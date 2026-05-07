// =============================================================================
// umbilical_catheter_calculator.dart
// Combined UVC + UAC insertion-depth calculator (Shukla / Dunn formulas).
//
// UVC depth (cm) = (3 × BW kg + 9) / 2 + umbilical stump length
//   Best position: T8–T9, 0.5–1.0 cm above the right diaphragm.
//
// UAC depth (cm):
//   • BW ≥ 1500 g  →  (3 × BW kg) + 9   + umbilical stump length
//   • BW < 1500 g  →  (4 × BW kg) + 7   + umbilical stump length
//   Best position: Low — L3–L4 ; High — T6–T9.
//
// Research add-ons:
//   • Wright birth-length method: UVC = 0.5 × shoulder–umbilicus length + 1
//   • Dunn surface-length method (uses crown-heel)
//   • Confirm position with X-ray; UVC tip in IVC at right diaphragm,
//     UAC high-line above coeliac axis (T6–T9), low-line below renal
//     arteries (L3–L4).
//   • Always clamp the cord at 1.5–2 cm above the abdominal wall before
//     insertion; subtract the stump length from final calculation.
// =============================================================================

import 'package:flutter/material.dart';
import 'fluid_electrolyte_shared.dart';

class UmbilicalCatheterCalculator extends StatefulWidget {
  const UmbilicalCatheterCalculator({super.key});

  @override
  State<UmbilicalCatheterCalculator> createState() =>
      _UmbilicalCatheterCalculatorState();
}

