import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../data/fenton_data_loader.dart';
import '../../logic/fenton_calculator.dart';
import 'fenton_chart_widget.dart';

/// Standard normal CDF via the Abramowitz & Stegun 7.1.26 approximation
/// (max error ~1.5e-7) — used to turn a value's position between two
/// known percentile anchors into an approximate exact percentile (e.g.
/// "94th") rather than just the P90–P97 band.
double _normalCdf(double z) {
  const a1 = 0.254829592, a2 = -0.284496736, a3 = 1.421413741;
  const a4 = -1.453152027, a5 = 1.061405429, p = 0.3275911;
  final sign = z < 0 ? -1.0 : 1.0;
  final x = z.abs() / sqrt2;
  final t = 1.0 / (1.0 + p * x);
  final y = 1.0 -
      (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * exp(-x * x);
  return 0.5 * (1.0 + sign * y);
}

/// Z-scores for the app's 5 stored percentile anchors.
const _kP3Z = -1.8808, _kP10Z = -1.2816, _kP50Z = 0.0, _kP90Z = 1.2816, _kP97Z = 1.8808;

/// Approximates the patient's exact percentile by finding which two
/// stored anchors (P3/P10/P50/P90/P97) the value falls between and
/// interpolating linearly in value-space between their known Z-scores,
/// then converting that Z back to a percentile. This is a display aid,
/// not a re-derivation of the full LMS curve — it's exact at the 5
/// anchors and a smooth, reasonable estimate between them.
int _approxPercentile(double value, FentonPercentiles p) {
  double z;
  if (value <= p.p3) {
    z = _kP3Z;
  } else if (value <= p.p10) {
    z = _kP3Z + (_kP10Z - _kP3Z) * (value - p.p3) / (p.p10 - p.p3);
  } else if (value <= p.p50) {
    z = _kP10Z + (_kP50Z - _kP10Z) * (value - p.p10) / (p.p50 - p.p10);
  } else if (value <= p.p90) {
    z = _kP50Z + (_kP90Z - _kP50Z) * (value - p.p50) / (p.p90 - p.p50);
  } else if (value <= p.p97) {
    z = _kP90Z + (_kP97Z - _kP90Z) * (value - p.p90) / (p.p97 - p.p90);
  } else {
    z = _kP97Z;
  }
  return (_normalCdf(z) * 100).round().clamp(0, 100);
}

class FentonChartScreen extends StatefulWidget {
  const FentonChartScreen({super.key});

  @override
  State<FentonChartScreen> createState() => _FentonChartScreenState();
}

class _FentonChartScreenState extends State<FentonChartScreen> {
  // ── Data ─────────────────────────────────────────────────────────────────────
  FentonChartData? _data;
  bool _loading = true;

  // ── Inputs ───────────────────────────────────────────────────────────────────
  FentonSex _sex = FentonSex.male;
  // Which chart is currently displayed — independent from which
  // measurements were entered, since weight/length/HC can't share one
  // graph (different units, different y-scales).
  FentonParameter _viewParam = FentonParameter.weight;

  final _gaWeeksCtrl = TextEditingController();
  final _gaDaysCtrl  = TextEditingController();
  final _weightCtrl  = TextEditingController(); // grams
  final _lengthCtrl  = TextEditingController(); // cm
  final _hcCtrl      = TextEditingController(); // cm
  final _formKey     = GlobalKey<FormState>();

  // ── Results — one per parameter, computed together from the same GA ────────
  FentonResult? _weightResult; // percentiles are in grams (native data unit)
  FentonResult? _lengthResult;
  FentonResult? _hcResult;

  double? _plotGa;
  double? _plotWeightG; // entered value, grams (display unit)
  double? _plotLengthCm;
  double? _plotHcCm;

  String? _formError;
  String  _gaLabel = '';

  // Reused for whichever chart is currently shown — combined-PDF export
  // switches _viewParam through all three in turn, capturing after each.
  final GlobalKey _chartKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    FentonDataLoader().load().then((d) {
      if (mounted) setState(() { _data = d; _loading = false; });
    });
  }

  @override
  void dispose() {
    _gaWeeksCtrl.dispose();
    _gaDaysCtrl.dispose();
    _weightCtrl.dispose();
    _lengthCtrl.dispose();
    _hcCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  List<FentonDataPoint> _dataPoints(FentonParameter param) {
    if (_data == null) return [];
    final g = _sex == FentonSex.male ? _data!.male : _data!.female;
    return switch (param) {
      FentonParameter.weight            => g.weight,
      FentonParameter.length            => g.length,
      FentonParameter.headCircumference => g.headCircumference,
    };
  }

  String _paramLabel(FentonParameter p) => switch (p) {
        FentonParameter.weight            => 'Weight',
        FentonParameter.length            => 'Length',
        FentonParameter.headCircumference => 'Head Circumference',
      };

  String _unitFor(FentonParameter p) =>
      p == FentonParameter.weight ? 'g' : 'cm';

  double? get _viewUserValue => switch (_viewParam) {
        FentonParameter.weight => _plotWeightG,
        FentonParameter.length => _plotLengthCm,
        FentonParameter.headCircumference => _plotHcCm,
      };

  void _calculate() {
    setState(() {
      _formError    = null;
      _weightResult = null;
      _lengthResult = null;
      _hcResult     = null;
      _plotGa       = null;
      _plotWeightG  = null;
      _plotLengthCm = null;
      _plotHcCm     = null;
    });
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final weeks = int.tryParse(_gaWeeksCtrl.text.trim());
    final days  = int.tryParse(_gaDaysCtrl.text.trim()) ?? 0;
    if (weeks == null) return;
    if (weeks < 22 || weeks > 50) {
      setState(() => _formError = 'Weeks must be between 22 and 50');
      return;
    }
    final ga = weeks + days / 7.0;

    final weightG  = double.tryParse(_weightCtrl.text.trim());
    final lengthCm = double.tryParse(_lengthCtrl.text.trim());
    final hcCm     = double.tryParse(_hcCtrl.text.trim());

    if (weightG == null && lengthCm == null && hcCm == null) {
      setState(() => _formError = 'Enter at least one measurement');
      return;
    }

    final wRes = weightG != null
        ? FentonCalculator.calculate(
            dataPoints: _dataPoints(FentonParameter.weight),
            ga: ga,
            value: weightG, // reference data is in grams natively now
            parameter: FentonParameter.weight,
          )
        : null;
    final lRes = lengthCm != null
        ? FentonCalculator.calculate(
            dataPoints: _dataPoints(FentonParameter.length),
            ga: ga,
            value: lengthCm,
            parameter: FentonParameter.length,
          )
        : null;
    final hRes = hcCm != null
        ? FentonCalculator.calculate(
            dataPoints: _dataPoints(FentonParameter.headCircumference),
            ga: ga,
            value: hcCm,
            parameter: FentonParameter.headCircumference,
          )
        : null;

    // Show whichever chart actually has a fresh result, preferring the
    // currently-selected tab if it has one.
    FentonParameter nextView = _viewParam;
    final hasCurrentView = switch (_viewParam) {
      FentonParameter.weight => wRes != null,
      FentonParameter.length => lRes != null,
      FentonParameter.headCircumference => hRes != null,
    };
    if (!hasCurrentView) {
      if (wRes != null) {
        nextView = FentonParameter.weight;
      } else if (lRes != null) {
        nextView = FentonParameter.length;
      } else if (hRes != null) {
        nextView = FentonParameter.headCircumference;
      }
    }

    setState(() {
      _weightResult = wRes;
      _lengthResult = lRes;
      _hcResult     = hRes;
      _viewParam    = nextView;
      _plotGa       = ga;
      _plotWeightG  = weightG;
      _plotLengthCm = lengthCm;
      _plotHcCm     = hcCm;
      _gaLabel      = days > 0 ? '${weeks}w ${days}d' : '${weeks}w 0d';
    });
  }

  void _reset() {
    _gaWeeksCtrl.clear();
    _gaDaysCtrl.clear();
    _weightCtrl.clear();
    _lengthCtrl.clear();
    _hcCtrl.clear();
    setState(() {
      _weightResult = null;
      _lengthResult = null;
      _hcResult     = null;
      _plotGa       = null;
      _plotWeightG  = null;
      _plotLengthCm = null;
      _plotHcCm     = null;
      _formError    = null;
      _gaLabel      = '';
    });
  }

  // ── Export ────────────────────────────────────────────────────────────────────

  Future<Uint8List?> _captureChart() async {
    try {
      // Give the chart a frame to finish painting after any setState this
      // capture follows (e.g. switching _viewParam for the combined export).
      await Future.delayed(const Duration(milliseconds: 120));
      final boundary = _chartKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: 1.8);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  void _showLoadingSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text(message),
        ]),
        duration: const Duration(seconds: 20),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  String get _sexLabel => _sex == FentonSex.male ? 'Male' : 'Female';

  /// Exports whichever chart is currently on screen — single parameter,
  /// matching the reference curve + patient point exactly as shown.
  Future<void> _exportCurrentChartPdf() async {
    _showLoadingSnackBar('Generating PDF…');
    try {
      final image = await _captureChart();
      final bytes = await _generateSingleChartPdf(_viewParam, image);
      if (mounted) ScaffoldMessenger.of(context).hideCurrentSnackBar();
      await Printing.layoutPdf(
        name: '$_sexLabel-${_paramLabel(_viewParam)}-Fenton',
        onLayout: (_) => bytes,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  /// Exports all three parameters (weight/length/HC) in one PDF, matching
  /// the layout of the official combined Fenton chart — the whole point
  /// being a single document you can print/save for bedside monitoring
  /// across visits, instead of three separate exports.
  Future<void> _exportCombinedPdf() async {
    _showLoadingSnackBar('Generating combined chart PDF…');
    final originalView = _viewParam;
    final images = <FentonParameter, Uint8List?>{};
    try {
      for (final p in const [
        FentonParameter.weight,
        FentonParameter.length,
        FentonParameter.headCircumference,
      ]) {
        setState(() => _viewParam = p);
        images[p] = await _captureChart();
      }
      final bytes = await _generateCombinedPdf(images);
      if (mounted) ScaffoldMessenger.of(context).hideCurrentSnackBar();
      await Printing.layoutPdf(
        name: '$_sexLabel-Fenton-Combined',
        onLayout: (_) => bytes,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _viewParam = originalView);
    }
  }

  FentonResult? _resultFor(FentonParameter p) => switch (p) {
        FentonParameter.weight => _weightResult,
        FentonParameter.length => _lengthResult,
        FentonParameter.headCircumference => _hcResult,
      };

  double? _plotValueFor(FentonParameter p) => switch (p) {
        FentonParameter.weight => _plotWeightG,
        FentonParameter.length => _plotLengthCm,
        FentonParameter.headCircumference => _plotHcCm,
      };

  pw.Widget _pdfResultBlock(FentonParameter p) {
    final result = _resultFor(p);
    final value = _plotValueFor(p);
    final unit = _unitFor(p);
    const navy = PdfColor.fromInt(0xFF1a237e);
    if (result == null || value == null) {
      return pw.Text('Not measured this visit',
          style: pw.TextStyle(fontSize: 10, color: PdfColors.grey500, fontStyle: pw.FontStyle.italic));
    }
    final pct = _approxPercentile(value, result.percentiles);
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          unit == 'g' ? '${value.toStringAsFixed(0)} $unit' : '$value $unit',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: navy),
        ),
        pw.Text('~$pct%ile  (${result.percentileBand})',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        if (result.classification != null)
          pw.Text(result.classification!,
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: navy)),
      ],
    );
  }

  Future<Uint8List> _generateSingleChartPdf(
      FentonParameter param, Uint8List? imageBytes) async {
    final doc = pw.Document();
    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year}';
    const navy = PdfColor.fromInt(0xFF1a237e);

    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text('PediAid', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: navy)),
                pw.Text('Fenton Preterm Growth Chart', style: pw.TextStyle(fontSize: 13, color: PdfColors.grey700)),
              ]),
              pw.Text(dateStr, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Divider(color: navy),
          pw.SizedBox(height: 10),
 pw.Text('$_sexLabel - ${_paramLabel(param)}',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: navy)),
 pw.Text('Fenton ${_data?.version ?? ''} 3rd-Generation Charts - GA $_gaLabel',
              style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
          pw.SizedBox(height: 14),
          if (imageBytes != null)
            pw.Image(pw.MemoryImage(imageBytes), height: 300, fit: pw.BoxFit.contain)
          else
            pw.Container(
              height: 300,
              color: PdfColors.grey200,
              child: pw.Center(child: pw.Text('Chart image unavailable', style: const pw.TextStyle(fontSize: 12))),
            ),
          pw.SizedBox(height: 14),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400), borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6))),
            child: _pdfResultBlock(param),
          ),
          pw.SizedBox(height: 20),
          pw.Divider(color: PdfColors.grey400),
          pw.SizedBox(height: 4),
 pw.Text('WHO/Fenton reference charts - for clinical use only',
              style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
        ],
      ),
    ));
    return doc.save();
  }

  Future<Uint8List> _generateCombinedPdf(
      Map<FentonParameter, Uint8List?> images) async {
    final doc = pw.Document();
    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year}';
    const navy = PdfColor.fromInt(0xFF1a237e);

    const order = [
      FentonParameter.weight,
      FentonParameter.length,
      FentonParameter.headCircumference,
    ];

    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(28),
      header: (ctx) => ctx.pageNumber == 1
          ? pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text('PediAid', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: navy)),
                    pw.Text('Combined Fenton Preterm Growth Chart', style: pw.TextStyle(fontSize: 13, color: PdfColors.grey700)),
                  ]),
                  pw.Text(dateStr, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Divider(color: navy),
              pw.SizedBox(height: 8),
 pw.Text('$_sexLabel - GA at assessment: $_gaLabel',
                  style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold, color: navy)),
 pw.Text('Fenton ${_data?.version ?? ''} 3rd-Generation Charts - Weight, Length & Head Circumference',
                  style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
              pw.SizedBox(height: 10),
            ])
          : pw.SizedBox(),
      footer: (ctx) => pw.Column(children: [
        pw.Divider(color: PdfColors.grey400, height: 8),
 pw.Text('WHO/Fenton reference charts - for clinical use only - Page ${ctx.pageNumber} of ${ctx.pagesCount}',
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
      ]),
      build: (ctx) => [
        for (final p in order) ...[
          pw.Text(_paramLabel(p), style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: navy)),
          pw.SizedBox(height: 6),
          if (images[p] != null)
            pw.Image(pw.MemoryImage(images[p]!), height: 230, fit: pw.BoxFit.contain)
          else
            pw.Container(
              height: 230,
              color: PdfColors.grey200,
              child: pw.Center(child: pw.Text('Chart unavailable', style: const pw.TextStyle(fontSize: 11))),
            ),
          pw.SizedBox(height: 6),
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400), borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6))),
            child: _pdfResultBlock(p),
          ),
          pw.SizedBox(height: 16),
        ],
      ],
    ));
    return doc.save();
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs    = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fenton Preterm Charts'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              bottom: true,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_data != null) _VersionBanner(cs: cs, version: _data!.version),
                    if (_data != null) const SizedBox(height: 12),

                    _InputCard(
                      cs: cs,
                      sex: _sex,
                      gaWeeksCtrl: _gaWeeksCtrl,
                      gaDaysCtrl: _gaDaysCtrl,
                      weightCtrl: _weightCtrl,
                      lengthCtrl: _lengthCtrl,
                      hcCtrl: _hcCtrl,
                      formKey: _formKey,
                      formError: _formError,
                      onSexChanged: (s) => setState(() {
                        _sex = s;
                        _reset();
                      }),
                      onCalculate: _calculate,
                      onReset: _reset,
                    ),
                    const SizedBox(height: 16),

                    // ── Chart (with a tab to pick which one to view) ─────────
                    if (_data != null)
                      _ChartCard(
                        cs: cs,
                        isDark: isDark,
                        chartKey: _chartKey,
                        chartData: _data!,
                        sex: _sex,
                        viewParam: _viewParam,
                        onViewParamChanged: (p) => setState(() => _viewParam = p),
                        userGa: _plotGa,
                        userValue: _viewUserValue,
                        paramLabel: _paramLabel(_viewParam),
                        unit: _unitFor(_viewParam),
                        hasWeight: _weightResult != null,
                        hasLength: _lengthResult != null,
                        hasHc: _hcResult != null,
                      ),

                    // ── Results — merged, one card per measurement entered ──
                    if (_weightResult != null || _lengthResult != null || _hcResult != null) ...[
                      const SizedBox(height: 16),
                      Text('Results',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface.withValues(alpha: 0.55))),
                      const SizedBox(height: 8),
                      if (_weightResult != null) ...[
                        _ResultCard(
                          cs: cs,
                          result: _weightResult!,
                          paramLabel: 'Weight',
                          unit: 'g',
                          ga: _plotGa!,
                          gaLabel: _gaLabel,
                          value: _plotWeightG!,
                          percentile: _approxPercentile(_plotWeightG!, _weightResult!.percentiles),
                        ),
                        const SizedBox(height: 10),
                      ],
                      if (_lengthResult != null) ...[
                        _ResultCard(
                          cs: cs,
                          result: _lengthResult!,
                          paramLabel: 'Length',
                          unit: 'cm',
                          ga: _plotGa!,
                          gaLabel: _gaLabel,
                          value: _plotLengthCm!,
                          percentile: _approxPercentile(_plotLengthCm!, _lengthResult!.percentiles),
                        ),
                        const SizedBox(height: 10),
                      ],
                      if (_hcResult != null)
                        _ResultCard(
                          cs: cs,
                          result: _hcResult!,
                          paramLabel: 'Head Circumference',
                          unit: 'cm',
                          ga: _plotGa!,
                          gaLabel: _gaLabel,
                          value: _plotHcCm!,
                          percentile: _approxPercentile(_plotHcCm!, _hcResult!.percentiles),
                        ),
                    ],

                    // ── Export ───────────────────────────────────────────────
                    if (_data != null) ...[
                      const SizedBox(height: 16),
                      Row(children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _exportCurrentChartPdf,
                            icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                            label: Text('${_paramLabel(_viewParam)} PDF', style: const TextStyle(fontSize: 12)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: cs.primary,
                              side: BorderSide(color: cs.primary.withValues(alpha: 0.5)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: FilledButton.icon(
                            onPressed: _exportCombinedPdf,
                            icon: const Icon(Icons.picture_as_pdf, size: 16),
                            label: const Text('Combined Chart PDF (Weight+Length+HC)', style: TextStyle(fontSize: 12)),
                            style: FilledButton.styleFrom(
                              backgroundColor: cs.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ]),
                    ],

                    // ── Citation ─────────────────────────────────────────────
                    if (_data != null) ...[
                      const SizedBox(height: 16),
                      _CitationCard(cs: cs, isDark: isDark, citation: _data!.citation, version: _data!.version),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}

// ── Version banner ───────────────────────────────────────────────────────────

class _VersionBanner extends StatelessWidget {
  final ColorScheme cs;
  final String version;
  const _VersionBanner({required this.cs, required this.version});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.primary.withValues(alpha: 0.30)),
      ),
      child: Row(children: [
        Icon(Icons.verified_outlined, size: 16, color: cs.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Fenton $version — 3rd Generation Growth Charts (latest)',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: cs.primary),
          ),
        ),
      ]),
    );
  }
}

