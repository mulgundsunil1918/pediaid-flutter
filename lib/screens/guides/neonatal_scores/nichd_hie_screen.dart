import 'package:flutter/material.dart';

// ═════════════════════════════════════════════════════════════════════════════
// Data — exact text from source, not modified
// ═════════════════════════════════════════════════════════════════════════════

class _ARow {
  final String category;
  final String normal;
  final String mild;
  final String moderate;
  final String severe;
  const _ARow(this.category, this.normal, this.mild, this.moderate, this.severe);
}

const List<_ARow> _tableRows = [
  _ARow(
    '1. Level of\nConsciousness',
    'Alert, responsive to stimuli (state dependent)',
    'Hyperalert, staring, jittery, high pitched cry, exaggerated response to minimal stimuli, inconsolable',
    'Lethargy',
    'Stupor/ comatose',
  ),
  _ARow(
    '2. Spontaneous\nActivity',
    'Normal, changes position when awake',
    'Normal, or decreased, with or without periods of excessive activity',
    'Decreased',
    'No activity',
  ),
  _ARow(
    '3. Posture',
    'Predominantly flexed when quiet',
    'Mild flexion of distal joints (fingers, wrists)',
    'Strong distal flexion, complete extension',
    'Intermittent decerebration',
  ),
  _ARow(
    '4. Tone',
    'Strong flexor tone in all extremities',
    'Normal or slightly increased peripheral tone',
    'Hypotonia or hypertonia',
    'Flaccid or rigid',
  ),
  _ARow(
    '5. Reflexes\n— Suck',
    'Strong, easy to elicit',
    'Weak, poor',
    'Weak or has bite',
    'Absent',
  ),
  _ARow(
    '5. Reflexes\n— Moro',
    'Complete',
    'Partial response, low threshold to elicit',
    'Incomplete',
    'Absent',
  ),
  _ARow(
    '6. Autonomic\n— Pupils',
    'Normal\n(Dark 2.5–4.5mm,\nLight 1.5–2.5mm)',
    'Mydriasis',
    'Constricted',
    'Deviated, non-reactive, dilated',
  ),
  _ARow(
    '6. Autonomic\n— Heart rate',
    'Normal\n(100 to 160 bpm)',
    'Tachycardia >160/min',
    'Bradycardia <100/min',
    'Variable',
  ),
  _ARow(
    '6. Autonomic\n— Resp. rate',
    'Regular respirations',
    'Hyperventilation >60/min',
    'Periodic breathing',
    'Apnoea / ventilated',
  ),
];

const List<String> _riskCriteria = [
  'Apgar score ≤ 5 at 10 minutes',
  'Ongoing resuscitation / ventilation ≥ 10 minutes after birth',
  'Severe acidosis (pH < 7.1 or base excess ≤ −12 mmol/L) within 60 minutes of birth',
];

const String _postnatalCollapse =
    "Asphyxial 'event' needing resuscitation with evidence of acidosis";

const List<String> _clinicalSigns = [
  'Moderate/Severe HIE on NICHD Assessment (if HIE is mild, perform serial assessments until 6h)',
  'Evidence of Seizures (clinical and/or CFM)',
];

const List<String> _howToUse = [
  'NICHD Assessment – 6 categories with 9 clinical aspects in 4 domains (normal, mild, moderate, severe).',
  'Evaluate all 9 aspects. Circle the worst domain for each of the categories. In both reflexes and autonomic, the worst domain dictates severity (e.g. for reflexes, weak suck, absent Moro would put neonate as severe in that category).',
  'If two or more categories are not normal, (in any domain of HIE) then the neonate has at least mild HIE.',
  'If three or more categories are moderate or severe, then neonate has moderate or severe HIE.',
  '(e.g. 3 moderate, 2 severe, 1 mild = neonate would have moderate HIE).',
  'If there are an equal number in mod/severe, then Category 1 (LoC) dictates grade.',
  'Note if confirmed evidence of seizure activity, neonate classifies as at least moderate HIE.',
];

const List<String> _trackingRowLabels = ['1st:', '2nd:', '3rd:', '4th:', '5th:'];

