// =============================================================================
// output/b.dart — Drug Formulary 3.0, letter B
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyB` per file; entries in book order.
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

const List<DrugEntryV3> formularyB = [
  // BACITRACIN ± POLYMYXIN B — PDF p. 72 (printed 881)
  DrugEntryV3(
    name: 'BACITRACIN ± POLYMYXIN B',
    brandNames: 'Various ophthalmic and topical generic products\nIn combination '
        'with polymyxin B: Polycin, FT Double Antibiotic Topical, Polysporin '
        'Topical and others',
    drugClass: 'Antibiotic, topical',
    iconRow: '',
    formulations: [
      'BACITRACIN:',
      'Ophthalmic ointment: 500 units/g (3.5 g); preservative free',
      'Topical ointment (OTC): 500 units/g (1, 14, 15, 28, 30, 454 g)',
      'BACITRACIN IN COMBINATION WITH POLYMYXIN B:',
      'Ophthalmic ointment (Polycin and generics): 500 units bacitracin +10,000 '
          'units polymyxin B/g (3.5 g)',
      'Topical ointment (OTC): 500 units bacitracin +10,000 units polymyxin B/g '
          '(15, 30 g)',
    ],
    doseSections: [
      DoseSection(
        heading: 'BACITRACIN:',
      ),
      DoseSection(
        heading: 'Child and adult:',
        lines: [
          DoseLine('Topical: Apply to affected area once daily–TID.'),
          DoseLine('Ophthalmic: Apply 0.25- to 0.5-inch ribbon into the conjunctival sac of '
              'the infected eye(s) Q3–12 hr; frequency depends on severity of infection. '
              'Administer Q3–4 hr × 7–10 days for mild/moderate infections.'),
        ],
      ),
      DoseSection(
        heading: 'BACITRACIN + POLYMYXIN B:',
      ),
      DoseSection(
        heading: 'Child and adult:',
        lines: [
          DoseLine('Topical: Apply ointment to affected area once daily–TID.'),
          DoseLine('Ophthalmic: Apply 0.25- to 0.5-inch ribbon into the conjunctival sac of '
              'the infected eye(s) Q3–12 hr; frequency depends on severity of infection. '
              'Administer Q3–4 hr × 7–10 days for mild/moderate infections.'),
        ],
      ),
    ],
    remarks: [
      'Hypersensitivity reactions to bacitracin and/or polymyxin B can occur. Do '
          'not use topical ointment for the eyes or for a duration of >7 days. Side '
          'effects may include rash, itching, burning, and edema.',
      'Ophthalmic dosage form may cause temporary blurred vision and retard '
          'corneal healing. For ophthalmic use, wash hands before use and avoid '
          'contact of tube tip with skin or eye.',
      'For neomycin-containing products, see Neomycin/Polymyxin B/± Bacitracin',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 881',
  ),
  // BACLOFEN — PDF p. 72–74 (printed 881–883)
  DrugEntryV3(
    name: 'BACLOFEN',
    brandNames: 'Lioresal, Gablofen, Lyvispah, Ozobax DS, Fleqsuvy, and generics',
    drugClass: 'Centrally acting skeletal muscle relaxant',
    iconRow: '',
    formulations: [
      'Tabs: 5, 10, 15, 20 mg',
      'Oral granules (Lyvispah): 5, 10, 20 mg (90 packets); contains saccharin',
      'Oral suspension (see remarks): 5, 10 mg/mL',
      'Fleqsuvy and generics: 5 mg/mL (120, 250, 300 mL); contains propylene '
          'glycol and sodium benzoate',
      'Oral solution:',
      'Generics: 1 mg/mL (473 mL); may contain parabens',
      'Ozobax DS and generics: 2 mg/mL (237, 473 mL); contains parabens',
      'Intrathecal injection:',
      'Gablofen: 50 mCg/mL (1 mL), 0.5 mg/mL (20 mL), 1 mg/mL (20 mL), 2 mg/mL '
          '(20 mL); preservative free',
      'Lioresal: 50 mCg/mL (1 mL), 0.5 mg/mL (20 mL), 2 mg/mL (5, 20 mL); '
          'preservative free',
      'Generics: 0.5 mg/mL (20 mL), 1 mg/mL (20 mL), 2 mg/mL (20 mL); '
          'preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Oral: Dosage increments, if tolerated, are made at 3-day intervals '
            'until desired effect or max. dose is achieved.',
        lines: [
          DoseLine('Initiate first dosage level at QHS, followed by Q12 hr and then Q8 hr. '
              'Dosage increments are made by first increasing the QHS dosage, followed '
              'by the morning dosage and then the remaining mid-day dosage.'),
          DoseLine(
            'Child (PO; see remarks for additional maintenance dosage range):',
            isHeading: true,
          ),
          DoseLine('<20 kg: Start at 2.5 mg QHS, increase in 2.5-mg increments, if needed, up '
              'to the recommended max. dose, below.'),
          DoseLine('≥20–50 kg: Start at 5 mg QHS, increase in 5-mg increments, if needed, up '
              'to the recommended max. dose, below.'),
          DoseLine('>50 kg: Start at 10 mg QHS, increase in 10-mg increments, if needed, up '
              'to the recommended max. dose, below.'),
          DoseLine(
            'Recommended max. PO dose:',
            isHeading: true,
          ),
          DoseLine('2 yr–<8 yr: 60 mg/24 hr'),
          DoseLine('8–16 yr: 80 mg/24 hr'),
          DoseLine('>16 yr: 120 mg/24 hr'),
          DoseLine(
            'Adult (PO):',
            isHeading: true,
          ),
          DoseLine('Start at 5 mg TID; increase in 5-mg increments, if needed, up to a max. '
              'of 80 mg/24 hr.'),
        ],
      ),
      DoseSection(
        heading: 'Intrathecal continuous infusion maintenance therapy (not well '
            'established):',
        lines: [
          DoseLine('<12 yr: Average dose of 274 mCg/24 hr (range: 24–1199 mCg/24 hr) has been '
              'reported.'),
          DoseLine('≥12 yr and adult: Most required 300–800 mCg/24 hr (range: 12–2003 mCg/24 '
              'hr with limited experience at doses >1000 mCg/24 hr).'),
        ],
      ),
    ],
    remarks: [
      'Avoid abrupt withdrawal of drug (withdrawal symptoms: agitation, '
          'confusion, hallucination, high fever, hypertension, insomnia, and muscle '
          'rigidity). Use with caution in patients with seizure disorder or impaired '
          'renal function. Approximately 70%–80% of the drug is excreted in the '
          'urine unchanged. Administer oral doses with food or milk.',
      'Adverse effects: drowsiness, fatigue, nausea, vertigo, psychiatric '
          'disturbances, rash, urinary frequency, and hypotonia. Avoid abrupt '
          'withdrawal of intrathecal therapy to prevent potential life-threatening '
          'events (rhabdomyolysis, multiple organ system failure) and death.',
      'Cases of intrathecal mass at the tip of the implanted catheter leading to '
          'withdrawal symptoms have been reported. Inadvertent subcutaneous '
          'injection may occur with improper access of the reservoir refill septum '
          'and may result in an overdose. Sterile techniques must be used with '
          'intrathecal use, accounting for all nonsterile external surfaces.',
      'Usual maintenance oral dosage range observed from a collection of smaller '
          'prospective and retrospective studies suggests the following (see dosage '
          'section for initial dose titration):',
      '<2 yr: 10–20 mg/24 hr ÷ Q8 hr to a maximum of 40 mg/24 hr',
      '2–7 yr: 20–40 mg/24 hr ÷ Q8 hr to a maximum of 60 mg/24 hr',
      '≥8 yr: 30–40 mg/24 hr ÷ Q8 hr to a maximum of 200 mg/24 hr',
      'Caution: Multiple concentrations of the oral liquid dosage form exist '
          '(e.g., 1, 5, 10 mg/mL). This is important to consider when completing the '
          'medication reconciliation process for needing to determine the dosage in '
          'milligrams and NOT the dosage volume that may result in an under- or '
          'overdose when using the incorrect medication concentration.',
      'Oral granules dosage form may be administered directly into the mouth or '
          'mixed into liquids or soft foods (e.g., applesauce, yogurt, or pudding). '
          'Recommended enteral feeding tube size for administering granules: '
          'nasogastric (≥8 Fr), gastrostomy (≥12 Fr), percutaneous endoscopic '
          'gastrostomy (≥14 Fr), and gastrojejunostomy (≥16 Fr); see product '
          'information for additional details with feeding tube administration.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 881–883',
  ),
  // BECLOMETHASONE DIPROPIONATE — PDF p. 74–75 (printed 883–884)
  DrugEntryV3(
    name: 'BECLOMETHASONE DIPROPIONATE',
    brandNames: 'QVAR Redihaler, Qnasl Children’s, Qnasl',
    drugClass: 'Corticosteroid',
    iconRow: '',
    formulations: [
      'Breath-activated inhalation aerosol, oral:',
      'QVAR Redihaler: 40 mCg/inhalation (10.6 g provides 120 inhalations), 80 '
          'mCg/inhalation (10.6 g provides 120 inhalations)',
      'Inhalation aerosol, nasal:',
      'Qnasl Children’s: 40 mCg/inhalation (6.8 g provides 60 metered doses)',
      'Qnasl: 80 mCg/inhalation (10.6 g provides 120 metered doses)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Oral inhalation (QVAR Redihaler) (patient requires an inspiratory '
            'flow rate of approximately 30 L/min for optimal drug delivery; see '
            'remarks):',
        lines: [
          DoseLine(
            'Asthma maintenance therapy:',
            isHeading: true,
          ),
          DoseLine('4–11 yr: Start at 40 mCg BID. If response is inadequate after 2 wk, may '
              'increase dose to the recommended maximum dose of 80 mCg BID.'),
          DoseLine(
            '≥12 yr and adult:',
            isHeading: true,
          ),
          DoseLine('Corticosteroid naïve: Start at 40–80 mCg BID; max. dose: 320 mCg BID'),
          DoseLine('Previous corticosteroid use: Start at 40–160 mCg BID; max. dose: 320 mCg '
              'BID'),
        ],
      ),
      DoseSection(
        heading: 'Nasal inhalation for allergic rhinitis:',
        lines: [
          DoseLine(
            'Qnasl Children’s:',
            isHeading: true,
          ),
          DoseLine('4–11 yr: 1 spray (40 mCg) each nostril once daily; max. dose: 2 sprays '
              'total (80 mCg)/24 hr'),
          DoseLine(
            'Qnasl:',
            isHeading: true,
          ),
          DoseLine('≥12 yr and adult: 2 sprays (160 mCg) each nostril once daily; max. dose: '
              '4 sprays (320 mCg)/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Equivalent Inhalation Dosages for Fluticasone and Beclomethasone',
        table: DoseTable(
          headers: ['Fluticasone MDI (Flovent HFA)', 'Fluticasone DPI (Flovent Diskus)', 'Beclomethasone BAI (QVAR Redihaler)'],
          rows: [
            DoseTableRow(['44 mCg: 2 puffs BID', '50 mCg: 2 inhalations BID', '40 mCg: 1 puff BID']),
            DoseTableRow(['110 mCg: 2 puffs BID', '100 mCg: 2 inhalations BID', '40 mCg: 2 puffs BID']),
            DoseTableRow(['220 mCg: 2 puffs BID', '250 mCg: 2 inhalations BID', '80 mCg: 2 puffs BID']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('BAI, Breath-activated inhaler; DPI, dry powder inhaler; MDI, metered-dose '
              'inhaler.'),
        ],
      ),
    ],
    remarks: [
      'Not recommended for use in children <4 yr because of unknown safety and '
          'efficacy. Dose should be titrated to lowest effective dose. Avoid using '
          'higher-than-recommended doses. Avoid use of nasal dosage form in cases of '
          'recent nasal ulcers, nasal surgery, or nasal trauma. Nasal septal '
          'perforation has been reported with nasal product. Psychiatric and '
          'behavioral changes have been reported in children with the oral '
          'inhalation product. Routinely monitor growth of pediatric patients with '
          'chronic use of all dosage forms.',
      'For mild asthma exacerbation in patients with mild/moderate disease, no '
          'history of life-threatening exacerbations, and a good asthma '
          'self-management plan, limited data in adolescents and adults suggest a '
          'temporary quadrupling of the maintenance dosage when asthma control '
          'starts to deteriorate. Revert back to baseline maintenance dose after '
          'symptoms stabilize or up to a maximum of 14 days of the quadrupled dose, '
          'whichever comes first. DO NOT use this management strategy for children '
          '<12 years of age due to the lack of efficacy and increased risk for '
          'decreasing linear growth.',
      'When converting from fluticasone to beclomethasone for oral inhalation '
          'use, consider the following:',
      'Use of cytochrome P-450 3A4 inhibitors (e.g., ketoconazole, erythromycin, '
          'and protease inhibitors) or significant hepatic impairment may increase '
          'systemic exposure of beclomethasone.',
      'Monitor for hypothalamic, pituitary, adrenal, or growth suppression, and '
          'hypercorticism. Patient should rinse mouth and gargle with water after '
          'oral inhalation; may cause thrush.',
      'QVAR Redihaler is a breath-activated inhaler device and requires the '
          'patient to have a minimum inspiratory flow rate of 30 L/min for proper '
          'dose activation, and does not require priming. Do not shake the Redihaler '
          'device with the cap open and do not use it with a tube spacer or volume '
          'holding chamber.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 883–884',
  ),
  // BENZOYL PEROXIDE — PDF p. 75–76 (printed 884–885)
  DrugEntryV3(
    name: 'BENZOYL PEROXIDE',
    brandNames: 'Acne Medication, Benzac, PanOxyl, and many other products including '
        'generics',
    drugClass: 'Topical acne product',
    iconRow: '',
    formulations: [
      'Liquid wash [OTC]: 2.5% (240 mL), 5% (120, 150, 240 mL), 7% (480 mL), 10% '
          '(120, 150, 240 mL)',
      'Liquid cream wash [OTC]: 4% (170 g), 7% (180 g)',
      'Bar [OTC]: 10% (113 g)',
      'Lotion [OTC]: 5% (30 mL), 8% (297 g), 10% (30 mL)',
      'Cream [OTC]: 5% (3, 30 g), 10% (30 g)',
      'Gel [OTC]: 2.5% (60 g), 5% (42.5, 60, 90 g), 6.5% (113 g), 8% (113 g), '
          '10% (42.5, 60, 90 g)',
      'NOTE: Some preparations may contain alcohol and come in combination packs '
          'of cleansers and creams at various strengths.',
      'Combination product with erythromycin (Benzamycin and generics):',
      'Gel: 3% (30 mg) erythromycin and 5% (50 mg) benzoyl peroxide per g (23.3, '
          '46 g); some preparations may contain 20% alcohol.',
      'Combination product with clindamycin:',
      'Gel: 1% (10 mg) clindamycin and 5% (50 mg) benzoyl peroxide per g (25, '
          '35, 50 g); 1.3% (12 mg) clindamycin and 2.5% (25 mg) benzoyl peroxide per '
          'g (50 g); 1.2% (12 mg) clindamycin and 5% (50 mg) benzoyl peroxide per g '
          '(45 g); some preparations may contain methylparaben.',
      'Acanya: 1.2% (12 mg) clindamycin and 2.5% (25 mg) benzoyl peroxide per g '
          '(50 g); contains propylene glycol',
      'Neuac: 1.2% (12 mg) clindamycin and 5% (50 mg) benzoyl peroxide per g (45 '
          'g); contains parabens',
      'Onexton: 1.2% (12 mg) clindamycin and 3.75% (37.5 mg) benzoyl peroxide '
          'per g (3.5, 50 g); contains propylene glycol',
      'Combination product with adapalene: See Adapalene ± Benzoyl Peroxide',
    ],
    doseSections: [
      DoseSection(
        heading: 'Acne (child ≥12 yr and adult, see remarks):',
        lines: [
          DoseLine('Cleansers (liquid wash, or bar): Wet affected area prior to application. '
              'Apply and wash once daily–BID; rinse thoroughly, and pat dry. Modify dose '
              'frequency or concentration to control the amount of drying or peeling.'),
          DoseLine('Lotion, cream, or gel: Cleanse skin, and apply small amounts over '
              'affected areas once daily initially; increase frequency to BID–TID, if '
              'needed. Modify dose frequency or concentration to control drying or '
              'peeling.'),
          DoseLine(
            'Combination products (these products have not been evaluated beyond 12 '
                'weeks of use):',
            isHeading: true,
          ),
          DoseLine('Generics: Apply once daily to affected areas after washing and drying '
              'skin. The 1% (10 mg) clindamycin and 5% (50 mg) benzoyl peroxide per g '
              'product may be administered BID (morning and evening).'),
          DoseLine('Acanya and Onexton: Apply pea-sized amount to affected areas once daily '
              'after washing and drying skin.'),
          DoseLine('Neuac: Apply a thin layer QHS to affected areas after washing and drying '
              'skin.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in known history of hypersensitivity to product’s '
          'components (benzoyl peroxide, clindamycin, or erythromycin). Avoid '
          'contact with mucous membranes and eyes. May cause skin irritation, '
          'stinging, dryness, peeling, erythema, edema, and contact dermatitis. '
          'Anaphylaxis has been reported with products containing clindamycin and '
          'benzoyl peroxide.',
      'Concomitant topical acne therapy should be used with caution due to '
          'possible cumulative irritancy effect. Concurrent use with tretinoin '
          '(Retin-A) will increase risk of skin irritation. Products containing '
          'clindamycin and erythromycin should not be used in combination.',
      'Any single application resulting in excessive stinging or burning may be '
          'removed with mild soap and water. Lotion, cream, and gel dosage forms '
          'should be applied to dry skin.',
      'Data are limited for use <12 yr of age.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 884–885',
  ),
  // BENZTROPINE MESYLATE — PDF p. 76–77 (printed 885–886)
  DrugEntryV3(
    name: 'BENZTROPINE MESYLATE',
    brandNames: 'Generics; previously available as Cogentin',
    drugClass: 'Anticholinergic agent, drug-induced dystonic reaction antidote, '
        'anti-Parkinson agent',
    iconRow: '',
    formulations: [
      'Injection: 1 mg/mL (2 mL)',
      'Tabs: 0.5, 1, 2 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Drug-induced extrapyramidal symptoms (PO/IM/IV; see remarks):',
        lines: [
          DoseLine('>3 yr: 0.02–0.05 mg/kg/dose once daily–BID'),
          DoseLine('Adult: 1–4 mg/dose once daily–BID'),
        ],
      ),
      DoseSection(
        heading: 'Acute dystonic reactions (IM/IV; see remarks):',
        lines: [
          DoseLine('Child: 0.02 mg/kg/dose (max. dose: 1 mg) × 1'),
          DoseLine('Adult: 1–2 mg/dose × 1'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in myasthenia gravis, GI/GU obstruction, untreated '
          'narrow-angle glaucoma, and peptic ulcer. Use IV route only when PO and IM '
          'routes are not feasible. May cause anticholinergic side effects, '
          'especially constipation and dry mouth. Drug interactions include: '
          'potentiate CNS depressant effects when used with CNS depressants; enhance '
          'CNS side effects of amantadine; and inhibit the response of neuroleptics. '
          'This medication has not been formally assigned a pregnancy category by '
          'the FDA. The Australian pregnancy ratings have deemed use in pregnancy to '
          'a limited number of women without an increase in frequency of '
          'malformation or other direct/indirect harmful effects.',
      'Onset of action: 15 min for IV/IM and 1 hr for PO.',
      'Oral doses should be administered with food to decrease GI upset.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 885–886',
  ),
  // BERACTANT — PDF p. 77 (printed 886)  [cross-reference]
  DrugEntryV3(
    name: 'BERACTANT',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Surfactant, pulmonary',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 886',
  ),
  // BETAMETHASONE — PDF p. 77–78 (printed 886–887)
  DrugEntryV3(
    name: 'BETAMETHASONE',
    brandNames: 'Injection: Celestone Soluspan and generics\nTopical: Diprolene, '
        'Sernivo, and generics',
    drugClass: 'Corticosteroid',
    iconRow: '',
    formulations: [
      'Na Phosphate and Acetate:',
      'Injection suspension (Celestone Soluspan and generics): 6 mg/mL (3 mg/mL '
          'Na phosphate +3 mg/mL betamethasone acetate) (5 mL); may contain '
          'benzalkonium chloride and EDTA',
      'Dipropionate:',
      'Topical cream: 0.05% (15, 45 g)',
      'Topical emulsion (Sernivo): 0.05% (120 mL); contains parabens',
      'Topical lotion: 0.05% (60 mL); may contain 46.8% alcohol and propylene '
          'glycol',
      'Topical ointment: 0.05% (15, 45 g)',
      'Valerate:',
      'Topical cream: 0.1% (15, 45 g)',
      'Topical foam: 1.2 mg/g (50, 100 g); may contain 60.4% ethanol, cetyl '
          'alcohol, stearyl alcohol, and propylene glycol',
      'Topical lotion: 0.1% (60 mL); may contain 47.5% isopropyl alcohol',
      'Topical ointment: 0.1% (15, 45 g)',
      'Dipropionate augmented:',
      'Topical cream: 0.05% (15, 50 g); contains propylene glycol',
      'Topical gel: 0.05% (15, 50 g); contains propylene glycol',
      'Topical lotion: 0.05% (30, 60 mL); contains 30% isopropyl alcohol',
      'Topical ointment (Diprolene and generics): 0.05% (15, 45, 50 g); contains '
          'propylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'All dosages should be adjusted based on patient response and severity '
            'of condition (see remarks).',
      ),
      DoseSection(
        heading: 'Anti-inflammatory:',
        lines: [
          DoseLine('Child IM: 0.0175–0.125 mg/kg/24 hr or 0.5–7.5 mg/m²/24 hr ÷ Q6–12 hr'),
          DoseLine('Adolescent and adult IM: 0.6–9 mg/24 hr ÷ Q12–24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Topical (use smallest amount for shortest period of time to avoid '
            'adrenal suppression, and reassess diagnosis if no improvement is '
            'achieved after 2 wk; see remarks):',
        lines: [
          DoseLine(
            'Valerate and dipropionate forms:',
            isHeading: true,
          ),
          DoseLine('Child and adult: Apply to affected areas once daily–BID.'),
          DoseLine(
            'Dipropionate augmented forms (see remarks):',
            isHeading: true,
          ),
          DoseLine('≥13 yr–adult: Apply to affected areas once daily–BID.'),
          DoseLine('Max. dose: 14 days and the following specific dosages for maximum amount:'),
          DoseLine('Cream, ointment, and gel: 50 g/wk'),
          DoseLine('Lotion: 50 mL/wk'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in hypothyroidism, cirrhosis, ulcerative colitis, and '
          'history of allergic reactions to corticosteroids. See Chapter 8 for '
          'relative steroid potencies and doses based on body surface area. '
          'Betamethasone is inadequate when used alone for adrenocortical '
          'insufficiency because of its minimal mineralocorticoid properties. Like '
          'all steroids, may cause hypertension, pseudotumor cerebri, acne, Cushing '
          'syndrome, adrenal axis suppression, GI bleeding, hyperglycemia, and '
          'osteoporosis. Pheochromocytoma crisis and hepatitis B reactivation have '
          'been reported.',
      'Betamethasone is a substrate for cytochrome P-450 3A4, and use with a '
          'strong inhibitor (e.g., ketoconazole and itraconazole) may lead to '
          'increased exposure and side effects of betamethasone.',
      'Na phosphate and acetate injectable suspension recommended for IM, '
          'intra-articular, intrasynovial, intralesional, and soft tissue use only; '
          'but not for IV use. Topical betamethasone dipropionate augmented '
          '(Diprolene and Diprolene AF) is not recommended in children ≤12 yr owing '
          'to the higher risk for adrenal suppression.',
      'Injectable IM dosage form is used in premature labor to stimulate fetal '
          'lung maturation. Neonatal hypoglycemia has been reported with antenatal '
          'use when administered close to time of delivery.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 886–887',
  ),
  // BICITRA — PDF p. 78 (printed 887)  [cross-reference]
  DrugEntryV3(
    name: 'BICITRA',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Citrate Mixtures',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 887',
  ),
  // BISACODYL — PDF p. 78–79 (printed 887–888)
  DrugEntryV3(
    name: 'BISACODYL',
    brandNames: 'Dulcolax, Bisacodyl EC, Fleet Bisacodyl, and various other names '
        'including generics',
    drugClass: 'Laxative, stimulant',
    iconRow: '',
    formulations: [
      'Tabs (enteric coated) [OTC]: 5 mg',
      'Suppository [OTC]: 10 mg',
      'Enema (Fleet Bisacodyl) [OTC]: 10 mg/30 mL (37.5 mL)',
      'Delayed-release tabs [OTC]: 5 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Oral (administered 6 hr before desired effect):',
        lines: [
          DoseLine('Child (3–10 yr): 5 mg once daily'),
          DoseLine('>10 yr and adolescent: 5–10 mg once daily'),
          DoseLine('Adult: 5–15 mg once daily'),
        ],
      ),
      DoseSection(
        heading: 'Rectal suppository (see remarks):',
        lines: [
          DoseLine('2–10 yr: 5 mg once daily'),
          DoseLine('>10 yr and adolescent: 5–10 mg once daily'),
          DoseLine('Adult: 10 mg once daily'),
        ],
      ),
      DoseSection(
        heading: 'Rectal enema (as a single dose):',
        lines: [
          DoseLine('2–10 yr: 5 mg (15 mL) × 1'),
          DoseLine('>10–18 yr: 5–10 mg (15–30 mL) × 1'),
          DoseLine('Adult: 10 mg (30 mL) × 1'),
        ],
      ),
    ],
    remarks: [
      'Do not use in newborn period. Instruct patient/parent that tablets should '
          'be swallowed whole, not chewed or crushed; not to be given within 1 hr of '
          'antacids or milk. May cause abdominal cramps, nausea, vomiting, and '
          'rectal irritation. Oral usually effective within 6–10 hr; rectal usually '
          'effective within 15–60 min.',
      'Antacids may decrease the effect of bisacodyl and may cause the premature '
          'release of the delayed-release formulation prior to reaching the large '
          'intestine. When used, suppository should be retained in the rectum for '
          '15–20 min.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 887–888',
  ),
  // BISMUTH SUBSALICYLATE — PDF p. 79 (printed 888)
  DrugEntryV3(
    name: 'BISMUTH SUBSALICYLATE',
    brandNames: 'Pepto-Bismol, Pink Bismuth, Stomach Relief, Stomach Relief Extra '
        'Strength, and many others including generics (see remarks)',
    drugClass: 'Antidiarrheal, gastrointestinal ulcer agent',
    iconRow: '',
    formulations: [
      'Liquid [OTC]:',
      'Pepto-Bismol, Bismatrol, Pink Bismuth, Stomach Relief, and others: 262 '
          'mg/15 mL (240, 360, 480 mL)',
      'Stomach Relief Extra Strength: 525 mg/15 mL (237 mL)',
      'Chewable tabs [OTC]: 262 mg; may contain aspartame',
      'Contains 102 mg salicylate per 262-mg tablet; or 129 mg salicylate per 15 '
          'mL of the 262 mg/15 mL liquid',
    ],
    doseSections: [
      DoseSection(
        heading: 'Travelers’ diarrhea:',
        lines: [
          DoseLine('Give following dose Q30 min to 1 hr PRN up to a max. dose of 8 doses/24 '
              'hr:'),
          DoseLine('3–5 yr: 87.3 mg (1/3 tablet or 5 mL of 262 mg/15 mL)'),
          DoseLine('6–8 yr: 174.7 mg (2/3 tablet or 10 mL of 262 mg/15 mL)'),
          DoseLine('9–11 yr: 262 mg (1 tablet or 15 mL of 262 mg/15 mL)'),
          DoseLine('≥12 yr–adult: 524 mg (2 tablets or 30 mL of 262 mg/15 mL)'),
        ],
      ),
      DoseSection(
        heading: 'Helicobacter pylori gastric infection',
        lines: [
          DoseLine('(as part of a 3- or 4-drug combination therapy; doses not well '
              'established for children):'),
          DoseLine('Child: 8 mg/kg/24 hr PO ÷ BID × 10–14 days, or 262 mg PO QID × 7–14 days '
              'has been reported.'),
          DoseLine('Adult: 300 mg PO QID × 10–14 days'),
        ],
      ),
    ],
    remarks: [
      'Generally not recommended in children <16 yr with chickenpox or flu-like '
          'symptoms (risk for Reye syndrome); in combination with other nonsteroidal '
          'anti-inflammatory drugs, anticoagulants, or oral antidiabetic agents; or '
          'in severe renal failure. Use with caution in bleeding disorders, renal '
          'dysfunction, gastritis, and gout. May cause darkening of tongue and/or '
          'black stools, GI upset, impaction, and decreased platelet aggregation.',
      'Drug combination appears to have antisecretory and antimicrobial effects '
          'with some anti-inflammatory effects. Absorption of bismuth is negligible, '
          'whereas approximately 80% of the salicylate is absorbed. Decreases '
          'absorption of tetracycline. The salicylate component may increase the '
          'effects/toxicity of antiplatelet, anticoagulant, and blood '
          'glucose–lowering medications and increase nephrotoxicity risk when used '
          'with ACE inhibitors.',
      'DO NOT use Children’s Pepto (calcium carbonate) because it does not '
          'contain bismuth subsalicylate. Avoid use in renal failure (see Chapter '
          '32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 888',
  ),
  // BOSENTAN — PDF p. 80–81 (printed 889–890)
  DrugEntryV3(
    name: 'BOSENTAN',
    brandNames: 'Tracleer and generics',
    drugClass: 'Endothelin receptor antagonist',
    iconRow: '',
    formulations: [
      'Tabs: 62.5, 125 mg',
      'Dispersible tabs (to be dissolved in water to make an oral suspension):',
      'Tracleer: 32 mg (scored); contains aspartame',
      'Oral suspension: 6.25 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Pulmonary arterial hypertension (see remarks):',
        lines: [
          DoseLine(
            '2015 AHA/ATS Pediatric Pulmonary Hypertension Guidelines:',
            isHeading: true,
          ),
          DoseLine('<10 kg: Start at 1 mg/kg/dose PO BID, then increase to 2 mg/kg/dose PO '
              'BID.'),
          DoseLine('10–20 kg: Start at 15.625 mg PO BID, then increase to 31.25 mg PO BID.'),
          DoseLine('>20–40 kg: Start at 31.25 mg PO BID, then increase to 62.5 mg PO BID.'),
          DoseLine('>40 kg: Start at 62.5 mg PO BID, then increase to 125 mg PO BID.'),
        ],
      ),
      DoseSection(
        heading: 'Alternative FDA-Labeled Dosing by Age and Weight (PO)',
        table: DoseTable(
          headers: ['Age', 'Weight (kg)', 'Dosage (PO)'],
          rows: [
            DoseTableRow(['3–<12 yr', '4–8', '16 mg BID']),
            DoseTableRow(['', '>8–16', '32 mg BID']),
            DoseTableRow(['', '>16–24', '48 mg BID']),
            DoseTableRow(['', '>24–40', '64 mg BID']),
            DoseTableRow(['≥12 yr', '≤40', '62.5 mg BID']),
            DoseTableRow(['', '>40', '62.5 mg BID × 4 wk, then 125 mg BID']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Dosage Modification for Transaminase Elevation',
        table: DoseTable(
          headers: ['ALT/AST Levels', 'Dosage Adjustment'],
          rows: [
            DoseTableRow(['>3 to ≤5× ULN', 'Reconfirm by another aminotransferase test; if confirmed, modify dosage '
                'regimen (always reassess aminotransferase levels within 3 days and Q2 wk '
                'thereafter to any dosage reintroduction or reduction):\n3–≤12 yr, and >12 '
                'yr and ≤40 kg: Interrupt therapy. If aminotransferase returns to '
                'pretreatment levels, reintroduce with dosage prior to interruption.\n>12 '
                'yr and >40 kg, and adult: Reduce dosage to 62.5 mg PO BID; or interrupt '
                'therapy and monitor aminotransferase levels Q2 wk (if aminotransferase '
                'levels return to pretreatment levels, continue with most recent dosage or '
                '62.5 mg PO BID).']),
            DoseTableRow(['>5 to ≤8× ULN', 'Reconfirm by another aminotransferase test; if confirmed, stop treatment '
                'and monitor aminotransferase at least Q2 wk. Once aminotransferase '
                'returns to pretreatment levels, consider reintroduction of bosentan and '
                'reassess aminotransferase within 3 days and Q2 wk thereafter to any '
                'dosage reintroduction or reduction:\n3–≤12 yr, and >12 yr and ≤40 kg: '
                'Dosage prior to discontinuing >12 yr and >40 kg, and adult: 62.5 mg PO BID']),
            DoseTableRow(['>8× ULN', 'All ages: Discontinue treatment permanently.']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ULN, Upper limit of normal.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in women who are or may become pregnant and with '
          'concurrent use of cyclosporine (increases bosentan concentrations) or '
          'glyburide (increases risk for hepatotoxicity). Due to these risks, '
          'bosentan is available only through the Tracleer REMS program, where '
          'prescribers and pharmacies need to be certified. See '
          'www.BosentanREMSProgram.com or call 1-866-359-2612 for more information.',
      'Baseline and monthly monitoring of serum aminotransferases and bilirubin, '
          'and pregnancy tests for females of reproductive potential (two forms of '
          'birth control required) are required. Use should be avoided in patients '
          'with preexisting hepatic impairment (baseline aminotransferases >3 times '
          'the usual normal limit).',
      'May cause respiratory tract infections, anemia (dose related), edema, '
          'increased liver aminotransferases (see dosage modification; higher '
          'incidence in adults), and pyrexia. Decreased sperm counts, liver '
          'cirrhosis, liver failure, DRESS, thrombocytopenia, and sinusitis have '
          'been reported.',
      'Bosentan is substrate for the cytochrome P-450 2C9 and 3A4 enzymes, and '
          'OATP1B1/SLCO1B1 transporter. It also induces CYP2C9 and 3A4; may decrease '
          'sildenafil levels. Reduces the effectiveness of hormonal contraceptives.',
      'Doses may be administered orally with or without food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 889–890',
  ),
  // BREO ELLIPTA — PDF p. 81 (printed 890)  [cross-reference]
  DrugEntryV3(
    name: 'BREO ELLIPTA',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Fluticasone Furoate + Vilanterol',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 890',
  ),
  // BUDESONIDE — PDF p. 81–83 (printed 890–892)
  DrugEntryV3(
    name: 'BUDESONIDE',
    brandNames: 'Pulmicort Respules, Pulmicort Flexhaler, Eohilia, Tarpeyo, Uceris, '
        'and generics; previously available as Rhinocort Allergy Nasal Spray '
        'and Entocort EC',
    drugClass: 'Corticosteroid',
    iconRow: '',
    formulations: [
      'Nasal spray (generics; previously available as Rhinocort Allergy) [OTC]: '
          '32 mCg/actuation (8.43 mL delivers 120 sprays); may contain disodium EDTA '
          'and polysorbate 80',
      'Nebulized inhalation suspension (Pulmicort Respules and generics): 0.25 '
          'mg/2 mL, 0.5 mg/2 mL, 1 mg/2 mL (30s); may contain disodium EDTA and '
          'polysorbate 80',
      'Oral breath-activated inhalation powder (Pulmicort Flexhaler): 90 '
          'mCg/metered dose (165 mg, delivers 60 doses), 180 mCg/metered dose (225 '
          'mg, delivers 120 doses); contains lactose',
      'Delayed-release capsule (Tarpeyo): 4 mg',
      'Enteric-coated granules in a capsule (generics; previously available as '
          'Entocort EC): 3 mg',
      'Extended-release tablet (Uceris and generics): 9 mg',
      'Oral suspension (Eohilia): 0.2 mg/1 mL (10 mL); contains EDTA, '
          'polysorbate 80, and sodium benzoate',
      'Rectal foam (Uceris): 2 mg per metered dose (33.4 g, delivers 14 doses; 2 '
          'canisters per kit)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Nebulized inhalation suspension (see remarks):',
        lines: [
          DoseLine(
            'Child 1–8 yr:',
            isHeading: true,
          ),
          DoseLine('No prior steroid use: 0.5 mg/24 hr ÷ once daily–BID; max. dose: 0.5 mg/24 '
              'hr'),
          DoseLine('Prior inhaled steroid use: 0.5 mg/24 hr ÷ once daily–BID; max. dose: 1 '
              'mg/24 hr'),
          DoseLine('Prior oral steroid use: 1 mg/24 hr ÷ once daily–BID; max. dose: 1 mg/24 hr'),
          DoseLine(
            'NIH Asthma Guideline 2007 recommendations (divide daily doses once '
                'daily–BID):',
            isHeading: true,
          ),
          DoseLine(
            'Child 0–4 yr:',
            isHeading: true,
          ),
          DoseLine('Low dose: 0.25–0.5 mg/24 hr'),
          DoseLine('Medium dose: >0.5–1 mg/24 hr'),
          DoseLine('High dose: >1 mg/24 hr'),
          DoseLine(
            'Child 5–11 yr:',
            isHeading: true,
          ),
          DoseLine('Low dose: 0.5 mg/24 hr'),
          DoseLine('Medium dose: 1 mg/24 hr'),
          DoseLine('High dose: 2 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Oral inhalation (see remarks):',
        lines: [
          DoseLine(
            'Pulmicort Flexhaler (patient requires an inspiratory flow rate of '
                'approximately 60 L/min for optimal drug delivery):',
            isHeading: true,
          ),
          DoseLine('Child ≥6–17 yr: Start at 180 mCg BID; max. dose: 720 mCg/24 hr.'),
          DoseLine('≥18 yr and adult: Start at 180–360 mCg BID; max. dose: 1440 mCg/24 hr.'),
          DoseLine(
            'NIH Asthma Guideline 2007 recommendations (divide daily doses BID):',
            isHeading: true,
          ),
          DoseLine(
            'Child 5–11 yr:',
            isHeading: true,
          ),
          DoseLine('Low dose: 180–400 mCg/24 hr'),
          DoseLine('Medium dose: >400–800 mCg/24 hr'),
          DoseLine('High dose: >800 mCg/24 hr'),
          DoseLine(
            'Child ≥12 and adolescent:',
            isHeading: true,
          ),
          DoseLine('Low dose: 180–600 mCg/24 hr'),
          DoseLine('Medium dose: >600–1200 mCg/24 hr'),
          DoseLine('High dose: >1200 mCg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Nasal inhalation:',
        lines: [
          DoseLine('≥6 to <12 yr: Start at 1 spray (32 mCg) in each nostril once daily. If '
              'needed, increase to 2 sprays (64 mCg) in each nostril once daily, then '
              'reduce dose back to initial dose when symptoms improve. Max. nasal dose: '
              '128 mCg/24 hr (4 sprays/24 hr).'),
          DoseLine('≥12 yr to adult: Start at 2 sprays (64 mCg) in each nostril once daily. '
              'When symptoms improve, reduce dose to 1 spray (32 mCg) in each nostril '
              'once daily. Usual max. dose is 128 mCg/24 hr (4 sprays/24 hr) but some '
              'may require 256 mCg/24 hr (8 sprays/24 hr) initially with a subsequent '
              'reduced dosage to improve symptoms.'),
        ],
      ),
      DoseSection(
        heading: 'Crohn disease:',
        lines: [
          DoseLine('Child ≥6 yr (see remarks): Data are limited; only the following dosages '
              'have been reported. Additional studies are needed.'),
          DoseLine('Active disease: 9 mg/24 hr PO once daily or ÷ Q8 hr × 7–8 wk'),
          DoseLine('Maintenance of remission: 6 mg PO once daily × 3–4 wk'),
          DoseLine('In addition, a report in 10–19-yr-old children demonstrated higher '
              'remission rates with an induction dose of 12 mg PO once daily × 4 wk, '
              'followed by 9 mg PO once daily × 3 wk, followed by 6 mg PO once daily × 3 '
              'wk.'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Active disease: 9 mg PO QAM × 8 wk; if remission is not achieved, a '
              'second 8-wk course may be given.'),
          DoseLine('Maintenance of remission: 6 mg PO once daily for up to 3 mo. If symptom '
              'control is maintained at 3 mo, taper dosage to compete cessation. '
              'Remission therapy beyond 3 mo has not been shown to provide substantial '
              'clinical benefit.'),
        ],
      ),
      DoseSection(
        heading: 'Ulcerative colitis, induction of remission (Uceris and generics):',
        lines: [
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Extended-release oral tablet: 9 mg PO QAM for up to 8 wk'),
          DoseLine('Rectal foam: 2 mg PR BID × 2 wk followed by 2 mg PR once daily × 4 wk'),
        ],
      ),
    ],
    remarks: [
      'Reduce maintenance dose to as low as possible to control symptoms. May '
          'cause pharyngitis, cough, epistaxis, nasal irritation, and HPA-axis '
          'suppression. Rinse mouth after each use via the oral inhalation route. '
          'Nebulized budesonide has been shown effective in mild to moderate croup '
          'at doses of 2 mg × 1. Ref: N Engl J Med. 1994;331(5):285.',
      'For mild asthma exacerbation in patients with mild/moderate disease, no '
          'history of life-threatening exacerbations, and a good asthma '
          'self-management plan, limited data in adolescents and adults suggest a '
          'temporary quadrupling of the maintenance dosage when asthma control '
          'starts to deteriorate. Revert back to baseline maintenance dose after '
          'symptoms stabilize or up to a maximum of 14 days of the quadrupled dose, '
          'whichever comes first. DO NOT use this management strategy for children '
          '<12 years of age due to the lack of efficacy and increased risk for '
          'decreasing linear growth.',
      'Hypersensitivity reactions, including anaphylaxis, have been reported '
          'with the inhaled route. Anaphylactic reactions, rectal bleeding, '
          'peripheral edema, mood swings, increased blood pressure, rash, and benign '
          'intracranial hypertension have been reported with oral route of '
          'administration. Monitor for hypercorticism and adrenal axis suppression '
          'with the use of oral dosage forms.',
      'Safety and effectiveness for mild/moderate Crohn disease have been '
          'established for children 8–17 yr old weighing ≥25 kg. Safety and efficacy '
          'have NOT been established in pediatric patients for the maintenance of '
          'clinical remission of mild/moderate Crohn disease. Although the reported '
          'safety profile in pediatric Crohn disease is consistent with adults, '
          'there may be increased risk for decreased growth velocity due to higher '
          'systemic absorption of corticosteroids in children with Crohn disease.',
      'Cytochrome P-450 3A4 inhibitors (e.g., ketoconazole, erythromycin, '
          'protease inhibitors) or significant hepatic impairment may increase '
          'systemic exposure of budesonide (inhalation and PO routes).',
      'Onset of action for oral inhalation and nebulized suspension is within 1 '
          'day and 2–8 days, respectively, with peak effects at 1–2 wk and 4–6 wk, '
          'respectively.',
      'For nasal use, onset of action is seen after 1 day with peak effects '
          'after 3–7 days of therapy. Discontinue therapy if no improvement in nasal '
          'symptoms after 3 wk of continuous therapy.',
      'Pulmicort Flexhaler is a breath-activated device that requires the '
          'patient to have an inspiratory flow rate of approximately 60 L/min for '
          'optimal drug delivery.',
    ],
    pregnancyNote: 'Pregnancy category is “B” for inhalation routes of administration '
        'and “C” for the oral and rectal routes. Breastfeeding category is '
        '“2” for inhalation routes and “?” for the rectal route. '
        'Breastfeeding with the oral route of administration may result in '
        'budesonide exposure to the infant up to 10 times higher than that '
        'by the inhalation route. Do not crush or chew the oral capsule '
        'dosage form.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 890–892',
  ),
  // BUDESONIDE AND FORMOTEROL — PDF p. 83–84 (printed 892–893)
  DrugEntryV3(
    name: 'BUDESONIDE AND FORMOTEROL',
    brandNames: 'Symbicort, Breyna, and generics',
    drugClass: 'Corticosteroid and long-acting β₂-adrenergic agonist',
    iconRow: '',
    formulations: [
      'Aerosol inhaler:',
      'Symbicort and generics:',
      '80 mCg budesonide + 4.5 mCg formoterol fumarate dihydrate (6.9 g delivers '
          '60 inhalations, 10.2 g delivers approximately 120 inhalations)',
      '160 mCg budesonide + 4.5 mCg formoterol fumarate dihydrate (6 g delivers '
          '60 inhalations, 10.2 g delivers approximately 120 inhalations)',
      'Breyna:',
      '80 mCg budesonide + 4.5 mCg formoterol fumarate dihydrate (10.3 g '
          'delivers approximately 120 inhalations)',
      '160 mCg budesonide + 4.5 mCg formoterol fumarate dihydrate (10.3 g '
          'delivers approximately 120 inhalations)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Asthma maintenance therapy:',
        lines: [
          DoseLine('5–11 yr (NIH Asthma Guideline 2007 recommendations) and 6 to <12 yr (FDA '
              'labeling); see remarks: Two inhalations BID of 80 mCg budesonide + 4.5 '
              'mCg formoterol; max. dose: 4 inhalations/24 hr'),
          DoseLine(
            '≥12 yr and adult (see remarks):',
            isHeading: true,
          ),
          DoseLine('No prior inhaled steroid use: Start with two inhalations BID of 80 mCg '
              'budesonide + 4.5 mCg formoterol OR 160 mCg budesonide + 4.5 mCg '
              'formoterol, depending on severity'),
          DoseLine('Prior low to medium doses of inhaled steroid use: Start with two '
              'inhalations BID of 80 mCg budesonide + 4.5 mCg formoterol'),
          DoseLine('Prior medium to high doses of inhaled steroid use: Start with two '
              'inhalations BID of 160 mCg budesonide + 4.5 mCg formoterol'),
          DoseLine('Max. dose: 2 inhalations of 160 mCg budesonide + 4.5 mCg formoterol BID'),
        ],
      ),
      DoseSection(
        heading: 'Asthma single maintenance and rescue therapy (SMART) for Steps 3 or 4 '
            'treatment (2020 NHLBI and NAEPPCC Asthma Management Guideline '
            'Update); see remarks:',
        lines: [
          DoseLine(
            '4–11 yr:',
            isHeading: true,
          ),
          DoseLine('80 mCg budesonide + 4.5 mCg formoterol: 1–2 puffs once daily–BID '
              'maintenance + 1–2 puffs PRN rescue up to a combined maintenance and PRN '
              'rescue maximum dosage of 8 puffs/24 hr or 36 mCg formoterol/24 hr'),
          DoseLine(
            '≥12 yr and adult:',
            isHeading: true,
          ),
          DoseLine('160 mCg budesonide + 4.5 mCg formoterol: 1–2 puffs once daily–BID '
              'maintenance PLUS 1–2 puffs PRN rescue up to a combined maintenance and '
              'PRN rescue maximum dosage of 12 puffs/24 hr or 54 mCg formoterol/24 hr'),
        ],
      ),
    ],
    remarks: [
      'See Budesonide and Formoterol for remarks. Should only be used for '
          'patients not adequately controlled on other asthma-controller medications '
          '(e.g., low- to medium-dose inhaled corticosteroids) or whose disease '
          'severity requires the use of two maintenance therapies. Titrate to the '
          'lowest effective strength after asthma is adequately controlled.',
      'Reported side effects at ≥3%, and more frequently compared with '
          'budesonide alone, include URI, pharyngitis, headache, and rhinitis.',
      '2020 NHLBI and NAEPPCC guideline for SMART therapy reports high certainty '
          'of evidence for ages ≥12 yr and moderate certainty of evidence for ages '
          '4–11 yr. As-needed rescue combination low-dose inhaled corticosteroid '
          '(ICS) and formoterol is preferred over short-acting beta-agonists (SABA) '
          'for adolescent and adult patients with asthma for all asthma severity '
          'levels (2025 GINA guidelines; see www.ginasthma.org/gina-reports for the '
          'latest updates). DO NOT substitute formoterol with a slower-onset, '
          'long-acting beta-agonist (LABA) such as salmeterol.',
      'Proper patient education, including dosage administration technique, is '
          'essential; see patient package insert for detailed instructions. Rinse '
          'mouth after each use.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 892–893',
  ),
  // BUMETANIDE — PDF p. 84–85 (printed 893–894)
  DrugEntryV3(
    name: 'BUMETANIDE',
    brandNames: 'Bumex and generics',
    drugClass: 'Loop diuretic',
    iconRow: '',
    formulations: [
      'Tabs: 0.5, 1, 2 mg',
      'Injection: 0.25 mg/mL (4, 10 mL); some preparations may contain 1% benzyl '
          'alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Edema:',
        lines: [
          DoseLine('Neonate and infant (see remarks): PO/IM/IV'),
          DoseLine('≤6 mo: 0.01–0.05 mg/kg/dose once daily or every other day'),
          DoseLine('Infant and child: PO/IM/IV'),
          DoseLine('>6 mo: 0.015–0.1 mg/kg/dose once daily–QID; max. dose: 10 mg/24 hr'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('PO: 0.5–2 mg/dose as a single dose. If needed, repeat dose(s) in 4- to '
              '5-hr intervals up to two additional doses.'),
          DoseLine('IM/IV: 0.5–1 mg (over 1–2 min for IV). May give additional doses Q2–3 hr '
              'PRN.'),
          DoseLine('Max. dose (PO/IM/IV): 10 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Cross-allergenicity may occur in patients allergic to sulfonamides. '
          'Dosage reduction may be necessary in patients with hepatic dysfunction. '
          'Administer oral doses with food.',
      'Side effects include cramps, dizziness, hypotension, headache, '
          'electrolyte losses (hypokalemia, hypocalcemia, hyponatremia, '
          'hypochloremia), and encephalopathy. May also lead to metabolic alkalosis. '
          'Serious skin reactions (e.g., Stevens-Johnson, TEN) have been reported.',
      'Drug elimination has been reported to be slower in neonates with '
          'respiratory disorders compared with neonates without. May displace '
          'bilirubin in critically ill neonates. Maximal diuretic effect for infants '
          '≤6 mo has been reported at 0.04 mg/kg/dose with greater efficacy seen at '
          'lower dosages.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 893–894',
  ),
  // BUTORPHANOL — PDF p. 85–86 (printed 894–895)
  DrugEntryV3(
    name: 'BUTORPHANOL',
    brandNames: 'Generics; previously available as Stadol',
    drugClass: 'Narcotic, analgesic',
    iconRow: '',
    formulations: [
      'Injection: 1 mg/mL (1 mL), 2 mg/mL (1, 2 mL)',
      'Nasal solution: 10 mg/mL (2.5 mL); 1 mg per spray',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child (limited data):',
        lines: [
          DoseLine('0.01–0.02 mg/kg/dose (max. dose: 2 mg/dose) IV Q3–4 hr PRN. Use of a '
              'single dose of 0.03 mg/kg IV has been reported in postoperative patients.'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('IV: 1 mg/dose Q3–4 hr PRN; usual dosage range: 0.5–2 mg Q3–4 hr PRN'),
          DoseLine('IM: 2 mg/dose Q3–4 hr PRN; usual dosage range: 1–4 mg Q3–4 hr PRN'),
          DoseLine('Intranasal: 1 spray (1 mg) in one nostril × 1; an additional 1-mg dose '
              'may be given at 1–1.5 hr if needed. This 2-dose sequence may be repeated '
              'in 3–4 hr if needed. Alternatively, the patient may receive 2 mg '
              'initially (1 mg in each nostril) only if they remain recumbent if '
              'drowsiness or dizziness occurs; an additional dose may be given 3–4 hr '
              'later.'),
        ],
      ),
    ],
    remarks: [
      'A synthetic mixed agonist/antagonist opioid analgesic used when '
          'alternative treatment options are ineffective or not tolerated. '
          'Contraindicated in patients hypersensitive to benzethonium chloride. Use '
          'with caution in hypotension, thyroid dysfunction, renal or hepatic '
          'impairment, and concomitant CNS depressants. Suggested dosage reduction '
          'in renal impairment (IV/IM): 75% of usual dose for GFR 10–50 mL/min and '
          '50% of usual dose for GFR <10 mL/min with an increase in dosage interval '
          'based on duration of clinical effects. A 50% IV/IM dosage reduction with '
          'increased dosage interval has been recommended in hepatic dysfunction. '
          'Reduced dosage for intranasal administration for both renal and hepatic '
          'impairment: initial dose should not exceed 1 mg.',
      'Butorphanol is a cytochrome P-450 3A4 substrate. CYP3A4 inhibitors may '
          'increase butophanol’s effects and toxicity (fatal respiratory depression).',
      'Common side effects include drowsiness, dizziness, insomnia (nasal '
          'spray), nausea, vomiting, and nasal congestion (nasal spray). Severe '
          'respiratory depression has been reported with use of nasal solutions.',
      'Onset of action: 5–10 min (IV); 0.5–1 hr (IM); and within 15 min '
          '(intranasal). Duration: 3–4 hr (IV/IM) and 4–5 hr (intranasal).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 894–895',
  ),
];
