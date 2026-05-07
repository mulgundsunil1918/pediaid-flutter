// =============================================================================
// lib/screens/formulary/drug_detail_v2_screen.dart
//
// Structured drug detail screen rendering the v2/v3 PediAid formulary.
// Replaces the old "PDF viewer at page N" experience for drugs that have
// rich data — the user still has a "Open PDF page N" escape hatch in the
// AppBar for the underlying source document.
//
// Renders Markdown-style **bold** spans inline using a tiny in-house
// parser so we don't have to pull in a markdown package as a dependency.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/formulary_service.dart';
import '../../services/formulary_v2_service.dart';
import 'drug_pdf_viewer_screen.dart';

class DrugDetailV2Screen extends StatefulWidget {
  /// The drug name shown in the formulary list (used to look up the rich
  /// record in [FormularyV2Service]). [source] is "Neofax" or
  /// "Harriet Lane" so we know which database to read from.
  final String name;
  final String source;

  /// Falls back to opening the source PDF at this page if no rich record
  /// is found (or if the user taps "Open PDF").
  final int pdfPage;

  const DrugDetailV2Screen({
    super.key,
    required this.name,
    required this.source,
    required this.pdfPage,
  });

  @override
  State<DrugDetailV2Screen> createState() => _DrugDetailV2ScreenState();
}

class _DrugDetailV2ScreenState extends State<DrugDetailV2Screen> {
  late Future<DrugV2?> _f;

  @override
  void initState() {
    super.initState();
    _f = FormularyV2Service().findByName(widget.name, source: widget.source);
  }

  void _openPdf() {
    final entry = DrugEntry(
      name: widget.name,
      nameLower: widget.name.toLowerCase(),
      page: widget.pdfPage > 0 ? widget.pdfPage : 1,
      source: widget.source,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => DrugPdfViewerScreen(entry: entry)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FutureBuilder<DrugV2?>(
      future: _f,
      builder: (context, snap) {
        final drug = snap.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              drug?.drug ?? widget.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                tooltip: 'Open source PDF',
                icon: const Icon(Icons.picture_as_pdf_outlined),
                onPressed: _openPdf,
              ),
            ],
          ),
          body: snap.connectionState != ConnectionState.done
              ? const Center(child: CircularProgressIndicator())
              : (drug == null || drug.hidden)
                  ? _NoRecord(name: widget.name, onOpenPdf: _openPdf)
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                      children: [
                        _Header(drug: drug),
                        const SizedBox(height: 14),
                        if (drug.callouts.isNotEmpty)
                          _Callouts(items: drug.callouts, onOpenPdf: _openPdf),
                        if (drug.callouts.isNotEmpty)
                          const SizedBox(height: 14),
                        ...drug.doseBlocks.map((b) => _DoseBlockCard(block: b)),
                        if (drug.rawDoseMd.isNotEmpty &&
                            drug.doseBlocks.isEmpty)
                          _SectionCard(
                            icon: Icons.medication_rounded,
                            title: 'Dosing',
                            tint: cs.primary,
                            child: _MdText(drug.rawDoseMd),
                          ),
                        if (drug.cautionsMd.isNotEmpty)
                          _SectionCard(
                            icon: Icons.warning_amber_rounded,
                            title: 'Cautions & contraindications',
                            tint: const Color(0xFFE65100),
                            child: _MdText(drug.cautionsMd),
                          ),
                        if (drug.adverseEffectsMd.isNotEmpty)
                          _SectionCard(
                            icon: Icons.report_gmailerrorred_rounded,
                            title: 'Adverse effects',
                            tint: const Color(0xFFB71C1C),
                            child: _MdText(drug.adverseEffectsMd),
                          ),
                        if (drug.monitoringMd.isNotEmpty)
                          _SectionCard(
                            icon: Icons.monitor_heart_rounded,
                            title: 'Monitoring',
                            tint: const Color(0xFF2E7D32),
                            child: _MdText(drug.monitoringMd),
                          ),
                        if (drug.pharmacokineticsMd.isNotEmpty)
                          _SectionCard(
                            icon: Icons.science_outlined,
                            title: 'Pharmacokinetics',
                            tint: const Color(0xFF6A1B9A),
                            child: _MdText(drug.pharmacokineticsMd),
                          ),
                        if (drug.pearlsMd.isNotEmpty)
                          _SectionCard(
                            icon: Icons.lightbulb_outline_rounded,
                            title: 'Notes & pearls',
                            tint: const Color(0xFF00897B),
                            child: _MdText(drug.pearlsMd),
                          ),
                        const SizedBox(height: 8),
                        _DisclaimerBanner(onOpenPdf: _openPdf, page: drug.page),
                      ],
                    ),
        );
      },
    );
  }
}

