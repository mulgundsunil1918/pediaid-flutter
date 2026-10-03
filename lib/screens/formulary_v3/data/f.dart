// =============================================================================
// output/f.dart — Drug Formulary 3.0, letter F
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyF` per file; entries in book order.
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

const List<DrugEntryV3> formularyF = [
  // FAMCICLOVIR — PDF p. 184–185 (printed 993–994)
  DrugEntryV3(
    name: 'FAMCICLOVIR',
    brandNames: 'Generics; previously available as Famvir',
    drugClass: 'Antiviral',
    iconRow: '',
    formulations: [
      'Tabs: 125, 250, 500 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child ≥45 kg, adolescent, and adult:',
        lines: [
          DoseLine('Herpes zoster: 500 mg PO Q8 hr × 7–10 days; initiate therapy promptly as '
              'soon as diagnosis is made (initiation within 48 hr after rash onset is '
              'ideal; currently no data for starting treatment >72 hr after rash onset)'),
          DoseLine(
            'Genital herpes (first episode):',
            isHeading: true,
          ),
          DoseLine('Immunocompetent: 250 mg PO Q8 hr × 7–10 days'),
          DoseLine('Immunocompromised: 500 mg PO Q12 hr x 5–10 days'),
          DoseLine(
            'Recurrent genital herpes (initiate therapy within 1 day of lesion onset):',
            isHeading: true,
          ),
          DoseLine('Immunocompetent (other regimens may exist): 1000 mg PO Q12 hr × 1 day or '
              '125 mg PO Q12 hr × 5 days'),
          DoseLine('Immunocompromised: 500 mg PO Q12 hr × 5–10 days'),
          DoseLine('Suppression of recurrent genital herpes (immunocompetent): 250 mg PO Q12 '
              'hr up to 1 yr, then reassess for HSV infection recurrence'),
          DoseLine(
            'Recurrent herpes labialis:',
            isHeading: true,
          ),
          DoseLine('Immunocompetent: 1500 mg PO × 1'),
          DoseLine('Immunocompromised: 500 mg PO Q12 hr × 5–10 days'),
        ],
      ),
    ],
    remarks: [
      'Drug is converted to its active form (penciclovir). Hepatic impairment '
          'may impair/reduce the conversion of famciclovir to penciclovir. Better '
          'absorption than PO acyclovir.',
      'May cause headache, diarrhea, nausea, and abdominal pain. Serious skin '
          'reactions (e.g., TEN and Stevens-Johnson), angioedema, hypersensitivity '
          'vasculitis, seizure, palpitations, cholestatic jaundice, and abnormal '
          'LFTs have been reported. Concomitant use with probenecid and other drugs '
          'eliminated by active tubular secretion may result in decreased '
          'penciclovir clearance. Reduce dose in renal impairment (see Chapter 32).',
      'Safety and efficacy in suppression of recurrent genital herpes have not '
          'been established beyond 1 yr. No efficacy data are available for children '
          '1–<12 yr to support its use for genital herpes, recurrent herpes '
          'labialis, and varicella. Furthermore, efficacy has not been established '
          'for recurrent herpes labialis for children 12–<18 yr. May be administered '
          'with or without food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 993–994',
  ),
  // FAMOTIDINE — PDF p. 185–186 (printed 994–995)
  DrugEntryV3(
    name: 'FAMOTIDINE',
    brandNames: 'Pepcid, Pepcid AC [OTC], Pepcid AC Maximum Strength [OTC], Pepcid '
        'Complete [OTC], Zantac 360 [OTC], Zantac 360 Maximum Strength '
        '[OTC], and generics',
    drugClass: 'Histamine-2 receptor antagonist',
    iconRow: '',
    formulations: [
      'Injection: 10 mg/mL (2, 4, 20 mL); multidose vials contain 0.9% benzyl '
          'alcohol',
      'Premixed injection: 20 mg/50 mL in iso-osmotic sodium chloride',
      'Oral suspension: 40 mg/5 mL (50, 100, 150 mL); may contain parabens and '
          'sodium benzoate',
      'Tabs:',
      'Pepcid AC, Zantac 360, and generics (OTC): 10 mg',
      'Pepcid, Pepcid AC Maximum Strength, Zantac 360 Maximum Strength, and '
          'generics (OTC and by prescription): 20 mg',
      'Pepcid and generics: 40 mg',
      'Chewable tabs:',
      'Pepcid Complete (OTC): 10 mg famotidine with 800 mg calcium carbonate and '
          '165 mg magnesium hydroxide (25s, 50s, 100s)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate and <3 mo:',
        lines: [
          DoseLine('IV: 0.25–0.5 mg/kg/dose Q24 hr'),
          DoseLine('PO: 0.5–1 mg/kg/dose Q24 hr'),
        ],
      ),
      DoseSection(
        heading: '≥3 mo–1 yr (GERD):',
        lines: [
          DoseLine('IV (limited to PK data): 0.25 mg/kg/dose Q12 hr'),
          DoseLine('PO: 0.5 mg/kg/dose Q12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Child (1–12 yr):',
        lines: [
          DoseLine('IV: Initial: 0.5–1 mg/kg/24 hr ÷ Q12 hr up to a max. of 40 mg/24 hr'),
          DoseLine('PO: Initial: 1–1.2 mg/kg/24 hr ÷ Q12 hr up to a max. of 40 mg/24 hr'),
          DoseLine('Peptic ulcer: 0.5–1 mg/kg/24 hr PO/IV QHS or ÷ Q12 hr up to a max. dose '
              'of 40 mg/24 hr'),
          DoseLine(
            'GERD:',
            isHeading: true,
          ),
          DoseLine('IV: 0.5–1 mg/kg/24 hr ÷ Q12 hr up to a max. dose of 40 mg/24 hr'),
          DoseLine('PO: 1–2 mg/kg/24 hr ÷ Q12 hr up to a max. dose of 80 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adolescent and adult:',
        lines: [
          DoseLine(
            'Duodenal ulcer:',
            isHeading: true,
          ),
          DoseLine('PO: 20 mg BID or 40 mg QHS × 4–8 wk, then maintenance therapy at 20 mg QHS'),
          DoseLine('IV: 20 mg BID'),
          DoseLine('GERD: 20 mg PO BID × 6 wk'),
          DoseLine('Esophagitis: 20–40 mg PO BID × 12 wk'),
        ],
      ),
    ],
    remarks: [
      'A Q12-hr dosage interval is generally recommended; however, infants and '
          'young children may require a Q8-hr interval because of enhanced drug '
          'clearance. Headaches, dizziness, constipation, diarrhea, and drowsiness '
          'have occurred. Dosage adjustment is required in severe renal failure (see '
          'Chapter 32); prolonged Q–T interval has been reported very rarely in '
          'patients with renal impairment whose dosage had not been adjusted '
          'appropriately. Rhabdomyolysis has been reported.',
      'Shake oral suspension well prior to each use. Oral doses may be '
          'administered with or without food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 994–995',
  ),
  // FELBAMATE — PDF p. 186–187 (printed 995–996)
  DrugEntryV3(
    name: 'FELBAMATE',
    brandNames: 'Felbatol and generics',
    drugClass: 'Anticonvulsant',
    iconRow: '',
    formulations: [
      'Tabs: 400, 600 mg',
      'Oral suspension: 600 mg/5 mL (240, 473 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Lennox-Gastaut for child 2–14 yr (adjunctive therapy):',
        lines: [
          DoseLine('Start at 15 mg/kg/24 hr PO ÷ TID–QID; increase dosage by 15 mg/kg/24 hr '
              'at weekly intervals up to a max. dose of 45 mg/kg/24 hr or 3600 mg/24 hr '
              '(whichever is less). See remarks for adjusting concurrent anticonvulsants.'),
        ],
      ),
      DoseSection(
        heading: 'Partial seizures for child ≥14 yr–adult:',
        lines: [
          DoseLine('Adjunctive therapy: Start at 1200 mg/24 hr PO ÷ TID–QID; increase dosage '
              'by 1200 mg/24 hr at weekly intervals up to a max. dose of 3600 mg/day. '
              'See remarks for adjusting concurrent anticonvulsants.'),
          DoseLine('Monotherapy (as initial therapy): Start at 1200 mg/24 hr PO ÷ TID–QID. '
              'Increase dose under close clinical supervision at 600-mg increments Q2 wk '
              'to 2400 mg/24 hr.'),
          DoseLine('Max. dose: 3600 mg/24 hr.'),
          DoseLine('Conversion to monotherapy: Start at 1200 mg/24 hr ÷ PO TID–QID for 2 wk; '
              'then increase to 2400 mg/24 hr for 1 wk. At wk 3, increase to 3600 mg/24 '
              'hr. Reduce dose of other anticonvulsants by 33% at the initiation of '
              'felbamate, then by an additional 33% of original dose at wk 2, and '
              'continue to reduce other anticonvulsants as clinically indicated at wk 3 '
              'and beyond.'),
        ],
      ),
    ],
    remarks: [
      'Drug should be prescribed under strict supervision by a specialist. '
          'Contraindicated in blood dyscrasias or hepatic dysfunction (prior or '
          'current), and hypersensitivity to meprobamate. Aplastic anemia and '
          'hepatic failure leading to death have been associated with drug. May '
          'cause headache, fatigue, anxiety, GI disturbances, gingival hyperplasia, '
          'increased liver enzymes, and bone marrow suppression. Suicidal behavior '
          'or ideation have been reported. Obtain serum levels of concurrent '
          'anticonvulsants. Monitor liver enzymes, bilirubin, CBC with differential, '
          'and platelets at baseline and every 1–2 wk. Doses should be decreased by '
          '50% in renally impaired patients.',
      'When initiating adjunctive therapy (all ages), reduce doses of other '
          'antiepileptic drugs (AEDs) by 20% to control plasma levels of concurrent '
          'phenytoin, valproic acid, phenobarbital, and carbamazepine. Further '
          'reductions of concomitant AED dosage may be necessary to minimize side '
          'effects caused by drug interactions.',
      'Carbamazepine levels may be decreased; however, phenytoin and valproic '
          'acid levels may be increased. Phenytoin and carbamazepine may increase '
          'felbamate clearance; valproic acid may decrease its clearance.',
      'Doses can be administered with or without food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 995–996',
  ),
  // FENTANYL — PDF p. 187–188 (printed 996–997)
  DrugEntryV3(
    name: 'FENTANYL',
    brandNames: 'Fentora, Actiq, generics; previously available as Sublimaze and '
        'Duragesic',
    drugClass: 'Narcotic; analgesic, sedative',
    iconRow: '',
    formulations: [
      'Injection: 50 mCg/mL (1, 2, 5, 10, 20, 50 mL)',
      'SR transdermal patch: 12.5, 25, 37.5, 50, 62.5, 75, 87.5, 100 mCg/hr (5s)',
      'Tabs for buccal administration:',
      'Fentora and generics: 100, 200, 400, 600, 800 mCg (28s)',
      'Lozenge on a stick:',
      'Actiq and generics: 200, 400, 600, 800, 1200, 1600 mCg (30s)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Titrate dose to effect.',
      ),
      DoseSection(
        heading: 'Neonate and younger infant:',
        lines: [
          DoseLine('Sedation/analgesia: 1–4 mCg/kg/dose (max. dose: 100 mCg/dose) IV Q2–4 hr '
              'PRN'),
          DoseLine('Continuous IV infusion: 1–5 mCg/kg/hr; tolerance may develop'),
        ],
      ),
      DoseSection(
        heading: 'Older infant and child:',
        lines: [
          DoseLine('Sedation/analgesia: 1–2 mCg/kg/dose (max. dose: 100 mCg/dose) IV/IM '
              'Q30–60 min PRN'),
          DoseLine('Continuous IV infusion: 1 mCg/kg/hr; titrate to effect; usual infusion '
              'range 1–3 mCg/kg/hr'),
        ],
      ),
      DoseSection(
        heading: 'To prepare infusion, use the following formula:',
        lines: [
          DoseLine('50 × Desired dose(mCg/kg/hr) / Desired infusion rate(mL/hr) × Wt(kg) = '
              'mCg Fentanyl / 50 mL fluid'),
        ],
      ),
      DoseSection(
        heading: 'Oral, breakthrough cancer pain for opioid-intolerant patients (see '
            'remarks):',
        lines: [
          DoseLine('Buccal tabs (≥18 yr NOT previously using Actiq): Start with 100 mCg by '
              'placing tablet in the buccal cavity (above a rear molar, between the '
              'upper cheek and gum) and letting the tablet dissolve for 15–25 min. A '
              'second 100 mCg dose, if needed, may be administered 30 min after the '
              'start of the first dose. If needed, increase dose initially in multiples '
              'of 100 mCg tablets when patients require >1 dose per breakthrough pain '
              'episode for several consecutive episodes. Must wait at least 4 hr before '
              'treating another episode with buccal tabs. If titration requires >400 '
              'mCg/dose, use 200 mCg tabs.'),
          DoseLine('Lozenges (≥16 yr): Start with 200 mCg by placing lozenge in the mouth, '
              'between the cheek and lower gum. If needed, may repeat dose 15 min after '
              'the completion of the first dose (30 min after start of prior dose). If '
              'therapy requires >1 lozenge per episode, consider increasing the dose to '
              'the next higher strength. Do not give more than 2 doses for each episode '
              'of breakthrough pain and reevaluate long-acting opioid therapy if patient '
              'requires >4 doses/24 hr. Must wait at least 4 hr before treating another '
              'episode with lozenges.'),
        ],
      ),
      DoseSection(
        heading: 'Transdermal (see remarks):',
        lines: [
          DoseLine('Safety has not been established in children <2 yr; should be administered '
              'in children ≥2 yr who are opioid tolerant. Use is contraindicated in '
              'acute or postoperative pain in opiate-naïve patients.'),
          DoseLine('Opioid-tolerant child receiving at least 60 mg morphine equivalents/24 '
              'hr: Use 25 mCg/hr patch Q72 hr. Patch titration should not occur before 3 '
              'days of administration of the initial dose or more frequently than every '
              '6 days thereafter.'),
        ],
      ),
      DoseSection(
        heading: 'See Chapter 6 for equianalgesic dosing and PCA dosing',
      ),
      DoseSection(
        heading: 'Intranasal route for acute and preprocedure analgesia (use IV dosage '
            'form; see remarks):',
        lines: [
          DoseLine('≥1 yr–adolescent: 1–2 mCg/kg/dose intranasally via an automizer (max. '
              'dose: 100 mCg/dose) Q1 hr PRN'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in bradycardia, respiratory depression, and increased '
          'intracranial pressure. Adjust dose in renal failure (see Chapter 32). '
          'Fatalities and life-threatening respiratory depression have been reported '
          'with inappropriate use (overdoses, use in opioid-naïve patients, changing '
          'the patch too frequently, and exposing the patch to a heat source) of the '
          'transdermal route.',
      'Highly lipophilic and may deposit into fat tissue. IV onset of action 1–2 '
          'min, with peak effects in 10 min. IV duration of action 30–60 min. Give '
          'IV dose over 3–5 min. Rapid infusion may cause respiratory depression and '
          'chest wall rigidity. Respiratory depression may persist beyond the period '
          'of analgesia. Transdermal onset of action 6–8 hr with a 72-hr duration of '
          'action. See Chapter 6 for pharmacodynamic information with transmucosal '
          'and transdermal routes.',
      'Buccal tabs and oral lozenges are indicated only for the management of '
          'breakthrough cancer pain in patients who are already receiving and who '
          'are tolerant to opioid therapy. Buccal tabs (Fentora), transdermal '
          'patches (previously available as Duragesic), and lozenge (Actiq) dosage '
          'forms are available through a restricted distribution program (REMS) and '
          'are NOT bioequivalent (see package insert for conversion).',
      'Intranasal route of administration for analgesia has an onset of action '
          'at 10–30 min. Pediatric studies have demonstrated that the intranasal '
          'fentanyl is equivalent to and better than morphine (PO/IV/IM) and '
          'equivalent to IV fentanyl for providing analgesia.',
      'Fentanyl is a substrate for the cytochrome P-450 3A4 enzyme. Be aware of '
          'medications that inhibit or induce this enzyme, for they may increase or '
          'decrease the effects of fentanyl, respectively.',
    ],
    pregnancyNote: 'Pregnancy category changes to “D” if drug is used for prolonged '
        'periods or in high doses at term.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 996–997',
  ),
  // FERRIC GLUCONATE — PDF p. 188 (printed 997)  [cross-reference]
  DrugEntryV3(
    name: 'FERRIC GLUCONATE',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Iron―Injectable Preparations',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 997',
  ),
  // FERROUS SULFATE — PDF p. 188 (printed 997)  [cross-reference]
  DrugEntryV3(
    name: 'FERROUS SULFATE',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Iron―Oral Preparations',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 997',
  ),
  // FEXOFENADINE ± PSEUDOEPHEDRINE — PDF p. 189 (printed 998)
  DrugEntryV3(
    name: 'FEXOFENADINE ± PSEUDOEPHEDRINE',
    brandNames: 'Allegra [OTC], Children\'s Allegra Allergy [OTC], and generics\nIn '
        'combination with pseudoephedrine: Allegra D-12 Hour [OTC], Allegra '
        'D-24 Hour [OTC] and generics',
    drugClass: 'Antihistamine, less-sedating ± decongestant',
    iconRow: '',
    formulations: [
      'Tabs [OTC]: 60, 180 mg',
      'Tabs, orally disintegrating (Children’s Allegra Allergy; ODT) [OTC]: 30 '
          'mg; contains phenylalanine',
      'Oral suspension [OTC]: 6 mg/mL (120, 240 mL); contains parabens',
      'Extended-release tab in combination with pseudoephedrine (PE):',
      'Allegra-D 12 Hour and generics [OTC]: 60 mg fexofenadine + 120 mg '
          'pseudoephedrine',
      'Allegra-D 24 Hour and generics [OTC]: 180 mg fexofenadine + 240 mg '
          'pseudoephedrine',
    ],
    doseSections: [
      DoseSection(
        heading: 'Fexofenadine:',
        lines: [
          DoseLine('6 mo–<2 yr: 15–30 mg PO BID'),
          DoseLine('2–11 yr: 30 mg PO BID'),
          DoseLine('≥12 yr–adult: 60 mg PO BID; 180 mg PO once daily may be used in seasonal '
              'rhinitis'),
        ],
      ),
      DoseSection(
        heading: 'Extended-release tabs of fexofenadine and pseudoephedrine:',
        lines: [
          DoseLine(
            '≥12 yr–adult:',
            isHeading: true,
          ),
          DoseLine('Allegra-D 12 Hour and generics: 1 tablet (fexofenadine 60 mg + '
              'pseudoephedrine 120 mg) PO BID'),
          DoseLine('Allegra-D 24 Hour and generics: 1 tablet (fexofenadine 180 mg + '
              'pseudoephedrine 240 mg) PO once daily'),
        ],
      ),
    ],
    remarks: [
      'May cause drowsiness, fatigue, headache, dyspepsia, nausea, and '
          'dysmenorrhea. Has not been implicated in causing cardiac arrhythmias when '
          'used with other drugs that are metabolized by hepatic microsomal enzymes '
          '(e.g., ketoconazole, erythromycin). Reduce dose to 15 mg PO once daily '
          'for child 6 mo–<2 yr, 30 mg PO once daily for child 6–11 yr, and 60 mg PO '
          'once daily for ≥12 yr for any degree of renal impairment. For use of '
          'Allegra-D 12 Hour and decreased renal function (CrCl <80 mL/min), an '
          'initial dose of 1 tablet PO once daily is recommended. Avoid use of '
          'Allegra-D 24 Hour in renal impairment. See Pseudoephedrine for additional '
          'remarks if using the combination product.',
      'Medication as the single agent may be administered with or without food. '
          'Do not administer antacids with or within 2 hr of fexofenadine dose. The '
          'extended-release combination product should be swallowed whole without '
          'food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 998',
  ),
  // FIDAXOMICIN — PDF p. 189–190 (printed 998–999)
  DrugEntryV3(
    name: 'FIDAXOMICIN',
    brandNames: 'Dificid',
    drugClass: 'Antibiotic, macrolide',
    iconRow: '',
    formulations: [
      'Oral suspension: 40 mg/mL (136 mL); contains sodium benzoate',
      'Tabs: 200 mg; contains soybean lecithin',
    ],
    doseSections: [
      DoseSection(
        heading: 'C. difficile treatment (PO):',
        lines: [
          DoseLine('Child ≥6 mo: 16 mg/kg/dose (max. dose: 200 mg/dose) BID × 10 days; or '
              'alternative fixed dosage by weight:'),
          DoseLine('4–<7 kg: 80 mg BID'),
          DoseLine('7–<9 kg: 120 mg BID'),
          DoseLine('9–<12.5 kg: 160 mg BID'),
          DoseLine('≥12.5 kg: 200 mg BID'),
          DoseLine('Adult: 200 mg BID × 10 days'),
        ],
      ),
    ],
    remarks: [
      'Minimally absorbable macrolide antibiotic with bactericidal activity '
          'against C. difficile; inhibits RNA polymerase sigma subunit resulting in '
          'inhibition of protein synthesis and cell death. Fidaxomicin use in '
          'children <18 yr is currently indicated as a second-line agent following '
          'recurrent courses of oral vancomycin, whereas it is the recommended '
          'first-line initial episode therapy for adults.',
      'Acute hypersensitivity reactions such as angioedema, dyspnea, pruritus, '
          'and rash have been reported, and individuals with a history of macrolide '
          'allergies may be at risk. Common side effects include abdominal pain, '
          'nausea, vomiting, anemia, and neutropenia. Bowel obstruction and GI '
          'hemorrhage have been reported.',
      'Fidaxomicin and its main metabolite (OP-118) are substrates of the P-gp '
          'efflux transporter in the GI tract. Use with cyclosporine, a P-gp '
          'inhibitor, may increase systemic levels of fidaxomicin and OP-118 without '
          'affecting the safety and efficacy for treating C. difficile in adult '
          'clinical trials.',
      'Doses may be administered with or without food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 998–999',
  ),
  // FILGRASTIM — PDF p. 190–191 (printed 999–1000)
  DrugEntryV3(
    name: 'FILGRASTIM',
    brandNames: 'Neupogen, and G-CSF; biosimilar brands include: Granix, Nivestym, '
        'Nypozi, Releuko, Zarxio',
    drugClass: 'Colony-stimulating factor',
    iconRow: '',
    formulations: [
      'Injection (Neupogen): 300 mCg/mL (1, 1.6 mL vials)',
      'Injection, prefilled syringes with 27-gauge ½-inch needles (Neupogen: 600 '
          'mCg/mL (300 mCg per 0.5 mL and 480 mCg per 0.8 mL) (10s)',
      'All dosage forms contain polysorbate 80 and are preservative free.',
      'NOTE: The following biosimilar products are available (all contain '
          'polysorbate 80 and are preservative free).',
      'Single-dose vials [Nivestym (filgrastim-aafi), Granix (tbo-filgrastim), '
          'Releuko (filgrastim-ayow)]: 300 mCg/1 mL and 480 mCg/1.6 mL (10s)',
      'Prefilled syringes [Nivestym (filgrastim-aafi), Granix (tbo-filgrastim), '
          'Nypozi (filgrasatim-txid), Zarxio (filgrastim-sndz), Releuko '
          '(filgrastim-ayow)]: 300 mCg/0.5 mL and 480 mCg/0.8 mL (1 or 10s); may be '
          'attached with a 27- or 29-gauge ½-inch needle (product dependent)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Individual protocols may direct dosing.',
      ),
      DoseSection(
        heading: 'Myelosuppressive chemotherapy recipients with nonmyeloid malignancies:',
        lines: [
          DoseLine('IV/SC: 5 mCg/kg/dose once daily × 14 days or until ANC >10,000/mm³. '
              'Dosage may be increased by 5 mCg/kg/24 hr if desired effect is not '
              'achieved within 7 days.'),
          DoseLine('Discontinue therapy when ANC >10,000/mm³.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated for patients sensitive to E. coli–derived proteins. Avoid '
          'simultaneous administration with chemotherapy and radiation and do not '
          'administer 24 hr before or after administration of chemotherapy. May '
          'cause bone pain, fever, and rash. Monitor CBC, uric acid, and LFTs. '
          'Aortitis, sickle cell crisis, serious allergic reactions, '
          'glomerulonephritis, and thrombocytopenia have been reported. Decreased '
          'bone density/osteoporosis has been reported in pediatric patients with '
          'severe chronic neutropenia. Use with caution in patients with '
          'malignancies with myeloid characteristics. Myelodysplastic syndrome and '
          'acute myeloid leukemia have been associated with the use of filgrastim in '
          'conjunction with chemotherapy and/or radiotherapy in patients with breast '
          'and lung cancer.',
      'Safety and effectiveness have been established for nonmyeloid '
          'malignancies receiving myelosuppressive chemotherapy in children ≥1 '
          'mo–<17 yr old. The safety profile was similar to adults.',
      'SC routes of administration are preferred because of prolonged serum '
          'levels over IV route. If used via IV route and G-CSF final concentration '
          '<15 mCg/mL, add 2 mg albumin/1 mL of IV fluid to prevent drug adsorption '
          'to the IV administration set.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 999–1000',
  ),
  // FLUCONAZOLE — PDF p. 191–192 (printed 1000–1001)
  DrugEntryV3(
    name: 'FLUCONAZOLE',
    brandNames: 'Diflucan and generics',
    drugClass: 'Antifungal agent',
    iconRow: '',
    formulations: [
      'Tabs: 50, 100, 150, 200 mg',
      'Injection: 2 mg/mL (50, 100, 200 mL); contains 9 mEq Na/2 mg drug',
      'Oral suspension: 10 mg/mL (35 mL), 40 mg/mL (35 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate (IV/PO):',
        lines: [
          DoseLine('Loading dose: 12–25 mg/kg'),
          DoseLine('Thrush: 6 mg/kg'),
          DoseLine('Maintenance dose: 6–12 mg/kg with the following dosing intervals (see '
              'following table); use higher doses for severe infections of Candida '
              'strains with MICs >4–8 mCg/mL'),
          DoseLine('Thrush: 3–6 mg/kg/dose with the following dosing intervals (see following '
              'table) for at least 2 wk'),
        ],
        table: DoseTable(
          headers: ['Postconceptional Age (wk)', 'Postnatal Age (days)', 'Dosing Interval (hr) and Time (hr) to Start First Maintenance Dose After '
                'Load'],
          rows: [
            DoseTableRow(['26–29', '0–14', '72']),
            DoseTableRow(['', '>14', '24']),
            DoseTableRow(['≥30', 'All', '24']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Child ≥1 mo (IV/PO):',
        table: DoseTable(
          headers: ['Indication', 'Maintenance Dosage Q24 hr', 'Maximum Dose'],
          rows: [
            DoseTableRow(['Oropharyngeal candidiasis', '6–12 mg/kg', '400 mg/dose']),
            DoseTableRow(['Esophageal candidiasis', '6–12 mg/kg', '600 mg/dose']),
            DoseTableRow(['Invasive systemic candidiasis (e.g., endocarditis) and cryptococcal '
                'meningitis', '12 mg/kg', '800 mg/dose']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Oropharyngeal candidiasis: Loading dose of 200 mg PO/IV, followed by '
              '100–200 mg Q24 hr (24 hr after load) for 7–14 days; doses up to 400 mg/24 '
              'hr have been used'),
          DoseLine('Esophageal candidiasis: Loading dose of 400 mg PO/IV, followed by 200–400 '
              'mg Q24 hr (24 hr after load); doses up to 800 mg/24 hr have been used'),
          DoseLine('Systemic candidiasis: Loading dose of 800 mg PO/IV, followed by 400–800 '
              'mg Q24 hr (24 hr after load)'),
          DoseLine('Bone marrow transplant prophylaxis: 400 mg PO/IV Q24 hr'),
          DoseLine('Suppressive therapy in for HIV infected with cryptococcal meningitis: '
              '200–400 mg PO/IV Q24 hr'),
          DoseLine('Vaginal candidiasis: 150 mg PO × 1'),
          DoseLine('Severe infection in immunocompromised: 150 mg PO Q72 hr × 2–3 doses'),
        ],
      ),
    ],
    remarks: [
      'Use with other medications known to prolong the Q–T interval and that are '
          'metabolized via the cytochrome P-450 (CYP) 3A4 enzyme (e.g., '
          'erythromycin) is considered contraindicated. May cause nausea, headache, '
          'rash, vomiting, abdominal pain, hepatitis, cholestasis, and diarrhea. '
          'Neutropenia, agranulocytosis, thrombocytopenia, exfoliative skin '
          'disorders (e.g., SJS, TEN, DRESS), and adrenal insufficiency (reversible) '
          'have been reported. Use with caution in hepatic or renal dysfunction and '
          'in patients with hypokalemia, proarrhythmic conditions, or advanced '
          'cardiac failure. Higher incidence of intestinal perforation has been '
          'reported with infants weighing <750 g at birth in a phase 3 prophylaxis '
          'clinical trial when compared to a placebo.',
      'Inhibits CYP2C9/2C10 and CYP3A3/3A4 (weak inhibitor). May increase '
          'effects, toxicity, or levels of cyclosporine, ivacaftor, midazolam, '
          'phenytoin, rifabutin, tacrolimus, theophylline, warfarin, oral '
          'hypoglycemics, AZT, and medicines containing ivacaftor. Rifampin '
          'increases fluconazole metabolism. May increase the risk of myopathy and '
          'rhabomyolysis when coadministered with HMG-CoA reductase inhibitors '
          '(statins); statin dosage reduction may be needed.',
      'Consider using higher doses in morbidly obese patients. Adjust dose in '
          'renal failure (see Chapter 32).',
    ],
    pregnancyNote: 'Pregnancy category is “C” for single 150-mg use for vaginal '
        'candidiasis, but a Danish study reports a higher risk for '
        'miscarriages during weeks 7–22 of gestation. Pregnancy category '
        '“D” is for all other indications (high-dose use during first '
        'trimester of pregnancy may result in birth defects).',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1000–1001',
  ),
  // FLUCYTOSINE — PDF p. 192–193 (printed 1001–1002)
  DrugEntryV3(
    name: 'FLUCYTOSINE',
    brandNames: 'Ancobon, 5-FC, 5-Fluorocytosine, and generics',
    drugClass: 'Antifungal agent',
    iconRow: '',
    formulations: [
      'Caps: 250, 500 mg',
      'Oral suspension: 10, 50 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate (initial dose; monitor serum concentrations):',
        lines: [
          DoseLine(
            '<1 kg:',
            isHeading: true,
          ),
          DoseLine('≤14 days old: 75 mg/kg/24 hr PO ÷ Q8 hr'),
          DoseLine('15–60 days old: 100 mg/kg/24 hr PO ÷ Q6 hr'),
          DoseLine(
            '1–2 kg:',
            isHeading: true,
          ),
          DoseLine('≤7 days old: 75 mg/kg/24 hr PO ÷ Q8 hr'),
          DoseLine('8–60 days old: 100 mg/kg/24 hr PO ÷ Q6 hr'),
          DoseLine('>2 kg and ≤60 days old: 100 mg/kg/24 hr PO ÷ Q6 hr'),
          DoseLine('Dosages of 75–100 mg/kg/24 hr have been used in neonates (preterm and '
              'term) for candidal meningitis.'),
        ],
      ),
      DoseSection(
        heading: 'Child and adult (initial dose; monitor serum concentrations):',
        lines: [
          DoseLine('50–150 mg/kg/24 hr PO ÷ Q6 hr'),
        ],
      ),
    ],
    remarks: [
      'Monitor CBC, BUN, serum creatinine, alkaline phosphatase, AST, and ALT. '
          'Common side effects: Nausea, vomiting, diarrhea, rash, CNS disturbance, '
          'anemia, leukopenia, and thrombocytopenia. Use with caution in hepatic and '
          'renal impairment and in hematologic disorders. Use is contraindicated in '
          'the first trimester of pregnancy.',
      'Therapeutic levels: 25–100 mg/L. Recommended serum sampling time at '
          'steady state: Obtain peak level 2–4 hr after oral dose following 4 days '
          'of continuous dosing. Peak levels of 40–60 mg/L have been recommended for '
          'systemic candidiasis. Maintain trough levels above 25 mg/L. Prolonged '
          'levels above 100 mg/L can increase risk for bone marrow suppression. Bone '
          'marrow suppression in immunosuppressed patients can be irreversible and '
          'fatal.',
      'Flucytosine interferes with creatinine assay tests using the dry-slide '
          'enzymatic method (Kodak Ektachem analyzer). Adjust dose in renal failure '
          '(see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1001–1002',
  ),
  // FLUDROCORTISONE ACETATE — PDF p. 193 (printed 1002)
  DrugEntryV3(
    name: 'FLUDROCORTISONE ACETATE',
    brandNames: 'Generics; 9-fluorohydrocortisone; previously available as Florinef',
    drugClass: 'Corticosteroid',
    iconRow: '',
    formulations: [
      'Tabs: 0.1 mg',
      'Oral suspension: 0.1 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infant and child:',
        lines: [
          DoseLine('0.05–0.1 mg/24 hr PO once daily'),
          DoseLine('Congenital adrenal hyperplasia: 0.05–0.3 mg/24 hr PO once daily'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('0.05–0.2 mg/24 hr PO once daily'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in CHF and systemic fungal infections. Has primarily '
          'mineralocorticoid activity. Use with caution in hypertension, edema, or '
          'renal dysfunction. May cause hypertension, hypokalemia, acne, rash, '
          'bruising, headaches, GI ulcers, and growth suppression.',
      'Monitor BP and serum electrolytes. See Chapter 10 for steroid potency '
          'comparison.',
      'Drug interactions: Drug’s hypokalemic effects may induce digoxin '
          'toxicity; phenytoin and rifampin may increase fludrocortisone metabolism.',
      'Doses 0.2–2 mg/24 hr have been used in the management of severe '
          'orthostatic hypotension in adults. Use a gradual dosage taper when '
          'discontinuing therapy.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1002',
  ),
  // FLUMAZENIL — PDF p. 193–194 (printed 1002–1003)
  DrugEntryV3(
    name: 'FLUMAZENIL',
    brandNames: 'Generics; previously available as Romazicon',
    drugClass: 'Benzodiazepine antidote',
    iconRow: '',
    formulations: [
      'Injection: 0.1 mg/mL (5, 10 mL); contains parabens',
    ],
    doseSections: [
      DoseSection(
        heading: 'Benzodiazepine overdose (IV, see remarks):',
        lines: [
          DoseLine('Child and adolescent (limited data): 0.01 mg/kg (max. dose: 0.2 mg) IV '
              'over 15 seconds Q1 min PRN up to a max. total cumulative dose of 1 mg. As '
              'an alternative for repeat bolus doses, a continuous infusion of '
              '0.005–0.01 mg/kg/hr has been used.'),
          DoseLine('Adult: Initial dose: 0.2 mg over 30 sec; if needed, give 0.3 mg 30 sec '
              'later over 30 sec. Additional doses of 0.5 mg given over 30 sec Q1 min '
              'PRN up to a cumulative dose of 3 mg (usual cumulative dose: 1–3 mg). '
              'Patients with only partial response to 3 mg may require additional slow '
              'titration to a total of 5 mg. Patients who have not responded 5 min after '
              'receiving a cumulative dose of 5 mg should be reassessed for other causes '
              'of sedation from non-benzodiazepines.'),
        ],
      ),
      DoseSection(
        heading: 'Reversal of benzodiazepine sedation (IV):',
        lines: [
          DoseLine('Child and adolescent: Initial dose: 0.01 mg/kg (max dose: 0.2 mg) given '
              'over 15 sec; if needed after 45 sec, 0.01 mg/kg (max. dose: 0.2 mg) Q1 '
              'min to a max. total cumulative dose of 0.05 mg/kg or 1 mg, whichever is '
              'lower. Usual total dose: 0.08–1 mg (average 0.65 mg).'),
          DoseLine('Adult: Initial dose: 0.2 mg over 15 sec; if needed after 45 sec, give 0.2 '
              'mg Q1 min to a max. total cumulative dose of 1 mg. Doses may be repeated '
              'at 20-min interval (max. dose of 1 mg per 20-min interval) up to a max. '
              'dose of 3 mg in 1 hr.'),
        ],
      ),
    ],
    remarks: [
      'Does not reverse narcotics. Onset of benzodiazepine reversal occurs in '
          '1–3 min. Reversal effects of flumazenil (T₁/₂ approximately 1 hr) may '
          'wear off sooner than benzodiazepine effects. If patient does not respond '
          'after cumulative 1–3 mg dose, suspect agent other than benzodiazepines.',
      'May precipitate seizures, especially in patients taking benzodiazepines '
          'for seizure control or in patients with tricyclic antidepressant '
          'overdose. Fear and panic attacks in patients with history of panic '
          'disorders have been reported.',
      'Use with caution in liver dysfunction; flumazenil’s clearance is '
          'significantly reduced. Use normal dose for initial dose and decrease the '
          'dosage and frequency for subsequent doses.',
      'See Chapter 3 for complete management of suspected ingestions',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1002–1003',
  ),
  // FLUNISOLIDE — PDF p. 194 (printed 1003)
  DrugEntryV3(
    name: 'FLUNISOLIDE',
    brandNames: 'Generics; previously available as Nasarel or Nasalide',
    drugClass: 'Corticosteroid',
    iconRow: '',
    formulations: [
      'Nasal solution: 25 mCg/spray (200 sprays/bottle) (25 mL); contains '
          'propylene glycol and benzalkonium chloride',
    ],
    doseSections: [
      DoseSection(
        heading: 'After symptoms are controlled, reduce to lowest effective maintenance '
            'dose (e.g., 1 spray each nostril once daily) to control symptoms',
      ),
      DoseSection(
        heading: 'Nasal solution:',
        lines: [
          DoseLine(
            'Child (6–14 yr):',
            isHeading: true,
          ),
          DoseLine('Initial: 1 spray (25 mCg) per nostril TID or 2 sprays (50 mCg) per '
              'nostril BID; max. dose: 4 sprays (100 mCg) per nostril/24 hr or 200 '
              'mCg/24 hr in total'),
          DoseLine(
            '≥15 yr and adult:',
            isHeading: true,
          ),
          DoseLine('Initial: 2 sprays (50 mCg) per nostril BID; if needed in 4–7 days, '
              'increase to 2 sprays (50 mCg) per nostril TID; max. dose: 8 sprays (200 '
              'mCg) per nostril/24 hr or 400 mCg/24 hr in total'),
        ],
      ),
    ],
    remarks: [
      'Nasal burning and stinging is common. Nasal congestion, sneezing, '
          'epistaxis, watery eyes, sore throat, nausea/vomiting, and headaches may '
          'also occur. May cause a reduction in growth velocity. Nasal septal '
          'perforations have been reported. Flunisolide is a minor substrate of '
          'cytochrome P-450 3A4.',
      'Shake nasal solution well before use and clear nasal passages before use. '
          'Priming of the nasal spray is recommended when using a new bottle or if '
          'the bottle has not been used for ≥5 days.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1003',
  ),
  // FLUORIDE — PDF p. 194–195 (printed 1003–1004)
  DrugEntryV3(
    name: 'FLUORIDE',
    brandNames: 'Fluoritab, many others, and generics',
    drugClass: 'Mineral',
    iconRow: '',
    formulations: [
      'Concentrations and strengths based on fluoride ion:',
      'Oral drops/solution:',
      'Generics: 0.125 mg/drop (30 mL)',
      'Chewable tabs:',
      'Fluoritab and generics: 0.5, 1 mg',
      'Generics: 0.25, 0.5 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'All doses/24 hr (see table below):',
        lines: [
          DoseLine(
            'Recommendations from American Academy of Pediatrics and American Dental '
                'Association for Prevention of Dental Caries',
            isHeading: true,
          ),
        ],
        table: DoseTable(
          headers: ['Age', 'Concentration of Fluoride in Drinking Water (ppm)', '', ''],
          rows: [
            DoseTableRow(['', '<0.3', '0.3–0.6', '>0.6']),
            DoseTableRow(['Birth–6 mo', '0', '0', '0']),
            DoseTableRow(['6 mo–3 yr', '0.25 mg', '0', '0']),
            DoseTableRow(['3–6 yr', '0.5 mg', '0.25 mg', '0']),
            DoseTableRow(['6–16 yr', '1 mg', '0.5 mg', '0']),
          ],
        ),
      ),
    ],
    remarks: [
      'Contraindicated in areas where drinking water fluoridation is >0.7 ppm. '
          'Acute overdose: GI distress, salivation, CNS irritability, tetany, '
          'seizures, hypocalcemia, hypoglycemia, and cardiorespiratory failure. '
          'Chronic excess use may result in mottled teeth or bone changes.',
      'Take with food, but not milk, to minimize GI upset. The doses have been '
          'decreased owing to concerns over dental fluorosis.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1003–1004',
  ),
  // FLUOXETINE HYDROCHLORIDE — PDF p. 195–196 (printed 1004–1005)
  DrugEntryV3(
    name: 'FLUOXETINE HYDROCHLORIDE',
    brandNames: 'Prozac and generics',
    drugClass: 'Antidepressant, selective serotonin reuptake inhibitor',
    iconRow: '',
    formulations: [
      'Oral solution: 20 mg/5 mL (120 mL); may contain alcohol',
      'Caps: 10, 20, 40 mg',
      'Delayed-release caps: 90 mg',
      'Tabs: 10, 20, 60 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'All dosages are with immediate release dosage forms.',
      ),
      DoseSection(
        heading: 'Depression:',
        lines: [
          DoseLine('Child, 8–<12 yr: Start at 5 or 10 mg PO once daily. Usual dose: 10 mg '
              'once daily. May increase dose every 1–2 weeks as needed up to a max. dose '
              'of 40 mg/24 hr (some patients may require higher doses).'),
          DoseLine('Adolescent ≥12 yr: Start at 10 or 20 mg PO once daily. May increase '
              'increase by 10–20 mg increments every 1–2 weeks as needed up to a max. '
              'dose of 60 mg/24 hr. Usual effective dose: 20–40 mg once daily.'),
          DoseLine('Adult: Start at 20 mg PO once daily in the morning. May increase after '
              'several weeks by 20 mg/24 hr increments to max. dose of 80 mg/24 hr. '
              'Doses >20 mg/24 hr should be divided BID.'),
        ],
      ),
      DoseSection(
        heading: 'Obsessive-compulsive disorder:',
        lines: [
          DoseLine(
            'Child, 7–18 yr:',
            isHeading: true,
          ),
          DoseLine('Lower-weight child: Start at 5 or 10 mg PO once daily. May increase after '
              'several weeks. Usual dose range: 20–30 mg/24 hr. There is very minimal '
              'experience with doses >20 mg/24 hr and no experience with doses >60 mg/24 '
              'hr.'),
          DoseLine('Higher-weight child and adolescent: Start at 10 mg PO once daily and '
              'increase dose to 20 mg/24 hr after 2 wk. May further increase dose after '
              'several weeks. Usual dose range: 20–60 mg/24 hr; higher dose of 80 mg/24 '
              'hr has been reported.'),
        ],
      ),
      DoseSection(
        heading: 'Bulimia:',
        lines: [
          DoseLine('Adolescent (PO; limited data): 20 mg QAM × 3 days, then 40 mg QAM × 3 '
              'days, then 60 mg QAM'),
          DoseLine('Adult: 60 mg PO QAM; it is recommended to titrate up to this dose over '
              'weekly intervals starting at 20 mg QAM'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in patients taking MAO inhibitors (e.g., linezolid) due '
          'to possibility of seizures, hyperpyrexia, and coma. Use with caution in '
          'patients with angle-closure glaucoma, receiving diuretics, or with liver '
          '(reduce dose with cirrhosis) or renal impairment. May increase the '
          'effects of tricyclic antidepressants. May cause headache, insomnia, '
          'nervousness, drowsiness, GI disturbance, sexual dysfunction, and weight '
          'loss. Increased bleeding diathesis with unaltered prothrombin time may '
          'occur with warfarin. Hyponatremia has been reported. Monitor for clinical '
          'worsening of depression and suicidal ideation/behavior following the '
          'initiation of therapy or after dose changes.',
      'May displace other highly protein-bound drugs. Inhibits cytochrome P-450 '
          '2C19, 2D6, and 3A3/3A4 drug metabolism isoenzymes, which may increase the '
          'effects or toxicity of drugs metabolized by these enzymes. For example, '
          'use with pimozide or thioridazine may increase the risk for prolonged '
          'cardiac Q–Tc interval and is considered contraindicated. Use with '
          'serotonergic drugs (e.g., triptans, methylene blue) and drugs that impair '
          'serotonin metabolism (MAOIs) may increase the risk for serotonin '
          'syndrome. Carefully review the patient’s medication profile for potential '
          'interactions.',
      'Delayed-release capsule is currently indicated for depression and is '
          'dosed at 90 mg Q7 days. It is unknown if weekly dosing provides the same '
          'protection from relapse as does daily dosing.',
      'Breastfeeding is not recommended by the manufacturer, as adverse events '
          'to nursing infants have been reported. Fluoxetine and metabolite are '
          'variable and are higher when compared with other SSRIs. Maternal use of '
          'SSRIs during pregnancy and postpartum may result in more difficult '
          'breastfeeding. Infants exposed to SSRIs during pregnancy may also have an '
          'increased risk for persistent pulmonary hypertension of the newborn.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1004–1005',
  ),
  // FLUTICASONE FUROATE + VILANTEROL — PDF p. 196–197 (printed 1005–1006)
  DrugEntryV3(
    name: 'FLUTICASONE FUROATE + VILANTEROL',
    brandNames: 'Breo Ellipta and generics',
    drugClass: 'Corticosteroid and long-acting β₂-adrenergic agonist',
    iconRow: '',
    formulations: [
      'Breath-activated aerosol powder for inhalation; contains lactose and milk '
          'proteins:',
      'Breo Ellipta:',
      '50 mCg fluticasone furoate + 25 mCg vilanterol per actuation (30 doses)',
      'Breo Ellipta and generics:',
      '100 mCg fluticasone furoate + 25 mCg vilanterol per actuation (14, 30 '
          'doses)',
      '200 mCg fluticasone furoate + 25 mCg vilanterol per actuation (14, 30 '
          'doses)',
      'For fluticasone furoate (Arnuity Ellipta) as a single agent, see '
          'Fluticasone Preparations',
    ],
    doseSections: [
      DoseSection(
        heading: 'Asthma (see remarks):',
        lines: [
          DoseLine('Child 5–12 yr: One inhalation of 50 mCg fluticasone furoate + 25 mCg '
              'vilanterol once daily'),
          DoseLine('Child 12 yr–adolescent: One inhalation of 100 mCg fluticasone furoate + '
              '25 mCg vilanterol once daily'),
          DoseLine('Adult: One inhalation of 100 mCg fluticasone furoate + 25 mCg vilanterol '
              'OR 200 mCg fluticasone furoate + 25 mCg vilanterol once daily; initial '
              'dosage selection based on asthma severity, previous therapy, and risk of '
              'future exacerbation.'),
          DoseLine('Max. dose: One inhalation/24 hr for each dosage strength (25 mCg '
              'vilanterol/24 hr)'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated with hypersensitivity to milk proteins. See Fluticasone '
          'Preparations for remarks. Vilanterol is a long-acting β₂-adrenergic '
          'agonist with a faster onset and longer duration of action compared to '
          'salmeterol.',
      'Hypersensitivity reactions, hyperglycemia, muscle spasms, and tremor have '
          'been reported.',
      'Titrate to the lowest effective strength after asthma is adequately '
          'controlled. This dosage form’s breath-activated device requires a minimum '
          'inspiratory flow rate of 60 L/min for proper dose activation. Proper '
          'patient education, including dosage administration technique, is '
          'essential; see patient package insert for detailed instructions. Rinse '
          'mouth after each use.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1005–1006',
  ),
  // FLUTICASONE PREPARATIONS — PDF p. 197–199 (printed 1006–1008)
  DrugEntryV3(
    name: 'FLUTICASONE PREPARATIONS',
    brandNames: 'Fluticasone propionate: Flonase and generics; previously available '
        'as Flovent Diskus, Flovent HFA, and Cutivate\nFluticasone furoate: '
        'Flonase Sensimist and Arnuity Ellipta',
    drugClass: 'Corticosteroid',
    iconRow: '',
    formulations: [
      'FLUTICASONE PROPIONATE:',
      'Nasal spray:',
      'Flonase and generics [OTC]: 50 mCg/actuation (9.9 mL = 60 doses, 11.1 mL '
          '= 72 doses, 18.2 mL = 144 doses); contains benzalkonium chloride and '
          'polysorbate 80',
      'Xhance: 93 mCg/actuation (16 mL = 120 doses); currently approved for '
          'adults as a prescription',
      'Topical cream: 0.05% (15, 30, 60 g)',
      'Topical ointment: 0.005% (15, 30, 60 g)',
      'Topical lotion (previously available as Cutivate): 0.05% (60 mL); '
          'contains parabens and propylene glycol',
      'Aerosol inhaler (MDI) (generics; previously available as Flovent HFA): 44 '
          'mCg/actuation (10.6 g), 110 mCg/actuation (12 g), 220 mCg/actuation (12 '
          'g); each inhaler provides 120 metered inhalations.',
      'Dry-powder inhalation (DPI) (generics; previously available as Flovent '
          'Diskus): 50 mCg/dose, 100 mCg/dose, 250 mCg/dose; all strengths come in '
          'foil strip to provide 60 doses per package. Contains lactose (milk '
          'proteins).',
      'FLUTICASONE FUROATE:',
      'Nasal spray (Flonase Sensimist [OTC]): 27.5 mCg/actuation (5.9 mL = 60 '
          'doses, 9.1 mL = 120 doses); contains benzalkonium chloride and '
          'polysorbate 80',
      'Breath-activated aerosol powder inhaler (Arnuity Ellipta): 50 '
          'mCg/actuation, (30 doses), 100 mCg/actuation (14, 30 doses), 200 '
          'mCg/actuation dose (14, 30 doses); contains lactose (milk proteins)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Allergic rhinitis (intranasal):',
        lines: [
          DoseLine(
            'Fluticasone propionate (Flonase and generics):',
            isHeading: true,
          ),
          DoseLine('≥4–11 yr: 1 spray (50 mCg) per nostril once daily. Higher doses of 2 '
              'sprays (100 mCg) per nostril once daily may be needed for nonallergic '
              'rhinitis (≥4 yr and adolescent).'),
          DoseLine('≥12 yr and adult: Initial 200 mCg/24 hr [2 sprays (100 mCg) per nostril '
              'once daily, OR 1 spray (50 mCg) per nostril BID]. Reduce to 1 spray per '
              'nostril once daily when symptoms are controlled.'),
          DoseLine('Max. dose (4 yr–adult): 2 sprays (100 mCg) per nostril/24 hr'),
          DoseLine(
            'Fluticasone furoate (Veramyst):',
            isHeading: true,
          ),
          DoseLine('2–11 yr: 1 spray (27.5 mCg) per nostril once daily. If needed, dose may '
              'be increased to 2 sprays each nostril once daily. Reduce to 1 spray per '
              'nostril once daily when symptoms are controlled.'),
          DoseLine('≥12 yr and adult: 2 sprays (55 mCg) each nostril once daily. Reduce to 1 '
              'spray per nostril once daily when symptoms are controlled.'),
          DoseLine('Max. dose (2 yr–adult): 2 sprays (55 mCg) per nostril/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Asthma maintenance therapy (oral inhalation; see remarks):',
        lines: [
          DoseLine('Fluticasone propionate (previously available as Flovent HFA and Diskus): '
              'divide all 24-hr doses BID. If desired response is not seen after 2 wk of '
              'starting therapy, increase dosage, then reduce to the lowest effective '
              'dose when asthma symptoms are controlled. Administration of MDI (HFA) '
              'with aerochamber enhances drug delivery.'),
        ],
      ),
      DoseSection(
        heading: 'Recommended Dosages for Asthma',
        table: DoseTable(
          headers: ['Age', 'Previous Use of Bronchodilators Only (Max. Dose):', 'Previous Use of Inhaled Corticosteroid (Max. Dose):', 'Previous Use of Oral Corticosteroid (Max. Dose):'],
          rows: [
            DoseTableRow(['Child (4–11 yr)', 'MDI: 88 mCg/24 hr (176 mCg/24 hr)\nDPI: 100 mCg/24 hr (200 mCg/24 hr)', 'MDI: 88 mCg/24 hr (176 mCg/24 hr)\nDPI: 100 mCg/24 hr (200 mCg/24 hr)', 'Dose not available']),
            DoseTableRow(['≥12 yr and adult', 'MDI: 176 mCg/24hr (880 mCg/24hr)\nDPI: 200 mCg/24 hr (2000 mCg/24 hr)', 'MDI: 176–440 mCg/24 hr (880 mCg/24 hr)\nDPI: 200–500 mCg/24 hr (2000 '
                'mCg/24 hr)', 'MDI: 880 mCg/24 hr (1760 mCg/24 hr)\nDPI: 1000–2000 mCg/24 hr (2000 '
                'mCg/24 hr)']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('DPI, Dry-powder inhaler (breath-activated); MDI, metered-dose inhaler.'),
          DoseLine(
            'Fluticasone furoate (Arnuity Ellipta; breath-activated aerosol powder '
                'inhaler; see remarks):',
            isHeading: true,
          ),
          DoseLine('5–11 yr: Inhale 50 mCg once daily.'),
          DoseLine('≥12 yr and adult: Inhale 100–200 mCg once daily; max. dose: 200 mCg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Eosinophilic esophagitis (limited data and other regimens exist; use '
            'oral fluticasone propionate HFA dosage form without spacer for PO '
            'administration as doses are swallowed):',
        lines: [
          DoseLine(
            'Induction (short-term):',
            isHeading: true,
          ),
          DoseLine('Child (1–10 yr): 220 mCg QID × 4 wk, then 220 mCg TID × 3 wk, then 220 '
              'mCg BID × 3 wk, and 220 mCg once daily × 2 wk'),
          DoseLine('Child ≥11 yr and adolescent: 440 mCg QID × 4 wk, then 440 mCg TID × 3 wk, '
              'then 440 mCg BID × 3 wk, and 440 mCg once daily × 2 wk'),
          DoseLine(
            'Maintenance (long-term):',
            isHeading: true,
          ),
          DoseLine('Child 2–4 yr: 88 mCg BID'),
          DoseLine('Child 5–10 yr: 220 mCg BID'),
          DoseLine('Child ≥11 yr and adolescent: 440 mCg BID'),
        ],
      ),
      DoseSection(
        heading: 'Atopic dermatitis (topical fluticasone propionate; reassess diagnosis '
            'if no improvement in 2 wk):',
        lines: [
          DoseLine(
            'Cream (see Chapter 8 for topical steroid comparisons):',
            isHeading: true,
          ),
          DoseLine('≥3 mo and adult: Apply thin film to affected areas once daily–BID, then '
              'reduce to a less potent topical agent when symptoms are controlled. '
              'Safety and efficacy have not been evaluated longer than 4 wk.'),
          DoseLine(
            'Lotion (see remarks):',
            isHeading: true,
          ),
          DoseLine('≥3 mo and adult: Apply thin film to affected areas once daily. Safety and '
              'efficacy have not been evaluated longer than 4 wk.'),
          DoseLine(
            'Ointment:',
            isHeading: true,
          ),
          DoseLine('Adult: Apply thin film to affected areas BID.'),
        ],
      ),
    ],
    remarks: [
      'Fluticasone propionate and fluticasone furoate do not have equivalent '
          'potencies; follow specific dosing regimens for the respective products.',
      'For mild asthma exacerbation in patients with mild/moderate disease, no '
          'history of life-threatening exacerbations, and a good asthma '
          'self-management plan, limited data in adolescents (>16 yr) and adults '
          'suggest a temporary quadrupling of the maintenance dosage when asthma '
          'control starts to deteriorate. Revert back to baseline maintenance dose '
          'after symptoms stabilize or up to a maximum of 14 days of the quadrupled '
          'dose, whichever comes first. DO NOT use this management strategy for '
          'children <12 years of age due to the lack of efficacy and increased risk '
          'for decreasing linear growth.',
      'Concurrent administration with ritonavir and other cytochrome P-450 3A4 '
          'inhibitors may increase fluticasone levels, resulting in Cushing syndrome '
          'and adrenal suppression. Use with caution and monitor closely in hepatic '
          'impairment.',
      'Intranasal: Clear nasal passages prior to use. May cause epistaxis and '
          'nasal irritation, which are usually transient. Taste and smell '
          'alterations, rare hypersensitivity reactions (angioedema, pruritis, '
          'urticaria, wheezing, dyspnea), and nasal septal perforation have been '
          'reported in post-marketing studies.',
      'Oral inhalation: DO NOT USE a spacer or volume holding chamber with '
          'breath-activated dosage forms. Specific breath-activated dosage forms '
          'require the following minimum inspiratory flow rates for proper dose '
          'activation:',
      'Arnuity Ellipta: 60 L/min',
      'ArmonAir Digihaler: 30 L/min',
      'Rinse mouth after each use. May cause dysphonia, oral thrush, and '
          'dermatitis. Esophageal candidiasis and hypersensitivity reactions have '
          'been reported with oral and nasal inhalation routes. Compared to '
          'beclomethasone, has been shown to have less of an effect on suppressing '
          'linear growth in asthmatic children. Eosinophilic conditions may occur '
          'with the withdrawal or decrease of oral corticosteroids after the '
          'initiation of inhaled fluticasone. Breath-activated dosage forms are '
          'contraindicated for patients who have milk protein allergies.',
      'TOPICAL USE: Irritation, folliculitis, acneiform eruptions, '
          'hypopigmentation, perioral dermatitis, allergic contact dermatitis, '
          'secondary infection, skin atrophy, striae, hypertrichosis, miliaria, '
          'cataracts, and glaucoma have been reported. Avoid contact of topical '
          'dosage forms with the eyes.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1006–1008',
  ),
  // FLUTICASONE PROPIONATE AND SALMETEROL — PDF p. 199–201 (printed 1008–1010)
  DrugEntryV3(
    name: 'FLUTICASONE PROPIONATE AND SALMETEROL',
    brandNames: 'Advair Diskus, Advair HFA, AirDuo RespiClick, and generics',
    drugClass: 'Corticosteroid and long-acting β₂-adrenergic agonist',
    iconRow: '',
    formulations: [
      'Aerosol inhaler (MDI) (Advair HFA and generics):',
      '45 mCg fluticasone propionate + 21 mCg salmeterol per inhalation (8 g '
          'delivers 60 doses, 12 g delivers 120 doses)',
      '115 mCg fluticasone propionate + 21 mCg salmeterol per inhalation (8 g '
          'delivers 60 doses, 12 g delivers 120 doses)',
      '230 mCg fluticasone propionate + 21 mCg salmeterol per inhalation (8 g '
          'delivers 60 doses, 12 g delivers 120 doses)',
      'Breath-activated DPI (Advair Diskus and generics; contains lactose and '
          'milk proteins):',
      '100 mCg fluticasone propionate + 50 mCg salmeterol per inhalation (14, 60 '
          'doses)',
      '250 mCg fluticasone propionate + 50 mCg salmeterol per inhalation (14, 60 '
          'doses)',
      '500 mCg fluticasone propionate + 50 mCg salmeterol per inhalation (14, 60 '
          'doses)',
      'Breath-activated aerosol powder inhaler (AirDuo RespiClick and generics; '
          'contains lactose):',
      '55 mCg fluticasone propionate + 14 mCg salmeterol per inhalation (0.45 g '
          'delivers 60 doses)',
      '113 mCg fluticasone propionate + 14 mCg salmeterol per inhalation (0.45 g '
          'delivers 60 doses)',
      '232 mCg fluticasone propionate + 14 mCg salmeterol per inhalation (0.45 g '
          'delivers 60 doses)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Asthma:',
        lines: [
          DoseLine(
            'Without prior inhaled steroid use:',
            isHeading: true,
          ),
          DoseLine(
            'Breath-activated (DPI; Advair Diskus; see remarks):',
            isHeading: true,
          ),
          DoseLine('4–11 yr: Start with one inhalation BID of 100 mCg fluticasone propionate '
              '+ 50 mCg salmeterol.'),
          DoseLine('≥12 yr and adult: Start with one inhalation BID of 100 mCg fluticasone '
              'propionate + 50 mCg salmeterol OR 250 mCg fluticasone propionate + 50 mCg '
              'salmeterol; max. dose: one inhalation BID of 500 mCg fluticasone '
              'propionate + 50 mCg salmeterol'),
          DoseLine(
            'Aerosol inhaler (MDI; Advair HFA):',
            isHeading: true,
          ),
          DoseLine('≥12 yr and adult: Start with 2 inhalations BID of 45 mCg fluticasone + 21 '
              'mCg salmeterol OR 115 mCg fluticasone + 21 mCg salmeterol; max. dose: 2 '
              'inhalations BID of 230 mCg fluticasone + 21 mCg salmeterol'),
          DoseLine(
            'Breath-activated aerosol powder inhaler (AirDuo Digihaler, AirDuo '
                'RespiClick; see remarks):',
            isHeading: true,
          ),
          DoseLine('≥12 yr and adult: Start with 1 inhalation BID of 55 mCg fluticasone + 14 '
              'mCg salmeterol; max. dose: one inhalation BID of 232 mCg fluticasone '
              'propionate + 14 mCg salmeterol'),
          DoseLine(
            'With prior inhaled steroid use (see following table and below):',
            isHeading: true,
          ),
        ],
      ),
      DoseSection(
        heading: 'Conversion From Other Inhaled Steroids',
        table: DoseTable(
          headers: ['Inhaled Corticosteroid', 'Current Daily Dose', 'Recommended Strength of Fluticasone Propionate + Salmeterol Diskus (DPI) '
                '(Advair Diskus) Administered at One Inhalation BID', 'Recommended Strength of Fluticasone Propionate + Salmeterol Aerosol '
                'Inhaler (MDI) (Advair HFA) Administered at Two Inhalations BID'],
          rows: [
            DoseTableRow(['Beclomethasone dipropionate (Qvar Redihaler)', '160 mCg', '100 mCg + 50 mCg', '45 mCg + 21 mCg']),
            DoseTableRow(['', '320 mCg', '250 mCg + 50 mCg', '115 mCg + 21 mCg']),
            DoseTableRow(['', '640 mCg', '500 mCg + 50 mCg', '230 mCg + 21 mCg']),
            DoseTableRow(['Budesonide', '≤400 mCg', '100 mCg + 50 mCg', '45 mCg + 21 mCg']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        table: DoseTable(
          headers: ['Inhaled Corticosteroid', 'Current Daily Dose', 'Recommended Strength of Fluticasone Propionate + Salmeterol Diskus (DPI) '
                '(Advair Diskus) Administered at One Inhalation BID', 'Recommended Strength of Fluticasone Propionate + Salmeterol Aerosol '
                'Inhaler (MDI) (Advair HFA) Administered at Two Inhalations BID'],
          rows: [
            DoseTableRow(['', '800–1200 mCg', '250 mCg + 50 mCg', '115 mCg + 21 mCg']),
            DoseTableRow(['', '1600 mCg', '500 mCg + 50 mCg', '230 mCg + 21 mCg']),
            DoseTableRow(['Fluticasone propionate aerosol (HFA)', '≤176 mCg', '100 mCg + 50 mCg', '45 mCg + 21 mCg']),
            DoseTableRow(['', '440 mCg', '250 mCg + 50 mCg', '115 mCg + 21 mCg']),
            DoseTableRow(['', '660–880 mCg', '500 mCg + 50 mCg', '230 mCg + 21 mCg']),
            DoseTableRow(['Fluticasone propionate DPI', '≤200 mCg', '100 mCg + 50 mCg', '45 mCg + 21 mCg']),
            DoseTableRow(['', '500 mCg', '250 mCg + 50 mCg', '115 mCg + 21 mCg']),
            DoseTableRow(['', '1000 mCg', '500 mCg + 50 mCg', '230 mCg + 21 mCg']),
            DoseTableRow(['Mometasone furoate', '220 mCg', '100 mCg + 50 mCg', '45 mCg + 21 mCg']),
            DoseTableRow(['', '440 mCg', '250 mCg + 50 mCg', '115 mCg + 21 mCg']),
            DoseTableRow(['', '880 mCg', '500 mCg + 50 mCg', '230 mCg + 21 mCg']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('DPI, Dry-powder inhaler (breath-activated); MDI, metered-dose inhaler.'),
          DoseLine('Breath-activated aerosol powder inhaler (AirDuo RespiClick): Select low '
              '(55 mCg fluticasone + 14 mCg salmeterol), medium (113 mCg fluticasone + '
              '14 mCg salmeterol), or high (232 mCg fluticasone + 14 mCg salmeterol) '
              'dose strength based on the previous inhaled corticosteroid product or the '
              'strength of the inhaled corticosteroid from a combination product and '
              'disease severity. All dosage strengths are administered as one inhalation '
              'BID.'),
          DoseLine(
            'Max. doses:',
            isHeading: true,
          ),
          DoseLine('Breath-activated (DPI; Advair Diskus): One inhalation BID of 500 mCg '
              'fluticasone propionate + 50 mCg salmeterol'),
          DoseLine('Aerosol inhaler (MDI; Advair HFA): Two inhalations BID of 230 mCg '
              'fluticasone propionate + 21 mCg salmeterol'),
          DoseLine('Breath-activated aerosol powder inhaler (AirDuo RespiClick): One '
              'inhalation BID of 232 mCg fluticasone propionate + 14 mCg salmeterol'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated with hypersensitivity to milk proteins. See Fluticasone '
          'Preparations and Salmeterol for remarks. Titrate to the lowest effective '
          'strength after asthma is adequately controlled.',
      'DO NOT USE a spacer or volume holding chamber with breath-activated '
          'dosage forms. Specific breath-activated dosage forms require the '
          'following minimum inspiratory flow rates for proper dose activation:',
      'Advair Diskus: 60 L/min',
      'AirDuo RespiClick: 30 L/min',
      'Proper patient education, including dosage administration technique, is '
          'essential; see patient package insert for detailed instructions for '
          'specific dosage form. Rinse mouth after each use.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1008–1010',
  ),
  // FLUVOXAMINE — PDF p. 202 (printed 1011)
  DrugEntryV3(
    name: 'FLUVOXAMINE',
    brandNames: 'Generics; previously available as Luvox and Luvox CR',
    drugClass: 'Antidepressant, selective serotonin reuptake inhibitor',
    iconRow: '',
    formulations: [
      'Tabs: 25, 50, 100 mg',
      'Extended-release capsules: 100, 150 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Obsessive-compulsive disorder (use immediate-release tablets unless '
            'noted otherwise, see remarks):',
        lines: [
          DoseLine('Child 8–12 yr: Start at 12.5–25 mg PO QHS. Dose may be increased by 25 '
              'mg/24 hr Q7–14 days (slower titration at Q2–4 wk may be used for '
              'minimizing behavioral side effects). Total daily doses >50 mg/24 hr '
              'should be divided BID. Female patients may require lower dosages compared '
              'to males.'),
          DoseLine('Max. dose: Child: 8–11 yr: 200 mg/24 hr; and child 12 yr: 300 mg/24 hr'),
          DoseLine('Adolescent: Start at 25–50 mg PO QHS. Dose may be increased by 25 mg/24 '
              'hr Q7–14 days (slower titration at Q2–4 wk may be used for minimizing '
              'behavioral side effects). Total daily doses >50 mg/24 hr should be '
              'divided BID with the larger dose at bedtime. Max. dose: 300 mg/24 hr'),
          DoseLine('Adult: Start at 50 mg PO QHS. Dose may be increased by 50 mg/24 hr Q4–7 '
              'days up to a max. dose of 300 mg/24 hr. Total daily doses >100 mg/24 hr '
              'should be divided BID with larger dose at bedtime.'),
          DoseLine('Extended-release capsule (adult): Start at 100 mg PO QHS. Dose may be '
              'increased by 50 mg/24 hr Q7 days up to a max. dose of 300 mg/24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated with coadministration of cisapride, pimozide, '
          'thioridazine, tizanidine, or MAO inhibitors. Use with caution in hepatic '
          'disease (dosage reduction may be necessary as drug is extensively '
          'metabolized by the liver) and in combination with serotonergic drugs '
          '(e.g., TCAs, triptans, fentanyl, lithium, tramadol, amphetamines, '
          'tryptophan, and St. John’s wort). Monitor for clinical worsening of '
          'depression and suicidal ideation/behavior following the initiation of '
          'therapy or after dose changes.',
      'Major substrate for cytochrome P-450 (CYP) 1A2 and 2D6. Poor metabolizers '
          'of CYP2D6 should consider an initial dose reduction of 25%–50% and '
          'titrate to response or use an alternative medication not metabolized by '
          'this enzyme.',
      'Inhibits CYP1A2, 2C19, 2C9, 2D6, and 3A3/3A4, which may increase the '
          'effects or toxicity of drugs metabolized by these enzymes. Dose-related '
          'use of thioridazine with fluvoxamine may cause prolongation of Q–T '
          'interval and serious arrhythmias. May increase warfarin plasma levels by '
          '98% and prolong PT. May increase toxicity and/or levels of theophylline, '
          'caffeine, and tricyclic antidepressants. Side effects include headache, '
          'insomnia, somnolence, nausea, diarrhea, dyspepsia, dry mouth, and sexual '
          'dysfunction.',
      'Titrate to lowest effective dose. Use a gradual taper when discontinuing '
          'therapy to prevent withdrawal symptoms.',
      'Consider the benefits vs. potential risk for maternal use in '
          'breastfeeding. Maternal use during pregnancy and postpartum may result in '
          'breastfeeding difficulties.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1011',
  ),
  // FOLIC ACID — PDF p. 202–203 (printed 1011–1012)
  DrugEntryV3(
    name: 'FOLIC ACID',
    brandNames: 'FA-8 and many generics; previously available as Folvite',
    drugClass: 'Water-soluble vitamin',
    iconRow: '',
    formulations: [
      'Tabs [OTC]: 0.4, 0.8, 1 mg',
      'Caps:',
      'FA-8: 0.8 mg [OTC]',
      'Generics: 5 mg, 20 mg',
      'Oral solution: 0.05 mg/mL, 1 mg/mL',
      'Injection: 5 mg/mL (10 mL); contains 1.5% benzyl alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'For U.S. RDA, see Chapter 21',
      ),
      DoseSection(
        heading: 'Folic acid deficiency (PO, IM, IV, SC):',
        lines: [
          DoseLine('Infant: 0.1 mg/24 hr once daily'),
          DoseLine('Child <4 yr: 0.1–0.3 mg/24 hr once daily'),
          DoseLine('Child ≥4 yr and adolescent: 0.1–0.4 mg/24 hr once daily'),
          DoseLine('Adult: 0.4 mg/24 hr once daily'),
          DoseLine('Pregnant and lactating women: 0.8 mg/24 hr once daily'),
        ],
      ),
    ],
    remarks: [
      'Normal levels: See Chapter 29. May mask hematologic effects of vitamin '
          'B₁₂ deficiency but will not prevent progression of neurologic '
          'abnormalities. High-dose folic acid may decrease the absorption of '
          'phenytoin.',
      'Women of childbearing age considering pregnancy should take at least 0.4 '
          'mg once daily before and during pregnancy to reduce risk of neural tube '
          'defects in the fetus. Pregnancy category changes to “C” if used in doses '
          'above the RDA.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1011–1012',
  ),
  // FOMEPIZOLE — PDF p. 203–204 (printed 1012–1013)
  DrugEntryV3(
    name: 'FOMEPIZOLE',
    brandNames: 'Generics; previously available as Antizol',
    drugClass: 'Antidote for ethylene glycol or methanol toxicity',
    iconRow: '',
    formulations: [
      'Injection: 1 g/mL (1.5 mL); preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child and adult NOT requiring hemodialysis (IV, all doses '
            'administered over 30 min):',
        lines: [
          DoseLine('Load: 15 mg/kg/dose × 1'),
          DoseLine('Maintenance: 10 mg/kg/dose Q12 hr × 4 doses, then 15 mg/kg/dose Q12 hr '
              'until ethylene glycol or methanol level decreases to <20 mg/dL and the '
              'patient is asymptomatic with normal pH'),
        ],
      ),
      DoseSection(
        heading: 'Child and adult requiring hemodialysis (IV following the recommended '
            'doses at the intervals indicated here. Fomepizole is removed by '
            'dialysis. All doses administered IV over 30 min):',
        lines: [
          DoseLine(
            'Dosing at the beginning of hemodialysis:',
            isHeading: true,
          ),
          DoseLine('If <6 hr since last fomepizole dose: DO NOT administer dose'),
          DoseLine('If ≥6 hr since last fomepizole dose: Administer next scheduled dose upon '
              'beginning dialysis'),
          DoseLine('Dosing during hemodialysis: Administer Q4 hr or, alternatively, 10–20 '
              'mg/kg loading dose, followed by a continuous infusion of 1–1.5 mg/kg/hr'),
          DoseLine(
            'Dosing at the time hemodialysis is completed (based on the time between '
                'last dose and end of hemodialysis):',
            isHeading: true,
          ),
          DoseLine('<1 hr: DO NOT administer dose at end of hemodialysis'),
          DoseLine('1–3 hr: Administer ½ of next scheduled dose at the end of hemodialysis'),
          DoseLine('>3 hr: Administer next scheduled dose at the end of hemodialysis'),
          DoseLine('Maintenance dose off hemodialysis: Give next scheduled dose 12 hr from '
              'last dose administered'),
        ],
      ),
    ],
    remarks: [
      'Works by competitively inhibiting alcohol dehydrogenase. Safety and '
          'efficacy in pediatrics have not been established. Contraindicated in '
          'hypersensitivity to any components or other pyrazole compounds. Most '
          'frequent side effects include headache, nausea, and dizziness. Fomepizole '
          'is extensively eliminated by the kidneys (use with caution in renal '
          'failure) and removed by hemodialysis.',
      'Drug product may solidify at temperatures <25°C (77°F); vial can be '
          'liquefied by holding it under running warm water (efficacy, safety, and '
          'stability are not affected). All doses must be diluted with at least 100 '
          'mL of D5W or NS to prevent vein irritation. DO NOT use polycarbonate '
          'syringe or polycarbonate-containing needles when diluting or '
          'administering this medication.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1012–1013',
  ),
  // FOSCARNET — PDF p. 204–205 (printed 1013–1014)
  DrugEntryV3(
    name: 'FOSCARNET',
    brandNames: 'Foscavir and generics',
    drugClass: 'Antiviral agent',
    iconRow: '',
    formulations: [
      'Injection: 24 mg/mL (250 mL); preservative free',
      'Contains 10 mEq Na/g drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'HIV positive or exposed with the following infection:',
        lines: [
          DoseLine(
            'CMV disease (IV):',
            isHeading: true,
          ),
          DoseLine(
            'Infant, child, and adolescent:',
            isHeading: true,
          ),
          DoseLine('Induction: 180 mg/kg/24 hr ÷ Q8–12 hr in combination with ganciclovir; '
              'continue until symptom improvement and convert to maintenance therapy'),
          DoseLine('Maintenance: 90–120 mg/kg/dose Q24 hr'),
          DoseLine(
            'CMV retinitis (disseminated disease; IV):',
            isHeading: true,
          ),
          DoseLine(
            'Infant and child:',
            isHeading: true,
          ),
          DoseLine('Induction: 180 mg/kg/24 hr ÷ Q8–12 hr × 14–21 days with or without '
              'ganciclovir'),
          DoseLine('Maintenance: 90–120 mg/kg/24 hr once daily'),
          DoseLine(
            'Adolescent and adult:',
            isHeading: true,
          ),
          DoseLine('Induction: 180 mg/kg/24 hr ÷ Q8–12 hr × 14–21 days'),
          DoseLine('Maintenance: 90–120 mg/kg/24 hr once daily'),
        ],
      ),
      DoseSection(
        heading: 'Acyclovir-resistant herpes simplex (limited data; IV):',
        lines: [
          DoseLine('Infant and child: 40 mg/kg/dose Q8 hr or 60 mg/kg/dose Q12 hr for up to 3 '
              'wk or until lesions heal'),
          DoseLine('Adolescent and adult: 40 mg/kg/dose Q8–12 hr × 14–21 days or until '
              'lesions heal'),
        ],
      ),
      DoseSection(
        heading: 'Varicella zoster unresponsive to acyclovir (IV):',
        lines: [
          DoseLine('Infant and child: 40–60 mg/kg/dose Q8 hr × 7–10 days'),
          DoseLine('Adolescent: 90 mg/kg/dose Q12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Varicella zoster, progressive outer retinal necrosis (IV):',
        lines: [
          DoseLine('Infant, child, and adolescent: 90 mg/kg/dose Q12 hr in combination with '
              'ganciclovir IV and intravitreal foscarnet with or without ganciclovir'),
        ],
      ),
      DoseSection(
        heading: 'Intravitreal route for progressive outer retinal necrosis (HIV '
            'positive or exposed):',
        lines: [
          DoseLine('Child and adolescent: 1.2 mg/0.05 mL per dose 2 times weekly in '
              'combination with IV foscarnet and ganciclovir and/or intravitreal '
              'ganciclovir'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in patients with renal insufficiency and hypernatremia '
          '(large sodium content). Discontinue use in adults if serum Cr ≥2.9 mg/dL. '
          'Adjust dose in renal failure (see Chapter 32).',
      'May cause peripheral neuropathy, seizures, neutropenia, esophageal '
          'ulceration, hallucinations, GI disturbance, increased LFTs, hypertension, '
          'chest pain, ECG abnormalities (Q–T interval prolongation has been '
          'reported), coughing, dyspnea, bronchospasm, and renal failure (adequate '
          'hydration and avoiding nephrotoxic medications may reduce risk). '
          'Hypocalcemia (increased risk if given with pentamidine), hypokalemia, and '
          'hypomagnesemia may also occur. Hypersensitivity reactions have been '
          'reported. Use with ciprofloxacin may increase risk for seizures.',
      'Correction of dehydration and adequate hydration reduces the risk for '
          'nephrotoxicity. 10–20 mL/kg IV (max. dose: 1000 mL) of NS or D₅W should '
          'be administered prior to the first dose and concurrently with subsequent '
          'doses. For lower foscarnet dosage regimens of 40–60 mg/kg, use 50% of the '
          'aforementioned hydration recommendations. Actual hydration may need to be '
          'reduced when clinically indicated. Oral hydration methods may also be '
          'considered in patients who are able to tolerate.',
      'For peripheral line IV administration, the concentration must be diluted '
          'to 12 mg/mL in NS or D₅W.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1013–1014',
  ),
  // FOSPHENYTOIN — PDF p. 205–206 (printed 1014–1015)
  DrugEntryV3(
    name: 'FOSPHENYTOIN',
    brandNames: 'Cerebyx and generics',
    drugClass: 'Anticonvulsant',
    iconRow: '',
    formulations: [
      'Injection: 50 mg phenytoin equivalent (75 mg fosphenytoin)/1 mL (2, 10 '
          'mL); contains tromethamine',
      '1 mg phenytoin equivalent provides 0.0037 mmol phosphate',
    ],
    doseSections: [
      DoseSection(
        heading: 'All doses are expressed as phenytoin sodium equivalents (PE) (see '
            'remarks for dose administration information):',
        lines: [
          DoseLine('Neonate, child, and adolescent: See Phenytoin and use the conversion of 1 '
              'mg phenytoin = 1 mg PE'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine(
            'Loading dose:',
            isHeading: true,
          ),
          DoseLine('Status epilepticus: 20 mg PE/kg IV (max. dose: 1500 mg PE/dose)'),
          DoseLine('Nonemergent loading: 10–20 mg PE/kg IV/IM'),
          DoseLine('Nonemergent initial maintenance dose (initiated 12 hr after loading '
              'dose): 4–7 mg PE/kg/24 hr IV/IM ÷ Q6–12 hr'),
        ],
      ),
    ],
    remarks: [
      'All doses should be prescribed and dispensed in terms of mg phenytoin '
          'sodium equivalents (PE) to avoid medication errors. Safety in pediatrics '
          'has not been fully established.',
      'Contraindicated in patients with history of phenytoin or other hydantoin '
          'hypersensitivity. Use with caution in patients with renal or hepatic '
          'impairment and porphyria (consider amount of phosphate delivered by '
          'fosphenytoin in patients with phosphate restrictions). Drug is also '
          'metabolized to liberate small amounts of formaldehyde, which is '
          'considered clinically insignificant with short-term use (e.g., 1 wk). '
          'Side effects: Hypokalemia (with rapid IV administration), slurred speech, '
          'dizziness, ataxia, rash, exfoliative dermatitis (e.g., TEN, SJS; '
          'increased risk with patients with HLA-B*1502 allele), nystagmus, '
          'diplopia, and tinnitus. Angioedema, macrocytosis, megaloblastic anema, '
          'and pure red cell aplasia have been reported. Increased unbound phenytoin '
          'concentrations may occur in patients with renal disease or '
          'hypoalbuminemia; measure “free” or “unbound” phenytoin levels in these '
          'patients. Patients with reduced cytochrome P-450 (CYP) 2C9 activity '
          '(CYP2C*3) have decreased clearance of phenytoin, resulting in increased '
          'phenytoin levels.',
      'Abrupt withdrawal may cause status epilepticus. BP and ECG monitoring '
          'should be present during IV loading dose administration. Max. IV infusion '
          'rate: 2 mg PE/kg/min up to a max. of 150 mg PE/min. Administer IM via 1 '
          'or 2 injection sites; IM route is not recommended in status epilepticus.',
      'Therapeutic levels: 10–20 mg/L (free and bound phenytoin) OR 1–2 mg/L '
          '(free only). Recommended peak serum sampling times: 4 hr following an IM '
          'dose or 2 hr following an IV dose.',
      'See Phenytoin remarks for drug interactions and additional side effects. '
          'Drug is more safely administered via peripheral IV than phenytoin.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1014–1015',
  ),
  // FUROSEMIDE — PDF p. 206–207 (printed 1015–1016)
  DrugEntryV3(
    name: 'FUROSEMIDE',
    brandNames: 'Lasix and generics',
    drugClass: 'Loop diuretic',
    iconRow: '',
    formulations: [
      'Tabs: 20, 40, 80 mg',
      'Injection: 10 mg/mL (2, 4, 10 mL)',
      'Oral solution: 10 mg/mL (60, 120 mL), 40 mg/5 mL (500 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'IM, IV:',
        lines: [
          DoseLine('Neonate (see remarks): 0.5–1 mg/kg/dose Q12–24 hr; max. dose: 2 mg/kg/dose'),
          DoseLine('Infant and child: 0.5–2 mg/kg/dose Q6–12 hr; max. dose: 6 mg/kg/dose not '
              'to exceed 200 mg/dose'),
          DoseLine('Adult: 20–40 mg/24 hr ÷ Q6–12 hr; max. dose: 200 mg/dose'),
        ],
      ),
      DoseSection(
        heading: 'PO:',
        lines: [
          DoseLine('Neonate: Bioavailability by this route is poor; doses of 1–3 mg/kg/dose '
              'once daily–BID have been used.'),
          DoseLine('Infant and child: Start at 2 mg/kg/dose; may increase by 1–2 mg/kg/dose '
              'no sooner than 6–8 hr following the previous dose. Max. dose: 6 '
              'mg/kg/dose. Dosages have ranged from 1–6 mg/kg/dose Q12–24 hr.'),
          DoseLine('Adult: 20–80 mg/dose Q6–12 hr; max. dose: 600 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Continuous IV infusion:',
        lines: [
          DoseLine('Infant and child: 0.1 mg/kg IV bolus followed by 0.05–0.4 mg/kg/hr '
              'infusion and titrate to effect'),
          DoseLine('Adult: 40–100 mg IV bolus followed by 10–40 mg/hr infusion and titrate to '
              'effect'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in anuria and hepatic coma. Use with caution in hepatic '
          'disease (hepatic encephalopathy has been reported); cirrhotic patients '
          'may require higher than usual doses. Ototoxicity may occur in presence of '
          'renal disease (especially when used with aminoglycosides and other '
          'nephrotoxic drugs), with rapid IV injection (do not infuse >4 mg/min in '
          'adults), or with hypoproteinemia. May cause hypokalemia, alkalosis, '
          'dehydration, hyperuricemia, and increased calcium excretion. Rash with '
          'eosinophilia and systemic symptoms and acute generalized exanthematous '
          'pustulosis have been reported. Prolonged use in premature infants and in '
          'children <4 yr may result in nephrocalcinosis. May increase risk for PDA '
          'in premature infants during the first week of life. Premature infants <31 '
          'wk postconceptual age receiving doses >1 mg/kg/24 hr may develop plasma '
          'levels that could be associated with potential ototoxicity.',
      'Furosemide-resistant edema in pediatric patients may benefit with the '
          'addition of metolazone. Some of these patients may have an exaggerated '
          'response leading to hypovolemia, tachycardia, and orthostatic hypotension '
          'requiring fluid replacement. Severe hypokalemia has been reported with a '
          'tendency for diuresis persisting for up to 24 hr after discontinuing '
          'metolazone, prolonged use of laxatives, or concomitant use of '
          'corticosteroids, ACTH, and large amounts of licorice.',
      'High doses of furosemide may inhibit binding of thyroid hormones to '
          'carrier proteins and result in transient increase in free thyroid '
          'hormones followed by an overall decrease in total thyroid hormone levels.',
      'Max. rate of intermittent IV dose: 0.5 mg/kg/min. For patients receiving '
          'ECMO, do not administer IV doses directly into the ECMO circuit as the '
          'medication is absorbed in the circuit, which may result in diminished '
          'effects and the need for higher doses.',
    ],
    pregnancyNote: 'Pregnancy category changes to “D” if used in pregnancy-induced '
        'hypertension.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1015–1016',
  ),
];
