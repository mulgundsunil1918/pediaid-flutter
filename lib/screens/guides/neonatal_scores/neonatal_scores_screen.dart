import 'package:flutter/material.dart';
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

class _NeonatalScoresScreenState extends State<NeonatalScoresScreen> {
  NeonatalScoresData? _data;
  bool _loading = true;
  String? _error;

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
      return const Center(child: CircularProgressIndicator());
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

    final scores = _data!.scores;

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

        // ── Score list ────────────────────────────────────────────────────
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: scores.length + 5,
            separatorBuilder: (context, i) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              // NICHD HIE Assessment — hardcoded card at top
              if (i == 0) {
                return _NichdCard(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NichdHieScreen()),
                  ),
                );
              }
              // LUS — Lung Ultrasound Score
              if (i == 1) {
                return _LusCard(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LusScoreScreen()),
                  ),
                );
              }
              // Modified Ballard — gestational age assessment
              if (i == 2) {
                return _ExtraScoreCard(
                  title: 'Modified Ballard Score',
                  subtitle: 'Gestational age assessment (neuromuscular + physical maturity)',
                  number: 3,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ModifiedBallardScreen())),
                );
              }
              // POFRAS — preterm oral feeding readiness
              if (i == 3) {
                return _ExtraScoreCard(
                  title: 'POFRAS',
                  subtitle: 'Preterm Oral Feeding Readiness Assessment Scale',
                  number: 4,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const PofrasScreen())),
                );
              }
              // CAN Score — clinical assessment of nutrition
              if (i == 4) {
                return _ExtraScoreCard(
                  title: 'CAN Score',
                  subtitle: 'Clinical Assessment of Nutrition at Birth',
                  number: 5,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CanScoreScreen())),
                );
              }
              final score = scores[i - 5];
              return _ScoreCard(
                score: score,
                // Five cards precede the list, and the card renders index + 1, so the
                // sequence continues at 6 instead of restarting at 4.
                index: i,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ScoreDetailScreen(score: score),
                  ),
                ),
              );
            },
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
