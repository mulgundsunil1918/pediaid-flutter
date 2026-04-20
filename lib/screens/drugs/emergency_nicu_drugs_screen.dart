// ============================================================
//  emergency_nicu_drugs_screen.dart
//  Emergency NICU Drugs — Weight-based Preparation Guide
// ============================================================

// ── Imports ───────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'emergency/current_infusions.dart';
import 'emergency/resuscitation_sheet.dart';
import 'emergency/drug_extras.dart';
import 'emergency/advanced_tools.dart';

// ── Data Enums ────────────────────────────────────────────────────────────────

enum _DrugCategory {
  inotrope,
  vasoactive,
  sedation,
  analgesic,
  diuretic,
  vasodilator,
  prostaglandin,
}

enum _DilutionKind { weightBased, fixed, special }

// ── Data Classes ──────────────────────────────────────────────────────────────

class _RateRow {
  final String rate;
  final String dose;
  final bool isStandard;
  const _RateRow(this.rate, this.dose, {this.isStandard = false});
}

class _DrugData {
  final String name;
  final _DrugCategory category;
  final String vialConc;
  final _DilutionKind kind;
  final double? dilutionFactor;
  final double? vialMgPerMl;
  final double? standardTotalMl;
  final String diluent;
  final String startingRateLabel;
  final String doseRange;
  final String? specialNote;
  final bool concentrationMultiplierApplies;

  const _DrugData({
    required this.name,
    required this.category,
    required this.vialConc,
    required this.kind,
    this.dilutionFactor,
    this.vialMgPerMl,
    this.standardTotalMl,
    required this.diluent,
    required this.startingRateLabel,
    required this.doseRange,
    this.specialNote,
    required this.concentrationMultiplierApplies,
  });
}

class _Preparation {
  final String drugLine;
  final String diluentLine;
  final String finalConcLine;
  final String rateAtStart;
  final String? warning;
  final double drugMl;
  final double diluentMl;
  final double totalMl;
  final double finalConcMcgPerMl;
  final List<_RateRow> rates;
  final String? unitNote;

  const _Preparation({
    required this.drugLine,
    required this.diluentLine,
    required this.finalConcLine,
    required this.rateAtStart,
    this.warning,
    required this.drugMl,
    required this.diluentMl,
    required this.totalMl,
    required this.finalConcMcgPerMl,
    required this.rates,
    this.unitNote,
  });
}

// ── Drug List ─────────────────────────────────────────────────────────────────

const List<_DrugData> _drugs = [
  // 1 — Dopamine
  _DrugData(
    name: 'Dopamine',
    category: _DrugCategory.inotrope,
    vialConc: '1 ml = 40 mg',
    kind: _DilutionKind.weightBased,
    dilutionFactor: 15,
    vialMgPerMl: 40,
    standardTotalMl: 24,
    diluent: 'NS',
    startingRateLabel: '1 ml/hr = 10 mcg/kg/min',
    doseRange: '5–20 mcg/kg/min',
    concentrationMultiplierApplies: true,
  ),
  // 2 — Dobutamine
  _DrugData(
    name: 'Dobutamine',
    category: _DrugCategory.inotrope,
    vialConc: '1 ml = 50 mg',
    kind: _DilutionKind.weightBased,
    dilutionFactor: 15,
    vialMgPerMl: 50,
    standardTotalMl: 24,
    diluent: 'NS',
    startingRateLabel: '1 ml/hr = 10 mcg/kg/min',
    doseRange: '5–20 mcg/kg/min',
    concentrationMultiplierApplies: true,
  ),
  // 3 — Adrenaline
  _DrugData(
    name: 'Adrenaline (Epinephrine)',
    category: _DrugCategory.vasoactive,
    vialConc: '1 ml = 1 mg',
    kind: _DilutionKind.weightBased,
    dilutionFactor: 1.5,
    vialMgPerMl: 1,
    standardTotalMl: 24,
    diluent: 'NS',
    startingRateLabel: '0.1 ml/hr = 0.1 mcg/kg/min',
    doseRange: '0.1–1.0 mcg/kg/min',
    concentrationMultiplierApplies: true,
  ),
  // 4 — Noradrenaline
  _DrugData(
    name: 'Noradrenaline (Norepinephrine)',
    category: _DrugCategory.vasoactive,
    vialConc: '1 ml = 1 mg',
    kind: _DilutionKind.weightBased,
    dilutionFactor: 1.5,
    vialMgPerMl: 1,
    standardTotalMl: 24,
    diluent: 'NS',
    startingRateLabel: '0.1 ml/hr = 0.1 mcg/kg/min',
    doseRange: '0.1–0.3 mcg/kg/min',
    concentrationMultiplierApplies: true,
  ),
  // 5 — Milrinone
  _DrugData(
    name: 'Milrinone',
    category: _DrugCategory.inotrope,
    vialConc: '1 ml = 1 mg',
    kind: _DilutionKind.weightBased,
    dilutionFactor: 1.5,
    vialMgPerMl: 1,
    standardTotalMl: 50,
    diluent: 'NS',
    startingRateLabel: '1.0 ml/hr = 0.5 mcg/kg/min',
    doseRange: '0.5–1.0 mcg/kg/min',
    concentrationMultiplierApplies: true,
  ),
  // 6 — Fentanyl
  _DrugData(
    name: 'Fentanyl',
    category: _DrugCategory.analgesic,
    vialConc: '1 ml = 50 mcg',
    kind: _DilutionKind.fixed,
    standardTotalMl: 10,
    diluent: 'NS',
    startingRateLabel: '(0.1 × W) ml/hr = 1 mcg/kg/hr',
    doseRange: '1–5 mcg/kg/hr',
    concentrationMultiplierApplies: false,
  ),
  // 7 — Vasopressin
  _DrugData(
    name: 'Vasopressin',
    category: _DrugCategory.vasoactive,
    vialConc: '1 ml = 20 units',
    kind: _DilutionKind.weightBased,
    dilutionFactor: 1.5,
    vialMgPerMl: 20,
    standardTotalMl: 10,
    diluent: 'NS',
    startingRateLabel: '0.2 ml/hr = 0.0005 units/kg/min',
    doseRange: '0.0003–0.002 units/kg/min',
    concentrationMultiplierApplies: true,
  ),
  // 8 — Morphine
  _DrugData(
    name: 'Morphine',
    category: _DrugCategory.analgesic,
    vialConc: 'Various strengths',
    kind: _DilutionKind.special,
    diluent: 'Per protocol',
    startingRateLabel: 'Per unit protocol',
    doseRange: '0.01–0.02 mg/kg/hr',
    specialNote:
        'Dose: 0.01–0.02 mg/kg/hr. Prepare as per your unit protocol. Confirm concentration with pharmacy before use.',
    concentrationMultiplierApplies: false,
  ),
  // 9 — PGE1
  _DrugData(
    name: 'PGE1 (Alprostadil)',
    category: _DrugCategory.prostaglandin,
    vialConc: '1 amp = 500 mcg',
    kind: _DilutionKind.fixed,
    standardTotalMl: 50,
    diluent: '5% Dextrose',
    startingRateLabel: '(0.6 × W) ml/hr = 0.1 mcg/kg/min',
    doseRange: '0.1–0.4 mcg/kg/min',
    specialNote:
        'Use 5% Dextrose ONLY — NOT normal saline. Start at lowest effective dose. Apnoea risk — be prepared for intubation.',
    concentrationMultiplierApplies: false,
  ),
  // 10 — Midazolam
  _DrugData(
    name: 'Midazolam',
    category: _DrugCategory.sedation,
    vialConc: '1 ml = 1 mg',
    kind: _DilutionKind.weightBased,
    dilutionFactor: 3,
    vialMgPerMl: 1,
    standardTotalMl: 24,
    diluent: 'NS or SW',
    startingRateLabel: 'Sedation / Seizures — see sub-ranges',
    doseRange: '0.01–0.4 mg/kg/hr',
    concentrationMultiplierApplies: true,
  ),
  // 11 — Furosemide
  _DrugData(
    name: 'Furosemide (Lasix)',
    category: _DrugCategory.diuretic,
    vialConc: '1 ml = 10 mg',
    kind: _DilutionKind.fixed,
    standardTotalMl: 10,
    diluent: 'NS',
    startingRateLabel: '(0.1 × W) ml/hr = 0.1 mg/kg/hr',
    doseRange: '0.1–1 mg/kg/hr',
    concentrationMultiplierApplies: false,
  ),
  // 12 — Ketamine
  _DrugData(
    name: 'Ketamine',
    category: _DrugCategory.sedation,
    vialConc: '1 ml = 50 mg',
    kind: _DilutionKind.fixed,
    standardTotalMl: 50,
    diluent: 'NS',
    startingRateLabel: '(0.5 × W) ml/hr = 0.5 mg/kg/hr',
    doseRange: '0.05–1.2 mg/kg/hr',
    concentrationMultiplierApplies: false,
  ),
  // 13 — Dexmedetomidine
  _DrugData(
    name: 'Dexmedetomidine',
    category: _DrugCategory.sedation,
    vialConc: '1 ml = 100 mcg',
    kind: _DilutionKind.fixed,
    standardTotalMl: 10,
    diluent: 'NS',
    startingRateLabel: '(0.05 × W) ml/hr = 0.5 mcg/kg/hr',
    doseRange: '0.5–1.0 mcg/kg/hr',
    concentrationMultiplierApplies: false,
  ),
  // 14 — Sildenafil
  _DrugData(
    name: 'Sildenafil',
    category: _DrugCategory.vasodilator,
    vialConc: '1 ml = 0.8 mg',
    kind: _DilutionKind.special,
    diluent: '5% Dextrose or neat',
    startingRateLabel: 'Loading then maintenance — see sub-phases',
    doseRange: 'Loading: 0.4 mg/kg; Maintenance: 1.6 mg/kg/day',
    concentrationMultiplierApplies: false,
  ),
];

