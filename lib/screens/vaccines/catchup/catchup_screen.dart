// =============================================================================
// catchup/catchup_screen.dart — UI for the catch-up immunization engine.
//
// A thin layer over CatchupEngine: collect the child's DOB + vaccination
// history, then render the recommendation buckets (Today / Not-yet-due /
// Missed-but-eligible / Not-eligible / Complete / Special) with the "why".
// Rendered inside VaccineScreen when the "Catch-up" tab is selected.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'catchup_engine.dart';
import 'vaccine_rules.dart';

class CatchupView extends StatefulWidget {
  final Color accent;
  const CatchupView({super.key, required this.accent});

  @override
  State<CatchupView> createState() => _CatchupViewState();
}

class _CatchupViewState extends State<CatchupView> {
  static final _engine = CatchupEngine(kCatchupRules);
  static final _df = DateFormat('d MMM yyyy');

  DateTime? _dob;
  bool _highRisk = false;
  bool _historyOpen = false;

  // vaccineId → doses received; and the date of the most recent dose.
  final Map<String, int> _count = {};
  final Map<String, DateTime?> _lastDate = {};

  static const _green = Color(0xFF2E7D32);
  static const _amber = Color(0xFFEF6C00);
  static const _red = Color(0xFFC62828);
  static const _purple = Color(0xFF6A1B9A);

  DateTime get _today => DateTime.now();

