// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'clinical_wizards.dart';

// =============================================================================
// SCREEN 1 — ProbePositionsScreen
// =============================================================================

class ProbePositionsScreen extends StatefulWidget {
  const ProbePositionsScreen({super.key});

  @override
  State<ProbePositionsScreen> createState() => _ProbePositionsScreenState();
}

class _ProbePositionsScreenState extends State<ProbePositionsScreen> {
  int? _highlightedIndex;
  final List<GlobalKey> _cardKeys = List.generate(4, (_) => GlobalKey());
  final ScrollController _scrollCtrl = ScrollController();

  static const List<String> _windowNames = [
    'Subcostal',
    'Apical',
    'Parasternal',
    'Suprasternal',
  ];

  static const List<Color> _windowColors = [
    Color(0xFF1565C0),
    Color(0xFFC62828),
    Color(0xFF2E7D32),
    Color(0xFF6A1B9A),
  ];

  static const List<String> _orientations = [
    'Just below xiphoid, varied tilts',
    'Below left nipple at 3 O\'clock, heart vertical on screen',
    '3rd left intercostal space, 11 O\'clock (PLAX) or 1 O\'clock (PSAX)',
    'Suprasternal notch, 12–1 O\'clock with left shoulder tilt',
  ];

  static const List<List<String>> _views = [
    ['IVC long axis', 'Subcostal 4-chamber', 'Abdominal aorta (long axis)', 'SVC-RA junction'],
    ['Apical 4-chamber', 'Apical 5-chamber', 'Apical 2-chamber (for biplane Simpson)'],
    ['Parasternal long axis (PLAX)', 'Parasternal short axis (PSAX)'],
    ['Three-legged stool (RPA, LPA, DA)', 'Aortic arch long axis', 'Crab\'s view (pulmonary veins)'],
  ];

  static const List<List<String>> _measurements = [
    ['IVC Collapsibility / Distensibility', 'SVC Flow', 'Shunt through PFO', 'UVC tip position', 'Celiac & SMA Doppler'],
    ['Ejection Fraction (Biplane Simpson)', 'LVO', 'E/A ratio', 'IVRT', 'TR jet (PAPSp)', 'Septal deviation'],
    ['LA/Ao ratio', 'Shortening fraction', 'RVO', 'MPA diameter & Doppler', 'LPA Doppler', 'Eccentricity index', 'PAAT'],
    ['Ductal diameter (TDD) & flow pattern', 'Aortic arch / DTA Doppler', 'Pulmonary vein drainage'],
  ];

  void _onDotTapped(int index) {
    setState(() => _highlightedIndex = index);
    // Scroll to card
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _cardKeys[index].currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 64,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Probe Positions',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              'Neonatal echo windows',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.80),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        controller: _scrollCtrl,
        padding: const EdgeInsets.all(16),
        children: [
          // Diagram card
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Tap a probe position to highlight the window',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: cs.onSurface.withValues(alpha: 0.55),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 280,
                  child: _NeonateTorsoWidget(
                    highlightedIndex: _highlightedIndex,
                    windowColors: _windowColors,
                    onDotTapped: _onDotTapped,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(height: 12),
                // Legend
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: List.generate(4, (i) => _LegendDot(
                    color: _windowColors[i],
                    label: _windowNames[i],
                    isHighlighted: _highlightedIndex == i,
                    onTap: () => _onDotTapped(i),
                  )),
                ),
              ],
            ),
          ),
          // Window cards
          ...List.generate(4, (i) => _ProbeWindowCard(
            key: _cardKeys[i],
            name: _windowNames[i],
            color: _windowColors[i],
            orientation: _orientations[i],
            views: _views[i],
            measurements: _measurements[i],
            isHighlighted: _highlightedIndex == i,
            onTap: () => setState(() => _highlightedIndex = i),
          )),
          const SizedBox(height: 8),
          _ReferenceFooter(
            text: 'ASE/CSE Targeted Neonatal Echocardiography Guidelines 2024.',
          ),
        ],
      ),
    );
  }
}

// ── Neonate torso widget ────────────────────────────────────────────────────

class _NeonateTorsoWidget extends StatelessWidget {
  final int? highlightedIndex;
  final List<Color> windowColors;
  final void Function(int) onDotTapped;
  final bool isDark;

  const _NeonateTorsoWidget({
    required this.highlightedIndex,
    required this.windowColors,
    required this.onDotTapped,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      final w = constraints.maxWidth;
      final h = constraints.maxHeight;
      return Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(w, h),
            painter: _TorsoPainter(isDark: isDark),
          ),
          // Dot positions (fractional of torso area)
          // Suprasternal: top centre
          _ProbeDot(
            x: w * 0.5,
            y: h * 0.10,
            color: windowColors[3],
            index: 3,
            highlighted: highlightedIndex == 3,
            onTap: onDotTapped,
          ),
          // Parasternal: left upper chest
          _ProbeDot(
            x: w * 0.38,
            y: h * 0.32,
            color: windowColors[2],
            index: 2,
            highlighted: highlightedIndex == 2,
            onTap: onDotTapped,
          ),
          // Apical: left lower chest
          _ProbeDot(
            x: w * 0.35,
            y: h * 0.55,
            color: windowColors[1],
            index: 1,
            highlighted: highlightedIndex == 1,
            onTap: onDotTapped,
          ),
          // Subcostal: just below xiphoid (midline, lower)
          _ProbeDot(
            x: w * 0.50,
            y: h * 0.70,
            color: windowColors[0],
            index: 0,
            highlighted: highlightedIndex == 0,
            onTap: onDotTapped,
          ),
        ],
      );
    });
  }
}

class _TorsoPainter extends CustomPainter {
  final bool isDark;
  _TorsoPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final skinColor = isDark ? const Color(0xFF4A3728) : const Color(0xFFFFDDB8);
    final outlineColor = isDark ? const Color(0xFF8D6E63) : const Color(0xFFBF8C6E);
    final featureColor = isDark ? const Color(0xFF6D4C41) : const Color(0xFFD4A574);

    final bodyPaint = Paint()..color = skinColor;
    final outlinePaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final featurePaint = Paint()..color = featureColor;

    final cx = size.width / 2;

    // Head
    final headRadius = size.width * 0.13;
    final headCy = size.height * 0.08;
    canvas.drawCircle(Offset(cx, headCy), headRadius, bodyPaint);
    canvas.drawCircle(Offset(cx, headCy), headRadius, outlinePaint);

