// =============================================================================
// rop/rop_followup.dart
//
// Follow-up intervals, post-treatment surveillance, and termination of
// screening.
//
// FOUR RULES FROM THE SPEC SHAPE THIS FILE
//
// §31  "Do not invent intervals." Intervals are protocol data, matched by
//      findings. This file decides WHICH rule applies; the rule itself carries
//      the number.
//
// §34  "Do not use the untreated ROP follow-up algorithm after treatment."
//      Post-treatment is a separate branch taken before anything else, not a
//      modifier on the normal path.
//
// §36  An anti-VEGF-treated infant is not discharged merely because acute ROP
//      regressed — late reactivation is the whole reason these babies are
//      watched for longer.
//
// §39  "No ROP today" must never terminate screening on its own. Vascular
//      maturity is a separate question from disease activity, and the
//      termination logic asks it separately.
// =============================================================================

import 'rop_exam.dart';

/// How urgently the next examination is needed. The spec's own vocabulary
/// (§31), not free text, so the UI cannot drift from the protocol.
enum FollowUpInterval {
  withinOneWeek,
  oneToTwoWeeks,
  twoWeeks,
  twoToThreeWeeks,
  longerInterval,
  treatmentFollowUp,
  terminationAssessment,
  urgentAssessment,
  cannotDetermine,
}

extension FollowUpIntervalX on FollowUpInterval {
  String get label => switch (this) {
        FollowUpInterval.withinOneWeek => 'within 1 week',
        FollowUpInterval.oneToTwoWeeks => '1–2 weeks',
        FollowUpInterval.twoWeeks => '2 weeks',
        FollowUpInterval.twoToThreeWeeks => '2–3 weeks',
        FollowUpInterval.longerInterval => 'longer interval per protocol',
        FollowUpInterval.treatmentFollowUp => 'post-treatment follow-up',
        FollowUpInterval.terminationAssessment => 'termination assessment',
        FollowUpInterval.urgentAssessment => 'urgent specialist assessment',
        FollowUpInterval.cannotDetermine => 'cannot determine',
      };

  /// Upper bound in days, used to compute a next-examination DATE.
  ///
  /// Null where naming a date would be dishonest — "within 1 week" is a
  /// deadline, not an appointment, and §32 says not to imply an exact mandated
  /// date. The UI shows "within 7 days" for those instead.
  int? get maxDays => switch (this) {
        FollowUpInterval.withinOneWeek => 7,
        FollowUpInterval.oneToTwoWeeks => 14,
        FollowUpInterval.twoWeeks => 14,
        FollowUpInterval.twoToThreeWeeks => 21,
        FollowUpInterval.longerInterval => null,
        FollowUpInterval.treatmentFollowUp => null,
        FollowUpInterval.terminationAssessment => null,
        FollowUpInterval.urgentAssessment => null,
        FollowUpInterval.cannotDetermine => null,
      };

  /// True when the interval is a deadline rather than a target date.
  bool get isDeadline =>
      this == FollowUpInterval.withinOneWeek ||
      this == FollowUpInterval.urgentAssessment;
}

/// One protocol follow-up rule: findings in, interval out.
class FollowUpRule {
  final String id;
  final String description;
  final RopZone? zone;
  final List<RopStage> stages;
  final List<PlusStatus> plus;
  final FollowUpInterval interval;

  const FollowUpRule({
    required this.id,
    required this.description,
    required this.interval,
    this.zone,
    this.stages = const [],
    this.plus = const [],
  });

  bool matches(EyeFindings e) {
    if (zone != null && e.zone != zone) return false;
    if (stages.isNotEmpty && !stages.contains(e.stage)) return false;
    if (plus.isNotEmpty && !plus.contains(e.plus)) return false;
    return true;
  }
}