// ── Input card ────────────────────────────────────────────────────────────────

class _InputCard extends StatelessWidget {
  final ColorScheme cs;
  final FentonSex sex;
  final TextEditingController gaWeeksCtrl;
  final TextEditingController gaDaysCtrl;
  final TextEditingController weightCtrl;
  final TextEditingController lengthCtrl;
  final TextEditingController hcCtrl;
  final GlobalKey<FormState> formKey;
  final String? formError;
  final ValueChanged<FentonSex> onSexChanged;
  final VoidCallback onCalculate;
  final VoidCallback onReset;

  const _InputCard({
    required this.cs,
    required this.sex,
    required this.gaWeeksCtrl,
    required this.gaDaysCtrl,
    required this.weightCtrl,
    required this.lengthCtrl,
    required this.hcCtrl,
    required this.formKey,
    required this.formError,
    required this.onSexChanged,
    required this.onCalculate,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title row
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.tune, color: cs.primary, size: 20),
                ),
                const SizedBox(width: 10),
                Text('Patient Parameters',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: cs.onSurface)),
              ]),
              const SizedBox(height: 16),

              // Sex toggle
              _SectionLabel('Sex', cs),
              const SizedBox(height: 6),
              _ToggleRow<FentonSex>(
                options: const [
                  (FentonSex.male,   'Male',   Icons.male),
                  (FentonSex.female, 'Female', Icons.female),
                ],
                selected: sex,
                primaryColor: cs.primary,
                cs: cs,
                onSelected: onSexChanged,
              ),
              const SizedBox(height: 14),

              // GA section label
              _SectionLabel('Gestational Age', cs),
              const SizedBox(height: 6),
              Row(children: [
                Expanded(
                  child: _IntField(
                    controller: gaWeeksCtrl,
                    label: 'Weeks',
                    hint: '22–50',
                    suffix: 'w',
                    cs: cs,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      final n = int.tryParse(v.trim());
                      if (n == null) return 'Invalid';
                      if (n < 22 || n > 50) return '22–50';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _IntField(
                    controller: gaDaysCtrl,
                    label: 'Days',
                    hint: '0–6',
                    suffix: 'd',
                    cs: cs,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null; // optional
                      final n = int.tryParse(v.trim());
                      if (n == null) return 'Invalid';
                      if (n < 0 || n > 6) return '0–6';
                      return null;
                    },
                  ),
                ),
              ]),
              const SizedBox(height: 14),

              // All three measurements at once — enter whichever you have.
              _SectionLabel('Measurements (enter any/all)', cs),
              const SizedBox(height: 6),
              _NumField(
                controller: weightCtrl,
                label: 'Weight',
                hint: 'e.g. 2500',
                suffix: 'g',
                cs: cs,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null; // optional
                  if (double.tryParse(v.trim()) == null) return 'Invalid';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _NumField(
                controller: lengthCtrl,
                label: 'Length',
                hint: 'e.g. 42',
                suffix: 'cm',
                cs: cs,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  if (double.tryParse(v.trim()) == null) return 'Invalid';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _NumField(
                controller: hcCtrl,
                label: 'Head Circumference',
                hint: 'e.g. 30',
                suffix: 'cm',
                cs: cs,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  if (double.tryParse(v.trim()) == null) return 'Invalid';
                  return null;
                },
              ),

              if (formError != null) ...[
                const SizedBox(height: 10),
                Text(formError!,
                    style: TextStyle(fontSize: 12, color: cs.error)),
              ],

              const SizedBox(height: 16),

              // Buttons
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReset,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Reset'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cs.onSurface.withValues(alpha: 0.6),
                      side: BorderSide(color: cs.outline.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: onCalculate,
                    icon: const Icon(Icons.show_chart, size: 18),
                    label: const Text('Plot on Chart'),
                    style: FilledButton.styleFrom(
                      backgroundColor: cs.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Chart card ────────────────────────────────────────────────────────────────

class _ChartCard extends StatelessWidget {
  final ColorScheme cs;
  final bool isDark;
  final GlobalKey chartKey;
  final FentonChartData chartData;
  final FentonSex sex;
  final FentonParameter viewParam;
  final ValueChanged<FentonParameter> onViewParamChanged;
  final double? userGa;
  final double? userValue;
  final String paramLabel;
  final String unit;
  final bool hasWeight;
  final bool hasLength;
  final bool hasHc;

  const _ChartCard({
    required this.cs,
    required this.isDark,
    required this.chartKey,
    required this.chartData,
    required this.sex,
    required this.viewParam,
    required this.onViewParamChanged,
    required this.userGa,
    required this.userValue,
    required this.paramLabel,
    required this.unit,
    required this.hasWeight,
    required this.hasLength,
    required this.hasHc,
  });

  @override
  Widget build(BuildContext context) {
    final sexLabel = sex == FentonSex.male ? 'Male' : 'Female';
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Which chart to view — independent of what's been entered.
            _ToggleRow<FentonParameter>(
              options: [
                (FentonParameter.weight, hasWeight ? 'Weight •' : 'Weight', Icons.monitor_weight_outlined),
                (FentonParameter.length, hasLength ? 'Length •' : 'Length', Icons.straighten),
                (FentonParameter.headCircumference, hasHc ? 'HC •' : 'HC', Icons.circle_outlined),
              ],
              selected: viewParam,
              primaryColor: cs.primary,
              cs: cs,
              onSelected: onViewParamChanged,
            ),
            const SizedBox(height: 12),

            // Header
            Row(children: [
              Icon(Icons.monitor_heart_outlined, color: cs.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$paramLabel · $sexLabel ($unit)',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: cs.onSurface),
                ),
              ),
            ]),
            const SizedBox(height: 12),

            RepaintBoundary(
              key: chartKey,
              child: Container(
                color: Theme.of(context).cardColor,
                child: FentonChartWidget(
                  chartData: chartData,
                  sex: sex,
                  parameter: viewParam,
                  userGa: userGa,
                  userValue: userValue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Result card ───────────────────────────────────────────────────────────────

class _ResultCard extends StatelessWidget {
  final ColorScheme cs;
  final FentonResult result;
  final String paramLabel;
  final String unit;
  final double ga;
  final String gaLabel;
  final double value;
  final int percentile;

  const _ResultCard({
    required this.cs,
    required this.result,
    required this.paramLabel,
    required this.unit,
    required this.ga,
    required this.gaLabel,
    required this.value,
    required this.percentile,
  });

  @override
  Widget build(BuildContext context) {
    final band       = result.percentileBand;
    final classify   = result.classification;
    final bandColor  = _bandColor(band);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bandColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.analytics_outlined, color: bandColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(paramLabel,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: cs.onSurface)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: bandColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text('~$percentile%ile',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: bandColor)),
              ),
            ]),
            const SizedBox(height: 14),

            // Percentile band row
            _ResultRow(
              label: 'Percentile Band',
              value: band,
              valueColor: bandColor,
              cs: cs,
            ),
            const SizedBox(height: 8),
            _ResultRow(
              label: 'Gestational Age',
              value: gaLabel.isNotEmpty
                  ? '$gaLabel  (${ga.toStringAsFixed(2)} wks)'
                  : '${ga.toStringAsFixed(2)} wks',
              cs: cs,
            ),
            const SizedBox(height: 8),
            _ResultRow(
              label: 'Measured',
              value: unit == 'g'
                  ? '${value.toStringAsFixed(0)} $unit'
                  : '$value $unit',
              cs: cs,
            ),

            // SGA/AGA/LGA (weight only)
            if (classify != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: _classifyColor(classify).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: _classifyColor(classify).withValues(alpha: 0.35)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Classification',
                        style: TextStyle(
                            fontSize: 13,
                            color: cs.onSurface.withValues(alpha: 0.6))),
                    Row(children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _classifyColor(classify),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$classify — ${_classifyFull(classify)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: _classifyColor(classify)),
                      ),
                    ]),
                  ],
                ),
              ),
            ],

            // All percentile values
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Text('Reference Percentiles at ${gaLabel.isNotEmpty ? gaLabel : '${ga.toStringAsFixed(2)} wks'}',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface.withValues(alpha: 0.45))),
            const SizedBox(height: 8),
            _PercentilesRow(result.percentiles, unit, cs),
          ],
        ),
      ),
    );
  }

  Color _bandColor(String band) {
    if (band.contains('Below P3'))  return const Color(0xFFB71C1C);
    if (band.contains('P3'))        return const Color(0xFFE53935);
    if (band.contains('P10'))       return const Color(0xFF0288D1);
    if (band.contains('P50'))       return const Color(0xFF00897B);
    if (band.contains('P90'))       return const Color(0xFFE65100);
    if (band.contains('Above P97')) return const Color(0xFF6A1B9A);
    return const Color(0xFF00897B);
  }

  Color _classifyColor(String c) {
    if (c == 'SGA') return const Color(0xFFE53935);
    if (c == 'LGA') return const Color(0xFF7B1FA2);
    return const Color(0xFF00897B);
  }

  String _classifyFull(String c) {
    if (c == 'SGA') return 'Small for Gestational Age';
    if (c == 'LGA') return 'Large for Gestational Age';
    return 'Appropriate for Gestational Age';
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final ColorScheme cs;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.cs,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13, color: cs.onSurface.withValues(alpha: 0.6))),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: valueColor ?? cs.onSurface)),
      ],
    );
  }
}

