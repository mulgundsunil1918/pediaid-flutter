// =============================================================================
// utils/friendly_error.dart
// Translates raw exceptions (HTTP, Dart core, plugin) into one-line, plain-
// English messages safe to put in a SnackBar or alert dialog.
//
// Usage:
//   try { … }
//   catch (e, st) {
//     debugPrint('raw: $e\n$st');                       // log truthfully
//     final msg = friendlyError(e);                     // show kindly
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg)),
//     );
//   }
//
// The raw exception is intentionally NOT discarded — log it locally before
// transforming, so debugging stays possible.
// =============================================================================

import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;

/// Convert a raw exception into a clean, user-facing message.
///
/// Strategy:
///   1. Firebase Auth exceptions matched by code (fastest, most specific).
///   2. Known network / IO / format failures hand-translated.
///   3. Known JWT auth-token shapes from the legacy backend.
///   4. Generic cleanup of Exception: prefixes, with fallback.
String friendlyError(Object? error) {
  if (error == null) return 'Something went wrong. Please try again.';

  // ── Firebase Auth ────────────────────────────────────────────────────────
  // Match by code first so we never leak "firebase_auth/" strings to the UI.
  if (error is FirebaseAuthException) {
    switch (error.code) {
      // Only the password-specific codes may blame the password.
      case 'invalid-login-credentials':
      case 'wrong-password':
      case 'user-not-found':
        return 'Email or password is incorrect. Please check and try again.';

      // invalid-credential is NOT password-specific — Firebase also raises it
      // when a Google or Apple credential is refused, which happens when that
      // provider is not enabled in Firebase Authentication. Reporting it as a
      // wrong password sent people to re-check a password they never typed,
      // and hid a configuration fault behind a user error.
      case 'invalid-credential':
        return 'That sign-in could not be completed. If you used Google or '
            'Apple, this sign-in method may not be enabled yet — please '
            'contact support.';
      case 'account-exists-with-different-credential':
        return 'You already have an account using a different sign-in method. '
            'Try signing in that way instead.';
      case 'email-already-in-use':
        return 'That email is already registered. Try signing in instead.';
      case 'weak-password':
        return 'Password too weak — please choose at least 8 characters.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'requires-recent-login':
        return 'Please sign in again to perform this action.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled. Please contact support.';
      case 'permission-denied':
        return "You don't have permission to do that.";
      case 'unavailable':
        return 'Service temporarily unavailable. Please try again shortly.';
      default:
        // macOS Keychain bug: SecureStorage throws -34018 on first launch.
        if (error.code.contains('34018')) {
          return 'iOS Keychain error. Try restarting the app.';
        }
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }

  final raw = error.toString();

  // ── Network / connectivity ───────────────────────────────────────────────
  if (error is SocketException) {
    return 'No internet connection. Check your network and try again.';
  }
  if (error is TimeoutException) {
    return "That took too long. Please try again — the server may be busy.";
  }
  if (error is HttpException) {
    final m = error.message.toLowerCase();
    if (m.contains('connection closed')) {
      return 'Connection dropped. Please try again.';
    }
    return 'Network error. Please try again.';
  }
  if (error is HandshakeException || error is TlsException) {
    return 'Secure connection failed. Check your device date/time and try again.';
  }

  // ── Format / parsing ─────────────────────────────────────────────────────
  if (error is FormatException) {
    return "We couldn't read the response. Please try again in a moment.";
  }

  // ── Auth-token shapes from our Render backend ────────────────────────────
  // Backend returns 401 with { "error": "token_expired" | "invalid_token" }
  // or { "message": "..." }. Pattern-match the common shapes.
  final lower = raw.toLowerCase();
  if (lower.contains('token_expired') || lower.contains('jwt expired')) {
    return 'Your session has expired. Please sign in again.';
  }
  if (lower.contains('invalid_token') || lower.contains('invalid jwt')) {
    return 'Your session is no longer valid. Please sign in again.';
  }
  if (lower.contains('unauthorized') || lower.contains('401')) {
    return 'You need to sign in to continue.';
  }
  if (lower.contains('forbidden') || lower.contains('403')) {
    return "You don't have permission to do that.";
  }
  if (lower.contains('not found') || lower.contains('404')) {
    return "We couldn't find that. It may have been deleted.";
  }
  if (lower.contains('rate limit') || lower.contains('429')) {
    return 'Too many requests. Please wait a moment and try again.';
  }
  if (lower.contains('5') && (lower.contains('500') || lower.contains('502') ||
      lower.contains('503') || lower.contains('504'))) {
    return 'Our server is having trouble right now. Please try again shortly.';
  }
  if (lower.contains('email already')) {
    return 'An account with this email already exists. Try signing in instead.';
  }
  if (lower.contains('weak password') || lower.contains('password is too weak')) {
    return 'Please choose a stronger password (at least 8 characters).';
  }
  if (lower.contains('wrong password') || lower.contains('invalid credentials')) {
    return "That email and password don't match. Please try again.";
  }

  // ── Generic clean-up ─────────────────────────────────────────────────────
  // Strip 'Exception:' / 'FormatException:' / etc. prefix, '[code/...]' tags,
  // anything that looks like a stack trace fragment.
  var cleaned = raw
      .replaceFirst(RegExp(r'^[A-Za-z]+Exception(:\s*)?'), '')
      .replaceAll(RegExp(r'\[[a-z0-9_\-/]+\]'), '')
      .replaceAll(RegExp(r'\(at .+:\d+(:\d+)?\)'), '')
      .trim();
  if (cleaned.isEmpty) {
    return 'Something went wrong. Please try again.';
  }
  // First sentence only, capitalised, with terminal period.
  final firstSentence = cleaned.split(RegExp(r'(?<=[.!?])\s+')).first.trim();
  final out = firstSentence[0].toUpperCase() + firstSentence.substring(1);
  return out.endsWith('.') || out.endsWith('!') || out.endsWith('?')
      ? out
      : '$out.';
}
