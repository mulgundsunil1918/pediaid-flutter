// =============================================================================
// lib/screens/guides/developmental_milestones/dev_milestones_hub.dart
//
// Landing screen for the Developmental Milestones module. Five entry tiles:
//   1. Smart View       — bidirectional age ↔ behaviour lookup
//   2. Browse by Domain — full list grouped by Gross / Fine / Language /
//                          Hearing / Socioadaptive / Vision
//   3. Red Flags        — every age × domain flag from the AIIMS handout
//   4. Developmental Quotient — DQ per domain + interpretation
//   5. Trivandrum DSC   — placeholder, full TDSC chart coming later
//
// Source: AIIMS New Delhi · Department of Paediatrics · Child Neurology
// Division (Prof. Sheffali Gulati) — verbatim. Cross-source enrichments
// for DQ interpretation bands from Nelson + Ghai.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dev_milestones_smart_view.dart';
import 'dev_milestones_list_view.dart';
import 'dev_milestones_red_flags.dart';
import 'dev_quotient_calculator.dart';
import 'dev_milestones_trivandrum.dart';

class DevMilestonesHub extends StatelessWidget {
  const DevMilestonesHub({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developmental Milestones'),
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
            // Source attribution banner — clinicians need to see provenance
            // before trusting any developmental tool.
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  Icon(Icons.verified_outlined, color: cs.primary, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AIIMS New Delhi reference',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '76 milestones · 23 red flags across 6 domains. Source: Child Neurology Division, Department of Paediatrics, AIIMS New Delhi (Prof. Sheffali Gulati). Enriched with Nelson + Ghai for DQ bands.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            height: 1.45,
                            fontWeight: FontWeight.w500,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _HubTile(
              icon: Icons.auto_awesome_rounded,
              tint: const Color(0xFF1565C0),
              title: 'Smart View',
              subtitle:
                  'Pick an age → see expected milestones · OR pick what the child is doing → estimate developmental age',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DevMilestonesSmartView())),
            ),
            _HubTile(
              icon: Icons.list_alt_rounded,
              tint: const Color(0xFF6A1B9A),
              title: 'Browse by Domain',
              subtitle:
                  '6 domains · Gross Motor · Fine Motor · Language · Hearing · Socioadaptive · Vision',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DevMilestonesListView())),
            ),
            _HubTile(
              icon: Icons.warning_amber_rounded,
              tint: const Color(0xFFB71C1C),
              title: 'Red Flags',
              subtitle:
                  '23 age × domain red flags — when each warrants formal developmental assessment',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DevMilestonesRedFlags())),
            ),
            _HubTile(
              icon: Icons.calculate_rounded,
              tint: const Color(0xFF00897B),
              title: 'Developmental Quotient',
              subtitle:
                  'DQ = (Developmental age / Chronological age) × 100 · per-domain calculation with interpretation bands',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DevQuotientCalculator())),
            ),
            _HubTile(
              icon: Icons.assignment_turned_in_outlined,
              tint: const Color(0xFFE65100),
              title: 'Trivandrum DSC',
              subtitle: 'Trivandrum Developmental Screening Chart — coming soon',
              comingSoon: true,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DevTrivandrumPlaceholder())),
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
  final bool comingSoon;
  const _HubTile({
    required this.icon,
    required this.tint,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.comingSoon = false,
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
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (comingSoon) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE65100)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'SOON',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                color: const Color(0xFFE65100),
                              ),
                            ),
                          ),
                        ],
                      ],
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
              'For qualified clinicians. The milestone ages are the AGES BY WHICH most healthy children achieve the skill — failure to achieve at the listed age does not equal pathology, but it should trigger formal screening. Always correct gestational age for infants ≤ 24 months.',
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
