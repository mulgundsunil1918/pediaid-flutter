// =============================================================================
// lib/screens/guides/developmental_milestones/tdsc/tdsc_engine.dart
//
// Pure-Dart interpretation engine for the Trivandrum Developmental
// Screening Chart. No widgets, no Material — just clinical logic the
// UI binds to.
//
// Bucket logic (the "vertical line at child's age" rule, made strict):
//
//   • EXPECTED  — bar lies entirely to the LEFT of the age line
//                 (item.ageEnd <= age). The child SHOULD already be
//                 doing it. This is the only bucket whose failure
//                 makes the screen positive.
//   • EMERGING  — bar intersects the age line (ageStart <= age <= ageEnd).
//                 The skill is normally appearing right now; failure
//                 here is not a delay yet.
//   • FUTURE    — bar lies entirely to the RIGHT (ageStart > age).
//                 The child is too young to expect it.
//
// Screen rule (Nair / TDSC manual, restated):
//   Any milestone in the EXPECTED bucket marked as Not Achieved
//   constitutes screen-positive — refer for formal assessment.
// =============================================================================

import 'tdsc_data.dart';

enum TdscStatus { notTested, achieved, notAchieved }

enum TdscBucket { expected, emerging, future }

enum TdscRisk { low, mild, moderate, high }

extension TdscRiskMeta on TdscRisk {
  String get label => switch (this) {
        TdscRisk.low => 'LOW RISK',
        TdscRisk.mild => 'MILD CONCERN',
        TdscRisk.moderate => 'MODERATE CONCERN',
        TdscRisk.high => 'HIGH RISK',
      };
}

class TdscInterpretation {
  final double ageMonths;
  final List<TdscItem> expected;
  final List<TdscItem> emerging;
  final List<TdscItem> future;
  final List<TdscItem> achieved; // any bucket, status = achieved
  final List<TdscItem> delayed; // expected ∩ notAchieved
  final List<TdscItem> needsAssessment; // expected ∩ notTested
  final Set<TdscDomain> affectedDomains;
  final TdscRisk risk;
  final bool screenPositive;
  final String headline;
  final String oneLineInterpretation;
  final List<String> recommendations;

  const TdscInterpretation({
    required this.ageMonths,
    required this.expected,
    required this.emerging,
    required this.future,
    required this.achieved,
    required this.delayed,
    required this.needsAssessment,
    required this.affectedDomains,
    required this.risk,
    required this.screenPositive,
    required this.headline,
    required this.oneLineInterpretation,
    required this.recommendations,
  });
}

/// Compute bucket for a single item at [ageMonths].
TdscBucket bucketFor(TdscItem item, double ageMonths) {
  if (item.ageEnd < ageMonths) return TdscBucket.expected;
  if (item.ageStart > ageMonths) return TdscBucket.future;
  return TdscBucket.emerging;
}

/// Pull current status for an item from the answers map.
TdscStatus statusFor(TdscItem item, Map<int, TdscStatus> answers) =>
    answers[stableId(item)] ?? TdscStatus.notTested;

