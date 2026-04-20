// =============================================================================
// lib/screens/guides/ga_classification_screen.dart
//
// Gestational Age & Birthweight Classification reference.
//
// Section 1 — Quick GA Classifier
//   User enters weeks + days; a banner updates live (no button) showing the
//   matching classification. When the baby is preterm (total_days < 260),
//   both the specific subtype and the umbrella "Preterm" label are shown.
//
// Section 2 — Full 9-row table from Table 6-2 (Chapter 6, Gestational Age
//   and Birthweight Classification, page 51). The row(s) matching the
//   user's input are highlighted with a filled 10%-opacity background and
//   a small "▶" indicator.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/view_mode_toggle.dart';

// ---------------------------------------------------------------------------
// Classification data — single source of truth for both the live banner
// and the 9-card table.
// ---------------------------------------------------------------------------

class _GAClass {
  /// Short name shown as the card / banner title.
  final String name;

  /// `Weeks of Gestation` row value.
  final String weeksOfGestation;

  /// `Completed Weeks` row value.
  final String completedWeeks;

  /// `Days` row value.
  final String days;

  /// Colour bar on the left of the card and border of the banner.
  final Color color;

  /// Inclusive range of total postnatal days (weeks × 7 + extraDays) that
  /// this classification matches. Null start = no lower bound, null end =
  /// no upper bound. The general "Preterm" umbrella uses this too.
  final int? dayMin;
  final int? dayMax;

  const _GAClass({
    required this.name,
    required this.weeksOfGestation,
    required this.completedWeeks,
    required this.days,
    required this.color,
    this.dayMin,
    this.dayMax,
  });
}

const List<_GAClass> _classifications = [
  _GAClass(
    name: 'Extremely preterm',
    weeksOfGestation: '<28 weeks',
    completedWeeks:
        'On or before the end of the last day of the 28th week',
    days: '<197 days',
    color: Color(0xFFB71C1C), // red
    dayMax: 196,
  ),
  _GAClass(
    name: 'Very preterm',
    weeksOfGestation: '28 0/7 to 31 6/7 weeks',
    completedWeeks:
        'On or after the first day of the 29th week through the last day of the 32nd week',
    days: '197–224 days',
    color: Color(0xFFE65100), // deep orange
    dayMin: 197,
    dayMax: 224,
  ),
  _GAClass(
    name: 'Moderately preterm',
    weeksOfGestation: '32 0/7 to 33 6/7 weeks',
    completedWeeks:
        'On or after the first day of the 33 weeks through the last day of the 34th week',
    days: '225–238 days',
    color: Color(0xFFF57F17), // amber
    dayMin: 225,
    dayMax: 238,
  ),
  _GAClass(
    name: 'Preterm',
    weeksOfGestation: '<37 weeks',
    completedWeeks:
        'On or before the end of the last day of the 37th week',
    days: '<260 days',
    color: Color(0xFFF57F17), // amber (umbrella — reuses preterm shade)
    dayMax: 259,
  ),
  _GAClass(
    name: 'Late preterm',
    weeksOfGestation: '34 0/7 to 36 6/7 weeks',
    completedWeeks:
        'On or after the first day of the 35th week through the end of the last day of the 37th week',
    days: '239–259 days',
    color: Color(0xFFFFD600), // yellow
    dayMin: 239,
    dayMax: 259,
  ),
  _GAClass(
    name: 'Early term',
    weeksOfGestation: '37 0/7 to 38 6/7 weeks',
    completedWeeks:
        'On or after the first day of the 38th week through the end of the last day of the 39th week',
    days: '260–273 days',
    color: Color(0xFF558B2F), // light green
    dayMin: 260,
    dayMax: 273,
  ),
  _GAClass(
    name: 'Full term',
    weeksOfGestation: '39 0/7 to 40 6/7 weeks',
    completedWeeks:
        'On or after the first day of the 40th week through the end of the last day of the 41st week',
    days: '274–287 days',
    color: Color(0xFF2E7D32), // green
    dayMin: 274,
    dayMax: 287,
  ),
  _GAClass(
    name: 'Late term',
    weeksOfGestation: '41 0/7 to 41 6/7 weeks',
    completedWeeks:
        'On or after the first day of the 42nd week through the end of the day of the 42nd week',
    days: '288–294 days',
    color: Color(0xFF1565C0), // blue
    dayMin: 288,
    dayMax: 294,
  ),
  _GAClass(
    name: 'Post term',
    weeksOfGestation: '42 0/7 weeks or more',
    completedWeeks: 'On or after first day of the 43rd week',
    days: '≥295 days',
    color: Color(0xFF4A148C), // purple
    dayMin: 295,
  ),
];

