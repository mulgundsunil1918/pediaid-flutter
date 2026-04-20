// =============================================================================
// lib/screens/guides/birthweight_classification_screen.dart
//
// Absolute birthweight classification reference (WHO + common clinical
// subdivisions).
//
// Same Smart ↔ Table view toggle pattern as the GA Classification screen:
//   - Smart view  → live classifier (birthweight in grams) + matching card
//   - Table view  → full 6-row reference table
//
// Classifications covered (WHO thresholds, with the widely-used micro-preemie
// extension at the low end and macrosomia grades at the high end):
//
//   Micropreemie / Micro-LBW : <750 g
//   ELBW                     : <1000 g
//   VLBW                     : 1000–1499 g
//   LBW                      : 1500–2499 g
//   Normal birth weight      : 2500–3999 g
//   Macrosomia (HBW)         : ≥4000 g
//
// References
//   - WHO. International Statistical Classification of Diseases and Related
//     Health Problems, 10th Revision. ICD-10 P07 (Disorders related to short
//     gestation and low birth weight).
//   - Cutland CL et al. Low birth weight: Case definition & guidelines for
//     data collection, analysis, and presentation of maternal immunization
//     safety data. Vaccine. 2017;35(48 Pt A):6492–6500.
//   - Boulet SL, Alexander GR, Salihu HM, Pass M. Macrosomic births in the
//     United States: determinants, outcomes, and proposed grades of risk.
//     Am J Obstet Gynecol. 2003;188(5):1372–8.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/view_mode_toggle.dart';

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

class _BwClass {
  final String name;          // Display name
  final String abbreviation;  // ELBW, VLBW etc.
  final String weightRange;   // e.g. "1000–1499 g"
  final String definition;    // Clinical definition line
  final String implications;  // Brief clinical implications
  final Color color;
  /// Inclusive grams range — null bound means "no limit".
  final int? gramsMin;
  final int? gramsMax;

  const _BwClass({
    required this.name,
    required this.abbreviation,
    required this.weightRange,
    required this.definition,
    required this.implications,
    required this.color,
    this.gramsMin,
    this.gramsMax,
  });
}

const List<_BwClass> _classifications = [
  _BwClass(
    name: 'Micropreemie',
    abbreviation: 'Micro-LBW',
    weightRange: '<750 g',
    definition:
        'Birthweight below 750 g — extreme end of the extremely-low birth weight spectrum.',
    implications:
        'Highest risk of mortality, IVH, NEC, BPD, ROP, and long-term neurodevelopmental impairment. Requires tertiary NICU care with surfactant, early CPAP/mechanical ventilation, and parenteral nutrition from Day 1.',
    color: Color(0xFF880E4F), // deep magenta
    gramsMax: 749,
  ),
  _BwClass(
    name: 'Extremely Low Birth Weight',
    abbreviation: 'ELBW',
    weightRange: '<1000 g',
    definition:
        'Birthweight below 1000 g regardless of gestational age.',
    implications:
        'Very high risk of respiratory distress syndrome, IVH, NEC, sepsis, and PDA. Surfactant, early TPN, antenatal steroids, and strict fluid/glucose management required. Long-term neurodevelopmental follow-up mandatory.',
    color: Color(0xFFB71C1C), // red
    gramsMax: 999,
  ),
  _BwClass(
    name: 'Very Low Birth Weight',
    abbreviation: 'VLBW',
    weightRange: '1000–1499 g',
    definition:
        'Birthweight 1000 g or more but less than 1500 g.',
    implications:
        'High risk of RDS, PDA, and IVH. Most require NICU admission for respiratory support, early nutrition, and glucose/thermal regulation. Better short-term survival than ELBW but similar risk categories.',
    color: Color(0xFFE65100), // deep orange
    gramsMin: 1000,
    gramsMax: 1499,
  ),
  _BwClass(
    name: 'Low Birth Weight',
    abbreviation: 'LBW',
    weightRange: '1500–2499 g',
    definition:
        'Birthweight 1500 g or more but less than 2500 g.',
    implications:
        'Elevated risk of hypothermia, hypoglycaemia, feeding difficulties, and neonatal sepsis. Many can be managed in SCBU/SNCU with kangaroo mother care (KMC). Lower long-term morbidity than VLBW but still requires close observation.',
    color: Color(0xFFF57F17), // amber
    gramsMin: 1500,
    gramsMax: 2499,
  ),
  _BwClass(
    name: 'Normal Birth Weight',
    abbreviation: 'NBW',
    weightRange: '2500–3999 g',
    definition:
        'Birthweight 2500 g or more but less than 4000 g.',
    implications:
        'Routine newborn care. Rooming-in with mother, early breastfeeding, standard screening (blood sugar, bilirubin, SpO₂, hearing). Low baseline risk of perinatal complications.',
    color: Color(0xFF2E7D32), // green
    gramsMin: 2500,
    gramsMax: 3999,
  ),
  _BwClass(
    name: 'Macrosomia (High Birth Weight)',
    abbreviation: 'HBW',
    weightRange: '≥4000 g',
    definition:
        'Birthweight 4000 g or more. Grade II ≥4500 g; Grade III ≥5000 g.',
    implications:
        'Increased risk of shoulder dystocia, birth injury (brachial plexus, clavicle fracture), hypoglycaemia (especially in infant of diabetic mother), polycythaemia, and NICU admission. Screen for maternal diabetes; monitor blood glucose in first 24–48 h.',
    color: Color(0xFF4A148C), // purple
    gramsMin: 4000,
  ),
];

_BwClass? _classifyFor(int grams) {
  for (final c in _classifications) {
    final min = c.gramsMin ?? -1 << 30;
    final max = c.gramsMax ?? 1 << 30;
    if (grams >= min && grams <= max) return c;
  }
  return null;
}

