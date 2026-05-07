// =============================================================================
// lib/screens/formulary/drug_detail_v2_screen.dart
//
// Premium drug-monograph detail screen — designed for fast bedside scanning
// during NICU/PICU rounds. Renders any DrugV2 (Neofax or Harriet Lane v3)
// using the same structured template, so every drug in the formulary
// looks identical in shape and a clinician can find a dose in seconds.
//
// Sections (each its own colour-coded Material 3 card):
//   - Hero header              drug name, alt names, category, source/page
//   - Quick Summary            auto-extracted bullets: routes, key dose,
//                              infusion duration, major toxicity, monitoring
//   - Dose                     blue,   per-indication → per-population
//   - Indian formulations      teal,   Neofax brand list (when present)
//   - Preparation              teal,   reconstitution + incompatibilities
//   - Monitoring               yellow, monitoring narrative
//   - Common adverse effects   amber,  adverse-effect sentences sans "serious"
//   - Serious toxicities       red,    sentences with fatal / life-threat /
//                              arrest / SJS / hepatotoxicity / etc.
//   - Contraindications        red,    cautions / contraindications text
//   - Renal / hepatic          purple, dose adjustments (Neofax)
//   - Pharmacokinetics         purple, PK narrative (HL only)
//   - Notes & pearls           gray,   clinical pearls
//   - Source disclaimer        bottom, with "open original PDF" escape hatch
//
// Long sections collapse via custom accordion by default (Adverse Effects,
// Pharmacokinetics, Notes). Critical bedside content (Dose, Monitoring,
// Contraindications, Quick Summary) stays expanded.
//
// All content is preserved verbatim from the source JSON. The renderer
// adds visual hierarchy + colour-coding only.
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
  /// is found, or when the user taps "Open PDF".
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
          backgroundColor: cs.surface,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 1,
            title: Text(
              drug?.drug ?? widget.name,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
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
                  : _DrugBody(drug: drug, onOpenPdf: _openPdf),
        );
      },
    );
  }
}

// ─── Body ────────────────────────────────────────────────────────────────────

class _DrugBody extends StatelessWidget {
  final DrugV2 drug;
  final VoidCallback onOpenPdf;
  const _DrugBody({required this.drug, required this.onOpenPdf});

