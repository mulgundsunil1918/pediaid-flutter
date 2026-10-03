// =============================================================================
// output/i.dart — Drug Formulary 3.0, letter I
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyI` per file; entries in book order.
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

const List<DrugEntryV3> formularyI = [
  // IBUPROFEN — PDF p. 223–225 (printed 1032–1034)
  DrugEntryV3(
    name: 'IBUPROFEN',
    brandNames: 'PO: Motrin, Advil, Children’s Advil, Children’s Motrin, Infant\'s '
        'Ibuprofen, Motrin Infants\' Drops, and generics\nIV: NeoProfen, '
        'Caldolor, and generics',
    drugClass: 'Nonsteroidal anti-inflammatory agent',
    iconRow: '',
    formulations: [
      'Oral suspension [OTC]: 100 mg/5 mL (120, 240, 473 mL); may contain '
          'propylene glycol and sodium benzoate',
      'Oral drops:',
      'Infants’ Ibuprofen and Motrin Infants’ Drops [OTC]: 40 mg/mL (15, 30 mL); '
          'may contain sodium benzoate and polysorbate 80; some preparations may be '
          'dye free',
      'Chewable tabs [OTC]: 100 mg; contains aspartame',
      'Tabs: 200 [OTC], 400, 600, 800 mg',
      'Capsules [OTC]: 200 mg',
      'Injection:',
      'NeoProfen and generic (lysine salt): 10 mg ibuprofen base/1 mL (2 mL); '
          'preservative free',
      'Caldolor:',
      '100 mg/mL (8 mL); contains 78 mg/mL arginine',
      'Ready to use: 4 mg/mL (200 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'PO:',
        lines: [
          DoseLine(
            'Infant and child (≥6 mo):',
            isHeading: true,
          ),
          DoseLine('Analgesic/antipyretic: 5–10 mg/kg/dose Q6–8 hr; max. dose: The lesser of '
              '40 mg/kg/24 hr or 2400 mg/24 hr'),
          DoseLine('JRA (6 mo–12 yr): 30–50 mg/kg/24 hr ÷ Q6 hr; max. dose: 800 mg/dose or '
              '2400 mg/24 hr'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Inflammatory disease: 400–800 mg/dose Q6–8 hr; max. dose: 800 mg/dose or '
              '3.2 g/24 hr'),
          DoseLine('Pain/fever/dysmenorrhea: 200–400 mg/dose Q4–6 hr PRN; max. dose: 3.2 g/24 '
              'hr'),
        ],
      ),
      DoseSection(
        heading: 'IV (Caldolor) analgesic and antipyretic:',
        lines: [
          DoseLine('Patient must be well hydrated to reduce the risk for adverse renal '
              'effects.'),
          DoseLine('3 mo–<6 mo: 10 mg/kg/dose (max. dose: 100 mg) as a single dose'),
          DoseLine('6 mo–<12 yr: 10 mg/kg/dose up to 400 mg/dose Q4–6 hr PRN; max. dose: The '
              'lesser of 40 mg/kg/24 hr or 2400 mg/24 hr'),
          DoseLine('12–17 yr: 400 mg/dose Q4–6 hr PRN; max. dose: The lesser of 40 mg/kg/24 '
              'hr or 2400 mg/24 hr'),
          DoseLine(
            '≥18 yr and adult:',
            isHeading: true,
          ),
          DoseLine('Analgesic (see remarks): 400–800 mg/dose Q6 hr PRN; max. dose: 3200 mg/24 '
              'hr'),
          DoseLine('Antipyretic (see remarks): 400 mg/dose Q4–6 hr or 100–200 mg/dose Q4 hr '
              'PRN; max. dose: 3200 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Closure of ductus arteriosus (NeoProfen and generics):',
        lines: [
          DoseLine('<32 wk of gestation and 0.5–1.5 kg (use birth weight to calculate all '
              'doses and infuse all doses over 15 min; see remarks): 10 mg/kg/dose IV × '
              '1, followed by two doses of 5 mg/kg/dose each, 24 and 48 hr after the '
              'initial dose. Hold second or third dose if urinary output is <0.6 '
              'mL/kg/hr; dosing should resume when laboratory studies indicate the '
              'return of normal renal function. If the ductus arteriosus fails to close '
              'or reopens, a second course of ibuprofen, the use of IV indomethacin, or '
              'surgery may be necessary.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated with active GI bleeding and ulcer disease. Use caution '
          'with aspirin hypersensitivity, hepatic/renal insufficiency, heart disease '
          '(risk for MI and stroke with prolonged use), or dehydration and in '
          'patients receiving anticoagulants. GI distress (lessened with milk), '
          'rashes, ocular problems, hypertension, granulocytopenia, and anemia may '
          'occur. Inhibits platelet aggregation. Consumption of more than three '
          'alcoholic beverages per day or use with corticosteroids or anticoagulants '
          'may increase risk for GI bleeding. Serious skin reactions (e.g., SJS, '
          'TEN) have been reported. False-positive test for urine cannabinoid and '
          'phencyclidine (PCP) screen may occur.',
      'May increase serum levels and effects of digoxin, methotrexate, and '
          'lithium. May decrease the effects of antihypertensives, aspirin '
          '(antiplatelet effects), furosemide, and thiazide diuretics.',
      'IV USE for analgesia/antipyretic: Hydrate patient well before use. Doses '
          'must be diluted to a concentration ≤4 mg/mL with NS, D₅W, or LR and '
          'infused over ≥30 min for adults and ≥10 min for children. Most common '
          'reported side effects in clinical trials include nausea, flatulence, '
          'vomiting, and headache.',
      'IV USE for PDA: Contraindicated in untreated infections, congenital heart '
          'diseases requiring a patent ductus arteriosus to facilitate satisfactory '
          'pulmonary and systemic blood flow, active intracranial or '
          'gastrointestinal bleeds, thrombocytopenia, coagulation defects, '
          'suspected/active NEC, and significant renal impairment. Use with caution '
          'in hyperbilirubinemia. Not indicated for IVH prophylaxis. Renal side '
          'effects are generally less frequent and severe when compared with IV '
          'indomethacin. NEC, GI perforation, and pulmonary hypertension have been '
          'reported. NeoProfen doses must be administered within 30 min of '
          'preparation and infused intravenously over 15 min.',
    ],
    pregnancyNote: 'Pregnancy category is “C” for prior to 30 wk gestation and “X” for '
        '30 wk and greater. Avoid use at >30 wk gestation due to increased '
        'risk for premature closure of the fetal ductus arteriosus. Limit '
        'dose and duration of use at 20–30 wk gestation for concerns of '
        'fetal renal dysfunction and oligohydramnios.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1032–1034',
  ),
  // ILOPROST — PDF p. 225 (printed 1034)
  DrugEntryV3(
    name: 'ILOPROST',
    brandNames: 'Ventavis, Aurlumyn, synthetic PGI₂',
    drugClass: 'Prostaglandin I₂, vasodilator',
    iconRow: '',
    formulations: [
      'Inhalation solution: 10 mCg/mL (1 mL), 20 mCg/mL (1 mL); contains ethanol '
          'and tromethamine; preservative free',
      'IV solution: 100 mCg/mL (1 mL); contains ethanol and tromethamine; '
          'preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Pulmonary arterial hypertension (limited data):',
        lines: [
          DoseLine('Intermittent inhalation via nebulization: Start at 2.5 mCg/dose (some '
              'recommend 1.25 mCg/dose for infant and small child). If tolerated, '
              'increase dose to 5 mCg/dose at intervals of 6 to 9 times daily (Q2–3 hr '
              'while awake; Q3–4 hr may be considered for patients with moderate/severe '
              'hepatic impairment). Avoid abrupt withdrawal or large dose reductions to '
              'prevent rebound pulmonary hypertension.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in bleeding disorders, respiratory diseases, and '
          'hypotension',
      'Headache, nausea, cough, flulike symptoms, and flushing are common side '
          'effects. Bronchospasm, hypotension, and AKI have been reported. May '
          'increase the effects/toxicity of anticoagulants and antiplatelet, '
          'antihypertensive, and vasodilating medications.',
      'Administer by nebulization, which may take 10–15 min. Avoid contact with '
          'skin or eyes and do not ingest by mouth. IV administration is currently '
          'indicated for frostbite in adults.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1034',
  ),
  // IMIPENEM AND CILASTATIN — PDF p. 225–226 (printed 1034–1035)
  DrugEntryV3(
    name: 'IMIPENEM AND CILASTATIN',
    brandNames: 'Primaxin IV and generics',
    drugClass: 'Antibiotic, carbapenem',
    iconRow: '',
    formulations: [
      'Injection: 250, 500 mg; each 1 mg drug contains 1 mg imipenem and 1 mg '
          'cilastatin',
      'Contains 3.2 mEq Na/g drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'Dosages based on imipenem component.',
      ),
      DoseSection(
        heading: 'Neonate (see remarks):',
        lines: [
          DoseLine('<7 days old: 50 mg/kg/24 hr IV ÷ Q12 hr'),
          DoseLine('≥7 days old: 75 mg/kg/24 hr IV ÷ Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Child (4 wk–3 mo):',
        lines: [
          DoseLine('100 mg/kg/24 hr IV ÷ Q6 hr'),
        ],
      ),
      DoseSection(
        heading: 'Child (>3 mo):',
        lines: [
          DoseLine('60–100 mg/kg/24 hr IV ÷ Q6 hr; max. dose: 4 g/24 hr'),
          DoseLine(
            'Cystic fibrosis:',
            isHeading: true,
          ),
          DoseLine('Pulmonary exacerbation: 100 mg/kg/24 hr IV ÷ Q6 hr; max. dose: 4 g/24 hr'),
          DoseLine('Non-tuberculosis mycobacterium: 30–40 mg/kg/24 hr IV ÷ Q12 hr; max. dose: '
              '2 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('0.5–1 g/dose IV Q6–8 hr; max. dose: 4 g/24 hr or 50 mg/kg/24 hr, '
              'whichever is less'),
        ],
      ),
    ],
    remarks: [
      'For IV use, give slowly over 30–60 min at a concentration ≤5 mg/mL to '
          'reduce risk for nausea (lowering the rate may reduce severity). Adverse '
          'effects: Thrombophlebitis, pruritus, urticaria, GI symptoms, seizures, '
          'dizziness, hypotension, elevated LFTs, blood dyscrasias, and penicillin '
          'allergy. Greater risk for seizures may occur with CNS infections, '
          'concomitant use with ganciclovir, higher doses, and renal impairment. CSF '
          'penetration is variable but best with inflamed meninges. Not recommended '
          'for CNS infections in neonates due to cilastatin accumulation and seizure '
          'risk.',
      'Do not administer with probenecid (increases imipenem/cilastatin levels) '
          'and ganciclovir (increased risk for seizures). May significantly reduce '
          'valproic acid levels.',
      'Adjust dose in renal insufficiency (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1034–1035',
  ),
  // IMIPRAMINE — PDF p. 226–227 (printed 1035–1036)
  DrugEntryV3(
    name: 'IMIPRAMINE',
    brandNames: 'Generics; previously available as Tofranil',
    drugClass: 'Antidepressant, tricyclic',
    iconRow: '',
    formulations: [
      'Tabs (HCl): 10, 25, 50 mg',
      'Caps (pamoate): 75, 100, 125, 150 mg; strengths are expressed as '
          'imipramine HCl equivalent',
    ],
    doseSections: [
      DoseSection(
        heading: 'Antidepressant (see remarks):',
        lines: [
          DoseLine(
            'Child (≥8 yr):',
            isHeading: true,
          ),
          DoseLine('Initial: 1.5 mg/kg/24 hr PO ÷ BID–TID; increase by 1 mg/kg/24 hr '
              'increments Q3–4 days to a max. dose of 5 mg/kg/24 hr'),
          DoseLine(
            'Adolescent:',
            isHeading: true,
          ),
          DoseLine('Initial: 25–50 mg/24 hr PO ÷ once daily–TID; max. dose: 200 mg/24 hr. '
              'Dosages exceeding 100 mg/24 hr are generally not necessary.'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Initial: 75–100 mg/24 hr PO ÷ TID'),
          DoseLine('Maintenance: 50–300 mg/24 hr PO QHS; max. dose: 300 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Enuresis (≥6 yr):',
        lines: [
          DoseLine('Initial: 10–25 mg PO QHS'),
          DoseLine('Increment if needed: 10–25 mg/dose at 1- to 2-wk intervals until max. '
              'dose for age or desired effect achieved. Continue × 2–3 mo, then taper '
              'slowly.'),
          DoseLine(
            'Max. dose:',
            isHeading: true,
          ),
          DoseLine('6–12 yr: The lesser of 2.5 mg/kg/24 hr or 50 mg/24 hr'),
          DoseLine('≥12 yr: 75 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Augment analgesia for chronic pain:',
        lines: [
          DoseLine('Initial: 0.2–0.4 mg/kg/dose PO QHS; increase 50% every 2–3 days PRN to a '
              'max. dose of 1–3 mg/kg/dose PO QHS'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in narrow-angle glaucoma and patients who used MAO '
          'inhibitors within 14 days. See Chapter 3 for management of toxic '
          'ingestion. Monitor for clinical worsening of depression and suicidal '
          'ideation/behavior following the initiation of therapy or after dose '
          'changes. Use with caution in renal or hepatic impairment. Side effects '
          'include sedation, urinary retention, constipation, dry mouth, dizziness, '
          'drowsiness, and arrhythmia. QHS dosing during first weeks of therapy will '
          'reduce sedation. Monitor ECG, BP, CBC at start of therapy and with dose '
          'changes. Tricyclics may cause mania. False-positive test for urine PCP '
          'screen may occur.',
      'Therapeutic reference range for depression (sum of imipramine and '
          'desipramine) = 150–250 ng/mL. Levels >1000 ng/mL are toxic; however, '
          'toxicity may occur at >300 ng/mL.',
      'Recommended serum sampling times at steady-state: Obtain trough level '
          'within 30 min prior to the next scheduled dose after 5–7 days of '
          'continuous therapy.',
      'Imipramine is a major substrate for cytochrome P-450 2C19 and 2D6. See '
          'the remarks in amitriptyline for pharmacogenomic dosing considerations. '
          'Carbamazepine may reduce imipramine levels, and cimetidine, fluoxetine, '
          'fluvoxamine, labetalol, and quinidine may increase imipramine levels.',
      'Onset of antidepressant effects: 1–3 wk. Do not discontinue abruptly in '
          'patients receiving long-term high-dose therapy.',
    ],
    pregnancyNote: 'Pregnancy category has not been officially assigned by the FDA, as '
        'congenital abnormalities have been reported in humans, with the '
        'causal relationship not being established.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1035–1036',
  ),
  // IMMUNE GLOBULIN — PDF p. 227–231 (printed 1036–1040)
  DrugEntryV3(
    name: 'IMMUNE GLOBULIN',
    brandNames: '',
    drugClass: 'Immune globulins',
    iconRow: '',
    formulations: [
      'IM preparations:',
      'GamaSTAN: 150–180 mg/mL (2, 10 mL); contains 0.16–0.26 M glycine; '
          'preservative free',
      'IV preparations in solution (preservative free):',
      'Alyglo: 10% (100 mg/mL) (50, 100, 200 mL); contains polysorbate 80, 15–26 '
          'mg/mL glycine, and ≤100 mCg/mL IgA; sucrose free',
      'Asceniv: 10% (100 mg/mL) (50 mL); contains polysorbate 80, 0.2–0.29 M '
          'glycine, and <200 mCg/mL IgA; sucrose free',
      'Bivigam: 10% (100 mg/mL) (50, 100 mL); contains polysorbate 80, 0.2–0.29 '
          'M glycine, and <200 mCg/mL IgA; sucrose free',
      'Flebogamma DIF:',
      '5% (50 mg/mL) (10, 50, 100, 200, 400 mL); contains 50 mg/mL sorbitol, ≤3 '
          'mg/mL polyethylene glycol, and <50 mCg/mL IgA; sucrose free',
      'Gamunex-C: 10% (100 mg/mL) (10, 25, 50, 100, 200, 400 mL); contains '
          '0.16–0.24 M glycine and ~46 mCg/mL IgA; sucrose free',
      'Gammagard liquid: 10% (100 mg/mL) (10, 25, 50, 100, 200, 300 mL); '
          'contains 0.25 M glycine and ~37 mCg/mL IgA; sucrose free',
      'Gammaked: 10% (100 mg/mL) (10, 25, 50, 100, 200 mL); contains 0.16–0.24 M '
          'glycine and ~46 mCg/mL IgA; sucrose free',
      'Gammaplex:',
      '5% (50 mg/mL) (100, 200, 400 mL); contains polysorbate 80, 50 mg/mL '
          'D-sorbitol, 6 mg/mL glycine, and <10 mCg/mL IgA; sucrose free',
      '10% (100 mg/mL) (50, 100, 200 mL); contains polysorbate 80, 2–3 mM/mL '
          'glycine, and <20 mCg/mL IgA; sucrose free',
      'Octagam:',
      '5% (50 mg/mL) (20, 50, 100, 200, 500 mL); contains ∼100 mg/mL maltose and '
          '≤0.2 mg/mL IgA; sucrose free',
      '10% (100 mg/mL) (20, 50, 100, 200, 300 mL); contains ~90 mg/mL maltose '
          'and ~106 mCg/mL IgA,; sucrose free',
      'Panzyga 10%: (100 mg/mL) (10, 25, 50, 100, 200, 300 mL); contains 15–19.5 '
          'mg/mL glycine and ~100 mCg/mL IgA; sucrose free',
      'Privigen 10% (100 mg/mL) (50, 100, 200, 400 mL); contains 210–290 mmol/L '
          'L-proline and <25 mCg/mL IgA; sucrose free',
      'IV preparations in powder for reconstitution (sucrose and preservative '
          'free):',
      'Gammagard S/D: 5, 10 g (when diluted at 5% or 50 mg/mL, contains <1 '
          'mCg/mL of IgA, 3 mg/mL albumin, 22.5 mg/mL glycine, 20 mg/mL glucose, 2 '
          'mg/mL polyethylene glycol, 1 mCg/mL tri-n-butyl phosphate, 1 mCg/mL '
          'octoxynol 9, and 100 mCg/mL polysorbate 80); may be diluted to 5% or 10%',
      'Subcutaneous (SC) preparations (sucrose and preservative free):',
      'Hizentra: 20% (200 mg/mL) (5, 10, 20, 50 mL); contains 210–290 mmol/L '
          'L-proline, 8–30 mg/L polysorbate 80, and ≤50 mCg/mL IgA',
      'Cutaquig: 16.9% (169 mg/mL) (6, 10, 12, 20, 24, 48 mL); contains 30 mEq/L '
          'sodium, polysorbate 80, and~0.206 mg/mL IgA',
      'Cuvitru: 20% (200 mg/mL) (5, 10, 20, 40, 50 mL); contains 0.25 M glycine, '
          '∼80 mCg/mL IgA, and polysorbate 80',
      'Xembify: 20% (200 mg/mL) (5, 10, 20, 50 mL); contains 0.16–0.26 M '
          'glycine, 10–40 mCg/mL polysorbate 80, and IgA',
    ],
    doseSections: [
      DoseSection(
        heading: 'IV preparations (see remarks):',
        lines: [
          DoseLine('Kawasaki disease (should be initiated within first 10 days of symptoms): '
              '2 g/kg × 1 dose over 8–12 hr infusion. If signs and symptoms persist, '
              'infliximab monotherapy as second line therapy has been recommended by a '
              'recent meta-analysis. If a second IVIG dose is used instead, consider '
              'using a different drug brand or lot number.'),
          DoseLine(
            'Immune thrombocytopenia (ITP) (see RHₒ[D] immune globulin IV for '
                'Rh-positive patients):',
            isHeading: true,
          ),
          DoseLine('Acute therapy: 400–1000 mg/kg/dose once daily for 2–5 days for a total '
              'cumulative dose 2000 mg/kg'),
          DoseLine('Maintenance therapy: 400–1000 mg/kg/dose Q3–6 wk based on clinical '
              'response'),
          DoseLine('Replacement therapy for antibody-deficient disorders: Start at 400–500 '
              'mg/kg/dose Q4 wk and adjust dose based on clinical response and to '
              'maintain a trough IgG level ≥500 mg/dL. For severe hypogammaglobulinemia '
              '(<100 mg/dL), patients may benefit with a loading dose of 400 mg/kg/dose '
              'once daily × 2, followed by 400–500 mg/kg/dose Q4 wk.'),
          DoseLine('Pediatric HIV with IgG <400 mg/dL: See Replacement therapy for '
              'antibody-deficient disorders above'),
          DoseLine('Bone marrow transplantation (may decrease risk for infection and death '
              'but not acute graft-versus-host disease): Start at 400–500 mg/kg/dose to '
              'maintain IgG levels ≥400 mg/dL, resulting in dosage intervals ranging '
              'from once weekly to Q3–4 wk'),
          DoseLine('Measles, postexposure prophylaxis for individuals with primary humoral '
              'immunodeficiency or without evidence of measles immunity (6–16 yr): 400 '
              'mg/kg/dose as soon as possible and within 6 days after exposure'),
        ],
      ),
      DoseSection(
        heading: 'General guidelines for administration (see package insert of specific '
            'products):',
        lines: [
          DoseLine('IV: Begin infusion at 0.01 mL/kg/min, double rate every 15–30 min, up to '
              'max. of 0.08 mL/kg/min. If adverse reactions occur, stop infusion until '
              'side effects subside and may restart at rate that was previously '
              'tolerated.'),
        ],
      ),
      DoseSection(
        heading: 'Subcutaneous (SC) preparations:',
        lines: [
          DoseLine(
            'Converting to SC route from previous IV dosage for patients receiving IV '
                'immune globulin (IVIG) infusions at regular intervals for at least 3 mo '
                '(≥2 yr):',
            isHeading: true,
          ),
          DoseLine(
            'Initial weekly dose (start 1 wk after last IV dose):',
            isHeading: true,
          ),
        ],
        table: DoseTable(
          headers: ['SC Product', 'Dose Calculation (mg)', 'Dose Calculation (mL)'],
          rows: [
            DoseTableRow(['Hizentra', 'Dose (g) = 1.37 × Previous IVIG dose in grams (g) ÷ number of weeks '
                'between IVIG doses', 'mL = multiply dose (g) by 5']),
            DoseTableRow(['Cutaquig', 'Dose (g) = 1.30 × Previous IVIG dose in grams (g) ÷ number of weeks '
                'between IVIG doses', 'mL = multiply dose (g) by 6']),
            DoseTableRow(['Cuvitru', 'Dose (g) = 1.30 × Previous IVIG dose in grams (g) ÷ number of weeks '
                'between IVIG doses', 'mL = multiply dose (g) by 5']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('Adjust dose over time by clinical response and serum IgG trough levels. '
              'Obtain a previous trough level from IVIG therapy prior to SC conversion '
              'and repeat trough level 2–3 mo after initiating the SC route. A goal '
              'trough with the SC route of ∼290 mg/dL higher than a trough with the IV '
              'route has been recommended. A Q2 wk dosing interval may be used after '
              'establishing the patient individualized weekly dosage by multiplying the '
              'weekly dosage by 2.'),
          DoseLine(
            'Measles, postexposure prophylaxis for high-risk patients:',
            isHeading: true,
          ),
          DoseLine('Hizentra: 0.2 g/kg/dose SC Q7 days × 2, or 0.4 g/kg/dose SC × 1'),
          DoseLine('SC administration: Injection sites include the abdomen, thigh, upper arm, '
              'and/or lateral hip. Doses may be administered into multiple sites (spaced '
              '≥2 inches apart) simultaneously (see following table).'),
        ],
        table: DoseTable(
          headers: ['SC Product', 'Max. Simultaneous Injection Sites', 'Max. Infusion Rate', 'Max. Infusion Volume'],
          rows: [
            DoseTableRow(['Hizentra', '8', 'First infusion: 15 mL/hr per infusion site for primary immunodeficiency '
                '(PI) or 20 mL/hr per infusion site for chronic inflammatory demyelinating '
                'polyneuropathy (CIDP)\nSubsequent infusions: 25 mL/hr per infusion site '
                'for PI or 50 mL/hr per infusion site for CIDP', 'First infusion: 15 mL per infusion site for PI or 20 mL per infusion site '
                'for CIDP\nSubsequent infusions:\n25 mL per infusion site for PI or 50 mL '
                'per infusion site for CIDP']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        table: DoseTable(
          headers: ['SC Product', 'Max. Simultaneous Injection Sites', 'Max. Infusion Rate', 'Max. Infusion Volume'],
          rows: [
            DoseTableRow(['Cutaquig', '6', 'Child 2–<18 yr:\nFirst 2 infusions: ≤15 mL/hr per infusion site\n'
                'Subsequent infusions:\nGradually increase as tolerated by 5–10 mL/hr\nper '
                'infusion site Q2–4 wk\nup to a maximum rate of\n25 mL/hr per infusion '
                'site\n18 yr and older:\nFirst 2 infusions: ≤20 mL/hr per infusion site\n'
                'Subsequent infusions:\nGradually increase as tolerated by 10 mL/hr per '
                'infusion site Q2–4 wk up\nto a maximum rate of 52\nmL/hr per infusion site', 'Child 2–6 yr:\nFirst 2 infusions: ≤10 mL per infusion site\nSubsequent '
                'infusions:\nGradually increase as tolerated by 5–10 mL per infusion site '
                'Q2–4 wk up to a maximum of 15.5 mL per infusion site\nChild >6–<17 yr:\n'
                'First 2 infusions: ≤15 mL per infusion site\nSubsequent infusions:\n'
                'Gradually increase as tolerated by 5–10 mL per infusion site Q2–4 wk up '
                'to a maximum of 29 mL per infusion site\n17 yr and older:\nFirst 2 '
                'infusions: ≤25 mL per infusion site\nSubsequent infusions:\nGradually '
                'increase as tolerated by 10 mL per infusion site Q2–4 wk up to a maximum '
                'of 40 mL per infusion site']),
            DoseTableRow(['Cuvitru', '4', 'First 2 infusions: 10–20 mL/hr per infusion site\nSubsequent infusions:\n'
                'Gradually increase as tolerated to 60 mL/hr per infusion site', 'First 2 infusions: <40 kg:\n≤20 mL per infusion site; ≥40 kg: ≤60 mL per '
                'infusion site\nSubsequent infusions (all weights): ≤60 mL per infusion '
                'site']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Intramuscular (IM) preparations:',
        lines: [
          DoseLine('Measles, postexposure prophylaxis for high-risk patients: 0.5 mL/kg/dose '
              '(max. dose: 15 mL) IM × 1 within 6 days of exposure'),
          DoseLine('IM administration: Administer in the anterolateral aspects of the upper '
              'thigh or deltoid muscle of the upper arm. Avoid gluteal region due to '
              'risk of injury to sciatic nerve. Consider splitting doses for multiple '
              'injection sites to address age-specific maximum IM injection volumes.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in patients with increased risk of thrombosis (e.g., '
          'hypercoagulable states, prolonged immobilization, indwelling catheters, '
          'estrogen use, thrombosis history, cardiovascular risks, and '
          'hyperviscosity) or hemolysis (e.g., non-O blood type, associated '
          'inflammatory conditions, and receiving high cumulative doses of immune '
          'globulins over several days).',
      'May cause flushing, chills, fever, headache, and hypotension. '
          'Hypersensitivity reaction may occur when IV form is administered rapidly. '
          'Maltose-containing products may cause an osmotic diuresis. May cause '
          'anaphylaxis in lgA-deficient patients due to varied amounts of lgA. Some '
          'products are lgA depleted; consult a pharmacist.',
      'To decrease risk of renal dysfunction, including acute renal failure, IV '
          'preparations containing sucrose should not be infused at a rate such that '
          'the amount of sucrose exceeds 3 mg/kg/min.',
      'SC route provides higher serum trough levels, lower rate of adverse '
          'reactions, and shorter administration time when compared with the IV '
          'route. Use of adjusted body weight [ABW = Ideal Body Weight + 0.5 (Actual '
          'Body Weight ∼ Ideal Body Weight)] for dosing in obese patients has been '
          'recommended.',
      'Use in multisystem inflammatory syndrome in children (MIS-C) associated '
          'with SARS-CoV-2 mimics the 2 g/kg IVIG dose used for Kawasaki disease in '
          'combination with glucocorticoids. Patients with cardiac impairment and/or '
          'concerns for fluid overload should reduce the IVIG infusion rate or '
          'adjusting the dose to 1 g/kg/24 hr × 2 doses.',
      'Delay immunizations after immune globulin administration (see latest AAP '
          'Red Book for details)',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1036–1040',
  ),
  // INDOMETHACIN — PDF p. 231–232 (printed 1040–1041)
  DrugEntryV3(
    name: 'INDOMETHACIN',
    brandNames: 'Indocin and generics',
    drugClass: 'Nonsteroidal anti-inflammatory agent',
    iconRow: '',
    formulations: [
      'Caps: 25, 50 mg',
      'Sustained-release caps: 75 mg',
      'Oral suspension: 25 mg/5 mL (237 mL); contains 1% alcohol',
      'Suppositories: 50 mg (30s)',
      'Injection: 1 mg; preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Anti-inflammatory/rheumatoid arthritis:',
        lines: [
          DoseLine(
            'Child (≥2 yr):',
            isHeading: true,
          ),
          DoseLine('Immediate release: Start at 1–2 mg/kg/24 hr PO ÷ TID–QID; max. dose: the '
              'lesser of 4 mg/kg/24 hr or 200 mg/24 hr'),
          DoseLine('Sustained-release caps (≥15 yr): Start with 75 mg PO once daily, may '
              'increase to 75 mg BID; max. dose: 150 mg/24 hr'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Immediate release: 50–150 mg/24 hr PO ÷ BID–QID; max. dose: 200 mg/24 hr'),
          DoseLine('Sustained-release caps: Start with 75 mg PO once daily, may increase to '
              '75 mg BID; max. dose: 150 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Closure of ductus arteriosus:',
        table: DoseTable(
          headers: ['', 'Dose (mg/kg/dose Q12–24 hr)ᵃ', '', ''],
          rows: [
            DoseTableRow(['Postnatal Age at Time of 1st Dose', '#1', '#2', '#3']),
            DoseTableRow(['<48 hr', '0.2', '0.1', '0.1']),
            DoseTableRow(['2–7 days', '0.2', '0.2', '0.2']),
            DoseTableRow(['>7 days', '0.2', '0.25', '0.25']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃDo not administer if urine output is <0.6 mL/kg/hr or anuric.'),
        ],
      ),
      DoseSection(
        heading: 'Infuse intravenously over 20–30 min:',
        lines: [
          DoseLine('For infants <1500 g, 0.1–0.2 mg/kg/dose IV Q24 hr may be given for an '
              'additional 3–5 days.'),
        ],
      ),
      DoseSection(
        heading: 'Intraventricular hemorrhage prophylaxis:',
        lines: [
          DoseLine('0.1 mg/kg/dose IV Q24 hr × 3 doses, initiated at 6–12 hr of age (give in '
              'consultation with a neonatologist)'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in active bleeding, coagulation defects, necrotizing '
          'enterocolitis, and renal insufficiency (urine output <0.6 mL/kg/hr). Use '
          'with caution in cardiac dysfunction, hypertension, heart disease (risk '
          'for MI and stroke with prolonged use), and renal or hepatic impairment. '
          'May cause (especially in neonates) decreased urine output, '
          'thrombocytopenia, decreased GI blood flow, and a reduction in the '
          'antihypertensive effects of β-blockers, hydralazine, and ACE inhibitors. '
          'Fatal hepatitis reported in JRA treatment. Pancreatitis and serious skin '
          'reactions (e.g., SJS, TEN) have been reported. Thrombotic events have '
          'been observed in adults receiving high doses or prolonged duration of '
          'therapy. Monitor renal and hepatic function before and during use. '
          'False-positive test for urine cannabinoid screen may occur.',
      'Reduction in cerebral blood flow associated with rapid IV infusion; '
          'infuse all IV doses over 20–30 min',
      'Sustained-release capsules are dosed once daily–BID.',
    ],
    pregnancyNote: 'Pregnancy category is “C” for prior to 30 wk gestation and “X” for '
        '30 wk and greater. Avoid use at >30 wk gestation due to increased '
        'risk for premature closure of the fetal ductus arteriosus. Limit '
        'dose and duration of use at 20–30 wk gestation for concerns of '
        'fetal renal dysfunction and oligohydramnios.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1040–1041',
  ),
  // INFLIXIMAB — PDF p. 232–234 (printed 1041–1043)
  DrugEntryV3(
    name: 'INFLIXIMAB',
    brandNames: 'Remicade, Remicade SC, Avsola, Infectra, Renflexis, Zymfentra, and '
        'generics',
    drugClass: 'Tumor necrosis factor (TNF) blocking agent',
    iconRow: '',
    formulations: [
      'All are chimeric products composed of human and murine components; abda, '
          'axxq, dyyb products are biosimilar products. Remicade, generic '
          'infliximab, dyyb, and abda products are produced in a murine cell line, '
          'and axxq is produced in a hamster cell line.',
      'Injection (all products contain polysorbate 80):',
      'Remicade and generics: 100 mg',
      'Avsola (infliximab-axxq): 100 mg',
      'Inflectra: (infliximab-dyyb): 100 mg',
      'Renflexis (infliximab-abda): 100 mg',
      'Injection (prefilled syringe with fixed ½-inch 29-gauge needle):',
      'Zymfentra (Infliximab-dyyb): 120 mg/mL (1, 2, 4, 6 syringes); contains '
          'polysorbate 80',
      'Auto-injector (prefilled pen with fixed ½-inch 27-gauge needle):',
      'Zymfentra (Infliximab-dyyb): 120 mg/mL (1, 2, 4, 6 pens); contains '
          'polysorbate 80',
    ],
    doseSections: [
      DoseSection(
        heading: 'Crohn disease and ulcerative colitis:',
        lines: [
          DoseLine('Check with specific disease state practice guidelines for specific '
              'disease severity and indication for use.'),
          DoseLine('Child (≥6 yr) and adolescent: Start at 5 mg/kg/dose IV at 0, 2, and 6 '
              'weeks, followed by 5 mg/kg/dose IV Q8 weeks. Dose adjustments may be '
              'necessary due to therapeutic drug monitoring (see remarks); patients with '
              'weight <30 kg, high BMI, high inflammatory burden, or low albumin may '
              'require higher doses (10 mg/kg/dose or maintenance dose dosage interval).'),
        ],
      ),
      DoseSection(
        heading: 'IVIG refractory Kawasaki disease (limited data):',
        lines: [
          DoseLine('Infant and child: 5-10 mg/kg/dose IV x 1.'),
        ],
      ),
      DoseSection(
        heading: 'Juvenile idiopathic arthritis (refractory to disease-modifying '
            'antirheumatic drugs; limited data):',
        lines: [
          DoseLine('Child (≥4 yr) and adolescent: Start at 5–10 mg/kg/dose IV at 0, 2, and 6 '
              'weeks, followed by 5–10 mg/kg/dose IV Q8 weeks. Lower dose of 3 '
              'mg/kg/dose has been reported to be efficacious but requires further '
              'investigation. A retrospective evaluation of 85 patients receiving higher '
              'doses of 10–20 mg/kg/dose appeared to be safe but still needs to be '
              'studied prospectively for efficacy with additional safety measures.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated with murine hypersensitivity, prior hypersensitivity '
          'reactions, and severe active infections [e.g., sepsis, opportunistic '
          'infections, tuberculosis (TB); test for TB prior/during therapy]. '
          'Moderate/severe heart failure patients (NYHA class III/IV) cannot receive '
          'doses >5 mg/kg. Use with caution in cardiac disorders, history of '
          'significant hematologic abnormalities, history of opportunistic '
          'infections, and when switching biological disease-modifying antirheumatic '
          'drugs (increases infection risk).',
      'Common side effects include rash, abdominal pain, nausea, headache, '
          'cough, pharyngitis, sinusitis, upper respiratory infection, and fatigue. '
          'Severe hepatic reactions, serious cerebrovascular events, skin cancers '
          '(e.g., melanoma and Merkel cell carcinoma), transient vision loss, '
          'seizures, and new/worsening of demyelinating disorders (e.g., multiple '
          'sclerosis, optic neuritis, Guillain-Barré syndrome) have been reported. '
          'Discontinue when hepatotoxicity [e.g., jaundice and/or marked increase in '
          'liver enzymes (≥5 times ULN)] or lupuslike syndrome develops during '
          'therapy.',
      'Avoid use with anakinra, abrocitinib, abatacept, tofacitinib, and other '
          'immunosuppressants, as it will further enhance immunosuppressive effects. '
          'May enhance adverse/toxic effects of live vaccines and diminish the '
          'effects of non-live vaccines (individuals vaccinated <14 days before or '
          'during therapy should be revaccinated at least 2–3 mo after therapy). '
          'Infants who were exposed to infliximab in utero should wait at least 6 mo '
          'after birth before receiving vaccines.',
      'Suggested trough serum concentration goals from the European Crohn’s and '
          'Colitis Organization and European Society of Paediatric Gastroenterology, '
          'Hepatology and Nutrition (ECCO-ESPGHAN):',
      'Crohn disease:',
      'Induction phase: Prior to second dose (≥25 mCg/mL) and prior to third '
          'dose (≥15 mCg/mL)',
      'Maintenance phase: Trough level ≥14 wk from start of therapy; ≥5 mCg/mL '
          '(some recommend ≥3 mCg/mL)',
      'Ulcerative colitis:',
      'Trough level ≥14 wk from start of therapy (during maintenance dosing): '
          '4–5 mCg/mL or 5–10 mCg/mL for severe steroid-refractory disease.',
      'Infuse all IV doses following the specific manufacturer instructions '
          '(over 3–4 hr initially, with the potential for faster rates in subsequent '
          'doses) with an inline, non-pyrogenic, low-protein-binding filter with a '
          'pore size 1.2 microns or less. For infusion-related reactions, '
          'temporarily discontinue or decrease infusion rate; antihistamines (H₁ ± '
          'H₂ antagonists), acetaminophen, and/or corticosteroids may also be used.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1041–1043',
  ),
  // INSULIN PREPARATIONS — PDF p. 234 (printed 1043)
  DrugEntryV3(
    name: 'INSULIN PREPARATIONS',
    brandNames: '',
    drugClass: 'Pancreatic hormone',
    iconRow: '',
    formulations: [
      'Many preparations, at concentrations of 100, 500 units/mL. See Chapter '
          '10, Table 10.3.',
      'Diluted concentrations of 1 unit/mL or 10 units/mL may be necessary for '
          'smaller doses in neonates and infants.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hyperkalemia:',
        lines: [
          DoseLine('See Resuscitation Medications Table in the front matter of the book'),
        ],
      ),
      DoseSection(
        heading: 'DKA:',
        lines: [
          DoseLine('See Chapter 10, Figure 10.1'),
        ],
      ),
    ],
    remarks: [
      'Accidental mix-ups between insulin products have been reported. Always '
          'check the insulin label before each use or injection.',
      'When using insulin drip with new IV tubing, before connecting tubing to '
          'the patient, fill the tubing with the insulin infusion solution, and wait '
          'for 30 min. Then flush the line and connect the IV line to the patient to '
          'start the infusion. This will ensure proper drug delivery. Adjust dose in '
          'renal failure (see Chapter 32). Use with caution and monitor closely in '
          'hepatic impairment.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1043',
  ),
  // IODIDE — PDF p. 234 (printed 1043)  [cross-reference]
  DrugEntryV3(
    name: 'IODIDE',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Potassium Iodide',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1043',
  ),
  // IODIXANOL — PDF p. 234–235 (printed 1043–1044)
  DrugEntryV3(
    name: 'IODIXANOL',
    brandNames: 'Visipaque and generics',
    drugClass: 'Radiopaque agent, contrast medium',
    iconRow: '',
    formulations: [
      'Injection: 270 mg/mL, 320 mg/mL (50, 100, 150, 200 mL); may contain EDTA '
          'and tromethamine; preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Consult with your local radiologist for specific dosing and '
            'administration recommendations.',
      ),
      DoseSection(
        heading: 'IV contrast for CT scans:',
        lines: [
          DoseLine('Use Visipaque 320 mg/mL. Check for contraindications; all patients should '
              'be encouraged to drink extra fluids for 8 hr after the exam as allowed.'),
          DoseLine('eGFR ≥60 mL/min/1.73 m²: 1–2 mL/kg/dose'),
          DoseLine('eGFR 30–60 mL/min/1.73 m²: Administer a reduced dose with IV fluids + '
              'acetylcysteine to reduce risk for nephropathy'),
          DoseLine('eGFR <30 mL/min/1.73 m²: Avoid use unless life-threatening situation in '
              'which benefits outweigh the risk'),
        ],
      ),
      DoseSection(
        heading: 'PO contrast for CT scans:',
        lines: [
          DoseLine('See Iohexol'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in children with prolonged fasting and the administration '
          'of a laxative before use. Avoid use via intrathecal route (serious '
          'life-threatening reactions may occur) and in patients with previous '
          'hypersensitivity reactions to contrast agents. Use with caution in '
          'asthma, hay fever, food allergy, congestive heart failure, severe liver '
          'or renal impairment, diabetic nephropathy, multiple myeloma, '
          'pheochromocytoma, hyperthyroidism, and sickle cell disease.',
      'Common side effects include general discomfort, sensations of warmth, and '
          'pain. Cardiac arrest, dysrhythmia, heart failure, shock, severe '
          'dermatologic reactions (e.g., SJS, TEN), sickle cell crisis, '
          'thromboembolic disorder, acute kidney injury, and hypersensitivity '
          'reactions have been reported.',
      'Children at higher risk for adverse events with contrast medium '
          'administration may include those having asthma, sensitivity to medication '
          'and/or allergens, congestive heart failure, serum creatinine >1.5 mg/dL, '
          'and those age <12 mo. Hypothyroidism or transient thyroid suppression '
          'following single or multiple exposures has been reported in children 0–3 '
          'yr old.',
      'Avoid use with metformin, as lactic acidosis and acute renal failure may '
          'occur. Postpone IV administration in patients who have recently received '
          'an oral cholecystographic contrast agent, as renal toxicity may occur.',
      'Visipaque 320 mg/mL has an osmolality of 290 mOsmol/kg versus Omnipaque '
          '350 mg/mL (884 mOsmol/kg) for a lower risk of contrast nephropathy. See '
          'product information for IV and intra-arterial administration guidelines.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1043–1044',
  ),
  // IOHEXOL — PDF p. 235–236 (printed 1044–1045)
  DrugEntryV3(
    name: 'IOHEXOL',
    brandNames: 'Iohexol: Omnipaque 140, Omnipaque 180, Omnipaque 240, Omnipaque '
        '300, Omnipaque 350, Omnipaque oral solution 9, Omnipaque oral '
        'solution 12, Oraltag\nIodixanol: see Visipaque',
    drugClass: 'Radiopaque agent, contrast medium',
    iconRow: '',
    formulations: [
      'Injection:',
      'Omnipaque 140: 302 mg iohexol equivalent to 140 mg iodine/mL (50 mL)',
      'Omnipaque 180: 388 mg iohexol equivalent to 180 mg iodine/mL (10 mL)',
      'Omnipaque 240: 518 mg iohexol equivalent to 240 mg iodine/mL (10, 20, 50, '
          '100, 150, 200 mL)',
      'Omnipaque 300: 647 mg iohexol equivalent to 300 mg iodine/mL (10, 30, 50, '
          '100, 125, 150, 500 mL)',
      'Omnipaque 350: 755 mg iohexol equivalent to 350 mg iodine/mL (50, 75, '
          '100, 125, 150, 200, 500 mL)',
      'Oral solution:',
      'Omnipaque, Oraltag: 9 mg iodine/mL (19 mg/mL iohexol equivalent; 500 mL)',
      'Omnipaque: 12 mg iodine/mL (26 mg iohexol equivalent; 500 mL)',
      'All preparations contain tromethamine and edetate calcium disodium.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Consult with your local radiologist for specific dosing and '
            'administration recommendations.',
      ),
      DoseSection(
        heading: 'Oral contrast for CT scans:',
        lines: [
          DoseLine('Use oral Omnipaque 9 mg iodine/mL solution. If oral solution not '
              'available, mix 13 mL of the Omnipaque 350 injection with 500 mL of '
              'noncarbonated beverage to make an Omnipaque 9 mg iodine/mL solution. '
              'Administer dose all at once or over a period of up to 45 min. The more '
              'contrast the patient consumes, the better the CT study.'),
          DoseLine('1–7 kg: 40–60 mL'),
          DoseLine('8–11 kg: 110–160 mL'),
          DoseLine('12–15 kg: 165–240 mL'),
          DoseLine('16–42 kg: 250–360 mL'),
          DoseLine('>42 kg: ≥480 mL'),
        ],
      ),
      DoseSection(
        heading: 'IV contrast for CT scans:',
        lines: [
          DoseLine('See Iodixanol'),
        ],
      ),
    ],
    remarks: [
      'Use in hysterosalpingography is contraindicated in pregnant females due '
          'to the potential risk to the fetus from an intrauterine procedure. Avoid '
          'use with history of severe cutaneous reactions to iohexol. Use with '
          'caution in dehydration, previous allergic reaction to a contrast medium, '
          'iodine sensitivity, asthma, hay fever, food allergy, congestive heart '
          'failure, severe liver or renal impairment, diabetic nephropathy, multiple '
          'myeloma, pheochromocytoma, hyperthyroidism, and sickle cell disease. '
          'Allergic reactions, arrhythmias, hypothyroidism, transient thyroid '
          'suppression, and nephrotoxicity have been reported. Use of the incorrect '
          'iodine concentration may result in life-threatening events, including '
          'seizures, cerebral hemorrhage, coma, paralysis, arachnoiditis, acute '
          'renal failure, cardiac arrest, rhabdomyolysis, hyperthermia, brain edema, '
          'and death.',
      'Children at higher risk for adverse events with contrast medium '
          'administration may include those having asthma, sensitivity to medication '
          'and/or allergens, congestive heart failure, serum creatinine >1.5 mg/dL, '
          'or those age <12 mo. Hypothyroidism or transient thyroid suppression '
          'following single or multiple exposures has been reported in children 0–3 '
          'yr old.',
      'Use NOT recommended with drugs that lower seizure threshold (e.g., '
          'phenothiazines), amiodarone (increased risk of cardiotoxicity), and '
          'metformin (lactic acidosis and acute renal failure).',
      'Many other uses exist; see package insert for additional information. '
          'Iohexol is particularly useful when barium sulfate is contraindicated in '
          'patients with suspected bowel perforation or those in whom aspiration of '
          'contrast medium is of concern. Oral dose is poorly absorbed from the '
          'normal GI tract (0.1%–0.5%); absorption increases with bowel perforation '
          'or bowel obstruction. Concentrations of 302–755 mg iohexol/mL have '
          'osmolalities from 1.1 to 3 times that of plasma (285 mOsm/kg) and CSF '
          '(301 mOsm/kg), and may be hypertonic.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1044–1045',
  ),
  // IPRATROPIUM BROMIDE ± ALBUTEROL — PDF p. 236–238 (printed 1045–1047)
  DrugEntryV3(
    name: 'IPRATROPIUM BROMIDE ± ALBUTEROL',
    brandNames: 'Atrovent HFA and generics\nIn combination with albuterol: Combivent '
        'Respimat and generics; previously available as DuoNeb',
    drugClass: 'Anticholinergic agent',
    iconRow: '',
    formulations: [
      'Aerosol oral inhaler (Atrovent HFA): 17 mCg/dose (200 actuations per '
          'canister, 12.9 g); contains alcohol',
      'Nebulized solution: 0.02% (500 mCg/2.5 mL) (25s, 30s, 60s); preservative '
          'free',
      'Nasal spray:',
      '0.03% (21 mCg per actuation, 30 mL provides 345 sprays)',
      '0.06% (42 mCg per actuation, 15 mL provides 165 sprays)',
      'In combination with albuterol:',
      'Nebulized solution (generic; previously available as DuoNeb): 0.5 mg '
          'ipratropium bromide and 2.5 mg albuterol in 3 mL (30s, 60s)',
      'Inhalation spray (Combivent Respimat): 20 mCg ipratropium and 100 mCg '
          'albuterol per actuation (120 actuations per canister, 4 g); contains '
          'benzalkonium chloride',
    ],
    doseSections: [
      DoseSection(
        heading: 'Ipratropium:',
        lines: [
          DoseLine(
            'Acute use in the ED or ICU for moderate/severe asthma exacerbations:',
            isHeading: true,
          ),
          DoseLine(
            'Nebulizer treatments:',
            isHeading: true,
          ),
          DoseLine('<12 yr: 250–500 mCg/dose Q20 min × 3, then Q2–4 hr PRN'),
          DoseLine('≥12 yr: 500 mCg/dose Q20 min × 3, then Q2–4 hr PRN'),
          DoseLine(
            'Inhaler:',
            isHeading: true,
          ),
          DoseLine('<12 yr: 4–8 puffs Q20 min PRN up to 3 hr'),
          DoseLine('≥12 yr: 8 puffs Q20 min PRN up to 3 hr'),
          DoseLine(
            'Nonacute use:',
            isHeading: true,
          ),
          DoseLine(
            'Inhaler:',
            isHeading: true,
          ),
          DoseLine('<12 yr: 1–2 puffs Q6 hr; max. dose: 12 puffs/24 hr'),
          DoseLine('≥12 yr: 2–3 puffs Q6 hr; max. dose: 12 puffs/24 hr'),
          DoseLine(
            'Nebulized treatments:',
            isHeading: true,
          ),
          DoseLine('Infant: 125–250 mCg/dose Q8 hr'),
          DoseLine('Child ≤12 yr: 250–500 mCg/dose Q6–8 hr'),
          DoseLine('>12 yr and adult: 250–500 mCg/dose Q6 hr'),
          DoseLine(
            'Nasal spray:',
            isHeading: true,
          ),
          DoseLine(
            '0.03% strength (21 mCg/spray):',
            isHeading: true,
          ),
          DoseLine('Allergic and nonallergic rhinitis (≥6 yr and adult): 2 sprays (42 mCg) '
              'per nostril BID–TID'),
          DoseLine(
            '0.06% strength (42 mCg/spray):',
            isHeading: true,
          ),
          DoseLine(
            'Rhinitis associated with common cold (use up to a total of 4 days; safety '
                'and efficacy have not been evaluated >4 days):',
            isHeading: true,
          ),
          DoseLine('2–<5 yr (limited data): 2 sprays (84 mCg) per nostril TID'),
          DoseLine('5–11 yr: 2 sprays (84 mCg) per nostril TID'),
          DoseLine('12 yr–adult: 2 sprays (84 mCg) per nostril TID–QID'),
          DoseLine(
            'Rhinitis associated with seasonal allergies:',
            isHeading: true,
          ),
          DoseLine('2–<5 yr (limited data): 1 spray (42 mCg) per nostril TID × 14 days'),
          DoseLine('≥5 yr–adult: 2 sprays (84 mCg) per nostril QID; use up to a total of 3 wk '
              '(safety and efficacy have not been evaluated for >3 wk)'),
        ],
      ),
      DoseSection(
        heading: 'Ipratropium in combination with albuterol:',
        lines: [
          DoseLine(
            'Acute use in the ED or ICU for severe asthma exacerbations:',
            isHeading: true,
          ),
          DoseLine(
            'Nebulizer treatments:',
            isHeading: true,
          ),
          DoseLine('<12 yr: 1.5 or 3 mL (0.25 mg ipratropium and 1.25 mg albuterol or 0.5 mg '
              'ipratropium and 2.5 mg albuterol) Q20 min × 3 then PRN for up to 3 hr'),
          DoseLine('≥12 yr: 3 mL (0.5 mg ipratropium and 2.5 mg albuterol) Q20 min × 3 then '
              'PRN for up to 3 hr'),
          DoseLine(
            'Inhalation spray (Combivent Respimat):',
            isHeading: true,
          ),
          DoseLine('<12 yr: 4–8 sprays Q20 min × 3 then PRN for up to 3 hr'),
          DoseLine('≥12 yr: 8 sprays Q20 min × 3 then PRN for up to 3 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in atropine hypersensitivity. Use with caution in '
          'narrow-angle glaucoma or bladder neck obstruction, though ipratropium has '
          'fewer anticholinergic systemic effects than atropine. May cause anxiety, '
          'dizziness, headache, GI discomfort, and cough with inhaler or nebulized '
          'use. Epistaxis, nasal congestion, and dry mouth/throat have been reported '
          'with the nasal spray. Reversible anisocoria may occur with unintentional '
          'aerosolization of drug to the eyes, particularly with mask nebulizers. '
          'Proven efficacy of nebulized solution in pediatrics is currently limited '
          'to reactive airway disease management in the emergency room and intensive '
          'care unit areas.',
      'Current aerosol inhaler product does not contain soy products. '
          'Combination ipratropium and albuterol products are currently approved for '
          'use only in adults and have not been formally studied in children. See '
          'Albuterol for additional remarks if using the combination product.',
      'Bronchodilation onset of action is 1–3 min, with peak effects within '
          '1.5–2 hr and duration of action of 4–6 hr.',
      'Shake inhaler well prior to use with spacer. Nebulized solution may be '
          'mixed with albuterol (or use the combination product).',
    ],
    pregnancyNote: 'Pregnancy category is “C” for Combivent Respimat. Breastfeeding '
        'safety extrapolated from safety of atropine.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1045–1047',
  ),
  // IRON DEXTRAN — PDF p. 238 (printed 1047)  [cross-reference]
  DrugEntryV3(
    name: 'IRON DEXTRAN',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Iron―Injectable Preparations',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1047',
  ),
  // IRON SUCROSE — PDF p. 238 (printed 1047)  [cross-reference]
  DrugEntryV3(
    name: 'IRON SUCROSE',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Iron―Injectable Preparations',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1047',
  ),
  // IRON―INJECTABLE PREPARATIONS — PDF p. 238–240 (printed 1047–1049)
  DrugEntryV3(
    name: 'IRON―INJECTABLE PREPARATIONS',
    brandNames: 'Ferric gluconate: Ferrlecit and generics\nIron dextran: INFeD\nIron '
        'sucrose: Venofer\nFerric carboxymaltose: Injectafer',
    drugClass: 'Parenteral iron',
    iconRow: '',
    formulations: [
      'Injection:',
      'Ferric gluconate (Ferrlecit and generics): 62.5 mg/mL (12.5 mg elemental '
          'Fe/mL) (5 mL); contains 9 mg/mL benzyl alcohol and 20% sucrose',
      'Iron dextran (INFeD): 50 mg/mL (50 mg elemental Fe/mL) (2 mL); products '
          'containing phenol 0.5% are only for IM administration; products '
          'containing sodium chloride 0.9% can be administered via the IM or IV '
          'route.',
      'Iron sucrose (Venofer): 20 mg/mL (20 mg elemental Fe/mL) (2.5, 5, 10 mL); '
          'contains 300 mg/mL sucrose; preservative free',
      'Ferric carboxymaltose (Injectafer): 50 mg/mL (50 mg elemental Fe/mL) (2, '
          '15, 20 mL); preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'FERRIC GLUCONATE (IV):',
      ),
      DoseSection(
        heading: 'Iron deficiency anemia in patients undergoing chronic hemodialysis '
            'who are receiving supplemental erythropoietin therapy (most require 8 '
            'doses at 8 sequential dialysis treatments to achieve a favorable '
            'response):',
        lines: [
          DoseLine('Child ≥6 yr: 1.5 mg/kg elemental Fe (0.12 mL/kg) IV; max. dose: 125 mg '
              'elemental Fe/dose. Dilute dose in 25 mL NS and infuse over 1 hr.'),
          DoseLine('Adult: 125 mg elemental Fe in 100 mL NS IV; infuse over 1 hr. Most '
              'require a minimum cumulative dose of 1 g elemental Fe administered over 8 '
              'sessions.'),
        ],
      ),
      DoseSection(
        heading: 'IRON DEXTRAN (IV OR IM):',
      ),
      DoseSection(
        heading: 'Iron deficiency anemia (≥4 mo, child, adolescent):',
        lines: [
          DoseLine('Test dose (IV over 5 min or IM; may initiate treatment dose 1 hr after '
              'test dose):'),
          DoseLine('<10 kg: 10 mg'),
          DoseLine('10–20 kg: 15 mg'),
          DoseLine('≥20 kg: 25 mg'),
          DoseLine('Total replacement dose of iron dextran (mL) = 0.0442 × lean body wt (kg) '
              '× (desired Hb [g/dL] ∼ measured Hb [g/dL]) + (0.26 × lean body wt [kg]). '
              'For patients weighing 5–15 kg, use actual body weight instead of lean '
              'body weight. Total replacement dose is divided into smaller daily doses '
              'if exceeds respective IV or IM daily max. doses (see below).'),
        ],
      ),
      DoseSection(
        heading: 'Acute blood loss:',
        lines: [
          DoseLine('Total replacement dose of iron dextran (mL) = 0.02 × blood loss (mL) × '
              'hematocrit expressed as decimal fraction. Assumes 1 mL of RBC = 1 mg '
              'elemental iron.'),
          DoseLine('If no reaction to test dose, give remainder of replacement dose ÷ over '
              '2–3 daily doses.'),
        ],
      ),
      DoseSection(
        heading: 'Max. daily IV dose:',
        lines: [
          DoseLine('100 mg'),
        ],
      ),
      DoseSection(
        heading: 'Max. daily IM dose:',
        lines: [
          DoseLine('<5 kg: 0.5 mL (25 mg)'),
          DoseLine('5–10 kg: 1 mL (50 mg)'),
          DoseLine('>10 kg: 2 mL (100 mg)'),
        ],
      ),
      DoseSection(
        heading: 'IM administration:',
        lines: [
          DoseLine('Use “Z-track” technique'),
        ],
      ),
      DoseSection(
        heading: 'IV administration:',
        lines: [
          DoseLine('Dilute in NS at a max. concentration of 50 mg/mL and infuse over 1–6 hr '
              'at a max. rate of 50 mg/min'),
        ],
      ),
      DoseSection(
        heading: 'IRON SUCROSE (IV):',
      ),
      DoseSection(
        heading: 'Test dose (optional): Infuse 25% of first day dose up to a max. of 25 '
            'mg undiluted over 30 min',
      ),
      DoseSection(
        heading: 'Iron deficiency anemia in patients with chronic kidney disease:',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('ESRD on hemodialysis: (limited data from 14 children): 1 mg/kg/dialysis '
              'was adequate for correcting ferritin levels, and 0.3 mg/kg/dialysis was '
              'successful in maintaining ferritin levels between 193 and 250 mCg/L. '
              'Doses were administered during the last hr of each dialysis and are '
              'recommended at a frequency of 3 times a week. A 10-mg test dose was '
              'administered.'),
          DoseLine('Nonrenal iron deficiency, refractory to PO therapy (limited data): '
              'Calculate total iron replacement dose (mg) = 0.6 × wt (kg) × (100 ∼ '
              '[measured Hb ÷ desired Hb × 100]). Replacement dose is administered by '
              'giving an initial dose of 5–7 mg/kg (max. dose: 100 mg/24 hr) followed by '
              'a maintenance dose of 5–7 mg/kg/dose (max. dose: 300 mg/24 hr) Q3–7 days '
              'until total iron replacement dose is achieved.'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Hemodialysis-dependent: 100 mg elemental Fe 1–3 times per wk during '
              'dialysis up to a total cumulative dose of 1000 mg. May continue to '
              'administer at lowest dose to maintain target Hb, Hct, and iron levels.'),
          DoseLine('Non–hemodialysis-dependent: 200 mg elemental Fe on 5 different days over '
              'a 2-wk period (total cumulative dose: 1000 mg)'),
        ],
      ),
      DoseSection(
        heading: 'IV administration:',
        lines: [
          DoseLine('May administer undiluted over 2–5 min. For an infusion, dilute each 100 '
              'mg with a max. of 100 mL NS and infuse over at least 15 min.'),
        ],
      ),
      DoseSection(
        heading: 'FERRIC CARBOXYMALTOSE (IV):',
      ),
      DoseSection(
        heading: 'Iron deficiency anemia:',
        lines: [
          DoseLine('Child (≥1 yr), adolescent, and adult weighing <50 kg: 15 mg/kg/dose (max. '
              'dose: 750 mg/dose) Q7 days x 2 doses'),
          DoseLine('Adult weighing ≥50 kg: Use two-dose regimen above or a single-dose '
              'regimen of 15 mg/kg/dose (max. dose: 1000 mg/dose) x 1 dose'),
        ],
      ),
      DoseSection(
        heading: 'IV administration:',
        lines: [
          DoseLine('May administer undiluted as a slow IV push at a rate of 100 mg/min '
              '(infuse over 15 min for doses of 1000 mg). For an infusion, dilute to a '
              'concentration of 2–4 mg/mL with NS and infuse over at least 15 min. Do '
              'not dilute to concentrations <2 mg/mL to assure stability.'),
        ],
      ),
    ],
    remarks: [
      'Oral therapy with iron salts is preferred; injectable routes are painful. '
          'Gluconate and sucrose salts may be better tolerated than iron dextran. '
          'Adverse effects include hypotension, GI disturbances, fever, rash, '
          'myalgia, arthralgias, cramps, and headaches. Hypersensitivity reactions '
          'have been reported for iron dextran and sucrose products; use of test '
          'dose prior to first therapeutic dose is recommended.',
      'IM administration is only possible with iron dextran salt product. Follow '
          'infusion recommendations for specific product. Monitor vital signs during '
          'IV infusion. TIBC levels may not be meaningful within 3 wk after dosing.',
      'Efficacy and safety of iron sucrose for maintenance therapy have been '
          'evaluated in children 2 yr and older with CKD and receiving '
          'erythropoietin therapy. Common side effects include headache, respiratory '
          'tract viral infection, peritonitis, vomiting, pyrexia, dizziness, and '
          'cough.',
    ],
    pregnancyNote: 'Pregnancy category is “B” for ferric gluconate and iron sucrose, '
        '“C” for iron dextran, and “?” for ferric carboxymaltose.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1047–1049',
  ),
  // IRON―ORAL PREPARATIONS — PDF p. 240–241 (printed 1049–1050)
  DrugEntryV3(
    name: 'IRON―ORAL PREPARATIONS',
    brandNames: 'Ferrous sulfate: Fer-In-Sol, Slow FE, Slow Iron, and many generics\n'
        'Ferrous gluconate: Ferate and generics\nFerrous fumarate: Ferretts, '
        'Ferrimin 150, and generics\nPolysaccharide-iron complex: EZFE 200, '
        'Poly-Iron 150, iFerex 150, NovaFerrum, NovaFerrum Pediatric Drops, '
        'and many other brands; previously available as Niferex',
    drugClass: 'Oral iron supplements',
    iconRow: '',
    formulations: [
      'Ferrous sulfate (20% elemental Fe):',
      'Drops and oral solution (Fer-In-Sol and generics; OTC): 75 mg (15 mg '
          'Fe)/1 mL (50 mL); may contain 0.2% alcohol and sodium bisulfite',
      'Oral elixir and liquid (OTC): 220 mg (44 mg Fe)/5 mL (473 mL); may '
          'contain 5% alcohol',
      'Tabs (OTC): 325 mg (65 mg Fe)',
      'Extended-release tabs (Slow FE, Slow Iron, and generics; OTC): 142 mg (45 '
          'mg Fe), 160 mg (50 mg Fe), 324 mg (65 mg Fe), and 325 mg (65 mg Fe)',
      'Ferrous gluconate (12% elemental Fe):',
      'Tabs (Ferate and generics; OTC): 240 mg (27 mg Fe), 324 mg (37.5 mg Fe)',
      'Ferrous fumarate (33% elemental Fe):',
      'Tabs (all OTC):',
      'Generics: 90 mg (29.5 mg Fe), 324 mg (106 mg Fe)',
      'Ferretts: 325 mg (106 mg Fe)',
      'Ferrimin 150: 456 mg (150 mg Fe)',
      'Polysaccharide-iron complex and ferrous bis-glycinate chelate (expressed '
          'in mg elemental Fe):',
      'Caps (OTC): 50 mg (NovaFerrum 50), 150 mg (Poly-Iron 150, iFerex 150, and '
          'others), 200 mg (EZFE 200); 150-mg strength may contain 50 mg vitamin C',
      'Oral liquid (NovaFerrum 125; OTC): 125 mg/5 mL (180 mL); contains sodium '
          'benzoate and 100 units cholecalciferol/5 mL',
      'Oral drops (NovaFerrum Pediatric Drops; OTC): 15 mg/mL (120 mL); contains '
          'sodium benzoate',
    ],
    doseSections: [
      DoseSection(
        heading: 'Iron deficiency anemia, treatment (see remarks):',
        lines: [
          DoseLine('Premature infant: 2–4 mg elemental Fe/kg/24 hr PO ÷ once daily–BID; max. '
              'dose: 15 mg elemental Fe/24 hr'),
          DoseLine('Child: 3–6 mg elemental Fe/kg/24 hr PO ÷ BID–TID'),
          DoseLine('Adult: 60–100 mg elemental Fe PO BID up to 60 mg elemental Fe QID'),
        ],
      ),
      DoseSection(
        heading: 'Prophylaxis:',
        lines: [
          DoseLine('Child: Give dose below PO ÷ once daily–TID'),
          DoseLine('Premature infant: 2 mg elemental Fe/kg/24 hr; max. dose: 15 mg elemental '
              'Fe/24 hr'),
          DoseLine('Full-term infant: 1–2 mg elemental Fe/kg/24 hr; max. dose: 15 mg '
              'elemental Fe/24 hr'),
          DoseLine('Child 2–12 yr: 2 mg elemental Fe/kg/24 hr; max. dose: 30 mg elemental '
              'Fe/24 hr'),
          DoseLine('Adolescent and adult: 30–60 mg elemental Fe/24 hr PO once daily'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in hemolytic anemia and hemochromatosis. Avoid use in GI '
          'tract inflammation. May produce constipation, dark stools (false-positive '
          'guaiac is controversial), nausea, and epigastric pain. Iron and '
          'tetracycline inhibit each other’s absorption. Antacids may decrease iron '
          'absorption. Alternating-day dosing, compared to daily dosing, may provide '
          'better iron absorption for those experiencing GI side effects.',
      'Iron preparations are variably absorbed. Less GI irritation when given '
          'with or after meals. Vitamin C, 200 mg per 30 mg iron, may enhance '
          'absorption. Liquid iron preparations may stain teeth. Give with dropper '
          'or drink through straw.',
    ],
    pregnancyNote: 'Pregnancy category is “A” for ferrous sulfate and is unknown for '
        'the other salt forms.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1049–1050',
  ),
  // ISAVUCONAZONIUM SULFATE — PDF p. 241–242 (printed 1050–1051)
  DrugEntryV3(
    name: 'ISAVUCONAZONIUM SULFATE',
    brandNames: 'Cresemba, isavuconazole prodrug',
    drugClass: 'Antifungal, triazole',
    iconRow: '',
    formulations: [
      'Injection: 372 mg (200 mg isavuconazole) (contains 96 mg mannitol and '
          'sulfuric acid for pH adjustment); preservative free',
      'Capsules: 74.5 mg (40 mg isavuconazole), 186 mg (100 mg isavuconazole); '
          'contains disodium EDTA',
    ],
    doseSections: [
      DoseSection(
        heading: 'Dosage based on isavuconazonium sulfate (prodrug):',
      ),
      DoseSection(
        heading: 'Invasive aspergillosis or mucormycosis:',
      ),
      DoseSection(
        heading: 'IV:',
        table: DoseTable(
          headers: ['Age (yr)', 'Loading Dose Administered IV Q8 hr x 6 Doses', 'Maintenance Dose Administered IV Q24 hr, Initiated 12–24 hr After Last '
                'Loading dose', 'Max. IV Dose (mg/dose)'],
          rows: [
            DoseTableRow(['1–<3', '15 mg/kg', '15 mg/kg', '372 mg']),
            DoseTableRow(['≥3–18', '10 mg/kg', '10 mg/kg', '372 mg']),
            DoseTableRow(['Adult', '372 mg', '372 mg', '372 mg']),
          ],
        ),
      ),
      DoseSection(
        heading: 'PO (see remarks):',
        table: DoseTable(
          headers: ['Age (yr)', 'Weight (kg)', 'Loading Dose Administered PO Q8 hr x 6 Doses', 'Maintenance Dose Administered PO Q24 hr, Initiated 12–24 hr After Last '
                'Loading Dose'],
          rows: [
            DoseTableRow(['≥6–<18', '16–<18', '149 mg', '149 mg']),
            DoseTableRow(['', '18–<25', '223.5 mg', '223.5 mg']),
            DoseTableRow(['', '25–<32', '298 mg', '298 mg']),
            DoseTableRow(['', '≥32', '372 mg', '372 mg']),
            DoseTableRow(['Adult', '', '372 mg', '372 mg']),
          ],
        ),
      ),
    ],
    remarks: [
      'Isavuconazonium is a prodrug that is converted to its active form, '
          'isavuconazole, by blood and intestinal esterases. Use is contraindicated '
          'with concurrent use of strong cytochrome P-450 3A4 inhibitors or inducers '
          '(e.g, ketoconazole and rifampin, respectively) and familial short Q–T '
          'syndrome. Common side effects include hypokalemia, peripheral edema, '
          'headache, cough, dyspnea, GI disturbances, and backache. Cholestasis, '
          'increased LFTs, hypersensitivity reactions (including anaphylaxis), '
          'infusion reactions (hypotension, chills, dyspnea, dizziness, and '
          'paresthesia), respiratory failure, and renal failure have been reported.',
      'For Child-Pugh class C hepatic impairment, use when benefits outweigh '
          'risks due to the absence of clinical data. Isavuconazole is a major '
          'substrate for CYP3A4 and a moderate inhibitor for CYP3A4, organic cation '
          'transporters 1 and 2 (OCT1, OCT2), and P-glycoprotein/ABCB1 transporter. '
          'Always check for interactions for the risk of potential toxicities and '
          'use recommendations when used with other medications with similar CYP '
          'substrate and drug transporter characteristics.',
      'Monitor basic metabolic panel and LFTs at baseline and periodically '
          'throughout therapy. Efficacy and safety for invasive aspergillosis have '
          'been established for children >1 yr old with the IV dosage form and for '
          'children >6 yr old and weighing >16 kg with the oral capsule dosage form.',
      'Administer IV infusions over a minimum of 1 hr with an in-line filter '
          '(0.2–1.2 micron) and flush the line with D5W or NS before and after each '
          'dose. Oral capsules may be administered with or without food. Those who '
          'are unable to swallow capsules may mix the contents of the capsule with '
          'an acidic beverage or soft food (e.g., yogurt). NG tube administration is '
          'facilitated by mixing 5 mL of sterile water for injection to a 372-mg '
          'vial of the IV dosage form to make a 74.4 mg isavuconazonium/1 mL '
          'solution. Measure out the age/weight appropriate dose and administer '
          'within 1 hr after reconstitution. Administer three 5-mL water rinses to '
          'the NG tube after each dose to facilitate drug delivery.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1050–1051',
  ),
  // ISONIAZID — PDF p. 242–243 (printed 1051–1052)
  DrugEntryV3(
    name: 'ISONIAZID',
    brandNames: 'Generics, INH; previously available as Nydrazid and Laniazid',
    drugClass: 'Antituberculous agent',
    iconRow: '',
    formulations: [
      'Tabs: 100, 300 mg',
      'Syrup: 50 mg/5 mL (473 mL); contains parabens',
      'Injection: 100 mg/mL (10 mL); contains 0.25% chlorobutanol',
    ],
    doseSections: [
      DoseSection(
        heading: 'See most recent edition of the AAP Red Book for details and length of '
            'therapy.',
      ),
      DoseSection(
        heading: 'TB treatment (other dosing regimens exist; see remarks):',
        lines: [
          DoseLine(
            'Infant and child:',
            isHeading: true,
          ),
          DoseLine('10–15 mg/kg (max. dose: 300 mg) PO once daily or 20–30 mg/kg (max. dose: '
              '900 mg) per dose three times weekly with rifampin for uncomplicated '
              'pulmonary tuberculosis in compliant patients. Additional drugs are '
              'necessary in complicated disease.'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('5 mg/kg (max. dose: 300 mg) PO once daily or 15 mg/kg (max. dose: 900 mg) '
              'per dose three times weekly with rifampin. Additional drugs are necessary '
              'in complicated disease.'),
        ],
      ),
      DoseSection(
        heading: 'For INH-resistant TB:',
        lines: [
          DoseLine('Discuss with health department or consult ID specialist'),
        ],
      ),
    ],
    remarks: [
      'Should not be used alone for treatment. Contraindicated in acute liver '
          'disease and previous isoniazid-associated hepatitis. Peripheral '
          'neuropathy, optic neuritis, seizures, encephalopathy, psychosis, and '
          'hepatic side effects may occur with higher doses, especially in '
          'combination with rifampin. Severe liver injury has been reported in '
          'children and adults treated for latent TB. Follow LFTs monthly. '
          'Pancreatitis, toxic epidermal necrolysis, and DRESS have been reported. '
          'May cause false-positive urine glucose test.',
      'Supplemental pyridoxine (1–2 mg/kg/24 hr) is recommended for prevention '
          'of neurologic side effects.',
      'Inhibits cytochrome P-450 (CYP) 1A2, 2C9, 2C19, and 3A3/3A4 microsomal '
          'enzymes; decrease dose of carbamazepine, diazepam, phenytoin, and '
          'prednisone. Prednisone may decrease isoniazid’s effects. Also a substrate '
          'and inducer of CYP2E1 and may potentiate acetaminophen hepatotoxicity. '
          'Avoid daily alcohol use to reduce risk for isoniazid-induced hepatitis.',
      'May be given IM (same as oral doses) when oral therapy is not possible. '
          'Administer oral doses 1 hr prior to and 2 hr after meals. Aluminum salts '
          'may decrease absorption. Adjust dose in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1051–1052',
  ),
  // ISOPROTERENOL — PDF p. 243 (printed 1052)
  DrugEntryV3(
    name: 'ISOPROTERENOL',
    brandNames: 'Generics; previously available as Isuprel',
    drugClass: 'Adrenergic agonist',
    iconRow: '',
    formulations: [
      'Injection: 0.2 mg/mL (1, 5 mL); preparations may be preservative free or '
          'contain disodium EDTA',
    ],
    doseSections: [
      DoseSection(
        heading: 'NOTE: The dosage units for adults are in mCg/min, compared to '
            'mCg/kg/min for children.',
      ),
      DoseSection(
        heading: 'IV infusion:',
        lines: [
          DoseLine('Neonate–child: 0.05–2 mCg/kg/min; start at minimum dose and increase '
              'every 5–10 min by 0.1 mCg/kg/min until desired effect or onset of '
              'toxicity; max. dose: 2 mCg/kg/min'),
          DoseLine('Adult: 2–20 mCg/min; titrate to desired effect'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in diabetes, hyperthyroidism, renal disease, CHF, '
          'ischemia, or aortic stenosis. May cause flushing, ventricular '
          'arrhythmias, profound hypotension, anxiety, and myocardial ischemia. '
          'Monitor heart rate, respiratory rate, and blood pressure. Not for '
          'treatment of asystole or for use in cardiac arrests unless bradycardia is '
          'due to heart block.',
      'Continuous infusion for bronchodilation must be gradually tapered over a '
          '24–48 hr period to prevent rebound bronchospasm. Tolerance may occur with '
          'prolonged use. Clinical deterioration, myocardial necrosis, congestive '
          'heart failure, and death have been reported with continuous infusion use '
          'in refractory asthmatic children.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1052',
  ),
  // ISOTRETINOIN — PDF p. 244 (printed 1053)
  DrugEntryV3(
    name: 'ISOTRETINOIN',
    brandNames: 'Absorica, Absorica LD, Accutane, Amnesteem, Claravis, Zenatane, and '
        'generics',
    drugClass: 'Retinoic acid, vitamin A derivative',
    iconRow: '',
    formulations: [
      'Caps, standard formulation (all products contain soybean oil):',
      'Absorica: 10, 20, 25, 30, 35, 40 mg',
      'Amnesteem: 10, 20, 40 mg; contains EDTA',
      'Accutane, Claravis, Zenatane: 10, 20, 30, 40 mg; may contain EDTA',
      'Generics: 10, 20, 25, 30, 35, 40 mg',
      'Caps, micronized formulation (not substitutable with standard formulation '
          'due to different bioavailability):',
      'Absorica LD: 8, 16, 24, 32 mg; contains soybean oil and polysorbate 80',
    ],
    doseSections: [
      DoseSection(
        heading: 'Cystic acne/severe recalcitrant nodular acne (see remarks):',
        lines: [
          DoseLine(
            'Child ≥12 yr and adult:',
            isHeading: true,
          ),
          DoseLine('Standard formulation: 0.5–2 mg/kg/24 hr PO ÷ BID × 15–20 wk or until the '
              'total cyst count decreases by 70%, whichever comes first. Dosages as low '
              'as 0.05 mg/kg/24 hr have been reported to be beneficial.'),
          DoseLine('Micronized formulation (Absorica LD): 0.4–0.8 mg/kg/24 hr PO ÷ BID × '
              '15–20 wk or until the total cyst count decreases by 70%, whichever comes '
              'first. Dosages as high as 1.6 mg/kg/24 hr ÷ BID have been used for severe '
              'cases in adults.'),
        ],
      ),
    ],
    remarks: [
      'Micronized (Absorica LD) and standard formulations are not bioequivalent '
          'and are NOT substitutable.',
      'Contraindicated during pregnancy; known teratogen. Use with caution in '
          'females during childbearing years. May cause conjunctivitis, xerosis, '
          'pruritus, photosensitivity reactions (avoid exposure to sunlight and use '
          'sunscreen), epistaxis, anemia, hyperlipidemia, pseudotumor cerebri '
          '(especially in combination with tetracyclines; avoid this combination), '
          'cheilitis, bone pain, muscle aches, skeletal changes, lethargy, nausea, '
          'vomiting, elevated ESR, mental depression, aggressive/violent behavior, '
          'and psychosis. Serious skin reactions (e.g., Stevens-Johnson syndrome, '
          'TEN) have been reported.',
      'Elevation of liver enzymes may occur during treatment; a dosage reduction '
          'or continued treatment may result in normalization. Discontinue use if '
          'liver enzymes do not normalize or if hepatitis is suspected.',
      'To avoid additive toxic effects, do not take vitamin A concomitantly. '
          'Increases clearance of carbamazepine. Hormonal birth control (oral, '
          'injectable, and implantable) failures have been reported with concurrent '
          'use. Monitor CBC, ESR, triglycerides, and LFTs.',
      'Prescribers, site pharmacists, patients, and wholesalers must register '
          'with the iPLEDGE system (a risk minimization program) at '
          'www.ipledgeprogram.com or 1-866-495-0654 before doses are dispensed. '
          'Prescriptions may not be written for more than a 1-mo supply.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1053',
  ),
  // ISRADIPINE — PDF p. 244–245 (printed 1053–1054)
  DrugEntryV3(
    name: 'ISRADIPINE',
    brandNames: 'Generics; previously available as DynaCirc',
    drugClass: 'Calcium channel blocker, antihypertensive',
    iconRow: '',
    formulations: [
      'Capsules: 2.5, 5 mg',
      'Oral suspension: 1 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hypertension:',
        lines: [
          DoseLine('Child (limited data): Start at 0.05–0.1 mg/kg/dose PO BID–TID (start at '
              '0.05 mg/kg/dose for child <2 yr old). Dose may be increased at 2–4 wk '
              'intervals as needed up to a maximum of 0.6 mg/kg/24 hr not to exceed 10 '
              'mg/24 hr. Usual daily dose of 0.3–0.4 mg/kg/24 hr has been reported.'),
          DoseLine('Adult: Start at 2.5 mg PO BID. After 2–4 weeks, the dose may be increased '
              'to 5 mg PO BID as most patients do not show improvement and experience '
              'more adverse reactions with doses greater than 10 mg/24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated with calcium channel antagonist hypersensitivity. Use '
          'with caution in renal and hepatic impairment. Increased and decreased '
          'oral absorption have been reported in adults with mild and severe renal '
          'impairment, respectively. Increases in bioavailability have been reported '
          'in hepatic impairment. Common side effects include peripheral edema, '
          'headache, fatigue, flushing, and dizziness. Tachycardia and palpitations '
          'have been reported.',
      'A major substrate of the cytochrome P-450 (CYP) 3A4 isoenzyme. Always '
          'check for drug interactions, especially for medications that are inducers '
          '(e.g., rifampin) and inhibitors (e.g., azole antifungals and protease '
          'inhibitors) of CYP3A4. May increase levels and toxicity of cyclosporine '
          'and tacrolimus. Doses may be administered with or without food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1053–1054',
  ),
  // ITRACONAZOLE — PDF p. 245–246 (printed 1054–1055)
  DrugEntryV3(
    name: 'ITRACONAZOLE',
    brandNames: 'Sporanox, Tolsura, and generics',
    drugClass: 'Antifungal agent',
    iconRow: '',
    formulations: [
      'Caps:',
      'Sporanox and generics: 100 mg',
      'Tolsura: 65 mg (see remarks)',
      'Oral solution (Sporanox and generics): 10 mg/mL (150 mL); contains '
          'hydroxypropyl-β-cyclodextrin, propylene glycol, and saccharin',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate (limited data in full-term neonates treated for tinea '
            'capitis):',
        lines: [
          DoseLine('5 mg/kg/24 hr PO once daily × 6 wk'),
        ],
      ),
      DoseSection(
        heading: 'Child (limited data):',
        lines: [
          DoseLine('3–5 mg/kg/24 hr PO ÷ once daily–BID; dosages as high as 5–10 mg/kg/24 hr '
              'have been used for Aspergillus prophylaxis in chronic granulomatous '
              'disease. Population pharmacokinetic data in pediatric cystic fibrosis and '
              'bone marrow transplant patients suggest an oral liquid dosage of 10 '
              'mg/kg/24 hr PO ÷ BID or oral capsule dosage of 20 mg/kg/24 hr PO ÷ BID to '
              'be more reliable for achieving trough plasma levels between 500 and 2000 '
              'ng/mL.'),
          DoseLine(
            'Prophylaxis for recurrence of opportunistic disease in HIV:',
            isHeading: true,
          ),
          DoseLine('Coccidioides spp.: 2–5 mg/kg/dose PO Q12 hr; max. dose: 400 mg/24 hr'),
          DoseLine('Cryptococcal meningitis: 5 mg/kg/dose PO Q24 hr; max. dose: 200 mg/24 hr'),
          DoseLine('Histoplasmosis: 5–10 mg/kg/dose PO Q24 hr; max. dose: 200 mg/dose'),
          DoseLine(
            'Treatment of opportunistic disease in HIV:',
            isHeading: true,
          ),
          DoseLine('Candidiasis: 5 mg/kg/24 hr PO ÷ Q12–24 hr; max. dose: 400 mg/24 hr'),
          DoseLine('Coccidioides spp. pneumonia: 2–5 mg/kg/dose (max. dose: 200 mg/dose) PO '
              'TID × 3 days, followed by 2–5 mg/kg/dose PO BID; max. dose: 400 mg/24 hr'),
          DoseLine('Cryptococcal meningitis: 2.5–5 mg/kg/dose (max. dose: 200 mg/dose) PO TID '
              '× 3 days, followed by 5–10 mg/kg/24 hr (max. dose: 400 mg/24 hr) ÷ once '
              'to twice daily for a minimum of 8 wk'),
          DoseLine('Histoplasmosis: 2–5 mg/kg/dose (max. dose: 200 mg/dose) PO TID × 3 days, '
              'followed by 2–5 mg/kg/dose (max. dose: 200 mg/dose) PO BID × 12 mo'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Blastomycosis and nonmeningeal histoplasmosis: 200 mg PO TID × 3 days, '
              'followed by 200 mg PO once daily or BID, depending on severity'),
          DoseLine('Aspergillosis and severe infections (use oral solution): 600 mg/24 hr PO '
              '÷ TID × 3–4 days, followed by 200–400 mg/24 hr ÷ BID; max. dose: 600 '
              'mg/24 hr ÷ TID'),
        ],
      ),
    ],
    remarks: [
      'Oral solution and capsule dosage form should NOT be used interchangeably; '
          'oral solution is more bioavailable. Only the oral solution has been '
          'demonstrated effective for oral and/or esophageal candidiasis. '
          'Contraindicated in CHF and with certain interacting drugs (see below). '
          'Use with caution in hepatic and/or renal impairment, cardiac '
          'dysrhythmias, and azole hypersensitivity. May cause GI symptoms, '
          'headaches, rash, liver enzyme elevation, hepatitis, and hypokalemia. '
          'Double/blurred vision, dizziness, tremor, and pseudoaldosteronism have '
          'been reported.',
      'Like ketoconazole, it inhibits the activity of the cytochrome P-450 3A4 '
          'drug-metabolizing isoenzyme. Thus, the co-administration of cisapride, '
          'dofetilide, felodipine, methadone, nisoldipine, pimozide, quinidine, '
          'triazolam, lovastatin, simvastatin, ergot derivatives, and oral midazolam '
          'is contraindicated. May increase systemic hormone concentrations of oral '
          'contraceptives. See remarks in Ketoconazole for additional drug '
          'interaction information.',
      'Steady-state serum concentrations of >0.25 mg/L itraconazole and >1 mg/L '
          'hydroxyitraconazole (metabolite) have been recommended. Recommended serum '
          'sampling time at steady state: any time after 2 wk after continuous '
          'dosing. Itraconazole has a 34–42-hr T₁/₂.',
      'Administer oral solution and Tolsura capsule on an empty stomach but '
          'administer generic capsules with food. The administration of Tolsura (two '
          '65-mg capsules) with food achieved similar systemic exposure as to '
          'Sporanox 100-mg capsules administered with food. Oral capsule '
          'bioavailability has been shown to be reduced in immunocompromised '
          'patients. Achlorhydria reduces absorption of the drug. Do not use oral '
          'liquid dosage form in patients with GFR <30 mL/min, because '
          'hydroxypropyl-β-cyclodextrin excipient has reduced clearance with renal '
          'failure.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1054–1055',
  ),
  // IVACAFTOR — PDF p. 246–247 (printed 1055–1056)
  DrugEntryV3(
    name: 'IVACAFTOR',
    brandNames: 'Kalydeco',
    drugClass: 'Cystic fibrosis transmembrane conductance regulator (CFTR) '
        'potentiator',
    iconRow: '',
    formulations: [
      'Oral granules: 5.8, 13.4, 25, 50, 75 mg (each strength available in '
          'packets of 56)',
      'Tabs: 150 mg (56 tabs)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Cystic fibrosis (see remarks):',
        lines: [
          DoseLine('<2 mo and ≥3 kg (use oral granules): 5.8 mg PO Q12 hr'),
          DoseLine('2–<4 mo and ≥3 kg (use oral granules): 13.4 mg PO Q12 hr'),
          DoseLine('4–<6 mo and ≥5 kg (use oral granules): 25 mg PO Q12 hr'),
          DoseLine(
            '≥6 mo and child <6 yr (use oral granules):',
            isHeading: true,
          ),
          DoseLine('5–<7 kg: 25 mg PO Q12 hr'),
          DoseLine('7–<14 kg: 50 mg PO Q12 hr'),
          DoseLine('≥14 kg: 75 mg PO Q12 hr'),
          DoseLine('≥6 yr, adolescent, and adult (use tabs): 150 mg PO Q12 hr'),
          DoseLine(
            'Dosage modification with hepatic impairment:',
            isHeading: true,
          ),
          DoseLine('Child-Pugh class B (moderate): Use above dosage with a once-daily dosage '
              'interval'),
          DoseLine('Child-Pugh class C (severe): Studies have not been completed, but '
              'exposure is expected to be higher than class B; use above dosage with '
              'caution once daily or with a less frequent dosage interval.'),
          DoseLine('Hepatotoxicity (ALT or AST >5× ULN) during therapy: Hold doses and '
              'reinitiate therapy after resolution of enzyme elevation if the benefits '
              'outweigh the risks'),
        ],
      ),
      DoseSection(
        heading: 'Dosage Modification When Used With Cytochrome P-450 (CYP) 3A '
            'Inhibitors',
        table: DoseTable(
          headers: ['Age', 'Weight (kg)', 'Dosed With Strong CYP 3A Inhibitor (e.g., Ketoconazole, Itraconazole, '
                'Voriconazole, Posaconazole, Clarithromycin)', 'Dosed With Moderate CYP 3A Inhibitor (e.g., Erythromycin, Fluconazole)'],
          rows: [
            DoseTableRow(['4–<6 mo', '≥5 kg', 'Use not recommended', 'Use not recommended']),
            DoseTableRow(['≥6 mo and <6 yr', '5–<7 kg', '25 mg PO twice weekly', '25 mg PO once daily']),
            DoseTableRow(['', '7–<14 kg', '50 mg PO twice weekly', '50 mg PO once daily']),
            DoseTableRow(['', '≥14 kg', '75 mg PO twice weekly', '75 mg PO once daily']),
            DoseTableRow(['≥6 yr, adolescent, and adult', 'All', '150 mg PO twice weekly', '150 mg PO once daily']),
          ],
        ),
      ),
    ],
    remarks: [
      'Works as a CFTR potentiator on class 3 CFTR mutations. Originally '
          'indicated for G551D CFTR mutation but has since been approved for many '
          'other mutations; see product information for list of approved mutations. '
          'Use is not recommended in children 4–<6 mo with hepatic impairment (due '
          'to variability of CYP enzyme maturation) and/or taking moderate or strong '
          'CYP 3A inhibitors.',
      'Common side effects include rash, abdominal pain, diarrhea, nausea, '
          'dizziness, headache, nasal congestion, pharyngitis, and URIs. Increased '
          'liver enzymes and cataracts may occur; monitor baseline AST/ALT and '
          'ocular exam. Repeat AST/ALT every 3 months for the first year, followed '
          'by annual assessments. Repeat ocular exams annually. May cause a '
          'false-positive urine drug screen test for cannabinoids. Hypersensitivity '
          'reactions, including anaphylaxis, have been reported. Use with caution in '
          'patients with CrCl ≤30 mL/min; has not been studied.',
      'Ivacaftor is CYP 3A substrate; see dose modification table in the dosing '
          'section. Use with strong CYP 3A inducers (e.g., rifampin, rifabutin, '
          'carbamazepine, St. John’s wort) is not recommended. Ivacaftor may inhibit '
          'CYP 2C9 and increase the effects/toxicity of warfarin. Always evaluate '
          'potential drug-drug interactions; see '
          'https://www.kalydecohcp.com/drug-interactions. Avoid food or drink '
          'containing grapefruit or Seville oranges.',
      'Administer all doses with high-fat foods to ensure absorption. Oral '
          'granules can be mixed with 5 mL of soft foods or liquids such as puréed '
          'fruits or vegetables, yogurt, applesauce, water, breast milk, infant '
          'formula, milk, or juice. Once mixed, it should be consumed within an '
          'hour. If a dose (all dosage forms) is missed within 6 hr of a scheduled '
          'dose, administer a dose immediately. However, if the missed dose is >6 '
          'hr, skip that dose and resume therapy at the next scheduled dose. Never '
          'take a double dose for a missed dose.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1055–1056',
  ),
  // IVERMECTIN — PDF p. 248–249 (printed 1057–1058)
  DrugEntryV3(
    name: 'IVERMECTIN',
    brandNames: 'Stromectol, Sklice, Soolantra, and generics',
    drugClass: 'Anthelmintic',
    iconRow: '',
    formulations: [
      'Tab (Stromectol and generics): 3 mg',
      'Topical lotion (OTC and prescription; Sklice): 0.5% (117 g); contains '
          'parabens',
      'Topical cream (Soolantra and generics): 1% (45 g); contains cetyl '
          'alcohol, EDTA, parabens, and propylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Systemic use:',
        lines: [
          DoseLine('Cutaneous lava migrans or strongyloidiasis: 0.2 mg/kg/dose PO once daily '
              '× 1 day for cutaneous lava migrans and × 1–2 days for strongyloidiasis; '
              'dosing by body weight as follows'),
          DoseLine('Scabies: 0.2 mg/kg/dose PO × 1, followed by repeat second dose in 7 or '
              '10–14 days; dosing by body weight as follows'),
        ],
      ),
      DoseSection(
        heading: 'Dosing for Cutaneous Lava Migrans, Strongyloidiasis, and Scabies',
        table: DoseTable(
          headers: ['Weight (kg)', 'Oral Dose'],
          rows: [
            DoseTableRow(['15–24', '3 mg']),
            DoseTableRow(['25–35', '6 mg']),
            DoseTableRow(['36–50', '9 mg']),
            DoseTableRow(['51–65', '12 mg']),
            DoseTableRow(['66–79', '15 mg']),
            DoseTableRow(['≥80', '0.2 mg/kg']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('Onchocerciasis: 0.15 mg/kg/dose PO × 1; may repeat dose every 6 mo until '
              'asymptomatic; dosing by body weight as follows'),
        ],
      ),
      DoseSection(
        heading: 'Dosing for Onchocerciasis',
        table: DoseTable(
          headers: ['Weight (kg)', 'Single Oral Dose'],
          rows: [
            DoseTableRow(['15–25', '3 mg']),
            DoseTableRow(['26–44', '6 mg']),
            DoseTableRow(['45–64', '9 mg']),
            DoseTableRow(['65–84', '12 mg']),
            DoseTableRow(['≥85', '0.15 mg/kg']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Topical use (see remarks):',
        lines: [
          DoseLine(
            'Lotion:',
            isHeading: true,
          ),
          DoseLine('Head lice infestation (≥6 mo to adult): Apply lotion to dry hair in '
              'sufficient amounts (up to one full tube) to thoroughly coat the hair and '
              'scalp for 10 min. Then rinse off with water.'),
          DoseLine(
            'Cream:',
            isHeading: true,
          ),
          DoseLine('Rosacea (Adult): Apply cream to each affected area (avoiding eyes and '
              'lips) once daily.'),
        ],
      ),
    ],
    remarks: [
      'Systemic Use: Rare fatal encephalopathy may occur in onchocerciasis with '
          'a concurrent heavy Loa loa infection. Reactions experienced with '
          'strongyloidiasis include diarrhea, nausea, vomiting, pruritus, rash, '
          'dizziness, and drowsiness. Adverse reactions experienced in '
          'onchocerciasis include cutaneous or systemic allergic/inflammatory '
          'reactions of varying severity (Mazzotti reaction) and ophthalmologic '
          'reactions. Neurotoxicity ranging from somnolence/drowsiness and stupor to '
          'coma has been reported in patients without onchocerciasis or in patients '
          'with onchocerciasis in the absence of Loa loa. Specific reactions may '
          'include arthralgia/synovitis, lymph node enlargement and tenderness, '
          'pruritus, edema, fever, orthostatic hypotension, and tachycardia. Therapy '
          'for postural hypotension may include oral hydration, recumbency, IV '
          'normal saline, and/or IV steroids. Antihistamines or aspirin, or both, '
          'have been used for most mild-to-moderate cases.',
      'Ivermectin may increase the effects/toxicity of warfarin. Administer oral '
          'doses on an empty stomach with water.',
      'Topical Use: Safety and efficacy have not been established for children '
          '<6 mo. Common side effects include conjunctivitis, ocular hyperemia, eye '
          'irritation, dandruff, dry skin, and skin burning. Contact dermatitis has '
          'been reported. Not for oral, ophthalmic, or intravaginal use. Use of '
          'lotion for children should be supervised by an adult to prevent oral '
          'ingestion.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1057–1058',
  ),
];
