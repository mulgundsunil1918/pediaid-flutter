// =============================================================================
// output/s.dart — Drug Formulary 3.0, letter S
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyS` per file; entries in book order.
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

const List<DrugEntryV3> formularyS = [
  // SALMETEROL — PDF p. 403–404 (printed 1212–1213)
  DrugEntryV3(
    name: 'SALMETEROL',
    brandNames: 'Serevent Diskus',
    drugClass: 'β₂-adrenergic agonist (long acting)',
    iconRow: '',
    formulations: [
      'Dry powder inhalation (DPI; Diskus): 50 mCg/inhalation (60 inhalations); '
          'contains lactose and milk protein',
      'In combination with fluticasone: See Fluticasone Propionate and '
          'Salmeterol.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Persistent asthma (see remarks):',
        lines: [
          DoseLine('≥4 yr and adult: 1 inhalation (50 mCg) Q12 hr; max. dose: 1 inhalation '
              'Q12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Prevention of exercise-induced bronchospasm (see remarks):',
        lines: [
          DoseLine('≥4 yr and adult: 1 inhalation 30–60 min before exercise. Additional doses '
              'should not be used for another 12 hr. Patients who are already using '
              '12-hr dosing for persistent asthma should NOT use additional salmeterol '
              'doses for this indication and should use alternative therapy (e.g., '
              'albuterol) prior to exercise.'),
        ],
      ),
    ],
    remarks: [
      'For long-term asthma control, should be used in combination with inhaled '
          'corticosteroids. Should not be used to relieve symptoms of acute asthma. '
          'It is long acting and has its onset of action in 10–20 min with a peak '
          'effect at 3 hr. May be used at QHS (1 inhalation of the dry powder '
          'inhaler [DPI]) for nocturnal symptoms. Salmeterol is a chronic medication '
          'and is not used similarly to short-acting β₂ agonists (e.g., albuterol). '
          'Patients already receiving salmeterol every 12 hr should not use '
          'additional doses for prevention of exercise-induced bronchospasm; '
          'consider alternative therapy. Asthma exacerbations or hospitalizations '
          'were reported to be lower when this medication was used with an inhaled '
          'corticosteroid.',
      'WARNING: Long-acting β₂ agonists as monotherapy increase the risks of '
          'asthma-related death and asthma-related hospitalizations. Monotherapy '
          'without concomitant use of an inhaled corticosteroid is contraindicated '
          'in asthma. Use salmeterol only as additional therapy for patients not '
          'adequately controlled on other asthma-controller medications (e.g., low- '
          'to medium-dose inhaled corticosteroids) or whose disease severity clearly '
          'requires initiation of treatment with two maintenance therapies. '
          'Contraindicated in milk allergies; contains milk proteins.',
      'Should not be used in conjunction with an inhaled, long-acting β₂ agonist '
          'and is not a substitute for an inhaled or systemic corticosteroid. Use '
          'with strong cytochrome P-450 (CYP) 3A4 inhibitors (e.g., ketoconazole, '
          'human immunodeficiency virus protease inhibitors, clarithromycin, '
          'itraconazole, nefazodone, and telithromycin) is not recommended due to '
          'risk for cardiovascular adverse events (e.g., Q–Tc prolongation, '
          'tachycardia). Salmeterol is a CYP3A4 substrate.',
      'Proper patient education is essential. This dosage form’s '
          'breath-activated device requires a minimum inspiratory flow rate of 60 '
          'mL/min for proper dose delivery. Use with caution in hepatic impairment. '
          'Side effects are similar to those of albuterol. Hypertension and '
          'arrhythmias have been reported. See Chapter 25 for recommendations for '
          'asthma controller therapy.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1212–1213',
  ),
  // SCOPOLAMINE HYDROBROMIDE — PDF p. 404–405 (printed 1213–1214)
  DrugEntryV3(
    name: 'SCOPOLAMINE HYDROBROMIDE',
    brandNames: 'Generics; previously available as Transderm Scop',
    drugClass: 'Anticholinergic agent',
    iconRow: '',
    formulations: [
      'Transdermal patch: 1 mg/3 days patch (4s, 10s, and 24s); delivers ~1 mg '
          'over 3 days',
    ],
    doseSections: [
      DoseSection(
        heading: 'Sialorrhea/excessive secretions (apply patch behind the ear; limited '
            'data):',
        lines: [
          DoseLine('Child ≥3 yr and adolescent: Start with ¼ patch Q3 days x 1 week, if '
              'needed and tolerated, increase dose by ¼ patch every 7 days up to a '
              'maximum of 1 patch Q3 days. When administering new patch Q3 days, remove '
              'old patch and place new patch behind the other ear.'),
        ],
      ),
      DoseSection(
        heading: 'Prevention of postoperative nausea and vomiting (apply patch behind '
            'the ear, the evening before surgery and remove patch the morning of '
            'the first postoperative day; limited data):',
        lines: [
          DoseLine('Child <2 yr: ¼ patch'),
          DoseLine('Child 2–6 yr: ½ patch'),
          DoseLine('Child 6–12 yr: ½–1 patch'),
          DoseLine('Child 12 yr and adolescent: 1 patch'),
        ],
      ),
      DoseSection(
        heading: 'Adult indications:',
        lines: [
          DoseLine('Sialorrhea/excessive secretions: Apply 1 patch behind the ear Q3 days. '
              'When administering new patch Q3 days, remove old patch and place new '
              'patch behind the other ear.'),
          DoseLine('Prevention of motion sickness: Apply 1 patch behind the ear at least 4 hr '
              'prior to exposure to motion; remove after 72 hr. If additional therapy is '
              'needed, apply 1 new patch behind the other ear.'),
          DoseLine('Prevention of postoperative nausea and vomiting (excluding cesarean '
              'section): Apply 1 patch behind the ear the evening before surgery. Remove '
              'patch 24 hr after surgery.'),
          DoseLine('Antiemetic prior to cesarean section: Apply 1 patch behind the ear 1 hr '
              'prior to surgery to minimize infant exposure. Remove patch 24 hr after '
              'surgery.'),
        ],
      ),
    ],
    remarks: [
      'Toxicities similar to those of atropine. Contraindicated in closed-angle '
          'glaucoma and hypersensitivity to belladonna alkaloids. Use with caution '
          'in hepatic or renal dysfunction, gastrointestinal and urinary disorders '
          '(discontinue use if there is difficulty in urination), cardiac disease, '
          'seizures, or psychosis. May cause dry mouth, drowsiness, urinary '
          'retention, and blurred vision. Generalized rash and erythema may indicate '
          'hypersensitivity to the medication or other ingredients in the '
          'formulation. Hallucinations, amblyopia, and mydriasis have been reported '
          'in children. Immediately remove patch when psychiatric adverse reactions '
          'occur and seek medical attention if severe symptoms persist.',
      'Drug withdrawal symptoms (nausea, vomiting, headache, and vertigo) have '
          'been reported following removal of transdermal patch in patients using '
          'the patch for more than 3 days. For perioperative use, the patch should '
          'be kept in place for 24 hr following surgery.',
      'Concurrent use with medications with known central nervous system (CNS) '
          'adverse reactions or that have anticholinergic properties may potentiate '
          'scopolamine’s CNS effects. Use of this medication may delay the rate of '
          'orally administered drugs and will interfere with the gastric secretion '
          'test (discontinue use 10 days prior to testing).',
      'REMOVE transdermal patch before undergoing magnetic resonance imaging; '
          'the patch contains aluminum.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1213–1214',
  ),
  // SELENIUM SULFIDE — PDF p. 405 (printed 1214)
  DrugEntryV3(
    name: 'SELENIUM SULFIDE',
    brandNames: 'Selsun Blue and many other brands, including generics',
    drugClass: 'Topical antiseborrheic agent',
    iconRow: '',
    formulations: [
      'Shampoo:',
      '1% (Selsun Blue and others; OTC): 207, 325, 400, 420 mL; some products '
          'are available in combination with a conditioner. Be aware of different '
          'active ingredients in the Selsun Blue product line.',
      '2.25%: 180 mL; may contain parabens and propylene glycol',
      '2.3%: 180 mL; may contain parabens and propylene glycol',
      'Topical lotion: 2.5% (120 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: '≥2 yr and adult:',
        lines: [
          DoseLine(
            'Seborrhea/dandruff:',
            isHeading: true,
          ),
          DoseLine('Lotion: Massage 5–10 mL into wet scalp and leave on scalp for 2–3 min. '
              'Rinse thoroughly and repeat. Use 2 applications twice weekly for 2 wk for '
              'control; may be followed by a less frequent maintenance application of '
              'once every 1–4 wk.'),
          DoseLine('Shampoo: Massage shampoo into wet scalp, then rinse thoroughly. Shampoo '
              'at least twice weekly for 2 wk; may be followed by less frequent '
              'maintenance use such as once weekly.'),
          DoseLine('Pityriasis (tinea) versicolor: Apply 2.5% lotion to affected areas of '
              'skin. Allow to remain on skin for 10 min. Rinse thoroughly. Repeat once '
              'daily for 7 days. Follow with weekly or monthly applications for 3 mo to '
              'prevent recurrences.'),
        ],
      ),
    ],
    remarks: [
      'Rinse hands and body well after treatment. May cause local irritation, '
          'hair loss, and hair discoloration. Avoid eyes, genital areas, and skin '
          'folds. Shampoo may be used for tinea capitis to reduce risk of '
          'transmission to others (does not eradicate tinea infection).',
      'For tinea versicolor, 15%–25% sodium hyposulfite or thiosulfate (Tinver '
          'lotion) applied to affected areas twice daily for 2–4 wk is an '
          'alternative. Topical antifungals (e.g., clotrimazole, miconazole) may be '
          'used for small focal infections. Do not use for tinea versicolor during '
          'pregnancy.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1214',
  ),
  // SENNA/SENNOSIDES — PDF p. 406 (printed 1215)
  DrugEntryV3(
    name: 'SENNA/SENNOSIDES',
    brandNames: 'Senokot, Senna-Lax, Ex-Lax, Genexa Kids Senna Laxative, and many '
        'others',
    drugClass: 'Laxative, stimulant',
    iconRow: '',
    formulations: [
      'Based on mg of senna (all products are OTC):',
      'Oral syrup: 176 mg/5 mL, 218 mg/5 mL (60 mL, 240 mL); may contain '
          'parabens and propylene glycol',
      'Tabs: 187, 217, 374 mg',
      '187 mg senna extract is approximately 8.6 mg sennosides.',
      'Based on mg of sennosides (all products are OTC):',
      'Oral syrup: 8.8 mg/5 mL (237 mL); may contain parabens and propylene '
          'glycol',
      'Tabs: 8.6, 15, 17.2, 25 mg',
      'Chewable tabs: 8.6, 15 mg',
      '8.6 mg sennosides is approximately 187 mg senna extract.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Constipation (a second-line agent for short-term use; other agents '
            'are preferred for maintenance therapy):',
        lines: [
          DoseLine(
            'Dosing based on mg senna:',
            isHeading: true,
          ),
          DoseLine(
            'Child:',
            isHeading: true,
          ),
          DoseLine('Oral: 10–20 mg/kg/dose PO QHS (max. dose: as shown below) or dosage by '
              'age:'),
          DoseLine('1 mo–1 yr: 55–109 mg PO QHS to max. dose: 218 mg/24 hr'),
          DoseLine('2–5 yr: 109–218 mg PO QHS to max. dose: 436 mg/24 hr'),
          DoseLine('5–15 yr: 218–436 mg PO QHS to max. dose: 872 mg/24 hr'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Syrup: 436–654 mg PO QHS to max. dose: 654 mg (15 mL) BID'),
          DoseLine('Tabs: 374 mg PO QHS to max. dose: 748 mg BID'),
          DoseLine(
            'Dosing based on mg sennosides:',
            isHeading: true,
          ),
          DoseLine(
            'Child ≤12 yr:',
            isHeading: true,
          ),
          DoseLine(
            'Syrup:',
            isHeading: true,
          ),
          DoseLine('1 mo–1 yr: 2.2–4.4 mg (1.25–2.5 mL) PO QHS to max. dose: 8.8 mg/24 hr'),
          DoseLine('2–5 yr: 4.4–6.6 mg (2.5–3.75 mL) PO QHS to max. dose: 6.6 mg BID'),
          DoseLine('6–12 yr: 8.8–13.2 mg (5–7.5 mL) PO QHS to max. dose: 13.2 mg BID'),
          DoseLine(
            'Tabs or chewable tabs (8.6 mg):',
            isHeading: true,
          ),
          DoseLine('2–5 yr: 4.3 mg PO QHS to max. dose: 8.6 mg BID'),
          DoseLine('6–12 yr: 8.6 mg PO QHS to max. dose: 17.2 mg BID'),
          DoseLine(
            'Chewable tabs (Genexa Kids Senna Laxative; 3 mg):',
            isHeading: true,
          ),
          DoseLine('2–5 yr: 3 mg PO once daily or BID'),
          DoseLine('6–12 yr: 6 mg PO once daily or BID'),
          DoseLine(
            '>12 yr and adult:',
            isHeading: true,
          ),
          DoseLine('Syrup: 17.6–26.4 mg (10–15 mL) PO QHS to max. dose: 26.4 mg BID'),
          DoseLine('Tabs: 17.2 mg PO QHS to max. dose: 34.4 mg BID'),
        ],
      ),
    ],
    remarks: [
      'Effects occur within 6–24 hr after oral administration. Prolonged use (>1 '
          'wk) should be avoided because it may lead to dependency. May cause '
          'nausea, vomiting, diarrhea, and abdominal cramps. Active metabolite '
          'stimulates the Auerbach plexus. Syrup may be administered with juice or '
          'milk or mixed with ice cream.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1215',
  ),
  // SERTRALINE HCL — PDF p. 407 (printed 1216)
  DrugEntryV3(
    name: 'SERTRALINE HCL',
    brandNames: 'Zoloft and generics',
    drugClass: 'Antidepressant (selective serotonin reuptake inhibitor)',
    iconRow: '',
    formulations: [
      'Tabs: 25, 50, 100 mg; tablets may be scored',
      'Caps: 150, 200 mg',
      'Oral concentrate solution: 20 mg/mL (60 mL); may contain 12% alcohol and '
          'propylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Depression (see remarks):',
        lines: [
          DoseLine('Child 6–12 yr: Start at 12.5–25 mg PO once daily. May increase dosage by '
              '12.5–25 mg at weekly intervals up to a max. dose of 200 mg/24 hr.'),
          DoseLine('Child ≥13 yr and adult: Start at 25–50 mg PO once daily. May increase '
              'dosage by 25–50 mg at weekly intervals up to a max. dose of 200 mg/24 hr.'),
        ],
      ),
      DoseSection(
        heading: 'Obsessive-compulsive disorder (see remarks):',
        lines: [
          DoseLine('Child 6–12 yr: Start at 25 mg PO once daily. May increase dosage by 25–50 '
              'mg at weekly intervals up to a max. dose of 200 mg/24 hr.'),
          DoseLine('Child ≥13 yr and adult: Start at 50 mg PO once daily. May increase dosage '
              'by 50 mg at weekly intervals up to max. dose of 200 mg/24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Drug is contraindicated in combination with (or within 14 days of '
          'discontinuing use of) a monoamine oxidase (MAO) inhibitor (e.g., '
          'linezolid or intravenous methylene blue) or pimozide (increases '
          'adverse/toxic effects of pimozide). Use with caution in patients with '
          'abnormal bleeding, syndrome of inappropriate diuretic hormone (SIADH) '
          'secretion, and hepatic or renal impairment. Adverse effects include '
          'nausea, diarrhea, tremor, sexual dysfunction, and increased sweating. '
          'Hyponatremia, diabetes mellitus, rhabdomyolysis, trismus, and platelet '
          'dysfunction have been reported. A positive correlation with length of '
          'Q–Tc interval and serum sertraline and N-desmethylsertraline levels has '
          'been reported.',
      'Monitor for clinical worsening of depression and suicidal '
          'ideation/behavior following the initiation of therapy or after dose '
          'changes. Use during the late third trimester of pregnancy may increase '
          'risk for withdrawal symptoms and persistent pulmonary hypertension in the '
          'newborn.',
      'Use with drugs that interfere with hemostasis (e.g., nonsteroidal '
          'anti-inflammatory drugs [NSAIDs], aspirin, warfarin) may increase risk '
          'for gastrointestinal bleeds. Use with warfarin may increase prothrombin '
          'time. Inhibits the cytochrome P-450 (CYP) 2D6 drug-metabolizing enzyme. '
          'Serotonin syndrome may occur when taken with selective serotonin reuptake '
          'inhibitors (e.g., amitriptyline, amphetamines, buspirone, '
          'dihydroergotamine, sumatriptan, sympathomimetics) and drugs that impair '
          'metabolism of serotonin.',
      'Sertraline is a substrate for CYP2B6, CYP2C9, CYP2C19, CYP2D6, and '
          'CYP3A4. Poor metabolizers of CYP2C19 should initiate therapy at 50% of '
          'the recommended dosage and titrate to desired effect or consider using an '
          'alternative medication not predominantly metabolized by this enzyme. '
          'Ultrarapid CYP2C19 metabolizers should initiate therapy at the '
          'recommended starting dose and titrate to the recommended maintenance '
          'dosage or consider using a drug not predominantly metabolized by this '
          'enzyme.',
      'Do not abruptly discontinue use; gradually taper dose (4–6 wk has been '
          'recommended) to reduce risk for withdrawal symptoms.',
      'Mix oral concentrate solution with 4 oz of water, ginger ale, lemon/lime '
          'soda, lemonade, or orange juice. After mixing, a slight haze may appear; '
          'this is normal. This dosage form should be used cautiously in patients '
          'with latex allergy because the dropper contains dry natural rubber.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1216',
  ),
  // SILDENAFIL — PDF p. 408–409 (printed 1217–1218)
  DrugEntryV3(
    name: 'SILDENAFIL',
    brandNames: 'Revatio, Viagra, and generics',
    drugClass: 'Phosphodiesterase type 5 (PDE5) inhibitor',
    iconRow: '',
    formulations: [
      'Tabs:',
      'Revatio and generics: 20 mg',
      'Viagra and generics: 25, 50, 100 mg',
      'Oral suspension: 2.5 mg/mL',
      'Commercially available generics: 10 mg/mL (112 mL); may contain sodium '
          'benzoate',
      'Injection:',
      'Revatio and generics: 0.8 mg/mL (12.5 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Pulmonary hypertension:',
        lines: [
          DoseLine(
            'Neonate (limited data from case reports and small clinical trials):',
            isHeading: true,
          ),
          DoseLine('PO: Several dosages have been reported and have ranged from 0.5 to 3 '
              'mg/kg/dose Q6–12 hr. A single dose of ~0.3 mg/kg has been used in select '
              'patients to facilitate weaning from inhaled nitric oxide.'),
          DoseLine('IV (case report from 4 neonates >34 wk gestation and <72 hr old): Start '
              'with 0.4 mg/kg/dose over 3 hr followed by a continuous infusion of 1.6 '
              'mg/kg/24 hr (0.067 mg/kg/hr) for up to 7 days.'),
          DoseLine(
            'Infant and child (limited data):',
            isHeading: true,
          ),
          DoseLine('PO: Start at 0.25 mg/kg/dose Q6 hr or 0.5 mg/kg/dose Q8 hr; if needed, '
              'titrate dose up to 1–2 mg/kg/dose Q6–8 hr. A single dose of ~0.4 mg/kg '
              'has been used in select patients to facilitate weaning from inhaled '
              'nitric oxide.'),
          DoseLine(
            'Child 1–17 yr (higher doses and long-term use are associated with '
                'increased risk for mortality; see remarks):',
            isHeading: true,
          ),
          DoseLine(
            'PO:',
            isHeading: true,
          ),
          DoseLine('≥8–20 kg: 10 mg TID'),
          DoseLine('>20–45 kg: 20 mg TID'),
          DoseLine('>45 kg: Start at 20 mg TID and may titrate up to 40 mg TID'),
        ],
      ),
      DoseSection(
        heading: 'Pulmonary arterial hypertension:',
        lines: [
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('PO: 20 mg TID (take at least 4–6 hr apart). If needed, may slowly '
              'increase dose in 20-mg increments up to a maximum of 80 mg TID.'),
          DoseLine('IV: 10 mg TID'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated with concurrent use of nitrates (e.g., nitroglycerin) and '
          'other nitric oxide donors; potentiates hypotensive effects. Use with '
          'caution in sepsis (high levels of cyclic guanosine monophosphate [cGMP] '
          'may potentiate hypotension), hypotension, and sickle cell anemia (use not '
          'established), and with concurrent cytochrome P-450 (CYP) 3A4 inhibiting '
          'medications (see discussion that follows) and antihypertensive '
          'medications. Hepatic insufficiency or severe renal impairment (glomerular '
          'filtration rate [GFR] <30 mL/min) significantly reduces sildenafil '
          'clearance.',
      'Findings from the dose-ranging study in 1- to 17-yr-olds with pulmonary '
          'arterial hypertension found an association of increased mortality risk '
          'with long-term use (>2 yr). Headache, pyrexia, upper respiratory tract '
          'infections (URTIs), vomiting, and diarrhea were the most frequently '
          'reported side effects in this study. Optimal dosing based on age and body '
          'weight still needs to be determined. Hazard ratios for mortality were '
          '3.95 (95% confidence interval [95% CI]: 1.46–10.65) for high versus low '
          'doses and 1.92 (95% CI: 0.65–5.65) for medium versus low doses in '
          'follow-up study for those receiving therapy for ≥3 yr. A subsequent '
          'extension open-label study on the same population for an additional 16 wk '
          'reported a greater hazard ratio for mortality with high- versus low-dose '
          'therapy (P = 0.007).',
      'In adults, a transient impairment of color discrimination may occur; this '
          'effect could increase risk of severe retinopathy of prematurity in '
          'neonates. Common side effects reported in adults have included flushing, '
          'rash, diarrhea, indigestion, headache, abnormal vision, and nasal '
          'congestion. Hearing loss has been reported.',
      'Sildenafil is substrate for CYP3A4 (major) and CYP2C8/9 (minor). Azole '
          'antifungals, cimetidine, ciprofloxacin, clarithromycin, erythromycin, '
          'nicardipine, propofol, protease inhibitors, quinidine, verapamil, and '
          'grapefruit juice may increase the effects/toxicity of sildenafil. '
          'Bosentan, efavirenz, carbamazepine, phenobarbital, phenytoin, rifampin, '
          'St. John’s wort, and high-fat meals may decrease sildenafil effects.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1217–1218',
  ),
  // SILVER SULFADIAZINE — PDF p. 409 (printed 1218)
  DrugEntryV3(
    name: 'SILVER SULFADIAZINE',
    brandNames: 'Silvadene, SSD Cream, and generics',
    drugClass: 'Topical antibiotic',
    iconRow: '',
    formulations: [
      'Cream: 1% (20, 25, 50, 85, 400, 1000 g); contains methylparabens and '
          'propylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Burns:',
        lines: [
          DoseLine('Child (≥2 mo) and adult: Cover affected areas completely once or twice '
              'daily. Apply cream to a thickness of 1/16 inch using sterile technique. '
              'Use until burn site has healed or is ready for grafting.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in premature infants and infants up to 2 mo of age due to '
          'concerns of kernicterus; also contraindicated in pregnancy (approaching '
          'term). Use with caution in glucose-6-phosphate dehydrogenase (G6PD) and '
          'renal and hepatic impairment. Discard product if cream has darkened. '
          'Significant systemic absorption may occur in severe burns. Adverse '
          'effects include pruritus, rash, bone marrow suppression, hemolytic '
          'anemia, hepatitis, interstitial nephritis, and life-threatening cutaneous '
          'reactions (e.g., Stevens-Johnson syndrome/toxic epidermal necrolysis '
          '[TEN] and exfoliative dermatitis). Avoid contact with the eye. Dressing '
          'may be used but is not necessary. See Chapter 4 for more information.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1218',
  ),
  // SIMETHICONE — PDF p. 409–410 (printed 1218–1219)
  DrugEntryV3(
    name: 'SIMETHICONE',
    brandNames: 'Mylicon, Children’s Mylicon, Phazyme, Mylanta Gas, Gas-X, and many '
        'other brands, including generics',
    drugClass: 'Antiflatulent',
    iconRow: '',
    formulations: [
      'All dosage forms available over the counter (OTC)',
      'Oral drops and suspension: 40 mg/0.6 mL (15, 30 mL); may contain sodium '
          'benzoate and polyethylene glycol',
      'Caps (Phazyme, Gas-X, and generics): 125, 180, 250 mg',
      'Chewable tabs: 80, 125 mg',
      'Children’s Mylicon: 40 mg; contains 400 mg calcium carbonate',
      'Strip, orally disintegrating (Gas-X): 40 mg (16s), 62.5 mg (18s); '
          'contains alcohol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infant and child <2 yr:',
        lines: [
          DoseLine('20 mg PO QPC and QHS PRN; max. dose: 240 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: '2–12 yr:',
        lines: [
          DoseLine('40 mg PO QPC and QHS PRN; max. dose: 480 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: '>12 yr and adult:',
        lines: [
          DoseLine('40–125 mg PO QPC and QHS PRN; max. dose: 500 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Efficacy has not been demonstrated for treating infant colic. Avoid '
          'carbonated beverages and gas-forming foods. Oral liquid may be mixed with '
          'water, infant formula, or other suitable liquids for ease of oral '
          'administration.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1218–1219',
  ),
  // SIROLIMUS — PDF p. 410–411 (printed 1219–1220)
  DrugEntryV3(
    name: 'SIROLIMUS',
    brandNames: 'Generics (previously available as Rapamune) and Hyftor',
    drugClass: 'Immunosuppressant agent',
    iconRow: '',
    formulations: [
      'Tabs: 0.5, 1, 2 mg',
      'Oral solution: 1 mg/mL (60 mL); contains 1.5%–2.5% ethanol, polysorbate '
          '80, and propylene glycol',
      'Topical gel:',
      'Hyftor: 0.2% (10 g); contains alcohol and triethanolamine',
    ],
    doseSections: [
      DoseSection(
        heading: 'Prophylaxis of organ rejection in renal transplantation:',
        lines: [
          DoseLine('Child and adolescent: conversion from tacrolimus with stable graft '
              'function for a minimum of 3 months after transplantation (use of oral '
              'solution is preferred; tablet and oral solution dosage forms are NOT '
              'bioequivalent; see remarks): 5 mg/m²/dose PO x 1, followed by 3 mg/m²/24 '
              'hr PO ÷ Q12 hr on the next day. Adjust dose to achieve desired trough '
              'blood level.'),
          DoseLine(
            'Adult (use of oral solution is preferred; tablet and oral solution dosage '
                'forms are NOT bioequivalent; see remarks):',
            isHeading: true,
          ),
          DoseLine(
            'Patients at low/moderate immunologic risk:',
            isHeading: true,
          ),
          DoseLine(
            'In combination with cyclosporine (adjust dose to achieve desired trough '
                'blood level):',
            isHeading: true,
          ),
          DoseLine('<40 kg: 3 mg/m²/dose PO given once immediately after transplantation '
              'followed by 1 mg/m²/dose PO once daily on the next day'),
          DoseLine('≥40 kg: 6 mg PO once immediately after transplantation, followed by 2 mg '
              'PO once daily on the next day'),
          DoseLine(
            'Patients at high immunologic risk:',
            isHeading: true,
          ),
          DoseLine('In combination with cyclosporine (withdrawal of cyclosporine may not be '
              'recommended and antibody induction therapy may be used): 15 mg PO once '
              'immediately after transplantation, followed by 5 mg PO once daily on the '
              'next day. Adjust dose to achieve desired trough blood level.'),
        ],
      ),
      DoseSection(
        heading: 'Facial angiofibroma associated with tuberous sclerosis:',
        lines: [
          DoseLine('≥6 yr: Reassess therapy if no improvement within 12 wk of use'),
          DoseLine('Hyftor (see remarks): Apply topical gel to affected area of the face BID '
              '(QAM and QHS) with the following maximum daily doses:'),
          DoseLine('6–11 yr: 600 mg (2 cm)/24 hr'),
          DoseLine('≥12 yr: 800 mg (2.5 cm)/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Increased susceptibility to infection and development of lymphoma may '
          'result from immunosuppression. Fatal bronchial anastomotic dehiscence has '
          'been reported in lung transplantation. Excess mortality, graft loss, and '
          'hepatic artery thrombosis have been reported in liver transplantation '
          'when used with tacrolimus. Patients with the greatest amount of urinary '
          'protein excretion prior to sirolimus conversion were those whose protein '
          'excretion increased the most after conversion. Increased risk of BK '
          'virus–associated nephropathies has been reported. The following adverse '
          'effects have been reported when converting from a calcineurin '
          'inhibitor–based regimen to maintenance sirolimus:',
      'Stable liver transplant: increased mortality',
      'Kidney transplant: pneumonia, proteinuria, acute rejection, graft loss, '
          'and death',
      'Monitor whole-blood trough levels (just prior to a dose at steady state); '
          'especially with pediatric patients; hepatic impairment; concurrent use of '
          'cytochrome P-450 (CYP) 3A4 and/or P-glycoprotein (P-gp) inducers and '
          'inhibitors; and/or if cyclosporine dosage is markedly changed or '
          'discontinued. Steady-state is generally achieved after 5–7 days of '
          'continuous dosing. Interpretation will vary based on specific treatment '
          'protocol and assay methodology (high-performance liquid chromatography '
          '[HPLC] vs. immunoassay vs. liquid chromatography–mass spectrometry '
          '[LC/MS]). Younger children may exhibit faster sirolimus clearance '
          'compared with adolescents.',
      'Sirolimus is a substrate for CYP3A4 and P-gp. Bromocriptine, cannabidiol, '
          'cyclosporine, diltiazem, metoclopramide, protease inhibitors, '
          'erythromycin, grapefruit juice, and other inhibitors of CYP3A4 (e.g., '
          'calcium channel blockers) may increase the toxicity of sirolimus. '
          'Phenobarbital, carbamazepine, phenytoin, and St John’s wort may decrease '
          'the effects of sirolimus. Strong inhibitors (e.g., azole antifungals and '
          'clarithromycin) and strong inducers (e.g., rifamycins) are not '
          'recommended.',
      'Hypertension, peripheral edema, increased serum creatinine, dyspnea, '
          'epistaxis, headache, anemia, thrombocytopenia, hyperlipidemia, '
          'hypercholesterolemia, and arthralgia may occur. Progressive multifocal '
          'leukoencephalopathy (PML), diabetes mellitus, posterior reversible '
          'encephalopathy syndrome, ovarian cysts, and menstrual disorders have been '
          'reported. Urinary tract infections have been reported in pediatric renal '
          'transplant patients with high immunologic risk.',
      'Two milligrams of the oral solution have been demonstrated to be '
          'clinically equivalent to the 2-mg tablets. However, it is not known '
          'whether they are still therapeutically equivalent at higher doses. Reduce '
          'maintenance dosage by one-third in the presence of hepatic function '
          'impairment. Administer doses consistently with or without food. When '
          'administered with cyclosporine, give dose 4 hr after cyclosporine. Do not '
          'crush or split tablets. Measure the oral liquid dosage form with an amber '
          'oral syringe and dilute in a cup with 60 mL of water or orange juice '
          'only. Take dose immediately after mixing, add/mix additional 120 mL '
          'diluent into the cup, and drink immediately after mixing.',
      'For use of topical gel dosage form, do not use with occlusive dressings '
          'nor administer via the oral, ophthalmic, or intravaginal routes. Complete '
          'all recommended vaccinations prior to initiating topical therapy as '
          'vaccination during topical therapy may result in reduced vaccine efficacy.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1219–1220',
  ),
  // SODIUM BICARBONATE — PDF p. 411–412 (printed 1220–1221)
  DrugEntryV3(
    name: 'SODIUM BICARBONATE',
    brandNames: 'Generics',
    drugClass: 'Alkalinizing agent, electrolyte',
    iconRow: '',
    formulations: [
      'Injection: 4.2% (0.5 mEq/mL) (5, 10 mL), 7.5% (0.89 mEq/mL) (50 mL), 8.4% '
          '(1 mEq/mL) (10, 50 mL)',
      'Tabs: 325 mg (3.8 mEq), 650 mg (7.6 mEq)',
      'Powder: 120, 500, 1000 g; contains 30 mEq Na⁺ per ½ teaspoon',
      'Each 1 mEq bicarbonate provides 1 mEq Na⁺.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Cardiac arrest:',
        lines: [
          DoseLine('See inside front cover.'),
        ],
      ),
      DoseSection(
        heading: 'Correction of metabolic acidosis:',
        lines: [
          DoseLine('Calculate patient’s dose with the following formulas.'),
          DoseLine(
            'Neonate, infant, and child:',
            isHeading: true,
          ),
          DoseLine('HCO₃⁻ (mEq) = 0.3 × weight (kg) × base deficit (mEq/L), OR'),
          DoseLine('HCO₃⁻ (mEq) = 0.5 × weight (kg) × [24 – serum HCO₃⁻ (mEq/L)]'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('HCO₃⁻ (mEq) = 0.2 × weight (kg) × base deficit (mEq/L) OR'),
          DoseLine('HCO₃⁻ (mEq) = 0.5 × weight (kg) × [24 – serum HCO₃⁻ (mEq/L)]'),
          DoseLine(
            'Urinary alkalinization (titrate dose accordingly to urine pH):',
            isHeading: true,
          ),
          DoseLine('Child: 84–840 mg (1–10 mEq)/kg/24 hr PO ÷ QID'),
          DoseLine('Adult: 4 g (48 mEq) × 1 followed by 1–2 g (12–24 mEq) PO Q4 hr. Doses up '
              'to 16 g (192 mEq)/24 hr have been used.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in respiratory alkalosis, hypochloremia, and inadequate '
          'ventilation during cardiac arrest. Use with caution in congestive heart '
          'failure (CHF), renal impairment, cirrhosis, hypocalcemia, hypertension, '
          'and concurrent corticosteroids. Maintain high urine output. Monitor '
          'acid-base balance and serum electrolytes. May cause hypernatremia '
          '(contains sodium), hypokalemia, hypomagnesemia, hypocalcemia, '
          'hyperreflexia, edema, and tissue necrosis (extravasation). Oral route of '
          'administration may cause gastrointestinal discomfort and gastric rupture '
          'from gas production.',
      'For direct intravenous administration (cardiac arrest) in neonates and '
          'infants, use the 0.5 mEq/mL (4.2%) concentration or dilute the 1 mEq/mL '
          '(8.4%) concentration 1:1 with sterile water for injection and infuse at a '
          'rate no greater than 10 mEq/min. The 1 mEq/mL (8.4%) concentration may be '
          'used in children and adults for direct intravenous administration.',
      'For intravenous infusions (for all ages), dilute to a max. concentration '
          'of 0.5 mEq/mL in dextrose or sterile water for injection and infuse over '
          '2 hr using a max. rate of 1 mEq/kg per hr.',
      'Sodium bicarbonate must not be mixed with or be in contact with calcium, '
          'norepinephrine, or dobutamine.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1220–1221',
  ),
  // SODIUM CHLORIDE—INHALED PREPARATIONS — PDF p. 412–413 (printed 1221–1222)
  DrugEntryV3(
    name: 'SODIUM CHLORIDE—INHALED PREPARATIONS',
    brandNames: 'Hypersal, Nebusal, PulmoSal, Simply Saline, Ocean, Ayr Saline, Ayr '
        'Nasal Mist Allergy/Sinus, many other brands, and generics',
    drugClass: 'Electrolyte, inhalation',
    iconRow: '',
    formulations: [
      'Nebulized solution (generics): 0.9% (3, 5, 15 mL), 3% (4, 15 mL), 7% (4 '
          'mL), 10% (4, 15 mL)',
      'Hypersal (preservative-free): 3.5% (4 mL), 7% (4 mL)',
      'Nebusal: 3% (4 mL), 6% (4 mL)',
      'PulmoSal: 7% (4 mL)',
      'Nasal solution spray/drops/mist (OTC): 0.65% (15, 30, 45 mL), 2.65% (50 '
          'mL); may contain benzalkonium chloride',
    ],
    doseSections: [
      DoseSection(
        heading: 'Intranasal as moisturizer (use 0.65% concentration):',
        lines: [
          DoseLine(
            'Child and adult:',
            isHeading: true,
          ),
          DoseLine('Spray/Mist: 2–6 sprays into each nostril Q2 hr PRN'),
          DoseLine('Drops: 2–6 drops into each nostril Q2 hr PRN'),
        ],
      ),
      DoseSection(
        heading: 'Cystic fibrosis (pretreatment with albuterol is recommended to '
            'prevent bronchospasms; see remarks):',
        lines: [
          DoseLine('≥2 yr and adult: Nebulize 4 mL of 7% solution once or twice daily. If '
              'patient is unable to tolerate the 7% strength, lower strengths of 3%, '
              '3.5%, or 5% may be used.'),
        ],
      ),
      DoseSection(
        heading: 'Acute viral bronchiolitis (for hospitalized patients only; '
            'pretreatment with albuterol is recommended to prevent bronchospasms; '
            'see remarks):',
        lines: [
          DoseLine('Infant (>34 wk gestation up to 18 mo old): Nebulize 4 mL of 3% solution '
              'Q2 hr for three doses followed by Q4 hr for five doses followed by Q6 hr '
              'dosing until discharge.'),
        ],
      ),
    ],
    remarks: [
      'INTRANASAL USE: May be used as a nasal wash for sinuses, to restore '
          'moisture, to thin nasal secretions, or to relieve dry, crusted, and '
          'inflamed nasal membranes from colds, low humidity, allergies, nasal '
          'decongestant overuse, minor nosebleeds, and other irritations. Nasal '
          'administration instructions:',
      'Nasal drops: Tilt head back and hold bottle upside down.',
      'Nasal spray: Hold head in upright position and give short, firm squeezes '
          'into each nostril. Sniff deeply.',
      'NEBULIZATION: Hypertonic solution lowers sputum viscosity and enhances '
          'mucociliary clearance.',
      'Cystic fibrosis: Improves forced expiratory volume in 1 sec (FEV₁) and '
          'reduces pulmonary exacerbation frequency. May cause bronchospasm, cough, '
          'pharyngitis, hemoptysis, and acute decline in pulmonary function '
          '(administer first dose in a medical facility). It is recommended to '
          'withhold therapy in the presence of massive hemoptysis.',
      'Acute viral bronchiolitis: Use not recommended in the emergency '
          'department but may be administered in hospitalized patients. Reported '
          'reduction in length of hospitalization when compared to normal saline is '
          'controversial. May cause acute bronchospasm and local irritation.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1221–1222',
  ),
  // SODIUM PHENYLACETATE AND SODIUM BENZOATE — PDF p. 413 (printed 1222)
  DrugEntryV3(
    name: 'SODIUM PHENYLACETATE AND SODIUM BENZOATE',
    brandNames: 'Generics; previously available as Ammonul',
    drugClass: 'Ammonium detoxicant, urea cycle disorder treatment agent',
    iconRow: '',
    formulations: [
      'Injection: 100 mg sodium phenylacetate and 100 mg sodium benzoate per 1 '
          'mL (50 mL)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Intravenous (IV) via central line (administered with IV arginine, '
            'continue infusion until ammonia levels are in the normal range):',
        lines: [
          DoseLine('See Chapter 13 for dosing information.'),
        ],
      ),
    ],
    remarks: [
      'Indicated for hyperammonemia due to enzyme deficiencies of the urea cycle '
          '(e.g., carbamoyl phosphate synthetase [CPS] and ornithine '
          'transcarbamylase deficiency). Use with caution in renal and hepatic '
          'impairment. Significant amounts of sodium may be administered with '
          'prolonged durations of therapy. Ammonia clearance is most efficient with '
          'hemodialysis.',
      'Side effects include hypotension, hypokalemia, hyperglycemia, injection '
          'site reaction, nausea/vomiting, altered mental status, fever, metabolic '
          'acidosis, cerebral edema, seizures, anemia, and disseminated '
          'intravascular coagulation. Central nervous system (CNS) side effects are '
          'more frequent with ornithine transcarbamylase (OTC) and CPS. Blood and '
          'lymphatic system disorders and hypotension are common in patients 30 days '
          'old or younger, whereas nausea, vomiting, and diarrhea are common in '
          'patients more than 30 days old. Monitor blood chemistry profiles, blood '
          'pH, and partial pressure of carbon dioxide (pCO₂) for hyperventilation '
          'and metabolic acidosis.',
      'Although no formal drug interaction studies have been completed, '
          'penicillin antibiotics and probenecid may increase serum concentrations '
          'of sodium phenylacetate and sodium benzoate by competing for renal '
          'tubular secretion. Use of valproic acid or corticosteroids may increase '
          'plasma ammonia levels.',
      'Must be diluted and administered IV via central line; peripheral line '
          'administration may result in burning and extravasation.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1222',
  ),
  // SODIUM PHOSPHATE — PDF p. 414 (printed 1223)
  DrugEntryV3(
    name: 'SODIUM PHOSPHATE',
    brandNames: 'Fleet Enema, Fleet Pedia-Lax, Fleet Enema Extra, GoodSense Enema, '
        'LaCrosse Complete, and generics',
    drugClass: 'Laxative, enema',
    iconRow: '',
    formulations: [
      'Enema [OTC]:',
      '7 g dibasic sodium phosphate and 19 g monobasic sodium phosphate/118 mL; '
          'contains 4.4 g sodium per 118 mL',
      'Pediatric size (Fleet Pedia-Lax): 66 mL',
      'Adult size (Fleet Enema, GoodSense Enema, LaCrosse Complete, and '
          'generics): 133 mL',
      '7 g dibasic sodium phosphate and 19 g monobasic sodium phosphate/197 mL; '
          'contains 4.4 g sodium per 197 mL',
      'Fleet Enema Extra: 230 mL',
      'Injection: See Phosphorus Supplements.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Not to be used for phosphorus supplementation (see Phosphorus '
            'Supplements)',
      ),
      DoseSection(
        heading: 'Enema (see remarks):',
        lines: [
          DoseLine('2–4 yr: 33 mL enema (half of Fleet Pedia-Lax) × 1'),
          DoseLine('5–11 yr: 66 mL enema (Fleet Pedia-Lax) × 1'),
          DoseLine('≥12 yr and adult: 133 mL enema (Fleet Enema or generics) OR 230 mL enema '
              '(Fleet Enema Extra) × 1'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in patients with severe renal failure, megacolon, bowel '
          'obstruction, and congestive heart failure (CHF). May cause '
          'hyperphosphatemia, hypernatremia, hypocalcemia, hypotension, dehydration, '
          'and acidosis. Avoid retention of enema solution and do not exceed '
          'recommended doses, as this may lead to severe electrolyte disturbances '
          'due to enhanced systemic absorption. Use with caution in cardiac '
          'arrhythmias. Colonic mucosal aphthous ulceration should be considered '
          'when interpreting colonoscopy findings with use in patients with known or '
          'suspected inflammatory bowel disease (IBD).',
      'Correct electrolyte abnormalities prior to use to minimize electrolyte '
          'side effects.',
      'Onset of action: PR, 2–5 min',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1223',
  ),
  // SODIUM POLYSTYRENE SULFONATE — PDF p. 414–415 (printed 1223–1224)
  DrugEntryV3(
    name: 'SODIUM POLYSTYRENE SULFONATE',
    brandNames: 'SPS, Kionex, and generics; previously available as Kayexalate',
    drugClass: 'Potassium-removing resin',
    iconRow: '',
    formulations: [
      'Powder: 15, 454 g',
      'Liquid suspension for oral or rectal use: 15 g/60 mL (60, 473 mL); '
          'contains 21.5 mL sorbitol per 60 mL, 0.1%–0.3% alcohol, and parabens',
      'Contains 4.3 mEq Na⁺/g drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hyperkalemia: Note:',
        lines: [
          DoseLine('Oral suspension may be given PO or PR (PO route is more effective). '
              'Practical exchange ratio is 1 mEq K per 1 g resin. May calculate dose '
              'according to desired exchange (see remarks).'),
          DoseLine(
            'Infant and child:',
            isHeading: true,
          ),
          DoseLine('PO: 1 g/kg per dose (max. dose: 15 g per dose) Q6 hr'),
          DoseLine('PR: 1 g/kg per dose Q2–6 hr; max. dose: 30–50 g per dose. Dosing by '
              'practical exchange (1 mEq K per 1 g resin) has been recommended for '
              'infants and smaller children.'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('PO: 15 g once daily–QID; max. dose: 60 g per 24 hr'),
          DoseLine('PR: 30–50 g Q2–6 hr'),
        ],
      ),
      DoseSection(
        heading: 'Removal of potassium from enteral formula and/or breast milk (limited '
            'data):',
        lines: [
          DoseLine('Start with 0.25–1 g per mEq of potassium in the total amount of feed '
              'volume being decanted. Place polystyrene and enteral feed in a capped '
              'container and shake vigorously for 20 sec followed by placing the '
              'container undisturbed in the refrigerator for at least 45 min to allow '
              'the binding of polystyrene with potassium. Then carefully pour off the '
              'top layer of the decanted fluid from the bottle into a clean empty '
              'bottle/container. Do not transfer the sediment from the first bottle into '
              'the new bottle/container as this contains the potassium from the feeds. '
              'The decanted feeds can be kept in the refrigerator for 24 hr or until the '
              'enteral feed expires, whichever is less.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in obstructive bowel disease, in neonates with reduced '
          'gut motility, and for oral administration in neonates. Use cautiously in '
          'presence of renal failure, congestive heart failure (CHF), hypertension, '
          'or severe edema. May cause hypokalemia, hypernatremia, hypomagnesemia, '
          'and hypocalcemia. Avoid use with sorbitol in patients with prematurity, '
          'history of intestinal disease or surgery hypovolemia, and renal '
          'insufficiency/failure as cases of colonic necrosis, gastrointestinal (GI) '
          'bleeding, ischemic colitis, and GI perforation have been reported. Use in '
          'neonates generally not recommended due to complication concerns for '
          'hypernatremia and necrotizing enterocolitis (NEC).',
      '1 mEq Na delivered for each mEq K removed. Do not administer with '
          'antacids or laxatives containing Mg²⁺ or Al³⁺; systemic alkalosis may '
          'result. May reduce absorption of other orally administered medications; '
          'administer other oral medications at least 3 hr before or 3 hr after '
          'sodium polystyrene sulfonate (patients with gastroparesis may require a '
          '6-hr separation). Enema should be retained in the colon for at least '
          '30–60 min.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1223–1224',
  ),
  // SPIRONOLACTONE — PDF p. 415–416 (printed 1224–1225)
  DrugEntryV3(
    name: 'SPIRONOLACTONE',
    brandNames: 'Aldactone, CaroSpir, and generics',
    drugClass: 'Diuretic, potassium sparing',
    iconRow: '',
    formulations: [
      'Tabs: 25, 50, 100 mg',
      'Oral suspension: 1, 5, 25 mg/mL',
      'CaroSpir and generics: 25 mg/5 mL (118, 473 mL); contains saccharin',
    ],
    doseSections: [
      DoseSection(
        heading: 'Diuretic (see remarks regarding dosage form bioavailability '
            'differences):',
        lines: [
          DoseLine('Neonate: 1–3 mg/kg/24 hr PO ÷ once or twice daily'),
          DoseLine('Child: 1–3 mg/kg/24 hr PO ÷ BID–QID; max. dose by indication:'),
          DoseLine('Hypertension: The lesser of 3.3 mg/kg/24 hr or 100 mg/24 hr'),
          DoseLine('Edema: The lesser of 4–6 mg/kg/24 hr or 400 mg/24 hr'),
          DoseLine('Adult: 25–200 mg/24 hr PO ÷ once daily–BID (see remarks); max. dose: 200 '
              'mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Primary aldosteronism (treatment):',
        lines: [
          DoseLine('Child (limited data): 1–3 mg/kg/24 hr PO ÷ BID–QID; max. dose: 100 mg/24 '
              'hr'),
          DoseLine('Adult: Start at 12.5–25 mg PO once daily. Increase dose gradually to the '
              'lowest effective dose as needed up to a maximum of 400 mg/24 hr.'),
        ],
      ),
      DoseSection(
        heading: 'Hirsutism in women:',
        lines: [
          DoseLine('Adult: 50–200 mg/24 hr PO ÷ once or twice daily'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in Addison disease, hyperkalemia, use with eplerenone, or '
          'severe renal failure (see Chapter 32). Use with caution in dehydration, '
          'hyponatremia, and renal or hepatic dysfunction. Precipitation of impaired '
          'neurological function, worsening hepatic encephalopathy, and coma may '
          'occur with hepatic disease with cirrhosis and ascites. May cause '
          'hyperkalemia (especially with severe heart failure), gastrointestinal '
          '(GI) distress, rash, lethargy, dizziness, and gynecomastia (due '
          'estrogenic properties). May potentiate ganglionic blocking agents and '
          'other antihypertensives. Monitor potassium levels and be aware of other '
          'K⁺ sources, K⁺-sparing diuretics, and angiotensin-converting enzyme '
          'inhibitors (ACEIs) (all of which can increase K⁺).',
      'Do not use with other medications known to cause hyperkalemia (e.g., '
          'ACEIs, angiotensin II antagonists, aldosterone blockers, and other '
          'potassium-sparing diuretics). Hyperkalemic metabolic acidosis has been '
          'reported with concurrent cholestyramine use. May cause false elevation in '
          'serum digoxin levels measured by radioimmunoassay.',
      'Although TID–QID regimens have been recommended, data suggest once- or '
          'twice-daily dosing to be adequate. Pregnancy category changes to “D” if '
          'used in pregnancy-induced hypertension. The commercially available oral '
          'liquid suspension product (e.g., CaroSpir) has a lower osmolality than '
          'the compounded version and is less irritating to the GI tract. Oral '
          'tablets and the commercially available oral liquid suspensions are NOT '
          'bioequivalent as the oral suspension has been reported to be more '
          'bioavailable by 15%–37%. Administration with food may increase the '
          'exposure of spironolactone by 90% for the commercially available oral '
          'suspension.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1224–1225',
  ),
  // STREPTOMYCIN SULFATE — PDF p. 416–417 (printed 1225–1226)
  DrugEntryV3(
    name: 'STREPTOMYCIN SULFATE',
    brandNames: 'Generics',
    drugClass: 'Antibiotic, aminoglycoside, antituberculous agent',
    iconRow: '',
    formulations: [
      'Powder for injection: 1 g',
    ],
    doseSections: [
      DoseSection(
        heading: 'Multidrug-resistant (MDR) tuberculosis:',
        lines: [
          DoseLine('Use as part of multidrug regimen (see latest edition of AAP Red Book). IM '
              'route is preferred. Monitor levels.'),
          DoseLine(
            'Infant, child, and adolescent (<15 yr or ≤40 kg):',
            isHeading: true,
          ),
          DoseLine('Daily therapy: 20–40 mg/kg/24 hr IM/IV once daily'),
          DoseLine('Max. daily dose: 1 g/24 hr'),
          DoseLine('Twice-weekly therapy (under direct observation): 25–30 mg/kg/dose IM/IV '
              'twice weekly Max. daily dose: 1 g/24 hr'),
          DoseLine(
            'Child, adolescent, and adult (≥15 yr or >40 kg):',
            isHeading: true,
          ),
          DoseLine('Daily therapy: 15–20 mg/kg/24 hr IM/IV once daily; max. daily dose: 1 '
              'g/24 hr'),
          DoseLine('Twice-weekly therapy (under direct observation): 15 mg/kg/dose IM/IV '
              'twice weekly; max. daily dose: 1 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Brucellosis, tularemia, plague, and rat bite fever:',
        lines: [
          DoseLine('See latest edition of the Red Book.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated with aminoglycoside and sulfite hypersensitivity. Use '
          'with caution in preexisting vertigo, tinnitus, hearing loss, and '
          'neuromuscular disorders. Drug is administered via deep IM injection only. '
          'Follow auditory status. May cause central nervous system (CNS) '
          'depression, other neurologic problems, myocarditis, serum sickness, '
          'nephrotoxicity, and ototoxicity. Concomitant neurotoxic, ototoxic, or '
          'nephrotoxic drugs and dehydration may increase risk for toxicity.',
      'Therapeutic levels: peak 15–40 mg/L; trough: <5 mg/L. Recommended serum '
          'sampling time at steady state: trough within 30 min prior to the third '
          'consecutive dose and peak at 30–60 min (60 min for IM) after the '
          'administration of the third consecutive dose. Therapeutic levels are not '
          'achieved in cerebrospinal fluid (CSF).',
      'Adjust dose in renal failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1225–1226',
  ),
  // SUCCIMER — PDF p. 417 (printed 1226)
  DrugEntryV3(
    name: 'SUCCIMER',
    brandNames: 'Chemet, DMSA [dimercaptosuccinic acid]',
    drugClass: 'Chelating agent',
    iconRow: '',
    formulations: [
      'Cap: 100 mg',
    ],
    doseSections: [
      DoseSection(
        heading: 'Lead chelation, child:',
        lines: [
          DoseLine('10 mg/kg/dose (or 350 mg/m²/dose) PO Q8 hr × 5 days, then 10 mg/kg/dose '
              '(or 350 mg/m²/dose) PO Q12 hr × 14 days. Max. dose: 500 mg per dose'),
          DoseLine('Manufacturer recommendation (see following table):'),
        ],
        table: DoseTable(
          headers: ['Weight (kg)', 'Dose (mg) Q8 hr × 5 Days Followed by Same Dose Q12 hr × 14 Days'],
          rows: [
            DoseTableRow(['8–15', '100']),
            DoseTableRow(['16–23', '200']),
            DoseTableRow(['24–34', '300']),
            DoseTableRow(['35–44', '400']),
            DoseTableRow(['≥45', '500']),
          ],
        ),
      ),
    ],
    remarks: [
      'Use caution in patients with compromised renal or hepatic function. '
          'Repeated courses may be necessary. Follow serum lead levels. Allow a '
          'minimum of 2 wk between courses unless blood levels require more '
          'aggressive management. Side effects: gastrointestinal (GI) symptoms, '
          'increased negative liver function tests (LFTs) (10%), rash, headaches, '
          'and dizziness. Allergic reactions, such as urticaria and angioedema, and '
          'neutropenia have been reported. May cause false-positive urinary ketone '
          'readings with nitroprusside reagent tests such as Ketostix and can '
          'falsely lower measured serum uric acid and creatine phosphokinase (CPK). '
          'Coadministration with other chelating agents is not recommended.',
      'Serum transaminases should be monitored at baseline and weekly during '
          'therapy. Treatment of iron deficiency is recommended as well as '
          'environmental remediation. Contents of capsule may be sprinkled on food '
          'for those who are unable to swallow a capsule.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1226',
  ),
  // SUCCINYLCHOLINE — PDF p. 417–418 (printed 1226–1227)
  DrugEntryV3(
    name: 'SUCCINYLCHOLINE',
    brandNames: 'Anectine, Quelicin, and generics',
    drugClass: 'Neuromuscular blocking agent',
    iconRow: '',
    formulations: [
      'Injection:',
      'Anectine, Quelicin, and generics: 20 mg/mL (10 mL); may contain parabens',
      'Prefilled syringe injection:',
      'Generics: 100 mg/5 mL (5 mL); preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Paralysis for intubation (see remarks):',
        lines: [
          DoseLine(
            'Infant, child, and adolescent:',
            isHeading: true,
          ),
          DoseLine(
            'Initial:',
            isHeading: true,
          ),
          DoseLine(
            'IV/IO:',
            isHeading: true,
          ),
          DoseLine('Infant: 2–3 mg/kg/dose × 1'),
          DoseLine('Child: 1–2 mg/kg/dose × 1'),
          DoseLine('Adolescent: 1–1.5 mg/kg/dose × 1'),
          DoseLine(
            'IM:',
            isHeading: true,
          ),
          DoseLine('Infant <6 mo: 4–5 mg/kg/dose × 1'),
          DoseLine('Infant ≥6 mo and child: 4 mg/kg/dose × 1; max. dose: 150 mg per dose'),
          DoseLine('Adolescent: 3–4 mg/kg/dose × 1; max. dose: 150 mg per dose'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine(
            'Initial:',
            isHeading: true,
          ),
          DoseLine('IV: 0.3–1.1 mg/kg/dose × 1'),
          DoseLine('IM: 3–4 mg/kg/dose × 1; max. dose: 150 mg/dose'),
          DoseLine('Maintenance for long surgical procedures: 0.04–0.07 mg/kg/dose IV Q5–10 '
              'min PRN. Continuous infusion not recommended.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated after the acute phase of an injury following major burns, '
          'multiple trauma, extensive denervation of skeletal muscle, or upper motor '
          'neuron injury because severe hyperkalemia and subsequent cardiac arrest '
          'may occur. Individuals carrying the RYR1 or CACNA1S gene have an '
          'increased risk for developing malignant hyperthermia with succinylcholine '
          'or halogenated volatile anesthetics; use in these individuals is '
          'contraindicated. Succinylcholine should be avoided in patients who are '
          'susceptible to malignant hyperthermia or who have neuromuscular diseases '
          'and renal failure.',
      'Pretreatment with atropine is recommended to reduce incidence of '
          'bradycardia. For rapid sequence intubation, see Chapter 1.',
      'Cardiac arrest has been reported in children and adolescents primarily '
          'with skeletal muscle myopathies (e.g., Duchenne muscular dystrophy). '
          'Identify developmental delays suggestive of a myopathy prior to use. '
          'Predose creatine kinase may be useful for identifying patients at risk. '
          'Monitoring of the electrocardiogram (ECG) for peaked T waves may be '
          'useful in detecting early signs of this adverse effect.',
      'May cause malignant hyperthermia (use dantrolene to treat), bradycardia, '
          'hypotension, arrhythmia, and hyperkalemia. Severe anaphylactic reactions '
          'have been reported; use caution if previous anaphylactic reaction to '
          'other neuromuscular blocking agents. Use with caution in patients with '
          'severe burns, paraplegia, or crush injuries and in patients with '
          'preexisting hyperkalemia. Beware of prolonged depression in patients with '
          'liver disease, malnutrition, pseudocholinesterase deficiency, or '
          'hypothermia and those receiving aminoglycosides, phenothiazines, '
          'quinidine, β-blockers, amphotericin B, cyclophosphamide, diuretics, '
          'lithium, acetylcholine, and anticholinesterases. Diazepam may decrease '
          'neuromuscular blocking effects. Prior use of succinylcholine may enhance '
          'the neuromuscular blocking effect of vecuronium and its duration of '
          'action.',
      'Duration of action 4–6 min IV, 10–30 min IM. Must be prepared to intubate '
          'within 1 min.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1226–1227',
  ),
  // SUCRALFATE — PDF p. 419 (printed 1228)
  DrugEntryV3(
    name: 'SUCRALFATE',
    brandNames: 'Carafate and generics',
    drugClass: 'Oral antiulcer agent',
    iconRow: '',
    formulations: [
      'Tabs: 1 g',
      'Oral suspension: 100 mg/mL (420 mL); contains sorbitol and parabens',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child:',
        lines: [
          DoseLine('Duodenal or gastric ulcer (limited data): 40–80 mg/kg/24 hr PO ÷ Q6 hr; '
              'max. dose: 1000 mg/dose'),
          DoseLine('Stomatitis (limited data): 5–10 mL (500–1000 mg of suspension), swish and '
              'spit or swish and swallow QID'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine(
            'Duodenal ulcer:',
            isHeading: true,
          ),
          DoseLine('Treatment: 1 g PO QID (1 hr before meals and QHS) or 2 g PO BID × 4–8 wk'),
          DoseLine('Maintenance/prophylaxis: 1 g PO BID'),
          DoseLine(
            'Stress ulcer:',
            isHeading: true,
          ),
          DoseLine('Prophylaxis: 1 g PO QID'),
          DoseLine('Stomatitis: 10 mL (1000 mg of suspension), swish and spit or swish and '
              'swallow QID'),
          DoseLine('Proctitis (use oral suspension as rectal enema): 20 mL (2 g) dissolved in '
              '20 mL of water PR as a retention enema BID for at least 4 wk or until '
              'resolution of symptoms'),
        ],
      ),
    ],
    remarks: [
      'May cause vertigo, constipation, and dry mouth. Hypersensitivity, '
          'including anaphylactic reactions and hyperglycemia in patients with '
          'diabetes, has been reported. Aluminum may accumulate in patients with '
          'renal failure. This may be augmented by the use of aluminum-containing '
          'antacids. Use with caution in patients with dysphagia or other conditions '
          'that may alter gag or cough reflexes or diminish oropharyngeal '
          'coordination/motility who are receiving the oral tablet dosage form; '
          'cases of tablet aspiration with respiratory complications have been '
          'reported.',
      'Decreases absorption of phenytoin, digoxin, theophylline, cimetidine, '
          'fat-soluble vitamins, ketoconazole, omeprazole, quinolones, and oral '
          'anticoagulants. Administer these drugs at least 2 hr before or after '
          'sucralfate doses.',
      'Drug requires an acidic environment to form a protective polymer coating '
          'for damaged gastrointestinal tract mucosa. Administer oral doses on an '
          'empty stomach (1 hr before meals and QHS).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1228',
  ),
  // SUGAMMADEX — PDF p. 419–420 (printed 1228–1229)
  DrugEntryV3(
    name: 'SUGAMMADEX',
    brandNames: 'Bridion and generics',
    drugClass: 'Neuromuscular blockade reversal agent',
    iconRow: '',
    formulations: [
      'Injection: 100 mg/1 mL (2, 5 mL); may be diluted with normal saline to a '
          'concentration of 10 mg/mL to increase the accuracy of smaller doses',
    ],
    doseSections: [
      DoseSection(
        heading: 'Routine reversal of rocuronium-induced moderate blockade (see '
            'remarks):',
        lines: [
          DoseLine('Infant, child (<2 yr; limited data): 2 or 4 mg/kg/dose IV once over 10 '
              'sec; some suggest administering over slow intravenous push to reduce risk '
              'for bradycardia or asystole'),
        ],
      ),
      DoseSection(
        heading: 'Reversal of rocuronium- or vecuronium-induced neuromuscular blockade '
            '(see remarks):',
        lines: [
          DoseLine(
            'Child ≥2 yr, adolescent, and adult (use actual body weight):',
            isHeading: true,
          ),
          DoseLine('Deep block (spontaneous recovery of twitch response reaching 1–2 '
              'post-tetanic counts with no twitch responses to train-of-four '
              'stimulation): 4 mg/kg/dose IV × 1 over 10 sec'),
          DoseLine('Moderate block (spontaneous recovery of reappearance of the second twitch '
              'in response to train-of-four stimulation): 2 mg/kg/dose IV × 1 over 10 sec'),
        ],
      ),
      DoseSection(
        heading: 'Reversal of neuromuscular blockade 3 min after rocuronium 1.2 mg/kg:',
        lines: [
          DoseLine('Adult (use actual body weight): 16 mg/kg/dose (max. dose: 1000 mg/dose) '
              'IV × 1. The recovery to T₁ of 10% baseline (relative to the time of '
              'administration of rocuronium or succinylcholine) was faster with '
              'rocuronium/sugammadex than with succinylcholine alone. This dose has not '
              'been evaluated for vecuronium-induced neuromuscular blockade.'),
        ],
      ),
    ],
    remarks: [
      'Sugammadex is a modified γ-cyclodextrin that binds to rocuronium and '
          'vecuronium for reduced neuromuscular blockade.',
      'Use is not recommended for patient with glomerular filtration rate (GFR) '
          '<30 mL/min or on dialysis. Use with caution in hepatic impairment, '
          'especially in the presence of coagulopathy or severe edema.',
      'Common side effects include nausea, vomiting, and headache. Serious '
          'effects include bradycardia, prolonged Q–Tc interval, hypersensitivity '
          'reactions/anaphylaxis, increased creatine kinase, and respiratory arrest. '
          'Bronchospasm, laryngospasm, dyspnea, wheezing, and pulmonary edema have '
          'been reported. May increase the effects/toxicity of anticoagulants and '
          'decrease the effects of hormonal contraceptives. Fusidic acid and '
          'toremifene may decrease sugammadex activity.',
      'Limited data in children (especially <2 yr) and dosing in a multicenter, '
          'randomized, parallel-group, dose-finding study in 63 children (28 days to '
          '17 yr of age) and 28 adult surgical patients. Doses were well tolerated '
          'across all ages with dose-response relationship for those 2 yr of age or '
          'older. All had a median recovery time of 1.1 to 1.2 min after a 2 mg/kg '
          'dose (Anesthesiology. 2009;110:284–294).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1228–1229',
  ),
  // SULFACETAMIDE SODIUM OPHTHALMIC — PDF p. 420 (printed 1229)
  DrugEntryV3(
    name: 'SULFACETAMIDE SODIUM OPHTHALMIC',
    brandNames: 'Generics; previously available as Bleph-10',
    drugClass: 'Ophthalmic antibiotic, sulfonamide derivative',
    iconRow: '',
    formulations: [
      'Ophthalmic solution: 10% (15 mL); may contain thimerosal or benzalkonium '
          'chloride',
      'Ophthalmic ointment: 10% (3.5 g)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Conjunctivitis (usual duration of therapy for ophthalmic use is 7–10 '
            'days):',
        lines: [
          DoseLine(
            '≥2 mo and adult:',
            isHeading: true,
          ),
          DoseLine('Ointment: Apply 0.5-in ribbon into the lower conjunctival sac Q3–4 hr and '
              'QHS initially and reduce the dosing frequency with adequate response.'),
          DoseLine('Drops: 1–2 drops to affected eye(s) Q2–3 hr initially, and reduce the '
              'dosing frequency with adequate response.'),
        ],
      ),
    ],
    remarks: [
      'Hypersensitivity reactions between different sulfonamides can occur '
          'regardless of route of administration. May cause local irritation, '
          'stinging, burning, conjunctival hyperemia, excessive tear production, and '
          'eye pain. Rare toxic epidermal necrolysis and Stevens-Johnson syndrome '
          'have been reported. Sulfacetamide preparations are incompatible with '
          'silver preparations.',
      'To reduce risk of systemic absorption with ophthalmic solution, apply '
          'finger pressure to lacrimal sac during and 1–2 min after instillation.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1229',
  ),
  // SULFADIAZINE — PDF p. 421 (printed 1230)
  DrugEntryV3(
    name: 'SULFADIAZINE',
    brandNames: 'Various generics',
    drugClass: 'Antibiotic, sulfonamide derivative',
    iconRow: '',
    formulations: [
      'Tabs: 500 mg',
      'Oral suspension: 100, 200 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'General dosing:',
        lines: [
          DoseLine('Infant ≥2 mo, child, and adolescent: 75 mg/kg/dose or 2000 mg/m²/dose PO '
              '× 1, followed by 150 mg/kg/24 hr or 4000 mg/m²/24 hr ÷ Q4–6 hr (max. '
              'dose: 6000 mg/24 hr)'),
          DoseLine('Adult: 2–4 g/dose × 1, followed by 2–4 g/24 hr PO ÷ Q4–8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Congenital toxoplasmosis (administer with pyrimethamine and folinic '
            'acid; see Pyrimethamine for dosage information):',
        lines: [
          DoseLine('Infant: 100 mg/kg/24 hr PO ÷ BID × 12 mo'),
        ],
      ),
      DoseSection(
        heading: 'Acquired toxoplasmosis (administer with pyrimethamine and folinic '
            'acid; see Pyrimethamine for dosage information):',
        lines: [
          DoseLine('Infant ≥2 mo and child: 100–200 mg/kg/24 hr PO ÷ Q6 hr for at least 4–6 '
              'wk; max. dose: 6000 mg/24 hr'),
          DoseLine('Adult: 4–6 g/24 hr PO ÷ Q6 hr for at least 4–6 wk'),
        ],
      ),
      DoseSection(
        heading: 'Rheumatic fever secondary prophylaxis:',
        lines: [
          DoseLine(
            'Infant ≥2 mo, child, and adolescent:',
            isHeading: true,
          ),
          DoseLine('≤27 kg: 500 mg PO once daily'),
          DoseLine('27–<30 kg: 500–1000 mg PO once daily'),
          DoseLine('≥30 kg: 1000 mg PO once daily'),
        ],
      ),
    ],
    remarks: [
      'Most cases of acquired toxoplasmosis do not require specific '
          'antimicrobial therapy. Contraindicated in porphyria and hypersensitivity '
          'to sulfonamides. Use with caution in premature infants and infants below '
          '2 mo of age, because of risk of hyperbilirubinemia, and in hepatic or '
          'renal dysfunction (30%–44% eliminated in urine). Maintain hydration. May '
          'cause fever, rash, hepatitis, systemic lupus erythematosus (SLE)–like '
          'syndrome, vasculitis, bone marrow suppression, and hemolysis in patients '
          'with glucose-6-phosphate dehydrogenase (G6PD) deficiency, and '
          'Stevens-Johnson syndrome.',
      'May cause increased effects of warfarin, methotrexate, thiazide '
          'diuretics, uricosuric agents, and sulfonylureas due to drug displacement '
          'from protein binding sites. Large quantities of vitamin C or acidifying '
          'agents (e.g., cranberry juice) may cause crystalluria. Pregnancy category '
          'changes from C to D if administered near term. Administer on an empty '
          'stomach with plenty of water.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1230',
  ),
  // SULFAMETHOXAZOLE AND TRIMETHOPRIM — PDF p. 421–422 (printed 1230–1231)
  DrugEntryV3(
    name: 'SULFAMETHOXAZOLE AND TRIMETHOPRIM',
    brandNames: 'Trimethoprim-sulfamethoxazole, Co-Trimoxazole, TMP-SMX, Bactrim, '
        'Bactrin DS, Sulfatrim Pediatric Suspension, and generics; '
        'previously available as Septra',
    drugClass: 'Antibiotic, sulfonamide derivative',
    iconRow: '',
    formulations: [
      'Tabs (may contain sodium benzoate):',
      'Reg. strength (Bactrim and generics): 80 mg TMP/400 mg SMX',
      'Double strength (Bactrim DS and generics): 160 mg TMP/800 mg SMX',
      'Oral suspension (Sulfatrim Pediatric Suspension and generics): 40 mg '
          'TMP/200 mg SMX per 5 mL (100, 480 mL); may contain parabens, alcohol, and '
          'saccharin',
      'Injection: 16 mg TMP/mL and 80 mg SMX/mL (5, 10, 30 mL); some '
          'preparations may contain propylene glycol and benzyl alcohol',
      'TMP = trimethoprim; SMX = sulfamethoxazole',
    ],
    doseSections: [
      DoseSection(
        heading: 'Doses based on TMP component.',
      ),
      DoseSection(
        heading: 'Minor/moderate infections (PO or IV):',
        lines: [
          DoseLine('Child: 8–12 mg/kg/24 hr ÷ BID; max. dose: 160 mg/dose'),
          DoseLine('Adult (>40 kg): 160 mg/dose BID'),
        ],
      ),
      DoseSection(
        heading: 'Severe infections (PO or IV):',
        lines: [
          DoseLine('Child and adult: 20 mg/kg/24 hr ÷ Q6–8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Urinary tract infection (UTI) prophylaxis:',
        lines: [
          DoseLine('Child: 2–4 mg/kg/24 hr PO once daily'),
        ],
      ),
      DoseSection(
        heading: 'Pneumocystis jiroveci (carinii) pneumonia (PCP):',
        lines: [
          DoseLine('Treatment (≥2 mo and adult, PO or IV): 15–20 mg/kg/24 hr ÷ Q6–8 hr × 21 '
              'days'),
          DoseLine(
            'Prophylaxis (PO or IV):',
            isHeading: true,
          ),
          DoseLine('≥1 mo and child: 150 mg/m²/24 hr ÷ BID for 3 consecutive days per wk; '
              'max. dose: 320 mg/24 hr; see Chapter 17 for use criteria for perinatal '
              'human immunodeficiency virus (HIV) PCP prophylaxis.'),
          DoseLine('Adolescent and adult: 80 or 160 mg once daily or 160 mg 3 days per wk'),
        ],
      ),
    ],
    remarks: [
      'Not recommended for use in infants below 2 mo of age (excluding PCP '
          'prophylaxis). Contraindicated in patients with sulfonamide or '
          'trimethoprim hypersensitivity, in those with megaloblastic anemia due to '
          'folate deficiency, and in those who are taking dofetilide. May cause '
          'kernicterus in newborns; may cause blood dyscrasias, crystalluria, '
          'glossitis, renal or hepatic injury, gastrointestinal irritation, rash, '
          'Stevens-Johnson syndrome, or hemolysis in patients with '
          'glucose-6-phosphate dehydrogenase (G6PD) deficiency. Severe hyponatremia '
          'may occur during treatment of Pneumocystis jiroveci pneumonia. '
          'Hyperkalemia may appear in HIV/acquired immunodeficiency syndrome (AIDS) '
          'patients. Use with caution in renal and hepatic impairment and in G6PD '
          'deficiency. QT prolongation resulting in ventricular tachycardia has been '
          'reported. Slow acetylators may be prone to idiosyncratic reactions to '
          'sulfonamides. Intravenous dosage form contains propylene glycol and '
          'benzyl alcohol, which may result in adverse toxic effects when used at '
          'higher dosages, especially in neonates. Use of an adjusted body weight '
          '(ABW; ABW = ideal body weight + 0.4 × [total body weight − ideal body '
          'weight]) has been recommended for determining doses for obese patients.',
      'Discontinue use if significant electrolyte abnormality, renal '
          'insufficiency, or reduction in CBC occurs. Hemophagocytic '
          'lymphohistiocytosis (HLH) has been reported in patients treated with '
          'SMX/TMP (immediately discontinue use).',
      'Epidemiological studies suggest that use during pregnancy may be '
          'associated with increased risk of congenital malformations (particularly '
          'neural tube defects), cardiovascular malformations, urinary tract '
          'defects, oral clefts, and clubfoot.',
      'Sulfamethoxazole is a cytochrome P-450 (CYP) 2C9 substrate and inhibitor. '
          'Trimethoprim is a CYP2C9, CYP3A4 substrate and an inhibitor of CYP2C8 and '
          'ornithine carbamoyltransferase 2 (OCT2) transporter. Avoid use with drugs '
          'that are substrates of CYP2C8 and 2C9 or OCT2. Reduce dose in renal '
          'impairment (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1230–1231',
  ),
  // SULFASALAZINE — PDF p. 423 (printed 1232)
  DrugEntryV3(
    name: 'SULFASALAZINE',
    brandNames: 'Azulfidine, Azulfidine EN-tabs, Salicylazosulfapyridine, and '
        'generics',
    drugClass: 'Anti-inflammatory agent',
    iconRow: '',
    formulations: [
      'Tabs (Azulfidine and generics): 500 mg',
      'Delayed-release tabs (Azulfidine EN-tabs and generics): 500 mg',
      'Oral suspension: 100 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Inflammatory bowel disease:',
        lines: [
          DoseLine(
            'Child ≥6 yr:',
            isHeading: true,
          ),
          DoseLine(
            'Initial dosing:',
            isHeading: true,
          ),
          DoseLine('Mild: 40–50 mg/kg/24 hr PO ÷ Q6 hr'),
          DoseLine('Moderate/severe: 50–75 mg/kg/24 hr PO ÷ Q4–6 hr'),
          DoseLine('Max. initial dose: 4 g/24 hr'),
          DoseLine('Maintenance: 30–70 mg/kg/24 hr PO ÷ Q4–8 hr; max. dose: 4 g/24 hr'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('Initial: 3–4 g/24 hr PO ÷ Q4–8 hr'),
          DoseLine('Maintenance: 2 g/24 hr PO ÷ Q6 hr'),
          DoseLine('Max. dose: 6 g/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Juvenile idiopathic arthritis:',
        lines: [
          DoseLine('Child 6–16 yr: Start with 10 mg/kg/24 hr PO ÷ BID and increase by 10 '
              'mg/kg/24 hr Q7 days until planned maintenance dose is achieved. Usual '
              'maintenance dose is 30–50 mg/kg/24 hr PO ÷ BID up to a max. of 2 g/24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in sulfa or salicylate hypersensitivity, porphyria, and '
          'gastrointestinal (GI) or genitourinary (GU) obstruction. Discontinue use '
          'if a serious infection or renal function deterioration develops while on '
          'therapy. Use with caution in renal impairment, blood dyscrasias, or '
          'asthma. Maintain hydration. May cause orange–yellow discoloration of '
          'urine and skin. May permanently stain contact lenses. May cause '
          'photosensitivity, hypersensitivity (which may result in hepatitis and '
          'nephritis), blood dyscrasias, central nervous system (CNS) changes, '
          'nausea, vomiting, anorexia, diarrhea, and renal damage. '
          'Hepatotoxicity/hepatic failure, anaphylaxis, angioedema, severe drug rash '
          'with eosinophilia and systemic symptoms (DRESS), and interstitial lung '
          'disease have been reported. May cause hemolysis in patients with '
          'glucose-6-phosphate dehydrogenase (G6PD) deficiency. Pseudomononucleosis, '
          'myocarditis, folate deficiency (decreases folic acid absorption), '
          'nephrolithiasis, and oropharyngeal pain have been reported.',
      'Reduces serum digoxin and cyclosporine levels. Slow acetylators may '
          'require lower dosage due to accumulation of active sulfapyridine '
          'metabolite. May cause false-positive test for urinary normetanephrine if '
          'using liquid chromatography methods.',
    ],
    pregnancyNote: 'Pregnancy category changes to “D” if drug is administered near '
        'term. Bloody stools or diarrhea have been reported in breastfed '
        'infants of mothers receiving sulfasalazine.',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1232',
  ),
  // SUMATRIPTAN SUCCINATE — PDF p. 424–425 (printed 1233–1234)
  DrugEntryV3(
    name: 'SUMATRIPTAN SUCCINATE',
    brandNames: 'Imitrex, Imitrex STAT dose, Zembrace SymTouch, Tosymra, Onzetra '
        'Xsail, and generics\nIn combination with naproxen:\nTreximet and '
        'generics',
    drugClass: 'Antimigraine agent, selective serotonin agonist',
    iconRow: '',
    formulations: [
      'Injection, for subcutaneous use:',
      'Zembrace SymTouch: 3 mg/0.5 mL (0.5 mL)',
      'Imitrex STAT dose, and generics: 4 mg/0.5 mL (0.5 mL), 6 mg/0.5 mL (0.5 '
          'mL)',
      'Tabs: 25, 50, 100 mg',
      'Oral suspension: 5 mg/mL',
      'Nasal spray (as a unit-dose spray device):',
      'Generics: 5-mg dose in 100 microliters (six units per pack); 20-mg dose '
          'in 100 microliters (six units per pack)',
      'Tosymra: 10-mg dose in 100 microliters (six units per pack)',
      'Nasal powder (Onzetra Xsail): 11-mg capsule with nasal inhalation '
          'nosepiece (two each per pouch; box of eight pouches)',
      'In combination with naproxen:',
      'Tab (Treximet and generics): 85 mg sumatriptan and 500 mg naproxen sodium '
          '(nine tabs)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child <18 yr:',
        lines: [
          DoseLine('PO/SC/Nasal: Incomplete clinical trials to establish efficacy, with '
              'concerns of serious side effects; see remarks'),
        ],
      ),
      DoseSection(
        heading: 'Adolescent ≥18 yr and adult (see remarks):',
        lines: [
          DoseLine('PO: 25, 50, or 100 mg as soon as possible after onset of headache. If no '
              'relief in 2 hr, give 25–100 mg Q2 hr up to a daily max. of 200 mg. Safety '
              'of treating more than four headaches in a 30-day period has not been '
              'established.'),
          DoseLine('Max. single dose: 100 mg/dose'),
          DoseLine('Max. daily dose: 200 mg/24 hr (with exclusive PO dosing or with an '
              'initial SC dose and subsequent PO dosing)'),
          DoseLine('SC: 3, 4, or 6 mg × 1 as soon as possible after onset of headache. If no '
              'response, may give an additional dose 1 hr later; max. daily dose: 12 '
              'mg/24 hr. Use lower subsequent dose if side effects occur.'),
          DoseLine(
            'Nasal (safety of treating more than four headaches in a 30-day period has '
                'not been established):',
            isHeading: true,
          ),
          DoseLine('Nasal spray (Tosymra and generics): 5, 10, or 20 mg per dose into one '
              'nostril or divided into each nostril after onset of headache. Dose may be '
              'repeated in 2 hr up to a max. of 40 mg/24 hr.'),
          DoseLine('Nasal powder (Onzetra Xsail): Inhale 22 mg (11 mg per nostril) after '
              'onset of headache. Dose may be repeated in 2 hr up to a max. of 44 mg/24 '
              'hr. If using a combination of different dosage forms, the max. dose is '
              'one dose of Onzetra Xsail (22 mg) and one dose of another sumatriptan '
              'product.'),
        ],
      ),
      DoseSection(
        heading: 'In combination with naproxen sodium:',
        lines: [
          DoseLine(
            'Treximet and generics:',
            isHeading: true,
          ),
          DoseLine('Child 12–17 yr: 1 tablet (85 mg sumatriptan + 500 mg naproxen sodium) '
              'after the onset of headache × 1; max. dose: 1 tab/24 hr. Safety of '
              'treating more than two headaches in a 30-day period has not been '
              'established.'),
          DoseLine('Adult: 1 tablet (85 mg sumatriptan + 500 mg naproxen sodium) after the '
              'onset of headache × 1; if response is unsatisfactory in 2 hr, a second '
              'dose may be administered. Max. dose: 2 tabs/24 hr. Safety of treating '
              'more than five headaches in a 30-day period has not been established.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated with concomitant administration of ergotamine '
          'derivatives, monoamine oxidase (MAO) inhibitors (and use within the past '
          '2 wk), and other vasoconstrictive drugs, or history of transient ischemic '
          'attack (TIA) or stroke. Not for migraine prophylaxis. Use with caution in '
          'renal or hepatic impairment. A max. single PO dose of 50 mg has been '
          'recommended in adults with hepatic dysfunction. Acts as selective agonist '
          'for serotonin receptor. Induration and swelling at the injection site, '
          'flushing, and dizziness, as well as chest, jaw, and neck tightness, may '
          'occur with SC administration. Weakness, hyperreflexia, incoordination, '
          'and serotonin syndrome (may be life threatening) have been reported with '
          'use in combination with selective serotonin reuptake inhibitors (e.g., '
          'fluoxetine, fluvoxamine, paroxetine, sertraline).',
      'May cause coronary vasospasm if administered intravenously. Use '
          'injectable form SC only! Onset of action is 10–120 min SC, 60–90 min PO, '
          'and 15–120 min intranasal.',
      'PO, nasal, and SC efficacy studies were not conclusive in clinical trials '
          'for children. Some do not recommend use in patients less than 18 yr of '
          'age owing to poor efficacy and reports of serious adverse events (e.g., '
          'stroke, visual loss, and death) in both children and adults with all '
          'dosage forms.',
      'To minimize infant exposure to sumatriptan, avoid breastfeeding for 12 hr '
          'after treatment. See Naproxen remarks if using the combination '
          'sumatriptan and naproxen dosage form.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1233–1234',
  ),
  // SURFACTANT, PULMONARY/BERACTANT — PDF p. 425–426 (printed 1234–1235)
  DrugEntryV3(
    name: 'SURFACTANT, PULMONARY/BERACTANT',
    brandNames: 'Survanta',
    drugClass: 'Bovine lung surfactant',
    iconRow: '',
    formulations: [
      'Suspension for inhalation: 25 mg/mL phospholipids (4, 8 mL); contains '
          '0.5–1.75 mg triglycerides, 1.4–3.5 mg free fatty acids, and <1 mg protein '
          'per 1 mL drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'Respiratory distress syndrome:',
        lines: [
          DoseLine('Rescue therapy (treatment): 4 mL/kg/dose intratracheally immediately '
              'following the diagnosis of respiratory distress syndrome (RDS). May '
              'repeat dose at intervals no shorter than Q6 hr PRN to a max. of four '
              'total doses during the first 48 hr of life.'),
          DoseLine('Prophylactic therapy (without antenatal steroid use; see remarks): 4 '
              'mL/kg/dose intratracheally as soon as possible (within 15 min after '
              'birth); up to four doses may be given at intervals no shorter than Q6 hr '
              'PRN during the first 48 hr of life.'),
          DoseLine('Method of administration for previously listed therapies (see remarks): '
              'Suction infant prior to administration. Each dose is divided into four '
              'aliquots of 1 mL/kg each; administer 1 mL/kg in each of four different '
              'positions (slight downward inclination with head turned to the right, '
              'then head turned to the left; slight upward inclination with the head '
              'turned to the right, then head turned to the left).'),
        ],
      ),
    ],
    remarks: [
      'Prophylactic therapy with the routine use of continuous positive airway '
          'pressure (CPAP) compared to CPAP alone did not demonstrate a mortality '
          'benefit in a meta-analysis and its use may no longer be recommended.',
      'Transient bradycardia, O₂ desaturation, pallor, vasoconstriction, '
          'hypotension, endotracheal tube blockage, hypercarbia, hypercapnia, apnea, '
          'and hypertension may occur during the administration process. Other side '
          'effects may include pulmonary interstitial emphysema, pulmonary air leak, '
          'and posttreatment nosocomial sepsis. Monitor heart rate and '
          'transcutaneous O₂ saturation during dose administration and arterial '
          'blood gases for postdose hyperoxia and hypocarbia after administration.',
      'All doses are administered intratracheally via a 5-Fr feeding catheter. '
          'If the suspension settles during storage, gently swirl the contents; do '
          'not shake. Drug is stored in the refrigerator, protected from light, and '
          'must be warmed by standing at room temperature for at least 20 min or '
          'warmed in the hand for at least 8 min. Artificial warming methods should '
          'NOT be used.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1234–1235',
  ),
  // SURFACTANT, PULMONARY/CALFACTANT — PDF p. 426 (printed 1235)
  DrugEntryV3(
    name: 'SURFACTANT, PULMONARY/CALFACTANT',
    brandNames: 'Infasurf',
    drugClass: 'Bovine lung surfactant',
    iconRow: '',
    formulations: [
      'Intratracheal suspension: 35 mg/mL phospholipids (3, 6 mL); contains 26 '
          'mg phosphatidylcholine, 0.7 mg protein, and 0.26 mg surfactant protein B '
          'per 1 mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Respiratory distress syndrome (RDS):',
        lines: [
          DoseLine('Rescue therapy (treatment; see remarks): 3 mL/kg/dose intratracheally '
              'immediately after the diagnosis of RDS. May repeat dose as needed Q12 hr '
              'to max. of 3 doses total.'),
          DoseLine('Prophylactic therapy (without antenatal steroid use; see remarks): 3 '
              'mL/kg/dose intratracheally as soon as possible (within 30 min after '
              'birth); up to a total maximum of three doses may be given Q12 hr.'),
          DoseLine('Method of administration for previously listed therapies (see remarks): '
              'Suction infant prior to administration. Manufacturer recommends '
              'administration through a side-port adapter into the endotracheal (ET) '
              'tube with two attendants (one to instill drug and another to monitor and '
              'position patient). Each dose is divided into two aliquots of 1.5 mL/kg '
              'each; administer 1.5 mL/kg in each of two different positions (infant '
              'positioned with either the right or left side dependent). Drug is '
              'administered while ventilation is continued over 20–30 breaths for each '
              'aliquot, with small bursts timed only during the inspiratory cycles. A '
              'pause followed by evaluation of respiratory status and repositioning '
              'should separate the two aliquots. The drug has also been administered by '
              'divided dose into four equal aliquots and administered with repositioning '
              'in the prone, supine, right lateral, and left lateral positions.'),
        ],
      ),
    ],
    remarks: [
      'For rescue therapy, repeat doses may be administered as early as 6 hr '
          'after the previous dose for a total of up to four doses if the infant is '
          'still intubated and requires at least 30% inspired oxygen to maintain an '
          'arterial partial pressure of oxygen (PaO₂) ≥80 torr.',
      'Prophylactic therapy with the routine use of continuous positive airway '
          'pressure (CPAP) compared to CPAP alone did not demonstrate a mortality '
          'benefit in a meta-analysis, and its use may no longer be recommended.',
      'Common adverse effects include cyanosis, airway obstruction, bradycardia, '
          'reflux of surfactant into the ET tube, requirement for manual '
          'ventilation, and reintubation. Monitor O₂ saturation and lung compliance '
          'after each dose so that oxygen therapy and ventilator pressure are '
          'adjusted as necessary.',
      'All doses administered intratracheally via a 5 Fr feeding catheter. If '
          'suspension settles during storage, gently swirl the contents; do not '
          'shake. Drug is stored in the refrigerator, protected from light, and does '
          'not need to be warmed before administration. Unopened vials that have '
          'been warmed to room temperature (once only) may be refrigerated within 24 '
          'hr and stored for future use.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1235',
  ),
  // SURFACTANT, PULMONARY/PORACTANT ALFA — PDF p. 427 (printed 1236)
  DrugEntryV3(
    name: 'SURFACTANT, PULMONARY/PORACTANT ALFA',
    brandNames: 'Curosurf',
    drugClass: 'Porcine lung surfactant',
    iconRow: '',
    formulations: [
      'Intratracheal suspension: 80 mg/mL (1.5, 3 mL): contains 76 mg '
          'phospholipids, 1 mg protein (0.45 mg surfactant protein B, and 0.59 mg '
          'surfactant protein C) per 1 mL drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'Rescue therapy (treatment):',
        lines: [
          DoseLine('2.5 mL/kg/dose (use birth weight) × 1 intratracheally, immediately '
              'following the diagnosis of respiratory distress syndrome (RDS). May '
              'administer 1.25 mL/kg/dose Q12 hr × 2 doses as needed up to a max. total '
              'dose of 5 mL/kg.'),
        ],
      ),
      DoseSection(
        heading: 'Method of administration (see remarks):',
        lines: [
          DoseLine('Suction infant prior to administration. Each dose is divided into two '
              'aliquots, with each aliquot administered into one of the two main bronchi '
              'by positioning the infant with either the right or left side dependent. '
              'After the first aliquot is administered, remove the catheter from the '
              'endotracheal (ET) tube and manually ventilate the infant with 100% oxygen '
              'at a rate of 40–60 breaths/min for 1 min. When the infant is stable, '
              'reposition the infant and administer the second dose with the same '
              'procedures. Then remove the catheter without flushing.'),
        ],
      ),
    ],
    remarks: [
      'Currently approved by the US Food and Drug Administration (FDA) for the '
          'treatment (rescue therapy) of RDS. Transient episodes of bradycardia, '
          'decreased oxygen saturation, reflux of surfactant into the ET tube, and '
          'airway obstruction have occurred during dose administration. Monitor O₂ '
          'saturation and lung compliance after each dose and adjust oxygen therapy '
          'and ventilator pressure as necessary. Pulmonary hemorrhage has been '
          'reported.',
      'All doses administered intratracheally via a 5 Fr feeding catheter. '
          'Suction infant prior to administration and 1 hr after surfactant '
          'instillation (unless signs of significant airway obstruction).',
      'Drug is stored in the refrigerator and protected from light. Each vial of '
          'drug should be slowly warmed to room temperature and gently turned upside '
          'down for uniform suspension (do not shake) before administration. '
          'Unopened vials that have been warmed to room temperature (once only) may '
          'be refrigerated within 24 hr and stored for future use.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1236',
  ),
  // SYMDEKO — PDF p. 427 (printed 1236)  [cross-reference]
  DrugEntryV3(
    name: 'SYMDEKO',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Tezacaftor and Ivacaftor.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1236',
  ),
];
