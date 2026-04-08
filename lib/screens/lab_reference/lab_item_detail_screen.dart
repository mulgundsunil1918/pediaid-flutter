import 'package:flutter/material.dart';
import '../../services/lab_reference_service.dart';

/// Generic detail screen — renders any LabTable structure.
class LabItemDetailScreen extends StatelessWidget {
  final String itemName;
  final LabTable? table;

  const LabItemDetailScreen({
    super.key,
    required this.itemName,
    required this.table,
  });

  // Strip "TABLE X.Y: " prefix for display
  static String _displayName(String n) =>
      n.replaceFirst(RegExp(r'^TABLE\s+[\d.]+:\s*', caseSensitive: false), '');

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final displayName = _displayName(itemName);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: cs.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          displayName,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: table == null ? _buildComingSoon(context) : _buildContent(context),
    );
  }

  // ── Coming Soon ────────────────────────────────────────────────────────────

  Widget _buildComingSoon(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline,
              size: 56, color: cs.onSurface.withValues(alpha: 0.25)),
          const SizedBox(height: 16),
          Text(
            'Coming Soon',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: cs.onSurface.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 8),
          Text(
            'Data for this item will be added\nin a future update.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13,
                color: cs.onSurface.withValues(alpha: 0.4),
                height: 1.5),
          ),
        ],
      ),
    );
  }

  // ── Main content ───────────────────────────────────────────────────────────

  Widget _buildContent(BuildContext context) {
    final t = table!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instruction / note card
          if ((t.instruction ?? '').isNotEmpty) ...[
            _buildNoteCard(context, t.instruction!),
            const SizedBox(height: 14),
          ],

          // Table data
          if (t.rows.isEmpty)
            _buildEmptyState(context)
          else ...[
            _buildSectionLabel(context, 'Data'),
            const SizedBox(height: 8),
            _hasArrayOrMapValues(t.rows)
                ? _buildCardLayout(context, t.rows)
                : _buildDataTable(context, t.rows),
          ],

          const SizedBox(height: 20),

          // Footer (reference citation)
          _buildFooter(context, t.reference),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Note card ─────────────────────────────────────────────────────────────

  Widget _buildNoteCard(BuildContext context, String text) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 16, color: cs.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 12,
                  color: cs.onSurface.withValues(alpha: 0.75),
                  height: 1.5,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section label ─────────────────────────────────────────────────────────

  Widget _buildSectionLabel(BuildContext context, String label) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      label,
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: cs.onSurface),
    );
  }

  // ── Empty state ───────────────────────────────────────────────────────────

  Widget _buildEmptyState(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Text(
          'No data rows available.',
          style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.4), fontSize: 14),
        ),
      ),
    );
  }

  // ── Detection helper ──────────────────────────────────────────────────────

  bool _hasArrayOrMapValues(List<Map<String, dynamic>> rows) =>
      rows.any((row) => row.values.any((v) => v is List || v is Map));

  // ── DataTable renderer (flat / nested-object rows) ────────────────────────

  Widget _buildDataTable(
      BuildContext context, List<Map<String, dynamic>> rows) {
    final cs = Theme.of(context).colorScheme;
    final cols = _deriveColumns(rows);

    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: cs.onSurface.withValues(alpha: 0.08)),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor:
              WidgetStateProperty.all(cs.primary.withValues(alpha: 0.08)),
          dataRowColor: WidgetStateProperty.resolveWith(
              (_) => Theme.of(context).cardColor),
          columnSpacing: 16,
          horizontalMargin: 12,
          headingRowHeight: 40,
          dataRowMinHeight: 34,
          dataRowMaxHeight: 60,
          columns: cols
              .map(
                (col) => DataColumn(
                  label: Text(
                    col,
                    style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 11),
                  ),
                ),
              )
              .toList(),
          rows: rows.map((row) {
            final flat = _flattenRow(row);
            return DataRow(
              cells: cols
                  .map(
                    (col) => DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 180),
                        child: Text(
                          (flat[col]?.isNotEmpty ?? false) ? flat[col]! : '—',
                          style: TextStyle(
                              color: cs.onSurface, fontSize: 11),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Derive ordered column list, flattening one level of nested maps.
  List<String> _deriveColumns(List<Map<String, dynamic>> rows) {
    final cols = <String>[];
    final seen = <String>{};
    for (final row in rows) {
      for (final entry in row.entries) {
        if (entry.value is Map) {
          final nested = entry.value as Map;
          for (final k in nested.keys) {
            final col = '${entry.key} — $k';
            if (seen.add(col)) cols.add(col);
          }
        } else {
          if (seen.add(entry.key)) cols.add(entry.key);
        }
      }
    }
    return cols;
  }

  /// Flatten a row: nested maps get expanded with "Parent — Child" keys,
  /// lists become comma-joined strings.
  Map<String, String> _flattenRow(Map<String, dynamic> row) {
    final result = <String, String>{};
    for (final entry in row.entries) {
      final v = entry.value;
      if (v is Map) {
        for (final k in v.keys) {
          result['${entry.key} — $k'] = v[k]?.toString() ?? '';
        }
      } else if (v is List) {
        result[entry.key] =
            v.map((e) => e is Map ? e.values.first?.toString() ?? '' : e?.toString() ?? '').join(', ');
      } else {
        result[entry.key] = v?.toString() ?? '';
      }
    }
    return result;
  }

  // ── Card-per-row renderer (for rows with arrays/nested maps) ──────────────

  Widget _buildCardLayout(
      BuildContext context, List<Map<String, dynamic>> rows) {
    return Column(
      children:
          rows.map((row) => _buildRowCard(context, row)).toList(),
    );
  }

  Widget _buildRowCard(BuildContext context, Map<String, dynamic> row) {
    return Card(
      elevation: 1,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: row.entries
              .map((e) => _buildFieldBlock(context, e.key, e.value))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildFieldBlock(BuildContext context, String key, dynamic value) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key.toUpperCase(),
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: cs.onSurface.withValues(alpha: 0.5),
                letterSpacing: 0.7),
          ),
          const SizedBox(height: 4),
          _buildValue(context, value),
        ],
      ),
    );
  }

  Widget _buildValue(BuildContext context, dynamic value) {
    if (value is List) return _buildList(context, value);
    if (value is Map) return _buildMap(context, value as Map<String, dynamic>);
    final cs = Theme.of(context).colorScheme;
    return Text(
      value?.toString() ?? '—',
      style: TextStyle(fontSize: 13, color: cs.onSurface, height: 1.4),
    );
  }

  // List<dynamic> — may contain strings or nested maps
  Widget _buildList(BuildContext context, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: item is Map
                    ? _buildNestedMapItem(
                        context, Map<String, dynamic>.from(item))
                    : _buildBulletRow(context, item?.toString() ?? ''),
              ))
          .toList(),
    );
  }

  // A map inside a list (e.g. {MainCondition, SubConditions})
  Widget _buildNestedMapItem(
      BuildContext context, Map<String, dynamic> item) {
    final cs = Theme.of(context).colorScheme;
    final main = item['MainCondition']?.toString();
    if (main != null) {
      final subs = item['SubConditions'] as List?;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBulletRow(context, main, bold: true),
          if (subs != null)
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Column(
                children: subs
                    .map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: cs.onSurface.withValues(alpha: 0.35),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  s?.toString() ?? '',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: cs.onSurface
                                          .withValues(alpha: 0.8),
                                      height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
        ],
      );
    }
    // Generic map item: show as indented key-value
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: item.entries
          .map((e) => _buildFieldBlock(context, e.key, e.value))
          .toList(),
    );
  }

  // Map as a value — render sub-keys as indented sections
  Widget _buildMap(BuildContext context, Map<String, dynamic> map) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: map.entries
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.key,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: cs.primary),
                  ),
                  const SizedBox(height: 3),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _buildValue(context, e.value),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildBulletRow(BuildContext context, String text,
      {bool bold = false}) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                  color: cs.primary, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 13,
                  color: cs.onSurface,
                  fontWeight:
                      bold ? FontWeight.w600 : FontWeight.normal,
                  height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  // ── Footer ────────────────────────────────────────────────────────────────

  Widget _buildFooter(BuildContext context, String? reference) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book_outlined, size: 16, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                'Source: Harriet Lane Handbook',
                style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withValues(alpha: 0.65),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          if ((reference ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              reference!,
              style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurface.withValues(alpha: 0.45),
                  height: 1.4,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}
