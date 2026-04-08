import 'package:flutter/material.dart';

// ── POFRAS — Preterm Oral Feeding Readiness Assessment Scale ─────────────────
// Based on Fujinaga et al. (2013)
// 18 items · 5 domains · Score 0–2 per item · Max 36
// <28 = Not Ready | 28–30 = Borderline | ≥30 = Ready

class PofrasScreen extends StatefulWidget {
  const PofrasScreen({super.key});

  @override
  State<PofrasScreen> createState() => _PofrasScreenState();
}

class _PofrasScreenState extends State<PofrasScreen>
    with SingleTickerProviderStateMixin {
  // ── Score state: item index → score (0, 1, or 2) ──────────────────────────
  final Map<int, int> _scores = {};

  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  int get _totalScore =>
      _scores.values.fold(0, (sum, v) => sum + v);

  bool get _isComplete => _scores.length == _kItems.length;

  void _setScore(int itemIndex, int value) {
    setState(() {
      _scores[itemIndex] = value;
    });
    if (_isComplete && !_animCtrl.isCompleted) {
      _animCtrl.forward();
    } else if (_isComplete && _animCtrl.isCompleted) {
      // already shown
    } else if (!_isComplete) {
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
        title: const Text('POFRAS'),
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
            // ── Top score bar ──────────────────────────────────────────────
            _ScoreBar(
              score: _totalScore,
              answered: _scores.length,
              total: _kItems.length,
              cs: cs,
            ),

            // ── Scrollable item list ───────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                children: [
                  // Intro banner
                  _InfoBanner(cs: cs),
                  const SizedBox(height: 12),

                  // Domain sections
                  ..._kDomains.map((domain) => _DomainSection(
                        domain: domain,
                        scores: _scores,
                        onScore: _setScore,
                        cs: cs,
                      )),

                  const SizedBox(height: 16),

                  // Result panel (animated)
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: _isComplete
                        ? _ResultPanel(score: _totalScore, cs: cs)
                        : const SizedBox.shrink(),
                  ),

                  if (!_isComplete && _scores.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${_kItems.length - _scores.length} item(s) remaining to complete assessment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withValues(alpha: 0.45),
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

  Color _barColor() {
    if (answered < total) return cs.primary.withValues(alpha: 0.6);
    if (score >= 30) return const Color(0xFF2E7D32);
    if (score >= 28) return const Color(0xFFE65100);
    return const Color(0xFFC62828);
  }

  @override
  Widget build(BuildContext context) {
    final progress = answered / total;
    final barColor = _barColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.06),
        border: Border(
            bottom: BorderSide(color: cs.outline.withValues(alpha: 0.15))),
      ),
      child: Row(
        children: [
          // Score circle
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: barColor, width: 2.5),
            ),
            child: Center(
              child: Text(
                '$score',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: barColor,
                ),
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
                      'Score / 36',
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                    Text(
                      '$answered / $total items',
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: 0.55),
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
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preterm Oral Feeding Readiness Assessment Scale',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: cs.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Fujinaga et al. (2013) · 18 items · 5 domains · Max score: 36\n'
            'Score each item 0 (absent/poor), 1 (partial/inconsistent), or 2 (present/good).',
            style: TextStyle(
              fontSize: 11.5,
              color: cs.onSurface.withValues(alpha: 0.6),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 8),
          // Legend row
          Row(
            children: [
              _LegendChip('< 28', 'Not Ready', const Color(0xFFC62828)),
              const SizedBox(width: 8),
              _LegendChip('28–29', 'Borderline', const Color(0xFFE65100)),
              const SizedBox(width: 8),
              _LegendChip('≥ 30', 'Ready', const Color(0xFF2E7D32)),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            range,
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color),
          ),
        ],
      ),
    );
  }
}

// ── Domain section ─────────────────────────────────────────────────────────────

class _DomainSection extends StatelessWidget {
  final _Domain domain;
  final Map<int, int> scores;
  final void Function(int, int) onScore;
  final ColorScheme cs;

