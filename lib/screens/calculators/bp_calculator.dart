import 'package:flutter/material.dart';
import 'bp_aap2017_data.dart';

// ══════════════════════════════════════════════════════════════════════════
// Pediatric BP — AAP 2017 Clinical Practice Guideline (Flynn et al,
// Pediatrics 2017;140(3):e20171904). Data lives in bp_aap2017_data.dart,
// generated directly from the source tables.
// ══════════════════════════════════════════════════════════════════════════

class BPChartsScreen extends StatelessWidget {
  const BPChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Blood Pressure Charts',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Text('Select Age Group',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: cs.onSurface)),
            const SizedBox(height: 4),
            Text('Age-specific BP norms using validated reference tables',
                style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.5))),
            const SizedBox(height: 16),
            _BPHubCard(
              icon: Icons.child_care,
              title: 'Infants',
              subtitle: 'Zubrow et al. reference\nNeonates & infants < 2 years',
              color: const Color(0xFF4F8FC0),
              comingSoon: true,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _BPHubCard(
              icon: Icons.monitor_heart,
              title: 'Children & Adolescents',
              subtitle: 'AAP 2017 Guideline · Ages 1–17 years',
              color: const Color(0xFF26648E),
              comingSoon: false,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const BPCalculator())),
            ),
          ],
        ),
      ),
    );
  }
}

