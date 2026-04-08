import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../guides/fetal_development_screen.dart';

// Semantic status colours — used ONLY for clinical progress/trimester indicators
// (Not for text or surfaces, which always use Theme.)
const Color _colGreen = Color(0xFF2E7D32);
const Color _colAmber = Color(0xFFF57F17);
const Color _colBlue  = Color(0xFF1565C0);

// ── Fetal development map (completed weeks) ───────────────────────────────────
const Map<int, String> _fetalDev = {
  1:  'Fertilization and implantation occurring. Embryonic disc forming.',
  4:  'Embryo implanted. Heart tube begins to form. Size: ~2mm.',
  5:  'Heart begins beating. Neural tube forming. Arm and leg buds appear.',
  6:  'Brain and spinal cord forming. Facial features beginning. ~4mm.',
  7:  'Hands and feet forming. Eyelids, ears developing. ~10mm.',
  8:  'All major organs forming. Embryo recognizably human. ~16mm.',
  9:  'Fingers forming. Embryo is now a fetus. ~23mm.',
  10: 'Fingernails forming. Fetus can swallow. ~31mm.',
  11: 'External genitalia differentiating. Tooth buds present.',
  12: 'Reflexes present. Kidneys producing urine. ~54mm.',
  13: 'End of first trimester. Fingerprints forming.',
  14: 'Facial expressions possible. Sucking reflex present.',
  16: 'Fine hair (lanugo) appearing. Some mothers feel movement.',
  18: 'Fingerprints complete. Hearing possible.',
  20: 'Halfway point. Vernix caseosa forming. ~25cm.',
  22: 'Rapid brain development. Eyelids still fused.',
  24: 'Viability threshold. Surfactant production beginning. ~30cm.',
  26: 'Eyes open. Responds to sound and light.',
  28: 'Brain developing rapidly. Good chance of survival if born now.',
  30: 'Skin becoming less wrinkled. Lanugo decreasing.',
  32: 'Bones fully developed. Practice breathing movements. ~42cm.',
  34: 'Central nervous system maturing rapidly.',
  36: 'Most organ systems ready. Gaining ~30g/day.',
  37: 'Early term. Lungs nearly mature.',
  38: 'Term. Baby is ready.',
  39: 'Full term. Optimal time for delivery.',
  40: 'Due date. Average birth weight ~3.4 kg.',
  41: 'Post-dates. Monitoring recommended.',
  42: 'Post-term. Induction typically indicated.',
};

String _devText(int week) {
  if (week <= 3) return _fetalDev[1]!;
  final keys = _fetalDev.keys.where((k) => k <= week).toList()..sort();
  return keys.isEmpty ? _fetalDev[1]! : _fetalDev[keys.last]!;
}

// ── Main widget ───────────────────────────────────────────────────────────────

class GestationalAgeCalculator extends StatefulWidget {
  const GestationalAgeCalculator({super.key});

  @override
  State<GestationalAgeCalculator> createState() =>
      _GestationalAgeCalculatorState();
}

class _GestationalAgeCalculatorState extends State<GestationalAgeCalculator> {
  // ── Tab ────────────────────────────────────────────────────────────────────
  int _tab = 0; // 0=LMP  1=US  2=EDD  3=IVF  4=Conception

  // ── LMP tab ────────────────────────────────────────────────────────────────
  DateTime? _lmpDate;
  final _cycleLenCtrl = TextEditingController(text: '28');

  // ── US tab ─────────────────────────────────────────────────────────────────
  DateTime? _scanDate;
  final _gaWeeksCtrl = TextEditingController(text: '0');
  final _gaDaysCtrl  = TextEditingController(text: '0');

  // ── EDD tab ────────────────────────────────────────────────────────────────
  DateTime? _knownEdd;

  // ── IVF tab ────────────────────────────────────────────────────────────────
  DateTime? _transferDate;
  int _embryoAge = 5; // 5, 3, or 0

  // ── Conception tab ─────────────────────────────────────────────────────────
  DateTime? _conceptionDate;

