// =============================================================================
// free_water_deficit_calculator.dart  —  Hypernatraemia (↑Na) correction
// FWD = 0.6 × wt × ([Na]/140 − 1)
// 4 mL FW/kg ≈ ↓ Na 1 mEq/L
// Goal: ↓ Na 10–15 mEq/L per 24 hr (slow correction).
// =============================================================================

import 'package:flutter/material.dart';
import 'fluid_electrolyte_shared.dart';

class FreeWaterDeficitCalculator extends StatefulWidget {
  const FreeWaterDeficitCalculator({super.key});
  @override
  State<FreeWaterDeficitCalculator> createState() =>
      _FreeWaterDeficitCalculatorState();
}

class _FreeWaterDeficitCalculatorState
    extends State<FreeWaterDeficitCalculator> {
  final _wt = TextEditingController();
  final _na = TextEditingController();
  double? _fwd;
  double? _ratePerHour;

  @override
  void dispose() {
    _wt.dispose();
    _na.dispose();
    super.dispose();
  }

  bool get _ready =>
      double.tryParse(_wt.text) != null &&
      double.tryParse(_na.text) != null &&
      double.parse(_na.text) > 140;

  void _compute() {
    final w = double.parse(_wt.text);
    final na = double.parse(_na.text);
    final fwd = 0.6 * w * (na / 140 - 1);
    // Replace over 48 h (slow correction in chronic hypernatraemia).
    setState(() {
      _fwd = fwd * 1000; // mL
      _ratePerHour = (_fwd ?? 0) / 48;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FECalcScaffold(
      title: 'Free Water Deficit (↑Na)',
      children: [
        FECalcInputCard(
          label: 'Patient values',
          child: Column(children: [
            FECalcNumberField(
                label: 'Weight',
                unit: 'kg',
                hint: 'e.g. 12',
                controller: _wt,
                onChanged: (_) => setState(() {})),
            const FECalcGap(),
            FECalcNumberField(
                label: 'Measured Sodium',
                unit: 'mEq/L',
                hint: 'e.g. 158',
                controller: _na,
                onChanged: (_) => setState(() {})),
          ]),
        ),
        const FECalcGap(16),
        FECalcButton(
          label: 'Calculate Free Water Deficit',
          icon: Icons.calculate,
          enabled: _ready,
          onPressed: _compute,
        ),
        if (_fwd != null) ...[
          const FECalcGap(16),
          FECalcResultCard(
            label: 'Free water deficit',
            value: _fwd!.toStringAsFixed(0),
            unit: 'mL',
            formula: 'FWD = 0.6 × wt × ([Na]/140 − 1)',
          ),
          const FECalcGap(),
          FECalcResultCard(
            label: 'Replace over 48 hours',
            value: _ratePerHour!.toStringAsFixed(1),
            unit: 'mL/hr',
            formula:
                'Use D5W or D5 ¼NS. Goal: ↓ Na 10–15 mEq/L per 24 hr. '
                '4 mL free water per kg ≈ ↓ Na by 1 mEq/L.',
          ),
          const FECalcGap(),
          const FECalcInsightCard(
            title: 'Critical safety reminders',
            body:
                '• NEVER drop Na faster than 0.5 mEq/L/hr (15 mEq/L/day) — '
                'risk of cerebral oedema.\n'
                '• Add the patient\'s usual maintenance fluids on top of FWD '
                'replacement.\n'
                '• Recheck Na q 2–4 h.\n'
                '• In central diabetes insipidus add desmopressin; in '
                'nephrogenic DI restrict salt + thiazide.',
            severity: FEInsightSeverity.warning,
          ),
        ],
        const FECalcGap(16),
        const FECalcReferenceCard(
          text:
              'Reference: "Electrolyte Corrections" — '
              'FWD = 0.6(wt)([Na]/140 − 1). Goal ↓ Na 10–15 mEq/L per 24 hr. '
              '4 mL FW/kg ≈ ↓ Na 1 mEq/L. For use by qualified clinicians '
              'only.',
        ),
      ],
    );
  }
}
