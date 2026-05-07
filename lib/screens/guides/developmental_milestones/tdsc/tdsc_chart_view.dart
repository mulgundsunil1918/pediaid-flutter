// =============================================================================
// lib/screens/guides/developmental_milestones/tdsc/tdsc_chart_view.dart
//
// Faithful visual rendering of the two TDSC charts as a vertical stack
// of horizontal bars. A draggable / slider-driven vertical "age cursor"
// crosses the bars; items the cursor crosses are highlighted (these are
// the items being screened at that age). Tap a bar to read its prompt.
//
// Below the visual chart there is a TABLE view of all 51 items so the
// user can scan them in plain tabular form too.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tdsc_data.dart';

class TdscChartView extends StatefulWidget {
  const TdscChartView({super.key});

  @override
  State<TdscChartView> createState() => _TdscChartViewState();
}

class _TdscChartViewState extends State<TdscChartView>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  double _ageMonths = 12;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('TDSC — Chart View'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        bottom: TabBar(
          controller: _tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.plusJakartaSans(
              fontSize: 12.5, fontWeight: FontWeight.w800),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(
              fontSize: 12.5, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Visual chart'),
            Tab(text: 'Table'),
          ],
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            _ageStrip(cs),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _visualChart(cs),
                  _tableView(cs),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Age strip + slider ─────────────────────────────────────────────────
  Widget _ageStrip(ColorScheme cs) {
    final crossed = tdscItemsAt(_ageMonths).length;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.06),
        border: Border(
            bottom: BorderSide(color: cs.primary.withValues(alpha: 0.15))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.straighten_rounded, size: 16, color: cs.primary),
              const SizedBox(width: 6),
              Text(
                'Age cursor',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${_ageMonths.toStringAsFixed(0)} mo · $crossed crossed',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: _ageMonths.clamp(0, 72),
            min: 0,
            max: 72,
            divisions: 72,
            onChanged: (v) => setState(() => _ageMonths = v),
          ),
        ],
      ),
    );
  }

  // ── Visual chart ───────────────────────────────────────────────────────
  Widget _visualChart(ColorScheme cs) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 24),
      children: [
        _chartHeader(cs, 'Chart 1 — 0 to 3 years', kTdscYoungest.length,
            const Color(0xFFE65100)),
        _chart(
          cs,
          items: kTdscYoungest,
          minMonth: 1,
          maxMonth: 34,
          barColor: const Color(0xFFE65100),
        ),
        const SizedBox(height: 18),
        _chartHeader(cs, 'Chart 2 — 3 to 6 years', kTdscEldest.length,
            const Color(0xFFB71C1C)),
        _chart(
          cs,
          items: kTdscEldest,
          minMonth: 36,
          maxMonth: 72,
          barColor: const Color(0xFFB71C1C),
        ),
      ],
    );
  }

  Widget _chartHeader(ColorScheme cs, String title, int count, Color accent) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 18,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$count items',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chart(
    ColorScheme cs, {
    required List<TdscItem> items,
    required double minMonth,
    required double maxMonth,
    required Color barColor,
  }) {
    const labelColWidth = 156.0;
    const rowHeight = 30.0;
    final span = maxMonth - minMonth;
    final cursorVisible = _ageMonths >= minMonth && _ageMonths <= maxMonth;

    return LayoutBuilder(
      builder: (ctx, cons) {
        final chartWidth = cons.maxWidth - labelColWidth - 14;
        if (chartWidth <= 60) return const SizedBox.shrink();

        final cursorX = cursorVisible
            ? ((_ageMonths - minMonth) / span * chartWidth)
            : -1.0;

        // Build month tick markers
        final ticks = <int>[];
        final step = span <= 36 ? 2 : 4;
        for (int m = minMonth.toInt(); m <= maxMonth.toInt(); m += step) {
          ticks.add(m);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8EC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE0D6BD)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...items.map((it) => _barRow(
                      cs,
                      item: it,
                      labelColWidth: labelColWidth,
                      chartWidth: chartWidth,
                      rowHeight: rowHeight,
                      minMonth: minMonth,
                      span: span,
                      barColor: barColor,
                      cursorX: cursorX,
                    )),
                const SizedBox(height: 4),
                _axis(
                  cs,
                  labelColWidth: labelColWidth,
                  chartWidth: chartWidth,
                  ticks: ticks,
                  minMonth: minMonth,
                  span: span,
                  cursorX: cursorX,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _barRow(
    ColorScheme cs, {
    required TdscItem item,
    required double labelColWidth,
    required double chartWidth,
    required double rowHeight,
    required double minMonth,
    required double span,
    required Color barColor,
    required double cursorX,
  }) {
    final crossed = item.isCrossedAt(_ageMonths);
    final left =
        ((item.ageStart - minMonth) / span * chartWidth).clamp(0.0, chartWidth);
    final right =
        ((item.ageEnd - minMonth) / span * chartWidth).clamp(0.0, chartWidth);
    final width = (right - left).clamp(2.0, chartWidth);

    return SizedBox(
      height: rowHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Label column
          SizedBox(
            width: labelColWidth,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 6),
              child: Row(
                children: [
                  Text(
                    '${item.number}.',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: barColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight:
                            crossed ? FontWeight.w800 : FontWeight.w600,
                        color: cs.onSurface,
                        height: 1.15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bar column
          Expanded(
            child: GestureDetector(
              onTap: () => _showItemDetails(item),
              onHorizontalDragUpdate: (d) {
                final localX = d.localPosition.dx;
                final months =
                    minMonth + (localX / chartWidth) * span;
                setState(() => _ageMonths = months.clamp(0, 72).toDouble());
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Faint baseline
                  Positioned(
                    left: 0,
                    right: 0,
                    top: rowHeight / 2,
                    child: Container(
                      height: 1,
                      color: const Color(0xFFE0D6BD),
                    ),
                  ),
                  // The bar
                  Positioned(
                    left: left,
                    width: width,
                    top: 6,
                    height: rowHeight - 12,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            barColor.withValues(alpha: 0.85),
                            barColor.withValues(alpha: 0.55),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: crossed
                              ? const Color(0xFF1565C0)
                              : barColor.withValues(alpha: 0.3),
                          width: crossed ? 1.4 : 0.8,
                        ),
                      ),
                    ),
                  ),
                  // Cursor segment for this row
                  if (cursorX >= 0)
                    Positioned(
                      left: cursorX - 1,
                      top: 0,
                      bottom: 0,
                      child: IgnorePointer(
                        child: Container(
                          width: 2,
                          color: const Color(0xFF1565C0),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _axis(
    ColorScheme cs, {
    required double labelColWidth,
    required double chartWidth,
    required List<int> ticks,
    required double minMonth,
    required double span,
    required double cursorX,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          SizedBox(
            width: labelColWidth,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                'AGE (mo)',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 22,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 1.2,
                      color: cs.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                  for (final t in ticks)
                    Positioned(
                      left: ((t - minMonth) / span * chartWidth) - 8,
                      top: 2,
                      child: SizedBox(
                        width: 16,
                        child: Column(
                          children: [
                            Container(
                              height: 4,
                              width: 1.2,
                              color: cs.onSurface.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              '$t',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w700,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (cursorX >= 0)
                    Positioned(
                      left: cursorX - 6,
                      top: -2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1565C0),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Item details bottom sheet ──────────────────────────────────────────
  void _showItemDetails(TdscItem item) {
    final cs = Theme.of(context).colorScheme;
    final domain = kTdscDomainInfo[item.domain]!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: domain.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(domain.icon, size: 14, color: domain.color),
                          const SizedBox(width: 4),
                          Text(
                            domain.shortLabel,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: domain.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Item ${item.number} · ${item.chart.label}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.straighten_rounded,
                          size: 16, color: cs.primary),
                      const SizedBox(width: 6),
                      Text(
                        'Age window: ${item.ageStart.toStringAsFixed(0)} – ${item.ageEnd.toStringAsFixed(0)} months',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Examiner prompt',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.prompt,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    height: 1.45,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Table view ─────────────────────────────────────────────────────────
  Widget _tableView(ColorScheme cs) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
      children: [
        _tableSection(cs, 'Chart 1 — 0 to 3 years', kTdscYoungest,
            const Color(0xFFE65100)),
        const SizedBox(height: 18),
        _tableSection(
            cs, 'Chart 2 — 3 to 6 years', kTdscEldest, const Color(0xFFB71C1C)),
      ],
    );
  }

  Widget _tableSection(
      ColorScheme cs, String title, List<TdscItem> items, Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.55)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              color: accent.withValues(alpha: 0.12),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 16,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    '${items.length} items',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                border: Border(
                    bottom: BorderSide(
                        color: cs.outlineVariant.withValues(alpha: 0.55))),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 28,
                    child: Text(
                      '#',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Item',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 78,
                    child: Text(
                      'Age (mo)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 72,
                    child: Text(
                      'Domain',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            for (int i = 0; i < items.length; i++)
              _tableRow(cs, items[i], i.isOdd),
          ],
        ),
      ),
    );
  }

  Widget _tableRow(ColorScheme cs, TdscItem it, bool zebra) {
    final domain = kTdscDomainInfo[it.domain]!;
    final crossed = it.isCrossedAt(_ageMonths);
    return InkWell(
      onTap: () => _showItemDetails(it),
      child: Container(
        color: crossed
            ? const Color(0xFF1565C0).withValues(alpha: 0.07)
            : (zebra
                ? cs.surfaceContainerHighest.withValues(alpha: 0.25)
                : Colors.transparent),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '${it.number}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Text(
                it.name,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight:
                      crossed ? FontWeight.w800 : FontWeight.w700,
                  color: cs.onSurface,
                  height: 1.3,
                ),
              ),
            ),
            SizedBox(
              width: 78,
              child: Text(
                '${it.ageStart.toStringAsFixed(0)}–${it.ageEnd.toStringAsFixed(0)}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
            SizedBox(
              width: 72,
              child: Row(
                children: [
                  Icon(domain.icon, size: 13, color: domain.color),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      domain.shortLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: domain.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
