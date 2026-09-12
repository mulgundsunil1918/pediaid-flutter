// =============================================================================
// test/rabies_tracker_test.dart
//
// Dose dates and the "continue, do not restart" rule (spec case 9).
//
// IAP 2022: "Should a vaccine dose be delayed for any reason, the PEP regimen
// should be resumed/continued (not restarted)."
//
// That is easy to agree with and easy to violate in code. The violation does
// not look like a bug — it looks like a helpful tracker that recomputes due
// dates from today when a dose is late, which has silently restarted the
// course. These tests pin the anchor: every due date is measured from the
// FIRST dose and never moves, no matter what happens afterwards.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/rabies/rabies_protocol.dart';
import 'package:pediaid_app/screens/rabies/rabies_tracker.dart';

final _d0 = DateTime(2026, 9, 12);

void main() {
  group('dates are calculated from the first dose', () {
    test('the IM course lands on the dates the spec names', () {
      final c = buildCourse(schedule: kScheduleImNaiveIap, firstDoseDate: _d0);
      expect(c.visits.map((v) => v.day), [0, 3, 7, 14, 28]);
      expect(c.visits[0].dueDate, DateTime(2026, 9, 12));
      expect(c.visits[1].dueDate, DateTime(2026, 9, 15));
      expect(c.visits[2].dueDate, DateTime(2026, 9, 19));
      expect(c.visits[3].dueDate, DateTime(2026, 9, 26));
      expect(c.visits[4].dueDate, DateTime(2026, 10, 10));
    });

    test('the ID course has four visits and no day 14', () {
      final c = buildCourse(schedule: kScheduleIdNaiveIap, firstDoseDate: _d0);
      expect(c.visits.map((v) => v.day), [0, 3, 7, 28]);
      expect(c.totalCount, 4);
    });

    test('the previously-immunised course is two visits', () {
      final c = buildCourse(schedule: kScheduleImBoostIap, firstDoseDate: _d0);
      expect(c.visits.map((v) => v.day), [0, 3]);
    });

    test('day 0 is recorded as given, not merely scheduled', () {
      // A course cannot have a first-dose date and no first dose.
      final c = buildCourse(schedule: kScheduleImNaiveIap, firstDoseDate: _d0);
      expect(c.visits.first.state, DoseState.given);
      expect(c.visits.first.givenDate, _d0);
      expect(c.givenCount, 1);
    });

    test('month and year boundaries are crossed correctly', () {
      final c = buildCourse(
          schedule: kScheduleImNaiveIap, firstDoseDate: DateTime(2026, 12, 20));
      expect(c.visits.last.dueDate, DateTime(2027, 1, 17));
    });

    test('a leap day is counted, not skipped', () {
      final c = buildCourse(
          schedule: kScheduleImNaiveIap, firstDoseDate: DateTime(2028, 2, 26));
      expect(c.visits[1].dueDate, DateTime(2028, 2, 29));
      expect(c.visits[2].dueDate, DateTime(2028, 3, 4));
    });

    test('the date format is unambiguous', () {
      expect(formatDoseDate(DateTime(2026, 9, 12)), '12 September 2026');
    });
  });

  group('Spec case 9: a delay never restarts the course', () {
    test('a dose given late does NOT move any other due date', () {
      var c = buildCourse(schedule: kScheduleImNaiveIap, firstDoseDate: _d0);
      final before = c.visits.map((v) => v.dueDate).toList();

      // Day 3 given nine days late.
      c = markDose(c, 3,
          state: DoseState.given, givenDate: DateTime(2026, 9, 24));

      expect(c.visits.map((v) => v.dueDate).toList(), before,
          reason: 'recomputing due dates from a late dose IS restarting the '
              'course, however helpful it looks');
      expect(c.visits[4].dueDate, DateTime(2026, 10, 10),
          reason: 'day 28 is still 28 days from the FIRST dose');
    });

    test('overdue visits are marked delayed, and only described', () {
      var c = buildCourse(schedule: kScheduleImNaiveIap, firstDoseDate: _d0);
      c = refreshStates(c, DateTime(2026, 9, 20));

      expect(c.visits[1].state, DoseState.delayed); // day 3
      expect(c.visits[2].state, DoseState.delayed); // day 7
      expect(c.visits[3].state, DoseState.scheduled); // day 14, not yet due

      final advice = delayAdvice(c);
      expect(advice.anyDelayed, isTrue);
      expect(advice.delayedDays, [3, 7]);
      expect(advice.message, contains('Do NOT restart'));
      expect(advice.message, contains('as soon as possible'));
    });

    test('even a very long delay says continue, not restart', () {
      var c = buildCourse(schedule: kScheduleImNaiveIap, firstDoseDate: _d0);
      c = refreshStates(c, DateTime(2027, 3, 1));
      final advice = delayAdvice(c);
      expect(advice.message, contains('Do NOT restart'));
      expect(advice.message, contains('however long the delay'));
    });

    test('an on-time course reports no delay', () {
      var c = buildCourse(schedule: kScheduleImNaiveIap, firstDoseDate: _d0);
      c = refreshStates(c, DateTime(2026, 9, 12));
      expect(delayAdvice(c).anyDelayed, isFalse);
    });

    test('a given dose is never re-flagged as delayed', () {
      var c = buildCourse(schedule: kScheduleImNaiveIap, firstDoseDate: _d0);
      c = markDose(c, 3, state: DoseState.given);
      c = refreshStates(c, DateTime(2026, 10, 1));
      expect(c.visits[1].state, DoseState.given);
      expect(delayAdvice(c).delayedDays, isNot(contains(3)));
    });
  });

  group('course progress', () {
    test('nextDue skips what has been given and what was skipped', () {
      var c = buildCourse(schedule: kScheduleImNaiveIap, firstDoseDate: _d0);
      expect(c.nextDue!.day, 3);

      c = markDose(c, 3, state: DoseState.given);
      expect(c.nextDue!.day, 7);

      c = markDose(c, 7, state: DoseState.skipped);
      expect(c.nextDue!.day, 14);
    });

    test('a finished course reports complete and has no next visit', () {
      var c = buildCourse(schedule: kScheduleImBoostIap, firstDoseDate: _d0);
      c = markDose(c, 3, state: DoseState.given);
      expect(c.isComplete, isTrue);
      expect(c.nextDue, isNull);
      expect(c.givenCount, 2);
    });

    test('sites per visit come from the schedule', () {
      final id = buildCourse(schedule: kScheduleIdNaiveIap, firstDoseDate: _d0);
      final im = buildCourse(schedule: kScheduleImNaiveIap, firstDoseDate: _d0);
      expect(id.visits.every((v) => v.sites == 2), isTrue);
      expect(im.visits.every((v) => v.sites == 1), isTrue);
    });

    test('marking a dose does not disturb the others', () {
      var c = buildCourse(schedule: kScheduleImNaiveIap, firstDoseDate: _d0);
      c = markDose(c, 14, state: DoseState.given);
      expect(c.visits[1].state, DoseState.scheduled);
      expect(c.visits[2].state, DoseState.scheduled);
      expect(c.visits[3].state, DoseState.given);
      expect(c.visits[4].state, DoseState.scheduled);
    });
  });
}
