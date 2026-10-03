// =============================================================================
// output/v.dart — Drug Formulary 3.0, letter V
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyV` per file; entries in book order.
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

const List<DrugEntryV3> formularyV = [
  // VALACYCLOVIR — PDF p. 451–452 (printed 1260–1261)
  DrugEntryV3(
    name: 'VALACYCLOVIR',
    brandNames: 'Valtrex and generics',
    drugClass: 'Antiviral agent',
    iconRow: '',
    formulations: [
      'Tabs/caplets: 500, 1000 mg',
      'Oral suspension: 50 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child:',
        lines: [
          DoseLine('Recommended dosages based on steady-state pharmacokinetic data in '
              'immunocompromised children. Efficacy data are incomplete.'),
          DoseLine(
            'To mimic an IV acyclovir regimen of 250 mg/m²/dose or 10 mg/kg/dose TID:',
            isHeading: true,
          ),
          DoseLine('30 mg/kg/dose PO TID OR alternatively by weight:'),
          DoseLine('4–12 kg: 250 mg PO TID'),
          DoseLine('13–21 kg: 500 mg PO TID'),
          DoseLine('22–29 kg: 750 mg PO TID'),
          DoseLine('≥30 kg: 1000 mg PO TID'),
          DoseLine(
            'To mimic a PO acyclovir regimen of 20 mg/kg/dose 4 or 5 times a day:',
            isHeading: true,
          ),
          DoseLine('20 mg/kg/dose PO TID OR alternatively by weight:'),
          DoseLine('6–19 kg: 250 mg PO TID'),
          DoseLine('20–31 kg: 500 mg PO TID'),
          DoseLine('≥32 kg: 750 mg PO TID'),
        ],
      ),
      DoseSection(
        heading: 'Varicella zoster (chickenpox; immunocompetent patient; initiate '
            'therapy at earliest signs or symptoms, within 24 hr of rash onset):',
        lines: [
          DoseLine('Infant ≥3 mo, child, and adolescent: 20 mg/kg/dose PO TID × 5 days; max. '
              'dose: 1 g/dose TID; lengthier duration of therapy may be needed for '
              'immunocompromised patients'),
        ],
      ),
      DoseSection(
        heading: 'Herpes simplex virus (HSV) genital herpes (immunocompetent):',
        lines: [
          DoseLine(
            'Child ≥3 mo–11 yr (limited data):',
            isHeading: true,
          ),
          DoseLine('Initial episode: 20 mg/kg/dose PO Q12 hr (max. dose: 1000 mg/dose) × 7–10 '
              'days or longer if lesions are not completely healed'),
          DoseLine('Recurrent episodes: 20 mg/kg/dose PO Q12 hr (max. dose: 1000 mg/dose) × '
              '5–10 days; most effective when therapy is initiated within 1 day of '
              'lesion appearance'),
          DoseLine('Suppressive therapy: 20 mg/kg/dose PO Q24 hr (max. dose: 1000 mg/dose)'),
          DoseLine(
            'Adolescent and adult:',
            isHeading: true,
          ),
          DoseLine('Initial episode: 1 g/dose PO BID × 10 days or longer if lesions are not '
              'completely healed'),
          DoseLine('Recurrent episodes: 500 mg/dose PO BID × 3 days or 1000 mg PO once daily '
              '× 5 days'),
          DoseLine(
            'Suppressive therapy:',
            isHeading: true,
          ),
          DoseLine('Immunocompetent patient: 500–1000 mg/dose PO once daily × 1 year, then '
              'reassess for recurrences. Patients with <9 recurrences per year may be '
              'dosed at 500 mg/dose PO once daily × 1 yr.'),
        ],
      ),
      DoseSection(
        heading: 'Herpes zoster (shingles, immunocompetent; initiate therapy within '
            '48–72 hr of onset of rash; see remarks):',
        lines: [
          DoseLine('Child ≥2 yr and adolescent: 20 mg/kg/dose PO Q8 hr; max. dose: 1000 '
              'mg/dose for a minimum of 7–10 days and until lesions have crusted over'),
          DoseLine('Adult (immunocompetent): 1 g/dose PO Q8 hr for a minimum of 7–10 days and '
              'until lesions have crusted over'),
        ],
      ),
      DoseSection(
        heading: 'Herpes labialis (cold sores; initiated at earliest symptoms):',
        lines: [
          DoseLine(
            '≥12 yr and adult:',
            isHeading: true,
          ),
          DoseLine('Immunocompetent: 2 g/dose PO Q12 hr × 2 doses (1 day)'),
          DoseLine('Human immunodeficiency virus (HIV) positive: 1 g/dose PO Q12 hr × 5–10 '
              'days. For chronic suppressive therapy, 500 mg PO Q12 hr'),
        ],
      ),
    ],
    remarks: [
      'This prodrug is metabolized to acyclovir and L-valine with better oral '
          'absorption than acyclovir. Use with caution in hepatic or renal '
          'insufficiency (adjust dose; see Chapter 32). Thrombotic thrombocytopenic '
          'purpura/hemolytic uremic syndrome (TTP/HUS) has been reported in patients '
          'with advanced HIV infection and in bone marrow and renal transplant '
          'recipients. Probenecid or cimetidine can reduce the rate of conversion to '
          'acyclovir. Headache, nausea, and abdominal pain are common adverse events '
          'in adults. Headache is common in children. See Acyclovir for additional '
          'drug interactions and adverse effects.',
      'For initial episodes of genital herpes, therapy is most effective when '
          'initiated within 48 hr of symptom onset. Therapy should be initiated '
          'immediately after the onset of symptoms in recurrent episodes (no '
          'efficacy data when initiating therapy >24 hr after onset of symptoms). '
          'Data are not available for use as suppressive therapy for periods >1 yr.',
      'Valacyclovir CANNOT be substituted for acyclovir on a one-to-one basis. '
          'Doses may be administered with or without food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1260–1261',
  ),
  // VALGANCICLOVIR — PDF p. 452–454 (printed 1261–1263)
  DrugEntryV3(
    name: 'VALGANCICLOVIR',
    brandNames: 'Valcyte and generics',
    drugClass: 'Antiviral agent',
    iconRow: '',
    formulations: [
      'Tabs: 450 mg',
      'Oral solution: 50 mg/mL (88 mL); contains saccharin and sodium benzoate',
      'Oral suspension: 60 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate and infant:',
        lines: [
          DoseLine('Symptomatic congenital cytomegalovirus (CMV) (from pharmacokinetic [PK] '
              'data in 8 infants 4–90 days old [mean: 20 days] and 24 neonates 8–34 days '
              'old): 16 mg/kg/dose PO Q12 hr produced levels similar to IV ganciclovir 6 '
              'mg/kg/dose BID. A comparison of 6 weeks vs. 6 months of therapy in 96 '
              'neonates (>32 wk gestation and ≥1.8 kg) showed modest improvement in '
              'long-term hearing and developmental outcomes at 1–2 yr of age with the '
              'longer duration of therapy of 6 months.'),
        ],
      ),
      DoseSection(
        heading: 'Child (1 mo–16 yr):',
        lines: [
          DoseLine('CMV treatment for mild/moderate infection for solid organ transplant '
              'recipients (see remarks): Q12 hr PO dosage calculated with the following '
              'equation:'),
          DoseLine('mg dose (max. dose: 900 mg) = 7 × body surface area (BSA) × CrCl. BSA is '
              'determined by the Mosteller equation and CrCl is determined by a modified '
              'Schwartz equation (max. value: 150 mL/min/1.73 m²).'),
          DoseLine('Mosteller BSA (m²) equation: square root of [(height (cm) × weight (kg)) '
              '÷ 3600]'),
          DoseLine('Modified Schwartz (mL/min/1.73 m²) equation (max. value: 150 mL/min/1.73 '
              'm²): k × height (cm) ÷ serum creatinine (mg/dL); where k = 0.33 if '
              'patient is <1 yr old with low birth weight for gestational age; k = 0.45 '
              'if patient is <1 yr old with birth weight appropriate for gestational age '
              'or if patient is 1 to <2 yr old; k = 0.55 for males 2 to <13 yr old and '
              'females 2 to <16 yr old; or k = 0.7 if male 13–16 yr old'),
          DoseLine('Duration of therapy for treatment regimen: Minimum of 2 weeks until '
              'symptoms resolve, and until 1 or 2 consecutive weekly CMV viral loads are '
              'undetectable or below a test-specific threshold level'),
          DoseLine('CMV prophylaxis in kidney (4 mo–16 yr), heart (1 mo–16 yr), or liver (4 '
              'mo–16 yr) transplantation (see remarks): Q24 hr PO dosage initiated '
              'within 10 days of transplantation is calculated with the following '
              'equation:'),
          DoseLine('Daily mg dose (max. dose: 900 mg) = 7 × BSA × CrCl. BSA is determined by '
              'the Mosteller equation and CrCl is determined by a modified Schwartz '
              'equation (max. value: 150 mL/min/1.73 m²).'),
          DoseLine('Mosteller BSA (m²) equation: square root of [(height (cm) × weight (kg)) '
              '÷ 3600]'),
          DoseLine('Modified Schwartz (mL/min/1.73 m²) equation (max. value: 150 mL/min/1.73 '
              'm²): k × height (cm) ÷ serum creatinine (mg/dL); where k = 0.33 if '
              'patient is <1 yr old with low birth weight for gestational age; k = 0.45 '
              'if patient is <1 yr old with birth weight appropriate for gestational age '
              'or if patient is 1 to <2 yr old; k = 0.55 for males 2 to <13 yr old and '
              'females 2 to <16 yr old; or k = 0.7 for males 13–16 yr old'),
          DoseLine(
            'Duration of therapy for prophylaxis:',
            isHeading: true,
          ),
          DoseLine('Kidney transplantation (≥4 mo to 16 yr): 200 days'),
          DoseLine('Heart transplantation (≥1 mo to 16 yr): 100 days'),
          DoseLine('Liver transplantation (≥4 mo to 16 yr): 100–200 days; limited data'),
        ],
      ),
      DoseSection(
        heading: 'Adolescent (>16 yr) and adult:',
        lines: [
          DoseLine(
            'CMV retinitis:',
            isHeading: true,
          ),
          DoseLine('Induction therapy: 900 mg PO BID × 14–21 days with food'),
          DoseLine('Maintenance therapy: 900 mg PO once daily with food for a minimum of 3–6 '
              'mo'),
          DoseLine('CMV treatment of mild/moderate infection in solid organ transplant '
              'recipients: 900 mg PO BID for a minimum of 2 wk until symptoms resolve '
              'and until 1 or 2 consecutive weekly CMV viral loads are undetectable or '
              'below a test-specific threshold level'),
          DoseLine('CMV prophylaxis in heart, kidney, and kidney-pancreas transplantation: '
              '900 mg PO once daily starting within 10 days of transplantation until 100 '
              'days post heart or kidney-pancreas transplantation; or until 200 days '
              'post kidney transplantation'),
        ],
      ),
    ],
    remarks: [
      'This prodrug is metabolized to ganciclovir with better oral absorption '
          'than ganciclovir. Contraindicated with hypersensitivity to '
          'valganciclovir/ganciclovir; absolute neutrophil count (ANC) <500 mm³; '
          'platelets <25,000 mm³; hemoglobin <8 g/dL; and patients on hemodialysis. '
          'Use with caution in renal insufficiency (adjust dose; see Chapter 32), '
          'preexisting bone marrow suppression, or receiving myelosuppressive drugs '
          'or irradiation. Has not been evaluated in hepatic impairment. May cause '
          'headache, insomnia, peripheral neuropathy, diarrhea, vomiting, '
          'neutropenia, anemia, and thrombocytopenia. Neutropenia incidence is '
          'greater at day 200 vs. day 100 in pediatric kidney transplant patients.',
      'Use effective contraception during and for at least 90 days after '
          'therapy; may impair fertility in men and women. See Ganciclovir for drug '
          'interactions and additional adverse effects.',
      'Monitor complete blood count (CBC) with differential, platelets, and '
          'serum creatinine at baseline and periodically during therapy. Consider '
          'changes in serum creatinine and body changes to height and body weight '
          'for prophylaxis dosing.',
      'Valganciclovir CANNOT be substituted for ganciclovir on a one-to-one '
          'basis. All doses are administered with food. Avoid direct skin or mucous '
          'membrane contact with broken or crushed tablets.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1261–1263',
  ),
  // VALPROIC ACID/VALPROATE SODIUM — PDF p. 454–455 (printed 1263–1264)
  DrugEntryV3(
    name: 'VALPROIC ACID/VALPROATE SODIUM',
    brandNames: 'Generics; previously available as Depakene (PO) and Depacon (IV)\n'
        'Depakote: See Divalproex Sodium',
    drugClass: 'Anticonvulsant',
    iconRow: '',
    formulations: [
      'VALPROIC ACID:',
      'Caps: 250 mg',
      'Oral solution: 250 mg/5 mL (473 mL); may contain parabens',
      'VALPROATE SODIUM:',
      'Injection: 100 mg/mL (5 mL); contains ethylenediaminetetra-acetic acid '
          '(EDTA)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Dosages based on valproic acid or valproate sodium. See remarks '
            'regarding use of extended-release dosage forms such as Depakote ER.',
      ),
      DoseSection(
        heading: 'Seizures (PO):',
        lines: [
          DoseLine('Initial: 10–15 mg/kg/24 hr ÷ once daily–TID'),
          DoseLine('Increment: 5–10 mg/kg/24 hr at weekly intervals to max. dose of 60 '
              'mg/kg/24 hr'),
          DoseLine('Maintenance: 30–60 mg/kg/24 hr ÷ BID–TID. Due to drug interactions, '
              'higher doses (up to 100 mg/kg/24 hr ÷ TID–QID) may be required in '
              'children on other anticonvulsants. If using divalproex sodium (Depakote '
              'or Depakote Sprinkle), divide daily dose BID. See remarks for therapeutic '
              'drug monitoring recommendations.'),
        ],
      ),
      DoseSection(
        heading: 'Intravenous route (use only when PO is not possible):',
        lines: [
          DoseLine('Use same PO daily dose ÷ Q6 hr. Convert back to PO as soon as possible.'),
        ],
      ),
      DoseSection(
        heading: 'Rectal route (use syrup diluted 1:1 with water, given PR as a '
            'retention enema; limited data):',
        lines: [
          DoseLine('Load: 20 mg/kg/dose'),
          DoseLine('Maintenance: 10–15 mg/kg/dose Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Migraine prophylaxis:',
        lines: [
          DoseLine('Child ≥5 yr (limited data): Start at 10–15 mg/kg/24 hr PO ÷ BID (max. '
              'initial dose: 250 mg/dose). If needed, increase dose over 4–6 wk to 40–45 '
              'mg/kg/24 hr PO ÷ BID up to a maximum of 1000 mg/24 hr. Alternative dosing '
              'for adolescent ≥17 yr is 250 mg PO BID initially titrated up to a maximum '
              'of 1000 mg/24 hr.'),
          DoseLine('Adult: Start with 500 mg/24 hr PO ÷ BID. Dose may be gradually increased '
              'to a max. of 1000 mg/24 hr PO ÷ BID. If using divalproex sodium '
              'extended-release tablets, administer the daily dose once daily.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in hepatic disease, pregnancy (for migraine indication), '
          'urea cycle disorders (e.g., ornithine carbamoyltransferase [OTC] '
          'deficiency), mitochondrial disorders with mutations in DNA polymerase γ '
          '(e.g., Alpers-Huttenlocher syndrome), and children <2 yr suspected of the '
          'aforementioned mitochondrial disorder. May cause gastrointestinal, liver, '
          'blood, and central nervous system (CNS) toxicity; weight gain; transient '
          'alopecia; pancreatitis (potentially life-threatening); nausea; sedation; '
          'vomiting; headache; thrombocytopenia (dose-related); platelet '
          'dysfunction; rash (especially with lamotrigine); and hyperammonemia. '
          'Hepatic failure has occurred especially in children <2 yr (especially '
          'those receiving multiple anticonvulsants, with congenital metabolic '
          'disorders, with severe seizure disorders with mental retardation, and '
          'with organic brain disease). Idiosyncratic life-threatening pancreatitis '
          'has been reported in children and adults. Hyperammonemic encephalopathy '
          'has been reported in patients with urea cycle disorders. Suicidal '
          'behavior or ideation, male infertility, elevated testosterone, decreased '
          'bone mineral density, drug rash with eosinophilia and systemic symptoms '
          '(DRESS), encephalopathy without elevated ammonia levels, hair '
          'texture/color changes, and nail/nail bed disorders have been reported.',
      'Valproic acid is a substrate for cytochrome P-450 (CYP) 2C19 isoenzyme '
          'and an inhibitor of CYP2C9, CYP2D6, and CYP3A3/3A4 (weak). It increases '
          'amitriptyline/nortriptyline, rufinamide, phenytoin, propofol, diazepam, '
          'and phenobarbital levels. Concomitant estrogen-containing contraceptives, '
          'phenytoin, phenobarbital, topiramate, meropenem, methotrexate, '
          'cholestyramine, and carbamazepine may decrease valproic acid levels. '
          'Amitriptyline or nortriptyline may increase valproic acid levels. Use '
          'with cannabidiol has been associated with the risk for alanine '
          'aminotransferase (ALT) and/or aspartate aminotransferase (AST) '
          'elevation(s). May interfere with urine ketone and thyroid tests.',
      'Do not give syrup with carbonated beverages. Use of IV route has not been '
          'evaluated for >14 days of continuous use. Infuse IV over 1 hr up to a '
          'max. rate of 20 mg/min. Depakote and Depakote ER are NOT bioequivalent; '
          'see package insert for dose conversion. Depakote ER is intended for '
          'once-daily administration and may require higher daily doses when '
          'converting from other dosage forms.',
      'Therapeutic levels: 50–100 mg/L. Recommendations for serum sampling at '
          'steady state: Obtain trough level within 30 min prior to the next '
          'scheduled dose after 2–3 days of continuous dosing. Levels of 50–60 mg/L '
          'and as high as 85 mg/L have been recommended for bipolar disorders. '
          'Monitor complete blood count (CBC) and liver function tests (LFTs) prior '
          'to and during therapy.',
      'Valproic acid and divalproex should not be used in pregnant women. '
          'Increased risk of neural tube defects, decreased child IQ scores, '
          'craniofacial defects, and cardiovascular malformations have been reported '
          'in babies exposed to valproic acid and divalproex sodium.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1263–1264',
  ),
  // VALSARTAN — PDF p. 455–456 (printed 1264–1265)
  DrugEntryV3(
    name: 'VALSARTAN',
    brandNames: 'Diovan and generics',
    drugClass: 'Angiotensin II receptor blocker, antihypertensive agent',
    iconRow: '',
    formulations: [
      'Tabs: 40, 80, 160, 320 mg',
      'Oral solution: 4 mg/mL (120, 473 mL); may contain parabens and propylene '
          'glycol',
      'Oral suspension: 4 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hypertension (see remarks):',
        lines: [
          DoseLine('Infant ≥6 mo and ≥6 kg (limited data): Start at 1 mg/kg/dose PO once '
              'daily; if needed, increase dose every 2 weeks up to a maximum of 4 '
              'mg/kg/24 hr. Usual range: 0.25–4 mg/kg/dose once daily'),
          DoseLine('Child 1–16 yr: Start at 1 or 2 mg/kg/dose PO once daily (max. dose: 40 '
              'mg/24 hr). Usual dosage range: 1–4 mg/kg/dose once daily; max. dose: 4 '
              'mg/kg/24 hr up to 160 mg/24 hr'),
          DoseLine('Adolescent ≥17 yr and adult (non–volume-depleted status): Start at 80 or '
              '160 mg PO once daily; usual dosage range is 80–320 mg once daily. Max. '
              'dose: 320 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated with aliskiren use in patients with diabetes. Discontinue '
          'use immediately when pregnancy is detected. Use with caution in renal '
          '(CrCl <30 mL/min) and liver insufficiency, heart failure, post myocardial '
          'infarction, renal artery stenosis, renal function changes, and volume '
          'depletion.',
      'Hypotension, dizziness, headache, cough, and increases in blood urea '
          'nitrogen (BUN) and serum creatinine (SCr) are common side effects. '
          'Hyperkalemia (most commonly reported in children <6 yr with underlying '
          'renal disease in clinical trials; also consider salt substitutes, foods, '
          'and medications that may increase potassium levels), bullous dermatitis, '
          'angioedema, acute renal failure, and dysgeusia have been reported. May '
          'increase lithium levels, resulting in toxicity for those receiving '
          'concurrent lithium therapy; monitor lithium levels closely.',
      'Onset of initial antihypertensive effects is 2 hr with maximum effects '
          'after 2–4 wk of chronic use. Patients may require higher doses of oral '
          'tablet dosage form than the oral suspension due to increased '
          'bioavailability with the oral suspension.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1264–1265',
  ),
  // VANCOMYCIN — PDF p. 456–458 (printed 1265–1267)
  DrugEntryV3(
    name: 'VANCOMYCIN',
    brandNames: 'Vancocin, Firvanq, and generics',
    drugClass: 'Antibiotic, glycopeptide',
    iconRow: '',
    formulations: [
      'Injection: 0.5, 0.75, 1, 1.5, 5, 10 g',
      'Premixed injection:',
      'In 5% dextrose in water (D₅W) or normal saline (NS): 500 mg/100 mL, 750 '
          'mg/150 mL, 1000 mg/200 mL, 1250 mg/250 mL, 1500 mg/300 mL',
      'Caps (Vancocin and generics): 125, 250 mg',
      'Oral solution: 25 mg/mL',
      'Firvanq: 25 mg/mL (150, 300 mL), 50 mg/mL (150, 300 mL); contains sodium '
          'benzoate',
      'Generics: 25 mg/mL (150, 300 mL), 50 mg/mL (80, 150, 300 mL); may contain '
          'sodium benzoate',
    ],
    doseSections: [
      DoseSection(
        heading: 'Initial empiric dosage; patient-specific dosage defined by '
            'therapeutic drug monitoring (see remarks)',
      ),
      DoseSection(
        heading: 'Neonate, IV (see following table for dosage interval):',
        lines: [
          DoseLine('Bacteremia: 10 mg/kg/dose'),
          DoseLine('Meningitis, pneumonia: 15 mg/kg/dose'),
        ],
        table: DoseTable(
          headers: ['Postmenstrual Age (Weeks)ᵃ', 'Postnatal Age (Days)', 'Dosage Interval (hr)'],
          rows: [
            DoseTableRow(['≤29', '0–14\n>14', '18\n12']),
            DoseTableRow(['30–36', '0–14\n>14', '12\n8']),
            DoseTableRow(['37–44', '0–7\n>7', '12\n8']),
            DoseTableRow(['≥45', 'All', '6']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃPostmenstrual age = gestational age + postnatal age.'),
        ],
      ),
      DoseSection(
        heading: 'Infant, child, adolescent, and adult (estimated glomerular filtration '
            'rate [eGFR] > 75 mL/min/1.73m²; IV):',
        table: DoseTable(
          headers: ['Age', 'General Dosage', 'Central Nervous System (CNS) Infections, Endocarditis, Osteomyelitis, '
                'Pneumonia, and Septic Arthritis'],
          rows: [
            DoseTableRow(['1 mo–12 yr', '15 mg/kg/dose Q6 hr', '20 mg/kg/dose Q6 hr']),
            DoseTableRow(['Adolescent (>12 to <18 yr)ᵃ', '15 mg/kg/dose (max. 2500 mg/dose) Q6–8 hr', '20 mg/kg/dose (max. 2500 mg/dose) Q6–8 hr']),
            DoseTableRow(['Adult (≥18 yr)', '15 mg/kg/dose (max. 2500 mg/dose) Q8–12 hr', '20 mg/kg/dose (max. 2500 mg/dose) Q8–12 hr']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃUse Q8 hr dosing interval for older adolescent.'),
        ],
      ),
      DoseSection(
        heading: 'Clostridium difficile colitis (PR route of administration may be '
            'preferable for complete ileus):',
        lines: [
          DoseLine('Child: 40–50 mg/kg/24 hr PO ÷ Q6 hr × 7–10 days'),
          DoseLine('Max dose: 500 mg/24 hr; higher maximum of 2 g/24 hr has also been used '
              'for severe/fulminant disease'),
          DoseLine('Adult: 125 mg/dose PO ÷ Q6 hr × 7–10 days; dosages as high as 2 g/24 hr ÷ '
              'Q6–8 hr have also been used for severe/fulminant disease'),
        ],
      ),
      DoseSection(
        heading: 'Endocarditis prophylaxis for genitourinary or gastrointestinal '
            '(excluding esophageal) procedures (complete all antibiotic dose '
            'infusion[s] within 30 min of starting procedure):',
        lines: [
          DoseLine(
            'Moderate-risk patients allergic to ampicillin or amoxicillin:',
            isHeading: true,
          ),
          DoseLine('Child: 20 mg/kg/dose (max. 1 g/dose) IV over 1–2 hr × 1'),
          DoseLine('Adult: 1 g/dose IV over 1–2 hr × 1'),
          DoseLine(
            'High-risk patients allergic to ampicillin or amoxicillin:',
            isHeading: true,
          ),
          DoseLine('Child and adult: Same vancomycin IV dose as moderate-risk patients plus '
              'gentamicin 1.5 mg/kg/dose (max. dose: 120 mg/dose) IV/IM ×1'),
        ],
      ),
      DoseSection(
        heading: '',
        table: DoseTable(
          headers: ['Indication', 'Goal Trough Level'],
          rows: [
            DoseTableRow(['Uncomplicated skin and soft tissue infection, uncomplicated bacteremia, '
                'febrile neutropenia, sepsis', '10–14 mg/L']),
            DoseTableRow(['CNS infections, endocarditis, pneumonia, osteomyelitis, septic arthritis', '14–17 mg/L']),
          ],
        ),
      ),
    ],
    remarks: [
      'Ototoxicity and nephrotoxicity may occur and may be exacerbated with '
          'concurrent aminoglycoside use. Greater nephrotoxicity risk has been '
          'associated with higher therapeutic serum trough concentrations (≥15 '
          'mg/mL), concurrent piperacillin/tazobactam therapy, and receiving '
          'furosemide in the intensive care unit. Adjust dose in renal failure (see '
          'Chapter 32). Use total body weight for obese patients when calculating '
          'dosages. Low concentrations of the drug may appear in cerebrospinal fluid '
          '(CSF) with inflamed meninges. Nausea, vomiting, and drug-induced '
          'erythroderma are common with IV use. Vancomycin infusion reaction is '
          'associated with rapid IV infusion. Infuse over 60 min (may infuse over '
          '120 min if 60-min infusion is not tolerated). NOTE: Diphenhydramine is '
          'used to reverse the infusion reaction. Allergic reactions (including drug '
          'rash with eosinophilia and systemic symptoms [DRESS]), neutropenia, and '
          'immune-mediated thrombocytopenia have been reported. Serious skin '
          'reactions (e.g., Stevens-Johnson syndrome [SJS], toxic epidermal '
          'necrolysis [TEN]) have been reported in association with use of both IV '
          'and oral routes of administration.',
      'Although current extrapolated adult guidelines suggest measuring only '
          'trough levels, an additional post-distributional level may be useful in '
          'characterizing enhanced/altered drug clearance for quicker dosage '
          'modification to attain target levels; this may be useful for infants with '
          'known faster clearance and patients in renal compromise. Consult a '
          'pharmacist.',
      'The following therapeutic trough level recommendations are based on the '
          'assumption that the pathogen’s vancomycin minimum inhibitory '
          'concentration (MIC) is ≤1 mg/L.',
      'Peak level measurement (20–50 mg/L) has also been recommended for '
          'patients with burns, clinical nonresponsiveness in 72 hr of therapy, '
          'persistent positive cultures, and CNS infections (≥30 mg/L).',
      'Recommended serum sampling time at steady state: Trough within 30 min '
          'prior to the fourth consecutive dose and peak 60 min after the '
          'administration of the fourth consecutive dose. Infants with faster '
          'elimination (shorter half-time [T₁/₂]) may be sampled around the third '
          'consecutive dose.',
      'Recent evidence strongly suggests moving away from serum trough '
          'vancomycin monitoring to a pharmacokinetic/pharmacodynamics (PK/PD) '
          'target of area under the curve (AUC)–to-MIC ratio. An AUC{₂₄} of 400–600 '
          'mg*h/L is associated with clinical efficacy and reduced risk for acute '
          'kidney injury (AKI). Vancomycin therapeutic monitoring guidelines were '
          'revised in 2020 by the Infectious Diseases Society of America (IDSA) in '
          'collaboration with PIDS, SIDP, and the American Society of Health-System '
          'Pharmacists. Consult with an infectious diseases specialist and '
          'pharmacist to see how this monitoring method is best operationalized at '
          'your institution.',
      'ORAL USE for C. difficile: Vancomycin (PO) or metronidazole (PO) is '
          'currently the recommended first-line therapy for children, whereas '
          'vancomycin (PO) or fidaxomicin is recommended for adults. See Clinical '
          'Infectious Diseases 66(7):e1–e48 for the 2017 IDSA/Society for Healthcare '
          'Epidemiology of America Clinical Practice Guidelines. Common adverse '
          'effects with oral vancomycin capsules in adults include nausea, abdominal '
          'pain, and hypokalemia.',
    ],
    pregnancyNote: 'Pregnancy category “C” for the intravenous route and “B” for the '
        'oral route of administration.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1265–1267',
  ),
  // VANZACAFTOR + TEZACAFTOR + DEUTIVACAFTOR — PDF p. 458–460 (printed 1267–1269)
  DrugEntryV3(
    name: 'VANZACAFTOR + TEZACAFTOR + DEUTIVACAFTOR',
    brandNames: 'Alyftrek',
    drugClass: 'Cystic fibrosis transmembrane conductance regulator (CFTR) corrector '
        'and potentiator',
    iconRow: '',
    formulations: [
      'Tabs (4-week supply in 4 weekly blister packs):',
      'Vanzacaftor 4 mg, tezacaftor 20 mg, and deutivacaftor 50 mg (84 tabs)',
      'Vanzacaftor 10 mg, tezacaftor 50 mg, and deutivacaftor 125 mg (56 tabs)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Usual dosage:',
        lines: [
          DoseLine(
            'Child 6–≤12 yr (see remarks):',
            isHeading: true,
          ),
          DoseLine('≤40 kg: vanzacaftor 12 mg/tezacaftor 60 mg/deutivacaftor 150 mg PO once '
              'daily by administering 3 tablets of the vanzacaftor 4 mg/tezacaftor 20 '
              'mg/deutivacaftor 50 mg tablet strength'),
          DoseLine('>40 kg: vanzacaftor 20 mg/tezacaftor 100 mg/deutivacaftor 250 mg PO once '
              'daily by administering 2 tablets of the vanzacaftor 10 mg/tezacaftor 50 '
              'mg/ deutivacaftor 125 mg tablet strength'),
          DoseLine('Child >12 yr and adult (see remarks): vanzacaftor 20 mg/tezacaftor 100 '
              'mg/deutivacaftor 250 mg PO once daily by administering 2 tablets of the '
              'vanzacaftor 10 mg/tezacaftor 50 mg/deutivacaftor 125 mg tablet strength'),
        ],
      ),
      DoseSection(
        heading: 'Dosage modification when used with moderate or strong cytochrome '
            'P-450 (CYP) 3A4 inhibitors:',
        table: DoseTable(
          headers: ['Age', 'Weight', 'Moderate CYP3A4 Inhibitor (e.g., fluconazole, erythromycin)', 'Strong CYP3A4 Inhibitor (e.g., ketoconazole, itraconazole, posaconazole, '
                'voriconazole, and clarithromycin)'],
          rows: [
            DoseTableRow(['6–<12 yr', '<40 kg', 'Vanzacaftor 8 mg/tezacaftor 40 mg/deutivacaftor 100 mg PO once every '
                'other day by administering 2 tablets of the vanzacaftor 4 mg/tezacaftor '
                '20 mg/deutivacaftor 50 mg tablet strength', 'Vanzacaftor 8 mg/tezacaftor 40 mg/deutivacaftor 100 mg PO once every week '
                'by administering 2 tablets of the vanzacaftor 4 mg/tezacaftor 20 '
                'mg/deutivacaftor 50 mg tablet strength']),
            DoseTableRow(['', '≥40 kg', 'One vanzacaftor 10 mg/tezacaftor 50 mg/deutivacaftor 125 mg tablet PO '
                'once every other day', 'One vanzacaftor 10 mg/tezacaftor 50 mg/deutivacaftor 125 mg tablet PO '
                'once every week']),
            DoseTableRow(['≥12 yr and adult', 'Any', 'One vanzacaftor 10 mg/tezacaftor 50 mg/deutivacaftor 125 mg tablet PO '
                'once every other day', 'One vanzacaftor 10 mg/tezacaftor 50 mg/deutivacaftor 125 mg tablet PO '
                'once every week']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Recommended dosage with existing hepatic impairment prior to therapy '
            'initiation (see remarks for recommendations when hepatotoxicity '
            'develops during treatment):',
        lines: [
          DoseLine('Mild impairment (Child-Pugh Class A): Use usual dosing regimen with close '
              'monitoring of liver function tests (LFTs)'),
          DoseLine('Moderate impairment (Child-Pugh Class B): Use is not recommended but may '
              'be considered when the benefits outweigh the risks (use usual dosing '
              'regimen with close monitoring of LFTs)'),
          DoseLine(
            'Severe impairment (Child-Pugh Class C): DO NOT use.',
            isHeading: true,
          ),
        ],
      ),
    ],
    remarks: [
      'Works on CFTR trafficking defect by acting as CFTR correctors '
          '(vanzacaftor and tezcaftor) in combination with a CFTR potentiator '
          '(deutivacaftor). Indicated for individuals who have at least one F508del '
          'mutation or another responsive mutation in the CFTR gene.',
      'Common side effects include rash, headache, cough, nasopharyngitis, '
          'oropharyngeal pain, fatigue, and upper respiratory tract infection. '
          'Elevated liver enzymes, creatinine phosphokinase, cataracts (obtain '
          'ocular exam at baseline and annually), and hypertension have been '
          'reported.',
      'Serious and potentially fatal drug-induced liver injury and failure have '
          'been reported within the first month and up to 15 months after the '
          'initiation of therapy. Obtain baseline LFTs (alanine aminotransferase '
          '[ALT], aspartate aminotransferase [AST], alkaline phosphatase, and '
          'bilirubin) followed by monthly tests for the first 6 months of therapy, '
          'then every 3 months for the next 12 months, then annually thereafter. '
          'More frequent LFT monitoring is recommended for patients with a history '
          'of liver disease or elevated LFTs at baseline.',
      'Interrupt therapy with clinical signs/symptoms of liver injury (e.g., '
          'jaundice, right upper quadrant pain, nausea, vomiting, altered mental '
          'status, ascites) or with significant increases in LFTs (e.g, ALT or AST '
          '>5 times the upper limit of normal (ULN), or ALT or AST >3 times ULN with '
          'bilirubin >2 times ULN) and consider consultation with a hepatologist. '
          'The decision to reintroduce therapy (with close monitoring) following '
          'clinical and laboratory resolution of hepatic injury will depend on '
          'whether the benefits will outweigh the risks.',
      'Use with caution with CrCl <30 mL/min and end-stage renal disease (no '
          'available data); only use if benefits outweigh risks. Reduce dose when '
          'initiating therapy while taking a CYP3A4 inhibitor (see dosing section).',
      'All three components of this medication are substrates for CYP3A4 and '
          'inhibit P-glycoprotein. May increase the effects/toxicity of '
          'cyclosporine, dabigatran, digoxin, everolimus, sirolimus, tacrolimus, '
          'risperidone, and warfarin. Coadministration with strong/moderate CYP3A4 '
          'inducers (e.g., rifampin, rifabutin, carbamazepine, phenobarbital, '
          'phenytoin, St. John’s wort) is NOT recommended. Always evaluate potential '
          'drug-drug interactions; see '
          'https://www.alyftrekhcp.com/drug-interactions. Avoid food or drink '
          'containing grapefruit or Seville oranges.',
      'Administer all doses with high-fat foods to ensure absorption. If a dose '
          'is missed within 6 hr of a scheduled dose, administer a dose immediately. '
          'If the missed dose is >6 hr, skip the missed dose and continue on the '
          'original schedule the next day. Never take a double dose for a missed '
          'dose.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1267–1269',
  ),
  // VARICELLA-ZOSTER IMMUNE GLOBULIN (HUMAN) — PDF p. 460–461 (printed 1269–1270)
  DrugEntryV3(
    name: 'VARICELLA-ZOSTER IMMUNE GLOBULIN (HUMAN)',
    brandNames: 'VariZig, VZIG',
    drugClass: 'Hyperimmune globulin, varicella-zoster',
    iconRow: '',
    formulations: [
      'Injection: 125 units (1.2 mL); contains 10% maltose, 0.03% polysorbate '
          '80, and <40 mCg/mL immunoglobulin A (IgA); preservative free. May contain '
          'low levels of anti–protein S antibodies',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infant, child, and adolescent: Dose should be given within 48 hr of '
            'varicella exposure and no later than 96 hr postexposure. IM '
            'administration:',
        lines: [
          DoseLine('<2 kg: 62.5 Units'),
          DoseLine('2.1–10 kg: 125 Units'),
          DoseLine('10.1–20 kg: 250 Units'),
          DoseLine('20.1–30 kg: 375 Units'),
          DoseLine('30.1–40 kg: 500 Units'),
          DoseLine('>40 kg: 625 Units'),
          DoseLine('Max. dose: 625 Units/dose'),
          DoseLine('If patient is high risk and re-exposed to varicella for more than 3 weeks '
              'after a prior dose, another full dose may be given.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in severe thrombocytopenia due to IM injection, IgA '
          'deficiency (anaphylactic reactions may occur), and known immunity to '
          'varicella-zoster virus. See Chapter 16 for indications. Local discomfort, '
          'redness, and swelling at the injection site and headache may occur.',
      'Hyperviscosity of the blood may increase risk for thrombotic events. '
          'Interferes with immune response to live virus vaccines such as measles, '
          'mumps, and rubella; defer administration of live vaccines 6 mo or longer '
          'after VZIG dose. See latest American Academy of Pediatrics Red Book for '
          'additional information.',
      'Avoid IM injection into the gluteal region due to risk for sciatic nerve '
          'damage and do not exceed age-specific single max. IM injection volume.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1269–1270',
  ),
  // VASOPRESSIN — PDF p. 461–462 (printed 1270–1271)
  DrugEntryV3(
    name: 'VASOPRESSIN',
    brandNames: 'Vasostrict and generics, 8-Arginine Vasopressin; previously '
        'available as Pitressin',
    drugClass: 'Antidiuretic hormone analog',
    iconRow: '',
    formulations: [
      'Injection:',
      'Vasostrict and generics: 20 Units/mL (aqueous) (1, 10 mL); may contain '
          '0.5% chlorobutanol',
      'Premixed injection in normal saline (NS):',
      'Generics: 0.2, 0.4 Units/mL (100 mL), 1 Unit/mL (50 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Diabetes insipidus:',
        lines: [
          DoseLine('Titrate dose to effect (see remarks).'),
          DoseLine(
            'SC/IM:',
            isHeading: true,
          ),
          DoseLine('Child: 2.5–10 Units BID–QID'),
          DoseLine('Adult: 5–10 Units BID–TID'),
          DoseLine('Continuous infusion (child and adult; limited data): Start at 0.5 '
              'milliunit/kg/hr (0.0005 Units/kg/hr). Increase dosage by 0.5 '
              'milliunit/kg/hr every 10 min PRN up to max. dose of 10 milliunit/kg/hr '
              '(0.01 Units/kg/hr).'),
        ],
      ),
      DoseSection(
        heading: 'Gastrointestinal hemorrhage (IV; NOTE: dosage metric is Units/kg/min '
            'for children and Units/min for adults):',
        lines: [
          DoseLine('Child (limited data): Start at 0.002–0.005 Units/kg/min. Increase dose as '
              'needed to max. dose of 0.01 Units/kg/min.'),
          DoseLine('Adult: Start at 0.2–0.4 Units/min. Increase dose as needed to max. dose '
              'of 0.8 Units/min.'),
        ],
      ),
      DoseSection(
        heading: 'Cardiac arrest, ventricular fibrillation, and pulseless ventricular '
            'tachycardia (limited data):',
        lines: [
          DoseLine('Child (use following 2 doses of epinephrine; limited data): 0.4 Units/kg '
              'IV × 1'),
        ],
      ),
      DoseSection(
        heading: 'Vasodilatory shock with hypotension (unresponsive to fluids and '
            'pressors; NOTE: dosage metric is Units/kg/min for children and '
            'Units/min for adults):',
        lines: [
          DoseLine('Infant, child, adolescent (various reports; limited data): 0.00017–0.008 '
              'Units/kg/min via continuous IV infusion in combination with pressors'),
          DoseLine('Adult: 0.01–0.04 Units/min via continuous IV infusion in combination with '
              'pressors'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in seizures, migraine, asthma, and renal, cardiac, or '
          'vascular diseases. Side effects include tremor, sweating, vertigo, '
          'abdominal discomfort, nausea, vomiting, urticaria, anaphylaxis, '
          'hypertension, and bradycardia. May cause vasoconstriction, water '
          'intoxication, bronchoconstriction, and decreased cardiac index. Drug '
          'interactions: lithium, demeclocycline, heparin, and alcohol reduce '
          'activity; carbamazepine, tricyclic antidepressants (TCAs), '
          'fludrocortisone, and chlorpropamide increase activity. Hemodynamic '
          'monitoring is recommended when used with catecholamines, indomethacin, '
          'ganglionic blocking agents, and medications that may cause syndrome of '
          'inappropriate secretion of antidiuretic hormone (SIADH) (e.g., selective '
          'serotonin reuptake inhibitors [SSRIs], TCAs, carbamazepine, and '
          'oxcarbazepine).',
      'Do not abruptly discontinue IV infusion (taper dose). Patients with '
          'variceal hemorrhage and hepatic insufficiency may respond to lower '
          'dosages. Monitor fluid intake and output, urine specific gravity, urine '
          'and serum osmolality, plasma osmolality, and sodium.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1270–1271',
  ),
  // VECURONIUM BROMIDE — PDF p. 462 (printed 1271)
  DrugEntryV3(
    name: 'VECURONIUM BROMIDE',
    brandNames: 'Various generics; previously available as Norcuron',
    drugClass: 'Nondepolarizing neuromuscular blocking agent',
    iconRow: '',
    formulations: [
      'Injection: 10, 20 mg; contains mannitol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate:',
        lines: [
          DoseLine('Initial: 0.1 mg/kg/dose IV'),
          DoseLine('Maintenance: 0.03–0.15 mg/kg/dose IV Q1–2 hr PRN'),
        ],
      ),
      DoseSection(
        heading: 'Infants (>7 wk to 1 yr) (see remarks):',
        lines: [
          DoseLine('Initial: 0.08–0.1 mg/kg/dose IV; reduce dose to 0.04–0.06 mg/kg/dose IV '
              'if used in combination with succinylcholine'),
          DoseLine('Maintenance: 0.05–0.1 mg/kg/dose IV Q1 hr PRN; may administer via '
              'continuous infusion at 0.06–0.09 mg/kg/hr IV'),
        ],
      ),
      DoseSection(
        heading: '>1 yr–adult (see remarks):',
        lines: [
          DoseLine('Initial: 0.08–0.1 mg/kg/dose IV; reduce dose to 0.04–0.06 mg/kg/dose IV '
              'if used in combination with succinylcholine'),
          DoseLine('Maintenance: 0.05–0.1 mg/kg/dose IV Q1 hr PRN; may administer via '
              'continuous infusion at 0.09–0.15 mg/kg/hr IV'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in patients with renal or hepatic impairment and '
          'neuromuscular disease. Dose reduction may be necessary in hepatic '
          'insufficiency. Infants (7 wk to 1 yr) are more sensitive to the drug and '
          'may have a longer recovery time. Children (1–10 yr) may require higher '
          'doses and more frequent supplementation than adults. Enflurane, '
          'isoflurane, aminoglycosides, β-blockers, calcium channel blockers, '
          'clindamycin, furosemide, magnesium salts, quinidine, procainamide, and '
          'cyclosporine may increase the potency and duration of neuromuscular '
          'blockade. Calcium, caffeine, carbamazepine, phenytoin, steroids (chronic '
          'use), acetylcholinesterases, and azathioprine may decrease effects. May '
          'cause arrhythmias, rash, and bronchospasm. Severe anaphylactic reactions '
          'have been reported.',
      'Sugammadex is considered the primary antidote. Neostigmine, '
          'pyridostigmine, or edrophonium are considered alternative antidotes. '
          'Onset of action within 1–3 min. Duration is 30–40 min. See Chapter 1 for '
          'rapid sequence intubation.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1271',
  ),
  // VIGABATRIN — PDF p. 462–463 (printed 1271–1272)
  DrugEntryV3(
    name: 'VIGABATRIN',
    brandNames: 'Sabril, Vigadrone, Vigafyde, Vigpoder, and generics',
    drugClass: 'Anticonvulsant',
    iconRow: '',
    formulations: [
      'Tabs (Sabril, Vigadrone, and generics): 500 mg; may be scored',
      'Oral solution (Vigafyde): 100 mg/mL (150 mL); contains parabens and '
          'sucralose',
      'Powder for oral solution (Sabril, Vigadrone, Vigpoder, and generics): 500 '
          'mg per packet to be dissolved in 10 mL water to make a 50 mg/mL solution '
          '(50s)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infantile spasms (1 mo–2 yr; see remarks for discontinuation of '
            'therapy):',
        lines: [
          DoseLine('Start at 50 mg/kg/24 hr PO ÷ BID; if needed and tolerated, may titrate '
              'dosage upward by 25–50 mg/kg/24 hr increments Q3 days up to a maximum of '
              '150 mg/kg/24 hr PO ÷ BID. Gradually withdraw therapy (see remarks) if no '
              'clinical benefit is seen in 2–4 wk.'),
        ],
      ),
      DoseSection(
        heading: 'Adjunctive therapy for refractory complex partial seizures (gradually '
            'withdraw therapy if no clinical benefit is seen in 3 mo; see remarks '
            'for discontinuation of therapy):',
        lines: [
          DoseLine('Child ≥2 yr and ≥10 kg, and adolescent ≤16 yr and ≤60 kg: If needed and '
              'tolerated, increase starting dose at weekly intervals to the recommended '
              'maintenance dose.'),
        ],
        table: DoseTable(
          headers: ['Weight (kg)', 'Starting Daily Dose (mg/24 hr ÷ BID)', 'Recommended Daily Maintenance Dose (mg/24 hr ÷ BID)'],
          rows: [
            DoseTableRow(['10–15', '350', '1050']),
            DoseTableRow(['>15–20', '450', '1300']),
            DoseTableRow(['>20–25', '500', '1500']),
            DoseTableRow(['>25–60', '500', '2000']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('Adolescent (≥17 yr) and adult (see remarks for discontinuation of '
              'therapy): Start at 500 mg PO BID; if needed and tolerated, increase daily '
              'dose by 500-mg increments at 7-day intervals. Usual recommended dose: '
              '1500 mg BID; max. dose: 6000 mg/24 hr. Doses >3 g/24 hr have not been '
              'shown to provide additional benefit and are associated with more side '
              'effects.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in renal impairment (reduce dose; see Chapter 32) and '
          'with other central nervous system depressants (enhanced effects). Can '
          'cause progressive and permanent vision loss (risk increases with dose and '
          'duration); periodic vision testing is required. Common side effects in '
          'children and adults include rash, weight gain, gastrointestinal '
          'disturbances, arthralgia, visual disturbances, vertigo, sedation, '
          'headache, confusion, and upper respiratory infections. Liver failure, '
          'anemia, psychotic disorder, angioedema, Stevens-Johnson syndrome, toxic '
          'epidermal necrolysis, alopecia, and suicidal ideation have been reported. '
          'Abnormal magnetic resonance imaging signal changes (T2 signal and '
          'restricted diffusion in a symmetric pattern) and intramyelinic edema (in '
          'postmortem exams) have been reported in infants treated for infantile '
          'spasms.',
      'Ketorolac, naproxen, and mefloquine may decrease the effect of '
          'vigabatrin. Vigabatrin may decrease the effects/levels of phenytoin but '
          'increase the levels/toxicity of carbamazepine.',
      'Use in adjunctive therapy for refractory complex partial seizure has '
          'labeled indication for ≥10-yr-old patients when potential benefits '
          'outweigh the risk of vision loss.',
      'DO NOT rapidly withdraw therapy. Dosage needs to be tapered when '
          'discontinuing therapy to minimize increased seizure frequency. The '
          'following tapering guidelines have been recommended:',
      'Infant: Decrease by 25–50 mg/kg every 3–4 days.',
      'Child: Decrease dose by ⅓ every 7 days for 3 weeks.',
      'Adult: Decrease by 1 g/24 hr every 7 days.',
      'Doses may be administered with or without food.',
      'Access to this medication is restricted to prescribers and pharmacies '
          'registered under a special restricted distribution program (SABRIL REMS '
          'Program) in the United States. Call 888-457-4273 or see '
          'www.SabrilREMS.com for more information.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1271–1272',
  ),
  // VITAMIN A — PDF p. 464 (printed 1273)
  DrugEntryV3(
    name: 'VITAMIN A',
    brandNames: 'Aquasol A and many generics',
    drugClass: 'Vitamin, fat soluble',
    iconRow: '',
    formulations: [
      'Caps [OTC]: 7500, 8000, 10,000, 25,000 IU',
      'Tabs [OTC]: 10,000, 15,000 IU',
      'Oral drops [OTC]; 750 mCg/0.3 mL (2500 IU/0.3 mL) (30 mL), 3000 mCg/0.25 '
          'mL (10,000 IU/0.25 mL) (30 mL)',
      'Sublingual tabs [OTC]: 5000 IU',
      'Injection for IM use (Aquasol A): 50,000 IU/mL (2 mL); contains '
          'polysorbate 80 and chlorobutanol',
      'Conversion: 10,000 IU is equivalent to 3000 mCg vitamin A.',
    ],
    doseSections: [
      DoseSection(
        heading: 'U.S. Recommended Daily Allowance (US RDA):',
        lines: [
          DoseLine('See Chapter 21.'),
        ],
      ),
      DoseSection(
        heading: 'Supplementation in measles infection (a third dose may be '
            'administered 2–6 wk after the second dose if patient has clinical '
            'signs of vitamin A deficiency or is severely malnourished; see '
            'remarks):',
        lines: [
          DoseLine('<6 mo: 50,000 IU/dose PO once daily × 2 days'),
          DoseLine('Infant 6 mo to <1 yr: 100,000 IU/dose PO once daily × 2 days'),
          DoseLine('Child ≥1 yr: 200,000 IU/dose PO once daily × 2 days'),
        ],
      ),
      DoseSection(
        heading: 'Malabsorption syndrome prophylaxis:',
        lines: [
          DoseLine('Child >8 yr and adult (limited data): 10,000–50,000 IU/dose PO once daily '
              'of water-miscible product'),
        ],
      ),
      DoseSection(
        heading: 'Cystic fibrosis (usually dosed in cystic fibrosis–specific '
            'multivitamins, but patients with liver disease may require higher '
            'doses; monitor serum concentrations):',
        lines: [
          DoseLine('Infant: 1500 IU/dose PO once daily'),
          DoseLine('Child 1–3 yr: 5000 IU/dose PO once daily'),
          DoseLine('Child 4–8 yr: 5000–10,000 IU/dose PO once daily'),
          DoseLine('Child ≥9 yr and adolescent: 10,000 IU/dose PO once daily'),
        ],
      ),
    ],
    remarks: [
      'High doses above the US RDA are teratogenic (category X). The use of '
          'vitamin A in measles is recommended in children 6 mo–2 yr of age who '
          'either are hospitalized or have any of the following risk factors: '
          'immunodeficiency, ophthalmologic evidence of vitamin A deficiency, '
          'impaired gastrointestinal (GI) absorption, moderate to severe '
          'malnutrition, and recent immigration from areas with high measles '
          'mortality. May cause GI disturbance, rash, headache, increased '
          'intracranial pressure (pseudotumor cerebri), papilledema, and '
          'irritability. Large doses may increase the effects of warfarin. Mineral '
          'oil, cholestyramine, and neomycin will reduce vitamin A absorption. Do '
          'not assess vitamin A levels during an acute inflammatory condition '
          'because falsely low levels have been reported.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1273',
  ),
  // VITAMIN B₁ — PDF p. 464 (printed 1273)  [cross-reference]
  DrugEntryV3(
    name: 'VITAMIN B₁',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Thiamine.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1273',
  ),
  // VITAMIN B₂ — PDF p. 464 (printed 1273)  [cross-reference]
  DrugEntryV3(
    name: 'VITAMIN B₂',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Riboflavin.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1273',
  ),
  // VITAMIN B₃ — PDF p. 465 (printed 1274)  [cross-reference]
  DrugEntryV3(
    name: 'VITAMIN B₃',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Niacin.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1274',
  ),
  // VITAMIN B₆ — PDF p. 465 (printed 1274)  [cross-reference]
  DrugEntryV3(
    name: 'VITAMIN B₆',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Pyridoxine.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1274',
  ),
  // VITAMIN B₁₂ — PDF p. 465 (printed 1274)  [cross-reference]
  DrugEntryV3(
    name: 'VITAMIN B₁₂',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Cyanocobalamin.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1274',
  ),
  // VITAMIN C — PDF p. 465 (printed 1274)  [cross-reference]
  DrugEntryV3(
    name: 'VITAMIN C',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Ascorbic Acid.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1274',
  ),
  // VITAMIN D₂ — PDF p. 465 (printed 1274)  [cross-reference]
  DrugEntryV3(
    name: 'VITAMIN D₂',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Ergocalciferol.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1274',
  ),
  // VITAMIN D₃ — PDF p. 465 (printed 1274)  [cross-reference]
  DrugEntryV3(
    name: 'VITAMIN D₃',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Cholecalciferol.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1274',
  ),
  // VITAMIN E/α-TOCOPHEROL — PDF p. 465 (printed 1274)
  DrugEntryV3(
    name: 'VITAMIN E/α-TOCOPHEROL',
    brandNames: 'Many brand names, including generics',
    drugClass: 'Vitamin, fat soluble',
    iconRow: '',
    formulations: [
      'Tabs [OTC]: 100, 200, 400 IU',
      'Caps [OTC]: 100, 200, 400, 1000 IU',
      'Oral solution (generic OTC): 50 IU/mL (30 mL); may contain propylene '
          'glycol, polysorbate 80, and saccharin',
      'Conversion: 400 IU is equivalent to 180 mg of vitamin E',
    ],
    doseSections: [
      DoseSection(
        heading: 'U.S. Recommended Daily Allowance (US RDA):',
        lines: [
          DoseLine('See Chapter 21.'),
        ],
      ),
      DoseSection(
        heading: 'Vitamin E deficiency and liver disease, PO:',
        lines: [
          DoseLine('Monitor levels closely and use water-miscible form (especially with '
              'malabsorption).'),
          DoseLine('Neonate: 25–50 IU/kg/24 hr'),
          DoseLine('Infant, child, and adolescent: 10–50 IU/kg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Cystic fibrosis supplementation (use water-miscible form; usually '
            'dosed in cystic fibrosis–specific multivitamins):',
        lines: [
          DoseLine('5–10 IU/kg/24 hr PO once daily; max. dose: 400 IU/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Adverse reactions include gastrointestinal distress, rash, headache, '
          'gonadal dysfunction, decreased serum thyroxine and triiodothyronine, and '
          'blurred vision. Necrotizing enterocolitis has been associated with large '
          'doses (>200 units/24 hr) of a hyperosmolar product administered to low '
          'birth weight infants. May increase hypoprothrombinemic response of oral '
          'anticoagulants (e.g., warfarin), especially in doses >400 IU/24 hr.',
      'In malabsorption, water-miscible preparations are better absorbed. '
          'Therapeutic levels: 6–14 mg/L.',
    ],
    pregnancyNote: 'Pregnancy category changes to “C” if used in doses above the US '
        'RDA.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1274',
  ),
  // VITAMIN K — PDF p. 466 (printed 1275)  [cross-reference]
  DrugEntryV3(
    name: 'VITAMIN K',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Phytonadione.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1275',
  ),
  // VORICONAZOLE — PDF p. 466–468 (printed 1275–1277)
  DrugEntryV3(
    name: 'VORICONAZOLE',
    brandNames: 'Vfend and generics',
    drugClass: 'Antifungal, triazole',
    iconRow: '',
    formulations: [
      'Tabs: 50, 200 mg; contains povidone',
      'Oral suspension: 40 mg/mL (75 mL); may contain sodium benzoate',
      'Injection: 200 mg; contains 3200 mg sulfobutyl ether β-cyclodextrin '
          '(SBECD) (see remarks)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Empirical doses; consider drug interactions and pharmacogenomic-based '
            'recommendations (see remarks). Between-patient and inter-occasion '
            'pharmacokinetic variability is high. Monitor trough level and adjust '
            'dose accordingly.',
      ),
      DoseSection(
        heading: 'Infant and child <2 yr (limited data):',
        lines: [
          DoseLine('Start with 9 mg/kg/dose IV/PO Q12 hr; monitor levels and adjust dose. '
              'Median dose of 31.5 mg/kg/24 hr ÷ 12 hr (range: 12–71 mg/kg/24 hr) has '
              'been reported to achieve target trough levels.'),
        ],
      ),
      DoseSection(
        heading: 'Child 2–≤12 yr and 12–14 yr weighing <50 kg:',
        lines: [
          DoseLine(
            'Invasive aspergillosis, candidemia (nonneutropenic), other deep tissue '
                'Candida infections, or other rare molds (e.g., Scedosporium and Fusarium):',
            isHeading: true,
          ),
          DoseLine('Loading dose: 9 mg/kg/dose IV Q12 hr × 2 followed by maintenance dose'),
          DoseLine('Maintenance dose: 8 mg/kg/dose IV Q12 hr and convert to the oral '
              'suspension dosage form after significant clinical improvement at a dose '
              'of 9 mg/kg/dose PO Q12 hr (max. dose: 350 mg Q12 hr). The oral suspension '
              'dosage form was used in clinical trials, and the bioequivalence of this '
              'dosage form and tablets has not been evaluated in children. Dosage '
              'increments and decrements of 1-mg/kg (or 50-mg) steps have been '
              'recommended for those with inadequate response and who are unable to '
              'tolerate their dosage level, respectively.'),
          DoseLine(
            'Esophageal candidiasis:',
            isHeading: true,
          ),
          DoseLine(
            'Treatment:',
            isHeading: true,
          ),
          DoseLine('IV: 4 mg/kg/dose Q12 hr'),
          DoseLine('PO: 9 mg/kg/dose Q12 hr; max. dose: 350 mg Q12 hr'),
          DoseLine(
            'Prophylaxis for candidiasis in high-risk acute myeloid leukemia (AML), '
                'acute lymphocytic leukemia (ALL), and allogeneic hematopoietic stem cell '
                'transplant (HSCT) patients (limited data):',
            isHeading: true,
          ),
          DoseLine('IV: 9 mg/kg/dose Q12 hr × 2 doses followed by 8 mg/kg/dose Q12 hr'),
          DoseLine('PO (oral suspension): 9 mg/kg/dose Q12 hr; max. dose: 350 mg/dose'),
        ],
      ),
      DoseSection(
        heading: 'Child 12–<15 yr weighing ≥50 kg, >15 yr (any weight), and adult:',
        lines: [
          DoseLine(
            'Invasive aspergillosis, candidemia (nonneutropenic), fusariosis, '
                'scedosporiosis, or other serious fungal infections:',
            isHeading: true,
          ),
          DoseLine('Loading dose: 6 mg/kg/dose (max.: 400 mg/dose) IV Q12 hr × 2 doses '
              'followed by maintenance dose'),
          DoseLine(
            'Maintenance dose:',
            isHeading: true,
          ),
          DoseLine('Candidemia (nonneutropenic): 3–4 mg/kg/dose IV Q12 hr'),
          DoseLine('Invasive aspergillosis, fusariosis, scedosporiosis, or other serious '
              'fungal infections: 4 mg/kg/dose IV Q12 hr; if patient unable to tolerate, '
              'reduce dose to 3 mg/kg/dose IV Q12 hr'),
          DoseLine('PO maintenance dose: Initial dose may be increased to the maximum dose '
              'when response is inadequate; if dose is not tolerated, reduce dose by '
              '50-mg decrements, until tolerated, with minimum of the initial '
              'recommended dose.'),
          DoseLine('<40 kg: 100 mg Q12 hr'),
          DoseLine('≥40 kg: 200 mg Q12 hr'),
          DoseLine('Esophageal candidiasis (secondary therapy; treat for a minimum of 14 days '
              'and until 7 days after resolution of symptoms): When response is '
              'inadequate, initial PO dose may be increased to the maximum dose by 50-mg '
              'increments for patients <40 kg and by 100-mg increments for patients ≥40 '
              'kg. If a titrated dose is not tolerated, reduce dose by 50-mg decrements '
              'until tolerated, with the minimum of the initial recommended dose.'),
          DoseLine('<40 kg: 100 mg Q12 hr PO'),
          DoseLine('≥40 kg: 200 mg Q12 hr PO'),
        ],
      ),
      DoseSection(
        heading: '',
        table: DoseTable(
          headers: ['CYP2C19 Phenotype', 'Pediatric Use Recommendation', 'Adult Use Recommendation'],
          rows: [
            DoseTableRow(['Ultrarapid metabolizer', 'Use alternative medicationᵃ', 'Use alternative medicationᵃ']),
            DoseTableRow(['Rapid metabolizer', 'Initiate with standard dosing with TDMᵇ', 'Use alternative medicationᵃ']),
            DoseTableRow(['Intermediate metabolizer', 'Initiate with standard dosing with TDMᵇ', 'Initiate with standard dosing with TDMᵇ']),
            DoseTableRow(['Poor metabolizer', 'Use alternative medicationᵃ; if voriconazole must be used, use a lower '
                'dose with TDMᵇ', 'Use alternative medicationᵃ; if voriconazole must be used, use a lower '
                'dose with TDMᵇ']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃAlternative medication should not be dependent on CYP2C19 metabolism and '
              'may include agents such as isavuco-'),
        ],
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('nazole, liposomal amphotericin B, and posaconazole.'),
        ],
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('TDM, Therapeutic drug monitoring.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated with concomitant administration of rifampin, '
          'carbamazepine, long-acting barbiturates, ritonavir, efavirenz, rifabutin, '
          'ergot alkaloids, or St. John’s wort (decreases voriconazole levels); and '
          'with terfenadine, astemizole, cisapride, finerenone, pimozide, naloxegol, '
          'tolvaptan, quinidine, or sirolimus (voriconazole increases levels of '
          'these drugs and thus increases side effects). Use with caution in '
          'proarrhythmic conditions (e.g., congenital/acquired Q–Tc prolongation, '
          'cardiomyopathy, and sinus bradycardia), severe hepatic disease, and '
          'galactose intolerance. Concurrent use with cytochrome P-450 (CYP) 3A4 '
          'substrates that can lead to prolonged Q–Tc interval (e.g., cisapride, '
          'ivabradine, pimozide, and quinidine) is contraindicated.',
      'Drug is a substrate and inhibitor for CYP2C9, CYP2C19 (major substrate), '
          'and CYP3A4 isoenzymes. Always check for interactions to determine risk of '
          'potential toxicities and use recommendation when used with other '
          'medications that have similar CYP substrate characteristics. Inhibition '
          'of CYP2C19 with omeprazole has been reported to boost voriconazole levels '
          'in a child, exhibiting rapid metabolism of voriconazole. Specific CYP2C19 '
          'pharmacogenomic phenotype and use recommendation for children and adults '
          'are as follows:',
      'Currently approved for use in invasive aspergillosis; candidemia, and '
          'disseminated candidiasis in skin, abdomen, kidney, bladder wall, and '
          'wounds; candidal esophagitis; and serious infections caused by Fusarium '
          'species and Scedosporium apiospermum in children ≥2 yr of age.',
      'Common side effects include gastrointestinal disturbances, fever, '
          'headache, hepatic abnormalities, photosensitivity (higher incidence in '
          'children; avoid direct sunlight and use protective measures), rash (6%), '
          'and visual disturbances (30%). Use with drugs associated with ultraviolet '
          '(UV) reactivation (e.g., methotrexate) increases risk for '
          'photosensitivity. Discontinue therapy with a dermatological follow-up for '
          'patients who develop photosensitivity reactions as squamous cell '
          'carcinoma and melanoma have been reported in those who experience this '
          'adverse reaction, especially with long-term use. Serious but rare side '
          'effects include anaphylaxis, liver or renal failure, and Stevens-Johnson '
          'syndrome. Drug rash with eosinophilia and systemic symptoms (DRESS) has '
          'been reported. Pancreatitis, hypoalbuminemia, dyspnea, dizziness, '
          'elevated liver function tests (LFTs), and renal impairment have been '
          'commonly reported in children. Monitoring serum transaminase and '
          'bilirubin levels weekly for the first month of therapy followed by '
          'reduced frequency has been recommended.',
      'Correct potassium, magnesium, and calcium levels before and during '
          'voriconazole therapy. Adjust dose in hepatic impairment by decreasing '
          'only the maintenance dose by 50% for patients with a Child-Pugh class A '
          'or B. Do not use IV dosage form for patients with glomerular filtration '
          'rate (GFR) <50 mL/min because of accumulation of the cyclodextrin '
          'excipient; switch to oral therapy if possible. Patients receiving '
          'concurrent phenytoin should increase their voriconazole maintenance doses '
          '(IV: 5 mg/kg/dose Q12 hr; PO: double the usual dose).',
      'Inter-occasion pharmacokinetic variability is high, thus requiring serum '
          'level monitoring. Therapeutic trough levels: 1–5.5 mg/L. Levels <1 mg/L '
          'have resulted in treatment failures and levels >5.5 mg/L have resulted in '
          'neurotoxicity, such as encephalopathy. Recommended serum sampling time: '
          'obtain trough within 30 min prior to a dose. Steady state is typically '
          'achieved after 5–7 days of initiating therapy.',
      'Oral bioequivalence of the oral suspension and tablet has not been '
          'evaluated in children. Administer IV over 1–2 hr with a max. rate of 3 '
          'mg/kg/hr at a concentration ≤5 mg/mL. Administer oral doses 1 hr before '
          'or 1 hr after meals.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1275–1277',
  ),
];
