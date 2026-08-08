// =============================================================================
// lib/services/academics_search_service.dart
//
// Searches the Academics library — landmark trials, guideline notes and
// reviews, and CME events — so one search box covers the whole app rather
// than only what ships inside it.
//
// Public on purpose: none of these need an account to read, so results appear
// whether or not someone is signed in. Failures are swallowed and return an
// empty list; Academics results are an addition to local search, and a dead
// network must never take the search screen down with it.
// =============================================================================

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

enum AcademicsHitKind { trial, note, event }

class AcademicsHit {
  const AcademicsHit({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.path,
  });

  final AcademicsHitKind kind;
  final String title;

  /// One line of context — the journal and year, the society, the event type.
  final String subtitle;

  /// Path inside the Academics site, e.g. `/trials/neonatology/feast`.
  /// AcademicsWebScreen prefixes the origin and appends the sign-in handoff.
  final String path;

  String get kindLabel => switch (kind) {
        AcademicsHitKind.trial => 'Trial',
        AcademicsHitKind.note => 'Guide',
        AcademicsHitKind.event => 'Event',
      };
}

class AcademicsSearchService {
  AcademicsSearchService._();
  static final AcademicsSearchService instance = AcademicsSearchService._();

  String get _base => AuthService.apiBase;

  /// Cache per query string. The search screen rebuilds on every keystroke,
  /// and a FutureBuilder without this would fire a fresh request each frame.
  final Map<String, List<AcademicsHit>> _cache = {};

  Future<List<AcademicsHit>> search(String query) async {
    final q = query.trim();
    if (q.length < 2) return const [];
    final cached = _cache[q.toLowerCase()];
    if (cached != null) return cached;

    // Three independent requests, and one failing must not lose the other
    // two — hence per-request error handling rather than a single try.
    final results = await Future.wait([
      _trials(q),
      _notes(q),
      _events(q),
    ]);

    final hits = [for (final r in results) ...r];
    _cache[q.toLowerCase()] = hits;
    return hits;
  }

  Future<List<dynamic>> _get(String path, String key) async {
    try {
      final res = await http
          .get(Uri.parse('$_base$path'))
          .timeout(const Duration(seconds: 12));
      if (res.statusCode != 200) return const [];
      final body = jsonDecode(res.body);
      if (body is! Map<String, dynamic>) return const [];
      final list = body[key];
      return list is List ? list : const [];
    } catch (_) {
      return const [];
    }
  }

  String _s(Map<String, dynamic> m, String k) {
    final v = m[k];
    return v == null ? '' : v.toString();
  }

  Future<List<AcademicsHit>> _trials(String q) async {
    final rows = await _get(
      '/api/academics/trials?q=${Uri.encodeQueryComponent(q)}',
      'trials',
    );
    return rows.whereType<Map<String, dynamic>>().map((t) {
      final acronym = _s(t, 'acronym');
      final journal = _s(t, 'journal');
      final year = _s(t, 'year');
      final meta = [journal, year].where((e) => e.isNotEmpty).join(' ');
      return AcademicsHit(
        kind: AcademicsHitKind.trial,
        title: acronym.isNotEmpty ? '$acronym — ${_s(t, 'title')}' : _s(t, 'title'),
        subtitle: meta.isNotEmpty ? meta : _s(t, 'subtitle'),
        // Detail route is /trials/:specialty/:slug — both segments required,
        // or the link resolves to nothing.
        path: '/trials/${_s(t, 'specialty')}/${_s(t, 'slug')}',
      );
    }).toList();
  }

  Future<List<AcademicsHit>> _notes(String q) async {
    final rows = await _get(
      '/api/academics/guideline-notes?q=${Uri.encodeQueryComponent(q)}',
      'notes',
    );
    return rows.whereType<Map<String, dynamic>>().map((n) {
      final society = _s(n, 'society');
      final year = _s(n, 'guidelineYear');
      final meta = [society, year].where((e) => e.isNotEmpty).join(' · ');
      return AcademicsHit(
        kind: AcademicsHitKind.note,
        title: _s(n, 'title'),
        subtitle: meta.isNotEmpty ? meta : _s(n, 'subtitle'),
        path: '/guideline-notes/${_s(n, 'slug')}',
      );
    }).toList();
  }

  Future<List<AcademicsHit>> _events(String q) async {
    // Note the envelope key here is `data`, not the resource name the other
    // two use.
    final rows = await _get(
      '/api/academics/cme/events?q=${Uri.encodeQueryComponent(q)}',
      'data',
    );
    return rows.whereType<Map<String, dynamic>>().map((e) {
      final type = _s(e, 'eventType');
      final venue = _s(e, 'venue');
      final meta = [
        if (type.isNotEmpty) type[0].toUpperCase() + type.substring(1),
        if (venue.isNotEmpty) venue else 'Online',
      ].join(' · ');
      return AcademicsHit(
        kind: AcademicsHitKind.event,
        title: _s(e, 'title'),
        subtitle: meta,
        path: '/cme/${_s(e, 'slug')}',
      );
    }).toList();
  }
}