  @override
  Widget build(BuildContext context) {
    final summary = QuickSummary.fromDrug(drug);
    final tox = ToxicitySplit.from(drug.adverseEffectsMd);

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 36),
      children: [
        // ── Hero ──────────────────────────────────────────────────────
        _Hero(drug: drug),
        const SizedBox(height: 14),

        // ── Quick Summary ─────────────────────────────────────────────
        if (summary.hasContent) ...[
          _QuickSummaryCard(summary: summary),
          const SizedBox(height: 14),
        ],

        // ── Tables-in-source callouts (HL only) ───────────────────────
        if (drug.callouts.isNotEmpty) ...[
          _CalloutsBanner(items: drug.callouts, onOpenPdf: onOpenPdf),
          const SizedBox(height: 14),
        ],

        // ── Dose ──────────────────────────────────────────────────────
        _DoseSection(drug: drug),

        // ── Indian formulations (Neofax) ──────────────────────────────
        if (drug.formulations.isNotEmpty)
          _FormulationsSection(items: drug.formulations),

        // ── Preparation ───────────────────────────────────────────────
        if (drug.reconstitutionMd.isNotEmpty || drug.incompatibilitiesMd.isNotEmpty)
          _PreparationSection(
            reconstitutionMd: drug.reconstitutionMd,
            incompatibilitiesMd: drug.incompatibilitiesMd,
          ),

        // ── Monitoring ────────────────────────────────────────────────
        if (drug.monitoringMd.isNotEmpty)
          _SectionCard(
            icon: Icons.monitor_heart_rounded,
            title: 'Monitoring',
            tint: const Color(0xFFD97706), // amber-600
            initiallyExpanded: true,
            child: _MdBody(text: drug.monitoringMd),
          ),

        // ── Common adverse effects ────────────────────────────────────
        if (tox.commonMd.isNotEmpty)
          _SectionCard(
            icon: Icons.warning_amber_rounded,
            title: 'Common adverse effects',
            tint: const Color(0xFFE65100), // orange-900
            initiallyExpanded: true,
            child: _MdBody(text: tox.commonMd),
          ),

        // ── Serious toxicities (only if any flagged) ──────────────────
        if (tox.seriousMd.isNotEmpty)
          _SectionCard(
            icon: Icons.report_problem_rounded,
            title: 'Serious toxicities',
            tint: const Color(0xFFB71C1C), // red-900
            initiallyExpanded: true,
            child: _MdBody(text: tox.seriousMd, emphasiseRed: true),
          ),

        // ── Contraindications ─────────────────────────────────────────
        if (drug.cautionsMd.isNotEmpty)
          _SectionCard(
            icon: Icons.block_rounded,
            title: 'Contraindications & cautions',
            tint: const Color(0xFFB71C1C),
            initiallyExpanded: true,
            child: _MdBody(text: drug.cautionsMd),
          ),

        // ── Renal / hepatic adjustments (Neofax) ──────────────────────
        if (drug.renalAdjustmentMd.isNotEmpty || drug.hepaticAdjustmentMd.isNotEmpty)
          _SectionCard(
            icon: Icons.tune_rounded,
            title: 'Renal / hepatic adjustment',
            tint: const Color(0xFF6A1B9A), // purple-900
            initiallyExpanded: false,
            child: _RenalHepaticContent(
              renal: drug.renalAdjustmentMd,
              hepatic: drug.hepaticAdjustmentMd,
            ),
          ),

        // ── Pharmacokinetics (HL only) ────────────────────────────────
        if (drug.pharmacokineticsMd.isNotEmpty)
          _SectionCard(
            icon: Icons.science_outlined,
            title: 'Pharmacokinetics',
            tint: const Color(0xFF6A1B9A),
            initiallyExpanded: false,
            child: _MdBody(text: drug.pharmacokineticsMd),
          ),

        // ── Pearls / notes ────────────────────────────────────────────
        if (drug.pearlsMd.isNotEmpty)
          _SectionCard(
            icon: Icons.lightbulb_outline_rounded,
            title: 'Notes & pearls',
            tint: const Color(0xFF00897B), // teal
            initiallyExpanded: false,
            child: _MdBody(text: drug.pearlsMd),
          ),

        const SizedBox(height: 8),
        _DisclaimerBanner(
          onOpenPdf: onOpenPdf,
          page: drug.page,
          source: drug.source,
        ),
      ],
    );
  }
}

// ─── No-record fallback ──────────────────────────────────────────────────────

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

// ─── Hero header ─────────────────────────────────────────────────────────────

class _Hero extends StatelessWidget {
  final DrugV2 drug;
  const _Hero({required this.drug});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cs.primary, cs.primary.withValues(alpha: 0.78)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            drug.drug,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: Colors.white,
              height: 1.15,
            ),
          ),
          if (drug.altNames.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              drug.altNames.join(' · '),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.88),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (drug.category.isNotEmpty)
                _heroChip(context,
                    icon: Icons.category_outlined, label: drug.category),
              if (drug.atcCode.isNotEmpty)
                _heroChip(context,
                    icon: Icons.tag_rounded, label: 'ATC ${drug.atcCode}'),
              _heroChip(context,
                  icon: Icons.book_outlined,
                  label: drug.page > 0
                      ? '${drug.source} · p${drug.page}'
                      : drug.source),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroChip(BuildContext context,
      {required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.1,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Quick Summary card ──────────────────────────────────────────────────────

class _QuickSummaryCard extends StatelessWidget {
  final QuickSummary summary;
  const _QuickSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final entries = <_QuickEntry>[];
    if (summary.routes.isNotEmpty) {
      entries.add(_QuickEntry(
        icon: Icons.alt_route_rounded,
        label: 'Route',
        value: summary.routes.join(' · '),
      ));
    }
    if (summary.keyDose != null) {
      entries.add(_QuickEntry(
        icon: Icons.water_drop_rounded,
        label: 'Key dose',
        value: summary.keyDose!,
      ));
    }
    if (summary.infusionDuration != null) {
      entries.add(_QuickEntry(
        icon: Icons.timer_outlined,
        label: 'Infusion',
        value: summary.infusionDuration!,
      ));
    }
    if (summary.maxDose != null) {
      entries.add(_QuickEntry(
        icon: Icons.straighten_rounded,
        label: 'Max',
        value: summary.maxDose!,
      ));
    }
    if (summary.majorToxicity != null) {
      entries.add(_QuickEntry(
        icon: Icons.warning_amber_rounded,
        label: 'Watch for',
        value: summary.majorToxicity!,
        valueTint: const Color(0xFFB71C1C),
      ));
    }
    if (summary.primaryMonitoring != null) {
      entries.add(_QuickEntry(
        icon: Icons.monitor_heart_rounded,
        label: 'Monitor',
        value: summary.primaryMonitoring!,
      ));
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flash_on_rounded, size: 16, color: cs.primary),
              const SizedBox(width: 6),
              Text(
                'QUICK SUMMARY',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                  color: cs.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...entries.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: e.build(context),
              )),
        ],
      ),
    );
  }
}

