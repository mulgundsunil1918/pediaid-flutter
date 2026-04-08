import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../services/who_data_service.dart';

const Color _boyBlue  = Color(0xFF1565C0);
const Color _girlPink = Color(0xFFAD1457);

// Percentile line colours
const Color _p3Color  = Color(0xFFD32F2F);
const Color _p10Color = Color(0xFFF57C00);
const Color _p25Color = Color(0xFFFBC02D);
const Color _p50Color = Color(0xFF388E3C);
const Color _p75Color = Color(0xFFFBC02D);
const Color _p90Color = Color(0xFFF57C00);
const Color _p97Color = Color(0xFFD32F2F);

// Z-score line colours
const Color _sd3nColor = Color(0xFFD32F2F);
const Color _sd2nColor = Color(0xFFF57C00);
const Color _sd0Color  = Color(0xFF388E3C);
const Color _sd2Color  = Color(0xFFF57C00);
const Color _sd3Color  = Color(0xFFD32F2F);

enum ChartMode   { percentile, zscore }
enum AgeInputMode { yearsMonths, decimal }

// ─────────────────────────────────────────────────────────────────────────────

class WhoChartScreen extends StatefulWidget {
  final String chartType;
  final String gender;
  final String title;

  const WhoChartScreen({
    super.key,
    required this.chartType,
    required this.gender,
    required this.title,
  });

  @override
  State<WhoChartScreen> createState() => _WhoChartScreenState();
}

// ─────────────────────────────────────────────────────────────────────────────

class _WhoChartScreenState extends State<WhoChartScreen> {
  ChartMode    _mode         = ChartMode.percentile;
  AgeInputMode _ageInputMode = AgeInputMode.yearsMonths;

  List<WhoPercentilePoint>? _pData;
  List<WhoZScorePoint>?     _zData;
  bool    _isLoading = true;
  String? _error;

  int _selectedYears  = 0;
  int _selectedMonths = 0;

  final _ageCtrl     = TextEditingController();
  final _measureCtrl = TextEditingController();
  final _weightCtrl  = TextEditingController();
  final _heightCtrl  = TextEditingController();

  double? _userX;
  double? _userY;
  bool   _hasResult            = false;
  String _resultBand           = '';
  Color  _resultColor          = Colors.grey;
  String _resultInterpretation = '';
  String _bmiDisplay           = '';

