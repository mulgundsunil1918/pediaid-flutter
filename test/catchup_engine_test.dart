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
}
