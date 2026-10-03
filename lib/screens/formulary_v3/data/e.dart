// =============================================================================
// output/e.dart — Drug Formulary 3.0, letter E
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyE` per file; entries in book order.
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

const List<DrugEntryV3> formularyE = [
  // ELEXACAFTOR/TEZACAFTOR/IVACAFTOR — PDF p. 163–166 (printed 972–975)
  DrugEntryV3(
    name: 'ELEXACAFTOR/TEZACAFTOR/IVACAFTOR',
    brandNames: 'Trikafta',
    drugClass: 'Cystic fibrosis transmembrane conductance regulator corrector and '
        'potentiator',
    iconRow: '',
    formulations: [
      'Oral granules:',
      'Morning dose:',
      'Blue and white colored packets: Elexacaftor 80 mg + tezacaftor 40 mg + '
          'ivacaftor 60 mg',
      'Orange and white colored packets: Elexacaftor 100 mg + tezacaftor 50 mg + '
          'ivacaftor 75 mg',
      'Evening dose:',
      'Green and white colored packets: Ivacaftor 59.5 mg',
      'Pink and white colored packets: Ivacaftor 75 mg',
      'Available as 56-count carton containing 4 wallets for a 28-day supply; '
          'each wallet contains 7 morning-dose packets and 7 evening-dose packets '
          'for a 7-day supply of the following combinations:',
      'Blue and white colored packets (elexacaftor 80 mg + tezacaftor 40 mg + '
          'ivacaftor 60 mg) and green and white colored packets (ivacaftor 59.5 mg)',
      'Orange and white colored packets (elexacaftor 100 mg + tezacaftor 50 mg + '
          'ivacaftor 75 mg) and pink and white colored packets (ivacaftor 150 mg)',
      'Tabs:',
      'Morning dose:',
      'Light orange colored: Elexacaftor 50 mg + tezacaftor 25 mg + ivacaftor '
          '37.5 mg',
      'Orange colored: Elexacaftor 100 mg + tezacaftor 50 mg + ivacaftor 75 mg',
      'Evening dose (light blue colored): Ivacaftor 75 mg or 150 mg',
      'Available as an 84-tablet carton containing 4 wallets for a 28-day '
          'supply; each wallet contains 14 morning-dose tablets and 7 evening-dose '
          'tablets for a 7-day supply of the following combinations:',
      'Light orange colored morning-dose tablets (elexacaftor 50 mg + tezacaftor '
          '25 mg + ivacaftor 37.5 mg) and light blue colored evening-dose tablets '
          '(ivacaftor 75 mg)',
      'Orange colored morning-dose tablets (elexacaftor 100 mg + tezacaftor 50 '
          'mg + ivacaftor 75 mg) and light blue colored evening-dose tablets '
          '(ivacaftor 150 mg)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Morning and evening doses should be taken (PO) ~12 hr apart with '
            'fat-containing food; see remarks',
        lines: [
          DoseLine('.'),
        ],
      ),
      DoseSection(
        heading: 'Child 2–<6 yr:',
        lines: [
          DoseLine(
            'Weighing <14 kg:',
            isHeading: true,
          ),
          DoseLine('Morning dose: 1 packet (elexacaftor 80 mg + tezacaftor 40 mg + ivacaftor '
              '60 mg each packet) every morning'),
          DoseLine('Evening dose: 1 packet (ivacaftor 59.5 mg each packet) every evening'),
          DoseLine(
            'Weighing ≥14 kg:',
            isHeading: true,
          ),
          DoseLine('Morning dose: 1 packet (elexacaftor 100 mg + tezacaftor 50 mg + ivacaftor '
              '75 mg each packet) every morning'),
          DoseLine('Evening dose: 1 packet (ivacaftor 75 mg each packet) every evening'),
        ],
      ),
      DoseSection(
        heading: 'Child 6–11 yr weighing <30 kg:',
        lines: [
          DoseLine('Morning dose: 2 morning-dose tablets (elexacaftor 50 mg + tezacaftor 25 '
              'mg + ivacaftor 37.5 mg each tablet) every morning'),
          DoseLine('Evening dose: 1 evening-dose tablet (75 mg ivacaftor) every evening'),
        ],
      ),
      DoseSection(
        heading: 'Child 6–11 yr weighing ≥30 kg, and child ≥12 yr and adult:',
        lines: [
          DoseLine('Morning dose: 2 morning-dose tablets (elexacaftor 100 mg + tezacaftor 50 '
              'mg + ivacaftor 75 mg each tablet) every morning'),
          DoseLine('Evening dose: 1 evening-dose tablet (150 mg ivacaftor) every evening'),
        ],
      ),
      DoseSection(
        heading: 'Dose Adjustment for Hepatic Impairment',
        table: DoseTable(
          headers: ['', 'Mild (Child-Pugh Class A)', 'ᵃModerate (Child-Pugh Class B)', 'Severe (Child-Pugh Class C)'],
          rows: [
            DoseTableRow(['Morning dose', 'Use regular dosage', 'Child 2–<6 yr:\nDays 1–3: Use regular age/weight-specific AM dosage (1 '
                'packet)\nDay 4: No dose\nDays 5 & 6: Use regular age/weight-specific AM '
                'dosage (1 packet)\nDay 7: No dose\nThen repeat same cycle weekly\nChild '
                '≥6 yr and adult:\nDay 1: Use regular age/weight-specific AM dosage (2 '
                'tablets)\nDay 2: Use one age/weight-specific AM tablet Then continue '
                'alternating Day 1 and Day 2 dosing thereafter and closely monitor liver '
                'function tests', 'Should not be used']),
            DoseTableRow(['Evening dose', 'Use regular dosage', 'All ages: No evening dosage', 'Should not be used']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃUse not recommended unless benefit exceeds risk.'),
        ],
      ),
      DoseSection(
        heading: 'Dose Adjustment for Moderate Cytochrome P-450 (CYP) 3A Inhibitors '
            '(e.g., fluconazole, erythromycin):',
        lines: [
          DoseLine('Administer all doses in the morning and continue alternating Day 1 and '
              'Day 2 regimens thereafter starting on Day 3'),
          DoseLine(
            'Child 2–<6 yr:',
            isHeading: true,
          ),
          DoseLine(
            '<14 kg:',
            isHeading: true,
          ),
          DoseLine('Day 1: 1 morning-dose packet (elexacaftor 80 mg + tezacaftor 40 mg + '
              'ivacaftor 60 mg each blue and white packet)'),
          DoseLine('Day 2: 1 evening-dose packet (ivacaftor 59.5 mg each green and white '
              'packet) in the morning'),
          DoseLine('≥14 kg:'),
          DoseLine('Day 1: 1 morning-dose packet (elexacaftor 100 mg + tezacaftor 50 mg + '
              'ivacaftor 75 mg each orange and white packet)'),
          DoseLine('Day 2: 1 evening-dose packet (ivacaftor 75 mg each pink and white packet) '
              'in the morning'),
          DoseLine(
            'Child 6–11 yr weighing <30 kg:',
            isHeading: true,
          ),
          DoseLine('Day 1: 2 morning-dose tablets of elexacaftor 50 mg + tezacaftor 25 mg + '
              'ivacaftor 37.5 mg each tablet (light orange tabs)'),
          DoseLine('Day 2: 1 evening-dose tablet (ivacaftor 75 mg) in the morning'),
          DoseLine(
            'Child 6–11 yr weighing ≥30 kg, and child ≥12 yr and adult:',
            isHeading: true,
          ),
          DoseLine('Day 1: 2 morning-dose tablets of elexacaftor 100 mg + tezacaftor 50 mg + '
              'ivacaftor 75 mg each tablet (orange tabs)'),
          DoseLine('Day 2: 1 evening-dose tablet (ivacaftor 150 mg) in the morning'),
        ],
      ),
      DoseSection(
        heading: 'Dose Adjustment for Strong CYP3A Inhibitors (e.g., ketoconazole, '
            'itraconazole, posaconazole, voriconazole, telithromycin, and '
            'clarithromycin):',
        lines: [
          DoseLine('Administer all doses in the morning twice weekly spaced approximately 3–4 '
              'days apart'),
          DoseLine(
            'Child 2–<6 yr:',
            isHeading: true,
          ),
          DoseLine(
            '<14 kg:',
            isHeading: true,
          ),
          DoseLine('Day 1: One morning-dose packet of elexacaftor 80 mg + tezacaftor 40 mg + '
              'ivacaftor 60 mg (blue and white packet)'),
          DoseLine('Days 2 and 3: No dose'),
          DoseLine('Day 4: Use Day 1 regimen, then continue same dosage twice a week '
              '(approximately 3–4 days apart)'),
          DoseLine(
            '≥14 kg:',
            isHeading: true,
          ),
          DoseLine('Day 1: One morning-dose packet of elexacaftor 100 mg + tezacaftor 50 mg + '
              'ivacaftor 75 mg (orange and white packet)'),
          DoseLine('Days 2 and 3: No dose'),
          DoseLine('Day 4: Use Day 1 regimen, then continue same dosage twice a week '
              '(approximately 3–4 days apart)'),
          DoseLine(
            'Child 6–11 yr weighing <30 kg:',
            isHeading: true,
          ),
          DoseLine('Day 1: 2 morning-dose tablets of elexacaftor 50 mg + tezacaftor 25 mg + '
              'ivacaftor 37.5 mg each tablet (light orange tabs)'),
          DoseLine('Days 2 and 3: No dose'),
          DoseLine('Day 4: Use Day 1 regimen (2 morning-dose tablets), then continue the same '
              'dosage twice a week (approximately 3–4 days apart)'),
          DoseLine(
            'Child 6–11 yr weighing ≥30 kg, and child ≥12 yr and adult:',
            isHeading: true,
          ),
          DoseLine('Day 1: 2 morning-dose tablets of elexacaftor 100 mg + tezacaftor 50 mg + '
              'ivacaftor 75 mg each tablet (orange tabs)'),
          DoseLine('Days 2 and 3: No dose'),
          DoseLine('Day 4: Use Day 1 regimen (2 morning-dose tablets), then continue the same '
              'dosage twice a week (approximately 3–4 days apart)'),
        ],
      ),
    ],
    remarks: [
      'Works on CFTR trafficking defects with two correctors (elexacaftor and '
          'tezacaftor) and a potentiator (ivacaftor). Indicated for individuals with '
          'at least one F508del CFTR mutation or with CFTR mutations that are '
          'responsive based on clinical and/or in vitro data.',
      'Common side effects include headache, URI, abdominal pain, diarrhea, '
          'rash, nasal congestion, rhinorrhea, rhinitis, influenza sinusitis, and '
          'increases in liver enzymes (ALT/AST, bilirubin) and serum creatine '
          'phosphokinase. Monitor baseline ALT/AST and bilirubin at baseline and '
          'repeat every 3 mo for the first year followed by annual assessments. '
          'Serious liver injury has been reported within the first month of therapy '
          'and up to 15 months following initiation. Ocular exams should be obtained '
          'at baseline and annually as cataracts have been reported in children. May '
          'cause a false-positive urine drug screen for cannabinoids.',
      'Do not use in severe hepatic impairment (Child-Pugh class C) and use is '
          'not recommended, unless the benefit outweighs the risk, for moderate '
          'hepatic impairment (Child-Pugh class B). Liver failure resulting in '
          'transplantation has been reported in a patient with cirrhosis and portal '
          'hypertension. Mental status changes (e.g., fogginess, memory issues) have '
          'been reported within the first 3 months of therapy. Anaphylaxis and '
          'angioedema have also been reported. Use with caution with CrCl ≤30 mL/min '
          'and ESRD because of lack of data.',
      'All three components of this medication are substrates of CYP3A. Avoid '
          'use in combination with strong inducers of CYP3A (e.g., rifampin, '
          'rifabutin, phenobarbital, carbamazepine, phenytoin, and St. John’s wort). '
          'Use with moderate and strong CYP3A inhibitors requires dose reductions; '
          'see dosing section. Elexacaftor/tezacaftor/ivacaftor may increase the '
          'effects/toxicity of digoxin, cyclosporine, everolimus, glimepiride, '
          'glipizide, glyburide, nateglinide, repaglinide, sirolimus, tacrolimus, '
          'and warfarin. Always evaluate the potential drug-drug interactions.',
      'Avoid food or drink containing grapefruit or Seville oranges.',
      'Administer all doses with high-fat foods to ensure absorption. Morning '
          'and evening doses should NOT be taken at the same time. If a dose is '
          'missed within 6 hr of a scheduled dose, administer the respective morning '
          'or evening dose immediately and resume usual dosing. However, if the '
          'missed dose is >6 hr, the following are recommended:',
      'Missed morning dose: Take missed morning dose as soon as possible and do '
          'not take evening dose for that day, then resume usual dosing the next day.',
      'Missed evening dose: Do not take the missed dose, then resume usual '
          'dosing the next day.',
      'Never take a double dose for a missed dose.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 972–975',
  ),
  // EMLA — PDF p. 166 (printed 975)  [cross-reference]
  DrugEntryV3(
    name: 'EMLA',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Lidocaine and Prilocaine',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 975',
  ),
  // ENALAPRIL MALEATE (PO), ENALAPRILAT (IV) — PDF p. 166–167 (printed 975–976)
  DrugEntryV3(
    name: 'ENALAPRIL MALEATE (PO), ENALAPRILAT (IV)',
    brandNames: 'Enalapril: Vasotec, Epaned, and generics\nEnalaprilat: generics; '
        'previously available as Vasotec IV',
    drugClass: 'Angiotensin-converting enzyme inhibitor, antihypertensive',
    iconRow: '',
    formulations: [
      'Enalapril:',
      'Tabs (Vasotec and generics): 2.5, 5, 10, 20 mg (scored)',
      'Oral solution (Epaned and generics): 1 mg/mL (150 mL); may contain sodium '
          'benzoate',
      'Oral suspension: 0.1, 1 mg/mL',
      'Enalaprilat:',
      'Injection: 1.25 mg/mL (1, 2 mL); contains benzyl alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hypertension:',
        lines: [
          DoseLine(
            'Infant and child:',
            isHeading: true,
          ),
          DoseLine('PO: 0.08 mg/kg/24 hr up to 5 mg/24 hr once daily; increase PRN over 2 wk'),
          DoseLine('Max. dose (higher doses have not been evaluated): 0.58 mg/kg/24 hr up to '
              '40 mg/24 hr'),
          DoseLine('IV: 0.005–0.01 mg/kg/dose Q8–24 hr; max. dose: 1.25 mg/dose'),
          DoseLine(
            'Adolescent and adult:',
            isHeading: true,
          ),
          DoseLine('PO: 2.5–5 mg/24 hr once daily initially to max. dose of 40 mg/24 hr ÷ '
              'once daily–BID'),
          DoseLine('IV: 0.625–1.25 mg/dose Q6 hr; doses as high as 5 mg Q6 hr are reported to '
              'be tolerated for up to 36 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated with hypersensitivity to ACE inhibitors and use in '
          'combination with a neprilysin inhibitor (e.g., sacubitril). Use with '
          'caution in bilateral renal artery stenosis. Avoid use in dialysis with '
          'high-flux membranes because anaphylactoid reactions have been reported. '
          'Side effects: nausea, diarrhea, headache, dizziness, hyperkalemia, '
          'hypoglycemia, hypotension, and hypersensitivity. Cough is a reported side '
          'effect of ACE inhibitors.',
      'Risk for angioedema increases with enalapril and coadministration of '
          'rapamycin or sacubitril.',
      'Enalapril (PO) is converted to its active form (Enalaprilat) by the '
          'liver. Administer IV over 5 min. Adjust dose in renal impairment (see '
          'Chapter 32).',
      'Nitritoid reactions have been seen in patients receiving concomitant IV '
          'gold therapy. Enalapril/enalaprilat should be discontinued as soon as '
          'possible when pregnancy is detected. If oliguria or hypotension occurs in '
          'a neonate with in utero exposure with enalapril/enalaprilat, exchange '
          'transfusions or dialysis may be needed to reverse hypotension and/or '
          'support renal function.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 975–976',
  ),
  // ENOXAPARIN — PDF p. 167–169 (printed 976–978)
  DrugEntryV3(
    name: 'ENOXAPARIN',
    brandNames: 'Lovenox, Enoxiluv Kit, and generics',
    drugClass: 'Anticoagulant, low-molecular-weight heparin',
    iconRow: '',
    formulations: [
      'Injection: 100 mg/mL (3 mL); contains pork proteins and 15 mg/mL benzyl '
          'alcohol',
      'Injection (prefilled syringes with 27-gauge × ½-inch needle):',
      'Lovenox and generics: 30 mg/0.3 mL, 40 mg/0.4 mL, 60 mg/0.6 mL, 80 mg/0.8 '
          'mL, 100 mg/1 mL, 120 mg/0.8 mL, 150 mg/1 mL; preservative free and may '
          'contain pork proteins',
      'Enoxiluv Kit: 40 mg/0.4 mL; preservative free and may contain pork '
          'proteins',
      'Approximate anti–factor Xa activity: 100 IU per 1 mg',
    ],
    doseSections: [
      DoseSection(
        heading: '',
        lines: [
          DoseLine('Initial empiric dosage; patient-specific dosage defined by therapeutic '
              'drug monitoring when indicated (see remarks)'),
        ],
      ),
      DoseSection(
        heading: 'DVT treatment with platelet count ≥50,000/mm³:',
        lines: [
          DoseLine('Premature neonate <37 wk postmenstrual age: 2.1 mg/kg/dose SC Q12 hr'),
          DoseLine(
            'Full-term neonate (≥37 wk postmenstrual age):',
            isHeading: true,
          ),
          DoseLine('<2 mo old: 1.7 mg/kg/dose SC Q12 hr'),
          DoseLine('≥2 mo–<6 yr: 1.3 mg/kg/dose SC Q12 hr'),
          DoseLine('≥6 yr–adult: 1 mg/kg/dose SC Q12 hr; alternatively, 1.5 mg/kg/dose SC Q24 '
              'hr can be used in adults'),
          DoseLine(
            'Dosage adjustment for DVT treatment to achieve target anti–factor Xa '
                'low-molecular-weight heparin (LMWH) levels of 0.5–1 units/mL (see the '
                'following table):',
            isHeading: true,
          ),
        ],
        table: DoseTable(
          headers: ['Anti–Factor Xa Level LMWH (units/mL)', 'Hold Next Dose?', 'Dose Change', 'Repeat Anti–Factor Xa Level LMWH?'],
          rows: [
            DoseTableRow(['<0.4', 'No', 'Increase by 25%', '4 hr after the second new dose']),
            DoseTableRow(['0.4', 'No', 'Increase by 10%', '4 hr after the second new dose']),
            DoseTableRow(['0.5–1', 'No', 'No', '1 wk later (4 hr after the dose)']),
            DoseTableRow(['1.1–1.5', 'No', 'Decrease by 20%', '4 hr after the second new dose']),
            DoseTableRow(['1.6–2', 'Hold dose for 3 hr and measure level', 'Decrease by 30%', '4 hr after the second new dose']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        table: DoseTable(
          headers: ['Anti–Factor Xa Level LMWH (units/mL)', 'Hold Next Dose?', 'Dose Change', 'Repeat Anti–Factor Xa Level LMWH?'],
          rows: [
            DoseTableRow(['', '(goal <0.5 units/mL) prior to next new dose', '', '']),
            DoseTableRow(['>2', 'Hold dose until anti–factor Xa LMWH reaches 0.5 units/mL (levels can be '
                'measured Q12 hr until it reaches ≤0.5 units/mL)', 'When anti–factor Xa LMWH reaches ≤0.5 units/mL, dose may be restarted at '
                'a dose 40% less than the previous dose', '4 hr after the second new dose']),
          ],
        ),
      ),
      DoseSection(
        heading: 'DVT prophylaxis (see remarks):',
        lines: [
          DoseLine('Infant <2 mo: 0.75 mg/kg/dose SC Q12 hr'),
          DoseLine('Infant ≥2 mo–child 18 yr: 0.5 mg/kg/dose SC Q12 hr; max. dose: 30 mg/dose'),
          DoseLine(
            'Patients with indwelling epidural catheters/neuraxial anesthesia (≥2 '
                'mo–child 18 yr):',
            isHeading: true,
          ),
          DoseLine('1 mg/kg/dose SC Q24 hr; max. dose: 40 mg/dose. Twice-daily dosing is '
              'contraindicated for these patients (see remarks).'),
          DoseLine('Adult: 40 mg SC Q24 hr'),
          DoseLine(
            'Dosage adjustment for DVT prophylaxis to achieve target anti–factor Xa '
                'low-molecular-weight heparin (LMWH) levels of 0.1–0.4 units/mL for all '
                'children (see the following table):',
            isHeading: true,
          ),
        ],
        table: DoseTable(
          headers: ['Anti–Xa Level LMWH (units/mL)', 'Hold Next Dose?', 'Dose Change', 'Repeat Anti–Factor Xa Level LMWH?'],
          rows: [
            DoseTableRow(['<0.1', 'No', 'Increase by 20%–30%', '4 hr after the second new dose']),
            DoseTableRow(['0.1–0.4', 'No', 'No', '1 wk later (4 hr after the dose)']),
            DoseTableRow(['0.5–0.6', 'No', 'Decrease by 20%', '4 hr after the second new dose']),
            DoseTableRow(['0.7–1', 'No', 'Decrease by 30%–40%', '4 hr after the second new dose']),
            DoseTableRow(['>1', 'Hold dose until anti–factor Xa LMWH is <0.5 units/mL', 'When anti–factor Xa LMWH reaches <0.5 units/mL, dose may be restarted at '
                'a dose 40% less than the previous dose', '4 hr after the second new dose']),
          ],
        ),
      ),
    ],
    remarks: [
      'Inhibits thrombosis by inactivating factor Xa without significantly '
          'affecting bleeding time, platelet function, PT, or aPTT at recommended '
          'doses. Dosages of enoxaparin, heparin, or other LMWHs CANNOT be used '
          'interchangeably on a unit-for-unit (or mg-for-mg) basis because of '
          'differences in pharmacokinetics and activity. Peak anti–factor Xa LMWH '
          'activity is achieved 4 hr after a SC dose. Anti–factor Xa LMWH is NOT THE '
          'SAME as unfractionated heparin anti–factor Xa level (used for monitoring '
          'heparin therapy).',
      'Contraindicated in major bleeding, drug-induced thrombocytopenia, and '
          'pork hypersensitivity. Relative contraindications include: platelets ≤ '
          '50,000/mm³ and IM injections. Use with caution in uncontrolled arterial '
          'hypertension, bleeding diathesis, history of recurrent GI ulcers, '
          'diabetic retinopathy, and severe renal dysfunction (reduce dose by '
          'increasing the dosage interval from Q12 hr to Q24 hr if GFR <30 mL/min). '
          'Prophylactic use is not recommended in patients with prosthetic heart '
          'valves (especially in pregnant women) due to reports of fatalities in '
          'patients and fetuses. Concurrent use with spinal or epidural anesthesia '
          'or spinal puncture has resulted in long-term or permanent paralysis; '
          'potential benefits must be weighed against the risks. May cause fever, '
          'confusion, edema, nausea, hemorrhage, thrombocytopenia (including '
          'heparin-induced thrombocytopenia ± thrombosis [HIT/HITTS]), hypochromic '
          'anemia, and pain/erythema at injection site. Allergic reactions, '
          'headache, eosinophilia, alopecia, hepatocellular and cholestatic liver '
          'injury, and osteoporosis (long-term use) have been reported. Protamine '
          'sulfate is the antidote; 1 mg protamine sulfate neutralizes 1 mg '
          'enoxaparin.',
      'DVT prophylaxis for patients with epidural catheters/neuraxial '
          'anesthesia: If placing needle, hold anticoagulation for 12 hr and restart '
          'dosing ≥4 hr after needle insertion. If removing catheter, hold '
          'anticoagulation for 12 hr and restart dosing ≥2 hr after catheter removal.',
      'Recommended anti–factor Xa LMWH levels obtained 4 hr after subcutaneous '
          'dose after the third consecutive dose for children (anti–factor Xa LMWH '
          'response in children is highly variable compared to adults):',
      'DVT treatment: 0.5–1 units/mL',
      'DVT prophylaxis: 0.1–0.4 units/mL',
      'Administer by deep SC injection by having the patient lie down. Alternate '
          'administration between the left and right anterolateral and left and '
          'right posterolateral abdominal wall. See package insert for detailed SC '
          'administration recommendations. To minimize bruising, do not rub the '
          'injection site. IM route of administration is not recommended.',
      'For additional information, see Chest 2008;133:887–968 and Regional '
          'Anesthesia and Pain Medicine 2003;28(3):172–197.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 976–978',
  ),
  // EPINEPHRINE HCL — PDF p. 169–171 (printed 978–980)
  DrugEntryV3(
    name: 'EPINEPHRINE HCL',
    brandNames: 'Adrenalin, EpiPen, Auvi-Q, Neffy, EpinephrineSNAP, Primatene Mist, '
        'and generics',
    drugClass: 'Sympathomimetic agent',
    iconRow: '',
    formulations: [
      'Injection:',
      '1:1000 (aqueous): 1 mg/mL (1, 30 mL); may contain chlorobutanol and '
          'metabisulfite',
      'Injection, in prefilled syringe:',
      '1:10,000 (aqueous): 0.1 mg/mL (10 mL prefilled syringes with either 18-G '
          '3.5-inch or 20-G 1.5-inch needles)',
      'Autoinjector (contains sulfites):',
      'EpiPen and generics: Delivers a single 0.3 mg (0.3 mL) dose (2-pack; '
          'EpiPen and some generic products include a training device)',
      'EpiPen Jr and generics: Delivers a single 0.15 mg (0.3 mL) dose (2-pack; '
          'EpiPen Jr and some generic products include a training device)',
      'Auvi-Q: Delivers a single 0.1 mg (0.1 mL) dose, 0.15 mg (0.15 mL) dose, '
          'or 0.3 mg (0.3 mL) dose (2-pack with training device; each unit provides '
          'voice instructions when activated)',
      'Syringe Kit for Anaphylaxis (for specific weight-based dosages for any '
          'size patient):',
      'EpinephrineSNAP: 1 mg/mL (1 mL single-use vial in a box of 25 vials; or '
          '30 mL multi-use vial as a single vial)',
      'Many preparations may contain sulfites.',
      'Nasal solution:',
      'Neffy: both concentrations contain EDTA, benzalkonium chloride, and '
          'metabisulfite. NOTE: this product is indicated for anaphylaxis.',
      '1 mg/0.1 mL (1%) as a single nasal spray (2-pack)',
      '2 mg/0.1 mL (2%) as a single nasal spray (2-pack)',
      'A lower 0.1% strength nasal solution is used as a nasal decongestant. '
          'These products are not interchangeable with the differences in '
          'concentration and indication.',
      'Aerosol inhaler (HFA):',
      'Primatene Mist [OTC]: 0.125 mg per spray (160 sprays per inhaler) (11.7 '
          'g); contains 1% alcohol and polysorbate 80',
    ],
    doseSections: [
      DoseSection(
        heading: 'CARDIAC USE:',
      ),
      DoseSection(
        heading: 'Neonate:',
        lines: [
          DoseLine('Asystole and bradycardia: 0.01–0.03 mg/kg of 0.1 mg/mL (1:10,000) '
              'solution (0.1–0.3 mL/kg) IV/IO Q3–5 min PRN'),
        ],
      ),
      DoseSection(
        heading: 'Infant and child:',
        lines: [
          DoseLine('Bradycardia/asystole and pulseless arrest: See page ii and PALS '
              'algorithms in the back of the book'),
          DoseLine(
            'Bradycardia, asystole, and pulseless arrest (see remarks):',
            isHeading: true,
          ),
          DoseLine('First dose: 0.01 mg/kg of 0.1 mg/mL (1:10,000) solution (0.1 mL/kg) '
              'IO/IV; max. dose: 1 mg (10 mL). Subsequent doses Q3–5 min PRN should be '
              'the same. High-dose epinephrine after failure of standard dose has not '
              'been shown to be effective (see remarks). Must circulate drug with CPR. '
              'For ET route, see below.'),
          DoseLine('All ET doses: 0.1 mg/kg (max. dose: 2.5 mg) of 1:1000 solution (0.1 '
              'mL/kg; max. dose 2.5 mL) ET Q3–5 min'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Asystole: 1 mg IV or 2–2.5 mg ET Q3–5 min'),
        ],
      ),
      DoseSection(
        heading: 'IV drip (all ages):',
        lines: [
          DoseLine('0.05–1 mCg/kg/min; titrate to effect; to prepare infusion, see inside '
              'front cover'),
        ],
      ),
      DoseSection(
        heading: 'HYPERSENSITIVITY/ANAPHYLACTIC REACTIONS:',
      ),
      DoseSection(
        heading: 'Recommended IM administration via the anterolateral aspect of the '
            'thigh through clothing if necessary; see remarks for IV dosing.',
      ),
      DoseSection(
        heading: 'Infant, child, and adolescent:',
        lines: [
          DoseLine('0.01 mg/kg/dose IM (max. dose: 0.3 mg/dose for prepubertal child, 0.5 '
              'mg/dose for adolescent) Q5–15 min PRN'),
          DoseLine(
            'Auvi-Q (administer the following dosage IM × 1; an additional dose may be '
                'repeated in 5–15 min):',
            isHeading: true,
          ),
          DoseLine('7.5 to <15 kg: 0.1 mg'),
          DoseLine('15 to <30 kg: 0.15 mg'),
          DoseLine('≥30 kg: 0.3 mg'),
          DoseLine(
            'EpiPen/EpiPen Jr, or equivalent generic autoinjector (administer the '
                'following dosage IM × 1; an additional dose may be repeated in 5–15 min):',
            isHeading: true,
          ),
          DoseLine('7.5 to <30 kg: 0.15 mg'),
          DoseLine('≥30 kg: 0.3 mg'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Start with 0.2–0.5 mg IM Q5–15 min PRN. If using EpiPen or equivalent '
              'generic autoinjector, use 0.3 mg IM × 1; an additional dose may be '
              'repeated in 5–15 min'),
        ],
      ),
      DoseSection(
        heading: 'Intranasal route:',
        lines: [
          DoseLine('Neffy (for anaphylaxis; see remarks): 1 spray into one nostril, if '
              'needed, a second dose may be administered into the same nostril 5 min '
              'after the first dose. Do not prime or reuse each dosage form more than '
              'once (each devised containes only 1 dose). ≥15-<30 kg: use 1 mg/0.1 mL '
              'strength; ≥30 kg: use 2 mg/0.1 mL strength'),
        ],
      ),
      DoseSection(
        heading: 'RESPIRATORY BRONCHODILATOR USE:',
      ),
      DoseSection(
        heading: 'SC Injection (use 1:1000 or 1 mg/mL aqueous injection):',
        lines: [
          DoseLine('Infant and child: 0.01 mL/kg/dose SC (max. single dose 0.5 mL); repeat '
              'Q15 min × 3–4 doses or Q4 hr PRN'),
          DoseLine('Adult: 0.3–0.5 mg (0.3–0.5 mL)/dose SC Q20 min × 3 doses'),
        ],
      ),
      DoseSection(
        heading: 'Nebulization (alternative to racemic epinephrine):',
        lines: [
          DoseLine('0.5 mL/kg of 1:1000 solution diluted in 3 mL NS; max. doses: ≤4 yr: 2.5 '
              'mL/dose; >4 yr: 5 mL/dose'),
        ],
      ),
      DoseSection(
        heading: 'Aerosol inhaler (Primatene Mist):',
        lines: [
          DoseLine('≥12 yr and adult: 1 inhalation PO; may repeat 1 inhalation if needed 1 '
              'min after the first dose. Wait >4 hr between additional doses PRN; max. '
              'dose: 8 inhalations/24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Use of high-dose rescue therapy for in-hospital cardiac arrest in '
          'children after failure of an initial standard dose has been reported to '
          'be of no benefit compared to standard dose (N Engl J Med '
          '2004;350:1722–1730).',
      'May produce arrhythmias, tachycardia, hypertension, headaches, '
          'nervousness, nausea, vomiting, and rare cases of stress cardiomyopathy. '
          'Necrosis may occur at site of repeated local injection. Rare cases of '
          'serious skin and soft tissue infections, including necrotizing fasciitis '
          'and myonecrosis, have been reported with IM or deep SC injections.',
      'Concomitant use of noncardiac selective β-blockers, MAO inhibitors, COMT '
          'inhibitors, levothyroxine, diphenhydramine, chlorpheniramine, clonidine, '
          'or tricyclic antidepressants may enhance epinephrine’s pressor response. '
          'Chlorpromazine, diuretics, ergot alkaloids, nitrates, or α-blockers may '
          'reverse the pressor response. β-Blockers may antagonize epinephrine’s '
          'cardiostimulating and bronchodilating effects. Cardiac arrhythmias may '
          'develop for those who receive epinephrine while concomitantly taking '
          'cardiac glycosides, diuretics, or anti-arrhythmics. Do not use products '
          'containing chlorobutanol for ophthalmic use, as it may be harmful to the '
          'corneal endothelium.',
      'ETT doses should be diluted with NS to a volume of 3–5 mL before '
          'administration. Follow with several positive pressure ventilations.',
      'Hypersensitivity reactions: For bronchial asthma and certain allergic '
          'manifestations (e.g., angioedema, urticaria, serum sickness, anaphylactic '
          'shock), use epinephrine SC. Patients with anaphylaxis may benefit from IM '
          'administration. The adult IV dose for hypersensitivity reactions or to '
          'relieve bronchospasm usually ranges from 0.1 to 0.25 mg injected slowly '
          'over 5–10 min Q5–15 min as needed. Neonates may be given a dose of 0.01 '
          'mg/kg body weight; for infants, 0.05 mg is an adequate initial dose, and '
          'this may be repeated at 20- to 30-min intervals in the management of '
          'asthma attacks.',
      'Due to the inconsistent availability of autoinjector products, periodic '
          'reeducation of available device may be necessary. See respective '
          'autoinjector product for proper dose administration methods, including '
          'methods to prevent injury and/or inadvertent dose administration to the '
          'individual administering the dose. Accidental injection into the digits, '
          'hand, or feet may result in the loss of blood flow to the affected area. '
          'Do not inject into the buttock area.',
      'INTRANASAL USE: Common side effects reported in pediatric studies include '
          'nasal discomfort, intranasal paresthesia, rhinorrhea, sneezing, '
          'paresthesia, fatigue, and feeling jittery. This dosage form may alter the '
          'nasal mucosa for up to 2 weeks after use by potentially increasing the '
          'systemic absorption of other nasal medications to increase their risk of '
          'adverse reactions. Neffy comes as a 2% or 20 mg/1 mL concentration nasal '
          'product and is indicated for anaphylaxis. A lower concentration nasal '
          'solution product (0.1% or 1 mg/1 mL) is indicated for nasal congestion '
          'and should NOT be used for anaphylaxis.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 978–980',
  ),
  // EPINEPHRINE, RACEMIC — PDF p. 172 (printed 981)
  DrugEntryV3(
    name: 'EPINEPHRINE, RACEMIC',
    brandNames: 'Asthmanefrin and S-2',
    drugClass: 'Sympathomimetic agent',
    iconRow: '',
    formulations: [
      'Solution for inhalation (OTC): 2.25% (1.25% epinephrine base) (0.5 mL) '
          '(30s)',
      'Contains edetate disodium and may contain sulfites',
    ],
    doseSections: [
      DoseSection(
        heading: '<4 yr:',
        lines: [
          DoseLine('Croup (using 2.25% solution): 0.05–0.1 mL/kg/dose up to a max. dose of '
              '0.5 mL/dose diluted to 3 mL with NS. Given via nebulizer over 15 min PRN '
              'but not more frequently than Q1–2 hr.'),
        ],
      ),
      DoseSection(
        heading: '≥4 yr:',
        lines: [
          DoseLine('0.5 mL/dose diluted to 3 mL with NS via nebulizer over 15 min Q3–4 hr PRN'),
        ],
      ),
    ],
    remarks: [
      'Tachyarrhythmias, headache, nausea, palpitations have been reported. '
          'Rebound symptoms may occur. Cardiorespiratory monitoring should be '
          'considered if administered more frequently than Q1–2 hr.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 981',
  ),
  // EPOETIN ALFA — PDF p. 172–173 (printed 981–982)
  DrugEntryV3(
    name: 'EPOETIN ALFA',
    brandNames: 'Epogen, Procrit, Retacrit, and Erythropoietin',
    drugClass: 'Recombinant human erythropoietin',
    iconRow: '',
    formulations: [
      'Injection (single-dose, preservative-free vials): 2000, 3000, 4000, '
          '10,000, 40,000 U/mL (1 mL); contains phenylalanine',
      'Injection (multidose vials): 10,000 U/mL (2 mL), 20,000 U/mL (1 mL); '
          'contains 1% benzyl alcohol',
      'All dosage forms contain 2.5 mg albumin per 1 mL.',
      'NOTE: Epoetin alfa-epbx (Retacrit) is a biosimilar product.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Anemia in chronic renal failure (see remarks for dosage adjustment '
            'and withholding therapy):',
        lines: [
          DoseLine('SC/IV (IV preferred for hemodialysis patients)'),
          DoseLine(
            'Initial dose:',
            isHeading: true,
          ),
          DoseLine('Child and adolescent ≤16 yr: Start at 50 U/kg/dose 3 times per week. '
              'Reported dosage range for children (3 mo–20 yr) not requiring dialysis: '
              '50–250 U/kg/dose 3 times per week. Reported dosage range for children '
              'receiving hemodialysis: 50–450 U/kg/dose 2–3 times per week.'),
          DoseLine('Adolescent >16 yr and adult: Start at 50–100 U/kg/dose 3 times per week'),
          DoseLine('Maintenance dose: Dose is individualized to achieve and maintain the '
              'lowest Hgb level sufficient to avoid transfusions and not to exceed the '
              'following levels:'),
          DoseLine('Child ≤16 yr (receiving or not receiving dialysis): 12 g/dL'),
          DoseLine('Adolescent >16 yr and adult:'),
          DoseLine('Receiving dialysis: 11 g/dL'),
          DoseLine('Not receiving dialysis: 10 g/dL'),
        ],
      ),
      DoseSection(
        heading: 'Anemia in cancer (use until chemotherapy is completed; see remarks '
            'for dosage reduction and withholding therapy):',
        lines: [
          DoseLine(
            'Initial dose:',
            isHeading: true,
          ),
          DoseLine('Child (5–18 yr): Start at 600 U/kg (max. dose: 40,000 U) IV once weekly'),
          DoseLine('Adult: Start at 40,000 U SC once every week or 150 U/kg/dose SC 3 times '
              'per week'),
          DoseLine(
            'Increasing doses (if needed):',
            isHeading: true,
          ),
          DoseLine(
            'Weekly dosing regimen: If no increase in Hgb >1 g/dL and Hgb remains <10 '
                'g/dL after initial 4 wk of therapy:',
            isHeading: true,
          ),
          DoseLine('Child: Increase dose to 900 U/kg/dose IV (max. dose: 60,000 U) once weekly'),
          DoseLine('Adult: 60,000 U SC once weekly'),
          DoseLine('Three-times-a-week dosing regimen (adult): If no increase in Hgb >1 g/dL '
              'and Hgb remains <10 g/dL after initial 4 wk of therapy, increase dosage '
              'to 300 U/kg/dose 3 times per week.'),
          DoseLine('For all ages, discontinue use after 8 wk of therapy if transfusions are '
              'still required or no hemoglobin response is observed.'),
        ],
      ),
      DoseSection(
        heading: 'Anemia of prematurity (many regimens exist):',
        lines: [
          DoseLine('250 U/kg/dose SC 3 times per wk × 10 doses; alternatively, 200–400 '
              'U/kg/dose IV/SC 3–5 times per week for 2–6 wk (total dose per week is '
              '600–1400 U/kg). Administer with supplemental iron at 3–6 mg elemental '
              'iron/kg/24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Use the lowest dose to avoid transfusions.',
      'Increased risk for death, serious cardiovascular events, and '
          'thrombosis/stroke have been reported with treatment in patients with '
          'chronic kidney disease and hemoglobin levels >11 g/dL. Increased risk for '
          'death, shortened survival and/or shortened time to tumor '
          'progression/regression, serious cardiovascular events, and thrombosis in '
          'various cancer patients, especially with Hgb levels >12 g/dL, have been '
          'reported with epoetin alfa and other erythropoiesis-stimulating agents.',
      'Evaluate serum iron, ferritin, TIBC before therapy. Iron supplementation '
          'recommended during therapy unless iron stores are already in excess. '
          'Monitor Hct, BP, clotting times, platelets, BUN, serum creatinine. Peak '
          'effect in 2–3 wk.',
      'DOSAGE ADJUSTMENT FOR ANEMIA IN CHRONIC RENAL FAILURE:',
      'Reduce dose by ≥25%: When Hgb increases >1 g/dL in any 2-wk period. Dose '
          'reductions can be made more frequently than once every 4 wk if needed.',
      'Increase dose by 25%: When Hgb does not increase by 1 g/dL after 4 wk of '
          'therapy. Dosage increments should not be made more frequently than once '
          'every 4 wk.',
      'Withhold therapy: When Hgb exceeds the age- and dialysis-specific maximum '
          'level, restart therapy at a 25% lower dose after Hgb decreases below the '
          'age- and dialysis-specific maximum level.',
      'Inadequate response after a 12-week dose escalation: Use minimum '
          'effective dosage that will maintain hemoglobin levels to avoid the need '
          'for recurrent blood transfusions, and evaluate other causes of anemia. '
          'Discontinue use if patient remains transfusion dependent.',
      'DOSAGE REDUCTION ADJUSTMENT/WITHHOLDING THERAPY FOR ANEMIA IN CANCER:',
      'If Hgb exceeds a level needed to avoid blood transfusion: Withhold dose '
          'and resume therapy at a dosage reduced by 25% when Hgb approaches a level '
          'where blood transfusions may be needed.',
      'If Hgb increases >1 g/dL in any 2-wk period or Hgb reaches a level to '
          'avoid blood transfusion: Reduce dose by 25%.',
      'May cause hypertension, seizure, hypersensitivity reactions, headache, '
          'edema, and dizziness. SC route provides sustained serum levels compared '
          'to IV route. For IV administration, infuse over 1–3 min.',
      'Do not use multidose-vial preparation for neonates, infants, and '
          'pregnant/breastfeeding mothers because of concerns for benzyl alcohol.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 981–982',
  ),
  // EPOPROSTENOL — PDF p. 173–174 (printed 982–983)
  DrugEntryV3(
    name: 'EPOPROSTENOL',
    brandNames: 'Flolan, Veletri, and generics, PGI₂, PGX, prostacyclin',
    drugClass: 'Prostaglandin I₂, vasodilator',
    iconRow: '',
    formulations: [
      'Injection: 0.5, 1.5 mg',
      'Flolan: Reconstitute with provided pH 12 sterile diluent for Flolan (50 '
          'mL)',
      'Veletri (available only via designated specialty outpatient pharmacies): '
          'Reconstitute with sterile water for injection or 0.9% sodium chloride',
      'Generic: Reconstitute with provided sterile diluent for epoprostenol '
          'sodium (50 mL) or with sterile water for injection or 0.9% sodium '
          'chloride (product specific)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Pulmonary Hypertension (limited data):',
        lines: [
          DoseLine('IV Infusion via central-line and 0.22-micron filter: Start at 1–2 '
              'nanograms/kg/min IV. Increase by 0.5–2 nanograms/kg/min Q45 min as needed '
              'and tolerated. Avoid abrupt withdrawal, interruptions in delivery, or '
              'sudden large decreases in dosage.'),
          DoseLine(
            'Usual effective dose:',
            isHeading: true,
          ),
          DoseLine('Neonate: 20–40 nanograms/kg/min'),
          DoseLine('Infant, child, and adolescent: 40 to >150 nanograms/kg/min (average 80 '
              'nanograms/kg/min)'),
          DoseLine('Downtitration of dosage is required in the presence of high-output state '
              '(hyperdynamic right ventricle).'),
          DoseLine(
            'Inhalation route (very limited data; use injectable dosage form by '
                'diluting with the respective product’s diluent per institutional-specific '
                'guidelines):',
            isHeading: true,
          ),
          DoseLine('Neonate: 10–50 nanograms/kg/min via continuous nebulization at a rate of '
              '8 mL/hr OR 50 nanograms/kg/min diluted in 3 mL Q2 hr via intermittent '
              'nebulization has been reported. Doses as high as 100 nanograms/kg/min '
              'have been reported.'),
          DoseLine('Child: 20–50 nanograms/kg/min via continuous nebulization has been '
              'reported.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in heart failure caused by decreased left ventricular '
          'ejection fraction. Use with caution in bleeding disorders; inhibits '
          'platelet aggregation.',
      'Dose-dependent side effects of nausea, diarrhea, jaw pain, bone pain, and '
          'headaches are common. Other common side effects include hypotension, '
          'flushing, diarrhea, loss of appetite, and chest and musculoskeletal pain. '
          'Reported complications include sepsis, local site infection, and catheter '
          'dislodgement resulting in severe sepsis or rebound pulmonary hypertension '
          '(avoid abrupt dose withdrawal and monitor for IV line interruptions). '
          'Hypoxia, flushing, and tachycardia may suggest an overdose.',
      'Use with medications exhibiting antiplatelet effects (e.g., SSRI '
          'antidepressants, desvenlafaxine, venlafaxine, duloxetine, NSAIDs, and '
          'anticoagulants) may increase risk for bleeding. May increase digoxin '
          'levels.',
      'Systemic T₁/₂ is 2–5 min. Continuous IV infusion is administered via '
          'central venous catheter with a 0.22-micron filter. Medication temperature '
          'stability requirements and the use of icepacks are product specific; '
          'consult with a pharmacist.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 982–983',
  ),
  // ERGOCALCIFEROL — PDF p. 174–175 (printed 983–984)
  DrugEntryV3(
    name: 'ERGOCALCIFEROL',
    brandNames: 'Drisdol and generics; previously available as calcidol',
    drugClass: 'Vitamin D₂',
    iconRow: '',
    formulations: [
      'Caps:',
      'Drisdol and generics [OTC]: 50,000 IU (1.25 mg)',
      'Tabs [OTC]: 400, 2000, 2400 IU',
      'Drops [OTC]: 8000 IU/mL (200 mCg/mL) (60 mL); contain propylene glycol',
      'Conversion: 1 mg = 40,000 IU vitamin D activity',
    ],
    doseSections: [
      DoseSection(
        heading: 'Dietary supplementation (see Chapter 21 for additional information):',
        lines: [
          DoseLine('Preterm neonate: 200–400 IU/24 hr PO'),
          DoseLine('Term neonate and infant (<1 yr) (breastfed or receiving <32 oz formula): '
              '400 IU/24 hr PO'),
          DoseLine('Child (≥1 yr) and adolescent: 400–600 IU/24 hr PO'),
        ],
      ),
      DoseSection(
        heading: 'Renal failure (CKD stages 2–5) and 25-OH vitamin D levels <30 ng/mL '
            '(monitor serum 25-OH vitamin D and corrected calcium/phosphorus 1 mo '
            'after initiation and Q3 mo thereafter):',
        lines: [
          DoseLine(
            '25-OH vitamin D <5 ng/mL:',
            isHeading: true,
          ),
          DoseLine('Child: 8000 IU/24 hr PO × 4 wk, followed by 4000 IU/24 hr PO × 2 mo or '
              '50,000 IU weekly × 4 wk, followed by 50,000 IU twice monthly for 2 mo'),
          DoseLine(
            '25-OH vitamin D 5–15 ng/mL:',
            isHeading: true,
          ),
          DoseLine('Child: 4000 IU/24 hr PO × 12 wk or 50,000 IU every other wk × 12 wk'),
          DoseLine(
            '25-OH vitamin D 16–30 ng/mL:',
            isHeading: true,
          ),
          DoseLine('Child: 2000 IU/24 hr PO × 3 mo or 50,000 IU every mo × 3 mo'),
        ],
      ),
      DoseSection(
        heading: 'Nutritional rickets:',
        lines: [
          DoseLine('Child and adult with normal GI absorption: 2000–5000 IU/24 hr PO × 6–12 wk'),
          DoseLine(
            'Malabsorption:',
            isHeading: true,
          ),
          DoseLine('Child: 10,000–25,000 IU/24 hr PO'),
          DoseLine('Adult: 10,000–300,000 IU/24 hr PO'),
        ],
      ),
      DoseSection(
        heading: 'Vitamin D–resistant rickets (with phosphate supplementation):',
        lines: [
          DoseLine('Child: Initial dose 40,000–80,000 IU/24 hr PO; increase daily dose by '
              '10,000–20,000 IU PO Q3–4 mo if needed'),
          DoseLine('Adult: 10,000–60,000 IU/24 hr PO'),
        ],
      ),
      DoseSection(
        heading: 'Hypoparathyroidism (with calcium supplementation):',
        lines: [
          DoseLine('Child: 50,000–200,000 IU/24 hr PO'),
          DoseLine('Adult: 25,000–200,000 IU/24 hr PO'),
        ],
      ),
    ],
    remarks: [
      'Consider using cholecalciferol instead; cholecalciferol has been shown to '
          'be more biologically potent, with better absorption than ergocalciferol. '
          'Vitamin D₂ is activated by 25-hydroxylation in liver and 1-hydroxylation '
          'in kidney to the active form, calcitriol.',
      'Monitor serum Ca²⁺, PO₄, 25-OH vitamin D (goal level for infant and '
          'child: ≥20 ng/mL), and alkaline phosphate. Serum Ca²⁺, PO₄ product should '
          'be <70 mg/dL to avoid ectopic calcification. Titrate dosage to patient '
          'response. Watch for symptoms of hypercalcemia: weakness, diarrhea, '
          'polyuria, metastatic calcification, nephrocalcinosis.',
      'Serum 25-OH vitamin D level of ≥35 ng/mL has been suggested in cystic '
          'fibrosis patients to decrease the risk of hyperparathyroidism and bone '
          'loss.',
    ],
    pregnancyNote: 'Pregnancy category changes to “C” if used in doses above the U.S. '
        'RDA.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 983–984',
  ),
  // ERGOTAMINE TARTRATE ± CAFFEINE — PDF p. 175–176 (printed 984–985)
  DrugEntryV3(
    name: 'ERGOTAMINE TARTRATE ± CAFFEINE',
    brandNames: 'Ergomar\nIn combination with caffeine: Migergot and generics; '
        'previously available as Cafergot',
    drugClass: 'Ergot alkaloid',
    iconRow: '',
    formulations: [
      'Sublingual tabs (Ergomar): 2 mg',
      'In combination with caffeine:',
      'Tabs: 1 mg and 100 mg caffeine',
      'Suppository (Migergot): 2 mg and 100 mg caffeine (12s)',
    ],
    doseSections: [
      DoseSection(
        heading: 'ERGOTAMINE:',
      ),
      DoseSection(
        heading: 'Adolescent and adult:',
        lines: [
          DoseLine('SL: 2 mg at onset of migraine attack, then 2 mg Q30 min PRN up to max. '
              'dose of 6 mg/24 hr; do not exceed 10 mg/wk'),
        ],
      ),
      DoseSection(
        heading: 'ERGOTAMINE PLUS CAFFEINE:',
        lines: [
          DoseLine('Doses based on mg of ergotamine'),
          DoseLine(
            'Oral tablet:',
            isHeading: true,
          ),
          DoseLine('Adolescent and adult: 1 or 2 mg PO at onset of migraine attack, then 1 mg '
              'Q30 min up to 6 mg per attack, not to exceed 10 mg/wk'),
          DoseLine(
            'Suppository:',
            isHeading: true,
          ),
          DoseLine('Adolescent: 1 mg (0.5 suppository) at first sign of attack; follow with '
              'second 1-mg dose after 45 min if needed; max. dose: 2 mg per attack, 4 '
              'mg/24 hr, not to exceed 8 mg/wk'),
          DoseLine('Adult: 2 mg at first sign of attack; follow with second 2-mg dose after 1 '
              'hr if needed; max. dose: 4 mg per attack, not to exceed 10 mg/wk'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in renal or hepatic disease. May cause paresthesias, GI '
          'disturbance, angina-like pain, rebound headache with abrupt withdrawal, '
          'or muscle cramps. Contraindicated in pregnancy and has not been '
          'recommended in breastfeeding. Concurrent administration with protease '
          'inhibitors, clarithromycin, erythromycin, other cytochrome P-450 3A4 '
          'inhibitors, and nitroglycerin are contraindicated owing to risk of '
          'ergotism (nausea, vomiting, vasospastic ischemia leading to cerebral and '
          'peripheral ischemia).',
      'For sublingual (SL) administration, place tablet under the tongue and do '
          'not crush.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 984–985',
  ),
  // ERTAPENEM — PDF p. 176–177 (printed 985–986)
  DrugEntryV3(
    name: 'ERTAPENEM',
    brandNames: 'Invanz and generics',
    drugClass: 'Antibiotic, carbapenem',
    iconRow: '',
    formulations: [
      'Injection: 1 g',
      'Contains ∼6 mEq Na/g drug',
    ],
    doseSections: [
      DoseSection(
        heading: '≥1 mo–12 yr:',
        lines: [
          DoseLine('15 mg/kg/dose IV/IM Q12 hr; max. dose: 1 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adolescent and adult:',
        lines: [
          DoseLine('1 g IV/IM Q24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Recommended duration of therapy (all ages):',
        lines: [
          DoseLine('Complicated intra-abdominal infection: 5–14 days or 4–7 days with source '
              'control'),
          DoseLine('Complicated skin/subcutaneous tissue infections: 7–14 days'),
          DoseLine('Diabetic foot infection without osteomyelitis: 14–28 days'),
          DoseLine('Community-acquired pneumonia, complicated UTI/pyelonephritis: 10–14 days'),
          DoseLine('Acute pelvic infection: 3–10 days'),
          DoseLine('UTI: 5–10 days; 7–10 days for complicated UTI and pyelonephritis'),
        ],
      ),
      DoseSection(
        heading: 'Surgical prophylaxis:',
        lines: [
          DoseLine('Child and adolescent: 15 mg/kg (max. dose: 1 g/dose) IV 1 hr before '
              'procedure'),
          DoseLine('Adult (colorectal surgery): 1 g IV 1 hr before procedure'),
        ],
      ),
    ],
    remarks: [
      'Ertapenem has poor activity against P. aeruginosa, Acinetobacter, MRSA, '
          'and Enterococcus. Do not use in meningitis due to poor CSF penetration. '
          'Use with caution with CNS disorders, including seizures. Adjust dosage in '
          'renal impairment (see Chapter 32).',
      'Diarrhea, infusion complications, nausea, headache, vaginitis, '
          'phlebitis/thrombophlebitis, and vomiting are common. Seizures (primarily '
          'with renal insufficiency and/or CNS disorders such as brain lesions and '
          'seizures), decreased consciousness, muscle weakness, gait disturbance, '
          'abnormal coordination, teeth staining, hypersensitivity vasculitis, and '
          'DRESS syndrome have been reported. Increased ALT, AST, and neutropenia '
          'have been reported in pediatric clinical trials. Decreases valproic acid '
          'levels. Probenecid may increase ertapenem levels.',
      'IM route requires reconstitution with 1% lidocaine; this formulation '
          'should not be administered by IV. Do not reconstitute or co-infuse with '
          'dextrose-containing solutions.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 985–986',
  ),
  // ERYTHROMYCIN PREPARATIONS — PDF p. 177–178 (printed 986–987)
  DrugEntryV3(
    name: 'ERYTHROMYCIN PREPARATIONS',
    brandNames: 'Erythromycin, EES, EryPed, Ery-Tab, Erythrocin, and generics\n'
        'Ophthalmic ointment: Generics; previously available as Ilotycin\n'
        'Topical gel: Ery, Erygel, and generics',
    drugClass: 'Antibiotic, macrolide',
    iconRow: '',
    formulations: [
      'Erythromycin base:',
      'Tabs: 250, 500 mg',
      'Delayed-release tabs (Ery-Tab and generics): 250, 333, 500 mg',
      'Delayed-release caps: 250 mg',
      'Topical gel (Erygel and generics): 2% (30, 60 g); contains alcohol 92%',
      'Topical solution: 2% (60 mL); may contain 44%–66% alcohol',
      'Topical pad/swab (Ery): 2% (60s); may contain propylene glycol and alcohol',
      'Ophthalmic ointment: 0.5% (1, 3.5 g)',
      'Erythromycin ethylsuccinate (EES):',
      'Oral suspension (EES, EryPed, and generics): 200 mg/5 mL (100, 200 mL), '
          '400 mg/5 mL (100 mL)',
      'Tabs (EES and generics): 400 mg',
      'Erythromycin stearate (Erythrocin stearate):',
      'Tabs: 250 mg',
      'Erythromycin lactobionate (Erythrocin and generics):',
      'Injection: 500 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Oral:',
        lines: [
          DoseLine(
            'Neonate (anti-infective indication; use EES preparation; see remarks for '
                'safety concerns):',
            isHeading: true,
          ),
          DoseLine('<1.2 kg: 20 mg/kg/24 hr PO ÷ Q12 hr'),
          DoseLine(
            '≥1.2 kg:',
            isHeading: true,
          ),
          DoseLine('0–7 days: 20 mg/kg/24 hr PO ÷ Q12 hr'),
          DoseLine(
            '>7 days:',
            isHeading: true,
          ),
          DoseLine('1.2–2 kg: 30 mg/kg/24 hr PO ÷ Q8 hr'),
          DoseLine('≥2 kg: 30–40 mg/kg/24 hr PO ÷ Q6–8 hr'),
          DoseLine('Chlamydial conjunctivitis and pneumonia: 50 mg/kg/24 hr PO ÷ Q6 hr × 14 '
              'days; max. dose: 2 g/24 hr'),
          DoseLine('Child (use base, EES, or stearate preparation): 30–50 mg/kg/24 hr PO ÷ '
              'Q6–8 hr; max. dose: 4 g/24 hr'),
          DoseLine('Pertussis: 40–50 mg/kg/24 hr PO ÷ Q6 hr × 14 days (max. dose: 2 g/24 hr); '
              'use azithromycin for infants <1 mo old'),
          DoseLine('Adult: 2 g/24 hr PO ÷ Q6 hr × 14 days'),
        ],
      ),
      DoseSection(
        heading: 'Parenteral:',
        lines: [
          DoseLine('Child and adult: 15–20 mg/kg/24 hr IV ÷ Q6 hr; max. dose: 4 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Ophthalmic:',
        lines: [
          DoseLine('Neonatal gonococcal ophthalmia prophylaxis: Apply 1-cm ribbon to both '
              'eyes × 1'),
          DoseLine(
            'Conjunctivitis:',
            isHeading: true,
          ),
          DoseLine('Infant, child, and adolescent: Apply 1-cm ribbon to affected eye(s) up to '
              '6 times daily. Some recommend administering to affected eye(s) QID for 7 '
              'days.'),
        ],
      ),
      DoseSection(
        heading: 'Preoperative bowel prep:',
        lines: [
          DoseLine('20 mg/kg/dose (max. dose: 1000 mg/dose) PO erythromycin base × 3 doses '
              'with neomycin 1 day before surgery'),
        ],
      ),
      DoseSection(
        heading: 'Prokinetic agent:',
        lines: [
          DoseLine('Infant and child: 10–20 mg/kg/24 hr PO ÷ TID–QID (QAC or QAC and QHS)'),
        ],
      ),
      DoseSection(
        heading: 'Topical (administer doses after washing skin with warm water and soap '
            'and patting it dry):',
        lines: [
          DoseLine(
            'Acne (≥7 yr–adolescent; typically not used as monotherapy):',
            isHeading: true,
          ),
          DoseLine('Topical gel: Apply to affected area once daily–BID; discontinue use after '
              '8 wk if no improvement or worsening of condition'),
          DoseLine('Topical solution or pad: Apply to affected area BID (morning and evening)'),
        ],
      ),
    ],
    remarks: [
      'Avoid use in patients with known Q–T prolongation, proarrhythmic '
          'conditions (e.g., hypokalemia, hypomagnesemia, significant bradycardia), '
          'and receiving class IA or class III antiarrhythmic agents, HMG-CoA '
          'reductase inhibitors metabolized by cytochrome P-450 (CYP) 3A4 (e.g., '
          'lovastatin or simvastatin; increases risk for myopathy and '
          'rhabdomyolysis), cisapride, or pimozide. Hypertrophic pyloric stenosis in '
          'neonates receiving prophylactic therapy for pertussis, life-threatening '
          'episodes of ventricular tachycardia associated with prolonged Q–Tc '
          'interval, and exacerbation of myasthenia gravis have been reported. May '
          'produce false-positive urinary catecholamines, 17-hydroxycorticosteroids, '
          'and 17-ketosteroids.',
      'GI side effects common (nausea, vomiting, abdominal cramps). Cardiac '
          'dysrhythmia, anaphylaxis, interstitial nephritis, and hearing loss have '
          'been reported. Use with caution in liver disease. Estolate formulation '
          'may cause cholestatic jaundice, although hepatotoxicity is uncommon (2% '
          'of reported cases). Inhibits CYP1A2, 3A3/3A4 isoenzymes. May produce '
          'elevated digoxin, theophylline, carbamazepine, clozapine, cyclosporine, '
          'and methylprednisolone levels. Adjust dose in renal failure (see Chapter '
          '32). Use ideal body weight for obese patients when calculating doses.',
      'Oral therapy should replace IV as soon as possible. Give oral doses after '
          'meals. Because of different absorption characteristics, higher oral doses '
          'of EES are needed to achieve therapeutic effects. Avoid IM route (pain, '
          'necrosis). For ophthalmic use, avoid contact of ointment container tip '
          'with eye or skin.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 986–987',
  ),
  // ERYTHROPOIETIN — PDF p. 178 (printed 987)  [cross-reference]
  DrugEntryV3(
    name: 'ERYTHROPOIETIN',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Epoetin Alfa',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 987',
  ),
  // ESCITALOPRAM — PDF p. 178–179 (printed 987–988)
  DrugEntryV3(
    name: 'ESCITALOPRAM',
    brandNames: 'Lexapro and generics',
    drugClass: 'Antidepressant, selective serotonin reuptake inhibitor',
    iconRow: '',
    formulations: [
      'Tabs: 5, 10, 20 mg',
      'Oral solution: 1 mg/mL (240 mL); contains parabens and propylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Depression:',
        lines: [
          DoseLine('<12 yr: Limited data, only one placebo-controlled RCT did not demonstrate '
              'efficacy'),
          DoseLine('≥12 yr and adolescent: Start with 10 mg PO once daily. If needed after 3 '
              'wk, dose may be increased to 20 mg once daily.'),
          DoseLine('Adult: Start with 10 mg PO once daily. If needed after 1 wk, dose may be '
              'increased to 20 mg once daily.'),
        ],
      ),
      DoseSection(
        heading: 'Autism and pervasive developmental disorders (PDD; limited data)',
        lines: [
          DoseLine('6–17 yr: A 10-wk open-label trial in which 28 subjects were given a '
              'weekly PRN increasing PO dosage regimen of 2.5, 5, 10, 15, and 20 mg/24 '
              'hr. Mean dosage of responders with significant improvement at 11.1 ± 6.5 '
              'mg/24 hr; 25% of subjects responded at doses <10 mg/24 hr, and 36% '
              'responded at doses ≥10 mg/24 hr. Seven of the 17 (41%) responders and 25% '
              'of all treated subjects could not tolerate the 10 mg/24 hr dose.'),
        ],
      ),
      DoseSection(
        heading: 'Social anxiety disorder (limited data):',
        lines: [
          DoseLine('10–17 yr: A 12-wk open-label trial in which 20 subjects were given an '
              'initial PO dosage of 5 mg once daily × 7 days, followed by 10 mg once '
              'daily. If needed and tolerated, increased by 5 mg/24 hr at weekly '
              'intervals up to a maximum of 20 mg/24 hr. Two subjects did not complete '
              'the trial due to lack of efficacy and tolerability. Sixty-five percent of '
              'the remaining subjects met the response criteria with a mean final dose '
              'of 13 ± 4.1 mg/24 hr. Common adverse events included somnolence (25%), '
              'insomnia (20%), flu symptoms (15%), increased appetite (15%), and '
              'decreased appetite (15%).'),
        ],
      ),
    ],
    remarks: [
      'Increased risk for serotonin syndrome when used with MAO inhibitors (or '
          'within 14 days of discontinuance), linezolid, or methylene blue; '
          'concurrent use considered contraindicated. Do not use with pimozide '
          'because of risk for increased Q–Tc interval. Use with caution with '
          'hepatic or severe renal impairment; dosage adjustment may be needed. '
          'Avoid abrupt discontinuation to prevent withdrawal symptoms.',
      'Diaphoresis, GI discomfort, xerostomia, dizziness, headache, insomnia, '
          'somnolence, sexual dysfunction, and fatigue are common side effects. '
          'Abnormal bleeding, depression, Q–Tc prolongation, and suicidal ideation '
          '(especially during initiation of therapy and with any dosage change) have '
          'been reported. Mixed/manic episode may occur when treating a depressive '
          'episode in patients with bipolar disorders. Use during pregnancy in the '
          'month before delivery may be associated with increase risk of postpartum '
          'hemorrhage.',
      'Primarily metabolized by the cytochrome P-450 2C19 and 3A4 enzymes and is '
          'a weak inhibitor for CYP2D6 enzyme. Consider an alternative medication '
          '(not significantly metabolized by CYP2C19) for individuals with '
          'ultra-rapid CYP2C19 activity. Poor CYP2C19 metabolizers can either '
          'initiate therapy at 50% of the usual dose and titrate to response or '
          'consider alternative therapy.',
      'Taking with other medications with Q–Tc prolongation or bleeding '
          'characteristics may further increase their respective risks. Omeprazole '
          'may increase the toxicity of escitalopram. Doses may be administered with '
          'or without food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 987–988',
  ),
  // ESMOLOL HCL — PDF p. 179–180 (printed 988–989)
  DrugEntryV3(
    name: 'ESMOLOL HCL',
    brandNames: 'Brevibloc and generics',
    drugClass: 'β₁-selective adrenergic blocking agent, antihypertensive agent, '
        'class II antiarrhythmic',
    iconRow: '',
    formulations: [
      'Injection: 10 mg/mL (10 mL); preservative free',
      'Injection, premixed infusion in iso-osmotic sodium chloride: 2000 mg/100 '
          'mL (100 mL), 2500 mg/250 mL (250 mL); preservative free',
      'Injection, premixed infusion in iso-osmotic water for injection: 2000 '
          'mg/100 mL (100 mL), 2500 mg/250 mL (250 mL); contains ethanol, propylene '
          'glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Postoperative hypertension:',
        lines: [
          DoseLine('Titrate to response (limited information):'),
          DoseLine('Loading dose: 500 mCg/kg IV over 1 min'),
          DoseLine('Maintenance dose: 50–250 mCg/kg/min IV as infusion. Titrate doses upward '
              '50–100 mCg/kg/min Q5–10 min as needed. Heart surgery patients may require '
              'higher doses (∼700 mCg/kg/min). Dosages as high as 1000 mCg/kg/min have '
              'been reported in children 1–12 yr.'),
        ],
      ),
      DoseSection(
        heading: 'SVT:',
        lines: [
          DoseLine('Titrate to response (limited information).'),
          DoseLine('Loading dose: 100–500 mCg/kg IV over 1 min'),
          DoseLine('Maintenance dose: 25–100 mCg/kg/min IV as infusion. Titrate doses upward '
              '50–100 mCg/kg/min Q5–10 min as needed. Dosages as high as 1000 mCg/kg/min '
              'have been reported.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in sinus bradycardia, >first-degree heart block, and '
          'cardiogenic shock or heart failure. Short duration of action; T₁/₂ = '
          '2.9–4.7 min for children and 9 min for adults. May cause bronchospasm, '
          'congestive heart failure, hypotension (at doses >200 mCg/kg/min), nausea, '
          'and vomiting. May increase digoxin (by 10%–20%) and theophylline levels. '
          'Morphine may increase esmolol level by 46%. Theophylline may decrease '
          'esmolol’s effects. Use with IV cardiodepressant calcium channel '
          'antagonists (e.g., verapamil) may cause cardiovascular collapse.',
      'Administer only in a monitored setting. Concentration for administration '
          'is typically ≤10 mg/mL, but 20 mg/mL has been administered in pediatric '
          'patients.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 988–989',
  ),
  // ESOMEPRAZOLE — PDF p. 180–181 (printed 989–990)
  DrugEntryV3(
    name: 'ESOMEPRAZOLE',
    brandNames: 'Nexium, Nexium 24HR, and generics',
    drugClass: 'Gastric acid proton pump inhibitor',
    iconRow: '',
    formulations: [
      'Caps, delayed release:',
      'Nexium and generics: 20, 40 mg; contains magnesium (some generic products '
          'may contain strontium instead)',
      'Nexium 24 HR [OTC]: 20 mg',
      'Nexium 24 HR Clear Minis [OTC]: 20 mg',
      'Tab, delayed release:',
      'Nexium 24 HR [OTC]: 20 mg; contains magnesium',
      'Powder for oral suspension:',
      'Nexium and generics: 2.5, 5, 10, 20, 40 mg packets (30s); contains '
          'magnesium',
      'Injection: 40 mg; contains EDTA',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child (PO):',
        lines: [
          DoseLine(
            'GERD (use for 4–8 wk):',
            isHeading: true,
          ),
          DoseLine('Weight-based dosage: 0.7–3.3 mg/kg/24 hr once daily; max. dose: 40 mg/24 '
              'hr; alternative fixed dosage:'),
          DoseLine('<20 kg: 10 mg once daily'),
          DoseLine('≥20 kg: 20 mg once daily'),
          DoseLine(
            'Erosive esophagitis in GERD:',
            isHeading: true,
          ),
          DoseLine(
            'Infant (1 mo to <1 yr; use for up to 6 wk):',
            isHeading: true,
          ),
          DoseLine('3–5 kg: 2.5 mg once daily'),
          DoseLine('>5–7.5 kg: 5 mg once daily'),
          DoseLine('>7.5 kg: 10 mg once daily'),
          DoseLine(
            '1–11 yr (use for 8 wk):',
            isHeading: true,
          ),
          DoseLine('<20 kg: 10 mg once daily'),
          DoseLine('≥20 kg: 10 or 20 mg once daily'),
          DoseLine('12–17 yr: 20 or 40 mg once daily for 4–8 wk'),
        ],
      ),
      DoseSection(
        heading: 'Child (IV):',
        lines: [
          DoseLine(
            'GERD with erosive esophagitis:',
            isHeading: true,
          ),
          DoseLine('Infant: 0.5–1 mg/kg/dose once daily'),
          DoseLine(
            'Child 1–17 yr:',
            isHeading: true,
          ),
          DoseLine('<55 kg: 10 mg once daily'),
          DoseLine('≥55 kg: 20–40 mg once daily'),
        ],
      ),
      DoseSection(
        heading: 'Adult (PO/IV):',
        lines: [
          DoseLine('GERD: 20 mg once daily'),
          DoseLine('GERD with erosive esophagitis: 20 or 40 mg once daily × 4–8 wk'),
          DoseLine('Prevention of NSAID-induced gastric ulcers: 20 or 40 mg once daily for up '
              'to 6 mo'),
          DoseLine('Pathological hypersecretory conditions (e.g., Zollinger-Ellison '
              'syndrome): 40 mg BID; doses up to 240 mg/24 hr have been used.'),
          DoseLine('Hepatic impairment: Patients with severe hepatic function impairment '
              '(Child-Pugh class C) should not exceed 20 mg/24 hr (40 mg/24 hr for '
              'pathological hypersecretory conditions).'),
        ],
      ),
    ],
    remarks: [
      'Cross-allergic reactions with other proton pump inhibitors (e.g., '
          'lansoprazole, pantoprazole, rabeprazole). Use with caution in liver '
          'impairment (see dosage adjustment recommendation in dosing section). GI '
          'disturbances and headache are common. Hypomagnesemia may occur with '
          'continuous use and may lead to hypocalcemia and/or hypokalemia. '
          'Anaphylaxis, angioedema, bronchospasm, acute interstitial nephritis, '
          'erythema multiforme, urticaria, Stevens-Johnson syndrome, TEN, '
          'pancreatitis, and fractures of the hip, wrist, and spine (in adults >50 '
          'yr old receiving high doses or prolonged therapy >1 yr) have been '
          'reported. Fundic gland polyps have been associated with long-term use of '
          '>1 yr.',
      'Drug is a substrate and inhibitor of cytochrome P-450 (CYP) 2C19 and '
          'substrate of CYP3A4. May decrease the absorption or effects of '
          'atazanavir, clopidogrel, ketoconazole, itraconazole, mycophenolate '
          'mofetil, and iron salts. May increase the effect/toxicity of diazepam, '
          'midazolam, digoxin, carbamazepine, and warfarin. Voriconazole may '
          'increase the effects of esomeprazole.',
      'May be used in combination with clarithromycin and amoxicillin for '
          'Helicobacter pylori infections.',
      'Administer all oral doses before meals and 30 min before sucralfate (if '
          'receiving). Do not crush or chew capsules. IV doses may be given as fast '
          'as 3 min or infused over 10–30 min.',
    ],
    pregnancyNote: 'Pregnancy category is a “B” for the magnesium-containing product '
        'and a “C” for the strontium-containing product.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 989–990',
  ),
  // ETANERCEPT — PDF p. 181–182 (printed 990–991)
  DrugEntryV3(
    name: 'ETANERCEPT',
    brandNames: 'Enbrel, Enbrel SureClick, Enbrel Mini',
    drugClass: 'Antirheumatic, immunomodulatory agent, tumor necrosis factor '
        'receptor p75 Fc fusion protein',
    iconRow: '',
    formulations: [
      'Prefilled injection (single use): 25 mg (0.5 mL), 50 mg (1 mL); contains '
          'sucrose, L-arginine (preservative free) (carton of 4 prefilled syringes)',
      'Injection (single-dose vial): 25 mg (0.5 mL); contains sucrose, '
          'L-arginine (preservative free) (carton of 4 vials)',
      'Autoinjector:',
      'Enbrel SureClick (single use): 50 mg (1 mL); contains sucrose, L-arginine '
          '(preservative free) (carton of 4 autoinjectors)',
      'Prefilled injection cartridge to be used with Auto Touch reusable '
          'autoinjector device:',
      'Enbrel Mini: 50 mg (1 mL); contains sucrose, L-arginine (preservative '
          'free) (carton of 4 cartridges)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Juvenile idiopathic arthritis and juvenile psoriatic arthritis:',
        lines: [
          DoseLine(
            'Child 2–17 yr:',
            isHeading: true,
          ),
          DoseLine('Once-weekly dosing: 0.8 mg/kg/dose (max. dose: 50 mg/dose with max. '
              'single injection site dose of 25 mg) SC once weekly'),
          DoseLine('Twice-weekly dosing (only for juvenile idiopathic arthritis): 0.4 '
              'mg/kg/dose (max. dose: 25 mg/dose) SC twice weekly administered 72–96 hr '
              'apart'),
        ],
      ),
      DoseSection(
        heading: 'Plaque psoriasis:',
        lines: [
          DoseLine('Child and adolescent (4–17 yr): 0.8 mg/kg/dose (max. dose: 50 mg) SC once '
              'weekly'),
          DoseLine('Adult: Start with 50 mg SC twice weekly administered 72–96 hr apart × 3 '
              'mo, followed by a reduced maintenance dose of 50 mg SC per wk. Starting '
              'doses of 25 mg or 50 mg/wk have also been shown to be effective.'),
          DoseLine('Max. single SC injection site dose: 25 mg'),
        ],
      ),
      DoseSection(
        heading: 'Rheumatoid arthritis, psoriatic arthritis, ankylosing spondylitis:',
        lines: [
          DoseLine('Adult: 25 mg SC twice weekly administered 72–96 hr apart. Alternative '
              'once-weekly dose of 50 mg SC (max. single injection site dose of 25 mg) '
              'may be used.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in serious infections, sepsis, or hypersensitivity to any '
          'of medication components. Use with caution in patients with history of '
          'recurrent infections (including hepatitis B) or underlying conditions '
          'that may predispose them to infections (including concomitant '
          'immunosuppressive therapy), CNS demyelinating disorders, malignancies, '
          'immune-related diseases, and latex allergy. Use in patients with '
          'granulomatosis with polyangiitis receiving immunosuppressive therapy is '
          'not recommended due to the risk for noncutaneous solid malignancies and '
          'no improved clinical outcomes.',
      'Common adverse effects in children include headache, abdominal pain, '
          'vomiting, and nausea. Injection site reactions (e.g., discomfort, '
          'itching, swelling), rhinitis, dizziness, rash, depression, infections '
          '(varicella, aseptic meningitis, rare cases of TB, and fatal/serious '
          'infections and sepsis), bone marrow suppression (e.g., aplastic anemia), '
          'sarcoidosis, vertigo, glomerulonephritis, and CNS demyelinating disorder '
          'have also been reported. Malignancies (some fatal and ∼50% were '
          'lymphomas) have been reported in children and adolescents.',
      'Do not administer live vaccines concurrently with this drug. In JRA, it '
          'is recommended that before initiating therapy, the patient be brought up '
          'to date with all immunizations in agreement with current immunization '
          'guidelines.',
      'Onset of action is 1–4 wk, with peak effects usually within 3 mo.',
      'Patients must be properly instructed on preparing and administering the '
          'medication (see specific product information). For multidose vial, '
          'reconstitute vial by gently swirling its contents with the supplied '
          'diluent (do not shake or vigorously agitate), as some foaming will occur. '
          'Reconstituted solutions should be clear and colorless; unused portions '
          'must be stored in the refrigerator and used within 14 days. Do not store '
          'Auto Touch autoinjector device in the refrigerator.',
      'Drug is administered subcutaneously by rotating injection sites (thigh, '
          'abdomen, or upper arm) with a max. single injection site dose of 25 mg. '
          'Administer new injections ≥1 inch from an old site and NEVER where the '
          'skin is tender, bruised, red, or hard.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 990–991',
  ),
  // ETHAMBUTOL HCL — PDF p. 183 (printed 992)
  DrugEntryV3(
    name: 'ETHAMBUTOL HCL',
    brandNames: 'Generics; previously available as Myambutol',
    drugClass: 'Antituberculosis drug',
    iconRow: '',
    formulations: [
      'Tabs: 100, 400 mg; 400-mg tabs may be scored',
      'Oral suspension: 50 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Tuberculosis (use in combination with other medications; see remarks):',
        lines: [
          DoseLine(
            'Infant, child, adolescent, and adult (see latest CDC guidelines, as '
                'additional dosing schedules exist):',
            isHeading: true,
          ),
          DoseLine('<15 yr and <40 kg: 15–25 mg/kg/dose (max. dose: 1 g/24 hr) PO once daily '
              'or 50 mg/kg/dose PO twice weekly (max. dose: 2.5 g/week)'),
          DoseLine(
            '<15 yr and ≥40 kg, or ≥15 yr:',
            isHeading: true,
          ),
          DoseLine('40–55 kg: 800 mg PO once daily or 5 times weekly'),
          DoseLine('56–75 kg: 1200 mg PO once daily or 5 times weekly'),
          DoseLine('76–90 kg: 1600 mg PO once daily or 5 times weekly'),
        ],
      ),
      DoseSection(
        heading: 'Nontuberculous mycobacterial infection and Mycobacterium avium '
            'complex in AIDS (recurrence prophylaxis or treatment; use in '
            'combination with other medications):',
        lines: [
          DoseLine('Infant and child: 15–25 mg/kg/24 hr PO once daily; max. dose: 2.5 g/24 hr'),
          DoseLine('Adolescent: 15 mg/kg/24 hr PO once daily; max. dose: 2.5 g/24 hr'),
        ],
      ),
    ],
    remarks: [
      'May cause reversible optic neuritis, especially with larger doses. Obtain '
          'baseline ophthalmologic studies before beginning therapy and then '
          'monthly. Follow visual acuity, visual fields, and (red-green) color '
          'vision. Do not use in optic neuritis and in children whose visual acuity '
          'cannot be assessed. Discontinue if any visual deterioration occurs. '
          'Monitor uric acid, liver function, heme status, and renal function. '
          'Hyperuricemia, GI disturbances, and mania are common. Erythema multiforme '
          'and hepatotoxicity have been reported.',
      'Dosing should be based on lean body weight. Coadministration with '
          'aluminum hydroxide can reduce ethambutol’s absorption; space '
          'administration by 4 hr. Give with food. Adjust dose with renal failure '
          '(see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 992',
  ),
  // ETHOSUXIMIDE — PDF p. 183–184 (printed 992–993)
  DrugEntryV3(
    name: 'ETHOSUXIMIDE',
    brandNames: 'Zarontin and generics',
    drugClass: 'Anticonvulsant',
    iconRow: '',
    formulations: [
      'Caps: 250 mg',
      'Oral solution: 250 mg/5 mL (473 mL); may contain sodium benzoate',
    ],
    doseSections: [
      DoseSection(
        heading: 'Oral:',
        lines: [
          DoseLine(
            '≤6 yr:',
            isHeading: true,
          ),
          DoseLine('Initial: 10 mg/kg/24 hr up to 250 mg/24 hr ÷ BID–TID; increase by 5–10 '
              'mg/kg/24 hr as needed Q4–7 days'),
          DoseLine('Usual maintenance dose: 15–40 mg/kg/24 hr ÷ BID–TID'),
          DoseLine('>6 yr and adult: 10 mg/kg/24 hr up to 500 mg/24 hr ÷ BID–TID; increase by '
              '250 mg/24 hr as needed Q4–7 days'),
          DoseLine('Usual maintenance dose: 20–40 mg/kg/24 hr ÷ BID–TID'),
          DoseLine('Max. dose (all ages): The lesser of 60 mg/kg/24 hr or 2 g/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Drug of choice for absence seizures. Use with caution in hepatic and '
          'renal disease. Ataxia, anorexia, drowsiness, sleep disturbances, rashes, '
          'and blood dyscrasias are rare idiosyncratic reactions. May cause '
          'lupuslike syndrome; may increase frequency of grand mal seizures in '
          'patients with mixed-type seizures. Serious dermatological reactions '
          '(e.g., Stevens-Johnson and DRESS) and immune thrombocytopenia have been '
          'reported. May increase risk of suicidal thoughts/behavior. Cases of birth '
          'defects have been reported; ethosuximide crosses the placenta.',
      'Carbamazepine, phenytoin, primidone, phenobarbital, valproic acid, '
          'nevirapine, and ritonavir may decrease ethosuximide levels.',
      'Therapeutic levels: 40–100 mg/L. T₁/₂ = 24–42 hr. Recommended serum '
          'sampling time at steady state: obtain trough level within 30 min prior to '
          'the next scheduled dose after 5–10 days of continuous dosing.',
      'To minimize GI distress, may administer with food or milk. Abrupt '
          'withdrawal of drug may precipitate absence status.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 992–993',
  ),
  // ETOMIDATE — PDF p. 184 (printed 993)
  DrugEntryV3(
    name: 'ETOMIDATE',
    brandNames: 'Amidate and generics',
    drugClass: 'General anesthetic',
    iconRow: '',
    formulations: [
      'Injection: 2 mg/mL (10, 20 mL); may contain propylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Rapid Sequence Intubation (infuse dose over 30–60 sec):',
        lines: [
          DoseLine('Normotensive patient: 0.3 mg/kg/dose IV/IO ×1; max. dose: 20 mg/dose'),
          DoseLine('Hypotensive patient (see remarks): 0.15 mg/kg/dose IV/IO ×1; max. dose: '
              '20 mg/dose'),
        ],
      ),
    ],
    remarks: [
      'Not recommended for patients in septic shock due to transient '
          'adrenocortical suppression and increased risk for mortality. Avoid use '
          'with benznidazole and metronidazole due to the risk for disulfiram-like '
          'reaction. Use with caution in renal impairment (higher risk for toxicity) '
          'and in heart failure (may exacerbate condition).',
      'Injection site pain, myoclonus (pretreatment with midazolam may reduce '
          'risk), nausea, and vomiting are reported common side effects for '
          'indications other than rapid-sequence intubation.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 993',
  ),
];
