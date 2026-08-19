// =============================================================================
// calculators/converter_calculators.dart
//
// Two dropdown-driven converters that don't fit the numeric SimpleCalcScaffold:
//   • SteroidConverter  — glucocorticoid dose equivalence
//   • UnitConverter     — common clinical unit / SI conversions
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../scores/adaptive_color.dart';

const _drug = Color(0xFF00838F);
const _conv = Color(0xFF455A64);

// ── Steroid equivalence ──────────────────────────────────────────────────────

class SteroidConverter extends StatefulWidget {
  const SteroidConverter({super.key});
  @override
  State<SteroidConverter> createState() => _SteroidConverterState();
}

class _SteroidConverterState extends State<SteroidConverter> {
  // Approximate equivalent anti-inflammatory (glucocorticoid) doses, in mg.
  static const Map<String, double> _equiv = {
    'Hydrocortisone': 20,
    'Cortisone': 25,
    'Prednisone': 5,
    'Prednisolone': 5,
    'Methylprednisolone': 4,
    'Triamcinolone': 4,
    'Dexamethasone': 0.75,
    'Betamethasone': 0.6,
  };

  String _from = 'Prednisolone';
  final _dose = TextEditingController(text: '5');

  @override
  void dispose() {
    _dose.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dose = double.tryParse(_dose.text.trim());
    final srcEquiv = _equiv[_from]!;
    // Accent drawn as text/border needs the dark-mode lift.
    final ink = adaptInk(context, _drug);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Steroid Converter',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        backgroundColor: _drug,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Equivalent glucocorticoid (anti-inflammatory) doses.',
                style: TextStyle(
                    fontSize: 13, color: cs.onSurface.withValues(alpha: 0.6))),
            const SizedBox(height: 16),
            _label('FROM', cs),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ink.withValues(alpha: 0.35)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _from,
                  items: _equiv.keys
                      .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                      .toList(),
                  onChanged: (v) => setState(() => _from = v ?? _from),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _label('DOSE (mg)', cs),
            const SizedBox(height: 6),
            TextField(
              controller: _dose,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
              ],
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                isDense: true,
                suffixText: 'mg',
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ink.withValues(alpha: 0.35))),
              ),
            ),
            const SizedBox(height: 20),
            if (dose != null && dose > 0) ...[
              Text('EQUIVALENT DOSES',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: ink)),
              const SizedBox(height: 8),
              ..._equiv.entries.map((e) {
                final eq = dose * (e.value / srcEquiv);
                final isSource = e.key == _from;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSource
                        ? _drug.withValues(alpha: 0.10)
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: ink.withValues(alpha: isSource ? 0.55 : 0.22)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(e.key,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSource
                                    ? FontWeight.w800
                                    : FontWeight.w500)),
                      ),
                      const SizedBox(width: 10),
                      Text('${_fmt(eq)} mg',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: ink)),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 14),
              _note(
                'Potencies are anti-inflammatory (glucocorticoid) equivalents only. '
                'Mineralocorticoid effect and duration of action differ — these figures are NOT for physiologic/stress replacement or fludrocortisone. Verify before prescribing.',
                cs,
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _fmt(double v) =>
      v >= 10 ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
}

// ── Unit / SI converter ──────────────────────────────────────────────────────

class _Conv {
  final String name;
  final String a; // unit A
  final String b; // unit B
  final double factor; // b = a × factor
  const _Conv(this.name, this.a, this.b, this.factor);
}

class UnitConverter extends StatefulWidget {
  const UnitConverter({super.key});
  @override
  State<UnitConverter> createState() => _UnitConverterState();
}

class _UnitConverterState extends State<UnitConverter> {
  // Simple linear conversions (b = a × factor). Temperature handled separately.
  static const List<_Conv> _convs = [
    _Conv('Length', 'cm', 'inch', 0.393701),
    _Conv('Weight', 'kg', 'lb', 2.204623),
    _Conv('Glucose', 'mg/dL', 'mmol/L', 1 / 18.0182),
    _Conv('Creatinine', 'mg/dL', 'µmol/L', 88.42),
    _Conv('Bilirubin', 'mg/dL', 'µmol/L', 17.104),
    _Conv('Calcium', 'mg/dL', 'mmol/L', 0.2495),
    _Conv('Urea / BUN', 'BUN mg/dL', 'urea mmol/L', 0.357),
    _Conv('Haemoglobin', 'g/dL', 'g/L', 10),
  ];