  // ── Results ────────────────────────────────────────────────────────────────
  bool _showResults = false;
  DateTime? _edd;
  DateTime? _lmp;
  String _method = '';

  // ── Section 2 explorer ─────────────────────────────────────────────────────
  int _explorerWeek = 20;

  // ── Section 5 — GA on date ──────────────────────────────────────────────────
  DateTime? _gaQueryDate;
  String? _gaQueryResult;

  // ── Formatter ──────────────────────────────────────────────────────────────
  static final DateFormat _fmt = DateFormat('dd MMM yyyy');

  @override
  void dispose() {
    _cycleLenCtrl.dispose();
    _gaWeeksCtrl.dispose();
    _gaDaysCtrl.dispose();
    super.dispose();
  }

  // ── Derived getters ────────────────────────────────────────────────────────

  int get _gaDayCount {
    if (_lmp == null) return 0;
    return DateTime.now().difference(_lmp!).inDays;
  }

  int get _gaWeeksComp => _gaDayCount ~/ 7;
  int get _gaRemDays   => _gaDayCount % 7;

  int get _daysToEdd {
    if (_edd == null) return 0;
    return _edd!.difference(DateTime.now()).inDays;
  }

  String get _trimesterLabel {
    final w = _gaWeeksComp;
    if (w < 14) return '1st Trimester';
    if (w < 28) return '2nd Trimester';
    return '3rd Trimester';
  }

  Color get _trimColor {
    final w = _gaWeeksComp;
    if (w < 14) return _colGreen;
    if (w < 28) return _colAmber;
    return _colBlue;
  }

  double get _progressVal => (_gaDayCount / 280.0).clamp(0.0, 1.0);

  String _fmtDate(DateTime d) => _fmt.format(d);
  String _fmtRange(DateTime a, DateTime b) =>
      '${_fmt.format(a)} — ${_fmt.format(b)}';
  DateTime _add(DateTime d, int days) => d.add(Duration(days: days));

  // ── Date picker ────────────────────────────────────────────────────────────

