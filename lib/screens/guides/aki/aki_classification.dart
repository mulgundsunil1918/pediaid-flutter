// =============================================================================
// screens/guides/aki/aki_classification.dart
//
// Acute kidney injury staging, for neonates and for children.
//
// THREE SYSTEMS, AND WHICH ONE APPLIES IS DECIDED BY AGE, NOT PREFERENCE
//
//   < 28 days        Neonatal Modified KDIGO — always. Nothing else.
//   1 month – 18 y   KDIGO is the default; pRIFLE is offered alongside it.
//
// The neonatal system is not the adult one with different numbers pencilled
// in. Two differences matter at the cot side:
//
//   * The reference creatinine is the LOWEST PREVIOUS value, not an admission
//     baseline. A neonate's creatinine starts at the mother's and falls over
//     the first days of life, so "baseline" in the adult sense does not exist
//     and a rise against admission would stage almost every healthy newborn.
//   * Stage 3 is SCr >= 2.5 mg/dL, not the adult 4.0. A neonatal kidney that
//     reaches 2.5 is in a different place from an adult one.
//
// Staging takes the HIGHER of the creatinine stage and the urine-output stage.
// That is the published rule in all three systems and it is the step most
// often dropped: a child making 0.2 mL/kg/h with an unremarkable creatinine is
// stage 3, and reading creatinine alone would call them stage 0. The screen
// states this above the table rather than leaving it to be inferred.
//
// THIS FILE IS DATA ONLY. It carried a staging engine — inputs in, stage out —
// until Sunil asked for the table alone (26 Sep). The engine and its seventeen
// tests are in git at ba01ccb5, including the float-comparison fix they turned
// up: 0.6 / 0.4 is 1.4999999999999998, so a creatinine risen to exactly 1.5x
// its reference failed a bare `>= 1.5` and staged one grade low. If this is
// ever made computable again, that trap is waiting on 1.5, 2.0 and 3.0.
//
// Every threshold here is from the published source. Values are drawn from
// KDIGO 2012, Jetton & Askenazi 2012 (the neonatal modification, as used in
// AWAKEN) and Akcan-Arikan 2007 (pRIFLE), and need Dr Mulgund's sign-off
// before this is presented as clinical guidance.
// =============================================================================

/// Which staging system applies.
enum AkiSystem {
  /// < 28 days. The only system for a neonate.
  neonatalKdigo,

  /// 1 month – 18 years. The default.
  kdigo,

  /// 1 month – 18 years. Offered alongside KDIGO, never instead of it for a
  /// neonate — it is defined on creatinine clearance, which needs a height.
  prifle,
}

extension AkiSystemInfo on AkiSystem {
  String get label => switch (this) {
    AkiSystem.neonatalKdigo => 'Neonatal Modified KDIGO',
    AkiSystem.kdigo => 'KDIGO',
    AkiSystem.prifle => 'pRIFLE',
  };

  String get ageBand => switch (this) {
    AkiSystem.neonatalKdigo => 'Neonates — under 28 days',
    AkiSystem.kdigo => '1 month to 18 years',
    AkiSystem.prifle => '1 month to 18 years',
  };

  /// What the creatinine is compared against. Different enough between the
  /// neonatal and paediatric systems to be worth saying on screen.
  String get referenceRule => switch (this) {
    AkiSystem.neonatalKdigo =>
      'Reference creatinine is the LOWEST previous value, not the '
          'admission value — a newborn’s creatinine reflects the '
          'mother’s and falls over the first days of life.',
    AkiSystem.kdigo =>
      'Baseline is the lowest creatinine in the preceding 7 days, or a '
          'known steady-state value.',
    AkiSystem.prifle =>
      'Compared against the estimated creatinine clearance at baseline '
          '(Schwartz), so a height is required.',
  };

  bool get isNeonatal => this == AkiSystem.neonatalKdigo;
}

/// One row of a staging table.
class AkiStageRow {
  const AkiStageRow({
    required this.stage,
    required this.label,
    required this.creatinine,
    required this.urineOutput,
  });

  /// 0–3 for the KDIGO systems; 1–5 for pRIFLE (Risk … End-stage).
  final int stage;

  /// "Stage 2", "Injury" — pRIFLE names its classes rather than numbering.
  final String label;

  final String creatinine;
  final String urineOutput;
}

// ---------------------------------------------------------------------------
// The published tables
// ---------------------------------------------------------------------------

/// Jetton & Askenazi 2012 — the neonatal modification of KDIGO.
const List<AkiStageRow> kNeonatalKdigoTable = [
  AkiStageRow(
    stage: 0,
    label: 'Stage 0',
    creatinine: 'No change, or a rise of less than 0.3 mg/dL',
    urineOutput: '≥ 1 mL/kg/h',
  ),
  AkiStageRow(
    stage: 1,
    label: 'Stage 1',
    creatinine:
        'Rise ≥ 0.3 mg/dL within 48 h, OR 1.5–1.9 × the '
        'lowest previous value within 7 days',
    urineOutput: '> 0.5 and < 1 mL/kg/h over 24 h',
  ),
  AkiStageRow(
    stage: 2,
    label: 'Stage 2',
    creatinine: '2.0–2.9 × the lowest previous value',
    urineOutput: '> 0.3 and ≤ 0.5 mL/kg/h over 24 h',
  ),
  AkiStageRow(
    stage: 3,
    label: 'Stage 3',
    creatinine:
        '≥ 3 × the lowest previous value, OR serum '
        'creatinine ≥ 2.5 mg/dL, OR receipt of dialysis',
    urineOutput: '≤ 0.3 mL/kg/h over 24 h, OR anuria for 12 h',
  ),
];

