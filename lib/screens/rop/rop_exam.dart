// =============================================================================
// rop/rop_exam.dart
//
// ICROP-3 findings for one eye, and the classification/treatment logic built
// on top of them.
//
// FOUR RULES FROM THE SPEC SHAPE THIS FILE
//
// §2, §45  "Unknown" is a real value, not an absence. Every finding enum has
//          an `unknown` member and every conclusion has a `cannotDetermine`
//          state. If plus status is unknown, the answer is "cannot determine",
//          never "no treatment-level disease" — that is exactly the false
//          reassurance the spec forbids for a sight-threatening disease.
//
// §27      "Do not create an oversimplified numerical score that replaces
//          clinical classification." Worst-eye selection therefore compares
//          findings in clinical order and REPORTS WHICH ONE decided it,
//          rather than summing severities into a number.
//
// §28      "Do not hard-code one treatment table for all countries." The Type
//          1 / Type 2 rules live in [TreatmentRuleSet] on the protocol, not in
//          this file's control flow.
//
// §30      Stage 4/5 and aggressive ROP get their own urgent states. They are
//          not folded into "treatment-level disease", because the action they
//          demand is different and more immediate.
// =============================================================================

/// ICROP-3 zone. Lower is more posterior and more serious.
enum RopZone { unknown, zoneI, zoneII, zoneIII }

/// ICROP-3 stage of acute ROP.
enum RopStage { unknown, none, stage1, stage2, stage3, stage4A, stage4B, stage5 }

/// Posterior vascular status.
enum PlusStatus { unknown, none, preplus, plus }

extension RopZoneX on RopZone {
  String get label => switch (this) {
        RopZone.zoneI => 'Zone I',
        RopZone.zoneII => 'Zone II',
        RopZone.zoneIII => 'Zone III',
        RopZone.unknown => 'Zone not recorded',
      };

  /// Severity rank; higher is worse. Unknown ranks LOW so it can never win a
  /// worst-eye comparison on its own — an unrecorded zone is handled by the
  /// completeness check, not by pretending it is severe.
  int get rank => switch (this) {
        RopZone.zoneI => 3,
        RopZone.zoneII => 2,
        RopZone.zoneIII => 1,
        RopZone.unknown => 0,
      };
}

extension RopStageX on RopStage {
  String get label => switch (this) {
        RopStage.none => 'No ROP',
        RopStage.stage1 => 'Stage 1',
        RopStage.stage2 => 'Stage 2',
        RopStage.stage3 => 'Stage 3',
        RopStage.stage4A => 'Stage 4A',
        RopStage.stage4B => 'Stage 4B',
        RopStage.stage5 => 'Stage 5',
        RopStage.unknown => 'Stage not recorded',
      };

  int get rank => switch (this) {
        RopStage.none => 0,
        RopStage.stage1 => 1,
        RopStage.stage2 => 2,
        RopStage.stage3 => 3,
        RopStage.stage4A => 4,
        RopStage.stage4B => 5,
        RopStage.stage5 => 6,
        RopStage.unknown => 0,
      };

  /// Stage 4 and 5 are retinal detachment — a different urgency from
  /// treatment-level acute ROP (spec §30).
  bool get isDetachment =>
      this == RopStage.stage4A ||
      this == RopStage.stage4B ||
      this == RopStage.stage5;
}

extension PlusStatusX on PlusStatus {
  String get label => switch (this) {
        PlusStatus.none => 'no plus disease',
        PlusStatus.preplus => 'pre-plus disease',
        PlusStatus.plus => 'plus disease',
        PlusStatus.unknown => 'plus status not recorded',
      };

  int get rank => switch (this) {
        PlusStatus.plus => 2,
        PlusStatus.preplus => 1,
        PlusStatus.none => 0,
        PlusStatus.unknown => 0,
      };
}

/// Findings for a single eye.
class EyeFindings {
  final RopZone zone;
  final RopStage stage;
  final PlusStatus plus;

