// =============================================================================
// output/c.dart — Drug Formulary 3.0, letter C
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyC` per file; entries in book order.
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

const List<DrugEntryV3> formularyC = [
  // CAFFEINE CITRATE — PDF p. 86 (printed 895)
  DrugEntryV3(
    name: 'CAFFEINE CITRATE',
    brandNames: 'Cafcit and generics',
    drugClass: 'Methylxanthine, respiratory stimulant',
    iconRow: '',
    formulations: [
      'Injection: 20 mg/mL (3 mL); preservative free',
      'Oral liquid: 20 mg/mL (3 mL), also available as powder for compounding 10 '
          'or 20 mg/mL',
      '20 mg/mL caffeine citrate salt = 10 mg/mL caffeine base',
    ],
    doseSections: [
      DoseSection(
        heading: 'Doses expressed in mg of caffeine citrate.',
      ),
      DoseSection(
        heading: 'Apnea of prematurity:',
        lines: [
          DoseLine('Loading dose: 20–25 mg/kg IV/PO × 1'),
          DoseLine('Maintenance dose: 5–10 mg/kg/dose PO/IV Q24 hr, to begin 24 hr after '
              'loading dose'),
        ],
      ),
    ],
    remarks: [
      'Avoid use in symptomatic cardiac arrhythmias. Do not use caffeine '
          'benzoate formulations in neonates; it has been associated with '
          'kernicterus. Use with caution in impaired renal or hepatic function; '
          'monitor serum concentration to prevent toxicity.',
      'Therapeutic levels: 5–25 mg/L. Cardiovascular, neurologic, or GI toxicity '
          'reported at serum levels >50 mg/L. Recommended serum sampling time: '
          'obtain trough level within 30 min prior to a dose. Steady state is '
          'typically achieved 3 wk after initiation of therapy. Levels obtained '
          'prior to steady state are useful for preventing toxicity.',
      'For IV administration, give loading dose over 30 min and maintenance dose '
          'over 10 min.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 895',
  ),
  // CALCITRIOL — PDF p. 86–87 (printed 895–896)
  DrugEntryV3(
    name: 'CALCITRIOL',
    brandNames: '1,25-dihydroxycholecalciferol, Rocaltrol, and generics',
    drugClass: 'Active form vitamin D, fat soluble',
    iconRow: '',
    formulations: [
      'Caps (Rocaltrol and generics): 0.25, 0.5 mCg; may contain parabens',
      'Oral solution (Rocaltrol and generics): 1 mCg/mL (15 mL)',
      'Injection (generics; previously available as Calcijex): 1 mCg/mL (1 mL); '
          'contains EDTA',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonatal hypocalcemia:',
        lines: [
          DoseLine('0.25–1 mCg/dose PO once daily'),
        ],
      ),
      DoseSection(
        heading: 'Hypoparathyroidism (evaluate dosage at 2- to 4-wk intervals and note '
            'the different mCg/dose vs. mCg/kg/dose per respective age group '
            'below):',
        lines: [
          DoseLine('Child >1 yr and adult: Initial dose of 0.25 mCg/dose PO once daily. May '
              'increase daily dosage by 0.25 mCg at 2- to 4-wk intervals. Usual '
              'maintenance dosage as follows:'),
          DoseLine('<1 yr (limited data): 0.02–0.06 mCg/kg/dose PO once daily'),
          DoseLine('1–5 yr: 0.25–0.75 mCg/dose PO once daily'),
          DoseLine('>5 yr and adult: 0.5–2 mCg/dose PO once daily'),
        ],
      ),
      DoseSection(
        heading: 'Renal failure:',
        lines: [
          DoseLine('See the National Kidney Foundation guidelines at '
              'https://kdigo.org/guidelines/ckd-mbd'),
        ],
      ),
    ],
    remarks: [
      'Most potent vitamin D metabolite available. Should not be used to treat '
          '25-OH vitamin D deficiency; use cholecalciferol or ergocalciferol. '
          'Monitor serum calcium and phosphorus, and parathyroid hormone (PTH) in '
          'dialysis patients. Avoid concomitant use of Mg²⁺-containing antacids. IV '
          'dosing applies if patient is undergoing hemodialysis.',
      'Contraindicated in patients with hypercalcemia or vitamin D toxicity. '
          'Side effects include: weakness, headache, vomiting, constipation, '
          'hypotonia, polydipsia, polyuria, myalgia, metastatic calcification, etc. '
          'Allergic reactions, including anaphylaxis, have been reported. May '
          'increase serum creatinine in predialysis patients.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 895–896',
  ),
  // CALCIUM ACETATE — PDF p. 87 (printed 896)
  DrugEntryV3(
    name: 'CALCIUM ACETATE',
    brandNames: 'Calphron, and generics; previously available as PhosLo; 25% '
        'elemental Ca',
    drugClass: 'Calcium supplement, phosphorus-lowering agent',
    iconRow: '',
    formulations: [
      'Tabs (Calphron [OTC] and generics): 667 mg (169 mg elemental Ca)',
      'Capsules (generics; previously available as PhosLo): 667 mg (169 mg '
          'elemental Ca)',
      'Each 1 g of salt contains 12.7 mEq or 6.34 mmol (250 mg) elemental Ca.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Doses expressed in mg of calcium acetate.',
      ),
      DoseSection(
        heading: 'Hyperphosphatemia in end-stage renal failure (see remarks):',
        lines: [
          DoseLine('Child and adolescent: Start with 667–1000 mg PO with each meal. If '
              'needed, dosage may be titrated every 2–4 wk up to the recommended limits '
              'from the KDOQI guidelines:'),
          DoseLine('Calcium intake as phosphate binders: 1500 mg elemental calcium/24 hr'),
          DoseLine('Total calcium intake from all sources: 2000 mg elemental calcium/24 hr'),
          DoseLine('Adult: Start with 1334 mg PO with each meal. Dosage may be increased '
              'gradually every 2–3 wk to bring serum phosphorus levels below 6 mg/dL, as '
              'long as hypercalcemia does not occur. Most patients require 2001–2668 mg '
              'PO with each meal.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in ventricular fibrillation. Use with caution in renal '
          'impairment, as hypercalcemia may develop in end-stage renal failure. '
          'Nausea and hypercalcemia may occur. Approximately 40% of dose is '
          'systemically absorbed under fasting conditions and up to 30% in '
          'nonfasting conditions. May reduce absorption of fluoroquinolones, '
          'tetracyclines, and iron and effectiveness of polystyrene sulfonate. May '
          'potentiate effects of digoxin.',
      '1 g calcium acetate binds to 45 mg phosphorus.',
      'Administer with meals and plenty of fluids for use as a '
          'phosphorus-lowering agent. Calcium is excreted in breast milk and is not '
          'expected to harm the infant, provided maternal serum calcium is '
          'appropriately monitored.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 896',
  ),
  // CALCIUM CARBONATE — PDF p. 87–88 (printed 896–897)
  DrugEntryV3(
    name: 'CALCIUM CARBONATE',
    brandNames: 'Tums, Children’s Pepto, Children\'s Mylicon, and many others '
        'including generics; 40% elemental Ca',
    drugClass: 'Calcium supplement, antacid',
    iconRow: '',
    formulations: [
      'Tab, chewable [OTC]: 500, 750, 1000, 1250 mg; may contain aspartame',
      'Children’s Pepto, Maalox Children’s [OTC]: 400 mg',
      'Children’s Mylicon [OTC]: 400 mg with 40 mg simethicone',
      'Tab [OTC]: 648, 1250, 1500 mg',
      'Oral suspension [OTC]: 1250 mg/5 mL (473 mL); may contain parabens',
      'Children’s Mylicon [OTC]: 400 mg/5 mL with 40 mg simethicone per 5 mL '
          '(120 mL)',
      'Powder [OTC]: 800 mg/2 g (480 g)',
      'Each 1 g of salt contains 20 mEq or 10 mmol (400 mg) elemental Ca.',
      'Some products may be combined with vitamin D; check package labeling.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hypocalcemia: (Doses expressed in mg of elemental calcium. To convert '
            'to mg of salt, divide elemental dose by 0.4.)',
        lines: [
          DoseLine('Neonate: 50–150 mg/kg/24 hr ÷ Q4–6 hr PO; max. dose: 1 g/24 hr'),
          DoseLine('Child: 45–65 mg/kg/24 hr PO ÷ QID'),
          DoseLine('Adult: 1–2 g/24 hr PO ÷ TID–QID'),
        ],
      ),
      DoseSection(
        heading: 'Antacid: (Doses expressed in mg of calcium carbonate; chronic use NOT '
            'recommended in GERD.) 2–5 yr and ≥10.9 kg:',
        lines: [
          DoseLine('400 mg PO as symptoms occur; max. dose: 1200 mg/24 hr'),
          DoseLine('6–11 yr: 800 mg PO as symptoms occur; max. dose: 2400 mg/24 hr'),
          DoseLine('>11 yr and adult: 1000–3000 mg PO as symptoms occur; max. dose: 7500 '
              'mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'See Calcium Acetate for contraindications, precautions, and drug '
          'interactions. Side effects: constipation, hypercalcemia, '
          'hypophosphatemia, hypomagnesemia, nausea, vomiting, headache, and '
          'confusion. Some products may contain trace amounts of sodium. Administer '
          'with plenty of fluids. For use as a phosphorus-lowering agent, administer '
          'with meals. Calcium is excreted in breast milk and is not expected to '
          'harm the infant, provided maternal serum calcium is appropriately '
          'monitored.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 896–897',
  ),
  // CALCIUM CHLORIDE — PDF p. 88–89 (printed 897–898)
  DrugEntryV3(
    name: 'CALCIUM CHLORIDE',
    brandNames: 'Various generics; 27% elemental Ca',
    drugClass: 'Calcium supplement',
    iconRow: '',
    formulations: [
      'Injection: 100 mg/mL (10%) (1.36 mEq Ca/mL) (10 mL)',
      'Prefilled syringe for injection: 100 mg/mL (10%) (1.36 mEq Ca/mL) (10 mL)',
      'Each 1 g of salt contains 13.6 mEq or 6.8 mmol (273 mg) elemental Ca.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Doses expressed in mg of calcium chloride.',
      ),
      DoseSection(
        heading: 'Cardiac arrest or calcium channel blocker toxicity (see remarks):',
        lines: [
          DoseLine('Neonate, infant, and child: 20 mg/kg/dose (max. dose: 1000 mg/dose) IV/IO '
              'Q10 min PRN; if effective, an infusion of 20–50 mg/kg/hr may be used'),
          DoseLine('Adult: 500–1000 mg/dose IV Q10 min PRN'),
        ],
      ),
      DoseSection(
        heading: 'MAXIMUM IV ADMINISTRATION RATES (in mg of calcium chloride):',
        lines: [
          DoseLine('IV push: Do not exceed 100 mg/min (over 5–10 min in cardiac arrest via '
              'central line or IO route).'),
          DoseLine('IV infusion: Do not exceed 45–90 mg/kg/hr with a max. concentration of 20 '
              'mg/mL.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in ventricular fibrillation. Not recommended for asystole '
          'and electromechanical dissociation. Use with caution in renal impairment, '
          'as hypercalcemia may develop in end-stage renal failure and the product '
          'contains small amounts of aluminum. May potentiate effects of digoxin. '
          'Routine use in cardiac arrest is NOT recommended due to the lack of '
          'improved survival.',
      'Use IV with extreme caution. Extravasation may lead to necrosis. '
          'Hyaluronidase may be helpful for extravasation. Central line '
          'administration is preferred IV route of administration. Do not use scalp '
          'veins. Do not administer by IM or SC routes.',
      'Rapid IV infusion associated with bradycardia, arrhythmias, hypotension, '
          'syncope, and peripheral vasodilation. May cause hyperchloremic acidosis. '
          'For neonates receiving concurrent IV ceftriaxone, administer each dose '
          'sequentially one after another if infusion lines at different sites are '
          'used, or infusion lines are thoroughly flushed between infusions with '
          'physiological salt solution to avoid precipitation.',
      'Calcium is excreted in breast milk and is not expected to harm the '
          'infant, provided maternal serum calcium is appropriately monitored.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 897–898',
  ),
  // CALCIUM CITRATE — PDF p. 89 (printed 898)
  DrugEntryV3(
    name: 'CALCIUM CITRATE',
    brandNames: 'Caltrate 600+D3, Citracal Petites, Citracal Maximum Plus, Citracal '
        'Slow Release, Citracal Gummies, Viactiv Calcium and Bone '
        'Strengthening, and generics; 21% elemental Ca',
    drugClass: 'Calcium supplement',
    iconRow: '',
    formulations: [
      'Some products may be combined with vitamin D; check package labeling.',
      'Tabs:',
      'Caltrate 600+D3 [OTC]: 600 mg elemental Ca and 800 IU vitamin D₃',
      'Generics [OTC]: 950 mg (200 mg elemental Ca), 1040 mg (218 mg elemental '
          'Ca)',
      'Caplets:',
      'Citracal Petites [OTC]: 200 mg elemental Ca and 250 IU vitamin D₃ with '
          '2.5 mg sodium',
      'Citracal Maximum Plus [OTC]: 325 mg elemental Ca and 500 IU vitamin D₃ '
          'with 2.75 mg zinc, 0.225 mg copper, 0.575 mg manganese, and 2.5 mg sodium',
      'Citracal Slow Release 1200 [OTC]: 600 mg elemental Ca and 500 IU vitamin '
          'D₃ with 40 mg magnesium and 2.5 mg sodium',
      'Chewable tabs:',
      'Citracal Gummies [OTC]: 250 mg elemental Ca and 500 IU vitamin D₃ with '
          '112.5 mg phosphorus and 17.5 mg sodium',
      'Viactiv Calcium and Bone Strengthening [OTC]: 650 mg elemental Ca and 500 '
          'IU vitamin D₃ with 40 mCg vitamin K and 10 mg sodium',
      'Each 1 g of salt contains 10.5 mEq or 5.25 mmol (211 mg) elemental Ca.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Doses expressed as mg of elemental calcium. To convert to mg of salt, '
            'divide elemental dose by 0.21.',
      ),
      DoseSection(
        heading: 'Hypocalcemia:',
        lines: [
          DoseLine('Neonate: 50–150 mg/kg/24 hr PO ÷ Q4–6 hr; max. dose: 1 g/24 hr'),
          DoseLine('Child: 45–65 mg/kg/24 hr PO ÷ QID'),
          DoseLine('Adult: 1–2 g/24 hr PO ÷ BID–TID'),
        ],
      ),
    ],
    remarks: [
      'See Calcium Acetate for contraindications, precautions, and drug '
          'interactions. Side effects: constipation, hypercalcemia, '
          'hypophosphatemia, hypomagnesemia, nausea, vomiting, headache, and '
          'confusion.',
      'Administer with meals for use as a phosphorus-lowering agent. For '
          'hypocalcemia, do not administer with or before meals/food and take plenty '
          'of fluids.',
      'Calcium is excreted in breast milk and is not expected to harm the '
          'infant, provided maternal serum calcium is appropriately monitored.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 898',
  ),
  // CALCIUM GLUCONATE — PDF p. 89–90 (printed 898–899)
  DrugEntryV3(
    name: 'CALCIUM GLUCONATE',
    brandNames: 'Various generics, 9.3% elemental Ca',
    drugClass: 'Calcium supplement',
    iconRow: '',
    formulations: [
      'Tabs [OTC]: 50 mg',
      'Injection: 100 mg/mL (10%) (0.465 mEq Ca/mL) (10, 50, 100 mL); may '
          'contain up to 512 mCg aluminum per 1000 mL (0.512 mCg per 100 mg calcium '
          'gluconate); see remarks',
      'Ready-to-use injection in sodium chloride: 20 mg/mL (0.093 mEq Ca/mL) '
          '(50, 100 mL); contains 0.675% NaCl and may contain up to 100 mCg aluminum '
          'per 1000 mL (0.5 mCg per 100 mg calcium gluconate); see remarks',
      'Each 1 g of salt contains 4.65 mEq or 2.33 mmol (93 mg) elemental Ca.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Doses expressed in mg calcium gluconate.',
      ),
      DoseSection(
        heading: 'Maintenance/hypocalcemia:',
        lines: [
          DoseLine('Neonate: IV: 200–800 mg/kg/24 hr ÷ Q6 hr'),
          DoseLine(
            'Infant:',
            isHeading: true,
          ),
          DoseLine('IV: 200–500 mg/kg/24 hr ÷ Q6 hr'),
          DoseLine('PO: 400–800 mg/kg/24 hr ÷ Q6 hr'),
          DoseLine('Child: 200–500 mg/kg/24 hr IV or PO ÷ Q6 hr'),
          DoseLine('Adult: 0.5–8 g/24 hr IV or PO ÷ Q6 hr'),
        ],
      ),
      DoseSection(
        heading: 'For cardiac arrest (see remarks):',
        lines: [
          DoseLine('Infant and child: 60 mg/kg/dose (max. 3000 mg/dose) IV Q10–20 min PRN'),
          DoseLine('Adult: 1.5–3 g/dose IV Q10 min PRN'),
          DoseLine('Max. dose: 3 g/dose'),
        ],
      ),
      DoseSection(
        heading: 'For tetany due to hypocalcemia:',
        lines: [
          DoseLine('Neonate, infant, child: 100–200 mg/kg dose IV over 5–10 min; repeat dose '
              '6 hr later if needed; max. dose: 500 mg/kg/24 hr'),
          DoseLine('Adult: 0.5–2 g IV over 10–30 min; repeat dose 6 hr later if needed.'),
        ],
      ),
      DoseSection(
        heading: 'MAXIMUM IV ADMINISTRATION RATES:',
        lines: [
          DoseLine('IV push: Do not exceed 100 mg/min (over 10–20 sec in cardiac arrest).'),
          DoseLine('IV infusion: Do not exceed 200 mg/min with a maximum concentration of 50 '
              'mg/mL.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in ventricular fibrillation. Use with caution in renal '
          'impairment, as hypercalcemia may develop in end-stage renal failure. '
          'Avoid peripheral infusion because extravasation may cause tissue '
          'necrosis. IV infusion associated with hypotension and bradycardia. Also '
          'associated with arrhythmias in digitalized patients. May reduce '
          'absorption of fluoroquinolones, tetracyclines, and iron and effectiveness '
          'of polystyrene sulfonate with oral route of administration. Routine use '
          'in cardiac arrest is not recommended due to lack of improved survival. '
          'Use of calcium chloride IV may be preferred due to its more rapid '
          'increase of ionized calcium in critically ill children.',
      'Do not administer IV dosage form via scalp veins and the IM or SC routes. '
          'IV dosage form may precipitate when mixed with bicarbonate or '
          'ceftriaxone. IV dosage form may also contain aluminum (see How Supplied '
          'section), and for patients with renal impairment (including premature '
          'infants), receipt >4–5 mCg/kg/24 hr aluminum has been associated with CNS '
          'and bone toxicities.',
      'Calcium is excreted in breast milk and is not expected to harm the '
          'infant, provided maternal serum calcium is appropriately monitored.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 898–899',
  ),
  // CALFACTANT — PDF p. 90 (printed 899)  [cross-reference]
  DrugEntryV3(
    name: 'CALFACTANT',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Surfactant, pulmonary',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 899',
  ),
  // CANNABIDIOL — PDF p. 91 (printed 900)
  DrugEntryV3(
    name: 'CANNABIDIOL',
    brandNames: 'Epidiolex',
    drugClass: 'Anticonvulsant',
    iconRow: '',
    formulations: [
      'Oral solution: 100 mg/mL (60, 100 mL); contains ethanol and sesame oil '
          'and supplied with 1 mL and 5 mL oral-dispensing syringes',
    ],
    doseSections: [
      DoseSection(
        heading: 'Lennox-Gastaut syndrome or Dravet syndrome (see remarks for therapy '
            'discontinuation):',
        lines: [
          DoseLine('Child ≥2 yr and adult: Start at 2.5 mg/kg/dose PO BID × 1 wk; dosage may '
              'be increased to a maintenance dose of 5 mg/kg/dose PO BID. Dose may be '
              'further increased after 1 wk if needed and tolerated at weekly increments '
              'of 2.5 mg/kg/dose BID (5 mg/kg/24 hr) up to the max. of 20 mg/kg/24 hr. '
              'Those requiring a more rapid titration from 10 mg/kg/24 hr to 20 mg/kg/24 '
              'hr may be titrated no more frequently than Q48 hr.'),
        ],
      ),
      DoseSection(
        heading: 'Dosage Reduction in Moderate and Severe Hepatic Impairment Prior to '
            'Initiation of Therapyᵃ',
        table: DoseTable(
          headers: ['Child-Pugh Category for Hepatic Impairment', 'Initial PO Dose (mg/kg/dose BID)', 'Maintenance PO Dose (mg/kg/dose BID)', 'Maximum PO Dose (mg/kg/dose BID)'],
          rows: [
            DoseTableRow(['B (moderate)', '1.25', '2.5', '5']),
            DoseTableRow(['C (severe)', '0.5', '1', '2']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃSlower dose titration has been suggested.'),
        ],
      ),
    ],
    remarks: [
      'Cannabidiol is no longer a controlled substance (FDA: April 6, 2020). '
          'Common side effects include somnolence, decreased appetite, diarrhea, '
          'elevated transaminase (dose related or with concomitant valproic acid and '
          'clobazam use), fatigue, malaise and asthenia, rash, insomnia, and sleep '
          'disorder. Suicidal behavior and ideation, hypersensitivity reactions, '
          'elevated serum creatinine, respiratory failure, cholestatic or mixed '
          'patterns of liver injury, and increased risk for pneumonia with '
          'concomitant clobazam have been reported.',
      'Monitor ALT, AST, and total bilirubin at baseline and 1, 3, and 6 mo '
          'initially and periodically thereafter. More frequent monitoring is '
          'recommended with concurrent valproic acid or clobazam. Reduce dose or '
          'discontinue use in the presence of hepatic impairment.',
      'Cannabidiol is a substrate for cytochrome P-450 (CYP) 2C19 and 3A4; other '
          'moderate/strong inducers or inhibitors for these enzymes may affect its '
          'overall exposure. May increase the effects/toxicity of clobazam and '
          'diazepam because it may inhibit CYP1A2, 2B6, 2C8, 2C9, and 2C19 and UGT '
          '1A9 and 2B7 transporters. May also inhibit P-glycoprotein transporters to '
          'increase effects/toxicity of sirolimus, tacrolimus, digoxin, and other '
          'P-glycoprotein substrates.',
      'Teratogen data limited to only animal studies, with evidence of '
          'developmental toxicities at similar exposure concentrations in humans '
          'receiving therapeutic doses. Patients exposed to cannabidiol during '
          'pregnancy are encouraged to register with the North American '
          'Antiepileptic Drug Pregnancy Registry at www.aedpregnancyregistry.org.',
      'Administration with high-fat or high-calorie meals may increase '
          'absorption. Gradually taper when discontinuing medication; avoid abrupt '
          'discontinuation to reduce risk for increased seizures.',
      'Use the supplied oral dosing syringe and bottle adapter and store the '
          'bottle of oral solution in the original bottle in the upright position at '
          '59–86°F. Discard the unused portion of each bottle 12 wk after first '
          'opening.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 900',
  ),
  // CAPTOPRIL — PDF p. 92 (printed 901)
  DrugEntryV3(
    name: 'CAPTOPRIL',
    brandNames: 'Various generics; previously available as Capoten',
    drugClass: 'Angiotensin-converting enzyme inhibitor, antihypertensive',
    iconRow: '',
    formulations: [
      'Tabs: 12.5, 25, 50, 100 mg',
      'Oral suspension: 1 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hypertension:',
        lines: [
          DoseLine('Neonate: Initially 0.01–0.05 mg/kg/dose PO Q8–12 hr; titrate upward if '
              'needed; max. dose: 0.5 mg/kg/dose Q6 hr'),
          DoseLine('Infant: Initially 0.05–0.3 mg/kg/dose PO BID–TID; titrate upward if '
              'needed; max. dose: 6 mg/kg/24 hr'),
          DoseLine('Child: Initially, 0.3–0.5 mg/kg/dose PO BID–TID; titrate upward if '
              'needed; max. dose: 6 mg/kg/24 hr up to 450 mg/24 hr'),
          DoseLine('Adolescent and adult: Initially, 12.5–25 mg/dose PO BID–TID; increase '
              'weekly if necessary by 25 mg/dose to max. dose: 450 mg/24 hr. Usual '
              'dosage range: 25–100 mg/24 hr ÷ BID'),
        ],
      ),
    ],
    remarks: [
      'Onset within 15–30 min of administration. Peak effect within 1–2 hr. '
          'Adjust dose with renal failure (see Chapter 32). Should be administered '
          'on an empty stomach 1 hr before or 2 hr after meals. Titrate to minimal '
          'effective dose. Lower doses should be used in patients with sodium and '
          'water depletion because of diuretic therapy.',
      'Use with caution in collagen vascular disease and with concomitant '
          'potassium-sparing diuretics. Avoid use with dialysis with high-flux '
          'membranes as anaphylactoid reactions have been reported. May cause rash, '
          'proteinuria, neutropenia, cough, angioedema (head, neck, and intestine), '
          'hyperkalemia, hypotension, or diminution of taste perception (with '
          'long-term use). Known to decrease aldosterone and increase renin '
          'production. Do not coadminister with angiotensin receptor blockers or '
          'aliskiren as use has been associated with increased risks for '
          'hypotension, hyperkalemia, and acute renal failure. Captopril is a '
          'cytochrome P-450 2D6 substrate. Use with sirolimus, everolimus, '
          'temsirolimus, or sacubitril may increase risk for angioedema.',
      'Captopril should be discontinued as soon as possible when pregnancy is '
          'detected.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 901',
  ),
  // CARBAMAZEPINE — PDF p. 92–93 (printed 901–902)
  DrugEntryV3(
    name: 'CARBAMAZEPINE',
    brandNames: 'Epitol, Tegretol, Tegretol-XR, Carbatrol, Equetro, and various '
        'generics',
    drugClass: 'Anticonvulsant',
    iconRow: '',
    formulations: [
      'Tabs: 200 mg',
      'Chewable tabs: 100, 200 mg',
      'Extended-release tabs (Tegretol-XR and generics): 100, 200, 400 mg',
      'Extended-release caps (Carbatrol, Equetro, and generics): 100, 200, 300 mg',
      'Oral suspension: 100 mg/5 mL (450 mL); may contain propylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Seizures (see remarks regarding specific dosage form, dosing '
            'interval, and pharmacogenomic considerations):',
        lines: [
          DoseLine(
            '<6 yr:',
            isHeading: true,
          ),
          DoseLine('Initial: 10–20 mg/kg/24 hr PO ÷ BID–TID (QID for oral suspension)'),
          DoseLine('Increment: Q5–7 days up to max. dose of 35 mg/kg/24 hr PO'),
          DoseLine(
            '6–12 yr:',
            isHeading: true,
          ),
          DoseLine('Initial: 10 mg/kg/24 hr PO ÷ BID (QID for oral suspension) up to max. '
              'dose: 100 mg/dose BID (50 mg/dose QID for oral suspension)'),
          DoseLine('Increment: 100 mg/24 hr at 1-wk intervals (÷ TID–QID) until desired '
              'response is obtained'),
          DoseLine('Maintenance: 20–30 mg/kg/24 hr PO ÷ BID–QID; usual maintenance dose is '
              '400–800 mg/24 hr; max. dose: 1000 mg/24 hr'),
          DoseLine(
            '>12 yr and adult:',
            isHeading: true,
          ),
          DoseLine('Initial: 200 mg PO BID (100 mg/dose QID for oral suspension)'),
          DoseLine('Increment: 200 mg/24 hr at 1-wk intervals (÷ BID–QID) until desired '
              'response is obtained'),
          DoseLine('Maintenance: 800–1200 mg/24 hr PO ÷ BID–QID'),
          DoseLine(
            'Max. dose:',
            isHeading: true,
          ),
          DoseLine('Child 12–15 yr: 1000 mg/24 hr'),
          DoseLine('Child >15 yr: 1200 mg/24 hr'),
          DoseLine('Adult: 1.6–2.4 g/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated for patients taking monoamine oxidase (MAO) inhibitors or '
          'who are sensitive to tricyclic antidepressants. Should not be used in '
          'combination with clozapine, owing to increased risk for bone marrow '
          'suppression and agranulocytosis. Increased risk for severe dermatologic '
          'reactions (e.g., Stevens-Johnson syndrome [SJS] and toxic epidermal '
          'necrolysis [TEN]) has been associated with the HLA-B*1502 (prevalent '
          'among Asian descent) and HLA-A*3101 (prevalent among Japanese, Native '
          'American, Southern Indian, and some Arabic ancestry) alleles.',
      'Erythromycin, diltiazem, verapamil, cefixime, cimetidine, itraconazole, '
          'aprepitant, and INH may increase serum levels. Carbamazepine may decrease '
          'activity of warfarin, direct-acting oral anticoagulants (e.g., '
          'rivaroxaban, apixaban), doxycycline, oral contraceptives, cyclosporine, '
          'theophylline, phenytoin, benzodiazepines, ethosuximide, and valproic '
          'acid. Carbamazepine is a cytochrome P-450 (CYP) 3A3/4 substrate and '
          'inducer of CYP1A2, 2B6, 2C8/9/19, and 3A3/4. The enzyme-inducing effects '
          'may increase effects/toxicity of cyclophosphamide. CYP3A4 inhibitors may '
          'increase carbamazepine levels/toxicity.',
      'Suggested dosing intervals for specific dosage forms: extended-release '
          'tabs or caps (BID); chewable and immediate-release tabs (BID–TID); oral '
          'suspension (TID–QID).',
      'Doses may be administered with food. Do not crush or chew '
          'extended-release dosage forms. Shake bottle well prior to dispensing oral '
          'suspension dosage form, and do not administer simultaneously with other '
          'liquid medicines or diluents.',
      'Drug metabolism typically increases after the first month of therapy '
          'initiation due to hepatic autoinduction.',
      'Therapeutic blood levels for seizures: 4–12 mg/L. Recommended serum '
          'sampling time: obtain trough level within 30 min prior to an oral dose. '
          'Steady state is typically achieved 1 mo following the initiation of '
          'therapy (following enzymatic autoinduction). Levels obtained prior to '
          'steady state are useful for preventing toxicity. Blood trough levels of '
          '7–10 mg/L have been recommended for bipolar disorders.',
      'Side effects include sedation, dizziness, diplopia, aplastic anemia, '
          'neutropenia, urinary retention, nausea, SIADH, and SJS. Suicidal behavior '
          'or ideation, cardiac conduction disturbances (including AV block), '
          'hepatic failure, hypogammaglobulinemia, and onychomadesis have been '
          'reported. Approximately one-third of patients who had hypersensitivity '
          'reactions will also experience the hypersensitivity to oxcarbazepine. '
          'Pretreatment complete blood counts (CBCs) and liver function tests (LFTs) '
          'are suggested. Patient should be monitored for hematologic and hepatic '
          'toxicity. Most common side effects with the IV route: dizziness, '
          'somnolence, blurred vision, diplopia, headache, infusion-related '
          'reaction, infusion site pain, and anemia.',
      'Adjust dose in renal impairment (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 901–902',
  ),
  // CARBAMIDE PEROXIDE — PDF p. 94 (printed 903)
  DrugEntryV3(
    name: 'CARBAMIDE PEROXIDE',
    brandNames: 'Otic solution: Debrox, Clearcanal Earwax Softener, GoodSense Ear '
        'Wax Removal, and many generic products',
    drugClass: 'Cerumenolytic, topical oral analgesic',
    iconRow: '',
    formulations: [
      'Otic solution (OTC): 6.5% (15 mL); may contain propylene glycol or alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Cerumenolytic:',
        lines: [
          DoseLine('<12 yr: Tilt head sideways and instill 1–5 drops (according to patient '
              'size) into affected ear; retain drops in ear for several minutes. Remove '
              'wax by gently flushing the ear with warm water, using a soft rubber bulb '
              'ear syringe. Dose may be repeated BID PRN for up to 4 days.'),
          DoseLine('≥12 yr: Following the same instructions as aforementioned, instill 5–10 '
              'drops into affected ear BID PRN for up to 4 days.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated if tympanic membrane is perforated; following otic '
          'surgery; with ear discharge, drainage, pain, irritation, or rash; or if '
          'PE tubes in place. Tip of applicator should not enter ear canal when used '
          'as a cerumenolytic.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 903',
  ),
  // CARBINOXAMINE — PDF p. 94–95 (printed 903–904)
  DrugEntryV3(
    name: 'CARBINOXAMINE',
    brandNames: 'Karbinal ER, RyVent, and many generics',
    drugClass: 'Antihistamine',
    iconRow: '',
    formulations: [
      'Immediate-release dosage forms:',
      'Oral liquid: 4 mg/5 mL (118 mL); may contain propylene glycol',
      'Tabs:',
      'Generics: 4, 6 mg',
      'RyVent: 6 mg',
      'Extended-release oral suspension:',
      '(Karbinal ER and generics): 4 mg/5 mL (480 mL); contains parabens and '
          'metasulfite',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child (PO; see remarks):',
        lines: [
          DoseLine('Immediate-release dosage forms: 0.2–0.4 mg/kg/24 hr PO ÷ TID–QID; '
              'alternative dosing by age (do not exceed 0.4 mg/kg/24 hr):'),
          DoseLine('2–5 yr: 1–2 mg TID–QID'),
          DoseLine('6–11 yr: 2–4 mg TID–QID'),
          DoseLine('≥12 yr: 4–8 mg TID–QID'),
          DoseLine(
            'Extended-release oral suspension (Karbinal ER and generics; approximately '
                '0.2–0.4 mg/kg/24 hr):',
            isHeading: true,
          ),
          DoseLine('2–3 yr: 3–4 mg Q12 hr'),
          DoseLine('4–5 yr: 3–8 mg Q12 hr'),
          DoseLine('6–11 yr: 6–12 mg Q12 hr'),
          DoseLine('≥12 yr: 6–16 mg Q12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult (PO):',
        lines: [
          DoseLine('Immediate-release dosage forms: 4–8 mg TID–QID'),
          DoseLine('RyVent: 6 mg TID-QID'),
          DoseLine('Extended-release oral suspension (Karbinal ER): 6–16 mg Q12 hr'),
        ],
      ),
    ],
    remarks: [
      'Generally not recommended for treating upper respiratory tract infections '
          '(URIs) in infants. No proven benefit for infants and young children with '
          'URIs. The FDA does not recommend use for URIs in children <2 yr because '
          'of reports of increased fatalities. Karbinal ER use is contraindicated in '
          'children <2 yr and in nursing mothers.',
      'Contraindicated in acute asthma, with other ethanolamine antihistamines '
          '(hypersensitivity), MAO inhibitors (prolongs and intensifies '
          'anticholinergic effects), severe hypertension, narrow-angle glaucoma, '
          'severe coronary artery disease, and urinary retention. Be aware that '
          'combination products containing a decongestant may exist.',
      'May cause drowsiness, vertigo, dry mucus membranes, and headache. '
          'Paradoxical excitation reactions more likely in younger children. Contact '
          'dermatitis and CNS excitation have been reported.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 903–904',
  ),
  // CARNITINE — PDF p. 95 (printed 904)
  DrugEntryV3(
    name: 'CARNITINE',
    brandNames: 'Levocarnitine, Carnitor, Carnitor SF, L-Carnitine, and generics',
    drugClass: 'Nutritional supplement, amino acid',
    iconRow: '',
    formulations: [
      'Tabs (Carnitor and generics): 330 mg',
      'Oral solution: 100 mg/mL (118 mL); contains methylparabens and '
          'propylparabens; Carnitor SF is a sugar-free product',
      'Injection: 200 mg/mL (5 mL); preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Primary carnitine deficiency:',
        lines: [
          DoseLine(
            'Oral:',
            isHeading: true,
          ),
          DoseLine('Child: 50–100 mg/kg/24 hr PO ÷ Q8–12 hr; increase slowly as needed and '
              'tolerated to max. dose of 3 g/24 hr'),
          DoseLine('Adult: 330 mg to 1 g/dose PO BID–TID; max. dose: 3 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Secondary carnitine deficiency:',
        lines: [
          DoseLine('IV:'),
          DoseLine('Child and adult: 50–100 mg/kg as loading dose; may follow with 50–100 '
              'mg/kg/24 hr IV infusion (for severe cases); maintenance: 50–100 mg/kg/24 '
              'hr ÷ Q4–6 hr; increase to max. dose of 300 mg/kg/24 hr if needed'),
        ],
      ),
    ],
    remarks: [
      'May cause nausea, vomiting, abdominal cramps, diarrhea, and body odor. '
          'Seizures have been reported in patients with or without a history of '
          'seizures.',
      'Safety in end-stage renal disease (ESRD) has not been established. High '
          'doses to severely compromised renal function or ESRD on dialysis may '
          'result in accumulation of potentially toxic metabolites (trimethylamine '
          'and trimethylamine-N-oxide). Serious hypersensitivity reactions, '
          'including anaphylaxis, have been reported with IV use mostly in ESRD '
          'patients undergoing dialysis.',
      'Give bolus IV infusion over 2–3 min.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 904',
  ),
  // CARVEDILOL — PDF p. 96 (printed 905)
  DrugEntryV3(
    name: 'CARVEDILOL',
    brandNames: 'Coreg, Coreg CR, and generics',
    drugClass: 'Adrenergic antagonist (α and β), antihypertensive',
    iconRow: '',
    formulations: [
      'Tabs (Coreg and generics): 3.125, 6.25, 12.5, 25 mg',
      'Extended-release caps (Coreg CR and generics): 10, 20, 40, 80 mg',
      'Oral suspension: 1 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Heart failure:',
        lines: [
          DoseLine(
            'Immediate-release dosage forms (tablets and oral suspension; see remarks):',
            isHeading: true,
          ),
          DoseLine(
            'Infant, child, adolescent (2013 Canadian Cardiovascular Society '
                'Guidelines):',
            isHeading: true,
          ),
          DoseLine('<62.5 kg: Start at 0.1 mg/kg/24 hr PO ÷ Q12 hr. Dose may be doubled every '
              '2 wk if needed and tolerated up to 0.8–1 mg/kg/24 hr ÷ Q12 hr. Due to '
              'altered pharmacokinetics, divide daily dosage by Q8 hr if child is <4 yr '
              'old.'),
          DoseLine('≥62.5 kg: Start at 3.125 mg PO BID. Dose may be doubled every 2 wk if '
              'needed and tolerated up to 25 mg BID. 25 mg PO TID may be needed for '
              'patients weighing >75 kg.'),
          DoseLine('Adult: Start at 3.125 mg PO BID × 2 wk; if needed and tolerated, may '
              'increase to 6.25 mg BID. Dose may be doubled every 2 wk if needed to the '
              'following max. doses:'),
          DoseLine('<85 kg: 25 mg BID'),
          DoseLine('≥85 kg: 50 mg BID'),
          DoseLine(
            'Extended-release capsules:',
            isHeading: true,
          ),
          DoseLine('Adult: Start at 10 mg PO once daily × 2 wk; if needed and tolerated, '
              'double the dose every 2 wk up to the maximum of 80 mg once daily.'),
        ],
      ),
      DoseSection(
        heading: 'Hypertension:',
        lines: [
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Immediate-release dosage forms: Start at 6.25 mg PO BID; dose may be '
              'doubled every 1–2 wk up to a maximum of 25 mg PO BID.'),
          DoseLine('Extended-release capsules: Start at 20 mg PO once daily × 1–2 wk; if '
              'needed and tolerated, increase to 40 mg PO once daily. If needed, dose '
              'may be further increased in 2-wk intervals up to a maximum of 80 mg/24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Immediate-release and extended-release products are NOT interchangeable '
          'on a mg-to-mg basis. Contraindicated in asthma or related bronchospastic '
          'disease, sick sinus syndrome, 2nd- or 3rd-degree heart block, severe '
          'bradycardia, cardiogenic shock, decompensated cardiac failure requiring '
          'IV inotropic therapy, and severe hepatic impairment (Child-Pugh class C).',
      'Use with caution in mild/moderate hepatic impairment (Child-Pugh class A '
          'or B), renal insufficiency, thyrotoxicosis, ischemic heart disease, '
          'diabetes, and cataract surgery. Avoid abrupt withdrawal of medication. As '
          'with all beta-blockers, early signs of hypoglycemia (e.g., tachycardia) '
          'may be masked.',
      'Children <3½ yr old may have faster carvedilol clearance and may require '
          'higher dosages or TID dosing. Carvedilol is a cytochrome P-450 2D6 '
          'substrate. Digoxin, disopyramide, and dipyridamole may increase '
          'bradycardic effects.',
      'Bradycardia, postural hypotension, peripheral edema, weight gain, '
          'hyperglycemia, diarrhea, dizziness, and fatigue are common. '
          'Hypersensitivity reactions have been reported. Chest pain, headache, '
          'vomiting, edema, and dyspnea have also been reported in children. '
          'Administering doses with food can reduce risk for orthostatic hypotension.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 905',
  ),
  // CASPOFUNGIN — PDF p. 97 (printed 906)
  DrugEntryV3(
    name: 'CASPOFUNGIN',
    brandNames: 'Cancidas and generics',
    drugClass: 'Antifungal, echinocandin',
    iconRow: '',
    formulations: [
      'Injection: 50, 70 mg; contains sucrose (39 mg in 50-mg vial and 54 mg in '
          '70-mg vial) and mannitol (26 mg in 50-mg vial and 36 mg in 70-mg vial)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Preterm neonate to <3-mo infant:',
        lines: [
          DoseLine('BSA dosing (based on a small pharmacokinetic study, achieving similar '
              'plasma exposure as seen in adults receiving 50 mg/24 hr): 25 mg/m²/dose '
              'IV once daily'),
          DoseLine('Weight-based dosing (based on prospective, randomized, double-blinded, '
              'controlled, and case series data): 2 mg/kg/dose IV once daily for at '
              'least 2 wk after first negative blood culture and resolution of '
              'signs/symptoms for invasive candidiasis has been reported to be more '
              'efficacious with fewer side effects than conventional amphotericin B.'),
        ],
      ),
      DoseSection(
        heading: '3-mo infant–17 yr (see remarks):',
        lines: [
          DoseLine('70 mg/m²/dose IV loading dose on day 1 followed by 50 mg/m²/dose IV '
              'once-daily maintenance dose. Increase the maintenance dose to 70 '
              'mg/m²/dose if response is inadequate or if the patient is receiving an '
              'enzyme-inducing medication (see remarks).'),
          DoseLine('Maximum loading and maintenance dose: 70 mg/dose'),
        ],
      ),
      DoseSection(
        heading: 'Adult (see remarks):',
        lines: [
          DoseLine('Loading dose: 70 mg IV × 1'),
          DoseLine(
            'Maintenance dose:',
            isHeading: true,
          ),
          DoseLine('Usual: 50 mg IV once daily. If tolerated and response is inadequate or if '
              'patient is receiving an enzyme-inducing medication (see remarks), '
              'increase to 70 mg IV once daily.'),
          DoseLine('Moderate hepatic insufficiency (Child-Pugh score 7–9; see remarks): 35 mg '
              'IV once daily is recommended in the FDA label. However, several '
              'pharmacokinetic evaluations suggest the reduced dosage may result in '
              'subtherapeutic levels for these patients.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in hepatic impairment and concomitant enzyme-inducing '
          'drugs. Higher maintenance doses (70 mg/m²/dose [not to exceed 70 mg] in '
          'children and 70 mg in adults) are recommended for concomitant use of '
          'enzyme inducers such as carbamazepine, dexamethasone, phenytoin, '
          'nevirapine, efavirenz, or rifampin. Use Mosteller formula for calculating '
          'body surface area (BSA).',
      'Most common adverse effects (>10%) in children include fever, diarrhea, '
          'rash, elevated aspartate transaminase/alanine transaminase (ALT/AST), '
          'hypokalemia, hypotension, and chills. May also cause facial swelling, '
          'nausea/vomiting, headache, infusion site phlebitis, and LFT elevation. '
          'Anaphylaxis, TEN, SJS, and possible histamine-related reactions '
          '(angioedema, bronchospasm, and warmth sensation) have been reported. '
          'Hepatobiliary adverse effects have been reported in pediatric patients '
          'with serious underlying medical conditions.',
      'Despite the FDA labeling recommendation for reducing the daily '
          'maintenance dose by 30% in moderate hepatic impairment (Child-Pugh score '
          '7–9), several pharmacokinetic evaluations suggest this dose reduction may '
          'result in subtherapeutic levels. No dosage adjustment is needed for mild '
          'hepatic impairment (Child-Pugh score 5-6) and there is no clinical '
          'experience with severe hepatic impairment (Child-Pugh score >9).',
      'Use with cyclosporine may cause transient increase in LFTs and '
          'caspofungin level elevations. May decrease tacrolimus levels.',
      'Administer doses by slow IV infusion over 1 hr. Do not mix or co-infuse '
          'with other medications, and avoid using dextrose-containing diluents '
          '(e.g., D₅W).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 906',
  ),
  // CEFADROXIL — PDF p. 98 (printed 907)
  DrugEntryV3(
    name: 'CEFADROXIL',
    brandNames: 'Generics; previously available as Duricef',
    drugClass: 'Antibiotic, cephalosporin (first generation)',
    iconRow: '',
    formulations: [
      'Oral suspension: 250 mg/5 mL (100 mL), 500 mg/5 mL (75, 100 mL)',
      'Tabs: 1 g',
      'Caps: 500 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infant and child:',
        lines: [
          DoseLine('Skin and soft tissue infection, and cystitis: 30 mg/kg/24 hr PO ÷ Q12 hr; '
              'max. dose: 2 g/24 hr'),
          DoseLine('Group A β-hemolytic streptococci pharyngitis/tonsillitis: 30 mg/kg/24 hr '
              'PO ÷ Q12–24 hr; max. dose: 1 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adolescent and adult:',
        lines: [
          DoseLine('1–2 g/24 hr PO ÷ Q12–24 hr (administer 1 g Q12 hr for complicated UTIs); '
              'max. dose: 2 g/24 hr'),
          DoseLine('Group A β-hemolytic streptococci pharyngitis/tonsillitis: 1 g /24 hr PO ÷ '
              'Q12–24 hr; max. dose: 1 g/24 hr'),
        ],
      ),
    ],
    remarks: [
      'See Cephalexin for precautions and interactions. Rash, nausea, vomiting, '
          'and diarrhea are common. Transient neutropenia and vaginitis have been '
          'reported. Adjust dose in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 907',
  ),
  // CEFAZOLIN — PDF p. 98–99 (printed 907–908)
  DrugEntryV3(
    name: 'CEFAZOLIN',
    brandNames: 'Generics; previously available as Ancef',
    drugClass: 'Antibiotic, cephalosporin (first generation)',
    iconRow: '',
    formulations: [
      'Injection: 0.5, 1, 2, 3, 10, 20 g',
      'Frozen injection: 1 g/50 mL (contains 2 g dextrose to make an iso-osmotic '
          'solution), 2 g/100 mL (contains 4 g dextrose to make an iso-osmotic '
          'solution), 3 g/150 mL (contains 6 g dextrose to make an iso-osmotic '
          'solution)',
      'Contains 2.1 mEq Na/g drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate (IM/IV):',
        lines: [
          DoseLine(
            'Postnatal age ≤7 days:',
            isHeading: true,
          ),
          DoseLine('≤2000 g: 50 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine('>2000 g: 100 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine(
            'Postnatal age >7–28 days:',
            isHeading: true,
          ),
          DoseLine('≤2000 g: 75 mg/kg/24 hr ÷ Q8 hr'),
          DoseLine('>2000 g: 150 mg/kg/24 hr ÷ Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Infant >1 mo and child (IM/IV):',
        lines: [
          DoseLine('Mild/moderate infection: 25–100 mg/kg/24 hr ÷ Q6–8 hr; max. dose: 6 g/24 '
              'hr'),
          DoseLine('Severe infection: 100–150 mg/kg/24 hr ÷ Q6–8 hr (max. dose: 12 g/24 hr); '
              '150 mg/kg/24 hr ÷ Q6–8 hr has been recommended for bone/joint infections'),
        ],
      ),
      DoseSection(
        heading: 'Adult (IM/IV):',
        lines: [
          DoseLine('1–2 g/dose Q8 hr; max. dose: 12 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Bacterial endocarditis prophylaxis for dental and upper respiratory '
            'procedures (IM/IV):',
        lines: [
          DoseLine('Infant and child: 50 mg/kg (max. dose: 1 g) 30–60 min before procedure'),
          DoseLine('Adult: 1 g 30–60 min before procedure'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in renal impairment or in penicillin-allergic patients. '
          'Does not penetrate well into cerebrospinal fluid (CSF). May cause '
          'phlebitis, leukopenia, thrombocytopenia, transient liver enzyme '
          'elevation, and false-positive urine-reducing substance (e.g., Clinitest, '
          'Benedict’s solution, or Fehling’s solution) and Coombs test. Enzymatic '
          'glucose oxidase urinary glucose tests (e.g., Clinistix or Tes-Tape) are '
          'recommended. Adjust dose in renal failure (see Chapter 32).',
      'For dosing in obese patients, use higher end of the dosing recommendation.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 907–908',
  ),
  // CEFDINIR — PDF p. 99 (printed 908)
  DrugEntryV3(
    name: 'CEFDINIR',
    brandNames: 'Generics; previously available as Omnicef',
    drugClass: 'Antibiotic, cephalosporin (third generation)',
    iconRow: '',
    formulations: [
      'Caps: 300 mg',
      'Oral suspension: 125 mg/5 mL (60, 100 mL), 250 mg/5 mL (60, 100 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: '6 mo–12 yr (see remarks):',
        lines: [
          DoseLine('Second-line therapy for otitis media or pharyngitis/tonsillitis (NOT '
              'RECOMMENDED for CAP, acute bacterial rhinosinusitis, UTI, uncomplicated '
              'skin infections, or penicillin-resistant streptococci): 14 mg/kg/24 hr PO '
              '÷ Q12–24 hr; max. dose: 600 mg/24 hr'),
          DoseLine('Second-line therapy for uncomplicated skin infections (first-generation '
              'cephalosporin may be more appropriate): 14 mg/kg/24 hr PO ÷ Q12 hr; max. '
              'dose: 600 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: '≥13 yr and adult (see remarks):',
        lines: [
          DoseLine('Second-line therapy for bronchitis, sinusitis, pharyngitis/tonsillitis: '
              '600 mg/24 hr PO ÷ Q12–24 hr'),
          DoseLine('Second-line therapy for community-acquired pneumonia (CAP), UTI, '
              'uncomplicated skin infections (first-generation cephalosporin may be more '
              'appropriate): 600 mg/24 hr PO ÷ Q12 hr'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in penicillin-allergic patients or in presence of renal '
          'impairment. DO NOT utilize ceftriaxone S. pneumoniae or gram-negative '
          'bacteria susceptibilities for cefdinir. Poor penetration into the urine '
          'and pulmonary tissue have been reported along with inadequate activity '
          'with penicillin-resistant pneumococci are reasons for avoiding use in '
          'CAP, UTI and other infections involving the risk for penicillin-resistant '
          'pneumococci. Bioavailability has been reported at 16-25% with serum '
          'protein binding at 60-70%.',
      'May cause diarrhea (especially in children <2 yr), headache, vaginitis, '
          'and false-positive urine-reducing substance (e.g., Clinitest, Benedict’s '
          'solution, or Fehling’s solution) and Coombs test. Enzymatic glucose '
          'oxidase urinary glucose tests (e.g., Clinistix or Tes-Tape) are '
          'recommended. Eosinophilia and abnormal LFTs have been reported with '
          'higher-than-usual doses.',
      'Probenecid increases serum cefdinir levels. Avoid concomitant '
          'administration with iron and iron-containing vitamins and antacids '
          'containing aluminum or magnesium (space 2 hr apart) to reduce the risk '
          'for decreasing antibiotic’s absorption. May cause red stools when '
          'administered with iron and iron-containing products. Doses may be taken '
          'without regard to food. Adjust dose in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 908',
  ),
  // CEFEPIME — PDF p. 99–100 (printed 908–909)
  DrugEntryV3(
    name: 'CEFEPIME',
    brandNames: 'Generics; previously available as Maxipime',
    drugClass: 'Antibiotic, cephalosporin (fourth generation)',
    iconRow: '',
    formulations: [
      'Injection: 1, 2, 100 g',
      'Premixed injection: 1 g/50 mL, 2 g/100 mL (iso-osmotic dextrose solutions)',
      'Each 1 g drug contains 725 mg L-arginine.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate (IV/IM):',
        lines: [
          DoseLine('<36 wk gestation: 60 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine('≥36 wk gestation: 100 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine(
            'Meningitis or Pseudomonas infections:',
            isHeading: true,
          ),
          DoseLine('<1 kg and 0–14 days old, or 1–2 kg and <0–7 days old: 100 mg/kg/24 hr ÷ '
              'Q12 hr'),
          DoseLine('<1 kg and >14 days old, or 1–2 kg and >7 days old, or >2 kg and 0–30 days '
              'old: 150 mg/kg/24 hr ÷ Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Child ≥2 mo (IV/IM):',
        lines: [
          DoseLine('100 mg/kg/24 hr ÷ Q12 hr; max. dose: 4 g/24 hr'),
          DoseLine('Meningitis, fever, and neutropenia, or serious infections: 150 mg/kg/24 '
              'hr ÷ Q8 hr; max. dose: 2 g/single dose or 6 g/24 hr'),
          DoseLine('Alternative extended infusion for elevated MICs or in serious infections: '
              'infuse each dose over 3–4 hours for optimizing the antibiotic exposure '
              'time above the MIC.'),
        ],
      ),
      DoseSection(
        heading: 'Cystic fibrosis (IV/IM):',
        lines: [
          DoseLine('150 mg/kg/24 hr ÷ Q8 hr, up to a max. dose of 6 g/24 hr. Higher dose of '
              '200 mg/kg/24 hr ÷ Q6 hr (max. dose: 8 g/24 hr) has been recommended for '
              'resistant Pseudomonas isolates. The aforementioned extended-infusion '
              'method of dose administration may be used.'),
        ],
      ),
      DoseSection(
        heading: 'Adult (IV/IM):',
        lines: [
          DoseLine('1–4 g/24 hr ÷ Q12 hr'),
          DoseLine('Severe infections: 6 g/24 hr ÷ Q8 hr'),
          DoseLine('Max. dose: 6 g/24 hr'),
          DoseLine('Alternative extended infusion for elevated MICs or in serious infections: '
              'Infuse each dose over 3–4 hours for optimizing the antibiotic exposure '
              'time above the MIC.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in patients with penicillin allergy or renal impairment. '
          'Good activity against Pseudomonas aeruginosa and other Gram-negative '
          'bacteria plus most Gram-positives (methicillin-sensitive Staphylococcus '
          'aureus). Extended/continuous infusion administration is an option for '
          'treating resistant isolates.',
      'May cause thrombophlebitis, GI discomfort, transient increases in liver '
          'enzymes, and false-positive urine-reducing substance (e.g., Clinitest, '
          'Benedict’s solution, or Fehling’s solution) and Coombs test. Enzymatic '
          'glucose oxidase urinary glucose tests (e.g., Clinistix or Tes-Tape) are '
          'recommended. Probenecid increases serum cefepime levels. Encephalopathy, '
          'myoclonus, seizures (including nonconvulsive status epilepticus), '
          'aphasia, transient leukopenia, neutropenia, agranulocytosis, and '
          'thrombocytopenia have been reported. Reported neurotoxicity (e.g., '
          'encephalopathy, aphasia, myoclonus, and seizures) may be attributed to '
          'cefepime’s concentration-dependent GABA inhibitory effects. Adjust dose '
          'in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 908–909',
  ),
  // CEFIDEROCOL — PDF p. 100–101 (printed 909–910)
  DrugEntryV3(
    name: 'CEFIDEROCOL',
    brandNames: 'Fetroja',
    drugClass: 'Antibiotic, cephalosporin (siderophore type)',
    iconRow: '',
    formulations: [
      'Injection: 1 g; contains sucrose',
      'Contains 3.7 mEq Na/g drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infant <3 mo (limited data based on pharmacokinetic allometric '
            'scaling techniques to replicate similar adult exposure levels; infuse '
            'doses IV over 1 hr):',
        lines: [
          DoseLine(
            '<2 mo:',
            isHeading: true,
          ),
          DoseLine('<32 wk gestation: 30 mg/kg/dose IV Q8 hr'),
          DoseLine('≥32 wk gestation: 40 mg/kg/dose IV Q8 hr'),
          DoseLine(
            '2–<3 mo:',
            isHeading: true,
          ),
          DoseLine('<32 wk gestation: 40 mg/kg/dose IV Q8 hr'),
          DoseLine('≥32 wk gestation: 60 mg/kg/dose IV Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Child ≥3 mo–<18 yr (current dosage being evaluated in clinical trials '
            'for suspected or confirmed Gram-negative bacterial infections; infuse '
            'doses IV over 3 hr):',
        lines: [
          DoseLine('<34 kg: 60 mg/kg/dose IV Q8 hr'),
          DoseLine('≥34 kg: 2 g IV Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Hospital-acquired pneumonia, ventilator-associated pneumonia, and UTI '
              '(infuse doses IV over 3 hr): 2 g IV Q8 hr'),
          DoseLine('Patients with eGFR ≥120 mL/min: 2 g IV Q6 hr'),
        ],
      ),
    ],
    remarks: [
      'Possesses a unique mechanism of action for having a catechol side chain '
          'that chelates with iron to enable iron transport systems to deliver '
          'cefiderocol to the outer membrane of Gram-negative aerobic bacteria. Its '
          'cephalosporin moiety then exerts its bactericidal properties by binding '
          'to penicillin-binding proteins.',
      'Use with caution in penicillin-, cephalosporin-, or beta-lactam–allergic '
          'patients or in the presence of renal impairment (adjust dose in renal '
          'failure; see Chapter 32). Common side effects include injection site '
          'reaction, rash, increased LFTs, hypokalemia, diarrhea, constipation, GI '
          'disturbance, and headache. Hypomagnesemia, hypersensitivity reactions, '
          'atrial fibrillation, seizures, and increase in mortality in patients with '
          'carbapenem-resistant Gram-negative bacterial infections have been '
          'reported in adults. May cause false-positive results for urine dipstick '
          'tests (urine protein, ketones, or occult blood) and Coombs test.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 909–910',
  ),
  // CEFIXIME — PDF p. 101 (printed 910)
  DrugEntryV3(
    name: 'CEFIXIME',
    brandNames: 'Generics; previously available as Suprax',
    drugClass: 'Antibiotic, cephalosporin (third generation)',
    iconRow: '',
    formulations: [
      'Oral suspension: 100 mg/5 mL (50 mL), 200 mg/5 mL (50, 75 mL); may '
          'contain sodium benzoate',
      'Caps: 400 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infant (>6 mo) and child:',
        lines: [
          DoseLine('8 mg/kg/24 hr PO ÷ Q12–24 hr; max. dose: 400 mg/24 hr'),
          DoseLine('Alternative dosing for acute UTI: 16 mg/kg/24 hr PO ÷ Q12 hr on day 1, '
              'followed by 8 mg/kg/24 hr Q24 hr PO × 13 days. Max. dose: 400 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adolescent and adult:',
        lines: [
          DoseLine('400 mg/24 hr PO ÷ Q12–24 hr'),
          DoseLine('Uncomplicated cervical, urethral, or rectal infections due to Neisseria '
              'gonorrhoeae (not recommended as first-line cephalosporin by the CDC; '
              'ceftriaxone is preferred; use only when ceftriaxone is not available): '
              '800 mg × 1 PO plus doxycycline 100 mg PO BID × 7 days'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in patients with penicillin allergy or renal failure. '
          'Adverse reactions include diarrhea (16% incidence reported in clinical '
          'trials), abdominal pain, nausea, and headaches. Transient increase in '
          'AST/ALT has been reported. Activity is inadequate against '
          'penicillin-resistant pneumococci.',
      'The capsule dosage form is NOT considered bioequivalent to the oral '
          'suspension and should not be used for the treatment of otitis media. '
          'Probenecid increases serum cefixime levels. Unlike most cephalosporins, '
          'drug is excreted unchanged in the bile (5%–10%) and urine (50%). May '
          'increase carbamazepine serum concentrations. May cause false-positive '
          'urine-reducing substance (e.g., Clinitest, Benedict’s solution, or '
          'Fehling’s solution), Coombs test, and nitroprusside test for ketones. '
          'Enzymatic glucose oxidase urinary glucose tests (e.g., Clinistix or '
          'Tes-Tape) are recommended. Adjust dose in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 910',
  ),
  // CEFOTAXIME — PDF p. 102 (printed 911)
  DrugEntryV3(
    name: 'CEFOTAXIME',
    brandNames: 'Generics; previously available as Claforan',
    drugClass: 'Antibiotic, cephalosporin (third generation)',
    iconRow: '',
    formulations: [
      'Injection: 1, 2 g',
      'Contains 2.2 mEq Na/g drug',
      'May not be available in the United States but the FDA had allowed '
          'temporary importation from Canada via Direct Success at '
          'distribution@dsuccess.com or 1-877-404-3338.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate (IV/IM):',
        lines: [
          DoseLine(
            '<32 wk gestation:',
            isHeading: true,
          ),
          DoseLine('<7 days old: 100 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine('≥7 days old: 150 mg/kg/24 hr ÷ Q8 hr'),
          DoseLine(
            '≥32 wk gestation:',
            isHeading: true,
          ),
          DoseLine('≤7 days old: 100 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine('>7 days old: 150 mg/kg/24 hr ÷ Q8 hr'),
          DoseLine(
            'Meningitis (minimum 21 days of therapy):',
            isHeading: true,
          ),
          DoseLine('Postnatal age ≤7 days: 100–150 mg/kg/24 hr ÷ Q8–12 hr'),
          DoseLine('Postnatal age >7 days: 150–200 mg/kg/24 hr ÷ Q6–8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Infant and child (1 mo–12 yr and <50 kg) (IV/IM):',
        lines: [
          DoseLine('150–200 mg/kg/24 hr ÷ Q6–8 hr. Higher doses of 150–225 mg/kg/24 hr ÷ Q6–8 '
              'hr have been recommended for infections outside the CSF due to '
              'penicillin-resistant pneumococci.'),
          DoseLine('Meningitis: 200 mg/kg/24 hr ÷ Q6 hr. Higher doses of 225–300 mg/kg/24 hr '
              '÷ Q6–8 hr (some recommend 300 mg/kg/24 hr ÷ Q4–6 hr), in combination with '
              'vancomycin (dosed at CNS target levels), have been recommended for '
              'meningitis due to penicillin-resistant pneumococci.'),
          DoseLine('Max. dose: 12 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Child (>12 yr or ≥50 kg) and adult (IV/IM):',
        lines: [
          DoseLine('1–2 g/dose Q6–8 hr'),
          DoseLine('Severe infection: 2 g/dose Q4–6 hr'),
          DoseLine('Max. dose: 12 g/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in penicillin allergy and renal impairment (reduce '
          'dosage). Toxicities similar to other cephalosporins: allergy, '
          'neutropenia, thrombocytopenia, eosinophilia, false-positive '
          'urine-reducing substance (e.g., Clinitest, Benedict’s solution, or '
          'Fehling’s solution) and Coombs test, and elevated BUN, creatinine, and '
          'liver enzymes. Enzymatic glucose oxidase urinary glucose tests (e.g., '
          'Clinistix or Tes-Tape) are recommended. Probenecid increases serum '
          'cefotaxime levels.',
      'Good CNS penetration. Adjust dose in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 911',
  ),
  // CEFOTETAN — PDF p. 102–103 (printed 911–912)
  DrugEntryV3(
    name: 'CEFOTETAN',
    brandNames: 'Generics; previously available as Cefotan',
    drugClass: 'Antibiotic, cephalosporin (second generation)',
    iconRow: '',
    formulations: [
      'Injection: 1, 2 g',
      'Contains 3.5 mEq Na/g drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infant and child (IV/IM, limited data):',
        lines: [
          DoseLine('Mild/moderate infection: 60 mg/kg/24 hr ÷ Q12 hr; max. single dose: 2 '
              'g/dose'),
          DoseLine('Severe infection: 100 mg/kg/24 hr ÷ Q12 hr; max. single dose: 3 g/dose'),
          DoseLine('Intra-abdominal infection: 40–80 mg/kg/24 hr ÷ Q12 hr; max. dose: 6 g/24 '
              'hr'),
        ],
      ),
      DoseSection(
        heading: 'Adolescent and adult:',
        lines: [
          DoseLine('2–4 g/24 hr ÷ Q12 hr IV/IM; max. dose: 6 g/24 hr'),
          DoseLine('PID: 2 g Q12 hr IV × 24–48 hr after clinical improvement. Doxycycline 100 '
              'mg Q12 hr PO/IV × 14 days is also initiated at the same time.'),
        ],
      ),
      DoseSection(
        heading: 'Max. dose (all ages):',
        lines: [
          DoseLine('IV: 6 g/24 hr; IM 4 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Preoperative prophylaxis (30–60 min before procedure; may repeat dose '
            'in 6 hr if lengthy procedure or excessive blood loss):',
        lines: [
          DoseLine('Child: 40 mg/kg/dose (max. dose: 2 g/dose) IV'),
          DoseLine('Adult: 2 g IV'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in penicillin-allergic patients or in presence of renal '
          'impairment. May cause disulfiram-like reaction with ethanol, increase '
          'effects/toxicities of anticoagulants, and result in false-positive '
          'urine-reducing substance (e.g., Clinitest, Benedict’s solution, or '
          'Fehling’s solution), and false elevations of serum and urine creatinine '
          '(Jaffe method). Enzymatic glucose oxidase urinary glucose tests (e.g., '
          'Clinistix or Tes-Tape) are recommended. Hemolytic anemia and liver enzyme '
          'elevations have been reported. Good anaerobic activity but poor CSF '
          'penetration. Adjust dose in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 911–912',
  ),
  // CEFOXITIN — PDF p. 103–104 (printed 912–913)
  DrugEntryV3(
    name: 'CEFOXITIN',
    brandNames: 'Generics; previously available as Mefoxin',
    drugClass: 'Antibiotic, cephalosporin (second generation)',
    iconRow: '',
    formulations: [
      'Injection: 1, 2, 10 g',
      'Contains 2.3 mEq Na/g drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate (IM/IV):',
        lines: [
          DoseLine(
            '<32 wk gestation:',
            isHeading: true,
          ),
          DoseLine('≤7 days old: 70 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine('>7 days old: 105 mg/kg/24 hr ÷ Q8 hr'),
          DoseLine('≥32 wk gestation: 105 mg/kg/24 hr ÷ Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Infant and child (IM/IV):',
        lines: [
          DoseLine('Mild/moderate infections: 80–100 mg/kg/24 hr ÷ Q6–8 hr'),
          DoseLine('Severe infections: 100–160 mg/kg/24 hr ÷ Q4–6 hr'),
        ],
      ),
      DoseSection(
        heading: 'PID (child ≥45 kg and adolescent):',
        lines: [
          DoseLine('Mild/moderate acute PID: 2 g IM x 1 and probenecid 1 g PO x 1, + '
              'doxycycline 100 mg PO Q12 hr and metronidazole 500 mg PO Q12 hr × 14 days'),
          DoseLine('Severe acute PID: 2 g IV Q6 hr × 24–48 hr after clinical improvement. '
              'Doxycycline 100 mg Q12 hr PO/IV × 14 days is also initiated at the same '
              'time.'),
        ],
      ),
      DoseSection(
        heading: 'Adult (IM/IV):',
        lines: [
          DoseLine('1–2 g/dose Q6–8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Max. dose (all ages):',
        lines: [
          DoseLine('12 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Preoperative prophylaxis (30–60 min before procedure; may repeat dose '
            'in 2 hr for lengthy procedure or excessive blood loss):',
        lines: [
          DoseLine('Child: 40 mg/kg/dose (max. dose: 2 g/dose) IV'),
          DoseLine('Adult: 2 g IV'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in penicillin-allergic patients or in presence of renal '
          'impairment. Has good anaerobic activity but poor CSF penetration. May '
          'cause injection site reaction and thrombophlebitis. Transient increases '
          'in LFTs have been reported.',
      'Probenecid increases serum cefoxitin levels. May cause false-positive '
          'urine-reducing substance (e.g., Clinitest, Benedict’s solution, or '
          'Fehling’s solution) and false elevations of serum and urine creatinine '
          '(Jaffe and KDA methods). Enzymatic glucose oxidase urinary glucose tests '
          '(e.g., Clinistix or Tes-Tape) are recommended.',
      'Adjust dose in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 912–913',
  ),
  // CEFPODOXIME PROXETIL — PDF p. 104 (printed 913)
  DrugEntryV3(
    name: 'CEFPODOXIME PROXETIL',
    brandNames: 'Generics; previously available as Vantin',
    drugClass: 'Antibiotic, cephalosporin (third generation)',
    iconRow: '',
    formulations: [
      'Tabs: 100, 200 mg',
      'Oral suspension: 50, 100 mg/5 mL (50, 100 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: '2 mo–11 yr:',
        lines: [
          DoseLine('Otitis media: 10 mg/kg/24 hr PO ÷ Q12 hr × 5–10 days; max. dose: 400 '
              'mg/24 hr'),
          DoseLine('Pharyngitis/tonsillitis: 10 mg/kg/24 hr PO ÷ Q12 hr × 5–10 days; max. '
              'dose: 200 mg/24 hr'),
          DoseLine('Acute maxillary sinusitis: 10 mg/kg/24 hr PO ÷ Q12 hr × 10 days; max. '
              'dose: 400 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: '≥12 yr–adult:',
        lines: [
          DoseLine('Exacerbation of chronic bronchitis, community-acquired pneumonia, and '
              'sinusitis: 400 mg/24 hr PO ÷ Q12 hr × 10 days (14 days for pneumonia)'),
          DoseLine('Pharyngitis/tonsillitis: 200 mg/24 hr PO ÷ Q12 hr × 5–10 days'),
          DoseLine('Skin/skin structure infection: 800 mg/24 hr PO ÷ Q12 hr × 7–14 days'),
          DoseLine('Uncomplicated UTI: 200 mg/24 hr PO ÷ Q12 hr × 5–7 days'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in penicillin-allergic patients or in presence of renal '
          'impairment. May cause diarrhea, nausea, vomiting, vaginal candidiasis, '
          'and false-positive urine-reducing substance (e.g., Clinitest, Benedict’s '
          'solution, or Fehling’s solution) and Coombs test. Enzymatic glucose '
          'oxidase urinary glucose tests (e.g., Clinistix or Tes-Tape) are '
          'recommended. Transient elevation of ALT/SGPT has been reported in '
          'clinical trials.',
      'Tablets should be administered with food to enhance absorption. '
          'Suspension may be administered without regard to food. High doses of '
          'antacids or H₂ blockers may reduce absorption. Probenecid increases serum '
          'cefpodoxime levels.',
      'Cefpodoxime proxetil is a prodrug that is de-esterified in the GI tract '
          'to the active cefpodoxime. Adjust dose in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 913',
  ),
  // CEFPROZIL — PDF p. 104–105 (printed 913–914)
  DrugEntryV3(
    name: 'CEFPROZIL',
    brandNames: 'Generics; previously available as Cefzil',
    drugClass: 'Antibiotic, cephalosporin (second generation)',
    iconRow: '',
    formulations: [
      'Tabs: 250, 500 mg',
      'Oral suspension: 125 mg/5 mL, 250 mg/5 mL (50, 75, 100 mL); contains '
          'aspartame and phenylalanine',
    ],
    doseSections: [
      DoseSection(
        heading: 'Otitis media:',
        lines: [
          DoseLine('6 mo–12 yr: 30 mg/kg/24 hr PO ÷ Q12 hr; max. dose: 1 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Pharyngitis/tonsillitis:',
        lines: [
          DoseLine('2–12 yr: 15 mg/kg/24 hr PO ÷ Q12 hr; max. dose: 1 g/24 hr'),
          DoseLine('≥13 yr: 500 mg PO Q24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Acute sinusitis:',
        lines: [
          DoseLine('6 mo–12 yr: 15–30 mg/kg/24 hr PO ÷ Q12 hr; max. dose: 1 g/24 hr'),
          DoseLine('>12 yr: 250 or 500 mg PO Q12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Uncomplicated skin infections:',
        lines: [
          DoseLine('2–12 yr: 20 mg/kg/24 hr PO Q24 hr; max. dose: 500 mg/dose'),
          DoseLine('>12 yr: 250 mg PO Q12 hr or 500 mg PO Q12–24 hr'),
        ],
      ),
      DoseSection(
        heading: 'UTI:',
        lines: [
          DoseLine('2–24 mo: 30 mg/kg/24 hr PO ÷ Q12 hr'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in penicillin-allergic patients or in presence of renal '
          'impairment. Oral suspension contains aspartame and phenylalanine and '
          'should not be used by phenylketonurics. May cause nausea, vomiting, '
          'diarrhea, liver enzyme elevations, and false-positive urine-reducing '
          'substance (e.g., Clinitest, Benedict’s solution, or Fehling’s solution) '
          'and Coombs test. Enzymatic glucose oxidase urinary glucose tests (e.g., '
          'Clinistix or Tes-Tape) are recommended. Probenecid increases serum '
          'cefprozil levels. Absorption is not affected by food. Adjust dose in '
          'renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 913–914',
  ),
  // CEFTAROLINE FOSAMIL — PDF p. 105 (printed 914)
  DrugEntryV3(
    name: 'CEFTAROLINE FOSAMIL',
    brandNames: 'Teflaro',
    drugClass: 'Antibiotic, cephalosporin (fifth generation)',
    iconRow: '',
    formulations: [
      'Injection: 400, 600 mg; contains L-arginine',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate and infant (< 2 mo):',
        lines: [
          DoseLine('≥34 wk gestation and ≥12 days old: 6 mg/kg/dose IV Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Child (2 mo–<18 yr):',
        lines: [
          DoseLine(
            'Acute bacterial skin and skin structure infection (ABSSSI) and '
                'community-acquired bacterial pneumonia (CABP):',
            isHeading: true,
          ),
          DoseLine('Infant <2 mo (ABSSSI indication only): 6 mg/kg/dose IV Q8 hr'),
          DoseLine('2 mo–<2 yr: 8 mg/kg/dose IV Q8 hr'),
          DoseLine(
            '≥2 yr–<18 yr:',
            isHeading: true,
          ),
          DoseLine('≤33 kg: 12 mg/kg/dose IV Q8 hr'),
          DoseLine('>33 kg: 400 mg IV Q8 hr or 600 mg IV Q12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('600 mg IV Q12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Cystic fibrosis (limited data):',
        lines: [
          DoseLine('Child ≥6 yr and adolescent: 15 mg/kg/dose IV Q8 hr (max. dose: 600 '
              'mg/dose) infused over 2 hr in 7 patients (mean age: 20.3 ± 8.0) achieved '
              'the targeted serum concentration time greater than the MIC of 60%.'),
          DoseLine('Adult: Pharmacokinetic simulations in 8 patients revealed dosages of 600 '
              'mg IV Q8 hr infused over 1 hr or 600 mg IV Q12 hr infused over 3 hr would '
              'achieve the targeted serum concentration time greater than the MIC of 60%.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in penicillin allergy and renal impairment. Common side '
          'effects from pediatric trials include diarrhea, rash, vomiting, pyrexia, '
          'and nausea. Leukopenia and liver enzyme elevations have been reported.',
      'Probenecid increases serum ceftaroline levels. Direct Coombs test '
          'seroconversion has been reported with use.',
      'Adjust dose in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 914',
  ),
  // CEFTAZIDIME — PDF p. 106 (printed 915)
  DrugEntryV3(
    name: 'CEFTAZIDIME',
    brandNames: 'Tazicef and generics; previously available as Fortaz',
    drugClass: 'Antibiotic, cephalosporin (third generation)',
    iconRow: '',
    formulations: [
      'Injection:',
      'Tazicef and generics: 1, 6 g',
      'Frozen injection:',
      'Tazicef: 1 g/50 mL 4.4% dextrose, 2 g/50 mL 3.2% dextrose (iso-osmotic '
          'solutions)',
      'Contains 2.3 mEq Na/g drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate (IV/IM):',
        lines: [
          DoseLine(
            '<32 wk gestation:',
            isHeading: true,
          ),
          DoseLine('<7 days old: 100 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine('≥7 days old: 150 mg/kg/24 hr ÷ Q8 hr'),
          DoseLine(
            '≥32 wk gestation:',
            isHeading: true,
          ),
          DoseLine('≤7 days old: 100 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine('>7 days old: 150 mg/kg/24 hr ÷ Q8 hr'),
          DoseLine(
            'Meningitis:',
            isHeading: true,
          ),
          DoseLine('Postnatal age ≤7 days: 50 mg/kg/dose Q8–12 hr'),
          DoseLine('Postnatal age >7 days: 50 mg/kg/dose Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Infant (>1 mo), child, and adolescent (IV/IM):',
        lines: [
          DoseLine('Mild/moderate infection: 100–150 mg/kg/24 hr ÷ Q8 hr; max. dose: 6 g/24 hr'),
          DoseLine('Meningitis: 150–200 mg/kg/24 hr ÷ Q8 hr (max. dose: 6 g/24 hr)'),
          DoseLine('Serious Pseudomonas infections: 200–300 mg/kg/24 hr ÷ Q8 hr (max. dose: '
              '12 g/24 hr)'),
          DoseLine('Cystic fibrosis: 200–400 mg/kg/24 hr ÷ Q6–8 hr (max. dose: 12 g/24 hr)'),
        ],
      ),
      DoseSection(
        heading: 'Adult (IV/IM):',
        lines: [
          DoseLine('1–2 g/dose Q8–12 hr; max. dose: 6 g/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in penicillin-allergic patients or in presence of renal '
          'impairment. Good Pseudomonas coverage and CSF penetration. May cause '
          'rash, liver enzyme elevations, and false-positive urine-reducing '
          'substance (e.g., Clinitest, Benedict’s solution, or Fehling’s solution) '
          'and Coombs test. Enzymatic glucose oxidase urinary glucose tests (e.g., '
          'Clinistix or Tes-Tape) are recommended. Probenecid increases serum '
          'ceftazidime levels. Adjust dose in renal failure (see Chapter 32). '
          'Nonconvulsive status epilepticus, neuromuscular excitability, and '
          'myoclonia may occur with elevated levels of ceftazidime.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 915',
  ),
  // CEFTAZIDIME WITH AVIBACTAM — PDF p. 106–107 (printed 915–916)
  DrugEntryV3(
    name: 'CEFTAZIDIME WITH AVIBACTAM',
    brandNames: 'Avycaz',
    drugClass: 'Antibiotic, cephalosporin (third generation with β-lactamase '
        'inhibitor)',
    iconRow: '',
    formulations: [
      'Injection: 2 g ceftazidime and 0.5 g avibactam',
      'Contains 3.2 mEq Na/g ceftazidime',
    ],
    doseSections: [
      DoseSection(
        heading: 'All doses based on ceftazidime component and are infused over 2–3 hr.',
      ),
      DoseSection(
        heading: 'Complicated UTI (including pyelonephritis) or nosocomial pneumonia '
            '(including VAP):',
        lines: [
          DoseLine('Duration of therapy 7–14 days'),
          DoseLine(
            '31–<37 wk gestation:',
            isHeading: true,
          ),
          DoseLine('≤44 wk postmenstrual age: 20 mg/kg/dose IV Q8 hr'),
          DoseLine('>44 wk postmenstrual age: 30 mg/kg/dose IV Q8 hr'),
          DoseLine(
            '≥37 wk gestation:',
            isHeading: true,
          ),
          DoseLine('≤28 days old: 20 mg/kg/dose IV Q8 hr'),
          DoseLine('>28 days old: 30 mg/kg/dose IV Q8 hr'),
          DoseLine('Infant <3 mo: 30 mg/kg/dose IV Q8 hr'),
          DoseLine('≥3 mo–<6 mo: 40 mg/kg/dose IV Q8 hr'),
          DoseLine('≥6 mo, child, and adolescent: 50 mg/kg/dose (max. 2 g/dose) IV Q8 hr'),
          DoseLine('Adult: 2 g IV Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Complicated intra-abdominal infections:',
        lines: [
          DoseLine('Use same dosage above in combination with metronidazole and treat for '
              '5–14 days.'),
        ],
      ),
    ],
    remarks: [
      'See Ceftazidime for additional remarks. Avibactam is a novel β-lactamase '
          'inhibitor of serine β-lactamases to improve ceftazidime’s susceptibility '
          'to Enterobacteriaceae.',
      'Clinical trial safety profiles in children and adults are similar, '
          'including common side effects of vomiting, diarrhea, rash, and infusion '
          'site reactions. May cause false-positive urine-reducing substance (e.g., '
          'Clinitest, Benedict’s solution, or Fehling’s solution) and Coombs test. '
          'Enzymatic glucose oxidase urinary glucose tests (e.g., Clinistix or '
          'Tes-Tape) are recommended.',
      'Adjust dose in renal failure (see Chapter 32). Australian Therapeutic '
          'Goods Administration reports animal reproductive toxicity without '
          'evidence of teratogenic effects with avibactam. Human studies of '
          'ceftazidime/avibactam are incomplete.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 915–916',
  ),
  // CEFTOLOZANE WITH TAZOBACTAM — PDF p. 107–108 (printed 916–917)
  DrugEntryV3(
    name: 'CEFTOLOZANE WITH TAZOBACTAM',
    brandNames: 'Zerbaxa',
    drugClass: 'Antibiotic, cephalosporin with β-lactamase inhibitor',
    iconRow: '',
    formulations: [
      'Injection: 1 g ceftolozane and 0.5 g tazobactam; contains 600 mg '
          'L-arginine',
      'Contains 8.3 mEq Na/g ceftolozane',
    ],
    doseSections: [
      DoseSection(
        heading: 'All doses based on ceftolozane component and are infused over 1 hr '
            '(3-hr infusion may be used for multidrug-resistant bacteria, severe '
            'infections, or adolescents).',
      ),
      DoseSection(
        heading: 'Neonate (limited data based on a single-dose pharmacokinetic [PK] '
            'evaluation where PK profiles in 13 neonates and infants <3 mo were '
            'comparable to older children receiving a single IV dose; <32 wk '
            'gestation and >7 days old [N = 6] and >32 wk gestation and >7 days '
            'old [N = 7]; see remarks):',
        lines: [
          DoseLine('Complicated UTI and complicated intra-abdominal infection: 20 mg/kg/dose '
              'IV Q8 hr'),
          DoseLine('Severe infections: 40 mg/kg/dose IV Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Infant, child, and adolescent (see remarks):',
        lines: [
          DoseLine(
            'Complicated intra-abdominal infection and complicated UTI (including '
                'pyelonephritis):',
            isHeading: true,
          ),
          DoseLine('20 mg/kg/dose (max. dose: 1 g/dose) IV Q8 hr for 5–14 days for '
              'intra-abdominal infection and 7–14 days for UTI'),
          DoseLine('Severe infections: 40 mg/kg/dose (max. dose: 2 g/dose) IV Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Complicated intra-abdominal infection and UTI (including pyelonephritis): '
              '1 g IV Q8 hr for 4–14 days for intra-abdominal infection and 7 days for '
              'UTI'),
          DoseLine('Hospital-acquired pneumonia and ventilator-associated pneumonia: 2 g IV '
              'Q8 hr for 8–14 days'),
        ],
      ),
    ],
    remarks: [
      'Use is reserved for multidrug-resistant Gram-negative bacterial '
          'infections, including Pseudomonas aeruginosa and E. coli. Tazobactam '
          'irreversibly inhibits certain β-lactamases, penicillinases, and '
          'cephalosporinases to extend ceftolozane’s spectrum of activity. Safety '
          'and efficacy in children with hospital-acquired and ventilator-associated '
          'pneumonia are currently being evaluated.',
      'Use with caution in penicillin-, cephalosporin-, or β-lactam–allergic '
          'patients or in the presence of renal impairment (adjust dose in renal '
          'failure; see Chapter 32). Decreased efficacy has been reported in adults '
          'with baseline eGFR of 30–50 mL/min/1.73 m² in both intra-abdominal and '
          'UTI trials (monitor for changing renal function and adjust dosage '
          'accordingly). The manufacturer does not recommend use in children with an '
          'eGFR <50 mL/min/1.73 m² due to insufficient clinical data.',
      'Common side effects in pediatric trials include thrombocytopenia, '
          'diarrhea, pyrexia, leukopenia, abdominal pain, vomiting, increased AST, '
          'and anemia. Common side effects in adult UTI trials include nausea, '
          'diarrhea, headache, and pyrexia. Increased hepatic transaminases, renal '
          'impairment, and diarrhea were observed in adult pneumonia trials.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 916–917',
  ),
  // CEFTRIAXONE — PDF p. 108–109 (printed 917–918)
  DrugEntryV3(
    name: 'CEFTRIAXONE',
    brandNames: 'Generics; previously available as Rocephin',
    drugClass: 'Antibiotic, cephalosporin (third generation)',
    iconRow: '',
    formulations: [
      'Injection: 0.25, 0.5, 1, 2, 10 g',
      'Frozen injection: 1 g/50 mL 3.8% dextrose, 2 g/50 mL 2.4% dextrose '
          '(iso-osmotic solutions)',
      'Contains 3.6 mEq Na/g drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate:',
        lines: [
          DoseLine('Gonococcal ophthalmia or prophylaxis: 25–50 mg/kg/dose IM/IV × 1; max. '
              'dose: 250 mg/dose'),
        ],
      ),
      DoseSection(
        heading: 'Infant (>1 mo) and child:',
        lines: [
          DoseLine('Mild/moderate infections: 50–75 mg/kg/24 hr IM/IV ÷ Q12–24 hr; max. dose: '
              '2 g/24 hr'),
          DoseLine('Severe infections/meningitis (including penicillin-resistant '
              'pneumococci): 100 mg/kg/24 hr IM/IV ÷ Q12 hr; max. dose: 2 g/dose and 4 '
              'g/24 hr'),
          DoseLine('Penicillin-resistant pneumococci outside of the CSF: 80–100 mg/kg/24 hr '
              'IM/IV ÷ Q12–24 hr (max. dose: 2 g/dose and 4 g/24 hr)'),
          DoseLine('Lyme disease: 50–75 mg/kg/dose (max. dose: 2 g/dose) IV once daily'),
          DoseLine('Acute otitis media: 50 mg/kg IM/IV (max. dose: 1 g) × 1; for persistent '
              'or relapse cases use 50 mg/kg IM/IV (max. dose: 1 g) Q24 hr × 3 doses'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('1–2 g/dose IV/IM Q12–24 hr; max. dose: 2 g/dose and 4 g/24 hr'),
          DoseLine(
            'Uncomplicated gonorrhea:',
            isHeading: true,
          ),
          DoseLine('<150 kg: 500 mg IM × 1'),
          DoseLine('≥150 kg: 1 g IM x 1'),
          DoseLine(
            'PID (see latest CDC Sexually Transmitted Infections Treatment Guidelines):',
            isHeading: true,
          ),
          DoseLine('Mild/moderate acute: 0.5–1 g IM × 1 (following the above uncomplicated '
              'gonorrhea dosage), plus doxycycline 100 mg PO Q12 hr and metronidazole '
              '500 mg PO Q12 hr × 14 days'),
          DoseLine('Severe acute: 1 g IV once daily, plus doxycycline 100 mg IV/PO Q12 hr and '
              'metronidazole 500 mg IV/PO Q12 hr to complete a 14-day course; convert to '
              'oral therapy after clinical improvement with IV therapy.'),
        ],
      ),
      DoseSection(
        heading: 'Bacterial endocarditis prophylaxis for dental and upper respiratory '
            'procedures:',
        lines: [
          DoseLine('Infant and child: 50 mg/kg IV/IM (max. dose: 1 g) 30–60 min before '
              'procedure'),
          DoseLine('Adult: 1 g IV/IM 30–60 min before procedure'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in neonates with hyperbilirubinemia. Do not administer '
          'with IV calcium-containing solutions or products (mixed or administered '
          'simultaneously via different lines) in neonates (<28 days old) because of '
          'risk of precipitation of ceftriaxone-calcium salt. Cases of fatal '
          'reactions with calcium-ceftriaxone precipitates in lungs and kidneys in '
          'preterm and full-term neonates have been reported. Do not administer '
          'simultaneously with IV calcium-containing solutions via a Y-site for any '
          'age group. IV calcium-containing products may be administered '
          'sequentially only when the infusion lines are thoroughly flushed between '
          'infusions with a compatible fluid.',
      'Use with caution in penicillin allergy; patients with gallbladder, '
          'biliary tract, liver, or pancreatic disease; presence of renal '
          'impairment; or in neonates with continuous dosing (risk for '
          'hyperbilirubinemia). In neonates, consider using an alternative '
          'third-generation cephalosporin with similar activity. Unlike other '
          'cephalosporins, ceftriaxone is significantly cleared by the biliary route '
          '(35%–45%).',
      'Rash, injection site pain, diarrhea, and transient increase in liver '
          'enzymes are common. May cause reversible cholelithiasis, sludging in '
          'gallbladder, and jaundice. Reversible neurologic reactions (e.g., '
          'encephalopathy, seizures, myoclonus) have been reported in post-marketing '
          'reports. May interfere with serum and urine creatinine assays (Jaffe '
          'method) and cause false-positive urinary protein and urinary reducing '
          'substances (e.g., Clinitest, Benedict’s solution, or Fehling’s solution). '
          'Enzymatic glucose oxidase urinary glucose tests (e.g., Clinistix or '
          'Tes-Tape) are recommended.',
      'For IM injections, dilute drug with either sterile water for injection or '
          '1% lidocaine to a concentration of 250 or 350 mg/mL (250 mg/mL has lower '
          'incidence of injection site reactions). Assess the potential risk/benefit '
          'for using lidocaine as a diluent; see Lidocaine for additional remarks, '
          'especially risk for methemoglobinemia.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 917–918',
  ),
  // CEFUROXIME (IV, IM)/CEFUROXIME AXETIL (PO) — PDF p. 109–110 (printed 918–919)
  DrugEntryV3(
    name: 'CEFUROXIME (IV, IM)/CEFUROXIME AXETIL (PO)',
    brandNames: 'IV: Generics; previously available as Zinacef\nPO: Generics; '
        'previously available as Ceftin',
    drugClass: 'Antibiotic, cephalosporin (second generation)',
    iconRow: '',
    formulations: [
      'Injection: 0.75, 1.5 g',
      'Injectable dosage forms contain 2.4 mEq Na/g drug.',
      'Tabs: 250, 500 mg',
      'Oral liquid: 10 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'IM/IV:',
        lines: [
          DoseLine(
            'Neonate:',
            isHeading: true,
          ),
          DoseLine('Postnatal age ≤7 days: 100 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine(
            'Postnatal age >7 days:',
            isHeading: true,
          ),
          DoseLine(
            '<1 kg:',
            isHeading: true,
          ),
          DoseLine('8 to ≤14 days old: 100 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine('≥15 days old: 150 mg/kg/24 hr ÷ Q8 hr'),
          DoseLine('≥1 kg: 150 mg/kg/24 hr ÷ Q8 hr'),
          DoseLine(
            'Infant (>3 mo)/child:',
            isHeading: true,
          ),
          DoseLine('Mild/moderate infection: 75–100 mg/kg/24 hr ÷ Q8 hr; max. dose: 1500 '
              'mg/dose'),
          DoseLine('Severe infection: 100–150 mg/kg/24 hr ÷ Q6–8 hr; max. dose: 1500 mg/dose'),
          DoseLine('Adult: 750–1500 mg/dose Q8 hr; max. dose: 9 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'PO (see remarks):',
        lines: [
          DoseLine(
            'Child (3 mo–12 yr):',
            isHeading: true,
          ),
          DoseLine('Pharyngitis and tonsillitis (oral liquid): 20 mg/kg/24 hr ÷ Q12 hr; max. '
              'dose: 500 mg/24 hr'),
          DoseLine('Impetigo (oral liquid): 30 mg/kg/24 hr ÷ Q12 hr; max. dose: 1 g/24 hr'),
          DoseLine(
            'Otitis media and sinusitis:',
            isHeading: true,
          ),
          DoseLine('Oral liquid: 30 mg/kg/24 hr ÷ Q12 hr; max. dose: 1 g/24 hr'),
          DoseLine('Oral tablet: 250 mg BID'),
          DoseLine('UTI (oral liquid): 20-30 mg/kg/24hr ÷ Q12 hr; max. dose: 1 g/24 hr'),
          DoseLine(
            'Lyme disease (alternative to doxycycline or amoxicillin):',
            isHeading: true,
          ),
          DoseLine('Oral liquid: 30 mg/kg/24 hr ÷ Q12 hr × 14–28 days; max. dose: 1 g/24 hr'),
          DoseLine(
            'Child (≥13 yr):',
            isHeading: true,
          ),
          DoseLine(
            'Sinusitis, otitis media, pharyngitis, and tonsillitis:',
            isHeading: true,
          ),
          DoseLine('Tab: 250 mg Q12 hr'),
          DoseLine('Adult: 250–500 mg BID; max. dose: 1 g/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in penicillin-allergic patients or in presence of renal '
          'impairment. May cause GI discomfort, thrombophlebitis at the infusion '
          'site, and false-positive urine-reducing substance (e.g., Clinitest, '
          'Benedict’s solution, or Fehling’s solution) and Coombs test. May '
          'interfere with serum and urine creatinine determinations by the alkaline '
          'picrate method. Enzymatic glucose oxidase urinary glucose tests (e.g., '
          'Clinistix or Tes-Tape) are recommended. Transient increases in liver '
          'enzymes have been reported. Not recommended for meningitis.',
      'Oral suspension dosage form currently not available. Tablets and oral '
          'suspension are NOT bioequivalent and CANNOT be substituted on a mg/mg '
          'basis. Concurrent use of antacids, H₂ blockers, and proton pump '
          'inhibitors may decrease oral absorption. Adjust dose in renal failure '
          '(see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 918–919',
  ),
  // CELECOXIB — PDF p. 110–111 (printed 919–920)
  DrugEntryV3(
    name: 'CELECOXIB',
    brandNames: 'Celebrex, Elyxyb, and generics',
    drugClass: 'Nonsteroidal anti-inflammatory agent (COX-2 selective)',
    iconRow: '',
    formulations: [
      'Capsules (Celebrex and generics): 50, 100, 200, 400 mg',
      'Oral solution (Elyxyb): 120 mg/4.8 mL (4.8 mL); contains alcohol, '
          'cremophor, and levomenthol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Juvenile rheumatoid arthritis (JRA; ≥2 yr and adolescent; see remarks '
            'for dosage adjustment considerations):',
        lines: [
          DoseLine('10–25 kg: 50 mg PO BID'),
          DoseLine('>25 kg: 100 mg PO BID'),
        ],
      ),
      DoseSection(
        heading: 'Adult (see remarks for dosage adjustment considerations):',
        lines: [
          DoseLine('Analgesia: 100–200 mg PO BID; max. dose: 400 mg/24 hr'),
          DoseLine('Acute migraine with or without aura (Elyxyb): 120 mg PO × 1; max. dose: '
              '120 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated for perioperative pain with coronary artery bypass graft '
          '(CABG) surgery. Use with caution in patients with systemic-onset JRA due '
          'to risk for serious adverse reactions (e.g., disseminated intravascular '
          'coagulation). In adults, serious cardiovascular and GI risks reported '
          'include thrombosis, myocardial infarction (MI), stroke, GI bleed, GI '
          'ulceration, and GI perforation. Common adverse effects include headache, '
          'diarrhea, nausea, and hypertension. DRESS, TEN, SJS, acute generalized '
          'exanthematous pustulosis, fixed drug eruption, acute kidney injury, and '
          'hyperkalemia have also been reported.',
      'Celecoxib is a substrate of cytochrome P-450 (CYP) 2C9. Poor metabolizers '
          'of CYP2C9 should start with half the lowest recommended dose and use with '
          'caution, or consider alternative therapy. Angiotensin-converting enzyme '
          '(ACE) inhibitors, loop diuretics, and sodium phosphates may increase risk '
          'for renal dysfunction. Oral corticosteroids, antiplatelet drugs (e.g., '
          'aspirin), anticoagulants, SSRIs, smoking, alcohol use, older age, and '
          'poor health status may increase risk for GI bleeds with prolonged '
          'treatment courses. Celecoxib may reduce the antihypertensive effects of '
          'ACE inhibitors and increase the levels/toxicity of lithium, metoprolol, '
          'and methotrexate.',
      'Not recommended for use in severe renal dysfunction and severe hepatic '
          'impairment (Child-Pugh class C). Reduce dose by 50% and monitor patient '
          'closely in moderate hepatic impairment (Child-Pugh class B).',
      'If patient is unable to swallow capsules whole, contents of the capsule '
          'may be added to applesauce (stable for up to 6 hr refrigerated) and '
          'ingested with water.',
    ],
    pregnancyNote: 'Pregnancy category is “C” for prior to 30 weeks’ gestation and “X” '
        'for 30 weeks and greater. Avoid use at ≥30 weeks’ gestation due to '
        'increased risk for premature closure of the fetal ductus '
        'arteriosus. Limit dose and duration of use at 20–30 weeks’ '
        'gestation for concerns of fetal renal dysfunction.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 919–920',
  ),
  // CEPHALEXIN — PDF p. 111 (printed 920)
  DrugEntryV3(
    name: 'CEPHALEXIN',
    brandNames: 'Generics; previously available as Keflex',
    drugClass: 'Antibiotic, cephalosporin (first generation)',
    iconRow: '',
    formulations: [
      'Caps: 250, 500, 750 mg',
      'Tabs: 250, 500 mg',
      'Oral suspension: 125 mg/5 mL, 250 mg/5 mL (100, 200 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infant and child:',
        lines: [
          DoseLine('Mild/moderate infection: 25–50 mg/kg/24 hr PO ÷ Q6 hr; max. dose: 2 g/24 '
              'hr. Less frequent dosing (Q8–12 hr) may be used for uncomplicated '
              'infections but NOT recommended with Staphylococcus aureus infections.'),
          DoseLine('Severe infection: 75–100 mg/kg/24 hr PO ÷ Q6 hr; max. dose: 4 g/24 hr'),
          DoseLine('Streptococcal pharyngitis: 40 mg/kg/24 hr PO ÷ Q12 hr; max. dose: 500 '
              'mg/dose'),
          DoseLine('Skin and soft tissue infection: 25–100 mg/kg/24 hr PO ÷ Q6–8 hr; max. '
              'dose: 500 mg/dose'),
          DoseLine('UTI: 25 mg/kg/dose PO Q6–8 hr; max. dose: 1 g/dose'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('1–4 g/24 hr PO ÷ Q6 hr; max. dose: 4 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Bacterial endocarditis prophylaxis for dental and upper respiratory '
            'procedures:',
        lines: [
          DoseLine('Infant and child: 50 mg/kg PO (max. dose: 2 g) 30–60 min before procedure'),
          DoseLine('Adult: 2 g PO 30–60 min before procedure'),
        ],
      ),
    ],
    remarks: [
      'Some cross-reactivity with penicillins. Use with caution in renal '
          'insufficiency. May cause GI discomfort, false-positive urine-reducing '
          'substance (e.g., Clinitest, Benedict’s solution, or Fehling’s solution) '
          'and Coombs test, false elevation of serum theophylline levels (HPLC '
          'method), and false urinary protein test. Enzymatic glucose oxidase '
          'urinary glucose tests (e.g., Clinistix or Tes-Tape) are recommended. '
          'Hemolytic anemia and slight increases in AST and ALT have been reported.',
      'Probenecid increases serum cephalexin levels, and concomitant '
          'administration with cholestyramine may reduce cephalexin absorption. May '
          'increase the effects of metformin.',
      'Administer doses on an empty stomach, 2 hr prior to or 1 hr after meals. '
          'Adjust dose in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 920',
  ),
  // CETIRIZINE ± PSEUDOEPHEDRINE — PDF p. 112–113 (printed 921–922)
  DrugEntryV3(
    name: 'CETIRIZINE ± PSEUDOEPHEDRINE',
    brandNames: 'Zyrtec, Zyrtec Allergy, Zyrtec Children’s Allergy, Quzyttir, '
        'Zerviate, and many generics\nIn combination with pseudoephedrine:\n'
        'Zyrtec-D 12 hr and generics',
    drugClass: 'Antihistamine, less sedating',
    iconRow: '',
    formulations: [
      'Oral solution or syrup (OTC): 5 mg/5 mL (120, 473 mL); may contain '
          'parabens, propylene glycol, or sodium benzoate',
      'Tabs (OTC): 5, 10 mg',
      'Chewable tabs (OTC): 5, 10 mg',
      'Capsule (liquid filled; OTC): 10 mg',
      'Dispersible/disintegrating tabs (OTC): 10 mg',
      'Injection (Quzyttir): 10 mg/mL (1 mL); preservative free',
      'Ophthalmic solution (Zerviate): 2.4 mg/1 mL (0.2 mL); 5 or 30 single-use '
          'vials per box; and 5, 7.5-mL multidose bottles; contains benzalkonium '
          'chloride, EDTA, and polyethylene glycol',
      'In combination with pseudoephedrine (PE):',
      'Extended-release tabs (OTC): 5 mg cetirizine + 120 mg PE',
    ],
    doseSections: [
      DoseSection(
        heading: 'Cetirizine (see remarks for dosing in hepatic impairment):',
        lines: [
          DoseLine(
            'Allergic symptoms or anaphylaxis adjunct (PO):',
            isHeading: true,
          ),
          DoseLine('6 mo–<2 yr: 2.5 mg PO once daily; dose may be increased for children '
              '12–23 mo to a max. dose of 2.5 mg PO Q12 hr'),
          DoseLine('2–5 yr: Initial dose: 2.5 mg PO once daily; if needed, may increase dose '
              'to a max. dose of 5 mg/24 hr once daily or divided BID'),
          DoseLine('≥6 yr–adult: 5–10 mg PO once daily'),
          DoseLine('Acute urticaria (Quzyttir; IV):'),
          DoseLine('≥6 mo–≤5 yr: 2.5 mg IV Q24 hr'),
          DoseLine('6–11 yr: 5–10 mg IV Q24 hr'),
          DoseLine('≥12 yr–adult: 10 mg IV Q24 hr'),
          DoseLine(
            'Ophthalmic use (Zerviate):',
            isHeading: true,
          ),
          DoseLine('≥2 yr–adult: Instill 1 drop to affected eye(s) BID (approximately 8 hr '
              'apart).'),
        ],
      ),
      DoseSection(
        heading: 'Cetirizine in combination with pseudoephedrine (PE) (see remarks for '
            'dosing in hepatic impairment):',
        lines: [
          DoseLine(
            '≥12 yr–adult:',
            isHeading: true,
          ),
          DoseLine('Zyrtec-D 12 hr: 1 tablet PO BID'),
        ],
      ),
    ],
    remarks: [
      'Generally not recommended for treating URIs in infants. No proven benefit '
          'for infants and young children with URIs. The FDA does not recommend use '
          'for URIs in children <2 yr because of reports of increased fatalities.',
      'May cause headache, pharyngitis, GI symptoms, dry mouth, and sedation. '
          'Aggressive reactions and convulsions have been reported. Has NOT been '
          'implicated in causing cardiac arrhythmias when used with other drugs that '
          'are metabolized by hepatic microsomal enzymes (e.g., ketoconazole, '
          'erythromycin).',
      'In hepatic impairment, the following doses have been recommended:',
      'Cetirizine:',
      '<6 yr: Use not recommended',
      '6–11 yr: <2.5 mg PO once daily',
      '≥12 yr–adult: 5 mg PO once daily',
      'Cetirizine in combination with pseudoephedrine (Zyrtec-D 12 and generics):',
      '≥12 yr–adult: 1 tablet PO once daily',
      'Doses may be administered without regard to food. For Zyrtec-D 12 Hr, see '
          'Pseudoephedrine for additional remarks. Pregnancy category is “B” for '
          'cetirizine and “C” when combined with pseudoephedrine. Dosage adjustment '
          'is recommended in renal impairment (see Chapter 32).',
      'OPHTHALMIC USE: Common side effects include application site pain, ocular '
          'hyperemia, and reduced visual acuity. Oculogyric crisis has been '
          'reported. Do not touch dropper tip to anything, and remove contact lenses '
          'prior to administration (wait 10 min before reinserting lenses).',
      'INTRAVENOUS USE: Infuse undiluted over 1–2 min. DO NOT administer IM or '
          'SQ.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 921–922',
  ),
  // CHARCOAL, ACTIVATED — PDF p. 113 (printed 922)  [cross-reference]
  DrugEntryV3(
    name: 'CHARCOAL, ACTIVATED',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Chapter 3.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 922',
  ),
  // CHLORAMPHENICOL — PDF p. 113–114 (printed 922–923)
  DrugEntryV3(
    name: 'CHLORAMPHENICOL',
    brandNames: 'Generics',
    drugClass: 'Antibiotic',
    iconRow: '',
    formulations: [
      'Injection: 1 g',
      'Contains 2.25 mEq Na/g drug.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate IV (see remarks for therapeutic drug monitoring):',
        lines: [
          DoseLine('Loading dose: 20 mg/kg'),
          DoseLine(
            'Maintenance dose (first dose should be given 12 hr after loading dose):',
            isHeading: true,
          ),
          DoseLine('≤7 days: 25 mg/kg/24 hr Q24 hr'),
          DoseLine(
            '>7 days:',
            isHeading: true,
          ),
          DoseLine('≤2 kg: 25 mg/kg/24 hr Q24 hr'),
          DoseLine('>2 kg: 50 mg/kg/24 hr ÷ Q12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Infant/child/adult (see remarks for therapeutic drug monitoring):',
        lines: [
          DoseLine('50–75 mg/kg/24 hr IV ÷ Q6 hr'),
          DoseLine('Meningitis: 75–100 mg/kg/24 hr IV ÷ Q6 hr'),
        ],
      ),
      DoseSection(
        heading: 'Max. dose (all ages):',
        lines: [
          DoseLine('4 g/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Dose recommendations are just guidelines for therapy; monitoring of blood '
          'levels is essential. Follow hematologic status for dose-related or '
          'idiosyncratic marrow suppression. “Gray baby” syndrome may be seen with '
          'levels >50 mg/L. Use with caution in G6PD deficiency, renal or hepatic '
          'dysfunction, and neonates.',
      'Concomitant use of phenobarbital and rifampin may lower chloramphenicol '
          'serum levels. Phenytoin may increase chloramphenicol serum levels. '
          'Chloramphenicol may increase the effects/toxicity of phenytoin, '
          'chlorpropamide, cyclosporine, tacrolimus, and oral anticoagulants and '
          'decrease absorption of vitamin B₁₂. Chloramphenicol is an inhibitor of '
          'cytochrome P-450 2C9.',
      'Therapeutic levels: Peak: 15–25 mg/L for meningitis and 10–20 mg/L for '
          'other infections. Trough: 5–15 mg/L for meningitis and 5–10 mg/L for '
          'other infections. Recommended serum sampling time: trough within 30 min '
          'prior to next dose; peak 30 min after the end of infusion. Time to '
          'achieve steady state: 2–3 days for newborns; 12–24 hr for children and '
          'adults.',
      'If a nursing mother is receiving chloramphenicol, monitor the '
          'breast-feeding infant for GI disturbances, adequacy of nursing, and CBC '
          'with differential. Some recommend the use of an alternative medication '
          'for the nursing mother or discontinuing breastfeeding.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 922–923',
  ),
  // CHLOROQUINE PHOSPHATE — PDF p. 114 (printed 923)
  DrugEntryV3(
    name: 'CHLOROQUINE PHOSPHATE',
    brandNames: 'Generics; previously available as Aralen',
    drugClass: 'Amebicide, antimalarial',
    iconRow: '',
    formulations: [
      'Tabs: 250, 500 mg as phosphate (150-, 300-mg base, respectively)',
      'Oral suspension: 16.67 mg/mL as phosphate (10 mg/mL base), 15 mg/mL as '
          'phosphate (9 mg/mL base)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Doses expressed in mg of chloroquine base:',
        lines: [
          DoseLine(
            'Malaria prophylaxis (start 1–2 wk prior to exposure and continue for 4 wk '
                'after leaving endemic area):',
            isHeading: true,
          ),
          DoseLine('Infant and child: 5 mg/kg/dose PO every week on the same day of the week; '
              'max. dose: 300 mg/dose'),
          DoseLine('Adult: 300 mg/dose PO every week on the same day of the week'),
          DoseLine(
            'Malaria treatment (uncomplicated; chloroquine-sensitive strains):',
            isHeading: true,
          ),
          DoseLine('For treatment for malaria, consult with ID specialist or see the latest '
              'edition of the AAP Red Book.'),
          DoseLine('Infant and child: 10 mg/kg/dose (max. dose: 600 mg/dose) PO × 1; followed '
              'by 5 mg/kg/dose (max. dose: 300 mg/dose) 6, 24, and 48 hr after the '
              'initial dose'),
          DoseLine('Adult: 600 mg/dose PO × 1; followed by 300 mg/dose 6, 24, and 48 hr after '
              'the initial dose'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in the presence of retinal or visual field changes and '
          'known hypersensitivity to 4-aminoquinoline compounds. Use with caution in '
          'liver disease, preexisting auditory damage or seizures, G6PD deficiency, '
          'psoriasis, porphyria, or concomitant hepatotoxic drugs. May cause nausea, '
          'vomiting, electrocardiogram (ECG) abnormalities, prolonged Q-T interval, '
          'blurred vision, retinal and corneal changes (reversible corneal '
          'opacities), headaches, confusion, skeletal muscle weakness, increased '
          'liver enzymes, and hair depigmentation. SJS, TEN, anaphylactic reactions, '
          'and maculopathy and macular degeneration have been reported. '
          'False-positive test for urine amphetamine screen may occur.',
      'Antacids, ampicillin, and kaolin may decrease the absorption of '
          'chloroquine (allow 4-hr interval between these drugs and chloroquine). '
          'Cimetidine may increase effects/toxicity of chloroquine. May increase '
          'serum cyclosporine levels. Coadministration with mefloquine may increase '
          'risk of convulsions. May reduce the antibody response to intradermal '
          'human diploid-cell rabies vaccine.',
      'Monitor CBCs periodically with therapies of prolonged duration. Adjust '
          'dose in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 923',
  ),
  // CHLOROTHIAZIDE — PDF p. 114–115 (printed 923–924)
  DrugEntryV3(
    name: 'CHLOROTHIAZIDE',
    brandNames: 'Diuril and generics',
    drugClass: 'Thiazide diuretic',
    iconRow: '',
    formulations: [
      'Oral suspension: 250 mg/5 mL (237 mL); contains 0.5% alcohol, 0.12% '
          'methylparaben, 0.02% propylparaben, and 0.1% benzoic acid',
      'Injection: 500 mg; contains 5 mEq Na/1 g drug',
    ],
    doseSections: [
      DoseSection(
        heading: '<6 mo:',
        lines: [
          DoseLine('PO: 20–40 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine('IV: Start at 5–10 mg/kg/24 hr ÷ Q12 hr; may increase to 20–40 mg/kg/24 hr '
              '÷ Q12 hr if needed'),
        ],
      ),
      DoseSection(
        heading: '≥6 mo:',
        lines: [
          DoseLine('PO: 10–40 mg/kg/24 hr ÷ Q12 hr; maximum PO dose by age:'),
          DoseLine('6 mo–<2 yr: 375 mg/24 hr'),
          DoseLine('2–12 yr: 1 g/24 hr'),
          DoseLine('>12 yr: 2 g/24 hr'),
          DoseLine('IV: Start at 5–10 mg/kg/24 hr ÷ Q12–24 hr; may increase to 20 mg/kg/24 hr '
              '÷ Q12 hr if needed'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('500–2000 mg/24 hr IV ÷ Q12–24 hr; alternative IV dosing: some may respond '
              'to intermittent dosing on alternate days or on 3–5 days each week'),
        ],
      ),
      DoseSection(
        heading: 'Adjunct therapy for neonatal hyperinsulinemia/hypoglycemia (limited '
            'data):',
        lines: [
          DoseLine('7–10 mg/kg/24 hr PO ÷ BID with diazoxide PO'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in anuria. Use with caution in liver and severe renal '
          'disease and sulfonamide hypersensitivity. May increase serum calcium, '
          'bilirubin, glucose, and uric acid. May cause alkalosis, pancreatitis, '
          'dizziness, hypokalemia, and hypomagnesemia.',
      'Avoid IM or subcutaneous administration.',
    ],
    pregnancyNote: 'Pregnancy category changes to “D” if used in pregnancy-induced '
        'hypertension.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 923–924',
  ),
  // CHLORPHENIRAMINE MALEATE — PDF p. 115 (printed 924)
  DrugEntryV3(
    name: 'CHLORPHENIRAMINE MALEATE',
    brandNames: 'Generics; previously available as Chlor-Trimeton',
    drugClass: 'Antihistamine',
    iconRow: '',
    formulations: [
      'Tabs [OTC]: 4 mg',
      'Sustained-release tabs [OTC]: 12 mg',
      'Syrup [OTC]: 2 mg/5 mL (473 mL); may contain 5% alcohol and/or parabens',
    ],
    doseSections: [
      DoseSection(
        heading: 'Doses may be administered as scheduled or PRN (see remarks).',
      ),
      DoseSection(
        heading: 'Child <12 yr:',
        lines: [
          DoseLine('0.35 mg/kg/24 hr PO ÷ Q4–6 hr or dose based on age as follows:'),
          DoseLine('2–5 yr: 1 mg/dose PO Q4–6 hr; max. dose: 6 mg/24 hr'),
          DoseLine('6–11 yr: 2 mg/dose PO Q4–6 hr; max. dose: 12 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: '≥12 yr–adult:',
        lines: [
          DoseLine('4 mg/dose Q4–6 hr PO; max. dose: 24 mg/24 hr'),
          DoseLine('Sustained release: 12 mg PO Q12 hr'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in asthma. May cause sedation, dry mouth, blurred '
          'vision, urinary retention, polyuria, and disturbed coordination. Young '
          'children may be paradoxically excited.',
      'Found in many combinations. Over-the-counter (OTC) cough and cold '
          'products are not recommended for children <6 yr old due to reports of '
          'serious adverse effects (cardiac and respiratory distress, convulsions, '
          'and hallucinations) and fatalities (from unintentional overdosages, '
          'including combined use of other OTC products containing the same active '
          'ingredients).',
      'Administer doses with food. Sustained-release forms are NOT recommended '
          'in children <6 yr and should NOT be crushed, chewed, or dissolved.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 924',
  ),
  // CHLORPROMAZINE — PDF p. 116 (printed 925)
  DrugEntryV3(
    name: 'CHLORPROMAZINE',
    brandNames: 'Generics; previously available as Thorazine',
    drugClass: 'Antiemetic, antipsychotic, phenothiazine derivative',
    iconRow: '',
    formulations: [
      'Tabs: 10, 25, 50, 100, 200 mg',
      'Oral liquid concentrate: 30 mg/mL (120 mL), 100 mg/mL (240 mL)',
      'Injection: 25 mg/mL (1, 2 mL); may contain sodium metabisulfite and '
          'sodium sulfite',
    ],
    doseSections: [
      DoseSection(
        heading: 'Psychosis (gradually taper doses when discontinuing therapy to '
            'prevent withdrawal symptoms and minimize risk of relapse):',
        lines: [
          DoseLine(
            'Child >6 mo:',
            isHeading: true,
          ),
          DoseLine('PO: 2.5–6 mg/kg/24 hr ÷ Q4–6 hr; max. PO dose: 500 mg/24 hr'),
          DoseLine('IM/IV: 2.5–4 mg/kg/24 hr ÷ Q6–8 hr'),
          DoseLine(
            'Max. IM/IV dose:',
            isHeading: true,
          ),
          DoseLine('<5 yr or <22.7 kg: 40 mg/24 hr'),
          DoseLine('≥5 yr–adolescent or ≥22.7 kg: 75 mg/24 hr'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('PO: 10–25 mg/dose Q4–6 hr; max. dose: 1–2 g/24 hr'),
          DoseLine('IM/IV: Initial: 25 mg; repeat with 25–50 mg/dose; if needed, Q1–4 hr up '
              'to a max. dose of 400 mg/dose Q4–6 hr'),
        ],
      ),
      DoseSection(
        heading: 'Antiemetic:',
        lines: [
          DoseLine(
            'Child (≥6 mo):',
            isHeading: true,
          ),
          DoseLine('IV/IM/PO: 0.5–1 mg/kg/dose Q6–8 hr PRN'),
          DoseLine(
            'Max. IM/IV/PO dose:',
            isHeading: true,
          ),
          DoseLine('<5 yr or <22.7 kg: 40 mg/24 hr'),
          DoseLine('≥5 yr–adolescent or 22.7–45.5 kg: 75 mg/24 hr'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('IV/IM: 10–25 mg/dose Q4–6 hr PRN; max. dose: 200 mg/24 hr'),
          DoseLine('PO: 10–25 mg/dose Q4–8 hr PRN; max. dose: 150 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Adverse effects include drowsiness, jaundice, lowered seizure threshold, '
          'extrapyramidal/anticholinergic symptoms, hypotension (more with IV), '
          'arrhythmias, agranulocytosis, and neuroleptic malignant syndrome. May '
          'potentiate effect of narcotics, sedatives, and other drugs. Monitor BP '
          'closely. ECG changes include prolonged P–R interval, flattened T waves, '
          'and ST depression; do not use in combination with fluoxetine, '
          'haloperidol, citalopram, and other drugs that can prolong the Q–T '
          'interval. Do not administer oral liquid dosage form simultaneously with '
          'carbamazepine oral suspension; an orange, rubbery precipitate may form.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 925',
  ),
  // CHOLECALCIFEROL — PDF p. 116–118 (printed 925–927)
  DrugEntryV3(
    name: 'CHOLECALCIFEROL',
    brandNames: 'D–3, D3–5, D3–50, Decara, D Drops, Enfamil D-Vi-Sol, Replesta, and '
        'many others including generics',
    drugClass: 'Vitamin D₃',
    iconRow: '',
    formulations: [
      'Tab (OTC): 400, 800, 1000, 2000, 3000, 5000, 50,000 IU',
      'Caps (OTC): 1000, 2000, 5000, 10,000, 50,000 IU',
      'D3–5: 5000 IU',
      'Decara: 5,000, 25,000 IU',
      'D3–50: 50,000 IU',
      'Chewable tab (OTC): 400, 1000, 2000 IU',
      'Chewable wafer (Replesta; OTC): 14,000 (8), 50,000 IU (4)',
      'Oral drops (D Drops and others) [OTC]: 400 IU/drop (2.5 mL), 600 IU/drop '
          '(2.8 mL), 1000 IU/drop (5 mL), 2000 IU/drop (5 mL), 5000 IU/drop with 120 '
          'mCg vitamin K₂/drop (2.5 mL)',
      'Oral liquid (OTC): 400, 5000 IU/mL',
      'Emfamil D-Vi-Sol (OTC): 400 IU/mL (50 mL)',
      'Conversion: 1000 IU is equivalent to 25 mCg of cholecalciferol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Dietary supplementation (see Chapter 21 for additional information):',
        lines: [
          DoseLine('Preterm: 200–400 IU/24 hr PO'),
          DoseLine('Infant (<1 yr): 400 IU/24 hr PO'),
          DoseLine('Neonate and infant (breastfed and/or receiving <32 oz of formula): 400 '
              'IU/24 hr PO'),
          DoseLine('Child (≥1 yr) and adolescent: 400–600 IU/24 hr PO'),
          DoseLine('Cystic fibrosis: See specific cystic fibrosis specialty multivitamin '
              'product (e.g., DEKA Plus, MVW Complete, ADEK) for recommended dosages.'),
        ],
      ),
      DoseSection(
        heading: 'Vitamin D insufficiency and deficiency (PO):',
      ),
      DoseSection(
        heading: 'Patients Without Cystic Fibrosis or Malabsorptive Conditions',
        table: DoseTable(
          headers: ['Vitamin D (25-OH) Level', '', ''],
          rows: [
            DoseTableRow(['Age', '12–<20 ng/mL (Insufficiency)', '<12 ng/mL (Deficiency)']),
            DoseTableRow(['<1 yr', '1000 IU once daily', '2000–4000 IU once daily']),
            DoseTableRow(['≥1 yr', '2000 IU once daily', '5000–6000 IU once daily OR\n50,000 IU once weekly']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Patients With Non–Cystic Fibrosis Malabsorptive Conditions',
        table: DoseTable(
          headers: ['Vitamin D (25-OH) Level', '', ''],
          rows: [
            DoseTableRow(['Age', '12–<20 ng/mL (Insufficiency)', '<12 ng/mL (Deficiency)']),
            DoseTableRow(['<10 yr', '2000 IU once daily', '5000 IU once daily']),
            DoseTableRow(['≥10 yr', '4000–6000 IU once daily', '10,000 IU once daily OR\n50,000 IU once weekly']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Patients With Cystic Fibrosis',
        table: DoseTable(
          headers: ['Vitamin D (25-OH) Level', '', ''],
          rows: [
            DoseTableRow(['Age', '20–<30 ng/mL (Insufficiency)', '<20 ng/mL (Deficiency)']),
            DoseTableRow(['<1 yr', '2000 IU once daily', '5000 IU once daily']),
            DoseTableRow(['1–<10 yr', '6000 IU once daily', '50,000 IU once daily × 1 mo followed by either 10,000 IU once daily OR '
                '50,000 IU once weekly']),
            DoseTableRow(['≥10 yr', '10,000 IU once daily', '50,000 IU once daily × 1 mo followed by either 10,000 IU once daily OR '
                '50,000 IU once weekly']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Rickets (with calcium supplementation; decrease to maintenance dosage '
            'when radiologically proven healing is achieved):',
        lines: [
          DoseLine('Infant: 2000 IU PO once daily × ≥3 mo, followed by 400 IU once daily '
              'maintenance'),
          DoseLine('Child: 3000–6000 IU PO once daily × ≥3 mo, followed by 600 IU once daily '
              'maintenance'),
          DoseLine('Adolescent: 6000 IU PO once daily × ≥3 mo, followed by 600 IU once daily '
              'maintenance'),
        ],
      ),
      DoseSection(
        heading: 'Renal failure (CKD stages 2–5) and 25-OH vitamin D levels ≤30 ng/mL '
            '(monitor serum 25-OH vitamin D and corrected calcium/phosphorus 1 mo '
            'after initiation and Q3 mo thereafter):',
        lines: [
          DoseLine(
            'Child (PO):',
            isHeading: true,
          ),
          DoseLine('25-OH vitamin D <5 ng/mL: 8000 IU/24 hr × 4 wk, followed by 4000 IU/24 hr '
              '× 2 mo; OR 50,000 IU weekly × 4 wk, followed by 50,000 IU twice monthly × '
              '3 mo'),
          DoseLine('25-OH vitamin D 5–15 ng/mL: 4000 IU/24 hr × 12 wk; OR 50,000 IU every '
              'other week × 12 wk'),
          DoseLine('25-OH vitamin D 16–30 ng/mL: 2000 IU/24 hr × 3 mo; OR 50,000 IU monthly × '
              '3 mo'),
          DoseLine('Maintenance dose (after repletion): 200–1000 IU once daily'),
        ],
      ),
    ],
    remarks: [
      'Biologic potency and oral absorption may be greater than ergocalciferol '
          '(vitamin D₂). Requires activation by the liver (25-hydroxylation) and '
          'kidney (1-hydroxylation) to the active form, calcitriol. Recommended time '
          'period to recheck serum 25-OH vitamin D is 3 mo after initiation or '
          'change in dosage.',
      'Monitor serum Ca²⁺, PO₄, 25-OH vitamin D (goal level for infant and '
          'child: ≥20 ng/mL) and alkaline phosphate. Serum Ca²⁺, PO₄ product should '
          'be <70 mg/dL to avoid ectopic calcification. Serum 25-OH vitamin D level '
          'of ≥35 ng/mL has been used in cystic fibrosis patients to decrease the '
          'risk of hyperparathyroidism and bone loss.',
      'Serum 25-OH vitamin D levels ≥100 ng/mL are considered toxic. Toxic '
          'effects in infants may result in nausea, vomiting, constipation, '
          'abdominal pain, loss of appetite, polydipsia, polyuria, muscle weakness, '
          'muscle/joint pain, confusion, and fatigue; renal damage may also occur.',
    ],
    pregnancyNote: 'Pregnancy category changes to “D” if used in doses above the U.S. '
        'RDA.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 925–927',
  ),
  // CHOLESTYRAMINE — PDF p. 118–119 (printed 927–928)
  DrugEntryV3(
    name: 'CHOLESTYRAMINE',
    brandNames: 'Questran, Questran Light, Cholestyramine Light, Prevalite, and '
        'generics',
    drugClass: 'Antilipemic, binding resin',
    iconRow: '',
    formulations: [
      'Powder for oral suspension:',
      'Questran and generics: 4 g anhydrous resin per 9 g powder (9 g―box of 60 '
          'packets, 378-g can)',
      'Questran Light: 4 g anhydrous resin per 5 g powder (5 g―box of 60 '
          'packets, 210-g can)',
      'Cholestyramine Light: 4 g anhydrous resin per 5.7 g powder with aspartame '
          '(5.7 g―box of 60 packets, 239-g can)',
      'Prevalite: 4 g anhydrous resin per 5.5 g powder with aspartame (5.5 g―box '
          'of 42 or 60 packets, 231-g can)',
    ],
    doseSections: [
      DoseSection(
        heading: 'All doses based in terms of anhydrous resin. Titrate dose based on '
            'response and tolerance.',
      ),
      DoseSection(
        heading: 'Hypercholesterolemia:',
        lines: [
          DoseLine('Child and adolescent: 240 mg/kg/24 hr PO ÷ TID; doses normally do not '
              'exceed 8 g/24 hr (higher doses do not provide additional benefit). Give '
              'PO as slurry in water, juice, or milk before meals for better efficacy.'),
          DoseLine('Adult: 4 g PO once daily–BID; max. dose: 24 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Pruritus associated with cholestasis:',
        lines: [
          DoseLine('Child: 240 mg/kg/24 hr PO ÷ BID–TID; higher doses may cause steatorrhea '
              '(dose reduction required). Suggested max. doses:'),
          DoseLine('≤10 yr: 4–10 g/24 hr'),
          DoseLine('>10 yr and adolescent: 8–16 g/24 hr'),
          DoseLine('Adult: 4 g PO once daily–BID; may gradually increase dose to 16 g/24 hr ÷ '
              'BID; max. dose: 24 g/24 hr'),
        ],
      ),
    ],
    remarks: [
      'In addition to the use for managing hypercholesterolemia, drug may be '
          'used for itching associated with elevated bile acids, and diarrheal '
          'disorders associated with excess fecal bile acids or Clostridium '
          'difficile (pseudomembranous colitis). May also be applied topically for '
          'diaper dermatitis by preparing a 5% or 10% topical product with '
          'hydrophilic topical ointment (Aquaphor); other compounded topical '
          'formulations exist (e.g., Butt Paste: cholestyramine, sucralfate, zinc '
          'oxide, and Eucerin).',
      'May cause constipation, abdominal distention, vomiting, vitamin '
          'deficiencies (A, D, E, K), and rash. Hyperchloremic acidosis may occur '
          'with prolonged use.',
      'Give other oral medications 4–6 hr after cholestyramine or 1 hr before '
          'dose to avoid decreased absorption. High doses or long-term systemic '
          'therapy may decrease the absorption of folic acid, fat-soluble vitamins, '
          'and iron.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 927–928',
  ),
  // CICLESONIDE — PDF p. 119–120 (printed 928–929)
  DrugEntryV3(
    name: 'CICLESONIDE',
    brandNames: 'Alvesco, Omnaris',
    drugClass: 'Corticosteroid',
    iconRow: '',
    formulations: [
      'Aerosol inhaler:',
      'Alvesco: 80 mCg/actuation (6.1 g = 60 doses), 160 mCg/actuation (6.1 g = '
          '60 doses)',
      'Nasal spray:',
      'Omnaris (nasal suspension): 50 mCg/actuation (12.5 g = 120 doses); '
          'contains sodium EDTA',
    ],
    doseSections: [
      DoseSection(
        heading: 'Intranasal (allergic rhinitis):',
        lines: [
          DoseLine(
            'Omnaris:',
            isHeading: true,
          ),
          DoseLine('2–11 yr (limited data): 1 or 2 sprays (50 or 100 mCg) per nostril once '
              'daily. Max. dose: 200 mCg/24 hr'),
          DoseLine('FDA-labeled seasonal allergic rhinitis for children ≥6 yr: 2 sprays (100 '
              'mCg) per nostril once daily; max. dose: 200 mCg/24 hr'),
          DoseLine('≥12 yr and adult: 2 sprays (100 mCg) per nostril once daily. Max. dose: '
              '200 mCg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Oral inhalation (asthma; Alvesco):',
        lines: [
          DoseLine('All daily doses divided BID.'),
        ],
      ),
      DoseSection(
        heading: 'Dosage Recommended by Global Initiative for Asthma (GINA) Guidelines',
        table: DoseTable(
          headers: ['Age', 'Low Dose (mCg/24 hr)', 'Medium Dose (mCg/24 hr)', 'High Dose (mCg/24 hr)'],
          rows: [
            DoseTableRow(['6–11 yr', '80', '>80–160', '>160 up to 640 mCg/24 hr']),
            DoseTableRow(['≥12 yr and adult', '80–160', '>160–320', '>320 up to 640 mCg/24 hr']),
          ],
        ),
      ),
      DoseSection(
        heading: '2–11 yr (limited data from randomized controlled studies in 4–11 and '
            '2–6 yr of age, where efficacy could not be established):',
        lines: [
          DoseLine('40, 80, or 160 mCg/dose BID'),
        ],
      ),
      DoseSection(
        heading: '≥12 yr and adult (FDA labeling):',
        lines: [
          DoseLine('Prior use with bronchodilator only: 80 mCg/dose BID; max. dose: 320 '
              'mCg/24 hr'),
          DoseLine('Prior use with inhaled corticosteroid: 80 mCg/dose BID; max. dose: 640 '
              'mCg/24 hr'),
          DoseLine('Prior use with oral corticosteroid: 320 mCg/dose BID; max. dose: 640 '
              'mCg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Ciclesonide is a prodrug hydrolyzed to an active metabolite, '
          'des-ciclesonide, via esterases in nasal mucosa and lungs; further '
          'metabolism via hepatic cytochrome P-450 (CYP) 3A4 and 2D6. Concurrent use '
          'with ketoconazole and other CYP3A4 inhibitors may increase systemic '
          'des-ciclesonide levels. Use with caution and monitor in hepatic '
          'impairment.',
      'Oral inhalation (asthma): Rinse mouth after each use. May cause headache, '
          'arthralgia, nasal congestion, nasopharyngitis, and URIs. Routinely '
          'monitor growth of pediatric patients. Maximum therapeutic benefit may not '
          'be achieved until 4 wk after initiation; consider dose increase if '
          'response is inadequate 4 wk after initial dosage.',
      'Intranasal (allergic rhinitis): Clear nasal passages prior to use. May '
          'cause otalgia, epistaxis, nasopharyngitis, and headache. Nasal septal '
          'perforation has been reported. Patients should be free of nasal disease, '
          'except for allergic rhinitis, before starting therapy. Monitor linear '
          'growth of pediatric patients routinely. Onset of action: 24–48 hr; '
          'further improvement observed over 1–2 wk in seasonal allergic rhinitis or '
          '5 wk in perennial allergic rhinitis. Discontinue use if nasal erosion, '
          'ulceration, or perforation occurs.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 928–929',
  ),
  // CIDOFOVIR — PDF p. 120 (printed 929)
  DrugEntryV3(
    name: 'CIDOFOVIR',
    brandNames: 'Generics; previously available as Vistide',
    drugClass: 'Antiviral',
    iconRow: '',
    formulations: [
      'Injection: 75 mg/mL (5 mL); preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Safety and efficacy have not been established in children.',
      ),
      DoseSection(
        heading: 'CMV retinitis:',
        lines: [
          DoseLine(
            'Adolescent and adult:',
            isHeading: true,
          ),
          DoseLine('Induction: 5 mg/kg IV once weekly × 2 with probenecid and hydration'),
          DoseLine('Maintenance: 5 mg/kg IV Q2 wk with probenecid and hydration'),
        ],
      ),
      DoseSection(
        heading: 'Adenovirus infection in immunocompromised oncology patients (limited '
            'data, and other regimens exist; see remarks):',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('Induction: 5 mg/kg/dose IV once weekly until PCR negative. Administer '
              'oral probenecid 1–1.25 g/m²/dose (rounded to the nearest 250-mg interval) '
              '3 hr before and 1 hr and 8 hr after each dose of cidofovir. Also give NS '
              'via IV at 3 times maintenance fluid concentration 1 hr before and 1 hr '
              'after cidofovir, followed by 2 times maintenance fluid concentration for '
              'an additional 2 hr. For patients with renal dysfunction (see remarks), '
              'give 1 mg/kg/dose IV 3 times weekly until PCR negative.'),
          DoseLine('Maintenance: 5 mg/kg/dose IV Q2 wk with probenecid and hydration'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in hypersensitivity to probenecid or sulfa-containing '
          'drugs; sCr >1.5 mg/dL, CrCl ≤55 mL/min, urine protein ≥100 mg/dL (2+ '
          'proteinuria); direct intraocular injection of cidofovir; and concomitant '
          'nephrotoxic drugs. Renal impairment is the major dose-limiting toxicity. '
          'IV NS prehydration and oral probenecid must be used (unless not '
          'indicated) to reduce risk of nephrotoxicity. May also cause nausea, '
          'vomiting, headache, rash, metabolic acidosis, uveitis, decreased '
          'intraocular pressure, and neutropenia.',
      'Reported criteria for defining renal dysfunction in children includen an '
          'sCr >1.5 mg/dL, GFR <90 mL/min/1.73 m², and >2+ proteinuria. For adults, '
          'reduce dose to 3 mg/kg if sCr increases 0.3–0.4 mg/dL from baseline. '
          'Discontinue therapy if sCr increases ≥0.5 mg/dL from baseline or '
          'development of ≥3+ proteinuria.',
      'Administer doses via IV infusion over 1 hr at a concentration ≤8 mg/mL.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 929',
  ),
  // CIPROFLOXACIN — PDF p. 121–122 (printed 930–931)
  DrugEntryV3(
    name: 'CIPROFLOXACIN',
    brandNames: 'Cipro, Ciloxan ophthalmic, Cetraxal, and generics\nIn combination '
        'with corticosteroid: Cipro HC Otic, Otovel Otic, and generics; '
        'previously available as Ciprodex,',
    drugClass: 'Antibiotic, quinolone',
    iconRow: '',
    formulations: [
      'Tabs: 250, 500, 750 mg',
      'Oral suspension:',
      'Cipro: 250 mg/5 mL (100 mL), 500 mg/5 mL (100 mL)',
      'Premixed injection: 200 mg/100 mL 5% dextrose, 400 mg/200 mL 5% dextrose '
          '(iso-osmotic solutions)',
      'Ophthalmic solution: 0.3% (2.5, 5, 10 mL); may contain benzalkonium '
          'chloride',
      'Ophthalmic ointment:',
      'Ciloxan: 0.3% (3.5 g)',
      'Otic solution:',
      'Cetraxal and generics: 0.5 mg/0.25 mL or 0.2% (14s)',
      'Otic suspension:',
      'With dexamethasone (generics; previously available as Ciprodex): 3 mg/mL '
          '(0.3%) ciprofloxacin + 1 mg/mL (0.1%) dexamethasone (7.5 mL); contains '
          'benzalkonium chloride',
      'With hydrocortisone (Cipro HC Otic): 2 mg/mL (0.2%) ciprofloxacin + 10 '
          'mg/mL (1%) hydrocortisone (10 mL); contains benzyl alcohol',
      'With fluocinolone (Otovel Otic and generics): 3 mg/mL (0.3%) '
          'ciprofloxacin + 0.25 mg/mL (0.025%) fluocinolone acetonide (0.25 mL; '
          'carton of 14s)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate (limited data based on pharmacokinetic data):',
        lines: [
          DoseLine('<34 wk postmenstrual age: 7.5–10 mg/kg/dose IV Q12 hr'),
          DoseLine('≥34 wk postmenstrual age: 10–15 mg/kg/dose IV Q12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Child and adolescent:',
        lines: [
          DoseLine(
            'PO:',
            isHeading: true,
          ),
          DoseLine('Mild/moderate infection: 20 mg/kg/24 hr ÷ Q12 hr; max. dose: 1 g/24 hr'),
          DoseLine('Severe infection: 30–40 mg/kg/24 hr ÷ Q12 hr; max. dose: 1.5 g/24 hr'),
          DoseLine(
            'IV:',
            isHeading: true,
          ),
          DoseLine('Severe infection: 10 mg/kg/dose Q8–12 hr; max. dose: 400 mg/dose'),
          DoseLine(
            'Complicated UTI or pyelonephritis (for 10–21 days):',
            isHeading: true,
          ),
          DoseLine('PO: 20–40 mg/kg/24 hr ÷ Q12 hr; max. dose: 1.5 g/24 hr'),
          DoseLine('IV: 18–30 mg/kg/24 hr ÷ Q8 hr; max. dose: 1.2 g/24 hr'),
          DoseLine(
            'Cystic fibrosis:',
            isHeading: true,
          ),
          DoseLine('PO: 40 mg/kg/24 hr ÷ Q12 hr; max. dose: 2 g/24 hr'),
          DoseLine('IV: 30 mg/kg/24 hr ÷ Q8 hr; max. dose: 1.2 g/24 hr'),
          DoseLine(
            'Anthrax (see remarks):',
            isHeading: true,
          ),
          DoseLine('Inhalational/systemic/cutaneous: Start with 30 mg/kg/24 hr IV ÷ Q8 hr '
              '(max. dose: 1200 mg/24 hr); with clinical improvement, convert to oral '
              'dosing at 30 mg/kg/24 hr PO ÷ Q12 hr (max. dose: 1 g/24 hr). Duration of '
              'therapy: 60 days (IV and PO combined)'),
          DoseLine('Postexposure prophylaxis: 30 mg/kg/24 hr PO ÷ Q12 hr × 60 days; max. '
              'dose: 1 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine(
            'PO:',
            isHeading: true,
          ),
          DoseLine('Immediate release: 250–750 mg/dose Q12 hr'),
          DoseLine(
            'Extended-release tabs (Cipro XR and generics):',
            isHeading: true,
          ),
          DoseLine('Uncomplicated UTI/cystitis: 500 mg/dose Q24 hr'),
          DoseLine('Complicated UTI/uncomplicated pyelonephritis: 1000 mg/dose Q24 hr'),
          DoseLine('IV: 400 mg/dose Q12 hr; 400 mg/dose Q8 hr for more severe/complicated '
              'infections'),
          DoseLine(
            'Anthrax (see remarks):',
            isHeading: true,
          ),
          DoseLine('Inhalational/systemic/cutaneous: Start with 400 mg/dose IV Q12 hr and '
              'convert to oral dosing with clinical improvement at 500 mg/dose PO Q12 '
              'hr. Duration of therapy: 60 days (IV and PO combined)'),
          DoseLine('Postexposure prophylaxis: 500 mg/dose PO Q12 hr × 60 days'),
        ],
      ),
      DoseSection(
        heading: 'Ophthalmic solution:',
        lines: [
          DoseLine('Bacterial conjunctivitis (≥1 yr and adult): 1–2 drops Q2 hr while awake × '
              '2 days, then 1–2 drops Q4 hr while awake × 5 days. Clinical efficacy for '
              'bacterial conjunctivitis has been demonstrated for neonates <31 days old '
              'in a randomized, double-blinded, multicenter, parallel-group clinical '
              'trial.'),
        ],
      ),
      DoseSection(
        heading: 'Ophthalmic ointment:',
        lines: [
          DoseLine('Bacterial conjunctivitis (≥2 yr and adult:) Apply 0.5-inch ribbon TID × 2 '
              'days, then BID × 5 days.'),
        ],
      ),
      DoseSection(
        heading: 'Otic:',
        lines: [
          DoseLine(
            'Cetraxal and generics:',
            isHeading: true,
          ),
          DoseLine('Acute otitis externa (≥1 yr and adult): 0.25 mL to affected ear(s) BID × '
              '7 days'),
          DoseLine(
            'Ciprofloxacin and dexamethasone (generics; previously available as '
                'Ciprodex):',
            isHeading: true,
          ),
          DoseLine('Acute otitis media with tympanostomy tubes or acute otitis externa (≥6 mo '
              'and adult): 4 drops to affected ear(s) BID × 7 days'),
          DoseLine(
            'Cipro HC Otic:',
            isHeading: true,
          ),
          DoseLine('Otitis externa (>1 yr and adult): 3 drops to affected ear(s) BID × 7 days'),
          DoseLine(
            'Otovel Otic and generics:',
            isHeading: true,
          ),
          DoseLine('Acute otitis media with tympanostomy tubes (≥6 mo): 0.25 mL to affected '
              'ear(s) BID × 7 days'),
        ],
      ),
    ],
    remarks: [
      'Systemic fluoroquinolones are associated with disabling and potentially '
          'permanent side effects to the tendons, muscles, joints, nerves, and '
          'central nervous system.',
      'Can cause GI upset, renal failure, and seizures. GI symptoms, headache, '
          'restlessness, and rash are common side effects. Peripheral neuropathy, '
          'pseudotumor cerebri, severe hepatic necrosis, psychiatric reactions, and '
          'acute myocardial ischemia (as part of an allergic reaction) have been '
          'reported. Use with caution in children <18 yr (like other quinolones, '
          'tendon rupture can occur during or after therapy, especially with '
          'concomitant corticosteroid use), alkalinized urine (crystalluria), '
          'seizures, excessive sunlight (photosensitivity), and renal dysfunction '
          '(adjust systemic dose in renal failure; see Chapter 32). Blood glucose '
          'disturbances (hypoglycemia and hyperglycemia) have been reported in '
          'patients with diabetes who are receiving insulin or an oral hypoglycemic '
          'agent.',
      'Do not use otic suspension with perforated tympanic membranes and with '
          'viral infections of the external ear canal.',
      'For dosing in obese patients, use an adjusted body weight (ABW): ABW = '
          'ideal body weight + 0.45 (total body weight ∼ ideal body weight)',
      'Combinational antimicrobial therapy is recommended for anthrax. For '
          'penicillin-susceptible strains, consider changing to high-dose '
          'amoxicillin (25–35 mg/kg/dose PO TID). See www.bt.cdc.gov for the latest '
          'information.',
      'Inhibits cytochrome P-450 1A2. Ciprofloxacin can increase effects and/or '
          'toxicity of caffeine, methotrexate, theophylline, warfarin, tizanidine '
          '(excessive sedation and dangerous hypotension), and cyclosporine. '
          'Probenecid increases ciprofloxacin levels.',
      'Do not administer antacids or other divalent salts with or within 2–4 hr '
          'of oral ciprofloxacin dose. Do not administer oral suspension through '
          'feeding tubes, because this dosage form adheres to the tube.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 930–931',
  ),
  // CITRATE MIXTURES — PDF p. 123 (printed 932)
  DrugEntryV3(
    name: 'CITRATE MIXTURES',
    brandNames: '',
    drugClass: 'Alkalinizing agent, electrolyte supplement',
    iconRow: '',
    formulations: [
      'Oral liquid',
      'ᵃSugar free.',
      'Oral powder for oral solution:',
      'Cytra-K: Each packet of sugar-free powder contains 30 mEq each of '
          'potassium and citrate/HCO₃ (100 packets per box) and must be diluted in '
          'at least 6 ounces of cold water or juice.',
    ],
    doseSections: [
      DoseSection(
        heading: 'mEq of Electrolyte per mL Oral Solution',
        table: DoseTable(
          headers: ['', 'Na', 'K', 'Citrate or HCO₃'],
          rows: [
            DoseTableRow(['Tricitrates1ᵃ or sodium citrate/potassium citrate and citric acid (473 mL)', '1', '1', '2']),
            DoseTableRow(['Potassium citrate and citric acidᵃ (473 mL)', '0', '2', '2']),
            DoseTableRow(['Sodium citrate and citric acidᵃ (30, 473 mL)', '1', '0', '1']),
            DoseTableRow(['Oracit (15, 30, 500 mL)', '1', '0', '1']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Dilute dose in water or juice.',
      ),
      DoseSection(
        heading: 'All mEq doses based on citrate.',
      ),
      DoseSection(
        heading: 'Systemic alkalinization:',
        lines: [
          DoseLine('Infant and child (PO): 2–3 mEq/kg/24 hr ÷ Q6–8 hr or 5–15 mL/dose ÷ Q6–8 '
              'hr (after meals and before bedtime) and adjust dose to desired serum '
              'bicarbonate level'),
          DoseLine('Adult (PO): 100–200 mEq/24 hr ÷ Q6–8 hr or 15–30 mL/dose ÷ Q6–8 hr (after '
              'meals and before bedtime)'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in severe renal impairment and acute dehydration. Use '
          'with caution in patients already receiving potassium supplements or who '
          'are sodium restricted. May have laxative effect and cause hypocalcemia '
          'and metabolic alkalosis. Patients with active UTIs may attenuate the '
          'ability to increase urinary citrate by bacterial enzymatic degradation of '
          'citrate. Also, the rise in urinary pH may promote bacterial growth.',
      'Adjust dose to maintain desired pH. 1 mEq of citrate is equivalent to 1 '
          'mEq HCO₃ in patients, as citrate is converted to CO₂ via the citric acid '
          'cycle in the mitochondria.',
      'Potassium citrate has a pregnancy category of “C”; otherwise the '
          'pregnancy category is unknown for the other components to this medication.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 932',
  ),
  // CLARITHROMYCIN — PDF p. 123–124 (printed 932–933)
  DrugEntryV3(
    name: 'CLARITHROMYCIN',
    brandNames: 'Generics; previously available as Biaxin and Biaxin XL',
    drugClass: 'Antibiotic, macrolide',
    iconRow: '',
    formulations: [
      'Film tabs: 250, 500 mg',
      'Extended-release tabs: 500 mg',
      'Granules for oral suspension: 125, 250 mg/5 mL (50, 100 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infant and child:',
        lines: [
          DoseLine('Pharyngitis/tonsillitis, pneumonia, acute maxillary sinusitis, or '
              'uncomplicated skin infections: 15 mg/kg/24 hr PO ÷ Q12 hr; max. dose: 1 '
              'g/24 hr (500 mg/24 hr for pharyngitis/tonsillitis)'),
          DoseLine('Pertussis (≥1 mo): 15 mg/kg/24 hr PO ÷ Q12 hr × 7 days; max. dose: 1 g/24 '
              'hr'),
          DoseLine('Bacterial endocarditis prophylaxis: 15 mg/kg (max. dose: 500 mg) PO 30–60 '
              'min before procedure'),
          DoseLine('Helicobacter pylori: 20 mg/kg/24 hr PO ÷ Q12 hr × 7–14 days; max. dose: 1 '
              'g/24 hr with amoxicillin and proton pump inhibitor with/without '
              'metronidazole'),
          DoseLine(
            'Mycobacterium avium complex (MAC):',
            isHeading: true,
          ),
          DoseLine('Prophylaxis (1st episode and recurrence): 15 mg/kg/24 hr PO ÷ Q12 hr'),
          DoseLine('Treatment: 15 mg/kg/24 hr PO ÷ Q12 hr with other antimycobacterial drugs'),
          DoseLine('Max. dose (prophylaxis and treatment): 1 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adolescent and adult:',
        lines: [
          DoseLine(
            'Pharyngitis/tonsillitis, acute maxillary sinusitis, bronchitis, '
                'pneumonia, or uncomplicated skin infections:',
            isHeading: true,
          ),
          DoseLine('Immediate release: 250–500 mg/dose PO Q12 hr (use 250 mg/dose Q12 hr for '
              'pharyngitis/tonsillitis or uncomplicated skin infections)'),
          DoseLine('Extended-release tablet (use not indicated for pharyngitis/tonsilitis or '
              'uncomplicated skin infections): 1000 mg PO Q24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult (immediate-release dosage form):',
        lines: [
          DoseLine('Pertussis: 500 mg/dose PO Q12 hr × 7 days'),
          DoseLine('Bacterial endocarditis prophylaxis: 500 mg PO 30–60 min before procedure'),
          DoseLine(
            'MAC:',
            isHeading: true,
          ),
          DoseLine('Prophylaxis (1st episode and recurrence): 500 mg/dose PO Q12 hr'),
          DoseLine('Treatment: 500 mg PO Q12 hr with other antimycobacterial drugs'),
          DoseLine('Helicobacter pylori GI infection: 500 mg PO Q12 hr × 7–14 days with '
              'proton pump inhibitor (lansoprazole or omeprazole) and amoxicillin'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in patients allergic to erythromycin and with history of '
          'cholestatic jaundice/hepatic dysfunction with prior use. As with other '
          'macrolides, clarithromycin has been associated with Q–T prolongation '
          '(avoid use with other drugs known to prolong Q–T interval) and '
          'ventricular arrhythmias, including ventricular tachycardia and torsades '
          'de pointes. May cause cardiac arrhythmias in patients also receiving '
          'cisapride. Side effects: diarrhea, nausea, abnormal taste, dyspepsia, '
          'abdominal discomfort (less than erythromycin but greater than '
          'azithromycin), and headache. Anaphylaxis, angioedema, hepatic '
          'dysfunction, rhabdomyolysis, SJS, and TEN have been reported. No longer '
          'recommended for acute otitis media due to limited efficacy against S. '
          'pneumoniae and H. influenzae.',
      'May increase effects/toxicity of carbamazepine, theophylline, '
          'cyclosporine, digoxin, ergot alkaloids, fluconazole, midazolam, selected '
          'oral hypoglycemic agents, tacrolimus, triazolam, quetiapine, and '
          'warfarin. Substrate and inhibitor of cytochrome P-450 (CYP) 3A4, and '
          'inhibits CYP1A2.',
      'Adjust dose in renal failure (see Chapter 32). Doses, regardless of '
          'dosage form, may be administered with food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 932–933',
  ),
  // CLINDAMYCIN — PDF p. 124–126 (printed 933–935)
  DrugEntryV3(
    name: 'CLINDAMYCIN',
    brandNames: 'Cleocin, Cleocin-T, Clindagel, Clindesse, Clindacin, Xaciato, and '
        'generics',
    drugClass: 'Antibiotic, lincomycin derivative',
    iconRow: '',
    formulations: [
      'Caps: 75, 150, 300 mg',
      'Oral solution: 75 mg/5 mL (100 mL); may contain ethyl parabens',
      'Injection: 150 mg/mL (2, 4, 6, 60 mL); contains 9.45 mg/mL benzyl alcohol',
      'Premixed injection in 5% dextrose or NS: 300 mg/50 mL, 600 mg/50 mL, 900 '
          'mg/50 mL; contains edetate disodium and may contain benzyl alcohol',
      'Solution, topical: 1% (30, 60 mL); may contain 50% isopropyl alcohol and '
          'propylene glycol',
      'Gel, topical (Cleocin-T, Clindagel, and generics): 1% (30, 60 g); may '
          'contain methylparaben and propylene glycol',
      'Lotion, topical (Cleocin-T and generics): 1% (60 mL); may contain '
          'methylparaben',
      'Foam, topical (Clindacin and generics): 1% (50, 100 g); contains 58% '
          'ethanol',
      'See Benzoyl peroxide for combination topical product (clindamycin and '
          'benzoyl peroxide).',
      'See Tretinoin for combination topical product (clindamycin and tretinoin).',
      'Vaginal cream (Cleocin and generics): 2% (40 g); may contain benzyl '
          'alcohol or parabens',
      'Clindesse: 2% (5 g); contains parabens',
      'Vaginal gel (Xaciato): 2% (25 g); contains benzyl alcohol',
      'Vaginal suppository (Cleocin): 100 mg (3s)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate (IV/IM):',
        lines: [
          DoseLine('≤32 wk postmenstrual age: 5 mg/kg/dose Q8 hr'),
          DoseLine('33–40 wk postmenstrual age: 7 mg/kg/dose Q8 hr'),
          DoseLine('>40 wk postmenstrual age: 9 mg/kg/dose Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Child (>1 mo) and adolescent (see remarks for dosing in obesity):',
        lines: [
          DoseLine('PO: 10–40 mg/kg/24 hr ÷ Q6–8 hr; max. dose: 1.8 g/24 hr'),
          DoseLine('IM/IV: 20–40 mg/kg/24 hr ÷ Q6–8 hr; max. dose: 2.7 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('PO: 600–1800 mg/24 hr ÷ Q6–12 hr; max. dose: 2.4 g/24 hr'),
          DoseLine('IM/IV: 1200–2700 mg/24 hr ÷ Q6–12 hr; max. IV dose: 4.8 g/24 hr; max. IM '
              'dose: 600 mg/dose'),
        ],
      ),
      DoseSection(
        heading: 'Topical for acne (≥12 yr and adult; administer after washing and '
            'fully drying the affected skin):',
        lines: [
          DoseLine('Solution, lotion, or gel (Cleocin-T and generics): Apply to affected area '
              'BID.'),
          DoseLine('Clindagel or Evoclin (foam): Apply to affected area once daily.'),
        ],
      ),
      DoseSection(
        heading: 'Bacterial vaginosis (≥12 yr and adult):',
        lines: [
          DoseLine('Suppositories: 100 mg/dose QHS × 3 days for nonpregnant patients'),
          DoseLine('Vaginal cream (2%): 1 applicator dose (5 g) QHS for 3 or 7 days in '
              'nonpregnant patients and for 7 days in pregnant patients in second and '
              'third trimesters'),
          DoseLine('Clindesse (2%): 1 applicator dose (5 g) × 1 for nonpregnant patients'),
          DoseLine('Vaginal gel (2%; Xaciato): 1 applicator dose (5 g) × 1'),
        ],
      ),
    ],
    remarks: [
      'Not indicated in meningitis; CSF penetration is poor. Clindamycin is no '
          'longer recommended for antibiotic prophylaxis for dental procedures.',
      'Pseudomembranous colitis may occur up to several weeks after cessation of '
          'therapy. May cause diarrhea, rash, granulocytopenia, thrombocytopenia, or '
          'sterile abscess at injection site. Severe taste alterations, including '
          'metallic taste (with high IV doses), and anaphylaxis, DRESS, SJS, TEN, '
          'and AKI have been reported with systemic use. The intravenous product '
          'contains benzyl alcohol. Eye pain and contact dermatitis have been '
          'reported with topical use.',
      'Clindamycin may increase the neuromuscular blocking effects of '
          'tubocurarine and pancuronium. Do not exceed IV infusion rate of 30 mg/min '
          'because hypotension and cardiac arrest have been reported with rapid '
          'infusions. May diminish the effects of erythromycin when administered '
          'together. In vitro studies indicate clindamycin is a substrate and '
          'inhibitor for cytochrome P-450 3A4.',
      'Dosage reduction may be required in severe renal or hepatic disease but '
          'not necessary in mild/moderate conditions. Systemic clindamycin should be '
          'dosed based on total body weight regardless of obesity. Oral liquid '
          'preparation may not be palatable; consider use of oral capsules as a '
          'sprinkle onto applesauce or pudding. Esophagitis has been reported '
          'particularly when taking the capsule dosage form in a lying position or '
          'with a small amount of water.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 933–935',
  ),
  // CLOBAZAM — PDF p. 126–127 (printed 935–936)
  DrugEntryV3(
    name: 'CLOBAZAM',
    brandNames: 'Onfi, Sympazan, and generics',
    drugClass: 'Benzodiazepine, anticonvulsant',
    iconRow: '',
    formulations: [
      'Tabs (Onfi and generics): 10, 20 mg',
      'Oral film (Sympazan): 5, 10, 20 mg (60s)',
      'Oral suspension (Onfi and generics): 2.5 mg/mL (120 mL); contains '
          'parabens, polysorbate 80, and propylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Lennox-Gastaut (adjunctive therapy; see remarks):',
        lines: [
          DoseLine('Child (≥2 yr) and adult (PO): Dosage increments (if needed) should not be '
              'more rapid than every 7 days.'),
        ],
        table: DoseTable(
          headers: ['Weight (kg)', 'Initial Dose', 'Dose at Day 8, if Needed', 'Dose at Day 15, if Needed'],
          rows: [
            DoseTableRow(['≤30 kg', '5 mg once daily', '5 mg BID', '10 mg BID (max. dose)']),
            DoseTableRow(['>30 kg', '5 mg BID', '10 mg BID', '20 mg BID (max. dose)']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine(
            'Dosage adjustment for mild/moderate hepatic impairment (Child-Pugh score '
                '5–9) and individuals with poor cytochrome P-450 (CYP) 2C19 activity (PO):',
            isHeading: true,
          ),
        ],
        table: DoseTable(
          headers: ['Weight (kg)', 'Initial Dose', 'First Dose Increment, if Needed', 'Second Dose Increment, if Needed', 'Third Dose Increment, if Needed'],
          rows: [
            DoseTableRow(['≤30 kg', '5 mg once daily × ≥14 days', '5 mg BID × ≥7 days', '10 mg BID (max. dose)', 'N/A']),
            DoseTableRow(['>30 kg', '5 mg once daily × ≥7 days', '5 mg BID × ≥7 days', '10 mg BID × ≥7 days', '20 mg BID (max. dose)']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('N/A, Not applicable.'),
        ],
      ),
      DoseSection(
        heading: 'Seizures (generalized or partial, as monotherapy or adjunctive '
            'therapy; limited data and prescribing information from Canada and the '
            'United Kingdom):',
        lines: [
          DoseLine('Infant and child (<2 yr): Start at 0.5–1 mg/kg/24 hr (max. dose: 5 mg/24 '
              'hr) PO ÷ BID; if needed and tolerated, slowly increase dosage at 5- to '
              '7-day intervals up to the maximum of 10 mg/24 hr.'),
          DoseLine('2–16 yr: Start at 5 mg PO once daily; if needed and tolerated, slowly '
              'increase dosage at 5- to 7-day intervals up to the maximum of 40 mg/24 '
              'hr. Usual dosage range: 10–20 mg/24 hr or 0.3–1 mg/kg/24 hr ÷ BID'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in hepatic impairment (dose adjustment may be needed). '
          'Do not discontinue use abruptly, as seizures/withdrawal symptoms may '
          'occur. Common side effects include constipation, drooling, ataxia, '
          'drowsiness, insomnia, aggressive behavior, cough, and fever. SJS, TEN, '
          'urinary retention, hypothermia, leukopenia, and thrombocytopenia have '
          'been reported. Patients should be instructed to report any fever or rash '
          'associated with signs of organ system involvement (e.g., lymphadenopathy, '
          'hepatic dysfunction) to their healthcare provider immediately as these '
          'reactions could be related to a DRESS or multiorgan hypersensitivity drug '
          'reaction.',
      'Do not use in combination with azelastine, olanzapine, sodium oxybate, '
          'and thioridazine; increases risk for adverse events. Proton pump '
          'inhibitors, azole antifungal agents (e.g., itraconazole and '
          'ketoconazole), St. John’s wort, grapefruit juice, CNS depressants, '
          'cimetidine, calcium channel blockers, and strong/moderate CYP2C19 '
          'inhibitors may increase the effects/toxicity of clobazam. Use with '
          'opioids may result in profound sedation, respiratory depression, coma, '
          'and mortality. Carbamazepine, rifamycin derivatives (e.g., rifampin), and '
          'theophylline may decrease the effects of clobazam. Clobazam is a major '
          'substrate for CYP2C19 and P-glycoprotein, minor substrate for CYP2B6 and '
          '3A4, inhibitor of CYP2D6, and inducer of CYP3A4. Carefully review the '
          'patient’s medication profile for other drug interactions each time '
          'clobazam is initiated or when a new drug is added to a regimen containing '
          'clobazam.',
      'Short-term use in lactating mothers is not likely to cause adverse '
          'effects to breastfed infants, especially if the infant is >2 months old. '
          'However, long-term maternal use may result in sedation, poor '
          'feeding/weight gain in the infant. Neonates born to mothers receiving '
          'benzodiazepines late in pregnancy have experienced symptoms of sedation '
          'and/or neonatal withdrawal.',
      'Doses may be taken with or without food. Tablets may be crushed and mixed '
          'with applesauce.',
      'Oral film (Sympazan) uses same PO dosage with the following method for '
          'administration: apply film on top of the tongue, allow it to dissolve, '
          'and swallow saliva in a normal manner. Do not chew, spit, or talk while '
          'film is dissolving. Doses may be taken with or without food but do not '
          'administer with liquids.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 935–936',
  ),
  // CLONAZEPAM — PDF p. 127–128 (printed 936–937)
  DrugEntryV3(
    name: 'CLONAZEPAM',
    brandNames: 'Klonopin and generics',
    drugClass: 'Benzodiazepine, anticonvulsant',
    iconRow: '',
    formulations: [
      'Tabs: 0.5, 1, 2 mg',
      'Disintegrating oral tabs: 0.125, 0.25, 0.5, 1, 2 mg; contains '
          'phenylalanine',
      'Oral suspension: 100 mCg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Seizures:',
        lines: [
          DoseLine(
            'Infant and child <10 yr or <30 kg:',
            isHeading: true,
          ),
          DoseLine('Initial: 0.01–0.03 mg/kg/24 hr PO ÷ BID–TID; maximum initial dose: 0.05 '
              'mg/kg/24 hr'),
          DoseLine('Maintenance: 0.01–0.02 mg/kg/24 hr increments PO Q3 days PRN (not to '
              'exceed 0.25–0.5 mg/24 hr) up to a maximum maintenance dose of 0.2 '
              'mg/kg/24 hr ÷ TID'),
          DoseLine(
            'Child ≥10 yr or ≥30 kg and adult:',
            isHeading: true,
          ),
          DoseLine('Initial: 1.5 mg/24 hr PO ÷ TID'),
          DoseLine('Maintenance: 0.5–1 mg/24 hr increments PO Q3–7 days PRN up to a maximum '
              'maintenance dose of 20 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in severe liver disease and acute narrow-angle glaucoma. '
          'Drowsiness, behavior changes, increased bronchial secretions, GI, CV, GU, '
          'and hematopoietic toxicity (thrombocytopenia, leukopenia) may occur. '
          'Monitor for depression, suicidal behavior/ideation, and unusual changes '
          'in behavior/mood. Use with caution in patients with compromised '
          'respiratory function, porphyria, and renal impairment. Do not discontinue '
          'abruptly. T₁/₂ = 24–36 hr.',
      'Maternal clonazepam use in breast-fed infants: monitor infant for '
          'drowsiness, weight gain, and developmental milestones. Neonates born to '
          'mothers receiving benzodiazepines late in pregnancy have experienced '
          'symptoms of sedation and/or neonatal withdrawal.',
      'Proposed therapeutic levels (not well established): 20–80 ng/mL. '
          'Recommended serum sampling time: Obtain trough level within 30 min prior '
          'to an oral dose. Steady state is typically achieved after 5–8 days '
          'continuous therapy using the same dose.',
      'Carbamazepine, phenytoin, and phenobarbital may decrease clonazepam '
          'levels and effect. Drugs that inhibit cytochrome P-450 3A4 isoenzymes '
          '(e.g., erythromycin) may increase clonazepam levels and effects/toxicity.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 936–937',
  ),
  // CLONIDINE — PDF p. 128–129 (printed 937–938)
  DrugEntryV3(
    name: 'CLONIDINE',
    brandNames: 'Onyda XR, Catapres TTS, Duraclon, and generics; previously '
        'available as Catapres and Kapvay',
    drugClass: 'Central α-adrenergic agonist, antihypertensive',
    iconRow: '',
    formulations: [
      'Tabs: 0.1, 0.2, 0.3 mg',
      'Extended-release oral tabs:',
      'Generics; previously available as Kapvay (12-hr dosing): 0.1 mg',
      'Oral suspension: 20, 100 mCg/mL',
      'Extended-release oral suspension:',
      'Onyda XR: 0.1 mg/mL (7, 30, 60 mL); contains EDTA, parabens, and '
          'polysorbate 80',
      'Transdermal patch (Catapres TTS and generics): 0.1, 0.2, 0.3 mg/24 hr '
          '(7-day patch; 4 patches per box); contains metallic components (see '
          'remarks)',
      'Injection, epidural (Duraclon and generics): 100, 500 mCg/mL (10 mL); '
          'preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonatal abstinence syndrome, adjunctive therapy (use '
            'immediate-release product; limited data):',
        lines: [
          DoseLine('Start at 0.5–1 mCg/kg/dose PO Q3–6 hr; use Q6 hr interval for preterm '
              'neonates. Dosage increments as needed: ~25% of the initial dose up to a '
              'reported maximum dose of 24 mCg/kg/24 hr.'),
        ],
      ),
      DoseSection(
        heading: 'ADHD (Child ≥6 yr and adolescent):',
        lines: [
          DoseLine(
            'Immediate-release product (PO):',
            isHeading: true,
          ),
          DoseLine('27–45 kg: Start with 0.05 mg QHS; if needed, increase by 0.05 mg/24 hr '
              'every 2–3 days as increments with BID, TID, and then QID dosing up to the '
              'following max. dose: 27–40.5 kg: 0.2 mg/24 hr'),
          DoseLine('>40.5–45 kg: 0.3 mg/24 hr'),
          DoseLine('>45 kg: Start with 0.1 mg QHS; if needed, increase by 0.1 mg/24 hr every '
              '2–3 days as increments with BID, TID, and then QID dosing up to the max. '
              'dose of 0.4 mg/24 hr.'),
          DoseLine('Extended-release product (Onyda XR oral suspension or generic tabs, PO): '
              'Start with 0.1 mg QHS; if needed, increase by 0.1 mg every 7 days by '
              'administering the dose BID up to a maximum of 0.4 mg/24 hr. Depending on '
              'dosage level, BID dosing should be either the same amount or with the '
              'higher dosage given at bedtime. If therapy is to be discontinued, slowly '
              'reduce dosage at ≤0.1 mg every 3 to 7 days to avoid withdrawal.'),
        ],
      ),
      DoseSection(
        heading: 'Hypertension (use immediate-release products unless noted):',
        lines: [
          DoseLine('Child (PO): 2–5 mCg/kg/dose Q6–8 hr initially; if needed, increase at 5- '
              'to 7-day intervals up to 10 mCg/kg/dose Q6–8 hr; max. dose: 0.8 mg/24 hr'),
          DoseLine('≥12 yr and adult (PO): 0.1 mg BID initially; increase in 0.1 mg/24 hr '
              'increments at weekly intervals until desired response is achieved (usual '
              'range: adolescent: 0.2–0.6 mg/24 hr ÷ BID; adult: 0.1–0.8 mg/24 hr ÷ '
              'BID); max. dose: 2.4 mg/24 hr'),
          DoseLine(
            'Transdermal patch (each patch lasts 7 days by rotating application sites, '
                'but more frequent patch change at every 5 days may be needed for '
                'children):',
            isHeading: true,
          ),
          DoseLine('Child: Conversion to patch only after establishing an optimal oral dose '
              'first. Use a transdermal dosage closest to the established total oral '
              'daily dose.'),
          DoseLine('Adult: Initial 0.1 mg/24 hr patch for first week. May increase dose by '
              '0.1 mg/24 hr at 1–2 wk intervals PRN. Usual range: 0.1–0.3 mg/24 hr. '
              'Doses >0.6 mg/24 hr do not provide additional benefit. Onset of action is '
              'delayed at 2–3 days following initiation due to required time to build up '
              'subcutaneous tissue drug levels.'),
        ],
      ),
    ],
    remarks: [
      'Immediate-release and extended-release dosage forms are NOT '
          'interchangeable on a mg-per-mg basis.',
      'Side effects: Dry mouth, dizziness, drowsiness, fatigue, constipation, '
          'anorexia, arrhythmias, and local skin reactions with patch. Somnolence, '
          'fatigue, URIs, irritability, throat pain, insomnia, nightmares, and '
          'emotional disorder were reported as common side effects in ADHD clinical '
          'trials. May worsen sinus node dysfunction and AV block, especially for '
          'patients taking other sympatholytic drugs. Do not abruptly discontinue; '
          'signs of sympathetic overactivity may occur; taper gradually over >1 wk.',
      'β-Blockers may exacerbate rebound hypertension during and following the '
          'withdrawal of clonidine. If patient is receiving both clonidine and a '
          'β-blocker and clonidine is to be discontinued, the β-blocker should be '
          'withdrawn several days prior to tapering the clonidine. If converting '
          'from clonidine over to a β-blocker, introduce the β-blocker several days '
          'after discontinuing clonidine (after taper).',
      'Monitor heart rate when used with digitalis, calcium channel blockers, '
          'and β-blockers. Use with diltiazem or verapamil may result in sinus '
          'bradycardia. Use with neuroleptics may induce/exacerbate orthostatic '
          'hypotension, dizziness, and fatigue. Consider using lower dosages in '
          'renal impairment because the drug is primarily eliminated unchanged in '
          'the urine and signs of bradycardia, sedation, and hypotension may occur.',
      'T₁/₂: 44–72 hr (neonate), 6–20 hr (adult). Onset of action '
          '(antihypertensive): 0.5–1 hr for oral route, 2–3 days for transdermal '
          'route. Do not use transdermal route while patient is undergoing a '
          'magnetic resonance imaging (MRI) procedure; transdermal patches contain '
          'metals and may result in serious patient burns when undergoing MRI.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 937–938',
  ),
  // CLOTRIMAZOLE — PDF p. 129–130 (printed 938–939)
  DrugEntryV3(
    name: 'CLOTRIMAZOLE',
    brandNames: 'Alevazol, Lotrimin AF, and generics; previously available as '
        'Gyne-Lotrimin 3 and Gyne-Lotrimin 7',
    drugClass: 'Antifungal, imidazole',
    iconRow: '',
    formulations: [
      'Oral troche: 10 mg',
      'Cream, topical (Lotrimin AF and generics; OTC): 1% (15, 30, 45 g); may '
          'contain benzyl alcohol or parabens',
      'Ointment, topical (Alevazol; OTC): 1% (56.7 g)',
      'Solution, topical (OTC): 1% (10, 30 mL)',
      'Vaginal cream (OTC):',
      'Generics; previously available as Gyne-Lotrimin 7: 1% (45 g)',
      'Generics ; previously available as Gyne-Lotrimin 3: 2% (21 g)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Topical (cream, ointment, or solution):',
        lines: [
          DoseLine('≥2 yr–adult: Apply to affected skin areas BID; × 2 wk for cutaneous '
              'candidiasis or tinea cruris, × 2–4 wk for tinea corporis, × 4–8 wk for '
              'tinea pedis.'),
        ],
      ),
      DoseSection(
        heading: 'Vaginal cream (>12 yr and adult; in addition to intravaginal use, may '
            'also apply to external vaginal area BID × 7 days PRN for itching and '
            'irritation):',
        lines: [
          DoseLine('1% cream: 1 applicator dose (5 g) intravaginally QHS × 7–14 days, or'),
          DoseLine('2% cream: 1 applicator dose intravaginally QHS × 3 days'),
        ],
      ),
      DoseSection(
        heading: 'Oropharyngeal candidiasis:',
        lines: [
          DoseLine('>3 yr–adult: Dissolve 1 troche slowly (15–30 min) in the mouth 5 times/24 '
              'hr × 14 days.'),
        ],
      ),
    ],
    remarks: [
      'Systemic use: Do not use troches for systemic infections. Liver enzyme '
          'elevation, nausea, and vomiting may occur with troches.',
      'Topical use: May cause erythema, blistering, or urticaria with topical '
          'use. Avoid use of tampons, douches, spermicides, other vaginal products, '
          'condoms, and diaphragms with vaginal cream. Vaginal cream can weaken '
          'latex.',
    ],
    pregnancyNote: 'Pregnancy code is a “B” for topical and vaginal dosage forms and '
        '“C” for troches.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 938–939',
  ),
  // CORTICOTROPIN — PDF p. 130 (printed 939)
  DrugEntryV3(
    name: 'CORTICOTROPIN',
    brandNames: 'Acthar Gel, Cortrophin Gel; ACTH',
    drugClass: 'Adrenocorticotropic hormone',
    iconRow: '',
    formulations: [
      'Injection, repository gel: 80 U/mL (5 mL); contains phenol',
      '1 unit = 1 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infantile spasms (many regimens exist):',
        lines: [
          DoseLine('20–40 U/24 hr IM once daily × 6 wk or 150 U/m²/24 hr ÷ BID for 2 wk, '
              'followed by a gradual 2-wk taper: 30 U/m²/dose QAM × 3 days, followed by '
              '15 U/m²/dose QAM × 3 days, followed by 10 U/m²/dose QAM × 3 days, '
              'followed by 10 U/m²/dose every other morning × 6 days'),
        ],
      ),
      DoseSection(
        heading: 'Anti-inflammatory:',
        lines: [
          DoseLine('≥2 yr and adolescent: 0.8 U/kg/24 hr IM ÷ Q12–24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in infants <2 yr with suspected congenital infections, '
          'acute psychoses, CHF, Cushing disease, primary adrenocortical '
          'insufficiency or adrenocortical hyperfunction, TB, peptic ulcer, ocular '
          'herpes, fungal infections, recent surgery, and sensitivity to porcine '
          'products. Use with caution in osteoporosis, hypertension, and renal '
          'insufficiency. Repository gel dosage form is only for IM route.',
      'Hypersensitivity reactions and injection site reactions may occur. Cases '
          'of anaphylaxis have been reported. Adverse effects similar to '
          'corticosteroids. Do not use with live or live attenuated vaccines.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 939',
  ),
  // CORTISONE ACETATE — PDF p. 131 (printed 940)
  DrugEntryV3(
    name: 'CORTISONE ACETATE',
    brandNames: 'Various generics',
    drugClass: 'Corticosteroid',
    iconRow: '',
    formulations: [
      'Tabs: 25 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Anti-inflammatory/immunosuppressive:',
        lines: [
          DoseLine('Child: 2.5–10 mg/kg/24 hr PO ÷ Q6–8 hr'),
          DoseLine('Adult: 25–300 mg/24 hr PO ÷ Q12–24 hr'),
        ],
      ),
    ],
    remarks: [
      'May produce glucose intolerance, Cushing syndrome, edema, hypertension, '
          'adrenal suppression, cataracts, hypokalemia, skin atrophy, peptic ulcer, '
          'osteoporosis, and growth suppression.',
    ],
    pregnancyNote: 'Pregnancy category changes to “D” if used in the first trimester.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 940',
  ),
  // CO-TRIMOXAZOLE — PDF p. 131 (printed 940)  [cross-reference]
  DrugEntryV3(
    name: 'CO-TRIMOXAZOLE',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Sulfamethoxazole and Trimethoprim',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 940',
  ),
  // CROMOLYN — PDF p. 131–132 (printed 940–941)
  DrugEntryV3(
    name: 'CROMOLYN',
    brandNames: 'Nasalcrom, Gastrocrom, and generics; previously available as Intal',
    drugClass: 'Antiallergic agent, mast cell stabilizer',
    iconRow: '',
    formulations: [
      'Nebulized solution: 10 mg/mL (2 mL)',
      'Oral concentrate (Gastrocrom and generics): 100 mg/5 mL (5 mL)',
      'Ophthalmic solution: 4% (10 mL)',
      'Nasal spray (NasalCrom and generics) [OTC]: 4% (5.2 mg/spray) (100 '
          'sprays, 13 mL; 200 sprays, 26 mL); contains benzalkonium chloride and EDTA',
    ],
    doseSections: [
      DoseSection(
        heading: 'Nebulization:',
        lines: [
          DoseLine('Child ≥2 yr and adult: 20 mg Q6–8 hr'),
          DoseLine('Exercise-induced asthma: 20 mg × 1, 10–15 min prior to and no longer than '
              '1 hr before exercise'),
        ],
      ),
      DoseSection(
        heading: 'Nasal:',
        lines: [
          DoseLine('Child ≥2 yr and adult: 1 spray each nostril TID–QID; max. dose: 1 spray 6 '
              'times/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Ophthalmic:',
        lines: [
          DoseLine('Child >4 yr and adult: 1–2 gtts 4–6 times/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Food allergy/inflammatory bowel disease (taper to lowest effective '
            'dose once desired effect is achieved):',
        lines: [
          DoseLine('2–12 yr: 100 mg PO QID; give 15–20 min AC and QHS; max. dose: 40 mg/kg/24 '
              'hr'),
          DoseLine('>12 yr and adult: 200–400 mg PO QID; give 15–20 min AC and QHS'),
        ],
      ),
      DoseSection(
        heading: 'Systemic mastocytosis (taper to lowest effective maintenance dose '
            'once desired effect is achieved):',
        lines: [
          DoseLine('Infant and child <2 yr: 20 mg/kg/24 hr PO ÷ QID; max. dose: <6 mo: 20 '
              'mg/kg/24 hr; ≥6 mo to <2 yr: 100 mg/dose or 40 mg/kg/24 hr'),
          DoseLine('2–12 yr: 100 mg PO QID; give 30 min AC and QHS; max. dose: 40 mg/kg/24 hr'),
          DoseLine('>12 yr and adult: 200 mg PO QID; give 30 min AC and QHS; max. dose: 40 '
              'mg/kg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'May cause rash, cough, bronchospasm, and nasal congestion. May cause '
          'headache, diarrhea with oral use. Use with caution in patients with renal '
          'or hepatic dysfunction because cromolyn is equally excreted unchanged in '
          'the urine and feces (bile).',
      'Therapeutic response often occurs within 2 wk; however, a 4- to 6-wk '
          'trial may be needed to determine maximum benefit. Oral concentrate can '
          'only be diluted in water. Nebulized solution can be mixed with albuterol '
          'nebs.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 940–941',
  ),
  // CYANOCOBALAMIN/VITAMIN B₁₂ — PDF p. 132 (printed 941)
  DrugEntryV3(
    name: 'CYANOCOBALAMIN/VITAMIN B₁₂',
    brandNames: 'Dodex, Physicians EZ Use B-12, Vitamin Deficiency System B12, '
        'Nascobal, vitamin B₁₂, and generics',
    drugClass: 'Vitamin (synthetic), water soluble',
    iconRow: '',
    formulations: [
      'Tabs (OTC): 100, 250, 500, 1000 mCg',
      'Extended-release tabs: 1000 mCg',
      'Sublingual tabs: 2500 mCg',
      'Sublingual liquid: 3000 mCg/mL (52 mL), 5000 mCg/mL (60 mL)',
      'Lozenges (OTC): 50, 100, 250, 500 mCg',
      'Nasal spray (Nascobal and generics): 500 mCg/spray (1.3 mL delivers 4 '
          'doses); contains benzalkonium chloride',
      'Injection (Dodex and generics): 1000 mCg/mL (1, 10, 30 mL); may contain '
          'benzyl alcohol',
      'Injection kit (Physicians EZ Use B-12, and Vitamin Deficiency System '
          'B12): 1000 mCg/mL (1 mL); may contain benzyl alcohol',
      'Contains cobalt (4.35%); and some preparations may contain aluminum',
    ],
    doseSections: [
      DoseSection(
        heading: 'U.S. RDA:',
        lines: [
          DoseLine('See Chapter 21.'),
        ],
      ),
      DoseSection(
        heading: 'Vitamin B₁₂ deficiency, treatment:',
        lines: [
          DoseLine('Child (IM or deep SC): 100 mCg/24 hr × 10–15 days followed by 100 mCg '
              'once or twice weekly for several months'),
          DoseLine('Maintenance: At least 60 mCg/mo'),
          DoseLine('Adult (IM or deep SC): 100 mCg/24 hr × 6–7 days; if improvement, 100 '
              'mCg/dose every 3–4 days × 2–3 wk. Use maintenance dose when hematologic '
              'values return to normal.'),
          DoseLine('Maintenance: 100 mCg/mo'),
        ],
      ),
      DoseSection(
        heading: 'Pernicious anemia:',
        lines: [
          DoseLine('Child (IM or deep SC): 30–50 mCg/24 hr for at least 14 days to a total '
              'dose of 1000–5000 mCg'),
          DoseLine('Maintenance: 100 mCg/mo'),
          DoseLine('Adult (IM or deep SC): 100 mCg/24 hr × 6–7 days; if improvement, 100 '
              'mCg/dose every 3–4 days × 2–3 wk. Use maintenance dose when hematologic '
              'values return to normal.'),
          DoseLine(
            'Maintenance:',
            isHeading: true,
          ),
          DoseLine('IM/deep SC: 100 mCg/mo'),
          DoseLine('Intranasal: 500 mCg in one nostril once weekly'),
          DoseLine('Sublingual: 1000–2000 mCg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in optic nerve atrophy and cobalt sensitivity. May cause '
          'hypokalemia, hypersensitivity (anaphylactic shock and death reported with '
          'parenteral use), pruritus, and vascular thrombosis. Vitamin B₁₂ use may '
          'mask folate deficiency and unmask polycythemia vera. Frequent monitoring '
          'of serum potassium and platelet counts is highly recommended when used '
          'for megaloblastic anemia.',
      'Prolonged use of acid-suppressing medications may reduce cyanocobalamin '
          'oral absorption.',
      'Protect product from light. Some products may contain aluminum and may '
          'accumulate in renal impairment. Oral route of administration is generally '
          'not recommended for pernicious anemia and B₁₂ deficiency due to poor '
          'absorption. IV route of administration is NOT recommended because of a '
          'more rapid elimination. See Chapter 21 for multivitamin preparations.',
    ],
    pregnancyNote: 'Pregnancy category changes to “C” if used in doses greater than '
        'the RDA or if administered by the intranasal route.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 941',
  ),
  // CYCLOPENTOLATE — PDF p. 133 (printed 942)
  DrugEntryV3(
    name: 'CYCLOPENTOLATE',
    brandNames: 'Cyclogyl and generics',
    drugClass: 'Anticholinergic, mydriatic agent',
    iconRow: '',
    formulations: [
      'Ophthalmic solution: 0.5% (15 mL), 1% (2, 5, 15 mL), 2% (2, 5, 15 mL); '
          'may contain benzalkonium chloride',
    ],
    doseSections: [
      DoseSection(
        heading: 'Administer dose approximately 40–50 min prior to '
            'examination/procedure.',
      ),
      DoseSection(
        heading: 'Infant:',
        lines: [
          DoseLine('Use cyclopentolate/phenylephrine (Cyclomydril) due to lower '
              'cyclopentolate concentration and reduced risk of systemic side effects.'),
        ],
      ),
      DoseSection(
        heading: 'Child and adolescent:',
        lines: [
          DoseLine('1 drop of 0.5%–1% solution OU, followed by repeat drop, if necessary, in '
              '5 min. Use 2% solution for heavily pigmented iris.'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('1 drop of 1% solution OU, followed by another drop OU in 5 min. Use 2% '
              'solution for heavily pigmented iris.'),
        ],
      ),
    ],
    remarks: [
      'Do not use in narrow-angle glaucoma. May cause a burning sensation, '
          'behavioral disturbance, tachycardia, and loss of visual accommodation. '
          'Psychotic reactions and behavioral disturbances have been reported in '
          'children. To minimize absorption, apply pressure over nasolacrimal sac '
          'for at least 2 min. CNS and cardiovascular side effects are common with '
          'the 2% solution in children. Avoid feeding infants within 4 hr of dosing '
          'to prevent potential feeding intolerance.',
      'Onset of action: 15–60 min; duration of action: 6–24 hr; complete '
          'recovery of accommodation may take several days for some patients. '
          'Observe patient closely for at least 30 min after dose.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 942',
  ),
  // CYCLOPENTOLATE WITH PHENYLEPHRINE — PDF p. 133 (printed 942)
  DrugEntryV3(
    name: 'CYCLOPENTOLATE WITH PHENYLEPHRINE',
    brandNames: 'Cyclomydril',
    drugClass: 'Anticholinergic/sympathomimetic, mydriatic agent',
    iconRow: '',
    formulations: [
      'Ophthalmic solution: 0.2% cyclopentolate and 1% phenylephrine (2, 5 mL); '
          'contains 0.1% benzalkonium chloride, EDTA, and boric acid',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate (administer dose approximately 40–50 min prior to '
            'examination/procedure; see remarks):',
        lines: [
          DoseLine('1 drop OU Q5–10 min; max. dose: 3 drops per eye'),
        ],
      ),
      DoseSection(
        heading: 'Infant, child, and adolescent (administer dose at least 15 min prior '
            'to examination; see remarks):',
        lines: [
          DoseLine('1 drop OU Q5–10 min PRN'),
        ],
      ),
    ],
    remarks: [
      'Used to induce mydriasis. See Cyclopentolate for additional remarks.',
      'Onset of action: 15–60 min. Duration of action: 4–12 hr.',
      'Apply pressure over the nasolacrimal sac for 2–3 min after administration '
          'to minimize systemic absorption.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 942',
  ),
  // CYCLOSPORINE, CYCLOSPORINE MICROEMULSION, CYCLOSPORINE MODIFIED — PDF p. 133–135 (printed 942–944)
  DrugEntryV3(
    name: 'CYCLOSPORINE, CYCLOSPORINE MICROEMULSION, CYCLOSPORINE MODIFIED',
    brandNames: 'Sandimmune, Gengraf, Neoral, Restasis, Restasis MultiDose, '
        'Verkazia, Vevye, Cequa, and generics',
    drugClass: 'Immunosuppressant',
    iconRow: '',
    formulations: [
      'CYCLOSPORINE (non-modified):',
      'Injection (Sandimmune): 50 mg/mL (5 mL); contains 32.9% alcohol and 650 '
          'mg/mL polyoxyethylated castor oil (Cremophor EL)',
      'Caps (Sandimmune and generics): 25, 100 mg; contains 12.7% alcohol',
      'CYCLOSPORINE MICROEMULSION (Neoral):',
      'Caps: 25, 100 mg',
      'Oral solution: 100 mg/mL (50 mL)',
      'All Neoral products contain 11.9% alcohol and propylene glycol.',
      'CYCLOSPORINE MODIFIED (Gengraf and generics):',
      'Caps: 25, 100 mg; contains 12.8% alcohol and propylene glycol',
      'Oral solution: 100 mg/mL (50 mL); contains propylene glycol',
      'Ophthalmic emulsion:',
      'Restasis and generics: 0.05% (0.4 mL as 30 or 60 single-use vials/box); '
          'preservative free and contains polysorbate 80',
      'Restasis MultiDose: 0.05% (5.5 mL); contains polysorbate 80',
      'Verkazia: 0.1% (0.3 mL as 5 or 120 single-use vials/box); preservative '
          'free and contains poloxamer 188',
      'Ophthalmic solution/drops:',
      'Cequa: 0.09% (0.25 mL in boxes of 60s); preservative free and contains '
          'Cremophor EL',
      'Vevye: 0.1% (2 mL); contains perfluororbutylpentane and ethanol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Solid organ transplantation rejection prophylaxis: Neoral '
            'manufacturer recommends a 1:1 conversion ratio with Sandimmune. '
            'Because of its better absorption, lower doses of Neoral and Gengraf '
            'may be required. Exact dosing will vary depending on transplant type.',
        lines: [
          DoseLine('Oral: 15 mg/kg/24 hr as a single dose given 4–12 hr pre-transplantation; '
              'give same daily dose ÷ Q12–24 hr for 1–2 wk post-transplantation, then '
              'reduce by 5% per week to 3–10 mg/kg/24 hr ÷ Q12–24 hr'),
          DoseLine('IV: 5–6 mg/kg/24 hr as a single dose given 4–12 hr pre-transplantation; '
              'administer over 2–6 hr; give same daily dose post-transplantation until '
              'patient able to tolerate oral form'),
        ],
      ),
      DoseSection(
        heading: 'Ophthalmic:',
        lines: [
          DoseLine(
            'Keratoconjunctivitis sicca:',
            isHeading: true,
          ),
          DoseLine(
            'Ophthalmic emulsion (0.05%; Restasis and generics):',
            isHeading: true,
          ),
          DoseLine('≥16 yr and adult: Instill 1 drop onto affected eye(s) Q12 hr.'),
          DoseLine(
            'Ophthalmic solution (0.09%; Cequa):',
            isHeading: true,
          ),
          DoseLine('≥18 yr: Instill 1 drop onto affected eye(s) Q12 hr.'),
          DoseLine(
            'Severe vernal keratoconjunctivitis:',
            isHeading: true,
          ),
          DoseLine(
            'Ophthalmic emulsion:',
            isHeading: true,
          ),
          DoseLine(
            'Verkazia (0.1%):',
            isHeading: true,
          ),
          DoseLine('≥4 yr and adult: Instill 1 drop onto affected eye(s) QID until resolution.'),
          DoseLine(
            'Restasis and generics (0.05%; limited data in children <14 yr old):',
            isHeading: true,
          ),
          DoseLine('≥5 yr–adult: Instill 1 drop onto affected eye(s) QID.'),
        ],
      ),
    ],
    remarks: [
      'May cause nephrotoxicity, hepatotoxicity, hypomagnesemia, hyperkalemia, '
          'hyperuricemia, hypertension, hirsutism, acne, GI symptoms, tremor, '
          'leukopenia, sinusitis, gingival hyperplasia, and headache. '
          'Encephalopathy, convulsions, lower extremity pain, vision and movement '
          'disturbances, and impaired consciousness have been reported, especially '
          'in liver transplant patients. Psoriasis patients previously treated with '
          'PUVA and, to a lesser extent, methotrexate or other immunosuppressive '
          'agents, UVB, coal tar, or radiation therapy are at increased risk for '
          'skin malignancies when taking Neoral or Gengraf.',
      'Opportunistic infections and activation of latent viral infections have '
          'been reported.',
      'BK virus–associated nephropathy has been observed in renal transplant '
          'patients.',
      'Use caution with concomitant use of other nephrotoxic drugs (e.g., '
          'amphotericin B, aminoglycosides, nonsteroidal anti-inflammatory drugs, '
          'and tacrolimus).',
      'Plasma concentrations increased with the use of boceprevir, telaprevir, '
          'fluconazole, ketoconazole, itraconazole, erythromycin, clarithromycin, '
          'voriconazole, nefazodone, diltiazem, verapamil, nicardipine, carvedilol, '
          'and corticosteroids. Plasma concentrations decreased with the use of '
          'carbamazepine, nafcillin, rifampin, oxcarbazepine, bosentan, '
          'phenobarbital, octreotide, and phenytoin. May increase bosentan, '
          'dabigatran, methotrexate, repaglinide, and anthracycline antibiotics '
          '(e.g., doxorubicin, mitoxantrone, daunorubicin) levels/effects/toxicity. '
          'May decrease mycophenolate levels/effects by inhibiting the enterohepatic '
          'circulation of mycophenolic acid. Use with nifedipine may result in '
          'gingival hyperplasia. Cyclosporine is a substrate and inhibitor for '
          'cytochrome P-450 3A4 and P-glycoprotein.',
      'Children may require dosages 2–3 times higher than adults. Plasma '
          'half-life 6–24 hr.',
      'Monitor trough levels (just prior to a dose at steady state). Steady '
          'state is generally achieved after 3–5 days of continuous dosing. '
          'Interpretation will vary based on treatment protocol and assay '
          'methodology (RIA monoclonal vs. RIA polyclonal vs. HPLC), as well as '
          'whole blood vs. serum sample. Additional monitoring and dosage '
          'adjustments may be necessary in renal and hepatic impairment or when '
          'changing dosage forms.',
      'For ophthalmic use: Ocular burning may occur. Remove contact lens prior '
          'to use; lens may be inserted 15 min after dose administration. May be '
          'used with artificial tears but need to be separated by 15 min from one '
          'another. Vevye product is indicated for dry eye disease in adults.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 942–944',
  ),
  // CYPROHEPTADINE — PDF p. 135–136 (printed 944–945)
  DrugEntryV3(
    name: 'CYPROHEPTADINE',
    brandNames: 'Various generics; previously available as Periactin',
    drugClass: 'Antihistamine',
    iconRow: '',
    formulations: [
      'Tabs: 4 mg',
      'Syrup: 2 mg/5 mL (473 mL); may contain alcohol 5%',
    ],
    doseSections: [
      DoseSection(
        heading: 'Antihistaminic uses:',
        lines: [
          DoseLine('Child: 0.25 mg/kg/24 hr or 8 mg/m²/24 hr PO ÷ Q8–12 hr, or by age:'),
          DoseLine('2–6 yr: 2 mg PO Q8–12 hr; max. dose: 12 mg/24 hr'),
          DoseLine('7–14 yr: 4 mg PO Q8–12 hr; max. dose: 16 mg/24 hr'),
          DoseLine('≥15 yr: 4 mg PO Q8 hr; usual range 12–16 mg/24 hr; max. dose: 0.5 '
              'mg/kg/24 hr'),
          DoseLine('Adult: Start with 12 mg/24 hr PO ÷ TID; dosage range: 12–32 mg/24 hr PO ÷ '
              'TID; max. dose: 0.5 mg/kg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Migraine prophylaxis:',
        lines: [
          DoseLine('0.25–0.4 mg/kg/24 hr PO ÷ BID–TID up to the following max. doses: 3–6 yr: '
              '12 mg/24 hr'),
          DoseLine('7–17 yr: 16 mg/24 hr'),
          DoseLine('Adult: 0.5 mg/kg/24 hr or 32 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Appetite stimulation (see remarks):',
        lines: [
          DoseLine('≥2 yr and adolescent: 0.25 mg/kg/24 hr PO ÷ Q12 hr up to the following '
              'max. dose by age: 2–6 yr: 12 mg/24 hr; 7–14 yr: 16 mg/24 hr; ≥15 yr: 32 '
              'mg/24 hr'),
          DoseLine(
            'Alternative dosing by age:',
            isHeading: true,
          ),
          DoseLine('4–8 yr (limited data): 2 mg PO Q8 hr'),
          DoseLine('>13 yr and adult: Start with 2 mg PO Q6 hr; dose may be gradually '
              'increased to 8 mg Q6 hr over a 3-wk period.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in neonates, patients currently on MAO inhibitors, and '
          'patients suffering from asthma, glaucoma, or GI/GU obstruction. May '
          'produce anticholinergic side effects, including sedation and appetite '
          'stimulation. Consider reducing dosage with hepatic insufficiency. Some '
          'consider avoiding use in lactating mothers as it can interfere with the '
          'lactation process by lowering maternal prolactin levels..',
      'Allow 4–8 wk of continuous therapy for assessing efficacy in migraine '
          'prophylaxis. For use as an appetite stimulant, a dosing cycle of 3 wk on '
          'therapy followed by 1 wk off of therapy may enhance efficacy.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 944–945',
  ),
];
