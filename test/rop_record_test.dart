// =============================================================================
// test/rop_record_test.dart
//
// Persistence (§63), change detection (§43) and export (§64).
//
// The rules worth pinning are the ones a reasonable implementation breaks by
// default: saving must never overwrite a previous examination, a corrupt
// record must not take the rest of the history with it, and a change
// comparison must not silently invert the direction of zone progression —
// more posterior is worse, more anterior is better, and the ranks run the
// other way round from the roman numerals.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pediaid_app/screens/rop/rop_exam.dart';
import 'package:pediaid_app/screens/rop/rop_followup.dart';
import 'package:pediaid_app/screens/rop/rop_record.dart';

EyeFindings _e(RopZone z, RopStage s, PlusStatus p, {int? hours, bool agg = false}) =>
    EyeFindings(zone: z, stage: s, plus: p, clockHours: hours, aggressive: agg);

RopRecord _r({
  required String id,
  required DateTime date,
  EyeFindings? right,
  EyeFindings? left,
  TreatmentRecord treatment = const TreatmentRecord(),
  String note = '',
  String? override,
  String ref = '',
}) =>
    RopRecord(
      id: id,
      examDate: date,
      protocolId: 'india',
      pma: '32+4',
      right: right ?? const EyeFindings(),
      left: left ?? right ?? const EyeFindings(),
      treatment: treatment,
      classification: 'Treatment-level disease not detected',
      followUp: '2 weeks',
      clinicianNote: note,
      overrideReason: override,
      patientRef: ref,
    );

