import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'services/lab_reference_service.dart';
import 'services/auth_service.dart';

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
      home: const _AuthGate(),
    );
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