class _QuickEntry {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueTint;
  const _QuickEntry({
    required this.icon,
    required this.label,
    required this.value,
    this.valueTint,
  });

  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 16, color: cs.primary),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 72,
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: valueTint ?? cs.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Tables-in-source callouts banner ────────────────────────────────────────

class _CalloutsBanner extends StatelessWidget {
  final List<String> items;
  final VoidCallback onOpenPdf;
  const _CalloutsBanner({required this.items, required this.onOpenPdf});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(14),
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
                'Source contains a dosing table',
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
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                    color: const Color(0xFF6D4C00),
                  ),
                ),
              )),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onOpenPdf,
              icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
              label: Text(
                'View original page',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFE65100),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable section card with custom accordion ─────────────────────────────

class _SectionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color tint;
  final Widget child;
  final bool initiallyExpanded;
  final Widget? trailing;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.tint,
    required this.child,
    required this.initiallyExpanded,
    this.trailing,
  });

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard>
    with SingleTickerProviderStateMixin {
  late bool _expanded = widget.initiallyExpanded;
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
    value: widget.initiallyExpanded ? 1 : 0,
  );
  late final Animation<double> _rotate = Tween<double>(begin: 0, end: 0.5)
      .animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic));

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _ac.forward();
      } else {
        _ac.reverse();
      }
    });
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (tap to toggle)
          InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: widget.tint.withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.icon, color: widget.tint, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.1,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  if (widget.trailing != null) ...[
                    widget.trailing!,
                    const SizedBox(width: 6),
                  ],
                  RotationTransition(
                    turns: _rotate,
                    child: Icon(
                      Icons.expand_more_rounded,
                      color: cs.onSurfaceVariant,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Body — animated reveal
          ClipRect(
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              heightFactor: _expanded ? 1 : 0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(0, 0, 14, 14),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: widget.tint, width: 3),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 14, top: 4),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dose section ────────────────────────────────────────────────────────────

class _DoseSection extends StatelessWidget {
  final DrugV2 drug;
  const _DoseSection({required this.drug});

  @override
  Widget build(BuildContext context) {
    if (drug.doseBlocks.isEmpty && drug.rawDoseMd.isEmpty) {
      return const SizedBox.shrink();
    }
    final showHeaders = drug.doseBlocks.length > 1 ||
        (drug.doseBlocks.isNotEmpty &&
            drug.doseBlocks.first.indication.toLowerCase() != 'dosing');
    return _SectionCard(
      icon: Icons.water_drop_rounded,
      title: 'Dose',
      tint: const Color(0xFF1565C0), // PediAid blue
      initiallyExpanded: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < drug.doseBlocks.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            _DoseBlockView(
              block: drug.doseBlocks[i],
              showHeader: showHeaders,
            ),
          ],
          if (drug.rawDoseMd.isNotEmpty && drug.doseBlocks.isEmpty) ...[
            _MdBody(text: drug.rawDoseMd),
          ],
        ],
      ),
    );
  }
}

