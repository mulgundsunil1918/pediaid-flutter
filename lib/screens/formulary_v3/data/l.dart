// =============================================================================
// output/l.dart — Drug Formulary 3.0, letter L
//
// Extracted word-for-word from source/harriet-lane-24th-ed.pdf by the scripts in
// tools/ (see progress/flagged.md for every decision that was not mechanical).
// Do not edit by hand: regenerate with `python3 tools/build.py`.
//
// Conventions (identical in all 26 output files):
//   * One `const List<DrugEntryV3> formularyL` per file; entries in book order.
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

const List<DrugEntryV3> formularyL = [
  // LABETALOL — PDF p. 252 (printed 1061)
  DrugEntryV3(
    name: 'LABETALOL',
    brandNames: 'Generics; previously available as Normodyne and Trandate',
    drugClass: 'Adrenergic antagonist (α and β), antihypertensive',
    iconRow: '',
    formulations: [
      'Tabs: 100, 200, 300, 400 mg',
      'Injection: 5 mg/mL (4, 20, 40 mL); contains parabens',
      'Injection, prefilled syringe: 5 mg/mL (2 mL); preservative-free',
      'Oral suspension: 10 mg/mL, 40 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child (see remarks):',
        lines: [
          DoseLine('PO: Initial: 1–3 mg/kg/24 hr ÷ BID. May increase up to a maximum of 12 '
              'mg/kg/24 hr up to 1200 mg/24 hr'),
          DoseLine('IV: Hypertensive emergency (start at lowest dose and titrate to effect; '
              'see Chapter 4 for additional information):'),
          DoseLine('Intermittent dose: 0.2–1 mg/kg/dose Q10 min PRN; max. dose: 40 mg/dose'),
          DoseLine('Infusion (hypertensive emergencies): 0.4–1 mg/kg/hr to a max. dose of 3 '
              'mg/kg/hr; may initiate with a 0.2–1 mg/kg bolus; max. bolus: 40 mg'),
        ],
      ),
      DoseSection(
        heading: 'Adult (see remarks):',
        lines: [
          DoseLine('PO: 100 mg BID, increase by 100 mg/dose Q2–3 days PRN to a max. dose of '
              '2.4 g/24 hr. Usual range: 200–800 mg/24hr ÷ BID'),
          DoseLine('IV: Hypertensive emergency (start at lowest dose and titrate to effect '
              'with a max. total dose of 300 mg for both methods of administration):'),
          DoseLine('Intermittent dose: 10–20 mg/dose Q10 min PRN; max. dose: 80 mg/dose'),
          DoseLine('Infusion: 0.5–2 mg/min, increase to titrate to response; may initiate '
              'with a 10–20-mg bolus over 2 min'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in asthma, pulmonary edema, cardiogenic shock, and heart '
          'block. May cause orthostatic hypotension, edema, CHF, bradycardia, AV '
          'conduction disturbances, bronchospasm, urinary retention, and skin '
          'tingling. Use with caution in hepatic disease (dose reduction may be '
          'necessary), diabetes, liver function test elevation, hepatic necrosis, '
          'and hepatitis. Cholestatic jaundice has been reported. Like other '
          'β-adrenergic antagonists, may mask warning signs of hypoglycemia (e.g., '
          'tachycardia). Use with digitalis glycosides may increase risk for '
          'bradycardia. False-positive test for urine amphetamine screen may occur.',
      'Patient should remain supine for up to 3 hr after IV administration. '
          'Pregnancy category changes to “D” if used in second or third trimesters.',
      'Onset of action: PO: 1–4 hr; IV: 5–15 min',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1061',
  ),
  // LACOSAMIDE — PDF p. 253–255 (printed 1062–1064)
  DrugEntryV3(
    name: 'LACOSAMIDE',
    brandNames: 'Vimpat, Motpoly XR, and generics',
    drugClass: 'Anticonvulsant',
    iconRow: '',
    formulations: [
      'Oral solution:',
      'Vimpat and generics: 10 mg/mL (200 mL); contains aspartame, parabens, and '
          'propylene glycol',
      'Tabs:',
      'Vimpat and generics: 50, 100, 150, 200 mg',
      'Extended-released caps (Motpoly XR): 100, 150, 200 mg; for Q24 hr dosing',
      'Injection: 10 mg/mL (20 mL); preservative free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Partial-onset seizures as monotherapy or adjunctive therapy '
            '(immediate-release dosage forms):',
        lines: [
          DoseLine(
            'Child (1 mo–<17 yr):',
            isHeading: true,
          ),
        ],
        table: DoseTable(
          headers: ['Weight (kg)', 'Initial Dosage', 'Titration Regimen', 'Maintenance Dosage'],
          rows: [
            DoseTableRow(['<6', 'PO: 1 mg/kg/dose BID\nIV: 0.66 mg/kg/dose TID', 'PO: Increase by 1 mg/kg/dose BID every 7 days\nIV: Increase by 0.66 '
                'mg/kg/dose TID every 7 days', 'PO: 3.75–7.5 mg/kg/dose BID\nIV: 2.5–5 mg/kg/dose TID']),
            DoseTableRow(['6–<30', 'PO/IV: 1 mg/kg/dose BID', 'PO/IV: Increase by 1 mg/kg/dose BID every 7 days', 'PO/IV: 3–6 mg/kg/dose BID']),
            DoseTableRow(['30–<50', 'PO/IV: 1 mg/kg/dose BID', 'PO/IV Increase by 1 mg/kg/dose BID every 7 days', 'PO/IV: 2–4 mg/kg/dose BID']),
            DoseTableRow(['≥50', 'PO/IV: 50 mg BID', 'PO/IV: Increase by 50 mg BID every 7 days', 'PO/IV:\nMonotherapy: 150–200 mg BID\nAdjunctive therapy:\n100–200 mg BID']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Primary generalized tonic-clonic seizures as adjunctive therapy '
            '(immediate-release dosage forms):',
        lines: [
          DoseLine(
            'Child (4 yr–<17 yr):',
            isHeading: true,
          ),
        ],
        table: DoseTable(
          headers: ['Weight (kg)', 'Initial Dosage', 'Titration Regimen', 'Maintenance Dosage'],
          rows: [
            DoseTableRow(['11–<30', 'PO/IV: 1 mg/kg/dose BID', 'PO/IV: Increase by 1 mg/kg/dose BID every 7 days', 'PO/IV: 3–6 mg/kg/dose BID']),
            DoseTableRow(['30–<50', 'PO/IV: 1 mg/kg/dose BID', 'PO/IV Increase by 1 mg/kg/dose BID every 7 days', 'PO/IV: 2–4 mg/kg/dose BID']),
            DoseTableRow(['≥50', 'PO/IV: 50 mg BID', 'PO/IV: Increase by 50 mg BID every 7 days', 'PO/IV:\nMonotherapy: 150–200 mg BID\nAdjunctive therapy: 100–200 mg BID']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Partial-onset seizures as monotherapy or adjunctive therapy, and '
            'primary generalized tonic-clonic seizures as adjunctive therapy '
            '(immediate-release dosage forms):',
        lines: [
          DoseLine(
            '17 yr and adult:',
            isHeading: true,
          ),
        ],
        table: DoseTable(
          headers: ['Initial Dosage (PO/IV)', 'Titration Regimen (PO/IV)', 'Maintenance Dosage (PO/IV)'],
          rows: [
            DoseTableRow(['Monotherapy: 100 mg BIDᵃ\nAdjunctive therapy: 50 mg BIDᵃ', 'Increase by 50 mg BID every 7 days', 'Monotherapy: 150–200 mg BID\nAdjunctive therapy: 100–200 mg BID\nDoses up '
                'to 300 mg BID may provide benefit for some patients for both indications']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃAlternative initial dosage (under medical supervision due to increased '
              'risk for CNS side effects): 200 mg × 1 and 12 hr'),
          DoseLine('later, start 100 mg BID × 7 days, then titrate to the respective '
              'monotherapy or adjunctive therapy goal.'),
        ],
      ),
      DoseSection(
        heading: 'Partial-onset seizures as monotherapy or adjunctive therapy, and '
            'primary generalized tonic-clonic seizures as adjunctive therapy '
            '(MotpolyXR; extended-release caps):',
        lines: [
          DoseLine(
            'Child ≥50 kg, adolescent, and adult:',
            isHeading: true,
          ),
        ],
        table: DoseTable(
          headers: ['Age and Weight', 'Initial Dosage (PO; Extended-Release Caps)', 'Titration Regimen (PO; Extended-Release Caps)', 'Maintenance Dosage (PO; Extended-Release Caps)'],
          rows: [
            DoseTableRow(['Child ≥50 kg', '100 mg once daily', 'Increase by 100 mg once daily every 7 days', 'Monotherapyᵃ:\n300–400 mg once daily\nAdjunctive therapy:\n200–400 mg '
                'once daily']),
            DoseTableRow(['Adolescent ≥17 yr and adult', 'Monotherapyᵃ: 200 mg once daily\nAdjunctive therapy:\n100 mg once daily', 'Increase by 100 mg once daily every 7 days', 'Monotherapyᵃ:\n300–400 mg once daily\nAdjunctive therapy:\n200–400 mg '
                'once daily']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃMonotherapy only for partial-onset seizures.'),
        ],
      ),
      DoseSection(
        heading: 'Converting from other single antiepileptic drug (AED) to lacosamide '
            'monotherapy:',
        lines: [
          DoseLine('Administer lacosamide in combination with the established single AED for '
              'at least 3 days before tapering. Gradually withdrawing the concomitant '
              'AED over 6 wk is recommended.'),
        ],
      ),
      DoseSection(
        heading: 'IV use:',
        lines: [
          DoseLine('Use same dose when converting from PO to IV and vice versa; except for '
              'pediatric patients <6 kg (see above table). IV use should be considered '
              'for short-term use as clinical treatment evaluations have been limited to '
              '5 days of consecutive use.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution with known cardiac conduction problems (e.g., '
          'second-degree AV block), severe cardiac disease (e.g., MI or heart '
          'failure), concomitant use with drugs known to prolong P–R interval, and '
          'renal (see Chapter 32) and hepatic impairment. Lacosamide undergoes 95% '
          'renal excretion; a reduction of 25% of the maximum dosage is recommended '
          'for adult and pediatric patients with severe renal impairment (CrCl <30 '
          'mL/min and ESRD), or with mild/moderate hepatic impairment. Use is not '
          'recommended in severe hepatic impairment. Dose reduction may be also '
          'necessary with concurrent strong inhibitor of cytochrome P-450 3A4 or 2C9 '
          'medication. Patients with mild/moderate hepatic impairment should be '
          'observed closely during dose titration. Oral bioavailability is '
          'approximately 100%.',
      'Most common side effects in adults include diplopia, headache, dizziness, '
          'and nausea. Somnolence and irritability were frequently reported in '
          'pediatric studies. Patients should be advised of potential dizziness, '
          'ataxia, and syncope with use. Multiorgan hypersensitivity reactions '
          '(including DRESS, affecting the skin, kidney, and liver), worsening of '
          'seizures, agranulocytosis, and euphoria (high doses) have been reported. '
          'As with other AEDs, monitor for suicidal behavior and ideation.',
      'Oral doses may be administered with or without food. Swallow tablets '
          'whole; do not cut tablets. IV doses should be administered over 30–60 '
          'min. Do not abruptly withdraw therapy; gradually taper to prevent '
          'potential seizures.',
      'Lacosamide is present in human milk as increased sleepiness in breastfed '
          'infants has been reported.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1062–1064',
  ),
  // LACTULOSE — PDF p. 255 (printed 1064)
  DrugEntryV3(
    name: 'LACTULOSE',
    brandNames: 'Constulose, Enulose, Generlac, Kristalose, and generics',
    drugClass: 'Ammonium detoxicant, hyperosmotic laxative',
    iconRow: '',
    formulations: [
      'Oral syrup: 10 g/15 mL (15, 30, 237, 473, 946 mL); contains galactose, '
          'lactose, and other sugars',
      'Crystals for reconstitution (Kristalose and generics): 10 g (15s, 30s), '
          '20 g (15s, 30s)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Constipation:',
        lines: [
          DoseLine('Child: 1.5–3 mL/kg/24 hr PO ÷ once daily–BID; max. dose: 90 mL/24 hr'),
          DoseLine('Adult: 15–30 mL/24 hr PO once daily × 1–2 days; may increase to 60 mL/24 '
              'hr if needed'),
        ],
      ),
      DoseSection(
        heading: 'Portal systemic encephalopathy (adjust dose to produce 2–3 soft '
            'stools/day):',
        lines: [
          DoseLine('Infant: 2.5–10 mL/24 hr PO ÷ TID–QID'),
          DoseLine('Child and adolescent: 40–90 mL/24 hr PO ÷ TID–QID'),
          DoseLine('Adult: 30–45 mL/dose PO TID–QID; acute episodes: 30–45 mL Q1–2 hr until '
              '2–3 soft stools/day'),
          DoseLine('Rectal (adult): 300 mL diluted in 700 mL water or NS in 30–60 min '
              'retention enema; may give Q4–8 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in galactosemia. Use with caution in diabetes mellitus. '
          'GI discomfort and diarrhea may occur. For portal systemic encephalopathy, '
          'monitor serum ammonia, serum potassium, and fluid status.',
      'Do not use with antacids. Dissolve crystal dosage form with 4 oz of water '
          'or juice. All doses may be administered with juice, milk, or water.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1064',
  ),
  // LAMIVUDINE — PDF p. 255–256 (printed 1064–1065)
  DrugEntryV3(
    name: 'LAMIVUDINE',
    brandNames: 'Epivir, 3TC, and generics; previously available as Epivir-HBV',
    drugClass: 'Antiviral agent, nucleoside analogue reverse transcriptase inhibitor',
    iconRow: '',
    formulations: [
      'Tabs:',
      'Epivir and generics: 150, 300 mg',
      'Generics (previously available as Epivir-HBV): 100 mg',
      'Oral solution:',
      'Epivir and generics: 10 mg/mL (240 mL); contains parabens',
    ],
    doseSections: [
      DoseSection(
        heading: 'HIV:',
        lines: [
          DoseLine('See https://clinicalinfo.hiv.gov/en/guidelines.'),
        ],
      ),
      DoseSection(
        heading: 'HIV vertical transmission and presumptive treatment during high-risk '
            'situations: mothers who received no antepartum antiretroviral '
            'therapy, mothers who received only intrapartum antiretroviral '
            'therapy, mothers who received antepartum antiretroviral therapy, but '
            'with suboptimal viral suppression (≥50 copies/mL) within 4 weeks '
            'prior to delivery, or mothers with acute or primary HIV infection '
            'during pregnancy or breastfeeding (immediately discontinue '
            'breastfeeding). Transition to a treatment regimen if positive HIV '
            'diagnosis is confirmed and discontinue use after a negative '
            'diagnosis; see Chapter 17 for additional information:',
        lines: [
          DoseLine('Neonate ≥32 wk gestation (use in combination with zidovudine and either '
              'raltegravir or nevirapine): 2 mg/kg/dose PO BID within 6–12 hr after '
              'birth. Increase dose to 4 mg/kg/dose PO BID at 4 wk of age.'),
        ],
      ),
      DoseSection(
        heading: 'Chronic hepatitis B, non-HIV exposed or infected (see remarks):',
        lines: [
          DoseLine('2–17 yr: 3 mg/kg/dose PO once daily up to a max. dose of 100 mg/dose'),
          DoseLine('18 yr and adult: 100 mg/dose PO once daily'),
        ],
      ),
    ],
    remarks: [
      'See https://clinicalinfo.hiv.gov/en/guidelines for remarks for use in '
          'HIV. Oral tablet dosage form is preferred over oral solution for children '
          '≥14 kg treated for HIV because subjects in the ARROW clinical trial '
          'receiving oral solution had lower rates of HIV viral suppression and '
          'lower plasma lamivudine exposure, and developed viral resistance more '
          'frequently.',
      'May cause headache, fatigue, GI disturbances, rash, and '
          'myalgia/arthralgia. Lactic acidosis, severe hepatomegaly with steatosis, '
          'post-treatment exacerbations of hepatitis B and ALT elevations, '
          'pancreatitis, and emergence of resistant viral strains have been '
          'reported. Treatment should be suspended in any patient developing '
          'clinical or laboratory signs of lactic acidosis or hepatotoxicity.',
      'Avoid use with sorbitol-containing medicines, as sorbitol reduces '
          'lamivudine exposure. Concomitant use with co-trimoxazole (TMP/SMX) may '
          'result in increased lamivudine levels.',
      'Use Epivir-HBV product for chronic hepatitis B indication only. Safety '
          'and effectiveness beyond 1 yr have not been determined. If serum HBV DNA '
          'remains detectable after 24 wk of lamivudine monotherapy, consider '
          'switching to an alternative therapy. Patients with both HIV and hepatitis '
          'B should use the higher HIV doses along with an appropriate combination '
          'regimen.',
      'May be administered with food. Adjust dose in renal impairment (see '
          'Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1064–1065',
  ),
  // LAMOTRIGINE — PDF p. 256–261 (printed 1065–1070)
  DrugEntryV3(
    name: 'LAMOTRIGINE',
    brandNames: 'Lamictal, Subvenite, Lamictal ODT, Lamictal XR, and generics',
    drugClass: 'Anticonvulsant',
    iconRow: '',
    formulations: [
      'Tabs (Lamictal, Subvenite, and generics): 25, 100, 150, 200 mg',
      'Extended-release tabs (Lamictal XR and generics): 25, 50, 100, 200, 250, '
          '300 mg',
      'Chewable tabs (Lamictal and generics): 5, 25 mg',
      'Orally disintegrated tabs (Lamictal ODT and generics): 25, 50, 100, 200 '
          'mg; contains sucralose',
      'Oral suspension: 1 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Infant and child <2 yr adjunctive seizure therapy (limited data; use '
            'immediate-release dosage forms):',
        lines: [
          DoseLine(
            'WITH enzyme-inducing AEDs (e.g., carbamazepine, phenytoin, phenobarbital, '
                'primidone) and WITHOUT valproic acid:',
            isHeading: true,
          ),
          DoseLine('Wk 1 and 2: 0.6 mg/kg/24 hr PO ÷ once daily–BID'),
          DoseLine('Wk 3 and 4: 1.2 mg/kg/24 hr PO ÷ once daily–BID'),
          DoseLine('Usual maintenance dose (>wk 4): Titrate dose to effect PRN by increasing '
              'dosage every week by no more than 1.2 mg/kg/24 hr up to a maximum of 15.6 '
              'mg/kg/24 hr ÷ TID not to exceed 400 mg/24 hr.'),
          DoseLine(
            'WITH AEDs containing valproic acid or non-enzyme-inducing AEDs:',
            isHeading: true,
          ),
          DoseLine('Wk 1 and 2: 0.15 mg/kg/24 hr PO ÷ once daily–BID'),
          DoseLine('Wk 3 and 4: 0.3 mg/kg/24 hr PO ÷ once daily–BID'),
          DoseLine('Usual maintenance dose (>wk 4): Titrate dose to effect PRN by increasing '
              'dosage every week by no more than 0.3 mg/kg/24 hr up to a maximum of 5.1 '
              'mg/kg/24 hr ÷ TID not to exceed 200 mg/24 hr.'),
        ],
      ),
      DoseSection(
        heading: 'Child 2–12 yr adjunctive seizure therapy (maintenance doses for '
            'patients <30 kg may need to be increased as much as 50%; use '
            'immediate-release dosage forms; see remarks):',
        lines: [
          DoseLine(
            'WITH AEDs other than carbamazepine, phenytoin, phenobarbital, primidone, '
                'or valproic acid:',
            isHeading: true,
          ),
          DoseLine('Wk 1 and 2: 0.3 mg/kg/24 hr PO ÷ once daily–BID; rounded down to the '
              'nearest whole tablet'),
          DoseLine('Wk 3 and 4: 0.6 mg/kg/24 hr PO ÷ BID; rounded down to the nearest whole '
              'tablet'),
          DoseLine('Usual maintenance dose (>wk 4): 4.5–7.5 mg/kg/24 hr PO ÷ BID; titrate to '
              'effect. To achieve the usual maintenance dose, increase doses Q1–2 wk by '
              '0.6 mg/kg/24 hr (rounded down to the nearest whole tablet) as needed.'),
          DoseLine('Max. dose: 300 mg/24 hr ÷ BID'),
          DoseLine(
            'WITH enzyme-inducing AEDs WITHOUT valproic acid:',
            isHeading: true,
          ),
          DoseLine('Wk 1 and 2: 0.6 mg/kg/24 hr PO ÷ BID; rounded down to the nearest whole '
              'tablet'),
          DoseLine('Wk 3 and 4: 1.2 mg/kg/24 hr PO ÷ BID; rounded down to the nearest whole '
              'tablet'),
          DoseLine('Usual maintenance dose (>wk 4): 5–15 mg/kg/24 hr PO ÷ BID; titrate to '
              'effect. To achieve the usual maintenance dose, increase doses Q1–2 wk by '
              '1.2 mg/kg/24 hr (rounded down to the nearest whole tablet) as needed.'),
          DoseLine('Max. dose: 400 mg/24 hr ÷ BID'),
          DoseLine(
            'WITH AEDs WITH valproic acid:',
            isHeading: true,
          ),
          DoseLine('Wk 1 and 2: 0.15 mg/kg/24 hr PO ÷ once daily–BID; rounded down to the '
              'nearest whole tablet (see following table)'),
          DoseLine('Wk 3 and 4: 0.3 mg/kg/24 hr PO ÷ once daily–BID; rounded down to the '
              'nearest whole tablet (see following table)'),
        ],
        table: DoseTable(
          headers: ['Weight (kg)', 'Weeks 1 and 2', 'Weeks 3 and 4'],
          rows: [
            DoseTableRow(['6.7–14', '2 mg every other day', '2 mg once daily']),
            DoseTableRow(['14.1–27', '2 mg once daily', '4 mg/24 hr ÷ once daily–BID']),
            DoseTableRow(['27.1–34', '4 mg/24 hr ÷ once daily–BID', '8 mg/24 hr ÷ once daily–BID']),
            DoseTableRow(['34.1–40', '5 mg once daily', '10 mg/24 hr ÷ once daily–BID']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('Usual maintenance dose: 1–5 mg/kg/24 hr PO ÷ once daily–BID; titrate to '
              'effect. To achieve the usual maintenance dose, increase doses Q1–2 wk by '
              '0.3 mg/kg/24 hr (rounded down to the nearest whole tablet) as needed. If '
              'adding lamotrigine with valproic acid alone, usual maintenance dose is '
              '1–3 mg/kg/24 hr.'),
          DoseLine('Max. dose: 200 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: '>12 yr and adult adjunctive therapy:',
        lines: [
          DoseLine(
            'WITH AEDs other than carbamazepine, phenytoin, phenobarbital, primidone, '
                'or valproic acid (use immediate-release dosage forms):',
            isHeading: true,
          ),
          DoseLine('Wk 1 and 2: 25 mg once daily PO'),
          DoseLine('Wk 3 and 4: 50 mg once daily PO'),
          DoseLine('Usual maintenance dose (>wk 4): 225–375 mg/24 hr PO ÷ BID; titrate to '
              'effect. To achieve the usual maintenance dose, increase doses Q1–2 wk by '
              '50 mg/24 hr as needed.'),
          DoseLine(
            'WITH enzyme-inducing AEDs WITHOUT valproic acid (use immediate-release '
                'dosage forms):',
            isHeading: true,
          ),
          DoseLine('Wk 1 and 2: 50 mg PO once daily'),
          DoseLine('Wk 3 and 4: 50 mg PO BID'),
          DoseLine('Usual maintenance dose (>wk 4): 300–500 mg/24 hr PO ÷ BID; titrate to '
              'effect. To achieve the usual maintenance dose, increase doses Q1–2 wk by '
              '100 mg/24 hr as needed. Doses as high as 700 mg/24 hr ÷ BID have been '
              'used.'),
          DoseLine('WITH AEDs WITH valproic acid: (use immediate-release dosage forms)'),
          DoseLine('Wk 1 and 2: 25 mg PO every other day'),
          DoseLine('Wk 3 and 4: 25 mg PO once daily'),
          DoseLine('Usual maintenance dose (>wk 4): 100–400 mg/24 hr PO ÷ once daily–BID; '
              'titrate to effect. To achieve the usual maintenance dose, increase doses '
              'Q1–2 wk by 25–50 mg/24 hr as needed. If adding lamotrigene to valproic '
              'acid alone, usual maintenance dose is 100–200 mg/24 hr.'),
          DoseLine(
            'Extended-release dosage form (Lamictal XR):',
            isHeading: true,
          ),
          DoseLine(
            '≥13 yr and adult adjunctive therapy (dose increases at wk 8 or later '
                'should not exceed 100 mg/24 hr at weekly intervals; see remarks):',
            isHeading: true,
          ),
        ],
        table: DoseTable(
          headers: ['', 'Weeks 1 and 2', 'Weeks 3 and 4', 'Week 5', 'Week 6', 'Week 7', 'Maintenance Doseᵃ'],
          rows: [
            DoseTableRow(['Patient NOT receiving enzyme-inducing drugs (e.g., carbamazepine) OR '
                'valproic acid', '25 mg once daily', '50 mg once daily', '100 mg once daily', '150 mg once daily', '200 mg once daily', '300–400 mg once daily']),
            DoseTableRow(['Patients receiving enzyme-inducing drugs (e.g., carbamazepine) WITHOUT '
                'valproic acid', '50 mg once daily', '100 mg once daily', '200 mg once daily', '300 mg once daily', '400 mg once daily', '400–600 mg once daily']),
            DoseTableRow(['Patients receiving valproic acid', '25 mg every other day', '25 mg once daily', '50 mg once daily', '100 mg once daily', '150 mg once daily', '200–250 mg once daily']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃDose increases after week 8 should not exceed 100 mg/24 hr at weekly '
              'intervals.'),
        ],
      ),
      DoseSection(
        heading: 'Converting Adjunctive Therapy to Lamotrigine Monotherapy:',
        table: DoseTable(
          headers: ['', 'Immediate-Release Lamotrigine Dosage Form Regimen (≥16 Yr and Adult)', 'Extended-Release Tabs (≥13 Yr and Adult)'],
          rows: [
            DoseTableRow(['Patient NOT receiving enzyme-inducing drugs (e.g., carbamazepine) OR '
                'valproic acid', 'No specific dosing guidelines provided', 'After achieving a maintenance dose of 250–300 mg/24 hr with the above '
                'recommendations, withdraw the concomitant AED by 20% decrements each week '
                'over a 4-wk period.']),
            DoseTableRow(['Patients receiving enzyme-inducing drugs (e.g., carbamazepine) WITHOUT '
                'valproic acid', 'After achieving a maintenance dose of 500 mg/24 hr with the above '
                'recommendations, withdraw the concomitant enzyme-inducing AED by 20% '
                'decrements each week over a 4-wk period', 'After achieving a maintenance dose of 500 mg/24 hr with the above '
                'recommendations, withdraw the concomitant enzyme-inducing AED by 20% '
                'decrements each week over a 4-wk period. After 2 wk of the complete '
                'withdrawal of enzyme-inducing AED, lamotrigine may be decreased no faster '
                'than 100 mg/24 hr each week to the maintenance dose of 250–300 mg/24 hr']),
            DoseTableRow(['Patients receiving valproic acid', 'Step 1: Achieve maintenance dose of 200 mg/24 hr with the above '
                'recommendations.\nStep 2: Decrease valproic acid by decrements no greater '
                'than 500 mg/24 hr per week to reach 500 mg/24 hr and maintain for 1 wk.\n'
                'Step 3: Increase lamotrigine to 300 mg/24 hr and decrease valproic acid '
                'to 250 mg/24 hr; maintain both for 1 wk.\nStep 4: Increase lamotrigine by '
                '100 mg/24 hr Q7 days until reaching maintenance dose of 500 mg/24 hr and '
                'discontinue valproic acid', 'Step 1: Achieve maintenance dose of 150 mg/24 hr with the above '
                'recommendations.\nStep 2: Decrease valproic acid by decrements no greater '
                'than 500 mg/24 hr per week to reach 500 mg/24 hr and maintain for 1 wk.\n'
                'Step 3: Increase lamotrigine to 200 mg/24 hr and decrease valproic acid '
                'to 250 mg/24 hr; maintain both for 1 wk.\nStep 4: Increase lamotrigine to '
                '250–300 mg/24 hr and discontinue valproic acid']),
          ],
        ),
      ),
      DoseSection(
        heading: 'Bipolar disease (use immediate-release dosage forms; see remarks):',
        lines: [
          DoseLine(
            '≥18 yr and adult (PO; see table below):',
            isHeading: true,
          ),
        ],
        table: DoseTable(
          headers: ['', 'Weeks 1 and 2', 'Weeks 3 and 4', 'Week 5', 'Weeks 6 and Thereafter'],
          rows: [
            DoseTableRow(['Patient NOT receiving enzyme-inducing drugs (e.g., carbamazepine) OR '
                'valproic acid', '25 mg/24 hr', '50 mg/24 hr ÷ once daily–BID', '100 mg/24 hr ÷ once daily–BID', '200 mg/24 hr ÷ once daily–BID (target dose); some patients may require '
                '400 mg/24 hr']),
            DoseTableRow(['Patents receiving enzyme-inducing drugs (e.g., carbamazepine) WITHOUT '
                'valproic acid', '50 mg/24 hr ÷ once daily–BID', '100 mg/24 hr ÷ once daily–BID', '200 mg/24 hr ÷ once daily–BID', 'Wk 6: 300 mg/24 hr ÷ once daily–BID\nWk 7 and thereafter:\nmay increase\n'
                'to 400 mg/24\nhr ÷ once\ndaily–BIDᵃ']),
            DoseTableRow(['Patients receiving valproic acid', '25 mg every other day', '25 mg once daily', '50 mg/24 hr ÷ once daily–BID', '100 mg/24 hr ÷ once daily–BID (target dose)ᵇ']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃIf carbamazepine or other enzyme-inducing drug is discontinued, maintain '
              'current lamotrigine dose for 1 wk, then'),
          DoseLine('decrease daily lamotrigine dose in 100-mg increments at weekly intervals '
              'until 200 mg/24 hr.'),
          DoseLine('ᵇIf valproic acid is discontinued, increase by 50 mg at weekly intervals, '
              'up to 200 mg/24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Enzyme-inducing AEDs include carbamazepine, phenytoin, and phenobarbital. '
          'Stevens-Johnson syndrome, toxic epidermal necrolysis, and other '
          'potentially life-threatening rashes have been reported in children '
          '(0.3%–0.8%) and adults (0.08%–0.3%) for adjunctive therapy in seizures. '
          'Reported rates for adults treated for bipolar/mood disorders as '
          'monotherapy and adjunctive therapy are 0.08% and 0.13%, respectively. May '
          'cause fatigue, drowsiness, ataxia, rash (especially with valproic acid), '
          'headache, nausea, vomiting, and abdominal pain. Diplopia, nystagmus, '
          'aseptic meningitis, hemophagocytic lymphohistiocytosis, aggression, and '
          'alopecia have also been reported. False-positive test for urine '
          'phencyclidine (PCP) screen may occur.',
      'Use during the first 3 mo of pregnancy may result in a higher chance for '
          'cleft lip or cleft palate in the newborn. Suicidal behavior or ideation '
          'has been reported. In vitro studies show lamotrigine having Class IB '
          'antiarrhythmic activity; access the benefit/risk for use in patients with '
          'clinically significant structural or functional heart disease, including '
          'cardiac channelopathies.',
      'If converting from immediate-release to extended-release dosage form, '
          'match the initial dose of extended-release dosage to the total daily dose '
          'of the immediate-release dosage and administer once daily. Adjust dose as '
          'needed with the recommended dosage guidelines.',
      'Reduce maintenance dose in renal failure. Reduce all doses (initial, '
          'escalation, and maintenance) in liver dysfunction defined by the '
          'Child-Pugh grading system as follows:',
      'Grade B: Moderate dysfunction; decrease dose by ~50%',
      'Grade C: Severe dysfunction; decrease dose by ~75%',
      'Withdrawal symptoms may occur if discontinued suddenly. A stepwise dose '
          'reduction over ≥2 wk (~50% per wk) is recommended unless safety concerns '
          'require a more rapid withdrawal.',
      'Lamotrigine is metabolized by uridine 5\'-diphospho-glucuronyl '
          'transferases (UGT). Strong and moderate inducers of cytochrome P-450 3A4 '
          'are known to induce UGT to increase lamotrigine clearance. Acetaminophen, '
          'carbamazepine, oral contraceptives (ethinyl estradiol), phenobarbital, '
          'primidone, phenytoin, and rifampin may decrease levels of lamotrigine. '
          'Valproic acid may increase levels. Use with sodium channel blockers may '
          'increase the risk of arrhythmias. Severe dermatologic reactions(e.g., SJS '
          'and TEN) has been associated with the HLA-B*1502 genotype.',
      'Safety and efficacy for maintenance therapy for bipolar disorder in 10–17 '
          'yr olds were not established in an RCT with 301 subjects.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1065–1070',
  ),
  // LANSOPRAZOLE — PDF p. 261–262 (printed 1070–1071)
  DrugEntryV3(
    name: 'LANSOPRAZOLE',
    brandNames: 'Prevacid, Prevacid SoluTab, and generics',
    drugClass: 'Gastric acid pump inhibitor',
    iconRow: '',
    formulations: [
      'Caps, delayed release: 15 mg (OTC and Rx), 30 mg',
      'Tabs, disintegrating delayed release (Prevacid SoluTab and generics): 15 '
          'mg (OTC and Rx), 30 mg; contains aspartame',
      'Oral suspension: 3 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate (limited data, with use not recommended in preterm neonates):',
        lines: [
          DoseLine('0.5–1.5 mg/kg/24 hr PO ÷ once daily–BID'),
        ],
      ),
      DoseSection(
        heading: 'Short-term treatment of GERD and erosive esophagitis, for up to 12 wk '
            '(see remarks):',
        lines: [
          DoseLine('Infant: 1–2 mg/kg/24 hr PO ÷ once daily–BID'),
          DoseLine('Alternative dosing for fixed dosing for ≥3 mo: 15 mg/24 hr PO ÷ once '
              'daily–BID'),
          DoseLine('Child 1–11 yr: 0.7–3 mg/kg/24 hr PO ÷ once daily–BID; max. dose: 30 mg/24 '
              'hr'),
          DoseLine(
            'Alternative dosing for fixed dosing:',
            isHeading: true,
          ),
          DoseLine('≤30 kg: 15 mg PO once daily'),
          DoseLine('>30 kg: 30 mg PO once daily'),
          DoseLine('Subsequent dosage increase (if needed): May be increased up to 30 mg PO '
              'BID after ≥2 wk of therapy without response at initial dose level'),
        ],
      ),
      DoseSection(
        heading: '12 yr–adult:',
        lines: [
          DoseLine('GERD: 15 mg PO once daily for up to 8 wk'),
          DoseLine('Erosive esophagitis: 30 mg PO once daily × 8–16 wk; maintenance dose: 15 '
              'mg PO once daily'),
          DoseLine('Duodenal ulcer: 15 mg PO once daily × 4 wk; maintenance dose: 15 mg PO '
              'once daily'),
          DoseLine(
            'Gastric ulcer and NSAID-induced ulcer:',
            isHeading: true,
          ),
          DoseLine('Prophylaxis: 15 mg PO once daily for up to 12 wk'),
          DoseLine('Treatment: 30 mg PO once daily for up to 8 wk'),
          DoseLine('Hypersecretory conditions: 60 mg PO once daily; dosage may be increased '
              'up to 90 mg PO BID, where doses >120 mg/24 hr are divided BID'),
        ],
      ),
    ],
    remarks: [
      'Common side effects include GI discomfort, headache, fatigue, rash, and '
          'taste perversion. Hypersensitivity reactions may result in anaphylaxis, '
          'angioedema, severe cutaneous reactions, bronchospasm, interstitial '
          'nephritis, and urticaria. Prolonged use may result in vitamin B₁₂ '
          'deficiency (≥2 yr) or hypomagnesemia (>1 yr; sometimes leading to '
          'hypocalcemia, tetany, arrhythmias, and seizures). Microscopic colitis, '
          'resulting in watery diarrhea, has been reported, and switching to an '
          'alternative proton pump inhibitor may be beneficial in resolving '
          'diarrhea. Increased risk for fundic gland polyps has been associated with '
          'long-term use >1 yr.',
      'Drug is a substrate for cytochrome P-450 (CYP) 2C19 and 3A3/3A4. '
          'Ultrarapid metabolizers of CYP2C19 may experience reduced efficacy and '
          'may require a 4-fold higher dosage. Lansoprazole may decrease levels of '
          'itraconazole, ketoconazole, iron salts, mycophenolate, nelfinavir, and '
          'ampicillin esters, and may increase the levels/effects of methotrexate, '
          'tacrolimus, and warfarin. Theophylline clearance may be enhanced. Reduce '
          'dose in severe hepatic impairment. May be used in combination with '
          'clarithromycin and amoxicillin for Helicobacter pylori infections.',
      'In a multicenter, double-blind, parallel-group study in infants (1 mo–1 '
          'yr) with GERD, lansoprazole was no more effective than placebo.',
      'Administer all oral doses before meals and 30 min prior to sucralfate. Do '
          'not crush or chew the granules (all dosage forms). Capsule may be opened '
          'and intact granules may be administered in an acidic beverage or food '
          '(e.g., apple or cranberry juice, applesauce). Do not break or cut the '
          'orally disintegrating tablets. Use of oral disintegrating tablets '
          'dissolved in water has been reported to clog and block oral syringes and '
          'feeding tubes (gastric and jejunostomy).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1070–1071',
  ),
  // LETERMOVIR — PDF p. 262–263 (printed 1071–1072)
  DrugEntryV3(
    name: 'LETERMOVIR',
    brandNames: 'Prevymis',
    drugClass: 'Antiviral agent',
    iconRow: '',
    formulations: [
      'Injection: 20 mg/mL (12, 24 mL); contains hydroxypropyl betadex, '
          'preservative free',
      'Tabs: 240, 480 mg',
      'Oral granules: 20, 120 mg (30 packets)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Prophylaxis of cytomegalovirus (CMV) in CMV-seropositive allogenic '
            'hematopoietic cell transplant recipient:',
        lines: [
          DoseLine('Initiate therapy between days 0–28 post-transplantation. Continue therapy '
              'through day 100 post-transplantation or through day 200 '
              'post-transplantation for patients at risk for late CMV disease. Reduce '
              'dosage by 50% when used in combination with cyclosporine.'),
          DoseLine(
            'Child 3–<12 yr:',
            isHeading: true,
          ),
        ],
        table: DoseTable(
          headers: ['Weight (kg)', 'PO Dose Once Daily (mg)', 'IV Dose Once Daily (See Remarks) (mg)'],
          rows: [
            DoseTableRow(['6–<7.5', '80', '40']),
            DoseTableRow(['7.5–<15', '120', '60']),
            DoseTableRow(['15–<30', '240', '120']),
            DoseTableRow(['≥30', '480', '480']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('Child 12–18 yr (≥30 kg): 480 mg IV/PO once daily'),
          DoseLine('Adult (≥30 kg): 480 mg IV/PO once daily initiated between days 0–28 '
              'post-transplantation. Continue therapy through day 100 '
              'post-transplantation; patients at risk for late CMV disease may be '
              'continued through day 200 post-transplantation.'),
        ],
      ),
      DoseSection(
        heading: 'Prophylaxis of CMV disease in high-risk kidney transplant recipient '
            '(donor CMV positive/recipient CMV negative):',
        lines: [
          DoseLine('Reduce dosage by 50% when used in combination with cyclosporine.'),
          DoseLine('Child ≥12 yr and adult (≥40 kg): 480 mg IV/PO once daily initiated '
              'between days 0–7 post-transplantation and continued through day 200 '
              'post-transplantation.'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated when used with pimozide, ergot alkaloids (e.g., '
          'ergotamine and dihydroergotamine), and pitavastatin/simvastatin due to '
          'increased risk for Q–Tc prolongation, ergotism, and '
          'myopathy/rhabdomyolysis, respectively. Common side effects include '
          'nausea, vomiting, diarrhea, abdominal pain, peripheral edema, headache, '
          'cough, and fatigue. Hypersensitivity reactions and decreased hemoglobin '
          'have been reported.',
      'Use is not recommended in severe liver impairment (Child-Pugh class C). '
          'Use with caution for patients with a CrCl of <50 mL/min and receiving the '
          'IV dosage form due to the potential accumulation of the IV drug '
          'stabilizer, hydroxypropyl betadex.',
      'Inhibits cytochrome P-450 3A4 and is a substrate for OATP1B1/1B3 and '
          'P-glycoprotein (ABCB1). Reduce letermovir dose by 50% when used in '
          'combination with cyclosporine. Always check for interactions to assess '
          'the risk of potential toxicities and use recommendations when used with '
          'other medications of similar metabolism and transporter characteristics.',
      'Administer IV dosage form through a 0.2- or 0.22-micron polyethersulfone '
          '(PES) in-line filter and DO NOT administer with IV bags and infusion sets '
          'containing polyurethane or diethylhexyl phthalate (DEHP) plasticizers. '
          'Oral tablets may be crushed and mixed with sterile water for feeding tube '
          'administration. Doses may be administered with or without food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1071–1072',
  ),
  // LEVALBUTEROL — PDF p. 263 (printed 1072)
  DrugEntryV3(
    name: 'LEVALBUTEROL',
    brandNames: 'Xopenex HFA and generics; previously available as Xopenex',
    drugClass: 'β₂-Adrenergic agonist',
    iconRow: '',
    formulations: [
      'Prediluted nebulized solution: 0.31 mg in 3 mL, 0.63 mg in 3 mL, 1.25 mg '
          'in 3 mL (30s)',
      'Concentrated nebulized solution: 1.25 mg/0.5 mL (0.5 mL) (30s)',
      'Aerosol inhaler (MDI; Xopenex HFA and generics): 45 mCg/actuation (15 g '
          'delivers 200 doses)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Nonacute exacerbation symptom relief:',
        lines: [
          DoseLine(
            'Nebulizer:',
            isHeading: true,
          ),
          DoseLine('≤4 yr (limited data): Start at 0.31 mg inhaled Q4–6 hr PRN; dose may be '
              'increased up to 1.25 mg Q4–6 hr PRN.'),
          DoseLine('5–11 yr: Start at 0.31 mg inhaled Q8 hr PRN; dose may be increased to '
              '0.63 mg Q8 hr PRN.'),
          DoseLine('≥12 yr and adult: Start at 0.63 mg inhaled Q6–8 hr PRN; dose may be '
              'increased to 1.25 mg inhaled Q6–8 hr PRN.'),
          DoseLine(
            'Aerosol inhaler (MDI):',
            isHeading: true,
          ),
          DoseLine('≥4 yr and adult: 2 puffs Q4–6 hr PRN'),
        ],
      ),
      DoseSection(
        heading: 'For use in acute exacerbations, more aggressive dosing may be used.',
      ),
    ],
    remarks: [
      'R-isomer of racemic albuterol. Side effects include tachycardia, '
          'palpitations, tremor, insomnia, nervousness, nausea, and headache.',
      'Clinical data in children demonstrate levalbuterol is as effective as '
          'albuterol with fewer cardiac side effects at equipotent doses (0.31–0.63 '
          'mg levalbuterol ~2.5 mg albuterol). However, when higher doses of '
          'levalbuterol (1.25 mg) were compared to 2.5 mg albuterol, changes in '
          'heart rate were similar.',
      'More frequent dosing may be necessary in asthma exacerbation.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1072',
  ),
  // LEVETIRACETAM — PDF p. 264–265 (printed 1073–1074)
  DrugEntryV3(
    name: 'LEVETIRACETAM',
    brandNames: 'Keppra, Keppra XR, Elepsia XR, Roweepra, Spritam, and generics',
    drugClass: 'Anticonvulsant',
    iconRow: '',
    formulations: [
      'Tabs: 250, 500, 750, 1000 mg',
      'Extended-release tabs (Q24 hr dosing; see remarks):',
      'Keprra XR and generics: 500, 750 mg',
      'Elepsia XR: 1000, 1500 mg',
      'Tabs, disintegrating (see remarks):',
      'Spritam: 250, 500, 750, 1000 mg',
      'Generic: 250 mg',
      'Oral solution: 100 mg/mL (480 mL); dye free and contains parabens',
      'Injection: 100 mg/mL (5 mL); contains 45 mg sodium chloride and 8.2 mg '
          'sodium acetate trihydrate per 100 mg drug',
      'Premixed injection: 500 mg/100 mL in 0.82% sodium chloride, 1000 mg/100 '
          'mL in 0.75% sodium chloride, 1500 mg/100 mL in 0.54% sodium chloride',
    ],
    doseSections: [
      DoseSection(
        heading: 'Partial seizures (monotherapy or adjunctive therapy; using '
            'immediate-release dosage forms and IV):',
        lines: [
          DoseLine('Infant (1–5 mo): Start at 7 mg/kg/dose PO/IV BID; increase by 7 '
              'mg/kg/dose BID every 2 wk as tolerated to the recommended dose of 21 '
              'mg/kg/dose BID. An average daily dose of 35 mg/kg/24 hr was reported in '
              'clinical trials.'),
          DoseLine('Infant ≥6 mo–child 3 yr (>20 kg): Start at 10 mg/kg/dose PO/IV BID; '
              'increase by 10 mg/kg/dose BID every 2 wk as tolerated to the recommended '
              'dose of 25 mg/kg/dose BID. An average daily dose of 47 mg/kg/24 hr was '
              'reported in clinical trials.'),
          DoseLine('Child 4–15 yr: Start at 10 mg/kg/dose PO/IV BID; increase by 10 '
              'mg/kg/dose BID every 2 wk as tolerated up to the recommended dose of 30 '
              'mg/kg/dose BID or up to a max. dose of 3000 mg/24 hr. An average daily '
              'dose of 44 mg/kg/24 hr was reported in clinical trials.'),
          DoseLine(
            'Alternative dosing with oral tablets or oral disintegrating tabs:',
            isHeading: true,
          ),
          DoseLine('20–40 kg: Start at 250 mg PO BID; increase by 250 mg BID every 2 wk as '
              'tolerated up to a maximum of 750 mg BID.'),
          DoseLine('>40 kg: Start at 500 mg PO BID; increase by 500 mg BID every 2 wk as '
              'tolerated up to a maximum of 1500 mg BID.'),
          DoseLine('16 yr–adult: Start at 500 mg PO/IV BID; may increase by 500 mg/dose BID '
              'every 2 wk as tolerated up to a max. dose of 1500 mg BID.'),
          DoseLine('Extended release tabs (>12 yr and adult): Start at 1000 mg PO once daily; '
              'increase by 1000 mg/24 hr every 2 wk as tolerated up to a maximum of 3000 '
              'mg/24 hr once daily.'),
        ],
      ),
      DoseSection(
        heading: 'Myoclonic seizure (adjunctive therapy; using immediate-release dosage '
            'forms and IV):',
        lines: [
          DoseLine('≥12 yr and adult: Start at 500 mg PO/IV BID; then increase dosage by 500 '
              'mg/dose BID every 2 wk as tolerated to reach the target dosage of 1500 mg '
              'BID.'),
        ],
      ),
      DoseSection(
        heading: 'Tonic-clonic seizure (primary generalized, adjunctive therapy; use '
            'immediate-release dosage forms and IV):',
        lines: [
          DoseLine('Child 6–15 yr: Start at 10 mg/kg/dose PO/IV BID; increase by 10 '
              'mg/kg/dose BID every 2 wk as tolerated to reach the target dosage of 30 '
              'mg/kg/dose BID.'),
          DoseLine(
            'Alternative fixed dosing with oral disintegrating tabs (see remarks):',
            isHeading: true,
          ),
          DoseLine('20–40 kg: Start at 250 mg PO BID; increase by 250 mg BID every 2 wk as '
              'tolerated up to a maximum of 750 mg BID.'),
          DoseLine('>40 kg: Start at 500 mg PO BID; increase by 500 mg BID every 2 wk as '
              'tolerated up to a maximum of 1500 mg BID.'),
          DoseLine('16 yr–adult: Start at 500 mg PO/IV BID; then increase dosage by 500 '
              'mg/dose BID every 2 wk as tolerated to reach the target dosage of 1500 mg '
              'BID.'),
        ],
      ),
      DoseSection(
        heading: 'Refractory status epilepticus (limited data):',
        lines: [
          DoseLine('Infant, child, and adolescent: 60 mg/kg (max. dose: 4500 mg/dose) IV/IO '
              'over 10 min × 1, then start maintenance therapy based on clinical '
              'response and seizure type'),
        ],
      ),
    ],
    remarks: [
      'Do not abruptly withdraw therapy, to reduce risk for seizures. Use with '
          'caution in renal impairment (reduce dose; see Chapter 32), hemodialysis, '
          'and neuropsychiatric conditions.',
      'May cause loss of appetite, vomiting, dizziness, headaches, somnolence, '
          'agitation, depression, and mood swings. Drowsiness, fatigue, nervousness, '
          'and aggressive behavior have been reported in children. Nonpsychotic '
          'behavioral symptoms reported in children are approximately 3 times '
          'greater than in adults (37.6% vs. 13.3%). Suicidal behavior or ideation, '
          'serious dermatologic reactions (e.g., Stevens-Johnson and TEN), '
          'multiorgan hypersensitivity (DRESS), hematologic abnormalities (e.g., '
          'anemia, leukopenia), reversible alopecia, hyponatremia, hypertension, and '
          'worsening of seizures have been reported. Levetiracetam may decrease '
          'carbamazepine’s effects. Ginkgo may decrease levetiracetam’s effects.',
      'Drug has excellent PO absorption. Use IV dosages similar to '
          'immediate-release PO dosages only when the oral route of administration '
          'is not feasible. Extended-release tablet is designed for once-daily '
          'administration at daily dosage similar to the immediate-release forms '
          '(e.g., 1000 mg once daily of the extended-release tablet is equivalent to '
          '500 mg BID of the immediate-release tablet). Disintegrating tabs '
          '(Spritam) may be administered by allowing the tablet to disintegrate in '
          'the mouth when taken with a sip of liquid or made into a suspension (see '
          'package insert); do not swallow this dosage form whole. Spritam is not '
          'recommended for patients ≤20 kg.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1073–1074',
  ),
  // LEVOCARNITINE — PDF p. 265 (printed 1074)  [cross-reference]
  DrugEntryV3(
    name: 'LEVOCARNITINE',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Carnitine.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1074',
  ),
  // LEVOFLOXACIN — PDF p. 265–266 (printed 1074–1075)
  DrugEntryV3(
    name: 'LEVOFLOXACIN',
    brandNames: 'Generics; previously available as Levaquin',
    drugClass: 'Antibiotic, quinolone',
    iconRow: '',
    formulations: [
      'Tabs: 250, 500, 750 mg',
      'Oral solution: 25 mg/mL (100, 200, 480 mL)',
      'Injection: 25 mg/mL (20 mL)',
      'Premixed injection in D₅W: 250 mg/50 mL, 500 mg/100 mL, 750 mg/150 mL',
      'Ophthalmic drops (generic): 1.5% (5 mL); preservative-free',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child:',
        lines: [
          DoseLine(
            'General dosing:',
            isHeading: true,
          ),
          DoseLine('6 mo–<5 yr: 10 mg/kg/dose IV/PO Q12 hr; max. dose: 500 mg/24 hr'),
          DoseLine('≥5 yr: 10 mg/kg/dose IV/PO Q24 hr; max. dose: 750 mg/24 hr'),
          DoseLine('Recurrent or persistent acute otitis media (6 mo–<5 yr): 10 mg/kg/dose PO '
              'Q12 hr × 10 days; max. dose: 500 mg/24 hr'),
          DoseLine(
            'Community-acquired pneumonia (IDSA/Pediatric Infectious Disease Society):',
            isHeading: true,
          ),
          DoseLine('6 mo–<5 yr: 8–10 mg/kg/dose PO/IV Q12 hr; max. dose: 750 mg/24 hr'),
          DoseLine('5–<18 yr: 8–10 mg/kg/dose PO/IV Q24 hr; max. dose: 750 mg/24 hr'),
          DoseLine(
            'Inhalational anthrax (postexposure) and plague:',
            isHeading: true,
          ),
          DoseLine('≥6 mo and <50 kg: 8 mg/kg/dose PO/IV Q12 hr; max. dose: 500 mg/24 hr'),
          DoseLine('>50 kg: 500 mg PO/IV once daily'),
          DoseLine(
            'Duration of therapy:',
            isHeading: true,
          ),
          DoseLine('Inhalational anthrax (postexposure): 60 days'),
          DoseLine('Plague: 10–14 days'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Community-acquired pneumonia: 750 mg PO/IV Q24 hr × 5 days'),
          DoseLine('Complicated UTI/acute pyelonephritis: 750 mg PO/IV Q24 hr × 5–7 days'),
          DoseLine('Acute bacterial sinusitis: 500 mg PO/IV Q24 hr × 10–14 days; OR 750 mg '
              'PO/IV Q24 hr × 5 days'),
          DoseLine('Inhalational anthrax (postexposure): 500 mg PO/IV Q24 hr × 60 days'),
          DoseLine('Plague: 750 mg PO/IV Q24 hr × 7–14 days'),
        ],
      ),
      DoseSection(
        heading: 'Corneal ulcer cause by susceptible bacteria strains:',
        lines: [
          DoseLine('≥6 yr and adult: Instill 1–2 drops of the 1.5% solution to affected '
              'eye(s) Q30 min to 2 hr while awake and approximately 4 and 6 hr after '
              'retiring for the first 3 days, then Q1–4 hr while awake'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in hypersensitivity to other quinolones. Avoid in '
          'patients with history of Q–Tc prolongation or taking Q–Tc prolonging '
          'drugs, and excessive sunlight exposure. Use with caution in diabetes, '
          'seizures, myasthenia gravis, children <18 yr, and renal impairment '
          '(adjust dose, see Chapter 32). May cause GI disturbances, headache, and '
          'blurred vision with the ophthalmic solution. Musculoskeletal disorders '
          '(e.g., arthralgia, arthritis, tendinopathy, and gait abnormality) may '
          'occur. Peripheral neuropathy and uveitis have been reported. Safety in '
          'pediatric patients treated more than 14 days has not been evaluated. Like '
          'other quinolones, tendon rupture can occur during or after therapy (risk '
          'increases with concurrent corticosteroids). Psychiatric adverse events, '
          'increased intracranial pressure, seizures, and blood glucose disturbances '
          'have been reported. Use with NSAIDs may increase risk of CNS stimulation '
          'and seizures.',
      'Infuse IV over 1–1.5 hr; avoid IV push or rapid infusion because of risk '
          'of hypotension. Do not administer antacids or other divalent salts (e.g., '
          'enteral formula) 1 hr prior or 2 hr after the oral levofloxacin dose; '
          'otherwise may be administered with or without food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1074–1075',
  ),
  // LEVOTHYROXINE (T₄) — PDF p. 266–267 (printed 1075–1076)
  DrugEntryV3(
    name: 'LEVOTHYROXINE (T₄)',
    brandNames: 'Synthroid, Euthyrox, Ermeza, Levoxyl, Tirosint, Thyquidity, '
        'Tirosint-Sol, Unithroid, and generics',
    drugClass: 'Thyroid product',
    iconRow: '',
    formulations: [
      'Tabs: 25, 50, 75, 88, 100, 112, 125, 137, 150, 175, 200, 300 mCg',
      'Caps:',
      'Tirosint : 13, 25, 37.5, 44, 50, 62.5, 75, 88, 100, 112, 125, 137, 150, '
          '175, 200 mCg',
      'Generics: 13, 25, 50, 75, 88, 100, 112, 125, 137, 150, 175, 200 mCg',
      'Injection: 100, 200, 500 mCg; preservative free',
      'Oral solution:',
      'Ermeza: 150 mCg/5 mL (75, 150 mL); contains EDTA',
      'Thyquidity: 100 mCg/5 mL (100 mL); contains parabens',
      'Tirosint-Sol: 13, 25, 37.5, 44, 50, 62.5, 75, 88, 100, 112, 125, 137, '
          '150, 175, 200 mCg/1 mL (30 ampules per box)',
      'Oral suspension: 25 mCg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hypothyroidism:',
        lines: [
          DoseLine(
            'Child PO dosing (see remarks):',
            isHeading: true,
          ),
          DoseLine('1–3 mo: 10–15 mCg/kg/dose once daily. If patient is at risk for '
              'developing cardiac failure, start with lower dose of 25 mCg/24 hr; and if '
              'patient has very low T₄ (<5 mCg/dL), use higher 12–17 mCg/kg/24 hr dose.'),
          DoseLine('>3–6 mo: 8–10 mCg/kg/dose once daily'),
          DoseLine('>6–12 mo: 6–8 mCg/kg/dose once daily'),
          DoseLine('1–5 yr: 5–6 mCg/kg/dose once daily'),
          DoseLine('6–12 yr: 4–5 mCg/kg/dose once daily'),
          DoseLine(
            '>12 yr:',
            isHeading: true,
          ),
          DoseLine('Incomplete growth and prepuberty: 2–3 mCg/kg/dose once daily'),
          DoseLine('Complete growth and puberty: 1.7 mCg/kg/dose once daily'),
          DoseLine('Child IM/IV dose: 50%–75% of oral dose once daily'),
          DoseLine(
            'Adult:',
            isHeading: true,
          ),
          DoseLine('PO: Start with 12.5–25 mCg/dose once daily. Increase by 12.5–25 mCg/24 hr '
              'at intervals of Q2–4 wk until euthyroid. Usual adult dose: 100–200 mCg/24 '
              'hr'),
          DoseLine('IM/IV dose: 50% of oral dose once daily'),
        ],
      ),
      DoseSection(
        heading: 'Myxedema coma or stupor:',
        lines: [
          DoseLine('Adult: 300–500 mCg IV × 1, then 50–100 mCg IV once daily; convert to oral '
              'therapy once patient is stabilized'),
        ],
      ),
    ],
    remarks: [
      'Contraindications include acute MI, thyrotoxicosis, and uncorrected '
          'adrenal insufficiency. May cause hyperthyroidism, rash, growth '
          'disturbances, hypertension, worsening of diabetic control, decreased bone '
          'mineral density (primarily in postmenopausal females), arrhythmias, '
          'diarrhea, and weight loss. Pseudotumor cerebri and slipped capital '
          'femoral epiphysis have been reported in children. Overtreatment may cause '
          'craniosynostosis in infants and premature closure of the epiphyses in '
          'infants who have not undergone complete closure of the fontanelles.',
      'Total replacement dose may be used in children unless there is evidence '
          'of cardiac disease; in that case, begin with one-fourth of maintenance '
          'and increase weekly. Titrate dosage with clinical status and serum T₄ and '
          'TSH.',
      'Increases the effects of warfarin. Phenytoin, rifampin, carbamazepine, '
          'iron and calcium supplements, antacids, grapefruit juice, and orlistat '
          'may decrease levothyroxine levels. Tricyclic antidepressants and SSRIs '
          'may enhance toxic effects. Use with ketamine may cause hypertension and '
          'tachycardia. High doses of propranolol or dexamethasone, and amiodarone '
          'may decrease the conversion of T₄ to T₃. Biotin and biotin-containing '
          'supplements are known to interfere with thyroid hormone immunoassays '
          '(discontinue biotin and biotin-containing supplements at least 2 days '
          'prior to testing).',
      '100 mCg levothyroxine = 65 mg thyroid USP. Administer oral doses on an '
          'empty stomach and tablets with a full glass of water. Iron and calcium '
          'supplements and antacids may decrease absorption; do not administer '
          'within 4 hr of these agents. Excreted in low levels in breast milk; '
          'preponderance of evidence suggests no clinically significant effect in '
          'infants.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1075–1076',
  ),
  // LIDOCAINE — PDF p. 268–269 (printed 1077–1078)
  DrugEntryV3(
    name: 'LIDOCAINE',
    brandNames: 'Xylocaine, L-M-X, Lidoderm, many different brands of topical '
        'products, and generics',
    drugClass: 'Antiarrhythmic class Ib, local anesthetic',
    iconRow: '',
    formulations: [
      'Injection: 0.5%, 1%, 1.5%, 2%, 4% (1% sol = 10 mg/mL); some products may '
          'be preservative free',
      'IV infusion (in D₅W): 0.4% (4 mg/mL) (250, 500 mL); 0.8% (8 mg/mL) (250 '
          'mL)',
      'Injection with epinephrine (some preparations may contain metasulfite and '
          'parabens or are preservative free):',
      'Injection with 1:100,000 epinephrine: 1%, 2% lidocaine',
      'Injection with 1:200,000 epinephrine: 0.5%, 1%, 1.5%, 2% lidocaine',
      'Ointment: 4% (50, 100 g), 5% (30, 50 g)',
      'Cream, topical: 3% (30, 85 g), 4% (L-M-X-4 and generics) [OTC] (5, 15, 30 '
          'g), 5% (L-M-X-5 and generics) [OTC] (15, 30 g); may contain benzyl alcohol',
      'Cream, rectal: 5% (L-M-X-5 and others; 15, 30 g); contains benzyl alcohol',
      'Gel (external): 2% (3.5, 30 g), 3% (10, 30, 90 mL), 4% (30, 75, 90 mL), '
          '5% (85 g); may contain benzyl alcohol, EDTA',
      'Lotion: 3% (177 mL), 4% (88 mL)',
      'Solution (external): 4% (50 mL); may contain parabens',
      'Aerosol spray (external): 4% (104 mL)',
      'Transdermal patch:',
      'Lidocaine pain relief and generics [OTC]: 4% (5s, 10s); may contain '
          'menthol, capsaicin, and methyl salicylate',
      'Lidoderm and generics: 5% (1s, 15s, 30s)',
      'Oral solution (mouth/throat): 2% (15, 100 mL), 4% (4 mL)',
      'Topical cream or gel 2.5% with 2.5% prilocaine: See Lidocaine and '
          'Prilocaine.',
    ],
    doseSections: [
      DoseSection(
        heading: 'Anesthetic:',
        lines: [
          DoseLine('Injection (local): Use <2% concentration. Dosage varies with procedure, '
              'degree and duration of analgesia, tissue vascularity, and patient '
              'condition.'),
          DoseLine('Without epinephrine: max. dose of 4.5 mg/kg/dose (up to 300 mg); do not '
              'repeat within 2 hr.'),
          DoseLine('With epinephrine: max. dose of 7 mg/kg/dose (up to 500 mg); do not repeat '
              'within 2 hr.'),
          DoseLine(
            'Topical:',
            isHeading: true,
          ),
          DoseLine('Cream (child ≥2 yr and adult): Apply to affected intact skin areas '
              'BID–QID; max. dose: 4.5 mg/kg/dose up to 300 mg/dose'),
          DoseLine('Gel, lotion, or ointment (child ≥2 yr and adult): Apply to affected '
              'intact skin areas once daily–QID (BID–TID for lotion); max. dose: 4.5 '
              'mg/kg/dose up to 300 mg/dose'),
          DoseLine(
            'Patch:',
            isHeading: true,
          ),
          DoseLine('4% (≥12 yr and adult): Apply patch to painful area and leave in place for '
              'up to 12 hr; max. dose: one patch/24 hr'),
          DoseLine('5% (adult): Apply to most painful area with up to 3 patches at a time. '
              'Patch(es) may be left in place for up to 12 hr in any 24-hr period.'),
        ],
      ),
      DoseSection(
        heading: 'Antiarrhythmic (infant, child, adolescent):',
        lines: [
          DoseLine('Bolus: 1 mg/kg/dose (max. dose: 100 mg) slowly IV; may repeat in 10–15 '
              'min × 2; max. total dose: 3–5 mg/kg within the first hr. ETT dose = 2–3 × '
              'IV dose.'),
          DoseLine('Continuous infusion: 20–50 mCg/kg/min IV/IO (do not exceed 20 mCg/kg/min '
              'for patients with shock, CHF, hepatic disease, or cardiac arrest); see '
              'inside cover for infusion preparation. Administer a 1-mg/kg bolus when '
              'infusion is initiated if bolus has not been given within previous 15 min.'),
        ],
      ),
      DoseSection(
        heading: 'Oral use (2% viscous liquid):',
        lines: [
          DoseLine('Child (≥3 yr): Up to the lesser of 4.5 mg/kg/dose or 300 mg/dose; swish '
              'and spit Q3 hr PRN up to a max. dose of 4 doses per 12-hr period'),
          DoseLine('Adult: 15 mL; swish and spit Q3 hr PRN up to a max. dose 4.5 mg/kg/dose '
              'or 300 mg/dose up to 8 doses/24 hr'),
        ],
      ),
    ],
    remarks: [
      'For cardiac arrest, amiodarone is the preferred agent over lidocaine; '
          'lidocaine may be used only when amiodarone is not available.',
      'Contraindicated in Stokes-Adams or Wolff-Parkinson-White syndromes and '
          'SA, AV, or intraventricular heart block without a pacemaker. Solutions '
          'containing dextrose may be contraindicated in patients with known allergy '
          'to corn or corn products. Side effects include hypotension, asystole, '
          'seizures, and respiratory arrest. Anaphylactic reactions have been '
          'reported. Local anesthetic use has been associated with methemoglobinemia.',
      'Cytochrome P-450 2D6 and 3A3/3A4 substrate. Use with caution in severe '
          'liver or renal disease. Decrease dose in hepatic failure or decreased '
          'cardiac output. Do not use topically for teething. Prolonged infusion may '
          'result in toxic accumulation of lidocaine, especially in infants. Do not '
          'use epinephrine-containing solutions for treatment of arrhythmias.',
      'Therapeutic levels 1.5–5 mg/L. Toxicity occurs at >7 mg/L. Toxicity in '
          'neonates may occur at >5 mg/L due to reduced protein binding of drug. '
          'Elimination T₁/₂: premature infant: 3.2 hr; adult: 1.5–2 hr.',
      'When using the topical patch, avoid exposing the application site to '
          'external heat sources as this may increase the risk for toxicity.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1077–1078',
  ),
  // LIDOCAINE AND PRILOCAINE — PDF p. 269–270 (printed 1078–1079)
  DrugEntryV3(
    name: 'LIDOCAINE AND PRILOCAINE',
    brandNames: 'Many brand names, Oraqix, Eutectic mixture of lidocaine and '
        'prilocaine; previously available as EMLA',
    drugClass: 'Topical analgesic',
    iconRow: '',
    formulations: [
      'Cream: Lidocaine 2.5% + prilocaine 2.5% (5, 30 g)',
      'Periodontal gel (Oraqix): Lidocaine 2.5% + prilocaine 2.5% (1.7 g in '
          'dental cartridges; 20s)',
    ],
    doseSections: [
      DoseSection(
        heading: '',
        lines: [
          DoseLine('See Chapter 6 for general use information.'),
        ],
      ),
      DoseSection(
        heading: 'Neonate:',
        lines: [
          DoseLine(
            '<37 wk gestation (limited data):',
            isHeading: true,
          ),
          DoseLine('Painful procedures (e.g., IM injections): 0.5 g/site for 60 min'),
          DoseLine(
            '≥37 wk gestation and <5 kg:',
            isHeading: true,
          ),
          DoseLine('Painful procedures (e.g., IM injections): 1 g/site for 60 min. Max. dose: '
              '1 g for all sites combined with a max. application area of 10 cm² and '
              'max. application time of 1 hr.'),
          DoseLine('Circumcision: 1–2 g and cover with occlusive dressing for 60–90 min.'),
        ],
      ),
      DoseSection(
        heading: 'Infant and child:',
        lines: [
          DoseLine('Painful procedures (e.g., IM injections): 1–2 g/site following the '
              'recommended maximum doses based on the child’s age and weight:'),
        ],
        table: DoseTable(
          headers: ['Age and Weight', 'Maximum Total EMLA Dose (g)ᵇ', 'Maximum Application Area (cm²)', 'Maximum Application Time (hr)'],
          rows: [
            DoseTableRow(['Birth–<3 mo or <5 kg', '1', '10', '1']),
            DoseTableRow(['3–12 mo and >5–10 kgᵃ', '2', '20', '4']),
            DoseTableRow(['1–6 yr and >10 kg', '10', '100', '4']),
            DoseTableRow(['7–12 yr and >20 kg', '20', '200', '4']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃIf patient is >3 mo and is not >5 kg, use the maximum total dose that '
              'corresponds to the patient’s weight.'),
          DoseLine('ᵇFor all sites combined.'),
          DoseLine('EMLA, Eutectic mixture of local anesthetics.'),
        ],
      ),
      DoseSection(
        heading: 'Adolescent and adult:',
        lines: [
          DoseLine('Minor procedures: 2.5 g/site over 20–25 cm² of skin for at least 60 min'),
          DoseLine('Painful procedures: 2 g/10 cm² of skin for at least 2 hr'),
        ],
      ),
    ],
    remarks: [
      'Should not be used in neonates <37 wk of gestation or in infants <12 mo '
          'old receiving treatment with methemoglobin-inducing agents (e.g., sulfa '
          'drugs, acetaminophen, nitrofurantoin, nitroglycerin, nitroprusside, '
          'phenobarbital, phenytoin). Use with caution in patients with G6PD '
          'deficiency, patients treated with class I or III antiarrhythmic drugs '
          '(additive or toxic cardiac effects), and patients with renal and hepatic '
          'impairment. Prilocaine has been associated with methemoglobinemia. Long '
          'duration of application, large treatment area, small patients, or '
          'impaired elimination may result in high blood levels.',
      'Apply topically to intact skin and cover with occlusive dressing; avoid '
          'mucous membranes or the eyes. Wipe cream off before procedure.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1078–1079',
  ),
  // LINEZOLID — PDF p. 270–271 (printed 1079–1080)
  DrugEntryV3(
    name: 'LINEZOLID',
    brandNames: 'Zyvox and generics',
    drugClass: 'Antibiotic, oxazolidinone',
    iconRow: '',
    formulations: [
      'Tabs: 600 mg; contains ~0.45 mEq Na per 200 mg drug',
      'Oral suspension: 100 mg/5 mL (150 mL); contains phenylalanine and sodium '
          'benzoate and 0.8 mEq Na per 200 mg drug',
      'Injection, premixed: 200 mg in 100 mL, 600 mg in 300 mL; contains 1.7 mEq '
          'Na per 200 mg drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'Neonate:',
        lines: [
          DoseLine(
            '<1 kg:',
            isHeading: true,
          ),
          DoseLine('<14 days old: 10 mg/kg/dose IV Q12 hr'),
          DoseLine('≥14 days old: 10 mg/kg/dose IV Q8 hr'),
          DoseLine(
            '≥1–2 kg:',
            isHeading: true,
          ),
          DoseLine('<7 days old: 10 mg/kg/dose IV/PO Q12 hr'),
          DoseLine('≥7–28 days old: 10 mg/kg/dose IV/PO Q8 hr'),
          DoseLine('>2 kg: 10 mg/kg/dose IV/PO Q8 hr'),
          DoseLine(
            'Alternate dosing by gestational age:',
            isHeading: true,
          ),
          DoseLine(
            '<34 wk gestation:',
            isHeading: true,
          ),
          DoseLine('<7 days old: 10 mg/kg/dose IV/PO Q12 hr'),
          DoseLine('≥7–28 days old: 10 mg/kg/dose IV/PO Q8 hr'),
          DoseLine('≥34 wk gestation and 0–28 days old: 10 mg/kg/dose IV/PO Q8 hr'),
        ],
      ),
      DoseSection(
        heading: 'Infant and child <12 yr old:',
        lines: [
          DoseLine('Pneumonia, bacteremia, bone/joint infections, septic thrombosis (MRSA), '
              'complicated skin/skin structure infections, vancomycin-resistant '
              'Enterococcus faecium (VRE) infections (including endocarditis): 10 '
              'mg/kg/dose IV/PO Q8 hr'),
          DoseLine(
            'Uncomplicated skin/skin structure infections:',
            isHeading: true,
          ),
          DoseLine('<5 yr: 10 mg/kg/dose IV/PO Q8 hr'),
          DoseLine('5–11 yr: 10 mg/kg/dose IV/PO Q12 hr'),
          DoseLine('Max. dose for all indications <12 yr: 600 mg/dose'),
        ],
      ),
      DoseSection(
        heading: '≥12 yr and adult:',
        lines: [
          DoseLine('600 mg IV/PO Q12 hr; 400 mg IV/PO Q12 hr may be used for adults with '
              'uncomplicated infection.'),
        ],
      ),
    ],
    remarks: [
      'Most common side effects include diarrhea, headache, and nausea. Anemia, '
          'leukopenia, pancytopenia, and thrombocytopenia may occur in patients who '
          'are at risk for myelosuppression and who receive regimens >2 wk. Complete '
          'blood count monitoring is recommended in these individuals. '
          'Pseudomembranous colitis, neuropathy (peripheral and optic), '
          'rhabdomyolysis, hyponatremia, hypoglycemia, and severe cutaneous adverse '
          'reactions (e.g., TEN and SJS) have also been reported. CSF penetration is '
          'variable in patients with VP shunts.',
      'Do not use with SSRIs (e.g., fluoxetine, paroxetine), tricyclic '
          'antidepressants, venlafaxine, and trazodone; may cause serotonin '
          'syndrome. Avoid use with monoamine oxidase inhibitors (e. g., '
          'phenelzine); and in patients with uncontrolled hypertension, '
          'pheochromocytoma, or thyrotoxicosis, and taking sympathomimetics or '
          'vasopressive agents (may elevate blood pressure). Use caution when '
          'consuming large amounts of foods and beverages containing tyramine; may '
          'increase blood pressure. Use in severe hepatic impairment (e.g., '
          'cirrhosis) or kidney impairment may increase risk for thrombocytopenia.',
      'Protect all dosage forms from light and moisture. Oral suspension product '
          'must be gently mixed by inverting the bottle 3–5 times prior to each use '
          '(do not shake). All oral doses may be administered with or without food.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1079–1080',
  ),
  // LIRAGLUTIDE — PDF p. 271–272 (printed 1080–1081)
  DrugEntryV3(
    name: 'LIRAGLUTIDE',
    brandNames: 'Saxenda, Victoza, and generics',
    drugClass: 'Antidiabetic agent, glucagon-like peptide-1 (GLP-1) receptor agonist',
    iconRow: '',
    formulations: [
      'Subcutaneous pen-injector: 18 mg/3 mL (3 mL); contains phenol, propylene '
          'glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'Type 2 diabetes mellitus (adjunctive therapy with diet and exercise)',
        lines: [
          DoseLine(':'),
          DoseLine('Victoza (child ≥10 yr and adolescent): Start with 0.6 mg SC once daily × '
              '1 wk, if needed, increase by 0.6-mg increments on a weekly basis PRN up '
              'to a maximum dose of 1.8 mg/24 hr. In clinical trials, metformin was also '
              'prescribed with some receiving insulin (those receiving insulin had their '
              'insulin dose reduced by ~20%).'),
        ],
      ),
      DoseSection(
        heading: 'Chronic weight management (adjunctive therapy with diet and exercise):',
        lines: [
          DoseLine('Saxenda (child ≥12 yr and adolescent): Start with 0.6 mg SC once daily × '
              '1 wk, then increase dose by 0.6 mg/24 hr at weekly increments up to the '
              'target dose of 3 mg once daily. If unable to tolerate 3 mg once daily, '
              'may reduce dose to 2.4 mg once daily (discontinue use if 2.4 mg dose is '
              'not tolerated). Pediatric patients who are unable to tolerate the dose '
              'escalation may use the lower dose, and the targeted escalation could take '
              'up to 8 wk. Discontinue therapy if the patient has a <1% reduction in BMI '
              'after 12 wk of therapy.'),
        ],
      ),
    ],
    remarks: [
      'A bioengineered analog of human GLP-1 in Saccharomyces cerevisiae and '
          'acts as a GLP-1 receptor agonist. Contraindicated in patients with a '
          'family history of medullary thyroid carcinoma and in patients with '
          'multiple endocrine neoplasia syndrome type 2.',
      'Common side effects include hypoglycemia, constipation, diarrhea, nausea, '
          'vomiting, indigestion, and headache. Pancreatitis, '
          'cholelithiasis/cholecystitis, hypersensitivity reactions (e.g., '
          'anaphylaxis and angioedema), and acute renal failure have been reported. '
          'Use with caution with other medications that could cause hypoglycemia '
          '(e.g., sulfonylurea, insulin, fluoroquinolones, beta-blockers, and '
          'SSRIs). Due to its effects on delaying gastric emptying, rare reports of '
          'pulmonary aspiration have been experienced in patients receiving general '
          'anesthesia or deep sedation for surgeries or procedures.',
      'Doses are injected subcutaneously in the abdomen, thigh, or upper arm any '
          'time of the day without regard to meals. Each new prefilled pen requires '
          'priming before the first injection. Use a new needle for each dose '
          'administration. Do not share pens between patients despite changing '
          'needles. Do not mix with insulin and do not administer adjacent to '
          'insulin. If a dose is missed more than 3 days, reinitiate the dosage '
          'titration at 0.6 mg/24 hr. Never administer extra or doubled doses.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1080–1081',
  ),
  // LISDEXAMFETAMINE — PDF p. 272–273 (printed 1081–1082)
  DrugEntryV3(
    name: 'LISDEXAMFETAMINE',
    brandNames: 'Vyvanse and generics',
    drugClass: 'CNS stimulant',
    iconRow: '',
    formulations: [
      'Capsules: 10, 20, 30, 40, 50, 60, 70 mg',
      'Chewable tabs: 10, 20, 30, 40, 50, 60 mg; contains mannitol and sucralose',
    ],
    doseSections: [
      DoseSection(
        heading: 'Attention-deficit/hyperactivity disorder:',
        lines: [
          DoseLine('Child ≥6 yr and adult: Start with 20–30 mg PO QAM (adult, start at 30 '
              'mg). May increase dose by 10–20 mg/24 hr at weekly intervals if needed, '
              'up to a max. dose of 70 mg/24 hr. Lower maximum dosages for renal '
              'insufficiency include the following:'),
          DoseLine('GFR ≥30 mL/min/1.73 m²: 70 mg/24 hr'),
          DoseLine('GFR 15–<30 mL/min/1.73 m²: 50 mg/24 hr'),
          DoseLine('GFR <15 mL/min/1.73 m² or ESRD on hemodialysis: 30 mg/24 hr'),
        ],
      ),
      DoseSection(
        heading: 'Binge eating disorder (moderate to severe):',
        lines: [
          DoseLine('Adult: Start with 30 mg PO once daily. Increase in increments of 20 mg at '
              'weekly intervals to achieve the recommended dosage of 50–70 mg PO once '
              'daily; max. dose: 70 mg/24 hr; discontinue use if no improvement.'),
        ],
      ),
    ],
    remarks: [
      'Lisdexamfetamine is a prodrug of dextroamphetamine that requires '
          'activation by intestinal/hepatic metabolism.',
      'Contraindicated in amphetamine or sympathomimetic hypersensitivity, '
          'symptomatic cardiovascular disease, moderate/severe hypertension, '
          'hyperthyroidism, glaucoma, agitated states, drug/alcohol abuse history, '
          'and MAO inhibitors (concurrent or use within 14 days). As with other CNS '
          'simulant medications, serious cardiovascular events, including death, '
          'have been reported in patients with preexisting structural cardiac '
          'abnormalities or other serious heart problems. Use with caution in '
          'patients with hypertension, psychiatric conditions, and epilepsy. May '
          'cause insomnia, irritability, motor/verbal tics, worsening of Tourette '
          'syndrome, rash, appetite suppression/weight loss, growth suppression, '
          'dizziness, xerostomia, and GI disturbances. Dermatillomania, bruxism, '
          'intestinal ischemia, Stevens-Johnson syndrome, and TEN have been reported.',
      'Urinary acidifying agents may reduce levels of amphetamines, and urinary '
          'alkalinizing agents may increase levels. May increase the effects of '
          'TCAs; increase or decrease the effects of guanfacine and phenytoin, and '
          'phenobarbital; and decrease the effects of adrenergic blockers, '
          'antihistamines, and antihypertensives. Norepinephrine may increase the '
          'effects of amphetamines.',
      'Chewable tablets must be completely chewed before swallowing. Chewable '
          'tablet and capsule dosage forms can be converted on an equal mg-per-mg '
          'basis.',
      'See Dextroamphetamine ± Amphetamine for additional remarks.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1081–1082',
  ),
  // LISINOPRIL — PDF p. 273–274 (printed 1082–1083)
  DrugEntryV3(
    name: 'LISINOPRIL',
    brandNames: 'Qbrelis, Zestril, and generics; previously available as Prinivil',
    drugClass: 'Angiotensin-converting enzyme inhibitor, antihypertensive',
    iconRow: '',
    formulations: [
      'Tabs: 2.5, 5, 10, 20, 30, 40 mg',
      'Oral solution (Qbrelis): 1 mg/mL (150 mL); contains sodium benzoate',
      'Oral suspension: 1 mg/mL',
      'Oral syrup: 2 mg/mL',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hypertension (see remarks):',
        lines: [
          DoseLine('Child (<6 yr; limited data): Use 6–17 yr dosing below.'),
          DoseLine('6–17 yr: Start with 0.07–0.1 mg/kg/dose PO once daily; max. initial dose: '
              '5 mg/dose. If needed, titrate dose upward at 1–2 wk intervals to doses up '
              'to 0.61 mg/kg/24 hr or 40 mg/24 hr (higher doses have not been evaluated).'),
          DoseLine('Adult: Start with 10 mg PO once daily (use 5 mg if using a diuretic). If '
              'needed, increase dose by 5–10 mg/24 hr at 1–2 wk intervals. Usual dosage '
              'range: 20–40 mg/24 hr; max. dose: 80 mg/24 hr.'),
        ],
      ),
    ],
    remarks: [
      'Use lower initial dose (50% of recommended dose) if using with a diuretic '
          'or in the presence of hyponatremia, hypovolemia, severe CHF, or decreased '
          'renal function.',
      'Contraindicated in hypersensitivity and history of angioedema with other '
          'ACE inhibitors and in combination with a neprilysin inhibitor (e.g., '
          'sacubitril). Do not use with aliskiren in patients with diabetes. Avoid '
          'use with dialysis with high-flux membranes because anaphylactoid '
          'reactions have been reported. Use with caution in aortic or bilateral '
          'renal artery stenosis and hepatic impairment. Side effects include cough, '
          'dizziness, headache, hyperkalemia, hypotension (especially with '
          'concurrent diuretic or antihypertensive agent use), rash, and GI '
          'disturbances. Mood alterations, including depressive symptoms, have been '
          'reported.',
      'Dual blockade of the renin–angiotensin system with lisinopril and '
          'angiotensin receptor antagonists (e.g., losartin) or aliskiren is '
          'associated with increased risk for hypotension, syncope, hyperkalemia, '
          'and renal impairment. Diabetic patients on lisinopril treated with oral '
          'antidiabetic agents should be monitored for hypoglycemia, especially '
          'during the first month of use. NSAIDs (e.g., indomethacin) may decrease '
          'linsinopril’s effects. Use with mTOR inhibitors (e.g., sirolimus, '
          'everolimus) may increase risk for angioedema. Adjust dose in renal '
          'impairment (see Chapter 32).',
      'Onset of action: 1 hr with maximal effect in 6–8 hr. Long-term blood '
          'pressure monitoring is recommended at Q2–4 wk until good control is '
          'achieved, followed by Q3–4 mo.',
      'Additional indications with limited data in children include proteinuria '
          'associated with mild IgA nephropathy, and renal protection for diabetes '
          'or renal parenchymal disease.',
      'Lisinopril should be discontinued as soon as possible when pregnancy is '
          'detected as it can cause fetal harm, especially when used during the '
          'second and third trimesters.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1082–1083',
  ),
  // LITHIUM — PDF p. 274 (printed 1083)
  DrugEntryV3(
    name: 'LITHIUM',
    brandNames: 'Lithobid and many generics; previously available as Eskalith',
    drugClass: 'Antimanic agent',
    iconRow: '',
    formulations: [
      'Carbonate salt:',
      '300 mg carbonate = 8.12 mEq lithium',
      'Caps: 150, 300, 600 mg',
      'Tabs: 300 mg',
      'Extended-release tabs: 300 mg (Lithobid and generics), 450 mg',
      'Citrate salt:',
      'Syrup: 8 mEq/5 mL (500 mL); 5 mL is equivalent to 300 mg lithium carbonate',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child (see remarks):',
        lines: [
          DoseLine('Initial (immediate-release dosage forms): 15–60 mg/kg/24 hr PO ÷ TID–QID. '
              'Adjust as needed (weekly) to achieve therapeutic levels.'),
        ],
      ),
      DoseSection(
        heading: 'Adolescent:',
        lines: [
          DoseLine('600–1800 mg/24 hr PO ÷ TID–QID (divided BID–TID using extended-release '
              'tablets)'),
        ],
      ),
      DoseSection(
        heading: 'Adult:',
        lines: [
          DoseLine('Initial: 300 mg PO TID. Adjust as needed to achieve therapeutic levels. '
              'Usual dose is about 300 mg TID–QID with immediate-release dosage form. '
              'For extended-release tablets, 900–1800 mg/24 hr PO ÷ BID–TID'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in severe cardiovascular disease (including Brugada '
          'syndrome) or renal disease. Decreased sodium intake, increased sodium '
          'wasting, or significant renal or cardiovascular disease may increase '
          'lithium levels, resulting in toxicity. May cause goiter, nephrogenic '
          'diabetes insipidus, hypothyroidism, arrhythmias, or sedation at '
          'therapeutic doses. Nephrotic syndrome and dermatologic reactions (e.g., '
          'alopecia, acne, psoriasis, and DRESS) have been reported.',
      'Coadministration with diuretics, metronidazole, ACE inhibitors, '
          'angiotensin receptor antagonists (e.g., losartan), or NSAIDs may increase '
          'risk for lithium toxicity. Use with iodine may increase risk for '
          'hypothyroidism. If used in combination with haloperidol, closely monitor '
          'neurologic toxicities because an encephalopathic syndrome followed by '
          'irreversible brain damage has been reported.',
      'Safety and efficacy for monotherapy for acute mania or mixed episodes of '
          'bipolar I disorder and maintenance monotherapy of bipolar I disorder in '
          'children 7–17 yr have been established from a clinical trial. Common '
          'adverse effects observed in this study included nausea/vomiting, '
          'polyuria, thyroid abnormalities, tremor, polydipsia, dizziness, '
          'rash/dermatitis, ataxia/gait disturbance, anorexia, and blurry vision.',
      'Therapeutic levels: 0.6–1.5 mEq/L. In either acute or chronic toxicity, '
          'confusion and somnolence may be seen at levels of 2–2.5 mEq/L. Seizures '
          'or death may occur at levels >2.5 mEq/L. Recommended serum sampling: '
          'trough level within 30 min prior to the next scheduled dose. Steady state '
          'is achieved within 4–6 days of continuous dosing. Adjust dose in renal '
          'failure (see Chapter 32).',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1083',
  ),
  // LOPERAMIDE — PDF p. 275 (printed 1084)
  DrugEntryV3(
    name: 'LOPERAMIDE',
    brandNames: 'Imodium, Imodium A–D, and generics',
    drugClass: 'Antidiarrheal',
    iconRow: '',
    formulations: [
      'Caps (OTC): 2 mg',
      'Tabs (OTC): 2 mg',
      'Oral solution (OTC): 1 mg/7.5 mL (120, 240 mL); may contain propylene '
          'glycol and sodium benzoate; each 30 mL contains 16 mg of sodium',
    ],
    doseSections: [
      DoseSection(
        heading: 'Acute diarrhea (see remarks):',
        lines: [
          DoseLine(
            'Child (initial doses within the first 24 hr):',
            isHeading: true,
          ),
          DoseLine('2–5 yr (13–<21 kg): 1 mg PO TID'),
          DoseLine('6–8 yr (21–27 kg): 2 mg PO BID'),
          DoseLine('9–11 yr (>27–43 kg): 2 mg PO TID'),
          DoseLine('Max. single dose: 2 mg'),
          DoseLine('Follow initial day’s dose with 0.1 mg/kg/dose after each loose stool (not '
              'to exceed the aforementioned initial doses).'),
          DoseLine('≥12 yr and adult: 4 mg/dose × 1, followed by 2 mg/dose after each stool '
              'up to max. dose of 8 mg/24 hr for 12–<18 yr and 16 mg/24 hr for adult'),
        ],
      ),
      DoseSection(
        heading: 'Chronic diarrhea (from intestinal failure, short bowel syndrome, or '
            'other noninfectious causes; see remarks):',
        lines: [
          DoseLine('Infant–child (limited data): 0.08–0.24 mg/kg/24 hr PO ÷ BID–TID; max. '
              'dose: 2 mg/dose'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in acute dysentery; acute ulcerative colitis; bacterial '
          'enterocolitis caused by Salmonella, Shigella, Campylobacter, and '
          'Clostridium difficile; and abdominal pain in the absence of diarrhea. '
          'Avoid use in children <2 yr due to reports of paralytic ileus associated '
          'with abdominal distention. Rare hypersensitivity reactions, including '
          'anaphylactic shock, have been reported. May cause nausea, rash, vomiting, '
          'constipation, cramps, dry mouth, and CNS depression. Use of higher than '
          'recommended dosages via abuse or misuse can cause serious cardiac events '
          '(e.g., torsades de pointes, arrhythmias, cardiac arrest, and Q–T '
          'prolongation).',
      'Discontinue use if no clinical improvement is observed within 48 hr. '
          'Naloxone may be administered for CNS depression.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1084',
  ),
  // LORATADINE ± PSEUDOEPHEDRINE — PDF p. 275–276 (printed 1084–1085)
  DrugEntryV3(
    name: 'LORATADINE ± PSEUDOEPHEDRINE',
    brandNames: 'Alavert, Claritin, Claritin Childrens, Triaminic Allerchews, many '
        'others and generics\nIn combination with pseudoephedrine:\n'
        'Claritin-D 12 hr, Claritin-D 24 hr, Alavert D-12 hr Allergy and '
        'Congestion, Loratadine-D 12 hr, Loratadine-D 24 hr, Allergy '
        'Relief-D, and generics',
    drugClass: 'Antihistamine, less sedating ± decongestant',
    iconRow: '',
    formulations: [
      'Tabs [OTC]: 10 mg',
      'Caps, liquid filled [OTC]: 10 mg; contains polysorbate 80',
      'Chewable tabs (Claritin Childrens and others) [OTC]: 5 mg; contains '
          'aspartame',
      'Disintegrating tabs (Alavert, Triaminic Allerchews, and generics) [OTC]: '
          '10 mg; contains aspartame',
      'Oral solution or syrup [OTC]: 1 mg/mL (120 mL); contains propylene glycol '
          'and sodium benzoate; some preparations may contain metasulfite',
      'Time-release tabs in combination with pseudoephedrine (PE):',
      'Claritin-D 12 hr, Alavert D-12 hr Allergy and Congestion, Loratadine-D 12 '
          'hr, and generics [OTC]: 5 mg loratadine + 120 mg PE',
      'Claritin-D 24 hr, Loratadine-D 24 hr, Allergy Relief-D and generics '
          '[OTC]: 10 mg loratadine + 240 mg PE',
    ],
    doseSections: [
      DoseSection(
        heading: 'Loratadine:',
        lines: [
          DoseLine('2–5 yr: 5 mg PO once daily'),
          DoseLine('≥6 yr and adult: 10 mg PO once daily. Disintegrating tablet may be dosed '
              'at 5 mg PO BID or 10 mg PO once daily.'),
        ],
      ),
      DoseSection(
        heading: 'Time-release tabs of loratidine and pseudoephedrine:',
        lines: [
          DoseLine(
            '≥12 yr and adult (see remarks):',
            isHeading: true,
          ),
          DoseLine('Claritin-D 12 hr and generics: 1 tablet PO BID'),
          DoseLine('Claritin-D 24 hr and generics: 1 tablet PO once daily'),
        ],
      ),
    ],
    remarks: [
      'May cause drowsiness, fatigue, dry mouth, headache, bronchospasms, '
          'palpitations, dermatitis, and dizziness. Has not been implicated in '
          'causing cardiac arrhythmias when used with other drugs that are '
          'metabolized by hepatic microsomal enzymes (e.g., ketoconazole, '
          'erythromycin). May be administered safely in patients who have allergic '
          'rhinitis and asthma.',
      'In hepatic and renal function impairment (GFR <30 mL/min), prolong '
          'loratadine (single agent) dosage interval to every other day. Adjust dose '
          'in renal failure (see Chapter 32).',
      'For time-release tablets of the combination product (loratadine and '
          'pseudoephedrine), prolong dosage interval in renal impairment (GFR <30 '
          'mL/min) as follows: Claritin-D 12 hr: 1 tablet PO once daily; Claritin-D '
          '24 hr: 1 tablet PO every other day. Do not use the combination product in '
          'hepatic impairment because drugs cannot be individually titrated. '
          'Pregnancy category changes to “C” for the combination product (loratadine '
          'and pseudoephedrine).',
      'Administer doses on an empty stomach. For use of disintegrating tabs '
          'place tablet on tongue and allow it to disintegrate in the mouth with or '
          'without water. For Claritin-D products, also see remarks in '
          'Pseudoephedrine.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1084–1085',
  ),
  // LORAZEPAM — PDF p. 276–277 (printed 1085–1086)
  DrugEntryV3(
    name: 'LORAZEPAM',
    brandNames: 'Ativan, Loreev XR, and generics',
    drugClass: 'Benzodiazepine anticonvulsant',
    iconRow: '',
    formulations: [
      'Tabs: 0.5, 1, 2 mg',
      'Extended-release capsules (Loreev XR): 1, 1.5, 2, 3 mg',
      'Injection: 2, 4 mg/mL (1, 10 mL); each contains 2% benzyl alcohol and '
          'propylene glycol',
      'Oral solution: 2 mg/mL (30 mL); some dosage forms may be alcohol and dye '
          'free, and contain propylene glycol',
    ],
    doseSections: [
      DoseSection(
        heading: 'DOSAGES ARE FOR IMMEDIATE-RELEASE DOSAGE FORMS (TABS, INJECTION, AND '
            'ORAL SOLUTION) (for extended-release capsules, see Remarks):',
      ),
      DoseSection(
        heading: 'Status epilepticus (IV route is preferred but may use IM route if IV '
            'is not available):',
        lines: [
          DoseLine('Neonate, infant, child, and adolescent: 0.05–0.1 mg/kg/dose IV over 2–5 '
              'min. May repeat dose in 5–10 min. Max. dose: 4 mg/dose. If IV access not '
              'available, 0.1 mg/kg/dose (max. 4 mg/dose) may be administered '
              'intranasally.'),
          DoseLine('Adult: 4 mg/dose IV given slowly over 2–5 min. May repeat in 5–10 min. '
              'Usual total max. dose in 12-hr period is 8 mg.'),
        ],
      ),
      DoseSection(
        heading: 'Antiemetic adjunct therapy (breakthrough):',
        lines: [
          DoseLine('Child: 0.025–0.05 mg/kg/dose IV Q6 hr PRN; max. single dose: 2 mg'),
        ],
      ),
      DoseSection(
        heading: 'Anxiolytic/sedation:',
        lines: [
          DoseLine('Infant and child: 0.05 mg/kg/dose PO/IV Q4–8 hr; max. dose: 2 mg/dose'),
          DoseLine('May also give IM for preprocedure sedation'),
          DoseLine('Adult: 0.5–2 mg/dose PO/IV Q4–6 hr PRN up to 10 mg/24 hr'),
        ],
      ),
    ],
    remarks: [
      'Contraindicated in narrow-angle glaucoma and severe hypotension. Use with '
          'caution in renal insufficiency (glucoronide metabolite clearance is '
          'reduced), hepatic insufficiency (may worsen hepatic encephalopathy; '
          'decrease dose with severe hepatic impairment), compromised pulmonary '
          'function, and use of CNS depressant medications. May cause respiratory '
          'depression, especially in combination with opioids and other sedatives. '
          'May also cause sedation, dizziness, mild ataxia, mood changes, rash, and '
          'GI symptoms. Paradoxical excitation has been reported in children '
          '(10%–30% of patients <8 yr old).',
      'When compared to diazepam for status epilepticus (3 mo–17 yr), lorazepam '
          'was found to be more sedating with a longer time to return to baseline '
          'mental status.',
      'Significant respiratory depression and/or hypotension has been reported '
          'when used in combination with loxapine. Probenecid and valproic acid may '
          'increase the effects/toxicity of lorazepam, and oral contraceptive '
          'steroids may decrease lorazepam’s effects.',
      'Injectable product may be given rectally. Benzyl alcohol and propylene '
          'glycol may be toxic to newborns at higher doses.',
      'Onset of action for sedation: PO, 20–30 min; IM, 30–60 min; IV, 1–5 min. '
          'Duration of action: 6–8 hr.',
      'Extended-release capsule (Loreev XR) may be swallowed whole or its '
          'content may be opened and sprinkled over a tablespoon of applesauce; '
          'followed by drinking water. DO NOT crush or chew. See product information '
          'for dose conversion from immediate-release dosage forms.',
      'Flumazenil is the antidote.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1085–1086',
  ),
  // LOSARTAN — PDF p. 277–278 (printed 1086–1087)
  DrugEntryV3(
    name: 'LOSARTAN',
    brandNames: 'Cozaar and generics',
    drugClass: 'Angiotensin II receptor antagonist',
    iconRow: '',
    formulations: [
      'Tabs: 25, 50, 100 mg',
      'Oral suspension: 2.5 mg/mL',
      'Contains 2.12 mg potassium per 25 mg drug',
    ],
    doseSections: [
      DoseSection(
        heading: 'Hypertension (see remarks):',
        lines: [
          DoseLine('6–16 yr: Start with 0.7 mg/kg/dose (max. dose: 50 mg/dose) PO once daily. '
              'Adjust dose to desired blood pressure response; daily dose may be divided '
              'BID. Max. dose (higher doses have not been evaluated): 1.4 mg/kg/24 hr or '
              '100 mg/24 hr.'),
          DoseLine('≥17 yr and adult: Start with 50 mg PO once daily (use lower initial dose '
              'of 25 mg PO once daily if patient is receiving diuretics, is experiencing '
              'intravascular volume depletion, or has hepatic impairment). Usual '
              'maintenance dose is 25–100 mg/24 hr PO ÷ once daily–BID.'),
        ],
      ),
    ],
    remarks: [
      'Use with caution in angioedema (current or past), excessive hypotension '
          '(volume depletion), hepatic (use lower starting dose) or renal (contains '
          'potassium) impairment, hyperkalemia (including use with medications that '
          'can cause hyperkalemia), renal artery stenosis, and severe CHF. Not '
          'recommended in patients <6 yr or in children with GFR <30 mL/min/1.73 m², '
          'owing to lack of data.',
      'Discontinue use as soon as possible when pregnancy is detected because '
          'injury and death to developing fetus may occur, especially during the '
          'second and third trimesters.',
      'Diarrhea, asthenia, dizziness, fatigue, and hypotension are common. '
          'Thrombocytopenia, rhabdomyolysis, hallucinations, and angioedema have '
          'been rarely reported.',
      'Losartan is a substrate for cytochrome P-450 (CYP) 2C9 (major) and '
          'CYP3A4. Fluconazole and cimetidine may increase losartan’s '
          'effects/toxicity. Rifampin, phenobarbital, and indomethacin may decrease '
          'its effects. Losartan may increase the risk of lithium toxicity. Do not '
          'use with aliskiren in patients with diabetes or with renal impairment '
          '(GFR <60 mL/min). Dual blockade of the renin–angiotensin system with '
          'losartin and ACE inhibitors (e.g., captopril) or aliskiren is associated '
          'with increased risk for hypotension, syncope, hyperkalemia, and renal '
          'impairment.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1086–1087',
  ),
  // LOW-MOLECULAR-WEIGHT HEPARIN — PDF p. 278 (printed 1087)  [cross-reference]
  DrugEntryV3(
    name: 'LOW-MOLECULAR-WEIGHT HEPARIN',
    brandNames: '',
    drugClass: '',
    iconRow: '',
    formulations: [],
    doseSections: [],
    remarks: [
      'See Enoxaparin.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — p. 1087',
  ),
  // LUMACAFTOR AND IVACAFTOR — PDF p. 278–280 (printed 1087–1089)
  DrugEntryV3(
    name: 'LUMACAFTOR AND IVACAFTOR',
    brandNames: 'Orkambi',
    drugClass: 'Cystic fibrosis transmembrane conductance regulator (CFTR) corrector '
        'and potentiator',
    iconRow: '',
    formulations: [
      'Oral granules (Lumacaftor:Ivacaftor): 75 mg:94 mg (14 packets), 100 '
          'mg:125 mg (56 packets), 150 mg:188 mg (56 packets)',
      'Tabs (Lumacaftor:Ivacaftor): 100 mg:125 mg (112 tabs), 200 mg:125 mg (112 '
          'tabs)',
    ],
    doseSections: [
      DoseSection(
        heading: 'Child 1–<2 yr:',
        lines: [
          DoseLine('7–<9 kg: One lumacaftor 75 mg/ivacaftor 94 mg granule packet PO Q12 hr'),
          DoseLine('9–<14 kg: One lumacaftor 100 mg/ivacaftor 125 mg granule packet PO Q12 hr'),
          DoseLine('≥14 kg: One lumacaftor 150 mg/ivacaftor 188 mg granule packet PO Q12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Child 2–5 yr:',
        lines: [
          DoseLine('<14 kg: One lumacaftor 100 mg/ivacaftor 125 mg granule packet PO Q12 hr'),
          DoseLine('≥14 kg: One lumacaftor 150 mg/ivacaftor 188 mg granule packet PO Q12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Child ≥6–11 yr:',
        lines: [
          DoseLine('Two lumacaftor 100 mg/ivacaftor 125 mg tablets PO Q12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Child ≥12, adolescent, and adult:',
        lines: [
          DoseLine('Two lumacaftor 200 mg/ivacaftor 125 mg tablets PO Q12 hr'),
        ],
      ),
      DoseSection(
        heading: 'Dosage Modification for Hepatic Impairment (Prior to Initiation of '
            'Therapy)',
        table: DoseTable(
          headers: ['Level of Hepatic Impairment (Child-Pugh Class)', 'Age Group (yr)', 'Morning Dose', 'Evening Dose'],
          rows: [
            DoseTableRow(['A. Mild', '1–5', 'No dose adjustment; use usual dose', 'No dose adjustment; use usual dose']),
            DoseTableRow(['', '≥6', 'No dose adjustment; use usual dose', 'No dose adjustment; use usual dose']),
            DoseTableRow(['B. Moderate', '1–5', '1 packet of granules', '1 packet of granules every other day']),
            DoseTableRow(['', '≥6', '2 tablets', '1 tablet']),
            DoseTableRow(['C. Severe', '1–5', '1 packet of granulesᵃ', 'No dose']),
            DoseTableRow(['', '≥6', '1 tabletᵃ', '1 tabletᵃ']),
          ],
        ),
      ),
      DoseSection(
        heading: '',
        lines: [
          DoseLine('ᵃOr less frequently as studies have not been conducted in severe hepatic '
              'impairment.'),
        ],
      ),
      DoseSection(
        heading: 'Dosage modification when used with cytochrome P-450 (CYP) 3A '
            'inhibitors:',
        lines: [
          DoseLine('Already taking Orkambi and initiating a strong CYP3A inhibitor (e.g., '
              'itraconazole): No dosage adjustment'),
          DoseLine('Already taking a strong CYP3A inhibitor and initiating Orkambi: Reduce '
              'Orkambi dosage to 1 tablet or 1 packet of granules every other day × the '
              'first week followed by the recommended daily dose. If Orkambi is '
              'interrupted for >1 wk and reinitiated while taking strong CYP3A '
              'inhibitor, Orkambi should be reintroduced with the reduced dosage of 1 '
              'tablet or 1 packet of granules every other day × 1 wk followed by the '
              'recommended daily dose.'),
        ],
      ),
    ],
    remarks: [
      'Works on CFTR trafficking defect by acting as a CFTR corrector '
          '(lumecaftor) and in combination with a CFTR potentiator (ivacaftor). '
          'Indicated for individuals with homozygous F508del CFTR mutation.',
      'Respiratory events, such as chest discomfort, dyspnea, and abnormal '
          'respiration, may occur during the initiation of therapy and may vary from '
          'transient to severe (requiring discontinuation). Common side effects '
          'include rash, diarrhea, nausea, flatulence, fatigue, nasal discharge, and '
          'URIs. Increased liver enzymes and cataracts may occur; monitor AST/ALT '
          'and ocular exam at baseline. Repeat AST/ALT every 3 mo for the first year '
          'followed by annual assessments. Repeat ocular exams annually. '
          'Hypertension and hypersensitivity reactions (including anaphylaxis) have '
          'been reported. May cause a false-positive urine drug screen for '
          'cannabinoids.',
      'Use with caution with CrCl ≤30 mL/min and ESRD. Reduce dose with '
          'moderate/severe hepatic impairment (see dosage section) or when '
          'initiating therapy while taking a strong CYP3A4 inhibitor.',
      'Lumecaftor is a strong inducer of CYP3A and ivacaftor is a CYP3A '
          'substrate; see dose modification table in the dosage section. Use with '
          'strong CYP3A inducers (e.g., rifampin, rifabutin, carbamazepine, St. '
          'John’s wort) is not recommended. Lumecaftor/ivacaftor may reduce the '
          'efficacy of hormonal contraceptives and increase the incidence of '
          'menstruation-associated side effects (e.g., amenorrhea, dysmenorrhea, and '
          'irregular menses). Always evaluate potential drug–drug interactions; see '
          'https://www.orkambihcp.com/drug-interactions. Avoid food or drink '
          'containing grapefruit or Seville oranges.',
      'Administer all doses with high-fat foods to ensure absorption. Oral '
          'granules can be mixed with 5 mL of soft foods or liquids, such as puréed '
          'fruits or vegetables, yogurt, applesauce, water, breast milk, infant '
          'formula, milk, or juice. Once mixed, it should be consumed within an '
          'hour. If a dose (all dosage forms) is missed within 6 hr of a scheduled '
          'dose, administer a dose immediately. However, if the missed dose is >6 '
          'hr, skip that dose and resume therapy at the next scheduled dose. Never '
          'take a double dose for a missed dose.',
    ],
    pregnancyNote: '',
    sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 1087–1089',
  ),
];
