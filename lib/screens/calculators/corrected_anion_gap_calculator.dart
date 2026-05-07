// =============================================================================
// corrected_anion_gap_calculator.dart
// Corrected AG (for hypoalbuminaemia)
// Source formula: AG + 0.25 × (Normal Albumin − Measured Albumin)   [g/L]
// Equivalent (g/dL):  AG + 2.5 × (Normal − Measured)
// =============================================================================

import 'package:flutter/material.dart';
import 'fluid_electrolyte_shared.dart';

enum _AlbUnit { gPerDL, gPerL }

class CorrectedAnionGapCalculator extends StatefulWidget {
  const CorrectedAnionGapCalculator({super.key});
  @override
  State<CorrectedAnionGapCalculator> createState() =>
      _CorrectedAnionGapCalculatorState();
}

class _CorrectedAnionGapCalculatorState
    extends State<CorrectedAnionGapCalculator> {
  final _ag = TextEditingController();
  final _alb = TextEditingController();
  final _normalAlb = TextEditingController(text: '4.0');
  _AlbUnit _unit = _AlbUnit.gPerDL;
  double? _result;

  @override
  void dispose() {
    _ag.dispose();
    _alb.dispose();
    _normalAlb.dispose();
    super.dispose();
  }

  void _onUnitChanged(_AlbUnit u) {
    setState(() {
      _unit = u;
      _normalAlb.text = u == _AlbUnit.gPerDL ? '4.0' : '40';
    });
  }

  bool get _ready =>
      double.tryParse(_ag.text) != null &&
      double.tryParse(_alb.text) != null &&
      double.tryParse(_normalAlb.text) != null;

  void _compute() {
    final ag = double.parse(_ag.text);
    final alb = double.parse(_alb.text);
    final normal = double.parse(_normalAlb.text);
    final factor = _unit == _AlbUnit.gPerDL ? 2.5 : 0.25;
    setState(() => _result = ag + factor * (normal - alb));
  }

  @override
  Widget build(BuildContext context) {
    return FECalcScaffold(
      title: 'Corrected AG (Albumin)',
      children: [
        FECalcInputCard(
          label: 'Inputs',
          child: Column(children: [
            FECalcNumberField(
                label: 'Measured Anion Gap',
                unit: 'mEq/L',
                hint: 'e.g. 12',
                controller: _ag,
                onChanged: (_) => setState(() {})),
            const FECalcGap(),
            const Text('ALBUMIN UNITS',
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3)),
            const FECalcGap(6),
            SegmentedButton<_AlbUnit>(
              segments: const [
                ButtonSegment(value: _AlbUnit.gPerDL, label: Text('g/dL')),
                ButtonSegment(value: _AlbUnit.gPerL, label: Text('g/L')),
              ],
              selected: {_unit},
              onSelectionChanged: (s) => _onUnitChanged(s.first),
            ),
            const FECalcGap(),
            FECalcNumberField(
                label: 'Measured Albumin',
                unit: _unit == _AlbUnit.gPerDL ? 'g/dL' : 'g/L',
                hint: _unit == _AlbUnit.gPerDL ? 'e.g. 2.0' : 'e.g. 20',
                controller: _alb,
                onChanged: (_) => setState(() {})),
            const FECalcGap(),
            FECalcNumberField(
                label: 'Normal Albumin',
                unit: _unit == _AlbUnit.gPerDL ? 'g/dL' : 'g/L',
                hint: _unit == _AlbUnit.gPerDL ? '4.0' : '40',
                controller: _normalAlb,
                onChanged: (_) => setState(() {})),
          ]),
        ),
        const FECalcGap(16),
        FECalcButton(
          label: 'Calculate Corrected AG',
          icon: Icons.calculate,
          enabled: _ready,
          onPressed: _compute,
        ),
        if (_result != null) ...[
          const FECalcGap(16),
          FECalcResultCard(
            label: 'Corrected anion gap',
            value: _result!.toStringAsFixed(1),
            unit: 'mEq/L',
            formula: _unit == _AlbUnit.gPerDL
                ? 'AG + 2.5 × (Normal − Measured)  [g/dL]'
                : 'AG + 0.25 × (Normal − Measured) [g/L]',
          ),
          const FECalcGap(),
          FECalcInsightCard(
            title: 'Why correct AG for albumin',
            body:
                'Albumin is the dominant unmeasured anion contributing to a '
                'normal AG. For every 1 g/dL drop in albumin, the AG falls by '
                '~2.5 mEq/L. In critically ill or nephrotic patients the '
                'measured AG can mask a true high-AG metabolic acidosis.',
            severity: FEInsightSeverity.info,
          ),
        ],
        const FECalcGap(16),
        const FECalcReferenceCard(
          text:
              'Reference: "Fluid and Electrolyte Formulae" — '
              'factor 0.25 (g/L) is equivalent to 2.5 (g/dL). Original '
              'derivation: Figge J, Crit Care Med 1998. For use by qualified '
              'clinicians only.',
        ),
      ],
    );
  }
}
