// =============================================================================
// test/hub_ordering_test.dart
//
// Both score hubs list alphabetically, and AKI sits in the list rather than
// beside it.
//
// AKI was pinned above the paediatric list because it is a classification and
// the hub is built from ScoreDef. Pinned, it ignored both sort modes and sat
// out of A–Z order — which is the one thing a list labelled A–Z promises. And
// the neonatal hub listed "the cards we wrote by hand, then whatever order the
// JSON asset happens to use", which is an implementation detail showing
// through to the user.
//
// Neither is the sort of thing that fails loudly. A regression here just looks
// like a slightly odd list.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/guides/neonatal_scores/neonatal_scores_screen.dart';
import 'package:pediaid_app/screens/scores/paediatric_scores_hub.dart';

/// Titles in the order they are rendered, read off the built tree.
List<String> _titlesIn(WidgetTester tester) => tester
    .widgetList<Text>(find.byType(Text))
    .map((t) => t.data ?? '')
    .where((s) => s.isNotEmpty)
    .toList();

Future<void> _pump(WidgetTester tester, Widget w, {double h = 4000}) async {
  tester.view.physicalSize = Size(420, h);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(home: w));
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 120));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('the neonatal hub lists alphabetically', () {
    testWidgets('hand-written cards and JSON rows are interleaved, not '
        'segregated', (tester) async {
      await _pump(tester, const NeonatalScoresScreen());

      final titles = _titlesIn(tester);
      // "Modified Ballard Score" is a hand-written card and "Apgar Score" is a
      // JSON row. Before the sort, every hand-written card preceded every JSON
      // row; alphabetically, Apgar comes first.
      final ballard = titles.indexWhere((t) => t.contains('Ballard'));
      final apgar = titles.indexWhere((t) => t.contains('Apgar'));
      if (ballard >= 0 && apgar >= 0) {
        expect(apgar, lessThan(ballard),
            reason: 'a JSON row must be able to precede a hand-written card');
      }
    });

    testWidgets('the first card is not NICHD any more', (tester) async {
      // NICHD was card 1 purely because it was written first.
      await _pump(tester, const NeonatalScoresScreen());
      final titles = _titlesIn(tester);
      final nichd = titles.indexWhere((t) => t.contains('NICHD'));
      final firstScore = titles.indexWhere((t) =>
          t.contains('Apgar') || t.contains('AKI') || t.contains('Ballard'));
      if (nichd >= 0 && firstScore >= 0) {
        expect(firstScore, lessThan(nichd),
            reason: 'NICHD sorts under N and cannot still be first');
      }
    });

    testWidgets('AKI is one of the cards', (tester) async {
      await _pump(tester, const NeonatalScoresScreen());
      expect(find.textContaining('AKI'), findsWidgets);
    });
  });

  group('the paediatric hub', () {
    testWidgets('AKI is IN the A–Z list, in alphabetical position',
        (tester) async {
      await _pump(tester, const PaediatricScoresHub());
      await tester.tap(find.text('A–Z'));
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 120));
      }

      final titles = _titlesIn(tester);
      final aki = titles.indexWhere((t) => t == 'AKI Classification');
      final adhd = titles.indexWhere((t) => t.startsWith('ADHD'));
      expect(aki, greaterThanOrEqualTo(0), reason: 'AKI must be listed');
      if (adhd >= 0) {
        expect(adhd, lessThan(aki),
            reason: 'ADHD sorts before AKI; pinned, AKI came first regardless');
      }
    });

    testWidgets('the bare item count is gone from the sort row',
        (tester) async {
      // It read "98" beside the A–Z toggle — a number with no label, which
      // tells a reader nothing and went stale the moment anything was added.
      await _pump(tester, const PaediatricScoresHub());
      // The per-system headers carry their own counts and those are fine —
      // they are labelled by the header above them. The one being asserted
      // gone is the unlabelled total, which equals the whole list length.
      final titles = _titlesIn(tester);
      final total = allPaediatricScores.length + 1; // +1 for AKI
      expect(titles, isNot(contains('$total')),
          reason: 'the unlabelled total is still rendered');
    });

    testWidgets('searching a word only AKI knows still finds it',
        (tester) async {
      await _pump(tester, const PaediatricScoresHub());
      await tester.enterText(find.byType(TextField).first, 'oliguria');
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 120));
      }
      expect(find.text('AKI Classification'), findsOneWidget,
          reason: 'the keyword list is what makes this findable at all');
    });
  });
}
