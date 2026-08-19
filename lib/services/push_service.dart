// =============================================================================
// lib/services/push_service.dart
//
// Firebase Cloud Messaging wiring for broadcast push ("all_users" topic).
//
// Platform support is deliberately narrow for now:
//   - Android: full push. Subscribes to the topic client-side.
//   - Web: push only once a VAPID key is set below (Firebase console →
//     Project Settings → Cloud Messaging → Web Push certificates). Until
//     then web init is a silent no-op. Web can't subscribe to topics
//     client-side, so the token is sent to the backend which subscribes
//     it server-side.
//   - iOS/macOS/desktop: skipped entirely — firebase_options.dart only has
//     android + web apps registered, and DefaultFirebaseOptions.currentPlatform
//     THROWS for unconfigured platforms. Re-run `flutterfire configure` with
//     ios once the Apple developer account is active, then widen _supported.
// =============================================================================

import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../firebase_options.dart';
import '../academics/academics_web_screen.dart';
import 'auth_service.dart';

/// Paste the Web Push certificate key pair here (Firebase console →
/// Project Settings → Cloud Messaging → Web configuration) to enable
/// push on pediaid.bridgr.co.in. Empty string = web push disabled.
const String _webVapidKey =
    'BHCfX5fYaYWNubWJaRcFInUBWSB4fquBYcfAsiDbLjqy7fy8jNyp5jbTW--e4ucrG8gEjeFI_xQvdeG9q06gAzg';

class PushService {
  PushService._();
  static final PushService instance = PushService._();

  /// Set from main.dart so foreground pushes can surface as a SnackBar on
  /// whatever screen is open, without each screen needing wiring.
  static GlobalKey<ScaffoldMessengerState>? messengerKey;

  /// The app's root navigator, so a notification tap can push a screen.
  static GlobalKey<NavigatorState>? navigatorKey;

  bool _initialized = false;

  /// The device's current FCM token, kept so it can be re-sent once the user
  /// signs in.
  String? _token;

  /// Re-registers this device against the account that just signed in.
  ///
  /// init() runs at startup, usually while signed out, so the token gets stored
  /// with no user attached and personal notifications have no destination. FCM
  /// only fires onTokenRefresh when the token itself changes — signing in is
  /// not such an event — so without this call the binding never happens for
  /// anyone who logs in after launch, which is nearly everyone.
  Future<void> onSignedIn() async {
    final t = _token;
    if (t != null) await _registerTokenWithBackend(t);
  }

