import 'package:flutter/material.dart';

import '../../../widgets/skeleton.dart';
import '../../../data/scores_data_loader.dart';
import 'score_detail_screen.dart';
import 'nichd_hie_screen.dart';
import 'lus_score_screen.dart';
import '../modified_ballard_screen.dart';
import '../pofras_screen.dart';
import '../can_score_screen.dart';

class NeonatalScoresScreen extends StatefulWidget {
  const NeonatalScoresScreen({super.key});

  @override
  State<NeonatalScoresScreen> createState() => _NeonatalScoresScreenState();
}

/// One row of the list. The five hardcoded cards and the JSON-driven scores
/// are different widgets, so each entry carries its own builder — that lets a
/// single filter run over the whole list instead of only the JSON half.
class _Entry {
  final String title;
  final String keywords;
  final WidgetBuilder build;
  const _Entry(this.title, this.keywords, this.build);

  bool matches(String q) =>
      title.toLowerCase().contains(q) || keywords.toLowerCase().contains(q);
}

class _NeonatalScoresScreenState extends State<NeonatalScoresScreen> {
  NeonatalScoresData? _data;
  bool _loading = true;
  String? _error;

  final TextEditingController _searchCtl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  /// Numbers are fixed to each score's position in the full list, not the
  /// filtered one, so a score keeps the same number while searching.
  List<_Entry> _entries() {
    final list = <_Entry>[
      _Entry(
        'NICHD HIE Assessment',
        'cooling eligibility hypoxic ischaemic encephalopathy therapeutic hypothermia sarnat',
        (ctx) => _NichdCard(
          onTap: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => const NichdHieScreen()),
          ),
        ),
      ),
      _Entry(
        'Lung Ultrasound Score (LUS)',
        'neonatal lung aeration 6 or 10-zone method surfactant respiratory distress',
        (ctx) => _LusCard(
          onTap: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => const LusScoreScreen()),
          ),
        ),
      ),
      _Entry(
        'Modified Ballard Score',
        'gestational age assessment neuromuscular physical maturity new ballard',
        (ctx) => _ExtraScoreCard(
          title: 'Modified Ballard Score',
          subtitle:
              'Gestational age assessment (neuromuscular + physical maturity)',
          number: 3,
          onTap: () => Navigator.push(ctx,
              MaterialPageRoute(builder: (_) => const ModifiedBallardScreen())),
        ),
      ),
      _Entry(
        'POFRAS',
        'preterm oral feeding readiness assessment scale breastfeeding',
        (ctx) => _ExtraScoreCard(
          title: 'POFRAS',
          subtitle: 'Preterm Oral Feeding Readiness Assessment Scale',
          number: 4,
          onTap: () => Navigator.push(
              ctx, MaterialPageRoute(builder: (_) => const PofrasScreen())),
        ),
      ),
      _Entry(
        'CAN Score',
        'clinical assessment of nutrition at birth malnutrition metcoff',
        (ctx) => _ExtraScoreCard(
          title: 'CAN Score',
          subtitle: 'Clinical Assessment of Nutrition at Birth',
          number: 5,
          onTap: () => Navigator.push(
              ctx, MaterialPageRoute(builder: (_) => const CanScoreScreen())),
        ),
      ),
    ];

    final scores = _data!.scores;
    for (var i = 0; i < scores.length; i++) {
      final score = scores[i];
      final number = list.length + i + 1;
      list.add(_Entry(
        score.name,
        [
          for (final sub in score.subsections) sub.title,
          score.reference,
        ].join(' '),
        (ctx) => _ScoreCard(
          score: score,
          index: number - 1,
          onTap: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => ScoreDetailScreen(score: score)),
          ),
        ),
      ));
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    ScoresDataLoader().load().then((d) {
      if (mounted) setState(() { _data = d; _loading = false; });
    }).catchError((e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Neonatal Scores'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: _buildBody(cs),
      ),
    );
  }

  Widget _buildBody(ColorScheme cs) {
    if (_loading) {
      return const SkeletonList(items: 8);
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Failed to load scores.\n$_error',
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.error),
          ),
        ),
      );
    }

    final entries = _entries();
    final q = _query.trim().toLowerCase();
    final visible =
        q.isEmpty ? entries : entries.where((e) => e.matches(q)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Subtitle banner ───────────────────────────────────────────────
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
          ),
          child: Text(
            _data!.description,
            style: TextStyle(
              fontSize: 12.5,
              color: cs.onSurface.withValues(alpha: 0.6),
              height: 1.4,
            ),
          ),
        ),

        // ── Search ────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
          child: TextField(
            controller: _searchCtl,
            onChanged: (v) => setState(() => _query = v),
            textInputAction: TextInputAction.search,
            style: TextStyle(fontSize: 14, color: cs.onSurface),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Search ${entries.length} neonatal scores…',
              hintStyle: TextStyle(
                  fontSize: 13.5,
                  color: cs.onSurface.withValues(alpha: 0.45)),
              prefixIcon: Icon(Icons.search,
                  size: 20, color: cs.onSurface.withValues(alpha: 0.5)),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: Icon(Icons.close,
                          size: 18,
                          color: cs.onSurface.withValues(alpha: 0.6)),
                      onPressed: () {
                        _searchCtl.clear();
                        setState(() => _query = '');
                      },
                    ),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: cs.outline.withValues(alpha: 0.35)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: cs.outline.withValues(alpha: 0.35)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: cs.primary, width: 1.4),
              ),
            ),
          ),
        ),

        // ── Score list ────────────────────────────────────────────────────
        Expanded(
          child: visible.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'No score matches "${_searchCtl.text}".',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13.5,
                          color: cs.onSurface.withValues(alpha: 0.55)),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: visible.length,
                  separatorBuilder: (context, i) => const SizedBox(height: 8),
                  itemBuilder: (context, i) => visible[i].build(context),
                ),
        ),
      ],
    );
  }
}

