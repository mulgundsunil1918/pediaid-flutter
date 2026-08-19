// =============================================================================
// lib/main_login_test.dart
//
// MINIMAL login-only diagnostic build for Sign in with Apple / Google.
//
// Same bundle id (app.pediaid.pediaid), same GoogleService-Info.plist, same
// entitlements and provisioning as the full app — so the Firebase provider
// config is exercised IDENTICALLY — but with cloud_firestore and every heavy
// pod removed (see the stripped pubspec), so it builds in minutes and does not
// OOM. It shows the EXACT Firebase error on screen instead of a friendly line.
//
// Build:  flutter build ios --simulator --debug -t lib/main_login_test.dart
//
// This file is NOT shipped. The store build always uses lib/main.dart.
// =============================================================================

import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// iOS Firebase options — copied verbatim from lib/firebase_options.dart so this
// mini-app talks to the exact same Firebase project (pediaid-app) as the real
// app. Native iOS also reads GoogleService-Info.plist, so both agree.
const _iosOptions = FirebaseOptions(
  apiKey: 'AIzaSyCu55GyWl4ea6Yy3-xmBQzt-HXC4zgs8Pk',
  appId: '1:11076606207:ios:dc57c66e8eeb718bf2d4ca',
  messagingSenderId: '11076606207',
  projectId: 'pediaid-app',
  storageBucket: 'pediaid-app.firebasestorage.app',
  iosClientId:
      '11076606207-3grv5stb6t8s0db6cihn8ls731tjj0if.apps.googleusercontent.com',
  iosBundleId: 'app.pediaid.pediaid',
);

const _iosClientId =
    '11076606207-3grv5stb6t8s0db6cihn8ls731tjj0if.apps.googleusercontent.com';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? initError;
  try {
    await Firebase.initializeApp(options: _iosOptions);
  } catch (e) {
    initError = 'Firebase.initializeApp failed:\n$e';
  }
  runApp(LoginTestApp(initError: initError));
}

class LoginTestApp extends StatelessWidget {
  const LoginTestApp({super.key, this.initError});
  final String? initError;
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PediAid Login Test',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF1565C0),
        ),
        home: LoginTestScreen(initError: initError),
      );
}

class LoginTestScreen extends StatefulWidget {
  const LoginTestScreen({super.key, this.initError});
  final String? initError;
  @override
  State<LoginTestScreen> createState() => _LoginTestScreenState();
}

