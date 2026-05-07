// =============================================================================
// onboarding/onboarding_screen.dart
//
// 6 slides shown ONCE at first launch, between splash and home/login:
//   1. WELCOME       Logo hero + tagline
//   2. CALCULATORS   40+ bedside calculators
//   3. FORMULARY     676 drugs with premium detail UI
//   4. EMERGENCY     STAT bolus / infusion drugs + acute-care guides
//   5. GUIDELINES    IAP STG · NNF CPG · WHO / IAP / Fenton growth charts
//   6. SEARCH        Single search bar across the whole app
//
// Persisted via PrefsKeys.onboardingComplete (versioned: '_v2'). A redesign
// bumps the suffix to re-show the slides to existing users.
//
// Skip from any slide marks onboarding done — we never re-show on retry.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/prefs_keys.dart';

class OnboardingScreen extends StatefulWidget {
  /// Called once the user finishes (or skips) the slides. The host should
  /// route to home / login as appropriate.
  final VoidCallback onDone;
  const OnboardingScreen({super.key, required this.onDone});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _ctrl = PageController();
  int _index = 0;

  static const _slides = <_Slide>[
    _Slide(
      eyebrow: 'Welcome',
      title: 'PediAid',
      tagline: 'Paediatrics & neonatology — bedside-ready.',
      body:
          'One app for the calculators, drug doses, growth charts, '
          'guidelines and emergency protocols you reach for every shift. '
          'Works offline once loaded. Patient inputs never leave the device.',
      assetPath: 'assets/icon/app_icon.png',
      icon: Icons.medical_services_outlined,
      gradient: [Color(0xFF0D47A1), Color(0xFF1976D2)],
    ),
    _Slide(
      eyebrow: 'Calculators',
      title: '40+ bedside\ncalculators.',
      tagline: 'Numbers in, decision out.',
      body:
          'GIR, blood gas, jaundice (AAP 2022 + NICE CG98), maintenance '
          'fluids, BP centiles, electrolyte corrections, ETT size + depth, '
          'umbilical catheter depth, dextrose bolus, free-water deficit, '
          '2D echo z-scores — every result shows the formula and source.',
      icon: Icons.calculate_rounded,
      gradient: [Color(0xFF1565C0), Color(0xFF42A5F5)],
    ),
    _Slide(
      eyebrow: 'Drug formulary',
      title: '676 drugs,\none clean view.',
      tagline: 'Neofax (199) + Harriet Lane (478)',
      body:
          'Every drug rendered the same way: Quick Summary up top, then '
          'Dose · Preparation · Monitoring · Common vs Serious adverse '
          'effects · Contraindications · Renal / Hepatic adjustment. '
          'India brand names included where available. Original PDFs '
          'one tap away as escape hatch.',
      icon: Icons.medication_rounded,
      gradient: [Color(0xFF00897B), Color(0xFF26A69A)],
    ),
    _Slide(
      eyebrow: 'Emergency',
      title: 'Built for the\ncrash cart.',
      tagline: 'STAT bolus + infusion drugs in seconds',
      body:
          'Emergency NICU and PICU drug bundles with live weight-based '
          'preparation. Acute severe asthma, DKA, RSI, status epilepticus, '
          'snake / scorpion envenomation, hypertensive emergency, '
          'electrolyte corrections — all one tap from the home screen.',
      icon: Icons.emergency_outlined,
      gradient: [Color(0xFFB71C1C), Color(0xFFE53935)],
    ),
    _Slide(
      eyebrow: 'Guidelines & charts',
      title: 'Sources you trust,\nat the bedside.',
      tagline: 'IAP STG · NNF CPG · WHO · Fenton',
      body:
          'IAP Standard Treatment Guidelines 2022, IAP Action Plan 2026, '
          'NNF CPG, AAP Red Book reference. WHO + IAP + Fenton + '
          'INTERGROWTH growth charts with z-score and centile plotting. '
          'Lab reference values banded by age and gestation.',
      icon: Icons.menu_book_rounded,
      gradient: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
    ),
    _Slide(
      eyebrow: 'Search anything',
      title: 'One search bar,\neverything inside.',
      tagline: 'Type "uti" · "2d echo" · "vanc"',
      body:
          'Tap the search icon on the home screen. Drugs, calculators, '
          'guides, growth charts, IAP STG and NNF CPG chapters, lab '
          'reference — all reachable from one query box. Common '
          'abbreviations (UTI, DKA, RSI, APAP, ETT, EBV, SGA…) resolve '
          'to the right tool.',
      icon: Icons.search_rounded,
      gradient: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
    ),
  ];

