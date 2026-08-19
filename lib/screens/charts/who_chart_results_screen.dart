// =============================================================================
// screens/charts/who_chart_results_screen.dart
//
// Output half of the IAP-style WHO flow: the child's measurements are entered
// once on WhoChartInputScreen, and this screen plots them across every WHO
// metric. To stay light, it is TABBED — one tab per parameter, and inside each
// a Centile / SD sub-tab — so only the visible chart is built. The first tab
// renders immediately; the remaining metrics' data is warmed in the background
// so switching tabs is instant. "Save PDF" walks every metric+mode, captures
// each chart, and lays them out one metric per page.
// =============================================================================

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../services/who_data_service.dart';
import '../../widgets/pediaid_loader.dart';
import 'who_chart_screen.dart';

const Color _boyBlue = Color(0xFF1565C0);
const Color _girlPink = Color(0xFFAD1457);

class _MetricDef {
  final String chartType;
  final String title;
  final String short; // tab label
  final String needs; // which measurement plots the point
  final IconData icon;
  const _MetricDef(
    this.chartType,
    this.title,
    this.short,
    this.needs,
    this.icon,
  );
}

class WhoChartResultsScreen extends StatefulWidget {
  final String gender; // 'boys' | 'girls'
  final WhoChildInput child;

  const WhoChartResultsScreen({
    super.key,
    required this.gender,
    required this.child,
  });

  @override
  State<WhoChartResultsScreen> createState() => _WhoChartResultsScreenState();
}

