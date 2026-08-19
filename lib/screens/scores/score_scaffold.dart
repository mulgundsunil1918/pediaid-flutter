// =============================================================================
// scores/score_scaffold.dart
//
// Shared engine for criteria/point scores (PEWS, Croup, Kawasaki, DSM-5,
// Rome-IV, PECARN, …). Each score is a compact ScoreDef: a list of questions
// (each a set of scored choices), interpretation bands keyed on the total, and
// source notes. The scaffold renders the questions, sums live, and shows the
// total with its interpretation. One data model covers graded scales, yes/no
// checklists and diagnostic-criteria counts alike.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/tool_registry.dart';

import 'adaptive_color.dart';

class ScoreChoice {
  final String label;
  final int value;
  const ScoreChoice(this.label, this.value);
}

class ScoreQ {
  final String q;
  final List<ScoreChoice> choices;

  /// True only for a present/absent criterion, which renders as a switch.
  /// Everything else renders its option LABELS as chips — inferring "binary"
  /// from `choices.length == 2` hid real option text (e.g. Westley croup's
  /// "Normal (including asleep)" vs "Disoriented"), leaving an unlabelled
  /// toggle the user could not interpret.
  final bool isCriterion;

  const ScoreQ(this.q, this.choices) : isCriterion = false;
  const ScoreQ._criterion(this.q, this.choices) : isCriterion = true;

  /// A simple criterion worth [pts] when met (rendered as a switch).
  factory ScoreQ.yesNo(String q, {int pts = 1}) =>
      ScoreQ._criterion(q, [const ScoreChoice('No', 0), ScoreChoice('Yes', pts)]);
}

class ScoreBand {
  final int min; // inclusive lower bound on the total
  final String label;
  final Color color;
  final String advice;
  const ScoreBand(this.min, this.label, this.color, this.advice);
}

class ScoreDef {
  final String title;
  final String subtitle;
  final String system;
  final Color accent;
  final List<ScoreQ> questions;

  /// Bands sorted low→high; the matching band is the highest whose [min] ≤ total.
  final List<ScoreBand> bands;
  final List<String> notes;

  /// Suffix on the total, e.g. "criteria met" for checklists.
  final String totalLabel;

  const ScoreDef({
    required this.title,
    required this.subtitle,
    required this.system,
    required this.accent,
    required this.questions,
    required this.bands,
    this.notes = const [],
    this.totalLabel = 'points',
  });

  int get maxScore => questions.fold(
      0,
      (a, q) =>
          a + q.choices.map((c) => c.value).fold(0, (m, v) => v > m ? v : m));
}

// Semantic band colours reused across scores.
const scGreen = Color(0xFF2E7D32);
const scAmber = Color(0xFFF9A825);
const scOrange = Color(0xFFEF6C00);
const scRed = Color(0xFFB71C1C);

class ScoreScaffold extends StatefulWidget {
  final ScoreDef def;
  const ScoreScaffold({super.key, required this.def});

  @override
  State<ScoreScaffold> createState() => _ScoreScaffoldState();
}

class _ScoreScaffoldState extends State<ScoreScaffold> {
  // NOT `late final`: when this widget is rebuilt in the same tree position
  // with a DIFFERENT score (its question count differs), a fixed-once list
  // keeps the old length and indexing throws a RangeError. Re-created in
  // didUpdateWidget so the answers always match the current definition.
  late List<int?> _sel;

  @override
  void initState() {
    super.initState();
    _sel = List<int?>.filled(widget.def.questions.length, null);
    // Recents should name the score the doctor opened, not the hub it sits in.
    ToolRegistry.instance
        .recordVisit(widget.def.title, kind: ToolKind.score);
  }

