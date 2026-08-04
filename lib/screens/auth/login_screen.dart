// =============================================================================
// lib/screens/auth/login_screen.dart
//
// Wardly-style combined Sign In / Sign Up screen (AUTH_REFERENCE_FROM_WARDLY.md §3).
//
// Layout (top → bottom):
//   1. Colored brand header  — top 34% of screen in primary color
//   2. White sheet overlay   — from top 28%, 32px top corner radius, scrollable
//   3. Sign In / Sign Up toggle
//   4. Full name (sign-up mode only)
//   5. Email + password fields
//   6. Remember device checkbox + Forgot password link
//   7. Primary action button
//   8. OR divider + social buttons (Google everywhere; Apple on iOS)
//
// Post-auth sequence (all three methods):
//   1. Persist "remember me" email
//   2. Mark onboarding complete (future launches skip the slides)
//   3. Kick off FCM registration (needs auth uid)
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
import '../../utils/friendly_error.dart';
import '../../utils/prefs_keys.dart';
import '../onboarding/profile_setup_screen.dart';

enum _Mode { signIn, signUp }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _passwordCtl = TextEditingController();

  _Mode _mode = _Mode.signIn;
  bool _obscure = true;
  bool _rememberDevice = false;
  String? _localError;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    _passwordCtl.dispose();
    super.dispose();
  }

  Future<void> _loadSavedEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(PrefsKeys.rememberedEmail);
      if (saved != null && saved.isNotEmpty && mounted) {
        setState(() {
          _emailCtl.text = saved;
          _rememberDevice = true;
        });
      }
    } catch (_) {}
  }

  Future<void> _persistRememberMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_rememberDevice) {
        await prefs.setString(
            PrefsKeys.rememberedEmail, _emailCtl.text.trim());
      } else {
        await prefs.remove(PrefsKeys.rememberedEmail);
      }
    } catch (_) {}
  }

  Future<void> _postAuthFlow() async {
    _persistRememberMe();
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
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ProfileSetupScreen()),
        );
        return; // ProfileSetupScreen pops back to the first route itself.
      }
    }

    if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _setError(String? msg) {
    if (mounted) setState(() => _localError = msg);
  }

  Future<void> _submit() async {
    _setError(null);
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    bool ok;
    if (_mode == _Mode.signIn) {
      ok = await auth.signIn(_emailCtl.text.trim(), _passwordCtl.text);
    } else {
      ok = await auth.register(
        name: _nameCtl.text.trim(),
        email: _emailCtl.text.trim(),
        password: _passwordCtl.text,
      );
    }
    if (!mounted) return;
    if (!ok) {
      _setError(auth.error ?? 'Something went wrong. Please try again.');
      return;
    }
    await _postAuthFlow();
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

  Future<void> _forgotPassword() async {
    final email = _emailCtl.text.trim();
    final auth = context.read<AuthProvider>();
    try {
      await auth.sendPasswordReset(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password reset link sent — check your inbox.',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      if (mounted) _setError(friendlyError(e));
    }
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
                child: AutofillGroup(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Mode toggle ────────────────────────────────
                        _ModeToggle(
                          mode: _mode,
                          onChanged: (m) => setState(() {
                            _mode = m;
                            _localError = null;
                          }),
                        ),
                        const SizedBox(height: 20),

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

                        // ── Full name (sign-up only) ───────────────────
                        if (_mode == _Mode.signUp) ...[
                          TextFormField(
                            controller: _nameCtl,
                            textCapitalization: TextCapitalization.words,
                            autofillHints: const [AutofillHints.name],
                            enabled: !auth.isLoading,
                            decoration: const InputDecoration(
                              labelText: 'Full name',
                              prefixIcon: Icon(Icons.person_outline_rounded),
                            ),
                            validator: (v) {
                              if ((v ?? '').trim().length < 2) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                        ],

                        // ── Email ──────────────────────────────────────
                        TextFormField(
                          controller: _emailCtl,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          autofillHints: _mode == _Mode.signUp
                              ? const [AutofillHints.newUsername]
                              : const [AutofillHints.email],
                          enabled: !auth.isLoading,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (v) {
                            final s = (v ?? '').trim();
                            if (s.isEmpty) return 'Email is required';
                            if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                .hasMatch(s)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // ── Password ───────────────────────────────────
                        TextFormField(
                          controller: _passwordCtl,
                          obscureText: _obscure,
                          autofillHints: _mode == _Mode.signUp
                              ? const [AutofillHints.newPassword]
                              : const [AutofillHints.password],
                          enabled: !auth.isLoading,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            helperText: _mode == _Mode.signUp
                                ? 'At least 6 characters'
                                : null,
                            prefixIcon:
                                const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if ((v ?? '').length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            if (!auth.isLoading) _submit();
                          },
                        ),
                        const SizedBox(height: 10),

                        // ── Remember me + Forgot password ──────────────
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.85,
                              child: Checkbox(
                                value: _rememberDevice,
                                onChanged: auth.isLoading
                                    ? null
                                    : (v) => setState(
                                        () => _rememberDevice = v ?? false),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            GestureDetector(
                              onTap: auth.isLoading
                                  ? null
                                  : () => setState(() =>
                                      _rememberDevice = !_rememberDevice),
                              child: Text(
                                'Remember this device',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  color: cs.onSurface.withValues(alpha: 0.75),
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (_mode == _Mode.signIn)
                              TextButton(
                                onPressed:
                                    auth.isLoading ? null : _forgotPassword,
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 4),
                                ),
                                child: Text(
                                  'Forgot password?',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: cs.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // ── Primary button ─────────────────────────────
                        SizedBox(
                          height: 50,
                          child: FilledButton(
                            onPressed: auth.isLoading ? null : _submit,
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              _mode == _Mode.signIn
                                  ? 'Sign In'
                                  : 'Create Account',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),

                        // ── Social sign-in ──────────────────────────────
                        // kIsWeb must short-circuit before Platform.isIOS is
                        // ever evaluated (Platform throws on web).
                        const SizedBox(height: 20),
                        _OrDivider(),
                        const SizedBox(height: 16),
                        if (!kIsWeb && Platform.isIOS)
                          Row(
                            children: [
                              Expanded(
                                child: _SocialButton(
                                  icon: Icons.g_mobiledata,
                                  label: 'Google',
                                  iconSize: 24,
                                  onPressed: auth.isLoading
                                      ? null
                                      : _signInGoogle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _SocialButton(
                                  icon: Icons.apple,
                                  label: 'Apple',
                                  iconSize: 22,
                                  onPressed: auth.isLoading
                                      ? null
                                      : _signInApple,
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
                            label: _mode == _Mode.signIn
                                ? 'Continue with Google'
                                : 'Sign up with Google',
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
// Sign In / Sign Up segmented toggle
// ---------------------------------------------------------------------------

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.mode, required this.onChanged});
  final _Mode mode;
  final ValueChanged<_Mode> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 44,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _Tab(
            label: 'Sign In',
            selected: mode == _Mode.signIn,
            onTap: () => onChanged(_Mode.signIn),
          ),
          _Tab(
            label: 'Create Account',
            selected: mode == _Mode.signUp,
            onTap: () => onChanged(_Mode.signUp),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? cs.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected
                  ? cs.onPrimary
                  : cs.onSurface.withValues(alpha: 0.65),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// OR divider
// ---------------------------------------------------------------------------

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: Divider(color: cs.outlineVariant)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: cs.onSurface.withValues(alpha: 0.45),
            ),
          ),
        ),
        Expanded(child: Divider(color: cs.outlineVariant)),
      ],
    );
  }
}

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
