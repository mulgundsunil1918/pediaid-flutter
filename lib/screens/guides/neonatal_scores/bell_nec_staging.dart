// =============================================================================
// screens/guides/neonatal_scores/bell_nec_staging.dart
//
// Modified Bell's staging criteria for necrotising enterocolitis.
//
// Walsh MC, Kliegman RM. Necrotizing enterocolitis: treatment based on staging
// criteria. Pediatr Clin North Am. 1986;33(1):179-201. (PMID 3081865.)
// Transcribed 2026-09-15 and cross-checked against a published reproduction of
// the table, which corrected two things in the copy supplied: stage IA's
// radiographic line is "Normal or MILD intestinal dilation, mild ileus", and
// the scan's "mildy / matked / instestinalis" are "mildly / marked /
// intestinalis".
//
// WHY THIS IS NOT A SCORE
// -----------------------
// Every other additive tool in this hub sums points. Bell's does not: IIB is
// not "more points than IIA", it is a different clinical picture. The shared
// smart view adds numeric columns, so pointing it at Bell's would produce a
// total with no meaning at all. Hence a separate model and a separate view.
//
// WHAT THE STAGING FUNCTION DOES, AND WHAT IT REFUSES TO DO
// ---------------------------------------------------------
// The stages are cumulative — each row reads "same as above, plus ..." — so
// every stage is defined by the findings it ADDS. Selecting findings and taking
// the highest stage whose added findings are present follows the table exactly.
//
// It is still a suggestion, not a verdict. The source is a descriptive
// classification, not a decision rule, and a real infant is staged on the whole
// picture. The UI says so, and the function never claims more than "the
// findings recorded reach this stage".
// =============================================================================

import 'package:flutter/foundation.dart';

enum BellStage { ia, ib, iia, iib, iiia, iiib }

extension BellStageX on BellStage {
  /// "IIIA"
  String get code => switch (this) {
        BellStage.ia => 'IA',
        BellStage.ib => 'IB',
        BellStage.iia => 'IIA',
        BellStage.iib => 'IIB',
        BellStage.iiia => 'IIIA',
        BellStage.iiib => 'IIIB',
      };

  String get classification => switch (this) {
        BellStage.ia => 'Suspected',
        BellStage.ib => 'Suspected',
        BellStage.iia => 'Definite, mildly ill',
        BellStage.iib => 'Definite, moderately ill',
        BellStage.iiia => 'Advanced, severely ill, intact bowel',
        BellStage.iiib => 'Advanced, severely ill, perforated bowel',
      };

  /// Rank for comparison. Not a score — only an ordering.
  int get rank => BellStage.values.indexOf(this);

  /// Treatment as the source states it.
  String get treatment => switch (this) {
        BellStage.ia => 'NPO, antibiotics × 3 days',
        BellStage.ib => 'NPO, antibiotics × 3 days (as IA)',
        BellStage.iia => 'NPO, antibiotics × 7 to 10 days',
        BellStage.iib => 'NPO, antibiotics × 14 days',
        BellStage.iiia =>
          'NPO, antibiotics × 14 days, fluid resuscitation, inotropic support, '
              'ventilator therapy, paracentesis',
        BellStage.iiib =>
          'NPO, antibiotics × 14 days, fluid resuscitation, inotropic support, '
              'ventilator therapy, paracentesis — PLUS surgery',
      };

  /// True for the two stages that need a surgeon in the room now.
  bool get isAdvanced => this == BellStage.iiia || this == BellStage.iiib;
}

/// Which column of the table a finding belongs to.
enum BellSystem { systemic, abdominal, radiographic }

extension BellSystemX on BellSystem {
  String get label => switch (this) {
        BellSystem.systemic => 'Systemic signs',
        BellSystem.abdominal => 'Abdominal signs',
        BellSystem.radiographic => 'Radiographic signs',
      };
}

/// One finding, and the stage its presence establishes.
@immutable
class BellFinding {
  final String id;
  final String label;
  final BellSystem system;

  /// The stage this finding belongs to in the table.
  final BellStage stage;

  /// True when this finding alone establishes its stage.
  ///
  /// Pneumoperitoneum is the clearest case: the table defines IIIB by it, so a
  /// single radiograph settles the stage. Contrast with "abdominal cellulitis",
  /// which the table lists as "with or without" — present it may be, decisive
  /// it is not.
  final bool decisive;

  const BellFinding({
    required this.id,
    required this.label,
    required this.system,
    required this.stage,
    this.decisive = true,
  });
}

