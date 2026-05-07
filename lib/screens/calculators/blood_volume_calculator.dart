// =============================================================================
// blood_volume_calculator.dart  —  Estimated blood volume
// Source: Neonate 85 mL/kg, Adult 65 mL/kg. Extended for paediatric ages.
// =============================================================================

import 'package:flutter/material.dart';
import 'fluid_electrolyte_shared.dart';

class _AgeBand {
  final String label;
  final String range;
  final double mlPerKg;
  const _AgeBand(this.label, this.range, this.mlPerKg);
}

const List<_AgeBand> _bands = [
  _AgeBand('Preterm', 'Preterm neonate', 95),
  _AgeBand('Term neonate', '0 – 1 month (term)', 85),
  _AgeBand('Infant', '1 – 12 months', 80),
  _AgeBand('Child', '1 – 12 years', 70),
  _AgeBand('Adolescent / Adult', '> 12 years', 65),
];

class BloodVolumeCalculator extends StatefulWidget {
  const BloodVolumeCalculator({super.key});
  @override
  State<BloodVolumeCalculator> createState() => _BloodVolumeCalculatorState();
}

class _BloodVolumeCalculatorState extends State<BloodVolumeCalculator> {
  final _wt = TextEditingController();
  _AgeBand _band = _bands[1];
  double? _result;

  @override
  void dispose() {
    _wt.dispose();
    super.dispose();
  }

  bool get _ready =>
      double.tryParse(_wt.text) != null && double.parse(_wt.text) > 0;

  void _calc() {
    final w = double.parse(_wt.text);
    setState(() => _result = w * _band.mlPerKg);
  }

  @override
  Widget build(BuildContext context) {
    return FECalcScaffold(
      title: 'Blood Volume',
      children: [
        FECalcInputCard(
          label: 'Patient',
          child: Column(children: [
            FECalcNumberField(
                label: 'Weight',
                unit: 'kg',
                hint: 'e.g. 12',
                controller: _wt,
                onChanged: (_) => setState(() {})),
            const FECalcGap(),
            const Text('AGE BAND',
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3)),
            const FECalcGap(6),
            ..._bands.map((b) => RadioListTile<_AgeBand>(
                  value: b,
                  groupValue: _band,
                  onChanged: (v) => setState(() => _band = v!),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text('${b.label} — ${b.mlPerKg.toInt()} mL/kg',
                      style: const TextStyle(fontSize: 13)),
                  subtitle: Text(b.range,
                      style: const TextStyle(fontSize: 11.5)),
                )),
          ]),
        ),
        const FECalcGap(16),
        FECalcButton(
          label: 'Calculate Blood Volume',
          icon: Icons.bloodtype,
          enabled: _ready,
          onPressed: _calc,
        ),
        if (_result != null) ...[
          const FECalcGap(16),
          FECalcResultCard(
            label: 'Estimated blood volume (EBV)',
            value: _result!.toStringAsFixed(0),
            unit: 'mL',
            formula: 'EBV = weight (kg) × ${_band.mlPerKg.toInt()} mL/kg',
          ),
          const FECalcGap(),
          FECalcInsightCard(
            title: 'Useful clinical thresholds',
            body:
                '• 10 % of EBV (${(_result! * 0.10).toStringAsFixed(0)} mL) — '
                'safe single-draw / starting transfusion volume.\n'
                '• 15 % of EBV (${(_result! * 0.15).toStringAsFixed(0)} mL) — '
                'haemorrhagic shock threshold; prepare blood.\n'
                '• Maximum allowable blood loss (MABL) calculation:\n'
                '   MABL = EBV × (Hct₀ − Hct_min) / Hct_avg.',
            severity: FEInsightSeverity.info,
          ),
        ],
        const FECalcGap(16),
        const FECalcReferenceCard(
          text:
              'Reference: "Fluid and Electrolyte Formulae" — '
              'Neonate 85 mL/kg, Adult 65 mL/kg. Intermediate ages per '
              'Coté & Lerman Practice of Anesthesia for Infants and '
              'Children, 6th ed. Patient ranges shown are typical; verify '
              'against the patient\'s clinical context.',
        ),
      ],
    );
  }
}
