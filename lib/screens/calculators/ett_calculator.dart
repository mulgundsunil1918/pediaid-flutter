// =============================================================================
// ett_calculator.dart
// Endotracheal tube SIZE + INSERTION DEPTH calculator.
//
// Restructured into self-contained method subsections: each method shows its
// own formula, takes only its own input, and computes live. Fill only the
// method(s) you need — nothing is shared or ambiguous.
//
//  SIZE (mm internal diameter)
//   - By weight — newborn / preterm weight-band table.
//   - By age    — Cole formula: (age/4) + 4 uncuffed, + 3.5/3 cuffed.
//  DEPTH (cm, oral at lip)
//   - NTL + 1 cm  (preferred neonatal method).
//   - 6 + weight (kg) — newborns.
//   - (age/2) + 12 — children > 2 yr.
//   - 3 × tube size — universal cross-check.
// =============================================================================

import 'package:flutter/material.dart';
import 'fluid_electrolyte_shared.dart';

class EttCalculator extends StatefulWidget {
  const EttCalculator({super.key});

  @override
  State<EttCalculator> createState() => _EttCalculatorState();
}

class _EttCalculatorState extends State<EttCalculator> {
  // One controller per method — each subsection is independent.
  final _wtSizeCtrl = TextEditingController();
  final _ageSizeCtrl = TextEditingController();
  final _ntlCtrl = TextEditingController();
  final _wtDepthCtrl = TextEditingController();
  final _ageDepthCtrl = TextEditingController();
  final _ettCtrl = TextEditingController();

  @override
  void dispose() {
    _wtSizeCtrl.dispose();
    _ageSizeCtrl.dispose();
    _ntlCtrl.dispose();
    _wtDepthCtrl.dispose();
    _ageDepthCtrl.dispose();
    _ettCtrl.dispose();
    super.dispose();
  }

  static const _blue = Color(0xFF1565C0);
  static const _purple = Color(0xFF6A1B9A);
  static const _green = Color(0xFF2E7D32);
  static const _red = Color(0xFFC62828);

  static double? _p(TextEditingController c) {
    final v = double.tryParse(c.text.trim());
    return (v != null && v > 0) ? v : null;
  }

