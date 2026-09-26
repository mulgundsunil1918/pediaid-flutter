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
// stage 3, and reading creatinine alone would call them stage 0.
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
// Staging
// ---------------------------------------------------------------------------

/// What the inputs produced, and why.
class AkiResult {
  const AkiResult({
    required this.system,
    required this.stage,
    required this.label,
    required this.byCreatinine,
    required this.byUrineOutput,
    required this.reasons,
    this.notes = const [],
  });

  final AkiSystem system;

  /// Null when nothing has been entered — which is NOT stage 0. A child
  /// nobody has measured is unstaged, and showing "Stage 0" for an empty form
  /// would read as a negative result.
  final int? stage;
  final String? label;

  /// The stage each axis alone would give, so the screen can show which one
  /// decided it.
  final int? byCreatinine;
  final int? byUrineOutput;

  /// Plain sentences naming the criteria that were met.
  final List<String> reasons;

  /// Caveats worth surfacing — a missing reference value, a dialysis override.
  final List<String> notes;

  bool get isStaged => stage != null;
}

/// Tolerant `>=` for thresholds reached by division.
///
/// See the note at the call site: exact ratios like 1.5 and 2.0 are not
/// exactly representable once they come out of a division, and staging an
/// episode one grade low because of a bit of float error is not an acceptable
/// failure mode.
bool _atLeast(double value, double threshold) => value >= threshold - 1e-9;

/// Stages an episode.
///
/// [currentCreatinine] and [referenceCreatinine] are mg/dL. [urineOutput] is
/// mL/kg/h averaged over the period the system specifies. Any of them may be
/// null — a real cot-side picture is usually incomplete, and the result says
/// what it could and could not establish rather than refusing outright.
///
/// The returned stage is the HIGHER of the two axes. That rule is why urine
/// output is not optional garnish: a child at 0.2 mL/kg/h with a flat
/// creatinine is stage 3.
AkiResult stageAki({
  required AkiSystem system,
  double? currentCreatinine,
  double? referenceCreatinine,
  double? urineOutput,
  bool onDialysis = false,
  bool anuric12h = false,
}) {
  final reasons = <String>[];
  final notes = <String>[];

  // ── Creatinine axis ────────────────────────────────────────────────────
  int? scrStage;
  if (onDialysis) {
    // Dialysis is stage 3 in both KDIGO systems regardless of the number.
    if (system != AkiSystem.prifle) {
      scrStage = 3;
      reasons.add('Receiving dialysis — stage 3 by definition');
    } else {
      notes.add(
        'pRIFLE does not stage on dialysis; classed on eCCl and urine '
        'output. Consider KDIGO alongside.',
      );
    }
  }

  if (currentCreatinine != null && referenceCreatinine != null) {
    if (referenceCreatinine <= 0) {
      notes.add('Reference creatinine must be greater than zero.');
    } else {
      final ratio = currentCreatinine / referenceCreatinine;
      final rise = currentCreatinine - referenceCreatinine;
      int byScr = 0;

      // Compare through _atLeast, never with a bare >=.
      //
      // 0.6 / 0.4 is 1.4999999999999998 in binary floating point, so a
      // creatinine that has risen to exactly 1.5x its reference fails a plain
      // `ratio >= 1.5` and the episode is staged one lower than it is. The
      // same trap sits on 2.0 and 3.0. Threshold comparisons on values derived
      // by division need a tolerance, and a clinical threshold is the last
      // place to discover that.
      if (_atLeast(ratio, 3.0)) {
        byScr = 3;
        reasons.add(
          'Creatinine is ${ratio.toStringAsFixed(1)} × the reference '
          'value (≥ 3)',
        );
      } else if (_atLeast(ratio, 2.0)) {
        byScr = 2;
        reasons.add(
          'Creatinine is ${ratio.toStringAsFixed(1)} × the reference '
          'value (2.0–2.9)',
        );
      } else if (_atLeast(ratio, 1.5)) {
        byScr = 1;
        reasons.add(
          'Creatinine is ${ratio.toStringAsFixed(1)} × the reference '
          'value (1.5–1.9)',
        );
      } else if (_atLeast(rise, 0.3) && system != AkiSystem.prifle) {
        // The absolute-rise criterion is KDIGO's; pRIFLE has no equivalent.
        byScr = 1;
        reasons.add(
          'Creatinine rose by ${rise.toStringAsFixed(2)} mg/dL '
          '(≥ 0.3 within 48 h)',
        );
      }

      // The absolute ceiling, which differs between the two KDIGO systems and
      // is the difference most often got wrong.
      final ceiling = system == AkiSystem.neonatalKdigo ? 2.5 : 4.0;
      if (system != AkiSystem.prifle && _atLeast(currentCreatinine, ceiling)) {
        if (byScr < 3) {
          reasons.add(
            'Creatinine ${currentCreatinine.toStringAsFixed(2)} mg/dL '
            'is at or above the stage 3 threshold of $ceiling',
          );
        }
        byScr = byScr < 3 ? 3 : byScr;
      }

      scrStage = (scrStage != null && scrStage > byScr) ? scrStage : byScr;
    }
  } else if (currentCreatinine != null && referenceCreatinine == null) {
    notes.add(
      'No reference creatinine, so the ratio criteria cannot be '
      'applied. ${system.referenceRule}',
    );
  }

  // ── Urine-output axis ──────────────────────────────────────────────────
  int? uoStage;
  if (anuric12h) {
    uoStage = 3;
    reasons.add('Anuria for 12 h — the most severe urine-output criterion');
  }
  if (urineOutput != null) {
    int byUo = 0;
    if (system == AkiSystem.neonatalKdigo) {
      if (urineOutput <= 0.3) {
        byUo = 3;
      } else if (urineOutput <= 0.5) {
        byUo = 2;
      } else if (urineOutput < 1.0) {
        byUo = 1;
      }
    } else {
      if (urineOutput < 0.3) {
        byUo = 3;
      } else if (urineOutput < 0.5) {
        // KDIGO and pRIFLE both separate their 1 and 2 by DURATION at this
        // rate, which a single averaged figure cannot distinguish. Reported
        // as the lower of the two rather than guessed upward.
        byUo = 1;
        notes.add(
          'Urine output below 0.5 mL/kg/h separates stage 1 from '
          'stage 2 by how long it persists — 6–12 h versus 12 h or more. '
          'Staged as 1 here; confirm the duration.',
        );
      }
    }
    if (byUo > 0) {
      reasons.add('Urine output ${urineOutput.toStringAsFixed(2)} mL/kg/h');
    }
    uoStage = (uoStage != null && uoStage > byUo) ? uoStage : byUo;
  }

  // ── Take the higher ────────────────────────────────────────────────────
  if (scrStage == null && uoStage == null) {
    return AkiResult(
      system: system,
      stage: null,
      label: null,
      byCreatinine: null,
      byUrineOutput: null,
      reasons: const [],
      notes: [
        'Nothing recorded yet. No findings is not the same as stage 0 — an '
            'unmeasured child is unstaged.',
        ...notes,
      ],
    );
  }

  final stage = [?scrStage, ?uoStage].reduce((a, b) => a > b ? a : b);

  final row = tableFor(
    system,
  ).firstWhere((r) => r.stage == stage, orElse: () => tableFor(system).first);

  return AkiResult(
    system: system,
    stage: stage,
    label: row.label,
    byCreatinine: scrStage,
    byUrineOutput: uoStage,
    reasons: reasons,
    notes: notes,
  );
}

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
