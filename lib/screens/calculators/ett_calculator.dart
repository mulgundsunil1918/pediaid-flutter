// =============================================================================
// ett_calculator.dart
// Endotracheal tube SIZE + INSERTION DEPTH calculator.
//
//  SIZE (mm internal diameter)
//   - Newborn / preterm by weight-band table.
//
//  INSERTION DEPTH (cm, oral)
//   1. NTL + 1 cm  — Nasal-Tragus length + 1, preferred for neonates.
//   2. 6 + weight (kg) — newborns up to ~3-4 kg.
//   3. (age yr / 2) + 12 — children > 2 yr.
//   4. 3 × tube size — universal cross-check.
// =============================================================================

import 'package:flutter/material.dart';
import 'fluid_electrolyte_shared.dart';

class EttCalculator extends StatefulWidget {
  const EttCalculator({super.key});

  @override
  State<EttCalculator> createState() => _EttCalculatorState();
}

class _EttCalculatorState extends State<EttCalculator> {
  final _ageYrCtrl = TextEditingController();
  final _wtCtrl = TextEditingController();
  final _ntlCtrl = TextEditingController();
  final _ettSizeCtrl = TextEditingController();

  double? _ageYr;
  double? _wt;
  double? _ntl;
  double? _ettSize;

  bool _calculated = false;

  @override
  void dispose() {
    _ageYrCtrl.dispose();
    _wtCtrl.dispose();
    _ntlCtrl.dispose();
    _ettSizeCtrl.dispose();
    super.dispose();
  }