  @override
  void didUpdateWidget(covariant ScoreScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.def, widget.def) ||
        oldWidget.def.questions.length != widget.def.questions.length) {
      _sel = List<int?>.filled(widget.def.questions.length, null);
    }
  }

  int get _total =>
      _sel.fold(0, (a, v) => a + (v ?? 0));
  int get _answered => _sel.where((v) => v != null).length;

  ScoreBand? get _band {
    ScoreBand? match;
    for (final b in widget.def.bands) {
      if (_total >= b.min) match = b;
    }
    return match;
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.def;
    final cs = Theme.of(context).colorScheme;
    final band = _band;
    final allAnswered = _answered == d.questions.length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(d.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        backgroundColor: d.accent,
        foregroundColor: Colors.white,
        actions: [
          // Scoring the next patient used to mean backing out to the hub and
          // re-opening the score; on a ward round that is one round trip per
          // baby.
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset',
            onPressed: _answered == 0
                ? null
                : () {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      _sel = List<int?>.filled(d.questions.length, null);
                    });
                  },
          ),
        ],
      ),
      bottomNavigationBar: _stickyTotal(band, allAnswered, cs),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(d.subtitle,
                style: TextStyle(
                    fontSize: 13, color: cs.onSurface.withValues(alpha: 0.6))),
            const SizedBox(height: 16),
            for (var i = 0; i < d.questions.length; i++) ...[
              _question(d.questions[i], i, cs),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 4),
            _resultCard(band, allAnswered, cs),
            if (d.notes.isNotEmpty) ...[
              const SizedBox(height: 16),
              _notes(cs),
            ],
            const SizedBox(height: 12),
            Text(
              'Decision support only — apply clinical judgement and local protocol.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11, color: cs.onSurface.withValues(alpha: 0.45)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _question(ScoreQ q, int i, ColorScheme cs) {
    // EVERY question renders as labelled buttons showing their point value.
    // A bare switch told the user neither what the two states meant nor what
    // they scored — e.g. Westley croup's "Level of consciousness" toggle gave
    // no hint that it meant Normal vs Disoriented (+5).
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: _sel[i] != null
                ? adaptInk(context, widget.def.accent).withValues(alpha: 0.45)
                : cs.outline.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(q.q,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in q.choices)
                _chip(_choiceLabel(c), _sel[i] == c.value, () {
                  // A score is tapped through while looking at the patient,
                  // not the phone — the tick confirms the tap landed.
                  HapticFeedback.selectionClick();
                  setState(() => _sel[i] = c.value);
                }),
            ],
          ),
        ],
      ),
    );
  }

  /// Appends the weight so the user can see what each option scores.
  String _choiceLabel(ScoreChoice c) =>
      c.value == 0 ? c.label : '${c.label}  +${c.value}';

  Widget _chip(String label, bool active, VoidCallback onTap) {
    // Accent as TEXT needs the dark-mode lift; as a solid fill it keeps the
    // brand hue with white on top.
    final inkAccent = adaptInk(context, widget.def.accent);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? widget.def.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
              color: active
                  ? widget.def.accent
                  : inkAccent.withValues(alpha: 0.45)),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : inkAccent)),
      ),
    );
  }

  /// Running total pinned to the bottom of the screen.
  ///
  /// The full result card sits BELOW every question, so on a twelve-question
  /// score you answer blind and scroll to the end to see the number — and
  /// after changing one answer near the top you scroll down again to see what
  /// it did. This keeps the number in view while you tap; the card below still
  /// carries the band advice.
  Widget _stickyTotal(ScoreBand? band, bool allAnswered, ColorScheme cs) {
    final started = _answered > 0;
    final color = adaptInk(context, band?.color ?? cs.outline);
    final d = widget.def;

    return SafeArea(
      top: false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: started
              ? color.withValues(alpha: 0.10)
              : Theme.of(context).cardColor,
          border: Border(
            top: BorderSide(
              color: started
                  ? color.withValues(alpha: 0.40)
                  : cs.outline.withValues(alpha: 0.25),
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              started ? '$_total' : '—',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: started ? color : cs.onSurface.withValues(alpha: 0.35),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    started && band != null ? band.label : d.totalLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: started
                          ? color
                          : cs.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                  Text(
                    allAnswered
                        ? 'All ${d.questions.length} answered'
                        : '$_answered of ${d.questions.length} answered',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: cs.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultCard(ScoreBand? band, bool allAnswered, ColorScheme cs) {
    final color = adaptInk(context, band?.color ?? cs.outline);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wrap (not Row): the band label drops to its own line on a narrow
          // phone rather than overflowing next to the total.
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              // Each piece is its own Wrap child so a long totalLabel
              // ("principal features") can flow to the next line on a phone
              // instead of overflowing a fixed Row.
              Text('$_total',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: color)),
              Text('/ ${widget.def.maxScore}  ${widget.def.totalLabel}',
                  style: TextStyle(
                      fontSize: 13,
                      color: cs.onSurface.withValues(alpha: 0.55))),
              if (band != null)
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 80),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(band.label,
                        style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: color)),
                  ),
                ),
            ],
          ),
          if (band != null && band.advice.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(band.advice,
                style: TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: cs.onSurface.withValues(alpha: 0.85))),
          ],
          if (!allAnswered) ...[
            const SizedBox(height: 8),
            Text('$_answered of ${widget.def.questions.length} answered',
                style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: cs.onSurface.withValues(alpha: 0.5))),
          ],
        ],
      ),
    );
  }

  Widget _notes(ColorScheme cs) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final n in widget.def.notes)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(n,
                    style: TextStyle(
                        fontSize: 12.5,
                        height: 1.45,
                        color: cs.onSurface.withValues(alpha: 0.75))),
              ),
          ],
        ),
      );
}
