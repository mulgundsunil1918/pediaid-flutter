// =============================================================================
// corrected_sodium_calculator.dart
// Corrected Na = Measured Na + 1.6 × ((Glucose mg/dL − 100) / 100)
// Source factor: 1.6 (internal reference). Hillier 1999 used 2.4 in the upper-glucose
// range (> 400) — included as a research add-on.
// =============================================================================

import 'package:flutter/material.dart';
import 'fluid_electrolyte_shared.dart';

class CorrectedSodiumCalculator extends StatefulWidget {
  const CorrectedSodiumCalculator({super.key});
  @override
  State<CorrectedSodiumCalculator> createState() =>
      _CorrectedSodiumCalculatorState();
}

class _CorrectedSodiumCalculatorState
    extends State<CorrectedSodiumCalculator> {
  final _na = TextEditingController();
  final _glu = TextEditingController();
  double? _result;
  double? _hillier;

  @override
  void dispose() {
    _na.dispose();
    _glu.dispose();
    super.dispose();
  }

  bool get _ready =>
      double.tryParse(_na.text) != null &&
      double.tryParse(_glu.text) != null;

  void _compute() {
    final na = double.parse(_na.text);
    final glu = double.parse(_glu.text);
    setState(() {
      _result = na + 1.6 * ((glu - 100) / 100);
      _hillier = na + 2.4 * ((glu - 100) / 100);
    });
  }

  ({String title, String body, FEInsightSeverity sev}) _interpret(double na) {
    if (na < 135) {
      return (
        title: 'Hyponatraemia after correction',
        body: 'Even after correcting for hyperglycaemia, the patient is '
            'hyponatraemic. Investigate volume status + urine osmolality + '
            'urine Na to differentiate hypovolaemic / euvolaemic / '
            'hypervolaemic causes.',
        sev: FEInsightSeverity.warning,
      );
    } else if (na <= 145) {
      return (
        title: 'Normal corrected sodium (135–145 mEq/L)',
        body: 'The measured hyponatraemia is purely dilutional from the '
            'hyperglycaemia. Treating the glucose will restore the sodium.',
        sev: FEInsightSeverity.good,
      );
    } else {
      return (
        title: 'Hypernatraemia after correction',
        body: 'True hypernatraemia in addition to hyperglycaemia. In DKA, '
            'a rising or high corrected Na as glucose falls is a red flag for '
            'cerebral oedema — slow fluid replacement, monitor osm, '
            'neuro-observations hourly.',
        sev: FEInsightSeverity.danger,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ins = _result == null ? null : _interpret(_result!);
    return FECalcScaffold(
      title: 'Corrected Na (hyperglycaemia)',
      children: [
        FECalcInputCard(
          label: 'Patient values',
          child: Column(children: [
            FECalcNumberField(
                label: 'Measured Sodium (Na⁺)',
                unit: 'mEq/L',
                hint: 'e.g. 130',
                controller: _na,
                onChanged: (_) => setState(() {})),
            const FECalcGap(),
            FECalcNumberField(
                label: 'Glucose',
                unit: 'mg/dL',
                hint: 'e.g. 600',
                controller: _glu,
                onChanged: (_) => setState(() {})),
          ]),
        ),
        const FECalcGap(16),
        FECalcButton(
          label: 'Calculate Corrected Na',
          icon: Icons.calculate,
          enabled: _ready,
          onPressed: _compute,
        ),
        if (_result != null) ...[
          const FECalcGap(16),
          FECalcResultCard(
            label: 'Corrected sodium',
            value: _result!.toStringAsFixed(1),
            unit: 'mEq/L',
            formula: 'Na + 1.6 × ((Glucose − 100) / 100)',
          ),
          const FECalcGap(),
          FECalcResultCard(
            label: 'Hillier formula (× 2.4) — for glucose > 400 mg/dL',
            value: _hillier!.toStringAsFixed(1),
            unit: 'mEq/L',
            formula:
                'Na + 2.4 × ((Glucose − 100) / 100). May better reflect '
                'true Na in severe hyperglycaemia.',
          ),
          const FECalcGap(),
          FECalcInsightCard(
              title: ins!.title, body: ins.body, severity: ins.sev),
        ],
        const FECalcGap(16),
        const FECalcReferenceCard(
          text:
              'Reference: "Fluid and Electrolyte Formulae" — '
              'correction factor 1.6. Hillier (Am J Med 1999) showed a '
              'factor of 2.4 better fits dilutional change in '
              'hyperglycaemia > 400 mg/dL. For use by qualified clinicians '
              'only.',
        ),
      ],
    );
  }
}
