// =============================================================================
// rop/rop_record.dart
//
// Longitudinal ROP records: persistence (§63), change detection (§43) and the
// export text (§64).
//
// THREE RULES FROM THE SPEC SHAPE THIS FILE
//
// §63  "Do not overwrite previous examinations." Records are append-only from
//      the caller's point of view — saving produces a NEW record unless an id
//      is given explicitly, and the store never rewrites history on a
//      recalculation.
//
// §62  "Do not overwrite clinician-entered information when recalculating."
//      The free-text note and any override reason are stored on the record and
//      never derived, so nothing the engine computes can replace them.
//
// §65  Privacy: an identifier is OPTIONAL and free-form. No name, no phone, no
//      address. The module works on dates and clinical values alone, and an
//      infant is identified by whatever label the unit already uses.
// =============================================================================

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'rop_exam.dart';
import 'rop_followup.dart';

/// Enum lookup by name, falling back rather than throwing.
///
/// `T extends Enum` matters: `.name` is an EXTENSION on Enum, not an instance
/// member, so `(v as dynamic).name` throws NoSuchMethodError at runtime. That
/// bug made every stored record fail to parse and the whole history read as
/// empty — the store looked broken when only the decoder was.
T _byName<T extends Enum>(List<T> values, String? name, T fallback) {
  if (name == null) return fallback;
  for (final v in values) {
    if (v.name == name) return v;
  }
  return fallback;
}

/// One saved examination.
class RopRecord {
  /// Stable id. Generated from the save time; never reused.
  final String id;

  /// Optional label — a cot number, a hospital number, whatever the unit uses.
  /// Spec §65 forbids requiring anything identifying.
  final String patientRef;

  final DateTime examDate;
  final String protocolId;

  /// PMA at examination, stored as text because it is a display form
  /// ("32+4") and recomputing it later would need the birth date to still
  /// be present.
  final String? pma;

  final EyeFindings right;
  final EyeFindings left;
  final TreatmentRecord treatment;

  /// What the engine concluded, captured at save time. Kept rather than
  /// recomputed so the record shows what was actually acted on, even if a
  /// protocol is later corrected.
  final String classification;
  final String followUp;

  /// Free text (§62). Never derived, never overwritten.
  final String clinicianNote;

  /// Set when the clinician overrode the algorithm (§61).
  final String? overrideReason;

  const RopRecord({
    required this.id,
    required this.examDate,
    required this.protocolId,
    required this.right,
    required this.left,
    this.patientRef = '',
    this.pma,
    this.treatment = const TreatmentRecord(),
    this.classification = '',
    this.followUp = '',
    this.clinicianNote = '',
    this.overrideReason,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientRef': patientRef,
        'examDate': examDate.toIso8601String(),
        'protocolId': protocolId,
        'pma': pma,
        'right': _eyeToJson(right),
        'left': _eyeToJson(left),
        'treatment': {
          'type': treatment.type.name,
          'date': treatment.date?.toIso8601String(),
          'agent': treatment.agent,
          'regression': treatment.regression.name,
          'reactivation': treatment.reactivation.name,
          'avascular': treatment.avascular.name,
        },
        'classification': classification,
        'followUp': followUp,
        'clinicianNote': clinicianNote,
        'overrideReason': overrideReason,
      };

  static Map<String, dynamic> _eyeToJson(EyeFindings e) => {
        'zone': e.zone.name,
        'stage': e.stage.name,
        'plus': e.plus.name,
        'clockHours': e.clockHours,
        'aggressive': e.aggressive,
        'notch': e.notch,
      };

  static EyeFindings _eyeFromJson(Map<String, dynamic>? j) {
    if (j == null) return const EyeFindings();
    // Unknown on a failed lookup rather than a default finding: a record that
    // cannot be read must not claim the eye was normal.
    return EyeFindings(
      zone: _byName(RopZone.values, j['zone'] as String?, RopZone.unknown),
      stage: _byName(RopStage.values, j['stage'] as String?, RopStage.unknown),
      plus: _byName(PlusStatus.values, j['plus'] as String?, PlusStatus.unknown),
      clockHours: j['clockHours'] as int?,
      aggressive: j['aggressive'] as bool? ?? false,
      notch: j['notch'] as bool? ?? false,
    );
  }

  static RopRecord fromJson(Map<String, dynamic> j) {
    final t = (j['treatment'] as Map?)?.cast<String, dynamic>() ?? const {};
    return RopRecord(
      id: j['id'] as String,
      patientRef: j['patientRef'] as String? ?? '',
      examDate: DateTime.parse(j['examDate'] as String),
      protocolId: j['protocolId'] as String? ?? 'india',
      pma: j['pma'] as String?,
      right: _eyeFromJson((j['right'] as Map?)?.cast<String, dynamic>()),
      left: _eyeFromJson((j['left'] as Map?)?.cast<String, dynamic>()),
      treatment: TreatmentRecord(
        type: _byName(RopTreatment.values, t['type'] as String?, RopTreatment.none),
        date: t['date'] == null ? null : DateTime.tryParse(t['date'] as String),
        agent: t['agent'] as String?,
        regression: _byName(
            Regression.values, t['regression'] as String?, Regression.unknown),
        reactivation: _byName(
            Reactivation.values, t['reactivation'] as String?, Reactivation.no),
        avascular: _byName(AvascularRetina.values, t['avascular'] as String?,
            AvascularRetina.unableToDetermine),
      ),
      classification: j['classification'] as String? ?? '',
      followUp: j['followUp'] as String? ?? '',
      clinicianNote: j['clinicianNote'] as String? ?? '',
      overrideReason: j['overrideReason'] as String?,
    );
  }
}

/// Local, on-device storage. Nothing leaves the phone (§65).
class RopStore {
  RopStore._();
  static final RopStore instance = RopStore._();

