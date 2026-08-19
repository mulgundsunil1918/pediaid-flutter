// Unit tests for the catch-up immunization engine (pure Dart, no Flutter).
// These prove the CLINICAL LOGIC independent of any UI or rule-source accuracy.

import 'package:flutter_test/flutter_test.dart';
import 'package:pediaid_app/screens/vaccines/catchup/catchup_engine.dart';
import 'package:pediaid_app/screens/vaccines/catchup/vaccine_rules.dart';

void main() {
  final engine = CatchupEngine(kCatchupRules);
  final today = DateTime(2026, 8, 16);
  DateTime dobDaysAgo(int d) => today.subtract(Duration(days: d));

  Recommendation rec(CatchupResult r, String id) =>
      r.recommendations.firstWhere((x) => x.vaccineId == id);

  test('Newborn, no vaccines → BCG / HepB / OPV due today', () {
    final r = engine.evaluate(dob: today, today: today, history: {});
    expect(rec(r, 'bcg').status, RecStatus.dueToday);
    expect(rec(r, 'hepb').status, RecStatus.dueToday);
    expect(rec(r, 'opv').status, RecStatus.dueToday);
    // Not yet old enough for 6-week vaccines.
    expect(rec(r, 'dtp').status, RecStatus.notYetDue);
    expect(rec(r, 'rota').status, RecStatus.notYetDue);
  });

  test('2-year-old, unvaccinated → DTP due, rotavirus NOT eligible', () {
    final dob = dobDaysAgo(730);
    final r = engine.evaluate(dob: dob, today: today, history: {});
    expect(rec(r, 'rota').status, RecStatus.notEligible,
        reason: 'Rotavirus must never be offered past its age window');
    expect(rec(r, 'dtp').status, RecStatus.dueToday);
    expect(rec(r, 'mmr').status, RecStatus.dueToday);
  });

  test('DTP series is CONTINUED, never restarted', () {
    final dob = dobDaysAgo(730); // 2 years old now
    final history = {
      'dtp': [
        GivenDose(dob.add(const Duration(days: 42))), // dose 1 @ 6 wk
        GivenDose(dob.add(const Duration(days: 70))), // dose 2 @ 10 wk
      ],
    };
    final r = engine.evaluate(dob: dob, today: today, history: history);
    final dtp = rec(r, 'dtp');
    expect(dtp.doseNumber, 3, reason: 'Next DTP is dose 3, not a restart');
    expect(dtp.status, RecStatus.missedEligible);
  });

  test('Rotavirus never initiated in an older child', () {
    final r =
        engine.evaluate(dob: dobDaysAgo(3 * 365), today: today, history: {});
    expect(rec(r, 'rota').status, RecStatus.notEligible);
  });

  test('MMR: minimum interval not yet elapsed → not yet due', () {
    final dob = dobDaysAgo(300); // ~10 months
    final history = {
      'mmr': [GivenDose(dob.add(const Duration(days: 285)))], // dose 1 recently
    };
    final r = engine.evaluate(dob: dob, today: today, history: history);
    final mmr = rec(r, 'mmr');
    expect(mmr.doseNumber, 2);
    expect(mmr.status, RecStatus.notYetDue);
    expect(mmr.earliestDate, isNotNull);
  });

  test('Rotavirus within the window (8 weeks, no doses) → due today', () {
    final r = engine.evaluate(dob: dobDaysAgo(56), today: today, history: {});
    expect(rec(r, 'rota').status, RecStatus.dueToday);
  });

  test('An invalid too-early dose is not silently counted', () {
    final dob = dobDaysAgo(365);
    // MMR "given" at 6 months — below the 9-month minimum age → invalid.
    final history = {
      'mmr': [GivenDose(dob.add(const Duration(days: 180)))],
    };
    final r = engine.evaluate(dob: dob, today: today, history: history);
    final mmr = rec(r, 'mmr');
    expect(mmr.doseNumber, 1,
        reason: 'The sub-minimum-age dose must not count as dose 1');
  });

  test('Special-situation vaccines are flagged, not routinely due', () {
    final r = engine.evaluate(dob: dobDaysAgo(365), today: today, history: {});
    expect(rec(r, 'je').status, RecStatus.special);
    expect(rec(r, 'rabies').status, RecStatus.special);
  });

  // ── Regression: errors found 2026-08-19 ─────────────────────────────────
  group('catch-up interval fixes', () {
    test('DTP dose 3 is due 4 weeks after dose 2 for an infant', () {
      // Was 24 weeks: the older-child 0-1-6 month pattern had been applied to
      // every age, delaying an infant's third DTP by five months.
      final rule = kCatchupRules.firstWhere((r) => r.id == 'dtp');
      final infantBand = rule.bands.first;
      expect(infantBand.intervalBefore(2), 28, reason: 'dose 1 -> 2');
      expect(infantBand.intervalBefore(3), 28, reason: 'dose 2 -> 3');
    });

    test('DTP keeps the 0-1-6 month pattern for a late starter', () {
      final rule = kCatchupRules.firstWhere((r) => r.id == 'dtp');
      final olderBand = rule.bands.last;
      expect(olderBand.intervalBefore(2), 28);
      expect(olderBand.intervalBefore(3), 168, reason: '24 weeks');
    });

    test('Hep B carries the whole-span and final-dose-age constraints', () {
      // 4 wk + 8 wk alone would allow a 12-week series; the final dose must be
      // >=16 wk after dose 1 and given at >=24 wk of age.
      final rule = kCatchupRules.firstWhere((r) => r.id == 'hepb');
      expect(rule.minFirstToFinalDays, 112, reason: '16 weeks');
      expect(rule.minFinalDoseAgeDays, 168, reason: '24 weeks');
    });

    test('rotavirus keeps its hard age limits', () {
      final rule = kCatchupRules.firstWhere((r) => r.id == 'rota');
      expect(rule.maxInitAgeDays, 105, reason: 'start by 15 weeks');
      expect(rule.maxCompleteAgeDays, 240, reason: 'complete by 8 months');
    });
  });

  // ── Fixes 1, 2, 6 (audit of 2026-08-19) ────────────────────────────────
  group('live-vaccine spacing (28 days)', () {
    final dob = DateTime(2024, 1, 1);

    test('MMR is deferred when varicella was given 10 days ago', () {
      final today = DateTime(2026, 6, 1);
      final res = CatchupEngine(kCatchupRules).evaluate(
        dob: dob,
        today: today,
        history: {
          'varicella': [GivenDose(today.subtract(const Duration(days: 10)))],
        },
      );
      final mmr = res.recommendations.firstWhere((r) => r.vaccineId == 'mmr');
      expect(mmr.status, RecStatus.notYetDue,
          reason: 'two live injectables must be 28 days apart');
      expect(mmr.earliestDate, isNotNull);
      expect(mmr.reason, contains('live'));
    });

    test('MMR is NOT deferred when varicella was given 30 days ago', () {
      final today = DateTime(2026, 6, 1);
      final res = CatchupEngine(kCatchupRules).evaluate(
        dob: dob,
        today: today,
        history: {
          'varicella': [GivenDose(today.subtract(const Duration(days: 30)))],
        },
      );
      final mmr = res.recommendations.firstWhere((r) => r.vaccineId == 'mmr');
      expect(mmr.status, isNot(RecStatus.notYetDue));
    });

    test('oral live vaccines do not trigger the rule', () {
      final today = DateTime(2026, 6, 1);
      final res = CatchupEngine(kCatchupRules).evaluate(
        dob: dob,
        today: today,
        history: {
          'rota': [GivenDose(today.subtract(const Duration(days: 5)))],
        },
      );
      final mmr = res.recommendations.firstWhere((r) => r.vaccineId == 'mmr');
      expect(mmr.status, isNot(RecStatus.notYetDue),
          reason: 'rotavirus is oral live and is exempt');
    });

    test('rotavirus and OPV are classified as oral live', () {
      for (final id in ['rota', 'opv']) {
        final rule = kCatchupRules.firstWhere((r) => r.id == id);
        expect(rule.kind, VaccineKind.liveOral, reason: id);
        expect(rule.isLiveParenteral, isFalse, reason: id);
      }
    });
  });

  group('invalid doses are reported, not dropped silently', () {
    test('a too-early dose comes back with a reason', () {
      final dob = DateTime(2025, 1, 1);
      final res = CatchupEngine(kCatchupRules).evaluate(
        dob: dob,
        today: DateTime(2026, 6, 1),
        // MMR at 2 months — well before the 9-month minimum age.
        history: {'mmr': [GivenDose(dob.add(const Duration(days: 60)))]},
      );
      final mmr = res.recommendations.firstWhere((r) => r.vaccineId == 'mmr');
      expect(mmr.rejectedDoses, isNotEmpty);
      expect(mmr.rejectedDoses.first.toLowerCase(), contains('minimum age'));
    });

    test('a valid series reports nothing rejected', () {
      final dob = DateTime(2024, 1, 1);
      final res = CatchupEngine(kCatchupRules).evaluate(
        dob: dob,
        today: DateTime(2026, 6, 1),
        history: {'mmr': [GivenDose(dob.add(const Duration(days: 300)))]},
      );
      final mmr = res.recommendations.firstWhere((r) => r.vaccineId == 'mmr');
      expect(mmr.rejectedDoses, isEmpty);
    });
  });

  // ── Fixes 3, 4, 5 (audit of 2026-08-19) ────────────────────────────────
  group('absolute constraints are not softened by the 4-day grace', () {
    test('Hep B dose 3 is refused 3 days before the 24-week minimum age', () {
      final dob = DateTime(2025, 1, 1);
      // Doses 1 and 2 long past, so only the age/span rule can block dose 3.
      final res = CatchupEngine(kCatchupRules).evaluate(
        dob: dob,
        today: dob.add(const Duration(days: 165)), // 3 days short of 168
        history: {
          'hepb': [
            GivenDose(dob),
            GivenDose(dob.add(const Duration(days: 30))),
          ],
        },
      );
      final hepb = res.recommendations.firstWhere((r) => r.vaccineId == 'hepb');
      expect(hepb.status, RecStatus.notYetDue,
          reason: 'grace must not relax a minimum AGE');
      expect(hepb.earliestDate, dob.add(const Duration(days: 168)));
    });

    test('Hep B dose 3 is allowed once 24 weeks and 16 weeks are both met', () {
      final dob = DateTime(2025, 1, 1);
      final res = CatchupEngine(kCatchupRules).evaluate(
        dob: dob,
        today: dob.add(const Duration(days: 170)),
        history: {
          'hepb': [
            GivenDose(dob),
            GivenDose(dob.add(const Duration(days: 30))),
          ],
        },
      );
      final hepb = res.recommendations.firstWhere((r) => r.vaccineId == 'hepb');
      expect(hepb.status, isNot(RecStatus.notYetDue));
    });
  });

  group('band selection ignores a dose that cannot count', () {
    test('an MMR given before the minimum age does not fix the band', () {
      final dob = DateTime(2025, 1, 1);
      // MMR at 2 months (invalid, <9 months) then a valid one at 10 months.
      final res = CatchupEngine(kCatchupRules).evaluate(
        dob: dob,
        today: dob.add(const Duration(days: 400)),
        history: {
          'mmr': [
            GivenDose(dob.add(const Duration(days: 60))),
            GivenDose(dob.add(const Duration(days: 300))),
          ],
        },
      );
      final mmr = res.recommendations.firstWhere((r) => r.vaccineId == 'mmr');
      // The invalid dose is reported and only the valid one counts.
      expect(mmr.rejectedDoses, hasLength(1));
      expect(mmr.dosesRequired, 2);
      expect(mmr.doseNumber, 2, reason: 'one valid dose so far');
    });
  });

  test('a SINGLE-dose series is still bound by a minimum final-dose age', () {
    // No shipping rule combines dosesRequired:1 with minFinalDoseAgeDays, so
    // this uses a synthetic rule. Before the fix the constraint lived inside
    // an `if (nextDose >= 2)` guard and could never fire for a 1-dose series.
    final dob = DateTime(2025, 1, 1);
    final rule = VaccineRule(
      id: 'synthetic',
      name: 'Synthetic single-dose',
      shortName: 'Syn',
      kind: VaccineKind.inactivated,
      minAgeDays: 0,
      minFinalDoseAgeDays: 100,
      bands: const [
        DoseBand(maxAgeDays: 1 << 30, dosesRequired: 1, intervalsDays: []),
      ],
      route: 'IM',
      notes: '',
      source: 'test',
      confidence: 'LOW',
    );

    final before = CatchupEngine([rule]).evaluate(
      dob: dob,
      today: dob.add(const Duration(days: 90)),
      history: const {},
    );
    expect(before.recommendations.single.status, RecStatus.notYetDue);
    expect(before.recommendations.single.earliestDate,
        dob.add(const Duration(days: 100)));

    final after = CatchupEngine([rule]).evaluate(
      dob: dob,
      today: dob.add(const Duration(days: 110)),
      history: const {},
    );
    expect(after.recommendations.single.status, RecStatus.dueToday);
  });

  // ── HPV single-dose, PCV/Hib booster, Rotarix (2026-08-19) ──────────────
  group('IAP-ACVIP 2025 schedule changes', () {
    final dob = DateTime(2014, 1, 1); // 12 y old on the test date
    final today = DateTime(2026, 6, 1);

    CatchupResult run({PatientSex sex = PatientSex.unknown, bool highRisk = false}) =>
        CatchupEngine(kCatchupRules).evaluate(
          dob: dob, today: today, history: const {}, sex: sex, highRisk: highRisk);

    test('an immunocompetent girl 9-15 needs ONE HPV dose', () {
      final hpv = run(sex: PatientSex.female)
          .recommendations.firstWhere((r) => r.vaccineId == 'hpv');
      expect(hpv.dosesRequired, 1);
    });

    test('a boy the same age still needs two', () {
      final hpv = run(sex: PatientSex.male)
          .recommendations.firstWhere((r) => r.vaccineId == 'hpv');
      expect(hpv.dosesRequired, 2);
    });

    test('unknown sex falls back to the safer two-dose schedule', () {
      final hpv = run().recommendations.firstWhere((r) => r.vaccineId == 'hpv');
      expect(hpv.dosesRequired, 2);
    });

    test('a high-risk girl does NOT get the single-dose schedule', () {
      final hpv = run(sex: PatientSex.female, highRisk: true)
          .recommendations.firstWhere((r) => r.vaccineId == 'hpv');
      expect(hpv.dosesRequired, 2,
          reason: 'reduced dosing is for immunocompetent children only');
    });
  });

  group('PCV / Hib booster', () {
    test('a 7-month starter needs a booster that cannot precede 12 months', () {
      final dob = DateTime(2025, 1, 1);
      final start = dob.add(const Duration(days: 220)); // ~7 months
      final res = CatchupEngine(kCatchupRules).evaluate(
        dob: dob,
        today: dob.add(const Duration(days: 300)), // ~10 months
        history: {
          'pcv': [GivenDose(start), GivenDose(start.add(const Duration(days: 30)))],
        },
      );
      final pcv = res.recommendations.firstWhere((r) => r.vaccineId == 'pcv');
      expect(pcv.dosesRequired, 3, reason: '2 primary + booster');
      expect(pcv.status, RecStatus.notYetDue);
      expect(pcv.earliestDate, dob.add(const Duration(days: 360)));
      expect(pcv.reason.toLowerCase(), contains('booster'));
    });

    test('Hib carries the same booster constraint', () {
      final hib = kCatchupRules.firstWhere((r) => r.id == 'hib');
      expect(hib.bands[1].minFinalDoseAgeDays, 360);
    });
  });

  group('rotavirus product', () {
    final dob = DateTime(2026, 4, 1);
    final today = dob.add(const Duration(days: 50));

    test('defaults to the 3-dose course', () {
      final r = CatchupEngine(kCatchupRules).evaluate(
        dob: dob, today: today, history: const {});
      expect(r.recommendations.firstWhere((x) => x.vaccineId == 'rota')
          .dosesRequired, 3);
    });

    test('Rotarix selection gives a 2-dose course', () {
      final r = CatchupEngine(kCatchupRules).evaluate(
        dob: dob, today: today, history: const {}, useAlternate: const {'rota'});
      expect(r.recommendations.firstWhere((x) => x.vaccineId == 'rota')
          .dosesRequired, 2);
    });
  });
}
