// =============================================================================
// lib/screens/intro/intro_screen.dart
//
// PediAid first-launch tutorial — 5 pages, animated, dynamic.
//
//   1) Welcome           — logo drop-in + tagline
//   2) What's inside     — animated feature grid
//   3) Live demo         — working mini-GIR calculator with sliders
//   4) Personalize       — role chips + theme toggle
//   5) Ready             — final CTA into the app
//
// Shown on first launch (gated by SharedPreferences key `seen_intro_v2` from
// main.dart). Re-openable from Settings → "Show app tour again". Marked seen
// either when the user finishes (last page CTA) or skips. Each page enters
// with its own animation when it becomes the active page in the PageView, so
// content feels live rather than a static carousel.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/theme_provider.dart';
import '../../services/profile_store.dart';

const String kIntroSeenKey = 'seen_intro_v2';

class IntroScreen extends StatefulWidget {
  /// Called when the user finishes (or skips) the tutorial. The host should
  /// navigate to the home screen and not show the tutorial again this session.
  final VoidCallback onDone;
  const IntroScreen({super.key, required this.onDone});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pc = PageController();
  int _page = 0;

  // Personalize-page state lifted up so it survives page swipes.
  String? _selectedRole;

  static const int _totalPages = 5;

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  Future<void> _markSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(kIntroSeenKey, true);
    } catch (e) {
      debugPrint('[IntroScreen] markSeen failed: $e');
    }
  }

  Future<void> _persistRole() async {
    if (_selectedRole == null) return;
    try {
      final current = ProfileStore.instance.profile;
      await ProfileStore.instance.save(current.copyWith(specialty: _selectedRole));
    } catch (e) {
      debugPrint('[IntroScreen] persistRole failed: $e');
    }
  }

  Future<void> _finish() async {
    await _persistRole();
    await _markSeen();
    if (mounted) widget.onDone();
  }

  void _next() {
    if (_page < _totalPages - 1) {
      _pc.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  void _skip() {
    _markSeen();
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLast = _page == _totalPages - 1;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar: skip / progress dots ──────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
              child: Row(
                children: [
                  _DotsIndicator(count: _totalPages, current: _page),
                  const Spacer(),
                  if (!isLast)
                    TextButton(
                      onPressed: _skip,
                      style: TextButton.styleFrom(
                        foregroundColor: cs.onSurfaceVariant,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
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

            // ── Pages ──────────────────────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _pc,
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _WelcomePage(active: _page == 0),
                  _FeaturesPage(active: _page == 1),
                  _DemoPage(active: _page == 2),
                  _PersonalizePage(
                    active: _page == 3,
                    selectedRole: _selectedRole,
                    onRolePicked: (r) => setState(() => _selectedRole = r),
                  ),
                  _ReadyPage(active: _page == 4),
                ],
              ),
            ),

            // ── Bottom CTA ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Row(
                children: [
                  if (_page > 0)
                    IconButton(
                      onPressed: () => _pc.previousPage(
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOutCubic,
                      ),
                      icon: Icon(Icons.arrow_back_rounded, color: cs.onSurfaceVariant),
                      tooltip: 'Back',
                    )
                  else
                    const SizedBox(width: 48),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: _next,
                    style: FilledButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      textStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    icon: const SizedBox.shrink(),
                    label: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(isLast ? 'Open PediAid' : 'Continue'),
                          const SizedBox(width: 8),
                          Icon(
                            isLast ? Icons.check_rounded : Icons.arrow_forward_rounded,
                            size: 18,
                          ),
                        ],
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

// ─── Page 1: Welcome ─────────────────────────────────────────────────────────

class _WelcomePage extends StatefulWidget {
  final bool active;
  const _WelcomePage({required this.active});

  @override
  State<_WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<_WelcomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subFade;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _ac, curve: const Interval(0.0, 0.55, curve: Curves.elasticOut)),
    );
    _logoFade = CurvedAnimation(parent: _ac, curve: const Interval(0.0, 0.30));
    _titleFade = CurvedAnimation(parent: _ac, curve: const Interval(0.40, 0.70));
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ac, curve: const Interval(0.40, 0.70, curve: Curves.easeOut)));
    _subFade = CurvedAnimation(parent: _ac, curve: const Interval(0.65, 1.0));
    if (widget.active) _ac.forward();
  }

  @override
  void didUpdateWidget(covariant _WelcomePage old) {
    super.didUpdateWidget(old);
    if (widget.active && !old.active) {
      _ac.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: AnimatedBuilder(
        animation: _ac,
        builder: (_, __) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            FadeTransition(
              opacity: _logoFade,
              child: ScaleTransition(
                scale: _logoScale,
                child: Container(
                  width: 144,
                  height: 144,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withOpacity(0.30),
                        blurRadius: 40,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Image.asset(
                    'assets/icon/app_icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 36),
            FadeTransition(
              opacity: _titleFade,
              child: SlideTransition(
                position: _titleSlide,
                child: Text(
                  'Welcome to PediAid',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            FadeTransition(
              opacity: _subFade,
              child: Text(
                'Paediatrics & neonatology,\nbedside-ready.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

// ─── Page 2: What's inside ───────────────────────────────────────────────────

class _FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color tint;
  const _FeatureItem(this.icon, this.title, this.subtitle, this.tint);
}

const _features = <_FeatureItem>[
  _FeatureItem(Icons.calculate_rounded, 'Calculators', '18+ bedside tools', Color(0xFF1565C0)),
  _FeatureItem(Icons.menu_book_rounded, 'Drug Formulary', 'Neofax + Harriet Lane', Color(0xFF00897B)),
  _FeatureItem(Icons.show_chart_rounded, 'Growth Charts', 'WHO, IAP, Fenton', Color(0xFF6A1B9A)),
  _FeatureItem(Icons.local_hospital_rounded, 'Emergency', 'Live weight-based dosing', Color(0xFFB71C1C)),
  _FeatureItem(Icons.auto_stories_rounded, 'Guides', 'Ballard, NRP, PALS, Echo', Color(0xFFE65100)),
  _FeatureItem(Icons.science_outlined, 'Lab Reference', 'Age-banded ranges', Color(0xFF2E7D32)),
];

class _FeaturesPage extends StatefulWidget {
  final bool active;
  const _FeaturesPage({required this.active});

  @override
  State<_FeaturesPage> createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<_FeaturesPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (widget.active) _ac.forward();
  }

  @override
  void didUpdateWidget(covariant _FeaturesPage old) {
    super.didUpdateWidget(old);
    if (widget.active && !old.active) {
      _ac.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What's inside",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Everything you reach for in NICU and OPD.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 22),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _features.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (_, i) {
                // Stagger entry: each tile starts 60ms after the previous one.
                final start = (i * 0.08).clamp(0.0, 0.7);
                final end = (start + 0.45).clamp(0.0, 1.0);
                final anim = CurvedAnimation(
                  parent: _ac,
                  curve: Interval(start, end, curve: Curves.easeOutCubic),
                );
                return AnimatedBuilder(
                  animation: anim,
                  builder: (_, __) => Opacity(
                    opacity: anim.value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - anim.value)),
                      child: _FeatureTile(item: _features[i]),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final _FeatureItem item;
  const _FeatureTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: item.tint.withOpacity(0.13),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(item.icon, color: item.tint, size: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Page 3: Live demo (mini GIR) ────────────────────────────────────────────

class _DemoPage extends StatefulWidget {
  final bool active;
  const _DemoPage({required this.active});

  @override
  State<_DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<_DemoPage>
    with SingleTickerProviderStateMixin {
  // Demo inputs — simple GIR exemplar.
  double _weightKg = 1.85;
  double _girTarget = 6.0;
  // Fixed for demo: 10% dextrose, calculate required total fluid mL/hr.
  static const double _dextrosePct = 10.0;

  late final AnimationController _ac;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    if (widget.active) _ac.forward();
  }

  @override
  void didUpdateWidget(covariant _DemoPage old) {
    super.didUpdateWidget(old);
    if (widget.active && !old.active) {
      _ac.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  // GIR (mg/kg/min) = (rate mL/hr * dextrose%) / (weight kg * 6)
  // → rate mL/hr = GIR * weight * 6 / dextrose%
  double get _rateMlPerHr => _girTarget * _weightKg * 6 / _dextrosePct;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: FadeTransition(
        opacity: _ac,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Try it live',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Mini GIR calculator — drag the sliders.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Result card — animates value changes.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [cs.primary, cs.primary.withOpacity(0.78)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: cs.primary.withOpacity(0.28),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Required infusion rate',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: _rateMlPerHr, end: _rateMlPerHr),
                    duration: const Duration(milliseconds: 220),
                    builder: (_, val, __) => RichText(
                      text: TextSpan(
                        style: GoogleFonts.plusJakartaSans(color: Colors.white),
                        children: [
                          TextSpan(
                            text: val.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.0,
                            ),
                          ),
                          TextSpan(
                            text: '  mL / hr',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'using ${_dextrosePct.toInt()}% dextrose',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.78),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _DemoSliderRow(
              label: 'Baby weight',
              value: _weightKg,
              min: 0.5,
              max: 5.0,
              suffix: 'kg',
              decimals: 2,
              onChanged: (v) => setState(() => _weightKg = v),
            ),
            const SizedBox(height: 14),
            _DemoSliderRow(
              label: 'GIR target',
              value: _girTarget,
              min: 4,
              max: 12,
              suffix: 'mg/kg/min',
              decimals: 1,
              onChanged: (v) => setState(() => _girTarget = v),
            ),

            const Spacer(),
            Row(
              children: [
                Icon(Icons.bolt_rounded, size: 16, color: cs.onSurfaceVariant),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Real calculator inside the app — with stock-bag picker, alerts, and printable orders.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _DemoSliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String suffix;
  final int decimals;
  final ValueChanged<double> onChanged;
  const _DemoSliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.decimals,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${value.toStringAsFixed(decimals)} $suffix',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: cs.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

// ─── Page 4: Personalize ─────────────────────────────────────────────────────

const _roles = [
  ('Neonatologist',  Icons.child_friendly_rounded),
  ('Paediatrician',  Icons.local_hospital_rounded),
  ('Resident',       Icons.school_rounded),
  ('Nurse',          Icons.medical_services_rounded),
  ('Student',        Icons.menu_book_rounded),
  ('Other',          Icons.person_outline_rounded),
];

class _PersonalizePage extends StatelessWidget {
  final bool active;
  final String? selectedRole;
  final ValueChanged<String> onRolePicked;
  const _PersonalizePage({
    required this.active,
    required this.selectedRole,
    required this.onRolePicked,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Make it yours',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Optional — change anytime in Settings.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "I'm a…",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _roles.map((r) {
              final picked = selectedRole == r.$1;
              return GestureDetector(
                onTap: () => onRolePicked(r.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: picked ? cs.primary : cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: picked ? cs.primary : cs.outlineVariant,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        r.$2,
                        size: 17,
                        color: picked ? cs.onPrimary : cs.onSurface,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        r.$1,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: picked ? cs.onPrimary : cs.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          Text(
            'Theme',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          _ThemeChooser(
            isDark: theme.isDarkMode,
            onChange: theme.setDarkMode,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withOpacity(0.55),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(Icons.lock_outline_rounded, size: 18, color: cs.onPrimaryContainer),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Stays on your device. We don\'t send your role anywhere.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ThemeChooser extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onChange;
  const _ThemeChooser({required this.isDark, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _themeOption(context, dark: false, isSelected: !isDark)),
        const SizedBox(width: 10),
        Expanded(child: _themeOption(context, dark: true, isSelected: isDark)),
      ],
    );
  }

  Widget _themeOption(BuildContext context,
      {required bool dark, required bool isSelected}) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => onChange(dark),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF161C28) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: cs.primary.withOpacity(0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              size: 20,
              color: dark ? Colors.amber.shade300 : Colors.orange.shade700,
            ),
            const SizedBox(width: 10),
            Text(
              dark ? 'Dark' : 'Light',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: dark ? Colors.white : const Color(0xFF0D1929),
              ),
            ),
            const Spacer(),
            if (isSelected) Icon(Icons.check_circle_rounded, size: 18, color: cs.primary),
          ],
        ),
      ),
    );
  }
}

// ─── Page 5: Ready ───────────────────────────────────────────────────────────

class _ReadyPage extends StatefulWidget {
  final bool active;
  const _ReadyPage({required this.active});

  @override
  State<_ReadyPage> createState() => _ReadyPageState();
}

class _ReadyPageState extends State<_ReadyPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    if (widget.active) _ac.forward();
  }

  @override
  void didUpdateWidget(covariant _ReadyPage old) {
    super.didUpdateWidget(old);
    if (widget.active && !old.active) {
      _ac.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: AnimatedBuilder(
        animation: _ac,
        builder: (_, __) {
          final iconScale =
              Tween<double>(begin: 0.5, end: 1.0)
                  .chain(CurveTween(curve: Curves.elasticOut))
                  .animate(CurvedAnimation(
                      parent: _ac, curve: const Interval(0, 0.7)))
                  .value;
          final fade = CurvedAnimation(
                  parent: _ac, curve: const Interval(0.4, 1.0))
              .value;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Transform.scale(
                scale: iconScale,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_rounded, size: 56, color: cs.primary),
                ),
              ),
              const SizedBox(height: 28),
              Opacity(
                opacity: fade,
                child: Text(
                  "You're all set",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: cs.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Opacity(
                opacity: fade,
                child: Text(
                  'Tap below to open PediAid.\nYou can replay this tour any time from Settings.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
              const Spacer(flex: 3),
            ],
          );
        },
      ),
    );
  }
}

// ─── Dot indicator ───────────────────────────────────────────────────────────

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int current;
  const _DotsIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final isCurrent = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.only(right: 6),
          width: isCurrent ? 22 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isCurrent ? cs.primary : cs.outlineVariant,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
