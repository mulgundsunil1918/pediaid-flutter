// ══════════════════════════════════════════════════════════════════════════
// Infant BP (1–12 months) — Second Task Force on Blood Pressure Control in
// Children, Pediatrics 1987;79(1):1–25.
//
// ⚠️  DATA NOT YET AVAILABLE.
// The 1987 Second Task Force presents 1–12 month BP norms as a PLOTTED CURVE
// (Fig 1), not a digitized percentile table. No verified numeric values are
// stored here. The map below is the target SHAPE only, filled with nulls.
//
// TODO: Populate from Second Task Force 1987, Fig 1 — digitize from the primary
//       source or a cited textbook table before enabling this layer. Do NOT
//       fill in estimated numbers; a fabricated reference value is worse than
//       none for a clinical tool. Once real values are in place, set
//       [infantBpDataReady] = true.
// ══════════════════════════════════════════════════════════════════════════

/// Percentile row for one age-month + sex. `null` = not yet digitized.
class InfantBP {
  final int? sbp50, sbp90, sbp95, sbp99;
  final int? dbp50, dbp90, dbp95, dbp99;
  const InfantBP({
    this.sbp50, this.sbp90, this.sbp95, this.sbp99,
    this.dbp50, this.dbp90, this.dbp95, this.dbp99,
  });

  bool get isPopulated => sbp50 != null; // 50th SBP present ⇒ row is real
}

/// Flip to `true` ONLY after [infantBp1987] holds verified numbers.
const bool infantBpDataReady = false;

/// Documented, widely-cited PALS hypotension floor for infants 1–12 months.
/// This is the one real number this calculator ships with today.
const int infantHypotensionSbp = 70;

/// age in months (1–12) → 'boy'/'girl' → percentile row.
/// All rows are placeholders (null fields) until digitized — see TODO above.
const Map<int, Map<String, InfantBP>> infantBp1987 = {
  1:  {'boy': InfantBP(), 'girl': InfantBP()},
  2:  {'boy': InfantBP(), 'girl': InfantBP()},
  3:  {'boy': InfantBP(), 'girl': InfantBP()},
  4:  {'boy': InfantBP(), 'girl': InfantBP()},
  5:  {'boy': InfantBP(), 'girl': InfantBP()},
  6:  {'boy': InfantBP(), 'girl': InfantBP()},
  7:  {'boy': InfantBP(), 'girl': InfantBP()},
  8:  {'boy': InfantBP(), 'girl': InfantBP()},
  9:  {'boy': InfantBP(), 'girl': InfantBP()},
  10: {'boy': InfantBP(), 'girl': InfantBP()},
  11: {'boy': InfantBP(), 'girl': InfantBP()},
  12: {'boy': InfantBP(), 'girl': InfantBP()},
};
