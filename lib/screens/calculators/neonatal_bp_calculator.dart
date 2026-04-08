import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════════
// Zubrow AB et al. J Perinatol. 1995;15(6):470–479.
// 5th, 50th, 95th centiles by PMA (weeks 24–46)
// S = Systolic, D = Diastolic, M = Mean arterial pressure
// ══════════════════════════════════════════════════════════════
const Map<int, Map<String, List<int>>> _neoData = {
  24: {'S': [35, 45, 65], 'D': [18, 28, 45], 'M': [23, 34, 51]},
  25: {'S': [35, 50, 68], 'D': [18, 30, 47], 'M': [24, 36, 53]},
  26: {'S': [38, 52, 70], 'D': [20, 32, 48], 'M': [26, 39, 55]},
  27: {'S': [40, 52, 72], 'D': [20, 32, 50], 'M': [26, 39, 55]},
  28: {'S': [40, 53, 72], 'D': [22, 33, 50], 'M': [28, 40, 57]},
  29: {'S': [42, 56, 74], 'D': [22, 34, 51], 'M': [29, 41, 58]},
  30: {'S': [42, 59, 75], 'D': [22, 35, 52], 'M': [29, 43, 59]},
  31: {'S': [45, 63, 76], 'D': [22, 38, 54], 'M': [29, 46, 61]},
  32: {'S': [45, 63, 80], 'D': [22, 38, 54], 'M': [29, 46, 61]},
  33: {'S': [48, 63, 82], 'D': [28, 40, 54], 'M': [34, 47, 63]},
  34: {'S': [50, 66, 82], 'D': [28, 40, 55], 'M': [35, 49, 64]},
  35: {'S': [53, 68, 83], 'D': [29, 42, 58], 'M': [37, 50, 66]},
  36: {'S': [53, 71, 85], 'D': [29, 43, 58], 'M': [37, 52, 67]},
  37: {'S': [55, 73, 88], 'D': [29, 43, 59], 'M': [37, 52, 68]},
  38: {'S': [57, 74, 88], 'D': [31, 44, 60], 'M': [39, 53, 69]},
  39: {'S': [60, 78, 90], 'D': [31, 47, 60], 'M': [40, 57, 70]},
  40: {'S': [62, 80, 95], 'D': [32, 47, 62], 'M': [42, 58, 73]},
  41: {'S': [62, 81, 96], 'D': [33, 48, 62], 'M': [43, 59, 73]},
  42: {'S': [66, 82, 100], 'D': [33, 50, 62], 'M': [43, 61, 75]},
  43: {'S': [67, 88, 100], 'D': [36, 51, 65], 'M': [46, 63, 77]},
  44: {'S': [69, 89, 102], 'D': [36, 52, 66], 'M': [47, 64, 78]},
  45: {'S': [72, 91, 103], 'D': [38, 55, 68], 'M': [49, 67, 78]},
  46: {'S': [73, 93, 104], 'D': [38, 55, 68], 'M': [49, 67, 78]},
};

class NeonatalBPCalculator extends StatefulWidget {
  const NeonatalBPCalculator({super.key});

  @override
  State<NeonatalBPCalculator> createState() => _NeonatalBPCalculatorState();
}

class _NeonatalBPCalculatorState extends State<NeonatalBPCalculator> {
  // ── Mode ──
  bool _quickMode = true;

  // ── Inputs ──
  int _pma = 34;
  int _sbp = 55;
  int _dbp = 35;
  int _map = 42;

  // ── Text controllers for manual entry ──
  final _pmaCtrl = TextEditingController(text: '34');
  final _sbpCtrl = TextEditingController(text: '55');
  final _dbpCtrl = TextEditingController(text: '35');
  final _mapCtrl = TextEditingController(text: '42');

  // ── Results ──
  bool _calculated = false;
  int _calcSBP = 0, _calcDBP = 0, _calcMAP = 0;
  int _calcPMA = 34;

  // ── Band logic ──
  String _band(int value, List<int> centiles) {
    if (value < centiles[0]) {
      return 'Below 5th centile';
    } else if (value < centiles[1]) {
      return '5th–50th centile';
    } else if (value < centiles[2]) {
      return '50th–95th centile';
    } else {
      return 'Above 95th centile';
    }
  }

