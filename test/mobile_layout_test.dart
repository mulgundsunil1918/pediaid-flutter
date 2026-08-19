// =============================================================================
// test/mobile_layout_test.dart
//
// Mobile-viewport layout check. Every new score and calculator is rendered on a
// 375 × 812 phone surface (iPhone-class, the narrowest common target) and the
// test fails if Flutter reports ANY layout overflow.
//
// A RenderFlex overflow throws in debug builds, so `tester.takeException()`
// returning null is a genuine assertion that nothing is clipped off-screen —
// including the worst-case long band labels ("Impending respiratory failure")
// and long result values ("Above treatment line").
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/scores/score_scaffold.dart';
import 'package:pediaid_app/screens/scores/paediatric_scores_hub.dart';
import 'package:pediaid_app/screens/calculators/new_clinical_calculators.dart';
import 'package:pediaid_app/screens/calculators/remaining_calculators.dart';
import 'package:pediaid_app/screens/calculators/converter_calculators.dart';
import 'package:pediaid_app/screens/calculators/calculators_hub_screen.dart';

/// Renders [w] on a phone-sized surface in the given theme and returns any
/// layout exception Flutter raised.
Future<Object?> _renderOnPhone(
  WidgetTester tester,
  Widget w, {
  Brightness brightness = Brightness.light,
}) async {
  tester.view.physicalSize = const Size(375 * 3, 812 * 3);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(MaterialApp(
    theme: ThemeData(brightness: brightness),
    home: w,
  ));
  await tester.pumpAndSettle();
  return tester.takeException();
}

void main() {
  group('Scores fit a 375px phone', () {
    testWidgets('every score renders without overflow (light)', (tester) async {
      for (final def in allPaediatricScores) {
        final err = await _renderOnPhone(tester, ScoreScaffold(def: def));
        expect(err, isNull, reason: 'Layout overflow in score: ${def.title}');
      }
    });

    testWidgets('every score renders without overflow (dark)', (tester) async {
      for (final def in allPaediatricScores) {
        final err = await _renderOnPhone(tester, ScoreScaffold(def: def),
            brightness: Brightness.dark);
        expect(err, isNull,
            reason: 'Dark-mode layout overflow in score: ${def.title}');
      }
    });

    testWidgets('the longest band label in the app fits at max score',
        (tester) async {
      // Deterministic worst case: take the longest band label of any score and
      // render it against the largest total, so the widest possible result
      // header is proven to fit a 375px phone.
      var longest = '';
      for (final s in allPaediatricScores) {
        for (final b in s.bands) {
          if (b.label.length > longest.length) longest = b.label;
        }
      }
      final worst = ScoreDef(
        title: 'Worst-case layout probe',
        subtitle: 'Longest band label rendered against the largest total.',
        system: 'Test',
        accent: const Color(0xFF00695C),
        totalLabel: 'principal features',
        questions: [ScoreQ.yesNo('A criterion', pts: 999)],
        bands: [ScoreBand(0, longest, scRed, 'Advice line for the worst case.')],
      );
      final err = await _renderOnPhone(tester, ScoreScaffold(def: worst));
      expect(err, isNull,
          reason: 'Overflow with the longest band label: "$longest"');
      expect(find.text(longest), findsOneWidget);
    });
  });

  group('Calculators fit a 375px phone', () {
    final calculators = <String, Widget>{
      'Absolute counts': const AbsoluteCountsCalculator(),
      'Mentzer': const MentzerIndexCalculator(),
      'QTc': const QtcCalculator(),
      'FeNa': const FenaCalculator(),
      'APRI': const ApriCalculator(),
      'FIB-4': const Fib4Calculator(),
      'PELD/MELD': const PeldMeldCalculator(),
      'HbA1c': const HbA1cEagCalculator(),
      'CSF WBC': const CsfWbcCorrectionCalculator(),
      'Paracetamol': const ParacetamolCalculator(),
      'BMI': const BmiCalculator(),
      'A-a gradient': const AaGradientCalculator(),
      'CPP': const CppCalculator(),
      'Henderson-Hasselbalch': const HendersonHasselbalchCalculator(),
      'Total body water': const TotalBodyWaterCalculator(),
      'Urine output': const UrineOutputCalculator(),
      'PEFR': const PefrPredictedCalculator(),
      'Fick': const FickCardiacOutputCalculator(),
      'MAP': const MapCalculator(),
      'FeMg': const FeMgCalculator(),
      'Reticulocyte': const ReticulocyteCalculator(),
      'Cryoprecipitate': const CryoprecipitateCalculator(),
      'Ideal body weight': const IdealBodyWeightCalculator(),
      'BMR': const BmrCalculator(),
      'Iron deficit': const IronDeficitCalculator(),
      'Infusion rate': const InfusionRateCalculator(),
      'Calcium equivalents': const CalciumEquivalentCalculator(),
      'Steroid converter': const SteroidConverter(),
      'Unit converter': const UnitConverter(),
    };

    testWidgets('every calculator renders without overflow (light)',
        (tester) async {
      for (final e in calculators.entries) {
        final err = await _renderOnPhone(tester, e.value);
        expect(err, isNull, reason: 'Layout overflow in ${e.key}');
      }
    });

    testWidgets('every calculator renders without overflow (dark)',
        (tester) async {
      for (final e in calculators.entries) {
        final err =
            await _renderOnPhone(tester, e.value, brightness: Brightness.dark);
        expect(err, isNull, reason: 'Dark-mode overflow in ${e.key}');
      }
    });

    testWidgets('paracetamol result (long value + long band) fits',
        (tester) async {
      // "Above treatment line" + "Treat with NAC" is the widest result pair.
      await _renderOnPhone(tester, const ParacetamolCalculator());
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), '4');
      await tester.enterText(fields.at(1), '250');
      await tester.enterText(fields.at(2), '20');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull,
          reason: 'Overflow with the longest result value + band');
      expect(find.text('Above treatment line'), findsOneWidget);
      expect(find.text('Treat with NAC'), findsOneWidget);
    });
  });

  group('Hubs fit a 375px phone', () {
    testWidgets('Paediatric Scores hub renders (both sort modes)',
        (tester) async {
      final err = await _renderOnPhone(tester, const PaediatricScoresHub());
      expect(err, isNull, reason: 'Scores hub overflow in system mode');

      await tester.tap(find.text('A–Z'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull,
          reason: 'Scores hub overflow in A–Z mode');
    });

    testWidgets('Calculators hub renders', (tester) async {
      final err = await _renderOnPhone(tester, const CalculatorsHubScreen());
      expect(err, isNull, reason: 'Calculators hub overflow');
      expect(find.text('Neonatal Calculators'), findsOneWidget);
      expect(find.text('Paediatric Calculators'), findsOneWidget);
    });
  });
}
