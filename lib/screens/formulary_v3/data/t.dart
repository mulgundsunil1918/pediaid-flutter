// =============================================================================
// output/t.dart — Drug Formulary 3.0, letter T
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyT` per file; entries in book order.
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

const List<DrugEntryV3> formularyT = [
  // TACROLIMUS — PDF p. 427–429 (printed 1236–1238)
  DrugEntryV3(
    name: 'TACROLIMUS',
    brandNames: 'Prograf, Astagraf XL, Envarsus XR, FK506, and generics; previously '
        'available as Protopic',
    drugClass: 'Immunosuppressant',
    iconRow: '',
    formulations: [
      'Caps (Prograf and generics): 0.5, 1, 5 mg',
      'Extended-release caps (Astagraf XL): 0.5, 1, 5 mg (Q24 hr dosing; see '
          'remarks)',
      'Extended-release tabs (Envarsus XR): 0.75, 1, 4 mg (Q24 hr dosing; see '
          'remarks)',
      'Oral suspension: 0.5, 1 mg/mL',
      'Granules for oral suspension (Prograf): 0.2, 1 mg (50 packets); contains '
          'lactose',
      'Injection (Prograf): 5 mg/mL (1 mL); contains alcohol and polyoxyl 60 '
          'hydrogenated castor oil (Cremophor)',
      'Topical ointment (generics; previously available as Protopic): 0.03%, '
          '0.1% (30, 60, 100 g)',
    ],
    doseSections: [
      DoseSection(
        heading: 'SYSTEMIC USE:',
      ),
      DoseSection(
        heading: 'Infant, child, and adolescent (initial immediate-release doses; '
            'titrate to therapeutic levels and convert IV to PO as soon as '
            'possible; see remarks):',
        lines: [
          DoseLine(
            'Liver transplantation:',
            isHeading: true,
          ),
          DoseLine('IV: 0.03–0.05 mg/kg/24 hr by continuous infusion'),
          DoseLine('PO: 0.15–0.2 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine(
            'Renal transplantation:',
            isHeading: true,
          ),
          DoseLine('IV (limited data): 0.06 mg/kg/24 hr by continuous infusion'),
          DoseLine('PO: 0.2–0.3 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine('Astagraf XL (in combination with other immunosuppressants): 0.15–0.3 '
              'mg/kg/24 hr PO Q24 hr; initial dose and post-reperfusion times vary with '
              'or without basiliximab induction'),
          DoseLine(
            'Cardiac transplantation:',
            isHeading: true,
          ),
          DoseLine('IV (limited data): 0.01–0.03 mg/kg/24 hr by continuous infusion'),
          DoseLine('PO: 0.1–0.3 mg/kg/24 hr ÷ Q12 hr; use lower initial dose for those '
              'receiving cell-depleting induction therapy'),
        ],
      ),
      DoseSection(
        heading: 'Adult (initial immediate-release doses; titrate to therapeutic '
            'levels):',
        lines: [
          DoseLine(
            'IV:',
            isHeading: true,
          ),
          DoseLine('Liver or kidney transplantation: 0.03–0.05 mg/kg/24 hr by continuous '
              'infusion'),
          DoseLine('Cardiac transplantation: 0.01 mg/kg/24 hr by continuous infusion'),
          DoseLine(
            'PO:',
            isHeading: true,
          ),
          DoseLine('Liver transplantation: 0.1–0.15 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine('Kidney transplantation: 0.1–0.2 mg/kg/24 hr ÷ Q12 hr'),
          DoseLine('Cardiac transplantation: 0.075 mg/kg/24 hr ÷ Q12 hr'),
        ],
      ),
      DoseSection(
        heading: 'TOPICAL USE:',
      ),
      DoseSection(
        heading: 'Atopic dermatitis (discontinue treatment when symptoms resolve and '
            'reconsider diagnosis if no improvement seen after 6 wk; see remarks):',
        lines: [
          DoseLine('Child ≥2 to 15 yr old: Apply a thin layer of the 0.03% ointment to the '
              'affected skin areas BID and rub in gently and completely.'),
          DoseLine('Adolescent ≥16 yr and adult: Apply a thin layer of the 0.03% or 0.1% '
              'ointment to the affected skin areas BID and rub in gently and completely.'),
        ],
      ),
    ],
    remarks: [
      'Avoid use in patients with prolonged cardiac Q–T intervals. IV dosage '
          'form contraindicated in patients allergic to polyoxyl 60 hydrogenated '
          'castor oil (Cremophor). Experience in pediatric kidney transplantation is '
          'limited. Pediatric patients may require higher mg/kg doses than adults. '
          'For bone marrow transplantation (BMT) use (beginning 1 day before BMT), '
          'dose and therapeutic levels similar to those in liver transplantation '
          'have been used.',
      'Major adverse events include tremor, headache, insomnia, diarrhea, '
          'constipation, hypertension, nausea, and renal dysfunction (increased risk '
          'with use of other nephrotoxic medications and with cytochrome P-450 [CYP] '
          '3A inhibitors). Hypokalemia, hypomagnesemia, hyperglycemia, confusion, '
          'depression, infections, lymphoma, liver enzyme elevation, optic '
          'neuropathy, and coagulation disorders may also occur. Gastrointestinal '
          'perforation, agranulocytosis, hemolytic uremic syndrome (HUS), thrombotic '
          'thrombocytopenic purpura (TTP), and hemolytic anemia have been reported.',
      'Tacrolimus is a substrate of the CYP3A4 drug-metabolizing enzyme and '
          'P-glycoprotein (P–gp) transporter. A 1.5–2-fold higher initial standard '
          'dose up to a max. dose of 0.3 mg/kg/24 hr has been recommended for '
          'intermediate or extensive metabolizers of CYP3A5. Calcium channel '
          'blockers, imidazole antifungals (ketoconazole, itraconazole, fluconazole, '
          'clotrimazole, posaconazole), macrolide antibiotics (erythromycin, '
          'clarithromycin, troleandomycin), cannabidiol, cisapride, cimetidine, '
          'cyclosporine, danazol, herbal products containing Schisandra sphenanthera '
          'extracts, methylprednisolone, grapefruit juice, Seville oranges, and '
          'severe diarrhea can increase tacrolimus serum levels. In contrast, '
          'carbamazepine, caspofungin, phenobarbital, phenytoin, rifampin, '
          'rifabutin, and sirolimus may decrease levels. Use with sirolimus may '
          'increase risk for hepatic artery thrombosis. Avoid use of live, '
          'attenuated vaccines. Use with other CYP3A inhibitors and substrates has '
          'the potential to prolong the cardiac Q–T interval. Reduce dose in renal '
          'or hepatic insufficiency.',
      'Monitor trough levels (just prior to a dose at steady state). Steady '
          'state is generally achieved after 2–5 days of continuous dosing. '
          'Interpretation will vary based on treatment protocol and assay '
          'methodology (whole blood enzyme–linked immunosorbent assay [ELISA] vs. '
          'microparticle enzyme immunoassay [MEIA] vs. high-performance liquid '
          'chromatography [HPLC]). Whole blood trough concentrations of 5–20 ng/mL '
          'have been recommended in liver transplantation at 1–12 mo. Trough levels '
          'of 7–20 ng/mL (whole blood) for the first 3 mo and 5–15 ng/mL after 3 mo '
          'have been recommended in renal transplantation. African Americans may '
          'need to be titrated to higher dosages. Patients with liver function '
          'changes during direct-acting antiviral therapy related to hepatitis C may '
          'alter tacrolimus pharmacokinetics, therefore requiring enhanced '
          'monitoring.',
      'Tacrolimus therapy generally should be initiated 6 hr or more after '
          'transplantation. PO is the preferred route of administration, and all PO '
          'dosage forms should be administered on an empty stomach (1 hr before and '
          '2 hr after meals). Administration of oral suspension dosage forms via '
          'gastric tubes containing polyvinyl chloride (PVC) can reduce systemic '
          'absorption as PVC materials can adsorb tacrolimus.',
      'Granules for oral suspension (Prograf): Mix contents of the number of '
          'dose-appropriate packet(s) in a glass cup with 15–30 mL of drinking water '
          'at room temperature (granules will not dissolve completely) and '
          'immediately administer the dose. Rinse and administer the contents of the '
          'glass cup with another 15–30 mL of water at room temperature to ensure '
          'complete dose administration. Do not use PVC-containing equipment (dosing '
          'cups or oral syringes) and do not sprinkle granules directly on food.',
      'Astagraf XL (extended-release capsule): Safety and efficacy have been '
          'established for de novo and stable (receiving immediate-release dosage '
          'form) pediatric kidney transplant patients. A mg-per-mg conversion from '
          'an immediate-release dosage form to Astagraf XL has been recommended.',
      'Envarsus XR (extended-release tablet): Currently labeled for use in adult '
          'kidney transplant patients (de novo and stable on immediate-release '
          'tacrolimus). When converting to Envarsus XR from immediate-release dosage '
          'form, initiate at 80% of the established immediate-release dosage form.',
      'All extended-release formulations are NOT interchangeable. IV infusions '
          'should be administered at concentrations between 0.004 and 0.02 mg/mL '
          'diluted with normal saline (NS) or 5% dextrose in water (D₅W).',
      'TOPICAL USE: Not recommended for use in patients who have skin conditions '
          'with a skin barrier defect with the potential for systemic absorption. Do '
          'not use in children <2 yr, in immunocompromised patients, or with '
          'occlusive dressings (promotes systemic absorption). Approved as a '
          'second-line therapy for short-term and intermittent treatment of atopic '
          'dermatitis for patients who fail to respond to, or do not tolerate, other '
          'approved therapies. Long-term safety is unknown. Skin burn sensation, '
          'pruritus, flu-like symptoms, allergic reaction, skin erythema, headache, '
          'and skin infection are the most common side effects. Application site '
          'edema has been reported. Although the risk is uncertain, the US Food and '
          'Drug Administration (FDA) has issued an alert about the potential cancer '
          'risk with the use of this product. See www.fda.gov/medwatch for the '
          'latest information.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1236–1238',
  ),
  // TAZAROTENE — PDF p. 430 (printed 1239)
  DrugEntryV3(
    name: 'TAZAROTENE',
    brandNames: 'Arazlo, Fabior, Tazorac, and generics',
    drugClass: 'Topical retinoic acid prodrug, keratolytic agent for acne or '
        'psoriasis',
    iconRow: '',
    formulations: [
      'Topical cream:',
      'Tazorac and generics: 0.05%, 0.1% (30, 60 g); contains benzyl alcohol and '
          'ethylenediaminetetra-acetic acid (EDTA)',
      'Topical foam:',
      'Fabior and generics: 0.1% (50, 100 g)',
      'Topical gel:',
      'Tazorac and generics: 0.05%, 0.1% (30, 100 g); contains benzyl alcohol '
          'and EDTA',
      'Topical lotion:',
      'Arazlo: 0.045% (45 g); contains EDTA and parabens',
    ],
    doseSections: [
      DoseSection(
        heading: 'Acne:',
        lines: [
          DoseLine(
            '0.045% topical lotion (Arazlo):',
            isHeading: true,
          ),
          DoseLine('>9 yr and adult: Apply a thin layer of the lotion to affected areas once '
              'daily.'),
          DoseLine(
            '0.01% topical cream, foam, or gel:',
            isHeading: true,
          ),
          DoseLine('≥12 yr and adult: Apply a small amount of 0.1% strength dosage forms to '
              'affected areas QHS. Use thin film (2 mg/cm²) of cream or gel dosage form '
              'and small amount of foam dosage form.'),
        ],
      ),
      DoseSection(
        heading: 'Psoriasis:',
        lines: [
          DoseLine('≥12 yr and adult: Apply a small amount of 0.05% gel (2 mg/cm²) to '
              'affected areas QHS initially. If needed and tolerated, increase to 0.1% '
              'gel QHS. The cream dosage form may also be used the same way as the gel, '
              'but it is currently labeled for use in adults (≥18 yr).'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in pregnancy. Pregnancy testing 2 wk prior to use and '
          'initiation of use during a normal menstrual period have been recommended. '
          'Avoid use in abraded or eczematous skin or with other medications or '
          'cosmetics with drying effects, or medications that can cause '
          'photosensitivity.',
      'Tazarotene is a retinoid prodrug that is converted to its active form, '
          'the cognate carboxylic acid of tazarotene (AGN 190299), by rapid '
          'deesterification in animals and humans.',
      'Common side effects include erythema, dry skin, skin irritation/pain '
          '(including blistering and skin desquamation), pruritus, and worsening of '
          'psoriasis.',
      'Avoid contact with mucous membranes. The foam dosage form is flammable; '
          'avoid fire, flame, or smoking during or immediately after use.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1239',
  ),
  // TERBINAFINE — PDF p. 430–431 (printed 1239–1240)
  DrugEntryV3(
    name: 'TERBINAFINE',
    brandNames: 'Previously available as Lamisil, Lamisil AT, and generics',
    drugClass: 'Antifungal',
    iconRow: '',
    formulations: [
      'Tabs: 250 mg',
      'Oral suspension: 25 mg/mL',
      'Topical cream:',
      'Lamisil AT and generics [OTC]: 1% (12, 15, 30 g); contains benzyl alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Tinea capitis:',
        lines: [
          DoseLine('Child: 4–6 mg/kg/dose PO once daily (max. dose: 250 mg), OR by the '
              'following once-daily dosages by weight category:'),
          DoseLine('10–20 kg: 62.5 mg'),
          DoseLine('21–40 kg: 125 mg'),
          DoseLine('>40 kg: 250 mg'),
          DoseLine('Duration of therapy: Trichophyton tonsurans: 4–6 wk; Microsprum canis: '
              '8–12 wk'),
          DoseLine('Adult: 250 mg PO once daily × 4–6 wk'),
        ],
      ),
      DoseSection(
        heading: 'Onychomycosis:',
        lines: [
          DoseLine('Child and adolescent (limited data): PO once daily by weight category:'),
          DoseLine('10–20 kg: 62.5 mg'),
          DoseLine('21–40 kg: 125 mg'),
          DoseLine('>40 kg: 250 mg'),
          DoseLine('Adult: 250 mg PO once daily'),
          DoseLine(
            'Duration of therapy:',
            isHeading: true,
          ),
          DoseLine('Fingernail infection: 6 wk'),
          DoseLine('Toenail infection: 12 wk'),
        ],
      ),
      DoseSection(
        heading: 'Topical use for dermal mycosis:',
        lines: [
          DoseLine(
            '≥12 yr:',
            isHeading: true,
          ),
          DoseLine('Tinea pedis: Apply topically (cream) interdigitally BID × 1 wk; if '
              'needed, apply the cream to the bottom or sides of the foot BID × 2 wk.'),
          DoseLine('Tinea cruris/tinea corporis: Apply topically (cream) to affected area '
              'once daily × 1 wk.'),
          DoseLine('Pityriasis (tinea) versicolor: Apply cream to affected area once daily × '
              '1 wk. Longer duration of 2–4 wk may be needed.'),
        ],
      ),
    ],
    remarks: [
      'SYSTEMIC USE: Contraindicated in chronic or acute liver disease. Common '
          'side effects include headache, fever, cough, diarrhea, taste disorder, '
          'increased liver function test results (LFTs), gastrointestinal '
          'disturbances, and rash. Severe dermatological reactions (e.g., '
          'Stevens-Johnson syndrome [SJS], toxic epidermal necrolysis [TEN]), '
          'hearing loss, neutropenia, thrombotic microangiopathy, and liver failure '
          '(some cases fatal) have been reported. Monitor aspartate '
          'aminotransferase/alanine aminotransferase (AST/ALT) at baseline and '
          'repeat with complete blood count (CBC) if therapy is >6 wk. Signs and '
          'symptoms of liver disease may include persistent nausea, anorexia, '
          'fatigue, vomiting, right upper abdominal pain, or jaundice. Discontinue '
          'use immediately if biochemical or clinical evidence of liver injury '
          'develops.',
      'Use with caution in renal impairment as terbinafine’s clearance has been '
          'shown to decrease by ~50% in adults with creatinine clearance (CrCl) ≤50 '
          'mL/min. Terbinafine inhibits cytochrome P-450 (CYP) 2D6, thus increasing '
          'the effects/toxicity of CYP2D6 substrates such as amphetamines, '
          'risperidone, and fluoxetine.',
      'Doses may be administered with or without food.',
      'TOPICAL USE: Do not use on/in the eyes, mouth, nails, scalp, or vaginal '
          'areas. Local irritation, skin rash, xeroderma, pruritus, and contact '
          'dermatitis may occur. Apply to clean and dry affected area, and wash '
          'hands after each use. If using topical spray, hold spray 4–6 inches from '
          'the affected area during dose administration.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1239–1240',
  ),
  // TERBUTALINE — PDF p. 432 (printed 1241)
  DrugEntryV3(
    name: 'TERBUTALINE',
    brandNames: 'Various generics; previously available as Brethine',
    drugClass: 'β₂-adrenergic agonist',
    iconRow: '',
    formulations: [
      'Injection: 1 mg/mL (1 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Acute asthma exacerbation:',
        lines: [
          DoseLine(
            'SC injection:',
            isHeading: true,
          ),
          DoseLine('≤12 yr: 0.01 mg/kg/dose Q15–20 min × 3 (max. dose: 0.25 mg/dose); if '
              'needed, repeat Q2–6 hr PRN'),
          DoseLine('>12 yr and adult: 0.25 mg/dose Q20 min PRN × 3; max. total dose: 0.75 mg'),
          DoseLine('Continuous infusion, IV: 2–10 mCg/kg loading dose (max. dose: 1 mg) over '
              '30 min followed by infusion of 0.2–0.4 mCg/kg/min. May titrate in '
              'increments of 0.1–0.2 mCg/kg/min Q30 min depending on clinical response. '
              'Doses as high as 10 mCg/kg/min have been used. To prepare infusion: See '
              'IV infusions on page i.'),
          DoseLine(
            'Nebulization (use IV dosage form; limited data):',
            isHeading: true,
          ),
          DoseLine('<2 yr: 0.5 mg in 2.5 mL normal saline (NS) Q4–6 hr PRN'),
          DoseLine('2–9 yr: 1 mg in 2.5 mL NS Q4–6 hr PRN'),
          DoseLine('>9 yr: 1.5–2.5 mg in 2.5 mL NS Q4–6 hr PRN'),
        ],
      ),
    ],
    remarks: [
      'IV and PO routes should not be used for the prevention or prolonged '
          'treatment of preterm labor because of the potential for serious maternal '
          'cardiac events and even death. Nervousness, tremor, headache, nausea, '
          'tachycardia, arrhythmias, and palpitations may occur. Paradoxical '
          'bronchoconstriction may occur with excessive use; if it occurs, '
          'discontinue drug immediately. Injectable product may be used for '
          'nebulization. For acute asthma, nebulizations may be given more '
          'frequently than Q4–6 hr.',
      'Monitor heart rate, blood pressure, respiratory rate, and serum potassium '
          'when using the continuous IV infusion route of administration. Adjust '
          'dose in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1241',
  ),
  // TETRACYCLINE HCL — PDF p. 432–433 (printed 1241–1242)
  DrugEntryV3(
    name: 'TETRACYCLINE HCL',
    brandNames: 'Various generics; previously available as Sumycin',
    drugClass: 'Antibiotic',
    iconRow: '',
    formulations: [
      'Caps: 250, 500 mg',
      'Oral suspension: 25 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Do not use in children <8 yr.',
      ),
      DoseSection(
        heading: 'Child ≥8 yr:',
        lines: [
          DoseLine('25–50 mg/kg/24 hr PO ÷ Q6 hr; max. dose: 2 g/24 hr'),
          DoseLine('Acne: 500 mg PO BID'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('250–500 mg PO Q6 hr or 500 mg PO Q12 hr'),
        ],
      ),
    ],
    remarks: [
      'Not recommended in patients <8 yr owing to tooth staining and decreased '
          'bone growth. Also not recommended for use in pregnancy because these side '
          'effects may occur in the fetus. The risk for these adverse effects is '
          'highest with long-term use. May cause nausea, gastrointestinal upset, '
          'hepatotoxicity, stomatitis, rash, fever, and superinfection. '
          'Photosensitivity reaction may occur. Avoid prolonged exposure to '
          'sunlight. Discontinue use if severe skin reactions (e.g., fixed drug '
          'eruptions, maculopapular/erythematous rashes) occur.',
      'Never use outdated tetracyclines because they may cause Fanconi-like '
          'syndrome. Do not give with dairy products or with any divalent cations '
          '(i.e., Fe²⁺, Ca²⁺, Mg²⁺). Give 1 hr before or 2 hr after meals.',
      'May decrease the effectiveness of oral contraceptives, increase serum '
          'digoxin levels, and increase effects of warfarin. Use with methoxyflurane '
          'increases risk for nephrotoxicity, and use with isotretinoin is '
          'associated with pseudotumor cerebri. Adjust dose in renal failure (see '
          'Chapter 32).',
      'Short-term maternal use is not likely to cause harm to breastfeeding '
          'infants.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1241–1242',
  ),
  // TEZACAFTOR AND IVACAFTOR — PDF p. 433–434 (printed 1242–1243)
  DrugEntryV3(
    name: 'TEZACAFTOR AND IVACAFTOR',
    brandNames: 'Symdeko',
    drugClass: 'Cystic fibrosis transmembrane conductance regulator (CFTR) corrector '
        'and potentiator',
    iconRow: '',
    formulations: [
      'Tabs (4-wk supply in 4 weekly blister packs):',
      'Tezacaftor 50 mg and ivacaftor 75 mg (white tabs; 28 tabs) and ivacaftor '
          '75 mg (light blue tabs; 28 tabs)',
      'Tezacaftor 100 mg and ivacaftor 150 mg (yellow tabs; 28 tabs) and '
          'ivacaftor 150 mg (light blue tabs; 28 tabs)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child 6 to <12 yr:',
        lines: [
          DoseLine('<30 kg: One tablet of tezacaftor 50 mg/ivacaftor 75 mg PO QAM and one '
              'tablet of ivacaftor 75 mg PO every evening administered ~12 hr apart'),
          DoseLine('≥30 kg: One tablet of tezacaftor 100 mg/ivacaftor 150 mg PO QAM and one '
              'tablet of ivacaftor 150 mg PO every evening administered ~12 hr apart'),
        ],
      ),
      DoseSection(
        heading: 'Child ≥12 yr–adult:',
        lines: [
          DoseLine('One tablet of tezacaftor 100 mg/ivacaftor 150 mg PO QAM and one tablet of '
              'ivacaftor 150 mg PO every evening administered ~12 hr apart'),
        ],
      ),
      DoseSection(
        heading: 'Dosage Modification With Hepatic Impairment',
        table: DoseTable(
          headers: ['Child-Pugh Class', 'Morning Dose', '', 'Evening Dose'],
          rows: [
            DoseTableRow(['', 'Age 6 to <12 yr and <30 kg:', 'Age 6 to <12 yr and ≥30 kg, and ≥12 yr–adult:', 'All patients']),
            DoseTableRow(['Class A', 'No adjustment', 'No adjustment', 'No adjustment']),
            DoseTableRow(['Class B', 'One tablet of tezacaftor 50 mg/ivacaftor 75 mg PO QAM', 'One tablet of tezacaftor 100 mg/ivacaftor 150 mg PO QAM', 'No ivacaftor']),
            DoseTableRow(['Class C', 'One tablet of tezacaftor 50 mg/ivacaftor 75 mg PO QAM or less frequently', 'One tablet of tezacaftor 100 mg/ivacaftor 150 mg PO QAM or less frequently', 'No ivacaftor']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Dosage modification with cytochrome P-450 (CYP) 3A4 inhibitors:',
        lines: [
          DoseLine('Moderate inhibitors (e.g., fluconazole, erythromycin): Do not administer '
              'any evening doses.'),
          DoseLine('Child 6 to <12 yr and <30 kg: Administer the following tablet PO on the '
              'following days only in the morning only:'),
        ],
        table: DoseTable(
          headers: ['Tablet', 'Day 1', 'Day 2', 'Day 3', 'Day 4ᵃ'],
          rows: [],
        ),
      ),
      DoseSection(
        heading: '',
        table: DoseTable(
          headers: ['Tablet', 'Day 1', 'Day 2', 'Day 3', 'Day 4ᵃ'],
          rows: [
            DoseTableRow(['Tezacaftor 50 mg/ivacaftor 75 mg', 'One tablet', '', 'One tablet', '']),
            DoseTableRow(['Ivacaftor 75 mg', '', 'One tablet', '', 'One tablet']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃContinue dosing with tezacaftor 50 mg/ivacaftor 75 mg or ivacaftor 75 mg '
              'on alternate days.'),
          DoseLine('Child 6 to <12 yr and ≥30 kg, and ≥12 yr–adult: Administer the following '
              'tablet PO on the following days only in the morning:'),
        ],
        table: DoseTable(
          headers: ['Tablet', 'Day 1', 'Day 2', 'Day 3', 'Day 4ᵃ'],
          rows: [
            DoseTableRow(['Tezacaftor 100 mg/ivacaftor 150 mg', 'One tablet', '', 'One tablet', '']),
            DoseTableRow(['Ivacaftor 150 mg', '', 'One tablet', '', 'One tablet']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃContinue dosing with tezacaftor 100 mg/ivacaftor 150 mg or ivacaftor 150 '
              'mg on alternate days.'),
        ],
      ),
      DoseSection(
        heading: 'Strong inhibitors (e.g., ketoconazole, itraconazole, posaconazole, '
            'voriconazole, telithromycin, and clarithromycin): Do not',
        lines: [
          DoseLine('administer any evening doses.'),
          DoseLine('Child 6 to <12 yr and <30 kg: One tablet of tezacaftor 50 mg/ivacaftor 75 '
              'mg PO in the morning on days 1 and 4, then continue with the same one '
              'tablet twice weekly (administered 3–4 days apart).'),
          DoseLine('Child 6 to <12 yr and ≥30 kg, and ≥12 yr–adult: One tablet of tezacaftor '
              '100 mg/ivacaftor 150 mg PO in the morning on days 1 and 4, then continue '
              'with the same one tablet twice weekly (administered 3–4 days apart).'),
        ],
      ),
    ],
    remarks: [
      'Works on CFTR trafficking defect by acting as a CFTR corrector '
          '(tezacaftor) and in combination with a CFTR potentiator (ivacaftor). '
          'Indicated for individuals with homozygous F508del CFTR mutation or who '
          'have at least one CFTR mutation that is responsive to this drug based on '
          'in vitro data and/or clinical evidence.',
      'Common side effects include headache, nausea, sinus congestion, and '
          'dizziness. Increased liver enzymes and cataracts may occur; monitor '
          'baseline aspartate aminotransferase/alanine aminotransferase (AST/ALT) '
          'and baseline ocular exam. Repeat AST/ALT every 3 months for the first '
          'year followed by annual assessments. Repeat ocular exams annually. May '
          'cause a false-positive urine drug screen for cannabinoids.',
      'Use with caution with CrCl ≤30 mL/min and end-stage renal disease (ESRD). '
          'Reduce dose with moderate/severe hepatic impairment or when initiating '
          'therapy while taking a CYP3A4 inhibitor (see dosing section).',
      'Tezacaftor and ivacaftor are substrates for CYP3A4/3A5. Use with strong '
          'CYP3A inducers (e.g., rifampin, rifabutin, carbamazepine, phenobarbital, '
          'phenytoin, St. John’s wort) is not recommended. Tezacaftor and ivacaftor '
          'may increase the effects/toxicity of cyclosporine, digoxin, everolimus, '
          'sirolimus, tacrolimus, and warfarin. Always evaluate potential drug-drug '
          'interactions; see https://www.symdekohcp.com/drug-interactions. Avoid '
          'food or drink containing grapefruit or Seville oranges.',
      'Administer all doses with high-fat foods to ensure absorption. If a dose '
          '(all dosage forms) is missed within 6 hr of a scheduled dose, administer '
          'a dose immediately. However, if the dose is missed >6 hr, skip that dose '
          'and resume therapy at the next scheduled dose. Never take a double dose '
          'for a missed dose.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1242–1243',
  ),
  // THEOPHYLLINE — PDF p. 435–436 (printed 1244–1245)
  DrugEntryV3(
    name: 'THEOPHYLLINE',
    brandNames: 'Theo-24, Elixophyllin, and generics',
    drugClass: 'Bronchodilator, methylxanthine',
    iconRow: '',
    formulations: [
      'Other dosage forms may exist.',
      'Immediate release:',
      'Oral elixir/solution (Elixophyllin and generics): 80 mg/15 mL (473 mL); '
          'may contain up to 20% alcohol (alcohol-free preparations may be available)',
      'Sustained/extended release (see remarks):',
      'Tabs:',
      'Q12 hr dosing (generics): 100, 200, 300, 450 mg',
      'Q24 hr dosing (generics): 400, 600 mg',
      'Caps (Q24 hr dosing: Theo-24): 100, 200, 300, 400 mg',
      'Sustained-release forms should not be chewed or crushed. Capsules may be '
          'opened and contents may be sprinkled on food.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Dosing intervals are for immediate-release preparations.',
        lines: [
          DoseLine('For sustained-release preparations, divide daily dose >Q8–24 hr based on '
              'product.'),
        ],
      ),
      DoseSection(
        heading: 'Neonatal apnea:',
        lines: [
          DoseLine('Loading dose: 5 mg/kg/dose PO × 1'),
          DoseLine('Maintenance: 3–6 mg/kg/24 hr PO ÷ Q6–8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Bronchospasm/reversible airflow obstruction (PO):',
        lines: [
          DoseLine('Loading dose: 1 mg/kg/dose for each 2 mg/L desired increase in serum '
              'theophylline level'),
          DoseLine(
            'Maintenance, infant (<1 yr):',
            isHeading: true,
          ),
          DoseLine(
            'Preterm:',
            isHeading: true,
          ),
          DoseLine('<24 days old (postnatal): 1 mg/kg/dose PO Q12 hr'),
          DoseLine('≥24 days old (postnatal): 1.5 mg/kg/dose PO Q12 hr'),
          DoseLine('Full-term up to 1 yr old: Total daily dose (mg) = [(0.2 × age in weeks) + '
              '5] × (kg body weight)'),
          DoseLine('≤6 mo: Divide daily dose Q8 hr'),
          DoseLine('>6 mo: Divide daily dose Q6 hr'),
          DoseLine(
            'Maintenance, child >1 yr and adult without risk factors for altered '
                'clearance (see remarks):',
            isHeading: true,
          ),
          DoseLine('<45 kg: Begin therapy at 12–14 mg/kg/24 hr ÷ Q4–6 hr up to max. dose of '
              '300 mg/24 hr. If needed based on serum levels, gradually increase to '
              '16–20 mg/kg/24 hr ÷ Q4–6 hr. Max. dose: 600 mg/24 hr'),
          DoseLine('≥45 kg: Begin therapy with 300 mg/24 hr ÷ Q6–8 hr. If needed based on '
              'serum levels, gradually increase to 400–600 mg/24 hr ÷ Q6–8 hr.'),
        ],
      ),
      DoseSection(
        heading: 'Theophylline Sustained-Release Products',
        table: DoseTable(
          headers: ['Trade Name', 'Available Strengths (mg)', 'Dosage Interval (hr)'],
          rows: [
            DoseTableRow(['CAPSULES:', '', '']),
            DoseTableRow(['Theo-24', '100, 200, 300, 400', 'Q24']),
            DoseTableRow(['TABLETS:', '', '']),
            DoseTableRow(['Theochron and generics', '100, 200, 300, 450', 'Q12']),
            DoseTableRow(['Generics', '400, 600', 'Q24']),
          ],
        ),
      ),
    ],
    remarks: [
      'Drug metabolism varies widely with age, drug formulation, and route of '
          'administration. Most common side effects and toxicities are nausea, '
          'vomiting, anorexia, abdominal pain, gastroesophageal reflux, nervousness, '
          'tachycardia, seizures, and arrhythmias.',
      'Serum levels should be monitored. Therapeutic levels: bronchospasm: 10–20 '
          'mg/L; apnea: 7–13 mg/L. Half-life is age dependent: 30 hr (newborns); 6.9 '
          'hr (infants); 3.4 hr (children); 8.1 hr (adults). See Aminophylline for '
          'guidelines for serum level determinations. Liver impairment, cardiac '
          'failure, and sustained high fever may increase theophylline levels. '
          'Theophylline is a substrate for cytochrome P-450 1A2. Levels are '
          'increased with allopurinol, alcohol, ciprofloxacin, cimetidine, '
          'clarithromycin, disulfiram, erythromycin, estrogen, isoniazid, '
          'propranolol, thiabendazole, and verapamil. Levels are decreased with '
          'carbamazepine, isoproterenol, phenobarbital, phenytoin, and rifampin. May '
          'cause increased skeletal muscle activity, agitation, and hyperactivity '
          'when used with doxapram, and may increase quinine levels/toxicity.',
      'Use ideal body weight in obese patients when calculating dosage because '
          'of poor distribution into body fat. Risk factors for increased clearance '
          'include: smoking, cystic fibrosis, hyperthyroidism, and high-protein '
          'diet. Factors for decreased clearance include congestive heart failure '
          '(CHF), correction of hyperthyroidism, fever, viral illness, sepsis, and '
          'high-carbohydrate diet.',
      'Suggested dosage intervals for sustained-release products (see following '
          'table):',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1244–1245',
  ),
  // THIAMINE — PDF p. 436 (printed 1245)
  DrugEntryV3(
    name: 'THIAMINE',
    brandNames: 'Vitamin B₁, many generic products',
    drugClass: 'Water-soluble vitamin',
    iconRow: '',
    formulations: [
      'Tabs (OTC): 50, 100, 250 mg',
      'Caps (OTC): 50, 100, 500 mg',
      'Oral liquid drops (OTC): 6 mg/mL (60 mL)',
      'Oral suspension: 25, 100 mg/mL',
      'Injection: 100 mg/mL (2 mL); some products are preservative-free',
    ],
    doseSections: [
      DoseSection(
        heading: '',
        lines: [
          DoseLine('For US recommended daily allowance (RDA), see Chapter 21.'),
        ],
      ),
      DoseSection(
        heading: 'Beriberi (thiamine deficiency):',
        lines: [
          DoseLine('Child: 10–25 mg/dose IM/IV once daily (if critically ill) or 10–50 '
              'mg/dose PO once daily × 2 wk, followed by 5–10 mg/dose PO once daily × 1 '
              'mo'),
          DoseLine('Adult: 10–20 mg/dose IM/IV TID (if critically ill) × 2 wk, followed by '
              '5–10 mg/24 hr PO ÷ once daily or TID × 1 mo'),
        ],
      ),
      DoseSection(
        heading: 'Wernicke’s encephalopathy syndrome:',
        lines: [
          DoseLine('Adult: 100 mg IV × 1, then 50–100 mg IM/IV once daily until patient '
              'resumes a normal diet. Initiate thiamine before starting glucose infusion.'),
        ],
      ),
      DoseSection(
        heading: 'Refeeding syndrome:',
        lines: [
          DoseLine('see Chapter 21'),
        ],
      ),
    ],
    remarks: [
      'Multivitamin preparations contain amounts meeting RDA requirements. '
          'Allergic reactions and anaphylaxis may occur, primarily with IV '
          'administration. Therapeutic range: 1.6–4 mg/dL. High-carbohydrate diets '
          'or IV dextrose solutions may increase thiamine requirements. Large doses '
          'may interfere with serum theophylline assay. Pregnancy category changes '
          'to “C” if used in doses above the RDA.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1245',
  ),
  // THIORIDAZINE — PDF p. 437 (printed 1246)
  DrugEntryV3(
    name: 'THIORIDAZINE',
    brandNames: 'Various generics; previously available as Mellaril',
    drugClass: 'Antipsychotic, phenothiazine derivative',
    iconRow: '',
    formulations: [
      'Tabs: 10, 25, 50, 100 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Refractory schizophrenia:',
        lines: [
          DoseLine('Child ≥6 yr–adolescent: Start with 0.5 mg/kg/24 hr PO ÷ BID–TID (initial '
              'max.: 50 mg/dose); dosage range: 0.5–3 mg/kg/24 hr PO ÷ BID–TID. Max. '
              'dose: 3 mg/kg/24 hr'),
          DoseLine('Adult: Start with 150–300 mg/24 hr PO ÷ TID. Then gradually increase PRN '
              'to max. dose 800 mg/24 hr ÷ BID–QID.'),
        ],
      ),
    ],
    remarks: [
      'Indicated for schizophrenia unresponsive to standard therapy. '
          'Contraindicated in severe central nervous system depression, brain '
          'damage, narrow-angle glaucoma, blood dyscrasias, and severe liver or '
          'cardiovascular disease. DO NOT coadminister with drugs that may inhibit '
          'the cytochrome P-450 (CYP) 2D6 isoenzymes (e.g., selective serotonin '
          'reuptake inhibitors [SSRIs] such as fluoxetine, fluvoxamine, paroxetine; '
          'and β-blockers such as propranolol and pindolol); with drugs that may '
          'widen the Q–Tc interval (e.g., disopyramide, procainamide, quinidine); '
          'and in patients with known reduced activity of CYP2D6.',
      'May cause drowsiness, extrapyramidal reactions, autonomic symptoms, '
          'electrocardiogram (ECG) changes (Q–Tc prolongation in a dose-dependent '
          'manner), arrhythmias, paradoxical reactions, and endocrine disturbances. '
          'Long-term use may cause tardive dyskinesia. Pigmentary retinopathy may '
          'occur with higher doses; a periodic eye exam is recommended. More '
          'autonomic symptoms and fewer extrapyramidal effects than chlorpromazine. '
          'Concurrent use with epinephrine can cause hypotension. Increased cardiac '
          'arrhythmias may occur with tricyclic antidepressants.',
      'In an overdose situation, monitor ECG and avoid drugs that can widen Q–Tc '
          'interval.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1246',
  ),
  // TIAGABINE — PDF p. 437–438 (printed 1246–1247)
  DrugEntryV3(
    name: 'TIAGABINE',
    brandNames: 'Generics; previously available as Gabitril',
    drugClass: 'Anticonvulsant',
    iconRow: '',
    formulations: [
      'Tabs: 2, 4, 12, 16 mg',
      'Oral suspension: 1 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Adjunctive therapy for partial (focal) seizures (dosage based on use '
            'with enzyme-inducing antiepileptic drugs [AEDs]; see remarks). NOTE:',
        lines: [
          DoseLine('Patients receiving non–enzyme-inducing AEDs had tiagabine blood levels '
              'about two times higher than patients receiving enzyme-inducing AEDs.'),
          DoseLine('≥12 yr and adult: Start at 4 mg PO once daily × 7 days. If needed, '
              'increase dose to 8 mg/24 hr PO ÷ BID. Dosage may be increased further by '
              '4–8 mg/24 hr at weekly intervals (daily doses may be divided BID–QID) '
              'until a clinical response is achieved or up to specified max. dose.'),
          DoseLine(
            'Max. dose:',
            isHeading: true,
          ),
          DoseLine('12–18 yr: 32 mg/24 hr'),
          DoseLine('Adult: 56 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Adjunctive therapy for refractory seizures (see remarks):',
        lines: [
          DoseLine('Child ≥2 yr (limited data from a safety and tolerability study in 52 '
              'children 2–17 yr, mean 9.3 + 4.1): Initial dose of 0.25 mg/kg/24 hr PO ÷ '
              'TID × 4 wk. Dosage was increased at 4-wk intervals to 0.5, 1, and 1.5 '
              'mg/kg/24 hr until an effective and well-tolerated dose was established. '
              'Criteria for dose increase required tolerance of the current dosage level '
              'and <50% reduction in seizures. Patients receiving enzyme-inducing AEDs '
              'received a max. daily dose of 0.73 ± 0.44 mg/kg/24 hr, and patients '
              'receiving non–enzyme-inducing AEDs received a max. daily dose of 0.61 ± '
              '0.32 mg/kg/24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in hepatic insufficiency (may need to reduce dose and/or '
          'increase dosing interval). Most common side effects include dizziness, '
          'somnolence, depression, confusion, and asthenia. Nervousness, tremor, '
          'nausea, abdominal pain, confusion, and difficulty in concentrating may '
          'also occur. Cognitive/neuropsychiatric symptoms resulting in '
          'nonconvulsive status epilepticus requiring subsequent dose reduction or '
          'drug discontinuation have been reported. Suicidal behavior or ideation, '
          'bullous dermatitis, and blurred vision have been reported. Off-label use '
          'in patients WITHOUT epilepsy is discouraged due to reports of seizures in '
          'these patients.',
      'Tiagabine’s clearance is increased by concurrent hepatic enzyme-inducing '
          'antiepileptic drugs (e.g., phenytoin, carbamazepine, and barbiturates), '
          'and St. John’s wort. Lower doses or a slower titration for clinical '
          'response may be necessary for patients receiving non–enzyme-inducing '
          'drugs (e.g., valproate, gabapentin, and lamotrigine). Avoid abrupt '
          'discontinuation of drug.',
      'TID dosing schedule may be preferred since BID schedule may not be well '
          'tolerated. Doses should be administered with food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1246–1247',
  ),
  // TIOTROPIUM — PDF p. 438–439 (printed 1247–1248)
  DrugEntryV3(
    name: 'TIOTROPIUM',
    brandNames: 'Spiriva HandiHaler, Spiriva Respimat, and generic',
    drugClass: 'Anticholinergic agent, long-acting',
    iconRow: '',
    formulations: [
      'Aerosol inhaler:',
      'Spiriva Respimat:',
      'For asthma: 1.25 mCg/actuation (each cartridge weighs 4 g and provides 60 '
          'actuations/inhaler); contains benzalkonium chloride and disodium '
          'ethylenediaminetetra-acetic acid (EDTA)',
      'For chronic obstructive pulmonary disease (COPD): 2.5 mCg/puff (each '
          'cartridge weighs 4 g and provides either 10 or 60 actuations/inhaler); '
          'contains benzalkonium chloride and disodium EDTA',
      'Inhalational capsules:',
      'Spiriva HandiHaler 18 mCg (boxes of 5s, 30s, or 90s with one HandiHaler '
          'device); contains milk proteins',
      'Generic: 18 mCg (box of 30s with one LupinHaler inhalation device); '
          'contains milk proteins',
    ],
    doseSections: [
      DoseSection(
        heading: 'Asthma (maintenance therapy, see remarks):',
        lines: [
          DoseLine(
            'Child ≥6 yr, adolescent, and adult:',
            isHeading: true,
          ),
          DoseLine('Spiriva Respimat: Inhale two 1.25-mCg actuations once daily; max. dose: '
              '2.5 mCg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in patients with ipratropium hypersensitivity reactions '
          '(e.g., angioedema, itching, or rash). Common side effects include '
          'headache, constipation, xerostomia, urinary tract infection, bronchitis, '
          'cough, pharyngitis, sinusitis, and upper respiratory infection. Bowel '
          'obstruction, angle-closure glaucoma, urinary retention, and bronchospasm '
          'have been reported. The pediatric adverse reaction profile is similar to '
          'that of adults.',
      'Use as an add-on maintenance therapy for asthma along with inhaled '
          'corticosteroid. Maximum benefits may take up to 4–8 wk of continuous use. '
          'Doses >2.5 mCg/24 hr were not associated with greater efficacy in forced '
          'expiratory volume in 1 sec (FEV₁) for adults with asthma.',
      'Monitor for anticholinergic side effects in patients with moderate/severe '
          'renal impairment (estimated glomerular filtration rate [eGFR] <60 mL/min).',
      'Administration of Spiriva Respimat 1.25 mCg × 2 delivered with the '
          'AeroChamber Plus Flow-Vu holding chamber with/without face mask by an in '
          'vitro study utilizing inspiratory flow rates for children 6–12 mo, 2–5 '
          'yr, and >5 yr has been shown to deliver a comparable adult dose on a '
          'mCg-per–body weight basis. Despite a report of an adverse reaction '
          'profile similar to adolescents and adults from a 12-wk placebo-controlled '
          'trial (2.5 mCg/24 hr) in children 1–5 yr, the clinical efficacy and '
          'safety have not been fully established for children <6 years of age with '
          'asthma.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1247–1248',
  ),
  // TOBRAMYCIN — PDF p. 439–441 (printed 1248–1250)
  DrugEntryV3(
    name: 'TOBRAMYCIN',
    brandNames: 'Tobrex, TOBI, TOBI Podhaler, Bethkis, Kitabis Pak, and generics; '
        'previously available as Nebcin',
    drugClass: 'Antibiotic, aminoglycoside',
    iconRow: '',
    formulations: [
      'Injection: 10 mg/mL (2 mL), 40 mg/mL (2, 30, 50 mL); may contain phenol '
          'and bisulfites',
      'Powder for injection: 1.2 g; preservative free',
      'Ophthalmic ointment (Tobrex): 0.3% (3.5 g); contains 0.5% chlorobutanol',
      'In combination with dexamethasone (TobraDex): 0.3% tobramycin with 0.1% '
          'dexamethasone (3.5 g); contains 0.5% chlorobutanol',
      'Ophthalmic solution (generics): 0.3% (5 mL)',
      'In combination with dexamethasone as an ophthalmic suspension (both '
          'products contain 0.01% benzalkonium chloride and '
          'ethylenediaminetetra-acetic acid [EDTA]):',
      'Generics: 0.3% tobramycin with 0.1% dexamethasone (2.5, 5, 10 mL)',
      'TobraDex ST: 0.3% tobramycin with 0.05% dexamethasone (5 mL)',
      'Nebulizer solution:',
      'Bethkis and generics: 300 mg/4 mL (56s); preservative free',
      'TOBI, Kitabis Pak, and generics: 300 mg/5 mL (56s); preservative free',
      '170 mg/3.4 mL (mixed in 0.45% normal saline, preservative free; use with '
          'eFlow/Trio nebulizer)',
      'Powder for inhalation:',
      'TOBI Podhaler: 28-mg capsules (224 capsules in 4 weekly packs with 2 '
          'Podhaler inhalation devices)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Initial empiric dosage; patient-specific dosage defined by '
            'therapeutic drug monitoring (see remarks)',
      ),
      DoseSection(
        heading: 'Neonate/infant, IM/IV (see following table):',
        table: DoseTable(
          headers: ['Postconceptional age (wk)', 'Postnatal age (days)', 'Dose (mg/kg/dose)', 'Interval (hr)'],
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
          DoseLine('ᵃOr significant asphyxia, patent ductus arteriosus, indomethacin use, '
              'poor cardiac output, reduced renal function.'),
          DoseLine('ᵇUse Q36 hr interval for hypoxic-ischemic encephalopathy patients '
              'receiving whole-body therapeutic cooling.'),
        ],
      ),
      DoseSection(
        heading: 'Child:',
        lines: [
          DoseLine('7.5 mg/kg/24 hr IV/IM ÷ Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Cystic fibrosis (if available, use patient’s previous therapeutic '
            'mg/kg dosage):',
        lines: [
          DoseLine('Conventional Q8 hr dosing: 7.5–10.5 mg/kg/24 hr IV ÷ Q8 hr'),
          DoseLine('High-dose extended-interval (once daily) dosing: 10–12 mg/kg/dose IV Q24 '
              'hr'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Conventional Q8 hr dosing: 3–6 mg/kg/24 hr IV/IM ÷ Q8 hr'),
          DoseLine('High-dose extended-interval dosing: 4–7 mg/kg/dose IV/IM Q24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Ophthalmic:',
        lines: [
          DoseLine(
            'Tobramycin:',
            isHeading: true,
          ),
          DoseLine(
            'Child and adult:',
            isHeading: true,
          ),
          DoseLine('Ophthalmic ointment: Apply 0.5-inch ribbon into conjunctival sac(s) '
              'BID–TID; for severe infections, apply Q3–4 hr initially, then reduce dose '
              'frequency.'),
          DoseLine('Ophthalmic drop: Instill 1–2 drops of solution to affected eye(s) Q4 hr; '
              'for severe infections, instill 2 drops Q60 min initially, then reduce '
              'dose frequency.'),
          DoseLine(
            'Tobramycin with dexamethasone:',
            isHeading: true,
          ),
          DoseLine(
            '≥2 yr and adult:',
            isHeading: true,
          ),
          DoseLine('Ophthalmic ointment: Apply 0.5-inch ribbon of ointment into conjunctival '
              'sac(s) TID–QID.'),
          DoseLine(
            'Ophthalmic drop:',
            isHeading: true,
          ),
          DoseLine('TobraDex: Instill 1–2 drop(s) of solution to affected eye(s) Q2 hr × '
              '24–48 hr, then 1–2 drop(s) Q4–6 hr; increase dosing interval when signs '
              'and symptoms improve.'),
          DoseLine('TobraDex ST: Instill 1 drop of solution to affected eye(s) Q2 hr × 24–48 '
              'hr, then 1 drop Q4–6 hr; increase dosing interval when signs and symptoms '
              'improve.'),
        ],
      ),
      DoseSection(
        heading: 'Inhalation:',
        lines: [
          DoseLine(
            'Cystic fibrosis prophylaxis therapy:',
            isHeading: true,
          ),
          DoseLine(
            '≥6 yr and adult:',
            isHeading: true,
          ),
          DoseLine('TOBI, Bethkis, Kitabis Pak, and generic nebulizers: Inhale 300 mg Q12 hr '
              'administered in repeated cycles of 28 days on drug followed by 28 days '
              'off drug'),
          DoseLine('Use with eFlow/Trio nebulizer: inhale 170 mg Q12 hr administered in '
              'repeated cycles of 28 days on drug followed by 28 days off drug'),
          DoseLine('TOBI Podhaler: Inhale four 28-mg capsules (112 mg) Q12 hr administered in '
              'repeated cycles of 28 days on drug followed by 28 days off drug'),
          DoseLine('Cystic fibrosis early eradication of Pseudomonas aeruginosa in the '
              'airways:.'),
          DoseLine(
            '≥6 yr and adult (limited data):',
            isHeading: true,
          ),
          DoseLine('TOBI, Bethkis, Kitabis Pak, and generic nebulizers: Inhale 300 mg Q12 hr '
              'for 28 days followed by reassessment of pulmonary cultures'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in combination with neurotoxic, ototoxic, or nephrotoxic '
          'drugs; with anesthetics or neuromuscular blocking agents; with '
          'preexisting renal, vestibular, or auditory impairment; and in patients '
          'with neuromuscular disorders. May cause ototoxicity, nephrotoxicity, and '
          'neuromuscular blockade. Serious allergic reactions, including '
          'anaphylaxis, and dermatologic reactions, including exfoliative '
          'dermatitis, toxic epidermal necrolysis, erythema multiforme, and '
          'Stevens-Johnson syndrome, have been reported rarely. Ototoxic effects '
          'synergistic with furosemide. Individuals with MT-RNR1 mitochondrial DNA '
          'variants (particularly the m.1555A>G) have been associated with '
          'ototoxicity.',
      'Higher doses are recommended in patients with cystic fibrosis, '
          'neutropenia, or burns. Adjust dose in renal failure (see Chapter 32). '
          'Monitor peak and trough levels.',
      'Therapeutic peak levels with conventional Q8 hr dosing:',
      '6–10 mg/L in general',
      '8–10 mg/L in pulmonary infections, neutropenia, osteomyelitis, and severe '
          'sepsis',
      'Therapeutic trough levels with conventional Q8 hr dosing: <2 mg/L. '
          'Recommended serum sampling time at steady state: trough within 30 min '
          'prior to the third consecutive dose and peak 30–60 min after the '
          'administration of the third consecutive dose.',
      'Therapeutic peak and trough goals for high-dose extended-interval dosing '
          'for cystic fibrosis:',
      'Peak: 20–40 mg/L; recommended serum sampling time at 30–60 min after the '
          'administration of the first dose',
      'Trough: <1 mg/L; recommended serum sampling time within 30 min before the '
          'second dose',
      'Serum levels should be rechecked with changing renal function, with poor '
          'clinical response, and at a minimum of once weekly for prolonged '
          'therapies.',
      'To maximize bactericidal effects, an individualized peak concentration to '
          'target a peak/minimum inhibitory concentration (MIC) ratio of 8–10:1 may '
          'be applied.',
      'For initial dosing in obese patients, use an adjusted body weight (ABW): '
          'ABW = Ideal Body Weight + 0.4 (Total Body Weight – Ideal Body Weight)',
      'INHALATIONAL USE: Transient voice alteration, bronchospasm, dyspnea, '
          'pharyngitis, and increased cough may occur. Transient tinnitus, decreased '
          'appetite, and hearing loss have been reported with nebulized dosage '
          'forms. Aphonia, discolored sputum, and malaise have been reported with '
          'the powder for inhalation. Use is not recommended with nephrotoxic, '
          'neurotoxic, or ototoxic medications, or when intravenous antibiotic '
          'therapy is prescribed. When used with other inhaled medications in cystic '
          'fibrosis, use the following order of administration: bronchodilator '
          'first, chest physiotherapy, other inhaled medications (if indicated), and '
          'tobramycin last. For TOBI Podhaler, inhale the entire contents of each '
          'capsule. To improve adherence with prophylactic inhalation therapy, '
          'initiate each 28-day inhalation cycle on the first day of an odd- or '
          'even-numbered month.',
    ],
    pregnancyNote: 'Pregnancy category is a “D” for injection and inhalation routes of '
        'administration and a “B” for the ophthalmic route. Consider '
        'alternative therapy in cases of known maternal ototoxicity history '
        'with aminoglycoside use or known mitochondrial DNA variant in the '
        'maternal patient.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1248–1250',
  ),
  // TOLNAFTATE — PDF p. 441 (printed 1250)
  DrugEntryV3(
    name: 'TOLNAFTATE',
    brandNames: 'Tinactin, many other brands and generics',
    drugClass: 'Antifungal agent',
    iconRow: '',
    formulations: [
      'Topical aerosol liquid [OTC]: 1% (150 g); may contain 29% vol/vol or 41% '
          'wt/wt alcohol',
      'Aerosol powder [OTC]: 1% (133 g); contains 11% vol/vol alcohol and talc',
      'Cream [OTC]: 1% (15, 30 g)',
      'Topical powder [OTC]: 1% (45 g)',
      'Topical solution [OTC]: 1% (10, 15, 30 mL); may contain propylene glycol '
          'and/or parabens',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child (≥2 yr), adolescent, and adult:',
        lines: [
          DoseLine('Topical for tinea pedis, tinea corporis, and tinea cruris: Apply 1–3 '
              'drops of solution, or small amount of liquid, cream, or powder to '
              'affected and surrounding areas BID for 2–4 wk (4 wk for tinea pedis).'),
        ],
      ),
    ],
    remarks: [
      'May cause mild irritation and sensitivity. Contact dermatitis has been '
          'reported. Avoid eye contact. Do not use for nail or scalp infections. '
          'Discontinue use if sensitization develops.',
    ],
    pregnancyNote: 'Pregnancy category not formally assigned by US Food and Drug '
        'Administration (FDA).',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1250',
  ),
  // TOPIRAMATE — PDF p. 442–443 (printed 1251–1252)
  DrugEntryV3(
    name: 'TOPIRAMATE',
    brandNames: 'Topamax, Topamax Sprinkle, Trokendi XR, Eprontia, and generics',
    drugClass: 'Anticonvulsant',
    iconRow: '',
    formulations: [
      'Caps, sprinkle:',
      'Topamax Sprinkle: 15, 25 mg',
      'Generics: 15, 25, 50 mg',
      'Tabs:',
      'Topamax and generics: 25, 50, 100, 200 mg',
      'Extended-release caps (Q24 hr dosing; see remarks):',
      'Trokendi XR and generics: 25, 50, 100, 200 mg',
      'Oral solution:',
      'Eprontia: 25 mg/mL (473 mL); contains parabens and polyethylene glycol',
      'Oral suspension: 6, 14, 20 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Adjunctive therapy for partial onset seizures or Lennox-Gastaut '
            'syndrome (immediate-release dosage forms):',
        lines: [
          DoseLine('Child 2–16 yr: Start with 1–3 mg/kg/dose (max. dose: 25 mg/dose) PO QHS × '
              '7 days, then increase by 1–3 mg/kg/24 hr increments at 1- to 2-wk '
              'intervals (divided daily dose BID) to response. Usual maintenance dose is '
              '5–9 mg/kg/24 hr PO ÷ BID; max. dose: 400 mg/24 hr'),
          DoseLine('≥17 yr and adult: Start with 25–50 mg PO QHS × 7 days, then increase by '
              '25–50 mg/24 hr increments at 1-wk intervals until adequate response. '
              'Doses >50 mg should be divided BID. Usual maintenance dose: 100–200 mg '
              'BID. Doses above 400 mg/24 hr have not been shown to improve responses in '
              'adults with partial onset seizures.'),
        ],
      ),
      DoseSection(
        heading: 'Adjunctive therapy for primary generalized tonic-clonic seizures '
            '(immediate-release dosage forms):',
        lines: [
          DoseLine('Child 2–16 yr: Use above initial dose and slower titration rate by '
              'reaching 6 mg/kg/24 hr by the end of 8 weeks.'),
          DoseLine('≥17 yr and adult: Use above initial dose and slower titration rate by '
              'reaching 200 mg BID by the end of 8 weeks; max. dose: 1600 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Monotherapy for partial onset seizures or primary generalized '
            'tonic-clonic seizures (immediate-release dosage forms):',
        lines: [
          DoseLine('Child 2 to <10 yr: Start with 25 mg PO QHS × 7 days; if needed and '
              'tolerated, may increase dose to 25 mg PO BID. May further increase by '
              '25–50 mg/24 hr at weekly intervals over 5–7 wk up to the lower end of the '
              'following daily target maintenance dosing range (if needed and tolerated, '
              'increase to higher end of dosing range by increasing by 25–50 mg/24 hr at '
              'weekly intervals):'),
          DoseLine('≤11 kg: 150–250 mg/24 hr ÷ BID'),
          DoseLine('12–22 kg: 200–300 mg/24 hr ÷ BID'),
          DoseLine('23–31 kg: 200–350 mg/24 hr ÷ BID'),
          DoseLine('32–38 kg: 250–350 mg/24 hr ÷ BID'),
          DoseLine('>38 kg: 250–400 mg/24 hr ÷ BID'),
          DoseLine('Child ≥10 yr and adult: Start with 25 mg PO BID × 7 days, then increase '
              'by 50 mg/24 hr increments at 1-wk intervals up to a max. dose of 100 mg '
              'PO BID at wk 4. If needed, dose may be further increased at weekly '
              'intervals by 100 mg/24 hr up to a recommended max. dose of 200 mg PO BID.'),
        ],
      ),
      DoseSection(
        heading: 'Migraine prophylaxis:',
        lines: [
          DoseLine('Child 6 to <12 yr and ≥20 kg (limited data): Start with 15 mg PO once '
              'daily × 7 days, then increase to 25 mg PO BID × 7 days, then gradually '
              'increase dose to effect up to a target dose of 2–3 mg/kg/24 hr ÷ BID '
              '(max. dose: 200 mg/24 hr).'),
          DoseLine('Child ≥12 yr and adult: Titrate dosage to 50 mg PO BID with the following '
              'schedule:'),
        ],
        table: DoseTable(
          headers: ['', 'Morning PO Dose (mg)', 'Evening PO Dose (mg)'],
          rows: [
            DoseTableRow(['Week 1', 'None', '25 mg']),
            DoseTableRow(['Week 2', '25', '25']),
            DoseTableRow(['Week 3', '25', '50']),
            DoseTableRow(['Week 4 and beyond', '50', '50']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('Use clinical outcome to guide dose and titration. Longer intervals '
              'between dose adjustments can be used.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in renal and hepatic dysfunction (decreased clearance) '
          'and sulfa hypersensitivity. Reduce dose by 50% when creatinine clearance '
          'is <70 mL/min. Common side effects (incidence lower in children) include '
          'ataxia, cognitive dysfunction, dizziness, nystagmus, paresthesia, '
          'sedation, visual disturbances, nausea, dyspepsia, and kidney stones '
          '(higher urinary calcium/citrate ratio; incidence higher in children). '
          'Secondary angle-closure glaucoma characterized by ocular pain, acute '
          'myopia, and increased intraocular pressure has been reported and may lead '
          'to blindness if left untreated. Patients should be instructed to seek '
          'immediate medical attention if they experience blurred vision or '
          'periorbital pain. Oligohidrosis and hyperthermia have been reported '
          'primarily in children and should be monitored, especially during hot '
          'weather and with use of drugs that predispose patients to heat-related '
          'disorders (e.g., carbonic anhydrase inhibitors and anticholinergics). Low '
          'serum bicarbonate levels, negative effects on growth (height and weight) '
          'in children, increased serum creatinine and glucose in children, and '
          'decreased bone mineral density have been reported in clinical trials. '
          'Hyperchloremic, non–anion gap metabolic acidosis, hyperammonemia (with or '
          'without encephalopathy), suicidal behavior or ideation, serious skin '
          'reactions (e.g., Stevens-Johnson syndrome and toxic epidermal '
          'necrolysis), and false-positive sweat chloride test for cystic fibrosis '
          'have been reported.',
      'Drug is metabolized by and inhibits the cytochrome P-450 2C19 isoenzyme. '
          'Phenytoin, valproic acid, and carbamazepine may decrease topiramate '
          'levels. Topiramate may decrease valproic acid, digoxin, warfarin, and '
          'ethinyl estradiol (to decrease oral contraceptive efficacy) but may '
          'increase phenytoin levels/effects. Alcohol and central nervous system '
          '(CNS) depressants may increase CNS side effects. Carbonic anhydrase '
          'inhibitors (e.g., acetazolamide) may increase risk of metabolic acidosis, '
          'nephrolithiasis, or paresthesia. Use with valproic acid may result in the '
          'development of hyperammonemia.',
      'Safety and efficacy in migraine prophylaxis in pediatrics have not been '
          'established; an increase in serum creatinine has been reported in a '
          'clinical trial.',
      'Use in pregnancy may increase risk for major congenital malformations '
          'such as cleft lip and/or palate, and small for gestational age.',
      'Trokendi XR is bioequivalent to immediate-release dosage forms, and these '
          'forms are dosed at their respective recommended dosage intervals. Doses '
          'may be administered with or without food. Capsule may be opened and '
          'sprinkled on small amount of food (e.g., 1 teaspoonful of applesauce) and '
          'swallowed whole (do not chew). Maintain adequate hydration to prevent '
          'kidney stone formation. If discontinuing therapy, gradually taper dosage.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1251–1252',
  ),
  // TRAZODONE — PDF p. 444 (printed 1253)
  DrugEntryV3(
    name: 'TRAZODONE',
    brandNames: 'Raldesy and generics; previously available as Desyrel',
    drugClass: 'Antidepressant, serotonin reuptake inhibitor/antagonist, '
        'triazolopyridine derivative',
    iconRow: '',
    formulations: [
      'Tabs: 50, 100, 150, 300 mg',
      'Oral solution (Raldesy): 10 mg/mL (150, 300 mL); contains '
          'ethylenediaminetetra-acetic acid (EDTA) and sodium benzoate',
      'Oral suspension: 10 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Insomnia with comorbid psychiatric disorders (limited data):',
        lines: [
          DoseLine('18 mo to <3 yr: Start at 1–2 mg/kg/dose (max. dose: 25 mg) PO QHS. If '
              'needed, increase by 12.5–25 mg Q2 wk up to 3 mg/kg/dose QHS, not to '
              'exceed a max. of 100 mg/24 hr.'),
          DoseLine('3–5 yr: Start at 1–2 mg/kg/dose (max. dose: 50 mg) PO QHS. If needed, '
              'increase by 12.5–25 mg Q2 wk up to 3 mg/kg/dose QHS, not to exceed a max. '
              'of 150 mg/24 hr.'),
          DoseLine('>5 yr–adolescent: 25–50 mg PO QHS; if needed, increase by 12.5–25 mg Q2 '
              'wk up to a max. of 200 mg/24 hr. Daily dose may be divided BID–TID when '
              'used for palliative care.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in preexisting cardiac disease, in initial recovery '
          'phase of myocardial infarction, in patients receiving antihypertensive '
          'medications, in renal and hepatic impairment (has not been evaluated), '
          'and with electroconvulsive therapy. Common side effects include '
          'dizziness, drowsiness, dry mouth, and diarrhea. May cause angle-closure '
          'glaucoma in patients with anatomically narrow angles who do not have an '
          'iridectomy. Seizures, tardive dyskinesia, extrapyramidal syndrome, '
          'arrhythmias, priapism, blurred vision, neuromuscular weakness, anemia, '
          'orthostatic hypotension, and rash have been reported. Monitor for '
          'clinical worsening of depression and suicidal ideation/behavior following '
          'the initiation of therapy or after dose changes.',
      'Trazodone is a cytochrome P-450 3A4 isoenzyme substrate (may interact '
          'with inhibitors and inducers) and may increase digoxin levels and '
          'increase central nervous system (CNS) effects of alcohol, barbiturates, '
          'and other CNS depressants.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1253',
  ),
  // TREPROSTINIL — PDF p. 444–445 (printed 1253–1254)
  DrugEntryV3(
    name: 'TREPROSTINIL',
    brandNames: 'Remodulin, Tyvaso, Tyvaso DPI, Orenitram, and generics',
    drugClass: 'Prostaglandin I₂ analogue, vasodilator',
    iconRow: '',
    formulations: [
      'Injection:',
      'Remodulin and generics: 1 mg/mL (20 mL), 2.5 mg/mL (20 mL), 5 mg/mL (20 '
          'mL), 10 mg/mL (20 mL); contains metacresol',
      'Inhalation solution:',
      'Tyvaso: 0.6 mg/mL (2.9 mL; 4s and 28s); use with Tyvaso inhalation system',
      'Powder for inhalation:',
      'Tyvaso DPI: 16, 32, 48, 64 mCg (16 cartridges with 2 inhaler devices, 112 '
          'cartridges with 5 inhaler devices)',
      'Extended-release tab:',
      'Orenitram: 0.125, 0.25, 1, 2.5, 5 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Pulmonary arterial hypertension (PAH):',
        lines: [
          DoseLine(
            'IV/SC infusion:',
            isHeading: true,
          ),
          DoseLine('Child (limited data): Initial dose of 2 nanogram/kg/min has been '
              'recommended with careful titration. Stable doses have been reported at '
              '50–80 nanogram/kg/min with an unknown maximum dosage. Dosages as high as '
              '350 and 170 nanogram/kg/min have been reported with the SC and IV routes, '
              'respectively.'),
          DoseLine('Adult (naive to prostacyclin therapy): Start at 1.25 nanogram/kg/min. If '
              'not tolerated, reduce to 0.625 nanogram/kg/min. If needed, increase dose '
              'at increments of 1.25 nanogram/kg/min per wk for the first 4 wk followed '
              'by 2.5 nanogram/kg/min per wk thereafter. Usual target dose: 40–80 '
              'nanogram/kg/min'),
          DoseLine(
            'Inhalation:',
            isHeading: true,
          ),
          DoseLine('Child (limited data): 1–9 patient-activated breaths (6–54 mCg) Q6 hr. In '
              'a retrospective report, 29 children with PAH receiving background therapy '
              'initially received 3 breaths (18 mCg) via oral inhalation QID and '
              'titrated doses weekly as tolerated to a maximum of 9 breaths (54 mCg) QID '
              'for ≥6 wk. Nineteen of 29 children had World Health Organization '
              'functional class improvement (significant improvements in exercise '
              'tolerance and peak oxygen consumption). Four children had to discontinue '
              'therapy for reasons of O₂ desaturation (1), progression of PAH (1), and '
              'chest tightness with bronchospasms (2).'),
          DoseLine('Adult: Start at 3 breaths (18 mCg) via oral inhalation Q4 hr four times a '
              'day during waking hours. Reduce dose to 1 or 2 breaths if not tolerated '
              'and subsequently increase to 3 breaths. If needed and tolerated, increase '
              'dose by 3 additional inhalations at ~1–2 wk intervals to the target and '
              'maximum maintenance dose of 9 breaths (54 mCg) QID.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in liver or renal impairment by titrating doses slowly. '
          'Avoid use with the oral dosage form in Child-Pugh classes B and C. '
          'Treprostinil is primarily metabolized by the liver via cytochrome P-450 '
          '2C8, and its metabolites are excreted primarily via the urinary route. '
          'Inhibitors (e.g., gemfibrozil) and inducers (e.g., rifampin) may increase '
          'and decrease treprostinil effects, respectively.',
      'Flushing, muscle pain (especially with SC route), headaches, and diarrhea '
          'are common side effects with injectable routes. Central line '
          'gram-negative catheter infections have been reported with the IV route. '
          'Recommendations for reducing this risk include using watertight seals in '
          'the drug delivery system and closed-hub systems, replacing the diluent '
          'with the diluent used for epoprostenol, and using the SC route. '
          'Thrombocytopenia has been reported with SC administration. Worsening of '
          'reactive airway symptoms, bronchospasm, cough, dizziness, muscle pain, '
          'bone or jaw pain, headache, syncope, and flushing may occur with the '
          'inhaled route. Headache, diarrhea, nausea, and flushing are common side '
          'effects with the oral dosage form in clinical trials.',
      'Treprostinil has a longer half-time (T₁/₂) than epoprostenol with better '
          'room temperature stability (depending on specific diluent used).',
      'Do not abruptly withdraw therapy, and have a backup plan for '
          'interruptions with IV/SC continuous therapies (e.g., backup pumps and '
          'medications).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1253–1254',
  ),
  // TRETINOIN—TOPICAL PREPARATIONS — PDF p. 445–447 (printed 1254–1256)
  DrugEntryV3(
    name: 'TRETINOIN—TOPICAL PREPARATIONS',
    brandNames: 'Retin-A, Retin-A Micro, Altreno, Atralin, Renova, and many others\n'
        'In combination with clindamycin: Ziana and generics\nIn combination '
        'with benzoyl peroxide: Twyneo',
    drugClass: 'Retinoic acid derivative, topical acne product',
    iconRow: '',
    formulations: [
      'Cream (all strengths may contain parabens, benzyl alcohol, and edetate '
          'disodium):',
      '0.02% (20, 40, 44, 60 g): Renova',
      '0.025% (20, 45 g): Retin-A, and generics',
      '0.05% (20, 45 g): Generics',
      '0.1% (20, 45 g): Generics',
      'Topical gel (all strengths may contain 90% alcohol, benzyl alcohol, '
          'propylene glycol, and trolamine):',
      '0.01% (15, 45 g): Retin-A and generics',
      '0.025% (15, 45 g): Generics',
      '0.04% (20, 45, 50 g): Retin-A Micro and generics',
      '0.05% (45 g): Atralin and generics',
      '0.06% (50 g): Retin-A Micro',
      '0.08% (50 g): Retin-A Micro and generics',
      '0.1% (20, 45, 50 g): Retin-A Micro and generics',
      'Lotion (Altreno):',
      '0.05% (20, 45 g), contains benzyl alcohol, parabens, and trolamine',
      'In combination with clindamycin:',
      'Topical gel (Ziana, and generics): 0.025% tretinoin and 1.2% clindamycin '
          '(30, 60 g); may contain parabens, tromethamine, and '
          'ethylenediaminetetra-acetic acid (EDTA)',
      'In combination with benzoyl peroxide:',
      'Topical cream (Twyneo): 0.1% tretinoin and 3% benzoyl peroxide (30 g); '
          'contains alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Topical for acne:',
        lines: [
          DoseLine('Child ≥12 yr and adult: Gently wash face with a mild soap, pat the skin '
              'dry, and wait 20–30 min before use. Initiate therapy with lower strengths '
              '(0.02% or 0.025% cream, or 0.01% gel) and apply a small pea-size amount '
              'to the affected areas of the face QHS or on alternate days. See remarks.'),
          DoseLine('Altralin gel 0.05% (Child ≥10 yr): Apply a thin layer of gel to affected '
              'areas QHS after thoroughly cleaning the skin.'),
          DoseLine('Altreno lotion 0.05% (Child ≥9 yr): Apply a thin layer of lotion to '
              'affected areas once daily.'),
        ],
      ),
      DoseSection(
        heading: 'In combination with clindamycin:',
        lines: [
          DoseLine('Child ≥12 yr and adult: Gently wash face with a mild soap, pat the skin '
              'dry, and wait 20–30 min before use. Apply a pea-size amount to entire '
              'face QHS.'),
        ],
      ),
      DoseSection(
        heading: 'In combination with benzoyl peroxide:',
        lines: [
          DoseLine('Child ≥9 yr and adult: Apply a thin layer to affected areas once daily on '
              'clean and dry skin.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in sunburns. Avoid excessive sun exposure. If stinging or '
          'irritation occurs, decrease frequency of administration to every other '
          'day. Avoid contact with eyes, ears, nostrils, mouth, or open wounds. '
          'Local adverse effects include irritation, erythema, excessive dryness, '
          'blistering, crusting, hyperpigmentation or hypopigmentation, and acne '
          'flare-ups. Concomitant use of other topical acne products may lead to '
          'significant skin irritation. Onset of therapeutic benefits may be '
          'experienced within 2–3 wk with optimal effects in 6 wk. The gel dosage '
          'form is flammable and should not be exposed to heat or temperatures '
          '>120°F.',
      'Retin-A Micro: Avoid contact with lime peel and application area. The '
          '0.04% topical gel has been used in children ≥8 yr as reported in the '
          'literature.',
      'In combination with clindamycin (additional remarks from above): '
          'Contraindicated in regional enteritis, ulcerative colitis, or history of '
          'antibiotic-associated colitis. Prolonged use may result in fungal and '
          'bacterial superinfection, including Clostridium difficile–associated '
          'diarrhea. Common side effects include burning sensation, desquamation, '
          'erythema, and xeroderma. See Clindamycin (topical use) for additional '
          'information.',
      'In combination with benzoyl peroxide (additional remarks from above): '
          'Contraindicated with a history of hypersensitivity reactions to either '
          'components. Common side effects include pain at application site, '
          'application-site scaling, erythema, dry skin, pruritus, and irritation. '
          'See Benzoyl Peroxide for additional information.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1254–1256',
  ),
  // TRIMETHOBENZAMIDE HCL — PDF p. 447 (printed 1256)
  DrugEntryV3(
    name: 'TRIMETHOBENZAMIDE HCL',
    brandNames: 'Tigan and generics',
    drugClass: 'Antiemetic',
    iconRow: '',
    formulations: [
      'Caps: 300 mg',
      'Injection (Tigan): 100 mg/mL (2 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Nausea/Vomiting (see remarks):',
        lines: [
          DoseLine('Child PO (avoid use in infants; limited data): 15–20 mg/kg/24 hr ÷ '
              'TID–QID PRN'),
          DoseLine(
            'Alternative dosing:',
            isHeading: true,
          ),
          DoseLine('<13.6 kg: 100 mg TID–QID PRN'),
          DoseLine('13.6–40 kg: 100–200 mg/dose TID–QID PRN'),
          DoseLine('>40 kg: 300 mg/dose TID–QID PRN'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('PO: 300 mg/dose TID–QID PRN'),
          DoseLine('IM: 200 mg/dose TID–QID PRN'),
        ],
      ),
    ],
    remarks: [
      'Do not use in premature or newborn infants. Avoid use in patients with '
          'hepatotoxicity, acute vomiting, medications with central nervous system '
          '(CNS) depressant effects, or allergic reaction. CNS disturbances are '
          'common in children (extrapyramidal symptoms, drowsiness, confusion, '
          'dizziness). Hypotension, especially with IM use, may occur. IM not '
          'recommended in children. Consider reducing dosage in the presence of '
          'renal impairment since a significant amount of drug is excreted and '
          'eliminated by the kidney.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1256',
  ),
  // TRIAMCINOLONE — PDF p. 447–449 (printed 1256–1258)
  DrugEntryV3(
    name: 'TRIAMCINOLONE',
    brandNames: 'Nasal preparations: Nasacort Allergy 24HR, Nasal Allergy 24 Hour, '
        'and generics\nTopical preparations: Triderm, Kourzeq, Oralone, and '
        'generics; previously available as Kenalog\nInjection preparations: '
        'Kenalog-10, Kenalog-40, Kenalog-80, Hexatrione, Zilretta, generics, '
        'and others in kits',
    drugClass: 'Corticosteroid',
    iconRow: '',
    formulations: [
      'Nasal spray:',
      'Nasacort Allergy 24HR, Nasal Allergy 24 Hour, and generics [OTC]: 55 '
          'mCg/actuation (60 actuations per 10.8 mL, 120 actuations per 16.9 mL); '
          'contains benzalkonium chloride, polysorbate 80, and '
          'ethylenediaminetetra-acetic acid (EDTA)',
      'Cream:',
      'Generics: 0.025% (15, 80, 454 g), 0.05% (15, 454 g), 0.1% (15, 30, 80, '
          '454 g); contains propylene glycol',
      'Triderm: 0.025% (15 g), 0.1% (28.4 g), 0.5%, (15 g)',
      'Ointment:',
      'Generics: 0.025% (15, 80, 454 g), 0.05% (110, 430 g), 0.1% (15, 30, 80, '
          '454 g), 0.5% (15 g)',
      'Lotion: 0.025%, 0.1% (60 mL)',
      'Topical aerosol:',
      'Generics: 0.2 mg/2-sec spray; each g of spray contains 0.147 mg '
          'triamcinolone acetate (63, 100 g); contains 10.3% alcohol',
      'Dental paste:',
      'Kourzeq, Oralone and generics: 0.1% (5 g)',
      'See Chapter 10 for potency rankings and sizes of topical preparations.',
      'Injection as acetonide: 10 mg/mL (Kenalog-10) (5 mL), 40 mg/mL '
          '(Kenalog-40 and generics) (1, 5, 10 mL), 80 mg/mL (Kenalog-80) (1, 5 mL); '
          'all strengths contain benzyl alcohol and polysorbate 80.',
      'Kits (all contain benzyl alcohol and polysorbate 80):',
      'P-Care K40: 40 mg/mL (1 × 1 mL)',
      'P-Care K80, Pro-C-Dure 5: 40 mg/mL (2 × 1 mL)',
      'Pro-C-Dure 6: 40 mg/mL (3 × 1 mL)',
      'Intra-articular injectable suspension:',
      'As hexacetonide (Hexatrione 2%): 20 mg/mL (2 mL); contains benzyl alcohol '
          'and polysorbate 80; NOTE: a US Food and Drug Administration '
          '(FDA)–unapproved product for use in drug shortage',
      'As acetonide in a microsphere formulation (Zilretta): 32 mg (1); contains '
          'polysorbate 80',
    ],
    doseSections: [
      DoseSection(
        heading: 'Intranasal for allergic rhinitis (titrate to lowest effective dose '
            'after symptoms are controlled; discontinue use if no relief of '
            'symptoms occurs after 3 wk of use):',
        lines: [
          DoseLine('Child 2–5 yr: 1 spray in each nostril once daily (110 mCg/24 hr; starting '
              'and max. dose)'),
          DoseLine('Child 6–11 yr: Start with 1 spray in each nostril once daily (110 mCg/24 '
              'hr). If no benefit in 1 wk, dose may be increased to the max. dose of 2 '
              'sprays in each nostril once daily (220 mCg/24 hr). Decrease dose back to '
              '1 spray in each nostril when symptoms are controlled.'),
          DoseLine('≥12 yr and adult: 2 sprays in each nostril once daily (220 mCg/24 hr; '
              'starting and max. dose). Decrease dose to 1 spray in each nostril (110 '
              'mCg/24 hr) when symptoms are controlled.'),
        ],
      ),
      DoseSection(
        heading: 'Topical cream or ointment:',
        lines: [
          DoseLine(
            'Infant, child, and adult:',
            isHeading: true,
          ),
          DoseLine('0.025% or 0.05%: Apply a thin film to affected areas BID–QID.'),
          DoseLine('0.1% or 0.5%: Apply a thin film to affected areas BID–TID.'),
        ],
      ),
      DoseSection(
        heading: 'Topical aerosol or lotion (0.025% or 0.1%):',
        lines: [
          DoseLine('Infant, child, and adult: Spray or apply to affected area TID–QID.'),
        ],
      ),
      DoseSection(
        heading: 'SYSTEMIC USE (see remarks):',
        lines: [
          DoseLine(
            'Anti-inflammatory and allergic condition:',
            isHeading: true,
          ),
          DoseLine('Child and adolescent (use 40 or 80 mg/mL strength, deep IM into gluteal '
              'muscle): 0.11–1.6 mg/kg/24 hr IM ÷ TID–QID'),
          DoseLine(
            'Intralesional for dermatosis:',
            isHeading: true,
          ),
          DoseLine('≥12 yr and adult (use 10 mg/mL strength): Inject up to 1 mg/site × 1 and '
              'may be repeated × 1 or more times weekly. May give separate doses in '
              'sites ≥1 cm apart, not to exceed 30 mg.'),
        ],
      ),
    ],
    remarks: [
      'NASAL USE: Rare reports of bone mineral density loss and osteoporosis '
          'have been made with prolonged use of inhaled dosage form. Nasal '
          'preparations may cause epistaxis, cough, fever, nausea, throat '
          'irritation, dyspepsia, and fungal infections (rarely). Shake intranasal '
          'dosage forms before each use.',
      'TOPICAL USE: Topical preparations may cause dermal atrophy, '
          'telangiectasias, and hypopigmentation. Hypothalamic-pituitary-adrenal '
          'axis suppression, Cushing syndrome, and intracranial hypertension have '
          'been reported in children with topical use. Topical steroids should be '
          'used with caution on the face and in intertriginous areas. See Chapter 8. '
          'Avoid spraying the eye or inhaling the topical aerosol dosage form. '
          'Aerosol dosage form is flammable.',
      'INJECTABLE USE: Anaphylaxis has been reported with use of the injectable '
          'dosage form. Dosage adjustment for hepatic failure with systemic use may '
          'be necessary. Triamcinolone is a substrate of the cytochrome P-450 3A4 '
          'enzyme; inhibitors of this enzyme may increase risk for side effects. '
          'Cardiac enlargement and congestive heart failure have been reported with '
          'concomitant use with amphotericin B and hydrocortisone. Use with caution '
          'in thyroid dysfunction, respiratory tuberculosis, ocular herpes simplex, '
          'peptic ulcer disease, osteoporosis, hypertension, congestive heart '
          'failure, myasthenia gravis, ulcerative colitis, and renal dysfunction. '
          'With systemic use, pregnancy category changes to “D” if used in the first '
          'trimester. Avoid IV administration with injectable dosage forms. '
          'Injectable forms contain benzyl alcohol.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1256–1258',
  ),
  // TRIAMTERENE — PDF p. 449 (printed 1258)
  DrugEntryV3(
    name: 'TRIAMTERENE',
    brandNames: 'Dyrenium and generics',
    drugClass: 'Diuretic, potassium sparing',
    iconRow: '',
    formulations: [
      'Caps: 50, 100 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hypertension:',
        lines: [
          DoseLine('Child (limited data): 1–2 mg/kg/24 hr PO ÷ BID. May increase up to a max. '
              'of 3–4 mg/kg/24 hr up to 300 mg/24 hr'),
          DoseLine('Adult: 50–100 mg/24 hr PO ÷ once daily–BID; max. dose: 300 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Do not use if glomerular filtration rate <10 mL/hr or in severe hepatic '
          'disease. Adjust dose in renal impairment (see Chapter 32) and cirrhosis. '
          'Monitor serum electrolytes. May cause hyperkalemia, hyponatremia, '
          'hypomagnesemia, and metabolic acidosis. Interstitial nephritis, '
          'thrombocytopenia, and anaphylaxis have been reported.',
      'Concurrent use of angiotensin-converting enzyme inhibitors may increase '
          'serum potassium. Use with caution when administering medications with '
          'high potassium load (e.g., some penicillins) and in patients with hepatic '
          'impairment or on high-potassium diets. Cimetidine may increase effects. '
          'This drug is also available as a combination product with '
          'hydrochlorothiazide; erythema multiforme and toxic epidermal necrolysis '
          'have been reported with this combination product. Administer doses with '
          'food to minimize gastrointestinal upset. Pregnancy category changes to '
          '“D” if used in pregnancy-induced hypertension.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1258',
  ),
  // TRIFLURIDINE — PDF p. 449–450 (printed 1258–1259)
  DrugEntryV3(
    name: 'TRIFLURIDINE',
    brandNames: 'Generics; previously available as Viroptic',
    drugClass: 'Antiviral, ophthalmic',
    iconRow: '',
    formulations: [
      'Ophthalmic solution: 1% (7.5 mL); contains thimerosal',
    ],
    doseSections: [
      DoseSection(
        heading: 'Herpes keratoconjunctivitis:',
        lines: [
          DoseLine('≥6 yr, adolescent, and adult: Instill 1 drop into affected eye(s) Q2 hr '
              'while awake up to a maximum of 9 drops/24 hr. Reduce dose when there is '
              're-epithelialization of the corneal ulcer to 1 drop Q4 hr (minimum 5 '
              'drops/24 hr) × 7 days. If improvement does not occur in 7–14 days, '
              'consider alternative therapy. DO NOT EXCEED 21 days of treatment.'),
        ],
      ),
    ],
    remarks: [
      'Burning sensation in eyes and palpebral edema are common side effects. '
          'Rare cross sensitivity with idoxuridine, increased intraocular pressure, '
          'keratoconjunctivitis, and ocular hyperemia have been reported.',
      'Avoid touching the applicator tip to eye, fingers, or other surfaces, and '
          'do not wear contact lenses during treatment of ocular infections. Apply '
          'pressure to the lacrimal sac during and for 1–2 min after dose '
          'administration to reduce risk of systemic absorption.',
      'Store medication in the refrigerator (2°C–8°C). Storage at room '
          'temperature will result in a decrease in pH, which will cause stinging '
          'and ocular discomfort when in use.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1258–1259',
  ),
  // TRIKAFTA — PDF p. 450 (printed 1259)  [cross-reference]
  DrugEntryV3(
    name: 'TRIKAFTA',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Elexacaftor/Tezacaftor/Ivacaftor.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1259',
  ),
  // TRIMETHOPRIM AND SULFAMETHOXAZOLE — PDF p. 450 (printed 1259)  [cross-reference]
  DrugEntryV3(
    name: 'TRIMETHOPRIM AND SULFAMETHOXAZOLE',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Sulfamethoxazole and Trimethoprim.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1259',
  ),
];
