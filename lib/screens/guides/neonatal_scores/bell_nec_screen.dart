// =============================================================================
// screens/guides/neonatal_scores/bell_nec_screen.dart
//
// Modified Bell's staging for NEC — table view and a tappable staging view.
//
// It has its own screen rather than joining the JSON-driven scores because it
// is not a score. The shared smart view adds numeric columns and reports a
// total out of a maximum; Bell's has no points to add and no maximum, so that
// view would produce a confident, meaningless number. Same toggle, same shape,
// different arithmetic — none.
// =============================================================================

import 'package:flutter/material.dart';

import 'bell_nec_staging.dart';

class BellNecScreen extends StatefulWidget {
  const BellNecScreen({super.key});

  @override
  State<BellNecScreen> createState() => _BellNecScreenState();
}

class _BellNecScreenState extends State<BellNecScreen> {
  bool _tableView = false;
  final Set<String> _selected = {};

  Color _stageColor(BellStage s) => switch (s) {
        BellStage.ia || BellStage.ib => const Color(0xFF1565C0),
        BellStage.iia || BellStage.iib => const Color(0xFFB26A00),
        BellStage.iiia || BellStage.iiib => const Color(0xFFC62828),
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final result = stageNec(_selected);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Modified Bell's Staging",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Necrotising enterocolitis',
                  style: TextStyle(
                      fontSize: 13,
                      color: cs.onSurface.withValues(alpha: 0.7))),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(_tableView ? 'Criteria' : 'Findings present',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface)),
                  ),
                  SegmentedButton<bool>(
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    segments: const [
                      ButtonSegment(
                        value: false,
                        icon: Icon(Icons.touch_app_outlined, size: 16),
                        label: Text('Stage'),
                      ),
                      ButtonSegment(
                        value: true,
                        icon: Icon(Icons.table_chart_outlined, size: 16),
                        label: Text('Table'),
                      ),
                    ],
                    selected: {_tableView},
                    showSelectedIcon: false,
                    onSelectionChanged: (v) =>
                        setState(() => _tableView = v.first),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_tableView) _table(cs) else _picker(cs, result),
              const SizedBox(height: 20),
              _referenceCard(cs),
            ],
          ),
        ),
      ),
    );
  }

  // ── Stage (tappable) view ──────────────────────────────────────────────
  Widget _picker(ColorScheme cs, BellResult result) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _resultCard(cs, result),
          const SizedBox(height: 18),
          for (final system in BellSystem.values) ...[
            Text(system.label.toUpperCase(),
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: cs.onSurface.withValues(alpha: 0.55))),
            const SizedBox(height: 8),
            for (final f in kBellFindings.where((f) => f.system == system))
              _findingTile(cs, f),
            const SizedBox(height: 16),
          ],
          if (_selected.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => setState(_selected.clear),
                icon: const Icon(Icons.refresh_rounded, size: 17),
                label: const Text('Clear'),
              ),
            ),
        ],
      );

  Widget _findingTile(ColorScheme cs, BellFinding f) {
    final on = _selected.contains(f.id);
    final c = _stageColor(f.stage);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        selected: on,
        button: true,
        label: '${f.label}. Stage ${f.stage.code}.',
        child: InkWell(
          onTap: () => setState(() {
            on ? _selected.remove(f.id) : _selected.add(f.id);
          }),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            constraints: const BoxConstraints(minHeight: 46),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: on ? c.withValues(alpha: 0.11) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: on ? c : cs.outlineVariant.withValues(alpha: 0.8),
                width: on ? 1.5 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(on ? Icons.check_circle : Icons.circle_outlined,
                    size: 17,
                    color: on ? c : cs.onSurface.withValues(alpha: 0.35)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(f.label,
                      style: TextStyle(
                          fontSize: 13,
                          height: 1.35,
                          fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                          color: on
                              ? c
                              : cs.onSurface.withValues(alpha: 0.88))),
                ),
                const SizedBox(width: 8),
                // The stage each finding belongs to is shown on the tile, so
                // the classification is legible while you use it rather than
                // only in the answer at the top.
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: c.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: c.withValues(alpha: 0.35)),
                  ),
                  child: Text(f.stage.code,
                      style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          color: c)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultCard(ColorScheme cs, BellResult r) {
    final stage = r.stage;
    final c = stage == null ? cs.outline : _stageColor(stage);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.withValues(alpha: 0.55), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (stage == null) ...[
            Row(
              children: [
                Icon(Icons.help_outline, size: 19, color: c),
                const SizedBox(width: 9),
                Expanded(
                  child: Text('No stage established',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: c)),
                ),
              ],
            ),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13, vertical: 7),
                  decoration: BoxDecoration(
                    color: c.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: c, width: 1.6),
                  ),
                  child: Text('STAGE ${stage.code}',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.4,
                          color: c)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(stage.classification,
                        style: TextStyle(
                            fontSize: 13,
                            height: 1.35,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface.withValues(alpha: 0.85))),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _labelled(cs, 'Reached by',
                r.deciding.map((f) => f.label).join(' · ')),
            if (r.supporting.isNotEmpty)
              _labelled(cs, 'Also present',
                  r.supporting.map((f) => f.label).join(' · ')),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TREATMENT',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: c)),
                  const SizedBox(height: 5),
                  Text(stage.treatment,
                      style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          fontWeight: FontWeight.w700,
                          color: c)),
                ],
              ),
            ),
            if (stage.isAdvanced) ...[
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline,
                      size: 17, color: Color(0xFFC62828)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      stage == BellStage.iiib
                          ? 'Perforated bowel. Surgical involvement now.'
                          : 'Severely ill. Surgical review and intensive '
                              'support now.',
                      style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFC62828)),
                    ),
                  ),
                ],
              ),
            ],
          ],
          const SizedBox(height: 10),
          Text(r.message,
              style: TextStyle(
                  fontSize: 11.8,
                  height: 1.45,
                  color: cs.onSurface.withValues(alpha: 0.7))),
        ],
      ),
    );
  }

  Widget _labelled(ColorScheme cs, String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 88,
              child: Text(label,
                  style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface.withValues(alpha: 0.55))),
            ),
            Expanded(
              child: Text(value,
                  style: TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: cs.onSurface.withValues(alpha: 0.88))),
            ),
          ],
        ),
      );

  // ── Table view ─────────────────────────────────────────────────────────
  //
  // One card per stage rather than a five-column grid. The published table is
  // wide, and on a phone a grid of it either scrolls sideways — which is how
  // the grade-2 column on Silverman and Downes used to hide — or shrinks to
  // unreadable. Stacking keeps every word on screen at full size.
  Widget _table(ColorScheme cs) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final row in kBellTable) _tableCard(cs, row),
        ],
      );

  Widget _tableCard(ColorScheme cs, BellRow row) {
    final c = _stageColor(row.stage);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: c.withValues(alpha: 0.45),
            width: row.stage.isAdvanced ? 1.6 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: c.withValues(alpha: 0.13),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Text('STAGE ${row.stage.code}',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.3,
                        color: c)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(row.stage.classification,
                      style: TextStyle(
                          fontSize: 11.5,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface.withValues(alpha: 0.75))),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cell(cs, 'Systemic', row.systemic),
                _cell(cs, 'Abdominal', row.abdominal),
                _cell(cs, 'Radiographic', row.radiographic),
                _cell(cs, 'Treatment', row.stage.treatment, accent: c),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(ColorScheme cs, String label, String value, {Color? accent}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(),
                style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: (accent ?? cs.onSurface).withValues(alpha: 0.6))),
            const SizedBox(height: 3),
            Text(value,
                style: TextStyle(
                    fontSize: 12.5,
                    height: 1.45,
                    fontWeight:
                        accent != null ? FontWeight.w700 : FontWeight.w400,
                    color: accent ?? cs.onSurface.withValues(alpha: 0.88))),
          ],
        ),
      );

  Widget _referenceCard(ColorScheme cs) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('REFERENCE',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: cs.onSurface.withValues(alpha: 0.55))),
            const SizedBox(height: 7),
            Text(kBellReference,
                style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: cs.onSurface.withValues(alpha: 0.8))),
          ],
        ),
      );
}