const List<String> _finalDocFields = [
  'Decision to cool? Yes / No',
  'HIE Grade: None / Mild / Mod / Severe',
  'Time active cooling started',
  'Time target temperature achieved',
  'Notes',
  'Assessment completed by',
  'Grade',
  'Signature',
];

const List<String> _references = [
  'NICHD Neonatal Research Network',
  'Time = Brain (P. Rycroft, P. Reynolds, 2019)',
  'AAP Hypothermia Guidelines',
];

// Column widths for the assessment table
const double _wCat  = 150.0;
const double _wNorm = 148.0;
const double _wMild = 168.0;
const double _wMod  = 142.0;
const double _wSev  = 158.0;
const double _tableW = _wCat + _wNorm + _wMild + _wMod + _wSev;

// ═════════════════════════════════════════════════════════════════════════════
// Screen
// ═════════════════════════════════════════════════════════════════════════════

class NichdHieScreen extends StatelessWidget {
  const NichdHieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NICHD HIE Assessment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Full title ──────────────────────────────────────────────
              Text(
                'NICHD Neurological Assessment of a Neonate with risk factors for HIE',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),

              // ── Section 1: Assessment Table ─────────────────────────────
              _SecHeader('Assessment Table', cs),
              const SizedBox(height: 10),
              _AssessmentTable(cs: cs, isDark: isDark),
              const SizedBox(height: 22),

              // ── Section 2: Risk of Encephalopathy ───────────────────────
              _SecHeader('Risk of Encephalopathy', cs),
              const SizedBox(height: 10),
              _RiskSection(cs: cs, isDark: isDark),
              const SizedBox(height: 22),

              // ── Section 3: How to Use ───────────────────────────────────
              _SecHeader('How to Use', cs),
              const SizedBox(height: 10),
              _HowToUseSection(cs: cs, isDark: isDark),
              const SizedBox(height: 22),

              // ── Section 4: Assessment Tracking ──────────────────────────
              _SecHeader('Assessment Tracking', cs),
              const SizedBox(height: 10),
              _TrackingTable(cs: cs, isDark: isDark),
              const SizedBox(height: 22),

              // ── Section 5: Cooling Decision Flow ────────────────────────
              _SecHeader('Cooling Decision Flow', cs),
              const SizedBox(height: 10),
              _CoolingFlow(cs: cs, isDark: isDark),
              const SizedBox(height: 22),

              // ── Section 6: Final Documentation ──────────────────────────
              _SecHeader('Final Documentation', cs),
              const SizedBox(height: 10),
              _FinalDocSection(cs: cs, isDark: isDark),
              const SizedBox(height: 22),

