import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/fenton_data_loader.dart';
import '../../logic/fenton_calculator.dart';
import 'fenton_chart_widget.dart';

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
  FentonResult? _weightResult; // percentiles here are in kg (native data unit)
  FentonResult? _lengthResult;
  FentonResult? _hcResult;

  double? _plotGa;
  double? _plotWeightG; // entered value, grams (display unit)
  double? _plotLengthCm;
  double? _plotHcCm;

  String? _formError;
  String  _gaLabel = '';

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

  /// The calculator and reference data work in kg for weight (their
  /// published unit) — this converts a kg-based result to the grams the UI
  /// actually shows, without touching the calculator or data files.
  FentonResult _weightResultInGrams(FentonResult kgResult) {
    final p = kgResult.percentiles;
    return FentonResult(
      percentiles: FentonPercentiles(
        p3:  p.p3  * 1000,
        p10: p.p10 * 1000,
        p50: p.p50 * 1000,
        p90: p.p90 * 1000,
        p97: p.p97 * 1000,
      ),
      percentileBand: kgResult.percentileBand,
      classification: kgResult.classification,
    );
  }

  double? get _viewUserValue => switch (_viewParam) {
        // Chart curves are plotted in kg (native data), so the weight point
        // must be converted back from the grams the user typed.
        FentonParameter.weight => _plotWeightG != null ? _plotWeightG! / 1000 : null,
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
            value: weightG / 1000, // grams entered → kg for the calculator
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
                          result: _weightResultInGrams(_weightResult!),
                          paramLabel: 'Weight',
                          unit: 'g',
                          ga: _plotGa!,
                          gaLabel: _gaLabel,
                          value: _plotWeightG!,
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
                        ),
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

            FentonChartWidget(
              chartData: chartData,
              sex: sex,
              parameter: viewParam,
              userGa: userGa,
              userValue: userValue,
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

  const _ResultCard({
    required this.cs,
    required this.result,
    required this.paramLabel,
    required this.unit,
    required this.ga,
    required this.gaLabel,
    required this.value,
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
              Text(paramLabel,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: cs.onSurface)),
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