  Color _bandColor(String band) {
    if (band == 'Below 5th centile') return const Color(0xFFE53935);
    if (band == 'Above 95th centile') return const Color(0xFFF5A623);
    return const Color(0xFF2DBD8C);
  }

  Color _bandBg(String band) {
    if (band == 'Below 5th centile') return const Color(0xFFFFEBEE);
    if (band == 'Above 95th centile') return const Color(0xFFFFF8E1);
    return const Color(0xFFE8F5E9);
  }

  void _calculate() {
    setState(() {
      _calcSBP = _sbp;
      _calcDBP = _dbp;
      _calcMAP = _map;
      _calcPMA = _pma;
      _calculated = true;
    });
  }

  @override
  void dispose() {
    _pmaCtrl.dispose();
    _sbpCtrl.dispose();
    _dbpCtrl.dispose();
    _mapCtrl.dispose();
    super.dispose();
  }

  void _autoMAP() {
    setState(() {
      _map = (_dbp + (_sbp - _dbp) / 3).round();
      _mapCtrl.text = _map.toString();
    });
  }

  // ── Stepper ──
  Widget _stepper({
    required String label,
    required int value,
    required int min,
    required int max,
    required String hint,
    required ValueChanged<int> onChanged,
    TextEditingController? controller,
  }) {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface)),
          const SizedBox(height: 6),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: value > min ? cs.primary : cs.onSurface.withValues(alpha: 0.3),
                onPressed: value > min ? () {
                  final newVal = value - 1;
                  onChanged(newVal);
                  controller?.text = newVal.toString();
                } : null,
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: hint,
                    isDense: true,
                  ),
                  onChanged: (v) {
                    final parsed = int.tryParse(v);
                    if (parsed != null && parsed >= min && parsed <= max) {
                      onChanged(parsed);
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: value < max ? cs.primary : cs.onSurface.withValues(alpha: 0.3),
                onPressed: value < max ? () {
                  final newVal = value + 1;
                  onChanged(newVal);
                  controller?.text = newVal.toString();
                } : null,
              ),
            ],
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Neonatal BP Calculator',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary)),
            Text('Zubrow et al. 1995 · 24–46 weeks PMA',
                style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // NICU badge + title
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F5F3),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFB3DDD9)),
                  ),
                  child: const Text('NICU TOOL',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.15,
                          color: Color(0xFF0d7a6e))),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Neonatal Blood Pressure Centiles',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface)),
            Text('By postmenstrual age (PMA) — Zubrow et al. 1995',
                style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
            const SizedBox(height: 16),

            // Mode toggle
            _buildModeToggle(),
            const SizedBox(height: 16),

            if (_quickMode) ...[
              _buildQuickInputCard(),
              const SizedBox(height: 16),
              _buildQuickRefTable(),
              const SizedBox(height: 12),
              _buildQuickBedsideCard(),
              const SizedBox(height: 12),
              _buildReferenceCard(),
            ] else ...[
              _buildInputCard(),
              if (_calculated) ...[
                const SizedBox(height: 16),
                _buildRefTable(),
                const SizedBox(height: 12),
                _buildResultBoxes(),
                const SizedBox(height: 12),
                _buildInterpCard(),
                const SizedBox(height: 12),
                _buildClinicalNotes(),
                const SizedBox(height: 12),
                _buildBedsideCard(),
                const SizedBox(height: 12),
                _buildReferenceCard(),
              ],
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildModeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(child: _modeBtn('Quick Reference', true)),
          Expanded(child: _modeBtn('Full Assessment', false)),
        ],
      ),
    );
  }

  Widget _modeBtn(String label, bool isQuick) {
    final active = _quickMode == isQuick;
    return GestureDetector(
      onTap: () => setState(() => _quickMode = isQuick),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? Theme.of(context).colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  // ── Quick Reference mode ──────────────────────────────────────────────────

  Widget _buildQuickInputCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter Postmenstrual Age',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 4),
            Text(
                'Reference BP centiles will display instantly.',
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
            const SizedBox(height: 16),
            _stepper(
              label: 'Postmenstrual Age (PMA)',
              value: _pma,
              min: 24,
              max: 46,
              hint: '24–46 weeks PMA',
              controller: _pmaCtrl,
              onChanged: (v) => setState(() => _pma = v),
            ),
            const SizedBox(height: 4),
            Text('PMA = Gestational age + Postnatal age',
                style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickRefTable() {
    final d = _neoData[_pma]!;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reference BP Values at $_pma weeks PMA',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 10),
            Table(
              border: TableBorder.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 0.5,
                  borderRadius: BorderRadius.circular(8)),
              columnWidths: const {
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                  children: [
                    _tc('Parameter', isHeader: true),
                    _tc('5th %ile', isHeader: true),
                    _tc('50th %ile', isHeader: true),
                    _tc('95th %ile', isHeader: true),
                  ],
                ),
                _quickRow('Systolic BP', d['S']!),
                _quickRow('Diastolic BP', d['D']!),
                _quickRow('Mean BP', d['M']!),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F5F3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
                  children: [
                    TextSpan(
                      text: 'Rule of thumb:  ',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                    ),
                    const TextSpan(
                      text: 'MAP ≥ gestational age in weeks',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0d7a6e)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _quickRow(String label, List<int> c) {
    return TableRow(
      children: [
        _tc(label),
        _tc('${c[0]}'),
        _tc('${c[1]}', isBold: true, color: Theme.of(context).colorScheme.primary),
        _tc('${c[2]}'),
      ],
    );
  }

  Widget _buildQuickBedsideCard() {
    final start = (_pma - 2).clamp(24, 46);
    final end = (_pma + 2).clamp(24, 46);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF5A623), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline, color: Color(0xFFF5A623), size: 18),
              SizedBox(width: 8),
              Text('NEARBY WEEKS REFERENCE',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.15,
                      color: Color(0xFFF5A623))),
            ],
          ),
          const SizedBox(height: 10),
          Table(
            border: TableBorder.all(
                color: Theme.of(context).colorScheme.outline,
                width: 0.5,
                borderRadius: BorderRadius.circular(6)),
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                children: [
                  _tc('PMA', isHeader: true),
                  _tc('SBP 5th', isHeader: true),
                  _tc('SBP 50th', isHeader: true),
                  _tc('SBP 95th', isHeader: true),
                ],
              ),
              for (int w = start; w <= end; w++)
                TableRow(
                  decoration: BoxDecoration(
                    color: w == _pma
                        ? const Color(0xFFE6F5F3)
                        : (w % 2 == 0
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context).cardColor),
                  ),
                  children: [
                    _tc('$w wk',
                        isBold: w == _pma,
                        color: w == _pma ? const Color(0xFF0d7a6e) : null),
                    _tc('${_neoData[w]!['S']![0]}',
                        isBold: w == _pma,
                        color: w == _pma ? const Color(0xFF0d7a6e) : null),
                    _tc('${_neoData[w]!['S']![1]}',
                        isBold: w == _pma,
                        color: w == _pma ? const Color(0xFF0d7a6e) : null),
                    _tc('${_neoData[w]!['S']![2]}',
                        isBold: w == _pma,
                        color: w == _pma ? const Color(0xFF0d7a6e) : null),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient Data',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 16),

            _stepper(
              label: 'Postmenstrual Age (weeks)',
              value: _pma,
              min: 24,
              max: 46,
              hint: '24–46 weeks PMA',
              controller: _pmaCtrl,
              onChanged: (v) => setState(() => _pma = v),
            ),
            const SizedBox(height: 4),
            Text('PMA = Gestational age + Postnatal age',
                style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
            const SizedBox(height: 16),

            _stepper(
              label: 'Systolic BP (mmHg)',
              value: _sbp,
              min: 20,
              max: 150,
              hint: 'Enter measured SBP',
              controller: _sbpCtrl,
              onChanged: (v) => setState(() => _sbp = v),
            ),
            const SizedBox(height: 16),

            _stepper(
              label: 'Diastolic BP (mmHg)',
              value: _dbp,
              min: 10,
              max: 120,
              hint: 'Enter measured DBP',
              controller: _dbpCtrl,
              onChanged: (v) => setState(() => _dbp = v),
            ),
            const SizedBox(height: 16),

            _stepper(
              label: 'Mean Arterial Pressure (mmHg)',
              value: _map,
              min: 10,
              max: 120,
              hint: 'Enter or auto-calculate',
              controller: _mapCtrl,
              onChanged: (v) => setState(() => _map = v),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Auto-calculated: MAP = DBP + (SBP–DBP)/3',
                    style:
                        TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
                const Spacer(),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0d7a6e),
                    side: const BorderSide(color: Color(0xFF0d7a6e)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _autoMAP,
                  child: const Text('Auto-calculate MAP',
                      style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _calculate,
                child: const Text('Assess BP',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRefTable() {
    final d = _neoData[_calcPMA]!;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reference Values at $_calcPMA weeks PMA',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 10),
            Table(
              border: TableBorder.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 0.5,
                  borderRadius: BorderRadius.circular(8)),
              columnWidths: const {
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                  children: [
                    _tc('Parameter', isHeader: true),
                    _tc('5th %ile', isHeader: true),
                    _tc('50th %ile', isHeader: true),
                    _tc('95th %ile', isHeader: true),
                  ],
                ),
                _refRow('Systolic BP', d['S']!, _calcSBP),
                _refRow('Diastolic BP', d['D']!, _calcDBP),
                _refRow('Mean BP', d['M']!, _calcMAP),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _refRow(String label, List<int> c, int entered) {
    Color colOf(int idx) {
      if (entered < c[0]) {
        return idx == 0 ? const Color(0xFFFFCDD2) : Theme.of(context).cardColor;
      } else if (entered >= c[2]) {
        return idx == 2 ? const Color(0xFFFFF9C4) : Theme.of(context).cardColor;
      } else if (entered < c[1]) {
        return idx == 0 ? const Color(0xFFE8F5E9) : Theme.of(context).cardColor;
      } else {
        return idx == 1 ? const Color(0xFFE8F5E9) : Theme.of(context).cardColor;
      }
    }

    return TableRow(
      children: [
        _tc(label),
        Container(color: colOf(0), child: _tc('${c[0]}')),
        Container(color: colOf(1), child: _tc('${c[1]}')),
        Container(color: colOf(2), child: _tc('${c[2]}')),
      ],
    );
  }

  Widget _buildResultBoxes() {
    final d = _neoData[_calcPMA]!;
    final sbpBand = _band(_calcSBP, d['S']!);
    final dbpBand = _band(_calcDBP, d['D']!);
    final mapBand = _band(_calcMAP, d['M']!);
    return Row(
      children: [
        Expanded(child: _resultBox('SBP', _calcSBP, sbpBand)),
        const SizedBox(width: 8),
        Expanded(child: _resultBox('DBP', _calcDBP, dbpBand)),
        const SizedBox(width: 8),
        Expanded(child: _resultBox('MAP', _calcMAP, mapBand)),
      ],
    );
  }

  Widget _resultBox(String label, int value, String band) {
    final c = _bandColor(band);
    final bg = _bandBg(band);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: c.withValues(alpha: 0.8))),
          const SizedBox(height: 4),
          Text('$value',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: c)),
          Text('mmHg',
              style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
          const SizedBox(height: 6),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: c.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              band.replaceAll(' centile', ''),
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: c),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterpCard() {
    final d = _neoData[_calcPMA]!;
    final sbpBand = _band(_calcSBP, d['S']!);
    final dbpBand = _band(_calcDBP, d['D']!);
    final mapBand = _band(_calcMAP, d['M']!);

    final hasLow = sbpBand == 'Below 5th centile' ||
        dbpBand == 'Below 5th centile' ||
        mapBand == 'Below 5th centile';
    final hasHigh = sbpBand == 'Above 95th centile' ||
        dbpBand == 'Above 95th centile' ||
        mapBand == 'Above 95th centile';

    String overall;
    if (hasLow) {
      overall = 'Hypotension concern';
    } else if (hasHigh) {
      overall = 'Hypertension concern';
    } else {
      overall = 'Normal range';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0d7a6e).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFF0d7a6e).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Interpretation',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0d7a6e))),
          const SizedBox(height: 10),
          _irow('PMA', '$_calcPMA weeks'),
          _irow('Systolic BP', '$_calcSBP mmHg  →  $sbpBand'),
          _irow('Diastolic BP', '$_calcDBP mmHg  →  $dbpBand'),
          _irow('Mean BP', '$_calcMAP mmHg  →  $mapBand'),
          const Divider(height: 16),
          Row(
            children: [
              Text('Overall:  ',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface)),
              Text(overall,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: hasLow
                          ? const Color(0xFFE53935)
                          : hasHigh
                              ? const Color(0xFFF5A623)
                              : const Color(0xFF2DBD8C))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _irow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface)),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicalNotes() {
    final d = _neoData[_calcPMA]!;
    final hasLow = _calcSBP < d['S']![0] ||
        _calcDBP < d['D']![0] ||
        _calcMAP < d['M']![0];
    final hasHigh = _calcSBP >= d['S']![2] ||
        _calcDBP >= d['D']![2] ||
        _calcMAP >= d['M']![2];

    final Color bg;
    final Color border;
    final String text;
    final IconData icon;

    if (hasLow) {
      bg = const Color(0xFFFFEBEE);
      border = const Color(0xFFE53935);
      icon = Icons.warning_amber_rounded;
      text = '⚠️ One or more BP values below 5th centile for PMA.\n'
          'Consider: fluid status, cardiac function, sepsis screen.\n'
          'NICU protocol for hypotension management.';
    } else if (hasHigh) {
      bg = const Color(0xFFFFF8E1);
      border = const Color(0xFFF5A623);
      icon = Icons.warning_amber_outlined;
      text = '⚠️ One or more BP values above 95th centile for PMA.\n'
          'Consider: pain/agitation, fluid overload, renal causes.\n'
          'Confirm with repeat measurement.';
    } else {
      bg = const Color(0xFFE8F5E9);
      border = const Color(0xFF2DBD8C);
      icon = Icons.check_circle_outline;
      text = '✅ BP values within normal centile range for PMA.';
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: border, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildBedsideCard() {
    final start = (_calcPMA - 2).clamp(24, 46);
    final end = (_calcPMA + 2).clamp(24, 46);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF5A623), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline, color: Color(0xFFF5A623), size: 18),
              SizedBox(width: 8),
              Text('BEDSIDE QUICK REFERENCE',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.15,
                      color: Color(0xFFF5A623))),
            ],
          ),
          const SizedBox(height: 10),
          Text('SBP centiles — PMA $start–$end weeks:',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: 6),
          Table(
            border: TableBorder.all(
                color: Theme.of(context).colorScheme.outline,
                width: 0.5,
                borderRadius: BorderRadius.circular(6)),
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                children: [
                  _tc('PMA', isHeader: true),
                  _tc('SBP 5th', isHeader: true),
                  _tc('SBP 50th', isHeader: true),
                  _tc('SBP 95th', isHeader: true),
                ],
              ),
              for (int w = start; w <= end; w++)
                TableRow(
                  decoration: BoxDecoration(
                    color: w == _calcPMA
                        ? const Color(0xFFE6F5F3)
                        : (w % 2 == 0
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context).cardColor),
                  ),
                  children: [
                    _tc('$w wk',
                        isBold: w == _calcPMA,
                        color: w == _calcPMA
                            ? const Color(0xFF0d7a6e)
                            : null),
                    _tc('${_neoData[w]!['S']![0]}',
                        isBold: w == _calcPMA,
                        color: w == _calcPMA
                            ? const Color(0xFF0d7a6e)
                            : null),
                    _tc('${_neoData[w]!['S']![1]}',
                        isBold: w == _calcPMA,
                        color: w == _calcPMA
                            ? const Color(0xFF0d7a6e)
                            : null),
                    _tc('${_neoData[w]!['S']![2]}',
                        isBold: w == _calcPMA,
                        color: w == _calcPMA
                            ? const Color(0xFF0d7a6e)
                            : null),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: RichText(
              text: TextSpan(
                style:
                    TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
                children: [
                  TextSpan(
                    text: 'Rule of thumb:  ',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                  ),
                  TextSpan(
                    text:
                        'MAP ≥ gestational age in weeks',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  TextSpan(
                    text:
                        '\ne.g. 28 wk GA → MAP ≥ 28 mmHg',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📚  Reference',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 8),
          Text(
            'Zubrow AB, Hulman S, Kushner H, Falkner B.\n'
            'Determinants of blood pressure in infants admitted to neonatal\n'
            'intensive care units: a prospective multicenter study.\n'
            'Journal of Perinatology. 1995;15(6):470–479.',
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Data represents 5th, 50th, and 95th centiles by postmenstrual age.\n'
            'PMA = Gestational Age + Postnatal Age in weeks.\n'
            'Range covered: 24–46 weeks PMA.',
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Table cell ──
  Widget _tc(String text,
      {bool isHeader = false, bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 10 : 11,
          fontWeight:
              isHeader || isBold ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.white : (color ?? Theme.of(context).colorScheme.onSurface),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
