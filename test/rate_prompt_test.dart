// =============================================================================
// test/rate_prompt_test.dart
//
// The backoff sequence for the automatic "Enjoying PediAid?" dialog.
//
// The rule the app intends is: ask after five launches, then after two weeks,
// then after six more, then never. Getting it wrong in the eager direction is
// how an app earns one-star "stop nagging me" reviews — the exact outcome the
// prompt exists to avoid — and nothing in a running app makes that visible
// until the reviews arrive.
// =============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pediaid_app/services/rate_prompt_service.dart';

int _daysAgo(int d) =>
    DateTime.now().subtract(Duration(days: d)).millisecondsSinceEpoch;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a new install is not asked on first launch', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await RatePromptService.instance.shouldAsk(), isFalse);
  });

  test('not asked before the fifth launch, asked on it', () async {
    // Launches 1-4 all decline; each call records one launch.
    SharedPreferences.setMockInitialValues({});
    for (var i = 1; i <= 4; i++) {
      expect(await RatePromptService.instance.shouldAsk(), isFalse,
          reason: 'launch $i should not ask');
    }
    expect(await RatePromptService.instance.shouldAsk(), isTrue,
        reason: 'launch 5 is the first reasonable moment');
  });

  test('once the user taps through, never again', () async {
    SharedPreferences.setMockInitialValues({
      'rate_launch_count': 99,
      'rate_done': true,
    });
    expect(await RatePromptService.instance.shouldAsk(), isFalse);
  });

  group('backoff after each ask', () {
    test('13 days after the first ask is too soon; 14 is due', () async {
      SharedPreferences.setMockInitialValues({
        'rate_launch_count': 99,
        'rate_ask_count': 1,
        'rate_last_asked_epoch': _daysAgo(13),
      });
      expect(await RatePromptService.instance.shouldAsk(), isFalse);

      SharedPreferences.setMockInitialValues({
        'rate_launch_count': 99,
        'rate_ask_count': 1,
        'rate_last_asked_epoch': _daysAgo(15),
      });
      expect(await RatePromptService.instance.shouldAsk(), isTrue);
    });

    test('the second gap is six weeks, not two', () async {
      SharedPreferences.setMockInitialValues({
        'rate_launch_count': 99,
        'rate_ask_count': 2,
        'rate_last_asked_epoch': _daysAgo(20),
      });
      expect(await RatePromptService.instance.shouldAsk(), isFalse,
          reason: '20 days is past the FIRST gap but not the second');

      SharedPreferences.setMockInitialValues({
        'rate_launch_count': 99,
        'rate_ask_count': 2,
        'rate_last_asked_epoch': _daysAgo(43),
      });
      expect(await RatePromptService.instance.shouldAsk(), isTrue);
    });

    test('after three asks it stops for good, however long it has been',
        () async {
      SharedPreferences.setMockInitialValues({
        'rate_launch_count': 99,
        'rate_ask_count': 3,
        'rate_last_asked_epoch': _daysAgo(3650),
      });
      expect(await RatePromptService.instance.shouldAsk(), isFalse,
          reason: 'three asks over two months is the whole budget');
    });
  });

  test('markDoneExternally stops the sequence', () async {
    // Rating from Settings or the drawer must silence the automatic dialog.
    SharedPreferences.setMockInitialValues({'rate_launch_count': 99});
    await RatePromptService.instance.markDoneExternally();
    expect(await RatePromptService.instance.shouldAsk(), isFalse);
  });

  // ── The one-time Apple reset ───────────────────────────────────────────
  //
  // Up to 2.0.1, an iPhone user who tapped "Rate PediAid" had rate_done set,
  // then saw nothing, because requestReview() is silently suppressed by Apple
  // and the code returned before reaching the store. Those users are the most
  // willing to review and were silenced permanently. The flags were set on the
  // strength of a prompt that could not have reached the store, so they are
  // cleared once.
  group('iOS state left by the broken path is cleared, once', () {
    tearDown(() => debugDefaultTargetPlatformOverride = null);

    test('an iPhone user marked done IS asked again', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      SharedPreferences.setMockInitialValues({
        'rate_launch_count': 99,
        'rate_done': true,
        'rate_ask_count': 3,
        'rate_last_asked_epoch': _daysAgo(1),
      });
      expect(await RatePromptService.instance.shouldAsk(), isTrue,
          reason: 'they said yes and got nothing — ask them again');
    });

    test('ask_count is cleared too, or they stay silenced by the backoff',
        () async {
      // Leaving ask_count at 3 trips `asked > _kBackoffDays.length` and blocks
      // them through a different branch.
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      SharedPreferences.setMockInitialValues({
        'rate_launch_count': 99,
        'rate_ask_count': 3,
        'rate_last_asked_epoch': _daysAgo(3650),
      });
      expect(await RatePromptService.instance.shouldAsk(), isTrue);
    });

    test('it runs ONCE — a later genuine "done" sticks', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      SharedPreferences.setMockInitialValues({
        'rate_launch_count': 99,
        'rate_done': true,
      });
      // First call resets and asks.
      expect(await RatePromptService.instance.shouldAsk(), isTrue);
      // The user now genuinely taps through on the working build.
      await RatePromptService.instance.markDoneExternally();
      expect(await RatePromptService.instance.shouldAsk(), isFalse,
          reason: 'the reset must not fire a second time and undo this');
    });

    test('launch count is KEPT, so a long-time user is not made to wait',
        () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      SharedPreferences.setMockInitialValues({
        'rate_launch_count': 99,
        'rate_done': true,
      });
      expect(await RatePromptService.instance.shouldAsk(), isTrue,
          reason: 'clearing launch count would impose five more launches');
    });

    test('ANDROID is untouched — its native sheet actually worked', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      SharedPreferences.setMockInitialValues({
        'rate_launch_count': 99,
        'rate_done': true,
      });
      expect(await RatePromptService.instance.shouldAsk(), isFalse,
          reason: 'on Android rate_done means what it says');
    });
  });
}
