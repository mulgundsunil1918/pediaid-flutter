// =============================================================================
// screens/rabies/rabies_tracker.dart — dose dates and course state
//
// Turns "days 0 – 3 – 7 – 14 – 28" into actual calendar dates, and tracks what
// was given.
//
// THE ONE RULE THIS FILE EXISTS TO ENFORCE
// ----------------------------------------
// IAP 2022: "Should a vaccine dose be delayed for any reason, the PEP regimen
// should be resumed/continued (not restarted)."
//
// That sentence is easy to agree with and easy to violate in code. A tracker
// that recomputes every due date from "today" whenever a dose is late has
// silently restarted the course; one that marks a late course "invalid" pushes
// a clinician toward starting again. So due dates are always anchored to the
// FIRST dose and never move, a late dose is described as late and nothing more,
// and no function in this file can shorten, invalidate or restart a course.
// =============================================================================

import 'package:flutter/foundation.dart';

import 'rabies_protocol.dart';

enum DoseState { scheduled, given, delayed, skipped, unknown }

extension DoseStateX on DoseState {
  String get label => switch (this) {
        DoseState.scheduled => 'Scheduled',
        DoseState.given => 'Given',
        DoseState.delayed => 'Delayed',
        DoseState.skipped => 'Skipped',
        DoseState.unknown => 'Not recorded',
      };
}

@immutable
class DoseVisit {
  /// Day number from the schedule: 0, 3, 7, 14, 28.
  final int day;

  /// Date this visit is due. Anchored to the first dose; never recomputed.
  final DateTime dueDate;

  final DoseState state;

  /// Date it was actually given, when it was.
  final DateTime? givenDate;

  /// Sites to inject at this visit, from the schedule.
  final int sites;

  const DoseVisit({
    required this.day,
    required this.dueDate,
    required this.state,
    required this.sites,
    this.givenDate,
  });

  DoseVisit copyWith({DoseState? state, DateTime? givenDate}) => DoseVisit(
        day: day,
        dueDate: dueDate,
        state: state ?? this.state,
        sites: sites,
        givenDate: givenDate ?? this.givenDate,
      );

  String get label => 'Day $day';
}

@immutable
class DoseCourse {
  final VaccineSchedule schedule;
  final DateTime firstDoseDate;
  final List<DoseVisit> visits;

  const DoseCourse({
    required this.schedule,
    required this.firstDoseDate,
    required this.visits,
  });

  int get givenCount => visits.where((v) => v.state == DoseState.given).length;
  int get totalCount => visits.length;
  bool get isComplete => givenCount == totalCount;

  /// The next visit that is not yet given, or null when the course is done.
  DoseVisit? get nextDue {
    for (final v in visits) {
      if (v.state != DoseState.given && v.state != DoseState.skipped) return v;
    }
    return null;
  }
}

/// Builds the course from a schedule and the date of the first dose.
///
/// Every due date is `firstDoseDate + day`. This is the anchor that makes
/// "continue, do not restart" true by construction.
DoseCourse buildCourse({
  required VaccineSchedule schedule,
  required DateTime firstDoseDate,
}) {
  final d0 = DateTime(firstDoseDate.year, firstDoseDate.month, firstDoseDate.day);
  return DoseCourse(
    schedule: schedule,
    firstDoseDate: d0,
    visits: [
      for (final day in schedule.days)
        DoseVisit(
          day: day,
          dueDate: d0.add(Duration(days: day)),
          // Day 0 is the dose that defines the course, so it is given by
          // definition — recording it as merely "scheduled" would let a course
          // exist with a first-dose date and no first dose.
          state: day == 0 ? DoseState.given : DoseState.scheduled,
          givenDate: day == 0 ? d0 : null,
          sites: schedule.sitesPerVisit,
        ),
    ],
  );
}

/// Marks one visit, returning a new course.
///
/// Note what this does NOT do: it does not move any other due date. A dose
/// given late is recorded as given late, and day 28 is still day 28 from the
/// first dose.
DoseCourse markDose(
  DoseCourse course,
  int day, {
  required DoseState state,
  DateTime? givenDate,
}) =>
    DoseCourse(
      schedule: course.schedule,
      firstDoseDate: course.firstDoseDate,
      visits: [
        for (final v in course.visits)
          if (v.day == day)
            v.copyWith(
              state: state,
              givenDate: state == DoseState.given
                  ? (givenDate ?? v.dueDate)
                  : v.givenDate,
            )
          else
            v,
      ],
    );

/// Re-reads each visit against today and flags the overdue ones.
///
/// "Delayed" is descriptive. It carries no instruction to restart, and there
/// is deliberately no function in this file that could.
DoseCourse refreshStates(DoseCourse course, DateTime today) {
  final now = DateTime(today.year, today.month, today.day);
  return DoseCourse(
    schedule: course.schedule,
    firstDoseDate: course.firstDoseDate,
    visits: [
      for (final v in course.visits)
        if (v.state == DoseState.scheduled && v.dueDate.isBefore(now))
          v.copyWith(state: DoseState.delayed)
        else
          v,
    ],
  );
}

@immutable
class DelayAdvice {
  final bool anyDelayed;
  final List<int> delayedDays;
  final String message;
  final GuidelineSource source;
  const DelayAdvice({
    required this.anyDelayed,
    required this.delayedDays,
    required this.message,
    required this.source,
  });
}

/// What to do about missed doses.
///
/// There is exactly one answer, and it is the same however many were missed.
DelayAdvice delayAdvice(DoseCourse course) {
  final late_ = course.visits
      .where((v) => v.state == DoseState.delayed)
      .map((v) => v.day)
      .toList(growable: false);

  if (late_.isEmpty) {
    return const DelayAdvice(
      anyDelayed: false,
      delayedDays: [],
      message: 'The course is on schedule.',
      source: GuidelineSource.iap2022,
    );
  }

  final days = late_.map((d) => 'day $d').join(', ');
  return DelayAdvice(
    anyDelayed: true,
    delayedDays: late_,
    message: 'Overdue: $days. Give the missed dose as soon as possible and '
        'continue the remaining schedule. Do NOT restart the course — the '
        'regimen is resumed or continued, never restarted, however long the '
        'delay.',
    source: GuidelineSource.iap2022,
  );
}

/// "12 September 2026"
String formatDoseDate(DateTime d) {
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  return '${d.day} ${months[d.month - 1]} ${d.year}';
}
