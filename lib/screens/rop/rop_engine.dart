// =============================================================================
// rop/rop_engine.dart
//
// Screening eligibility and first-examination timing. Pure functions over
// [RopProtocol] data — no UI, no protocol names hardcoded, fully testable.
//
// THREE RULES FROM THE SPEC SHAPE THIS FILE
//
// §8  "Do not simply display 'Eligible'." Every result carries the list of
//     criteria that fired, in the protocol's own words. A conclusion the
//     clinician cannot audit is not decision support.
//
// §55 "Do not create a black-box score." There is no score here at all —
//     eligibility is a set of named reasons, and timing is a named rule.
//
// §2 and §45  Incomplete input must NEVER conclude that screening is not
//     needed. [ScreeningStatus.insufficientData] exists so that "we do not
//     know" has somewhere to go that is not "no". Returning `notIndicated`
//     when gestational age is missing would be false reassurance about a
//     time-critical, sight-threatening disease.
// =============================================================================

import 'rop_protocol.dart';

/// Outcome of the eligibility question. Deliberately NOT a boolean.
enum ScreeningStatus {
  /// Protocol criteria not met and no risk factors selected.
  notIndicated,

  /// At least one criterion met.
  indicated,

  /// Met, and the first-examination window has already passed.
  overdue,

  /// Met, and the examination is due today or inside the window.
  dueNow,

  /// Not enough information to decide. Never means "no".
  insufficientData,
}

/// Postmenstrual age — gestational age plus postnatal age.
class Pma {
  final int weeks;
  final int days;
  const Pma(this.weeks, this.days);

  int get totalDays => weeks * 7 + days;

  /// Spec §48 — display as "32+4 weeks", the form clinicians write.
  @override
  String toString() => '$weeks+$days';
}

/// What the engine concluded, and why.
class ScreeningResult {
  final ScreeningStatus status;

  /// Human-readable reasons this infant qualified, in protocol wording.
  final List<String> reasons;

  /// Which inputs were missing, when [status] is insufficientData.
  final List<String> missing;

  /// Postmenstrual age now, when it could be computed.
  final Pma? pma;

  /// Day of life now.
  final int? postnatalDays;

  /// First-examination window in days of life, when the protocol expresses it
  /// that way; otherwise the computed target date drives the message.
  final int? windowFromDay;
  final int? windowToDay;

  /// Days until the window opens (negative when overdue).
  final int? daysUntilDue;

  /// True when the infant falls into the protocol's named early pathway.
  final bool earlyPathway;

  /// The rule that produced the timing, for the audit trail.
  final String? timingRule;

  const ScreeningResult({
    required this.status,
    this.reasons = const [],
    this.missing = const [],
    this.pma,
    this.postnatalDays,
    this.windowFromDay,
    this.windowToDay,
    this.daysUntilDue,
    this.earlyPathway = false,
    this.timingRule,
  });

  bool get isIndicated =>
      status == ScreeningStatus.indicated ||
      status == ScreeningStatus.dueNow ||
      status == ScreeningStatus.overdue;
}

/// Everything the engine needs about the infant.
class RopPatient {
  /// Completed weeks of gestation at birth.
  final int? gaWeeks;

  /// Extra days beyond [gaWeeks], 0–6.
  final int? gaDays;

  final int? birthWeightG;
  final DateTime? birthDate;
  final DateTime? assessmentDate;

  /// Risk factors the clinician selected, from the protocol's own list.
  final List<String> riskFactors;

  /// Set when the clinician judges the infant high risk regardless of numbers
  /// (spec §8 criterion 4).
  final bool clinicianConcern;

  const RopPatient({
    this.gaWeeks,
    this.gaDays,
    this.birthWeightG,
    this.birthDate,
    this.assessmentDate,
    this.riskFactors = const [],
    this.clinicianConcern = false,
  });

  int? get gaTotalDays =>
      gaWeeks == null ? null : gaWeeks! * 7 + (gaDays ?? 0);
}

/// Whole days between two dates, ignoring time of day so a record made at
/// 23:00 and one at 01:00 are still one day apart (spec §47).
int daysBetween(DateTime from, DateTime to) {
  final a = DateTime(from.year, from.month, from.day);
  final b = DateTime(to.year, to.month, to.day);
  return b.difference(a).inDays;
}

/// Postmenstrual age = gestational age at birth + postnatal age.
Pma? computePma(RopPatient p) {
  final ga = p.gaTotalDays;
  if (ga == null || p.birthDate == null) return null;
  final now = p.assessmentDate ?? DateTime.now();
  final postnatal = daysBetween(p.birthDate!, now);
  if (postnatal < 0) return null; // birth date in the future — caller validates
  final total = ga + postnatal;
  return Pma(total ~/ 7, total % 7);
}

