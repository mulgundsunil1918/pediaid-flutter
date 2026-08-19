// =============================================================================
// neonatal_score_by_name.dart
//
// Opens one JSON-driven neonatal score by its name.
//
// The nine scores in nicu_scores.json are loaded asynchronously, so they could
// not be registered in ToolRegistry (which resolves screens synchronously).
// The effect was that searching "apgar" in Quick Access or the home search
// returned only the "Neonatal Scores" hub — the score itself was unreachable
// except by browsing.
//
// This wrapper closes that gap: it is a synchronous widget the registry can
// construct, and it performs the load itself before showing the detail screen.
// =============================================================================

import 'package:flutter/material.dart';

import '../../../data/scores_data_loader.dart';
import 'score_detail_screen.dart';

class NeonatalScoreByName extends StatefulWidget {
  const NeonatalScoreByName({super.key, required this.scoreName});

  /// Must match the `name` field in nicu_scores.json exactly.
  final String scoreName;

  @override
  State<NeonatalScoreByName> createState() => _NeonatalScoreByNameState();
}

class _NeonatalScoreByNameState extends State<NeonatalScoreByName> {
  NeonatalScore? _score;
  String? _error;

  @override
  void initState() {
    super.initState();
    ScoresDataLoader().load().then((data) {
      if (!mounted) return;
      NeonatalScore? match;
      for (final s in data.scores) {
        if (s.name == widget.scoreName) {
          match = s;
          break;
        }
      }
      setState(() {
        _score = match;
        _error = match == null
            ? 'Score "${widget.scoreName}" is no longer in the score data.'
            : null;
      });
    }).catchError((Object e) {
      if (mounted) setState(() => _error = e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      final cs = Theme.of(context).colorScheme;
      return Scaffold(
        appBar: AppBar(title: Text(widget.scoreName)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(_error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: cs.error)),
          ),
        ),
      );
    }
    if (_score == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.scoreName)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return ScoreDetailScreen(score: _score!);
  }
}
