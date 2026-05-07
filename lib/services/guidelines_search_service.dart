// =============================================================================
// services/guidelines_search_service.dart
//
// Pulls the three guideline-set indexes that the React Academics app already
// hosts (IAP STG 2022, IAP Action Plan 2026, NNF CPG) and exposes a fast
// in-memory search over the combined ~237 chapters. So when the user types
// "UTI" in the home search bar, the IAP STG UTI module shows up alongside
// any local matches.
//
// Caching strategy
//   - First call kicks off a parallel fetch of all three index JSONs
//     (small files: 12-58 KB each).
//   - Result is cached in SharedPreferences with a 7-day TTL.
//   - On subsequent app launches we hand back the cached list immediately
//     and refresh in the background — no spinner blocks the search UI.
//
// Search ranking
//   title.startsWith(q)  +5
//   title.contains(q)    +10
//   keywords.contains(q)  +5
//   section.contains(q)  +2
//
// Tap → external URL launcher (the chapter PDFs live on iapindia.org,
// nnfi.org and the pediaid-stg GitHub Pages site — all renderable by the
// system browser / Drive viewer / native PDF viewer).
// =============================================================================

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GuidelineSource {
  final String slug;
  final String shortName;
  final String fullName;
  /// Solid colour used for the source-of-truth dot on each result tile.
  final int colorArgb;
  final String indexUrl;

  const GuidelineSource({
    required this.slug,
    required this.shortName,
    required this.fullName,
    required this.colorArgb,
    required this.indexUrl,
  });
}

class GuidelineSearchHit {
  final String no;
  final String title;
  final String section;
  final List<String> keywords;
  /// Absolute URL to the chapter PDF.
  final String url;
  /// Source publication this chapter belongs to.
  final GuidelineSource source;

  const GuidelineSearchHit({
    required this.no,
    required this.title,
    required this.section,
    required this.keywords,
    required this.url,
    required this.source,
  });
}

class GuidelinesSearchService {
  GuidelinesSearchService._();
  static final GuidelinesSearchService instance = GuidelinesSearchService._();

  // ── Source registry — same URLs the React Academics module uses ──────────
  static const List<GuidelineSource> sources = [
    GuidelineSource(
      slug: 'iap-stg-2022',
      shortName: 'IAP STG 2022',
      fullName: 'IAP Standard Treatment Guidelines 2022',
      colorArgb: 0xFF1E3A5F,
      indexUrl:
          'https://mulgundsunil1918.github.io/pediaid-stg/stg_index.json',
    ),
    GuidelineSource(
      slug: 'iap-action-plan-2026',
      shortName: 'IAP Action Plan 2026',
      fullName: 'IAP Action Plan 2026 — Practice Guidelines',
      colorArgb: 0xFFEA580C,
      indexUrl:
          'https://mulgundsunil1918.github.io/pediaid-frontend/data/iap-action-plan-2026-index.json',
    ),
    GuidelineSource(
      slug: 'nnf-cpg',
      shortName: 'NNF CPG',
      fullName: 'NNF Clinical Practice Guidelines',
      colorArgb: 0xFF7C3AED,
      indexUrl:
          'https://mulgundsunil1918.github.io/pediaid-frontend/data/nnf-cpg-index.json',
    ),
  ];

  static const String _kCachePrefsKey = 'pediaid_guidelines_cache_v1';
  static const String _kCacheTimePrefsKey =
      'pediaid_guidelines_cache_at_v1';
  static const Duration _cacheTtl = Duration(days: 7);

  /// Combined list of all chapters across all sources. `null` until the
  /// first load completes (or hydrates from cache).
  List<GuidelineSearchHit>? _all;
  Future<void>? _loading;

  bool get isLoaded => _all != null;
  int get totalChapters => _all?.length ?? 0;

  /// Kicks off (or returns) the load. Idempotent — call freely.
  Future<void> ensureLoaded() {
    if (_all != null) return Future.value();
    return _loading ??= _loadInternal();
  }

