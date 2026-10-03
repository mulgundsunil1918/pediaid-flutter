// =============================================================================
// screens/formulary_v3/drug_entry_v3.dart
//
// Drug Formulary 3.0 — the data model, and the first entry.
//
// Everything in `acetaminophenV3` below is copied word-for-word from the
// Harriet Lane 24th edition PDF, pages 853-854 (the "Chapter 31 A 853/854"
// running header), verified twice: once as a mechanical word-for-word diff
// against a fresh pypdf extraction of those pages, and once by rendering the
// actual page as an image and reading the dosing table cell by cell against
// it. Nothing here is paraphrased, summarised, or invented — including the
// B/C/1/Yes/No icon row, which is reproduced as printed because its meaning
// (the icon legend is on a different page) was not independently verified.
//
// This is a hand-built proof entry, not an output of the batch pipeline
// discussed earlier in this session — Sunil asked to see the UI, not to
// settle the extraction-pipeline question first.
// =============================================================================

/// Turns a book-style ALL-CAPS drug name into Title Case for display —
/// "ALUMINUM HYDROXIDE WITH MAGNESIUM HYDROXIDE" becomes "Aluminum Hydroxide
/// With Magnesium Hydroxide", every word, not just the first.
///
/// Shared rather than written per-screen: an earlier version of this lived
/// only in the detail screen, and the hub screen's own copy only capitalised
/// the very first letter of the whole string and lowercased everything after
/// it — correct for a one-word name, wrong for most of the formulary, since
/// it drops every word after the first back to lowercase instead of
/// capitalising each one. One function, used everywhere a name is displayed,
/// so that class of bug can't recur.
String titleCaseDrugName(String s) => s
    .split(' ')
    .map((w) => w.isEmpty ? w : '${w[0]}${w.substring(1).toLowerCase()}')
    .join(' ');

/// One row of a dosing table (e.g. weight-banded acetaminophen dosing).
class DoseTableRow {
  const DoseTableRow(this.cells);
  final List<String> cells;
}

/// A table as printed — headers plus rows, nothing restructured.
class DoseTable {
  const DoseTable({required this.headers, required this.rows});
  final List<String> headers;
  final List<DoseTableRow> rows;
}

/// One line of prose within a dosing section — e.g. a single age-band dose,
/// or a sub-heading like "Neonate and infant:". [isHeading] renders it bold
/// with no leading dose marker, matching the PDF's own sub-headings.
class DoseLine {
  const DoseLine(this.text, {this.isHeading = false});
  final String text;
  final bool isHeading;
}

/// A dosing section as the PDF prints it — a heading ("Analgesic and
/// antipyretic:", "IV (maximum daily doses...)"), then a mix of prose lines
/// and, where the PDF has one, a real table.
class DoseSection {
  const DoseSection({required this.heading, this.lines = const [], this.table});
  final String heading;
  final List<DoseLine> lines;
  final DoseTable? table;
}

class DrugEntryV3 {
  const DrugEntryV3({
    required this.name,
    required this.brandNames,
    required this.drugClass,
    required this.iconRow,
    required this.formulations,
    required this.doseSections,
    required this.remarks,
    required this.pregnancyNote,
    required this.sourcePages,
  });

  final String name;
  final String brandNames;
  final String drugClass;

  /// Printed exactly as the book shows it — e.g. "B/C  ·  1  ·  Yes  ·  Yes  ·  No".
  /// Not expanded into English, because the legend that defines these icons
  /// lives on a different page (p. 814) and wasn't part of this extraction.
  final String iconRow;

  final List<String> formulations;
  final List<DoseSection> doseSections;

  /// Cautions / interactions / pharmacokinetics paragraphs, in PDF order.
  final List<String> remarks;

  final String pregnancyNote;
  final String sourcePages;
}

