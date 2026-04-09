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
  await LabReferenceService().load();
  // Hydrate the persisted JWT + user blob from secure storage BEFORE the
  // auth gate builds, so the app doesn't flash the login screen on a cold
  // start for an already-signed-in user.
  await AuthService.instance.loadFromStorage();
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
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
