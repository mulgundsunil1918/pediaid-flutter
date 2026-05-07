// =============================================================================
// lib/services/auth_service.dart
//
// Singleton wrapping the JWT auth state for the PediAid Flutter app. Talks
// to the same /api/academics/auth endpoints as the React academics frontend
// so the two surfaces share one identity per user.
//
// Persistence model mirrors the React store:
//   - accessToken (7 day TTL on the backend, stored as pediaid_access_token)
//   - refreshToken (90 day TTL, stored as pediaid_refresh_token)
//   - user blob (stored as pediaid_user_blob)
//
// Storage backends:
//   - Mobile (Android/iOS): flutter_secure_storage (Keychain /
//     EncryptedSharedPreferences).
//   - Web: flutter_secure_storage mirrored into SharedPreferences
//     (localStorage) because IndexedDB can be evicted on GitHub Pages
//     origins — the mirror is the source of truth on web.
//
// Silent refresh:
//   - On boot, if we have a refresh token, we call /auth/refresh to get a
//     fresh access token before any other call fires. This handles the
//     "I've been logged out" case after an access token expires between
//     sessions.
//   - A periodic timer rotates the access token every 6 days while the
//     app is open, so a tab/app left open for weeks never hits the TTL.
//   - authorizedFetch wraps an HTTP call and, on a 401, tries a refresh
//     once before giving up.
// =============================================================================