  void _calc() {
    setState(() {
      _ageYr = double.tryParse(_ageYrCtrl.text);
      _wt = double.tryParse(_wtCtrl.text);
      _ntl = double.tryParse(_ntlCtrl.text);
      _ettSize = double.tryParse(_ettSizeCtrl.text);
      _calculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FECalcScaffold(
      title: 'ETT Size + Depth',
      children: [
        // ── Inputs ──────────────────────────────────────────────────────
        FECalcInputCard(
          label: 'Inputs (any combination)',
          child: Column(
            children: [
              // ── Highlighted hint: any one value is enough ─────────────
              Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFFFFB300), width: 1.2),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.info_outline,
                        color: Color(0xFFE65100), size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Enter ANY value below — you do not need to fill '
                        'all four. Each formula uses only its own input '
                        '(e.g. NTL alone is enough for the NTL+1 depth, '
                        'weight alone gives the neonatal size band).',
                        style: TextStyle(
                            color: Color(0xFF8B5300),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const FECalcGap(),
              FECalcNumberField(
                controller: _ageYrCtrl,
                label: 'Age',
                hint: 'years (use 0 for neonates)',
                unit: 'yr',
              ),
              const FECalcGap(),
              FECalcNumberField(
                controller: _wtCtrl,
                label: 'Weight',
                hint: 'kg',
                unit: 'kg',
              ),
              const FECalcGap(),
              FECalcNumberField(
                controller: _ntlCtrl,
                label: 'Nasal–Tragus length (NTL)',
                hint: 'cm — measure tip of nose to tragus',
                unit: 'cm',
              ),
              const FECalcGap(),
              FECalcNumberField(
                controller: _ettSizeCtrl,
                label: 'ETT internal diameter (optional)',
                hint:
                    'mm — leave blank to auto-recommend',
                unit: 'mm',
              ),
              const FECalcGap(),
              FECalcButton(
                  label: 'Calculate',
                  icon: Icons.calculate,
                  onPressed: _calc),
            ],
          ),
        ),
        const FECalcGap(),

        if (_calculated) ...[
          // ── ETT Size recommendations ──────────────────────────────────
          _SectionHeader(
              title: 'ETT internal diameter (mm)', color: Color(0xFF1565C0)),
          const SizedBox(height: 8),
          _sizeRecommendations(),
          const FECalcGap(),

          // ── ETT Depth ─────────────────────────────────────────────────
          _SectionHeader(
              title: 'Oral insertion depth (cm at lip)',
              color: Color(0xFFC62828)),
          const SizedBox(height: 8),
          _depthRecommendations(),
          const FECalcGap(),

          // ── Position confirmation insight ─────────────────────────────
          const FECalcInsightCard(
            severity: FEInsightSeverity.info,
            title: 'Confirm position before securing',
            body:
                '• Equal bilateral chest rise + breath sounds ; CO₂ trace.\n'
                '• Listen over both axillae and stomach (no epigastric '
                'sounds, no condensation in tube while bagging).\n'
                '• CXR — tip should sit between T1–T2 (above carina).\n'
                '• If R-main bronchus intubation: pull back 1 cm and '
                'reassess.\n'
                '• Cuff pressure < 25 cm H₂O when cuffed tubes used.',
          ),
        ],

        const FECalcGap(),

        // ── Reference table ────────────────────────────────────────────
        _SectionHeader(
            title: 'Newborn / preterm reference table',
            color: Color(0xFF6A1B9A)),
        const SizedBox(height: 8),
        const _NeonatalTable(),

        const FECalcGap(),
        const FECalcReferenceCard(
          text:
              'For use by qualified clinicians only — verify position '
              'with auscultation, capnography and chest X-ray after every '
              'intubation. Newborn weight-band sizes mirror standard NRP '
              'practice; depth methods are common bedside formulas.',
        ),
      ],
    );
  }

  // ── Size cards ─────────────────────────────────────────────────────────
  Widget _sizeRecommendations() {
    final cards = <Widget>[];

    // Newborn weight-band rule (preferred for neonates)
    if (_wt != null && _wt! > 0 && (_ageYr == null || _ageYr! < 1)) {
      String wtBand;
      String size;
      if (_wt! < 1.0) {
        wtBand = '< 1 kg';
        size = '2.5';
      } else if (_wt! < 2.0) {
        wtBand = '1–2 kg';
        size = '3.0';
      } else if (_wt! < 3.0) {
        wtBand = '2–3 kg';
        size = '3.0';
      } else {
        wtBand = '> 3 kg';
        size = '3.5';
      }
      cards.add(_methodCard(
        method: 'Neonatal weight band ($wtBand)',
        result: '$size mm uncuffed',
        formula: 'standard neonatal practice',
        color: const Color(0xFF6A1B9A),
      ));
    }

    if (_ageYr != null && _ageYr! >= 1) {
      // Uncuffed standard
      final szU = _ageYr! / 4 + 4;
      cards.add(_methodCard(
        method: 'Uncuffed — (age/4) + 4',
        result: '${_round05(szU).toStringAsFixed(1)} mm',
        formula: '(${_fmt(_ageYr!)}/4) + 4',
        color: const Color(0xFF1565C0),
      ));
      // Cuffed standard (≥ 2 yr)
      if (_ageYr! >= 2) {
        final szC = _ageYr! / 4 + 3.5;
        cards.add(_methodCard(
          method: 'Cuffed (≥ 2 yr) — (age/4) + 3.5',
          result: '${_round05(szC).toStringAsFixed(1)} mm',
          formula: '(${_fmt(_ageYr!)}/4) + 3.5',
          color: const Color(0xFF1565C0),
        ));
      } else {
        // Cuffed under 2 yr
        final szSmall = _ageYr! / 4 + 3;
        cards.add(_methodCard(
          method: 'Cuffed (< 2 yr) — (age/4) + 3',
          result: '${_round05(szSmall).toStringAsFixed(1)} mm',
          formula: '(${_fmt(_ageYr!)}/4) + 3',
          color: const Color(0xFF1565C0),
        ));
      }
    }

    if (cards.isEmpty) {
      cards.add(const _EmptyHint(text:
          'Enter age (≥ 1 yr) for the size formula or weight for the '
          'neonatal band recommendation.'));
    }
    return Column(children: cards);
  }

  // ── Depth cards ────────────────────────────────────────────────────────
  Widget _depthRecommendations() {
    final cards = <Widget>[];

    // 1. NTL + 1 cm
    if (_ntl != null && _ntl! > 0) {
      final d = _ntl! + 1;
      cards.add(_methodCard(
        method: 'NTL + 1 cm  (preferred neonatal method)',
        result: '${_fmt(d)} cm',
        formula: 'NTL (${_fmt(_ntl!)}) + 1',
        color: const Color(0xFF2E7D32),
        emphasised: true,
      ));
    }

    // 2. 6 + weight
    if (_wt != null && _wt! > 0) {
      final d = 6 + _wt!;
      cards.add(_methodCard(
        method: '6 + weight (newborn)',
        result: '${_fmt(d)} cm',
        formula: '6 + ${_fmt(_wt!)}',
        color: const Color(0xFFC62828),
      ));
    }

    // 3. Age-based oral (> 2 yr)
    if (_ageYr != null && _ageYr! >= 2) {
      final d = (_ageYr! / 2) + 12;
      cards.add(_methodCard(
        method: 'Age-based (> 2 yr) — (age/2) + 12',
        result: '${_fmt(d)} cm',
        formula: '(${_fmt(_ageYr!)}/2) + 12',
        color: const Color(0xFFC62828),
      ));
    }

    // 4. Tube size × 3 (universal)
    if (_ettSize != null && _ettSize! > 0) {
      final d = 3 * _ettSize!;
      cards.add(_methodCard(
        method: 'Tube size × 3 (cross-check)',
        result: '${_fmt(d)} cm',
        formula: '3 × ${_fmt(_ettSize!)} mm',
        color: const Color(0xFFC62828),
      ));
    }

    if (cards.isEmpty) {
      cards.add(const _EmptyHint(text:
          'Enter NTL (cm) for the preferred neonatal NTL+1 method, or '
          'weight / age / tube size for the alternate formulas.'));
    }
    return Column(children: cards);
  }

  // ── Helpers ────────────────────────────────────────────────────────────
  static double _round05(double v) {
    return (v * 2).round() / 2.0;
  }

  static String _fmt(double v) {
    if (v.isNaN || v.isInfinite) return '—';
    return v.toStringAsFixed(1);
  }

  Widget _methodCard({
    required String method,
    required String result,
    required String formula,
    required Color color,
    bool emphasised = false,
  }) {
    return Builder(builder: (ctx) {
      final cs = Theme.of(ctx).colorScheme;
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: emphasised
              ? color.withValues(alpha: 0.10)
              : Theme.of(ctx).cardColor,
          border: Border.all(
              color: emphasised
                  ? color
                  : cs.onSurface.withValues(alpha: 0.10),
              width: emphasised ? 1.5 : 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(method,
                      style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2)),
                  const SizedBox(height: 2),
                  Text(formula,
                      style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.55),
                          fontSize: 10.5,
                          fontStyle: FontStyle.italic)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(result,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2)),
            ),
          ],
        ),
      );
    });
  }
}