  final GlobalKey _chartKey = GlobalKey();

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _loadData();
    if (_isBfa) {
      _weightCtrl.addListener(_updateBmi);
      _heightCtrl.addListener(_updateBmi);
    }
  }

  @override
  void dispose() {
    _ageCtrl.dispose();
    _measureCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  // ── Computed properties ────────────────────────────────────────────────────

  bool get _isAgeBased =>
      widget.chartType != 'wfl' && widget.chartType != 'wfh';
  bool get _isBfa  => widget.chartType == 'bfa';
  bool get _isLhfa => widget.chartType == 'lhfa';

  Color get _accentColor =>
      widget.gender == 'boys' ? _boyBlue : _girlPink;
  Color get _bgTint =>
      widget.gender == 'boys'
          ? const Color(0xFFE3F2FD)
          : const Color(0xFFFCE4EC);

  String get _genderLabel => widget.gender == 'boys' ? 'Boys' : 'Girls';

  String get _chartFullName {
    switch (widget.chartType) {
      case 'bfa':  return 'BMI for Age';
      case 'lhfa': return 'Length / Height for Age';
      case 'wfa':  return 'Weight for Age';
      case 'hcfa': return 'Head Circumference for Age';
      case 'wfl':  return 'Weight for Length';
      case 'wfh':  return 'Weight for Height';
      default:     return widget.title;
    }
  }

  String get _xAxisLabel =>
      _isAgeBased
          ? 'Age (months)'
          : (widget.chartType == 'wfl' ? 'Length (cm)' : 'Height (cm)');

  String get _measureLabel {
    switch (widget.chartType) {
      case 'bfa':  return 'BMI (kg/m²)';
      case 'lhfa': return 'Length/Height (cm)';
      case 'wfa':  return 'Weight (kg)';
      case 'hcfa': return 'Head Circumference (cm)';
      case 'wfl':  return 'Weight (kg)';
      case 'wfh':  return 'Weight (kg)';
      default:     return 'Measurement';
    }
  }

  String get _measureHint {
    switch (widget.chartType) {
      case 'lhfa': return 'e.g. 65.0';
      case 'wfa':  return 'e.g. 7.5';
      case 'hcfa': return 'e.g. 40.5';
      default:     return 'e.g. 10.0';
    }
  }

  double get _ageMonthsTotal =>
      (_selectedYears * 12 + _selectedMonths).toDouble();

  double? get _ageForCalc {
    if (!_isAgeBased) return null;
    return _ageInputMode == AgeInputMode.yearsMonths
        ? _ageMonthsTotal
        : double.tryParse(_ageCtrl.text);
  }

  // ── Data loading ───────────────────────────────────────────────────────────

  Future<void> _loadData() async {
    try {
      final pData = await WhoDataService.instance
          .loadPercentileData(widget.chartType, widget.gender);
      final zData = await WhoDataService.instance
          .loadZScoreData(widget.chartType, widget.gender);
      setState(() {
        _pData = pData;
        _zData = zData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _updateBmi() {
    final w = double.tryParse(_weightCtrl.text);
    final h = double.tryParse(_heightCtrl.text);
    if (w != null && h != null && h > 0) {
      final bmi = w / ((h / 100) * (h / 100));
      setState(() => _bmiDisplay = 'BMI: ${bmi.toStringAsFixed(1)} kg/m²');
    } else {
      setState(() => _bmiDisplay = '');
    }
  }

  List<T> _sampled<T>(List<T> src, double Function(T) getDay) {
    final result = <T>[];
    double next = 0;
    final maxDay = _isAgeBased ? 1826.25 : double.infinity;
    for (final p in src) {
      final day = getDay(p);
      if (day > maxDay) break;
      if (day >= next) {
        result.add(p);
        next = day + 15;
      }
    }
    return result;
  }

  double _toChartX(double raw) => _isAgeBased ? raw / 30.4375 : raw;

  double _computeGridInterval(double minY, double maxY) {
    final range = maxY - minY;
    if (range <= 10) return 1.0;
    if (range <= 20) return 2.0;
    if (range <= 50) return 5.0;
    if (range <= 100) return 10.0;
    return 20.0;
  }

  // ── Chart capture ──────────────────────────────────────────────────────────

  Future<Uint8List?> _captureChart() async {
    try {
      final boundary = _chartKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: 1.5);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  // ── PDF generation ─────────────────────────────────────────────────────────

  Future<Uint8List> _generateFullPdf(Uint8List? chartImageBytes) async {
    final doc = pw.Document();
    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year}';
    final modeLabel =
        _mode == ChartMode.percentile ? 'Centile Chart' : 'SD Chart';
    const navyPdf = PdfColor(0.10, 0.14, 0.49); // ~#1a237e

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header row
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('PediAid',
                          style: pw.TextStyle(
                              fontSize: 22,
                              fontWeight: pw.FontWeight.bold,
                              color: navyPdf)),
                      pw.Text('WHO Growth Chart',
                          style: pw.TextStyle(
                              fontSize: 13, color: PdfColors.grey700)),
                    ],
                  ),
                  pw.Text(dateStr,
                      style: pw.TextStyle(
                          fontSize: 10, color: PdfColors.grey600)),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Divider(color: navyPdf),
              pw.SizedBox(height: 10),
              pw.Text('$_genderLabel — $_chartFullName',
                  style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: navyPdf)),
              pw.Text('WHO Growth Standards 2006 · $modeLabel',
                  style: pw.TextStyle(
                      fontSize: 11, color: PdfColors.grey700)),
              pw.SizedBox(height: 14),
              // Chart image
              if (chartImageBytes != null)
                pw.Image(pw.MemoryImage(chartImageBytes),
                    height: 270, fit: pw.BoxFit.contain)
              else
                pw.Container(
                  height: 270,
                  color: PdfColors.grey200,
                  child: pw.Center(
                    child: pw.Text('Chart image unavailable',
                        style: pw.TextStyle(
                            fontSize: 12, color: PdfColors.grey600)),
                  ),
                ),
              pw.SizedBox(height: 14),
              // Result
              if (_hasResult) ...[
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey400),
                    borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(6)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Result',
                          style: pw.TextStyle(
                              fontSize: 13,
                              fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text(_resultBand,
                          style: const pw.TextStyle(fontSize: 12)),
                      pw.SizedBox(height: 2),
                      pw.Text(_resultInterpretation,
                          style: pw.TextStyle(
                              fontSize: 11,
                              color: PdfColors.grey700)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 12),
              ],
              pw.SizedBox(height: 20),
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 4),
              pw.Text(
                'WHO Child Growth Standards 2006 — For clinical use only',
                style: pw.TextStyle(
                    fontSize: 9, color: PdfColors.grey600),
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  Future<Uint8List> _generateScreenshotPdf(
      Uint8List? chartImageBytes) async {
    final doc = pw.Document();
    const navyPdf = PdfColor(0.10, 0.14, 0.49);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text('$_genderLabel — $_chartFullName',
                  style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                      color: navyPdf)),
              pw.Text('WHO Growth Standards 2006',
                  style: pw.TextStyle(
                      fontSize: 10, color: PdfColors.grey600)),
              pw.SizedBox(height: 10),
              if (chartImageBytes != null)
                pw.Expanded(
                  child: pw.Image(pw.MemoryImage(chartImageBytes),
                      fit: pw.BoxFit.contain),
                )
              else
                pw.Expanded(
                  child: pw.Center(
                    child: pw.Text('Chart unavailable',
                        style: const pw.TextStyle(fontSize: 12)),
                  ),
                ),
              pw.SizedBox(height: 8),
              pw.Text(
                'WHO Child Growth Standards 2006 — For clinical use only',
                style:
                    pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  // ── Export actions ─────────────────────────────────────────────────────────

  void _showLoadingSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        duration: const Duration(seconds: 15),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Future<void> _exportPdf() async {
    _showLoadingSnackBar('Generating PDF…');
    await Future.delayed(const Duration(milliseconds: 80));
    try {
      final imageBytes = await _captureChart();
      final pdfBytes = await _generateFullPdf(imageBytes);
      if (mounted) ScaffoldMessenger.of(context).hideCurrentSnackBar();
      await Printing.layoutPdf(
          name: '$_genderLabel-$_chartFullName',
          onLayout: (_) => pdfBytes);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  Future<void> _exportScreenshot() async {
    _showLoadingSnackBar('Capturing chart…');
    await Future.delayed(const Duration(milliseconds: 80));
    try {
      final imageBytes = await _captureChart();
      final pdfBytes = await _generateScreenshotPdf(imageBytes);
      if (mounted) ScaffoldMessenger.of(context).hideCurrentSnackBar();
      await Printing.layoutPdf(
          name: '$_genderLabel-$_chartFullName-screenshot',
          onLayout: (_) => pdfBytes);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Screenshot failed: $e')));
      }
    }
  }

  // ── Calculation ────────────────────────────────────────────────────────────

  void _calculate() {
    final double? xRaw = _isAgeBased
        ? _ageForCalc
        : double.tryParse(_measureCtrl.text);
    if (xRaw == null) return;

    double? yVal;
    if (_isBfa) {
      final w = double.tryParse(_weightCtrl.text);
      final h = double.tryParse(_heightCtrl.text);
      if (w == null || h == null || h <= 0) return;
      yVal = w / ((h / 100) * (h / 100));
    } else if (!_isAgeBased) {
      yVal = double.tryParse(_weightCtrl.text);
    } else {
      yVal = double.tryParse(_measureCtrl.text);
    }
    if (yVal == null) return;

    final double xNative = _isAgeBased ? xRaw * 30.4375 : xRaw;

    if (_mode == ChartMode.percentile && _pData != null) {
      _calcPercentile(xRaw, xNative, yVal);
    } else if (_mode == ChartMode.zscore && _zData != null) {
      _calcZScore(xRaw, xNative, yVal);
    }
  }

  void _calcPercentile(double xDisplay, double xNative, double y) {
    WhoPercentilePoint? nearest;
    double minDiff = double.infinity;
    for (final p in _pData!) {
      final diff = (p.day - xNative).abs();
      if (diff < minDiff) {
        minDiff = diff;
        nearest = p;
      }
    }
    if (nearest == null) return;

    String band;
    Color color;
    String interpretation;

    if (y < nearest.p3) {
      band = 'Below 3rd centile';
      color = const Color(0xFFB71C1C);
      interpretation =
          'Below 3rd centile — Undernutrition likely. Clinical evaluation recommended.';
    } else if (y < nearest.p10) {
      band = '3rd–10th centile';
      color = const Color(0xFFF57C00);
      interpretation = '3rd–10th centile — Low normal. Monitor closely.';
    } else if (y < nearest.p90) {
      band = 'Normal range (10th–90th centile)';
      color = const Color(0xFF2E7D32);
      interpretation = 'Normal range (10th–90th centile)';
    } else if (y < nearest.p97) {
      band = '90th–97th centile';
      color = const Color(0xFFF57C00);
      interpretation = '90th–97th centile — High normal. Monitor.';
    } else {
      band = 'Above 97th centile';
      color = const Color(0xFFB71C1C);
      interpretation =
          'Above 97th centile — Overnutrition likely. Clinical evaluation recommended.';
    }

    setState(() {
      _userX = xDisplay;
      _userY = y;
      _resultBand = band;
      _resultColor = color;
      _resultInterpretation = interpretation;
      _hasResult = true;
    });
  }

  void _calcZScore(double xDisplay, double xNative, double y) {
    WhoZScorePoint? nearest;
    double minDiff = double.infinity;
    for (final p in _zData!) {
      final diff = (p.day - xNative).abs();
      if (diff < minDiff) {
        minDiff = diff;
        nearest = p;
      }
    }
    if (nearest == null) return;

    String band;
    Color color;
    String zone;

    if (y < nearest.sd3neg) {
      band = 'Below −3 SD';
      color = const Color(0xFFB71C1C);
      zone = 'below3';
    } else if (y < nearest.sd2neg) {
      band = 'Between −3 SD and −2 SD';
      color = const Color(0xFFF57C00);
      zone = 'neg2to3';
    } else if (y < nearest.sd0) {
      band = 'Between −2 SD and Median (0)';
      color = const Color(0xFF2E7D32);
      zone = 'neg2to0';
    } else if (y < nearest.sd2) {
      band = 'Between Median (0) and +2 SD';
      color = const Color(0xFF2E7D32);
      zone = '0to2';
    } else if (y < nearest.sd3) {
      band = 'Between +2 SD and +3 SD';
      color = const Color(0xFFF57C00);
      zone = '2to3';
    } else {
      band = 'Above +3 SD';
      color = const Color(0xFFB71C1C);
      zone = 'above3';
    }

    setState(() {
      _userX = xDisplay;
      _userY = y;
      _resultBand = band;
      _resultColor = color;
      _resultInterpretation = _sdInterpretation(zone);
      _hasResult = true;
    });
  }

  String _sdInterpretation(String zone) {
    switch (widget.chartType) {
      case 'wfa':
        if (zone == 'below3') return 'Severely underweight';
        if (zone == 'neg2to3') return 'Underweight';
        if (zone == 'above3') return 'Overweight';
        return 'Normal weight';
      case 'lhfa':
        if (zone == 'below3') return 'Severely stunted';
        if (zone == 'neg2to3') return 'Stunted';
        if (zone == 'above3') return 'Tall stature';
        return 'Normal stature';
      case 'wfl':
      case 'wfh':
      case 'bfa':
        if (zone == 'below3') return 'Severely wasted';
        if (zone == 'neg2to3') return 'Wasted';
        if (zone == '2to3') return 'Overweight';
        if (zone == 'above3') return 'Obese';
        return 'Normal';
      case 'hcfa':
        if (zone == 'below3') return 'Severe microcephaly';
        if (zone == 'neg2to3') return 'Microcephaly';
        if (zone == 'above3') return 'Macrocephaly';
        return 'Normal head circumference';
      default:
        return '';
    }
  }

  void _clear() {
    setState(() {
      _ageCtrl.clear();
      _measureCtrl.clear();
      _weightCtrl.clear();
      _heightCtrl.clear();
      _selectedYears  = 0;
      _selectedMonths = 0;
      _userX = null;
      _userY = null;
      _hasResult = false;
      _bmiDisplay = '';
      _resultBand = '';
      _resultInterpretation = '';
    });
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Clamp text scaling to max 1.2 for layout safety
    final media = MediaQuery.of(context);
    final clampedTextScaler =
        media.textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.2);

    return MediaQuery(
      data: media.copyWith(textScaler: clampedTextScaler),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 0,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? _buildError()
                : Column(
                    children: [
                      Expanded(
                        child: LayoutBuilder(
                          builder: (ctx, constraints) {
                            return constraints.maxWidth >= 600
                                ? _buildWideLayout(
                                    constraints, media.size.height)
                                : _buildNarrowLayout(
                                    media.size.height);
                          },
                        ),
                      ),
                      // FIX 1 + 3: Beautiful bottom export bar
                      _buildExportBar(),
                    ],
                  ),
      ),
    );
  }

  Widget _buildError() {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: cs.error, size: 48),
            const SizedBox(height: 12),
            Text('Failed to load WHO data',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface)),
            const SizedBox(height: 8),
            Text(_error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withValues(alpha: 0.6))),
          ],
        ),
      ),
    );
  }

  // FIX 2: Narrow layout (< 600 px)
  Widget _buildNarrowLayout(double screenHeight) {
    final chartH = (screenHeight * 0.45).clamp(200.0, 400.0);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 12),
          _buildModeToggle(),
          const SizedBox(height: 12),
          _buildChart(chartHeight: chartH),
          const SizedBox(height: 4),
          Center(
            child: Text('Pinch to zoom · Drag to pan',
                style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
          ),
          const SizedBox(height: 10),
          _buildLegend(),
          const SizedBox(height: 14),
          _buildInputSection(),
          if (_hasResult) ...[
            const SizedBox(height: 14),
            _buildResultCard(),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // FIX 2: Wide layout (>= 600 px)
  Widget _buildWideLayout(BoxConstraints constraints, double screenHeight) {
    final chartH = (screenHeight * 0.45).clamp(200.0, 400.0);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left 60%: chart + legend
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildChart(chartHeight: chartH),
                    const SizedBox(height: 4),
                    Center(
                      child: Text('Pinch to zoom · Drag to pan',
                          style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
                    ),
                    const SizedBox(height: 10),
                    _buildLegend(),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Right 40%: mode + input + result
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildModeToggle(),
                    const SizedBox(height: 12),
                    _buildInputSection(),
                    if (_hasResult) ...[
                      const SizedBox(height: 14),
                      _buildResultCard(),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ── Header card ────────────────────────────────────────────────────────────

  Widget _buildHeaderCard() {
    final isBoys = widget.gender == 'boys';
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_accentColor, _accentColor.withValues(alpha: 0.75)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(isBoys ? '👦' : '👧',
                style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_genderLabel — $_chartFullName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'WHO Growth Standards 2006 · 0 to 5 years',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Mode toggle ────────────────────────────────────────────────────────────

  Widget _buildModeToggle() {
    return Row(
      children: [
        Expanded(child: _modeBtn('Centile Chart', ChartMode.percentile)),
        const SizedBox(width: 10),
        Expanded(child: _modeBtn('SD Chart', ChartMode.zscore)),
      ],
    );
  }

  Widget _modeBtn(String label, ChartMode mode) {
    final active = _mode == mode;
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => setState(() {
        _mode = mode;
        _hasResult = false;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? cs.primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cs.primary),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: active ? cs.onPrimary : cs.primary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ── Chart ──────────────────────────────────────────────────────────────────

  Widget _buildChart({required double chartHeight}) {
    final pSampled = _pData != null
        ? _sampled(_pData!, (p) => p.day)
        : <WhoPercentilePoint>[];
    final zSampled = _zData != null
        ? _sampled(_zData!, (p) => p.day)
        : <WhoZScorePoint>[];

    final chartLines = _mode == ChartMode.percentile
        ? _buildPercentileLines(pSampled)
        : _buildZScoreLines(zSampled);

    final allY = chartLines
        .expand((l) => l.spots.map((s) => s.y))
        .toList();
    if (allY.isEmpty) {
      return SizedBox(
          height: chartHeight,
          child: const Center(child: CircularProgressIndicator()));
    }

    final minY = allY.reduce((a, b) => a < b ? a : b);
    final maxY = allY.reduce((a, b) => a > b ? a : b);
    final yPad = (maxY - minY) * 0.10;
    final gridH = _computeGridInterval(minY, maxY);

    double minX;
    double maxX;
    if (_isAgeBased) {
      minX = 0;
      maxX = 60;
    } else {
      final xs =
          chartLines.expand((l) => l.spots.map((s) => s.x)).toList();
      minX = xs.isNotEmpty ? xs.reduce((a, b) => a < b ? a : b) : 0;
      maxX = xs.isNotEmpty ? xs.reduce((a, b) => a > b ? a : b) : 120;
    }

    final allLines = [...chartLines];
    if (_hasResult && _userX != null && _userY != null) {
      allLines.add(_patientDotBar(_userX!, _userY!));
    }

    return RepaintBoundary(
      key: _chartKey,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          color: _bgTint.withValues(alpha: 0.35),
          padding: const EdgeInsets.fromLTRB(4, 16, 16, 8),
          child: SizedBox(
            height: chartHeight,
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4.0,
              child: LineChart(
                LineChartData(
                  minX: minX,
                  maxX: maxX,
                  minY: minY - yPad,
                  maxY: maxY + yPad,
                  clipData: const FlClipData.all(),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    horizontalInterval: gridH,
                    verticalInterval:
                        _isAgeBased ? 6 : (maxX - minX) / 8,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                      strokeWidth: 0.8,
                      dashArray: [4, 4],
                    ),
                    getDrawingVerticalLine: (_) => FlLine(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                      strokeWidth: 0.8,
                      dashArray: [4, 4],
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1),
                  ),
                  extraLinesData: _isLhfa
                      ? ExtraLinesData(
                          verticalLines: [
                            VerticalLine(
                              x: 24,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              strokeWidth: 1.5,
                              dashArray: [5, 4],
                              label: VerticalLineLabel(
                                show: true,
                                labelResolver: (_) =>
                                    'Length|Height',
                                style: TextStyle(
                                    fontSize: 8,
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                                alignment: Alignment.topRight,
                              ),
                            ),
                          ],
                        )
                      : null,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: gridH,
                        getTitlesWidget: (val, _) => Text(
                          val.toStringAsFixed(1),
                          style: TextStyle(
                              fontSize: 9,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text(
                        _xAxisLabel,
                        style: TextStyle(
                            fontSize: 9,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: _isAgeBased
                            ? 6
                            : (maxX - minX) / 8,
                        getTitlesWidget: (val, _) {
                          if (_isAgeBased) {
                            const ticks = [
                              0, 6, 12, 18, 24, 30, 36, 42, 48, 54, 60
                            ];
                            if (!ticks.contains(val.round())) {
                              return const SizedBox.shrink();
                            }
                            return Text(val.round().toString(),
                                style: TextStyle(
                                    fontSize: 9,
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)));
                          }
                          return Text(val.toStringAsFixed(0),
                              style: TextStyle(
                                  fontSize: 9,
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)));
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (spots) {
                        return spots.map((spot) {
                          final xStr = _isAgeBased
                              ? '${spot.x.toStringAsFixed(1)} mo'
                              : '${spot.x.toStringAsFixed(1)} cm';
                          return LineTooltipItem(
                            '$xStr\n${spot.y.toStringAsFixed(2)}',
                            const TextStyle(
                                fontSize: 11, color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: allLines,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> _buildPercentileLines(
      List<WhoPercentilePoint> pts) {
    List<FlSpot> spots(double Function(WhoPercentilePoint) fn) =>
        pts.map((pt) => FlSpot(_toChartX(pt.day), fn(pt))).toList();

    return [
      _refLine(spots((pt) => pt.p3),  _p3Color,  dashed: true),
      _refLine(spots((pt) => pt.p10), _p10Color, dashed: true),
      _refLine(spots((pt) => pt.p25), _p25Color, dashed: true),
      _refLine(spots((pt) => pt.p50), _p50Color, width: 2.5),
      _refLine(spots((pt) => pt.p75), _p75Color, dashed: true),
      _refLine(spots((pt) => pt.p90), _p90Color, dashed: true),
      _refLine(spots((pt) => pt.p97), _p97Color, dashed: true),
    ];
  }

  List<LineChartBarData> _buildZScoreLines(List<WhoZScorePoint> pts) {
    List<FlSpot> spots(double Function(WhoZScorePoint) fn) =>
        pts.map((pt) => FlSpot(_toChartX(pt.day), fn(pt))).toList();

    return [
      _refLine(spots((pt) => pt.sd3neg), _sd3nColor, dashed: true),
      _refLine(spots((pt) => pt.sd2neg), _sd2nColor, dashed: true),
      _refLine(spots((pt) => pt.sd0),    _sd0Color,  width: 2.5),
      _refLine(spots((pt) => pt.sd2),    _sd2Color,  dashed: true),
      _refLine(spots((pt) => pt.sd3),    _sd3Color,  dashed: true),
    ];
  }

  LineChartBarData _refLine(List<FlSpot> spots, Color color,
      {double width = 1.5, bool dashed = false}) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: width,
      dotData: const FlDotData(show: false),
      dashArray: dashed ? [4, 3] : null,
    );
  }

  LineChartBarData _patientDotBar(double xDisplay, double y) {
    return LineChartBarData(
      spots: [FlSpot(xDisplay, y)],
      isCurved: false,
      color: _accentColor,
      barWidth: 0,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, xIdx, barData, barIdx) =>
            FlDotCirclePainter(
          radius: 7,
          color: _accentColor,
          strokeWidth: 2.5,
          strokeColor: Colors.white,
        ),
      ),
    );
  }

  // ── Legend ─────────────────────────────────────────────────────────────────

  Widget _buildLegend() {
    final items = _mode == ChartMode.percentile
        ? [
            _LegendItem('3rd',  _p3Color,  dashed: true),
            _LegendItem('10th', _p10Color, dashed: true),
            _LegendItem('25th', _p25Color, dashed: true),
            _LegendItem('50th', _p50Color),
            _LegendItem('75th', _p75Color, dashed: true),
            _LegendItem('90th', _p90Color, dashed: true),
            _LegendItem('97th', _p97Color, dashed: true),
          ]
        : [
            _LegendItem('−3 SD',      _sd3nColor, dashed: true),
            _LegendItem('−2 SD',      _sd2nColor, dashed: true),
            _LegendItem('0 (Median)', _sd0Color),
            _LegendItem('+2 SD',      _sd2Color,  dashed: true),
            _LegendItem('+3 SD',      _sd3Color,  dashed: true),
          ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items
            .map((item) => Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: _legendTile(item),
                ))
            .toList(),
      ),
    );
  }

  Widget _legendTile(_LegendItem item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 22,
          height: 3,
          child: item.dashed
              ? Row(
                  children: List.generate(
                    3,
                    (i) => Expanded(
                      child: Container(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 1),
                        color: item.color,
                      ),
                    ),
                  ),
                )
              : Container(color: item.color),
        ),
        const SizedBox(width: 5),
        Text(item.label,
            style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
      ],
    );
  }

  // ── Input section ──────────────────────────────────────────────────────────

  Widget _buildInputSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Plot Patient',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _accentColor)),
            const SizedBox(height: 12),

            if (_isAgeBased) ...[
              _buildAgeInputSection(),
              const SizedBox(height: 10),
            ],

            if (_isBfa) ...[
              Row(children: [
                Expanded(
                    child: _inputField(
                        controller: _weightCtrl,
                        label: 'Weight (kg)',
                        hint: 'e.g. 7.5')),
                const SizedBox(width: 10),
                Expanded(
                    child: _inputField(
                        controller: _heightCtrl,
                        label: 'Height (cm)',
                        hint: 'e.g. 65')),
              ]),
              if (_bmiDisplay.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _accentColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(_bmiDisplay,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _accentColor)),
                ),
              ],
            ] else if (!_isAgeBased) ...[
              _inputField(
                  controller: _measureCtrl,
                  label: _xAxisLabel,
                  hint: widget.chartType == 'wfl'
                      ? 'e.g. 75'
                      : 'e.g. 90'),
              const SizedBox(height: 10),
              _inputField(
                  controller: _weightCtrl,
                  label: 'Weight (kg)',
                  hint: 'e.g. 9.5'),
            ] else ...[
              _inputField(
                  controller: _measureCtrl,
                  label: _measureLabel,
                  hint: _measureHint),
            ],

            const SizedBox(height: 14),
            Row(children: [
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Plot on Chart',
                      style: TextStyle(fontSize: 14)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: _clear,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _accentColor,
                    side: BorderSide(color: _accentColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Clear',
                      style: TextStyle(fontSize: 14)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Expanded(
              child: _ageSegBtn(
                  'Years & Months', AgeInputMode.yearsMonths)),
          const SizedBox(width: 8),
          Expanded(
              child:
                  _ageSegBtn('Decimal Months', AgeInputMode.decimal)),
        ]),
        const SizedBox(height: 10),
        if (_ageInputMode == AgeInputMode.yearsMonths) ...[
          Row(children: [
            Expanded(
              child: _dropdownField<int>(
                label: 'Years',
                value: _selectedYears,
                items: List.generate(6, (i) => i),
                itemLabel: (v) => '$v yr',
                onChanged: (v) {
                  if (v != null) setState(() => _selectedYears = v);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _dropdownField<int>(
                label: 'Months',
                value: _selectedMonths,
                items: List.generate(12, (i) => i),
                itemLabel: (v) => '$v mo',
                onChanged: (v) {
                  if (v != null) setState(() => _selectedMonths = v);
                },
              ),
            ),
          ]),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Age: $_selectedYears years $_selectedMonths months'
              ' (${_ageMonthsTotal.toStringAsFixed(1)} months total)',
              style: TextStyle(
                  fontSize: 12,
                  color: _accentColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ] else ...[
          _inputField(
              controller: _ageCtrl,
              label: 'Age (months)',
              hint: 'e.g. 18.5'),
          const SizedBox(height: 2),
          Text('Enter age directly in months',
              style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
        ],
      ],
    );
  }

  Widget _ageSegBtn(String label, AgeInputMode mode) {
    final active = _ageInputMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _ageInputMode = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: active ? _accentColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: _accentColor),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : _accentColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _dropdownField<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) itemLabel,
    required void Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 11, color: _accentColor)),
        const SizedBox(height: 4),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<T>(
            value: value,
            items: items
                .map((v) => DropdownMenuItem<T>(
                      value: v,
                      child: Text(itemLabel(v),
                          style:
                              const TextStyle(fontSize: 14)),
                    ))
                .toList(),
            onChanged: onChanged,
            underline: const SizedBox.shrink(),
            isExpanded: true,
            isDense: true,
          ),
        ),
      ],
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(fontSize: 12, color: _accentColor),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _accentColor),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        isDense: true,
      ),
    );
  }

  // ── Result card ────────────────────────────────────────────────────────────

  Widget _buildResultCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            color: _resultColor.withValues(alpha: 0.4)),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _resultColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _resultColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.show_chart,
                      color: _resultColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(_resultBand,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _resultColor)),
                ),
              ],
            ),
            if (_resultInterpretation.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _resultColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_resultInterpretation,
                    style: TextStyle(
                        fontSize: 13,
                        color: _resultColor,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── FIX 1 + 3: Beautiful bottom export bar ────────────────────────────────

  Widget _buildExportBar() {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primary,
            cs.primary.withValues(alpha: 0.88),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Chart info
          Text(
            '$_genderLabel — $_chartFullName',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          const Text(
            'WHO Growth Standards 2006',
            style: TextStyle(
                color: Colors.white60, fontSize: 11),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Buttons
          Row(children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _exportPdf,
                icon: const Icon(Icons.picture_as_pdf_outlined,
                    size: 18),
                label: const Text('Export PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.onPrimary,
                  foregroundColor: cs.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 11),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _exportScreenshot,
                icon: const Icon(Icons.camera_alt_outlined,
                    size: 18),
                label: const Text('Screenshot'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side:
                      const BorderSide(color: Colors.white54),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 11),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          Text(
            'PDF opens print dialog · Screenshot saves chart as PDF',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _LegendItem {
  final String label;
  final Color color;
  final bool dashed;

  const _LegendItem(this.label, this.color, {this.dashed = false});
}
