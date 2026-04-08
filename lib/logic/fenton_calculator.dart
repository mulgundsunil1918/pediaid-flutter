import '../data/fenton_data_loader.dart';

// ── Enums ─────────────────────────────────────────────────────────────────────

enum FentonSex { male, female }

enum FentonParameter { weight, length, headCircumference }

// ── Result model ──────────────────────────────────────────────────────────────

class FentonPercentiles {
  final double p3, p10, p50, p90, p97;
  const FentonPercentiles(
      {required this.p3,
      required this.p10,
      required this.p50,
      required this.p90,
      required this.p97});
}

class FentonResult {
  final FentonPercentiles percentiles;
  final String percentileBand; // e.g. "P10 – P50"
  final String? classification; // SGA / AGA / LGA (weight only)

  const FentonResult({
    required this.percentiles,
    required this.percentileBand,
    this.classification,
  });
}

// ── Calculator ────────────────────────────────────────────────────────────────

class FentonCalculator {
  // Returns null if GA is outside the data range.
  static FentonResult? calculate({
    required List<FentonDataPoint> dataPoints,
    required double ga,
    required double value,
    required FentonParameter parameter,
  }) {
    if (dataPoints.isEmpty) return null;

    final minGa = dataPoints.first.ga.toDouble();
    final maxGa = dataPoints.last.ga.toDouble();
    if (ga < minGa || ga > maxGa) return null;

    // Find surrounding bracket
    FentonDataPoint lower = dataPoints.first;
    FentonDataPoint upper = dataPoints.last;

    for (int i = 0; i < dataPoints.length - 1; i++) {
      if (dataPoints[i].ga <= ga && dataPoints[i + 1].ga >= ga) {
        lower = dataPoints[i];
        upper = dataPoints[i + 1];
        break;
      }
    }

    final pct = lower.ga == upper.ga
        ? FentonPercentiles(
            p3: lower.p3,
            p10: lower.p10,
            p50: lower.p50,
            p90: lower.p90,
            p97: lower.p97,
          )
        : FentonPercentiles(
            p3: _lerp(lower.ga, upper.ga, lower.p3, upper.p3, ga),
            p10: _lerp(lower.ga, upper.ga, lower.p10, upper.p10, ga),
            p50: _lerp(lower.ga, upper.ga, lower.p50, upper.p50, ga),
            p90: _lerp(lower.ga, upper.ga, lower.p90, upper.p90, ga),
            p97: _lerp(lower.ga, upper.ga, lower.p97, upper.p97, ga),
          );

    return FentonResult(
      percentiles: pct,
      percentileBand: _band(value, pct),
      classification: parameter == FentonParameter.weight
          ? _classify(value, pct.p10, pct.p90)
          : null,
    );
  }

  // Generate dense spots for smooth curve rendering (step = 0.5 weeks).
  static List<({double ga, double value})> generateCurveSpots(
    List<FentonDataPoint> dataPoints,
    String pctKey, // 'p3'|'p10'|'p50'|'p90'|'p97'
  ) {
    if (dataPoints.isEmpty) return [];
    final result = <({double ga, double value})>[];
    final minGa = dataPoints.first.ga.toDouble();
    final maxGa = dataPoints.last.ga.toDouble();

    double ga = minGa;
    while (ga <= maxGa + 0.001) {
      FentonDataPoint low = dataPoints.first;
      FentonDataPoint high = dataPoints.last;

      for (int i = 0; i < dataPoints.length - 1; i++) {
        if (dataPoints[i].ga <= ga && dataPoints[i + 1].ga >= ga) {
          low = dataPoints[i];
          high = dataPoints[i + 1];
          break;
        }
      }

      final double v = low.ga == high.ga
          ? _pctVal(low, pctKey)
          : _lerp(low.ga, high.ga, _pctVal(low, pctKey), _pctVal(high, pctKey), ga);

      result.add((ga: ga, value: v));
      ga += 0.5;
    }
    return result;
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  static double _lerp(int gaLow, int gaHigh, double vLow, double vHigh, double ga) {
    final t = (ga - gaLow) / (gaHigh - gaLow);
    return vLow + t * (vHigh - vLow);
  }

  static double _pctVal(FentonDataPoint pt, String key) => switch (key) {
        'p3' => pt.p3,
        'p10' => pt.p10,
        'p50' => pt.p50,
        'p90' => pt.p90,
        'p97' => pt.p97,
        _ => pt.p50,
      };

  static String _band(double v, FentonPercentiles p) {
    if (v < p.p3) return 'Below P3';
    if (v < p.p10) return 'P3 – P10';
    if (v < p.p50) return 'P10 – P50';
    if (v <= p.p90) return 'P50 – P90';
    if (v <= p.p97) return 'P90 – P97';
    return 'Above P97';
  }

  static String _classify(double v, double p10, double p90) {
    if (v < p10) return 'SGA';
    if (v <= p90) return 'AGA';
    return 'LGA';
  }
}