/// Every finding in the table, in the stage it is first introduced.
///
/// Stages IB upward read "same as above, plus ...", so a finding appears once,
/// against the stage that adds it.
const List<BellFinding> kBellFindings = [
  // ── IA: suspected ────────────────────────────────────────────────────────
  BellFinding(
      id: 'temp_instability',
      label: 'Temperature instability',
      system: BellSystem.systemic,
      stage: BellStage.ia),
  BellFinding(
      id: 'apnea',
      label: 'Apnoea',
      system: BellSystem.systemic,
      stage: BellStage.ia),
  BellFinding(
      id: 'bradycardia',
      label: 'Bradycardia',
      system: BellSystem.systemic,
      stage: BellStage.ia),
  BellFinding(
      id: 'lethargy',
      label: 'Lethargy',
      system: BellSystem.systemic,
      stage: BellStage.ia),
  BellFinding(
      id: 'gastric_retention',
      label: 'Gastric retention',
      system: BellSystem.abdominal,
      stage: BellStage.ia),
  BellFinding(
      id: 'distention',
      label: 'Abdominal distention',
      system: BellSystem.abdominal,
      stage: BellStage.ia),
  BellFinding(
      id: 'emesis',
      label: 'Emesis',
      system: BellSystem.abdominal,
      stage: BellStage.ia),
  BellFinding(
      id: 'heme_positive',
      label: 'Heme-positive stool',
      system: BellSystem.abdominal,
      stage: BellStage.ia),
  BellFinding(
      id: 'normal_or_mild_dilation',
      label: 'Normal, or mild intestinal dilation and mild ileus',
      system: BellSystem.radiographic,
      stage: BellStage.ia),

  // ── IB: grossly bloody stool is the only change ──────────────────────────
  BellFinding(
      id: 'grossly_bloody_stool',
      label: 'Grossly bloody stool',
      system: BellSystem.abdominal,
      stage: BellStage.ib),

  // ── IIA: definite, mildly ill ────────────────────────────────────────────
  BellFinding(
      id: 'absent_bowel_sounds',
      label: 'Absent bowel sounds',
      system: BellSystem.abdominal,
      stage: BellStage.iia),
  BellFinding(
      id: 'abdominal_tenderness',
      label: 'Abdominal tenderness (with or without)',
      system: BellSystem.abdominal,
      stage: BellStage.iia,
      // The table qualifies this one "with or without", so on its own it does
      // not establish IIA.
      decisive: false),
  BellFinding(
      id: 'pneumatosis',
      label: 'Pneumatosis intestinalis',
      system: BellSystem.radiographic,
      stage: BellStage.iia),
  BellFinding(
      id: 'ileus_dilation',
      label: 'Intestinal dilation with ileus',
      system: BellSystem.radiographic,
      stage: BellStage.iia),

  // ── IIB: definite, moderately ill ────────────────────────────────────────
  BellFinding(
      id: 'mild_metabolic_acidosis',
      label: 'Mild metabolic acidosis',
      system: BellSystem.systemic,
      stage: BellStage.iib),
  BellFinding(
      id: 'thrombocytopenia',
      label: 'Thrombocytopenia',
      system: BellSystem.systemic,
      stage: BellStage.iib),
  BellFinding(
      id: 'definite_tenderness',
      label: 'Definite abdominal tenderness',
      system: BellSystem.abdominal,
      stage: BellStage.iib),
  BellFinding(
      id: 'cellulitis_or_rlq_mass',
      label: 'Abdominal cellulitis or right lower quadrant mass '
          '(with or without)',
      system: BellSystem.abdominal,
      stage: BellStage.iib,
      decisive: false),
  BellFinding(
      id: 'ascites',
      label: 'Ascites',
      system: BellSystem.radiographic,
      stage: BellStage.iib),

  // ── IIIA: advanced, severely ill, intact bowel ───────────────────────────
  BellFinding(
      id: 'hypotension',
      label: 'Hypotension',
      system: BellSystem.systemic,
      stage: BellStage.iiia),
  BellFinding(
      id: 'severe_apnea',
      label: 'Severe apnoea',
      system: BellSystem.systemic,
      stage: BellStage.iiia),
  BellFinding(
      id: 'combined_acidosis',
      label: 'Combined respiratory and metabolic acidosis',
      system: BellSystem.systemic,
      stage: BellStage.iiia),
  BellFinding(
      id: 'dic',
      label: 'Disseminated intravascular coagulation',
      system: BellSystem.systemic,
      stage: BellStage.iiia),
  BellFinding(
      id: 'neutropenia',
      label: 'Neutropenia',
      system: BellSystem.systemic,
      stage: BellStage.iiia),
  BellFinding(
      id: 'peritonitis',
      label: 'Signs of peritonitis',
      system: BellSystem.abdominal,
      stage: BellStage.iiia),
  BellFinding(
      id: 'marked_tenderness',
      label: 'Marked tenderness and abdominal distention',
      system: BellSystem.abdominal,
      stage: BellStage.iiia),

  // ── IIIB: perforated ─────────────────────────────────────────────────────
  BellFinding(
      id: 'pneumoperitoneum',
      label: 'Pneumoperitoneum',
      system: BellSystem.radiographic,
      stage: BellStage.iiib),
];

