import 'package:flutter/material.dart';
// ── Semantic/status colors (kept as constants) ────────────────────────────────
const Color _accent    = Color(0xFF58a6ff);
const Color _green     = Color(0xFF3fb950);
const Color _greenDim  = Color(0xFF122820);
const Color _amber     = Color(0xFFd29922);
const Color _amberDim  = Color(0xFF2d2005);
const Color _red       = Color(0xFFf85149);
const Color _redDim    = Color(0xFF2d1117);
const Color _purple    = Color(0xFFbc8cff);
const Color _purpleDim = Color(0xFF1e1530);
const Color _orange    = Color(0xFFf0883e);
const Color _orangeDim = Color(0xFF2a1a08);

class SchwartzEGFRCalculator extends StatefulWidget {
  const SchwartzEGFRCalculator({super.key});

  @override
  State<SchwartzEGFRCalculator> createState() =>
      _SchwartzEGFRCalculatorState();
}

class _SchwartzEGFRCalculatorState extends State<SchwartzEGFRCalculator>
    with SingleTickerProviderStateMixin {
  // ── State ─────────────────────────────────────────────────────────────────
  String _ageGroup = 'infant'; // 'infant' | 'child'
  double _k = 0.33;
  String _kReason = 'Infant < 1 year';

  double _ageY  = 0;
  double _ageM  = 6;
  double _height = 65;
  double _creat  = 0.4;

  final _ageYCtrl    = TextEditingController(text: '0');
  final _ageMCtrl    = TextEditingController(text: '6');
  final _heightCtrl  = TextEditingController(text: '65');
  final _creatCtrl   = TextEditingController(text: '0.4');

  String? _errHeight;
  String? _errCreat;

  bool _showResults = false;
  _CalcResult? _result;

  late AnimationController _fadeCtrl;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim  = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ageYCtrl.dispose();
    _ageMCtrl.dispose();
    _heightCtrl.dispose();
    _creatCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Age group ─────────────────────────────────────────────────────────────
  void _setAgeGroup(String group) {
    setState(() {
      _ageGroup = group;
      if (group == 'infant') {
        _k       = 0.33;
        _kReason = 'Infant < 1 year';
        _ageY    = 0;  _ageYCtrl.text   = '0';
        _ageM    = 6;  _ageMCtrl.text   = '6';
        _height  = 65; _heightCtrl.text = '65';
      } else {
        _k       = 0.45;
        _kReason = 'Child ≥ 1 year';
        _ageY    = 5;  _ageYCtrl.text   = '5';
        _ageM    = 0;  _ageMCtrl.text   = '0';
        _height  = 110; _heightCtrl.text = '110';
      }
      _errHeight    = null;
      _errCreat     = null;
      _showResults  = false;
      _result       = null;
    });
  }

  // ── CKD stage ─────────────────────────────────────────────────────────────
  _CKDStage _getCKDStage(double egfr) {
    if (egfr >= 90) return const _CKDStage('ckd-g1', 'g1', 'G1 — Normal or High',              'Normal kidney function');
    if (egfr >= 60) return const _CKDStage('ckd-g2', 'g2', 'G2 — Mildly Decreased',             'Monitor closely');
    if (egfr >= 45) return const _CKDStage('ckd-g3a','g3a','G3a — Mild–Moderate Decrease',       'CKD Stage 3a');
    if (egfr >= 30) return const _CKDStage('ckd-g3b','g3b','G3b — Moderate–Severe Decrease',     'CKD Stage 3b');
    if (egfr >= 15) return const _CKDStage('ckd-g4', 'g4', 'G4 — Severely Decreased',            'Prepare for RRT');
    return             const _CKDStage('ckd-g5', 'g5', 'G5 — Kidney Failure',                    'RRT indicated');
  }

  // ── Calculate ─────────────────────────────────────────────────────────────
  void _calculate() {
    setState(() { _errHeight = null; _errCreat = null; });
    bool valid = true;

    if (_height < 30 || _height > 200) {
      setState(() => _errHeight = 'Enter height (30–200 cm)');
      valid = false;
    }
    if (_creat < 0.1 || _creat > 20) {
      setState(() => _errCreat  = 'Enter creatinine (0.1–20 mg/dL)');
      valid = false;
    }
    if (!valid) { setState(() => _showResults = false); return; }

    final egfr        = double.parse((_k * _height / _creat).toStringAsFixed(1));
    final egfrBedside = double.parse((0.413 * _height / _creat).toStringAsFixed(1));
    final stage       = _getCKDStage(egfr);

    final String ageStr;
    if (_ageGroup == 'infant') {
      ageStr = '${_ageM.toInt()} month(s)';
    } else {
      final mPart = _ageM > 0 ? ' ${_ageM.toInt()}m' : '';
      ageStr = '${_ageY.toInt()} yr(s)$mPart'.trim();
    }

    setState(() {
      _result = _CalcResult(
        egfr: egfr,
        egfrBedside: egfrBedside,
        stage: stage,
        ageStr: ageStr,
        height: _height,
        creat: _creat,
        k: _k,
        ageGroup: _ageGroup,
      );
      _showResults = true;
    });
    _fadeCtrl.forward(from: 0);
  }

  // ── Reset ─────────────────────────────────────────────────────────────────
  void _clearAll() {
    final h = _ageGroup == 'infant' ? 65.0 : 110.0;
    final ay = _ageGroup == 'infant' ? 0.0  : 5.0;
    final am = _ageGroup == 'infant' ? 6.0  : 0.0;
    _heightCtrl.text = h.toInt().toString();
    _creatCtrl.text  = '0.4';
    _ageYCtrl.text   = ay.toInt().toString();
    _ageMCtrl.text   = am.toInt().toString();
    setState(() {
      _height       = h;
      _creat        = 0.4;
      _ageY         = ay;
      _ageM         = am;
      _errHeight    = null;
      _errCreat     = null;
      _showResults  = false;
      _result       = null;
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Schwartz eGFR',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildAgeGroupSection(),
            const SizedBox(height: 12),
            _buildPatientDetails(),
            const SizedBox(height: 16),
            _buildActionButtons(),
            if (_showResults && _result != null) ...[
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: _buildResults(_result!),
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _purple.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text('PAEDIATRIC TOOL',
              style: TextStyle(
                  color: _purple,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2)),
        ),
        const SizedBox(height: 8),
        Builder(builder: (context) => Text('Schwartz eGFR Calculator',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface, fontSize: 22, fontWeight: FontWeight.bold))),
        const SizedBox(height: 4),
        Builder(builder: (context) => Text(
            'Creatinine clearance for infants & children — Schwartz equation with CKD staging',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12.5))),
      ],
    );
  }

  // ── Age group section ─────────────────────────────────────────────────────
  Widget _buildAgeGroupSection() {
    return _sectionCard(
      title: 'Age Group',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toggle buttons
          Row(
            children: [
              Expanded(child: _ageToggleBtn('infant', '< 1 Year (Infant)')),
              const SizedBox(width: 8),
              Expanded(child: _ageToggleBtn('child',  '≥ 1 Year (Child)')),
            ],
          ),
          const SizedBox(height: 14),
          // K constant badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _purple.withValues(alpha: 0.12),
              border: Border.all(color: _purple.withValues(alpha: 0.4)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Text('🧮', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Schwartz constant k',
                          style: TextStyle(
                              color: _purple,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Builder(builder: (context) => Text(_kReason,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 11.5))),
                    ],
                  ),
                ),
                Text(
                  _k.toStringAsFixed(2),
                  style: const TextStyle(
                      color: _purple,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ageToggleBtn(String group, String label) {
    final active = _ageGroup == group;
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return GestureDetector(
        onTap: () => _setAgeGroup(group),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? _purple : Colors.transparent,
            border: Border.all(
                color: active ? _purple : cs.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: active ? Colors.white : cs.onSurface.withValues(alpha: 0.6),
                fontSize: 13,
                fontWeight: active ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      );
    });
  }

  // ── Patient details ───────────────────────────────────────────────────────
  Widget _buildPatientDetails() {
    return _sectionCard(
      title: 'Patient Details',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _stepperField(
                label: 'Age — Years',
                value: _ageY,
                ctrl: _ageYCtrl,
                unit: 'years',
                step: 1,
                min: 0,
                max: 18,
                decimals: 0,
                error: null,
                onChanged: (v) => setState(() => _ageY = v),
              )),
              const SizedBox(width: 10),
              Expanded(child: _stepperField(
                label: 'Age — Months',
                value: _ageM,
                ctrl: _ageMCtrl,
                unit: 'months',
                step: 1,
                min: 0,
                max: 11,
                decimals: 0,
                error: null,
                onChanged: (v) => setState(() => _ageM = v),
              )),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _stepperField(
                label: 'Height',
                value: _height,
                ctrl: _heightCtrl,
                unit: 'cm',
                step: 0.5,
                min: 30,
                max: 200,
                decimals: 1,
                error: _errHeight,
                onChanged: (v) => setState(() {
                  _height = v;
                  _errHeight = null;
                }),
              )),
              const SizedBox(width: 10),
              Expanded(child: _stepperField(
                label: 'Serum Creatinine',
                value: _creat,
                ctrl: _creatCtrl,
                unit: 'mg/dL',
                step: 0.1,
                min: 0.1,
                max: 20,
                decimals: 1,
                error: _errCreat,
                onChanged: (v) => setState(() {
                  _creat = v;
                  _errCreat = null;
                }),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepperField({
    required String label,
    required double value,
    required TextEditingController ctrl,
    required String unit,
    required double step,
    required double min,
    required double max,
    required int decimals,
    required String? error,
    required void Function(double) onChanged,
  }) {
    String fmt(double v) =>
        decimals == 0 ? v.toInt().toString() : v.toStringAsFixed(decimals);

    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.6), fontSize: 11.5, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: error != null ? _red : cs.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _stepBtn(Icons.add, () {
                  final nv = double.parse(
                      (value + step).toStringAsFixed(decimals + 1));
                  if (nv <= max) {
                    ctrl.text = fmt(nv);
                    onChanged(nv);
                  }
                }),
                TextField(
                  controller: ctrl,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: decimals > 0),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  ),
                  onChanged: (text) {
                    final parsed = double.tryParse(text);
                    if (parsed != null && parsed >= min && parsed <= max) {
                      onChanged(parsed);
                    }
                  },
                ),
                _stepBtn(Icons.remove, () {
                  final nv = double.parse(
                      (value - step).toStringAsFixed(decimals + 1));
                  if (nv >= min) {
                    ctrl.text = fmt(nv);
                    onChanged(nv);
                  }
                }),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(unit, style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 10.5)),
          if (error != null) ...[
            const SizedBox(height: 2),
            Text(error, style: const TextStyle(color: _red, fontSize: 10.5)),
          ],
        ],
      );
    });
  }

  Widget _stepBtn(IconData icon, VoidCallback onTap) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), size: 16),
        ),
      );
    });
  }

  // ── Action buttons ────────────────────────────────────────────────────────
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _calculate,
            style: ElevatedButton.styleFrom(
              backgroundColor: _purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text('Calculate eGFR',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 50,
          height: 50,
          child: Builder(builder: (context) => OutlinedButton(
            onPressed: _clearAll,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Theme.of(context).colorScheme.outline),
              foregroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.zero,
            ),
            child: Text('↺',
                style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
          )),
        ),
      ],
    );
  }

  // ── Results ───────────────────────────────────────────────────────────────
  Widget _buildResults(_CalcResult r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildEgfrHero(r),
        const SizedBox(height: 12),
        _buildBedsideBox(r),
        const SizedBox(height: 12),
        _buildDetailCard(r),
        const SizedBox(height: 12),
        _buildCKDTable(r.stage),
        const SizedBox(height: 12),
        _buildKdigoNote(),
        const SizedBox(height: 12),
        _buildDisclaimer(),
      ],
    );
  }

  // eGFR hero box
  Widget _buildEgfrHero(_CalcResult r) {
    final bgColor  = _stageBg(r.stage.cls);
    final tagColor = _stageTagColor(r.stage.cls);
    final badgeColor = _stageBadgeColor(r.stage.cls);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: tagColor.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text('Estimated GFR — Schwartz',
              style: TextStyle(
                  color: tagColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8)),
          const SizedBox(height: 10),
          Text(
            r.egfr.toStringAsFixed(1),
            style: TextStyle(
                color: tagColor,
                fontSize: 52,
                fontWeight: FontWeight.bold,
                height: 1),
          ),
          const SizedBox(height: 4),
          Text('mL/min/1.73m²',
              style: TextStyle(color: tagColor.withValues(alpha: 0.8), fontSize: 13)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.2),
              border: Border.all(color: badgeColor.withValues(alpha: 0.6)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(r.stage.label,
                style: TextStyle(
                    color: badgeColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Bedside Schwartz box
  Widget _buildBedsideBox(_CalcResult r) {
    return _sectionCard(
      title: '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🩺', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(builder: (context) => Text('Bedside Schwartz Formula',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold))),
                    Builder(builder: (context) => Text('QUICK ESTIMATE — no k constant needed',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 11))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Builder(builder: (context) => Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: _purple.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'eGFR = 0.413 × Height (cm) / Serum Creatinine (mg/dL)',
              style: TextStyle(
                  color: _purple,
                  fontSize: 12.5,
                  fontFamily: 'monospace'),
            ),
          )),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _compBox(
                label: 'Schwartz (k)',
                value: r.egfr.toStringAsFixed(1),
                color: _purple,
              )),
              const SizedBox(width: 10),
              Expanded(child: _compBox(
                label: 'Bedside (0.413)',
                value: r.egfrBedside.toStringAsFixed(1),
                color: _accent,
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _compBox({
    required String label,
    required String value,
    required Color color,
  }) {
    return Builder(builder: (context) => Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text('mL/min/1.73m²',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 10)),
        ],
      ),
    ));
  }

  // Detail card
  Widget _buildDetailCard(_CalcResult r) {
    final ageLbl = r.ageGroup == 'infant'
        ? '< 1 Year (Infant)'
        : '≥ 1 Year (Child)';
    final kLbl = '${r.k.toStringAsFixed(2)} (${r.ageGroup == 'infant' ? 'infant < 1yr' : 'child ≥ 1yr'})';

    return _sectionCard(
      title: '',
      child: Column(
        children: [
          _detailRow('Age Group', ageLbl),
          _detailRow('Age', r.ageStr),
          _detailRow('Height', '${r.height.toStringAsFixed(r.height % 1 == 0 ? 0 : 1)} cm'),
          _detailRow('Serum Creatinine', '${r.creat.toStringAsFixed(1)} mg/dL'),
          _detailRow('k constant used', kLbl),
          const SizedBox(height: 4),
          Builder(builder: (context) => Row(
            children: [
              Expanded(
                flex: 4,
                child: Text('Formula',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 11.5)),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  'eGFR = k × Height(cm) / SCr(mg/dL)',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 11,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  // CKD stage table
  Widget _buildCKDTable(_CKDStage active) {
    final rows = [
      _TableRow('G1',  'g1',  '≥ 90',    'Normal or high'),
      _TableRow('G2',  'g2',  '60 – 89', 'Mildly decreased*'),
      _TableRow('G3a', 'g3a', '45 – 59', 'Mildly to moderately decreased'),
      _TableRow('G3b', 'g3b', '30 – 44', 'Moderately to severely decreased'),
      _TableRow('G4',  'g4',  '15 – 29', 'Severely decreased'),
      _TableRow('G5',  'g5',  '< 15',    'Kidney failure'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text('eGFR Categories (G)',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: _purpleDim,
                    border: Border.all(
                        color: _purple.withValues(alpha: 0.4)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('KDIGO 2024',
                      style: TextStyle(
                          color: _purple,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          // Column headers
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 7),
            child: Row(
              children: [
                SizedBox(
                  width: 46,
                  child: Text('Category',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 3,
                  child: Text('GFR (mL/min/1.73m²)',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 4,
                  child: Text('Terms',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          // Rows
          ...rows.map((row) {
            final isActive = row.cls == active.cls;
            return Container(
              color: isActive
                  ? _purple.withValues(alpha: 0.12)
                  : Colors.transparent,
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 9),
              child: Row(
                children: [
                  SizedBox(
                    width: 46,
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _stageTagColor(row.cls),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(row.label,
                            style: TextStyle(
                                color: isActive ? _purple : Theme.of(context).colorScheme.onSurface,
                                fontSize: 12,
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(row.range,
                        style: TextStyle(
                            color: isActive ? _purple : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 12)),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(row.terms,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: isActive ? _purple : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 11.5)),
                  ),
                ],
              ),
            );
          }),
          // Footer note
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
            child: Text(
              '* In the absence of other kidney damage markers, G1 and G2 do not fulfil the criteria for CKD.',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 10.5, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  // KDIGO 2024 paediatric note
  Widget _buildKdigoNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _purple.withValues(alpha: 0.12),
        border: Border.all(color: _purple.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📋', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('KDIGO 2024 — Paediatric Note',
                    style: TextStyle(
                        color: _purple,
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  'eGFR < 90 mL/min/1.73m² can now be flagged as "low" in children and adolescents. '
                  'Young people should maintain excellent kidney function — values below 90 warrant '
                  'attention even without structural kidney damage.',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface, fontSize: 12.5, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Disclaimer
  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _amber.withValues(alpha: 0.08),
        border: Border.all(color: _amber.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        '⚠️ Staging per KDIGO 2024. Schwartz equation validated for paediatric patients only.\n'
        'Normal GFR is age-dependent in infants — interpret in clinical context.\n'
        'Not for use in adults.',
        style: TextStyle(color: _amber, fontSize: 11.5, height: 1.5),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(title,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }

  Widget _detailRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(key,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12.5)),
          ),
          Expanded(
            flex: 6,
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ── Color helpers ─────────────────────────────────────────────────────────
  Color _stageBg(String cls) {
    switch (cls) {
      case 'g1': return _greenDim;
      case 'g2': return const Color(0xFF0d2218);
      case 'g3a': return _amberDim;
      case 'g3b': return _orangeDim;
      case 'g4': return _redDim;
      case 'g5': return const Color(0xFF200808);
      default:   return Colors.transparent;
    }
  }

  Color _stageTagColor(String cls) {
    switch (cls) {
      case 'g1':
      case 'g2':  return _green;
      case 'g3a': return _amber;
      case 'g3b': return _orange;
      case 'g4':
      case 'g5':  return _red;
      default:    return Colors.grey;
    }
  }

  Color _stageBadgeColor(String cls) {
    switch (cls) {
      case 'g1':
      case 'g2':  return _green;
      case 'g3a': return _amber;
      case 'g3b': return _orange;
      case 'g4':
      case 'g5':  return _red;
      default:    return Colors.grey;
    }
  }
}

// ── Data models ───────────────────────────────────────────────────────────────
class _CKDStage {
  final String id;
  final String cls;
  final String label;
  final String desc;

  const _CKDStage(this.id, this.cls, this.label, this.desc);
}

class _TableRow {
  final String label;
  final String cls;
  final String range;
  final String terms;

  const _TableRow(this.label, this.cls, this.range, this.terms);
}

class _CalcResult {
  final double egfr;
  final double egfrBedside;
  final _CKDStage stage;
  final String ageStr;
  final double height;
  final double creat;
  final double k;
  final String ageGroup;

  const _CalcResult({
    required this.egfr,
    required this.egfrBedside,
    required this.stage,
    required this.ageStr,
    required this.height,
    required this.creat,
    required this.k,
    required this.ageGroup,
  });
}
