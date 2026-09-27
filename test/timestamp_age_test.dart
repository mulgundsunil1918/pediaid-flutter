// =============================================================================
// test/timestamp_age_test.dart
//
// Working an age out from two timestamps, for the bilirubin screens.
//
// The arithmetic is trivial and the edge cases are not. Two matter clinically:
//
//   * A sample earlier than the birth must give NOTHING, not zero. Zero is a
//     real, plottable age on both charts — the thresholds start there — so
//     letting it stand in for "not known" would plot a point nobody entered.
//   * Rounding is to the NEAREST hour, not truncated. Thirty-five minutes
//     short of an hour is nearer that hour than the one before it, and these
//     charts are steepest in exactly the region where that matters.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

/// The rule under test, kept here in the same form both screens use.
int? hoursBetween(DateTime? birth, DateTime? sample) {
  if (birth == null || sample == null) return null;
  final mins = sample.difference(birth).inMinutes;
  if (mins < 0) return null;
  return (mins + 30) ~/ 60;
}

void main() {
  group('the age is only known when both times are', () {
    test('a missing birth time gives nothing', () {
      expect(hoursBetween(null, DateTime(2026, 9, 27, 9, 15)), isNull);
    });

    test('a missing sample time gives nothing', () {
      expect(hoursBetween(DateTime(2026, 9, 25, 21, 40), null), isNull);
    });

    test('a sample BEFORE the birth gives nothing, not zero', () {
      final birth = DateTime(2026, 9, 26, 12, 0);
      final sample = DateTime(2026, 9, 26, 11, 0);
      expect(hoursBetween(birth, sample), isNull,
          reason: 'zero is a real age on these charts and must not stand in '
              'for an impossible one');
    });

    test('a sample at the moment of birth is zero, which IS a real age', () {
      final t = DateTime(2026, 9, 26, 12, 0);
      expect(hoursBetween(t, t), 0);
    });
  });

  group('rounding is to the nearest hour', () {
    test("Sunil's worked example: 21:40 Tuesday to 09:15 Thursday", () {
      final birth = DateTime(2026, 9, 22, 21, 40);
      final sample = DateTime(2026, 9, 24, 9, 15);
      // 35 h 35 min -> 36 h to the nearest hour.
      expect(hoursBetween(birth, sample), 36);
    });

    test('29 minutes rounds down, 30 rounds up', () {
      final birth = DateTime(2026, 9, 26, 0, 0);
      expect(hoursBetween(birth, DateTime(2026, 9, 26, 5, 29)), 5);
      expect(hoursBetween(birth, DateTime(2026, 9, 26, 5, 30)), 6);
    });

    test('truncation would have under-reported by nearly an hour', () {
      final birth = DateTime(2026, 9, 26, 0, 0);
      final sample = DateTime(2026, 9, 26, 11, 59);
      expect(hoursBetween(birth, sample), 12,
          reason: 'truncating would say 11, on a chart that climbs steeply '
              'through the first days');
    });
  });

  group('the range the charts actually cover', () {
    test('14 days is 336 hours — the NICE chart ends there', () {
      final birth = DateTime(2026, 9, 1, 0, 0);
      expect(hoursBetween(birth, DateTime(2026, 9, 15, 0, 0)), 336);
    });

    test('a three-week-old is well past it, and the value says so', () {
      final birth = DateTime(2026, 9, 1, 0, 0);
      final h = hoursBetween(birth, DateTime(2026, 9, 22, 0, 0));
      expect(h, 504);
      expect(h! > 336, isTrue,
          reason: 'the screen clamps to 14 d and must warn rather than plot '
              'silently');
    });

    test('daylight-free local arithmetic holds across a month boundary', () {
      final birth = DateTime(2026, 8, 31, 23, 0);
      expect(hoursBetween(birth, DateTime(2026, 9, 1, 1, 0)), 2);
    });
  });
}