  Map<String, List<GivenDose>> get _history {
    final h = <String, List<GivenDose>>{};
    for (final r in kCatchupRules) {
      final c = _count[r.id] ?? 0;
      if (c == 0) continue;
      final d = _lastDate[r.id];
      h[r.id] = List.generate(c, (i) => GivenDose(i == c - 1 ? d : null));
    }
    return h;
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? now,
      firstDate: DateTime(now.year - 19),
      lastDate: now,
      helpText: 'Date of birth',
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _pickLastDate(String id) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _lastDate[id] ?? DateTime.now(),
      firstDate: _dob ?? DateTime(DateTime.now().year - 19),
      lastDate: DateTime.now(),
      helpText: 'Date of most recent dose',
    );
    if (picked != null) setState(() => _lastDate[id] = picked);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final result = _dob == null
        ? null
        : _engine.evaluate(
            dob: _dob!, today: _today, history: _history, highRisk: _highRisk);

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 32),
      children: [
        _childCard(cs, result),
        const SizedBox(height: 12),
        _historyCard(cs),
        const SizedBox(height: 12),
        if (result != null) ..._results(result, cs),
        const SizedBox(height: 16),
        _disclaimer(cs),
      ],
    );
  }

  // ── Child details ──────────────────────────────────────────────────────────
  Widget _childCard(ColorScheme cs, CatchupResult? r) {
    return _panel(
      cs,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Child details',
            style: TextStyle(fontWeight: FontWeight.bold, color: cs.onSurface)),
        const SizedBox(height: 10),
        InkWell(
          onTap: _pickDob,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: cs.outlineVariant),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(children: [
              Icon(Icons.cake_outlined, size: 18, color: widget.accent),
              const SizedBox(width: 10),
              Text(
                _dob == null ? 'Select date of birth' : _df.format(_dob!),
                style: TextStyle(
                    color: _dob == null ? cs.onSurfaceVariant : cs.onSurface,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Icon(Icons.edit_calendar_outlined,
                  size: 18, color: cs.onSurfaceVariant),
            ]),
          ),
        ),
        if (r != null) ...[
          const SizedBox(height: 10),
          Row(children: [
            _chip('Age: ${r.age.label}', widget.accent),
            const SizedBox(width: 8),
            _chip(
              _statusText(r),
              r.byStatus(RecStatus.notEligible).isEmpty &&
                      r.byStatus(RecStatus.dueToday).isEmpty &&
                      r.byStatus(RecStatus.missedEligible).isEmpty
                  ? _green
                  : _amber,
            ),
          ]),
        ],
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: [
          _toggleChip('High-risk child', _highRisk,
              (v) => setState(() => _highRisk = v)),
        ]),
        if (_highRisk)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _note(
                'High-risk schedules (asplenia, immunodeficiency, HIV, malignancy, transplant, CSF leak, cochlear implant, chronic organ disease) differ from healthy-child catch-up. Verify against the applicable IAP-ACVIP recommendation.',
                _amber),
          ),
      ]),
    );
  }

  String _statusText(CatchupResult r) {
    final pending = r.recommendations.where((x) =>
        x.status == RecStatus.dueToday ||
        x.status == RecStatus.missedEligible ||
        x.status == RecStatus.notYetDue);
    return pending.isEmpty ? 'Up to date' : 'Incomplete';
  }

  // ── Vaccination history ──────────────────────────────────────────────────────
  Widget _historyCard(ColorScheme cs) {
    final routine = kCatchupRules.where((r) => !r.specialOnly).toList();
    return _panel(
      cs,
      child: Column(children: [
        InkWell(
          onTap: () => setState(() => _historyOpen = !_historyOpen),
          child: Row(children: [
            Icon(Icons.fact_check_outlined, size: 18, color: widget.accent),
            const SizedBox(width: 10),
            Expanded(
              child: Text('Vaccination history',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: cs.onSurface)),
            ),
            Text(_historyOpen ? 'Hide' : 'Enter doses given',
                style: TextStyle(
                    color: widget.accent,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600)),
            Icon(_historyOpen ? Icons.expand_less : Icons.expand_more,
                color: widget.accent),
          ]),
        ),
        if (_historyOpen) ...[
          const SizedBox(height: 4),
          _note(
              'Leave everything at 0 for an unvaccinated child. Enter the date of the most recent dose so intervals and next-dose dates are exact.',
              cs.onSurfaceVariant),
          const SizedBox(height: 8),
          ...routine.map((r) => _historyRow(r, cs)),
        ],
      ]),
    );
  }

  Widget _historyRow(VaccineRule r, ColorScheme cs) {
    final c = _count[r.id] ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text(r.name,
                style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface)),
          ),
          Wrap(spacing: 4, children: List.generate(5, (i) {
            final sel = i == c;
            return GestureDetector(
              onTap: () => setState(() {
                _count[r.id] = i;
                if (i == 0) _lastDate.remove(r.id);
              }),
              child: Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: sel ? widget.accent : widget.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text('$i',
                    style: TextStyle(
                        color: sel ? Colors.white : widget.accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
              ),
            );
          })),
        ]),
        if (c > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: InkWell(
              onTap: () => _pickLastDate(r.id),
              child: Row(children: [
                Icon(Icons.event, size: 14, color: cs.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  _lastDate[r.id] == null
                      ? 'Add date of last dose'
                      : 'Last dose: ${_df.format(_lastDate[r.id]!)}',
                  style: TextStyle(
                      fontSize: 12,
                      color: _lastDate[r.id] == null
                          ? widget.accent
                          : cs.onSurfaceVariant),
                ),
              ]),
            ),
          ),
        Divider(height: 14, color: cs.outlineVariant.withValues(alpha: 0.5)),
      ]),
    );
  }

  // ── Results ──────────────────────────────────────────────────────────────────
  List<Widget> _results(CatchupResult r, ColorScheme cs) {
    final today = [
      ...r.byStatus(RecStatus.dueToday),
      ...r.byStatus(RecStatus.missedEligible),
    ];
    final later = [
      ...r.byStatus(RecStatus.notYetDue),
      ...r.byStatus(RecStatus.needsDate),
    ]..sort((a, b) => (a.earliestDate ?? DateTime(9999))
        .compareTo(b.earliestDate ?? DateTime(9999)));
    final notEligible = r.byStatus(RecStatus.notEligible);
    final complete = r.byStatus(RecStatus.complete);
    final special = r.byStatus(RecStatus.special);

    return [
      _section('Can give today', Icons.vaccines, _green, today,
          empty: 'Nothing is due today for this child.'),
      if (later.isNotEmpty)
        _section('Not yet due', Icons.schedule, _amber, later),
      if (notEligible.isNotEmpty)
        _section('No longer eligible', Icons.block, _red, notEligible),
      if (special.isNotEmpty)
        _section('Special situations', Icons.flag_outlined, _purple, special),
      if (complete.isNotEmpty)
        _section('Completed', Icons.check_circle_outline, cs.onSurfaceVariant,
            complete),
    ];
  }

  Widget _section(String title, IconData icon, Color color,
      List<Recommendation> items,
      {String? empty}) {
    final cs = Theme.of(context).colorScheme;
    if (items.isEmpty && empty == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(title.toUpperCase(),
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.5,
                  letterSpacing: 0.4)),
          const SizedBox(width: 6),
          if (items.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20)),
              child: Text('${items.length}',
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 11)),
            ),
        ]),
        const SizedBox(height: 8),
        if (items.isEmpty)
          Text(empty!,
              style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13))
        else
          ...items.map((it) => _recCard(it, color, cs)),
      ]),
    );
  }

  Widget _recCard(Recommendation r, Color color, ColorScheme cs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text(r.vaccineName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                    color: cs.onSurface)),
          ),
          if (r.isLive)
            Container(
              margin: const EdgeInsets.only(left: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                  color: _purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6)),
              child: const Text('LIVE',
                  style: TextStyle(
                      color: _purple, fontSize: 9, fontWeight: FontWeight.w800)),
            ),
          if (r.dosesRequired > 0)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(r.doseLabel,
                  style: TextStyle(
                      color: color, fontSize: 12, fontWeight: FontWeight.w700)),
            ),
        ]),
        const SizedBox(height: 4),
        Text(r.reason,
            style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant, height: 1.35)),
        if (r.earliestDate != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(children: [
              Icon(Icons.event_available, size: 13, color: color),
              const SizedBox(width: 5),
              Text('Earliest valid date: ${_df.format(r.earliestDate!)}',
                  style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.w700)),
            ]),
          ),
      ]),
    );
  }

  // ── Bits ─────────────────────────────────────────────────────────────────────
  Widget _panel(ColorScheme cs, {required Widget child}) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.6)),
        ),
        child: child,
      );

  Widget _chip(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20)),
        child: Text(text,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w700)),
      );

  Widget _toggleChip(String label, bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: value ? _amber.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: value ? _amber : Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(value ? Icons.check_circle : Icons.circle_outlined,
              size: 15, color: value ? _amber : Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: value ? _amber : Theme.of(context).colorScheme.onSurface)),
        ]),
      ),
    );
  }

  Widget _note(String text, Color color) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(8)),
        child: Text(text,
            style: TextStyle(fontSize: 11.5, color: color, height: 1.35)),
      );

  Widget _disclaimer(ColorScheme cs) => Column(children: [
        Text('Guideline: $kGuidelineVersion ($kGuidelineEffective)',
            style: TextStyle(
                fontSize: 11,
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(
          'Clinical decision-support based on IAP-ACVIP recommendations. Rule values are being validated — verify patient-specific contraindications, product instructions, high-risk conditions and current recommendations before administration.',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 10.5, color: cs.onSurfaceVariant.withValues(alpha: 0.8), height: 1.4),
        ),
      ]);
}
