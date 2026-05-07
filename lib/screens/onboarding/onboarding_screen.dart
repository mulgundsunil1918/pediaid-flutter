// =============================================================================
// onboarding/onboarding_screen.dart
//
// 4 slides shown ONCE at first launch, between splash and home/login:
//   1. PROBLEM      Bedside paediatric work juggles 8 references at once
//   2. SOLUTION     PediAid puts them in one fast app
//   3. HOW IT WORKS Real UI mock — calculator + chart + drug entry
//   4. CTA          Get started (or Sign in if your account exists)
//
// Persisted via PrefsKeys.onboardingComplete (versioned: '_v1'). A redesign
// bumps the suffix to re-show.
//
// Skip on slide 1 marks onboarding done — we never re-show on retry.
// =============================================================================

import 'package:flutter/material.dart';
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
      eyebrow: 'Why PediAid',
      title: 'Paediatric care\nshouldn\'t need 8 tabs.',
      body:
          'Right now: a calculator on one tab, growth chart on another, '
          'Neofax open in a PDF, IAP STG in a browser, NICE bilirubin '
          'on a printout. PediAid puts them in one fast offline app.',
      icon: Icons.layers_clear_outlined,
      gradient: [Color(0xFF1e3a5f), Color(0xFF3182ce)],
    ),
    _Slide(
      eyebrow: 'What it does',
      title: 'Bedside-ready\nclinical tools.',
      body:
          'Eighteen calculators, growth charts (WHO, IAP, Fenton), '
          'Neofax + Harriet Lane drug formulary, AAP 2022 + NICE CG98 '
          'jaundice pathways, NICU scores, lab references, IAP STG and '
          'NNF CPG — all searchable.',
      icon: Icons.medical_services_outlined,
      gradient: [Color(0xFF2c5282), Color(0xFF4fa8e0)],
    ),
    _Slide(
      eyebrow: 'How it works',
      title: 'Type. Tap. Done.',
      body:
          'Every calculator shows the formula, the safety bands and the '
          'source guideline on the result screen — so you can verify '
          'before you act. Patient inputs are never sent to our '
          'servers and are forgotten when you close the screen.',
      icon: Icons.touch_app_outlined,
      gradient: [Color(0xFF38a169), Color(0xFF2f855a)],
    ),
    _Slide(
      eyebrow: 'You\'re ready',
      title: 'Let\'s open\nthe toolbox.',
      body:
          'You can use everything without an account. Sign in only if '
          'you want the Academics web app, peer-reviewed chapters and '
          'CME tracking.',
      icon: Icons.rocket_launch_outlined,
      gradient: [Color(0xFFd69e2e), Color(0xFFb7791f)],
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
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == _slides.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar — back / step / skip
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
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.55),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _markDone,
                    child: const Text('Skip'),
                  ),
                ],
              ),
            ),

            // Slides
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                onPageChanged: (i) => setState(() => _index = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _SlideView(slide: _slides[i]),
              ),
            ),

            // Dots
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _index
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    isLast ? 'Get started' : 'Next',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
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
  final String body;
  final IconData icon;
  final List<Color> gradient;
  const _Slide({
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.icon,
    required this.gradient,
  });
}

class _SlideView extends StatelessWidget {
  final _Slide slide;
  const _SlideView({required this.slide});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Big gradient hero "card" with icon
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: slide.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: slide.gradient.last.withValues(alpha: 0.35),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Icon(slide.icon, color: Colors.white, size: 72),
          ),
          const SizedBox(height: 36),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(slide.eyebrow.toUpperCase(),
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: cs.primary,
                )),
          ),
          const SizedBox(height: 14),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.18,
              letterSpacing: -0.5,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            slide.body,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.55,
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