// Specific (non-umbrella) mutually-exclusive subtypes used for the live
// banner headline. "Preterm" is an umbrella, not a subtype.
const _umbrellaName = 'Preterm';

_GAClass? _primaryFor(int totalDays) {
  for (final c in _classifications) {
    if (c.name == _umbrellaName) continue; // skip umbrella
    final min = c.dayMin ?? -1 << 30;
    final max = c.dayMax ?? 1 << 30;
    if (totalDays >= min && totalDays <= max) return c;
  }
  return null;
}

bool _isPreterm(int totalDays) => totalDays < 260;

// =============================================================================
// Screen
// =============================================================================

class GAClassificationScreen extends StatefulWidget {
  const GAClassificationScreen({super.key});

  @override
  State<GAClassificationScreen> createState() => _GAClassificationScreenState();
}

enum _ViewMode { smart, table }

class _GAClassificationScreenState extends State<GAClassificationScreen> {
  final _weeksCtl = TextEditingController();
  final _daysCtl = TextEditingController();
  _ViewMode _view = _ViewMode.smart;

  @override
  void initState() {
    super.initState();
    _weeksCtl.addListener(() => setState(() {}));
    _daysCtl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _weeksCtl.dispose();
    _daysCtl.dispose();
    super.dispose();
  }

  /// Parse current input. Returns null if weeks is blank or out of range.
  /// Days defaults to 0 if blank; out-of-range days clamp to null (no banner).
  int? get _totalDays {
    final weeks = int.tryParse(_weeksCtl.text.trim());
    if (weeks == null) return null;
    if (weeks < 22 || weeks > 44) return null;
    final daysText = _daysCtl.text.trim();
    final days = daysText.isEmpty ? 0 : int.tryParse(daysText);
    if (days == null) return null;
    if (days < 0 || days > 6) return null;
    return weeks * 7 + days;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final totalDays = _totalDays;
    final primary = totalDays != null ? _primaryFor(totalDays) : null;
    final preterm = totalDays != null && _isPreterm(totalDays);

    // Names of the rows to highlight in the table below.
    final Set<String> highlighted = {
      if (primary != null) primary.name,
      if (preterm) _umbrellaName,
    };

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GA Classification',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Text(
              'Gestational Age & Birthweight',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.80),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        toolbarHeight: 60,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── View toggle: Smart ↔ Table ──────────────────────────────
          ViewModeToggle(
            value: _view == _ViewMode.smart
                ? ViewModeChoice.smart
                : ViewModeChoice.table,
            onChanged: (choice) => setState(() {
              _view = choice == ViewModeChoice.smart
                  ? _ViewMode.smart
                  : _ViewMode.table;
            }),
          ),
          const SizedBox(height: 16),