class _PercentilesRow extends StatelessWidget {
  final FentonPercentiles p;
  final String unit;
  final ColorScheme cs;

  const _PercentilesRow(this.p, this.unit, this.cs);

  String _fmt(double v) => switch (unit) {
        'g'  => v.toStringAsFixed(0),
        'kg' => v.toStringAsFixed(2),
        _    => v.toStringAsFixed(1),
      };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _PctChip('P3',  _fmt(p.p3),  const Color(0xFF7C4DFF), cs),
        _PctChip('P10', _fmt(p.p10), const Color(0xFF0288D1), cs),
        _PctChip('P50', _fmt(p.p50), const Color(0xFF00897B), cs),
        _PctChip('P90', _fmt(p.p90), const Color(0xFF0288D1), cs),
        _PctChip('P97', _fmt(p.p97), const Color(0xFF7C4DFF), cs),
      ],
    );
  }
}

class _PctChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final ColorScheme cs;

  const _PctChip(this.label, this.value, this.color, this.cs);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color)),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: cs.onSurface)),
      ],
    );
  }
}

// ── Citation card ─────────────────────────────────────────────────────────────

class _CitationCard extends StatelessWidget {
  final ColorScheme cs;
  final bool isDark;
  final String citation;
  final String version;

  const _CitationCard({
    required this.cs,
    required this.isDark,
    required this.citation,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: isDark ? 0.06 : 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.info_outline,
                size: 14, color: cs.onSurface.withValues(alpha: 0.45)),
            const SizedBox(width: 6),
            Text('Source — Fenton $version',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface.withValues(alpha: 0.5))),
          ]),
          const SizedBox(height: 6),
          Text(
            citation,
            style: TextStyle(
                fontSize: 10.5,
                color: cs.onSurface.withValues(alpha: 0.45),
                height: 1.45),
          ),
        ],
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  final ColorScheme cs;
  const _SectionLabel(this.text, this.cs);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: cs.onSurface.withValues(alpha: 0.55)),
      );
}