// ── Compute Functions ──────────────────────────────────────────────────────────

String _fmt(double v, {int decimals = 2}) {
  if (v.isNaN || v.isInfinite) return '—';
  return v.toStringAsFixed(decimals);
}

_Preparation _computePrep(
  _DrugData drug,
  double weight,
  double multiplier,
  double? overrideTotalMl,
) {
  if (drug.kind == _DilutionKind.special) {
    return const _Preparation(
      drugLine: '',
      diluentLine: '',
      finalConcLine: '',
      rateAtStart: '',
      drugMl: 0,
      diluentMl: 0,
      totalMl: 0,
      finalConcMcgPerMl: 0,
      rates: [],
    );
  }

  final double totalVol =
      overrideTotalMl ?? drug.standardTotalMl ?? 24;

  switch (drug.name) {
    // ── Dopamine ──────────────────────────────────────────────────────────────
    case 'Dopamine':
      {
        final drugDose = drug.dilutionFactor! * weight; // mg
        final drugMl = (drugDose / drug.vialMgPerMl!) * multiplier;
        final dilMl = totalVol - drugMl;
        final finalConc = (drugDose * multiplier * 1000) / totalVol;
        String? warning;
        if (drugMl > totalVol) {
          warning =
              'Cannot make ${_fmt(multiplier, decimals: 1)}x — drug volume (${_fmt(drugMl)} ml) exceeds syringe volume (${_fmt(totalVol)} ml). Consider a larger total volume.';
        }
        final baseRates = [0.5, 1.0, 1.5, 2.0];
        final baseDoses = ['5 mcg/kg/min', '10 mcg/kg/min', '15 mcg/kg/min', '20 mcg/kg/min'];
        final rates = List.generate(4, (i) {
          final r = baseRates[i] / multiplier;
          return _RateRow(
            '${_fmt(r)} ml/hr',
            baseDoses[i],
            isStandard: i == 1,
          );
        });
        return _Preparation(
          drugLine:
              'Take ${_fmt(drugMl)} ml of Dopamine (${_fmt(drugDose)} mg)',
          diluentLine:
              'Add ${_fmt(dilMl)} ml of NS to make ${_fmt(totalVol)} ml',
          finalConcLine: 'Final: ${_fmt(finalConc, decimals: 1)} mcg per ml',
          rateAtStart:
              '${_fmt(1.0 / multiplier)} ml/hr for 10 mcg/kg/min',
          warning: warning,
          drugMl: drugMl,
          diluentMl: dilMl,
          totalMl: totalVol,
          finalConcMcgPerMl: finalConc,
          rates: rates,
        );
      }

    // ── Dobutamine ────────────────────────────────────────────────────────────
    case 'Dobutamine':
      {
        final drugDose = drug.dilutionFactor! * weight;
        final drugMl = (drugDose / drug.vialMgPerMl!) * multiplier;
        final dilMl = totalVol - drugMl;
        final finalConc = (drugDose * multiplier * 1000) / totalVol;
        String? warning;
        if (drugMl > totalVol) {
          warning =
              'Cannot make ${_fmt(multiplier, decimals: 1)}x — drug volume (${_fmt(drugMl)} ml) exceeds syringe volume (${_fmt(totalVol)} ml). Consider a larger total volume.';
        }
        final baseRates = [0.5, 1.0, 1.5, 2.0];
        final baseDoses = ['5 mcg/kg/min', '10 mcg/kg/min', '15 mcg/kg/min', '20 mcg/kg/min'];
        final rates = List.generate(4, (i) {
          final r = baseRates[i] / multiplier;
          return _RateRow(
            '${_fmt(r)} ml/hr',
            baseDoses[i],
            isStandard: i == 1,
          );
        });
        return _Preparation(
          drugLine:
              'Take ${_fmt(drugMl)} ml of Dobutamine (${_fmt(drugDose)} mg)',
          diluentLine:
              'Add ${_fmt(dilMl)} ml of NS to make ${_fmt(totalVol)} ml',
          finalConcLine: 'Final: ${_fmt(finalConc, decimals: 1)} mcg per ml',
          rateAtStart:
              '${_fmt(1.0 / multiplier)} ml/hr for 10 mcg/kg/min',
          warning: warning,
          drugMl: drugMl,
          diluentMl: dilMl,
          totalMl: totalVol,
          finalConcMcgPerMl: finalConc,
          rates: rates,
        );
      }

    // ── Adrenaline ────────────────────────────────────────────────────────────
    case 'Adrenaline (Epinephrine)':
      {
        final drugDose = drug.dilutionFactor! * weight; // mg
        final drugMl = (drugDose / drug.vialMgPerMl!) * multiplier;
        final dilMl = totalVol - drugMl;
        final finalConc = (drugDose * multiplier * 1000) / totalVol;
        String? warning;
        if (drugMl > totalVol) {
          warning =
              'Cannot make ${_fmt(multiplier, decimals: 1)}x — drug volume (${_fmt(drugMl)} ml) exceeds syringe volume (${_fmt(totalVol)} ml). Consider a larger total volume.';
        }
        final baseRates = [0.1, 0.5, 1.0];
        final baseDoses = ['0.1 mcg/kg/min', '0.5 mcg/kg/min', '1.0 mcg/kg/min'];
        final rates = List.generate(3, (i) {
          final r = baseRates[i] / multiplier;
          return _RateRow(
            '${_fmt(r)} ml/hr',
            baseDoses[i],
            isStandard: i == 0,
          );
        });
        return _Preparation(
          drugLine:
              'Take ${_fmt(drugMl)} ml of Adrenaline (${_fmt(drugDose)} mg)',
          diluentLine:
              'Add ${_fmt(dilMl)} ml of NS to make ${_fmt(totalVol)} ml',
          finalConcLine: 'Final: ${_fmt(finalConc, decimals: 3)} mcg per ml',
          rateAtStart:
              '${_fmt(0.1 / multiplier)} ml/hr for 0.1 mcg/kg/min',
          warning: warning,
          drugMl: drugMl,
          diluentMl: dilMl,
          totalMl: totalVol,
          finalConcMcgPerMl: finalConc,
          rates: rates,
        );
      }

    // ── Noradrenaline ─────────────────────────────────────────────────────────
    case 'Noradrenaline (Norepinephrine)':
      {
        final drugDose = drug.dilutionFactor! * weight;
        final drugMl = (drugDose / drug.vialMgPerMl!) * multiplier;
        final dilMl = totalVol - drugMl;
        final finalConc = (drugDose * multiplier * 1000) / totalVol;
        String? warning;
        if (drugMl > totalVol) {
          warning =
              'Cannot make ${_fmt(multiplier, decimals: 1)}x — drug volume (${_fmt(drugMl)} ml) exceeds syringe volume (${_fmt(totalVol)} ml). Consider a larger total volume.';
        }
        final baseRates = [0.1, 0.2, 0.3];
        final baseDoses = ['0.1 mcg/kg/min', '0.2 mcg/kg/min', '0.3 mcg/kg/min'];
        final rates = List.generate(3, (i) {
          final r = baseRates[i] / multiplier;
          return _RateRow(
            '${_fmt(r)} ml/hr',
            baseDoses[i],
            isStandard: i == 0,
          );
        });
        return _Preparation(
          drugLine:
              'Take ${_fmt(drugMl)} ml of Noradrenaline (${_fmt(drugDose)} mg)',
          diluentLine:
              'Add ${_fmt(dilMl)} ml of NS to make ${_fmt(totalVol)} ml',
          finalConcLine: 'Final: ${_fmt(finalConc, decimals: 3)} mcg per ml',
          rateAtStart:
              '${_fmt(0.1 / multiplier)} ml/hr for 0.1 mcg/kg/min',
          warning: warning,
          drugMl: drugMl,
          diluentMl: dilMl,
          totalMl: totalVol,
          finalConcMcgPerMl: finalConc,
          rates: rates,
        );
      }

    // ── Milrinone ─────────────────────────────────────────────────────────────
    case 'Milrinone':
      {
        final drugDose = drug.dilutionFactor! * weight; // mg
        final drugMl = (drugDose / drug.vialMgPerMl!) * multiplier;
        final dilMl = totalVol - drugMl;
        final finalConc = (drugDose * multiplier * 1000) / totalVol;
        String? warning;
        if (drugMl > totalVol) {
          warning =
              'Cannot make ${_fmt(multiplier, decimals: 1)}x — drug volume (${_fmt(drugMl)} ml) exceeds syringe volume (${_fmt(totalVol)} ml). Consider a larger total volume.';
        }
        final baseRates = [1.0, 2.0];
        final baseDoses = ['0.5 mcg/kg/min', '1.0 mcg/kg/min'];
        final rates = List.generate(2, (i) {
          final r = baseRates[i] / multiplier;
          return _RateRow(
            '${_fmt(r)} ml/hr',
            baseDoses[i],
            isStandard: i == 0,
          );
        });
        return _Preparation(
          drugLine:
              'Take ${_fmt(drugMl)} ml of Milrinone (${_fmt(drugDose)} mg)',
          diluentLine:
              'Add ${_fmt(dilMl)} ml of NS to make ${_fmt(totalVol)} ml',
          finalConcLine: 'Final: ${_fmt(finalConc, decimals: 2)} mcg per ml',
          rateAtStart: '${_fmt(1.0 / multiplier)} ml/hr for 0.5 mcg/kg/min',
          warning: warning,
          drugMl: drugMl,
          diluentMl: dilMl,
          totalMl: totalVol,
          finalConcMcgPerMl: finalConc,
          rates: rates,
        );
      }

    // ── Fentanyl (fixed) ──────────────────────────────────────────────────────
    case 'Fentanyl':
      {
        const double fDrugMl = 2.0;
        const double fDilMl = 8.0;
        const double fTotal = 10.0;
        const double fFinalConc = 10.0; // 10 mcg/ml
        final rates = [
          _RateRow(
            '${_fmt(0.1 * weight)} ml/hr',
            '1 mcg/kg/hr',
            isStandard: true,
          ),
          _RateRow('${_fmt(0.2 * weight)} ml/hr', '2 mcg/kg/hr'),
          _RateRow('${_fmt(0.3 * weight)} ml/hr', '3 mcg/kg/hr'),
          _RateRow('${_fmt(0.5 * weight)} ml/hr', '5 mcg/kg/hr'),
        ];
        return _Preparation(
          drugLine: 'Take 2 ml of Fentanyl (100 mcg)',
          diluentLine: 'Add 8 ml of NS to make 10 ml',
          finalConcLine: 'Final: 10 mcg per ml',
          rateAtStart:
              '${_fmt(0.1 * weight)} ml/hr for 1 mcg/kg/hr',
          drugMl: fDrugMl,
          diluentMl: fDilMl,
          totalMl: fTotal,
          finalConcMcgPerMl: fFinalConc,
          rates: rates,
        );
      }

    // ── Vasopressin ───────────────────────────────────────────────────────────
    case 'Vasopressin':
      {
        final drugDoseUnits = drug.dilutionFactor! * weight; // units
        final drugMl = (drugDoseUnits / drug.vialMgPerMl!) * multiplier;
        final double useTotal = overrideTotalMl ?? 10.0;
        final dilMl = useTotal - drugMl;
        final finalConc = (drugDoseUnits * multiplier) / useTotal;
        String? warning;
        if (drugMl > useTotal) {
          warning =
              'Cannot make ${_fmt(multiplier, decimals: 1)}x — drug volume (${_fmt(drugMl)} ml) exceeds syringe volume (${_fmt(useTotal)} ml).';
        }
        final rates = [
          _RateRow(
            '${_fmt(0.2 / multiplier)} ml/hr',
            '0.0005 units/kg/min',
            isStandard: true,
          ),
        ];
        return _Preparation(
          drugLine:
              'Take ${_fmt(drugMl)} ml of Vasopressin (${_fmt(drugDoseUnits)} units)',
          diluentLine:
              'Add ${_fmt(dilMl)} ml of NS to make ${_fmt(useTotal)} ml',
          finalConcLine:
              'Final: ${_fmt(finalConc, decimals: 4)} units per ml',
          rateAtStart:
              '${_fmt(0.2 / multiplier)} ml/hr for 0.0005 units/kg/min',
          warning: warning,
          drugMl: drugMl,
          diluentMl: dilMl,
          totalMl: useTotal,
          finalConcMcgPerMl: finalConc,
          rates: rates,
          unitNote: 'units/ml',
        );
      }

    // ── Midazolam ─────────────────────────────────────────────────────────────
    case 'Midazolam':
      {
        final drugDose = drug.dilutionFactor! * weight; // mg (3×W)
        final drugMl = (drugDose / drug.vialMgPerMl!) * multiplier;
        final dilMl = totalVol - drugMl;
        final finalMgPerMl = (drugDose * multiplier) / totalVol;
        String? warning;
        if (drugMl > totalVol) {
          warning =
              'Cannot make ${_fmt(multiplier, decimals: 1)}x — drug volume (${_fmt(drugMl)} ml) exceeds syringe volume (${_fmt(totalVol)} ml).';
        }
        // Sedation rates
        // rate = dose(mg/kg/hr) × W / finalMgPerMl
        // 0.01 mg/kg/hr: rate = 0.01×W/finalMgPerMl = 0.01/(multiplier×0.125)
        // With 3×W in 24ml base: finalMgPerMl at 1x = 3W/24 = 0.125×W... per ml
        // simplified: rate = (dose / (3×multiplier/24)) = dose×24/(3×multiplier) = dose×8/multiplier
        final rates = [
          _RateRow(
            '${_fmt(0.08 / multiplier)} ml/hr',
            '0.01 mg/kg/hr (sedation start)',
            isStandard: true,
          ),
          _RateRow(
            '${_fmt(0.48 / multiplier)} ml/hr',
            '0.06 mg/kg/hr (sedation max / seizure start)',
          ),
          _RateRow(
            '${_fmt(0.80 / multiplier)} ml/hr',
            '0.10 mg/kg/hr (seizure)',
          ),
          _RateRow(
            '${_fmt(3.20 / multiplier)} ml/hr',
            '0.40 mg/kg/hr (seizure max)',
          ),
        ];
        return _Preparation(
          drugLine:
              'Take ${_fmt(drugMl)} ml of Midazolam (${_fmt(drugDose)} mg)',
          diluentLine:
              'Add ${_fmt(dilMl)} ml of ${drug.diluent} to make ${_fmt(totalVol)} ml',
          finalConcLine:
              'Final: ${_fmt(finalMgPerMl, decimals: 3)} mg per ml',
          rateAtStart: 'Sedation: ${_fmt(0.08 / multiplier)} ml/hr',
          warning: warning,
          drugMl: drugMl,
          diluentMl: dilMl,
          totalMl: totalVol,
          finalConcMcgPerMl: finalMgPerMl * 1000,
          rates: rates,
          unitNote: 'mg/ml',
        );
      }

    // ── PGE1 (fixed) ──────────────────────────────────────────────────────────
    case 'PGE1 (Alprostadil)':
      {
        const double fDrugMl = 1.0;
        const double fDilMl = 49.0;
        const double fTotal = 50.0;
        const double fFinalConc = 10.0; // mcg/ml
        final rates = [
          _RateRow(
            '${_fmt(0.6 * weight)} ml/hr',
            '0.1 mcg/kg/min',
            isStandard: true,
          ),
          _RateRow('${_fmt(1.2 * weight)} ml/hr', '0.2 mcg/kg/min'),
          _RateRow('${_fmt(1.8 * weight)} ml/hr', '0.3 mcg/kg/min'),
          _RateRow(
            '${_fmt(2.4 * weight)} ml/hr',
            '0.4 mcg/kg/min (maximum)',
          ),
        ];
        return _Preparation(
          drugLine: 'Take 1 amp of Alprostadil (500 mcg)',
          diluentLine: 'Add 49 ml of 5% Dextrose to make 50 ml',
          finalConcLine: 'Final: 10 mcg per ml',
          rateAtStart:
              '${_fmt(0.6 * weight)} ml/hr for 0.1 mcg/kg/min',
          drugMl: fDrugMl,
          diluentMl: fDilMl,
          totalMl: fTotal,
          finalConcMcgPerMl: fFinalConc,
          rates: rates,
        );
      }

    // ── Furosemide (fixed) ────────────────────────────────────────────────────
    case 'Furosemide (Lasix)':
      {
        const double fDrugMl = 1.0;
        const double fDilMl = 9.0;
        const double fTotal = 10.0;
        const double fFinalConc = 1.0; // mg/ml
        final rates = [
          _RateRow(
            '${_fmt(0.1 * weight)} ml/hr',
            '0.1 mg/kg/hr',
            isStandard: true,
          ),
          _RateRow('${_fmt(0.5 * weight)} ml/hr', '0.5 mg/kg/hr'),
          _RateRow(
            '${_fmt(1.0 * weight)} ml/hr',
            '1.0 mg/kg/hr (maximum)',
          ),
        ];
        return _Preparation(
          drugLine: 'Take 1 ml of Furosemide (10 mg)',
          diluentLine: 'Add 9 ml of NS to make 10 ml',
          finalConcLine: 'Final: 1 mg per ml',
          rateAtStart: '${_fmt(0.1 * weight)} ml/hr for 0.1 mg/kg/hr',
          drugMl: fDrugMl,
          diluentMl: fDilMl,
          totalMl: fTotal,
          finalConcMcgPerMl: fFinalConc * 1000,
          rates: rates,
          unitNote: 'mg/ml',
        );
      }

    // ── Ketamine (fixed) ──────────────────────────────────────────────────────
    case 'Ketamine':
      {
        const double fDrugMl = 1.0;
        const double fDilMl = 49.0;
        const double fTotal = 50.0;
        const double fFinalConc = 1.0; // mg/ml
        final rates = [
          _RateRow('${_fmt(0.05 * weight)} ml/hr', '0.05 mg/kg/hr'),
          _RateRow(
            '${_fmt(0.5 * weight)} ml/hr',
            '0.5 mg/kg/hr',
            isStandard: true,
          ),
          _RateRow('${_fmt(1.0 * weight)} ml/hr', '1.0 mg/kg/hr'),
          _RateRow(
            '${_fmt(1.2 * weight)} ml/hr',
            '1.2 mg/kg/hr (maximum)',
          ),
        ];
        return _Preparation(
          drugLine: 'Take 1 ml of Ketamine (50 mg)',
          diluentLine: 'Add 49 ml of NS to make 50 ml',
          finalConcLine: 'Final: 1 mg per ml',
          rateAtStart: '${_fmt(0.5 * weight)} ml/hr for 0.5 mg/kg/hr',
          drugMl: fDrugMl,
          diluentMl: fDilMl,
          totalMl: fTotal,
          finalConcMcgPerMl: fFinalConc * 1000,
          rates: rates,
          unitNote: 'mg/ml',
        );
      }

    // ── Dexmedetomidine (fixed) ───────────────────────────────────────────────
    case 'Dexmedetomidine':
      {
        const double fDrugMl = 1.0;
        const double fDilMl = 9.0;
        const double fTotal = 10.0;
        const double fFinalConc = 10.0; // mcg/ml
        final rates = [
          _RateRow(
            '${_fmt(0.05 * weight)} ml/hr',
            '0.5 mcg/kg/hr',
            isStandard: true,
          ),
          _RateRow(
            '${_fmt(0.10 * weight)} ml/hr',
            '1.0 mcg/kg/hr (maximum)',
          ),
        ];
        return _Preparation(
          drugLine: 'Take 1 ml of Dexmedetomidine (100 mcg)',
          diluentLine: 'Add 9 ml of NS to make 10 ml',
          finalConcLine: 'Final: 10 mcg per ml',
          rateAtStart:
              '${_fmt(0.05 * weight)} ml/hr for 0.5 mcg/kg/hr',
          drugMl: fDrugMl,
          diluentMl: fDilMl,
          totalMl: fTotal,
          finalConcMcgPerMl: fFinalConc,
          rates: rates,
        );
      }

    default:
      return const _Preparation(
        drugLine: '—',
        diluentLine: '—',
        finalConcLine: '—',
        rateAtStart: '—',
        drugMl: 0,
        diluentMl: 0,
        totalMl: 0,
        finalConcMcgPerMl: 0,
        rates: [],
      );
  }
}

