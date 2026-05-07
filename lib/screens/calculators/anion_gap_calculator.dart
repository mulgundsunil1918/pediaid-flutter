// =============================================================================
// anion_gap_calculator.dart  —  Anion Gap = [Na⁺ − (HCO3⁻ + Cl⁻)]
// Normal: 10–12 mEq/L (per internal reference) ; many labs use 8–16.
// =============================================================================

import 'package:flutter/material.dart';
import 'fluid_electrolyte_shared.dart';

class AnionGapCalculator extends StatefulWidget {
  const AnionGapCalculator({super.key});
  @override
  State<AnionGapCalculator> createState() => _AnionGapCalculatorState();
}

class _AnionGapCalculatorState extends State<AnionGapCalculator> {
  final _na = TextEditingController();
  final _hco3 = TextEditingController();
  final _cl = TextEditingController();
  double? _result;

  @override
  void dispose() {
    _na.dispose();
    _hco3.dispose();
    _cl.dispose();
    super.dispose();
  }

  bool get _ready =>
      double.tryParse(_na.text) != null &&
      double.tryParse(_hco3.text) != null &&
      double.tryParse(_cl.text) != null;

  void _calc() {
    final na = double.parse(_na.text);
    final hco3 = double.parse(_hco3.text);
    final cl = double.parse(_cl.text);
    setState(() => _result = na - (hco3 + cl));
  }

  ({String title, String body, FEInsightSeverity sev})? _interpret(double ag) {
    if (ag < 8) {
      return (
        title: 'Low anion gap (< 8 mEq/L)',
        body: 'Consider hypoalbuminaemia (most common), bromism, lithium '
            'toxicity, hypercalcaemia, multiple myeloma. Correct AG for '
            'albumin if low.',
        sev: FEInsightSeverity.info,
      );
    } else if (ag <= 12) {
      return (
        title: 'Normal anion gap (8–12 mEq/L)',
        body: 'No high anion gap acidosis. If acidotic, think NAGMA: '
            'diarrhoea, RTA, ureteric diversion, early renal failure.',
        sev: FEInsightSeverity.good,
      );
    } else if (ag <= 20) {
      return (
        title: 'Mild high anion gap (12–20 mEq/L)',
        body: 'Mild HAGMA. Consider lactic acidosis, ketoacidosis (DKA, '
            'starvation), uraemia, ingestions (salicylates, methanol, '
            'ethylene glycol), drugs.',
        sev: FEInsightSeverity.warning,
      );
    } else {
      return (
        title: 'High anion gap (> 20 mEq/L)',
        body: 'Significant HAGMA — MUDPILES (Methanol, Uraemia, DKA / other '
            'ketoacidosis, Paracetamol/Propylene glycol, Iron / INH, Lactic '
            'acidosis, Ethylene glycol, Salicylates). Investigate and treat '
            'underlying cause urgently.',
        sev: FEInsightSeverity.danger,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ins = _result == null ? null : _interpret(_result!);
    return FECalcScaffold(
      title: 'Anion Gap',
      children: [
        FECalcInputCard(
          label: 'Serum electrolytes',
          child: Column(children: [
            FECalcNumberField(
                label: 'Sodium (Na⁺)',
                unit: 'mEq/L',
                hint: 'e.g. 140',
                controller: _na,
                onChanged: (_) => setState(() {})),
            const FECalcGap(),
            FECalcNumberField(
                label: 'Bicarbonate (HCO₃⁻)',
                unit: 'mEq/L',
                hint: 'e.g. 24',
                controller: _hco3,
                onChanged: (_) => setState(() {})),
            const FECalcGap(),
            FECalcNumberField(
                label: 'Chloride (Cl⁻)',
                unit: 'mEq/L',
                hint: 'e.g. 102',
                controller: _cl,
                onChanged: (_) => setState(() {})),
          ]),
        ),
        const FECalcGap(16),
        FECalcButton(
          label: 'Calculate Anion Gap',
          icon: Icons.calculate,
          enabled: _ready,
          onPressed: _calc,
        ),
        if (_result != null) ...[
          const FECalcGap(16),
          FECalcResultCard(
            label: 'Anion gap',
            value: _result!.toStringAsFixed(1),
            unit: 'mEq/L',
            formula: 'AG = Na⁺ − (HCO₃⁻ + Cl⁻)',
          ),
          const FECalcGap(),
          FECalcInsightCard(
              title: ins!.title, body: ins.body, severity: ins.sev),
        ],
        const FECalcGap(16),
        const FECalcReferenceCard(
          text:
              'Reference: "Fluid and Electrolyte Formulae" card — '
              'normal AG 10–12 mEq/L. Interpretation bands per Harriet '
              'Lane 23rd ed. and Nelson 21st ed. For use by qualified '
              'clinicians only — verify against the source guideline.',
        ),
      ],
    );
  }
}