              // ── References ──────────────────────────────────────────────
              _RefsBlock(cs: cs, isDark: isDark),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section header ─────────────────────────────────────────────────────────────

class _SecHeader extends StatelessWidget {
  final String title;
  final ColorScheme cs;
  const _SecHeader(this.title, this.cs);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3, height: 16,
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
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Section 1 — Assessment Table
// ═════════════════════════════════════════════════════════════════════════════

class _AssessmentTable extends StatelessWidget {
  final ColorScheme cs;
  final bool isDark;
  const _AssessmentTable({required this.cs, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final borderC  = cs.outline.withValues(alpha: isDark ? 0.30 : 0.22);
    final headerBg = cs.primary.withValues(alpha: isDark ? 0.22 : 0.10);
    final altBg    = cs.onSurface.withValues(alpha: isDark ? 0.06 : 0.03);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: _tableW,
            child: Column(
              children: [
                // ── NICHD Assessment label + Domains header ─────────────
                _buildDomainsRow(headerBg, borderC),

                // ── Sub-header row: Categories | Normal | Mild | Moderate | Severe ──
                _buildHeaderRow(headerBg, borderC),

                // ── Data rows ────────────────────────────────────────────
                ...List.generate(_tableRows.length, (i) {
                  final row = _tableRows[i];
                  final bg  = i.isOdd ? altBg : Colors.transparent;
                  return _buildDataRow(row, bg, borderC, i == _tableRows.length - 1);
                }),

                // ── Total in each domain row ─────────────────────────────
                _buildTotalRow(borderC, altBg),

                // ── Grade of HIE row ─────────────────────────────────────
                _buildGradeRow(borderC, headerBg),

                // ── Evidence of Seizures row ─────────────────────────────
                _buildSeizuresRow(borderC),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDomainsRow(Color headerBg, Color borderC) {
    return Container(
      color: headerBg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Cell(
            width: _wCat,
            text: 'NICHD\nAssessment',
            bold: true,
            cs: cs,
            borderC: borderC,
            showBottom: true,
          ),
          _Cell(
            width: _wNorm + _wMild + _wMod + _wSev,
            text: 'Domains',
            bold: true,
            cs: cs,
            borderC: borderC,
            showRight: false,
            showBottom: true,
            center: true,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(Color headerBg, Color borderC) {
    return Container(
      color: headerBg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Cell(width: _wCat,  text: 'Categories', bold: true, cs: cs, borderC: borderC, showBottom: true),
          _Cell(width: _wNorm, text: 'Normal',      bold: true, cs: cs, borderC: borderC, showBottom: true),
          _Cell(width: _wMild, text: 'MILD',        bold: true, cs: cs, borderC: borderC, showBottom: true),
          _Cell(width: _wMod,  text: 'MODERATE',    bold: true, cs: cs, borderC: borderC, showBottom: true),
          _Cell(width: _wSev,  text: 'SEVERE',      bold: true, cs: cs, borderC: borderC, showBottom: true, showRight: false),
        ],
      ),
    );
  }

  Widget _buildDataRow(_ARow row, Color bg, Color borderC, bool isLast) {
    return Container(
      color: bg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Cell(width: _wCat,  text: row.category, bold: true,  cs: cs, borderC: borderC, showBottom: !isLast),
          _Cell(width: _wNorm, text: row.normal,   bold: false, cs: cs, borderC: borderC, showBottom: !isLast),
          _Cell(width: _wMild, text: row.mild,     bold: false, cs: cs, borderC: borderC, showBottom: !isLast),
          _Cell(width: _wMod,  text: row.moderate, bold: false, cs: cs, borderC: borderC, showBottom: !isLast),
          _Cell(width: _wSev,  text: row.severe,   bold: false, cs: cs, borderC: borderC, showBottom: !isLast, showRight: false),
        ],
      ),
    );
  }

  Widget _buildTotalRow(Color borderC, Color altBg) {
    return Container(
      color: altBg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Cell(
            width: _wCat,
            text: 'Total in each\ndomain: (max 6)',
            bold: false,
            cs: cs,
            borderC: borderC,
            showBottom: true,
          ),
          _Cell(width: _wNorm, text: '', bold: false, cs: cs, borderC: borderC, showBottom: true),
          _Cell(width: _wMild, text: '', bold: false, cs: cs, borderC: borderC, showBottom: true),
          _Cell(width: _wMod,  text: '', bold: false, cs: cs, borderC: borderC, showBottom: true),
          _Cell(width: _wSev,  text: '', bold: false, cs: cs, borderC: borderC, showBottom: true, showRight: false),
        ],
      ),
    );
  }

  Widget _buildGradeRow(Color borderC, Color headerBg) {
    return Container(
      color: headerBg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Cell(width: _wCat,  text: 'Grade of HIE:', bold: true,  cs: cs, borderC: borderC, showBottom: true),
          _Cell(width: _wNorm, text: 'Normal',        bold: true,  cs: cs, borderC: borderC, showBottom: true, center: true),
          _Cell(width: _wMild, text: 'Mild',          bold: true,  cs: cs, borderC: borderC, showBottom: true, center: true),
          _Cell(width: _wMod,  text: 'Moderate',      bold: true,  cs: cs, borderC: borderC, showBottom: true, center: true),
          _Cell(width: _wSev,  text: 'Severe',        bold: true,  cs: cs, borderC: borderC, showBottom: true, showRight: false, center: true),
        ],
      ),
    );
  }

