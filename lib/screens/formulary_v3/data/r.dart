// =============================================================================
// output/r.dart — Drug Formulary 3.0, letter R
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyR` per file; entries in book order.
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

const List<DrugEntryV3> formularyR = [
  // RALTEGRAVIR — PDF p. 388–389 (printed 1197–1198)
  DrugEntryV3(
    name: 'RALTEGRAVIR',
    brandNames: 'Isentress and Isentress HD',
    drugClass: 'Antiretroviral agent, integrase inhibitor',
    iconRow: '',
    formulations: [
      'Tabs:',
      'Isentress: 400 mg',
      'Isentress HD: 600 mg',
      'Chewable tabs: 25, 100 mg; contains aspartame and saccharin (100-mg tab '
          'is scored)',
      'Oral powder for suspension: 100 mg (60 packets); contains polyethylene '
          'glycol; each 100-mg packet is suspended in 10 mL of water to provide a '
          'final concentration of 10 mg/mL (see remarks).',
    ],
    doseSections: [
      DoseSection(
        heading: 'Human immunodeficiency virus (HIV) treatment:',
        lines: [
          DoseLine('See https://clinicalinfo.hiv.gov/en/guidelines'),
        ],
      ),
      DoseSection(
        heading: 'HIV vertical transmission and presumptive treatment during high-risk '
            'situations (mothers who received no antepartum antiretroviral '
            'therapy, mothers who received only intrapartum antiretroviral '
            'therapy, mothers who receive antepartum antiretroviral therapy but '
            'with suboptimal viral suppression [>50 copies/mL] within 4 weeks '
            'prior to delivery, or mothers with acute or primary HIV infection '
            'during pregnancy or breastfeeding [immediately discontinue '
            'breastfeeding]). Transition to a treatment regimen if positive HIV '
            'diagnosis is confirmed and discontinue use after a negative '
            'diagnosis; see Chapter 17 for additional information:',
        lines: [
          DoseLine(
            '≥37 weeks gestation at birth and ≥2 kg (use 10 mg/mL oral suspension '
                'dosage form in combination with zidovudine and lamivudine administered '
                'from birth up to 6 weeks; delay first dose of raltegravir 24–48 hr after '
                'birth if mother received raltegravir 2–24 hr prior to delivery, but '
                'initiate zidovudine and lamivudine immediately):',
            isHeading: true,
          ),
          DoseLine('<7 days old: 1.5 mg/kg/dose PO once daily or by the following weight '
              'categories:'),
          DoseLine('2–<3 kg: 4 mg PO once daily'),
          DoseLine('3–<4 kg: 5 mg PO once daily'),
          DoseLine('4–<5 kg: 7 mg PO once daily'),
          DoseLine('1–4 weeks old: 3 mg/kg/dose PO BID or by the following weight categories:'),
          DoseLine('2–<3 kg: 8 mg PO BID'),
          DoseLine('3–<4 kg: 10 mg PO BID'),
          DoseLine('4–<5 kg: 15 mg PO BID'),
          DoseLine('4–6 weeks old: 6 mg/kg/dose PO BID or by the following weight categories:'),
          DoseLine('3–<4 kg: 25 mg PO BID'),
          DoseLine('4–<6 kg: 30 mg PO BID'),
          DoseLine('6–<8 kg: 40 mg PO BID'),
        ],
      ),
    ],
    remarks: [
      'Common side effects include nausea, headache, increased alanine '
          'transaminase and other liver enzymes, insomnia, and fatigue. Severe and '
          'life-threatening skin reactions (e.g., Stevens-Johnson syndrome, toxic '
          'epidermal necrolysis), hypersensitivity reactions characterized by rash, '
          'organ dysfunction (including hepatic failure), immune reconstitution '
          'syndrome, hyperglycemia, rhabdomyolysis, and autoimmune disorders (e.g., '
          'Graves disease and Guillain-Barré syndrome) have been reported.',
      'Raltegravir is ~83% protein bound and primarily metabolized via the '
          'uridine diphosphate–glucuronosyltransferase (UGT)1A1 glucuronidation '
          'pathway. UGT1A1 activity is low at birth and increases rapidly during the '
          'next 4–6 weeks of life. No dosing information is currently available for '
          'preterm infants or infants weighing <2 kg at birth and for severe hepatic '
          'impairment. Use with antacids containing aluminum or magnesium salts may '
          'reduce raltegravir levels and is not recommended. Medications containing '
          'polyvalent cations (e.g., supplements containing iron, calcium, or '
          'magnesium; sucralfate; and laxatives) should be spaced apart by '
          'administering raltegravir at least 2 hr before or 6 hr after the '
          'administration of polyvalent cation medicine. Use with fosamprenavir may '
          'result in reduced levels of amprenavir and raltegravir. Other medications '
          'that could decrease raltegravir levels and effects include rifampin, '
          'orlistat, and etravirine. Omeprazole may increase raltegravir levels.',
      'Each dosage form has a different pharmacokinetic profile; dosage forms '
          'are not interchangeable. Oral tablets must be swallowed whole, and the '
          'chewable tablet may be crushed and mixed with ~5 mL of water, juice, or '
          'breast milk. The oral powder for suspension is suspended in water by '
          'gently swirling in a mixing cup for 45 sec in a circular motion and must '
          'be administered within 30 min after reconstitution. Doses may be '
          'administered with or without food; however, the effect of food on the '
          'oral suspension has not been evaluated.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1197–1198',
  ),
  // RASBURICASE — PDF p. 389–390 (printed 1198–1199)
  DrugEntryV3(
    name: 'RASBURICASE',
    brandNames: 'Elitek',
    drugClass: 'Antihyperuricemic agent',
    iconRow: '',
    formulations: [
      'Injection: 1.5, 7.5 mg; contains mannitol and L-alanine',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hyperuricemia (all ages; see remarks):',
        lines: [
          DoseLine('0.1–0.2 mg/kg/dose (rounded down to the nearest whole 1.5-mg multiple) '
              'intravenously over 30 min × 1. Patients generally respond to one dose, '
              'but if needed, dose may be repeated Q24 hr for up to four additional '
              'doses.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in glucose-6-phosphate dehydrogenase deficiency (risk for '
          'acute hemolytic anemia) or history of hypersensitivity, hemolytic '
          'reactions, or methemoglobinemia with rasburicase. Use with caution in '
          'asthma, allergies, hypersensitivity with other medications, and children '
          '<2 yr of age (decreased efficacy and increased risk for rash, vomiting, '
          'diarrhea, and fever).',
      'Common side effects include nausea, vomiting, abdominal pain, discomfort, '
          'diarrhea, constipation, mucositis, fever, and rash. Serious and fatal '
          'hypersensitivity reactions, including anaphylaxis, have been reported in '
          '<1% of patients and can occur at any time; discontinue use immediately '
          'and permanently.',
      'During therapy, uric acid blood samples must be sent to the laboratory '
          'immediately. Blood should be collected in prechilled tubes containing '
          'heparin and placed in an ice-water bath to avoid potential falsely low '
          'uric acid levels (degradation of plasma uric acid occurs in the presence '
          'of rasburicase at room temperature). Centrifugation in a precooled '
          'centrifuge (4°C) is indicated. Plasma samples must be assayed within 4 hr '
          'of sample collection.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1198–1199',
  ),
  // RHₒ(D) IMMUNE GLOBULIN INTRAVENOUS (HUMAN) — PDF p. 390–391 (printed 1199–1200)
  DrugEntryV3(
    name: 'RHₒ(D) IMMUNE GLOBULIN INTRAVENOUS (HUMAN)',
    brandNames: 'WinRho-SDF, Rhophylac, HyperRHO S/D Mini-Dose, HyperRHO S/D Full '
        'Dose, RhoGAM Ultra-Filtered Plus',
    drugClass: 'Immune globulin',
    iconRow: '',
    formulations: [
      'Injection (WinRho-SDF): 1500 IU (1.3 mL), 2500 IU (2.2 mL), 5000 IU (4.4 '
          'mL), 15,000 IU (13 mL); may contain polysorbate 80',
      'Prefilled injection for intravenous (IV) or intramuscular (IM) '
          'administration:',
      'Rhophylac: 1500 IU (2 mL); preservative free',
      'Prefilled injection for IM administration:',
      'HyperRHO S/D Mini-Dose: 250 IU',
      'HyperRHO S/D Full Dose: 1500 IU',
      'RhoGAM Ultra-Filtered Plus: 1500 IU; contains polysorbate 80',
      'Conversion: 1 mCg = 5 IU',
      'IM route and IM dosage forms: Indicated for prevention of Rh hemolytic '
          'disease of newborn by administering to Rhₒ(D) negative mother or '
          'prevention of isoimmunization in Rhₒ(D)-negative individuals who have '
          'been transfused with Rhₒ(D)-positive blood/cell components.',
    ],
    doseSections: [
      DoseSection(
        heading: 'All doses based on international units (IU) and are product specific',
      ),
      DoseSection(
        heading: 'Immune thrombocytopenic purpura (nonsplenectomized Rhₒ[D]-positive '
            'patients; see remarks):',
        lines: [
          DoseLine(
            'WinRho-SDF (child, adolescent, and adult; see remarks):',
            isHeading: true,
          ),
          DoseLine(
            'Initial dose (may be given in two divided doses on separate days or as a '
                'single dose):',
            isHeading: true,
          ),
          DoseLine('Hemoglobin ≥10 g/dL: 250 IU/kg/dose IV × 1'),
          DoseLine('Hemoglobin 8–<10 g/dL: 125–200 IU/kg/dose IV × 1'),
          DoseLine('Hemoglobin <8 g/dL: Use alternative therapy.'),
          DoseLine(
            'Subsequent doses (actual dose and frequency of administration is '
                'determined by the patient’s clinical response and subsequent hemoglobin '
                'level):',
            isHeading: true,
          ),
          DoseLine('Hemoglobin ≥10 g/dL: 250–300 IU/kg/dose IV × 1'),
          DoseLine('Hemoglobin 8–<10 g/dL: 125–200 IU/kg/dose IV × 1'),
          DoseLine('Hemoglobin <8 g/dL: Use alternative therapy'),
          DoseLine('Rhophylac (child, adolescent, and adult; see remarks): 250 IU/kg/dose IV '
              '× 1'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in immunoglobulin A deficiency. Use with caution with '
          'history of atherosclerosis, known/suspected hyperviscosity, coagulation '
          'disorders, and other thrombotic risks. Adverse events associated with '
          'immune thrombocytopenic purpura (ITP) indication include headache, '
          'chills, fever, and reduction in hemoglobin (due to the destruction of '
          'Rhₒ[D] antigen-positive red cells). Intravascular hemolysis resulting in '
          'anemia and renal insufficiency has been reported. May interfere with '
          'immune response to live virus vaccines (e.g., MMR, varicella).',
      'Clinical response for ITP therapy requires monitoring of platelet counts, '
          'red blood cells, hemoglobin, and reticulocyte count. Rhₒ(D)-positive '
          'patients should be monitored for signs and symptoms of intravascular '
          'hemolysis, anemia, and renal insufficiency.',
      'Recommended IV administration rate:',
      'WinRho-SDF: Over 3–5 min',
      'Rhophylac: Each 1500 IU (2 mL) per 15–60 sec',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1199–1200',
  ),
  // RIBAVIRIN — PDF p. 391–392 (printed 1200–1201)
  DrugEntryV3(
    name: 'RIBAVIRIN',
    brandNames: 'Oral: Generics; previously available as Rebetol\nInhalation: '
        'Virazole and generics',
    drugClass: 'Antiviral agent',
    iconRow: '',
    formulations: [
      'Oral caps: 200 mg',
      'Tabs: 200 mg',
      'Aerosol (Virazole and generics): 6 g',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hepatitis C (oral [PO], see remarks):',
        lines: [
          DoseLine('Hepatitis C combination therapy is dependent on hepatitis C virus '
              'genotype and treatment status. Specific treatment recommendations are '
              'dynamic with newer therapies; see the most recent American Association '
              'for the Study of Liver Diseases/Infectious Disease Society of America '
              '(AASLD/IDSA) treatment recommendations at www.hcvguidelines.org'),
          DoseLine('Child: In combination with sofosbuvir for patients with genotypes 2 or 3 '
              'with/without cirrhosis:'),
          DoseLine(
            'Child ≥3 yr and adolescent (see remarks):',
            isHeading: true,
          ),
          DoseLine('<47 kg: 15 mg/kg/24 hr PO ÷ BID'),
          DoseLine('47–49 kg: 600 mg/24 hr PO ÷ BID'),
          DoseLine('50–65 kg: 800 mg/24 hr PO ÷ BID'),
          DoseLine('66–80 kg: 1000 mg/24 hr PO ÷ BID'),
          DoseLine('>80 kg: 1200 mg/24 hr PO ÷ BID'),
          DoseLine(
            'Duration of therapy:',
            isHeading: true,
          ),
          DoseLine('Genotype 2: 12 wk'),
          DoseLine('Genotype 3: 24 wk'),
          DoseLine(
            'Adult (see remarks):',
            isHeading: true,
          ),
          DoseLine(
            'Oral capsules or solution as part of a recommended combination therapy:',
            isHeading: true,
          ),
          DoseLine('<75 kg: 500 mg PO BID'),
          DoseLine('≥75 kg: 600 mg PO BID'),
        ],
      ),
      DoseSection(
        heading: 'Inhalation (see remarks):',
        lines: [
          DoseLine('Continuous: Administer 6 g by aerosol over 12–18 hr once daily for 3–7 '
              'days. The 6-g ribavirin vial is diluted in 300 mL preservative-free '
              'sterile water to a final concentration of 20 mg/mL. Must be administered '
              'with Viratek Small Particle Aerosol Generator (SPAG-2).'),
          DoseLine('Intermittent (for nonventilated patients and to minimize health care '
              'worker exposure; limited data): Administer 2 g by aerosol over 2 hr TID '
              'for 3–7 days. The 6-g ribavirin vial is diluted in 100 mL '
              'preservative-free sterile water to a final concentration of 60 mg/mL. '
              'Intermittent use is not recommended in patients with endotracheal tubes.'),
        ],
      ),
    ],
    remarks: [
      'ORAL RIBAVIRIN: Contraindicated in pregnancy, significant or unstable '
          'cardiac disease, autoimmune hepatitis, hepatic decompensation (Child-Pugh '
          'score >6; class B or C), hemoglobinopathies, and creatinine clearance <50 '
          'mL/min. Use with caution in preexisting cardiac disease, pulmonary '
          'disease, and sarcoidosis. Anemia (most common), insomnia, depression, '
          'irritability, and suicidal behavior (higher in adolescent and pediatric '
          'patients) have been reported with the oral route.',
      'Combination therapy with peginterferon for hepatitis C is no longer '
          'recommended due to poor efficacy. Tinnitus, hearing loss, vertigo, severe '
          'hypertriglyceridemia, and homicidal ideation have been reported in '
          'combination with interferon. Suicidal ideation or attempts have been '
          'reported more frequently among adolescents compared to adults (2.4% vs. '
          '1%) during treatment and off-therapy follow up. Pancytopenia has been '
          'reported in combination with interferon and azathioprine. Increased risk '
          'for hepatic decompensation with cirrhotic chronic hepatitis C patients '
          'treated with α interferons or with human immunodeficiency virus '
          'coinfection receiving highly active antiretroviral therapy and interferon '
          'alfa-2a. Growth inhibition (delays in weight and height increases) was '
          'observed in children (5–17 years old) receiving combination therapy for '
          'up to 48 weeks.',
      'May decrease the effects of zidovudine and stavudine and increase the '
          'risk for lactic acidosis with nucleoside analogues. Reduce or discontinue '
          'dosage for toxicity as follows: Patient with no cardiac disease:',
      'Hgb <10 g/dL and ≥8.5 g/dL:',
      'Child: 12 mg/kg/dose PO once daily; may further reduce to 8 mg/kg/dose PO '
          'once daily',
      'Adult: 600 mg PO once daily (capsules or solution) or 200 mg PO QAM and '
          '400 mg PO QPM (tablets)',
      'Hgb <8.5 g/dL: Discontinue therapy permanently.',
      'Patient with cardiac disease:',
      '≥2 mg/dL decrease in hemoglobin (Hgb) during any 4-week period during '
          'therapy:',
      'Child: 12 mg/kg/dose PO once daily; may further reduce to 8 mg/kg/dose PO '
          'once daily (monitor weekly)',
      'Adult: 600 mg PO once daily (capsules or solution) or 200 mg PO QAM and '
          '400 mg PO QPM (tablets)',
      'Hgb <12 g/dL after 4 weeks of reduced dose: Discontinue therapy '
          'permanently.',
      'INHALED RIBAVIRIN: Use of ribavirin for respiratory syncytial virus (RSV) '
          'is controversial and not routinely indicated. Aerosol therapy may be '
          'considered for selected infants and young children at high risk for '
          'serious RSV disease (see most recent edition of the AAP Redbook). Most '
          'effective if begun early in course of RSV infection, generally in the '
          'first 3 days. May cause worsening respiratory distress, rash, '
          'conjunctivitis, mild bronchospasm, hypotension, anemia, and cardiac '
          'arrest. Avoid unnecessary occupational exposure to ribavirin due to its '
          'teratogenic effects. Drug can precipitate in the respiratory equipment.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1200–1201',
  ),
  // RIBOFLAVIN — PDF p. 392–393 (printed 1201–1202)
  DrugEntryV3(
    name: 'RIBOFLAVIN',
    brandNames: 'Vitamin B₂ and various brands and generics',
    drugClass: 'Water-soluble vitamin',
    iconRow: '',
    formulations: [
      'Tabs [OTC]: 25, 50, 100 mg',
      'Caps [OTC]: 400 mg',
      'Oral liquid [OTC]: 8.125 mg/mL (30 mL), 12.5 mg/mL (60 mL);',
    ],
    doseSections: [
      DoseSection(
        heading: 'Riboflavin deficiency:',
        lines: [
          DoseLine('Child: 2.5–10 mg/24 hr PO ÷ once daily–BID'),
          DoseLine('Adult: 5–30 mg/24 hr PO ÷ once daily–BID'),
        ],
      ),
      DoseSection(
        heading: 'U.S. RDA requirements: See Chapter 21',
        lines: [
          DoseLine('.'),
        ],
      ),
      DoseSection(
        heading: 'Migraine prophylaxis (limited data):',
        lines: [
          DoseLine('Child ≥8 yr and adolescent: 200–400 mg PO once daily'),
        ],
      ),
    ],
    remarks: [
      'Hypersensitivity may occur. Administer with food. Causes yellow to orange '
          'discoloration of urine. For multivitamin information, see Chapter 21.',
    ],
    pregnancyNote: 'Pregnancy category changes to “C” if used in doses above the RDA.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1201–1202',
  ),
  // RIFABUTIN — PDF p. 393–394 (printed 1202–1203)
  DrugEntryV3(
    name: 'RIFABUTIN',
    brandNames: 'Generics; previously available as Mycobutin',
    drugClass: 'Antituberculous agent',
    iconRow: '',
    formulations: [
      'Caps: 150 mg',
      'Oral suspension: 20 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Mycobacterium avium complex (MAC) primary prophylaxis for first '
            'episode of opportunistic disease in human immunodeficiency virus '
            '(HIV) infection (see remarks for interactions and '
            'https://clinicalinfo.hiv.gov/en/guidelines:',
        lines: [
          DoseLine('Child >5 yr, adolescent, and adult: 300 mg PO once daily; doses may be '
              'administered as 150 mg PO BID if gastrointestinal (GI) upset occurs'),
        ],
      ),
      DoseSection(
        heading: 'MAC secondary prophylaxis for recurrence of opportunistic disease in '
            'HIV (in combination with ethambutol and a macrolide antibiotic '
            '[clarithromycin or azithromycin]):',
        lines: [
          DoseLine('Infant and child: 5 mg/kg/24 hr PO once daily; max. dose: 300 mg/24 hr'),
          DoseLine('Adolescent and adult: 300 mg PO once daily; doses may be administered 150 '
              'mg PO BID if GI upset occurs'),
        ],
      ),
      DoseSection(
        heading: 'MAC treatment:',
        lines: [
          DoseLine('Child: 10–20 mg/kg/24 hr PO once daily; max. dose: 300 mg/24 hr as part '
              'of a multidrug regimen for severe disease'),
          DoseLine('Adult: 300 mg PO once daily; may be used in combination with azithromycin '
              'and ethambutol'),
          DoseLine('Use in combination with HIV antiretroviral agents: See product '
              'information for dosage recommendations.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in patients being treated with cabotegravir/rilpivirine '
          'due to significant cytochrome P-450 (CYP) 3A enzyme induction (see below '
          'for additional drug interactions). Should not be used for MAC prophylaxis '
          'with active tuberculosis. May cause gastrointestinal (GI) distress, '
          'discoloration of skin and body fluids (brown–orange color), and marrow '
          'suppression. Rash, eosinophilia, and bronchospasm have been reported. Use '
          'with caution in renal and liver impairment. Adjust dose in renal '
          'impairment (see Chapter 32). May permanently stain contact lenses. '
          'Uveitis can occur when using high doses (>300 mg/24 hr in adults) in '
          'combination with macrolide antibiotics.',
      'Rifabutin is an inducer of CYP3A enzyme and is structurally similar to '
          'rifampin (similar drug interactions; see Rifampin). Clarithromycin, '
          'fluconazole, itraconazole, nevirapine, and protease inhibitors increase '
          'rifabutin levels. Efavirenz may decrease rifabutin levels. May decrease '
          'effectiveness of dapsone, delavirdine, nevirapine, amprenavir, indinavir, '
          'nelfinavir, saquinavir, itraconazole, warfarin, oral contraceptives, '
          'digoxin, cyclosporine, ketoconazole, and narcotics.',
      'Doses may be administered with food if patient experiences GI intolerance.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1202–1203',
  ),
  // RIFAMPIN — PDF p. 394–395 (printed 1203–1204)
  DrugEntryV3(
    name: 'RIFAMPIN',
    brandNames: 'Rifadin and generics',
    drugClass: 'Antibiotic, antituberculous agent, rifamycin',
    iconRow: '',
    formulations: [
      'Caps: 150, 300 mg',
      'Oral suspension: 10, 25 mg/mL',
      'Injection (Rifadin and generics): 600 mg; contains formaldehyde '
          'sulfoxylate',
    ],
    doseSections: [
      DoseSection(
        heading: 'Staphylococcus aureus infections (as part of synergistic therapy with '
            'other anti-staphylococcal agents):',
        lines: [
          DoseLine('Neonate, infant, child, and adolescent: 10–20 mg/kg/24 hr IV/PO ÷ Q12 hr; '
              'max. dose: 600 mg/24 hr'),
          DoseLine(
            'Prosthetic valve endocarditis:',
            isHeading: true,
          ),
          DoseLine('Empirical early infection (≤1 yr postsurgery): 20 mg/kg/24 hr IV/PO ÷ Q8 '
              'hr; max. dose: 900 mg/24 hr'),
          DoseLine('Empirical late infection (>1 yr postsurgery): 15–20 mg/kg/24 hr IV/PO ÷ '
              'Q12 hr; max. dose: 600 mg/24 hr'),
          DoseLine('Methicillin-resistant S. aureus infection: 15 mg/kg/24 hr IV/PO ÷ Q8 hr; '
              'max. dose: 900 mg/24 hr'),
          DoseLine('Adult: 600 mg once daily, or 300–450 mg IV/PO Q12 hr'),
          DoseLine('Prosthetic valve endocarditis: 300 mg IV/PO Q8 hr for a minimum of 6 '
              'weeks in combination with anti-staphylococcal penicillin with or without '
              'gentamicin for first 2 weeks'),
        ],
      ),
      DoseSection(
        heading: 'Tuberculosis (TB; see latest edition of the AAP Red Book for duration '
            'of therapy and combination therapy):',
        lines: [
          DoseLine('Three-times-weekly therapy may be used after 1–2 months of daily therapy.'),
          DoseLine(
            'Infant, child, and adolescent (as part of a combination therapy):',
            isHeading: true,
          ),
          DoseLine('Daily therapy: 15–20 mg/kg/24 hr IV/PO ÷ Q12–24 hr; higher dose of 20–30 '
              'mg/kg/24 hr ÷ Q12–24 hr has been recommended for infants and toddlers and '
              'for central nervous system (CNS) and disseminated disease. Max. dose: 600 '
              'mg/24 hr'),
          DoseLine('Three-times-weekly therapy: 15–20 mg/kg/24 hr PO three times weekly; '
              'higher dose of 20–30 mg/kg/24 hr three times weekly has been recommended '
              'for infants and toddlers and for CNS and disseminated disease. Max. daily '
              'dose: 600 mg/24 hr'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Daily therapy: 10 mg/kg/24 hr IV/PO once daily'),
          DoseLine('Three-times-weekly therapy: 10 mg/kg/24 hr IV/PO three times weekly'),
          DoseLine('Max. daily dose (all regimens): 600 mg/24 hr'),
          DoseLine(
            'TB meningitis (all ages; empirical dosing with possible need for higher '
                'doses due to autoinduction of metabolic enzymes):',
            isHeading: true,
          ),
          DoseLine('PO: 20 mg/kg/dose Q24 hr; max. dose: 1200 mg/dose'),
          DoseLine('IV: 15 mg/kg/dose Q24 hr; max. dose: 900 mg/dose'),
        ],
      ),
      DoseSection(
        heading: 'Prophylaxis for Neisseria meningitidis (see latest edition of the AAP '
            'Red Book for additional information):',
        lines: [
          DoseLine('0–<1 mo: 10 mg/kg/24 hr PO ÷ Q12 hr × 2 days'),
          DoseLine('≥1 mo: 20 mg/kg/24 hr PO ÷ Q12 hr × 2 days'),
          DoseLine('Adult: 600 mg PO Q12 hr × 2 days'),
          DoseLine('Max. dose (all ages): 1200 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Never use as monotherapy except when used for prophylaxis. Patients with '
          'latent TB infection should NOT be treated with rifampin and pyrazinamide '
          'because of the risk of severe liver injury. Use is NOT recommended in '
          'porphyria. Use with caution in diabetes.',
      'May cause gastrointestinal irritation, allergy, headache, fatigue, '
          'ataxia, muscle weakness, confusion, fever, hepatitis, transient liver '
          'function test abnormalities, blood dyscrasias, interstitial nephritis, '
          'and elevated blood urea nitrogen and uric acid. Causes red discoloration '
          'of body secretions such as urine, saliva, and tears (which can '
          'permanently stain contact lenses). Pulmonary toxicity, hepatotoxicity, '
          'bleeding, and vitamin K–dependent coagulation disorders have been '
          'reported.',
      'Induces several hepatic enzymes and transporters (cytochrome P-450 [CYP] '
          '2C9, CYP2C19, and CYP3A4; uridine diphosphate–glucuronosyltransferase '
          '[UGT]1A1, P-glycoprotein, and organic ion–transporting polypeptide '
          '[OATP]1B1/1B3), which may decrease plasma concentration of digoxin, '
          'corticosteroids, buspirone, benzodiazepines, fentanyl, calcium channel '
          'blockers, β-blockers, cyclosporine, tacrolimus, itraconazole, '
          'ketoconazole, caspofungin, oral anticoagulants, barbiturates, and '
          'theophylline. May reduce the effectiveness of oral contraceptives, '
          'hepatitis C antiviral agents (e.g., daclatasvir, sofosbuvir) and '
          'antiretroviral agents (protease inhibitors and nonnucleoside reverse '
          'transcriptase inhibitors). Use is contraindicated with praziquantel due '
          'to decreased praziquantel levels; rifampin should be discontinued 4 weeks '
          'prior to initiating praziquantel, and rifampin can be restarted 1 day '
          'after completion of praziquantel. Hepatotoxicity is a greater concern '
          'when used in combination with pyrazinamide and ritonavir-boosted '
          'saquinavir (use is contraindicated).',
      'Adjust dose in renal failure (see Chapter 32). Reduce dose in hepatic '
          'impairment. Give oral doses 1 hr before or 2 hr after meals. Patients '
          'should abstain from alcohol, hepatotoxic medications, or herbal products '
          'while taking rifampin.',
      'For Haemophilus influenzae type b prophylaxis, see latest edition of the '
          'Red Book.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1203–1204',
  ),
  // RIFAXIMIN — PDF p. 395–396 (printed 1204–1205)
  DrugEntryV3(
    name: 'RIFAXIMIN',
    brandNames: 'Xifaxan',
    drugClass: 'Antibiotic, rifamycin derivative',
    iconRow: '',
    formulations: [
      'Tabs: 200, 550 mg; may contain edetate disodium',
      'Oral suspension: 20 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Small intestinal bacterial overgrowth (SIBO; limited data):',
        lines: [
          DoseLine('Child 3–<8 yr: 200 mg PO TID × 7–14 days'),
          DoseLine('Child ≥8 yr and adolescent: 200–550 mg PO TID × 7–14 days'),
          DoseLine('Adult: 550 mg PO TID × 14 days'),
        ],
      ),
      DoseSection(
        heading: 'Irritable bowel syndrome with diarrhea:',
        lines: [
          DoseLine('Child ≥8 yr and adolescent (limited data): 10–30 mg/kg/24 hr PO ÷ TID; '
              'max. dose: 1200 mg/24 hr'),
          DoseLine('Adult: 550 mg PO TID × 14 days; may repeat up to twotimes with the same '
              'dosage regimen'),
        ],
      ),
      DoseSection(
        heading: 'Travelers’ diarrhea (caused by noninvasive strains of Escherichia '
            'coli):',
        lines: [
          DoseLine('Child ≥3–11 yr (limited data): 100 mg PO QID for up to 5 days'),
          DoseLine('Child ≥12 yr and adult: 200 mg PO TID × 3 days'),
        ],
      ),
      DoseSection(
        heading: 'Recurrent or subsequent Clostridium difficile diarrhea (initiated '
            'after a 10-day course of oral vancomycin):',
        lines: [
          DoseLine('Child <12 yr (limited data): 15–30 mg/kg/24 hr PO ÷ TID × 20 days; max. '
              'dose: 1200 mg/24 hr'),
          DoseLine('Child ≥12 yr and adult: 400 mg PO TID × 20 days'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated with rifamycin hypersensitivity. Avoid use in diarrhea '
          'complicated by fever or blood in the stool. Use with caution in severe '
          'hepatic impairment (Child-Pugh class C). Severe cutaneous reactions '
          '(e.g., Stevens-Johnson syndrome, toxic epidermal necrolysis) have been '
          'reported with use in patients with cirrhosis.',
      'Common side effects include peripheral edema, abdominal pain, nausea, '
          'constipation, ascites, dizziness, headache, and fatigue. Anaphylaxis, '
          'angioedema, rhabdomyolysis, and exfoliative dermatitis have been reported.',
      'Substrate and inhibitor of organic ion–transporting polypeptide '
          '(OATP)1A2/SLCOA2 transporter and substrate of P-glycoprotein ABCB1 and '
          'OATP1B1/1B3. May decrease the effects of warfarin and immunological '
          'effects of cholera and bacille Calmette-Guérin vaccines. P-glycoprotein '
          'inhibitors (e.g., cyclosporine) may increase the effects/toxicity of '
          'rifaximin.',
      'Doses may be administered with or without food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1204–1205',
  ),
  // RIMANTADINE — PDF p. 396 (printed 1205)
  DrugEntryV3(
    name: 'RIMANTADINE',
    brandNames: 'Generics; previously available as Flumadine',
    drugClass: 'Antiviral agent',
    iconRow: '',
    formulations: [
      'Tabs: 100 mg',
      'Oral suspension: 10 mg/1 mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Influenza A prophylaxis (for at least 10 days after known exposure; '
            'usually for 6–8 weeks during influenza A season or local outbreak):',
        lines: [
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('1–9 yr: 5 mg/kg/24 hr PO ÷ once daily–BID; max. dose: 150 mg/24 hr'),
          DoseLine(
            '≥10 yr:',
            isHeading: true,
          ),
          DoseLine('<40 kg: 5 mg/kg/24 hr PO ÷ BID; max. dose: 150 mg/24 hr'),
          DoseLine('≥40 kg: 100 mg per dose PO BID'),
          DoseLine('Adult: 100 mg PO BID'),
        ],
      ),
      DoseSection(
        heading: 'Influenza A treatment (within 48 hr of illness onset; NOT to be used '
            'in areas with high resistance rates):',
        lines: [
          DoseLine('Use the aforementioned prophylaxis dosages × 7 days.'),
        ],
      ),
    ],
    remarks: [
      'Resistance to influenza A and recommendations against the use for '
          'treatment and prophylaxis have been reported by the Centers for Disease '
          'Control and Prevention (CDC). Check with local microbiology laboratories '
          'and the CDC for seasonal susceptibility/resistance.',
      'Preferred over amantadine for influenza due to lower incidence of adverse '
          'events. Individuals immunized with live attenuated influenza vaccine '
          '(e.g., FluMist) should not receive rimantadine prophylaxis for 14 days '
          'after the vaccine. Chemoprophylaxis does not interfere with immune '
          'response to inactivated influenza vaccine.',
      'May cause gastrointestinal disturbance, xerostomia, dizziness, headache, '
          'and urinary retention. Central nervous system disturbances are less than '
          'with amantadine. Contraindicated in amantadine hypersensitivity. Use with '
          'caution in renal or hepatic insufficiency; dosage reduction may be '
          'necessary. A dosage reduction of 50% has been recommended in severe '
          'hepatic or renal impairment. Subjects with severe renal impairment have '
          'been reported to have an 81% increase in systemic exposure.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1205',
  ),
  // RISPERIDONE — PDF p. 397–399 (printed 1206–1208)
  DrugEntryV3(
    name: 'RISPERIDONE',
    brandNames: 'Risperdal, Risperdal Consta, Rykindo, Uzedy, Perseris, and generics',
    drugClass: 'Atypical antipsychotic, serotonin (5-HT₂) and dopamine (D₂) '
        'antagonist',
    iconRow: '',
    formulations: [
      'Tabs: 0.25, 0.5, 1, 2, 3, 4 mg',
      'Oral (PO) solution: 1 mg/mL (30 mL); may contain benzoic acid',
      'Orally disintegrating tabs: 0.25, 0.5, 1, 2, 3, 4 mg; contain '
          'phenylalanine',
      'Intramuscular (IM) injection:',
      'Risperdal Consta and generics: 12.5, 25, 37.5, 50 mg extended-release '
          'microspheres for IM administration only (vial, vial adapter, with '
          'prefilled syringe with 2 mL diluent; includes one 21-gauge 1-in needle '
          'for deltoid administration and one 20-gauge 2-in needle for gluteal '
          'administration)',
      'Rykindo: 12.5, 25, 37.5, 50 mg extended-release injectable suspension for '
          'IM administration only (vial, vial adapter, prefilled syringe with 2 mL '
          'diluent; includes one 20-gauge 2-in safety needle for gluteal '
          'administration only); contains polysorbate 80',
      'Subcutaneous (SC) injection:',
      'Perseris: 90, 120 mg extended-release injectable suspension for SQ '
          'administration (prefilled syringe that includes an 18-gauge, 5/8-inch '
          'needle)',
      'Uzedy: 50 mg/0.14 mL (0.14 mL), 75 mg/0.21 mL (0.21 mL), 100 mg/0.28 mL '
          '(0.28 mL), 125 mg/0.35 mL (0.35 mL), 150 mg/0.42 mL (0.42 mL), 200 '
          'mg/0.56 mL (0.56 mL), 250 mg/0.7 mL (0.7 mL) extended-release injectable '
          'suspension for SQ administration (prefilled syringe that includes a '
          '21-gauge, 5/8-inch needle)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Irritability associated with autistic disorder:',
        lines: [
          DoseLine(
            '5–17 yr (PO daily doses may be administered once daily–BID; patients '
                'experiencing somnolence may benefit from at bedtime [QHS] or BID dosing '
                'or dose reduction):',
            isHeading: true,
          ),
          DoseLine(
            'Initial dose:',
            isHeading: true,
          ),
          DoseLine('<20 kg: 0.25 mg/24 hr PO for a minimum of 4 days; use with caution if <15 '
              'kg as dosing recommendation is not established'),
          DoseLine('≥20 kg: 0.5 mg/24 hr PO for a minimum of 4 days'),
          DoseLine(
            'Dose increment (if needed) after 4 days of initial dose:',
            isHeading: true,
          ),
          DoseLine('<20 kg: 0.5 mg/24 hr PO for a minimum of 14 days; if additional '
              'increments needed, increase dose by 0.25 mg/24 hr at intervals of at '
              'least 14 days'),
          DoseLine('≥20 kg: 1 mg/24 hr PO for a minimum of 14 days; if additional increments '
              'needed, increase dose by 0.5 mg/24 hr at intervals of at least 14 days'),
          DoseLine(
            'Max. daily dose for plateau of therapeutic effect (from one pivotal '
                'clinical trial):',
            isHeading: true,
          ),
          DoseLine('<20 kg: 1 mg/24 hr'),
          DoseLine('≥20–45 kg: 2.5 mg/24 hr'),
          DoseLine('>45 kg: 3 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Bipolar mania:',
        lines: [
          DoseLine('Oral doses may be administered once or twice daily; patients experiencing '
              'somnolence may benefit from QHS or BID dosing or dose reduction. '
              'Long-term use beyond 3 weeks and doses (all ages) >6 mg/24 hr have not '
              'been evaluated.'),
          DoseLine('Child (10–17 yr): Start with 0.5 mg/24 hr PO once daily (every morning '
              '[QAM] or QHS). If needed, increase dose at intervals ≥24 hr in increments '
              'of 0.5 or 1 mg/24 hr, as tolerated, up to a recommended dose of 2.5 mg/24 '
              'hr. Although efficacy has been demonstrated between 0.5 and 6 mg/24 hr, '
              'no additional benefit was seen above 2.5 mg/24 hr. Higher doses were '
              'associated with more adverse effects.'),
          DoseLine('Adult: Start with 2–3 mg PO once. Dosage increases or decreases of 1 '
              'mg/24 hr can be made at 24-hr intervals. Dosage range: 4–6 mg/24 hr. '
              'Usual max. dose: 8 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Schizophrenia:',
        lines: [
          DoseLine('Oral doses may be administered once daily–BID, and patients experiencing '
              'somnolence may benefit from BID dosing (see remarks).'),
          DoseLine('Adolescent (13–17 yr): No data are available to support long-term use of '
              '>8 wk.'),
          DoseLine('PO: Start with 0.5 mg once daily (QAM or QHS). If needed, increase dose '
              'at intervals ≥24 hr in increments of 0.5 or 1 mg/24 hr, as tolerated, to '
              'a recommended dose of 3 mg/24 hr. Although efficacy has been demonstrated '
              'between 1 and 6 mg/24 hr, no additional benefit and greater side effects '
              'were seen above 3 mg/24 hr. Doses >6 mg/24 hr have not been studied.'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('PO: Start with 1 mg BID on day 1; if tolerated, increase to 2 mg BID on '
              'day 2 and to 3 mg BID thereafter. Dosage increases or decreases of 1–2 mg '
              'can be made on a weekly basis if needed. Usual effective dose: 2–8 mg/24 '
              'hr. Doses above 16 mg/24 hr have not been evaluated.'),
          DoseLine('IM (establish PO dosage regimen prior to converting to the IM dosage '
              'form): Start with 25 mg Q2 wk; if no response, dose may be increased to '
              '37.5 mg or 50 mg at 4-week intervals. Max. IM dose: 50 mg Q2 wk. PO '
              'risperidone should also be administered with the initial IM dose and '
              'continued × 3 weeks and discontinued to provide adequate plasma '
              'concentrations during the initial IM dosing period.'),
          DoseLine(
            'Established oral dose–to–IM dose recommendation:',
            isHeading: true,
          ),
          DoseLine('≤3 mg/24 hr PO: 25 mg IM Q2 wk'),
          DoseLine('>3–≤5 mg/24 hr PO: 37.5 mg IM Q2 wk'),
          DoseLine('>5 mg/24 hr PO: 50 mg IM Q2 wk'),
          DoseLine(
            'SC extended-release injection:',
            isHeading: true,
          ),
          DoseLine(
            'Perseris (establish tolerability with oral therapy first before '
                'transitioning to this dosage form; no oral overlap is needed, discontinue '
                'oral dosing the day before initiating SC route):',
            isHeading: true,
          ),
          DoseLine(
            'Established oral dose and SC dose recommendation:',
            isHeading: true,
          ),
          DoseLine('3 mg/24 hr PO: 90 mg SC once monthly'),
          DoseLine('4 mg/24 hr PO: 120 mg SC once monthly'),
          DoseLine(
            'Uzedy (establish tolerability with oral therapy first before '
                'transitioning to this dosage form; no oral overlap is needed, discontinue '
                'oral dosing the day before initiating SC route):',
            isHeading: true,
          ),
          DoseLine(
            'Established oral dose and SC dose recommendation:',
            isHeading: true,
          ),
          DoseLine('2 mg/24 hr PO: 50 mg SC once monthly or 100 mg SC every 2 months'),
          DoseLine('3 mg/24 hr PO: 75 mg SC once monthly or 150 mg SC every 2 months'),
          DoseLine('4 mg/24 hr PO: 100 mg SC once monthly or 200 mg SC every 2 months'),
          DoseLine('5 mg/24 hr PO: 125 mg SC once monthly or 250 mg SC every 2 months'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in cardiovascular disorders, diabetes, renal or hepatic '
          'impairment (dose reduction necessary), hypothermia or hyperthermia, '
          'seizures, breast cancer or other prolactin-dependent tumors, and '
          'dysphagia. Common side effects include abdominal pain and other '
          'gastrointestinal disturbances, arthralgia, anxiety, dizziness, headache, '
          'insomnia, somnolence (use QHS dosing), extrapyramidal symptoms, cough, '
          'fever, pharyngitis, rash, rhinitis, sexual dysfunction, tachycardia, and '
          'weight gain. Weight gain, somnolence, and fatigue were common side '
          'effects reported in the autism studies. Priapism, Q–Tc prolongation, '
          'neuroleptic malignant syndrome, hypothermia, sleep apnea syndrome, '
          'sleepwalking, ileus, urinary retention, dyslipidemia, diabetes mellitus, '
          'and hypoglycemia have been reported. Very rare cases of anaphylaxis have '
          'been reported with use of the IM dosage form in patients who have '
          'previously tolerated the oral dosage form.',
      'In the presence of severe renal or hepatic impairment or risk for '
          'hypotension, the following adult dosing has been recommended: Start with '
          '0.5 mg PO BID. Increase dose, if needed and tolerated, in increments no '
          'more than 0.5 mg BID. Increases to doses >1.5 mg BID should occur at '
          'intervals of at least 1 week; slower titration may be required in some '
          'patients.',
      'Limited studies in pediatric-related Tourette syndrome, schizophrenia, '
          'and aggressive behavior in psychiatric disorders are reported. Autistic '
          'disorder safety and efficacy in children <5 yr of age have not been '
          'established. If therapy has been discontinued for a period of time, '
          'therapy should be reinitiated with the same initial titration regimen.',
      'Drug is a cytochrome P-450 (CYP) 2D6 and CYP3A4 isoenzyme substrate. '
          'Concurrent use of isoenzyme inhibitors (e.g., fluoxetine, paroxetine, '
          'sertraline, cimetidine) and inducers (e.g., carbamazepine, rifampin, '
          'phenobarbital, phenytoin) may increase and decrease the effects of '
          'risperidone, respectively. Alcohol, central nervous system depressants, '
          'and St. John’s wort may potentiate the drug’s side effects. Risperidone '
          'may enhance the hypotensive effects of levodopa and dopamine agonists. '
          'When used with methylphenidate, an increased risk for extrapyramidal '
          'symptoms may occur whenever a dosage change is made to either medication.',
      'Oral dosage forms may be administered with or without food. Oral solution '
          'can be mixed in water, coffee, orange juice, or low-fat milk but is '
          'incompatible with cola or tea. Do not split or chew the orally '
          'disintegrating tablet. Use IM suspension preparation within 6 hr after '
          'reconstitution.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1206–1208',
  ),
  // RIVAROXABAN — PDF p. 399–400 (printed 1208–1209)
  DrugEntryV3(
    name: 'RIVAROXABAN',
    brandNames: 'Xarelto, Xarelto Starter Pack, and generics',
    drugClass: 'Anticoagulant, direct thrombin inhibitor',
    iconRow: '',
    formulations: [
      'Tabs:',
      'Xarelto: 2.5, 10, 15, 20 mg',
      'Xarelto Starter Pack: 15 mg (42 tabs) and 20 mg (9 tabs); provides 30 '
          'days of therapy',
      'Generic: 2.5 mg',
      'Oral suspension:',
      'Xarelto: 1 mg/mL (155 mL); contains sodium benzoate',
    ],
    doseSections: [
      DoseSection(
        heading: 'Prevention and treatment of venous thromboembolic event (VTE):',
        lines: [
          DoseLine('Child from birth (≥37 weeks’ gestation and ≥2.6 kg) to <18 yr: Prevention '
              'and treatment dosages are similar. Initiate therapy after a minimum of 5 '
              'days of initial intravenous anticoagulation therapy. Neonates and infants '
              '<6 months old should have had at least 10 days of oral feedings. Use only '
              'the oral suspension dosage form for patients <30 kg and either oral '
              'suspension or tablets for patients >30 kg (2.5-mg tablet not recommended '
              'in children due to incomplete pharmacokinetic/pharmacodynamic and '
              'clinical data). Monitor patient weight regularly (especially those <12 '
              'kg) and review dosage level regularly to maintain a therapeutic dose. '
              'Administer all doses with feeds or food for VTE treatment but optional '
              'for VTE prevention.'),
          DoseLine('2.6–2.9 kg: 0.8 mg PO Q8 hr'),
          DoseLine('3–3.9 kg: 0.9 mg PO Q8 hr'),
          DoseLine('4–4.9 kg: 1.4 mg PO Q8 hr'),
          DoseLine('5–6.9 kg: 1.6 mg PO Q8 hr'),
          DoseLine('7–7.9 kg: 1.8 mg PO Q8 hr'),
          DoseLine('8–8.9 kg: 2.4 mg PO Q8 hr'),
          DoseLine('9–9.9 kg: 2.8 mg PO Q8 hr'),
          DoseLine('10–11.9 kg: 3 mg PO Q8 hr'),
          DoseLine('12–29.9 kg: 5 mg PO Q12 hr'),
          DoseLine('30–49.9 kg: 15 mg PO Q24 hr'),
          DoseLine('≥50 kg: 20 mg PO Q24 hr'),
          DoseLine(
            'Duration of therapy:',
            isHeading: true,
          ),
          DoseLine('All patients (except for <2 yr old with catheter-related thrombosis): '
              '3–12 months'),
          DoseLine('<2 yr old with catheter-related thrombosis: 1–3 months'),
          DoseLine('Adult: Administer all doses with food for VTE treatment but optional for '
              'VTE prevention.'),
          DoseLine('VTE treatment: 15 mg PO BID × 21 days followed by 20 mg PO once daily'),
          DoseLine('VTE prevention: 10 mg PO once daily'),
        ],
      ),
      DoseSection(
        heading: 'Thromboprophylaxis following Fontan procedure:',
        lines: [
          DoseLine('Child ≥2–<18 yr: Use only the oral suspension dosage form for patients '
              '<50 kg and either oral suspension or tablets for patients ≥50 kg (2.5-mg '
              'tablet not recommended in children due to incomplete '
              'pharmacokinetic/pharmacodynamic and clinical data). Doses may be '
              'administered with or without food.'),
          DoseLine('7–7.9 kg: 1.1 mg PO Q12 hr'),
          DoseLine('8–9.9 kg: 1.6 mg PO Q12 hr'),
          DoseLine('10–11.9 kg: 1.7 mg PO Q12 hr'),
          DoseLine('12–19.9 kg: 2 mg PO Q12 hr'),
          DoseLine('20–29.9 kg: 2.5 mg PO Q12 hr'),
          DoseLine('30–49.9 kg: 7.5 mg PO Q24 hr'),
          DoseLine('≥50 kg: 10 mg PO Q24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in active pathological bleeding and severe '
          'hypersensitivity to rivaroxaban and its excipients. AVOID use in '
          'moderate/severe hepatic impairment (Child-Pugh classes B and C); in those '
          'who develop acute renal failure with use; children with moderate/severe '
          'renal impairment (estimated glomerular filtration rate [eGFR] <50 '
          'mL/min); adults with severe renal impairment (eGFR <15 m/min); use with '
          'medications that are P-glycoprotein (P-gp) and strong cytochrome P-450 '
          '(CYP) 3A4 inducers (e.g., carbamazepine, phenytoin, rifampin, and St. '
          'John’s wort), or use with medications that are P-gp and strong CYP3A4 '
          'inhibitors (e.g., ketoconazole, itraconazole, clarithromycin, '
          'lopinavir/ritonavir, ritonavir, indinavir/ritonavir). Use is not '
          'recommended in triple-positive antiphospholipid syndrome; in patients '
          'with prosthetic heart valves or transcatheter aortic valve replacement; '
          'and with human immunodeficiency virus protease inhibitors.',
      'Common side effects include gastroenteritis (13% in children), vomiting '
          '(11%–14% in children), cough (16% in children), heavy menstrual bleeding '
          '(27% in adolescents), and hemorrhage (5%–36% in children and adults). '
          'Spinal hematoma or epidural hemorrhage may occur in patients receiving '
          'neuraxial anesthesia or undergoing spinal puncture; if needed, '
          'discontinue use of rivaroxaban 72 hr prior to neuraxial intervention and '
          'consider checking anti–factor Xa level. Eosinophilic pneumonia and '
          'anticoagulant-related nephropathy have been reported in postmarketing '
          'reports.',
      'Rivaroxaban is a major CYP3A4 and minor P-gp/ABC1 and BCRP/ABCG2 '
          'substrate. See above for medications to avoid and always assess for other '
          'drug interactions.',
      'Administer all dosages with food or feeds as indicated. If '
          'anticoagulation needs to be discontinued prior to surgery or other '
          'procedures with bleeding risk, discontinue rivaroxaban at least 24 hr '
          'before the procedure. If converting from or to another anticoagulant '
          'medication, see product information for recommendations. Adjust dosage in '
          'renal impairment (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1208–1209',
  ),
  // RIZATRIPTAN BENZOATE — PDF p. 401 (printed 1210)
  DrugEntryV3(
    name: 'RIZATRIPTAN BENZOATE',
    brandNames: 'Maxalt, Maxalt-MLT, and generics',
    drugClass: 'Antimigraine agent, selective serotonin agonist',
    iconRow: '',
    formulations: [
      'Tabs:',
      'Generics: 5, 10 mg (9s, 12s, 18s)',
      'Maxalt: 5 (18s), 10 mg (3s, 6s, 9s, 12s, 18s)',
      'Orally disintegrating tabs (ODT):',
      'Generics: 5, 10 mg (3s, 9s, 12s, 18s); contain aspartame',
      'Maxalt-MLT: 5 (18s), 10 mg (3s, 6s, 12s, 18s); contains aspartame',
    ],
    doseSections: [
      DoseSection(
        heading: 'Treatment of acute migraines with or without aura (tabs and ODT):',
        lines: [
          DoseLine(
            'Child 6–17 yr (efficacy and safety with >1 dose within 24 hr has not been '
                'established):',
            isHeading: true,
          ),
          DoseLine('<40 kg: 5 mg PO × 1'),
          DoseLine('≥40 kg: 10 mg PO × 1'),
          DoseLine('≥18 yr and adult (safety in an average of >4 headaches in a 30-day period '
              'has not been established; see remarks): 5–10 mg PO × 1. If needed in 2 '
              'hr, a second dose may be administered. Max. daily dose: 30 mg/24 hr'),
          DoseLine(
            'Dosage adjustment if receiving propranolol:',
            isHeading: true,
          ),
          DoseLine(
            'Child 6–17 yr:',
            isHeading: true,
          ),
          DoseLine(
            '<40 kg: DO NOT USE',
            isHeading: true,
          ),
          DoseLine('≥40 kg: 5 mg PO × 1; max. dose: 5 mg/24-hr period'),
          DoseLine('≥18 yr and adult: 5 mg PO up to a maximum of three doses at 2-hr '
              'intervals; max. dose: 15 mg/24-hr period'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in hemiplegic or basilar migraine, coronary artery '
          'vasospasm, uncontrolled hypertension, ischemic bowel or coronary artery '
          'disease, peripheral vascular disease, history of stroke or transient '
          'ischemic attack, and current or recent use (within 2 weeks) of a '
          'monoamine oxidase inhibitor.',
      'Do not administer within 24 hr with any ergotamine-containing or '
          'ergot-type agent, any other 5-hydroxytryptamine₁ agonist (e.g., '
          'triptans), methylene blue, or linezolid.',
      'Use with caution in renal and hepatic impairment, as a 44% increase in '
          'area under the curve (AUC) for patients receiving hemodialysis and a 30% '
          'increase in plasma concentration for patients with moderate hepatic '
          'dysfunction were reported.',
      'Common adverse effects include nausea, asthenia, dizziness, somnolence, '
          'and fatigue. Serious adverse effects include chest pain, coronary artery '
          'spasm, hypertension, myocardial infarction, peripheral ischemia, '
          'ventricular arrhythmia, ischemic colitis, anaphylaxis, angioedema, '
          'cerebrovascular accident, and serotonin syndrome. Transient and permanent '
          'vision loss have been reported.',
      'When the ODT is being used, place the whole tablet on the tongue, allow '
          'the tablet to dissolve, and swallow with saliva. Administration with '
          'liquids is optional. Do not break the ODT tablet.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1210',
  ),
  // ROCURONIUM — PDF p. 401–402 (printed 1210–1211)
  DrugEntryV3(
    name: 'ROCURONIUM',
    brandNames: 'Generics; previously available as Zemuron',
    drugClass: 'Nondepolarizing neuromuscular blocking agent',
    iconRow: '',
    formulations: [
      'Injection: 10 mg/mL (5, 10 mL); may be preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Surgical tracheal intubation; use of a peripheral nerve stimulator to '
            'monitor drug effect is recommended.',
        lines: [
          DoseLine(
            'Infant:',
            isHeading: true,
          ),
          DoseLine('Intravenous (IV): 0.5 mg/kg/dose; may repeat Q20–30 min as needed (PRN)'),
          DoseLine(
            'Child (3 mo–14 yr):',
            isHeading: true,
          ),
          DoseLine('IV: Start with 0.6 mg/kg/dose × 1; if needed, give maintenance doses at '
              '0.075–0.125 mg/kg/dose Q20–30 min PRN when neuromuscular blockade returns '
              'to 25% of control. Alternatively, a maintenance continuous IV infusion '
              'may be used starting at 7–12 mCg/kg/min when neuromuscular blockade '
              'returns to 10% of control.'),
          DoseLine(
            'Adolescent and adult:',
            isHeading: true,
          ),
          DoseLine('IV: Start with 0.6–1.2 mg/kg/dose × 1; if needed, give maintenance doses '
              'at 0.1–0.2 mg/kg/dose Q20–30 min PRN. Alternatively, a maintenance '
              'continuous IV infusion may be used starting at 10–12 mCg/kg/min (range: '
              '4–16 mCg/kg/min).'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in hepatic impairment and history of anaphylaxis with '
          'other neuromuscular blocking agents. Hypertension, hypotension, '
          'arrhythmia, tachycardia, nausea, vomiting, bronchospasm, wheezing, '
          'hiccups, rash, and edema at the injection site may occur. Myopathy after '
          'long-term use in an intensive care unit and Q–T interval prolongation in '
          'pediatric patients receiving general anesthetic agents have been '
          'reported. Severe anaphylactic reactions and malignant hypothermia have '
          'been reported. Increased neuromuscular blockade may occur with '
          'concomitant use of aminoglycosides, clindamycin, tetracycline, magnesium '
          'sulfate, quinine, quinidine, succinylcholine, and inhalation anesthetics '
          '(for continuous infusion, reduce infusion by 30%–50% at 45–60 min after '
          'intubating dose).',
      'Caffeine, calcium, carbamazepine, phenytoin, phenylephrine, azathioprine, '
          'and theophylline may reduce neuromuscular blocking effects.',
      'Use must be accompanied by adequate anesthesia or sedation. Peak effects '
          'occur in 0.5–1 min for children and in 1–3.7 min for adults. Duration of '
          'action: 30–40 min in children and 20–94 min in adults (longer in '
          'geriatrics). Recovery time in children 3 months to 1 year of age is '
          'similar to that in adults. To prevent residual paralysis, extubate '
          'patient only after the patient has sufficiently recovered from '
          'neuromuscular blockade. In obese patients, use actual body weight for '
          'dosage calculation. Sugammadex is the reversal agent.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1210–1211',
  ),
  // RUFINAMIDE — PDF p. 402–403 (printed 1211–1212)
  DrugEntryV3(
    name: 'RUFINAMIDE',
    brandNames: 'Banzel and generics',
    drugClass: 'Anticonvulsant, triazole derivative',
    iconRow: '',
    formulations: [
      'Tabs: 200, 400 mg',
      'Oral suspension: 40 mg/mL (460 mL); contains parabens and propylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Lennox-Gastaut syndrome (adjunctive therapy; it is not known if doses '
            'lower than the targeted dosages are effective; see remarks):',
        lines: [
          DoseLine('Child 1–<17 yr (see remarks): Start at 10 mg/kg/24 hr PO ÷ BID, then '
              'increase dose by ~10 mg/kg/24 hr every other day up to the maximum '
              'targeted dose of 45 mg/kg/24 hr ÷ BID not to exceed 3200 mg/24 hr.'),
          DoseLine('Child ≥17 yr and adult: Start at 400–800 mg/24 hr PO ÷ BID, then increase '
              'dose by 400–800 mg/24 hr every other day up to the maximum targeted dose '
              'of 3200 mg/24 hr ÷ BID.'),
          DoseLine('Use with concurrent valproate therapy: Use lower initial dosages; <10 '
              'mg/kg/24 hr for child 1–<17 yr and <400 mg/24 hr for ≥17 yr and adult.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in familial short QT syndrome. Use is not recommended in '
          'severe hepatic impairment (Child-Pugh score 10–15). Use with caution when '
          'taking other medications that can shorten the Q–T interval, when '
          'performing tasks requiring mental alertness, and in mild/moderate hepatic '
          'impairment (Child-Pugh score 5–9).',
      'Common side effects include fatigue, blurred vision, diplopia, ataxia, '
          'dizziness, headache, somnolence, nausea, vomiting, and shortening of '
          'cardiac Q–T interval. Serious side effects of leukopenia, severe '
          'dermatologic reactions (e.g., Stevens-Johnson syndrome), multiorgan '
          'hypersensitivity reactions (e.g., drug rash with eosinophilia and '
          'systemic symptoms [DRESS]), and suicidal ideation have been reported.',
      'Rufinamide is a weak inhibitor of cytochrome P-450 (CYP) 2E1 and weak '
          'inducer of CYP3A4. May decrease levels/effects of nifedipine, nimodipine, '
          'piperaquine, calcifediol, clozapine, carbamazepine, lamotrigine, '
          'triazolam, orlistat, and hormonal contraceptives. May increase the '
          'levels/effects of phenytoin and phenobarbital. Primidone, phenobarbital, '
          'phenytoin, and carbamazepine may decrease the levels/effects of '
          'rufinamide, whereas valproic acid may increase the levels/effects of '
          'rufinamide.',
      'The effectiveness data for 1- to 4-year-old children are based on '
          'bridging pharmacokinetic (PK) and safety data as their PK and safety data '
          'are similar to children ≥4 years old and adults.',
      'Consider dose adjustment for drug loss in patients receiving hemodialysis '
          '(rufinamide is dialyzable). For therapy discontinuation, reduce dose by '
          '~25% every 2 days. Tablets may be crushed and all doses may be '
          'administered with or without food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1211–1212',
  ),
];
