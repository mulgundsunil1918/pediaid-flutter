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
import 'package:shared_preferences/shared_preferences.dart';
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

  /// Ticks whenever a push arrives while the app is open. The notification
  /// bell listens to this instead of polling: an incoming message is the only
  /// event that can change the unread count, so refreshing on it is both
  /// cheaper and faster than a timer.
  static final ValueNotifier<int> messageReceived = ValueNotifier<int>(0);

  /// True when init() stopped short because permission had not been granted.
  /// requestPermissionAndRegister() picks up from there. Exposed so a
  /// settings screen can show "notifications are off" without re-querying
  /// the OS.
  bool _pendingRegistration = false;
  bool get awaitingPermission => _pendingRegistration;

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
  /// Forced past the unchanged-registration check below: signing in is rare,
  /// and if `currentUser` is not yet populated when this runs the fingerprint
  /// would match the signed-out one and skip the very call that binds the
  /// device to the account. One redundant write beats a silent delivery gap.
  Future<void> onSignedIn() async {
    final t = _token;
    if (t != null) await _registerTokenWithBackend(t, force: true);
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

      // Do NOT prompt here. This runs during app start, and on iOS Apple
      // allows exactly one system dialog: spending it before the user has
      // seen a screen is how a "no" becomes permanent, leaving the device
      // with no token and no subscription while every server-side check
      // still looks healthy. PushPermissionPrimer asks on second launch,
      // behind our own explainer, and calls
      // requestPermissionAndRegister() only if the user opts in.
      //
      // Already-granted installs (and Android below 13, where the
      // permission is granted at install) fall straight through and
      // register as before.
      final current = await messaging.getNotificationSettings();
      if (current.authorizationStatus != AuthorizationStatus.authorized &&
          current.authorizationStatus != AuthorizationStatus.provisional) {
        _pendingRegistration = true;
        return;
      }

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
        // Tell the bell to refresh even for a data-only message.
        messageReceived.value++;
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
    messageReceived.value++;
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

  /// Called by [PushPermissionPrimer] once the user has opted in.
  ///
  /// Shows the real OS dialog and, if granted, completes the registration
  /// init() deferred: APNs token wait, FCM token, backend registration and
  /// the broadcast topic subscription.
  Future<bool> requestPermissionAndRegister() async {
    if (!_supported) return false;
    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission();
      final ok =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
      if (!ok) return false;

      _pendingRegistration = false;
      // init() has already run its non-permission setup, so re-running it
      // now completes the parts that were skipped.
      _initialized = false;
      await init();
      return true;
    } catch (e) {
      debugPrint('[push] requestPermissionAndRegister failed: $e');
      return false;
    }
  }

  /// SharedPreferences keys recording the last registration that the backend
  /// actually accepted.
  static const _kLastRegKey = 'push_last_registration';
  static const _kLastRegAtKey = 'push_last_registration_at';

  /// How long a registration is trusted before being refreshed anyway.
  ///
  /// Nothing server-side reads `updated_at` today and dead tokens are pruned
  /// from FCM's own send response, so this is not required for correctness —
  /// it is insurance. If a token row ever disappears server-side without the
  /// token itself changing, the device re-registers within a week instead of
  /// silently losing push forever, which is a failure mode this app has had
  /// before.
  static const Duration _kReRegisterAfter = Duration(days: 7);

  /// Whether a registration POST is worth making.
  ///
  /// Pure and public so the rule can be tested directly — the real path is
  /// wrapped in Firebase, HTTP and SharedPreferences, none of which belong in
  /// a test of "should we write this row again".
  ///
  /// Every uncertain case answers TRUE. Registering unnecessarily costs one
  /// row write; failing to register costs a user their notifications silently,
  /// and that asymmetry decides every branch here.
  @visibleForTesting
  static bool shouldRegister({
    required String fingerprint,
    required String? lastFingerprint,
    required int? lastAtMillis,
    required int nowMillis,
    bool force = false,
  }) {
    if (force) return true;
    // Never registered, or the record was lost.
    if (lastFingerprint == null || lastAtMillis == null) return true;
    // Token changed, or it is now bound to a different account.
    if (lastFingerprint != fingerprint) return true;
    // A clock moved backwards gives a negative age; treat that as unknown
    // rather than as "recent", which would skip indefinitely.
    final age = nowMillis - lastAtMillis;
    if (age < 0) return true;
    return age >= _kReRegisterAfter.inMilliseconds;
  }

  /// POSTs the token to the backend, unless an identical registration is
  /// already on record.
  ///
  /// WHY THE CHECK EXISTS
  /// --------------------
  /// init() runs on every launch and used to call this unconditionally. The
  /// backend's handler is an upsert, so every launch by every signed-in user
  /// wrote a row to Postgres. Neon bills compute-hours and suspends after five
  /// minutes idle; a continuous trickle of WRITES is the most effective way to
  /// ensure that never happens, because each one has to be flushed to the
  /// pageserver. The Neon console showed inserts and updates moving in lockstep
  /// around the clock with the CPU essentially at zero — work that changed
  /// nothing, since the row being written was already identical.
  ///
  /// The fingerprint is token + bound user, because those are exactly the two
  /// things the backend stores. If either differs the row is genuinely stale
  /// and the write is real work.
  Future<void> _registerTokenWithBackend(
    String token, {
    bool force = false,
  }) async {
    final uid = AuthService.instance.currentUser?.id ?? '';
    final fingerprint = '$token|$uid';

    SharedPreferences? prefs;
    try {
      prefs = await SharedPreferences.getInstance();
      if (!shouldRegister(
        fingerprint: fingerprint,
        lastFingerprint: prefs.getString(_kLastRegKey),
        lastAtMillis: prefs.getInt(_kLastRegAtKey),
        nowMillis: DateTime.now().millisecondsSinceEpoch,
        force: force,
      )) {
        return;
      }
    } catch (e) {
      // Preferences being unavailable must never cost a registration — fall
      // through and register as before.
      debugPrint('[push] registration cache unavailable: $e');
    }

    try {
      // Send the session token when there is one. Without it the backend can
      // only add this device to the broadcast topic; with it, the device is
      // bound to the account and can receive personal notifications
      // ("your submission was approved"). Signed-out registration still works
      // and still gets announcements — that is why the header is optional.
      final auth = AuthService.instance.accessToken;
      final res = await http
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

      // Recorded only on success. A failed POST must be retried next launch —
      // caching a failure as though it were a registration would reproduce the
      // silent no-push bug this whole path exists to avoid.
      if (res.statusCode >= 200 && res.statusCode < 300) {
        await prefs?.setString(_kLastRegKey, fingerprint);
        await prefs?.setInt(
          _kLastRegAtKey,
          DateTime.now().millisecondsSinceEpoch,
        );
      } else {
        debugPrint('[push] register returned ${res.statusCode}; will retry');
      }
    } catch (e) {
      debugPrint('[push] token registration failed (non-fatal): $e');
    }
  }
}
