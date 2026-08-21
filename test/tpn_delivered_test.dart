// =============================================================================
// test/tpn_delivered_test.dart
//
// WHY THIS EXISTS
// ---------------
// The TPN nutrition card reported the GIR, carbohydrate and calories that were
// ASKED FOR, regardless of what the dextrose mix worked out to.
//
// When the chosen stock pair cannot bracket the target concentration the mix
// is clamped, and in the out-of-range case to ZERO volume of both stocks — a
// bag containing no dextrose at all. The mix box showed an error, but the
// nutrition card sitting directly beneath it still displayed the prescribed
// GIR, so the two halves of the same screen disagreed and the wrong half read
// like a result.
//
// Everything the card shows now derives from what the prescribed volumes
// actually contain.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/calculators/tpn_calculator.dart';

void main() {
  group('Delivered dextrose grams', () {
    test('a normal two-stock mix sums to the target', () {
      // 91.35 ml at 14.19% from D10 + D25.
      // v1 = 91.35 * (14.19 - 25) / (10 - 25) = 65.83 ml of D10
      const volA = 65.83, volB = 91.35 - 65.83;
      final g = tpnDeliveredGrams(volA, 10, volB, 25);
      expect(g, closeTo(12.96, 0.05)); // GIR 6 on a 1.5 kg baby
    });

    test('zero volumes deliver zero grams', () {
      // This is the out-of-range clamp: no dextrose in the bag at all.
      expect(tpnDeliveredGrams(0, 10, 0, 25), 0.0);
    });

    test('a single stock delivers its own concentration', () {
      expect(tpnDeliveredGrams(100, 10, 0, 10), closeTo(10.0, 1e-9));
    });
  });

  group('Delivered nutrition', () {
    // A 1.5 kg baby prescribed GIR 6 => 8.64 g/kg/day of carbohydrate.
    const w = 1.5;
    const carbsTarget = 8.64;
    const girTarget = 6.0;
    // Protein 3 g/kg/day (12 kcal) + carbohydrate 8.64 g/kg/day (29.4 kcal).
    const kcalTarget = 3 * 4 + carbsTarget * 3.4;

    test('an exact mix reports the prescription unchanged', () {
      final d = tpnDeliveredNutrition(
        deliveredGrams: 12.96, // 8.64 g/kg/day x 1.5 kg
        weight: w,
        carbsGkgTarget: carbsTarget,
        calKcalKgTarget: kcalTarget,
        girTarget: girTarget,
      );
      expect(d.gir, closeTo(6.0, 0.01));
      expect(d.carbsGkg, closeTo(8.64, 0.01));
      expect(d.calKcalKg, closeTo(kcalTarget, 0.01));
      expect(d.shortfall, isFalse);
    });

    test('an unreachable target reports zero GIR, not the prescription', () {
      // The exact defect: stocks out of range, so the clamp gives no dextrose.
      final d = tpnDeliveredNutrition(
        deliveredGrams: 0.0,
        weight: w,
        carbsGkgTarget: carbsTarget,
        calKcalKgTarget: kcalTarget,
        girTarget: girTarget,
      );
      expect(d.gir, 0.0, reason: 'a bag with no dextrose cannot deliver GIR 6');
      expect(d.carbsGkg, 0.0);
      expect(d.shortfall, isTrue, reason: 'the user must be warned');
      // Protein calories survive; only the carbohydrate share is lost.
      expect(d.calKcalKg, closeTo(12.0, 0.01));
    });

    test('a partial shortfall is caught, and a rounding difference is not', () {
      final big = tpnDeliveredNutrition(
        deliveredGrams: 10.0, // vs 12.96 prescribed
        weight: w,
        carbsGkgTarget: carbsTarget,
        calKcalKgTarget: kcalTarget,
        girTarget: girTarget,
      );
      expect(big.gir, closeTo(4.63, 0.01));
      expect(big.shortfall, isTrue);

      final tiny = tpnDeliveredNutrition(
        deliveredGrams: 12.95, // 0.005 mg/kg/min out — noise, not a warning
        weight: w,
        carbsGkgTarget: carbsTarget,
        calKcalKgTarget: kcalTarget,
        girTarget: girTarget,
      );
      expect(tiny.shortfall, isFalse);
    });

    test('no mix yet falls back to the prescription without warning', () {
      final d = tpnDeliveredNutrition(
        deliveredGrams: null,
        weight: w,
        carbsGkgTarget: carbsTarget,
        calKcalKgTarget: kcalTarget,
        girTarget: girTarget,
      );
      expect(d.gir, girTarget);
      expect(d.shortfall, isFalse);
    });

    test('a zero weight cannot divide, and must not produce NaN', () {
      final d = tpnDeliveredNutrition(
        deliveredGrams: 12.96,
        weight: 0,
        carbsGkgTarget: carbsTarget,
        calKcalKgTarget: kcalTarget,
        girTarget: girTarget,
      );
      expect(d.gir.isNaN, isFalse);
      expect(d.gir, girTarget);
    });
  });
}
