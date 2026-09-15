// =============================================================================
// test/guide_badge_counts_test.dart
//
// The Guides cards advertise how many scores each hub holds.
//
// Those numbers were typed into the catalogue by hand, so they stopped being
// true the moment a score was added somewhere else: the neonatal card still
// read "14 scores" while the hub offered 23, and the paediatric card "96" after
// Finnegan and SNAPPE-II went in. Nothing failed, because nothing was checking.
//
// The badges are now computed from the score lists themselves. These tests pin
// the one number that still cannot be — the count of hand-written cards in the
// neonatal hub — and assert the arithmetic that feeds the label.
// =============================================================================

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/guides/neonatal_scores/neonatal_scores_screen.dart';
import 'package:pediaid_app/screens/scores/paediatric_scores_hub.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('the neonatal count is fixed cards plus every JSON score', () async {
    final raw = await rootBundle.loadString('assets/data/nicu_scores.json');
    final jsonCount = (jsonDecode(raw)['scores'] as List).length;

    expect(await neonatalScoreCount(), kNeonatalFixedScoreCards + jsonCount);
    // If this fails, a score was added and the hub grew — which is fine. The
    // badge follows automatically; only this expectation needs the new number.
    expect(jsonCount, 16);
  });

  test('kNeonatalFixedScoreCards matches the hub it describes', () {
    // The hub asserts this at runtime too, but an assert only fires in debug
    // and only if someone opens the screen. This fails in CI.
    expect(kNeonatalFixedScoreCards, 8,
        reason: 'NICHD, LUS, Modified Ballard, POFRAS, CAN, Modified Finnegan, '
            "Modified Bell's staging, SNAPPE-II");
  });

  test('the paediatric count comes from the list, and is not zero', () {
    // Computed, so there is no literal to drift. Asserting it is non-trivial
    // catches the list failing to assemble at all.
    expect(allPaediatricScores.length, greaterThan(90));
    expect(allPaediatricScores.map((s) => s.title).toSet().length,
        allPaediatricScores.length,
        reason: 'a duplicated score would inflate the badge');
  });

  test('Finnegan and SNAPPE-II are counted once, not twice', () {
    // They live in neonatalScores, which is spread into allPaediatricScores AND
    // surfaced as fixed cards in the neonatal hub. Two hubs, one definition —
    // but neither total should double-count within itself.
    final titles = allPaediatricScores.map((s) => s.title).toList();
    for (final t in titles) {
      expect(titles.where((x) => x == t).length, 1, reason: t);
    }
  });
}