import 'dart:async';
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

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _kAccessToken = 'pediaid_access_token';
  static const _kRefreshToken = 'pediaid_refresh_token';
  static const _kUserBlob = 'pediaid_user_blob';

  String? _accessToken;
  String? _refreshToken;
  AuthUser? _user;

  /// Silent-refresh interval while the app is open. Matches the React
  /// frontend: 6 days of runway before the 7-day access token would expire.
  static const Duration _refreshInterval = Duration(days: 6);
  Timer? _refreshTimer;

  /// Deduplicates concurrent refresh attempts so stacked 401s fan out into
  /// a single network call.
  Future<bool>? _inflightRefresh;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  AuthUser? get currentUser => _user;
  bool get isLoggedIn => _accessToken != null && _user != null;

  // -------------------------------------------------------------------------
  // Persistence
  // -------------------------------------------------------------------------

  /// Load the cached session from persistent storage (called on app boot).
  /// On web, falls back to SharedPreferences if FlutterSecureStorage returns
  /// nothing, and also hydrates from it if the secure backend threw.
  ///
  /// After hydrating, if we have a refresh token, fires a silent rotation
  /// in the background so a stale access token never blocks the first
  /// authenticated call the app makes.
  Future<void> loadFromStorage() async {
    String? token;
    String? refresh;
    String? blob;

    // Try flutter_secure_storage first (works on mobile; sometimes works on web).
    try {
      token   = await _storage.read(key: _kAccessToken);
      refresh = await _storage.read(key: _kRefreshToken);
      blob    = await _storage.read(key: _kUserBlob);
    } catch (e) {
      debugPrint('[AuthService] secure_storage read failed: $e');
    }

    // Web fallback — SharedPreferences is backed by localStorage.
    if (kIsWeb && ((token == null || token.isEmpty) || blob == null)) {
      try {
        final prefs = await SharedPreferences.getInstance();
        token   = prefs.getString(_kAccessToken);
        refresh = refresh ?? prefs.getString(_kRefreshToken);
        blob    = prefs.getString(_kUserBlob);
      } catch (e) {
        debugPrint('[AuthService] shared_prefs fallback read failed: $e');
      }
    }
    // Mobile fallback — if secure storage returned no refresh token but
    // an older build wrote one to SharedPreferences, pick it up.
    if (!kIsWeb && refresh == null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        refresh = prefs.getString(_kRefreshToken);
      } catch (_) {}
    }

    if (token != null && token.isNotEmpty && blob != null) {
      try {
        _accessToken = token;
        _refreshToken = refresh;
        _user = AuthUser.fromJson(jsonDecode(blob) as Map<String, dynamic>);
      } catch (_) {
        _accessToken = null;
        _refreshToken = null;
        _user = null;
        await _wipeStorage();
      }
    }
    notifyListeners();

    // Kick off a silent refresh if we have the refresh token — this
    // rotates any access token that's close to expiry before the first
    // authenticated API call fires. Fire-and-forget on purpose.
    if (_refreshToken != null && _refreshToken!.isNotEmpty) {
      unawaited(_silentRefresh());
    }
    _armRefreshTimer();
  }

  /// Persist the token pair + user blob to every storage backend we use.
  Future<void> _persistSession({
    required String token,
    required String? refresh,
    required String userJsonStr,
  }) async {
    try {
      await _storage.write(key: _kAccessToken, value: token);
      if (refresh != null) {
        await _storage.write(key: _kRefreshToken, value: refresh);
      }
      await _storage.write(key: _kUserBlob, value: userJsonStr);
    } catch (e) {
      debugPrint('[AuthService] secure_storage write failed: $e');
    }
    // Always mirror to SharedPreferences on web, and ALSO on mobile so
    // that an older build that only reads from one backend still gets
    // the refresh token on upgrade.
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kAccessToken, token);
      if (refresh != null) {
        await prefs.setString(_kRefreshToken, refresh);
      }
      await prefs.setString(_kUserBlob, userJsonStr);
    } catch (e) {
      debugPrint('[AuthService] shared_prefs write failed: $e');
    }
  }

  Future<void> _wipeStorage() async {
    try {
      await _storage.delete(key: _kAccessToken);
      await _storage.delete(key: _kRefreshToken);
      await _storage.delete(key: _kUserBlob);
    } catch (_) {}
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kAccessToken);
      await prefs.remove(_kRefreshToken);
      await prefs.remove(_kUserBlob);
    } catch (_) {}
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

    await _handleAuthResponse(res);
    _armRefreshTimer();
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
  }

  // -------------------------------------------------------------------------
  // Delete account — Play Store hard requirement
  //
  // Hits DELETE /api/academics/auth/account on the Render backend, then
  // — regardless of the network outcome — wipes the local session so the
  // user lands back on login. Backend MUST hard-delete the user row;
  // there is no soft-delete.
  //
  // Throws AuthException on permanent failures (4xx other than 401, which
  // we treat as success since the account is already gone). 5xx / network
  // errors propagate so the UI can offer a retry, but local session is
  // still cleared so the user isn't trapped.
  // -------------------------------------------------------------------------

  Future<void> deleteAccount() async {
    final token = _accessToken;
    Object? networkError;

    if (token != null && token.isNotEmpty) {
      try {
        final res = await http
            .delete(
              Uri.parse('$apiBase/api/academics/auth/account'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
            )
            .timeout(const Duration(seconds: 30));

        // 204 / 200 = deleted. 401 = token already invalid (treat as deleted).
        // 404 = endpoint not yet implemented on backend — log loudly but
        //       wipe locally anyway so the user can reinstall fresh.
        if (res.statusCode == 404) {
          debugPrint('[AuthService] DELETE /account returned 404 — backend '
              'endpoint not yet implemented. Wiping local session anyway.');
        } else if (res.statusCode >= 400 && res.statusCode != 401) {
          throw AuthException(_extractErrorMessage(res));
        }
      } on AuthException {
        rethrow;
      } catch (e) {
        // Network / timeout / parse failure — keep the error so we can
        // surface it AFTER local wipe, which the UI may want to retry.
        debugPrint('[AuthService] deleteAccount network failure: $e');
        networkError = e;
      }
    }

    // Always clear local session so the user isn't stranded with a half-
    // dead account.
    await logout();

    if (networkError != null) {
      throw AuthException(
        'We signed you out, but couldn\'t reach the server to fully delete '
        'your account. Please try Delete Account again from the sign-in '
        'screen, or email mulgundsunil@gmail.com to confirm deletion.',
      );
    }
  }

  // -------------------------------------------------------------------------
  // Logout — the ONLY code path that clears the session
  // -------------------------------------------------------------------------

  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _user = null;
    _refreshTimer?.cancel();
    _refreshTimer = null;
    await _wipeStorage();
    notifyListeners();
  }

  // -------------------------------------------------------------------------
  // Silent refresh
  // -------------------------------------------------------------------------

  /// Rotates the access + refresh token pair using the stored refresh token.
  /// Returns true on success. On failure (refresh token is genuinely dead,
  /// 401 from /auth/refresh) the session is cleared. On a network error
  /// the existing tokens are kept and the caller can retry later.
  ///
  /// Concurrent callers share the same inflight future.
  Future<bool> _silentRefresh() {
    final existing = _inflightRefresh;
    if (existing != null) return existing;

    final future = _runRefresh();
    _inflightRefresh = future;
    future.whenComplete(() => _inflightRefresh = null);
    return future;
  }

  Future<bool> _runRefresh() async {
    final refresh = _refreshToken;
    if (refresh == null || refresh.isEmpty) return false;

    try {
      final res = await http
          .post(
            Uri.parse('$apiBase/api/academics/auth/refresh'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({'refreshToken': refresh}),
          )
          .timeout(const Duration(seconds: 20));

      if (res.statusCode == 401 || res.statusCode == 403) {
        // Refresh token is truly dead — clear and drop back to login.
        debugPrint('[AuthService] refresh rejected ${res.statusCode} — logging out');
        await logout();
        return false;
      }
      if (res.statusCode != 200) {
        // 500, 429, transient — keep tokens and try again later.
        debugPrint('[AuthService] refresh transient error ${res.statusCode}');
        return false;
      }

      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final newAccess = body['accessToken'] as String?;
      final newRefresh = body['refreshToken'] as String?;
      if (newAccess == null) return false;

      _accessToken = newAccess;
      if (newRefresh != null) _refreshToken = newRefresh;

      // Persist the rotated pair. We don't need to re-write the user blob,
      // but doing so keeps every storage backend in sync.
      final userJson = _user != null ? jsonEncode(_user!.toJson()) : '{}';
      await _persistSession(
        token: newAccess,
        refresh: newRefresh ?? _refreshToken,
        userJsonStr: userJson,
      );
      notifyListeners();
      debugPrint('[AuthService] silent refresh ok');
      return true;
    } catch (e) {
      debugPrint('[AuthService] refresh failed: $e');
      return false;
    }
  }

  void _armRefreshTimer() {
    _refreshTimer?.cancel();
    if (_refreshToken == null || _refreshToken!.isEmpty) return;
    _refreshTimer = Timer.periodic(_refreshInterval, (_) {
      unawaited(_silentRefresh());
    });
  }

  // -------------------------------------------------------------------------
  // Authorised HTTP helpers
  // -------------------------------------------------------------------------

  Map<String, String> get authHeaders => {
        'Content-Type': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      };

  /// Wraps an HTTP call with automatic 401 → refresh → retry. Callers that
  /// want silent rotation on expired tokens should use this instead of
  /// calling http directly. The [send] closure is invoked with the current
  /// authHeaders; if the response is 401 and the refresh succeeds, it's
  /// invoked a second time with the fresh headers.
  Future<http.Response> authorizedFetch(
    Future<http.Response> Function(Map<String, String> headers) send,
  ) async {
    final firstRes = await send(authHeaders);
    if (firstRes.statusCode != 401) return firstRes;

    final refreshed = await _silentRefresh();
    if (!refreshed) return firstRes;

    return send(authHeaders);
  }

  // -------------------------------------------------------------------------
  // Internal helpers
  // -------------------------------------------------------------------------

  Future<void> _handleAuthResponse(http.Response res) async {
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
    final refresh = body['refreshToken'] as String?;
    final userJson = body['user'] as Map<String, dynamic>?;
    if (token == null || userJson == null) {
      throw const AuthException('Server response missing token or user.');
    }

    _accessToken = token;
    _refreshToken = refresh;
    _user = AuthUser.fromJson(userJson);

    await _persistSession(
      token: token,
      refresh: refresh,
      userJsonStr: jsonEncode(userJson),
    );

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
