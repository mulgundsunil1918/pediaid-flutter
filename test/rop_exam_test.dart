// =============================================================================
// test/rop_exam_test.dart
//
// Spec §72 cases 15–33: ICROP-3 classification, Type 1/2, urgency, worst eye,
// and the incomplete-examination safety rules.
//
// The cases that matter most are the pairs that differ by ONE finding —
// Zone I Stage 3 with and without plus, Zone II Stage 2 with and without plus.
// Those are where a treatment table gets silently mis-transcribed, and the
// difference is whether a baby is treated this week or watched.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/rop/rop_exam.dart';

EyeFindings _e({
  RopZone zone = RopZone.unknown,
  RopStage stage = RopStage.unknown,
  PlusStatus plus = PlusStatus.unknown,
  int? hours,
  bool aggressive = false,
  bool notch = false,
}) =>
    EyeFindings(
      zone: zone,
      stage: stage,
      plus: plus,
      clockHours: hours,
      aggressive: aggressive,
      notch: notch,
    );

void main() {
  group('Spec §72 cases 15-19 — Type 1 hinges on one finding', () {
    test('case 15: Zone I Stage 3 + plus is Type 1', () {
      final c = classifyEye(
          _e(zone: RopZone.zoneI, stage: RopStage.stage3, plus: PlusStatus.plus),
          etropRules);
      expect(c.type, RopType.type1);
      expect(c.urgency, RopUrgency.urgentTreatment);
    });

    test('case 16: Zone I Stage 3 WITHOUT plus is still Type 1', () {
      // The rule that is easiest to get wrong: Zone I Stage 3 qualifies with
      // or without plus. Treating this as Type 2 would delay treatment.
      final c = classifyEye(
          _e(zone: RopZone.zoneI, stage: RopStage.stage3, plus: PlusStatus.none),
          etropRules);
      expect(c.type, RopType.type1);
      expect(c.reason, contains('with or without'));
    });

    test('case 17: Zone II Stage 2 + plus is Type 1', () {
      final c = classifyEye(
          _e(zone: RopZone.zoneII, stage: RopStage.stage2, plus: PlusStatus.plus),
          etropRules);
      expect(c.type, RopType.type1);
    });

    test('case 18: Zone II Stage 2 WITHOUT plus is not Type 1', () {
      final c = classifyEye(
          _e(zone: RopZone.zoneII, stage: RopStage.stage2, plus: PlusStatus.none),
          etropRules);
      expect(c.type, isNot(RopType.type1));
      expect(c.urgency, RopUrgency.none);
    });

    test('case 19: Zone II Stage 3 + plus is Type 1', () {
      final c = classifyEye(
          _e(zone: RopZone.zoneII, stage: RopStage.stage3, plus: PlusStatus.plus),
          etropRules);
      expect(c.type, RopType.type1);
    });

    test('Zone II Stage 3 without plus is Type 2, not Type 1', () {
      final c = classifyEye(
          _e(zone: RopZone.zoneII, stage: RopStage.stage3, plus: PlusStatus.none),
          etropRules);
      expect(c.type, RopType.type2);
    });

    test('Zone I Stage 1 with plus is Type 1 (any stage with plus)', () {
      final c = classifyEye(
          _e(zone: RopZone.zoneI, stage: RopStage.stage1, plus: PlusStatus.plus),
          etropRules);
      expect(c.type, RopType.type1);
    });
  });

  group('Spec §30 — detachment and aggressive ROP get their own urgency', () {
    test('cases 20-22: Stage 4A, 4B and 5 are urgent detachment', () {
      for (final s in [RopStage.stage4A, RopStage.stage4B, RopStage.stage5]) {
        final c = classifyEye(_e(stage: s), etropRules);
        expect(c.urgency, RopUrgency.urgentDetachment, reason: '${s.label}');
        // Flagged even though zone and plus were never recorded — waiting for
        // a complete dataset before warning about a detached retina is absurd.
        expect(c.type, RopType.type1);
      }
    });

    test('case 23: aggressive ROP is urgent on its own', () {
      final c = classifyEye(_e(zone: RopZone.zoneI, aggressive: true), etropRules);
      expect(c.urgency, RopUrgency.urgentAggressive);
      expect(c.type, RopType.type1);
    });

    test('case 24: pre-plus alone does not trigger treatment', () {
      final c = classifyEye(
          _e(zone: RopZone.zoneII, stage: RopStage.stage1, plus: PlusStatus.preplus),
          etropRules);
      expect(c.type, isNot(RopType.type1));
      expect(c.urgency, RopUrgency.none);
    });

    test('case 25: no ROP with immature vascularisation is neither type', () {
      final c = classifyEye(
          _e(zone: RopZone.zoneII, stage: RopStage.none, plus: PlusStatus.none),
          etropRules);
      expect(c.type, RopType.neither);
      expect(c.findings.describe(), contains('No ROP'));
    });
  });

  group('Spec §2 and §45 — incomplete never means "no disease"', () {
    test('cases 31-33: a missing zone, stage or plus gives cannotClassify', () {
      final noZone = classifyEye(
          _e(stage: RopStage.stage3, plus: PlusStatus.plus), etropRules);
      expect(noZone.type, RopType.cannotClassify);
      expect(noZone.missing, contains('Zone'));

      final noStage = classifyEye(
          _e(zone: RopZone.zoneII, plus: PlusStatus.plus), etropRules);
      expect(noStage.type, RopType.cannotClassify);
      expect(noStage.missing, contains('Stage'));

      final noPlus = classifyEye(
          _e(zone: RopZone.zoneII, stage: RopStage.stage3), etropRules);
      expect(noPlus.type, RopType.cannotClassify,
          reason: 'Zone II Stage 3 is Type 1 WITH plus and Type 2 without — '
              'unknown plus cannot be read as "without"');
      expect(noPlus.missing, contains('Plus status'));
    });

    test('a normal fellow eye cannot reassure over an unexamined one', () {
      final a = assessExam(
        _e(zone: RopZone.zoneIII, stage: RopStage.none, plus: PlusStatus.none),
        _e(zone: RopZone.zoneII), // left eye barely examined
        etropRules,
      );
      expect(a.type, RopType.cannotClassify,
          reason: 'the unexamined eye is the one that might be blind');
      expect(a.incomplete, isTrue);
    });

    test('but a Type 1 eye still reports Type 1 even if the other is unknown',
        () {
      final a = assessExam(
        _e(zone: RopZone.zoneI, stage: RopStage.stage3, plus: PlusStatus.plus),
        _e(), // nothing recorded
        etropRules,
      );
      expect(a.type, RopType.type1);
      expect(a.urgency, RopUrgency.urgentTreatment);
      expect(a.reason, contains('Right'));
    });
  });

  group('Spec §27 — worst eye names the finding, not a score', () {
    test('plus disease outranks a higher stage in the other eye', () {
      final w = worseEye(
        _e(zone: RopZone.zoneII, stage: RopStage.stage1, plus: PlusStatus.plus),
        _e(zone: RopZone.zoneII, stage: RopStage.stage3, plus: PlusStatus.none),
      );
      expect(w.eye, 'Right');
      expect(w.reason, contains('plus'));
    });

    test('a more posterior zone wins when plus status matches', () {
      final w = worseEye(
        _e(zone: RopZone.zoneI, stage: RopStage.stage1, plus: PlusStatus.none),
        _e(zone: RopZone.zoneIII, stage: RopStage.stage3, plus: PlusStatus.none),
      );
      expect(w.eye, 'Right');
      expect(w.reason.toLowerCase(), contains('posterior'));
    });

    test('detachment outranks everything', () {
      final w = worseEye(
        _e(zone: RopZone.zoneIII, stage: RopStage.stage4A),
        _e(zone: RopZone.zoneI, stage: RopStage.stage3, plus: PlusStatus.plus),
      );
      expect(w.eye, 'Right');
      expect(w.reason.toLowerCase(), contains('detachment'));
    });

    test('identical eyes report equal rather than picking one', () {
      final f = _e(zone: RopZone.zoneII, stage: RopStage.stage2, plus: PlusStatus.none);
      expect(worseEye(f, f).eye, 'Both equal');
    });
  });

  group('Spec §26 — the standardised sentence', () {
    test('reads in ICROP-3 order', () {
      final s = _e(
        zone: RopZone.zoneII,
        stage: RopStage.stage2,
        plus: PlusStatus.preplus,
        hours: 4,
      ).describe();
      expect(s, 'Zone II, Stage 2, pre-plus disease, 4 clock hours.');
    });

    test('aggressive ROP is described as such, not as a stage', () {
      final s = _e(zone: RopZone.zoneI, aggressive: true, hours: 6).describe();
      expect(s, contains('aggressive ROP'));
      expect(s, isNot(contains('Stage')));
    });

    test('an empty eye says so rather than inventing findings', () {
      expect(_e().describe(), 'No findings recorded.');
    });
  });

  group('Clinical governance', () {
    test('the treatment rule set names its source', () {
      expect(etropRules.source.toLowerCase(), contains('early treatment'));
      expect(etropRules.type1, isNotEmpty);
      expect(etropRules.type2, isNotEmpty);
    });

    test('every Type 1 rule states the finding it matches', () {
      for (final r in [...etropRules.type1, ...etropRules.type2]) {
        expect(r.description.trim(), isNotEmpty,
            reason: 'spec §29 requires showing the finding that triggered it');
      }
    });
  });
}