class _DoseBlockView extends StatelessWidget {
  final DoseBlock block;
  final bool showHeader;
  const _DoseBlockView({required this.block, required this.showHeader});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              block.indication,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
                letterSpacing: 0.05,
              ),
            ),
          ),
        ...block.populations.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _PopulationRow(pop: p),
            )),
      ],
    );
  }
}

class _PopulationRow extends StatelessWidget {
  final DosePopulation pop;
  const _PopulationRow({required this.pop});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasLabels = pop.label.isNotEmpty || pop.routeHint.isNotEmpty;
    final popTint = _populationTint(pop.label);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasLabels)
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                if (pop.label.isNotEmpty)
                  _Chip(
                    text: pop.label,
                    bg: popTint.withValues(alpha: 0.15),
                    fg: popTint,
                  ),
                if (pop.routeHint.isNotEmpty)
                  _Chip(
                    text: pop.routeHint,
                    bg: const Color(0xFF00897B).withValues(alpha: 0.13),
                    fg: const Color(0xFF00695C),
                    monospace: pop.routeHint.length <= 12,
                  ),
              ],
            ),
          if (hasLabels) const SizedBox(height: 8),
          _MdBody(text: pop.doseMd),
        ],
      ),
    );
  }

  Color _populationTint(String label) {
    final l = label.toLowerCase();
    if (l.contains('preterm')) return const Color(0xFF6A1B9A);
    if (l.contains('neonate') || l.contains('newborn')) {
      return const Color(0xFF1565C0);
    }
    if (l.contains('infant')) return const Color(0xFF00897B);
    if (l.contains('child') ||
        l.contains('paediatric') ||
        l.contains('pediatric')) {
      return const Color(0xFF2E7D32);
    }
    if (l.contains('adolescent')) return const Color(0xFFE65100);
    if (l.contains('adult')) return const Color(0xFF455A64);
    if (l.contains('loading')) return const Color(0xFFB71C1C);
    if (l.contains('maintenance')) return const Color(0xFF1565C0);
    return const Color(0xFF1565C0);
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  final bool monospace;
  const _Chip({
    required this.text,
    required this.bg,
    required this.fg,
    this.monospace = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = monospace
        ? GoogleFonts.jetBrainsMono(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: fg,
          )
        : GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: fg,
            letterSpacing: 0.1,
          );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(text, style: style),
    );
  }
}

// ─── Indian formulations section (Neofax) ───────────────────────────────────

class _FormulationsSection extends StatelessWidget {
  final List<FormulationEntry> items;
  const _FormulationsSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.medication_outlined,
      title: 'Indian formulations & brands',
      tint: const Color(0xFF00897B),
      initiallyExpanded: false,
      trailing: _Pill(label: '${items.length}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _FormulationCard(item: items[i]),
          ],
        ],
      ),
    );
  }
}

class _FormulationCard extends StatelessWidget {
  final FormulationEntry item;
  const _FormulationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.form.isNotEmpty)
            Text(
              item.form,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
              ),
            ),
          if (item.strength.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              item.strength,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: cs.onSurface,
              ),
            ),
          ],
          if (item.brandsIndia.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: item.brandsIndia
                  .map((b) => _Chip(
                        text: b,
                        bg: const Color(0xFF00897B).withValues(alpha: 0.12),
                        fg: const Color(0xFF00695C),
                      ))
                  .toList(),
            ),
          ],
          if (item.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(9),
                border: const Border(
                  left: BorderSide(color: Color(0xFF00695C), width: 2),
                ),
              ),
              child: Text(
                item.notes,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  const _Pill({required this.label});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: cs.onPrimaryContainer,
        ),
      ),
    );
  }
}

// ─── Preparation section ─────────────────────────────────────────────────────

