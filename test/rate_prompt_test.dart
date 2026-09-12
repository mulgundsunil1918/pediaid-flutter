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
}
