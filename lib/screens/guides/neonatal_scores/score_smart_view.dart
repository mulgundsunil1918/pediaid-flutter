// =============================================================================
// guides/neonatal_scores/score_smart_view.dart
//
// The interactive half of the neonatal score screens: tap a grade per
// parameter, get a live total and its interpretation.
//
// WHY THIS EXISTS
// ---------------
// The JSON scores render as a wide table — parameter name plus one column per
// grade. Apgar, Downes, Silverman and LATCH come to 550 px and Thompson to
// 680 px, against a 375 px phone. The table did scroll horizontally, but with
// no affordance at all, so the grade-2 column simply was not there as far as
// the user could tell. Reported by Sunil, who could not see score 2 on
// Silverman and Downes.
//
// Scrolling is now signposted in the table view, but the real fix is this:
// pick each row on its own line, and the width problem disappears along with
// the arithmetic.
//
// NOT EVERY SCORE CAN HAVE THIS
// -----------------------------
// Only scores whose grade columns are NUMERIC and additive. Levene, Modified
// Sarnat and IVH grading describe mutually exclusive STAGES — "stage 2" is a
// category, not two points, and summing them would produce a number with no
// meaning that still looked authoritative. [isAdditiveScore] is the guard, and
// staging scores are shown as a table only.
// =============================================================================

import 'package:flutter/material.dart';

/// The key holding the row's name. Usually 'parameter', but Thompson uses
/// 'sign' — hardcoding one name silently excluded Thompson from the
/// interactive view, which is the widest table of the lot and the one that
/// most needed it.
String? labelKeyOf(Map<String, String> row) {
  for (final k in row.keys) {
    if (int.tryParse(k.trim()) == null) return k;
  }
  return null;
}

/// True when the grade columns are whole numbers, so they are points that may
/// legitimately be added rather than stage labels.
bool isAdditiveScore(List<Map<String, String>> parameters) {
  if (parameters.isEmpty) return false;
  final label = labelKeyOf(parameters.first);
  if (label == null) return false;
  final grades =
      parameters.first.keys.where((k) => k != label).toList();
  if (grades.length < 2) return false;
  // Every remaining column must be numeric. One stray text column means this
  // is a descriptive table, not a points table.
  return grades.every((k) => int.tryParse(k.trim()) != null);
}

/// Parses an interpretation band's `score` field — "0", "4-6", "7-10",
/// "≥ 8", "8+" — into an inclusive range. Returns null when it cannot be read,
/// so an unparseable band is skipped rather than silently matching everything.
({int lo, int hi})? parseBandRange(String raw) {
  final s = raw
      .replaceAll('–', '-')
      .replaceAll('—', '-')
      .replaceAll('≥', '>=')
      .replaceAll('≤', '<=')
      .trim();

  final range = RegExp(r'^(\d+)\s*-\s*(\d+)$').firstMatch(s);
  if (range != null) {
    return (lo: int.parse(range.group(1)!), hi: int.parse(range.group(2)!));
  }
  final gte = RegExp(r'^>=\s*(\d+)$').firstMatch(s) ??
      RegExp(r'^(\d+)\s*\+$').firstMatch(s);
  if (gte != null) return (lo: int.parse(gte.group(1)!), hi: 1 << 30);

  final lte = RegExp(r'^<=\s*(\d+)$').firstMatch(s);
  if (lte != null) return (lo: 0, hi: int.parse(lte.group(1)!));

  // Strict inequalities. Downes writes its bands as "<4" and ">6", and
  // without these two the whole score reported no interpretation for eight of
  // its eleven possible totals — it silently fell through to "see the table".
  final gt = RegExp(r'^>\s*(\d+)$').firstMatch(s);
  if (gt != null) return (lo: int.parse(gt.group(1)!) + 1, hi: 1 << 30);

  final lt = RegExp(r'^<\s*(\d+)$').firstMatch(s);
  if (lt != null) return (lo: 0, hi: int.parse(lt.group(1)!) - 1);

  final exact = RegExp(r'^(\d+)$').firstMatch(s);
  if (exact != null) {
    final n = int.parse(exact.group(1)!);
    return (lo: n, hi: n);
  }
  return null;
}

/// The interpretation whose range contains [total], or null.
String? meaningForTotal(List<Map<String, String>> interpretation, int total) {
  for (final row in interpretation) {
    final r = parseBandRange(row['score'] ?? '');
    if (r != null && total >= r.lo && total <= r.hi) {
      return row['meaning'];
    }
  }
  return null;
}

