import 'package:flutter/material.dart';

import '../../widgets/list_search_field.dart';
import 'who_chart_screen.dart';

const Color _boyBlue  = Color(0xFF1565C0);
const Color _girlPink = Color(0xFFAD1457);

class WhoChartSelectionScreen extends StatefulWidget {
  const WhoChartSelectionScreen({super.key});

  @override
  State<WhoChartSelectionScreen> createState() =>
      _WhoChartSelectionScreenState();
}

class _WhoChartSelectionScreenState extends State<WhoChartSelectionScreen> {
  final TextEditingController _searchCtl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  List<_ChartOption> _match(List<_ChartOption> opts) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return opts;
    return opts
        .where((o) =>
            o.title.toLowerCase().contains(q) ||
            o.range.toLowerCase().contains(q) ||
            o.chartType.toLowerCase().contains(q))
        .toList();
  }

  static const List<_ChartOption> _boysOptions = [
    _ChartOption(
      icon: Icons.monitor_weight,
      title: 'Weight for Age',
      range: '0–5 yrs',
      chartType: 'wfa',
      gender: 'boys',
    ),
    _ChartOption(
      icon: Icons.height,
      title: 'Length/Height for Age',
      range: '0–5 yrs',
      chartType: 'lhfa',
      gender: 'boys',
    ),
    _ChartOption(
      icon: Icons.circle_outlined,
      title: 'Head Circumference',
      range: '0–5 yrs',
      chartType: 'hcfa',
      gender: 'boys',
    ),
    _ChartOption(
      icon: Icons.calculate,
      title: 'BMI for Age',
      range: '0–5 yrs',
      chartType: 'bfa',
      gender: 'boys',
    ),
    _ChartOption(
      icon: Icons.straighten,
      title: 'Weight for Length',
      range: '0–2 yrs',
      chartType: 'wfl',
      gender: 'boys',
    ),
    _ChartOption(
      icon: Icons.swap_vert,
      title: 'Weight for Height',
      range: '2–5 yrs',
      chartType: 'wfh',
      gender: 'boys',
    ),
  ];

  static const List<_ChartOption> _girlsOptions = [
    _ChartOption(
      icon: Icons.monitor_weight,
      title: 'Weight for Age',
      range: '0–5 yrs',
      chartType: 'wfa',
      gender: 'girls',
    ),
    _ChartOption(
      icon: Icons.height,
      title: 'Length/Height for Age',
      range: '0–5 yrs',
      chartType: 'lhfa',
      gender: 'girls',
    ),
    _ChartOption(
      icon: Icons.circle_outlined,
      title: 'Head Circumference',
      range: '0–5 yrs',
      chartType: 'hcfa',
      gender: 'girls',
    ),
    _ChartOption(
      icon: Icons.calculate,
      title: 'BMI for Age',
      range: '0–5 yrs',
      chartType: 'bfa',
      gender: 'girls',
    ),
    _ChartOption(
      icon: Icons.straighten,
      title: 'Weight for Length',
      range: '0–2 yrs',
      chartType: 'wfl',
      gender: 'girls',
    ),
    _ChartOption(
      icon: Icons.swap_vert,
      title: 'Weight for Height',
      range: '2–5 yrs',
      chartType: 'wfh',
      gender: 'girls',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final boys = _match(_boysOptions);
    final girls = _match(_girlsOptions);
    final total = _boysOptions.length + _girlsOptions.length;
    final searching = _query.trim().isNotEmpty;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('WHO Growth Charts 0–5 Years'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Chart Type',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 8),
            ListSearchField(
              controller: _searchCtl,
              hintText: 'Search $total WHO charts…',
              onChanged: (v) => setState(() => _query = v),
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            ),

            if (searching && boys.isEmpty && girls.isEmpty)
              ListSearchEmptyState(query: _searchCtl.text, noun: 'charts'),

            // ── Boys section ───────────────────────────────────────────────
            if (boys.isNotEmpty) ...[
            _SectionHeader(
              icon: Icons.boy,
              label: 'Boys',
              color: _boyBlue,
            ),
            const SizedBox(height: 10),
            _ChartGrid(
              options: boys,
              accentColor: _boyBlue,
              onTap: (opt) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WhoChartScreen(
                    chartType: opt.chartType,
                    gender: opt.gender,
                    title: opt.title,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ],

            // ── Girls section ──────────────────────────────────────────────
            if (girls.isNotEmpty) ...[
            _SectionHeader(
              icon: Icons.girl,
              label: 'Girls',
              color: _girlPink,
            ),
            const SizedBox(height: 10),
            _ChartGrid(
              options: girls,
              accentColor: _girlPink,
              onTap: (opt) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WhoChartScreen(
                    chartType: opt.chartType,
                    gender: opt.gender,
                    title: opt.title,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ],

            // ── Disclaimer ─────────────────────────────────────────────────
            Text(
              'WHO Child Growth Standards 2006',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: cs.onSurface.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chart grid ────────────────────────────────────────────────────────────────

class _ChartGrid extends StatelessWidget {
  final List<_ChartOption> options;
  final Color accentColor;
  final void Function(_ChartOption) onTap;

  const _ChartGrid({
    required this.options,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        // Fixed height instead of childAspectRatio: aspect ratio scales
        // height with width, so on wide/web viewports these cards were
        // ballooning to hundreds of pixels tall for the same ~110px of
        // actual content (icon + 2-line title + range). A fixed extent
        // keeps card height constant no matter how wide the screen is.
        mainAxisExtent: 120,
      ),
      itemCount: options.length,
      itemBuilder: (context, i) {
        final opt = options[i];
        return Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          elevation: 1,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onTap(opt),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(opt.icon, color: accentColor, size: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    opt.title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    opt.range,
                    style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurface.withValues(alpha: 0.5)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Data class ────────────────────────────────────────────────────────────────

class _ChartOption {
  final IconData icon;
  final String title;
  final String range;
  final String chartType;
  final String gender;

  const _ChartOption({
    required this.icon,
    required this.title,
    required this.range,
    required this.chartType,
    required this.gender,
  });
}