class _LoginTestScreenState extends State<LoginTestScreen> {
  String _status = '';
  bool _ok = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    if (widget.initError != null) {
      _status = widget.initError!;
    } else {
      final u = FirebaseAuth.instance.currentUser;
      if (u != null) {
        _ok = true;
        _status = 'Already signed in\nuid: ${u.uid}\n${u.email ?? ""}';
      }
    }
  }

  void _set(String s, {bool ok = false}) {
    if (mounted) {
      setState(() {
        _status = s;
        _ok = ok;
        _busy = false;
      });
    }
  }

  // The whole point of this build: show the RAW Firebase error, not a friendly
  // one. For a FirebaseAuthException that means [code] + the server message,
  // which names the exact fault.
  String _raw(Object e) {
    if (e is FirebaseAuthException) {
      final m = (e.message ?? '').trim();
      return 'FirebaseAuthException\n[${e.code}]${m.isEmpty ? '' : '\n$m'}';
    }
    return '${e.runtimeType}\n$e';
  }

  String _nonce([int len = 32]) {
    const cs =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
    final r = Random.secure();
    return List.generate(len, (_) => cs[r.nextInt(cs.length)]).join();
  }

  String _sha256(String s) => sha256.convert(utf8.encode(s)).toString();

  Future<void> _google() async {
    setState(() {
      _busy = true;
      _status = 'Google: starting…';
    });
    try {
      final gu = await GoogleSignIn(clientId: _iosClientId).signIn();
      if (gu == null) {
        _set('Google: cancelled');
        return;
      }
      final ga = await gu.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: ga.accessToken,
        idToken: ga.idToken,
      );
      final r = await FirebaseAuth.instance.signInWithCredential(cred);
      _set('GOOGLE OK ✅\nuid: ${r.user?.uid}\n${r.user?.email ?? ""}', ok: true);
    } catch (e) {
      _set('GOOGLE FAILED ❌\n${_raw(e)}');
    }
  }

  // Decode a JWT payload (middle segment) so we can SEE the token's claims —
  // aud + nonce are exactly what decides whether Firebase accepts it.
  Map<String, dynamic> _decodeJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return {'_err': '${parts.length} parts, not a JWT'};
      var p = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      while (p.length % 4 != 0) {
        p += '=';
      }
      return json.decode(utf8.decode(base64.decode(p))) as Map<String, dynamic>;
    } catch (e) {
      return {'_err': 'decode failed: $e'};
    }
  }

  Future<void> _apple() async {
    setState(() {
      _busy = true;
      _status = 'Apple: starting…';
    });
    if (!Platform.isIOS) {
      _set('Apple: iOS only');
      return;
    }
    final raw = _nonce();
    final hashed = _sha256(raw); // HASHED goes to Apple

    // ── Step 1: Apple's own authorization (BEFORE Firebase) ──────────────────
    AuthorizationCredentialAppleID ac;
    try {
      ac = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashed,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      // A genuine cancel is NOT a failure — report it plainly, no red alarm.
      if (e.code == AuthorizationErrorCode.canceled) {
        _set('Apple sheet CANCELLED (error 1001) — this is BEFORE Firebase.\n\n'
            'It was dismissed, OR it never presented.\n\n'
            '❓ Did the black Apple sheet actually slide up (Face ID / '
            '"Continue")? That answer tells us which.');
      } else {
        _set('APPLE SDK error (before Firebase):\n[${e.code}] ${e.message}');
      }
      return;
    } catch (e) {
      _set('Apple step-1 error (before Firebase):\n${_raw(e)}');
      return;
    }

    // ── The token arrived. Decode it so the fault is visible, not guessed ────
    final tok = ac.identityToken;
    if (tok == null || tok.isEmpty) {
      _set('Apple returned NO identityToken (null/empty).\n'
          'authorizationCode present: ${ac.authorizationCode.isNotEmpty}');
      return;
    }
    final claims = _decodeJwt(tok);
    final tokenNonce = claims['nonce'];
    final diag = StringBuffer()
      ..writeln('✅ Apple returned a token (${tok.length} chars)')
      ..writeln('authCode present: ${ac.authorizationCode.isNotEmpty}')
      ..writeln('name: ${ac.givenName ?? "-"} ${ac.familyName ?? ""}'.trim())
      ..writeln('')
      ..writeln('── TOKEN CLAIMS ──')
      ..writeln('aud : ${claims['aud']}')
      ..writeln('iss : ${claims['iss']}')
      ..writeln('sub : ${claims['sub']}')
      ..writeln('email: ${claims['email'] ?? ac.email ?? "-"}')
      ..writeln('exp : ${claims['exp']}   iat: ${claims['iat']}')
      ..writeln(claims.containsKey('_err') ? 'decode: ${claims['_err']}' : '')
      ..writeln('── NONCE ──')
      ..writeln('token nonce : $tokenNonce')
      ..writeln('sha256(raw) : $hashed')
      ..writeln('MATCH: ${tokenNonce == hashed}')
      ..writeln('')
      ..writeln('(expected aud = app.pediaid.pediaid)')
      ..writeln('── sending to Firebase… ──');
    setState(() => _status = diag.toString());

    // ── THE FIX (identical to the real app): backend custom-token path ───────
    // Skip the broken signInWithCredential entirely. Hand the Apple token to
    // the backend, which runs the working signInWithIdp REST call and mints a
    // Firebase custom token; sign in with that — a clean SDK path.
    setState(() => _status = '$diag\n→ POST /apple-native …');
    try {
      final resp = await http.post(
        Uri.parse(
          'https://pediaid-backend.onrender.com/api/academics/auth/apple-native',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'identityToken': tok, 'rawNonce': raw}),
      );
      if (resp.statusCode != 200) {
        _set('$diag\n\n❌ backend /apple-native [${resp.statusCode}]:\n${resp.body}');
        return;
      }
      final customToken =
          (json.decode(resp.body) as Map<String, dynamic>)['customToken'] as String;
      setState(() => _status =
          '$diag\n→ got custom token (${customToken.length} chars)\n→ signInWithCustomToken …');
      final r = await FirebaseAuth.instance.signInWithCustomToken(customToken);
      _set(
        '$diag\n\n✅ APPLE OK — via custom token\n'
        'uid: ${r.user?.uid}\n${r.user?.email ?? ac.email ?? ""}',
        ok: true,
      );
    } catch (e) {
      _set('$diag\n\n❌ custom-token sign-in failed:\n${_raw(e)}');
    }
  }

  Future<void> _signOut() async {
    try {
      await GoogleSignIn(clientId: _iosClientId).signOut();
    } catch (_) {}
    await FirebaseAuth.instance.signOut();
    _set('Signed out');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PediAid — Login Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Minimal build — Firebase Auth only (no Firestore).\n'
              'Same bundle id & Firebase project as the real app.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: Colors.black54),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _busy ? null : _google,
              icon: const Icon(Icons.g_mobiledata, size: 30),
              label: const Text('Sign in with Google'),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _busy ? null : _apple,
              style: FilledButton.styleFrom(backgroundColor: Colors.black),
              icon: const Icon(Icons.apple),
              label: const Text('Sign in with Apple'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _busy ? null : _signOut,
              child: const Text('Sign out'),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _ok ? Colors.green.shade50 : Colors.red.shade50,
                border: Border.all(color: _ok ? Colors.green : Colors.red),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                _status.isEmpty ? 'Tap a button to test sign-in.' : _status,
                style: TextStyle(
                  fontFamily: 'Menlo',
                  fontSize: 13,
                  height: 1.4,
                  color: _ok ? Colors.green.shade900 : Colors.red.shade900,
                ),
              ),
            ),
            if (_busy)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
