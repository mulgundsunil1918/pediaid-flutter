// =============================================================================
// test/neonatal_new_scores_test.dart
//
// NIPS, PIPP, NSCS, nSOFA and MSNS — and the two defects adding them exposed.
//
// The smart view used to read its point columns from the FIRST row and apply
// them to every row, and computed the maximum as "top value x number of rows".
// Every score in the hub happened to be uniform, so it never showed. NIPS is
// not uniform (cry scores 0-2, everything else 0-1) and nSOFA is not either
// (0/2/4/6/8, 0-4, 0-3). Under the old code NIPS would have read "out of 12"
// against a real maximum of 7, and nSOFA "out of 24" against 15 — a wrong
// denominator makes every score look less severe than it is.
//
// The table view had the matching bug: columns came from rows.first.keys, so
// nSOFA's cardiovascular 1 and 3 would have been silently dropped — present in
// the data, absent from the screen, with nothing to show anything was missing.
// =============================================================================

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/guides/neonatal_scores/score_smart_view.dart';

late List<Map<String, dynamic>> _scores;

Map<String, dynamic> _byName(String needle) => _scores.firstWhere(
      (s) => (s['name'] as String).toLowerCase().contains(needle.toLowerCase()),
      orElse: () => throw StateError('score not found: $needle'),
    );

String _labelKey(Map<String, dynamic> row) =>
    row.keys.firstWhere((k) => int.tryParse(k.trim()) == null);