class _UmbilicalCatheterCalculatorState
    extends State<UmbilicalCatheterCalculator> {
  final _wtCtrl = TextEditingController();
  final _stumpCtrl = TextEditingController();

  double? _wt;
  double _stump = 0.0; // default 0 cm
  bool _showResult = false;

  @override
  void dispose() {
    _wtCtrl.dispose();
    _stumpCtrl.dispose();
    super.dispose();
  }

  void _calc() {
    setState(() {
      _wt = double.tryParse(_wtCtrl.text);
      _stump = double.tryParse(_stumpCtrl.text) ?? 0.0;
      _showResult = (_wt != null && _wt! > 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FECalcScaffold(
      title: 'UVC / UAC Depth',
      children: [
        // ── Inputs ──────────────────────────────────────────────────────
        FECalcInputCard(
          label: 'Inputs',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FECalcNumberField(
                controller: _wtCtrl,
                label: 'Birth weight',
                hint: 'kg',
                unit: 'kg',
              ),
              const FECalcGap(),
              FECalcNumberField(
                controller: _stumpCtrl,
                label: 'Umbilical stump length',
                hint: 'cm (default 0)',
                unit: 'cm',
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

        if (_showResult && _wt != null) ...[
          // ── UVC ────────────────────────────────────────────────────────
          _CatheterResultCard(
            title: 'UVC — Umbilical Venous Catheter',
            color: const Color(0xFF1565C0),
            depth: _uvcDepth(_wt!) + _stump,
            depthFormula:
                '= (3 × ${_fmt(_wt!)} + 9) / 2 + ${_fmt(_stump)} stump',
            position: 'Tip at T8–T9 (0.5–1.0 cm above right diaphragm)',
            extras: [
              _kvLine('Length without stump',
                  '${_fmt(_uvcDepth(_wt!))} cm'),
              _kvLine('Stump added', '${_fmt(_stump)} cm'),
              _kvLine('CXR confirmation',
                  'IVC / RA junction; avoid intracardiac (RA)'),
            ],
          ),
          const FECalcGap(),

          // ── UAC ────────────────────────────────────────────────────────
          _CatheterResultCard(
            title: 'UAC — Umbilical Arterial Catheter',
            color: const Color(0xFFC62828),
            depth: _uacDepth(_wt!) + _stump,
            depthFormula: _uacFormulaDescription(_wt!, _stump),
            position: 'Low: L3–L4   ·   High: T6–T9',
            extras: [
              _kvLine('Length without stump',
                  '${_fmt(_uacDepth(_wt!))} cm'),
              _kvLine('Stump added', '${_fmt(_stump)} cm'),
              _kvLine(
                  'Weight-band',
                  _wt! >= 1.5
                      ? '≥ 1500 g  →  (3 × wt) + 9'
                      : '< 1500 g  →  (4 × wt) + 7'),
              _kvLine('CXR confirmation',
                  'High line above T6 = coeliac axis; '
                      'Low line L3–L4 below renal arteries'),
            ],
          ),
          const FECalcGap(),

          // ── Insight ───────────────────────────────────────────────────
          FECalcInsightCard(
            severity: FEInsightSeverity.info,
            title: 'Best practice',
            body:
                '• Confirm both lines with AP CXR before infusion of '
                'inotropes / hyperosmolar fluid.\n'
                '• High UAC (T6–T9) carries lower thrombosis / vascular '
                'compromise risk than low UAC (L3–L4) — preferred where '
                'practicable.\n'
                '• UVC tip in left atrium or portal vein is unacceptable — '
                'pull back to IVC. If unable, use as low-lying line and '
                'remove within 24 h.\n'
                '• Replace UAC by day 5 and UVC by day 7–14 to limit '
                'sepsis / thrombus risk.',
          ),
        ],

        const FECalcGap(),

        // ── Reference ──────────────────────────────────────────────────
        FECalcReferenceCard(
          text:
              'Shukla / Dunn formulas — UVC depth (cm) = (3 × BW kg + 9)/2; '
              'UAC depth (cm) = (3 × BW kg + 9) for ≥ 1500 g, '
              '(4 × BW kg + 7) for < 1500 g; add umbilical stump length to '
              'each. Position confirmed on AP chest/abdominal X-ray. '
              'For use by qualified neonatal clinicians only.',
        ),
      ],
    );
  }

  // ── Math ───────────────────────────────────────────────────────────────
  double _uvcDepth(double wt) => (3 * wt + 9) / 2;
  double _uacDepth(double wt) =>
      wt >= 1.5 ? (3 * wt) + 9 : (4 * wt) + 7;

  String _uacFormulaDescription(double wt, double stump) {
    if (wt >= 1.5) {
      return '= (3 × ${_fmt(wt)}) + 9 + ${_fmt(stump)} stump  '
          '(BW ≥ 1500 g rule)';
    }
    return '= (4 × ${_fmt(wt)}) + 7 + ${_fmt(stump)} stump  '
        '(BW < 1500 g rule)';
  }
}

// ─── Result card ────────────────────────────────────────────────────────────

class _CatheterResultCard extends StatelessWidget {
  final String title;
  final Color color;
  final double depth;
  final String depthFormula;
  final String position;
  final List<Widget> extras;
  const _CatheterResultCard({
    required this.title,
    required this.color,
    required this.depth,
    required this.depthFormula,
    required this.position,
    required this.extras,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          left: BorderSide(color: color, width: 4),
          top: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
          right: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
          bottom: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(_fmt(depth),
                  style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: color,
                      height: 1.0)),
              const SizedBox(width: 6),
              Text('cm',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: color)),
            ],
          ),
          const SizedBox(height: 6),
          Text(depthFormula,
              style: TextStyle(
                  fontSize: 11.5,
                  color: cs.onSurface.withValues(alpha: 0.65),
                  fontStyle: FontStyle.italic)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 7, 10, 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withValues(alpha: 0.40)),
            ),
            child: Row(
              children: [
                Icon(Icons.gps_fixed, size: 14, color: color),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(position,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: color)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...extras,
        ],
      ),
    );
  }
}

Widget _kvLine(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Builder(builder: (ctx) {
      final cs = Theme.of(ctx).colorScheme;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurface.withValues(alpha: 0.55),
                    fontWeight: FontWeight.w700)),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withValues(alpha: 0.85),
                    height: 1.45)),
          ),
        ],
      );
    }),
  );
}

String _fmt(double v) {
  if (v.isNaN || v.isInfinite) return '—';
  return v.toStringAsFixed(1);
}
