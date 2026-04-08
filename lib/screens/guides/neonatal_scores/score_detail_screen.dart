import 'package:flutter/material.dart';
import '../../../data/scores_data_loader.dart';

class ScoreDetailScreen extends StatelessWidget {
  final NeonatalScore score;

  const ScoreDetailScreen({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(score.name, style: const TextStyle(fontSize: 17)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Parameters / Subsections ────────────────────────────────
              _SectionHeader('Parameters', cs),
              const SizedBox(height: 10),

              if (score.subsections.isNotEmpty) ...[
                // Combined-style: multiple named subsections
                ...score.subsections.map((sub) => _SubsectionBlock(
                      sub: sub,
                      cs: cs,
                      isDark: isDark,
                    )),
              ] else ...[
                // Standard single table
                _ParameterTable(
                  rows: score.parameters,
                  cs: cs,
                  isDark: isDark,
                ),
              ],

              const SizedBox(height: 24),

              // ── Interpretation ──────────────────────────────────────────
              _SectionHeader('Interpretation', cs),
              const SizedBox(height: 10),
              _InterpretationSection(
                rows: score.interpretation,
                cs: cs,
                isDark: isDark,
              ),

              const SizedBox(height: 24),

              // ── Reference ───────────────────────────────────────────────
              _ReferenceBlock(
                  reference: score.reference, cs: cs, isDark: isDark),

              // ── PHVD Management Zones (IVH module only) ─────────────────
              if (score.phvd != null) ...[
                const SizedBox(height: 28),
                _PhvdSection(phvd: score.phvd!, cs: cs, isDark: isDark),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Subsection block (titled group) ──────────────────────────────────────────

class _SubsectionBlock extends StatelessWidget {
  final ScoreSubsection sub;
  final ColorScheme cs;
  final bool isDark;

  const _SubsectionBlock({
    required this.sub,
    required this.cs,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Subsection title pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
          ),
          child: Text(
            sub.title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: cs.primary,
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _ParameterTable(rows: sub.parameters, cs: cs, isDark: isDark),
        const SizedBox(height: 14),
      ],
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final ColorScheme cs;
  const _SectionHeader(this.title, this.cs);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: cs.primary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// ── Parameter table — fully dynamic column count ──────────────────────────────

class _ParameterTable extends StatelessWidget {
  final List<Map<String, String>> rows;
  final ColorScheme cs;
  final bool isDark;

  const _ParameterTable({
    required this.rows,
    required this.cs,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();

    final headers  = rows.first.keys.toList();
    final colCount = headers.length;

    // Column widths: first col wider for names, rest narrower
    final double col0 = colCount > 2 ? 160.0 : 190.0;
    final double colN = colCount > 2 ? 130.0 : 200.0;
    final double totalWidth = col0 + colN * (colCount - 1);

    final headerBg    = cs.primary.withValues(alpha: isDark ? 0.25 : 0.12);
    final altRowBg    = cs.onSurface.withValues(alpha: isDark ? 0.06 : 0.03);
    final borderColor = cs.outline.withValues(alpha: isDark ? 0.3 : 0.2);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: totalWidth,
            child: Column(
              children: [
                _buildRow(
                  widths: [col0, ...List.filled(colCount - 1, colN)],
                  cells: headers.map(_formatHeader).toList(),
                  isHeader: true,
                  bg: headerBg,
                  cs: cs,
                  borderColor: borderColor,
                  isLast: false,
                ),
                ...List.generate(rows.length, (i) {
                  final row = rows[i];
                  return _buildRow(
                    widths: [col0, ...List.filled(colCount - 1, colN)],
                    cells: headers.map((k) => row[k] ?? '').toList(),
                    isHeader: false,
                    bg: i.isOdd ? altRowBg : Colors.transparent,
                    cs: cs,
                    borderColor: borderColor,
                    isLast: i == rows.length - 1,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow({
    required List<double> widths,
    required List<String> cells,
    required bool isHeader,
    required Color bg,
    required ColorScheme cs,
    required Color borderColor,
    required bool isLast,
  }) {
    return Container(
      color: bg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(cells.length, (ci) {
          final isLastCol = ci == cells.length - 1;
          return Container(
            width: widths[ci],
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                right: isLastCol
                    ? BorderSide.none
                    : BorderSide(color: borderColor, width: 0.8),
                bottom: isLast
                    ? BorderSide.none
                    : BorderSide(color: borderColor, width: 0.8),
              ),
            ),
            child: Text(
              cells[ci],
              style: TextStyle(
                fontSize: isHeader ? 12.5 : 13,
                fontWeight: isHeader ? FontWeight.w700 : FontWeight.normal,
                color: isHeader ? cs.primary : cs.onSurface,
                height: 1.4,
              ),
            ),
          );
        }),
      ),
    );
  }

  static String _formatHeader(String key) {
    if (key.isEmpty) return key;
    if (RegExp(r'^[0-9]+$').hasMatch(key)) return key;
    return key[0].toUpperCase() + key.substring(1);
  }
}

// ── Interpretation section — 2-col or 3-col depending on data ─────────────────

class _InterpretationSection extends StatelessWidget {
  final List<Map<String, String>> rows;
  final ColorScheme cs;
  final bool isDark;

  const _InterpretationSection({
    required this.rows,
    required this.cs,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();

    final colCount = rows.first.length;

    if (colCount >= 3) {
      // 3-column (e.g. score | category | meaning) — use scrollable table
      return _ThreeColInterpTable(rows: rows, cs: cs, isDark: isDark);
    }

    // Standard 2-column
    return _TwoColInterpTable(rows: rows, cs: cs, isDark: isDark);
  }
}

// ── 2-column interpretation (standard) ───────────────────────────────────────

class _TwoColInterpTable extends StatelessWidget {
  final List<Map<String, String>> rows;
  final ColorScheme cs;
  final bool isDark;

  const _TwoColInterpTable({
    required this.rows,
    required this.cs,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final headers     = rows.first.keys.toList();
    final labelKey    = headers.first;
    final meaningKey  = headers.length > 1 ? headers[1] : '';
    final borderColor = cs.outline.withValues(alpha: isDark ? 0.3 : 0.2);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            _InterpRow2(
              label: _cap(labelKey),
              meaning: _cap(meaningKey),
              isHeader: true,
              bg: cs.primary.withValues(alpha: isDark ? 0.25 : 0.12),
              cs: cs,
              borderColor: borderColor,
              isLast: false,
            ),
            ...List.generate(rows.length, (i) {
              final row   = rows[i];
              final altBg = i.isOdd
                  ? cs.onSurface.withValues(alpha: isDark ? 0.06 : 0.03)
                  : Colors.transparent;
              return _InterpRow2(
                label: row[labelKey] ?? '',
                meaning: meaningKey.isNotEmpty ? (row[meaningKey] ?? '') : '',
                isHeader: false,
                bg: altBg,
                cs: cs,
                borderColor: borderColor,
                isLast: i == rows.length - 1,
              );
            }),
          ],
        ),
      ),
    );
  }

  static String _cap(String key) {
    if (key.isEmpty) return key;
    return key[0].toUpperCase() + key.substring(1);
  }
}

class _InterpRow2 extends StatelessWidget {
  final String label;
  final String meaning;
  final bool isHeader;
  final Color bg;
  final ColorScheme cs;
  final Color borderColor;
  final bool isLast;

  const _InterpRow2({
    required this.label,
    required this.meaning,
    required this.isHeader,
    required this.bg,
    required this.cs,
    required this.borderColor,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 130,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: borderColor, width: 0.8),
                bottom: isLast
                    ? BorderSide.none
                    : BorderSide(color: borderColor, width: 0.8),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: isHeader ? 12.5 : 13,
                fontWeight:
                    isHeader ? FontWeight.w700 : FontWeight.w600,
                color: isHeader ? cs.primary : cs.onSurface,
                height: 1.4,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: isLast
                      ? BorderSide.none
                      : BorderSide(color: borderColor, width: 0.8),
                ),
              ),
              child: Text(
                meaning,
                style: TextStyle(
                  fontSize: isHeader ? 12.5 : 13,
                  fontWeight: isHeader ? FontWeight.w700 : FontWeight.normal,
                  color: isHeader ? cs.primary : cs.onSurface,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 3-column interpretation (Combined Apgar style) ────────────────────────────

class _ThreeColInterpTable extends StatelessWidget {
  final List<Map<String, String>> rows;
  final ColorScheme cs;
  final bool isDark;

  const _ThreeColInterpTable({
    required this.rows,
    required this.cs,
    required this.isDark,
  });

  // Fixed widths: score | category | meaning
  static const double _wScore    = 80.0;
  static const double _wCategory = 180.0;
  static const double _wMeaning  = 250.0;
  static const double _totalW    = _wScore + _wCategory + _wMeaning;

  @override
  Widget build(BuildContext context) {
    final headers     = rows.first.keys.toList();
    final borderColor = cs.outline.withValues(alpha: isDark ? 0.3 : 0.2);
    final headerBg    = cs.primary.withValues(alpha: isDark ? 0.25 : 0.12);
    final altBg       = cs.onSurface.withValues(alpha: isDark ? 0.06 : 0.03);

    final widths = [_wScore, _wCategory, _wMeaning];

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: _totalW,
            child: Column(
              children: [
                // Header
                _buildRow3(
                  cells: headers.map(_cap).toList(),
                  widths: widths,
                  isHeader: true,
                  bg: headerBg,
                  cs: cs,
                  borderColor: borderColor,
                  isLast: false,
                ),
                // Data rows
                ...List.generate(rows.length, (i) {
                  final row = rows[i];
                  return _buildRow3(
                    cells: headers.map((k) => row[k] ?? '').toList(),
                    widths: widths,
                    isHeader: false,
                    bg: i.isOdd ? altBg : Colors.transparent,
                    cs: cs,
                    borderColor: borderColor,
                    isLast: i == rows.length - 1,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow3({
    required List<String> cells,
    required List<double> widths,
    required bool isHeader,
    required Color bg,
    required ColorScheme cs,
    required Color borderColor,
    required bool isLast,
  }) {
    return Container(
      color: bg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(cells.length, (ci) {
          final isLastCol = ci == cells.length - 1;
          // Severity color for data rows in column 1 (category)
          Color textColor = isHeader ? cs.primary : cs.onSurface;
          FontWeight weight = isHeader ? FontWeight.w700 : FontWeight.normal;
          if (!isHeader && ci == 1) {
            textColor = _severityColor(cells[ci], cs);
            weight    = FontWeight.w600;
          }
          return Container(
            width: widths[ci],
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                right: isLastCol
                    ? BorderSide.none
                    : BorderSide(color: borderColor, width: 0.8),
                bottom: isLast
                    ? BorderSide.none
                    : BorderSide(color: borderColor, width: 0.8),
              ),
            ),
            child: Text(
              cells[ci],
              style: TextStyle(
                fontSize: isHeader ? 12.5 : 13,
                fontWeight: weight,
                color: textColor,
                height: 1.4,
              ),
            ),
          );
        }),
      ),
    );
  }

  static Color _severityColor(String category, ColorScheme cs) {
    final lower = category.toLowerCase();
    if (lower.contains('normal') || lower.contains('reassuring')) {
      return const Color(0xFF2E7D32); // green
    }
    if (lower.contains('moderate')) return const Color(0xFFE65100); // orange
    if (lower.contains('severe'))   return const Color(0xFFB71C1C); // red
    return cs.onSurface;
  }

  static String _cap(String key) {
    if (key.isEmpty) return key;
    return key[0].toUpperCase() + key.substring(1);
  }
}

// ── Reference block ───────────────────────────────────────────────────────────

class _ReferenceBlock extends StatelessWidget {
  final String reference;
  final ColorScheme cs;
  final bool isDark;

  const _ReferenceBlock({
    required this.reference,
    required this.cs,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: isDark ? 0.06 : 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outline.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'REFERENCE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: cs.onSurface.withValues(alpha: 0.4),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            reference,
            style: TextStyle(
              fontSize: 12,
              color: cs.onSurface.withValues(alpha: 0.55),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// PHVD Management Zones
// ═════════════════════════════════════════════════════════════════════════════

class _PhvdSection extends StatelessWidget {
  final PhvdData phvd;
  final ColorScheme cs;
  final bool isDark;

  const _PhvdSection({
    required this.phvd,
    required this.cs,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Section header ──────────────────────────────────────────────
        Row(children: [
          Container(
            width: 3, height: 16,
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              phvd.title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: cs.primary,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ]),
        const SizedBox(height: 12),

        // ── Zone cards ──────────────────────────────────────────────────
        ...phvd.zones.map((zone) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PhvdZoneCard(zone: zone, cs: cs, isDark: isDark),
            )),

        // ── Footer note ─────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cs.onSurface.withValues(alpha: isDark ? 0.07 : 0.04),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: cs.outline.withValues(alpha: 0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NOTE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface.withValues(alpha: 0.4),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                phvd.footer,
                style: TextStyle(
                  fontSize: 12,
                  color: cs.onSurface.withValues(alpha: 0.6),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // ── PHVD Reference ──────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: cs.onSurface.withValues(alpha: isDark ? 0.06 : 0.04),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: cs.outline.withValues(alpha: 0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'REFERENCE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface.withValues(alpha: 0.4),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                phvd.reference,
                style: TextStyle(
                  fontSize: 12,
                  color: cs.onSurface.withValues(alpha: 0.55),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Zone card ─────────────────────────────────────────────────────────────────

class _PhvdZoneCard extends StatelessWidget {
  final PhvdZone zone;
  final ColorScheme cs;
  final bool isDark;

  const _PhvdZoneCard({
    required this.zone,
    required this.cs,
    required this.isDark,
  });

  static Color _zoneColor(String name) {
    final n = name.toLowerCase();
    if (n.contains('green'))  return const Color(0xFF2E7D32);
    if (n.contains('yellow')) return const Color(0xFFF9A825);
    if (n.contains('red'))    return const Color(0xFFC62828);
    return const Color(0xFF1565C0);
  }

  @override
  Widget build(BuildContext context) {
    final zc = _zoneColor(zone.name);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: zc.withValues(alpha: 0.55), width: 1.5),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Zone name header ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: zc.withValues(alpha: isDark ? 0.2 : 0.12),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(
              zone.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: zc,
                letterSpacing: 0.3,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Key Criteria label ──────────────────────────────────
                Text(
                  'Key Criteria:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 6),

                // ── Ventricular size header ─────────────────────────────
                Text(
                  zone.ventricularHeader,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: cs.onSurface.withValues(alpha: 0.65),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 5),

                // Ventricular criteria with connector between them
                ...List.generate(zone.ventricularCriteria.length, (i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BulletLine(text: zone.ventricularCriteria[i], cs: cs),
                      if (i < zone.ventricularCriteria.length - 1)
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 3, bottom: 3),
                          child: Text(
                            zone.ventricularConnector,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                    ],
                  );
                }),

                const SizedBox(height: 8),

                // ── Clinical criteria connector ─────────────────────────
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    zone.clinicalHeader,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                ),
                Text(
                  zone.clinicalNote,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: cs.onSurface.withValues(alpha: 0.65),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 5),

                ...zone.clinicalCriteria.map(
                  (c) => _BulletLine(text: c, cs: cs),
                ),

                const SizedBox(height: 12),
                Divider(
                  height: 1,
                  color: cs.outline.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 10),

                // ── Management ──────────────────────────────────────────
                Text(
                  'Management:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 6),
                ...zone.management.map(
                  (m) => _BulletLine(text: m, cs: cs, isMgmt: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bullet line ───────────────────────────────────────────────────────────────

class _BulletLine extends StatelessWidget {
  final String text;
  final ColorScheme cs;
  final bool isMgmt;

  const _BulletLine({
    required this.text,
    required this.cs,
    this.isMgmt = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 4, right: 8),
            child: Container(
              width: isMgmt ? 5 : 5,
              height: isMgmt ? 5 : 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.onSurface.withValues(alpha: 0.45),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.5,
                color: cs.onSurface.withValues(alpha: isMgmt ? 0.85 : 0.7),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
