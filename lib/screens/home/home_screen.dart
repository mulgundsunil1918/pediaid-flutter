import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/recents_service.dart';
import '../../theme/theme_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/prefs_keys.dart';
import '../../widgets/notification_bell.dart';
import '../../widgets/install_prompt.dart';
import '../calculators/calculators_screen.dart';
import '../calculators/gir_calculator.dart';
import '../calculators/blood_gas_analyser.dart';
import '../calculators/tpn_calculator.dart';
import '../calculators/cga_pma_calculator.dart';
import '../calculators/ponderal_index_calculator.dart';
import '../calculators/mid_parental_height_calculator.dart';
import '../calculators/bsa_calculator.dart';
import '../calculators/maintenance_fluid_calculator.dart';
import '../calculators/burn_mortality_calculator.dart';
import '../calculators/parkland_calculator_screen.dart';
import '../calculators/lund_browder_screen.dart';
import '../calculators/pet_calculator_screen.dart';
import '../calculators/schwartz_egfr_calculator.dart';
import '../calculators/gestational_age_calculator.dart';
import '../calculators/ventilator_parameters.dart';
import '../calculators/nutritional_audit_calculator.dart';
import '../calculators/double_volume_exchange.dart';
import '../calculators/neonatal_bp_calculator.dart';
import '../charts/growth_charts_screen.dart';
import '../formulary/formulary_screen.dart';
import '../calculators/bp_hub_screen.dart';
import '../calculators/jaundice_hub_screen.dart';
import '../settings/settings_screen.dart';
import '../lab_reference/lab_reference_screen.dart';
import '../about_screen.dart';
import '../account_screen.dart';
import '../references_screen.dart';
import '../guides/guides_screen.dart';
import '../cme/cme_screen.dart';
import '../shared/suggest_feature_sheet.dart';
import '../../academics/academics_web_screen.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'app_search_delegate.dart';
// AuthService + AdminDashboardScreen imports preserved as references —
// auth is disabled for testing, but _buildAdminTile below still uses the
// route so don't remove the file.
// ignore: unused_import
import '../../services/auth_service.dart';
// ignore: unused_import
import '../admin/admin_dashboard_screen.dart';
import '../never_again/never_again_screen.dart';
import '../resources/resources_screen.dart';
import '../../utils/support_contact.dart';
import '../submissions/my_submissions_screen.dart';
import '../saved/saved_screen.dart';
import '../guides/developmental_milestones/dev_milestones_hub.dart';
import '../guides/developmental_milestones/tdsc/tdsc_assistant_screen.dart';
import '../../services/app_config_service.dart';
import '../../services/rate_prompt_service.dart';
import '../../widgets/tool_gate.dart';

// ── All available quick-access items ─────────────────────────────────────────

const _kPrefKey = 'quick_access_keys';

const List<_ChipDef> _allChips = [
  // Calculators
  _ChipDef('gir', 'GIR Calc', Icons.water_drop_rounded),
  _ChipDef('gas', 'Blood Gas', Icons.air_rounded),
  _ChipDef('tpn', 'TPN', Icons.medical_services_rounded),
  _ChipDef('cga', 'CGA / PMA', Icons.calendar_month_rounded),
  _ChipDef('ponderal', 'Ponderal', Icons.child_care_rounded),
  _ChipDef('mph', 'Mid-Parental Ht', Icons.height_rounded),
  _ChipDef('bsa', 'BSA', Icons.person_rounded),
  _ChipDef('bp', 'BP Calc', Icons.favorite_rounded),
  _ChipDef('neobp', 'Neonatal BP', Icons.monitor_heart_rounded),
  _ChipDef('bili', 'Bili Tool', Icons.opacity_rounded),
  _ChipDef('fluid', 'Maint. Fluid', Icons.water_rounded),
  _ChipDef('burn', 'Burn Mortality', Icons.local_fire_department_rounded),
  _ChipDef('parkland', 'Parkland', Icons.whatshot_rounded),
  _ChipDef('lund', 'Lund-Browder', Icons.accessibility_new_rounded),
  _ChipDef('pet', 'PET Calc', Icons.science_rounded),
  _ChipDef('egfr', 'Schwartz eGFR', Icons.bloodtype_rounded),
  _ChipDef('ga', 'GA Calc', Icons.date_range_rounded),
  _ChipDef('vent', 'Ventilator', Icons.air_rounded),
  _ChipDef('nutri', 'Nutri Audit', Icons.restaurant_rounded),
  _ChipDef('dve', 'DVE', Icons.sync_alt_rounded),
  _ChipDef('allcalc', 'All Calculators', Icons.calculate_rounded),
  // Charts
  _ChipDef('growth', 'Charts', Icons.show_chart_rounded),
  // Developmental
  _ChipDef('devmile', 'Dev Milestones', Icons.child_friendly_rounded),
  _ChipDef('tdsc', 'TDSC', Icons.assignment_turned_in_outlined),
  // References / library
  _ChipDef('formulary', 'Formulary', Icons.menu_book_rounded),
  _ChipDef('labref', 'Lab Reference', Icons.science_outlined),
  _ChipDef('guides', 'Guides', Icons.auto_stories_rounded),
  _ChipDef('cme', 'CME & Webinars', Icons.event_available_rounded),
  _ChipDef('academics', 'Academics', Icons.school_rounded),
  _ChipDef('resources', 'Resources', Icons.download_rounded),
];