class ScoreSmartView extends StatefulWidget {
  const ScoreSmartView({
    super.key,
    required this.parameters,
    required this.interpretation,
  });

  final List<Map<String, String>> parameters;
  final List<Map<String, String>> interpretation;

  @override
  State<ScoreSmartView> createState() => _ScoreSmartViewState();
}

class _ScoreSmartViewState extends State<ScoreSmartView> {
  /// parameter index -> chosen points. Absent means not yet answered.
  final Map<int, int> _picked = {};

  String get _labelKey => labelKeyOf(widget.parameters.first) ?? 'parameter';

  List<int> get _grades {
    final keys = widget.parameters.first.keys
        .where((k) => k != _labelKey)
        .map((k) => int.parse(k.trim()))
        .toList()
      ..sort();
    return keys;
  }

  int get _total => _picked.values.fold(0, (a, b) => a + b);
  bool get _complete => _picked.length == widget.parameters.length;

  int get _maxTotal {
    final top = _grades.last;
    return top * widget.parameters.length;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final grades = _grades;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < widget.parameters.length; i++) ...[
          _ParameterPicker(
            label: widget.parameters[i][_labelKey] ?? '',
            grades: grades,
            optionLabels: {
              for (final g in grades)
                g: widget.parameters[i]['$g'] ?? widget.parameters[i]['$g '] ?? '',
            },
            selected: _picked[i],
            onPick: (v) => setState(() => _picked[i] = v),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 6),
        _TotalCard(
          total: _total,
          maxTotal: _maxTotal,
          complete: _complete,
          answered: _picked.length,
          outOf: widget.parameters.length,
          meaning: meaningForTotal(widget.interpretation, _total),
          cs: cs,
        ),
        if (_picked.isNotEmpty) ...[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => setState(_picked.clear),
              icon: const Icon(Icons.refresh_rounded, size: 17),
              label: const Text('Clear'),
            ),
          ),
        ],
      ],
    );
  }
}

class _ParameterPicker extends StatelessWidget {
  const _ParameterPicker({
    required this.label,
    required this.grades,
    required this.optionLabels,
    required this.selected,
    required this.onPick,
  });

  final String label;
  final List<int> grades;
  final Map<int, String> optionLabels;
  final int? selected;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final answered = selected != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: answered
              ? cs.primary.withValues(alpha: 0.45)
              : cs.outline.withValues(alpha: 0.25),
          width: answered ? 1.4 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          // One option per line rather than a row of chips: the grade text is
          // full sentences ("Stethoscope only", "Marked, see-saw"), which is
          // exactly what got cut off in the table.
          for (final g in grades) ...[
            _GradeOption(
              points: g,
              text: optionLabels[g] ?? '',
              selected: selected == g,
              onTap: () => onPick(g),
            ),
            if (g != grades.last) const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}

class _GradeOption extends StatelessWidget {
  const _GradeOption({
    required this.points,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final int points;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? cs.primary.withValues(alpha: 0.13)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? cs.primary.withValues(alpha: 0.55)
                : cs.outline.withValues(alpha: 0.22),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? cs.primary
                    : cs.onSurface.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                '$points',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: selected ? cs.onPrimary : cs.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.35,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: cs.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({
    required this.total,
    required this.maxTotal,
    required this.complete,
    required this.answered,
    required this.outOf,
    required this.meaning,
    required this.cs,
  });

  final int total;
  final int maxTotal;
  final bool complete;
  final int answered;
  final int outOf;
  final String? meaning;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final accent = complete ? cs.primary : cs.onSurface.withValues(alpha: 0.5);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: complete ? 0.09 : 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.4), width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$total',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: accent,
                  height: 1,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '/ $maxTotal',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface.withValues(alpha: 0.45),
                ),
              ),
              const Spacer(),
              // A partial total is not a score. Saying so prevents someone
              // reading a half-finished number as the answer.
              if (!complete)
                Text(
                  '$answered of $outOf',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            complete
                ? (meaning ?? 'See the interpretation table below.')
                : 'Select every parameter for the interpretation.',
            style: TextStyle(
              fontSize: 13.5,
              height: 1.4,
              fontWeight: complete ? FontWeight.w600 : FontWeight.normal,
              color: complete
                  ? cs.onSurface
                  : cs.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}
