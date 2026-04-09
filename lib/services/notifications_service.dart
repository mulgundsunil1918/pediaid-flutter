// =============================================================================
// lib/services/notifications_service.dart
//
// Thin HTTP client for the notification bell in the Flutter app header.
// Talks to GET/PUT /api/academics/notifications and uses the AuthService
// singleton for its Authorization header. Designed to be polled every 60s
// by NotificationBell's Timer.periodic.
// =============================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class PediaidNotification {
  final String id;
  final String title;
  final String message;
  final String type;
  final String? linkPath;
  final bool isRead;
  final DateTime createdAt;

  const PediaidNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.linkPath,
    required this.isRead,
    required this.createdAt,
  });

  factory PediaidNotification.fromJson(Map<String, dynamic> json) {
    return PediaidNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      linkPath: json['linkPath'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class NotificationListResult {
  final List<PediaidNotification> data;
  final int unreadCount;
  const NotificationListResult({required this.data, required this.unreadCount});
}

class NotificationsService {
  NotificationsService._();
  static final NotificationsService instance = NotificationsService._();

  String get _base => AuthService.apiBase;

  /// Fetch the current user's notifications + unread count. Returns an empty
  /// result (no throw) when the user isn't logged in — the bell is hidden in
  /// that case anyway.
  Future<NotificationListResult> list() async {
    final token = AuthService.instance.accessToken;
    if (token == null) {
      return const NotificationListResult(data: [], unreadCount: 0);
    }
    final res = await http
        .get(
          Uri.parse('$_base/api/academics/notifications'),
          headers: AuthService.instance.authHeaders,
        )
        .timeout(const Duration(seconds: 20));

    if (res.statusCode == 401) {
      // Token expired — force logout
      await AuthService.instance.logout();
      return const NotificationListResult(data: [], unreadCount: 0);
    }
    if (res.statusCode != 200) {
      throw Exception('Failed to load notifications (${res.statusCode})');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final data = (body['data'] as List<dynamic>? ?? [])
        .map((e) => PediaidNotification.fromJson(e as Map<String, dynamic>))
        .toList();
    final unreadCount = (body['unreadCount'] as num?)?.toInt() ?? 0;
    return NotificationListResult(data: data, unreadCount: unreadCount);
  }

  Future<void> markRead(String id) async {
    final token = AuthService.instance.accessToken;
    if (token == null) return;
    await http
        .put(
          Uri.parse('$_base/api/academics/notifications/$id/read'),
          headers: AuthService.instance.authHeaders,
        )
        .timeout(const Duration(seconds: 15));
  }

  Future<void> markAllRead() async {
    final token = AuthService.instance.accessToken;
    if (token == null) return;
    await http
        .put(
          Uri.parse('$_base/api/academics/notifications/read-all'),
          headers: AuthService.instance.authHeaders,
        )
        .timeout(const Duration(seconds: 15));
  }
}
