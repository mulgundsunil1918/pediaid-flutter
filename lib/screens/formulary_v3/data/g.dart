// =============================================================================
// output/g.dart — Drug Formulary 3.0, letter G
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyG` per file; entries in book order.
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

const List<DrugEntryV3> formularyG = [
  // GABAPENTIN — PDF p. 207–208 (printed 1016–1017)
  DrugEntryV3(
    name: 'GABAPENTIN',
    brandNames: 'Neurontin, Gralise, Gabarone, and generics',
    drugClass: 'Anticonvulsant',
    iconRow: '',
    formulations: [
      'Caps: 100, 300, 400 mg',
      'Tabs: 100, 400, 600, 800 mg',
      'Slow-release/extended-release tabs (these dosage forms are not '
          'interchangeable with other gabapentin products due to different '
          'pharmacokinetic profiles affecting the dosing interval; see specific '
          'product information for specific indications for use and dosage):',
      'Gralise and generics: 300, 450, 600, 750, 900 mg',
      'Oral solution: 250 mg/5 mL (470 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Seizures, adjunctive therapy (maximum time between doses should not '
            'exceed 12 hr):',
        lines: [
          DoseLine(
            '3–<12 yr (PO, see remarks):',
            isHeading: true,
          ),
          DoseLine('Day 1: 10–15 mg/kg/24 hr ÷ TID, then gradually titrate dose upward to the '
              'following dosages over a 3-day period:'),
          DoseLine('3–4 yr: 40 mg/kg/24 hr ÷ TID'),
          DoseLine('≥5–<12 yr: 25–35 mg/kg/24 hr ÷ TID'),
          DoseLine('Dosages up to 50 mg/kg/24 hr have been well tolerated.'),
          DoseLine('≥12 yr and adult (PO, see remarks): Start with 300 mg TID; if needed, '
              'increase dose up to 1800 mg/24 hr ÷ TID. Usual effective doses: 900–1800 '
              'mg/24 hr ÷ TID. Doses as high as 3.6 g/24 hr have been tolerated.'),
        ],
      ),
      DoseSection(
        heading: 'Neuropathic pain (see remarks):',
        lines: [
          DoseLine(
            'Child (PO; limited data):',
            isHeading: true,
          ),
          DoseLine('Day 1: 5 mg/kg/dose (max. 300 mg/dose) at bedtime'),
          DoseLine('Day 2: 5 mg/kg/dose (max. 300 mg/dose) BID'),
          DoseLine('Day 3: 5 mg/kg/dose (max. 300 mg/dose) TID; then titrate dose to effect '
              'with TID schedule. A dosage range of 8–35 mg/kg/24 hr ÷ TID has been '
              'reported in patients taking concurrent analgesics.'),
          DoseLine(
            'Maximum daily dose of 3600 mg/24 hr has been suggested but not formally '
                'evaluated.',
            isHeading: true,
          ),
          DoseLine(
            'Adult (PO):',
            isHeading: true,
          ),
          DoseLine('Day 1: 300 mg at bedtime'),
          DoseLine('Day 2: 300 mg BID'),
          DoseLine('Day 3: 300 mg TID; then titrate dose to effect with TID schedule. Usual '
              'dosage range: 1800–2400 mg/24 hr; max. dose: 3600 mg/24 hr'),
          DoseLine('Postherpetic neuralgia: The above dosage regimen may be titrated up PRN '
              'for pain relief to a daily dose of 1800 mg/24 hr ÷ TID (efficacy has been '
              'shown from 1800 to 3600 mg/24 hr; however, no additional benefit has been '
              'shown for doses >1800 mg/24 hr). The Gralise dosage form is designed for '
              'once-daily administration with the evening meals. '
              'Slow-release/extended-release dosage forms are NOT interchangeable due to '
              'differences in pharmacokinetic profiles. See specific product information '
              'for details.'),
        ],
      ),
    ],
    remarks: [
      'Generally used as adjunctive therapy for partial and secondary '
          'generalized seizures and neuropathic pain. Commonly used in paroxysmal '
          'sympathetic hyperactivity (PSH or dysautonomia) as a preventive therapy; '
          'limited data regarding the dosage regimen for neuropathic pain.',
      'Somnolence, dizziness, ataxia, fatigue, and nystagmus were common when '
          'used for seizures (≥12 yr). Viral infections, fever, nausea and/or '
          'vomiting, somnolence, and hostility have been reported in patients 3–12 '
          'yr receiving other antiepileptics. Dizziness, somnolence, and peripheral '
          'edema are common side effects in adults with postherpetic neuralgia. '
          'Suicidal behavior or ideation, agitation, and multiorgan hypersensitivity '
          '(e.g., anaphylaxis, angioedema, or drug reaction with eosinophilia and '
          'systemic symptoms [DRESS]) have been reported. Life-threatening or fatal '
          'respiratory depression in patients taking gabapentin with opioids or '
          'other CNS depressants, or with an underlying respiratory impairment, has '
          'been reported.',
      'Do not withdraw medication abruptly (withdraw gradually over a minimum of '
          '1 wk). Drug is not metabolized by the liver and is primarily excreted in '
          'the urine unchanged. Higher doses (~30% more) may be required for '
          'children <5 yr because of faster clearance in this age group.',
      'May be taken with or without food. In TID dosing schedule, interval '
          'between doses should not exceed 12 hr. Adjust dose in renal impairment '
          '(see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1016–1017',
  ),
  // GANCICLOVIR — PDF p. 208–209 (printed 1017–1018)
  DrugEntryV3(
    name: 'GANCICLOVIR',
    brandNames: 'Generics, Zirgan; previously available as Cytovene',
    drugClass: 'Antiviral agent',
    iconRow: '',
    formulations: [
      'Injection (generics; previously available as Cytovene): 500 mg; contains '
          '4 mEq Na per 1 g drug',
      'Injection in solution: 500 mg/10 mL (10 mL)',
      'Premixed injection in 0.8% sodium chloride: 500 mg/250 mL (250 mL); '
          'preservative free',
      'Ophthalmic gel (drops):',
      'Zirgan: 0.15% (5 g); contains benzalkonium chloride',
    ],
    doseSections: [
      DoseSection(
        heading: 'Cytomegalovirus (CMV) infections:',
        lines: [
          DoseLine('Neonate (congenital CMV): 12 mg/kg/24 hr IV ÷ Q12 hr with transition to '
              'oral valganciclovir to complete a total 6-mo course'),
          DoseLine(
            'Child >3 mo and adult:',
            isHeading: true,
          ),
          DoseLine('Induction therapy (duration 14–21 days): 10 mg/kg/24 hr IV ÷ Q12 hr'),
          DoseLine('IV maintenance therapy: 5 mg/kg/dose IV once daily for 7 days/wk or 6 '
              'mg/kg/dose IV once daily for 5 days/wk'),
        ],
      ),
      DoseSection(
        heading: 'Prevention of CMV in transplant recipients:',
        lines: [
          DoseLine(
            'Child and adult:',
            isHeading: true,
          ),
          DoseLine('Induction therapy (duration 5–7 days): 10 mg/kg/24 hr IV ÷ Q12 hr'),
          DoseLine('IV maintenance therapy: 5 mg/kg/dose once daily for 7 days/wk or 6 '
              'mg/kg/dose once daily for 5 days/wk for 100–120 days posttransplant'),
        ],
      ),
      DoseSection(
        heading: 'CMV in HIV-infected individuals: See',
        lines: [
          DoseLine('https://hivinfo.nih.gov/home-page for latest recommendations and '
              'guidelines for CMV treatment and prophylaxis'),
        ],
      ),
      DoseSection(
        heading: 'Herpetic keratitis (ophthalmic gel/drops):',
        lines: [
          DoseLine('≥2 yr and adult: Apply 1 drop onto affected eye(s) 5 times a day (∼Q3 hr '
              'while awake) until corneal ulcer is healed, then 1 drop TID × 7 days'),
        ],
      ),
    ],
    remarks: [
      'Limited experience with use in children <12 yr old. Contraindicated in '
          'severe neutropenia (ANC <500/microliter) or severe thrombocytopenia '
          '(platelets <25,000/microliter). Use with extreme caution. Reduce dose in '
          'renal failure (see Chapter 32). Has not been evaluated in hepatic '
          'impairment. For oral route of administration, see Valganciclovir.',
      'Common side effects: Neutropenia, thrombocytopenia, retinal detachment, '
          'and confusion. Drug reactions alleviated with dose reduction or temporary '
          'interruption. Ganciclovir may increase didanosine and zidovudine levels, '
          'and didanosine and zidovudine may decrease ganciclovir levels. '
          'Immunosuppressive agents may increase hematologic toxicities. '
          'Amphotericin B, cyclosporine, and tacrolimus increase risk for '
          'nephrotoxicity. Imipenem/cilastatin may increase risk for seizures. May '
          'cause female and male infertility.',
      'Minimum dilution is 10 mg/mL and should be infused IV over ≥1 hr. IM and '
          'SC administration are contraindicated because of high pH of 11.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1017–1018',
  ),
  // GATIFLOXACIN — PDF p. 209 (printed 1018)
  DrugEntryV3(
    name: 'GATIFLOXACIN',
    brandNames: 'Zymaxid and generics',
    drugClass: 'Antibiotic, quinolone',
    iconRow: '',
    formulations: [
      'Ophthalmic solution: 0.5% (2.5 mL); may contain benzalkonium chloride',
      'Previously available as a 0.3% ophthalmic solution (Zymar)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Conjunctivitis:',
        lines: [
          DoseLine('≥1 yr–adult: Instill 1 drop to affected eye(s) Q2 hr while awake (up to 8 '
              'times/24 hr) for the first day, then 1 drop BID–QID while awake on days '
              '2–7'),
        ],
      ),
    ],
    remarks: [
      'Worsening of conjunctivitis, decreased visual acuity, excessive tear '
          'production, and keratitis are common side effects. Conjunctival '
          'hemorrhage has been reported.',
      'Avoid touching the applicator tip to eye, fingers, or other surfaces, and '
          'do not wear contact lenses during treatment of ocular infections. Apply '
          'pressure to the lacrimal sac during and for 1–2 min after dose '
          'administration to reduce risk of systemic absorption.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1018',
  ),
  // GCSF — PDF p. 209 (printed 1018)  [cross-reference]
  DrugEntryV3(
    name: 'GCSF',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Filgrastim',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1018',
  ),
  // GENTAMICIN — PDF p. 209–210 (printed 1018–1019)
  DrugEntryV3(
    name: 'GENTAMICIN',
    brandNames: 'Generics; previously available as Garamycin and Gentak',
    drugClass: 'Antibiotic, aminoglycoside',
    iconRow: '',
    formulations: [
      'Injection: 10 mg/mL (2 mL, preservative free), 40 mg/mL (2, 20 mL); some '
          'products may contain sodium metabisulfite',
      'Premixed injection in NS: 60 mg (50 mL), 80 mg (50, 100 mL), 100 mg (50, '
          '100 mL), 120 mg (100 mL)',
      'Ophthalmic drops: 0.3% (5 mL)',
      'Topical ointment: 0.1% (15, 30 g)',
      'Topical cream: 0.1% (15, 30 g)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Initial empiric dosage; patient-specific dosage defined by '
            'therapeutic drug monitoring (see remarks).',
      ),
      DoseSection(
        heading: 'Parenteral (IM or IV):',
      ),
      DoseSection(
        heading: 'Neonate/Infant',
        table: DoseTable(
          headers: ['Postconceptional Age (wk)', 'Postnatal Age (days)', 'Dose (mg/kg/dose)', 'Interval (hr)'],
          rows: [
            DoseTableRow(['≤29ᵃ', '0–7', '5', '48']),
            DoseTableRow(['', '8–28', '4', '36']),
            DoseTableRow(['', '>28', '4', '24']),
            DoseTableRow(['30–34', '0–7', '4.5', '36']),
            DoseTableRow(['', '>7', '4', '24']),
            DoseTableRow(['≥35', 'ALL', '4', '24ᵇ']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃOr significant asphyxia, patent ductus arteriosus (PDA), indomethacin '
              'use, poor cardiac output, reduced renal function.'),
          DoseLine('Alternatively, dosing by levels may be necessary for situations of '
              'unstable renal function.'),
          DoseLine('ᵇUse Q36 hr interval for hypoxic-ischemic encephalopathy (HIE) patients '
              'receiving whole-body therapeutic cooling.'),
          DoseLine('Child (eGFR >75 mL/min/1.73m²): 7.5 mg/kg/24 hr ÷ Q8 hr'),
          DoseLine('Adult (eGFR >75 mL/min/1.73m²): 3–6 mg/kg/24 hr ÷ Q8 hr'),
          DoseLine('Cystic fibrosis (eGFR >75 mL/min/1.73m²): 7.5–10.5 mg/kg/24 hr ÷ Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Intrathecal/intraventricular (use preservative-free product only):',
        lines: [
          DoseLine('Newborn: 1 mg once daily'),
          DoseLine('>3 mo: 1–2 mg once daily'),
          DoseLine('Adult: 4–8 mg once daily'),
        ],
      ),
      DoseSection(
        heading: 'Ophthalmic ointment:',
        lines: [
          DoseLine('Apply 0.5-inch ribbon to the conjunctival sac of the affected eye(s) '
              'Q8–12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Ophthalmic drops:',
        lines: [
          DoseLine('Instill 1–2 drops to affected eye(s) Q4 hr; up to 2 drops Q1 hr for '
              'severe infections'),
        ],
      ),
      DoseSection(
        heading: 'Topical cream or ointment:',
        lines: [
          DoseLine('>1 yr and adult: Apply to affected area TID–QID'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in patients receiving anesthetics or neuromuscular '
          'blocking agents and in patients with neuromuscular disorders. May cause '
          'nephrotoxicity and ototoxicity. Ototoxicity may be potentiated with the '
          'use of loop diuretics. Eliminated more quickly in patients with cystic '
          'fibrosis, neutropenia, and burns. Adjust dose in renal failure (see '
          'Chapter 32). Monitor peak and trough levels.',
      'Therapeutic peak levels are 6–10 mg/L in general and 8–10 mg/L in '
          'pulmonary infections, cystic fibrosis, neutropenia, osteomyelitis, and '
          'severe sepsis.',
      'To maximize bactericidal effects, an individualized peak concentration to '
          'target a peak/minimal inhibitory concentration (MIC) ratio of 8–10:1 may '
          'be applied.',
      'Therapeutic trough levels: <2 mg/L. Recommended serum sampling time at '
          'steady state: trough within 30 min prior to the 3rd consecutive dose and '
          'peak 30–60 min after the administration of the 3rd consecutive dose.',
      'For initial dosing in obese patients, use an adjusted body weight (ABW). '
          'ABW = Ideal Body Weight + 0.4 (Total Body Weight ∼ Ideal Body Weight)',
    ],
    pregnancyNote: 'Pregnancy category is a “C” for ophthalmic use, a “D” with IV use, '
        'and not classified for topical use.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1018–1019',
  ),
  // GLUCAGON HCL — PDF p. 211–212 (printed 1020–1021)
  DrugEntryV3(
    name: 'GLUCAGON HCL',
    brandNames: 'Gvoke, Baqsimi, and generics',
    drugClass: 'Antihypoglycemic agent',
    iconRow: '',
    formulations: [
      'Injection: 1-mg vial (requires reconstitution)',
      'Injection kit:',
      'Gvoke Kit: 1 mg/0.2 mL vial with syringe; for SC injection only',
      'Injection in prefilled syringe (Gvoke PFS): 0.5 mg/0.1 mL (1- or 2-pack), '
          '1 mg/0.2 mL (1- or 2-pack); for subcutaneous injection only',
      'Injection in autoinjector (Gvoke HypoPen): 0.5 mg/0.1 mL (1- or 2-pack), '
          '1 mg/0.2 mL (1- or 2-pack); for subcutaneous injection only',
      'Nasal powder (Baqsimi): 3 mg/dose (1- or 2-pack); contains betadex and '
          'dodecylphosphocholine',
      '1 unit = 1 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hypoglycemia (see remarks):',
        lines: [
          DoseLine(
            'Injectable route (IM, IV, SC; see remarks):',
            isHeading: true,
          ),
          DoseLine('Neonate, infant, and child <20 kg: 0.5 mg/dose (or 0.02–0.03 mg/kg/dose) '
              'Q15–20 min PRN'),
          DoseLine('Child ≥20 kg and adult: 1 mg/dose Q15–20 min PRN'),
          DoseLine(
            'Intranasal route (see remarks):',
            isHeading: true,
          ),
          DoseLine('≥4 yr and adult: Actuate 3 mg (1 actuation) intranasally into one nostril '
              '× 1. If no response after 15 min, an additional 3-mg dose may be given.'),
        ],
      ),
      DoseSection(
        heading: 'β-Blocker or calcium channel blocker overdose (for hypotension that '
            'is unresponsive to fluid boluses; limited data):',
        lines: [
          DoseLine('Infant and child: Load with 0.05 mg/kg IV × 1; if no response, may repeat '
              'dose. Some recommend initiating a continuous IV infusion of 0.05–0.1 '
              'mg/kg/hr at the time of the responsive dose.'),
          DoseLine('Adolescent: Loading dose of 5–10 mg IV × 1, followed by a continuous IV '
              'infusion of 1–5 mg/hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in insulinoma, pheochromocytoma, glucagonoma, and history '
          'of hypersensitivity to glucagon and components. Drug product is '
          'genetically engineered and identical to human glucagon. High doses have a '
          'cardiac stimulatory effect and have been used with some success in '
          'β-blocker and calcium channel blocker overdose. May increase myocardial '
          'oxygen demand, blood pressure, and pulse, which may be life-threatening '
          'in patients with cardiac disease. May cause nausea, vomiting, urticaria, '
          'and respiratory distress. Necrolytic migratory erythema (NME) has been '
          'reported with continuous IV infusion; assess benefit/risk for continued '
          'use.',
      'Do not delay glucose infusion; dose for hypoglycemia is 2–4 mL/kg of '
          'dextrose 25%.',
      'Glucagon may increase the effects/toxicity of warfarin. Indomethacin use '
          'may decrease the effects of glucagon.',
      'Sufficient hepatic glycogen is necessary for effect; patients in states '
          'of starvation, with adrenal or chronic hypoglycemia, may not have '
          'adequate levels of glycogen. Onset of action: IM: 8–10 min; SC: ~10 min; '
          'IV: 1 min. Duration of action: IM: 12–27 min; SC: up to 90 min; IV: 9–17 '
          'min.',
      'INTRANASAL USE: See product information for dose administration '
          'instructions. Dose does not need to be inhaled and can be administered if '
          'the patient has nasal congestion or the common cold. Common side effects '
          'include nausea, vomiting, headache, rhinorrhea, nasal '
          'discomfort/congestion, cough, epistaxis, and irritation to the eyes, '
          'nose, and throat. In type 1 pediatric diabetes trials, the time to '
          'increase glucose ≥20 mg/dL from nadir was',
      '11–15 min, and peak plasma levels were achieved in 15–20 min with a '
          'median T₁/₂ of 21–31 min.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1020–1021',
  ),
  // GLYCERIN — PDF p. 212 (printed 1021)
  DrugEntryV3(
    name: 'GLYCERIN',
    brandNames: 'Pedia-Lax, Fleet Liquid Glycerin Supp, and others, including '
        'generics',
    drugClass: 'Osmotic laxative',
    iconRow: '',
    formulations: [
      'Rectal liquid suppository [OTC]:',
      'Pedia-Lax: 4 mL with average 2.7 mL (2.8 g) dose delivered (6s)',
      'Fleet Liquid Glycerin: 7.5 mL with average 5.4 mL (5.4 g) dose delivered '
          '(4s)',
      'Suppository [OTC]:',
      'Infant/pediatric:',
      'Pedia-Lax and generics: 1 g (12s)',
      'Generics: 1.2 g (12s, 25s)',
      'Adult:',
      'Generics: 2 g (12s, 25s, 50s, 100s)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Constipation:',
        lines: [
          DoseLine('Neonate: 0.5 mL/kg/dose rectal solution PR as an enema once daily PRN or '
              'sliver/chip of infant/pediatric suppository PR once daily PRN'),
          DoseLine('Child <6 yr: 2–5 mL rectal solution PR as an enema or 1 infant/pediatric '
              'suppository PR once daily PRN'),
          DoseLine('>6 yr–adult: 5–15 mL rectal solution PR as an enema or 1 adult '
              'suppository PR once daily PRN'),
        ],
      ),
    ],
    remarks: [
      'Onset of action: 15–30 min. May cause rectal irritation, abdominal pain, '
          'bloating, and dizziness. Insert suppository high into rectum and retain '
          'for 15 min.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1021',
  ),
  // GLYCOPYRROLATE — PDF p. 212–213 (printed 1021–1022)
  DrugEntryV3(
    name: 'GLYCOPYRROLATE',
    brandNames: 'Glycate, Glyrx-PF, Cuvposa, and generics; previously available as '
        'Robinul',
    drugClass: 'Anticholinergic agent',
    iconRow: '',
    formulations: [
      'Tabs (Glycate, and generics): 1, 1.5, 2 mg',
      'Oral solution (Cuvposa and generics): 1 mg/5 mL (473 mL); contains '
          'propylene glycol and parabens',
      'Injection (Glyrx-PF and generics): 0.2 mg/mL (1, 2, 3, 5, 20 mL); some '
          'multidose vials contain 0.9% benzyl alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Respiratory antisecretory:',
        lines: [
          DoseLine(
            'IM/IV:',
            isHeading: true,
          ),
          DoseLine('Child: 0.004–0.01 mg/kg/dose TID–QID'),
          DoseLine('Adult: 0.1–0.2 mg/dose TID–QID'),
          DoseLine('Max. dose: 0.2 mg/dose or 0.8 mg/24 hr'),
          DoseLine(
            'Oral:',
            isHeading: true,
          ),
          DoseLine('Child: 0.04–0.1 mg/kg/dose TID–QID'),
          DoseLine('Alternative dosage for 3–16-yr-old with chronic severe drooling secondary '
              'to neurologic conditions: Start with 0.02 mg/kg/dose TID and titrate in '
              'increments of 0.02 mg/kg/dose every 5–7 days as needed and tolerated up '
              'to a max. dose of 0.1 mg/kg/dose TID not to exceed 1.5–3 mg/dose'),
          DoseLine('Adult: 1–2 mg/dose BID–TID'),
        ],
      ),
      DoseSection(
        heading: 'Reverse neuromuscular blockade:',
        lines: [
          DoseLine('Child and adult: 0.2 mg IV for every 1 mg neostigmine or 5 mg '
              'pyridostigmine'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in hepatic and renal disease, ulcerative colitis, '
          'asthma, glaucoma, ileus, or urinary retention. Atropine-like side '
          'effects: Tachycardia, nausea, constipation, confusion, blurred vision, '
          'and dry mouth. These may be potentiated if given with other drugs with '
          'anticholinergic properties.',
      'Onset of action: PO: within 1 hr; IM/SC: 15–30 min; IV: 1 min. Duration '
          'of antisialagogue effect: PO: 8–12 hr; IM/SC/IV: 7 hr. Oral doses should '
          'be administered 1 hr before and 2 hr after meals.',
    ],
    pregnancyNote: 'Pregnancy category is “B” for the injection and tablet dosage '
        'forms and “C” for the oral solution.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1021–1022',
  ),
  // GRANISETRON — PDF p. 213–214 (printed 1022–1023)
  DrugEntryV3(
    name: 'GRANISETRON',
    brandNames: 'Sancuso, Sustol, and generics; previously available as Kytril',
    drugClass: 'Antiemetic agent, 5-HT₃ antagonist',
    iconRow: '',
    formulations: [
      'Injection: 1 mg/mL (1, 4 mL); 4 mL multidose vials contain benzyl alcohol',
      'Prefilled syringe for subcutaneous extended-release injection (Sustol): '
          '10 mg/0.4 mL (0.4 mL); contains polyethylene glycol',
      'Tabs: 1 mg',
      'Oral suspension: 0.2 mg/mL, 50 mCg/mL',
      'Transdermal patch (Sancuso): 3.1 mg/24 hr',
    ],
    doseSections: [
      DoseSection(
        heading: 'Chemotherapy-induced nausea and vomiting prevention (used in '
            'combination with dexamethasone):',
        lines: [
          DoseLine(
            'IV:',
            isHeading: true,
          ),
          DoseLine('Child ≥2 yr and adult: 10–20 mCg/kg/dose 15–60 min before chemotherapy; '
              'the same dose may be repeated 2–3 times at ≥10-min intervals following '
              'chemotherapy (within 24 hr after chemotherapy) as a treatment regimen. '
              'Max. dose: 3 mg/dose or 9 mg/24 hr. Alternatively, a single 40 '
              'mCg/kg/dose 15–60 min before chemotherapy has been used.'),
          DoseLine(
            'SC (Sustol, extended release):',
            isHeading: true,
          ),
          DoseLine('Adult: 10 mg at least 30 min prior to first dose of moderately emetogenic '
              'chemotherapy. Do not administer more frequently than Q7 days.'),
          DoseLine(
            'PO:',
            isHeading: true,
          ),
          DoseLine('Infant, child, and adolescent: 40 mCg/kg/dose BID is recommended for '
              'moderately or low emetogenic chemotherapy; initiate first dose 1 hr prior '
              'to chemotherapy.'),
          DoseLine('Adult: 2 mg/24 hr ÷ once daily–BID; initiate first dose 1 hr prior to '
              'chemotherapy'),
        ],
      ),
      DoseSection(
        heading: 'Postoperative nausea and vomiting prevention (dosed prior to '
            'anesthesia or immediately before anesthesia reversal) and treatment '
            '(IV; see remarks):',
        lines: [
          DoseLine('Adult: 1 mg × 1'),
        ],
      ),
      DoseSection(
        heading: 'Radiation-induced nausea and vomiting prevention:',
        lines: [
          DoseLine('Adult: 2 mg once daily PO administered 1–2 hr prior to radiation'),
        ],
      ),
      DoseSection(
        heading: 'Transdermal patch (see remarks):',
        lines: [
          DoseLine(
            'Prophylaxis for chemotherapy-induced nausea and vomiting:',
            isHeading: true,
          ),
          DoseLine('Adult: Apply 1 patch 24–48 hr prior to chemotherapy. Patch removal at a '
              'minimum of 24 hr after completion of chemotherapy. Patch may be worn up '
              'to 7 days, depending on the chemotherapy regimen duration.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in liver disease, recent abdominal surgery, and '
          'preexisting cardiac conduction disorders and arrhythmias. May cause '
          'hypertension, hypotension, progressive ileus, gastric distention, '
          'arrhythmias, agitation, and insomnia. Q–T prolongation has been reported. '
          'Inducers or inhibitors of the cytochrome P-450 3A3/3A4 drug-metabolizing '
          'enzymes may increase or decrease, respectively, the drug’s clearance. '
          'Serotonin syndrome has been reported with concomitant use of 5-HT3 '
          'antagonists and other serotonergic drugs.',
      'Safety and efficacy in pediatric patients for the prevention of '
          'postoperative nausea and vomiting have not been established due to lack '
          'of efficacy and Q–T prolongation in a prospective multicenter randomized '
          'double-blinded trial in 157 patients ages 2–16 yr.',
      'Avoid external heat sources (e.g., heating pads) on and around the '
          'transdermal patch dosage form, as heat may increase the rate of drug '
          'release. Application site reactions of pain, pruritus, rash, irritation, '
          'vesicles, and discoloration have been reported with transdermal patch '
          'use. Covering the application site of the transdermal system with '
          'clothing (while wearing the patch and 10 days following removal) is '
          'recommended to prevent potential phototoxic skin reactions. The '
          'subcutaneous dosage form is not recommended for children <12 yr, because '
          'this dosage form requires a large 18-gauge needle and lengthy time (20–30 '
          'seconds) for subcutaneous dose administration.',
      'Onset of action: IV: 4–10 min. Duration of action: IV: ≤24 hr.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1022–1023',
  ),
  // GRISEOFULVIN — PDF p. 214–215 (printed 1023–1024)
  DrugEntryV3(
    name: 'GRISEOFULVIN',
    brandNames: 'Microsize: Generics; previously available as Grifulvin V, '
        'Griseofulvin Microsize\nUltramicrosize: Generics; previously '
        'available as Gris-PEG',
    drugClass: 'Antifungal agent',
    iconRow: '',
    formulations: [
      'Microsize:',
      'Tabs: 500 mg',
      'Oral suspension: 125 mg/5 mL (120 mL); contains 0.2% alcohol, parabens, '
          'and propylene glycol',
      'Ultramicrosize:',
      'Tabs: 125, 250 mg',
      '250 mg ultramicrosize is approximately 500 mg microsize.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Microsize:',
        lines: [
          DoseLine('Child >2 yr and adolescent: 20–25 mg/kg/24 hr PO ÷ once daily–BID; give '
              'with milk, eggs, fatty foods'),
          DoseLine('Adult: 500–1000 mg/24 hr PO ÷ once daily–BID'),
          DoseLine('Max. dose (all ages): 1 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Ultramicrosize:',
        lines: [
          DoseLine('Child >2 yr and adolescent: 10–15 mg/kg/24 hr PO ÷ once daily–BID'),
          DoseLine('Adult: 375 mg/dose PO once daily–BID'),
          DoseLine('Max. dose (all ages): 750 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in porphyria, pregnancy, and hepatic disease. Monitor '
          'hematologic, renal, and hepatic function. May cause leukopenia, rash, '
          'headache, paresthesias, and GI symptoms. Severe skin reactions (e.g., '
          'Stevens-Johnson, TEN), erythema multiforme, LFT elevations (AST, ALT, '
          'bilirubin), and jaundice have been reported. Possible cross-reactivity in '
          'penicillin-allergic patients. Usual treatment period is 8 wk for tinea '
          'capitis and 4–6 mo for tinea unguium. Photosensitivity reactions may '
          'occur. May reduce effectiveness or decrease level of oral contraceptives, '
          'warfarin, and cyclosporine. Induces cytochrome P-450 1A2 isoenzyme. '
          'Phenobarbital may enhance clearance of griseofulvin. Coadministration '
          'with fatty meals will increase the drug’s absorption.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1023–1024',
  ),
  // GUANFACINE — PDF p. 215–216 (printed 1024–1025)
  DrugEntryV3(
    name: 'GUANFACINE',
    brandNames: 'Intuniv and generics',
    drugClass: 'α₂-adrenergic agonist',
    iconRow: '',
    formulations: [
      'Tabs: 1, 2 mg',
      'Extended-release tabs (Intuniv and generics): 1, 2, 3, 4 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Attention-deficit/hyperactivity disorder (see remarks):',
        lines: [
          DoseLine(
            'Immediate-release tabs:',
            isHeading: true,
          ),
          DoseLine(
            '≥6 yr and adolescent:',
            isHeading: true,
          ),
          DoseLine('≤45 kg: Start at 0.5 mg QHS; if needed and tolerated, increase dose every '
              '3–4 days at 0.5 mg/24 hr increments by increasing the dosing frequency to '
              'BID, TID, QID. Max. dose: 27–40.5 kg: 2 mg/24 hr and 40.5–45 kg: 3 mg/24 '
              'hr'),
          DoseLine('>45 kg: Start at 1 mg QHS; if needed and tolerated, increase dose every '
              '3–4 days at 1 mg/24 hr increments by increasing the dosing frequency to '
              'BID, TID, QID. Max. dose: 4 mg/24 hr'),
          DoseLine(
            'Extended-release tab:',
            isHeading: true,
          ),
          DoseLine('6–17 yr: Start at 1 mg Q24 hr; if needed and tolerated, increase dose no '
              'more than 1 mg/wk up to the max. dose of 4 mg/24 hr for 6–12 yr and 7 '
              'mg/24 hr for 13–17 yr when used as monotherapy. If used with '
              'psychostimulants as an adjunctive therapy, the max. dose is 4 mg/24 hr.'),
        ],
      ),
      DoseSection(
        heading: 'Use With Strong Cytochrome P-450 (CYP) 3A4 Inhibitors or Inducers',
        table: DoseTable(
          headers: ['CYP3A4 Characteristic', 'Adding Guanfacine With Respective CYP3A4 Inducer/Inhibitor Already on '
                'Board', 'Adding Respective CYP3A4 Inducer/Inhibitor With Guanfacine Already on '
                'Board'],
          rows: [
            DoseTableRow(['Strong inducer (e.g., carbamazepine, phenytoin, rifampin, St. John’s wort)', 'Guanfacine may be titrated up to double the recommended target dose', 'Consider increasing guanfacine dose up to double the recommended target '
                'dose over 1–2 wk as tolerated. If the strong inducer is discontinued, '
                'decrease guanfacine dose to target dose over 1–2 wk.']),
            DoseTableRow(['Strong inhibitor (e.g., clarithromycin, azole antifungals)', 'Decrease guanfacine dose to 50% of recommended target dose', 'Decrease guanfacine dose to 50% of recommended target dose. If the strong '
                'inhibitor is discontinued, increase guanficine dose to recommended target '
                'dose.']),
          ],
        ),
      ),
    ],
    remarks: [
      'Use with caution in patients at risk for hypotension, bradycardia, heart '
          'block, and syncope. A dose-dependent hypotension and bradycardia may '
          'occur. Somnolence, fatigue, insomnia, dizziness, and abdominal pain are '
          'common side effects. Orthostatic hypotension, hallucinations, syncope, '
          'and erectile dysfunction have been reported.',
      'Drug is a substrate for CYP3A4. See dosing section for dosage adjustment '
          'with inhibitors and inducers.',
      'Do not abruptly discontinue therapy (may cause rebound hypertension); '
          'taper of no more than 1 mg Q3–7 days has been recommended. Dose '
          'reductions may be required with clinically significant renal or hepatic '
          'impairment. When converting from an immediate-release tab to the '
          'extended-release tab, do not convert on a mg-per-mg basis (due to '
          'differences in pharmacokinetic profiles) but discontinue the '
          'immediate-release tab and titrate with the extended-release product using '
          'the recommended dosing schedules.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1024–1025',
  ),
];
