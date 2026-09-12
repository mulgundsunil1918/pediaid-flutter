// =============================================================================
// test/rabies_rig_test.dart
//
// Passive-immunisation dose, volume, and the day-7 window.
//
// The failure this file exists to prevent is a plausible-looking millilitre
// figure derived from a concentration nobody checked. IAP prints 40 IU/mL for
// single-monoclonal RMAb and 600 IU/mL for the cocktail — a fifteen-fold
// difference — so a tool that assumed a concentration to avoid an empty field
// would be manufacturing dosing errors at exactly the moment a clinician is
// least able to catch them.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/rabies/rabies_protocol.dart';
import 'package:pediaid_app/screens/rabies/rabies_rig.dart';

void main() {
  group('Spec cases 7-8: the arithmetic', () {
    test('case 7: a 15 kg child — HRIG 300 IU, ERIG 600 IU', () {
      expect(calculateRig(agent: kHrig, weightKg: 15).totalIu, 300);
      expect(calculateRig(agent: kErig, weightKg: 15).totalIu, 600);
    });

    test('case 8: a 20 kg child — HRIG 400 IU, ERIG 800 IU', () {
      expect(calculateRig(agent: kHrig, weightKg: 20).totalIu, 400);
      expect(calculateRig(agent: kErig, weightKg: 20).totalIu, 800);
    });

    test('the per-kg rates are the ones both sources print', () {
      expect(kHrig.iuPerKg, 20);
      expect(kErig.iuPerKg, 40);
      expect(kRmabSingle.iuPerKg, 3.33);
      expect(kRmabCocktail.iuPerKg, 40);
    });

    test('fractional weights are not silently rounded to whole kilograms', () {
      // 12.4 kg is a real paediatric weight and 248 is a real dose.
      expect(calculateRig(agent: kHrig, weightKg: 12.4).totalIu,
          closeTo(248, 0.001));
    });

    test('the 3.33 IU/kg monoclonal is not rounded to 3', () {
      final d = calculateRig(agent: kRmabSingle, weightKg: 15);
      expect(d.totalIu, closeTo(49.95, 0.001));
      expect(d.iuLabel, '49.95 IU');
    });

    test('display trims false precision without losing real digits', () {
      expect(calculateRig(agent: kHrig, weightKg: 15).iuLabel, '300 IU');
      expect(calculateRig(agent: kHrig, weightKg: 12.4).iuLabel, '248 IU');
      expect(calculateRig(agent: kRmabSingle, weightKg: 20).iuLabel, '66.6 IU');
    });
  });

  group('a dose is never invented', () {
    test('no weight, no dose — and the reason is named', () {
      final d = calculateRig(agent: kHrig);
      expect(d.totalIu, isNull);
      expect(d.isComplete, isFalse);
      expect(d.iuLabel, '—');
      expect(d.missing.first, contains('weight'));
    });

    test('a zero or negative weight is refused, not computed', () {
      expect(calculateRig(agent: kHrig, weightKg: 0).totalIu, isNull);
      expect(calculateRig(agent: kHrig, weightKg: -5).totalIu, isNull);
    });

    test('no concentration, no volume — the IU dose still stands', () {
      // HRIG has no printed potency: the dose is knowable, the volume is not.
      final d = calculateRig(agent: kHrig, weightKg: 15);
      expect(d.totalIu, 300);
      expect(d.volumeMl, isNull);
      expect(d.volumeLabel, '—');
      expect(d.missing.single, contains('concentration'));
    });

    test('a supplied concentration gives a volume', () {
      final d = calculateRig(
          agent: kHrig, weightKg: 15, concentrationIuPerMl: 150);
      expect(d.volumeMl, closeTo(2.0, 0.0001));
      expect(d.volumeLabel, '2 mL');
      expect(d.missing, isEmpty);
    });

    test("the product in the room overrides the guideline's printed potency",
        () {
      // IAP prints 600 IU/mL for the cocktail; this vial is 300.
      final printed = calculateRig(agent: kRmabCocktail, weightKg: 15);
      expect(printed.volumeMl, closeTo(1.0, 0.0001));

      final actual = calculateRig(
          agent: kRmabCocktail, weightKg: 15, concentrationIuPerMl: 300);
      expect(actual.volumeMl, closeTo(2.0, 0.0001),
          reason: 'the person holding the vial is the authority on its potency');
      expect(actual.concentrationIuPerMl, 300,
          reason: 'the concentration used must be reported back');
    });

    test('the two RMAb potencies differ fifteen-fold and must not be swapped',
        () {
      expect(kRmabSingle.concentrationIuPerMl, 40);
      expect(kRmabCocktail.concentrationIuPerMl, 600);
      final single = calculateRig(agent: kRmabSingle, weightKg: 15);
      final cocktail = calculateRig(agent: kRmabCocktail, weightKg: 15);
      expect(single.volumeMl, closeTo(1.24875, 0.0001));
      expect(cocktail.volumeMl, closeTo(1.0, 0.0001));
    });

    test('all four agents calculate together for the comparison table', () {
      final all = calculateAllRig(weightKg: 15);
      expect(all.length, 4);
      expect(all.every((d) => d.isComplete), isTrue);
    });
  });

  group('Spec case 10: the day-7 RIG window', () {
    final d0 = DateTime(2026, 9, 12);

    test('not started: give it now, with the first dose', () {
      final w = rigWindow(today: d0);
      expect(w.status, RigWindowStatus.notStarted);
      expect(w.message, contains('as soon as possible'));
    });

    test('day 0 is open', () {
      final w = rigWindow(firstVaccineDate: d0, today: d0);
      expect(w.status, RigWindowStatus.open);
      expect(w.daysSinceFirstDose, 0);
    });

    test('day 7 is the last open day', () {
      final w = rigWindow(
          firstVaccineDate: d0, today: d0.add(const Duration(days: 7)));
      expect(w.status, RigWindowStatus.open);
      expect(w.daysRemaining, 0);
    });

    test('day 8 is CLOSED and says so', () {
      final w = rigWindow(
          firstVaccineDate: d0, today: d0.add(const Duration(days: 8)));
      expect(w.status, RigWindowStatus.closed);
      expect(w.message, contains('Do not give RIG beyond'));
    });

    test('long past the window is still closed, not wrapped around', () {
      final w = rigWindow(
          firstVaccineDate: d0, today: d0.add(const Duration(days: 400)));
      expect(w.status, RigWindowStatus.closed);
    });

    test('a first-dose date in the future is flagged, not treated as day 0', () {
      final w = rigWindow(
          firstVaccineDate: d0.add(const Duration(days: 3)), today: d0);
      expect(w.status, RigWindowStatus.unknown);
      expect(w.message, contains('Check the date'));
    });

    test('the window constant is 7 days, as both sources state', () {
      expect(kRigWindowDays, 7);
    });
  });
}
