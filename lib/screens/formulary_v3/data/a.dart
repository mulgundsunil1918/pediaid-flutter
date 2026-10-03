// =============================================================================
// output/a.dart — Drug Formulary 3.0, letter A
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyA` per file; entries in book order.
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

const List<DrugEntryV3> formularyA = [
  // ACETAMINOPHEN — PDF p. 31–32 (printed 840–841)
  DrugEntryV3(
    name: 'ACETAMINOPHEN',
    brandNames: 'Tylenol, Tempra, Panadol, FeverAll, Anacin Asprin Free, Mapap, '
        'Paracetamol, and many others including generics; previously '
        'available as Ofirmev',
    drugClass: 'Analgesic, antipyretic',
    iconRow: '',
    formulations: [
      'Tabs [OTC]: 325, 500 mg',
      'Chewable tabs [OTC]: 80, 160 mg; some may contain phenylalanine',
      'Child suspension/syrup [OTC]: 160 mg/5 mL; may contain sodium benzoate '
          'and propylene glycol',
      'Oral liquid [OTC]: 160 mg/5 mL; may contain sodium benzoate and propylene '
          'glycol',
      'Elixir [OTC]: 160 mg/5 mL; may contain sodium benzoate and propylene '
          'glycol',
      'Extended release tabs [OTC]: 650 mg',
      'Capsules [OTC]: 325, 500 mg',
      'Oral Powder packets:',
      'Tylenol Children’s Dissolve Packs [OTC]: 160 mg (30 packets); contains '
          'sucralose and xylitol',
      'Tylenol Extra Strength Dissolve Packs [OTC]: 500 mg (32 packets); '
          'contains sucralose and xylitol',
      'Suppositories (FeverAll and generics) [OTC]: 80, 120, 325, 650 mg; '
          'contain polysorbate 80',
      'Injection: 10mg/mL (100mL); preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Analgesic and antipyretic:',
      ),
      DoseSection(
        heading: 'PO/PR (maximum daily doses include all routes of acetaminophen '
            'administration and DO NOT exceed 5 doses in 24 hours):',
        lines: [
          DoseLine('Term neonate: 10–15 mg/kg/dose PO/PR Q4–6 hr; max. dose: 75 mg/kg/24 hr. '
              'Some advocate loading doses of 20–25 mg/kg/dose for PO dosing or 30 '
              'mg/kg/dose for PR dosing.'),
          DoseLine('Pediatric: 10–15 mg/kg/dose PO/PR Q4–6 hr; max. dose: 75 mg/kg/24 hr or 4 '
              'g/24 hr. For rectal dosing, some may advocate a 40–45 mg/kg/dose loading '
              'dose.'),
        ],
      ),
      DoseSection(
        heading: 'Dosing by weight (preferred) or age (PO/PR Q4–6 hr; DO NOT exceed 5 '
            'doses in 24 hours):',
        table: DoseTable(
          headers: ['Weight (lbs)', 'Weight (kg)', 'Age', 'Dosage (mg)'],
          rows: [
            DoseTableRow(['6–11', '2.7–5', '0–3 mo', '40']),
            DoseTableRow(['12–17', '5.1–7.7', '4–11 mo', '80']),
            DoseTableRow(['18–23', '7.8–10.5', '1–2 yr', '120']),
            DoseTableRow(['24–35', '10.6–15.9', '2–3 yr', '160']),
            DoseTableRow(['36–47', '16–21.4', '4–5 yr', '240']),
            DoseTableRow(['48–59', '21.5–26.8', '6–8 yr', '320 to 325']),
            DoseTableRow(['60–71', '26.9–32.3', '9–10 yr', '325 to 400']),
            DoseTableRow(['72–95', '32.4–43.2', '11 yr', '480 to 500']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('Adult: 325–650 mg/dose PO/PR Q4–6 hr'),
          DoseLine('Max. dose: 4 g/24 hr, 5 doses/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'IV (maximum daily doses include all routes of acetaminophen '
            'administration):',
        lines: [
          DoseLine(
            'Neonate and infant:',
            isHeading: true,
          ),
          DoseLine('<32 wk gestation: 7.5–10 mg/kg/dose Q6 hr IV up to a maximum of 40 '
              'mg/kg/24 hr'),
          DoseLine(
            '≥32 wk gestation:',
            isHeading: true,
          ),
          DoseLine('≤28 days old: 12.5 mg/kg/dose Q6 hr IV up to a maximum of 50 mg/kg/24 hr'),
          DoseLine('≥29 days old to <2 yr: 15 mg/kg/dose Q6 hr IV up to a maximum of 60 '
              'mg/kg/24 hr'),
          DoseLine('Child (≥2–12 yr): 15 mg/kg/dose Q6 hr, OR 12.5 mg/kg/dose Q4 hr IV up to '
              'the following maximum dose by patient weight:'),
          DoseLine('<50 kg: 75 mg/kg/24 hr up to 3750 mg/24 hr with a maximum single dose of '
              '15 mg/kg/dose up to 750 mg'),
          DoseLine('≥50 kg: 75 mg/kg/24 hr up to 4000 mg/24 hr with a maximum single dose of '
              '15 mg/kg/dose up to 1000 mg'),
          DoseLine(
            'Adolescent (≥13 yr) and adult:',
            isHeading: true,
          ),
          DoseLine('<50 kg: 15 mg/kg/dose Q6 hr, OR 12.5 mg/kg/dose Q4 hr IV up to a daily '
              'maximum of 75 mg/kg/24 hr up to 3750 mg/24 hr with a maximum single dose '
              'of 15 mg/kg/dose up to 750 mg'),
          DoseLine('≥50 kg: 1000 mg Q6 hr, OR 650 mg Q4 hr up to a maximum of 4000 mg/24 hr '
              'with a maximum single dose of 1000 mg/dose'),
        ],
      ),
    ],
    remarks: [
      'Does NOT possess anti-inflammatory activity. Safety and efficacy for '
          'acute pain and fever in children ≥2 years old are supported by controlled '
          'clinical trials. Use with caution in patients with known G6PD deficiency.',
      'T₁/₂: 1–3 hr, 2–5 hr in neonates; metabolized in the liver; see Chapter 3 '
          'and acetylcysteine for management of drug overdose.',
      'Some preparations contain alcohol (7%–10%) and/or phenylalanine; all '
          'suspensions should be shaken before use.',
      'May be used for the treatment of patent ductus arteriosus when standard '
          'NSAID is contraindicated or has failed. Most commonly reported dosage is '
          '15 mg/kg dose Q6 hr IV/PO for 3 days (may be given up to 7 days or with a '
          'repeated 3-day course).',
      'May decrease the activity of lamotrigine and increase the '
          'activity/toxicity of busulfan, warfarin, and zidovudine. Barbiturates, '
          'phenytoin, rifampin, and anticholinergic agents (e.g., scopolamine) may '
          'decrease the effect of acetaminophen. Increased risk for hepatotoxicity '
          'may occur with barbiturates, carbamazepine, phenytoin, carmustine (with '
          'high acetaminophen doses), chronic alcohol use, and inducers of CYP 450 '
          '2E1 (e.g., isoniazid). Adjust dose in renal failure (see Chapter 32).',
      'FOR IV USE: Administer dose undiluted over 15 min. Most common side '
          'effects with IV use include nausea, vomiting, constipation, pruritus, '
          'agitation, and atelectasis in children; and nausea, vomiting, headache, '
          'and insomnia in adults. Rare risk of serious skin reactions (e.g., SJS, '
          'TEN) has been reported.',
    ],
    pregnancyNote: 'Pregnancy category is “B” for oral/rectal routes of administration '
        'and “C” for intravenous route.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 840–841',
  ),
  // ACETAZOLAMIDE — PDF p. 32–33 (printed 841–842)
  DrugEntryV3(
    name: 'ACETAZOLAMIDE',
    brandNames: 'Various generics; previously available as Diamox',
    drugClass: 'Carbonic anhydrase inhibitor, diuretic',
    iconRow: '',
    formulations: [
      'Tabs: 125, 250 mg',
      'Oral suspension: 25 mg/mL',
      'Capsules (extended release): 500 mg',
      'Injection (sodium): 500 mg',
      'Contains 2.05 mEq Na/500 mg drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'Diuretic (PO, IV)',
        lines: [
          DoseLine('Child: 5 mg/kg/dose once daily or every other day'),
          DoseLine('Adult: 250–375 mg/dose once daily or every other day'),
        ],
      ),
      DoseSection(
        heading: 'Glaucoma',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('PO: 8–30 mg/kg/24 hr ÷ Q6–8 hr; max. dose: 1000 mg/24 hr'),
          DoseLine('IM/IV: 20–40 mg/kg/24 hr ÷ Q6 hr; max. dose: 1000 mg/24 hr'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('PO (simple chronic; open angle): 1000 mg/24 hr ÷ Q6 hr'),
          DoseLine('IV (acute secondary; closed angle): For rapid decrease in intraocular '
              'pressure, administer 500 mg/dose IV.'),
        ],
      ),
      DoseSection(
        heading: 'Seizures (extended release product not recommended):',
        lines: [
          DoseLine('Child and adult: 8–30 mg/kg/24 hr ÷ Q6–12 hr PO; max. dose: 1 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Urine alkalization:',
        lines: [
          DoseLine('Adult: 5 mg/kg/dose PO repeated BID-TID over 24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Management of hydrocephalus (see remarks):',
        lines: [
          DoseLine('Start with 20 mg/kg/24 hr ÷ Q8 hr PO/IV; may increase to 100 mg/kg/24 hr '
              'up to a max. dose of 2 g/24 hr.'),
        ],
      ),
      DoseSection(
        heading: 'Pseudotumor cerebri (PO; see remarks):',
        lines: [
          DoseLine('Child: Start with 25 mg/kg/24 hr ÷ once daily-QID; increase by 25 '
              'mg/kg/24 hr until clinical response or as tolerated up to a maximum of '
              '100 mg/kg/24 hr up to 2 g/24 hr.'),
          DoseLine('Adolescent: Start with 1 g/24 hr ÷ once daily-QID; increase by 250 mg/24 '
              'hr until clinical response or as tolerated up to a maximum of 4 g/24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in hepatic failure, severe renal failure (GFR <10 '
          'mL/min), and hypersensitivity to sulfonamides.',
      'T₁/₂: 2–6 hr; do not use sustained release capsules in seizures; IM '
          'injection may be painful; bicarbonate replacement therapy may be required '
          'during long-term use (see Citrate Mixtures or Sodium Bicarbonate). For '
          'use in pseudotumor cerebri, doses of 60 mg/kg/24 hr may be required.',
      'Possible side effects (more likely with long-term therapy) include GI '
          'irritation, paresthesias, sedation, hypokalemia, acidosis, reduced urate '
          'secretion, aplastic anemia, polyuria, and development of renal calculi.',
      'May increase toxicity of carbamazepine and cyclosporine. Aspirin may '
          'increase toxicity of acetazolamide. May decrease the effects of '
          'salicylates, lithium, and phenobarbital. False-positive urinary protein '
          'may occur with several assays. Adjust dose in renal failure (see Chapter '
          '32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 841–842',
  ),
  // ACETYLCYSTEINE — PDF p. 33–34 (printed 842–843)
  DrugEntryV3(
    name: 'ACETYLCYSTEINE',
    brandNames: 'Various generics, Acetadote; previously available as Mucomyst',
    drugClass: 'Mucolytic, antidote for acetaminophen toxicity',
    iconRow: '',
    formulations: [
      'Solution for inhalation or oral use: 100 mg/mL (10%) (4, 10, 30 mL) or '
          '200 mg/mL (20%) (4, 10, 30 mL); may contain EDTA',
      'Injectable (Acetadote and generics): 200 mg/mL (20%) (30 mL); may contain '
          'EDTA 0.5 mg/mL',
      'Preservative-free versions of the inhalation and oral solutions and '
          'injectable forms exist.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Acetaminophen poisoning (see Chapter 3 for additional information):',
        lines: [
          DoseLine('PO: 140 mg/kg (max. 15 g/dose) × 1, followed by 70 mg/kg/dose (max. 7.5 '
              'g/dose) Q4 hr starting 4 hr after initial loading dose for a total of 17 '
              'doses. Repeat dose if vomiting occurs with 1 hr of administration.'),
          DoseLine('IV (see remarks for 2-bag method): 150 mg/kg (max. 15 g/dose) × 1 diluted '
              'in D₅W or D₅W½NS administered over 60 min, followed by 50 mg/kg (max. 5 '
              'g/dose) diluted in D₅W administered over 4 hr, then 100 mg/kg (max. 10 '
              'g/dose) diluted in D₅W administered over 16 hr. Recommended weight-based '
              'drug dilution volumes:'),
        ],
        table: DoseTable(
          headers: ['Weight (kg)', 'Volume of D₅W or D₅W½NS for 150 mg/kg Loading Dose Administered Over 60 '
                'min', 'Volume of D₅W for 50 mg/kg Second Dose Administered Over 4 hr', 'Volume of D₅W for 100 mg/kg Third Dose Administered Over 16 hr'],
          rows: [
            DoseTableRow(['≤20', '3 mL/kg', '7 mL/kg', '14 mL/kg']),
            DoseTableRow(['>20 to ≤40', '100 mL', '250 mL', '500 mL']),
            DoseTableRow(['>40', '200 mL', '500 mL', '1000 mL']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Nebulizer:',
        lines: [
          DoseLine('Infant: 1–2 mL of 20% solution (diluted with equal volume of H₂O, or '
              'sterile saline to equal 10%), or 2–4 mL of 10% solution; administer '
              'TID-QID'),
          DoseLine('Child: 3–5 mL of 20% solution (diluted with equal volume of H₂O, or '
              'sterile saline to equal 10%), or 6–10 mL of 10% solution; administer '
              'TID-QID'),
          DoseLine('Adolescent: 5–10 mL of 10% or 20% solution; administer TID-QID'),
        ],
      ),
      DoseSection(
        heading: 'Distal intestinal obstruction syndrome in cystic fibrosis:',
        lines: [
          DoseLine('Adolescent and adult: 10 mL of 20% solution (diluted in a sweet drink) PO '
              'QID with 100 mL of 10% solution PR as an enema once daily-QID'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in asthma. For nebulized use, give inhaled '
          'bronchodilator 10–15 min before use and follow with postural drainage '
          'and/or suctioning after acetylcysteine administration. Prior hydration is '
          'essential for distal intestinal obstruction syndrome treatment.',
      'May induce bronchospasm, stomatitis, drowsiness, rhinorrhea, nausea, '
          'vomiting, and hemoptysis. Serious hypersensitivity reactions have been '
          'reported with IV use in children. Be aware of potential fluid overload '
          'resulting in hyponatremia with IV volume dilution; reduce diluent volume '
          'if needed.',
      'For IV use, elimination T₁/₂ is longer in newborns (11 hr) than in adults '
          '(5.6 hr). T₁/₂ is increased by 80% in patients with severe liver damage '
          '(Child-Pugh score of 7–13) and biliary cirrhosis (Child-Pugh score of '
          '5–7). A 2-bag IV administration method for acetaminophen poisoning has '
          'been associated with less cutaneous and systemic nonallergic anaphylactic '
          'reactions with similar efficacy [200 mg/kg (max. dose: 20 g/dose) infused '
          'IV over 4 hr followed by 100 mg/kg (max. dose: 10 g/dose) infused over 16 '
          'hr; max. total dose: 30 g].',
      'For oral administration, chilling the solution and mixing with carbonated '
          'beverages, orange juice, or sweet drinks may enhance palatability.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 842–843',
  ),
  // ACTH — PDF p. 34 (printed 843)  [cross-reference]
  DrugEntryV3(
    name: 'ACTH',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Corticotropin',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 843',
  ),
  // ACYCLOVIR — PDF p. 34–36 (printed 843–845)
  DrugEntryV3(
    name: 'ACYCLOVIR',
    brandNames: 'Zovirax and generics',
    drugClass: 'Antiviral',
    iconRow: '',
    formulations: [
      'Capsules: 200 mg',
      'Tabs: 400, 800 mg',
      'Oral suspension: 200 mg/5 mL (473 mL); may contain parabens',
      'Ointment (Zovirax and generics): 5% (5, 15, 30 g)',
      'Cream (Zovirax and generics): 5% (5 g); may contain propylene glycol',
      'Injection in solution (with sodium): 50 mg/mL (10, 20 mL)',
      'Contains 4.2 mEq Na/1 g drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'IMMUNOCOMPETENT:',
      ),
      DoseSection(
        heading: 'Neonatal (HSV and HSV encephalitis; birth–3 mo):',
        lines: [
          DoseLine(
            'Initial IV therapy (duration of therapy: 14 days for cutaneous/mucous '
                'membrane infection or 21 days for CNS/disseminated infection):',
            isHeading: true,
          ),
          DoseLine('<34 wk postmenstrual age: 40 mg/kg/24 hr ÷ Q12 hr IV'),
          DoseLine('≥34 wk postmenstrual age: 60 mg/kg/24 hr ÷ Q8 hr IV'),
          DoseLine('Oral therapy for HSV suppression and neurodevelopment following treatment '
              'with IV acyclovir for 14–21 days: 300 mg/m²/dose Q8 hr PO × 6 mo'),
        ],
      ),
      DoseSection(
        heading: 'HSV encephalitis (duration of therapy: 14–21 days):',
        lines: [
          DoseLine('Birth–3 mo: Use aforementioned IV dosage.'),
          DoseLine('3 mo–12 yr: 30–45 mg/kg/24 hr ÷ Q8 hr IV'),
          DoseLine('≥12 yr: 30 mg/kg/24 hr ÷ Q8 hr IV'),
        ],
      ),
      DoseSection(
        heading: 'Mucocutaneous HSV (including genital):',
        lines: [
          DoseLine(
            'Initial infection:',
            isHeading: true,
          ),
          DoseLine('IV: 15 mg/kg/24 hr or 750 mg/m²/24 hr ÷ Q8 hr × 5–7 days'),
          DoseLine('PO: 80 mg/kg/24 hr ÷ Q6 hr × 7–10 days (max. dose: 3200 mg/24 hr); for > '
              '12 yr, 1200 mg/24 hr ÷ Q8 hr has also been recommended'),
          DoseLine(
            'Recurrence (≥12 yr):',
            isHeading: true,
          ),
          DoseLine('PO: 1600 mg/24 hr ÷ Q12 hr × 5 days, or 2400 mg/24 hr ÷ Q8 hr × 2 days'),
          DoseLine(
            'Chronic suppressive therapy (12 yr):',
            isHeading: true,
          ),
          DoseLine('PO: 800 mg/24 hr ÷ Q12 hr for up to 1 yr and re-evaluate annually'),
        ],
      ),
      DoseSection(
        heading: 'Zoster:',
        lines: [
          DoseLine('IV (all ages): 30 mg/kg/24 hr or 1500 mg/m²/24 hr ÷ Q8 hr × 7–10 days'),
          DoseLine('PO (≥12 yr): 4000 mg/24 hr ÷ 5×/24 hr × 5–7 days'),
        ],
      ),
      DoseSection(
        heading: 'Varicella:',
        lines: [
          DoseLine('IV (≥2 yr): 30 mg/kg/24 hr or 1500 mg/m²/24 hr ÷ Q8 hr × 7–10 days'),
          DoseLine('PO (≥2 yr): 80 mg/kg/24 hr ÷ QID × 5 days (begin treatment at earliest '
              'signs/symptoms); max. dose: 3200 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Max. dose',
        lines: [
          DoseLine('of oral acyclovir in children = 80 mg/kg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'IMMUNOCOMPROMISED:',
      ),
      DoseSection(
        heading: 'HSV:',
        lines: [
          DoseLine('IV (all ages): 1500 mg/m²/24 hr ÷ Q8 hr × 7–14 days'),
          DoseLine('PO (≥2 yr): 1000 mg/24 hr ÷ 3–5 times/24 hr × 7–14 days; max. dose for '
              'child: 80 mg/kg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'HSV prophylaxis:',
        lines: [
          DoseLine('IV (all ages): 750 mg/m²/24 hr ÷ Q8 hr during risk period'),
          DoseLine('PO (≥2 yr): 600–1000 mg/24 hr ÷ 3–5 times/24 hr during risk period; max. '
              'dose for child: 80 mg/kg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Varicella or zoster:',
        lines: [
          DoseLine('IV (all ages): 1500 mg/m²/24 hr ÷ Q8 hr × 7–10 days'),
          DoseLine(
            'PO (consider using valacyclovir or famciclovir for better absorption):',
            isHeading: true,
          ),
          DoseLine('Infant and child: 20 mg/kg/dose (max. 800 mg) Q6 hr × 7–10 days'),
          DoseLine('Adolescent and adult: 20 mg/kg/dose (max. 800 mg) 5 times daily × 7–10 '
              'days'),
        ],
      ),
      DoseSection(
        heading: 'Max. dose',
        lines: [
          DoseLine('of oral acyclovir in children = 80 mg/kg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'TOPICAL:',
      ),
      DoseSection(
        heading: 'Cream (see remarks):',
        lines: [
          DoseLine('Herpes labialis (≥12 yr and adult): Apply to affected areas 5 times a day '
              '× 4 days.'),
        ],
      ),
      DoseSection(
        heading: 'Ointment:',
        lines: [
          DoseLine('Immunocompromised genital or mucocutaneous HSV (adult): Apply ½-inch '
              'ribbon of 5% ointment for 4-inch square surface area 6 times a day × 7 '
              'days.'),
        ],
      ),
    ],
    remarks: [
      'See most recent edition of the AAP RedBook for further details. Use with '
          'caution in patients with preexisting neurologic or renal impairment '
          '(adjust dose; see Chapter 32) or dehydration. Adequate hydration and slow '
          '(1 hr) IV administration are essential to prevent crystallization in '
          'renal tubules. Do not use topical product on the eye or for the '
          'prevention of recurrent HSV infections. Oral absorption is unpredictable '
          '(15%–30%); consider using valacyclovir or famciclovir for better '
          'absorption. Use ideal body weight for obese patients when calculating '
          'dosages. Resistant strains of HSV and VZV have been reported in '
          'immunocompromised patients (e.g., advanced HIV infection).',
      'Inflammation or phlebitis at the injection site and transient elevations '
          'of sCr and BUN are the most frequent IV use side effects. Can cause renal '
          'impairment and has been associated with headache, vertigo, insomnia, '
          'encephalopathy, GI tract irritation, elevated liver function tests, rash, '
          'urticaria, arthralgia, fever, and adverse hematologic effects. Probenecid '
          'decreases acyclovir renal clearance. Acyclovir may increase the '
          'concentration of tenofovir, and meperidine and its metabolite '
          '(normeperidine).',
      'Topical cream acyclovir 5% in combination with hydrocortisone 1% (Xerese) '
          'is indicated for herpes labialis (≥6 yr and adults) at a dosage of 5 '
          'applications per day for 5 days. Use a finger cot or rubber glove when '
          'applying topical cream or ointment.',
      'Ophthalmic ointment product was removed from market in 2021.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 843–845',
  ),
  // ADAPALENE ± BENZOYL PEROXIDE — PDF p. 36–37 (printed 845–846)
  DrugEntryV3(
    name: 'ADAPALENE ± BENZOYL PEROXIDE',
    brandNames: 'Differin and generics\nIn combination with benzoyl peroxide: '
        'Epiduo, Epiduo Forte',
    drugClass: 'Synthetic retinoic acid derivative; topical acne product',
    iconRow: '',
    formulations: [
      'Topical cream: 0.1% (45 g)',
      'Topical gel: 0.1% [OTC] (15, 45 g), 0.3% (45 g); some preparations may '
          'contain parabens and propylene glycol',
      'Topical lotion: 0.1% (59 mL); some preparations may contain parabens and '
          'propylene glycol',
      'Topical solution as a swab: 0.1% (1.2 g per swab; 14 swabs per box)',
      'In combination with benzoyl peroxide:',
      'Topical gel:',
      'Epiduo and generics: 0.1% adapalene + 2.5% benzoyl peroxide (45 g)',
      'Epiduo Forte: 0.3% adapalene + 2.5% benzoyl peroxide (45, 60 g)',
      'Topical gel as a swab: 0.1% adapalene + 2.5% benzoyl peroxide (1.2 g per '
          'swab; 14 swabs per box)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Adapalene (≥12 yr and adult; see remarks):',
        lines: [
          DoseLine('Apply a thin film of cream, gel, or lotion to affected areas of cleansed '
              'and dried skin QHS. Limited data in children 7 to ≤12 yr'),
        ],
      ),
      DoseSection(
        heading: 'Adapalene and benzoyl peroxide (see remarks):',
        lines: [
          DoseLine('Apply a thin film to affected areas of cleansed and dried skin once daily.'),
          DoseLine('Epiduo: Indicated for children ≥9 yr and adults with limited data in '
              'children 7 to <9 yr'),
          DoseLine('Epiduo Forte: Indicated for children ≥12 yr and adults'),
        ],
      ),
    ],
    remarks: [
      'Avoid contact with eyes, mucous membranes, abraded skin, and open wounds; '
          'excessive sun exposure; and use of other irritating topical products. A '
          'mild, transitory warm or stinging sensation of the skin may occur during '
          'the first 4 wk of use. Clean and dry the skin before each use.',
      'ADAPALENE: Onset of therapeutic benefits seen in 8–12 wk. Common side '
          'effects include dry skin, erythema, and scaly skin. When compared with '
          'tretinoin in clinical trials for acne vulgaris, adapalene was as '
          'effective and had a more rapid onset of clinical effects with less skin '
          'irritation. Anaphylaxis, angioedema, urticaria, face edema, eyelid edema, '
          'lip swelling, and pruritus have been reported.',
      'ADAPALENE + BENZOYL PEROXIDE: Contraindicated in patients with a history '
          'of benzoyl peroxide hypersensitivity reactions. Avoid or minimize '
          'exposure to artificial (e.g., tanning beds) or natural light to prevent '
          'photosensitivity reactions; sunscreen products and protective apparel use '
          'are recommended. Onset of therapeutic benefits seen in 4–8 wk. Side '
          'effects reported in placebo-controlled studies include dry skin, '
          'erythema, skin irritation, and contact dermatitis. When compared with '
          'isotretinoin in a clinical trial for nodulocystic acne, adapalene + '
          'benzoyl peroxide plus doxycycline was not inferior to isotretinoin and '
          'was less effective in reducing the number of total lesions (nodules, '
          'papules/pustules, and comedones).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 845–846',
  ),
  // ADDERALL — PDF p. 37 (printed 846)  [cross-reference]
  DrugEntryV3(
    name: 'ADDERALL',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Dextroamphetamine ± Amphetamine',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 846',
  ),
  // ADENOSINE — PDF p. 37 (printed 846)
  DrugEntryV3(
    name: 'ADENOSINE',
    brandNames: 'Generics; previously available as Adenocard',
    drugClass: 'Antiarrhythmic',
    iconRow: '',
    formulations: [
      'Injection: 3 mg/mL (2, 4, 20, 30 mL); preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Supraventricular tachycardia (follow each dose with NS flush; see '
            'remarks):',
        lines: [
          DoseLine('Neonate: 0.05–0.1 mg/kg by rapid IV push over 1–2 sec; may increase dose '
              'by 0.05–0.1 mg/kg increments every 2 min up to a max. single dose of 0.3 '
              'mg/kg or until termination of SVT'),
          DoseLine('Child: 0.1 mg/kg (initial max. dose: 6 mg) by rapid IV/IO push over 1–2 '
              'sec; may repeat in 2 min at 0.2 mg/kg IV/IO, then 0.3 mg/kg IV/IO after 2 '
              'min (all subsequent max. single doses: 12 mg), or until termination of SVT'),
          DoseLine('Adolescent and adult ≥50 kg: 6 mg rapid IV push over 1–2 sec; if no '
              'response after 1–2 min, give 12 mg rapid IV push. May repeat a second 12 '
              'mg dose after 1–2 min if required. Max. single dose: 12 mg'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in 2nd-degree and 3rd-degree AV block or sick sinus '
          'syndrome unless pacemaker placed. Use with caution in combination with '
          'digoxin (enhanced depressant effects on SA and AV nodes). If necessary, '
          'doses may be administered IO. T₁/₂: <10 sec.',
      'May precipitate bronchoconstriction, especially in asthmatics. Side '
          'effects include transient asystole, facial flushing, headache, shortness '
          'of breath, dyspnea, nausea, chest pain, and lightheadedness.',
      'Carbamazepine and dipyridamole may increase the effects and toxicity of '
          'adenosine, respectively Methylxanthines (e.g., caffeine and theophylline) '
          'may decrease the effects of adenosine.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 846',
  ),
  // ALBUMIN, HUMAN — PDF p. 38 (printed 847)
  DrugEntryV3(
    name: 'ALBUMIN, HUMAN',
    brandNames: 'Albuked, Albumin-ZLB, Albuminex, AlbuRx, Albutein, Kedbumin, and '
        'many others',
    drugClass: 'Blood product derivative, plasma volume expander',
    iconRow: '',
    formulations: [
      'Injection: 5% (50 mg/mL) (50, 100, 250, 500 mL); 25% (250 mg/mL) (50, 100 '
          'mL); both concentrations contain 130–160 mEq Na/L',
    ],
    doseSections: [
      DoseSection(
        heading: 'Product concentration use recommendations:',
        lines: [
          DoseLine('5%: hypovolemia or intravascular depletion'),
          DoseLine('25%: fluid or sodium restriction; considered contraindicated in preterm '
              'infants'),
        ],
      ),
      DoseSection(
        heading: 'Hypoalbuminemia:',
        lines: [
          DoseLine('Child: 0.5–1 g/kg/dose (max. dose: 25 g/dose) IV over 30–120 min; repeat '
              'Q1–2 days PRN'),
          DoseLine('Adult: 25 g/dose IV over 30–120 min; repeat Q1–2 days PRN'),
          DoseLine('Max. dose: 2 g/kg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Hypovolemia:',
        lines: [
          DoseLine('Child: 0.5–1 g/kg/dose IV rapid infusion; after 15–30 min, may repeat PRN'),
          DoseLine('Adult: 12.5–25 g/dose IV rapid infusion; after 15–30 min, may repeat PRN'),
        ],
      ),
      DoseSection(
        heading: '',
        table: DoseTable(
          headers: ['Product Concentration', 'Patients With Normal Plasma Volume', 'Patients With Hypoproteinemia'],
          rows: [
            DoseTableRow(['5%', '2–4 mL/min', '5–10 mL/min']),
            DoseTableRow(['25%', '1 mL/min', '2–3 mL/min']),
          ],
        ),
      ),
    ],
    remarks: [
      'Contraindicated in cases of CHF or severe anemia; rapid infusion may '
          'cause fluid overload; hypersensitivity reactions may occur; may cause '
          'rapid increase in serum sodium levels. Recommended maximum infusion rates:',
      'Caution: 25% concentration is considered contraindicated in preterm '
          'infants due to risk of IVH. Use product-specific recommended in-line '
          'filter size. Both 5% and 25% products are isotonic but differ in oncotic '
          'effects. Dilutions of the 25% product should be made with D₅W or NS; '
          'avoid sterile water as a diluent.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 847',
  ),
  // ALBUTEROL — PDF p. 38–39 (printed 847–848)
  DrugEntryV3(
    name: 'ALBUTEROL',
    brandNames: 'Ventolin HFA (aerosol inhaler), ProAir RespiClick (breath-activated '
        'inhaler), and many generics',
    drugClass: 'β₂ adrenergic agonist',
    iconRow: '',
    formulations: [
      'Tabs: 2, 4 mg',
      'Oral solution: 2 mg/5 mL (473 mL)',
      'Aerosol inhaler (HFA): 90 mCg/actuation',
      'Ventolin HFA: (60 actuations/inhaler) (8 g), (200 actuations/inhaler) (18 '
          'g)',
      'Generic: (6.7, 8.5, 18 g)',
      'Breath-activated aerosol powder inhaler:',
      'ProAir RespiClick: 90 mCg/actuation (200 actuations/inhaler) (0.65 g); '
          'contains milk proteins and small amounts of lactose',
      'Nebulization solution (dilution required): 0.5% (5 mg/mL) (0.5, 5, 20 '
          'mL); some preparations may be preservative free (see remarks)',
      'Prediluted nebulized solution: 0.63 mg in 3 mL NS, 1.25 mg in 3 mL NS, '
          'and 2.5 mg in 3 mL NS (0.083%); some preparations may be preservative '
          'free (see remarks)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Bronchospasm (nonacute use; see remarks):',
        lines: [
          DoseLine('Aerosol (HFA): 2 puffs (90 mCg/puff) Q4–6 hr PRN'),
          DoseLine(
            'Breath-activated aerosol (see remarks):',
            isHeading: true,
          ),
          DoseLine('≥4 yr: 2 inhalations (90 mCg/inhalation) Q4–6 hr PRN'),
          DoseLine(
            'Nebulization:',
            isHeading: true,
          ),
          DoseLine('<4 yr: 0.63–2.5 mg/dose Q4–6 hr PRN'),
          DoseLine('5–11 yr: 1.25–5 mg/dose Q4–6 hr PRN'),
          DoseLine('≥12 yr: 2.5–5 mg/dose Q4–8 hr PRN'),
        ],
      ),
      DoseSection(
        heading: 'For use in acute exacerbations, scheduled frequency and more '
            'aggressive dosing may be used.',
      ),
      DoseSection(
        heading: 'Exercise-induced bronchospasm (administered 15–30 min before '
            'exercise):',
        lines: [
          DoseLine('Aerosol (HFA): 2 puffs (90 mCg/puff)'),
          DoseLine('Breath-activated aerosol (see remarks): 2 inhalations (90 mCg/inhalation)'),
        ],
      ),
    ],
    remarks: [
      'Inhaled doses may be given more frequently than indicated. In such cases, '
          'consider cardiac monitoring and monitoring of serum potassium '
          '(hypokalemia). Systemic effects are dose related. Verify the '
          'concentration of the nebulization solution used. Continuous nebulization '
          'treatment with an albuterol product containing the benzalkonium chloride '
          'preservative has been reported to have a longer duration of treatment and '
          'need for additional respiratory support when compared to a '
          'preservative-free albuterol product.',
      'Safety and efficacy for the treatment of symptoms or bronchospasms '
          'associated with obstructive airway disease have not been demonstrated for '
          'children <4 yr of age (either dose studied was not optimal in this age '
          'group or drug is not effective in this age group).',
      'Use of oral dosage form is discouraged due to increased side effects and '
          'decreased efficacy compared with inhaled formulations.',
      'Possible side effects include tachycardia, palpitations, tremor, '
          'insomnia, nervousness, nausea, and headache.',
      'The use of tube spacers or chambers may enhance efficacy of the HFA '
          'metered-dose inhalers and have been proven to be just as effective and '
          'sometimes safer than nebulizers. Do not use a spacer device with any of '
          'the breath-activated inhaler dosage forms. Breath-activated dosage forms '
          'require patients to generate a minimum inspiratory flow rate of ≥30 L/min '
          'for proper dose activation. ProAir RespiClick: keep device dry and do not '
          'wash or place any part of the inhaler in water.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 847–848',
  ),
  // ALLOPURINOL — PDF p. 39–40 (printed 848–849)
  DrugEntryV3(
    name: 'ALLOPURINOL',
    brandNames: 'Aloprim and generics; previously available as Zyloprim',
    drugClass: 'Uric acid lowering agent, xanthine oxidase inhibitor',
    iconRow: '',
    formulations: [
      'Tabs: 100, 200, 300 mg',
      'Oral suspension: 20 mg/mL',
      'Injection (Aloprim and generics): 500 mg',
      'Contains ∼1.45 mEq Na/500 mg drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'For use in tumor lysis syndrome, see Chapter 22 for additional '
            'information. See remarks for genomic considerations.',
      ),
      DoseSection(
        heading: 'Child:',
        lines: [
          DoseLine('Oral: 10 mg/kg/24 hr PO ÷ BID–QID; max. dose: 800 mg/24 hr'),
          DoseLine('Injectable: 200 mg/m²/24 hr IV ÷ Q6–12 hr; max. dose: 600 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Oral: 200–800 mg/24 hr PO ÷ BID–TID'),
          DoseLine('Injectable: 200–400 mg/m²/24 hr IV ÷ Q6–12 hr; max. dose: 600 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Discontinue use at the first appearance of skin rash or other signs of an '
          'allergic reaction. Avoid use in individuals with HLA-B*58:01 allele as '
          'they are at significant risk for developing severe cutaneous adverse '
          'reactions (e.g., Stevens-Johnson syndrome, DRESS, and TEN).',
      'Side effects include rash, neuritis, hepatotoxicity, renal function '
          'impairment, GI disturbance, bone marrow suppression, and drowsiness.',
      'Adjust dose in renal insufficiency (see Chapter 32). Must maintain '
          'adequate urine output and alkaline urine.',
      'Drug interactions: Increases serum theophylline level; may increase the '
          'incidence of rash with ampicillin and amoxicillin; increased risk of '
          'toxicity with azathioprine, didanosine, and mercaptopurine; and increased '
          'risk of hypersensitivity reactions with ACE inhibitors and thiazide '
          'diuretics. Use with didanosine is contraindicated due to increased risk '
          'for didanosine toxicity. Rhabdomyolysis has been reported with '
          'clarithromycin use.',
      'IV dosage form is very alkaline and must be diluted to a minimum '
          'concentration of 6 mg/mL and infused over 30 min.',
      'The manufacturer advises not to breastfeed during treatment with '
          'allopurinol for 1 week after the last dose as limited data indicate a '
          'maternal dose of 300 mg daily can provide near-therapeutic dose and '
          'plasma levels in an exclusively breastfed infant.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 848–849',
  ),
  // ALMOTRIPTAN MALATE — PDF p. 40–41 (printed 849–850)
  DrugEntryV3(
    name: 'ALMOTRIPTAN MALATE',
    brandNames: 'Generics; previously available as Axert',
    drugClass: 'Antimigraine agent, selective serotonin agonist',
    iconRow: '',
    formulations: [
      'Tabs: 6.25, 12.5 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Treatment of acute migraines with or without aura:',
        lines: [
          DoseLine(
            'Oral (safety of an average of >4 headaches in a 30-day period has not '
                'been established; see remarks):',
            isHeading: true,
          ),
          DoseLine('Child ≥12 and adult: Start with 6.25–12.5 mg PO × 1. If needed in 2 hr, a '
              'second dose may be administered. Max. daily dose: 2 doses/24 hr and 25 '
              'mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in ischemic/vasospastic coronary artery disease, '
          'significant underlying cardiovascular disease, cerebrovascular syndromes, '
          'peripheral vascular disease, uncontrolled hypertension, or '
          'hemiplegic/basilar migraine. Do not administer with any '
          'ergotamine-containing medication or ergot-type medication, any other '
          '5-HT₁ agonist (e.g., triptans), methylene blue, or with/within 2 wk of '
          'discontinuing an MAO inhibitor or linezolid.',
      'FDA-labeled indication for adolescents is acute migraine treatment in '
          'patients with a history of migraine lasting ≥4 hr when left untreated. '
          'Efficacy for the treatment of migraine-associated symptoms of nausea, '
          'photophobia, and phonophobia was not established for adolescents.',
      'Most common side effects include dizziness, somnolence, headache, '
          'paresthesia, nausea, and vomiting. Reported serious adverse effects '
          'include coronary artery spasm, ischemia',
      '(myocardial, gastrointestinal, peripheral vascular), '
          'cerebral/subarachnoid hemorrhage, cerebrovascular accident/disease, and '
          'vision loss.',
      'Use with caution in renal impairment (CrCl ≤30 mL/min) or hepatic '
          'impairment; use initial dose of 6.25 mg dose with a max. daily dose of '
          '12.5 mg/24 hr.',
      'Almotriptan is a minor substrate for cytochrome 450 (CYP) 2D6 and 3A4. '
          'Use lower initial single dose of 6.25 mg with max. daily dose of 12.5 mg '
          'if receiving a potent CYP3A4 inhibitor (e.g., itraconazole, ritonavir). '
          'Do not use almotriptan in the presence of renal or hepatic impairment and '
          'if receiving a potent CYP3A4 inhibitor.',
      'Doses may be administered with or without food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 849–850',
  ),
  // ALPROSTADIL — PDF p. 41 (printed 850)
  DrugEntryV3(
    name: 'ALPROSTADIL',
    brandNames: 'Prostin VR Pediatric, prostaglandin E₁, PGE₁',
    drugClass: 'Prostaglandin E₁, vasodilator',
    iconRow: '',
    formulations: [
      'Injection: 500 mCg/mL (1 mL); contains dehydrated alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate:',
        lines: [
          DoseLine('Initial: 0.05–0.1 mCg/kg/min. Advance to 0.2 mCg/kg/min if necessary.'),
          DoseLine('Maintenance: When increase in PaO₂ is noted, decrease immediately to '
              'lowest effective dose. Usual dosage range: 0.01–0.4 mCg/kg/min; doses '
              '>0.4 mCg/kg/min not likely to produce additional benefit.'),
        ],
      ),
      DoseSection(
        heading: 'To prepare infusion:',
        lines: [
          DoseLine('See inside front cover.'),
        ],
      ),
    ],
    remarks: [
      'For palliation only. Continuous vital sign monitoring essential. May '
          'cause apnea (10%–12%; especially in those weighing <2 kg at birth), '
          'fever, seizures, flushing, bradycardia, hypotension, diarrhea, gastric '
          'outlet obstruction, and reversible cortical proliferation of long bones '
          '(with prolonged use). May decrease platelet aggregation.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 850',
  ),
  // ALTEPLASE — PDF p. 41–42 (printed 850–851)
  DrugEntryV3(
    name: 'ALTEPLASE',
    brandNames: 'Activase, Cathflo Activase, tPA',
    drugClass: 'Thrombolytic agent, tissue plasminogen activator',
    iconRow: '',
    formulations: [
      'Injection:',
      'Cathflo Activase: 2 mg',
      'Activase: 50 mg (29 million unit), 100 mg (58 million unit)',
      'All products contain: L-arginine and polysorbate 80',
    ],
    doseSections: [
      DoseSection(
        heading: 'Occluded IV catheter:',
        lines: [
          DoseLine('Aspiration method: Use 1 mg/1 mL concentration as follows:'),
          DoseLine(
            'Central venous line (dosage per lumen, treating one lumen at a time):',
            isHeading: true,
          ),
          DoseLine('<30 kg: Instill a volume equal to 110% of internal lumen volume of the '
              'catheter NOT exceeding 2 mg.'),
          DoseLine('≥30 kg: 2 mg each lumen'),
          DoseLine('Subcutaneous port: Instill a volume equal to 110% of internal lumen and '
              'line volume of the port NOT exceeding 2 mg.'),
          DoseLine('Instill into catheter over 1–2 min and leave in place for 2 hr before '
              'attempting blood withdrawal. After 2 hr, attempts to withdraw blood may '
              'be made every 2 hr for 3 attempts. Dose may be repeated once in 24 hr '
              'using a longer catheter dwell time of 3–4 hr. After 3–4 hr (repeat dose), '
              'attempts to withdraw blood may be made every 2 hr for 3 attempts. DO NOT '
              'infuse into patient.'),
        ],
      ),
      DoseSection(
        heading: 'Systemic thrombolytic therapy (limited data, use in consultation with '
            'a hematologist; see remarks):',
        lines: [
          DoseLine(
            'Low-dose initial infusion:',
            isHeading: true,
          ),
          DoseLine('<90 days old: 0.06 mg/kg/hr; max. dose: 2 mg/hr'),
          DoseLine('≥90 days old–21 yr: 0.03 mg/kg/hr; max. dose: 2 mg/hr'),
          DoseLine('High-dose initial infusion: 0.1–0.5 mg/kg/hr; max. dose: 25 mg/hr'),
          DoseLine('Dosage regimens ranging from lower dosages (0.01 mg/kg/hr) to higher '
              'dosages (0.1–0.6 mg/kg/hr) have been reported (Chest 2008;133:887–968S). '
              'The length of continuous infusion is variable as patients may respond to '
              'longer or shorter courses of therapy.'),
        ],
      ),
    ],
    remarks: [
      'Current use in the pediatric population is limited. May cause bleeding, '
          'rash, angioedema, and increased prothrombin time. Rare fatal '
          'hypersensitivity reaction has been reported.',
      'THROMBOLYTIC USE: History of stroke, transient ischemic attacks, other '
          'neurologic disease, and hypertension are contraindications for adults but '
          'considered relative contraindications for children. Monitor fibrinogen, '
          'thrombin clotting time, PT, and aPTT when used as a thrombolytic. For '
          'systemic thrombosis therapy, efficacy has been reported at 40%–97% with '
          'the risk for bleeding at 3%–27%. Poor efficacy in VTE in children has '
          'been recently reported. Use with caution in severe hepatic or renal '
          'dysfunction (systemic use only).',
      'Newborns have reduced plasminogen levels (∼50% of adult values), which '
          'decrease the thrombolytic effects of alteplase. Plasminogen '
          'supplementation may be necessary.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 850–851',
  ),
  // ALUMINUM HYDROXIDE — PDF p. 42 (printed 851)
  DrugEntryV3(
    name: 'ALUMINUM HYDROXIDE',
    brandNames: 'Various generics; previously available as Amphojel',
    drugClass: 'Antacid, phosphate binder',
    iconRow: '',
    formulations: [
      'Oral suspension [OTC]: 320 mg/5 mL (473 mL)',
      'Each 5-mL suspension contains <0.13 mEq Na.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Antacid (see remarks):',
        lines: [
          DoseLine('Child: 320–960 mg (5–15 mL) PO 1–3 hr PC and QHS PRN'),
          DoseLine('Adult: 640 mg (10 mL) PO 1–3 hr PC and QHS PRN; max. dose: 3840 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Hyperphosphatemia (administer all doses with meals and titrate to '
            'normal serum phosphorus):',
        lines: [
          DoseLine('Child: 50–150 mg/kg/24 hr ÷ Q4–6 hr PO'),
          DoseLine('Adult: 300–600 mg TID PO with meals'),
          DoseLine('Max. dose (all ages): 3000 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'AVOID long-term use. Chronic antacid use is not recommended for children '
          'with GERD. Use with caution in patients with renal failure and upper GI '
          'hemorrhage.',
      'Interferes with the absorption of several orally administered '
          'medications, including digoxin, ethambutol, indomethacin, isoniazid, '
          'naproxen, mycophenolate, tetracyclines, fluoroquinolones (e.g., '
          'ciprofloxacin), and iron. In general, do not take oral medications within '
          '1–2 hr of taking aluminum dose unless specified.',
      'May cause constipation, decreased bowel motility, encephalopathy, and '
          'phosphorus depletion.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 851',
  ),
  // ALUMINUM HYDROXIDE WITH MAGNESIUM HYDROXIDE ± SIMETHICONE — PDF p. 43 (printed 852)
  DrugEntryV3(
    name: 'ALUMINUM HYDROXIDE WITH MAGNESIUM HYDROXIDE ± SIMETHICONE',
    brandNames: 'Mag-Al; previously available as Maalox\nIn combination with '
        'simethicone: Mylanta Maximum Strength, Almacone Antacid Antigas, '
        'Almacone Double Strength, and many other generics (see remarks)',
    drugClass: 'Antacid',
    iconRow: '',
    formulations: [
      'Chewable tabs [OTC]: (Al [OH]₃: Mg [OH]₂)',
      'Almacone and generics: 200 mg AlOH, 200 mg MgOH, and 25 mg simethicone',
      'Oral suspension [OTC] (see remarks):',
      'Mag-Al: each 5 mL contains 200 mg AlOH and 200 mg MgOH (30 mL); contains '
          'parabens, propylene glycol, and saccharin',
      'Almacone Antacid Antigas, and generics: each 5 mL contains 200 mg AlOH, '
          '200 mg MgOH, and 20 mg simethicone (150, 360, 720 mL); some preparations '
          'may contain 0.2% alcohol, benzyl alcohol, or propylene glycol',
      'Mylanta Maximum Strength, Almacone Double Strength, and generics: each 5 '
          'mL contains 400 mg AlOH, 400 mg MgOH, and 40 mg simethicone (360, 480 '
          'mL); some preparations may contain benzyl alcohol',
      'Many other combinations exist.',
      'Contains 0.03–0.06 mEq Na/5 mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Antacid (mL volume dosages are based on the 200 mg AlOH, 200 mg MgOH, '
            '± 20 mg simethicone per 5 mL oral suspension concentration):',
        lines: [
          DoseLine('Child ≤12 yr: 0.5–1 mL/kg/dose (max. dose: 20 mL/dose) PO 1–3 hr PC and '
              'HS PRN'),
          DoseLine('>12 yr and adult: 10–20 mL PO 1–3 hr PC and HS PRN; max. dose: 80 mL/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Chronic antacid use is not recommended for children with GERD. May have '
          'laxative effect. May cause hypokalemia. Use with caution in patients with '
          'renal insufficiency (magnesium), gastric outlet obstruction. Do not use '
          'for hyperphosphatemia.',
      'Interferes with the absorption of the benzodiazepines, chloroquine, '
          'digoxin, naproxen, mycophenolate, phenytoin, quinolones (e.g., '
          'ciprofloxacin), tetracyclines, and iron. In general, do not take oral '
          'medications within 1–2 hr of taking antacid dose unless specified.',
      'DO NOT use Maalox Total Relief (bismuth subsalicylate), Mylanta New '
          'Tonight Soothing Liquid (calcium carbonate + magnesium hydroxide + '
          'simethicone), Maalox Regular Strength or Children’s Chewable Tablets and '
          'Children’s Mylanta Chewable Tablets (calcium carbonate), Maalox Maximum '
          'Strength Chewable (calcium carbonate and simethicone), and Mylanta Gas '
          '(simethicone), as these products do not contain aluminum hydroxide and '
          'magnesium hydroxide.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 852',
  ),
  // ALYFTREK — PDF p. 43 (printed 852)  [cross-reference]
  DrugEntryV3(
    name: 'ALYFTREK',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Vanzacaftor/Tezacaftor/Deutivacaftor',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 852',
  ),
  // AMANTADINE HYDROCHLORIDE — PDF p. 43–44 (printed 852–853)
  DrugEntryV3(
    name: 'AMANTADINE HYDROCHLORIDE',
    brandNames: 'Immediate release dosage forms: generics; previously available as '
        'Symmetrel\nExtended release dosage forms: Gocovri, Osmolex ER',
    drugClass: 'Antiviral agent',
    iconRow: '',
    formulations: [
      'Capsule: 100 mg',
      'Tabs: 100 mg',
      'Extended-release capsule (Gocovri; see remarks): 68.5, 137 mg',
      'Extended-release tabs (Osmolex ER; see remarks): 129 mg',
      'Oral solution: 50 mg/5 mL (480 mL); may contain parabens',
    ],
    doseSections: [
      DoseSection(
        heading: 'Traumatic brain injury (limited data; use immediate-release dosage '
            'forms):',
        lines: [
          DoseLine('≥6 yr to <16 yr: 4–6 mg/kg/24 hr PO ÷ BID with the suggested maximum '
              'dosage:'),
          DoseLine('<10 yr or <40 kg: 150 mg/24 hr'),
          DoseLine('≥10 yr or ≥40 kg: 200 mg/24 hr'),
          DoseLine('≥16 yr: 100 mg PO BID x 14 days, then increase to 150 mg PO BID. If '
              'needed, may increase dose to 200 mg PO BID only after 3 weeks from the '
              'initiation of therapy.'),
        ],
      ),
    ],
    remarks: [
      'Use in influenza A no longer recommended due to high resistance rates. '
          'Avoid use of live attenuated influenza vaccine (LAIV) due to potential '
          'risk for reduced vaccine efficacy.',
      'Preliminary studies in traumatic brain injury suggest improved cognition '
          'in children who were more recently injured (<2 yr after injury).',
      'Do not use in the first trimester of pregnancy. Use with caution in '
          'patients with liver disease, seizures, renal disease, congestive heart '
          'failure, peripheral edema, orthostatic hypotension, or history of '
          'recurrent eczematoid rash, and in those receiving CNS stimulants. Adjust '
          'dose in patients with renal insufficiency (see Chapter 32).',
      'Extended-release capsule and tablet dosage forms are indicated for the '
          'treatment of dyskinesia in patients with Parkinson disease receiving '
          'levodopa-based therapy.',
      'May cause dizziness, anxiety, depression, mental status change, rash '
          '(livedo reticularis), nausea, orthostatic hypotension, edema, CHF, and '
          'urinary retention. Impulse control disorder has been reported. '
          'Neuroleptic malignant syndrome has been reported with abrupt dose '
          'reduction or discontinuation (especially if patient is receiving '
          'neuroleptics).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 852–853',
  ),
  // AMIKACIN SULFATE — PDF p. 44–45 (printed 853–854)
  DrugEntryV3(
    name: 'AMIKACIN SULFATE',
    brandNames: 'Various generics; previously available as Amikin',
    drugClass: 'Antibiotic, aminoglycoside',
    iconRow: '',
    formulations: [
      'Injection: 250 mg/mL (2, 4 mL); may contain sodium bisulfite',
    ],
    doseSections: [
      DoseSection(
        heading: '',
        lines: [
          DoseLine('Initial empirical dosage; patient-specific dosage defined by therapeutic '
              'drug monitoring (see remarks).'),
        ],
      ),
      DoseSection(
        heading: 'Neonate:',
        lines: [
          DoseLine('See the following table'),
        ],
      ),
      DoseSection(
        heading: 'Neonate Dosages',
        table: DoseTable(
          headers: ['Postconceptional Age (wk)', 'Postnatal Age (days)', 'Dose (mg/kg/dose)', 'Interval (hr)'],
          rows: [
            DoseTableRow(['≤29ᵃ', '0–7', '18', '48']),
            DoseTableRow(['', '8–28', '15', '36']),
            DoseTableRow(['', '>28', '15', '24']),
            DoseTableRow(['30–34', '0–7', '18', '36']),
            DoseTableRow(['', '>7', '15', '24']),
            DoseTableRow(['≥35', 'ALL', '15', '24ᵇ']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃOr significant asphyxia, PDA, indomethacin use, poor cardiac output, '
              'reduced renal function.'),
          DoseLine('ᵇUse Q36 hr interval for HIE patients receiving whole-body therapeutic '
              'cooling.'),
        ],
      ),
      DoseSection(
        heading: 'Infant and child:',
        lines: [
          DoseLine('15–22.5 mg/kg/24 hr ÷ Q8 hr IV/IM; infants and patients requiring higher '
              'doses (e.g., cystic fibrosis) may receive initial doses of 30 mg/kg/24 hr '
              '÷ Q8 hr IV/IM'),
        ],
      ),
      DoseSection(
        heading: 'Cystic fibrosis (if available, use patient’s previous therapeutic '
            'mg/kg dosage):',
        lines: [
          DoseLine('Conventional Q8 hr dosing: 30 mg/kg/24 hr ÷ Q8 hr IV'),
          DoseLine('High-dose extended-interval (once daily) dosing (limited data): 30–35 '
              'mg/kg/24 hr Q24 hr IV'),
        ],
      ),
      DoseSection(
        heading: 'Nontuberculous mycobacterium (part of a multiple drug regimen):',
        lines: [
          DoseLine('Infant and child: 15–30 mg/kg/dose Q24 hr IV; max. dose: 1500 mg/24 hr'),
          DoseLine('Adolescent: 10–15 mg/kg/dose Q24 hr IV; max. dose: 1500 mg/24 hr'),
          DoseLine('Adult: 15 mg/kg/24 hr ÷ Q8–12 hr IV/IM'),
          DoseLine('Initial max. dose: 1.5 g/24 hr, then monitor levels'),
        ],
      ),
      DoseSection(
        heading: 'Therapeutic Drug Monitoring Goals',
        table: DoseTable(
          headers: ['Dosing Method/Indication', 'Peak Level', 'Trough Level', 'Recommended Serum Sampling Time'],
          rows: [
            DoseTableRow(['Conventional dosing', '20–30 mg/L; 25–30 mg/L for CNS, pulmonary, bone, life-threatening, '
                'Pseudomonas infections and febrile neutropenia', '5–10 mg/L', 'Trough within 30 min before the 3rd consecutive dose and peak 30–60 min '
                'after the administration of the 3rd consecutive dose (at steady state)']),
            DoseTableRow(['High-dose extended interval (Q24 hr) for cystic fibrosis', '80–120 mg/L', '<10 mg/L', 'Trough within 30 min before the 2nd dose and peak 30–60 min after '
                'administration of 2nd dose']),
            DoseTableRow(['Extended interval (Q24 hr) for nontuberculous mycobacterium', '20–40 mg/L', '<10 mg/L', 'Trough within 30 min before the 2nd dose and peak 30–60 min after '
                'administration of 2nd dose']),
          ],
        ),
      ),
    ],
    remarks: [
      'Use with caution in preexisting renal, vestibular, or auditory '
          'impairment; concomitant anesthesia or neuromuscular blockers; concomitant '
          'neurotoxic, ototoxic, or nephrotoxic drugs; sulfite sensitivity; and '
          'dehydration. Adjust dose in renal failure (see Chapter 32).',
      'Longer dosing intervals may be necessary for neonates receiving '
          'indomethacin for PDAs and for all patients with poor cardiac output. '
          'Rapidly eliminated in patients with cystic fibrosis or burns, and in '
          'febrile neutropenic patients. CNS penetration is poor beyond early '
          'infancy.',
      'For initial dosing in obese patients, use an adjusted body weight (ABW). '
          'ABW = ideal body weight + 0.4 (total body weight ∼ ideal body weight).',
      'May cause ototoxicity, nephrotoxicity, neuromuscular blockade, and rash. '
          'Loop diuretics may potentiate the ototoxicity of all aminoglycoside '
          'antibiotics.',
      'A liposomal inhalation product, Arikayce, is currently approved in adults '
          'as part of a multidrug treatment regimen for Mycobacterium avium complex '
          '(MAC) lung disease.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 853–854',
  ),
  // AMINOCAPROIC ACID — PDF p. 45–46 (printed 854–855)
  DrugEntryV3(
    name: 'AMINOCAPROIC ACID',
    brandNames: 'Generics; previously available as Amicar',
    drugClass: 'Hemostatic agent',
    iconRow: '',
    formulations: [
      'Tabs: 500, 1000 mg',
      'Oral liquid/syrup: 250 mg/mL (240 mL); may contain 0.2% methylparaben and '
          '0.05% propylparaben',
      'Injection: 250 mg/mL (20 mL); may contain 0.9% benzyl alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child (IV/PO):',
        lines: [
          DoseLine('Loading dose: 100–200 mg/kg'),
          DoseLine('Maintenance: 50–100 mg/kg/dose Q4–6 hr; max. dose: 24–30 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult (IV/PO):',
        lines: [
          DoseLine('4–5 g during the first hour, followed by 1 g/hr × 8 hr or until bleeding '
              'is controlled. Max. dose: 30 g/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindications: DIC, hematuria. Use with caution in patients with '
          'cardiac or renal disease. Should not be given with factor IX complex '
          'concentrates or anti-inhibitor coagulant concentrates because of risk for '
          'thrombosis. Dose should be reduced by 75% in oliguria or end-stage renal '
          'disease. Hypercoagulation may be produced when given in conjunction with '
          'oral contraceptives.',
      'May cause nausea, diarrhea, malaise, weakness, headache, decreased '
          'platelet function, hypotension, and false increase in urine amino acids. '
          'Elevation of serum potassium may occur, especially in patients with renal '
          'impairment. Prolonged use may increase risk for skeletal muscle weakness '
          'and rhabdomyolysis.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 854–855',
  ),
  // AMINOPHYLLINE — PDF p. 46–47 (printed 855–856)
  DrugEntryV3(
    name: 'AMINOPHYLLINE',
    brandNames: 'Various generics',
    drugClass: 'Bronchodilator, methylxanthine',
    iconRow: '',
    formulations: [
      'Injection: 25 mg/mL (79% theophylline) (10, 20 mL)',
      'Note: Pharmacy may dilute IV dosage forms to enhance accuracy of neonatal '
          'dosing.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonatal apnea:',
        lines: [
          DoseLine('Loading dose: 5–6 mg/kg IV'),
          DoseLine('Maintenance dose: 1–2 mg/kg/dose Q6–8 hr, IV'),
        ],
      ),
      DoseSection(
        heading: 'Asthma exacerbation and reactive airway disease:',
        lines: [
          DoseLine('IV loading: 6 mg/kg IV over 20 min (each 1.2-mg/kg dose raises the serum '
              'theophylline concentration 2 mg/L)'),
          DoseLine(
            'IV maintenance: Continuous IV drip:',
            isHeading: true,
          ),
          DoseLine('Neonate: 0.2 mg/kg/hr'),
          DoseLine('6 wk–6 mo: 0.5 mg/kg/hr'),
          DoseLine('6 mo–1 yr: 0.6–0.7 mg/kg/hr'),
          DoseLine('1–9 yr: 1–1.2 mg/kg/hr'),
          DoseLine('9–12 yr and young adult smoker: 0.9 mg/kg/hr'),
          DoseLine('>12 yr healthy nonsmoker: 0.7 mg/kg/hr'),
          DoseLine('The above total daily doses may also be administered IV ÷ Q4–6 hr.'),
        ],
      ),
    ],
    remarks: [
      'Consider milligrams of theophylline available when dosing aminophylline. '
          'For oral route of administration, use theophylline.',
      'Monitoring serum levels is essential, especially in infants and young '
          'children. Intermittent dosing for infants and children 1–5 yr may require '
          'Q4 hr dosing regimen due to enhanced metabolism/clearance. Side effects: '
          'restlessness, GI upset, headache, tachycardia, seizures (may occur in '
          'absence of other side effects with toxic levels). Dosage reduction and '
          'frequent serum monitoring have been recommended for infants <3 mo with '
          'altered renal function.',
      'Therapeutic level (as theophylline): for asthma, 10–20 mg/L; for neonatal '
          'apnea, 6–13 mg/L',
      'Recommended guidelines for obtaining levels:',
      'IV bolus: 30 min after infusion',
      'IV continuous: 12–24 hr after initiation of infusion',
      'PO liquid, immediate-release tab (theophylline product):',
      'Peak: 1 hr post dose',
      'Trough: just before dose',
      'PO sustained-release (theophylline product):',
      'Peak: 4 hr post dose',
      'Trough: just before dose',
      'Ideally, obtain levels after steady state has been achieved (after at '
          'least 1 day of therapy). Liver impairment, cardiac failure, and sustained '
          'high fever may increase theophylline levels. See Theophylline for drug '
          'interactions.',
      'Use in breastfeeding may cause irritability to infant. It is recommended '
          'to avoid breastfeeding for 2 hr after IV or 4 hr after immediate-release '
          'oral intermittent dose.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 855–856',
  ),
  // AMIODARONE HCL — PDF p. 47–48 (printed 856–857)
  DrugEntryV3(
    name: 'AMIODARONE HCL',
    brandNames: 'Pacerone, Nexterone, and generics',
    drugClass: 'Antiarrhythmic, Class III',
    iconRow: '',
    formulations: [
      'Tabs (Pacerone and generics): 100, 200, 400 mg',
      'Oral suspension: 5 mg/mL',
      'Injection: 50 mg/mL (3, 9, 18 mL) (contains 20.2 mg/mL benzyl alcohol and '
          '100 mg/mL polysorbate 80 or Tween 80)',
      'Premixed injection (Nexterone): 1.5 mg/mL (100 mL) (iso-osmotic solution, '
          'each 1 mL contains 15 mg sulfbutylether β-cyclodextrin [SBECD; see '
          'remarks], 0.362 mg citric acid, 0.183 mg sodium citrate, and 42.1 mg '
          'dextrose), 1.8 mg/mL (200 mL) (iso-osmotic solution, each 1 mL contains '
          '18 mg SBECD, 0.362 mg citric acid, 0.183 mg sodium citrate, and 41.4 mg '
          'dextrose)',
      'Contains 37.3% iodine by weight',
    ],
    doseSections: [
      DoseSection(
        heading: 'See algorithms in front cover of book for arrest dosing.',
      ),
      DoseSection(
        heading: 'Child PO for tachyarrhythmia:',
        lines: [
          DoseLine('<1 yr: 600–800 mg/1.73 m²/24 hr ÷ Q12–24 hr × 4–14 days and/or until '
              'adequate control achieved, then reduce to 200–400 mg/1.73 m²/24 hr'),
          DoseLine('≥1 yr: 10–15 mg/kg/24 hr ÷ Q12–24 hr × 4–14 days and/or until adequate '
              'control achieved, then reduce to 5 mg/kg/24 hr ÷ Q12–24 hr if effective'),
        ],
      ),
      DoseSection(
        heading: 'Child IV for tachyarrhythmia (limited data):',
        lines: [
          DoseLine('5 mg/kg (max. dose: 300 mg) over 30–60 min followed by a continuous '
              'infusion starting at 5 micrograms (mCg)/kg/min; infusion may be increased '
              'up to a max. dose of 15 mCg/kg/min or 20 mg/kg/24 hr or 2200 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult PO for ventricular arrhythmias:',
        lines: [
          DoseLine('Loading dose: 800–1600 mg/24 hr ÷ Q8–12 hr for 1–3 wk'),
          DoseLine('Maintenance: 600–800 mg/24 hr ÷ Q12–24 hr × 1 mo, then 200 mg Q12–24 hr'),
          DoseLine(
            'Use lowest effective dose to minimize adverse reactions.',
            isHeading: true,
          ),
        ],
      ),
      DoseSection(
        heading: 'Adult IV for ventricular arrhythmias:',
        lines: [
          DoseLine('Loading dose: 150 mg over 10 min (15 mg/min) followed by 360 mg over 6 hr '
              '(1 mg/min); followed by a maintenance dose of 0.5 mg/min. Supplemental '
              'boluses of 150 mg over 10 min may be given for breakthrough VF or '
              'hemodynamically unstable VT, and the maintenance infusion may be '
              'increased to suppress the arrhythmia. Max. dose: 2.2 g in the first 24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Used in the resuscitation algorithm for ventricular '
          'fibrillation/pulseless ventricular tachycardia (see front cover for '
          'arrest dosing and back cover for PALS algorithm). Overall use of this '
          'drug may be limited due to its potentially life-threatening side effects '
          'and the difficulties associated with managing its use.',
      'Contraindicated in severe sinus node dysfunction, marked sinus '
          'bradycardia, and second-and third-degree AV block. Use with caution in '
          'hepatic impairment.',
      'Long elimination half-life (IV single dose: 9–36 days, chronic oral '
          'dosing: 40–55 days). Major metabolite N-desethylamiodarone is active with '
          'a long half-life (IV single dose: 9–30 days; chronic oral dosing: 61 '
          'days). Use of premixed injection (Nexterone) is not recommended in renal '
          'insufficiency due to accumulation of cyclodextrin excipient.',
      'Increases cyclosporine, digoxin, phenytoin, tacrolimus, warfarin, calcium '
          'channel blockers, theophylline, and quinidine levels. Amiodarone is a '
          'cytochrome P450 (CYP) 3A3/4 substrate and inhibits CYP3A3/4, 2C9, and '
          '2D6. Risk of rhabdomyolysis is increased when used with simvastatin at '
          'doses greater than 20 mg/24 hr and lovastatin at doses greater than 40 '
          'mg/24 hr. Serious symptomatic bradycardia has been reported when used '
          'with sofosbuvir.',
      'Proposed therapeutic level with chronic oral use: 1–2.5 mg/L.',
      'Asymptomatic corneal microdeposits should appear in all patients. Alters '
          'liver enzymes, thyroid function. Pulmonary fibrosis reported in adults. '
          'May cause worsening of preexisting arrhythmias with bradycardia and AV '
          'block. May also cause hypotension, anorexia, nausea, vomiting, dizziness, '
          'paresthesias, ataxia, tremor, SIADH, and hypothyroidism or '
          'hyperthyroidism. Drug rash with eosinophilia and systemic symptoms '
          '(DRESS), acute respiratory distress syndrome, and anaphylactic reactions '
          'have been reported. IV administration at much higher concentrations and '
          'rates of infusion has been reported to increase the risk for hepatic '
          'injury.',
      'Correct hypokalemia, hypocalcemia, or hypomagnesemia whenever possible '
          'before use as these conditions may exaggerate QTc prolongation.',
      'Intravenous continuous infusion concentration for peripheral '
          'administration should not exceed 2 mg/mL (minimizes the risk for '
          'phlebitis) and must be diluted with D₅W. The intravenous dosage form can '
          'leach out plasticizers such as DEHP. It is recommended to reduce the '
          'potential exposure to plasticizers in pregnant women and children at the '
          'toddler stages of development and younger by using alternative methods of '
          'IV drug administration.',
      'Oral administration should be consistent with regard to meals because '
          'food increases the rate and extent of oral absorption.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 856–857',
  ),
  // AMITRIPTYLINE — PDF p. 48–50 (printed 857–859)
  DrugEntryV3(
    name: 'AMITRIPTYLINE',
    brandNames: 'Generics; previously available as Elavil',
    drugClass: 'Antidepressant, tricyclic (TCA)',
    iconRow: '',
    formulations: [
      'Tabs: 10, 25, 50, 75, 100, 150 mg',
      'Oral syrup: 1 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'See remarks for genomic considerations.',
      ),
      DoseSection(
        heading: 'Antidepressant:',
        lines: [
          DoseLine('Child (9–12 yr): Start with 1 mg/kg/24 hr ÷ TID PO for 3 days; then '
              'increase to 1.5 mg/kg/24 hr ÷ TID. Dose may be gradually increased to a '
              'max. dose of 5 mg/kg/24 hr if needed. Monitor ECG, BP, and heart rate '
              '(HR) for doses >3 mg/kg/24 hr.'),
          DoseLine('Adolescent (12–18 yr): 10 mg TID PO and 20 mg QHS PO; dose may be '
              'gradually increased up to a max. dose of 200 mg/24 hr if needed.'),
          DoseLine('Adult: 40–100 mg/24 hr ÷ QHS–BID PO; dose may be gradually increased up '
              'to 300 mg/24 hr if needed; gradually decrease dose to lowest effective '
              'dose when symptoms are controlled.'),
        ],
      ),
      DoseSection(
        heading: 'Augment analgesia for chronic pain (limited data):',
        lines: [
          DoseLine('Child: Initial: 0.1 mg/kg/dose QHS PO; increase as needed and tolerated '
              'over 2–3 wk to 0.5–2 mg/kg/dose QHS.'),
        ],
      ),
      DoseSection(
        heading: 'Migraine prophylaxis (limited data):',
        lines: [
          DoseLine('Child (≥8 yr): Start at 0.25 mg/kg/dose QHS PO; increase as needed and '
              'tolerated every 2 wk by 0.25 mg/kg/dose to 1 mg/kg/24 hr. Maximum dose: '
              '100 mg/24 hr. If dosage exceeds 1 mg/kg/24 hr, divide daily dose BID and '
              'monitor ECG.'),
          DoseLine('Adult: Initial 10–25 mg/dose QHS PO; increase dose as needed and '
              'tolerated in 10–25 mg/dose increments (at intervals ≥1 wk) up to 150 '
              'mg/24 hr.'),
        ],
      ),
      DoseSection(
        heading: 'Pharmacogenomic Dosing Considerations for CYP2D6 and CYP2C19 '
            'Phenotypes',
        table: DoseTable(
          headers: ['Phenotype', 'CYP2D6 Ultra-rapid Metabolizer', 'CYP2D6 Normal Metabolizer', 'CYP2D6 Intermediate Metabolizer', 'CYP2D6 Poor Metabolizer'],
          rows: [
            DoseTableRow(['CYP2C19 Ultra-rapid or Rapid Metabolizer', 'Avoid use; use alternative therapy', 'Consider alternative therapy not metabolized by CYP2C19', 'Consider alternative therapy not metabolized by CYP2C19', 'Avoid use; use alternative therapy']),
            DoseTableRow(['CYP2C19 Normal Metabolizer', 'Avoid use but if use necessary, titrate to higher target dose', 'Use recommended initial dose', 'Consider a 25% initial dose reduction', 'Avoid use but if use necessary, consider 50% initial dose reduction']),
            DoseTableRow(['CYP2C19 Intermediate Metabolizer', 'Avoid use; use alternative therapy', 'Use recommended initial dose', 'Consider a 25% initial dose reduction', 'Avoid use but if use necessary, consider 50% initial dose reduction']),
            DoseTableRow(['CYP2C19 Poor Metabolizer', 'Avoid use; use alternative therapy', 'Avoid use but if use necessary, consider 50% initial dose reduction', 'Avoid use; use alternative therapy', 'Avoid use; use alternative therapy']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('Clinical Pharmacology and Therapeutics 2016;102(1):37–44.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in narrow-angle glaucoma, seizures, severe cardiac '
          'disorders, and patients who received MAO inhibitors within 14 days. See '
          'Chapter 3 for management of TCA toxic ingestion.',
      'T₁/₂ = 9–25 hr in adults. Maximum antidepressant effects may not occur '
          'for 2 wk or more after initiation of therapy. Do not abruptly discontinue '
          'therapy in patients receiving high doses for prolonged periods.',
      'Therapeutic levels (sum of amitriptyline and nortriptyline): 100–250 '
          'ng/mL. Recommended serum sampling time: obtain a single level 8 hr or '
          'more after an oral dose (following 4–5 days of continuous dosing). '
          'Amitriptyline is a substrate for cytochrome P450 (CYP) 1A2, 2C9, 2C19, '
          '2D6, and 3A3/4 and inhibitor for CYP1A2, 2C19, 2C9, 2D6, and 2E1. '
          'Rifampin can decrease amitriptyline levels. Amitriptyline may increase '
          'side effects of tramadol.',
      'Side effects include sedation, urinary retention, constipation, dry '
          'mouth, dizziness, drowsiness, liver enzyme elevation, and arrhythmia. May '
          'discolor urine (blue/green). QHS dosing during first weeks of therapy '
          'will reduce sedation. Monitor ECG, BP, CBC at start of therapy and with '
          'dose changes. Decrease dose if PR interval reaches 0.22 sec, QRS reaches '
          '130% of baseline, HR rises greater than 140/min, or BP is >140/90. '
          'Tricyclics may cause mania. For antidepressant use, monitor for clinical '
          'worsening of depression and suicidal ideation/behavior following the '
          'initiation of therapy or after dosage changes.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 857–859',
  ),
  // AMLODIPINE — PDF p. 50 (printed 859)
  DrugEntryV3(
    name: 'AMLODIPINE',
    brandNames: 'Norvasc, Norliqva, Katerzia, and generics',
    drugClass: 'Calcium channel blocker, antihypertensive',
    iconRow: '',
    formulations: [
      'Tabs: 2.5, 5, 10 mg',
      'Oral solution (Norliqva): 1 mg/mL (150 mL); contains 4 mL alcohol per 100 '
          'mL total volume',
      'Oral suspension: 1 mg/mL',
      'Katerzia: 1 mg/mL (150 mL); contains polysorbate 80 and sodium benzoate',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hypertension:',
        lines: [
          DoseLine(
            'Child (see remarks):',
            isHeading: true,
          ),
          DoseLine('<6 yr (limited data): Start with 0.1 mg/kg/dose (max. dose: 5 mg) PO once '
              'daily–BID; dosage may be gradually increased to a max. dose of 0.6 '
              'mg/kg/24 hr up to 5 mg/24 hr.'),
          DoseLine('≥6–17 yr: Start with 2.5 mg PO once daily; dosage may be gradually '
              'increased to a max. dose of 10 mg/24 hr.'),
          DoseLine('Adult: Start with 2.5–5 mg/dose PO once daily; dosage may be gradually '
              'increased to a max. dose of 10 mg/24 hr. Use an initial dose of 2.5 '
              'mg/dose once daily PO for patients with hepatic insufficiency.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in combination with other antihypertensive agents. '
          'Younger children (<6 yr) may require higher mg/kg doses than older '
          'children and adults. A BID dosing regimen may provide better efficacy in '
          'children.',
      'Reduce dose in hepatic insufficiency. Allow 5–7 days of continuous '
          'initial dose therapy before making dosage adjustments because of the '
          'drug’s gradual onset of action and lengthy elimination half-life. '
          'Amlodipine is a substrate for cytochrome P450 (CYP) 3A4 and should be '
          'used with caution with CYP3A4 inhibitors such as protease inhibitors and '
          'azole antifungals (e.g., fluconazole and ketoconazole). May increase '
          'levels and toxicity of cyclosporine, tacrolimus, and simvastatin.',
      'Dose-related side effects include edema, dizziness, flushing, fatigue, '
          'and palpitations. Other side effects include headache, nausea, abdominal '
          'pain, and somnolence.',
      'Limited data report that amlodipine is present in breast milk at low '
          'levels and is undetectable in infant plasma, with no adverse effects to '
          'breastfed infants.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 859',
  ),
  // AMMONUL — PDF p. 50 (printed 859)  [cross-reference]
  DrugEntryV3(
    name: 'AMMONUL',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Sodium Phenylacetate + Sodium Benzoate',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 859',
  ),
  // AMOXICILLIN — PDF p. 51 (printed 860)
  DrugEntryV3(
    name: 'AMOXICILLIN',
    brandNames: 'Various generics; previously available as Amoxil and Trimox',
    drugClass: 'Antibiotic, aminopenicillin',
    iconRow: '',
    formulations: [
      'Oral suspension: 125, 250 mg/5 mL (80, 100, 150 mL); and 200, 400 mg/5 mL '
          '(50, 75, 100 mL)',
      'Caps: 250, 500 mg',
      'Tablets: 500, 875 mg',
      'Chewable tabs: 125, 250 mg; may contain phenylalanine',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate – ≤3 mo:',
        lines: [
          DoseLine('Standard dose: 20–30 mg/kg/24 hr ÷ Q12 hr PO'),
        ],
      ),
      DoseSection(
        heading: 'Child ≥3 mo and adolescent:',
        lines: [
          DoseLine('Standard dose: 25–50 mg/kg/24 hr ÷ Q8–12 hr PO'),
          DoseLine('High dose (acute otitis media, community-acquired pneumonia, resistant '
              'Streptococcus pneumoniae; see remarks): 80–90 mg/kg/24 hr ÷ Q8–12 hr PO; '
              'the Q8 hr dosage interval is used to optimize the drug concentration time '
              'over the MIC to enhance pharmacodynamics.'),
          DoseLine('Max. dose: 2–3 g/24 hr; some experts recommend a maximum dosage up to 4 '
              'g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Mild/moderate infections: 250 mg/dose Q8 hr PO OR 500 mg/dose Q12 hr PO'),
          DoseLine('Severe infections: 500 mg/dose Q8 hr PO OR 875 mg/dose Q12 hr PO'),
          DoseLine('Max. dose: 2–3 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Tonsillitis/pharyngitis (Streptococcus pyogenes):',
        lines: [
          DoseLine('Child and adolescent: 50 mg/kg/24 hr ÷ Q12 hr PO × 10 days; max. dose: 1 '
              'g/24 hr'),
          DoseLine('Adult: 500 mg Q12 hr PO x 10 days'),
        ],
      ),
      DoseSection(
        heading: 'SBE prophylaxis:',
        lines: [
          DoseLine('Administer dose 30–60 min before procedure.'),
          DoseLine('Child: 50 mg/kg PO × 1; max. 2 g/dose'),
          DoseLine('Adult: 2 g PO × 1'),
        ],
      ),
      DoseSection(
        heading: 'Early Lyme disease:',
        lines: [
          DoseLine('Child: 50 mg/kg/24 hr ÷ Q8 hr PO × 14–21 days; max. dose: 1.5 g/24 hr'),
          DoseLine('Adult: 500 mg/dose Q8 hr PO × 14–21 days'),
        ],
      ),
    ],
    remarks: [
      'Renal elimination. Adjust dose in renal failure (see Chapter 32). Serum '
          'levels about twice those achieved with equal dose of ampicillin. Fewer GI '
          'effects, but otherwise similar to ampicillin. Side effects: rash and '
          'diarrhea. Rash may develop with concurrent EBV infection. Drug-induced '
          'enterocolitis syndrome and severe cutaneous reactions have been reported. '
          'May increase warfarin’s effect by increasing INR.',
      'High-dose regimen is recommended in respiratory infections (e.g., CAP), '
          'acute otitis media, and sinusitis, owing to increasing incidence of '
          'penicillin-resistant pneumococci. Chewable tablets may contain '
          'phenylalanine and should not be used by patients with phenylketonuria.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 860',
  ),
  // AMOXICILLIN-CLAVULANIC ACID — PDF p. 51–53 (printed 860–862)
  DrugEntryV3(
    name: 'AMOXICILLIN-CLAVULANIC ACID',
    brandNames: 'Augmentin, Augmentin ES-600, and generics; previously available as '
        'Augmentin XR',
    drugClass: 'Antibiotic, aminopenicillin with β-lactamase inhibitor',
    iconRow: '',
    formulations: [
      'Tabs:',
      'For TID dosing: 250, 500 mg amoxicillin (with 125 mg clavulanate)',
      'For BID dosing: 875 mg amoxicillin (with 125 mg clavulanate)',
      'Extended-release tabs (previously available as Augmentin XR): 1 g '
          'amoxicillin (with 62.5 mg clavulanate)',
      'Chewable tabs:',
      'For BID dosing (7:1 amoxicillin:clavulanate): 400 mg amoxicillin (57 mg '
          'clavulanate); contains saccharin and aspartame',
      'Oral suspension:',
      'For TID dosing (4:1 amoxicillin:clavulanate): 125 mg amoxicillin/5 mL '
          '(31.25 mg clavulanate/5 mL) (75, 100, 150 mL); contains saccharin',
      'For BID dosing:',
      '7:1 amoxicillin:clavulanate: 200, 400 mg amoxicillin/5 mL (28.5 and 57 mg '
          'clavulanate/5 mL, respectively) (50, 75, 100 mL)',
      '14:1 amoxicillin:clavulanate (Augmentin ES-600 and generics): 600 mg '
          'amoxicillin/5 mL (42.9 mg clavulanate/5 mL) (75, 125, 200 mL); contains '
          'saccharin and/or aspartame',
      'Contains 0.63 mEq K⁺ per 125 mg clavulanate (Augmentin ES-600 contains '
          '0.23 mEq K⁺ per 42.9 mg clavulanate)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Dosage based on amoxicillin component (see remarks for resistant '
            'Streptococcus pneumoniae).',
      ),
      DoseSection(
        heading: 'Infant 1–<3 mo:',
        lines: [
          DoseLine('30 mg/kg/24 hr ÷ Q12 hr PO (recommended dosage form is 125 mg/5 mL '
              'suspension)'),
        ],
      ),
      DoseSection(
        heading: 'Child ≥3 mo:',
        lines: [
          DoseLine(
            'Standard (non-high) dose amoxicillin regimens:',
            isHeading: true,
          ),
          DoseLine(
            '<40 kg:',
            isHeading: true,
          ),
          DoseLine('TID dosing (see remarks): 20–40 mg/kg/24 hr ÷ Q8 hr PO'),
          DoseLine('BID dosing (see remarks): 25–45 mg/kg/24 hr ÷ Q12 hr PO'),
          DoseLine('≥40 kg: Use adult dosage.'),
          DoseLine(
            'High-dose amoxicillin regimens:',
            isHeading: true,
          ),
          DoseLine('≥3 mo and <40 kg (use 14:1 amoxicillin:clavulanate dosage form, Augmentin '
              'ES-600, or generic oral suspension): 90 mg/kg/24 hr ÷ Q8–12 hr PO; Q8 hr '
              'recommended for CAP, orbital cellulitis, and severe infections'),
          DoseLine('≥40 kg: Use adult dosage.'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('250–500 mg/dose Q8 hr PO or 875 mg/dose Q12 hr PO for more severe and '
              'respiratory infections'),
        ],
      ),
      DoseSection(
        heading: 'Extended-release tablet:',
        lines: [
          DoseLine('≥16 yr and adult (≥40 kg): 2 g Q12 hr PO × 10 days for acute bacterial '
              'sinusitis, 7–10 days for community-acquired pneumonia, or 5–10 days for '
              'acute otitis media'),
        ],
      ),
    ],
    remarks: [
      'See Amoxicillin for additional comments. Adjust dose in renal failure '
          '(see Chapter 32). Contraindicated in patients with a history of '
          'cholestatic jaundice/hepatic dysfunction associated with '
          'amoxicillin–clavulanic acid. Extended-release tablet dosage form is '
          'contraindicated in patients with CrCl <30 mL/min.',
      'Clavulanic acid extends the activity of amoxicillin to include '
          'β-lactamase–producing strains of Haemophilus influenzae, Moraxella '
          'catarrhalis, Neisseria gonorrhoeae, and some Staphylococcus aureus and '
          'increases the risk for diarrhea.',
      'The BID dosing schedule is associated with less diarrhea. For BID dosing, '
          'the 875-mg and 1-g tablets, the 400-mg chewable tablet, or the 200 mg/5 '
          'mL, 400 mg/5 mL, and 600 mg/5 mL suspensions should be used. These BID '
          'dosage forms contain phenylalanine and should not be used by patients '
          'with phenylketonuria. For TID dosing, the 250-mg and 500-mg tablets or '
          'the 125 mg/5 mL suspension should be used.',
      'Higher doses of 80–90 mg/kg/24 hr (amoxicillin component) have been '
          'recommended for resistant strains of S. pneumoniae in acute otitis media '
          'and pneumonia (use BID formulations containing 7:1 or 14:1 ratio of '
          'amoxicillin to clavulanic acid or Augmentin ES-600, respectively).',
      'The 250-mg or 500-mg tablets cannot be substituted for Augmentin XR '
          'tablets.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 860–862',
  ),
  // AMPHETAMINE — PDF p. 53–54 (printed 862–863)
  DrugEntryV3(
    name: 'AMPHETAMINE',
    brandNames: 'Evekeo, Adzenys XR-ODT, Dyanavel XR, and generics',
    drugClass: 'CNS stimulant',
    iconRow: '',
    formulations: [
      'Tabs, immediate release:',
      'Evekeo and generics: 5, 10 mg; both tablets are scored',
      'Extended-release tabs:',
      'Dyanavel XR: 5, 10, 15, 20 mg',
      'Extended-release dispersible tabs:',
      'Adzenys XR-ODT: 3.1, 6.3, 9.4, 12.5, 15.7, 18.8 mg',
      'Extended-release oral suspension:',
      'Dyanavel XR: 2.5 mg/mL (464 mL); contains parabens and polysorbate 80',
      'DO NOT substitute extended-release formulations for other amphetamine '
          'products on a milligram-per-milligram basis due to differences in potency '
          'and pharmacokinetic profiles. If converting from other amphetamine '
          'products, discontinue that treatment first and titrate new dosage form as '
          'indicated in the drug dosage section.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Attention-deficit/hyperactivity disorder:',
        lines: [
          DoseLine(
            'Immediate-release tabs (Evekeo and generics; PO):',
            isHeading: true,
          ),
          DoseLine('3–5 yr: 2.5 mg/24 hr QAM; increase by 2.5 mg/24 hr at weekly intervals '
              'until desired response. Incremental dosages may be administered BID–TID '
              'with the first dose at awakening and subsequent doses spaced at 4–6 hr '
              'intervals. Doses rarely exceed 40 mg/24 hr.'),
          DoseLine('≥6 yr and adolescent: 5 mg once daily or BID; increase by 5 mg/24 hr at '
              'weekly intervals until desired response. Incremental dosages may be '
              'administered BID–TID with the first dose at awakening and subsequent '
              'doses spaced at 4–6 hr intervals. Doses rarely exceed 40 mg/24 hr.'),
          DoseLine(
            'Extended-release suspension or extended-release tabs (Dyanavel XR; PO):',
            isHeading: true,
          ),
          DoseLine('≥6 yr and adolescent: Start at 2.5 or 5 mg/24 hr QAM; increase by 2.5–10 '
              'mg/24 hr every 4–7 days until desired response up to a maximum dose of 20 '
              'mg/24 hr.'),
          DoseLine(
            'Extended-release dispersible tabs (see how-supplied section, earlier; '
                'Adzenys XR-ODT; PO):',
            isHeading: true,
          ),
          DoseLine('6–17 yr: 6.3 mg/24 hr QAM; increase by 3.1 or 6.3 mg/24 hr at weekly '
              'intervals until desired response. Max. dose: 6–12 yr: 18.8 mg/24 hr; '
              '13–18 yr: 12.5 mg/24 hr.'),
          DoseLine('Adult:12.5 mg/24 hr QAM.'),
          DoseLine('If converting from Adderall XR, see dosage equivalent information in '
              'Adzenys XR-ODT product information.'),
        ],
      ),
      DoseSection(
        heading: 'Narcolepsy:',
        lines: [
          DoseLine(
            'Immediate-release tabs (Evekeo and generics; PO):',
            isHeading: true,
          ),
          DoseLine('6–12 yr: 5 mg QAM; increase by 5 mg/24 hr at weekly intervals until '
              'desired response. Incremental doses may be administered with the first '
              'dose at awakening and subsequent doses (5 or 10 mg) spaced at 4–6 hr '
              'intervals. Usual daily dosage range: 5–60 mg/24 hr in divided doses.'),
          DoseLine('≥13 yr and adult: 10 mg QAM; increase by 10 mg/24 hr at weekly intervals '
              'until desired response. Incremental doses may be administered with the '
              'first dose at awakening and subsequent doses (5 or 10 mg) spaced at 4–6 '
              'hr intervals. Usual daily dosage range: 5–60 mg/24 hr in divided doses.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in presence of hypertension, cardiovascular disease, and '
          'risk for abuse or addiction. Avoid use in known serious structural '
          'cardiac abnormalities, cardiomyopathy, serious heart rhythm '
          'abnormalities, coronary artery disease, or other serious cardiac problems '
          'that may increase risk of sympathomimetic effects of amphetamines (sudden '
          'death, stroke, and MI have been reported). Contraindicated with MAO '
          'inhibitors, including linezolid and IV methylene blue, as a hypertensive '
          'crisis may occur if used within 14 days of discontinuance of MAO '
          'inhibitor. Serotonin syndrome may occur when used in combination with MAO '
          'inhibitors, SSRIs, serotonin/norepinephrine reuptake inhibitors (SNRIs), '
          'triptans, TCAs, fentanyl, lithium, tramadol, tryptophan, buspirone, and '
          'St. John’s wort.',
      'Amphetamine is a minor substrate of cytochrome P450 2D6. Alkalinizing '
          'agents should be avoided as they can increase the effects/toxicity of '
          'amphetamine by decreasing its secretion.',
      'Not recommended for patients <3 yr of age. Medication should generally '
          'not be used in children <5 yr, because diagnosis of ADHD in this age '
          'group is extremely difficult (use in consultation with a specialist). '
          'Interrupt administration occasionally to determine need for continued '
          'therapy.',
      'Common side effects include headache, insomnia, anorexia (monitor '
          'growth), abdominal pain, anxiety, mood swings, and agitation. Psychotic '
          'disorder, peripheral vascular disease (including Raynaud phenomenon), '
          'intestinal ischemia, and cerebrovascular accident have been reported.',
      'Evekeo has an additional labeled indication for the treatment of '
          'exogenous obesity in children ≥12 yr and adults. Doses may be '
          'administered with or without food. Do not crush or chew the '
          'extended-release dispersible tabs (Adzenys XR-ODT). Shake oral suspension '
          'bottle (Dyanavel XR) well before dispensing and administering each dose.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 862–863',
  ),
  // AMPHOTERICIN B DEOXYCHOLATE (CONVENTIONAL) — PDF p. 54–55 (printed 863–864)
  DrugEntryV3(
    name: 'AMPHOTERICIN B DEOXYCHOLATE (CONVENTIONAL)',
    brandNames: 'Various generics; previously available as Fungizone',
    drugClass: 'Antifungal, polyene',
    iconRow: '',
    formulations: [
      'Injection: 50-mg vials',
    ],
    doseSections: [
      DoseSection(
        heading: 'IV:',
        lines: [
          DoseLine('Mix with D₅W to concentration 0.1 mg/mL (peripheral administration) or '
              '0.25 mg/mL (central line only). pH >4.2. Infuse over 2–6 hr.'),
        ],
      ),
      DoseSection(
        heading: 'Optional test dose:',
        lines: [
          DoseLine('0.1 mg/kg/dose IV up to max. dose of 1 mg (followed by remaining initial '
              'dose).'),
        ],
      ),
      DoseSection(
        heading: 'Initial dose:',
        lines: [
          DoseLine('0.5–1 mg/kg/24 hr; if test dose NOT used, infuse first dose over 6 hr and '
              'monitor frequently during the first several hours.'),
        ],
      ),
      DoseSection(
        heading: 'Increment:',
        lines: [
          DoseLine('Increase as tolerated by 0.25–0.5 mg/kg/24 hr once daily or every other '
              'day. Use larger dosage increment (0.5 mg once daily) for critically ill '
              'patients.'),
        ],
      ),
      DoseSection(
        heading: 'Usual maintenance:',
        lines: [
          DoseLine('Once-daily dosing: 0.5–1 mg/kg/24 hr once daily'),
          DoseLine('Every-other-day dosing: 1.5 mg/kg/dose every other day'),
        ],
      ),
      DoseSection(
        heading: 'Max. dose:',
        lines: [
          DoseLine('1.5 mg/kg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Intrathecal (limited data):',
        lines: [
          DoseLine('25–100 mCg Q48–72 hr. Increase to 500 mCg as tolerated. Dosages as high '
              'as 1500 mCg have been recommended.'),
        ],
      ),
      DoseSection(
        heading: 'Bladder irrigation for urinary tract mycosis (limited data):',
        lines: [
          DoseLine('5–15 mg in 100 mL sterile water for irrigation at 100–300 mL/24 hr. '
              'Instill solution into bladder, clamp catheter for 1–2 hr, then drain; '
              'repeat TID–QID for 2–5 days.'),
        ],
      ),
    ],
    remarks: [
      'Monitor renal, hepatic, electrolyte, and hematologic status closely. '
          'Hypercalciuria, hypokalemia, hypomagnesemia, RTA, renal failure, acute '
          'hepatic failure, hypotension, and phlebitis may occur. For dosing '
          'information in renal failure, see Chapter 32.',
      'Common infusion-related reactions include fever, chills, headache, '
          'hypotension, nausea, and vomiting; may premedicate with acetaminophen and '
          'diphenhydramine 30 min before and 4 hr after infusion. Meperidine is '
          'useful for chills. Hydrocortisone, 1 mg/mg ampho (max.: 25 mg), added to '
          'bottle may help to prevent immediate adverse reactions. Use total body '
          'weight for obese patients when calculating dosages.',
      'Salt loading with 10–15 mL/kg of NS infused prior to each dose may '
          'minimize the risk of nephrotoxicity. Maintaining sodium intake of >4 '
          'mEq/kg/24 hr in premature neonates may also reduce risk for '
          'nephrotoxicity. Nephrotoxic drugs such as aminoglycosides, '
          'chemotherapeutic agents, and cyclosporine may result in synergistic '
          'toxicity. Hypokalemia may increase the toxicity of neuromuscular blocking '
          'agents and cardiac glycosides.',
      'Although there are no breastfeeding data for amphotericin, many experts '
          'believe it is compatible since the drug is highly protein bound, has a '
          'large molecular weight, and is not absorbed orally.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 863–864',
  ),
  // AMPHOTERICIN B LIPID COMPLEX — PDF p. 55–56 (printed 864–865)
  DrugEntryV3(
    name: 'AMPHOTERICIN B LIPID COMPLEX',
    brandNames: 'Abelcet, ABLC',
    drugClass: 'Antifungal, polyene',
    iconRow: '',
    formulations: [
      'Injection: 5 mg/mL (20 mL); preservative free',
      '(Formulated as a 1:1 molar ratio of amphotericin B to lipid complex '
          'composed of dimyristoylphosphatidylcholine and '
          'dimyristoylphosphatidylglycerol)',
    ],
    doseSections: [
      DoseSection(
        heading: 'IV:',
        lines: [
          DoseLine('5 mg/kg/24 hr once daily'),
        ],
      ),
      DoseSection(
        heading: 'Candidiasis:',
        lines: [
          DoseLine('IV: 3–5 mg/kg/24 hr once daily'),
        ],
      ),
      DoseSection(
        heading: 'Cryptococcal meningitis:',
        lines: [
          DoseLine('IV: 5 mg/kg/24 hr once daily; use in combination with flucytosine or '
              'fluconazole for HIV'),
          DoseLine('Mix with D₅W to concentration 1 or 2 mg/mL for fluid-restricted patients.'),
        ],
      ),
      DoseSection(
        heading: 'Infusion rate:',
        lines: [
          DoseLine('2.5 mg/kg/hr; shake the infusion bag every 2 hr if total infusion time '
              'exceeds 2 hr. Do not use an in-line filter.'),
        ],
      ),
    ],
    remarks: [
      'Monitor renal, hepatic, electrolyte, and hematologic status closely. '
          'Thrombocytopenia, anemia, leukopenia, hypokalemia, hypomagnesemia, '
          'diarrhea, respiratory failure, skin rash, nephrotoxicity, and increases '
          'in liver enzymes and bilirubin may occur. See Conventional Amphotericin B '
          'for drug interactions.',
      'Highest concentrations achieved in spleen, lung, and liver based on human '
          'autopsy data from one heart transplant patient. CNS/CSF levels are lower '
          'than amphotericin B, liposomal (AmBisome). In animal models, '
          'concentrations are higher in the liver, spleen, and lungs but the same in '
          'the kidneys when compared with conventional amphotericin B. '
          'Pharmacokinetics in renal and hepatic impairment have not been studied.',
      'Common infusion-related reactions include fever, chills, rigors, nausea, '
          'vomiting, hypotension, and headache; may premedicate with acetaminophen, '
          'diphenhydramine, and meperidine (see Conventional Amphotericin B remarks).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 864–865',
  ),
  // AMPHOTERICIN B, LIPOSOMAL — PDF p. 56 (printed 865)
  DrugEntryV3(
    name: 'AMPHOTERICIN B, LIPOSOMAL',
    brandNames: 'AmBisome and generics',
    drugClass: 'Antifungal, polyene',
    iconRow: '',
    formulations: [
      'Injection: 50 mg (vials); contains soy, 900 mg sucrose',
      '(Formulated in liposomes composed of hydrogenated soy '
          'phosphatidylcholine, cholesterol, distearoylphosphatidylglycerol, and '
          'α-tocopherol)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Systemic fungal infections:',
        lines: [
          DoseLine('3–5 mg/kg/24 hr IV once daily; an upper dosage limit of 10 mg/kg/24 hr '
              'has been suggested based on pharmacokinetic endpoints and risk for '
              'hypokalemia. However, dosages as high as 15 mg/kg/24 hr have been used. '
              'Dosages as high as 10 mg/kg/24 hr have been used in patients with '
              'Aspergillus.'),
        ],
      ),
      DoseSection(
        heading: 'Empiric therapy for febrile neutropenia:',
        lines: [
          DoseLine('3 mg/kg/24 hr IV once daily'),
        ],
      ),
      DoseSection(
        heading: 'Cryptococcal meningitis in HIV:',
        lines: [
          DoseLine('6 mg/kg/24 hr IV once daily'),
        ],
      ),
      DoseSection(
        heading: 'Leishmaniasis (a repeat course may be necessary if infection does not '
            'clear):',
        lines: [
          DoseLine('Immunocompetent: 3 mg/kg/24 hr IV on days 1 to 5, 14, and 21'),
          DoseLine('Immunocompromised: 4 mg/kg/24 hr IV on days 1 to 5, 10, 17, 24, 31, and 38'),
          DoseLine('Mix with D₅W to concentration 1–2 mg/mL (0.2–0.5 mg/mL may be used for '
              'infants and small children).'),
        ],
      ),
      DoseSection(
        heading: 'Infusion rate:',
        lines: [
          DoseLine('Administer dose over 2 hr; infusion may be reduced to 1 hr if well '
              'tolerated. A ≥1-micron inline filter may be used.'),
        ],
      ),
    ],
    remarks: [
      'Closely monitor renal, hepatic, electrolyte, and hematologic status. '
          'Thrombocytopenia, anemia, leukopenia, tachycardia, hypokalemia, '
          'hypomagnesemia, hypocalcemia, hyperglycemia, diarrhea, dyspnea, skin '
          'rash, low back pain, nephrotoxicity, and increases in liver enzymes and '
          'bilirubin may occur. Rhabdomyolysis has been reported. Safety and '
          'effectiveness in neonates have not been established as lipid-based '
          'formulations may have reduced tissue penetration as compared with '
          'conventional formulations in neonates. See Conventional Amphotericin B '
          'for drug interactions.',
      'Compared with conventional amphotericin B, higher concentrations are '
          'found in the liver and spleen, and similar concentrations are found in '
          'the lungs and kidneys. CNS/CSF concentrations are higher than other '
          'amphotericin B products. Pharmacokinetics in renal and hepatic impairment '
          'have not been studied.',
      'Common infusion-related reactions include fever, chills, rigors, nausea, '
          'vomiting, hypotension, and headache; may premedicate with acetaminophen, '
          'diphenhydramine, and meperidine (see Conventional Amphotericin B remarks).',
      'False elevations of serum phosphate have been reported with the PHOSm '
          'assay (used in Beckman Coulter analyzers).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 865',
  ),
  // AMPICILLIN — PDF p. 57 (printed 866)
  DrugEntryV3(
    name: 'AMPICILLIN',
    brandNames: 'Many generics',
    drugClass: 'Antibiotic, aminopenicillin',
    iconRow: '',
    formulations: [
      'Caps: 500 mg',
      'Injection: 125, 250, 500 mg; 1, 2, 10 g',
      'Contains 3 mEq Na/1 g IV drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate (IM/IV):',
        lines: [
          DoseLine(
            '≤34 wk gestation:',
            isHeading: true,
          ),
          DoseLine('Postnatal age ≤7 days old: 100 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine('Postnatal age 8–<28 days old: 150 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine(
            '>34 wk gestation:',
            isHeading: true,
          ),
          DoseLine('Postnatal age ≤28 days old: 150 mg/kg/24 hr ÷ Q8 hr'),
          DoseLine(
            'Group B streptococcal meningitis (independent of gestational age):',
            isHeading: true,
          ),
          DoseLine('Postnatal age ≤7 days old: 300 mg/kg/24 hr ÷ Q8 hr'),
          DoseLine('Postnatal age 8–<28 days old: 300 mg/kg/24 hr ÷ Q6 hr'),
        ],
      ),
      DoseSection(
        heading: 'Infant/child (see remarks):',
        lines: [
          DoseLine(
            'Mild-moderate infections:',
            isHeading: true,
          ),
          DoseLine('IM/IV: 100–200 mg/kg/24 hr ÷ Q6 hr; max dose: 8 g/24 hr'),
          DoseLine('PO: 50–100 mg/kg/24 hr ÷ Q6 hr; max. PO dose: 2 g/24 hr'),
          DoseLine('Severe infections: 300–400 mg/kg/24 hr ÷ Q4–6 hr IM/IV; max. dose: 12 '
              'g/24 hr'),
          DoseLine(
            'Community-acquired pneumonia in a fully immunized patient (IV/IM):',
            isHeading: true,
          ),
          DoseLine('S. pneumoniae penicillin MIC ≤2.0 or H. influenzae (β-lactamase '
              'negative): 150–200 mg/kg/24 hr ÷ Q6 hr'),
          DoseLine('S. pneumoniae penicillin MIC ≥4.0: 300–400 mg/kg/24 hr ÷ Q6 hr'),
          DoseLine('Max. IV/IM dose: 12 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('IM/IV: 500–3000 mg Q4–6 hr; max. dose: 12 g/24 hr'),
          DoseLine('PO: 250–500 mg Q6 hr'),
        ],
      ),
      DoseSection(
        heading: 'SBE prophylaxis (when PO administration is not feasible):',
        lines: [
          DoseLine(
            'Moderate-risk patients:',
            isHeading: true,
          ),
          DoseLine('Child: 50 mg/kg/dose (max. dose: 2 g/dose) × 1 IV/IM 30 min before '
              'procedure'),
          DoseLine('Adult: 2 g/dose × 1 IV/IM 30 min before procedure'),
          DoseLine('High-risk patients with GU and GI procedures: Aforementioned doses PLUS '
              'gentamicin 1.5 mg/kg × 1 (max. dose: 120 mg) IV within 30 min of starting '
              'procedure, followed by ampicillin 25 mg/kg/dose IV (or PO amoxicillin) × '
              '1, 6 hr later.'),
        ],
      ),
    ],
    remarks: [
      'Use higher doses with shorter dosing intervals to treat CNS disease and '
          'severe infection. CSF penetration occurs only with inflamed meninges. '
          'Adjust dose in renal failure (see Chapter 32).',
      'Produces the same side effects as penicillin, with cross-reactivity. Rash '
          'commonly seen at 5–10 days and rash may occur with concurrent EBV '
          'infection or allopurinol use. May cause interstitial nephritis, diarrhea, '
          'and pseudomembranous enterocolitis. Chloroquine reduces ampicillin’s oral '
          'absorption.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 866',
  ),
  // AMPICILLIN/SULBACTAM — PDF p. 58 (printed 867)
  DrugEntryV3(
    name: 'AMPICILLIN/SULBACTAM',
    brandNames: 'Unasyn and generics',
    drugClass: 'Antibiotic, aminopenicillin with β-lactamase inhibitor',
    iconRow: '',
    formulations: [
      'Injection:',
      '1.5 g = ampicillin 1 g + sulbactam 0.5 g',
      '3 g = ampicillin 2 g + sulbactam 1 g',
      '15 g = ampicillin 10 g + sulbactam 5 g',
      'Contains 5 mEq Na per 1.5 g drug combination',
    ],
    doseSections: [
      DoseSection(
        heading: 'Dosage based on ampicillin component:',
        lines: [
          DoseLine(
            'Neonate:',
            isHeading: true,
          ),
          DoseLine('Premature (based on pharmacokinetic data): 100 mg/kg/24 hr ÷ Q12 hr IM/IV'),
          DoseLine('Full term: 100 mg/kg/24 hr ÷ Q8 hr IM/IV'),
          DoseLine(
            'Infant ≥1 mo and child (see remarks):',
            isHeading: true,
          ),
          DoseLine('Mild/moderate infections: 100–200 mg/kg/24 hr ÷ Q6 hr IM/IV; max. dose: 8 '
              'g ampicillin/24 hr'),
          DoseLine('Meningitis/severe infections: 200–400 mg/kg/24 hr ÷ Q4–6 hr IM/IV; max. '
              'dose: 8 g ampicillin/24 hr'),
          DoseLine('Adult: 1–2 g Q6–8 hr IM/IV; max. dose: 8 g ampicillin/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Spectrum of antibacterial activity similar to that of ampicillin with the '
          'added coverage of β-lactamase–producing organisms. Total sulbactam dose '
          'should not exceed 4 g/24 hr.',
      'Use higher doses with shorter dosing intervals to treat CNS disease and '
          'severe infection. Hepatic dysfunction (e.g., hepatitis and cholestatic '
          'jaundice) and allergic reaction resulting in acute myocardial ischemia '
          'have been reported. Monitor hepatic function in patients with hepatic '
          'impairment.',
      'Adjust dose in renal failure (see Chapter 32). CSF distribution and side '
          'effects similar to those of ampicillin. Postmarketing adverse reactions '
          'reported include abdominal pain, melena, gastritis, stomatitis, '
          'dyspepsia, black hairy tongue, dizziness, dyspnea, TEN, urticaria, and '
          'linear IgA bullous dermatosis.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 867',
  ),
  // ANAKINRA — PDF p. 58–60 (printed 867–869)
  DrugEntryV3(
    name: 'ANAKINRA',
    brandNames: 'Kineret',
    drugClass: 'Interleukin-1 receptor antagonist, disease-modifying antirheumatic '
        'drug (DMARD)',
    iconRow: '',
    formulations: [
      'Injection (pre-filled syringes with 29-gauge needles): 100 mg/0.67 mL '
          '(0.67 mL); contains disodium EDTA, polysorbate 80 (cartons of 7 or 28 '
          'syringes)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Chronic infantile neurological, cutaneous, and articular syndrome; '
            'and deficiency of interleukin-1 receptor antagonist:',
        lines: [
          DoseLine('Infant, child and adolescent: Start at 1–2 mg/kg/24 hr SQ once daily. May '
              'increase dose by increments of 0.5–1 mg/kg/24 hr as needed up to a '
              'maximum of 8 mg/kg/24 hr. Once-daily SQ administration is preferred, but '
              'the daily dose may be divided BID for the treatment of chronic infantile '
              'neurological, cutaneous, and articular syndrome.'),
        ],
      ),
      DoseSection(
        heading: 'Juvenile idiopathic arthritis (JIA) (limited data; see remarks):',
        lines: [
          DoseLine('Systemic-onset JIA (child and adolescent): Start at 1–2 mg/kg/dose (max. '
              'initial dose: 100 mg/dose) SQ once daily. If needed, dosage may be '
              'doubled at 2-week intervals to a maximum of 4 mg/kg/dose up to 200 '
              'mg/dose.'),
          DoseLine('Polyarticular JIA (Child ≥2 yr and adolescent): 1 mg/kg/dose (max. dose: '
              '100 mg/dose) SQ once daily.'),
        ],
      ),
      DoseSection(
        heading: 'Rheumatoid arthritis (see remarks):',
        lines: [
          DoseLine('Adult: 100 mg SQ once daily, administered at approximately the same time '
              'every day.'),
        ],
      ),
      DoseSection(
        heading: 'Kawasaki disease refractory to IVIG (limited data):',
        lines: [
          DoseLine('A summary of small case series and reports describes dosages ranging from '
              '1–10 mg/kg/24 hr SQ ÷ once daily–BID with dose titration based on '
              'clinical response, with a few employing a dose taper when discontinuing '
              'therapy. Duration of therapy was variable, with one report continued as '
              'long as 6 months (Pediatric Drugs 2020;22:645–52).'),
          DoseLine('A phase II, open-labeled, multicenter, dose-finding trial (KAWAKINRA '
              'study) in 16 patients who were unresponsive to ≥1 course(s) of IVIG 2 '
              'g/kg/dose reported subjects became afebrile within 48 hours after their '
              'last dose escalation in 75% of the intent-to-treat cohort and 87.5% with '
              'a per-protocol cohort. All subjects received a 14-day course at their '
              'respective responsive afebrile dosage level. Fever was defined as ≥38°C '
              'and the protocol recommended using an alternative therapy if the patient '
              'remained febrile 72 hr after the initial anakinra dose (Arthritis & '
              'Rheumatology 2021;73(1):151–61).'),
        ],
      ),
      DoseSection(
        heading: 'Dosing Regimen in KAWAKINRA Study',
        table: DoseTable(
          headers: ['Age & Weight', 'Initial Dose', '1st Dose Increase If Fever Persists 24 hr After Initial Dose', '2nd and Final Dose Increase If Fever Persists 48 hr After Initial Dose'],
          rows: [
            DoseTableRow(['≥3 mo and ≥5 kg to <8 mo and ≤10 kg', '4 mg/kg/dose SQ once daily', '6 mg/kg/dose SQ once daily', '8 mg/kg/dose SQ once daily']),
            DoseTableRow(['≥8 mo, child, and adolescent weighing >10 kg', '2 mg/kg/dose SQ once daily', '4 mg/kg/dose SQ once daily', '6 mg/kg/dose SQ once daily']),
          ],
        ),
      ),
    ],
    remarks: [
      'Contraindicated with known hypersensitivity to E. coli–derived proteins. '
          'Do not use with live vaccines and tumor necrosis factor blocking agents; '
          'or during an active infection. Screen for tuberculosis (TB) prior to '
          'initiation of therapy due to the risk for reactivation; treat latent TB '
          'prior to initiating therapy.',
      'Common side effects include injection site reactions, abdominal symptoms '
          '(pain, nausea, vomiting, diarrhea), arthralgia, headache, '
          'nasopharyngitis, upper respiratory infections, and fever. Neutropenia, '
          'hypersensitivity reactions (including anaphylaxis), gastroenteritis, '
          'malignancies (melanoma, lymphoma), and bacterial infections (cellulitis, '
          'pneumonia, musculoskeletal) have been reported. DRESS has been reported '
          'in patients with autoinflammatory disorders. Despite a previous FDA '
          'pregnancy category B designation, insufficient human data on the safe use '
          'during pregnancy with specific clinical disorders and fetal risk cannot '
          'be ruled out.',
      'Dosage reduction by increasing the dosage interval to every other day has '
          'been recommended for those patients with severe renal impairment (eGFR '
          '<30 mL/min) and end-stage renal disease. Use in hepatic impairment has '
          'not been evaluated. In addition to disease-specific laboratory tests, '
          'monitor CBC with differential (baseline, monthly for the first 3 months, '
          'and then every 3 months up to a year); serum creatinine and LFTs at '
          'baseline; hypersensitivity reactions; symptoms of malignancy; and '
          'occasional skin examinations. Always screen for drug interactions, '
          'especially when used with those biologicals and medications with '
          'immunosuppressive effects.',
      'Successful first-line therapy for systemic JIA has been reported from '
          'international centers despite the current absence of FDA approval for '
          'this indication. Currently not recommended for pediatric use in juvenile '
          'rheumatoid arthritis due to insufficient studies demonstrating efficacy. '
          'Use in IVIG and corticosteroid-refractory multisystem inflammatory '
          'syndrome in children due to SARS-CoV-2 has reported doses of 5–10 '
          'mg/kg/24 hr IV or SQ ÷ once daily–QID, with a variable duration of '
          'therapy based on clinical response and a suggested 2–3-week taper.',
      'The pre-filled syringe dosage form contains a graduated syringe that '
          'allows for doses between 20 and 100 mg to be administered. When not in '
          'use, this medication is stored in the refrigerator and protected from '
          'light.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 867–869',
  ),
  // ARGININE HYDROCHLORIDE―INJECTABLE PREPARATION — PDF p. 60 (printed 869)
  DrugEntryV3(
    name: 'ARGININE HYDROCHLORIDE―INJECTABLE PREPARATION',
    brandNames: 'R-Gene 10',
    drugClass: 'Metabolic alkalosis agent, urea cycle disorder treatment agent, '
        'growth hormone diagnostic agent',
    iconRow: '',
    formulations: [
      'Injection: 10% (100 mg/mL) arginine hydrochloride, contains 47.5 mEq '
          'chloride per 100 mL (300 mL)',
      'Osmolality: 950 mOsmol/L',
    ],
    doseSections: [
      DoseSection(
        heading: 'Used as a secondary alternative agent for patients who are '
            'unresponsive or unable to receive sodium chloride and potassium '
            'chloride.',
        lines: [
          DoseLine('Correction of hypochloremia (IV): Arginine chloride dose in '
              'milliequivalents (mEq) = 0.2 × patient’s weight (kg) × (103 ∼ patient’s '
              'serum chloride in mEq/L). Administer ½ to 2⁄3 of the calculated dose and '
              'reassess.'),
        ],
      ),
      DoseSection(
        heading: 'Drug administration: Do not exceed',
        lines: [
          DoseLine('an IV infusion rate of 1 g/kg/hr (4.75 mEq/kg/hr). Drug may be '
              'administered without further dilution but should be diluted to reduce '
              'risk of tissue irritation.'),
        ],
      ),
      DoseSection(
        heading: 'Hyperammonemia in metabolic disorders:',
        lines: [
          DoseLine('See Chapter 13.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in renal or hepatic failure. Use with extreme caution as '
          'overdosages may result in hyperchloremic metabolic acidosis, cerebral '
          'edema, and death. Hypersensitivity reactions, including anaphylaxis, and '
          'hematuria have been reported.',
      'Arginine hydrochloride is metabolized to nitrogen-containing products for '
          'renal excretion. Excess arginine increases the production of nitric oxide '
          '(NO) to cause vasodilation/hypotension. Closely monitor acid/base status. '
          'Hyperglycemia, hyperkalemia, GI disturbances, IV extravasation, headache, '
          'and flushing may occur.',
      'In addition to its use for chloride supplementation, arginine is used in '
          'urea cycle disorder therapy (increase arginine levels and prevent '
          'breakdown of endogenous proteins) and as a diagnostic agent for growth '
          'hormone (stimulates pituitary release of growth hormone).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 869',
  ),
  // ARIPIPRAZOLE — PDF p. 60–62 (printed 869–871)
  DrugEntryV3(
    name: 'ARIPIPRAZOLE',
    brandNames: 'Abilify, Abilify Asimtufil, Abilify Maintena, Abilify MyCite '
        'Starter Kit, Abilify MyCite Maintenance Kit, and generics',
    drugClass: 'Atypical antipsychotic (2nd generation)',
    iconRow: '',
    formulations: [
      'Tabs: 2, 5, 10, 15, 20, 30 mg',
      'Abilify MyCite: 2, 5, 10, 15, 20, 30 mg; contains an ingestible event '
          'marker sensor inside the tablet to monitor adherence.',
      'Starter Kit: Each respective-strength starter kit comes with 30 tablets, '
          'one MyCite pod device, and 7 MyCite adhesive strips.',
      'Maintenance Kit: Each respective-strength maintenance kit comes with 30 '
          'tablets and 7 MyCite adhesive strips.',
      'Tabs, orally disintegrating (ODT): 10, 15 mg; contains phenylalanine',
      'Oral solution: 1 mg/mL (150 mL); may contain parabens',
      'Extended-release intramuscular suspension for injection in vial:',
      'Abilify Maintena: 300, 400 mg; each vial contains a 5-mL vial of sterile '
          'water for injection, one 3-mL Luer lock syringe with attached 21-gauge '
          'needle, one 3-mL Luer lock syringe, and one vial adapter. One each of '
          '23-, 22-, and 21-gauge needles are also included.',
      'Extended-release intramuscular suspension for injection in pre-filled '
          'syringe:',
      'Abilify Maintena: 300, 400 mg; each syringe contains a duo-chamber '
          'containing powdered drug in the front chamber and sterile water for '
          'injection in the rear chamber. One each of 23-, 22-, and 21-gauge needles '
          'are also included.',
      'Abilify Asimtufil: 720 mg/2.4 mL (2.4 mL), 960 mg/3.2 mL (3.2 mL); '
          'contains polyethylene glycol. Each syringe contains 2 safety needles (21- '
          'and 22-gauge needles).',
    ],
    doseSections: [
      DoseSection(
        heading: 'Irritability Associated With Autistic Disorder:',
        lines: [
          DoseLine('6–17 yr: Start at 2 mg PO once daily × 7 days, then increase to 5 mg PO '
              'once daily. If needed, dose may be increased in 5-mg increments ≥7 days '
              'in duration up to a maximum dose of 15 mg/24 hr. Patients should be '
              'periodically evaluated to determine the continued need for maintenance '
              'treatment.'),
        ],
      ),
      DoseSection(
        heading: 'Schizophrenia:',
        lines: [
          DoseLine('13–17 yr: Start at 2 mg PO once daily × 2 days, followed by 5 mg PO once '
              'daily × 2 days, then to the recommended target dose of 10 mg PO once '
              'daily. If necessary, dose may be increased in 5-mg increments up to a '
              'maximum of 30 mg/24 hr (30 mg/24 hr was not shown to be more effective '
              'than 10 mg/24 hr in clinical trials). Patients should be periodically '
              'evaluated to determine the continued need for maintenance treatment.'),
        ],
      ),
      DoseSection(
        heading: 'Bipolar I Disorder (monotherapy or adjunctive therapy):',
        lines: [
          DoseLine('10–17 yr: Start at 2 mg PO once daily × 2 days, followed by 5 mg PO once '
              'daily × 2 days, then to the recommended target dose of 10 mg PO once '
              'daily. If necessary, dose may be increased in 5-mg increments up to a '
              'maximum of 30 mg/24 hr.'),
        ],
      ),
      DoseSection(
        heading: 'Tourette Syndrome:',
        lines: [
          DoseLine(
            '6–18 yr (patients should be periodically evaluated to determine the '
                'continued need for maintenance treatment):',
            isHeading: true,
          ),
          DoseLine('<50 kg: Start at 2 mg PO once daily × 2 days, then increase to the target '
              'dose of 5 mg PO once daily. If necessary after 7 days, dose may be '
              'increased to 10 mg PO once daily.'),
          DoseLine('≥50 kg: Start at 2 mg PO once daily × 2 days, followed by 5 mg PO once '
              'daily × 5 days, and then 10 mg PO once daily. If necessary after 7 days, '
              'dose may be increased in 5-mg increments of ≥7 days in duration up to a '
              'maximum of 20 mg/24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Monitor for clinical worsening of depression and suicidal '
          'ideation/behavior after initiation of therapy or after dosage changes. '
          'Avoid use of extended-release IM injection with cytochrome P450 (CYP) '
          'inducers, including carbamazepine, for >14 days. Higher cumulative doses '
          'and longer treatment duration may increase risk for irreversible tardive '
          'dyskinesia.',
      'Weight gain, constipation, GI discomfort, akathisia, dizziness, '
          'extrapyramidal symptoms, headaches, insomnia, sedation, blurred vision, '
          'and fatigue are common. May cause leukopenia, neutropenia, '
          'agranulocytosis, hiccups, hyperthermia, neuroleptic malignant syndrome, '
          'hyperglycemia, orthostatic hypotension (risk for falls), and prolongation '
          'of the QT interval (use considered contraindicated with other medications '
          'prolonging the QT interval). Rare impulse control problems (e.g., '
          'compulsive or uncontrollable urges to gamble, binge eat, shop, and have '
          'sex), oculogyric crisis, and DRESS have been reported.',
      'Primarily metabolized by the CYP2D6 and 3A4 enzymes. Dosage reduction for '
          'using half of the usual dose has been recommended for those who are '
          'either known poor CYP2D6 metabolizers; or nonpoor CYP2D6 metabolizers '
          'taking strong CYP2D6 (e.g., quinidine, fluoxetine, paroxetine) or CYP3A4 '
          '(e.g., itraconazole, clarithromycin) inhibitors. Use of ¼ the usual dose '
          'has been recommended for known poor CYP2D6 metabolizers taking either a '
          'strong 2D6 or 3A4 inhibitor; or nonpoor CYP2D6 metabolizers taking both '
          'strong 2D6 AND 3A4 inhibitors.',
      'Consult with a pediatric psychiatrist for use in ADHD, conduct disorder, '
          'and PDD-NOS. Oral doses may be administered with or without meals. Do not '
          'split orally disintegrating tablet dosage form.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 869–871',
  ),
  // ARNUITY ELLIPTA — PDF p. 62 (printed 871)  [cross-reference]
  DrugEntryV3(
    name: 'ARNUITY ELLIPTA',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Fluticasone Preparations',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 871',
  ),
  // ASCORBIC ACID — PDF p. 62 (printed 871)
  DrugEntryV3(
    name: 'ASCORBIC ACID',
    brandNames: 'Vitamin C; many brands and generics',
    drugClass: 'Water-soluble vitamin',
    iconRow: '',
    formulations: [
      'Tabs [OTC]: 100, 250, 500 mg; 1 g',
      'Chewable tabs [OTC]: 100, 250, 500 mg; some may contain aspartame',
      'Tabs (timed release) [OTC]: 0.5, 1.5 g',
      'Caps [OTC]: 500, 1000 mg',
      'Extended release caps [OTC]: 500 mg',
      'Injection: 500 mg/mL (50 mL); may contain sodium hydrosulfite or edetate '
          'disodium',
      'Oral liquid [OTC]: 500 mg/5 mL (120, 236, 473 mL); may contain propylene '
          'glycol, saccharin, sodium benzoate',
      'Oral crystals or powder [OTC]: 1 g per ¼ teaspoonful (120 g, 480 g)',
      'Some products may contain approximately 5 mEq Na/1 g ascorbic acid.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Scurvy (PO/IM/IV/SC):',
        lines: [
          DoseLine('Child: 100–300 mg/24 hr ÷ once daily–BID for at least 2 wk'),
          DoseLine('Adult: 100–250 mg once daily–BID for at least 2 wk'),
        ],
      ),
      DoseSection(
        heading: 'U.S. Recommended Daily Allowance (RDA):',
        lines: [
          DoseLine('See Chapter 21.'),
        ],
      ),
    ],
    remarks: [
      'Adverse reactions: nausea, vomiting, heartburn, flushing, headache, '
          'faintness, dizziness, and hyperoxaluria. Use with caution in G6PD '
          'patients due to reports of hemolysis. May cause false-negative and '
          'false-positive urine glucose determinations with glucose oxidase and '
          'cupric sulfate tests, respectively.',
      'May increase the enteral absorption of aluminum hydroxide and iron; and '
          'increase the adverse/toxic effects of deferoxamine. A dose of 200 mg oral '
          'vitamin C per 30 mg iron has been recommended to enhance enteral iron '
          'absorption. May reduce the effects of amphetamines.',
      'Oral dosing is preferred with or without food. IM route is the preferred '
          'parenteral route. Protect the injectable dosage form from light.',
    ],
    pregnancyNote: 'Pregnancy Category changes to “C” if used in doses greater than '
        'the RDA.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 871',
  ),
  // ASPIRIN — PDF p. 63 (printed 872)
  DrugEntryV3(
    name: 'ASPIRIN',
    brandNames: 'ASA, various trade names and generics',
    drugClass: 'Nonsteroidal anti-inflammatory agent, antiplatelet agent, analgesic',
    iconRow: '',
    formulations: [
      'Tabs/caplet [OTC]: 325, 500 mg',
      'Tabs, enteric coated [OTC]: 81, 325, 650 mg',
      'Tabs, time release [OTC]: 81, 325 mg',
      'Tabs, buffered [OTC]: 325, 500 mg; may contain magnesium, aluminum, '
          'and/or calcium',
      'Caplet, buffered [OTC]: 500 mg; may contain calcium',
      'Tabs, chewable [OTC]: 81 mg',
      'Suppository [OTC]: 300 mg (12s)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Analgesic/antipyretic:',
        lines: [
          DoseLine('10–15 mg/kg/dose PO/PR Q4–6 hr up to total of 60–80 mg/kg/24 hr Max. '
              'dose: 4 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Antiinflammatory:',
        lines: [
          DoseLine('60–100 mg/kg/24 hr PO ÷ Q6–8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Kawasaki disease (see remarks):',
        lines: [
          DoseLine('80–100 mg/kg/24 hr PO ÷ QID during febrile phase (up to 14 days) until '
              'defervescent for 48–72 hr, then decrease to 3–5 mg/kg/24 hr PO QAM. '
              'Continue for at least 8 wk or until both platelet count and ESR are '
              'normal. Alternatively, a lower initial febrile-phase dosage of 30–50 '
              'mg/kg/24 hr PO ÷ QID is used in Japan and Western Europe because there '
              'are no data to suggest this or the higher 80–100 mg/kg/24 hr dosage '
              'regimen is superior.'),
        ],
      ),
    ],
    remarks: [
      'Do not use in children <16 yr for treatment of varicella or flu-like '
          'symptoms (risk for Reye syndrome), in combination with other NSAIDs, or '
          'in severe renal failure. Use with caution in bleeding disorders, renal '
          'dysfunction, gastritis, and gout. May cause GI upset, allergic reactions, '
          'liver toxicity, and decreased platelet aggregation.',
      'Drug interactions: May increase effects of methotrexate, valproic acid, '
          'and warfarin, which may lead to toxicity (protein displacement). Buffered '
          'dosage forms may decrease absorption of ketoconazole and tetracycline. GI '
          'bleeds have been reported with concurrent use of SSRIs (e.g., fluoxetine, '
          'paroxetine, sertraline).',
      'Therapeutic levels: antipyretic/analgesic: 30–50 mg/L, anti-inflammatory: '
          '150–300 mg/L. Tinnitus may occur at levels of 200–400 mg/L. Recommended '
          'serum sampling time at steady state: Obtain trough level just prior to '
          'dose following 1–2 days of continuous dosing. Peak levels obtained 2 hr '
          'after a dose (for non–sustained-release dosage forms) may be useful for '
          'monitoring toxicity. Adjust dose in renal failure (see Chapter 32).',
      'Use in multisystem inflammatory syndrome in children due to SARS-CoV-2 '
          'have reported doses of 3–5 mg/kg/24 hr (max. 81 mg/24 hr) PO once daily '
          'for antiplatelet/antithrombotic effects for patients without active or '
          'significant bleeding risk or low platelets (≤ 80,000 cells/mm³).',
      'For breastfeeding considerations:',
      'High-dose aspirin regimens: Use of an alternative drug is recommended.',
      'Low-dose (75–162 mg/24 hr) aspirin regimens: Avoid breastfeeding for 1–2 '
          'hr after a dose.',
      'For pregnancy considerations: Low-dose regimens are currently recommended '
          'for certain pregnancy-related conditions such as the prevention of '
          'preeclampsia. However, DO NOT use non–low-dose regimens at ≥20 weeks’ '
          'gestation as this may cause problems to the unborn child or complications '
          'during delivery. Category “D” is for using full doses during the third '
          'trimester.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 872',
  ),
  // ATENOLOL — PDF p. 64 (printed 873)
  DrugEntryV3(
    name: 'ATENOLOL',
    brandNames: 'Tenormin and generics',
    drugClass: 'β₁-selective adrenergic blocker',
    iconRow: '',
    formulations: [
      'Tab: 25, 50, 100 mg',
      'Oral suspension: 2 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hypertension:',
        lines: [
          DoseLine('Child and adolescent: 0.5–1 mg/kg/dose PO once daily–BID; max. dose: 2 '
              'mg/kg/24 hr up to 100 mg/24 hr'),
          DoseLine('Adult: 25–100 mg/dose PO once daily–BID; max. dose: 100 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Infantile hemangioma (limited data):',
        lines: [
          DoseLine('Infant: Start at 0.5 mg/kg/dose PO once daily for 1 week, then increase '
              'to 1 mg/kg/dose PO once daily.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in pulmonary edema and cardiogenic shock. May cause '
          'bradycardia, hypotension, second- or third-degree AV block, dizziness, '
          'fatigue, lethargy, and headache. Use with caution in diabetes and asthma. '
          'Wheezing and dyspnea have occurred when daily dosage exceeds 100 mg/24 '
          'hr. Hypoglycemia has been reported as a dose-related side effect in '
          'patients with diabetes or who are fasting or vomiting. Postmarketing '
          'evaluation reports a temporal relationship that causes elevated LFTs '
          'and/or bilirubin, hallucinations, psoriatic rash, thrombocytopenia, '
          'visual disturbances, and dry mouth.',
      'Avoid abrupt withdrawal of the drug. Does not cross the blood-brain '
          'barrier; lower incidence of CNS side effects compared with propranolol. '
          'Neonates born to mothers receiving atenolol during labor or while '
          'breastfeeding may be at risk for hypoglycemia.',
      'Use with disopyramide, amiodarone, or digoxin may enhance bradycardic '
          'effects. Adjust dose in renal impairment (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 873',
  ),
  // ATOMOXETINE — PDF p. 64–65 (printed 873–874)
  DrugEntryV3(
    name: 'ATOMOXETINE',
    brandNames: 'Strattera and generics',
    drugClass: 'Norepinephrine reuptake inhibitor, ADHD agent',
    iconRow: '',
    formulations: [
      'Capsules: 10, 18, 25, 40, 60, 80, 100 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child ≥6 yr and adolescent: ≤70 kg (see remarks):',
        lines: [
          DoseLine('Start with approximately 0.5 mg/kg/24 hr PO QAM and increase after a '
              'minimum of 3 days to approximately 1.2 mg/kg/24 hr PO ÷ QAM or BID '
              '(morning and late afternoon/early evening).'),
          DoseLine('Max. daily dose: 1.4 mg/kg/24 hr or 100 mg, whichever is less'),
          DoseLine('If used with a strong cytochrome P-450 (CYP) 2D6 inhibitor (e.g., '
              'fluoxetine, paroxetine, quinidine) or in patients with reduced CYP2D6 '
              'activity: Maintain aforementioned initial dose for 4 wk and increase to a '
              'max. of 1.2 mg/kg/24 hr only if symptoms do not improve and initial dose '
              'is tolerated.'),
        ],
      ),
      DoseSection(
        heading: 'Child ≥6 yr and adolescent: >70 kg (see remarks):',
        lines: [
          DoseLine('Start with 40 mg PO QAM and increase after a minimum of 3 days to '
              'approximately 80 mg/24 hr PO ÷ QAM or BID (morning and late '
              'afternoon/early evening). After 2–4 wk, dose may be increased to a max. '
              'of 100 mg/24 hr if needed.'),
          DoseLine('If used with a strong CYP2D6 inhibitor (e.g., fluoxetine, paroxetine, '
              'quinidine) or in patients with reduced CYP2D6 activity: Maintain '
              'aforementioned initial dose for 4 wk and increase to 80 mg/24 hr only if '
              'symptoms do not improve and initial dose is tolerated.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in patients with narrow-angle glaucoma, pheochromocytoma, '
          'and severe cardiac disorders. Do not administer with or within 2 wk after '
          'discontinuing an MAO inhibitor; fatal reactions have been reported. Use '
          'with caution in hypertension, tachycardia, and cardiovascular or '
          'cerebrovascular diseases, or with concurrent albuterol therapy. Increased '
          'risk of suicidal thinking has been reported; closely monitor for clinical '
          'worsening, agitation, aggressive behavior, irritability, suicidal '
          'thinking or behaviors, and unusual changes in behavior when initiating '
          '(first few months) or at times of dose changes (increases or decreases). '
          'Patients with bipolar disorders may be at increased risk for developing '
          'mania or mixed episodes.',
      'Atomoxetine is a CYP2D6 substrate; compared with normal metabolizers, '
          'poor 2D6 metabolizers have been reported to have higher rates of adverse '
          'effects (insomnia, weight loss, constipation, depression, tremor, and '
          'excoriation) and greater improvement of ADHD symptoms with lower final '
          'dose requirements.',
      'Doses >1.2 mg/kg/24 hr in patients ≤70 kg have not been shown to be of '
          'additional benefit. Reduce dose (initial and target doses) by 50% and 75% '
          'for patients with moderate (Child-Pugh Class B) and severe (Child-Pugh '
          'Class C) hepatic insufficiency, respectively.',
      'Major side effects include GI discomfort, vomiting, fatigue, anorexia, '
          'dizziness, and mood swings. Hypersensitivity reactions, aggression, '
          'hostility, irritability, psychotic or manic symptoms, priapism, allergic '
          'reactions, severe liver injury, alopecia, and hyperhidrosis have also '
          'been reported. Consider interrupting therapy in patients who are not '
          'growing or gaining weight satisfactorily.',
      'Doses may be administered with or without food. Atomoxetine can be '
          'discontinued without tapering.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 873–874',
  ),
  // ATOVAQUONE — PDF p. 65–66 (printed 874–875)
  DrugEntryV3(
    name: 'ATOVAQUONE',
    brandNames: 'Mepron and generics',
    drugClass: 'Antiprotozoal',
    iconRow: '',
    formulations: [
      'Oral suspension: 750 mg/5 mL (210 mL); contains benzyl alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Pneumocystis jiroveci (previously P. carinii) pneumonia (PCP):',
        lines: [
          DoseLine(
            'Treatment (21-day course):',
            isHeading: true,
          ),
          DoseLine('Child: 30–40 mg/kg/24 hr PO ÷ BID with fatty foods; max. dose: 1500 mg/24 '
              'hr. Infants 4–24 mo may require higher doses of 45 mg/kg/24 hr.'),
          DoseLine('Adult: 750 mg/dose PO BID'),
          DoseLine(
            'Prophylaxis (1st episode and recurrence):',
            isHeading: true,
          ),
          DoseLine('Child 1–3 mo or >24 mo: 30–40 mg/kg/24 hr PO once daily; max. dose: 1500 '
              'mg/24 hr'),
          DoseLine('Child 4–24 mo: 45 mg/kg/24 hr PO once daily; max. dose: 1500 mg/24 hr'),
          DoseLine('Adult: 1500 mg/dose PO once daily'),
        ],
      ),
      DoseSection(
        heading: 'Toxoplasma gondii for HIV patients:',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('First episode prophylaxis and recurrence prophylaxis: with or without '
              'pyrimethamine 1 mg/kg/dose (max. 25 mg/dose) PO once daily PLUS '
              'leucovorin 5 mg PO Q3 days.'),
          DoseLine('Child 1–3 mo or >24 mo: 30 mg/kg/24 hr PO once daily; max. dose: 1500 '
              'mg/24 hr'),
          DoseLine('Child 4–24 mo: 45 mg/kg/24 hr PO once daily; max. dose: 1500 mg/24 hr'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Treatment: 1500 mg/dose PO BID with either sulfadiazine 1000–1500 mg PO '
              'Q6 hr OR pyrimethamine PLUS leucovorin) for a minimum of 6 weeks'),
          DoseLine('First episode prophylaxis: 1500 mg/dose PO once daily with or without '
              'pyrimethamine 25 mg PO once daily PLUS leucovorin 10 mg PO once daily'),
          DoseLine('Recurrence prophylaxis: 750–1500 mg/dose PO Q12 hr alone OR with either '
              'pyrimethamine 25 mg PO once daily PLUS leucovorin 10 mg PO once daily OR '
              'sulfadiazine'),
        ],
      ),
    ],
    remarks: [
      'Not recommended in the treatment of severe P. jiroveci (lack of clinical '
          'data). Patients with GI disorders or severe vomiting and who cannot '
          'tolerate oral therapy should consider alternative IV therapies. Rash, '
          'pruritus, sweating, GI symptoms, LFT elevation, dizziness, headache, '
          'insomnia, anxiety, cough, and fever are common. Anemia, Stevens-Johnson '
          'syndrome, hepatitis, renal/urinary disorders, and pancreatitis have been '
          'reported.',
      'Metoclopramide, rifampin, rifabutin, and tetracycline may decrease '
          'atovaquone levels. Shake oral suspension well before dispensing all '
          'doses. Take all doses with high-fat foods to maximize absorption.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 874–875',
  ),
  // ATROPINE SULFATE — PDF p. 66–67 (printed 875–876)
  DrugEntryV3(
    name: 'ATROPINE SULFATE',
    brandNames: 'Many generics; previously available as AtroPen and Isopto Atropine',
    drugClass: 'Anticholinergic agent',
    iconRow: '',
    formulations: [
      'Injection (vials): 0.4, 1 mg/mL',
      'Injection (prefilled syringe): 0.25 mg/5 mL, 0.5 mg/5 mL, 1 mg/10 mL',
      'Ophthalmic Dosage Forms:',
      'Ointment: 1% (3.5 g)',
      'Solution (previously available as Isopto Atropine): 1% (2, 5, 10 mL); may '
          'contain benzalkonium chloride',
    ],
    doseSections: [
      DoseSection(
        heading: 'Preintubation dose (use 1 mg/mL concentration for IM route; see '
            'remarks):',
        lines: [
          DoseLine('Neonate: 0.01–0.02 mg/kg/dose IV (over 1 min)/IM prior to other '
              'premedications'),
          DoseLine('Child: 0.02 mg/kg/dose IV/IO/IM; max. dose: 0.5 mg/dose'),
          DoseLine('Adult: 0.5 mg/dose IV/IM'),
        ],
      ),
      DoseSection(
        heading: 'Cardiopulmonary resuscitation/bradycardia (see remarks):',
        lines: [
          DoseLine('Child: 0.02 mg/kg/dose IV/IO/IM (use 1 mg/mL for IM) Q5 min × 2–3 doses '
              'PRN; max. single dose: 0.5 mg in children, 1 mg in adolescents; max. '
              'total dose: 1 mg children, 2 mg adolescents'),
          DoseLine('ET tube administration: 0.04–0.06 mg/kg (dilute with NS to volume of 1–2 '
              'mL and follow dose with 1 mL NS); may repeat once if needed'),
          DoseLine('Adult: 1 mg/dose IV Q5 min; max. total dose: 3 mg'),
        ],
      ),
      DoseSection(
        heading: 'Bronchospasm:',
        lines: [
          DoseLine('0.025–0.05 mg/kg/dose (max. dose: 2.5 mg/dose) in 2.5 mL NS Q6–8 hr via '
              'nebulizer'),
        ],
      ),
      DoseSection(
        heading: 'Nerve agent and insecticide poisoning for muscarinic symptoms '
            '(organophosphate or carbamate poisoning):',
        lines: [
          DoseLine(
            'IV/IO/IM:',
            isHeading: true,
          ),
          DoseLine('Child: 0.05–0.1 mg/kg Q3–5 min until bronchial or oral secretions '
              'terminate'),
          DoseLine('Adolescent: 1–3 mg/dose Q3–5 min until bronchial or oral secretions '
              'terminate'),
          DoseLine('Adult: 2–5 mg/dose Q3–5 min until bronchial or oral secretions terminate'),
          DoseLine('ET tube administration: Increase above IV doses by 2–3 times and dilute '
              'in 3–5 mL NS. Flush each dose with 3–5 mL NS followed by 5 assisted '
              'ventilations.'),
          DoseLine('Alternative weight-based dosing via IM route (from previously available '
              'AtroPen auto-injector device): Inject as soon as exposure is known or '
              'suspected. Give one dose for mild symptoms and two additional doses '
              '(total three doses) in rapid succession 10 min after the first dose for '
              'severe symptoms as follows:'),
          DoseLine('<7 kg: 0.25 mg'),
          DoseLine('7–18 kg: 0.5 mg'),
          DoseLine('18–41 kg: 1 mg'),
          DoseLine('>41 kg: 2 mg'),
        ],
      ),
      DoseSection(
        heading: 'Ophthalmic (mydriasis induction; see remarks):',
        lines: [
          DoseLine('Child ≥3 mo and adult: 1 drop of the 1% solution into the cul-de-sac of '
              'the conjunctiva 40 minutes prior to the intended maximal dilation time '
              'with the following max. dose: Child ≥3 mo to <3 yr: 1 drop per eye per 24 '
              'hr'),
          DoseLine('Child ≥3 yr and adult: may repeat dose up to BID as needed'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in glaucoma, obstructive uropathy, tachycardia, and '
          'thyrotoxicosis, except for severe or life-threatening muscarinic '
          'symptoms. Use with caution in patients sensitive to sulfites.',
      'Use in neonatal bradycardia is no longer recommended. Data suggest the '
          'use of a minimum 0.1-mg dose may not be warranted for the preintubation '
          'indication. Use of the minimum 0.1-mg dose could result in an overdose in '
          'younger patients.',
      'Side effects include: dry mouth, blurred vision, fever, tachycardia, '
          'constipation, urinary retention, CNS signs (dizziness, hallucinations, '
          'restlessness, fatigue, headache).',
      'Use injectable solution for nebulized use; can be mixed with albuterol '
          'for simultaneous administration. AtroPen dosage form is designed for IM '
          'administration to the outer thigh.',
      'Ophthalmic use is not recommended for children <3 mo of age due to risk '
          'for systemic absorption and potential side effects.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 875–876',
  ),
  // AZATHIOPRINE — PDF p. 67–68 (printed 876–877)
  DrugEntryV3(
    name: 'AZATHIOPRINE',
    brandNames: 'Imuran, Azasan, and generics',
    drugClass: 'Immunosuppressant',
    iconRow: '',
    formulations: [
      'Oral suspension: 50 mg/mL',
      'Tabs:',
      'Imuran and generics: 50 mg (scored)',
      'Azasan and generics: 75, 100 mg (scored)',
      'Injection: 100 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Immunosuppression (see remarks for genomic considerations):',
        lines: [
          DoseLine(
            'Child and adult:',
            isHeading: true,
          ),
          DoseLine('Initial: 3–5 mg/kg/24 hr IV/PO once daily'),
          DoseLine('Maintenance: 1–3 mg/kg/24 hr IV/PO once daily'),
        ],
      ),
    ],
    remarks: [
      'Should NOT be given during pregnancy without careful evaluation of risk '
          'over benefit. Increased risk for hepatosplenic T-cell lymphoma has been '
          'reported in adolescents and young adults. Toxicity: Bone marrow '
          'suppression, rash, stomatitis, hepatotoxicity, alopecia, arthralgias, and '
          'GI disturbances.',
      'Use ¼–⅓ dose when given with xanthine oxidase inhibitors (e.g., '
          'allopurinol). Patients with low or absent thiopurine methyltransferase '
          '(TPMT) or nucleotide diphosphatase (NUDT15) may be at increased risk for '
          'severe and life-threatening myelotoxicity. Consider alternative therapy '
          'in patients with homozygous TPMT or NUDT15 deficiency and reduced dosages '
          'in patients with heterozygous deficiency. Low-functioning alleles for '
          'NUDT15 are common among individuals of Asian ancestry and Hispanic '
          'ethnicity.',
      'Severe anemia has been reported when used in combination with captopril '
          'or enalapril. Monitor CBC, platelets, total bilirubin, alkaline '
          'phosphatase, BUN, and creatinine. Pancytopenia and bone marrow '
          'suppression have been reported with concomitant use of pegylated '
          'interferon and ribavirin in patients with hepatitis C. Progressive '
          'multifocal leukoencephalopathy (PML) has been reported. Adjust dose in '
          'renal failure (see Chapter 32).',
      'Administer oral doses with food to minimize GI discomfort. To minimize '
          'infant exposure via breastmilk, avoid breastfeeding for 4–6 hr after '
          'administering a maternal dose.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 876–877',
  ),
  // AZELASTINE — PDF p. 68 (printed 877)
  DrugEntryV3(
    name: 'AZELASTINE',
    brandNames: 'Astepro, Children\'s Astepro, and generics; previously available as '
        'Opitvar',
    drugClass: 'Antihistamine',
    iconRow: '',
    formulations: [
      'Nasal spray:',
      'Generic: 0.1% (delivers 137 mCg/spray) (200 actuations per 30 mL); '
          'contains benzalkonium chloride and EDTA',
      'Astepro [OTC]: 0.15% (delivers 205.5 mCg/spray) (200 actuations per 30 '
          'mL); contains benzalkonium chloride and EDTA',
      'Children’s Astepro [OTC]: 0.15% (delivers 205.5 mCg/spray) (60 actuations '
          'per 11 mL; 120 actuations per 23 mL); contains benzalkonium chloride and '
          'EDTA',
      'Ophthalmic drops (generics; previously available as Opitvar): 0.05% (0.5 '
          'mg/mL) (6 mL); contains benzalkonium chloride',
    ],
    doseSections: [
      DoseSection(
        heading: 'Seasonal allergic rhinitis:',
        lines: [
          DoseLine(
            '0.1% strength:',
            isHeading: true,
          ),
          DoseLine('Child 2–11 yr: 1 spray each nostril BID'),
          DoseLine('≥12 yr and adult: 1–2 sprays each nostril BID'),
          DoseLine(
            '0.15% strength:',
            isHeading: true,
          ),
          DoseLine('Child 6–12 yr: 1 spray each nostril BID'),
          DoseLine('≥12 yr and adult: 1–2 sprays each nostril BID or 2 sprays each nostril '
              'once daily'),
        ],
      ),
      DoseSection(
        heading: 'Perennial allergic rhinitis:',
        lines: [
          DoseLine(
            '0.1% strength:',
            isHeading: true,
          ),
          DoseLine('≥6 mo–<6 yr: 1 spray each nostril BID'),
          DoseLine(
            '0.15% strength:',
            isHeading: true,
          ),
          DoseLine('6–<12 yr: 1 spray each nostril BID'),
          DoseLine('≥12 yr and adult: 2 sprays each nostril BID'),
        ],
      ),
      DoseSection(
        heading: 'Ophthalmic:',
        lines: [
          DoseLine('≥3 yr and adult: Instill 1 drop into each affected eye BID.'),
        ],
      ),
    ],
    remarks: [
      'NASAL USE: Drowsiness may occur despite nasal route of administration '
          '(avoid concurrent use of alcohol or CNS depressants). Bitter taste, '
          'nausea, nasal burning, pharyngitis, weight gain, fatigue, nasal sores, '
          'and epistaxis may also occur. Also available in combination with '
          'fluticasone as Dymista with labeled dosing information of 1 spray each '
          'nostril BID for seasonal allergic rhinitis (≥6 yr and adult).',
      'OPHTHALMIC USE: Eye burning and stinging have been reported in about 30% '
          'of patients receiving the ophthalmic dosage form. Should not be used to '
          'treat contact lens–related irritation. Soft contact lens users should '
          'wait at least 10 min after dose instillation before they insert their '
          'lenses.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 877',
  ),
  // AZELASTINE AND FLUTICASONE — PDF p. 69 (printed 878)
  DrugEntryV3(
    name: 'AZELASTINE AND FLUTICASONE',
    brandNames: 'Dymista and generics',
    drugClass: 'Intranasal antihistamine and corticosteroid combination',
    iconRow: '',
    formulations: [
      'Nasal spray: 137 mCg azelastine and 50 mCg fluticasone per spray (23 g '
          'delivers 120 doses); contains benzalkonium chloride, EDTA, and '
          'polysorbate 80',
    ],
    doseSections: [
      DoseSection(
        heading: 'Seasonal allergic rhinitis:',
        lines: [
          DoseLine('Child >6 yr, adolescent, and adult: 1 spray each nostril BID'),
        ],
      ),
    ],
    remarks: [
      'May cause drowsiness. Avoid use with recent nasal ulcers, nasal surgery, '
          'or nasal trauma. Use with ketoconazole, ritonavir, or other strong '
          'cytochrome P-450 3A4 inhibitors may increase fluticasone levels and '
          'result in systemic corticosteroid effects, including Cushing syndrome and '
          'adrenal suppression. Monitor growth velocity in children with prolonged '
          'use. See Azelastine and Fluticasone individual profiles for remarks on '
          'intranasal route of administration for additional information.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 878',
  ),
  // AZITHROMYCIN — PDF p. 69–71 (printed 878–880)
  DrugEntryV3(
    name: 'AZITHROMYCIN',
    brandNames: 'Zithromax, Zithromax TRI-PAK, Zithromax Z-PAK, AzaSite, and generics',
    drugClass: 'Antibiotic, macrolide',
    iconRow: '',
    formulations: [
      'Tablets: 250, 500, 600 mg',
      'Zithromax TRI-PAK and generics: 500 mg (3s as unit dose pack)',
      'Zithromax Z-PAK and generics: 250 mg (6s as unit dose pack)',
      'Oral suspension: 100 mg/5 mL (15 mL), 200 mg/5 mL (15, 22.5, 30 mL); see '
          'remarks',
      'Oral powder (sachet): 1 g (3s)',
      'Injection: 500 mg; contains 9.92 mEq Na/1 g drug',
      'Ophthalmic solution (AzaSite): 1% (2.5 mL); contains benzalkonium '
          'chloride and EDTA',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infant and child (see remarks):',
        lines: [
          DoseLine(
            'Community-acquired pneumonia (≥3 mo):',
            isHeading: true,
          ),
          DoseLine('Tablet or oral suspension (mild infection or step-down therapy): 10 mg/kg '
              '(max. dose: 500 mg) PO on day 1, followed by 5 mg/kg/24 hr (max. dose: '
              '250 mg/24 hr) PO once daily on days 2–5'),
          DoseLine('IV and PO regimen (severe infection): 10 mg/kg/dose (max. dose: 500 '
              'mg/dose) IV once daily for at least 2 days followed by 5 mg/kg/dose (max. '
              'dose: 250 mg/dose) PO once daily to complete a 5-day course'),
          DoseLine('Pharyngitis/tonsillitis (Group A streptococcal; 2–15 yr): 12 mg/kg/24 hr '
              'PO once daily × 5 days (max. dose: 500 mg/24 hr)'),
          DoseLine(
            'Pertussis:',
            isHeading: true,
          ),
          DoseLine('1–<6 mo: 10 mg/kg/dose PO/IV once daily × 5 days'),
          DoseLine('≥6 mo: 10 mg/kg/dose (max. dose: 500 mg) PO/IV on day 1, followed by 5 '
              'mg/kg/dose (max. dose: 250 mg) PO/IV once daily on days 2–5'),
          DoseLine(
            'Mycobacterium avium complex in HIV (see https://clinicalinfo.hiv.gov/en '
                'for most current recommendations):',
            isHeading: true,
          ),
          DoseLine('Prophylaxis for first episode (primary prophylaxis): 20 mg/kg/dose PO Q7 '
              'days (max. dose: 1200 mg/dose); alternatively, 5 mg/kg/24 hr PO once '
              'daily (max. dose: 250 mg/dose)'),
          DoseLine('Prophylaxis for recurrence (secondary prophylaxis): 5 mg/kg/24 hr PO once '
              'daily (max. dose: 250 mg/dose), plus ethambutol 15 mg/kg/24 hr (max. '
              'dose: 900 mg/24 hr) PO once daily with or without rifabutin 5 mg/kg/24 hr '
              '(max. dose: 300 mg/24 hr)'),
          DoseLine('Treatment: 10–12 mg/kg/24 hr PO once daily (max. dose: 500 mg/24 hr) for '
              'at least 12 mo plus ethambutol 15–25 mg/kg/24 hr (max. dose: 1 g/24 hr) '
              'PO once daily with or without rifabutin 10–20 mg/kg/24 hr (max. dose: 300 '
              'mg/24 hr)'),
          DoseLine('Endocarditis prophylaxis: 15 mg/kg/dose (max. dose: 500 mg) PO × 1, 30–60 '
              'min before procedure'),
          DoseLine(
            'Anti-inflammatory agent in cystic fibrosis:',
            isHeading: true,
          ),
          DoseLine('<18 kg: 10 mg/kg/dose PO every Monday, Wednesday, and Friday'),
          DoseLine('18–<36 kg: 250 mg PO every Monday, Wednesday, and Friday'),
          DoseLine('≥36 kg: 500 mg PO every Monday, Wednesday, and Friday'),
        ],
      ),
      DoseSection(
        heading: 'Adolescent and adult:',
        lines: [
          DoseLine('Pharyngitis or tonsillitis: 500 mg PO on day 1, then 250 mg/24 hr PO on '
              'days 2–5. Alternatively, 12 mg/kg (max. dose: 500 mg) PO once daily x 5 '
              'days has been recommended.'),
          DoseLine('Mild/moderate bacterial COPD exacerbation: 500 mg PO on day 1, then 250 '
              'mg/24 hr PO on days 2–5 OR 500 mg PO once daily × 3 days'),
          DoseLine(
            'Community-acquired pneumonia:',
            isHeading: true,
          ),
          DoseLine('Tablets (outpatient regimen): 500 mg PO on day 1, then 250 mg/24 hr PO on '
              'days 2–5 OR 500 mg PO once daily × 3 days'),
          DoseLine('IV and tablet regimen (inpatient regimen): 500 mg IV once daily for at '
              'least 2 days followed by 500 mg PO once daily to complete a 7- to 10-day '
              'regimen (IV and PO)'),
          DoseLine('Uncomplicated chlamydial cervicitis or urethritis (alternative to '
              'CDC-recommended doxycycline): Single 1-g dose PO'),
          DoseLine(
            'Gonococcal cervicitis or urethritis (alternative to CDC-recommended '
                'ceftriaxone):',
            isHeading: true,
          ),
          DoseLine('Single 2-g dose PO with gentamicin 240 mg IM x 1'),
          DoseLine('Pelvic inflammatory disease (PID): 500 mg IV once daily × 1–2 days '
              'followed by 250 mg PO once daily to complete a 7-day regimen (IV and PO) '
              'in combination with metronidazole'),
          DoseLine(
            'Mycobacterium avium complex in HIV (see https://clinicalinfo.hiv.gov/en '
                'for most recent recommendations):',
            isHeading: true,
          ),
          DoseLine('Prophylaxis for first episode (primary prophylaxis): 1200 mg PO Q7 days'),
          DoseLine('Prophylaxis for recurrence (secondary prophylaxis): 500 mg PO once daily, '
              'plus ethambutol 15 mg/kg/dose PO once daily, with or without rifabutin '
              '300 mg PO once daily'),
          DoseLine('Treatment: 500–600 mg PO once daily for at least 12 mo with ethambutol 15 '
              'mg/kg/dose PO once daily with or without rifabutin 300 mg PO once daily'),
          DoseLine('Endocarditis prophylaxis: 500 mg PO × 1, 30–60 min before procedure'),
          DoseLine('Anti-inflammatory agent in cystic fibrosis: Use same dosing as in '
              'children.'),
        ],
      ),
      DoseSection(
        heading: 'Ophthalmic:',
        lines: [
          DoseLine('≥1 yr and adult: Instill 1 drop into the affected eye(s) BID, 8–12 hr '
              'apart, × 2 days, followed by 1 drop once daily for the next 5 days.'),
        ],
      ),
    ],
    remarks: [
      'Not recommended for otitis media and acute sinusitis due to increased '
          'resistant pathogens.',
      'Contraindicated in hypersensitivity to macrolides and history of '
          'cholestatic jaundice/hepatic dysfunction associated with prior use. Use '
          'with caution in impaired hepatic function, GFR <10 mL/min (limited data), '
          'hypokalemia, hypomagnesemia, bradycardia, arrhythmias, prolonged QT '
          'intervals, and receiving medications that can cause the aforementioned '
          'conditions of caution. May cause increase in hepatic enzymes, cholestatic '
          'jaundice, GI discomfort, and pain at injection site (IV use). Compared '
          'with other macrolides, less risk for drug interactions. Nelfinavir may '
          'increase azithromycin levels; monitor for liver enzyme abnormalities and '
          'hearing impairment. Vomiting, diarrhea, and nausea have been reported at '
          'higher frequency in otitis media with 1-day dosing regimen. Exacerbations '
          'of myasthenia gravis/myasthenic syndrome, serious skin reactions (e.g., '
          'SJS and TEN), infantile hypertrophic pyloric stenosis, decreased '
          'lymphocytes, and elevated bilirubin, BUN, and creatinine have been '
          'reported. CNS penetration is poor.',
      'Aluminum- and magnesium-containing antacids decrease absorption. Oral '
          'dosage forms may be administered with or without food. The 200 mg/5 mL '
          'oral suspension has a reported osmolality of 3950 mOsm/kg and may '
          'increase risk for GI side effects. Diluting the oral suspension dose with '
          'purified water at 1–3 times the dosage volume prior to administration has '
          'been suggested to reduce the osmolality. Intravenous administration is '
          'over 1–3 hr; do not give as a bolus or IM injection.',
      'Ophthalmic Use: Do not wear contact lenses. Eye irritation is the most '
          'common side effect. Avoid contaminating the applicator tip with the eye, '
          'finger, or other sources.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 878–880',
  ),
  // AZTREONAM — PDF p. 71–72 (printed 880–881)
  DrugEntryV3(
    name: 'AZTREONAM',
    brandNames: 'Azactam, Cayston, and generic intravenous products',
    drugClass: 'Antibiotic, monobactam',
    iconRow: '',
    formulations: [
      'Injection: 1, 2 g; each 1 g of drug contains approximately 780 mg '
          'L-arginine',
      'Nebulizer solution (Cayston): 75 mg powder to be reconstituted with the '
          'supplied diluent of 1 mL 0.17% sodium chloride (28-day course kit '
          'contains 84 sterile vials of Cayston and 88 ampules of sterile diluent); '
          'arginine and preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate:',
        lines: [
          DoseLine(
            '30 mg/kg/dose IV/IM (higher doses may be necessary for meningitis):',
            isHeading: true,
          ),
          DoseLine(
            'Gestational age <34 wk:',
            isHeading: true,
          ),
          DoseLine('≤7 days old: Q12 hr'),
          DoseLine('>7 days old: Q8 hr'),
          DoseLine(
            'Gestational age ≥34 wk:',
            isHeading: true,
          ),
          DoseLine('≤7 days old: Q8 hr'),
          DoseLine('>7 days old: Q6 hr'),
        ],
      ),
      DoseSection(
        heading: 'Child:',
        lines: [
          DoseLine('90–120 mg/kg/24 hr ÷ Q6–8 hr IV/IM; max. dose: 2 g/dose and 8 g/24 hr.'),
        ],
      ),
      DoseSection(
        heading: 'Cystic fibrosis (child and adult):',
        lines: [
          DoseLine('150–200 mg/kg/24 hr ÷ Q6–8 hr IV/IM (max. dose: 8 g/24 hr). '
              'Alternatively, higher doses have been used at 200–300 mg/kg/24 hr ÷ Q6 hr '
              'IV/IM (max. dose: 12 g/24 hr).'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Moderate infections: 1–2 g/dose Q8–12 hr IV/IM'),
          DoseLine('Severe infections: 2 g/dose Q6–8 hr IV/IM'),
          DoseLine('Max. dose: 8 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Inhalation:',
        lines: [
          DoseLine(
            'Cystic fibrosis prophylaxis therapy (see remarks):',
            isHeading: true,
          ),
          DoseLine('≥7 yr and adult: 75 mg TID (minimum 4 hr between doses) administered in '
              'repeated cycles of 28 days on drug followed by 28 days off drug. '
              'Administer each dose with the Altera Nebulizer System.'),
        ],
      ),
    ],
    remarks: [
      'Typically indicated in multidrug-resistant aerobic gram-negative '
          'infections when β-lactam therapy is contraindicated. Well absorbed when '
          'given IM. Use with caution in arginase deficiency. Low '
          'cross-allergenicity between aztreonam and other β-lactams. Adverse '
          'reactions: thrombophlebitis, eosinophilia, leukopenia, neutropenia, '
          'thrombocytopenia, elevation of liver enzymes, hypotension, seizures, and '
          'confusion. Good CNS penetration. Probenecid and furosemide increase '
          'aztreonam levels. Adjust dose in renal failure (see Chapter 32).',
      'INHALATIONAL USE: Cough, nasal congestion, wheezing, pharyngolaryngeal '
          'pain, pyrexia, chest discomfort, abdominal pain, and vomiting may occur. '
          'Bronchospasm has been reported. Use the following order of '
          'administration: bronchodilator first, chest physiotherapy, other inhaled '
          'medications (if indicated), and aztreonam last. Limited data for patients '
          '3 months to <7 years old. Cayston vials and diluent ampules should be '
          'stored in the refrigerator (2–8ᵒ C), but once they are removed from the '
          'refrigerator, they can be stored at room temperature for up to 28 days. '
          'Cayston vials should be protected from light.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 880–881',
  ),
];