// ─── Widgets ─────────────────────────────────────────────────────────────────

class _NoRecord extends StatelessWidget {
  final String name;
  final VoidCallback onOpenPdf;
  const _NoRecord({required this.name, required this.onOpenPdf});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_outlined, size: 48, color: cs.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              "We don't have a structured record for $name yet.",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onOpenPdf,
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('Open source PDF'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final DrugV2 drug;
  const _Header({required this.drug});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cs.primary, cs.primary.withValues(alpha: 0.78)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            drug.drug,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
              color: Colors.white,
            ),
          ),
          if (drug.altNames.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              drug.altNames.join(' · '),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
          if (drug.category.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                drug.category,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.book_outlined, size: 14,
                  color: Colors.white.withValues(alpha: 0.85)),
              const SizedBox(width: 6),
              Text(
                '${drug.source}${drug.page > 0 ? "  ·  p${drug.page}" : ""}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Callouts extends StatelessWidget {
  final List<String> items;
  final VoidCallback onOpenPdf;
  const _Callouts({required this.items, required this.onOpenPdf});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFB74D).withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.table_chart_outlined,
                  color: Color(0xFFE65100), size: 18),
              const SizedBox(width: 8),
              Text(
                'Tables in source',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFE65100),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...items.map((c) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  '• $c',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6D4C00),
                  ),
                ),
              )),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onOpenPdf,
              icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
              label: Text(
                'Open the page',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: cs.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color tint;
  final Widget child;
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.tint,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: tint, size: 17),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _DoseBlockCard extends StatelessWidget {
  final DoseBlock block;
  const _DoseBlockCard({required this.block});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.medication_rounded,
                    color: cs.onPrimaryContainer, size: 17),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  block.indication,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...block.populations.map((p) => _PopulationRow(pop: p)),
        ],
      ),
    );
  }
}

class _PopulationRow extends StatelessWidget {
  final DosePopulation pop;
  const _PopulationRow({required this.pop});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(color: cs.primary, width: 3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pop.label.isNotEmpty || pop.routeHint.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  if (pop.label.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        pop.label,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: cs.onPrimaryContainer,
                        ),
                      ),
                    ),
                  if (pop.routeHint.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00897B).withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        pop.routeHint,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF00695C),
                        ),
                      ),
                    ),
                ],
              ),
            if (pop.label.isNotEmpty || pop.routeHint.isNotEmpty)
              const SizedBox(height: 6),
            _MdText(pop.doseMd),
          ],
        ),
      ),
    );
  }
}

class _DisclaimerBanner extends StatelessWidget {
  final VoidCallback onOpenPdf;
  final int page;
  const _DisclaimerBanner({required this.onOpenPdf, required this.page});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 16, color: cs.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'For qualified clinicians. Verify every dose against your local protocol and current vial strength before administration.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          if (page > 0) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onOpenPdf,
                icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                label: Text(
                  'Open source PDF (page $page)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: cs.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Tiny markdown renderer (handles **bold** and newlines) ──────────────────

class _MdText extends StatelessWidget {
  final String md;
  const _MdText(this.md);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final base = GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.45,
      color: cs.onSurface,
    );
    final boldStyle = base.copyWith(fontWeight: FontWeight.w800, color: cs.onSurface);
    return RichText(
      text: TextSpan(
        style: base,
        children: _parseSpans(md, base, boldStyle),
      ),
    );
  }

  /// Split `**bold**` segments in a single pass. Markdown intra-word `_x_`
  /// underscores are also recognised as italic. Newlines pass through as
  /// real linebreaks.
  static List<InlineSpan> _parseSpans(
      String s, TextStyle base, TextStyle bold) {
    final spans = <InlineSpan>[];
    final pat = RegExp(r"\*\*(.+?)\*\*", dotAll: true);
    int i = 0;
    for (final m in pat.allMatches(s)) {
      if (m.start > i) {
        spans.add(TextSpan(text: s.substring(i, m.start)));
      }
      spans.add(TextSpan(text: m.group(1), style: bold));
      i = m.end;
    }
    if (i < s.length) spans.add(TextSpan(text: s.substring(i)));
    return spans;
  }
}
