// =============================================================================
// scores/paediatric_scores_hub.dart
//
// The Paediatric Scores hub. Every score registers itself here as a ScoreDef,
// and the hub offers the two orderings Sunil asked for: grouped BY SYSTEM
// (default) or a flat A–Z list, plus a search box.
// =============================================================================

import 'package:flutter/material.dart';

import 'adaptive_color.dart';
import 'score_scaffold.dart';
import 'psychosocial_scores.dart';
import 'infectious_respiratory_scores.dart';
import 'critcare_neuro_cardiac_scores.dart';
import 'gi_liver_scores.dart';
import 'oncology_scores.dart';
import 'rheumatology_scores.dart';
import 'misc_system_scores.dart';
import 'neonatal_scores.dart';

/// Every paediatric score in the app, in registration order.
final List<ScoreDef> allPaediatricScores = [
  ...criticalCareScores,
  ...neuroTraumaScores,
  ...infectiousScores,
  ...respiratoryScores,
  ...cardiacScores,
  ...giLiverScores,
  ...oncologyScores,
  ...rheumatologyScores,
  ...psychosocialScores,
  ...haematologyScores,
  ...endocrineScores,
  ...renalScores,
  ...painScores,
  ...radiologyScores,
  ...sleepScores,
  ...giLiverScores2,
  ...neonatalScores,
];

class PaediatricScoresHub extends StatefulWidget {
  const PaediatricScoresHub({super.key});

  @override
  State<PaediatricScoresHub> createState() => _PaediatricScoresHubState();
}

class _PaediatricScoresHubState extends State<PaediatricScoresHub> {
  bool _azMode = false;
  String _query = '';

  List<ScoreDef> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return allPaediatricScores;
    return allPaediatricScores
        .where((s) =>
            s.title.toLowerCase().contains(q) ||
            s.subtitle.toLowerCase().contains(q) ||
            s.system.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final items = _filtered;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Paediatric Scores',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Search scores…',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: cs.outline.withValues(alpha: 0.3)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Sort toggle — by system (grouped) or A–Z (flat).
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Row(children: [
                _sortBtn('By system', !_azMode, () => setState(() => _azMode = false)),
                const SizedBox(width: 4),
                _sortBtn('A–Z', _azMode, () => setState(() => _azMode = true)),
                const Spacer(),
                Flexible(
                  child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text('${items.length}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withValues(alpha: 0.55))),
                ),
                ),
              ]),
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text('No scores match "$_query"',
                        style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.5))))
                : (_azMode ? _azList(items) : _systemList(items)),
          ),
        ],
      ),
    );
  }

  Widget _sortBtn(String label, bool active, VoidCallback onTap) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: active ? cs.onPrimary : cs.onSurface.withValues(alpha: 0.7))),
      ),
    );
  }

  Widget _azList(List<ScoreDef> items) {
    final sorted = [...items]..sort((a, b) => a.title.compareTo(b.title));
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: sorted.length,
      itemBuilder: (_, i) => _tile(sorted[i], showSystem: true),
    );
  }

  Widget _systemList(List<ScoreDef> items) {
    final groups = <String, List<ScoreDef>>{};
    for (final s in items) {
      groups.putIfAbsent(s.system, () => []).add(s);
    }
    final keys = groups.keys.toList()..sort();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        for (final k in keys) ...[
          _sectionHeader(k, groups[k]!.length),
          for (final s in groups[k]!) _tile(s),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _sectionHeader(String label, int n) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 12, 2, 8),
      child: Row(children: [
        Text(label.toUpperCase(),
            style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: cs.primary)),
        const SizedBox(width: 8),
        Text('$n',
            style: TextStyle(
                fontSize: 11.5, color: cs.onSurface.withValues(alpha: 0.45))),
        const SizedBox(width: 10),
        Expanded(
            child: Divider(color: cs.primary.withValues(alpha: 0.2), height: 1)),
      ]),
    );
  }

  Widget _tile(ScoreDef s, {bool showSystem = false}) {
    final cs = Theme.of(context).colorScheme;
    final ink = adaptInk(context, s.accent);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ScoreScaffold(def: s)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: ink.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.fact_check_outlined, color: ink, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.title,
                          style: const TextStyle(
                              fontSize: 14.5, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(
                        showSystem ? '${s.system} · ${s.subtitle}' : s.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12,
                            height: 1.35,
                            color: cs.onSurface.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right,
                    color: cs.onSurface.withValues(alpha: 0.3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