/// The maximum the smart view computes: each row's own top value, added up.
int _maxOf(Map<String, dynamic> score) {
  final params = (score['parameters'] as List).cast<Map<String, dynamic>>();
  final label = _labelKey(params.first);
  var sum = 0;
  for (final row in params) {
    final vals = <int>[];
    for (final k in row.keys) {
      if (k == label) continue;
      final n = int.tryParse(k.trim());
      if (n == null) continue;
      final text = (row[k] as String? ?? '').trim();
      if (text.isEmpty || text == '—' || text == '-') continue;
      vals.add(n);
    }
    if (vals.isNotEmpty) sum += vals.reduce((a, b) => a > b ? a : b);
  }
  return sum;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final raw = await rootBundle.loadString('assets/data/nicu_scores.json');
    _scores = (jsonDecode(raw)['scores'] as List).cast<Map<String, dynamic>>();
  });

  test('all five new scores are present', () {
    for (final n in ['NIPS', 'PIPP', 'Skin Condition', 'nSOFA', 'Modified Sick']) {
      expect(() => _byName(n), returnsNormally, reason: n);
    }
  });

  group('the maximum each score can reach', () {
    test('NIPS is out of 7, not 12', () {
      // Six items; cry scores 0-2 and the other five 0-1.
      expect(_maxOf(_byName('NIPS')), 7);
    });

    test('PIPP is out of 21', () {
      final p = (_byName('PIPP')['parameters'] as List);
      expect(p.length, 7, reason: 'seven indicators');
      expect(_maxOf(_byName('PIPP')), 21);
    });

    test('NSCS runs 3 to 9 — its minimum is 3, not 0', () {
      final s = _byName('Skin Condition');
      expect(_maxOf(s), 9);
      // Every row's lowest option is 1, so a fully scored infant cannot be 0.
      final params = (s['parameters'] as List).cast<Map<String, dynamic>>();
      for (final row in params) {
        expect(row.containsKey('0'), isFalse,
            reason: 'NSCS items are scored 1-3, never 0');
      }
      expect(params.length, 3);
    });

    test('nSOFA is out of 15, not 24', () {
      expect(_maxOf(_byName('nSOFA')), 15);
    });

    test('MSNS is out of 16', () {
      expect((_byName('Modified Sick')['parameters'] as List).length, 8);
      expect(_maxOf(_byName('Modified Sick')), 16);
    });

    test('no existing score changed its maximum', () {
      expect(_maxOf(_byName('Apgar Score')), 10);
      expect(_maxOf(_byName('Downes')), 10);
      expect(_maxOf(_byName('Silverman')), 10);
      expect(_maxOf(_byName('Thompson')), 22);
      expect(_maxOf(_byName('CRIES')), 10);
      expect(_maxOf(_byName('BIND')), 9);
    });
  });

  group('nSOFA has genuinely uneven rows', () {
    test('respiratory scores only 0, 2, 4, 6, 8', () {
      final params =
          (_byName('nSOFA')['parameters'] as List).cast<Map<String, dynamic>>();
      final resp = params.firstWhere(
          (r) => (r['parameter'] as String).contains('Respiratory'));
      final real = resp.keys
          .where((k) => int.tryParse(k) != null)
          .where((k) => (resp[k] as String).trim() != '—')
          .map(int.parse)
          .toList()
        ..sort();
      expect(real, [0, 2, 4, 6, 8],
          reason: 'there is no 1, 3, 5 or 7 on this row');
    });

    test('the padded cells are em-dashes, so they are skipped not offered', () {
      final params =
          (_byName('nSOFA')['parameters'] as List).cast<Map<String, dynamic>>();
      final haem = params.firstWhere(
          (r) => (r['parameter'] as String).contains('Haematological'));
      expect(haem['4'], '—');
      expect(haem['6'], '—');
      expect(haem['8'], '—');
      // And the real platelet bands are all there.
      expect(haem['0'], contains('150'));
      expect(haem['3'], contains('50'));
    });

    test('every row carries the same key set, so the table has full columns',
        () {
      // The table takes the union of all rows, but keeping the keys aligned
      // means the grid reads as a grid rather than a ragged set of cells.
      final params =
          (_byName('nSOFA')['parameters'] as List).cast<Map<String, dynamic>>();
      final first = params.first.keys.toSet();
      for (final row in params) {
        expect(row.keys.toSet(), first);
      }
    });
  });

  group('MSNS runs backwards and says so', () {
    test('a HIGHER score is better — the reference warns in capitals', () {
      final ref = _byName('Modified Sick')['reference'] as String;
      expect(ref, contains('RUNS BACKWARDS'));
      expect(ref, contains('HIGHER score is BETTER'));
    });

    test('the LOW band is the dangerous one', () {
      final interp = (_byName('Modified Sick')['interpretation'] as List)
          .cast<Map<String, dynamic>>();
      final low = interp.firstWhere((i) => i['score'] == '0-10');
      expect((low['meaning'] as String).toUpperCase(), contains('HIGH'));
      final high = interp.firstWhere((i) => i['score'] == '14-16');
      expect((high['meaning'] as String).toLowerCase(), contains('lower'));
    });

    test('normal values score 2, not 0', () {
      final params = (_byName('Modified Sick')['parameters'] as List)
          .cast<Map<String, dynamic>>();
      final hr =
          params.firstWhere((r) => r['parameter'] == 'Heart rate');
      expect(hr['2'], contains('Normal'));
      expect(hr['0'], contains('Bradycardia'));
    });
  });

  group('every new score cites its source', () {
    test('named authors, journal and year', () {
      const expected = {
        'NIPS': 'Lawrence',
        'PIPP': 'Stevens',
        'Skin Condition': 'Lund',
        'nSOFA': 'Wynn',
        'Modified Sick': 'Mansoor',
      };
      expected.forEach((score, author) {
        final ref = _byName(score)['reference'] as String;
        expect(ref, contains(author), reason: score);
        expect(ref, matches(RegExp(r'(19|20)\d\d')), reason: '$score year');
      });
    });

    test('nSOFA does not claim validated treatment thresholds', () {
      // It is validated as a continuous predictor; the bands are descriptive
      // and must not read as cut-offs someone acts on.
      final ref = _byName('nSOFA')['reference'] as String;
      expect(ref, contains('CONTINUOUS'));
      expect(ref, contains('not validated treatment thresholds'));
    });

    test('PIPP records that two items are scored as CHANGE from baseline', () {
      final ref = _byName('PIPP')['reference'] as String;
      expect(ref, contains('CHANGE'));
      expect(ref, contains('baseline'));
    });

    test('every score has interpretation bands covering its own maximum', () {
      for (final n in ['NIPS', 'PIPP', 'Skin Condition', 'nSOFA', 'Modified Sick']) {
        final s = _byName(n);
        final bands = (s['interpretation'] as List).cast<Map<String, dynamic>>();
        expect(bands, isNotEmpty, reason: n);
        final last = bands.last['score'] as String;
        final top = int.parse(last.split('-').last.trim());
        expect(top, greaterThanOrEqualTo(_maxOf(s)),
            reason: '$n: the top band must reach the maximum score');
      }
    });
  });

  // ── The widget itself, not a reimplementation of its arithmetic ─────────
  //
  // Everything above computes the maximum the same way the widget does, which
  // proves the DATA is shaped right but would still pass if the widget ignored
  // it. These render the real smart view and read the denominator off screen.
  group('the rendered smart view shows the right denominator', () {
    Future<void> pump(WidgetTester tester, String name) async {
      final score = _byName(name);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ScoreSmartView(
              parameters: (score['parameters'] as List)
                  .map((r) => (r as Map).map(
                      (k, v) => MapEntry(k as String, v as String)))
                  .toList(),
              interpretation: (score['interpretation'] as List)
                  .map((r) => (r as Map).map(
                      (k, v) => MapEntry(k as String, v as String)))
                  .toList(),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('NIPS renders "/ 7", not "/ 12"', (tester) async {
      tester.view.physicalSize = const Size(375, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await pump(tester, 'NIPS');
      expect(find.text('/ 7'), findsOneWidget);
      expect(find.text('/ 12'), findsNothing);
    });

    testWidgets('nSOFA renders "/ 15", not "/ 24"', (tester) async {
      tester.view.physicalSize = const Size(375, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await pump(tester, 'nSOFA');
      expect(find.text('/ 15'), findsOneWidget);
      expect(find.text('/ 24'), findsNothing);
    });

    testWidgets('nSOFA offers no option for the padded em-dash cells',
        (tester) async {
      tester.view.physicalSize = const Size(375, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await pump(tester, 'nSOFA');
      // A "—" rendered as a selectable option would let a clinician score
      // points the row does not have.
      expect(find.text('—'), findsNothing);
    });

    testWidgets('MSNS renders "/ 16"', (tester) async {
      tester.view.physicalSize = const Size(375, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await pump(tester, 'Modified Sick');
      expect(find.text('/ 16'), findsOneWidget);
    });
  });
}
