// =============================================================================
// test/rop_screening_test.dart
//
// Spec §72 requires a test case per scenario before release. This covers the
// screening-eligibility and first-examination-timing half (cases 1–14 and
// 34–37); classification, treatment and follow-up land with their phases.
//
// The safety cases matter more than the arithmetic ones. Spec §2 and §45 say
// incomplete input must never conclude that screening is not needed, and §13
// forbids mixing protocols — both are asserted here rather than assumed.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/rop/rop_engine.dart';
import 'package:pediaid_app/screens/rop/rop_protocol.dart';

/// Fixed dates so the suite cannot drift with the calendar.
final _birth = DateTime(2026, 8, 1);
DateTime _dol(int day) => _birth.add(Duration(days: day));

RopPatient _p({
  int? ga,
  int gaDays = 0,
  int? bw,
  int dayOfLife = 0,
  List<String> risk = const [],
  bool concern = false,
  DateTime? birth,
}) =>
    RopPatient(
      gaWeeks: ga,
      gaDays: gaDays,
      birthWeightG: bw,
      birthDate: birth ?? _birth,
      assessmentDate: (birth ?? _birth).add(Duration(days: dayOfLife)),
      riskFactors: risk,
      clinicianConcern: concern,
    );

void main() {
  group('Spec §72 — Indian protocol eligibility', () {
    // Cases 1–6: every one of these is under BOTH the GA and BW thresholds.
    test('cases 1-6: preterm infants all qualify, and say why', () {
      const cases = [
        (24, 650), (25, 800), (28, 1100), (30, 1400), (32, 1800), (34, 1900),
      ];
      for (final (ga, bw) in cases) {
        final r = evaluateScreening(_p(ga: ga, bw: bw), ropProtocolIndia);
        expect(r.isIndicated, isTrue, reason: 'GA $ga BW $bw should qualify');
        expect(r.reasons, isNotEmpty,
            reason: 'spec §8 forbids reporting eligibility without a reason');
        expect(r.reasons.join(), contains('$ga'),
            reason: 'the reason should quote the infant\'s own value');
      }
    });

    // Case 7: GA 35, BW 2100 — above the GA threshold, above BW, qualifies
    // ONLY through the risk-factor criterion. This is the case a plain GA/BW
    // filter misses, which §9 exists to warn about.
    test('case 7: GA 35 BW 2100 with prolonged oxygen qualifies on risk', () {
      final none = evaluateScreening(_p(ga: 35, bw: 2100), ropProtocolIndia);
      expect(none.status, ScreeningStatus.notIndicated,
          reason: 'no criterion met without risk factors');

      final withRisk = evaluateScreening(
        _p(ga: 35, bw: 2100, risk: const ['Prolonged oxygen requirement']),
        ropProtocolIndia,
      );
      expect(withRisk.isIndicated, isTrue);
      expect(withRisk.reasons.join(), contains('Prolonged oxygen'));
    });

    // Case 8: GA 36, BW 2300 + severe illness.
    test('case 8: GA 36 BW 2300 with severe illness qualifies on risk', () {
      final r = evaluateScreening(
        _p(ga: 36, bw: 2300, risk: const ['Other significant neonatal illness']),
        ropProtocolIndia,
      );
      expect(r.isIndicated, isTrue);
    });

    // Case 9: term, well — the only case that should come back negative.
    test('case 9: GA 37 BW 2500 with no risk factors is not indicated', () {
      final r = evaluateScreening(_p(ga: 37, bw: 2500), ropProtocolIndia);
      expect(r.status, ScreeningStatus.notIndicated);
      expect(r.reasons, isEmpty);
    });

    test('clinician judgement alone qualifies (spec §8 criterion 4)', () {
      final r = evaluateScreening(
        _p(ga: 36, bw: 2400, concern: true),
        ropProtocolIndia,
      );
      expect(r.isIndicated, isTrue);
      expect(r.reasons.join().toLowerCase(), contains('clinician'));
    });
  });

  group('Spec §10 — first examination timing, India', () {
    test('before the window: reports days until due', () {
      // RBSK 2017: "Initial Screen at 4 Weeks (30 Days) of Birth."
      final r = evaluateScreening(_p(ga: 30, bw: 1400, dayOfLife: 19),
          ropProtocolIndia);
      expect(r.status, ScreeningStatus.indicated);
      expect(r.windowFromDay, 28);
      expect(r.windowToDay, 30);
      expect(r.daysUntilDue, 9, reason: 'day 19 → 9 days to day 28');
    });

    test('inside the window: due now', () {
      final r = evaluateScreening(_p(ga: 30, bw: 1400, dayOfLife: 29),
          ropProtocolIndia);
      expect(r.status, ScreeningStatus.dueNow);
    });

    test('case 13: past the window is OVERDUE, never hidden', () {
      final r = evaluateScreening(_p(ga: 30, bw: 1400, dayOfLife: 34),
          ropProtocolIndia);
      expect(r.status, ScreeningStatus.overdue,
          reason: 'spec §10: never hide an overdue examination');
      expect(r.daysUntilDue, lessThan(0));
    });

    test('day 28 exactly is due, not overdue', () {
      final r = evaluateScreening(_p(ga: 30, bw: 1400, dayOfLife: 28),
          ropProtocolIndia);
      expect(r.status, ScreeningStatus.dueNow);
    });

    test('day 30 exactly is still due, day 31 is overdue', () {
      expect(evaluateScreening(_p(ga: 30, bw: 1400, dayOfLife: 30),
              ropProtocolIndia).status,
          ScreeningStatus.dueNow);
      expect(evaluateScreening(_p(ga: 30, bw: 1400, dayOfLife: 31),
              ropProtocolIndia).status,
          ScreeningStatus.overdue);
    });
  });

  group('Spec §11 — early pathway is named, not buried', () {
    test('case 10: very preterm infant is flagged for the early pathway', () {
      // RBSK: "less than 28 weeks ... or less than 1200 grams" → 2-3 weeks.
      expect(evaluateScreening(_p(ga: 25, bw: 800), ropProtocolIndia)
          .earlyPathway, isTrue);
      // A 27-week infant is inside "less than 28 weeks"; a 28-week one is not.
      expect(evaluateScreening(_p(ga: 27, bw: 1400), ropProtocolIndia)
          .earlyPathway, isTrue);
      expect(evaluateScreening(_p(ga: 28, bw: 1400), ropProtocolIndia)
          .earlyPathway, isFalse);
      // 1199 g is inside "less than 1200 grams"; 1200 g is not.
      expect(evaluateScreening(_p(ga: 30, bw: 1199), ropProtocolIndia)
          .earlyPathway, isTrue);
      expect(evaluateScreening(_p(ga: 30, bw: 1200), ropProtocolIndia)
          .earlyPathway, isFalse);
    });

    test('a 32-week 1800 g infant is not on the early pathway', () {
      final r = evaluateScreening(_p(ga: 32, bw: 1800), ropProtocolIndia);
      expect(r.earlyPathway, isFalse);
    });
  });

  group('Spec §2 and §45 — incomplete data never means "no"', () {
    test('missing gestational age does not conclude not-indicated', () {
      final r = evaluateScreening(_p(bw: 2400), ropProtocolIndia);
      expect(r.status, ScreeningStatus.insufficientData,
          reason: 'a missing GA read as "above threshold" is false '
              'reassurance about a sight-threatening disease');
      expect(r.missing, contains('Gestational age at birth'));
    });

    test('missing birth weight does not conclude not-indicated', () {
      final r = evaluateScreening(_p(ga: 36), ropProtocolIndia);
      expect(r.status, ScreeningStatus.insufficientData);
    });

    test('case 34: a birth date after the assessment date is rejected', () {
      final r = evaluateScreening(
        RopPatient(
          gaWeeks: 30,
          birthWeightG: 1400,
          birthDate: DateTime(2026, 9, 1),
          assessmentDate: DateTime(2026, 8, 1),
        ),
        ropProtocolIndia,
      );
      expect(r.status, ScreeningStatus.insufficientData);
    });
  });

  group('Spec §13 and §50 — protocols must not be mixed', () {
    // The same infant, three protocols, three different answers. If any two
    // agree here, a threshold has leaked between protocols.
    test('case 36/37: GA 32, BW 1800 differs by protocol', () {
      final p = _p(ga: 32, bw: 1800);
      expect(evaluateScreening(p, ropProtocolIndia).isIndicated, isTrue,
          reason: 'India: BW ≤2000 g');
      expect(evaluateScreening(p, ropProtocolAap).isIndicated, isFalse,
          reason: 'AAP: BW >1500 g and GA >30 weeks');
      expect(evaluateScreening(p, ropProtocolUk).isIndicated, isFalse,
          reason: 'UK: BW ≥1501 g and GA ≥31 weeks');
    });

    test('AAP timing uses the later of PMA and chronological age', () {
      // GA 24 → 31 weeks PMA is day (31*7 − 24*7) = 49; 4 weeks is day 28.
      // The later, 49, must win.
      final r = evaluateScreening(_p(ga: 24, bw: 650, dayOfLife: 30),
          ropProtocolAap);
      expect(r.windowFromDay, 49);
      expect(r.timingRule, contains('whichever is later'));

      // GA 31 has no PMA target, so the 4-week rule stands alone.
      final r2 = evaluateScreening(_p(ga: 31, bw: 1400, dayOfLife: 10),
          ropProtocolAap);
      expect(r2.windowFromDay, 28);
    });
  });

  group('PMA arithmetic (spec §7, §47, §48)', () {
    test('GA 30+2 at 12 days of life is 32+0', () {
      final pma = computePma(_p(ga: 30, gaDays: 2, bw: 1400, dayOfLife: 12));
      expect(pma.toString(), '32+0');
    });

    test('case 35: a leap-year birth date counts days correctly', () {
      // 2028 is a leap year; 29 Feb → 31 Mar is 31 days.
      final leap = DateTime(2028, 2, 29);
      expect(daysBetween(leap, DateTime(2028, 3, 31)), 31);
      final pma = computePma(RopPatient(
        gaWeeks: 28,
        birthWeightG: 1000,
        birthDate: leap,
        assessmentDate: DateTime(2028, 3, 31),
      ));
      expect(pma!.totalDays, 28 * 7 + 31);
    });

    test('time of day never shifts the day count', () {
      final a = DateTime(2026, 8, 1, 23, 30);
      final b = DateTime(2026, 8, 2, 1, 15);
      expect(daysBetween(a, b), 1);
    });
  });

  group('Clinical governance', () {
    test('every protocol records when it was checked against its source', () {
      // Spec §73 step 9 — record the date each reference was verified. Values
      // were transcribed from the source documents on 2026-08-26.
      for (final p in ropProtocols) {
        expect(p.lastVerified, isNotNull,
            reason: '${p.name}: no verification date recorded');
        expect(p.references, isNotEmpty);
        expect(p.references.first.length, greaterThan(30),
            reason: '${p.name}: reference must be a real citation');
      }
    });

    test('AAP Table 1 is transcribed, not approximated', () {
      // Each row of the AAP table gives a PMA and a chronologic age that
      // describe the SAME date. Both are stored, so a future edit to either
      // column shows up rather than being silently absorbed.
      for (final r in ropProtocolAap.firstExamRules) {
        if (r.pmaWeeks == null || r.chronologicalWeeks == null) continue;
        expect(r.pmaWeeks! - r.gaFromWeeks, r.chronologicalWeeks,
            reason: 'GA ${r.gaFromWeeks}: PMA ${r.pmaWeeks} and chronologic '
                '${r.chronologicalWeeks} disagree about the same date');
      }
    });

    test('India carries the breadth warning required by spec §9', () {
      expect(ropProtocolIndia.breadthWarning, isNotNull);
      expect(ropProtocolIndia.breadthWarning!.toLowerCase(), contains('high risk'));
    });
  });
}
