// =============================================================================
// lib/services/bookmarks_service.dart
//
// Saved items, shared with the web app through the same account.
//
// Unlike SubmissionsService there is no device_id fallback here: a bookmark is
// per account by design, so it follows someone from their phone to the ward
// computer. Signed out there is nothing to fetch, and saying so is more useful
// than returning an empty list that looks like "you saved nothing".
// =============================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class Bookmark {
  const Bookmark({
    required this.itemType,
    required this.itemId,
    required this.title,
    this.subtitle,
    this.tag,
    this.linkPath,
  });

  final String itemType;
  final String itemId;
  final String title;
  final String? subtitle;
  final String? tag;
  final String? linkPath;

  /// Reader-facing label for the type chip. Unknown types degrade to the raw
  /// value rather than throwing, so a module added on the web does not need an
  /// app release before its saved items can be listed.
  String get typeLabel {
    switch (itemType) {
      case 'trial':
        return 'Trial';
      case 'guide':
        return 'Guide';
      case 'cme':
        return 'Event';
      case 'chapter':
        return 'Chapter';
      case 'stg':
        return 'Guideline';
      default:
        return itemType;
    }
  }

  factory Bookmark.fromJson(Map<String, dynamic> j) => Bookmark(
        itemType: j['itemType'] as String? ?? 'other',
        itemId: j['itemId'] as String? ?? '',
        title: j['title'] as String? ?? 'Untitled',
        subtitle: j['subtitle'] as String?,
        tag: j['tag'] as String?,
        linkPath: j['linkPath'] as String?,
      );
}

class BookmarksResult {
  const BookmarksResult({required this.bookmarks, required this.tags});
  final List<Bookmark> bookmarks;
  final List<String> tags;
}

/// Thrown when the caller is signed out, so the screen can offer sign-in
/// instead of showing an empty list.
class NotSignedInException implements Exception {
  const NotSignedInException();
}

class BookmarksService {
  BookmarksService._();
  static final BookmarksService instance = BookmarksService._();

  String get _apiBase => AuthService.apiBase;

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<BookmarksResult> getSaved() async {
    final token = AuthService.instance.accessToken;
    if (token == null) throw const NotSignedInException();

    final res = await http
        .get(Uri.parse('$_apiBase/api/academics/bookmarks'), headers: _headers(token))
        .timeout(const Duration(seconds: 20));

    if (res.statusCode == 401) throw const NotSignedInException();
    if (res.statusCode != 200) {
      throw Exception('Could not load your saved items (${res.statusCode}).');
    }

    // Defensive decode: a truncated or HTML response (a proxy error page, say)
    // should read as "could not load", not as a raw FormatException.
    late final Map<String, dynamic> body;
    try {
      body = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      throw Exception('Could not read the response from the server.');
    }

    final marks = (body['bookmarks'] as List? ?? [])
        .cast<Map<String, dynamic>>()
        .map(Bookmark.fromJson)
        .toList();
    final tags = (body['tags'] as List? ?? []).map((t) => t.toString()).toList();
    return BookmarksResult(bookmarks: marks, tags: tags);
  }

  /// Removes one saved item. Idempotent on the server, so a double tap or a
  /// retry cannot put it back.
  Future<void> remove(String itemType, String itemId) async {
    final token = AuthService.instance.accessToken;
    if (token == null) throw const NotSignedInException();

    final res = await http
        .delete(
          Uri.parse(
            '$_apiBase/api/academics/bookmarks/$itemType/${Uri.encodeComponent(itemId)}',
          ),
          headers: _headers(token),
        )
        .timeout(const Duration(seconds: 20));

    if (res.statusCode != 200) {
      throw Exception('Could not remove that item (${res.statusCode}).');
    }
  }
}
