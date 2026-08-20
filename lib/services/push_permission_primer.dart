// =============================================================================
// services/push_permission_primer.dart
//
// Asks for notification permission at a moment the user can say yes to.
//
// WHY THIS EXISTS
// ---------------
// PushService.init() used to call requestPermission() cold, during app start,
// before the user had seen a single screen. On iOS that spends the ONE system
// dialog Apple allows: tap "Don't Allow" once and it can never be shown again,
// only reached through Settings. And a denial makes init() return early — no
// FCM token, no topic subscription — so the user silently receives nothing,
// forever, while every server-side check looks perfectly healthy.
//
// The fix is standard pre-permission priming: show our own explainer first and
// only call the OS dialog if the user opts in. A "no" then costs our dialog,
// not Apple's, so we can ask again later.
//
// Timing: SECOND launch (Sunil's decision). By then the app has proved itself
// useful, which is what a person is actually saying yes to.
// =============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'push_service.dart';

class PushPermissionPrimer {
  PushPermissionPrimer._();

  static const _kLaunchCountKey = 'push_primer_launch_count';
  static const _kAskedKey = 'push_primer_asked';

  /// Launch on which the explainer is shown.
  static const int _kAskOnLaunch = 2;

  /// Records this launch and reports whether the explainer is due.
  ///
  /// Counting happens even when the prompt is not shown, so "second launch"
  /// means the second real app start rather than the second time this is
  /// checked.
  static Future<bool> registerLaunchAndShouldAsk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_kAskedKey) ?? false) return false;

      final count = (prefs.getInt(_kLaunchCountKey) ?? 0) + 1;
      await prefs.setInt(_kLaunchCountKey, count);
      return count >= _kAskOnLaunch;
    } catch (_) {
      return false;
    }
  }

  static Future<void> _markAsked() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kAskedKey, true);
    } catch (_) {/* asking twice is far better than crashing */}
  }

  /// Shows the explainer, and only on "Turn on" calls the OS dialog.
  ///
  /// Declining here is deliberately NOT recorded as permanent: the user said
  /// no to us, not to iOS, so a later release may ask again. Only reaching the
  /// real system dialog is final.
  static Future<void> maybeAsk(BuildContext context) async {
    if (!context.mounted) return;

    final wantsIt = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        final cs = Theme.of(ctx).colorScheme;
        return AlertDialog(
          icon: Icon(Icons.notifications_active_outlined,
              size: 30, color: cs.primary),
          title: Text('Stay up to date',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
          content: Text(
            'Get notified when a landmark trial, guideline note or CME event '
            'is published. Roughly one a week — no spam, and you can turn it '
            'off any time.',
            style: GoogleFonts.plusJakartaSans(fontSize: 13.5, height: 1.45),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Not now'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Turn on'),
            ),
          ],
        );
      },
    );

    if (wantsIt != true) return; // ask again on a later release
    await _markAsked();
    await PushService.instance.requestPermissionAndRegister();
  }

  /// Convenience for app start: count the launch, then prompt if due.
  static Future<void> maybeAskOnLaunch(BuildContext context) async {
    if (kIsWeb) return; // the browser prompt has its own rules
    final due = await registerLaunchAndShouldAsk();
    if (!due || !context.mounted) return;
    await maybeAsk(context);
  }
}
