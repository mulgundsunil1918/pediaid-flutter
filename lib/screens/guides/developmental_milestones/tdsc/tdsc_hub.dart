// =============================================================================
// lib/screens/guides/developmental_milestones/tdsc/tdsc_hub.dart
//
// Landing for the Trivandrum Developmental Screening Chart (TDSC) module.
// Three sub-screens:
//   • Smart Screen   — type child's age → tick pass/fail → instant verdict
//   • Chart View     — full visual chart with vertical age cursor + table
//   • How to Read    — interpretation rules, caveats, citation
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tdsc_data.dart';
import 'tdsc_smart_screen.dart';
import 'tdsc_chart_view.dart';
import 'tdsc_interpretation.dart';

class TdscHub extends StatelessWidget {
  const TdscHub({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final totalItems = kTdscAll.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trivandrum DSC'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: SafeArea(
        bottom: true,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
          children: [
            // Header card — what this is + source
            Container(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.assignment_turned_in_outlined,
                          color: cs.primary, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'Two charts, merged',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Chart 1 (1–34 mo) — 27 items.   Chart 2 (36–72 mo) — 24 items.   Total $totalItems items across the full 0–6-year window.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Source: Child Development Centre, Trivandrum Medical College, Kerala (Nair MK et al., Indian Pediatrics 2009 + 2013).',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      height: 1.45,
                      fontStyle: FontStyle.italic,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _HubTile(
              icon: Icons.auto_awesome_rounded,
              tint: const Color(0xFF1565C0),
              title: 'Smart Screen',
              subtitle:
                  'Enter age → tick PASS / FAIL on each crossed item → instant verdict (suspect vs not-suspect)',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const TdscSmartScreen())),
            ),
            _HubTile(
              icon: Icons.bar_chart_rounded,
              tint: const Color(0xFFE65100),
              title: 'Chart View',
              subtitle:
                  'Both charts as horizontal bars with a draggable age cursor. Tap a bar to read the prompt.',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const TdscChartView())),
            ),
            _HubTile(
              icon: Icons.menu_book_outlined,
              tint: const Color(0xFF6A1B9A),
              title: 'How to Read & Interpret',
              subtitle:
                  'Screening rule, vertical age-line method, age correction, what "suspect" actually means.',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const TdscInterpretationScreen())),
            ),
            const SizedBox(height: 18),
            _DisclaimerCard(),
          ],
        ),
      ),
    );
  }
}

class _HubTile extends StatelessWidget {
  final IconData icon;
  final Color tint;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _HubTile({
    required this.icon,
    required this.tint,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.55)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: tint, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.chevron_right_rounded,
                  color: cs.onSurface.withValues(alpha: 0.35)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              size: 16, color: cs.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'TDSC is a SCREEN, not a diagnostic test. A "suspect" result triggers formal developmental assessment (Bayley / DASII / Vineland), it does not by itself diagnose delay. For preterm infants ≤ 24 mo always use age corrected for prematurity.',
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
    );
  }
}