/// Follow-up schedule.
///
/// Transcribed from the AAP policy statement's suggested schedule (Pediatrics
/// 2006;117(2):572), checked 2026-08-26:
///
///   1 week or less — Zone I stage 1 or 2; Zone II stage 3
///   1 to 2 weeks   — Zone I immature, no ROP; Zone II stage 2; Zone I regressing
///   2 weeks        — Zone II stage 1; Zone II regressing
///   2 to 3 weeks   — Zone II immature, no ROP; Zone III stage 1 or 2;
///                    Zone III regressing
///
/// The RBSK 2017 guidance is compatible: an immature eye with no ROP is
/// examined "at least every other week until vessels reach zone III".
///
/// Ordered most-urgent first; the first match wins, so a rule inserted out of
/// order changes behaviour.
const ropFollowUpRules = <FollowUpRule>[
  FollowUpRule(
    id: 'z1-any',
    description: 'Zone I, stage 1 or 2 ROP',
    zone: RopZone.zoneI,
    // Stage 3 in Zone I is Type 1 disease and never reaches this table — the
    // urgency branch takes it first — but it is listed so the rule still
    // matches if the treatment rules are ever narrowed.
    stages: [RopStage.stage1, RopStage.stage2, RopStage.stage3],
    interval: FollowUpInterval.withinOneWeek,
  ),
  FollowUpRule(
    id: 'z1-immature',
    description: 'Zone I, immature vascularisation, no ROP',
    zone: RopZone.zoneI,
    stages: [RopStage.none],
    interval: FollowUpInterval.oneToTwoWeeks,
  ),
  FollowUpRule(
    id: 'z2-s3',
    description: 'Zone II, Stage 3',
    zone: RopZone.zoneII,
    stages: [RopStage.stage3],
    interval: FollowUpInterval.withinOneWeek,
  ),
  FollowUpRule(
    id: 'z2-s2',
    description: 'Zone II, Stage 2',
    zone: RopZone.zoneII,
    stages: [RopStage.stage2],
    interval: FollowUpInterval.oneToTwoWeeks,
  ),
  FollowUpRule(
    id: 'z2-s1',
    description: 'Zone II, Stage 1',
    zone: RopZone.zoneII,
    stages: [RopStage.stage1],
    interval: FollowUpInterval.twoWeeks,
  ),
  FollowUpRule(
    id: 'z2-none',
    description: 'Zone II, immature vascularisation, no ROP',
    zone: RopZone.zoneII,
    stages: [RopStage.none],
    // 2–3 weeks, not 2. The draft had this a week too short; AAP lists
    // "immature vascularization: zone II—no ROP" under 2- to 3-week follow-up.
    interval: FollowUpInterval.twoToThreeWeeks,
  ),
  FollowUpRule(
    id: 'z3-any',
    description: 'Zone III',
    zone: RopZone.zoneIII,
    interval: FollowUpInterval.twoToThreeWeeks,
  ),
];

// ── Treatment and post-treatment ─────────────────────────────────────────────

enum RopTreatment { none, laser, antiVegf, vitreoretinalSurgery, other, unknown }

extension RopTreatmentX on RopTreatment {
  String get label => switch (this) {
        RopTreatment.none => 'No treatment',
        RopTreatment.laser => 'Laser photocoagulation',
        RopTreatment.antiVegf => 'Anti-VEGF injection',
        RopTreatment.vitreoretinalSurgery => 'Vitreoretinal surgery',
        RopTreatment.other => 'Other treatment',
        RopTreatment.unknown => 'Treatment type not recorded',
      };
}

/// ICROP-3 regression (spec §37).
enum Regression { unknown, none, incomplete, complete }

/// ICROP-3 reactivation (spec §37).
enum Reactivation { no, suspected, yes }

/// Persistent peripheral avascular retina (spec §38).
enum AvascularRetina { unableToDetermine, no, suspected, yes }

class TreatmentRecord {
  final RopTreatment type;
  final DateTime? date;
  final String? agent;
  final Regression regression;
  final Reactivation reactivation;
  final AvascularRetina avascular;

  const TreatmentRecord({
    this.type = RopTreatment.none,
    this.date,
    this.agent,
    this.regression = Regression.unknown,
    this.reactivation = Reactivation.no,
    this.avascular = AvascularRetina.unableToDetermine,
  });

  bool get wasTreated =>
      type != RopTreatment.none && type != RopTreatment.unknown;
}

/// A follow-up recommendation with its justification.
class FollowUpResult {
  final FollowUpInterval interval;

  /// The rule or condition that produced it (spec §55 — nothing unexplained).
  final String reason;

  /// Target date, when naming one is honest. Null for deadlines and for
  /// intervals the protocol does not express in days.
  final DateTime? nextExamDate;

  /// Days from the examination date to [nextExamDate].
  final int? days;

  const FollowUpResult({
    required this.interval,
    required this.reason,
    this.nextExamDate,
    this.days,
  });
}

