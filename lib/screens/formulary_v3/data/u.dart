// =============================================================================
// output/u.dart — Drug Formulary 3.0, letter U
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyU` per file; entries in book order.
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

const List<DrugEntryV3> formularyU = [
  // URSODIOL — PDF p. 450–451 (printed 1259–1260)
  DrugEntryV3(
    name: 'URSODIOL',
    brandNames: 'Urso Forte, Reltone, and generics; previously available as Actigall',
    drugClass: 'Gallstone solubilizing agent, cholelitholytic agent',
    iconRow: '',
    formulations: [
      'Oral suspension: 20, 25, 50, 60 mg/mL',
      'Caps:',
      'Generics: 200, 300, 400 mg',
      'Reltone: 200, 400 mg',
      'Tabs:',
      'Generics: 250 mg',
      'Urso Forte and generics: 500 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Biliary atresia:',
        lines: [
          DoseLine('Neonate, infant, and child (limited data): 10–20 mg/kg/24 hr PO ÷ '
              'BID–TID; higher doses of 20–36 mg/kg/24 hr have been reported in neonates '
              'and infants receiving the Kasai procedure'),
        ],
      ),
      DoseSection(
        heading: 'Pruritus from cholestasis:',
        lines: [
          DoseLine('Infant, child, and adolescent (limited data): 15–30 mg/kg/24 hr PO ÷ once '
              'daily–BID'),
        ],
      ),
      DoseSection(
        heading: 'Total parenteral nutrition–induced cholestasis:',
        lines: [
          DoseLine('Neonate (limited data): 10–30 mg/kg/24 hr PO ÷ TID'),
          DoseLine('Infant and child (limited data): 30 mg/kg/24 hr PO ÷ TID'),
        ],
      ),
      DoseSection(
        heading: 'Cystic fibrosis (to improve fatty acid metabolism in liver disease; '
            'limited data):',
        lines: [
          DoseLine('Child: 15–30 mg/kg/24 hr PO ÷ BID–TID'),
        ],
      ),
      DoseSection(
        heading: 'Gallstone dissolution:',
        lines: [
          DoseLine('Adult: 10–15 mg/kg/24 hr PO ÷ BID–TID'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in calcified cholesterol stones, radiopaque stones, bile '
          'pigment stones, or stones >20 mm in diameter. Use with caution in '
          'patients with non-visualizing gallbladder and chronic liver disease. May '
          'cause gastrointestinal (GI) disturbance, rash, arthralgias, anxiety, '
          'headache, and elevated liver enzymes (elevated alanin aminotransferase, '
          'aspartate aminotransferase, alkaline phosphatase, bilirubin, γ-glutamyl '
          'transferase). Monitor liver function tests every month for the first 3 '
          'months after initiating therapy and every 6 months thereafter. '
          'Thrombocytopenia has been reported in clinical trials. Reports of '
          'ursodiol-treated patients with underlying intestinal stenosis or stasis '
          '(e.g., surgical enteroanastomoses, Crohn’s disease) developing bezoars, '
          'resulting in obstructive symptoms requiring surgical intervention. It is '
          'recommended to hold ursodiol therapy in patients presenting with '
          'obstructive GI symptoms until a clinical evaluation is completed.',
      'Aluminum-containing antacids, cholestyramine, and oral contraceptives '
          'decrease ursodiol effectiveness. Dissolution of stones may take several '
          'months. Stone recurrence occurs in 30%–50% of patients within 5 yr.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1259–1260',
  ),
];