// quick helper: for the collapsed header "standard rate" pill
String _quickStartRate(_DrugData drug, double weight, double multiplier) {
  if (weight <= 0) return 'Enter wt';
  switch (drug.name) {
    case 'Dopamine':
    case 'Dobutamine':
      return '${_fmt(1.0 / multiplier)} ml/hr';
    case 'Adrenaline (Epinephrine)':
    case 'Noradrenaline (Norepinephrine)':
      return '${_fmt(0.1 / multiplier)} ml/hr';
    case 'Milrinone':
      return '${_fmt(1.0 / multiplier)} ml/hr';
    case 'Fentanyl':
      return '${_fmt(0.1 * weight)} ml/hr';
    case 'Vasopressin':
      return '${_fmt(0.2 / multiplier)} ml/hr';
    case 'Morphine':
      return 'Per protocol';
    case 'PGE1 (Alprostadil)':
      return '${_fmt(0.6 * weight)} ml/hr';
    case 'Midazolam':
      return '${_fmt(0.08 / multiplier)} ml/hr';
    case 'Furosemide (Lasix)':
      return '${_fmt(0.1 * weight)} ml/hr';
    case 'Ketamine':
      return '${_fmt(0.5 * weight)} ml/hr';
    case 'Dexmedetomidine':
      return '${_fmt(0.05 * weight)} ml/hr';
    case 'Sildenafil':
      return 'Loading/Maint';
    default:
      return '—';
  }
}