  Widget _buildSeizuresRow(Color borderC) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _Cell(width: _wCat, text: 'Evidence of\nSeizures:', bold: true, cs: cs, borderC: borderC, showBottom: false),
        // "No" spans Normal + Mild
        Container(
          width: _wNorm + _wMild,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: borderC, width: 0.8),
            ),
          ),
          child: Text(
            'No',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2E7D32),
            ),
          ),
        ),
        // "Yes" spans Moderate + Severe
        Container(
          width: _wMod + _wSev,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: borderC, width: 0.8),
            ),
          ),
          child: Text(
            'Yes',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFC62828),
            ),
          ),
        ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  final double width;
  final String text;
  final bool bold;
  final ColorScheme cs;
  final Color borderC;
  final bool showBottom;
  final bool showRight;
  final bool center;

  const _Cell({
    required this.width,
    required this.text,
    required this.bold,
    required this.cs,
    required this.borderC,
    this.showBottom = true,
    this.showRight  = true,
    this.center     = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        border: Border(
          right: showRight ? BorderSide(color: borderC, width: 0.8) : BorderSide.none,
          bottom: showBottom ? BorderSide(color: borderC, width: 0.8) : BorderSide.none,
        ),
      ),
      child: Text(
        text,
        textAlign: center ? TextAlign.center : TextAlign.left,
        style: TextStyle(
          fontSize: 12,
          fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
          color: bold ? cs.primary : cs.onSurface,
          height: 1.4,
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Section 2 — Risk of Encephalopathy
// ═════════════════════════════════════════════════════════════════════════════

class _RiskSection extends StatelessWidget {
  final ColorScheme cs;
  final bool isDark;
  const _RiskSection({required this.cs, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Box 1: Risk of Encephalopathy
        _OutlineBox(
          label: 'Risk of Encephalopathy (one of these)',
          labelColor: cs.primary,
          borderColor: cs.primary.withValues(alpha: 0.45),
          bg: cs.primary.withValues(alpha: isDark ? 0.1 : 0.05),
          cs: cs,
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _riskCriteria
                .map((c) => _BulletRow(text: c, cs: cs))
                .toList(),
          ),
        ),
        const SizedBox(height: 10),
        // Box 2: Postnatal Collapse
        _OutlineBox(
          label: 'Postnatal Collapse',
          labelColor: const Color(0xFFE65100),
          borderColor: const Color(0xFFE65100).withValues(alpha: 0.45),
          bg: const Color(0xFFE65100).withValues(alpha: isDark ? 0.1 : 0.05),
          cs: cs,
          isDark: isDark,
          child: Text(
            _postnatalCollapse,
            style: TextStyle(
              fontSize: 13,
              color: cs.onSurface,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Box 3: Clinical signs
        _OutlineBox(
          label: 'Clinical signs of encephalopathy (either/both)',
          labelColor: const Color(0xFFB71C1C),
          borderColor: const Color(0xFFB71C1C).withValues(alpha: 0.45),
          bg: const Color(0xFFB71C1C).withValues(alpha: isDark ? 0.1 : 0.05),
          cs: cs,
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _clinicalSigns
                .map((c) => _BulletRow(text: c, cs: cs))
                .toList(),
          ),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Section 3 — How to Use
// ═════════════════════════════════════════════════════════════════════════════

class _HowToUseSection extends StatelessWidget {
  final ColorScheme cs;
  final bool isDark;
  const _HowToUseSection({required this.cs, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: isDark ? 0.06 : 0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outline.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_howToUse.length, (i) {
          final isExample = _howToUse[i].startsWith('(e.g.');
          return Padding(
            padding: EdgeInsets.only(
              bottom: i < _howToUse.length - 1 ? 8 : 0,
              left: isExample ? 16 : 0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isExample) ...[
                  Container(
                    margin: const EdgeInsets.only(top: 5, right: 10),
                    width: 5, height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cs.primary,
                    ),
                  ),
                ],
                Expanded(
                  child: Text(
                    _howToUse[i],
                    style: TextStyle(
                      fontSize: isExample ? 11.5 : 12.5,
                      color: isExample
                          ? cs.onSurface.withValues(alpha: 0.55)
                          : cs.onSurface,
                      fontStyle: isExample ? FontStyle.italic : FontStyle.normal,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Section 4 — Assessment Tracking Table
// ═════════════════════════════════════════════════════════════════════════════

class _TrackingTable extends StatelessWidget {
  final ColorScheme cs;
  final bool isDark;
  const _TrackingTable({required this.cs, required this.isDark});

  static const List<String> _cols = [
    'Assessment',
    'Time (24h)',
    'Age',
    'NICHD Score',
    'Seizures\n(Y/N)',
    'CFM',
  ];
  static const List<double> _colW = [90, 85, 70, 90, 80, 70];
  static double get _totalW => _colW.fold(0, (a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    final borderC  = cs.outline.withValues(alpha: isDark ? 0.30 : 0.22);
    final headerBg = cs.primary.withValues(alpha: isDark ? 0.22 : 0.10);
    final altBg    = cs.onSurface.withValues(alpha: isDark ? 0.06 : 0.03);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: _totalW,
            child: Column(
              children: [
                // Header
                Container(
                  color: headerBg,
                  child: Row(
                    children: List.generate(_cols.length, (ci) {
                      return _TCell(
                        width: _colW[ci],
                        text: _cols[ci],
                        bold: true,
                        cs: cs,
                        borderC: borderC,
                        showBottom: true,
                        showRight: ci < _cols.length - 1,
                      );
                    }),
                  ),
                ),
                // Data rows
                ...List.generate(_trackingRowLabels.length, (ri) {
                  final bg = ri.isOdd ? altBg : Colors.transparent;
                  final isLast = ri == _trackingRowLabels.length - 1;
                  return Container(
                    color: bg,
                    child: Row(
                      children: List.generate(_cols.length, (ci) {
                        return _TCell(
                          width: _colW[ci],
                          text: ci == 0 ? _trackingRowLabels[ri] : '',
                          bold: ci == 0,
                          cs: cs,
                          borderC: borderC,
                          showBottom: !isLast,
                          showRight: ci < _cols.length - 1,
                        );
                      }),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TCell extends StatelessWidget {
  final double width;
  final String text;
  final bool bold;
  final ColorScheme cs;
  final Color borderC;
  final bool showBottom;
  final bool showRight;

  const _TCell({
    required this.width,
    required this.text,
    required this.bold,
    required this.cs,
    required this.borderC,
    this.showBottom = true,
    this.showRight  = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          right: showRight ? BorderSide(color: borderC, width: 0.8) : BorderSide.none,
          bottom: showBottom ? BorderSide(color: borderC, width: 0.8) : BorderSide.none,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
          color: bold ? cs.primary : cs.onSurface,
          height: 1.3,
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Section 5 — Cooling Decision Flow
// ═════════════════════════════════════════════════════════════════════════════

class _CoolingFlow extends StatelessWidget {
  final ColorScheme cs;
  final bool isDark;
  const _CoolingFlow({required this.cs, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Step 1: Risk / Postnatal Collapse
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _FlowBox(
                label: 'Risk of Encephalopathy\n(one of these)',
                color: cs.primary,
                isDark: isDark,
                cs: cs,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _riskCriteria
                      .map((c) => _BulletRow(text: c, cs: cs, fontSize: 11.5))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _FlowBox(
                label: 'Postnatal Collapse',
                color: const Color(0xFFE65100),
                isDark: isDark,
                cs: cs,
                child: Text(
                  _postnatalCollapse,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: cs.onSurface,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
        _Arrow(cs: cs),

        // Step 2: Clinical signs
        _FlowBox(
          label: 'Clinical signs of encephalopathy (either/both)',
          color: const Color(0xFFB71C1C),
          isDark: isDark,
          cs: cs,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _clinicalSigns
                .map((c) => _BulletRow(text: c, cs: cs, fontSize: 11.5))
                .toList(),
          ),
        ),
        _Arrow(cs: cs),

        // Step 3: Decision box
        _FlowBox(
          label: 'Evaluate:',
          color: cs.primary,
          isDark: isDark,
          cs: cs,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Moderate / Severe HIE on NICHD assessment',
                style: TextStyle(fontSize: 12, color: cs.onSurface, height: 1.4),
              ),
              Text(
                'AND / OR',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface.withValues(alpha: 0.55),
                ),
              ),
              Text(
                'Evidence of seizures (clinical and/or CFM)',
                style: TextStyle(fontSize: 12, color: cs.onSurface, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // YES / NO branches
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // YES branch (left)
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _YesNoLabel('YES', const Color(0xFF2E7D32), cs),
                  _Arrow(cs: cs),
                  // Age gate
                  _FlowBox(
                    label: 'Age gate:',
                    color: cs.primary,
                    isDark: isDark,
                    cs: cs,
                    child: Text(
                      'Age < 6 hours and ≥ 35 weeks gestation',
                      style: TextStyle(fontSize: 12, color: cs.onSurface, height: 1.4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // YES → Start cooling
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _YesNoLabel('YES', const Color(0xFF2E7D32), cs),
                      const SizedBox(width: 8),
                      const Text('▼', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withValues(alpha: isDark ? 0.2 : 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF2E7D32).withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'Start active cooling',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // NO → Uncertain
                  _YesNoLabel('NO', const Color(0xFFC62828), cs),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC62828).withValues(alpha: isDark ? 0.1 : 0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFC62828).withValues(alpha: 0.4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'If uncertain whether cooling is indicated\n'
                          '(e.g. postnatal collapse, abnormal CFM, > 6h etc)\n'
                          'discuss with local NICU consultant',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: cs.onSurface,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(children: [
                          Text(
                            'Discussed with: ',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: cs.outline.withValues(alpha: 0.4),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // NO branch (right)
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _YesNoLabel('NO', const Color(0xFFC62828), cs),
                  _Arrow(cs: cs),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC62828).withValues(alpha: isDark ? 0.2 : 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFC62828).withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'Do not cool',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFC62828),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Arrow extends StatelessWidget {
  final ColorScheme cs;
  const _Arrow({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Text(
          '▼',
          style: TextStyle(
            fontSize: 18,
            color: cs.onSurface.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}

class _YesNoLabel extends StatelessWidget {
  final String label;
  final Color color;
  final ColorScheme cs;
  const _YesNoLabel(this.label, this.color, this.cs);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text('▼', style: TextStyle(fontSize: 14, color: color.withValues(alpha: 0.6))),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Section 6 — Final Documentation
// ═════════════════════════════════════════════════════════════════════════════

class _FinalDocSection extends StatelessWidget {
  final ColorScheme cs;
  final bool isDark;
  const _FinalDocSection({required this.cs, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outline.withValues(alpha: 0.25)),
        color: cs.onSurface.withValues(alpha: isDark ? 0.04 : 0.02),
      ),
      child: Column(
        children: List.generate(_finalDocFields.length, (i) {
          final isLast = i == _finalDocFields.length - 1;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : Border(
                      bottom: BorderSide(
                        color: cs.outline.withValues(alpha: 0.18),
                      ),
                    ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _finalDocFields[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  height: 1,
                  color: cs.outline.withValues(alpha: 0.3),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// References
// ═════════════════════════════════════════════════════════════════════════════

class _RefsBlock extends StatelessWidget {
  final ColorScheme cs;
  final bool isDark;
  const _RefsBlock({required this.cs, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: isDark ? 0.06 : 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outline.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'REFERENCES',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: cs.onSurface.withValues(alpha: 0.4),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          ..._references.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  '• $r',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: cs.onSurface.withValues(alpha: 0.55),
                    height: 1.45,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Shared helpers
// ═════════════════════════════════════════════════════════════════════════════

class _OutlineBox extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Color borderColor;
  final Color bg;
  final ColorScheme cs;
  final bool isDark;
  final Widget child;

  const _OutlineBox({
    required this.label,
    required this.labelColor,
    required this.borderColor,
    required this.bg,
    required this.cs,
    required this.isDark,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: labelColor,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _FlowBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDark;
  final ColorScheme cs;
  final Widget child;

  const _FlowBox({
    required this.label,
    required this.color,
    required this.isDark,
    required this.cs,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.1 : 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  final String text;
  final ColorScheme cs;
  final double fontSize;
  const _BulletRow({required this.text, required this.cs, this.fontSize = 12.5});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, right: 8),
            child: Container(
              width: 5, height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: cs.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