const acetaminophenV3 = DrugEntryV3(
  name: 'ACETAMINOPHEN',
  brandNames: 'Tylenol, Tempra, Panadol, FeverAll, Anacin Aspirin Free, '
      'Mapap, Paracetamol, and many others including generics; '
      'previously available as Ofirmev',
  drugClass: 'Analgesic, antipyretic',
  iconRow: 'B/C   ·   1   ·   Yes   ·   Yes   ·   No',
  formulations: [
    'Tabs [OTC]: 325, 500 mg',
    'Chewable tabs [OTC]: 80, 160 mg; some may contain phenylalanine',
    'Child suspension/syrup [OTC]: 160 mg/5 mL; may contain sodium benzoate '
        'and propylene glycol',
    'Oral liquid [OTC]: 160 mg/5 mL; may contain sodium benzoate and '
        'propylene glycol',
    'Elixir [OTC]: 160 mg/5 mL; may contain sodium benzoate and propylene '
        'glycol',
    'Extended release tabs [OTC]: 650 mg',
    'Capsules [OTC]: 325, 500 mg',
    "Tylenol Children's Dissolve Packs [OTC]: 160 mg (30 packets); contains "
        'sucralose and xylitol',
    'Tylenol Extra Strength Dissolve Packs [OTC]: 500 mg (32 packets); '
        'contains sucralose and xylitol',
    'Suppositories (FeverAll and generics) [OTC]: 80, 120, 325, 650 mg; '
        'contain polysorbate 80',
    'Injection: 10 mg/mL (100 mL); preservative free',
  ],
  doseSections: [
    DoseSection(
      heading: 'Analgesic and antipyretic:',
      lines: [
        DoseLine(
          'PO/PR (maximum daily doses include all routes of acetaminophen '
          'administration and DO NOT exceed 5 doses in 24 hours):',
          isHeading: true,
        ),
        DoseLine(
          'Term neonate: 10–15 mg/kg/dose PO/PR Q4–6 hr; max. dose: '
          '75 mg/kg/24 hr. Some advocate loading doses of 20–25 mg/kg/dose '
          'for PO dosing or 30 mg/kg/dose for PR dosing.',
        ),
        DoseLine(
          'Pediatric: 10–15 mg/kg/dose PO/PR Q4–6 hr; max. dose: '
          '75 mg/kg/24 hr or 4 g/24 hr. For rectal dosing, some may advocate '
          'a 40–45 mg/kg/dose loading dose.',
        ),
        DoseLine(
          'Dosing by weight (preferred) or age (PO/PR Q4–6 hr; DO NOT '
          'exceed 5 doses in 24 hours):',
          isHeading: true,
        ),
      ],
      table: DoseTable(
        headers: ['Weight (lbs)', 'Weight (kg)', 'Age', 'Dosage (mg)'],
        rows: [
          DoseTableRow(['6–11', '2.7–5', '0–3 mo', '40']),
          DoseTableRow(['12–17', '5.1–7.7', '4–11 mo', '80']),
          DoseTableRow(['18–23', '7.8–10.5', '1–2 yr', '120']),
          DoseTableRow(['24–35', '10.6–15.9', '2–3 yr', '160']),
          DoseTableRow(['36–47', '16–21.4', '4–5 yr', '240']),
          DoseTableRow(['48–59', '21.5–26.8', '6–8 yr', '320 to 325']),
          DoseTableRow(['60–71', '26.9–32.3', '9–10 yr', '325 to 400']),
          DoseTableRow(['72–95', '32.4–43.2', '11 yr', '480 to 500']),
        ],
      ),
    ),
    DoseSection(
      heading: 'Adult (for reference):',
      lines: [
        DoseLine('325–650 mg/dose PO/PR Q4–6 hr'),
        DoseLine('Max. dose: 4 g/24 hr, 5 doses/24 hr'),
      ],
    ),
    DoseSection(
      heading: 'IV (maximum daily doses include all routes of acetaminophen '
          'administration):',
      lines: [
        DoseLine('Neonate and infant:', isHeading: true),
        DoseLine(
          '<32 wk gestation: 7.5–10 mg/kg/dose Q6 hr IV up to a maximum of '
          '40 mg/kg/24 hr',
        ),
        DoseLine('≥32 wk gestation:', isHeading: true),
        DoseLine(
          '≤28 days old: 12.5 mg/kg/dose Q6 hr IV up to a maximum of '
          '50 mg/kg/24 hr',
        ),
        DoseLine(
          '≥29 days old to <2 yr: 15 mg/kg/dose Q6 hr IV up to a maximum of '
          '60 mg/kg/24 hr',
        ),
        DoseLine(
          'Child (≥2–12 yr): 15 mg/kg/dose Q6 hr, OR 12.5 mg/kg/dose Q4 hr '
          'IV up to the following maximum dose by patient weight:',
        ),
        DoseLine(
          '<50 kg: 75 mg/kg/24 hr up to 3750 mg/24 hr with a maximum single '
          'dose of 15 mg/kg/dose up to 750 mg',
        ),
        DoseLine(
          '≥50 kg: 75 mg/kg/24 hr up to 4000 mg/24 hr with a maximum single '
          'dose of 15 mg/kg/dose up to 1000 mg',
        ),
        DoseLine('Adolescent (≥13 yr) and adult:', isHeading: true),
        DoseLine(
          '<50 kg: 15 mg/kg/dose Q6 hr, OR 12.5 mg/kg/dose Q4 hr IV up to a '
          'daily maximum of 75 mg/kg/24 hr up to 3750 mg/24 hr with a '
          'maximum single dose of 15 mg/kg/dose up to 750 mg',
        ),
        DoseLine(
          '≥50 kg: 1000 mg Q6 hr, OR 650 mg Q4 hr up to a maximum of '
          '4000 mg/24 hr with a maximum single dose of 1000 mg/dose',
        ),
      ],
    ),
  ],
  remarks: [
    'Does NOT possess anti-inflammatory activity. Safety and efficacy for '
        'acute pain and fever in children ≥2 years old are supported by '
        'controlled clinical trials. Use with caution in patients with '
        'known G6PD deficiency.',
    'T 1/2: 1–3 hr, 2–5 hr in neonates; metabolized in the liver; see '
        'Chapter 3 and acetylcysteine for management of drug overdose.',
    'Some preparations contain alcohol (7%–10%) and/or phenylalanine; all '
        'suspensions should be shaken before use.',
    'May be used for the treatment of patent ductus arteriosus when '
        'standard NSAID is contraindicated or has failed. Most commonly '
        'reported dosage is 15 mg/kg dose Q6 hr IV/PO for 3 days (may be '
        'given up to 7 days or with a repeated 3-day course).',
    'May decrease the activity of lamotrigine and increase the '
        'activity/toxicity of busulfan, warfarin, and zidovudine. '
        'Barbiturates, phenytoin, rifampin, and anticholinergic agents '
        '(e.g., scopolamine) may decrease the effect of acetaminophen. '
        'Increased risk for hepatotoxicity may occur with barbiturates, '
        'carbamazepine, phenytoin, carmustine (with high acetaminophen '
        'doses), chronic alcohol use, and inducers of CYP 450 2E1 (e.g., '
        'isoniazid). Adjust dose in renal failure (see Chapter 32).',
    'FOR IV USE: Administer dose undiluted over 15 min. Most common side '
        'effects with IV use include nausea, vomiting, constipation, '
        'pruritus, agitation, and atelectasis in children; and nausea, '
        'vomiting, headache, and insomnia in adults. Rare risk of serious '
        'skin reactions (e.g., SJS, TEN) has been reported.',
  ],
  pregnancyNote: 'Pregnancy category is "B" for oral/rectal routes of '
      'administration and "C" for intravenous route.',
  sourcePages: 'Harriet Lane Handbook, 24th ed. — pp. 853–854',
);
