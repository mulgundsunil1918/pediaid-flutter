// =============================================================================
// dextrose_bolus_calculator.dart  —  Hypoglycaemia bolus
// D10 5 mL/kg PIV  /  D25 2 mL/kg CVL  /  D50 1 mL/kg CVL
// Glucose infusion 6–8 mg/kg/min of D10
// No IV: Glucagon 0.003 mg/kg, Epi 0.01 mg/kg IM/SQ
// If GIR > 10 mg/kg/min: diazoxide 3–8 mg/kg/day q 12 OR octreotide 10
// mcg/kg IV or SQ q 8 h
// =============================================================================

import 'package:flutter/material.dart';
import 'fluid_electrolyte_shared.dart';

class DextroseBolusCalculator extends StatefulWidget {
  const DextroseBolusCalculator({super.key});
  @override
  State<DextroseBolusCalculator> createState() =>
      _DextroseBolusCalculatorState();
}

class _DextroseBolusCalculatorState extends State<DextroseBolusCalculator> {
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
        'd10_mL': 5.0 * w,
        'd25_mL': 2.0 * w,
        'd50_mL': 1.0 * w,
        'gir_low_d10_mLhr': (6 * w * 60) / 100,
        'gir_high_d10_mLhr': (8 * w * 60) / 100,
        'glucagon_mg': 0.003 * w,
        'epi_mg': 0.01 * w,
        'diazoxide_low_mg': 3.0 * w,
        'diazoxide_high_mg': 8.0 * w,
        'octreotide_mcg': 10.0 * w,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return FECalcScaffold(
      title: 'Hypoglycaemia Management (↓Glu)',
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
          label: 'Calculate dextrose bolus + maintenance',
          icon: Icons.calculate,
          enabled: _ready,
          onPressed: _compute,
        ),
        if (_r != null) ...[
          const FECalcGap(16),
          FECalcResultCard(
            label: '10% dextrose bolus (preferred — peripheral)',
            value: _r!['d10_mL']!.toStringAsFixed(0),
            unit: 'mL of 10% dextrose',
            formula: '5 mL/kg of 10% dextrose intravenous bolus = 0.5 g/kg dextrose. '
                'Safe through a peripheral intravenous line.',
          ),
          const FECalcGap(),
          FECalcResultCard(
            label: '25% dextrose bolus (central line only)',
            value: _r!['d25_mL']!.toStringAsFixed(0),
            unit: 'mL of 25% dextrose',
            formula: '2 mL/kg of 25% dextrose = 0.5 g/kg dextrose. '
                'Sclerosing — central venous line only.',
          ),
          const FECalcGap(),
          FECalcResultCard(
            label: '50% dextrose bolus (central line, adult-style)',
            value: _r!['d50_mL']!.toStringAsFixed(1),
            unit: 'mL of 50% dextrose',
            formula: '1 mL/kg of 50% dextrose = 0.5 g/kg dextrose. '
                'Sclerosing — central venous line only.',
          ),
          const FECalcGap(),
          FECalcResultCard(
            label: '10% dextrose maintenance infusion (glucose infusion rate 6–8 mg/kg/min)',
            value:
                '${_r!['gir_low_d10_mLhr']!.toStringAsFixed(1)} – ${_r!['gir_high_d10_mLhr']!.toStringAsFixed(1)}',
            unit: 'mL/hr of 10% dextrose',
            formula: 'Glucose infusion rate 6–8 mg/kg/min of 10% dextrose. '
                'Use the Glucose Infusion Rate (GIR) Calculator for two-stock mixing.',
          ),
          const FECalcGap(),
          FECalcResultCard(
            label: 'No intravenous access — intramuscular / subcutaneous rescue',
            value:
                'Glucagon ${_r!['glucagon_mg']!.toStringAsFixed(2)} mg  +  Adrenaline ${_r!['epi_mg']!.toStringAsFixed(2)} mg',
            unit: 'intramuscular / subcutaneous',
            formula:
                'Glucagon 0.003 mg/kg  +  Adrenaline (epinephrine) 0.01 mg/kg '
                'intramuscular or subcutaneous, as a bridge while intravenous '
                'access is established.',
          ),
          const FECalcGap(),
          FECalcResultCard(
            label: 'If requirement > 10 mg/kg/min — adjuncts',
            value:
                'Diazoxide ${_r!['diazoxide_low_mg']!.toStringAsFixed(0)}–${_r!['diazoxide_high_mg']!.toStringAsFixed(0)} mg/day  ·  Octreotide ${_r!['octreotide_mcg']!.toStringAsFixed(0)} mcg',
            unit: 'oral / intravenous',
            formula:
                'Diazoxide 3–8 mg/kg/day orally, divided every 12 h. '
                'Octreotide 10 mcg/kg intravenous or subcutaneous every 8 h. '
                'Work up hyperinsulinism (insulin, C-peptide, cortisol, growth '
                'hormone, free fatty acids, lactate, beta-hydroxybutyrate).',
          ),
          const FECalcGap(),
          const FECalcInsightCard(
            title: 'Critical labs (BEFORE giving glucose)',
            body:
                'Send the "critical sample" while hypoglycaemic: insulin, '
                'C-peptide, cortisol, GH, FFA, lactate, β-OHB, ammonia, '
                'LFTs, urine glucose + ketones, plasma amino acids, '
                'acylcarnitine profile, IGF-1. Without this sample, '
                'persistent hypoglycaemia is much harder to diagnose.',
            severity: FEInsightSeverity.danger,
          ),
        ],
        const FECalcGap(16),
        const FECalcReferenceCard(
          text:
              'Reference: "Electrolyte Corrections" — '
              '10% dextrose 5 mL/kg peripheral, 25% dextrose 2 mL/kg central line, '
              '50% dextrose 1 mL/kg central line. Infusion 6–8 mg/kg/min of 10% '
              'dextrose. No intravenous access: Glucagon 0.003 + Adrenaline 0.01 '
              'mg/kg intramuscular/subcutaneous. > 10 mg/kg/min: diazoxide 3–8 '
              'mg/kg/day every 12 h or octreotide 10 mcg/kg intravenous/subcutaneous '
              'every 8 h. For use by qualified clinicians only.',
        ),
      ],
    );
  }
}
