// =============================================================================
// lib/screens/guides/developmental_milestones/tdsc/tdsc_assistant_screen.dart
//
// "Intelligent developmental screening assistant" for the TDSC.
//
// Single-page experience built around three ideas:
//   1. The doctor sets the child's age (chronological + optional GA
//      correction for preterms ≤ 24 mo).
//   2. The doctor taps a milestone and marks Achieved / Not Achieved /
//      Not Tested.
//   3. The app interprets continuously: bucketing every TDSC item into
//      EXPECTED / EMERGING / FUTURE, scoring delays, and producing a
//      live risk verdict + recommendation.
//
// The interactive bar chart shows every bar coloured by its current
// classification rather than as a static infographic. A "Classic mode"
// toggle restores the original brown / orange TDSC paint.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tdsc_data.dart';
import 'tdsc_engine.dart';
import 'tdsc_chart_view.dart';
import 'tdsc_interpretation.dart';

class TdscAssistantScreen extends StatefulWidget {
  const TdscAssistantScreen({super.key});

  @override
  State<TdscAssistantScreen> createState() => _TdscAssistantScreenState();
}

class _TdscAssistantScreenState extends State<TdscAssistantScreen> {
  double _chronAge = 12;
  bool _correctForGa = false;
  int _gaWeeks = 40;

  bool _classicMode = false;
  TdscDomain? _domainFilter;
  bool _showAchieved = false;
  bool _showFuture = false;

  final Map<int, TdscStatus> _answers = {};

  double get _age => correctedAgeMonths(
        chronologicalMonths: _chronAge,
        gaWeeks: _gaWeeks,
        correctionEnabled: _correctForGa,
      );

  // ── Color system (modern) ──────────────────────────────────────────────
  static const _kAchieved = Color(0xFF16A34A);
  static const _kDelayed = Color(0xFFDC2626);
  static const _kEmerging = Color(0xFFF59E0B);
  static const _kFuture = Color(0xFF94A3B8);
  static const _kCursor = Color(0xFF1565C0);
  static const _kNeedsAsmt = Color(0xFFD97706);

  // Classic palette — authentic TDSC paint (CSS SaddleBrown + DarkOrange)
  static const _kClassicEarly = Color(0xFF8B4513); // SaddleBrown
  static const _kClassicLate = Color(0xFFFF8C00); // DarkOrange

  Color _barColor(TdscItem item, TdscBucket bucket, TdscStatus status) {
    if (_classicMode) return _kClassicLate;
    if (status == TdscStatus.achieved) return _kAchieved;
    if (bucket == TdscBucket.expected && status == TdscStatus.notAchieved) {
      return _kDelayed;
    }
    if (bucket == TdscBucket.expected && status == TdscStatus.notTested) {
      return _kNeedsAsmt;
    }
    if (bucket == TdscBucket.emerging) return _kEmerging;
    return _kFuture;
  }

