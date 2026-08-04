// =============================================================================
// lib/services/firebase_auth_service.dart
//
// Firebase Auth + Firestore user-document service, following the Wardly
// reference (AUTH_REFERENCE_FROM_WARDLY.md).
//
// Architecture (three layers):
//   FirebaseAuthService  ← all Firebase calls, Firestore user doc CRUD
//       ↓
//   AuthProvider         ← ChangeNotifier, currentUser, isLoading, error
//       ↓
//   UI                   ← login_screen, account_screen, etc.
//
// Design:
//   - Every sign-in path: authenticate with Firebase → check/create users/{uid}
//     Firestore doc → read it back → return typed AppUser.
//   - The UI never touches FirebaseUser directly; only AppUser from Firestore.
//   - Apple Sign-In uses the mandatory nonce dance (see §7 of the reference).
//   - deleteAccount() handles re-auth for all three providers, fixing the
//     Wardly bug where Apple users fell into the email/password branch.
//
// Platform notes:
//   - Apple Sign-In: iOS only (guarded by kIsWeb + Platform.isIOS checks).
//   - Google sign-out: skipped on desktop (google_sign_in has no desktop support).
//   - firebase_options.dart currently only has Android + web; iOS must be added
//     with `flutterfire configure` once the Apple developer account is set up.
// =============================================================================

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../firebase_options.dart';
import '../models/app_user.dart';

bool get _isDesktop =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux);

class FirebaseAuthService {
  FirebaseAuth? _authOverride;
  FirebaseFirestore? _firestoreOverride;

  FirebaseAuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _authOverride = auth,
        _firestoreOverride = firestore;

  // Lazy on purpose: touching FirebaseAuth.instance / FirebaseFirestore.instance
  // constructs the JS interop bindings, which can throw if this runs before
  // Firebase.initializeApp() has actually completed. AuthProvider constructs
  // FirebaseAuthService() synchronously at app boot (main.dart), before any
  // async gap — eager access here previously threw an uncaught exception
  // straight out of main(), aborting boot before runApp() ever ran (blank
  // page, no console output). Deferring to first real use means any failure
  // surfaces inside a method call, which every caller already wraps in
  // try/catch.
  FirebaseAuth get _auth => _authOverride ??= FirebaseAuth.instance;
  FirebaseFirestore get _firestore =>
      _firestoreOverride ??= FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  User? get firebaseUser => _auth.currentUser;

  Set<String> get providerIds =>
      _auth.currentUser?.providerData.map((p) => p.providerId).toSet() ?? {};

  // ── Read ──────────────────────────────────────────────────────────────────

