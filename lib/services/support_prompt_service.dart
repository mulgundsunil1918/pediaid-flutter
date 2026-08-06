// =============================================================================
// services/support_prompt_service.dart
//
// Asks, occasionally, whether someone wants to support the project.
//
// NEVER ON iOS. App Store guideline 3.1.1 requires digital purchases to go
// through in-app purchase, and 3.1.3 treats a link out to an external payment
// page as steering. A donation link in an iOS build is a routine rejection,
// so this is gated off before any state is even read.
//
// TIMING RULES, in order of importance:
//
//   1. Never during work. It fires from the home screen on open, never over a
//      calculator or a chart. Someone working out a dose mid-shift should not
//      have to dismiss a donation box to see the number.
//   2. Not before the app has proved useful. Nothing is shown until it has
//      been opened enough times to mean something.
//   3. Fourteen days minimum between asks, and a hard stop after a few. Two
//      weeks is the floor Sunil set; the escalation and the cap are here
//      because an app that asks forever teaches people to dismiss its dialogs
//      without reading, which costs more than the donations are worth.
//   4. "Support" or "No thanks" both stop it permanently. Someone who has
//      given, or who has said no, should not be asked again.
// =============================================================================

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const _kSupportUrl = 'https://bridgr.co.in/support?from=pediaid';

const _kLaunchCountKey = 'support_launch_count';
const _kLastAskedKey = 'support_last_asked';
const _kAskCountKey = 'support_ask_count';
const _kDoneKey = 'support_done';

/// Opens before the first ask. Enough use that the app has earned the question.
const _kMinLaunches = 8;

/// Sunil's floor is a fortnight. Later asks back off further, so someone who
/// keeps the app for a year is asked three times, not twenty-six.
const _kGaps = <Duration>[
  Duration(days: 14),
  Duration(days: 30),
  Duration(days: 60),
];

class SupportPromptService {
  SupportPromptService._();
  static final SupportPromptService instance = SupportPromptService._();

  /// iOS is excluded outright — see the header. kIsWeb is checked first
  /// because Platform throws on web.
  static bool get _isIos => !kIsWeb && Platform.isIOS;

  /// Call once on app open. Never from inside a tool.
  Future<void> maybeShow(BuildContext context) async {
    if (_isIos) return;

    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_kDoneKey) ?? false) return;

    final launches = (prefs.getInt(_kLaunchCountKey) ?? 0) + 1;
    await prefs.setInt(_kLaunchCountKey, launches);
    if (launches < _kMinLaunches) return;

    final asked = prefs.getInt(_kAskCountKey) ?? 0;
    if (asked >= _kGaps.length) {
      // Asked as often as this is ever going to. Stop for good rather than
      // leaving it to keep firing on the last interval forever.
      await prefs.setBool(_kDoneKey, true);
      return;
    }

    final lastMs = prefs.getInt(_kLastAskedKey);
    if (lastMs != null) {
      final since = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(lastMs),
      );
      if (since < _kGaps[asked]) return;
    }

    if (!context.mounted) return;
    await _show(context, prefs, asked);
  }

  Future<void> _show(
    BuildContext context,
    SharedPreferences prefs,
    int asked,
  ) async {
    await prefs.setInt(_kAskCountKey, asked + 1);
    await prefs.setInt(
      _kLastAskedKey,
      DateTime.now().millisecondsSinceEpoch,
    );

    if (!context.mounted) return;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // A compact sheet, not a dialog. It covers a strip at the bottom rather
    // than the screen, closes on an X, on a swipe down, or on a tap outside —
    // three ways out, none of them a decision.
    final supported = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1A12) : const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF92400E).withValues(alpha: 0.4)
                  : const Color(0xFFFDE68A),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('☕️', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'PediAid is free, and run by one paediatrician. '
                      'A small contribution keeps it online.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                  // The X is a plain close, not a refusal — it leaves the
                  // next ask on its timer instead of stopping for good.
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(ctx, false),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      // A definite no — stop asking entirely.
                      await prefs.setBool(_kDoneKey, true);
                      if (ctx.mounted) Navigator.pop(ctx, false);
                    },
                    child: Text(
                      "Don't ask again",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        color: isDark ? Colors.white38 : Colors.black45,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text('Support'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (supported == true) {
      // Treated as done: there is no signal that says whether a donation was
      // actually made, and asking again after someone tapped through would be
      // the most annoying possible outcome.
      await prefs.setBool(_kDoneKey, true);
      await launchUrl(
        Uri.parse(_kSupportUrl),
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