  Future<void> _pickDate(
    BuildContext context,
    DateTime? initial,
    void Function(DateTime) onPicked,
  ) async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2042),
    );
    if (d != null) onPicked(d);
  }

  // ── Calculate ──────────────────────────────────────────────────────────────

  void _calculate() {
    DateTime? edd;
    DateTime? lmp;
    String method = '';

    switch (_tab) {
      case 0: // LMP
        if (_lmpDate == null) {
          _err('Please enter the LMP date.');
          return;
        }
        final cycle = int.tryParse(_cycleLenCtrl.text) ?? 28;
        final corrected = _lmpDate!.add(Duration(days: cycle - 28));
        edd = corrected.add(const Duration(days: 280));
        lmp = corrected;
        method = 'LMP (cycle ${cycle}d)';

      case 1: // Ultrasound
        if (_scanDate == null) {
          _err('Please enter the scan date.');
          return;
        }
        final gaW = int.tryParse(_gaWeeksCtrl.text) ?? 0;
        final gaD = int.tryParse(_gaDaysCtrl.text) ?? 0;
        final gaAtScan = gaW * 7 + gaD;
        edd = _scanDate!.subtract(Duration(days: gaAtScan)).add(const Duration(days: 280));
        lmp = edd.subtract(const Duration(days: 280));
        method = 'Ultrasound (${gaW}w${gaD}d)';

      case 2: // Known EDD
        if (_knownEdd == null) {
          _err('Please enter the EDD.');
          return;
        }
        edd = _knownEdd!;
        lmp = edd.subtract(const Duration(days: 280));
        method = 'Known EDD';

      case 3: // IVF
        if (_transferDate == null) {
          _err('Please enter the embryo transfer date.');
          return;
        }
        final offset = _embryoAge == 5 ? 261 : _embryoAge == 3 ? 263 : 266;
        edd = _transferDate!.add(Duration(days: offset));
        lmp = edd.subtract(const Duration(days: 280));
        method = 'IVF/ART (Day $_embryoAge transfer)';

      case 4: // Conception
        if (_conceptionDate == null) {
          _err('Please enter the conception date.');
          return;
        }
        edd = _conceptionDate!.add(const Duration(days: 266));
        lmp = _conceptionDate!.subtract(const Duration(days: 14));
        method = 'Conception date';
    }

    setState(() {
      _edd = edd;
      _lmp = lmp;
      _method = method;
      _showResults = true;
      _gaQueryResult = null;
      _gaQueryDate = null;
      _explorerWeek = _gaWeeksComp.clamp(1, 42);
    });
  }

  void _reset() {
    setState(() {
      _lmpDate = _scanDate = _knownEdd = _transferDate = _conceptionDate = null;
      _cycleLenCtrl.text = '28';
      _gaWeeksCtrl.text = '0';
      _gaDaysCtrl.text = '0';
      _embryoAge = 5;
      _showResults = false;
      _edd = _lmp = null;
      _method = '';
      _gaQueryDate = null;
      _gaQueryResult = null;
    });
  }

  void _err(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Gestational Age & EDD',
          style: TextStyle(color: cs.onPrimary, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTabRow(cs),
                  const SizedBox(height: 16),
                  _buildTabContent(cs),
                  const SizedBox(height: 16),
                  _buildButtons(cs),
                  if (_showResults && _edd != null && _lmp != null) ...[
                    const SizedBox(height: 24),
                    _buildSection1(cs),
                    const SizedBox(height: 16),
                    _buildSection2(cs),
                    const SizedBox(height: 16),
                    _buildSection3(cs),
                    const SizedBox(height: 16),
                    _buildSection4(cs),
                    const SizedBox(height: 16),
                    _buildSection5(cs),
                  ],
                  const SizedBox(height: 24),
                  _buildDisclaimer(cs),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Tab row ────────────────────────────────────────────────────────────────

  Widget _buildTabRow(ColorScheme cs) {
    const labels = ['LMP', 'Ultrasound', 'Known EDD', 'IVF / ART', 'Conception'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = _tab == i;
          return Padding(
            padding: EdgeInsets.only(right: i < labels.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => setState(() {
                _tab = i;
                _showResults = false;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  color: active ? cs.primary : cs.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: active ? cs.primary : cs.outline,
                  ),
                ),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    color: active ? cs.onPrimary : cs.onSurface,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Tab content ────────────────────────────────────────────────────────────

  Widget _buildTabContent(ColorScheme cs) {
    return _card(
      cs,
      child: [
        if (_tab == 0) _buildLmpTab(cs),
        if (_tab == 1) _buildUsTab(cs),
        if (_tab == 2) _buildEddTab(cs),
        if (_tab == 3) _buildIvfTab(cs),
        if (_tab == 4) _buildConceptionTab(cs),
      ].first,
    );
  }

  // TAB 0 — LMP ──────────────────────────────────────────────────────────────

  Widget _buildLmpTab(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('LMP Method', cs),
        const SizedBox(height: 12),
        _dateField(
          context,
          label: 'First day of Last Menstrual Period',
          date: _lmpDate,
          cs: cs,
          onTap: () => _pickDate(context, _lmpDate, (d) => setState(() => _lmpDate = d)),
          onToday: () => setState(() => _lmpDate = _today()),
        ),
        const SizedBox(height: 12),
        _numField(
          label: 'Cycle length (days)',
          ctrl: _cycleLenCtrl,
          hint: '28',
          cs: cs,
        ),
        const SizedBox(height: 10),
        _infoBox(
          'Corrected LMP = LMP + (cycle length − 28).\nEDD = corrected LMP + 280 days.',
          cs,
        ),
      ],
    );
  }

  // TAB 1 — Ultrasound ───────────────────────────────────────────────────────

  Widget _buildUsTab(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('Ultrasound Method', cs),
        const SizedBox(height: 12),
        _dateField(
          context,
          label: 'Scan date',
          date: _scanDate,
          cs: cs,
          onTap: () => _pickDate(context, _scanDate, (d) => setState(() => _scanDate = d)),
          onToday: () => setState(() => _scanDate = _today()),
        ),
        const SizedBox(height: 12),
        Text('Gestational age at scan',
            style: TextStyle(fontSize: 13, color: cs.onSurface.withValues(alpha: 0.7))),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(
            child: _numField(label: 'Weeks', ctrl: _gaWeeksCtrl, hint: '0', cs: cs),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _numField(label: 'Days', ctrl: _gaDaysCtrl, hint: '0', cs: cs),
          ),
        ]),
        const SizedBox(height: 10),
        _infoBox('EDD = scan date − GA at scan + 280 days.', cs),
      ],
    );
  }

  // TAB 2 — Known EDD ────────────────────────────────────────────────────────

  Widget _buildEddTab(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('Known EDD', cs),
        const SizedBox(height: 12),
        _dateField(
          context,
          label: 'Estimated Due Date (EDD)',
          date: _knownEdd,
          cs: cs,
          onTap: () => _pickDate(context, _knownEdd, (d) => setState(() => _knownEdd = d)),
          onToday: null,
        ),
        const SizedBox(height: 10),
        _infoBox('LMP will be calculated as EDD − 280 days.', cs),
      ],
    );
  }

  // TAB 3 — IVF ──────────────────────────────────────────────────────────────

  Widget _buildIvfTab(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('IVF / ART Method', cs),
        const SizedBox(height: 12),
        _dateField(
          context,
          label: 'Embryo transfer date',
          date: _transferDate,
          cs: cs,
          onTap: () =>
              _pickDate(context, _transferDate, (d) => setState(() => _transferDate = d)),
          onToday: () => setState(() => _transferDate = _today()),
        ),
        const SizedBox(height: 12),
        Text('Embryo age at transfer',
            style: TextStyle(fontSize: 13, color: cs.onSurface.withValues(alpha: 0.7))),
        const SizedBox(height: 6),
        RadioGroup<int>(
          groupValue: _embryoAge,
          onChanged: (v) => setState(() => _embryoAge = v!),
          child: Column(
            children: [5, 3, 0].map((age) {
              final label = age == 5
                  ? 'Day 5 — Blastocyst (+261 days to EDD)'
                  : age == 3
                      ? 'Day 3 (+263 days to EDD)'
                      : 'Day 0 — Fresh retrieval (+266 days to EDD)';
              return RadioListTile<int>(
                value: age,
                title: Text(label,
                    style: TextStyle(fontSize: 13, color: cs.onSurface)),
                activeColor: cs.primary,
                dense: true,
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // TAB 4 — Conception ───────────────────────────────────────────────────────

  Widget _buildConceptionTab(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('Conception Date', cs),
        const SizedBox(height: 12),
        _dateField(
          context,
          label: 'Known conception date',
          date: _conceptionDate,
          cs: cs,
          onTap: () =>
              _pickDate(context, _conceptionDate, (d) => setState(() => _conceptionDate = d)),
          onToday: () => setState(() => _conceptionDate = _today()),
        ),
        const SizedBox(height: 10),
        _infoBox('EDD = conception date + 266 days.\nLMP = conception date − 14 days.', cs),
      ],
    );
  }

  // ── Buttons ────────────────────────────────────────────────────────────────

  Widget _buildButtons(ColorScheme cs) {
    return Row(children: [
      Expanded(
        flex: 3,
        child: FilledButton.icon(
          onPressed: _calculate,
          icon: const Icon(Icons.calculate_outlined, size: 18),
          label: const Text('Calculate', style: TextStyle(fontWeight: FontWeight.w700)),
          style: FilledButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        flex: 2,
        child: OutlinedButton.icon(
          onPressed: _reset,
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Reset', style: TextStyle(fontWeight: FontWeight.w600)),
          style: OutlinedButton.styleFrom(
            foregroundColor: cs.onSurface,
            side: BorderSide(color: cs.outline),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // RESULT SECTIONS
  // ══════════════════════════════════════════════════════════════════════════

  // SECTION 1 — Summary ──────────────────────────────────────────────────────

  Widget _buildSection1(ColorScheme cs) {
    final trimColor = _trimColor;
    final gaStr = '${_gaWeeksComp}w ${_gaRemDays}d';
    final eddStr = _fmtDate(_edd!);
    final days = _daysToEdd;
    final daysLabel = days >= 0
        ? '$days day${days == 1 ? '' : 's'} to 40w (approx.)'
        : '${-days} day${-days == 1 ? '' : 's'} past EDD';

    return _card(
      cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle('Summary', cs),
          const SizedBox(height: 14),
          // EDD large
          Text('Estimated Due Date (EDD)',
              style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: 4),
          Text(eddStr,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                  letterSpacing: -0.5)),
          const SizedBox(height: 16),
          // GA chip + trimester
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: trimColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: trimColor.withValues(alpha: 0.4)),
              ),
              child: Text(
                gaStr,
                style: TextStyle(
                    color: trimColor, fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(_trimesterLabel,
                  style: TextStyle(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ),
          ]),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: _progressVal,
              minHeight: 10,
              backgroundColor: cs.onSurface.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(trimColor),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0w', style: TextStyle(fontSize: 11, color: cs.onSurface.withValues(alpha: 0.45))),
              Text(daysLabel,
                  style: TextStyle(fontSize: 11, color: cs.onSurface.withValues(alpha: 0.6))),
              Text('40w', style: TextStyle(fontSize: 11, color: cs.onSurface.withValues(alpha: 0.45))),
            ],
          ),
        ],
      ),
    );
  }

  // SECTION 2 — Fetal development ────────────────────────────────────────────

  Widget _buildSection2(ColorScheme cs) {
    final currentWeek = _gaWeeksComp.clamp(1, 42);
    return _card(
      cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle('Fetal Development', cs),
          const SizedBox(height: 4),
          Text(
            'This week: Fetal development — ${_gaWeeksComp}w\n'
            '(${_gaWeeksComp}w ${_gaRemDays}d counts as $_gaWeeksComp completed weeks)',
            style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 14),
          // Current GA dev card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Week $currentWeek',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: cs.primary)),
                const SizedBox(height: 4),
                Text(_devText(currentWeek),
                    style: TextStyle(fontSize: 13, color: cs.onSurface, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Week explorer slider
          Text('Week explorer',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface.withValues(alpha: 0.65))),
          Slider(
            value: _explorerWeek.toDouble(),
            min: 1,
            max: 42,
            divisions: 41,
            label: '${_explorerWeek}w',
            activeColor: cs.primary,
            onChanged: (v) => setState(() => _explorerWeek = v.round()),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Week $_explorerWeek',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface)),
                const SizedBox(height: 4),
                Text(_devText(_explorerWeek),
                    style: TextStyle(fontSize: 13, color: cs.onSurface, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FetalDevelopmentScreen())),
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text('View Fetal Development'),
            style: OutlinedButton.styleFrom(
              foregroundColor: cs.primary,
              side: BorderSide(color: cs.primary.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  // SECTION 3 — Calculation details ──────────────────────────────────────────

  Widget _buildSection3(ColorScheme cs) {
    final gaStr = '${_gaWeeksComp}w ${_gaRemDays}d';
    final concDate = _add(_lmp!, 14);
    final rows = [
      ('Gestational age today', gaStr),
      ('Calculation method', _method),
      ('Calculated / used LMP', _fmtDate(_lmp!)),
      ('Estimated conception date', _fmtDate(concDate)),
      ('Estimated conception window',
          _fmtRange(_add(_lmp!, 12), _add(_lmp!, 16))),
    ];
    return _card(
      cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle('Calculation Details', cs),
          const SizedBox(height: 12),
          ...List.generate(rows.length, (i) {
            return _detailRow(rows[i].$1, rows[i].$2, cs,
                shade: i.isEven);
          }),
        ],
      ),
    );
  }

  // SECTION 4 — Antenatal dates ──────────────────────────────────────────────

  Widget _buildSection4(ColorScheme cs) {
    final l = _lmp!;

    final items = <_AnteItem>[
      _AnteItem('Calculated LMP', _fmtDate(l)),
      _AnteItem('Estimated conception', _fmtDate(_add(l, 14))),
      _AnteItem('Conception window', _fmtRange(_add(l, 12), _add(l, 16))),
      _AnteItem('Estimated Due Date (EDD)', _fmtDate(_add(l, 280))),
      _AnteItem('NT scan window [11w–13w6d]',
          _fmtRange(_add(l, 84), _add(l, 97))),
      _AnteItem('Anatomy scan window [18w–22w]',
          _fmtRange(_add(l, 126), _add(l, 154))),
      _AnteItem('Typical anatomy scan [20w]', _fmtDate(_add(l, 140))),
      _AnteItem('Glucose screen [24w–28w]',
          _fmtRange(_add(l, 168), _add(l, 196))),
      _AnteItem('Rho(D) immune globulin [28w]', _fmtDate(_add(l, 196))),
      _AnteItem(
        'Antenatal testing — 32w',
        _fmtDate(_add(l, 224)),
        sub: 'Mo-di twins, CHTN on meds, A2GDM/poorly controlled GDM, T1DM, T2DM, '
            'uncomplicated SLE, APS, sickle cell, renal disease (Cr >1.4), previous stillbirth, '
            'previous FGR or preeclampsia requiring preterm delivery, polyhydramnios (DVP ≥12 cm or AFI ≥30 cm).',
      ),
      _AnteItem(
        'Antenatal testing — 34w',
        _fmtDate(_add(l, 238)),
        sub: 'Pre-pregnancy BMI ≥40.',
      ),
      _AnteItem(
        'Antenatal testing — 36w',
        _fmtDate(_add(l, 252)),
        sub: 'Di-di twins, IVF, alcohol use (≥5 drinks/wk), velamentous cord insertion, '
            'single umbilical artery, abnormal PAPP-A or inhibin A.',
      ),
      _AnteItem(
        'Antenatal testing — 37w',
        _fmtDate(_add(l, 259)),
        sub: 'Pre-pregnancy BMI ≥35.',
      ),
      _AnteItem('Tdap vaccination [27w–36w]',
          _fmtRange(_add(l, 189), _add(l, 252))),
      _AnteItem('GBS screen [36w–37w6d]',
          _fmtRange(_add(l, 252), _add(l, 265))),
      _AnteItem('Viability threshold (approx.) [23w]', _fmtDate(_add(l, 161))),
      _AnteItem('Early term [37w0d]', _fmtDate(_add(l, 259))),
      _AnteItem('Full term [39w0d]', _fmtDate(_add(l, 273))),
      _AnteItem('Postdates [41w0d]', _fmtDate(_add(l, 287))),
    ];

    return _card(
      cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle('Important Dates & Antenatal Windows', cs),
          const SizedBox(height: 4),
          Text(
            'Includes pregnancy timing dates plus staff scheduling reminders for '
            'common antenatal surveillance start points. Use as a workflow aid with '
            'clinician judgment and current practice guidance.',
            style: TextStyle(
                fontSize: 11.5,
                color: cs.onSurface.withValues(alpha: 0.55),
                height: 1.5),
          ),
          const SizedBox(height: 12),
          ...List.generate(items.length, (i) {
            final item = items[i];
            return Container(
              color: i.isEven
                  ? cs.primary.withValues(alpha: 0.04)
                  : Colors.transparent,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.label,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: cs.onSurface)),
                        if (item.sub != null) ...[
                          const SizedBox(height: 3),
                          Text(item.sub!,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: cs.onSurface.withValues(alpha: 0.55),
                                  height: 1.4)),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: Text(
                      item.value,
                      style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // SECTION 5 — GA on a given date ───────────────────────────────────────────

  Widget _buildSection5(ColorScheme cs) {
    return _card(
      cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle('GA on a Given Date', cs),
          const SizedBox(height: 12),
          _dateField(
            context,
            label: 'Enter date',
            date: _gaQueryDate,
            cs: cs,
            onTap: () => _pickDate(context, _gaQueryDate,
                (d) => setState(() => _gaQueryDate = d)),
            onToday: () => setState(() => _gaQueryDate = _today()),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              if (_gaQueryDate == null) {
                _err('Select a date first.');
                return;
              }
              final diff = _gaQueryDate!.difference(_lmp!).inDays;
              if (diff < 0) {
                setState(() => _gaQueryResult =
                    'Selected date is before the calculated LMP.');
                return;
              }
              final w = diff ~/ 7;
              final d = diff % 7;
              setState(() => _gaQueryResult =
                  'GA on ${_fmtDate(_gaQueryDate!)} = ${w}w ${d}d');
            },
            style: FilledButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Compute', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          if (_gaQueryResult != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
              ),
              child: Text(
                _gaQueryResult!,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Disclaimer ────────────────────────────────────────────────────────────

  Widget _buildDisclaimer(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        'Reference: ACOG Practice Bulletins, RCOG Green-top Guidelines, '
        'NNF India, IAP India Guidelines. Use with clinical judgment.',
        style: TextStyle(
            fontSize: 11,
            color: cs.onSurface.withValues(alpha: 0.45),
            height: 1.5),
        textAlign: TextAlign.center,
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SHARED WIDGETS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _card(ColorScheme cs, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outline.withValues(alpha: 0.5)),
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title, ColorScheme cs) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: cs.onSurface),
    );
  }

  Widget _infoBox(String text, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 14, color: cs.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withValues(alpha: 0.75),
                    height: 1.5,
                    fontStyle: FontStyle.italic)),
          ),
        ],
      ),
    );
  }

  Widget _dateField(
    BuildContext context, {
    required String label,
    required DateTime? date,
    required ColorScheme cs,
    required VoidCallback onTap,
    VoidCallback? onToday,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: date != null
                  ? cs.primary.withValues(alpha: 0.6)
                  : cs.outline),
        ),
        child: Row(children: [
          Icon(Icons.calendar_today_outlined, size: 18,
              color: date != null ? cs.primary : cs.onSurface.withValues(alpha: 0.4)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurface.withValues(alpha: 0.55))),
                const SizedBox(height: 2),
                Text(
                  date != null ? _fmtDate(date) : 'Tap to select date',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: date != null ? FontWeight.w600 : FontWeight.normal,
                      color: date != null
                          ? cs.onSurface
                          : cs.onSurface.withValues(alpha: 0.35)),
                ),
              ],
            ),
          ),
          if (onToday != null)
            TextButton(
              onPressed: onToday,
              style: TextButton.styleFrom(
                foregroundColor: cs.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Today', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
        ]),
      ),
    );
  }

  Widget _numField({
    required String label,
    required TextEditingController ctrl,
    required String hint,
    required ColorScheme cs,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: TextStyle(color: cs.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.65), fontSize: 13),
        hintText: hint,
        hintStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.35)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: cs.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        filled: true,
        fillColor: Theme.of(context).cardColor,
      ),
    );
  }

  Widget _detailRow(String label, String value, ColorScheme cs, {bool shade = false}) {
    return Container(
      color: shade ? cs.primary.withValues(alpha: 0.04) : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 9),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(label,
                style: TextStyle(
                    fontSize: 13,
                    color: cs.onSurface.withValues(alpha: 0.7))),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }
}

// ── Data class for antenatal items ────────────────────────────────────────────

class _AnteItem {
  final String label;
  final String value;
  final String? sub;
  const _AnteItem(this.label, this.value, {this.sub});
}
