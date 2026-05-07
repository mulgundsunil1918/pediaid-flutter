// =============================================================================
// services/recents_service.dart
//
// Tracks the last N modules the user opened from the home screen so the
// HomeScreen can show a "Recents" row that adapts to actual usage.
//
// Design:
//   - Module identity is a short string key (matches the Quick Access chip
//     keys: 'gir', 'gas', 'formulary', etc.) plus a display label so the
//     row can render without needing the chip table.
//   - Persisted in SharedPreferences as a single string list, encoded as
//     'key|label' lines. No JSON dependency, no schema migrations.
//   - Insertion is "most recent first, dedupe by key, cap at 6".
//   - Updates publish through a [ValueNotifier] so the home screen
//     rebuilds the row immediately when a chip is tapped.
//
// Usage:
//   await RecentsService.instance.load();        // once at boot
//   RecentsService.instance.record('gir', 'GIR Calc');  // on tap
//   ValueListenableBuilder(
//     valueListenable: RecentsService.instance.notifier,
//     builder: (_, items, __) => ...
//   );
// =============================================================================

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentItem {
  final String key;
  final String label;
  const RecentItem({required this.key, required this.label});

  @override
  bool operator ==(Object other) =>
      other is RecentItem && other.key == key;
  @override
  int get hashCode => key.hashCode;
}

class RecentsService {
  RecentsService._();
  static final RecentsService instance = RecentsService._();

  static const String _kPrefsKey = 'pediaid_recents_v1';
  static const int _kMaxItems = 6;

  /// Listenable list of recent items, most-recent first.
  final ValueNotifier<List<RecentItem>> notifier =
      ValueNotifier<List<RecentItem>>(const []);

  bool _loaded = false;

  /// Hydrate from SharedPreferences. Idempotent — calling twice is free.
  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_kPrefsKey) ?? const [];
      final items = <RecentItem>[];
      for (final line in raw) {
        final i = line.indexOf('|');
        if (i <= 0 || i == line.length - 1) continue;
        items.add(RecentItem(
          key: line.substring(0, i),
          label: line.substring(i + 1),
        ));
        if (items.length >= _kMaxItems) break;
      }
      notifier.value = items;
    } catch (e) {
      // Recents are an enhancement, never fatal.
      debugPrint('[RecentsService] load failed: $e');
    }
  }

  /// Record that the user opened the module identified by [key]. Moves
  /// the item to the front, dedupes, persists.
  Future<void> record(String key, String label) async {
    if (key.isEmpty || label.isEmpty) return;
    final list = List<RecentItem>.from(notifier.value);
    list.removeWhere((e) => e.key == key);
    list.insert(0, RecentItem(key: key, label: label));
    while (list.length > _kMaxItems) {
      list.removeLast();
    }
    notifier.value = list;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _kPrefsKey,
        list.map((e) => '${e.key}|${e.label}').toList(),
      );
    } catch (e) {
      debugPrint('[RecentsService] save failed: $e');
    }
  }

  /// Wipe history. Exposed for a "Clear recents" entry in Settings.
  Future<void> clear() async {
    notifier.value = const [];
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kPrefsKey);
    } catch (_) {/* fine */}
  }
}