// ── LUS card (hardcoded) ──────────────────────────────────────────────────────

class _LusCard extends StatelessWidget {
  final VoidCallback onTap;
  const _LusCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      elevation: isDark ? 0 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: cs.secondary.withValues(alpha: 0.7),
                width: 3,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: cs.secondary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '2',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: cs.secondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lung Ultrasound Score (LUS)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Neonatal lung aeration · 6 or 10-zone method',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  color: cs.onSurface.withValues(alpha: 0.35), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Extra score card (Ballard, POFRAS — link to their own screens) ───────────

class _ExtraScoreCard extends StatelessWidget {
  final String title;
  final String subtitle;
  /// Position in the list, 1-based.
  ///
  /// These three cards used to show a topic icon where every other card shows
  /// its number, so the list read 1, 2, [icon], [icon], [icon], 4, 5 — three
  /// entries with no number and a sequence that then skipped 3. One card, one
  /// number, counted from the same place.
  final int number;
  final VoidCallback onTap;
  const _ExtraScoreCard({
    required this.title,
    required this.subtitle,
    required this.number,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      elevation: isDark ? 0 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(color: cs.primary.withValues(alpha: 0.7), width: 3),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurface.withValues(alpha: 0.6))),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: cs.onSurface.withValues(alpha: 0.35)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Score card ────────────────────────────────────────────────────────────────

class _ScoreCard extends StatelessWidget {
  final NeonatalScore score;
  final int index;
  final VoidCallback onTap;

  const _ScoreCard({
    required this.score,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final paramCount = score.parameters.length;
    final colCount = score.parameters.isNotEmpty
        ? score.parameters.first.length
        : 0;

    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      elevation: isDark ? 0 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: cs.primary.withValues(alpha: 0.5),
                width: 3,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Index badge
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Score name
              Expanded(
                child: Text(
                  score.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
              ),
              // Meta chips
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MetaChip(
                    '${paramCount}P',
                    cs.onSurface.withValues(alpha: 0.35),
                  ),
                  const SizedBox(width: 6),
                  _MetaChip(
                    '${colCount}C',
                    cs.onSurface.withValues(alpha: 0.35),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right,
                      color: cs.onSurface.withValues(alpha: 0.35), size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── NICHD HIE Assessment card (hardcoded, not from JSON) ─────────────────────

class _NichdCard extends StatelessWidget {
  final VoidCallback onTap;
  const _NichdCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      elevation: isDark ? 0 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: cs.tertiary.withValues(alpha: 0.7),
                width: 3,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Badge
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: cs.tertiary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '1',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: cs.tertiary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NICHD HIE Assessment',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Cooling eligibility & assessment tool',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  color: cs.onSurface.withValues(alpha: 0.35), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final Color color;
  const _MetaChip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