  int _idx = 0;
  bool _reversed = false; // false: A→B, true: B→A
  final _value = TextEditingController();

  @override
  void dispose() {
    _value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ink = adaptInk(context, _conv);
    final c = _convs[_idx];
    final input = double.tryParse(_value.text.trim());
    final fromUnit = _reversed ? c.b : c.a;
    final toUnit = _reversed ? c.a : c.b;
    double? out;
    if (input != null) {
      out = _reversed ? input / c.factor : input * c.factor;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Unit Converter',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        backgroundColor: _conv,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Common clinical unit & SI conversions.',
                style: TextStyle(
                    fontSize: 13, color: cs.onSurface.withValues(alpha: 0.6))),
            const SizedBox(height: 16),
            _label('QUANTITY', cs),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ink.withValues(alpha: 0.35)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: _idx,
                  items: [
                    for (var i = 0; i < _convs.length; i++)
                      DropdownMenuItem(
                          value: i,
                          child: Text(
                              '${_convs[i].name}  (${_convs[i].a} ↔ ${_convs[i].b})')),
                  ],
                  onChanged: (v) => setState(() => _idx = v ?? _idx),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _value,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                    ],
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: 'Value',
                      suffixText: fromUnit,
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: ink.withValues(alpha: 0.35))),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Swap direction',
                  onPressed: () => setState(() => _reversed = !_reversed),
                  icon: const Icon(Icons.swap_horiz_rounded),
                  color: ink,
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (out != null)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: ink.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ink.withValues(alpha: 0.45)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('${_value.text} $fromUnit  =',
                        style: TextStyle(
                            fontSize: 14,
                            color: cs.onSurface.withValues(alpha: 0.7))),
                    ),
                    const SizedBox(width: 10),
                    Text('${_fmt(out)} $toUnit',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: ink)),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            // Temperature is non-linear, so give it its own always-on tool.
            const _TempConverter(),
          ],
        ),
      ),
    );
  }

  static String _fmt(double v) {
    if (v.abs() >= 100) return v.toStringAsFixed(1);
    if (v.abs() >= 1) return v.toStringAsFixed(2);
    return v.toStringAsFixed(3);
  }
}

class _TempConverter extends StatefulWidget {
  const _TempConverter();
  @override
  State<_TempConverter> createState() => _TempConverterState();
}

class _TempConverterState extends State<_TempConverter> {
  final _c = TextEditingController();
  final _f = TextEditingController();

  @override
  void dispose() {
    _c.dispose();
    _f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TEMPERATURE',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: adaptInk(context, _conv))),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _c,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                ],
                onChanged: (t) {
                  final v = double.tryParse(t);
                  _f.text = v == null ? '' : (v * 9 / 5 + 32).toStringAsFixed(1);
                },
                decoration: const InputDecoration(
                    labelText: '°C', border: OutlineInputBorder()),
              ),
            ),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('=')),
            Expanded(
              child: TextField(
                controller: _f,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                ],
                onChanged: (t) {
                  final v = double.tryParse(t);
                  _c.text =
                      v == null ? '' : ((v - 32) * 5 / 9).toStringAsFixed(1);
                },
                decoration: const InputDecoration(
                    labelText: '°F', border: OutlineInputBorder()),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

// ── shared bits ──────────────────────────────────────────────────────────────

Widget _label(String t, ColorScheme cs) => Text(t,
    style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: cs.onSurface.withValues(alpha: 0.55)));

Widget _note(String t, ColorScheme cs) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(t,
          style: TextStyle(
              fontSize: 12, height: 1.45, color: cs.onSurface.withValues(alpha: 0.75))),
    );
