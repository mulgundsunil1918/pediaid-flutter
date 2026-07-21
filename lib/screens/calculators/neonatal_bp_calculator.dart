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
  // ── Input ──
  int _pma = 34;

  final _pmaCtrl = TextEditingController(text: '34');

  @override
  void dispose() {
    _pmaCtrl.dispose();
    super.dispose();
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

            _buildQuickInputCard(),
            const SizedBox(height: 16),
            _buildQuickRefTable(),
            const SizedBox(height: 12),
            _buildQuickBedsideCard(),
            const SizedBox(height: 12),
            _buildReferenceCard(),
            const SizedBox(height: 24),
          ],
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
              Text('FULL BP REFERENCE — 24 TO 46 WK',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.15,
                      color: Color(0xFFF5A623))),
            ],
          ),
          const SizedBox(height: 6),
          Text('Values shown as 5th / 50th / 95th centile (mmHg)',
              style: TextStyle(
                  fontSize: 10.5,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55))),
          const SizedBox(height: 8),
          _fullReferenceTable(_pma),
        ],
      ),
    );
  }

  // Full Zubrow table (24-46 wk), all three parameters, highlighted at the
  // given PMA. Shared by quick mode and calculator mode.
  Widget _fullReferenceTable(int highlightPma) {
    String trip(List<int> c) => '${c[0]}/${c[1]}/${c[2]}';
    return Table(
      border: TableBorder.all(
          color: Theme.of(context).colorScheme.outline,
          width: 0.5,
          borderRadius: BorderRadius.circular(6)),
      columnWidths: const {
        0: FlexColumnWidth(0.8),
        1: FlexColumnWidth(1.1),
        2: FlexColumnWidth(1.1),
        3: FlexColumnWidth(1.1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
          children: [
            _tc('PMA', isHeader: true),
            _tc('SBP', isHeader: true),
            _tc('DBP', isHeader: true),
            _tc('MAP', isHeader: true),
          ],
        ),
        for (int w = 24; w <= 46; w++)
          TableRow(
            decoration: BoxDecoration(
              color: w == highlightPma
                  ? const Color(0xFFE6F5F3)
                  : (w % 2 == 0
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).cardColor),
            ),
            children: [
              _tc('$w wk',
                  isBold: w == highlightPma,
                  color: w == highlightPma ? const Color(0xFF0d7a6e) : null),
              _tc(trip(_neoData[w]!['S']!),
                  isBold: w == highlightPma,
                  color: w == highlightPma ? const Color(0xFF0d7a6e) : null),
              _tc(trip(_neoData[w]!['D']!),
                  isBold: w == highlightPma,
                  color: w == highlightPma ? const Color(0xFF0d7a6e) : null),
              _tc(trip(_neoData[w]!['M']!),
                  isBold: w == highlightPma,
                  color: w == highlightPma ? const Color(0xFF0d7a6e) : null),
            ],
          ),
      ],
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
