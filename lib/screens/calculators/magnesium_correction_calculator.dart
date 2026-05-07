// =============================================================================
// magnesium_correction_calculator.dart  —  ↓Mg correction
// Correct if Mg < 0.75 mmol/L
// 0.2 mmol/kg (50 mg/kg) (0.5 mL/kg of 10 % MgSO₄)
// 25–50 mg/kg MgSO₄ over 2–4 hours; max 4 mmol or 1 g or 10 mL over 10 min
// Oral: 0.2–0.4 mmol/kg
// =============================================================================

import 'package:flutter/material.dart';
import 'fluid_electrolyte_shared.dart';

class MagnesiumCorrectionCalculator extends StatefulWidget {
  const MagnesiumCorrectionCalculator({super.key});
  @override
  State<MagnesiumCorrectionCalculator> createState() =>
      _MagnesiumCorrectionCalculatorState();
}

class _MagnesiumCorrectionCalculatorState
    extends State<MagnesiumCorrectionCalculator> {
  final _wt = TextEditingController();
  Map<String, double>? _r;

  @override
  void dispose() {
    _wt.dispose();
    super.dispose();
  }

  bool get _ready =>
      double.tryParse(_wt.text) != null && double.parse(_wt.text) > 0;

  void _compute() {
    final w = double.parse(_wt.text);
    setState(() {
      _r = {
        'standard_mg': (50 * w).clamp(0.0, 1000.0),     // mg
        'standard_mL10pc': (0.5 * w).clamp(0.0, 10.0),    // mL of 10%
        'slow_low_mg': (25 * w).clamp(0.0, 1000.0),
        'slow_high_mg': (50 * w).clamp(0.0, 1000.0),
        'oral_low_mmol': 0.2 * w,
        'oral_high_mmol': 0.4 * w,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return FECalcScaffold(
      title: 'Magnesium Correction (↓Mg)',
      children: [
        FECalcInputCard(
          label: 'Patient',
          child: FECalcNumberField(
              label: 'Weight',
              unit: 'kg',
              hint: 'e.g. 10',
              controller: _wt,
              onChanged: (_) => setState(() {})),
        ),
        const FECalcGap(16),
        FECalcButton(
          label: 'Calculate Mg dose',
          icon: Icons.calculate,
          enabled: _ready,
          onPressed: _compute,
        ),
        if (_r != null) ...[
          const FECalcGap(16),
          FECalcResultCard(
            label: 'IV bolus (standard)',
            value: '${_r!['standard_mg']!.toStringAsFixed(0)}',
            unit: 'mg MgSO₄',
            formula:
                '0.2 mmol/kg = 50 mg/kg = '
                '${_r!['standard_mL10pc']!.toStringAsFixed(2)} mL of 10 % '
                'MgSO₄. Max 4 mmol / 1 g / 10 mL over 10 min.',
          ),
          const FECalcGap(),
          FECalcResultCard(
            label: 'Slow IV (preferred for stable patient)',
            value:
                '${_r!['slow_low_mg']!.toStringAsFixed(0)} – ${_r!['slow_high_mg']!.toStringAsFixed(0)}',
            unit: 'mg MgSO₄',
            formula: 'MgSO₄ 25–50 mg/kg IV over 2–4 hours.',
          ),
          const FECalcGap(),
          FECalcResultCard(
            label: 'Oral replacement',
            value:
                '${_r!['oral_low_mmol']!.toStringAsFixed(1)} – ${_r!['oral_high_mmol']!.toStringAsFixed(1)}',
            unit: 'mmol Mg',
            formula:
                'Oral: 0.2–0.4 mmol/kg. Useful for chronic mild '
                'hypomagnesaemia and for ongoing maintenance after IV '
                'replacement.',
          ),
          const FECalcGap(),
          const FECalcInsightCard(
            title: 'Monitor for toxicity + workup loss',
            body:
                'Watch for bradycardia, hypotension, loss of deep tendon '
                'reflexes (toxicity ≥ 4 mmol/L). Stop infusion if reflexes '
                'absent or BP drops.\n\n'
                'Workup loss:  FE_Mg < 2 % → non-renal loss (GI, dietary);  '
                '24 h urine Mg > 30 mg → renal loss (loop/thiazide '
                'diuretics, tubulopathies, alcoholism, drug-induced).',
            severity: FEInsightSeverity.warning,
          ),
        ],
        const FECalcGap(16),
        const FECalcReferenceCard(
          text:
              'Reference: "Electrolyte Corrections" — '
              'correct if Mg < 0.75 mmol/L. 0.2 mmol/kg (50 mg/kg, 0.5 '
              'mL/kg of 10 % MgSO₄). 25–50 mg/kg over 2–4 h. Max 4 mmol '
              'or 1 g or 10 mL over 10 min. Oral 0.2–0.4 mmol/kg. For use '
              'by qualified clinicians only.',
        ),
      ],
    );
  }
}