// ─── Section header (mini) ──────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: color, width: 4),
        ),
      ),
      child: Text(title.toUpperCase(),
          style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.5)),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String text;
  const _EmptyHint({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.04),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.10)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 11.5,
              color: cs.onSurface.withValues(alpha: 0.65),
              fontStyle: FontStyle.italic)),
    );
  }
}

// ─── Neonatal weight-based reference table ──────────────────────────────────

class _NeonatalTable extends StatelessWidget {
  const _NeonatalTable();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    const rows = [
      _NeoRow(weight: '< 1.0 kg', size: '2.5', depth: '6.5–7'),
      _NeoRow(weight: '1.0–2.0 kg', size: '3.0', depth: '7–8'),
      _NeoRow(weight: '2.0–3.0 kg', size: '3.0', depth: '8–9'),
      _NeoRow(weight: '> 3.0 kg', size: '3.5', depth: '9–10'),
      _NeoRow(weight: '6 mo (~7 kg)', size: '3.5', depth: '10'),
      _NeoRow(weight: '1 yr (~10 kg)', size: '4.0', depth: '11'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.10)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFF6A1B9A).withValues(alpha: 0.10),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(9),
                  topRight: Radius.circular(9)),
            ),
            child: Row(
              children: [
                Expanded(flex: 4, child: _hdr('WEIGHT')),
                Expanded(flex: 3, child: _hdr('TUBE (mm)')),
                Expanded(flex: 3, child: _hdr('DEPTH (cm)')),
              ],
            ),
          ),
          ...rows.map((r) => Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 7),
                child: Row(
                  children: [
                    Expanded(flex: 4, child: _cell(r.weight)),
                    Expanded(flex: 3, child: _cell(r.size, bold: true)),
                    Expanded(flex: 3, child: _cell(r.depth, bold: true)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _hdr(String s) => Text(s,
      style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF4A148C),
          letterSpacing: 0.4));

  Widget _cell(String s, {bool bold = false}) => Text(s,
      style: TextStyle(
          fontSize: 12,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500));
}

class _NeoRow {
  final String weight;
  final String size;
  final String depth;
  const _NeoRow(
      {required this.weight, required this.size, required this.depth});
}
