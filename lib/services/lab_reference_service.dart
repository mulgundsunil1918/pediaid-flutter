import 'dart:convert';
import 'package:flutter/services.dart';

// ── Data models ───────────────────────────────────────────────────────────────

/// One system entry from lab_structure.json
class LabSystem {
  final String name;
  final List<String> labs;
  final List<String> guides;

  const LabSystem({
    required this.name,
    required this.labs,
    required this.guides,
  });

  List<String> get allItems => [...labs, ...guides];
}

/// A parsed table from lab_data.json
class LabTable {
  final String name;
  final List<Map<String, dynamic>> rows;
  final String? reference;
  final String? instruction;

  const LabTable({
    required this.name,
    required this.rows,
    this.reference,
    this.instruction,
  });
}

/// One search hit
class LabSearchResult {
  final String itemName;
  final String system;
  final bool isGuide;
  final bool hasData;

  const LabSearchResult({
    required this.itemName,
    required this.system,
    required this.isGuide,
    required this.hasData,
  });
}

// ── Service (singleton) ───────────────────────────────────────────────────────

class LabReferenceService {
  static final LabReferenceService _instance = LabReferenceService._internal();
  factory LabReferenceService() => _instance;
  LabReferenceService._internal();

  List<LabSystem> _systems = [];
  // Keyed by normalised table name (lowercase + trimmed)
  final Map<String, LabTable> _tables = {};
  bool _loaded = false;

  bool get isLoaded => _loaded;

  // ── Load ────────────────────────────────────────────────────────────────────

  Future<void> load() async {
    if (_loaded) return;

    final results = await Future.wait([
      rootBundle.loadString('assets/lab_structure.json'),
      rootBundle.loadString('assets/lab_data.json'),
    ]);

    // --- Parse lab_structure.json ---
    final structList = json.decode(results[0]) as List;
    _systems = structList.map((e) {
      final m = e as Map<String, dynamic>;
      return LabSystem(
        name: m['system'] as String,
        labs: List<String>.from(m['labs'] as List),
        guides: List<String>.from(m['guides'] as List),
      );
    }).toList();

    // --- Parse lab_data.json (multiple concatenated JSON arrays) ---
    // Each top-level array may contain:
    //   Format 1 – flat rows: [{TableName, col…}, {col…}, …]
    //   Format 2 – Data wrapper: [{TableName, Data:[…]}, {TableInstruction}]
    //   Format 3 – multiple tables in one array: [{TableName, Data:[…]}, {TableName, Data:[…]}, …]
    for (final arr in _splitJsonArrays(results[1])) {
      if (arr.isEmpty) continue;
      _processArray(arr);
    }

    _loaded = true;
  }

  /// Processes one top-level JSON array, extracting one or more LabTables.
  void _processArray(List<dynamic> arr) {
    String? currentName;
    final currentRows = <Map<String, dynamic>>[];
    String? currentRef;
    String? currentInstr;

    void flush() {
      if (currentName == null) return;
      _tables[_norm(currentName!)] = LabTable(
        name: currentName!,
        rows: List<Map<String, dynamic>>.from(currentRows),
        reference: currentRef,
        instruction: currentInstr,
      );
      currentName = null;
      currentRows.clear();
      currentRef = null;
      currentInstr = null;
    }

    for (final raw in arr) {
      final obj = Map<String, dynamic>.from(raw as Map<String, dynamic>);
      final tableName = obj['TableName']?.toString();
      final dataVal = obj['Data'];

      if (tableName != null && dataVal is List) {
        // Format 2 / 3 — rows are nested inside "Data"
        flush();
        currentName = tableName;
        for (final item in dataVal) {
          currentRows
              .add(Map<String, dynamic>.from(item as Map<String, dynamic>));
        }
      } else if (tableName != null) {
        // Format 1 — first object mixes TableName with the first row's columns
        flush();
        currentName = tableName;
        final rowData = Map<String, dynamic>.from(obj)
          ..remove('TableName')
          ..remove('TableReference')
          ..remove('TableInstruction');
        if (rowData.isNotEmpty) currentRows.add(rowData);
      } else if (obj.containsKey('TableReference')) {
        currentRef = obj['TableReference']?.toString();
      } else if (obj.containsKey('TableInstruction')) {
        currentInstr = obj['TableInstruction']?.toString();
      } else {
        // Format 1 continuation — plain data row
        final rowData = Map<String, dynamic>.from(obj)
          ..remove('TableName')
          ..remove('TableReference')
          ..remove('TableInstruction');
        if (rowData.isNotEmpty) currentRows.add(rowData);
      }
    }

    flush();
  }

