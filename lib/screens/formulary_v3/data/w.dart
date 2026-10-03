// =============================================================================
// output/w.dart — Drug Formulary 3.0, letter W
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyW` per file; entries in book order.
//   * `iconRow` is left empty on purpose: the icon captions were excluded on
//     request (`python3 tools/build.py --icons raw` emits them as printed).
//   * Printed en dashes, curly quotes, ≥ ≤ ÷ × and sub/superscripts are kept as
//     the real Unicode characters; nothing is normalised.
//   * doseSections: every level-0 bold item in the book starts a DoseSection;
//     deeper bold-only lines are DoseLine(isHeading: true).  A DoseSection holds
//     lines and then at most one table, so text that follows a table starts a
//     new section (heading '' when the book printed none).  Table footnotes are
//     the lines of that following section.
//   * Tables printed inside the formulations block come first in doseSections,
//     tables printed inside the remarks block come last (the schema has no
//     other slot for them).  A second header row (spanning header) is the first
//     row of `rows`.
//   * Cross-reference entries ("ACTH — See Corticotropin") are kept as entries
//     with the 'See ...' text in `remarks`.
//   * Import path assumes this repo's layout; adjust when moving into the app.
// =============================================================================

import '../drug_entry_v3.dart';

const List<DrugEntryV3> formularyW = [
  // WARFARIN — PDF p. 468–470 (printed 1277–1279)
  DrugEntryV3(
    name: 'WARFARIN',
    brandNames: 'Jantoven and generics; previously available as Coumadin',
    drugClass: 'Anticoagulant',
    iconRow: '',
    formulations: [
      'Tabs: 1, 2, 2.5, 3, 4, 5, 6, 7.5, 10 mg; tablets may be scored',
      'Oral liquid: 1 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infant and child (see remarks):',
        lines: [
          DoseLine('To achieve an international normalized ratio (INR) between 2 and 3.5 '
              'directed by specific indication'),
        ],
      ),
      DoseSection(
        heading: 'Loading dose on day 1:',
        lines: [
          DoseLine('Baseline INR ≤1.3: 0.2 mg/kg/dose PO; max. dose: 7.5 mg/dose'),
          DoseLine('Liver dysfunction, baseline INR >1.3, cardiopulmonary bypass within '
              'previous 10 days, NPO status/poor nutrition, receiving broad-spectrum '
              'antibiotics, receiving medications that significantly inhibit cytochrome '
              'P-450 (CYP) 2C9, or slow metabolizers of warfarin (see remarks): 0.05–0.1 '
              'mg/kg/dose PO; max. dose: 5 mg/dose'),
          DoseLine('Immediate postoperative period after a Fontan procedure: 0.05 mg/kg/dose '
              'PO; max. dose: 2.5 mg/dose'),
        ],
      ),
      DoseSection(
        heading: 'Loading dose on days 2–4:',
        table: DoseTable(
          headers: ['Day 2', '', 'Days 3 and 4', ''],
          rows: [
            DoseTableRow(['INR Level', 'Dose Adjustment', 'INR Level', 'Dose Adjustment']),
            DoseTableRow(['1.1–1.3', 'Repeat day 1 loading dose', '1.1–1.4', 'Increase previous dose by 20%–50%']),
            DoseTableRow(['1.4–1.9', 'Decrease day 1 loading dose by 50%', '1.5–1.9', 'Continue current dose']),
            DoseTableRow(['≥2', 'Hold dose for 24 hr, then give 50% of day 1 loading dose on day 3', '2–3', 'Use 25% of day 1 loading dose']),
            DoseTableRow(['', '', '3.1–3.5', 'Use 25%–50% of day 1 loading dose']),
            DoseTableRow(['', '', '>3.5', 'Hold dose until INR <3.5, then restart at ≤25% of day 1 loading dose']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Maintenance dose (therapy day ≥5):',
        table: DoseTable(
          headers: ['Goal INR 2–3', '', 'Goal INR 2.5–3.5', ''],
          rows: [
            DoseTableRow(['INR', 'Dose Adjustment', 'INR', 'Dose Adjustment']),
            DoseTableRow(['1.1–1.4', 'Increase previous dose by 20%', '1.1–1.9', 'Increase previous dose by 20%']),
            DoseTableRow(['1.5–1.9', 'Increase previous dose by 10%', '2–2.4', 'Increase previous dose by 10%']),
            DoseTableRow(['2–3', 'No change', '2.5–3.5', 'No change']),
            DoseTableRow(['3.1–3.5', 'Decrease previous dose by 10%', '3.6–4', 'Decrease previous dose by 50% for one dose, then restart at a dose (prior '
                'to 50% dose decrease) decreased by 20% the next day']),
            DoseTableRow(['>3.5', 'Hold dose until INR <3.5, then restart at 20% less than the last dose', '>4', 'Hold dose for 1 day, then restart at a dose decreased by 20% of the last '
                'dose']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Usual maintenance dose for INR goal of 2–3 (see remarks):',
        lines: [
          DoseLine('~0.1 mg/kg/24 hr PO once daily; range: 0.05–0.34 mg/kg/24 hr. Reported '
              'average dosages include the following:'),
          DoseLine('Infant <1 yr: 0.33 mg/kg/24 hr PO once daily'),
          DoseLine('Adolescent 11–18 yr: 0.09 mg/kg/24 hr PO once daily'),
        ],
      ),
      DoseSection(
        heading: 'Adult (see remarks):',
        lines: [
          DoseLine('2.5–10 mg PO once daily × 2–3 days. Adjust dose to achieve the desired '
              'INR or prothrombin time (PT). Maintenance dose range: 2–10 mg/24 hr PO '
              'once daily'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in severe liver or kidney disease, uncontrolled bleeding, '
          'gastrointestinal ulcers, and malignant hypertension. Acts on vitamin '
          'K–dependent coagulation factors II, VII, IX, and X. Side effects include '
          'fever, skin lesions, skin necrosis (especially in protein C deficiency), '
          'anorexia, nausea, vomiting, diarrhea, hemorrhage, and hemoptysis.',
      'Warfarin is a substrate for CYP1A2, 2C8, 2C9, 2C18, 2C19, and 3A3/4. '
          'Amiodarone, azole antifungals (e.g., fluconazole, voriconazole), '
          'broad-spectrum antibiotics (e.g., cefepime, meropenem, '
          'piperacillin/tazobactam), chloramphenicol, chloral hydrate, cimetidine, '
          'corticosteroids, delavirdine, fluoroquinolones (e.g., ciprofloxacin, '
          'levofloxacin), fluoxetine, metronidazole, indomethacin, large doses of '
          'vitamins A or E, nonsteroidal anti-inflammatory agents, omeprazole, '
          'oxandrolone, quinidine, salicylates, selective serotonin reuptake '
          'inhibitors (SSRIs; e.g., fluoxetine, paroxetine, sertraline), '
          'sulfonamides, and zafirlukast may increase warfarin’s effect. Ascorbic '
          'acid, barbiturates, carbamazepine, cholestyramine, dicloxacillin, '
          'griseofulvin, oral contraceptives, nafcillin, ribavirin, rifampin, '
          'spironolactone, sucralfate, and vitamin K (including foods with high '
          'content) may decrease warfarin’s effect.',
      'Younger children generally require higher doses to achieve desired '
          'effect. Children receiving Fontan cardiac surgery may require smaller '
          'doses than children with either congenital heart disease (without Fontan '
          'procedure) or no congenital heart disease. (See Chest 2004;126:645–687 '
          'and Blood 1999;94[9]:3007–3014 for additional information.)',
      'Lower doses should be considered for patients with pharmacogenetic '
          'variations in CYP2C9 (e.g., *2 and *3 alleles) and VKORC1 (e.g., 1639G>A '
          'allele) enzymes, especially in those with European ancestry. Elderly '
          'and/or debilitated patients and patients with a potential to exhibit '
          'greater than expected PT/INR response to warfarin should also consider '
          'using lower doses.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1277–1279',
  ),
];
