import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../data/fenton_data_loader.dart';
import '../../logic/fenton_calculator.dart';

// ── Percentile palette ────────────────────────────────────────────────────────
const Color _cP3P97  = Color(0xFF7C4DFF); // purple  — outer bounds
const Color _cP10P90 = Color(0xFF0288D1); // blue    — inner bounds
const Color _cP50    = Color(0xFF00897B); // teal    — median
const Color _cDot    = Color(0xFFE53935); // red     — patient point

// ─────────────────────────────────────────────────────────────────────────────
/// Renders the Fenton percentile chart.
/// Pass [userGa] + [userValue] to plot the patient point.
// ─────────────────────────────────────────────────────────────────────────────
class FentonChartWidget extends StatelessWidget {
  final FentonChartData chartData;
  final FentonSex sex;
  final FentonParameter parameter;
  final double? userGa;
  final double? userValue;

  const FentonChartWidget({
    super.key,
    required this.chartData,
    required this.sex,
    required this.parameter,
    this.userGa,
    this.userValue,
  });

  List<FentonDataPoint> get _pts {
    final g = sex == FentonSex.male ? chartData.male : chartData.female;
    return switch (parameter) {
      FentonParameter.weight           => g.weight,
      FentonParameter.length           => g.length,
      FentonParameter.headCircumference => g.headCircumference,
    };
  }

  bool get _isWeight => parameter == FentonParameter.weight;

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final pts     = _pts;
    if (pts.isEmpty) return const SizedBox.shrink();

    // Generate smooth spots
    final p3s  = _spots('p3');
    final p10s = _spots('p10');
    final p50s = _spots('p50');
    final p90s = _spots('p90');
    final p97s = _spots('p97');

    // Y bounds from p3 and p97 extremes
    final allY = [...p3s.map((s) => s.y), ...p97s.map((s) => s.y)];
    final rawMin = allY.reduce((a, b) => a < b ? a : b);
    final rawMax = allY.reduce((a, b) => a > b ? a : b);
    final minY = (rawMin * 0.88).floorToDouble();
    final maxY = (rawMax * 1.06).ceilToDouble();

    final gridCol = cs.onSurface.withValues(alpha: isDark ? 0.1 : 0.08);
    final textCol = cs.onSurface.withValues(alpha: 0.5);

    // Build line bars
    final bars = <LineChartBarData>[
      _line(p3s,  _cP3P97,  1.3, dotted: true),
      _line(p10s, _cP10P90, 1.3, dotted: true),
      _line(p50s, _cP50,    2.2),
      _line(p90s, _cP10P90, 1.3, dotted: true),
      _line(p97s, _cP3P97,  1.3, dotted: true),
    ];

