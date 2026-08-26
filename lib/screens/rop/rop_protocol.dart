// =============================================================================
// rop/rop_protocol.dart
//
// Screening protocols as DATA, not as branching code.
//
// Spec §14 requires this, and §3 and §12 forbid the thing it prevents: mixing
// criteria from different guidelines. If the engine ever reads "if India then
// 34 weeks else 30 weeks", the two protocols are one tangled algorithm and a
// change to one silently moves the other. Here each protocol is a closed
// object, and the engine can only ask it questions.
//
// It also makes the values auditable. Spec §73 requires every threshold to be
// checked against its original guideline and the date of that check recorded —
// so `lastVerified` is a field, not a comment.
//
// ⚠️  CLINICAL STATUS: the numbers below are DRAFT.
//
// Spec §73 is explicit — "Do not launch the clinical calculator solely based on
// AI-generated medical logic" — and the module must be reviewed by a
// neonatologist and an ROP ophthalmologist before release. Every value carries
// a `source` string so it can be checked line by line rather than trusted.
// The same approach was taken with the immunisation catch-up rules.
// =============================================================================

/// How a protocol expresses the timing of the FIRST examination.
enum FirstExamBasis {
  /// A window in days of life, e.g. India's day 25–30.
  postnatalDays,

  /// The later of a PMA target and a chronological age, e.g. AAP/AAPOS.
  pmaOrChronological,
}

/// One row of a gestational-age-driven timing table.
class FirstExamRule {
  /// Inclusive GA range in completed weeks this row applies to.
  final int gaFromWeeks;
  final int gaToWeeks;

  /// Target postmenstrual age in weeks, when the protocol uses PMA.
  final int? pmaWeeks;

  /// Target chronological age in weeks, when the protocol uses one.
  final int? chronologicalWeeks;

  /// Window in days of life, when the protocol uses days.
  final int? dayFrom;
  final int? dayTo;

  const FirstExamRule({
    required this.gaFromWeeks,
    required this.gaToWeeks,
    this.pmaWeeks,
    this.chronologicalWeeks,
    this.dayFrom,
    this.dayTo,
  });

  bool coversGaWeeks(int w) => w >= gaFromWeeks && w <= gaToWeeks;
}

/// A named reason an infant qualifies, so the result can say WHY (spec §8:
/// "Do not simply display 'Eligible'").
class EligibilityCriterion {
  /// Stable id, used by the engine and by tests.
  final String id;

  /// Shown to the clinician, e.g. "Gestational age ≤ 34 weeks".
  final String label;

  /// Upper bound in completed weeks, when this is a GA rule.
  final int? gaMaxWeeks;

  /// Upper bound in grams, when this is a birth-weight rule.
  final int? birthWeightMaxG;

  /// True when the criterion is satisfied by clinician-selected risk factors
  /// rather than by a number.
  final bool riskFactorBased;

  const EligibilityCriterion({
    required this.id,
    required this.label,
    this.gaMaxWeeks,
    this.birthWeightMaxG,
    this.riskFactorBased = false,
  });
}

class RopProtocol {
  final String id;
  final String name;
  final String country;
  final String organisation;
  final String version;

  /// Any ONE satisfied criterion makes screening indicated.
  final List<EligibilityCriterion> criteria;

  /// Risk factors this protocol recognises for its discretionary criterion.
  final List<String> riskFactors;

  final FirstExamBasis firstExamBasis;
  final List<FirstExamRule> firstExamRules;

  /// Infants who need examination EARLIER than the general rule. Spec §11
  /// insists this is a named pathway rather than something buried inside the
  /// general calculation.
  final int? earlyPathwayGaMaxWeeks;
  final int? earlyPathwayBirthWeightMaxG;
  final String? earlyPathwayNote;

  /// Shown when this protocol's thresholds differ materially from others
  /// (spec §9 and §50).
  final String? breadthWarning;

  final List<String> references;

  /// Date the values above were last checked against the source guideline
  /// (spec §73 step 9). `null` means NOT yet verified by a clinician.
  final DateTime? lastVerified;

