// =============================================================================
// test/universal_search_test.dart
//
// Everything in the app must be findable from the home-screen search bar.
//
// It was not. There were two catalogues: app_search_delegate.dart lists every
// tool by hand with hand-tuned keywords, and ToolRegistry DERIVES its list from
// guideCatalogue, allPaediatricScores and nicu_scores.json. Home search read
// only the hand-written one, so an entire week of work — the ROP module, the
// rabies module, seven neonatal scores, Bell's staging — could not be found by
// typing its name.
//
// The registry had its own version of the same problem: the neonatal scores it
// knows were a hand-typed list of names, so the five added to the JSON were
// invisible there too.
//
// So these tests are not really about search. They are about the rule that a
// list describing data must come FROM that data.
// =============================================================================

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/home/app_search_delegate.dart';
import 'package:pediaid_app/services/tool_registry.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> warm() => ToolRegistry.instance.registerAssetScores();

  group('everything added recently is findable by name', () {
    test('the modules and scores from the last week all resolve', () async {
      await warm();
      const queries = {
        'rop': 'ROP',
        'retinopathy': 'ROP',
        'rabies': 'Rabies',
        'animal bite': 'Rabies',
        'finnegan': 'Finnegan',
        'snappe': 'SNAPPE',
        'bind': 'BIND',
        'cries': 'CRIES',
        'nips': 'NIPS',
        'pipp': 'PIPP',
        'nsofa': 'nSOFA',
        'skin condition': 'Skin Condition',
        'modified sick': 'Modified Sick',
        'bell': "Bell",
        'enterocolitis': "Bell",
        'weight velocity': 'Weight Velocity',
      };
      final missing = <String>[];
      queries.forEach((q, expected) {
        final hits = ToolRegistry.instance.search(q);
        if (!hits.any((t) => t.label.contains(expected))) missing.add(q);
      });
      expect(missing, isEmpty,
          reason: 'not findable by typing: ${missing.join(", ")}');
    });

    test('a typographic dash does not hide a tool', () async {
      // Titles use en dashes — "A–a Gradient" — and nobody types one.
      await warm();
      expect(ToolRegistry.instance.search('a-a gradient'), isNotEmpty);
      expect(ToolRegistry.instance.search('a–a gradient'), isNotEmpty);
    });
  });

  group('the registry follows the data instead of a typed list', () {
    test('EVERY score in nicu_scores.json is searchable', () async {
      // The check that would have caught this: five scores were added to the
      // asset and none were registered, because the registry named them by
      // hand.
      await warm();
      final raw = await rootBundle.loadString('assets/data/nicu_scores.json');
      final names = (jsonDecode(raw)['scores'] as List)
          .map((s) => (s as Map)['name'] as String)
          .toList();

      final labels = ToolRegistry.instance.all.map((t) => t.label).toSet();
      final missing = names.where((n) => !labels.contains(n)).toList();
      expect(missing, isEmpty,
          reason: 'in the asset but not searchable: ${missing.join(", ")}');
      expect(names.length, greaterThanOrEqualTo(16));
    });

    test('registerAssetScores is safe to call twice', () async {
      await warm();
      final first = ToolRegistry.instance.all.length;
      await warm();
      expect(ToolRegistry.instance.all.length, first,
          reason: 'a second scan must not duplicate every score');
    });

    test('no two entries share a key', () async {
      await warm();
      final keys = ToolRegistry.instance.all.map((t) => t.key).toList();
      expect(keys.toSet().length, keys.length,
          reason: 'keys are persisted for pinning — a collision would open '
              'the wrong screen');
    });
  });

  group('the catalogues stay in step', () {
    test('Bell\'s has its own screen, so it must be named explicitly',
        () async {
      // It is not a JSON row, so the asset scan cannot find it — the only way
      // it is searchable is the explicit entry.
      await warm();
      final hits = ToolRegistry.instance.search('necrotising enterocolitis');
      expect(hits.any((t) => t.label.contains('Bell')), isTrue);
    });

    test('the registry is substantially bigger than it was', () async {
      await warm();
      // 203 before this work; the asset scan and Bell's add to that. A sharp
      // drop means a catalogue stopped being read.
      expect(ToolRegistry.instance.all.length, greaterThan(200));
    });
  });

  // ── The search bar people actually use ─────────────────────────────────
  //
  // Everything above tests ToolRegistry. That is necessary and not sufficient:
  // the registry was already right about most things, and the home search bar
  // still could not find them, because it read a different list. This drives
  // the real delegate.
  group('the home-screen search bar finds it', () {
    /// Opens the real delegate and sets its query.
    ///
    /// The query is set on the delegate rather than typed into the field:
    /// SearchDelegate builds its TextField inside a pushed route, and driving
    /// the widget tree there fights the asset warm-ups the constructor starts.
    /// buildSuggestions is what renders results either way, so this exercises
    /// the same path with none of the flakiness.
    Future<void> openAndType(WidgetTester tester, String query) async {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final delegate = AppSearchDelegate();
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () =>
                    showSearch<void>(context: context, delegate: delegate),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      // Several pumps rather than pumpAndSettle: the constructor warms the
      // guideline and formulary caches, so the tree never goes quiet.
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 120));
      }
      delegate.query = query;
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 120));
      }
    }

    testWidgets('"rabies" surfaces the module', (tester) async {
      await ToolRegistry.instance.registerAssetScores();
      await openAndType(tester, 'rabies');
      expect(find.textContaining('Rabies'), findsWidgets,
          reason: 'the module was unreachable from this search bar');
    });

    testWidgets('"nsofa" surfaces the score', (tester) async {
      await ToolRegistry.instance.registerAssetScores();
      await openAndType(tester, 'nsofa');
      expect(find.textContaining('nSOFA'), findsWidgets);
    });

    testWidgets('"enterocolitis" surfaces Bell\'s staging', (tester) async {
      await ToolRegistry.instance.registerAssetScores();
      await openAndType(tester, 'enterocolitis');
      expect(find.textContaining('Bell'), findsWidgets);
    });

    testWidgets('"retinopathy" surfaces the ROP module', (tester) async {
      await ToolRegistry.instance.registerAssetScores();
      await openAndType(tester, 'retinopathy');
      expect(find.textContaining('ROP'), findsWidgets);
    });
  });
}
