// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

// =============================================================================
// MAIN SCREEN — EchoCalculatorsScreen
// =============================================================================

class EchoCalculatorsScreen extends StatelessWidget {
  const EchoCalculatorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2D Echo Calculators',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              'Neonatal · Point-of-Care',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.80),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        toolbarHeight: 64,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CategoryCard(
            icon: Icons.water_drop,
            color: const Color(0xFF0D47A1),
            title: 'Cardiac Output',
            subtitle: 'LVO · RVO · SVC Flow · DAo · SV',
            count: 5,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _CardiacOutputScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            icon: Icons.favorite,
            color: const Color(0xFFC62828),
            title: 'LV Systolic Function',
            subtitle: 'EF · FS · MAPSE · S′ TDI LV',
            count: 4,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _LVFunctionScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            icon: Icons.air,
            color: const Color(0xFF1565C0),
            title: 'Pulmonary Pressures',
            subtitle: 'PAPSp · PAAT · EI · MPA:Ao',
            count: 4,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _PulmonaryScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            icon: Icons.waves,
            color: const Color(0xFF6A1B9A),
            title: 'Diastolic Function',
            subtitle: 'MPI · E/e′',
            count: 2,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _DiastolicScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            icon: Icons.waterfall_chart,
            color: const Color(0xFF00695C),
            title: 'Volume Status',
            subtitle: 'IVC Collapsibility · IVC Distensibility · LA/Ao',
            count: 3,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _VolumeStatusScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            icon: Icons.swap_horiz,
            color: const Color(0xFFE65100),
            title: 'PDA Assessment',
            subtitle: 'Qp:Qs Ratio',
            count: 1,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _PDAScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            icon: Icons.favorite_outline,
            color: const Color(0xFFAD1457),
            title: 'RV Systolic Function',
            subtitle: 'FAC · TAPSE · S′ TDI RV',
            count: 3,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _RVFunctionScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            icon: Icons.library_books,
            color: const Color(0xFF424242),
            title: 'Reference Values',
            subtitle: 'LV dimensions · Wall thickness · Valve velocities · Visceral flow',
            count: 6,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _ReferenceValuesScreen()),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// =============================================================================
// CATEGORY CARD WIDGET
// =============================================================================

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final int count;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: cs.onSurface.withValues(alpha: 0.4)),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SHARED HELPER WIDGETS
// =============================================================================

/// Expandable calculator card
class _CalcCard extends StatefulWidget {
  final String title;
  final String formula;
  final Widget Function(BuildContext context) builder;

  const _CalcCard({
    required this.title,
    required this.formula,
    required this.builder,
  });

  @override
  State<_CalcCard> createState() => _CalcCardState();
}

class _CalcCardState extends State<_CalcCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      widget.formula,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.sourceCodePro(
                        fontSize: 11,
                        color: cs.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: cs.onSurface.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: widget.builder(context),
            ),
        ],
      ),
    );
  }
}

/// Numeric input field
class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool optional;

  const _InputField({
    required this.label,
    required this.hint,
    required this.controller,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (optional)
              Text(
                '  (optional)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.plusJakartaSans(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: cs.onSurface.withValues(alpha: 0.35),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: cs.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            isDense: true,
          ),
        ),
      ],
    );
  }
}

/// Result card — tinted blue
class _ResultCard extends StatelessWidget {
  final String title;
  final String formula;

  const _ResultCard({required this.title, required this.formula});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: cs.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formula,
            style: GoogleFonts.sourceCodePro(
              fontSize: 11,
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Interpretation card with coloured left border
enum _Severity { normal, borderline, abnormal }

class _InterpretationCard extends StatelessWidget {
  final _Severity severity;
  final String title;
  final String body;
  final String normalRange;

  const _InterpretationCard({
    required this.severity,
    required this.title,
    required this.body,
    required this.normalRange,
  });

  Color get _borderColor {
    switch (severity) {
      case _Severity.normal:
        return const Color(0xFF2E7D32);
      case _Severity.borderline:
        return const Color(0xFFF57C00);
      case _Severity.abnormal:
        return const Color(0xFFC62828);
    }
  }

  Color get _bgColor {
    switch (severity) {
      case _Severity.normal:
        return const Color(0xFF2E7D32).withValues(alpha: 0.08);
      case _Severity.borderline:
        return const Color(0xFFF57C00).withValues(alpha: 0.08);
      case _Severity.abnormal:
        return const Color(0xFFC62828).withValues(alpha: 0.08);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: _borderColor, width: 4)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: _borderColor,
            ),
          ),
          if (body.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              body,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: cs.onSurface.withValues(alpha: 0.8),
                height: 1.45,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            normalRange,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: cs.onSurface.withValues(alpha: 0.5),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

/// Reference footnote
class _ReferenceFootnote extends StatelessWidget {
  final String text;
  const _ReferenceFootnote({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          color: cs.onSurface.withValues(alpha: 0.45),
          fontStyle: FontStyle.italic,
          height: 1.5,
        ),
      ),
    );
  }
}

/// Expandable reference card — shows a lookup table instead of a calculator
class _ReferenceCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<({String label, String value, String? note})> rows;
  final String? interpretation;
  final String reference;

  const _ReferenceCard({
    required this.title,
    this.subtitle,
    required this.rows,
    required this.interpretation,
    required this.reference,
  });

  @override
  State<_ReferenceCard> createState() => _ReferenceCardState();
}