  static double _round05(double v) => (v * 2).round() / 2.0;
  static String _fmt(double v) => v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    return FECalcScaffold(
      title: 'ETT Size + Depth',
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFFB300), width: 1.2),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: Color(0xFFE65100), size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Each method below is self-contained. Fill only the one you '
                  'want — its result updates live as you type.',
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

        // ── SIZE ────────────────────────────────────────────────────────────
        const _SectionHeader(title: 'ETT internal diameter (mm)', color: _blue),
        const SizedBox(height: 8),
        _sizeByWeight(),
        _sizeByAge(),
        const FECalcGap(),

        // ── DEPTH ───────────────────────────────────────────────────────────
        const _SectionHeader(title: 'Oral insertion depth (cm at lip)', color: _red),
        const SizedBox(height: 8),
        _depthNtl(),
        _depthByWeight(),
        _depthByAge(),
        _depthByTube(),
        const FECalcGap(),

        const FECalcInsightCard(
          severity: FEInsightSeverity.info,
          title: 'Confirm position before securing',
          body:
              '• Equal bilateral chest rise + breath sounds ; CO₂ trace.\n'
              '• Listen over both axillae and stomach (no epigastric sounds).\n'
              '• CXR — tip should sit between T1–T2 (above carina).\n'
              '• If right-main bronchus intubation: pull back 1 cm and reassess.\n'
              '• Cuff pressure < 25 cm H₂O when cuffed tubes used.',
        ),
        const FECalcGap(),

        const _SectionHeader(title: 'Newborn / preterm reference table', color: _purple),
        const SizedBox(height: 8),
        const _NeonatalTable(),
        const FECalcGap(),
        const FECalcReferenceCard(
          text:
              'For use by qualified clinicians only — verify position with '
              'auscultation, capnography and chest X-ray after every intubation. '
              'Newborn weight-band sizes mirror standard NRP practice; depth '
              'methods are common bedside formulas.',
        ),
      ],
    );
  }

  // ── SIZE subsections ──────────────────────────────────────────────────────
  Widget _sizeByWeight() {
    final wt = _p(_wtSizeCtrl);
    String? result, sub;
    if (wt != null) {
      final String band, size;
      if (wt < 1.0) { band = '< 1 kg'; size = '2.5'; }
      else if (wt < 2.0) { band = '1–2 kg'; size = '3.0'; }
      else if (wt < 3.0) { band = '2–3 kg'; size = '3.0'; }
      else { band = '> 3 kg'; size = '3.5'; }
      result = '$size mm';
      sub = 'uncuffed · $band';
    }
    return _method(
      title: 'Size by weight (neonate)',
      formula: 'Weight-band table (NRP)',
      color: _purple,
      controller: _wtSizeCtrl,
      fieldLabel: 'Weight',
      unit: 'kg',
      result: result,
      resultSub: sub,
    );
  }

  Widget _sizeByAge() {
    final age = _p(_ageSizeCtrl);
    String? result, sub;
    if (age != null) {
      final unc = _round05(age / 4 + 4);
      final cuff = _round05(age / 4 + (age >= 2 ? 3.5 : 3));
      result = '${_fmt(unc)} mm';
      sub = 'uncuffed · cuffed ${_fmt(cuff)} mm';
    }
    return _method(
      title: 'Size by age (Cole formula)',
      formula: 'uncuffed = (age/4) + 4 · cuffed = (age/4) + 3.5',
      color: _blue,
      controller: _ageSizeCtrl,
      fieldLabel: 'Age',
      unit: 'yr',
      result: result,
      resultSub: sub,
    );
  }

  // ── DEPTH subsections ─────────────────────────────────────────────────────
  Widget _depthNtl() {
    final ntl = _p(_ntlCtrl);
    return _method(
      title: 'NTL + 1 cm  (preferred neonatal)',
      formula: 'Nasal–Tragus length + 1',
      color: _green,
      emphasised: true,
      controller: _ntlCtrl,
      fieldLabel: 'Nasal–Tragus length',
      unit: 'cm',
      result: ntl == null ? null : '${_fmt(ntl + 1)} cm',
    );
  }

  Widget _depthByWeight() {
    final wt = _p(_wtDepthCtrl);
    return _method(
      title: 'Depth by weight (newborn)',
      formula: '6 + weight (kg)',
      color: _red,
      controller: _wtDepthCtrl,
      fieldLabel: 'Weight',
      unit: 'kg',
      result: wt == null ? null : '${_fmt(6 + wt)} cm',
    );
  }

  Widget _depthByAge() {
    final age = _p(_ageDepthCtrl);
    return _method(
      title: 'Depth by age (> 2 yr)',
      formula: '(age/2) + 12',
      color: _red,
      controller: _ageDepthCtrl,
      fieldLabel: 'Age',
      unit: 'yr',
      result: age == null ? null : '${_fmt(age / 2 + 12)} cm',
    );
  }

  Widget _depthByTube() {
    final ett = _p(_ettCtrl);
    return _method(
      title: 'Depth by tube size (cross-check)',
      formula: '3 × tube internal diameter',
      color: _red,
      controller: _ettCtrl,
      fieldLabel: 'ETT internal diameter',
      unit: 'mm',
      result: ett == null ? null : '${_fmt(3 * ett)} cm',
    );
  }

  // ── Reusable method subsection ────────────────────────────────────────────
  Widget _method({
    required String title,
    required String formula,
    required Color color,
    required TextEditingController controller,
    required String fieldLabel,
    required String unit,
    required String? result,
    String? resultSub,
    bool emphasised = false,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: emphasised ? color.withValues(alpha: 0.06) : Theme.of(context).cardColor,
        border: Border.all(
          color: emphasised ? color : cs.onSurface.withValues(alpha: 0.12),
          width: emphasised ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(formula,
                        style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.55),
                            fontSize: 11,
                            fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Live result chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: result == null ? cs.onSurface.withValues(alpha: 0.06) : color,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(result ?? '—',
                        style: TextStyle(
                            color: result == null ? cs.onSurface.withValues(alpha: 0.4) : Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800)),
                    if (result != null && resultSub != null)
                      Text(resultSub,
                          style: const TextStyle(color: Colors.white70, fontSize: 9.5, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FECalcNumberField(
            controller: controller,
            label: fieldLabel,
            hint: unit == 'yr' ? 'years' : unit == 'kg' ? 'kg' : unit == 'cm' ? 'cm' : 'mm',
            unit: unit,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
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
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Text(title.toUpperCase(),
          style: TextStyle(
              fontSize: 11.5, fontWeight: FontWeight.w800, color: color, letterSpacing: 0.5)),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFF6A1B9A).withValues(alpha: 0.10),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(9), topRight: Radius.circular(9)),
            ),
            child: Row(children: [
              Expanded(flex: 4, child: _hdr('WEIGHT')),
              Expanded(flex: 3, child: _hdr('TUBE (mm)')),
              Expanded(flex: 3, child: _hdr('DEPTH (cm)')),
            ]),
          ),
          ...rows.map((r) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                child: Row(children: [
                  Expanded(flex: 4, child: _cell(r.weight)),
                  Expanded(flex: 3, child: _cell(r.size, bold: true)),
                  Expanded(flex: 3, child: _cell(r.depth, bold: true)),
                ]),
              )),
        ],
      ),
    );
  }

  Widget _hdr(String s) => Text(s,
      style: const TextStyle(
          fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF4A148C), letterSpacing: 0.4));

  Widget _cell(String s, {bool bold = false}) => Text(s,
      style: TextStyle(fontSize: 12, fontWeight: bold ? FontWeight.w700 : FontWeight.w500));
}

class _NeoRow {
  final String weight;
  final String size;
  final String depth;
  const _NeoRow({required this.weight, required this.size, required this.depth});
}
