// =============================================================================
// output/q.dart — Drug Formulary 3.0, letter Q
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyQ` per file; entries in book order.
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

const List<DrugEntryV3> formularyQ = [
  // QUETIAPINE — PDF p. 384–387 (printed 1193–1196)
  DrugEntryV3(
    name: 'QUETIAPINE',
    brandNames: 'Seroquel, Seroquel XR, and generics',
    drugClass: 'Antipsychotic, second generation',
    iconRow: '',
    formulations: [
      'Tabs:',
      'Seroquel: 25, 50, 100, 200, 300, 400 mg',
      'Generics: 25, 50, 100, 150, 200, 300, 400 mg',
      'Extended-release tabs (Seroquel XR and generics): 50, 150, 200, 300, 400 '
          'mg',
      'Oral suspension: 10, 40 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Bipolar mania (continue therapy at lowest dose to maintain efficacy '
            'and periodically assess maintenance treatment needs; PO)',
      ),
      DoseSection(
        heading: 'Immediate-release dosage forms',
        table: DoseTable(
          headers: ['Age', 'Dose Titration', 'Usual Effective Dose', 'Maximum Dose'],
          rows: [
            DoseTableRow(['Child ≥10 yr and adolescent (monotherapy)', 'Day 1: 25 mg BID\nDay 2: 50 mg BID\nDay 3: 100 mg BID\nDay 4: 150 mg BID\n'
                'Day 5: 200 mg BID\n≥Day 6: If needed, additional increases should be ≤100 '
                'mg/24 hr up to 600 mg/24 hr. Total daily doses may be divided TID based '
                'on response and tolerability', '400–600 mg/24 hr', '600 mg/24 hr']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        table: DoseTable(
          headers: ['Age', 'Dose Titration', 'Usual Effective Dose', 'Maximum Dose'],
          rows: [
            DoseTableRow(['Adult (monotherapy or in combination with lithium or divalproex)', 'Day 1: 50 mg BID\nDay 2: 100 mg BID\nDay 3: 150 mg BID\nDay 4: 200 mg '
                'BID\n≥Day 5: If needed, additional increases ≤200 mg/24 hr up to 800 '
                'mg/24 hr by day 6', '400–800 mg/24 hr', '800 mg/24 hr']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Extended-Release tabs (see remarks)',
        table: DoseTable(
          headers: ['Age', 'Dose Titration', 'Usual Effective Dose', 'Maximum Dose'],
          rows: [
            DoseTableRow(['Child ≥10 yr and adolescent (monotherapy)', 'Day 1: 50 mg QHS\nDay 2: 100 mg QHS\nDay 3–5: Increase by 100 mg/24 hr '
                'increments each day until 400 mg once daily is achieved on day 5', '400–600 mg once daily', '600 mg/24 hr']),
            DoseTableRow(['Adult (monotherapy or in combination with lithium or divalproex)', 'Day 1: 300 mg QHS\nDay 2: 600 mg QHS\nDay 3: Adjust dose to 400–800 mg '
                'once daily based on efficacy and tolerance', '400–800 mg once daily', '800 mg/24 hr (some may require 1200 mg/24 hr)']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Schizophrenia (continue therapy at lowest dose to maintain efficacy '
            'and periodically assess maintenance treatment needs; PO)',
      ),
      DoseSection(
        heading: 'Immediate-release dosage forms',
        table: DoseTable(
          headers: ['Age', 'Dose Titration', 'Usual Effective Dose', 'Maximum Dose'],
          rows: [
            DoseTableRow(['Adolescent (13–17 yr)', 'Day 1: 25 mg BID\nDay 2: 50 mg BID\nDay 3: 100 mg BID\nDay 4: 150 mg BID\n'
                'Day 5: 200 mg BID\n≥Day 6: If needed, additional increases should be ≤100 '
                'mg/24 hr up to 800 mg/24 hr. Total daily doses may be divided TID based '
                'on response and tolerability', '400–800 mg/24 hr', '800 mg/24 hr']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        table: DoseTable(
          headers: ['Age', 'Dose Titration', 'Usual Effective Dose', 'Maximum Dose'],
          rows: [
            DoseTableRow(['Adult', 'Day 1: 25 mg BID\nDay 2 and 3: Increase in increments of 25–50 mg divided '
                '2–3 doses daily to 300–400 mg/24 hr divided BID–TID by day 4. If needed, '
                'increase dose by 50–100 mg/24 hr at intervals of at least 2 days', '150–750 mg/24 hr', '750 mg/24 hr']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Extended-Release tabs (see remarks)',
        table: DoseTable(
          headers: ['Age', 'Dose Titration', 'Usual Effective Dose', 'Maximum Dose'],
          rows: [
            DoseTableRow(['Adolescent (13–17 yr)', 'Day 1: 50 mg once daily\nDay 2: 100 mg once daily\nDay 3: 200 mg once '
                'daily\nDay 4: 300 mg once daily\nDay 5: 400 mg once daily', '400–800 mg once daily', '800 mg/24 hr']),
            DoseTableRow(['Adult', 'Day 1: 300 mg QHS\nIf needed, increase dose in increments of up to 300 '
                'mg/24 hr.', '400–800 mg once daily', '800 mg/24 hr']),
          ],
        ),
      ),
    ],
    remarks: [
      'Avoid use in patients with history of cardiac arrhythmias or prolonged '
          'Q–Tc interval syndrome, concurrent medications that can prolong the Q–Tc '
          'interval, and alcohol use. Use with caution in hypovolemia and diabetes '
          'mellitus.',
      'Suicidal ideation/behavior or worsening depression may occur, especially '
          'in children and young adults during the first few months of therapy or '
          'during dosage changes.',
      'Common side effects in children include hypertension, hyperglycemia, '
          'hyperprolactinemia, and significant weight gain. Other common side '
          'effects include orthostatic hypotension, tachycardia, '
          'hypercholesterolemia, hypertriglyceridemia, abdominal pain, '
          'gastrointestinal disturbances, increased appetite, xerostomia, increased '
          'serum transaminases, extrapyramidal symptoms, headache, dizziness, '
          'agitation, and fatigue. Anaphylactic reactions, drug rash with '
          'eosinophilia and systemic symptoms, Stevens-Johnson syndrome, toxic '
          'epidermal necrolysis, syndrome of inappropriate secretion of antidiuretic '
          'hormone, cardiomyopathy, priapism, diabetic ketoacidosis, pancreatitis, '
          'eosinophilia, agranulocytosis, leukopenia, neutropenia, cataracts, '
          'hypothyroidism, fecal incontinence, neuroleptic malignant syndrome, and '
          'seizures have been reported. Anticholinergic side effects (e.g., '
          'constipation, urinary retention) may occur due to norquetiapine, its '
          'active metabolite, and may be enhanced with concurrent use of '
          'anticholinergic medications.',
      'Do not abruptly discontinue medication as acute withdrawal symptoms '
          'occur. Dosage adjustment in hepatic impairment may be necessary as it is '
          'primarily hepatically metabolized. Quetiapine is a major substrate for '
          'cytochrome P-450 (CYP) 3A4 and minor substrate for CYP2D6. Opioids and '
          'other central nervous system (CNS) depressants may enhance CNS depressant '
          'effects. Carbamazepine may decrease the effects of quetiapine. Quetiapine '
          'may decrease dopamine agonist effects (e.g., anti-Parkinson agents) but '
          'may enhance the anticholinergic and Q–Tc interval prolongation effects to '
          'those medications processing these risks. Always check for drug '
          'interactions as effects can be mild to severe.',
      'A Dutch pharmacogenetics working group recommend using an alternative '
          'medication for those who are poor CYP3A4 metabolizers for the indication '
          'of depression. For other indications, a dose reduction of 30% of the '
          'normal dose has been recommended for poor CYP3A4 metabolizers.',
      'Non–extended-release dosage forms may be administered with or without '
          'food. Extended-release tabs must be swallowed whole and administered '
          'preferably in the evening without food (a light meal of ≤300 calories is '
          'allowed). May convert patients from immediate-release to extended-release '
          'tablets at the equivalent total daily dose and administer once daily; '
          'individual dosage adjustments may be necessary.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1193–1196',
  ),
  // QUINIDINE — PDF p. 387–388 (printed 1196–1197)
  DrugEntryV3(
    name: 'QUINIDINE',
    brandNames: 'Various generics',
    drugClass: 'Class IA antiarrhythmic, antimalarial agent',
    iconRow: '',
    formulations: [
      'As gluconate (62% quinidine):',
      'Slow-release tabs: 324 mg',
      'As sulfate (83% quinidine):',
      'Tabs: 200, 300 mg',
      'Oral suspension: 10 mg/mL',
      'Equivalents: 200 mg sulfate = 267 mg gluconate',
      'NOTE: The intravenous dosage form is no longer available in the United '
          'States. Contact the CDC Malaria Hotline at (770) 488-7788 or (855) '
          '856-4713 for an alternative therapy.',
    ],
    doseSections: [
      DoseSection(
        heading: 'All doses are expressed as salt forms.',
      ),
      DoseSection(
        heading: 'Antiarrhythmic (not first line):',
        lines: [
          DoseLine('Child (as sulfate): 15–60 mg/kg/24 hr PO ÷ Q6 hr; max. dose: 2400 mg/24 hr'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('As sulfate: Start at 200 mg/dose Q6 hr and titrate cautiously to desired '
              'effect up to 600 mg PO Q6–12 hr.'),
          DoseLine('As gluconate: 324–648 mg PO Q8–12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Malaria:',
        lines: [
          DoseLine(
            'Child and adult (give intravenously [IV] as gluconate; see remarks):',
            isHeading: true,
          ),
          DoseLine('Loading dose: 10 mg/kg/dose IV (max. dose: 600 mg) over 1–2 hr followed '
              'by maintenance dose. Omit or decrease load if patient has received '
              'quinine or mefloquine.'),
          DoseLine('Maintenance dose: 0.02 mg/kg/min IV as continuous infusion until oral '
              'therapy can be initiated. If more than 48 hr of IV therapy is required, '
              'reduce dose by 30%–50%.'),
        ],
      ),
    ],
    remarks: [
      'Test dose is given to assess for idiosyncratic reaction to quinidine. '
          'Toxicity indicated by increase of QRS interval by ≥0.02 sec (skip dose or '
          'stop drug). May cause gastrointestinal symptoms, hypotension, tinnitus, '
          'thrombotic thrombocytopenic purpura, rash, heart block, and blood '
          'dyscrasias. When used alone, may cause 1:1 conduction in atrial flutter, '
          'leading to ventricular fibrillation. Patients may develop idiosyncratic '
          'ventricular tachycardia with low levels, especially when therapy is being '
          'initiated.',
      'Quinidine is a substrate of cytochrome P-450 (CYP) 3A3/3A4 and 3A5–3A7 '
          'enzymes, and an inhibitor of CYP2D6 and 3A3/3A4 enzymes. Can cause '
          'increase in digoxin levels. Quinidine potentiates the effect of '
          'neuromuscular blocking agents, β-blockers, anticholinergics, and '
          'warfarin. Amiodarone, antacids, delavirdine, diltiazem, grapefruit juice, '
          'saquinavir, ritonavir, verapamil, or cimetidine may enhance the drug’s '
          'effect. Barbiturates, phenytoin, cholinergic drugs, nifedipine, '
          'sucralfate, or rifampin may reduce quinidine’s effect. Use with caution '
          'in renal insufficiency (15%–25% of drug is eliminated unchanged in the '
          'urine), myocardial depression, sick sinus syndrome, glucose-6-phosphate '
          'dehydrogenase deficiency, and hepatic dysfunction.',
      'Therapeutic levels (antiarrhythmic): 3–7 mg/L. Recommended serum sampling '
          'times at steady state: trough level obtained within 30 min prior to the '
          'next scheduled dose after 1–2 days of continuous dosing (steady state).',
      'MALARIA USE: Continuous monitoring of electrocardiogram, blood pressure, '
          'and serum glucose is recommended, especially in pregnant women and young '
          'children.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1196–1197',
  ),
];
