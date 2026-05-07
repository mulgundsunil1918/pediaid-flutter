// =============================================================================
// potassium_correction_calculator.dart
// Hypokalaemia: KCl 0.5–1 mEq/kg IV over 1–2 h.
// Hyperkalaemia: insulin/glucose, calcium, NaHCO3, kayexalate, dialysis.
// =============================================================================

import 'package:flutter/material.dart';
import 'fluid_electrolyte_shared.dart';

enum _Direction { hypo, hyper }

class PotassiumCorrectionCalculator extends StatefulWidget {
  const PotassiumCorrectionCalculator({super.key});
  @override
  State<PotassiumCorrectionCalculator> createState() =>
      _PotassiumCorrectionCalculatorState();
}

class _PotassiumCorrectionCalculatorState
    extends State<PotassiumCorrectionCalculator> {
  final _wt = TextEditingController();
  _Direction _dir = _Direction.hypo;
  Map<String, double>? _result;

  @override
  void dispose() {
    _wt.dispose();
    super.dispose();
  }

  bool get _ready =>
      double.tryParse(_wt.text) != null && double.parse(_wt.text) > 0;

  void _compute() {
    final w = double.parse(_wt.text);
    if (_dir == _Direction.hypo) {
      // KCl 0.5–1 mEq/kg
      setState(() {
        _result = {
          'low_meq': 0.5 * w,
          'high_meq': 1.0 * w,
          'rate_mlhr_low': 0.5 * w,
          'rate_mlhr_high': 0.5 * w,
        };
      });
    } else {
      // Hyperkalaemia treatment — return mg / mEq doses
      setState(() {
        _result = {
          'dextrose_g_low': 1.0 * w,
          'dextrose_g_high': 2.0 * w,
          'insulin_units': 0.1 * w,
          'cacl_low_mg': 10.0 * w,
          'cacl_high_mg': 20.0 * w,
          'nahco3_low_meq': 1.0 * w,
          'nahco3_high_meq': 2.0 * w,
          'kayexalate_low_g': 1.0 * w,
          'kayexalate_high_g': 2.0 * w,
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FECalcScaffold(
      title: 'Potassium Correction',
      children: [
        FECalcInputCard(
          label: 'Patient',
          child: Column(children: [
            const Text('DIRECTION',
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3)),
            const FECalcGap(6),
            SegmentedButton<_Direction>(
              segments: const [
                ButtonSegment(value: _Direction.hypo, label: Text('↓K (hypo)')),
                ButtonSegment(
                    value: _Direction.hyper, label: Text('↑K (hyper)')),
              ],
              selected: {_dir},
              onSelectionChanged: (s) => setState(() {
                _dir = s.first;
                _result = null;
              }),
            ),
            const FECalcGap(),
            FECalcNumberField(
                label: 'Weight',
                unit: 'kg',
                hint: 'e.g. 12',
                controller: _wt,
                onChanged: (_) => setState(() {})),
          ]),
        ),
        const FECalcGap(16),
        FECalcButton(
          label: _dir == _Direction.hypo
              ? 'Calculate KCl replacement'
              : 'Calculate hyperkalaemia regimen',
          icon: Icons.calculate,
          enabled: _ready,
          onPressed: _compute,
        ),
        if (_result != null && _dir == _Direction.hypo) ...[
          const FECalcGap(16),
          FECalcResultCard(
            label: 'KCl IV replacement',
            value:
                '${_result!['low_meq']!.toStringAsFixed(1)} – ${_result!['high_meq']!.toStringAsFixed(1)}',
            unit: 'mEq',
            formula: 'KCl 0.5 – 1 mEq/kg IV over 1–2 hours.\n'
                'Maximum peripheral concentration: 40 mEq/L.\n'
                'Maximum infusion rate: 0.5 mEq/kg/hr (peripheral) '
                'or 1 mEq/kg/hr (central, with cardiac monitoring).',
          ),
          const FECalcGap(),
          const FECalcInsightCard(
            title: 'Cautions',
            body:
                '• Always have IV access and cardiac monitoring for K > 0.3 '
                'mEq/kg/hr.\n'
                '• Hold replacement if urine output < 0.5 mL/kg/hr.\n'
                '• Concomitant Mg replacement is essential — refractory '
                'hypokalaemia is often hypomagnesaemia.\n'
                '• Watch for urine K > 40 mEq/L → renal wasting (workup '
                'tubulopathy, diuretics, Bartter, Gitelman).',
            severity: FEInsightSeverity.warning,
          ),
        ],
        if (_result != null && _dir == _Direction.hyper) ...[
          const FECalcGap(16),
          FECalcResultCard(
            label: 'Dextrose + insulin (cellular shift)',
            value:
                '${_result!['dextrose_g_low']!.toStringAsFixed(1)} – ${_result!['dextrose_g_high']!.toStringAsFixed(1)} g  +  ${_result!['insulin_units']!.toStringAsFixed(2)} U insulin',
            unit: 'IV',
            formula:
                'Dextrose 1–2 g/kg IV with Insulin 0.1 U/kg IV. Onset 15–30 '
                'min, lasts 2–4 h. Monitor BG q 1 h.',
          ),
          const FECalcGap(),
          FECalcResultCard(
            label: 'Calcium gluconate / chloride (membrane stabiliser)',
            value:
                '${_result!['cacl_low_mg']!.toStringAsFixed(0)} – ${_result!['cacl_high_mg']!.toStringAsFixed(0)}',
            unit: 'mg CaCl₂',
            formula:
                'CaCl₂ 10–20 mg/kg IV (max 500 mg/dose) OR '
                'Calcium gluconate 100 mg/kg IV (max 2 g/dose). '
                'For ECG changes — onset 1–3 min.',
          ),
          const FECalcGap(),
          FECalcResultCard(
            label: 'Sodium bicarbonate',
            value:
                '${_result!['nahco3_low_meq']!.toStringAsFixed(1)} – ${_result!['nahco3_high_meq']!.toStringAsFixed(1)}',
            unit: 'mEq NaHCO₃',
            formula: 'NaHCO₃ 1–2 mEq/kg IV. Reserve for acidotic patients.',
          ),
          const FECalcGap(),
          FECalcResultCard(
            label: 'Kayexalate (sodium polystyrene sulfonate)',
            value:
                '${_result!['kayexalate_low_g']!.toStringAsFixed(1)} – ${_result!['kayexalate_high_g']!.toStringAsFixed(1)}',
            unit: 'g (NG/PR)',
            formula:
                'Kayexalate 1–2 g/kg/dose NG or PR. Removes K from body. '
                'Plus loop diuretic + dialysis if oligoanuric.',
          ),
          const FECalcGap(),
          const FECalcInsightCard(
            title: 'Order of intervention',
            body:
                '1. Calcium FIRST if ECG changes (peaked T waves, widened '
                'QRS, sine wave) — stabilises myocardium.\n'
                '2. Insulin + dextrose AND/OR salbutamol — shifts K into '
                'cells.\n'
                '3. Sodium bicarbonate IF acidotic.\n'
                '4. Kayexalate / loop diuretic / dialysis — removes K from '
                'body (slower).\n'
                '5. Stop all K-containing fluids and meds. Investigate '
                'cause (renal failure, rhabdomyolysis, TLS, drugs, '
                'haemolysis).',
            severity: FEInsightSeverity.danger,
          ),
        ],
        const FECalcGap(16),
        const FECalcReferenceCard(
          text:
              'Reference: "Electrolyte Corrections" — '
              '↓K: 0.5–1 mEq/kg KCl IV over 1–2 h. '
              '↑K: dextrose 1–2 g/kg + insulin 0.1 U/kg, CaCl₂ 10–20 '
              'mg/kg, NaHCO₃ 1–2 mEq/kg, kayexalate 1–2 g/kg/dose. '
              'For use by qualified clinicians only.',
        ),
      ],
    );
  }
}
