import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'services/lab_reference_service.dart';
import 'services/auth_service.dart';
import 'services/profile_store.dart';
import 'services/review_service.dart';
import 'services/guidelines_search_service.dart';
import 'services/recents_service.dart';
import 'utils/prefs_keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Each boot step is wrapped in try/catch so a single failing subsystem
  // can NEVER blank out the whole app. Before hardening this, an exception
  // in flutter_secure_storage on web (the auth-hydration step) was
  // escaping main() and stopping runApp() from ever being called — the
  // user saw a completely blank page. Now the worst case is a missed
  // feature with an error on the debug console.

  try {
    await LabReferenceService().load();
  } catch (e, st) {
    debugPrint('[boot] LabReferenceService load failed: $e\n$st');
  }

  // Hydrate the persisted JWT + user blob from secure storage BEFORE the
  // auth gate builds, so the app doesn't flash the login screen on a cold
  // start for an already-signed-in user. On web, flutter_secure_storage
  // is backed by WebCrypto + localStorage and CAN throw on first boot
  // (e.g. private browsing) — absolutely must not block main().
  try {
    await AuthService.instance.loadFromStorage();
  } catch (e, st) {
    debugPrint('[boot] AuthService loadFromStorage failed: $e\n$st');
  }

  // Doctor profile (name, age, gender, emoji, qualifications, specialty)
  // lives in SharedPreferences. Hydrate once at boot so the AccountScreen
  // opens instantly. Uses the current auth user's name as the initial
  // full-name fallback for brand-new profiles.
  try {
    await ProfileStore.instance.load(
      fallbackFullName: AuthService.instance.currentUser?.fullName,
    );
  } catch (e) {
    debugPrint('[boot] ProfileStore load failed: $e');
  }

  // Stamp the first-launch timestamp so the in-app review prompt has a
  // valid install-age baseline. Idempotent — only writes if missing.
  try {
    await ReviewService.instance.markFirstLaunchIfMissing();
  } catch (e) {
    debugPrint('[boot] ReviewService init failed: $e');
  }

  // Warm the guideline-chapter search index in the background so the
  // very first home-screen search hit (e.g. "UTI") returns immediately
  // instead of after a network round-trip. Hydrates from cache first
  // (instant) then refreshes from network. Fire-and-forget — never
  // awaited so a slow network can't block app start.
  // ignore: unawaited_futures
  GuidelinesSearchService.instance.ensureLoaded();

  // Hydrate the Recents list (most-recently-opened modules) so the home
  // screen's Recents row paints with content on the first frame.
  try {
    await RecentsService.instance.load();
  } catch (e) {
    debugPrint('[boot] RecentsService load failed: $e');
  }

  try {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarDividerColor: Colors.transparent,
    ));
  } catch (e) {
    debugPrint('[boot] System UI config failed: $e');
  }

  runApp(ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: const PediAidApp(),
  ));
}

class PediAidApp extends StatelessWidget {
  const PediAidApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'PediAid',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // ── AUTH DISABLED FOR TESTING ──────────────────────────────────────────
      // User has asked to remove the login page entirely while testing the
      // app. Jump straight to the HomeScreen; _AuthGate is left in place
      // below for easy restoration later.
      //
      // Wrapped in an OnboardingGate so first-launch users see the slides
      // before the home screen.
      home: const _OnboardingGate(child: HomeScreen()),
    );
  }
}

/// Shows the slide-based onboarding ONCE on first launch (or after a
/// version-bumped redesign), then the wrapped child. Uses
/// [PrefsKeys.onboardingComplete] which is versioned ('_v1') by design —
/// bumping the suffix re-shows the slides to existing users.
class _OnboardingGate extends StatefulWidget {
  final Widget child;
  const _OnboardingGate({required this.child});

  @override
  State<_OnboardingGate> createState() => _OnboardingGateState();
}

class _OnboardingGateState extends State<_OnboardingGate> {
  bool? _onboardingDone; // null = still loading

  @override
  void initState() {
    super.initState();
    _hydrate();
  }

  Future<void> _hydrate() async {
    bool done = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      done = prefs.getBool(PrefsKeys.onboardingComplete) ?? false;
    } catch (e) {
      // If prefs are broken, default to "show onboarding" — better to
      // show it twice than to lock the user out.
      debugPrint('[OnboardingGate] prefs read failed: $e');
    }
    if (mounted) setState(() => _onboardingDone = done);
  }

  @override
  Widget build(BuildContext context) {
    if (_onboardingDone == null) {
      // Brief blank-canvas while we read the flag — no spinner, no flash
      // (the flag read is sub-frame on every device).
      return const Scaffold(body: SizedBox.expand());
    }
    if (_onboardingDone == false) {
      return OnboardingScreen(
        onDone: () {
          if (mounted) setState(() => _onboardingDone = true);
        },
      );
    }
    return widget.child;
  }
}

/// Top-level auth gate. Listens to [AuthService] (a ChangeNotifier) so that
/// logging in or out anywhere in the app triggers an automatic rebuild and
/// swap between the home screen and the login screen — no explicit
/// navigation required at those call sites.
class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  @override
  void initState() {
    super.initState();
    AuthService.instance.addListener(_onAuthChange);
  }

  @override
  void dispose() {
    AuthService.instance.removeListener(_onAuthChange);
    super.dispose();
  }

  void _onAuthChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AuthService.instance.isLoggedIn
        ? const HomeScreen()
        : const LoginScreen();
  }
}
