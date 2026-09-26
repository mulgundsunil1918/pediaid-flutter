// =============================================================================
// scores/paediatric_scores_hub.dart
//
// The Paediatric Scores hub. Every score registers itself here as a ScoreDef,
// and the hub offers the two orderings Sunil asked for: grouped BY SYSTEM
// (default) or a flat A–Z list, plus a search box.
// =============================================================================

import 'package:flutter/material.dart';
import '../guides/aki/aki_screen.dart';

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

/// A row in this hub.
///
/// Almost every row is a [ScoreDef]. AKI is not — it is a classification with
/// its own screen, and the shared ScoreScaffold would sum columns that are not
/// points and report a total out of a maximum that does not exist.
///
/// It was pinned above the list for exactly that reason, and that was wrong:
/// pinned, it ignored both sort modes and sat out of A–Z order, which is the
/// one thing a list sorted A–Z promises. The list now carries a small wrapper
/// so a non-score entry can take its proper place among the scores.
class _HubEntry {
  const _HubEntry({
    required this.title,
    required this.subtitle,
    required this.system,
    required this.accent,
    required this.open,
    this.keywords = '',
  });

  factory _HubEntry.fromScore(ScoreDef s) => _HubEntry(
    title: s.title,
    subtitle: s.subtitle,
    system: s.system,
    accent: s.accent,
    open: (ctx) => Navigator.push(
      ctx,
      MaterialPageRoute(builder: (_) => ScoreScaffold(def: s)),
    ),
  );

  final String title;
  final String subtitle;
  final String system;
  final Color accent;
  final void Function(BuildContext) open;

  /// Extra words to match in the search box. Empty for scores, whose title and
  /// subtitle already carry their vocabulary; AKI needs it because nobody
  /// searching for this types the words in its title.
  final String keywords;

  bool matches(String q) =>
      title.toLowerCase().contains(q) ||
      subtitle.toLowerCase().contains(q) ||
      system.toLowerCase().contains(q) ||
      (keywords.isNotEmpty && keywords.contains(q));
}

/// Everything this hub lists — the scores, plus the classifications that are
/// not scores. Derived, so a score added to allPaediatricScores appears here
/// without anyone remembering to add it twice.
List<_HubEntry> _hubEntries() => [
  ...allPaediatricScores.map(_HubEntry.fromScore),
  _HubEntry(
    title: 'AKI Classification',
    subtitle: 'Acute kidney injury — KDIGO, with pRIFLE',
    system: 'Renal',
    accent: const Color(0xFF0288D1),
    keywords:
        'aki acute kidney injury renal failure insufficiency '
        'creatinine oliguria oliguric anuria anuric urine output kdigo '
        'prifle rifle nephrology dialysis rrt crrt azotaemia azotemia '
        'uraemia uremia staging classification',
    open: (ctx) => Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (_) => const AkiScreen(entry: AkiEntry.paediatric),
      ),
    ),
  ),
];

class PaediatricScoresHub extends StatefulWidget {
  const PaediatricScoresHub({super.key});

  @override
  State<PaediatricScoresHub> createState() => _PaediatricScoresHubState();
}

class _PaediatricScoresHubState extends State<PaediatricScoresHub> {
  bool _azMode = false;
  String _query = '';

  List<_HubEntry> get _filtered {
    final all = _hubEntries();
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all.where((e) => e.matches(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final items = _filtered;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Paediatric Scores',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: cs.outline.withValues(alpha: 0.3),
                        ),
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
              child: Row(
                children: [
                  _sortBtn(
                    'By system',
                    !_azMode,
                    () => setState(() => _azMode = false),
                  ),
                  const SizedBox(width: 4),
                  _sortBtn(
                    'A–Z',
                    _azMode,
                    () => setState(() => _azMode = true),
                  ),
                  // A bare "98" used to sit here. A number with no label says
                  // nothing — the per-system headers already carry counts that
                  // mean something, and this one was only ever the length of
                  // whatever happened to be on screen.
                ],
              ),
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      'No scores match "$_query"',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  )
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
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: active ? cs.onPrimary : cs.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  Widget _azList(List<_HubEntry> items) {
    final sorted = [...items]..sort((a, b) => a.title.compareTo(b.title));
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: sorted.length,
      itemBuilder: (_, i) => _tile(sorted[i], showSystem: true),
    );
  }

  Widget _systemList(List<_HubEntry> items) {
    final groups = <String, List<_HubEntry>>{};
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
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: cs.primary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$n',
            style: TextStyle(
              fontSize: 11.5,
              color: cs.onSurface.withValues(alpha: 0.45),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Divider(color: cs.primary.withValues(alpha: 0.2), height: 1),
          ),
        ],
      ),
    );
  }

  Widget _tile(_HubEntry s, {bool showSystem = false}) {
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
          onTap: () => s.open(context),
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
                      Text(
                        s.title,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        showSystem ? '${s.system} · ${s.subtitle}' : s.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: cs.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: cs.onSurface.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