  /// Extent in clock hours, 0–12. Null when not recorded.
  final int? clockHours;

  /// Aggressive ROP (spec §22) — flat, rapidly progressive disease that does
  /// not pass through the usual stages, so it is recorded separately.
  final bool aggressive;

  /// ROP notch (spec §25).
  final bool notch;

  const EyeFindings({
    this.zone = RopZone.unknown,
    this.stage = RopStage.unknown,
    this.plus = PlusStatus.unknown,
    this.clockHours,
    this.aggressive = false,
    this.notch = false,
  });

  /// True when the three findings needed to classify are all recorded.
  ///
  /// Extent and notch are descriptive and do not gate classification; zone,
  /// stage and plus do.
  bool get isComplete =>
      zone != RopZone.unknown &&
      stage != RopStage.unknown &&
      plus != PlusStatus.unknown;

  List<String> get missing => [
        if (zone == RopZone.unknown) 'Zone',
        if (stage == RopStage.unknown) 'Stage',
        if (plus == PlusStatus.unknown) 'Plus status',
      ];

  bool get hasAnyFinding =>
      zone != RopZone.unknown ||
      stage != RopStage.unknown ||
      plus != PlusStatus.unknown ||
      aggressive ||
      notch;

  /// Spec §26 — the standardised sentence, in ICROP-3 order.
  String describe() {
    if (!hasAnyFinding) return 'No findings recorded.';
    if (aggressive) {
      final parts = <String>[
        if (zone != RopZone.unknown) zone.label,
        'aggressive ROP',
        if (clockHours != null) '$clockHours clock hours',
      ];
      return '${parts.join(', ')}.';
    }
    if (stage == RopStage.none && zone != RopZone.unknown) {
      return 'No ROP, vascularisation to ${zone.label}.';
    }
    final parts = <String>[
      zone.label,
      stage.label,
      plus.label,
      if (clockHours != null) '$clockHours clock hours',
      if (notch) 'notch present',
    ];
    return '${parts.join(', ')}.';
  }
}

/// Which findings drive treatment, per protocol (spec §28).
class TreatmentRule {
  final String id;
  final String description;
  final RopZone? zone;

  /// Stages this rule applies to. Empty means any stage.
  final List<RopStage> stages;

  /// Plus statuses required. Empty means plus is irrelevant to this rule.
  final List<PlusStatus> plus;