  Future<void> _loadInternal() async {
    // 1. Hydrate from cache if available — instant, non-blocking.
    bool hydratedFromCache = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_kCachePrefsKey);
      final cachedAt = prefs.getInt(_kCacheTimePrefsKey) ?? 0;
      if (cached != null && cached.isNotEmpty) {
        try {
          _all = _decodeCache(cached);
          hydratedFromCache = true;
          debugPrint('[GuidelinesSearch] hydrated ${_all!.length} chapters from cache');
        } catch (e) {
          debugPrint('[GuidelinesSearch] cache decode failed: $e');
        }
      }
      // If cache is fresh AND hydration worked, don't bother refetching
      // synchronously — fire a background refresh and return.
      if (hydratedFromCache &&
          DateTime.now().millisecondsSinceEpoch - cachedAt <
              _cacheTtl.inMilliseconds) {
        // Background refresh — caller doesn't await.
        // ignore: unawaited_futures
        _fetchAllAndCache();
        return;
      }
    } catch (e) {
      debugPrint('[GuidelinesSearch] cache read failed: $e');
    }

    // 2. Fetch fresh in parallel. If hydration succeeded we already have
    // _all populated, so a network failure here is non-fatal.
    try {
      await _fetchAllAndCache();
    } catch (e) {
      debugPrint('[GuidelinesSearch] network load failed: $e');
      _all ??= const <GuidelineSearchHit>[]; // never leave _all null
    }
  }

  Future<void> _fetchAllAndCache() async {
    final futures = sources.map((s) => _fetchOne(s)).toList();
    final results = await Future.wait(futures, eagerError: false);
    final combined = <GuidelineSearchHit>[];
    for (final list in results) {
      combined.addAll(list);
    }
    _all = combined;
    debugPrint('[GuidelinesSearch] fetched ${combined.length} chapters from network');

    // Persist cache.
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kCachePrefsKey, _encodeCache(combined));
      await prefs.setInt(_kCacheTimePrefsKey,
          DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('[GuidelinesSearch] cache write failed: $e');
    }
  }

  Future<List<GuidelineSearchHit>> _fetchOne(GuidelineSource source) async {
    try {
      final res = await http
          .get(Uri.parse(source.indexUrl))
          .timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) {
        debugPrint('[GuidelinesSearch] ${source.slug} HTTP ${res.statusCode}');
        return const [];
      }
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final chapters = body['chapters'] as List<dynamic>? ?? const [];
      return chapters
          .whereType<Map<String, dynamic>>()
          .map((c) => GuidelineSearchHit(
                no: (c['no'] ?? '').toString(),
                title: (c['title'] ?? '').toString(),
                section: (c['section'] ?? '').toString(),
                keywords: ((c['keywords'] as List?) ?? const [])
                    .map((e) => e.toString())
                    .toList(),
                url: (c['url'] ?? '').toString(),
                source: source,
              ))
          .where((h) => h.title.isNotEmpty && h.url.isNotEmpty)
          .toList();
    } catch (e) {
      debugPrint('[GuidelinesSearch] ${source.slug} fetch failed: $e');
      return const [];
    }
  }

  // ── Public search API ────────────────────────────────────────────────────
  /// Returns up to 20 best-matching chapters, sorted by descending score.
  /// Empty query returns []. Always synchronous — call ensureLoaded() first
  /// (the search UI does this implicitly via FutureBuilder).
  List<GuidelineSearchHit> search(String query, {int limit = 20}) {
    final all = _all;
    final q = query.trim().toLowerCase();
    if (all == null || q.isEmpty) return const [];

    final scored = <_Scored>[];
    for (final c in all) {
      final s = _score(c, q);
      if (s > 0) scored.add(_Scored(c, s));
    }
    scored.sort((a, b) => b.score - a.score);
    return scored.take(limit).map((s) => s.hit).toList();
  }

  int _score(GuidelineSearchHit c, String q) {
    int n = 0;
    final title = c.title.toLowerCase();
    final section = c.section.toLowerCase();
    final keywords =
        c.keywords.map((k) => k.toLowerCase()).join(' | ');
    if (title.contains(q)) n += 10;
    if (title.startsWith(q)) n += 5;
    if (keywords.contains(q)) n += 5;
    if (section.contains(q)) n += 2;
    return n;
  }

  // ── Cache (de)serialisation ──────────────────────────────────────────────
  String _encodeCache(List<GuidelineSearchHit> hits) {
    final list = hits.map((h) => {
      'no': h.no,
      'title': h.title,
      'section': h.section,
      'keywords': h.keywords,
      'url': h.url,
      'src': h.source.slug,
    }).toList();
    return jsonEncode({'v': 1, 'hits': list});
  }

  List<GuidelineSearchHit> _decodeCache(String raw) {
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final hits = decoded['hits'] as List<dynamic>;
    final byKey = {for (final s in sources) s.slug: s};
    return hits
        .whereType<Map<String, dynamic>>()
        .map((j) {
          final src = byKey[j['src'] as String?];
          if (src == null) return null;
          return GuidelineSearchHit(
            no: (j['no'] ?? '').toString(),
            title: (j['title'] ?? '').toString(),
            section: (j['section'] ?? '').toString(),
            keywords: ((j['keywords'] as List?) ?? const [])
                .map((e) => e.toString())
                .toList(),
            url: (j['url'] ?? '').toString(),
            source: src,
          );
        })
        .whereType<GuidelineSearchHit>()
        .toList();
  }
}

class _Scored {
  final GuidelineSearchHit hit;
  final int score;
  _Scored(this.hit, this.score);
}
