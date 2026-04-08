import 'package:flutter/material.dart';

// ── Data models ───────────────────────────────────────────────────────────────

class _Option {
  final int score;
  final String label;
  const _Option(this.score, this.label);
}

class _Param {
  final String id;
  final String name;
  final List<_Option> options;
  const _Param({required this.id, required this.name, required this.options});
}

// ── Parameter definitions ─────────────────────────────────────────────────────

const List<_Param> _neuroParams = [
  _Param(id: 'posture', name: 'Posture', options: [
    _Option(-1, 'Extended'),
    _Option(0, 'Slight flexion'),
    _Option(1, 'Moderate flexion'),
    _Option(2, 'Full flexion'),
    _Option(3, 'Hyperflexion'),
    _Option(4, 'Marked flexion'),
    _Option(5, 'Tight flexion'),
  ]),
  _Param(id: 'sq_window', name: 'Square Window\n(Wrist)', options: [
    _Option(-1, '>90°'),
    _Option(0, '90°'),
    _Option(1, '60°'),
    _Option(2, '45°'),
    _Option(3, '30°'),
    _Option(4, '0°'),
    _Option(5, 'Negative angle'),
  ]),
  _Param(id: 'arm_recoil', name: 'Arm Recoil', options: [
    _Option(-1, 'No recoil'),
    _Option(0, 'Slow recoil'),
    _Option(1, 'Slight recoil'),
    _Option(2, 'Moderate recoil'),
    _Option(3, 'Brisk recoil'),
    _Option(4, 'Full recoil'),
    _Option(5, 'Instant recoil'),
  ]),
  _Param(id: 'popliteal', name: 'Popliteal Angle', options: [
    _Option(-1, '>180°'),
    _Option(0, '180°'),
    _Option(1, '160°'),
    _Option(2, '140°'),
    _Option(3, '120°'),
    _Option(4, '100°'),
    _Option(5, '<90°'),
  ]),
  _Param(id: 'scarf', name: 'Scarf Sign', options: [
    _Option(-1, 'Elbow beyond midline'),
    _Option(0, 'Elbow at midline'),
    _Option(1, 'Between midline & nipple'),
    _Option(2, 'At nipple line'),
    _Option(3, 'Before nipple'),
    _Option(4, 'Near shoulder'),
    _Option(5, 'Does not reach midline'),
  ]),
  _Param(id: 'heel_ear', name: 'Heel to Ear', options: [
    _Option(-1, 'Heel easily to ear'),
    _Option(0, 'Very close'),
    _Option(1, 'Close with resistance'),
    _Option(2, 'Moderate resistance'),
    _Option(3, 'Marked resistance'),
    _Option(4, 'Strong resistance'),
    _Option(5, 'Cannot approach'),
  ]),
];

const List<_Param> _physicalParams = [
  _Param(id: 'skin', name: 'Skin', options: [
    _Option(-1, 'Sticky, transparent'),
    _Option(0, 'Gelatinous'),
    _Option(1, 'Smooth pink'),
    _Option(2, 'Superficial peeling'),
    _Option(3, 'Cracking'),
    _Option(4, 'Parchment'),
    _Option(5, 'Leathery'),
  ]),
  _Param(id: 'lanugo', name: 'Lanugo', options: [
    _Option(-1, 'None'),
    _Option(0, 'Sparse'),
    _Option(1, 'Abundant'),
    _Option(2, 'Thinning'),
    _Option(3, 'Bald areas'),
    _Option(4, 'Mostly bald'),
    _Option(5, 'Absent'),
  ]),
  _Param(id: 'plantar', name: 'Plantar Surface', options: [
    _Option(-1, 'No creases'),
    _Option(0, 'Faint marks'),
    _Option(1, 'Anterior creases'),
    _Option(2, 'Two-thirds creases'),
    _Option(3, 'Full creases'),
    _Option(4, 'Deep creases'),
    _Option(5, 'Very deep creases'),
  ]),
  _Param(id: 'breast', name: 'Breast', options: [
    _Option(-1, 'Imperceptible'),
    _Option(0, 'Barely visible'),
    _Option(1, 'Flat areola'),
    _Option(2, 'Stippled areola'),
    _Option(3, 'Raised areola'),
    _Option(4, 'Full bud'),
    _Option(5, 'Large bud'),
  ]),
  _Param(id: 'eye_ear', name: 'Eye / Ear', options: [
    _Option(-1, 'Fused lids'),
    _Option(0, 'Lids open, flat ear'),
    _Option(1, 'Soft ear'),
    _Option(2, 'Some cartilage'),
    _Option(3, 'Well curved'),
    _Option(4, 'Stiff ear'),
    _Option(5, 'Thick cartilage'),
  ]),
];