class _PreparationSection extends StatelessWidget {
  final String reconstitutionMd;
  final String incompatibilitiesMd;
  const _PreparationSection({
    required this.reconstitutionMd,
    required this.incompatibilitiesMd,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.science_outlined,
      title: 'Preparation',
      tint: const Color(0xFF00695C),
      initiallyExpanded: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reconstitutionMd.isNotEmpty) ...[
            const _SubLabel(text: 'Reconstitution & dilution'),
            const SizedBox(height: 6),
            _MdBody(text: reconstitutionMd),
          ],
          if (incompatibilitiesMd.isNotEmpty) ...[
            if (reconstitutionMd.isNotEmpty) const SizedBox(height: 14),
            const _SubLabel(text: 'Incompatibilities'),
            const SizedBox(height: 6),
            _MdBody(text: incompatibilitiesMd),
          ],
        ],
      ),
    );
  }
}

class _RenalHepaticContent extends StatelessWidget {
  final String renal;
  final String hepatic;
  const _RenalHepaticContent({required this.renal, required this.hepatic});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (renal.isNotEmpty) ...[
          const _SubLabel(text: 'Renal'),
          const SizedBox(height: 6),
          _MdBody(text: renal),
        ],
        if (hepatic.isNotEmpty) ...[
          if (renal.isNotEmpty) const SizedBox(height: 14),
          const _SubLabel(text: 'Hepatic'),
          const SizedBox(height: 6),
          _MdBody(text: hepatic),
        ],
      ],
    );
  }
}

class _SubLabel extends StatelessWidget {
  final String text;
  const _SubLabel({required this.text});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.0,
        color: cs.onSurfaceVariant,
      ),
    );
  }
}

// ─── Disclaimer footer ───────────────────────────────────────────────────────