// All modules surface in Quick Access by default. Users can prune via the
// Edit sheet — but a fresh install shows everything so the carousel feels
// full rather than empty.
const List<String> _kDefaultKeys = [
  'gir',
  'gas',
  'tpn',
  'cga',
  'ponderal',
  'mph',
  'bsa',
  'bp',
  'neobp',
  'bili',
  'fluid',
  'burn',
  'parkland',
  'lund',
  'pet',
  'egfr',
  'ga',
  'vent',
  'nutri',
  'dve',
  'allcalc',
  'growth',
  'devmile',
  'tdsc',
  'formulary',
  'labref',
  'guides',
  'cme',
  'academics',
  'resources',
];

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

  // ── Showcase coachmark keys ────────────────────────────────────────────────
  // Each highlights a real UI element in the home screen on first visit
  // (after the slide-based onboarding completes). Re-runnable from
  // Settings → "Replay tutorial" — that handler clears
  // PrefsKeys.interactiveTutorialDone so the next HomeScreen build starts
  // the tour again.
  final GlobalKey _scDrawerKey = GlobalKey();
  final GlobalKey _scSearchKey = GlobalKey();
  final GlobalKey _scQuickAccessKey = GlobalKey();
  final GlobalKey _scCalculatorsKey = GlobalKey();
  final GlobalKey _scFormularyKey = GlobalKey();
  final GlobalKey _scGuidesKey = GlobalKey();
  bool _tutorialAttempted = false;

  // Web-only vanity counter — backed by Upstash Redis (not Postgres/Neon),
  // so unlike the old version this can't drain database compute hours.
  int? _visitorCount;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _scrollController.addListener(_onScroll);
    if (kIsWeb) _fetchVisitorCount();
    _maybeAskForReview();
  }

  /// Offers the review prompt a few seconds after the home screen settles.
  ///
  /// Not on the first frame: someone who just opened the app is on their way
  /// to look something up, and a dialog in front of that is an interruption
  /// rather than a request. The service decides whether it is due at all — it
  /// asks three times over two months at most, then never again.
  Future<void> _maybeAskForReview() async {
    await Future<void>.delayed(const Duration(seconds: 4));
    if (!mounted) return;
    await RatePromptService.instance.maybeAsk(context);
  }

  Future<void> _fetchVisitorCount() async {
    try {
      final res = await http
          .get(
            Uri.parse(
              'https://pediaid-backend.onrender.com/api/stats/visits/app',
            ),
          )
          .timeout(const Duration(seconds: 10));
      if (!mounted || res.statusCode != 200) return;
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      setState(() => _visitorCount = body['count'] as int);
    } catch (_) {
      // Silent — vanity counter, never surface an error for this.
    }
  }

  /// Called once after the showcase frame is laid out. Reads prefs and,
  /// if onboarding is done but the coachmark tour hasn't run yet, kicks
  /// it off. Idempotent — guarded by [_tutorialAttempted].
  Future<void> _maybeStartTutorial(BuildContext showcaseCtx) async {
    if (_tutorialAttempted) return;
    _tutorialAttempted = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final onboardingDone =
          prefs.getBool(PrefsKeys.onboardingComplete) ?? false;
      final tourDone =
          prefs.getBool(PrefsKeys.interactiveTutorialDone) ?? false;
      if (onboardingDone && !tourDone && mounted && showcaseCtx.mounted) {
        ShowCaseWidget.of(showcaseCtx).startShowCase([
          _scDrawerKey,
          _scSearchKey,
          _scQuickAccessKey,
          _scCalculatorsKey,
          _scFormularyKey,
          _scGuidesKey,
        ]);
      }
    } catch (_) {
      /* never block boot for the tour */
    }
  }

  Future<void> _markTourDone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(PrefsKeys.interactiveTutorialDone, true);
    } catch (_) {
      /* fine — will retry next launch */
    }
  }

  void _onScroll() {
    final offset = _scrollController.hasClients
        ? _scrollController.offset
        : 0.0;
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

  /// Key under which we record which chips existed when the user last saved.
  ///
  /// Needed to tell "the user removed this" apart from "this did not exist
  /// yet". Without it, a saved selection silently froze Quick Access at the
  /// module list of whichever version the user first customised on — every
  /// module added afterwards was invisible to them forever, while a fresh
  /// install showed everything. That is why modules appeared to be missing.
  static const _kKnownKey = '${_kPrefKey}_known';

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_kPrefKey);
    if (saved == null || saved.isEmpty) return;

    final known = prefs.getStringList(_kKnownKey);

    // Chips that did not exist when this selection was saved, so the user
    // never had the chance to opt out of them. Anything they actively removed
    // stays removed, because it was in `known` at the time.
    final List<String> unseen;
    if (known == null) {
      // Saved before this bookkeeping existed — nothing records what was on
      // offer then. Add back everything missing, once, so the modules they
      // never saw appear; from here on `known` makes it exact, and anything
      // they remove now stays removed.
      unseen = _kDefaultKeys.where((k) => !saved.contains(k)).toList();
    } else {
      unseen = _kDefaultKeys
          .where((k) => !known.contains(k) && !saved.contains(k))
          .toList();
    }

    final merged = [...saved, ...unseen];
    setState(() => _selectedKeys = merged);

    if (unseen.isNotEmpty || known == null) {
      await prefs.setStringList(_kPrefKey, merged);
      await prefs.setStringList(_kKnownKey, _kDefaultKeys);
    }
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kPrefKey, _selectedKeys);
    // Snapshot what was on offer, so a later release can tell which modules
    // are genuinely new versus ones this user chose not to have.
    await prefs.setStringList(_kKnownKey, _kDefaultKeys);
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onFinish: _markTourDone,
      blurValue: 1,
      builder: _buildHomeScaffold,
    );
  }

  Widget _buildHomeScaffold(BuildContext showcaseCtx) {
    final cs = Theme.of(showcaseCtx).colorScheme;
    final isDark = Theme.of(showcaseCtx).brightness == Brightness.dark;

    // Fire the coachmark trigger after the first frame so widget keys are
    // registered with the ShowCaseWidget controller.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _maybeStartTutorial(showcaseCtx),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(showcaseCtx).scaffoldBackgroundColor,
      drawer: _buildDrawer(showcaseCtx, isDark),
      // The install prompt sits above the scroll view rather than inside it,
      // so it stays put instead of scrolling away before anyone reads it.
      // It renders nothing on native builds, on desktop, once installed, or
      // after dismissal — see install_prompt.dart.
      body: Column(
        children: [
          const InstallPrompt(),
          Expanded(
            child: CustomScrollView(
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
                  leading: Showcase(
                    key: _scDrawerKey,
                    title: 'Menu',
                    description:
                        'Settings, Account, About, Admin and Logout all live here.',
                    targetShapeBorder: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
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
                    // Support the developer — hidden on iOS (App Store guideline 3.1.1)
                    if (kIsWeb || !Platform.isIOS)
                      IconButton(
                        tooltip: 'Support the developer',
                        onPressed: () async {
                          final uri = Uri.parse(
                            'https://bridgr.co.in/support?from=pediaid',
                          );
                          try {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (_) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Couldn't open the link."),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, _) => IconButton(
                        onPressed: () => themeProvider.toggleTheme(),
                        icon: Icon(
                          themeProvider.isDarkMode
                              ? Icons.light_mode
                              : Icons.dark_mode,
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
                          final progress = (scrollY / _kHeroFadeEnd).clamp(
                            0.0,
                            1.0,
                          );
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
                          final maxContent = constraints.maxWidth > 700
                              ? 680.0
                              : constraints.maxWidth;
                          return Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxContent),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  10,
                                  16,
                                  32,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Web only: which platform gets the full
                                    // experience. Kept to one line per box —
                                    // this sits above the primary grid, so
                                    // anything longer gets skipped, not read.
                                    // Not shown in the apps: the iOS build
                                    // must not reference the fuller web
                                    // version (App Store guideline 1.4.2 /
                                    // 2.3.1), and Android already IS the full
                                    // app.
                                    if (kIsWeb) ...[
                                      _PlatformNoticeBoxes(cs: cs),
                                      const SizedBox(height: 16),
                                    ],
                                    _buildFeatureGrid(context, isDark, cs),
                                    const SizedBox(height: 24),
                                    // Recents row — only renders when the user
                                    // has actually opened something (RecentsService
                                    // notifier publishes []).
                                    _RecentsRow(
                                      onOpen: (key) =>
                                          _navigateChip(context, key),
                                    ),
                                    _buildQuickHeader(context, cs),
                                    const SizedBox(height: 10),
                                    _buildQuickChips(context, cs, isDark),
                                    const SizedBox(height: 24),
                                    _buildDisclaimer(context, cs),
                                    const SizedBox(height: 8),
                                    _buildReferencesLink(context, cs),
                                    const SizedBox(height: 16),
                                    _buildSuggestBanner(context, cs),
                                    // Admin tile disabled while auth is removed for
                                    // testing — was previously gated on
                                    // AuthService.instance.currentUser?.role == 'admin'.
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (kIsWeb || !Platform.isIOS)
                        _buildDonationFooter(context, isDark),
                      // The iOS-only "More features on the Web App" banner is
                      // deliberately not rendered.
                      //
                      // It named the drug formulary and dose calculators and
                      // linked to the site that still has them — on the one
                      // platform where those tools are withheld to satisfy App
                      // Store guideline 1.4.2. To a reviewer that reads as
                      // routing users around the restriction rather than
                      // complying with it, which is treated more harshly than
                      // simply shipping the feature, and it also invites 2.3.1
                      // (functionality not evident in the app itself).
                      //
                      // Kept as a widget rather than deleted: it is legitimate
                      // on any platform that is not iOS, if it is ever wanted
                      // there without naming the withheld tools.
                      if (kIsWeb) _buildVisitorCounter(context),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 16,
                      ),
                    ],
                  ),
                ),
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
  // "Support the developer" card at the end of the home scroll makes it
  // easy for happy users to chip in without being in their face about it.
  // Links out to bridgr.co.in (Sunil's own site) so he controls how the
  // support pitch is presented.

  Widget _buildDonationFooter(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 8),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1A12) : const Color(0xFFFFFBEB),
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
                  'Like PediAid? Support the developer.',
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
              "consider supporting the developer. Every contribution keeps "
              "the app alive.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                height: 1.55,
                color:
                    (isDark ? const Color(0xFFFCD34D) : const Color(0xFF78350F))
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
                  final uri = Uri.parse(
                    'https://bridgr.co.in/support?from=pediaid',
                  );
                  try {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Couldn't open the link."),
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.favorite_rounded, size: 16),
                label: Text(
                  'Support the developer',
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
                'Opens bridgr.co.in — no account needed.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color:
                      (isDark
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
                  color:
                      (isDark
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

  // ── Visitor counter (web only, standalone, very end of the page) ─────────
  Widget _buildVisitorCounter(BuildContext context) {
    if (_visitorCount == null) return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 4),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.visibility_rounded, size: 22, color: cs.primary),
              const SizedBox(height: 6),
              Text(
                '$_visitorCount',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  color: cs.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'people have visited PediAid',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Web promo footer — NOT rendered on iOS (see call site) ──────────────
  // ignore: unused_element
  Widget _buildWebPromoFooter(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => launchUrl(
          Uri.parse('https://pediaid.bridgr.co.in'),
          mode: LaunchMode.externalApplication,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.language_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'More features on the Web App',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Drug formulary, dose calculators & more at pediaid.bridgr.co.in',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.open_in_new_rounded, size: 16, color: cs.primary),
            ],
          ),
        ),
      ),
    );
  }

  // ── Welcome banner (below AppBar, in scroll body) ────────────────────────

  Widget _buildWelcomeBanner(BuildContext context, bool isDark) {
    final gradStart = isDark
        ? const Color(0xFF1A2744)
        : const Color(0xFF1565C0);
    final gradEnd = isDark ? const Color(0xFF0F1117) : const Color(0xFF0D47A1);

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.wb_sunny_outlined,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _greeting,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'What would you like to look up?',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Paediatric & Neonatal Clinical Reference',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                // Search bar (tappable — opens full search)
                Showcase(
                  key: _scSearchKey,
                  title: 'Search anything',
                  description:
                      'Type any drug, calculator, guide or guideline chapter. '
                      'Common abbreviations like UTI, DKA, RSI or 2D echo all '
                      'resolve to the right tool.',
                  targetBorderRadius: BorderRadius.circular(12),
                  child: GestureDetector(
                    onTap: () => showSearch(
                      context: context,
                      delegate: AppSearchDelegate(),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.white.withValues(alpha: 0.6),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Search calculators, drugs, guides, charts, guidelines…',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white.withValues(alpha: 0.55),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.tune_rounded,
                            color: Colors.white.withValues(alpha: 0.4),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
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
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withValues(alpha: alpha),
    ),
  );

  // ── Section label ──────────────────────────────────────────────────────────

  Widget _sectionLabel(BuildContext context, String title) => Text(
    title,
    style: GoogleFonts.plusJakartaSans(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.onSurface,
      letterSpacing: 0.1,
    ),
  );

  // ── Feature grid ──────────────────────────────────────────────────────────

  Widget _buildFeatureGrid(BuildContext context, bool isDark, ColorScheme cs) {
    // Each card records itself into Recents on tap so the Recents row
    // can surface heavy modules (Formulary, Guides) right alongside the
    // light-weight Quick Access chips.
    void open(String key, String label, Widget Function() builder) {
      // ignore: unawaited_futures
      RecentsService.instance.record(key, label);
      // Gated here too: Quick Access and Recents reach calculators without
      // going through the calculators list, so a tool withdrawn from service
      // must be unreachable from every route into it, not just the obvious one.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ToolGate(toolId: key, child: builder()),
        ),
      );
    }

    final bool _iosNative = !kIsWeb && Platform.isIOS;
    final cards = [
      _FeatureDef(
        'Calculators & Tools',
        'Calc · BP · Bili · More',
        Icons.calculate_rounded,
        const Color(0xFF1565C0),
        () => open('allcalc', 'Calculators', () => const CalculatorsScreen()),
      ),
      _FeatureDef(
        'Charts',
        'Growth · Fenton · IAP',
        Icons.show_chart_rounded,
        const Color(0xFF6A1B9A),
        () => open('growth', 'Charts', () => const GrowthChartsScreen()),
      ),
      if (!_iosNative)
        _FeatureDef(
          'Drug Formulary',
          '500+ drugs',
          Icons.medication_rounded,
          const Color(0xFF00695C),
          () => open(
            'formulary',
            'Drug Formulary',
            () => const FormularyScreen(),
          ),
        ),
      _FeatureDef(
        'Lab Reference',
        'Harriet Lane values',
        Icons.biotech_rounded,
        const Color(0xFF00838F),
        () => open('labref', 'Lab Reference', () => const LabReferenceScreen()),
      ),
      _FeatureDef(
        'Guides',
        'Fetal Dev · Protocols',
        Icons.menu_book_outlined,
        const Color(0xFF6D4C41),
        () => open('guides', 'Guides', () => const GuidesScreen()),
      ),
      _FeatureDef(
        'CME & Webinars',
        'Conferences · Webinars',
        Icons.event_note_rounded,
        const Color(0xFF7B1FA2),
        () => open('cme', 'CME & Webinars', () => const CmeScreen()),
      ),
      _FeatureDef(
        'Academics',
        'Trials, CME & guidelines',
        Icons.auto_stories_rounded,
        const Color(0xFF283593),
        () => open('academics', 'Academics', () => const AcademicsWebScreen()),
        highlight: true,
      ),
      _FeatureDef(
        'Never Again',
        'Learn from real mistakes',
        Icons.groups_rounded,
        const Color(0xFF1A237E),
        () => open('neveragain', 'Never Again', () => const NeverAgainScreen()),
      ),
      _FeatureDef(
        'Resources',
        'Charts · scores · templates',
        Icons.download_rounded,
        const Color(0xFFAD1457),
        () => open('resources', 'Resources', () => const ResourcesScreen()),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.55,
      ),
      itemCount: cards.length,
      itemBuilder: (_, i) {
        Widget tile = _FeatureCardWidget(card: cards[i], isDark: isDark);
        // Wrap the Calculators / Formulary / Guides cards in Showcase so
        // the coachmark tour can highlight them. Index order matches the
        // `cards` list above: 0=Calculators, 2=Formulary, 4=Guides.
        if (i == 0) {
          tile = Showcase(
            key: _scCalculatorsKey,
            title: 'Calculators',
            description:
                '40+ bedside calculators — GIR, blood gas, jaundice, '
                'electrolyte corrections, ETT, fluids and more.',
            targetBorderRadius: BorderRadius.circular(16),
            child: tile,
          );
        } else if (i == 2) {
          tile = Showcase(
            key: _scFormularyKey,
            title: 'Drug Formulary',
            description:
                '676 drugs (Neofax + Harriet Lane). Tap any drug for the '
                'premium structured detail view with Quick Summary.',
            targetBorderRadius: BorderRadius.circular(16),
            child: tile,
          );
        } else if (i == 4) {
          tile = Showcase(
            key: _scGuidesKey,
            title: 'Guides & emergency protocols',
            description:
                'IAP STG, NNF CPG, NRP, PALS, plus emergency tools — DKA, '
                'RSI, snake / scorpion envenomation, status epilepticus.',
            targetBorderRadius: BorderRadius.circular(16),
            child: tile,
          );
        }
        return tile;
      },
    );
  }

  // ── Quick access header (label + edit button) ──────────────────────────────

  Widget _buildQuickHeader(BuildContext context, ColorScheme cs) {
    return Showcase(
      key: _scQuickAccessKey,
      title: 'Quick Access',
      description:
          'Pin the calculators and tools you reach for most. Tap "Edit" '
          'to add or remove tiles.',
      targetBorderRadius: BorderRadius.circular(8),
      child: Row(
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined, size: 13, color: cs.primary),
                  const SizedBox(width: 5),
                  Text(
                    'Edit',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick chips ───────────────────────────────────────────────────────────

  Widget _buildQuickChips(BuildContext context, ColorScheme cs, bool isDark) {
    final chipBg = isDark ? AppTheme.dCard : Colors.white;
    final chipBorder = isDark ? AppTheme.dBorder : const Color(0xFFCBD8EB);

    final bool _iosChip = !kIsWeb && Platform.isIOS;
    final visible = _allChips
        .where((c) => _selectedKeys.contains(c.key))
        .where((c) => !_iosChip || c.key != 'formulary')
        .toList();

    if (visible.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'No quick items selected. Tap Edit to add some.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: cs.onSurface.withValues(alpha: 0.4),
          ),
        ),
      );
    }

    // Horizontal-scrolling carousel — with the new default of 26 chips,
    // a Wrap would push the page down by 4-5 rows. ListView.separated keeps
    // the row a single line and slides under the user's finger on Android +
    // iOS without fighting the parent CustomScrollView (we cap with
    // shrinkWrap + a fixed height).
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        itemCount: visible.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final c = visible[i];
          return InkWell(
            onTap: () => _navigateChip(context, c.key),
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: chipBg,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: chipBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(c.icon, size: 15, color: cs.primary),
                  const SizedBox(width: 6),
                  Text(
                    c.label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Edit quick access bottom sheet ─────────────────────────────────────────

  void _showEditQuickAccess(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            final cs = Theme.of(ctx).colorScheme;
            final maxH = MediaQuery.of(ctx).size.height * 0.85;
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxH),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: cs.outline,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.tune_rounded, color: cs.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Customise Quick Access',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Select which shortcuts appear on your home screen.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 8),
                        children: [
                          for (final chip in _allChips)
                            Builder(
                              builder: (_) {
                                final selected = _selectedKeys.contains(
                                  chip.key,
                                );
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
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: cs.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      chip.icon,
                                      color: cs.primary,
                                      size: 18,
                                    ),
                                  ),
                                  title: Text(
                                    chip.label,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                  activeColor: cs.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  dense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Done',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _navigateChip(BuildContext context, String key) {
    final routes = <String, Widget Function()>{
      'gir': () => const GIRCalculator(),
      'gas': () => const BloodGasAnalyser(),
      'tpn': () => const TpnCalculator(),
      'cga': () => const CGAPMACalculator(),
      'ponderal': () => const PonderalIndexCalculator(),
      'mph': () => const MidParentalHeightCalculator(),
      'bsa': () => const BSACalculator(),
      'bp': () => const BPHubScreen(),
      'neobp': () => const NeonatalBPCalculator(),
      'bili': () => const JaundiceHubScreen(),
      'fluid': () => const MaintenanceFluidCalculator(),
      'burn': () => const BurnMortalityCalculator(),
      'parkland': () => const ParklandCalculatorScreen(),
      'lund': () => const LundBrowderScreen(),
      'pet': () => const PETCalculatorScreen(),
      'egfr': () => const SchwartzEGFRCalculator(),
      'ga': () => const GestationalAgeCalculator(),
      'vent': () => const VentilatorParameters(),
      'nutri': () => const NutritionalAuditCalculator(),
      'dve': () => const DoubleVolumeExchange(),
      'allcalc': () => const CalculatorsScreen(),
      'growth': () => const GrowthChartsScreen(),
      'devmile': () => const DevMilestonesHub(),
      'tdsc': () => const TdscAssistantScreen(),
      'formulary': () => const FormularyScreen(),
      'labref': () => const LabReferenceScreen(),
      'guides': () => const GuidesScreen(),
      'cme': () => const CmeScreen(),
      'academics': () => const AcademicsWebScreen(),
      'resources': () => const ResourcesScreen(),
    };
    final builder = routes[key];
    if (builder == null) return;
    // Record into Recents using the chip's display label.
    final chip = _allChips.firstWhere(
      (c) => c.key == key,
      orElse: () => const _ChipDef('', '', Icons.apps_rounded),
    );
    if (chip.label.isNotEmpty) {
      // ignore: unawaited_futures
      RecentsService.instance.record(key, chip.label);
    }
    // Gated here too: Quick Access and Recents reach calculators without
    // going through the calculators list, so a tool withdrawn from service
    // must be unreachable from every route into it, not just the obvious one.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ToolGate(toolId: key, child: builder()),
      ),
    );
  }

  // ── Admin tile (only rendered when currentUser.role == 'admin') ──────────
  // Currently unreferenced — auth is disabled for testing. Kept for easy
  // restoration when login is re-enabled.
  // ignore: unused_element
  Widget _buildAdminTile(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AdminDashboardScreen())),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFDC2626), Color(0xFF991B1B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33DC2626),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.admin_panel_settings_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Dashboard',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Review pending CMEs, chapters, and role requests',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
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
                fontSize: 12,
                color: cs.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── References & Sources link ─────────────────────────────────────────────

  Widget _buildReferencesLink(BuildContext context, ColorScheme cs) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ReferencesScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFEEF2FF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark
                ? const Color(0xFF4F46E5).withValues(alpha: 0.35)
                : const Color(0xFFC7D2FE),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.menu_book_rounded,
              size: 16,
              color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'References & Sources — Neofax, Harriet Lane, IAP STG, WHO & more',
                style: TextStyle(
                  fontSize: 11.5,
                  color: isDark
                      ? const Color(0xFF818CF8)
                      : const Color(0xFF3730A3),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: isDark
                  ? const Color(0xFF818CF8).withValues(alpha: 0.6)
                  : const Color(0xFF4F46E5).withValues(alpha: 0.6),
            ),
          ],
        ),
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
          border: Border.all(color: accent.withValues(alpha: 0.35), width: 1.5),
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
                  color: accent.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.lightbulb_rounded,
                color: accent,
                size: 22,
              ),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
    final drawerBg = isDark ? AppTheme.dSurface : Colors.white;
    final gradStart = isDark
        ? const Color(0xFF1A2744)
        : const Color(0xFF1565C0);
    final gradEnd = isDark ? const Color(0xFF232D42) : const Color(0xFF1E88E5);

    return Drawer(
      backgroundColor: drawerBg,
      width: 280,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gradStart, gradEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.child_care_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'PediAid',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Paediatric & Neonatal Reference',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // Minimal drawer: the main features (calculators, charts,
                // formulary, lab reference, guides, CME, academics) are the
                // primary tiles on the home screen itself, so they've been
                // removed from the drawer to keep it a quiet utility menu.
                _DrawerItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  onTap: () => Navigator.pop(context),
                ),
                _DrawerItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.info_outline_rounded,
                  label: 'About',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutScreen()),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.menu_book_rounded,
                  label: 'References & Sources',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReferencesScreen(),
                      ),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.account_circle_outlined,
                  label: 'Account',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AccountScreen()),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.bookmark_border,
                  label: 'Saved',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SavedScreen()),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.fact_check_outlined,
                  label: 'My Submissions',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MySubmissionsScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 24, indent: 16, endIndent: 16),
                // ── Rate, Share, Web, Feedback ────────────────────────
                _DrawerItem(
                  icon: Icons.star_rounded,
                  label: 'Rate PediAid',
                  onTap: () async {
                    Navigator.pop(context);
                    // requestReview() is quota-limited by Google and does
                    // nothing at all when the app was not installed from the
                    // Play Store — a sideloaded build gets silence, with no
                    // error to explain it. isAvailable() does not catch that,
                    // so the tap has to fall back to the store listing rather
                    // than trusting the card appeared.
                    final review = InAppReview.instance;
                    var shown = false;
                    try {
                      if (await review.isAvailable()) {
                        await review.requestReview();
                        shown = true;
                      }
                    } catch (_) {
                      // Fall through to the listing below.
                    }
                    if (!shown) {
                      await launchUrl(
                        Uri.parse(
                          'https://play.google.com/store/apps/details'
                          '?id=com.pediaid.pediaid',
                        ),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                ),
                _DrawerItem(
                  icon: Icons.share_rounded,
                  label: 'Share with Colleagues',
                  onTap: () {
                    Navigator.pop(context);
                    Share.share(
                      'Check out PediAid — a free paediatric & neonatal clinical reference app for drug doses, calculators, and growth charts.\n\n'
                      '📱 iOS: https://apps.apple.com/app/id6748139585\n'
                      '🤖 Android: https://play.google.com/store/apps/details?id=com.pediaid.pediaid',
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.language_rounded,
                  label: 'Visit Web App',
                  onTap: () async {
                    Navigator.pop(context);
                    await launchUrl(
                      Uri.parse('https://pediaid.bridgr.co.in'),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.hub_rounded,
                  label: 'Bridgr Ecosystem',
                  onTap: () async {
                    Navigator.pop(context);
                    await launchUrl(
                      Uri.parse('https://bridgr.co.in'),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.feedback_outlined,
                  label: 'Send Feedback',
                  onTap: () async {
                    Navigator.pop(context);
                    await launchUrl(
                      Uri.parse(
                        'mailto:$kSupportEmail?subject=PediAid%20Feedback',
                      ),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'PediAid v${AppConfigService.instance.versionLabel.isEmpty ? "1.3.0" : AppConfigService.instance.versionLabel}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
              textAlign: TextAlign.center,
            ),
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

  /// Draws the card in warm amber instead of plain white.
  ///
  /// Reserved for one card at a time. The grid works because every tile looks
  /// alike and the eye scans them evenly — highlighting a second one would
  /// just restore that uniformity at a louder volume and single out neither.
  final bool highlight;

  const _FeatureDef(
    this.title,
    this.subtitle,
    this.icon,
    this.accent,
    this.onTap, {
    this.highlight = false,
  });
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
    final cs = Theme.of(context).colorScheme;
    // Amber wash for the highlighted card. Tinted rather than saturated: it
    // has to read as "start here" against a grid of white tiles without
    // fighting the icon colour or looking like a warning.
    const highlightBg = Color(0xFFFFF8E1);
    const highlightBorder = Color(0xFFFFC107);
    const highlightBgDark = Color(0xFF2A2415);

    final cardBg = card.highlight
        ? (isDark ? highlightBgDark : highlightBg)
        : (isDark ? AppTheme.dCard : Colors.white);
    final border = card.highlight
        ? highlightBorder
        : (isDark ? AppTheme.dBorder : const Color(0xFFCBD8EB));
    final accent = card.accent;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: border,
          width: card.highlight ? 1.6 : 1.0,
        ),
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: isDark ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(card.icon, color: accent, size: 22),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.title,
                    style: GoogleFonts.plusJakartaSans(
                      color: cs.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    card.subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      color: cs.onSurface.withValues(alpha: 0.55),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
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
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: cs.primary, size: 22),
      title: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          color: cs.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}

// ── Recents row ──────────────────────────────────────────────────────────────

class _RecentsRow extends StatelessWidget {
  /// Open handler — receives the recorded module key and routes to the
  /// matching screen via [_navigateChip].
  final void Function(String key) onOpen;
  const _RecentsRow({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ValueListenableBuilder<List<RecentItem>>(
      valueListenable: RecentsService.instance.notifier,
      builder: (context, items, _) {
        if (items.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.history_rounded, size: 16, color: cs.primary),
                  const SizedBox(width: 6),
                  Text(
                    'RECENTS',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final item = items[i];
                    final chip = _allChips.firstWhere(
                      (c) => c.key == item.key,
                      orElse: () =>
                          _ChipDef(item.key, item.label, Icons.history_rounded),
                    );
                    return _RecentChip(
                      label: item.label,
                      icon: chip.icon,
                      onTap: () => onOpen(item.key),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RecentChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _RecentChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: cs.primaryContainer.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: cs.primary),
            const SizedBox(width: 7),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: cs.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Web-only platform notice ──────────────────────────────────────────────────

/// Two one-line boxes above the feature grid, web only.
///
/// The single message that matters per platform, and nothing else: iPhone
/// users need to know THIS is the full PediAid (the iOS app is reduced under
/// App Store policy), Android users need to know the Play app is. Sits above
/// the primary grid, so it is written to be caught in a glance — one bold
/// hook, one short line. Anything longer here gets skipped, not read.
class _PlatformNoticeBoxes extends StatelessWidget {
  const _PlatformNoticeBoxes({required this.cs});

  final ColorScheme cs;

  static const _playUrl =
      'https://play.google.com/store/apps/details?id=com.pediaid.pediaid';

  @override
  Widget build(BuildContext context) {
    final apple = _NoticeBox(
      icon: Icons.apple_rounded,
      accent: const Color(0xFF1565C0),
      title: 'iPhone / iPad?',
      line:
          'Use this web version — it has everything. '
          'The iOS app is limited by App Store rules.',
    );
    final android = _NoticeBox(
      icon: Icons.android_rounded,
      accent: const Color(0xFF2E7D32),
      title: 'Android?',
      line: 'Get the full app on Google Play →',
      onTap: () =>
          launchUrl(Uri.parse(_playUrl), mode: LaunchMode.externalApplication),
    );

    return LayoutBuilder(
      builder: (context, box) {
        if (box.maxWidth >= 640) {
          // IntrinsicHeight, not CrossAxisAlignment.stretch: this sits in a
          // scrollable Column, so a stretching Row asks for unbounded height
          // and throws — taking the whole home grid down with it.
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: apple),
                const SizedBox(width: 12),
                Expanded(child: android),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [apple, const SizedBox(height: 10), android],
        );
      },
    );
  }
}

class _NoticeBox extends StatelessWidget {
  const _NoticeBox({
    required this.icon,
    required this.accent,
    required this.title,
    required this.line,
    this.onTap,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final String line;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: accent.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: accent.withValues(alpha: 0.35)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: accent),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      height: 1.4,
                      color: cs.onSurface.withValues(alpha: 0.85),
                    ),
                    children: [
                      TextSpan(
                        text: '$title  ',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: accent,
                        ),
                      ),
                      TextSpan(text: line),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
