// ══════════════════════════════════════════════════════════════════════════
// Infant BP (1–12 months) — Second Task Force on Blood Pressure Control in
// Children, Pediatrics 1987;79(1):1–25 (the reference the AAP 2017 guideline
// retains for this age band).
//
// Numeric values digitised from the Task Force Fig 1 & 2 percentile curves by
// Lee Yingtong Li (2025), "Infant blood pressure centiles from the Second Task
// Force on Blood Pressure Control in Children", CC BY-SA 4.0
// (https://yingtongli.me) — extracted by projective transformation and
// validated against the report's own 90th-centile table. Sampled here at each
// whole month (50th/90th/95th, SBP & DBP, boys & girls). The 99th percentile
// is not part of these curves, so it is left null.
//
// ⚠️  Doppler-derived (1987): oscillometric monitors can read differently.
//     Values are read off a smoothed curve → treat as ±1–2 mmHg references.
// ══════════════════════════════════════════════════════════════════════════

/// Percentile row for one age-month + sex. `null` = not available.
class InfantBP {
  final int? sbp50, sbp90, sbp95, sbp99;
  final int? dbp50, dbp90, dbp95, dbp99;
  const InfantBP({
    this.sbp50, this.sbp90, this.sbp95, this.sbp99,
    this.dbp50, this.dbp90, this.dbp95, this.dbp99,
  });

  bool get isPopulated => sbp50 != null;
}

/// Real digitised values are now loaded → percentile layer is live.
const bool infantBpDataReady = true;

/// Documented PALS hypotension floor for infants 1–12 months.
const int infantHypotensionSbp = 70;

/// age in months (1–12) → 'boy'/'girl' → percentile row (mmHg).
const Map<int, Map<String, InfantBP>> infantBp1987 = {
  1: {'boy': InfantBP(sbp50: 86, sbp90: 100, sbp95: 104, dbp50: 52, dbp90: 65, dbp95: 69), 'girl': InfantBP(sbp50: 84, sbp90: 98, sbp95: 103, dbp50: 52, dbp90: 65, dbp95: 69)},
  2: {'boy': InfantBP(sbp50: 91, sbp90: 106, sbp95: 110, dbp50: 50, dbp90: 63, dbp95: 67), 'girl': InfantBP(sbp50: 87, sbp90: 101, sbp95: 106, dbp50: 51, dbp90: 64, dbp95: 68)},
  3: {'boy': InfantBP(sbp50: 91, sbp90: 106, sbp95: 110, dbp50: 50, dbp90: 63, dbp95: 66), 'girl': InfantBP(sbp50: 89, sbp90: 103, sbp95: 108, dbp50: 51, dbp90: 64, dbp95: 68)},
  4: {'boy': InfantBP(sbp50: 91, sbp90: 106, sbp95: 110, dbp50: 50, dbp90: 63, dbp95: 67), 'girl': InfantBP(sbp50: 90, sbp90: 105, sbp95: 109, dbp50: 52, dbp90: 65, dbp95: 68)},
  5: {'boy': InfantBP(sbp50: 91, sbp90: 105, sbp95: 110, dbp50: 52, dbp90: 64, dbp95: 68), 'girl': InfantBP(sbp50: 91, sbp90: 106, sbp95: 110, dbp50: 52, dbp90: 65, dbp95: 69)},
  6: {'boy': InfantBP(sbp50: 91, sbp90: 105, sbp95: 109, dbp50: 53, dbp90: 66, dbp95: 70), 'girl': InfantBP(sbp50: 92, sbp90: 106, sbp95: 110, dbp50: 53, dbp90: 66, dbp95: 69)},
  7: {'boy': InfantBP(sbp50: 91, sbp90: 105, sbp95: 109, dbp50: 54, dbp90: 67, dbp95: 71), 'girl': InfantBP(sbp50: 92, sbp90: 106, sbp95: 110, dbp50: 53, dbp90: 66, dbp95: 70)},
  8: {'boy': InfantBP(sbp50: 91, sbp90: 105, sbp95: 109, dbp50: 55, dbp90: 68, dbp95: 71), 'girl': InfantBP(sbp50: 92, sbp90: 106, sbp95: 110, dbp50: 54, dbp90: 66, dbp95: 70)},
  9: {'boy': InfantBP(sbp50: 91, sbp90: 105, sbp95: 109, dbp50: 56, dbp90: 68, dbp95: 72), 'girl': InfantBP(sbp50: 91, sbp90: 106, sbp95: 110, dbp50: 54, dbp90: 67, dbp95: 70)},
  10: {'boy': InfantBP(sbp50: 91, sbp90: 105, sbp95: 109, dbp50: 56, dbp90: 69, dbp95: 72), 'girl': InfantBP(sbp50: 91, sbp90: 106, sbp95: 110, dbp50: 54, dbp90: 67, dbp95: 70)},
  11: {'boy': InfantBP(sbp50: 91, sbp90: 105, sbp95: 109, dbp50: 56, dbp90: 69, dbp95: 73), 'girl': InfantBP(sbp50: 91, sbp90: 106, sbp95: 110, dbp50: 55, dbp90: 67, dbp95: 71)},
  12: {'boy': InfantBP(sbp50: 91, sbp90: 105, sbp95: 109, dbp50: 56, dbp90: 69, dbp95: 73), 'girl': InfantBP(sbp50: 91, sbp90: 105, sbp95: 109, dbp50: 55, dbp90: 67, dbp95: 71)},
};