void main() {
  // SharedPreferences' mock needs the binding up before setMockInitialValues
  // takes effect; without it every save silently no-ops and load() returns
  // an empty list, which looks exactly like a broken store.
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('Spec §63 — previous examinations are never overwritten', () {
    test('a second save appends rather than replacing', () async {
      final s = RopStore.instance;
      await s.save(_r(id: 'a', date: DateTime(2026, 8, 12)));
      await s.save(_r(id: 'b', date: DateTime(2026, 8, 19)));
      final all = await s.load();
      expect(all.length, 2);
      expect(all.map((r) => r.id), ['a', 'b']);
    });

    test('records come back in date order regardless of save order', () async {
      final s = RopStore.instance;
      await s.save(_r(id: 'late', date: DateTime(2026, 9, 2)));
      await s.save(_r(id: 'early', date: DateTime(2026, 8, 12)));
      final all = await s.load();
      expect(all.map((r) => r.id), ['early', 'late']);
    });

    test('saving the same id edits that record, not the newest', () async {
      final s = RopStore.instance;
      await s.save(_r(id: 'a', date: DateTime(2026, 8, 12), note: 'first'));
      await s.save(_r(id: 'b', date: DateTime(2026, 8, 19)));
      await s.save(_r(id: 'a', date: DateTime(2026, 8, 12), note: 'corrected'));
      final all = await s.load();
      expect(all.length, 2, reason: 'editing must not create a duplicate');
      expect(all.firstWhere((r) => r.id == 'a').clinicianNote, 'corrected');
    });
  });

  group('Round-trip fidelity', () {
    test('findings, treatment, note and override all survive', () async {
      final s = RopStore.instance;
      await s.save(_r(
        id: 'x',
        date: DateTime(2026, 8, 20),
        right: _e(RopZone.zoneII, RopStage.stage3, PlusStatus.plus, hours: 6),
        left: _e(RopZone.zoneIII, RopStage.none, PlusStatus.none),
        treatment: TreatmentRecord(
          type: RopTreatment.laser,
          date: DateTime(2026, 8, 21),
          reactivation: Reactivation.suspected,
          avascular: AvascularRetina.yes,
        ),
        note: 'Examined under indirect ophthalmoscopy.',
        override: 'institutional protocol',
        ref: 'Cot 4',
      ));
      final r = (await s.load()).single;
      expect(r.right.zone, RopZone.zoneII);
      expect(r.right.stage, RopStage.stage3);
      expect(r.right.plus, PlusStatus.plus);
      expect(r.right.clockHours, 6);
      expect(r.left.stage, RopStage.none);
      expect(r.treatment.type, RopTreatment.laser);
      expect(r.treatment.reactivation, Reactivation.suspected);
      expect(r.treatment.avascular, AvascularRetina.yes);
      // §62 — clinician text is never derived and never lost.
      expect(r.clinicianNote, 'Examined under indirect ophthalmoscopy.');
      expect(r.overrideReason, 'institutional protocol');
      expect(r.patientRef, 'Cot 4');
    });

    test('an unreadable record is skipped, not fatal', () async {
      SharedPreferences.setMockInitialValues({
        'rop_records_v1': [
          '{not valid json',
          '{"id":"ok","examDate":"2026-08-20T00:00:00.000","protocolId":"india"}',
        ],
      });
      final all = await RopStore.instance.load();
      expect(all.length, 1, reason: 'one bad row must not hide the history');
      expect(all.single.id, 'ok');
    });

    test('an unreadable eye reads as UNKNOWN, never as normal', () async {
      SharedPreferences.setMockInitialValues({
        'rop_records_v1': [
          '{"id":"z","examDate":"2026-08-20T00:00:00.000","right":{"zone":"nonsense"}}',
        ],
      });
      final r = (await RopStore.instance.load()).single;
      expect(r.right.zone, RopZone.unknown,
          reason: 'a record that cannot be read must not claim the eye was fine');
      expect(r.right.stage, RopStage.unknown);
      expect(r.right.plus, PlusStatus.unknown);
    });
  });

  group('Spec §43 — change detection is descriptive and directional', () {
    final d1 = DateTime(2026, 8, 12);
    final d2 = DateTime(2026, 8, 19);

    test('stage progression is named with both values', () {
      final c = detectChanges(
        _r(id: '1', date: d1, right: _e(RopZone.zoneII, RopStage.stage1, PlusStatus.none)),
        _r(id: '2', date: d2, right: _e(RopZone.zoneII, RopStage.stage2, PlusStatus.none)),
      );
      expect(c.any((x) => x.description.contains('Stage 1 → Stage 2')), isTrue);
      expect(c.first.severity, ChangeSeverity.progression);
    });

    test('new plus disease is urgent and shouted', () {
      final c = detectChanges(
        _r(id: '1', date: d1, right: _e(RopZone.zoneII, RopStage.stage2, PlusStatus.none)),
        _r(id: '2', date: d2, right: _e(RopZone.zoneII, RopStage.stage2, PlusStatus.plus)),
      );
      final plus = c.firstWhere((x) => x.description.contains('PLUS'));
      expect(plus.severity, ChangeSeverity.urgent);
    });

    test('zone direction is not inverted', () {
      // Zone II → Zone I is disease reaching further back: WORSE.
      final worse = detectChanges(
        _r(id: '1', date: d1, right: _e(RopZone.zoneII, RopStage.stage1, PlusStatus.none)),
        _r(id: '2', date: d2, right: _e(RopZone.zoneI, RopStage.stage1, PlusStatus.none)),
      );
      final w = worse.firstWhere((x) => x.description.contains('Zone'));
      expect(w.description, contains('more posterior'));
      expect(w.severity, ChangeSeverity.progression);

      // Zone II → Zone III is vessels growing outward: BETTER.
      final better = detectChanges(
        _r(id: '1', date: d1, right: _e(RopZone.zoneII, RopStage.stage1, PlusStatus.none)),
        _r(id: '2', date: d2, right: _e(RopZone.zoneIII, RopStage.stage1, PlusStatus.none)),
      );
      final b = better.firstWhere((x) => x.description.contains('Zone'));
      expect(b.description, contains('vascularisation progressed'));
      expect(b.severity, ChangeSeverity.improvement);
    });

    test('new ROP where there was none is reported as new, not as a step', () {
      final c = detectChanges(
        _r(id: '1', date: d1, right: _e(RopZone.zoneII, RopStage.none, PlusStatus.none)),
        _r(id: '2', date: d2, right: _e(RopZone.zoneII, RopStage.stage1, PlusStatus.none)),
      );
      expect(c.any((x) => x.description.contains('new ROP')), isTrue);
    });

    test('detachment and aggressive ROP are urgent', () {
      final det = detectChanges(
        _r(id: '1', date: d1, right: _e(RopZone.zoneII, RopStage.stage3, PlusStatus.none)),
        _r(id: '2', date: d2, right: _e(RopZone.zoneII, RopStage.stage4A, PlusStatus.none)),
      );
      expect(det.first.severity, ChangeSeverity.urgent);

      final agg = detectChanges(
        _r(id: '1', date: d1, right: _e(RopZone.zoneII, RopStage.stage2, PlusStatus.none)),
        _r(id: '2', date: d2, right: _e(RopZone.zoneII, RopStage.stage2, PlusStatus.none, agg: true)),
      );
      expect(agg.first.severity, ChangeSeverity.urgent);
    });

    test('reactivation is caught', () {
      final c = detectChanges(
        _r(id: '1', date: d1, right: _e(RopZone.zoneIII, RopStage.none, PlusStatus.none)),
        _r(id: '2', date: d2, right: _e(RopZone.zoneIII, RopStage.none, PlusStatus.none),
            treatment: const TreatmentRecord(reactivation: Reactivation.yes)),
      );
      expect(c.any((x) => x.description.toLowerCase().contains('reactivation')), isTrue);
    });

    test('no change says so rather than returning nothing', () {
      final same = _e(RopZone.zoneII, RopStage.stage1, PlusStatus.none);
      final c = detectChanges(
        _r(id: '1', date: d1, right: same),
        _r(id: '2', date: d2, right: same),
      );
      expect(c.length, 1);
      expect(c.single.description, contains('No change'));
      expect(c.single.severity, ChangeSeverity.neutral);
    });

    test('an unknown finding produces no change claim either way', () {
      // Going from "recorded" to "not recorded" is a documentation gap, not a
      // clinical improvement, and must not be reported as one.
      final c = detectChanges(
        _r(id: '1', date: d1, right: _e(RopZone.zoneII, RopStage.stage2, PlusStatus.plus)),
        _r(id: '2', date: d2, right: const EyeFindings()),
      );
      expect(c.any((x) => x.severity == ChangeSeverity.improvement), isFalse,
          reason: 'losing a finding is not an improvement');
    });
  });

  group('Spec §64 — export carries the clinical content', () {
    test('the timeline names every examination and its changes', () {
      final text = exportTimeline([
        _r(id: '1', date: DateTime(2026, 8, 12),
            right: _e(RopZone.zoneII, RopStage.none, PlusStatus.none), ref: 'Cot 4'),
        _r(id: '2', date: DateTime(2026, 8, 19),
            right: _e(RopZone.zoneII, RopStage.stage1, PlusStatus.none), ref: 'Cot 4'),
      ]);
      expect(text, contains('12 Aug 2026'));
      expect(text, contains('19 Aug 2026'));
      expect(text, contains('2 examinations'));
      expect(text, contains('Cot 4'));
      expect(text, contains('new ROP'), reason: 'changes belong in the export');
      expect(text, contains('not a substitute'),
          reason: 'the disclaimer travels with the text');
    });

    test('an empty history exports a sentence, not a broken document', () {
      expect(exportTimeline(const []), 'No ROP examinations recorded.');
    });
  });
}
