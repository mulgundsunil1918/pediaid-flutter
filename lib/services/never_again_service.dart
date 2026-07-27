// =============================================================================
// lib/services/never_again_service.dart
//
// HTTP client for the "Never Again" anonymous peer learning module.
// No auth required — all endpoints are public. Uses a locally-generated
// device_id (UUID v4 stored in SharedPreferences) for rate limiting,
// resonating, and flagging.
// =============================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'auth_service.dart';

const String _kDeviceIdKey = 'never_again_device_id';
const String _kResonatedKey = 'never_again_resonated_ids';

class NeverAgainPost {
  final int id;
  final String whatHappened;
  final String whatWentWrong;
  final String theLesson;
  final String category;
  final String? role;
  final int resonatedCount;
  final DateTime createdAt;

  const NeverAgainPost({
    required this.id,
    required this.whatHappened,
    required this.whatWentWrong,
    required this.theLesson,
    required this.category,
    this.role,
    required this.resonatedCount,
    required this.createdAt,
  });

  factory NeverAgainPost.fromJson(Map<String, dynamic> json) {
    return NeverAgainPost(
      id: json['id'] as int,
      whatHappened: (json['what_happened'] ?? '') as String,
      whatWentWrong: (json['what_went_wrong'] ?? '') as String,
      theLesson: (json['the_lesson'] ?? '') as String,
      category: (json['category'] ?? 'Other') as String,
      role: json['role'] as String?,
      resonatedCount: (json['resonated_count'] ?? 0) as int,
      createdAt: DateTime.tryParse(
            (json['created_at'] ?? '').toString(),
          ) ??
          DateTime.now(),
    );
  }
}

class NeverAgainService {
  NeverAgainService._();
  static final NeverAgainService instance = NeverAgainService._();

  String get _apiBase => AuthService.apiBase;
  String? _deviceId;
  Set<int> _resonatedIds = {};

