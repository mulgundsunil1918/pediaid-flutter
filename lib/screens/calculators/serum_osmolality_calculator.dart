// =============================================================================
// serum_osmolality_calculator.dart
// Calculated osm = 2(Na⁺) + Glucose(mg/dL)/18 + BUN(mg/dL)/2.8
// Normal serum osmolality 270–295 mOsm/kg.
// Optional measured osmolality field → osmolar gap.
// =============================================================================

import 'package:flutter/material.dart';
import 'fluid_electrolyte_shared.dart';

class SerumOsmolalityCalculator extends StatefulWidget {
  const SerumOsmolalityCalculator({super.key});
  @override
  State<SerumOsmolalityCalculator> createState() =>
      _SerumOsmolalityCalculatorState();
}

class _SerumOsmolalityCalculatorState extends State<SerumOsmolalityCalculator> {
  final _na = TextEditingController();
  final _glu = TextEditingController();
  final _bun = TextEditingController();
  final _measured = TextEditingController();
  double? _calc;
  double? _gap;

  @override
  void dispose() {
    _na.dispose();
    _glu.dispose();
    _bun.dispose();
    _measured.dispose();
    super.dispose();
  }

  bool get _ready =>
      double.tryParse(_na.text) != null &&
      double.tryParse(_glu.text) != null &&
      double.tryParse(_bun.text) != null;

  void _compute() {
    final na = double.parse(_na.text);
    final glu = double.parse(_glu.text);
    final bun = double.parse(_bun.text);
    final calc = 2 * na + glu / 18 + bun / 2.8;
    final m = double.tryParse(_measured.text);
    setState(() {
      _calc = calc;
      _gap = (m != null) ? (m - calc) : null;
    });
  }

  ({String title, String body, FEInsightSeverity sev}) _interpret(double o) {
    if (o < 270) {
      return (
        title: 'Hypo-osmolar (< 270 mOsm/kg)',
        body: 'Consider hyponatraemia, water intoxication, SIADH. Watch for '
            'cerebral oedema with rapid correction.',
        sev: FEInsightSeverity.warning,
      );
    } else if (o <= 295) {
      return (
        title: 'Normal (270–295 mOsm/kg)',
        body: 'No osmolar disturbance.',
        sev: FEInsightSeverity.good,
      );
    } else {
      return (
        title: 'Hyperosmolar (> 295 mOsm/kg)',
        body: 'Consider dehydration, hypernatraemia, hyperglycaemia (DKA/HHS), '
            'mannitol therapy. Correct slowly to avoid cerebral oedema.',
        sev: FEInsightSeverity.danger,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ins = _calc == null ? null : _interpret(_calc!);
    return FECalcScaffold(
      title: 'Serum Osmolality',
      children: [
        FECalcInputCard(
          label: 'Required',
          child: Column(children: [
            FECalcNumberField(
                label: 'Sodium (Na⁺)',
                unit: 'mEq/L',
                hint: 'e.g. 140',
                controller: _na,
                onChanged: (_) => setState(() {})),
            const FECalcGap(),
            FECalcNumberField(
                label: 'Glucose',
                unit: 'mg/dL',
                hint: 'e.g. 100',
                controller: _glu,
                onChanged: (_) => setState(() {})),
            const FECalcGap(),
            FECalcNumberField(
                label: 'BUN',
                unit: 'mg/dL',
                hint: 'e.g. 14',
                controller: _bun,
                onChanged: (_) => setState(() {})),
          ]),
        ),
        const FECalcGap(),
        FECalcInputCard(
          label: 'Optional — measured osmolality (for osmolar gap)',
          child: FECalcNumberField(
              label: 'Measured serum osmolality',
              unit: 'mOsm/kg',
              hint: 'e.g. 295',
              controller: _measured,
              onChanged: (_) => setState(() {})),
        ),
        const FECalcGap(16),
        FECalcButton(
          label: 'Calculate Osmolality',
          icon: Icons.calculate,
          enabled: _ready,
          onPressed: _compute,
        ),
        if (_calc != null) ...[
          const FECalcGap(16),
          FECalcResultCard(
            label: 'Calculated osmolality',
            value: _calc!.toStringAsFixed(0),
            unit: 'mOsm/kg',
            formula: '2 × Na + Glucose / 18 + BUN / 2.8',
          ),
          if (_gap != null) ...[
            const FECalcGap(),
            FECalcResultCard(
              label: 'Osmolar gap (measured − calculated)',
              value: _gap!.toStringAsFixed(1),
              unit: 'mOsm/kg',
              formula: 'Normal: < 10. > 10 → suspect toxic alcohol '
                  '(methanol, ethylene glycol, isopropanol).',
            ),
          ],
          const FECalcGap(),
          FECalcInsightCard(
              title: ins!.title, body: ins.body, severity: ins.sev),
        ],
        const FECalcGap(16),
        const FECalcReferenceCard(
          text:
              'Reference: "Fluid and Electrolyte Formulae" — '
              'normal serum osmolality 270–295 mOsm/kg. Osmolar-gap toxic '
              'alcohol screen per Goldfrank Toxicologic Emergencies, 11th '
              'ed. Use total Na (not corrected). For use by qualified '
              'clinicians only.',
        ),
      ],
    );
  }
}
