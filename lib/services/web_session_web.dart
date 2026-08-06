// =============================================================================
// lib/services/web_session_web.dart
//
// One sign-in across the app and Academics, on the web.
//
// Both are served from pediaid.bridgr.co.in now, so they share one
// localStorage — but they are still two applications that stored their
// sessions under different keys, so signing into one left the other signed
// out. Users hit two sign-in screens for one product.
//
// The tokens are interchangeable: both come from the same backend and mean the
// same account. So the app mirrors its session into the keys Academics reads,
// and reads them back when it has none of its own. Either surface can be
// signed into first; the other picks it up.
//
// Written in plain localStorage on purpose. Academics keeps its session there
// already, so this adds no exposure that the origin did not have — and an
// encrypted copy would be unreadable to the very app it exists for.
// =============================================================================

// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

const _kAccess = 'acad_access_token';
const _kRefresh = 'acad_refresh_token';
const _kUser = 'acad_user';

void writeSharedSession(String accessToken, String? refreshToken, String userJson) {
  try {
    html.window.localStorage[_kAccess] = accessToken;
    if (refreshToken != null) html.window.localStorage[_kRefresh] = refreshToken;
    html.window.localStorage[_kUser] = userJson;
  } catch (_) {
    // Storage disabled or full. Sharing is a convenience — failing here must
    // never break sign-in itself.
  }
}

void clearSharedSession() {
  try {
    html.window.localStorage.remove(_kAccess);
    html.window.localStorage.remove(_kRefresh);
    html.window.localStorage.remove(_kUser);
  } catch (_) {}
}

Map<String, String?>? readSharedSession() {
  try {
    final access = html.window.localStorage[_kAccess];
    if (access == null || access.isEmpty) return null;
    return {
      'access': access,
      'refresh': html.window.localStorage[_kRefresh],
      'user': html.window.localStorage[_kUser],
    };
  } catch (_) {
    return null;
  }
}
