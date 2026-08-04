// Regression tests for the Fenton chart's Y-axis scaling.
//
// The bug these exist for: `_yInterval` matched the data range against a ladder
// of hard-coded bands whose last rung returned 5.0. That ladder was written
// when weight was stored in kilograms (range ~5). When weight moved to grams
// the range became ~6800, fell off the end of the ladder, and still got a
// 5-unit interval — about 1465 labels and gridlines stacked on each other,
// rendering the axis as a black smear and the plot area as solid grey.
//
// The real defect was that the scaling silently assumed a unit. So these tests
// assert a property that holds at ANY scale — a sane number of labels — rather
// than checking specific intervals, because pinning exact numbers would just
// re-encode the same brittleness in the test suite.

import 'package:flutter_test/flutter_test.dart';
import 'package:pediaid_app/screens/charts/fenton_chart_widget.dart';

/// Labels fl_chart will draw for a range, given the snapping the widget applies.
int _labelCount(double lo, double hi) {
  final step = fentonYInterval(hi - lo);
  final minY = (lo / step).floorToDouble() * step;
  final maxY = (hi / step).ceilToDouble() * step;
  return ((maxY - minY) / step).round() + 1;
}

void main() {
  group('fentonYInterval keeps label count sane at any scale', () {
    // Real Fenton 2025 extremes, from assets/data/fenton_data.json.
    const cases = <String, List<double>>{
      'male weight (g)': [331, 7181],
      'female weight (g)': [325, 6685],
      'male length (cm)': [26.2, 63],
      'female length (cm)': [25.8, 61.5],
      'male head circumference (cm)': [17, 41.6],
      'female head circumference (cm)': [16.3, 40.8],
    };

    cases.forEach((name, bounds) {
      test(name, () {
        final n = _labelCount(bounds[0], bounds[1]);
        expect(n, greaterThanOrEqualTo(3),
            reason: '$name: too few labels to read the axis');
        expect(n, lessThanOrEqualTo(12),
            reason: '$name: $n labels would overlap into an unreadable smear');
      });
    });
  });

  test('the exact regression: grams no longer produce a thousand labels', () {
    // The old ladder returned 5.0 for this range, giving ~1465 labels.
    expect(_labelCount(331, 7181), lessThan(12));
  });

  test('a unit change does not break the axis', () {
    // The same measurement in kg, g, and mg must all stay readable — this is
    // the property whose absence caused the original bug.
    for (final scale in [1.0, 1000.0, 1000000.0]) {
      final n = _labelCount(0.331 * scale, 7.181 * scale);
      expect(n, inInclusiveRange(3, 12), reason: 'broke at scale $scale');
    }
  });

  test('steps are readable 1/2/5 x 10^n values', () {
    for (final range in [1.0, 7.5, 25.0, 340.0, 6850.0, 99000.0]) {
      final step = fentonYInterval(range);
      var m = step;
      while (m >= 10) {
        m /= 10;
      }
      while (m < 1) {
        m *= 10;
      }
      expect([1.0, 2.0, 5.0], contains(double.parse(m.toStringAsFixed(6))),
          reason: 'range $range gave a non-round step of $step');
    }
  });

  test('degenerate ranges do not divide by zero or hang', () {
    expect(fentonYInterval(0), greaterThan(0));
    expect(fentonYInterval(-5), greaterThan(0));
    expect(fentonYInterval(double.nan), greaterThan(0));
    expect(fentonYInterval(double.infinity), greaterThan(0));
  });
}