  static const _key = 'rop_records_v1';

  Future<List<RopRecord>> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_key) ?? const [];
      final out = <RopRecord>[];
      for (final s in raw) {
        try {
          out.add(RopRecord.fromJson(
              jsonDecode(s) as Map<String, dynamic>));
        } catch (_) {
          // One unreadable record must not take the whole history with it.
          // Skipping it keeps every other examination visible.
        }
      }
      out.sort((a, b) => a.examDate.compareTo(b.examDate));
      return out;
    } catch (_) {
      return const [];
    }
  }

  /// Appends, or replaces the record with the same id.
  ///
  /// §63 forbids overwriting previous examinations, so a save with no matching
  /// id always adds rather than replacing the most recent one.
  Future<void> save(RopRecord r) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await load();
    final i = all.indexWhere((x) => x.id == r.id);
    if (i >= 0) {
      all[i] = r;
    } else {
      all.add(r);
    }
    await prefs.setStringList(
        _key, all.map((x) => jsonEncode(x.toJson())).toList());
  }

  Future<void> delete(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await load()
      ..removeWhere((x) => x.id == id);
    await prefs.setStringList(
        _key, all.map((x) => jsonEncode(x.toJson())).toList());
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

// ── Change detection (§43) ───────────────────────────────────────────────────

/// How a change should be presented. Descriptive, never a recommendation —
/// §43 says the comparison "should be descriptive and not replace clinical
/// judgment".
enum ChangeSeverity { improvement, neutral, progression, urgent }

class RopChange {
  final String description;
  final ChangeSeverity severity;
  const RopChange(this.description, this.severity);
}

/// Compares one eye between two examinations.
List<RopChange> _compareEye(String eye, EyeFindings was, EyeFindings now) {
  final out = <RopChange>[];

  // Detachment and aggressive ROP first — these change what happens today.
  if (!was.stage.isDetachment && now.stage.isDetachment) {
    out.add(RopChange('$eye: retinal detachment — ${now.stage.label}',
        ChangeSeverity.urgent));
  }
  if (!was.aggressive && now.aggressive) {
    out.add(RopChange('$eye: aggressive ROP newly documented',
        ChangeSeverity.urgent));
  }

  // Plus is the finding that most often flips treatment status.
  if (was.plus != now.plus &&
      now.plus != PlusStatus.unknown &&
      was.plus != PlusStatus.unknown) {
    if (now.plus.rank > was.plus.rank) {
      out.add(RopChange(
          '$eye: ${now.plus == PlusStatus.plus ? 'NEW PLUS DISEASE' : 'new pre-plus disease'}',
          now.plus == PlusStatus.plus
              ? ChangeSeverity.urgent
              : ChangeSeverity.progression));
    } else {
      out.add(RopChange('$eye: plus status improved to ${now.plus.label}',
          ChangeSeverity.improvement));
    }
  }

  // New ROP where there was none.
  if (was.stage == RopStage.none &&
      now.stage.rank > 0 &&
      now.stage != RopStage.unknown) {
    out.add(RopChange('$eye: new ROP — ${now.stage.label}',
        ChangeSeverity.progression));
  } else if (was.stage != now.stage &&
      was.stage != RopStage.unknown &&
      now.stage != RopStage.unknown) {
    final up = now.stage.rank > was.stage.rank;
    out.add(RopChange(
      '$eye: stage ${up ? 'increased' : 'decreased'} from '
      '${was.stage.label} → ${now.stage.label}',
      up ? ChangeSeverity.progression : ChangeSeverity.improvement,
    ));
  }

  // Zone. A LOWER rank is more anterior, which is vascular progression — the
  // direction is easy to invert, so it is spelled out.
  if (was.zone != now.zone &&
      was.zone != RopZone.unknown &&
      now.zone != RopZone.unknown) {
    if (now.zone.rank > was.zone.rank) {
      out.add(RopChange(
          '$eye: disease more posterior — ${was.zone.label} → ${now.zone.label}',
          ChangeSeverity.progression));
    } else {
      out.add(RopChange(
          '$eye: vascularisation progressed — ${was.zone.label} → ${now.zone.label}',
          ChangeSeverity.improvement));
    }
  }

  final wh = was.clockHours, nh = now.clockHours;
  if (wh != null && nh != null && nh != wh) {
    out.add(RopChange(
      '$eye: extent ${nh > wh ? 'increased' : 'decreased'} from $wh → $nh clock hours',
      nh > wh ? ChangeSeverity.progression : ChangeSeverity.improvement,
    ));
  }

  return out;
}

/// Everything that changed between two examinations.
List<RopChange> detectChanges(RopRecord previous, RopRecord current) {
  final out = <RopChange>[
    ..._compareEye('Right', previous.right, current.right),
    ..._compareEye('Left', previous.left, current.left),
  ];

  if (previous.treatment.reactivation == Reactivation.no &&
      current.treatment.reactivation != Reactivation.no) {
    out.add(RopChange(
        'ROP reactivation ${current.treatment.reactivation.name}',
        ChangeSeverity.urgent));
  }
  if (previous.treatment.regression != current.treatment.regression &&
      current.treatment.regression != Regression.unknown) {
    out.add(RopChange('Regression: ${current.treatment.regression.name}',
        ChangeSeverity.improvement));
  }
  if (!previous.treatment.wasTreated && current.treatment.wasTreated) {
    out.add(RopChange('${current.treatment.type.label} performed',
        ChangeSeverity.neutral));
  }

  if (out.isEmpty) {
    out.add(const RopChange(
        'No change in recorded findings since the previous examination.',
        ChangeSeverity.neutral));
  }
  return out;
}

// ── Export (§64) ─────────────────────────────────────────────────────────────

String _d(DateTime d) {
  const m = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${d.day} ${m[d.month - 1]} ${d.year}';
}

/// The whole timeline as shareable text.
///
/// §64 says the summary should contain "only necessary clinical information",
/// so this carries findings, classification and follow-up — and the optional
/// reference only if the clinician set one.
String exportTimeline(List<RopRecord> records) {
  if (records.isEmpty) return 'No ROP examinations recorded.';
  final ref = records.last.patientRef;
  final b = StringBuffer()
    ..writeln('ROP EXAMINATION TIMELINE')
    ..writeln(ref.isEmpty ? '' : 'Reference: $ref')
    ..writeln('${records.length} examination'
        '${records.length == 1 ? '' : 's'}, '
        '${_d(records.first.examDate)} – ${_d(records.last.examDate)}')
    ..writeln();

  for (var i = 0; i < records.length; i++) {
    final r = records[i];
    b.writeln('${_d(r.examDate)}${r.pma == null ? '' : '  ·  PMA ${r.pma}'}');
    b.writeln('  Right: ${r.right.describe()}');
    b.writeln('  Left:  ${r.left.describe()}');
    if (r.classification.isNotEmpty) b.writeln('  ${r.classification}');
    if (r.followUp.isNotEmpty) b.writeln('  Follow-up: ${r.followUp}');
    if (r.treatment.wasTreated) b.writeln('  ${r.treatment.type.label}');
    if (r.overrideReason != null) {
      b.writeln('  Clinician override: ${r.overrideReason}');
    }
    if (r.clinicianNote.isNotEmpty) b.writeln('  Note: ${r.clinicianNote}');

    if (i > 0) {
      final changes = detectChanges(records[i - 1], r)
          .where((c) => c.severity != ChangeSeverity.neutral)
          .toList();
      for (final c in changes) {
        b.writeln('  → ${c.description}');
      }
    }
    b.writeln();
  }

  b.writeln('Generated by PediAid. Screening and documentation support only — '
      'not a substitute for examination by an ophthalmologist.');
  return b.toString();
}
