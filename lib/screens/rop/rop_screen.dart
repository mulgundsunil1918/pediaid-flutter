// =============================================================================
// rop/rop_screen.dart
//
// The ROP module's UI. Quick mode (spec §58) that expands into the full
// examination (spec §59).
//
// The screen holds no clinical logic. Everything it shows comes from
// rop_engine, rop_exam, rop_followup and rop_note — so a rule can be changed
// and re-tested without touching a widget, and a widget can be redesigned
// without risking a threshold. That separation is the point of spec §54's
// auditable-decision-logic requirement.
//
// The provenance banner is not decoration. It names the source document and
// the date its values were transcribed, at the top where it cannot be missed,
// and still says the clinical sign-off spec §73 requires is a separate step
// from that transcription check.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'rop_engine.dart';
import 'rop_exam.dart';
import 'rop_followup.dart';
import 'rop_note.dart';
import 'rop_protocol.dart';

const _accent = Color(0xFF6A1B9A); // purple — unused by other modules

class RopScreen extends StatefulWidget {
  const RopScreen({super.key});

  @override
  State<RopScreen> createState() => _RopScreenState();
}

class _RopScreenState extends State<RopScreen> {
  RopProtocol _protocol = ropProtocolIndia;

  final _gaWeeksCtrl = TextEditingController();
  final _gaDaysCtrl = TextEditingController();
  final _bwCtrl = TextEditingController();
  DateTime? _dob;
  DateTime _assessDate = DateTime.now();

  final Set<String> _risks = {};
  bool _concern = false;

  bool _examMode = false;
  EyeFindings _right = const EyeFindings();
  EyeFindings _left = const EyeFindings();
  TreatmentRecord _treatment = const TreatmentRecord();
  bool _vascularisationComplete = false;

  @override
  void dispose() {
    _gaWeeksCtrl.dispose();
    _gaDaysCtrl.dispose();
    _bwCtrl.dispose();
    super.dispose();
  }

