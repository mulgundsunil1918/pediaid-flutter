// =============================================================================
// sodium_correction_calculator.dart  —  Hyponatraemia (↓Na) correction
// Symptomatic: 3 % saline 6 mL/kg → raises Na by ≈ 5 mEq/L
// Slow correction: 0.5 mEq/L/hr (max 10–12 mEq/L per 24 hr)
// Sodium deficit = (Na_goal − Na_meas) × wt × 1.2
// =============================================================================

import 'package:flutter/material.dart';
import 'fluid_electrolyte_shared.dart';

class SodiumCorrectionCalculator extends StatefulWidget {
  const SodiumCorrectionCalculator({super.key});
  @override
  State<SodiumCorrectionCalculator> createState() =>
      _SodiumCorrectionCalculatorState();
}

class _SodiumCorrectionCalculatorState
    extends State<SodiumCorrectionCalculator> {
  final _wt = TextEditingController();
  final _na = TextEditingController();
  final _goal = TextEditingController(text: '135');
  double? _deficit;
  double? _hyperVolMl;

  @override
  void dispose() {
    _wt.dispose();
    _na.dispose();
    _goal.dispose();
    super.dispose();
  }

  bool get _ready =>
      double.tryParse(_wt.text) != null &&
      double.tryParse(_na.text) != null &&
      double.tryParse(_goal.text) != null &&
      double.parse(_na.text) < double.parse(_goal.text);

  void _compute() {
    final w = double.parse(_wt.text);
    final na = double.parse(_na.text);
    final g = double.parse(_goal.text);
    setState(() {
      _deficit = (g - na) * w * 1.2; // mEq
      _hyperVolMl = 6.0 * w; // 3 % saline 6 mL/kg = symptomatic bolus
    });
  }

  @override
  Widget build(BuildContext context) {
    return FECalcScaffold(
      title: 'Sodium Correction (↓Na)',
      children: [
        FECalcInputCard(
          label: 'Patient values',
          child: Column(children: [
            FECalcNumberField(
                label: 'Weight',
                unit: 'kg',
                hint: 'e.g. 15',
                controller: _wt,
                onChanged: (_) => setState(() {})),
            const FECalcGap(),
            FECalcNumberField(
                label: 'Measured Sodium',
                unit: 'mEq/L',
                hint: 'e.g. 122',
                controller: _na,
                onChanged: (_) => setState(() {})),
            const FECalcGap(),
            FECalcNumberField(
                label: 'Goal Sodium',
                unit: 'mEq/L',
                hint: 'e.g. 135',
                controller: _goal,
                onChanged: (_) => setState(() {})),
          ]),
        ),
        const FECalcGap(16),
        FECalcButton(
          label: 'Calculate Na deficit',
          icon: Icons.calculate,
          enabled: _ready,
          onPressed: _compute,
        ),
        if (_deficit != null) ...[
          const FECalcGap(16),
          FECalcResultCard(
            label: 'Sodium deficit',
            value: _deficit!.toStringAsFixed(1),
            unit: 'mEq',
            formula: 'Na = (Na_goal − Na_meas) × wt × 1.2',
          ),
          const FECalcGap(),
          FECalcResultCard(
            label: 'Symptomatic bolus — 3 % saline',
            value: _hyperVolMl!.toStringAsFixed(0),
            unit: 'mL',
            formula: '3 % saline 6 mL/kg over 10–60 min '
                '→ ↑ Na by ≈ 5 mEq/L (use only if seizing/comatose).',
          ),
          const FECalcGap(),
          const FECalcInsightCard(
            title: 'Correction safety',
            body:
                '• Slow correction: 0.5 mEq/L/hr or 15 mEq/L/day.\n'
                '• Symptomatic (seizing / GCS drop): 3 % NaCl 4–6 mL/kg '
                '(max 100 mL) IV over 10–30 min — repeat to control symptoms.\n'
                '• Over-rapid correction → osmotic demyelination syndrome '
                '(ODS).\n'
                '• Investigate cause: SIADH, hypovolaemia, CSW, water '
                'intoxication, adrenal insufficiency. Restrict water if '
                'SIADH.',
            severity: FEInsightSeverity.warning,
          ),
        ],
        const FECalcGap(16),
        const FECalcReferenceCard(
          text:
              'Reference: "Electrolyte Corrections" — '
              'Na in mEq = (Na_goal − Na_meas)(Wt)(1.2). Symptomatic 3 % '
              'saline 6 mL/kg → ↑ Na 5 mEq/L. For use by qualified '
              'clinicians only.',
        ),
      ],
    );
  }
}
