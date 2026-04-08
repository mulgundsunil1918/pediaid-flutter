import 'package:flutter/material.dart';

// ── CAN Score — Clinical Assessment of Nutrition ─────────────────────────────
// Metcoff J. Clinical Assessment of Nutritional Status at Birth.
// Pediatric Clinics of North America 1994;41(4):875–891.
// 9 parameters · Score 1–4 per parameter · Total range 9–36
// ≥ 25 = Normal | < 25 = Malnutrition present

class CanScoreScreen extends StatefulWidget {
  const CanScoreScreen({super.key});

  @override
  State<CanScoreScreen> createState() => _CanScoreScreenState();
}

class _CanScoreScreenState extends State<CanScoreScreen>
    with SingleTickerProviderStateMixin {
  // ── State: parameter index → score (1–4) ─────────────────────────────────
  final Map<int, int> _scores = {};

  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  int get _totalScore => _scores.values.fold(0, (s, v) => s + v);
  bool get _isComplete => _scores.length == _kParams.length;

  void _setScore(int paramIdx, int value) {
    setState(() => _scores[paramIdx] = value);
    if (_isComplete) {
      _animCtrl.forward();
    } else {
      _animCtrl.reverse();
    }
  }

  void _reset() {
    setState(() => _scores.clear());
    _animCtrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('CAN Score'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_scores.isNotEmpty)
            TextButton.icon(
              onPressed: _reset,
              icon: Icon(Icons.refresh_rounded,
                  size: 16, color: cs.onPrimary.withValues(alpha: 0.85)),
              label: Text('Reset',
                  style: TextStyle(
                      color: cs.onPrimary.withValues(alpha: 0.85),
                      fontSize: 13)),
            ),
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // ── Score bar ─────────────────────────────────────────────────
            _ScoreBar(
              score: _totalScore,
              answered: _scores.length,
              total: _kParams.length,
              cs: cs,
            ),

            // ── Scrollable content ────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  _InfoBanner(cs: cs),
                  const SizedBox(height: 14),

                  // Parameter cards
                  ...List.generate(_kParams.length, (i) {
                    return _ParamCard(
                      number: i + 1,
                      param: _kParams[i],
                      currentScore: _scores[i],
                      onScore: (v) => _setScore(i, v),
                      cs: cs,
                    );
                  }),

                  const SizedBox(height: 8),

                  // Incomplete hint
                  if (!_isComplete && _scores.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        '${_kParams.length - _scores.length} parameter(s) remaining',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ),

                  // Result (animated, shown only when complete)
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: _isComplete
                        ? _ResultPanel(score: _totalScore, cs: cs)
                        : const SizedBox.shrink(),
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

// ── Score bar ──────────────────────────────────────────────────────────────────

class _ScoreBar extends StatelessWidget {
  final int score;
  final int answered;
  final int total;
  final ColorScheme cs;

  const _ScoreBar({
    required this.score,
    required this.answered,
    required this.total,
    required this.cs,
  });

  Color _color(bool complete) {
    if (!complete) return cs.primary.withValues(alpha: 0.55);
    return score >= 25
        ? const Color(0xFF2E7D32)
        : const Color(0xFFC62828);
  }

  @override
  Widget build(BuildContext context) {
    final complete = answered == total;
    final color = _color(complete);
    final progress = total == 0 ? 0.0 : answered / total;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.05),
        border: Border(
            bottom: BorderSide(color: cs.outline.withValues(alpha: 0.15))),
      ),
      child: Row(
        children: [
          // Score circle
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2.5),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$score',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                      height: 1,
                    ),
                  ),
                  Text(
                    '/ 36',
                    style: TextStyle(
                      fontSize: 9,
                      color: color.withValues(alpha: 0.7),
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Clinical Assessment of Nutrition',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                    Text(
                      '$answered / $total',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: cs.outline.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info banner ────────────────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  final ColorScheme cs;
  const _InfoBanner({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clinical Assessment of Nutrition (CAN Score)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: cs.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Metcoff (1994) · 9 parameters · Score 1–4 per parameter · Total range: 9–36\n'
            'Score each parameter: 1 = Severe malnutrition · 2 = Moderate · 3 = Mild/Borderline · 4 = Normal',
            style: TextStyle(
              fontSize: 11.5,
              color: cs.onSurface.withValues(alpha: 0.6),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _LegendChip('< 25', 'Malnutrition', const Color(0xFFC62828)),
              const SizedBox(width: 8),
              _LegendChip('≥ 25', 'Normal', const Color(0xFF2E7D32)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  final String range;
  final String label;
  final Color color;
  const _LegendChip(this.range, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(range,
              style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: color)),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(fontSize: 10.5, color: color)),
        ],
      ),
    );
  }
}

// ── Parameter card ─────────────────────────────────────────────────────────────

class _ParamCard extends StatelessWidget {
  final int number;
  final _Param param;
  final int? currentScore;
  final void Function(int) onScore;
  final ColorScheme cs;

  const _ParamCard({
    required this.number,
    required this.param,
    required this.currentScore,
    required this.onScore,
    required this.cs,
  });

  Color _scoreColor(int score) {
    switch (score) {
      case 1: return const Color(0xFFC62828);
      case 2: return const Color(0xFFE65100);
      case 3: return const Color(0xFFF9A825);
      default: return const Color(0xFF2E7D32);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = currentScore != null;
    final accentColor =
        selected ? _scoreColor(currentScore!) : cs.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected
              ? accentColor.withValues(alpha: 0.4)
              : cs.outline.withValues(alpha: 0.15),
          width: selected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.07),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(11)),
              border: Border(
                bottom: BorderSide(
                    color: accentColor.withValues(alpha: 0.15)),
              ),
            ),
            child: Row(
              children: [
                // Number badge
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    param.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                // Selected score badge
                if (selected)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Score ${currentScore!}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Options ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            child: Column(
              children: List.generate(4, (i) {
                final score = i + 1; // scores are 1–4
                final isSelected = currentScore == score;
                final optColor = _scoreColor(score);

                return GestureDetector(
                  onTap: () => onScore(score),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? optColor.withValues(alpha: 0.1)
                          : cs.surface,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: isSelected
                            ? optColor.withValues(alpha: 0.5)
                            : cs.outline.withValues(alpha: 0.18),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Radio indicator
                        Container(
                          width: 20,
                          height: 20,
                          margin:
                              const EdgeInsets.only(right: 10, top: 1),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? optColor
                                  : cs.outline.withValues(alpha: 0.4),
                              width: isSelected ? 2 : 1.5,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: optColor,
                                    ),
                                  ),
                                )
                              : null,
                        ),

                        // Score label
                        Container(
                          width: 20,
                          margin:
                              const EdgeInsets.only(right: 8, top: 1),
                          child: Text(
                            '$score',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? optColor
                                  : cs.onSurface
                                      .withValues(alpha: 0.45),
                            ),
                          ),
                        ),

                        // Description
                        Expanded(
                          child: Text(
                            param.options[i],
                            style: TextStyle(
                              fontSize: 12.5,
                              color: isSelected
                                  ? optColor
                                  : cs.onSurface
                                      .withValues(alpha: 0.7),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              height: 1.4,
                            ),
                          ),
                        ),

                        if (isSelected)
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 6, top: 2),
                            child: Icon(
                              Icons.check_circle_rounded,
                              size: 15,
                              color: optColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Result panel ───────────────────────────────────────────────────────────────

class _ResultPanel extends StatelessWidget {
  final int score;
  final ColorScheme cs;

  const _ResultPanel({required this.score, required this.cs});

  @override
  Widget build(BuildContext context) {
    final bool normal = score >= 25;
    final Color color =
        normal ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
    final String interpretation =
        normal ? 'Normal Nutritional Status' : 'Fetal Malnutrition Present';
    final IconData icon =
        normal ? Icons.check_circle_rounded : Icons.warning_rounded;
    final String detail = normal
        ? 'Score ≥ 25 indicates adequate nutritional status at birth. '
            'No evidence of significant fetal malnutrition on clinical assessment.'
        : 'Score < 25 indicates fetal malnutrition. This may be present even when '
            'birth weight is appropriate for gestational age. Further nutritional '
            'assessment and support are recommended.';

    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: color.withValues(alpha: 0.35), width: 1.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Score + interpretation ─────────────────────────────────────
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  interpretation,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$score / 36',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            detail,
            style: TextStyle(
              fontSize: 13,
              color: color.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 12),

          // ── Subscale breakdown ─────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.onSurface.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Threshold Reference',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface.withValues(alpha: 0.5),
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 6),
                _ThresholdRow('< 25', 'Malnutrition present',
                    const Color(0xFFC62828), score < 25),
                const SizedBox(height: 4),
                _ThresholdRow('≥ 25', 'Normal nutritional status',
                    const Color(0xFF2E7D32), score >= 25),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // ── Clinical note ──────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 14,
                  color: cs.onSurface.withValues(alpha: 0.4)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'CAN score detects fetal malnutrition even in infants with normal birth weight. '
                  'Assessment is based on physical signs of fat and muscle wasting and is '
                  'independent of birth weight (Metcoff, 1994).',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: cs.onSurface.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThresholdRow extends StatelessWidget {
  final String range;
  final String label;
  final Color color;
  final bool active;

  const _ThresholdRow(this.range, this.label, this.color, this.active);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? color : color.withValues(alpha: 0.25),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          range,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: active ? color : color.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: active
                ? color
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.35),
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        if (active) ...[
          const SizedBox(width: 6),
          Icon(Icons.arrow_left_rounded, size: 16, color: color),
        ],
      ],
    );
  }
}

