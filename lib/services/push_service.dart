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
import 'auth_service.dart';

/// Paste the Web Push certificate key pair here (Firebase console →
/// Project Settings → Cloud Messaging → Web configuration) to enable
/// push on pediaid.bridgr.co.in. Empty string = web push disabled.
const String _webVapidKey = '';

class PushService {
  PushService._();
  static final PushService instance = PushService._();

  /// Set from main.dart so foreground pushes can surface as a SnackBar on
  /// whatever screen is open, without each screen needing wiring.
  static GlobalKey<ScaffoldMessengerState>? messengerKey;

  bool _initialized = false;

  static bool get _supported =>
      kIsWeb || defaultTargetPlatform == TargetPlatform.android;

  /// Fire-and-forget from main(). Never throws — push being unavailable
  /// must not affect the rest of the app.
  Future<void> init() async {
    if (_initialized || !_supported) return;
    // Without a VAPID key web push can't work at all — bail before
    // requestPermission() so visitors never see a pointless browser
    // notification-permission popup.
    if (kIsWeb && _webVapidKey.isEmpty) return;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;

      if (kIsWeb) {
        final token = await messaging.getToken(vapidKey: _webVapidKey);
        if (token == null) return;
        await _registerTokenWithBackend(token);
        messaging.onTokenRefresh.listen(_registerTokenWithBackend);
      } else {
        // Android supports client-side topic subscription directly.
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
              n.body == null || n.body!.isEmpty ? n.title ?? '' : '${n.title} — ${n.body}',
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

  Future<void> _registerTokenWithBackend(String token) async {
    try {
      await http
          .post(
            Uri.parse('${AuthService.apiBase}/api/push/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'token': token}),
          )
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('[push] token registration failed (non-fatal): $e');
    }
  }
}
