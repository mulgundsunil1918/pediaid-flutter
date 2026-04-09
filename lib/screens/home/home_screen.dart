import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/theme_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/notification_bell.dart';
import '../calculators/calculators_screen.dart';
import '../calculators/gir_calculator.dart';
import '../calculators/blood_gas_analyser.dart';
import '../calculators/tpn_calculator.dart';
import '../calculators/cga_pma_calculator.dart';
import '../calculators/ponderal_index_calculator.dart';
import '../calculators/bsa_calculator.dart';
import '../charts/growth_charts_screen.dart';
import '../formulary/formulary_screen.dart';
import '../calculators/bp_hub_screen.dart';
import '../calculators/jaundice_hub_screen.dart';
import '../settings/settings_screen.dart';
import '../lab_reference/lab_reference_screen.dart';
import '../about_screen.dart';
import '../account_screen.dart';
import '../guides/guides_screen.dart';
import '../cme/cme_screen.dart';
import '../shared/suggest_feature_sheet.dart';
import '../../academics/academics_web_screen.dart';
import 'app_search_delegate.dart';

// ── All available quick-access items ─────────────────────────────────────────

const _kPrefKey = 'quick_access_keys';

const List<_ChipDef> _allChips = [
  _ChipDef('gir',     'GIR Calc',   Icons.water_drop_rounded),
  _ChipDef('gas',     'Blood Gas',  Icons.air_rounded),
  _ChipDef('tpn',     'TPN',        Icons.medical_services_rounded),
  _ChipDef('cga',     'CGA / PMA',  Icons.calendar_month_rounded),
  _ChipDef('growth',  'Growth',     Icons.show_chart_rounded),
  _ChipDef('ponderal','Ponderal',   Icons.child_care_rounded),
  _ChipDef('bsa',     'BSA',        Icons.person_rounded),
  _ChipDef('bp',      'BP Calc',    Icons.favorite_rounded),
  _ChipDef('bili',    'Bili Tool',  Icons.opacity_rounded),
];

const _kDefaultKeys = ['gir', 'gas', 'tpn', 'cga', 'growth'];