  // ── Build ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final age = _age;
    final interp = interpretTdsc(ageMonths: age, answers: _answers);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TDSC Assistant'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          if (_answers.isNotEmpty)
            IconButton(
              tooltip: 'Reset assessment',
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () => setState(_answers.clear),
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: _onMenuSelect,
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'classic',
                child: ListTile(
                  leading: Icon(Icons.palette_outlined),
                  title: Text('Classic TDSC colours'),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              PopupMenuItem(
                value: 'fullChart',
                child: ListTile(
                  leading: Icon(Icons.bar_chart_rounded),
                  title: Text('Full reference chart'),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              PopupMenuItem(
                value: 'howTo',
                child: ListTile(
                  leading: Icon(Icons.menu_book_outlined),
                  title: Text('How to interpret'),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 32),
        children: [
          _howToCard(cs),
          const SizedBox(height: 14),
          _ageCard(cs),
          const SizedBox(height: 14),
          _riskHero(cs, interp),
          const SizedBox(height: 12),
          _quickActions(cs, interp),
          const SizedBox(height: 14),
          _graphCard(cs, interp),
          const SizedBox(height: 14),
          if (interp.delayed.isNotEmpty) ...[
            _section(
              cs,
              accent: _kDelayed,
              icon: Icons.error_outline_rounded,
              title: 'Delayed milestones',
              count: interp.delayed.length,
              subtitle:
                  'Bar lies completely past the age line and the child has not achieved it.',
              children: [
                for (final it in interp.delayed)
                  _milestoneTile(cs, it, interp, accent: _kDelayed),
              ],
            ),
            const SizedBox(height: 12),
          ],
          if (interp.needsAssessment.isNotEmpty) ...[
            _section(
              cs,
              accent: _kNeedsAsmt,
              icon: Icons.help_outline_rounded,
              title: 'Needs assessment',
              count: interp.needsAssessment.length,
              subtitle:
                  'Expected by this age but not yet tested — elicit each before concluding.',
              children: [
                for (final it in interp.needsAssessment)
                  _milestoneTile(cs, it, interp, accent: _kNeedsAsmt),
              ],
            ),
            const SizedBox(height: 12),
          ],
          if (interp.emerging.isNotEmpty) ...[
            _section(
              cs,
              accent: _kEmerging,
              icon: Icons.trending_up_rounded,
              title: 'Emerging milestones',
              count: interp.emerging.length,
              subtitle:
                  'Bar still crosses the age line — may normally appear later, not a delay yet.',
              children: [
                for (final it in interp.emerging)
                  _milestoneTile(cs, it, interp, accent: _kEmerging),
              ],
            ),
            const SizedBox(height: 12),
          ],
          if (interp.expected.isNotEmpty) ...[
            _expandableSection(
              cs,
              accent: _kAchieved,
              icon: Icons.check_circle_outline_rounded,
              title: 'Expected for age',
              count: interp.expected.length,
              subtitle:
                  '${interp.expected.where((e) => statusFor(e, _answers) == TdscStatus.achieved).length} of ${interp.expected.length} achieved',
              expanded: _showAchieved,
              onToggle: () => setState(() => _showAchieved = !_showAchieved),
              children: [
                for (final it in interp.expected)
                  _milestoneTile(cs, it, interp, accent: _kAchieved),
              ],
            ),
            const SizedBox(height: 12),
          ],
          if (interp.future.isNotEmpty) ...[
            _expandableSection(
              cs,
              accent: _kFuture,
              icon: Icons.schedule_rounded,
              title: 'Future milestones',
              count: interp.future.length,
              subtitle: 'Too early to expect — listed for reference only.',
              expanded: _showFuture,
              onToggle: () => setState(() => _showFuture = !_showFuture),
              children: [
                for (final it in interp.future)
                  _milestoneTile(cs, it, interp, accent: _kFuture),
              ],
            ),
            const SizedBox(height: 12),
          ],
          _recommendationCard(cs, interp),
          const SizedBox(height: 12),
          _disclaimer(cs),
        ],
      ),
    );
  }

  // ── Menu actions ───────────────────────────────────────────────────────
  void _onMenuSelect(String key) {
    switch (key) {
      case 'classic':
        setState(() => _classicMode = !_classicMode);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content: Text(
              _classicMode
                  ? 'Switched to classic TDSC colours.'
                  : 'Switched back to status-aware colours.',
            ),
          ),
        );
      case 'fullChart':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const TdscChartView()),
        );
      case 'howTo':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const TdscInterpretationScreen()),
        );
    }
  }

  // ── How to use (intro) ────────────────────────────────────────────────
  Widget _howToCard(ColorScheme cs) {
    return _frame(
      cs,
      borderColor: _kCursor,
      tint: _kCursor.withValues(alpha: 0.04),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline_rounded,
                    size: 18, color: _kCursor),
                const SizedBox(width: 8),
                Text(
                  'How to use this screen',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _step(cs, '1', 'Set the child\'s age on the slider below.'),
            _step(
              cs,
              '2',
              'Tap the green “Mark all expected as achieved” button — that ticks every milestone the child should already have done.',
            ),
            _step(
              cs,
              '3',
              'On the bars below, flip ✓ to ✗ for any milestone the child has NOT yet achieved.',
            ),
            _step(
              cs,
              '4',
              'Read the verdict + recommendation card. Two-or-more red items past their bar = refer for full assessment.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _step(ColorScheme cs, String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: _kCursor,
              borderRadius: BorderRadius.circular(11),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                text,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface.withValues(alpha: 0.85),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Age card ───────────────────────────────────────────────────────────
  Widget _ageCard(ColorScheme cs) {
    return _frame(
      cs,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.cake_outlined, size: 16, color: cs.primary),
                const SizedBox(width: 6),
                Text(
                  "Child's age",
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                      letterSpacing: 0.3),
                ),
                const Spacer(),
                Text(
                  '${_chronAge.toStringAsFixed(0)} mo chrono',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Slider(
              value: _chronAge.clamp(0, 72),
              min: 0,
              max: 72,
              divisions: 72,
              label: '${_chronAge.toStringAsFixed(0)} mo',
              onChanged: (v) => setState(() => _chronAge = v),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final m in const [3, 6, 9, 12, 18, 24, 36, 48, 60, 72])
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(
                          m < 12
                              ? '$m mo'
                              : (m % 12 == 0
                                  ? '${m ~/ 12} y'
                                  : '${(m / 12).toStringAsFixed(1)} y'),
                          style: GoogleFonts.plusJakartaSans(fontSize: 11),
                        ),
                        selected: _chronAge.toInt() == m,
                        onSelected: (_) =>
                            setState(() => _chronAge = m.toDouble()),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                ],
              ),
            ),
            if (_chronAge <= 24) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Correct for prematurity',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  Switch(
                    value: _correctForGa,
                    onChanged: (v) => setState(() => _correctForGa = v),
                  ),
                ],
              ),
              if (_correctForGa) ...[
                Row(
                  children: [
                    Text(
                      'GA at birth',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Slider(
                        value: _gaWeeks.toDouble().clamp(24, 42),
                        min: 24,
                        max: 42,
                        divisions: 18,
                        label: '$_gaWeeks wks',
                        onChanged: (v) =>
                            setState(() => _gaWeeks = v.round()),
                      ),
                    ),
                    SizedBox(
                      width: 56,
                      child: Text(
                        '$_gaWeeks wk',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _kCursor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Screen at ${_age.toStringAsFixed(1)} mo (corrected)',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: _kCursor,
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  // ── Risk hero ──────────────────────────────────────────────────────────
  Widget _riskHero(ColorScheme cs, TdscInterpretation interp) {
    final (bg, fg, icon) = _verdictPalette(interp);
    final eyebrow = interp.delayed.isNotEmpty
        ? interp.risk.label
        : (interp.needsAssessment.isNotEmpty ? 'INCOMPLETE' : 'LOW RISK');
    return _frame(
      cs,
      borderColor: bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coloured top stripe — the only saturated area
          Container(
            color: bg,
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            child: Row(
              children: [
                Icon(icon, color: fg, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    eyebrow,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: fg,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body — sits on cs.surface so the interpretation text is legible
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  interp.headline,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  interp.oneLineInterpretation,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _stat(cs, 'Expected', interp.expected.length, _kAchieved),
                    _stat(cs, 'Achieved', interp.achieved.length, _kAchieved),
                    _stat(cs, 'Delayed', interp.delayed.length, _kDelayed),
                    _stat(cs, 'Emerging', interp.emerging.length, _kEmerging),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color, IconData) _verdictPalette(TdscInterpretation interp) {
    if (interp.delayed.isEmpty && interp.needsAssessment.isEmpty) {
      return (_kAchieved, Colors.white, Icons.check_circle_rounded);
    }
    if (interp.delayed.isEmpty) {
      return (_kNeedsAsmt, Colors.white, Icons.help_outline_rounded);
    }
    return (_kDelayed, Colors.white, Icons.error_rounded);
  }

  Widget _stat(ColorScheme cs, String label, int value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: cs.onSurfaceVariant,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Quick actions ──────────────────────────────────────────────────────
  Widget _quickActions(ColorScheme cs, TdscInterpretation interp) {
    final expectedCount = interp.expected.length;
    final hasAnyAnswer = _answers.isNotEmpty;
    if (expectedCount == 0 && !hasAnyAnswer) return const SizedBox.shrink();
    return Row(
      children: [
        if (expectedCount > 0)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _markAllExpectedAchieved,
              icon: const Icon(Icons.done_all_rounded, size: 16),
              label: Text(
                'Mark all $expectedCount expected as achieved',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kAchieved,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
            ),
          ),
        if (hasAnyAnswer) ...[
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () => setState(_answers.clear),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: Text(
              'Reset',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ],
    );
  }

  // ── Graph card ─────────────────────────────────────────────────────────
  Widget _graphCard(ColorScheme cs, TdscInterpretation interp) {
    final age = interp.ageMonths;
    final useEldest = age >= 36;
    final items = useEldest ? kTdscEldest : kTdscYoungest;
    final filtered = _domainFilter == null
        ? items
        : items.where((e) => e.domain == _domainFilter).toList();
    final minMo = useEldest ? 36.0 : 1.0;
    final maxMo = useEldest ? 72.0 : 34.0;
    return _frame(
      cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Row(
              children: [
                Icon(Icons.insights_rounded, size: 16, color: cs.primary),
                const SizedBox(width: 6),
                Text(
                  useEldest ? 'TDSC 3 – 6 years' : 'TDSC 0 – 3 years',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                    letterSpacing: 0.3,
                  ),
                ),
                const Spacer(),
                if (_classicMode)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _kClassicLate.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'CLASSIC',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: _kClassicLate,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Domain filter chips
          SizedBox(
            height: 38,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.horizontal,
              children: [
                _domainChip(cs, label: 'All', selected: _domainFilter == null,
                    onTap: () => setState(() => _domainFilter = null)),
                for (final d in TdscDomain.values)
                  _domainChip(
                    cs,
                    label: kTdscDomainInfo[d]!.shortLabel,
                    color: kTdscDomainInfo[d]!.color,
                    icon: kTdscDomainInfo[d]!.icon,
                    selected: _domainFilter == d,
                    onTap: () => setState(() => _domainFilter = d),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // The chart
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 12, 12),
            child: _chart(
              cs,
              items: filtered,
              minMo: minMo,
              maxMo: maxMo,
              age: age,
              interp: interp,
            ),
          ),
          // Legend
          _legend(cs),
        ],
      ),
    );
  }

  Widget _domainChip(
    ColorScheme cs, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
    Color? color,
    IconData? icon,
  }) {
    final fg = color ?? cs.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? fg : fg.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: fg.withValues(alpha: selected ? 1 : 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 13, color: selected ? Colors.white : fg),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: selected ? Colors.white : fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chart(
    ColorScheme cs, {
    required List<TdscItem> items,
    required double minMo,
    required double maxMo,
    required double age,
    required TdscInterpretation interp,
  }) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'No items in this domain on the current chart.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: cs.onSurfaceVariant,
          ),
        ),
      );
    }
    const labelWidth = 132.0;
    const rowH = 26.0;
    final span = maxMo - minMo;
    final ageVisible = age >= minMo && age <= maxMo;

    return LayoutBuilder(
      builder: (ctx, cons) {
        final chartW = cons.maxWidth - labelWidth - 6;
        if (chartW <= 60) return const SizedBox.shrink();
        final cursorX = ageVisible ? (age - minMo) / span * chartW : -1.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...items.map((it) {
              final bucket = bucketFor(it, age);
              final status = statusFor(it, _answers);
              final color = _barColor(it, bucket, status);
              final left = ((it.ageStart - minMo) / span * chartW)
                  .clamp(0.0, chartW);
              final right =
                  ((it.ageEnd - minMo) / span * chartW).clamp(0.0, chartW);
              final w = (right - left).clamp(2.0, chartW);
              return SizedBox(
                height: rowH,
                child: Row(
                  children: [
                    SizedBox(
                      width: labelWidth,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(
                          '${it.number}. ${it.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: status == TdscStatus.notTested
                                ? FontWeight.w600
                                : FontWeight.w800,
                            color: cs.onSurface
                                .withValues(alpha: bucket == TdscBucket.future ? 0.55 : 1),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _editMilestone(it),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Baseline grid
                            Positioned(
                              left: 0,
                              right: 0,
                              top: rowH / 2,
                              child: Container(
                                height: 1,
                                color: cs.outlineVariant
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                            // The bar
                            Positioned(
                              left: left,
                              width: w,
                              top: 5,
                              height: rowH - 10,
                              child: _classicMode
                                  ? _classicBar(w)
                                  : _modernBar(color, status),
                            ),
                            // Status icon
                            if (status != TdscStatus.notTested && !_classicMode)
                              Positioned(
                                left: right + 2,
                                top: rowH / 2 - 7,
                                child: Icon(
                                  status == TdscStatus.achieved
                                      ? Icons.check_circle_rounded
                                      : Icons.cancel_rounded,
                                  color: status == TdscStatus.achieved
                                      ? _kAchieved
                                      : _kDelayed,
                                  size: 14,
                                ),
                              ),
                            // Cursor segment
                            if (cursorX >= 0)
                              Positioned(
                                left: cursorX - 1,
                                top: 0,
                                bottom: 0,
                                child: IgnorePointer(
                                  child: Container(
                                    width: 2,
                                    color: _kCursor,
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
            }),
            // Axis
            Padding(
              padding: const EdgeInsets.only(left: labelWidth, top: 4),
              child: SizedBox(
                height: 18,
                child: LayoutBuilder(
                  builder: (ctx, cc) {
                    final w = cc.maxWidth;
                    final ticks = <int>[];
                    final step = span <= 36 ? 4 : 6;
                    for (int m = minMo.toInt();
                        m <= maxMo.toInt();
                        m += step) {
                      ticks.add(m);
                    }
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 1.2,
                          color: cs.onSurface.withValues(alpha: 0.4),
                        ),
                        for (final t in ticks)
                          Positioned(
                            left: ((t - minMo) / span * w) - 8,
                            top: 2,
                            child: SizedBox(
                              width: 16,
                              child: Column(
                                children: [
                                  Container(
                                    width: 1,
                                    height: 4,
                                    color: cs.onSurface
                                        .withValues(alpha: 0.5),
                                  ),
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
                            left: cursorX - 5,
                            top: -2,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: _kCursor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _modernBar(Color color, TdscStatus status) {
    return Container(
      decoration: BoxDecoration(
        color: status == TdscStatus.achieved
            ? color
            : color.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: color, width: 0.8),
      ),
    );
  }

  Widget _classicBar(double width) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(color: _kClassicEarly),
        ),
        Expanded(
          flex: 3,
          child: Container(color: _kClassicLate),
        ),
      ],
    );
  }

  Widget _legend(ColorScheme cs) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Always-on classic brown / orange explainer — the original
          // TDSC bar segments are what every paediatric textbook prints.
          Text(
            'Reading the bars (classic TDSC)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w800,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          _legendRow(
            cs,
            swatch: _kClassicEarly,
            title: 'Brown — earliest acquisition window',
            body:
                'Some children begin doing the milestone in this stretch. Failing it here is normal.',
          ),
          const SizedBox(height: 6),
          _legendRow(
            cs,
            swatch: _kClassicLate,
            title: 'Orange — later acquisition window',
            body:
                'Most normal children achieve the milestone before the bar ends. By the right edge ≈ 97 % should pass.',
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: _kCursor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(Icons.priority_high_rounded,
                    size: 14, color: _kCursor),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Bar fully past the age line + Not Achieved = delay (refer).',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: _kCursor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _classicMode ? 'Classic mode ON' : 'Status overlay (modern mode)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w800,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _legendDot(_kAchieved, 'Achieved'),
              _legendDot(_kDelayed, 'Delayed'),
              _legendDot(_kNeedsAsmt, 'Needs asmt'),
              _legendDot(_kEmerging, 'Emerging'),
              _legendDot(_kFuture, 'Future'),
              _legendDot(_kCursor, 'Age line'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendRow(
    ColorScheme cs, {
    required Color swatch,
    required String title,
    required String body,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 3),
          width: 18,
          height: 10,
          decoration: BoxDecoration(
            color: swatch,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              Text(
                body,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _legendDot(Color c, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
              BoxDecoration(color: c, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: c,
          ),
        ),
      ],
    );
  }

  // ── Generic section card ──────────────────────────────────────────────
  Widget _section(
    ColorScheme cs, {
    required Color accent,
    required IconData icon,
    required String title,
    required int count,
    required String subtitle,
    required List<Widget> children,
  }) {
    return _frame(
      cs,
      borderColor: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: accent.withValues(alpha: 0.08),
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              children: [
                Icon(icon, size: 18, color: accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$count',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                color: cs.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 4),
          ...children,
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _expandableSection(
    ColorScheme cs, {
    required Color accent,
    required IconData icon,
    required String title,
    required int count,
    required String subtitle,
    required bool expanded,
    required VoidCallback onToggle,
    required List<Widget> children,
  }) {
    return _frame(
      cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$count',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: accent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: cs.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...children,
          if (expanded) const SizedBox(height: 6),
        ],
      ),
    );
  }

  // ── Status setter (used by inline toggles + sheet) ────────────────────
  void _setStatus(TdscItem item, TdscStatus s) {
    setState(() {
      if (s == TdscStatus.notTested) {
        _answers.remove(stableId(item));
      } else {
        _answers[stableId(item)] = s;
      }
    });
  }

  /// Bulk: mark every EXPECTED milestone as achieved at the current age.
  /// Typical "child has hit everything expected, no concerns" workflow —
  /// flip the few they failed afterwards.
  void _markAllExpectedAchieved() {
    final age = _age;
    setState(() {
      for (final it in kTdscAll) {
        if (bucketFor(it, age) == TdscBucket.expected) {
          _answers[stableId(it)] = TdscStatus.achieved;
        }
      }
    });
  }

  // ── Milestone tile ────────────────────────────────────────────────────
  Widget _milestoneTile(
    ColorScheme cs,
    TdscItem item,
    TdscInterpretation interp, {
    required Color accent,
  }) {
    final status = statusFor(item, _answers);
    final domain = kTdscDomainInfo[item.domain]!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
        child: Row(
          children: [
            // Icon + name (tap to open prompt sheet)
            Expanded(
              child: InkWell(
                onTap: () => _editMilestone(item),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: domain.color.withValues(alpha: 0.13),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            Icon(domain.icon, color: domain.color, size: 15),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: cs.onSurface,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              '${domain.shortLabel} · ${item.ageStart.toStringAsFixed(0)}–${item.ageEnd.toStringAsFixed(0)} mo',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Inline 3-button toggle — direct set, no sheet
            const SizedBox(width: 6),
            _inlineToggle(item, status),
          ],
        ),
      ),
    );
  }

  Widget _inlineToggle(TdscItem item, TdscStatus status) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _toggleBtn(
          icon: Icons.check_rounded,
          color: _kAchieved,
          selected: status == TdscStatus.achieved,
          tooltip: 'Achieved',
          onTap: () => _setStatus(item, TdscStatus.achieved),
        ),
        const SizedBox(width: 4),
        _toggleBtn(
          icon: Icons.close_rounded,
          color: _kDelayed,
          selected: status == TdscStatus.notAchieved,
          tooltip: 'Not yet',
          onTap: () => _setStatus(item, TdscStatus.notAchieved),
        ),
        const SizedBox(width: 4),
        _toggleBtn(
          icon: Icons.remove_rounded,
          color: _kFuture,
          selected: status == TdscStatus.notTested,
          tooltip: 'Clear / Untested',
          onTap: () => _setStatus(item, TdscStatus.notTested),
        ),
      ],
    );
  }

  Widget _toggleBtn({
    required IconData icon,
    required Color color,
    required bool selected,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: selected ? color : color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? color : color.withValues(alpha: 0.35),
              width: selected ? 1.4 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 16,
            color: selected ? Colors.white : color,
          ),
        ),
      ),
    );
  }

  // ── Recommendation card ───────────────────────────────────────────────
  Widget _recommendationCard(ColorScheme cs, TdscInterpretation interp) {
    if (interp.recommendations.isEmpty) return const SizedBox.shrink();
    final positive = interp.delayed.isNotEmpty;
    final accent = positive
        ? _kDelayed
        : (interp.needsAssessment.isNotEmpty ? _kNeedsAsmt : _kAchieved);
    return _frame(
      cs,
      borderColor: accent,
      tint: accent.withValues(alpha: 0.04),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_services_outlined, color: accent, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Clinical recommendation',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final r in interp.recommendations)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: 8),
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        r,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          height: 1.45,
                          color: cs.onSurface.withValues(alpha: 0.85),
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

  Widget _disclaimer(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              size: 14, color: cs.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'TDSC is a screen, not a diagnostic test. Source: Nair MK et al., Indian Pediatrics 2009 + 2013.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: cs.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _frame(ColorScheme cs,
      {required Widget child, Color? tint, Color? borderColor}) {
    return Container(
      decoration: BoxDecoration(
        color: tint ?? cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: (borderColor ?? cs.outlineVariant)
              .withValues(alpha: borderColor == null ? 0.55 : 0.3),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  // ── Milestone editor sheet ────────────────────────────────────────────
  void _editMilestone(TdscItem item) {
    final cs = Theme.of(context).colorScheme;
    final domain = kTdscDomainInfo[item.domain]!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            final id = stableId(item);
            final current = _answers[id] ?? TdscStatus.notTested;
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 32,
                        height: 4,
                        decoration: BoxDecoration(
                          color: cs.outline,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: domain.color.withValues(alpha: 0.13),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(domain.icon, color: domain.color, size: 13),
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
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.straighten_rounded,
                              size: 14, color: cs.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Window ${item.ageStart.toStringAsFixed(0)} – ${item.ageEnd.toStringAsFixed(0)} mo',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'How to elicit',
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
                        fontSize: 12.5,
                        height: 1.5,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _statusButton(
                          label: 'Achieved',
                          icon: Icons.check_circle_rounded,
                          color: _kAchieved,
                          selected: current == TdscStatus.achieved,
                          onTap: () {
                            setState(() =>
                                _answers[id] = TdscStatus.achieved);
                            setLocal(() {});
                          },
                        ),
                        const SizedBox(width: 8),
                        _statusButton(
                          label: 'Not yet',
                          icon: Icons.cancel_rounded,
                          color: _kDelayed,
                          selected: current == TdscStatus.notAchieved,
                          onTap: () {
                            setState(() =>
                                _answers[id] = TdscStatus.notAchieved);
                            setLocal(() {});
                          },
                        ),
                        const SizedBox(width: 8),
                        _statusButton(
                          label: 'Untested',
                          icon: Icons.help_outline_rounded,
                          color: _kFuture,
                          selected: current == TdscStatus.notTested,
                          onTap: () {
                            setState(() => _answers.remove(id));
                            setLocal(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Done',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _statusButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 60,
          decoration: BoxDecoration(
            color: selected ? color : color.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color, width: 1.2),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: selected ? Colors.white : color, size: 18),
              const SizedBox(height: 2),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: selected ? Colors.white : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