  Future<void> _markDone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(PrefsKeys.onboardingComplete, true);
    } catch (_) {/* fine — onboarding will re-show next launch */}
    widget.onDone();
  }

  void _next() {
    if (_index >= _slides.length - 1) {
      _markDone();
    } else {
      _ctrl.nextPage(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLast = _index == _slides.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar: back · step · skip ────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  if (_index > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      onPressed: () => _ctrl.previousPage(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOut),
                    )
                  else
                    const SizedBox(width: 48),
                  const Spacer(),
                  Text(
                    '${_index + 1} / ${_slides.length}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: cs.onSurface.withValues(alpha: 0.55),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _markDone,
                    style: TextButton.styleFrom(
                      foregroundColor: cs.onSurfaceVariant,
                    ),
                    child: Text(
                      'Skip',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Slides ─────────────────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                onPageChanged: (i) => setState(() => _index = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _SlideView(slide: _slides[i]),
              ),
            ),

            // ── Dot indicator ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _index ? 26 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _index
                          ? cs.primary
                          : cs.onSurface.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // ── CTA ────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 22),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLast ? 'Open PediAid' : 'Continue',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isLast ? Icons.check_rounded : Icons.arrow_forward_rounded,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}

class _Slide {
  final String eyebrow;
  final String title;
  /// Short one-liner under the title — sub-heading, before the full body.
  final String tagline;
  final String body;
  final IconData icon;
  /// If non-null, render this PNG inside the gradient hero instead of the
  /// fallback [icon]. Used by the welcome slide to show the actual logo.
  final String? assetPath;
  final List<Color> gradient;
  const _Slide({
    required this.eyebrow,
    required this.title,
    required this.tagline,
    required this.body,
    required this.icon,
    this.assetPath,
    required this.gradient,
  });
}

class _SlideView extends StatelessWidget {
  final _Slide slide;
  const _SlideView({required this.slide});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ConstrainedBox(
      // Cap the readable column on wide viewports (web / tablet) so the
      // body copy doesn't sprawl across 1200 px.
      constraints: const BoxConstraints(maxWidth: 520),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Hero ─────────────────────────────────────────────────────
            //
            // For slides with an asset (the welcome slide), show the logo
            // PNG on its own — its blue background is part of the brand,
            // wrapping it in another coloured gradient looked busy. Other
            // slides use the gradient hero with a white icon.
            slide.assetPath != null
                ? Container(
                    width: 176,
                    height: 176,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: slide.gradient.last.withValues(alpha: 0.32),
                          blurRadius: 30,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      slide.assetPath!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 168,
                    height: 168,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: slide.gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: slide.gradient.last.withValues(alpha: 0.38),
                          blurRadius: 32,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(slide.icon, color: Colors.white, size: 72),
                    ),
                  ),
            const SizedBox(height: 38),

            // ── Eyebrow chip ─────────────────────────────────────────────
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                slide.eyebrow.toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                  color: cs.primary,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ── Title ────────────────────────────────────────────────────
            Text(
              slide.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                height: 1.15,
                letterSpacing: -0.5,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            // ── Tagline ──────────────────────────────────────────────────
            Text(
              slide.tagline,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: cs.primary,
                letterSpacing: 0.05,
              ),
            ),
            const SizedBox(height: 14),

            // ── Body ─────────────────────────────────────────────────────
            Text(
              slide.body,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                height: 1.55,
                fontWeight: FontWeight.w500,
                color: cs.onSurface.withValues(alpha: 0.70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
