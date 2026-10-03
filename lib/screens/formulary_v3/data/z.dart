// =============================================================================
// output/z.dart — Drug Formulary 3.0, letter Z
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyZ` per file; entries in book order.
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

const List<DrugEntryV3> formularyZ = [
  // ZIDOVUDINE — PDF p. 470–472 (printed 1279–1281)
  DrugEntryV3(
    name: 'ZIDOVUDINE',
    brandNames: 'Retrovir, AZT, and generics',
    drugClass: 'Antiviral agent, nucleoside analogue reverse transcriptase inhibitor',
    iconRow: '',
    formulations: [
      'Caps: 100 mg',
      'Tabs: 300 mg',
      'Oral syrup: 50 mg/5 mL (240 mL); contains 0.2% sodium benzoate',
      'Injection: 10 mg/mL (20 mL); preservative-free solution (vial stoppers '
          'may contain latex)',
      'In combination with lamivudine (dideoxy-3\'-thiacytidine [3TC]) as '
          'generics:',
      'Tabs: 300 mg zidovudine + 150 mg lamivudine',
    ],
    doseSections: [
      DoseSection(
        heading: 'Human immunodeficiency virus (HIV):',
        lines: [
          DoseLine('See https://clinicalinfo.hiv.gov/en/guidelines'),
        ],
      ),
      DoseSection(
        heading: 'Prevention of HIV vertical transmission (low- and high-risk cases), '
            'prophylaxis, or presumptive treatment:',
        lines: [
          DoseLine(
            '14–34 weeks of pregnancy (maternal dosing):',
            isHeading: true,
          ),
          DoseLine('Until labor (see perinatal guidelines for currently recommended '
              'combination antiretroviral therapies, which may or may not include '
              'zidovudine): 600 mg/24 hr PO ÷ BID–TID'),
          DoseLine('During labor for maternal dosing in situations in which HIV viral load '
              '>1000 copies/mL, unknown HIV RNA status, known or suspected lack of '
              'adherence since last HIV RNA test, or a positive expedited '
              'antigen/antibody HIV test during labor (dosage based on maternal total '
              'body weight): 2 mg/kg/dose IV over 1 hr followed by 1 mg/kg/hr IV '
              'infusion over 2 hr. For scheduled cesarean delivery, initiate this '
              'regimen 3 hr before cesarean delivery.'),
          DoseLine(
            'Neonate and infant (initiate therapy within 6–12 hr of birth with or '
                'without other antiretrovirals; see current pediatric guidelines '
                '(https://clinicalinfo.hiv.gov/en/guidelines) for duration of use, as it '
                'will depend on the specific clinical situation:',
            isHeading: true,
          ),
        ],
        table: DoseTable(
          headers: ['Gestational Age (wk)', 'Oral (PO) Dosage', 'Intravenous (IV) Dosageᵃ'],
          rows: [
            DoseTableRow(['<30', 'Birth to 4 wk of age: 2 mg/kg/dose Q12 hr\n4 to 8–10 wk of age: 3 '
                'mg/kg/dose Q12 hr\n>8–10 wk of ageᵇ: 12 mg/kg/dose Q12 hr', 'Birth to 4 wk of age:\n1.5 mg/kg/dose Q12 hr\n4 to 8–10 wk of age:\n2.25 '
                'mg/kg/dose\nQ12 hr\n>8–10 wk of ageᵇ: 9 mg/kg/dose Q12 hr']),
            DoseTableRow(['30–34', 'Birth to 2 wk of age: 2 mg/kg/dose Q12 hr\n2 to 6–8 wk of age: 3 '
                'mg/kg/dose Q12 hr\n>6–8 wk of ageᵇ: 12 mg/kg/dose Q12 hr', 'Birth to 2 wk of age:\n1.5 mg/kg/dose Q12 hr\n2 to 6–8 wk of age: 2.25 '
                'mg/kg/dose Q12 hr\n>6–8 wk of ageᵇ: 9 mg/kg/dose Q12 hr']),
            DoseTableRow(['≥35', 'Birth to 4 wk of age: 4 mg/kg/dose Q12 hr\n>4 wk of ageᵇ: 12 mg/kg/dose '
                'Q12 hr', 'Birth to 4 wk of age:\n3 mg/kg/dose Q12 hr\n>4 wk of ageᵇ: 9 mg/kg/dose '
                'Q12 hr']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃConvert to PO route when possible.'),
          DoseLine('ᵇMake this dose increase only for infants with confirmed HIV infection.'),
        ],
      ),
      DoseSection(
        heading: 'HIV postexposure prophylaxis (all combination therapies to begin '
            'within 72 hr of exposure if possible, for a total of 28 days):',
        lines: [
          DoseLine('See https://clinicalinfo.hiv.gov/en/guidelines for the most recent '
              'preferred and alternative regimens. Zidovudine is dosed using HIV '
              'treatment doses and used in combination with additional antiretroviral '
              'agent(s).'),
        ],
      ),
    ],
    remarks: [
      'See https://clinicalinfo.hiv.gov/en/guidelines for additional remarks.',
      'Use with caution in patients with impaired renal or hepatic function. '
          'Dosage reduction is recommended in severe renal impairment and may be '
          'necessary in hepatic dysfunction. Drug penetrates well into the central '
          'nervous system. Most common side effects include: anemia, '
          'granulocytopenia, nausea, and headache (dosage reduction, erythropoietin, '
          'filgrastim/granulocyte colony-stimulating factor (G-CSF), or '
          'discontinuance may be required depending on event). Seizures, confusion, '
          'rash, myositis, myopathy (use >1 yr), hepatitis, and elevated liver '
          'enzymes have been reported. Macrocytosis is noted after 4 wk of therapy '
          'and can be used as an indicator of compliance. Lactic acidosis and severe '
          'hepatomegaly with steatosis, including fatal cases, have been reported. '
          'Neutropenia and severe anemia have been reported in advanced HIV disease. '
          'Use of injectable dosage form may cause allergic reactions in '
          'latex-sensitive individuals.',
      'Do not use in combination with stavudine because of poor antiretroviral '
          'effect. Effects of interacting drugs include: increased toxicity '
          '(acyclovir, trimethoprim-sulfamethoxazole); increased hematological '
          'toxicity (ganciclovir, interferon-α, marrow suppressive drugs); and drugs '
          'that affect glucuronidation (acetaminophen). Methadone, atovaquone, '
          'cimetidine, valproic acid, probenecid, and fluconazole may increase '
          'levels of zidovudine, whereas rifampin, rifabutin, and clarithromycin may '
          'decrease levels.',
      'Do not administer IM. IV form is incompatible with blood product '
          'infusions and should be infused over 1 hr (intermittent IV dosing). '
          'Despite manufacturer recommendations of administering oral doses 30 min '
          'prior to or 1 hr after meals, doses may be administered with food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1279–1281',
  ),
  // ZINC SALTS, SYSTEMIC — PDF p. 472 (printed 1281)
  DrugEntryV3(
    name: 'ZINC SALTS, SYSTEMIC',
    brandNames: 'Galzin, Orazinc, and generics',
    drugClass: 'Trace mineral',
    iconRow: '',
    formulations: [
      'Sulfate salt (23% elemental Zn):',
      'Tabs as sulfate (Orazinc and generics) [OTC]: 66, 110, 220 mg',
      'Caps as sulfate (Orazinc and generics) [OTC]: 220 mg',
      'Liquid as sulfate: 10 mg elemental Zn/mL',
      'Injection as sulfate; preparations may be preservative free:',
      '1 mg elemental Zn/mL (10 mL)',
      '3 mg elemental Zn/mL (10 mL)',
      '5 mg elemental Zn/mL (5 mL)',
      'Acetate salt (30% elemental Zn):',
      'Caps as acetate (Galzin): 25, 50 mg elemental Zn per capsule',
      'Liquid as acetate: 5 mg elemental Zn/mL, 10 mg elemental Zn/mL',
      'Chloride salt (48% elemental Zn):',
      'Injection as chloride: 1 mg elemental Zn/mL (10 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Zinc deficiency (see remarks):',
        lines: [
          DoseLine('Infant and child: 0.5–2 mg elemental Zn/kg/24 hr PO ÷ once daily–TID'),
          DoseLine('Adult: 25–50 mg elemental Zn/dose (100–220 mg Zn sulfate/dose) PO TID'),
        ],
      ),
      DoseSection(
        heading: 'Wilson disease:',
        lines: [
          DoseLine('Child ≥5–<10 yr: 75 mg elemental Zn/24 hr PO ÷ TID'),
          DoseLine('Child ≥10 yr and adolescent: 75–150 mg elemental Zn /24 hr PO ÷ TID'),
        ],
      ),
      DoseSection(
        heading: 'U.S. Recommended Daily Allowance (US RDA):',
        lines: [
          DoseLine('See Chapter 21.'),
          DoseLine('For supplementation in parenteral nutrition, see Chapter 21.'),
        ],
      ),
    ],
    remarks: [
      'Nausea, vomiting, gastrointestinal (GI) disturbances, leukopenia, and '
          'diaphoresis may occur. Gastric ulcers, hypotension, and tachycardia may '
          'occur at high doses. Copper deficiency (zinc sulfate and chloride) and '
          'gastric ulcer (zinc sulfate) have been reported with long-term use. '
          'Patients with excessive losses (burns) or impaired absorption require '
          'higher doses. Therapeutic levels: 70–130 mCg/dL.',
      'Parenteral products contain trace amounts of aluminum as a by-product; '
          'use with caution in renal impairment. May decrease the absorption of '
          'penicillamine, tetracycline, and fluoroquinolones (e.g., ciprofloxacin). '
          'Drugs that increase gastric pH (e.g., histamine₂ [H₂] antagonists and '
          'proton pump inhibitors) can reduce the absorption of zinc. Excessive zinc '
          'administration can cause copper deficiency.',
      'Approximately 20%–30% of oral dose is absorbed. Oral doses may be '
          'administered with food if GI upset occurs. Pregnancy category is A for '
          'zinc acetate and C for all other salt forms.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1281',
  ),
  // ZOLMITRIPTAN — PDF p. 473–474 (printed 1282–1283)
  DrugEntryV3(
    name: 'ZOLMITRIPTAN',
    brandNames: 'Zomig and generics previously available as Zomig ZMT',
    drugClass: 'Antimigraine agent, selective serotonin agonist',
    iconRow: '',
    formulations: [
      'Tabs:',
      'Zomig and generics: 2.5 mg (scored), 5 mg',
      'Oral disintegrating tabs (ODTs):',
      'Generics: 2.5, 5 mg; contains aspartame',
      'Nasal spray:',
      'Zomig and generics: 2.5 mg single unit nasal spray (6s), 5 mg single unit '
          'nasal spray (1s, 6s)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Treatment of acute migraines with or without aura:',
        lines: [
          DoseLine(
            'Nasal (safety for an average of >4 headaches in a 30-day period has not '
                'been established; see remarks):',
            isHeading: true,
          ),
          DoseLine('≥12 yr and adult: Start with 2.5 mg inhaled into a single nostril × 1. If '
              'needed in 2 hr, a second dose may be administered. Dose may be increased '
              'to a maximum single dose of 5 mg if needed. Max. daily dose: 10 mg/24 hr'),
          DoseLine('Patients receiving concurrent cimetidine: Limit maximum doses to 2.5 mg '
              'as the max. single dose and do not exceed 5 mg in any 24-hr period.'),
          DoseLine(
            'Oral (use not recommended in children; safety and efficacy in children '
                'have not been established with the oral route. One randomized '
                'placebo-controlled trial in 696 adolescents 12–17 yr old did not '
                'establish efficacy and had adverse events similar to those seen in adult '
                'trials):',
            isHeading: true,
          ),
          DoseLine(
            'Adult (safety for an average of >3 headaches in a 30-day period has not '
                'been established; see remarks):',
            isHeading: true,
          ),
          DoseLine('PO or ODT tabs: Start with 2.5 mg PO × 1. If needed in 2 hr, a second '
              'dose may be administered. Dose may be increased to a maximum single dose '
              'of 5 mg if needed. Max. daily dose: 10 mg/24 hr'),
          DoseLine('Patients receiving concurrent cimetidine: Limit maximum doses to 2.5 mg '
              'as the max. single dose and do not exceed 5 mg in any 24-hr period.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in ischemic bowel disease; ischemic coronary artery '
          'disease; uncontrolled hypertension; peripheral vascular disease; history '
          'of stroke or transient ischemic attack (TIA), arrhythmias, or hemiplegic '
          'or basilar migraine; significant cardiovascular disease; and coronary '
          'artery vasospasm.',
      'Do not administer with any ergot-containing medications, any other '
          '5-hydroxytriptamine₁ (5-HT₁) agonist (e.g., triptans), methylene blue, or '
          'within 2 wk of discontinuing a monoamine oxidase (MAO) inhibitor or '
          'linezolid. Cimetidine may increase the zolmitriptan levels; see dosage '
          'section for reduced maximum dosage. Patients with multiple cardiovascular '
          'risk factors and negative cardiovascular evaluation should have their '
          'first dose administered in a medically supervised facility.',
      'Use not recommended in moderate/severe hepatic impairment. Severe renal '
          'impairment (CrCl 5–25 mL/min) reduces zolmitriptan clearance by 25%.',
      'Common adverse reactions for all dosage forms, unless otherwise '
          'indicated, include nausea, taste alteration (nasal route), xerostomia, '
          'dizziness, hyperesthesia (nasal route), paresthesia, somnolence, '
          'sensation of hot and cold, throat pain, and asthenia (oral route). '
          'Hypertension, coronary artery spasm, myocardial infarction, cerebral '
          'hemorrhage, and headaches have been reported.',
      'For intranasal use, blow nose gently prior to dosing. Block opposite '
          'nostril while administering dose by breathing in gently.',
      'When using the ODT, place the whole tablet on the tongue, allow the '
          'tablet to dissolve, and swallow with saliva. Administration with liquids '
          'is optional. Do not break the ODT tablet.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1282–1283',
  ),
  // ZONISAMIDE — PDF p. 474 (printed 1283)
  DrugEntryV3(
    name: 'ZONISAMIDE',
    brandNames: 'Zonegran, Zonisade, and generics',
    drugClass: 'Anticonvulsant',
    iconRow: '',
    formulations: [
      'Caps:',
      'Zonegran: 25, 100 mg',
      'Generics: 25, 50, 100 mg',
      'Oral suspension:',
      'Zonisade: 20 mg/mL (150 mL); contains sodium benzoate',
      'Oral syrup: 10 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infant, child, and adolescent <16 yr:',
        lines: [
          DoseLine(
            'Adjunctive therapy for partial seizures (limited data):',
            isHeading: true,
          ),
          DoseLine('<5 yr: Start with 1–2 mg/kg/24 hr PO ÷ BID. Increase dosage by 0.5–1 '
              'mg/kg/24 hr Q2 wk to the usual dosage range of 5–8 mg/kg/24 hr PO ÷ BID.'),
          DoseLine('5–<16 yr: Start with 0.5–1 mg/kg/24 hr PO ÷ once daily–BID. Increase '
              'dosage by 0.5–1 mg/kg/24 hr ÷ BID Q2 wk to the usual dosage range of 5–8 '
              'mg/kg/24 hr PO ÷ once daily–BID. Suggested maximum dose: 12 mg/kg/24 hr '
              'or 500 mg/24 hr, whichever is less'),
          DoseLine('Infantile spasms (regimen that was effective in a small study from Japan; '
              'additional studies needed): Start with 2–4 mg/kg/24 hr PO ÷ BID. Then '
              'increase by 2–5 mg/kg/24 hr every 2–4 days until seizures disappear, up '
              'to a maximum of 20 mg/kg/24 hr.'),
        ],
      ),
      DoseSection(
        heading: 'Adolescent ≥16 yr–adult:',
        lines: [
          DoseLine('Adjunctive therapy for partial seizures: 100 mg PO once daily × 2 wk. '
              'Dose may be increased to 200 mg PO once daily × 2 wk. Additional dosage '
              'increments of 100 mg/24 hr can be made at 2-wk intervals to allow '
              'attainment of steady-state levels. Effective doses have ranged from 100 '
              'mg to 600 mg/24 hr ÷ once daily–BID (BID dosing may provide better '
              'efficacy). No additional benefit has been shown for doses >400 mg/24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Because zonisamide is a sulfonamide, it is contraindicated in patients '
          'allergic to sulfonamides (may result in Stevens-Johnson syndrome or toxic '
          'epidermal necrolysis). Common side effects of drowsiness (especially at '
          'higher doses), ataxia, anorexia, gastrointestinal discomfort, headache, '
          'rash, and pruritus usually occur early in therapy and can be minimized '
          'with slow dose titration. Children are at increased risk for hyperthermia '
          'and oligohydrosis, especially in warm or hot weather. Suicidal behavior '
          'or ideation, acute pancreatitis, urolithiasis, metabolic acidosis (more '
          'frequent and severe in younger patients), drug rash with eosinophilia and '
          'systemic symptoms (DRESS)/multiorgan hypersensitivity, rhabdomyolysis, '
          'metabolic acidosis, hyperammonemia/encephalopathy, acute myopia, '
          'glaucoma, and elevated creatinine phosphokinase have been reported.',
      'Although not fully delineated, therapeutic serum levels of 20–30 mg/L '
          'have been suggested as higher rates of adverse reactions have been seen '
          'at levels >30 mg/L.',
      'Zonisamide is a cytochrome P-450 (CYP) 3A4 substrate. Phenytoin, '
          'carbamazepine, and phenobarbital can decrease levels of zonisamide.',
      'Use with caution in renal or hepatic impairment; slower dose titration '
          'and more frequent monitoring are recommended. Do not use if glomerular '
          'filtration rate (GFR) is <50 mL/min. Avoid abrupt discontinuation or '
          'radical dose reductions. Swallow capsules whole and do not crush or chew.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1283',
  ),
];