// =============================================================================
// Screen
// =============================================================================

class BirthweightClassificationScreen extends StatefulWidget {
  const BirthweightClassificationScreen({super.key});

  @override
  State<BirthweightClassificationScreen> createState() =>
      _BirthweightClassificationScreenState();
}

enum _ViewMode { smart, table }

class _BirthweightClassificationScreenState
    extends State<BirthweightClassificationScreen> {
  final _gramsCtl = TextEditingController();
  _ViewMode _view = _ViewMode.smart;

  @override
  void initState() {
    super.initState();
    _gramsCtl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _gramsCtl.dispose();
    super.dispose();
  }

  /// Parsed grams, or null if out of range / unparseable.
  int? get _grams {
    final text = _gramsCtl.text.trim();
    if (text.isEmpty) return null;
    final g = int.tryParse(text) ?? double.tryParse(text)?.round();
    if (g == null) return null;
    if (g < 200 || g > 7000) return null; // sanity-check bounds
    return g;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final grams = _grams;
    final primary = grams != null ? _classifyFor(grams) : null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Birthweight Classification',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Text(
              'ELBW · VLBW · LBW · NBW · Macrosomia',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.80),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        toolbarHeight: 60,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ViewModeToggle(
            value: _view == _ViewMode.smart
                ? ViewModeChoice.smart
                : ViewModeChoice.table,
            onChanged: (choice) => setState(() {
              _view = choice == ViewModeChoice.smart
                  ? _ViewMode.smart
                  : _ViewMode.table;
            }),
          ),
          const SizedBox(height: 16),

          if (_view == _ViewMode.smart) ...[
            _QuickClassifierCard(
              controller: _gramsCtl,
              grams: grams,
              primary: primary,
            ),
            if (primary != null) ...[
              const SizedBox(height: 20),
              _SectionLabel(
                label: 'Matching Classification',
                color: primary.color,
              ),
              const SizedBox(height: 10),
              _BwCard(entry: primary, highlighted: true),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => setState(() => _view = _ViewMode.table),
                icon: const Icon(Icons.table_chart_outlined, size: 16),
                label: Text(
                  'View full table →',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ] else ...[
            _SectionLabel(
              label: 'Full Birthweight Table',
              color: cs.primary,
            ),
            const SizedBox(height: 10),
            ..._classifications.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _BwCard(
                  entry: c,
                  highlighted: primary?.name == c.name,
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),
          Text(
            'WHO ICD-10 P07 (Disorders related to short gestation & low birth weight). '
            'Cutland CL et al., Vaccine 2017. '
            'Macrosomia grading: Boulet SL et al., Am J Obstet Gynecol 2003.\n'
            'Absolute birthweight only — for size-for-GA (SGA / AGA / LGA), '
            'use the Fenton or Intergrowth-21st growth charts.',
            textAlign: TextAlign.left,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: cs.onSurface.withValues(alpha: 0.55),
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Quick classifier card
// ---------------------------------------------------------------------------

class _QuickClassifierCard extends StatelessWidget {
  const _QuickClassifierCard({
    required this.controller,
    required this.grams,
    required this.primary,
  });

  final TextEditingController controller;
  final int? grams;
  final _BwClass? primary;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Birthweight Classifier',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Enter birthweight in grams',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: cs.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: GoogleFonts.plusJakartaSans(fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Birthweight (grams)',
              hintText: 'e.g. 1450',
              suffixText: 'g',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: cs.onSurface.withValues(alpha: 0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: cs.onSurface.withValues(alpha: 0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: cs.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _ResultBanner(grams: grams, primary: primary),
        ],
      ),
    );
  }
}

class _ResultBanner extends StatelessWidget {
  const _ResultBanner({required this.grams, required this.primary});
  final int? grams;
  final _BwClass? primary;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (grams == null || primary == null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.onSurface.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: cs.onSurface.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline,
                size: 16, color: cs.onSurface.withValues(alpha: 0.55)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Enter birthweight (200–7000 g) to classify.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: cs.onSurface.withValues(alpha: 0.7),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }
    final c = primary!;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: c.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(color: c.color, width: 4),
          top: BorderSide(color: c.color.withValues(alpha: 0.25)),
          right: BorderSide(color: c.color.withValues(alpha: 0.25)),
          bottom: BorderSide(color: c.color.withValues(alpha: 0.25)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  c.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: c.color,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: c.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: c.color.withValues(alpha: 0.45)),
                ),
                child: Text(
                  c.abbreviation,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: c.color,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _Row(label: 'Weight range', value: c.weightRange),
          const SizedBox(height: 3),
          _Row(label: 'Entered', value: '$grams g'),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withValues(alpha: 0.65),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              color: cs.onSurface,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Birthweight classification card
// ---------------------------------------------------------------------------

class _BwCard extends StatelessWidget {
  const _BwCard({required this.entry, required this.highlighted});
  final _BwClass entry;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = highlighted
        ? entry.color.withValues(alpha: 0.10)
        : Theme.of(context).cardColor;
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlighted
              ? entry.color.withValues(alpha: 0.55)
              : cs.onSurface.withValues(alpha: 0.1),
          width: highlighted ? 1.4 : 1,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: entry.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (highlighted)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Text(
                              '▶',
                              style: TextStyle(
                                color: entry.color,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            entry.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: entry.color.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            entry.abbreviation,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: entry.color,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _Row(label: 'Weight range', value: entry.weightRange),
                    const SizedBox(height: 4),
                    _Row(label: 'Definition', value: entry.definition),
                    const SizedBox(height: 4),
                    _Row(label: 'Implications', value: entry.implications),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
          color: color,
        ),
      ),
    );
  }
}
