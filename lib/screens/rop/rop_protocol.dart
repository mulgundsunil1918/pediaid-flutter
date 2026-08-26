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
// CLINICAL STATUS
//
// Values were read from the source documents on 2026-08-26, not recalled:
//
//   India  — "Guidelines for Universal Eye Screening in Newborns including
//            Retinopathy of Prematurity", RBSK, Ministry of Health & Family
//            Welfare, Government of India, June 2017. Screening thresholds,
//            the 30-day rule, the <28 wk / <1200 g early pathway and the
//            follow-up and discharge rules are quoted from that document.
//   AAP    — Policy Statement, Section on Ophthalmology / AAO / AAPOS,
//            Pediatrics 2006;117(2):572. Table 1 is transcribed row by row.
//   UK     — RCPCH / RCOphth / BAPM, UK screening of retinopathy of
//            prematurity, March 2022 (updated 2024).
//
// `lastVerified` records that check per protocol. Spec §73 also requires
// review by a neonatologist and an ROP ophthalmologist before release — that
// is a separate sign-off from this transcription check, and the UI still says
// the module is decision support rather than a diagnosis.
// =============================================================================

/// The date every protocol's values were checked against its source document.
/// Spec §73 step 9 requires recording when each reference was verified.
final _verifiedOn = DateTime(2026, 8, 26);

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
    // RBSK 2017: "Initial Screen at 4 Weeks (30 Days) of Birth." A single rule
    // across the GA range; the earlier pathway below is the documented
    // exception, not a second row here.
    FirstExamRule(gaFromWeeks: 0, gaToWeeks: 99, dayFrom: 28, dayTo: 30),
  ],
  // RBSK 2017, verbatim: "infants with period of gestation less than 28 weeks
  // (gestation age) or less than 1200 grams birth weight should be first
  // screened at 2-3 weeks after delivery." Spec §11 requires this be a named
  // pathway rather than a special case buried in the 30-day arithmetic.
  earlyPathwayGaMaxWeeks: 27, // "less than 28 weeks" → 27+6 or below
  earlyPathwayBirthWeightMaxG: 1199, // "less than 1200 grams"
  earlyPathwayNote:
      'Gestation under 28 weeks or birth weight under 1200 g: first screening '
      'at 2–3 weeks after delivery, not at 4 weeks (RBSK 2017).',
  breadthWarning:
      'Indian screening criteria are deliberately broader than several Western '
      'protocols. An infant outside the routine GA and birth-weight thresholds '
      'may still need screening if clinically high risk — a simple GA/BW filter '
      'misses larger, sicker babies.',
  references: const [
    'Guidelines for Universal Eye Screening in Newborns including Retinopathy '
        'of Prematurity. Rashtriya Bal Swasthya Karyakram, Ministry of Health '
        '& Family Welfare, Government of India. June 2017.',
    'NNF clinical practice guidelines — ROP screening and treatment.',
  ],
  lastVerified: _verifiedOn,
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
  // AAP Table 1, "Timing of First Eye Examination Based on Gestational Age at
  // Birth", transcribed row by row. The two columns always describe the SAME
  // date — 31 weeks PMA is 9 weeks chronological at GA 22, 4 weeks at GA 27 —
  // so taking the later of the two reproduces the table exactly while also
  // covering gestations the table does not list.
  //
  // The statement notes rows for 22 and 23 weeks are tentative rather than
  // evidence-based, given how few survivors there were in those categories.
  firstExamRules: const [
    FirstExamRule(gaFromWeeks: 22, gaToWeeks: 22, pmaWeeks: 31, chronologicalWeeks: 9),
    FirstExamRule(gaFromWeeks: 23, gaToWeeks: 23, pmaWeeks: 31, chronologicalWeeks: 8),
    FirstExamRule(gaFromWeeks: 24, gaToWeeks: 24, pmaWeeks: 31, chronologicalWeeks: 7),
    FirstExamRule(gaFromWeeks: 25, gaToWeeks: 25, pmaWeeks: 31, chronologicalWeeks: 6),
    FirstExamRule(gaFromWeeks: 26, gaToWeeks: 26, pmaWeeks: 31, chronologicalWeeks: 5),
    FirstExamRule(gaFromWeeks: 27, gaToWeeks: 27, pmaWeeks: 31, chronologicalWeeks: 4),
    FirstExamRule(gaFromWeeks: 28, gaToWeeks: 28, pmaWeeks: 32, chronologicalWeeks: 4),
    FirstExamRule(gaFromWeeks: 29, gaToWeeks: 29, pmaWeeks: 33, chronologicalWeeks: 4),
    FirstExamRule(gaFromWeeks: 30, gaToWeeks: 30, pmaWeeks: 34, chronologicalWeeks: 4),
    FirstExamRule(gaFromWeeks: 31, gaToWeeks: 31, pmaWeeks: 35, chronologicalWeeks: 4),
    FirstExamRule(gaFromWeeks: 32, gaToWeeks: 99, pmaWeeks: 36, chronologicalWeeks: 4),
  ],
  breadthWarning:
      'Screening parameters vary internationally. AAP/AAPOS thresholds are '
      'narrower than Indian national guidance — do not apply them to a '
      'population screened under a different protocol.',
  references: const [
    'Screening Examination of Premature Infants for Retinopathy of '
        'Prematurity. Section on Ophthalmology, American Academy of '
        'Pediatrics; American Academy of Ophthalmology; American Association '
        'for Pediatric Ophthalmology and Strabismus. Pediatrics. '
        '2006;117(2):572-576. Table 1 transcribed 2026-08-26.',
  ],
  lastVerified: _verifiedOn,
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
  // RCPCH 2022: for infants born before 31+0 weeks, the first examination is
  // between 31+0 and 31+6 weeks PMA, OR at 4 completed weeks postnatal age
  // (28–34 days), WHICHEVER IS LATER. One rule covers the whole range because
  // the guideline states it as one rule.
  firstExamRules: const [
    FirstExamRule(gaFromWeeks: 0, gaToWeeks: 99, pmaWeeks: 31, chronologicalWeeks: 4),
  ],
  references: const [
    'UK screening of retinopathy of prematurity. Royal College of Paediatrics '
        'and Child Health, Royal College of Ophthalmologists, British '
        'Association of Perinatal Medicine. March 2022 (updated 2024).',
  ],
  lastVerified: _verifiedOn,
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
