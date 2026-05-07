// =============================================================================
// services/review_service.dart
//
// Triggers the native in-app review prompt at sensible moments. Every guard
// from the production-ready spec is implemented:
//
//   - Skipped entirely on web (no Play Services / app store).
//   - Won't fire if the install is fresher than 3 days.
//   - Won't fire more often than every 7 days.
//   - Won't fire if the user has disabled review prompts in Profile.
//   - Always silent on failure — never shows an error to the user.
//
// Google's own server-side rate limit means the prompt itself only appears
// occasionally, so weekly call attempts are safe.
//
// Usage:
//   // First-launch bookkeeping (call once at app start):
//   ReviewService.instance.markFirstLaunchIfMissing();
//
//   // After a meaningful "value moment" (e.g. user completed a calculation):
//   ReviewService.instance.maybePrompt();
// =============================================================================

import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/prefs_keys.dart';

class ReviewService {
  ReviewService._();
  static final ReviewService instance = ReviewService._();

  static const Duration _minInstallAge = Duration(days: 3);
  static const Duration _minBetweenPrompts = Duration(days: 7);

  final InAppReview _review = InAppReview.instance;

  /// Stamp the first-launch timestamp on first call; no-op afterwards.
  Future<void> markFirstLaunchIfMissing() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getInt(PrefsKeys.firstLaunchAt) == null) {
        await prefs.setInt(PrefsKeys.firstLaunchAt,
            DateTime.now().millisecondsSinceEpoch);
      }
    } catch (e) {
      debugPrint('[ReviewService] markFirstLaunchIfMissing failed: $e');
    }
  }

  /// Try to show the in-app review prompt. Silently skips if any guard
  /// fails. Returns true if a prompt was attempted (Google may still
  /// internally rate-limit).
  Future<bool> maybePrompt() async {
    if (kIsWeb) return false;
    try {
      final prefs = await SharedPreferences.getInstance();

      // Respect user toggle (default: ON).
      final enabled = prefs.getBool(PrefsKeys.reviewPromptsEnabled) ?? true;
      if (!enabled) return false;

      // Install age gate.
      final firstLaunch = prefs.getInt(PrefsKeys.firstLaunchAt);
      if (firstLaunch == null) {
        // Cold install — record the timestamp now and bail. We'll be
        // eligible 3 days from now.
        await prefs.setInt(PrefsKeys.firstLaunchAt,
            DateTime.now().millisecondsSinceEpoch);
        return false;
      }
      final installAge = DateTime.now().millisecondsSinceEpoch - firstLaunch;
      if (installAge < _minInstallAge.inMilliseconds) return false;

      // Throttle.
      final lastPrompt = prefs.getInt(PrefsKeys.lastReviewPromptAt) ?? 0;
      final sinceLast =
          DateTime.now().millisecondsSinceEpoch - lastPrompt;
      if (sinceLast < _minBetweenPrompts.inMilliseconds) return false;

      // Availability.
      final available = await _review.isAvailable();
      if (!available) return false;

      // Stamp BEFORE the request — if the user dismisses, we still
      // throttle the next attempt.
      await prefs.setInt(PrefsKeys.lastReviewPromptAt,
          DateTime.now().millisecondsSinceEpoch);

      await _review.requestReview();
      return true;
    } catch (e) {
      debugPrint('[ReviewService] maybePrompt failed silently: $e');
      return false;
    }
  }
}
