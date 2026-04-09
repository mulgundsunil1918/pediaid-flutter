// =============================================================================
// lib/services/auth_service.dart
//
// Singleton wrapping the JWT auth state for the PediAid Flutter app. Talks
// to the same /api/academics/auth endpoints as the React academics frontend
// so the two surfaces share one identity per user.
//
// The access token and a JSON blob of the current user are stored in
// FlutterSecureStorage so the app resumes signed in across cold restarts.
// Uses ChangeNotifier so the auth-gate widget in main.dart can listen for
// login / logout and push-and-replace to the correct screen.
// =============================================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Simple user model — only the fields the Flutter app actually displays.
// ---------------------------------------------------------------------------

class AuthUser {
  final String id;
  final String email;
  final String role;
  final String? fullName;

  const AuthUser({
    required this.id,
    required this.email,
    required this.role,
    this.fullName,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] as Map<String, dynamic>?;
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      fullName: profile?['fullName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'role': role,
        if (fullName != null) 'profile': {'fullName': fullName},
      };
}

// ---------------------------------------------------------------------------
// AuthException — user-facing error with a readable message.
// ---------------------------------------------------------------------------

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}

// ---------------------------------------------------------------------------
// AuthService singleton
// ---------------------------------------------------------------------------

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._();
  AuthService._();

  // Allow overriding the API base at build time:
  //   flutter build web --dart-define=PEDIAID_API_BASE=http://localhost:3002
  static const String apiBase = String.fromEnvironment(
    'PEDIAID_API_BASE',
    defaultValue: 'https://pediaid-backend.onrender.com',
  );

  // Secure, on-device storage for the JWT + user blob.
  //
  // On mobile (Android/iOS) flutter_secure_storage uses the Keychain /
  // EncryptedSharedPreferences and is rock-solid. On web it's backed by
  // IndexedDB + WebCrypto — which is fine most of the time but CAN fail
  // on first boot, in private browsing, or after the browser evicts
  // storage for a GitHub Pages origin. When that happens, the user is
  // silently signed out on every page reload, which is the exact bug the
  // user reported.
  //
  // Fix: on WEB only, ALSO mirror the token + user blob into
  // SharedPreferences (which is backed by plain localStorage on web).
  // localStorage survives page reloads for the origin and is the standard
  // choice for a long-lived token on the web. Mobile still uses
  // flutter_secure_storage as its source of truth — SharedPreferences
  // is only touched on kIsWeb.
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _kAccessToken = 'pediaid_access_token';
  static const _kUserBlob = 'pediaid_user_blob';

  String? _accessToken;
  AuthUser? _user;

  String? get accessToken => _accessToken;
  AuthUser? get currentUser => _user;
  bool get isLoggedIn => _accessToken != null && _user != null;

  /// Load the cached session from persistent storage (called on app boot).
  /// On web, falls back to SharedPreferences if FlutterSecureStorage returns
  /// nothing, and also hydrates from it if the secure backend threw.
  Future<void> loadFromStorage() async {
    String? token;
    String? blob;

    // First try flutter_secure_storage (works on mobile; sometimes works on web).
    try {
      token = await _storage.read(key: _kAccessToken);
      blob = await _storage.read(key: _kUserBlob);
    } catch (e) {
      debugPrint('[AuthService] secure_storage read failed: $e');
    }

    // On web: if secure storage came back empty or failed, try the
    // localStorage-backed SharedPreferences fallback.
    if (kIsWeb && (token == null || token.isEmpty || blob == null)) {
      try {
        final prefs = await SharedPreferences.getInstance();
        token = prefs.getString(_kAccessToken);
        blob = prefs.getString(_kUserBlob);
      } catch (e) {
        debugPrint('[AuthService] shared_prefs fallback read failed: $e');
      }
    }

    if (token != null && token.isNotEmpty && blob != null) {
      try {
        _accessToken = token;
        _user = AuthUser.fromJson(jsonDecode(blob) as Map<String, dynamic>);
      } catch (_) {
        // Corrupted blob — wipe and stay signed out
        _accessToken = null;
        _user = null;
        await _wipeStorage();
      }
    }
    notifyListeners();
  }

  /// Persist the token + user blob to every storage backend we use, so a
  /// later boot via any one of them succeeds.
  Future<void> _persistSession(String token, String userJsonStr) async {
    // Fire-and-forget — don't block the UI on IO errors.
    try {
      await _storage.write(key: _kAccessToken, value: token);
      await _storage.write(key: _kUserBlob, value: userJsonStr);
    } catch (e) {
      debugPrint('[AuthService] secure_storage write failed: $e');
    }
    if (kIsWeb) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_kAccessToken, token);
        await prefs.setString(_kUserBlob, userJsonStr);
      } catch (e) {
        debugPrint('[AuthService] shared_prefs write failed: $e');
      }
    }
  }

  Future<void> _wipeStorage() async {
    try {
      await _storage.delete(key: _kAccessToken);
      await _storage.delete(key: _kUserBlob);
    } catch (_) {}
    if (kIsWeb) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_kAccessToken);
        await prefs.remove(_kUserBlob);
      } catch (_) {}
    }
  }

  // -------------------------------------------------------------------------
  // Email + password
  // -------------------------------------------------------------------------

  Future<void> loginEmailPassword(String email, String password) async {
    final res = await http
        .post(
          Uri.parse('$apiBase/api/academics/auth/login'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email.trim(), 'password': password}),
        )
        .timeout(const Duration(seconds: 30));

    _handleAuthResponse(res);
  }

  Future<void> registerEmailPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final registerRes = await http
        .post(
          Uri.parse('$apiBase/api/academics/auth/register'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email.trim(),
            'password': password,
            'fullName': fullName.trim(),
          }),
        )
        .timeout(const Duration(seconds: 30));

    if (registerRes.statusCode != 201) {
      throw AuthException(_extractErrorMessage(registerRes));
    }

    // Register returns 201 but no token — auto-login to land them signed in.
    await loginEmailPassword(email, password);
  }

  // -------------------------------------------------------------------------
  // Forgot password (kicks off the email; reset is completed on the web)
  // -------------------------------------------------------------------------

  Future<void> forgotPassword(String email) async {
    await http
        .post(
          Uri.parse('$apiBase/api/academics/auth/forgot-password'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email.trim()}),
        )
        .timeout(const Duration(seconds: 30));
    // Always treated as success — the endpoint never reveals whether the
    // email matched an account.
  }

  // -------------------------------------------------------------------------
  // Logout
  // -------------------------------------------------------------------------

  /// Sign out.
  ///
  /// Clears the in-memory session state FIRST and notifies listeners inside
  /// a finally block so _AuthGate always rebuilds to LoginScreen — even if
  /// flutter_secure_storage throws while wiping the persisted blob. A
  /// previous version awaited the storage deletes before notifying, which
  /// meant a flaky secure-storage backend could leave the user visibly
  /// signed in until they restarted the app.
  Future<void> logout() async {
    _accessToken = null;
    _user = null;
    // Wipe every backend so a lingering token in either doesn't silently
    // sign the user back in on the next boot.
    await _wipeStorage();
    notifyListeners();
  }

  // -------------------------------------------------------------------------
  // Authorised HTTP helpers (used by NotificationsService + any future
  // authenticated call in the Flutter app).
  // -------------------------------------------------------------------------

  Map<String, String> get authHeaders => {
        'Content-Type': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      };

  // -------------------------------------------------------------------------
  // Internal helpers
  // -------------------------------------------------------------------------

  void _handleAuthResponse(http.Response res) {
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw AuthException(_extractErrorMessage(res));
    }

    final Map<String, dynamic> body;
    try {
      body = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      throw const AuthException('Server returned an unexpected response.');
    }

    final token = body['accessToken'] as String?;
    final userJson = body['user'] as Map<String, dynamic>?;
    if (token == null || userJson == null) {
      throw const AuthException('Server response missing token or user.');
    }

    _accessToken = token;
    _user = AuthUser.fromJson(userJson);

    // Persist to every backend we use (secure_storage on mobile + both
    // backends on web) so the next boot picks the session up no matter
    // which storage layer happens to be working.
    _persistSession(token, jsonEncode(userJson));

    notifyListeners();
  }

  String _extractErrorMessage(http.Response res) {
    try {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final msg = body['message'] as String?;
      if (msg != null && msg.isNotEmpty) return msg;
    } catch (_) {}
    switch (res.statusCode) {
      case 400:
        return 'That request was not valid. Please check your inputs.';
      case 401:
        return 'Invalid email or password.';
      case 403:
        return 'Access denied.';
      case 404:
        return 'Not found.';
      case 409:
        return 'That email is already registered. Please sign in instead.';
      case 429:
        return 'Too many attempts. Please wait a minute and try again.';
      default:
        return 'Something went wrong (${res.statusCode}). Please try again.';
    }
  }
}