class _WhoChartResultsScreenState extends State<WhoChartResultsScreen>
    with TickerProviderStateMixin {
  late final TabController _tab;
  late final List<_MetricDef> _metrics;

  final Map<String, GlobalKey> _keys = {}; // '$chartType-$tag' -> boundary key
  final Map<int, ChartMode> _mode = {}; // per-metric centile/SD choice
  bool _ready = false; // false while the loader preloads every metric's data
  bool _exporting = false;

  Color get _accent => widget.gender == 'boys' ? _boyBlue : _girlPink;
  String get _genderLabel => widget.gender == 'boys' ? 'Boys' : 'Girls';

  GlobalKey _keyFor(String chartType, String tag) =>
      _keys.putIfAbsent('$chartType-$tag', () => GlobalKey());

  @override
  void initState() {
    super.initState();
    _metrics = _buildMetrics();
    _tab = TabController(length: _metrics.length, vsync: this);
    _prepare();
  }

  List<_MetricDef> _buildMetrics() {
    final c = widget.child;
    final under2 = c.ageMonths < 24;
    return [
      const _MetricDef(
        'wfa',
        'Weight for Age',
        'Weight',
        'weight',
        Icons.monitor_weight,
      ),
      const _MetricDef(
        'lhfa',
        'Length / Height for Age',
        'Height',
        'height',
        Icons.height,
      ),
      const _MetricDef(
        'bfa',
        'BMI for Age',
        'BMI',
        'weight + height',
        Icons.calculate,
      ),
      under2
          ? const _MetricDef(
              'wfl',
              'Weight for Length',
              'Wt / Length',
              'length + weight',
              Icons.straighten,
            )
          : const _MetricDef(
              'wfh',
              'Weight for Height',
              'Wt / Height',
              'height + weight',
              Icons.swap_vert,
            ),
      const _MetricDef(
        'hcfa',
        'Head Circumference for Age',
        'Head Circ',
        'head circumference',
        Icons.circle_outlined,
      ),
      // Additional anthropometry — only when its measurement was entered.
      if (c.muacCm != null)
        const _MetricDef(
          'acfa',
          'Arm Circumference for Age',
          'Arm (MUAC)',
          'arm circumference',
          Icons.fitness_center,
        ),
      if (c.tricepsMm != null)
        const _MetricDef(
          'tsfa',
          'Triceps Skinfold for Age',
          'Triceps',
          'triceps skinfold',
          Icons.compress,
        ),
      if (c.subscapularMm != null)
        const _MetricDef(
          'ssfa',
          'Subscapular Skinfold for Age',
          'Subscap',
          'subscapular skinfold',
          Icons.compress,
        ),
    ];
  }

  // Parse every metric's data behind the branded loader, THEN reveal the whole
  // screen at once. Nothing loads on demand afterwards, so tabs never flash a
  // spinner — the fix for the "still buggy / loads a lot" behaviour.
  Future<void> _prepare() async {
    for (final m in _metrics) {
      if (!mounted) return;
      try {
        await WhoDataService.instance.loadPercentileData(
          m.chartType,
          widget.gender,
        );
        await WhoDataService.instance.loadZScoreData(
          m.chartType,
          widget.gender,
        );
      } catch (_) {}
      await Future<void>.delayed(Duration.zero); // yield so the loader animates
    }
    if (mounted) setState(() => _ready = true);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  // ── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        body: PediAidLoader(message: 'Preparing WHO growth charts'),
      );
    }
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: _accent,
        foregroundColor: Colors.white,
        title: const Text(
          'WHO Growth Charts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Save all as PDF',
            icon: _exporting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.picture_as_pdf_outlined),
            onPressed: _exporting ? null : _exportAllPdf,
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabAlignment: TabAlignment.start,
          tabs: [
            for (final m in _metrics)
              Tab(
                height: 46,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(m.icon, size: 16),
                    const SizedBox(width: 6),
                    Text(m.short),
                  ],
                ),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          _summaryCard(),
          Expanded(
            child: TabBarView(
              controller: _tab,
              physics: const NeverScrollableScrollPhysics(),
              // All panes are built up front (data is already parsed), so
              // switching tabs is instant with nothing loading on demand.
              children: [
                for (var i = 0; i < _metrics.length; i++)
                  _KeepAlive(child: _metricPane(i, _metrics[i])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── One metric pane: sub-tabs (Centile / SD) + the active chart ────────────
  Widget _metricPane(int i, _MetricDef m) {
    final mode = _mode[i] ?? ChartMode.percentile;
    return SingleChildScrollView(
      key: PageStorageKey('pane$i'),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(m.icon, color: _accent, size: 19),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.title,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: _accent,
                      ),
                    ),
                    Text(
                      'Plots ${m.needs}',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _subTabs(i, mode),
          const SizedBox(height: 12),
          // Rebuilds with a new key when the sub-tab flips, so the embedded
          // chart re-plots in the chosen mode (data is cached, so it's quick).
          WhoChartScreen(
            key: ValueKey('${m.chartType}-${_tag(mode)}'),
            chartType: m.chartType,
            gender: widget.gender,
            title: m.title,
            embedded: true,
            forcedMode: mode,
            child: widget.child,
            captureKey: _keyFor(m.chartType, _tag(mode)),
          ),
        ],
      ),
    );
  }

  Widget _subTabs(int i, ChartMode mode) {
    Widget btn(String label, ChartMode m) {
      final active = mode == m;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _mode[i] = m),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? _accent : Colors.transparent,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: active ? Colors.white : _accent.withValues(alpha: 0.9),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          btn('Centile', ChartMode.percentile),
          const SizedBox(width: 4),
          btn('SD (Z-score)', ChartMode.zscore),
        ],
      ),
    );
  }

  String _tag(ChartMode m) => m == ChartMode.percentile ? 'p' : 'z';

  // ── Summary of what was entered ────────────────────────────────────────────
  Widget _summaryCard() {
    final c = widget.child;
    final yrs = c.ageMonths ~/ 12;
    final mos = (c.ageMonths % 12).round();
    String? bmi;
    if (c.weightKg != null && c.heightCm != null && c.heightCm! > 0) {
      final b = c.weightKg! / ((c.heightCm! / 100) * (c.heightCm! / 100));
      bmi = '${b.toStringAsFixed(1)} kg/m²';
    }
    final chips = <String>[
      'Age ${yrs}y ${mos}m',
      if (c.weightKg != null) 'Wt ${_n(c.weightKg!)} kg',
      if (c.heightCm != null) 'Ht ${_n(c.heightCm!)} cm',
      if (bmi != null) 'BMI $bmi',
      if (c.hcCm != null) 'HC ${_n(c.hcCm!)} cm',
      if (c.muacCm != null) 'MUAC ${_n(c.muacCm!)} cm',
      if (c.tricepsMm != null) 'TSF ${_n(c.tricepsMm!)} mm',
      if (c.subscapularMm != null) 'SSF ${_n(c.subscapularMm!)} mm',
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 2),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: _accent.withValues(alpha: 0.06),
          border: Border.all(color: _accent.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            Text(
              widget.gender == 'boys' ? '👦' : '👧',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Wrap(
                spacing: 7,
                runSpacing: 7,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    '$_genderLabel · 0–5y',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: _accent,
                    ),
                  ),
                  for (final ch in chips)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _accent.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        ch,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── PDF: cycle every metric+mode, capture, one metric per page ─────────────
  Future<void> _exportAllPdf() async {
    setState(() => _exporting = true);
    final savedTab = _tab.index;
    final savedModes = Map<int, ChartMode>.from(_mode);
    final shots = <_MetricShots>[];
    try {
      for (var i = 0; i < _metrics.length; i++) {
        final m = _metrics[i];
        _tab.index = i;
        final p = await _showAndCapture(i, ChartMode.percentile, m.chartType);
        final z = await _showAndCapture(i, ChartMode.zscore, m.chartType);
        shots.add(_MetricShots(m.title, p, z));
      }
      // Restore what the user was looking at.
      if (mounted) {
        setState(() {
          _mode.addAll(savedModes);
          _tab.index = savedTab;
        });
      }
      final bytes = await _buildPdf(shots);
      if (mounted) {
        await Printing.layoutPdf(
          name: 'WHO Growth Charts — $_genderLabel',
          onLayout: (_) => bytes,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<Uint8List?> _showAndCapture(
    int i,
    ChartMode mode,
    String chartType,
  ) async {
    if (!mounted) return null;
    setState(() => _mode[i] = mode);
    // Let the chart mount, load (cached) and plot before capturing.
    await Future<void>.delayed(const Duration(milliseconds: 320));
    await WidgetsBinding.instance.endOfFrame;
    final ctx = _keyFor(chartType, _tag(mode)).currentContext;
    final boundary = ctx?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    try {
      final image = await boundary.toImage(pixelRatio: 1.5);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      return data?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  Future<Uint8List> _buildPdf(List<_MetricShots> shots) async {
    final doc = pw.Document();
    const navy = PdfColor(0.10, 0.14, 0.49);

    // ASCII only in PDF text. The package's built-in Helvetica has no glyph
    // for an em dash, so "PediAid — WHO Growth Charts" rendered as a tofu box
    // on every heading. Embedding a Unicode font would mean a runtime download,
    // which this app must work without.
    //
    // MultiPage rather than one Page per metric: charts now flow continuously
    // and pack two metrics to a page instead of leaving half of each page to a
    // Spacer.
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        header: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'PediAid | WHO Growth Charts',
              style: pw.TextStyle(
                fontSize: 15,
                fontWeight: pw.FontWeight.bold,
                color: navy,
              ),
            ),
            pw.Divider(color: navy),
            pw.SizedBox(height: 4),
          ],
        ),
        footer: (ctx) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'WHO Child Growth Standards 2006 - For clinical use only',
              style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
            pw.Text(
              'Page ${ctx.pageNumber} of ${ctx.pagesCount}',
              style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
          ],
        ),
        build: (ctx) => [
          for (final s in shots) ...[
            pw.SizedBox(height: 6),
            pw.Text(
              '$_genderLabel - ${s.title}',
              style: pw.TextStyle(
                fontSize: 13,
                fontWeight: pw.FontWeight.bold,
                color: navy,
              ),
            ),
            pw.SizedBox(height: 8),
            _pdfChart('Centile chart', s.percentile),
            pw.SizedBox(height: 10),
            _pdfChart('SD (Z-score) chart', s.zscore),
            pw.SizedBox(height: 16),
          ],
        ],
      ),
    );
    return doc.save();
  }

  pw.Widget _pdfChart(String label, Uint8List? bytes) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        label,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.grey700,
        ),
      ),
      pw.SizedBox(height: 4),
      if (bytes != null)
        pw.Image(pw.MemoryImage(bytes), height: 250, fit: pw.BoxFit.contain)
      else
        pw.Container(
          height: 120,
          alignment: pw.Alignment.center,
          color: PdfColors.grey200,
          child: pw.Text(
            'Chart unavailable',
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ),
    ],
  );

  static String _n(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();
}

class _MetricShots {
  final String title;
  final Uint8List? percentile;
  final Uint8List? zscore;
  _MetricShots(this.title, this.percentile, this.zscore);
}

/// Keeps a tab's chart alive when it scrolls off-screen so returning to it is
/// instant (no reload flash).
class _KeepAlive extends StatefulWidget {
  final Widget child;
  const _KeepAlive({required this.child});
  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
