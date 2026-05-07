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

/// Convert a raw exception into a clean, user-facing message.
///
/// Strategy:
///   1. If it's a known network / IO / format failure, hand-translate.
///   2. If it's a known auth-token failure, hand-translate.
///   3. Otherwise strip "Exception:" / "[…]" prefixes and trim the message.
///   4. Fall back to a generic "Something went wrong" so we never leak a
///      stack trace to the user.
String friendlyError(Object? error) {
  if (error == null) return 'Something went wrong. Please try again.';

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