/// The result of staging a set of findings.
@immutable
class BellResult {
  /// Null when nothing decisive has been recorded.
  final BellStage? stage;

  /// The findings that established it, in the order they appear in the table.
  final List<BellFinding> deciding;

  /// Findings recorded that the table qualifies "with or without", so they
  /// support the picture without establishing a stage on their own.
  final List<BellFinding> supporting;

  final String message;

  const BellResult({
    required this.stage,
    required this.deciding,
    required this.supporting,
    required this.message,
  });
}

/// Stages a set of selected findings.
///
/// The highest stage with a DECISIVE finding present wins, because the table is
/// cumulative and each stage is defined by what it adds. A finding the table
/// qualifies "with or without" cannot raise the stage by itself — it is
/// reported as supporting instead, which is exactly the weight the source
/// gives it.
BellResult stageNec(Set<String> selectedIds) {
  final selected = kBellFindings
      .where((f) => selectedIds.contains(f.id))
      .toList(growable: false);

  if (selected.isEmpty) {
    return const BellResult(
      stage: null,
      deciding: [],
      supporting: [],
      message: 'Select the findings that are present. Nothing has been '
          'recorded yet — and no findings is not the same as stage IA.',
    );
  }

  final decisive = selected.where((f) => f.decisive).toList(growable: false);
  final supporting = selected.where((f) => !f.decisive).toList(growable: false);

  if (decisive.isEmpty) {
    return BellResult(
      stage: null,
      deciding: const [],
      supporting: supporting,
      message: 'Only findings the criteria qualify "with or without" have been '
          'recorded. Those support a picture but do not establish a stage on '
          'their own — record the systemic, abdominal or radiographic findings '
          'that define it.',
    );
  }

  var top = decisive.first.stage;
  for (final f in decisive) {
    if (f.stage.rank > top.rank) top = f.stage;
  }
  final deciding =
      decisive.where((f) => f.stage == top).toList(growable: false);

  return BellResult(
    stage: top,
    deciding: deciding,
    supporting: supporting,
    message: 'The findings recorded reach stage ${top.code}. Bell\'s is a '
        'clinical classification, not a decision rule — stage the infant on the '
        'whole picture.',
  );
}

// ── The table, for the chart view ────────────────────────────────────────────

/// One row of the published table.
@immutable
class BellRow {
  final BellStage stage;
  final String systemic;
  final String abdominal;
  final String radiographic;
  const BellRow(this.stage, this.systemic, this.abdominal, this.radiographic);
}

/// The table as published, including its "same as above" wording — that
/// cumulative phrasing is how the classification works and flattening it out
/// would misrepresent the source.
const List<BellRow> kBellTable = [
  BellRow(
    BellStage.ia,
    'Temperature instability, apnea, bradycardia, lethargy',
    'Gastric retention, abdominal distention, emesis, heme-positive stool',
    'Normal or mild intestinal dilation, mild ileus',
  ),
  BellRow(
    BellStage.ib,
    'Same as above',
    'Grossly bloody stool',
    'Same as above',
  ),
  BellRow(
    BellStage.iia,
    'Same as above',
    'Same as above, plus absent bowel sounds with or without abdominal '
        'tenderness',
    'Intestinal dilation, ileus, pneumatosis intestinalis',
  ),
  BellRow(
    BellStage.iib,
    'Same as above, plus mild metabolic acidosis and thrombocytopenia',
    'Same as above, plus absent bowel sounds, definite tenderness, with or '
        'without abdominal cellulitis or right lower quadrant mass',
    'Same as IIA, plus ascites',
  ),
  BellRow(
    BellStage.iiia,
    'Same as IIB, plus hypotension, bradycardia, severe apnea, combined '
        'respiratory and metabolic acidosis, DIC, and neutropenia',
    'Same as above, plus signs of peritonitis, marked tenderness, and '
        'abdominal distention',
    'Same as IIA, plus ascites',
  ),
  BellRow(
    BellStage.iiib,
    'Same as IIIA',
    'Same as IIIA',
    'Same as above, plus pneumoperitoneum',
  ),
];

const String kBellReference =
    'Walsh MC, Kliegman RM. Necrotizing enterocolitis: treatment based on '
    'staging criteria. Pediatr Clin North Am. 1986;33(1):179-201. '
    'Modification of Bell MJ, Ternberg JL, Feigin RD, et al. Ann Surg. '
    '1978;187(1):1-7. Staging is a clinical classification, not a scoring '
    'system — the stages are not added and a higher stage is not a larger '
    'number, it is a different clinical picture.';
