import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
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
import 'services/push_service.dart';
import 'providers/auth_provider.dart';
import 'utils/prefs_keys.dart';
import 'widgets/report_issue_overlay.dart';

/// Lets foreground push notifications surface a SnackBar on whatever screen
/// is currently open, without per-screen wiring.
final GlobalKey<ScaffoldMessengerState> rootMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Each boot step is wrapped in try/catch so a single failing subsystem
  // can NEVER blank out the whole app.

  try {
    await LabReferenceService().load();
  } catch (e, st) {
    debugPrint('[boot] LabReferenceService load failed: $e\n$st');
  }

  // Firebase must be initialized before any Firebase service (Auth, Firestore,
  // Messaging) is used. On platforms not yet configured in firebase_options.dart
  // (currently iOS — run `flutterfire configure` with --platforms=ios once the
  // Apple developer account is active) this throws UnsupportedError; we catch
  // it so the app still launches for testing on those platforms.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on UnsupportedError catch (e) {
    debugPrint('[boot] Firebase not configured for this platform: $e');
  } catch (e) {
    debugPrint('[boot] Firebase.initializeApp failed: $e');
  }

  // Pre-load the Firebase auth session so the _AuthGate shows the correct
  // screen on the very first frame — avoids a flash of the login screen for
  // already-signed-in users.
  final authProvider = AuthProvider();
  try {
    await authProvider.loadCurrentUser();
  } catch (e) {
    debugPrint('[boot] AuthProvider.loadCurrentUser failed: $e');
  }

  // Legacy JWT auth — kept so existing backend API calls (CME, academics)
  // continue to work. Restores whatever session was persisted last time,
  // whether that was a direct legacy login or a Firebase bridge (below).
  try {
    await AuthService.instance.loadFromStorage();
  } catch (e, st) {
    debugPrint('[boot] AuthService loadFromStorage failed: $e\n$st');
  }

  // If Firebase has a session but the legacy bridge above didn't restore
  // one (e.g. this device signed in via Firebase before the bridge existed,
  // or its legacy session was cleared independently), silently reconnect it
  // now so CME/admin screens gated on the legacy session don't show
  // "signed out" underneath an otherwise-signed-in app.
  try {
    await authProvider.bridgeLegacySessionIfNeeded();
  } catch (e) {
    debugPrint('[boot] legacy bridge failed: $e');
  }

  // Doctor profile (name, age, gender, emoji, qualifications, specialty)
  // lives in SharedPreferences. Use Firebase auth name as the initial
  // fallback for brand-new installs.
  try {
    await ProfileStore.instance.load(
      fallbackFullName: authProvider.currentUser?.name
          ?? AuthService.instance.currentUser?.fullName,
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

  // Push notifications (Android + web only for now — see push_service.dart).
  // Fire-and-forget: a slow Firebase handshake must never block app start.
  PushService.messengerKey = rootMessengerKey;
  // ignore: unawaited_futures
  PushService.instance.init();

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

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: authProvider),
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ],
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
      scaffoldMessengerKey: rootMessengerKey,
      // Lets the report-issue overlay (which lives above the Navigator via
      // `builder`) push its bottom sheet onto the root navigator.
      navigatorKey: reportNavigatorKey,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const _OnboardingGate(child: _AuthGate()),
      // Floats a small "report an issue" button above every screen in the
      // app without needing to touch each of those screen files individually.
      builder: (context, child) => ReportIssueOverlay(child: child!),
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

/// Top-level auth gate. Watches [AuthProvider] (a ChangeNotifier registered
/// in MultiProvider) so logging in or out anywhere in the app triggers an
/// automatic rebuild — no explicit navigation required at those call sites.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return auth.isLoggedIn ? const HomeScreen() : const LoginScreen();
  }
}
