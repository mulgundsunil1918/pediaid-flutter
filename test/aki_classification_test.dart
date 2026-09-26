// =============================================================================
// test/aki_classification_test.dart
//
// The AKI tables.
//
// This file used to test a staging engine — the higher-of-two-axes rule, the
// neonatal 2.5 mg/dL threshold against the paediatric 4.0, the refusal to call
// an unmeasured child stage 0. That engine is gone (Sunil wanted the table
// alone, 26 Sep) and those tests went with it; they are in git at ba01ccb5.
//
// What is left is what can still be wrong: the published numbers themselves,
// and the two details a reader would not notice were missing — that the
// neonatal reference creatinine is the LOWEST PREVIOUS value rather than an
// admission baseline, and that its stage 3 threshold is 2.5 and not the adult
// 4.0. Both are the kind of thing that survives a careless edit unnoticed.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/guides/aki/aki_classification.dart';

void main() {
  group('the tables match the published ones', () {
    test('the KDIGO systems have four stages, pRIFLE five classes plus none',
        () {
      expect(kNeonatalKdigoTable.length, 4);
      expect(kKdigoTable.length, 4);
      expect(kPrifleTable.length, 6);
      expect(kPrifleTable.map((r) => r.label),
          ['No AKI', 'Risk', 'Injury', 'Failure', 'Loss', 'End-stage']);
    });

    test('every row carries both columns — neither may be left blank', () {
      for (final sys in AkiSystem.values) {
        for (final row in tableFor(sys)) {
          expect(row.creatinine.trim(), isNotEmpty,
              reason: '${sys.label} ${row.label}');
          expect(row.urineOutput.trim(), isNotEmpty,
              reason: '${sys.label} ${row.label}');
        }
      }
    });

    test('tableFor returns the right table for each system', () {
      expect(tableFor(AkiSystem.neonatalKdigo), same(kNeonatalKdigoTable));
      expect(tableFor(AkiSystem.kdigo), same(kKdigoTable));
      expect(tableFor(AkiSystem.prifle), same(kPrifleTable));
    });
  });

  group('the neonatal system is not the adult one with new numbers', () {
    test('its stage 3 creatinine threshold is 2.5, not 4.0', () {
      expect(kNeonatalKdigoTable[3].creatinine, contains('2.5'));
      expect(kNeonatalKdigoTable[3].creatinine, isNot(contains('4.0')));
      expect(kKdigoTable[3].creatinine, contains('4.0'));
    });

    test('its reference is the lowest previous value, and says so', () {
      expect(AkiSystem.neonatalKdigo.referenceRule, contains('LOWEST'));
      expect(kNeonatalKdigoTable[1].creatinine,
          contains('lowest previous value'));
      expect(AkiSystem.kdigo.referenceRule, contains('7 days'));
    });

    test('its urine bands differ from the paediatric ones', () {
      // Stage 1 neonatally is >0.5 and <1 mL/kg/h; beyond the newborn period
      // stage 1 does not begin until below 0.5.
      expect(kNeonatalKdigoTable[1].urineOutput, contains('< 1 mL/kg/h'));
      expect(kKdigoTable[1].urineOutput, contains('< 0.5 mL/kg/h'));
    });

    test('only the neonatal system is flagged neonatal', () {
      expect(AkiSystem.neonatalKdigo.isNeonatal, isTrue);
      expect(AkiSystem.kdigo.isNeonatal, isFalse);
      expect(AkiSystem.prifle.isNeonatal, isFalse);
    });
  });

  group('the reference is rendered, not merely declared', () {
    test('it names all four sources', () {
      for (final s in ['KDIGO', 'Jetton', 'Akcan-Arikan', 'Schwartz']) {
        expect(kAkiReference, contains(s), reason: s);
      }
    });

    test('it states the higher-of-two-axes rule', () {
      expect(kAkiReference, contains('higher of the creatinine and urine'));
    });
  });
}
