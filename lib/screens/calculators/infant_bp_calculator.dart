import 'package:flutter/material.dart';
import 'infant_bp_1987_data.dart';

// ══════════════════════════════════════════════════════════════════════════
// Infant BP (postnatal 1–12 months).
//
// Two layers:
//   1) Hypotension screen  — SBP < 70 mmHg flag (real, sourced; ships now).
//   2) Percentile layer    — full by-month table, gated behind
//      [infantBpDataReady]; dormant until Second Task Force 1987 Fig 1 is
//      digitized (see infant_bp_1987_data.dart). No invented numbers.
// ══════════════════════════════════════════════════════════════════════════

class InfantBPCalculator extends StatefulWidget {
  const InfantBPCalculator({super.key});

  @override
  State<InfantBPCalculator> createState() => _InfantBPCalculatorState();
}

class _InfantBPCalculatorState extends State<InfantBPCalculator> {
  bool _isBoy = true;
  int _months = 6;
  final _monthsCtrl = TextEditingController(text: '6');
  final _sbpCtrl = TextEditingController(text: '');
  final _dbpCtrl = TextEditingController(text: '');

  bool _assessed = false;
  int _enteredSBP = 0;
  int? _enteredDBP;

  @override
  void dispose() {
    _monthsCtrl.dispose();
    _sbpCtrl.dispose();
    _dbpCtrl.dispose();
    super.dispose();
  }

  int? get _monthsInput {
    final v = int.tryParse(_monthsCtrl.text.trim());
    return (v != null && v >= 1 && v <= 12) ? v : null;
  }

  int? get _sbpInput {
    final v = int.tryParse(_sbpCtrl.text.trim());
    return (v != null && v >= 30 && v <= 160) ? v : null;
  }

  int? get _dbpInput {
    final v = int.tryParse(_dbpCtrl.text.trim());
    return (v != null && v >= 15 && v <= 120) ? v : null;
  }

  bool get _canAssess => _monthsInput != null && _sbpInput != null;

