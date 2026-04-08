import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════════════════════════
// Lung Ultrasound Score (LUS)
// Based on: Brat R, et al. Lung Ultrasonography Score to Evaluate Oxygenation
// and Surfactant Need in Neonates Born Very Preterm. JAMA Pediatr. 2015.
//
// Zone scoring: 0 = A-lines · 1 = ≥3 B-lines · 2 = Coalescent B-lines
//               3 = Consolidation
// 6-zone method: max 18 · 10-zone method: max 30
// ══════════════════════════════════════════════════════════════════════════════

enum _LusMethod { six, ten }

// ── Zone identifiers ──────────────────────────────────────────────────────────
enum _Zone {
  rUpperAnt,
  rLowerAnt,
  rLateral,
  rPostUpper,
  rPostLower,
  lUpperAnt,
  lLowerAnt,
  lLateral,
  lPostUpper,
  lPostLower,
}

extension _ZoneLabel on _Zone {
  String get label {
    switch (this) {
      case _Zone.rUpperAnt:   return 'Upper Anterior';
      case _Zone.rLowerAnt:   return 'Lower Anterior';
      case _Zone.rLateral:    return 'Lateral';
      case _Zone.rPostUpper:  return 'Post. Upper';
      case _Zone.rPostLower:  return 'Post. Lower';
      case _Zone.lUpperAnt:   return 'Upper Anterior';
      case _Zone.lLowerAnt:   return 'Lower Anterior';
      case _Zone.lLateral:    return 'Lateral';
      case _Zone.lPostUpper:  return 'Post. Upper';
      case _Zone.lPostLower:  return 'Post. Lower';
    }
  }
}

// ── Zones per method ──────────────────────────────────────────────────────────
const _rightZones6 = [_Zone.rUpperAnt, _Zone.rLowerAnt, _Zone.rLateral];
const _leftZones6  = [_Zone.lUpperAnt, _Zone.lLowerAnt, _Zone.lLateral];
const _rightZones10 = [
  _Zone.rUpperAnt, _Zone.rLowerAnt, _Zone.rLateral,
  _Zone.rPostUpper, _Zone.rPostLower,
];
const _leftZones10 = [
  _Zone.lUpperAnt, _Zone.lLowerAnt, _Zone.lLateral,
  _Zone.lPostUpper, _Zone.lPostLower,
];

// ── Score labels ──────────────────────────────────────────────────────────────
const _scoreLabels = ['A-lines', 'B-lines', 'Coalescent', 'Consolidation'];

// ── Colors per score ──────────────────────────────────────────────────────────
const _scoreColors = [
  Color(0xFF2E7D32), // 0 – green
  Color(0xFFF9A825), // 1 – amber
  Color(0xFFE65100), // 2 – orange
  Color(0xFFC62828), // 3 – red
];

// ══════════════════════════════════════════════════════════════════════════════
// Logic
// ══════════════════════════════════════════════════════════════════════════════

int _calculateScore(Map<_Zone, int> zones, _LusMethod method) {
  final active = method == _LusMethod.six
      ? [..._rightZones6, ..._leftZones6]
      : [..._rightZones10, ..._leftZones10];
  return active.fold(0, (sum, z) => sum + (zones[z] ?? 0));
}

int _computeMaxScore(_LusMethod method) => method == _LusMethod.six ? 18 : 30;

int _zoneCount(_LusMethod method) => method == _LusMethod.six ? 6 : 10;

// ── Interpretation data model ─────────────────────────────────────────────────
class _Insight {
  final String title;
  final String detail;
  final Color color;
  final IconData icon;
  const _Insight({
    required this.title,
    required this.detail,
    required this.color,
    required this.icon,
  });
}