// ── HomeScreen ────────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> _selectedKeys = List.from(_kDefaultKeys);

  // Scroll-driven hero header animation.
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollY = ValueNotifier<double>(0);
  static const double _kHeroFadeEnd = 120.0;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    final clamped = offset < 0 ? 0.0 : offset;
    if (_scrollY.value != clamped) {
      _scrollY.value = clamped;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollY.dispose();
    super.dispose();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_kPrefKey);
    if (saved != null && saved.isNotEmpty) {
      setState(() => _selectedKeys = saved);
    }
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kPrefKey, _selectedKeys);
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: _buildDrawer(context, isDark),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            snap: true,
            elevation: 0,
            backgroundColor: isDark
                ? const Color(0xFF022B42)
                : const Color(0xFF395886),
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            title: const Text(
              'PediAid',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 0.3,
              ),
            ),
            actions: [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) => IconButton(
                  onPressed: () => themeProvider.toggleTheme(),
                  icon: Icon(
                    themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const NotificationBell(),
              const SizedBox(width: 4),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ValueListenableBuilder<double>(
                  valueListenable: _scrollY,
                  builder: (context, scrollY, child) {
                    final progress = (scrollY / _kHeroFadeEnd).clamp(0.0, 1.0);
                    final opacity = 1.0 - progress;
                    return IgnorePointer(
                      ignoring: opacity < 0.1,
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: (1.0 - progress).clamp(0.0, 1.0),
                          child: Opacity(
                            opacity: opacity,
                            child: Transform.translate(
                              offset: Offset(0, -40 * progress),
                              child: child,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: _buildWelcomeBanner(context, isDark),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final maxContent = constraints.maxWidth > 700 ? 680.0 : constraints.maxWidth;
                    return Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxContent),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _sectionLabel(context, 'Features'),
                              const SizedBox(height: 12),
                              _buildFeatureGrid(context, isDark, cs),
                              const SizedBox(height: 24),
                              _buildQuickHeader(context, cs),
                              const SizedBox(height: 10),
                              _buildQuickChips(context, cs, isDark),
                              const SizedBox(height: 24),
                              _buildDisclaimer(context, cs),
                              const SizedBox(height: 16),
                              _buildSuggestBanner(context, cs),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                _buildDonationFooter(context, isDark),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Donation footer (bottom of the home scroll) ──────────────────────────
  //
  // PediAid is one person's side project — everything from the calculators
  // to the peer-review pipeline is coded and paid for by Dr. Sunil. Servers,
  // databases, and the domain all cost money every month. A lightweight
  // "buy me a chai" card at the end of the home scroll makes it easy for
  // happy users to chip in without being in their face about it.

  Widget _buildDonationFooter(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 8),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1E1A12)
              : const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark
                ? const Color(0xFF92400E).withValues(alpha: 0.4)
                : const Color(0xFFFDE68A),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('☕️', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  'Like PediAid? Buy me a chai.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? const Color(0xFFFCD34D)
                        : const Color(0xFF92400E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "I've done the coding on my own — the app, the academics web, "
              "the backend, everything. It costs me every month to keep the "
              "servers running. If PediAid has saved you time on a shift, "
              "consider donating. Every chai keeps the app alive.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                height: 1.55,
                color: (isDark
                        ? const Color(0xFFFCD34D)
                        : const Color(0xFF78350F))
                    .withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final uri = Uri.parse('https://www.chai4.me/mulgundsunil');
                  try {
                    await launchUrl(uri,
                        mode: LaunchMode.externalApplication);
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Couldn't open the link.")),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.favorite_rounded, size: 16),
                label: Text(
                  'Buy me a chai',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Opens chai4.me — no account needed.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: (isDark
                          ? const Color(0xFFFCD34D)
                          : const Color(0xFF92400E))
                      .withValues(alpha: 0.55),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                '— Dr. Sunil Mulgund',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: (isDark
                          ? const Color(0xFFFCD34D)
                          : const Color(0xFF92400E))
                      .withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Welcome banner (below AppBar, in scroll body) ────────────────────────

  Widget _buildWelcomeBanner(BuildContext context, bool isDark) {
    final gradStart = isDark ? const Color(0xFF1A2744) : const Color(0xFF1565C0);
    final gradEnd   = isDark ? const Color(0xFF0F1117) : const Color(0xFF0D47A1);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradStart, gradEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -30, right: -40, child: _circle(180, 0.04)),
          Positioned(top: 40, right: 60, child: _circle(90, 0.05)),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.wb_sunny_outlined, color: Colors.white, size: 12),
                    const SizedBox(width: 5),
                    Text(_greeting,
                        style: GoogleFonts.plusJakartaSans(
                            color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                  ]),
                ),
                const SizedBox(height: 8),
                Text(
                  'What would you like to look up?',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white, fontSize: 20,
                    fontWeight: FontWeight.w800, height: 1.2, letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Paediatric & Neonatal Clinical Reference',
                  style: GoogleFonts.plusJakartaSans(
                      color: Colors.white.withValues(alpha: 0.65), fontSize: 12),
                ),
                const SizedBox(height: 12),
                // Search bar (tappable — opens full search)
                GestureDetector(
                  onTap: () => showSearch(
                    context: context,
                    delegate: AppSearchDelegate(),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Row(children: [
                      Icon(Icons.search, color: Colors.white.withValues(alpha: 0.6), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Search calculators, drugs, guides, charts…',
                            style: GoogleFonts.plusJakartaSans(
                                color: Colors.white.withValues(alpha: 0.55), fontSize: 13)),
                      ),
                      Icon(Icons.tune_rounded, color: Colors.white.withValues(alpha: 0.4), size: 16),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, double alpha) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withValues(alpha: alpha),
    ),
  );

  // ── Section label ──────────────────────────────────────────────────────────

  Widget _sectionLabel(BuildContext context, String title) => Text(
    title,
    style: GoogleFonts.plusJakartaSans(
      fontSize: 16, fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.onSurface, letterSpacing: 0.1,
    ),
  );

  // ── Feature grid ──────────────────────────────────────────────────────────

  Widget _buildFeatureGrid(BuildContext context, bool isDark, ColorScheme cs) {
    final cards = [
      _FeatureDef('Calculators & Tools', 'Calc · BP · Bili · More',   Icons.calculate_rounded,   const Color(0xFF1565C0), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalculatorsScreen()))),
      _FeatureDef('Charts',        'Growth · Fenton · IAP',   Icons.show_chart_rounded,  const Color(0xFF6A1B9A), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GrowthChartsScreen()))),
      _FeatureDef('Drug Formulary','500+ drugs',               Icons.medication_rounded,  const Color(0xFF00695C), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FormularyScreen()))),
      _FeatureDef('Lab Reference',       'Harriet Lane values',        Icons.biotech_rounded,        const Color(0xFF00838F), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LabReferenceScreen()))),
      _FeatureDef('Guides',              'Fetal Dev · Protocols',      Icons.menu_book_outlined,     const Color(0xFF6D4C41), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GuidesScreen()))),
      _FeatureDef('CME & Webinars',       'Conferences · Webinars',     Icons.event_note_rounded,     const Color(0xFF7B1FA2), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CmeScreen()))),
      _FeatureDef('Academics',           'Peer-reviewed content',       Icons.auto_stories_rounded,   const Color(0xFF283593), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AcademicsWebScreen(path: '/academics')))),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.55,
      ),
      itemCount: cards.length,
      itemBuilder: (_, i) => _FeatureCardWidget(card: cards[i], isDark: isDark),
    );
  }

  // ── Quick access header (label + edit button) ──────────────────────────────

  Widget _buildQuickHeader(BuildContext context, ColorScheme cs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _sectionLabel(context, 'Quick Access'),
        GestureDetector(
          onTap: () => _showEditQuickAccess(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.edit_outlined, size: 13, color: cs.primary),
              const SizedBox(width: 5),
              Text('Edit',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12, fontWeight: FontWeight.w600, color: cs.primary)),
            ]),
          ),
        ),
      ],
    );
  }

  // ── Quick chips ───────────────────────────────────────────────────────────

  Widget _buildQuickChips(BuildContext context, ColorScheme cs, bool isDark) {
    final chipBg     = isDark ? AppTheme.dCard   : Colors.white;
    final chipBorder = isDark ? AppTheme.dBorder : const Color(0xFFCBD8EB);

    final visible = _allChips.where((c) => _selectedKeys.contains(c.key)).toList();

    if (visible.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text('No quick items selected. Tap Edit to add some.',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 13, color: cs.onSurface.withValues(alpha: 0.4))),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: visible.map((c) => InkWell(
        onTap: () => _navigateChip(context, c.key),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: chipBg,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: chipBorder),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(c.icon, size: 15, color: cs.primary),
            const SizedBox(width: 6),
            Text(c.label,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, fontWeight: FontWeight.w600, color: cs.onSurface)),
          ]),
        ),
      )).toList(),
    );
  }

  // ── Edit quick access bottom sheet ─────────────────────────────────────────

  void _showEditQuickAccess(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            final cs = Theme.of(ctx).colorScheme;
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 36, height: 4,
                      decoration: BoxDecoration(
                          color: cs.outline, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(children: [
                    Icon(Icons.tune_rounded, color: cs.primary, size: 20),
                    const SizedBox(width: 8),
                    Text('Customise Quick Access',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 17, fontWeight: FontWeight.w700, color: cs.onSurface)),
                  ]),
                  const SizedBox(height: 4),
                  Text('Select which shortcuts appear on your home screen.',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 12, color: cs.onSurface.withValues(alpha: 0.5))),
                  const SizedBox(height: 16),
                  ..._allChips.map((chip) {
                    final selected = _selectedKeys.contains(chip.key);
                    return CheckboxListTile(
                      value: selected,
                      onChanged: (v) {
                        setLocal(() {
                          if (v == true) {
                            _selectedKeys.add(chip.key);
                          } else {
                            _selectedKeys.remove(chip.key);
                          }
                        });
                        setState(() {});
                        _savePrefs();
                      },
                      secondary: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(chip.icon, color: cs.primary, size: 18),
                      ),
                      title: Text(chip.label,
                          style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600, fontSize: 14, color: cs.onSurface)),
                      activeColor: cs.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    );
                  }),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text('Done',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _navigateChip(BuildContext context, String key) {
    final routes = {
      'gir':      () => const GIRCalculator(),
      'gas':      () => const BloodGasAnalyser(),
      'tpn':      () => const TpnCalculator(),
      'cga':      () => const CGAPMACalculator(),
      'growth':   () => const GrowthChartsScreen(),
      'ponderal': () => const PonderalIndexCalculator(),
      'bsa':      () => const BSACalculator(),
      'bp':       () => const BPHubScreen(),
      'bili':     () => const JaundiceHubScreen(),
    };
    final builder = routes[key];
    if (builder != null) Navigator.push(context, MaterialPageRoute(builder: (_) => builder()));
  }

  // ── Disclaimer ────────────────────────────────────────────────────────────

  Widget _buildDisclaimer(BuildContext context, ColorScheme cs) {
    const amber = Color(0xFFF57C00);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: amber.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(Icons.info_outline_rounded, color: amber, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Clinical decision support tool only. Always verify calculations independently. '
              'PediAid does not replace clinical judgement.',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 12, color: cs.onSurface.withValues(alpha: 0.7), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // ── Suggest a Feature banner ──────────────────────────────────────────────

  Widget _buildSuggestBanner(BuildContext context, ColorScheme cs) {
    const accent = Color(0xFF1565C0);
    return GestureDetector(
      onTap: () => showSuggestSheet(context),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              accent.withValues(alpha: 0.13),
              const Color(0xFF6A1B9A).withValues(alpha: 0.09),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: accent.withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: accent.withValues(alpha: 0.3), width: 1),
              ),
              child: const Icon(Icons.lightbulb_rounded,
                  color: accent, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggest a Feature',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: accent,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Request a calculator, guide, chart, or any feature',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: cs.onSurface.withValues(alpha: 0.6),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Suggest',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Drawer ────────────────────────────────────────────────────────────────

  Widget _buildDrawer(BuildContext context, bool isDark) {
    final cs = Theme.of(context).colorScheme;
    final drawerBg  = isDark ? AppTheme.dSurface : Colors.white;
    final gradStart = isDark ? const Color(0xFF1A2744) : const Color(0xFF1565C0);
    final gradEnd   = isDark ? const Color(0xFF232D42) : const Color(0xFF1E88E5);

    return Drawer(
      backgroundColor: drawerBg,
      width: 280,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [gradStart, gradEnd],
                  begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.child_care_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 14),
              Text('PediAid',
                  style: GoogleFonts.plusJakartaSans(
                      color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              Text('Paediatric & Neonatal Reference',
                  style: GoogleFonts.plusJakartaSans(
                      color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
            ]),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // Minimal drawer: the main features (calculators, charts,
                // formulary, lab reference, guides, CME, academics) are the
                // primary tiles on the home screen itself, so they've been
                // removed from the drawer to keep it a quiet utility menu.
                _DrawerItem(icon: Icons.home_rounded,         label: 'Home',     onTap: () => Navigator.pop(context)),
                _DrawerItem(icon: Icons.settings_rounded,     label: 'Settings', onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())); }),
                _DrawerItem(icon: Icons.info_outline_rounded, label: 'About me', onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())); }),
                _DrawerItem(icon: Icons.account_circle_outlined, label: 'Account',  onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountScreen())); }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('PediAid v1.0.0',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 11, color: cs.onSurface.withValues(alpha: 0.4)),
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  // _handleLogout was removed from the drawer — Sign out now lives inside
  // the AccountScreen which can be opened from the drawer's 'Account' entry.

  // _showComingSoon was removed along with the 'Research' drawer entry.

}

