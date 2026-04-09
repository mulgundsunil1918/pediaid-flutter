// =============================================================================
// lib/screens/about_screen.dart
//
// "About" page for the PediAid app. Reached from the home drawer menu.
// Shows the developer's credentials and a short bio explaining why PediAid
// exists, plus a short tag-line for PediAid Academics.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

const String kSupportDeveloperUrl = 'https://www.chai4.me/mulgundsunil';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _openSupport(BuildContext context) async {
    final uri = Uri.parse(kSupportDeveloperUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't open the link.")),
        );
      }
    }
  }

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
            // ── Avatar + name + credentials card ────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                              'MBBS · MD (Paediatrics) · DNB (Paediatrics) · NNF Fellowship in Neonatology',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: cs.primary,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Paediatrician · Neonatologist · Developer of PediAid',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                color: cs.onSurface.withValues(alpha: 0.7),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

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
              "photocopy, or a saved PDF on my phone.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                height: 1.65,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "I wanted to make life a little less miserable and a lot more "
              "organised — one place where a paediatrician or paediatric "
              "trainee can walk onto a shift and get to the answer in seconds. "
              "Not ten tabs, not a group chat, not someone's printed 2017 "
              "handbook. Just the dose, the chart, the reference, the score.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                height: 1.65,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "PediAid is built and maintained single-handedly — every line "
              "of the Flutter app, the React academics web, the Fastify "
              "backend, and the Postgres schema. I'm not a full-time "
              "developer. I built this because I wanted it to exist, and "
              "because I hoped it would help other paediatricians and "
              "students the way I wish it had helped me during my training.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                height: 1.65,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Academics is the next step: a peer-reviewed teaching library "
              "where clinicians contribute chapters that other clinicians "
              "actually read, and where CMEs and webinars from across India "
              "can be shared in one place. If you're reading this and you've "
              "used PediAid on a busy shift — thank you. That's the whole "
              "reason this exists.",
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

            const SizedBox(height: 24),

            // ── Support the developer ──────────────────────────────────
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('☕️', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 8),
                      Text(
                        'Support the developer',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "I've built and maintain PediAid on my own — all the "
                    "coding, the servers, the databases, the domain, the "
                    "email infrastructure. It's free for every user and "
                    "always will be, but servers cost money every month to "
                    "keep running. If PediAid has saved you time on a "
                    "shift, consider buying me a chai — it directly helps "
                    "keep the app live and growing.",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      height: 1.55,
                      color: const Color(0xFF78350F),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _openSupport(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.favorite_rounded, size: 16),
                      label: Text(
                        'Buy me a chai',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Opens chai4.me in your browser. No account needed.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      color: const Color(0xFF92400E).withValues(alpha: 0.7),
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