List<_Insight> _getInsights(int score, int gestWeeks, int dayOfLife) {
  final insights = <_Insight>[];
  final preterm = gestWeeks < 34;
  final max = 30; // reference max for severity %
  final pct = score / max;

  // ── Severity summary ──────────────────────────────────────────────────────
  if (score == 0) {
    insights.add(_Insight(
      title: 'Normal Lung Aeration',
      detail: 'Score 0 — All zones show A-lines. Normal lung aeration. '
              'No evidence of respiratory disease on ultrasound.',
      color: const Color(0xFF2E7D32),
      icon: Icons.check_circle_rounded,
    ));
  } else if (pct < 0.3) {
    insights.add(_Insight(
      title: 'Mild Interstitial Syndrome',
      detail: 'Low LUS. Mild B-line predominance. Monitor respiratory status '
              'and repeat scan if clinical condition changes.',
      color: const Color(0xFF2E7D32),
      icon: Icons.check_circle_rounded,
    ));
  } else if (pct < 0.6) {
    insights.add(_Insight(
      title: 'Moderate Lung Pathology',
      detail: 'Moderate LUS. Significant B-line activity with possible focal '
              'consolidation. Close respiratory monitoring warranted.',
      color: const Color(0xFFF9A825),
      icon: Icons.warning_amber_rounded,
    ));
  } else {
    insights.add(_Insight(
      title: 'Severe Lung Pathology',
      detail: 'High LUS. Extensive coalescent B-lines or consolidation. '
              'Significant loss of aeration. Prompt clinical review required.',
      color: const Color(0xFFC62828),
      icon: Icons.error_rounded,
    ));
  }

  // ── Surfactant need ───────────────────────────────────────────────────────
  if (preterm && score > 4) {
    insights.add(_Insight(
      title: 'Surfactant Therapy — Consider',
      detail: 'Preterm (<34 wks) with LUS > 4. Brat et al. showed LUS > 4 '
              'predicts surfactant need with high sensitivity in VLBW neonates. '
              'Evaluate for INSURE/LISA procedure.',
      color: const Color(0xFFE65100),
      icon: Icons.medication_rounded,
    ));
  } else if (!preterm && score > 8) {
    insights.add(_Insight(
      title: 'Surfactant Therapy — Consider',
      detail: 'Term neonate with LUS > 8. Elevated score suggests significant '
              'surfactant deficiency. Consider surfactant administration and '
              'evaluate for primary respiratory diagnoses.',
      color: const Color(0xFFE65100),
      icon: Icons.medication_rounded,
    ));
  }

  // ── Mechanical ventilation risk ───────────────────────────────────────────
  if (score >= 7 && score <= 10 && dayOfLife <= 3) {
    insights.add(_Insight(
      title: 'High MV Risk — Day 1–3',
      detail: 'LUS 7–10 in the first 3 days of life is associated with high '
              'risk of requiring mechanical ventilation. Anticipate escalation '
              'of respiratory support.',
      color: const Color(0xFFC62828),
      icon: Icons.airline_seat_flat_angled_rounded,
    ));
  } else if (score > 10 && dayOfLife <= 3) {
    insights.add(_Insight(
      title: 'Very High MV Risk',
      detail: 'LUS > 10 in early postnatal period. Very high probability of '
              'intubation and mechanical ventilation. Ensure airway access '
              'and surfactant availability.',
      color: const Color(0xFFC62828),
      icon: Icons.airline_seat_flat_angled_rounded,
    ));
  }

  // ── Extubation readiness ──────────────────────────────────────────────────
  if (score <= 6) {
    insights.add(_Insight(
      title: 'Extubation — Likely Feasible',
      detail: 'LUS ≤ 6 is associated with successful extubation. '
              'Adequate aeration for weaning from ventilatory support '
              'if clinical criteria also met.',
      color: const Color(0xFF2E7D32),
      icon: Icons.air_rounded,
    ));
  } else if (score > 6 && score <= 12) {
    insights.add(_Insight(
      title: 'Extubation — Caution',
      detail: 'LUS 7–12. Moderate lung pathology may complicate extubation. '
              'Optimise respiratory support and repeat assessment before '
              'attempting weaning.',
      color: const Color(0xFFF9A825),
      icon: Icons.air_rounded,
    ));
  } else {
    insights.add(_Insight(
      title: 'Extubation — Not Recommended',
      detail: 'LUS > 12. Significant lung pathology. Extubation unlikely to '
              'succeed. Continue ventilatory support and treat underlying cause.',
      color: const Color(0xFFC62828),
      icon: Icons.do_not_disturb_on_rounded,
    ));
  }

  // ── BPD prediction ────────────────────────────────────────────────────────
  if (preterm && (dayOfLife == 7 || dayOfLife == 14) && score >= 9) {
    insights.add(_Insight(
      title: 'BPD Risk — Elevated',
      detail: 'High LUS at Day $dayOfLife in preterm neonate. Persistent '
              'elevated score at Day 7/14 is associated with risk of developing '
              'Bronchopulmonary Dysplasia. Ensure lung-protective ventilation '
              'and consider inhaled corticosteroids per protocol.',
      color: const Color(0xFFAD1457),
      icon: Icons.timeline_rounded,
    ));
  }

  return insights;
}

