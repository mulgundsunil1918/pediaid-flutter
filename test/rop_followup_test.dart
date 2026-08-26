// =============================================================================
// test/rop_followup_test.dart
//
// Spec §72 cases 26-30 plus the follow-up and termination rules.
//
// The cases worth having are the ones where a plausible shortcut would be
// wrong: running the untreated interval table on a treated infant (§34),
// discharging an anti-VEGF baby because the retina looks quiet (§36), and
// stopping screening on "no ROP today" (§39). Each of those is a real clinical
// error that a naive implementation makes by default.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/rop/rop_exam.dart';
import 'package:pediaid_app/screens/rop/rop_followup.dart';

final _exam = DateTime(2026, 8, 26);

ExamAssessment _assess(EyeFindings r, [EyeFindings? l]) =>
    assessExam(r, l ?? r, etropRules);

EyeFindings _e(RopZone z, RopStage s, PlusStatus p) =>
    EyeFindings(zone: z, stage: s, plus: p);

void main() {
  group('Spec §31 — intervals come from the rules, not invented', () {
    test('Zone I disease is seen within a week', () {
      final f = recommendFollowUp(
        assessment: _assess(_e(RopZone.zoneI, RopStage.stage1, PlusStatus.none)),
        examDate: _exam,
      );
      expect(f.interval, FollowUpInterval.withinOneWeek);
    });

    test('Zone II with no ROP is 2-3 weeks, not 2', () {
      // The draft had this a week short. AAP lists "immature vascularization:
      // zone II—no ROP" under 2- to 3-week follow-up.
      expect(
        recommendFollowUp(
          assessment: _assess(_e(RopZone.zoneII, RopStage.none, PlusStatus.none)),
          examDate: _exam,
        ).interval,
        FollowUpInterval.twoToThreeWeeks,
      );
    });

    test('Zone II Stage 1 gets 2 weeks; Zone III gets 2-3', () {
      expect(
        recommendFollowUp(
          assessment: _assess(_e(RopZone.zoneII, RopStage.stage1, PlusStatus.none)),
          examDate: _exam,
        ).interval,
        FollowUpInterval.twoWeeks,
      );
      expect(
        recommendFollowUp(
          assessment: _assess(_e(RopZone.zoneIII, RopStage.stage1, PlusStatus.none)),
          examDate: _exam,
        ).interval,
        FollowUpInterval.twoToThreeWeeks,
      );
    });

    test('the WORSE eye drives the interval', () {
      // Right eye quiet Zone III, left eye Zone I. Scheduling on the right eye
      // would follow the healthier retina.
      final f = recommendFollowUp(
        assessment: assessExam(
          _e(RopZone.zoneIII, RopStage.none, PlusStatus.none),
          _e(RopZone.zoneI, RopStage.stage1, PlusStatus.none),
          etropRules,
        ),
        examDate: _exam,
      );
      expect(f.interval, FollowUpInterval.withinOneWeek);
    });
  });

  group('Spec §32 — a deadline is not an appointment', () {
    test('"within 1 week" gets no exact date', () {
      final f = recommendFollowUp(
        assessment: _assess(_e(RopZone.zoneI, RopStage.stage1, PlusStatus.none)),
        examDate: _exam,
      );
      expect(f.interval.isDeadline, isTrue);
      expect(f.nextExamDate, isNull,
          reason: 'naming a date would falsely imply a mandated day');
      expect(f.interval.maxDays, 7);
    });

    test('"2 weeks" does get a date', () {
      final f = recommendFollowUp(
        assessment: _assess(_e(RopZone.zoneII, RopStage.stage1, PlusStatus.none)),
        examDate: _exam,
      );
      expect(f.nextExamDate, DateTime(2026, 9, 9));
      expect(f.days, 14);
    });
  });

  group('Spec §30 and §37 — urgency and reactivation override', () {
    test('Type 1 disease routes to urgent assessment, not an interval', () {
      final f = recommendFollowUp(
        assessment: _assess(_e(RopZone.zoneII, RopStage.stage3, PlusStatus.plus)),
        examDate: _exam,
      );
      expect(f.interval, FollowUpInterval.urgentAssessment);
      expect(f.nextExamDate, isNull);
    });

    test('detachment and aggressive ROP name themselves in the reason', () {
      expect(
        recommendFollowUp(
          assessment: _assess(const EyeFindings(stage: RopStage.stage4A)),
          examDate: _exam,
        ).reason.toLowerCase(),
        contains('detachment'),
      );
      expect(
        recommendFollowUp(
          assessment: _assess(const EyeFindings(zone: RopZone.zoneI, aggressive: true)),
          examDate: _exam,
        ).reason.toLowerCase(),
        contains('aggressive'),
      );
    });

    test('case 29: reactivation outranks even quiet findings', () {
      final f = recommendFollowUp(
        assessment: _assess(_e(RopZone.zoneIII, RopStage.none, PlusStatus.none)),
        examDate: _exam,
        treatment: const TreatmentRecord(
          type: RopTreatment.laser,
          reactivation: Reactivation.suspected,
        ),
      );
      expect(f.interval, FollowUpInterval.urgentAssessment);
      expect(f.reason.toLowerCase(), contains('reactivation'));
    });
  });

  group('Spec §34 — treated infants leave the untreated algorithm', () {
    test('cases 27-28: post-laser and post-anti-VEGF use treatment follow-up', () {
      for (final t in [RopTreatment.laser, RopTreatment.antiVegf]) {
        final f = recommendFollowUp(
          // Findings that would otherwise produce a routine 2-week interval.
          assessment: _assess(_e(RopZone.zoneII, RopStage.stage1, PlusStatus.none)),
          examDate: _exam,
          treatment: TreatmentRecord(type: t, date: _exam),
        );
        expect(f.interval, FollowUpInterval.treatmentFollowUp,
            reason: '${t.label} must not use the routine table');
        expect(f.reason, contains('not the routine interval'));
      }
    });
  });

  group('Spec §39 — screening does not stop on "no ROP today"', () {
    const quiet = TreatmentRecord();

    test('no ROP but vascularisation not documented: continue', () {
      final t = assessTermination(
        assessment: _assess(_e(RopZone.zoneII, RopStage.none, PlusStatus.none)),
        treatment: quiet,
        fullVascularisationDocumented: false,
      );
      expect(t.result, TerminationResult.continueSurveillance);
      expect(t.reason, contains('does not mean the retina is mature'));
    });

    test('vascularisation complete with no disease: may terminate', () {
      final t = assessTermination(
        assessment: _assess(_e(RopZone.zoneIII, RopStage.none, PlusStatus.none)),
        treatment: quiet,
        fullVascularisationDocumented: true,
      );
      expect(t.result, TerminationResult.canTerminate);
    });

    test('case 28: anti-VEGF never auto-terminates, however quiet', () {
      final t = assessTermination(
        assessment: _assess(_e(RopZone.zoneIII, RopStage.none, PlusStatus.none)),
        treatment: const TreatmentRecord(
          type: RopTreatment.antiVegf,
          regression: Regression.complete,
        ),
        fullVascularisationDocumented: true,
      );
      expect(t.result, TerminationResult.specialistDecision,
          reason: 'spec §36: late reactivation is described after anti-VEGF');
    });

    test('case 30: persistent avascular retina needs a specialist', () {
      final t = assessTermination(
        assessment: _assess(_e(RopZone.zoneIII, RopStage.none, PlusStatus.none)),
        treatment: const TreatmentRecord(avascular: AvascularRetina.yes),
        fullVascularisationDocumented: true,
      );
      expect(t.result, TerminationResult.specialistDecision);
    });

    test('an incomplete examination cannot stop screening', () {
      final t = assessTermination(
        assessment: assessExam(
          _e(RopZone.zoneIII, RopStage.none, PlusStatus.none),
          const EyeFindings(zone: RopZone.zoneII), // left eye incomplete
          etropRules,
        ),
        treatment: quiet,
        fullVascularisationDocumented: true,
      );
      expect(t.result, TerminationResult.insufficientInformation);
    });

    test('active urgent disease always continues surveillance', () {
      final t = assessTermination(
        assessment: _assess(_e(RopZone.zoneI, RopStage.stage3, PlusStatus.plus)),
        treatment: quiet,
        fullVascularisationDocumented: true,
      );
      expect(t.result, TerminationResult.continueSurveillance);
    });
  });

  group('Every recommendation explains itself (spec §55)', () {
    test('no result carries an empty reason', () {
      final samples = [
        _assess(_e(RopZone.zoneI, RopStage.stage3, PlusStatus.plus)),
        _assess(_e(RopZone.zoneII, RopStage.stage1, PlusStatus.none)),
        _assess(const EyeFindings()),
        _assess(const EyeFindings(stage: RopStage.stage5)),
      ];
      for (final a in samples) {
        final f = recommendFollowUp(assessment: a, examDate: _exam);
        expect(f.reason.trim(), isNotEmpty);
      }
    });
  });
}