class _BPHubCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool comingSoon;
  final VoidCallback onTap;

  const _BPHubCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.comingSoon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: comingSoon ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: comingSoon ? Colors.grey.withValues(alpha: 0.1) : color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: comingSoon ? Colors.grey : color, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(title,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: comingSoon ? Colors.grey : Theme.of(context).colorScheme.onSurface)),
                        if (comingSoon) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Coming Soon',
                                style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 12,
                            color: comingSoon
                                ? Colors.grey.withValues(alpha: 0.6)
                                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            height: 1.4)),
                  ],
                ),
              ),
              if (!comingSoon) Icon(Icons.chevron_right, color: color.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// BP CALCULATOR — Children & Adolescents (AAP 2017)
// ══════════════════════════════════════════════════════════════════════════

class BPCalculator extends StatefulWidget {
  const BPCalculator({super.key});

  @override
  State<BPCalculator> createState() => _BPCalculatorState();
}

class _BPCalculatorState extends State<BPCalculator> {
  // ── Inputs ──
  bool _isBoy = true;
  int _age = 8;
  int _sbp = 100;
  int _dbp = 65;
  double _heightCm = 128.0;

  final _ageCtrl = TextEditingController(text: '8');
  final _sbpCtrl = TextEditingController(text: '100');
  final _dbpCtrl = TextEditingController(text: '65');
  final _heightCtrl = TextEditingController(text: '128');

  // Snapshot of the inputs at the moment "Assess" was pressed — results read
  // these, never the live fields, so an empty/edited field can't retroactively
  // change a displayed result.
  bool _calculated = false;
  bool _calcIsBoy = true;
  int _calcAge = 8;
  double _calcHeightCm = 128.0;
  int _enteredSBP = 0, _enteredDBP = 0;

  @override
  void dispose() {
    _ageCtrl.dispose();
    _sbpCtrl.dispose();
    _dbpCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  // ── Input validity (parsed from the text fields so blanks are detected) ──
  int? get _ageInput {
    final v = int.tryParse(_ageCtrl.text.trim());
    return (v != null && v >= 1 && v <= 17) ? v : null;
  }

  double? get _heightInput {
    final v = double.tryParse(_heightCtrl.text.trim());
    return (v != null && v >= 50 && v <= 200) ? v : null;
  }

  int? get _sbpInput {
    final v = int.tryParse(_sbpCtrl.text.trim());
    return (v != null && v >= 50 && v <= 220) ? v : null;
  }

  int? get _dbpInput {
    final v = int.tryParse(_dbpCtrl.text.trim());
    return (v != null && v >= 30 && v <= 140) ? v : null;
  }

  bool get _allValid =>
      _ageInput != null && _heightInput != null && _sbpInput != null && _dbpInput != null;

  void _calculate() {
    if (!_allValid) return;
    setState(() {
      _calcIsBoy = _isBoy;
      _calcAge = _ageInput!;
      _calcHeightCm = _heightInput!;
      _enteredSBP = _sbpInput!;
      _enteredDBP = _dbpInput!;
      _calculated = true;
    });
  }

  // ── Height → column ──────────────────────────────────────────────────────
  // The 2017 tables print the actual measured height (cm) for each of the 7
  // height-percentile columns, so we pick the column whose tabulated height is
  // closest to the child's measured height (the "or Measured Height" feature).
  AgeBP _bpData(bool isBoy, int age) => (isBoy ? bpBoys2017 : bpGirls2017)[age]!;

  int _colFor(AgeBP bp, double h) {
    var best = 0;
    var bestDiff = (bp.heightCm[0] - h).abs();
    for (var i = 1; i < bp.heightCm.length; i++) {
      final d = (bp.heightCm[i] - h).abs();
      if (d < bestDiff) {
        bestDiff = d;
        best = i;
      }
    }
    return best;
  }

  // Results read the snapshot; the input-card preview reads live values.
  AgeBP get _bp => _bpData(_calcIsBoy, _calcAge);
  int _heightColIndex() => _colFor(_bp, _calcHeightCm);

  static const _htLabels = ['5th', '10th', '25th', '50th', '75th', '90th', '95th'];

  // ── Classification (AAP 2017 Table 3) ────────────────────────────────────
  // 0 Normal · 1 Elevated · 2 Stage 1 HTN · 3 Stage 2 HTN
  int _percentileCat(int val, int p90, int p95) {
    if (val >= p95 + 12) return 3;
    if (val >= p95) return 2;
    if (val >= p90) return 1;
    return 0;
  }

  // Adult / adolescent absolute thresholds (also the "whichever is lower"
  // floor for children < 13).
  int _absoluteCat(int sbp, int dbp) {
    if (sbp >= 140 || dbp >= 90) return 3;
    if (sbp >= 130 || dbp >= 80) return 2;
    if (sbp >= 120) return 1; // elevated is systolic 120–129 with DBP < 80
    return 0;
  }

  int _categoryIndex() {
    final col = _heightColIndex();
    final bp = _bp;
    final sCat = _percentileCat(_enteredSBP, bp.sbp90[col], bp.sbp95[col]);
    final dCat = _percentileCat(_enteredDBP, bp.dbp90[col], bp.dbp95[col]);
    final pctCat = sCat > dCat ? sCat : dCat;
    final absCat = _absoluteCat(_enteredSBP, _enteredDBP);
    // ≥13 yr: adolescents are staged by the adult absolute thresholds only.
    if (_calcAge >= 13) return absCat;
    return pctCat > absCat ? pctCat : absCat;
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('BP Calculator', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Children · AAP 2017 Guideline', style: TextStyle(fontSize: 11)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputCard(),
            if (_calculated) ...[
              const SizedBox(height: 16),
              _buildCategoryBanner(),
              const SizedBox(height: 12),
              _buildBPResultCards(),
              const SizedBox(height: 12),
              _buildThresholdCard(),
              const SizedBox(height: 12),
              _buildHypotensionInfo(),
              const SizedBox(height: 16),
              _buildAdditionalInfo(),
              const SizedBox(height: 12),
              _buildReference(),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Input card ──
  Widget _buildInputCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(builder: (context) => Text('Blood Pressure Assessment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary))),
            const SizedBox(height: 16),
            Builder(builder: (context) => Text('Sex',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface))),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _genderBtn('👦  Boy', true)),
                Expanded(child: _genderBtn('👧  Girl', false)),
              ],
            ),
            const SizedBox(height: 16),
            _stepper(
              label: 'Age (years)',
              value: _age,
              min: 1,
              max: 17,
              hint: '1–17 years',
              controller: _ageCtrl,
              onChanged: (v) => setState(() => _age = v),
            ),
            const SizedBox(height: 16),
            _sectionLabel('Height (cm)'),
            const SizedBox(height: 6),
            Builder(builder: (context) {
              final cs = Theme.of(context).colorScheme;
              return Row(children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _heightCm > 50 ? () => setState(() {
                    _heightCm = (_heightCm - 1).clamp(50.0, 200.0);
                    _heightCtrl.text = _heightCm.toStringAsFixed(0);
                  }) : null,
                  color: _heightCm > 50 ? cs.primary : cs.onSurface.withValues(alpha: 0.3),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _heightCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(labelText: 'Height (cm)', suffixText: 'cm', isDense: true),
                    onChanged: (v) => setState(() {
                      _heightCm = (double.tryParse(v) ?? _heightCm).clamp(50.0, 200.0);
                    }),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _heightCm < 200 ? () => setState(() {
                    _heightCm = (_heightCm + 1).clamp(50.0, 200.0);
                    _heightCtrl.text = _heightCm.toStringAsFixed(0);
                  }) : null,
                  color: _heightCm < 200 ? cs.primary : cs.onSurface.withValues(alpha: 0.3),
                ),
              ]);
            }),
            const SizedBox(height: 4),
            Builder(builder: (context) {
              final age = _ageInput, h = _heightInput;
              if (age == null || h == null) {
                return Text(
                  h == null && _heightCtrl.text.trim().isEmpty
                      ? 'Enter a height to pick the reference column'
                      : 'Enter a valid age (1–17) and height (50–200 cm)',
                  style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
                );
              }
              final bp = _bpData(_isBoy, age);
              final col = _colFor(bp, h);
              return Text(
                'Nearest height column for age $age: ~${_htLabels[col]} percentile '
                '(${bp.heightCm[col].toStringAsFixed(0)} cm)',
                style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.primary),
              );
            }),
            const SizedBox(height: 16),
            _stepper(
              label: 'Systolic BP (mmHg)',
              value: _sbp, min: 50, max: 220, hint: 'e.g. 112',
              controller: _sbpCtrl, onChanged: (v) => setState(() => _sbp = v),
            ),
            const SizedBox(height: 16),
            _stepper(
              label: 'Diastolic BP (mmHg)',
              value: _dbp, min: 30, max: 140, hint: 'e.g. 72',
              controller: _dbpCtrl, onChanged: (v) => setState(() => _dbp = v),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _allValid ? _calculate : null,
                child: const Text('Assess Blood Pressure',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            if (!_allValid) ...[
              const SizedBox(height: 8),
              Builder(builder: (context) => Text(
                'Enter sex, age, height, systolic and diastolic BP to assess.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11.5, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55)),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _genderBtn(String label, bool isBoy) {
    final active = _isBoy == isBoy;
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
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
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(color: active ? Colors.white : cs.primary, fontWeight: FontWeight.w600, fontSize: 14)),
        ),
      );
    });
  }

  // ── Category banner ──
  Widget _buildCategoryBanner() {
    const cats = [
      ('Normal BP', Color(0xFF2DBD8C), 'Below the 90th percentile (and < 120/80).'),
      ('Elevated BP', Color(0xFFD4820A), '90th–<95th percentile, or ≥120/<80 mmHg. Lifestyle counselling; recheck in 6 months.'),
      ('Stage 1 Hypertension', Color(0xFFF97316), '95th percentile to <95th + 12 mmHg, or 130/80–139/89. Recheck in 1–2 weeks.'),
      ('Stage 2 Hypertension', Color(0xFFE53935), '≥95th + 12 mmHg, or ≥140/90. Evaluate/refer within 1 week.'),
    ];
    final (label, color, desc) = cats[_categoryIndex()];
    final basis = _calcAge >= 13
        ? 'Staged by adult thresholds (≥13 yr).'
        : 'Staged by percentile for age/sex/height, or absolute cutoff — whichever is lower.';
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          border: Border.all(color: color.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AAP 2017 CLASSIFICATION',
                style: TextStyle(color: cs.onSurface.withValues(alpha: 0.5), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 21, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(desc, style: TextStyle(color: cs.onSurface.withValues(alpha: 0.78), fontSize: 12.5, height: 1.4)),
            const SizedBox(height: 6),
            Text(basis, style: TextStyle(color: cs.onSurface.withValues(alpha: 0.5), fontSize: 11, fontStyle: FontStyle.italic)),
          ],
        ),
      );
    });
  }

  // ── SBP / DBP boxes ──
  Widget _buildBPResultCards() {
    final col = _heightColIndex();
    final bp = _bp;
    final sbpText = _centileText(_enteredSBP, bp.sbp90[col], bp.sbp95[col]);
    final dbpText = _centileText(_enteredDBP, bp.dbp90[col], bp.dbp95[col]);
    return Row(
      children: [
        Expanded(child: _bpBox('Systolic', '$_enteredSBP mmHg', sbpText, _boxColor(sbpText))),
        const SizedBox(width: 12),
        Expanded(child: _bpBox('Diastolic', '$_enteredDBP mmHg', dbpText, _boxColor(dbpText))),
      ],
    );
  }

  String _centileText(int v, int p90, int p95) {
    if (v >= p95 + 12) return '≥95th + 12 mmHg';
    if (v >= p95) return '95th–(95th+12)';
    if (v >= p90) return '90th–95th';
    return '<90th centile';
  }

  Color _boxColor(String t) {
    if (t.contains('+ 12')) return const Color(0xFFE53935);
    if (t.contains('95th–(')) return const Color(0xFFF97316);
    if (t.contains('90th–95th')) return const Color(0xFFD4820A);
    return const Color(0xFF2DBD8C);
  }

  Widget _bpBox(String label, String value, String centile, Color color) {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          border: Border(left: BorderSide(color: color, width: 4)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(color: cs.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(centile, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    });
  }

  // ── Thresholds used ──
  Widget _buildThresholdCard() {
    final col = _heightColIndex();
    final bp = _bp;
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      TableRow row(String label, int sbp, int dbp, [bool bold = false]) => TableRow(children: [
            _cell(label, bold: bold, color: cs.onSurface),
            _cell('$sbp', bold: bold, color: cs.onSurface),
            _cell('$dbp', bold: bold, color: cs.onSurface),
          ]);
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: cs.surface, border: Border.all(color: cs.outline), borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thresholds for age $_calcAge ${_calcIsBoy ? 'boy' : 'girl'}, ~${_htLabels[col]} height',
                style: TextStyle(color: cs.onSurface, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Table(
              border: TableBorder.all(color: cs.outline, width: 0.5, borderRadius: BorderRadius.circular(6)),
              columnWidths: const {0: FlexColumnWidth(1.7), 1: FlexColumnWidth(1), 2: FlexColumnWidth(1)},
              children: [
                TableRow(
                  decoration: BoxDecoration(color: cs.primary),
                  children: [_cell('Percentile', header: true), _cell('SBP', header: true), _cell('DBP', header: true)],
                ),
                row('50th', bp.sbp50[col], bp.dbp50[col]),
                row('90th (Elevated)', bp.sbp90[col], bp.dbp90[col]),
                row('95th (Stage 1)', bp.sbp95[col], bp.dbp95[col]),
                row('95th + 12 (Stage 2)', bp.sbp95[col] + 12, bp.dbp95[col] + 12, true),
              ],
            ),
          ],
        ),
      );
    });
  }

  // ── Hypotension (PALS) ──
  Widget _buildHypotensionInfo() {
    final clinicalMin = _calcAge <= 10 ? 70 + (2 * _calcAge) : 90;
    final isHypo = _enteredSBP < clinicalMin;
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      const amber = Color(0xFFD4820A);
      const red = Color(0xFFE53935);
      return Column(children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: amber.withValues(alpha: 0.08), border: Border.all(color: amber.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hypotension Reference (PALS)', style: TextStyle(color: amber, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('Minimum acceptable SBP for age $_calcAge: $clinicalMin mmHg',
                  style: TextStyle(color: cs.onSurface, fontSize: 12)),
              const SizedBox(height: 4),
              Text(_calcAge <= 10 ? '1–10 yr: 70 + (2 × age)' : '> 10 yr: fixed 90 mmHg',
                  style: TextStyle(color: cs.onSurface.withValues(alpha: 0.7), fontSize: 11)),
            ],
          ),
        ),
        if (isHypo) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: red.withValues(alpha: 0.1), border: Border.all(color: red.withValues(alpha: 0.5)), borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              const Icon(Icons.warning_rounded, color: red, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text('SBP below the PALS minimum ($clinicalMin mmHg) — assess for hypotension',
                  style: const TextStyle(color: red, fontSize: 13, fontWeight: FontWeight.w600))),
            ]),
          ),
        ],
      ]);
    });
  }

  // ── Additional information (collapsed by default) ──
  Widget _buildAdditionalInfo() {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ADDITIONAL INFORMATION',
              style: TextStyle(color: cs.onSurface.withValues(alpha: 0.5), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
          const SizedBox(height: 8),
          _expandable('BP categories & staging (Table 3)', Icons.category_outlined, _table3Content()),
          _expandable('Full BP table for age $_calcAge (Table 4/5)', Icons.table_chart_outlined, _fullAgeTable()),
          _expandable('Simplified screening values (Table 6)', Icons.speed_outlined, _table6Content()),
          _expandable('Evaluation & management (Table 11)', Icons.assignment_outlined, _table11Content()),
          _expandable('Initial workup (Table 10)', Icons.science_outlined, _table10Content()),
          _expandable('DASH diet recommendations (Table 16)', Icons.restaurant_outlined, _table16Content()),
        ],
      );
    });
  }

  Widget _expandable(String title, IconData icon, Widget child) {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: cs.outline)),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 14),
            childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            leading: Icon(icon, size: 20, color: cs.primary),
            title: Text(title, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: cs.onSurface)),
            children: [child],
          ),
        ),
      );
    });
  }

  // ── Table content builders ──
  Widget _table3Content() {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      Widget block(String heading, List<String> rows) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(heading, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: cs.primary)),
              const SizedBox(height: 4),
              ...rows.map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(r, style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.8), height: 1.35)),
                  )),
            ],
          );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          block('Children aged 1–13 y', [
            'Normal: <90th percentile',
            'Elevated: ≥90th to <95th, or 120/80 to <95th (whichever is lower)',
            'Stage 1 HTN: ≥95th to <95th + 12 mmHg, or 130/80–139/89 (whichever lower)',
            'Stage 2 HTN: ≥95th + 12 mmHg, or ≥140/90 (whichever lower)',
          ]),
          const SizedBox(height: 12),
          block('Children aged ≥13 y', [
            'Normal: <120/<80 mmHg',
            'Elevated: 120/<80 to 129/<80 mmHg',
            'Stage 1 HTN: 130/80 to 139/89 mmHg',
            'Stage 2 HTN: ≥140/90 mmHg',
          ]),
        ],
      );
    });
  }

  Widget _fullAgeTable() {
    final col = _heightColIndex();
    final bp = _bp;
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      Widget cell(String t, {bool header = false, bool hi = false}) => Container(
            color: hi ? const Color(0xFFE6F5F3) : null,
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
            child: Text(t,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: header ? 9.5 : 10.5, fontWeight: header || hi ? FontWeight.bold : FontWeight.normal, color: header ? Colors.white : (hi ? const Color(0xFF0d7a6e) : cs.onSurface))),
          );
      List<Widget> bpRow(String label, List<int> sbp, List<int> dbp, {bool plus12 = false}) {
        final s = plus12 ? sbp.map((e) => e + 12).toList() : sbp;
        final d = plus12 ? dbp.map((e) => e + 12).toList() : dbp;
        return [
          cell(label),
          for (var i = 0; i < 7; i++) cell('${s[i]}/${d[i]}', hi: i == col),
        ];
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SBP/DBP (mmHg) by height percentile — age $_calcAge ${_calcIsBoy ? 'boys' : 'girls'}',
              style: TextStyle(fontSize: 11, color: cs.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              defaultColumnWidth: const FixedColumnWidth(52),
              columnWidths: const {0: FixedColumnWidth(46)},
              border: TableBorder.all(color: cs.outline, width: 0.4),
              children: [
                TableRow(decoration: BoxDecoration(color: cs.primary), children: [
                  cell('%ile', header: true),
                  ..._htLabels.map((l) => cell(l, header: true)),
                ]),
                TableRow(children: bpRow('50th', bp.sbp50, bp.dbp50)),
                TableRow(children: bpRow('90th', bp.sbp90, bp.dbp90)),
                TableRow(children: bpRow('95th', bp.sbp95, bp.dbp95)),
                TableRow(children: bpRow('95+12', bp.sbp95, bp.dbp95, plus12: true)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text('Highlighted column = nearest to entered height (${_calcHeightCm.toStringAsFixed(0)} cm).',
              style: TextStyle(fontSize: 10.5, color: cs.onSurface.withValues(alpha: 0.5))),
        ],
      );
    });
  }

  Widget _table6Content() {
    final s = bpScreen2017[_calcAge >= 13 ? 13 : _calcAge]!;
    final sbp = _calcIsBoy ? s[0] : s[2];
    final dbp = _calcIsBoy ? s[1] : s[3];
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('A quick screen: if BP is at or above this value, do the full-table lookup above.',
              style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.75), height: 1.35)),
          const SizedBox(height: 8),
          Text('Age ${_calcAge >= 13 ? '≥13' : '$_calcAge'} ${_calcIsBoy ? 'boy' : 'girl'}: screen at $sbp/$dbp mmHg',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: cs.primary)),
        ],
      );
    });
  }

  Widget _table11Content() {
    return _bulletBlock({
      'Normal': ['Recheck at next well-child visit (annual).', 'Lifestyle & nutrition counselling.'],
      'Elevated BP': [
        'Lifestyle counselling; recheck in 6 months.',
        'Still elevated at 6 mo → check upper & lower limb BP, recheck in 6 mo.',
        'Still elevated at 12 mo → ABPM, diagnostic evaluation, consider referral.',
      ],
      'Stage 1 HTN': [
        'Lifestyle counselling; recheck in 1–2 weeks.',
        'Persists → upper & lower limb BP, recheck in 3 months.',
        'Third visit → ABPM, diagnostic evaluation, start treatment, consider referral.',
      ],
      'Stage 2 HTN': [
        'Upper & lower limb BP at first visit; evaluate/refer to specialty care within 1 week.',
        'ABPM, diagnostic evaluation, initiate treatment, referral.',
        'If symptomatic, or BP >30 mmHg above the 95th (or >180/120 in an adolescent) → send to ED.',
      ],
    });
  }

  Widget _table10Content() {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      Widget li(String t) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('• $t', style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.8), height: 1.35)),
          );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('All patients', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: cs.primary)),
          const SizedBox(height: 4),
          li('Urinalysis'),
          li('Chemistry panel — electrolytes, BUN, creatinine'),
          li('Lipid profile (fasting or non-fasting: HDL + total cholesterol)'),
          li('Renal ultrasound if < 6 yr, or abnormal urinalysis / renal function'),
          const SizedBox(height: 8),
          Text('If obese (BMI ≥95th percentile), add', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: cs.primary)),
          const SizedBox(height: 4),
          li('HbA1c (diabetes screen)'),
          li('AST & ALT (fatty liver screen)'),
          li('Fasting lipid panel (dyslipidemia screen)'),
        ],
      );
    });
  }

  Widget _table16Content() {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      const rows = [
        ('Fruits & vegetables', '4–5 servings/day'),
        ('Low-fat milk products', '≥2 servings/day'),
        ('Whole grains', '6 servings/day'),
        ('Fish, poultry, lean red meats', '≤2 servings/day'),
        ('Legumes & nuts', '1 serving/day'),
        ('Oils & fats', '2–3 servings/day'),
        ('Added sugar & sweets', '≤1 serving/day'),
        ('Dietary sodium', '<2300 mg/day'),
      ];
      return Column(
        children: rows
            .map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(r.$1, style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.85)))),
                      Text(r.$2, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: cs.primary)),
                    ],
                  ),
                ))
            .toList(),
      );
    });
  }

  Widget _bulletBlock(Map<String, List<String>> sections) {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      final curName = ['Normal', 'Elevated BP', 'Stage 1 HTN', 'Stage 2 HTN'][_categoryIndex()];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sections.entries.map((e) {
          final isCurrent = e.key == curName;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: isCurrent
                ? BoxDecoration(color: cs.primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(6), border: Border.all(color: cs.primary.withValues(alpha: 0.3)))
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(e.key, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: cs.primary)),
                  if (isCurrent) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(4)),
                      child: const Text('THIS PATIENT', style: TextStyle(fontSize: 8.5, color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ]),
                const SizedBox(height: 3),
                ...e.value.map((r) => Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text('• $r', style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.8), height: 1.35)),
                    )),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildReference() {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: cs.surface, border: Border.all(color: cs.outline), borderRadius: BorderRadius.circular(10)),
        child: Text(
          'Flynn JT, Kaelber DC, Baker-Smith CM, et al. Clinical Practice\n'
          'Guideline for Screening and Management of High Blood Pressure\n'
          'in Children and Adolescents. Pediatrics. 2017;140(3):e20171904.',
          style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 11, height: 1.5),
        ),
      );
    });
  }

  // ── shared helpers ──
  Widget _sectionLabel(String text) => Builder(builder: (context) => Text(text,
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)));

  Widget _cell(String t, {bool header = false, bool bold = false, Color? color}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Text(t,
            textAlign: header ? TextAlign.center : TextAlign.start,
            style: TextStyle(fontSize: header ? 11 : 12, fontWeight: header || bold ? FontWeight.bold : FontWeight.normal, color: header ? Colors.white : color)),
      );

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
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: cs.onSurface)),
          const SizedBox(height: 6),
          Row(children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: value > min ? cs.primary : cs.onSurface.withValues(alpha: 0.3),
              onPressed: value > min ? () {
                final n = value - 1;
                onChanged(n);
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
                  final parsed = int.tryParse(v);
                  if (parsed != null && parsed >= min && parsed <= max) onChanged(parsed);
                  // Refresh on every keystroke so the Assess button and the
                  // height-column preview react to a cleared/invalid field.
                  setState(() {});
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              color: value < max ? cs.primary : cs.onSurface.withValues(alpha: 0.3),
              onPressed: value < max ? () {
                final n = value + 1;
                onChanged(n);
                controller?.text = n.toString();
              } : null,
            ),
          ]),
        ],
      );
    });
  }
}
