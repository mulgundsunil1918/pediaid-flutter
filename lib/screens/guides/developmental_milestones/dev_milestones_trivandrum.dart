// =============================================================================
// lib/screens/guides/developmental_milestones/dev_milestones_trivandrum.dart
//
// Placeholder screen for the Trivandrum Developmental Screening Chart
// (TDSC). The full chart will be implemented in a later iteration; for
// now we surface what TDSC is, who uses it, and how it differs from the
// AIIMS milestone reference so the user knows the module is intentionally
// reserved here.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DevTrivandrumPlaceholder extends StatelessWidget {
  const DevTrivandrumPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 24),
          children: [
            // Coming-soon banner
            Container(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              decoration: BoxDecoration(
                color: const Color(0xFFE65100).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: const Color(0xFFE65100).withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.engineering_outlined,
                          color: Color(0xFFE65100), size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'COMING SOON',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: const Color(0xFFE65100),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The full Trivandrum Developmental Screening Chart (TDSC-2013) will land here in a future update — interactive item-by-item scoring, automated pass/fail across 17 age groups, and chronological-age + corrected-age handling.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            _InfoSection(
              title: 'What is the TDSC?',
              icon: Icons.help_outline_rounded,
              children: [
                'Trivandrum Developmental Screening Chart (TDSC) is an Indian-validated developmental screening tool developed by the Child Development Centre, Medical College, Thiruvananthapuram.',
                'TDSC-2013 is the current revision — 51 items spread across 17 age sections from 0 to 6 years.',
                'It is a screening tool, not a diagnostic test — children who fail are referred for formal developmental assessment (e.g. DASII, BSID-III).',
              ],
            ),
            _InfoSection(
              title: 'Why use it (vs the AIIMS handout)?',
              icon: Icons.compare_arrows_rounded,
              children: [
                'The AIIMS milestone reference (in this module) lists what a child should be doing at each age — useful for clinical surveillance.',
                'TDSC asks the parent / clinician a fixed set of pass-fail items at the visit age, then declares "passed" or "failed" the screen — useful for outpatient screening at routine well-child visits.',
                'TDSC items are India-specific and validated against the Bayley scales in Indian children, which makes its sensitivity / specificity directly applicable to our population.',
              ],
            ),
            _InfoSection(
              title: 'Until then',
              icon: Icons.lightbulb_outline_rounded,
              children: [
                'Use the Smart View → "By Age" mode to see what milestones the child should have achieved at the visit age.',
                'Use the Smart View → "By Behaviour" mode to tick achieved milestones and get an estimated developmental age per domain.',
                'Use the Developmental Quotient calculator to compute DQ once you know the developmental age in each domain.',
                'Refer to the Red Flags tab for age × domain cutoffs that warrant onward referral.',
              ],
            ),
            const SizedBox(height: 8),
            Container(
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
                      'TDSC-2013 reference: Nair et al. Indian Pediatrics 2013;50:837–840. The screening chart itself is published by the Child Development Centre, Trivandrum.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> children;
  const _InfoSection({
    required this.title,
    required this.icon,
    required this.children,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 17, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final c in children) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6, right: 8),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      c,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
