// =============================================================================
// test/who_chart_interpretation_test.dart
//
// WHY THIS EXISTS
// ---------------
// A user reported on 2026-08-21 that plotting a large head on
// head-circumference-for-age said "Overnutrition likely" instead of
// macrocephaly.
//
// The cause: the CENTILE interpretation was one metric-agnostic block that
// called anything below the 3rd centile "Undernutrition likely" and anything
// above the 97th "Overnutrition likely", on every chart. The Z-SCORE path had
// been metric-aware all along, so the same measurement gave a correct answer
// in one mode and a wrong one in the other.
//
// It compiled, analyzed clean and looked plausible on screen. Only a human
// reading clinical text on the right chart could catch it — which is exactly
// why it needs a test.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/charts/who_chart_screen.dart';

/// Every chart type this screen serves.
const _kChartTypes = <String>['wfa', 'lhfa', 'wfl', 'wfh', 'bfa', 'hcfa'];

void main() {
  group('Centile interpretation is metric-aware', () {
    test('head circumference reports micro/macrocephaly, never nutrition', () {
      final low = whoCentileInterpretation('hcfa', 'below3');
      final high = whoCentileInterpretation('hcfa', 'above97');

      expect(low.toLowerCase(), contains('microcephaly'));
      expect(high.toLowerCase(), contains('macrocephaly'));

      // The exact wording the user reported.
      expect(high.toLowerCase(), isNot(contains('overnutrition')));
      expect(low.toLowerCase(), isNot(contains('undernutrition')));
    });

    test('length/height reports stunting and tall stature', () {
      expect(whoCentileInterpretation('lhfa', 'below3').toLowerCase(),
          anyOf(contains('stunted'), contains('short stature')));
      expect(whoCentileInterpretation('lhfa', 'above97').toLowerCase(),
          contains('tall stature'));
    });

    test('weight-for-length reports wasting and overweight', () {
      for (final t in ['wfl', 'wfh']) {
        expect(whoCentileInterpretation(t, 'below3').toLowerCase(),
            contains('wasted'));
        expect(whoCentileInterpretation(t, 'above97').toLowerCase(),
            contains('overweight'));
      }
    });

    test('high weight-for-age is not called overweight on its own', () {
      // WHO: a high weight-for-age cannot be read alone, because a tall child
      // is heavy for age without being overnourished. It must point the reader
      // at weight-for-length or BMI.
      final t = whoCentileInterpretation('wfa', 'above97').toLowerCase();
      expect(t, anyOf(contains('weight-for-length'), contains('bmi')));
    });

    test('no chart uses nutrition wording where nutrition is not the metric',
        () {
      for (final t in ['hcfa', 'lhfa']) {
        for (final zone in ['below3', 'low', 'high', 'above97']) {
          final text = whoCentileInterpretation(t, zone).toLowerCase();
          expect(text, isNot(contains('nutrition')),
              reason: '$t/$zone still uses nutrition wording: $text');
        }
      }
    });

    test('every chart and zone returns non-empty text', () {
      for (final t in _kChartTypes) {
        for (final zone in ['below3', 'low', 'high', 'above97']) {
          expect(whoCentileInterpretation(t, zone).trim(), isNotEmpty,
              reason: '$t/$zone is empty');
        }
      }
    });
  });

  group('Centile and Z-score modes agree', () {
    // The two paths describe the same measurement. They may word it
    // differently, but they must not disagree about WHAT is being measured --
    // that was the whole defect.
    test('both name the same condition at the extremes', () {
      const expected = <String, List<String>>{
        'hcfa': ['microcephaly', 'macrocephaly'],
        'lhfa': ['stunt', 'tall'],
        'wfl': ['wast', 'overweight'],
      };
      expected.forEach((type, words) {
        final cLow = whoCentileInterpretation(type, 'below3').toLowerCase();
        final sLow = whoSdInterpretation(type, 'below3').toLowerCase();
        expect(cLow, contains(words[0]));
        expect(sLow, contains(words[0]),
            reason: 'Z-score mode disagrees for $type at the low extreme');

        final cHigh = whoCentileInterpretation(type, 'above97').toLowerCase();
        expect(cHigh, contains(words[1]));
      });
    });
  });
}