    // Neck
    final neckW = size.width * 0.08;
    final neckTop = headCy + headRadius;
    final neckBot = size.height * 0.18;
    canvas.drawRect(
      Rect.fromLTRB(cx - neckW, neckTop, cx + neckW, neckBot),
      bodyPaint,
    );

    // Torso (rounded rectangle)
    final torsoLeft = cx - size.width * 0.22;
    final torsoRight = cx + size.width * 0.22;
    final torsoTop = neckBot;
    final torsoBottom = size.height * 0.82;
    final torsoRRect = RRect.fromLTRBR(
      torsoLeft, torsoTop, torsoRight, torsoBottom,
      const Radius.circular(18),
    );
    canvas.drawRRect(torsoRRect, bodyPaint);
    canvas.drawRRect(torsoRRect, outlinePaint);

    // Sternum line
    final sternumPaint = Paint()
      ..color = outlineColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx, torsoTop + 10),
      Offset(cx, torsoTop + (torsoBottom - torsoTop) * 0.55),
      sternumPaint,
    );

    // Ribs (3 pairs, simple arcs)
    final ribPaint = Paint()
      ..color = outlineColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (int r = 0; r < 3; r++) {
      final ry = torsoTop + (torsoBottom - torsoTop) * (0.20 + r * 0.16);
      final ribW = size.width * (0.14 - r * 0.01);
      final path = Path();
      path.moveTo(cx, ry);
      path.quadraticBezierTo(cx - ribW * 0.5, ry - 6, cx - ribW, ry);
      canvas.drawPath(path, ribPaint);
      final path2 = Path();
      path2.moveTo(cx, ry);
      path2.quadraticBezierTo(cx + ribW * 0.5, ry - 6, cx + ribW, ry);
      canvas.drawPath(path2, ribPaint);
    }

    // Left arm
    final leftArmPath = Path();
    leftArmPath.moveTo(torsoLeft, torsoTop + 20);
    leftArmPath.quadraticBezierTo(
      torsoLeft - size.width * 0.10,
      torsoTop + (torsoBottom - torsoTop) * 0.25,
      torsoLeft - size.width * 0.08,
      torsoTop + (torsoBottom - torsoTop) * 0.55,
    );
    leftArmPath.lineTo(torsoLeft - size.width * 0.04, torsoTop + (torsoBottom - torsoTop) * 0.55);
    leftArmPath.quadraticBezierTo(
      torsoLeft - size.width * 0.02,
      torsoTop + (torsoBottom - torsoTop) * 0.25,
      torsoLeft + 8,
      torsoTop + 20,
    );
    leftArmPath.close();
    canvas.drawPath(leftArmPath, bodyPaint);
    canvas.drawPath(leftArmPath, outlinePaint);

    // Right arm
    final rightArmPath = Path();
    rightArmPath.moveTo(torsoRight, torsoTop + 20);
    rightArmPath.quadraticBezierTo(
      torsoRight + size.width * 0.10,
      torsoTop + (torsoBottom - torsoTop) * 0.25,
      torsoRight + size.width * 0.08,
      torsoTop + (torsoBottom - torsoTop) * 0.55,
    );
    rightArmPath.lineTo(torsoRight + size.width * 0.04, torsoTop + (torsoBottom - torsoTop) * 0.55);
    rightArmPath.quadraticBezierTo(
      torsoRight + size.width * 0.02,
      torsoTop + (torsoBottom - torsoTop) * 0.25,
      torsoRight - 8,
      torsoTop + 20,
    );
    rightArmPath.close();
    canvas.drawPath(rightArmPath, bodyPaint);
    canvas.drawPath(rightArmPath, outlinePaint);

    // Nipples
    final nippleR = size.width * 0.018;
    final nippleY = torsoTop + (torsoBottom - torsoTop) * 0.28;
    canvas.drawCircle(Offset(cx - size.width * 0.10, nippleY), nippleR, featurePaint);
    canvas.drawCircle(Offset(cx + size.width * 0.10, nippleY), nippleR, featurePaint);
  }

  @override
  bool shouldRepaint(_TorsoPainter old) => old.isDark != isDark;
}

class _ProbeDot extends StatelessWidget {
  final double x;
  final double y;
  final Color color;
  final int index;
  final bool highlighted;
  final void Function(int) onTap;