class _DisclaimerBanner extends StatelessWidget {
  final VoidCallback onOpenPdf;
  final int page;
  final String source;
  const _DisclaimerBanner({
    required this.onOpenPdf,
    required this.page,
    required this.source,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 16, color: cs.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'For qualified clinicians. Verify every dose against your local protocol and the current vial / formulation strength before administration.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onOpenPdf,
              icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
              label: Text(
                page > 0
                    ? 'Open $source (page $page)'
                    : 'Open $source PDF',
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

// ═══════════════════════════════════════════════════════════════════════════
// Markdown rendering
// ═══════════════════════════════════════════════════════════════════════════

/// Renders a small Markdown subset:
///   - **bold**            → bold span
///   - lines starting with `- ` or `• ` or `* `  → bullet
///   - blank-line separated → paragraph break
///   - "Label: value" prefix at line start → label auto-bolded
///
/// All content is preserved verbatim — no truncation, no omission. Long
/// blobs of unstructured text become a single paragraph; the section card
/// itself controls whether the user has to expand to see them.
class _MdBody extends StatelessWidget {
  final String text;
  final bool emphasiseRed;
  const _MdBody({required this.text, this.emphasiseRed = false});

  @override
  Widget build(BuildContext context) {
    final blocks = _parseBlocks(text);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < blocks.length; i++) ...[
          if (i > 0) const SizedBox(height: 6),
          _renderBlock(context, blocks[i]),
        ],
      ],
    );
  }

  Widget _renderBlock(BuildContext context, _MdBlock b) {
    final cs = Theme.of(context).colorScheme;
    final bodyColor = emphasiseRed ? const Color(0xFFB71C1C) : cs.onSurface;
    final base = GoogleFonts.plusJakartaSans(
      fontSize: 13.5,
      fontWeight: FontWeight.w500,
      height: 1.5,
      color: bodyColor,
    );
    final bold = base.copyWith(fontWeight: FontWeight.w800);

    switch (b.kind) {
      case _BlockKind.bulletList:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final item in b.items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7, right: 8),
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: emphasiseRed
                              ? const Color(0xFFB71C1C)
                              : cs.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: base,
                          children: _inlineSpans(item, base, bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      case _BlockKind.paragraph:
        return RichText(
          text: TextSpan(
            style: base,
            children: _inlineSpans(b.text, base, bold),
          ),
        );
    }
  }

  /// Split a markdown blob into paragraph + bullet blocks. Preserves all
  /// content; only changes layout.
  static List<_MdBlock> _parseBlocks(String input) {
    final lines = input.replaceAll('\r\n', '\n').split('\n');
    final out = <_MdBlock>[];
    final paraBuf = <String>[];
    final bulletBuf = <String>[];

    void flushPara() {
      if (paraBuf.isEmpty) return;
      final joined = paraBuf.map((l) => l.trim()).join(' ');
      if (joined.isNotEmpty) {
        out.add(_MdBlock.paragraph(joined));
      }
      paraBuf.clear();
    }

    void flushBullets() {
      if (bulletBuf.isEmpty) return;
      out.add(_MdBlock.bulletList(List.of(bulletBuf)));
      bulletBuf.clear();
    }

    for (final raw in lines) {
      final line = raw.trimRight();
      if (line.trim().isEmpty) {
        flushPara();
        flushBullets();
        continue;
      }
      final m = _bulletPrefix.firstMatch(line);
      if (m != null) {
        flushPara();
        bulletBuf.add(line.substring(m.end).trim());
      } else {
        flushBullets();
        // Markdown hard line-break: trailing two spaces.
        if (line.endsWith('  ')) {
          paraBuf.add(line.substring(0, line.length - 2));
          flushPara();
        } else {
          paraBuf.add(line);
        }
      }
    }
    flushPara();
    flushBullets();
    return out;
  }

  /// Split `**bold**` segments. Auto-bold "Label:" prefixes at the start
  /// of a paragraph (Reconstitution: ..., Loading: ..., Max: ...) so the
  /// reader's eye locks on the key term.
  static List<InlineSpan> _inlineSpans(
      String s, TextStyle base, TextStyle boldStyle) {
    final spans = <InlineSpan>[];

    final prefixMatch = _autoBoldPrefix.firstMatch(s);
    int startAt = 0;
    if (prefixMatch != null && !s.substring(0, prefixMatch.end).contains('**')) {
      spans.add(TextSpan(text: prefixMatch.group(0), style: boldStyle));
      startAt = prefixMatch.end;
    }

    final body = s.substring(startAt);
    final pat = RegExp(r"\*\*(.+?)\*\*", dotAll: true);
    int i = 0;
    for (final m in pat.allMatches(body)) {
      if (m.start > i) {
        spans.add(TextSpan(text: body.substring(i, m.start)));
      }
      spans.add(TextSpan(text: m.group(1), style: boldStyle));
      i = m.end;
    }
    if (i < body.length) {
      spans.add(TextSpan(text: body.substring(i)));
    }
    return spans;
  }

  static final _bulletPrefix = RegExp(r'^\s*(?:[-•*]\s+|\d+[.)]\s+)');
  static final _autoBoldPrefix = RegExp(r'^[A-Z][\w\s\-/]{1,32}:\s+');
}

enum _BlockKind { paragraph, bulletList }

class _MdBlock {
  final _BlockKind kind;
  final String text;
  final List<String> items;
  const _MdBlock._(this.kind, this.text, this.items);
  factory _MdBlock.paragraph(String s) =>
      _MdBlock._(_BlockKind.paragraph, s, const []);
  factory _MdBlock.bulletList(List<String> items) =>
      _MdBlock._(_BlockKind.bulletList, '', items);
}

// ═══════════════════════════════════════════════════════════════════════════
// Auto-extraction: Quick Summary
// ═══════════════════════════════════════════════════════════════════════════

class QuickSummary {
  final List<String> routes;
  final String? keyDose;
  final String? infusionDuration;
  final String? maxDose;
  final String? majorToxicity;
  final String? primaryMonitoring;

  const QuickSummary({
    required this.routes,
    this.keyDose,
    this.infusionDuration,
    this.maxDose,
    this.majorToxicity,
    this.primaryMonitoring,
  });

  bool get hasContent =>
      routes.isNotEmpty ||
      keyDose != null ||
      infusionDuration != null ||
      maxDose != null ||
      majorToxicity != null ||
      primaryMonitoring != null;