// ── Data classes ──────────────────────────────────────────────────────────────

class _FeatureDef {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;
  const _FeatureDef(this.title, this.subtitle, this.icon, this.accent, this.onTap);
}

class _ChipDef {
  final String key;
  final String label;
  final IconData icon;
  const _ChipDef(this.key, this.label, this.icon);
}

// ── Feature card widget ────────────────────────────────────────────────────────

class _FeatureCardWidget extends StatelessWidget {
  final _FeatureDef card;
  final bool isDark;
  const _FeatureCardWidget({required this.card, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cs      = Theme.of(context).colorScheme;
    final cardBg  = isDark ? AppTheme.dCard   : Colors.white;
    final border  = isDark ? AppTheme.dBorder : const Color(0xFFCBD8EB);
    final accent  = card.accent;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: card.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: isDark ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(card.icon, color: accent, size: 22),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(card.title,
                      style: GoogleFonts.plusJakartaSans(
                        color: cs.onSurface,
                        fontSize: 14, fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(card.subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        color: cs.onSurface.withValues(alpha: 0.55),
                        fontSize: 11, fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Drawer item ───────────────────────────────────────────────────────────────

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _DrawerItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: cs.primary, size: 22),
      title: Text(label,
          style: GoogleFonts.plusJakartaSans(
              color: cs.onSurface, fontSize: 14, fontWeight: FontWeight.w600)),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
