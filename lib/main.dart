import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'deep_links.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/profile/profile_gate.dart';
import 'widgets/app_config_gate.dart';
import 'services/tool_registry.dart';
import 'services/lab_reference_service.dart';
import 'services/auth_service.dart';
import 'services/profile_store.dart';
import 'services/guidelines_search_service.dart';
import 'services/recents_service.dart';
import 'services/push_service.dart';
import 'services/profile_migration.dart';
import 'services/profile_sync.dart';
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
    ).timeout(const Duration(seconds: 8));
  } on UnsupportedError catch (e) {
    debugPrint('[boot] Firebase not configured for this platform: $e');
  } catch (e) {
    // Includes TimeoutException — a stuck init must never block boot.
    debugPrint('[boot] Firebase.initializeApp failed: $e');
  }

  // Pre-load the Firebase auth session so the _AuthGate shows the correct
  // screen on the very first frame — avoids a flash of the login screen for
  // already-signed-in users.
  final authProvider = AuthProvider();
  try {
    // preferCache: the profile document is read from Firestore's on-disk
    // cache, not the network. Deciding between the home screen and the login
    // screen does not need a fresh copy, and waiting for one put a network
    // round-trip in front of the first frame on every single launch.
    await authProvider.loadCurrentUser(preferCache: true);
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
  // so CME/admin screens gated on the legacy session don't show "signed out"
  // underneath an otherwise-signed-in app.
  //
  // NOT awaited. This is a Firebase token refresh followed by a POST to the
  // backend, and it was the single worst thing in this function: on a cold
  // start the token has usually expired (one-hour life) and the backend
  // instance is asleep, so the sequence could take tens of seconds — all of
  // it before the first frame, with nothing on screen. That is the
  // "sometimes the app takes forever to open" on Android.
  //
  // It is safe to let it land late because AuthProvider is a ChangeNotifier
  // and _bridgeLegacySession now notifies when it resolves, so anything
  // gated on the legacy session rebuilds itself. The worst case is a second
  // or two where a CME screen thinks it is signed out — against a blank
  // screen for everyone, on every launch, that is not a close call.
  // ignore: unawaited_futures
  authProvider.bridgeLegacySessionIfNeeded().catchError((Object e) {
    debugPrint('[boot] legacy bridge failed: $e');
  });

  // And bring the cached profile up to date behind the first frame, so
  // preferCache above cannot leave a renamed or re-roled account stale.
  // ignore: unawaited_futures
  authProvider.refreshCurrentUser();

  // One-shot rescue of profile data that only ever existed on this device.
  //
  // The Account screen wrote age, gender and qualifications to
  // SharedPreferences and nowhere else, so that data has never been readable
  // by anyone and every reinstall deletes it permanently. This copies it into
  // Firestore, filling gaps only — the server wins wherever it has a value.
  //
  // Not awaited, and it cannot throw: a failed rescue leaves its marker unset
  // and simply tries again on the next launch.
  // Retry any profile sync a previous launch could not complete — usually
  // because the legacy session had not been bridged yet when the form was
  // saved. A no-op when nothing is owed.
  // ignore: unawaited_futures
  retryPendingProfileSync();

  // ignore: unawaited_futures
  migrateLocalProfileToFirestore(
    service: authProvider.service,
    currentUser: authProvider.currentUser,
  );

  // Doctor profile (name, age, gender, emoji, qualifications, specialty)
  // lives in SharedPreferences. Use Firebase auth name as the initial
  // fallback for brand-new installs.
  try {
    await ProfileStore.instance.load(
      fallbackFullName:
          authProvider.currentUser?.name ??
          AuthService.instance.currentUser?.fullName,
    );
  } catch (e) {
    debugPrint('[boot] ProfileStore load failed: $e');
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

  // Pick up any neonatal score that lives only in nicu_scores.json, so home
  // search finds it without anyone having to name it in the registry too.
  // Fire-and-forget: search works without it, it just knows less.
  // ignore: unawaited_futures
  ToolRegistry.instance.registerAssetScores();

  // Push notifications (Android + web only for now — see push_service.dart).
  // Fire-and-forget: a slow Firebase handshake must never block app start.
  PushService.messengerKey = rootMessengerKey;
  PushService.navigatorKey = reportNavigatorKey;
  // ignore: unawaited_futures
  PushService.instance.init();

  try {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  } catch (e) {
    debugPrint('[boot] System UI config failed: $e');
  }

  // Web-only deep link: if this tab was opened at a URL like
  // pediaid.bridgr.co.in/#fenton-growth-chart (e.g. from an SEO landing
  // page's "Open in PediAid" button), push that one screen on top of
  // whatever the normal boot flow renders. Navigator.push always shows the
  // new route full-screen regardless of what's underneath, so this works
  // the same whether the visitor is signed in or not, and it never touches
  // any existing screen's own navigation.
  if (kIsWeb) {
    final builder = resolveDeepLink();
    if (builder != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        reportNavigatorKey.currentState?.push(
          MaterialPageRoute(builder: builder),
        );
      });
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const PediAidApp(),
    ),
  );
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
      // Lets HomeScreen know when a route pushed above it (the profile-setup
      // step, on a first install) has been popped, so the coachmark tour can
      // wait its turn instead of drawing over whatever is on top.
      navigatorObservers: [appRouteObserver],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // AppConfigGate is outermost: if a released build is known to be
      // unsafe, that must be decided before anything else is shown. It is
      // invisible unless app-config.json says otherwise.
      home: const AppConfigGate(child: _OnboardingGate(child: _AuthGate())),
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
/// Watches route pushes and pops so a screen can react to being covered or
/// uncovered. Needed because the interactive tutorial starts from HomeScreen's
/// first frame, which on a first install happens while the profile-setup step
/// is still pushed on top of it.
final RouteObserver<ModalRoute<void>> appRouteObserver =
    RouteObserver<ModalRoute<void>>();

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
    // hasBootstrapped, not isLoading: isLoading also flips true/false on
    // every later sign-in attempt made FROM LoginScreen, and swapping the
    // whole screen on that would tear LoginScreen down mid-submit — see
    // the comment on AuthProvider.hasBootstrapped.
    if (!auth.hasBootstrapped) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    // ProfileGate sits between the two: signed in is not enough, the profile
    // has to be complete. See profile_gate.dart.
    return auth.isLoggedIn
        ? const ProfileGate(child: HomeScreen())
        : const LoginScreen();
  }
}
