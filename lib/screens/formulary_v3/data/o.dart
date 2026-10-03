// =============================================================================
// output/o.dart — Drug Formulary 3.0, letter O
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyO` per file; entries in book order.
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

const List<DrugEntryV3> formularyO = [
  // OCTREOTIDE ACETATE — PDF p. 327–328 (printed 1136–1137)
  DrugEntryV3(
    name: 'OCTREOTIDE ACETATE',
    brandNames: 'Sandostatin, Sandostatin LAR Depot, and generics',
    drugClass: 'Somatostatin analog, antisecretory agent',
    iconRow: '',
    formulations: [
      'Injection (amps and single-dose vials): 0.05, 0.1, 0.5 mg/mL (1 mL); '
          'preservative free',
      'Injection (multidose vials): 0.2, 1 mg/mL (5 mL); contains phenol',
      'Injection, microspheres for suspension, IM use (Sandostatin LAR Depot and '
          'generics; see remarks): 10, 20, 30 mg (in kits with 2 mL diluent and '
          '1.5-in 20-ga needles)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infant and child:',
        lines: [
          DoseLine(
            'Intractable diarrhea (very limited data):',
            isHeading: true,
          ),
          DoseLine('IV/SC: 1–10 mCg/kg/24 hr ÷ Q12–24 hr. Dose may be increased within the '
              'recommended range by 0.3 mCg/kg/dose every 3 days as needed. Max. dose: '
              '1500 mCg/24 hr'),
          DoseLine('IV continuous infusion: Bolus of 1 mCg/kg/dose followed by 1 mCg/kg/hr; '
              'this has been used in diarrhea associated with graft-versus-host disease.'),
          DoseLine('Esophageal varices (limited data): Bolus of 1–2 mCg/kg/dose followed by '
              '1–2 mCg/kg/hr. Use was reported as safe and effective over a 2–5 day '
              'duration with major adverse effects in one subject each receiving higher '
              'dose or longer duration of therapy. Therapy is typically discontinued 24 '
              'hr after bleeding has ceased or when no clinical response is seen after '
              '12 hr of use.'),
        ],
      ),
    ],
    remarks: [
      'Cholelithiasis, hyperglycemia, hypoglycemia, hypothyroidism, nausea, '
          'diarrhea, abdominal discomfort, headache, dizziness, and pain at '
          'injection site may occur. Growth hormone suppression may occur with '
          'long-term use. Bradycardia, thrombocytopenia, steatorrhea, '
          'loose/discolored stools, reduced vitamin B₁₂ levels, increased risk for '
          'pregnancy in patients with acromegaly, and pancreatitis have been '
          'reported. Cyclosporine levels may be reduced in patients receiving this '
          'drug. May increase the effects/toxicity of bromocriptine.',
      'Patients with severe renal failure requiring dialysis may require dosage '
          'adjustments due to an increase in half-life. Effects of hepatic '
          'dysfunction on octreotide have not been evaluated. Octreotide may '
          'interfere with the efficacy of lutetium Lu 177 dotatate; discontinue '
          'octreotide at least 24 hr prior to each lutetium Lu 177 dotatate dose. '
          'May decrease the effects of cyclosporine and increase the effect/toxicity '
          'of bromocriptine. Use with caution with medications that are primarily '
          'metabolized via cytochrome P-450 (CYP) 3A4 with low therapeutic index '
          '(e.g., quinidine) as somatostatin analogs may decrease CYP activity via '
          'growth hormone suppression.',
      'Sandostatin LAR Depot is administered once every 4 wk only by the IM '
          'route and is currently indicated for use in adults who have been '
          'stabilized on IV/SC therapy. See package insert for details.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1136–1137',
  ),
  // OFLOXACIN (OTIC AND OPHTHALMIC) — PDF p. 328 (printed 1137)
  DrugEntryV3(
    name: 'OFLOXACIN (OTIC AND OPHTHALMIC)',
    brandNames: 'Ocuflox and generics; previously available as Floxin and Floxin Otic',
    drugClass: 'Antibiotic, quinolone',
    iconRow: '',
    formulations: [
      'Otic solution: 0.3% (5, 10 mL); contains benzalkonium chloride',
      'Ophthalmic solution (Ocuflox and generics): 0.3% (5, 10 mL); contains '
          'benzalkonium chloride',
    ],
    doseSections: [
      DoseSection(
        heading: 'Otic use:',
        lines: [
          DoseLine(
            'Otitis externa (acute):',
            isHeading: true,
          ),
          DoseLine('6 mo–12 yr: 5 drops to affected ear(s) once daily × 7 days'),
          DoseLine('≥13 yr–adult: 10 drops to affected ear(s) once daily × 7 days'),
          DoseLine(
            'Chronic suppurative otitis media:',
            isHeading: true,
          ),
          DoseLine('≥12 yr–adult: 10 drops to affected ear(s) BID × 14 days'),
          DoseLine(
            'Acute otitis media with tympanostomy tubes:',
            isHeading: true,
          ),
          DoseLine('1–12 yr: 5 drops to affected ear(s) BID × 10 days'),
        ],
      ),
      DoseSection(
        heading: 'Ophthalmic use (>1 yr–adult):',
        lines: [
          DoseLine('Conjunctivitis: 1–2 drops to affected eye(s) 2–4 hr while awake × 2 days, '
              'then QID × 5 additional days'),
          DoseLine('Corneal ulcer: 1–2 drops to affected eye(s) Q30 min while awake and Q4–6 '
              'hr while asleep at night × 2 days, followed by Q1 hr while awake × 5 '
              'days, and then QID until treatment has been completed'),
        ],
      ),
    ],
    remarks: [
      'Pruritus, local irritation, taste perversion, dizziness, and earache have '
          'been reported with otic use. Ocular burning/discomfort is frequent with '
          'ophthalmic use. Consult with ophthalmologist in cases of corneal ulcers.',
      'When otic solution is being used, the solution should be warmed by '
          'holding the bottle in the hand for 1–2 min. The use of cold solutions may '
          'result in dizziness. For otitis externa, the patient should lie with the '
          'affected ear upward before instillation and remain in the same position '
          'after dose administration for 5 min to enhance drug delivery. For acute '
          'otitis media with tympanostomy tubes, the patient should lie in the same '
          'position prior to instillation and the tragus should be pumped 4 times '
          'after the dose to assist in drug delivery to the middle ear.',
      'Systemic use of ofloxacin is typically replaced by levofloxacin, its '
          'S-isomer, which has a more favorable side effect profile than ofloxacin. '
          'See Levofloxacin.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1137',
  ),
  // OLANZAPINE — PDF p. 329–331 (printed 1138–1140)
  DrugEntryV3(
    name: 'OLANZAPINE',
    brandNames: 'Zyprexa, Zyprexa Relprevv, and generics',
    drugClass: 'Antipsychotic, atypical second generation',
    iconRow: '',
    formulations: [
      'Tabs: 2.5, 5, 7.5, 10, 15, 20 mg',
      'Orally disintegrating tabs: 5, 10, 15, 20 mg; contain phenylalanine and '
          'parabens',
      'IM injection:',
      'Short-acting: 10 mg; contains tartaric acid',
      'Long-acting pamoate salt (Zyprexa Relprevv): This dosage form is only '
          'available from H2 Pharma and patients must be enrolled in the Zyprexa '
          'Relprevv Patient Care Program Coordinating Center (877-772-9390)',
      'Every 2 wk dosing: 210, 300 mg; contains mannitol, polysorbate 80',
      'Every 4 wk dosing: 405 mg; contains mannitol, polysorbate 80',
    ],
    doseSections: [
      DoseSection(
        heading: 'Severe or refractory agitation for psychiatric emergencies in '
            'developmental delay, autism, or oppositional defiant/conduct disorder '
            '(very limited data; oral disintegrating tab is preferred):',
        lines: [
          DoseLine('Child <12 yr: 2.5 mg PO'),
          DoseLine('Child ≥12 yr and adolescent: 5–10 mg PO'),
        ],
      ),
      DoseSection(
        heading: 'Bipolar I disorder (manic or mixed episodes; not first-line therapy):',
        lines: [
          DoseLine('Child 4–6 yr of age (limited data, based on an open-label trial in 15 '
              'subjects): Start at 1.25 mg PO once daily × 7 days, then increase dose Q7 '
              'days PRN as tolerated to a target dose of 10 mg once daily.'),
          DoseLine('Child 6–12 yr of age (limited data): Start at 2.5 mg PO once daily × 7 '
              'days, then increase dose in 2.5- or 5-mg increments Q7 days to a target '
              'dose of 10 mg once daily. Suggested max. dose: 20 mg/24 hr'),
          DoseLine('Adolescent (see remarks): Start at 2.5 or 5 mg PO once daily × 7 days, '
              'then increase dose in 2.5- or 5-mg increments Q7 days to a target dose of '
              '10 mg once daily. Suggested max. dose: 20 mg/24 hr (doses >20 mg/24 hr '
              'have not been evaluated)'),
          DoseLine('Adult: Start at 10 or 15 mg PO once daily (use 10 mg if used with lithium '
              'or valproate). If needed, increase or decrease dose by 5 mg daily at '
              'intervals not <24 hr. Maintenance dosage range: 5–20 mg/24 hr. Suggested '
              'max. dose: 20 mg/24 hr (doses >20 mg/24 hr have not been evaluated)'),
        ],
      ),
      DoseSection(
        heading: 'Schizophrenia:',
        lines: [
          DoseLine('Child ≥8 yr of age and adolescent (see remarks): Start with 2.5 or 5 mg '
              'PO once daily, then increase dose in 2.5- or 5-mg increments Q7 days to '
              'the target dose of 10 mg once daily (doses >20 mg/24 hr have not been '
              'evaluated).'),
          DoseLine('Adult: Start with 5 or 10 mg PO once daily (use 5 mg for individuals who '
              'are debilitated, predisposed to hypotension, pharmacodynamically '
              'sensitive to olanzapine, or nonsmoking females ≥65 yr old) with a target '
              'dose of 10 mg once daily within 5–7 days. If needed, increase or decrease '
              'dose by 5 mg daily at weekly intervals. Usual dosage range: 10–15 mg once '
              'daily. Additional clinical assessment is recommended for doses >10 mg/24 '
              'hr (doses >20 mg/24 hr have not been evaluated).'),
        ],
      ),
      DoseSection(
        heading: 'Chemotherapy-induced nausea and vomiting (refractory breakthrough; '
            'limited data):',
        lines: [
          DoseLine('Child ≥3 yr and adolescent: 0.1–0.14 mg/kg/dose (rounded to the nearest '
              '1.25 mg dosage increment) PO once daily–BID. Many report use in '
              'combination with other antiemetics such as aprepitant, dexamethasone, '
              'ondansetron, or granisetron.'),
        ],
      ),
      DoseSection(
        heading: 'Short-acting IM injection:',
        lines: [
          DoseLine(
            'Severe or refractory agitation for psychiatric emergencies in '
                'developmental delay, autism, or oppositional defiant/conduct disorder (PO '
                'administration is preferred; limited data):',
            isHeading: true,
          ),
          DoseLine('Child <12 yr: 1.25–5 mg IM'),
          DoseLine('Child ≥12 yr and adolescent: 5–10 mg IM; dose may be repeated after 2 hr '
              'if needed'),
          DoseLine(
            'Acute agitation associated with bipolar I or schizophrenia:',
            isHeading: true,
          ),
          DoseLine('Child and adolescent (limited retrospective data in 15 children and 35 '
              'adolescents): ≤12 yr: 5 mg; adolescent (13–17 yr): 10 mg. Dosing '
              'frequencies and max. doses were not reported.'),
          DoseLine('Adult: 10 mg (5 mg for geriatric patients and 2.5 mg for individuals who '
              'are debilitated, predisposed to hypotension, or pharmacodynamically '
              'sensitive to olanzapine). If needed, additional doses × 2 may be given; '
              'second dose 2 hr after the first dose and third dose 4 hr after the '
              'second dose. Recommended max. dose is 30 mg/24 hr (10 mg × 3 given 2–4 hr '
              'apart); safety of doses >30 mg/24 hr has not been evaluated.'),
        ],
      ),
      DoseSection(
        heading: 'Long-acting pamoate salt (Zyprexa Relprevv):',
        lines: [
          DoseLine('Schizophrenia (adult): See remarks and package insert for specific dosage '
              'based on established oral dosage.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in cardiovascular or cerebrovascular disease, '
          'hypotensive conditions, diabetes/hyperglycemia, elevated serum lipids and '
          'cholesterol, paralytic ileus, hepatic impairment, seizure disorders, '
          'narrow-angle glaucoma, and prostatic hypertrophy. Medication exhibits '
          'anticholinergic effects.',
      'Common side effects include orthostatic hypotension, peripheral edema, '
          'hypercholesterolemia, hyperprolactinemia, appetite simulation, weight '
          'gain (greater in adolescents than adults; monitoring is recommended), '
          'hypertriglyceridemia, constipation, xerostomia, akathisia, asthenia, '
          'dizziness, somnolence, tremor, and personality disorder. Neuroleptic '
          'malignant syndrome, dystonia, cognitive and motor impairment, tardive '
          'dyskinesia (irreversible with cumulative high doses), sleep walking, '
          'neutropenia, leukopenia, agranulocytosis, suicidal intent, acute '
          'pancreatitis, fecal incontinence, pulmonary embolism, increases in liver '
          'function tests (ALT, AST, GGT), DRESS, salivary hypersecretion, and '
          'hyperthermia have been reported.',
      'Olanzapine is a major substrate for cytochrome P-450 (CYP) 1A2 and minor '
          'substrate for 2D6. It also is a weak inhibitor to CYP1A2 and 2C9/2C19. Do '
          'not use in combination with alcohol, benzodiazepines, or opiates due to '
          'increased risk for sedation and cardiopulmonary depression. Caution is '
          'also indicated with anticholinergic agents (e.g., azelastine, '
          'glycopyrrolate), as olanzapine may enhance the anticholinergic effects. '
          'Use with Q–Tc-prolonging medications may further increase the risk for '
          'Q–Tc prolongation. Metoclopramide may enhance neurologic side effects of '
          'olanzapine. Do not use orally disintegrating tablets in phenylketonuria.',
      'T₁/₂: 37 hr for children and 21–54 hr for adults via PO route. '
          'Short-acting IM T₁/₂ in adults is similar to PO route, but long-acting IM '
          'T₁/₂ is ~30 days in adults.',
      'Maintenance treatment for bipolar I disorder and schizophrenia has not '
          'been systematically evaluated in adolescents. Therefore it is recommended '
          'to utilize the lowest dose to maintain efficacy and to reassess the need '
          'for maintenance treatment periodically for this age group.',
      'All oral dosages may be taken either with or without food. For orally '
          'disintegrating tabs, tablet must be placed in patient’s mouth immediately '
          'after removing it from the foil pack (by peeling off the foil, not by '
          'pushing the tablet through the foil) and allowed to dissolve in saliva; '
          'then swallowed with or without liquids.',
      'Zyprexa Relprevv (long-acting IM injection): Postinjection delirium and '
          'sedation syndrome have been reported with this dosage form. Patients must '
          'be observed by a healthcare provider at a healthcare facility for at '
          'least 3 hr after administration. The FDA REMS program requires '
          'prescribers, healthcare facilities, and pharmacies to register with the '
          'Zyprexa Relprevv Patient Care Program at 1-877-772-9390 for use of this '
          'product.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1138–1140',
  ),
  // OLOPATADINE — PDF p. 331 (printed 1140)
  DrugEntryV3(
    name: 'OLOPATADINE',
    brandNames: 'Pataday and generics',
    drugClass: 'Antihistamine',
    iconRow: '',
    formulations: [
      'Ophthalmic solution (products may contain benzalkonium chloride):',
      'Pataday and generics (OTC): 0.1% (5 mL), 0.2% (2.5 mL)',
      'Pataday: 0.7% (2.5 mL)',
      'Nasal spray: 0.6% (30.5 g provides 240 metered spray doses); contains '
          'benzalkonium chloride and EDTA',
    ],
    doseSections: [
      DoseSection(
        heading: 'Ophthalmic use for allergic conjunctivitis ( ≥2 yr and adult):',
        lines: [
          DoseLine('0.1% solution: 1 drop in affected eye(s) BID (spaced 6–8 hr apart)'),
          DoseLine('0.2% or 0.7% solution: 1 drop in affected eye(s) once daily'),
        ],
      ),
      DoseSection(
        heading: 'Intranasal use for allergic rhinitis:',
        lines: [
          DoseLine('Patients 6–11 yr: Inhale 1 spray into each nostril BID.'),
          DoseLine('Patients ≥12 yr and adult: Inhale 2 sprays into each nostril BID.'),
        ],
      ),
    ],
    remarks: [
      'Ocular use: DO NOT use while wearing contact lenses; wait at least 10 min '
          'after instilling drops before inserting lenses. Ocular side effects '
          'include burning or stinging, dry eye, foreign body sensation, hyperemia, '
          'keratitis, lid edema, and pruritus. May also cause headaches, asthenia, '
          'pharyngitis, rhinitis, and taste perversion. Use the ocular route of '
          'administration with caution in lactation.',
      'Nasal use: Common side effects include bitter taste and headaches. '
          'Somnolence, impaired mental alertness, nasal ulceration, epistaxis, nasal '
          'septal perforation, throat pain, and postnasal drip have been reported. '
          'Diarrhea was reported more frequently (9%) in an allergic rhinitis '
          'clinical trial for 2–5-yr-old children compared to 6–11-yr-old children '
          '(<1%). Breastfeeding information is unknown with the intranasal route of '
          'administration.',
      'To reduce the risk of drug being systemically absorbed with ophthalmic '
          'use, place pressure on the tear duct by the corner of the eye for ≥1 min, '
          'then remove the excess solution with an absorbent tissue. A combination '
          'intranasal product of olopatadine and mometasone (Ryaltris) is available '
          'for seasonal allergic rhinitis and currently indicated for children >12 '
          'yr and adults. Breast feeding is a “2” with the ophthalmic dosage forms '
          'and unknown with the nasal spray dosage form.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1140',
  ),
  // OMEPRAZOLE — PDF p. 331–332 (printed 1140–1141)
  DrugEntryV3(
    name: 'OMEPRAZOLE',
    brandNames: 'Prilosec, Prilosec OTC, and generics\nIn combination with sodium '
        'bicarbonate: Zegerid, Zegerid OTC, and generics',
    drugClass: 'Gastric acid pump inhibitor',
    iconRow: '',
    formulations: [
      'Caps, sustained release: 10, 20, 40 mg; may contain magnesium',
      'Tabs, delayed release (Prilosec OTC and generics; OTC): 20 mg; may '
          'contain magnesium',
      'Oral suspension:',
      'Compounded formulation: 2 mg/mL; contains ~0.5 mEq sodium bicarbonate per '
          '1 mg drug',
      'Granules for oral suspension (Prilosec): 2.5- and 10-mg packets (30s); '
          'contains magnesium',
      'In combination with sodium bicarbonate:',
      'Powder for oral suspension (Zegerid and generics): 20-, 40-mg packets '
          '(30s); each packet (regardless of strength) contains 1680 mg (20 mEq) '
          'sodium bicarbonate',
      'Caps, immediate release (Zegerid, Zegerid OTC, and generics): 20 mg '
          '(OTC), 40 mg; each capsule (regardless of strength) contains 1100 mg '
          '(13.1 mEq) sodium bicarbonate',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infant and child:',
        lines: [
          DoseLine('Esophagitis, GERD, or ulcers: Start at 1 mg/kg/24 hr PO ÷ once daily–BID '
              '(max. dose: 20 mg/24 hr). Reported effective range for GERD: 0.7–4 '
              'mg/kg/24 hr. Children 1–6 yr may require higher doses due to enhanced '
              'drug clearance. Alternative dosing by weight category:'),
          DoseLine('3–<5 kg: 2.5 mg PO once daily'),
          DoseLine('5–<10 kg: 5 mg PO once daily'),
          DoseLine('10–<20 kg: 10 mg PO once daily'),
          DoseLine('≥20 kg: 20 mg PO once daily'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Duodenal ulcer or GERD: 20–40 mg/dose PO once daily × 4–8 wk; may give up '
              'to 12 wk for erosive esophagitis'),
          DoseLine('Gastric ulcer: 20–40 mg/24 hr PO ÷ once daily–BID × 4–8 wk'),
          DoseLine('Pathologic hypersecretory conditions: Start with 60 mg/24 hr PO once '
              'daily. If needed, dose may be increased up to 120 mg/24 hr PO ÷ TID. '
              'Daily doses >80 mg should be administered in divided doses.'),
        ],
      ),
    ],
    remarks: [
      'Common side effects: Headache, diarrhea, nausea, and vomiting. Allergic '
          'reactions (discontinue use immediately), including anaphylaxis, acute '
          'interstitial nephritis, severe skin reactions, hypomagnesemia, and '
          'vitamin B₁₂ deficiency (with prolonged use), have been reported. Fundic '
          'gland polyps have been associated with long-term use of PPIs. Has been '
          'associated with increased risk for Clostridium difficile–associated '
          'diarrhea.',
      'Drug induces cytochrome P-450 (CYP) 1A2 (decreases theophylline levels) '
          'and is also a substrate and inhibitor of CYP2C19. Recommended dosage '
          'modification for ultrarapid metabolizers of CYP2C19 is to increase the '
          'usual dose by threefold. Increases T₁/₂ of citalopram, diazepam, '
          'phenytoin, and warfarin. May decrease the effects of itraconazole, '
          'ketoconazole, clopidogrel, iron salts, and ampicillin esters. St. John’s '
          'wort and rifampin may decrease omeprazole effects. May be used in '
          'combination with clarithromycin and amoxicillin for Helicobacter pylori '
          'infections. Omeprazole may interfere with serum chromogranin A (CgA) '
          'diagnostic test for neuroendocrine tumors; discontinue use at least 14 '
          'days prior to testing.',
      'Bioavailability may be increased with hepatic dysfunction or in patients '
          'of Asian descent. Safety and efficacy for GERD in children <1 mo have not '
          'been established.',
      'Administer all doses before meals. Administer 30 min prior to sucralfate. '
          'Capsules contain enteric-coated granules to ensure bioavailability. Do '
          'not chew or crush capsule. For doses unable to be divided by 10 mg, '
          'capsule may be opened and intact pellets may be administered in an acidic '
          'beverage (e.g., apple juice, cranberry juice) or applesauce. The '
          'extemporaneously compounded oral suspension product may be less '
          'bioavailable due to the loss of the enteric coating.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1140–1141',
  ),
  // OMNIPAQUE — PDF p. 333 (printed 1142)  [cross-reference]
  DrugEntryV3(
    name: 'OMNIPAQUE',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Iohexol.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1142',
  ),
  // ONDANSETRON — PDF p. 333–334 (printed 1142–1143)
  DrugEntryV3(
    name: 'ONDANSETRON',
    brandNames: 'Generics; previously available as Zofran',
    drugClass: 'Antiemetic agent, 5-HT3 antagonist',
    iconRow: '',
    formulations: [
      'Injection: 2 mg/mL (2, 20 mL); single-dose vials are preservative free '
          'and multidose vials contain parabens',
      'Tabs: 4, 8, 24 mg',
      'Tabs, orally disintegrating (ODT): 4, 8, 16 mg; contain aspartame',
      'Oral solution: 4 mg/5 mL (50 mL); contains sodium benzoate',
    ],
    doseSections: [
      DoseSection(
        heading: 'Preventing nausea and vomiting associated with chemotherapy:',
        lines: [
          DoseLine(
            'Oral (give initial dose 30 min before chemotherapy):',
            isHeading: true,
          ),
          DoseLine(
            'Child (≥2 yr of age and adolescent), dose based on body surface area:',
            isHeading: true,
          ),
          DoseLine('<0.3 m²: 1 mg TID PRN nausea'),
          DoseLine('0.3–0.6 m²: 2 mg TID PRN nausea'),
          DoseLine('0.6–1 m²: 3 mg TID PRN nausea'),
          DoseLine('>1 m²: 4–8 mg TID PRN nausea'),
          DoseLine(
            'Dose based on age:',
            isHeading: true,
          ),
          DoseLine('<4 yr: Use dose based on body surface area from preceding dosages'),
          DoseLine('4–11 yr: 4 mg TID PRN nausea'),
          DoseLine('>11 yr and adult: 8 mg TID or 24 mg once daily PRN nausea'),
          DoseLine(
            'IV (child and adult):',
            isHeading: true,
          ),
          DoseLine('Moderately emetogenic drugs: 0.15 mg/kg/dose (max. dose: 8 mg/dose for '
              'child and 16 mg/dose adult) 30 min before and 4 and 8 hr after emetogenic '
              'drugs. Then same dose Q4 hr PRN'),
          DoseLine('Highly emetogenic drugs: 0.15 mg/kg/dose (max. dose: 16 mg/dose) 30 min '
              'before 4 and 8 hr after emetogenic drugs. Then 0.15 mg/kg/dose (max. '
              'dose: 16 mg/dose) Q4 hr PRN'),
        ],
      ),
      DoseSection(
        heading: 'Preventing nausea and vomiting associated with surgery (additional '
            'doses for controlling nausea and vomiting may not provide any '
            'benefits):',
        lines: [
          DoseLine(
            'IV/IM (administered prior to anesthesia over 2–5 min):',
            isHeading: true,
          ),
          DoseLine(
            'Child (1 mo–12 yr):',
            isHeading: true,
          ),
          DoseLine('<40 kg: 0.1 mg/kg/dose × 1'),
          DoseLine('≥40 kg: 4 mg × 1'),
          DoseLine('Adult: 4 mg × 1'),
          DoseLine(
            'Oral:',
            isHeading: true,
          ),
          DoseLine('Adult: 16 mg × 1, 1 hr prior to induction of anesthesia'),
        ],
      ),
      DoseSection(
        heading: 'Preventing nausea and vomiting associated with radiation therapy:',
        lines: [
          DoseLine('Child: Use above dosage for preventing nausea and vomiting associated '
              'with chemotherapy and give initial dose 1–2 hr prior to radiation.'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Total body irradiation: 8 mg PO 1–2 hr prior to radiation once daily–BID'),
          DoseLine('Single high-dose fraction radiation to abdomen: 8 mg PO 1–2 hr prior to '
              'radiation with subsequent doses Q8 hr after first dose × 1–2 days after '
              'completion of radiation.'),
          DoseLine('Daily fractionated radiation to abdomen: 8 mg PO 1–2 hr prior to '
              'radiation with subsequent doses Q8 hr after first dose for each day '
              'radiation is given'),
        ],
      ),
      DoseSection(
        heading: 'Vomiting in acute gastroenteritis (oral route is preferred; use IV '
            'route when oral administration is not possible):',
        lines: [
          DoseLine(
            'Oral (child 6 mo–10 yr and weighing ≥8 kg; use oral disintegrating '
                'tablet):',
            isHeading: true,
          ),
          DoseLine('8–15 kg: 2 mg × 1'),
          DoseLine('>15 and ≤30 kg: 4 mg × 1'),
          DoseLine('>30 kg: 8 mg × 1'),
          DoseLine('IV (≥1 mo): 0.15–0.3 mg/kg/dose × 1; max. dose: 8 mg/dose'),
        ],
      ),
    ],
    remarks: [
      'Avoid use in congenital long QT syndrome. Bronchospasm, tachycardia, '
          'hypokalemia, seizures, headaches, lightheadedness, constipation, '
          'diarrhea, and transient increases in AST, ALT, and bilirubin may occur. '
          'Transient blindness (resolution within a few min up to 48 hr), '
          'arthralgia, Stevens-Johnson syndrome, TENS, hepatic dysfunction, masking '
          'of progressive ileus and gastric distention, myocardial ischemia '
          '(primarily with IV route) and rare/transient ECG changes (including Q–Tc '
          'interval prolongation) have been reported. Data limited for use in '
          'children below 3 yr of age.',
      'ECG monitoring is recommended in patients with electrolyte abnormalities, '
          'CHF, or bradyarrhythmias. Drug clearance is higher for surgical and '
          'cancer patients <18 yr as compared with adults. Clearance is slower for '
          'children 1–4-mo old compared with children >4–24-mo old.',
      'Ondansetron is a substrate for cytochrome P-450 (CYP) 1A2, 2D6, 2E1, and '
          '3A3/3A4 drug-metabolizing enzymes. It is likely that the inhibition/loss '
          'of one of the previously listed enzymes will be compensated by others and '
          'may result in insignificant changes to the elimination of ondansetron, '
          'which may be affected by CYP enzyme inducers. Ultrarapid metabolizers of '
          'CYP2D6 are associated with decreased response, and use of an alternative '
          'drug not predominantly metabolized by CYP2D6 (e.g., granisetron) is '
          'recommended. Follow theophylline, phenytoin, or warfarin levels closely, '
          'if used in combination. Use with apomorphine may result in profound '
          'hypotension and loss of consciousness and is contraindicated.',
      'To administer the oral film dosage form (Zuplenz), film must be placed on '
          'top of patient’s tongue, allowed to dissolve completely in 4–20 sec, and '
          'swallowed with or without liquid.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1142–1143',
  ),
  // ORKAMBI — PDF p. 334 (printed 1143)  [cross-reference]
  DrugEntryV3(
    name: 'ORKAMBI',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Lumacaftor and Ivacaftor.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1143',
  ),
  // OSELTAMIVIR PHOSPHATE — PDF p. 334–335 (printed 1143–1144)
  DrugEntryV3(
    name: 'OSELTAMIVIR PHOSPHATE',
    brandNames: 'Tamiflu and generics',
    drugClass: 'Antiviral, neuraminidase inhibitor',
    iconRow: '',
    formulations: [
      'Caps: 30, 45, 75 mg',
      'Oral suspension: 6 mg/mL (60 mL); may contain saccharin and sodium '
          'benzoate',
      'May also be extemporaneously compounded from capsules (6 mg/mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Treatment of influenza (initiate therapy within 2 days of onset of '
            'symptoms for best results; patients hospitalized or with severe '
            'complicated illness may benefit from therapy despite having symptoms '
            '>2 days):',
        lines: [
          DoseLine('Preterm neonate (limited data): Usual duration of therapy: 5 days'),
          DoseLine('Postmenstrual age (PMA) neonate <38 wk: 1 mg/kg/dose PO BID'),
          DoseLine('PMA 38–40 wk: 1.5 mg/kg/dose PO BID'),
          DoseLine('Full-term neonate (PMA >40 wk)–child 1 yr: 3 mg/kg/dose PO BID × 5 days'),
          DoseLine(
            'Child ≥1–12 yr:',
            isHeading: true,
          ),
        ],
        table: DoseTable(
          headers: ['Weight (kg)', 'Dosage for 5 Days', 'Volume of Oral Suspension (6 mg/mL)'],
          rows: [
            DoseTableRow(['≤15', '30 mg PO BID', '5 mL']),
            DoseTableRow(['>15–23', '45 mg PO BID', '7.5 mL']),
            DoseTableRow(['>23–40', '60 mg PO BID', '10 mL']),
            DoseTableRow(['>40', '75 mg PO BID', '12.5 mL']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('≥13 yr old and adult: 75 mg PO BID × 5 days'),
        ],
      ),
      DoseSection(
        heading: 'Prophylaxis of influenza (initiate therapy within 2 days of exposure '
            'for 10 days; duration may be extended for 6 wk in community '
            'outbreaks; see remarks):',
        lines: [
          DoseLine('Child 3 mo–<1 yr: 3 mg/kg/dose PO once daily; alternative dosage based on '
              'age:'),
          DoseLine('3–5 mo: 20 mg PO once daily'),
          DoseLine('6–11 mo: 25 mg PO once daily'),
          DoseLine(
            'Child 1–12 yr:',
            isHeading: true,
          ),
          DoseLine('≤15 kg: 30 mg PO once daily'),
          DoseLine('16–23 kg: 45 mg PO once daily'),
          DoseLine('24–40 kg: 60 mg PO once daily'),
          DoseLine('>40 kg: 75 mg PO once daily'),
          DoseLine('≥13 yr old and adult: 75 mg PO once daily; 12 wk duration of therapy may '
              'be used for immunocompromised patients.'),
        ],
      ),
    ],
    remarks: [
      'Currently indicated for the treatment of influenza A and B strains. Use '
          'in children <1 yr has not been recommended due to concerns of excessive '
          'CNS penetration and fatalities in 7-day-old rats.',
      'Nausea and vomiting generally occur within the first 2 days and are the '
          'most common adverse effects. Insomnia, vertigo, seizures, hypothermia, '
          'neuropsychiatric events (may result in fatal outcomes), arrhythmias, '
          'rash, and toxic epidermal necrolysis have also been reported. If the '
          'glomerular filtration rate (GFR) is 10–30 mL/min, reduce treatment dose '
          'to 75 mg PO once daily × 5 days for adults (see Chapter 32).',
      'PROPHYLACTIC USE: Oseltamivir is not a substitute for annual flu '
          'vaccination. Safety and efficacy have been demonstrated for ≤6 wk of '
          'therapy; duration of protection lasts for as long as dosing is continued. '
          'Adjust prophylaxis dose if GFR is 10–30 mL/min by extending the dosage '
          'interval to once every other day.',
      'Probenecid increases oseltamivir levels. Oseltamivir decreases the '
          'efficacy of the nasal influenza vaccine (live attenuated influenza '
          'vaccine, FluMist); avoid administration of vaccine within 2 wk before or '
          '48 hr after oseltamivir administration unless medically indicated.',
      'Dosage adjustments in hepatic impairment, severe renal disease, and '
          'dialysis have not been established for either treatment or prophylactic '
          'use. The safety and efficacy of repeated treatment or prophylaxis courses '
          'have not been evaluated. Doses may be administered with or without food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1143–1144',
  ),
  // OXACILLIN — PDF p. 336 (printed 1145)
  DrugEntryV3(
    name: 'OXACILLIN',
    brandNames: 'Various generics',
    drugClass: 'Antibiotic, penicillin (penicillinase resistant)',
    iconRow: '',
    formulations: [
      'Injection: 1, 2, 10 g',
      'Injection, premixed in iso-osmotic dextrose: 2 g/50 mL',
      'Injectable products contain 2.8–3.1 mEq Na per 1 g drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate (IM/IV):',
        lines: [
          DoseLine('Usual dose: 25 mg/kg/dose; following the dosage interval below'),
          DoseLine('Meningitis or severe infection: 50 mg/kg/dose; following the dosage '
              'interval below'),
          DoseLine(
            'Gestational age:',
            isHeading: true,
          ),
          DoseLine(
            '≤34 wk:',
            isHeading: true,
          ),
          DoseLine('≤7 days old: Q12 hr'),
          DoseLine('>7 days old: Q8 hr'),
          DoseLine(
            '>34 wk:',
            isHeading: true,
          ),
          DoseLine('≤7 days old: Q8 hr'),
          DoseLine('>7 days old: Q6 hr'),
        ],
      ),
      DoseSection(
        heading: 'Infant and child (IM/IV):',
        lines: [
          DoseLine('100–200 mg/kg/24 hr ÷ Q4–6 hr (max. dose: 12 g/24 hr); use 200 mg/kg/24 '
              'hr for endocarditis and severe infections and Q4 hr dosing for severe/CNS '
              'infections'),
        ],
      ),
      DoseSection(
        heading: 'Adult (IM/IV):',
        lines: [
          DoseLine('250–2000 mg/dose Q4–6 hr; use higher dosage range for endocarditis or '
              'severe infections and Q4 hr dosing for severe/CNS infections'),
          DoseLine('Max. dose (all ages): 12 g/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Rash and GI disturbances are common. Leukopenia, reversible '
          'hepatotoxicity, and acute interstitial nephritis have been reported. '
          'Hematuria and azotemia have occurred in neonates and infants with high '
          'doses. May cause false-positive urinary and serum proteins.',
      'Probenecid increases serum oxacillin levels. Tetracyclines may antagonize '
          'the bactericidal effects of oxacillin.',
      'CSF penetration is poor unless meninges are inflamed. Use the lower end '
          'of the usual dosage range for patients with creatinine clearances <10 '
          'mL/min. Adjust dose in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1145',
  ),
  // OXCARBAZEPINE — PDF p. 336–338 (printed 1145–1147)
  DrugEntryV3(
    name: 'OXCARBAZEPINE',
    brandNames: 'Trileptal, Oxtellar XR, and generics',
    drugClass: 'Anticonvulsant',
    iconRow: '',
    formulations: [
      'Tabs: 150, 300, 600 mg',
      'Extended-release tabs (Oxtellar XR and generics): 150, 300, 600 mg',
      'Oral suspension: 300 mg/5 mL (250 mL); contains saccharin, ethanol, and '
          'propylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child (see remarks):',
        lines: [
          DoseLine(
            '<2 yr:',
            isHeading: true,
          ),
          DoseLine('Adjunctive therapy for partial-onset seizures (limited data): Start with '
              '7.5–10 mg/kg/24 hr PO ÷ BID; gradually increase the dose 7.5–10 mg/kg/24 '
              'hr every 5–7 days up to a max. dose of 60–90 mg/kg/24 hr. Daily dosage '
              'may be divided TID for improved tolerability and to achieve therapeutic '
              'levels.'),
          DoseLine(
            '2–<4 yr:',
            isHeading: true,
          ),
          DoseLine('Adjunctive therapy for partial-onset seizures (limited data): Start with '
              '8–10 mg/kg/24 hr PO ÷ BID up to a max. dose of 600 mg/24 hr. For children '
              '<20 kg, may consider using a starting dose of 16–20 mg/kg/24 hr PO ÷ BID; '
              'gradually increase the dose over a 2–4-wk period and do not exceed 60 '
              'mg/kg/24 hr ÷ BID.'),
          DoseLine(
            '4–16 yr (see remarks):',
            isHeading: true,
          ),
          DoseLine('Adjunctive therapy for partial-onset seizures: Start with 8–10 mg/kg/24 '
              'hr PO ÷ BID up to a max. dose of 600 mg/24 hr. Then gradually increase '
              'the dose over a 2-wk period to the following maintenance doses:'),
          DoseLine('20–29 kg: 900 mg/24 hr PO ÷ BID'),
          DoseLine('>29–39 kg: 1200 mg/24 hr PO ÷ BID'),
          DoseLine('>39 kg: 1800 mg/24 hr PO ÷ BID'),
          DoseLine('Conversion to monotherapy for partial-onset seizures: Start with 8–10 '
              'mg/kg/24 hr PO ÷ BID and simultaneously initiate dosage reduction of '
              'concomitant AEDs and withdrawal completely over 3–6 wk. Dose may be '
              'increased at weekly intervals, as clinically indicated, by a maximum of '
              '10 mg/kg/24 hr to achieve the recommended monotherapy maintenance dose as '
              'described in the following table.'),
          DoseLine('Initiation of monotherapy for partial-onset seizures (with no concomitant '
              'AEDs): Start with 8–10 mg/kg/24 hr PO ÷ BID. Then increase by 5 mg/kg/24 '
              'hr Q3 days up to the recommended monotherapy maintenance dose as '
              'described in the following table.'),
        ],
      ),
      DoseSection(
        heading: 'Recommended Monotherapy Maintenance Doses for Children by Weight',
        table: DoseTable(
          headers: ['Weight (kg)', 'Daily Oral Maintenance Dose (mg/24 hr) Divided BID'],
          rows: [
            DoseTableRow(['20–<25', '600–900']),
            DoseTableRow(['25–<35', '900–1200']),
            DoseTableRow(['35–<45', '900–1500']),
            DoseTableRow(['45–<50', '1200–1500']),
            DoseTableRow(['50–<60', '1200–1800']),
            DoseTableRow(['60–<70', '1200–2100']),
            DoseTableRow(['≥70', '1500–2100']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Adjunctive therapy for partial-onset seizures: Start with 600 mg/24 hr PO '
              '÷ BID. Dose may be increased at weekly intervals, as clinically '
              'indicated, by a maximum of 600 mg/24 hr. Usual maintenance dose is 1200 '
              'mg/24 hr PO ÷ BID. Doses ≥2400 mg/24 hr are generally not well tolerated '
              'due to CNS side effects.'),
          DoseLine('Conversion to monotherapy for partial-onset seizures: Start with 600 '
              'mg/24 hr PO ÷ BID and simultaneously initiate dosage reduction of '
              'concomitant AEDs. Dose may be increased at weekly intervals as clinically '
              'indicated, by a max of 600 mg/24 hr to achieve a dose of 2400 mg/24 hr PO '
              '÷ BID. Concomitant AEDs should be terminated gradually over approximately '
              '3–6 wk.'),
          DoseLine('Initiation of monotherapy for partial-onset seizures: Start with 600 '
              'mg/24 hr PO ÷ BID. Then increase by 300 mg/24 hr every 3 days up to 1200 '
              'mg/24 hr PO ÷ BID.'),
        ],
      ),
      DoseSection(
        heading: 'EXTENDED RELEASE TABS (OXTELLAR XR; SEE REMARKS):',
        lines: [
          DoseLine(
            'Child 6–17 yr:',
            isHeading: true,
          ),
          DoseLine('Adjunctive therapy for partial-onset seizures: Start with 8–10 mg/kg/24 '
              'hr PO once daily up to a max. dose of 600 mg/24 hr. Then gradually '
              'increase at weekly intervals in increments of 8–10 mg/kg/24 hr (max. '
              'dosage increment: 600 mg) to the following maintenance doses:'),
          DoseLine('20–29 kg: 900 mg PO once daily'),
          DoseLine('>29–39 kg: 1200 mg PO once daily'),
          DoseLine('>39 kg: 1800 mg PO once daily'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Adjunctive therapy for partial-onset seizures: Start with 600 mg PO once '
              'daily (consider using 900 mg if patient is receiving concomitant '
              'enzyme-inducing AEDs). Then gradually increase at weekly intervals in 600 '
              'mg/24 hr increments to the maintenance dose of 1200–2400 mg once daily.'),
        ],
      ),
    ],
    remarks: [
      'Clinically significant hyponatremia may occur; generally seen within the '
          'first 3 mo of therapy. May also cause headache, dizziness, drowsiness, '
          'ataxia, fatigue, nystagmus, urticaria, diplopia, abnormal gait, and GI '
          'discomfort. About 25%–30% of patients with carbamazepine hypersensitivity '
          'will experience a cross-reaction with oxcarbazepine. Serious dermatologic '
          'reactions (Stevens-Johnson syndrome [SJS] and TENS), multiorgan '
          'hypersensitivity reactions (e.g., DRESS), bone marrow depression, '
          'osteoporosis, pancreatitis, folic acid deficiency, hypothyroidism, rare '
          'cases of anaphylaxis and angioedema, and suicidal behavior or ideation '
          'have been reported. Increased risk for severe dermatologic reactions '
          '(e.g., SJS and TENS) has been associated with the HLA-B*1502 alleles '
          '(prevalent among persons of Asian descent).',
      'Inhibits cytochrome P-450 (CYP) 2C19 and induces CYP3A4/3A5 '
          'drug-metabolizing enzymes. Carbamazepine, cyclosporine, phenobarbital, '
          'phenytoin, rifampin, valproic acid, and verapamil may decrease '
          'oxcarbazepine levels. Oxcarbazepine may increase phenobarbital and '
          'phenytoin levels. Oxcarbazepine can decrease the effects of oral '
          'contraceptives, cyclosporine, felodipine, and lamotrigine. Children 2–<4 '
          'yr and 4–<12 yr may require up to 100% and 50% higher dose per body '
          'weight, respectively, compared to adults.',
      'If GFR <30 mL/min, adjust dosage by administering 50% of the normal '
          'starting dose (max. dose: 300 mg/24 hr) followed by a slower than normal '
          'increase in dose if necessary (see Chapter 32). No dosage adjustment is '
          'required in mild/moderate hepatic impairment. Use is not recommended in '
          'severe hepatic impairment due to lack of information.',
      'Extended-release and immediate-release products are not bioequivalent, as '
          'higher doses of the extended-release product may be necessary. Doses may '
          'be administered with or without food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1145–1147',
  ),
  // OXYBUTYNIN CHLORIDE — PDF p. 338–339 (printed 1147–1148)
  DrugEntryV3(
    name: 'OXYBUTYNIN CHLORIDE',
    brandNames: 'Oxytrol, Oxytrol for Women, and generics; previously available as '
        'Ditropan',
    drugClass: 'Anticholinergic agent, antispasmodic',
    iconRow: '',
    formulations: [
      'Tabs: 2.5, 5 mg',
      'Tabs, extended release: 5, 10, 15 mg',
      'Syrup: 1 mg/mL (473 mL); contains parabens',
      'Transdermal system (Oxytrol, Oxytrol for Women [OTC]): Delivers 3.9 mg/24 '
          'hr (1, 4, 8s); contains 36 mg per system',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neurogenic/overactive bladder:',
        lines: [
          DoseLine(
            'Child ≤5 yr:',
            isHeading: true,
          ),
          DoseLine('Immediate release: 0.2 mg/kg/dose PO BID–TID; max. dose: 15 mg/24 hr'),
          DoseLine(
            'Child >5 yr:',
            isHeading: true,
          ),
          DoseLine('Immediate release: 5 mg/dose PO BID–TID; max. dose: 20 mg/24 hr'),
          DoseLine('Extended release (≥6 yr): Start with 5 mg/dose PO once daily; if needed, '
              'increase as tolerated by 5-mg weekly increments up to a maximum of 20 '
              'mg/24 hr.'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Immediate release: 5 mg/dose PO BID–TID; max. dose: 5 mg QID'),
          DoseLine('Extended release: 5–10 mg/dose PO once daily; adjust in 5-mg weekly '
              'increments if needed, up to a max. dose of 30 mg/dose once daily'),
          DoseLine(
            'Transdermal system:',
            isHeading: true,
          ),
          DoseLine('Female: 1 patch (3.9 mg/24 hr) every 4 days'),
          DoseLine('Male: 1 patch (3.9 mg/24 hr) every 3–4 days (twice weekly)'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in hepatic or renal disease, hyperthyroidism, GE reflux, '
          'IBD, concurrent use of bisphosphonates, or cardiovascular disease. '
          'Anticholinergic side effects may occur, including drowsiness, confusion, '
          'and hallucinations. Contraindicated in glaucoma, GI obstruction, '
          'megacolon, myasthenia gravis, severe colitis, hypovolemia, and GU '
          'obstruction. Memory impairment, angioedema, and Q–T interval prolongation '
          'have been reported. Oxybutynin is a cytochrome P-450 (CYP) 3A4 substrate; '
          'inhibitors and inducers of CYP3A4 may increase and decrease the effects '
          'of oxybutynin, respectively. May antagonize the effects of metoclopramide.',
      'Dosage adjustments for the extended-release dosage form are at weekly '
          'intervals. The extended-release tablets should not be crushed, chewed, or '
          'divided. Transdermal systems (patches) should not be cut. Apply '
          'transdermal system on dry intact skin on the abdomen, hip, or buttock; '
          'rotate the site and avoid same-site application within 7 days.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1147–1148',
  ),
  // OXYCODONE — PDF p. 339–340 (printed 1148–1149)
  DrugEntryV3(
    name: 'OXYCODONE',
    brandNames: 'OxyContin, Roxicodone, RoxyBond, Oxaydo, Xtampza ER, and many '
        'others, including generics',
    drugClass: 'Narcotic, analgesic',
    iconRow: '',
    formulations: [
      'Expressed as hydrochloride salt unless indicated otherwise.',
      'Oral solution: 1 mg/mL (5, 15, 473 mL); contains alcohol',
      'Concentrated oral solution: 20 mg/mL (30 mL); may contain saccharin',
      'Tabs:',
      'Generics: 5, 10, 15, 20, 30 mg',
      'Roxicodone: 15, 30 mg',
      'RoxyBond: 5, 15, 30 mg',
      'Oxaydo: 5, 7.5 mg',
      'Controlled-release tabs (OxyContin): 10, 15, 20, 30, 40, 60, 80 mg (80-mg '
          'strength for opioid-tolerant patients only)',
      'Caps: 5 mg',
      'Extended-release caps (Xtampza ER): 9, 13.5, 18, 27, 36 mg oxycodone '
          'base; equivalent to 10, 15, 20, 30, and 40 mg oxycodone hydrochloride '
          'salt, respectively',
    ],
    doseSections: [
      DoseSection(
        heading: 'Opioid-naïve doses based upon oxycodone hydrochloride salt (limited '
            'data):',
        lines: [
          DoseLine('Infant ≤6 mo: 0.025–0.05 mg/kg/dose PO Q4–6 hr PRN'),
          DoseLine('Infant >6 mo, child, and adolescent <50 kg: 0.05–0.15 mg/kg/dose PO Q4–6 '
              'hr PRN up to 5 mg/dose'),
          DoseLine('Adolescent (≥50 kg) and adult: 5–10 mg PO Q4–6 hr PRN; see remarks for '
              'use of controlled-release tablets'),
        ],
      ),
    ],
    remarks: [
      'There is a potential for abuse; CNS and respiratory depression, increased '
          'ICP, histamine release, constipation, and GI distress may occur. Use with '
          'caution in severe renal impairment (increases T₁/₂) and mild/moderate '
          'hepatic dysfunction (use of one-third to one-half of usual dose has been '
          'recommended). Naloxone is the antidote. See Chapter 6 for equianalgesic '
          'dosing. Check dosages of acetaminophen or aspirin when using combination '
          'products (e.g., Percocet, Percodan). Oxycodone is metabolized by the '
          'cytochrome P-450 3A4 (major) and 2D6 (minor) isoenzymes.',
      'When controlled-release tablets (e.g., Oxycontin) are being used, '
          'patient’s total 24-hr requirement should be determined and divided by 2 '
          'to administer on a Q12 hr dosing interval. Oxycontin 80-mg tablet is USED '
          'ONLY for opioid-tolerant patients; this strength can cause fatal '
          'respiratory depression in opioid-naïve patients. Controlled-release '
          'dosage form should not be used as a PRN analgesic and must be swallowed '
          'whole.',
      'The FDA has assigned a Risk Evaluation and Mitigation Strategy (REMS) for '
          'opioid analgesia; see www.fda.gov/OpioidAnalgesicREMSPCG. The REMS '
          'strongly encourages prescriber to (1) complete a REMS-compliant education '
          'program; (2) counsel patients/caregivers on prescription safe use, risks, '
          'storage, and disposal; (3) emphasize the importance of reading the '
          'medication guide provided by pharmacists at all times; and (4) consider '
          'other methods for improving patient, household, and community safety.',
    ],
    pregnancyNote: 'Pregnancy category changes to “D” if used for prolonged periods or '
        'in high doses at term.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1148–1149',
  ),
  // OXYCODONE AND ACETAMINOPHEN — PDF p. 340 (printed 1149)
  DrugEntryV3(
    name: 'OXYCODONE AND ACETAMINOPHEN',
    brandNames: 'Endocet, Percocet, Prolate, and many others, including generics',
    drugClass: 'Combination analgesic with a narcotic',
    iconRow: '',
    formulations: [
      'Tabs (Percocet, Endocet, and others, including generics):',
      'Most common strength: Oxycodone HCl 5 mg + acetaminophen 325 mg',
      'Other strengths:',
      'Oxycodone HCl 2.5 mg + acetaminophen 325 mg',
      'Oxycodone HCl 7.5 mg + acetaminophen 325 mg or 300 mg',
      'Oxycodone HCl 10 mg + acetaminophen 325 mg',
      'Oral solution:',
      'Prolate and generics: Oxycodone HCl 10 mg + acetaminophen 300 mg/5 mL '
          '(120, 500 mL); contain EDTA, propylene glycol, and saccharin',
    ],
    doseSections: [
      DoseSection(
        heading: '',
        lines: [
          DoseLine('Dose based on amount of oxycodone and acetaminophen. Do not exceed 4 g/24 '
              'hr of acetaminophen.'),
        ],
      ),
    ],
    remarks: [
      'See Oxycodone and Acetaminophen. Check dosages of acetaminophen and '
          'oxycodone when using these combination products.',
      'The FDA has assigned a Risk Evaluation and Mitigation Strategy (REMS) for '
          'Opioid Analgesia; see www.fda.gov/OpioidAnalgesicREMSPCG. The REMS '
          'strongly encourages prescriber to (1) complete a REMS-compliant education '
          'program; (2) counsel patients/caregivers on prescription safe use, risks, '
          'storage and disposal; (3) emphasize the importance of reading the '
          'Medication Guide provided by pharmacists at all times; and (4) consider '
          'other methods for improving patient, household, and community safety.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1149',
  ),
  // OXYCODONE AND ASPIRIN — PDF p. 340–341 (printed 1149–1150)
  DrugEntryV3(
    name: 'OXYCODONE AND ASPIRIN',
    brandNames: 'Various generics; previously available as Percodan and Endodan',
    drugClass: 'Combination analgesic (narcotic and salicylate)',
    iconRow: '',
    formulations: [
      'Tabs: Oxycodone 4.8355 mg and aspirin 325 mg',
    ],
    doseSections: [
      DoseSection(
        heading: '',
        lines: [
          DoseLine('Dose based on amount of oxycodone and aspirin. Do not exceed 4 g/24 hr of '
              'aspirin.'),
        ],
      ),
    ],
    remarks: [
      'See Oxycodone and Aspirin. Must not be used in children <16 yr because of '
          'risk for Reye syndrome. Check dosages of aspirin and oxycodone when using '
          'these combination products. The aspirin component may cause serious skin '
          'reactions (e.g., SJS, TENS).',
      'The FDA has assigned a Risk Evaluation and Mitigation Strategy (REMS) for '
          'Opioid Analgesia; see www.fda.gov/OpioidAnalgesicREMSPCG. The REMS '
          'strongly encourages prescriber to (1) complete a REMS-compliant education '
          'program; (2) counsel patients/caregivers on prescription safe use, risks, '
          'storage and disposal; (3) emphasize the importance of reading the '
          'Medication Guide provided by pharmacists at all times; and (4) consider '
          'other methods for improving patient, household, and community safety.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1149–1150',
  ),
  // OXYMETAZOLINE — PDF p. 341 (printed 1150)
  DrugEntryV3(
    name: 'OXYMETAZOLINE',
    brandNames: 'Afrin, Vicks Sinex 12 Hour , Nostrilla, and many others, including '
        'generics',
    drugClass: 'Nasal decongestant, vasoconstrictor',
    iconRow: '',
    formulations: [
      'Nasal spray (OTC): 0.05% (15 mL); may contain benzalkonium chloride, '
          'EDTA, and propylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Nasal decongestant (not to exceed 3 days in duration):',
        lines: [
          DoseLine('≥6 yr–adult: 2–3 sprays or 2–3 drops in each nostril BID (separated by '
              '10–12 hr). Do not exceed 2 doses/24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in patients on MAO inhibitor therapy. Rebound nasal '
          'congestion may occur with excessive use (>3 days) via the nasal route. '
          'Systemic absorption may occur. Headache, insomnia, hypertension, '
          'transient burning, stinging, dryness, nasal mucosal ulceration, and '
          'sneezing have occurred.',
      'Accidental ingestion in children <5 yr has been reported and required '
          'hospitalization for adverse events (nausea, vomiting, lethargy, '
          'tachycardia, respiratory depression, bradycardia, hypotension, '
          'hypertension, sedation, mydriasis, stupor, hypothermia, drooling, and '
          'coma).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1150',
  ),
];