  RopPatient get _patient => RopPatient(
        gaWeeks: int.tryParse(_gaWeeksCtrl.text.trim()),
        gaDays: int.tryParse(_gaDaysCtrl.text.trim()) ?? 0,
        birthWeightG: int.tryParse(_bwCtrl.text.trim()),
        birthDate: _dob,
        assessmentDate: _assessDate,
        riskFactors: _risks.toList(),
        clinicianConcern: _concern,
      );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final screening = evaluateScreening(_patient, _protocol);
    final assessment =
        _examMode ? assessExam(_right, _left, etropRules) : null;
    final followUp = assessment == null
        ? null
        : recommendFollowUp(
            assessment: assessment,
            examDate: _assessDate,
            treatment: _treatment,
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('ROP Screening & Follow-up',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        backgroundColor: _accent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sourceBanner(cs),
            const SizedBox(height: 14),
            _protocolPicker(cs),
            const SizedBox(height: 18),
            _patientInputs(cs),
            const SizedBox(height: 18),
            _riskFactors(cs),
            const SizedBox(height: 20),
            _screeningResult(screening, cs),
            const SizedBox(height: 18),
            _examToggle(cs),
            if (_examMode) ...[
              const SizedBox(height: 18),
              _eyeEditor('Right eye', _right, (f) => setState(() => _right = f), cs),
              const SizedBox(height: 14),
              _eyeEditor('Left eye', _left, (f) => setState(() => _left = f), cs),
              const SizedBox(height: 18),
              _treatmentEditor(cs),
              const SizedBox(height: 20),
              if (assessment != null) _classification(assessment, cs),
              if (followUp != null) ...[
                const SizedBox(height: 16),
                _followUpCard(followUp, cs),
              ],
              const SizedBox(height: 16),
              _terminationCard(assessment!, cs),
              const SizedBox(height: 18),
              _summaryCard(screening, assessment, followUp, cs),
              const SizedBox(height: 16),
              _noteCard(screening, assessment, followUp!, cs),
            ],
            const SizedBox(height: 22),
            _disclaimer(cs),
          ],
        ),
      ),
    );
  }

  // ── Draft / safety ─────────────────────────────────────────────────────────

  /// Shows where this protocol's numbers came from, and when.
  ///
  /// Two different statuses, deliberately distinguished. A protocol with no
  /// `lastVerified` has never been checked against its source and gets a hard
  /// warning. A verified one names the document and date, and still says the
  /// clinical sign-off spec §73 requires is separate from that transcription
  /// check — the values being right is not the same as a clinician having
  /// agreed the module is safe to use.
  Widget _sourceBanner(ColorScheme cs) {
    final draft = _protocol.isDraft;
    final bg = draft ? const Color(0xFFFFF3E0) : const Color(0xFFE8F1FB);
    final line = draft ? const Color(0xFFE9A23B) : const Color(0xFF6E9BC7);
    final ink = draft ? const Color(0xFF6B3E00) : const Color(0xFF23445F);
    final v = _protocol.lastVerified;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(draft ? Icons.warning_amber_rounded : Icons.verified_outlined,
              color: ink, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  draft
                      ? 'DRAFT clinical content — not yet checked against the '
                          'source guideline. Do not use for clinical decisions.'
                      : 'Thresholds and intervals transcribed from the source '
                          'guideline on ${v!.day}/${v.month}/${v.year}. '
                          'Independent clinical review before relying on this '
                          'module is still recommended.',
                  style: TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: ink,
                      fontWeight: FontWeight.w600),
                ),
                if (!draft) ...[
                  const SizedBox(height: 6),
                  for (final r in _protocol.references)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text('• $r',
                          style: TextStyle(
                              fontSize: 11, height: 1.35, color: ink)),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _disclaimer(ColorScheme cs) => Text(
        'Screening, timing and documentation support only. This tool does not '
        'replace examination by a trained ophthalmologist, and the diagnosis '
        'and treatment decision remain with the treating clinician.',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 11.5,
            height: 1.45,
            color: cs.onSurface.withValues(alpha: 0.5)),
      );

  // ── Protocol ───────────────────────────────────────────────────────────────

  Widget _protocolPicker(ColorScheme cs) => _card(
        cs,
        'Screening protocol',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final p in ropProtocols)
              RadioListTile<String>(
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: p.id,
                groupValue: _protocol.id,
                title: Text(p.name, style: const TextStyle(fontSize: 13.5)),
                subtitle: Text(p.organisation,
                    style: TextStyle(
                        fontSize: 11.5,
                        color: cs.onSurface.withValues(alpha: 0.55))),
                onChanged: (v) => setState(() {
                  _protocol = ropProtocolById(v!);
                  // Risk factors belong to a protocol's own list — carrying
                  // them across would mix guidelines, which §3 forbids.
                  _risks.clear();
                }),
              ),
            const SizedBox(height: 6),
            // Spec §50 — the criteria genuinely differ between countries.
            Text(
              '⚠️ Screening criteria and examination timing differ between '
              'countries and guidelines. Criteria are never combined.',
              style: TextStyle(
                  fontSize: 11.5,
                  height: 1.4,
                  color: cs.onSurface.withValues(alpha: 0.6)),
            ),
            if (_protocol.breadthWarning != null) ...[
              const SizedBox(height: 8),
              Text(_protocol.breadthWarning!,
                  style: TextStyle(
                      fontSize: 11.5,
                      height: 1.4,
                      fontStyle: FontStyle.italic,
                      color: cs.onSurface.withValues(alpha: 0.7))),
            ],
          ],
        ),
      );

  // ── Patient ────────────────────────────────────────────────────────────────

  Widget _patientInputs(ColorScheme cs) => _card(
        cs,
        'Infant',
        Column(
          children: [
            Row(
              children: [
                Expanded(child: _num(_gaWeeksCtrl, 'GA weeks', 'e.g. 29')),
                const SizedBox(width: 10),
                Expanded(child: _num(_gaDaysCtrl, 'GA days', '0–6')),
              ],
            ),
            const SizedBox(height: 10),
            _num(_bwCtrl, 'Birth weight', 'grams'),
            const SizedBox(height: 10),
            _dateRow('Date of birth', _dob, (d) => setState(() => _dob = d), cs),
            const SizedBox(height: 10),
            _dateRow('Assessment date', _assessDate,
                (d) => setState(() => _assessDate = d), cs),
          ],
        ),
      );

  Widget _num(TextEditingController c, String label, String hint) => TextField(
        controller: c,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          isDense: true,
          border: const OutlineInputBorder(),
        ),
      );

  Widget _dateRow(
    String label,
    DateTime? value,
    ValueChanged<DateTime> onPick,
    ColorScheme cs,
  ) =>
      InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () async {
          final now = DateTime.now();
          final d = await showDatePicker(
            context: context,
            initialDate: value ?? now,
            firstDate: DateTime(now.year - 2),
            lastDate: DateTime(now.year + 1),
          );
          if (d != null) onPick(d);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: cs.outline.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 17, color: _accent),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(label, style: const TextStyle(fontSize: 13.5))),
              Text(
                value == null
                    ? 'Select'
                    : '${value.day.toString().padLeft(2, '0')}/'
                        '${value.month.toString().padLeft(2, '0')}/${value.year}',
                style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: value == null ? FontWeight.normal : FontWeight.w700,
                    color: value == null
                        ? cs.onSurface.withValues(alpha: 0.45)
                        : _accent),
              ),
            ],
          ),
        ),
      );

  Widget _riskFactors(ColorScheme cs) {
    if (_protocol.riskFactors.isEmpty) return const SizedBox.shrink();
    return _card(
      cs,
      'Risk factors',
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final f in _protocol.riskFactors)
                FilterChip(
                  label: Text(f, style: const TextStyle(fontSize: 12)),
                  selected: _risks.contains(f),
                  onSelected: (v) => setState(
                      () => v ? _risks.add(f) : _risks.remove(f)),
                ),
            ],
          ),
          const SizedBox(height: 6),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _concern,
            onChanged: (v) => setState(() => _concern = v ?? false),
            title: const Text(
              'Clinician considers this infant high risk',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // ── Screening result ───────────────────────────────────────────────────────

  Widget _screeningResult(ScreeningResult r, ColorScheme cs) {
    final (Color colour, String title) = switch (r.status) {
      ScreeningStatus.overdue => (const Color(0xFFB71C1C), '🔴 ROP examination OVERDUE'),
      ScreeningStatus.dueNow => (const Color(0xFFB71C1C), '🔴 ROP examination due now'),
      ScreeningStatus.indicated => (const Color(0xFFEF6C00), 'ROP screening indicated'),
      ScreeningStatus.notIndicated =>
        (const Color(0xFF2E7D32), 'Screening not routinely indicated'),
      ScreeningStatus.insufficientData =>
        (const Color(0xFF616161), '⚠️ Cannot determine — information missing'),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colour.withValues(alpha: 0.5), width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w800, color: colour)),
          if (r.pma != null) ...[
            const SizedBox(height: 8),
            Text('PMA ${r.pma} weeks · day ${r.postnatalDays} of life',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
          // Spec §8 — never just "Eligible".
          if (r.reasons.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text('Reason', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            for (final reason in r.reasons)
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text('• $reason', style: const TextStyle(fontSize: 12.5, height: 1.35)),
              ),
          ],
          if (r.missing.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text(
              'This is NOT a negative result — the following are needed:',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 3),
            for (final m in r.missing)
              Text('• $m', style: const TextStyle(fontSize: 12.5)),
          ],
          if (r.windowFromDay != null) ...[
            const SizedBox(height: 10),
            Text(
              r.windowFromDay == r.windowToDay
                  ? 'First examination target: day ${r.windowFromDay} of life'
                  : 'First examination window: day ${r.windowFromDay}–${r.windowToDay} of life',
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
            if (r.timingRule != null)
              Text('Rule: ${r.timingRule}',
                  style: TextStyle(
                      fontSize: 11.5,
                      color: cs.onSurface.withValues(alpha: 0.6))),
            if (r.daysUntilDue != null && r.status == ScreeningStatus.indicated)
              Text('Due in ${r.daysUntilDue} days',
                  style: const TextStyle(fontSize: 12.5)),
            if (r.status == ScreeningStatus.overdue)
              Text('Overdue by ${-(r.daysUntilDue ?? 0) - (r.windowToDay! - r.windowFromDay!)} days',
                  style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: colour)),
          ],
          if (r.earlyPathway) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFB71C1C).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Early-screening pathway\n${_protocol.earlyPathwayNote ?? ''}',
                style: const TextStyle(fontSize: 12, height: 1.4, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _examToggle(ColorScheme cs) => FilledButton.icon(
        style: FilledButton.styleFrom(backgroundColor: _accent),
        onPressed: () => setState(() => _examMode = !_examMode),
        icon: Icon(_examMode ? Icons.expand_less : Icons.remove_red_eye_outlined),
        label: Text(_examMode ? 'Hide examination' : 'Full examination'),
      );

  // ── Examination ────────────────────────────────────────────────────────────

  Widget _eyeEditor(
    String title,
    EyeFindings f,
    ValueChanged<EyeFindings> onChange,
    ColorScheme cs,
  ) =>
      _card(
        cs,
        title,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _enumRow<RopZone>('Zone', RopZone.values, f.zone,
                (v) => v.label, (v) => onChange(_copy(f, zone: v))),
            const SizedBox(height: 10),
            _enumRow<RopStage>('Stage', RopStage.values, f.stage,
                (v) => v.label, (v) => onChange(_copy(f, stage: v))),
            const SizedBox(height: 10),
            _enumRow<PlusStatus>('Plus', PlusStatus.values, f.plus,
                (v) => v.label, (v) => onChange(_copy(f, plus: v))),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: f.aggressive,
                    onChanged: (v) =>
                        onChange(_copy(f, aggressive: v ?? false)),
                    title: const Text('Aggressive ROP',
                        style: TextStyle(fontSize: 12.5)),
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: f.notch,
                    onChanged: (v) => onChange(_copy(f, notch: v ?? false)),
                    title: const Text('Notch', style: TextStyle(fontSize: 12.5)),
                  ),
                ),
              ],
            ),
            Text(f.describe(),
                style: TextStyle(
                    fontSize: 12.5,
                    fontStyle: FontStyle.italic,
                    color: cs.onSurface.withValues(alpha: 0.7))),
          ],
        ),
      );

  EyeFindings _copy(
    EyeFindings f, {
    RopZone? zone,
    RopStage? stage,
    PlusStatus? plus,
    int? clockHours,
    bool? aggressive,
    bool? notch,
  }) =>
      EyeFindings(
        zone: zone ?? f.zone,
        stage: stage ?? f.stage,
        plus: plus ?? f.plus,
        clockHours: clockHours ?? f.clockHours,
        aggressive: aggressive ?? f.aggressive,
        notch: notch ?? f.notch,
      );

  Widget _enumRow<T>(
    String label,
    List<T> values,
    T selected,
    String Function(T) labelOf,
    ValueChanged<T> onPick,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 5),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final v in values)
                ChoiceChip(
                  label: Text(labelOf(v), style: const TextStyle(fontSize: 11.5)),
                  selected: selected == v,
                  onSelected: (_) => onPick(v),
                ),
            ],
          ),
        ],
      );

  Widget _treatmentEditor(ColorScheme cs) => _card(
        cs,
        'Treatment & surveillance',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _enumRow<RopTreatment>(
                'Treatment performed',
                RopTreatment.values,
                _treatment.type,
                (v) => v.label,
                (v) => setState(() => _treatment = _copyTx(type: v))),
            const SizedBox(height: 10),
            _enumRow<Reactivation>(
                'Reactivation',
                Reactivation.values,
                _treatment.reactivation,
                (v) => v.name,
                (v) => setState(() => _treatment = _copyTx(reactivation: v))),
            const SizedBox(height: 10),
            _enumRow<AvascularRetina>(
                'Peripheral avascular retina',
                AvascularRetina.values,
                _treatment.avascular,
                (v) => v.name,
                (v) => setState(() => _treatment = _copyTx(avascular: v))),
            CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: _vascularisationComplete,
              onChanged: (v) =>
                  setState(() => _vascularisationComplete = v ?? false),
              title: const Text('Retinal vascularisation documented complete',
                  style: TextStyle(fontSize: 12.5)),
            ),
          ],
        ),
      );

  TreatmentRecord _copyTx({
    RopTreatment? type,
    Reactivation? reactivation,
    AvascularRetina? avascular,
  }) =>
      TreatmentRecord(
        type: type ?? _treatment.type,
        date: _treatment.date,
        agent: _treatment.agent,
        regression: _treatment.regression,
        reactivation: reactivation ?? _treatment.reactivation,
        avascular: avascular ?? _treatment.avascular,
      );

  // ── Results ────────────────────────────────────────────────────────────────

  Widget _classification(ExamAssessment a, ColorScheme cs) {
    final urgent = a.urgency != RopUrgency.none;
    final colour = urgent
        ? const Color(0xFFB71C1C)
        : a.type == RopType.cannotClassify
            ? const Color(0xFF616161)
            : const Color(0xFF2E7D32);

    final banner = switch (a.urgency) {
      RopUrgency.urgentDetachment => '🔴 URGENT — RETINAL DETACHMENT',
      RopUrgency.urgentAggressive => '🔴 URGENT — AGGRESSIVE ROP',
      RopUrgency.urgentTreatment => '🔴 URGENT',
      RopUrgency.none => switch (a.type) {
          RopType.type2 => 'Type 2 ROP — close observation',
          RopType.cannotClassify => '⚠️ Cannot classify — incomplete examination',
          _ => 'Treatment-level disease not detected',
        },
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colour, width: 1.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(banner,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w800, color: colour)),
          if (urgent) ...[
            const SizedBox(height: 8),
            const Text(
              'Findings may represent treatment-requiring ROP. Prompt '
              'evaluation by an experienced ROP ophthalmologist is required.',
              style: TextStyle(fontSize: 13, height: 1.4, fontWeight: FontWeight.w600),
            ),
          ],
          if (a.reason != null) ...[
            const SizedBox(height: 8),
            Text(a.reason!, style: const TextStyle(fontSize: 12.5, height: 1.35)),
          ],
          const SizedBox(height: 10),
          Text('Right eye: ${a.right.findings.describe()}',
              style: const TextStyle(fontSize: 12.5)),
          Text('Left eye: ${a.left.findings.describe()}',
              style: const TextStyle(fontSize: 12.5)),
          const SizedBox(height: 6),
          Text('Most severe eye: ${a.worst.eye} — ${a.worst.reason}',
              style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface.withValues(alpha: 0.75))),
        ],
      ),
    );
  }

  Widget _followUpCard(FollowUpResult f, ColorScheme cs) => _card(
        cs,
        'Follow-up',
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(f.interval.label,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            const SizedBox(height: 5),
            Text(f.reason, style: const TextStyle(fontSize: 12.5, height: 1.35)),
            if (f.nextExamDate != null) ...[
              const SizedBox(height: 6),
              Text(
                'Next examination: '
                '${f.nextExamDate!.day}/${f.nextExamDate!.month}/${f.nextExamDate!.year}'
                '  ·  ${f.days} days',
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
            ] else if (f.interval.maxDays != null) ...[
              const SizedBox(height: 6),
              Text('Next examination: within ${f.interval.maxDays} days',
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
            ],
          ],
        ),
      );

  Widget _terminationCard(ExamAssessment a, ColorScheme cs) {
    final t = assessTermination(
      assessment: a,
      treatment: _treatment,
      fullVascularisationDocumented: _vascularisationComplete,
    );
    return _card(
      cs,
      'Can ROP screening be stopped?',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            switch (t.result) {
              TerminationResult.canTerminate =>
                'Screening can be terminated according to protocol',
              TerminationResult.continueSurveillance => 'Continue ROP surveillance',
              TerminationResult.specialistDecision => 'Specialist decision required',
              TerminationResult.insufficientInformation => 'Insufficient information',
            },
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 5),
          Text(t.reason, style: const TextStyle(fontSize: 12.5, height: 1.35)),
        ],
      ),
    );
  }

  Widget _summaryCard(ScreeningResult s, ExamAssessment a, FollowUpResult? f,
          ColorScheme cs) =>
      _card(
        cs,
        'ROP summary',
        Column(
          children: [
            for (final (label, value) in buildSummary(
              protocol: _protocol,
              patient: _patient,
              screening: s,
              assessment: a,
              followUp: f,
            ))
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(label,
                          style: TextStyle(
                              fontSize: 12,
                              color: cs.onSurface.withValues(alpha: 0.6))),
                    ),
                    Expanded(
                      child: Text(value,
                          style: const TextStyle(
                              fontSize: 12.5, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );

  Widget _noteCard(ScreeningResult s, ExamAssessment a, FollowUpResult f,
      ColorScheme cs) {
    final note = buildExamNote(
      examDate: _assessDate,
      pma: s.pma,
      right: _right,
      left: _left,
      assessment: a,
      followUp: f,
      treatment: _treatment,
    );
    return _card(
      cs,
      'Clinical note',
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SelectableText(note,
              style: const TextStyle(fontSize: 12.5, height: 1.45)),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: note));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Clinical note copied')),
              );
            },
            icon: const Icon(Icons.copy_rounded, size: 17),
            label: const Text('Copy clinical note'),
          ),
        ],
      ),
    );
  }

  Widget _card(ColorScheme cs, String title, Widget child) => Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outline.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title.toUpperCase(),
                style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w800,
                    color: _accent)),
            const SizedBox(height: 10),
            child,
          ],
        ),
      );
}