  factory QuickSummary.fromDrug(DrugV2 drug) {
    // ── Routes: collect every IV/IM/PO/etc. token mentioned in route_hint
    //   or inside dose narratives, deduped, in insertion order.
    final routes = <String>{};
    for (final block in drug.doseBlocks) {
      for (final p in block.populations) {
        if (p.routeHint.isNotEmpty) {
          routes.addAll(_extractRouteTokens(p.routeHint));
        }
        routes.addAll(_extractRouteTokens(p.doseMd));
      }
    }
    const allowed = {
      'IV', 'IM', 'PO', 'PR', 'SC', 'IO', 'ETT',
      'NG', 'SL', 'INH', 'NEB', 'TOPICAL',
    };
    final filteredRoutes = routes
        .map((r) => r.toUpperCase())
        .where(allowed.contains)
        .toList();

    // ── Key dose: first numeric+unit value in any dose narrative.
    String? keyDose;
    for (final block in drug.doseBlocks) {
      for (final p in block.populations) {
        final m = _firstDoseRe.firstMatch(p.doseMd);
        if (m != null) {
          keyDose = _stripBold(m.group(0)!).trim();
          break;
        }
      }
      if (keyDose != null) break;
    }

    // ── Max dose
    String? maxDose;
    for (final block in drug.doseBlocks) {
      for (final p in block.populations) {
        final m = _maxDoseRe.firstMatch(p.doseMd);
        if (m != null) {
          maxDose = _stripBold(m.group(1)!).trim();
          break;
        }
      }
      if (maxDose != null) break;
    }

    // ── Infusion duration
    String? infusion;
    for (final block in drug.doseBlocks) {
      for (final p in block.populations) {
        final m = _infusionRe.firstMatch(p.doseMd);
        if (m != null) {
          infusion = _stripBold(m.group(0)!).trim();
          break;
        }
      }
      if (infusion != null) break;
    }

    // ── Major toxicity: first sentence of adverse_effects (capped).
    String? majorTox;
    if (drug.adverseEffectsMd.trim().isNotEmpty) {
      majorTox = _firstSentence(drug.adverseEffectsMd, maxLen: 110);
    }

    // ── Primary monitoring: first sentence of monitoring_md.
    String? primaryMon;
    if (drug.monitoringMd.trim().isNotEmpty) {
      primaryMon = _firstSentence(drug.monitoringMd, maxLen: 110);
    }

    return QuickSummary(
      routes: filteredRoutes,
      keyDose: keyDose,
      infusionDuration: infusion,
      maxDose: maxDose,
      majorToxicity: majorTox,
      primaryMonitoring: primaryMon,
    );
  }

  /// Pull route tokens out of a string. Recognises both bare tokens
  /// (e.g. "IV") and slash-separated combos (e.g. "IM/IV", "IV/PO").
  static Iterable<String> _extractRouteTokens(String s) sync* {
    for (final m in _routeTokenRe.allMatches(s)) {
      final hit = m.group(0)!;
      for (final part in hit.split(RegExp(r'[/,\-+]'))) {
        final t = part.trim().toUpperCase();
        if (t.isNotEmpty) yield t;
      }
    }
  }

  static String _stripBold(String s) =>
      s.replaceAll('**', '').replaceAll('  \n', ' ').trim();

  static String _firstSentence(String input, {int maxLen = 120}) {
    final s = input.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
    final m = RegExp(r'^([^.;]+[.;])').firstMatch(s);
    final base = m != null ? m.group(1)! : s;
    if (base.length <= maxLen) return base.trim();
    return '${base.substring(0, maxLen).trim()}…';
  }

  static final _routeTokenRe = RegExp(
    r'(?<![A-Za-z])'
    r'(?:IV|IM|PO|PR|SC|IO|ETT|NG|SL|INH|NEB|TOPICAL)'
    r'(?:\s*/\s*(?:IV|IM|PO|PR|SC|IO|ETT|NG|SL|INH|NEB|TOPICAL))*'
    r'(?![A-Za-z])',
  );

  // Match a leading dose value with units, e.g. "**0.05 mg/kg**", "20 mg/kg",
  // "5–10 mg/kg/dose", "10 mcg/kg/min". Captures the whole match.
  static final _firstDoseRe = RegExp(
    r'\*?\*?'
    r'\d+(?:\.\d+)?(?:[–\-]\d+(?:\.\d+)?)?\s*'
    r'(?:mg|mcg|µg|g|U|IU|mEq|mmol|mL|ng)'
    r'(?:/kg)?(?:/dose|/day|/24\s*hr|/hr|/min)?'
    r'\*?\*?',
    caseSensitive: false,
  );

