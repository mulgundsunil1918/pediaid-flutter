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
  'NIPS — Neonatal Infant Pain Scale',
  'PIPP — Premature Infant Pain Profile',
  'Neonatal Skin Condition Score (NSCS)',
  'nSOFA — Neonatal Sequential Organ Failure Assessment',
  'Modified Sick Neonatal Score (MSNS)',
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

      // Per row, and only the options a row actually has.
      //
      // This test used to take the FIRST row's columns and multiply by the row
      // count — the same mistake the widget made. It survived because every
      // score was uniform. NIPS is not (cry 0-2, the rest 0-1) and nSOFA is
      // not (0/2/4/6/8, 0-4, 0-3), so the range has to be built row by row.
      var min = 0;
      var max = 0;
      for (final row in s.parameters) {
        final grades = <int>[];
        for (final k in row.keys) {
          if (k == label) continue;
          final n = int.tryParse(k.trim());
          if (n == null) continue;
          final text = (row[k] ?? '').trim();
          // An em-dash pads a grid where a row has no option worth that many
          // points. It is not a choice.
          if (text.isEmpty || text == '—' || text == '-') continue;
          grades.add(n);
        }
        if (grades.isEmpty) continue;
        grades.sort();
        min += grades.first;
        max += grades.last;
      }

      // From the score's OWN minimum, not from zero. NSCS items are scored
      // 1-3, so its lowest possible total is 3 and totals 0-2 do not exist.
      for (var total = min; total <= max; total++) {
        expect(meaningForTotal(s.interpretation, total), isNotNull,
            reason: '${s.name}: total $total falls in no interpretation band');
      }
    }
  });
}
