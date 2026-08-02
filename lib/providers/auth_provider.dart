// =============================================================================
// lib/providers/auth_provider.dart
//
// ChangeNotifier wrapping FirebaseAuthService. Every auth call follows the
// same shape: clear error, set loading, call service, store result, clear
// loading, return bool success. The UI watches this provider and never calls
// the service layer directly.
//
// Note: AuthProvider does NOT subscribe to authStateChanges() — it loads
// the user imperatively via loadCurrentUser() at boot (called from main.dart
// before runApp) and sets _currentUser after each successful sign-in call.
// External auth changes (token revocation on another device) won't auto-
// propagate; the user will see a Firestore permission error on their next
// action and can sign out / back in.
// =============================================================================

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../services/firebase_auth_service.dart';
import '../utils/friendly_error.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _service;

  AuthProvider({FirebaseAuthService? service})
      : _service = service ?? FirebaseAuthService();

  AppUser? _currentUser;
  bool _isLoading = false;
  bool _hasBootstrapped = false;
  String? _error;

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  /// True once the one-time boot hydration (loadCurrentUser at app launch)
  /// has finished, success or failure. _AuthGate uses this — NOT isLoading —
  /// to decide when to stop showing its spinner. isLoading toggles again on
  /// every later sign-in/out/register call; if _AuthGate swapped on that too,
  /// it would tear down LoginScreen (and whatever error it just set) mid-
  /// submit on every failed attempt, replacing it with a blank new instance.
  bool get hasBootstrapped => _hasBootstrapped;

  /// True when the signed-in user uses email + password (not Google or Apple).
  /// Used by the delete-account flow to decide whether to prompt for password.
  bool get isEmailUser => _service.providerIds.contains('password');

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  // ── Boot ──────────────────────────────────────────────────────────────────

  /// Called once in main() before runApp() to hydrate the Firebase session.
  Future<bool> loadCurrentUser() async {
    _setLoading(true);
    try {
      _currentUser = await _service.getCurrentUser();
      _error = null;
    } catch (e) {
      _error = friendlyError(e);
      debugPrint('[AuthProvider] loadCurrentUser: $e');
    }
    _hasBootstrapped = true;
    _setLoading(false);
    return _currentUser != null;
  }

  /// Bridges an already-loaded Firebase session to the legacy backend, but
  /// only if the legacy session isn't already present. Call this from
  /// main.dart AFTER both AuthProvider.loadCurrentUser() and
  /// AuthService.instance.loadFromStorage() have run at boot, so the
  /// isLoggedIn check below reflects the legacy session actually restored
  /// from its own storage rather than its pre-hydration default.
  Future<void> bridgeLegacySessionIfNeeded() async {
    if (_currentUser != null && !AuthService.instance.isLoggedIn) {
      await _bridgeLegacySession(_currentUser!);
    }
  }

  // ── Email / password ──────────────────────────────────────────────────────

  Future<bool> signIn(String email, String password) async {
    _error = null;
    _setLoading(true);
    try {
      _currentUser = await _service.signIn(email, password);
      if (_currentUser != null) await _bridgeLegacySession(_currentUser!);
      _setLoading(false);
      return _currentUser != null;
    } catch (e) {
      _error = friendlyError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _error = null;
    _setLoading(true);
    try {
      _currentUser = await _service.registerUser(
        name: name,
        email: email,
        password: password,
      );
      if (_currentUser != null) await _bridgeLegacySession(_currentUser!);
      _setLoading(false);
      return _currentUser != null;
    } catch (e) {
      _error = friendlyError(e);
      _setLoading(false);
      return false;
    }
  }

  // ── Social ────────────────────────────────────────────────────────────────

  Future<bool> signInWithGoogle() async {
    _error = null;
    _setLoading(true);
    try {
      _currentUser = await _service.signInWithGoogle();
      if (_currentUser != null) await _bridgeLegacySession(_currentUser!);
      _setLoading(false);
      return _currentUser != null;
    } catch (e) {
      _error = friendlyError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    _error = null;
    _setLoading(true);
    try {
      _currentUser = await _service.signInWithApple();
      if (_currentUser != null) await _bridgeLegacySession(_currentUser!);
      _setLoading(false);
      return _currentUser != null;
    } catch (e) {
      _error = friendlyError(e);
      _setLoading(false);
      return false;
    }
  }

  // ── Sign out ──────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    _error = null;
    try {
      await _service.signOut();
    } catch (e) {
      debugPrint('[AuthProvider] signOut: $e');
    }
    try {
      await AuthService.instance.logout();
    } catch (e) {
      debugPrint('[AuthProvider] legacy signOut: $e');
    }
    _currentUser = null;
    notifyListeners();
  }

  // ── Password reset ────────────────────────────────────────────────────────

  Future<void> sendPasswordReset(String email) async {
    await _service.sendPasswordReset(email);
  }

  // ── Profile ───────────────────────────────────────────────────────────────

  Future<void> updateProfile({
    String? name,
    String? avatarEmoji,
    String? specialty,
  }) async {
    await _service.updateProfile(
      name: name,
      avatarEmoji: avatarEmoji,
      specialty: specialty,
    );
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        avatarEmoji: avatarEmoji,
        specialty: specialty,
      );
      notifyListeners();
    }
  }

  // ── Delete account ────────────────────────────────────────────────────────

  /// Permanently deletes the account after re-authenticating.
  /// [password] is only needed for email/password accounts; social accounts
  /// re-authenticate automatically inside FirebaseAuthService.deleteAccount().
  Future<bool> deleteAccount({String? password}) async {
    _error = null;
    _setLoading(true);
    try {
      await _service.deleteAccount(password: password);
      try {
        await AuthService.instance.deleteAccount();
      } catch (e) {
        debugPrint('[AuthProvider] legacy deleteAccount: $e');
      }
      _currentUser = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _error = friendlyError(e);
      _setLoading(false);
      return false;
    }
  }

  // ── Legacy backend bridge ──────────────────────────────────────────────
  //
  // CME submission, Never Again, and the in-app admin screens still
  // authenticate against the pre-Firebase JWT backend (AuthService /
  // acad_users) — migrating every one of those call sites to Firebase was
  // out of scope here. Instead, every successful Firebase sign-in silently
  // provisions (or logs into) a matching acad_users row using a password
  // nobody ever sees or types: deterministic per Firebase uid, so the same
  // Firebase account always maps to the same backend account.
  //
  // Failures here are swallowed on purpose — the Firebase sign-in has
  // already succeeded and must not be undone by a legacy-backend hiccup;
  // worst case, legacy-gated screens keep showing "not signed in" until the
  // next successful sign-in retries the bridge.
  //
  // Known gap: an account that already existed in acad_users BEFORE this
  // bridge shipped (a real, user-chosen password) will fail both the login
  // and the register attempt below — the email is taken but the password
  // doesn't match. That one row needs a one-time manual reconciliation
  // (update its password hash to match the derived one below).
  Future<void> _bridgeLegacySession(AppUser user) async {
    final bridgePassword = _legacyBridgePassword(user.uid);
    try {
      await AuthService.instance.loginEmailPassword(user.email, bridgePassword);
      return;
    } catch (_) {
      // No existing bridge account yet — fall through to provisioning one.
    }
    try {
      await AuthService.instance.registerEmailPassword(
        email: user.email,
        password: bridgePassword,
        fullName: user.name.isNotEmpty ? user.name : user.email.split('@').first,
      );
    } catch (e) {
      debugPrint('[AuthProvider] legacy bridge failed for ${user.email}: $e');
    }
  }

  String _legacyBridgePassword(String uid) =>
      sha256.convert(utf8.encode('pediaid-firebase-bridge:$uid')).toString();
}