// ── Data model ─────────────────────────────────────────────────────────────────

class _Param {
  final String name;
  final List<String> options; // index 0 = score 1, index 3 = score 4
  const _Param({required this.name, required this.options});
}

// ── Parameter definitions ──────────────────────────────────────────────────────

const List<_Param> _kParams = [
  _Param(
    name: 'Hair',
    options: [
      'Dull, dry, brittle; easily pluckable; sparse or depigmented',
      'Slightly dull or sparse; mildly reduced luster',
      'Slightly less shiny than expected; subtle changes only',
      'Shiny, strong, well-implanted; not easily pluckable',
    ],
  ),
  _Param(
    name: 'Cheeks',
    options: [
      'Sunken, hollow; absent buccal fat pads; skin tented',
      'Buccal fat mildly reduced; slight hollowing on sucking',
      'Buccal fat slightly reduced; near normal contour',
      'Full, plump buccal fat pads; round cheeks',
    ],
  ),
  _Param(
    name: 'Neck & Chin',
    options: [
      'Very thin neck; deep skin folds; chin flat; loose overhanging skin',
      'Some loose skin over neck; mild wrinkling',
      'Slightly loose skin; minimal wrinkling; near normal',
      'Full, round chin; no loose folds; no wrinkling',
    ],
  ),
  _Param(
    name: 'Arms',
    options: [
      'Very thin; no subcutaneous fat; skin hangs loosely; muscle wasting',
      'Reduced subcutaneous fat; some loose skin',
      'Slightly reduced fat; near normal tone',
      'Full, round; good subcutaneous fat and muscle mass',
    ],
  ),
  _Param(
    name: 'Legs',
    options: [
      'Very thin; no subcutaneous fat; skin loose and wrinkled; muscle wasting',
      'Reduced fat; slightly loose skin over thighs',
      'Slightly reduced fat; near normal contour',
      'Full, round, well-muscled; no loose skin',
    ],
  ),
  _Param(
    name: 'Back',
    options: [
      'Spine and scapulae very prominent; loose skin hanging over spinous processes',
      'Scapulae slightly prominent; some loss of fat over back',
      'Mildly reduced dorsal fat; spine just palpable',
      'Well-padded back; smooth contour; no bony prominences visible',
    ],
  ),
  _Param(
    name: 'Buttocks',
    options: [
      'Flat, no gluteal fat; deep gluteal furrow; loose skin hanging in folds',
      'Reduced gluteal fat; gluteal furrow visible',
      'Slightly reduced gluteal fat; near normal appearance',
      'Full, round buttocks; no gluteal furrow; well-padded',
    ],
  ),
  _Param(
    name: 'Chest',
    options: [
      'Ribs very prominent; visible intercostal recession; absent subcutaneous fat',
      'Ribs easily visible; reduced subcutaneous fat',
      'Ribs slightly visible on deep inspiration; near normal',
      'Ribs not visible; well-padded chest wall; normal contour',
    ],
  ),
  _Param(
    name: 'Abdomen',
    options: [
      'Skin hangs loosely in folds; marked laxity; very thin abdominal wall',
      'Reduced abdominal fat; some loose skin',
      'Slightly reduced subcutaneous fat; mildly loose skin',
      'Round, well-padded abdomen; no loose skin; normal tone',
    ],
  ),
];
