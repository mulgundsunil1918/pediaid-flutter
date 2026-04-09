// =============================================================================
// lib/services/admin_service.dart
//
// Admin-only HTTP client for the Flutter app. Provides pending lists and
// approve/reject actions for CMEs, chapter submissions, and role requests.
// Uses AuthService.instance.authHeaders — all endpoints require an admin
// JWT. Callers that expose these screens should gate on
// AuthService.instance.currentUser?.role == 'admin'.
// =============================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'cme_service.dart';

// ---------------------------------------------------------------------------
// Data classes
// ---------------------------------------------------------------------------

class AdminSummaryCounts {
  const AdminSummaryCounts({
    required this.cmesPending,
    required this.chaptersPending,
    required this.roleRequestsPending,
  });

  final int cmesPending;
  final int chaptersPending;
  final int roleRequestsPending;

  int get total => cmesPending + chaptersPending + roleRequestsPending;
}

class PendingRoleRequest {
  const PendingRoleRequest({
    required this.id,
    required this.userId,
    required this.email,
    required this.fullName,
    required this.requestedRole,
    required this.reason,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String email;
  final String? fullName;
  final String requestedRole;
  final String? reason;
  final DateTime? createdAt;

  factory PendingRoleRequest.fromJson(Map<String, dynamic> json) {
    return PendingRoleRequest(
      id: (json['id'] ?? '').toString(),
      userId: (json['user_id'] ?? json['userId'] ?? '').toString(),
      email: (json['user_email'] ?? json['email'] ?? '').toString(),
      fullName: (json['user_name'] ?? json['full_name']) as String?,
      requestedRole:
          (json['requested_role'] ?? json['requestedRole'] ?? 'author')
              .toString(),
      reason: json['reason'] as String?,
      createdAt: DateTime.tryParse(
        (json['created_at'] ?? json['createdAt'] ?? '').toString(),
      ),
    );
  }
}

class PendingChapterSubmission {
  const PendingChapterSubmission({
    required this.id,
    required this.title,
    required this.slug,
    required this.authorName,
    required this.authorEmail,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String slug;
  final String? authorName;
  final String? authorEmail;
  final DateTime? updatedAt;

  factory PendingChapterSubmission.fromJson(Map<String, dynamic> json) {
    return PendingChapterSubmission(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? 'Untitled').toString(),
      slug: (json['slug'] ?? '').toString(),
      authorName: (json['author_name'] ?? json['authorName']) as String?,
      authorEmail: (json['author_email'] ?? json['authorEmail']) as String?,
      updatedAt: DateTime.tryParse(
        (json['updated_at'] ?? json['updatedAt'] ?? '').toString(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AdminService singleton
// ---------------------------------------------------------------------------

class AdminService {
  AdminService._();
  static final AdminService instance = AdminService._();

  String get _apiBase => AuthService.apiBase;
  Map<String, String> get _headers => AuthService.instance.authHeaders;

  Uri _u(String path) => Uri.parse('$_apiBase/api/academics$path');

  // -------------------------------------------------------------------------
  // Pending CMEs
  // -------------------------------------------------------------------------

  Future<List<CmeEvent>> listPendingCmeEvents() async {
    final res = await http
        .get(_u('/admin/cme/pending'), headers: _headers)
        .timeout(const Duration(seconds: 30));
    if (res.statusCode != 200) {
      throw Exception(
        'Failed to load pending CMEs (${res.statusCode}).',
      );
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final list = (body['data'] as List? ?? [])
        .cast<Map<String, dynamic>>()
        .map(CmeEvent.fromJson)
        .toList();
    return list;
  }

  Future<void> approveCmeEvent(String eventId) async {
    final res = await http
        .put(_u('/admin/cme/$eventId/approve'), headers: _headers)
        .timeout(const Duration(seconds: 30));
    if (res.statusCode != 200) {
      throw Exception(_extractError(res, 'Approval failed'));
    }
  }

  Future<void> rejectCmeEvent(String eventId, String reason) async {
    final res = await http
        .put(
          _u('/admin/cme/$eventId/reject'),
          headers: _headers,
          body: jsonEncode({'reason': reason}),
        )
        .timeout(const Duration(seconds: 30));
    if (res.statusCode != 200) {
      throw Exception(_extractError(res, 'Rejection failed'));
    }
  }

  // -------------------------------------------------------------------------
  // Pending chapters
  // -------------------------------------------------------------------------

  Future<List<PendingChapterSubmission>> listPendingChapters() async {
    final res = await http
        .get(_u('/moderation/queue'), headers: _headers)
        .timeout(const Duration(seconds: 30));
    if (res.statusCode != 200) {
      throw Exception(
        'Failed to load pending chapters (${res.statusCode}).',
      );
    }
    final body = jsonDecode(res.body);
    final list = (body is Map<String, dynamic>
            ? (body['data'] ?? body['items'] ?? body['chapters']) as List?
            : body as List?) ??
        [];
    return list
        .cast<Map<String, dynamic>>()
        .map(PendingChapterSubmission.fromJson)
        .toList();
  }

  // -------------------------------------------------------------------------
  // Pending role requests
  // -------------------------------------------------------------------------

  Future<List<PendingRoleRequest>> listPendingRoleRequests() async {
    final res = await http
        .get(
          _u('/admin/role-requests?status=pending'),
          headers: _headers,
        )
        .timeout(const Duration(seconds: 30));
    if (res.statusCode != 200) {
      throw Exception(
        'Failed to load role requests (${res.statusCode}).',
      );
    }
    final body = jsonDecode(res.body);
    final list = (body is Map<String, dynamic>
            ? body['data'] as List?
            : body as List?) ??
        [];
    return list
        .cast<Map<String, dynamic>>()
        .map(PendingRoleRequest.fromJson)
        .toList();
  }

  Future<void> approveRoleRequest({
    required String userId,
    required String role, // 'author' | 'moderator'
  }) async {
    final res = await http
        .put(
          _u('/admin/users/$userId/approve-role'),
          headers: _headers,
          body: jsonEncode({'role': role}),
        )
        .timeout(const Duration(seconds: 30));
    if (res.statusCode != 200) {
      throw Exception(_extractError(res, 'Role approval failed'));
    }
  }

  Future<void> rejectRoleRequest(String userId) async {
    final res = await http
        .put(
          _u('/admin/users/$userId/reject-role'),
          headers: _headers,
        )
        .timeout(const Duration(seconds: 30));
    if (res.statusCode != 200) {
      throw Exception(_extractError(res, 'Role rejection failed'));
    }
  }

  // -------------------------------------------------------------------------
  // Summary counts — calls all three list endpoints in parallel
  // -------------------------------------------------------------------------

  Future<AdminSummaryCounts> getSummaryCounts() async {
    final results = await Future.wait<List<Object>>([
      listPendingCmeEvents().catchError((_) => <CmeEvent>[]),
      listPendingChapters().catchError((_) => <PendingChapterSubmission>[]),
      listPendingRoleRequests().catchError((_) => <PendingRoleRequest>[]),
    ]);
    return AdminSummaryCounts(
      cmesPending: results[0].length,
      chaptersPending: results[1].length,
      roleRequestsPending: results[2].length,
    );
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  String _extractError(http.Response res, String fallback) {
    try {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final msg = body['message'] as String?;
      if (msg != null && msg.isNotEmpty) return msg;
    } catch (_) {}
    return '$fallback (${res.statusCode}).';
  }
}