// ══════════════════════════════════════════════════════════════════════════════
// Screen
// ══════════════════════════════════════════════════════════════════════════════

class LusScoreScreen extends StatefulWidget {
  const LusScoreScreen({super.key});

  @override
  State<LusScoreScreen> createState() => _LusScoreScreenState();
}

class _LusScoreScreenState extends State<LusScoreScreen> {
  _LusMethod _method = _LusMethod.six;
  final Map<_Zone, int> _zones = {};

  // Clinical context
  int _gestWeeks = 32;
  int _dayOfLife = 1;

  // Guide expansion
  bool _guideExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  List<_Zone> get _activeZones => _method == _LusMethod.six
      ? [..._rightZones6, ..._leftZones6]
      : [..._rightZones10, ..._leftZones10];

  int get _totalScore   => _calculateScore(_zones, _method);
  int get _maxScore     => _computeMaxScore(_method);
  int get _answered     => _activeZones.where((z) => _zones.containsKey(z)).length;
  bool get _allAnswered => _answered == _zoneCount(_method);

  void _setZone(_Zone zone, int value) {
    setState(() => _zones[zone] = value);
  }

  void _switchMethod(_LusMethod m) {
    if (m == _method) return;
    setState(() {
      _method = m;
      _zones.clear();
    });
  }

