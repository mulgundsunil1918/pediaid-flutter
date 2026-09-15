// =============================================================================
// test/bell_nec_staging_test.dart
//
// Modified Bell's staging for NEC.
//
// The error this file mostly guards against is the one the rest of the hub
// invites: treating Bell's like the additive scores around it. IIB is not "more
// points than IIA", it is a different clinical picture, and a total would mean
// nothing. So these test the ORDERING and the refusals, not arithmetic.
//
// The other theme is that no findings must never read as stage IA. An infant
// nobody has examined is not a suspected-NEC infant.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/guides/neonatal_scores/bell_nec_staging.dart';

void main() {
  group('a single decisive finding establishes its stage', () {
    test('pneumoperitoneum is IIIB — one radiograph settles it', () {
      final r = stageNec({'pneumoperitoneum'});
      expect(r.stage, BellStage.iiib);
      expect(r.stage!.classification,
          'Advanced, severely ill, perforated bowel');
      expect(r.stage!.treatment, contains('surgery'));
    });

    test('pneumatosis intestinalis is IIA — definite, not suspected', () {
      expect(stageNec({'pneumatosis'}).stage, BellStage.iia);
    });

    test('ascites is IIB', () {
      expect(stageNec({'ascites'}).stage, BellStage.iib);
    });

    test('grossly bloody stool is IB', () {
      expect(stageNec({'grossly_bloody_stool'}).stage, BellStage.ib);
    });

    test('hypotension or DIC is IIIA', () {
      expect(stageNec({'hypotension'}).stage, BellStage.iiia);
      expect(stageNec({'dic'}).stage, BellStage.iiia);
    });
  });

  group('the highest stage present wins, because the table is cumulative', () {
    test('IA findings plus pneumatosis is IIA, not IA', () {
      final r = stageNec({'apnea', 'distention', 'pneumatosis'});
      expect(r.stage, BellStage.iia);
      expect(r.deciding.map((f) => f.id), contains('pneumatosis'));
    });

    test('a very sick infant with perforation is IIIB, not IIIA', () {
      final r = stageNec({
        'hypotension', 'dic', 'neutropenia', 'peritonitis',
        'ascites', 'pneumatosis', 'pneumoperitoneum',
      });
      expect(r.stage, BellStage.iiib);
    });

    test('order of selection does not change the answer', () {
      final a = stageNec({'pneumoperitoneum', 'apnea'});
      final b = stageNec({'apnea', 'pneumoperitoneum'});
      expect(a.stage, b.stage);
    });

    test('the deciding findings name only the stage that was reached', () {
      final r = stageNec({'apnea', 'pneumatosis', 'ascites'});
      expect(r.stage, BellStage.iib);
      expect(r.deciding.every((f) => f.stage == BellStage.iib), isTrue,
          reason: 'showing IA findings as the reason for IIB would mislead');
    });
  });

  group('"with or without" findings cannot raise a stage on their own', () {
    test('abdominal tenderness alone establishes nothing', () {
      // The table qualifies it "with or without absent bowel sounds", so it
      // supports the picture and does not define IIA.
      final r = stageNec({'abdominal_tenderness'});
      expect(r.stage, isNull);
      expect(r.supporting.map((f) => f.id), contains('abdominal_tenderness'));
      expect(r.message, contains('with or without'));
    });

    test('cellulitis or an RLQ mass alone establishes nothing', () {
      expect(stageNec({'cellulitis_or_rlq_mass'}).stage, isNull);
    });

    test('but they are reported alongside a stage that IS established', () {
      final r = stageNec({'pneumatosis', 'abdominal_tenderness'});
      expect(r.stage, BellStage.iia);
      expect(r.supporting.map((f) => f.id), contains('abdominal_tenderness'));
    });
  });

  group('nothing recorded is not stage IA', () {
    test('an empty selection has no stage and says why', () {
      final r = stageNec(const {});
      expect(r.stage, isNull);
      expect(r.deciding, isEmpty);
      expect(r.message, contains('no findings is not the same as stage IA'));
    });

    test('an unrecognised id is ignored rather than guessed at', () {
      expect(stageNec({'not_a_finding'}).stage, isNull);
    });
  });

  group('the classification is not a score', () {
    test('rank orders the stages but is never presented as a total', () {
      final ranks = BellStage.values.map((s) => s.rank).toList();
      expect(ranks, [0, 1, 2, 3, 4, 5]);
      expect(BellStage.iiib.rank, greaterThan(BellStage.ia.rank));
    });

    test('the reference says explicitly that stages are not added', () {
      expect(kBellReference, contains('not a scoring system'));
      expect(kBellReference, contains('Walsh'));
      expect(kBellReference, contains('1986'));
    });

    test('every stage carries a treatment, as the source states it', () {
      for (final s in BellStage.values) {
        expect(s.treatment.trim(), isNotEmpty, reason: s.code);
        expect(s.treatment, contains('NPO'), reason: s.code);
      }
      expect(BellStage.ia.treatment, contains('3 days'));
      expect(BellStage.iia.treatment, contains('7 to 10 days'));
      expect(BellStage.iib.treatment, contains('14 days'));
      expect(BellStage.iiib.treatment, contains('surgery'));
    });

    test('only IIIA and IIIB are flagged advanced', () {
      expect(BellStage.iiia.isAdvanced, isTrue);
      expect(BellStage.iiib.isAdvanced, isTrue);
      expect(BellStage.iib.isAdvanced, isFalse);
    });
  });

  group('the table matches the published one', () {
    test('six rows, in order', () {
      expect(kBellTable.length, 6);
      expect(kBellTable.map((r) => r.stage.code),
          ['IA', 'IB', 'IIA', 'IIB', 'IIIA', 'IIIB']);
    });

    test('stage IA radiographic says MILD intestinal dilation', () {
      // The copy supplied dropped "mild"; the published table has it.
      expect(kBellTable.first.radiographic,
          'Normal or mild intestinal dilation, mild ileus');
    });

    test('the cumulative "same as above" wording is preserved', () {
      // Flattening it out would misrepresent how the classification works.
      expect(kBellTable[1].systemic, 'Same as above');
      expect(kBellTable[3].radiographic, contains('Same as IIA'));
      expect(kBellTable[5].radiographic, contains('pneumoperitoneum'));
    });

    test('every finding in the picker appears in the table it came from', () {
      // Guards against a finding drifting to the wrong stage.
      for (final f in kBellFindings) {
        expect(kBellTable.any((r) => r.stage == f.stage), isTrue,
            reason: '${f.id} claims stage ${f.stage.code}');
      }
      // And every stage has at least one decisive finding, or it could never
      // be reached from the picker.
      for (final s in BellStage.values) {
        expect(kBellFindings.any((f) => f.stage == s && f.decisive), isTrue,
            reason: 'stage ${s.code} is unreachable');
      }
    });
  });
}