/// KDIGO 2012, as applied to children.
const List<AkiStageRow> kKdigoTable = [
  AkiStageRow(
    stage: 0,
    label: 'Stage 0',
    creatinine: 'No criterion met',
    urineOutput: '≥ 0.5 mL/kg/h',
  ),
  AkiStageRow(
    stage: 1,
    label: 'Stage 1',
    creatinine:
        '1.5–1.9 × baseline within 7 days, OR a rise '
        '≥ 0.3 mg/dL within 48 h',
    urineOutput: '< 0.5 mL/kg/h for 6–12 h',
  ),
  AkiStageRow(
    stage: 2,
    label: 'Stage 2',
    creatinine: '2.0–2.9 × baseline',
    urineOutput: '< 0.5 mL/kg/h for ≥ 12 h',
  ),
  AkiStageRow(
    stage: 3,
    label: 'Stage 3',
    creatinine:
        '≥ 3.0 × baseline, OR serum creatinine '
        '≥ 4.0 mg/dL, OR start of renal replacement therapy, OR in a '
        'child under 18, eGFR falling below 35 mL/min/1.73 m²',
    urineOutput: '< 0.3 mL/kg/h for ≥ 24 h, OR anuria for ≥ 12 h',
  ),
];

/// Akcan-Arikan 2007. Classed, not staged — and the last two classes are
/// about duration, which no single set of observations can establish.
const List<AkiStageRow> kPrifleTable = [
  AkiStageRow(
    stage: 0,
    label: 'No AKI',
    creatinine: 'Estimated creatinine clearance unchanged',
    urineOutput: '≥ 0.5 mL/kg/h',
  ),
  AkiStageRow(
    stage: 1,
    label: 'Risk',
    creatinine: 'eCCl decreased by 25%',
    urineOutput: '< 0.5 mL/kg/h for 8 h',
  ),
  AkiStageRow(
    stage: 2,
    label: 'Injury',
    creatinine: 'eCCl decreased by 50%',
    urineOutput: '< 0.5 mL/kg/h for 16 h',
  ),
  AkiStageRow(
    stage: 3,
    label: 'Failure',
    creatinine: 'eCCl decreased by 75%, OR eCCl < 35 mL/min/1.73 m²',
    urineOutput: '< 0.3 mL/kg/h for 24 h, OR anuric for 12 h',
  ),
  AkiStageRow(
    stage: 4,
    label: 'Loss',
    creatinine: 'Persistent failure for more than 4 weeks',
    urineOutput: '—',
  ),
  AkiStageRow(
    stage: 5,
    label: 'End-stage',
    creatinine:
        'End-stage renal disease — persistent failure for more '
        'than 3 months',
    urineOutput: '—',
  ),
];

List<AkiStageRow> tableFor(AkiSystem system) => switch (system) {
  AkiSystem.neonatalKdigo => kNeonatalKdigoTable,
  AkiSystem.kdigo => kKdigoTable,
  AkiSystem.prifle => kPrifleTable,
};

// ---------------------------------------------------------------------------
// References
// ---------------------------------------------------------------------------

const String kAkiReference = '''
REFERENCES

Kidney Disease: Improving Global Outcomes (KDIGO) Acute Kidney Injury Work
Group. KDIGO Clinical Practice Guideline for Acute Kidney Injury.
Kidney Int Suppl. 2012;2(1):1–138.

Jetton JG, Askenazi DJ. Update on acute kidney injury in the neonate.
Curr Opin Pediatr. 2012;24(2):191–196. — the neonatal modification, as applied
in the AWAKEN study (Jetton et al, Lancet Child Adolesc Health 2017).

Akcan-Arikan A, Zappitelli M, Loftis LL, Washburn KK, Jefferson LS,
Goldstein SL. Modified RIFLE criteria in critically ill children with acute
kidney injury. Kidney Int. 2007;71(10):1028–1035. — pRIFLE.

Schwartz GJ, Work DF. Measurement and estimation of GFR in children and
adolescents. Clin J Am Soc Nephrol. 2009;4(11):1832–1843. — the estimated
creatinine clearance pRIFLE is defined on.

NOTE ON USE. Staging takes the higher of the creatinine and urine-output
criteria; neither alone is the answer. In a neonate the reference creatinine
is the lowest previous value, never the admission value, and the stage 3
creatinine threshold is 2.5 mg/dL rather than the 4.0 used beyond the newborn
period.
''';