// ── Category helpers ──────────────────────────────────────────────────────────

Color _categoryColor(_DrugCategory cat) {
  switch (cat) {
    case _DrugCategory.inotrope:
      return const Color(0xFFC62828);
    case _DrugCategory.vasoactive:
      return const Color(0xFFE65100);
    case _DrugCategory.sedation:
      return const Color(0xFF6A1B9A);
    case _DrugCategory.analgesic:
      return const Color(0xFF1565C0);
    case _DrugCategory.diuretic:
      return const Color(0xFF00838F);
    case _DrugCategory.vasodilator:
      return const Color(0xFF2E7D32);
    case _DrugCategory.prostaglandin:
      return const Color(0xFF4A148C);
  }
}

String _categoryLabel(_DrugCategory cat) {
  switch (cat) {
    case _DrugCategory.inotrope:
      return 'Inotrope';
    case _DrugCategory.vasoactive:
      return 'Vasoactive';
    case _DrugCategory.sedation:
      return 'Sedation';
    case _DrugCategory.analgesic:
      return 'Analgesic';
    case _DrugCategory.diuretic:
      return 'Diuretic';
    case _DrugCategory.vasodilator:
      return 'Vasodilator';
    case _DrugCategory.prostaglandin:
      return 'Prostaglandin';
  }
}

