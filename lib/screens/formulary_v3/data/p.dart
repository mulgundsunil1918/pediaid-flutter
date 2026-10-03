// =============================================================================
// output/p.dart — Drug Formulary 3.0, letter P
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyP` per file; entries in book order.
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

const List<DrugEntryV3> formularyP = [
  // PALIVIZUMAB — PDF p. 341–342 (printed 1150–1151)
  DrugEntryV3(
    name: 'PALIVIZUMAB',
    brandNames: 'Synagis',
    drugClass: 'Monoclonal antibody',
    iconRow: '',
    formulations: [
      'Injection, solution: 100 mg/mL (0.5, 1 mL; single use); contains glycine '
          'and histidine',
    ],
    doseSections: [
      DoseSection(
        heading: 'RSV prophylaxis during RSV season for the following age and clinical '
            'criteria (nirsevimab is now considered the agent of choice; see '
            'latest edition of Red Book for most recent indications).',
        lines: [
          DoseLine('Following recommendations are from Pediatrics 2014;134(2):415–420.'),
          DoseLine(
            'Candidates for recommended use:',
            isHeading: true,
          ),
          DoseLine(
            '<12 mo of age (one of the following):',
            isHeading: true,
          ),
          DoseLine('Born at <29 weeks gestation; OR'),
          DoseLine('With chronic lung disease (CLD) of prematurity (<32 weeks gestation '
              'requiring >21% oxygen for at least 28 days after birth); OR'),
          DoseLine('With hemodynamically significant congenital heart disease'),
          DoseLine(
            '<24 mo of age:',
            isHeading: true,
          ),
          DoseLine('Born at ≤32 weeks gestation with CLD requiring medical therapy (e.g., ≥28 '
              'days of supplemental oxygen, bronchodilator, diuretics, or chronic '
              'steroids) within 6 mo prior to start of RSV season'),
          DoseLine(
            'Candidates for consideration:',
            isHeading: true,
          ),
          DoseLine(
            '<12 mo of age (one of the following):',
            isHeading: true,
          ),
          DoseLine('With congenital airway abnormalities or neuromuscular disorders that '
              'decrease ability to manage airway secretions; OR'),
          DoseLine('With cystic fibrosis with clinical evidence of CLD and/or nutritional '
              'compromise'),
          DoseLine(
            '≤24 mo of age (one of the following):',
            isHeading: true,
          ),
          DoseLine('With cystic fibrosis with severe lung disease (previous pulmonary '
              'exacerbation in first year of life or abnormal chest x-ray) or weight for '
              'length less than the 10th percentile; OR'),
          DoseLine('Profoundly immunocompromised; OR'),
          DoseLine('Undergoing cardiac transplantation during RSV season'),
          DoseLine(
            'DOSE:',
            isHeading: true,
          ),
          DoseLine('≤24 mo old: 15 mg/kg/dose IM Q monthly just prior to and during the RSV '
              'season. Maximum of five doses per RSV season is recommended by the AAP. '
              'Therapy should be discontinued if child experiences breakthrough RSV '
              'hospitalization.'),
        ],
      ),
    ],
    remarks: [
      'RSV season is typically November through April in the northern hemisphere '
          'but may begin earlier or persist later in certain communities. This '
          'infection pattern was significantly altered in 2020–2022 due to the '
          'implementation of COVID-19 prevention strategies of masking and social '
          'distancing. Check with state and county health departments and the '
          'Centers for Disease Control and Prevention for the current RSV activity '
          'in your region.',
      'IM is currently the only route of administration, so use with caution in '
          'patients with thrombocytopenia or any coagulation disorder. The following '
          'adverse effects have been reported at slightly higher incidences when '
          'compared with placebo: rhinitis, rash, pain, increased liver enzymes, '
          'pharyngitis, cough, wheeze, diarrhea, vomiting, conjunctivitis, and '
          'anemia. Rare acute hypersensitivity reactions have been reported (first '
          'or subsequent doses).',
      'Does not interfere with the response to routine childhood vaccines. May '
          'interfere with immunologic-based RSV diagnostic tests (some antigen '
          'detection–based assays and viral culture assays) but not with reverse '
          'transcriptase-polymerase chain reaction–based assays.',
      'Palivizumab is currently indicated for RSV prophylaxis in high-risk '
          'infants only. Efficacy and safety have not been demonstrated for '
          'treatment of RSV.',
      'Cardiopulmonary bypass and extracorporeal membrane oxygenation (ECMO) '
          'will significantly reduce serum concentrations; administer a dose '
          'immediately after the bypass procedure or ECMO even if it is <1 mo from '
          'the previous dose.',
      'Each dose should be administered IM in the anterolateral aspect of the '
          'thigh. It is recommended to divide doses with total injection volumes >1 '
          'mL. Avoid injection in the gluteal muscle because of risk for damage to '
          'the sciatic nerve.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1150–1151',
  ),
  // PANCRELIPASE/PANCREATIC ENZYMES — PDF p. 342–344 (printed 1151–1153)
  DrugEntryV3(
    name: 'PANCRELIPASE/PANCREATIC ENZYMES',
    brandNames: 'Creon Pancreaze Pertzye Viokace and Zenpep',
    drugClass: 'Pancreatic enzyme',
    iconRow: '',
    formulations: [
      'ᵃEnterically coated microspheres.',
      'ᵇEnteric coated minitab.',
      'ᶜContains bicarbonate.',
      'ᵈEnteric coated beads.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Delayed-Release Enterically Coated Beads, Microspheres, or Minitabs '
            'in Capsules (Porcine Derived)',
        table: DoseTable(
          headers: ['Product', 'Lipase (USP) Units', 'Amylase (USP) Units', 'Protease (USP) Units'],
          rows: [
            DoseTableRow(['Creonᵃ', '', '', '']),
            DoseTableRow(['3', '3,000', '15,000', '9,500']),
            DoseTableRow(['6', '6,000', '30,000', '19,000']),
            DoseTableRow(['12', '12,000', '60,000', '38,000']),
            DoseTableRow(['24', '24,000', '120,000', '76,000']),
            DoseTableRow(['36', '36,000', '180,000', '114,000']),
            DoseTableRow(['Pancreazeᵇ', '', '', '']),
            DoseTableRow(['MT 2', '2,600', '15,200', '8,800']),
            DoseTableRow(['MT 4', '4,200', '24,600', '14,200']),
            DoseTableRow(['MT 10', '10,500', '61,500', '35,500']),
            DoseTableRow(['MT 16', '16,800', '98,400', '56,800']),
            DoseTableRow(['MT 20', '21,000', '83,900', '54,700']),
            DoseTableRow(['MT 37', '37,000', '149,900', '97,300']),
            DoseTableRow(['Pertzyeᵃ,ᶜ', '', '', '']),
            DoseTableRow(['4', '4,000', '15,125', '14,375']),
            DoseTableRow(['8', '8,000', '30,250', '28,750']),
            DoseTableRow(['16', '16,000', '60,500', '57,500']),
            DoseTableRow(['24', '24,000', '90,750', '86,250']),
            DoseTableRow(['Zenpepᵈ', '', '', '']),
            DoseTableRow(['3', '3,000', '14,000', '10,000']),
            DoseTableRow(['5', '5,000', '24,000', '17,000']),
            DoseTableRow(['10', '10,000', '42,000', '32,000']),
            DoseTableRow(['15', '15,000', '63,000', '47,000']),
            DoseTableRow(['20', '20,000', '84,000', '63,000']),
            DoseTableRow(['25', '25,000', '105,000', '79,000']),
            DoseTableRow(['40', '40,000', '168,000', '126,000']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Tabs (Porcine Derived)',
        table: DoseTable(
          headers: ['Product', 'Lipase (USP) Units', 'Amylase (USP) Units', 'Protease (USP) Units'],
          rows: [
            DoseTableRow(['Viokace', '', '', '']),
            DoseTableRow(['10', '10,440', '39,150', '39,150']),
            DoseTableRow(['20', '20,880', '78,300', '78,300']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Initial doses (actual requirements are patient specific):',
        lines: [
          DoseLine(
            'Enterically coated microspheres and microtabs:',
            isHeading: true,
          ),
          DoseLine('Newborn–1 yr: 2000–4000 U lipase per 120 mL (formula or breast milk) or '
              'per breast-feeding'),
          DoseLine('Child >1 yr–<4 yr: 1000 U lipase/kg/meal'),
          DoseLine('Child ≥4 yr and adult: 500 U lipase/kg/meal'),
          DoseLine('Max. dose (child–adult): 2500 U lipase/kg/meal, or 10,000 U lipase/kg/24 '
              'hr, or 4000 U lipase/g fat/24 hr'),
          DoseLine('Total daily dose should include approximately three meals and two to '
              'three snacks per day. Snack doses are approximately half of meal doses, '
              'depending on the amount of fat and food consumed.'),
        ],
      ),
    ],
    remarks: [
      'May cause occult GI bleeding, allergic reactions to porcine proteins, '
          'hyperuricemia, and hyperuricosuria with high doses. Hypersensitivity '
          'reactions have been reported. Dose should be titrated to eliminate '
          'diarrhea and to minimize steatorrhea. Do not crush or chew microspheres '
          'or microtabs as it will result in oral mucosa irritation and/or loss of '
          'enzyme activity. Concurrent administration with H₂ antagonists or gastric '
          'acid pump inhibitors may enhance enzyme efficacy. Doses higher than 6000 '
          'U lipase/kg/meal have been associated with colonic strictures or '
          'fibrosing colonopathy in children <12 yr. Non–enterically coated dosage '
          'forms (e.g., powder and tablet) are not preferred, owing to potential GI '
          'mucosal ulceration. Patients who are unable to swallow capsules intact '
          'may mix the contents with small amount of acidic soft foods (pH ≤4.5; '
          'such as applesauce), swallow immediately after mixing, and follow with '
          'infant formula, breast milk, or fluids to ensure complete ingestion of '
          'the medication.',
      'Avoid use of generic pancreatic enzyme products because they have been '
          'associated with treatment failures. Products not approved by the U.S. '
          'Food and Drug Administration are no longer allowed to be distributed in '
          'the United States.',
      'Patients requiring enzyme supplementation who receive enteral feeding via '
          'a feeding tube may alternatively use a digestive enzyme cartridge '
          '(RELiZORB).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1151–1153',
  ),
  // PANTOPRAZOLE — PDF p. 344–345 (printed 1153–1154)
  DrugEntryV3(
    name: 'PANTOPRAZOLE',
    brandNames: 'Protonix and generics',
    drugClass: 'Gastric acid pump inhibitor',
    iconRow: '',
    formulations: [
      'Tab, delayed release:',
      'Protonix and generics: 20, 40 mg',
      'Injection: 40 mg; contains edetate sodium',
      'Injection, pre-mixed in normal saline: 40 mg/100 mL, 80 mg/100 mL; '
          'preservative free',
      'Oral suspension: 2 mg/mL; contains 0.25 mEq sodium bicarbonate per 1 mg '
          'drug',
      'Enterically coated granules for delayed-release oral suspension:',
      'Protonix and generics: 40-mg packets (30s); may contain polysorbate 80',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child (see remarks):',
        lines: [
          DoseLine(
            'PO:',
            isHeading: true,
          ),
          DoseLine(
            'GERD (limited data):',
            isHeading: true,
          ),
          DoseLine('Infant, child, and adolescent: 1–2 mg/kg/24 hr PO once daily; max. dose: '
              '40 mg/24 hr × 4–8 weeks'),
          DoseLine(
            'GERD with erosive esophagitis:',
            isHeading: true,
          ),
          DoseLine('1–5 yr (limited data): 0.3, 0.6, or 1.2 mg/kg/24 hr PO once daily all '
              'improved GERD symptoms in an 8-wk multicenter, randomized '
              'placebo-controlled trial for 60 subjects with GERD and histologic/erosive '
              'esophagitis'),
          DoseLine(
            '≥5 yr (up to 8 wk of therapy):',
            isHeading: true,
          ),
          DoseLine('15–<40 kg: 20 mg PO once daily'),
          DoseLine('≥40 kg: 40 mg PO once daily'),
          DoseLine(
            'IV (when PO route not feasible; convert back to PO as soon as the patient '
                'is able to):',
            isHeading: true,
          ),
          DoseLine(
            'GERD with erosive esophagitis:',
            isHeading: true,
          ),
          DoseLine(
            '3 mo–<1 yr:',
            isHeading: true,
          ),
          DoseLine('<12.5 kg: 0.8 mg/kg IV once daily'),
          DoseLine('≥12.5 kg: 10 mg IV once daily'),
          DoseLine(
            '1–17 yr:',
            isHeading: true,
          ),
          DoseLine('≤15 kg: 10 mg IV once daily'),
          DoseLine('>15–≤40 kg: 20 mg IV once daily'),
          DoseLine('>40 kg: 40 mg IV once daily'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine(
            'GERD with erosive esophagitis:',
            isHeading: true,
          ),
          DoseLine('PO: 40 mg once daily × 8–16 weeks'),
          DoseLine('IV: 40 mg once daily × 7–10 days'),
          DoseLine('Peptic ulcer: 40–80 mg PO once daily × 4–8 weeks'),
          DoseLine(
            'Hypersecretory conditions:',
            isHeading: true,
          ),
          DoseLine('PO: 40 mg BID; dose may be increased as needed up to a max. dose of 240 '
              'mg/24 hr'),
          DoseLine('IV: 80 mg Q12 hr; dose may be increased as needed to Q8 hr (max. dose: '
              '240 mg/24 hr). Therapy >7 days at 240 mg/24 hr has not been evaluated.'),
        ],
      ),
    ],
    remarks: [
      'Convert from IV to PO therapy as soon as patient is able to tolerate PO. '
          'Common side effects include diarrhea and headache. May cause transient '
          'elevation in liver function tests. Like other proton pump inhibitors '
          '(PPIs), may increase risk for Clostridium difficile–associated diarrhea. '
          'Hypomagnesemia has been reported with long-term use. Hypersensitivity '
          'reactions (e.g., anaphylaxis, shock, angioedema, bronchospasm, acute '
          'interstitial nephritis, toxic epidermal necrolysis, drug rash with '
          'eosinophilia and systemic symptoms, and urticaria), agranulocytosis, '
          'pancytopenia, hypomagnesemia, and taste disorders have been reported. '
          'Fundic gland polyps have been associated with long-term use of PPIs.',
      'May interfere with serum chromogranin A (CgA) diagnostic test for '
          'neuroendocrine tumors; discontinue use at least 14 days prior to testing. '
          'False-positive test for urine cannabinoid screen may occur.',
      'Drug is a substrate for cytochrome P-450 (CYP) 2C19 (major), CYP2D6 '
          '(minor), and CYP3A3/3A4 (minor) isoenzymes. Recommended dosage '
          'modification for ultrarapid metabolizers of CYP2C19 is to increase the '
          'usual dose by fivefold. May decrease the absorption of itraconazole, '
          'ketoconazole, iron salts, and ampicillin esters. May increase the '
          'effect/toxicity of methotrexate. May cause false-positive elevated serum '
          'CgA levels.',
      'Children 1–2 yr of age have demonstrated more rapid clearance of '
          'pantoprazole in pharmacokinetic studies; this age group may require '
          'higher doses. All oral doses may be taken with or without food. Do not '
          'crush or chew tablets. The extemporaneously compounded oral suspension '
          'may be less bioavailable owing to the loss of the enteric coating. '
          'Granules for delayed-release oral suspension product may be mixed with 5 '
          'mL apple juice (administer immediately followed by rinsing container with '
          'more apple juice), or sprinkled on 1 teaspoonful of applesauce '
          '(administer within 10 min); see package insert for nasogastric (NG) '
          'administration.',
      'For IV infusion, doses may be administered over 15 min at a concentration '
          'of 0.4–0.8 mg/mL or over 2 min at a concentration of 4 mg/mL. Midazolam '
          'and zinc are not compatible with the IV dosage form. Parenteral routes '
          'other than IV are not recommended.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1153–1154',
  ),
  // PAROMOMYCIN SULFATE — PDF p. 345–346 (printed 1154–1155)
  DrugEntryV3(
    name: 'PAROMOMYCIN SULFATE',
    brandNames: 'Humatin and generics',
    drugClass: 'Amebicide, antibiotic (aminoglycoside)',
    iconRow: '',
    formulations: [
      'Caps: 250 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Intestinal amebiasis (Entamoeba histolytica); Dientamoeba fragilis '
            'and Giardia lamblia infection:',
        lines: [
          DoseLine('Child and adult: 25–35 mg/kg/24 hr PO ÷ Q8 hr × 5–10 days (usually 7 days)'),
        ],
      ),
      DoseSection(
        heading: 'Cryptosporidiosis in immunocompromised or nutritionally deficient '
            '(limited efficacy data for infants and children with HIV):',
        lines: [
          DoseLine('Infant, child, and adolescent: 25–35 mg/kg/24 hr PO ÷ BID–QID for 14 days '
              'with or without azithromycin; max. dose: use adult dosage of 500 mg QID.'),
          DoseLine('Adult: 500 mg PO QID for 14–21 days'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in intestinal obstruction. Use with caution in ulcerative '
          'bowel lesions to avoid renal toxicity via systemic absorption. Drug is '
          'generally poorly absorbed and therefore not indicated for sole treatment '
          'of extraintestinal amebiasis. Side effects include GI disturbance, '
          'hematuria, rash, ototoxicity, and hypocholesterolemia. Bacterial '
          'overgrowth of nonsusceptible organisms, including fungi, may occur. May '
          'decrease the effects of digoxin.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1154–1155',
  ),
  // PAROXETINE — PDF p. 346–347 (printed 1155–1156)
  DrugEntryV3(
    name: 'PAROXETINE',
    brandNames: 'Paxil, Paxil CR, and generics',
    drugClass: 'Antidepressant, selective serotonin reuptake inhibitor',
    iconRow: '',
    formulations: [
      'Tabs (Paxil and generics): 10, 20, 30, 40 mg',
      'Caps: 7.5 mg',
      'Controlled-release tabs (Paxil CR and generics): 12.5, 25, 37.5 mg',
      'Oral suspension (Paxil and generics): 10 mg/5 mL (250 mL); contains '
          'saccharin and parabens',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child (use immediate-release dosage forms):',
        lines: [
          DoseLine('Depression: Well-controlled clinical trials have failed to demonstrate '
              'efficacy in children. The FDA recommends paroxetine NOT be used for this '
              'indication. Use should be reserved for refractory cases.'),
          DoseLine('Obsessive-compulsive disorder (limited data, based on a 10-wk randomized '
              'controlled trial in 207 children 7–17 yr; mean age 11.1 + 3.03 yr): Start '
              'with 10 mg PO once daily. If needed, adjust upward by increasing dose no '
              'more than 10 mg/24 hr no more frequently than Q7 days up to a max. dose '
              'of 60 mg/24 hr. Mean doses of 20.3 mg/24 hr (children) and 26.8 mg/24 hr '
              '(adolescents) were used.'),
          DoseLine('Social anxiety disorder (limited data; 8–17 yr): Start with 10 mg PO once '
              'daily. If needed, increase dose by 10 mg/24 hr no more frequently than Q7 '
              'days up to a max. dose of 50 mg/24 hr.'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine(
            'Depression:',
            isHeading: true,
          ),
          DoseLine('Immediate-release dosage forms: Start with 20 mg PO QAM × 4 wk. If no '
              'clinical improvement, increase dose by 10 mg/24 hr Q7 days PRN up to a '
              'max. dose of 50 mg/24 hr.'),
          DoseLine('Controlled-release tabs (Paxil CR and generics): Start with 25 mg PO QAM '
              '× 4 wk. If no improvement, increase dose by 12.5 mg/24 hr Q7 days PRN up '
              'to a max. dose of 62.5 mg/24 hr.'),
          DoseLine('Obsessive-compulsive disorder (immediate release): Start with 20 mg PO '
              'once daily; increase dose by 10 mg/24 hr Q7 days PRN up to a max. dose of '
              '60 mg/24 hr. Usual dose is 40 mg PO once daily. Rapid metabolizers may '
              'require doses as high as 100 mg/24 hr.'),
          DoseLine(
            'Panic disorder:',
            isHeading: true,
          ),
          DoseLine('Immediate-release dosage forms: Start with 10 mg PO QAM; increase dose by '
              '10 mg/24 hr Q7 days PRN up to a max. dose of 60 mg/24 hr.'),
          DoseLine('Paxil CR: Start with 12.5 mg PO QAM; increase dose by 12.5 mg/24 hr Q7 '
              'days PRN up to a max. dose of 75 mg/24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in patients taking monoamine oxidase inhibitors (MAOIs) '
          'and within 14 days of discontinuing MAOIs, and patients taking linezolid, '
          'methylene blue, pimozide, or thioridazine. Use with caution in patients '
          'with history of seizures, renal or hepatic impairment, cardiac disease, '
          'suicidal concerns, mania/hypomania, concurrent use with other '
          'serotonergic drugs (e.g., triptans, fentanyl, lithium, tramadol, '
          'amphetamines, or St. John’s wort), and diuretic use. Patients with severe '
          'renal or hepatic impairment should initiate therapy at 10 mg/24 hr and '
          'increase dose as needed up to a max. of 40 mg/24 hr.',
      'Common side effects include anxiety, nausea, anorexia, sexual '
          'dysfunction, and decreased appetite. Monitor for clinical worsening of '
          'depression and suicidal ideation/behavior following the initiation of '
          'therapy or after dose changes. Stevens-Johnson syndrome has been reported.',
      'Paroxetine is an inhibitor and substrate for cytochrome P-450 (CYP) 2D6. '
          'Ultrametabolizers of CYP2D6 should avoid use of paroxetine and use an '
          'alternative medication not metabolized by this enzyme system. A 50% '
          'initial dose reduction for poor CYP2D6 metabolizers has been recommended. '
          'May increase the effects/toxicity of tricyclic antidepressants, '
          'theophylline, and warfarin. May decrease the effects of tamoxifen. '
          'Cimetidine, ritonavir, MAOIs (fatal serotonin syndrome), '
          'dextromethorphan, phenothiazines, and class IC antiarrhythmics may '
          'increase the effect/toxicity of paroxetine. Weakness, hyperreflexia, and '
          'poor coordination have been reported when taken with sumatriptan.',
      'Do not discontinue therapy abruptly; may cause sweating, dizziness, '
          'confusion, and tremor. May be taken with or without food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1155–1156',
  ),
  // PENICILLIN G PREPARATIONS—AQUEOUS POTASSIUM AND SODIUM — PDF p. 347–348 (printed 1156–1157)
  DrugEntryV3(
    name: 'PENICILLIN G PREPARATIONS—AQUEOUS POTASSIUM AND SODIUM',
    brandNames: 'Pfizerpen and generics',
    drugClass: 'Antibiotic, aqueous penicillin',
    iconRow: '',
    formulations: [
      'Injection (K⁺): 5, 20 million units (contains 1.7 mEq K and 0.3 mEq Na/1 '
          'million units penicillin G)',
      'Premixed frozen injection (K⁺): 2 million units in 50 mL dextrose 2.3%; 3 '
          'million units in 50 mL dextrose 0.7% (contains 1.7 mEq K and 0.3 mEq Na/1 '
          'million units penicillin G)',
      'Injection (Na⁺): 5 million units (contains 2 mEq Na/1 million units '
          'penicillin G)',
      'Conversion: 250 mg = 400,000 units',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate (IM/IV; use higher end of dosage range for meningitis and '
            'severe infections):',
        lines: [
          DoseLine(
            '≤34 weeks gestation:',
            isHeading: true,
          ),
          DoseLine('≤7 days old: 100,000–200,000 units/kg/24 hr ÷ Q12 hr'),
          DoseLine('8–28 days old: 150,000–300,000 units/kg/24 hr ÷ Q8 hr'),
          DoseLine(
            '>34 weeks gestation:',
            isHeading: true,
          ),
          DoseLine(
            '≤7 days old:',
            isHeading: true,
          ),
          DoseLine('General dosing: 100,000 units/kg/24 hr ÷ Q12 hr'),
          DoseLine('Meningitis and severe infection: 300,000 units/kg/24 hr ÷ Q8 hr'),
          DoseLine(
            '8–28 days old:',
            isHeading: true,
          ),
          DoseLine('General dosing: 150,000 units/kg/24 hr ÷ Q8 hr'),
          DoseLine('Meningitis and severe infection: 400,000 units/kg/24 hr ÷ Q6 hr'),
          DoseLine(
            'Group B streptococcal meningitis:',
            isHeading: true,
          ),
          DoseLine('≤7 days old: 450,000 units/kg/24 hr ÷ Q8 hr'),
          DoseLine('8–28 days old: 500,000 units/kg/24 hr ÷ Q4–6 hr'),
          DoseLine(
            'Congenital syphilis (total of 10 days of therapy; if >1 day of therapy is '
                'missed, restart the entire course):',
            isHeading: true,
          ),
          DoseLine('≤7 days old: 100,000 units/kg/24 hr IV ÷ Q12 hr; increase to the '
              'following dosage at day 8 of life'),
          DoseLine('8–28 days old: 150,000 units/kg/24 hr IV ÷ Q8 hr'),
          DoseLine('>28–60 days old: 200,00 units/kg/24 hr IV ÷ Q6 hr; if full-term neonate, '
              'may receive higher dose of 300,000 units/kg/24 hr IV ÷ Q4 hr'),
        ],
      ),
      DoseSection(
        heading: 'Infant, child, and adolescent:',
        lines: [
          DoseLine(
            'IM/IV (use higher end of dosage range and Q4 hr interval for meningitis '
                'and severe infections):',
            isHeading: true,
          ),
          DoseLine('100,000–400,000 units/kg/24 hr ÷ Q4–6 hr; max. dose: 24 million units/24 '
              'hr'),
          DoseLine(
            'Neurosyphilis:',
            isHeading: true,
          ),
          DoseLine('Infant and child: 200,000–300,000 units/kg/24 hr IV ÷ Q4–6 hr × 10–14 '
              'days; max. dose: 24 million units/24 hr'),
          DoseLine('Adolescent: 3–4 million units IV Q4 hr × 10–14 days; max. dose: 24 '
              'million units/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Moderate/severe infection (IM/IV): 12–24 million units/24 hr ÷ Q4–6 hr; '
              'lower doses may be indicated for other indications'),
          DoseLine('Neurosyphilis: 18–24 million units/24 hr IV ÷ Q4 hr × 10–14 days'),
        ],
      ),
    ],
    remarks: [
      'Use penicillin V potassium for oral use. Side effects: anaphylaxis, '
          'urticaria, hemolytic anemia, interstitial nephritis, Jarisch-Herxheimer '
          'reaction (syphilis). Preparations containing potassium and/or sodium '
          'salts may alter serum electrolytes. T₁/₂ = 30 min; may be prolonged by '
          'concurrent use of probenecid. For meningitis, use higher daily dose at '
          'shorter dosing intervals. For the treatment of anthrax (Bacillus '
          'anthracis), see https://www.cdc. gov/anthrax/about/index.html for '
          'additional information. Adjust dose in renal impairment (see Chapter 32).',
      'Tetracyclines, chloramphenicol, and erythromycin may antagonize '
          'penicillin’s activity. Probenecid increases penicillin levels. May cause '
          'false-positive or false-negative urinary glucose level (Clinitest '
          'method), false-positive direct Coombs test, and false-positive urinary '
          'and/or serum protein levels.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1156–1157',
  ),
  // PENICILLIN G PREPARATIONS—BENZATHINE — PDF p. 348–349 (printed 1157–1158)
  DrugEntryV3(
    name: 'PENICILLIN G PREPARATIONS—BENZATHINE',
    brandNames: 'Bicillin L-A, Extencilline, Lentocilin',
    drugClass: 'Antibiotic, penicillin (very-long-acting IM)',
    iconRow: '',
    formulations: [
      'Injection for IM use:',
      'Bicillin L-A: 600,000 units/mL (1, 2, 4 mL); contains parabens and '
          'povidone',
      'Extencilline: 1,200,000 and 2,400,000 units; contains soybean lecithin '
          'and oil; either vial is diluted with 5 mL sterile water for injection or '
          'lidocaine (0.5% or 1%)',
      'Lentocilin: 1,200,000 units; contains polysorbate 80 and soybean '
          'lecithin; vial is diluted with 4 mL of supplied diluent',
      'Injection should be IM only.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Group A streptococci:',
        lines: [
          DoseLine('Infant and child: 25,000–50,000 units/kg/dose IM × 1. Max. dose: 1.2 '
              'million units/dose'),
          DoseLine(
            'OR:',
            isHeading: true,
          ),
          DoseLine('>1 mo and <27 kg: 600,000 units/dose IM × 1'),
          DoseLine('≥27 kg and adult: 1.2 million units/dose IM × 1'),
        ],
      ),
      DoseSection(
        heading: 'Rheumatic fever prophylaxis (Q3 wk administration is recommended for '
            'high-risk situations):',
        lines: [
          DoseLine('Infant and child (>1 mo and <27 kg): 600,000 units/dose IM Q3–4 wk'),
          DoseLine('Child ≥27 kg and adult: 1.2 million units/dose IM Q3–4 wk'),
        ],
      ),
      DoseSection(
        heading: 'Congenital syphilis (for cases of low probability of disease; aqueous '
            'penicillin is the drug of choice):',
        lines: [
          DoseLine('Neonate: 50,000 units/kg/dose IM × 1'),
        ],
      ),
      DoseSection(
        heading: 'Syphilis (if >1 day of therapy is missed, restart the entire course; '
            'divide total dose into two injection sites):',
        lines: [
          DoseLine(
            'Infant and child:',
            isHeading: true,
          ),
          DoseLine('Primary, secondary, and early latent syphilis (<1-yr duration): 50,000 '
              'units/kg/dose IM × 1'),
          DoseLine('Late latent syphilis or latent syphilis of unknown duration: 50,000 '
              'units/kg/dose IM Q7 days × 3 doses'),
          DoseLine('Max. dose: 2.4 million units/dose'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Primary, secondary, and early latent syphilis (<1-yr duration): 2.4 '
              'million units/dose IM × 1'),
          DoseLine('Late latent syphilis or latent syphilis of unknown duration: 2.4 million '
              'units/dose IM Q7 days × 3 doses'),
        ],
      ),
    ],
    remarks: [
      'Provides sustained levels for 2–4 wk. Use with caution in renal failure, '
          'asthma, glucose-6-phosphate dehydrogenase deficiency (risk for '
          'methemoglobinemia), and cephalosporin hypersensitivity. Side effects and '
          'drug interactions same as for Penicillin G Preparations–Aqueous Potassium '
          'and Sodium. Injection site reactions are common. Severe cutaneous '
          'reactions (e.g., Stevens-Johnson syndrome, toxic epidermal necrolysis, '
          'and drug rash with eosinophilia and systemic symptoms) have been reported.',
      'Deep IM administration only. Do not administer intravenously (cardiac '
          'arrest and death may occur), and do not inject into or near an artery or '
          'nerve (may result in permanent neurologic damage and necrosis/sloughing '
          'at the injection site).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1157–1158',
  ),
  // PENICILLIN G PREPARATIONS—PENICILLIN G BENZATHINE AND PENICILLIN G PROCAINE — PDF p. 349–350 (printed 1158–1159)
  DrugEntryV3(
    name: 'PENICILLIN G PREPARATIONS—PENICILLIN G BENZATHINE AND PENICILLIN G '
        'PROCAINE',
    brandNames: 'Bicillin C-R, Bicillin C-R 900/300',
    drugClass: 'Antibiotic, penicillin (very-long-acting IM)',
    iconRow: '',
    formulations: [
      'Bicillin CR: 600,000 units penicillin G procaine + 600,000 units '
          'penicillin G benzathine/mL to provide 1,200,000 units penicillin per 2 mL '
          '(2 mL Tubex syringe)',
      'Bicillin CR (900/300): 300,000 units penicillin G procaine + 900,000 '
          'units penicillin G benzathine per 2 mL (2 mL Tubex syringe)',
      'All preparations contain parabens and povidone.',
      'Injection should be for IM use only.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Dosage based on total amount of penicillin.',
      ),
      DoseSection(
        heading: 'Group A streptococci (see remarks):',
        lines: [
          DoseLine(
            'Infant and child (Bicillin CR):',
            isHeading: true,
          ),
          DoseLine('<14 kg: 600,000 units/dose IM × 1'),
          DoseLine('14–<27 kg: 900,000–1,200,000 units/dose IM × 1'),
          DoseLine(
            'Child ≥27 kg and adult:',
            isHeading: true,
          ),
          DoseLine('Bicillin C-R: 2,400,000 units/dose IM × 1'),
          DoseLine('Bicillin C-R 900/300: 1,200,000 units/dose IM × 1'),
        ],
      ),
      DoseSection(
        heading: 'Pneumococcal infection (non-CNS):',
        lines: [
          DoseLine('Dosed Q2–3 days until afebrile for 48 hr (see remarks)'),
          DoseLine(
            'Infant and child:',
            isHeading: true,
          ),
          DoseLine('Bicillin C-R: 600,000 units/dose IM'),
          DoseLine('Bicillin C-R 900/300: 1,200,000 units/dose IM'),
          DoseLine('Adult (Bicillin C-R or Bicillin C-R 900/300): 1,200,000 units/dose IM'),
        ],
      ),
    ],
    remarks: [
      'This preparation provides early peak levels in addition to prolonged '
          'levels of penicillin in the blood. Do not use this product to treat '
          'syphilis; treatment failure can occur. Use with caution in renal failure, '
          'asthma, significant allergies, glucose-6-phosphate dehydrogenase '
          'deficiency (risk for methemoglobinemia), and cephalosporin '
          'hypersensitivity. Severe cutaneous reactions (e.g., Stevens-Johnson '
          'syndrome, toxic epidermal necrolysis, and drug rash with eosinophilia and '
          'systemic symptoms) have been reported. The addition of procaine '
          'penicillin has not been shown to be more efficacious than benzathine '
          'alone. However, it may reduce injection discomfort.',
      'Deep IM administration only. Do not administer intravenously (cardiac '
          'arrest and death may occur), and do not inject into or near an artery or '
          'nerve (may result in permanent neurologic damage and necrosis/sloughing '
          'at the injection site).',
      'Side effects and drug interactions same as for Penicillin G '
          'Preparations–Aqueous Potassium and Sodium. Immune hypersensitivity '
          'reaction has been reported.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1158–1159',
  ),
  // PENICILLIN V POTASSIUM — PDF p. 350 (printed 1159)
  DrugEntryV3(
    name: 'PENICILLIN V POTASSIUM',
    brandNames: 'Generics; previously available as Veetids',
    drugClass: 'Antibiotic, penicillin',
    iconRow: '',
    formulations: [
      'Tabs: 250, 500 mg',
      'Oral solution: 125 mg/5 mL, 250 mg/5 mL (100, 200 mL); may contain '
          'saccharin',
      'Contains 0.7 mEq potassium/250 mg drug',
      'Conversion: 250 mg = 400,000 units',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infant and child:',
        lines: [
          DoseLine('25–75 mg/kg/24 hr PO ÷ Q6–8 hr; max. dose: 2 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adolescent and adult:',
        lines: [
          DoseLine('125–500 mg/dose PO Q6–8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Acute group A streptococcal pharyngitis (use BID dosing regimen ONLY '
            'if good compliance is expected):',
        lines: [
          DoseLine('Child <27 kg: 250 mg PO BID–TID × 10 days'),
          DoseLine('Child ≥27 kg, adolescent, and adult: 500 mg PO BID–TID × 10 days'),
        ],
      ),
      DoseSection(
        heading: 'Rheumatic fever prophylaxis, and pneumococcal prophylaxis for sickle '
            'cell disease and functional or anatomic asplenia (regardless of '
            'immunization status):',
        lines: [
          DoseLine('2 mo–<3 yr: 125 mg PO BID'),
          DoseLine('3–5 yr: 250 mg PO BID; for sickle cell and asplenia, use may be '
              'discontinued after 5 yr of age if child received recommended pneumococcal '
              'immunizations and did not experience invasive pneumococcal infection'),
        ],
      ),
      DoseSection(
        heading: 'Recurrent rheumatic fever prophylaxis:',
        lines: [
          DoseLine('Child and adult: 250 mg PO BID'),
        ],
      ),
    ],
    remarks: [
      'See Penicillin G Preparations–Aqueous Potassium and Sodium for side '
          'effects and drug interactions. GI absorption is better than penicillin G. '
          'Note: Must be taken 1 hr before or 2 hr after meals. Penicillin will '
          'prevent rheumatic fever if started within 9 days of the acute illness. '
          'Adjust dose in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1159',
  ),
  // PENTAMIDINE ISETHIONATE — PDF p. 351 (printed 1160)
  DrugEntryV3(
    name: 'PENTAMIDINE ISETHIONATE',
    brandNames: 'Pentam 300, NebuPent, and generics',
    drugClass: 'Antibiotic, antiprotozoal',
    iconRow: '',
    formulations: [
      'Injection (Pentam 300 and generics): 300 mg',
      'Inhalation (NebuPent and generics): 300 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Treatment (child and adult):',
        lines: [
          DoseLine('Pneumocystis jiroveci (carinii): 4 mg/kg/24 hr IM/IV once daily × 14–21 '
              'days (IV is the preferred route)'),
          DoseLine('Trypanosomiasis (Trypanosoma gambiense, T. rhodesiense without central '
              'nervous system involvement): 4 mg/kg/24 hr IM/IV once daily × 7–10 days'),
          DoseLine('Visceral leishmaniasis (Leishmania donovani, L. infantum, L. chagasi): '
              '2–4 mg/kg/dose IM/IV once daily for up to 15 doses'),
          DoseLine('Cutaneous leishmaniasis (Leishmania [Viannia] panamensis): 2–4 mg/kg/dose '
              'IM/IV once every other day × 4–7 doses'),
        ],
      ),
      DoseSection(
        heading: 'Prophylaxis (child and adult):',
        lines: [
          DoseLine(
            'P. jiroveci (carinii):',
            isHeading: true,
          ),
          DoseLine('IM/IV (IV is the preferred route): 4 mg/kg/dose Q3–4 wk (Q2 wk for '
              'hematopoietic stem cell transplant); max. single dose: 300 mg'),
          DoseLine(
            'Inhalation (use with Respigard II nebulizer):',
            isHeading: true,
          ),
          DoseLine('<5 yr: 9 mg/kg (max. dose: 300 mg/dose) Q month'),
          DoseLine('≥5 yr: 300 mg Q month'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in ventricular tachycardia, Stevens-Johnson syndrome, '
          'and daily doses >21 days. May cause hypoglycemia, hyperglycemia, '
          'hypotension (both IV and IM administration), nausea, vomiting, fever, '
          'mild hepatotoxicity, pancreatitis, megaloblastic anemia, nephrotoxicity, '
          'hypocalcemia, and granulocytopenia. Additive nephrotoxicity with '
          'aminoglycosides, amphotericin B, cisplatin, and vancomycin may occur. '
          'Aerosol administration may also cause bronchospasm, cough, oxygen '
          'desaturation, dyspnea, and loss of appetite. Infuse IV over 1–2 hr to '
          'reduce the risk of hypotension. Sterile abscess may occur at IM injection '
          'site.',
      'Adjust dose in renal impairment (see Chapter 32) with systemic use.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1160',
  ),
  // PENTOBARBITAL — PDF p. 351–352 (printed 1160–1161)
  DrugEntryV3(
    name: 'PENTOBARBITAL',
    brandNames: 'Generics; previously available as Nembutal',
    drugClass: 'Barbiturate',
    iconRow: '',
    formulations: [
      'Injection: 50 mg/mL (20, 50 mL); may contains propylene glycol and 10% '
          'alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hypnotic/preoperative sedation',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('IM: 2–6 mg/kg/dose. Max. dose: 100 mg'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('IM: 150–200 mg'),
        ],
      ),
      DoseSection(
        heading: 'Reduction in elevated intracranial pressure (adjunct therapy; patient '
            'must be intubated):',
        lines: [
          DoseLine('Barbiturate coma may be used if needed.'),
          DoseLine(
            'Child and adolescent:',
            isHeading: true,
          ),
          DoseLine('IV/IO: 1–3 mg/kg/dose'),
          DoseLine('IM/PR: 2–6 mg/kg/dose'),
          DoseLine('Max. dose: 100 mg/dose'),
        ],
      ),
      DoseSection(
        heading: 'Barbiturate coma',
        lines: [
          DoseLine(
            'Child and adult:',
            isHeading: true,
          ),
          DoseLine('IV: Loading dose: 10–15 mg/kg given slowly over 1–2 hr'),
          DoseLine('Maintenance: Begin at 1 mg/kg/hr. Usual range: 0.5–5 mg/kg/hr as needed'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in liver failure and history of porphyria. Use in '
          'preprocedure sedation has been replaced by other agents. Use with caution '
          'in hypovolemic shock, congestive heart failure, hypotension, and hepatic '
          'impairment. No advantage over phenobarbital for control of seizures. May '
          'cause drug-related isoelectric electroencephalogram. Do not administer '
          'for >2 wk in treatment of insomnia. May cause hypotension, arrhythmias, '
          'hypothermia, respiratory depression, and dependence.',
      'Onset of action: IM: 10–15 min; IV: 1 min. Duration of action: IV: 15 min.',
      'Administer IV at a rate of <50 mg/min.',
      'Therapeutic serum levels: sedation: 1–5 mg/L; hypnosis: 5–15 mg/L; coma: '
          '20–40 mg/L (steady state is achieved after 4–5 days of continuous IV '
          'dosing).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1160–1161',
  ),
  // PERMETHRIN — PDF p. 352 (printed 1161)
  DrugEntryV3(
    name: 'PERMETHRIN',
    brandNames: 'Elimite, Nix and generics',
    drugClass: 'Scabicidal agent',
    iconRow: '',
    formulations: [
      'Cream (Elimite and generics): 5% (60 g); contains 0.1% formaldehyde',
      'Liquid cream rinse/lotion (Nix Lice-Killing Crème Rinse–OTC and generics) '
          '[OTC]: 1% (59 mL with comb); may contain 20% isopropyl alcohol (1 or 2 '
          'bottles)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Pediculus humanus capitis, Phthirus pubis (>2 mo, child, and '
            'adolescent):',
        lines: [
          DoseLine('Head lice: Saturate hair and scalp and apply behind the ears and at the '
              'base of the neck with 1% cream rinse/lotion after shampooing, rinsing, '
              'and towel drying hair. Leave on for 10 min, then rinse. May repeat in 7 '
              'days. May be used for lice in other areas of the body (e.g., pubic lice) '
              'in same fashion. If the 1% cream rinse is resistant, the 5% cream may be '
              'used after shampooing, rinsing, and towel drying hair. Leave on for 8–14 '
              'hr overnight under a shower cap; then rinse off. May repeat in 7 days.'),
          DoseLine('Scabies: Apply 5% cream from neck to toe (head to toe for infants and '
              'toddlers); wash off with water in 8–14 hr. May repeat in 14 days if mites '
              'appear. Use in full-term infants <1 mo is safe and effective when applied '
              'for a 6-hr period.'),
        ],
      ),
    ],
    remarks: [
      'Ovicidal activity generally makes single-dose regimen adequate. However, '
          'resistance to permethrin has been reported. May cause pruritus, '
          'hypersensitivity, burning, stinging, erythema, and rash. For either lice '
          'or scabies, instruct patient to launder bedding and clothing. For lice, '
          'treat symptomatic contacts only. For scabies, treat all contacts even if '
          'asymptomatic.',
      'Avoid contact with eyes during application. Shake well before using. Do '
          'not use near eyes, inside of nose, mouth, or vagina, or for lice in '
          'eyebrows/eyelashes. Topical cream dosage form contains formaldehyde. '
          'Dispense 60 g per one adult or two small children.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1161',
  ),
  // PHENAZOPYRIDINE HCL — PDF p. 353 (printed 1162)
  DrugEntryV3(
    name: 'PHENAZOPYRIDINE HCL',
    brandNames: 'Pyridium, Azo-Urinary Pain Relief Maximum Strength [OTC], many '
        'other brands and generics',
    drugClass: 'Urinary analgesic',
    iconRow: '',
    formulations: [
      'Tabs: 95 mg [OTC] (12s, 30s), 99.5 mg [OTC] (24s, 72s), 100 mg, 200 mg',
      'Oral suspension: 10 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Urinary tract infection (use with an appropriate antibacterial agent):',
        lines: [
          DoseLine('Child 6–<12 yr: 12 mg/kg/24 hr PO ÷ TID until symptoms of lower urinary '
              'tract irritation are controlled or for 2 days. Max. dose: 200 mg/dose'),
          DoseLine('≥12 yr and adult: 190–200 mg PO TID until symptoms are controlled or for '
              '2 days'),
        ],
      ),
    ],
    remarks: [
      'May cause pruritus, rash, gastrointestinal distress, vertigo, and '
          'headache. Anaphylactoid-like reaction, methemoglobinemia, hemolytic '
          'anemia, and renal and hepatic toxicity have been reported, usually at '
          'overdosage levels. Colors urine orange; stains clothing. May also stain '
          'contact lenses and interfere with urinalysis tests based on spectrometry '
          'or color reactions. Give doses with or after meals.',
      'Avoid use in moderate/severe renal impairment; adjust dose in mild renal '
          'impairment (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1162',
  ),
  // PHENOBARBITAL — PDF p. 353–354 (printed 1162–1163)
  DrugEntryV3(
    name: 'PHENOBARBITAL',
    brandNames: 'Sezaby and generics; previously available as Luminal',
    drugClass: 'Barbiturate',
    iconRow: '',
    formulations: [
      'Tabs: 15, 16.2, 30, 32.4, 60, 64.8, 97.2, 100 mg',
      'Oral elixir or solution: 20 mg/5 mL (15, 473 mL); may contain 15% alcohol',
      'Injection: 65, 130 mg/mL (1 mL); may contain 10% alcohol and propylene '
          'glycol',
      'Sezaby: 100 mg; preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Status epilepticus:',
        lines: [
          DoseLine(
            'Loading dose, IV:',
            isHeading: true,
          ),
          DoseLine('Neonate, infant, and child: 15–20 mg/kg/dose (max. loading dose: 1000 mg) '
              'in a single or divided dose. May give additional 5 mg/kg doses Q20 min to '
              'a max. total of 30 mg/kg'),
          DoseLine('Seizures maintenance therapy (PO/IV): Monitor levels.'),
          DoseLine('Neonate: 3–5 mg/kg/24 hr ÷ once daily–BID'),
          DoseLine('Infant: 5–6 mg/kg/24 hr ÷ once daily–BID'),
          DoseLine('Child 1–5 yr: 6–8 mg/kg/24 hr ÷ once daily–BID'),
          DoseLine('Child 6–12 yr: 4–6 mg/kg/24 hr ÷ once daily–BID'),
          DoseLine('>12 yr: 1–3 mg/kg/24 hr ÷ once daily–BID'),
        ],
      ),
      DoseSection(
        heading: 'Hyperbilirubinemia (limited data; <12 yr):',
        lines: [
          DoseLine('3–8 mg/kg/24 hr PO ÷ BID–TID. Doses up to 12 mg/kg/24 hr have been used. '
              'Not recommended for biliary cirrhosis.'),
        ],
      ),
      DoseSection(
        heading: 'Preoperative sedation (child):',
        lines: [
          DoseLine('1–3 mg/kg/dose IM/IV/PO × 1. Give 60–90 min before procedure.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in porphyria, severe respiratory disease with dyspnea, or '
          'obstruction. Use with caution in hepatic or renal disease (reduce dose). '
          'IV administration may cause respiratory arrest or hypotension. Side '
          'effects include drowsiness, cognitive impairment, ataxia, hypotension, '
          'hepatitis, rash, respiratory depression, apnea, megaloblastic anemia, and '
          'anticonvulsant hypersensitivity syndrome. Paradoxic reaction in children '
          '(not dose related) may cause hyperactivity, irritability, or insomnia. '
          'Induces several liver enzymes (cytochrome P-450 1A2, 2A6, 2B6, 2C8/9, '
          '3A4), P-glycoprotein, and glucoronidation (UGT1A1), and thus decreases '
          'blood levels of many drugs (e.g., anticonvulsants). IV push not to exceed '
          '1 mg/kg/min.',
      'T₁/₂ is variable with age: neonates, 45–100 hr; infants, 20–133 hr; '
          'children, 37–73 hr. Owing to long half-life, consider other agents for '
          'sedation for procedures.',
      'Therapeutic levels: 15–40 mg/L. Recommended serum sampling time at steady '
          'state: trough level obtained within 30 min prior to the next scheduled '
          'dose after 10–14 days of continuous dosing.',
      'Adjust dose in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1162–1163',
  ),
  // PHENTOLAMINE MESYLATE — PDF p. 354–355 (printed 1163–1164)
  DrugEntryV3(
    name: 'PHENTOLAMINE MESYLATE',
    brandNames: 'OraVerse and generics; previously available as Regitine',
    drugClass: 'α-Adrenergic blocking agent; antidote, extravasation',
    iconRow: '',
    formulations: [
      'Injection: 5-mg vial; may contain mannitol',
      'Injection in solution for submucosal use:',
      'OraVerse: 0.4 mg/1.7 mL (1.7 mL in dental cartridges) (10s); contains '
          'edetate disodium',
    ],
    doseSections: [
      DoseSection(
        heading: 'Treatment of α-adrenergic drug extravasation (most effective within '
            '12 hr of extravasation):',
        lines: [
          DoseLine('All doses are five doses administered SC around the site of extravasation '
              'within 12 hr of extravasation (see the following table). Monitor for '
              'hypotension (blood pressure) Q15 min × 4 then Q1 hr × 2.'),
        ],
      ),
      DoseSection(
        heading: 'Weight-Based Dosing and Recommended Drug Concentration',
        table: DoseTable(
          headers: ['Patient Weight', 'Drug Concentration (Diluted With Preservative-Free NS)', 'Dose for Each Syringe ×5 Syringes', 'Total Dose From All 5 Syringes'],
          rows: [
            DoseTableRow(['<2.5 kg', '0.2 mg/mL', '0.1 mL', '0.1 mg']),
            DoseTableRow(['2.5–<5 kg', '0.2 mg/mL', '0.25 mL', '0.25 mg']),
            DoseTableRow(['5–<10 kg', '1 mg/mL', '0.1 mL', '0.5 mg']),
            DoseTableRow(['10–<20 kg', '1 mg/mL', '0.2 mL', '1 mg']),
            DoseTableRow(['20–<30 kg', '1 mg/mL', '0.4 mL', '2 mg']),
            DoseTableRow(['30–<40 kg', '1 mg/mL', '0.6 mL', '3 mg']),
            DoseTableRow(['40–<50 kg', '1 mg/mL', '0.8 mL', '4 mg']),
            DoseTableRow(['≥50 kg', '1 mg/mL', '1 mL', '5 mg']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Max. total dose:',
        lines: [
          DoseLine('Neonate: 2.5 mg'),
          DoseLine('Infant, child, adolescent, and adult: 0.1–0.2 mg/kg/dose or 5 mg'),
        ],
      ),
      DoseSection(
        heading: 'Diagnosis of pheochromocytoma:',
        lines: [
          DoseLine(
            'Child and adolescent:',
            isHeading: true,
          ),
          DoseLine('IV: 1 mg'),
          DoseLine('IM: 3 mg'),
          DoseLine('Adult: 5 mg/dose IV/IM'),
        ],
      ),
      DoseSection(
        heading: 'Hypertension, prior to surgery for pheochromocytoma, IM/IV:',
        lines: [
          DoseLine('Child: 0.05–0.1 mg/kg/dose up to a max. dose of 5 mg 1–2 hr before '
              'surgery, repeat Q2–4 hr PRN'),
          DoseLine('Adult: 5 mg/dose 1–2 hr before surgery, repeat Q2–4 hr PRN'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in myocardial infarction, coronary insufficiency, and '
          'angina. Use with caution in hypotension, arrhythmias, and cerebral '
          'vascular spasm/occlusion.',
      'For diagnosis of pheochromocytoma, patient should be resting in a supine '
          'position. A blood pressure reduction of more than 35 mm Hg systolic and '
          '24 mm Hg diastolic is considered a positive test for pheochromocytoma. '
          'For treatment of extravasation, use 27- to 30-gauge needle with multiple '
          'small injections, and monitor site closely because repeat doses may be '
          'necessary.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1163–1164',
  ),
  // PHENYLEPHRINE HCL — PDF p. 355–356 (printed 1164–1165)
  DrugEntryV3(
    name: 'PHENYLEPHRINE HCL',
    brandNames: 'Vazculep, Biorphen, Immphentiv, Neo-Synephrine, many others, and '
        'generics',
    drugClass: 'Adrenergic agonist',
    iconRow: '',
    formulations: [
      'Injection:',
      'Vazculep and generics: 10 mg/mL (1%) (1-, 2-, 5-, 10-mL vials); may '
          'contain metasulfites',
      'Biorphen and generics: 10 mg/mL (1%) (1-mL ampules); preservative and '
          'sulfite free',
      'Ready-to-use injection:',
      'Biorphen: 0.1 mg/mL (5-mL ampules or vials); preservative and sulfite free',
      'Immphentiv: 0.1 mg/mL (5-, 10-mL vials); contains '
          'ethylenediaminetetra-acetic acid (EDTA)',
      'Nasal spray/drops (OTC; may contain benzalkonium chloride):',
      '0.25% (Neo-Synephrine Cold/Allergy Mild): 0.25% (15 mL)',
      '0.5% (Neo-Synephrine Cold/Allergy Regular Strength): 0.5% (15 mL)',
      '1% (4-Way Fast Acting, Neo-Synephrine Extra Strength, and generics): 1% '
          '(15, 30 mL)',
      'NOTE: For Neo-Synephrine 12-hr Nasal, see Oxymetazoline.',
      'Ophthalmic drops (Altafrin and generics): 2.5% (2, 10, 15 mL), 10% (5 '
          'mL); contains benzalkonium chloride',
      'Tabs (Sudafed PE Sinus Congestion and others [OTC]): 10 mg; NOTE: also '
          'available in combination with antipyretics/analgesics or diphenhydramine '
          'or dextromethorphan',
      'Oral solution (Sudafed PE Children’s [OTC]): 2.5 mg/5 mL (118 mL); '
          'contains EDTA and sodium benzoate',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hypotension:',
        lines: [
          DoseLine('To prepare infusion: See inside front cover.'),
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('IV bolus: 5–20 mCg/kg/dose (initial max. dose: 500 mCg/dose, subsequent '
              'max. dose: 1000 mCg/dose) Q10–15 min PRN'),
          DoseLine('IV drip: Start at 0.1–0.5 mCg/kg/min; titrate to effect.'),
          DoseLine('IM/SC: 0.1 mg/kg/dose Q1–2 hr PRN; max. dose: 5 mg'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('IV drip: 0.5–6 mCg/kg/min; titrate to effect'),
        ],
      ),
      DoseSection(
        heading: 'Pupillary dilation (see remarks):',
        lines: [
          DoseLine('<1 yr: 2.5% ophthalmic solution; 1 drop in each eye 15–30 min before exam'),
          DoseLine('Child (≥1 yr) and adult: 2.5% or 10% ophthalmic solution; 1 drop in each '
              'eye 10–60 min before exam'),
        ],
      ),
      DoseSection(
        heading: 'Nasal decongestant (in each nostril; give up to 3 days):',
        lines: [
          DoseLine('Child 2–<6 yr: 1–3 drops to each nostril of 0.125% solution Q4 hr PRN'),
          DoseLine('Child 6–12 yr: 1–3 sprays/drops to each nostril of 0.25% solution Q4 hr '
              'PRN'),
          DoseLine('>12 yr–adult: 1–3 sprays/drops to each nostril of 0.25%, 0.5%, or 1% '
              'solution Q4 hr PRN'),
        ],
      ),
      DoseSection(
        heading: 'Oral decongestant (see remarks):',
        lines: [
          DoseLine('4–<6 yr: 2.5 mg (5 mL) PO Q4 hr PRN, up to 15 mg (30 mL)/24 hr'),
          DoseLine('≥6–<12 yr: 5 mg (10 mL) PO Q4 hr PRN up to 30 mg (60 mL)/24 hr'),
          DoseLine('≥12 yr and adult: 10 mg PO Q4 hr PRN up to 60 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in presence of arrhythmias, hyperthyroidism, or '
          'hyperglycemia. May cause tremor, insomnia, or palpitations. Metabolized '
          'by monoamine oxidase. Contraindicated in pheochromocytoma and severe '
          'hypertension. Injectable product may contain sulfites.',
      'Nasal decongestants may cause rebound congestion with excessive use (>3 '
          'days). The 1% nasal spray can be used in adults with extreme congestion.',
      'Oral phenylephrine is found in a variety of combination cough and cold '
          'products and has replaced pseudoephedrine and phenylpropanolamine. '
          'Over-the-counter (OTC or nonprescription) use of this product is not '
          'recommended for children younger than age 6; reports of serious adverse '
          'effects (cardiac and respiratory distress, convulsions, and '
          'hallucinations) and fatalities (from unintentional overdosages, including '
          'combined use of other OTC products containing the same active '
          'ingredients) have been made.',
      'Ophthalmic use: Apply pressure to the lacrimal sac during and 2 min after '
          'administering drops to minimize systemic absorption.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1164–1165',
  ),
  // PHENYTOIN — PDF p. 356–357 (printed 1165–1166)
  DrugEntryV3(
    name: 'PHENYTOIN',
    brandNames: 'Dilantin, Dilantin Infatab, Phenytoin Infatab, Phenytek, and '
        'generics',
    drugClass: 'Anticonvulsant, class IB antiarrhythmic',
    iconRow: '',
    formulations: [
      'Chewable tabs (Dilantin Infatab, Phenytoin Infatabs, and generics): 50 '
          'mg; may contain saccharin, and some products may be scored',
      'Extended-release caps:',
      'Dilantin: 30, 100 mg',
      'Phenytek: 200, 300 mg',
      'Generics: 100, 200, 300 mg',
      'Oral suspension (Dilantin and generics): 125 mg/5 mL (240 mL); contains '
          '≤0.6% alcohol and sodium benzoate',
      'Injection: 50 mg/mL (2, 5 mL); contains alcohol and sodium benzoate',
    ],
    doseSections: [
      DoseSection(
        heading: 'Status epilepticus:',
        lines: [
          DoseLine('See Chapter 1 and remarks. Fosphenytoin is the preferred IV dosage form '
              'due to lower risk for side effects.'),
          DoseLine('Loading dose (all ages): 20 mg/kg IV; max. dose: 1500 mg/24 hr'),
          DoseLine(
            'Maintenance for seizure disorders (initiate 12 hr after administration of '
                'loading dose; use once-daily or BID dosing with extended-release caps):',
            isHeading: true,
          ),
          DoseLine('Neonate: Start with 5 mg/kg/24 hr PO/IV ÷ Q12 hr; usual range 4–8 '
              'mg/kg/24 hr PO/IV ÷ Q8–12 hr'),
          DoseLine('Infant/child: Start with 5 mg/kg/24 hr PO/IV ÷ BID–TID; usual dose range '
              '(doses divided BID–TID with non–extended-release dosage forms):'),
          DoseLine('6 mo–3 yr: 8–10 mg/kg/24 hr'),
          DoseLine('4–6 yr: 7.5–9 mg/kg/24 hr'),
          DoseLine('7–9 yr: 7–8 mg/kg/24 hr'),
          DoseLine('10–16 yr: 6–7 mg/kg/24 hr'),
          DoseLine('Adult: Start with 100 mg/dose IV/PO Q8 hr and carefully titrate (if '
              'needed) by 100-mg increments Q2–4 wk to 300–600 mg/24 hr (or 6–7 mg/kg/24 '
              'hr) ÷ Q8–24 hr IV/PO.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in patients with heart block or sinus bradycardia; those '
          'who are receiving delavirdine (decrease virologic response); and history '
          'of hydantoin hypersensitivity. Use with caution in patients with '
          'pacemakers or cardiac dysrhythmias because of its class IB antiarrhythmic '
          'properties. IM administration is not recommended because of erratic '
          'absorption and pain at injection site; consider fosphenytoin. Side '
          'effects include gingival hyperplasia, hirsutism, dermatitis, blood '
          'dyscrasia, ataxia, lupus-like and Stevens-Johnson syndromes, '
          'lymphadenopathy, liver damage, and nystagmus. Suicidal behavior or '
          'ideation, bradycardia, cardiac arrest, red cell aplasia, and multiorgan '
          'hypersensitivity (drug rash with eosinophilia and systemic symptoms) have '
          'been reported. An increased risk for serious skin reactions (e.g., toxic '
          'epidermal necrolysis and Stevens-Johnson syndrome) may occur in patients '
          'with the HLA-B*1502 allele; do not use this medication in individuals who '
          'carry this genotype.',
      'Many drug interactions: Levels may be increased by cimetidine, '
          'chloramphenicol, isoniazid, sulfonamides, trimethoprim, etc. Levels may '
          'be decreased by some antineoplastic agents. Phenytoin induces hepatic '
          'microsomal enzymes (cytochrome P-450 [CYP] 1A2, 2C8/9/19, and 3A3/3A4), '
          'leading to decreased effectiveness of oral contraceptives, direct '
          'thrombin inhibitors (e.g., dabigatran, rivaroxaban), fosamprenavir (used '
          'without ritonavir), quinidine, lacosamide, valproic acid, theophylline, '
          'and other substrates to the previously listed CYP hepatic enzymes. May '
          'increase levels of amprenavir when administered with fosamprenavir and '
          'ritonavir. May cause resistance to neuromuscular blocking action of '
          'nondepolarizing neuromuscular blocking agents (e.g., pancuronium, '
          'vecuronium, rocuronium, and cisatracurium) and decrease concentrations of '
          'thyroxine and triiodothyronine (typically without clinical '
          'hypothyroidism). May increase risk for hyperammonemia when used with '
          'valproic acid.',
      'The following initial maintenance dose modifications for HLA-B*1502 '
          'allele noncarriers and CYP2C9 phenotypes have been recommended:',
      'CYP2C9 intermediate metabolizer: 25% reduction with therapeutic drug '
          'monitoring',
      'CYP2C9 poor metabolizer: 50% reduction with therapeutic drug monitoring',
      'Some recommend avoiding use for those who are positive for HLA-B*1502 or '
          'CYP2C9*3 carriers.',
      'Ideal body weight should be used for calculating dosages. Suggested '
          'dosing intervals for specific oral dosage forms: extended-release caps, '
          'once daily–BID; chewable tablets and oral suspension, TID. Oral '
          'absorption reduced in neonates. T₁/₂ is variable (7–42 hr) and dose '
          'dependent. Drug is highly protein bound; free fraction of drug will be '
          'increased in patients with hypoalbuminemia.',
      'For seizure disorders, therapeutic levels: 10–20 mg/L (free and bound '
          'phenytoin) OR 1–2 mg/L (free only). Monitor free phenytoin levels in '
          'hypoalbuminemia or renal insufficiency. Recommended serum sampling times: '
          'trough level (PO/IV) within 30 min prior to the next scheduled dose; peak '
          'or postload level (IV) 1 hr after the end of IV infusion. Steady state is '
          'usually achieved after 5–10 days of continuous dosing. For routine '
          'monitoring, measure trough.',
      'IV push/infusion rate: Not to exceed 0.5 mg/kg/min in neonates, or 1 '
          'mg/kg/min in infants, children, and adults with maximum of 50 mg/min; may '
          'cause cardiovascular collapse. Consider fosphenytoin in situations of '
          'tenuous IV access and risk for extravasation.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1165–1166',
  ),
  // PHOSPHORUS SUPPLEMENTS — PDF p. 358 (printed 1167)
  DrugEntryV3(
    name: 'PHOSPHORUS SUPPLEMENTS',
    brandNames: 'K-PHOS Neutral, K-PHOS No. 2, Av-Phos 250 Neutral, Phospho-Trin 250 '
        'Neutral, Phospha 250 Neutral, PHOS-NaK, Sodium Phosphate, Potassium '
        'Phosphate, and many generics',
    drugClass: 'Electrolyte supplement',
    iconRow: '',
    formulations: [
      'Oral:',
      'Na and K phosphate powder:',
      'PHOS-NaK and generics: 250 mg (8 mM) P, 6.96 mEq (160 mg) Na, 7.16 mEq '
          '(280 mg) K per packet of powder (100s); reconstitute with 75 mL water or '
          'juice per packet',
      'Na and K phosphate tabs:',
      'K-PHOS Neutral, Phospho-Trin 250 Neutral, Phospha 250 Neutral, Av-Phos '
          '250 Neutral, and generics: 250 mg P (8 mM), 13 mEq Na, 1.1 mEq K; '
          'administer each tablet with a full glass of water',
      'K-PHOS No. 2: 250 mg P (8 mM), 5.8 mEq Na, 2.3 mEq K; administer each '
          'tablet with a full glass of water',
      'K phosphate tabs:',
      'K-Phos Original: 500 mg potassium acid phosphate (114 mg phosphorus and '
          '3.7 mEq K); dissolve each tablet in 3–4 oz water',
      'Injection (see remarks):',
      'Na phosphate: 3 mM (93 mg) P, 4 mEq Na/mL (5, 15, 50 mL)',
      'K phosphate: 3 mM (93 mg) P, 4.4 mEq K/mL (5, 15 mL)',
      'Conversion: 31 mg P = 1 mM P',
    ],
    doseSections: [
      DoseSection(
        heading: 'Acute hypophosphatemia:',
        lines: [
          DoseLine('0.16–0.32 mM/kg/dose (or 5–10 mg/kg/dose) IV over 4–6 hr. Higher doses of '
              '0.32-0.64 mM/kg/dose (or 10–20 mg/kg/dose) IV over 8–12 hr have been '
              'recommended for severe cases (phosphorous <1.5 mg/dL).'),
        ],
      ),
      DoseSection(
        heading: 'Maintenance/replacement:',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('IV: 0.5–1.5 mM/kg (or 15–45 mg/kg) over 24 hr'),
          DoseLine('PO: 30–90 mg/kg/24 hr (or 1–3 mM/kg/24 hr) ÷ TID–QID'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('IV: 50–65 mM (or 1.5–2 g) over 24 hr'),
          DoseLine('PO: 3–4.5 g/24 hr (or 100–150 mM/24 hr) ÷ TID–QID'),
        ],
      ),
      DoseSection(
        heading: 'Recommended IV infusion rate:',
        lines: [
          DoseLine('≤0.1 mM/kg/hr (or 3.1 mg/kg/hr) of phosphate. When potassium salt is '
              'used, the rate may be limited by the max. potassium infusion rate. Do not '
              'co-infuse with calcium-containing products.'),
        ],
      ),
    ],
    remarks: [
      'May cause tetany, hyperphosphatemia, hyperkalemia, or hypocalcemia. Use '
          'with caution in patients with renal impairment. Be aware of sodium and/or '
          'potassium load when supplementing phosphate. IV administration may cause '
          'hypotension and renal failure, or arrhythmias, heart block, and cardiac '
          'arrest with potassium salt. IV potassium phosphate and sodium phosphate '
          'contain aluminum as a byproduct, with reported concentrations of 4–10 '
          'mCg/mL and 3.2 mCg/mL, respectively. PO dosing may cause nausea, '
          'vomiting, abdominal pain, or diarrhea. See Chapter 21 for daily '
          'requirements and Chapter 11 for additional information on '
          'hypophosphatemia and hyperphosphatemia.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1167',
  ),
  // PHYSOSTIGMINE SALICYLATE — PDF p. 359 (printed 1168)
  DrugEntryV3(
    name: 'PHYSOSTIGMINE SALICYLATE',
    brandNames: 'Anticholium; previously available as Antilirium',
    drugClass: 'Cholinergic agent',
    iconRow: '',
    formulations: [
      'Injection: 0.4 mg/mL (5 mL); contains sodium edetate with a 1:1 molar '
          'ratio of physostigmine to salicylate',
    ],
    doseSections: [
      DoseSection(
        heading: 'Reversal of toxic anticholinergic effects from antihistamine or '
            'anticholinergic agents:',
        lines: [
          DoseLine('Child: 0.02 mg/kg/dose (max. dose: 0.5 mg/dose) IM or IV (administered no '
              '>0.5 mg/min); dose may be repeated every 5–10 min if no response or '
              'return of anticholinergic symptoms up to a max. total of 2 mg'),
          DoseLine('Adult: 0.5–2 mg IM or IV (administered no >1 mg/min); if needed, repeat '
              'dose every 10–30 min until response is seen or adverse effects occur'),
        ],
      ),
    ],
    remarks: [
      'Physostigmine antidote: Atropine always should be available. '
          'Contraindicated in asthma, gangrene, diabetes, cardiovascular disease, '
          'gastrointestinal (GI) or genitourinary tract obstruction, any vagotonic '
          'state, and patients receiving choline esters or depolarizing '
          'neuromuscular blocking agents (e.g., decamethonium, succinylcholine). May '
          'cause seizures, arrhythmias, bradycardia, GI symptoms, and other '
          'cholinergic effects. Rapid IV administration can cause bradycardia and '
          'hypersalivation leading to respiratory distress and seizures.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1168',
  ),
  // PHYTONADIONE/VITAMIN K₁ — PDF p. 359–360 (printed 1168–1169)
  DrugEntryV3(
    name: 'PHYTONADIONE/VITAMIN K₁',
    brandNames: 'Mephyton and generics',
    drugClass: 'Vitamin, fat soluble',
    iconRow: '',
    formulations: [
      'Tabs (Mephyton and generics): 5 mg; may be scored',
      'Oral suspension: 1 mg/mL',
      'Injection, emulsion (contains no more than 500 mCg/L aluminum):',
      '2 mg/mL (0.5 mL); some preparations may be preservative free but may '
          'contain propylene glycol',
      '10 mg/mL (1 mL); contains 0.9% benzyl alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Vitamin K deficiency bleeding (neonatal hemorrhagic disease): '
            'Preservative-free dosage form is preferred.',
        lines: [
          DoseLine(
            'Prophylaxis (IM, administered within 6 hr after birth):',
            isHeading: true,
          ),
          DoseLine('≤1.5 kg: 0.3–0.5 mg/kg/dose × 1'),
          DoseLine('>1.5 kg: 1 mg × 1'),
          DoseLine('Treatment: 1–2 mg/24 hr IM/SC/IV'),
        ],
      ),
      DoseSection(
        heading: 'Warfarin overdose (see remarks):',
        lines: [
          DoseLine(
            'No significant bleeding (international normalized ratio [INR] levels):',
            isHeading: true,
          ),
          DoseLine('INR 4–4.5: Consider PO vitamin K at dosage indicated for INR >4.5–<10 '
              'below and monitor INR Q24 hr. Lower or hold warfarin dose.'),
          DoseLine('INR >4.5–<10: Repeat INR and hold warfarin dose. Monitor INR Q24 hr until '
              'INR <4. Give PO vitamin K for patients with high bleeding risk:'),
          DoseLine('<40 kg: 0.03 mg/kg PO × 1'),
          DoseLine('≥40 kg: 1–2.5 mg PO × 1'),
          DoseLine('INR ≥10: Repeat INR and hold warfarin dose . Monitor INR Q12 hr and give '
              'PO vitamin K (dose may be repeated Q12–24 hr PRN):'),
          DoseLine('<40 kg: 0.06 mg/kg PO × 1'),
          DoseLine('≥40 kg: 5–10 mg PO × 1'),
          DoseLine('Minor bleeding (any elevated INR): Hold warfarin and monitor INR Q12–24 '
              'hr, administer single vitamin K dose and repeat vitamin K dose in 24 hr '
              'if full correction not achieved and bleeding persists.'),
          DoseLine(
            'PO:',
            isHeading: true,
          ),
          DoseLine('<40 kg: 0.03 mg/kg × 1'),
          DoseLine('≥40 kg: 1–2.5 mg × 1'),
          DoseLine('IV: 0.5–2.5 mg ×1'),
          DoseLine('Significant or life-threatening bleeding (any elevated INR): Hold '
              'warfarin and give vitamin K 5–10 mg IV ×1 in combination with fresh '
              'frozen plasma (10–15 mL/kg) or prothrombin complex concentrate '
              '(KCentra®). Monitor INR Q4–6 hr; repeat vitamin K dose if full correction '
              'not achieved at 12–24 hr and bleeding persists.'),
        ],
      ),
      DoseSection(
        heading: 'Vitamin K deficiency:',
        lines: [
          DoseLine('Liver disease (infant, child, and adolescent): 2.5–5 mg/24 hr PO'),
          DoseLine('Cholestasis (infant, child, and adolescent): 2.5–15 mg/24 hr PO'),
        ],
      ),
    ],
    remarks: [
      'IV or IM doses may cause flushing, dizziness, cardiac/respiratory arrest, '
          'hypotension, and anaphylaxis. IV or IM administration is indicated only '
          'when other routes of administration are not feasible (or in emergency '
          'situations).',
      'Monitor prothrombin time/partial thromboplastin time. Large doses (10–20 '
          'mg) in newborns may cause hyperbilirubinemia and severe hemolytic anemia. '
          'Blood coagulation factors increase within 6–12 hr after oral doses and '
          'within 1–2 hr following parenteral administration. Use of higher doses '
          'for warfarin overdose may cause warfarin resistance for ≥1 wk. Concurrent '
          'administration of oral mineral oil may decrease gastrointestinal '
          'absorption of oral vitamin K.',
      'IV injection rate not to exceed 3 mg/m²/min or 1 mg/min. Protect product '
          'from light. See Chapter 21 for multivitamin preparations.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1168–1169',
  ),
  // PILOCARPINE HCL — PDF p. 360–361 (printed 1169–1170)
  DrugEntryV3(
    name: 'PILOCARPINE HCL',
    brandNames: 'Vuity, Qlosi, Salagen, and generics; previously available as Isopto '
        'Carpine',
    drugClass: 'Cholinergic agent',
    iconRow: '',
    formulations: [
      'Ophthalmic solution:',
      'Generics: 1% (15 mL), 2% (15 mL), 4% (15 mL); may contain benzalkonium '
          'chloride',
      'Vuity: 1.25% (2.5, 5 mL); contains benzalkonium chloride',
      'Qlosi: 0.4% (0.4 mL; available as 5 vials per pouch in quantities of 2, '
          '4, 6, or 12 pouches per box); contains edetate disodium (EDTA)',
      'Tab (Salagen and generics): 5, 7.5 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'For elevated intraocular pressure:',
        lines: [
          DoseLine('Infant and child <2 yr: Instill 1 drop of the 1% solution into each '
              'affected eye(s) TID.'),
          DoseLine('Child ≥2 yr, adolescent, and adult: Instill 1–2 drop(s) in each affected '
              'eye up to 4 times a day; concentration and dosage frequency are dependent '
              'on the degree of elevated pressure and miotic response.'),
        ],
      ),
      DoseSection(
        heading: 'Xerostomia:',
        lines: [
          DoseLine('Adult: 5 mg/dose PO TID; dose may be titrated to 10 mg/dose PO TID in '
              'patients who do not respond to lower dose and who are able to tolerate '
              'the drug. Also, 5 mg/dose PO QID has been used in Sjögren syndrome.'),
        ],
      ),
    ],
    remarks: [
      'OPHTHALMIC USE: Contraindicated in acute iritis or anterior chamber '
          'inflammation and uncontrolled asthma. May cause transient blurred or '
          'dim/dark vision, stinging, burning, lacrimation, headache, vitreous '
          'floaters, and retinal detachment. Use with caution in patients with '
          'corneal abrasion or significant cardiovascular disease. Use with topical '
          'nonsteroidal antiinflammatory drugs (e.g., ketorolac) may decrease '
          'topical pilocarpine effects.',
      'ORAL USE: Sweating, nausea, rhinitis, chills, flushing, urinary '
          'frequency, dizziness, asthenia, and headaches have also been reported. '
          'Reduce oral dosing in the presence of mild hepatic insufficiency '
          '(Child-Pugh score of 5–6); avoid use in severe hepatic insufficiency.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1169–1170',
  ),
  // PIMECROLIMUS — PDF p. 361 (printed 1170)
  DrugEntryV3(
    name: 'PIMECROLIMUS',
    brandNames: 'Elidel and generics',
    drugClass: 'Topical immunosuppressant, calcineurin inhibitor',
    iconRow: '',
    formulations: [
      'Cream: 1% (30, 60, 100 g); contains benzyl alcohol and propylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Atopic dermatitis (second-line therapy):',
        lines: [
          DoseLine('Child ≥2 yr, adolescent, and adult (see remarks): Apply a thin layer to '
              'affected area BID and rub in gently and completely. Reevaluate patient in '
              '6 wk if lesions are not healed.'),
        ],
      ),
    ],
    remarks: [
      'Do not use in children <2 yr (higher rate of upper respiratory '
          'infections), in immunocompromised patients, or with occlusive dressings '
          '(promotes systemic absorption). Avoid use on malignant or premalignant '
          'skin conditions as rare cases of lymphoma and skin malignancy have been '
          'reported with topical calcineurin inhibitors. Approved as a second-line '
          'therapy for atopic dermatitis for patients who fail to respond to, or do '
          'not tolerate, other approved therapies. Use medication for short periods '
          'of time by using the minimum amounts to control symptoms; long-term '
          'safety is unknown. Avoid contact with eyes, nose, mouth, and cut, '
          'infected, or scraped skin. Minimize and avoid exposure to natural and '
          'artificial sunlight, respectively.',
      'Most common side effects include burning at the application site, '
          'headache, viral infections, and pyrexia. Skin discoloration, skin '
          'flushing associated with alcohol use, anaphylactic reactions, ocular '
          'irritation after application to the eyelids or near the eyes, '
          'angioneurotic edema, and facial edema have been reported. Drug is a '
          'cytochrome P-450 3A3/3A4 substrate.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1170',
  ),
  // PIPERACILLIN WITH TAZOBACTAM — PDF p. 361–363 (printed 1170–1172)
  DrugEntryV3(
    name: 'PIPERACILLIN WITH TAZOBACTAM',
    brandNames: 'Zosyn and generics',
    drugClass: 'Antibiotic, penicillin (extended spectrum with β-lactamase inhibitor)',
    iconRow: '',
    formulations: [
      '8:1 ratio of piperacillin to tazobactam:',
      'Injection, powder: 2 g piperacillin and 0.25 g tazobactam; 3 g '
          'piperacillin and 0.375 g tazobactam; 4 g piperacillin and 0.5 g '
          'tazobactam; 12 g piperacillin and 1.5 g tazobactam; 36 g piperacillin and '
          '4.5 g tazobactam',
      'Injection, premixed in iso-osmotic dextrose: 2 g piperacillin and 0.25 g '
          'tazobactam in 50 mL; 3 g piperacillin and 0.375 g tazobactam in 50 mL; 4 '
          'g piperacillin and 0.5 g tazobactam in 100 mL',
      'Contains 2.84 mEq Na/g piperacillin',
    ],
    doseSections: [
      DoseSection(
        heading: 'All doses based on piperacillin component.',
      ),
      DoseSection(
        heading: 'Neonate and infant (IV; limited data and see remarks):',
        lines: [
          DoseLine(
            '≤2 kg:',
            isHeading: true,
          ),
          DoseLine('≤7 days old: 100 mg/kg/dose Q8 hr'),
          DoseLine(
            '8–28 days old:',
            isHeading: true,
          ),
          DoseLine('≤30 wk postmenstrual age: 100 mg/kg/dose Q8 hr'),
          DoseLine('>30 wk postmenstrual age: 80 mg/kg/dose Q6 hr'),
          DoseLine('29–60 days old: 80 mg/kg/dose Q6 hr'),
          DoseLine(
            '>2 kg:',
            isHeading: true,
          ),
          DoseLine('≤60 days old: 80 mg/kg/dose Q6 hr'),
        ],
      ),
      DoseSection(
        heading: 'NOTE:',
        lines: [
          DoseLine('For patients with a postmenstrual age of >35 wk, a pharmacokinetic study '
              'suggests using 80 mg/kg/dose IV Q4 hr to achieve targeted drug '
              'concentration time above the minimum inhibitory concentration (MIC). '
              'Prolonged dose infusion times of 3 hours can improve the pharmacodynamic '
              'concentration time above the MIC and may be useful for pathogens with '
              'higher MICs. Postmenstrual age = gestational age + postnatal age.'),
        ],
      ),
      DoseSection(
        heading: 'Child and adolescent:',
        lines: [
          DoseLine(
            'Severe infections and nosocomial pneumonia (lengthening the dose '
                'administration time to 4 hr [see remarks] may enhance the pharmacodynamic '
                'properties):',
            isHeading: true,
          ),
          DoseLine('2–9 mo: 80 mg/kg/dose IV Q6 hr'),
          DoseLine('>9 mo, child, and adolescent: 100 mg/kg/dose (max. 4000 mg/dose) IV Q6 hr'),
          DoseLine('Max. dose (all ages): 16 g/24 hr'),
          DoseLine(
            'Appendicitis or peritonitis (dosing interval may be shortened to Q6 hr to '
                'enhance pharmacodynamic properties):',
            isHeading: true,
          ),
          DoseLine('2–9 mo: 80 mg/kg/dose IV Q8 hr'),
          DoseLine(
            '>9 mo–adolescent:',
            isHeading: true,
          ),
          DoseLine('≤40 kg: 100 mg/kg/dose (max. 3000 mg/dose) IV Q8 hr'),
          DoseLine('>40 kg: 3 g/dose IV Q6 hr'),
          DoseLine('Max. dose (all ages): 16 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Intra-abdominal or soft tissue infections: 3 g IV Q6 hr'),
          DoseLine('Nosocomial pneumonia: 4 g IV Q6 hr'),
        ],
      ),
      DoseSection(
        heading: 'Cystic fibrosis (antipseudomonal; see remarks):',
        lines: [
          DoseLine('All ages: 350–600 mg/kg/24 hr IV ÷ Q4–6 hr; max. dose: 24 g/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Tazobactam is a β-lactamase inhibitor, thus extending the spectrum of '
          'piperacillin. Like other penicillins, cerebrospinal fluid penetration '
          'occurs only with inflamed meninges. Gastrointestinal disturbances, '
          'pruritus, rash, and headaches are common. Abnormal platelet aggregation '
          'and prolonged bleeding, hemophagocytic lymphohistiocytosis, '
          'rhabdomyolysis, and serious skin reactions (e.g., Stevens-Johnson '
          'syndrome, drug rash with eosinophilia and systemic symptoms, acute '
          'generalized exanthematous pustulosis, and toxic epidermal necrolysis) '
          'have been reported. Cystic fibrosis patients have an increased risk for '
          'fever and rash. Increases in renal failure risk (in critically ill '
          'adults) and incidence of acute kidney injury (in combination with IV '
          'vancomycin) have been reported.',
      'Coagulation parameters should be tested more frequently and monitored '
          'regularly with high doses of heparin, warfarin, or other drugs affecting '
          'blood coagulation or thrombocyte function. May falsely decrease '
          'aminoglycoside serum levels if the drugs are infused close to one '
          'another; allow a minimum of 2 hr between infusions to prevent this '
          'interaction. May prolong the neuromuscular blockade effects of vecuronium.',
      'Prolonging the dose administration time to 4 hr will maximize the '
          'pharmacokinetic/pharmacodynamic properties by prolonging the time of drug '
          'concentration above the MIC, especially for pathogens with piperacillin '
          'MICs of 8–16 mCg/mL. Adjust dose in renal impairment (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1170–1172',
  ),
  // POLYCITRA — PDF p. 363 (printed 1172)  [cross-reference]
  DrugEntryV3(
    name: 'POLYCITRA',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Citrate Mixtures.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1172',
  ),
  // POLYETHYLENE GLYCOL—ELECTROLYTE SOLUTION — PDF p. 363–364 (printed 1172–1173)
  DrugEntryV3(
    name: 'POLYETHYLENE GLYCOL—ELECTROLYTE SOLUTION',
    brandNames: 'Bowel-cleansing products: GoLYTELY, Colyte, GaviLyte, and generics\n'
        'Laxative products: MiraLax, GaviLAX, GlycoLax, HealthyLax, and many '
        'others, including generics',
    drugClass: 'Bowel evacuant, osmotic laxative',
    iconRow: '',
    formulations: [
      'Powder for oral solution:',
      'Bowel-cleansing products:',
      'GoLYTELY and others: Polyethylene glycol 3350 (236 g); contains Na '
          'sulfate (22.74 g), Na bicarbonate (6.74 g), NaCl (5.86 g), KCl (2.97 g), '
          'mixed with water to 4 L. Contents vary somewhat. See package insert for '
          'specific contents of other products.',
      'Laxative products:',
      'MiraLax [OTC], GaviLAX [OTC], Glycolax [OTC], HealthyLax [OTC], and '
          'generics [OTC and Rx]:',
      'Polyethylene glycol 3350 (17, 119, 238, 510, 527, 850 g)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Bowel cleansing (using products containing supplemental electrolytes '
            'for bowel cleansing, such as GoLYTELY, NuLYTELY, and generics; and '
            'patients should be NPO 3–4 hr prior to dosing):',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('Oral/nasogastric: 25–40 mL/kg/hr until rectal effluent is clear (usually '
              'in 4–10 hr)'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Oral: 240 mL PO Q10 min up to 4 L or until rectal effluent is clear'),
          DoseLine('Nasogastric: 20–30 mL/min (1.2–1.8 L/hr) up to 4 L or until rectal '
              'effluent is clear'),
        ],
      ),
      DoseSection(
        heading: 'Bowel cleansing (using MiraLax or equivalent product):',
        lines: [
          DoseLine('≥2 yr and adolescent: 1.5 g/kg/24 hr (max. dose: 100 g/24 hr) × 4 days'),
        ],
      ),
      DoseSection(
        heading: 'Constipation (using MiraLax or equivalent product):',
        lines: [
          DoseLine(
            'Child (limited data in 20 children with chronic constipation, 18 mo–11 '
                'yr; see remarks):',
            isHeading: true,
          ),
          DoseLine('A mean effective dose of 0.84 g/kg/24 hr PO ÷ BID for 8 wk (range: '
              '0.25–1.42 g/kg/24 hr) was used to yield 2 soft stools per day. Do not '
              'exceed 17 g/24 hr. If patient >20 kg, use adult dose.'),
          DoseLine('Adult: 17 g (one heaping tablespoonful) mixed in 240 mL of water, juice, '
              'soda, coffee, or tea PO once daily'),
        ],
      ),
      DoseSection(
        heading: 'Fecal impaction:',
        lines: [
          DoseLine(
            'GoLYTELY and others:',
            isHeading: true,
          ),
          DoseLine('≥2 yr (Oral/nasogastric tube): 20 mL/kg/hr up to a maximum of 1 L/hr × 4 '
              'hr per 24 hr for 2 days'),
          DoseLine(
            'MiraLax and others:',
            isHeading: true,
          ),
          DoseLine('>3 yr: 1–1.5 g/kg/24 hr (max. dose: 100 g/24 hr) PO × 3–6 days. Following '
              'disimpaction, give a maintenance dose of 0.4–1 g/kg/24 hr for ≥2 mo '
              'followed by a gradual decrease in dose.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in polyethylene glycol hypersensitivity. Monitor '
          'electrolytes, blood urea nitrogen, serum glucose, and urine osmolality '
          'with prolonged administration. Seizures resulting from electrolyte '
          'abnormalities have been reported.',
      'Bowel cleansing (GoLYTELY and others): Contraindicated in toxic '
          'megacolon, gastric retention, toxic colitis, ileus, and bowel '
          'perforation. Use with caution in patients prone to aspiration or with '
          'impaired gag reflex. Do not mix with starch-based thickeners as it may '
          'reduce their viscosity and increase the risk of choking and aspiration '
          'for patients who have trouble swallowing. Effect should occur within 1–2 '
          'hr. Solution generally more palatable if chilled.',
      'Constipation (MiraLax and others): Contraindicated in bowel obstruction. '
          'Sipping the dose throughout the day will reduce the osmotic effect and '
          'may decrease its effectiveness. Child: Dilute powder using the ratio of '
          '17 g powder to 240 mL of water, juice, or milk. A trial reported an onset '
          'of action within 1 wk in 12 of 20 patients, with the remaining 8 patients '
          'reporting improvement during the second week of therapy. Side effects '
          'reported in this trial included diarrhea, flatulence, and mild abdominal '
          'pain. (See J Pediatr 2001;139[3]:428–432 for additional information.)',
      'Adult: 2–4 days may be required to produce a bowel movement. Most common '
          'side effects include nausea, abdominal bloating, cramping, and '
          'flatulence. Use beyond 2 wk has not been studied.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1172–1173',
  ),
  // POLYMYXIN B SULFATE AND BACITRACIN — PDF p. 364 (printed 1173)  [cross-reference]
  DrugEntryV3(
    name: 'POLYMYXIN B SULFATE AND BACITRACIN',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Bacitracin ± Polymyxin B.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1173',
  ),
  // POLYMYXIN B SULFATE AND TRIMETHOPRIM SULFATE — PDF p. 364 (printed 1173)
  DrugEntryV3(
    name: 'POLYMYXIN B SULFATE AND TRIMETHOPRIM SULFATE',
    brandNames: 'Generics; previously available as Polytrim Ophthalmic Solution',
    drugClass: 'Topical antibiotic (ophthalmic preparations listed)',
    iconRow: '',
    formulations: [
      'Ophthalmic solution: Polymyxin B sulfate 10,000 U/mL, and trimethoprim '
          'sulfate 1 mg/mL (10 mL); some preparations may contain 0.04 mg/mL '
          'benzalkonium chloride',
    ],
    doseSections: [
      DoseSection(
        heading: 'Surface ocular bacterial infections (conjunctivitis and '
            'blepharoconjunctivitis):',
        lines: [
          DoseLine('≥2 mo, child, adolescent, and adult: Instill 1 drop in the affected '
              'eye(s) Q3 hr (max. of 6 doses/24 hr) × 7–10 days. A reduced dosage of 1 '
              'drop QID x 5–7 days has been used in children and adolescents with acute '
              'conjunctivitis.'),
        ],
      ),
    ],
    remarks: [
      'Active against susceptible strains of Staphylococcus aureus, '
          'Staphylococcus epidermidis, Streptococcus pneumoniae, Streptococcus '
          'viridans, Haemophilus influenzae, and Pseudomonas aeruginosa. Not '
          'indicated for the prophylaxis or treatment of ophthalmia neonatorum. '
          'Local irritation consisting of redness, burning, stinging, and/or itching '
          'is common. Hypersensitivity reactions consisting of lid edema, itching, '
          'increased redness, tearing, and/or circumocular rash have been reported.',
      'Apply finger pressure to lacrimal sac during and for 1–2 min after dose '
          'application.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1173',
  ),
  // POLYMYXIN B SULFATE, NEOMYCIN SULFATE, HYDROCORTISONE OTIC — PDF p. 365 (printed 1174)
  DrugEntryV3(
    name: 'POLYMYXIN B SULFATE, NEOMYCIN SULFATE, HYDROCORTISONE OTIC',
    brandNames: 'Generics; previously available as Cortisporin Otic',
    drugClass: 'Topical otic antibiotic',
    iconRow: '',
    formulations: [
      'Otic solution or suspension: Polymyxin B sulfate 10,000 U/mL, neomycin '
          'sulfate 5 mg/mL (3.5 mg/mL neomycin base), hydrocortisone 10 mg/mL (10 '
          'mL); some preparations may contain thimerosol and metabisulfite',
      'For ophthalmic suspension, see Neomycin/Polymyxin B Ophthalmic Products.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Otitis externa:',
        lines: [
          DoseLine('≥2 yr, child, and adolescent: 3 drops TID–QID × 7–10 days. If preferred, '
              'a cotton wick may be saturated and inserted into ear canal. Moisten wick '
              'with antibiotic every 4 hr and replace the wick Q24 hr.'),
          DoseLine('Adult: 4 drops TID–QID × 7–10 days (otic suspension preferred)'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in patients with active varicella and herpes simplex and '
          'in cases with perforated eardrum (possible ototoxicity). Use with caution '
          'in chronic otitis media and when the integrity of the tympanic membrane '
          'is in question. Metabisulfite-containing products may cause allergic '
          'reactions to susceptible individuals. Hypersensitivity (itching, skin '
          'rash, redness, swelling, or other sign of irritation in or around the '
          'ear) may occur. Neomycin may cause sensitization. Prolonged treatment may '
          'result in overgrowth of nonsusceptible organisms and fungi. May cause '
          'cutaneous sensitization.',
      'Shake suspension well before use. Warm the medication to body temperature '
          'prior to use.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1174',
  ),
  // POLYSPORIN — PDF p. 365 (printed 1174)  [cross-reference]
  DrugEntryV3(
    name: 'POLYSPORIN',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Bacitracin ± Polymyxin B.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1174',
  ),
  // POLYTRIM OPHTHALMIC SOLUTION — PDF p. 365 (printed 1174)  [cross-reference]
  DrugEntryV3(
    name: 'POLYTRIM OPHTHALMIC SOLUTION',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Polymyxin B Sulfate and Trimethoprim Sulfate.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1174',
  ),
  // PORACTANT ALFA — PDF p. 365 (printed 1174)  [cross-reference]
  DrugEntryV3(
    name: 'PORACTANT ALFA',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Surfactant, Pulmonary/Poractant Alfa.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1174',
  ),
  // POSACONAZOLE — PDF p. 365–367 (printed 1174–1176)
  DrugEntryV3(
    name: 'POSACONAZOLE',
    brandNames: 'Noxafil, Noxafil PowderMix, and generics',
    drugClass: 'Antifungal agent',
    iconRow: '',
    formulations: [
      'Delayed-release tabs: 100 mg',
      'Injection: 300 mg/16.7 mL (16.7 mL); contains edetate disodium (EDTA) and '
          'sulfobutyl ether-β-cyclodextrin (SBECD)',
      'Oral suspension (immediate release): 40 mg/mL (105 mL); contains '
          'polysorbate 80 and sodium benzoate',
      'Delayed-release oral suspension (Noxafil PowderMix): 300 mg powder packet '
          'to be mixed with 9 mL of mixing liquid to yield a 30 mg/mL oral '
          'suspension (8 powder packets); contains sorbitol, parabens, and saccharin',
    ],
    doseSections: [
      DoseSection(
        heading: 'Invasive fungal infections treatment (a phase 2 clinical trial in '
            'children <2 yr old is currently being conducted; see '
            'clinicaltrials.gov):',
        lines: [
          DoseLine(
            'Immediate-release oral suspension (limited data from 33 pediatric '
                'oncology patients with a median age of 11.5 yr in whom it was noted that '
                'the adult maximum daily dose applied to those >13 yr may result in lower '
                'trough levels; see remarks for therapeutic drug monitoring '
                'recommendations):',
            isHeading: true,
          ),
          DoseLine(
            'Child ≥5 mo:',
            isHeading: true,
          ),
          DoseLine('<34 kg: 4.5–6 mg/kg/dose PO QID; max. dose: 800 mg/24 hr'),
          DoseLine('≥34 kg: 200 mg PO QID'),
          DoseLine(
            'IV (very limited data from two series comprising 12 bone marrow '
                'transplant patients and 2 hematology/oncology patients):',
            isHeading: true,
          ),
          DoseLine('Chlid 1.5–11 yr: 6–10 mg/kg/dose IV BID x 1 day, followed by 6–10 '
              'mg/kg/dose IV once daily; max. dose: 300 mg/dose'),
        ],
      ),
      DoseSection(
        heading: 'Prophylaxis for invasive Aspergillus and Candida in severely '
            'immunocompromised (e.g., hematopoietic stem cell recipients with '
            'graft-versus-host disease or those with hematologic malignancies with '
            'prolonged neutropenia); duration based on recovery from neutropenia '
            'or immunosuppression (see remarks):',
        lines: [
          DoseLine(
            'Delayed-release oral suspension (Noxafil PowderMix):',
            isHeading: true,
          ),
          DoseLine(
            '≥2 yr and 10–40 kg:',
            isHeading: true,
          ),
          DoseLine('10–<12 kg: 90 mg (3 mL) PO BID × 1 day, followed by 90 mg PO once daily'),
          DoseLine('12–<17 kg: 120 mg (4 mL) PO BID × 1 day, followed by 120 mg PO once daily'),
          DoseLine('17–<21 kg: 150 mg (5 mL) PO BID × 1 day, followed by 150 mg PO once daily'),
          DoseLine('21–<26 kg: 180 mg (6 mL) PO BID × 1 day, followed by 180 mg PO once daily'),
          DoseLine('26–<36 kg: 210 mg (7 mL) PO BID × 1 day, followed by 210 mg PO once daily'),
          DoseLine('36–40 kg: 240 mg (8 mL) PO BID × 1 day, followed by 240 mg PO once daily'),
          DoseLine(
            'Delayed-release tablet:',
            isHeading: true,
          ),
          DoseLine('≥2–<18 yr (>40 kg) and adult: 300 mg PO BID × 1 day, followed by 300 mg '
              'PO once daily'),
          DoseLine(
            'Immediate-release oral suspension:',
            isHeading: true,
          ),
          DoseLine('≥13 yr and adult: 200 mg PO TID'),
          DoseLine(
            'IV:',
            isHeading: true,
          ),
          DoseLine('≥2–<18 yr: 6 mg/kg/dose (max. dose: 300 mg/dose) IV BID × 1 day, followed '
              'by 6 mg/kg/dose (max. dose: 300 mg/dose) IV once daily'),
          DoseLine('Adult: 300 mg IV BID × 1 day, followed by 300 mg IV once daily'),
        ],
      ),
      DoseSection(
        heading: 'Invasive aspergillosis treatment:',
        lines: [
          DoseLine(
            'IV or delayed-release tablet (switching between these two dosage forms is '
                'acceptable):',
            isHeading: true,
          ),
          DoseLine('≥13 yr and adult: 300 mg IV/PO BID x 1 day, followed by 300 mg IV/PO once '
              'daily for 6–12 weeks'),
          DoseLine(
            'Immediate-release oral suspension:',
            isHeading: true,
          ),
          DoseLine('≥13 yr and adult (limited data): 200 mg PO TID or 400 mg PO BID for 6–12 '
              'weeks'),
        ],
      ),
      DoseSection(
        heading: 'Oropharyngeal candidiasis treatment for non–human immunodeficiency '
            'virus infected:',
        lines: [
          DoseLine(
            'Immediate-release oral suspension:',
            isHeading: true,
          ),
          DoseLine('≥13 yr and adult: 100 mg PO Q12 hr × 2 doses followed by 100 mg PO Q24 hr '
              '× 13 days'),
        ],
      ),
      DoseSection(
        heading: 'Refractory oropharyngeal candidiasis (refractory to '
            'itraconazole/fluconazole):',
        lines: [
          DoseLine(
            'Immediate-release oral suspension:',
            isHeading: true,
          ),
          DoseLine('≥13 yr and adult: 400 mg PO Q12 hr. Duration of therapy based on severity '
              'and response.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated with use of ergot alkaloids (e.g., ergotamine); major '
          'substrates for cytochrome P-450 (CYP) 3A4 (e.g., atorvastatin, '
          'lovastatin, simvastatin, sirolimus); or CYP 3A4 medications that prolong '
          'the Q–Tc interval (e.g., pimozide and quinidine). Also contraindicated in '
          'patients with chronic lymphocytic leukemia or small lymphocytic lymphoma '
          'who are treated with venetoclax during the initiation and ramp-up phase '
          'due to the potential for increased tumor lysis syndrome. Use with caution '
          'with electrolyte imbalances (correct prior to use), cardiac arrhythmias, '
          'and hepatic or renal impairment. Use of IV dosage form is not recommended '
          'for estimated glomerular filtration rate <50 mL/min due to the risk for '
          'accumulation of SBECD excipient.',
      'The delayed-release oral suspension (Noxafil PowderMix) is not '
          'recommended for patients weighing >40 kg (recommended dosage cannot be '
          'achieved with this dosage form) and is contraindicated for use in '
          'patients with hereditary fructose intolerance (dosage form contains '
          'sorbitol). Monitoring of trough levels is recommended due to concerns for '
          'large inter- and intrapatient pharmacokinetic variability. Therapeutic '
          'trough levels:',
      'Treatment of invasive molds: ≥1 mCg/mL',
      'Prophylaxis: ≥0.7 mCg/mL',
      'Recommended serum sampling time: obtain trough within 30 min prior to a '
          'dose; steady state is achieved 7 days after initiating therapy.',
      'Patients weighing >120 kg are reported to have a clinically significant '
          'faster clearance compared to those weighing at 70 kg.',
      'Hypokalemia, diarrhea, nausea, vomiting, headache, and fever are common '
          'side effects. Serious reactions include hypersensitivity reactions, '
          'arrhythmias, Q–Tc prolongation, and hepatotoxicity (consider '
          'discontinuing therapy). Pseudoaldosteronism and pancreatitis have been '
          'reported.',
      'Posaconazole is a substrate of UDP-glucoronosyltransferase 1–4 (UGT1A4) '
          'and P-glycoprotein efflux and strong inhibitor of CYP 3A4 (see earlier '
          'for contraindicated substrates for concurrent use). Use with vincristine '
          'has been associated with neurotoxicity, seizures, peripheral neuropathy, '
          'syndrome of inappropriate secretion of antidiuretic hormone, and '
          'paralytic ileus.',
      'Oral suspension dosage form is NOT substitutable with delayed-release '
          'tablets or delayed-release oral suspension. Use respective dosage form '
          'for specific indication. Administer delayed-release tablets with food to '
          'enhance absorption. Do not crush or chew delayed-release tablets. IV '
          'dosage information is currently limited in adults.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1174–1176',
  ),
  // POTASSIUM IODIDE — PDF p. 367–368 (printed 1176–1177)
  DrugEntryV3(
    name: 'POTASSIUM IODIDE',
    brandNames: 'Iosat, SSKI, ThyroShield, ThyroSafe, and others',
    drugClass: 'Antithyroid agent',
    iconRow: '',
    formulations: [
      'Tabs:',
      'Iosat [OTC]: 65 mg (50 mg iodine), 130 mg',
      'ThyroSafe [OTC]: 65 mg',
      'Oral solution:',
      'ThyroShield [OTC] and generics: 65 mg/mL (30 mL); contains parabens and '
          'saccharin',
      'Saturated solution of potassium iodide (SSKI): 1000 mg/mL (30, 240 mL); '
          '10 drops = 500 mg potassium iodide',
      'Potassium content is 6 mEq (234 mg) K⁺/g potassium iodide.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonatal Graves disease:',
        lines: [
          DoseLine('50–100 mg (about 1–2 drops of SSKI) PO once daily'),
        ],
      ),
      DoseSection(
        heading: 'Thyrotoxicosis:',
        lines: [
          DoseLine('Child: 50–250 mg (about 1–5 drops of SSKI) PO TID'),
          DoseLine('Adult: 50–500 mg (1–10 drops of SSKI) PO TID'),
        ],
      ),
      DoseSection(
        heading: 'Cutaneous or lymphocutaneous sporotrichosis (treat for 4–6 wk after '
            'lesions have completely healed; increase dose until either max. dose '
            'is achieved or signs of intolerance appear):',
        lines: [
          DoseLine('Child and adolescent (limited data): 50 mg PO TID. Dose may be gradually '
              'increased as tolerated to the max. dose of the lesser of 50 mg/kg/dose or '
              '2000–2500 mg PO TID.'),
          DoseLine('Adult: Start with 250 mg PO TID. Doses may be gradually increased as '
              'tolerated to the max. dose of 2000–2500 mg PO TID.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in pregnancy, hyperkalemia, iodine-induced goiter, and '
          'hypothyroidism. Use with caution in cardiac disease and renal failure. '
          'Gastrointestinal disturbance, metallic taste, rash, salivary gland '
          'inflammation, headache, lacrimation, and rhinitis are symptoms of iodism. '
          'Give with milk or water after meals. Monitor thyroid function tests. '
          'Onset of antithyroid effects: 1–2 days.',
      'Lithium carbonate and iodide-containing medications may have synergistic '
          'hypothyroid activity. Potassium-containing medications, potassium-sparing '
          'diuretics, and angiotensin-converting enzyme inhibitors may increase '
          'serum potassium levels.',
      'For use as a thyroid blocking agent in nuclear or radiation emergencies, '
          'see https://www.fda. '
          'gov/drugs/bioterrorism-and-drug-preparedness/radiation-emergencies',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1176–1177',
  ),
  // POTASSIUM SUPPLEMENTS — PDF p. 368–369 (printed 1177–1178)
  DrugEntryV3(
    name: 'POTASSIUM SUPPLEMENTS',
    brandNames: 'Many brand names and generics',
    drugClass: 'Electrolyte',
    iconRow: '',
    formulations: [
      'Potassium chloride (40 mEq K = 3 g KCl):',
      'Sustained-release caps: 8, 10 mEq',
      'Sustained-release tabs: 8, 10, 15, 20 mEq',
      'Powder: 10 mEq/packet (30s, 60s), 20 mEq/packet (30s, 50s, 100s)',
      'Oral solution/liquid: 10% (6.7 mEq/5 mL), 20% (13.3 mEq/5 mL) (473 mL)',
      'Injection (use with a calibrated infusion device): 0.1 mEq/mL (100 mL), '
          '0.2 mEq/mL (50, 100 mL), 0.4 mEq/mL (50, 100 mL); osmolarity: 200, 400, '
          '799 mOsmol/L, respectively; preservative-free',
      'Concentrated injection (must be diluted prior to use): 2 mEq/mL (5, 10, '
          '15, 20 mL); osmolarity: 4000 mOsmol/L; preservative-free',
      'Potassium gluconate (40 mEq K = 9.4 g K gluconate):',
      'Tabs: 465 mg (2 mEq), 581 mg (2.5 mEq)',
      'Caps [OTC as K-99]: 595 mg (2.56 mEq)',
      'Potassium acetate (40 mEq K = 3.9 g K acetate):',
      'Concentrated injection: 2 mEq/mL (20, 50 mL)',
      'Potassium bicarbonate/citric acid (10 mEq K = 1 g K bicarbonate):',
      'Effervescent tab for oral solution (Effer-K): 10, 20, 25 mEq; each 10 mEq '
          'K contains 0.84 g citric acid and delivers approximately 10 mEq '
          'bicarbonate',
      'Potassium phosphate:',
      'See Phosphorus Supplements.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Normal daily requirements: See Chapter 21.',
      ),
      DoseSection(
        heading: 'Replacement:',
        lines: [
          DoseLine('Determine based on maintenance requirements, deficit, and ongoing losses. '
              'See Chapter 11.'),
        ],
      ),
      DoseSection(
        heading: 'Hypokalemia:',
        lines: [
          DoseLine(
            'Oral (mild/moderate hypokalemia):',
            isHeading: true,
          ),
          DoseLine('Child: 1–4 mEq/kg/24 hr ÷ BID–QID. Monitor serum potassium.'),
          DoseLine('Adult: 40–100 mEq/24 hr ÷ BID–QID. Limit single doses by 20–25 mEq to '
              'minimize GI side effects.'),
          DoseLine('IV (severe hypokalemia): MONITOR SERUM K CLOSELY.'),
          DoseLine('Child: 0.5–1 mEq/kg/dose given as an infusion of 0.5 mEq/kg/hr × 1–2 hr'),
          DoseLine('Max. IV infusion rate: 1 mEq/kg/hr. This may be used in critical '
              'situations (i.e., hypokalemia with arrhythmia).'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Serum K ≥2.5 mEq/L: Replete at rates up to 10 mEq/hr. Total dosage not to '
              'exceed 200 mEq/24 hr.'),
          DoseLine('Serum K <2.5 mEq/L: Replete at rates up to 40 mEq/hr. Total dosage not to '
              'exceed 400 mEq/24 hr.'),
          DoseLine('Max. peripheral IV solution concentration: 40 mEq/L'),
          DoseLine('Max. concentration for central line administration: 150–200 mEq/L'),
        ],
      ),
    ],
    remarks: [
      'PO administration may cause gastrointestinal disturbance and ulceration. '
          'Oral liquid supplements should be diluted in water or fruit juice prior '
          'to administration. Sustained-release tablets must be swallowed whole and '
          'NOT dissolved in the mouth or chewed.',
      'Do not administer IV potassium undiluted. IV administration may cause '
          'irritation, pain, and phlebitis at the infusion site. Rapid or central IV '
          'infusion may cause cardiac arrhythmias. Patients receiving infusion >0.5 '
          'mEq/kg/hr (>20 mEq/hr for adults) should be placed on an '
          'electrocardiographic monitor.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1177–1178',
  ),
  // PRALIDOXIME CHLORIDE ± ATROPINE — PDF p. 369–370 (printed 1178–1179)
  DrugEntryV3(
    name: 'PRALIDOXIME CHLORIDE ± ATROPINE',
    brandNames: 'Protopam, 2-PAM, and generics\nIn combination with atropine: ATNAA',
    drugClass: 'Antidote, organophosphate poisoning',
    iconRow: '',
    formulations: [
      'Injection (Protopam): 1000 mg',
      'In combination with atropine (ATNNA):',
      'Injection for intramuscular injection in autoinjector device: 600 mg/2 mL '
          'of pralidoxime and 2.1 mg/0.7 mL of atropine; contains benzyl alcohol. '
          'ATNNA must be administered by emergency medical services personnel who '
          'have had adequate training in the recognition and treatment of nerve '
          'agent or insecticide intoxication.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Organophosphate poisoning (use with atropine):',
        lines: [
          DoseLine(
            'Infant, child, and adolescent:',
            isHeading: true,
          ),
          DoseLine('IV intermittent: 20–50 mg/kg/dose (max. dose: 2000 mg) IV × 1. May repeat '
              'in 1–2 hr if muscle weakness is not relieved, then at Q10–12 hr PRN if '
              'cholinergic signs reappear.'),
          DoseLine('IV continuous infusion: Loading dose of 20–50 mg/kg/dose (max. dose: 2000 '
              'mg) IV over 15–30 min followed by 10–20 mg/kg/hr (max. dose: 500 mg/hr)'),
          DoseLine(
            'IM (use when IV route not feasible):',
            isHeading: true,
          ),
          DoseLine('<40 kg: 15 mg/kg/dose IM × 1. May repeat Q15 min PRN up to a max. total '
              'dose of 45 mg/kg for mild symptoms; may repeat twice in rapid succession '
              'for severe symptoms (max. total dose of 45 mg/kg). For persistent '
              'symptoms, may repeat another maximum 45 mg/kg series (in 3 divided doses) '
              'approximately 1 hr after the last injection.'),
          DoseLine('≥40 kg: 600 mg IM × 1. May repeat Q15 min PRN up to a max. total dose of '
              '1800 mg for mild symptoms; may repeat twice in rapid succession for '
              'severe symptoms (max. total dose of 1800 mg). For persistent symptoms, '
              'may repeat another max. 1800 mg series (in 3 divided doses) approximately '
              '1 hr after the last injection.'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('IV intermittent: 1–2 g/dose IV × 1. May repeat in 1–2 hr if muscle '
              'weakness is not relieved, then at Q10–12 hr PRN if cholinergic signs '
              'reappear.'),
          DoseLine('IM: Use aforementioned ≥40 kg child IM dosage.'),
        ],
      ),
      DoseSection(
        heading: 'In combination with atropine (Duodote, ATNNA; see remarks for '
            'description of symptoms):',
      ),
      DoseSection(
        heading: 'Organophosphate poisoning:',
        lines: [
          DoseLine(
            'Child and adult >41 kg:',
            isHeading: true,
          ),
          DoseLine('Mild symptoms of nerve agent or insecticide exposure: Inject one '
              'prefilled syringe IM × 1 and wait 10–15 min for effect. If severe '
              'symptoms emerge at any time after the first dose, inject two additional '
              'prefilled syringes IM in rapid succession.'),
          DoseLine('Severe symptoms of nerve agent or insecticide exposure: Inject three '
              'prefilled syringes IM in rapid succession.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in poisonings due to phosphorus, inorganic phosphates, or '
          'organic phosphates without anticholinesterase activity. Do not use as an '
          'antidote for carbamate classes of pesticides. Removal of secretions and '
          'maintaining a patent airway are critical. May cause muscle rigidity, '
          'laryngospasm, and tachycardia after rapid IV infusion. Drug is generally '
          'ineffective if administered 36–48 hr after exposure. Additional doses may '
          'be necessary.',
      'For IV administration, dilute to 50 mg/mL or less and infuse over 15–30 '
          'min (not to exceed 200 mg/min). Reduce dosage in renal impairment since '
          '80%–90% of the drug is excreted unchanged in the urine 12 hr after '
          'administration. Severe hepatic impairment may require less frequent doses '
          'after the initial dose for both IV and IM routes.',
      'Pralidoxime and atropine combination (Duodote): Signs of atropine '
          'effects/toxicity may occur earlier than when atropine is used alone. '
          'Safety and efficacy data are only available for children and adults >41 '
          'kg (90 lb). Duodote product information description of mild and severe '
          'symptoms:',
      'Mild symptoms: Increased airway secretions, blurred vision, bradycardia, '
          'breathing difficulties, chest tightness, drooling, miosis, nausea, '
          'vomiting, runny nose, salivation, stomach cramps (acute onset), '
          'tachycardia, teary eyes, tremors/muscular twitching, wheezing/coughing',
      'Severe symptoms: Breathing difficulties (severe), confused/strange '
          'behavior, convulsions, copious secretions from lungs or airways, '
          'involuntary urination/defecation, muscular twitching/generalized weakness '
          '(severe), unconsciousness',
      'IM injection is via the midlateral thigh.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1178–1179',
  ),
  // PREDNISOLONE — PDF p. 370–371 (printed 1179–1180)
  DrugEntryV3(
    name: 'PREDNISOLONE',
    brandNames: 'Oral products:\nOrapred ODT, Pediapred, and generics; previously '
        'available as Prelone\nOphthalmic products:\nPred Forte, Pred Mild, '
        'and generics',
    drugClass: 'Corticosteroid',
    iconRow: '',
    formulations: [
      'Tabs: 5 mg',
      'Oral solution (generics): 15 mg/5 mL (240 mL); may contain alcohol and '
          'saccharin',
      'Tablets, orally disintegrating (as Na phosphate) (Orapred ODT and '
          'generics): 10, 15, 30 mg',
      'Oral solution/syrup (as Na phosphate):',
      'Pediapred and generics: 5 mg/5 mL (120 mL); may contain edetate disodium '
          '(EDTA) and parabens; some preparations may be alcohol and dye free',
      'Generics: 10 mg/5 mL (237 mL), 15 mg/5 mL (237 mL), 20 mg/5 mL (237 mL), '
          '25 mg/5 mL (237 mL); may contain parabens, alcohol; some preparations may '
          'be dye free',
      'Ophthalmic suspension (as acetate; both strengths contain benzalkonium '
          'chloride and may contain bisulfites):',
      'Pred Mild: 0.12% (5, 10 mL)',
      'PredForte and generics: 1% (5, 10, 15 mL)',
      'Ophthalmic solution (as Na phosphate): 1% (10 mL); may contain '
          'benzalkonium chloride',
    ],
    doseSections: [
      DoseSection(
        heading: 'See Prednisone for systemic oral dosing (equivalent dosing).',
      ),
      DoseSection(
        heading: 'Ophthalmic for steroid-responsive ocular inflammatory conditions '
            '(consult ophthalmologist before use; see remarks):',
        lines: [
          DoseLine(
            'Ophthalmic suspension (0.12% or 1%):',
            isHeading: true,
          ),
          DoseLine('Child (limited data) and adult: 1–2 drops to the conjunctival sac of the '
              'affected eye(s) BID–QID (dosage frequency may be increased during initial '
              '24–48 hr if needed). Reevaluate patient if signs and symptoms do not '
              'improve after 2 days.'),
          DoseLine(
            'Ophthalmic solution:',
            isHeading: true,
          ),
          DoseLine('Child and adult: Start with 1–2 drops Q1 hr during the day and Q2 hr '
              'during the night until favorable response, then reduce dose to 1 drop Q4 '
              'hr. Dose may be further reduced to 1 drop TID–QID.'),
        ],
      ),
    ],
    remarks: [
      'See Prednisone for remarks. See Chapter 10 for relative steroid '
          'potencies. Pregnancy category changes to “D” if used in the first '
          'trimester.',
      'OPHTHALMIC USE: Contraindicated in viral (e.g., herpes simplex, vaccinia, '
          'and varicella), fungal, and mycobacterial infections of the cornea and '
          'conjunctiva. Increase in intraocular pressure, cataract formation, eye '
          'pain, and delayed wound healing may occur.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1179–1180',
  ),
  // PREDNISONE — PDF p. 371–372 (printed 1180–1181)
  DrugEntryV3(
    name: 'PREDNISONE',
    brandNames: 'Rayos, Prednisone Intensol, and generics',
    drugClass: 'Corticosteroid',
    iconRow: '',
    formulations: [
      'Tabs: 1, 2.5, 5, 10, 20, 50 mg',
      'Delayed-release tabs (Rayos): 1, 2, 5 mg',
      'Oral solution: 1 mg/mL (120, 500 mL); may contain 5% alcohol and saccharin',
      'Concentrated solution (Prednisone Intensol): 5 mg/mL (30 mL); contains '
          '30% alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Acute asthma:',
        lines: [
          DoseLine('Child: 2 mg/kg/24 hr PO ÷ once daily–BID × 5–7 days; max. dose: 80 mg/24 '
              'hr. Patients may benefit from tapering if therapy exceeds 5–7 days.'),
          DoseLine(
            'Acute exacerbation in emergency care or hospital (2007 National Heart, '
                'Lung, and Blood Institute [NHLBI] Guideline Recommendations; dose until '
                'peak expiratory flow reaches 70% of predicted or personal best):',
            isHeading: true,
          ),
          DoseLine('Child ≤12 yr: 1–2 mg/kg/24 hr PO ÷ Q12 hr (max. dose: 60 mg/24 hr)'),
          DoseLine('Child >12 yr and adult: 40–80 mg/24 hr PO ÷ Q12–24 hr'),
          DoseLine(
            'Outpatient asthma exacerbation burst therapy (2007 NHLBI guidelines; '
                'therapy should be continued until symptoms resolve or until peak '
                'expiratory flow reaches 80% of personal best; usual therapy duration 3–10 '
                'days [average ~5 days]; longer durations may be necessary):',
            isHeading: true,
          ),
          DoseLine('Child ≤12 yr: 1–2 mg/kg/24 hr PO ÷ Q12–24 hr (max. dose: 60 mg/24 hr)'),
          DoseLine('Child >12 yr and adult: 40–60 mg/24 hr PO ÷ Q12–24 hr'),
          DoseLine(
            'Acute exacerbation in primary care or acute care facility (2020 Global '
                'Initiative for Asthma [GINA] Guidelines):',
            isHeading: true,
          ),
          DoseLine('Infant and child: 1–2 mg/kg/24 hr PO once daily × 3–5 days with the '
              'following maximum dose by age:'),
          DoseLine('Infant and child ≤2 yr: 20 mg/24 hr'),
          DoseLine('Child 3–5 yr: 30 mg/24 hr'),
          DoseLine('Child 6–11 yr: 40 mg/24 hr'),
          DoseLine('Child >12 yr and adolescent: 1 mg/kg/24 hr (max. dose: 50 mg/24 hr) PO '
              'once daily × 5–7 days'),
        ],
      ),
      DoseSection(
        heading: 'Antiinflammatory/immunosuppressive:',
        lines: [
          DoseLine('Child: 0.5–2 mg/kg/24 hr PO ÷ once daily–BID'),
        ],
      ),
      DoseSection(
        heading: 'Nephrotic syndrome:',
        lines: [
          DoseLine('Child (use ideal body weight for obese patients): Starting dose of 2 '
              'mg/kg/24 hr (max. dose: 60 mg/24 hr) PO ÷ once daily–TID is recommended. '
              'Further treatment plans are individualized. Consult a nephrologist.'),
        ],
      ),
    ],
    remarks: [
      'See Chapter 10 for physiologic replacement, relative steroid potencies, '
          'and doses based on body surface area.',
      'Despite requiring hepatic metabolism to its active form (prednisolone), '
          'patients with liver disease have reported higher prednisolone levels than '
          'that of normal patients. Methylprednisolone or prednisolone may be '
          'preferable in hepatic disease.',
      'Side effects may include: mood changes, seizures, hyperglycemia, '
          'diarrhea, nausea, abdominal distention, gastrointestinal bleeding, '
          'hypothalamic-pituitary-adrenal axis suppression, osteopenia, cushingoid '
          'effects, and cataracts with prolonged use. As with all corticosteroids, '
          'may cause immunosuppression and increase risk of infection. Prednisone is '
          'a cytochrome P-450 3A3/3A4 substrate and inducer. Barbiturates, '
          'carbamazepine, phenytoin, rifampin, and isoniazid may reduce the effects '
          'of prednisone, whereas estrogens may enhance the effects. Pregnancy '
          'category changes to “D” if used in the first trimester.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1180–1181',
  ),
  // PRIMAQUINE PHOSPHATE — PDF p. 372–373 (printed 1181–1182)
  DrugEntryV3(
    name: 'PRIMAQUINE PHOSPHATE',
    brandNames: 'Various generics',
    drugClass: 'Antimalarial',
    iconRow: '',
    formulations: [
      'Tabs: 26.3 mg (15 mg base)',
      'Oral suspension: 10.52 mg (6 mg base)/5 mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Doses expressed in mg of primaquine base (see remarks):',
        lines: [
          DoseLine(
            'Malaria:',
            isHeading: true,
          ),
          DoseLine(
            'Prevention of relapses for Plasmodium vivax or Plasmodium ovale only '
                '(initiate therapy during the last 2 wk of, or following a course of, '
                'suppression with chloroquine or comparable drug):',
            isHeading: true,
          ),
          DoseLine('Child: 0.5 mg/kg/dose (max. dose: 30 mg/dose) PO once daily × 14 days'),
          DoseLine('Adult: 30 mg PO once daily × 14 days'),
          DoseLine(
            'Prevention of chloroquine-resistant strains (initiate 1 day prior to '
                'departure and continued until 7 days after leaving endemic area):',
            isHeading: true,
          ),
          DoseLine('Child: 0.5 mg/kg/dose PO once daily; max. dose: 30 mg/24 hr'),
          DoseLine('Adult: 30 mg PO once daily'),
          DoseLine(
            'P. jirovecii (carinii) pneumonia (in combination with clindamycin):',
            isHeading: true,
          ),
          DoseLine('Infant and child: 0.3 mg/kg/dose (max. dose: 30 mg/dose) PO once daily × '
              '21 days'),
          DoseLine('Adult: 30 mg PO once daily × 21 days'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in granulocytopenia (e.g., rheumatoid arthritis, lupus '
          'erythematosus) and bone marrow suppression. Avoid use with quinacrine and '
          'with other drugs that have a potential for causing hemolysis or bone '
          'marrow suppression. Use with caution in patients with glucose-6-phosphate '
          'dehydrogenase and nicotinamide adenine dinucleotide–methemoglobin '
          'reductase deficiency due to increased risk for hemolytic anemia and '
          'leukopenia, respectively. Monitor electrocardiogram for Q–Tc prolongation '
          'in patients with cardiac disease, history of arrhythmias, uncorrected '
          'hypokalemia and/or hypomagnesemia, bradycardia, and receiving concomitant '
          'Q–Tc prolonging medications. Use in pregnancy is not recommended by the '
          'AAP Red Book. Cross sensitivity with iodoquinol.',
      'May cause headache, visual disturbances, nausea, vomiting, and abdominal '
          'cramps. Hemolytic anemia, leukopenia, cardiac arrhythmia, Q–Tc interval '
          'prolongation, and methemoglobinemia have been reported. Administer all '
          'doses with food to mask bitter taste.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1181–1182',
  ),
  // PRIMIDONE — PDF p. 373 (printed 1182)
  DrugEntryV3(
    name: 'PRIMIDONE',
    brandNames: 'Mysoline and generics',
    drugClass: 'Anticonvulsant, barbiturate',
    iconRow: '',
    formulations: [
      'Tabs:',
      'Generics: 50, 125, 250 mg',
      'Mysoline: 50, 250 (scored) mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate:',
        lines: [
          DoseLine('12–20 mg/kg/24 hr PO ÷ BID–QID; initiate therapy at the lower dosage '
              'range and titrate upward.'),
        ],
      ),
      DoseSection(
        heading: 'Child, adolescent, and adult:',
        table: DoseTable(
          headers: ['Day of Therapy', '<8 Yr', '≥8 Yr and Adult'],
          rows: [
            DoseTableRow(['Days 1–3', '50 mg PO QHS', '100–125 mg PO QHS']),
            DoseTableRow(['Days 4–6', '50 mg PO BID', '100–125 mg PO BID']),
            DoseTableRow(['Days 7–9', '100 mg PO BID', '100–125 mg PO TID']),
            DoseTableRow(['Day 10 and thereafter', '125–250 mg PO TID or 10–25 mg/kg/ 24 hr PO ÷ TID–QID', '250 mg PO TID–QID; max. dose: 2 g/24 hr']),
          ],
        ),
      ),
    ],
    remarks: [
      'Use with caution in renal or hepatic disease and pulmonary insufficiency. '
          'Primidone is metabolized to phenobarbital and has the same drug '
          'interactions and toxicities (see Phenobarbital). In addition, primidone '
          'may cause vertigo, nausea, leukopenia, malignant lymphoma–like syndrome, '
          'diplopia, nystagmus, and systemic lupus erythematosus–like syndrome. '
          'Monitor for suicidal behavior or ideation. Acetazolamide may decrease '
          'primidone absorption. Adjust dose in renal failure (see Chapter 32).',
      'Monitor both primidone and phenobarbital levels. Therapeutic levels: 5–12 '
          'mg/L of primidone and 15–40 mg/L of phenobarbital. Recommended serum '
          'sampling time at steady state: trough level obtained within 30 min prior '
          'to the next scheduled dose after 1–4 days of continuous dosing.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1182',
  ),
  // PROBENECID — PDF p. 374 (printed 1183)
  DrugEntryV3(
    name: 'PROBENECID',
    brandNames: 'Various generics',
    drugClass: 'Penicillin therapy adjuvant, uric acid–lowering agent',
    iconRow: '',
    formulations: [
      'Tabs: 500 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'To prolong penicillin levels.',
        lines: [
          DoseLine('Child (2–14 yr): 25 mg/kg PO × 1, then 40 mg/kg/24 hr PO ÷ QID; max. '
              'single dose: 500 mg/dose. Use adult dose if >50 kg.'),
          DoseLine('Adult: 500 mg PO QID'),
        ],
      ),
      DoseSection(
        heading: 'Hyperuricemia with gout:',
        lines: [
          DoseLine('Adult: 250 mg PO BID × 1 wk, then 500 mg PO BID; may increase by 500-mg '
              'increments Q4 wk PRN up to a max. dose of 2–3 g/24 hr ÷ BID'),
        ],
      ),
      DoseSection(
        heading: 'Gonorrhea, antibiotic adjunct (administer just prior to antibiotic):',
        lines: [
          DoseLine('≤45 kg: 23 mg/kg/dose PO × 1'),
          DoseLine('>45 kg: 1 g PO × 1'),
        ],
      ),
      DoseSection(
        heading: 'Prevention of nephrotoxicity from cidofovir:',
        lines: [
          DoseLine('See Cidofovir.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in patients with peptic ulcer disease. Contraindicated '
          'in children <2 yr and patients with renal insufficiency. Do not use if '
          'glomerular filtration rate <30 mL/min.',
      'Increases uric acid excretion. Inhibits renal tubular secretion of '
          'acyclovir, ganciclovir, ciprofloxacin, levofloxacin, nalidixic acid, '
          'moxifloxacin, organic acids, penicillins, cephalosporins, azidothymidine, '
          'dapsone, methotrexate, nonsteroidal antiinflammatory agents, and '
          'benzodiazepines. Salicylates may decrease probenecid’s activity. '
          'Alkalinize urine in patients with gout. May cause headache, '
          'gastrointestinal symptoms, rash, anemia, and hypersensitivity. '
          'False-positive glucosuria with Clinitest may occur.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1183',
  ),
  // PROCHLORPERAZINE — PDF p. 374–375 (printed 1183–1184)
  DrugEntryV3(
    name: 'PROCHLORPERAZINE',
    brandNames: 'Compro and generics; previously available as Compazine',
    drugClass: 'Antiemetic, phenothiazine derivative',
    iconRow: '',
    formulations: [
      'Tabs (as maleate): 5, 10 mg',
      'Suppository (Compro and generics): 25 mg (12s)',
      'Injection (as edisylate): 5 mg/mL (2 mL); may contain benzyl alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Antiemetic doses:',
        lines: [
          DoseLine(
            'Child (≥2 yr and ≥9 kg):',
            isHeading: true,
          ),
          DoseLine('PO or PR: 0.4 mg/kg/24 hr ÷ TID–QID PRN (max. dose: 10 mg/dose) or '
              'alternative dosing by weight:'),
          DoseLine('9–13 kg: 2.5 mg once daily–BID PRN; max. dose: 7.5 mg/24 hr'),
          DoseLine('>13–18 kg: 2.5 mg BID–TID PRN; max. dose: 10 mg/24 hr'),
          DoseLine('>18–39 kg: 2.5 mg TID or 5 mg BID PRN; max. dose: 15 mg/24 hr'),
          DoseLine('>39 kg: Use adult dose.'),
          DoseLine('IM: 0.1–0.15 mg/kg/dose BID–TID PRN; max. dose: 10 mg/single dose or 40 '
              'mg/24 hr'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('PO: 5–10 mg/dose TID–QID PRN; max. dose: 40 mg/24 hr'),
          DoseLine('PR: 25 mg/dose BID PRN'),
          DoseLine('IM: 5–10 mg/dose Q3–4 hr PRN'),
          DoseLine('IV: 2.5–10 mg/dose; may repeat Q3–4 hr PRN'),
          DoseLine('Max. IM/IV dose: 40 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Psychoses:',
        lines: [
          DoseLine(
            'Child 2–12 yr and >9 kg:',
            isHeading: true,
          ),
          DoseLine('PO: Start with 2.5 mg BID–TID with a max. first-day dose of 10 mg/24 hr. '
              'Dose may be increased as needed to 20 mg/24 hr for children 2–5 yr and 25 '
              'mg/24 hr for 6–12 yr.'),
          DoseLine('IM: 0.13 mg/kg/dose × 1 and convert to PO immediately'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('PO: 5–10 mg TID–QID; may be increased as needed to a max. dose of 150 '
              'mg/24 hr'),
          DoseLine('IM: 10–20 mg Q2–4 hr PRN; convert to PO immediately'),
        ],
      ),
      DoseSection(
        heading: 'Intractable migraines:',
        lines: [
          DoseLine('Child (5–18 yr, limited data): 0.15 mg/kg/dose (max. dose: 10 mg/dose) IV '
              'over 10 min was effective in migraine headaches presenting in the '
              'emergency departments (see Ann Emerg Med. 2004;43:256–262).'),
        ],
      ),
    ],
    remarks: [
      'Toxicity as for other phenothiazines (see Chlorpromazine). Extrapyramidal '
          'reactions (reversed by diphenhydramine) or orthostatic hypotension may '
          'occur. May mask signs and symptoms of overdosage of other drugs and may '
          'obscure the diagnosis and treatment of conditions such as intestinal '
          'obstruction, brain tumor, and Reye syndrome. May cause false-positive '
          'test for phenylketonuria, urinary amylase, uroporphyrins, and '
          'urobilinogen. IV route in children is typically avoided due to '
          'hypotension risk. Use only in management of prolonged vomiting of known '
          'etiology.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1183–1184',
  ),
  // PROMETHAZINE — PDF p. 375–376 (printed 1184–1185)
  DrugEntryV3(
    name: 'PROMETHAZINE',
    brandNames: 'Phenergan, Promethegan, and generics',
    drugClass: 'Antihistamine, antiemetic, phenothiazine derivative',
    iconRow: '',
    formulations: [
      'Tabs: 12.5, 25, 50 mg',
      'Oral solution/syrup: 6.25 mg/5 mL (473 mL); contains alcohol and may '
          'contain parabens, sodium benzoate, or phenol (many formulations exist)',
      'Suppository (Promethegan and generics): 12.5, 25, 50 mg (12s)',
      'Injection: 25, 50 mg/mL (1 mL); may contain edetate disodium (EDTA), '
          'sulfites, and phenol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Antihistaminic:',
        lines: [
          DoseLine('Child ≥2 yr: 0.1 mg/kg/dose PO (max. dose: 12.5 mg/dose) Q6 hr during the '
              'day hours and 0.5 mg/kg/dose PO (max. dose: 25 mg/dose) QHS PRN'),
          DoseLine('Adult: 6.25–12.5 mg PO/PR TID OR 25 mg QHS'),
        ],
      ),
      DoseSection(
        heading: 'Nausea and vomiting PO/IM/IV/PR (see remarks):',
        lines: [
          DoseLine('Child ≥2 yr: 0.25–1 mg/kg/dose Q4–6 hr PRN; max. dose: 25 mg/dose'),
          DoseLine('Adult: 12.5–25 mg Q4–6 hr PRN'),
        ],
      ),
      DoseSection(
        heading: 'Motion sickness:',
        lines: [
          DoseLine('(1st dose 0.5–1 hr before departure):'),
          DoseLine('Child ≥2 yr: 0.5 mg/kg/dose PO/PR Q12 hr PRN; max. dose: 25 mg/dose'),
          DoseLine('Adult: 25 mg PO Q8–12 hr PRN'),
        ],
      ),
    ],
    remarks: [
      'Avoid use in children <2 yr because of risk for fatal respiratory '
          'depression. Toxicity similar to other phenothiazines (see '
          'Chlorpromazine). Do not administer SC or intra-arterially because of '
          'severe local reactions. IV route of administration is not recommended (IM '
          'preferred) due to severe tissue injury (tissue necrosis and gangrene). If '
          'using IV route, dilute 25 mg/mL strength product with 10–20 mL normal '
          'saline and administer over 10–15 min, consider lower initial doses, '
          'administer through a large-bore vein and check patency of line before '
          'administering, administer through an IV line at the port farthest from '
          'the patient’s vein, and monitor for burning or pain during or after '
          'injection. Administer oral doses with meals to decrease gastrointestinal '
          'irritation.',
      'May cause profound sedation, blurred vision, respiratory depression (use '
          'lowest effective dose in children and avoid concomitant use of '
          'respiratory depressants), and dystonic reactions (reversed by '
          'diphenhydramine). Cholestatic jaundice and neuroleptic malignant syndrome '
          'has been reported. May interfere with pregnancy tests (immunologic '
          'reactions between human chorionic gonadotropin [hCG] and anti-hCG). For '
          'nausea and vomiting, use only in management of prolonged vomiting of '
          'known etiology.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1184–1185',
  ),
  // PROPRANOLOL — PDF p. 376–377 (printed 1185–1186)
  DrugEntryV3(
    name: 'PROPRANOLOL',
    brandNames: 'Inderal LA, Hemangeol, and generics; previously available as Inderal',
    drugClass: 'Adrenergic blocking agent (β), class II antiarrhythmic',
    iconRow: '',
    formulations: [
      'Tabs: 10, 20, 40, 60, 80 mg',
      'Extended-release caps (Inderal LA and others, including generics): 60, '
          '80, 120, 160 mg',
      'Oral solution: 20 mg/5 mL, 40 mg/5 mL (500 mL); contains parabens and '
          'saccharin',
      'Hemangeol: 4.28 mg/mL (120 mL); alcohol, sugar and paraben free; contains '
          'saccharin',
      'Injection: 1 mg/mL (1 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Arrhythmias:',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('IV: 0.01–0.1 mg/kg/dose IV push over 10 min, repeat Q6–8 hr PRN; max. '
              'dose: 1 mg/dose for infant; 3 mg/dose for child and adolescent'),
          DoseLine('PO: Start at 0.5–1 mg/kg/24 hr ÷ Q6–8 hr; increase dosage Q3–5 days PRN. '
              'Usual dosage range: 2–4 mg/kg/24 hr ÷ Q6–8 hr; max. dose: 60 mg/24 hr or '
              '16 mg/kg/24 hr'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('IV: 1–3 mg/dose x 1, may repeat after 2 min. Additional doses may be '
              'given after 4 hr.'),
          DoseLine('PO: 10–30 mg/dose TID–QID; increase PRN. Usual range 30–160 mg/24 hr ÷ '
              'TID–QID'),
        ],
      ),
      DoseSection(
        heading: 'Hypertension (as alternative therapy):',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('PO: Initial: 0.5–1 mg/kg/24 hr ÷ Q6–12 hr. May increase dose Q5–7 days '
              'PRN; max. dose: 8 mg/kg/24 hr'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('PO: 40 mg/dose BID or 60–80 mg/dose (sustained release capsule) once '
              'daily. May increase 10–20 mg/dose Q3–7 days; max. dose: 640 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Migraine prophylaxis:',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('<35 kg: Start with 10 mg PO once daily and increase dose PRN weekly '
              'intervals at 10-mg increments. Usual dosage range: 10–20 mg PO TID'),
          DoseLine('≥35 kg: 20–40 mg PO TID'),
          DoseLine('Adult: 80 mg/24 hr PO ÷ Q6–8 hr; increase dose by 20–40 mg/dose Q3–4 wk '
              'PRN. Usual effective dose range: 160–240 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Tetralogy spells:',
        lines: [
          DoseLine('IV: 0.15–0.25 mg/kg/dose slow IV push. Max. initial dose: 1 mg/dose. May '
              'repeat in 15 min × 1. See also Chapter 7.'),
          DoseLine('PO: Start at 2–4 mg/kg/24 hr ÷ Q6 hr PRN. Usual dose range: 4–8 mg/kg/24 '
              'hr ÷ Q6 hr PRN. Doses as high as 15 mg/kg/24 hr have been used with '
              'careful monitoring.'),
        ],
      ),
      DoseSection(
        heading: 'Thyrotoxicosis:',
        lines: [
          DoseLine('Neonate: 0.5–2 mg/kg/24 hr PO ÷ Q6–12 hr'),
          DoseLine('Infant and child: 0.5–2 mg/kg/24 hr PO ÷ Q8 hr; max. dose: 40 mg/dose'),
          DoseLine(
            'Adolescent and adult:',
            isHeading: true,
          ),
          DoseLine('IV: 1–3 mg/dose over 10 min. May repeat in 4–6 hr'),
          DoseLine('PO: 10–40 mg/dose PO Q6–8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Infantile hemangioma (see remarks):',
        lines: [
          DoseLine('Infant (5 wk–5 mo and ≥2 kg; labeled dosing information for Hemangeol '
              'product): 0.6 mg/kg/dose PO BID (at least 9 hr apart) × 7 days, then '
              'increase to 1.1 mg/kg/dose PO BID × 14 days, followed by 1.7 mg/kg/dose '
              'PO BID × 6 mo'),
          DoseLine('Alternative dosing: Start at 1 mg/kg/24 hr PO ÷ Q8 hr. If tolerated after '
              '1 day, increase dose to 2 mg/kg/24 hr PO ÷ Q8 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in asthma, Raynaud syndrome, heart failure, and heart '
          'block. Not indicated for the treatment of hypertensive emergencies. Use '
          'with caution in presence of obstructive lung disease, diabetes mellitus, '
          'or renal or hepatic disease. May cause hypoglycemia, hypotension, nausea, '
          'vomiting, depression, weakness, impotence, bronchospasm, and heart block. '
          'Cutaneous reactions, including Stevens-Johnson syndrome, toxic epidermal '
          'necrolysis, exfoliative dermatitis, erythema multiforme, and urticaria, '
          'have been reported. Acute hypertension has occurred after insulin-induced '
          'hypoglycemia in patients on propranolol.',
      'Therapeutic levels for β-blockade: 50–100 ng/mL; ventricular arrhythmia: '
          '40–85 ng/mL. Drug is metabolized by cytochrome P-4501A2, 2C18, 2C19, and '
          '2D6 isoenzymes. Concurrent administration with barbiturates, '
          'indomethacin, or rifampin may cause decreased activity of propranolol. '
          'Concurrent administration with cimetidine, hydralazine, flecainide, '
          'quinidine, chlorpromazine, or verapamil may lead to increased activity of '
          'propranolol. Avoid IV use of propranolol with calcium channel blockers; '
          'may increase effect of calcium channel blocker. Use with amiodarone may '
          'increase negative chronotropic effects.',
      'For infantile hemangioma, monitor blood pressure and heart rate 2 hr '
          'after initiating therapy and after dose increases. To reduce risk of '
          'hypoglycemia, administer doses during or right after a feeding; hold '
          'doses if child is not eating or is vomiting. Infants <6 mo must be fed '
          'every 4 hr. Common adverse effects (>10%) reported in clinical trials '
          'with Hemangeol include sleep disorders, aggravated respiratory tract '
          'infections (e.g., bronchitis and bronchiolitis) associated with '
          'cough/fever, diarrhea, and vomiting. Readjust dose periodically with '
          'changes (increases) in child’s body weight.',
      'Successful use in infantile hepatic hemangiomas has also been reported.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1185–1186',
  ),
  // PROPYLTHIOURACIL — PDF p. 377–378 (printed 1186–1187)
  DrugEntryV3(
    name: 'PROPYLTHIOURACIL',
    brandNames: 'PTU and generics',
    drugClass: 'Antithyroid agent',
    iconRow: '',
    formulations: [
      'Tabs: 50 mg',
      'Oral suspension: 5 mg/mL',
      '100 mg PTU = 10 mg methimazole',
    ],
    doseSections: [
      DoseSection(
        heading: 'Dosages should be adjusted as required to achieve and maintain '
            'thyroxine, thyroid-stimulating hormone (TSH) levels in normal ranges.',
      ),
      DoseSection(
        heading: 'Neonate:',
        lines: [
          DoseLine('5–10 mg/kg/24 hr PO ÷ Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Child:',
        lines: [
          DoseLine('Initial: 5–7 mg/kg/24 hr PO ÷ Q8 hr, OR by age:'),
          DoseLine('6–10 yr: 50–150 mg/24 hr PO ÷ Q8 hr'),
          DoseLine('>10 yr: 150–300 mg/24 hr PO ÷ Q8 hr'),
          DoseLine('Maintenance: Generally begins after 2 mo. Usually 1/3–2/3 the initial '
              'dose in divided doses (Q8–12 hr) when the patient is euthyroid'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Initial: 300–400 mg/24 hr PO ÷ Q6–8 hr; some may require larger doses of '
              '600–900 mg/24 hr'),
          DoseLine('Maintenance: 100–150 mg/24 hr PO ÷ Q8 hr'),
        ],
      ),
    ],
    remarks: [
      'Generally reserved for patients who are unable to tolerate methimazole '
          'and for whom radioactive iodine or surgery is not appropriate. May be the '
          'antithyroid treatment of choice during or just prior to the first '
          'trimester of pregnancy because of risk of fetal abnormalities associated '
          'with methimazole.',
      'May cause blood dyscrasias, fever, liver disease, dermatitis, urticaria, '
          'malaise, central nervous system stimulation or depression, and '
          'arthralgias. Glomerulonephritis, severe liver injury/failure, '
          'agranulocytosis, severe vasculitis, interstitial pneumonitis, exfoliative '
          'dermatitis, and erythema nodosum have also been reported. May decrease '
          'the effectiveness of warfarin. Monitor thyroid function. A dose reduction '
          'of β-blocker may be necessary when the hyperthyroid patient becomes '
          'euthyroid.',
      'For neonates, crush tablets, weigh appropriate dose, and mix in '
          'formula/breast milk. Adjust dose in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1186–1187',
  ),
  // PROSTAGLANDIN E₁SEE ALPROSTADIL. — PDF p. 378 (printed 1187)  [cross-reference]
  DrugEntryV3(
    name: 'PROSTAGLANDIN E₁SEE ALPROSTADIL.',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1187',
  ),
  // PROTAMINE SULFATE — PDF p. 378–379 (printed 1187–1188)
  DrugEntryV3(
    name: 'PROTAMINE SULFATE',
    brandNames: 'Various generics',
    drugClass: 'Antidote, heparin',
    iconRow: '',
    formulations: [
      'Injection: 10 mg/mL (5, 25 mL); preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Heparin antidote, IV:',
        lines: [
          DoseLine('1 mg protamine will neutralize 115 U porcine intestinal heparin, or 100 U '
              '(1 mg) low-molecular-weight heparin'),
          DoseLine(
            'Consider time since last heparin dose:',
            isHeading: true,
          ),
          DoseLine('If <0.5 hr: Give 100% of specified dose.'),
          DoseLine('If within 0.5–1 hr: Give 50%–75% of aforementioned dose.'),
          DoseLine('If within 1–2 hr: Give 37.5%–50% of aforementioned dose.'),
          DoseLine('If ≥2 hr: Give 25%–37.5% of aforementioned dose.'),
          DoseLine('Max. dose: 50 mg/dose IV'),
          DoseLine('Max. infusion rate: 5 mg/min'),
          DoseLine('Max. IV concentration: 10 mg/mL'),
          DoseLine(
            'If heparin was administered by deep SC injection, give 1–1.5 mg protamine '
                'per 100 U heparin as follows:',
            isHeading: true,
          ),
          DoseLine('Load with 25–50 mg via slow IV infusion followed by the rest of the '
              'calculated dose via continuous infusion over 8–16 hr or the expected '
              'duration of SC heparin absorption.'),
        ],
      ),
      DoseSection(
        heading: 'Enoxaparin overdosage, IV (see remarks):',
        lines: [
          DoseLine('Approximately 1 mg protamine will neutralize 1 mg enoxaparin.'),
          DoseLine(
            'Consider time since last enoxaparin dose:',
            isHeading: true,
          ),
          DoseLine('If <8 hr: Give 100% of aforementioned dose.'),
          DoseLine('If within 8–12 hr: Give 50% of aforementioned dose.'),
          DoseLine('If >12 hr: Protamine not required but if serious bleeding is present, '
              'give 50% of aforementioned dose.'),
          DoseLine('If aPTT remains prolonged 2–4 hr after the first protamine dose or if '
              'bleeding continues, a second infusion of 0.5 mg protamine per 1 mg '
              'enoxaparin may be given.'),
          DoseLine('Max. dose: 50 mg/dose. See aforementioned heparin antidote IV dosage for '
              'max. administration concentration and rate.'),
        ],
      ),
    ],
    remarks: [
      'Risk factors for protamine hypersensitivity include known '
          'hypersensitivity to fish and exposure to protamine-containing insulin or '
          'prior protamine therapy.',
      'May cause hypotension, bradycardia, dyspnea, and anaphylaxis. Monitor '
          'activated partial thromboplastin time or activated coagulation time. '
          'Heparin rebound with bleeding has been reported to occur 8–18 hr later.',
      'Use in enoxaparin overdose may not be complete despite using multiple '
          'doses of protamine.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1187–1188',
  ),
  // PSEUDOEPHEDRINE — PDF p. 379 (printed 1188)
  DrugEntryV3(
    name: 'PSEUDOEPHEDRINE',
    brandNames: 'Sudafed, Children\'s Sudafed, Sudafed 12 Hour, Sudafed 24 Hour, and '
        'generics',
    drugClass: 'Sympathomimetic, nasal decongestant',
    iconRow: '',
    formulations: [
      'Tabs (OTC): 30, 60 mg',
      'Extended-release tab (OTC):',
      'Sudafed 12 Hour and generics: 120 mg',
      'Sudafed 24 Hour: 240 mg',
      'Oral liquid:',
      'Children’s Sudafed (OTC): 15 mg/5 mL (120 mL); alcohol and sugar free; '
          'contains edetate disodium (EDTA), polyethylene glycol, and sodium benzoate',
      'Purchases of over-the-counter (OTC) products are limited to '
          'behind-the–pharmacy counter sales with monthly sale limits due to the '
          'methamphetamine epidemic.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child <12 yr:',
        lines: [
          DoseLine('4 mg/kg/24 hr PO ÷ Q6 hr or by age:'),
          DoseLine('<4 yr: 4 mg/kg/24 hr PO ÷ Q6 hr; max. dose: 60 mg/24 hr'),
          DoseLine('4–5 yr: 15 mg/dose PO Q4–6 hr; max. dose: 60 mg/24 hr'),
          DoseLine('6–12 yr: 30 mg/dose PO Q4–6 hr; max. dose: 120 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Child ≥12 yr and adult:',
        lines: [
          DoseLine('Immediate release: 60 mg/dose PO Q4–6 hr; max. dose: 240 mg/24 hr'),
          DoseLine(
            'Sustained release:',
            isHeading: true,
          ),
          DoseLine('Sudafed 12 Hour and generics: 120 mg PO Q12 hr'),
          DoseLine('Sudafed 24 Hour: 240 mg PO Q24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated with monoamine oxidase inhibitor drugs and in severe '
          'hypertension and severe coronary artery disease. Use with caution in '
          'mild/moderate hypertension, hyperglycemia, hyperthyroidism, and cardiac '
          'disease. May cause dizziness, nervousness, restlessness, insomnia, and '
          'arrhythmias. Pseudoephedrine is a common component of OTC cough and cold '
          'preparations and is combined with several antihistamines; these products '
          'are not recommended for children <6 yr. Since drug and active metabolite '
          'are primarily excreted renally, doses should be adjusted in renal '
          'impairment. May cause false-positive test for amphetamines (EMIT assay).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1188',
  ),
  // PSYLLIUM — PDF p. 380 (printed 1189)
  DrugEntryV3(
    name: 'PSYLLIUM',
    brandNames: 'Metamucil, Konsyl Original Formula, and many others, including some '
        'generics',
    drugClass: 'Bulk-forming laxative',
    iconRow: '',
    formulations: [
      'Check specific product label for amount of psyllium per unit of '
          'measurement.',
      'Granules [OTC]:',
      'Konsyl Original Formula: 6 g psyllium per rounded teaspoon (300 g); '
          'contains 50 mg potassium for each 6-g dose; sugar and gluten free',
      'Powder [OTC]:',
      'Metamucil: 3.4 g psyllium per rounded teaspoon (37.1 oz) or individual '
          '5.8-g packet (30s); contains 5 mg sodium, 30 mg potassium, and 25 mg '
          'phenylalanine for each teaspoon or packet. Other products may contain '
          'sucrose or maltodextrin instead of phenylalanine.',
      '3.4 g psyllium hydrophilic mucilloid is equivalent to 2 g soluble fiber',
    ],
    doseSections: [
      DoseSection(
        heading: 'Constipation (granules or powder must be mixed with a full glass [240 '
            'mL] of water or juice):',
        lines: [
          DoseLine('<6 yr: 1.25–2.5 g/dose PO once daily–TID; max. dose: 7.5 g/24 hr'),
          DoseLine('6–11 yr: 2.5–3.75 g/dose PO once daily–TID; max. dose: 15 g/24 hr'),
          DoseLine('≥12 yr and adult: 2.5–7.5 g/dose PO once daily–TID; max. dose: 30 g/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in cases of fecal impaction or gastrointestinal '
          'obstruction. Use with caution in patients with esophageal strictures and '
          'rectal bleeding. Phenylketonurics should be aware that certain '
          'preparations may contain aspartame. Should be taken or mixed with a full '
          'glass (240 mL) of liquid. Onset of action: 12–72 hr.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1189',
  ),
  // PYRANTEL PAMOATE — PDF p. 380 (printed 1189)
  DrugEntryV3(
    name: 'PYRANTEL PAMOATE',
    brandNames: 'Reese’s Pinworm Medicine, Pin-Away, Pin Rid, and many other generics',
    drugClass: 'Anthelmintic',
    iconRow: '',
    formulations: [
      'Oral suspension (OTC):',
      'Reese’s Pinworm Medicine, Pin-Away, and generics: 50 mg/mL pyrantel base '
          '(144 mg/mL pyrantel pamoate) (30, 60 mL); may contain sodium benzoate, '
          'parabens, and saccharin',
      'Tabs (OTC): 62.5 mg pyrantel base (180 mg pyrantel pamoate); scored tablet',
      'Chewable tab (OTC):',
      'Pin Rid: 250 mg pyrantel base (720.5 mg pyrantel pamoate)',
    ],
    doseSections: [
      DoseSection(
        heading: 'All doses expressed in terms of pyrantel base.',
      ),
      DoseSection(
        heading: 'Child (≥2 yr), adolescent, and adult:',
        lines: [
          DoseLine('Ascaris (roundworm) and Trichostrongylus: 11 mg/kg/dose PO × 1'),
          DoseLine('Enterobius (pinworm): 11 mg/kg/dose PO × 1. Repeat same dose 2 wk later.'),
          DoseLine('Hookworm or eosinophilic enterocolitis: 11 mg/kg/dose PO once daily × 3 '
              'days'),
          DoseLine('Moniliformis: 11 mg/kg/dose PO Q2 wk × 3 doses'),
          DoseLine('Max. dose (all indications): 1 g/dose'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in liver dysfunction. Do not use in combination with '
          'piperazine because of antagonism. May cause nausea, vomiting, anorexia, '
          'transient aspartate aminotransferase elevations, headaches, rash, and '
          'muscle weakness. Limited experience in children <2 yr. May increase '
          'theophylline levels. Drug may be mixed with milk or fruit juice and may '
          'be taken with food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1189',
  ),
  // PYRAZINAMIDE — PDF p. 381 (printed 1190)
  DrugEntryV3(
    name: 'PYRAZINAMIDE',
    brandNames: 'Pyrazinoic acid amide and generics',
    drugClass: 'Antituberculous agent',
    iconRow: '',
    formulations: [
      'Tabs: 500 mg',
      'Oral suspension: 100 mg/mL',
      'In combination with isoniazid and rifampin (Rifater):',
      'Tabs: 300 mg with 50 mg isoniazid and 120 mg rifampin; contains povidone '
          'and propylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Tuberculosis:',
        lines: [
          DoseLine('Use as part of a multidrug regimen for tuberculosis. See latest edition '
              'of the AAP Red Book for recommended treatment for tuberculosis.'),
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine(
            '<40 kg:',
            isHeading: true,
          ),
          DoseLine('Daily dose regimen: 30–40 mg/kg/24 hr PO once daily; max. dose: 2 g/24 hr'),
          DoseLine('Twice-weekly dose regimen: 50 mg/kg/dose PO 2× per week; max. dose: 2 '
              'g/dose'),
          DoseLine('≥40 kg: Use adult dosage below.'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine(
            'Daily dose regimen:',
            isHeading: true,
          ),
          DoseLine('40–55 kg: 1000 mg PO once daily'),
          DoseLine('56–75 kg: 1500 mg PO once daily'),
          DoseLine('76–90 kg: 2000 mg PO once daily'),
          DoseLine(
            'Twice-weekly dose regimen:',
            isHeading: true,
          ),
          DoseLine('40–55 kg: 2000 mg PO 2× per week'),
          DoseLine('56–75 kg: 3000 mg PO 2× per week'),
          DoseLine('76–90 kg: 4000 mg PO 2× per week'),
        ],
      ),
    ],
    remarks: [
      'See latest edition of the AAP Red Book for recommended treatment for '
          'tuberculosis. Contraindicated in severe hepatic damage and acute gout. '
          'The Centers for Disease Control and Prevention and the American Thoracic '
          'Society do not recommend the combination of pyrazinamide and rifampin for '
          'latent tuberculosis infections. Use with caution in patients with renal '
          'failure (dosage reduction has been recommended), gout, or diabetes '
          'mellitus. Monitor liver function tests (baseline and periodic) and serum '
          'uric acid.',
      'Hepatoxicity is most common dose-related side effect; doses ≤30 mg/kg/24 '
          'hr minimizes effect. Hyperuricemia, maculopapular rash, arthralgia, '
          'fever, acne, porphyria, dysuria, and photosensitivity may occur. Severe '
          'hepatic toxicity may occur with rifampin use. May decrease isoniazid '
          'levels.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1190',
  ),
  // PYRETHRINS WITH PIPERONYL BUTOXIDE — PDF p. 381–382 (printed 1190–1191)
  DrugEntryV3(
    name: 'PYRETHRINS WITH PIPERONYL BUTOXIDE',
    brandNames: 'A-200, Pronto Plus, RID, and many others',
    drugClass: 'Pediculicide',
    iconRow: '',
    formulations: [
      'All products are available over-the-counter without a prescription.',
      'Shampoo (RID, Pronto Plus, A-200): 0.33% pyrethrins and 4% piperonyl '
          'butoxide (60, 120, 240 mL); may contain alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Pediculosis (≥2 yr and adult):',
        lines: [
          DoseLine('Apply to dry hair or affected body area for 10 min, then wash thoroughly '
              'and comb with fine-tooth comb or nit-removing comb; repeat in 7–10 days.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in ragweed hypersensitivity; drug is derived from the '
          'chrysanthemum flowers. For topical use only. Avoid use in and around the '
          'eyes, mouth, nose, or vagina. Avoid repeat applications in <24 hr. Low '
          'ovicidal activity requires repeat treatment. Dead nits require mechanical '
          'removal. Wash bedding and clothing to eradicate infestation.',
      'Local irritation, including erythema, pruritus, urticaria, edema, and '
          'eczema, may occur.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1190–1191',
  ),
  // PYRIDOSTIGMINE BROMIDE — PDF p. 382 (printed 1191)
  DrugEntryV3(
    name: 'PYRIDOSTIGMINE BROMIDE',
    brandNames: 'Mestinon, Regonol, and generics',
    drugClass: 'Cholinergic agent',
    iconRow: '',
    formulations: [
      'Oral syrup (Mestinon and generics): 60 mg/5 mL (473 mL); contains 5% '
          'alcohol and sodium benzoate',
      'Tabs (Mestinon and generics): 30, 60 mg',
      'Sustained-release tab (Mestinon and generics): 180 mg; scored tablet',
      'Injection (Regonol): 5 mg/mL (2 mL); may contain 1% benzyl alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Myasthenia gravis:',
        lines: [
          DoseLine(
            'Neonate:',
            isHeading: true,
          ),
          DoseLine('PO: 1 mg/kg/dose Q4 hr; max. dose: 7 mg/kg/24 hr'),
          DoseLine('IM/IV: 0.05–0.15 mg/kg/dose Q4–6 hr; max. single IM/IV dose: 10 mg'),
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('PO: 7 mg/kg/24 hr in 5–6 divided doses'),
          DoseLine('IM/IV: 0.05–0.15 mg/kg/dose Q4–6 hr; max. single IM/IV dose: 10 mg'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('PO (immediate release): 60 mg TID; increase Q48 hr PRN. Usual effective '
              'dose: 60–1500 mg/24 hr'),
          DoseLine('PO (sustained release): 180–540 mg once daily–BID'),
          DoseLine('IM/IV (use when PO therapy is not practical): Give 1/30 of the usual PO'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in mechanical intestinal or urinary obstruction. Use with '
          'caution in patients with epilepsy, asthma, bradycardia, hyperthyroidism, '
          'arrhythmias, or peptic ulcer. May cause nausea, vomiting, diarrhea, rash, '
          'headache, and muscle cramps. Pyridostigmine is mainly excreted unchanged '
          'by the kidney. Therefore, lower doses titrated to effect in renal disease '
          'may be necessary.',
      'Changes in oral dosages may take several days to show results. Atropine '
          'is the antidote.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1191',
  ),
  // PYRIDOXINE — PDF p. 382–383 (printed 1191–1192)
  DrugEntryV3(
    name: 'PYRIDOXINE',
    brandNames: 'Vitamin B₆ and various names, including generics',
    drugClass: 'Vitamin, water soluble',
    iconRow: '',
    formulations: [
      'Tabs (HCl) [OTC]: 10, 25, 50, 100, 250, 500 mg',
      'Oral liquid [OTC]: 100 mg/2.5 mL (120 mL); contains sorbitol',
      'Oral solution (HCl): 1 mg/mL',
      'Injection (HCl): 100 mg/mL (1 mL); some products may contain aluminum and '
          '0.5% chlorobutanol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Deficiency, IM/IV/PO (PO preferred):',
        lines: [
          DoseLine('Child: 5–25 mg/24 hr × 3 wk, followed by 2.5–5 mg/24 hr as maintenance '
              'therapy (via multivitamin preparation)'),
          DoseLine('Adolescent and adult: 10–20 mg/24 hr × 3 wk, followed by 2–5 mg/24 hr as '
              'maintenance therapy (via multivitamin preparation)'),
        ],
      ),
      DoseSection(
        heading: 'Drug-induced neuritis (PO):',
        lines: [
          DoseLine(
            'Prophylaxis:',
            isHeading: true,
          ),
          DoseLine('Child: 1 mg/kg/24 hr or 10–50 mg/24 hr'),
          DoseLine('Adolescent and adult: 25–50 mg/24 hr'),
          DoseLine(
            'Treatment (optimal dose not established):',
            isHeading: true,
          ),
          DoseLine('Child: 50–200 mg/24 hr'),
          DoseLine('Adolescent and adult: 50–300 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Pyridoxine-dependent seizures:',
        lines: [
          DoseLine(
            'Neonate and infant:',
            isHeading: true,
          ),
          DoseLine('Initial: 50–100 mg/dose IM or rapid IV × 1'),
          DoseLine('Maintenance: 50–100 mg/24 hr PO'),
        ],
      ),
      DoseSection(
        heading: 'Amelioration of levetiracetam behavioral side effects (limited data):',
        lines: [
          DoseLine('Dosages of 7 mg/kg/24 hr (max. dose: 350 mg/24 hr) PO once daily and '
              '10–15 mg/kg/24 hr (max. dose: 200 mg/24 hr) PO once daily have been '
              'reported to provide benefit when initiated after experiencing '
              'levetiracetam behavioral side effect (e.g., aggression, agitation, '
              'personality changes, mood lability, and depression).'),
        ],
      ),
      DoseSection(
        heading: 'Recommended daily allowance: See Chapter 21.',
      ),
    ],
    remarks: [
      'Use caution with concurrent levodopa therapy. Chronic administration has '
          'been associated with sensory neuropathy. Nausea, headache, increased '
          'aspartate aminotransferase, decreased serum folic acid level, and '
          'allergic reaction may occur. May lower phenobarbital and phenytoin '
          'levels. See Chapter 20 for management of neonatal seizures.',
    ],
    pregnancyNote: 'Pregnancy category changes to “C” if dosage exceeds U.S. '
        'Recommended Daily Allowance.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1191–1192',
  ),
  // PYRIMETHAMINE — PDF p. 383–384 (printed 1192–1193)
  DrugEntryV3(
    name: 'PYRIMETHAMINE',
    brandNames: 'Daraprim and generics',
    drugClass: 'Antiparasitic agent',
    iconRow: '',
    formulations: [
      'Tabs: 25 mg; scored tablet (see remarks for outpatient prescription '
          'process)',
      'Oral suspension: 2 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Congenital toxoplasmosis (administer with sulfadiazine and '
            'leucovorin; see remarks):',
        lines: [
          DoseLine('Load: 2 mg/kg/24 hr PO ÷ Q12 hr × 2 days'),
          DoseLine('Maintenance: 1 mg/kg/24 hr PO once daily × 2–6 mo, then 1 mg/kg/24 hr 3× '
              'per wk to complete total 12 mo of therapy'),
        ],
      ),
      DoseSection(
        heading: 'Toxoplasmosis treatment (administer with sulfadiazine or '
            'trisulfapyrimidines, and leucovorin):',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('Load: 2 mg/kg/24 hr PO ÷ BID (max. dose: 100 mg/24 hr) with the following '
              'duration:'),
          DoseLine('Non–HIV exposed/positive: 2 days'),
          DoseLine('HIV exposed/positive: 3 days'),
          DoseLine(
            'Maintenance:',
            isHeading: true,
          ),
          DoseLine('Non–HIV exposed/positive: 1 mg/kg/24 hr PO once daily (max. dose: 25–50 '
              'mg/24 hr) × 6 mo, followed by 1 mg/kg/dose (max. dose: 25–50 mg/24 hr) 3 '
              'times per week to complete a total 12 mo of therapy'),
          DoseLine('HIV exposed/positive: 1 mg/kg/24 hr PO once daily (max. dose: 25 mg/24 '
              'hr) ≥6 wk'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Non–HIV exposed/positive: 50–75 mg/24 hr PO × 1–3 wk. Depending on '
              'tolerance and response, additional therapy at a 50% reduced dosage is '
              'continued × 4–5 wk.'),
          DoseLine('HIV exposed/positive: 200 mg PO × 1 followed by 50–75 mg/24 hr once daily '
              '× ≥6 wk'),
        ],
      ),
    ],
    remarks: [
      'Pyrimethamine is a folate antagonist. Supplementation with folinic acid '
          'leucovorin at 5–15 mg/24 hr is recommended. Contraindicated in '
          'megaloblastic anemia secondary to folate deficiency. Use with caution in '
          'glucose-6-phosphate dehydrogenase deficiency, malabsorption syndromes, '
          'alcoholism, pregnancy, and renal or hepatic impairment. Pyrimethamine can '
          'cause glossitis, bone marrow suppression, seizures, rash, and '
          'photosensitivity. For congenital toxoplasmosis, see Clin Infect Dis '
          '1994;18:38–72. Zidovudine and methotrexate may increase risk for bone '
          'marrow suppression. Aurothioglucose, trimethoprim, and sulfamethoxazole '
          'may increase risk for blood dyscrasias. Administer doses with meals. Most '
          'cases of acquired toxoplasmosis do not require specific antimicrobial '
          'therapy.',
      'Outpatient prescriptions may need to be processed through a specialty '
          'pharmacy program via the manufacturer; see '
          'https://www.daraprimdirect.com/home/hcp.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1192–1193',
  ),
];
