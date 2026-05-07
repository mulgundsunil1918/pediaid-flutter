// =============================================================================
// formulary_v2_hub.dart
// PediAid Drug Formulary 2.0 — hub screen with section tiles.
// First section live: Neonatology (Neofax-derived, 199 drugs).
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'neonatology_list_screen.dart';
import 'paediatrics_list_screen.dart';

class FormularyV2Hub extends StatelessWidget {
  const FormularyV2Hub({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Drug Formulary 2.0',
            style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800, fontSize: 18)),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        bottom: true,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Beta banner
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                border: Border.all(color: const Color(0xFFFFB300)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.science_outlined,
                      color: Color(0xFFE65100), size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'PediAid v2 — curated, copyright-safe formulary built '
                      'from public sources. Each entry has been '
                      'cross-checked against WHO WMFc, NNF CPG, AAP Red '
                      'Book, DailyMed, IAP Drug Formulary. Verify every '
                      'dose against your local protocol before use.',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: const Color(0xFF7F4F00),
                          fontWeight: FontWeight.w600,
                          height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            Text('Sections',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: cs.onSurface.withValues(alpha: 0.6))),
            const SizedBox(height: 10),

            _SectionTile(
              icon: Icons.child_care,
              color: const Color(0xFF1565C0),
              title: 'Neonatology Formulary',
              subtitle:
                  '199 drugs · Neofax-derived · India brand names · GA-band dosing',
              count: '199',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const NeonatologyListScreen()),
              ),
            ),
            const SizedBox(height: 10),
            _SectionTile(
              icon: Icons.people_alt_outlined,
              color: const Color(0xFF6A1B9A),
              title: 'Paediatrics Formulary  ·  BETA',
              subtitle:
                  '478 drugs · Harriet Lane-derived · Auto-extracted, awaiting full authoring',
              count: '478',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const PaediatricsListScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String count;
  final bool comingSoon;
  final VoidCallback? onTap;
  const _SectionTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.onTap,
    this.comingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: comingSoon
              ? cs.onSurface.withValues(alpha: 0.04)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: comingSoon
                  ? cs.onSurface.withValues(alpha: 0.10)
                  : color.withValues(alpha: 0.30),
              width: 1.2),
          boxShadow: comingSoon
              ? null
              : [
                  BoxShadow(
                      color: color.withValues(alpha: 0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: comingSoon
                              ? cs.onSurface.withValues(alpha: 0.55)
                              : cs.onSurface)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: cs.onSurface.withValues(alpha: 0.65),
                          height: 1.4)),
                  if (comingSoon) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: cs.onSurface.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('COMING SOON',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              color: cs.onSurface.withValues(alpha: 0.60))),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: comingSoon
                    ? cs.onSurface.withValues(alpha: 0.08)
                    : color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(count,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: comingSoon
                          ? cs.onSurface.withValues(alpha: 0.55)
                          : Colors.white)),
            ),
            if (!comingSoon) ...[
              const SizedBox(width: 4),
              Icon(Icons.chevron_right,
                  color: cs.onSurface.withValues(alpha: 0.45)),
            ],
          ],
        ),
      ),
    );
  }
}
