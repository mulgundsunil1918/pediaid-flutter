import 'dart:convert';
import 'package:flutter/services.dart';

class VaccineEntry {
  final String type; // 'structured' | 'text_block'
  final String vaccine;
  final String dose;
  final String route;
  final String site;
  final String notes;
  final List<String> brands;
  final List<String> content; // for text_block type

  const VaccineEntry({
    required this.type,
    required this.vaccine,
    this.dose = '',
    this.route = '',
    this.site = '',
    this.notes = '',
    this.brands = const [],
    this.content = const [],
  });

  factory VaccineEntry.fromJson(Map<String, dynamic> json) => VaccineEntry(
        type: (json['type'] as String?) ?? 'structured',
        vaccine: (json['vaccine'] as String?) ?? '',
        dose: (json['dose'] as String?) ?? '',
        route: (json['route'] as String?) ?? '',
        site: (json['site'] as String?) ?? '',
        notes: (json['notes'] as String?) ?? '',
        brands: List<String>.from((json['brands'] as List?) ?? []),
        content: List<String>.from((json['content'] as List?) ?? []),
      );
}

class VaccineAgeGroup {
  final String age;
  final List<VaccineEntry> entries;

  const VaccineAgeGroup({required this.age, required this.entries});

  factory VaccineAgeGroup.fromJson(Map<String, dynamic> json) =>
      VaccineAgeGroup(
        age: json['age'] as String,
        entries: (json['entries'] as List<dynamic>)
            .map((e) => VaccineEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class VaccineSchedule {
  final String source;
  final List<VaccineAgeGroup> data;
  final List<String> notes;

  const VaccineSchedule(
      {required this.source, required this.data, required this.notes});

  factory VaccineSchedule.fromJson(Map<String, dynamic> json) =>
      VaccineSchedule(
        source: json['schedule_source'] as String,
        data: (json['data'] as List<dynamic>)
            .map((e) => VaccineAgeGroup.fromJson(e as Map<String, dynamic>))
            .toList(),
        notes: List<String>.from((json['notes'] as List?) ?? []),
      );
}

class VaccineService {
  static final VaccineService _instance = VaccineService._();
  factory VaccineService() => _instance;
  VaccineService._();

  VaccineSchedule? _iap;
  VaccineSchedule? _nis;

  Future<VaccineSchedule> loadIAP() async {
    _iap ??= VaccineSchedule.fromJson(
      jsonDecode(await rootBundle
          .loadString('assets/data/vaccines/iap_schedule.json')) as Map<String, dynamic>,
    );
    return _iap!;
  }

  Future<VaccineSchedule> loadNIS() async {
    _nis ??= VaccineSchedule.fromJson(
      jsonDecode(await rootBundle
          .loadString('assets/data/vaccines/nis_schedule.json')) as Map<String, dynamic>,
    );
    return _nis!;
  }
}
