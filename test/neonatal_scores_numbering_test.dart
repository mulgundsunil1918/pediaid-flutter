// =============================================================================
// test/neonatal_scores_numbering_test.dart
//
// The hub numbers its cards 1..N. Five entries are hand-written widgets with a
// hardcoded badge; the rest come from nicu_scores.json and are numbered in a
// loop. That loop read `list.length` while appending to `list`, so the count
// advanced twice per pass and the list rendered 6, 8, 10, 12 ... 26.
//
// This pins the whole visible sequence rather than just the arithmetic: the
// numbers are what a reader actually uses to refer to a score, and a gap in
// them is the kind of defect that survives a green analyzer indefinitely.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/guides/neonatal_scores/neonatal_scores_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('badges run 1..N with no gaps and no repeats', (tester) async {
    tester.view.physicalSize = const Size(430, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: NeonatalScoresScreen()));
    await tester.pumpAndSettle();

    // Every badge is a bare integer Text inside a 28x28 circle. Collecting all
    // integer-only Texts on the page is enough to catch a broken sequence.
    final numbers = tester
        .widgetList<Text>(find.byType(Text))
        .map((t) => t.data)
        .whereType<String>()
        .map((s) => int.tryParse(s))
        .whereType<int>()
        .toList()
      ..sort();

    expect(numbers, isNotEmpty, reason: 'the hub rendered no numbered cards');
    expect(numbers, List<int>.generate(numbers.length, (i) => i + 1),
        reason: 'numbering must be consecutive from 1 — got $numbers');
  });

  testWidgets('Finnegan and SNAPPE-II are reachable from THIS hub',
      (tester) async {
    tester.view.physicalSize = const Size(430, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: NeonatalScoresScreen()));
    await tester.pumpAndSettle();

    // Both were originally registered only in the paediatric hub, where a
    // reader looking for a neonatal score would never find them.
    expect(find.textContaining('Finnegan'), findsWidgets);
    expect(find.textContaining('SNAPPE'), findsWidgets);
  });
}