// ── Main Screen Widget ────────────────────────────────────────────────────────

class EmergencyNICUDrugsScreen extends StatefulWidget {
  const EmergencyNICUDrugsScreen({super.key});

  @override
  State<EmergencyNICUDrugsScreen> createState() =>
      _EmergencyNICUDrugsScreenState();
}

class _EmergencyNICUDrugsScreenState extends State<EmergencyNICUDrugsScreen>
    with SingleTickerProviderStateMixin {
  // ── State ──────────────────────────────────────────────────────────────────
  final TextEditingController _weightCtrl = TextEditingController();
  double? _weight;

  bool _smartView = true;

  double _multiplier = 1.0;

  String _dropdownVolume = 'Default';
  double? _customVolumeMl;
  final TextEditingController _customVolCtrl = TextEditingController();
  bool _showCustomVolField = false;

  // ── FAB pulse animation (scale 1.0 → 1.05) ────────────────────────────────
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.05)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _weightCtrl.dispose();
    _customVolCtrl.dispose();
    super.dispose();
  }

  double? _resolvedTotalMl(_DrugData drug) {
    if (_dropdownVolume == 'Default') return null; // use drug's standard
    if (_dropdownVolume == 'Custom') return _customVolumeMl;
    final v = double.tryParse(
      _dropdownVolume.replaceAll('ml', '').trim(),
    );
    return v;
  }

  void _onWeightChanged(String val) {
    setState(() {
      _weight = double.tryParse(val);
    });
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      Theme.of(context).textTheme,
    );

    return Theme(
      data: Theme.of(context).copyWith(textTheme: textTheme),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFB71C1C),
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Emergency NICU Drugs',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                'Weight-based · Preparation Guide',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
          actions: [
            // Running Infusions panel
            ListenableBuilder(
              listenable: InfusionStore.instance,
              builder: (_, __) {
                final count = InfusionStore.instance.items.length;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Current Infusions',
                      icon: const Icon(Icons.monitor_heart),
                      onPressed: () => openCurrentInfusionsSheet(
                        context,
                        weightKg: _weight,
                      ),
                    ),
                    if (count > 0)
                      Positioned(
                        top: 8,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            // Resuscitation quick-access
            IconButton(
              tooltip: 'Resuscitation Drugs',
              icon: const Icon(Icons.warning_rounded),
              onPressed: () =>
                  openResuscitationSheet(context, weightKg: _weight),
            ),
          ],
        ),
        floatingActionButton: ScaleTransition(
          scale: _pulseAnim,
          child: FloatingActionButton.extended(
            onPressed: () =>
                openResuscitationSheet(context, weightKg: _weight),
            backgroundColor: const Color(0xFFB71C1C),
            foregroundColor: Colors.white,
            icon: const Icon(Icons.emergency),
            label: Text(
              'RESUS',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // ── Sticky Header ──────────────────────────────────────────────
            _StickyHeader(
              weightCtrl: _weightCtrl,
              onWeightChanged: _onWeightChanged,
              smartView: _smartView,
              onViewToggle: (v) => setState(() => _smartView = v),
              multiplier: _multiplier,
              onMultiplierChanged: (v) => setState(() => _multiplier = v),
              dropdownVolume: _dropdownVolume,
              onDropdownChanged: (v) {
                setState(() {
                  _dropdownVolume = v ?? 'Default';
                  _showCustomVolField = _dropdownVolume == 'Custom';
                  if (!_showCustomVolField) _customVolumeMl = null;
                });
              },
              showCustomVolField: _showCustomVolField,
              customVolCtrl: _customVolCtrl,
              onCustomVolChanged: (v) {
                setState(() {
                  _customVolumeMl = double.tryParse(v);
                });
              },
            ),
            // ── Drug List ──────────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                children: [
                  if (_smartView) ...[
                    for (final drug in _drugs)
                      _SmartDrugCard(
                        drug: drug,
                        weight: _weight,
                        multiplier: _multiplier,
                        overrideTotalMl: _weight != null
                            ? _resolvedTotalMl(drug)
                            : null,
                      ),
                    const SizedBox(height: 12),
                    AdvancedTools(weight: _weight),
                  ] else ...[
                    _TableViewHeader(weight: _weight),
                    for (final drug in _drugs)
                      _TableDrugRow(
                        drug: drug,
                        weight: _weight,
                        multiplier: _multiplier,
                        overrideTotalMl: _weight != null
                            ? _resolvedTotalMl(drug)
                            : null,
                      ),
                  ],
                  const SizedBox(height: 8),
                  _DisclaimerBanner(),
                  const SizedBox(height: 80), // FAB breathing room
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sticky Header Widget ──────────────────────────────────────────────────────

class _StickyHeader extends StatelessWidget {
  final TextEditingController weightCtrl;
  final ValueChanged<String> onWeightChanged;
  final bool smartView;
  final ValueChanged<bool> onViewToggle;
  final double multiplier;
  final ValueChanged<double> onMultiplierChanged;
  final String dropdownVolume;
  final ValueChanged<String?> onDropdownChanged;
  final bool showCustomVolField;
  final TextEditingController customVolCtrl;
  final ValueChanged<String> onCustomVolChanged;

  const _StickyHeader({
    required this.weightCtrl,
    required this.onWeightChanged,
    required this.smartView,
    required this.onViewToggle,
    required this.multiplier,
    required this.onMultiplierChanged,
    required this.dropdownVolume,
    required this.onDropdownChanged,
    required this.showCustomVolField,
    required this.customVolCtrl,
    required this.onCustomVolChanged,
  });

  static const List<double> _multiplierValues = [0.5, 1.0, 2.0, 3.0, 4.0];
  static const List<String> _multiplierLabels = ['½x', '1x', '2x', '3x', '4x'];
  static const List<String> _volumeOptions = [
    'Default',
    '10ml',
    '20ml',
    '24ml',
    '50ml',
    'Custom',
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: cs.onSurface.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row A — Weight input
          TextField(
            controller: weightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            onChanged: onWeightChanged,
            decoration: InputDecoration(
              labelText: "Baby's Weight",
              hintText: 'Enter weight in kg',
              suffixText: 'kg',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              isDense: true,
            ),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          // Row B — View toggle
          Row(
            children: [
              Expanded(
                child: smartView
                    ? FilledButton.icon(
                        onPressed: () => onViewToggle(true),
                        icon: const Text('🧠', style: TextStyle(fontSize: 14)),
                        label: Text(
                          'Smart View',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFB71C1C),
                          foregroundColor: Colors.white,
                        ),
                      )
                    : OutlinedButton.icon(
                        onPressed: () => onViewToggle(true),
                        icon: const Text('🧠', style: TextStyle(fontSize: 14)),
                        label: Text(
                          'Smart View',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: !smartView
                    ? FilledButton.icon(
                        onPressed: () => onViewToggle(false),
                        icon: const Text('📋', style: TextStyle(fontSize: 14)),
                        label: Text(
                          'Table View',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFB71C1C),
                          foregroundColor: Colors.white,
                        ),
                      )
                    : OutlinedButton.icon(
                        onPressed: () => onViewToggle(false),
                        icon: const Text('📋', style: TextStyle(fontSize: 14)),
                        label: Text(
                          'Table View',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ),
            ],
          ),
          if (smartView) ...[
            const SizedBox(height: 10),
            // Row C — Concentration multiplier chips
            Row(
              children: [
                Text(
                  'Concentration:',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_multiplierValues.length, (i) {
                        final val = _multiplierValues[i];
                        final label = _multiplierLabels[i];
                        final isSelected = multiplier == val;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Tooltip(
                            message:
                                'Increase concentration when fluid restriction needed',
                            child: ChoiceChip(
                              label: Text(
                                label,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (_) {
                                HapticFeedback.selectionClick();
                                onMultiplierChanged(val);
                              },
                              selectedColor:
                                  const Color(0xFFB71C1C),
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : null,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 0,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Row D — Diluent total volume
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Total volume:',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: dropdownVolume,
                  isDense: true,
                  items: _volumeOptions
                      .map(
                        (v) => DropdownMenuItem(
                          value: v,
                          child: Text(
                            v,
                            style: GoogleFonts.plusJakartaSans(fontSize: 13),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: onDropdownChanged,
                  underline: const SizedBox.shrink(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: cs.onSurface,
                  ),
                ),
                if (showCustomVolField) ...[
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 70,
                    child: TextField(
                      controller: customVolCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      onChanged: onCustomVolChanged,
                      decoration: InputDecoration(
                        hintText: 'ml',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        isDense: true,
                      ),
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Smart Drug Card ───────────────────────────────────────────────────────────

class _SmartDrugCard extends StatefulWidget {
  final _DrugData drug;
  final double? weight;
  final double multiplier;
  final double? overrideTotalMl;

  const _SmartDrugCard({
    required this.drug,
    required this.weight,
    required this.multiplier,
    required this.overrideTotalMl,
  });

  @override
  State<_SmartDrugCard> createState() => _SmartDrugCardState();
}

class _SmartDrugCardState extends State<_SmartDrugCard> {
  @override
  Widget build(BuildContext context) {
    final drug = widget.drug;
    final weight = widget.weight;
    final multiplier = widget.multiplier;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final catColor = _categoryColor(drug.category);

    final hasWeight = weight != null && weight > 0;
    _Preparation? prep;
    if (hasWeight && drug.kind != _DilutionKind.special) {
      prep = _computePrep(
        drug,
        weight,
        multiplier,
        widget.overrideTotalMl,
      );
    }

    final startRate =
        hasWeight ? _quickStartRate(drug, weight, multiplier) : 'Enter wt';
    final isFixedNoMul =
        drug.kind == _DilutionKind.fixed && !drug.concentrationMultiplierApplies;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: cs.onSurface.withValues(alpha: 0.1),
        ),
      ),
      elevation: 0,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: EdgeInsets.zero,
          onExpansionChanged: (_) {
            HapticFeedback.lightImpact();
          },
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      drug.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _categoryLabel(drug.category),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: catColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: hasWeight
                      ? const Color(0xFFFF8F00).withValues(alpha: 0.15)
                      : cs.onSurface.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  startRate,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: hasWeight
                        ? const Color(0xFFE65100)
                        : cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: _SmartCardBody(
                drug: drug,
                weight: weight,
                multiplier: multiplier,
                prep: prep,
                isDark: isDark,
                isFixedNoMul: isFixedNoMul,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Smart Card Body (4-tab: Prepare / Titrate / Check / Info) ────────────────

class _SmartCardBody extends StatefulWidget {
  final _DrugData drug;
  final double? weight;
  final double multiplier;
  final _Preparation? prep;
  final bool isDark;
  final bool isFixedNoMul;

  const _SmartCardBody({
    required this.drug,
    required this.weight,
    required this.multiplier,
    required this.prep,
    required this.isDark,
    required this.isFixedNoMul,
  });

  @override
  State<_SmartCardBody> createState() => _SmartCardBodyState();
}

class _SmartCardBodyState extends State<_SmartCardBody>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final TextEditingController _titrateCtl = TextEditingController();
  final TextEditingController _checkRateCtl = TextEditingController();
  final TextEditingController _checkHoursCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
    _titrateCtl.addListener(() => setState(() {}));
    _checkRateCtl.addListener(() => setState(() {}));
    _checkHoursCtl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabs.dispose();
    _titrateCtl.dispose();
    _checkRateCtl.dispose();
    _checkHoursCtl.dispose();
    super.dispose();
  }

  // Accessor shortcuts so the rest of the old build code stays mostly the same.
  _DrugData get drug => widget.drug;
  double? get weight => widget.weight;
  double get multiplier => widget.multiplier;
  _Preparation? get prep => widget.prep;
  bool get isDark => widget.isDark;
  bool get isFixedNoMul => widget.isFixedNoMul;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Morphine and Sildenafil have special non-tab bodies — keep their
    // original dedicated widgets so the simple UX stays.
    if (drug.name == 'Morphine' || drug.name == 'Sildenafil') {
      return _buildPrepareTab(context);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tab bar
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TabBar(
            controller: _tabs,
            indicator: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: const EdgeInsets.all(3),
            dividerColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: cs.onSurface.withValues(alpha: 0.65),
            labelStyle: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
            tabs: const [
              Tab(text: '⚗️ Prepare'),
              Tab(text: '↕️ Titrate'),
              Tab(text: '🔄 Check'),
              Tab(text: 'ℹ️ Info'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Tab views (fixed-height, content-based via AnimatedSize)
        AnimatedBuilder(
          animation: _tabs,
          builder: (_, __) {
            Widget child;
            switch (_tabs.index) {
              case 0:
                child = _buildPrepareTab(context);
                break;
              case 1:
                child = _buildTitrateTab(context);
                break;
              case 2:
                child = _buildCheckTab(context);
                break;
              case 3:
              default:
                child = _buildInfoTab(context);
            }
            return AnimatedSize(
              duration: const Duration(milliseconds: 180),
              alignment: Alignment.topCenter,
              child: Container(key: ValueKey(_tabs.index), child: child),
            );
          },
        ),
      ],
    );
  }

  // ── PREPARE TAB (former main body) ───────────────────────────────────────
  Widget _buildPrepareTab(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasWeight = weight != null && weight! > 0;

    // ── MORPHINE special card ─────────────────────────────────────────────────
    if (drug.name == 'Morphine') {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFFFB300)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, color: Color(0xFFFF8F00), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                drug.specialNote!,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: const Color(0xFF4E342E),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // ── SILDENAFIL special two-phase card ─────────────────────────────────────
    if (drug.name == 'Sildenafil') {
      return _SildenafilCard(weight: weight, hasWeight: hasWeight);
    }

    if (!hasWeight) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Enter baby\'s weight above to see preparation instructions.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: cs.onSurface.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    final p = prep!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Vial info
        Text(
          drug.vialConc,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: cs.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 8),

        // Warning banner
        if (p.warning != null) ...[
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFB300)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber,
                  color: Color(0xFFFF8F00),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    p.warning!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: const Color(0xFF4E342E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        // PGE1 special warnings
        if (drug.name == 'PGE1 (Alprostadil)') ...[
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE53935)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.emergency, color: Color(0xFFD32F2F), size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Use 5% Dextrose ONLY — NOT normal saline',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFB71C1C),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFB300)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber,
                  color: Color(0xFFFF8F00),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Start at lowest effective dose. Apnoea risk — be prepared for intubation.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: const Color(0xFF4E342E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        // Preparation box
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF0D2137)
                : const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PREPARATION',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: isDark
                      ? Colors.white70
                      : const Color(0xFF1565C0),
                ),
              ),
              const SizedBox(height: 8),
              _PrepLine(
                label: 'Take ',
                value: _fmt(p.drugMl),
                rest: ' ml of ${drug.name}',
                valueColor: const Color(0xFF42A5F5),
              ),
              const SizedBox(height: 4),
              _PrepLine(
                label: 'Add ',
                value: _fmt(p.diluentMl),
                rest: ' ml of ${drug.diluent} to make ${_fmt(p.totalMl)} ml',
                valueColor: const Color(0xFF78909C),
              ),
              const SizedBox(height: 4),
              Text(
                p.finalConcLine,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1A237E),
                ),
              ),
            ],
          ),
        ),

        // Concentration note
        if (multiplier != 1.0 && drug.concentrationMultiplierApplies) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${_fmt(multiplier, decimals: 1)}x concentration — run at same starting dose, rate adjusted by factor of ${_fmt(1 / multiplier)}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: const Color(0xFF2E7D32),
              ),
            ),
          ),
        ],

        // Fixed dilution note
        if (isFixedNoMul) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: cs.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Fixed dilution — adjust rate to change dose, not concentration',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],

        const SizedBox(height: 10),

        // Dose table
        if (p.rates.isNotEmpty) ...[
          // Midazolam special sub-labels
          if (drug.name == 'Midazolam') ...[
            _MidazolamRateSection(rates: p.rates),
          ] else ...[
            _RateTable(rates: p.rates),
          ],
        ],

        const SizedBox(height: 8),
        // Dose range
        Text(
          'Dose range: ${drug.doseRange}',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: cs.onSurface.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }

  // ── TITRATE TAB — "what rate for my target dose?" ──────────────────────────
  Widget _buildTitrateTab(BuildContext context) {
    final w = weight;
    final p = prep;
    final max = kMaxDose[drug.name];
    final unit = _doseUnitFor(drug.name);

    if (w == null || w <= 0 || p == null) {
      return _placeholder(context, 'Enter weight above to titrate.');
    }

    final target = double.tryParse(_titrateCtl.text.trim()) ?? 0;
    final native = _nativeConcFromPrep(drug.name, p);
    final targetRate = target > 0
        ? rateForTargetDose(
            targetDose: target,
            weight: w,
            finalConcNativePerMl: native,
            doseUnit: unit,
          )
        : null;

    final band = target > 0 ? doseBandFor(target, max?.maxValue) : DoseBand.safe;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TabCardHeader(
          title: 'What rate for my target dose?',
          subtitle: 'Concentration: ${p.finalConcLine.replaceFirst("Final concentration: ", "")}',
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _titrateCtl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.plusJakartaSans(fontSize: 14),
          decoration: InputDecoration(
            labelText: 'Target dose',
            hintText: 'e.g. 12',
            suffixText: unit,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 10),
        if (targetRate != null) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0D2137) : const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set rate to ${_fmt(targetRate)} ml/hr',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF42A5F5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_fmt(targetRate)} ml/hr will deliver $target $unit',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : const Color(0xFF1A237E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _titrateBanner(band, max),
        ] else
          _placeholder(context, 'Enter a target dose above.'),
      ],
    );
  }

  // ── CHECK TAB — "what dose am I giving at this rate?" ──────────────────────
  Widget _buildCheckTab(BuildContext context) {
    final w = weight;
    final p = prep;
    final unit = _doseUnitFor(drug.name);
    final max = kMaxDose[drug.name];

    if (w == null || w <= 0 || p == null) {
      return _placeholder(context, 'Enter weight above to check.');
    }

    final rate = double.tryParse(_checkRateCtl.text.trim()) ?? 0;
    final hours = double.tryParse(_checkHoursCtl.text.trim());
    final native = _nativeConcFromPrep(drug.name, p);

    final currentDose = rate > 0
        ? doseFromRate(
            rateMlHr: rate,
            weight: w,
            finalConcNativePerMl: native,
            doseUnit: unit,
          )
        : null;

    final band = currentDose != null
        ? doseBandFor(currentDose, max?.maxValue)
        : DoseBand.safe;

    // Total given over the running period
    String? cumulativeLine;
    if (rate > 0 && hours != null && hours > 0) {
      final totalMl = rate * hours;
      final totalNative = totalMl * native; // same unit as native (mcg or mg)
      final perKg = totalNative / w;
      final unitLabel = unit.contains('mg') ? 'mg' : 'mcg';
      cumulativeLine =
          'Drug given so far: ${_fmt(totalMl)} ml = ${_fmt(totalNative)} $unitLabel = ${_fmt(perKg)} $unitLabel/kg total';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TabCardHeader(
          title: 'What dose am I giving?',
          subtitle: 'Enter current rate to see delivered dose.',
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _checkRateCtl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.plusJakartaSans(fontSize: 14),
          decoration: InputDecoration(
            labelText: 'Current rate',
            hintText: 'e.g. 2.3',
            suffixText: 'ml/hr',
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _checkHoursCtl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.plusJakartaSans(fontSize: 14),
          decoration: InputDecoration(
            labelText: 'Running for how long? (optional)',
            hintText: 'e.g. 4.5',
            suffixText: 'hours',
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 12),
        if (currentDose != null) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0D2137) : const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Running at ${_fmt(rate)} ml/hr = ${_fmt(currentDose, decimals: unit.contains('mcg/kg/min') ? 2 : 3)} $unit',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF42A5F5),
                  ),
                ),
                if (cumulativeLine != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    cumulativeLine,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: isDark ? Colors.white70 : const Color(0xFF1A237E),
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          _titrateBanner(band, max),
        ] else
          _placeholder(context, 'Enter the current rate to see the dose.'),
      ],
    );
  }

  // ── INFO TAB ───────────────────────────────────────────────────────────────
  Widget _buildInfoTab(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final info = kDrugInfo[drug.name];
    final compat = kDiluentCompat[drug.name];

    Widget line(String label, String value) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: cs.onSurface.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                height: 1.5,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (info != null) ...[
          line('Mechanism', info.mechanism),
          line('Neonatal use', info.neonatalUse),
          line('Special notes', info.special),
        ],
        if (compat != null) ...[
          CompatibilityChips(compat: compat),
          const SizedBox(height: 10),
        ],
        if (info != null)
          Text(
            'Source: ${info.source}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontStyle: FontStyle.italic,
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ),
      ],
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _placeholder(BuildContext context, String msg) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        msg,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          color: cs.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _titrateBanner(DoseBand band, MaxDoseInfo? max) {
    switch (band) {
      case DoseBand.safe:
        return const DoseBanner(
          band: DoseBand.safe,
          message: 'Within normal range',
        );
      case DoseBand.nearMax:
        return const DoseBanner(
          band: DoseBand.nearMax,
          message: 'Approaching maximum dose',
        );
      case DoseBand.overMax:
        return DoseBanner(
          band: DoseBand.overMax,
          message: max?.suggestion ??
              'Above maximum recommended dose — reassess.',
        );
    }
  }

  /// Maps a drug name to its dose unit for the Titrate/Check tabs.
  String _doseUnitFor(String name) {
    switch (name) {
      case 'Dopamine':
      case 'Dobutamine':
      case 'Adrenaline':
      case 'Noradrenaline':
      case 'Milrinone':
      case 'PGE1 (Alprostadil)':
      case 'PGE1':
        return 'mcg/kg/min';
      case 'Vasopressin':
        return 'units/kg/min';
      case 'Fentanyl':
      case 'Dexmedetomidine':
        return 'mcg/kg/hr';
      case 'Midazolam':
      case 'Furosemide':
      case 'Ketamine':
      case 'Sildenafil':
        return 'mg/kg/hr';
      default:
        return 'mcg/kg/min';
    }
  }

  /// Extract the drug's native-unit concentration per ml from the Preparation.
  /// The existing `_Preparation.finalConcMcgPerMl` field holds mcg/ml for
  /// most drugs, mg/ml for Midazolam / Furosemide / Ketamine / Sildenafil,
  /// and units/ml for Vasopressin (it's a generic "native per ml" store).
  double _nativeConcFromPrep(String name, _Preparation p) {
    return p.finalConcMcgPerMl;
  }
}

// ── Midazolam Rate Section ────────────────────────────────────────────────────

class _MidazolamRateSection extends StatelessWidget {
  final List<_RateRow> rates;
  const _MidazolamRateSection({required this.rates});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sedation sub-header
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            '🟡 Sedation (0.01–0.06 mg/kg/hr)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFFF8F00),
            ),
          ),
        ),
        _RateTable(rates: rates.sublist(0, 2)),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            '🔴 Seizures (0.06–0.4 mg/kg/hr)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFD32F2F),
            ),
          ),
        ),
        _RateTable(rates: rates.sublist(1)),
      ],
    );
  }
}