  static bool get _supported =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  /// Fire-and-forget from main(). Never throws — push being unavailable
  /// must not affect the rest of the app.
  Future<void> init() async {
    if (_initialized || !_supported) return;
    // Without a VAPID key web push can't work at all — bail before
    // requestPermission() so visitors never see a pointless browser
    // notification-permission popup.
    //
    // Logged rather than returning quietly: an empty constant silently turning
    // off a whole feature is exactly the kind of thing that goes unnoticed for
    // months, and the only symptom is "push doesn't work on the website" with
    // nothing anywhere to explain why.
    if (kIsWeb && _webVapidKey.isEmpty) {
      debugPrint(
        '[push] Web push disabled: _webVapidKey is empty. Set it from Firebase '
        'console → Project Settings → Cloud Messaging → Web Push certificates.',
      );
      return;
    }
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;

      // iOS only hands out an FCM token once the APNS token is set. On a cold
      // first launch getToken() would otherwise return null, leaving the device
      // unregistered — no token row, no topic subscription, so nothing ever
      // reaches the notification centre (only the in-app bell, which is a DB
      // read). Wait briefly for the APNS token before asking for the FCM one.
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        var apns = await messaging.getAPNSToken();
        for (var i = 0; apns == null && i < 8; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 500));
          apns = await messaging.getAPNSToken();
        }
      }

      // ── Tap handlers FIRST ────────────────────────────────────────────
      // These must be registered before any network work. They used to sit
      // after an AWAITED POST to the backend, which runs on a plan that spins
      // down — so a cold start could spend 30-60 s in that await while
      // onMessageOpenedApp (a plain stream, no replay) dropped the tap event
      // entirely. The symptom was a notification tap opening the app on the
      // home screen instead of the linked trial.
      FirebaseMessaging.onMessageOpenedApp.listen(_openFromMessage);
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        // At cold start the navigator isn't mounted yet — wait for first frame.
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _openFromMessage(initialMessage),
        );
      }

      // Every platform needs its token registered, not just web.
      //
      // Android previously only subscribed to the broadcast topic here. Topics
      // deliver announcements to everyone, but a personal notification ("your
      // event was approved") is addressed to one user's tokens — so with no row
      // in acad_push_tokens the backend had nobody to send to and silently sent
      // nothing. The in-app bell still worked, because that reads a database
      // row, which is what made the gap look like a delivery problem rather
      // than a registration one.
      final token = await messaging.getToken(
        vapidKey: kIsWeb ? _webVapidKey : null,
      );
      if (token != null) {
        _token = token;
        // Deliberately NOT awaited: nothing below depends on it, and the
        // backend can be cold. Blocking here delayed everything after it.
        // ignore: unawaited_futures
        _registerTokenWithBackend(token);
      }
      messaging.onTokenRefresh.listen((t) {
        _token = t;
        _registerTokenWithBackend(t);
      });

      if (!kIsWeb) {
        // Still subscribe to the topic — that is the broadcast channel, and it
        // is separate from per-user delivery rather than a substitute for it.
        await messaging.subscribeToTopic('all_users');
      }

      // In the foreground the OS doesn't show a system notification —
      // surface the message in-app instead.
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final n = message.notification;
        if (n == null) return;
        messengerKey?.currentState?.showSnackBar(
          SnackBar(
            content: Text(
              n.body == null || n.body!.isEmpty
                  ? n.title ?? ''
                  : '${n.title} — ${n.body}',
            ),
            duration: const Duration(seconds: 6),
          ),
        );
      });

      _initialized = true;
    } catch (e) {
      debugPrint('[push] init failed (non-fatal): $e');
    }
  }

  /// Open the Academics WebView at the notification's deep-link path.
  ///
  /// [attempt] exists because the navigator may not be mounted the instant a
  /// cold start delivers the tap. Returning silently there lost the deep link
  /// and left the user on the home screen, so this retries briefly instead.
  static void _openFromMessage(RemoteMessage message, {int attempt = 0}) {
    final link = message.data['linkPath'];
    if (link == null || link.isEmpty) return;
    final nav = navigatorKey?.currentState;
    if (nav == null) {
      if (attempt >= 10) return; // ~5 s, then give up rather than loop
      Future<void>.delayed(const Duration(milliseconds: 500), () {
        _openFromMessage(message, attempt: attempt + 1);
      });
      return;
    }
    // linkPath is an absolute web path (e.g. /academics/trials/x/y), but
    // AcademicsWebScreen's base URL already ends in /academics — strip that
    // prefix so the URL is not doubled to /academics/academics.
    var rel = link.startsWith('/academics')
        ? link.substring('/academics'.length)
        : link;
    if (rel.isEmpty) rel = '/';
    nav.push(MaterialPageRoute(builder: (_) => AcademicsWebScreen(path: rel)));
  }

  Future<void> _registerTokenWithBackend(String token) async {
    try {
      // Send the session token when there is one. Without it the backend can
      // only add this device to the broadcast topic; with it, the device is
      // bound to the account and can receive personal notifications
      // ("your submission was approved"). Signed-out registration still works
      // and still gets announcements — that is why the header is optional.
      final auth = AuthService.instance.accessToken;
      await http
          .post(
            Uri.parse('${AuthService.apiBase}/api/push/register'),
            headers: {
              'Content-Type': 'application/json',
              if (auth != null) 'Authorization': 'Bearer $auth',
            },
            body: jsonEncode({
              'token': token,
              'platform': kIsWeb ? 'web' : defaultTargetPlatform.name,
            }),
          )
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('[push] token registration failed (non-fatal): $e');
    }
  }
}
