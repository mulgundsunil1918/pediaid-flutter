// =============================================================================
// rop/rop_note.dart
//
// The clinical note (spec §41) and the summary block (spec §49).
//
// "Do not invent findings" is the whole rule here. Anything not recorded is
// either omitted or named as not recorded — never softened into a normal
// finding, and never padded to make the note read better. A note that says
// "no plus disease" when plus was never assessed is a false entry in the
// record, which is worse than a short note.
// =============================================================================

import 'rop_engine.dart';
import 'rop_exam.dart';
import 'rop_followup.dart';
import 'rop_protocol.dart';

String _d(DateTime d) {
  const m = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${d.day} ${m[d.month - 1]} ${d.year}';
}

/// Spec §41 — a concise note built only from what was recorded.
String buildExamNote({
  required DateTime examDate,
  required Pma? pma,
  required EyeFindings right,
  required EyeFindings left,
  required ExamAssessment assessment,
  required FollowUpResult followUp,
  TreatmentRecord treatment = const TreatmentRecord(),
}) {
  final parts = <String>[];

  parts.add(
    'ROP examination performed on ${_d(examDate)}'
    '${pma != null ? ' at PMA $pma weeks' : ''}.',
  );

  // Both eyes described identically get one sentence, as spec §26 shows.
  if (right.hasAnyFinding &&
      left.hasAnyFinding &&
      right.describe() == left.describe()) {
    parts.add('Both eyes: ${right.describe()}');
  } else {
    parts.add('Right eye: ${right.describe()}');
    parts.add('Left eye: ${left.describe()}');
  }

  // Only stated when it was actually assessed in at least one eye. Silence is
  // not the same as "absent".
  if (right.isComplete || left.isComplete) {
    if (!right.aggressive && !left.aggressive) {
      parts.add('No aggressive ROP.');
    }
  }

  if (treatment.wasTreated) {
    parts.add(
      '${treatment.type.label}'
      '${treatment.date != null ? ' on ${_d(treatment.date!)}' : ''}.',
    );
    if (treatment.regression != Regression.unknown) {
      parts.add('Regression: ${treatment.regression.name}.');
    }
    if (treatment.reactivation != Reactivation.no) {
      parts.add('Reactivation ${treatment.reactivation.name}.');
    }
  }

  if (assessment.type == RopType.type1) {
    parts.add('Treatment-level disease: ${assessment.reason}.');
  } else if (assessment.type == RopType.cannotClassify) {
    parts.add('Classification incomplete: ${assessment.reason}.');
  }

  parts.add('Follow-up recommended: ${followUp.interval.label}.');
  if (followUp.nextExamDate != null) {
    parts.add('Next examination ${_d(followUp.nextExamDate!)}.');
  }

  return parts.join(' ');
}

/// One row of the summary block.
typedef SummaryRow = (String label, String value);

/// Spec §49 — the summary shown above the result.
List<SummaryRow> buildSummary({
  required RopProtocol protocol,
  required RopPatient patient,
  required ScreeningResult screening,
  ExamAssessment? assessment,
  FollowUpResult? followUp,
}) {
  final rows = <SummaryRow>[
    ('Screening protocol', protocol.name),
    (
      'GA at birth',
      patient.gaWeeks == null
          ? 'Not recorded'
          : '${patient.gaWeeks}+${patient.gaDays ?? 0} weeks'
    ),
    (
      'Birth weight',
      patient.birthWeightG == null ? 'Not recorded' : '${patient.birthWeightG} g'
    ),
    (
      'Postnatal age',
      screening.postnatalDays == null
          ? 'Not recorded'
          : '${screening.postnatalDays} days'
    ),
    (
      'Current PMA',
      screening.pma == null ? 'Not available' : '${screening.pma} weeks'
    ),
    ('Screening', switch (screening.status) {
      ScreeningStatus.indicated => 'Indicated',
      ScreeningStatus.dueNow => 'Indicated — due now',
      ScreeningStatus.overdue => 'Indicated — OVERDUE',
      ScreeningStatus.notIndicated => 'Not routinely indicated',
      ScreeningStatus.insufficientData => 'Cannot determine',
    }),
  ];

  if (assessment != null) {
    final worst = assessment.worst.eye == 'Left'
        ? assessment.left.findings
        : assessment.right.findings;
    rows.add(('ROP status', worst.describe()));
    rows.add((
      'Treatment-level disease',
      switch (assessment.type) {
        RopType.type1 => 'YES — ${assessment.reason}',
        RopType.type2 => 'No — Type 2, close observation',
        RopType.neither => 'No',
        RopType.cannotClassify => 'Cannot determine — incomplete examination',
      }
    ));
  }

  if (followUp != null) {
    rows.add(('Next examination', followUp.interval.label));
    if (followUp.nextExamDate != null) {
      rows.add(('Next due date', _d(followUp.nextExamDate!)));
    }
  }

  return rows;
}
