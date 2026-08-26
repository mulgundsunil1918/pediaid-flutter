// =============================================================================
// test/neonatal_smart_view_test.dart
//
// Guards the split between scores that may be ADDED and scores that may not.
//
// The interactive ("Score") view sums the selected grades. That is correct for
// Apgar, Downes, Silverman, Thompson and LATCH, and clinically meaningless for
// Levene, Modified Sarnat and IVH grading, whose columns are mutually
// exclusive STAGES. Getting this wrong produces an authoritative-looking total
// for a score that has none, which is worse than showing nothing.
//
// It also pins the label-column lookup: Thompson names its first column 'sign'
// rather than 'parameter', and a hardcoded 'parameter' silently excluded the
// widest table in the set from the view that fixes it.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:pediaid_app/screens/guides/neonatal_scores/score_smart_view.dart';
import 'package:pediaid_app/data/scores_data_loader.dart';

/// Scores whose grades are points and may be summed.
const _kAdditive = {
  'Apgar Score',
  'Downes Score',
  'Silverman Anderson Score',
  'Thompson Score (HIE)',
  'LATCH Score (Breastfeeding)',
  'BIND Score (Bilirubin-Induced Neurologic Dysfunction)',
  'CRIES Pain Score (Neonatal)',
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('every score is classified additive or staging, correctly', () async {
    final data = await ScoresDataLoader().load();
    for (final s in data.scores) {
      final additive = s.subsections.isEmpty && isAdditiveScore(s.parameters);
      expect(additive, _kAdditive.contains(s.name),
          reason: '${s.name}: summing a staging score is meaningless, and '
              'refusing to sum a points score hides the fix');
    }
  });

  test('the label column is found whatever it is called', () async {
    final data = await ScoresDataLoader().load();
    for (final s in data.scores) {
      if (s.parameters.isEmpty) continue;
      final key = labelKeyOf(s.parameters.first);
      expect(key, isNotNull, reason: '${s.name} has no non-numeric column');
      expect(s.parameters.first[key]!.trim(), isNotEmpty);
    }
    // The specific case that broke it.
    final thompson =
        data.scores.firstWhere((x) => x.name == 'Thompson Score (HIE)');
    expect(labelKeyOf(thompson.parameters.first), 'sign');
  });

  test('interpretation bands parse, including the awkward forms', () {
    expect(parseBandRange('0')?.lo, 0);
    expect(parseBandRange('4-6')?.hi, 6);
    expect(parseBandRange('7–10')?.hi, 10); // en dash
    expect(parseBandRange('≥ 8')?.lo, 8);
    expect(parseBandRange('8+')?.lo, 8);
    // Downes writes strict inequalities; without these its totals 0-3 and 7-10
    // matched no band at all.
    expect(parseBandRange('<4')?.hi, 3);
    expect(parseBandRange('>6')?.lo, 7);
    // Unparseable must return null so it is SKIPPED rather than matching every
    // total and reporting the wrong meaning.
    expect(parseBandRange('mild'), isNull);
  });

  test('every additive score maps its full range to a band', () async {
    final data = await ScoresDataLoader().load();
    for (final s in data.scores.where((x) => _kAdditive.contains(x.name))) {
      final label = labelKeyOf(s.parameters.first)!;
      final grades = s.parameters.first.keys
          .where((k) => k != label)
          .map((k) => int.parse(k.trim()))
          .toList()
        ..sort();
      final max = grades.last * s.parameters.length;
      for (var total = 0; total <= max; total++) {
        expect(meaningForTotal(s.interpretation, total), isNotNull,
            reason: '${s.name}: total $total falls in no interpretation band');
      }
    }
  });
}
