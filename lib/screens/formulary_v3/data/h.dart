// =============================================================================
// output/h.dart — Drug Formulary 3.0, letter H
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyH` per file; entries in book order.
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

const List<DrugEntryV3> formularyH = [
  // HALOPERIDOL — PDF p. 216–217 (printed 1025–1026)
  DrugEntryV3(
    name: 'HALOPERIDOL',
    brandNames: 'Generics; previously available as Haldol and Haldol Decanoate',
    drugClass: 'Antipsychotic agent',
    iconRow: '',
    formulations: [
      'Injection (IM use only):',
      'Lactate: 5 mg/mL (1, 10 mL)',
      'Decanoate (long acting): 50, 100 mg/mL (1, 5 mL); in sesame oil with 1.2% '
          'benzyl alcohol',
      'Tabs: 0.5, 1, 2, 5, 10, 20 mg',
      'Oral solution: 2 mg/mL (15, 120 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child 3–12 yr (limited data; see remarks):',
        lines: [
          DoseLine('PO: Initial dose at 0.5 mg/24 hr ÷ BID–TID. If necessary, increase daily '
              'dosage by 0.25–0.5 mg/24 hr Q5–7 days PRN. Benefits are not to be '
              'expected for doses beyond 6 mg/24 hr. Usual maintenance doses for '
              'specific indications include the following:'),
          DoseLine('Agitation: 0.01–0.03 mg/kg/24 hr once daily'),
          DoseLine('Psychosis: 0.05–0.15 mg/kg/24 hr ÷ BID–TID'),
          DoseLine('Tourette syndrome: 0.05–0.075 mg/kg/24 hr ÷ BID–TID; may increase daily '
              'dose by 0.5 mg Q5–7 days'),
          DoseLine(
            'IM, as lactate:',
            isHeading: true,
          ),
          DoseLine('Acute agitation: may repeat dose Q20-30 minutes up to the weight-specific '
              'daily maximum dose'),
          DoseLine('Child: 0.5–2 mg/dose; max. dose: ≤40 kg: 6 mg/24 hr and >40 kg: 15 mg/24 '
              'hr'),
        ],
      ),
      DoseSection(
        heading: '>12 yr (limited data):',
        lines: [
          DoseLine('Acute agitation: 2–5 mg/dose IM as lactate or 1–15 mg/dose PO; repeat in '
              '1 hr PRN; max. dose: ≤40 kg: 6 mg/24 hr and >40 kg: 15 mg/24 hr'),
          DoseLine('Psychosis: 2–5 mg/dose IM Q4–8 hr PRN OR 1–15 mg/24 hr PO ÷ BID–TID'),
          DoseLine('Tourette syndrome: 0.5–2 mg/dose PO BID–TID; 3–5 mg/dose PO BID–TID may '
              'be used for severe symptoms.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in severe toxic CNS depression, comas, Parkinson disease, '
          'and Lewy body dementia. Use with caution in patients with cardiac disease '
          '(risk of hypotension), cerebrovascular adverse reaction risk, renal or '
          'hepatic dysfunction, thyrotoxicosis, and in patients with epilepsy, since '
          'the drug lowers the seizure threshold. Extrapyramidal symptoms, '
          'drowsiness, headache, tachycardia, ECG changes, nausea, and vomiting can '
          'occur. Higher-than-recommended doses are associated with a higher risk of '
          'Q–T prolongation and torsades de pointes. Leukopenia/neutropenia, '
          'including agranulocytosis and rhabdomyolysis (IM route), and transient '
          'dyskinetic signs (following abrupt withdrawal from maintenance therapies) '
          'have been reported.',
      'Drug is metabolized by cytochrome P-450 (CYP) 1A2, 2D6, and 3A3/3A4 '
          'isoenzymes. May also inhibit CYP2D6 and 3A3/3A4 isoenzymes. '
          'Serotonin-specific reuptake inhibitors (e.g., fluoxetine) may increase '
          'levels and effects of haloperidol. Carbamazepine and phenobarbital may '
          'decrease levels and effects of haloperidol. Monitor for encephalopathic '
          'syndrome when used in combination with lithium.',
      'For poor metabolizers of CYP2D6, consider a 50% reduction of initial dose '
          'and titrate to response OR use an alternative medication not metabolized '
          'by this enzyme system.',
      'Acutely aggravated patients may require doses as often as Q60 min. '
          'Decanoate salt is given every 3–4 wk in doses that are 10–15 times the '
          'individual patient’s stabilized oral dose.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1025–1026',
  ),
  // HEPARIN SODIUM — PDF p. 217–218 (printed 1026–1027)
  DrugEntryV3(
    name: 'HEPARIN SODIUM',
    brandNames: 'Various generics',
    drugClass: 'Anticoagulant',
    iconRow: '',
    formulations: [
      'Injection:',
      'Porcine intestinal mucosa: 1000, 5000, 10,000, 20,000 U/mL (some products '
          'may be preservative free; multidosed vials contain benzyl alcohol).',
      'Lock flush solution (porcine based): 10, 100 U/mL (some products may be '
          'preservative free or contain benzyl alcohol).',
      'Injection for IV infusion (porcine based):',
      'D₅W: 40 U/mL (500 mL), 50 U/mL (250, 500 mL), 100 U/mL (100, 250 mL); '
          'contains bisulfite',
      'NS (0.9% NaCl): 2 U/mL (500, 1000 mL)',
      '0.45% NaCl: 50 U/mL (250, 500 mL), 100 U/mL (250 mL); contains EDTA',
      '120 U = approximately 1 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Anticoagulation empiric dosage:',
        lines: [
          DoseLine('Continuous IV infusion (initial doses for goal of unfractionated heparin '
              '[UFH] anti-Xa level of 0.3–0.7 units/mL):'),
        ],
        table: DoseTable(
          headers: ['Age', 'Loading Dose (IV)ᵃ', 'Initial IV Infusion Rate (units/kg/hr)'],
          rows: [
            DoseTableRow(['Neonate and infant <1 yr', '75 U/kg IV', '28']),
            DoseTableRow(['Child age 1–18 yr', '75 U/kg IV (max. dose: 8000 U)', '20 (max. initial rate: 1650 U/hr)']),
            DoseTableRow(['>18 yr', '70 U/kg IV (max. dose: 8000 U)', '18 (max. initial rate: 1650 U/hr)']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃDo not give loading dose for patients with stroke or significant '
              'bleeding risk and obtain aPPT 4 hr after loading dose.'),
        ],
      ),
      DoseSection(
        heading: 'DVT or PE prophylaxis:',
        lines: [
          DoseLine('Adult: 5000 U/dose SC Q8–12 hr until ambulatory'),
        ],
      ),
      DoseSection(
        heading: 'Heparin flush (doses should be less than heparinizing dose):',
        lines: [
          DoseLine('Younger child: Lower doses should be used to avoid systemic '
              'heparinization.'),
          DoseLine(
            'Older child and adult:',
            isHeading: true,
          ),
          DoseLine('Peripheral IV: 1–2 mL of 10 U/mL solution Q4 hr'),
          DoseLine('Central lines: 0.5–3 mL of 10 U/mL solution Q24 hr and PRN'),
          DoseLine('TPN (central line) and arterial line: Add heparin to make final '
              'concentration of 0.5–1 U/mL'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in active major bleeding, known or suspected HIT, and '
          'concurrent epidural therapy. Use with caution if platelets <50,000/mm³. '
          'Avoid IM injections and other medications affecting platelet function '
          '(e.g., NSAIDs and ASA). Toxicities include bleeding, allergy, alopecia, '
          'and thrombocytopenia. May increase serum aminotransferases (AST and ALT). '
          'Hyperkalemia has been reported, particularly in patients with diabetes '
          'mellitus, chronic renal failure, or metabolic acidosis, or taking '
          'potassium-sparing drugs. Risk for hyperkalemia increases with duration of '
          'therapy but is usually reversible with heparin discontinuance.',
      'Adjust dose with one of the following laboratory goals:',
      'Unfractionated heparin (UFH) anti-Xa level: 0.3–0.7 units/mL',
      'aPTT level (reagent specific to reflect anti-Xa level of 0.3–0.7 '
          'units/mL): 50–80 sec',
      'These laboratory measurements are best measured 4–6 hr after initiation '
          'or changes in infusion rate. Do not collect blood levels from the '
          'heparinized line or same extremity as site of heparin infusion. If '
          'unfractionated heparin anti-Xa or aPTT levels are not available, a ratio '
          'of aPPT 1.5–2.5 times control value has been used in the past. '
          'Unfractionated heparin anti-Xa level is NOT THE SAME as '
          'low-molecular-weight heparin anti-Xa level (used for monitoring '
          'low-molecular-weight heparin products such as enoxaparin).',
      'Use with IV nitroglycerin may decrease the partial thromboplastin time '
          '(PTT), with subsequent rebound upon discontinuation of nitroglycerin. '
          'Antithrombin III (human) and NSAIDs may increase heparin’s anticoagulant '
          'effects and bleeding risk.',
      'Use preservative-free heparin in neonates. Note: Heparin flush doses may '
          'alter aPTT in smaller patients; consider using more dilute heparin in '
          'these cases. Multiple strengths of heparin exist; do not use the more '
          'concentrated injectable product as flushes.',
      'Use actual body weight when dosing obese patients. Due to recent '
          'regulatory changes to the manufacturing process, heparin products may '
          'exhibit decreased potency.',
      'Antidote: Protamine sulfate (1 mg/100 U heparin in previous 4 hr). For '
          'low-molecular-weight heparin (LMWH), see Enoxaparin.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1026–1027',
  ),
  // HYALURONIDASE — PDF p. 218–219 (printed 1027–1028)
  DrugEntryV3(
    name: 'HYALURONIDASE',
    brandNames: 'Amphadase, Hylenex, and Vitrase',
    drugClass: 'Antidote, extravasation',
    iconRow: '',
    formulations: [
      'Injection:',
      'Amphadase: 150 U/mL (1 mL); bovine source; contains edetate disodium and '
          'thimerosal',
      'Hylenex: 150 U/mL (1 mL); recombinant human source; contains 1 mg '
          'albumin, 1.5 mg L-methionine, and 0.2 mg polysorbate 80 per 150 U; '
          'preservative free',
      'Vitrase: 200 U/mL (1.2 mL); ovine source containing lactose, preservative '
          'free',
      'Pharmacy can make a 15 U/mL dilution.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Extravasation:',
        lines: [
          DoseLine('Infant and child: Use 150 U/mL product by administering 5 separate SC or '
              'intradermal injections of 0.2 mL (30 U) at borders of extravasation site '
              'using a 25- or 26-gauge needle. Alternatively, a diluted 15 U/mL '
              'concentration has been used with the same dosing instructions.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in patients with dopamine and α-agonist extravasation and '
          'hypersensitivity to the respective product sources (bovine or ovine). May '
          'cause urticaria. Patients receiving large amounts of salicylates, '
          'cortisone, ACTH, estrogens, or antihistamines may decrease the effects of '
          'hyaluronidase (larger doses may be necessary). Administer as early as '
          'possible',
      '(minutes to 1 hr) after IV extravasation.',
      'Hylenex product is chemically incompatible with sodium metabisulfite, '
          'furosemide, benzodiazepines, and phenytoin.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1027–1028',
  ),
  // HYDRALAZINE HYDROCHLORIDE — PDF p. 219 (printed 1028)
  DrugEntryV3(
    name: 'HYDRALAZINE HYDROCHLORIDE',
    brandNames: 'Generics; previously available as Apresoline',
    drugClass: 'Antihypertensive, vasodilator',
    iconRow: '',
    formulations: [
      'Tabs: 10, 25, 50, 100 mg',
      'Injection: 20 mg/mL (1 mL)',
      'Oral liquid: 4 mg/mL',
      'Some dosage forms may contain tartrazines or sulfites.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Acute severe hypertension (may result in severe and prolonged '
            'hypotension; see Chapter 1, Table 1.8 for alternatives):',
        lines: [
          DoseLine('Child: 0.1–0.2 mg/kg/dose IM or IV Q4–6 hr PRN; max. dose: 20 mg/dose. '
              'Usual IV/IM dosage range is 0.2–0.6 mg/kg/dose Q4–6 hr.'),
          DoseLine('Adult: 10–20 mg IM or IV Q4–6 hr PRN; may increase to max. dose of 40 '
              'mg/dose if needed'),
        ],
      ),
      DoseSection(
        heading: 'Chronic hypertension:',
        lines: [
          DoseLine('Infant and child: Start at 0.75–1 mg/kg/24 hr PO ÷ Q6–12 hr (max. initial '
              'dose: 10 mg/dose). If necessary, increase dose over 3–4 wk up to a max. '
              'dose of 5 mg/kg/24 hr for infants and 7.5 mg/kg/24 hr for children; or '
              '200 mg/24 hr'),
          DoseLine('Adult: 10–50 mg/dose PO QID; max. dose: 300 mg/24 hr. Usual dosage range: '
              '100-200 mg/24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in severe renal and cardiac disease. Slow acetylators, '
          'patients receiving high-dose chronic therapy, and those with renal '
          'insufficiency are at highest risk of lupus-like syndrome (generally '
          'reversible). May cause reflex tachycardia, palpitations, dizziness, '
          'headaches, and GI discomfort. MAO inhibitors and β-blockers may increase '
          'hypotensive effects. Indomethacin may decrease hypotensive effects.',
      'Drug undergoes first-pass metabolism. Onset of action: PO: 20–30 min; IV: '
          '5–20 min. Duration of action: PO: 2–4 hr; IV: 2–6 hr. Adjust dose in '
          'renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1028',
  ),
  // HYDROCHLOROTHIAZIDE — PDF p. 219–220 (printed 1028–1029)
  DrugEntryV3(
    name: 'HYDROCHLOROTHIAZIDE',
    brandNames: 'Generics; previously available as HydroDiuril and Microzide',
    drugClass: 'Diuretic, thiazide',
    iconRow: '',
    formulations: [
      'Tabs: 12.5, 25, 50 mg',
      'Caps: 12.5 mg',
      'Oral suspension: 5 mg/mL, 10 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Edema:',
        lines: [
          DoseLine('Neonate and infant <6 mo: 1–3 mg/kg/24 hr PO ÷ once daily–BID; max. dose: '
              '37.5 mg/24 hr'),
          DoseLine('≥6 mo, child, and adolescent: 1–2 mg/kg/24 hr PO ÷ once daily–BID; max. '
              'dose: <2 yr: 37.5 mg/24 hr, child 2–12 yr: 100 mg/24 hr, and adolescent: '
              '200 mg/24 hr'),
          DoseLine('Adult: 25–100 mg/24 hr PO ÷ once daily–BID; max. dose: 200 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Hypertension:',
        lines: [
          DoseLine('Infant and child: Start at 1–2 mg/kg/24 hr PO ÷ once daily–BID; max. '
              'dose: <6 mo: 37.5 mg/24 hr, child ≥6 mo–12 yr: 100 mg/24 hr (37.5 mg/24 '
              'hr has been recommended by some experts).'),
          DoseLine('Adult: 12.5–25 mg/dose PO once daily–BID; doses >50 mg/24 hr often result '
              'in hypokalemia.'),
        ],
      ),
    ],
    remarks: [
      'See Chlorothiazide. May cause fluid and electrolyte imbalances and '
          'hyperuricemia. Drug may not be effective when creatinine clearance is '
          'less than 25–50 mL/min/1.73m². Use with carbamazepine may result in '
          'symptomatic hyponatremia.',
      'Hydrochlorothiazide is also available in combination with '
          'potassium-sparing diuretics (e.g., spironolactone), ACE inhibitors, '
          'angiotensin II receptor antagonists, hydralazine, methyldopa, reserpine, '
          'and β-blockers.',
    ],
    pregnancyNote: 'Pregnancy category is “D” if used in pregnancy-induced '
        'hypertension.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1028–1029',
  ),
  // HYDROCORTISONE — PDF p. 220–221 (printed 1029–1030)
  DrugEntryV3(
    name: 'HYDROCORTISONE',
    brandNames: 'Systemic dosage forms: Solu-Cortef, Cortef, Alkindi Sprinkle, and '
        'generics\nTopical: Anusol HC, Cortifoam, Cortenema, MiCort-HC, '
        'NuCort, Proctocort, and many others, including generics',
    drugClass: 'Corticosteroid',
    iconRow: '',
    formulations: [
      'Hydrocortisone base:',
      'Tabs (Cortef and generics): 5, 10, 20 mg',
      'Oral granules in capsules (Alkindi sprinkle): 0.5, 1, 2, 5 mg',
      'Oral suspension: 2 mg/mL',
      'Rectal cream: 1% (30 g)',
      'Anusol HC and generics: 2.5% (30 g)',
      'Rectal suspension as an enema (Cortenema): 100 mg/60 mL; may contain '
          'parabens',
      'Topical ointment: 0.5% [OTC], 1% [OTC], 2.5%',
      'Topical cream: 0.5% [OTC], 1% [OTC], 2.5%',
      'Topical lotion: 1% [OTC], 2%, 2.5%',
      'Na Succinate (Solu-Cortef):',
      'Injection: 100, 250, 500, 1000 mg/vial; preservative free',
      'Acetate:',
      'Topical cream: 1% [OTC]',
      'MiCort-HC: 2% (28.4 g)',
      'Topical lotion (NuCort): 2% (60 g); contains benzyl alcohol and aloe',
      'Topical ointment: 1% (30 g)',
      'Suppository:',
      'Anusol HC and generics: 25 mg',
      'Proctocort and generics: 30 mg',
      'Rectal foam aerosol (Cortifoam): 10% (90 mg/dose) (15 g); may contain '
          'parabens',
    ],
    doseSections: [
      DoseSection(
        heading: 'Status asthmaticus:',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('Load (optional): 4–8 mg/kg/dose IV; max. dose: 250 mg'),
          DoseLine('Maintenance: 8 mg/kg/24 hr IV ÷ Q6 hr'),
          DoseLine('Adult: 50–500 mg/dose IV Q6 hr × 2 days, followed by prednisone PO'),
        ],
      ),
      DoseSection(
        heading: 'Physiologic replacement:',
        lines: [
          DoseLine('See Chapter 10 for dosing'),
        ],
      ),
      DoseSection(
        heading: 'Anti-inflammatory/immunosuppressive:',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('PO: 2.5–10 mg/kg/24 hr ÷ Q6–8 hr'),
          DoseLine('IM/IV: 1–5 mg/kg/24 hr ÷ Q12–24 hr'),
          DoseLine(
            'Adolescent and adult:',
            isHeading: true,
          ),
          DoseLine('PO/IM/IV: 15–240 mg/dose Q12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Acute adrenal insufficiency:',
        lines: [
          DoseLine('See Chapter 10 for dosing'),
        ],
      ),
      DoseSection(
        heading: 'Topical use:',
        lines: [
          DoseLine('Child and adult: Apply to affected areas BID–QID, depending on severity '
              'and specific indication for use'),
        ],
      ),
      DoseSection(
        heading: 'Ulcerative colitis, induction for mild/moderate case (limited data):',
        lines: [
          DoseLine('Child, adolescent, and adult: Insert 1 application of 100-mg rectal enema '
              'once daily–BID × 2–3 wk'),
        ],
      ),
      DoseSection(
        heading: 'Hemorrhoids:',
        lines: [
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Rectal cream: Apply sparingly up to BID with either 1% or 2.5% strength'),
          DoseLine('Suppository: 25 or 30 mg PR BID × 1–2 wk'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in immunocompromised patients, as they should avoid '
          'exposure to chickenpox or measles. Hypertrophic cardiomyopathy has been '
          'reported in premature infants. Dosages that are greater than '
          'physiological replacement may increase risk of infections (bacterial, '
          'viral, fungal, protozoan, or helminthic) ranging from mild to '
          'severe/fatal.',
      'Alkindi sprinkle product: Administered by sprinkling the capsule’s '
          'contents directly onto the tongue or mixed with soft food. DO NOT swallow '
          'capsules. Different hydrocortisone exposure may occur when converting to '
          'Alkindi sprinkle from other manipulated oral formulations (e.g., split or '
          'crushed tabs, compounded formulations).',
      'For potency comparisons of topical preparations, see Chapter 8. For doses '
          'based on body surface area, see Chapter 10.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1029–1030',
  ),
  // HYDROMORPHONE HCL — PDF p. 221–222 (printed 1030–1031)
  DrugEntryV3(
    name: 'HYDROMORPHONE HCL',
    brandNames: 'Dilaudid and generics',
    drugClass: 'Narcotic, analgesic',
    iconRow: '',
    formulations: [
      'Tabs: 2, 4, 8 mg',
      'Extended-release tabs: 8, 12, 16, 32 mg',
      'Injection: 1, 2, 4 mg/mL (1 mL), 10 mg/mL (1, 5, 50 mL); may be '
          'preservative free',
      'Prefilled injectable syringes: 0.2 mg/mL (1 mL), 1 mg/mL (0.5, 1 mL), 2 '
          'mg/mL (1 mL)',
      'Suppository: 3 mg (6s)',
      'Oral solution: 1 mg/mL; may contain parabens and metasulfite',
    ],
    doseSections: [
      DoseSection(
        heading: 'Analgesia, initial doses with immediate-release dosage forms to '
            'opioid-naïve (titrate to effect):',
        lines: [
          DoseLine(
            'Child (<50 kg):',
            isHeading: true,
          ),
          DoseLine('IV: 0.015 mg/kg/dose Q3–6 hr PRN'),
          DoseLine('PO: 0.03–0.08 mg/kg/dose Q3–4 hr PRN; max. dose: 5 mg/dose'),
          DoseLine(
            'Child and adolescent (≥50 kg; NOTE: doses are NOT weight based):',
            isHeading: true,
          ),
          DoseLine('IV: 0.2–0.6 mg/dose Q2–4 hr PRN'),
          DoseLine('IM, SC (not preferred route; absorption is erratic): 0.8–1 mg/dose Q4–6 '
              'hr PRN'),
          DoseLine('PO: 1–2 mg/dose Q3–4 hr PRN'),
          DoseLine('PR: 3 mg Q6–8 hr PRN'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('IV: 0.2–0.5 mg/dose Q2–4 hr PRN'),
          DoseLine('IM, SC (not preferred route; absorption is erratic): 0.2–0.5 mg/dose Q2–3 '
              'hr PRN'),
          DoseLine('PO: 1–2 mg/dose Q4–6 hr PRN'),
          DoseLine('PR: 3 mg Q6–8 hr PRN'),
        ],
      ),
    ],
    remarks: [
      'Refer to Chapter 6 for equianalgesic doses and for patient-controlled '
          'analgesia dosing. Less pruritus than morphine. Profile of side effects '
          'similar to other narcotics. Use with caution in infants and young '
          'children and do not use in neonates due to potential CNS effects. Dose '
          'reduction recommended in renal insufficiency or severe hepatic '
          'impairment. Pregnancy category changes to “D” if used for prolonged '
          'periods or in high doses at term.',
      'The FDA has assigned a Risk Evaluation and Mitigation Strategy (REMS) for '
          'this medication, which involves an education program for provision of '
          'safety information. See www. opioidanalgesicrems.com',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1030–1031',
  ),
  // HYDROXYCHLOROQUINE SULFATE — PDF p. 222–223 (printed 1031–1032)
  DrugEntryV3(
    name: 'HYDROXYCHLOROQUINE SULFATE',
    brandNames: 'Plaquenil, Sovuna, and generics',
    drugClass: 'Antimalarial, antirheumatic agent',
    iconRow: '',
    formulations: [
      'Tabs:',
      'Generics: 100 mg (77.5 mg base), 200 mg (155 mg base), 300 mg (232.5 mg '
          'base), 400 mg (310 mg base)',
      'Plaquenil: 200 mg (155 mg base)',
      'Sovuna: 200 mg (155 mg base), 300 mg (232.5 mg base)',
      'Oral suspension: 25 mg/mL (19.375 mg/mL base)',
    ],
    doseSections: [
      DoseSection(
        heading: 'All doses expressed in mg of hydroxychloroquine base.',
      ),
      DoseSection(
        heading: 'Malaria prophylaxis (start 2 wk prior to exposure and continue for 4 '
            'wk after leaving endemic area):',
        lines: [
          DoseLine('Child: 5 mg/kg/dose PO once weekly; max. dose: 310 mg'),
          DoseLine('Adult: 310 mg PO once weekly'),
        ],
      ),
      DoseSection(
        heading: 'Malaria treatment (acute uncomplicated cases):',
        lines: [
          DoseLine('For treatment of malaria, consult with ID specialist or see the latest '
              'edition of the AAP Red Book.'),
          DoseLine('Child: 10 mg/kg/dose (max. dose: 620 mg) PO × 1, followed by 5 mg/kg/dose '
              '(max. dose: 310 mg) 6 hr later, then 5 mg/kg/dose (max. dose: 310 mg) PO '
              'Q24 hr × 2 doses, starting 24 hr after the first dose'),
          DoseLine('Adult: 620 mg PO × 1 followed by 310 mg 6 hr later, then 310 mg PO Q24 hr '
              '× 2 doses, starting 24 hr after the first dose'),
        ],
      ),
      DoseSection(
        heading: 'Systemic lupus erythematosus (limited data):',
        lines: [
          DoseLine('Child: 3.1–5 mg/kg/24 hr (base) PO ÷ once daily–BID; max. dose: 310 mg/24 '
              'hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in psoriasis, porphyria, retinal or visual field changes, '
          'and 4-aminoquinoline hypersensitivity. Use with caution in liver disease, '
          'G6PD deficiency, concomitant hepatic toxic drugs, renal impairment, '
          'metabolic acidosis, or hematologic disorders. Long-term use in children '
          'is not recommended. May cause headaches, myopathy, GI disturbances, skin '
          'and mucosal pigmentation, agranulocytosis, visual disturbances, and '
          'increased digoxin serum levels. Hypoglycemia, cardiomyopathy with '
          'phospholipidosis without inflammation, proximal myopathy/neuropathy, '
          'hepatotoxicity associated with porphyria cutanea tarda, and suicidal '
          'behavior have been reported. Baseline ocular exam is recommended within '
          'the first year of initiating long-term therapy, as retinal damage has '
          'been reported.',
      'Use with aurothioglucose may increase risk for blood dyscrasias. When '
          'used in combination with other immunosuppressive agents for SLE and JRA, '
          'lower doses of hydroxychloroquine can be used.',
    ],
    pregnancyNote: 'Pregnancy category has not been formally assigned by the FDA. The '
        'only situation in which use is recommended during pregnancy is '
        'during the suppression or treatment of malaria, when the benefits '
        'outweigh the risks.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1031–1032',
  ),
  // HYDROXYZINE — PDF p. 223 (printed 1032)
  DrugEntryV3(
    name: 'HYDROXYZINE',
    brandNames: 'Generics; previously available as Vistaril',
    drugClass: 'Antihistamine, anxiolytic, antiemetic',
    iconRow: '',
    formulations: [
      'Tabs (HCl salt): 10, 25, 50 mg',
      'Caps (pamoate salt): 25, 50, 100 mg',
      'Oral syrup (HCl salt): 10 mg/5 mL (120, 473 mL); may contain alcohol, '
          'parabens, and propylene glycol',
      'Injection for IM use (HCl salt): 25 mg/mL (1 mL), 50 mg/mL (1, 2 mL); may '
          'contain benzyl alcohol',
      'NOTE: Pamoate and HCL salts are equivalent in regard to mg of hydroxyzine.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Pruritus and anxiety:',
        lines: [
          DoseLine(
            'Oral:',
            isHeading: true,
          ),
          DoseLine('Child and adolescent: 2 mg/kg/24 hr ÷ Q6–8 hr PRN; max. single dose: <6 '
              'yr: 12.5 mg, 6–12 yr: 25 mg, and >12 yr: 100 mg'),
          DoseLine(
            'Alternative dosing by age:',
            isHeading: true,
          ),
          DoseLine('<6 yr: 50 mg/24 hr ÷ Q6–8 hr PRN'),
          DoseLine('≥6 yr: 50–100 mg/24 hr ÷ Q6–8 hr PRN'),
          DoseLine('Adult: 25–100 mg/dose TID–QID PRN'),
          DoseLine(
            'IM:',
            isHeading: true,
          ),
          DoseLine('Child and adolescent: 0.5–1 mg/kg/dose Q4–6 hr PRN; max. single dose: 100 '
              'mg'),
          DoseLine('Adult: 25–100 mg/dose Q4–6 hr PRN'),
        ],
      ),
      DoseSection(
        heading: 'Antiemetic (excluding use during pregnancy):',
        lines: [
          DoseLine('Child and adolescent: 1.1 mg/kg/dose IM; max. single dose: 100 mg'),
          DoseLine('Adult: 25–100 mg IM'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in prolonged Q–T interval. May potentiate barbiturates, '
          'meperidine, and other CNS depressants. Use with caution with concomitant '
          'use of other medications known to prolong the Q–T interval. May cause dry '
          'mouth, drowsiness, tremor, convulsions, blurred vision, and hypotension. '
          'May cause pain at injection site. Fixed drug eruptions have been reported '
          'with use of the oral dosage form.',
      'Increase dosage interval to Q24 hr or longer in the presence of liver '
          'disease (e.g., primary biliary cirrhosis).',
      'Onset of action within 15–30 min. Duration of action: 4–6 hr. IV '
          'administration is NOT recommended.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1032',
  ),
];