  void _reset() {
    setState(() => _zones.clear());
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Lung Ultrasound Score'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: 'About LUS',
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => _showInfoDialog(context, cs),
          ),
          if (_zones.isNotEmpty)
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
            // ── Live score bar ──────────────────────────────────────────────
            _ScoreBar(
              score: _totalScore,
              maxScore: _maxScore,
              answered: _answered,
              total: _zoneCount(_method),
              cs: cs,
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                children: [
                  // ── Method toggle ─────────────────────────────────────────
                  _MethodToggle(
                    selected: _method,
                    onChanged: _switchMethod,
                    cs: cs,
                  ),
                  const SizedBox(height: 14),

                  // ── Clinical context ──────────────────────────────────────
                  _ClinicalContext(
                    gestWeeks: _gestWeeks,
                    dayOfLife: _dayOfLife,
                    onGestChanged: (v) => setState(() => _gestWeeks = v),
                    onDayChanged: (v) => setState(() => _dayOfLife = v),
                    cs: cs,
                  ),
                  const SizedBox(height: 14),

                  // ── Scoring legend ────────────────────────────────────────
                  _ScoringLegend(cs: cs),
                  const SizedBox(height: 14),

                  // ── Zone grid ─────────────────────────────────────────────
                  _ZoneGrid(
                    method: _method,
                    zones: _zones,
                    onZoneSet: _setZone,
                    cs: cs,
                  ),

                  const SizedBox(height: 10),

                  // Remaining hint
                  if (!_allAnswered && _zones.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        '${_zoneCount(_method) - _answered} zone(s) remaining',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ),

                  // ── Live interpretation (shown even incomplete) ────────────
                  if (_answered > 0) ...[
                    const SizedBox(height: 4),
                    _InterpretationPanel(
                      score: _totalScore,
                      maxScore: _maxScore,
                      gestWeeks: _gestWeeks,
                      dayOfLife: _dayOfLife,
                      allAnswered: _allAnswered,
                      cs: cs,
                    ),
                    const SizedBox(height: 14),
                  ],

                  // ── Expandable clinical guide ─────────────────────────────
                  _ClinicalGuide(
                    expanded: _guideExpanded,
                    onToggle: () =>
                        setState(() => _guideExpanded = !_guideExpanded),
                    cs: cs,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, ColorScheme cs) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.sensors_rounded, color: cs.primary, size: 22),
            const SizedBox(width: 10),
            const Text('About LUS'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _InfoSection(
                'Reference',
                'Brat R, et al. Lung Ultrasonography Score to Evaluate '
                'Oxygenation and Surfactant Need in Neonates Born Very Preterm. '
                'JAMA Pediatr. 2015;169(8):e151797.',
                cs,
              ),
              const SizedBox(height: 12),
              _InfoSection(
                'Scoring Principle',
                'Each lung zone is independently scored 0–3 based on the '
                'predominant ultrasound pattern. Higher scores indicate '
                'greater loss of aeration.',
                cs,
              ),
              const SizedBox(height: 12),
              _InfoSection(
                'Methods',
                '6-Zone: 3 zones per lung (Upper Ant., Lower Ant., Lateral) → Max 18\n'
                '10-Zone: Adds 2 posterior zones per lung → Max 30',
                cs,
              ),
              const SizedBox(height: 12),
              _InfoSection(
                'Clinical Use',
                '• Early respiratory distress evaluation\n'
                '• Surfactant need prediction\n'
                '• Extubation readiness\n'
                '• BPD risk stratification\n'
                '• Serial monitoring of lung recruitment',
                cs,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final String body;
  final ColorScheme cs;
  const _InfoSection(this.title, this.body, this.cs);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: cs.primary,
              letterSpacing: 0.3,
            )),
        const SizedBox(height: 3),
        Text(body,
            style: TextStyle(
              fontSize: 12.5,
              color: cs.onSurface.withValues(alpha: 0.75),
              height: 1.5,
            )),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Score Bar
// ══════════════════════════════════════════════════════════════════════════════

class _ScoreBar extends StatelessWidget {
  final int score;
  final int maxScore;
  final int answered;
  final int total;
  final ColorScheme cs;

  const _ScoreBar({
    required this.score,
    required this.maxScore,
    required this.answered,
    required this.total,
    required this.cs,
  });

  Color get _color {
    if (answered == 0) return cs.primary.withValues(alpha: 0.5);
    final pct = score / maxScore;
    if (pct < 0.3) return const Color(0xFF2E7D32);
    if (pct < 0.6) return const Color(0xFFF9A825);
    return const Color(0xFFC62828);
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
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
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2.5),
              color: color.withValues(alpha: 0.07),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$score',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                      height: 1,
                    ),
                  ),
                  Text(
                    '/ $maxScore',
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
                      'Lung Ultrasound Score',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                    Text(
                      '$answered / $total zones',
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
                const SizedBox(height: 5),
                // Score severity bar
                if (answered > 0)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: maxScore == 0 ? 0 : score / maxScore,
                      minHeight: 4,
                      backgroundColor: cs.outline.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          color.withValues(alpha: 0.6)),
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

// ══════════════════════════════════════════════════════════════════════════════
// Method Toggle
// ══════════════════════════════════════════════════════════════════════════════

class _MethodToggle extends StatelessWidget {
  final _LusMethod selected;
  final void Function(_LusMethod) onChanged;
  final ColorScheme cs;

  const _MethodToggle({
    required this.selected,
    required this.onChanged,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          _ToggleBtn(
            label: '6-Zone Method',
            sublabel: 'Anterior + Lateral  ·  Max 18',
            selected: selected == _LusMethod.six,
            onTap: () => onChanged(_LusMethod.six),
            cs: cs,
          ),
          const SizedBox(width: 4),
          _ToggleBtn(
            label: '10-Zone Method',
            sublabel: '+ Posterior zones  ·  Max 30',
            selected: selected == _LusMethod.ten,
            onTap: () => onChanged(_LusMethod.ten),
            cs: cs,
          ),
        ],
      ),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final String label;
  final String sublabel;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme cs;

  const _ToggleBtn({
    required this.label,
    required this.sublabel,
    required this.selected,
    required this.onTap,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? cs.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Column(
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: selected ? cs.onPrimary : cs.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sublabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.5,
                  color: selected
                      ? cs.onPrimary.withValues(alpha: 0.75)
                      : cs.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Clinical Context
// ══════════════════════════════════════════════════════════════════════════════

class _ClinicalContext extends StatelessWidget {
  final int gestWeeks;
  final int dayOfLife;
  final void Function(int) onGestChanged;
  final void Function(int) onDayChanged;
  final ColorScheme cs;

  const _ClinicalContext({
    required this.gestWeeks,
    required this.dayOfLife,
    required this.onGestChanged,
    required this.onDayChanged,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: cs.tertiary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.tertiary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_rounded,
                  size: 14, color: cs.tertiary.withValues(alpha: 0.7)),
              const SizedBox(width: 6),
              Text(
                'Clinical Context',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: cs.tertiary,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(used for interpretation)',
                style: TextStyle(
                  fontSize: 10.5,
                  color: cs.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Gestation
              Expanded(
                child: _ContextPicker(
                  label: 'Gestation',
                  unit: 'wks',
                  value: gestWeeks,
                  min: 23,
                  max: 42,
                  onChanged: onGestChanged,
                  cs: cs,
                  preterm: gestWeeks < 34,
                ),
              ),
              const SizedBox(width: 10),
              // Day of life
              Expanded(
                child: _ContextPicker(
                  label: 'Day of Life',
                  unit: 'DOL',
                  value: dayOfLife,
                  min: 1,
                  max: 28,
                  onChanged: onDayChanged,
                  cs: cs,
                  preterm: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContextPicker extends StatelessWidget {
  final String label;
  final String unit;
  final int value;
  final int min;
  final int max;
  final void Function(int) onChanged;
  final ColorScheme cs;
  final bool preterm;

  const _ContextPicker({
    required this.label,
    required this.unit,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.cs,
    required this.preterm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: cs.outline.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface.withValues(alpha: 0.55),
                  )),
              if (preterm && label == 'Gestation')
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE65100).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Preterm',
                    style: TextStyle(
                      fontSize: 9,
                      color: Color(0xFFE65100),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: value > min ? () => onChanged(value - 1) : null,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.remove_rounded,
                      size: 16,
                      color: value > min
                          ? cs.primary
                          : cs.onSurface.withValues(alpha: 0.2)),
                ),
              ),
              Column(
                children: [
                  Text(
                    '$value',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: 9,
                      color: cs.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: value < max ? () => onChanged(value + 1) : null,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.add_rounded,
                      size: 16,
                      color: value < max
                          ? cs.primary
                          : cs.onSurface.withValues(alpha: 0.2)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Scoring Legend
// ══════════════════════════════════════════════════════════════════════════════

class _ScoringLegend extends StatelessWidget {
  final ColorScheme cs;
  const _ScoringLegend({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scoring Key',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: cs.primary,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: List.generate(4, (i) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < 3 ? 5 : 0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                  decoration: BoxDecoration(
                    color: _scoreColors[i].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                        color: _scoreColors[i].withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$i',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _scoreColors[i],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _scoreLabels[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9.5,
                          color: _scoreColors[i],
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Zone Grid
// ══════════════════════════════════════════════════════════════════════════════

class _ZoneGrid extends StatelessWidget {
  final _LusMethod method;
  final Map<_Zone, int> zones;
  final void Function(_Zone, int) onZoneSet;
  final ColorScheme cs;

  const _ZoneGrid({
    required this.method,
    required this.zones,
    required this.onZoneSet,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final rightZones =
        method == _LusMethod.six ? _rightZones6 : _rightZones10;
    final leftZones =
        method == _LusMethod.six ? _leftZones6 : _leftZones10;

    return Column(
      children: [
        // Header row
        Row(
          children: [
            _LungHeader('RIGHT LUNG', Icons.arrow_back_rounded, cs),
            const SizedBox(width: 8),
            _LungHeader('LEFT LUNG', Icons.arrow_forward_rounded, cs),
          ],
        ),
        const SizedBox(height: 8),
        // Zone pairs
        ...List.generate(rightZones.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _ZoneCard(
                    zone: rightZones[i],
                    score: zones[rightZones[i]],
                    onScore: (v) => onZoneSet(rightZones[i], v),
                    cs: cs,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ZoneCard(
                    zone: leftZones[i],
                    score: zones[leftZones[i]],
                    onScore: (v) => onZoneSet(leftZones[i], v),
                    cs: cs,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _LungHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  final ColorScheme cs;
  const _LungHeader(this.label, this.icon, this.cs);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: cs.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12, color: cs.primary),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: cs.primary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Zone card ──────────────────────────────────────────────────────────────────

class _ZoneCard extends StatelessWidget {
  final _Zone zone;
  final int? score;
  final void Function(int) onScore;
  final ColorScheme cs;

  const _ZoneCard({
    required this.zone,
    required this.score,
    required this.onScore,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final selected = score != null;
    final accentColor = selected ? _scoreColors[score!] : cs.primary;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: selected
              ? accentColor.withValues(alpha: 0.4)
              : cs.outline.withValues(alpha: 0.15),
          width: selected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Zone label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.07),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              border: Border(
                  bottom:
                      BorderSide(color: accentColor.withValues(alpha: 0.15))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    zone.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                if (selected)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${score!}',
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
          // Score buttons: 0 1 2 3 in a row
          Padding(
            padding: const EdgeInsets.all(7),
            child: Row(
              children: List.generate(4, (i) {
                final isSelected = score == i;
                final btnColor = _scoreColors[i];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onScore(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? btnColor
                            : btnColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: isSelected
                              ? btnColor
                              : btnColor.withValues(alpha: 0.25),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$i',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : btnColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Selected label
          if (selected)
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Text(
                _scoreLabels[score!],
                style: TextStyle(
                  fontSize: 10,
                  color: accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            const SizedBox(height: 5),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Interpretation Panel
// ══════════════════════════════════════════════════════════════════════════════

class _InterpretationPanel extends StatelessWidget {
  final int score;
  final int maxScore;
  final int gestWeeks;
  final int dayOfLife;
  final bool allAnswered;
  final ColorScheme cs;

  const _InterpretationPanel({
    required this.score,
    required this.maxScore,
    required this.gestWeeks,
    required this.dayOfLife,
    required this.allAnswered,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final insights = _getInsights(score, gestWeeks, dayOfLife);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                  width: 3,
                  height: 16,
                  color: cs.primary,
                  margin: const EdgeInsets.only(right: 8)),
              Text(
                'Clinical Interpretation',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              if (!allAnswered)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Partial',
                    style: TextStyle(
                      fontSize: 10,
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Score summary badge
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: cs.primary.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Text(
                '$score',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
              Text(
                ' / $maxScore',
                style: TextStyle(
                  fontSize: 14,
                  color: cs.primary.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gestWeeks < 34 ? 'Preterm · ${gestWeeks}w' : 'Term · ${gestWeeks}w',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: gestWeeks < 34
                            ? const Color(0xFFE65100)
                            : const Color(0xFF2E7D32),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Day of Life $dayOfLife',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: cs.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Insight cards
        ...insights.map((insight) => _InsightCard(insight: insight, cs: cs)),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final _Insight insight;
  final ColorScheme cs;

  const _InsightCard({required this.insight, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: insight.color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
            color: insight.color.withValues(alpha: 0.3), width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1, right: 10),
            child: Icon(insight.icon, color: insight.color, size: 20),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: insight.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight.detail,
                  style: TextStyle(
                    fontSize: 12,
                    color: insight.color.withValues(alpha: 0.85),
                    height: 1.5,
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

// ══════════════════════════════════════════════════════════════════════════════
// Expandable Clinical Guide
// ══════════════════════════════════════════════════════════════════════════════

class _ClinicalGuide extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;
  final ColorScheme cs;

  const _ClinicalGuide({
    required this.expanded,
    required this.onToggle,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  Icon(Icons.menu_book_rounded,
                      size: 18, color: cs.primary.withValues(alpha: 0.8)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Clinical Guide & Cut-offs',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: cs.onSurface.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          ),

          // Content
          if (expanded) ...[
            Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: cs.outline.withValues(alpha: 0.15)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GuideSection(
                    title: 'Zone Definitions',
                    items: const [
                      _GuideItem('Score 0 — A-lines',
                          'Horizontal reverberation artifacts parallel to pleura. Indicates normal lung aeration.'),
                      _GuideItem('Score 1 — B-lines (≥3)',
                          'Vertical laser-like artifacts arising from pleural line. Mild interstitial syndrome.'),
                      _GuideItem('Score 2 — Coalescent B-lines',
                          'B-lines merge into white lung appearance. Severe interstitial syndrome / alveolar fluid.'),
                      _GuideItem('Score 3 — Consolidation',
                          'Tissue-like echotexture with air bronchograms. Complete loss of aeration.'),
                    ],
                    cs: cs,
                  ),
                  const SizedBox(height: 14),
                  _GuideSection(
                    title: 'Key Thresholds',
                    items: const [
                      _GuideItem('LUS > 4 (Preterm <34w)',
                          'Predicts surfactant need. Consider INSURE/LISA approach (Brat 2015).'),
                      _GuideItem('LUS > 8 (Term)',
                          'Suggests significant surfactant deficiency in term neonates.'),
                      _GuideItem('LUS 7–10 (Day 1–3)',
                          'High risk for requiring mechanical ventilation.'),
                      _GuideItem('LUS ≤ 6',
                          'Associated with successful extubation outcomes.'),
                      _GuideItem('High LUS at Day 7 / 14 (Preterm)',
                          'Elevated risk for Bronchopulmonary Dysplasia (BPD).'),
                    ],
                    cs: cs,
                  ),
                  const SizedBox(height: 14),
                  _GuideSection(
                    title: 'Zone Scanning Protocol',
                    items: const [
                      _GuideItem('Upper Anterior',
                          'Probe in 2nd intercostal space, mid-clavicular line. Transverse or longitudinal.'),
                      _GuideItem('Lower Anterior',
                          'Probe in 4th–5th intercostal space, mid-clavicular line.'),
                      _GuideItem('Lateral',
                          'Probe in mid-axillary line at level of 3rd–4th intercostal space.'),
                      _GuideItem('Posterior Upper / Lower',
                          '(10-zone only) Probe at paraspinal / posterior axillary line above and below scapula.'),
                    ],
                    cs: cs,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: cs.onSurface.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded,
                            size: 14,
                            color: cs.onSurface.withValues(alpha: 0.4)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Brat R, et al. Lung Ultrasonography Score to Evaluate Oxygenation '
                            'and Surfactant Need in Neonates Born Very Preterm. '
                            'JAMA Pediatr. 2015;169(8):e151797.',
                            style: TextStyle(
                              fontSize: 11,
                              color: cs.onSurface.withValues(alpha: 0.5),
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _GuideSection extends StatelessWidget {
  final String title;
  final List<_GuideItem> items;
  final ColorScheme cs;

  const _GuideSection({
    required this.title,
    required this.items,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: cs.primary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 7),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.only(top: 5, right: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cs.primary.withValues(alpha: 0.5),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withValues(alpha: 0.8),
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: '${item.label}:  ',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600),
                          ),
                          TextSpan(text: item.detail),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

class _GuideItem {
  final String label;
  final String detail;
  const _GuideItem(this.label, this.detail);
}
