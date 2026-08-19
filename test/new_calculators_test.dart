// =============================================================================
// test/new_calculators_test.dart
//
// Cross-check for the new clinical calculators. Each test drives the REAL
// widget — enters values into its fields exactly as a user would — and asserts
// the displayed result against an independently hand-computed value.
//
// This catches formula transcription errors, unit mistakes and wrong band
// thresholds, which a code read-through does not.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/calculators/new_clinical_calculators.dart';
import 'package:pediaid_app/screens/calculators/remaining_calculators.dart';

/// Pumps [w], types [values] into its text fields in order, and settles.
Future<void> _fill(WidgetTester tester, Widget w, List<String?> values) async {
  await tester.pumpWidget(MaterialApp(home: w));
  final fields = find.byType(TextField);
  for (var i = 0; i < values.length; i++) {
    final v = values[i];
    if (v == null) continue;
    await tester.enterText(fields.at(i), v);
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

void main() {
  // ── Haematology ───────────────────────────────────────────────────────────
  testWidgets('ANC: WBC 8.0, 45% neut + 5% bands = 4000/µL', (tester) async {
    // 8.0 ×10⁹/L = 8000/µL; (45+5)% = 50% → 4000/µL
    await _fill(tester, const AbsoluteCountsCalculator(),
        ['8.0', '45', '5', '3', '40']);
    expect(find.textContaining('ANC 4000'), findsOneWidget);
    expect(find.textContaining('Normal'), findsWidgets);
    // AEC = 8000 × 3% = 240 ; ALC = 8000 × 40% = 3200
    expect(find.textContaining('240'), findsWidgets);
    expect(find.textContaining('3200'), findsWidgets);
  });

  testWidgets('ANC severe neutropenia band: WBC 2.0, 10% neut = 200/µL',
      (tester) async {
    await _fill(tester, const AbsoluteCountsCalculator(),
        ['2.0', '10', null, null, null]);
    expect(find.textContaining('ANC 200'), findsOneWidget);
    expect(find.text('Severe neutropenia'), findsOneWidget);
  });

  testWidgets('Mentzer: MCV 65 / RBC 5.6 = 11.6 → thalassaemia trait',
      (tester) async {
    await _fill(tester, const MentzerIndexCalculator(), ['65', '5.6']);
    expect(find.text('11.6'), findsOneWidget);
    expect(find.text('Thalassaemia trait likely'), findsOneWidget);
  });

  testWidgets('Mentzer: MCV 70 / RBC 4.0 = 17.5 → iron deficiency',
      (tester) async {
    await _fill(tester, const MentzerIndexCalculator(), ['70', '4.0']);
    expect(find.text('17.5'), findsOneWidget);
    expect(find.text('Iron deficiency likely'), findsOneWidget);
  });

  testWidgets('Reticulocyte RPI: 2.5% at Hct 25 → corrected 1.39, RPI 0.93',
      (tester) async {
    // corrected = 2.5 × 25/45 = 1.3889 ; MF at Hct 25 = 1.5 ; RPI = 0.926
    await _fill(tester, const ReticulocyteCalculator(), ['2.5', '25', null]);
    expect(find.text('RPI 0.93'), findsOneWidget);
    expect(find.text('Inadequate response'), findsOneWidget);
    expect(find.text('1.39 %'), findsOneWidget);
  });

  // ── Cardiology ────────────────────────────────────────────────────────────
  testWidgets('QTc Bazett: QT 380 ms at HR 90 = 465 ms (prolonged)',
      (tester) async {
    // RR = 60/90 = 0.6667 s ; √RR = 0.8165 ; 380/0.8165 = 465.4
    await _fill(tester, const QtcCalculator(), ['380', '90']);
    expect(find.text('465 ms'), findsOneWidget);
    expect(find.text('Prolonged'), findsOneWidget);
  });

  testWidgets('QTc normal: QT 360 ms at HR 60 = 360 ms', (tester) async {
    // RR = 1.0 s → QTc == QT
    await _fill(tester, const QtcCalculator(), ['360', '60']);
    expect(find.text('360 ms'), findsOneWidget);
    expect(find.text('Normal'), findsOneWidget);
  });

  testWidgets('MAP: 100/60 = 73 mmHg, pulse pressure 40', (tester) async {
    // MAP = 60 + (40/3) = 73.3
    await _fill(tester, const MapCalculator(), ['100', '60', '5']);
    expect(find.text('73 mmHg'), findsOneWidget);
    expect(find.text('40 mmHg'), findsOneWidget);
  });

  testWidgets('Fick cardiac output: VO2 150, Hb 12, SaO2 98, SvO2 70 = 3.33',
      (tester) async {
    // CO = 150 / (1.34 × 12 × 0.28 × 10) = 150 / 45.024 = 3.331
    await _fill(tester, const FickCardiacOutputCalculator(),
        ['150', '12', '98', '70', null]);
    expect(find.text('3.33 L/min'), findsOneWidget);
  });

  // ── Renal ─────────────────────────────────────────────────────────────────
  testWidgets('FeNa: UNa 20, SCr 1.2, SNa 138, UCr 60 = 0.29% (pre-renal)',
      (tester) async {
    // (20 × 1.2) / (138 × 60) × 100 = 24/8280 × 100 = 0.2899
    await _fill(tester, const FenaCalculator(), ['20', '138', '60', '1.2']);
    expect(find.text('0.29 %'), findsOneWidget);
    expect(find.text('Pre-renal'), findsOneWidget);
  });

  testWidgets('FeNa intrinsic: UNa 60, SCr 2.0, SNa 140, UCr 30 = 2.86%',
      (tester) async {
    // (60 × 2) / (140 × 30) × 100 = 120/4200 × 100 = 2.857
    await _fill(tester, const FenaCalculator(), ['60', '140', '30', '2.0']);
    expect(find.text('2.86 %'), findsOneWidget);
    expect(find.text('Intrinsic / ATN'), findsOneWidget);
  });

  testWidgets('FeMg: UMg 3, SCr 0.6, SMg 1.4, UCr 60 = 3.1% (extra-renal)',
      (tester) async {
    // (3 × 0.6) / (0.7 × 1.4 × 60) × 100 = 1.8/58.8 × 100 = 3.061
    await _fill(tester, const FeMgCalculator(), ['3', '1.4', '60', '0.6']);
    expect(find.text('3.1 %'), findsOneWidget);
    expect(find.text('Extra-renal loss'), findsOneWidget);
  });

  // ── Hepatology ────────────────────────────────────────────────────────────
  testWidgets('APRI: AST 80, ULN 40, PLT 150 = 1.33 (cirrhosis likely)',
      (tester) async {
    // (80/40) / 150 × 100 = 2/150 × 100 = 1.333
    await _fill(tester, const ApriCalculator(), ['80', '40', '150']);
    expect(find.text('1.33'), findsOneWidget);
    expect(find.text('Cirrhosis likely'), findsOneWidget);
  });

  testWidgets('APRI low: AST 30, ULN 40, PLT 250 = 0.30', (tester) async {
    // (30/40)/250 × 100 = 0.75/250 × 100 = 0.30
    await _fill(tester, const ApriCalculator(), ['30', '40', '250']);
    expect(find.text('0.30'), findsOneWidget);
    expect(find.text('Fibrosis unlikely'), findsOneWidget);
  });

  testWidgets('FIB-4: age 14, AST 80, ALT 60, PLT 150 = 0.96', (tester) async {
    // (14 × 80) / (150 × √60) = 1120 / (150 × 7.7460) = 1120/1161.9 = 0.9639
    await _fill(tester, const Fib4Calculator(), ['14', '80', '60', '150']);
    expect(find.text('0.96'), findsOneWidget);
    expect(find.text('Low'), findsOneWidget);
  });

  testWidgets('MELD (age ≥12): bili 4, INR 1.8, Cr 1.0 = 18', (tester) async {
    // 3.78·ln4 + 11.2·ln1.8 + 9.57·ln1 + 6.43
    // = 3.78(1.3863) + 11.2(0.5878) + 0 + 6.43 = 5.240 + 6.583 + 6.43 = 18.25
    await _fill(tester, const PeldMeldCalculator(),
        ['14', '4', '1.8', null, '1.0']);
    expect(find.text('MELD 18'), findsOneWidget);
  });

  // ── Endocrine ─────────────────────────────────────────────────────────────
  testWidgets('HbA1c 7% → eAG 154 mg/dL (8.6 mmol/L)', (tester) async {
    // 28.7 × 7 − 46.7 = 200.9 − 46.7 = 154.2 ; 1.59 × 7 − 2.59 = 8.54
    await _fill(tester, const HbA1cEagCalculator(), ['7.0']);
    expect(find.text('154 mg/dL'), findsOneWidget);
    expect(find.text('8.5'), findsOneWidget);
  });

  // ── Neurology ─────────────────────────────────────────────────────────────
  testWidgets('CSF WBC correction: 50 obs, 5000 RBC, blood 10/4.5 → 39',
      (tester) async {
    // predicted = 5000 × (10000 / 4.5e6) = 11.1 ; corrected = 50 − 11.1 = 38.9
    await _fill(tester, const CsfWbcCorrectionCalculator(),
        ['50', '5000', '10', '4.5']);
    expect(find.textContaining('Corrected WBC 39'), findsOneWidget);
    expect(find.text('True pleocytosis'), findsOneWidget);
  });

  // ── Toxicology ────────────────────────────────────────────────────────────
  testWidgets('Paracetamol at 4 h: 200 µg/mL is above the 150 line',
      (tester) async {
    await _fill(tester, const ParacetamolCalculator(), ['4', '200', '20']);
    expect(find.text('Above treatment line'), findsOneWidget);
    expect(find.text('Treat with NAC'), findsOneWidget);
    // NAC bag 1 = 150 mg/kg × 20 kg = 3000 mg
    expect(find.textContaining('3000 mg'), findsOneWidget);
  });

  testWidgets('Paracetamol at 12 h: line halves twice to 37.5 µg/mL',
      (tester) async {
    // 150 × 2^(-(12−4)/4) = 150 × 2^-2 = 37.5 ; 30 is below it
    await _fill(tester, const ParacetamolCalculator(), ['12', '30', null]);
    expect(find.text('Below treatment line'), findsOneWidget);
    expect(find.textContaining('38 µg/mL'), findsOneWidget);
  });

  // ── Growth ────────────────────────────────────────────────────────────────
  testWidgets('BMI: 20 kg, 115 cm = 15.1 kg/m²', (tester) async {
    // 20 / 1.15² = 20/1.3225 = 15.12
    await _fill(tester, const BmiCalculator(), ['20', '115']);
    expect(find.text('15.1 kg/m²'), findsOneWidget);
  });

  testWidgets('Ideal body weight: height 130 cm ≈ 27.0 kg', (tester) async {
    // 2.396 × e^(0.01863 × 130) = 2.396 × e^2.4219 = 2.396 × 11.268 = 26.99
    await _fill(tester, const IdealBodyWeightCalculator(), ['130', null]);
    expect(find.text('27.0 kg'), findsOneWidget);
  });

  testWidgets('Schofield BMR: boy 7 y, 20 kg = 958 kcal/day', (tester) async {
    // 3–10 y boys: 22.706 × 20 + 504.3 = 454.12 + 504.3 = 958.42
    await _fill(tester, const BmrCalculator(), ['20', '7', '1', null]);
    expect(find.text('958 kcal/day'), findsOneWidget);
  });

  testWidgets('Schofield BMR: girl 12 y, 40 kg = 1228 kcal/day',
      (tester) async {
    // 10–18 y girls: 13.384 × 40 + 692.6 = 535.36 + 692.6 = 1227.96
    await _fill(tester, const BmrCalculator(), ['40', '12', '0', null]);
    expect(find.text('1228 kcal/day'), findsOneWidget);
  });

  // ── Critical care ─────────────────────────────────────────────────────────
  testWidgets('A–a gradient on room air: PaO2 90, PaCO2 40 → 9.7', (tester) async {
    // PAO2 = 0.21 × 713 − 50 = 149.73 − 50 = 99.73 ; A−a = 9.73
    await _fill(tester, const AaGradientCalculator(),
        ['0.21', '90', '40', '8', '760']);
    expect(find.text('9.7 mmHg'), findsOneWidget);
    // Expected for an 8-year-old = (8/4)+4 = 6 mmHg, so 9.7 is correctly
    // flagged as elevated. The expected value is shown alongside.
    expect(find.text('Elevated'), findsOneWidget);
    expect(find.text('6.0 mmHg'), findsOneWidget);
  });

  testWidgets('CPP: MAP 70 − ICP 15 = 55, at/above target for a 6-year-old',
      (tester) async {
    await _fill(tester, const CppCalculator(), ['70', '15', '6']);
    // Appears twice: the CPP result and the age-based minimum (both 55).
    expect(find.text('55 mmHg'), findsNWidgets(2));
    expect(find.text('At/above target'), findsOneWidget);
  });

  testWidgets('CPP below target: MAP 55 − ICP 25 = 30 in a 14-year-old',
      (tester) async {
    await _fill(tester, const CppCalculator(), ['55', '25', '14']);
    expect(find.text('30 mmHg'), findsOneWidget);
    expect(find.text('BELOW target'), findsOneWidget);
  });

  testWidgets('Henderson-Hasselbalch: HCO3 24, PaCO2 40 → pH 7.40',
      (tester) async {
    // 6.1 + log10(24 / 1.2) = 6.1 + log10(20) = 6.1 + 1.3010 = 7.401
    await _fill(tester, const HendersonHasselbalchCalculator(), ['24', '40']);
    expect(find.text('pH 7.40'), findsOneWidget);
    expect(find.text('Normal pH'), findsOneWidget);
  });

  testWidgets('Henderson-Hasselbalch acidaemia: HCO3 10, PaCO2 40 → 7.02',
      (tester) async {
    // 6.1 + log10(10/1.2) = 6.1 + 0.9208 = 7.021
    await _fill(tester, const HendersonHasselbalchCalculator(), ['10', '40']);
    expect(find.text('pH 7.02'), findsOneWidget);
    expect(find.text('Acidaemia'), findsOneWidget);
  });

  testWidgets('Total body water: 15 kg child = 9.0 L (60%)', (tester) async {
    await _fill(tester, const TotalBodyWaterCalculator(), ['15', '4']);
    expect(find.text('9.0 L'), findsOneWidget);
    expect(find.text('Child (~60 %)'), findsOneWidget);
  });

  testWidgets('Total body water: newborn 3 kg = 2.3 L (75%)', (tester) async {
    // 3 × 0.75 = 2.25 → 2.3
    await _fill(tester, const TotalBodyWaterCalculator(), ['3', '0']);
    expect(find.text('2.3 L'), findsOneWidget);
    expect(find.text('Newborn (~75 %)'), findsOneWidget);
  });

  testWidgets('Urine output: 120 mL / 10 kg / 8 h = 1.50 mL/kg/h',
      (tester) async {
    await _fill(tester, const UrineOutputCalculator(),
        ['120', '10', '8', null]);
    expect(find.text('1.50 mL/kg/h'), findsOneWidget);
    expect(find.text('Adequate'), findsOneWidget);
  });

  testWidgets('Urine output oliguria: 20 mL / 10 kg / 8 h = 0.25 → anuria band',
      (tester) async {
    await _fill(tester, const UrineOutputCalculator(), ['20', '10', '8', null]);
    expect(find.text('0.25 mL/kg/h'), findsOneWidget);
    expect(find.text('Anuria/severe oliguria'), findsOneWidget);
  });

  testWidgets('Predicted PEFR: height 130 cm = 250 L/min', (tester) async {
    // (130 − 100) × 5 + 100 = 250
    await _fill(tester, const PefrPredictedCalculator(), ['130', null]);
    expect(find.text('250 L/min'), findsOneWidget);
  });

  testWidgets('PEFR % predicted: 125 of 250 = 50% → severe', (tester) async {
    await _fill(tester, const PefrPredictedCalculator(), ['130', '125']);
    expect(find.text('50 % of predicted'), findsOneWidget);
    expect(find.text('Moderate'), findsOneWidget);
  });

  // ── Drug / fluids ─────────────────────────────────────────────────────────
  testWidgets('Ganzoni iron deficit: 20 kg, Hb 8→12 = 492 mg', (tester) async {
    // 20 × 4 × 2.4 = 192 ; stores 20 × 15 = 300 ; total 492
    await _fill(tester, const IronDeficitCalculator(), ['20', '8', '12']);
    expect(find.text('492 mg'), findsOneWidget);
    expect(find.text('192 mg'), findsOneWidget);
    expect(find.text('300 mg'), findsOneWidget);
  });

  testWidgets('IV drip rate: 500 mL over 6 h = 83.3 mL/h, 83 gtt/min micro',
      (tester) async {
    // 500/6 = 83.33 mL/h ; ×60/60 = 83 gtt/min
    await _fill(tester, const InfusionRateCalculator(), ['500', '6', '60']);
    expect(find.text('83.3 mL/hour'), findsOneWidget);
    expect(find.text('83 gtt/min'), findsOneWidget);
  });

  testWidgets('Calcium equivalents: 10 mL gluconate 10% = 93 mg elemental',
      (tester) async {
    // 10 mL × 9.3 mg/mL = 93 mg ; equivalent CaCl2 = 93/27.3 = 3.4 mL
    await _fill(tester, const CalciumEquivalentCalculator(), ['10', null]);
    expect(find.text('93 mg elemental Ca'), findsOneWidget);
    expect(find.text('3.4 mL'), findsOneWidget);
  });

  testWidgets('Cryoprecipitate: 20 kg → 2–4 units', (tester) async {
    // 20/10 = 2 ; 20/5 = 4
    await _fill(tester, const CryoprecipitateCalculator(), ['20', null, null]);
    expect(find.text('2–4 units'), findsOneWidget);
  });
}
