import 'dart:math';
import 'package:flutter/material.dart';

// ── Color tokens ──────────────────────────────────────────────────────────────
const Color _burnColor = Color(0xFFE65100);   // selected / burned regions
const Color _accent    = Color(0xFFB71C1C);   // header accent

class LundBrowderScreen extends StatefulWidget {
  const LundBrowderScreen({super.key});

  @override
  State<LundBrowderScreen> createState() => _LundBrowderScreenState();
}

class _LundBrowderScreenState extends State<LundBrowderScreen> {
  // ── State ─────────────────────────────────────────────────────────────────
  String _ageGroup = 'Adult'; // 'Infant' | 'Child' | 'Adult'
  final Map<String, double> _selected = {}; // region id → fraction

  // ── TBSA data (exact values from spec) ───────────────────────────────────
  static const Map<String, Map<String, double>> _pcts = {
    'Adult': {
      'head': 9,  'anterior_trunk': 18, 'posterior_trunk': 18,
      'left_arm': 9, 'right_arm': 9,
      'left_leg': 18, 'right_leg': 18, 'perineum': 1,
    },
    'Child': {
      'head': 18, 'anterior_trunk': 18, 'posterior_trunk': 18,
      'left_arm': 9, 'right_arm': 9,
      'left_leg': 14, 'right_leg': 14, 'perineum': 1,
    },
    'Infant': {
      'head': 19, 'anterior_trunk': 18, 'posterior_trunk': 18,
      'left_arm': 9, 'right_arm': 9,
      'left_leg': 13, 'right_leg': 13, 'perineum': 1,
    },
  };

  static const Map<String, String> _names = {
    'head':            'Head',
    'anterior_trunk':  'Anterior Trunk',
    'posterior_trunk': 'Posterior Trunk',
    'left_arm':        'Left Arm',
    'right_arm':       'Right Arm',
    'left_leg':        'Left Leg',
    'right_leg':       'Right Leg',
    'perineum':        'Perineum',
  };

  double _pct(String id) => _pcts[_ageGroup]?[id] ?? 0;

  double get _tbsa {
    double t = 0;
    for (final e in _selected.entries) { t += _pct(e.key) * e.value; }
    return t;
  }

  // ── Interaction ───────────────────────────────────────────────────────────
  void _onRegionTap(String id) {
    if (_selected.containsKey(id)) {
      // Already selected → remove
      setState(() => _selected.remove(id));
    } else {
      // New selection → add at full, then offer fraction choice
      setState(() => _selected[id] = 1.0);
      _showFractionSheet(id);
    }
  }

  void _showFractionSheet(String id) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) => _FractionSheet(
        name:      _names[id] ?? id,
        regionPct: _pct(id),
        current:   _selected[id] ?? 1.0,
        onSelect:  (f) { setState(() => _selected[id] = f); Navigator.pop(context); },
        onRemove:  ()  { setState(() => _selected.remove(id)); Navigator.pop(context); },
      ),
    );
  }

  void _reset() => setState(() { _selected.clear(); });

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs     = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Lund & Browder Chart'),
        actions: [
          TextButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Reset'),
            style: TextButton.styleFrom(foregroundColor: _accent),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── TBSA summary ──────────────────────────────────────────
              _TbsaCard(tbsa: _tbsa, cs: cs),
              const SizedBox(height: 14),

              // ── Age group selector ────────────────────────────────────
              _AgeSelector(
                selected: _ageGroup,
                pcts: _pcts,
                onChanged: (g) => setState(() { _ageGroup = g; _selected.clear(); }),
                isDark: isDark,
              ),
              const SizedBox(height: 16),

              // ── Body map ──────────────────────────────────────────────
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  child: Column(
                    children: [
                      Text(
                        'Tap to select burned regions',
                        style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurface.withValues(alpha: 0.5)),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: LayoutBuilder(builder: (_, box) {
                          final w = min(box.maxWidth * 0.75, 220.0);
                          return _BodyMapWidget(
                            width: w,
                            selected: Map.unmodifiable(_selected),
                            isDark: isDark,
                            onTap: _onRegionTap,
                          );
                        }),
                      ),
                      const SizedBox(height: 10),
                      // Legend
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _legendDot(
                              isDark ? const Color(0xFF4A4A4A) : const Color(0xFFD0D0D0),
                              'Unburned', cs),
                          const SizedBox(width: 20),
                          _legendDot(_burnColor, 'Burned', cs),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),

              // ── Hint text ─────────────────────────────────────────────
              Center(
                child: Text(
                  _selected.isEmpty
                      ? 'Tap a body region to begin'
                      : 'Tap a selected region to remove it • Tap fraction to change',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurface.withValues(alpha: 0.4)),
                ),
              ),
              const SizedBox(height: 14),

              // ── Selected regions list ─────────────────────────────────
              if (_selected.isNotEmpty)
                _RegionsList(
                  selected: _selected,
                  names: _names,
                  getPct: _pct,
                  onFractionTap: _showFractionSheet,
                  isDark: isDark,
                  cs: cs,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label, ColorScheme cs) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 12, height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black26, width: 0.5),
        ),
      ),
      const SizedBox(width: 5),
      Text(label,
          style: TextStyle(fontSize: 11, color: cs.onSurface.withValues(alpha: 0.5))),
    ],
  );
}

