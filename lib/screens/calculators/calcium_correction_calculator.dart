// =============================================================================
// calcium_correction_calculator.dart
// ↓Ca: CaCl₂ 10–20 mg/kg q10 min (max 500 mg/dose)
//      Ca-Gluconate 100 mg/kg q10 min (max 4 g/dose)
//      MgSO₄ 25–50 mg/kg (max 2.5 g/dose)
// =============================================================================

import 'package:flutter/material.dart';
import 'fluid_electrolyte_shared.dart';

class CalciumCorrectionCalculator extends StatefulWidget {
  const CalciumCorrectionCalculator({super.key});
  @override
  State<CalciumCorrectionCalculator> createState() =>
      _CalciumCorrectionCalculatorState();
}

class _CalciumCorrectionCalculatorState
    extends State<CalciumCorrectionCalculator> {
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
        'cacl_low_mg': (10 * w).clamp(0.0, 500.0),
        'cacl_high_mg': (20 * w).clamp(0.0, 500.0),
        'gluc_low_mg': (100 * w).clamp(0.0, 4000.0),
        'gluc_high_mg': (100 * w).clamp(0.0, 4000.0),
        'mg_low_mg': (25 * w).clamp(0.0, 2500.0),
        'mg_high_mg': (50 * w).clamp(0.0, 2500.0),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return FECalcScaffold(
      title: 'Calcium Correction (↓Ca)',
      children: [
        FECalcInputCard(
          label: 'Patient',
          child: FECalcNumberField(
              label: 'Weight',
              unit: 'kg',
              hint: 'e.g. 8',
              controller: _wt,
              onChanged: (_) => setState(() {})),
        ),
        const FECalcGap(16),
        FECalcButton(
          label: 'Calculate calcium dose',
          icon: Icons.calculate,
          enabled: _ready,
          onPressed: _compute,
        ),
        if (_r != null) ...[
          const FECalcGap(16),
          FECalcResultCard(
            label: 'Calcium chloride 10 % (preferred via CVL)',
            value:
                '${_r!['cacl_low_mg']!.toStringAsFixed(0)} – ${_r!['cacl_high_mg']!.toStringAsFixed(0)}',
            unit: 'mg / dose',
            formula:
                'CaCl₂ 10–20 mg/kg IV q 10 min, max 500 mg/dose. '
                '10 % CaCl₂ = 100 mg/mL = 27.2 mg elemental Ca/mL.',
          ),
          const FECalcGap(),
          FECalcResultCard(
            label: 'Calcium gluconate 10 % (peripheral OK)',
            value:
                '${_r!['gluc_low_mg']!.toStringAsFixed(0)} – ${_r!['gluc_high_mg']!.toStringAsFixed(0)}',
            unit: 'mg / dose',
            formula:
                'Ca-gluconate 100 mg/kg IV q 10 min, max 4 g/dose. '
                '10 % = 100 mg/mL = 9.3 mg elemental Ca/mL.',
          ),
          const FECalcGap(),
          FECalcResultCard(
            label: 'Magnesium sulphate (if Mg is low)',
            value:
                '${_r!['mg_low_mg']!.toStringAsFixed(0)} – ${_r!['mg_high_mg']!.toStringAsFixed(0)}',
            unit: 'mg / dose',
            formula:
                'MgSO₄ 25–50 mg/kg IV, max 2.5 g/dose. Hypomagnesaemia '
                'causes refractory hypocalcaemia — replace Mg first.',
          ),
          const FECalcGap(),
          const FECalcInsightCard(
            title: 'Workup before treating',
            body:
                'Send: CMP, PO₄, Mg, PTH, Vit D, urine Ca/Cr, protein, '
                'iCa (ionised). Get an ECG (look for prolonged QTc) and a '
                'left-wrist X-ray for evidence of rickets. Calcium chloride '
                'is more potent (×3 elemental Ca) but also more sclerosing '
                '— prefer CVL or large peripheral vein.',
            severity: FEInsightSeverity.info,
          ),
        ],
        const FECalcGap(16),
        const FECalcReferenceCard(
          text:
              'Reference: "Electrolyte Corrections" — CaCl₂ '
              '10–20 mg/kg q 10 min (max 500 mg/dose), Ca-gluconate 100 '
              'mg/kg q 10 min (max 4 g/dose), MgSO₄ 25–50 mg/kg (max 2.5 '
              'g/dose). For use by qualified clinicians only.',
        ),
      ],
    );
  }
}
