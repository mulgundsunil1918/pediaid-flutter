// =============================================================================
// lib/screens/auth/login_screen.dart
//
// Sign in with Google or Apple. No passwords, and no separate sign-up — the
// account is created the first time someone signs in.
//
// Why the email/password form went away:
//   - Every password becomes a support burden that eventually reaches a human:
//     resets, "which method did I use", weak choices reused from elsewhere.
//   - Both providers hand back an already-verified email, so there is nothing
//     for us to verify and no verification mail to send.
//   - Nothing here stores or transports a credential, so there is no password
//     for this app to leak.
//
// Layout (top -> bottom):
//   1. Colored brand header  — top 34% of screen in primary color
//   2. White sheet overlay   — from top 28%, 32px top corner radius, scrollable
//   3. Provider buttons — Google and Apple side by side on iOS, Google alone
//      elsewhere (native Sign in with Apple is iOS-only in this app)
//
// Post-auth sequence (both methods):
//   1. Mark onboarding complete (future launches skip the slides)
//   2. Kick off FCM registration (needs auth uid)
//   3. Ask for name + specialty if we don't have them yet
//   4. Pop to root — _AuthGate rebuilds to HomeScreen automatically
//
// Platform guard: kIsWeb must short-circuit before Platform.isIOS is evaluated
// (Platform throws on web). All Platform.* refs live inside !kIsWeb blocks.
// =============================================================================

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/auth_provider.dart';
import '../../services/push_service.dart';
import '../../utils/prefs_keys.dart';
import '../onboarding/profile_setup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _localError;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _postAuthFlow() async {
    TextInput.finishAutofillContext();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(PrefsKeys.onboardingComplete, true);
    } catch (_) {}
    try {
      // ignore: unawaited_futures
      PushService.instance.init();
    } catch (_) {}

    // Every sign-in path — email, Google and Apple — funnels through here, so
    // this is the one place the details step needs to be hooked in. The
    // slide-based onboarding runs before sign-in and therefore cannot ask
    // anything about the person; a social sign-up would otherwise leave
    // specialty empty forever, since almost nobody goes looking for Account
    // settings on their own.
    if (mounted) {
      final auth = context.read<AuthProvider>();
      if (needsProfileSetup(auth)) {
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const ProfileSetupScreen()));
        return; // ProfileSetupScreen pops back to the first route itself.
      }
    }

    if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _setError(String? msg) {
    if (mounted) setState(() => _localError = msg);
  }

  Future<void> _signInGoogle() async {
    _setError(null);
    final auth = context.read<AuthProvider>();
    final ok = await auth.signInWithGoogle();
    if (!mounted) return;
    if (!ok) {
      _setError(auth.error ?? 'Google sign-in failed. Please try again.');
      return;
    }
    await _postAuthFlow();
  }

  Future<void> _signInApple() async {
    _setError(null);
    final auth = context.read<AuthProvider>();
    final ok = await auth.signInWithApple();
    if (!mounted) return;
    if (!ok) {
      _setError(auth.error ?? 'Apple sign-in failed. Please try again.');
      return;
    }
    await _postAuthFlow();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final auth = context.watch<AuthProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Brand header ─────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.34,
            child: Container(
              color: cs.primary,
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        color: cs.onPrimary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          'assets/icon/app_icon.png',
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, trace) => Center(
                            child: Text(
                              'P',
                              style: TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w900,
                                color: cs.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'PediAid',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: cs.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Paediatric & Neonatal Clinical Reference',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: cs.onPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── White sheet ──────────────────────────────────────────────────
          Positioned.fill(
            top: size.height * 0.28,
            child: Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Error banner ───────────────────────────────
                    if (_localError != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cs.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _localError!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: cs.onErrorContainer,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // ── Social sign-in ──────────────────────────────
                    // kIsWeb must short-circuit before Platform.isIOS is
                    // ever evaluated (Platform throws on web).
                    const SizedBox(height: 4),
                    if (!kIsWeb && Platform.isIOS)
                      Row(
                        children: [
                          Expanded(
                            child: _SocialButton(
                              icon: Icons.g_mobiledata,
                              label: 'Google',
                              iconSize: 24,
                              onPressed: auth.isLoading ? null : _signInGoogle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _SocialButton(
                              icon: Icons.apple,
                              label: 'Apple',
                              iconSize: 22,
                              onPressed: auth.isLoading ? null : _signInApple,
                              dark: true,
                            ),
                          ),
                        ],
                      )
                    else
                      // Android and web: Google only. On web this uses
                      // FirebaseAuthService's signInWithPopup branch.
                      _SocialButton(
                        icon: Icons.g_mobiledata,
                        label: 'Continue with Google',
                        iconSize: 28,
                        onPressed: auth.isLoading ? null : _signInGoogle,
                        fullWidth: true,
                      ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),

          // ── Loading scrim ────────────────────────────────────────────────
          if (auth.isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.2),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// OR divider
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Social sign-in button (custom OutlinedButton per reference §4)
// ---------------------------------------------------------------------------

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.iconSize = 24.0,
    this.dark = false,
    this.fullWidth = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final double iconSize;
  final bool dark;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fgColor = dark ? (isDark ? Colors.white : Colors.black) : null;
    final borderColor = dark ? (isDark ? Colors.white : Colors.black) : null;

    final button = SizedBox(
      height: 46,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: iconSize),
        label: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: fgColor,
          side: borderColor != null ? BorderSide(color: borderColor) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