  // ── Public API ──────────────────────────────────────────────────────────────

  List<LabSystem> get allSystems => List.unmodifiable(_systems);

  /// Looks up a table by name (case-insensitive, partial match fallback).
  LabTable? getTable(String name) {
    final key = _norm(name);
    return _tables[key] ?? _partialMatch(key);
  }

  bool hasData(String name) => getTable(name) != null;

  int itemsWithData(LabSystem system) =>
      system.allItems.where(hasData).length;

  List<LabSearchResult> search(String query) {
    if (query.trim().isEmpty) return [];
    final q = _norm(query);
    final results = <LabSearchResult>[];
    final seen = <String>{};

    for (final system in _systems) {
      for (final lab in system.labs) {
        final uid = '${system.name}|$lab';
        if (seen.add(uid) && _norm(lab).contains(q)) {
          results.add(LabSearchResult(
            itemName: lab,
            system: system.name,
            isGuide: false,
            hasData: hasData(lab),
          ));
        }
      }
      for (final guide in system.guides) {
        final uid = '${system.name}|$guide';
        if (seen.add(uid) && _norm(guide).contains(q)) {
          results.add(LabSearchResult(
            itemName: guide,
            system: system.name,
            isGuide: true,
            hasData: hasData(guide),
          ));
        }
      }
    }

    return results;
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  String _norm(String s) => s.toLowerCase().trim();

  LabTable? _partialMatch(String normQuery) {
    // Direct containment check
    for (final entry in _tables.entries) {
      if (entry.key.contains(normQuery) || normQuery.contains(entry.key)) {
        return entry.value;
      }
    }
    // Word-based fuzzy: ≥60 % of query words (>2 chars) appear in table key
    final words =
        normQuery.split(RegExp(r'\s+')).where((w) => w.length > 2).toList();
    if (words.isEmpty) return null;
    final needed = (words.length * 0.6).ceil();
    for (final entry in _tables.entries) {
      final hits = words.where((w) => entry.key.contains(w)).length;
      if (hits >= needed) return entry.value;
    }
    return null;
  }

  /// Splits a string that contains multiple concatenated JSON top-level arrays
  /// into a list of decoded lists.
  List<List<dynamic>> _splitJsonArrays(String content) {
    final out = <List<dynamic>>[];
    int i = 0;
    final len = content.length;

    while (i < len) {
      // Skip whitespace between arrays
      while (i < len && _isWs(content[i])) {
        i++;
      }
      if (i >= len) break;

      if (content[i] == '[') {
        int depth = 0;
        final start = i;
        bool inStr = false;
        bool esc = false;

        while (i < len) {
          final ch = content[i];
          if (esc) {
            esc = false;
            i++;
            continue;
          }
          if (ch == '\\' && inStr) {
            esc = true;
            i++;
            continue;
          }
          if (ch == '"') {
            inStr = !inStr;
          } else if (!inStr) {
            if (ch == '[') {
              depth++;
            } else if (ch == ']') {
              depth--;
              if (depth == 0) {
                try {
                  out.add(
                      json.decode(content.substring(start, i + 1)) as List);
                } catch (_) {
                  // Skip malformed arrays
                }
                i++;
                break;
              }
            }
          }
          i++;
        }
      } else {
        i++;
      }
    }
    return out;
  }

  bool _isWs(String ch) =>
      ch == ' ' || ch == '\n' || ch == '\r' || ch == '\t';
}