/// Recommends the next examination.
///
/// Order matters and is not arbitrary: reactivation, then urgency, then
/// post-treatment, then the routine rules. Spec §34 forbids running the
/// untreated algorithm on a treated infant, so that branch is taken before the
/// rule table is ever consulted.
FollowUpResult recommendFollowUp({
  required ExamAssessment assessment,
  required DateTime examDate,
  TreatmentRecord treatment = const TreatmentRecord(),
  List<FollowUpRule> rules = ropFollowUpRules,
}) {
  FollowUpResult build(FollowUpInterval i, String why) {
    final d = i.maxDays;
    return FollowUpResult(
      interval: i,
      reason: why,
      days: d,
      // A deadline gets no date — §32 says not to imply an exact mandated day.
      nextExamDate: (d == null || i.isDeadline)
          ? null
          : examDate.add(Duration(days: d)),
    );
  }

  // Spec §37 — reactivation overrides everything below it.
  if (treatment.reactivation == Reactivation.yes ||
      treatment.reactivation == Reactivation.suspected) {
    return build(
      FollowUpInterval.urgentAssessment,
      'ROP reactivation ${treatment.reactivation == Reactivation.yes ? 'documented' : 'suspected'} '
      '— specialist reassessment required.',
    );
  }

  if (assessment.urgency != RopUrgency.none) {
    return build(
      FollowUpInterval.urgentAssessment,
      switch (assessment.urgency) {
        RopUrgency.urgentDetachment =>
          'Retinal detachment — immediate vitreoretinal assessment.',
        RopUrgency.urgentAggressive =>
          'Aggressive ROP — immediate ROP specialist assessment.',
        _ => assessment.reason ??
            'Treatment-level disease — prompt ROP specialist assessment.',
      },
    );
  }

  // Spec §34 — a treated infant never uses the untreated table.
  if (treatment.wasTreated) {
    return build(
      FollowUpInterval.treatmentFollowUp,
      '${treatment.type.label} performed — follow the post-treatment schedule '
      'in the protocol you are using, not the routine interval.',
    );
  }

  if (assessment.incomplete) {
    return build(
      FollowUpInterval.cannotDetermine,
      assessment.reason ??
          'Examination incomplete — interval cannot be determined.',
    );
  }

  // Routine rules, applied to the WORSE eye. Following the better eye would
  // schedule around the healthier retina.
  final worst = assessment.worst.eye == 'Left'
      ? assessment.left.findings
      : assessment.right.findings;

  for (final r in rules) {
    if (r.matches(worst)) return build(r.interval, r.description);
  }

  return build(
    FollowUpInterval.cannotDetermine,
    'No protocol follow-up rule matches these findings.',
  );
}

// ── Termination (spec §39) ───────────────────────────────────────────────────

enum TerminationResult {
  canTerminate,
  continueSurveillance,
  specialistDecision,
  insufficientInformation,
}

class TerminationAssessment {
  final TerminationResult result;
  final String reason;
  const TerminationAssessment(this.result, this.reason);
}

/// Can screening stop?
///
/// Spec §39 is emphatic that "No ROP today" is never sufficient on its own —
/// absence of disease is not maturity of the retinal vasculature, and the two
/// questions are asked separately here.
TerminationAssessment assessTermination({
  required ExamAssessment assessment,
  required TreatmentRecord treatment,
  required bool fullVascularisationDocumented,
}) {
  if (assessment.urgency != RopUrgency.none) {
    return const TerminationAssessment(
      TerminationResult.continueSurveillance,
      'Active treatment-level or urgent disease — screening continues.',
    );
  }
  if (treatment.reactivation != Reactivation.no) {
    return const TerminationAssessment(
      TerminationResult.specialistDecision,
      'Reactivation documented or suspected — a specialist decides when '
      'surveillance ends.',
    );
  }
  // Spec §36 — anti-VEGF infants need prolonged surveillance regardless of
  // how quiet the retina looks today.
  if (treatment.type == RopTreatment.antiVegf) {
    return const TerminationAssessment(
      TerminationResult.specialistDecision,
      'Anti-VEGF treated — late reactivation is described, so surveillance is '
      'prolonged and ending it is a specialist decision.',
    );
  }
  if (treatment.avascular == AvascularRetina.yes ||
      treatment.avascular == AvascularRetina.suspected) {
    return const TerminationAssessment(
      TerminationResult.specialistDecision,
      'Persistent peripheral avascular retina — specialist decision required.',
    );
  }
  if (assessment.incomplete) {
    return const TerminationAssessment(
      TerminationResult.insufficientInformation,
      'Examination incomplete — screening cannot be stopped on missing data.',
    );
  }
  if (!fullVascularisationDocumented) {
    return const TerminationAssessment(
      TerminationResult.continueSurveillance,
      'Retinal vascularisation not documented as complete. "No ROP today" '
      'does not mean the retina is mature.',
    );
  }
  return const TerminationAssessment(
    TerminationResult.canTerminate,
    'Vascularisation documented as complete with no active disease — '
    'termination criteria met for the selected protocol. Confirm against the '
    'protocol and with the examining ophthalmologist.',
  );
}
