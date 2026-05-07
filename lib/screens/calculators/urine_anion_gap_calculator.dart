// =============================================================================
// urine_anion_gap_calculator.dart
// Urine AG = [Ur. Na⁺ + Ur. K⁻ − Ur. Cl⁻]
// +ve  → impaired NH4⁺ excretion → RTA
// −ve  → GI bicarbonate loss (e.g., diarrhoea)
// =============================================================================

import 'package:flutter/material.dart';
import 'fluid_electrolyte_shared.dart';

class UrineAnionGapCalculator extends StatefulWidget {
  const UrineAnionGapCalculator({super.key});
  @override
  State<UrineAnionGapCalculator> createState() =>
      _UrineAnionGapCalculatorState();
}

class _UrineAnionGapCalculatorState extends State<UrineAnionGapCalculator> {
  final _na = TextEditingController();
  final _k = TextEditingController();
  final _cl = TextEditingController();
  double? _result;

  @override
  void dispose() {
    _na.dispose();
    _k.dispose();
    _cl.dispose();
    super.dispose();
  }

  bool get _ready =>
      double.tryParse(_na.text) != null &&
      double.tryParse(_k.text) != null &&
      double.tryParse(_cl.text) != null;

  void _compute() {
    final na = double.parse(_na.text);
    final k = double.parse(_k.text);
    final cl = double.parse(_cl.text);
    setState(() => _result = na + k - cl);
  }

  ({String title, String body, FEInsightSeverity sev}) _interpret(double v) {
    if (v > 5) {
      return (
        title: '+ve Urine AG → suggests RTA',
        body: 'Positive UAG indicates impaired NH4⁺ excretion. Consider '
            'distal (Type 1) RTA, hypoaldosteronism (Type 4), or proximal '
            '(Type 2) RTA with bicarbonaturia. Workup: urine pH, K⁺, '
            'serum K, ABG.',
        sev: FEInsightSeverity.warning,
      );
    } else if (v < -5) {
      return (
        title: '−ve Urine AG → suggests GI bicarb loss',
        body: 'Negative UAG indicates appropriate NH4⁺ excretion. The '
            'NAGMA is most likely from gastrointestinal bicarbonate loss '
            '(diarrhoea, fistula, ileostomy).',
        sev: FEInsightSeverity.info,
      );
    } else {
      return (
        title: 'Indeterminate (~0)',
        body: 'Cannot reliably distinguish renal from GI cause. Consider '
            'urine osmolar gap (Urine osm − 2[Na+K] − Urea/2.8 − Glu/18) '
            'as a surrogate for urinary NH4⁺ excretion.',
        sev: FEInsightSeverity.info,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ins = _result == null ? null : _interpret(_result!);
    return FECalcScaffold(
      title: 'Urine Anion Gap',
      children: [
        FECalcInputCard(
          label: 'Spot urine electrolytes',
          child: Column(children: [
            FECalcNumberField(
                label: 'Urine Sodium (Na⁺)',
                unit: 'mEq/L',
                hint: 'e.g. 40',
                controller: _na,
                onChanged: (_) => setState(() {})),
            const FECalcGap(),
            FECalcNumberField(
                label: 'Urine Potassium (K⁺)',
                unit: 'mEq/L',
                hint: 'e.g. 25',
                controller: _k,
                onChanged: (_) => setState(() {})),
            const FECalcGap(),
            FECalcNumberField(
                label: 'Urine Chloride (Cl⁻)',
                unit: 'mEq/L',
                hint: 'e.g. 80',
                controller: _cl,
                onChanged: (_) => setState(() {})),
          ]),
        ),
        const FECalcGap(16),
        FECalcButton(
          label: 'Calculate Urine AG',
          icon: Icons.calculate,
          enabled: _ready,
          onPressed: _compute,
        ),
        if (_result != null) ...[
          const FECalcGap(16),
          FECalcResultCard(
            label: 'Urine anion gap',
            value: _result!.toStringAsFixed(1),
            unit: 'mEq/L',
            formula: 'UAG = Na + K − Cl',
          ),
          const FECalcGap(),
          FECalcInsightCard(
              title: ins!.title, body: ins.body, severity: ins.sev),
        ],
        const FECalcGap(16),
        const FECalcReferenceCard(
          text:
              'Reference: "Fluid and Electrolyte Formulae" — '
              '+ve UAG → RTA, −ve UAG → diarrhoea. Goldstein (Am J '
              'Nephrol 1986) original description. UAG is unreliable when '
              'UTI is present (urease), volume depletion, or unmeasured '
              'urine anions are high. For use by qualified clinicians only.',
        ),
      ],
    );
  }
}
