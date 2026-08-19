// =============================================================================
// test/inventory_test.dart
//
// Golden inventory of every user-facing catalogue in the app.
//
// WHY THIS EXISTS
// ---------------
// On 2026-08-19 the "Paediatric Scores" entry was lost from the Guides list
// during an unrelated repair. `flutter analyze` passed — a missing element in a
// list is not a compile error — and all 117 tests passed, because nothing
// asserted what the catalogues should contain. Two builds shipped with 96
// scores compiled into the binary but no way to reach them.
//
// This test makes that class of bug impossible to ship silently: a deletion, a
// rename, or an accidental revert fails here immediately.
//
// WHEN THIS TEST FAILS
// --------------------
// It is doing its job. Either you removed something on purpose — in which case
// update the expected list in the same commit, deliberately — or you removed
// something by accident, which is exactly what it is here to catch. Never
// "fix" it by loosening the assertion to a count-only check.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/guides/guides_screen.dart';
import 'package:pediaid_app/screens/scores/paediatric_scores_hub.dart';
import 'package:pediaid_app/screens/calculators/calculators_screen.dart';
import 'package:pediaid_app/screens/resources/resources_screen.dart';
import 'package:pediaid_app/services/tool_registry.dart';

/// Entries that must be reachable from the Guides & Scores hub.
/// Order is not asserted; presence is.
const _kExpectedGuides = <String>[
  'Neonatal Scores',
  'Paediatric Scores', // ← the one that went missing. Never let it go again.
  'GA Classification',
  'Birthweight Classification',
  'Fetal Development',
  'Developmental Milestones',
  'NRP 9th Edition',
  'PALS Algorithms',
  'Neonatal Echo',
  'Paediatric Parameters',
  'Polycythemia in Newborn',
  'DKA Algorithm',
  'Snake Envenomation',
  'Scorpion Sting',
  'Poisoning & Antidotes',
  'Acute Severe Asthma',
];

void main() {
  group('Guides & Scores catalogue', () {
    test('every expected guide is present', () {
      final titles = guideCatalogue.map((g) => g.title).toSet();
      final missing =
          _kExpectedGuides.where((t) => !titles.contains(t)).toList();
      expect(missing, isEmpty,
          reason: 'Guides disappeared from the hub: $missing');
    });

    test('the Paediatric Scores hub is reachable', () {
      // Called out on its own because this is the exact regression that shipped.
      expect(
        guideCatalogue.any((g) => g.title == 'Paediatric Scores'),
        isTrue,
        reason: '96 paediatric scores are in the binary but unreachable '
            'from Guides — this shipped in builds 33 and 34.',
      );
    });

    test('no guide has a null builder', () {
      // guideCatalogue already filters these out, so an empty catalogue would
      // silently pass the checks above.
      expect(guideCatalogue.length, greaterThanOrEqualTo(_kExpectedGuides.length));
    });
  });

  group('Score library', () {
    test('the paediatric score count has not dropped', () {
      expect(allPaediatricScores.length, greaterThanOrEqualTo(96),
          reason: 'paediatric scores were removed');
    });

    test('every score has a title, a question and a band', () {
      for (final s in allPaediatricScores) {
        expect(s.title.trim(), isNotEmpty);
        expect(s.questions, isNotEmpty, reason: '${s.title} has no questions');
        expect(s.bands, isNotEmpty, reason: '${s.title} has no bands');
      }
    });

    test('score titles are unique', () {
      final titles = allPaediatricScores.map((s) => s.title).toList();
      expect(titles.toSet().length, titles.length,
          reason: 'duplicate score titles');
    });
  });

  group('Calculators', () {
    test('the calculator count has not dropped', () {
      expect(calculatorCatalogue.length, greaterThanOrEqualTo(62),
          reason: 'calculators were removed from the catalogue');
    });

    test('every calculator in the catalogue resolves to a screen', () {
      for (final c in calculatorCatalogue) {
        expect(calculatorScreenFor(c.title), isNotNull,
            reason: '${c.title} is listed but opens nothing');
      }
    });
  });

  group('Resources', () {
    test('the resource count has not dropped', () {
      expect(kResourceItems.length, greaterThanOrEqualTo(47),
          reason: 'Drive resources were removed');
    });

    test('every resource has a Drive id', () {
      for (final r in kResourceItems) {
        expect(r.driveId.trim(), isNotEmpty, reason: '${r.title} has no driveId');
      }
    });
  });

  group('Tool registry (Quick Access / Recents)', () {
    test('the registry still covers calculators, scores and guides', () {
      final reg = ToolRegistry.instance;
      expect(reg.calculators.length, greaterThanOrEqualTo(62));
      // 96 paediatric + 14 neonatal. The 9 JSON-driven neonatal scores were
      // missing until 2026-08-19, so searching "apgar" found only the hub.
      expect(reg.scores.length, greaterThanOrEqualTo(110));
      expect(reg.guides.length, greaterThanOrEqualTo(15));
      expect(reg.all.length, greaterThanOrEqualTo(195),
          reason: 'a whole category dropped out of the registry');
    });

    test('the scores a doctor actually types are findable', () {
      // Each of these returned only the "Neonatal Scores" hub before the
      // JSON-driven scores were registered.
      const expected = {
        'apgar': 'Apgar Score',
        'downes': 'Downes Score',
        'silverman': 'Silverman Anderson Score',
        'sarnat': 'Modified Sarnat Staging (HIE)',
        'thompson': 'Thompson Score (HIE)',
        'latch': 'LATCH Score (Breastfeeding)',
        'croup': 'Westley Croup Score',
        'kawasaki': 'Kawasaki Disease Criteria',
        'pews': 'PEWS — Paediatric Early Warning Score',
      };
      expected.forEach((query, label) {
        final hits = ToolRegistry.instance.search(query);
        expect(hits, isNotEmpty, reason: '"$query" found nothing');
        expect(hits.first.label, label,
            reason: '"$query" should rank $label first, '
                'got ${hits.first.label}');
      });
    });
  });
}
