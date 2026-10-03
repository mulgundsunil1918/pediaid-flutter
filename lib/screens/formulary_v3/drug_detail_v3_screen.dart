// =============================================================================
// screens/formulary_v3/drug_detail_v3_screen.dart
//
// Drug Formulary 3.0 — first proof render.
//
// Styled with the app's own theme (primaryNavy / accentTeal from
// theme/app_theme.dart), not the orphaned purple of formulary_v2 — this is
// meant to feel like it belongs to PediAid, not to the earlier attempt.
//
// The one thing worth being deliberate about: the dosing table renders as an
// actual table — real columns, real rows — rather than flattened into prose.
// That reconstruction is the entire point of doing this over the old
// page-image formulary; a doctor scanning for "11 yr" should be able to find
// the row, not re-read a paragraph.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'drug_entry_v3.dart';

class DrugDetailV3Screen extends StatelessWidget {
  const DrugDetailV3Screen({super.key, required this.drug});

  final DrugEntryV3 drug;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titleCaseDrugName(drug.name),
          style: GoogleFonts.plusJakartaSans(
              fontSize: 16, fontWeight: FontWeight.w800),
        ),
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 36),
        children: [
          _HeaderCard(drug: drug, cs: cs),
          const SizedBox(height: 14),

          _SectionLabel('FORMULATIONS', cs),
          const SizedBox(height: 8),
          _Card(
            cs: cs,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final f in drug.formulations) _BulletLine(f, cs),
              ],
            ),
          ),
          const SizedBox(height: 18),

          _SectionLabel('DOSING', cs),
          const SizedBox(height: 8),
          for (final section in drug.doseSections) ...[
            _DoseSectionCard(section: section, cs: cs),
            const SizedBox(height: 10),
          ],

          const SizedBox(height: 8),
          _SectionLabel('REMARKS', cs),
          const SizedBox(height: 8),
          _Card(
            cs: cs,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < drug.remarks.length; i++) ...[
                  _BodyText(drug.remarks[i], cs),
                  if (i != drug.remarks.length - 1) const SizedBox(height: 10),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.tertiaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.pregnant_woman_outlined,
                    size: 16, color: cs.onSurface.withValues(alpha: 0.6)),
                const SizedBox(width: 8),
                Expanded(child: _BodyText(drug.pregnancyNote, cs)),
              ],
            ),
          ),

          const SizedBox(height: 22),
          Center(
            child: Text(
              drug.sourcePages,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  color: cs.onSurface.withValues(alpha: 0.45)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ───────────────────────────────────────────────────────────────

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.drug, required this.cs});
  final DrugEntryV3 drug;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleCaseDrugName(drug.name),
            style: GoogleFonts.plusJakartaSans(
                fontSize: 20, fontWeight: FontWeight.w900, color: cs.primary),
          ),
          const SizedBox(height: 4),
          Text(
            drug.brandNames,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                height: 1.4,
                color: cs.onSurface.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  drug.drugClass,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11, fontWeight: FontWeight.w800, color: cs.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline,
                  size: 13, color: cs.onSurface.withValues(alpha: 0.4)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${drug.iconRow}  (printed as in the book — icon legend is '
                  'on a different page and is not reproduced here)',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      color: cs.onSurface.withValues(alpha: 0.5)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Shared bits ─────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, this.cs);
  final String text;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.9,
            color: cs.onSurface.withValues(alpha: 0.55)),
      );
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.cs});
  final Widget child;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
        ),
        child: child,
      );
}

class _BulletLine extends StatelessWidget {
  const _BulletLine(this.text, this.cs);
  final String text;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Icon(Icons.circle,
                  size: 4.5, color: cs.onSurface.withValues(alpha: 0.4)),
            ),
            const SizedBox(width: 9),
            Expanded(child: _BodyText(text, cs)),
          ],
        ),
      );
}

/// Renders a line of PDF prose with **bold** markers around dose numbers and
/// units picked out automatically (mg/kg/dose, Q4–6 hr, ages, weights) —
/// cosmetic only; the text itself is untouched from the source.
class _BodyText extends StatelessWidget {
  const _BodyText(this.text, this.cs, {this.heading = false});
  final String text;
  final ColorScheme cs;
  final bool heading;

  static final _boldPattern = RegExp(
    r'(\d[\d.,]*(?:\s*[–\-]\s*\d[\d.,]*)?\s*'
    r'(?:mg(?:/kg)?(?:/dose)?(?:/24\s*hr)?|g(?:/24\s*hr)?|mL|mcg)'
    r'|Q\d+[–\-]?\d*\s*hr'
    r'|\d+[–\-]?\d*\s*(?:yr|mo|wk|hr|days?))',
    caseSensitive: false,
  );

  @override
  Widget build(BuildContext context) {
    final base = GoogleFonts.plusJakartaSans(
      fontSize: 13,
      height: 1.5,
      fontWeight: heading ? FontWeight.w800 : FontWeight.w400,
      color: cs.onSurface,
    );
    if (heading) return Text(text, style: base);

    final spans = <TextSpan>[];
    var last = 0;
    for (final m in _boldPattern.allMatches(text)) {
      if (m.start > last) {
        spans.add(TextSpan(text: text.substring(last, m.start)));
      }
      spans.add(TextSpan(
        text: m.group(0),
        style: const TextStyle(fontWeight: FontWeight.w800),
      ));
      last = m.end;
    }
    if (last < text.length) spans.add(TextSpan(text: text.substring(last)));
    return Text.rich(TextSpan(style: base, children: spans));
  }
}

// ── Dosing ───────────────────────────────────────────────────────────────

class _DoseSectionCard extends StatelessWidget {
  const _DoseSectionCard({required this.section, required this.cs});
  final DoseSection section;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: cs.primary.withValues(alpha: 0.6), width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.heading,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5, fontWeight: FontWeight.w800, color: cs.primary),
          ),
          if (section.lines.isNotEmpty) const SizedBox(height: 8),
          for (final line in section.lines) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: _BodyText(line.text, cs, heading: line.isHeading),
            ),
          ],
          if (section.table != null) ...[
            const SizedBox(height: 4),
            _DoseTableWidget(table: section.table!, cs: cs),
          ],
        ],
      ),
    );
  }
}

/// A real scrollable table — not text. This is the point of the exercise:
/// on the old page-image formulary a doctor had to re-read the whole
/// paragraph to find "11 yr"; here they scan one row.
class _DoseTableWidget extends StatelessWidget {
  const _DoseTableWidget({required this.table, required this.cs});
  final DoseTable table;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(
            color: cs.outline.withValues(alpha: 0.25), width: 0.6),
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: [
          TableRow(
            decoration: BoxDecoration(color: cs.primary.withValues(alpha: 0.10)),
            children: [
              for (final h in table.headers) _cell(h, header: true),
            ],
          ),
          for (var i = 0; i < table.rows.length; i++)
            TableRow(
              decoration: BoxDecoration(
                color: i.isEven
                    ? Colors.transparent
                    : cs.surfaceContainerHighest.withValues(alpha: 0.35),
              ),
              children: [
                for (final c in table.rows[i].cells) _cell(c),
              ],
            ),
        ],
      ),
    );
  }

  Widget _cell(String text, {bool header = false}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: header ? FontWeight.w800 : FontWeight.w600,
            color: header ? cs.primary : cs.onSurface,
          ),
        ),
      );
}