  const _ProbeDot({
    required this.x,
    required this.y,
    required this.color,
    required this.index,
    required this.highlighted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = highlighted ? 16.0 : 12.0;
    return Positioned(
      left: x - radius,
      top: y - radius,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            color: color.withValues(alpha: highlighted ? 1.0 : 0.85),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: highlighted ? 2.5 : 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: highlighted ? 10 : 4,
                spreadRadius: highlighted ? 2 : 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _LegendDot({
    required this.color,
    required this.label,
    required this.isHighlighted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isHighlighted ? Border.all(color: cs.onSurface, width: 1.5) : null,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
              color: isHighlighted ? color : cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProbeWindowCard extends StatelessWidget {
  final String name;
  final Color color;
  final String orientation;
  final List<String> views;
  final List<String> measurements;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _ProbeWindowCard({
    super.key,
    required this.name,
    required this.color,
    required this.orientation,
    required this.views,
    required this.measurements,
    required this.isHighlighted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(
            color: isHighlighted ? color.withValues(alpha: 0.6) : cs.onSurface.withValues(alpha: 0.1),
            width: isHighlighted ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: isHighlighted
              ? [BoxShadow(color: color.withValues(alpha: 0.18), blurRadius: 12, offset: const Offset(0, 4))]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header bar
            Container(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
              ),
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Orientation
                  _InfoRow(
                    icon: Icons.rotate_90_degrees_ccw,
                    label: 'Orientation',
                    value: orientation,
                    color: color,
                  ),
                  const SizedBox(height: 10),
                  // Views
                  _BulletSection(
                    title: 'Key Views',
                    items: views,
                    color: color,
                  ),
                  const SizedBox(height: 10),
                  // Measurements
                  _BulletSection(
                    title: 'Measurements',
                    items: measurements,
                    color: color,
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: color.withValues(alpha: 0.7)),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                TextSpan(
                  text: value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BulletSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color color;

  const _BulletSection({required this.title, required this.items, required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: cs.onSurface.withValues(alpha: 0.55),
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 4),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        color: cs.onSurface.withValues(alpha: 0.8),
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

// =============================================================================
// SCREEN 2 — WaveformGalleryScreen
// =============================================================================

class WaveformGalleryScreen extends StatelessWidget {
  const WaveformGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 64,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Waveform Gallery',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              'Doppler pattern reference',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.80),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _WaveformCard(
            title: 'Normal LVO Doppler',
            interpretation: 'Normal aortic outflow. Rapid upstroke, rounded peak, smooth downstroke.',
            color: const Color(0xFFC62828),
            waveformType: _WaveformType.normalLvo,
          ),
          _WaveformCard(
            title: 'High-output LVO (PDA)',
            interpretation: 'Wide tall envelope suggests high VTI → increased LVO, commonly from L→R ductal shunt or anaemia.',
            color: const Color(0xFFC62828),
            waveformType: _WaveformType.highLvo,
          ),
          _WaveformCard(
            title: 'Normal MPA Doppler',
            interpretation: 'Normal pulmonary outflow. Triangular shape with peak in mid-late systole.',
            color: const Color(0xFF1565C0),
            waveformType: _WaveformType.normalMpa,
          ),
          _WaveformCard(
            title: 'Elevated PVR (Notched MPA)',
            interpretation: 'Mid-systolic notching → elevated PVR / pulmonary hypertension. PAAT <55 ms. Watch for RV dysfunction.',
            color: const Color(0xFF1565C0),
            waveformType: _WaveformType.notchedMpa,
          ),
          _TrJetCard(cs: cs),
          _DuctalPatternCard(cs: cs),
          _WaveformCard(
            title: 'Normal MV Inflow (Neonatal)',
            interpretation: 'Neonates rely on atrial kick — A-dominant (A > E) is normal. E/A < 1.',
            color: const Color(0xFF2E7D32),
            waveformType: _WaveformType.normalMvInflow,
          ),
          _WaveformCard(
            title: 'Fused E and A Waves',
            interpretation: 'At high heart rates E and A fuse — E/A measurement unreliable. Skip if fused.',
            color: const Color(0xFF2E7D32),
            waveformType: _WaveformType.fusedEA,
          ),
          _IvcMmodeCard(cs: cs),
          _WaveformCard(
            title: 'Normal DTA Doppler',
            interpretation: 'Normal descending aortic flow. Systolic forward + small diastolic forward.',
            color: const Color(0xFFC62828),
            waveformType: _WaveformType.normalDta,
          ),
          _WaveformCard(
            title: 'Systemic Steal Pattern (Reversed DTA Diastolic)',
            interpretation: 'Reversed diastolic flow in DTA → systemic steal from hsPDA. NEC & IVH risk.',
            color: const Color(0xFFE65100),
            waveformType: _WaveformType.reversedDta,
          ),
          _WaveformCard(
            title: 'PAAT Measurement',
            interpretation: 'Measure from start of ejection to EARLIEST peak. Normal >65 ms. <55 ms = PH. <45 ms = severe PH.',
            color: const Color(0xFF1565C0),
            waveformType: _WaveformType.paatAnnotated,
          ),
          const SizedBox(height: 8),
          _ReferenceFooter(
            text: 'Adapted from Jain A et al., Semin Fetal Neonatal Med 2015; El-Khuffash AF et al. 2018.',
          ),
        ],
      ),
    );
  }
}

enum _WaveformType {
  normalLvo,
  highLvo,
  normalMpa,
  notchedMpa,
  normalMvInflow,
  fusedEA,
  normalDta,
  reversedDta,
  paatAnnotated,
}

// Normalised waveform point sets (x 0→1, y 0→1; baseline at y=0.5, above=positive flow, below=negative)
List<Offset> _waveformPoints(_WaveformType type) {
  switch (type) {
    case _WaveformType.normalLvo:
      return [
        const Offset(0.0, 0.5), const Offset(0.05, 0.5),
        const Offset(0.15, 0.12), const Offset(0.30, 0.08),
        const Offset(0.45, 0.10), const Offset(0.55, 0.20),
        const Offset(0.62, 0.50), const Offset(0.95, 0.50),
        const Offset(1.0, 0.5),
      ];
    case _WaveformType.highLvo:
      return [
        const Offset(0.0, 0.5), const Offset(0.05, 0.5),
        const Offset(0.12, 0.06), const Offset(0.28, 0.03),
        const Offset(0.45, 0.05), const Offset(0.58, 0.15),
        const Offset(0.68, 0.50), const Offset(0.95, 0.50),
        const Offset(1.0, 0.5),
      ];
    case _WaveformType.normalMpa:
      return [
        const Offset(0.0, 0.5), const Offset(0.05, 0.5),
        const Offset(0.18, 0.20), const Offset(0.38, 0.10),
        const Offset(0.52, 0.15), const Offset(0.63, 0.50),
        const Offset(0.95, 0.50), const Offset(1.0, 0.5),
      ];
    case _WaveformType.notchedMpa:
      return [
        const Offset(0.0, 0.5), const Offset(0.05, 0.5),
        const Offset(0.15, 0.15), const Offset(0.25, 0.12),
        const Offset(0.32, 0.20), // notch
        const Offset(0.38, 0.16),
        const Offset(0.48, 0.50), const Offset(0.95, 0.50),
        const Offset(1.0, 0.5),
      ];
    case _WaveformType.normalMvInflow:
      // E then A, with A > E (neonatal)
      return [
        const Offset(0.0, 0.5),
        const Offset(0.12, 0.5),
        const Offset(0.20, 0.28), // E peak
        const Offset(0.28, 0.5),
        const Offset(0.40, 0.5),
        const Offset(0.52, 0.18), // A peak (taller)
        const Offset(0.62, 0.5),
        const Offset(1.0, 0.5),
      ];
    case _WaveformType.fusedEA:
      return [
        const Offset(0.0, 0.5),
        const Offset(0.15, 0.5),
        const Offset(0.22, 0.30), // E
        const Offset(0.30, 0.22), // merged peak
        const Offset(0.38, 0.30), // A merging
        const Offset(0.46, 0.5),
        const Offset(1.0, 0.5),
      ];
    case _WaveformType.normalDta:
      return [
        const Offset(0.0, 0.5), const Offset(0.05, 0.5),
        const Offset(0.14, 0.15), const Offset(0.28, 0.12),
        const Offset(0.40, 0.20), const Offset(0.50, 0.50),
        const Offset(0.58, 0.44), // small diastolic forward
        const Offset(0.75, 0.47),
        const Offset(0.90, 0.50), const Offset(1.0, 0.5),
      ];
    case _WaveformType.reversedDta:
      return [
        const Offset(0.0, 0.5), const Offset(0.05, 0.5),
        const Offset(0.14, 0.14), const Offset(0.28, 0.11),
        const Offset(0.40, 0.20), const Offset(0.50, 0.50),
        const Offset(0.58, 0.60), // diastolic reversal
        const Offset(0.72, 0.68),
        const Offset(0.82, 0.60), const Offset(0.90, 0.50),
        const Offset(1.0, 0.5),
      ];
    case _WaveformType.paatAnnotated:
      return [
        const Offset(0.0, 0.5), const Offset(0.05, 0.5),
        const Offset(0.18, 0.15), // early peak (PAAT)
        const Offset(0.30, 0.20),
        const Offset(0.50, 0.50), const Offset(0.95, 0.50),
        const Offset(1.0, 0.5),
      ];
  }
}

class _WaveformPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final bool showBaseline;
  _WaveformPainter({
    required this.points,
    required this.color,
    this.showBaseline = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final baselinePaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..strokeWidth = 1.0;

    if (showBaseline) {
      canvas.drawLine(
        Offset(0, size.height * 0.5),
        Offset(size.width, size.height * 0.5),
        baselinePaint,
      );
    }



    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final first = Offset(points[0].dx * size.width, points[0].dy * size.height);
    path.moveTo(first.dx, first.dy);

    for (int i = 1; i < points.length - 1; i++) {
      final curr = Offset(points[i].dx * size.width, points[i].dy * size.height);
      final next = Offset(points[i + 1].dx * size.width, points[i + 1].dy * size.height);
      final cpX = (curr.dx + next.dx) / 2;
      final cpY = (curr.dy + next.dy) / 2;
      path.quadraticBezierTo(curr.dx, curr.dy, cpX, cpY);
    }

    final last = Offset(points.last.dx * size.width, points.last.dy * size.height);
    path.lineTo(last.dx, last.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WaveformPainter old) =>
      old.points != points || old.color != color;
}

class _WaveformCard extends StatelessWidget {
  final String title;
  final String interpretation;
  final Color color;
  final _WaveformType waveformType;

  const _WaveformCard({
    required this.title,
    required this.interpretation,
    required this.color,
    required this.waveformType,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final pts = _waveformPoints(waveformType);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: cs.onSurface.withValues(alpha: 0.07)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _WaveformPainter(points: pts, color: color, showBaseline: true),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Text(
              interpretation,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                color: cs.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// TR Jet dual waveform card
class _TrJetCard extends StatelessWidget {
  final ColorScheme cs;
  const _TrJetCard({required this.cs});

  @override
  Widget build(BuildContext context) {
    final smallTrPts = [
      const Offset(0.0, 0.5), const Offset(0.1, 0.5),
      const Offset(0.22, 0.38), const Offset(0.35, 0.36),
      const Offset(0.48, 0.40), const Offset(0.58, 0.5),
      const Offset(1.0, 0.5),
    ];
    final largeTrPts = [
      const Offset(0.0, 0.5), const Offset(0.08, 0.5),
      const Offset(0.18, 0.20), const Offset(0.30, 0.10),
      const Offset(0.42, 0.12), const Offset(0.55, 0.20),
      const Offset(0.65, 0.5), const Offset(1.0, 0.5),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Text(
              'TR Jet (Normal vs PPHN)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1565C0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Normal (0.5–2 m/s)',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: cs.onSurface.withValues(alpha: 0.6))),
                      const SizedBox(height: 4),
                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: cs.onSurface.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: cs.onSurface.withValues(alpha: 0.07)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: _WaveformPainter(
                              points: smallTrPts,
                              color: const Color(0xFF1565C0),
                              showBaseline: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      Text('PPHN (3+ m/s)',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: cs.onSurface.withValues(alpha: 0.6))),
                      const SizedBox(height: 4),
                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: cs.onSurface.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: cs.onSurface.withValues(alpha: 0.07)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: _WaveformPainter(
                              points: largeTrPts,
                              color: const Color(0xFFC62828),
                              showBaseline: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
            child: Text(
              'Record multiple cycles and pick MAXIMUM velocity. PAPSp = 4V² + RAP.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                color: cs.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Ductal flow patterns card (2x2 grid)
class _DuctalPatternCard extends StatelessWidget {
  final ColorScheme cs;
  const _DuctalPatternCard({required this.cs});

  @override
  Widget build(BuildContext context) {
    final patterns = [
      _DuctalPattern(
        label: 'Growing (L→R)',
        color: const Color(0xFF2E7D32),
        points: [
          const Offset(0.0, 0.5), const Offset(0.05, 0.5),
          const Offset(0.15, 0.38), const Offset(0.30, 0.35),
          const Offset(0.70, 0.36), const Offset(0.85, 0.42),
          const Offset(0.95, 0.5), const Offset(1.0, 0.5),
        ],
      ),
      _DuctalPattern(
        label: 'Pulsatile (L→R)',
        color: const Color(0xFF1565C0),
        points: [
          const Offset(0.0, 0.5),
          const Offset(0.10, 0.18), const Offset(0.20, 0.25),
          const Offset(0.30, 0.14), const Offset(0.40, 0.22),
          const Offset(0.50, 0.5),
          const Offset(0.60, 0.18), const Offset(0.70, 0.25),
          const Offset(0.80, 0.14), const Offset(0.90, 0.22),
          const Offset(1.0, 0.5),
        ],
      ),
      _DuctalPattern(
        label: 'Closing (restrict.)',
        color: const Color(0xFFE65100),
        points: [
          const Offset(0.0, 0.5), const Offset(0.05, 0.5),
          const Offset(0.15, 0.08), const Offset(0.28, 0.06),
          const Offset(0.42, 0.10), const Offset(0.52, 0.5),
          const Offset(0.95, 0.5), const Offset(1.0, 0.5),
        ],
      ),
      _DuctalPattern(
        label: 'Bidirectional/PH',
        color: const Color(0xFF6A1B9A),
        points: [
          const Offset(0.0, 0.5), const Offset(0.05, 0.5),
          const Offset(0.15, 0.20), // R→L systole (above baseline = reversed)
          const Offset(0.25, 0.50),
          const Offset(0.35, 0.65), // L→R diastole
          const Offset(0.55, 0.68),
          const Offset(0.65, 0.5),
          const Offset(0.75, 0.22), const Offset(0.82, 0.5),
          const Offset(0.88, 0.65), const Offset(0.95, 0.5),
          const Offset(1.0, 0.5),
        ],
      ),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Text(
              'Ductal Flow Patterns',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF6A1B9A),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.8,
              children: patterns.map((p) => Column(
                children: [
                  Text(p.label,
                      style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: p.color, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: cs.onSurface.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: cs.onSurface.withValues(alpha: 0.07)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: _WaveformPainter(points: p.points, color: p.color, showBaseline: true),
                        ),
                      ),
                    ),
                  ),
                ],
              )).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
            child: Text(
              'Ductal pattern predicts haemodynamic behaviour: growing = hsPDA risk; bidirectional = PPHN component.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                color: cs.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DuctalPattern {
  final String label;
  final Color color;
  final List<Offset> points;
  _DuctalPattern({required this.label, required this.color, required this.points});
}

// IVC M-mode card (3 sketches)
class _IvcMmodeCard extends StatelessWidget {
  final ColorScheme cs;
  const _IvcMmodeCard({required this.cs});

  @override
  Widget build(BuildContext context) {
    final normal = _buildMmodePainter(0.3, const Color(0xFF2E7D32));
    final plethoric = _buildMmodePainter(0.08, const Color(0xFF1565C0));
    final collapsed = _buildMmodePainter(0.72, const Color(0xFFC62828));

    Widget mmodeTile(String label, Color color, _MmodePainter painter) {
      return Column(
        children: [
          Text(label,
              style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: color, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: cs.onSurface.withValues(alpha: 0.07)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: CustomPaint(size: Size.infinite, painter: painter),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Text(
              'IVC M-mode (Normal vs Plethoric vs Collapsed)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2E7D32),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: SizedBox(
              height: 90,
              child: Row(
                children: [
                  Expanded(child: mmodeTile('Normal\n30–50%', const Color(0xFF2E7D32), normal)),
                  const SizedBox(width: 8),
                  Expanded(child: mmodeTile('Plethoric\n<30%', const Color(0xFF1565C0), plethoric)),
                  const SizedBox(width: 8),
                  Expanded(child: mmodeTile('Collapsed\n>50%', const Color(0xFFC62828), collapsed)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
            child: Text(
              'cIVC = (max-min)/max × 100. Spontaneous breathing: 30–50% = normal. >50% = underfilled. <30% = plethoric.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                color: cs.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _MmodePainter _buildMmodePainter(double collapsibility, Color color) {
    return _MmodePainter(collapsibility: collapsibility, color: color);
  }
}

class _MmodePainter extends CustomPainter {
  final double collapsibility; // 0=no variation, 1=full collapse
  final Color color;

  _MmodePainter({required this.collapsibility, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final midY = size.height * 0.5;
    final maxAmp = size.height * 0.35;
    final minAmp = maxAmp * (1 - collapsibility);

    final path = Path();
    const cycles = 3;
    final cycleWidth = size.width / cycles;

    for (int c = 0; c < cycles; c++) {
      final startX = c * cycleWidth;
      // Expiration (max diameter)
      path.moveTo(startX, midY - maxAmp);
      path.lineTo(startX + cycleWidth * 0.3, midY - maxAmp);
      // Inspiration (min diameter)
      path.lineTo(startX + cycleWidth * 0.4, midY - minAmp);
      path.lineTo(startX + cycleWidth * 0.7, midY - minAmp);
      // Back up
      path.lineTo(startX + cycleWidth * 0.8, midY - maxAmp);
      path.lineTo(startX + cycleWidth, midY - maxAmp);

      // Bottom wall mirror
      path.moveTo(startX, midY + maxAmp);
      path.lineTo(startX + cycleWidth * 0.3, midY + maxAmp);
      path.lineTo(startX + cycleWidth * 0.4, midY + minAmp);
      path.lineTo(startX + cycleWidth * 0.7, midY + minAmp);
      path.lineTo(startX + cycleWidth * 0.8, midY + maxAmp);
      path.lineTo(startX + cycleWidth, midY + maxAmp);
    }

    canvas.drawPath(path, paint);

    // Baseline
    final blPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..strokeWidth = 0.8;
    canvas.drawLine(Offset(0, midY), Offset(size.width, midY), blPaint);
  }

  @override
  bool shouldRepaint(_MmodePainter old) => old.collapsibility != collapsibility || old.color != color;
}

// =============================================================================
// SCREEN 3 — CombineFindingsScreen
// =============================================================================

class CombineFindingsScreen extends StatefulWidget {
  const CombineFindingsScreen({super.key});

  @override
  State<CombineFindingsScreen> createState() => _CombineFindingsScreenState();
}

class _CombineFindingsScreenState extends State<CombineFindingsScreen> {
  // Numeric inputs
  final _lvoCtrl = TextEditingController();
  final _svcCtrl = TextEditingController();
  final _laAoCtrl = TextEditingController();
  final _efCtrl = TextEditingController();
  final _papSpCtrl = TextEditingController();
  final _paatCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();

  // Toggle switches
  bool _septalFlattening = false;
  bool _bidirectionalDuctal = false;
  bool _reversedDtaDiastolic = false;
  bool _largeTdd = false;
  bool _plethoric = false;
  bool _underFilled = false;

  // Report state
  String? _report;
  List<String> _nextSteps = [];

  @override
  void dispose() {
    _lvoCtrl.dispose();
    _svcCtrl.dispose();
    _laAoCtrl.dispose();
    _efCtrl.dispose();
    _papSpCtrl.dispose();
    _paatCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  void _generateReport() {
    HapticFeedback.mediumImpact();

    final lvo = double.tryParse(_lvoCtrl.text);
    final svc = double.tryParse(_svcCtrl.text);
    final laAo = double.tryParse(_laAoCtrl.text);
    final ef = double.tryParse(_efCtrl.text);
    final papSp = double.tryParse(_papSpCtrl.text);
    final paat = double.tryParse(_paatCtrl.text);
    final reason = _reasonCtrl.text.trim();

    final buf = StringBuffer();
    final steps = <String>[];

    if (reason.isNotEmpty) {
      buf.write('Reason for study: $reason. ');
    }

    // 1. LV systolic function
    if (ef != null) {
      if (ef >= 55) {
        buf.write('LV systolic function is preserved (EF $ef%). ');
      } else if (ef >= 45) {
        buf.write('LV systolic function is mildly reduced (EF $ef%). ');
        steps.add('Cardiology review for mildly reduced EF');
        steps.add('Optimise volume status and afterload');
      } else if (ef >= 35) {
        buf.write('LV systolic function is moderately reduced (EF $ef%). ');
        steps.add('Urgent cardiology review for moderate LV dysfunction');
        steps.add('Consider dobutamine support if clinically shocked');
      } else {
        buf.write('LV systolic function is severely reduced (EF $ef%) — significant cardiac dysfunction. ');
        steps.add('Urgent cardiology / tertiary centre involvement');
        steps.add('Initiate inotropic support (adrenaline / dobutamine)');
      }
    } else {
      buf.write('LV systolic function not formally quantified. ');
    }

    // 2. Systemic output
    if (lvo != null && svc != null) {
      if (lvo >= 150 && svc >= 41) {
        buf.write('Systemic output is adequate (LVO $lvo mL/kg/min, SVC $svc mL/kg/min). ');
      } else if (lvo < 150 || svc < 41) {
        buf.write('Low systemic flow detected (LVO ${lvo.toStringAsFixed(0)} mL/kg/min, SVC ${svc.toStringAsFixed(0)} mL/kg/min) — consider haemodynamic support. ');
        if (svc < 41) steps.add('Low SVC flow — high IVH risk; consider early intervention');
        if (lvo < 150) steps.add('Low LVO — assess for obstructive physiology or PDA steal');
      }
    } else if (lvo != null) {
      buf.write('LVO $lvo mL/kg/min — ${lvo >= 150 ? "within normal range" : "below target; consider causes"}. ');
      if (lvo < 150) steps.add('Low LVO — optimise preload and cardiac output');
    } else if (svc != null) {
      buf.write('SVC flow $svc mL/kg/min — ${svc >= 41 ? "adequate" : "low; high IVH risk"}. ');
      if (svc < 41) steps.add('Low SVC flow — consider early indomethacin/ibuprofen if hsPDA present');
    }

    // 3. PDA assessment
    final hasPda = (laAo != null && laAo > 1.4) || _bidirectionalDuctal || _reversedDtaDiastolic || _largeTdd;
    if (hasPda) {
      buf.write('Evidence of haemodynamically significant PDA: ');
      final reasons = <String>[];
      if (laAo != null && laAo > 1.4) reasons.add('LA:Ao ${laAo.toStringAsFixed(2)} (dilated left heart)');
      if (_largeTdd) reasons.add('large TDD >1.5 mm');
      if (_reversedDtaDiastolic) reasons.add('reversed diastolic flow in DTA (systemic steal)');
      if (_bidirectionalDuctal) reasons.add('bidirectional ductal flow (PPHN component)');
      buf.write('${reasons.join(", ")}. ');
      steps.add('Consider pharmacological PDA closure (indomethacin / ibuprofen / paracetamol)');
      steps.add('Fluid restriction and optimise oxygenation');
      if (_bidirectionalDuctal) steps.add('Bidirectional flow — manage concurrent PPHN before aggressive PDA treatment');
    } else if (laAo != null && laAo <= 1.4) {
      buf.write('LA:Ao ${laAo.toStringAsFixed(2)} — no significant left heart volume loading. ');
    } else {
      buf.write('PDA assessment incomplete. ');
    }

    // 4. Pulmonary pressures
    final hasPph = _septalFlattening ||
        (paat != null && paat < 55) ||
        (papSp != null && papSp > 40);
    if (hasPph) {
      buf.write('Elevated pulmonary pressures suggested: ');
      final pReasons = <String>[];
      if (papSp != null && papSp > 40) pReasons.add('PAPSp ${papSp.toStringAsFixed(0)} mmHg');
      if (paat != null && paat < 55) pReasons.add('PAAT ${paat.toStringAsFixed(0)} ms (shortened)');
      if (_septalFlattening) pReasons.add('septal flattening / D-sign');
      buf.write('${pReasons.join(", ")}. ');
      if (papSp != null && papSp >= 40) steps.add('Optimise oxygenation and ventilation for PPHN');
      if (papSp != null && papSp >= 55) steps.add('Consider inhaled nitric oxide (iNO) for severe PPHN');
      steps.add('Echocardiogram-guided pulmonary vasodilator therapy');
    } else if (papSp != null || paat != null) {
      buf.write('Pulmonary pressures within acceptable range. ');
    }

    // 5. Volume status
    if (_plethoric) {
      buf.write('IVC appears plethoric — possible volume overload or elevated right atrial pressure. ');
      steps.add('Consider fluid restriction; reassess hydration balance');
    }
    if (_underFilled) {
      buf.write('IVC appears under-filled — consider relative hypovolaemia or distributive physiology. ');
      steps.add('Cautious fluid bolus (10 mL/kg NaCl 0.9%) and reassess');
    }

    // 6. Summary
    buf.write('Overall impression: ');
    if (!hasPda && !hasPph && (ef == null || ef >= 55) && (lvo == null || lvo >= 150)) {
      buf.write('No major haemodynamic compromise identified on current assessment. Continue monitoring.');
      steps.add('Repeat echo in 12–24 h or if clinical status changes');
    } else {
      final issues = <String>[];
      if (ef != null && ef < 55) issues.add('LV dysfunction');
      if (hasPda) issues.add('hsPDA');
      if (hasPph) issues.add('pulmonary hypertension');
      if (_underFilled || (svc != null && svc < 41)) issues.add('low flow state');
      if (_plethoric) issues.add('volume overload');
      buf.write('${issues.isEmpty ? "Incomplete data — targeted" : issues.join(" + ")} — targeted intervention advised.');
      steps.add('Repeat echo in 6 h or after intervention');
    }

    if (steps.isEmpty) steps.add('Routine monitoring; repeat echo in 24 h');

    setState(() {
      _report = buf.toString();
      _nextSteps = steps;
    });
  }

  void _copyToClipboard() {
    if (_report == null) return;
    final fullText = '$_report\n\nSuggested next steps:\n${_nextSteps.map((s) => '• $s').join('\n')}';
    Clipboard.setData(ClipboardData(text: fullText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied', style: GoogleFonts.plusJakartaSans()),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _sectionHeader(String title, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: cs.onSurface.withValues(alpha: 0.45),
          letterSpacing: 0.9,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 64,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Combine Findings',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              'Integrated echo report',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.80),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Key Measurements card
            _CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('Key Measurements', cs),
                  _NumericRow(label: 'LVO', unit: 'mL/kg/min', controller: _lvoCtrl, hint: 'e.g. 185'),
                  const SizedBox(height: 10),
                  _NumericRow(label: 'SVC Flow', unit: 'mL/kg/min', controller: _svcCtrl, hint: 'e.g. 65'),
                  const SizedBox(height: 10),
                  _NumericRow(label: 'LA:Ao ratio', unit: '', controller: _laAoCtrl, hint: 'e.g. 1.6'),
                  const SizedBox(height: 10),
                  _NumericRow(label: 'Ejection Fraction', unit: '%', controller: _efCtrl, hint: 'e.g. 58'),
                  const SizedBox(height: 10),
                  _NumericRow(label: 'PAPSp', unit: 'mmHg', controller: _papSpCtrl, hint: 'e.g. 38'),
                  const SizedBox(height: 10),
                  _NumericRow(label: 'PAAT', unit: 'ms', controller: _paatCtrl, hint: 'e.g. 62'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Qualitative Findings card
            _CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('Qualitative Findings', cs),
                  _ToggleRow(
                    label: 'Septal flattening / D-sign',
                    value: _septalFlattening,
                    onChanged: (v) => setState(() => _septalFlattening = v),
                    cs: cs,
                  ),
                  _ToggleRow(
                    label: 'Bidirectional ductal flow',
                    value: _bidirectionalDuctal,
                    onChanged: (v) => setState(() => _bidirectionalDuctal = v),
                    cs: cs,
                  ),
                  _ToggleRow(
                    label: 'Reversed DTA diastolic flow',
                    value: _reversedDtaDiastolic,
                    onChanged: (v) => setState(() => _reversedDtaDiastolic = v),
                    cs: cs,
                  ),
                  _ToggleRow(
                    label: 'Large TDD (>1.5 mm)',
                    value: _largeTdd,
                    onChanged: (v) => setState(() => _largeTdd = v),
                    cs: cs,
                  ),
                  _ToggleRow(
                    label: 'Plethoric IVC',
                    value: _plethoric,
                    onChanged: (v) => setState(() => _plethoric = v),
                    cs: cs,
                  ),
                  _ToggleRow(
                    label: 'Under-filled IVC',
                    value: _underFilled,
                    onChanged: (v) => setState(() => _underFilled = v),
                    cs: cs,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Clinical Context card
            _CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('Clinical Context', cs),
                  Text(
                    'Reason for study',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _reasonCtrl,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13.5, color: cs.onSurface),
                    decoration: InputDecoration(
                      hintText: 'e.g. Day 3 VLBW, respiratory distress',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: cs.onSurface.withValues(alpha: 0.35),
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: cs.onSurface.withValues(alpha: 0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.15)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.15)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cs.primary, width: 1.5),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Generate button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _generateReport,
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: Text(
                  'Generate Report',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            if (_report != null) ...[
              const SizedBox(height: 20),
              // Result card
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(color: cs.primary.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: cs.primary.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.1),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                      ),
                      padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
                      child: Row(
                        children: [
                          Icon(Icons.description_outlined, size: 18, color: cs.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Integrated Impression',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: cs.primary,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _copyToClipboard,
                            icon: const Icon(Icons.copy, size: 18),
                            tooltip: 'Copy to clipboard',
                            color: cs.primary,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        _report!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          height: 1.6,
                          color: cs.onSurface.withValues(alpha: 0.88),
                        ),
                      ),
                    ),
                    if (_nextSteps.isNotEmpty) ...[
                      Divider(color: cs.onSurface.withValues(alpha: 0.08), height: 1),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Suggested Next Steps',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface.withValues(alpha: 0.55),
                                letterSpacing: 0.6,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ..._nextSteps.map((step) => Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Container(
                                          width: 5,
                                          height: 5,
                                          decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          step,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            color: cs.onSurface.withValues(alpha: 0.82),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _ReferenceFooter(
                text: 'Based on El-Khuffash PDA staging (2018), Jain & McNamara PPHN (2015), and de Waal/Kluckow shock classification.',
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _NumericRow extends StatelessWidget {
  final String label;
  final String unit;
  final TextEditingController controller;
  final String hint;

  const _NumericRow({required this.label, required this.unit, required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: GoogleFonts.plusJakartaSans(fontSize: 13.5, color: cs.onSurface, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.plusJakartaSans(
                color: cs.onSurface.withValues(alpha: 0.3),
                fontSize: 12,
              ),
              suffixText: unit.isNotEmpty ? unit : null,
              suffixStyle: GoogleFonts.plusJakartaSans(
                color: cs.onSurface.withValues(alpha: 0.5),
                fontSize: 11.5,
              ),
              filled: true,
              fillColor: cs.onSurface.withValues(alpha: 0.04),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.15)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.15)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: cs.primary, width: 1.5),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            ),
          ),
        ),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final ColorScheme cs;

  const _ToggleRow({required this.label, required this.value, required this.onChanged, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: cs.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: (v) {
              HapticFeedback.selectionClick();
              onChanged(v);
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SCREEN 4 — ClinicalScenariosScreen
// =============================================================================

class ClinicalScenariosScreen extends StatelessWidget {
  const ClinicalScenariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scenarios = _buildScenarios();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 64,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clinical Scenarios',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              'Pre-defined echo workflows',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.80),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...scenarios.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ScenarioCard(scenario: s),
              )),
          const SizedBox(height: 8),
          _ReferenceFooter(
            text: 'Workflow frameworks adapted from ASE TNE Guidelines 2024 and Neonatal Haemodynamics (El-Khuffash & McNamara).',
          ),
        ],
      ),
    );
  }

  List<_Scenario> _buildScenarios() {
    return [
      _Scenario(
        title: 'PDA Assessment Workflow',
        icon: Icons.swap_horiz,
        color: const Color(0xFFE65100),
        description: 'Complete haemodynamic PDA assessment in ~5 minutes',
        steps: [
          'PLAX — LA:Ao ratio (M-mode)',
          'Suprasternal — TDD + ductal flow pattern + LPA Doppler',
          'Apical 5-chamber — LVO calculation',
          'Subcostal — DTA diastolic flow, celiac diastolic flow',
          'Run through PDA Staging Wizard',
        ],
        actionLabel: 'Open PDA Staging Wizard',
        actionTarget: _ScenarioAction.pdaWizard,
        infoCard: null,
      ),
      _Scenario(
        title: 'PPHN Work-up Workflow',
        icon: Icons.air,
        color: const Color(0xFF1565C0),
        description: 'Full PPHN severity assessment',
        steps: [
          'Apical 4-chamber — RV-focused: TR jet peak velocity',
          'PSAX papillary — Eccentricity index, septal position',
          'PSAX MPA — PAAT, check for mid-systolic notching',
          'Suprasternal — ductal flow direction',
          'Measure pre/post-ductal SpO₂',
          'Run through PPHN Severity Bundle',
        ],
        actionLabel: 'Open PPHN Severity Bundle',
        actionTarget: _ScenarioAction.pphnBundle,
        infoCard: null,
      ),
      _Scenario(
        title: 'Neonatal Shock Assessment',
        icon: Icons.favorite_border,
        color: const Color(0xFFC62828),
        description: 'Differentiate shock phenotype and guide therapy',
        steps: [
          'PLAX — EF (Simpson) or SF',
          'Apical 5-chamber — LVO',
          'Subcostal — SVC flow, IVC collapsibility',
          'PLAX — LA:Ao (to rule out hsPDA masquerade)',
          'Clinical assessment — peripheral perfusion, pulses',
          'Run through Shock Phenotype Classifier',
        ],
        actionLabel: 'Open Shock Phenotype Classifier',
        actionTarget: _ScenarioAction.shockClassifier,
        infoCard: null,
      ),
      _Scenario(
        title: 'Hypoxic-Ischaemic Encephalopathy (HIE) Screen',
        icon: Icons.healing,
        color: const Color(0xFF6A1B9A),
        description: 'Post-asphyxia haemodynamic baseline',
        steps: [
          'Apical 4-chamber — EF (often reduced), TAPSE, MAPSE',
          'PSAX — TR jet, eccentricity index (PPHN common)',
          'PLAX — LA:Ao',
          'Subcostal — SVC flow (can be low due to RV dysfunction)',
          'Document pre-cooling baseline',
        ],
        actionLabel: null,
        actionTarget: null,
        infoCard: 'Post-asphyxia cardiac dysfunction resolves over 48–72 h with hypothermia. TAPSE most sensitive early marker.',
      ),
      _Scenario(
        title: 'RDS / Preterm Haemodynamic Survey',
        icon: Icons.child_care,
        color: const Color(0xFF0D47A1),
        description: 'Day 1–3 assessment for VLBW infants',
        steps: [
          'Suprasternal — PDA assessment (ductal diameter, pattern)',
          'Apical — LVO',
          'Subcostal — SVC flow (target >41 mL/kg/min to reduce IVH risk)',
          'PSAX — IVS position (septal flattening common in transition)',
          'Repeat at 24 and 72 hours to track transitional physiology',
        ],
        actionLabel: null,
        actionTarget: null,
        infoCard: 'Low SVC flow in first 12 h strongly associated with IVH. Consider early indomethacin/ibuprofen if persistent low flow with hsPDA.',
      ),
    ];
  }
}

enum _ScenarioAction { pdaWizard, pphnBundle, shockClassifier }

class _Scenario {
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final List<String> steps;
  final String? actionLabel;
  final _ScenarioAction? actionTarget;
  final String? infoCard;

  const _Scenario({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.steps,
    required this.actionLabel,
    required this.actionTarget,
    required this.infoCard,
  });
}

class _ScenarioCard extends StatelessWidget {
  final _Scenario scenario;

  const _ScenarioCard({required this.scenario});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => _WorkflowDetailPage(scenario: scenario)),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  color: scenario.color.withValues(alpha: 0.10),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                ),
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: scenario.color.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(scenario.icon, color: scenario.color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scenario.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: scenario.color,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            scenario.description,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: cs.onSurface.withValues(alpha: 0.65),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: cs.onSurface.withValues(alpha: 0.35), size: 20),
                  ],
                ),
              ),
              // Steps preview (first 2)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...scenario.steps.take(2).toList().asMap().entries.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: scenario.color.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${e.key + 1}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: scenario.color,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 7),
                              Expanded(
                                child: Text(
                                  e.value,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    color: cs.onSurface.withValues(alpha: 0.75),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    if (scenario.steps.length > 2)
                      Text(
                        '+${scenario.steps.length - 2} more steps...',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: scenario.color.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
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

class _WorkflowDetailPage extends StatelessWidget {
  final _Scenario scenario;

  const _WorkflowDetailPage({required this.scenario});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          scenario.title,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: scenario.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: scenario.color.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(scenario.icon, color: scenario.color, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      scenario.description,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: scenario.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Steps
            Text(
              'WORKFLOW STEPS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: cs.onSurface.withValues(alpha: 0.45),
                letterSpacing: 0.9,
              ),
            ),
            const SizedBox(height: 10),
            ...scenario.steps.asMap().entries.map((e) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: scenario.color,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${e.key + 1}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          e.value,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: cs.onSurface.withValues(alpha: 0.88),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            // Info card (scenarios 4 & 5)
            if (scenario.infoCard != null) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: scenario.color.withValues(alpha: 0.07),
                  border: Border.all(color: scenario.color.withValues(alpha: 0.25)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: scenario.color, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        scenario.infoCard!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: cs.onSurface.withValues(alpha: 0.82),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Action button (scenarios 1-3)
            if (scenario.actionLabel != null && scenario.actionTarget != null) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    _navigateToAction(context, scenario.actionTarget!);
                  },
                  icon: Icon(scenario.icon, size: 18),
                  label: Text(
                    scenario.actionLabel!,
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: scenario.color,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            _ReferenceFooter(
              text: 'Workflow frameworks adapted from ASE TNE Guidelines 2024 and Neonatal Haemodynamics (El-Khuffash & McNamara).',
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAction(BuildContext context, _ScenarioAction action) {
    Widget screen;
    switch (action) {
      case _ScenarioAction.pdaWizard:
        screen = const PdaStagingWizardScreen();
        break;
      case _ScenarioAction.pphnBundle:
        screen = const PphnSeverityBundleScreen();
        break;
      case _ScenarioAction.shockClassifier:
        screen = const ShockPhenotypeClassifierScreen();
        break;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

// =============================================================================
// SHARED HELPERS
// =============================================================================

class _CardContainer extends StatelessWidget {
  final Widget child;

  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      child: child,
    );
  }
}

class _ReferenceFooter extends StatelessWidget {
  final String text;

  const _ReferenceFooter({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.menu_book_outlined, size: 13, color: cs.onSurface.withValues(alpha: 0.35)),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: cs.onSurface.withValues(alpha: 0.4),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