class _ToggleRow<T> extends StatelessWidget {
  final List<(T, String, IconData)> options;
  final T selected;
  final Color primaryColor;
  final ColorScheme cs;
  final ValueChanged<T> onSelected;

  const _ToggleRow({
    required this.options,
    required this.selected,
    required this.primaryColor,
    required this.cs,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.map((opt) {
        final (value, label, icon) = opt;
        final isActive = selected == value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: opt == options.last ? 0 : 8,
            ),
            child: GestureDetector(
              onTap: () => onSelected(value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isActive
                      ? primaryColor.withValues(alpha: 0.15)
                      : cs.onSurface.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isActive
                        ? primaryColor.withValues(alpha: 0.6)
                        : cs.outline.withValues(alpha: 0.25),
                    width: isActive ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon,
                        size: 16,
                        color: isActive
                            ? primaryColor
                            : cs.onSurface.withValues(alpha: 0.4)),
                    const SizedBox(width: 5),
                    Text(label,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isActive
                                ? primaryColor
                                : cs.onSurface.withValues(alpha: 0.5))),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Integer-only field (weeks / days) ─────────────────────────────────────────

class _IntField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String suffix;
  final ColorScheme cs;
  final FormFieldValidator<String>? validator;

  const _IntField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.suffix,
    required this.cs,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      validator: validator,
    );
  }
}

class _NumField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String suffix;
  final ColorScheme cs;
  final FormFieldValidator<String>? validator;

  const _NumField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.suffix,
    required this.cs,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      validator: validator,
    );
  }
}