    // Patient dot
    if (userGa != null && userValue != null) {
      bars.add(LineChartBarData(
        spots: [FlSpot(userGa!, userValue!)],
        color: _cDot,
        barWidth: 0,
        dotData: FlDotData(
          show: true,
          getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
            radius: 5.5,
            color: _cDot,
            strokeWidth: 2,
            strokeColor: Colors.white,
          ),
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 260,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: LineChart(
              LineChartData(
                minX: 22,
                maxX: 50,
                minY: minY,
                maxY: maxY,
                lineBarsData: bars,
                extraLinesData: (userGa != null && userValue != null)
                    ? ExtraLinesData(
                        horizontalLines: [
                          HorizontalLine(
                            y: userValue!,
                            color: _cDot.withValues(alpha: 0.35),
                            strokeWidth: 1,
                            dashArray: [4, 4],
                          ),
                        ],
                        verticalLines: [
                          VerticalLine(
                            x: userGa!,
                            color: _cDot.withValues(alpha: 0.35),
                            strokeWidth: 1,
                            dashArray: [4, 4],
                          ),
                        ],
                      )
                    : null,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  verticalInterval: 2,
                  horizontalInterval: _yInterval(minY, maxY),
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: gridCol, strokeWidth: 0.7),
                  getDrawingVerticalLine: (_) =>
                      FlLine(color: gridCol, strokeWidth: 0.7),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 4,
                      reservedSize: 22,
                      getTitlesWidget: (v, meta) => SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(
                          v.toInt().toString(),
                          style: TextStyle(fontSize: 9.5, color: textCol),
                        ),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: _yInterval(minY, maxY),
                      getTitlesWidget: (v, meta) => SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(
                          _isWeight
                              ? v.toStringAsFixed(1)
                              : v.toInt().toString(),
                          style: TextStyle(fontSize: 9, color: textCol),
                        ),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: gridCol),
                ),
                lineTouchData: const LineTouchData(enabled: false),
              ),
            ),
          ),
        ),

        // Axis labels
        Padding(
          padding: const EdgeInsets.only(left: 40, right: 16, top: 2),
          child: Center(
            child: Text(
              'Gestational Age (weeks)',
              style: TextStyle(
                  fontSize: 10.5,
                  color: cs.onSurface.withValues(alpha: 0.5)),
            ),
          ),
        ),

        // Legend
        const SizedBox(height: 10),
        _FentonLegend(showDot: userGa != null && userValue != null),
      ],
    );
  }

  List<FlSpot> _spots(String key) =>
      FentonCalculator.generateCurveSpots(_pts, key)
          .map((p) => FlSpot(p.ga, p.value))
          .toList();

  LineChartBarData _line(List<FlSpot> spots, Color color, double width,
      {bool dotted = false}) =>
      LineChartBarData(
        spots: spots,
        color: color,
        barWidth: width,
        isCurved: true,
        curveSmoothness: 0.25,
        preventCurveOverShooting: true,
        dotData: const FlDotData(show: false),
        dashArray: dotted ? [6, 3] : null,
        belowBarData: BarAreaData(show: false),
      );

  double _yInterval(double minY, double maxY) {
    final r = maxY - minY;
    if (r <= 1.5) return 0.2;
    if (r <= 4)   return 0.5;
    if (r <= 12)  return 1.0;
    if (r <= 25)  return 2.0;
    return 5.0;
  }
}

// ── Legend ────────────────────────────────────────────────────────────────────

class _FentonLegend extends StatelessWidget {
  final bool showDot;
  const _FentonLegend({required this.showDot});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: [
        _item('P3',   _cP3P97,  dotted: true, cs: cs),
        _item('P10',  _cP10P90, dotted: true, cs: cs),
        _item('P50',  _cP50,    cs: cs),
        _item('P90',  _cP10P90, dotted: true, cs: cs),
        _item('P97',  _cP3P97,  dotted: true, cs: cs),
        if (showDot)
          _dotItem('Patient', _cDot, cs),
      ],
    );
  }

  Widget _item(String label, Color color,
      {bool dotted = false, required ColorScheme cs}) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        width: 22,
        height: 12,
        child: CustomPaint(
          painter: _LinePainter(color: color, dotted: dotted),
        ),
      ),
      const SizedBox(width: 4),
      Text(label,
          style: TextStyle(
              fontSize: 10.5,
              color: cs.onSurface.withValues(alpha: 0.65),
              fontWeight: FontWeight.w600)),
    ]);
  }

  Widget _dotItem(String label, Color color, ColorScheme cs) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      ),
      const SizedBox(width: 4),
      Text(label,
          style: TextStyle(
              fontSize: 10.5,
              color: color,
              fontWeight: FontWeight.w700)),
    ]);
  }
}

class _LinePainter extends CustomPainter {
  final Color color;
  final bool dotted;
  const _LinePainter({required this.color, required this.dotted});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = dotted ? 1.5 : 2.2
      ..style = PaintingStyle.stroke;

    if (dotted) {
      double x = 0;
      bool draw = true;
      while (x < size.width) {
        final end = (x + 4).clamp(0.0, size.width);
        if (draw) {
          canvas.drawLine(
              Offset(x, size.height / 2), Offset(end, size.height / 2), paint);
        }
        x += draw ? 4 : 3;
        draw = !draw;
      }
    } else {
      canvas.drawLine(
          Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    }
  }

  @override
  bool shouldRepaint(_LinePainter o) => o.color != color || o.dotted != dotted;
}
