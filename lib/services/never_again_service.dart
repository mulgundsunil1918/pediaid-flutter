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

  Future<({List<NeverAgainPost> posts, int total, bool hasMore})> getPosts({
    String? category,
    int page = 1,
  }) async {
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

    return (
      posts: list,
      total: (body['total'] ?? 0) as int,
      hasMore: (body['hasMore'] ?? false) as bool,
    );
  }

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
    await http
        .post(
          Uri.parse('$_apiBase/api/never-again/$postId/flag'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({'device_id': deviceId}),
        )
        .timeout(const Duration(seconds: 15));
  }
}