class _ReferenceCardState extends State<_ReferenceCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: cs.onSurface.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'REF',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: cs.onSurface.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.subtitle != null) ...[
                    Text(
                      widget.subtitle!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: 0.6),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  ...widget.rows.map((row) => Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: cs.onSurface.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              row.label,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              row.value,
                              style: GoogleFonts.sourceCodePro(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: cs.primary,
                              ),
                            ),
                          ],
                        ),
                        if (row.note != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            row.note!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: cs.onSurface.withValues(alpha: 0.55),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )),
                  if (widget.interpretation != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: cs.primary.withValues(alpha: 0.15)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, size: 15, color: cs.primary.withValues(alpha: 0.7)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.interpretation!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: cs.onSurface.withValues(alpha: 0.75),
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  _ReferenceFootnote(text: widget.reference),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// =============================================================================
// CATEGORY SUB-SCREENS
// =============================================================================

// ─────────────────────────────────────────────────────────────────────────────
// 1. CARDIAC OUTPUT SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class _CardiacOutputScreen extends StatelessWidget {
  const _CardiacOutputScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cardiac Output',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CalcCard(
            title: 'Left Ventricular Output (LVO)',
            formula: 'VTI × π×(d/2)² × HR ÷ Wt',
            builder: (_) => const _LVOCalculator(),
          ),
          _CalcCard(
            title: 'Right Ventricular Output (RVO)',
            formula: 'VTI × π×(d/2)² × HR ÷ Wt',
            builder: (_) => const _RVOCalculator(),
          ),
          _CalcCard(
            title: 'SVC Flow',
            formula: 'VTI × π×(d/2)² × HR ÷ Wt',
            builder: (_) => const _SVCCalculator(),
          ),
          _CalcCard(
            title: 'Stroke Volume',
            formula: 'VTI × π×(d/2)²',
            builder: (_) => const _StrokeVolumeCalculator(),
          ),
          _CalcCard(
            title: 'DAo Flow (Descending Aorta)',
            formula: 'VTI × π×(d/2)² × HR ÷ Weight',
            builder: (_) => const _DAoFlowCalculator(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. LV FUNCTION SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class _LVFunctionScreen extends StatelessWidget {
  const _LVFunctionScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LV Systolic Function',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CalcCard(
            title: 'Ejection Fraction (Simpson)',
            formula: '(EDV − ESV) / EDV × 100',
            builder: (_) => const _EFCalculator(),
          ),
          _CalcCard(
            title: 'Fractional Shortening',
            formula: '(LVEDD − LVESD) / LVEDD × 100',
            builder: (_) => const _FSCalculator(),
          ),
          _ReferenceCard(
            title: 'MAPSE by Gestational Age',
            subtitle: 'Mitral Annular Plane Systolic Excursion (mm) — mean ± SD',
            rows: const [
              (label: '26 wks', value: '3.6 ± 0.5 mm', note: null),
              (label: '28 wks', value: '4.0 ± 0.5 mm', note: null),
              (label: '30 wks', value: '4.4 ± 0.6 mm', note: null),
              (label: '32 wks', value: '4.8 ± 0.6 mm', note: null),
              (label: '34 wks', value: '5.0 ± 0.7 mm', note: null),
              (label: '36 wks', value: '5.2 ± 0.7 mm', note: null),
              (label: '38 wks', value: '5.4 ± 0.8 mm', note: null),
              (label: '40 wks', value: '5.6 ± 0.8 mm', note: null),
            ],
            interpretation: 'Reduced MAPSE → LV longitudinal systolic dysfunction. More sensitive than EF for early detection.',
            reference: 'Koestenberger M, et al. Neonatology. 2014.',
          ),
          _ReferenceCard(
            title: "S\u2032 TDI — LV (Mitral Annulus)",
            subtitle: 'Tissue Doppler systolic velocity (cm/s)',
            rows: const [
              (label: 'Preterm 26–30 wks', value: '3.5–5.5 cm/s', note: null),
              (label: 'Term ≥37 wks', value: '4.5–7.0 cm/s', note: null),
            ],
            interpretation: "Low S\u2032 → LV systolic dysfunction. Correlates with MAPSE and EF.",
            reference: 'Tissot C, et al. Front Pediatr. 2018;6:79.',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. PULMONARY PRESSURES SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class _PulmonaryScreen extends StatelessWidget {
  const _PulmonaryScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pulmonary Pressures',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CalcCard(
            title: 'PAPSp from TR Jet',
            formula: '4 × V² + RAP',
            builder: (_) => const _PAPSpCalculator(),
          ),
          _CalcCard(
            title: 'PAAT / PAATi',
            formula: 'PAATi = PAAT / RVET',
            builder: (_) => const _PAATCalculator(),
          ),
          _CalcCard(
            title: 'Eccentricity Index',
            formula: 'EI = D1 / D2',
            builder: (_) => const _EccentricityCalculator(),
          ),
          _CalcCard(
            title: 'MPA:Ao Ratio',
            formula: 'MPA ÷ Ao',
            builder: (_) => const _MPAAoCalculator(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. DIASTOLIC FUNCTION SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class _DiastolicScreen extends StatelessWidget {
  const _DiastolicScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Diastolic Function',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CalcCard(
            title: 'MPI / Tei Index',
            formula: '(IVCT + IVRT) / ET  or  (a − b) / b',
            builder: (_) => const _MPICalculator(),
          ),
          _CalcCard(
            title: "E/e\u2032 Ratio",
            formula: "E \u00f7 e\u2032",
            builder: (_) => const _EToEPrimeCalculator(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. VOLUME STATUS SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class _VolumeStatusScreen extends StatelessWidget {
  const _VolumeStatusScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Volume Status',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CalcCard(
            title: 'IVC Collapsibility Index',
            formula: '(IVC_max − IVC_min) / IVC_max × 100',
            builder: (_) => const _IVCCollapsibilityCalculator(),
          ),
          _CalcCard(
            title: 'IVC Distensibility Index',
            formula: '(IVC_max − IVC_min) / IVC_min × 100',
            builder: (_) => const _IVCDistensibilityCalculator(),
          ),
          _CalcCard(
            title: 'LA/Ao Ratio',
            formula: 'LA / Ao',
            builder: (_) => const _LAAoCalculator(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. PDA ASSESSMENT SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class _PDAScreen extends StatelessWidget {
  const _PDAScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PDA Assessment',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CalcCard(
            title: 'Qp:Qs Ratio',
            formula: '(MPA VTI × MPA d²) / (LVOT VTI × LVOT d²)',
            builder: (_) => const _QpQsCalculator(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 7. RV SYSTOLIC FUNCTION SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class _RVFunctionScreen extends StatelessWidget {
  const _RVFunctionScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RV Systolic Function',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CalcCard(
            title: 'Fractional Area Change (FAC)',
            formula: '(RVEDa − RVESa) / RVEDa × 100',
            builder: (_) => const _FACCalculator(),
          ),
          _ReferenceCard(
            title: 'TAPSE by Gestational Age',
            subtitle: 'Tricuspid Annular Plane Systolic Excursion (mm) — mean ± SD',
            rows: const [
              (label: '26 wks', value: '5.3 ± 1.1 mm', note: null),
              (label: '28 wks', value: '6.0 ± 1.2 mm', note: null),
              (label: '30 wks', value: '7.0 ± 1.2 mm', note: null),
              (label: '32 wks', value: '7.5 ± 1.3 mm', note: null),
              (label: '34 wks', value: '8.0 ± 1.3 mm', note: null),
              (label: '36 wks', value: '8.5 ± 1.4 mm', note: null),
              (label: '38 wks', value: '9.0 ± 1.5 mm', note: null),
              (label: '40 wks', value: '9.1 ± 1.5 mm', note: null),
            ],
            interpretation: 'Reduced TAPSE for GA → RV longitudinal systolic dysfunction. Useful in PPHN assessment and post-asphyxia.',
            reference: 'Koestenberger M, et al. Neonatology. 2011;100:85–92.',
          ),
          _ReferenceCard(
            title: "S\u2032 TDI — RV (Tricuspid Annulus)",
            subtitle: 'Tissue Doppler systolic velocity (cm/s)',
            rows: const [
              (label: 'Preterm 26–30 wks', value: '4.0–6.0 cm/s', note: null),
              (label: 'Term ≥37 wks', value: '5.5–8.5 cm/s', note: null),
            ],
            interpretation: "Low S\u2032 → RV systolic dysfunction. Correlates with TAPSE.",
            reference: 'Breatnach CR, et al. Early Hum Dev. 2017;108:33–39.',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 8. REFERENCE VALUES SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class _ReferenceValuesScreen extends StatelessWidget {
  const _ReferenceValuesScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reference Values',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ReferenceCard(
            title: 'LV Dimensions (M-mode)',
            subtitle: 'LVEDD / LVESD normal ranges by gestational age',
            rows: const [
              (label: '24–27 wks', value: 'LVEDD 10–13 mm', note: 'LVESD 6–9 mm'),
              (label: '28–31 wks', value: 'LVEDD 12–16 mm', note: 'LVESD 7–11 mm'),
              (label: '32–35 wks', value: 'LVEDD 14–18 mm', note: 'LVESD 9–12 mm'),
              (label: '≥37 wks',   value: 'LVEDD 16–22 mm', note: 'LVESD 10–14 mm'),
            ],
            interpretation: null,
            reference: 'Al-Biltagi M, et al. J Saudi Heart Assoc. 2013.',
          ),
          _ReferenceCard(
            title: 'Wall Thickness (IVSd, LVPWd)',
            subtitle: 'Term neonates — normal values',
            rows: const [
              (label: 'IVSd',  value: '3–5 mm', note: null),
              (label: 'LVPWd', value: '3–5 mm', note: null),
            ],
            interpretation: '>5 mm → Consider hypertrophic cardiomyopathy, IDM (infant of diabetic mother), twin-twin transfusion syndrome.',
            reference: 'Frontiers in Pediatrics. 2022;10:894152.',
          ),
          _ReferenceCard(
            title: 'Aortic Valve Peak Velocity',
            subtitle: 'Normal ranges by maturity',
            rows: const [
              (label: 'Preterm', value: '0.5–1.0 m/s', note: null),
              (label: 'Term',    value: '0.6–1.2 m/s', note: null),
            ],
            interpretation: '>1.5 m/s → Possible aortic stenosis, sub-aortic obstruction, or LVOTO.',
            reference: 'Frontiers in Pediatrics. 2022;10:894152.',
          ),
          _ReferenceCard(
            title: 'Mitral Valve E and A Velocities',
            subtitle: 'Term neonates — normal values',
            rows: const [
              (label: 'MV-E',   value: '0.4–0.7 m/s', note: null),
              (label: 'MV-A',   value: '0.5–0.8 m/s', note: null),
              (label: 'MV-E/A', value: 'Typically <1', note: 'A-dominant pattern is normal in neonates'),
            ],
            interpretation: 'Neonates rely on atrial kick — A-dominant is expected.',
            reference: 'Frontiers in Pediatrics. 2022;10:894152.',
          ),
          _ReferenceCard(
            title: 'Celiac Trunk Peak Systolic Velocity',
            subtitle: 'Abdominal Doppler — normal values',
            rows: const [
              (label: 'Normal PSV', value: '60–120 cm/s', note: 'Diastolic forward flow normally present'),
            ],
            interpretation: null,
            reference: 'Murdoch EM, et al. Pediatr Res. 2006.',
          ),
          _ReferenceCard(
            title: 'SMA Peak Systolic Velocity',
            subtitle: 'Superior Mesenteric Artery — normal values',
            rows: const [
              (label: 'Normal PSV', value: '50–100 cm/s', note: 'Diastolic forward flow normally present'),
            ],
            interpretation: 'Absent diastolic flow → Risk of gut ischaemia. High index of suspicion for NEC.\nReversed diastolic flow → Active gut ischaemia. Withhold feeds, investigate urgently.',
            reference: 'Murdoch EM, et al. Pediatr Res. 2006.',
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// INDIVIDUAL CALCULATOR IMPLEMENTATIONS
// =============================================================================

// ─────────────────────────────────────────────────────────────────────────────
// CALC 1: Left Ventricular Output (LVO)
// ─────────────────────────────────────────────────────────────────────────────

class _LVOCalculator extends StatefulWidget {
  const _LVOCalculator();
  @override
  State<_LVOCalculator> createState() => _LVOCalculatorState();
}

class _LVOCalculatorState extends State<_LVOCalculator> {
  final _dCtrl = TextEditingController();
  final _vtiCtrl = TextEditingController();
  final _hrCtrl = TextEditingController();
  final _wtCtrl = TextEditingController();

  double? _lvo;
  double? _svPerKg;


  void _calculate() {
    final d = double.tryParse(_dCtrl.text);
    final vti = double.tryParse(_vtiCtrl.text);
    final hr = double.tryParse(_hrCtrl.text);
    final wt = double.tryParse(_wtCtrl.text);
    if (d == null || vti == null || hr == null || wt == null || wt == 0) return;
    final sv = vti * pi * (d / 2) * (d / 2);
    setState(() {
      _lvo = sv * hr / wt;
      _svPerKg = sv / wt;
    });
  }

  ({_Severity severity, String title, String body}) _interpret(double lvo) {
    if (lvo < 150) {
      return (
        severity: _Severity.abnormal,
        title: 'Low Cardiac Output',
        body:
            'Systemic blood flow is reduced. Assess for myocardial dysfunction, hypovolaemia, or high afterload. Consider fluid bolus if hypovolaemic, or inotrope (dobutamine/dopamine) if myocardial dysfunction. In presence of PDA or ASD, LVO does not represent true systemic flow — use SVC flow instead.',
      );
    } else if (lvo <= 300) {
      return (
        severity: _Severity.normal,
        title: 'Normal Cardiac Output',
        body: 'Systemic blood flow is within normal range. Continue monitoring as clinically indicated.',
      );
    } else {
      return (
        severity: _Severity.borderline,
        title: 'High Cardiac Output',
        body:
            'Consider significant L→R shunt (PDA), anaemia, sepsis, or AV fistula as causes of high output state.',
      );
    }
  }

  @override
  void dispose() {
    _dCtrl.dispose();
    _vtiCtrl.dispose();
    _hrCtrl.dispose();
    _wtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interp = _lvo != null ? _interpret(_lvo!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputField(label: 'LVOT Diameter (cm)', hint: 'e.g. 0.8', controller: _dCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'Aortic VTI (cm)', hint: 'e.g. 12.5', controller: _vtiCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'Heart Rate (bpm)', hint: 'e.g. 150', controller: _hrCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'Weight (kg)', hint: 'e.g. 1.2', controller: _wtCtrl),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setSt) => FilledButton(
            onPressed: () { setSt(() {}); _calculate(); },
            child: Text('Calculate', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ),
        if (_lvo != null) ...[
          const SizedBox(height: 12),
          _ResultCard(
            title: 'LVO: ${_lvo!.toStringAsFixed(1)} mL/kg/min',
            formula:
                'VTI(${_vtiCtrl.text}) × π×(${_dCtrl.text}/2)² × HR(${_hrCtrl.text}) ÷ Wt(${_wtCtrl.text})\nStroke Volume: ${_svPerKg!.toStringAsFixed(2)} mL/kg',
          ),
          const SizedBox(height: 8),
          _InterpretationCard(
            severity: interp!.severity,
            title: interp.title,
            body: interp.body,
            normalRange: 'Normal: 150–300 mL/kg/min (Kluckow & Evans 2000, Groves et al. 2011)',
          ),
          const SizedBox(height: 4),
          const _ReferenceFootnote(
            text:
                'Kluckow M, Evans N. Arch Dis Child Fetal Neonatal Ed. 2000. Groves AM, et al. Arch Dis Child Fetal Neonatal Ed. 2011.',
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALC 2: Right Ventricular Output (RVO)
// ─────────────────────────────────────────────────────────────────────────────

class _RVOCalculator extends StatefulWidget {
  const _RVOCalculator();
  @override
  State<_RVOCalculator> createState() => _RVOCalculatorState();
}

class _RVOCalculatorState extends State<_RVOCalculator> {
  final _dCtrl = TextEditingController();
  final _vtiCtrl = TextEditingController();
  final _hrCtrl = TextEditingController();
  final _wtCtrl = TextEditingController();

  double? _rvo;


  void _calculate() {
    final d = double.tryParse(_dCtrl.text);
    final vti = double.tryParse(_vtiCtrl.text);
    final hr = double.tryParse(_hrCtrl.text);
    final wt = double.tryParse(_wtCtrl.text);
    if (d == null || vti == null || hr == null || wt == null || wt == 0) return;
    setState(() {
      _rvo = vti * pi * (d / 2) * (d / 2) * hr / wt;
    });
  }

  ({_Severity severity, String title, String body}) _interpret(double rvo) {
    if (rvo < 150) {
      return (
        severity: _Severity.abnormal,
        title: 'Low RV Output',
        body: 'Assess for RV dysfunction, elevated PVR, hypovolaemia.',
      );
    } else if (rvo <= 300) {
      return (
        severity: _Severity.normal,
        title: 'Normal RV Output',
        body: 'RV output is within the expected normal range.',
      );
    } else {
      return (
        severity: _Severity.borderline,
        title: 'High RV Output',
        body: 'Consider L→R atrial shunt inflating RVO.',
      );
    }
  }

  @override
  void dispose() {
    _dCtrl.dispose();
    _vtiCtrl.dispose();
    _hrCtrl.dispose();
    _wtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interp = _rvo != null ? _interpret(_rvo!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputField(label: 'MPA Diameter (cm)', hint: 'e.g. 0.9', controller: _dCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'Pulmonary VTI (cm)', hint: 'e.g. 11.0', controller: _vtiCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'Heart Rate (bpm)', hint: 'e.g. 150', controller: _hrCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'Weight (kg)', hint: 'e.g. 1.2', controller: _wtCtrl),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setSt) => FilledButton(
            onPressed: () { setSt(() {}); _calculate(); },
            child: Text('Calculate', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ),
        if (_rvo != null) ...[
          const SizedBox(height: 12),
          _ResultCard(
            title: 'RVO: ${_rvo!.toStringAsFixed(1)} mL/kg/min',
            formula:
                'VTI(${_vtiCtrl.text}) × π×(${_dCtrl.text}/2)² × HR(${_hrCtrl.text}) ÷ Wt(${_wtCtrl.text})',
          ),
          const SizedBox(height: 8),
          _InterpretationCard(
            severity: interp!.severity,
            title: interp.title,
            body: interp.body,
            normalRange: '150–300 mL/kg/min (Groves et al. 2011)',
          ),
          const SizedBox(height: 4),
          const _ReferenceFootnote(
            text: 'Groves AM, et al. Arch Dis Child Fetal Neonatal Ed. 2011.',
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALC 3: SVC Flow
// ─────────────────────────────────────────────────────────────────────────────

class _SVCCalculator extends StatefulWidget {
  const _SVCCalculator();
  @override
  State<_SVCCalculator> createState() => _SVCCalculatorState();
}

class _SVCCalculatorState extends State<_SVCCalculator> {
  final _dCtrl = TextEditingController();
  final _vtiCtrl = TextEditingController();
  final _hrCtrl = TextEditingController();
  final _wtCtrl = TextEditingController();

  double? _svc;


  void _calculate() {
    final d = double.tryParse(_dCtrl.text);
    final vti = double.tryParse(_vtiCtrl.text);
    final hr = double.tryParse(_hrCtrl.text);
    final wt = double.tryParse(_wtCtrl.text);
    if (d == null || vti == null || hr == null || wt == null || wt == 0) return;
    setState(() {
      _svc = vti * pi * (d / 2) * (d / 2) * hr / wt;
    });
  }

  ({_Severity severity, String title, String body}) _interpret(double svc) {
    if (svc < 41) {
      return (
        severity: _Severity.abnormal,
        title: 'Low SVC Flow',
        body:
            'Associated with intraventricular haemorrhage risk in preterm infants. Assess for high PVR, myocardial dysfunction, hypovolaemia. Consider volume expansion, inotropes, or pulmonary vasodilators.',
      );
    } else if (svc <= 80) {
      return (
        severity: _Severity.borderline,
        title: 'Borderline SVC Flow',
        body: 'Monitor closely. Trend more important than single value.',
      );
    } else if (svc <= 155) {
      return (
        severity: _Severity.normal,
        title: 'Normal SVC Flow',
        body: 'SVC flow is within the expected normal range.',
      );
    } else {
      return (
        severity: _Severity.borderline,
        title: 'High SVC Flow',
        body: 'Consider high cardiac output state.',
      );
    }
  }

  @override
  void dispose() {
    _dCtrl.dispose();
    _vtiCtrl.dispose();
    _hrCtrl.dispose();
    _wtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interp = _svc != null ? _interpret(_svc!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputField(label: 'SVC Diameter (cm)', hint: 'e.g. 0.6', controller: _dCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'SVC VTI (cm)', hint: 'e.g. 8.5', controller: _vtiCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'Heart Rate (bpm)', hint: 'e.g. 150', controller: _hrCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'Weight (kg)', hint: 'e.g. 1.2', controller: _wtCtrl),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setSt) => FilledButton(
            onPressed: () { setSt(() {}); _calculate(); },
            child: Text('Calculate', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ),
        if (_svc != null) ...[
          const SizedBox(height: 12),
          _ResultCard(
            title: 'SVC Flow: ${_svc!.toStringAsFixed(1)} mL/kg/min',
            formula:
                'VTI(${_vtiCtrl.text}) × π×(${_dCtrl.text}/2)² × HR(${_hrCtrl.text}) ÷ Wt(${_wtCtrl.text})',
          ),
          const SizedBox(height: 8),
          _InterpretationCard(
            severity: interp!.severity,
            title: interp.title,
            body: interp.body,
            normalRange:
                'Normal: 55–155 mL/kg/min. Low flow threshold: <41 mL/kg/min (Kluckow & Evans 2000)',
          ),
          const SizedBox(height: 4),
          const _ReferenceFootnote(
            text: 'Kluckow M, Evans N. Arch Dis Child Fetal Neonatal Ed. 2000.',
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALC 4: Stroke Volume
// ─────────────────────────────────────────────────────────────────────────────

class _StrokeVolumeCalculator extends StatefulWidget {
  const _StrokeVolumeCalculator();
  @override
  State<_StrokeVolumeCalculator> createState() => _StrokeVolumeCalculatorState();
}

class _StrokeVolumeCalculatorState extends State<_StrokeVolumeCalculator> {
  final _dCtrl = TextEditingController();
  final _vtiCtrl = TextEditingController();
  final _wtCtrl = TextEditingController();

  double? _sv;
  double? _svPerKg;


  void _calculate() {
    final d = double.tryParse(_dCtrl.text);
    final vti = double.tryParse(_vtiCtrl.text);
    final wt = double.tryParse(_wtCtrl.text);
    if (d == null || vti == null || wt == null || wt == 0) return;
    final sv = vti * pi * (d / 2) * (d / 2);
    setState(() {
      _sv = sv;
      _svPerKg = sv / wt;
    });
  }

  ({_Severity severity, String title, String body}) _interpret(double svPerKg) {
    if (svPerKg < 1.0) {
      return (
        severity: _Severity.abnormal,
        title: 'Low Stroke Volume',
        body: 'Reduced stroke volume. Assess for hypovolaemia, myocardial dysfunction, or high afterload.',
      );
    } else if (svPerKg <= 2.5) {
      return (
        severity: _Severity.normal,
        title: 'Normal Stroke Volume',
        body: 'Stroke volume is within the expected range for weight.',
      );
    } else {
      return (
        severity: _Severity.borderline,
        title: 'High Stroke Volume',
        body: 'Consider high output state: significant shunt, anaemia, or sepsis.',
      );
    }
  }

  @override
  void dispose() {
    _dCtrl.dispose();
    _vtiCtrl.dispose();
    _wtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interp = _svPerKg != null ? _interpret(_svPerKg!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputField(label: 'Outflow Diameter (cm)', hint: 'e.g. 0.8', controller: _dCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'VTI (cm)', hint: 'e.g. 12.5', controller: _vtiCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'Weight (kg)', hint: 'e.g. 1.2', controller: _wtCtrl),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setSt) => FilledButton(
            onPressed: () { setSt(() {}); _calculate(); },
            child: Text('Calculate', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ),
        if (_sv != null) ...[
          const SizedBox(height: 12),
          _ResultCard(
            title: 'SV: ${_sv!.toStringAsFixed(2)} mL (${_svPerKg!.toStringAsFixed(2)} mL/kg)',
            formula: 'VTI(${_vtiCtrl.text}) × π×(${_dCtrl.text}/2)²',
          ),
          const SizedBox(height: 8),
          _InterpretationCard(
            severity: interp!.severity,
            title: interp.title,
            body: interp.body,
            normalRange: '1.0–2.5 mL/kg (de Waal K, Kluckow M. J Pediatr. 2010)',
          ),
          const SizedBox(height: 4),
          const _ReferenceFootnote(
            text: 'de Waal K, Kluckow M. Functional echocardiography. J Pediatr. 2010.',
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALC 5: Ejection Fraction (Simpson)
// ─────────────────────────────────────────────────────────────────────────────

class _EFCalculator extends StatefulWidget {
  const _EFCalculator();
  @override
  State<_EFCalculator> createState() => _EFCalculatorState();
}

class _EFCalculatorState extends State<_EFCalculator> {
  final _edvCtrl = TextEditingController();
  final _esvCtrl = TextEditingController();

  double? _ef;
  String? _error;


  void _calculate() {
    final edv = double.tryParse(_edvCtrl.text);
    final esv = double.tryParse(_esvCtrl.text);
    if (edv == null || esv == null) return;
    if (esv >= edv) {
      setState(() {
        _ef = null;
        _error = 'ESV must be less than EDV.';
      });
      return;
    }
    setState(() {
      _error = null;
      _ef = (edv - esv) / edv * 100;
    });
  }

  ({_Severity severity, String title, String body}) _interpret(double ef) {
    if (ef > 80) {
      return (
        severity: _Severity.borderline,
        title: 'Hyperdynamic',
        body: 'Consider sepsis, significant PDA, anaemia.',
      );
    } else if (ef >= 55) {
      return (
        severity: _Severity.normal,
        title: 'Normal LV Systolic Function',
        body: 'EF is within normal range.',
      );
    } else if (ef >= 45) {
      return (
        severity: _Severity.borderline,
        title: 'Mild LV Dysfunction',
        body: 'Monitor. Consider supportive measures.',
      );
    } else if (ef >= 30) {
      return (
        severity: _Severity.abnormal,
        title: 'Moderate LV Dysfunction',
        body: 'Inotropic support likely needed. Assess aetiology.',
      );
    } else {
      return (
        severity: _Severity.abnormal,
        title: 'Severe LV Dysfunction',
        body:
            'Urgent escalation. Inotrope required. Investigate: asphyxia, cardiomyopathy, sepsis.',
      );
    }
  }

  @override
  void dispose() {
    _edvCtrl.dispose();
    _esvCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interp = _ef != null ? _interpret(_ef!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputField(label: 'EDV (mL)', hint: 'End-Diastolic Volume', controller: _edvCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'ESV (mL)', hint: 'End-Systolic Volume', controller: _esvCtrl),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setSt) => FilledButton(
            onPressed: () { setSt(() {}); _calculate(); },
            child: Text('Calculate', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFC62828).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _error!,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: const Color(0xFFC62828),
              ),
            ),
          ),
        ],
        if (_ef != null) ...[
          const SizedBox(height: 12),
          _ResultCard(
            title: 'EF: ${_ef!.toStringAsFixed(1)}%',
            formula:
                '(EDV(${_edvCtrl.text}) − ESV(${_esvCtrl.text})) / EDV(${_edvCtrl.text}) × 100',
          ),
          const SizedBox(height: 8),
          _InterpretationCard(
            severity: interp!.severity,
            title: interp.title,
            body: interp.body,
            normalRange: '55–80% (Tissot et al. 2018)',
          ),
          const SizedBox(height: 4),
          const _ReferenceFootnote(
            text: 'Tissot C, et al. Targeted neonatal echocardiography. Pediatr Cardiol. 2018.',
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALC 6: Fractional Shortening
// ─────────────────────────────────────────────────────────────────────────────

class _FSCalculator extends StatefulWidget {
  const _FSCalculator();
  @override
  State<_FSCalculator> createState() => _FSCalculatorState();
}

class _FSCalculatorState extends State<_FSCalculator> {
  final _lveddCtrl = TextEditingController();
  final _lvesdCtrl = TextEditingController();

  double? _fs;
  String? _error;


  void _calculate() {
    final lvedd = double.tryParse(_lveddCtrl.text);
    final lvesd = double.tryParse(_lvesdCtrl.text);
    if (lvedd == null || lvesd == null) return;
    if (lvesd >= lvedd) {
      setState(() {
        _fs = null;
        _error = 'LVESD must be less than LVEDD.';
      });
      return;
    }
    setState(() {
      _error = null;
      _fs = (lvedd - lvesd) / lvedd * 100;
    });
  }

  ({_Severity severity, String title, String body}) _interpret(double fs) {
    if (fs > 40) {
      return (
        severity: _Severity.borderline,
        title: 'Hyperdynamic',
        body: 'Consider sepsis, PDA, anaemia.',
      );
    } else if (fs >= 28) {
      return (
        severity: _Severity.normal,
        title: 'Normal',
        body: 'Fractional shortening is within normal range.',
      );
    } else {
      return (
        severity: _Severity.abnormal,
        title: 'Impaired LV Systolic Function',
        body: 'Investigate aetiology. Consider inotropic support.',
      );
    }
  }

  @override
  void dispose() {
    _lveddCtrl.dispose();
    _lvesdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interp = _fs != null ? _interpret(_fs!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputField(label: 'LVEDD (mm)', hint: 'End-Diastolic diameter', controller: _lveddCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'LVESD (mm)', hint: 'End-Systolic diameter', controller: _lvesdCtrl),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setSt) => FilledButton(
            onPressed: () { setSt(() {}); _calculate(); },
            child: Text('Calculate', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFC62828).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _error!,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: const Color(0xFFC62828),
              ),
            ),
          ),
        ],
        if (_fs != null) ...[
          const SizedBox(height: 12),
          _ResultCard(
            title: 'FS: ${_fs!.toStringAsFixed(1)}%',
            formula:
                '(LVEDD(${_lveddCtrl.text}) − LVESD(${_lvesdCtrl.text})) / LVEDD(${_lveddCtrl.text}) × 100',
          ),
          const SizedBox(height: 8),
          _InterpretationCard(
            severity: interp!.severity,
            title: interp.title,
            body: interp.body,
            normalRange:
                '28–40%. ASE discourages exclusive use. Unreliable when IVS flattened.',
          ),
          const SizedBox(height: 4),
          const _ReferenceFootnote(
            text: 'American Society of Echocardiography guidelines. Lang RM et al. JASE. 2015.',
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALC 7: PAPSp from TR Jet
// ─────────────────────────────────────────────────────────────────────────────

class _PAPSpCalculator extends StatefulWidget {
  const _PAPSpCalculator();
  @override
  State<_PAPSpCalculator> createState() => _PAPSpCalculatorState();
}

class _PAPSpCalculatorState extends State<_PAPSpCalculator> {
  final _vCtrl = TextEditingController();
  final _rapCtrl = TextEditingController(text: '5');
  final _bpCtrl = TextEditingController();
  String _age = '<72 hours';

  double? _papsp;
  double? _ratio;


  void _calculate() {
    final v = double.tryParse(_vCtrl.text);
    final rap = double.tryParse(_rapCtrl.text);
    final bp = double.tryParse(_bpCtrl.text);
    if (v == null || rap == null) return;
    final papsp = 4 * v * v + rap;
    setState(() {
      _papsp = papsp;
      _ratio = (bp != null && bp > 0) ? papsp / bp : null;
    });
  }

  ({_Severity severity, String title, String body}) _interpret(double papsp, double? ratio) {
    if (_age == '<72 hours') {
      if (papsp <= 36) {
        return (
          severity: _Severity.normal,
          title: 'Normal — Transitional Period',
          body: 'Transitional pulmonary hypertension is expected in the first 72 hours.',
        );
      } else {
        return (
          severity: _Severity.borderline,
          title: 'Elevated for Transitional Period',
          body: 'Monitor. Reassess after 72 hours.',
        );
      }
    } else {
      if (papsp < 35) {
        return (
          severity: _Severity.normal,
          title: 'Normal Pulmonary Pressure',
          body: 'Pulmonary arterial pressure is within normal range.',
        );
      }
      if (ratio != null) {
        if (ratio < 0.5) {
          return (
            severity: _Severity.borderline,
            title: 'Mild PH',
            body: 'PAP <1/2 systemic. Monitor.',
          );
        } else if (ratio <= 0.67) {
          return (
            severity: _Severity.abnormal,
            title: 'Moderate PH',
            body: 'PAP 1/2 to 2/3 systemic. Consider iNO, optimise ventilation.',
          );
        } else {
          return (
            severity: _Severity.abnormal,
            title: 'Severe PH',
            body:
                'PAP >2/3 systemic. Supra-systemic PH likely. Urgent: iNO, sildenafil, prostacyclin. Expect R→L ductal shunting.',
          );
        }
      } else {
        if (papsp <= 50) {
          return (
            severity: _Severity.borderline,
            title: 'Moderate PH',
            body: 'Consider iNO. Enter systemic BP for severity grading.',
          );
        } else {
          return (
            severity: _Severity.abnormal,
            title: 'Severe PH',
            body: 'Urgent intervention likely needed. Enter systemic BP for ratio.',
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _vCtrl.dispose();
    _rapCtrl.dispose();
    _bpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final interp = _papsp != null ? _interpret(_papsp!, _ratio) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputField(label: 'TR Jet Velocity V (m/s)', hint: 'e.g. 3.2', controller: _vCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'Estimated RAP (mmHg)', hint: 'default 5', controller: _rapCtrl),
        const SizedBox(height: 10),
        _InputField(
          label: 'Systemic Systolic BP (mmHg)',
          hint: 'optional',
          controller: _bpCtrl,
          optional: true,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              'Postnatal Age:',
              style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _age,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.2)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  isDense: true,
                ),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: cs.onSurface,
                ),
                items: const [
                  DropdownMenuItem(value: '<72 hours', child: Text('<72 hours')),
                  DropdownMenuItem(value: '>72 hours', child: Text('>72 hours')),
                ],
                onChanged: (v) => setState(() => _age = v ?? _age),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setSt) => FilledButton(
            onPressed: () { setSt(() {}); _calculate(); },
            child: Text('Calculate', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ),
        if (_papsp != null) ...[
          const SizedBox(height: 12),
          _ResultCard(
            title: _ratio != null
                ? 'PAPSp: ${_papsp!.toStringAsFixed(0)} mmHg    PAPSp/SBP: ${_ratio!.toStringAsFixed(2)}'
                : 'PAPSp: ${_papsp!.toStringAsFixed(0)} mmHg',
            formula: '4 × V²(${_vCtrl.text}²) + RAP(${_rapCtrl.text}) = ${_papsp!.toStringAsFixed(1)} mmHg',
          ),
          const SizedBox(height: 8),
          _InterpretationCard(
            severity: interp!.severity,
            title: interp.title,
            body: interp.body,
            normalRange: '<35 mmHg after 72 hrs. PAPSp >2/3 systemic = severe (Jain & McNamara 2015)',
          ),
          const SizedBox(height: 4),
          const _ReferenceFootnote(
            text:
                'Jain A, McNamara PJ. Persistent pulmonary hypertension of the newborn. Semin Fetal Neonatal Med. 2015.',
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALC 8: PAAT / PAATi
// ─────────────────────────────────────────────────────────────────────────────

class _PAATCalculator extends StatefulWidget {
  const _PAATCalculator();
  @override
  State<_PAATCalculator> createState() => _PAATCalculatorState();
}

class _PAATCalculatorState extends State<_PAATCalculator> {
  final _paatCtrl = TextEditingController();
  final _rvetCtrl = TextEditingController();

  double? _paat;
  double? _paati;


  void _calculate() {
    final paat = double.tryParse(_paatCtrl.text);
    final rvet = double.tryParse(_rvetCtrl.text);
    if (paat == null || rvet == null || rvet == 0) return;
    setState(() {
      _paat = paat;
      _paati = paat / rvet;
    });
  }

  ({_Severity severity, String title, String body}) _interpret(double paat, double paati) {
    if (paat > 65 && paati > 0.31) {
      return (
        severity: _Severity.normal,
        title: 'Normal Pulmonary Vascular Resistance',
        body: 'PAAT and PAATi within normal range.',
      );
    } else if ((paat >= 55 && paat <= 65) || (paati >= 0.29 && paati <= 0.31)) {
      return (
        severity: _Severity.borderline,
        title: 'Borderline',
        body: 'Trend and correlate with clinical picture.',
      );
    } else {
      return (
        severity: _Severity.abnormal,
        title: 'Elevated PVR — Pulmonary Hypertension',
        body:
            'PAAT <55 ms consistent with PH. If <45 ms with mid-systolic notching, severe PH likely.',
      );
    }
  }

  @override
  void dispose() {
    _paatCtrl.dispose();
    _rvetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interp = (_paat != null && _paati != null) ? _interpret(_paat!, _paati!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputField(
          label: 'PAAT — Pulmonary Artery Acceleration Time (ms)',
          hint: 'e.g. 68',
          controller: _paatCtrl,
        ),
        const SizedBox(height: 10),
        _InputField(
          label: 'RVET — RV Ejection Time (ms)',
          hint: 'e.g. 210',
          controller: _rvetCtrl,
        ),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setSt) => FilledButton(
            onPressed: () { setSt(() {}); _calculate(); },
            child: Text('Calculate', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ),
        if (_paat != null && _paati != null) ...[
          const SizedBox(height: 12),
          _ResultCard(
            title: 'PAAT: ${_paat!.toStringAsFixed(0)} ms    PAATi: ${_paati!.toStringAsFixed(3)}',
            formula: 'PAATi = PAAT(${_paatCtrl.text}) / RVET(${_rvetCtrl.text})',
          ),
          const SizedBox(height: 8),
          _InterpretationCard(
            severity: interp!.severity,
            title: interp.title,
            body: interp.body,
            normalRange: 'PAAT >65 ms, PAATi >0.31 (Nair & Lakshminrusimha 2014)',
          ),
          const SizedBox(height: 4),
          const _ReferenceFootnote(
            text:
                'Nair J, Lakshminrusimha S. Update on PPHN: mechanisms and treatment. Semin Perinatol. 2014.',
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALC 9: Eccentricity Index
// ─────────────────────────────────────────────────────────────────────────────

class _EccentricityCalculator extends StatefulWidget {
  const _EccentricityCalculator();
  @override
  State<_EccentricityCalculator> createState() => _EccentricityCalculatorState();
}

class _EccentricityCalculatorState extends State<_EccentricityCalculator> {
  final _d1Ctrl = TextEditingController();
  final _d2Ctrl = TextEditingController();

  double? _ei;


  void _calculate() {
    final d1 = double.tryParse(_d1Ctrl.text);
    final d2 = double.tryParse(_d2Ctrl.text);
    if (d1 == null || d2 == null || d2 == 0) return;
    setState(() {
      _ei = d1 / d2;
    });
  }

  ({_Severity severity, String title, String body}) _interpret(double ei) {
    if (ei <= 1.1) {
      return (
        severity: _Severity.normal,
        title: 'Normal — Circular LV',
        body: 'No evidence of RV pressure or volume overload.',
      );
    } else if (ei <= 1.3) {
      return (
        severity: _Severity.borderline,
        title: 'Borderline',
        body: 'Mild septal flattening. Trend and reassess.',
      );
    } else if (ei <= 1.5) {
      return (
        severity: _Severity.abnormal,
        title: 'RV Overload',
        body:
            'If measured at end-systole: RV pressure overload (pulmonary hypertension). If measured at end-diastole: RV volume overload (large L→R shunt).',
      );
    } else {
      return (
        severity: _Severity.abnormal,
        title: 'Severe — IVS bowing into LV',
        body: 'Significant RV overload causing D-shaped LV. Urgent assessment required.',
      );
    }
  }

  @override
  void dispose() {
    _d1Ctrl.dispose();
    _d2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final interp = _ei != null ? _interpret(_ei!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputField(label: 'D1 (mm) — perpendicular diameter', hint: 'e.g. 12.5', controller: _d1Ctrl),
        const SizedBox(height: 10),
        _InputField(label: 'D2 (mm) — through IVS midpoint', hint: 'e.g. 11.0', controller: _d2Ctrl),
        const SizedBox(height: 6),
        Text(
          'PSAX at papillary muscle level. D2 = through IVS midpoint to posterior wall. D1 = perpendicular to D2.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: cs.onSurface.withValues(alpha: 0.5),
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setSt) => FilledButton(
            onPressed: () { setSt(() {}); _calculate(); },
            child: Text('Calculate', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ),
        if (_ei != null) ...[
          const SizedBox(height: 12),
          _ResultCard(
            title: 'EI: ${_ei!.toStringAsFixed(2)}',
            formula: 'D1(${_d1Ctrl.text}) / D2(${_d2Ctrl.text})',
          ),
          const SizedBox(height: 8),
          _InterpretationCard(
            severity: interp!.severity,
            title: interp.title,
            body: interp.body,
            normalRange: '1.0 circular LV. >1.3 = RV overload (Ryan et al. 1996)',
          ),
          const SizedBox(height: 4),
          const _ReferenceFootnote(
            text:
                'Ryan T, et al. An echocardiographic index for separation of right ventricular volume and pressure overload. JACC. 1996.',
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALC 10: MPI / Tei Index
// ─────────────────────────────────────────────────────────────────────────────

class _MPICalculator extends StatefulWidget {
  const _MPICalculator();
  @override
  State<_MPICalculator> createState() => _MPICalculatorState();
}

class _MPICalculatorState extends State<_MPICalculator> {
  // Method 1 controllers
  final _ivctCtrl = TextEditingController();
  final _ivrtCtrl = TextEditingController();
  final _etCtrl = TextEditingController();
  // Method 2 controllers
  final _aCtrl = TextEditingController();
  final _bCtrl = TextEditingController();

  int _method = 0; // 0 = Method 1, 1 = Method 2
  String _ventricle = 'LV';

  double? _mpi;

  void _calculate() {
    double? mpi;
    if (_method == 0) {
      final ivct = double.tryParse(_ivctCtrl.text);
      final ivrt = double.tryParse(_ivrtCtrl.text);
      final et = double.tryParse(_etCtrl.text);
      if (ivct == null || ivrt == null || et == null || et == 0) return;
      mpi = (ivct + ivrt) / et;
    } else {
      final a = double.tryParse(_aCtrl.text);
      final b = double.tryParse(_bCtrl.text);
      if (a == null || b == null || b == 0) return;
      mpi = (a - b) / b;
    }
    setState(() => _mpi = mpi);
  }

  ({_Severity severity, String title, String body}) _interpret(double mpi) {
    if (_ventricle == 'LV') {
      if (mpi <= 0.50) {
        return (
          severity: _Severity.normal,
          title: 'Normal LV Myocardial Performance',
          body: 'MPI within normal range for LV.',
        );
      } else if (mpi <= 0.60) {
        return (
          severity: _Severity.borderline,
          title: 'Borderline',
          body: 'Monitor. Combined systolic and diastolic impairment possible.',
        );
      } else {
        return (
          severity: _Severity.abnormal,
          title: 'Impaired LV Myocardial Performance',
          body:
              'Combined systolic and diastolic dysfunction. Assess for cardiomyopathy, asphyxia, sepsis.',
        );
      }
    } else {
      if (mpi <= 0.45) {
        return (
          severity: _Severity.normal,
          title: 'Normal RV Myocardial Performance',
          body: 'MPI within normal range for RV.',
        );
      } else if (mpi <= 0.55) {
        return (
          severity: _Severity.borderline,
          title: 'Borderline',
          body: 'Monitor. Trend in context of clinical picture.',
        );
      } else {
        return (
          severity: _Severity.abnormal,
          title: 'Impaired RV Myocardial Performance',
          body: 'Elevated RV MPI. Assess for RV dysfunction, PH, or cardiomyopathy.',
        );
      }
    }
  }

  @override
  void dispose() {
    _ivctCtrl.dispose();
    _ivrtCtrl.dispose();
    _etCtrl.dispose();
    _aCtrl.dispose();
    _bCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final interp = _mpi != null ? _interpret(_mpi!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Ventricle selector
        Row(
          children: [
            Text(
              'Ventricle:',
              style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'LV', label: Text('LV')),
                ButtonSegment(value: 'RV', label: Text('RV')),
              ],
              selected: {_ventricle},
              onSelectionChanged: (s) => setState(() {
                _ventricle = s.first;
                _mpi = null;
              }),
              style: ButtonStyle(
                textStyle: WidgetStateProperty.all(
                  GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Method selector
        Row(
          children: [
            Text(
              'Method:',
              style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 12),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('IVCT + IVRT / ET')),
                ButtonSegment(value: 1, label: Text('(a − b) / b')),
              ],
              selected: {_method},
              onSelectionChanged: (s) => setState(() {
                _method = s.first;
                _mpi = null;
              }),
              style: ButtonStyle(
                textStyle: WidgetStateProperty.all(
                  GoogleFonts.plusJakartaSans(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_method == 0) ...[
          _InputField(label: 'IVCT (ms)', hint: 'Isovolumic Contraction Time', controller: _ivctCtrl),
          const SizedBox(height: 10),
          _InputField(label: 'IVRT (ms)', hint: 'Isovolumic Relaxation Time', controller: _ivrtCtrl),
          const SizedBox(height: 10),
          _InputField(label: 'ET (ms)', hint: 'Ejection Time', controller: _etCtrl),
        ] else ...[
          _InputField(
            label: 'a (ms)',
            hint: 'Time from MV/TV close to open',
            controller: _aCtrl,
          ),
          const SizedBox(height: 10),
          _InputField(label: 'b (ms)', hint: 'Ejection Time', controller: _bCtrl),
        ],
        const SizedBox(height: 6),
        Text(
          _method == 0
              ? 'MPI = (IVCT + IVRT) / ET'
              : 'MPI = (a − b) / b  where a = time from AV/PV close to open, b = ejection time',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: cs.onSurface.withValues(alpha: 0.5),
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setSt) => FilledButton(
            onPressed: () { setSt(() {}); _calculate(); },
            child: Text('Calculate', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ),
        if (_mpi != null) ...[
          const SizedBox(height: 12),
          _ResultCard(
            title: 'MPI: ${_mpi!.toStringAsFixed(2)}',
            formula: _method == 0
                ? '(IVCT(${_ivctCtrl.text}) + IVRT(${_ivrtCtrl.text})) / ET(${_etCtrl.text})'
                : '(a(${_aCtrl.text}) − b(${_bCtrl.text})) / b(${_bCtrl.text})',
          ),
          const SizedBox(height: 8),
          _InterpretationCard(
            severity: interp!.severity,
            title: interp.title,
            body: interp.body,
            normalRange: 'LV 0.30–0.50. RV 0.25–0.45 (Tei et al. 1995)',
          ),
          const SizedBox(height: 4),
          const _ReferenceFootnote(
            text:
                'Tei C, et al. New index of combined systolic and diastolic myocardial performance. J Cardiol. 1995.',
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALC 11: IVC Collapsibility Index
// ─────────────────────────────────────────────────────────────────────────────

class _IVCCollapsibilityCalculator extends StatefulWidget {
  const _IVCCollapsibilityCalculator();
  @override
  State<_IVCCollapsibilityCalculator> createState() =>
      _IVCCollapsibilityCalculatorState();
}

class _IVCCollapsibilityCalculatorState extends State<_IVCCollapsibilityCalculator> {
  final _maxCtrl = TextEditingController();
  final _minCtrl = TextEditingController();

  double? _civc;
  String? _error;


  void _calculate() {
    final max = double.tryParse(_maxCtrl.text);
    final min = double.tryParse(_minCtrl.text);
    if (max == null || min == null) return;
    if (min >= max) {
      setState(() {
        _civc = null;
        _error = 'IVC_min must be less than IVC_max.';
      });
      return;
    }
    setState(() {
      _error = null;
      _civc = (max - min) / max * 100;
    });
  }

  ({_Severity severity, String title, String body}) _interpret(double civc) {
    if (civc < 30) {
      return (
        severity: _Severity.borderline,
        title: 'Plethoric IVC',
        body:
            'Consider volume overload, RV failure, or cardiac tamponade. Assess for raised CVP.',
      );
    } else if (civc <= 50) {
      return (
        severity: _Severity.normal,
        title: 'Normal',
        body: 'Normal IVC variability in spontaneously breathing infants.',
      );
    } else {
      return (
        severity: _Severity.abnormal,
        title: 'Underfilled IVC',
        body: 'Suggests hypovolaemia. Consider fluid bolus 10 mL/kg normal saline.',
      );
    }
  }

  @override
  void dispose() {
    _maxCtrl.dispose();
    _minCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final interp = _civc != null ? _interpret(_civc!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputField(label: 'IVC_max (mm)', hint: 'Maximum IVC diameter', controller: _maxCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'IVC_min (mm)', hint: 'Minimum IVC diameter', controller: _minCtrl),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setSt) => FilledButton(
            onPressed: () { setSt(() {}); _calculate(); },
            child: Text('Calculate', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFC62828).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _error!,
              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFFC62828)),
            ),
          ),
        ],
        if (_civc != null) ...[
          const SizedBox(height: 12),
          _ResultCard(
            title: 'cIVC: ${_civc!.toStringAsFixed(1)}%',
            formula:
                '(IVC_max(${_maxCtrl.text}) − IVC_min(${_minCtrl.text})) / IVC_max(${_maxCtrl.text}) × 100',
          ),
          const SizedBox(height: 8),
          _InterpretationCard(
            severity: interp!.severity,
            title: interp.title,
            body: interp.body,
            normalRange: '<50% (Singh Y. Front Pediatr. 2017)',
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: cs.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'For spontaneously breathing infants only. For ventilated infants, use IVC Distensibility Index.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: cs.onSurface.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const _ReferenceFootnote(
            text: 'Singh Y. Echocardiographic Evaluation of Hemodynamics in Neonates. Front Pediatr. 2017.',
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALC 12: IVC Distensibility Index
// ─────────────────────────────────────────────────────────────────────────────

class _IVCDistensibilityCalculator extends StatefulWidget {
  const _IVCDistensibilityCalculator();
  @override
  State<_IVCDistensibilityCalculator> createState() =>
      _IVCDistensibilityCalculatorState();
}

class _IVCDistensibilityCalculatorState extends State<_IVCDistensibilityCalculator> {
  final _maxCtrl = TextEditingController();
  final _minCtrl = TextEditingController();

  double? _divc;
  String? _error;


  void _calculate() {
    final max = double.tryParse(_maxCtrl.text);
    final min = double.tryParse(_minCtrl.text);
    if (max == null || min == null) return;
    if (min >= max) {
      setState(() {
        _divc = null;
        _error = 'IVC_min must be less than IVC_max.';
      });
      return;
    }
    setState(() {
      _error = null;
      _divc = (max - min) / min * 100;
    });
  }

  ({_Severity severity, String title, String body}) _interpret(double divc) {
    if (divc > 18) {
      return (
        severity: _Severity.normal,
        title: 'Fluid Responsive',
        body: 'IVC distending significantly with ventilator breaths. Consider volume expansion.',
      );
    } else {
      return (
        severity: _Severity.borderline,
        title: 'Not Fluid Responsive',
        body: 'Volume unlikely to help. Consider inotrope or vasopressor instead.',
      );
    }
  }

  @override
  void dispose() {
    _maxCtrl.dispose();
    _minCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final interp = _divc != null ? _interpret(_divc!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputField(
          label: 'IVC_max (mm)',
          hint: 'Max IVC diameter (at peak inspiration)',
          controller: _maxCtrl,
        ),
        const SizedBox(height: 10),
        _InputField(
          label: 'IVC_min (mm)',
          hint: 'Min IVC diameter (at expiration)',
          controller: _minCtrl,
        ),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setSt) => FilledButton(
            onPressed: () { setSt(() {}); _calculate(); },
            child: Text('Calculate', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFC62828).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _error!,
              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFFC62828)),
            ),
          ),
        ],
        if (_divc != null) ...[
          const SizedBox(height: 12),
          _ResultCard(
            title: 'dIVC: ${_divc!.toStringAsFixed(1)}%',
            formula:
                '(IVC_max(${_maxCtrl.text}) − IVC_min(${_minCtrl.text})) / IVC_min(${_minCtrl.text}) × 100',
          ),
          const SizedBox(height: 8),
          _InterpretationCard(
            severity: interp!.severity,
            title: interp.title,
            body: interp.body,
            normalRange: '>18% suggests fluid responsiveness (Singh Y. Front Pediatr. 2017)',
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: cs.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'For mechanically ventilated infants only.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: cs.onSurface.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const _ReferenceFootnote(
            text: 'Singh Y. Echocardiographic Evaluation of Hemodynamics in Neonates. Front Pediatr. 2017.',
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALC 13: LA/Ao Ratio
// ─────────────────────────────────────────────────────────────────────────────

class _LAAoCalculator extends StatefulWidget {
  const _LAAoCalculator();
  @override
  State<_LAAoCalculator> createState() => _LAAoCalculatorState();
}

class _LAAoCalculatorState extends State<_LAAoCalculator> {
  final _laCtrl = TextEditingController();
  final _aoCtrl = TextEditingController();

  double? _laAo;


  void _calculate() {
    final la = double.tryParse(_laCtrl.text);
    final ao = double.tryParse(_aoCtrl.text);
    if (la == null || ao == null || ao == 0) return;
    setState(() {
      _laAo = la / ao;
    });
  }

  ({_Severity severity, String title, String body}) _interpret(double laAo) {
    if (laAo <= 1.4) {
      return (
        severity: _Severity.normal,
        title: 'Normal',
        body: 'No significant left-sided volume overload.',
      );
    } else if (laAo <= 1.5) {
      return (
        severity: _Severity.borderline,
        title: 'Borderline',
        body: 'Trend and correlate with clinical findings and other PDA markers.',
      );
    } else if (laAo <= 1.8) {
      return (
        severity: _Severity.abnormal,
        title: 'Elevated — Haemodynamically Significant PDA Likely',
        body:
            'LA volume overload from L→R shunt. Combine with TDD, LPA diastolic flow, and DTA diastolic flow for comprehensive PDA assessment.',
      );
    } else {
      return (
        severity: _Severity.abnormal,
        title: 'Significantly Elevated — Large PDA',
        body:
            'Significant left heart volume overload. Consider pharmacological or surgical PDA closure.',
      );
    }
  }

  @override
  void dispose() {
    _laCtrl.dispose();
    _aoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interp = _laAo != null ? _interpret(_laAo!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputField(label: 'LA Diameter (mm)', hint: 'Left atrium diameter', controller: _laCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'Ao Diameter (mm)', hint: 'Aortic root diameter', controller: _aoCtrl),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setSt) => FilledButton(
            onPressed: () { setSt(() {}); _calculate(); },
            child: Text('Calculate', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ),
        if (_laAo != null) ...[
          const SizedBox(height: 12),
          _ResultCard(
            title: 'LA/Ao: ${_laAo!.toStringAsFixed(2)}',
            formula: 'LA(${_laCtrl.text}) / Ao(${_aoCtrl.text})',
          ),
          const SizedBox(height: 8),
          _InterpretationCard(
            severity: interp!.severity,
            title: interp.title,
            body: interp.body,
            normalRange: '≤1.4. >1.5 = significant PDA (El-Khuffash et al. 2011)',
          ),
          const SizedBox(height: 4),
          const _ReferenceFootnote(
            text:
                'El-Khuffash A, et al. Echocardiography-based assessment of haemodynamic significance of PDA. Arch Dis Child. 2011.',
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALC 14: Qp:Qs Ratio
// ─────────────────────────────────────────────────────────────────────────────

class _QpQsCalculator extends StatefulWidget {
  const _QpQsCalculator();
  @override
  State<_QpQsCalculator> createState() => _QpQsCalculatorState();
}

class _QpQsCalculatorState extends State<_QpQsCalculator> {
  final _mpaVtiCtrl = TextEditingController();
  final _mpaDCtrl = TextEditingController();
  final _lvotVtiCtrl = TextEditingController();
  final _lvotDCtrl = TextEditingController();

  double? _qpQs;


  void _calculate() {
    final mpaVti = double.tryParse(_mpaVtiCtrl.text);
    final mpaD = double.tryParse(_mpaDCtrl.text);
    final lvotVti = double.tryParse(_lvotVtiCtrl.text);
    final lvotD = double.tryParse(_lvotDCtrl.text);
    if (mpaVti == null || mpaD == null || lvotVti == null || lvotD == null) return;
    final qp = mpaVti * pi * (mpaD / 2) * (mpaD / 2);
    final qs = lvotVti * pi * (lvotD / 2) * (lvotD / 2);
    if (qs == 0) return;
    setState(() => _qpQs = qp / qs);
  }

  ({_Severity severity, String title, String body}) _interpret(double qpQs) {
    if (qpQs < 1.5) {
      return (
        severity: _Severity.normal,
        title: 'No significant shunt',
        body: 'Qp:Qs within normal range. No haemodynamically significant shunt.',
      );
    } else if (qpQs <= 2.0) {
      return (
        severity: _Severity.borderline,
        title: 'Moderate shunt',
        body:
            'Significant L→R shunt likely. Correlate with LA/Ao, TDD, clinical findings.',
      );
    } else {
      return (
        severity: _Severity.abnormal,
        title: 'Large shunt',
        body:
            'Large L→R shunt. Haemodynamically significant PDA likely. Consider intervention.',
      );
    }
  }

  @override
  void dispose() {
    _mpaVtiCtrl.dispose();
    _mpaDCtrl.dispose();
    _lvotVtiCtrl.dispose();
    _lvotDCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interp = _qpQs != null ? _interpret(_qpQs!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputField(label: 'MPA VTI (cm)', hint: 'Pulmonary VTI', controller: _mpaVtiCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'MPA Diameter (cm)', hint: 'Main pulmonary artery diameter', controller: _mpaDCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'LVOT VTI (cm)', hint: 'Aortic VTI', controller: _lvotVtiCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'LVOT Diameter (cm)', hint: 'LVOT diameter', controller: _lvotDCtrl),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setSt) => FilledButton(
            onPressed: () { setSt(() {}); _calculate(); },
            child: Text('Calculate', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ),
        if (_qpQs != null) ...[
          const SizedBox(height: 12),
          _ResultCard(
            title: 'Qp:Qs = ${_qpQs!.toStringAsFixed(2)}:1',
            formula:
                'Qp = MPA VTI(${_mpaVtiCtrl.text}) × π×(${_mpaDCtrl.text}/2)²\nQs = LVOT VTI(${_lvotVtiCtrl.text}) × π×(${_lvotDCtrl.text}/2)²',
          ),
          const SizedBox(height: 8),
          _InterpretationCard(
            severity: interp!.severity,
            title: interp.title,
            body: interp.body,
            normalRange: '~1:1 (no shunt). >1.5:1 = significant shunt',
          ),
          const SizedBox(height: 4),
          const _ReferenceFootnote(
            text:
                'El-Khuffash A, McNamara PJ. Neonatologist-performed functional echocardiography. Semin Perinatol. 2011.',
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALC 15: DAo Flow (Descending Aorta)
// ─────────────────────────────────────────────────────────────────────────────

class _DAoFlowCalculator extends StatefulWidget {
  const _DAoFlowCalculator();
  @override
  State<_DAoFlowCalculator> createState() => _DAoFlowCalculatorState();
}

class _DAoFlowCalculatorState extends State<_DAoFlowCalculator> {
  final _dCtrl  = TextEditingController();
  final _vtiCtrl = TextEditingController();
  final _hrCtrl  = TextEditingController();
  final _wtCtrl  = TextEditingController();

  double? _dao;


  void _calculate() {
    final d   = double.tryParse(_dCtrl.text);
    final vti = double.tryParse(_vtiCtrl.text);
    final hr  = double.tryParse(_hrCtrl.text);
    final wt  = double.tryParse(_wtCtrl.text);
    if (d == null || vti == null || hr == null || wt == null || wt == 0) return;
    setState(() {
      _dao = vti * pi * (d / 2) * (d / 2) * hr / wt;
    });
  }

  ({_Severity severity, String title, String body}) _interpret(double dao) {
    if (dao >= 94 && dao <= 158) {
      return (
        severity: _Severity.normal,
        title: 'Normal Descending Aortic Flow',
        body: 'DAo flow is within the expected range (mean 126 ± 32 mL/kg/min).',
      );
    } else if (dao < 94) {
      return (
        severity: _Severity.abnormal,
        title: 'Low DAo Flow',
        body:
            'Reduced descending aortic flow. Check for absent or reversed diastolic component — '
            'systemic steal from haemodynamically significant PDA. Associated with NEC and IVH risk.',
      );
    } else {
      return (
        severity: _Severity.borderline,
        title: 'Elevated DAo Flow',
        body: 'Consider high output state or significant L→R shunt augmenting descending aortic flow.',
      );
    }
  }

  @override
  void dispose() {
    _dCtrl.dispose();
    _vtiCtrl.dispose();
    _hrCtrl.dispose();
    _wtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interp = _dao != null ? _interpret(_dao!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputField(label: 'DAo Diameter (cm)', hint: 'e.g. 0.5', controller: _dCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'DAo VTI (cm)', hint: 'e.g. 9.0', controller: _vtiCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'Heart Rate (bpm)', hint: 'e.g. 150', controller: _hrCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'Weight (kg)', hint: 'e.g. 1.2', controller: _wtCtrl),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setSt) => FilledButton(
            onPressed: () { setSt(() {}); _calculate(); },
            child: Text('Calculate', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ),
        if (_dao != null) ...[
          const SizedBox(height: 12),
          _ResultCard(
            title: 'DAo Flow: ${_dao!.toStringAsFixed(1)} mL/kg/min',
            formula:
                'VTI(${_vtiCtrl.text}) × π×(${_dCtrl.text}/2)² × HR(${_hrCtrl.text}) ÷ Wt(${_wtCtrl.text})',
          ),
          const SizedBox(height: 8),
          _InterpretationCard(
            severity: interp!.severity,
            title: interp.title,
            body: interp.body,
            normalRange: 'Mean 126 ± 32 mL/kg/min (Groves AM, et al. 2011)',
          ),
          const SizedBox(height: 4),
          const _ReferenceFootnote(
            text: 'Groves AM, et al. Arch Dis Child Fetal Neonatal Ed. 2011;96:F86–F91.',
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALC 16: MPA:Ao Ratio
// ─────────────────────────────────────────────────────────────────────────────

class _MPAAoCalculator extends StatefulWidget {
  const _MPAAoCalculator();
  @override
  State<_MPAAoCalculator> createState() => _MPAAoCalculatorState();
}

class _MPAAoCalculatorState extends State<_MPAAoCalculator> {
  final _mpaCtrl = TextEditingController();
  final _aoCtrl  = TextEditingController();

  double? _ratio;


  void _calculate() {
    final mpa = double.tryParse(_mpaCtrl.text);
    final ao  = double.tryParse(_aoCtrl.text);
    if (mpa == null || ao == null || ao == 0) return;
    setState(() {
      _ratio = mpa / ao;
    });
  }

  ({_Severity severity, String title, String body}) _interpret(double ratio) {
    if (ratio <= 1.2) {
      return (
        severity: _Severity.normal,
        title: 'Normal',
        body: 'MPA:Ao ratio within expected range.',
      );
    } else {
      return (
        severity: _Severity.borderline,
        title: 'Elevated',
        body:
            'Suggests pulmonary hypertension or increased RV flow. '
            'Correlate with PAAT, TR jet, and eccentricity index.',
      );
    }
  }

  @override
  void dispose() {
    _mpaCtrl.dispose();
    _aoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interp = _ratio != null ? _interpret(_ratio!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputField(label: 'MPA Diameter (mm)', hint: 'Main pulmonary artery', controller: _mpaCtrl),
        const SizedBox(height: 10),
        _InputField(label: 'Ao Diameter (mm)', hint: 'Aortic root diameter', controller: _aoCtrl),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setSt) => FilledButton(
            onPressed: () { setSt(() {}); _calculate(); },
            child: Text('Calculate', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ),
        if (_ratio != null) ...[
          const SizedBox(height: 12),
          _ResultCard(
            title: 'MPA:Ao: ${_ratio!.toStringAsFixed(2)}',
            formula: 'MPA(${_mpaCtrl.text}) ÷ Ao(${_aoCtrl.text})',
          ),
          const SizedBox(height: 8),
          _InterpretationCard(
            severity: interp!.severity,
            title: interp.title,
            body: interp.body,
            normalRange: '≤1.2 (Mertens L, et al. J Am Soc Echocardiogr. 2011)',
          ),
          const SizedBox(height: 4),
          const _ReferenceFootnote(
            text: 'Mertens L, et al. J Am Soc Echocardiogr. 2011.',
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALC 17: Fractional Area Change (FAC)
// ─────────────────────────────────────────────────────────────────────────────

class _FACCalculator extends StatefulWidget {
  const _FACCalculator();
  @override
  State<_FACCalculator> createState() => _FACCalculatorState();
}

class _FACCalculatorState extends State<_FACCalculator> {
  final _edaCtrl = TextEditingController();
  final _esaCtrl = TextEditingController();

  double? _fac;
  String? _error;


  void _calculate() {
    final eda = double.tryParse(_edaCtrl.text);
    final esa = double.tryParse(_esaCtrl.text);
    if (eda == null || esa == null) return;
    if (esa >= eda) {
      setState(() {
        _fac = null;
        _error = 'RVESa must be less than RVEDa.';
      });
      return;
    }
    setState(() {
      _error = null;
      _fac = (eda - esa) / eda * 100;
    });
  }

  ({_Severity severity, String title, String body}) _interpret(double fac) {
    if (fac >= 35) {
      return (
        severity: _Severity.normal,
        title: 'Normal RV Systolic Function',
        body: 'FAC is within normal range.',
      );
    } else {
      return (
        severity: _Severity.abnormal,
        title: 'RV Systolic Dysfunction',
        body:
            'Assess for PPHN, post-asphyxia, or RV strain. '
            'Measure from RV-focused 4-chamber view.',
      );
    }
  }

  @override
  void dispose() {
    _edaCtrl.dispose();
    _esaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interp = _fac != null ? _interpret(_fac!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputField(
          label: 'RV End-Diastolic Area (cm²)',
          hint: 'RVEDa — e.g. 4.5',
          controller: _edaCtrl,
        ),
        const SizedBox(height: 10),
        _InputField(
          label: 'RV End-Systolic Area (cm²)',
          hint: 'RVESa — e.g. 2.8',
          controller: _esaCtrl,
        ),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setSt) => FilledButton(
            onPressed: () { setSt(() {}); _calculate(); },
            child: Text('Calculate', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFC62828).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _error!,
              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFFC62828)),
            ),
          ),
        ],
        if (_fac != null) ...[
          const SizedBox(height: 12),
          _ResultCard(
            title: 'FAC: ${_fac!.toStringAsFixed(1)}%',
            formula:
                '(RVEDa(${_edaCtrl.text}) − RVESa(${_esaCtrl.text})) / RVEDa(${_edaCtrl.text}) × 100',
          ),
          const SizedBox(height: 8),
          _InterpretationCard(
            severity: interp!.severity,
            title: interp.title,
            body: interp.body,
            normalRange: '35–60% (ASE TNE Guidelines 2024)',
          ),
          const SizedBox(height: 4),
          const _ReferenceFootnote(
            text: 'ASE Targeted Neonatal Echocardiography Guidelines. 2024.',
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALC 18: E/e′ Ratio
// ─────────────────────────────────────────────────────────────────────────────

class _EToEPrimeCalculator extends StatefulWidget {
  const _EToEPrimeCalculator();
  @override
  State<_EToEPrimeCalculator> createState() => _EToEPrimeCalculatorState();
}

class _EToEPrimeCalculatorState extends State<_EToEPrimeCalculator> {
  final _eCtrl      = TextEditingController();
  final _ePrimeCtrl = TextEditingController();

  double? _ratio;


  void _calculate() {
    final e      = double.tryParse(_eCtrl.text);
    final ePrime = double.tryParse(_ePrimeCtrl.text);
    if (e == null || ePrime == null || ePrime == 0) return;
    setState(() {
      _ratio = e / ePrime;
    });
  }

  ({_Severity severity, String title, String body}) _interpret(double ratio) {
    if (ratio <= 8) {
      return (
        severity: _Severity.normal,
        title: 'Normal LV Filling Pressure',
        body: 'E/e\u2032 within normal range.',
      );
    } else {
      return (
        severity: _Severity.borderline,
        title: 'Elevated LV Filling Pressure',
        body:
            'Suggests diastolic dysfunction. Note: limited validation in neonates.',
      );
    }
  }

  @override
  void dispose() {
    _eCtrl.dispose();
    _ePrimeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final interp = _ratio != null ? _interpret(_ratio!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputField(
          label: 'Mitral E Velocity (cm/s)',
          hint: 'e.g. 60',
          controller: _eCtrl,
        ),
        const SizedBox(height: 6),
        Text(
          'E in cm/s. If entered in m/s, multiply by 100.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: cs.onSurface.withValues(alpha: 0.5),
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 10),
        _InputField(
          label: "e\u2032 — Lateral Mitral Annulus TDI (cm/s)",
          hint: 'e.g. 8.0',
          controller: _ePrimeCtrl,
        ),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setSt) => FilledButton(
            onPressed: () { setSt(() {}); _calculate(); },
            child: Text('Calculate', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ),
        if (_ratio != null) ...[
          const SizedBox(height: 12),
          _ResultCard(
            title: "E/e\u2032: ${_ratio!.toStringAsFixed(1)}",
            formula: 'E(${_eCtrl.text}) \u00f7 e\u2032(${_ePrimeCtrl.text})',
          ),
          const SizedBox(height: 8),
          _InterpretationCard(
            severity: interp!.severity,
            title: interp.title,
            body: interp.body,
            normalRange: '<8 (Tissot et al. Front Pediatr. 2018). Limited neonatal data.',
          ),
          const SizedBox(height: 4),
          const _ReferenceFootnote(
            text: 'Tissot C, et al. Front Pediatr. 2018;6:79.',
          ),
        ],
      ],
    );
  }
}
