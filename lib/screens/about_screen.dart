// =============================================================================
// lib/screens/about_screen.dart
//
// "About" page for the PediAid app. Reached from the home drawer menu.
// Shows the developer's credentials and a short bio explaining why PediAid
// exists, plus a short tag-line for PediAid Academics.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Avatar + name card ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: cs.primary,
                    child: Icon(
                      Icons.medical_services_rounded,
                      size: 30,
                      color: cs.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. Sunil Mulgund',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Paediatrician · Neonatologist · Developer of PediAid',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: cs.onSurface.withValues(alpha: 0.7),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Credentials ─────────────────────────────────────────────
            _SectionLabel(label: 'Credentials', color: cs.primary),
            const SizedBox(height: 10),
            _BulletRow(text: 'MBBS'),
            _BulletRow(text: 'MD (Paediatrics)'),
            _BulletRow(text: 'DNB (Paediatrics)'),
            _BulletRow(text: 'NNF Fellowship in Neonatology'),

            const SizedBox(height: 24),

            // ── Bio ─────────────────────────────────────────────────────
            _SectionLabel(label: 'About the developer', color: cs.primary),
            const SizedBox(height: 10),
            Text(
              "I'm a practising paediatrician and neonatologist. Day to day on "
              "the wards I kept reaching for the same handful of things — "
              "weight-based drug doses, growth charts, jaundice curves, lab "
              "ranges, quick reference to the latest guidelines — and every "
              "time I was fishing them out of a different app, a textbook, a "
              "photocopy, or a saved PDF on my phone.\n\n"
              "I wanted to make life a little less miserable and a lot more "
              "organised.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                height: 1.65,
                color: cs.onSurface,
              ),
            ),

            const SizedBox(height: 24),

            // ── About PediAid Academics ─────────────────────────────────
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: cs.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_stories_rounded,
                        size: 18,
                        color: cs.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'About PediAid Academics',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'A clinical reference, calculator suite, and peer-reviewed '
                    'teaching library — built by a paediatrician, for '
                    'paediatricians and trainees.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      height: 1.6,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Footer ──────────────────────────────────────────────────
            Center(
              child: Text(
                'PediAid v1.0.0',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: cs.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Small helper widgets
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 10, left: 2),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: cs.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: cs.onSurface,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
