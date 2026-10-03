// =============================================================================
// output/n.dart — Drug Formulary 3.0, letter N
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyN` per file; entries in book order.
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

const List<DrugEntryV3> formularyN = [
  // NAFCILLIN — PDF p. 312 (printed 1121)
  DrugEntryV3(
    name: 'NAFCILLIN',
    brandNames: 'Generics; previously available as Nallpen',
    drugClass: 'Antibiotic, penicillin (penicillinase resistant)',
    iconRow: '',
    formulations: [
      'Injection: 1, 2, 10 g; contains 2.9 mEq Na/g drug',
      'Injection, premixed in iso-osmotic dextrose: 2 g in 100 mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate (IM/IV):',
        lines: [
          DoseLine(
            '<1 kg:',
            isHeading: true,
          ),
          DoseLine('≤14 days old: 50 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine('15–28 days old: 75 mg/kg/24 hr ÷ Q8 hr'),
          DoseLine(
            '1–2 kg:',
            isHeading: true,
          ),
          DoseLine('≤7 days old: 50 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine('8–28 days old: 75 mg/kg/24 hr ÷ Q8 hr'),
          DoseLine(
            '>2 kg:',
            isHeading: true,
          ),
          DoseLine('≤7 days old: 75 mg/kg/24 hr ÷ Q8 hr'),
          DoseLine('8–28 days old: 100 mg/kg/24 hr ÷ Q6 hr'),
          DoseLine('Meningitis: Use twice the above mg/kg/24 hr dose with the same dosage '
              'interval.'),
        ],
      ),
      DoseSection(
        heading: 'Infant and child (IM/IV):',
        lines: [
          DoseLine('Mild to moderate infections: 100–150 mg/kg/24 hr ÷ Q6 hr'),
          DoseLine('Severe infections: 150–200 mg/kg/24 hr ÷ Q4–6 hr; give 200 mg/kg/24 hr ÷ '
              'Q4–6 hr for staphylococcal endocarditis or meningitis'),
          DoseLine('Max. dose: 12 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('IV: 1000–2000 mg Q4–6 hr'),
          DoseLine('IM: 500–1000 mg Q4–6 hr'),
          DoseLine('Max. dose: 12 g/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Allergic cross-sensitivity with penicillin. Solutions containing dextrose '
          'may be contraindicated in patients with known allergy to corn or corn '
          'products. High incidence of phlebitis with IV dosing. May cause rash, '
          'bone marrow suppression, and false-positive urinary and serum proteins. '
          'Hypokalemia has been reported. Acute interstitial nephritis is rare.',
      'Cerebrospinal fluid (CSF) penetration is poor unless meninges are '
          'inflamed. Use with caution in patients with combined renal and hepatic '
          'impairment (reduce dose by 33%–50%). Nafcillin may increase elimination '
          'of cyclosporine and warfarin.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1121',
  ),
  // NALOXONE — PDF p. 312–313 (printed 1121–1122)
  DrugEntryV3(
    name: 'NALOXONE',
    brandNames: 'Narcan, Kloxxado, RiVive, Rextovy, Zimhi, and generics',
    drugClass: 'Narcotic antagonist',
    iconRow: '',
    formulations: [
      'Injection: 0.4 mg/mL (1, 10 mL); some preparations may contain parabens',
      'Injection, in prefilled syringe; preservative-free:',
      'Generic: 0.4 mg/1 mL (1 mL), 2 mg/2 mL (2 mL)',
      'Zimhi: 5 mg/0.5 mL (0.5 mL); latex free',
      'Injection in single-dose Carpuject: 0.4 mg/mL (1 mL)',
      'Auto-injector: 10 mg/0.4 mL single-dose prefilled auto-injector (box of '
          '10)',
      'Nasal liquid:',
      'Narcan and generics: 4 mg/0.1 mL (1 or 2 each); may contain benzalkonium '
          'chloride and EDTA',
      'RiVive (OTC): 3 mg/0.1 mL (2 each)',
      'Rextovy: 4 mg/0.25 mL (2 each)',
      'Kloxxado: 8 mg/0.1 mL (2 each); contains 20% alcohol, EDTA, and propylene '
          'glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Opiate intoxication (full reversal, IM/IV/IO/SC, use 2–10 times IV '
            'dose for ETT route; see remarks):',
        lines: [
          DoseLine('Neonate, infant, child ≤20 kg or <5 yr (IV/IO route is preferred for '
              'faster onset of action): 0.1 mg/kg/dose; may repeat PRN Q2–3 min'),
          DoseLine('Child >20 kg or ≥5 yr (IV/IO route preferred): 2 mg/dose; may repeat PRN '
              'Q2–3 min'),
          DoseLine(
            'Zimhi:',
            isHeading: true,
          ),
          DoseLine('≥12 yr: 5 mg/dose × 1 SC or IM into the anterolateral aspect of the '
              'thigh, through clothing if necessary; may repeat PRN Q2–3 min'),
          DoseLine(
            'Auto-injector product (10 mg/0.4 mL; for suspected high-potency opiate '
                'intoxication, intended for chemical incident responders or military '
                'personnel):',
            isHeading: true,
          ),
          DoseLine('≥12 yr: 10 mg/dose x 1 SC or IM into the anterolateral aspect of the '
              'thigh, through clothing if necessary. May repeat PRN until emergency '
              'medical personnel are available.'),
          DoseLine('Continuous infusion (child and adult): 0.005 mg/kg loading dose followed '
              'by infusion of 0.0025 mg/kg/hr has been recommended. A range of '
              '0.0025–0.16 mg/kg/hr has been reported. Taper gradually to avoid relapse.'),
          DoseLine('Adult: 0.4–2 mg/dose; may repeat PRN Q2–3 min. Use 0.1- to 0.2-mg '
              'increments in opiate-dependent patients.'),
          DoseLine('Zimhi: 5 mg/dose × 1 SC or IM into the anterolateral aspect of the thigh, '
              'through clothing if necessary; may repeat PRN Q2–3 min'),
          DoseLine(
            'Auto-injector product (10 mg/0.4 mL) for suspected high-potency opiate '
                'intoxication:',
            isHeading: true,
          ),
          DoseLine('Administer one dose (10 mg) SC or IM into the anterolateral aspect of the '
              'thigh, through clothing if necessary, by pressing the device firmly until '
              'you hear a click and hiss sound and then hold in place for 5 seconds. If '
              'the patient’s symptoms relapse after the first dose, additional doses may '
              'be necessary.'),
        ],
      ),
      DoseSection(
        heading: 'Intranasal route for opiate intoxication (full reversal):',
        lines: [
          DoseLine('All ages: 4 or 8 mg of nasal liquid dosage form into one nostril Q2–3 min '
              'PRN in alternating nostrils.'),
          DoseLine('Opioid-dependent patient at risk for opioid withdrawal: Use lower 2 mg of '
              'nasal liquid dosage form into one nostril Q2–3 min PRN in alternating '
              'nostrils. Alternatively, the 2 mg/2 mL intravenous (IV) syringe dosage '
              'form with nasal adapter may be used by administering 1 mg (1 mL) per '
              'nostril.'),
        ],
      ),
      DoseSection(
        heading: 'Opiate-induced pruritus (limited data):',
        lines: [
          DoseLine('0.25–2 mCg/kg/hr IV; a dose-finding study in 59 children suggests a '
              'minimal dose of 1 mCg/kg/hr when used as prophylactic therapy. Doses ≥3 '
              'mCg/kg/hr increase the risk for reduced pain control.'),
        ],
      ),
    ],
    remarks: [
      'Short duration of action may necessitate multiple doses. For severe '
          'intoxication, doses of 0.2 mg/kg may be required. If no response is '
          'achieved after a cumulative dose of 10 mg, reevaluate diagnosis. In the '
          'nonarrest situation, use the lowest dose effective (may start at 0.001 '
          'mg/kg/dose). See Chapter 6 for additional information.',
      'Will produce narcotic withdrawal syndrome in patients with chronic '
          'dependence. Use with caution in patients with chronic cardiac disease. '
          'Abrupt reversal of narcotic depression may result in nausea, vomiting, '
          'diaphoresis, tachycardia, hypertension, and tremulousness. Aggressive '
          'behavior has been reported in abrupt reversal of an opioid overdose. '
          'False-positive test for urine opiates screen may occur.',
      'IV administration is preferred for faster onset of action. Onset of '
          'action may be delayed with other routes of administration; the intranasal '
          'route is slightly delayed compared to IM or IV routes.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1121–1122',
  ),
  // NAPROXEN/NAPROXEN SODIUM — PDF p. 314–315 (printed 1123–1124)
  DrugEntryV3(
    name: 'NAPROXEN/NAPROXEN SODIUM',
    brandNames: 'Naprosyn, EC-Naprosyn, Naprelan, Aleve [OTC], and many others, '
        'including generics',
    drugClass: 'Nonsteroidal anti-inflammatory agent',
    iconRow: '',
    formulations: [
      'Naproxen:',
      'Tabs: 250, 375, 500 mg',
      'Delayed-release tabs:',
      'EC-Naprosyn: 375, 500 mg',
      'Anaprox DS: 550 mg',
      'Oral suspension (generics): 125 mg/5 mL; contains 0.34 mEq Na/1 mL and '
          'parabens',
      'Naproxen sodium:',
      'Caps:',
      'Aleve: 220 mg',
      'Tabs:',
      'Generics and other brand names (OTC): 220 mg (200 mg base); contains 0.87 '
          'mEq Na',
      'Generics: 275 mg (250 mg base), 550 mg (500 mg base); contains 1 mEq, 2 '
          'mEq Na, respectively',
      'Controlled-release tabs:',
      'Naprelan and generics: 412.5 mg (375 mg base), 550 mg (500 mg base), 825 '
          'mg (750 mg base)',
    ],
    doseSections: [
      DoseSection(
        heading: 'All doses based on naproxen base.',
      ),
      DoseSection(
        heading: 'Child >2 yr:',
        lines: [
          DoseLine('Analgesia: 5–10 mg/kg/dose PO Q12 hr; max. dose: 1000 mg/24 hr'),
          DoseLine('JIA: 10–15 mg/kg/24 hr PO ÷ Q12 hr; max. dose: 1000 mg/24 hr'),
          DoseLine('Ankylosing spondylitis: 15–20 mg/kg/24 hr PO ÷ Q12 hr; max. dose: 1500 '
              'mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adolescent and adult:',
        lines: [
          DoseLine(
            'Analgesia:',
            isHeading: true,
          ),
          DoseLine('Over-the-counter dosage forms: 200 mg Q8–12 hr PO PRN (400-mg initial '
              'dose may be needed); max. dose: 600 mg/24 hr'),
          DoseLine('Prescription-strength dosage forms (immediate release): 250 mg Q8–12 hr '
              'PO PRN (500-mg initial dose may be needed) or 500 mg Q12 hr PO PRN. max. '
              'dose: 1250 mg/24 hr for first day, then 1000 mg/24 hr'),
          DoseLine(
            'Rheumatoid arthritis, ankylosing spondylitis:',
            isHeading: true,
          ),
          DoseLine('Immediate-release dosage forms: 250–500 mg PO BID'),
          DoseLine(
            'Delayed-release tabs:',
            isHeading: true,
          ),
          DoseLine('EC-Naprosyn: 375–500 mg PO BID'),
          DoseLine('Controlled-release tabs (Naprelan): 750–1000 mg PO once daily. For '
              'patients converting from immediate- and delayed-release forms, calculate '
              'daily dose and administer Naprelan as a single daily dose.'),
          DoseLine('Max. dose (all dosage forms): 1500 mg/24 hr'),
          DoseLine(
            'Dysmenorrhea:',
            isHeading: true,
          ),
          DoseLine('Immediate-release dosage forms: 500 mg × 1 PO, then 250 mg Q6–8 hr PO PRN '
              'or 500 mg Q12 hr PO PRN; max. dose: 1250 mg/24 hr for first day, then '
              '1000 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in treating perioperative pain for coronary artery bypass '
          'graft surgery. May cause GI bleeding, thrombocytopenia, heartburn, '
          'headache, drowsiness, vertigo, and tinnitus. Use with caution in patients '
          'with GI disease, cardiac disease (risk for thrombotic events, myocardial '
          'infarction [MI], stroke), or renal or hepatic impairment, and those '
          'receiving anticoagulants. Drug reactions with eosinophilia and systemic '
          'symptoms (DRESS), and serious skin reactions (e.g., SJS, TEN, fixed drug '
          'eruption, and generalized bullous fixed drug eruption) have been '
          'reported. False-positive test for urine cannabinoid screen may occur.',
      'Use is NOT recommended for moderate/severe renal impairment (CrCl <30 '
          'mL/min). See Ibuprofen for other side effects.',
      'Administer doses with food or milk to reduce GI discomfort.',
    ],
    pregnancyNote: 'Pregnancy category is “C” for prior to 30 weeks’ gestation and “X” '
        'for 30 wk and greater. Avoid use at >30 weeks’ gestation due to '
        'increased risk for premature closure of the fetal ductus '
        'arteriosus. Limit dose and duration of use at 20–30 weeks’ '
        'gestation for concerns of fetal renal dysfunction and '
        'oligohydramnios.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1123–1124',
  ),
  // NEO-POLYCIN HC — PDF p. 315 (printed 1124)  [cross-reference]
  DrugEntryV3(
    name: 'NEO-POLYCIN HC',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Neomycin/polymyxin B Ophthalmic Products.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1124',
  ),
  // NEO-POLYMYCIN OPHTHALMIC OINTMENT — PDF p. 315 (printed 1124)  [cross-reference]
  DrugEntryV3(
    name: 'NEO-POLYMYCIN OPHTHALMIC OINTMENT',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Neomycin/polymyxin B Ophthalmic Products.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1124',
  ),
  // NEOMYCIN SULFATE — PDF p. 315 (printed 1124)
  DrugEntryV3(
    name: 'NEOMYCIN SULFATE',
    brandNames: 'Generics',
    drugClass: 'Antibiotic, aminoglycoside; ammonium detoxicant',
    iconRow: '',
    formulations: [
      'Tabs: 500 mg',
      'Oral solution: 25 mg/mL; contains parabens',
      '125 mg neomycin sulfate is equivalent to 87.5 mg neomycin base.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Enteric bacterial eradication (limited data):',
        lines: [
          DoseLine('Preterm (>1.2 kg), newborn, infant, child, and adolescent: 50–100 '
              'mg/kg/24 hr PO ÷ Q6 hr (max. dose: 12 g/24 hr) for up to 2 wk'),
        ],
      ),
      DoseSection(
        heading: 'Hepatic encephalopathy (limited data):',
        lines: [
          DoseLine('Infant, child, and adolescent: 50–100 mg/kg/24 hr PO ÷ Q6–8 hr × 5–6 '
              'days; max. dose: 12 g/24 hr'),
          DoseLine('Adult: 4–12 g/24 hr PO ÷ Q4–6 hr × 5–6 days'),
        ],
      ),
      DoseSection(
        heading: 'Bowel prep (in combination with erythromycin base; many other '
            'regimens exist):',
        lines: [
          DoseLine('Child: 90 mg/kg/24 hr PO ÷ Q4 hr × 2–3 days'),
          DoseLine('Adult: 1 g Q1 hr PO × 4 doses, then 1 g Q4 hr PO × 5 doses'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in ulcerative bowel disease, intestinal obstruction, or '
          'aminoglycoside hypersensitivity. Monitor for nephrotoxicity and '
          'ototoxicity. Oral absorption is limited, but levels may accumulate. '
          'Consider dosage reduction in the presence of renal failure. May cause '
          'itching, redness, edema, colitis, candidiasis, or poor wound healing if '
          'applied topically. Prevalence of neomycin hypersensitivity has increased. '
          'May decrease absorption of penicillin V, vitamin B₁₂, digoxin, and '
          'methotrexate. May potentiate oral anticoagulants and the adverse effects '
          'of other neurotoxic, ototoxic, or nephrotoxic drugs.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1124',
  ),
  // NEOMYCIN/POLYMYXIN B OPHTHALMIC PRODUCTS — PDF p. 316–317 (printed 1125–1126)
  DrugEntryV3(
    name: 'NEOMYCIN/POLYMYXIN B OPHTHALMIC PRODUCTS',
    brandNames: 'Neomycin/Polymyxin B + Bacitracin:\nNeo-Polycin and generics\n'
        'Neomycin/Polymyxin B + Dexamethasone:\nMaxitrol\nNeomycin/Polymyxin '
        'B + Gramicidin:\nGenerics; previously available as Neosporin '
        'Ophthalmic Solution\nNeomycin/Polymyxin B + Hydrocortisone:\n'
        'Generics\nNeomycin/Polymyxin B + Bacitracin + Hydrocortisone:\n'
        'Neo-Polycin HC and generics',
    drugClass: 'Ophthalmic antibiotic ± corticosteroid',
    iconRow: '',
    formulations: [
      'Neomycin/Polymyxin B + Bacitracin:',
      'Ophthalmic ointment (Neo-Polycin Ophthalmic Ointment and generics): 3.5 g '
          'neomycin, 10,000 U polymyxin B, and 400 U bacitracin per 1 g ointment '
          '(3.5 g)',
      'Neomycin/Polymyxin B + Dexamethasone:',
      'Ophthalmic ointment (Maxitrol): 3.5 mg neomycin, 10,000 U polymyxin B, '
          'and 1 mg dexamethasone per 1 g (3.5 g)',
      'Ophthalmic suspension (Maxitrol): 3.5 mg neomycin, 10,000 U polymyxin B, '
          'and 1 mg dexamethasone per 1 mL (5 mL); contains benzalkonium chloride',
      'Neomycin/Polymyxin B + Gramicidin:',
      'Ophthalmic solution: 1.75 neomycin, 10,000 U polymyxin B, and 0.025 mg '
          'gramicidin per 1 mL (10 mL); contains propylene glycol, alcohol, and '
          'thimerosal',
      'Neomycin/Polymyxin B + Hydrocortisone:',
      'Ophthalmic suspension: 3.5 mg neomycin, 10,000 U polymyxin B, and 10 mg '
          'hydrocortisone per 1 mL (7.5 mL)',
      'Neomycin/Polymyxin B + Bacitracin + Hydrocortisone:',
      'Ophthalmic ointment (Neo-Polycin HC and generics): 3.5 mg neomycin, '
          '10,000 U polymyxin B, 400 U bacitracin, and 10 mg hydrocortisone per 1 g '
          '(3.5 g)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neomycin/Polymyxin B + Bacitracin (Neo-Polycin and generics):',
        lines: [
          DoseLine('Child and adult: Apply 0.5-inch ribbon to affected eye(s) Q3–4 hr for '
              'acute infections or BID–TID for mild/moderate infections × 7–10 days. Do '
              'not dispense >8 g and should not be refilled without further evaluation.'),
        ],
      ),
      DoseSection(
        heading: 'Neomycin/Polymyxin B + Dexamethasone (Maxitrol):',
        lines: [
          DoseLine(
            'Child (≥2 yr)–adult:',
            isHeading: true,
          ),
          DoseLine('Ophthalmic suspension: Instill 1–2 drops into the conjunctival sac of the '
              'affected eye(s) 4–6 times per day for mild/moderate infections. For '
              'severe infections, administer Q1 hr and taper to discontinuation as '
              'inflammation subsides. No more than 20 mL should be prescribed initially '
              'and should not be refilled without further evaluation.'),
          DoseLine('Ophthalmic ointment: Apply ~0.5-inch ribbon into the conjunctival sac of '
              'the affected eye(s) TID–QID. Reevaluate diagnosis if signs and symptoms '
              'do not improve in 48 hr. Do not dispense >8 g and should not be refilled '
              'without further evaluation.'),
        ],
      ),
      DoseSection(
        heading: 'Neomycin/Polymyxin B + Gramicidin:',
        lines: [
          DoseLine('Child and adult: Instill 1–2 drops to affected eye(s) Q4 hr or 2 drops '
              'every hour for severe infections × 7–10 days.'),
        ],
      ),
      DoseSection(
        heading: 'Neomycin/Polymyxin B + Hydrocortisone:',
        lines: [
          DoseLine('Child (limited data) and adult: Instill 1–2 drops to affected eye(s) Q3–4 '
              'hr. More frequent dosing has been used for severe infection in adults.'),
        ],
      ),
      DoseSection(
        heading: 'Neomycin/Polymyxin B + Bacitracin + Hydrocortisone (Neo-Polycin HC '
            'and generics):',
        lines: [
          DoseLine('Child (limited data) and adult: Apply ointment sparingly to inside of '
              'lower lid of affected eye(s) Q3–4 hr. Reevaluate diagnosis if signs and '
              'symptoms do not improve in 48 hr. Monitor intraocular pressure if use is '
              '≥10 days.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated if patient is hypersensitive to specific medications '
          '(e.g., neomycin, polymyxin B, gramicidin, bacitracin, or hydrocortisone) '
          'of respective product. Use with caution in glaucoma. Blurred vision, '
          'burning, and stinging may occur. Increased intraocular pressure and '
          'mycosis may occur with prolonged use. Avoid prolonged use with products '
          'containing corticosteroids.',
      'Ophthalmic solution/suspension: Shake well before use and avoid '
          'contamination of tip of eye dropper. Apply finger pressure to lacrimal '
          'sac during and 1–2 min after dose application.',
      'Ophthalmic ointment: Do not touch tube tip to eyelids or other surfaces '
          'to prevent contamination.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1125–1126',
  ),
  // NEOMYCIN/POLYMYXIN B/BACITRACIN — PDF p. 317 (printed 1126)
  DrugEntryV3(
    name: 'NEOMYCIN/POLYMYXIN B/BACITRACIN',
    brandNames: 'Neosporin Original, Triple Antibiotic, and various generics',
    drugClass: 'Topical antibiotic',
    iconRow: '',
    formulations: [
      'Ointment, topical (OTC): 3.5 mg neomycin sulfate, 400 U bacitracin, and '
          '5000 U polymyxin B/g (1, 14.2, 15, 28.4, 30 g)',
      'For ophthalmic products, see Neomycin/Polymyxin B Ophthalmic Products.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Prevention of infection from minor cuts, scrapes and burns:',
        lines: [
          DoseLine('Child and adult: Apply to minor wounds and burns once daily–TID.'),
        ],
      ),
    ],
    remarks: [
      'Do not use for extended periods. May cause superinfection, delayed '
          'healing. See Neomycin for additional remarks. Prevalence of neomycin '
          'hypersensitivity has increased.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1126',
  ),
  // NEOSTIGMINE — PDF p. 317–318 (printed 1126–1127)
  DrugEntryV3(
    name: 'NEOSTIGMINE',
    brandNames: 'Bloxiverz and generics',
    drugClass: 'Anticholinesterase (cholinergic) agent',
    iconRow: '',
    formulations: [
      'Injection (Bloxiverz and generics): 0.5, 1 mg/mL (10 mL) (as '
          'methylsulfate); contains phenol',
      'Prefilled syringe injection: 1 mg/mL (3, 5 mL) (as methylsulfate); may '
          'contain phenol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Myasthenia gravis diagnosis:',
        lines: [
          DoseLine('Use with atropine (see remarks).'),
          DoseLine('Child: 0.025–0.04 mg/kg IM × 1'),
          DoseLine('Adult: 1.5 mg IM × 1'),
        ],
      ),
      DoseSection(
        heading: 'Treatment:',
        lines: [
          DoseLine('Child: 0.01–0.04 mg/kg/dose IM/IV/SC Q2–4 hr PRN'),
          DoseLine('Adult: 0.5–2.5 mg/dose IM/IV/SC Q1–3 hr PRN up to max. dose of 10 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Reversal of nondepolarizing neuromuscular blocking agents:',
        lines: [
          DoseLine('Administer with atropine or glycopyrrolate.'),
          DoseLine('All ages: 0.03–0.07 mg/kg/dose IV; max. dose: 5 mg/dose'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in GI and urinary obstruction. Caution in patients with '
          'asthma. May cause cholinergic crisis, bronchospasm, salivation, nausea, '
          'vomiting, diarrhea, miosis, diaphoresis, lacrimation, bradycardia, '
          'hypotension, fatigue, confusion, respiratory depression, and seizures. '
          'Titrate for each patient, but avoid excessive cholinergic effects.',
      'For reversal of neuromuscular blockade, infants and small children may be '
          'at greater risk of complications from incomplete reversal of '
          'neuromuscular blockade due to decreased respiratory reserve.',
      'For diagnosis of myasthenia gravis (MG), administer atropine 0.011 '
          'mg/kg/dose IV immediately before or IM (0.011 mg/kg/dose) 30 min before '
          'neostigmine. For treatment of MG, patients may need higher doses of '
          'neostigmine at times of greatest fatigue.',
      'Antidote: Atropine 0.01–0.04 mg/kg/dose. Atropine and epinephrine should '
          'be available in the event of a hypersensitivity reaction.',
      'Adjust dose in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1126–1127',
  ),
  // NEVIRAPINE — PDF p. 318–319 (printed 1127–1128)
  DrugEntryV3(
    name: 'NEVIRAPINE',
    brandNames: 'Generics; previously available as Viramune; NVP',
    drugClass: 'Antiviral, nonnucleoside reverse transcriptase inhibitor',
    iconRow: '',
    formulations: [
      'Tabs: 200 mg',
      'Extended-release tabs: 400 mg',
      'Oral suspension: 10 mg/mL (240 mL); contains parabens, propylene glycol, '
          'and polysorbate 80',
    ],
    doseSections: [
      DoseSection(
        heading: 'HIV treatment:',
        lines: [
          DoseLine('See https://clinicalinfo.hiv.gov/en/guidelines'),
        ],
      ),
      DoseSection(
        heading: 'Prevention of HIV vertical transmission during high-risk situations '
            '(mothers who received no antepartum antiretroviral therapy, mothers '
            'who received only intrapartum antiretroviral therapy, mothers who '
            'receive antepartum antiretroviral therapy but with suboptimal viral '
            'suppression [>50 copies/mL] within 4 wk prior to delivery, or mothers '
            'with acute or primary HIV infection during pregnancy or breastfeeding '
            '[immediately discontinue breastfeeding]); see Chapter 17 for '
            'additional information:',
        lines: [
          DoseLine('Newborn: Use in combination as part of a 2-drug regimen within 6–12 hr '
              'after birth (discontinue this regimen and convert to presumptive '
              'treatment regimen if HIV diagnosis is obtained): 3 doses (based on birth '
              'weight) in the first week of life; dose 1: within 48 hr of birth; dose 2: '
              '48 hr after dose 1; dose 3: 96 hr after dose 2'),
          DoseLine('Birth weight 1.5–2 kg: 8 mg/dose PO'),
          DoseLine('Birth weight >2 kg: 12 mg/dose PO'),
        ],
      ),
      DoseSection(
        heading: 'HIV vertical transmission and presumptive treatment during high-risk '
            'situations (see above). Use in combination as part of a 3-drug '
            'regimen initiated within 6–12 hr after birth; transition to a '
            'treatment regimen if positive HIV diagnosis is confirmed and '
            'discontinue use after a negative diagnosis (see Chapter 17 for '
            'additional information):',
        lines: [
          DoseLine(
            '≥32–<34 weeks’ gestation at birth (dosage based on pharmacokinetic '
                'modeling and simulation and has not been evaluated in clinical trials):',
            isHeading: true,
          ),
          DoseLine('Birth–2 wk old: 2 mg/kg/dose PO BID; first dose within 6–12 hr after '
              'delivery'),
          DoseLine('>2–4 wk old: 4 mg/kg/dose PO BID'),
          DoseLine('>4–6 wk old: 6 mg/kg/dose PO BID'),
          DoseLine('>6 wk old (use this higher dose only if infant has a confirmed HIV '
              'diagnosis): 200 mg/m²/dose PO BID'),
          DoseLine(
            '≥34–<37 weeks’ gestation at birth (dosage based on pharmacokinetic and '
                'safety data):',
            isHeading: true,
          ),
          DoseLine('Birth–1 wk old: 4 mg/kg/dose PO BID; first dose within 6–12 hr after '
              'delivery'),
          DoseLine('>1–4 wk old: 6 mg/kg/dose PO BID'),
          DoseLine('>4 wk old (use this higher dose only if infant has a confirmed HIV '
              'diagnosis): 200 mg/m²/dose PO BID'),
          DoseLine(
            '≥37 weeks’ gestation at birth (dosage based on pharmacokinetic and safety '
                'data):',
            isHeading: true,
          ),
          DoseLine('Birth–4 wk old: 6 mg/kg/dose PO BID; first dose within 6–12 hr after '
              'delivery'),
          DoseLine('>4 wk old (use this higher dose only if infant has a confirmed HIV '
              'diagnosis): 200 mg/m²/dose PO BID'),
        ],
      ),
    ],
    remarks: [
      'See https://clinicalinfo.hiv.gov/en/guidelines for additional remarks.',
      'Use with caution in patients with hepatic or renal dysfunction. '
          'Contraindicated in moderate/severe hepatic impairment (Child-Pugh class B '
          'or C) and postexposure (occupational or nonoccupational) prophylactic '
          'regimens. Most frequent side effects with continuous therapy include skin '
          'rash (may be life threatening, including Stevens-Johnson syndrome and '
          'DRESS; permanently discontinue and never restart), fever, abnormal liver '
          'function tests, headache, and nausea. Discontinue therapy if any of the '
          'following occurs: severe rash; rash with fever, blistering, oral lesions, '
          'conjunctivitis, or muscle aches. Permanently discontinue and do not '
          'restart therapy if symptomatic hepatitis, severe transaminase elevations, '
          'or hypersensitivity reactions occur.',
      'Life-threatening hepatotoxicity has been reported primarily during the '
          'first 12 wk of continuous therapy. Patients with increased serum '
          'transaminase or a history of hepatitis B or C infection prior to '
          'nevirapine are at greater risk for hepatotoxicity. Women, including '
          'pregnant women, with CD4 cell counts >250/mm³ or men with CD4 cell counts '
          '>400/mm³ are at risk for hepatotoxicity. Monitor liver function tests '
          '(obtain transaminases immediately after development of hepatitis '
          'signs/symptoms, hypersensitivity reactions, or rash) and complete blood '
          'counts. Hypophosphatemia has been reported.',
      'Nevirapine induces the cytochrome P-450 3A4 drug-metabolizing isoenzyme '
          'to cause an autoinduction of its own metabolism within the first 2–4 wk '
          'of therapy and has the potential to interact with many drugs. Carefully '
          'review the patient’s drug profile for other drug interactions each time '
          'nevirapine is initiated or when a new drug is added to a regimen '
          'containing nevirapine.',
      'Doses can be administered with food and concurrently with didanosine.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1127–1128',
  ),
  // NIACIN/VITAMIN B₃ — PDF p. 319–320 (printed 1128–1129)
  DrugEntryV3(
    name: 'NIACIN/VITAMIN B₃',
    brandNames: 'Niacor, Slo-Niacin, Nicotinic acid, Vitamin B₃, and many generics',
    drugClass: 'Vitamin, water soluble',
    iconRow: '',
    formulations: [
      'Tabs:',
      'Generics (OTC): 50, 100, 250, 500 mg',
      'Niacor: 500 mg',
      'Timed or extended-release tabs:',
      'Generics: 250 (OTC), 500, 750, 1000 mg',
      'Slo-Niacin (OTC): 500, 750 mg',
      'Caps (OTC): 100, 500 mg',
      'Timed or extended-release caps (OTC): 250, 500 mg',
      'Powder (OTC): 100, 500, 1000 g',
    ],
    doseSections: [
      DoseSection(
        heading: 'US recommended dietary allowance (RDA):',
        lines: [
          DoseLine('See Chapter 21.'),
        ],
      ),
      DoseSection(
        heading: 'Pellagra (PO):',
        lines: [
          DoseLine('Usual treatment duration is 3–4 wk'),
          DoseLine('Child: 50–100 mg/dose TID'),
          DoseLine('Adult: 50–100 mg/dose TID–QID'),
          DoseLine('Max. dose: 500 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in hepatic dysfunction, active peptic ulcer, and severe '
          'hypotension. Use with caution in unstable angina, acute MI (especially if '
          'patient is receiving vasoactive drugs), and renal dysfunction, and in '
          'patients with history of jaundice, hepatobiliary disease, or peptic '
          'ulcer. Adverse reactions of flushing, pruritus, or GI distress may occur '
          'with oral administration. May cause hyperglycemia, hyperuricemia, blurred '
          'vision, abnormal liver function tests, dizziness, and headaches. Burning '
          'sensation of the skin, skin discoloration, acanthosis nigricans, '
          'hepatitis, and elevated creatine kinase have been reported. May cause '
          'false-positive urine catecholamines (fluorometric methods) and urine '
          'glucose (Benedict reagent).',
      'Use with statins may increase the risk of myopathy/rhabdomyolysis. Bile '
          'acid sequestrants (e.g., cholestyramine) may bind to niacin and should be '
          'taken at least 4–6 hr before niacin administration.',
    ],
    pregnancyNote: 'Pregnancy category changes to “C” if used in doses above the RDA '
        'or for typical doses used for lipid disorders. Breastfeeding '
        'should be discontinued when used for the treatment of '
        'dyslipidemias for mothers as hepatotoxicity is a potential to the '
        'infant. See Chapter 21 for multivitamin preparations.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1128–1129',
  ),
  // NICARDIPINE — PDF p. 320–321 (printed 1129–1130)
  DrugEntryV3(
    name: 'NICARDIPINE',
    brandNames: 'Cardene IV and generics',
    drugClass: 'Calcium channel blocker, antihypertensive',
    iconRow: '',
    formulations: [
      'Caps (immediate release): 20, 30 mg',
      'Injection:',
      'Cardene IV: 0.1 mg/mL (200 mL; premixed in isotonic saline), 0.2 mg/mL '
          '(200 mL; premixed in isotonic saline)',
      'Generic: 2.5 mg/mL (10 mL); may contain sorbitol or benzoic acid',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child (see remarks):',
        lines: [
          DoseLine(
            'Hypertension:',
            isHeading: true,
          ),
          DoseLine('Continuous IV infusion for severe hypertension: Start at 0.5–1 '
              'mCg/kg/min; dose may be increased as needed every 15–30 min up to a max. '
              'of 4–5 mCg/kg/min.'),
        ],
      ),
      DoseSection(
        heading: 'Adult (see remarks):',
        lines: [
          DoseLine(
            'Hypertension:',
            isHeading: true,
          ),
          DoseLine('Oral: 20 mg PO TID; dose may be increased after 3 days to 40 mg PO TID if '
              'needed'),
          DoseLine('Continuous IV infusion: Start at 5 mg/hr; increase dose as needed by 2.5 '
              'mg/hr Q5–15 min up to a max. dose of 15 mg/hr. Following attainment of '
              'desired BP, decrease infusion to 3 mg/hr and adjust rate as needed to '
              'maintain desired response.'),
        ],
      ),
    ],
    remarks: [
      'Reported use in children has been limited to a small number of preterm '
          'infants, infants, and children.',
      'Contraindicated in advanced aortic stenosis. Avoid systemic hypotension '
          'in patients following an acute cerebral infarct or hemorrhage. Use with '
          'caution in hepatic or renal dysfunction by carefully titrating dose. The '
          'drug undergoes significant first-pass metabolism through the liver and is '
          'excreted in the urine (60%). Use caution when converting to another '
          'dosage form; they are NOT equivalent on a milligram-per-milligram basis.',
      'May cause headache, dizziness, asthenia, peripheral edema, and GI '
          'symptoms. Nicardipine is a substrate for cytochrome P-450 (CYP) 3A and '
          'inhibitor of CYP2C9/2C19. Cimetidine increases the effects/toxicity of '
          'nicardipine. Nicardipine may increase effect/toxicity of cyclosporine and '
          'tacrolimus. See Nifedipine for additional drug and food interactions.',
      'Onset of action for orally administered drug is 20 min with peak effects '
          'in 0.5–2 hr. Onset of action of intravenously administered drug is 1 min. '
          'Duration of action following a single IV or PO dose is 3 hr. To reduce '
          'the risk for venous thrombosis, phlebitis, and vascular impairment with '
          'IV administration, do not use small veins (e.g., dorsum of hand or '
          'wrist). Avoid intra-arterial administration or extravasation. For '
          'additional information, see Chapter 4.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1129–1130',
  ),
  // NIFEDIPINE — PDF p. 321–322 (printed 1130–1131)
  DrugEntryV3(
    name: 'NIFEDIPINE',
    brandNames: 'Procardia XL and many generics; previously available as Procardia '
        'and Adalat CC',
    drugClass: 'Calcium channel blocker, antihypertensive',
    iconRow: '',
    formulations: [
      'Caps: 10 mg (0.34 mL), 20 mg (0.45 mL)',
      'Sustained-release tabs: (Procardia XL and generics): 30, 60, 90 mg',
      'Oral suspension: 4 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child (see remarks for precautions):',
        lines: [
          DoseLine(
            'Chronic hypertension:',
            isHeading: true,
          ),
          DoseLine('Sustained-release tabs: Start with 0.2–0.5 mg/kg/24 hr PO (initial max. '
              'dose: 30–60 mg/24 hr) ÷ Q12–24 hr. May increase to max. dose: 3 mg/kg/24 '
              'hr up to 120 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine(
            'Chronic hypertension or angina:',
            isHeading: true,
          ),
          DoseLine('Sustained-release tabs: Start with 30 or 60 mg PO once daily. May '
              'increase to max. dose of 120 mg/24 hr. Dosing above 90 mg/24 hr for '
              'angina is limited and should be used with caution.'),
        ],
      ),
    ],
    remarks: [
      'Use of immediate-release dosage form in children is controversial and has '
          'been abandoned by many. Use with caution in children with acute CNS '
          'injury due to increased risk for stroke, seizure, hepatic impairment, and '
          'altered level of consciousness. To prevent rapid decrease in blood '
          'pressure in children, an initial dose of ≤0.25 mg/kg is recommended.',
      'Use with caution in patients with congestive heart failure (CHF), aortic '
          'stenosis, GI obstruction/narrowing (bezoar formation), and cirrhosis '
          '(reduced drug clearance). May cause severe hypotension, peripheral edema, '
          'flushing, tachycardia, headaches, dizziness, nausea, palpitations, and '
          'syncope. Acute generalized exanthematous pustulosis has been reported.',
      'Although overall use in adults has been abandoned, the immediate-release '
          'dosage form is contraindicated in adults with severe obstructive coronary '
          'artery disease or recent MI and in hypertensive emergencies.',
      'Nifedipine is a substrate for cytochrome P-450 (CYP) 3A3/3A4 and 3A5-7. '
          'Do not administer with grapefruit juice; may increase bioavailability and '
          'effects. Itraconazole and ketoconazole may increase nifedipine levels '
          'and/or effects. CYP3A inducers (e.g., rifampin, rifabutin, phenobarbital, '
          'phenytoin, carbamazepine) may reduce nifedipine’s effects. Nifedipine may '
          'increase phenytoin, cyclosporine, and digoxin levels. For hypertensive '
          'emergencies, see Chapter 4.',
      'For sublingual (SL) administration, capsule must be punctured and liquid '
          'expressed into the patient’s mouth. A small amount is absorbed via the SL '
          'route. Most effects are due to swallowing and oral absorption. Do not '
          'crush or chew sustained-release tablet dosage form.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1130–1131',
  ),
  // NIRSEVIMAB — PDF p. 322 (printed 1131)
  DrugEntryV3(
    name: 'NIRSEVIMAB',
    brandNames: 'Beyfortus',
    drugClass: 'Monoclonal antibody',
    iconRow: '',
    formulations: [
      'Injection (prefilled single-use syringes): 50 mg/0.5 mL, 100 mg/1 mL; '
          'contains arginine, histidine, polysorbate 80, and sucrose (preservative '
          'free)',
    ],
    doseSections: [
      DoseSection(
        heading: 'RSV prophylaxis for neonates and infants born during or entering '
            'their first RSV season (infants born during RSV season should be '
            'dosed within 1 wk of birth):',
        lines: [
          DoseLine('<5 kg: 50 mg IM x 1'),
          DoseLine('≥5 kg: 100 mg IM x 1'),
        ],
      ),
      DoseSection(
        heading: 'Children <24 mo old who remain at increased risk for severe RSV '
            '(e.g., chronic lung disease of prematurity requiring medical support, '
            'severe immunocompromise, cystic fibrosis, American Indian or Alaska '
            'Native) during their second RSV season:',
        lines: [
          DoseLine('200 mg x 1 administered as two 100-mg IM injections'),
        ],
      ),
      DoseSection(
        heading: 'Children undergoing cardiac surgery with cardiopulmonary bypass:',
        lines: [
          DoseLine('an additional dose is recommended as soon as the child is stable after '
              'surgery'),
          DoseLine(
            'First RSV season:',
            isHeading: true,
          ),
          DoseLine(
            'Surgery ≤90 days after receiving nirsevimab:',
            isHeading: true,
          ),
          DoseLine('<5 kg: 50 mg IM x 1'),
          DoseLine('≥5 kg: 100 mg IM x 1'),
          DoseLine('Surgery >90 days after receiving nirsevimab: , 50 mg IM x 1'),
          DoseLine(
            'Second RSV season:',
            isHeading: true,
          ),
          DoseLine('Surgery ≤90 days after receiving nirsevimab: 200 mg x 1 administered as '
              'two 100-mg IM injections'),
          DoseLine('Surgery >90 days after receiving nirsevimab: 100 mg IM x 1'),
        ],
      ),
    ],
    remarks: [
      'Use is not recommended for infants whose mothers received RSVpreF '
          '(Abrysvo) vaccine at 32–36 wk of pregnancy where at least 14 days have '
          'elapsed between vaccine administration and birth. Administer with caution '
          'with thrombocytopenia, coagulation disorder, or receiving anticoagulation '
          'therapy. Rash and injection site reaction were reported in clinical '
          'trials at incidences of 0.9% and 0.3%, respectively. Hypersensitivity '
          'reactions, including anaphylaxis, have been reported.',
      'Infants who received <5 doses of palivizumab during the season may '
          'receive one dose of nirsevimab as soon as possible with no additional '
          'doses of palivizumab. Infants eligible for RSV prophylaxis in season 2 '
          'who received palivizumab in season 1 should receive nirsevimab for season '
          '2. See the latest ACIP and AAP recommendations for other recommendations.',
      'May be given concomitantly with childhood vaccines but with separate '
          'syringes and at different injection sites. Does not interfere with '
          'reverse transcriptase polymerase chain reaction (RT-PCR) or rapid antigen '
          'detection RSV diagnostic assays that target antigenic site I, II, or IV '
          'on the RSV fusion (F) protein.',
      'Administer IM in the anterolateral aspect of the thigh. Inject at '
          'different sites if 2 injections are required but not at the gluteal '
          'region due to the risk for sciatic nerve damage. Medication may be kept '
          'at room temperature for a maximum of 8 hr after removal from the '
          'refrigerator.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1131',
  ),
  // NITROFURANTOIN — PDF p. 323 (printed 1132)
  DrugEntryV3(
    name: 'NITROFURANTOIN',
    brandNames: 'Macrodantin, Macrobid, and generics; previously available as '
        'Furadantin',
    drugClass: 'Antibiotic',
    iconRow: '',
    formulations: [
      'Caps (macrocrystals; Macrodantin and generics): 25, 50, 100 mg',
      'Caps (dual release; Macrobid and generics): 100 mg (25 mg macrocrystal/75 '
          'mg monohydrate)',
      'Oral suspension: 25 mg/5 mL (230 mL), 50 mg/5 mL (60 mL); may contain '
          'parabens, sorbitol, and saccharin',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child (>1 mo; oral suspension or macrocrystals; see remarks):',
        lines: [
          DoseLine('Cystitis treatment: 5–7 mg/kg/24 hr PO ÷ Q6 hr; max. dose: 400 mg/24 hr'),
          DoseLine('UTI prophylaxis: 1–2 mg/kg/dose PO QHS; max. dose: 100 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: '≥12 yr and adult (see remarks):',
        lines: [
          DoseLine(
            'Cystitis treatment:',
            isHeading: true,
          ),
          DoseLine('Macrocrystals or oral suspension: 50–100 mg/dose PO Q6 hr'),
          DoseLine('Dual release (Macrobid): 100 mg/dose PO Q12 hr'),
          DoseLine('UTI prophylaxis (macrocrystals or oral suspension): 50–100 mg/dose PO QHS'),
        ],
      ),
    ],
    remarks: [
      'NOT indicated for the treatment of complex UTI and pyelonephritis due to '
          'inadequate renal tissue and serum concentrations. Contraindicated in '
          'severe renal disease, infants younger than 1 mo of age, glomerular '
          'filtration rate (GFR) below 60 mL/min (reduced drug distribution in the '
          'urine), active/previous cholestatic jaundice/hepatic dysfunction, and '
          'pregnant women at term. Use with caution in G6PD deficiency, anemia, lung '
          'disease, and peripheral neuropathy. May cause nausea, hypersensitivity '
          'reactions (including vasculitis), vomiting, cholestatic jaundice, '
          'headache, hepatotoxicity, polyneuropathy, and hemolytic anemia.',
      'Anticholinergic drugs and high-dose probenecid may increase '
          'nitrofurantoin toxicity. Magnesium salts may decrease nitrofurantoin '
          'absorption. Causes false-positive urine glucose with Clinitest. '
          'Administer doses with food or milk.',
    ],
    pregnancyNote: 'Pregnancy category changes to “X” at term (38–42 weeks’ gestation) '
        'and during labor due to the potential for hemolytic anemia in the '
        'neonate. Breastfeeding by mothers receiving nitrofurantoin is not '
        'recommended for infants younger than 1 mo and those with G6PD '
        'deficiency; use with infants 1 mo or older and without G6PD '
        'deficiency is compatible.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1132',
  ),
  // NITROGLYCERIN — PDF p. 323–325 (printed 1132–1134)
  DrugEntryV3(
    name: 'NITROGLYCERIN',
    brandNames: 'Nitro-Bid, Nitrostat, Nitro-Time, Nitro-Dur, Nitrolingual, Rectiv, '
        'and generics',
    drugClass: 'Vasodilator, antihypertensive',
    iconRow: '',
    formulations: [
      'Injection: 5 mg/mL (10 mL); contains alcohol or propylene glycol',
      'Prediluted injection in D₅W: 100 mCg/mL (250 mL), 200 mCg/mL (250 mL), '
          '400 mCg/mL (250 mL); contains alcohol and propylene glycol',
      'Sublingual tabs (Nitrostat and generics): 0.3, 0.4, 0.6 mg',
      'Sustained-release caps (Nitro-Time): 2.5, 6.5, 9 mg',
      'Ointment, topical (Nitro-Bid): 2% (1, 30, 60 g)',
      'Ointment, rectal (Rectiv and generics): 0.4% (30 g); contains propylene '
          'glycol',
      'Patch (Nitro-Dur and generics): 2.5 mg/24 hr (0.1 mg/hr), 5 mg/24 hr (0.2 '
          'mg/hr), 7.5 mg/24 hr (0.3 mg/hr), 10 mg/24 hr (0.4 mg/hr), 15 mg/24 hr '
          '(0.6 mg/hr), 20 mg/24 hr (0.8 mg/hr) (30s, 100s)',
      'Spray, translingual (Nitrolingual and generics): 0.4 mg per metered spray '
          '(4.9, 12 g; delivers 60 and 200 doses, respectively); contains 20% '
          'alcohol (flammable)',
    ],
    doseSections: [
      DoseSection(
        heading: 'NOTE: The IV dosage units for children are in mCg/kg/min, compared '
            'with mCg/min for adolescents and adults (see remarks).',
      ),
      DoseSection(
        heading: 'Infant/child:',
        lines: [
          DoseLine('Continuous IV infusion: Begin with 0.25–0.5 mCg/kg/min; may increase by '
              '0.5–1 mCg/kg/min Q3–5 min PRN. Usual dose: 1–5 mCg/kg/min; max. dose: 20 '
              'mCg/kg/min'),
          DoseLine('Treatment of sympathomimetic/vasopressor extravasation (alternative to '
              'phentolamine; very limited data): Apply 4 mm/kg of the 2% ointment as a '
              'thin ribbon to the affected areas. If no improvement seen after 8 hr, '
              'apply another dose. Monitor patient’s blood pressure for hypotension.'),
        ],
      ),
      DoseSection(
        heading: 'Adolescent:',
        lines: [
          DoseLine('Continuous IV infusion: 5 mCg/min IV, then increase Q3–5 min PRN by 5 '
              'mCg/min up to 20 mCg/min. If no response, increase by 10–20 mCg/min Q3–5 '
              'min PRN up to a max. of 200 mCg/min.'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Continuous IV infusion: 5 mCg/min IV, then increase Q3–5 min PRN by 5 '
              'mCg/min up to 20 mCg/min. If no response, increase by 10–20 mCg/min Q3–5 '
              'min PRN up to a max. of 200 mCg/min for hypertension and 400 mCg/min for '
              'acute angina.'),
          DoseLine(
            'Acute angina:',
            isHeading: true,
          ),
          DoseLine('Sublingual tabs: 0.3–0.4 mg Q5 min; max. of three doses in 15 min'),
          DoseLine(
            'Angina prophylaxis:',
            isHeading: true,
          ),
          DoseLine('Sustained-release oral caps: 2.5–6.5 mg TID–QID; up to 26 mg QID. Allow '
              'approximately 10–12 hr of a nitrate-free period each day to minimize '
              'tachyphylaxis/tolerance.'),
          DoseLine('Sublingual tabs: 0.3–0.4 mg 5–10 min before activity that might induce an '
              'attack'),
          DoseLine('Translingual spray (0.4 mg/spray): 1–2 sprays 5–10 min before activity '
              'that might induce an attack'),
          DoseLine('Ointment: Apply ½ inch upon rising in the morning and another ½ inch 6 hr '
              'later if needed, double the dose to 1 inch with the same dosing schedule '
              'the next day and subsequently to 2 inches if needed. Max. recommended '
              'dose: 2 doses/24 hr. Provide 10–12 hr/day of nitrate-free period to '
              'minimize tachyphylaxis/tolerance.'),
          DoseLine('Patch: 0.2–0.4 mg/hr initially, then titrate to 0.4–0.8 mg/hr; apply new '
              'patch daily (tachyphylaxis/tolerance is minimized by removing patch for '
              '10–12 hr/24 hr)'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in glaucoma, with increased ICP, cerebral hemorrhage, '
          'traumatic brain injury, shock, severe anemia, concurrent '
          'phosphodiesterase-5 inhibitor (e.g., sildenafil), and concurrent '
          'guanylate cyclase stimulator (e.g., riociguat). In small doses (1–2 '
          'mCg/kg/min), acts mainly on systemic veins and decreases preload. At 3–5 '
          'mCg/kg/min, acts on systemic arterioles to decrease resistance. May cause '
          'headache, flushing, hypersensitivity reactions, hypotension, GI upset, '
          'blurred vision, and methemoglobinemia. Use with caution in severe renal '
          'impairment and hepatic failure. IV nitroglycerin may antagonize '
          'anticoagulant effect of heparin. Tachyphylaxis develops within 24–48 hr '
          'of continuous IV administration; 10–12 hr/day of nitrate-free period has '
          'been recommended to prevent tachyphylaxis in adults.',
      'Decrease dose gradually in patients receiving drug for prolonged periods '
          'to avoid withdrawal reaction. Must use polypropylene infusion sets to '
          'avoid adsorption of drug to plastic tubing. Use in heparinized patients '
          'may result in a decrease of PTT with subsequent rebound effect on '
          'discontinuation of nitroglycerin.',
      'Onset (duration) of action: IV: 1–2 min (3–5 min); sublingual: 1–3 min '
          '(30–60 min); PO sustained release: 40 min (4–8 hr); topical ointment: '
          '20–60 min (2–12 hr); and transdermal patch: 40–60 min (18–24 hr).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1132–1134',
  ),
  // NITROPRUSSIDE — PDF p. 325 (printed 1134)
  DrugEntryV3(
    name: 'NITROPRUSSIDE',
    brandNames: 'Nipride RTU and generics',
    drugClass: 'Vasodilator, antihypertensive',
    iconRow: '',
    formulations: [
      'Injection: 25 mg/mL (2 mL)',
      'Prediluted injection in 0.9% sodium chloride:',
      'Nipride RTU and generics: 0.2 mg/mL (100 mL), 0.5 mg/mL (100 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child, adolescent, and adult (see remarks):',
        lines: [
          DoseLine('IV, continuous infusion'),
          DoseLine('Dose: Start at 0.3–0.5 mCg/kg/min, titrate to effect. Usual dose is 3–4 '
              'mCg/kg/min. Max. dose: 10 mCg/kg/min'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in patients with decreased cerebral perfusion and in '
          'situations of compensatory hypertension (increased ICP). Monitor for '
          'hypotension and acidosis. Dilute with D₅W and protect from light.',
      'Pediatric efficacy is supported by a dose-ranging trial, an open-label '
          'trial, and adult trials. No novel safety issues were found in the '
          'aforementioned pediatric trials.',
      'Nitroprusside is nonenzymatically converted to cyanide, which is '
          'converted to thiocyanate. Cyanide may produce metabolic acidosis and '
          'methemoglobinemia; thiocyanate may produce psychosis and seizures. '
          'Monitor thiocyanate levels if used for more than 48 hr or in a dose ≥4 '
          'mCg/kg/min. Thiocyanate levels should be <50 mg/L. Monitor cyanide levels '
          '(toxic levels >2 mCg/mL) in patients with hepatic dysfunction and '
          'thiocyanate levels in patients with renal dysfunction.',
      'Onset of action is 2 min with a 1–10-min duration of effect.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1134',
  ),
  // NOREPINEPHRINE BITARTRATE — PDF p. 325 (printed 1134)
  DrugEntryV3(
    name: 'NOREPINEPHRINE BITARTRATE',
    brandNames: 'Levophed and generics',
    drugClass: 'Adrenergic agonist',
    iconRow: '',
    formulations: [
      'Injection: 1 mg/mL as norepinephrine base (4 mL); may contain sulfites',
      'Prediluted injection in D₅W or normal saline: 16 mCg/mL (250 mL), 32 '
          'mCg/mL (250 mL), 64 mCg/mL (250 mL); may contain sulfites or preservative '
          'free',
    ],
    doseSections: [
      DoseSection(
        heading: 'NOTE: The dosage units for children are in mCg/kg/min compared with '
            'mCg/min for adults.',
      ),
      DoseSection(
        heading: 'Child:',
        lines: [
          DoseLine('Continuous IV infusion doses as norepinephrine base. Start at 0.05–0.1 '
              'mCg/kg/min. Titrate to effect. Max. dose: 2 mCg/kg/min'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Continuous IV infusion doses as norepinephrine base. Start at 8–12 '
              'mCg/min and titrate to effect. Usual maintenance dosage range: 2–4 mCg/min'),
        ],
      ),
    ],
    remarks: [
      'May cause cardiac arrhythmias, hypertension, hypersensitivity, headaches, '
          'vomiting, uterine contractions, and organ ischemia. May cause decreased '
          'renal blood flow and urine output. Avoid extravasation into tissues; may '
          'cause severe tissue necrosis. If this occurs, treat locally with '
          'phentolamine.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1134',
  ),
  // NORTRIPTYLINE HYDROCHLORIDE — PDF p. 326 (printed 1135)
  DrugEntryV3(
    name: 'NORTRIPTYLINE HYDROCHLORIDE',
    brandNames: 'Pamelor and generics',
    drugClass: 'Antidepressant, tricyclic',
    iconRow: '',
    formulations: [
      'Caps: 10, 25, 50, 75 mg; may contain benzyl alcohol, parabens, or EDTA',
      'Oral solution: 10 mg/5 mL (473 mL); contains up to 4% alcohol, sodium '
          'benzoate, and sorbitol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Depression (see remarks):',
        lines: [
          DoseLine('Adolescent: 1–3 mg/kg/24 hr PO ÷ TID–QID or 30–50 mg/24 hr PO ÷ TID–QID'),
          DoseLine('Adult: 75–100 mg/24 hr PO ÷ TID–QID; alternatively, initiate at 25–50 mg '
              'PO QHS and if needed, increase dosage in 25- to 50-mg increments at '
              'intervals ≥ 7 days.'),
          DoseLine('Max. dose (all ages): 150 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Nocturnal enuresis (see remarks):',
        lines: [
          DoseLine('6–7 yr (20–25 kg): 10 mg PO QHS'),
          DoseLine('8–11 yr (26–35 kg): 10–20 mg PO QHS'),
          DoseLine('>11 yr (36–54 kg): 25–35 mg PO QHS'),
        ],
      ),
    ],
    remarks: [
      'See imipramine for contraindications and common side effects. Also '
          'contraindicated with linezolid or IV methylene blue due to increased risk '
          'for serotonin syndrome. Avoid use in patients with Brugada syndrome. '
          'Fewer CNS and anticholinergic side effects than with amitriptyline. May '
          'cause mild pupillary dilation, which can lead to narrow-angle glaucoma.',
      'Lower doses and slower dose titration are recommended in hepatic '
          'impairment. Therapeutic antidepressant effects occur in 7–21 days. '
          'Monitor for clinical worsening of depression and suicidal '
          'ideation/behavior following the initiation of therapy or after dose '
          'changes. Do not discontinue abruptly. Nortriptyline is a substrate for '
          'the cytochrome P-450 (CYP) 1A2 and 2D6 drug-metabolizing enzymes. Use and '
          'dosing considerations have been recommended based on the following CYP2D6 '
          'phenotypes:',
      'Ultrarapid metabolizer: Use of alternative drug not metabolized by '
          'CYP2D6. If use is warranted, titrate to the highest target dose and '
          'monitor serum levels.',
      'Intermediate metabolizer: Reduce recommended initial dose by 25% and '
          'monitor serum levels.',
      'Poor metabolizer: Avoid use to prevent potential side effect and use '
          'alternative drug not metabolized by CYP2D6. If use is warranted, reduce '
          'recommended initial dose by 50% and monitor serum levels.',
      'Rifampin may increase the metabolism of nortriptyline.',
      'Therapeutic nortriptyline levels for depression: 50–150 ng/mL. '
          'Recommended serum sampling time: Obtain a single level 8 or more hours '
          'after an oral dose (following 4 days of continuous dosing for children '
          'and after 9–10 days for adults).',
      'Administer with food to decrease GI upset.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1135',
  ),
  // NYSTATIN — PDF p. 326–327 (printed 1135–1136)
  DrugEntryV3(
    name: 'NYSTATIN',
    brandNames: 'Klayesta, Nyamyc, Nystop, and generics; previously available as '
        'Mycostatin and Nilstat',
    drugClass: 'Antifungal agent',
    iconRow: '',
    formulations: [
      'Tabs: 500,000 U',
      'Oral suspension: 100,000 U/mL (5, 60, 473 mL)',
      'Topical cream and ointment: 100,000 U/g (15, 30 g)',
      'Topical powder (Klayesta, Nyamyc, Nystop, and generics): 100,000 U/g (15, '
          '30, 60 g)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Oropharyngeal candidiasis:',
        lines: [
          DoseLine('Preterm neonate: 0.5 mL (50,000 U) to each side of mouth QID'),
          DoseLine('Term neonate and infant: 1 mL (100,000 U) to each side of mouth QID'),
          DoseLine('Child, adolescent, and adult: 4–6 mL (400,000–600,000 U) swish and '
              'swallow QID'),
        ],
      ),
      DoseSection(
        heading: 'Nonesophageal mucous membrane GI candidiasis:',
        lines: [
          DoseLine('Adult (oral tabs): 500,000–1,000,000 U PO Q8 hr until 48 hr after '
              'clinical cure'),
        ],
      ),
      DoseSection(
        heading: 'Topical (including diaper dermatitis):',
        lines: [
          DoseLine('All ages (all topical dosage forms): Apply to affected areas BID–QID.'),
        ],
      ),
    ],
    remarks: [
      'May produce diarrhea and GI side effects. Local irritation, contact '
          'dermatitis, and Stevens-Johnson syndrome have been reported. Treat until '
          '48–72 hr after resolution of symptoms. Drug is poorly absorbed through '
          'the GI tract. Oral suspension should be swished about the mouth and '
          'retained in the mouth as long as possible before swallowing.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1135–1136',
  ),
];