  void _assess() {
    if (!_canAssess) return;
    setState(() {
      _months = _monthsInput!;
      _enteredSBP = _sbpInput!;
      _enteredDBP = _dbpInput;
      _assessed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: cs.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Infant BP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: cs.onPrimary)),
            Text('Postnatal 1–12 months', style: TextStyle(fontSize: 11, color: cs.onPrimary.withValues(alpha: 0.75))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pendingNote(),
            const SizedBox(height: 14),
            _inputCard(),
            if (_assessed) ...[
              const SizedBox(height: 16),
              _hypotensionResult(),
              if (infantBpDataReady) ...[
                const SizedBox(height: 12),
                _percentileResult(),
              ],
            ],
            const SizedBox(height: 14),
            _whichCardNote(),
            const SizedBox(height: 12),
            _referenceCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── "Data pending" banner (only while percentile layer is dormant) ──
  Widget _pendingNote() {
    if (infantBpDataReady) return const SizedBox.shrink();
    const orange = Color(0xFFD4820A);
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: orange.withValues(alpha: 0.09),
        border: Border.all(color: orange.withValues(alpha: 0.45)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🚧', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Full percentile reference for this age band is pending verified data. '
              'This tool currently screens for hypotension (< $infantHypotensionSbp mmHg systolic) only.',
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  // ── Input card ──
  Widget _inputCard() {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Infant Blood Pressure', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.primary)),
            const SizedBox(height: 16),
            Text('Sex', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: cs.onSurface)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _genderBtn('👦  Boy', true)),
              Expanded(child: _genderBtn('👧  Girl', false)),
            ]),
            const SizedBox(height: 16),
            _stepper(
              label: 'Age (months)',
              value: _months, min: 1, max: 12, hint: '1–12 months',
              controller: _monthsCtrl,
              onChanged: (v) => _months = v,
            ),
            const SizedBox(height: 16),
            _numField('Systolic BP (mmHg)', _sbpCtrl, 'e.g. 85'),
            const SizedBox(height: 14),
            _numField('Diastolic BP (mmHg) — optional', _dbpCtrl, 'recorded, not yet classified'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canAssess ? _assess : null,
                child: const Text('Screen Blood Pressure', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            if (!_canAssess) ...[
              const SizedBox(height: 8),
              Text('Enter age in months and a systolic BP to screen.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11.5, color: cs.onSurface.withValues(alpha: 0.55))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _genderBtn(String label, bool isBoy) {
    final cs = Theme.of(context).colorScheme;
    final active = _isBoy == isBoy;
    return GestureDetector(
      onTap: () => setState(() => _isBoy = isBoy),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? cs.primary : Colors.transparent,
          border: Border.all(color: cs.primary),
          borderRadius: BorderRadius.horizontal(
            left: isBoy ? const Radius.circular(10) : Radius.zero,
            right: isBoy ? Radius.zero : const Radius.circular(10),
          ),
        ),
        child: Text(label, textAlign: TextAlign.center,
            style: TextStyle(color: active ? Colors.white : cs.primary, fontWeight: FontWeight.w600, fontSize: 14)),
      ),
    );
  }

  Widget _numField(String label, TextEditingController ctrl, String hint) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: cs.onSurface)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(hintText: hint, isDense: true, border: const OutlineInputBorder()),
        ),
      ],
    );
  }

  // ── Hypotension result (the real, sourced output) ──
  Widget _hypotensionResult() {
    final cs = Theme.of(context).colorScheme;
    final isHypo = _enteredSBP < infantHypotensionSbp;
    const red = Color(0xFFE53935);
    const green = Color(0xFF2DBD8C);
    final color = isHypo ? red : green;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        border: Border.all(color: color.withValues(alpha: 0.55), width: 1.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(isHypo ? Icons.warning_amber_rounded : Icons.check_circle_rounded, color: color, size: 22),
            const SizedBox(width: 8),
            Text('HYPOTENSION SCREEN',
                style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.6)),
          ]),
          const SizedBox(height: 10),
          Text(isHypo ? 'Hypotensive' : 'Above hypotension threshold',
              style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            isHypo
                ? 'Systolic $_enteredSBP mmHg is BELOW the $infantHypotensionSbp mmHg infant floor — assess urgently for hypotension/shock.'
                : 'Systolic $_enteredSBP mmHg is at or above the $infantHypotensionSbp mmHg infant floor. This screens for LOW BP only — it does not confirm BP is normal for age.',
            style: TextStyle(color: cs.onSurface.withValues(alpha: 0.82), fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 6),
          Text('PALS hypotension floor, infant 1–12 months: SBP < $infantHypotensionSbp mmHg.',
              style: TextStyle(color: cs.onSurface.withValues(alpha: 0.55), fontSize: 11.5, fontStyle: FontStyle.italic)),
          if (_enteredDBP != null) ...[
            const SizedBox(height: 8),
            Text('Diastolic recorded: $_enteredDBP mmHg (no verified percentile reference for this age band yet).',
                style: TextStyle(color: cs.onSurface.withValues(alpha: 0.55), fontSize: 11.5)),
          ],
        ],
      ),
    );
  }

  // ── Percentile result (only reachable when infantBpDataReady == true) ──
  Widget _percentileResult() {
    // Placeholder for the future percentile layer. When infant_bp_1987_data.dart
    // is populated and infantBpDataReady flips true, build the AAP-style
    // classification here using infantBp1987[_months][sex].
    final row = infantBp1987[_months]?[_isBoy ? 'boy' : 'girl'];
    final cs = Theme.of(context).colorScheme;
    if (row == null || !row.isPopulated) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: cs.surface, border: Border.all(color: cs.outline), borderRadius: BorderRadius.circular(10)),
      child: Text('Percentile classification — Second Task Force 1987 (age $_months mo).',
          style: TextStyle(color: cs.onSurface, fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }

  Widget _whichCardNote() {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cs.surface, border: Border.all(color: cs.outline), borderRadius: BorderRadius.circular(10)),
      child: Text(
        'Which card? Use Neonatal BP for postmenstrual age up to ~46 weeks; this card for '
        'postnatal age 1–12 months; Paediatric BP (AAP 2017) from 1 year.',
        style: TextStyle(fontSize: 11.5, color: cs.onSurface.withValues(alpha: 0.6), height: 1.45),
      ),
    );
  }

  Widget _referenceCard() {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cs.surface, border: Border.all(color: cs.outline), borderRadius: BorderRadius.circular(10)),
      child: Text(
        'Report of the Second Task Force on Blood Pressure Control in Children.\n'
        'Pediatrics. 1987;79(1):1–25. (Infant 1–12 mo norms are a plotted curve,\n'
        'not a numeric table — percentile layer pending digitisation.)\n'
        'Hypotension floor: Pediatric Advanced Life Support (PALS).',
        style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 11, height: 1.5),
      ),
    );
  }

  // ── stepper (matches the other BP calculators) ──
  Widget _stepper({
    required String label,
    required int value,
    required int min,
    required int max,
    required String hint,
    required ValueChanged<int> onChanged,
    TextEditingController? controller,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: cs.onSurface)),
        const SizedBox(height: 6),
        Row(children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            color: value > min ? cs.primary : cs.onSurface.withValues(alpha: 0.3),
            onPressed: value > min ? () {
              final n = value - 1;
              setState(() => onChanged(n));
              controller?.text = n.toString();
            } : null,
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(labelText: hint, isDense: true),
              onChanged: (v) {
                final p = int.tryParse(v);
                if (p != null && p >= min && p <= max) onChanged(p);
                setState(() {});
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: value < max ? cs.primary : cs.onSurface.withValues(alpha: 0.3),
            onPressed: value < max ? () {
              final n = value + 1;
              setState(() => onChanged(n));
              controller?.text = n.toString();
            } : null,
          ),
        ]),
      ],
    );
  }
}
