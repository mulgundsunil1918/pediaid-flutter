// =============================================================================
// output/k.dart — Drug Formulary 3.0, letter K
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyK` per file; entries in book order.
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

const List<DrugEntryV3> formularyK = [
  // KALYDECO — PDF p. 249 (printed 1058)  [cross-reference]
  DrugEntryV3(
    name: 'KALYDECO',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Ivacaftor.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1058',
  ),
  // KETAMINE — PDF p. 249–250 (printed 1058–1059)
  DrugEntryV3(
    name: 'KETAMINE',
    brandNames: 'Ketalar and generics',
    drugClass: 'General anesthetic',
    iconRow: '',
    formulations: [
      'Injection: 10 mg/mL (20 mL), 50 mg/mL (10 mL), 100 mg/mL (5, 10 mL); '
          'contains benzethonium chloride as a preservative',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child (see remarks):',
        lines: [
          DoseLine(
            'Sedation:',
            isHeading: true,
          ),
          DoseLine('PO: 5 mg/kg × 1, 30–45 min prior to procedure'),
          DoseLine('IV: 0.5–1 mg/kg; max. dose: 150 mg/dose'),
          DoseLine('IM: 2–5 mg/kg × 1'),
          DoseLine('Intranasal (≥3 mo; limited data): 3–6 mg/kg x 1, administering half of '
              'total dose per nostril using a mucosal automizer device'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine(
            'Analgesia with sedation:',
            isHeading: true,
          ),
          DoseLine('IV (see remarks): 0.2–1 mg/kg'),
          DoseLine('IM: 0.5–4 mg/kg'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in significant hypertension and known hypersensitivity to '
          'the drug. Use with caution in elevated ICP, aneurysms, thyrotoxicosis, '
          'CHF, angina, and psychotic disorders. May cause hypertension, '
          'hypotension, emergence reactions, tachycardia, laryngospasm, respiratory '
          'depression, and stimulation of salivary secretions. Cystitis has been '
          'reported with chronic use/abuse. Intravenous use may induce general '
          'anesthesia. Hepatobiliary dysfunction with or without biliary obstruction '
          'has also been reported with recurrent use. Diplopia and nystagmus have '
          'been noted following IV administration. False-positive test for urine '
          'phencyclidine (PCP) screen may occur.',
      'Coadministration of an anticholinergic agent may be added in situations '
          'of clinically significant hypersalivation in patients with impaired '
          'ability to mobilize secretions. Benzodiazepine may be used in the '
          'presence of a ketamine-associated recovery reaction (prophylaxis use in '
          'adults may be beneficial). Ondansetron prophylaxis can slightly reduce '
          'vomiting. See Ann Emerg Med. 2001;57:449–461 for additional use '
          'information in the emergency department.',
      'Drug is a substrate for cytochrome P-450 2B6, 2C9, and 3A4 isoenzymes. '
          'Consider potential drug interactions with respective enzyme inhibitors '
          'and inducers, especially with prolonged use. Use with aminophylline or '
          'theophylline may increase risk for seizures. Use with sympathomimetics '
          'and vasopressin may enhance the sympathomimetic effects of ketamine. Use '
          'with CNS depressants may result in profound sedation, respiratory '
          'depression, and coma.',
      'Rate of IV infusion should not exceed 0.5 mg/kg/min and infusion should '
          'not be administered in less than 60 sec. For additional information, '
          'including onset and duration of action, see Chapter 6.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1058–1059',
  ),
  // KETOCONAZOLE — PDF p. 250–251 (printed 1059–1060)
  DrugEntryV3(
    name: 'KETOCONAZOLE',
    brandNames: 'Nizoral, Ketodan, and generics',
    drugClass: 'Antifungal agent, imidazole',
    iconRow: '',
    formulations: [
      'Tabs: 200 mg',
      'Oral suspension: 100 mg/5 mL',
      'Cream: 2% (15, 30, 60 g); contains sulfites',
      'Topical foam: 2% (Ketodan and generics) (50, 100 g); contains alcohol and '
          'propylene glycol',
      'Shampoo:',
      '1% [Nizoral (OTC)] (125, 200, 325, 400 mL); may contain a conditioner',
      '2% (generics) (120 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Oral (antifungal use; see remarks):',
        lines: [
          DoseLine('Child ≥2 yr and adolescent: 3.3–6.6 mg/kg/24 hr once daily'),
          DoseLine('Adult: 200–400 mg/24 hr once daily'),
          DoseLine('Max. dose (all ages): 400 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Topical (≥12 yr; see remarks):',
        lines: [
          DoseLine('Cream: 1 application to affected area once daily × 2–6 wk. For seborrheic '
              'dermatitis, use BID × 4 wk.'),
          DoseLine('Foam: 1 application to affected area BID × 4 wk for seborrheic dermatitis'),
        ],
      ),
      DoseSection(
        heading: 'Shampoo:',
        lines: [
          DoseLine('1% (Dandruff): Apply to wet hair, generously lather, rinse thoroughly; '
              'use every 3–4 days for up to 8 wk PRN.'),
          DoseLine('2% (Tinea versicolor): Apply to wet hair and leave on for 5 min before '
              'rinsing once daily for 1–3 days'),
        ],
      ),
    ],
    remarks: [
      'The systemic dosage form should NOT be first-line treatment for any '
          'fungal infection due to concerns of hepatotoxicity and adrenal gland '
          'effects (per the FDA). Off-label uses include precocious puberty and '
          'Cushing syndrome (second line).',
      'Monitor LFTs in long-term use and adrenal function for patients at risk. '
          'Drugs that decrease gastric acidity will decrease absorption. May cause '
          'nausea, vomiting, rash, headache, pruritus, and fever. Hepatotoxicity '
          '(including fatal cases) has been reported; use with hepatic impairment is '
          'contraindicated. High doses may decrease adrenocortical function and '
          'serum testosterone levels. Hypersensitivity reactions (including '
          'anaphylaxis) have been reported with all dosage forms.',
      'Safety and efficacy with topical use in seborrheic dermatitis for '
          'patients >12 yr of age have been established. Avoid topical use on breast '
          'or nipples in nursing mothers.',
      'Inhibits cytochrome P-450 3A4. Contraindicated for use with cisapride, '
          'disopyramide, methadone, mefloquine, quinidine, terfenadine, pimozide, or '
          'any drug that can prolong the Q–T interval (because of risk for cardiac '
          'arrhythmias), and HMG-CoA reductase inhibitors (e.g., simvastatin and '
          'lovastatin). Excessive sedation and prolonged hypnotic effects with '
          'triazolam use (also contraindicated). May increase levels/effects of '
          'phenytoin, digoxin, cyclosporine, corticosteroids, nevirapine, protease '
          'inhibitors, and warfarin. Achlorhydria, phenobarbital, rifampin, '
          'isoniazid, H₂ blockers, antacids, and omeprazole can decrease levels of '
          'oral ketoconazole.',
      'Administering oral doses with food or acidic beverages and 2 hr prior to '
          'antacids will increase absorption. For topical products, avoid contact '
          'with eyes and other mucous membranes.',
      'To use shampoo, wet hair and scalp with water, apply sufficient amount to '
          'scalp, and gently massage for about 1 min. Rinse hair thoroughly, reapply '
          'shampoo and leave on the scalp for an additional 3 min, and rinse.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1059–1060',
  ),
  // KETOROLAC — PDF p. 251–252 (printed 1060–1061)
  DrugEntryV3(
    name: 'KETOROLAC',
    brandNames: 'Many generics (previously available as Toradol), Acular, Acular LS, '
        'Acuvail',
    drugClass: 'Nonsteroidal anti-inflammatory agent',
    iconRow: '',
    formulations: [
      'Injection: 15 mg/mL (1 mL), 30 mg/mL (1, 2 mL); contains 10% alcohol and '
          'tromethamine; some preparations may be preservative free',
      'Tabs: 10 mg; contains tromethamine',
      'Ophthalmic solution (all containing tromethamine):',
      'Acular and generics: 0.5% (5, 10 mL); contains benzalkonium chloride and '
          'EDTA',
      'Acular LS and generics: 0.4% (5 mL); contains benzalkonium chloride and '
          'EDTA',
      'Acuvail: 0.45% (0.4 mL; 30 s); preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Systemic use is not to exceed 3–5 days, regardless of systemic route '
            'of administration (IM, IV, PO).',
      ),
      DoseSection(
        heading: 'IM/IV:',
        lines: [
          DoseLine('Child: 0.5 mg/kg/dose IM/IV Q6–8 hr. Max. dose: 30 mg Q6 hr or 120 mg/24 '
              'hr'),
          DoseLine('Adult: 15–30 mg IM/IV Q6 hr. Max. dose: 120 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'PO:',
        lines: [
          DoseLine('Child 2–≤16 yr (limited data): 1 mg/kg/dose Q4–6 hr; max. dose: 10 '
              'mg/dose and 40 mg/24 hr'),
          DoseLine('Child >16 yr and adult: 10 mg PRN Q4–6 hr; max. dose: 40 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Ophthalmic (see remarks):',
        lines: [
          DoseLine(
            'Postoperative cataract surgery:',
            isHeading: true,
          ),
          DoseLine('≥2 yr–adult (use 0.5%): 1 drop in each affected eye QID starting 24 hr '
              'after surgery × 2 wk'),
          DoseLine(
            'Postoperative corneal refractive surgery:',
            isHeading: true,
          ),
          DoseLine('≥3 yr–adult (use 0.4%): 1 drop in each affected eye QID PRN for up to 4 '
              'days after surgery'),
          DoseLine(
            'Seasonal allergic conjunctivitis:',
            isHeading: true,
          ),
          DoseLine('≥2 yr–adult (use 0.5%): 1 drop in each eye QID'),
        ],
      ),
    ],
    remarks: [
      'May cause GI bleeding, nausea, dyspepsia, drowsiness, decreased platelet '
          'function, and interstitial nephritis. Not recommended in patients at '
          'increased risk of bleeding. Do not use in hepatic or renal failure. Use '
          'with caution in heart disease (risk for MI and stroke with prolonged '
          'use). False-positive test for urine cannabinoid screen may occur with '
          'systemic use.',
      'Duration of therapy for ophthalmic use: 14 days after cataract surgery, '
          'and up to 4 days after corneal refractive surgery. Also indicated for '
          'ocular itching associated with seasonal allergic conjunctivitis. '
          'Bronchospasm or asthma exacerbations, allergic reactions, corneal '
          'erosion/perforation/thinning/melt, and epithelial breakdown have been '
          'reported with ophthalmic use. Avoid having the tip of the ophthalmic '
          'bottle touch the eye or surrounding structures to decrease risk for '
          'ocular infections.',
    ],
    pregnancyNote: 'Pregnancy category is “C” for ophthalmic use and systemic use '
        'prior to 30 wk gestation; and “X” for systemic use at 30 wk '
        'gestation and greater. Avoid systemic use at >30 wk gestation due '
        'to increased risk for premature closure of the fetal ductus '
        'arteriosus. Limit dose and duration of systemic use at 20–30 wk '
        'gestation for concerns of fetal renal dysfunction and '
        'oligohydramnios.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1060–1061',
  ),
];
