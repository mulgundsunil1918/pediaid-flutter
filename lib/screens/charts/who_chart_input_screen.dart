// =============================================================================
// screens/charts/who_chart_input_screen.dart
//
// The single IAP-style entry point for the WHO 0–5 charts. Instead of making
// the user pick a chart type first, they enter the child's details once —
// gender, age, height, weight (+ optional head circumference and the extra
// anthropometry) — and tap Plot. WhoChartResultsScreen then draws every
// applicable WHO chart (centile AND SD) from that one set of numbers.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'who_chart_screen.dart' show WhoChildInput;
import 'who_chart_results_screen.dart';

const Color _boyBlue = Color(0xFF1565C0);
const Color _girlPink = Color(0xFFAD1457);

class WhoChartInputScreen extends StatefulWidget {
  const WhoChartInputScreen({super.key});

  @override
  State<WhoChartInputScreen> createState() => _WhoChartInputScreenState();
}

class _WhoChartInputScreenState extends State<WhoChartInputScreen> {
  String _gender = 'boys';
  bool _showExtra = false;

  final _years = TextEditingController(text: '2');
  final _months = TextEditingController(text: '0');
  final _height = TextEditingController();
  final _weight = TextEditingController();
  final _hc = TextEditingController();
  final _muac = TextEditingController();
  final _triceps = TextEditingController();
  final _subscap = TextEditingController();

  Color get _accent => _gender == 'boys' ? _boyBlue : _girlPink;

  @override
  void dispose() {
    for (final c in [
      _years,
      _months,
      _height,
      _weight,
      _hc,
      _muac,
      _triceps,
      _subscap,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double? _parse(TextEditingController c) =>
      c.text.trim().isEmpty ? null : double.tryParse(c.text.trim());

  void _plot() {
    final years = int.tryParse(_years.text.trim()) ?? 0;
    final months = int.tryParse(_months.text.trim()) ?? 0;
    final ageMonths = (years * 12 + months).toDouble();

    if (ageMonths > 60) {
      _toast('WHO 0–5 charts cover up to 60 months (5 years).');
      return;
    }
    if (_parse(_weight) == null && _parse(_height) == null) {
      _toast('Enter at least weight or height to plot a point.');
      return;
    }

    final child = WhoChildInput(
      ageMonths: ageMonths,
      weightKg: _parse(_weight),
      heightCm: _parse(_height),
      hcCm: _parse(_hc),
      muacCm: _parse(_muac),
      tricepsMm: _parse(_triceps),
      subscapularMm: _parse(_subscap),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WhoChartResultsScreen(gender: _gender, child: child),
      ),
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('WHO Growth Charts 0–5 Years'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Child Growth Assessment',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _accent)),
            const SizedBox(height: 4),
            Text(
              'Weight · Height · BMI · Head circumference — WHO Standards 2006',
              style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 18),

            _label('GENDER'),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _genderBtn('boys', '👦 Boy', _boyBlue)),
              const SizedBox(width: 10),
              Expanded(child: _genderBtn('girls', '👧 Girl', _girlPink)),
            ]),
            const SizedBox(height: 18),

            _label("CHILD'S DETAILS"),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: _stepper('Age — Years', _years,
                    step: 1, min: 0, max: 5, decimals: 0),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _stepper('Age — Months', _months,
                    step: 1, min: 0, max: 11, decimals: 0, hint: '0–11'),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: _stepper('Height / Length (cm)', _height,
                    step: 0.5, min: 30, max: 130, decimals: 1),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _stepper('Weight (kg)', _weight,
                    step: 0.1, min: 0, max: 40, decimals: 1),
              ),
            ]),
            const SizedBox(height: 12),
            _stepper('Head Circumference (cm)', _hc,
                step: 0.1, min: 20, max: 60, decimals: 1),

            const SizedBox(height: 10),
            // ── Optional extras ──
            Theme(
              data: Theme.of(context)
                  .copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(top: 4, bottom: 8),
                initiallyExpanded: _showExtra,
                onExpansionChanged: (v) => setState(() => _showExtra = v),
                title: Text('Additional measurements (optional)',
                    style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: _accent)),
                subtitle: Text('For arm circumference & skinfold charts',
                    style: TextStyle(
                        fontSize: 11.5,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.55))),
                children: [
                  Row(children: [
                    Expanded(
                      child: _stepper('Arm circ. — MUAC (cm)', _muac,
                          step: 0.1, min: 5, max: 30, decimals: 1),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _stepper('Triceps skinfold (mm)', _triceps,
                          step: 0.1, min: 2, max: 40, decimals: 1),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _stepper('Subscapular skinfold (mm)', _subscap,
                      step: 0.1, min: 2, max: 40, decimals: 1),
                ],
              ),
            ),

            const SizedBox(height: 18),
            SizedBox(
              height: 54,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: _accent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _plot,
                icon: const Text('📊', style: TextStyle(fontSize: 18)),
                label: const Text('Plot Growth Charts',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Leave a measurement blank to see its chart as reference curves only.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11.5,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)));

  Widget _genderBtn(String value, String label, Color color) {
    final active = _gender == value;
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? color : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: active ? color : color.withValues(alpha: 0.35),
              width: 1.5),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: active ? Colors.white : color)),
      ),
    );
  }

  Widget _stepper(
    String label,
    TextEditingController ctrl, {
    required double step,
    required double min,
    required double max,
    required int decimals,
    String? hint,
  }) {
    void bump(double delta) {
      final cur = double.tryParse(ctrl.text.trim()) ?? min;
      var next = (cur + delta).clamp(min, max);
      // Snap to a clean multiple of the step to avoid float drift.
      next = (next / step).round() * step;
      ctrl.text =
          decimals == 0 ? next.toStringAsFixed(0) : next.toStringAsFixed(decimals);
      setState(() {});
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.55))),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: _accent.withValues(alpha: 0.3), width: 1.2),
          ),
          child: Row(
            children: [
              _stepBtn(Icons.remove, () => bump(-step)),
              Expanded(
                child: TextField(
                  controller: ctrl,
                  textAlign: TextAlign.center,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.4)),
                  ),
                ),
              ),
              _stepBtn(Icons.add, () => bump(step)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepBtn(IconData icon, VoidCallback onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Icon(icon, size: 20, color: _accent),
        ),
      );
}
