// =============================================================================
// phosphate_correction_calculator.dart  —  ↓PO₄ correction
// Correct if phosphorus < 0.8 mmol/L
// 0.4 mmol/kg (child > 2 yr) — 0.7 mmol/kg (child < 2 yr)
// As Sodium phosphate (0.6 mmol/mL) or Potassium phosphate (1–3 mmol/mL)
// over 8–14 h. Dilute 1 in 10 in 0.9 % saline or 5 % D
// at rate of 0.05 mmol/kg/hr peripheral, 0.5 mmol/kg/hr central
// Oral: 1–3 mmol/kg/day (Phos sachet 500 mg / 16 mmol; K-Phos tab 250 mg / 8 mmol)
// =============================================================================

import 'package:flutter/material.dart';
import 'fluid_electrolyte_shared.dart';

class PhosphateCorrectionCalculator extends StatefulWidget {
  const PhosphateCorrectionCalculator({super.key});
  @override
  State<PhosphateCorrectionCalculator> createState() =>
      _PhosphateCorrectionCalculatorState();
}

class _PhosphateCorrectionCalculatorState
    extends State<PhosphateCorrectionCalculator> {
  final _wt = TextEditingController();
  bool _under2 = false;
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
    final dose = (_under2 ? 0.7 : 0.4) * w;
    setState(() {
      _r = {
        'iv_mmol': dose,
        'naphos_mL': dose / 0.6,
        'kphos_low_mL': dose / 3.0,
        'kphos_high_mL': dose / 1.0,
        'oral_low_mmol': 1.0 * w,
        'oral_high_mmol': 3.0 * w,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return FECalcScaffold(
      title: 'Phosphate Correction (↓PO₄)',
      children: [
        FECalcInputCard(
          label: 'Patient',
          child: Column(children: [
            FECalcNumberField(
                label: 'Weight',
                unit: 'kg',
                hint: 'e.g. 14',
                controller: _wt,
                onChanged: (_) => setState(() {})),
            const FECalcGap(),
            SwitchListTile(
              title: const Text('Child < 2 years',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
              subtitle: const Text(
                  'Higher dose (0.7 mmol/kg) for under-2s.',
                  style: TextStyle(fontSize: 11.5)),
              value: _under2,
              dense: true,
              contentPadding: EdgeInsets.zero,
              onChanged: (v) => setState(() => _under2 = v),
            ),
          ]),
        ),
        const FECalcGap(16),
        FECalcButton(
          label: 'Calculate PO₄ dose',
          icon: Icons.calculate,
          enabled: _ready,
          onPressed: _compute,
        ),
        if (_r != null) ...[
          const FECalcGap(16),
          FECalcResultCard(
            label: 'IV total dose',
            value: _r!['iv_mmol']!.toStringAsFixed(2),
            unit: 'mmol PO₄',
            formula: _under2
                ? '0.7 mmol/kg (child < 2 yr) — also acceptable 0.15–0.3 '
                    'mmol/kg of NaPhos / KPhos IV over 4 h'
                : '0.4 mmol/kg (child > 2 yr) — also acceptable 0.15–0.3 '
                    'mmol/kg of NaPhos / KPhos IV over 4 h',
          ),
          const FECalcGap(),
          FECalcResultCard(
            label: 'Sodium phosphate volume (0.6 mmol/mL)',
            value: _r!['naphos_mL']!.toStringAsFixed(2),
            unit: 'mL NaPhos',
            formula: 'Dilute 1:10 in 0.9 % saline or 5 % D. Infuse over '
                '8–14 h. Peripheral: 0.05 mmol/kg/hr. CVL: 0.5 mmol/kg/hr.',
          ),
          const FECalcGap(),
          FECalcResultCard(
            label: 'Potassium phosphate volume (1–3 mmol/mL)',
            value:
                '${_r!['kphos_low_mL']!.toStringAsFixed(2)} – ${_r!['kphos_high_mL']!.toStringAsFixed(2)}',
            unit: 'mL KPhos',
            formula: 'Dilute 1:10. Same infusion rates. KPhos preferred '
                'when both K and PO₄ are low; max K rate = 0.3 mEq/kg/hr.',
          ),
          const FECalcGap(),
          FECalcResultCard(
            label: 'Oral replacement (chronic / mild)',
            value:
                '${_r!['oral_low_mmol']!.toStringAsFixed(1)} – ${_r!['oral_high_mmol']!.toStringAsFixed(1)}',
            unit: 'mmol/day',
            formula: 'Oral 1–3 mmol/kg/day. '
                'Phos sachet 500 mg = 16 mmol. K-Phos tab 250 mg = 8 mmol.',
          ),
          const FECalcGap(),
          const FECalcInsightCard(
            title: 'Cautions',
            body:
                '• Risk of hypocalcaemia (PO₄ binds Ca) — monitor iCa.\n'
                '• Risk of metastatic calcification with rapid infusion.\n'
                '• Investigate cause: refeeding syndrome (most common in '
                'PICU), DKA, alcohol withdrawal, sepsis, vitamin D '
                'deficiency, X-linked hypophosphataemia, Fanconi syndrome.',
            severity: FEInsightSeverity.warning,
          ),
        ],
        const FECalcGap(16),
        const FECalcReferenceCard(
          text:
              'Reference: "Electrolyte Corrections" — '
              '0.15–0.3 mmol/kg NaPhos / KPhos IV over 4 h; correct if '
              'PO₄ < 0.8 mmol/L; 0.4 mmol/kg (>2 yr) – 0.7 mmol/kg (<2 yr); '
              'oral 1–3 mmol/kg/day. For use by qualified clinicians only.',
        ),
      ],
    );
  }
}