  const TreatmentRule({
    required this.id,
    required this.description,
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

/// Type 1 and Type 2 definitions for one protocol.
class TreatmentRuleSet {
  final List<TreatmentRule> type1;
  final List<TreatmentRule> type2;
  final String source;

  const TreatmentRuleSet({
    required this.type1,
    required this.type2,
    required this.source,
  });
}

/// ETROP Type 1 / Type 2, the basis most protocols reference.
///
/// ⚠️ DRAFT until clinically verified (spec §73).
const etropRules = TreatmentRuleSet(
  source: 'ETROP — Early Treatment for Retinopathy of Prematurity Cooperative '
      'Group. Arch Ophthalmol 2003. Verify against the protocol in use.',
  type1: [
    TreatmentRule(
      id: 'z1-plus',
      description: 'Zone I, any stage, with plus disease',
      zone: RopZone.zoneI,
      plus: [PlusStatus.plus],
    ),
    TreatmentRule(
      id: 'z1-s3',
      description: 'Zone I, Stage 3, with or without plus disease',
      zone: RopZone.zoneI,
      stages: [RopStage.stage3],
    ),
    TreatmentRule(
      id: 'z2-s2s3-plus',
      description: 'Zone II, Stage 2 or 3, with plus disease',
      zone: RopZone.zoneII,
      stages: [RopStage.stage2, RopStage.stage3],
      plus: [PlusStatus.plus],
    ),
  ],
  type2: [
    TreatmentRule(
      id: 'z1-s12-noplus',
      description: 'Zone I, Stage 1 or 2, without plus disease',
      zone: RopZone.zoneI,
      stages: [RopStage.stage1, RopStage.stage2],
      plus: [PlusStatus.none, PlusStatus.preplus],
    ),
    TreatmentRule(
      id: 'z2-s3-noplus',
      description: 'Zone II, Stage 3, without plus disease',
      zone: RopZone.zoneII,
      stages: [RopStage.stage3],
      plus: [PlusStatus.none, PlusStatus.preplus],
    ),
  ],
);

/// Outcome of the treatment question (spec §28, §29).
enum RopType { cannotClassify, type1, type2, neither }

/// Urgency, in the states spec §30 names.
enum RopUrgency { none, urgentTreatment, urgentAggressive, urgentDetachment }

class EyeClassification {
  final EyeFindings findings;
  final RopType type;
  final RopUrgency urgency;

  /// The rule or finding that produced [type] — spec §29 requires showing it.
  final String? reason;

  /// Findings not recorded, when [type] is cannotClassify.
  final List<String> missing;

  const EyeClassification({
    required this.findings,
    required this.type,
    required this.urgency,
    this.reason,
    this.missing = const [],
  });

  bool get isUrgent => urgency != RopUrgency.none;
}

/// Classifies one eye against a protocol's treatment rules.
EyeClassification classifyEye(EyeFindings e, TreatmentRuleSet rules) {
  // Detachment and aggressive ROP are urgent regardless of how much else is
  // recorded — waiting for a complete dataset before flagging a Stage 5 eye
  // would be absurd, and spec §30 gives each its own warning.
  if (e.stage.isDetachment) {
    return EyeClassification(
      findings: e,
      type: RopType.type1,
      urgency: RopUrgency.urgentDetachment,
      reason: '${e.stage.label} — retinal detachment',
    );
  }
  if (e.aggressive) {
    return EyeClassification(
      findings: e,
      type: RopType.type1,
      urgency: RopUrgency.urgentAggressive,
      reason: 'Aggressive ROP',
    );
  }

  // Everything else needs zone, stage and plus. Missing any of them means we
  // do not know — never "no treatment-level disease" (spec §2, §45).
  if (!e.isComplete) {
    return EyeClassification(
      findings: e,
      type: RopType.cannotClassify,
      urgency: RopUrgency.none,
      missing: e.missing,
    );
  }

  if (e.stage == RopStage.none) {
    return EyeClassification(
      findings: e,
      type: RopType.neither,
      urgency: RopUrgency.none,
      reason: 'No ROP recorded in ${e.zone.label}',
    );
  }

  for (final r in rules.type1) {
    if (r.matches(e)) {
      return EyeClassification(
        findings: e,
        type: RopType.type1,
        urgency: RopUrgency.urgentTreatment,
        reason: r.description,
      );
    }
  }
  for (final r in rules.type2) {
    if (r.matches(e)) {
      return EyeClassification(
        findings: e,
        type: RopType.type2,
        urgency: RopUrgency.none,
        reason: r.description,
      );
    }
  }

  return EyeClassification(
    findings: e,
    type: RopType.neither,
    urgency: RopUrgency.none,
    reason: '${e.zone.label} ${e.stage.label}, ${e.plus.label}',
  );
}

/// Which eye is worse, and WHY (spec §27 — no composite score).
class WorstEye {
  /// 'Right', 'Left', or 'Both equal'.
  final String eye;

  /// The single finding that decided it, in clinical order.
  final String reason;

  const WorstEye(this.eye, this.reason);
}

/// Compares eyes on clinical features in order of weight, and reports the
/// first that separates them. Deliberately NOT a sum: spec §27 forbids a
/// number standing in for the classification.
WorstEye worseEye(EyeFindings right, EyeFindings left) {
  if (right.stage.isDetachment != left.stage.isDetachment) {
    final r = right.stage.isDetachment;
    return WorstEye(r ? 'Right' : 'Left',
        'retinal detachment (${(r ? right : left).stage.label})');
  }
  if (right.aggressive != left.aggressive) {
    return WorstEye(right.aggressive ? 'Right' : 'Left', 'aggressive ROP');
  }
  if (right.plus.rank != left.plus.rank) {
    final r = right.plus.rank > left.plus.rank;
    return WorstEye(r ? 'Right' : 'Left', (r ? right : left).plus.label);
  }
  if (right.zone.rank != left.zone.rank) {
    // Higher rank is MORE posterior, which is more serious.
    final r = right.zone.rank > left.zone.rank;
    return WorstEye(r ? 'Right' : 'Left',
        'more posterior disease (${(r ? right : left).zone.label})');
  }
  if (right.stage.rank != left.stage.rank) {
    final r = right.stage.rank > left.stage.rank;
    return WorstEye(r ? 'Right' : 'Left', 'higher stage (${(r ? right : left).stage.label})');
  }
  final rh = right.clockHours ?? 0, lh = left.clockHours ?? 0;
  if (rh != lh) {
    final r = rh > lh;
    return WorstEye(r ? 'Right' : 'Left', 'greater extent (${r ? rh : lh} clock hours)');
  }
  return const WorstEye('Both equal', 'findings are the same in both eyes');
}

/// The whole-infant conclusion for one examination.
class ExamAssessment {
  final EyeClassification right;
  final EyeClassification left;
  final WorstEye worst;

  /// The more urgent of the two eyes — this drives the banner.
  final RopUrgency urgency;

  /// The more severe type across both eyes.
  final RopType type;

  /// Why [type] was reached, naming the eye.
  final String? reason;

  /// True when either eye lacks a finding needed to classify.
  final bool incomplete;

  const ExamAssessment({
    required this.right,
    required this.left,
    required this.worst,
    required this.urgency,
    required this.type,
    this.reason,
    this.incomplete = false,
  });
}

/// Assesses both eyes together.
ExamAssessment assessExam(
  EyeFindings right,
  EyeFindings left,
  TreatmentRuleSet rules,
) {
  final r = classifyEye(right, rules);
  final l = classifyEye(left, rules);

  // Urgency takes the worst of the two, in the order spec §30 lists them.
  RopUrgency urg = RopUrgency.none;
  for (final u in [
    RopUrgency.urgentDetachment,
    RopUrgency.urgentAggressive,
    RopUrgency.urgentTreatment,
  ]) {
    if (r.urgency == u || l.urgency == u) {
      urg = u;
      break;
    }
  }

  // Type takes the more severe, EXCEPT that an unclassifiable eye cannot be
  // overridden into reassurance by a normal fellow eye. If one eye is
  // incomplete and the other is not type 1, the honest answer is "cannot
  // classify" — the unexamined eye is the one that might be blind.
  final incomplete =
      r.type == RopType.cannotClassify || l.type == RopType.cannotClassify;

  RopType type;
  String? reason;
  if (r.type == RopType.type1 || l.type == RopType.type1) {
    final worse = r.type == RopType.type1 ? r : l;
    type = RopType.type1;
    reason = '${r.type == RopType.type1 ? 'Right' : 'Left'} eye: ${worse.reason}';
  } else if (incomplete) {
    type = RopType.cannotClassify;
    final side = r.type == RopType.cannotClassify ? r : l;
    reason = 'Incomplete examination — '
        '${r.type == RopType.cannotClassify ? 'right' : 'left'} eye missing '
        '${side.missing.join(', ').toLowerCase()}';
  } else if (r.type == RopType.type2 || l.type == RopType.type2) {
    final worse = r.type == RopType.type2 ? r : l;
    type = RopType.type2;
    reason = '${r.type == RopType.type2 ? 'Right' : 'Left'} eye: ${worse.reason}';
  } else {
    type = RopType.neither;
    reason = r.reason ?? l.reason;
  }

  return ExamAssessment(
    right: r,
    left: l,
    worst: worseEye(right, left),
    urgency: urg,
    type: type,
    reason: reason,
    incomplete: incomplete,
  );
}