  /// Initialise the device ID and restore resonated state from
  /// SharedPreferences. Call once on screen mount.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _deviceId = prefs.getString(_kDeviceIdKey);
    if (_deviceId == null || _deviceId!.isEmpty) {
      _deviceId = const Uuid().v4();
      await prefs.setString(_kDeviceIdKey, _deviceId!);
    }
    final saved = prefs.getStringList(_kResonatedKey) ?? [];
    _resonatedIds = saved.map((s) => int.tryParse(s) ?? -1).where((i) => i >= 0).toSet();
  }

  String get deviceId => _deviceId ?? '';

  bool isResonated(int postId) => _resonatedIds.contains(postId);

  Future<void> _persistResonated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _kResonatedKey,
      _resonatedIds.map((i) => i.toString()).toList(),
    );
  }

  // -------------------------------------------------------------------------
  // GET posts
  // -------------------------------------------------------------------------

  bool _usingPreview = false;
  bool get usingPreview => _usingPreview;

  Future<({List<NeverAgainPost> posts, int total, bool hasMore})> getPosts({
    String? category,
    int page = 1,
  }) async {
    try {
      final params = <String, String>{
        'page': page.toString(),
        'limit': '20',
      };
      if (category != null && category != 'All') {
        params['category'] = category;
      }
      final uri = Uri.parse('$_apiBase/api/never-again').replace(queryParameters: params);
      final res = await http.get(uri).timeout(const Duration(seconds: 20));

      if (res.statusCode != 200) {
        throw Exception('Failed to load posts (${res.statusCode})');
      }

      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final list = (body['posts'] as List? ?? [])
          .cast<Map<String, dynamic>>()
          .map(NeverAgainPost.fromJson)
          .toList();

      _usingPreview = false;
      return (
        posts: list,
        total: (body['total'] ?? 0) as int,
        hasMore: (body['hasMore'] ?? false) as bool,
      );
    } catch (_) {
      _usingPreview = true;
      final all = _previewPosts;
      final filtered = (category != null && category != 'All')
          ? all.where((p) => p.category == category).toList()
          : all;
      return (posts: filtered, total: filtered.length, hasMore: false);
    }
  }

  static final List<NeverAgainPost> _previewPosts = [
    NeverAgainPost(
      id: -1,
      whatHappened: 'A preterm neonate (32 weeks, 1.4 kg) was started on IV fluids. The resident calculated the fluid rate using full-term neonatal values instead of adjusting for prematurity and insensible losses.',
      whatWentWrong: "The infant received significantly less fluid than needed. By hour 12, serum sodium was 158 mEq/L with rising urea. The error was caught on the next shift’s labs.",
      theLesson: 'Always use gestational-age-adjusted fluid calculations for preterms. Day 1 fluids for a 32-weeker start at ~80 mL/kg/day, not the 60 mL/kg/day used for term babies. Double-check with a senior before writing the first fluid order on any preterm.',
      category: 'Fluids & Electrolytes',
      role: 'Resident',
      resonatedCount: 24,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    NeverAgainPost(
      id: -2,
      whatHappened: 'A 3-day-old neonate with worsening jaundice was being monitored with serial bilirubin levels. The TSB came back at 22 mg/dL (380 µmol/L). The on-call resident decided to start phototherapy and "recheck in 6 hours" without plotting the value on the Bhutani nomogram.',
      whatWentWrong: 'At that bilirubin level and rate of rise, the baby had crossed the exchange transfusion threshold. A 6-hour delay meant the bilirubin peaked at 28 mg/dL before the exchange was finally initiated. The baby required NICU admission.',
      theLesson: 'Every elevated bilirubin MUST be plotted on the hour-specific nomogram, not just compared to a single cut-off. The decision is exchange vs phototherapy, not "start phototherapy and hope." When in doubt, call the senior — a phone call takes 30 seconds, an exchange transfusion delay can cause kernicterus.',
      category: 'Jaundice',
      role: 'Senior Resident',
      resonatedCount: 41,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    NeverAgainPost(
      id: -3,
      whatHappened: 'A 2-month-old presented to the emergency department with fever, irritability, and poor feeding for 24 hours. The resident performed a septic screen (CBC, CRP, blood culture) and started empiric antibiotics. Lumbar puncture was deferred because the baby "looked okay" and the parents were anxious about the procedure.',
      whatWentWrong: 'Blood culture grew Group B Streptococcus. CSF obtained 48 hours later (after partial treatment) showed elevated protein and pleocytosis — probable meningitis. The child needed a prolonged antibiotic course and follow-up MRI showed a small area of cerebral infarction.',
      theLesson: 'In a febrile infant under 3 months, LP is not optional — it is part of the standard septic workup. Parental anxiety is understandable but must be addressed with explanation, not by skipping a critical diagnostic step. Partially treated meningitis is harder to diagnose and treat.',
      category: 'Sepsis & Infection',
      role: 'Fellow',
      resonatedCount: 56,
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
    NeverAgainPost(
      id: -4,
      whatHappened: 'An infant was prescribed oral phenobarbitone syrup at 5 mg/kg/day. The syrup concentration was 20 mg/5mL. The nurse calculated the dose volume but accidentally used the concentration of a different formulation (15 mg/5mL) that was also in the medication cupboard.',
      whatWentWrong: 'The baby received approximately 33% more phenobarbitone than prescribed for two doses before the error was caught during a routine medication reconciliation. The infant became excessively drowsy and required monitoring.',
      theLesson: 'Always verify the exact concentration on the bottle in hand, not from memory. Read the label three times: when picking it up, when drawing it, and before administering. Two formulations of the same drug with different concentrations should never be stored side by side.',
      category: 'Medications & Dosing',
      role: 'Nurse',
      resonatedCount: 33,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    NeverAgainPost(
      id: -5,
      whatHappened: 'During neonatal resuscitation of a meconium-stained baby, the team initially attempted to suction the trachea via intubation before starting positive pressure ventilation, following older guidelines. The intubation attempt took over 45 seconds.',
      whatWentWrong: 'The prolonged intubation attempt delayed effective ventilation. The baby developed severe bradycardia (HR < 60) requiring chest compressions. Post-resuscitation, the infant had poor tone and required therapeutic hypothermia evaluation.',
      theLesson: 'NRP 8th edition (2021) changed the approach: do NOT routinely intubate for tracheal suction in meconium-stained non-vigorous neonates. Begin PPV immediately. Suctioning under direct vision only if the airway is obstructed. Keeping up with guideline updates saves lives — pin the latest algorithm in every delivery room.',
      category: 'Resuscitation',
      role: 'Consultant',
      resonatedCount: 62,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  // -------------------------------------------------------------------------
  // POST new post
  // -------------------------------------------------------------------------

  Future<void> submitPost({
    required String whatHappened,
    required String whatWentWrong,
    required String theLesson,
    required String category,
    String? role,
  }) async {
    final res = await http
        .post(
          Uri.parse('$_apiBase/api/never-again'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({
            'what_happened': whatHappened,
            'what_went_wrong': whatWentWrong,
            'the_lesson': theLesson,
            'category': category,
            'role': role,
            'device_id': deviceId,
          }),
        )
        .timeout(const Duration(seconds: 20));

    if (res.statusCode == 429) {
      throw Exception("You've reached today's posting limit.");
    }
    if (res.statusCode != 201) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      throw Exception(body['message'] ?? 'Failed to submit post.');
    }
  }

  // -------------------------------------------------------------------------
  // Toggle resonate
  // -------------------------------------------------------------------------

  Future<({bool resonated, int newCount})> toggleResonate(int postId) async {
    if (postId < 0) return (resonated: false, newCount: 0);
    final res = await http
        .post(
          Uri.parse('$_apiBase/api/never-again/$postId/resonate'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({'device_id': deviceId}),
        )
        .timeout(const Duration(seconds: 15));

    if (res.statusCode != 200) {
      throw Exception('Failed to resonate.');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final resonated = body['resonated'] as bool;
    final newCount = body['new_count'] as int;

    if (resonated) {
      _resonatedIds.add(postId);
    } else {
      _resonatedIds.remove(postId);
    }
    _persistResonated();

    return (resonated: resonated, newCount: newCount);
  }

  // -------------------------------------------------------------------------
  // Flag
  // -------------------------------------------------------------------------

  Future<void> flagPost(int postId) async {
    if (postId < 0) return;
    await http
        .post(
          Uri.parse('$_apiBase/api/never-again/$postId/flag'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({'device_id': deviceId}),
        )
        .timeout(const Duration(seconds: 15));
  }
}