  const _DomainSection({
    required this.domain,
    required this.scores,
    required this.onScore,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    // domain score sum
    final domainScore = domain.itemIndices
        .map((i) => scores[i] ?? 0)
        .fold(0, (a, b) => a + b);
    final domainAnswered =
        domain.itemIndices.where((i) => scores.containsKey(i)).length;
    final domainMax = domain.itemIndices.length * 2;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Domain header
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: domain.color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10)),
              border: Border.all(
                  color: domain.color.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                Icon(domain.icon, size: 16, color: domain.color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    domain.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: domain.color,
                    ),
                  ),
                ),
                Text(
                  '$domainAnswered/${domain.itemIndices.length}',
                  style: TextStyle(
                    fontSize: 11,
                    color: domain.color.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: domain.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$domainScore / $domainMax',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: domain.color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items
          Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                    color: domain.color.withValues(alpha: 0.3), width: 1),
                right: BorderSide(
                    color: domain.color.withValues(alpha: 0.2), width: 1),
                bottom: BorderSide(
                    color: domain.color.withValues(alpha: 0.2), width: 1),
              ),
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10)),
            ),
            child: Column(
              children: domain.itemIndices.asMap().entries.map((entry) {
                final listIdx = entry.key;
                final itemIdx = entry.value;
                final item = _kItems[itemIdx];
                final isLast =
                    listIdx == domain.itemIndices.length - 1;
                return _ItemRow(
                  number: itemIdx + 1,
                  item: item,
                  currentScore: scores[itemIdx],
                  onScore: (v) => onScore(itemIdx, v),
                  isLast: isLast,
                  accentColor: domain.color,
                  cs: cs,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Item row ───────────────────────────────────────────────────────────────────

class _ItemRow extends StatelessWidget {
  final int number;
  final _Item item;
  final int? currentScore;
  final void Function(int) onScore;
  final bool isLast;
  final Color accentColor;
  final ColorScheme cs;

  const _ItemRow({
    required this.number,
    required this.item,
    required this.currentScore,
    required this.onScore,
    required this.isLast,
    required this.accentColor,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                    color: cs.outline.withValues(alpha: 0.1))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item label row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Number badge
              Container(
                width: 22,
                height: 22,
                margin: const EdgeInsets.only(top: 1, right: 8),
                decoration: BoxDecoration(
                  color: currentScore != null
                      ? accentColor.withValues(alpha: 0.15)
                      : cs.outline.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: currentScore != null
                          ? accentColor
                          : cs.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),

          // Score chips
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ScoreChipRow(
                  options: item.options,
                  currentScore: currentScore,
                  onScore: onScore,
                  accentColor: accentColor,
                  cs: cs,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Score chip row ─────────────────────────────────────────────────────────────

class _ScoreChipRow extends StatelessWidget {
  final List<String> options; // 3 entries: [0-text, 1-text, 2-text]
  final int? currentScore;
  final void Function(int) onScore;
  final Color accentColor;
  final ColorScheme cs;

  const _ScoreChipRow({
    required this.options,
    required this.currentScore,
    required this.onScore,
    required this.accentColor,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(3, (i) {
        final selected = currentScore == i;
        final scoreColor = i == 0
            ? const Color(0xFFC62828)
            : i == 1
                ? const Color(0xFFE65100)
                : const Color(0xFF2E7D32);
        return GestureDetector(
          onTap: () => onScore(i),
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: selected
                  ? scoreColor.withValues(alpha: 0.12)
                  : cs.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected
                    ? scoreColor.withValues(alpha: 0.5)
                    : cs.outline.withValues(alpha: 0.2),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Score badge
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 8, top: 1),
                  decoration: BoxDecoration(
                    color: selected
                        ? scoreColor
                        : cs.outline.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$i',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color:
                            selected ? Colors.white : cs.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    options[i],
                    style: TextStyle(
                      fontSize: 12,
                      color: selected
                          ? scoreColor
                          : cs.onSurface.withValues(alpha: 0.65),
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      height: 1.35,
                    ),
                  ),
                ),
                if (selected)
                  Icon(Icons.check_circle_rounded,
                      size: 16, color: scoreColor),
              ],
            ),
          ),
        );
      }),
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
    final Color color;
    final String status;
    final String message;
    final IconData icon;

    if (score >= 30) {
      color = const Color(0xFF2E7D32);
      status = 'Ready for Oral Feeding';
      message =
          'Score ≥ 30 indicates adequate readiness. The infant may be trialled on oral feeds with continuous monitoring of physiological stability, sucking efficiency, and tolerance.';
      icon = Icons.check_circle_rounded;
    } else if (score >= 28) {
      color = const Color(0xFFE65100);
      status = 'Borderline Readiness';
      message =
          'Score 28–29 suggests borderline readiness. Consider a short oral feeding trial (1–2 sucks) under close supervision. Re-assess after 24–48 hours or when state improves.';
      icon = Icons.warning_rounded;
    } else {
      color = const Color(0xFFC62828);
      status = 'Not Ready for Oral Feeding';
      message =
          'Score < 28 indicates insufficient readiness. Continue non-nutritive sucking (NNS) practice and oral stimulation. Re-assess in 48–72 hours.';
      icon = Icons.cancel_rounded;
    }

    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$score / 36',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 13,
              color: color.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Text(
            'Clinical note: POFRAS is a validated tool to support decision-making. '
            'Clinical judgement, parental input, and interdisciplinary team assessment '
            'should always guide final feeding decisions.',
            style: TextStyle(
              fontSize: 11.5,
              color: cs.onSurface.withValues(alpha: 0.5),
              fontStyle: FontStyle.italic,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data model ─────────────────────────────────────────────────────────────────

class _Item {
  final String label;
  final List<String> options; // [score0, score1, score2]
  const _Item({required this.label, required this.options});
}

class _Domain {
  final String name;
  final IconData icon;
  final Color color;
  final List<int> itemIndices; // indices into _kItems
  const _Domain({
    required this.name,
    required this.icon,
    required this.color,
    required this.itemIndices,
  });
}

// ── Item definitions ───────────────────────────────────────────────────────────

const List<_Item> _kItems = [
  // Domain 1: Corrected Gestational Age (item 0)
  _Item(
    label: 'Corrected Gestational Age',
    options: [
      '0 — ≤ 32 weeks',
      '1 — 33–34 weeks',
      '2 — ≥ 35 weeks',
    ],
  ),

  // Domain 2: Behavioral Organization (items 1–3)
  _Item(
    label: 'State of Alertness',
    options: [
      '0 — Deep sleep; unresponsive',
      '1 — Light sleep; drowsy or agitated',
      '2 — Awake and alert; calm and stable',
    ],
  ),
  _Item(
    label: 'Postural Tone',
    options: [
      '0 — Hypotonic; flaccid; no resistance',
      '1 — Variable tone; inconsistent posture',
      '2 — Normal tone; well-flexed posture',
    ],
  ),
  _Item(
    label: 'Tolerance to Stimulation',
    options: [
      '0 — Strong negative response; desaturation or bradycardia',
      '1 — Mild negative response; minor physiological change',
      '2 — Tolerates stimulation well; stable physiological state',
    ],
  ),

  // Domain 3: Oral Posture (items 4–5)
  _Item(
    label: 'Lip Posture',
    options: [
      '0 — Open/retracted; unable to approximate lips',
      '1 — Partially closed; inconsistent lip seal',
      '2 — Lips closed at rest; adequate resting tone',
    ],
  ),
  _Item(
    label: 'Tongue Posture',
    options: [
      '0 — Protruded or elevated; not cupped',
      '1 — Flat or inconsistently positioned',
      '2 — Cupped and midline; appropriate for feeding',
    ],
  ),

  // Domain 4: Oral Reflexes (items 6–9)
  _Item(
    label: 'Gag Reflex',
    options: [
      '0 — Absent or markedly diminished',
      '1 — Hyperactive; triggered by light touch',
      '2 — Adequate; triggered only by appropriate stimulus',
    ],
  ),
  _Item(
    label: 'Bite Reflex',
    options: [
      '0 — Persistent strong bite; cannot be released',
      '1 — Present but can be released with mild effort',
      '2 — Absent or minimal; does not interfere with feeding',
    ],
  ),
  _Item(
    label: 'Rooting Reflex',
    options: [
      '0 — Absent; no response to perioral stimulation',
      '1 — Incomplete; partial or delayed response',
      '2 — Complete; consistent response to perioral touch',
    ],
  ),
  _Item(
    label: 'Sucking Reflex',
    options: [
      '0 — Absent; no sucking movement',
      '1 — Weak or inconsistent sucking',
      '2 — Strong, consistent sucking',
    ],
  ),

  // Domain 5: Non-Nutritive Sucking (items 10–17)
  _Item(
    label: 'Ability to Latch',
    options: [
      '0 — Unable to latch onto teat/finger',
      '1 — Latches with significant difficulty',
      '2 — Latches easily and maintains latch',
    ],
  ),
  _Item(
    label: 'Lip Seal During Sucking',
    options: [
      '0 — No lip seal; air escapes continuously',
      '1 — Incomplete seal; intermittent air leaks',
      '2 — Complete and sustained lip seal',
    ],
  ),
  _Item(
    label: 'Sucking Bursts',
    options: [
      '0 — Absent; no organised sucking burst',
      '1 — 1–5 sucks per burst',
      '2 — ≥ 6 sucks per burst consistently',
    ],
  ),
  _Item(
    label: 'Sucking Rhythm',
    options: [
      '0 — Arrhythmic; no organised sucking pattern',
      '1 — Inconsistent rhythm; variable burst/pause',
      '2 — Regular, organised burst–pause pattern',
    ],
  ),
  _Item(
    label: 'Tongue Tip Elevation',
    options: [
      '0 — Absent; tongue does not elevate',
      '1 — Partial elevation; inconsistent',
      '2 — Complete, consistent elevation during sucking',
    ],
  ),
  _Item(
    label: 'Jaw Excursion',
    options: [
      '0 — Excessive (clenching) or minimal (barely moves)',
      '1 — Moderate excursion; somewhat inconsistent',
      '2 — Adequate, graded excursion coordinated with sucking',
    ],
  ),
  _Item(
    label: 'Suction Generation',
    options: [
      '0 — Absent; no intraoral negative pressure',
      '1 — Weak; fluid is not drawn effectively',
      '2 — Adequate negative pressure; effective fluid extraction',
    ],
  ),
  _Item(
    label: 'Endurance',
    options: [
      '0 — Significant fatigue within first few sucks; unable to sustain',
      '1 — Moderate fatigue; quality diminishes after brief period',
      '2 — Maintains sucking quality throughout the assessment',
    ],
  ),
];

// ── Domain definitions ─────────────────────────────────────────────────────────

final List<_Domain> _kDomains = [
  const _Domain(
    name: 'Domain 1 — Corrected Gestational Age',
    icon: Icons.calendar_month_outlined,
    color: Color(0xFF6A1B9A),
    itemIndices: [0],
  ),
  const _Domain(
    name: 'Domain 2 — Behavioral Organization',
    icon: Icons.psychology_outlined,
    color: Color(0xFF1565C0),
    itemIndices: [1, 2, 3],
  ),
  const _Domain(
    name: 'Domain 3 — Oral Posture',
    icon: Icons.face_outlined,
    color: Color(0xFF00695C),
    itemIndices: [4, 5],
  ),
  const _Domain(
    name: 'Domain 4 — Oral Reflexes',
    icon: Icons.touch_app_outlined,
    color: Color(0xFFAD1457),
    itemIndices: [6, 7, 8, 9],
  ),
  const _Domain(
    name: 'Domain 5 — Non-Nutritive Sucking',
    icon: Icons.water_drop_outlined,
    color: Color(0xFFE65100),
    itemIndices: [10, 11, 12, 13, 14, 15, 16, 17],
  ),
];