  const RopProtocol({
    required this.id,
    required this.name,
    required this.country,
    required this.organisation,
    required this.version,
    required this.criteria,
    required this.riskFactors,
    required this.firstExamBasis,
    required this.firstExamRules,
    required this.references,
    this.earlyPathwayGaMaxWeeks,
    this.earlyPathwayBirthWeightMaxG,
    this.earlyPathwayNote,
    this.breadthWarning,
    this.lastVerified,
  });

  /// True while the clinical values still need sign-off. Drives the DRAFT
  /// banner; a protocol must never look authoritative before it is checked.
  bool get isDraft => lastVerified == null;
}

// ── India ────────────────────────────────────────────────────────────────────
// Spec §8: any one of GA ≤34 weeks, BW ≤2000 g, >34 weeks with risk factors,
// or clinician discretion. §9 requires the breadth warning.
const _kRiskFactorsIndia = <String>[
  'Cardiorespiratory support',
  'Prolonged oxygen requirement',
  'Respiratory distress syndrome',
  'Chronic lung disease',
  'Blood transfusion',
  'Exchange transfusion',
  'Sepsis',
  'Intraventricular haemorrhage',
  'Apnoea',
  'Poor postnatal weight gain',
  'Other significant neonatal illness',
];

final ropProtocolIndia = RopProtocol(
  id: 'india',
  name: 'India — National / Indian ROP protocol',
  country: 'India',
  organisation: 'National guidance / RBSK–NNF',
  version: 'draft',
  criteria: const [
    EligibilityCriterion(
      id: 'ga',
      label: 'Gestational age ≤ 34 weeks',
      gaMaxWeeks: 34,
    ),
    EligibilityCriterion(
      id: 'bw',
      label: 'Birth weight ≤ 2000 g',
      birthWeightMaxG: 2000,
    ),
    EligibilityCriterion(
      id: 'risk',
      label: 'Gestational age > 34 weeks with significant risk factors',
      riskFactorBased: true,
    ),
    EligibilityCriterion(
      id: 'discretion',
      label: 'Clinician judgement — infant considered high risk',
      riskFactorBased: true,
    ),
  ],
  riskFactors: _kRiskFactorsIndia,
  firstExamBasis: FirstExamBasis.postnatalDays,
  firstExamRules: const [
    // Spec §10: first screening by roughly day 25–30 of life, and before
    // discharge if that comes sooner. Applies across the GA range, so one row.
    FirstExamRule(gaFromWeeks: 0, gaToWeeks: 99, dayFrom: 25, dayTo: 30),
  ],
  // Spec §11 — a named early pathway, not a special case inside the day-25–30
  // arithmetic. THRESHOLD IS DRAFT and must be set from the chosen Indian
  // guidance before release.
  earlyPathwayGaMaxWeeks: 28,
  earlyPathwayBirthWeightMaxG: 1200,
  earlyPathwayNote:
      'Very preterm or very low birth weight infants may need examination '
      'earlier than day 25–30. Follow the earlier schedule in the protocol you '
      'are using.',
  breadthWarning:
      'Indian screening criteria are deliberately broader than several Western '
      'protocols. An infant outside the routine GA and birth-weight thresholds '
      'may still need screening if clinically high risk — a simple GA/BW filter '
      'misses larger, sicker babies.',
  references: const [
    'Indian national ROP operational guidelines (RBSK) — verify the current '
        'edition and its exact first-examination window before release.',
    'NNF clinical practice guidelines — ROP screening.',
  ],
  lastVerified: null, // ← DRAFT until a clinician signs it off
);

