import 'dart:convert';
import 'package:flutter/services.dart';

class DrugEntry {
  final String name;
  final String nameLower;
  final int page;
  final String source;

  const DrugEntry({
    required this.name,
    required this.nameLower,
    required this.page,
    required this.source,
  });

  factory DrugEntry.fromJson(Map<String, dynamic> json) {
    return DrugEntry(
      name: json['name'] as String? ?? '',
      nameLower: json['name_lower'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 1,
      source: json['source'] as String? ?? '',
    );
  }
}

class FormularyService {
  static final FormularyService _instance = FormularyService._internal();
  factory FormularyService() => _instance;
  FormularyService._internal();

  List<DrugEntry>? _neofaxCache;
  List<DrugEntry>? _harrietLaneCache;

  Future<void> _ensureLoaded() async {
    if (_neofaxCache != null) return;
    final raw = await rootBundle
        .loadString('assets/data/formulary/formulary_index_accurate.json');
    final Map<String, dynamic> data = json.decode(raw) as Map<String, dynamic>;

    _neofaxCache = (data['neofax'] as List<dynamic>)
        .map((e) => DrugEntry.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    _harrietLaneCache = (data['harriet_lane'] as List<dynamic>)
        .map((e) => DrugEntry.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name))
      ..removeWhere((d) {
        final n = d.name.trim().toLowerCase();
        return n == 'a/c' || n == 'a/d' || n == 'a/x';
      });
  }

  Future<List<DrugEntry>> getAllNeofax() async {
    await _ensureLoaded();
    return _neofaxCache!;
  }

  Future<List<DrugEntry>> getAllHarrietLane() async {
    await _ensureLoaded();
    return _harrietLaneCache!;
  }

  Future<List<DrugEntry>> searchNeofax(String query) async {
    final all = await getAllNeofax();
    if (query.isEmpty) return all;
    final q = query.toLowerCase();
    return all.where((d) => d.nameLower.contains(q)).toList();
  }

  Future<List<DrugEntry>> searchHarrietLane(String query) async {
    final all = await getAllHarrietLane();
    if (query.isEmpty) return all;
    final q = query.toLowerCase();
    return all.where((d) => d.nameLower.contains(q)).toList();
  }
}
