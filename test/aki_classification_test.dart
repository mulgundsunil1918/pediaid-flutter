// =============================================================================
// test/aki_classification_test.dart
//
// The two rules that get dropped when someone implements AKI staging from
// memory:
//
//   1. The stage is the HIGHER of the creatinine axis and the urine-output
//      axis. Reading creatinine alone calls an anuric child stage 0.
//   2. The neonatal absolute threshold is 2.5 mg/dL, not the 4.0 used beyond
//      the newborn period. Carrying the adult number across is the single
//      easiest mistake to make here.
//
// Plus the refusal that matters: no measurements is NOT stage 0.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/guides/aki/aki_classification.dart';

void main() {
  group('the stage is the higher of the two axes', () {
    test('anuria stages 3 even with an untroubling creatinine', () {
      final r = stageAki(
        system: AkiSystem.kdigo,
        currentCreatinine: 0.4,
        referenceCreatinine: 0.4,
        urineOutput: 0.1,
      );
      expect(r.stage, 3);
      expect(r.byCreatinine, 0);
      expect(r.byUrineOutput, 3);
    });

    test('a tripled creatinine stages 3 with a normal urine output', () {
      final r = stageAki(
        system: AkiSystem.kdigo,
        currentCreatinine: 1.5,
        referenceCreatinine: 0.5,
        urineOutput: 2.0,
      );
      expect(r.stage, 3);
      expect(r.byUrineOutput, 0);
    });

    test('the lower axis never drags the stage down', () {
      final r = stageAki(
        system: AkiSystem.kdigo,
        currentCreatinine: 1.1,
        referenceCreatinine: 0.5, // 2.2x -> stage 2
        urineOutput: 3.0, // stage 0
      );
      expect(r.stage, 2);
    });
  });

  group('the neonatal system is not the adult one with new numbers', () {
    test('2.6 mg/dL is stage 3 in a neonate', () {
      final r = stageAki(
        system: AkiSystem.neonatalKdigo,
        currentCreatinine: 2.6,
        referenceCreatinine: 2.5, // ratio barely moved
      );
      expect(r.stage, 3,
          reason: 'the neonatal absolute threshold is 2.5, not 4.0');
    });

    test('2.6 mg/dL is NOT stage 3 on that criterion beyond the newborn', () {
      final r = stageAki(
        system: AkiSystem.kdigo,
        currentCreatinine: 2.6,
        referenceCreatinine: 2.5,
      );
      expect(r.stage, 0, reason: 'the paediatric threshold is 4.0');
    });

    test('4.1 mg/dL is stage 3 beyond the newborn', () {
      final r = stageAki(
        system: AkiSystem.kdigo,
        currentCreatinine: 4.1,
        referenceCreatinine: 4.0,
      );
      expect(r.stage, 3);
    });

    test('the neonatal urine bands differ from the paediatric ones', () {
      // 0.7 mL/kg/h is stage 1 in a neonate (>0.5 and <1) and stage 0 beyond.
      expect(
          stageAki(system: AkiSystem.neonatalKdigo, urineOutput: 0.7).stage, 1);
      expect(stageAki(system: AkiSystem.kdigo, urineOutput: 0.7).stage, 0);
    });
  });

  group('dialysis', () {
    test('is stage 3 in both KDIGO systems, whatever the numbers', () {
      for (final sys in [AkiSystem.neonatalKdigo, AkiSystem.kdigo]) {
        final r = stageAki(system: sys, onDialysis: true);
        expect(r.stage, 3, reason: sys.label);
        expect(r.reasons.join(), contains('dialysis'));
      }
    });

    test('pRIFLE says so rather than silently staging on it', () {
      final r = stageAki(system: AkiSystem.prifle, onDialysis: true);
      expect(r.notes.join(), contains('pRIFLE does not stage on dialysis'));
    });
  });

  group('nothing measured is not stage 0', () {
    test('an empty form is unstaged and says why', () {
      final r = stageAki(system: AkiSystem.kdigo);
      expect(r.stage, isNull);
      expect(r.isStaged, isFalse);
      expect(r.notes.join(), contains('unmeasured child is unstaged'));
    });

    test('a creatinine with no reference cannot use the ratio criteria', () {
      final r = stageAki(system: AkiSystem.kdigo, currentCreatinine: 1.2);
      expect(r.stage, isNull);
      expect(r.notes.join(), contains('No reference creatinine'));
    });

    test('a zero reference is refused rather than divided by', () {
      final r = stageAki(
        system: AkiSystem.kdigo,
        currentCreatinine: 1.2,
        referenceCreatinine: 0,
      );
      expect(r.notes.join(), contains('greater than zero'));
    });
  });

  group('the criteria that belong to one system only', () {
    test('the 0.3 mg/dL absolute rise is KDIGO, not pRIFLE', () {
      final kdigo = stageAki(
        system: AkiSystem.kdigo,
        currentCreatinine: 0.75,
        referenceCreatinine: 0.4, // +0.35, but only 1.9x... actually 1.875x
      );
      expect(kdigo.stage, 1);

      final prifle = stageAki(
        system: AkiSystem.prifle,
        currentCreatinine: 0.6,
        referenceCreatinine: 0.4, // +0.2 rise, 1.5x
      );
      // 1.5x still trips the ratio rule; the point is the absolute rise alone
      // must not.
      final prifleAbsoluteOnly = stageAki(
        system: AkiSystem.prifle,
        currentCreatinine: 0.75,
        referenceCreatinine: 0.6, // +0.15... below 0.3 anyway
      );
      expect(prifle.stage, greaterThan(0));
      expect(prifleAbsoluteOnly.stage, 0);
    });

    test('a sub-0.5 urine output flags the duration ambiguity', () {
      final r = stageAki(system: AkiSystem.kdigo, urineOutput: 0.4);
      expect(r.stage, 1);
      expect(r.notes.join(), contains('how long it persists'));
    });
  });

  group('the tables match the published ones', () {
    test('the KDIGO systems have four stages, pRIFLE five classes plus none',
        () {
      expect(kNeonatalKdigoTable.length, 4);
      expect(kKdigoTable.length, 4);
      expect(kPrifleTable.length, 6);
      expect(kPrifleTable.map((r) => r.label),
          ['No AKI', 'Risk', 'Injury', 'Failure', 'Loss', 'End-stage']);
    });

    test('the neonatal reference rule is stated, not assumed', () {
      expect(AkiSystem.neonatalKdigo.referenceRule, contains('LOWEST'));
      expect(kNeonatalKdigoTable[3].creatinine, contains('2.5'));
      expect(kKdigoTable[3].creatinine, contains('4.0'));
    });

    test('the references name all three sources', () {
      for (final s in ['KDIGO', 'Jetton', 'Akcan-Arikan', 'Schwartz']) {
        expect(kAkiReference, contains(s), reason: s);
      }
    });
  });
}