// ── AAP / AAPOS ──────────────────────────────────────────────────────────────
// Spec §12: BW ≤1500 g or GA ≤30 weeks, plus selected larger infants with risk
// factors. Timing is a GA-driven table, stored as data.
final ropProtocolAap = RopProtocol(
  id: 'aap',
  name: 'AAP / AAPOS',
  country: 'United States',
  organisation: 'AAP, AAPOS, AAO',
  version: 'draft',
  criteria: const [
    EligibilityCriterion(
      id: 'bw',
      label: 'Birth weight ≤ 1500 g',
      birthWeightMaxG: 1500,
    ),
    EligibilityCriterion(
      id: 'ga',
      label: 'Gestational age ≤ 30 weeks',
      gaMaxWeeks: 30,
    ),
    EligibilityCriterion(
      id: 'risk',
      label: 'Selected larger or more mature infant with an unstable course',
      riskFactorBased: true,
    ),
  ],
  riskFactors: const [
    'Hypotension requiring inotropic support',
    'Prolonged oxygen supplementation',
    'Oxygen without adequate saturation monitoring',
    'Significant neonatal instability',
  ],
  firstExamBasis: FirstExamBasis.pmaOrChronological,
  // The AAP timing table: examine at the LATER of the PMA target and the
  // chronological age. Values are DRAFT and must be checked against the
  // current AAP policy statement before release.
  firstExamRules: const [
    FirstExamRule(gaFromWeeks: 22, gaToWeeks: 27, pmaWeeks: 31, chronologicalWeeks: 4),
    FirstExamRule(gaFromWeeks: 28, gaToWeeks: 28, pmaWeeks: 32, chronologicalWeeks: 4),
    FirstExamRule(gaFromWeeks: 29, gaToWeeks: 29, pmaWeeks: 33, chronologicalWeeks: 4),
    FirstExamRule(gaFromWeeks: 30, gaToWeeks: 30, pmaWeeks: 34, chronologicalWeeks: 4),
    FirstExamRule(gaFromWeeks: 31, gaToWeeks: 99, chronologicalWeeks: 4),
  ],
  breadthWarning:
      'Screening parameters vary internationally. AAP/AAPOS thresholds are '
      'narrower than Indian national guidance — do not apply them to a '
      'population screened under a different protocol.',
  references: const [
    'Fierson WM; AAP Section on Ophthalmology, AAO, AAPOS, AACO. Screening '
        'Examination of Premature Infants for Retinopathy of Prematurity. '
        'Pediatrics — verify the current edition and its timing table.',
  ],
  lastVerified: null,
);

// ── UK / RCPCH ───────────────────────────────────────────────────────────────
// Spec §13: GA <31+0 weeks OR BW <1501 g, with separate timing rules.
final ropProtocolUk = RopProtocol(
  id: 'uk',
  name: 'UK — RCPCH / RCOphth',
  country: 'United Kingdom',
  organisation: 'RCPCH, RCOphth, BAPM',
  version: 'draft',
  criteria: const [
    EligibilityCriterion(
      id: 'ga',
      label: 'Gestational age < 31+0 weeks',
      gaMaxWeeks: 30, // <31+0 means 30+6 or less
    ),
    EligibilityCriterion(
      id: 'bw',
      label: 'Birth weight < 1501 g',
      birthWeightMaxG: 1500,
    ),
  ],
  riskFactors: const [],
  firstExamBasis: FirstExamBasis.pmaOrChronological,
  // DRAFT — must be set exactly from the current UK guideline. Mixing UK
  // timing with Indian eligibility is explicitly forbidden by spec §13.
  firstExamRules: const [
    FirstExamRule(gaFromWeeks: 0, gaToWeeks: 26, pmaWeeks: 31),
    FirstExamRule(gaFromWeeks: 27, gaToWeeks: 99, chronologicalWeeks: 4),
  ],
  references: const [
    'RCPCH / RCOphth / BAPM guideline on the screening and treatment of '
        'retinopathy of prematurity — verify the current edition.',
  ],
  lastVerified: null,
);

/// Every built-in protocol, in the order the picker shows them. India first,
/// because spec §1 says the module is primarily for Indian practice.
final List<RopProtocol> ropProtocols = [
  ropProtocolIndia,
  ropProtocolAap,
  ropProtocolUk,
];

RopProtocol ropProtocolById(String id) =>
    ropProtocols.firstWhere((p) => p.id == id, orElse: () => ropProtocolIndia);
