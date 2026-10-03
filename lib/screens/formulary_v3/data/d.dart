// =============================================================================
// output/d.dart — Drug Formulary 3.0, letter D
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyD` per file; entries in book order.
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

const List<DrugEntryV3> formularyD = [
  // DABIGATRAN ETEXILATE MESYLATE — PDF p. 136–137 (printed 945–946)
  DrugEntryV3(
    name: 'DABIGATRAN ETEXILATE MESYLATE',
    brandNames: 'Pradaxa and generics',
    drugClass: 'Anticoagulant, direct thrombin inhibitor',
    iconRow: '',
    formulations: [
      'Oral pellets:',
      'Pradaxa: 20, 30, 40, 50, 110, 150 mg (60 packets of pellets per carton)',
      'Caps:',
      'Pradaxa and generics: 75, 110, 150 mg; may contain carrageenan',
    ],
    doseSections: [
      DoseSection(
        heading: 'Oral pellets and capsule dosage forms are NOT bioequivalent and are '
            'NOT interchangeable on a mg-per-mg basis.',
      ),
      DoseSection(
        heading: 'Refer to institutional-specific protocol when transitioning from '
            'another anticoagulant.',
      ),
      DoseSection(
        heading: 'Prevention and treatment of venous thromboembolic event (VTE; see '
            'remarks):',
      ),
      DoseSection(
        heading: 'Child 3 mo–<2 yr (Using Oral Pellets)',
        table: DoseTable(
          headers: ['Weight (kg)', 'Age (mo)', 'Dose (mg) PO BID'],
          rows: [
            DoseTableRow(['3–<4', '3–<6 mo', '30']),
            DoseTableRow(['4–<5', '3–<10 mo', '40']),
            DoseTableRow(['5–<7', '3–<5 mo', '40']),
            DoseTableRow(['', '5–<24 mo', '50']),
            DoseTableRow(['7–<9', '3–<4 mo', '50']),
            DoseTableRow(['', '4–<9 mo', '60']),
            DoseTableRow(['', '9–<24 mo', '70']),
            DoseTableRow(['9–<11', '5–<6 mo', '60']),
            DoseTableRow(['', '6–<11 mo', '80']),
            DoseTableRow(['', '11–<24 mo', '90']),
            DoseTableRow(['11–<13', '8–<18 mo', '100']),
            DoseTableRow(['', '18–<24 mo', '110']),
            DoseTableRow(['13–<16', '10–<11 mo', '100']),
            DoseTableRow(['', '11–<24 mo', '140']),
            DoseTableRow(['16–<21', '12–<24 mo', '140']),
            DoseTableRow(['21–<26', '18–<24 mo', '180']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine(
            'Child 2–12 yr (PO BID; using oral pellets):',
            isHeading: true,
          ),
          DoseLine('7–<9 kg: 70 mg'),
          DoseLine('9–<11 kg: 90 mg'),
          DoseLine('11–<13 kg: 110 mg'),
          DoseLine('13–<16 kg: 140 mg'),
          DoseLine('16–<21 kg: 170 mg'),
          DoseLine('21–<41 kg: 220 mg'),
          DoseLine('≥41 kg: 260 mg'),
          DoseLine(
            'Child 8–<18 yr (PO BID; using oral capsules):',
            isHeading: true,
          ),
          DoseLine('11–<16 kg: 75 mg'),
          DoseLine('16–<26 kg: 110 mg'),
          DoseLine('26–<41 kg: 150 mg'),
          DoseLine('41–<61 kg: 185 mg'),
          DoseLine('61–<81 kg: 220 mg'),
          DoseLine('≥81 kg: 260 mg'),
          DoseLine('Adult (PO BID; using oral capsules): 150 mg'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in mechanical prosthetic heart valves, active bleeding, '
          'and prior serious hypersensitivity reactions to dabigatran and any of its '
          'excipients. Use is NOT recommended in patients with triple-positive '
          'antiphospholipid syndrome due to the increased risk for recurrent '
          'thrombosis. Epidural or spinal hematomas may occur in patients receiving '
          'neuraxial anesthesia or undergoing spinal puncture and may result in '
          'paralysis.',
      'Common side effects include esophagitis, gastritis, indigestion, GI '
          'hemorrhage, and hemorrhage. Alopecia, angioedema, neutropenia, and '
          'agranulocytosis have been reported. Idarucizumab is the reversal agent '
          'indicated for adults in situations of emergency surgery/urgent procedures '
          'and life-threatening/uncontrolled bleeding. Pediatric use of idarucizumab '
          '(reversal agent) has not been established. Consider the use of an '
          'alternative anticoagulant to decrease the risk of thrombosis in '
          'situations in which dabigatran is discontinued for reasons other than '
          'pathological bleeding or completion of a therapy course.',
      'Safety and efficacy have been established in children 8–<18 years of age '
          'for the treatment and prophylaxis of venous thromboembolism. In a phase 3 '
          'pediatric treatment trial, site-specific bleeding rates were comparable '
          'to standard-of-care therapy (vitamin K antagonists, low-molecular-weight '
          'heparin, or fondaparinux) except for GI bleeds (5.7% vs. 1.8%). An '
          'open-label study evaluating the safety of dabigatran prophylaxis '
          'following a treatment course of dabigatran noted common side effects of '
          'dyspepsia, epistaxis, nausea, and menorrhagia. The adverse reaction '
          'profile for this pediatric trial was generally consistent with that of '
          'adult patients.',
      'Adjust dose in renal impairment (see Chapter 32); pediatric renal '
          'impairment studies have not been completed. Dabigatran is a '
          'P-glycoprotein (P-gp)/ABCB1 substrate. Avoid use with rifampin (P-gp '
          'inducer). Use with a P-gp inhibitor in patients with renal impairment is '
          'likely to result in supratherapeutic/toxic effects.',
      'BID dosing should be separated by Q12 hr when possible. DO NOT combine '
          'the capsule and pellet dosage forms as they are NOT bioequivalent. '
          'Capsules may be administered with or without food and MUST NOT be opened '
          'or chewed. Oral pellets are mixed with mashed carrot or banana, '
          'applesauce, or apple juice (see product information for specific '
          'instructions) for administration. DO NOT administer oral pellets via oral '
          'syringes or feeding tubes and DO NOT mix them with milk or any '
          'milk-containing products.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 945–946',
  ),
  // DANTROLENE — PDF p. 137–138 (printed 946–947)
  DrugEntryV3(
    name: 'DANTROLENE',
    brandNames: 'Dantrium, Revonto, Ryanodex, and generics',
    drugClass: 'Skeletal muscle relaxant',
    iconRow: '',
    formulations: [
      'Caps:',
      'Dantrium and generics: 25, 50, 100 mg',
      'Oral suspension: 5 mg/mL',
      'Injection:',
      'Dantrium, Revonto, and generics: 20 mg; injectable solution containing 3 '
          'g mannitol per 20 mg drug; some preparations may be preservative free',
      'Ryanodex : 250 mg; injectable suspension containing 125 mg mannitol, 25 '
          'mg polysorbate 80, 4 mg povidone K12 per 250 mg drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'Chronic spasticity:',
        lines: [
          DoseLine(
            'Child (≥5 yr):',
            isHeading: true,
          ),
          DoseLine('Initial: 0.5 mg/kg/dose (max. dose: 25 mg/dose) PO BID'),
          DoseLine('Increment: Increase frequency to TID–QID at 4- to 7-day intervals, then '
              'increase doses by 0.5 mg/kg/dose'),
          DoseLine('Max. dose: 3 mg/kg/dose PO QID, up to 400 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Malignant hyperthermia (infant, child, and adult):',
        lines: [
          DoseLine(
            'Prevention:',
            isHeading: true,
          ),
          DoseLine('PO: 4–8 mg/kg/24 hr ÷ Q6 hr × 1–2 days before surgery, with last dose '
              'administered 3–4 hr prior to surgery'),
          DoseLine('IV (see remarks for specific dosage form administration rates): 2.5 mg/kg '
              'beginning 1.25 hr before anesthesia, additional doses PRN'),
          DoseLine('Treatment (see remarks for specific dosage form administration rates): 1 '
              'mg/kg IV, repeat PRN to maximum cumulative dose of 10 mg/kg, followed by '
              'a post-crisis regimen of 4–8 mg/kg/24 hr PO ÷ Q6 hr for 1–3 days'),
        ],
      ),
      DoseSection(
        heading: 'IV Administration Rates for Malignant Hyperthermia',
        table: DoseTable(
          headers: ['Dosage Form', 'Prevention Use', 'Treatment Use'],
          rows: [
            DoseTableRow(['Injectable solution', 'Over 1 hr', 'IV push']),
            DoseTableRow(['Injectable suspension', 'Over at least 1 min', 'IV push']),
          ],
        ),
      ),
    ],
    remarks: [
      'Contraindicated in active hepatic disease. Monitor transaminases for '
          'hepatotoxicity. Use with caution with cardiac or pulmonary impairment. '
          'May cause change in sensorium, drowsiness, weakness, diarrhea, '
          'constipation, incontinence, and enuresis. Rare cardiovascular collapse '
          'has been reported in patients receiving concomitant verapamil. May '
          'potentiate vecuronium-induced neuromuscular block. Elevated liver enzymes '
          'and hepatic toxicity have been reported hours to days following the use '
          'of the IV dosage form, especially in patients with comorbidities (e.g., '
          'critical illness).',
      'Avoid unnecessary exposure of medication to sunlight. Avoid extravasation '
          'into tissues. A decrease in spasticity sufficient to allow daily function '
          'should be the therapeutic goal. Discontinue if benefits are not evident '
          'in 45 days.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 946–947',
  ),
  // DAPSONE — PDF p. 138–139 (printed 947–948)
  DrugEntryV3(
    name: 'DAPSONE',
    brandNames: 'Aczone, Diaminodiphenyl sulfone, DDS, and generics',
    drugClass: 'Antibiotic, sulfone derivative',
    iconRow: '',
    formulations: [
      'Tabs: 25, 100 mg',
      'Oral suspension: 2 mg/mL',
      'Topical gel (Aczone and generics): 5%, 7.5% (60, 90 g); contains '
          'methylparaben',
    ],
    doseSections: [
      DoseSection(
        heading: 'Pneumocystis jiroveci (formerly carinii) treatment:',
        lines: [
          DoseLine('Child and adult: 2 mg/kg/24 hr PO once daily (max. dose: 100 mg/24 hr) '
              'with trimethoprim 15 mg/kg/24 hr PO ÷ TID × 21 days'),
        ],
      ),
      DoseSection(
        heading: 'P. jiroveci (formerly carinii) prophylaxis (first episode and '
            'recurrence):',
        lines: [
          DoseLine('Child ≥1 mo: 2 mg/kg/24 hr PO once daily; max. dose: 100 mg/24 hr. '
              'Alternative weekly dosing: 4 mg/kg/dose PO Q7 days; max. dose: 200 mg/dose'),
          DoseLine('Adult: 100 mg/24 hr PO ÷ once daily–BID as monotherapy; OR 50 mg PO once '
              'daily with pyrimethamine 50 mg PO Q7 days and leucovorin 25 mg PO Q7 '
              'days; other combination regimens with pyrimethamine and leucovorin may be '
              'used (see https://clinicalinfo.hiv. gov/en/guidelines)'),
        ],
      ),
      DoseSection(
        heading: 'Toxoplasma gondii prophylaxis (prevent first episode):',
        lines: [
          DoseLine('Child ≥1 mo: 2 mg/kg/24 hr (max. dose: 25 mg/24 hr) PO once daily with '
              'pyrimethamine 1 mg/kg/24 hr (max. 25 mg/dose) PO once daily and '
              'leucovorin 5 mg PO Q3 days'),
          DoseLine('Adolescent and adult: 50 mg PO once daily with pyrimethamine 50 mg PO Q7 '
              'days and leucovorin 25 mg PO Q7 days; other combination regimens with '
              'pyrimethamine and leucovorin may be used (see '
              'https://clinicalinfo.hiv.gov/en/guidelines)'),
        ],
      ),
      DoseSection(
        heading: 'Leprosy (see '
            'https://www.hrsa.gov/hansens-disease/diagnosis/recommended-treatment '
            'for the National Hansen’s Disease Program latest recommendations, '
            'including combination regimens such as rifampin ± clofazimine):',
        lines: [
          DoseLine('Child: 1–2 mg/kg/24 hr PO once daily; max. dose: 100 mg/24 hr'),
          DoseLine('Adult: 100 mg PO once daily'),
        ],
      ),
      DoseSection(
        heading: 'Acne vulgaris (topical gel; reevaluate patient if no improvement '
            'after 12 wk of therapy):',
        lines: [
          DoseLine('5% gel (≥12 yr old): Apply small amount (pea size) of topical gel onto '
              'clean, acne-affected areas BID.'),
          DoseLine('7.5% gel (≥9 yr old): Apply small amount (pea size) of topical gel onto '
              'clean, acne-affected areas once daily.'),
        ],
      ),
    ],
    remarks: [
      'Patients with HIV, glutathione deficiency, or G6PD deficiency may be at '
          'increased risk for developing methemoglobinemia. Side effects include '
          'hemolytic anemia (dose related), agranulocytosis, methemoglobinemia, '
          'aplastic anemia, nausea, vomiting, hyperbilirubinemia, headache, '
          'nephrotic syndrome, and hypersensitivity reaction (sulfone syndrome). '
          'Cholestatic jaundice, hepatitis, peripheral neuropathy, and suicidal '
          'intent have been reported with systemic use.',
      'Didanosine, rifabutin, and rifampin decrease dapsone levels. Trimethoprim '
          'increases dapsone levels. Pyrimethamine, nitrofurantoin, primaquine, and '
          'zidovudine increase risk for hematological side effects.',
      'Oral suspension may not be absorbed as well as tablets.',
      'TOPICAL USE: Dry skin, erythema, and peeling of the skin may occur. Use '
          'of topical gel, followed by benzoyl peroxide for acne, has resulted in '
          'temporary local discoloration (yellow/orange) of the skin and facial '
          'hair. Avoid use of topical gel in G6PD deficiency or '
          'congenital/idiopathic methemoglobinemia.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 947–948',
  ),
  // DARBEPOETIN ALFA — PDF p. 139–141 (printed 948–950)
  DrugEntryV3(
    name: 'DARBEPOETIN ALFA',
    brandNames: 'Aranesp',
    drugClass: 'Erythropoiesis-stimulating protein',
    iconRow: '',
    formulations: [
      'Injection: 25, 40, 60, 100, 200 mCg/1 mL (1 mL)',
      'Single-dose prefilled injection syringe (27-gauge ½-inch needle): 10 '
          'mCg/0.4 mL (0.4 mL), 25 mCg/0.42 mL (0.42 mL), 40 mCg/0.4 mL (0.4 mL), 60 '
          'mCg/0.3 mL (0.3 mL), 100 mCg/0.5 mL (0.5 mL), 150 mCg/0.3 mL (0.3 mL), '
          '200 mCg/0.4 mL (0.4 mL), 300 mCg/0.6 mL (0.6 mL), 500 mCg/1 mL (1 mL)',
      'Both dosage forms contain polysorbate 80 (0.05 mg/mL) and mouse and/or '
          'hamster protein; albumin free and preservative free.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Anemia in chronic renal failure (see remarks):',
        lines: [
          DoseLine(
            'Receiving dialysis (initial dosage; adjust dose according to the table '
                'that follows; IV route is recommended for patients on hemodialysis):',
            isHeading: true,
          ),
          DoseLine('Infant, child, and adolescent: Start with 0.45 mCg/kg/dose IV/SC once '
              'weekly.'),
          DoseLine('Adult: Start with 0.45 mCg/kg/dose IV/SC once weekly, OR 0.75 mCg/kg/dose '
              'IV/SC once every 2 wk.'),
          DoseLine(
            'Not receiving dialysis (initial dosage; adjust dose according to the '
                'table that follows):',
            isHeading: true,
          ),
          DoseLine('Infant, child, and adolescent: Start with 0.45 mCg/kg/dose IV/SC once '
              'weekly, OR 0.75 mCg/kg/dose IV/SC once every 2 wk.'),
          DoseLine('Adult: Start with 0.45 mCg/kg/dose IV/SC once every 4 wk.'),
        ],
      ),
      DoseSection(
        heading: 'Darbepoetin Alfa Dose Adjustment in Anemia Associated With Chronic '
            'Renal Failure',
        table: DoseTable(
          headers: ['Response to Dose', 'Dose Adjustment'],
          rows: [
            DoseTableRow(['<1 g/dL increase in hemoglobin and below target range after 4 wk of '
                'therapy', 'Increase dose by 25% not more frequently than once monthly. Further '
                'increases, if needed, may be done at 4-wk intervals. Among those who do '
                'not adequately respond over a 12-wk escalation period, further dose '
                'increase is unlikely to improve response and may increase risks.']),
            DoseTableRow(['>1 g/dL increase in hemoglobin in any 2-wk period or if hemoglobin '
                'exceeds and approaches 11 g/dL', 'Decrease dose by 25% or more.']),
            DoseTableRow(['Hemoglobin continues to increase despite dosage reduction', 'Discontinue therapy; reinitiate therapy at a dose 25% lower than the '
                'previous dose after the hemoglobin starts to decrease.']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Anemia associated with chemotherapy (patients with nonmyeloid '
            'malignancies):',
        lines: [
          DoseLine('Child (limited data) and adult (see remarks): Start with 2.25 mCg/kg/dose '
              'SC once weekly and adjust dose according to the table that follows:'),
        ],
      ),
      DoseSection(
        heading: 'Darbepoetin Alfa Dose Adjustment in Anemia Associated With '
            'Chemotherapy',
        table: DoseTable(
          headers: ['Response to Dose', 'Dose Adjustment'],
          rows: [
            DoseTableRow(['<1 g/dL increase in hemoglobin and remains below 10 g/dL after 6 wk of '
                'therapy', 'Increase dose to 4.5 mCg/kg/dose once weekly SC/IV.']),
            DoseTableRow(['>1 g/dL increase in hemoglobin in any 2-wk period or when hemoglobin '
                'reaches a level needed to avoid transfusion', 'Decrease dose by 40%.']),
            DoseTableRow(['If hemoglobin exceeds a level needed to avoid transfusion', 'Hold therapy until hemoglobin approaches a level at which transfusions '
                'may be required and restart at a dose reduced by 40%.']),
            DoseTableRow(['Lack of response after 8 wk or completion of chemotherapy', 'Discontinue therapy.']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Conversion from epoetin alfa to darbepoetin alfa (see table below):',
        table: DoseTable(
          headers: ['Previous Weekly Epoetin Alfa Dose (units/wk)ᵃ', 'Pediatric Weekly Darbepoetin Alfa Dose (mCg/wk) Administered SC/IV Once '
                'Weeklyᵇ', 'Adult Weekly Darbepoetin Alfa Dose (mCg/wk) Administered SC/IV Once '
                'Weeklyᵇ', 'Adult Once Every 2 wk Darbepoetin Alfa Dose (mCg Every 2 wk) Administered '
                'SC/IV Once Every 2 wkᶜ'],
          rows: [
            DoseTableRow(['<1,500', 'Insufficient data', '6.25', '12.5']),
            DoseTableRow(['1,500–2,499', '6.25', '6.25', '12.5']),
            DoseTableRow(['2,500–4,999', '10', '12.5', '25']),
            DoseTableRow(['5,000–10,999', '20', '25', '50']),
            DoseTableRow(['11,000–17,999', '40', '40', '80']),
            DoseTableRow(['18,000–33,999', '60', '60', '120']),
            DoseTableRow(['34,000–89,999', '100', '100', '200']),
            DoseTableRow(['≥90,000', '200', '200', '400']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃ200 units of epoetin alfa is equivalent to 1 mCg darbepoetin alfa.'),
          DoseLine('ᵇIf patient was receiving epoetin alfa 2–3 times weekly, darbepoetin alfa '
              'should be administered once weekly.'),
          DoseLine('ᶜIf patient was receiving epoetin alfa once weekly, darbepoetin alfa '
              'should be administered once every 2 wk.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in uncontrolled hypertension and patients hypersensitive '
          'to albumin/polysorbate 80 or epoetin alfa. Darbepoetin alfa is not '
          'intended for patients requiring acute correction of anemia. Use with '
          'caution in seizures and liver disease. Erythema multiforme, SJS, and TEN '
          'have been reported. Evaluate serum iron, ferritin, and TIBC; concurrent '
          'iron supplementation may be necessary. Red cell aplasia and severe anemia '
          'associated with neutralizing antibodies to erythropoietin have been '
          'reported.',
      'USE IN CHRONIC RENAL FAILURE: Higher doses may be needed for pediatric '
          'patients being switched from epoetin alfa than those for naïve patients. '
          'May cause edema, fatigue, GI disturbances, headache, blood pressure '
          'changes, fever, cardiac arrhythmia/arrest, infections, and myalgia. '
          'Higher risk for mortality and serious cardiovascular events have been '
          'reported with higher targeted hemoglobin levels (>11 g/dL). If hemoglobin '
          'levels do not increase or reach targeted levels despite appropriate dose '
          'titrations over a 12-wk period, (1) do not administer higher doses and '
          'instead use the lowest dose that will maintain hemoglobin levels to avoid '
          'the need for recurrent blood transfusions; (2) evaluate and treat other '
          'causes of anemia; (3) always follow the dose adjustment instructions; and '
          '(4) discontinue use if patient remains transfusion dependent.',
      'USE IN CANCER: Use only for anemia due to myelosuppressive chemotherapy; '
          'not effective in reducing the need for transfusions in patients with '
          'anemia not due to chemotherapy. Shortened survival and time to tumor '
          'progression have been reported in patients with various cancers. May '
          'cause fatigue, fever, edema, dizziness, headache, GI disturbances, '
          'arthralgia/myalgia, and rash. Use lowest dose to avoid transfusions and '
          'do not exceed hemoglobin levels >12 g/dL; increased frequency of adverse '
          'events, including mortality and thrombotic vascular events, have been '
          'reported. Prescribers and hospitals must enroll in and comply with the '
          'ESA APPRISE Oncology Program to prescribe and/or dispense this drug to '
          'cancer patients.',
      'Monitor hemoglobin, BP, serum chemistries, and reticulocyte count. '
          'Increases in dose should not be made more frequently than once a month. '
          'For IV administration, infuse over 1–3 min.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 948–950',
  ),
  // DEFEROXAMINE MESYLATE — PDF p. 142 (printed 951)
  DrugEntryV3(
    name: 'DEFEROXAMINE MESYLATE',
    brandNames: 'Desferal and generics',
    drugClass: 'Chelating agent',
    iconRow: '',
    formulations: [
      'Injection:',
      'Desferal: 500 mg',
      'Generics: 500, 2000 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Acute iron poisoning (if using IV route, convert to IM as soon as the '
            'patient’s clinical condition permits; see remarks):',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('IV: 15 mg/kg/hr'),
          DoseLine('IM: 50 mg/kg/dose Q6 hr'),
          DoseLine('Max. IV or IM dose: 6 g/24 hr'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('IV: 15 mg/kg/hr'),
          DoseLine('IM: 1 g × 1, then 0.5 g Q4 hr × 2; may repeat 0.5 g Q4–12 hr'),
          DoseLine('Max. dose: 6 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Chronic iron overload (see remarks):',
        lines: [
          DoseLine(
            'Child and adolescent:',
            isHeading: true,
          ),
          DoseLine('IV: 20–40 mg/kg/dose over 8–12 hr once daily × 5–7 days per week; usual '
              'max. dose: 40 mg/kg/24 hr (child) or 60 mg/kg/24 hr (adolescent)'),
          DoseLine('SC: 20–40 mg/kg/dose once daily as infusion over 8–12 hr × 3–7 days per '
              'week; max. dose: 2 g/24 hr'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('IV: 40–50 mg/kg/dose over 8–12 hr once daily × 5–7 days per week; max. '
              'dose: 60 mg/kg/24 hr'),
          DoseLine('IM: 0.5–1 g/dose once daily; max. dose: 1 g/24 hr'),
          DoseLine('SC: 1–2 g/dose once daily as infusion over 8–24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in severe renal disease or anuria. Not approved for use '
          'in primary hemochromatosis. May cause flushing, erythema, urticaria, '
          'hypotension, tachycardia, diarrhea, leg cramps, fever, cataracts, hearing '
          'loss, nausea, and vomiting. Iron mobilization may be poor in children <3 '
          'yr. Serum creatinine elevation, acute renal failure, renal tubular '
          'disorders, and hepatic dysfunction have been reported.',
      'Avoid use if glomerular filtration rate (GFR) <10 mL/min and administer '
          '25%–50% of usual dose if GFR is 10–50 mL/min or patient is receiving '
          'continuous renal replacement therapy (CRRT).',
      'High doses and concomitant low ferritin levels have also been associated '
          'with growth retardation. Growth velocity may resume to pretreatment '
          'levels by reducing the dosage. Acute respiratory distress syndrome (ARDS) '
          'has been reported following treatment with excessively high IV doses in '
          'patients with acute iron intoxication or thalassemia. Toxicity risk has '
          'been reported with infusions >8 mg/kg/hr for >4 days for thalassemia, and '
          'with infusions of 15 mg/kg/hr for >1 day for acute iron toxicity. '
          'Pulmonary toxicity was not seen in 193 courses.',
      'For IV infusion, maximum rate: 15 mg/kg/hr. Infuse over 6–12 hr for '
          'mild/moderate iron intoxication and over 24 hr for severe cases, then '
          'reassess. SC route is via a portable controlled-infusion device and is '
          'not recommended in acute iron poisoning.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 951',
  ),
  // DESMOPRESSIN ACETATE — PDF p. 143–144 (printed 952–953)
  DrugEntryV3(
    name: 'DESMOPRESSIN ACETATE',
    brandNames: 'DDAVP, Nocdurna, and generics; previously available as Stimate',
    drugClass: 'Vasopressin analog, synthetic; hemostatic agent',
    iconRow: '',
    formulations: [
      'Tabs:',
      'DDAVP and generics: 0.1, 0.2 mg',
      'Sublingual tabs:',
      'Nocdurna: 27.7, 55.3 mCg; contains fish gelatin and mannitol',
      'Injection:',
      'DDAVP and generics: 4 mCg/mL (1, 10 mL); contains 9 mg NaCl/mL and may '
          'contain chlorobutanol (some preparations are preservative free)',
      'Nasal spray:',
      'Generics: 100 mCg/mL, 10 mCg/spray (50 sprays, 5 mL); contains 7.5 mg '
          'NaCl/mL and 0.2 mg benzalkonium chloride/mL',
      'Conversion: 100 mCg = 400 IU arginine vasopressin',
    ],
    doseSections: [
      DoseSection(
        heading: 'Diabetes insipidus (see remarks):',
        lines: [
          DoseLine(
            'Oral:',
            isHeading: true,
          ),
          DoseLine('Child ≤12 yr: Start with 0.05 mg/dose BID; titrate dose to effect; usual '
              'dose range: 0.1–0.8 mg/24 hr.'),
          DoseLine('Child >12 yr and adult: Start with 0.05 mg/dose BID; titrate dose to '
              'effect; usual dose range: 0.1–1.2 mg/24 hr ÷ BID–TID.'),
          DoseLine(
            'Nasal spray (titrate dose to achieve control of excessive thirst and '
                'urination. Morning and evening doses should be adjusted separately for '
                'diurnal rhythm of water turnover):',
            isHeading: true,
          ),
          DoseLine('≥4–18 yr: Start at 10 mCg once daily, may titrate up to 30 mCg/24 hr ÷ '
              'once daily or BID (20 mCg AM and 10 mCg PM).'),
          DoseLine('Adult: Start at 10 mCg once daily, may titrate up to 40 mCg/24 hr ÷ '
              'BID–TID.'),
          DoseLine('Converting from IV dosage form: Give 10 times the IV dose intranasally, '
              'rounding down to the nearest 10 mCg.'),
          DoseLine('Converting from PO dosage form: Intranasal dose is approximately 10- to '
              '40-fold more potent than oral dose.'),
          DoseLine(
            'IV/SC:',
            isHeading: true,
          ),
          DoseLine('<12 yr (limited data): 0.1–1 mCg/24 hr ÷ once daily–BID; start with lower '
              'dose and increase as needed.'),
          DoseLine('≥12 yr and adult: 2–4 mCg/24 hr ÷ BID'),
        ],
      ),
      DoseSection(
        heading: 'Hemophilia A and von Willebrand disease:',
        lines: [
          DoseLine('IV (≥3 mo, child, adolescent): 0.3 mCg/kg/dose (max. dose: 20 mCg/dose) '
              'over 15–30 min, administered 30 min before procedure'),
        ],
      ),
      DoseSection(
        heading: 'Nocturnal enuresis (≥6 yr; see remarks):',
        lines: [
          DoseLine('Oral: 0.2 mg at bedtime; if needed, titrate to achieve desired effect by '
              '0.2 mg Q3 days up to a max. dose of 0.6 mg/24 hr. Limit fluid intake to a '
              'minimum from 1 hr prior to desmopressin dosing until the next morning or '
              'at least 8 hr after dose administration.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in hypertension, patients at risk for water intoxication '
          'with hyponatremia, and coronary artery disease. May cause headache, '
          'nausea, seizures, blood pressure changes, hyponatremia, nasal congestion, '
          'abdominal cramps, and hypertension.',
      'Desmopressin is primarily excreted in the urine, and renal impairment may '
          'increase the elimination half-life (some consider use contraindicated '
          'when GFR is <50 mL/min).',
      'NOCTURNAL ENURESIS: Intranasal formulations are no longer indicated by '
          'the FDA for primary nocturnal enuresis (children are susceptible for '
          'severe hyponatremia and seizures) or in patients with a history of '
          'hyponatremia. Patients using tablets should reduce their fluid intake to '
          'prevent potential water intoxication and hyponatremia and have their '
          'therapy interrupted during acute illnesses that may lead to fluid and/or '
          'electrolyte imbalance.',
      'Injection may be used SC or IV at approximately 10% of intranasal dose. '
          'Adjust fluid intake to decrease risk of water intoxication and monitor '
          'serum sodium.',
      'If switching stabilized patient from intranasal route to IV/SC route, use '
          '10% of intranasal dose. Peak effects: 1–5 hr with intranasal route; 1.5–3 '
          'hr with IV route; and 2–7 hr with PO route.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 952–953',
  ),
  // DEXAMETHASONE — PDF p. 144–145 (printed 953–954)
  DrugEntryV3(
    name: 'DEXAMETHASONE',
    brandNames: 'Dexabliss, Dexamethasone Intensol, HiDex, TaperDex, Maxidex, and '
        'various generics; previously available as Decadron',
    drugClass: 'Corticosteroid',
    iconRow: '',
    formulations: [
      'Tabs: 0.5, 0.75, 1, 1.5, 2, 4, 6 mg',
      'Dexabliss: 1.5 mg [39 tabs (11 days)]',
      'HiDex: 1.5 mg [21 tabs (6 days)]',
      'TaperDex: 1.5 mg [21 tabs (6 days), 27 tabs (7 days), 49 tabs (12 days)]',
      'Generic: 1.5 mg [21 tabs (6 days), 35 tabs (10 days), 51 tabs (13 days)]',
      'Injection (sodium phosphate salt): 4 mg/mL (1, 5, 30 mL), 10 mg/mL (1, 10 '
          'mL); some preparations contain benzyl alcohol or methyl-/propylparabens',
      'Oral elixir: 0.5 mg/5 mL (237 mL); some preparations contain 5% alcohol',
      'Oral solution:',
      'Generics: 0.1 mg/mL; may contain EDTA, parabens, and propylene glycol',
      'Dexamethasone Intensol: 1 mg/mL; contains 30% alcohol',
      'Ophthalmic solution: 0.1% (5 mL); contains EDTA, benzalkonium chloride, '
          'and polysorbate 80',
      'Ophthalmic suspension (Maxidex): 0.1% (5 mL); contains EDTA, benzalkonium '
          'chloride, and polysorbate 80',
    ],
    doseSections: [
      DoseSection(
        heading: 'Airway edema/extubation:',
        lines: [
          DoseLine('Infant, child, and adolescent: 0.5 mg/kg/dose (max. dose: 10 mg/dose) '
              'IV/IM/PO Q6 hr × 6 doses, initiating therapy 6–12 hr prior to extubation'),
        ],
      ),
      DoseSection(
        heading: 'Asthma exacerbation:',
        lines: [
          DoseLine('Infant, child, and adolescent: 0.6 mg/kg/dose (max. dose: 16 mg/dose) '
              'PO/IV/IM Q24 hr × 1 or 2 doses; use beyond 2 days increases risk for '
              'metabolic adverse effects'),
        ],
      ),
      DoseSection(
        heading: 'Croup:',
        lines: [
          DoseLine('Infant and child: 0.6 mg/kg/dose PO/IV/IM ×1. Usual max. dose: 16 mg/dose'),
        ],
      ),
      DoseSection(
        heading: 'Antiemetic (chemotherapy induced):',
        lines: [
          DoseLine('Initial: 10 mg/m²/dose IV; max. dose: 20 mg'),
          DoseLine('Subsequent: 5 mg/m²/dose IV Q6 hr'),
        ],
      ),
      DoseSection(
        heading: 'Anti-inflammatory:',
        lines: [
          DoseLine('Child: 0.08–0.3 mg/kg/24 hr PO/IV/IM ÷ Q6–12 hr'),
          DoseLine('Adult: 0.75–9 mg/24 hr PO/IV/IM ÷ Q6–12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Cerebral edema (infant, child, and adolescent; limited data):',
        lines: [
          DoseLine('Loading dose: 1–2 mg/kg/dose IV/IM × 1'),
          DoseLine('Maintenance: 1–2 mg/kg/24 hr IV/IM ÷ Q4–6 hr; max. dose: 16 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Ophthalmic use (infant, child, and adult):',
        lines: [
          DoseLine('Solution: Instill 1–2 drops into the conjunctival sac(s) of the affected '
              'eye(s) Q1 hr during the day and Q2 hr during the night as initial '
              'therapy. When a favorable response is achieved, reduce dosage to Q3–4 hr. '
              'Further dose reduction to 1 drop TID–QID may be sufficient to control '
              'symptoms.'),
          DoseLine('Suspension: Shake well before using. For mild disease, instill 1–2 drops '
              'in the conjunctival sac(s) of the affected eye(s) up to 4–6 times/24 hr. '
              'For severe disease, drops may be used Q1 hr, being tapered to '
              'discontinuation as inflammation subsides. BID dosing has been effective '
              'in controlling inflammation in children ≤10 yr old after strabismus '
              'surgery.'),
        ],
      ),
    ],
    remarks: [
      'Not recommended for systemic therapy in the prevention or treatment of '
          'chronic lung disease in infants with very low birth weight because of '
          'increased risk for adverse events. Dexamethasone is a substrate of CYP '
          'P450 3A3/4 and P-glycoprotein, and a moderate inducer of CYP P450 3A4.',
      'Compared to prednisone, dexamethasone has no mineralocorticoid effects '
          'with greater glucocorticoid effects. Consider use of alternative low '
          'glucocorticoid systemic steroid for patients with hyperglycemia. '
          'Contraindicated in active untreated infections and fungal, viral, and '
          'mycobacterial ocular infections.',
      'Use in hospitalized COVID-19 patients with SpO2 ≤94% on room air have '
          'recommended 0.15-0.3 mg/kg/dose (max. dose: 6 mg/dose) IV/PO once daily '
          'for up to 10 days.',
      'Oral peak serum levels occur 1–2 hr and within 8 hr following IM '
          'administration. For other uses, doses based on body surface area, and '
          'dose equivalence to other steroids, see Chapter 10.',
      'OPHTHALMIC USE: Use ophthalmic preparation only in consultation with an '
          'ophthalmologist. Use with caution in corneal/scleral thinning and '
          'glaucoma. Consider the possibility of persistent fungal infections of the '
          'cornea after prolonged use. Ophthalmic solution/suspension may be used '
          'for otitis externa.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 953–954',
  ),
  // DEXMEDETOMIDINE — PDF p. 145–146 (printed 954–955)
  DrugEntryV3(
    name: 'DEXMEDETOMIDINE',
    brandNames: 'Precedex, Igalmi and generics',
    drugClass: 'α-Adrenergic agonist, sedative',
    iconRow: '',
    formulations: [
      'Injection (Precedex and generics): 200 mCg/2 mL (2 mL); preservative free',
      'Multidose injection: 400 mCg/4 mL (4 mL), 1000 mCg/10 mL (10 mL); '
          'contains methyl- and propylparabens',
      'Premixed injection in NS (Precedex and generics): 80 mCg/20 mL (20 mL), '
          '200 mCg/50 mL (50 mL), 400 mCg/100 mL (100 mL), 1000 mCg/250 mL (250 mL); '
          'preservative free',
      'Sublingual film:',
      'Igalmi: 120, 180 mCg (10s); contains FD&C Blue #1 colorant, peppermint '
          'oil, and polyethylene oxide',
    ],
    doseSections: [
      DoseSection(
        heading: 'NOTE: Maintenance infusion rate dosing metric is mCg/kg/hr.',
      ),
      DoseSection(
        heading: 'ICU sedation:',
        lines: [
          DoseLine('Child (limited data): 0.5–1 mCg/kg/dose IV × 1 over 10 min followed by '
              '0.2–1 mCg/kg/hr infusion titrated to effect. Dosages of 0.2–2.5 mCg/kg/hr '
              'have been reported. Infants may require higher dosages than neonates or '
              'older children.'),
          DoseLine('Adult: 1 mCg/kg/dose IV × 1 over 10 min, followed by 0.2–1 mCg/kg/hr '
              'infusion titrated to effect.'),
        ],
      ),
      DoseSection(
        heading: 'Procedural sedation:',
        lines: [
          DoseLine(
            'Child (limited data):',
            isHeading: true,
          ),
          DoseLine('IV: 2 mCg/kg/dose × 1 followed by 1.5 mCg/kg/hr was administered to '
              'children with autism/pervasive developmental disorders for sedation for '
              'electroencephalography (EEG).'),
          DoseLine('IM: 1–4.5 mCg/kg/dose × 1 was administered to children for sedation for '
              'EEG. Extremely anxious, inconsolable, aggressive, and noncompliant '
              'children received doses >2.5 mCg/kg, and calm and relatively compliant '
              'children received doses ≤2.5 mCg/kg. A second lower repeat dose (∼2 '
              'mCg/kg/dose) was administered when adequate sedation was not achieved '
              'after 10 min of the first dose.'),
          DoseLine('Intranasal route (limited data): 1–2 mCg/kg/dose × 1 for premedication '
              '30–60 min prior to anesthesia induction'),
          DoseLine('Adult: 0.5–1 mCg/kg/dose IV × 1 over 10 min, followed by 0.6 mCg/kg/hr '
              'titrated to effect; dosage has ranged from 0.2–1 mCg/kg/hr.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution with other vasodilating or negative chronotropic agents '
          '(additive pharmacodynamic effects), hepatic impairment (decrease drug '
          'clearance; consider dose reduction), advanced heart block, hypovolemia, '
          'diabetes mellitus, chronic hypertension, and severe ventricular '
          'dysfunction. Prolonged use >24 hr may be associated with tolerance and '
          'tachyphylaxis and dose-related side effects (ARDS, respiratory failure, '
          'and agitation). Withdrawal symptoms within 24 hr after discontinuing '
          'dexmedetomidine have been reported in ∼5% of adults receiving the '
          'medication up to 7 days, regardless of dosage; no withdrawal symptoms '
          'were seen in adults after discontinuing therapy lasting <6 hr in '
          'duration. In children, mild transient withdrawal symptoms of delirium or '
          'agitation have been seen after discontinuation of short-term infusions of '
          '<2 hr.',
      'Hypotension and bradycardia are common side effects; may be more '
          'pronounced in hypovolemia, diabetes, or chronic hypertension. Transient '
          'hypertension has been observed during loading doses. Q–T prolongation, '
          'hypernatremia, sinus arrest, and polyuria have been reported. Do not '
          'abruptly withdraw therapy, as withdrawal symptoms (nausea, vomiting, and '
          'agitation) are possible; taper the dose when discontinuing use. May cause '
          'hyperthermia or pyrexia, which may be resistant to administration of '
          'cooled IV fluids and antipyretics; may require discontinuing '
          'dexmedetomidine.',
      'Use with anesthetics, sedatives, hypnotics, and opioids may lead to '
          'enhanced effects; consider dosage reduction of dexmedetomidine. '
          'Dexmedetomidine is a cytochrome P-450 (CYP) 2A6 substrate and a weak '
          'inhibitor of CYP1A2, 2C9, and 3A4.',
      'Onset of action for procedural sedation: IV or IM: 15 min; intranasal: '
          '15–30 min. Duration of action for procedural sedation: IM: 1 hr; '
          'intranasal: 1–1.5 hr',
      'This drug should be administered by individuals skilled in the management '
          'of patients in the ICU and OR. Concentrated IV solution (100 mCg/1 mL) '
          'must be diluted with NS to a concentration of 4 mCg/mL prior to '
          'administration. See Chapter 6 for additional information. The sublingual '
          'film dosage form is currently approved as an alternative agent for adults '
          'with agitation associated with schizophrenia or bipolar I or II disorder.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 954–955',
  ),
  // DEXMETHYLPHENIDATE — PDF p. 146–147 (printed 955–956)
  DrugEntryV3(
    name: 'DEXMETHYLPHENIDATE',
    brandNames: 'Focalin, Focalin XR, and generics',
    drugClass: 'CNS stimulant',
    iconRow: '',
    formulations: [
      'Tab, immediate release (Focalin and generics): 2.5, 5, 10 mg',
      'Extended-release caps (Focalin XR and generics): 5, 10, 15, 20, 25, 30, '
          '35, 40 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Attention deficit/hyperactivity disorder:',
      ),
      DoseSection(
        heading: 'Methylphenidate NaÏve',
        table: DoseTable(
          headers: ['Age/Dosage Form', 'Initial Dose', 'Dosage Increase at Weekly Intervals, if Needed', 'Daily Maximum Dose'],
          rows: [
            DoseTableRow(['≥6 YR AND ADOLESCENT', '', '', '']),
            DoseTableRow(['Immediate-release tabsᵃ', '2.5 mg PO BID', '2.5–5 mg/24 hr', '20 mg/24 hr (10 mg BID); some may require and be able to tolerate up to '
                '50 mg/24 hr']),
            DoseTableRow(['Extended-release capsᵇ', '5 mg PO once daily', '5 mg/24 hr', '30 mg/24 hr; some may require and be able to tolerate up to 50 mg/24 hr']),
            DoseTableRow(['ADULT', '', '', '']),
            DoseTableRow(['Immediate-release tabsᵃ', '2.5 mg PO BID', '2.5–5 mg/24 hr', '20 mg/24 hr (10 mg BID)']),
            DoseTableRow(['Extended-release capsᵇ', '10 mg PO once daily', '10 mg/24 hr', '40 mg/24 hr']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃBID dosing (at least 4 hr apart).'),
          DoseLine('ᵇOnce-daily dosing.'),
        ],
      ),
      DoseSection(
        heading: 'CONVERTING FROM METHYLPHENIDATE:',
      ),
      DoseSection(
        heading: '≥6 yr and adult:',
        lines: [
          DoseLine('Start at 50% of the total daily dose of racemic methylphenidate with the '
              'following max. doses:'),
          DoseLine('Immediate-release tabs (BID dosing): 20 mg/24 hr; some may require and be '
              'able to tolerate 50 mg/24 hr'),
          DoseLine(
            'Extended-release caps (once daily dosing):',
            isHeading: true,
          ),
          DoseLine('≥6 yr–adolescent: 30 mg/24 hr; some may require and be able to tolerate '
              '50 mg/24 hr'),
          DoseLine('Adult: 40 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'CONVERTING FROM IMMEDIATE-RELEASE TABS (BID) TO EXTENDED-RELEASE CAPS '
            '(ONCE DAILY) DEXMETHYLPHENIDATE:',
        lines: [
          DoseLine('Use the equivalent mg dosage amount'),
        ],
      ),
    ],
    remarks: [
      'Dexmethylphenidate is the d-enantiomer of methylphenidate and accounts '
          'for the majority of clinical effects for methylphenidate. Contraindicated '
          'in glaucoma, anxiety disorders, motor tics, and Tourette syndrome. Do not '
          'use with monoamine oxidase (MAO) inhibitor; hypertensive crisis may occur '
          'if used within 14 days of discontinuance of MAO inhibitor. When used in '
          'combination with risperidone, any dosage change to either medication may '
          'increase the risk for extrapyramidal symptoms. See Methylphenidate for '
          'additional warnings and drug interactions.',
      'Common side effects include abdominal pain, indigestion, appetite '
          'suppression, nausea, headache, insomnia, and anxiety. Peripheral '
          'vasculopathy, including Raynaud phenomenon, and priapism have been '
          'reported. Monitor for long-term growth suppression in children and assess '
          'for risk of abuse and dependence prior to prescribing.',
      'Immediate-release tablets are dosed BID (minimum 4 hr between doses), and '
          'extended-release capsules are dosed once daily. Contents of the '
          'extended-release capsule may be sprinkled on a spoonful of applesauce and '
          'consumed immediately for those who are unable to swallow capsules.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 955–956',
  ),
  // DEXTROAMPHETAMINE ± AMPHETAMINE — PDF p. 148–150 (printed 957–959)
  DrugEntryV3(
    name: 'DEXTROAMPHETAMINE ± AMPHETAMINE',
    brandNames: 'Dexedrine, ProCentra, Zenzedi, Xelstrym, and many generics\nIn '
        'combination with amphetamine: Adderall, Adderall XR, Mydayis, and '
        'generics',
    drugClass: 'CNS stimulant, amphetamine',
    iconRow: '',
    formulations: [
      'Tabs, immediate release:',
      'Zenzedi and generics: 2.5, 5, 7.5, 10, 15, 20, 30 mg',
      'Sustained-release caps:',
      'Generics: 5, 10, 15 mg',
      'Dexedrine: 10 mg',
      'Oral solution (ProCentra and generics): 1 mg/mL (473 mL); may contain '
          'benzoic acid and saccharin',
      'Transdermal patch (Xelstrym): 4.5 mg/9 hr (4.76 cm² patch), 9 mg/9 hr '
          '(9.52 cm² patch), 13.5 mg/9 hr (14.29 cm² patch), and 18 mg/9 hr (19.02 '
          'cm² patch) (30s)',
      'In combination with amphetamine (Adderall): Available as 1:1:1:1 mixture '
          'of dextroamphetamine sulfate, dextroamphetamine saccharate, amphetamine '
          'aspartate, and amphetamine sulfate salts (e.g., 5-mg tablet contains 1.25 '
          'mg dextroamphetamine sulfate, 1.25 mg dextroamphetamine saccharate, 1.25 '
          'mg amphetamine aspartate, and 1.25 mg amphetamine sulfate; 5 mg of the '
          'mixture is equivalent to 3.1 mg amphetamine base):',
      'Tabs (Adderall and generics): 5, 7.5, 10, 12.5, 15, 20, 30 mg',
      'Caps, extended release:',
      'Adderal XR: 5, 10, 15, 20, 25, 30 mg',
      'Mydayis: 12.5, 25, 37.5, 50 mg',
      'Generics: 5, 10, 12.5, 15, 20, 25, 30, 37.5, 50 mg',
      'Oral suspension: 1 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Dosages are in terms of mg of dextroamphetamine when using '
            'dextroamphetamine alone OR in terms of mg of the total '
            'dextroamphetamine and amphetamine salts (e.g., Adderall, Mydayis, or '
            'generic equivalent).',
      ),
      DoseSection(
        heading: 'Attention Deficit/Hyperactivity Disorder (PO)',
        table: DoseTable(
          headers: ['', 'Dextroamphetamine', 'Dextroamphetamine + Amphetamine'],
          rows: [
            DoseTableRow(['Immediate-release dosage formsᵃ', 'Zenzedi and generics', 'Adderall and generics']),
            DoseTableRow(['3–5 yr', 'Start at 2.5 mg QAM; increase by 2.5 mg/24 hr at weekly intervals PRN to '
                'a max. dose of 40 mg/24 hr ÷ BID–TID (first dose in the morning)', 'Start at 2.5 mg QAM; increase by 2.5 mg/24 hr at weekly intervals PRN to '
                'a max. dose of 40 mg/24 hr ÷ QAM–TID (first dose in the morning)']),
            DoseTableRow(['6–17 yr', 'Start at 5 mg QAM or BID (first dose in the morning); increase by 5 mg/24 '
                'hr at weekly intervals PRN to a max. dose of 40 mg/24 hr ÷ BID–TID (first '
                'dose in the morning)', 'Start at 5 mg QAM or BID (first dose in the morning); increase by 5 mg/24 '
                'hr at weekly intervals PRN to a max. dose of 40 mg/24 hr ÷ QAM–TID (first '
                'dose in the morning). Max. dose of 60 mg/24 hr has been used in patients '
                '>50 kg.']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃ Usually given PO BID–TID; first dose upon awakening and subsequent '
              'doses at intervals of 4–6 hr later.'),
        ],
        table: DoseTable(
          headers: ['', 'Dextroamphetamine', 'Dextroamphetamine + Amphetamine'],
          rows: [
            DoseTableRow(['Extended/sustained-release dosage formsᵇ', 'Dexedrine and generics', 'Adderall XR and generics']),
            DoseTableRow(['6–12 yr', 'Start at 5 mg QAM or BID (first dose in the morning); increase by 5 mg/24 '
                'hr at weekly intervals PRN to a max. dose of 40 mg/24 hr ÷ QAM or BID '
                '(first dose in the morning). Max. dose of 60 mg/24 hr has been used in '
                'patients >50 kg.', 'Start at 5 or 10 mg QAM; increase by 5 or 10 mg/24 hr at weekly intervals '
                'PRN to a max. dose of 30 mg/24 hr. Max. dose of 60 mg/24 hr has been used '
                'in patients >50 kg.']),
            DoseTableRow(['13–17 yr', 'Similar dosing as 6–12 yr (see above)', 'Start at 10 mg QAM; if needed after 1 week, may increase to 20 mg QAM. '
                'Max. dose: 20 mg/24 hr. Max. dose of 60 mg/24 hr has been used in '
                'patients >50 kg.']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵇ Usually given PO once daily, sometimes BID (6–8 hr between doses).'),
          DoseLine(
            'Mydayis (extended-release capsules):',
            isHeading: true,
          ),
          DoseLine('13–17 yr: Start at 12.5 mg PO QAM; increase by 12.5 mg/24 hr PRN at '
              'weekly intervals to a max. dose of 25 mg/24 hr QAM.'),
          DoseLine('Adult: Start at 12.5 mg PO QAM; increase by 12.5 mg/24 hr PRN at weekly '
              'intervals to a max. dose of 50 mg/24 hr QAM.'),
          DoseLine('Transdermal patch (Xelstrym; see remarks): Apply to the hip, upper arm, '
              'chest, upper back, or flank 2 hr before the effect is desired and remove '
              'within 9 hr. Patch may be removed before 9 hr if shorter duration of '
              'effect is desired.'),
          DoseLine('6–17 yr: Start with 4.5 mg/9 hr patch. Dose may be adjusted in weekly '
              'increments of 4.5 mg up to a maximum of 18 mg/9 hr.'),
          DoseLine('Adult: Start with 9 mg/9 hr patch. Maximum dose: 18 mg/9 hr'),
        ],
      ),
      DoseSection(
        heading: 'Narcolepsy (divide daily dosage once daily–TID for immediate-release '
            'dosage form and once daily–BID for extended-release dosage form; PO):',
        lines: [
          DoseLine('6–12 yr: 5 mg/24 hr ÷ once daily–TID; increase by 5 mg/24 hr at weekly '
              'intervals to a max. dose of 60 mg/24 hr'),
          DoseLine('>12 yr and adult: 10 mg/24 hr ÷ once daily–TID; increase by 10 mg/24 hr '
              'at weekly intervals to a max. dose of 60 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in presence of hypertension, cardiovascular disease, and '
          'renal or hepatic impairment (drug elimination may be decreased). Avoid '
          'use in known serious structural cardiac abnormalities, cardiomyopathy, '
          'serious heart rhythm abnormalities, coronary artery disease, or other '
          'serious cardiac problems that may increase risk of sympathomimetic '
          'effects of amphetamines (sudden death, stroke, and MI have been '
          'reported). Do not give with MAO inhibitors (also within 14 days of '
          'discontinuance) or general anesthetics. Use with proton pump inhibitors '
          '(PPIs) may reduce the effectiveness of either dextroamphetamine or the '
          'combination with amphetamine.',
      'DEXTROAMPHETAMINE AND AMPHETAMINE: Serotonin syndrome may occur when used '
          'with serotonergic neurotransmitter medications such as MAO inhibitors, '
          'SSRIs, serotonin and norepinephrine reuptake inhibitors (SNRIs), '
          'triptans, and TCAs. Cytochrome P-450 2D6 inhibitors may increase the '
          'effects/toxicity of the combination medication.',
      'Not recommended for children <3 yr. Medication should generally not be '
          'used in children <5 yr old, as diagnosis of attention deficit and '
          'hyperactivity disorder (ADHD) in this age group is extremely difficult '
          '(use in consultation with a specialist). Interrupt administration '
          'occasionally to determine need for continued therapy. Many side effects, '
          'including insomnia (avoid dose administration within 6 hr of bedtime), '
          'restlessness/irritability, anorexia, psychosis, visual disturbances, '
          'headache, vomiting, abdominal cramps, dry mouth, and growth failure. '
          'Paranoia, mania, peripheral vasculopathy (including Raynaud phenomenon), '
          'priapism, bruxism, intestinal ischemia, worsening of Tourette syndrome, '
          'and auditory hallucination have been reported. Assess for risk of abuse '
          'and dependence prior to prescribing. Tolerance develops. Same guidelines '
          'as for methylphenidate apply. See Amphetamine for amphetamine-containing '
          'products.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 957–959',
  ),
  // DIAZEPAM — PDF p. 150–152 (printed 959–961)
  DrugEntryV3(
    name: 'DIAZEPAM',
    brandNames: 'Valium, Libervant, Valtoco, and generics; previously available as '
        'Diastat',
    drugClass: 'Benzodiazepine; anxiolytic, anticonvulsant',
    iconRow: '',
    formulations: [
      'Tabs: 2, 5, 10 mg',
      'Oral solution: 1 mg/mL, 5 mg/mL; contains 19% alcohol',
      'Oral buccal film:',
      'Libervant: 5, 10, 12.5, 15 mg (1s, 2s); contains EDTA',
      'Injection: 5 mg/mL (2, 10 mL); contains 40% propylene glycol, 10% '
          'alcohol, 5% sodium benzoate, and 1.5% benzyl alcohol',
      'Rectal gel:',
      'Generics; previously available as Pediatric Diastat: 2.5 mg (5 mg/mL '
          'concentration with 4.4-cm rectal tip delivery system; contains 10% '
          'alcohol, 1.5% benzyl alcohol, sodium benzoate, and propylene glycol); in '
          'twin packs',
      'Generics; previously available as Diastat AcuDial:',
      '4.4-cm rectal tip delivery system (pediatric/adult): 10 mg (5 mg/mL, '
          'delivers set doses of either 5, 7.5, or 10 mg); contains 10% alcohol, '
          '1.5% benzyl alcohol, sodium benzoate, and propylene glycol; in twin packs',
      '6-cm rectal tip delivery system (adult): 20 mg (5 mg/mL, delivers set '
          'doses of either 12.5, 15, 17.5, 20 mg); contains 10% alcohol, 1.5% benzyl '
          'alcohol, sodium benzoate, and propylene glycol; in twin packs',
      'Nasal spray:',
      'Valtoco: 5 mg/0.1 mL, 7.5 mg/0.1 mL, 10 mg/0.1 mL (in 2 individual '
          'blister packs with one nasal spray device in each blister pack); contains '
          'alcohol and benzyl alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Sedative/muscle relaxant:',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('IM or IV: 0.05–0.2 mg/kg/dose Q6–12 hr; max. dose: 0.6 mg/kg within an '
              '8-hr period'),
          DoseLine('PO: 0.12–0.8 mg/kg/24 hr ÷ Q6–12 hr; max. dose: 10 mg/dose'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('IM or IV: 5–10 mg/dose Q3–4 hr PRN'),
          DoseLine('PO: 2–10 mg/dose Q6–8 hr PRN'),
        ],
      ),
      DoseSection(
        heading: 'Status epilepticus:',
        lines: [
          DoseLine('Neonate (use only after failed therapy with other agents; note the '
              'excipients of the IV dosage forms): 0.1–0.3 mg/kg/dose IV Q15–30 min × '
              '2–3 doses up to max. total dose of 2 mg'),
          DoseLine('Child >1 mo–<5 yr: 0.2–0.5 mg/dose IV Q2–5 min up to max. total dose of 5 '
              'mg. May repeat dosing in 2–4 hr as needed.'),
          DoseLine('Child ≥5 yr: 1 mg/dose IV Q2–5 min up to max. total dose of 10 mg. May '
              'repeat dosing in 2–4 hr as needed.'),
          DoseLine('Adult: 5–10 mg/dose IV Q10–15 min; max. total dose: 30 mg in an 8-hr '
              'period. May repeat dosing in 2–4 hr as needed.'),
        ],
      ),
      DoseSection(
        heading: 'Acute seizures:',
        lines: [
          DoseLine('Buccal film (Libervant): Administer one dose per patient age/weight '
              'below. If needed, a second dose may be administered 4 hr after the first '
              'dose. Do not exceed 2 doses in 24 hr. Do not repeat dose if patient '
              'experiences difficulty in breathing or excessive sedation. Do not use '
              'more than once every 5 days and no more than 5 times per month.'),
          DoseLine('Child 2–5 yr:'),
          DoseLine('6–<11 kg: 5 mg'),
          DoseLine('11–<16 kg: 7.5 mg'),
          DoseLine('16–<21 kg: 10 mg'),
          DoseLine('21–<26 kg: 12.5 mg'),
          DoseLine('26–30 kg: 15 mg'),
          DoseLine('Nasal spray: Administer one dose using the dosing table below. If needed, '
              'a second dose may be administered 4 hr after the first dose. Max. dose: 2 '
              'doses per single seizure episode. Do not use more than once every 5 days '
              'and no more than 5 times per month.'),
        ],
      ),
      DoseSection(
        heading: 'Nasal Spray Dosing for Acute Seizures: Child >6 yr and Adult',
        table: DoseTable(
          headers: ['Dose Based on Age and Weight', '', 'Administration', '', ''],
          rows: [
            DoseTableRow(['6–11 yr (0.3 mg/kg/dose) Weight (kg)', '≥12 yr (0.2 mg/kg/dose) Weight (kg)', 'Dose (mg)', 'Number of Nasal Spray Devices', 'Number of Sprays']),
            DoseTableRow(['10–18', '14–27', '5', 'One 5-mg device', 'One spray in only one nostril']),
            DoseTableRow(['19–37', '28–50', '10', 'One 10-mg device', 'One spray in only one nostril']),
            DoseTableRow(['38–55', '51–75', '15', 'Two 7.5-mg devices', 'One spray in each nostril']),
            DoseTableRow(['56–74', '≥76', '20', 'Two 10-mg devices', 'One spray in each nostril']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('Rectal dose (using IV dosage form): 0.5 mg/kg/dose followed by 0.25 '
              'mg/kg/dose in 10 min PRN; max. dose: 20 mg/dose'),
          DoseLine('Rectal gel: All doses rounded up to the nearest 2.5 mg increment; repeat '
              'dose in 4–12 hr PRN. Do not use more than once every 5 days and no more '
              'than 5 times per month.'),
          DoseLine('2–5 yr: 0.5 mg/kg/dose'),
          DoseLine('6–11 yr: 0.3 mg/kg/dose'),
          DoseLine('≥12 yr and adult: 0.2 mg/kg/dose'),
          DoseLine('Max. dose (all ages): 20 mg/dose'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in myasthenia gravis, severe respiratory insufficiency, '
          'severe hepatic failure, and sleep apnea syndrome. Hypotension and '
          'respiratory depression may occur. Use with caution in hepatic and renal '
          'dysfunction, glaucoma, shock, and depression. Do not use in combination '
          'with protease inhibitors. Concurrent use with CNS depressants, '
          'cimetidine, erythromycin, itraconazole, and valproic acid may enhance the '
          'effects of diazepam. Use with opioids may result in profound sedation, '
          'respiratory depression, coma, and mortality. Diazepam is a substrate for '
          'cytochrome P-450 (CYP) 2B6, 2C8, 2C9, and 3A5-3A7, and minor substrate '
          'and inhibitor for CYP2C19 and 3A3/3A4. The active desmethyldiazepam '
          'metabolite is a CYP2C19 substrate.',
      'Nasal discomfort, dysgeusia, and epistaxis may occur with the intranasal '
          'route of administration. Ataxia, headache, dizziness, sedation, and rash '
          'have been reported with use of the the rectal gel.',
      'Administer the conventional IV product undiluted no faster than 2 mg/min '
          'and do not mix with IV fluids. Do not test or prime the nasal spray '
          'dosage form as each device sprays one time only. Do not administer '
          'liquids with the buccal film dosage form.',
      'In status epilepticus, diazepam must be followed by long-acting '
          'anticonvulsants. Onset of anticonvulsant effect: 1–3 min with IV route; '
          '2–10 min with rectal route; and <5 min with intranasal route. For '
          'management of status epilepticus, see Chapter 1.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 959–961',
  ),
  // DIAZOXIDE — PDF p. 152 (printed 961)
  DrugEntryV3(
    name: 'DIAZOXIDE',
    brandNames: 'Proglycem and generics',
    drugClass: 'Antihypoglycemic agent',
    iconRow: '',
    formulations: [
      'Oral suspension: 50 mg/mL (30 mL); contains approximately 7.25% alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hyperinsulinemic hypoglycemia (due to insulin-producing tumors; start '
            'at the lowest dose; see remarks):',
        lines: [
          DoseLine('Newborn and infant: Start at 5 mg/kg/24 hr PO ÷ Q8–12 hr and gradually '
              'titrate (2.5–5 mg/kg/24 hr every 5 days) if needed; usual range of 5–15 '
              'mg/kg/24 hr with reported range of 5–20 mg/kg/24 hr ÷ Q8–12 hr'),
          DoseLine('Child and adolescent: Start at 5 mg/kg/24 hr PO ÷ 8-12 hr and gradually '
              'titrate if needed; usual range: 3–15 mg/kg/24 hr PO ÷ Q8–12 hr'),
        ],
      ),
    ],
    remarks: [
      'Hypoglycemia should be treated initially with IV glucose; diazoxide '
          'should be introduced only if patient is refractory to glucose infusion. '
          'Should not be used in patients hypersensitive to thiazides unless benefit '
          'outweighs risk. Thiazides may enhance diazoxide’s hyperglycemic effects. '
          'Use with caution in renal impairment (clearance of drug is reduced); '
          'consider dosage reduction.',
      'Sodium and fluid retention is common in young infants and adults and may '
          'precipitate congestive heart failure (CHF) in patients with compromised '
          'cardiac reserve (usually responsive to diuretics). Hirsutism '
          '(reversible), GI disturbances, transient loss of taste, tachycardia, '
          'ketoacidosis, palpitations, rash, headache, weakness, and hyperuricemia '
          'may occur. Pulmonary hypertension in newborns/infants treated for '
          'hypoglycemia (especially at doses ≥10 mg/kg/24 hr) has been reported, and '
          'resolution/improvement of the condition was achieved after discontinuing '
          'diazoxide. Monitor BP closely for hypotension. Diazoxide binds to '
          'albumin, which may displace bilirubin and increase the effects of '
          'warfarin.',
      'Hyperglycemic effect with PO administration occurs within 1 hr with a '
          'duration of 8 hr.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 961',
  ),
  // DIGOXIN — PDF p. 153–154 (printed 962–963)
  DrugEntryV3(
    name: 'DIGOXIN',
    brandNames: 'Lanoxin, Lanoxin Pediatric, and generics',
    drugClass: 'Antiarrhythmic agent, inotrope',
    iconRow: '',
    formulations: [
      'Tabs:',
      'Lanoxin and generics: 62.5, 125, 250 mCg',
      'Oral solution: 50 mCg/mL (60 mL); may contain 10% alcohol',
      'Injection:',
      'Lanoxin Pediatric: 100 mCg/mL (1 mL); may contain propylene glycol and '
          'alcohol',
      'Lanoxin and generics: 250 mCg/mL (2 mL); may contain propylene glycol and '
          'alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Digitalizing:',
        lines: [
          DoseLine('Total digitalizing dose (TDD) and maintenance doses in mCg/kg/24 hr (see '
              'the following table):'),
        ],
      ),
      DoseSection(
        heading: 'Digoxin Digitalizing and Maintenance Doses',
        table: DoseTable(
          headers: ['', 'TDD', '', 'Daily Maintenance', ''],
          rows: [
            DoseTableRow(['Age', 'PO', 'IV/IMᵃ', 'PO', 'IV/IMᵃ']),
            DoseTableRow(['Premature neonate', '20', '15', '5', '3–4']),
            DoseTableRow(['Full-term neonate', '30', '20', '8–10', '6–8']),
            DoseTableRow(['1 mo–<2 yr', '40–50', '30–40', '10–12', '7.5–9']),
            DoseTableRow(['2–10 yr', '30–40', '20–30', '8–10', '6–8']),
            DoseTableRow(['>10 yr and <100 kg', '10–15', '8–12', '2.5–5', '2–3']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('TDD, Total digitalizing dose.'),
          DoseLine('ᵃ IV route preferred over IM due to local irritation, pain, and tissue '
              'damage with IM route.'),
        ],
      ),
      DoseSection(
        heading: 'Initial:',
        lines: [
          DoseLine('½ TDD, then ¼ TDD Q6–8 hr × 2 doses; obtain electrocardiogram (ECG) 6 hr '
              'after dose to assess for toxicity'),
        ],
      ),
      DoseSection(
        heading: 'Maintenance:',
        lines: [
          DoseLine('<10 yr: Give maintenance dose ÷ BID'),
          DoseLine('≥10 yr: Give maintenance dose once daily'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in patients with ventricular dysrhythmias. Use should be '
          'avoided in patients with preserved left ventricular systolic function. '
          'Use with caution in renal failure, with calcium channel blockers (may '
          'result in heart block), and with adenosine (enhanced depressant effects '
          'on sinoatrial [SA] and atrioventricular [AV] nodes). May cause AV block '
          'or dysrhythmias. In patients treated with digoxin, cardioversion, or '
          'calcium infusion, may lead to ventricular fibrillation (pretreatment with '
          'lidocaine may prevent this). Patients with beriberi heart disease may not '
          'respond to digoxin if underlying thiamine deficiency is not treated '
          'concomitantly. Decreased serum potassium and magnesium, or increased '
          'magnesium and calcium, may increase risk for digoxin toxicity. For signs '
          'and symptoms of toxicity, see Chapter 3.',
      'Excreted via the kidney; adjust dose in renal failure (see Chapter 32). '
          'Therapeutic concentration: 0.8–2 ng/mL. Higher doses may be required for '
          'supraventricular tachycardia. Neonates, pregnant women, and patients with '
          'renal, hepatic, or heart failure may have falsely elevated digoxin levels '
          'due to the presence of digoxin-like substances.',
      'Digoxin is a cytochrome P-450 3A4 and P-glycoprotein substrate. Calcium '
          'channel blockers, captopril, carvedilol, amiodarone, quinidine, '
          'cyclosporine, itraconazole, tetracycline, and macrolide antibiotics may '
          'increase digoxin levels. Use with β-blockers and ivabradine may increase '
          'risk for bradycardia. Succinylcholine may cause arrhythmias in '
          'digitalized patients.',
      'T₁/₂: Premature infants, 61–170 hr; full-term neonates, 35–45 hr; '
          'infants, 18–25 hr; and children, 35 hr.',
      'Recommended serum sampling at steady state: Obtain a single level from 6 '
          'hr postdose to just before the next scheduled dose following 5–8 days of '
          'continuous dosing. Levels obtained prior to steady state may be useful in '
          'preventing toxicity.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 962–963',
  ),
  // DIGOXIN IMMUNE FAB (OVINE) — PDF p. 154 (printed 963)
  DrugEntryV3(
    name: 'DIGOXIN IMMUNE FAB (OVINE)',
    brandNames: 'DigiFab',
    drugClass: 'Antidigoxin antibody',
    iconRow: '',
    formulations: [
      'Injection: 40 mg; derived from the blood of healthy sheep immunized with '
          'digoxin derivative',
    ],
    doseSections: [
      DoseSection(
        heading: 'Dosing based on known amounts of digoxin acutely ingested:',
        lines: [
          DoseLine(
            'First, determine total body digoxin load (TBL):',
            isHeading: true,
          ),
          DoseLine('TBL (mg) = mg digoxin ingested × 0.8'),
          DoseLine(
            'Then calculate digoxin immune Fab dose:',
            isHeading: true,
          ),
          DoseLine('Dose in number of digoxin immune Fab vials (DigiFab): # of vials = TBL ÷ '
              '0.5'),
        ],
      ),
      DoseSection(
        heading: 'Dosing based on steady-state serum digoxin levels:',
        lines: [
          DoseLine('DigiFab dose (mg) from steady-state digoxin levels'),
        ],
        table: DoseTable(
          headers: ['', 'Serum Digoxin Concentration (ng/mL)', '', '', '', '', '', ''],
          rows: [
            DoseTableRow(['Patient Weight (kg)', '1', '2', '4', '8', '12', '16', '20']),
            DoseTableRow(['1', '0.4 mgᵃ', '1 mgᵃ', '1.5 mgᵃ', '3 mgᵃ', '5 mg', '6.5 mg', '8 mg']),
            DoseTableRow(['3', '1 mgᵃ', '2.5 mgᵃ', '5 mg', '10 mg', '14 mg', '19 mg', '24 mg']),
            DoseTableRow(['5', '2 mgᵃ', '4 mg', '8 mg', '16 mg', '24 mg', '32 mg', '40 mg']),
            DoseTableRow(['10', '4 mg', '8 mg', '16 mg', '32 mg', '48 mg', '64 mg', '80 mg']),
            DoseTableRow(['20', '8 mg', '16 mg', '32 mg', '64 mg', '96 mg', '128 mg', '160 mg']),
            DoseTableRow(['40', '20 mg', '40 mg', '80 mg', '120 mg', '200 mg', '280 mg', '320 mg']),
            DoseTableRow(['60', '20 mg', '40 mg', '120 mg', '200 mg', '280 mg', '400 mg', '480 mg']),
            DoseTableRow(['70', '40 mg', '80 mg', '120 mg', '240 mg', '360 mg', '440 mg', '560 mg']),
            DoseTableRow(['80', '40 mg', '80 mg', '120 mg', '280 mg', '400 mg', '520 mg', '640 mg']),
            DoseTableRow(['100', '40 mg', '80 mg', '160 mg', '320 mg', '480 mg', '640 mg', '800 mg']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃUse 1 mg/mL DigiFab concentration for dose accuracy.'),
        ],
      ),
      DoseSection(
        heading: 'Dosage administration:',
        lines: [
          DoseLine('Reconstitute each vial with 4 mL NS for a 10 mg/mL concentration and '
              'infuse IV dose over 30 min. If an infusion rate reaction occurs, stop '
              'infusion and restart at a slower rate. In situations of cardiac arrest, '
              'DigiFab can be administered as a bolus injection, but expect an increased '
              'risk for infusion-related reactions. For smaller doses, vials may be '
              'reconstituted with 36 mL NS for a 1 mg/mL concentration.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated if hypersensitive to sheep products. Use with caution in '
          'renal or cardiac failure. May cause rapidly developing severe '
          'hypokalemia, decreased cardiac output (from withdrawal of digoxin’s '
          'inotropic effects), rash, edema, and phlebitis. Digoxin therapy may be '
          'reinstituted in 3–7 days, when toxicity has been corrected. Digoxin '
          'immune Fab will interfere with digitalis immunoassay measurements to '
          'result in misleading concentrations.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 963',
  ),
  // DILTIAZEM — PDF p. 155 (printed 964)
  DrugEntryV3(
    name: 'DILTIAZEM',
    brandNames: 'Cardizem, Cardizem CD, Cardizem LA, Cartia XT, Dilt-XR, Matzim LA, '
        'Tiadylt ER, Tiazac, and many others including generics',
    drugClass: 'Calcium channel blocker, antihypertensive',
    iconRow: '',
    formulations: [
      'Tabs:',
      'Generics: 30, 60, 90, 120 mg',
      'Cardizem: 30, 60 120 mg',
      'Extended-release tabs (for Q24 hr dosing):',
      'Cardizem LA and generics: 120, 180, 240, 300, 360, 420 mg',
      'Matzim LA: 180, 240, 300, 360, 420 mg',
      'Extended-release caps (for Q12 hr dosing):',
      'Generics: 60, 90, 120 mg',
      'Extended-release caps (for Q24 hr dosing):',
      'Tiazac and generics: 120, 180, 240, 300, 360, 420 mg',
      'Cardizem CD: 120, 180, 240, 300, 360 mg',
      'Cartia XT: 120, 180, 240, 300 mg',
      'Dilt-XR: 120, 180, 240 mg',
      'Tiadylt ER: 120, 180, 240, 360, 420 mg',
      'Oral liquid: 12 mg/mL',
      'Injection: 5 mg/mL (5, 10, 25 mL); some preparations may be preservative '
          'free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hypertension:',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('Immediate release: 1.5―2 mg/kg/24 hr PO ÷ TID―QID; max. dose: 3.5 '
              'mg/kg/24 hr; alternative max. dose of 6 mg/kg/24 hr up to 360 mg/24 hr '
              'has been recommended'),
          DoseLine(
            'Adolescent and adult:',
            isHeading: true,
          ),
          DoseLine('Immediate release: 30–120 mg/dose PO TID–QID; usual range 180–360 mg/24 hr'),
          DoseLine('Extended release: 120–360 mg/24 hr PO once daily–BID (BID dosing with Q12 '
              'hr extended-release generic capsule; once-daily dosing with '
              'extended-release tab, Cardizem CD, Cartia XT, Cardizem LA, Dilt-XR, '
              'Matzim LA, Tiadylt ER, Tiazac, and Q24 hr generic extended-release '
              'capsule or tab); max. dose: 540 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in acute myocardial infarction (MI) with pulmonary '
          'congestion, second- or third-degree heart block, and sick sinus syndrome. '
          'Use with caution in CHF or renal and hepatic impairment. Dizziness, '
          'headache, edema, nausea, vomiting, heart block, and arrhythmias may '
          'occur. Acute hepatic injury and severe skin reactions have been reported. '
          'Monitor heart rate with concurrent clonidine use (sinus bradycardia has '
          'been reported).',
      'Diltiazem is a substrate and inhibitor of the cytochrome P-450 3A4 enzyme '
          'system. May increase levels and effects/toxicity of buspirone, '
          'cyclosporine, carbamazepine, fentanyl, digoxin, ivabradine, quinidine, '
          'tacrolimus, benzodiazepines, and β-blockers. Cimetidine and statins may '
          'increase diltiazem serum levels. Rifampin may decrease diltiazem serum '
          'levels.',
      'Maximal antihypertensive effect seen within 2 wk. Extended-release dosage '
          'forms should be swallowed whole and NOT crushed or chewed. Cardizem '
          'immediate-release tablets should be swallowed whole, as crushing or '
          'chewing them may alter their pharmacokinetics.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 964',
  ),
  // DIMENHYDRINATE — PDF p. 156 (printed 965)
  DrugEntryV3(
    name: 'DIMENHYDRINATE',
    brandNames: 'Dramamine, Driminate, and generics',
    drugClass: 'Antiemetic, antihistamine',
    iconRow: '',
    formulations: [
      'Tabs (OTC): 50 mg',
      'Chewable tabs (OTC): 50 mg; contains 0.75 mg phenylalanine',
      'Injection: 50 mg/mL; contains benzyl alcohol and propylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child (<12 yr):',
        lines: [
          DoseLine('1–1.5 mg/kg/dose PO/IM/IV Q6 hr; max. dose: 25 mg/dose; alternative oral '
              'dosing by age:'),
          DoseLine('2–5 yr: 12.5–25 mg/dose PO Q6–8 hr PRN with the max. dosage below'),
          DoseLine('6–12 yr: 25–50 mg/dose PO Q6–8 hr PRN with the max. dosage below'),
        ],
      ),
      DoseSection(
        heading: '≥12 yr and adult:',
        lines: [
          DoseLine('50–100 mg/dose PO/IM/IV Q4–6 hr PRN'),
        ],
      ),
      DoseSection(
        heading: 'MAX. PO DOSE:',
        lines: [
          DoseLine('2–5 yr: 75 mg/24 hr'),
          DoseLine('6–12 yr: 150 mg/24 hr'),
          DoseLine('≥12 yr and adult: 400 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'MAX. IM DOSE:',
        lines: [
          DoseLine('Child: 300 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Causes drowsiness and anticholinergic side effects. May mask vestibular '
          'symptoms and cause CNS excitation in young children. Caution when taken '
          'with ototoxic agents or history of seizures. Use should be limited to '
          'management of prolonged vomiting of known etiology. Not recommended in '
          'children <2 yr. Toxicity resembles anticholinergic poisoning.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 965',
  ),
  // DIPHENHYDRAMINE — PDF p. 156–157 (printed 965–966)
  DrugEntryV3(
    name: 'DIPHENHYDRAMINE',
    brandNames: 'Benadryl, many other brand names, and generics',
    drugClass: 'Antihistamine',
    iconRow: '',
    formulations: [
      'Oral elixir (OTC): 12.5 mg/5 mL; may contain 5.6% alcohol',
      'Oral liquid/solution (OTC): 12.5 mg/5 mL; some preparations may contain '
          'parabens and/or sodium benzoate',
      'Caps/tabs (OTC): 25, 50 mg',
      'Chewable tabs (OTC): 12.5 mg; contains aspartame, phenylalanine',
      'Injection: 50 mg/mL (1, 10 mL)',
      'Topical cream (OTC): 2% (28, 35, 42 g); may contain zinc acetate and '
          'parabens',
      'Topical gel (OTC): 2% (103, 118 mL); contains parabens',
      'Topical stick (OTC): 2% (14 mL); contains alcohol',
      'Topical spray (OTC): 2% (59 mL); contains zinc and parabens',
    ],
    doseSections: [
      DoseSection(
        heading: 'Severe allergic reaction (anaphylaxis) and dystonic reactions '
            '(including phenothiazine toxicity) (PO/IM/IV):',
        lines: [
          DoseLine('Child: 1–2 mg/kg/dose Q6 hr; usual dose: 5 mg/kg/24 hr ÷ Q6 hr; max. '
              'dose: 50 mg/dose and 300 mg/24 hr'),
          DoseLine('Adult: 25–50 mg/dose Q4–8 hr; max. dose: 400 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Sleep aid (PO/IM/IV):',
        lines: [
          DoseLine('Administer dose 30 min before bedtime.'),
          DoseLine('2–11 yr: 0.5–1 mg/kg/dose; max. dose: 50 mg/dose'),
          DoseLine('≥12 yr: 25–50 mg'),
        ],
      ),
      DoseSection(
        heading: 'Topical (cream, gel, stick):',
        lines: [
          DoseLine('≥2 yr–adult: Apply to affected area no more than TID–QID.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated with concurrent MAO inhibitor use, acute attacks of '
          'asthma, and GI or urinary obstruction. Use with caution in infants and '
          'young children, and do not use in neonates due to potential CNS effects. '
          'Side effects include sedation, nausea, vomiting, xerostoma, blurred '
          'vision, and other reactions common to antihistamines. CNS side effects '
          'more common than GI disturbances. May cause paradoxical excitement in '
          'children. False-positive test for urine phencyclidine (PCP) screen may '
          'occur. Adjust dose in renal failure (see Chapter 32).',
      'TOPICAL USE: Side effects include rash, urticaria, and photosensitivity.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 965–966',
  ),
  // DIVALPROEX SODIUM — PDF p. 157 (printed 966)
  DrugEntryV3(
    name: 'DIVALPROEX SODIUM',
    brandNames: 'Depakote, Depakote Sprinkles, Depakote ER, and generics',
    drugClass: 'Anticonvulsant',
    iconRow: '',
    formulations: [
      'Delayed-release tabs:',
      'Depakote and generics: 125, 250, 500 mg',
      'Extended-release tabs (for Q24 hr dosing):',
      'Depakote ER and generics: 250, 500 mg',
      'Delayed-release sprinkle caps:',
      'Depakote Sprinkles and generics: 125 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Dose:',
        lines: [
          DoseLine('See Valproic Acid'),
        ],
      ),
    ],
    remarks: [
      'See Valproic Acid. Preferred over valproic acid for patients on ketogenic '
          'diet. Contraindicated for patients with known urea cycle disorders. '
          'Depakote ER is prescribed on a once-daily interval, whereas Depakote is '
          'typically prescribed BID. Depakote and Depakote ER are not bioequivalent; '
          'see package insert for dose conversion.',
      'Efficacy was not established in separate randomized, double-blind, '
          'placebo-controlled trials for the treatment of pediatric bipolar disorder '
          '(10–17 yr old) and migraine prophylaxis (12–17 yr old).',
    ],
    pregnancyNote: 'Pregnancy category is “X” when used for migraine prophylaxis and '
        'is “D” for all other indications.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 966',
  ),
  // DOBUTAMINE — PDF p. 157–158 (printed 966–967)
  DrugEntryV3(
    name: 'DOBUTAMINE',
    brandNames: 'Various generics; previously available as Dobutrex',
    drugClass: 'Sympathomimetic agent',
    iconRow: '',
    formulations: [
      'Injection: 12.5 mg/mL (20 mL); may contain sulfites',
      'Prediluted injection in D₅W: 1 mg/mL (250 mL), 2 mg/mL (250 mL), 4 mg/mL '
          '(250 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Continuous IV infusion (all ages):',
        lines: [
          DoseLine('Start at 0.5–1 mCg/kg/min and gradually increase as needed; usual range: '
              '2–20 mCg/kg/min'),
          DoseLine('Recommended max. dose: 40 mCg/kg/min'),
        ],
      ),
      DoseSection(
        heading: 'To prepare infusion:',
        lines: [
          DoseLine('See IV infusions on inside front cover.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in idiopathic hypertrophic subaortic stenosis (IHSS). '
          'Tachycardia, arrhythmias (premature ventricular contractions [PVCs]), and '
          'hypertension may occasionally occur (especially at higher infusion '
          'rates). Correct hypovolemic states before use. Increases AV conduction '
          'and may precipitate ventricular ectopic activity.',
      'Dobutamine has been shown to increase cardiac output and systemic '
          'pressure in pediatric patients of every age group. However, in premature '
          'neonates, dobutamine is less effective than dopamine in raising systemic '
          'blood pressure without causing undue tachycardia, and dobutamine has not '
          'been shown to provide any added benefit when given to such infants '
          'already receiving optimal infusions of dopamine.',
      'Monitor BP and vital signs. T₁/₂: 2 min. Peak effects in 10–20 min. Use '
          'with linezolid may potentially increase blood pressure. Use with '
          'catechol-O-methyltransferase (COMT) inhibitors (e.g., entacapone) may '
          'increase heart rate and risk for arrhythmias and changes in blood '
          'pressure.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 966–967',
  ),
  // DOCUSATE — PDF p. 158 (printed 967)
  DrugEntryV3(
    name: 'DOCUSATE',
    brandNames: 'Colace, DocuSol Kids, Enemeez Mini, and many other brands and '
        'generics',
    drugClass: 'Stool softener, laxative',
    iconRow: '',
    formulations: [
      'Available as docusate sodium:',
      'Caps (OTC): 100, 250 mg; sodium content (100-mg cap: ∼5 mg)',
      'Tabs (OTC): 100 mg',
      'Syrup (OTC): 20 mg/5 mL (473 mL); may contain alcohol',
      'Oral liquid (OTC): 10 mg/mL (118, 473 mL); contains 1 mg/mL sodium',
      'Rectal enema:',
      'DocuSol Kids (OTC): 100 mg/5 mL (5 mL); contains polyethylene glycol',
      'Enemeez Mini (OTC): 283 mg/5 mL (5 mL); contains polyethylene glycol',
      'Available as docusate calcium:',
      'Caps (OTC): 240 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'PO (take with liquids; see remarks):',
        lines: [
          DoseLine('<3 yr: 10–40 mg/24 hr ÷ once daily–QID'),
          DoseLine('3–6 yr: 20–60 mg/24 hr ÷ once daily–QID'),
          DoseLine('6–12 yr: 40–150 mg/24 hr ÷ once daily–QID'),
          DoseLine('>12 yr and adult: 50–400 mg/24 hr ÷ once daily–QID'),
          DoseLine('Docusate calcium: 240 mg once daily'),
        ],
      ),
      DoseSection(
        heading: 'Rectal (see remarks):',
        lines: [
          DoseLine('2–<12 yr: 100 mg/5 mL or 283 mg/5 mL PR once daily'),
          DoseLine('≥12 yr and adult: 283 mg/5 mL PR once daily–TID. Alternatively, 50–100 mg '
              'of oral liquid (not syrup) mixed in enema fluid (saline or oil retention '
              'enemas) may be used.'),
        ],
      ),
    ],
    remarks: [
      'Oral dosage effective only after 1–3 days of therapy, whereas the enema '
          'has an onset of action in 2–15 min. Reassess therapy if no response seen '
          'after 7 days of continuous use.',
      'Incidence of side effects is exceedingly low. Rash, nausea, and throat '
          'irritation have been reported. Oral liquid is bitter; give with milk, '
          'fruit juice, or formula to mask taste.',
      'A few drops of the 10 mg/mL oral liquid may be used in the ear as a '
          'cerumenolytic. Effect is usually seen within 15 min.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 967',
  ),
  // DOLASETRON — PDF p. 158–159 (printed 967–968)
  DrugEntryV3(
    name: 'DOLASETRON',
    brandNames: 'Anzemet',
    drugClass: 'Antiemetic agent, 5-HT3 antagonist',
    iconRow: '',
    formulations: [
      'Tabs: 50 mg',
      'Oral suspension: 10 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Chemotherapy-induced nausea and vomiting prevention:',
        lines: [
          DoseLine('2 yr–adult: 1.8 mg/kg/dose PO up to a max. dose of 100 mg. Administer PO '
              'dose 60 min prior to chemotherapy. IV route of administration is '
              'considered contraindicated for this indication due to increased risk for '
              'Q–Tc interval prolongation and is no longer available.'),
        ],
      ),
    ],
    remarks: [
      'May cause hypotension and prolongation of cardiac conduction intervals, '
          'particularly Q–Tc interval (dose-dependent effect). Common side effects '
          'include dizziness, headache, sedation, blurred vision, fever, chills, and '
          'sleep disorders. Rare cases of sustained supraventricular and ventricular '
          'arrhythmias, fatal cardiac arrest, and MI have been reported in children '
          'and adolescents.',
      'Avoid use in patients with congenital long QT syndrome, hypomagnesemia, '
          'and hypokalemia, or with concurrent use with other drugs that increase '
          'Q–Tc interval (e.g., erythromycin, cisapride). Drug’s active metabolite '
          '(hydrodolasetron) is a substrate for cytochrome P-450 2D6 and 3A3/3A4 '
          'isoenzymes; concomitant use of enzyme inhibitors (e.g., cimetidine) may '
          'increase risk for side effects, and use of enzyme inducers (e.g., '
          'rifampin) may decrease dolasetron’s efficacy. Serotonin syndrome has been '
          'associated with concurrent use of SSRIs (e.g., fluoxetine, sertraline), '
          'SNRIs (e.g., duloxetine, venlafaxine), MAO inhibitors, mirtazapine, '
          'fentanyl, lithium, tramadol, and IV methylene blue.',
      'Although no dosage adjustments are necessary, hydrodolasetron’s clearance '
          'decreases 42% with severe hepatic impairment and 44% with severe renal '
          'impairment.',
      'ECG monitoring is recommended in patients with electrolyte abnormalities, '
          'CHF, bradyarrhythmias, or renal impairment.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 967–968',
  ),
  // DOPAMINE — PDF p. 159 (printed 968)
  DrugEntryV3(
    name: 'DOPAMINE',
    brandNames: 'Various generics; previously available as Intropin',
    drugClass: 'Sympathomimetic agent',
    iconRow: '',
    formulations: [
      'Injection: 40 mg/mL (5, 10 mL); preservative free',
      'Prediluted injection in D₅W: 0.8, 1.6, 3.2 mg/mL (250, 500 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'All ages:',
        lines: [
          DoseLine('Low dose: 2–5 mCg/kg/min IV; increases renal blood flow; minimal effect '
              'on heart rate and cardiac output'),
          DoseLine('Intermediate dose: 5–15 mCg/kg/min IV; increases heart rate, cardiac '
              'contractility, cardiac output, and to a lesser extent, renal blood flow'),
          DoseLine('High dose: >15 mCg/kg/min IV; α-adrenergic effects are prominent; '
              'decreases renal perfusion'),
          DoseLine('Max. dose recommended: 20–50 mCg/kg/min IV'),
          DoseLine('To prepare infusion: See IV infusions on inside front cover'),
        ],
      ),
    ],
    remarks: [
      'Do not use in pheochromocytoma, tachyarrhythmias, or hypovolemia. Monitor '
          'vital signs and blood pressure continuously. Correct hypovolemic states. '
          'Tachyarrhythmias, ectopic beats, hypertension, vasoconstriction, and '
          'vomiting may occur. Use with caution with phenytoin because hypotension '
          'and bradycardia may be exacerbated. Use with linezolid may potentially '
          'increase blood pressure.',
      'Newborn infants may be more sensitive to the vasoconstrictive effects of '
          'dopamine. Children <2 yr of age clear dopamine faster, and high '
          'variability in neonates is exhibited.',
      'Should be administered through a central line or large vein. '
          'Extravasation may cause tissue necrosis; treat with phentolamine. Do not '
          'administer into an umbilical arterial catheter.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 968',
  ),
  // DORNASE ALFA/DNASE — PDF p. 160 (printed 969)
  DrugEntryV3(
    name: 'DORNASE ALFA/DNASE',
    brandNames: 'Pulmozyme',
    drugClass: 'Inhaled mucolytic',
    iconRow: '',
    formulations: [
      'Inhalation solution: 1 mg/mL (2.5 mL; in boxes of 30s)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Cystic fibrosis:',
        lines: [
          DoseLine('Child 3 mo–<5 yr (limited data from 65 patients receiving 2 wk of '
              'therapy): 2.5 mg via nebulizer once daily'),
          DoseLine('Child ≥5 yr and adult: 2.5 mg via nebulizer once daily. Some patients may '
              'benefit from 2.5 mg BID.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in patients with hypersensitivity to epoetin alfa. Voice '
          'alteration, pharyngitis, and laryngitis may result. These are generally '
          'reversible without dose adjustment. Safety and efficacy have not been '
          'demonstrated in patients with >1 yr of continuous use.',
      'Has been used intranasally via the Pari Sinus device for chronic '
          'rhinosinusitis in cystic fibrosis (>5 yr and adult); 2.5 mg intranasally '
          'once daily (limited data).',
      'Do not mix with other nebulized drugs. An inhaled β-agonist may be useful '
          'before administration to enhance drug distribution. Chest physiotherapy '
          'should be incorporated into treatment regimen. The following nebulizer '
          'compressor systems have been recommended for use: Pulmo-Aide, '
          'Pari-Proneb, Mobilaire, Porta-Neb, or PariBaby. Use of the “Sidestream” '
          'nebulizer cup can significantly reduce the medication administration '
          'time. Medication should be protected from light and stored in the '
          'refrigerator.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 969',
  ),
  // DOXYCYCLINE — PDF p. 160–161 (printed 969–970)
  DrugEntryV3(
    name: 'DOXYCYCLINE',
    brandNames: 'Doxy, Doryx, Monodox, Oracea, many others, and generics; previously '
        'available as Vibramycin',
    drugClass: 'Antibiotic, tetracycline derivative',
    iconRow: '',
    formulations: [
      'Caps: 50, 75, 100, 150 mg',
      'Tabs: 20, 50, 75, 100, 150 mg',
      'Delayed-release caps (Oracea and generics): 40 mg',
      'Delayed-release tabs:',
      'Generics: 50, 75, 80, 100, 150, 200 mg',
      'Doryx: 50 mg',
      'Doryx MPC: 60 mg',
      'Oral suspension: 25 mg/5 mL (60 mL)',
      'Injection (Doxy and generics): 100 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'General dosing, community-acquired pneumonia (Mycoplasma pneumoniae, '
            'Chlamydophila pneumoniae), Lyme disease, rickettsial disease, Rocky '
            'Mountain spotted fever, tularemia, and skin/soft tissue infection',
        lines: [
          DoseLine('(see remarks):'),
          DoseLine('≤45 kg: 2.2 mg/kg/dose PO/IV BID; max. dose: 200 mg/24 hr'),
          DoseLine('>45 kg: 100 mg/dose PO/IV BID'),
          DoseLine('Max. dose: 200 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Pelvic inflammatory disease (see latest CDC STI treatment guidelines):',
        lines: [
          DoseLine('Inpatient: 100 mg IV Q12 hr with cefotetan or cefoxitin, or ceftriaxone + '
              'metronidazole. Convert to oral therapy 24 hr after patient improves on IV '
              'to complete a 14-day total course (IV and PO).'),
          DoseLine('Outpatient: 100 mg PO Q12 hr × 14 days with ceftriaxone single IM dose '
              'with metronidazole, or cefoxitin single IM dose + probenecid single PO '
              'dose with metronidazole, or other parenteral third-generation '
              'cephalosporin with metronidazole'),
        ],
      ),
      DoseSection(
        heading: 'Anthrax (inhalation/systemic/cutaneous; see remarks):',
        lines: [
          DoseLine('Initiate therapy with IV route and convert to PO route when clinically '
              'appropriate. Duration of therapy is 60 days (IV and PO combined):'),
          DoseLine('≤8 yr or ≤45 kg: 2.2 mg/kg/dose IV/PO BID; max. dose: 200 mg/24 hr'),
          DoseLine('>8 yr and >45 kg: 100 mg/dose IV/PO BID'),
        ],
      ),
      DoseSection(
        heading: 'Malaria prophylaxis (start 1–2 days prior to exposure and continue '
            'for 4 wk after leaving endemic area):',
        lines: [
          DoseLine('≥8 yr: 2.2 mg/kg/24 hr PO once daily; max. dose: 100 mg/24 hr and max. '
              'duration of 4 mo'),
          DoseLine('Adult: 100 mg PO once daily'),
        ],
      ),
      DoseSection(
        heading: 'Acne:',
        lines: [
          DoseLine('≥8 yr and adolescent: 50–100 mg PO BID or 150 mg PO once daily'),
        ],
      ),
      DoseSection(
        heading: 'Periodontitis:',
        lines: [
          DoseLine('Adult: 20 mg PO BID × 3–9 mo'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in hepatic and renal disease. Previously not recommended '
          'for use in children <8 yr due to risk for tooth enamel hypoplasia and '
          'discoloration. However, the AAP Red Book now accepts the use of short '
          'courses (<21 days) for all ages when necessary. Doxycycline is the drug '
          'of choice for rickettsial disease regardless of age. May cause GI '
          'symptoms, photosensitivity, hemolytic anemia, rash, and hypersensitivity '
          'reactions. Increased intracranial pressure (pseudotumor cerebri), TEN, '
          'DRESS, erythema multiforme, and Stevens-Johnson syndrome have been '
          'reported. Avoid prolonged exposure to direct sunlight.',
      'Doxycycline is approved for the treatment of anthrax (Bacillus anthracis) '
          'in combination with one or two other antimicrobials. If meningitis is '
          'suspected, consider using an alternative agent because of poor CNS '
          'penetration. Consider changing to high-dose amoxicillin (25–35 mg/kg/dose '
          'PO TID) for penicillin-susceptible strains. See '
          'https://www.cdc.gov/anthrax/treatment/ for the latest information.',
      'Rifampin, barbiturates, phenytoin, and carbamazepine may increase '
          'clearance of doxycycline. Doxycycline may enhance the hypoprothrombinemic '
          'effect of warfarin. See Tetracycline for additional drug/food '
          'interactions and remarks.',
      'Infuse IV over 1–4 hr.',
      'For periodontitis, take tablets ≥1 hr prior to or 2 hr after meals.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 969–970',
  ),
  // DRONABINOL — PDF p. 161–162 (printed 970–971)
  DrugEntryV3(
    name: 'DRONABINOL',
    brandNames: 'Marinol, Syndros, tetrahydrocannabinol, THC, and generics',
    drugClass: 'Antiemetic',
    iconRow: '',
    formulations: [
      'Caps (Marinol and generics): 2.5, 5, 10 mg; may contain sesame oil',
      'Oral solution (Syndros): 5 mg/mL (30 mL); contains alcohol (50% w/w), '
          'parabens, and polyethylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Oral capsule and solution dosage forms are NOT bioequivalent and '
            'should not be used interchangeably.',
      ),
      DoseSection(
        heading: 'ORAL CAPSULES:',
      ),
      DoseSection(
        heading: 'Antiemetic:',
        lines: [
          DoseLine('Child ≥6 yr and adult (PO capsules): 5 mg/m²/dose 1–3 hr prior to '
              'chemotherapy, then Q2–4 hr up to a max. dose of 4–6 doses/24 hr; doses '
              'may be gradually increased by 2.5 mg/m²/dose increments up to a max. dose '
              'of 15 mg/m²/dose if needed and tolerated.'),
        ],
      ),
      DoseSection(
        heading: 'Appetite stimulant:',
        lines: [
          DoseLine('Adult (PO capsules): 2.5 mg BID 1 hr before lunch and dinner; if not '
              'tolerated, reduce dose to 2.5 mg once daily 1 hr before dinner or QHS. '
              'Max dose: 20 mg/24 hr (use caution when increasing doses because of '
              'increased risk of dose-related adverse reactions at higher dosages).'),
        ],
      ),
      DoseSection(
        heading: 'ORAL SOLUTION:',
      ),
      DoseSection(
        heading: 'Antiemetic:',
        lines: [
          DoseLine('Adult (PO oral solution): 4.2 mg/m²/dose 1–3 hr prior to chemotherapy, '
              'then Q2–4 hr up to a max. dose of 4–6 doses/24 hr; doses may be gradually '
              'increased by 2.1 mg/m²/dose increments up to a max. dose of 12.6 '
              'mg/m²/dose, if needed and tolerated.'),
        ],
      ),
      DoseSection(
        heading: 'Appetite stimulant:',
        lines: [
          DoseLine('Adult (PO oral solution): 2.1 mg BID 1 hr before lunch and dinner; if not '
              'tolerated, reduce dose to 2.1 mg once daily 1 hr before dinner or QHS. '
              'Dose may be gradually increased, if needed and tolerated, by increasing '
              'the pre-dinner dose to 4.2 mg 1 hr before dinner. Further increase to 4.2 '
              'mg BID 1 hr before lunch and dinner if needed and tolerated. Max. dose: '
              '16.8 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in patients with history of substance abuse and mental '
          'illness and allergy to sesame oil (capsules only). Use with caution in '
          'heart disease, seizures, hepatic disease (reduce dose if severe), and in '
          'patients who operate motor vehicles or dangerous machinery. Side effects: '
          'euphoria, dizziness, difficulty concentrating, anxiety, mood change, '
          'sedation, hallucinations, ataxia, paresthesia, hypotension, excessively '
          'increased appetite, and habit-forming potential. Exacerbation of mania, '
          'depression, schizophrenia, and seizures have been reported. Avoid use '
          'with other medications that can produce similar side effects.',
      'Dronabinol is a substrate for cytochrome P-450 (CYP) 2C9 and 3A4. '
          'Individuals with poor CYP2C9 activity may have reduced clearance of '
          'dronabinol, which may increase effects/toxicity.',
      'Onset of action: 0.5–1 hr; duration of psychoactive effects 4–6 hr, '
          'appetite stimulation 24 hr',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 970–971',
  ),
  // DROPERIDOL — PDF p. 162–163 (printed 971–972)
  DrugEntryV3(
    name: 'DROPERIDOL',
    brandNames: 'Generics; previously available as Inapsine',
    drugClass: 'Sedative, antiemetic',
    iconRow: '',
    formulations: [
      'Injection: 2.5 mg/mL (1, 2 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Antiemetic/sedation (see remarks):',
        lines: [
          DoseLine('Child (2–12 yr): 0.01–0.015 mg/kg/dose (max. dose: 1.25 mg/dose; some '
              'recommend an initial max. dose of 0.1 mg/kg/dose) IM or IV over 2–5 min. '
              'Additional doses should be administered with caution; benefits outweigh '
              'the risks. Dosages >0.05 mg/kg/dose are considered excessive with higher '
              'risk for adverse events and are no longer recommended.'),
          DoseLine(
            'Dosage interval:',
            isHeading: true,
          ),
          DoseLine('Antiemetic: Q6 hr PRN'),
          DoseLine('Sedation: Repeat dose in 15–30 min if necessary.'),
          DoseLine('Adult: 2.5 mg IM or IV over 2–5 min. Additional doses of 1.25 mg should '
              'be administered with caution (benefits outweigh the risks).'),
          DoseLine(
            'Dosage interval:',
            isHeading: true,
          ),
          DoseLine('Antiemetic: Q6 hr PRN'),
          DoseLine('Sedation: Repeat dose in 15–30 min if necessary.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in renal and hepatic impairment; 75% of metabolites are '
          'excreted renally, and drug is extensively metabolized in the liver. Side '
          'effects include hypotension, tachycardia, extrapyramidal side effects '
          'such as dystonia, feeling of motor restlessness, laryngospasm, and '
          'bronchospasm. May lower seizure threshold. Fatal arrhythmias and Q–T '
          'interval prolongation have been associated with use.',
      'Onset in 3–10 min. Peak effects within 10–30 min. Duration of action 2–4 '
          'hr. Often given as adjunct to other agents.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 971–972',
  ),
  // DYMISTA — PDF p. 163 (printed 972)  [cross-reference]
  DrugEntryV3(
    name: 'DYMISTA',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Azelastine and Fluticasone.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 972',
  ),
];