          if (_view == _ViewMode.smart) ...[
            _QuickClassifierCard(
              weeksCtl: _weeksCtl,
              daysCtl: _daysCtl,
              totalDays: totalDays,
              primary: primary,
              preterm: preterm,
            ),
            // Smart view also shows the matching card(s) below — focused view
            if (highlighted.isNotEmpty) ...[
              const SizedBox(height: 20),
              _SectionLabel(
                label: 'Matching Classification',
                color: primary?.color ?? cs.primary,
              ),
              const SizedBox(height: 10),
              ..._classifications
                  .where((c) => highlighted.contains(c.name))
                  .map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ClassCard(entry: c, highlighted: true),
                    ),
                  ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => setState(() => _view = _ViewMode.table),
                icon: const Icon(Icons.table_chart_outlined, size: 16),
                label: Text(
                  'View full table →',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ] else ...[
            _SectionLabel(
              label: 'Full Classification Table',
              color: cs.primary,
            ),
            const SizedBox(height: 10),
            ..._classifications.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ClassCard(
                  entry: c,
                  highlighted: highlighted.contains(c.name),
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),
          Text(
            'Table 6-2: Definitions of Postnatal Gestational Age.\n'
            'Source: Chapter 6 — Gestational Age and Birthweight Classification, Page 51.\n'
            'Definitions based on conventional medical definitions (day of birth is day zero).',
            textAlign: TextAlign.left,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: cs.onSurface.withValues(alpha: 0.55),
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// =============================================================================
// Quick Classifier card (Section 1)
// =============================================================================

class _QuickClassifierCard extends StatelessWidget {
  const _QuickClassifierCard({
    required this.weeksCtl,
    required this.daysCtl,
    required this.totalDays,
    required this.primary,
    required this.preterm,
  });

  final TextEditingController weeksCtl;
  final TextEditingController daysCtl;
  final int? totalDays;
  final _GAClass? primary;
  final bool preterm;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick GA Classifier',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Gestational Age (weeks + days)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: cs.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _NumField(
                  controller: weeksCtl,
                  label: 'Weeks',
                  hint: 'e.g. 34',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _NumField(
                  controller: daysCtl,
                  label: 'Days',
                  hint: 'e.g. 3',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _ResultBanner(
            totalDays: totalDays,
            primary: primary,
            preterm: preterm,
          ),
        ],
      ),
    );
  }
}

class _NumField extends StatelessWidget {
  const _NumField({
    required this.controller,
    required this.label,
    required this.hint,
  });
  final TextEditingController controller;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withValues(alpha: 0.75),
            )),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: GoogleFonts.plusJakartaSans(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: cs.onSurface.withValues(alpha: 0.35),
            ),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: cs.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultBanner extends StatelessWidget {
  const _ResultBanner({
    required this.totalDays,
    required this.primary,
    required this.preterm,
  });

  final int? totalDays;
  final _GAClass? primary;
  final bool preterm;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Nothing to show until the user has entered a valid GA.
    if (totalDays == null || primary == null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.onSurface.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: cs.onSurface.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline,
                size: 16, color: cs.onSurface.withValues(alpha: 0.55)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Enter weeks (22–44) and days (0–6) to classify.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: cs.onSurface.withValues(alpha: 0.7),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final c = primary!;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: c.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(color: c.color, width: 4),
          top: BorderSide(color: c.color.withValues(alpha: 0.25)),
          right: BorderSide(color: c.color.withValues(alpha: 0.25)),
          bottom: BorderSide(color: c.color.withValues(alpha: 0.25)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  c.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: c.color,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              if (preterm && c.name != _umbrellaName)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF57F17).withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: const Color(0xFFF57F17).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    'PRETERM',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFE65100),
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _Row(label: 'Weeks of Gestation', value: c.weeksOfGestation),
          const SizedBox(height: 3),
          _Row(label: 'Days', value: c.days),
          const SizedBox(height: 3),
          _Row(label: 'Calculated', value: '$totalDays days total'),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withValues(alpha: 0.65),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              color: cs.onSurface,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Full classification card (Section 2)
// =============================================================================

class _ClassCard extends StatelessWidget {
  const _ClassCard({required this.entry, required this.highlighted});
  final _GAClass entry;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = highlighted
        ? entry.color.withValues(alpha: 0.10)
        : Theme.of(context).cardColor;
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlighted
              ? entry.color.withValues(alpha: 0.55)
              : cs.onSurface.withValues(alpha: 0.1),
          width: highlighted ? 1.4 : 1,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left colour bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: entry.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (highlighted)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Text(
                              '▶',
                              style: TextStyle(
                                color: entry.color,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            entry.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _Row(
                        label: 'Weeks of Gestation',
                        value: entry.weeksOfGestation),
                    const SizedBox(height: 4),
                    _Row(
                        label: 'Completed Weeks',
                        value: entry.completedWeeks),
                    const SizedBox(height: 4),
                    _Row(label: 'Days', value: entry.days),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Small section label (matches GIR Calculator styling)
// =============================================================================

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
          color: color,
        ),
      ),
    );
  }
}