TdscInterpretation interpretTdsc({
  required double ageMonths,
  required Map<int, TdscStatus> answers,
}) {
  final expected = <TdscItem>[];
  final emerging = <TdscItem>[];
  final future = <TdscItem>[];
  final achieved = <TdscItem>[];
  final delayed = <TdscItem>[];
  final needsAssessment = <TdscItem>[];

  for (final it in kTdscAll) {
    final b = bucketFor(it, ageMonths);
    final s = statusFor(it, answers);
    switch (b) {
      case TdscBucket.expected:
        expected.add(it);
      case TdscBucket.emerging:
        emerging.add(it);
      case TdscBucket.future:
        future.add(it);
    }
    if (s == TdscStatus.achieved) achieved.add(it);
    if (b == TdscBucket.expected && s == TdscStatus.notAchieved) {
      delayed.add(it);
    }
    if (b == TdscBucket.expected && s == TdscStatus.notTested) {
      needsAssessment.add(it);
    }
  }

  final affectedDomains = delayed.map((e) => e.domain).toSet();

  TdscRisk risk;
  if (delayed.isEmpty) {
    risk = TdscRisk.low;
  } else if (delayed.length == 1) {
    risk = TdscRisk.mild;
  } else if (delayed.length <= 3 && affectedDomains.length <= 2) {
    risk = TdscRisk.moderate;
  } else {
    risk = TdscRisk.high;
  }

  final screenPositive = delayed.isNotEmpty;

  String headline;
  String oneLine;
  List<String> recs;

  if (expected.isEmpty) {
    headline = 'Set the age to begin screening';
    oneLine =
        'No milestones are expected at this age yet. Adjust the age slider above the chart.';
    recs = const [];
  } else if (delayed.isNotEmpty) {
    headline = 'Suspect developmental delay';
    final domainNames = affectedDomains
        .map((d) => kTdscDomainInfo[d]!.shortLabel)
        .join(' · ');
    oneLine = delayed.length == 1
        ? '1 milestone past its acquisition window has not been achieved (${delayed.first.name}). Domain: $domainNames.'
        : '${delayed.length} milestones past their acquisition windows have not been achieved. Affected domain${affectedDomains.length == 1 ? '' : 's'}: $domainNames.';
    recs = [
      'Refer for formal developmental assessment (Bayley III / DASII / Vineland).',
      'Pediatric neurology / developmental paediatrician evaluation.',
      'Consider hearing & vision screening if not already done.',
      if (affectedDomains.length >= 2)
        'Multi-domain delay — early-intervention referral is warranted now, do not wait to repeat the screen.'
      else
        'Repeat the screen at the next routine visit; if still positive, escalate.',
    ];
  } else if (needsAssessment.isNotEmpty) {
    headline = 'Assessment incomplete';
    oneLine =
        '${needsAssessment.length} expected milestone${needsAssessment.length == 1 ? '' : 's'} ${needsAssessment.length == 1 ? 'has' : 'have'} not been tested yet. Mark each ACHIEVED or NOT ACHIEVED to complete the screen.';
    recs = const [
      'Elicit each untested expected milestone before concluding the screen.',
      'Parent-report is acceptable for clearly remembered behaviours.',
    ];
  } else {
    headline = 'Screen negative — development on track';
    oneLine =
        'All ${expected.length} milestones expected by ${ageMonths.toStringAsFixed(0)} mo have been achieved. No items are past their acquisition window unmet.';
    recs = const [
      'Reassess at the next routine well-child visit.',
      'Continue surveillance — TDSC is a screen, not a one-off clearance.',
    ];
  }

  return TdscInterpretation(
    ageMonths: ageMonths,
    expected: expected,
    emerging: emerging,
    future: future,
    achieved: achieved,
    delayed: delayed,
    needsAssessment: needsAssessment,
    affectedDomains: affectedDomains,
    risk: risk,
    screenPositive: screenPositive,
    headline: headline,
    oneLineInterpretation: oneLine,
    recommendations: recs,
  );
}

/// Apply preterm correction: returns the age at which the screen should
/// be applied for an infant born at [gaWeeks] gestation, given a
/// chronological age in months. Correction stops being applied after
/// 24 mo chronological age.
double correctedAgeMonths({
  required double chronologicalMonths,
  required int gaWeeks,
  required bool correctionEnabled,
}) {
  if (!correctionEnabled) return chronologicalMonths;
  if (chronologicalMonths > 24) return chronologicalMonths;
  if (gaWeeks >= 40) return chronologicalMonths;
  final corrMonths = (40 - gaWeeks) / 4.0;
  final corrected = chronologicalMonths - corrMonths;
  return corrected.clamp(0.0, 72.0);
}
