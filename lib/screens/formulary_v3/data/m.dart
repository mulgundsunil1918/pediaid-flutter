// =============================================================================
// output/m.dart — Drug Formulary 3.0, letter M
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyM` per file; entries in book order.
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

const List<DrugEntryV3> formularyM = [
  // MAGNESIUM CITRATE — PDF p. 280 (printed 1089)
  DrugEntryV3(
    name: 'MAGNESIUM CITRATE',
    brandNames: 'Slow Mag Mg Gummies, and various generics 16.17% Elemental Magnesium',
    drugClass: 'Laxative/cathartic',
    iconRow: '',
    formulations: [
      'Oral solution (OTC): 1.75 g/30 mL (296 mL); 5 mL = 3.9–4.7 mEq Mg',
      'Tabs (OTC): 200 mg',
      'Caps (OTC): 150 mg',
      'Chewable tab:',
      'SlowMag Mg Gummies (OTC): 85 mg',
      'Magnesium Citrate Gummies (OTC): 750 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Constipation:',
        lines: [
          DoseLine('2–<6 yr: 2–4 mL/kg/24 hr PO ÷ once daily–BID; OR 60–90 mL/24 hr PO ÷ once '
              'daily–BID'),
          DoseLine('6–12 yr: 100–150 mL/24 hr PO ÷ once daily–BID'),
          DoseLine('>12 yr and adult: 150–300 mL/24 hr PO ÷ once daily–BID'),
        ],
      ),
      DoseSection(
        heading: 'Bowel prep:',
        lines: [
          DoseLine('Child >6 yr and adolescent: 4–6 mL/kg/24 hr (max. 300 mL/24 hr) PO × 1 as '
              'a single or divided dose the day prior to surgery'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in renal insufficiency (monitor magnesium level) and '
          'patients receiving digoxin. May cause hypermagnesemia, diarrhea, muscle '
          'weakness, hypotension, and respiratory depression. Up to approximately '
          '30% of dose is absorbed. May decrease absorption of H₂ antagonists, '
          'phenytoin, iron salts, tetracyclines, steroids, benzodiazepines, and '
          'quinolone antibiotics.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1089',
  ),
  // MAGNESIUM HYDROXIDE — PDF p. 280–281 (printed 1089–1090)
  DrugEntryV3(
    name: 'MAGNESIUM HYDROXIDE',
    brandNames: 'Milk of Magnesia, Pedia-Lax, and various generics 41.69% Elemental '
        'Magnesium',
    drugClass: 'Antacid, laxative',
    iconRow: '',
    formulations: [
      'Oral liquid (OTC): 400 mg/5 mL (Milk of Magnesia and others) (355, 473 '
          'mL); may contain parabens, propylene glycol and saccharin',
      'Concentrated oral liquid (OTC): 2400 mg/10 mL (Milk of Magnesia '
          'concentrate) (10 mL); may contain parabens, propylene glycol, and '
          'saccharin',
      'Chewable tabs (Pedia-Lax, see remarks [OTC]): 400 mg',
      '400 mg magnesium hydroxide is equivalent to 166.76 mg elemental magnesium.',
      'Combination product with aluminum hydroxide: See Aluminum Hydroxide.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Laxative (all liquid mL doses based on 400 mg/5 mL magnesium '
            'hydroxide, unless noted otherwise):',
        lines: [
          DoseLine('Dose/24 hr PO ÷ once daily–QID'),
          DoseLine('<2 yr: 0.5 mL/kg'),
          DoseLine('2–5 yr: 5–15 mL OR 400–1200 mg (1–3 chewable tabs)'),
          DoseLine('6–11 yr: 15–30 mL OR 1200–2400 mg (3–6 chewable tabs)'),
          DoseLine('≥12 yr and adult: 30–60 mL OR 2400–4800 mg (6–12 chewable tabs)'),
        ],
      ),
      DoseSection(
        heading: 'Antacid:',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('Liquid (400 mg/5 mL): 2.5–5 mL/dose PO once daily–QID'),
          DoseLine('Tabs: 400 mg PO once daily–QID'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Liquid (400 mg/5 mL): 5–15 mL/dose PO once daily–QID'),
          DoseLine('Concentrated liquid (800 mg/5 mL): 2.5–7.5 mL/dose PO once daily–QID'),
          DoseLine('Tabs: 400–1200 mg/dose PO once daily–QID'),
        ],
      ),
    ],
    remarks: [
      'See Magnesium Citrate. Use with caution in renal insufficiency (monitor '
          'magnesium level) and patients receiving digoxin. Drink a full 8 oz of '
          'liquid with each dose of the chewable tablets.',
      'Pedia-Lax chewable tablet is magnesium hydroxide. However, other dosage '
          'forms bearing the Pedia-Lax name (e.g., oral liquid, suppository, and '
          'enema) contain different active ingredients.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1089–1090',
  ),
  // MAGNESIUM OXIDE — PDF p. 281 (printed 1090)
  DrugEntryV3(
    name: 'MAGNESIUM OXIDE',
    brandNames: 'Mag-200 and other generics\n60.32% Elemental Magnesium',
    drugClass: 'Oral magnesium salt',
    iconRow: '',
    formulations: [
      'Tabs (OTC): 100, 200, 250, 400, 420, 500 mg',
      'Caps (OTC): 300, 500 mg',
      'Chewable gummies (OTC): 200, 250 mg',
      '400 mg magnesium oxide is equivalent to 241.3 mg elemental Mg or 20 mEq '
          'Mg.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Doses expressed in magnesium oxide salt.',
      ),
      DoseSection(
        heading: 'Magnesium supplementation:',
        lines: [
          DoseLine('Child: 5–10 mg/kg/24 hr PO ÷ TID–QID'),
          DoseLine('Adult: 400–800 mg/24 hr PO ÷ BID–QID'),
        ],
      ),
      DoseSection(
        heading: 'Hypomagnesemia:',
        lines: [
          DoseLine('Child: 65–130 mg/kg/24 hr PO ÷ QID'),
          DoseLine('Adult: 2000 mg/24 hr ÷ PO QID'),
        ],
      ),
    ],
    remarks: [
      'See Magnesium Citrate. Use with caution in renal insufficiency (monitor '
          'magnesium level) and patients receiving digoxin. For dietary recommended '
          'intake (U.S. recommended daily allowance [RDA]) for magnesium, see '
          'Chapter 21.',
    ],
    pregnancyNote: 'Pregnancy category is “A” for doses up to 400 mg/24 hr.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1090',
  ),
  // MAGNESIUM SULFATE — PDF p. 281–282 (printed 1090–1091)
  DrugEntryV3(
    name: 'MAGNESIUM SULFATE',
    brandNames: 'Epsom salts, many others, and generics 9.9% Elemental Magnesium',
    drugClass: 'Magnesium salt',
    iconRow: '',
    formulations: [
      'Injection: 500 mg/mL (4 mEq/mL) (2, 10, 20, 50 mL); must be diluted '
          'before use',
      'Injection, prediluted in sterile water for injection; ready to use: 40 '
          'mg/mL (0.325 mEq/mL) (50, 100, 500, 1000 mL); 80 mg/mL (0.65 mEq/mL) (50 '
          'mL)',
      'Injection, prediluted in D₅W; ready to use: 10 mg/mL (0.081 mEq/mL) (100 '
          'mL)',
      'Granules (Epsom salts and generics): Approx. 40 mEq Mg per 5 g (454, 1810 '
          'g)',
      '500 mg magnesium sulfate is equivalent to 49.3 mg elemental Mg or 4.1 mEq '
          'Mg.',
    ],
    doseSections: [
      DoseSection(
        heading: 'All doses expressed in magnesium sulfate salt.',
      ),
      DoseSection(
        heading: 'Cathartic:',
        lines: [
          DoseLine('Child: 0.25 g/kg/dose PO Q4–6 hr'),
          DoseLine('Adult: 10–30 g/dose PO Q4–6 hr'),
        ],
      ),
      DoseSection(
        heading: 'Hypomagnesemia or hypocalcemia:',
        lines: [
          DoseLine('IV/IM: 25–50 mg/kg/dose Q4–6 hr × 3–4 doses; repeat PRN. Max. single '
              'dose: 2 g'),
          DoseLine('PO: 100–200 mg/kg/dose QID'),
        ],
      ),
      DoseSection(
        heading: 'Daily maintenance for parenteral nutrition:',
        lines: [
          DoseLine('30–60 mg/kg/24 hr OR 0.25–0.5 mEq/kg/24 hr IV; max. dose: 1 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adjunctive therapy for moderate to severe reactive airway disease '
            'exacerbation (bronchodilation); some recommend an IV saline bolus '
            'prior to magnesium administration to prevent hypotension:',
        lines: [
          DoseLine('Child: 25–75 mg/kg/dose (max. dose: 2 g) × 1 IV over 20 min'),
          DoseLine('Adult: 2 g/dose × 1 IV over 20 min'),
        ],
      ),
    ],
    remarks: [
      'When magnesium sulfate is given IV, beware of hypotension, bradycardia, '
          'respiratory depression, complete heart block, and/or hypermagnesemia. '
          'Calcium gluconate (IV) should be available as antidote. Use with caution '
          'in patients with renal insufficiency (monitor magnesium levels) and with '
          'patients on digoxin. Serum level–dependent toxicity includes the '
          'following: >3 mg/dL: CNS depression; >5 mg/dL: decreased deep tendon '
          'reflexes, flushing, somnolence; and >12 mg/dL: respiratory paralysis, '
          'heart block.',
      'Max. IV intermittent infusion rate:',
      'Emergent situations: 1 mEq/kg/hr or 125 mg MgSO₄ salt/kg/hr',
      'Asymptomatic hypomagnesemia: 0.1 mEq/kg/hr or 12.5 mg MgSO₄ salt/kg/hr',
    ],
    pregnancyNote: 'Pregnancy category is “D” because hypocalcemia, osteopenia, and '
        'fractures in the developing baby or fetus have been reported in '
        'pregnant women receiving magnesium >5–7 days for preterm labor.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1090–1091',
  ),
  // MANNITOL — PDF p. 282–283 (printed 1091–1092)
  DrugEntryV3(
    name: 'MANNITOL',
    brandNames: 'Osmitrol, and generics, inhalation: Bronchitol and Aridol',
    drugClass: 'Osmotic diuretic',
    iconRow: '',
    formulations: [
      'Injection: 100 mg/mL (10%) (500 mL); 200 mg/mL (20%) (250, 500 mL); 250 '
          'mg/mL (25%) (50 mL)',
      'Inhalation powder in capsules:',
      'Bronchitol: 40 mg (10s, 140s, 560s with 1, 1, and 4 inhalers, '
          'respectively)',
      'Aridol (graduated dose kit in 3 blister packs):',
      'Blister pack 1: one capsule each of 0, 5, 10, and 20 mg marked 1, 2, 3, '
          'and 4, respectively',
      'Blister pack 2: 40-mg capsules marked as 5 (one capsule), 6 (two '
          'capsules), and 7 (four capsules)',
      'Blister pack 3: 40-mg capsules marked as 8 and 9 (both containing four '
          'capsules)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Intracranial pressure reduction (see remarks):',
        lines: [
          DoseLine('0.25–1 g/kg/dose IV/IO over 20–30 min; may repeat dose if needed'),
        ],
      ),
      DoseSection(
        heading: 'Inhalational use (see remarks):',
        lines: [
          DoseLine(
            'Cystic fibrosis maintenance (Bronchitol; after passing tolerance test):',
            isHeading: true,
          ),
          DoseLine('Child ≥6 yr and adult (limited data <18 yr): Inhale the contents of 10 '
              'capsules (400 mg) BID (every morning and 2–3 hr before bedtime). Use an '
              'inhaled short-acting bronchodilator 5–15 min prior to each dose.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in severe renal disease, active intracranial bleed, '
          'dehydration (especially severe hypovolemia), prior hypersensitivity to '
          'mannitol, and pulmonary edema. May cause circulatory overload and '
          'electrolyte disturbances. For hyperosmolar therapy, keep serum osmolality '
          'at 310–320 mOsm/kg. Do not use with aminoglycosides as this may enhance '
          'nephrotoxicity risk.',
      'Larger doses may require fluid bolus to prevent hypotension. May cause '
          'hypovolemia, headache, acute kidney injury, and polydipsia. Reduction in '
          'ICP occurs in 15 min and lasts 3–6 hr.',
      'Caution: Drug may crystallize at low temperatures with concentrations '
          '≥15%; redissolve crystals by warming solution up to 70°C with agitation. '
          'Use an in-line filter (≤5 micron).',
      'INHALED USE (Bronchitol): Do not puncture the capsule more than once and '
          'do not swallow capsule. Use an inhaled bronchodilator prior to each dose. '
          'Patients are instructed to exhale fully first, then place inhaler device '
          'in the mouth by closing the lips around the mouthpiece, and take a '
          'steady, deep breath, inhaling the contents of the capsule, followed by '
          'holding the breath for 5 sec before exhaling. Repeat the process again if '
          'powder is still left. Each inhaler device should be replaced after 7 days '
          'of use. Use of this product is contraindicated if the patient fails the '
          'Bronchitol Tolerance Test (BTT); see product information for testing '
          'procedure and passing criteria. Common side effects from the BTT include '
          'nausea, retching, chest discomfort, dizziness, headache, cough, dyspnea, '
          'respiratory tract pain, nasal discharge, throat irritation, and wheezing. '
          'Common side effects during maintenance therapy include arthralgia, cough, '
          'throat pain, pulmonary bacterial infection (positive sputum), and fever. '
          'Aridol product is indicated for the assessment of bronchial '
          'hyperresponsiveness in children ≥6 yr and adults.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1091–1092',
  ),
  // MEBENDAZOLE — PDF p. 283–284 (printed 1092–1093)
  DrugEntryV3(
    name: 'MEBENDAZOLE',
    brandNames: 'Emverm; previously available as Vermox',
    drugClass: 'Anthelmintic',
    iconRow: '',
    formulations: [
      'Chewable tabs: 100 mg (may be swallowed whole or chewed); contains '
          'saccharin',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child (≥2 yr) and adult:',
        lines: [
          DoseLine('Pinworms (Enterobius): 100 mg PO × 1, repeat in 2 wk if not cured.'),
          DoseLine('Hookworms, roundworms (Ascaris), and whipworm (Trichuris): 100 mg PO BID '
              '× 3 days. Repeat in 3–4 wk if not cured. Alternatively, may administer '
              '500 mg PO × 1 and repeat in 3–4 wk if not cured.'),
          DoseLine('Capillariasis: 200 mg PO BID × 20–30 days'),
          DoseLine('Visceral larva migrans (toxocariasis): 100–200 mg PO BID × 5 days'),
          DoseLine('Trichinellosis (Trichinella spiralis): 200–400 mg PO TID × 3 days, then '
              '400–500 mg PO TID × 10 days; use with steroids for severe symptoms'),
          DoseLine('See latest edition of the AAP Red Book for additional information.'),
        ],
      ),
    ],
    remarks: [
      'Experience in children <2 yr and pregnancy is limited. May cause rash, '
          'headache, diarrhea, and abdominal cramping in cases of massive infection. '
          'Liver function test elevations and hepatitis have been reported with '
          'prolonged courses; monitor hepatic function with prolonged therapy.',
      'Family may need to be treated as a group. Therapeutic effect may be '
          'decreased if administered to patients receiving aminoquinolones, '
          'carbamazepine, or phenytoin. Cimetidine may increase the effects/toxicity '
          'of mebendazole. Avoid taking with metronidazole as this my cause serious '
          'skin reactions. Administer with food. Tablet may be crushed and mixed '
          'with food, swallowed whole, chewed, or turned into a soft mass by adding '
          '2–3 mL of water to a spoon, then placing the tablet into the water (which '
          'can then be swallowed).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1092–1093',
  ),
  // MEDROXYPROGESTERONE — PDF p. 284–285 (printed 1093–1094)
  DrugEntryV3(
    name: 'MEDROXYPROGESTERONE',
    brandNames: 'Depo-Provera, Provera, Depo-Sub Q Provera 104, and generics',
    drugClass: 'Contraceptive, progestin',
    iconRow: '',
    formulations: [
      'Tabs (Provera and generics): 2.5, 5, 10 mg',
      'Injection, suspension as acetate for IM USE ONLY:',
      'Depo-Provera and generics: 150 mg/mL (1 mL and 1-mL prefilled syringe), '
          '400 mg/mL (2.5 mL); may contain parabens and polyethylene glycol',
      'Injection, prefilled syringe as acetate for SC USE ONLY:',
      'Depo-Sub Q Provera 104: 104 mg (0.65 mL of 160 mg/mL); contains parabens '
          'and polyethylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Adolescent and adult:',
        lines: [
          DoseLine('Contraception: Initiate therapy during the first 5 days after onset of a '
              'normal menstrual period; within 5 days postpartum if not breastfeeding; '
              'or if breastfeeding, at 6 wk postpartum. When converting contraceptive '
              'method to Depo-Sub Q Provera 104, administer dose within 7 days after the '
              'last day of using the previous method (pill, ring, patch).'),
          DoseLine('IM (Depo-Provera and generics): 150 mg Q3 mo (every 13 wk)'),
          DoseLine('SC (Depo-Sub Q Provera 104): 104 mg Q3 mo (every 12–14 wk)'),
          DoseLine('Amenorrhea: 5–10 mg PO once daily × 5–10 days'),
          DoseLine('Abnormal uterine bleeding: 5–10 mg PO once daily × 5–10 days initiated on '
              'the 16th or 21st day of the menstrual cycle'),
          DoseLine('Endometriosis-associated pain (Depo-Sub Q Provera 104): 104 mg SC Q3 mo. '
              'Do not use longer than 2 yr due to impact on bone mineral density.'),
        ],
      ),
    ],
    remarks: [
      'Consider patient’s risk for osteoporosis because of the potential for '
          'decrease in bone mineral density with long-term use. Contraception use '
          'for >2 yr is NOT recommended. Contraindicated in pregnancy, breast or '
          'genital cancer, liver disease, missed abortion, thrombophlebitis, '
          'thromboembolic disorders, cerebral vascular disease, and undiagnosed '
          'vaginal bleeding. Use with caution in patients with family history of '
          'breast cancer, depression, diabetes, and fluid retention. May cause '
          'dizziness, headache, insomnia, fatigue, nausea, weight increase, appetite '
          'changes, amenorrhea, and breakthrough bleeding. Cholestatic jaundice, '
          'adrenal suppression, anaphylaxis, and increased intracranial pressure '
          'have been reported. Injection site reactions may include pain/tenderness, '
          'persistent atrophy/indentation/dimpling, lipodystrophy, sterile abscess, '
          'skin color change, and node/lump.',
      'Drug is a substrate to cytochrome P-450 3A4 isoenzyme. Aminoglutethimide '
          'may decrease medroxyprogesterone levels. May alter thyroid and liver '
          'function tests; prothrombin time; factors VII, VIII, IX, and X; and '
          'metyrapone test.',
      'The WHO recommends the injectable depot medroxyprogesterone should not be '
          'used before 6 wk postpartum.',
      'Do not inject IM or SC product intravenously. Shake IM injection vial '
          'well before use, and administer in the upper arm or buttock. Administer '
          'SC injection product into the anterior thigh or abdomen. Administer oral '
          'doses with food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1093–1094',
  ),
  // MEFLOQUINE HCL — PDF p. 285 (printed 1094)
  DrugEntryV3(
    name: 'MEFLOQUINE HCL',
    brandNames: 'Generics; previously available as Lariam',
    drugClass: 'Antimalarial',
    iconRow: '',
    formulations: [
      'Tabs: 250 mg (228 mg base)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Doses expressed in mg mefloquine HCl salt.',
      ),
      DoseSection(
        heading: 'Malaria prophylaxis (start ≥2 wk prior to exposure and continue for 4 '
            'wk after leaving endemic area; see remarks):',
        lines: [
          DoseLine(
            'Child (PO, administered Q7 days):',
            isHeading: true,
          ),
          DoseLine('<10 kg: 5 mg/kg'),
          DoseLine('10–19 kg: 62.5 mg (¼ tablet)'),
          DoseLine('20–30 kg: 125 mg (½ tablet)'),
          DoseLine('31–45 kg: 187.5 mg (¾ tablet)'),
          DoseLine('>45 kg: 250 mg (1 tablet)'),
          DoseLine('Adult: 250 mg PO Q7 days'),
        ],
      ),
      DoseSection(
        heading: 'Malaria treatment (uncomplicated/mild infection, '
            'chloroquine-resistant Plasmodium vivax; used in combination with '
            'other agents):',
        lines: [
          DoseLine('Child ≥6 mo and >5 kg: 15 mg/kg (max. dose: 750 mg) PO × 1 followed by 10 '
              'mg/kg (max. dose: 500 mg) PO × 1 6–12 hr later'),
          DoseLine('Adult: 750 mg PO × 1 followed by 500 mg PO × 1 6–12 hr later'),
          DoseLine('See latest edition of the Red Book for additional information.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in active or recent history of depression, anxiety '
          'disorders, psychosis or schizophrenia, seizures, or hypersensitivity to '
          'quinine or quinidine. Use with caution in cardiac dysrhythmias and '
          'neurologic disease. May cause dizziness, ringing of the ears, headache, '
          'syncope, psychiatric symptoms (e.g., anxiety, paranoia, depression, '
          'hallucinations, and psychotic behavior), seizures, ocular abnormalities, '
          'GI symptoms, leukopenia, and thrombocytopenia. If neurologic or '
          'psychiatric side effects occur, discontinue therapy and use an '
          'alternative medication. Most adverse events occur within 3 doses with '
          'prophylaxis use. Monitor liver enzymes and ocular exams for therapies >1 '
          'yr.',
      'Mefloquine is a substrate and inhibitor of P-glycoprotein and may reduce '
          'valproic acid levels. ECG abnormalities may occur when used in '
          'combination with quinine, quinidine, chloroquine, halofantrine, and '
          'β-blockers. If any of the aforementioned antimalarial drugs is used in '
          'the initial treatment of severe malaria, initiate mefloquine at least 12 '
          'hr after the last dose of any of these drugs. Do not initiate '
          'halofantrine or ketoconazole within 15 days of the last dose of '
          'mefloquine. Use with chloroquine may increase risk for seizures. Rifampin '
          'may decrease mefloquine levels.',
      'Do not take on an empty stomach. Administer with at least 240 mL (8 oz) '
          'water. Treatment failures in children may be related to vomiting of '
          'administered dose. If vomiting occurs less than 30 min after the dose, '
          'administer a second full dose. If vomiting occurs 30–60 min after the '
          'dose, administer an additional half-dose. If vomiting continues, monitor '
          'patient closely and consider alternative therapy.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1094',
  ),
  // MEROPENEM — PDF p. 286–287 (printed 1095–1096)
  DrugEntryV3(
    name: 'MEROPENEM',
    brandNames: 'Generics; previously available as Merrem',
    drugClass: 'Carbapenem antibiotic',
    iconRow: '',
    formulations: [
      'Injection: 0.5, 1, 2 g; contains 3.92 mEq Na/g drug',
      'Injection, in a duplex chamber to be diluted in supplied sodium chloride '
          'for injection:',
      '500 mg in 50 mL; contains 10.7 mEq Na per 500 mg drug when diluted',
      '1000 mg in 50 mL; contains 12.6 mEq Na per 1000 mg drug when diluted',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate and infant <3 mo (IV):',
        lines: [
          DoseLine(
            'Non-CNS general dosing (meropenem MIC <4):',
            isHeading: true,
          ),
          DoseLine(
            '≤2 kg:',
            isHeading: true,
          ),
          DoseLine('≤14 days old: 20 mg/kg/dose Q12 hr'),
          DoseLine('15–28 days old: 20 mg/kg/dose Q8 hr'),
          DoseLine('29–60 days old: 30 mg/kg/dose Q8 hr'),
          DoseLine(
            '>2 kg:',
            isHeading: true,
          ),
          DoseLine('≤14 days old: 20 mg/kg/dose Q8 hr'),
          DoseLine('15–60 days old: 30 mg/kg/dose Q8 hr'),
          DoseLine(
            'Non-CNS infection with moderately resistant meropenem isolate (MIC 4–8 '
                'mCg/mL; consider infusing dose over 4 hr to enhance the time above the '
                'MIC):',
            isHeading: true,
          ),
          DoseLine(
            '≤2 kg:',
            isHeading: true,
          ),
          DoseLine('≤14 days old: 40 mg/kg/dose Q12 hr'),
          DoseLine('15–60 days old: 40 mg/kg/dose Q8 hr'),
          DoseLine(
            '>2 kg:',
            isHeading: true,
          ),
          DoseLine('≤60 days old: 40 mg/kg/dose Q8 hr'),
          DoseLine(
            'Intra-abdominal infection (meropenem MIC <4 mCg/mL):',
            isHeading: true,
          ),
          DoseLine(
            '<32 wk gestation:',
            isHeading: true,
          ),
          DoseLine('<14 days old: 20 mg/kg/dose Q12 hr'),
          DoseLine('≥14 days old: 20 mg/kg/dose Q8 hr'),
          DoseLine(
            '≥32 wk gestation:',
            isHeading: true,
          ),
          DoseLine('<14 days old: 20 mg/kg/dose Q8 hr'),
          DoseLine('≥14 days old: 30 mg/kg/dose Q8 hr'),
          DoseLine(
            'Meningitis (limited data):',
            isHeading: true,
          ),
          DoseLine(
            '≤2 kg:',
            isHeading: true,
          ),
          DoseLine('≤14 days old: 40 mg/kg/dose Q12 hr'),
          DoseLine('15–60 days old: 40 mg/kg/dose Q8 hr'),
          DoseLine(
            '>2 kg:',
            isHeading: true,
          ),
          DoseLine('≤60 days old: 40 mg/kg/dose Q8 hr'),
          DoseLine('1–3 mo; recommendation from 2004 IDSA meningitis practice guidelines: 40 '
              'mg/kg/dose Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Infant (≥3 mo), child, and adolescent (IV):',
        lines: [
          DoseLine('Meningitis, severe infections, and cystic fibrosis pulmonary '
              'exacerbations: 40 mg/kg/dose (max. dose: 2 g/dose) Q8 hr'),
          DoseLine('Complicated skin and skin structure infection: 10 mg/kg/dose (max. dose: '
              '500 mg/dose) Q8 hr. For severe or necrotizing infections or Pseudomonas '
              'aeruginosa infection (suspected or confirmed), use 20 mg/kg/dose (max. '
              'dose: 1 g/dose) Q8 hr.'),
          DoseLine(
            'Intra-abdominal and mild/moderate infections, and fever/neutropenia '
                'empiric therapy:',
            isHeading: true,
          ),
          DoseLine('20 mg/kg/dose (max. dose: 1 g/dose) Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult (IV):',
        lines: [
          DoseLine('Skin and subcutaneous tissue infections: 500 mg Q8 hr; use 1 g Q8 hr for '
              'suspected or confirmed Pseudomonas aeruginosa'),
          DoseLine(
            'Intra-abdominal and mild/moderate infections; and fever/neutropenia '
                'empiric therapy:',
            isHeading: true,
          ),
          DoseLine('1 g Q8 hr'),
          DoseLine('Meningitis and severe infections: 2 g Q8 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in patients sensitive to carbapenems, or with a history '
          'of anaphylaxis to β-lactam antibiotics. Use with caution in meningitis '
          'and CNS disorders (may cause seizures) and renal impairment (adjust dose; '
          'see Chapter 32). Drug penetrates well into the CSF.',
      'May cause diarrhea, rash, nausea, vomiting, oral moniliasis, glossitis, '
          'pain and irritation at the IV injection site, and headache. Hepatic '
          'enzyme and bilirubin elevation, dermatologic reactions (including '
          'Stevens-Johnson syndrome, DRESS, and TEN), leukopenia, thrombocytopenia '
          '(in renal dysfunction), neutropenia, and rhabdomyolysis have been '
          'reported. Probenecid may increase serum meropenem levels. May reduce '
          'valproic acid levels.',
      'Lengthening the IV drug administration time to 4 hr will improve the '
          'meropenem concentration time above the MIC and may be useful in '
          'situations of resistant organisms.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1095–1096',
  ),
  // MESALAMINE — PDF p. 287–288 (printed 1096–1097)
  DrugEntryV3(
    name: 'MESALAMINE',
    brandNames: 'Apriso, Canasa, Delzicol, Lialda, Pentasa, Rowasa, SfRowasa, and '
        'generics; 5-aminosalicylic acid, 5-ASA',
    drugClass: 'Salicylate, GI anti-inflammatory agent',
    iconRow: '',
    formulations: [
      'Caps, controlled release:',
      'Pentasa: 250, 500 mg',
      'Delzicol and generics: 400 mg',
      'Apriso and generics (for Q24 hr dosing): 375 mg; contains aspartame',
      'Tabs, delayed release:',
      'Generics: 800, 1200 mg',
      'Lialda: 1200 mg',
      'Suppository (Canasa and generics): 1000 mg (1, 30s)',
      'Rectal suspension enema (Rowasa, SfRowasa, and generics): 4 g/60 mL; '
          'contains sulfites (SfRowasa is sulfite free), EDTA and sodium benzoate',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child and adolescent (mild/moderate ulcerative colitis):',
        lines: [
          DoseLine('Caps (controlled release) and tabs (delayed release): 60–80 mg/kg/24 hr '
              'PO ÷ once daily–BID (defined by dosage form used); max. dose: 4.8 g/24 hr'),
          DoseLine(
            'Delzicol (mild/moderate ulcerative colitis treatment for 6 wk; ≥5–18 yr; '
                'see remarks):',
            isHeading: true,
          ),
          DoseLine('17–32 kg: 800 mg PO QAM and 400 mg PO Q afternoon'),
          DoseLine('33–53 kg: 1200 mg PO QAM and 800 mg PO Q afternoon'),
          DoseLine('54–90 kg: 1200 mg PO QAM and Q afternoon'),
          DoseLine(
            'Lialda (mild/moderate ulcerative colitis; child and adolescent ≥24 kg):',
            isHeading: true,
          ),
          DoseLine('24–35 kg: 2400 mg PO once daily × 8 wk, then decrease to 1200 mg PO once '
              'daily'),
          DoseLine('>35–50 kg: 3600 mg PO once daily × 8 wk, then decrease to 2400 mg PO once '
              'daily'),
          DoseLine('>50 kg: 4800 mg PO once daily × 8 wk, then decrease to 2400 mg PO once '
              'daily'),
        ],
      ),
      DoseSection(
        heading: 'Older child and adolescent (mild/moderate ulcerative colitis; see '
            'remarks):',
        lines: [
          DoseLine('Enema (Rowasa): 25 mg/kg/dose (max. dose: 1 g/dose) PR once daily; doses '
              'greater than 1 g are not more effective'),
        ],
      ),
      DoseSection(
        heading: 'Adult (mild/moderate ulcerative colitis; see remarks):',
        lines: [
          DoseLine(
            'Caps, controlled release:',
            isHeading: true,
          ),
          DoseLine('Initial therapy: 1 g PO QID × 3–8 wk'),
          DoseLine('Delzicol: 800 mg PO TID × 6 wk'),
          DoseLine(
            'Maintenance therapy for remission:',
            isHeading: true,
          ),
          DoseLine('Apriso: 1.5 g PO QAM'),
          DoseLine('Delzicol: 1.6 g/24 hr PO divided BID–QID'),
          DoseLine('Pentasa: 1 g PO QID'),
          DoseLine(
            'Tabs, delayed release:',
            isHeading: true,
          ),
          DoseLine(
            'Initial therapy:',
            isHeading: true,
          ),
          DoseLine('Lialda: 2.4–4.8 g PO once daily up to 8 wk'),
          DoseLine(
            'Maintenance therapy for remission:',
            isHeading: true,
          ),
          DoseLine('Generic: At least 2 g PO once daily'),
          DoseLine('Lialda: 2.4 g PO once daily'),
          DoseLine('Suppository (ulcerative proctitis): 1000 mg PR QHS × 3–6 wk; retain each '
              'dose in the rectum for 1–3 hr or longer, if possible'),
          DoseLine('Rectal suspension (ulcerative colitis or proctitis): 60 mL (4 g) PR QHS × '
              '3–6 wk, retaining each dose for about 8 hr; lie on left side during '
              'administration to improve delivery to the sigmoid colon'),
        ],
      ),
    ],
    remarks: [
      'Generally not recommended in children <16 yr with chickenpox or flu-like '
          'symptoms (risk of Reye syndrome). Contraindicated in active peptic ulcer '
          'disease, severe renal failure, and salicylate hypersensitivity. Rectal '
          'suspension should not be used in patients with history of sulfite '
          'allergy. Use with caution in sulfasalazine hypersensitivity, impaired '
          'hepatic or renal function, pyloric stenosis, nephrotoxic medications, and '
          'concurrent thrombolytics. May cause headache, GI discomfort, '
          'pancreatitis, pericarditis, and rash. Angioedema, Stevens-Johnson '
          'syndrome, DRESS, fatal infections (e.g., sepsis and pneumonia; '
          'discontinue use), interstitial nephritis, renal failure, nephrolithiasis, '
          'hepatic disorders (including failure), and photosensitivity have been '
          'reported. May cause a false-positive urinary normetanephrine test. '
          'Patient’s urine may become discolored reddish-brown when the medication '
          'comes in contact with surfaces or water treated with '
          'hypochlorite-containing bleach.',
      'Safety and efficacy of Delzicol in children 5–17 yr for mild/moderate '
          'acute ulcerative colitis have been established over a 6-wk period; safety '
          'and efficacy for maintenance of remission of ulcerative colitis in '
          'children have not been established. Safety and efficacy of Canasa '
          'suppositories have not been demonstrated for mild/moderate active '
          'ulcerative proctitis in a 6-wk open-label study in 49 patients 5–17 yr '
          'old.',
      'Do not administer with lactulose or other medications that can lower '
          'intestinal pH. Use with myelosuppressive drugs (e.g., azathioprine, '
          '6-mercaptopurine) may increase risk for blood disorders, bone marrow '
          'failure, and associated complications.',
      'Two Delzicol 400-mg capsules have not been shown to be interchangeable or '
          'substitutable with one mesalamine 800-mg delayed-release tablet. Oral '
          'capsules are designed to release medication throughout the GI tract, and '
          'oral tablets release medication at the terminal ileus and beyond; 400 mg '
          'mesalamine PO is equivalent to 1 g sulfasalazine PO. Tablets should be '
          'swallowed whole.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1096–1097',
  ),
  // METFORMIN — PDF p. 289–290 (printed 1098–1099)
  DrugEntryV3(
    name: 'METFORMIN',
    brandNames: 'Riomet and generics; previously available as Glucophage and '
        'Glucophage XR',
    drugClass: 'Antidiabetic, biguanide',
    iconRow: '',
    formulations: [
      'Tabs: 500, 625, 750, 850, 1000 mg',
      'Tabs, extended release: 500, 750, 1000 mg',
      'Oral suspension (Riomet and generics): 100 mg/mL (118, 473 mL); may '
          'contain saccharin and propylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Type 2 diabetes:',
        lines: [
          DoseLine('Administer all doses with meals (e.g., BID: morning and evening meals).'),
          DoseLine(
            'Child 10–16 yr (PO) (see remarks):',
            isHeading: true,
          ),
          DoseLine('Immediate-release dosage forms: Start with 500 mg BID; may increase dose '
              'every 1–2 wk as tolerated by 500 mg/24 hr in 2 divided doses up to a max. '
              'dose of 2000 mg/24 hr.'),
          DoseLine('Extended-release tabs (limited data): Start with 500–1000 mg once daily × '
              '7 days; may increase dose every 1–2 wk as tolerated by 500 mg/24 hr as '
              'once daily or divided doses up to a max. dose of 2000 mg/24 hr.'),
          DoseLine(
            'Child ≥17 yr and adult (PO) (see remarks):',
            isHeading: true,
          ),
          DoseLine('500-mg immediate-release tabs: Start with 500 mg BID; may increase dose '
              'weekly by 500 mg/24 hr in 2 divided doses up to a max. dose of 2500 mg/24 '
              'hr. Administer 2500 mg/24 hr doses by dividing daily dose TID with meals.'),
          DoseLine('850-mg immediate-release tabs: Start with 850 mg once daily with morning '
              'meal; may increase by 850 mg every 2 wk up to a max. dose of 2550 mg/24 '
              'hr (first dosage increment: 850 mg BID; second dosage increment: 850 mg '
              'TID).'),
          DoseLine('Extended-release tabs: Start with 500 mg once daily with evening meal; '
              'may increase by 500 mg every wk up to a max. dose of 2000 mg/24 hr (if '
              'glycemic control is not achieved at max. dose, divide dose to 1000 mg '
              'BID). If a dose >2000 mg is needed, consider switching to '
              'non–extended-release tablets in divided doses and increase dose to a max. '
              'dose of 2550 mg/24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Assess patient’s eGFR prior to initiating therapy. Contraindicated in '
          'severe renal impairment (<30 mL/min/1.73 m²), hepatic impairment '
          '(increased risk for lactic acidosis), CHF, and metabolic acidosis and '
          'during radiology studies using iodinated contrast media. Use with caution '
          'when transferring patients from chlorpropamide therapy (potential '
          'hypoglycemia risk), excessive alcohol intake, hypoxemia, dehydration, '
          'surgical procedures, mild/moderate renal impairment, hepatic disease, '
          'anemia, and thyroid disease.',
      'Fatal lactic acidosis (diarrhea; severe muscle pain, cramping; shallow '
          'and fast breathing; unusual weakness and sleepiness) and decrease in '
          'vitamin B₁₂ levels have been reported. May cause GI discomfort (~50% '
          'incidence), anorexia, and vomiting. Transient abdominal discomfort or '
          'diarrhea has been reported in 40% of pediatric patients. Organic cationic '
          'transporter-2 (OCT2) and multidrug and toxin extrusion (MATE) inhibitors '
          '(e.g., cimetidine), furosemide, and nifedipine may increase the '
          'effects/toxicity of metformin. In addition to monitoring serum glucose '
          'and glycosylated hemoglobin, monitor renal function and hematologic '
          'parameters (baseline and annual).',
      'Adult patients initiated on 500 mg PO BID may also have their dose '
          'increased to 850 mg PO BID after 2 wk.',
      'COMBINATION THERAPY WITH SULFONYLUREAS: If patient has not responded to 4 '
          'wk of maximum doses of metformin monotherapy, consider gradual addition '
          'of an oral sulfonylurea with continued maximum metformin dosing (even if '
          'failure with sulfonylurea has occurred). Attempt to identify the minimum '
          'effective dose for each drug (metformin and sulfonylurea) because the '
          'combination can increase risk for sulfonylurea-induced hypoglycemia. If '
          'patient does not respond to 1–3 mo of combination therapy with maximum '
          'metformin doses, consider discontinuing combination therapy and '
          'initiating insulin therapy.',
      'Administer all doses with food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1098–1099',
  ),
  // METHADONE HCL — PDF p. 290 (printed 1099)
  DrugEntryV3(
    name: 'METHADONE HCL',
    brandNames: 'Methadose and generics; previously available as Dolophine',
    drugClass: 'Narcotic, analgesic',
    iconRow: '',
    formulations: [
      'Tabs: 5, 10 mg',
      'Tabs, dispersible (Methadose and generics): 40 mg',
      'Oral solution: 5 mg/5 mL (500 mL), 10 mg/5 mL (500 mL); contains 8% '
          'alcohol',
      'Concentrated oral solution (Methadose and generics): 10 mg/mL (30, 1000 '
          'mL); may contain propylene glycol and parabens and may be sugar free',
      'Injection: 10 mg/mL (20 mL), contains 0.5% chlorobutanol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Analgesia (initial doses; see remarks):',
        lines: [
          DoseLine('Child: 0.7 mg/kg/24 hr PO, SC, IM, or IV ÷ Q4–6 hr PRN pain; max. dose: '
              '10 mg/dose'),
          DoseLine('Adult: 2.5–10 mg/dose PO, SC, IM, or IV Q8–12 hr PRN pain'),
        ],
      ),
      DoseSection(
        heading: 'Detoxification or maintenance: See package insert.',
      ),
    ],
    remarks: [
      'Unintentional overdoses have resulted in fatalities and severe adverse '
          'events such as respiratory depression and cardiac arrhythmias. Use with '
          'caution in hepatic (avoid in severe cases) and biliary tract impairment. '
          'May cause respiratory depression, sedation, increased intracranial '
          'pressure, hypotension, and bradycardia. Cardiac Q–T interval prolongation '
          'and serious arrhythmias have occurred mostly with higher doses; avoid use '
          'with other medications that may prolong Q–T interval. Nystagmus, '
          'strabismus, hypoglycemia, hypokalemia, hypomagnesemia, and weight gain '
          'have been reported.',
      'Average T₁/₂: Children 19 hr, and adults 35 hr. Duration of action PO is '
          '6–8 hr initially and 22–48 hr after repeated doses. Respiratory effects '
          'last longer than analgesia. Accumulation may occur with continuous use, '
          'making it necessary to adjust dose.',
      'Nevirapine may decrease serum levels of methadone. Fatalities have been '
          'reported with abuse in combination with benzodiazepines. Serotonin '
          'syndrome has been reported with use with selective serotonin reuptake '
          'inhibitors (SSRIs), serotonin norepinephrine reuptake inhibitor (SNRIs), '
          'TCAs, 5-HT3 antagonists, MAO inhibitors, and drugs that affect the '
          'serotonergic neurotransmitter system (e.g., trazodone, tramadol). '
          'Methadone is a substrate for cytochrome P-450 (CYP) 3A3/3A4, 2D6, and 1A2 '
          'and inhibitor of CYP2D6.',
      'See Chapter 6 for equianalgesic dosing and onset of action. Adjust dose '
          'in renal failure (see Chapter 32).',
      'A Risk Evaluation and Mitigation Strategy (REMS) is required for '
          'healthcare providers to ensure the benefits outweigh the risks of '
          'addiction, abuse, and misuse. See '
          'www.fda.gov/OpioidAnalgesicREMSBlueprint or call 1-800-503-0784.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1099',
  ),
  // METHIMAZOLE — PDF p. 291 (printed 1100)
  DrugEntryV3(
    name: 'METHIMAZOLE',
    brandNames: 'Generics; previously available as Tapazole',
    drugClass: 'Antithyroid agent',
    iconRow: '',
    formulations: [
      'Tabs: 5, 10 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hyperthyroidism:',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('Initial: 0.4–0.7 mg/kg/24 hr or 15–20 mg/m²/24 hr PO ÷ Q8 hr'),
          DoseLine('Maintenance: 1/3–2/3 of initial dose PO ÷ Q8 hr'),
          DoseLine('Max. dose: 30 mg/24 hr'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Initial: 15–60 m/24 hr PO ÷ Q8 hr'),
          DoseLine('Maintenance: 5–15 mg/24 hr PO ÷ Q8 hr'),
        ],
      ),
    ],
    remarks: [
      'Readily crosses placental membranes and distributes into breast milk '
          '(maternal doses ≤20 mg/24 hr are considered safe, but there are '
          'insufficient data to support safe use with maternal doses >20 mg/24 hr). '
          'Blood dyscrasias, dermatitis, hepatitis, arthralgia, CNS reactions, '
          'pruritus, nephritis, hypoprothrombinemia, agranulocytosis, headache, '
          'fever, and hypothyroidism may occur. Acute hepatic failure and hepatitis '
          'have been reported.',
      'May increase the effects of oral anticoagulants. When correcting '
          'hyperthyroidism, consider whether existing β-blocker, digoxin, and '
          'theophylline doses need to be reduced to avoid potential toxicities.',
      'Switch to maintenance dose when patient is euthyroid. Administer all '
          'doses with food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1100',
  ),
  // METHYLENE BLUE — PDF p. 291–292 (printed 1100–1101)
  DrugEntryV3(
    name: 'METHYLENE BLUE',
    brandNames: 'ProvayBlue and generics',
    drugClass: 'Antidote, drug-induced methemoglobinemia, and cyanide toxicity',
    iconRow: '',
    formulations: [
      'Injection 1%:',
      'Prefilled syringe: 10 mg/mL (2 mL); preservative-free',
      'Vials: 10 mg/mL (10 mL)',
      'Injection 0.5% (ProvayBlue and generics; see remarks):',
      'Ampules: 5 mg/mL (2, 10 mL)',
      'Vials: 5 mg/mL (2, 10 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Methemoglobinemia:',
        lines: [
          DoseLine('Child and adult: 1–2 mg/kg/dose or 25–50 mg/m²/dose IV/IO over 5 min. May '
              'repeat in 30–60 min if needed.'),
        ],
      ),
    ],
    remarks: [
      'At high doses, may cause methemoglobinemia. Avoid subcutaneous or '
          'intrathecal routes of administration. Use with caution in G6PD deficiency '
          'or renal insufficiency (methylene blue concentrations have increased in '
          'subjects with renal impairment). May cause nausea, vomiting, dizziness, '
          'headache, diaphoresis, stained skin, and abdominal pain. Causes '
          'blue–green discoloration of urine and feces. Additional adverse reactions '
          'from pediatric and adult clinical studies include hypokalemia, diarrhea, '
          'hypomagnesemia, myoclonus, and seizure-like phenomena.',
      'Serotonin syndrome has been reported with the coadministration of SSRI, '
          'SNRI, or clomipramine. Use with bupropion, paroxetine, sertraline, '
          'duloxetine, vilazodone, venlafaxine, fluoxetine, or desipramine is '
          'considered contraindicated.',
      'The 0.5% concentration dosage form (e.g., ProvayBlue) is hypotonic and '
          'may be diluted in 50 mL D₅W to prevent local infusion pain. Avoid '
          'diluting in sodium chloride as this may reduce the solubility of '
          'methylene blue.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1100–1101',
  ),
  // METHYLPHENIDATE HCL — PDF p. 292–295 (printed 1101–1104)
  DrugEntryV3(
    name: 'METHYLPHENIDATE HCL',
    brandNames: 'Ritalin, Aptensio XR, Jornay PM, Methylin, Metadate CD, Metadate '
        'ER, Methylin ER, Concerta, Relexxii, QuilliChew ER, Quillivant XR, '
        'Ritalin LA, Cotempla XR-ODT, Daytrana, and generics',
    drugClass: 'CNS stimulant',
    iconRow: '',
    formulations: [
      'Tabs (Ritalin and generics): 5, 10, 20 mg',
      'Chewable tabs (generics): 2.5, 5, 10 mg; contains phenylalanine',
      'Extended-release chewable tabs (dosed once daily in the morning):',
      'QuilliChew ER: 20, 30, 40 mg; contains phenylalanine',
      'Oral solution (Methylin and generics): 1 mg/mL, 2 mg/mL; may contain '
          'propylene glycol',
      'Oral suspension, extended release (dosed once daily in the morning):',
      'Quillivant XR: 25 mg/5 mL (60, 120, 150, 180 mL); contains sodium benzoate',
      'Extended-release tabs:',
      '8-hr duration (Metadate ER): 20 mg; dosed BID–TID',
      '24-hr duration:',
      'Concerta: 18, 27, 36, 54 mg',
      'Relexxii: 18, 27, 36, 45, 54, 63, 72 mg',
      'Generics: 10, 18, 20, 27, 36, 45, 54, 63, 72 mg',
      'Extended-release oral disintegrating tabs:',
      'Cotempla XR-ODT (dosed once daily in the morning): 8.6, 17.3, 25.9 mg; '
          'contains polyethylene glycol',
      'Extended-release caps:',
      '24-hr duration:',
      'Ritalin LA: 10, 20, 30, 40 mg',
      'Aptensio XR: 10, 15, 20, 30, 40, 50, 60 mg',
      'Metadate CD: 10, 20, 30, 40, 50, 60 mg',
      'Jornay PM: 20, 40, 60, 80, 100 mg (dosed only in the evening)',
      'Generics: 10, 15, 20, 30, 40, 50, 60 mg',
      'Transdermal patch (Daytrana and generics): 10 mg/9 hr (each 12.5-cm² '
          'patch contains 27.5 mg), 15 mg/9 hr (each 18.75-cm² patch contains 41.3 '
          'mg), 20 mg/9 hr (each 25-cm² patch contains 55 mg), 30 mg/9 hr (each '
          '37.5-cm² patch contains 82.5 mg) (30s)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Attention-deficit/hyperactivity disorder (ADHD):',
        lines: [
          DoseLine(
            'Immediate-release oral dosage forms (Methylin, Ritalin; ≥6 yr):',
            isHeading: true,
          ),
          DoseLine('Initial: 0.3 mg/kg/dose (or 2.5–5 mg/dose) given before breakfast and '
              'lunch. May increase by 0.1 mg/kg/dose (or 5–10 mg/24 hr) weekly until '
              'maintenance dose achieved. May give extra afternoon dose if needed.'),
          DoseLine('Maintenance dose range: 0.3–1 mg/kg/24 hr'),
          DoseLine('Max. dose: 2 mg/kg/24 hr or 60 mg/24 hr for those weighing ≤50 kg and 100 '
              'mg/24 hr >50 kg'),
          DoseLine(
            'Extended-release once-daily oral dosage form (Concerta; ≥6 yr):',
            isHeading: true,
          ),
          DoseLine('Methylphenidate-naïve patients: Start with 18 mg QAM for children and '
              'adolescents and 18–36 mg QAM for adults; dosage may be increased at '
              'weekly intervals at 18-mg increments up to the following max. dose:'),
          DoseLine('6–12 yr: 54 mg/24 hr'),
          DoseLine('13–17 yr: 72 mg/24 hr not to exceed 2 mg/kg/24 hr'),
          DoseLine('Patients weighing >50 kg: Higher max. dose of 108 mg/24 hr may be used.'),
          DoseLine('Patients currently receiving methylphenidate: See following table.'),
        ],
      ),
      DoseSection(
        heading: 'Recommended dose conversion from methylphenidate regimens to Concerta',
        table: DoseTable(
          headers: ['Previous Methylphenidate Daily Dose', 'Recommended Concerta Dose'],
          rows: [
            DoseTableRow(['5 mg PO BID–TID or 20 mg SR PO once daily', '18 mg PO QAM']),
            DoseTableRow(['10 mg PO BID–TID or 40 mg SR PO once daily', '36 mg PO QAM']),
            DoseTableRow(['15 mg PO BID–TID or 60 mg SR PO once daily', '54 mg PO QAM']),
            DoseTableRow(['20 mg PO BID–TID', '72 mg PO QAM']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('After a week of receiving the above-recommended Concerta dose, dose may '
              'be increased in 18-mg increments at weekly'),
          DoseLine('intervals PRN up to a maximum of 54 mg/24 hr for children 6–12 yr and 72 '
              'mg/24 hr (not to exceed 2 mg/kg/24 hr) for'),
          DoseLine('children 13–17 yr.'),
        ],
      ),
      DoseSection(
        heading: 'Other extended-release oral dosage forms (see specific product '
            'information if converting from another product or dosage form):',
        table: DoseTable(
          headers: ['Product (Dosage Form)', 'Initial Dose (≥6 yr)', 'Dosage Adjustment', 'Max. Dose'],
          rows: [
            DoseTableRow(['Aptensio XR (extended-release caps)', '10 mg PO once daily in the AM', 'Increase at 10-mg increments Q7 days PRN', '60 mg/24 hr']),
            DoseTableRow(['Cotempla XR-ODT (extended-release oral disintegrating tabs)ᵇ', '17.3 mg PO once daily in the AM', 'Increase at 8.6-mg or 17.3-mg increments Q7 days PRN', '51.8 mg/24 hr']),
            DoseTableRow(['Jornay PM (extended-release caps)', '20 mg PO QHS (between 6:30 and 9:30 PM; 8:00 PM was the most optimal time '
                'for children 6–12 yr in clinical trials)', 'Increase at 20-mg increments Q7 days PRN; administered QHS', '100 mg/24 hr']),
            DoseTableRow(['Metadate CD (extended-release caps)', '20 mg PO once daily', 'Increase at 10-mg to 20-mg increments Q7 days PRN', '≤50 kg: 60 mg/24 hr; >50 kg: 100 mg/24 hr']),
            DoseTableRow(['Quillivant XR (extended-release oral suspension)ᵃ', '20 mg PO once daily', 'Increase at 10-mg to 20-mg increments Q7 days PRN', '60 mg/24 hr']),
            DoseTableRow(['QuilliChew (extended-release chewable tabs)', '20 mg PO once daily', 'Increase by 10, 15, or 20 mg Q7 days PRN', 'Doses >60 mg/24 hr have not been studied']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        table: DoseTable(
          headers: ['Product (Dosage Form)', 'Initial Dose (≥6 yr)', 'Dosage Adjustment', 'Max. Dose'],
          rows: [
            DoseTableRow(['Relexxii (extended-release tabs)', '18 mg PO once daily in the AM', 'Increase by 18 mg Q7 days PRN', '6–12 yrᶜ: 54 mg/24 hr;\n13–<18 yrᶜ: lesser of 72 mg/24 hr or 2 mg/kg/24 '
                'hr;\n≥18 yr: 72 mg/24 hr']),
            DoseTableRow(['Ritalin LA (extended-release caps)', '20 mg PO once daily', 'Increase at 10-mg increments Q7 days PRN', '≤50 kg: 60 mg/24 hr; >50 kg: 100 mg/24 hr']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃQuillivant XR dosing recommendations for children 6–12 yr.'),
          DoseLine('ᵇCotempla XR ODT dosing recommendations for children 6–17 yr.'),
          DoseLine('ᶜHigher doses have not been studied for this age group.'),
        ],
      ),
      DoseSection(
        heading: 'Metadate ER (8-hr duration of action):',
        lines: [
          DoseLine('Convert to immediate-release tabs when the 8-hr dosage corresponds to the '
              'available extended-release tablet size. Usual max. dose: 60 mg/24 hr for '
              'children, but some patients >50 kg may tolerate doses up to 100 mg/24 hr '
              'with increased monitoring.'),
        ],
      ),
      DoseSection(
        heading: 'Transdermal patch (Daytrana; see remarks):',
        lines: [
          DoseLine('Apply to the hip 2 hr before the effect is needed and remove 9 hr later. '
              'Patch may be removed before 9 hr if shorter duration of effect is desired '
              'or if late-day adverse effects appear.'),
          DoseLine('6–17 yr: Start with 10 mg/9 hr patch once daily. Increase dose PRN Q7 '
              'days by increasing to the next dosage strength. Higher starting doses '
              'have been reported in patients converting from oral dosage forms >20 '
              'mg/24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in glaucoma, anxiety disorders, motor tics, and Tourette '
          'syndrome. Medication should generally not be used in children <5 yr old; '
          'diagnosis of ADHD in this age group is extremely difficult and should be '
          'done only in consultation with a specialist. Sudden death (children, '
          'adolescents, and adults), stroke (adults), and MI (adults) have been '
          'reported in patients with preexisting structural cardiac abnormalities or '
          'other serious heart problems. Use with caution in patients with '
          'hypertension, psychiatric conditions, and epilepsy. Insomnia, weight '
          'loss, anorexia, rash, nausea, emesis, abdominal pain, hypertension or '
          'hypotension, tachycardia, arrhythmias, palpitations, restlessness, '
          'headaches, fever, tremor, motor and verbal tics, increase intraocular '
          'pressure, visual disturbances, and thrombocytopenia may occur. Abnormal '
          'liver function (ranging from transaminase elevation to severe hepatic '
          'injury), cerebral arteritis and/or occlusion, peripheral vasculopathy '
          '(including Raynaud phenomenon), leukopenia and/or anemia, '
          'hypersensitivity reactions, transient depressed mood, paranoia, mania, '
          'auditory hallucination, priapism, and scalp hair loss have been reported. '
          'Skin irritation, chemical leukoderma, and contact dermatitis have been '
          'reported with transdermal route. High doses may slow growth by appetite '
          'suppression. GI obstruction has been reported with Concerta.',
      'May increase serum concentrations/effects of tricyclic antidepressants, '
          'dopamine agonists (e.g., haloperidol), phenytoin, phenobarbital, and '
          'warfarin. May decrease the effects of antihypertensive drugs. Effect of '
          'methylphenidate may be potentiated by MAO inhibitors; hypertensive crisis '
          'may also occur if used within 14 days of discontinuance of the MAO '
          'inhibitor. When used with risperidone, any dosage adjustment '
          '(increase/decrease) to either medication can result in extrapyramidal '
          'symptoms. Avoid use with halogenated anesthetics as this may increase the '
          'risk of sudden blood pressure and heart rate increase during surgery. Use '
          'with a H2-blocker or PPI is not recommended with Cotempla XR ODT.',
      'Extended/sustained-release dosage forms have either an 8- or 24-hr dosage '
          'interval (as stipulated previously). Concerta dosage form delivers 22.2% '
          'of its dose as an immediate-release product with the remaining amounts '
          'delivered as an extended-release product (e.g., 18 mg strength: 4 mg as '
          'immediate release, and 14 mg as extended release). Jornay PM is dosed '
          'only in the evening and should NOT be taken in the morning. Do not '
          'consume alcohol with Ritalin LA dosage form, because it may result in a '
          'more rapid release of the drug. Do not expose transdermal application '
          'site to external heat sources (e.g., electric blankets, heating pads); '
          'this may increase drug release.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1101–1104',
  ),
  // METHYLPREDNISOLONE — PDF p. 295–296 (printed 1104–1105)
  DrugEntryV3(
    name: 'METHYLPREDNISOLONE',
    brandNames: 'Medrol, Medrol Dosepack, Solu-Medrol, Depo-Medrol, and generics',
    drugClass: 'Corticosteroid',
    iconRow: '',
    formulations: [
      'Tabs: 2, 4, 8, 16, 32 mg',
      'Tabs, dose pack (Medrol Dosepack and generics): 4 mg (21s)',
      'Injection, Na succinate (Solu-Medrol and generics): 40, 125, 500, 1000, '
          '2000 mg (IV or IM use); multidose vials contain benzyl alcohol',
      'Injection, acetate suspension (Depo-Medrol and generics; for IM, '
          'intrasynovial, and soft tissue injection): 20 mg/mL (5 mL), 40 mg/mL (1, '
          '5, 10 mL), 80 mg/mL (1, 5 mL); contains polyethylene glycol; multidose '
          'vials contain benzyl alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Anti-inflammatory/immunosuppressive:',
        lines: [
          DoseLine('PO/IM/IV (use succinate salt for IM/IV): 0.5–1.7 mg/kg/24 hr ÷ Q6–12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Asthma exacerbations (2007 National Heart, Lung, and Blood Institute '
            'Guideline Recommendations; dose until peak expiratory flow reaches '
            '70% of predicted or personal best):',
        lines: [
          DoseLine('Child ≤12 yr (IV/IM/PO; use succinate salt for IV/IM): 1–2 mg/kg/24 hr ÷ '
              'Q12 hr (max. dose: 60 mg/24 hr). An alternative regimen for ≤5 yr old of '
              '1 mg/kg/dose Q6 hr × 24 hr followed by oral corticosteroids to complete a '
              '3-day to 5-day course has been suggested.'),
          DoseLine('Child >12 yr and adult (IV/IM/PO; use succinate salt for IV/IM): 40–60 '
              'mg/24 hr ÷ Q12–24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Outpatient asthma exacerbation burst therapy (longer durations may be '
            'necessary):',
        lines: [
          DoseLine(
            'PO:',
            isHeading: true,
          ),
          DoseLine('Child ≤12 yr: 1–2 mg/kg/24 hr ÷ Q12–24 hr (max. dose: 60 mg/24 hr) × 3–10 '
              'days'),
          DoseLine('Child >12 yr and adult: 40–60 mg/24 hr ÷ Q12–24 hr × 3–10 days'),
          DoseLine(
            'IM (use methylprednisolone acetate product) for patients vomiting or with '
                'adherence issues:',
            isHeading: true,
          ),
          DoseLine('Child ≤4 yr: 7.5 mg/kg (max. dose: 240 mg) IM × 1'),
          DoseLine('Child >4 yr, adolescent, and adult: 240 mg IM × 1'),
        ],
      ),
      DoseSection(
        heading: 'Acute spinal cord injury:',
        lines: [
          DoseLine('30 mg/kg IV over 15 min followed in 45 min by a continuous infusion of '
              '5.4 mg/kg/hr × 23 hr'),
        ],
      ),
    ],
    remarks: [
      'See Chapter 10 for relative steroid potencies. Acetate form may also be '
          'used for intra-articular and intralesional injection and has longer times '
          'to max. effect and duration of action; it should NOT be given IV. Use '
          'with caution with systemic sclerosis. Like all steroids, may cause '
          'hypertension, leukocytosis, pseudotumor cerebri, acne, Cushing syndrome, '
          'increase risk of infection, adrenal axis suppression, GI bleeding, '
          'hyperglycemia, and osteoporosis. Hypertrophic cardiomyopathy in premature '
          'infants and tumor lysis syndrome in patients with malignancies have been '
          'reported.',
      'Barbiturates, phenytoin, and rifampin may enhance methylprednisolone '
          'clearance. Erythromycin, itraconazole, and ketoconazole may increase '
          'methylprednisolone levels. Methylprednisolone may increase cyclosporine '
          'and tacrolimus levels.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1104–1105',
  ),
  // METOCLOPRAMIDE — PDF p. 296 (printed 1105)
  DrugEntryV3(
    name: 'METOCLOPRAMIDE',
    brandNames: 'Reglan and generics',
    drugClass: 'Antiemetic, prokinetic agent',
    iconRow: '',
    formulations: [
      'Tabs: 5, 10 mg',
      'Tabs, orally disintegrating (ODT): 5 mg',
      'Injection: 5 mg/mL (2 mL); preservative-free available',
      'Oral solution: 5 mg/5 mL (473 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Gastroesophageal reflux (GER) or GI dysmotility:',
        lines: [
          DoseLine('Infant and child: 0.1–0.2 mg/kg/dose IV/IM/PO up to QID; max. dose: 0.8 '
              'mg/kg/24 hr or 10 mg/dose'),
          DoseLine('Adult: 5–10 mg/dose IV/IM/PO QAC and QHS'),
        ],
      ),
      DoseSection(
        heading: 'Antiemetic for chemotherapy-induced nausea and vomiting (child and '
            'adolescent):',
        lines: [
          DoseLine('Premedicate with diphenhydramine to reduce extrapyramidal symptoms (EPS).'),
          DoseLine('1–2 mg/kg/dose IV/IM/PO Q2–6 hr up to 5 doses/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in GI obstruction, seizure disorder, tardive dyskinesia, '
          'and pheochromocytoma, or in patients receiving drugs likely to cause EPS. '
          'May cause EPS, especially at higher doses. Sedation, headache, anxiety, '
          'depression, leukopenia, and diarrhea may occur. Neuroleptic malignant '
          'syndrome and tardive dyskinesia (increased risk with prolonged duration '
          'of therapy; avoid use >12 wk) have been reported.',
      'Metoclopramide is a substrate for cytochrome P-450 2D6; inhibitors to '
          'this enzyme may increase risk for metoclopramide toxicity. G6PD '
          'deficiency may increase risk for methemoglobinemia; DO NOT use methylene '
          'blue as it may cause a fatal hemolytic anemia.',
      'For GER, give 30 min before meals and at bedtime. Reduce dose in renal '
          'impairment (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1105',
  ),
  // METOLAZONE — PDF p. 296–297 (printed 1105–1106)
  DrugEntryV3(
    name: 'METOLAZONE',
    brandNames: 'Generics; previously available as Zaroxolyn',
    drugClass: 'Diuretic, thiazide-like',
    iconRow: '',
    formulations: [
      'Tabs: 2.5, 5, 10 mg',
      'Oral suspension: 0.25 mg/mL, 1 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Dosage based on Zaroxolyn (for oral suspension, see remarks):',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('Edema: 0.2–0.4 mg/kg/24 hr PO ÷ once daily–BID'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Hypertension: 2.5–5 mg PO once daily'),
          DoseLine('Edema: 2.5–20 mg PO once daily'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in patients with anuria, hepatic coma, or '
          'hypersensitivity to sulfonamides or thiazides. Use with caution in severe '
          'renal disease, impaired hepatic function, gout, lupus erythematosus, '
          'diabetes mellitus, and elevated cholesterol and triglycerides. '
          'Electrolyte imbalance, GI disturbance, hyperglycemia, marrow suppression, '
          'chills, hyperuricemia, chest pain, hepatitis, and rash may occur.',
      'Oral suspensions have increased bioavailability; therefore lower doses '
          'may be necessary when using these dosage forms. More effective than '
          'thiazide diuretics in impaired renal function; may be effective in GFRs '
          'as low as 20 mL/min. Furosemide-resistant edema in pediatric patients may '
          'benefit with the addition of metolazone.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1105–1106',
  ),
  // METRONIDAZOLE — PDF p. 297–299 (printed 1106–1108)
  DrugEntryV3(
    name: 'METRONIDAZOLE',
    brandNames: 'Flagyl, Likmez, MetroGel, MetroLotion, MetroCream, Noritate, '
        'Vandazole, Nuvessa, and generics',
    drugClass: 'Antibiotic, antiprotozoal',
    iconRow: '',
    formulations: [
      'Tabs: 125, 250, 500 mg',
      'Caps: 375 mg',
      'Oral suspension: 50 mg/mL',
      'Likmez: 100 mg/mL (200 mL); contains parabens',
      'Ready-to-use injection: 5 mg/mL (100 mL); contains 28 mEq Na/g drug',
      'Gel, topical:',
      'Generics: 0.75% (45 g), 1% (55, 60 g)',
      'MetroGel: 1% (60 g)',
      'Lotion (MetroLotion and generics): 0.75% (59 mL); contains benzyl alcohol',
      'Cream, topical:',
      'MetroCream, and generics: 0.75% (45 g); contain benzyl alcohol',
      'Noritate: 1% (60 g); contains parabens',
      'Gel, vaginal:',
      'Vandazole and generics: 0.75% (each applicator delivers ~5 g of gel '
          'containing ~37.5 mg metronidazole); contains parabens (70 g with 5 '
          'applicators)',
      'Nuvessa: 1.3%: (each applicator delivers ~5 g containing ~65 mg '
          'metronidazole); contains parabens and benzyl alcohol (1 prefilled '
          'applicator)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Amebiasis:',
        lines: [
          DoseLine('Child: 35–50 mg/kg/24 hr PO ÷ Q8 hr × 10 days; max. dose: 750 mg/dose'),
          DoseLine('Adult: 500–750 mg/dose PO Q8 hr × 10 days'),
        ],
      ),
      DoseSection(
        heading: 'Anaerobic infection (see remarks):',
        lines: [
          DoseLine(
            'Neonate: PO/IV:',
            isHeading: true,
          ),
          DoseLine('Loading dose (all ages): 15 mg/kg × 1'),
          DoseLine(
            'Maintenance dose based on postmenstural age (PMA):',
            isHeading: true,
          ),
          DoseLine('PMA 24–25 wk: 7.5 mg/kg/dose Q24 hr'),
          DoseLine('PMA 26–27 wk: 10 mg/kg/dose Q24 hr'),
          DoseLine('PMA 28–33 wk: 7.5 mg/kg/dose Q12 hr'),
          DoseLine('PMA 34–40 wk: 7.5 mg/kg/dose Q8 hr'),
          DoseLine('PMA >40 wk: 7.5 mg/kg/dose Q6 hr'),
          DoseLine(
            'Infant/child/adolescent:',
            isHeading: true,
          ),
          DoseLine('PO: 30–50 mg/kg/24 hr ÷ Q8 hr; max. dose: 2250 mg/24 hr'),
          DoseLine('IV: 22.5–40 mg/kg/24 hr ÷ Q6–8 hr; max. dose: 4 g/24 hr'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('PO/IV: 30 mg/kg/24 hr ÷ Q6 hr; max. dose: 4 g/24 hr. A 15-mg/kg/dose IV '
              'loading dose over 1 hr is administered 6 hr prior to the aforementioned '
              'maintenance dose for IV route.'),
        ],
      ),
      DoseSection(
        heading: 'Bacterial vaginosis:',
        lines: [
          DoseLine(
            'Child, adolescent, and adult:',
            isHeading: true,
          ),
          DoseLine(
            'PO (7 days treatment duration):',
            isHeading: true,
          ),
          DoseLine('<45 kg: 15–25 mg/kg/24 hr ÷ Q8 hr; max dose: 2000 mg/24 hr'),
          DoseLine('≥45 kg: 500 mg BID'),
          DoseLine(
            'Vaginal:',
            isHeading: true,
          ),
          DoseLine('Vaginal gel 0.75% (adolescent and adult): ~37.5 mg (1 applicator full) '
              'QHS × 5 days'),
          DoseLine('Vaginal gel 1.3% (≥12 yr and adult): ~65 mg (1 applicator full) at '
              'bedtime × 1'),
        ],
      ),
      DoseSection(
        heading: 'Giardiasis:',
        lines: [
          DoseLine('Child: 15–30 mg/kg/24 hr PO ÷ TID × 5–7 days; max. dose: 750 mg/24 hr'),
          DoseLine('Adult: 250 mg PO TID × 5 days'),
        ],
      ),
      DoseSection(
        heading: 'Trichomoniasis: Treat sexual contacts.',
        lines: [
          DoseLine('Child <45 kg: 45 mg/kg/24 hr PO ÷ TID × 7 days; max. dose: 2000 mg/24 hr'),
          DoseLine(
            'Child ≥45 kg, adolescent/adult:',
            isHeading: true,
          ),
          DoseLine('Female: 500 mg PO BID × 7 days'),
          DoseLine('Male: 2 g PO × 1'),
        ],
      ),
      DoseSection(
        heading: 'Clostridium difficile infection (IV may be less efficacious):',
        lines: [
          DoseLine('Child: 30 mg/kg/24 hr PO/IV ÷ Q6 hr × 10–14 days; max. dose: 2000 mg/24 hr'),
          DoseLine('Severe fulminant infection (with oral or rectal vancomycin): 30 mg/kg/24 '
              'hr IV ÷ Q8 hr × 10 days; max. dose: 500 mg/dose'),
          DoseLine('Adult: 500 mg PO/IV TID × 10–14 days'),
          DoseLine('Severe fulminant infection (with oral or rectal vancomycin): 500 mg IV Q8 '
              'hr'),
        ],
      ),
      DoseSection(
        heading: 'Helicobacter pylori infection (use in combination with amoxicillin '
            'and acid-suppressing agent with/without clarithromycin):',
        lines: [
          DoseLine('Child: 20–30 mg/kg/24 hr PO ÷ BID × 10–14 days; max. dose: 1000 mg/24 hr'),
          DoseLine('Adult: 250–500 mg PO TID–QID (QAC and QHS) × 10–14 days'),
        ],
      ),
      DoseSection(
        heading: 'Topical use for rosacea (adult):',
        lines: [
          DoseLine('Apply and rub a thin film to affected areas at the following frequencies '
              'specific to product concentration.'),
          DoseLine('0.75% cream: BID'),
          DoseLine('1% cream: Once daily'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in Cockayne syndrome as fatal liver failure has been '
          'reported. Avoid use in first-trimester pregnancy. Use with caution in '
          'patients with CNS disease, blood dyscrasias, severe liver (reduce dose by '
          '50% with Child-Pugh class C) or renal disease (GFR <10 mL/min; see '
          'Chapter 32). If using single 2-g dose in a breastfeeding mother, '
          'discontinue breastfeeding for 12–24 hr to allow excretion of the drug. '
          'Breast feeding category is “2” with systemic routes of administration and '
          '“?” for topical/vaginal routes.',
      'Nausea, diarrhea, urticaria, dry mouth, leukopenia, vertigo, metallic '
          'taste, and peripheral neuropathy may occur. Candidiasis may worsen. May '
          'discolor urine. Patients should not ingest alcohol for 24–48 hr after '
          'dose (disulfiram-type reaction). Peripheral neuropathy has been reported '
          'with topical use. May interfere with AST, ALT, triglycerides, glucose, '
          'and LDH testing. Severe and sometimes fatal cutaneous reactions (e.g., '
          'TEN, SJS, DRESS), tinnitus, and impaired hearing have been reported.',
      'Single-dose oral regimen no longer recommended in bacterial vaginosis due '
          'to poor efficacy. May increase levels or toxicity of phenytoin, lithium, '
          'and warfarin. Phenobarbital and rifampin may increase metronidazole '
          'metabolism. Q–T prolongation has been reported when used with other '
          'medications with the potential for prolonging the Q–T interval.',
      'IV infusion must be given slowly over 1 hr. For intravenous use in all '
          'ages, some references recommend a 15-mg/kg loading dose.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1106–1108',
  ),
  // MICAFUNGIN SODIUM — PDF p. 299–300 (printed 1108–1109)
  DrugEntryV3(
    name: 'MICAFUNGIN SODIUM',
    brandNames: 'Mycamine and generics',
    drugClass: 'Antifungal, echinocandin',
    iconRow: '',
    formulations: [
      'Injection: 50, 100 mg; contains lactose',
      'Injection, diluted in 0.9% sodium chloride for injection (iso-osmotic and '
          'preservative-free):',
      '50 mg in 50 mL; 100 mg in 100 mL; 150 mg in 150 mL; every 50 mg of '
          'micafungin contains 200 mg of sodium',
    ],
    doseSections: [
      DoseSection(
        heading: 'Invasive candidiasis (see remarks):',
        lines: [
          DoseLine(
            'Neonate and infant (based on a multidose pharmacokinetic and safety trial '
                'in 13 neonates/infants >48 hr and <120 days old with suspected or '
                'invasive candidiasis; minimum of 4–5 days of therapy):',
            isHeading: true,
          ),
          DoseLine('<1 kg: 10 mg/kg/dose IV Q24 hr; additional data from another multidose '
              'trial in 12 preterm neonates (median birth weight: 775 g, 27 wk '
              'gestation) suggest 15 mg/kg/dose IV Q24 hr will provide similar AUC drug '
              'exposure of approximately 5 mg/kg/dose in adults'),
          DoseLine('≥1 kg: 7–10 mg/kg/dose IV Q24 hr; 10–12 mg/kg/dose IV Q24 hr may be '
              'needed for HIV-exposed/infected neonates'),
          DoseLine('Non-CNS or non-ocular involvement: 4 mg/kg/dose IV Q24 hr is recommended '
              'by the manufacturer despite pharmacokinetic modeling studies indicating '
              'approximately 40% of subjects would achieve exposure rates similar to '
              'those of adults receiving 100 mg/24 hr.'),
          DoseLine('Infant (≥1 mo), child, and adolescent: 2–4 mg/kg/dose IV Q24 hr; max. '
              'dose: 100 mg/dose'),
          DoseLine('Adult: 100–150 mg IV Q24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Esophageal candidiasis, invasive aspergillosis, candidal endocarditis '
            '(see remarks):',
        lines: [
          DoseLine('Infant (≥1 mo), child, and adolescent: 4 mg/kg/dose IV Q24 hr; max. dose: '
              '150 mg/24 hr'),
          DoseLine('Adult: 150 mg IV Q24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Candida prophylaxis in hematopoietic stem cell transplant:',
        lines: [
          DoseLine('Infant (1 mo), child, and adult: 1 mg/kg/dose IV Q24 hr; max. dose: 50 '
              'mg/dose'),
        ],
      ),
    ],
    remarks: [
      'Prior hypersensitivity to other echinocandins (anidulafungin, '
          'caspofungin) increases risk; anaphylaxis with shock has been reported. '
          'Use with caution in hepatic and renal impairment.',
      'No dosing adjustments are required based on race or gender, or in '
          'patients with severe renal dysfunction or mild to moderate hepatic '
          'function impairment. Effect of severe hepatic function impairment on '
          'micafungin pharmacokinetics has not been evaluated. Higher dosage '
          'requirements in premature and young infants may be attributed to the '
          'faster drug clearance due to lower protein binding. Higher treatment '
          'doses in infants and children have been reported at 8.6–12 mg/kg/dose IV '
          'once daily.',
      'May cause GI disturbances, phlebitis, rash, hyperbilirubinemia, liver '
          'function test elevation, headache, fever, and rigor. Anemia, leukopenia, '
          'neutropenia, thrombocytopenia, TENS, Stevens-Johnson syndrome, and '
          'hemolysis have been reported. Micafungin is cytochrome P-450 3A isoenzyme '
          'substrate and weak inhibitor. May increase the effects/toxicity of '
          'nifedipine and sirolimus.',
      'Safety and efficacy in children ≤4 mo have been established in patients '
          'without meningoencephalitis and/or other dissemination. This is supported '
          'by adequate and well-controlled studies in children ≥4 mo with additional '
          'pharmacokinetic/safety data in children <4 mo.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1108–1109',
  ),
  // MICONAZOLE — PDF p. 300–301 (printed 1109–1110)
  DrugEntryV3(
    name: 'MICONAZOLE',
    brandNames: 'Topical products: Micatin, Desenex, Lotrimin AF, and other brands & '
        'generics\nVaginal products: Miconazole 7, Miconazole 3, Monistat, '
        'Vagistat-3, and other brands & generics\nOral buccal tab: Oravig',
    drugClass: 'Antifungal agent',
    iconRow: '',
    formulations: [
      'Cream (OTC): 2% (15, 28, 30, 42.5, 113 g); may contain EDTA, propylene '
          'glycol, and parabens',
      'Ointment (OTC): 2% (56, 141 g)',
      'Topical solution (OTC): 2% with alcohol (30 mL); may contain benzyl '
          'alcohol',
      'Powder (OTC): 2% (85, 90 g); may contain sodium benzoate',
      'Spray, powder (OTC): 2% (85, 113 g); contains alcohol',
      'Vaginal cream (OTC): 2% (45 g); contains benzoic acid',
      'Monistat 7 and Vagistat 7 (OTC): 2% (45 g) with 7 disposable applicators',
      'Vaginal suppository (OTC): 100 mg (7s), 200 mg (3s)',
      'Vaginal combination packs:',
      'Monistat 1 Combination Pack (OTC): 1200 mg vaginal suppository (1) and 2% '
          'cream (9 g)',
      'Miconazole 3 Combo Pack, Monistat 3 Combo Pack, Vagistat-3, and may '
          'others (OTC):',
      '200 mg (4%) vaginal suppository (3s); and 2% external cream (9 g)',
      'Monistat 7 Combo Pack (OTC): 100 mg vaginal suppository (7s) and 2% cream '
          '(9 g)',
      'Oral buccal tab:',
      'Oravig: 50 mg; contains corn starch and milk proteins',
    ],
    doseSections: [
      DoseSection(
        heading: 'Topical/dermatologic (≥2 yr and adolescent):',
        lines: [
          DoseLine('Apply BID × 2–4 wk.'),
        ],
      ),
      DoseSection(
        heading: 'Vaginal (≥12 yr and adult):',
        lines: [
          DoseLine('7-day regimen: 1 applicator full of 2% cream or 100-mg suppository QHS × '
              '7 days'),
          DoseLine('3-day regimen: 1 applicator full of 4% cream or 200-mg suppository QHS × '
              '3 days'),
          DoseLine('1-day regimen (Monistat 1): 1200-mg suppository × 1 at bedtime or during '
              'the day'),
        ],
      ),
      DoseSection(
        heading: 'Mild oropharyngeal candidiasis (adolescent/adult):',
        lines: [
          DoseLine('Apply 1 tab (50 mg) to the upper gum once daily × 7–14 days.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in hypersensitivity to other imidazole antifungal agents '
          '(e.g., clotrimazole, ketoconazole). Side effects include pruritus, rash, '
          'burning, phlebitis, headaches, and pelvic cramps.',
      'Drug is a substrate and inhibitor of the cytochrome P-450 3A3/3A4 '
          'isoenzymes. Vaginal use with concomitant warfarin use has also been '
          'reported to increase warfarin’s effect. Vegetable oil base in vaginal '
          'suppositories may interact with latex products (e.g., condoms and '
          'diaphragms); consider switching to the vaginal cream.',
      'Avoid contact with eyes.',
      'Do not crush, chew, or swallow the buccal tabs. Apply buccal tabs in the '
          'morning after brushing teeth by placing the tablet against the upper gum '
          'above one of the incisor teeth and hold with slight pressure over the '
          'upper lip for 30 sec (alternate sides of the mouth with each '
          'application). Placement of the rounded side of the tablet against the gum '
          'may be more comfortable; avoid chewing gum while tablet is in place. If '
          'tablet falls off within 6 hr of application, reposition the same tablet '
          'immediately. See product information for additional information. Oral '
          'discomfort, including mouth and tongue ulceration, dry mouth, toothache, '
          'and loss of/altered taste, has been reported with use of buccal tabs.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1109–1110',
  ),
  // MIDAZOLAM — PDF p. 301–302 (printed 1110–1111)
  DrugEntryV3(
    name: 'MIDAZOLAM',
    brandNames: 'Generics; previously available as Versed; intranasal: Nayzilam',
    drugClass: 'Benzodiazepine',
    iconRow: '',
    formulations: [
      'Injection: 1 mg/mL (2, 5, 10 mL), 5 mg/mL (1, 2, 5, 10 mL); some '
          'preparations may contain 1% benzyl alcohol',
      'Premixed injection in 0.8% or 0.9% sodium chloride (ready to use): 1 '
          'mg/mL (50, 100 mL); preservative free',
      'Oral syrup: 2 mg/mL (118 mL); contains sodium benzoate',
      'Nasal solution (Nayzilam): 5 mg per 0.1 mL (2s); contains propylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Titrate to effect under controlled conditions (see remarks).',
        lines: [
          DoseLine('See Chapter 6 for additional routes of administration.'),
        ],
      ),
      DoseSection(
        heading: 'Sedation for procedures:',
        lines: [
          DoseLine(
            'Infant, child, and adolescent:',
            isHeading: true,
          ),
          DoseLine('IM: 0.1–0.15 mg/kg/dose 30–60 min prior to procedure. Higher dose of 0.5 '
              'mg/kg/dose has been used for anxious patients. Max. dose: 10 mg'),
          DoseLine(
            'IV:',
            isHeading: true,
          ),
          DoseLine('6 mo–5 yr: 0.05–0.1 mg/kg/dose over 2–3 min. May repeat dose PRN in '
              '2–3-min intervals up to a max. total dose of 6 mg. A total dose up to 0.6 '
              'mg/kg may be necessary for desired effect.'),
          DoseLine('6–12 yr: 0.025–0.05 mg/kg/dose over 2–3 min. May repeat dose PRN in '
              '2–3-min intervals up to a max. total dose of 10 mg. A total dose up to '
              '0.4 mg/kg may be necessary for desired effect.'),
          DoseLine('>12–18 yr: 0.5–2.5 mg over 2–3 min. May repeat in 2–3-min intervals up to '
              'max. total dose of 10 mg.'),
          DoseLine(
            'PO:',
            isHeading: true,
          ),
          DoseLine('≥6 mo, child, and adolescent <16 yr: 0.25–0.5 mg/kg/dose × 1; max. dose: '
              '20 mg. Younger patients (6 mo–5 yr) may require higher doses of 1 '
              'mg/kg/dose, whereas older patients (6–15 yr) may require only 0.25 '
              'mg/kg/dose. Use 0.25 mg/kg/dose for patients with cardiac or respiratory '
              'compromise, concurrent CNS depressive drug, or high-risk surgery.'),
          DoseLine(
            'Intranasal (limited data; using IV dosage form with nasal atomizer):',
            isHeading: true,
          ),
          DoseLine('Infant, child, and adolescent: 0.2–0.3 mg/kg/dose (max. 10 mg/dose) '
              'intranasally × 1. Higher doses of 0.4–0.5 mg/kg/dose (max. 10 mg/dose) '
              'have also been reported.'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('IM: 0.07–0.08 mg/kg/dose 30–60 min prior to procedure; usual dose is 5 mg'),
          DoseLine('IV: 0.5–2 mg/dose over 2 min. May repeat PRN in 2–3-min intervals until '
              'desired effect. Usual total dose: 2.5–5 mg. Max. total dose: 5 mg'),
        ],
      ),
      DoseSection(
        heading: 'Sedation with mechanical ventilation:',
        lines: [
          DoseLine(
            'Intermittent:',
            isHeading: true,
          ),
          DoseLine('Infant and child: 0.05–0.15 mg/kg/dose IV Q1–2 hr PRN'),
          DoseLine(
            'Continuous IV infusion (initial doses, titrate to effect):',
            isHeading: true,
          ),
          DoseLine(
            'Neonate:',
            isHeading: true,
          ),
          DoseLine('<32 wk gestation: 0.5 mCg/kg/min'),
          DoseLine('≥32 wk gestation: 1 mCg/kg/min'),
          DoseLine('Infant and child: 1–2 mCg/kg/min'),
        ],
      ),
      DoseSection(
        heading: 'Refractory status epilepticus:',
        lines: [
          DoseLine('Infant ≥2 mo and child: Load with 0.2 mg/kg IV × 1 followed by a '
              'continuous infusion of 1 mCg/kg/min; titrate dose upward Q5 min to effect '
              '(mean dose of 2.3 mCg/kg/min with a range of 1–18 mCg/kg/min has been '
              'reported).'),
        ],
      ),
      DoseSection(
        heading: 'Acute treatment of intermittent, stereotypic episodes of frequent '
            'seizure activity (i.e., seizure clusters, acute repetitive seizures) '
            'that are distinct from a patient’s usual seizure pattern in patients '
            'with epilepsy:',
        lines: [
          DoseLine(
            'Infant, child, and adolescent (intranasal using IV dosage form with nasal '
                'atomizer):',
            isHeading: true,
          ),
          DoseLine('Inhale 0.2–0.3 mg/kg/dose (max. dose: 10 mg/dose) intranasally by '
              'administering half of total dose into each nostril. If no response after '
              '10 min, dose may be repeated once.'),
          DoseLine('≥12 yr and adult (Nayzilam intranasal; see remarks): Administer one spray '
              '(5 mg) intranasally into one nostril. If no response in 10 min, '
              'administer an additional 5-mg spray into the alternative nostril. Do not '
              'administer the second dose if patient has trouble breathing or if there '
              'is excessive sedation that is uncharacteristic of the patient during a '
              'seizure episode. Max. dose: 10 mg/dose per episode; not to exceed one '
              'episode every 3 days and 5 episodes per month.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in patients with narrow-angle glaucoma and shock. Use '
          'with caution in CHF, renal impairment (adjust dose; see Chapter 32), '
          'pulmonary disease, hepatic dysfunction, and neonates. Causes respiratory '
          'depression, hypotension, and bradycardia. Cardiovascular monitoring is '
          'recommended. Use lower doses or reduce dose when given in combination '
          'with narcotics or in patients with respiratory compromise. Neonates '
          'exposed to midazolam late in pregnancy or during labor may experience '
          'sedation and/or withdrawal symptoms.',
      'Higher recommended dosage for younger patients (6 mo–5 yr) is attributed '
          'to the water-soluble properties of midazolam and the higher percent body '
          'water for younger patients.',
      'Drug is a substrate for cytochrome P-450 3A4. Serum concentrations may be '
          'increased by cimetidine, clarithromycin, diltiazem, erythromycin, '
          'itraconazole, ketoconazole, ranitidine, and protease inhibitors (use '
          'contraindicated). Sedative effects may be antagonized by theophylline. '
          'Effects can be reversed by flumazenil. For pharmacodynamic information, '
          'see Chapter 6.',
      'Do not prime Nayzilam intranasal dosage form, because this will promote '
          'drug loss.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1110–1111',
  ),
  // MILRINONE — PDF p. 302 (printed 1111)
  DrugEntryV3(
    name: 'MILRINONE',
    brandNames: 'Generics; previously available as Primacor',
    drugClass: 'Inotrope, phosphodiesterase inhibitor',
    iconRow: '',
    formulations: [
      'Injection: 1 mg/mL (10, 20, 50 mL); single-dose use products are '
          'preservative free',
      'Premixed injection in D₅W: 200 mCg/mL (100, 200 mL); preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infant, child, and adolescent (limited data):',
        lines: [
          DoseLine('Optional 50-mCg/kg IV loading dose over 15 min, followed by a continuous '
              'infusion of 0.25–0.75 mCg/kg/min and titrate to effect. Loading dose is '
              'NOT recommended by some due to the risk of hypotension.'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Continuous infusion of 0.125–0.75 mCg/kg/min; titrate to the lowest dose '
              'for clinical effect. Prior use of loading dose is NOT recommended due to '
              'the risk of hypotension.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in severe aortic stenosis, severe pulmonic stenosis, and '
          'acute MI. May cause headache, dysrhythmias, hypotension, hypokalemia, '
          'nausea, vomiting, anorexia, abdominal pain, hepatotoxicity, and '
          'thrombocytopenia. Pediatric patients may require higher mCg/kg/min doses '
          'because of a faster elimination T₁/₂ and larger volume of distribution, '
          'when compared with adults. Hemodynamic effects can last up to 3–5 hr '
          'after discontinuation of infusion in children. Reduce dose in renal '
          'impairment.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1111',
  ),
  // MINERAL OIL — PDF p. 303 (printed 1112)
  DrugEntryV3(
    name: 'MINERAL OIL',
    brandNames: 'Fleet Laxative Mineral Oil, GoodSense Mineral Oil, Kondremul, and '
        'generics',
    drugClass: 'Laxative, lubricant',
    iconRow: '',
    formulations: [
      'Liquid, oral (Fleet Laxative Mineral Oil, GoodSense Mineral Oil, and '
          'generics; OTC): 480, 946 mL',
      'Emulsion, oral (Kondremul; OTC): 480 mL; each 5 mL Kondremul contains 2.5 '
          'mL mineral oil',
      'Rectal liquid (Fleet Laxative Mineral Oil and generics; OTC): 133-mL '
          'bottle delivers approximately 120 mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Constipation:',
        lines: [
          DoseLine(
            'Child 6–11 yr (see remarks):',
            isHeading: true,
          ),
          DoseLine('Oral liquid: 5–15 mL/24 hr PO ÷ once daily (QHS)–TID'),
          DoseLine('Oral emulsion (Kondremul): 10–30 mL/24 hr PO ÷ once daily (QHS)–TID'),
          DoseLine('Rectal (2–11 yr): ~60 mL (half bottle) as single dose'),
          DoseLine(
            'Child ≥12 yr and adult (see remarks):',
            isHeading: true,
          ),
          DoseLine('Oral liquid: 15–45 mL/24 hr PO ÷ once daily (QHS)–TID'),
          DoseLine('Oral emulsion (Kondremul): 30–90 mL/24 hr PO ÷ once daily (QHS)–TID'),
          DoseLine('Rectal (≥12 yr and adult): ~120 mL (full bottle) as single dose'),
        ],
      ),
    ],
    remarks: [
      'May cause diarrhea, cramps, and lipid pneumonitis via aspiration. Use as '
          'a laxative should not exceed 1 wk. Onset of action is approximately 6–8 '
          'hr. Higher doses may be necessary to achieve desired effect. DO NOT give '
          'QHS dose and use with caution in children <5 yr to minimize risk of '
          'aspiration. May impair the absorption of fat-soluble vitamins, calcium, '
          'phosphorus, oral contraceptives, and warfarin. Emulsified preparations '
          'are more palatable and are dosed differently than the oral liquid '
          'preparation.',
      'For disimpaction, doses up to 1 ounce (30 mL) per year of age (max. dose '
          'of 240 mL) BID can be given.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1112',
  ),
  // MINOCYCLINE — PDF p. 303–304 (printed 1112–1113)
  DrugEntryV3(
    name: 'MINOCYCLINE',
    brandNames: 'Minocin, Emrosi, Amzeeq, and generics',
    drugClass: 'Antibiotic, tetracycline derivative',
    iconRow: '',
    formulations: [
      'Tabs: 50, 75, 100 mg',
      'Caps: 50, 75, 100 mg',
      'Extended-release tabs (Q24 hr dosing):',
      'Generics: 45, 55, 65, 80, 90, 105, 115, 135 mg',
      'Extended-release caps (Q24 hr dosing):',
      'Emrosi: 40 mg',
      'Injection (Minocin): 100 mg; may contain 2.2 mEq magnesium/100 mg drug',
      'Topical foam (dispensed in a pressurized container with butane, '
          'isobutane, and propane propellants):',
      'Amzeeq: 4% (30 g); contains alcohols',
    ],
    doseSections: [
      DoseSection(
        heading: 'General infections:',
        lines: [
          DoseLine('Child (8–12 yr): 4 mg/kg/dose (max. dose: 200 mg/dose) IV/PO × 1, then 2 '
              'mg/kg/dose IV/PO Q12 hr; max. dose: 200 mg/24 hr'),
          DoseLine('Adolescent and adult: 200 mg/dose IV/PO × 1, then 100 mg IV/PO Q12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Chlamydia trachomatis/Ureaplasma urealyticum:',
        lines: [
          DoseLine('Adolescent and adult: 100 mg IV/PO Q12 hr × 7 days'),
        ],
      ),
      DoseSection(
        heading: 'Acne (≥12 yr–adult):',
        lines: [
          DoseLine('Immediate-release dosage forms: 50–100 mg PO once daily–BID'),
          DoseLine(
            'Extended-release tabs:',
            isHeading: true,
          ),
          DoseLine('45–49 kg: 45 mg PO once daily'),
          DoseLine('50–59 kg: 55 mg PO once daily'),
          DoseLine('60–71 kg: 65 mg PO once daily'),
          DoseLine('72–84 kg: 80 mg PO once daily'),
          DoseLine('85–96 kg: 90 mg PO once daily'),
          DoseLine('97–110 kg: 105 PO once daily'),
          DoseLine('111–125 kg: 115 mg PO once daily'),
          DoseLine('126–136 kg: 135 mg PO once daily'),
          DoseLine(
            'Topical foam (Amzeeq; moderate-to-severe acne vulgaris):',
            isHeading: true,
          ),
          DoseLine('≥9 yr and adult (see remarks): Apply a small amount to affected areas QHS '
              '(at least 1 hr before bedtime) until all areas are treated.'),
        ],
      ),
      DoseSection(
        heading: 'Rosacea:',
        lines: [
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Immediate-release tab or cap: 50–100 mg PO BID'),
          DoseLine('Extended-release cap (Emrosi): 40 mg PO once daily'),
        ],
      ),
    ],
    remarks: [
      'Not recommended for children <8 yr and during the last half of pregnancy '
          'due to risk of permanent tooth discoloration. Use with caution in renal '
          'failure; lower dosage may be necessary. High incidence of vestibular '
          'dysfunction (30%–90%). Nausea, vomiting, allergy, increased intracranial '
          'pressure (e.g., pseudotumor cerebri), photophobia, and injury to '
          'developing teeth may occur. Hepatitis, including autoimmune hepatitis, '
          'liver failure, hypersensitivity reactions (e.g., anaphylaxis, '
          'Stevens-Johnson syndrome, erythema multiforme), and serum sickness–like '
          'and lupus-like syndrome have been reported.',
      'May increase effects/toxicity of warfarin and decrease the efficacy of '
          'live attenuated oral typhoid vaccine. May be administered with food but '
          'NOT with milk or dairy products. See Tetracycline for additional '
          'drug/food interactions and comments.',
      'TOPICAL USE: Dosage form is flammable; avoid smoking during and '
          'immediately after application. Not for oral, ophthalmic, or intravaginal '
          'use. Headache is the most common side effect. Hyperpigmentation, '
          'erythema, dryness, and itching have also been reported.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1112–1113',
  ),
  // MINOXIDIL — PDF p. 304–305 (printed 1113–1114)
  DrugEntryV3(
    name: 'MINOXIDIL',
    brandNames: 'Tabs: Generics; previously available as Loniten\nTopical: Rogaine '
        'Men’s/Women’s, Minoxidil for Men/Women, Hair Regrowth Treatment '
        'Men, Men’s Rogaine Extra Strength, Gainextra Hair Regrowth, '
        'Gainextra Mens, and generics',
    drugClass: 'Antihypertensive agent, hair growth stimulant',
    iconRow: '',
    formulations: [
      'Tabs: 2.5, 10 mg',
      'Topical solution:',
      'Minoxidil for Men, Minoxidil for Women, Rogaine, and generics (OTC): 2% '
          '(60 mL); contains alcohol and propylene glycol',
      'Hair Regrowth Treatment for Men, Men’s Rogaine Extra Strength, Minoxidil '
          'Extra Strength for Men, Gainextra Hair Regrowth, and generics (OTC): 5% '
          '(60, 120 mL); contains 30% alcohol',
      'Topical foam:',
      'Rogaine Men’s, Rogaine Women’s, Rogaine Men’s Extra Strength, and '
          'Gainextra Mens (OTC): 5% (60 g); contains cetyl alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hypertension:',
        lines: [
          DoseLine('Child <12 yr: Start with 0.1–0.2 mg/kg/24 hr PO once daily; max. dose: 5 '
              'mg/24 hr. Dose may be increased in increments of 0.1–0.2 mg/kg/24 hr at '
              '3-day intervals. Usual effective range: 0.25–1 mg/kg/24 hr PO ÷ once '
              'daily–TID; max. dose: 50 mg/24 hr'),
          DoseLine('≥12 yr and adult: Start with 5 mg PO once daily. Dose may be gradually '
              'increased at 3-day intervals. Usual effective range: 10–40 mg/24 hr ÷ '
              'once daily–TID; max. dose: 100 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Topical (alopecia; see remarks):',
        lines: [
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Solution (2% or 5%): Apply 1 mL to affected areas of the scalp BID (QAM '
              'and QHS).'),
          DoseLine(
            'Foam (5%):',
            isHeading: true,
          ),
          DoseLine('Female: Apply ½ capful to affected areas of the scalp once daily.'),
          DoseLine('Male: Apply ½ capful to affected areas of the scalp BID.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in acute MI, dissecting aortic aneurysm, and '
          'pheochromocytoma. Concurrent use with a β-blocker and diuretic is '
          'recommended to prevent reflex tachycardia and reduce water retention, '
          'respectively. Use with caution in hepatic impairment as decrease in drug '
          'clearance has been reported in mild cirrhosis for adults. May cause '
          'drowsiness, dizziness, CHF, pulmonary edema, pericardial effusion, '
          'pericarditis, thrombocytopenia, leukopenia, Stevens-Johnson syndrome, '
          'TENS, and hypertrichosis (reversible) with systemic use. Neonatal '
          'hypertrichosis has been reported following use during pregnancy.',
      'Concurrent use of guanethidine may cause profound orthostatic '
          'hypotension; use with other antihypertensive agents may cause additive '
          'hypotension. Patients with renal failure or receiving dialysis may '
          'require a dosage reduction. Antihypertensive onset of action within 30 '
          'min and peak effects within 2–8 hr.',
      'TOPICAL USE: Local irritation, contact dermatitis may occur. Do not use '
          'in conjunction with other topical agents, including topical '
          'corticosteroids, retinoids, or petrolatum, or agents that are known to '
          'enhance cutaneous drug absorption. Onset of hair growth is 4 mo. Wash '
          'hands thoroughly after each application. The 5% solution is flammable.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1113–1114',
  ),
  // MOMETASONE FUROATE ± FOMOTEROL FUMARATE — PDF p. 305–307 (printed 1114–1116)
  DrugEntryV3(
    name: 'MOMETASONE FUROATE ± FOMOTEROL FUMARATE',
    brandNames: 'Asmanex, Nasonex, and other generic nasal and topical products; '
        'previously available as Elocon (topical forms)\nIn combination with '
        'fomoterol: Dulera',
    drugClass: 'Corticosteroid',
    iconRow: '',
    formulations: [
      'Nasal spray (Nasonex and generics): 0.05%, 50 mCg per actuation (10 mL '
          'provides 60 doses [OTC]; 17 g provides 120 doses)',
      'Aerosol for inhalation (Asmanex HFA): 50 mCg per actuation (13 g provides '
          '120 actuations), 100 mCg per actuation (13 g provides 120 actuations), '
          '200 mCg per actuation (13 g provides 120 actuations)',
      'Powder for inhalation, breath-activated (Asmanex Twisthaler; see '
          'remarks): 110 mCg per actuation (30 doses), 220 mCg per actuation (14, '
          '30, 60, 120 doses); contains lactose and milk proteins',
      'Topical cream and ointment: 0.1% (15, 45 g)',
      'Topical lotion: 0.1% (30, 60 mL); contains isopropyl alcohol',
      'In combination with fomoterol:',
      'Aerosol inhaler (Dulera):',
      '50 mCg mometasone furoate + 5 mCg fomoterol fumarate dihydrate per '
          'inhalation (13 g delivers 120 inhalations)',
      '100 mCg mometasone furoate + 5 mCg fomoterol fumarate dihydrate per '
          'inhalation (8.8 g delivers 60 inhalations, 13 g delivers 120 inhalations)',
      '200 mCg mometasone furoate + 5 mCg fomoterol fumarate dihydrate per '
          'inhalation (8.8 g delivers 60 inhalations, 13 g delivers 120 inhalations)',
    ],
    doseSections: [
      DoseSection(
        heading: 'MOMETASONE FUROATE:',
      ),
      DoseSection(
        heading: 'Intranasal (allergic rhinitis):',
        lines: [
          DoseLine('Patients with known seasonal allergic rhinitis should initiate therapy '
              '2–4 wk prior to anticipated pollen season.'),
          DoseLine('Child 2–11 yr: 50 mCg (1 spray) each nostril once daily (100 mCg/24 hr)'),
          DoseLine('Child ≥12 yr and adult: 100 mCg (2 sprays) each nostril once daily (200 '
              'mCg/24 hr)'),
        ],
      ),
      DoseSection(
        heading: 'Oral inhalation:',
        lines: [
          DoseLine(
            'Asmanex HFA (aerosol for inhalation):',
            isHeading: true,
          ),
          DoseLine('Child 5–<12 yr: 2 inhalations (100 mCg) BID of 50 mCg inhaler (200 mCg/24 '
              'hr)'),
          DoseLine('Child ≥12 yr and adult: Max. effects may not be achieved until 2 wk. '
              'Titrate doses to lowest effective dose once asthma is stabilized.'),
          DoseLine('Previously treated with bronchodilators alone or medium-dose inhaled '
              'corticosteroids: 2 inhalations (200 mCg) BID of 100-mCg inhaler (400 '
              'mCg/24 hr)'),
          DoseLine('Previously receiving high-dose inhaled or chronic oral corticosteroids: 2 '
              'inhalations (400 mCg) BID of 200-mCg inhaler (800 mCg/24 hr)'),
          DoseLine('Max. dose (all ages): 800 mCg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Asmanex Twisthaler (breath-activated powder for inhalation; see '
            'remarks):',
        lines: [
          DoseLine('Child 4–11 yr: Start with 110 mCg (1 inhalation) QHS of the 110-mCg '
              'inhaler regardless of prior therapy; max. dose: 110 mCg/24 hr.'),
          DoseLine('Child ≥12 yr and adult: Max. effects may not be achieved until 1–2 wk or '
              'longer. Titrate doses to the lowest effective dose once asthma is '
              'stabilized.'),
          DoseLine('Previously treated with bronchodilators alone or with inhaled '
              'corticosteroids: Start with 220 mCg (1 inhalation) QHS. Dose may be '
              'increased up to a max. dose of 440 mCg/24 hr ÷ QHS or BID.'),
          DoseLine('Previously treated with oral corticosteroids: Start with 440 mCg BID; '
              'max. dose: 880 mCg/24 hr.'),
        ],
      ),
      DoseSection(
        heading: 'Topical (see Chapter 8 for topical steroid comparisons):',
        lines: [
          DoseLine(
            'Cream and ointment:',
            isHeading: true,
          ),
          DoseLine('≥2 yr and adult: Apply a thin film to affected area once daily. Safety '
              'and efficacy for >3 wk have not been established for pediatric patients.'),
          DoseLine(
            'Lotion:',
            isHeading: true,
          ),
          DoseLine('≥12 yr and adult: Apply a few drops to affected area and massage lightly '
              'into skin once daily until it disappears.'),
        ],
      ),
      DoseSection(
        heading: 'MOMETASONE FUROATE + FOMOTEROL FUMARATE (DULERA):',
      ),
      DoseSection(
        heading: 'Child 5–<12 yr:',
        lines: [
          DoseLine('Two inhalations BID of 50 mCg mometasone + 5 mCg fomoterol; max. dose: 2 '
              'inhalations BID'),
        ],
      ),
      DoseSection(
        heading: 'Child ≥12 yr and adult:',
        lines: [
          DoseLine('Two inhalations BID of either 100 mCg mometasone + 5 mCg formoterol or '
              '200 mCg mometasone + 5 mCg formoterol based on prior asthma therapy'),
          DoseLine('(see the following table). If using the lower strength (100 mCg '
              'mometasone + 5 mCg formoterol), allow for 2 wk of therapy before '
              'increasing to the higher strength if no adequate response. Max. dose: Two '
              'inhalations BID of 200 mCg mometasone + 5 mCg formoterol.'),
        ],
        table: DoseTable(
          headers: ['Previous Therapy', 'Recommended Starting Dose', 'Recommended Maximum Daily Dose'],
          rows: [
            DoseTableRow(['Medium-dose inhaled corticosteroids', '100 mCg mometasone + 5 mCg formoterol: 2 inhalations BID', '400 mCg mometasone + 20 mCg formoterol']),
            DoseTableRow(['High-dose inhaled corticosteroids', '200 mCg mometasone + 5 mCg formoterol: 2 inhalations BID', '800 mCg mometasone + 20 mCg formoterol']),
          ],
        ),
      ),
    ],
    remarks: [
      'Mometasone is a cytochrome P-450 (CYP) 3A4 substrate; concurrent '
          'administration with ketoconazole and other CYP3A4 inhibitors (e.g., '
          'protease inhibitors) may increase mometasone levels, resulting in Cushing '
          'syndrome and adrenal suppression. Blurred vision, cataracts, and glaucoma '
          'have been reported. Use with caution with hepatic impairment; increased '
          'drug exposure is possible.',
      'INTRANASAL: Clear nasal passages and shake nasal spray well before each '
          'use. Onset of action for nasal symptoms of allergic rhinitis has been '
          'shown to occur within 11 hr after the first dose. Nasal burning and '
          'irritation, and epistaxis may occur. Nasal septal perforation, localized '
          'Candida infections, adrenal suppression (using higher than recommended '
          'dosages), and taste and smell disturbances have been reported. Monitor '
          'linear growth in children; especially with long-term use. A clinical '
          'trial in children 6–17 yr old was not able to demonstrate effectiveness '
          'for treating nasal polyps. A combination intranasal product of mometasone '
          'and olopatadine (Ryaltris) is available for seasonal allergic rhinitis '
          'and currently indicated for children ≥12 yr and adults.',
      'ORAL INHALATION (all forms): Rinse mouth after each use. Fever, allergic '
          'rhinitis, URI, UTI, GI discomfort, and sore throat have been reported in '
          'children. Musculoskeletal pain, oral candidiasis, arthralgia, and fatigue '
          'may occur. May potentially worsen tuberculosis; fungal, bacterial, viral, '
          'or parasitic infection; or ocular herpes simplex. Do not use Asmanex '
          'Twisthaler if allergic to milk proteins. The Twisthaler dosage form '
          'requires a minimum 30–60 L/min inspiratory flow rate to ensure proper '
          'dose delivery. Breastfeeding information is currently unknown, but most '
          'experts consider use of inhaled corticosteroids acceptable.',
      'MOMETASONE + FOMOTEROL (Dulera): Common side effects include '
          'nasopharyngitis, sinusitis, and headache. Angioedema, anaphylaxis, and '
          'arrhythmias have been reported. See Formoterol for additional remarks.',
      'TOPICAL USE: HPA axis suppression and skin atrophy have been reported '
          'with cream and ointment use in infants 6–23 mo. Avoid application/contact '
          'to face, eyes, underarms, groin, and mucous membranes. Occlusive '
          'dressings and use in diaper dermatitis are not recommended.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1114–1116',
  ),
  // MONTELUKAST — PDF p. 307–308 (printed 1116–1117)
  DrugEntryV3(
    name: 'MONTELUKAST',
    brandNames: 'Singulair and generics',
    drugClass: 'Antiasthmatic, antiallergy, leukotriene receptor antagonist',
    iconRow: '',
    formulations: [
      'Chewable tabs: 4, 5 mg; contain phenylalanine',
      'Tabs: 10 mg',
      'Oral granules: 4 mg per packet (30s)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Asthma and allergic rhinitis:',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('6 mo–5 yr: 4 mg (oral granules or chewable tablet) PO QHS; minimum age '
              'for use in asthma (per product label) is 12 mo'),
          DoseLine('6–14 yr: 5 mg (chewable tablet) PO QHS'),
          DoseLine('Adolescent ≥15 yr and adult: 10 mg PO QHS'),
        ],
      ),
      DoseSection(
        heading: 'Prevention of exercise-induced bronchospasm (administer dose at least '
            '2 hr prior to exercise; additional doses should not be administered '
            'within 24 hr):',
        lines: [
          DoseLine('Child (6–14 yr): 5 mg (chewable tablet) PO'),
          DoseLine('≥15 yr and adult: 10 mg PO'),
        ],
      ),
    ],
    remarks: [
      'Chewable tablet dosage form is contraindicated in phenylketonuric '
          'patients. Side effects include headache, abdominal pain, dyspepsia, '
          'fatigue, dizziness, cough, and elevated liver enzymes. Diarrhea, '
          'enuresis, epistaxis, pulmonary eosinophilia, thrombocytopenia, '
          'hypersensitivity reactions (including Stevens-Johnson syndrome and TENS), '
          'pharyngitis, nausea, otitis, sinusitis, and viral infections have been '
          'reported in children. Neuropsychiatric events, including aggression, '
          'anxiety, dream abnormalities, obsessive-compulsive symptoms, '
          'hallucinations, depression, suicidal behavior, and insomnia, have been '
          'reported.',
      'Drug is a substrate for cytochrome P-450 3A4 and 2C9. Phenobarbital and '
          'rifampin may induce hepatic metabolism to increase the clearance of '
          'montelukast.',
      'Doses may be administered with or without food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1116–1117',
  ),
  // MORPHINE SULFATE — PDF p. 308–309 (printed 1117–1118)
  DrugEntryV3(
    name: 'MORPHINE SULFATE',
    brandNames: 'Duramorph, MS Contin, Avinza, and many generics',
    drugClass: 'Narcotic, analgesic',
    iconRow: '',
    formulations: [
      'Oral solution: 10 mg/5 mL, 20 mg/5 mL',
      'Concentrated oral solution: 100 mg/5 mL',
      'Tabs: 15, 30 mg',
      'Extended-release tabs:',
      'MS Contin and generics: 15, 30, 60, 100, 200 mg',
      'Extended-release caps:',
      'Generics: 10, 20, 30, 45, 50, 60, 75, 80, 90, 100, 120 mg',
      'Combination immediate-release and extended-release caps:',
      'Avinza (10% of dose as immediate release): 30, 60, 90, 120 mg',
      'Rectal suppository: 5, 10, 20, 30 mg (12s)',
      'Injection:',
      'Duramorph and generics: 0.5, 1, 2, 4, 5, 8, 10, 25, 50 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Titrate to effect.',
      ),
      DoseSection(
        heading: 'Neonate',
        lines: [
          DoseLine(':'),
          DoseLine('Analgesia/tetralogy (cyanotic) spells: 0.05–0.1 mg/kg/dose IM, slow IV, '
              'SC Q4 hr'),
          DoseLine('Opiate withdrawal: 0.04–0.2 mg/kg/dose PO Q3–4 hr PRN'),
        ],
      ),
      DoseSection(
        heading: 'Infant 1–6 mo:',
        lines: [
          DoseLine(
            'Analgesia:',
            isHeading: true,
          ),
          DoseLine('PO: 0.08–0.1 mg/kg/dose Q3–4 hr PRN'),
          DoseLine('IV: 0.025–0.03 mg/kg/dose Q2–4 hr PRN'),
        ],
      ),
      DoseSection(
        heading: 'Infant >6 mo and child:',
        lines: [
          DoseLine(
            'Analgesia:',
            isHeading: true,
          ),
          DoseLine('PO: 0.2–0.5 mg/kg/dose (initial max. dose: 15–20 mg/dose) Q4–6 hr PRN '
              '(immediate release) or 0.3–0.6 mg/kg/dose Q12 hr PRN (controlled release)'),
          DoseLine('IM/IV/SC: 0.1–0.2 mg/kg/dose Q2–4 hr PRN; max. initial dose: infant: 2 '
              'mg/dose, 1–6 yr: 4 mg/dose, 7–12 yr: 8 mg/dose, and adolescent: 10 mg/dose'),
        ],
      ),
      DoseSection(
        heading: 'Adult (analgesia):',
        lines: [
          DoseLine('PO: 10–30 mg Q4 hr PRN (immediate release) or 15–30 mg Q8–12 hr PRN '
              '(controlled release; see specific dosage form product information for '
              'additional instructions)'),
          DoseLine('IM/IV/SC: 2–15 mg/dose Q2–6 hr PRN'),
        ],
      ),
      DoseSection(
        heading: 'Continuous IV infusion and SC infusion:',
        lines: [
          DoseLine('Dosing ranges, titrate to effect.'),
          DoseLine('Neonate (IV route only): 0.01–0.02 mg/kg/hr'),
          DoseLine(
            'Infant and child:',
            isHeading: true,
          ),
          DoseLine('Postoperative pain: 0.01–0.04 mg/kg/hr'),
          DoseLine('Sickle cell and cancer: 0.04–0.07 mg/kg/hr'),
          DoseLine('Adult: 1–4 mg/hr'),
        ],
      ),
      DoseSection(
        heading: 'To prepare infusion for neonates, infants, and children, use the '
            'following formula:',
        lines: [
          DoseLine('50 × Desired dose (mg/kg/hr) / Desired infusion rate (mL/hr) × Wt(kg) = '
              'mg morphine / 50 mL fluid'),
        ],
      ),
    ],
    remarks: [
      'Dependence, CNS and respiratory depression, nausea, vomiting, urinary '
          'retention, constipation, hypotension, bradycardia, increased ICP, miosis, '
          'biliary spasm, and allergy may occur. Be aware of concomitant medications '
          'with similar side effect profiles. Naloxone may be used to reverse '
          'effects, especially respiratory depression. Causes histamine release, '
          'resulting in itching and possible bronchospasm. Low-dose naloxone '
          'infusion may be used for itching. Inflammatory masses (e.g., granulomas) '
          'have been reported with continuous infusions via indwelling intrathecal '
          'catheters.',
      'Dosage reduction may be necessary with liver cirrhosis. See Chapter 6 for '
          'equianalgesic dosing. Pregnancy category changes to “D” if used for '
          'prolonged periods or in higher doses at term. Rectal dosing is same as '
          'oral dosing but is not recommended due to poor absorption. '
          'Controlled/sustained-release oral tablets must be administered whole. '
          'Controlled-release oral capsules may be opened and the entire contents '
          'sprinkled on applesauce immediately prior to ingestion. Be aware of the '
          'various oral solution concentrations; the concentrated oral solution (100 '
          'mg/5 mL) has been associated with accidental overdoses. Adjust dose in '
          'renal failure (see Chapter 32).',
      'The FDA has assigned an REMS for Opioid Analgesia; see '
          'https://www.accessdata.fda.gov/scripts/cder/rems/index.cfm?event=RemsDetai'
          'ls.page&REMS=17#tabs-4. The REMS strongly encourages the provider to (1) '
          'complete a REMS-compliant education program; (2) counsel '
          'patients/caregivers on prescription safe use, risks, storage, and '
          'disposal; (3) emphasize the importance of reading the Medication Guide '
          'provided by pharmacists at all times; and (4) consider other methods for '
          'improving patient, household, and community safety.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1117–1118',
  ),
  // MUPIROCIN — PDF p. 309–310 (printed 1118–1119)
  DrugEntryV3(
    name: 'MUPIROCIN',
    brandNames: 'Generics; previously available as Bactroban',
    drugClass: 'Topical antibiotic',
    iconRow: '',
    formulations: [
      'Ointment: 2% (15, 30 g); contains propylene glycol',
      'Cream: 2% (15, 30 g); may contain benzyl alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Topical (see remarks):',
        lines: [
          DoseLine('≥3 mo–adult: Apply small amount TID to affected area × 5–10 days. Topical '
              'ointment may be used in infants ≥2 mo for impetigo.'),
        ],
      ),
      DoseSection(
        heading: 'Intranasal for elimination of nasal colonization of Staphylococcus '
            'aureus, including MRSA (in the absence of the nasal ointment dosage '
            'form, use ointment dosage form):',
        lines: [
          DoseLine('Infant, child, and adolescent: Apply small amount intranasally to both '
              'nostrils BID × 5–10 days.'),
          DoseLine('Adult: Apply approximately 500 mg intranasally to both nostrils using a '
              'cotton swab BID × 5–10 days.'),
        ],
      ),
    ],
    remarks: [
      'Avoid contact with the eyes. Topical cream is not intended for use in '
          'lesions >10 cm in length or 100 cm² in surface area. Do not use topical '
          'ointment preparation on open wounds because of concerns about systemic '
          'absorption of polyethylene glycol. May cause minor local irritation and '
          'dry skin. Intranasal route may cause nasal stinging, taste disorder, '
          'headache, rhinitis, and pharyngitis. Severe allergic reactions (e.g., '
          'anaphylaxis, urticaria, angioedema, and rash) have been reported.',
      'If clinical response is not apparent in 3–5 days with topical use, '
          'reevaluate infection.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1118–1119',
  ),
  // MYCOPHENOLATE — PDF p. 310–311 (printed 1119–1120)
  DrugEntryV3(
    name: 'MYCOPHENOLATE',
    brandNames: 'Mycophenolate mofetil: CellCept, Myhibbin, and generics\n'
        'Mycophenolic acid: Myfortic and generics',
    drugClass: 'Immunosuppressant agent',
    iconRow: '',
    formulations: [
      'Mycophenolate mofetil (CellCept and generics):',
      'Caps: 250 mg',
      'Tabs: 500 mg',
      'Oral suspension: 200 mg/mL (160 mL); contains phenylalanine (0.56 mg/mL) '
          'and methylparabens',
      'Myhibbin: 200 mg/mL (175 mL); contains parabens, polysorbate 80, '
          'simethicone, and sorbitol',
      'Injection: 500 mg; may contain polysorbate 80',
      'Mycophenolic acid:',
      'Delayed-release tabs (Myfortic and generics): 180, 360 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infant ≥3 mo, child, and adolescent (see remarks):',
        lines: [
          DoseLine('Heart and liver transplant (mycophenolate mofetil):'),
          DoseLine('Suspension: Start with 600 mg/m²/dose PO BID; if tolerated, may increase '
              'to 900 mg/m²/dose BID. Max. dose: 3000 mg/24 hr.'),
          DoseLine(
            'Tabs or caps:',
            isHeading: true,
          ),
          DoseLine('BSA 1.25–<1.5 m²: Start with 750 mg PO BID; if tolerated, may increase '
              'dose with BID dosage interval up to a maximum of 3000 mg/24 hr.'),
          DoseLine('BSA ≥1.5 m²: Start with 1000 mg PO BID; if tolerated, may increase dose '
              'with BID dosage interval up to a maximum of 3000 mg/24 hr.'),
          DoseLine(
            'Renal transplant:',
            isHeading: true,
          ),
          DoseLine('Caps, tabs, or suspension (mycophenolate mofetil): 600 mg/m²/dose PO/IV '
              'BID up to a max. dose of 2000 mg/24 hr; alternatively, patients with BSAs '
              '≥1.25 m² may be dosed as follows:'),
          DoseLine('1.25–<1.5 m²: 750 mg PO BID'),
          DoseLine('≥1.5 m²: 1000 mg PO BID'),
          DoseLine('Delayed-release tabs (Myfortic; ≥5 yr): 400 mg/m²/dose PO BID; max. dose: '
              '720 mg BID; this dosage form not recommended in patients with BSAs <1.19 '
              'm². Alternatively, patients with BSAs ≥1.19 m² may be dosed as follows:'),
          DoseLine('1.19–1.58 m²: 540 mg PO BID'),
          DoseLine('>1.58 m²: 720 mg PO BID'),
          DoseLine(
            'Nephrotic syndrome:',
            isHeading: true,
          ),
          DoseLine('Frequently relapsing: 12.5–18 mg/kg/dose or 600 mg/m²/dose PO BID up to a '
              'max. dose of 2000 mg/24 hr for 1–2 yr and taper prednisone regimen'),
          DoseLine('Steroid dependent: 12–18 mg/kg/dose or 600 mg/m²/dose PO BID up to a max. '
              'dose of 2000 mg/24 hr for at least 12 mo'),
        ],
      ),
      DoseSection(
        heading: 'Adult (in combination with corticosteroids and cyclosporine; check '
            'specific transplantation protocol for specific dosage):',
        lines: [
          DoseLine('IV: 1000–3000 mg/24 hr ÷ BID'),
          DoseLine(
            'Oral:',
            isHeading: true,
          ),
          DoseLine('Caps, tabs, or suspension: 500–1500 mg PO BID'),
          DoseLine('Delayed-release tabs (Myfortic): 360–1080 mg PO BID'),
        ],
      ),
    ],
    remarks: [
      'Check specific transplantation protocol for specific dosage. '
          'Mycophenolate mofetil is a prodrug for mycophenolic acid. Owing to '
          'differences in absorption, the delayed-release tablets should not be '
          'interchanged with other oral dosage forms on an equivalent '
          'milligram-to-milligram basis. Increases risk of first trimester pregnancy '
          'loss and increased risk of congenital malformations (especially external '
          'ear and facial abnormalities, including cleft lip and palate, and '
          'anomalies of the distal limbs, heart, and esophagus).',
      'Common side effects may include headache, hypertension, diarrhea, '
          'vomiting, bone marrow suppression, anemia, fever, opportunistic '
          'infections, and sepsis. May cause drowsiness and increase the risk for '
          'bacterial, fungal, protozoal, and viral infections, and lymphomas or '
          'other malignancies. GI bleeds and increased risk for rejection in heart '
          'transplant patients switched from calcineurin inhibitors (e.g., '
          'cyclosporine and tacrolimus) and CellCept to sirolimus and CellCept have '
          'been reported. Cases of progressive multifocal leukoencephalopathy (PML), '
          'pure red cell aplasia (PRCA), posttransplant lymphoproliferative disorder '
          '(PTLD), acute inflammatory syndrome, and hypogammaglobulinemia have also '
          'been reported. The type and frequency of adverse reactions in pediatric '
          'heart or kidney transplant patients have been reported to be similar to '
          'those observed in pediatric renal transplant patients and in adults.',
      'Use of mycophenolic acid (Myfortic) should be avoided in patients with '
          'hypoxanthine-guanine phosphoribosyltransferase (HGPRT) deficiency (e.g., '
          'Lesch-Nyhan and Kelley-Seegmiller syndrome) because it may exacerbate '
          'disease symptoms characterized by increased uric acid, leading to acute '
          'arthritis, tophi, nephrolithiasis/urolithiasis, and renal failure.',
      'Use with caution in patients with active GI disease or renal impairment '
          '(GFR <25 mL/min/1.73 m²) outside of the immediate posttransplant period. '
          'In adults with renal impairment, avoid doses >2 g/24 hr and observe '
          'carefully. Dose should be interrupted or reduced in the presence of '
          'neutropenia (ANC <1.3 × 10³/microliter). No dose adjustment is needed for '
          'patients experiencing delayed graft function postoperatively.',
      'Drug interactions: (1) Displacement of phenytoin or theophylline from '
          'protein-binding sites will decrease total serum levels and increase free '
          'serum levels of these drugs. Salicylates displace mycophenolate to '
          'increase free levels of mycophenolate. (2) Competition for renal tubular '
          'secretion results in increased serum levels of acyclovir, ganciclovir, '
          'probenecid, and mycophenolate (when any of these are used together). (3) '
          'Avoid live and live attenuated vaccines (including influenza); decreases '
          'vaccine effectiveness. (4) Proton pump inhibitors, antacids, '
          'cholestyramine, cyclosporine, and telmisartan may reduce mycophenolate '
          'levels.',
      'Administer oral doses on an empty stomach. Infuse intravenous doses over '
          '2 hr. Oral suspension may be administered via NG tube with a minimum size '
          'of 8 Fr.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1119–1120',
  ),
];
