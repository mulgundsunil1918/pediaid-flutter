// =============================================================================
// lib/screens/guides/developmental_milestones/tdsc/tdsc_smart_screen.dart
//
// Smart screen — the parent-friendly TDSC workflow.
//   1. Enter chronological age (months).
//   2. (Optional) correct for prematurity if ≤ 24 mo.
//   3. App lists every TDSC item the vertical line at that age crosses.
//   4. Examiner taps PASS / FAIL on each. The footer updates live with
//      the failed count and the "suspect for delay" verdict (≥ 2 fails).
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tdsc_data.dart';

class TdscSmartScreen extends StatefulWidget {
  const TdscSmartScreen({super.key});

  @override
  State<TdscSmartScreen> createState() => _TdscSmartScreenState();
}

class _TdscSmartScreenState extends State<TdscSmartScreen> {
  double _chronAgeMonths = 12;
  bool _correctForGa = false;
  int _gaWeeks = 40;

  /// stableId(item) -> pass state
  final Map<int, TdscPass> _answers = {};

  double get _ageForScreen {
    if (!_correctForGa) return _chronAgeMonths;
    if (_chronAgeMonths > 24) return _chronAgeMonths;
    final correctionMonths = (40 - _gaWeeks) / 4.0; // 4 weeks ≈ 1 month
    final corrected = _chronAgeMonths - correctionMonths;
    return corrected.clamp(0.0, 72.0);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final age = _ageForScreen;
    final crossed = tdscItemsAt(age);
    final result =
        scoreTdsc(ageMonths: age, answers: _answers);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TDSC — Smart Screen'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          if (_answers.isNotEmpty)
            IconButton(
              tooltip: 'Reset answers',
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () => setState(() => _answers.clear()),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
              children: [
                _ageCard(cs),
                const SizedBox(height: 14),
                _summaryStrip(cs, age, crossed.length, result),
                const SizedBox(height: 14),
                if (crossed.isEmpty)
                  _outOfRangeNotice(cs, age)
                else
                  ..._buildItemList(cs, crossed),
              ],
            ),
          ),
          _verdictBar(cs, age, result),
        ],
      ),
    );
  }

  // ── Age card ────────────────────────────────────────────────────────────
  Widget _ageCard(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Child's chronological age",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _chronAgeMonths.clamp(0, 72),
                  min: 0,
                  max: 72,
                  divisions: 72,
                  label: '${_chronAgeMonths.toStringAsFixed(0)} mo',
                  onChanged: (v) => setState(() => _chronAgeMonths = v),
                ),
              ),
              SizedBox(
                width: 84,
                child: Text(
                  '${_chronAgeMonths.toStringAsFixed(0)} mo',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
          // Quick-jump chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final m in const [3, 6, 9, 12, 18, 24, 30, 36, 48, 60, 72])
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(
                        m < 12
                            ? '$m mo'
                            : (m % 12 == 0
                                ? '${m ~/ 12} y'
                                : '${(m / 12).toStringAsFixed(1)} y'),
                        style: GoogleFonts.plusJakartaSans(fontSize: 11.5),
                      ),
                      selected: _chronAgeMonths.toInt() == m,
                      onSelected: (_) =>
                          setState(() => _chronAgeMonths = m.toDouble()),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Preterm correction
          if (_chronAgeMonths <= 24) ...[
            const Divider(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Correct for prematurity (use under 24 mo)',
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
                      fontSize: 12.5,
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
                      onChanged: (v) => setState(() => _gaWeeks = v.round()),
                    ),
                  ),
                  SizedBox(
                    width: 64,
                    child: Text(
                      '$_gaWeeks wk',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'Corrected age: ${_ageForScreen.toStringAsFixed(1)} mo  (chrono ${_chronAgeMonths.toStringAsFixed(0)} − ${((40 - _gaWeeks) / 4.0).toStringAsFixed(1)} mo)',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: cs.primary,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  // ── Summary strip ───────────────────────────────────────────────────────
  Widget _summaryStrip(
      ColorScheme cs, double age, int crossedCount, TdscScoreResult r) {
    final chartLabel = preferredChartFor(age).label;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(Icons.straighten_rounded, color: cs.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Vertical line at ${age.toStringAsFixed(1)} mo crosses $crossedCount item${crossedCount == 1 ? '' : 's'} on $chartLabel.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ),
          if (crossedCount > 0)
            _miniPill(
              label: '${r.passed}/${r.crossedTotal} passed',
              color: const Color(0xFF16A34A),
            ),
        ],
      ),
    );
  }

  Widget _miniPill({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }

  Widget _outOfRangeNotice(ColorScheme cs, double age) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.errorContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        age < 1
            ? 'TDSC begins at 1 month — choose 1 mo or older to start screening.'
            : 'No items are crossed at ${age.toStringAsFixed(1)} mo. Both charts cover 1–34 mo and 36–72 mo with a small gap at 34–36 mo.',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
        ),
      ),
    );
  }

  // ── Item list ───────────────────────────────────────────────────────────
  List<Widget> _buildItemList(ColorScheme cs, List<TdscItem> crossed) {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 6, left: 4),
        child: Text(
          'Items being screened — mark each PASS or FAIL',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
            color: cs.onSurfaceVariant,
          ),
        ),
      ),
      for (final it in crossed) _itemTile(cs, it),
    ];
  }

  Widget _itemTile(ColorScheme cs, TdscItem it) {
    final id = stableId(it);
    final p = _answers[id] ?? TdscPass.unset;
    final domain = kTdscDomainInfo[it.domain]!;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: switch (p) {
            TdscPass.pass => const Color(0xFF16A34A).withValues(alpha: 0.5),
            TdscPass.fail => const Color(0xFFDC2626).withValues(alpha: 0.5),
            _ => cs.outlineVariant.withValues(alpha: 0.55),
          },
          width: p == TdscPass.unset ? 1 : 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(domain.icon, color: domain.color, size: 16),
                const SizedBox(width: 6),
                Text(
                  '#${it.number} · ${domain.shortLabel}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: domain.color,
                    letterSpacing: 0.4,
                  ),
                ),
                const Spacer(),
                Text(
                  '${it.ageStart.toStringAsFixed(0)}–${it.ageEnd.toStringAsFixed(0)} mo',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              it.name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              it.prompt,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                height: 1.4,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _passFailButton(
                  icon: Icons.check_rounded,
                  label: 'Pass',
                  color: const Color(0xFF16A34A),
                  selected: p == TdscPass.pass,
                  onTap: () => setState(() => _answers[id] = TdscPass.pass),
                ),
                const SizedBox(width: 8),
                _passFailButton(
                  icon: Icons.close_rounded,
                  label: 'Fail',
                  color: const Color(0xFFDC2626),
                  selected: p == TdscPass.fail,
                  onTap: () => setState(() => _answers[id] = TdscPass.fail),
                ),
                const Spacer(),
                if (p != TdscPass.unset)
                  IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(Icons.replay_rounded, size: 18),
                    onPressed: () =>
                        setState(() => _answers.remove(id)),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _passFailButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: selected ? color : color.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color, width: 1.2),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? Colors.white : color,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
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

  // ── Verdict bar ─────────────────────────────────────────────────────────
  Widget _verdictBar(ColorScheme cs, double age, TdscScoreResult r) {
    Color bg;
    String headline;
    String detail;
    IconData icon;
    if (r.crossedTotal == 0) {
      bg = cs.surfaceContainerHighest;
      headline = 'Adjust age to begin screening';
      detail = 'Age is outside the chart window (1–34 mo or 36–72 mo).';
      icon = Icons.info_outline_rounded;
    } else if (r.passed + r.failed == 0) {
      bg = const Color(0xFF1565C0);
      headline = 'Tap PASS or FAIL on each item above';
      detail =
          '${r.crossedTotal} item${r.crossedTotal == 1 ? '' : 's'} to score · screening rule = 2 or more fails';
      icon = Icons.touch_app_rounded;
    } else if (r.suspect) {
      bg = const Color(0xFFDC2626);
      headline = 'SUSPECT — refer for formal assessment';
      detail =
          '${r.failed} fail${r.failed == 1 ? '' : 's'} of ${r.crossedTotal} crossed · rule met (≥ 2 fails)';
      icon = Icons.warning_rounded;
    } else if (r.unknown > 0) {
      bg = const Color(0xFFF59E0B);
      headline = 'Score incomplete';
      detail =
          '${r.failed} fail${r.failed == 1 ? '' : 's'} so far · ${r.unknown} item${r.unknown == 1 ? '' : 's'} still unmarked';
      icon = Icons.hourglass_top_rounded;
    } else {
      bg = const Color(0xFF16A34A);
      headline = 'NOT SUSPECT — reassess at next routine visit';
      detail =
          '${r.failed} fail${r.failed == 1 ? '' : 's'} of ${r.crossedTotal} crossed · below the ≥ 2 cut-off';
      icon = Icons.check_circle_rounded;
    }
    return Container(
      color: bg,
      width: double.infinity,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headline,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      detail,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.92),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