// Genitals — shown separately (Male + Female); exactly one must be selected
const _Param _genitalsMale = _Param(
  id: 'gen_male',
  name: 'Genitals — Male',
  options: [
    _Option(-1, 'Scrotum flat, smooth'),
    _Option(0, 'Scrotum empty, faint rugae'),
    _Option(1, 'Testes in upper canal, rare rugae'),
    _Option(2, 'Testes descending, few rugae'),
    _Option(3, 'Testes down, good rugae'),
    _Option(4, 'Testes pendulous, deep rugae'),
    _Option(5, 'Deeply rugated'),
  ],
);

const _Param _genitalsFemale = _Param(
  id: 'gen_female',
  name: 'Genitals — Female',
  options: [
    _Option(-1, 'Clitoris prominent, labia flat'),
    _Option(0, 'Clitoris prominent, small labia minora'),
    _Option(1, 'Clitoris prominent, labia minora enlarging'),
    _Option(2, 'Majora & minora equally prominent'),
    _Option(3, 'Majora large, minora small'),
    _Option(4, 'Majora covers clitoris & minora'),
    _Option(5, 'Majora large, minora covered'),
  ],
);

// All standard (non-genitals) param IDs — 11 params
final _standardIds = [
  ..._neuroParams.map((p) => p.id),
  ..._physicalParams.map((p) => p.id),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class ModifiedBallardScreen extends StatefulWidget {
  const ModifiedBallardScreen({super.key});

  @override
  State<ModifiedBallardScreen> createState() => _ModifiedBallardScreenState();
}

class _ModifiedBallardScreenState extends State<ModifiedBallardScreen> {
  // null = not selected
  final Map<String, int?> _sel = {};

  void _select(String id, int score) {
    setState(() {
      _sel[id] = score;
      // Mutual exclusion for genitals
      if (id == 'gen_male')   _sel.remove('gen_female');
      if (id == 'gen_female') _sel.remove('gen_male');
    });
  }

  void _reset() {
    setState(() => _sel.clear());
  }

  // ── Derived ───────────────────────────────────────────────────────────────

  bool get _genitalsSelected =>
      _sel.containsKey('gen_male') || _sel.containsKey('gen_female');

  bool get _isComplete {
    final stdDone = _standardIds.every((id) => _sel.containsKey(id));
    return stdDone && _genitalsSelected;
  }

  int get _totalScore {
    int sum = 0;
    for (final v in _sel.values) {
      if (v != null) sum += v;
    }
    return sum;
  }

  double get _ga => (2 * _totalScore + 120) / 5;

  String _category(double ga) {
    if (ga < 28) return 'Extremely Preterm';
    if (ga < 32) return 'Very Preterm';
    if (ga < 37) return 'Moderate to Late Preterm';
    if (ga <= 42) return 'Term';
    return 'Post-term';
  }

  Color _categoryColor(double ga, ColorScheme cs) {
    if (ga < 28) return const Color(0xFFB71C1C);
    if (ga < 32) return const Color(0xFFE64A19);
    if (ga < 37) return const Color(0xFFE65100);
    if (ga <= 42) return const Color(0xFF2E7D32);
    return const Color(0xFF6A1B9A);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modified Ballard Score'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: _reset,
            icon: Icon(Icons.refresh, size: 18, color: cs.error),
            label: Text('Reset',
                style: TextStyle(
                    color: cs.error, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      bottomNavigationBar: _ResultBar(
        isComplete: _isComplete,
        totalScore: _totalScore,
        ga: _isComplete ? _ga : null,
        category: _isComplete ? _category(_ga) : null,
        categoryColor: _isComplete ? _categoryColor(_ga, cs) : null,
        cs: cs,
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Neuromuscular Maturity ──────────────────────────────────
              _SectionHeader(
                title: 'Neuromuscular Maturity',
                count: _neuroParams
                    .where((p) => _sel.containsKey(p.id))
                    .length,
                total: _neuroParams.length,
                cs: cs,
              ),
              const SizedBox(height: 10),
              ..._neuroParams.map((p) => _ParamCard(
                    param: p,
                    selected: _sel[p.id],
                    cs: cs,
                    onSelect: (score) => _select(p.id, score),
                  )),

              const SizedBox(height: 18),

              // ── Physical Maturity ───────────────────────────────────────
              _SectionHeader(
                title: 'Physical Maturity',
                count: _physicalParams
                        .where((p) => _sel.containsKey(p.id))
                        .length +
                    (_genitalsSelected ? 1 : 0),
                total: _physicalParams.length + 1,
                cs: cs,
              ),
              const SizedBox(height: 10),
              ..._physicalParams.map((p) => _ParamCard(
                    param: p,
                    selected: _sel[p.id],
                    cs: cs,
                    onSelect: (score) => _select(p.id, score),
                  )),

              // Genitals note
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  Container(
                    width: 3, height: 12,
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Genitals — select one sex only',
                    style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withValues(alpha: 0.5)),
                  ),
                ]),
              ),

              _ParamCard(
                param: _genitalsMale,
                selected: _sel['gen_male'],
                cs: cs,
                onSelect: (score) => _select('gen_male', score),
              ),
              _ParamCard(
                param: _genitalsFemale,
                selected: _sel['gen_female'],
                cs: cs,
                onSelect: (score) => _select('gen_female', score),
              ),

              const SizedBox(height: 8),

              // Reference
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.onSurface.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: cs.outline.withValues(alpha: 0.2)),
                ),
                child: Text(
                  'Reference: Ballard JL et al., Pediatrics 1991 '
                  '(Modified Ballard Score)',
                  style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurface.withValues(alpha: 0.45),
                      height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final int total;
  final ColorScheme cs;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.total,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final done = count == total;
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: done
                ? const Color(0xFF2E7D32).withValues(alpha: 0.12)
                : cs.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: done
                  ? const Color(0xFF2E7D32).withValues(alpha: 0.4)
                  : cs.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            '$count / $total',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: done
                  ? const Color(0xFF2E7D32)
                  : cs.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Parameter card ────────────────────────────────────────────────────────────

class _ParamCard extends StatelessWidget {
  final _Param param;
  final int? selected;
  final ColorScheme cs;
  final ValueChanged<int> onSelect;

  const _ParamCard({
    required this.param,
    required this.selected,
    required this.cs,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = selected != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? cs.primary.withValues(alpha: 0.45)
              : cs.outline.withValues(alpha: isDark ? 0.25 : 0.18),
          width: isSelected ? 1.4 : 1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                )
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 11, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Parameter name + selected score badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    param.name,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                      height: 1.3,
                    ),
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Score: $selected',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 9),

            // Options chips
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: param.options.map((opt) {
                final isChipSelected = selected == opt.score;
                return _OptionChip(
                  option: opt,
                  isSelected: isChipSelected,
                  cs: cs,
                  onTap: () => onSelect(opt.score),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Option chip ───────────────────────────────────────────────────────────────

class _OptionChip extends StatelessWidget {
  final _Option option;
  final bool isSelected;
  final ColorScheme cs;
  final VoidCallback onTap;

  const _OptionChip({
    required this.option,
    required this.isSelected,
    required this.cs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 88,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? cs.primary
              : cs.onSurface.withValues(alpha: isDark ? 0.07 : 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? cs.primary
                : cs.outline.withValues(alpha: isDark ? 0.3 : 0.2),
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Score number
            Text(
              option.score.toString(),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isSelected
                    ? Colors.white
                    : cs.primary,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            // Descriptor label
            Text(
              option.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.9)
                    : cs.onSurface.withValues(alpha: 0.65),
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Result bar ────────────────────────────────────────────────────────────────

class _ResultBar extends StatelessWidget {
  final bool isComplete;
  final int totalScore;
  final double? ga;
  final String? category;
  final Color? categoryColor;
  final ColorScheme cs;

  const _ResultBar({
    required this.isComplete,
    required this.totalScore,
    required this.ga,
    required this.category,
    required this.categoryColor,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(
              color: cs.outline.withValues(alpha: isDark ? 0.3 : 0.18)),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                )
              ],
      ),
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
      child: isComplete
          ? _CompletedResult(
              totalScore: totalScore,
              ga: ga!,
              category: category!,
              categoryColor: categoryColor!,
              cs: cs,
            )
          : _IncompleteResult(totalScore: totalScore, cs: cs),
    );
  }
}

class _CompletedResult extends StatelessWidget {
  final int totalScore;
  final double ga;
  final String category;
  final Color categoryColor;
  final ColorScheme cs;

  const _CompletedResult({
    required this.totalScore,
    required this.ga,
    required this.category,
    required this.categoryColor,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Total score
        _ResultPill(
          label: 'Total Score',
          value: totalScore.toString(),
          valueColor: cs.primary,
          cs: cs,
        ),
        const SizedBox(width: 14),
        // GA
        _ResultPill(
          label: 'Gest. Age',
          value: '${ga.toStringAsFixed(1)} wks',
          valueColor: cs.primary,
          cs: cs,
        ),
        const SizedBox(width: 14),
        // Category
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Category',
                style: TextStyle(
                  fontSize: 10,
                  color: cs.onSurface.withValues(alpha: 0.45),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                category,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: categoryColor,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IncompleteResult extends StatelessWidget {
  final int totalScore;
  final ColorScheme cs;

  const _IncompleteResult({required this.totalScore, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.info_outline,
            size: 18, color: cs.onSurface.withValues(alpha: 0.4)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Incomplete — select all parameters to see gestational age',
            style: TextStyle(
              fontSize: 12,
              color: cs.onSurface.withValues(alpha: 0.5),
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$totalScore',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: cs.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultPill extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final ColorScheme cs;

  const _ResultPill({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: cs.onSurface.withValues(alpha: 0.45),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