/// Evaluates screening eligibility and first-examination timing.
ScreeningResult evaluateScreening(RopPatient p, RopProtocol protocol) {
  // ── Completeness first ────────────────────────────────────────────────────
  // A missing gestational age or birth weight cannot be read as "does not
  // meet the threshold" — that is the false-reassurance failure §2 forbids.
  final missing = <String>[
    if (p.gaWeeks == null) 'Gestational age at birth',
    if (p.birthWeightG == null) 'Birth weight',
    if (p.birthDate == null) 'Date of birth',
  ];
  if (missing.isNotEmpty) {
    return ScreeningResult(
      status: ScreeningStatus.insufficientData,
      missing: missing,
    );
  }

  final now = p.assessmentDate ?? DateTime.now();
  if (daysBetween(p.birthDate!, now) < 0) {
    return const ScreeningResult(
      status: ScreeningStatus.insufficientData,
      missing: ['Date of birth is after the assessment date'],
    );
  }

  // ── Which criteria fired ──────────────────────────────────────────────────
  final reasons = <String>[];
  for (final c in protocol.criteria) {
    // "less than 34 weeks" excludes 34+0; "32 weeks or less" includes 32+6.
    // Completed weeks, so strictBelow drops the whole boundary week.
    if (c.gaMaxWeeks != null &&
        (c.strictBelow
            ? p.gaWeeks! < c.gaMaxWeeks!
            : p.gaWeeks! <= c.gaMaxWeeks!)) {
      reasons.add('${c.label} — this infant ${p.gaWeeks}+${p.gaDays ?? 0}');
    } else if (c.birthWeightMaxG != null &&
        (c.strictBelow
            ? p.birthWeightG! < c.birthWeightMaxG!
            : p.birthWeightG! <= c.birthWeightMaxG!)) {
      reasons.add('${c.label} — this infant ${p.birthWeightG} g');
    } else if (c.riskFactorBased) {
      if (c.id == 'discretion') {
        if (p.clinicianConcern) reasons.add(c.label);
      } else if (p.riskFactors.isNotEmpty) {
        reasons.add('${c.label}: ${p.riskFactors.join(', ')}');
      }
    }
  }

  if (reasons.isEmpty) {
    return ScreeningResult(
      status: ScreeningStatus.notIndicated,
      pma: computePma(p),
      postnatalDays: daysBetween(p.birthDate!, now),
    );
  }

  // ── Timing ────────────────────────────────────────────────────────────────
  final postnatal = daysBetween(p.birthDate!, now);
  final pma = computePma(p);

  final early = (protocol.earlyPathwayGaMaxWeeks != null &&
          p.gaWeeks! <= protocol.earlyPathwayGaMaxWeeks!) ||
      (protocol.earlyPathwayBirthWeightMaxG != null &&
          p.birthWeightG! <= protocol.earlyPathwayBirthWeightMaxG!);

  final rule = protocol.firstExamRules
      .cast<FirstExamRule?>()
      .firstWhere((r) => r!.coversGaWeeks(p.gaWeeks!), orElse: () => null);

  int? from, to, until;
  String? timingRule;

  if (rule != null) {
    if (protocol.firstExamBasis == FirstExamBasis.postnatalDays) {
      from = rule.dayFrom;
      to = rule.dayTo;
      timingRule = 'Day $from–$to of life';
    } else {
      // The later of the PMA target and the chronological target, expressed
      // back in days of life so every protocol reports one comparable number.
      final byPma = rule.pmaWeeks == null
          ? null
          : rule.pmaWeeks! * 7 - p.gaTotalDays!;
      final byAge =
          rule.chronologicalWeeks == null ? null : rule.chronologicalWeeks! * 7;
      final target = [byPma, byAge].whereType<int>().fold<int?>(
          null, (a, b) => a == null ? b : (b > a ? b : a));
      if (target != null) {
        from = target;
        to = target;
        timingRule = [
          if (rule.pmaWeeks != null) '${rule.pmaWeeks} weeks PMA',
          if (rule.chronologicalWeeks != null)
            '${rule.chronologicalWeeks} weeks chronological age',
        ].join(' or ') + (byPma != null && byAge != null ? ', whichever is later' : '');
      }
    }
  }

  ScreeningStatus status = ScreeningStatus.indicated;
  if (from != null && to != null) {
    until = from - postnatal;
    if (postnatal > to) {
      status = ScreeningStatus.overdue;
    } else if (postnatal >= from) {
      status = ScreeningStatus.dueNow;
    }
  }

  return ScreeningResult(
    status: status,
    reasons: reasons,
    pma: pma,
    postnatalDays: postnatal,
    windowFromDay: from,
    windowToDay: to,
    daysUntilDue: until,
    earlyPathway: early,
    timingRule: timingRule,
  );
}