  static final _maxDoseRe = RegExp(
    r'\*?\*?Max(?:\.|imum)?(?:\s+(?:single|daily|subsequent))?(?:\s+dose)?\*?\*?\s*:?\s*'
    r'\*?\*?'
    r'(\d+(?:\.\d+)?(?:[–\-]\d+(?:\.\d+)?)?\s*'
    r'(?:mg|mcg|µg|g|U|IU|mEq|mmol|mL|ng)'
    r'(?:/kg)?(?:/dose|/day|/24\s*hr|/hr|/min)?)'
    r'\*?\*?',
    caseSensitive: false,
  );

  static final _infusionRe = RegExp(
    r'(?:over|infuse(?:d)?\s+over|administered?\s+over)\s+'
    r'\d+(?:[–\-]\d+)?\s*(?:min|minute|second|hour|h)s?',
    caseSensitive: false,
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// Toxicity splitter (Common vs Serious)
// ═══════════════════════════════════════════════════════════════════════════

/// Splits an adverse-effects narrative into "Common" and "Serious" buckets
/// using sentence-level keyword matching. NEVER drops content — every
/// sentence ends up in exactly one bucket. Preserves the original wording
/// verbatim within each bucket.
class ToxicitySplit {
  final String commonMd;
  final String seriousMd;
  const ToxicitySplit({required this.commonMd, required this.seriousMd});

  factory ToxicitySplit.from(String adverseEffectsMd) {
    final src = adverseEffectsMd.trim();
    if (src.isEmpty) return const ToxicitySplit(commonMd: '', seriousMd: '');

    final sentences = _splitSentences(src);
    final common = <String>[];
    final serious = <String>[];
    for (final s in sentences) {
      if (_isSerious(s)) {
        serious.add(s);
      } else {
        common.add(s);
      }
    }
    return ToxicitySplit(
      commonMd: common.join(' ').trim(),
      seriousMd: serious.join(' ').trim(),
    );
  }

  static bool _isSerious(String s) {
    final l = s.toLowerCase();
    for (final kw in _seriousKeywords) {
      if (l.contains(kw)) return true;
    }
    return false;
  }

  static List<String> _splitSentences(String s) {
    final norm = s.replaceAll('\r\n', '\n').replaceAll('\n', ' ');
    final out = <String>[];
    final re = RegExp(r'[^.;!?]+[.;!?]+|[^.;!?]+$');
    for (final m in re.allMatches(norm)) {
      final t = m.group(0)!.trim();
      if (t.isNotEmpty) out.add(t);
    }
    return out;
  }

  static const List<String> _seriousKeywords = [
    'fatal', 'death', 'mortality',
    'life-threatening', 'life threatening',
    'cardiac arrest', 'arrhythmia', 'asystole', 'torsades',
    'respiratory depression', 'respiratory arrest', 'apnea', 'apnoea',
    'anaphylaxis', 'anaphylactoid',
    'stevens-johnson', 'stevens johnson', 'toxic epidermal necrolysis',
    'agranulocytosis', 'aplastic anemia', 'aplastic anaemia',
    'bone marrow suppression', 'pancytopenia', 'neutropenia',
    'severe hepatotoxicity', 'hepatic failure', 'fulminant hepatic',
    'renal failure', 'acute kidney injury',
    'nephrotoxicity',
    'ototoxicity',
    'seizure', 'status epilepticus',
    'qt prolongation', 'qtc prolongation',
    'severe hypotension', 'shock',
    'kernicterus',
    'extravasation',
    'tissue necrosis',
    'syndrome of inappropriate', 'siadh',
    'severe allergic',
    'angioedema',
    'rhabdomyolysis',
    'serotonin syndrome', 'neuroleptic malignant',
    'malignant hyperthermia',
    'lactic acidosis',
    'thromboembolism', 'pulmonary embolism',
    'intracranial hemorrhage', 'intracranial haemorrhage',
    'methemoglobinemia',
    'cardiogenic shock',
    'severe bronchospasm',
    'pancreatitis',
  ];
}
