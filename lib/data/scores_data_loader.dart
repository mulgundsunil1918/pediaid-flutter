import 'dart:convert';
import 'package:flutter/services.dart';

// ── PHVD models ───────────────────────────────────────────────────────────────

class PhvdZone {
  final String name;
  final String ventricularHeader;
  final List<String> ventricularCriteria;
  final String ventricularConnector;
  final String clinicalHeader;   // "And" or "Or"
  final String clinicalNote;     // "Absence of..." or "Any of..."
  final List<String> clinicalCriteria;
  final List<String> management;

  const PhvdZone({
    required this.name,
    required this.ventricularHeader,
    required this.ventricularCriteria,
    required this.ventricularConnector,
    required this.clinicalHeader,
    required this.clinicalNote,
    required this.clinicalCriteria,
    required this.management,
  });
}

class PhvdData {
  final String title;
  final List<PhvdZone> zones;
  final String footer;
  final String reference;

  const PhvdData({
    required this.title,
    required this.zones,
    required this.footer,
    required this.reference,
  });
}

// ── Score subsection model ────────────────────────────────────────────────────

class ScoreSubsection {
  final String title;
  final List<Map<String, String>> parameters;
  const ScoreSubsection({required this.title, required this.parameters});
}

// ── Score model ───────────────────────────────────────────────────────────────

class NeonatalScore {
  final String name;
  final List<Map<String, String>> parameters;
  final List<ScoreSubsection> subsections;
  final List<Map<String, String>> interpretation;
  final String reference;

  /// Optional PHVD management zone data (IVH module only).
  final PhvdData? phvd;

  const NeonatalScore({
    required this.name,
    required this.parameters,
    this.subsections = const [],
    required this.interpretation,
    required this.reference,
    this.phvd,
  });
}

class NeonatalScoresData {
  final String category;
  final String description;
  final List<NeonatalScore> scores;

  const NeonatalScoresData({
    required this.category,
    required this.description,
    required this.scores,
  });
}

// ── Singleton loader ──────────────────────────────────────────────────────────

class ScoresDataLoader {
  static final ScoresDataLoader _instance = ScoresDataLoader._();
  ScoresDataLoader._();
  factory ScoresDataLoader() => _instance;

  NeonatalScoresData? _cache;

  Future<NeonatalScoresData> load() async {
    if (_cache != null) return _cache!;

    final raw  = await rootBundle.loadString('assets/data/nicu_scores.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;

    _cache = NeonatalScoresData(
      category:    json['category'] as String,
      description: json['description'] as String,
      scores: (json['scores'] as List<dynamic>).map((s) {
        final sm = s as Map<String, dynamic>;

        // Subsections
        final List<ScoreSubsection> subsections = [];
        if (sm['subsections'] != null) {
          for (final sub in sm['subsections'] as List<dynamic>) {
            final subMap = sub as Map<String, dynamic>;
            subsections.add(ScoreSubsection(
              title:      subMap['title'] as String,
              parameters: _parseRows(subMap['parameters']),
            ));
          }
        }

        // PHVD data
        PhvdData? phvd;
        if (sm['phvd'] != null) {
          final p = sm['phvd'] as Map<String, dynamic>;
          phvd = PhvdData(
            title:     p['title'] as String,
            footer:    p['footer'] as String,
            reference: p['reference'] as String,
            zones: (p['zones'] as List<dynamic>).map((z) {
              final zm = z as Map<String, dynamic>;
              return PhvdZone(
                name:                  zm['name'] as String,
                ventricularHeader:     zm['ventricular_header'] as String,
                ventricularCriteria:   List<String>.from(zm['ventricular_criteria']),
                ventricularConnector:  zm['ventricular_connector'] as String,
                clinicalHeader:        zm['clinical_header'] as String,
                clinicalNote:          zm['clinical_note'] as String,
                clinicalCriteria:      List<String>.from(zm['clinical_criteria']),
                management:            List<String>.from(zm['management']),
              );
            }).toList(),
          );
        }

        return NeonatalScore(
          name:           sm['name'] as String,
          parameters:     _parseRows(sm['parameters'] ?? []),
          subsections:    subsections,
          interpretation: _parseRows(sm['interpretation']),
          reference:      sm['reference'] as String,
          phvd:           phvd,
        );
      }).toList(),
    );

    return _cache!;
  }

  static List<Map<String, String>> _parseRows(dynamic list) {
    return (list as List<dynamic>).map((item) {
      final m = item as Map<String, dynamic>;
      return Map<String, String>.fromEntries(
        m.entries.map((e) => MapEntry(e.key, e.value.toString())),
      );
    }).toList();
  }
}
