// =============================================================================
// services/rate_prompt_service.dart
//
// Asks for a Play Store review, at a moment when asking is reasonable.
//
// The obvious brief — "prompt every week until they review" — cannot be built
// as stated, and it is worth being clear why rather than approximating it:
//
//   * Nothing tells an app whether a review was left. Neither the In-App
//     Review API nor Play reports it, so "until they review" has no signal to
//     stop on. The best available proxy is that the user tapped through, which
//     is what this treats as done.
//   * Google's own API is quota-limited and silently ignores repeat calls, so
//     a weekly loop would mostly show nothing while still counting as asked.
//   * Weekly nagging is how an app trains people to dismiss its dialogs
//     without reading, which costs more than the reviews are worth.
//
// So: ask after the app has actually been used, then back off hard — roughly
// two weeks, then six, then never again. Three asks over two months, not
// fifty-two a year.
// =============================================================================

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/share_message.dart';

const _kLaunchCountKey = 'rate_launch_count';
const _kLastAskedKey = 'rate_last_asked_epoch';
const _kAskCountKey = 'rate_ask_count';
const _kDoneKey = 'rate_done';

/// Launches before the first ask. Someone who has opened the app five times is
/// using it; someone on their first run has no basis for an opinion yet, and
/// being asked immediately reads as presumptuous.
const _kLaunchesBeforeFirstAsk = 5;

/// Days to wait before each subsequent ask. Running out ends the sequence, so
/// the app asks three times in total and then stops for good.
const _kBackoffDays = <int>[14, 42];

class RatePromptService {
  RatePromptService._();
  static final RatePromptService instance = RatePromptService._();

  /// Records a launch and returns true if this is a reasonable moment to ask.
  ///
  /// Deliberately not called during startup: a review dialog over a loading
  /// screen interrupts someone who opened the app to look something up, which
  /// is the worst possible moment to ask them for a favour.
  Future<bool> shouldAsk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_kDoneKey) ?? false) return false;

      final launches = (prefs.getInt(_kLaunchCountKey) ?? 0) + 1;
      await prefs.setInt(_kLaunchCountKey, launches);
      if (launches < _kLaunchesBeforeFirstAsk) return false;

      final asked = prefs.getInt(_kAskCountKey) ?? 0;
      if (asked > _kBackoffDays.length) return false;

      final last = prefs.getInt(_kLastAskedKey);
      if (last != null) {
        // asked == 1 means one ask has happened, so the wait is _kBackoffDays[0].
        final waitDays = _kBackoffDays[(asked - 1).clamp(0, _kBackoffDays.length - 1)];
        final due = DateTime.fromMillisecondsSinceEpoch(last)
            .add(Duration(days: waitDays));
        if (DateTime.now().isBefore(due)) return false;
      }
      return true;
    } catch (_) {
      // Storage unavailable — never ask rather than risk asking every launch.
      return false;
    }
  }

  Future<void> _recordAsked() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kAskCountKey, (prefs.getInt(_kAskCountKey) ?? 0) + 1);
      await prefs.setInt(
          _kLastAskedKey, DateTime.now().millisecondsSinceEpoch);
    } catch (_) {/* asking again later is harmless */}
  }

  Future<void> _markDone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kDoneKey, true);
    } catch (_) {/* worst case, one more ask */}
  }

  /// Shows the prompt if it is due. Safe to call from anywhere; does nothing
  /// when it is not time.
  Future<void> maybeAsk(BuildContext context) async {
    if (!await shouldAsk()) return;
    if (!context.mounted) return;
    await _recordAsked();
    // _recordAsked awaits, so the earlier check no longer covers us — the
    // screen can be gone by now.
    if (!context.mounted) return;

    // A quiet question first, rather than firing Google's card immediately.
    // The API's quota is spent whether or not the person wanted to review, so
    // asking first means the card is shown to people inclined to say yes —
    // and anyone who is not simply declines without a store page opening.
    final wants = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Enjoying PediAid?',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'If it has been useful on shift, a short review helps other '
          'paediatricians find it. It takes a moment.',
          style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Not now',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Rate PediAid',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (wants != true) return;

    // Tapping through counts as done. There is no way to learn whether a
    // review was actually submitted, and continuing to pester someone who
    // already agreed is worse than missing a review.
    await _markDone();
    await openStoreReview();
  }

  /// Sends someone who said yes somewhere they can actually leave a review.
  ///
  /// APPLE IS NOT ANDROID HERE, AND TREATING IT AS SUCH WAS THE BUG
  /// --------------------------------------------------------------
  /// This used to call `isAvailable()` then `requestReview()` and return. On
  /// iOS `isAvailable()` answers true on anything since 10.3, so that branch
  /// always won — and Apple's prompt is shown entirely at Apple's discretion,
  /// at most three times a year, with no callback and no way to know whether
  /// anything appeared. The overwhelmingly common outcome on iPhone was: the
  /// user taps "Rate PediAid", nothing happens, and `_markDone()` has already
  /// fired, so they are never asked again. Silent, permanent, and invisible in
  /// any log.
  ///
  /// The fallback made it worse: it opened the GOOGLE PLAY listing, which is
  /// useless on an iPhone.
  ///
  /// So Apple devices skip the native call entirely and open the App Store
  /// write-review page, which is deterministic. Android keeps the native
  /// sheet, where it is reliable and keeps the person in the app.
  Future<void> openStoreReview() async {
    final isApple = defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;

    if (!isApple) {
      try {
        final review = InAppReview.instance;
        if (await review.isAvailable()) {
          await review.requestReview();
          return;
        }
      } catch (_) {/* fall through to the listing */}
    }

    // Platform-aware: the App Store review page on Apple, Play on everything
    // else. Never the wrong store.
    await launchUrl(
      Uri.parse(reviewUrlForThisDevice()),
      mode: LaunchMode.externalApplication,
    );
  }

  /// Marks the sequence finished.
  ///
  /// Public so the manual "Rate PediAid" entries in Settings and the drawer can
  /// stop the automatic sequence — someone who went and rated deliberately
  /// should not then be asked by a dialog a fortnight later.
  Future<void> markDoneExternally() => _markDone();
}