// ── TBSA Card ─────────────────────────────────────────────────────────────────

class _TbsaCard extends StatelessWidget {
  final double tbsa;
  final ColorScheme cs;
  const _TbsaCard({required this.tbsa, required this.cs});

  String get _severity {
    if (tbsa == 0) return '';
    if (tbsa < 10)  return 'Minor Burn';
    if (tbsa < 20)  return 'Moderate Burn';
    if (tbsa < 40)  return 'Major Burn';
    return 'Critical Burn';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_accent.withValues(alpha: 0.85), _burnColor.withValues(alpha: 0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: _accent.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department, color: Colors.white, size: 34),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total TBSA Burned',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 2),
                Text('${tbsa.toStringAsFixed(1)}%',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        height: 1.0)),
              ],
            ),
          ),
          if (tbsa > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(_severity,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}

// ── Age selector ──────────────────────────────────────────────────────────────

class _AgeSelector extends StatelessWidget {
  final String selected;
  final Map<String, Map<String, double>> pcts;
  final ValueChanged<String> onChanged;
  final bool isDark;

  const _AgeSelector({
    required this.selected,
    required this.pcts,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Subtitle text per age group
    const subtitles = {
      'Infant': 'Head 19% · Each leg 13%',
      'Child':  'Head 18% · Each leg 14%',
      'Adult':  'Head 9% · Each leg 18%',
    };

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Age Group',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: cs.onSurface)),
            const SizedBox(height: 10),
            Row(
              children: ['Infant', 'Child', 'Adult'].map((g) {
                final isSelected = selected == g;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(g),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? _accent : _accent.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: isSelected
                                ? _accent
                                : _accent.withValues(alpha: 0.25)),
                      ),
                      child: Column(
                        children: [
                          Text(g,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isSelected ? Colors.white : _accent)),
                          const SizedBox(height: 2),
                          Text(subtitles[g] ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 9,
                                  color: isSelected
                                      ? Colors.white70
                                      : cs.onSurface.withValues(alpha: 0.45))),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Body map widget ───────────────────────────────────────────────────────────

// SVG viewBox: 0 0 200 400
// All coordinates match the spec exactly.

abstract class _Shape {
  bool hit(Offset pos, double scale);
  void draw(Canvas c, double scale, Paint fill, Paint stroke);
  Offset center(double scale);
}

class _CircleShape extends _Shape {
  final double cx, cy, r;
  _CircleShape(this.cx, this.cy, this.r);

  @override
  bool hit(Offset p, double scale) =>
      (p - Offset(cx * scale, cy * scale)).distance <= r * scale + 6;

  @override
  void draw(Canvas c, double scale, Paint fill, Paint stroke) {
    final o = Offset(cx * scale, cy * scale);
    c.drawCircle(o, r * scale, fill);
    c.drawCircle(o, r * scale, stroke);
  }

  @override
  Offset center(double scale) => Offset(cx * scale, cy * scale);
}

class _RectShape extends _Shape {
  final double x, y, w, h;
  _RectShape(this.x, this.y, this.w, this.h);

  Rect _rect(double scale) =>
      Rect.fromLTWH(x * scale, y * scale, w * scale, h * scale);

  @override
  bool hit(Offset p, double scale) => _rect(scale).inflate(4).contains(p);

  @override
  void draw(Canvas c, double scale, Paint fill, Paint stroke) {
    c.drawRect(_rect(scale), fill);
    c.drawRect(_rect(scale), stroke);
  }

  @override
  Offset center(double scale) {
    final r = _rect(scale);
    return r.center;
  }
}

class _Region {
  final String id;
  final _Shape shape;
  final String shortLabel;
  const _Region(this.id, this.shape, this.shortLabel);
}

// Matches SVG spec exactly
final _kRegions = [
  _Region('head',            _CircleShape(100, 40, 20),         'Head'),
  _Region('anterior_trunk',  _RectShape(70, 70, 60, 100),       'Ant.\nTrunk'),
  _Region('posterior_trunk', _RectShape(70, 180, 60, 100),      'Post.\nTrunk'),
  _Region('left_arm',        _RectShape(30, 80, 30, 120),       'L\nArm'),
  _Region('right_arm',       _RectShape(140, 80, 30, 120),      'R\nArm'),
  _Region('left_leg',        _RectShape(70, 290, 25, 100),      'L\nLeg'),
  _Region('right_leg',       _RectShape(105, 290, 25, 100),     'R\nLeg'),
  _Region('perineum',        _CircleShape(100, 280, 8),         ''),
];

class _BodyMapWidget extends StatelessWidget {
  final double width;
  final Map<String, double> selected;
  final bool isDark;
  final void Function(String) onTap;

  const _BodyMapWidget({
    required this.width,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scale  = width / 200.0;
    final height = scale * 400.0;

    return GestureDetector(
      onTapDown: (details) {
        final pos = details.localPosition;
        // Test regions in reverse draw order (top-most last drawn = tested first)
        for (final region in _kRegions.reversed) {
          if (region.shape.hit(pos, scale)) {
            onTap(region.id);
            return;
          }
        }
      },
      child: CustomPaint(
        size: Size(width, height),
        painter: _BodyPainter(
          selected: selected,
          isDark: isDark,
          scale: scale,
        ),
      ),
    );
  }
}

class _BodyPainter extends CustomPainter {
  final Map<String, double> selected;
  final bool isDark;
  final double scale;

  const _BodyPainter({
    required this.selected,
    required this.isDark,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final unselFill  = isDark ? const Color(0xFF4A4A4A) : const Color(0xFFD0D0D0);
    final strokeColor = isDark ? Colors.white38 : Colors.black38;

    for (final region in _kRegions) {
      final isSelected = selected.containsKey(region.id);
      final fraction   = selected[region.id] ?? 1.0;

      final fill = Paint()
        ..color = isSelected ? _burnColor : unselFill
        ..style = PaintingStyle.fill;

      final stroke = Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      region.shape.draw(canvas, scale, fill, stroke);

      // Short label inside the shape
      if (region.shortLabel.isNotEmpty) {
        _drawLabel(canvas, region.shortLabel, region.shape.center(scale),
            isSelected, scale);
      }

      // Fraction badge on selected regions
      if (isSelected && fraction < 1.0) {
        _drawFractionBadge(
            canvas, fraction, region.shape.center(scale), scale);
      }
    }
  }

  void _drawLabel(Canvas canvas, String label, Offset center,
      bool isSelected, double scale) {
    final textColor = isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black54);
    final lines  = label.split('\n');
    final fontSize = 7.5 * scale.clamp(0.9, 1.3);
    final lineH  = fontSize * 1.3;
    final startY = center.dy - (lines.length - 1) * lineH / 2;

    for (int i = 0; i < lines.length; i++) {
      final tp = TextPainter(
        text: TextSpan(
          text: lines[i],
          style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w600),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas,
          Offset(center.dx - tp.width / 2, startY + i * lineH - tp.height / 2));
    }
  }

  void _drawFractionBadge(Canvas canvas, double fraction, Offset center, double scale) {
    final label = fraction == 0.5 ? '½' : '¼';
    final badgeSize = 11.0 * scale.clamp(0.9, 1.2);

    // Badge circle
    final badgePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx + 8 * scale, center.dy - 8 * scale), badgeSize / 2, badgePaint);
    canvas.drawCircle(
        Offset(center.dx + 8 * scale, center.dy - 8 * scale), badgeSize / 2,
        Paint()
          ..color = _burnColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8);

    // Badge text
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
            color: _burnColor, fontSize: badgeSize * 0.75, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(
        canvas,
        Offset(
            center.dx + 8 * scale - tp.width / 2,
            center.dy - 8 * scale - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _BodyPainter old) =>
      old.selected != selected || old.isDark != isDark;
}

// ── Fraction picker bottom sheet ──────────────────────────────────────────────

class _FractionSheet extends StatelessWidget {
  final String name;
  final double regionPct;
  final double current;
  final void Function(double) onSelect;
  final VoidCallback onRemove;

  const _FractionSheet({
    required this.name,
    required this.regionPct,
    required this.current,
    required this.onSelect,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final fractions = [
      (1.0,   'Full',    '${regionPct.toStringAsFixed(0)}%'),
      (0.5,   'Half',    '${(regionPct * 0.5).toStringAsFixed(1)}%'),
      (0.25,  'Quarter', '${(regionPct * 0.25).toStringAsFixed(2)}%'),
    ];

    return Padding(
      padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 36, height: 4,
            decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),

          // Title
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: _burnColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_fire_department,
                    color: _burnColor, size: 18),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: cs.onSurface)),
                  Text('${regionPct.toStringAsFixed(0)}% of total BSA',
                      style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withValues(alpha: 0.5))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text('How much of this region is burned?',
              style: TextStyle(
                  fontSize: 13,
                  color: cs.onSurface.withValues(alpha: 0.7))),
          const SizedBox(height: 12),

          // Fraction buttons
          Row(
            children: fractions.map((item) {
              final isSelected = (current - item.$1).abs() < 0.01;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSelect(item.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 130),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? _burnColor : _burnColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: isSelected
                              ? _burnColor
                              : _burnColor.withValues(alpha: 0.25)),
                    ),
                    child: Column(
                      children: [
                        Text(item.$2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isSelected ? Colors.white : _burnColor)),
                        const SizedBox(height: 2),
                        Text(item.$3,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 11,
                                color: isSelected
                                    ? Colors.white70
                                    : cs.onSurface.withValues(alpha: 0.45))),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Remove button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onRemove,
              icon: const Icon(Icons.remove_circle_outline, size: 16),
              label: const Text('Remove this region'),
              style: OutlinedButton.styleFrom(
                foregroundColor: cs.onSurface.withValues(alpha: 0.6),
                side: BorderSide(color: cs.onSurface.withValues(alpha: 0.2)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Selected regions list ─────────────────────────────────────────────────────

class _RegionsList extends StatelessWidget {
  final Map<String, double> selected;
  final Map<String, String> names;
  final double Function(String) getPct;
  final void Function(String) onFractionTap;
  final bool isDark;
  final ColorScheme cs;

  const _RegionsList({
    required this.selected,
    required this.names,
    required this.getPct,
    required this.onFractionTap,
    required this.isDark,
    required this.cs,
  });

  String _fractionLabel(double f) {
    if ((f - 1.0).abs() < 0.01)  return 'Full';
    if ((f - 0.5).abs() < 0.01)  return 'Half';
    if ((f - 0.25).abs() < 0.01) return 'Quarter';
    return '${(f * 100).toStringAsFixed(0)}%';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.checklist_rounded, color: _burnColor, size: 16),
                const SizedBox(width: 7),
                Text('Selected Regions',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: _burnColor)),
              ],
            ),
            const Divider(height: 18),

            // Region rows
            ...selected.entries.map((e) {
              final pct    = getPct(e.key);
              final contrib = pct * e.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    // Color dot
                    Container(
                      width: 8, height: 8,
                      decoration: const BoxDecoration(
                          color: _burnColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    // Name
                    Expanded(
                      child: Text(names[e.key] ?? e.key,
                          style: TextStyle(
                              fontSize: 13,
                              color: cs.onSurface)),
                    ),
                    // Fraction chip (tappable)
                    GestureDetector(
                      onTap: () => onFractionTap(e.key),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _burnColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: _burnColor.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_fractionLabel(e.value),
                                style: const TextStyle(
                                    color: _burnColor,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(width: 3),
                            const Icon(Icons.edit, color: _burnColor, size: 10),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Contribution
                    SizedBox(
                      width: 42,
                      child: Text(
                        '${contrib.toStringAsFixed(1)}%',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: cs.onSurface),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const Divider(height: 8),
            const SizedBox(height: 4),

            // Total row
            Row(
              children: [
                const Expanded(
                  child: Text('TBSA Total',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: _burnColor)),
                ),
                Text(
                  '${selected.entries.fold(0.0, (t, e) => t + getPct(e.key) * e.value).toStringAsFixed(1)}%',
                  style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: _burnColor),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