  Future<AppUser?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _users.doc(user.uid).get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }

  // ── Email / password ──────────────────────────────────────────────────────

  Future<AppUser?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return _fetchUser(cred.user?.uid);
  }

  Future<AppUser?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = cred.user;
    if (user == null) return null;

    await user.updateDisplayName(name.trim());

    await _users.doc(user.uid).set({
      'name': name.trim(),
      'email': email.trim(),
      'role': 'doctor',
      'avatarUrl': null,
      'createdAt': Timestamp.fromDate(DateTime.now()),
    });

    return _fetchUser(user.uid);
  }

  // ── Google ─────────────────────────────────────────────────────────────────

  Future<AppUser?> signInWithGoogle() async {
    UserCredential cred;

    if (kIsWeb) {
      cred = await _auth.signInWithPopup(GoogleAuthProvider());
    } else {
      // kIsWeb guard is required before DefaultFirebaseOptions.currentPlatform
      // on platforms where the options are not yet configured (throws).
      String? iosClientId;
      try {
        iosClientId = DefaultFirebaseOptions.currentPlatform.iosClientId;
      } catch (_) {}

      final googleUser = await GoogleSignIn(clientId: iosClientId).signIn();
      if (googleUser == null) return null; // user cancelled

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      cred = await _auth.signInWithCredential(credential);
    }

    final user = cred.user;
    if (user == null) return null;

    final doc = await _users.doc(user.uid).get();
    if (!doc.exists) {
      final displayName =
          user.displayName ?? (user.email ?? 'User').split('@').first;
      await _users.doc(user.uid).set({
        'name': displayName,
        'email': user.email ?? '',
        'role': 'doctor',
        'avatarUrl': user.photoURL,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });
    }
    return _fetchUser(user.uid); // deliberate re-read
  }

  // ── Apple (iOS only) ───────────────────────────────────────────────────────

  // kIsWeb must be checked before Platform.isIOS — Platform throws on web.
  Future<AppUser?> signInWithApple() async {
    if (kIsWeb) throw UnsupportedError('Apple Sign-In is not available on web.');
    if (!Platform.isIOS && !Platform.isMacOS) {
      throw UnsupportedError('Apple Sign-In requires iOS or macOS.');
    }

    final rawNonce = _generateNonce();
    final hashedNonce = _sha256ofString(rawNonce);

    // Apple sends name + email only on the VERY FIRST grant, ever.
    // Capture givenName / familyName here — they will be null on all future
    // sign-ins unless the user revokes access under Settings → Apple ID.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce, // HASHED goes to Apple
    );

    final oauthCred = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce, // RAW goes to Firebase
    );
    final cred = await _auth.signInWithCredential(oauthCred);
    final user = cred.user;
    if (user == null) return null;

    final doc = await _users.doc(user.uid).get();
    if (!doc.exists) {
      final composed = [
        appleCredential.givenName ?? '',
        appleCredential.familyName ?? '',
      ].where((s) => s.isNotEmpty).join(' ').trim();
      final displayName = composed.isNotEmpty
          ? composed
          : (user.displayName ??
              (user.email ?? 'Apple user').split('@').first);
      await _users.doc(user.uid).set({
        'name': displayName,
        'email': user.email ?? appleCredential.email ?? '',
        'role': 'doctor',
        'avatarUrl': user.photoURL,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });
    }
    return _fetchUser(user.uid);
  }

  // ── Sign out ───────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    if (!_isDesktop) {
      try {
        String? iosClientId;
        try {
          iosClientId = DefaultFirebaseOptions.currentPlatform.iosClientId;
        } catch (_) {}
        await GoogleSignIn(clientId: iosClientId).signOut();
      } catch (_) {}
    }
    await _auth.signOut();
  }

  // ── Password reset ─────────────────────────────────────────────────────────

  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // ── Profile update ─────────────────────────────────────────────────────────

  Future<void> updateProfile({
    String? name,
    String? avatarUrl,
    String? avatarEmoji,
    String? specialty,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (avatarUrl != null) updates['avatarUrl'] = avatarUrl;
    if (avatarEmoji != null) updates['avatarEmoji'] = avatarEmoji;
    if (specialty != null) updates['specialty'] = specialty;
    if (updates.isEmpty) return;

    await _users.doc(user.uid).update(updates);
    if (name != null) await user.updateDisplayName(name);
  }

  // ── Delete account ─────────────────────────────────────────────────────────
  // App Store / Play Store requirement if sign-up is offered.
  // Firebase requires recent re-authentication before deletion.
  // Handles all three providers — fixing the Wardly bug that missed Apple.

  Future<void> deleteAccount({String? password}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final providers = providerIds;

    // Re-authentication must mirror how the user actually signs in, per
    // platform. It previously did not: both the Google and Apple branches were
    // gated on `!kIsWeb`, so on web (and, for Google, on desktop) they were
    // skipped entirely and execution fell through to the password branch —
    // which threw "Password is required to delete your account" at people who
    // have never had a password. On those platforms a social-login user could
    // not delete their account at all, which is a store-policy requirement.
    //
    // The rule now: if you can sign in that way, you can re-authenticate that
    // way. Web uses the popup APIs (matching signInWithGoogle above), every
    // other platform uses the native SDK.
    if (providers.contains('google.com')) {
      if (kIsWeb) {
        await user.reauthenticateWithPopup(GoogleAuthProvider());
      } else {
        String? iosClientId;
        try {
          iosClientId = DefaultFirebaseOptions.currentPlatform.iosClientId;
        } catch (_) {}
        final googleUser = await GoogleSignIn(clientId: iosClientId).signIn();
        if (googleUser == null) throw Exception('Google re-auth cancelled.');
        final googleAuth = await googleUser.authentication;
        await user.reauthenticateWithCredential(
          GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ),
        );
      }
    } else if (providers.contains('apple.com')) {
      if (kIsWeb || _isDesktop) {
        // Native Sign in with Apple is unavailable here, but Firebase's popup
        // flow is not — so an Apple account created on iOS can still be
        // deleted from the web build.
        await user.reauthenticateWithPopup(OAuthProvider('apple.com'));
      } else {
        final rawNonce = _generateNonce();
        final hashedNonce = _sha256ofString(rawNonce);
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [],
          nonce: hashedNonce,
        );
        await user.reauthenticateWithCredential(
          OAuthProvider('apple.com').credential(
            idToken: appleCredential.identityToken,
            rawNonce: rawNonce,
          ),
        );
      }
    } else if (providers.contains('password')) {
      if (password == null || password.isEmpty) {
        throw Exception('Password is required to delete your account.');
      }
      final email = user.email;
      if (email == null) throw Exception('Unable to determine account email.');
      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: email, password: password),
      );
    } else {
      // No provider we can re-authenticate with. Asking for a password would
      // be misleading, since there isn't one to give.
      throw Exception(
        'Could not verify your identity for deletion. Please sign out, sign '
        'back in, and try again — or email help@bridgr.co.in.',
      );
    }

    await _users.doc(user.uid).delete();
    await user.delete();
  }

  // ── Internal helpers ───────────────────────────────────────────────────────

  Future<AppUser?> _fetchUser(String? uid) async {
    if (uid == null) return null;
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256ofString(String input) =>
      sha256.convert(utf8.encode(input)).toString();
}
