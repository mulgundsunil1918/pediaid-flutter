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
  FentonSex _sex              = FentonSex.male;
  FentonParameter _param      = FentonParameter.weight;
  final _gaWeeksCtrl          = TextEditingController();
  final _gaDaysCtrl           = TextEditingController();
  final _valCtrl              = TextEditingController();
  final _formKey              = GlobalKey<FormState>();

  // ── Result ───────────────────────────────────────────────────────────────────
  FentonResult? _result;
  double? _plotGa;
  double? _plotValue;
  String? _gaError;
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
    _valCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  List<FentonDataPoint> get _dataPoints {
    if (_data == null) return [];
    final g = _sex == FentonSex.male ? _data!.male : _data!.female;
    return switch (_param) {
      FentonParameter.weight            => g.weight,
      FentonParameter.length            => g.length,
      FentonParameter.headCircumference => g.headCircumference,
    };
  }

  String get _paramLabel => switch (_param) {
        FentonParameter.weight            => 'Weight',
        FentonParameter.length            => 'Length',
        FentonParameter.headCircumference => 'Head Circumference',
      };

  String get _unit => _param == FentonParameter.weight ? 'kg' : 'cm';

  void _calculate() {
    setState(() { _gaError = null; _result = null; _plotGa = null; _plotValue = null; });
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final weeks = int.tryParse(_gaWeeksCtrl.text.trim());
    final days  = int.tryParse(_gaDaysCtrl.text.trim()) ?? 0;
    final val   = double.tryParse(_valCtrl.text.trim());

    if (weeks == null || val == null) return;

    if (weeks < 22 || weeks > 50) {
      setState(() => _gaError = 'Weeks must be between 22 and 50');
      return;
    }

    final ga = weeks + days / 7.0;

    final res = FentonCalculator.calculate(
      dataPoints: _dataPoints,
      ga: ga,
      value: val,
      parameter: _param,
    );

    setState(() {
      _result    = res;
      _plotGa    = ga;
      _plotValue = val;
      _gaLabel   = days > 0 ? '${weeks}w ${days}d' : '${weeks}w 0d';
    });
  }

  void _reset() {
    _gaWeeksCtrl.clear();
    _gaDaysCtrl.clear();
    _valCtrl.clear();
    setState(() {
      _result    = null;
      _plotGa    = null;
      _plotValue = null;
      _gaError   = null;
      _gaLabel   = '';
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
                    _InputCard(
                      cs: cs,
                      isDark: isDark,
                      sex: _sex,
                      param: _param,
                      gaWeeksCtrl: _gaWeeksCtrl,
                      gaDaysCtrl: _gaDaysCtrl,
                      valCtrl: _valCtrl,
                      formKey: _formKey,
                      unit: _unit,
                      paramLabel: _paramLabel,
                      gaError: _gaError,
                      onSexChanged: (s) => setState(() {
                        _sex = s;
                        _reset();
                      }),
                      onParamChanged: (p) => setState(() {
                        _param = p;
                        _reset();
                      }),
                      onCalculate: _calculate,
                      onReset: _reset,
                    ),
                    const SizedBox(height: 16),

                    // ── Chart ────────────────────────────────────────────────
                    if (_data != null)
                      _ChartCard(
                        cs: cs,
                        isDark: isDark,
                        chartData: _data!,
                        sex: _sex,
                        param: _param,
                        userGa: _plotGa,
                        userValue: _plotValue,
                        paramLabel: _paramLabel,
                        unit: _unit,
                      ),

                    // ── Result ───────────────────────────────────────────────
                    if (_result != null) ...[
                      const SizedBox(height: 16),
                      _ResultCard(
                        cs: cs,
                        result: _result!,
                        paramLabel: _paramLabel,
                        unit: _unit,
                        ga: _plotGa!,
                        gaLabel: _gaLabel,
                        value: _plotValue!,
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

// ── Input card ────────────────────────────────────────────────────────────────

class _InputCard extends StatelessWidget {
  final ColorScheme cs;
  final bool isDark;
  final FentonSex sex;
  final FentonParameter param;
  final TextEditingController gaWeeksCtrl;
  final TextEditingController gaDaysCtrl;
  final TextEditingController valCtrl;
  final GlobalKey<FormState> formKey;
  final String unit;
  final String paramLabel;
  final String? gaError;
  final ValueChanged<FentonSex> onSexChanged;
  final ValueChanged<FentonParameter> onParamChanged;
  final VoidCallback onCalculate;
  final VoidCallback onReset;

  const _InputCard({
    required this.cs,
    required this.isDark,
    required this.sex,
    required this.param,
    required this.gaWeeksCtrl,
    required this.gaDaysCtrl,
    required this.valCtrl,
    required this.formKey,
    required this.unit,
    required this.paramLabel,
    required this.gaError,
    required this.onSexChanged,
    required this.onParamChanged,
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

              // Parameter toggle
              _SectionLabel('Parameter', cs),
              const SizedBox(height: 6),
              _ToggleRow<FentonParameter>(
                options: const [
                  (FentonParameter.weight,            'Weight',  Icons.monitor_weight_outlined),
                  (FentonParameter.length,            'Length',  Icons.straighten),
                  (FentonParameter.headCircumference, 'HC',      Icons.circle_outlined),
                ],
                selected: param,
                primaryColor: cs.primary,
                cs: cs,
                onSelected: onParamChanged,
              ),
              const SizedBox(height: 14),

              // GA section label
              _SectionLabel('Gestational Age', cs),
              const SizedBox(height: 6),

              // GA weeks + days row
              Row(children: [
                Expanded(
                  flex: 5,
                  child: _IntField(
                    controller: gaWeeksCtrl,
                    label: 'Weeks',
                    hint: '22–50',
                    suffix: 'w',
                    cs: cs,
                    extraError: gaError,
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
                  flex: 4,
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
                const SizedBox(width: 10),
                // Measurement value field
                Expanded(
                  flex: 6,
                  child: _NumField(
                    controller: valCtrl,
                    label: paramLabel,
                    hint: unit == 'kg' ? 'e.g. 1.3' : 'e.g. 42',
                    suffix: unit,
                    cs: cs,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (double.tryParse(v.trim()) == null) return 'Invalid';
                      return null;
                    },
                  ),
                ),
              ]),
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
  final FentonParameter param;
  final double? userGa;
  final double? userValue;
  final String paramLabel;
  final String unit;

  const _ChartCard({
    required this.cs,
    required this.isDark,
    required this.chartData,
    required this.sex,
    required this.param,
    required this.userGa,
    required this.userValue,
    required this.paramLabel,
    required this.unit,
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
              parameter: param,
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
              Text('Result',
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
              label: paramLabel,
              value: '$value $unit',
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

  @override
  Widget build(BuildContext context) {
    final isKg = unit == 'kg';
    String fmt(double v) => isKg ? v.toStringAsFixed(2) : v.toStringAsFixed(1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _PctChip('P3',  fmt(p.p3),  const Color(0xFF7C4DFF), cs),
        _PctChip('P10', fmt(p.p10), const Color(0xFF0288D1), cs),
        _PctChip('P50', fmt(p.p50), const Color(0xFF00897B), cs),
        _PctChip('P90', fmt(p.p90), const Color(0xFF0288D1), cs),
        _PctChip('P97', fmt(p.p97), const Color(0xFF7C4DFF), cs),
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
  final String? extraError;
  final FormFieldValidator<String>? validator;

  const _IntField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.suffix,
    required this.cs,
    this.extraError,
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
        errorText: extraError,
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
