import 'dart:convert';
import 'package:flutter/services.dart';

// ── Data models ───────────────────────────────────────────────────────────────

class FentonDataPoint {
  final int ga;
  final double p3, p10, p50, p90, p97;

  const FentonDataPoint({
    required this.ga,
    required this.p3,
    required this.p10,
    required this.p50,
    required this.p90,
    required this.p97,
  });

  factory FentonDataPoint.fromJson(Map<String, dynamic> j) => FentonDataPoint(
        ga: j['ga'] as int,
        p3: (j['p3'] as num).toDouble(),
        p10: (j['p10'] as num).toDouble(),
        p50: (j['p50'] as num).toDouble(),
        p90: (j['p90'] as num).toDouble(),
        p97: (j['p97'] as num).toDouble(),
      );
}

class FentonParamData {
  final List<FentonDataPoint> weight;
  final List<FentonDataPoint> length;
  final List<FentonDataPoint> headCircumference;

  const FentonParamData({
    required this.weight,
    required this.length,
    required this.headCircumference,
  });
}

class FentonChartData {
  final String citation;
  final String version;
  final FentonParamData male;
  final FentonParamData female;

  const FentonChartData({
    required this.citation,
    required this.version,
    required this.male,
    required this.female,
  });
}

// ── Loader singleton ──────────────────────────────────────────────────────────

class FentonDataLoader {
  static final FentonDataLoader _instance = FentonDataLoader._();
  factory FentonDataLoader() => _instance;
  FentonDataLoader._();

  FentonChartData? _cache;

  Future<FentonChartData> load() async {
    if (_cache != null) return _cache!;
    final raw =
        await rootBundle.loadString('assets/data/fenton_data.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    _cache = _parse(json);
    return _cache!;
  }

  FentonChartData _parse(Map<String, dynamic> json) {
    List<FentonDataPoint> pts(dynamic list) => (list as List<dynamic>)
        .map((e) => FentonDataPoint.fromJson(e as Map<String, dynamic>))
        .toList();

    FentonParamData gender(Map<String, dynamic> g) => FentonParamData(
          weight: pts(g['weight']),
          length: pts(g['length']),
          headCircumference: pts(g['head_circumference']),
        );

    return FentonChartData(
      citation: json['citation'] as String,
      version: (json['meta'] as Map<String, dynamic>)['version'] as String,
      male: gender(json['data']['male'] as Map<String, dynamic>),
      female: gender(json['data']['female'] as Map<String, dynamic>),
    );
  }
}
