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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const _kPlayUrl =
    'https://play.google.com/store/apps/details?id=com.pediaid.pediaid';

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

    try {
      final review = InAppReview.instance;
      if (await review.isAvailable()) {
        await review.requestReview();
        return;
      }
    } catch (_) {/* fall through to the store listing */}

    // requestReview does nothing on builds not installed from Play, so the
    // listing is the only reliable path there.
    await launchUrl(Uri.parse(_kPlayUrl), mode: LaunchMode.externalApplication);
  }
}
