// =============================================================================
// lib/services/web_session_stub.dart
//
// Non-web platforms. Native builds host Academics in a WebView, which shares
// no storage with the app, so there is nothing to mirror — the one-time code
// handoff covers that direction instead.
// =============================================================================

/// Mirrors the app's session where Academics can read it. No-op off web.
void writeSharedSession(String accessToken, String? refreshToken, String userJson) {}

/// Clears the mirrored session. No-op off web.
void clearSharedSession() {}

/// Reads a session Academics may have written. Always null off web.
Map<String, String?>? readSharedSession() => null;