// ── Rate Table ────────────────────────────────────────────────────────────────

class _RateTable extends StatelessWidget {
  final List<_RateRow> rates;
  const _RateTable({required this.rates});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Table(
        border: TableBorder.all(
          color: cs.onSurface.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(2),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: cs.onSurface.withValues(alpha: 0.06),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                child: Text(
                  'Rate',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                child: Text(
                  'Dose delivered',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
          ...rates.map((row) {
            return TableRow(
              decoration: BoxDecoration(
                color: row.isStandard
                    ? const Color(0xFFE8F5E9)
                    : Colors.transparent,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  child: Text(
                    row.rate,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: row.isStandard
                          ? const Color(0xFF2E7D32)
                          : null,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          row.dose,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: row.isStandard
                                ? const Color(0xFF2E7D32)
                                : null,
                          ),
                        ),
                      ),
                      if (row.isStandard)
                        Text(
                          ' ← start',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// ── Prep Line ─────────────────────────────────────────────────────────────────

class _PrepLine extends StatelessWidget {
  final String label;
  final String value;
  final String rest;
  final Color valueColor;

  const _PrepLine({
    required this.label,
    required this.value,
    required this.rest,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return RichText(
      text: TextSpan(
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          color: isDark ? Colors.white : const Color(0xFF1A237E),
        ),
        children: [
          TextSpan(text: label),
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: valueColor,
            ),
          ),
          TextSpan(text: rest),
        ],
      ),
    );
  }
}

// ── Sildenafil Special Card ───────────────────────────────────────────────────

class _SildenafilCard extends StatelessWidget {
  final double? weight;
  final bool hasWeight;

  const _SildenafilCard({required this.weight, required this.hasWeight});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!hasWeight) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Enter baby\'s weight above to see preparation instructions.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      );
    }
    final w = weight!;
    // Phase 1 loading
    final loadDoseMg = 0.4 * w;
    final loadVolMl = loadDoseMg / 0.8;
    final loadRate = loadVolMl / 3;
    // Phase 2 maintenance
    final maintDailyMg = 1.6 * w;
    final maintHourlyMg = maintDailyMg / 24;
    final maintRate = maintHourlyMg / 0.8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1 ml = 0.8 mg',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 8),
        // Phase 1
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF0D2137)
                : const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF42A5F5).withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PHASE 1 — LOADING',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: const Color(0xFF1565C0),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Draw ${_fmt(loadVolMl)} ml of Sildenafil (${_fmt(loadDoseMg)} mg)',
                style: GoogleFonts.plusJakartaSans(fontSize: 13),
              ),
              Text(
                'Give over 3 hours at ${_fmt(loadRate)} ml/hr',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'No dilution required — give neat or dilute with 5% Dextrose if needed',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : const Color(0xFF1A237E),
                ),
              ),
            ],
          ),
        ),
        // Phase 2
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF0D2A1A)
                : const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PHASE 2 — MAINTENANCE',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: const Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Daily dose: ${_fmt(maintDailyMg)} mg/day (${_fmt(maintHourlyMg)} mg/hr)',
                style: GoogleFonts.plusJakartaSans(fontSize: 13),
              ),
              Text(
                'Rate: ${_fmt(maintRate)} ml/hr of undiluted Sildenafil',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Or dilute as per unit protocol for smaller rates',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : const Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Dose range: Loading: 0.4 mg/kg over 3 hrs; Maintenance: 1.6 mg/kg/day',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
}

// ── Table View Widgets ────────────────────────────────────────────────────────

class _TableViewHeader extends StatelessWidget {
  final double? weight;
  const _TableViewHeader({required this.weight});

  @override
  Widget build(BuildContext context) {
    if (weight == null || weight! <= 0) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEB3B).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFFFC107)),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: Color(0xFFFF8F00), size: 18),
            const SizedBox(width: 8),
            Text(
              'Enter weight above to see calculated values',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: const Color(0xFF4E342E),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFB71C1C).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFB71C1C).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.monitor_weight_outlined,
            color: Color(0xFFB71C1C),
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Baby\'s Weight: ',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: const Color(0xFFB71C1C),
            ),
          ),
          Text(
            '${_fmt(weight!)} kg',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFB71C1C),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableDrugRow extends StatelessWidget {
  final _DrugData drug;
  final double? weight;
  final double multiplier;
  final double? overrideTotalMl;

  const _TableDrugRow({
    required this.drug,
    required this.weight,
    required this.multiplier,
    required this.overrideTotalMl,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasWeight = weight != null && weight! > 0;
    final catColor = _categoryColor(drug.category);

    _Preparation? prep;
    if (hasWeight && drug.kind != _DilutionKind.special) {
      prep = _computePrep(drug, weight!, multiplier, overrideTotalMl);
    }

    String dilutionRule;
    if (!hasWeight) {
      dilutionRule = drug.startingRateLabel;
    } else if (drug.kind == _DilutionKind.special) {
      dilutionRule = 'See unit protocol';
    } else {
      dilutionRule = prep!.drugLine;
    }

    String standardRate;
    if (!hasWeight) {
      standardRate = 'Enter weight';
    } else {
      standardRate = _quickStartRate(drug, weight!, multiplier);
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: cs.onSurface.withValues(alpha: 0.1)),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    drug.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _categoryLabel(drug.category),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: catColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            _TableRow(label: 'Vial', value: drug.vialConc),
            _TableRow(
              label: 'Preparation',
              value: hasWeight && prep != null
                  ? prep.drugLine
                  : dilutionRule,
            ),
            if (hasWeight && prep != null)
              _TableRow(label: 'Diluent', value: prep.diluentLine),
            _TableRow(label: 'Starting rate', value: standardRate),
            _TableRow(label: 'Dose range', value: drug.doseRange),
          ],
        ),
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  final String label;
  final String value;

  const _TableRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.plusJakartaSans(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Disclaimer Banner ─────────────────────────────────────────────────────────

class _DisclaimerBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFB300)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber,
            color: Color(0xFFFF8F00),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Always verify drug doses, concentrations, and preparation with a senior clinician or pharmacist before administration. This tool is a guide only.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: const Color(0xFF4E342E),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
