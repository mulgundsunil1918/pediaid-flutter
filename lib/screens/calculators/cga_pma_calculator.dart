import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ── Semantic status colors (kept as-is — theme-independent) ──────────────────
const Color _green = Color(0xFF3fb950);
const Color _amber = Color(0xFFd29922);
const Color _teal = Color(0xFF39d0c8);

class CGAPMACalculator extends StatefulWidget {
  const CGAPMACalculator({super.key});

  @override
  State<CGAPMACalculator> createState() => _CGAPMACalculatorState();
}

class _CGAPMACalculatorState extends State<CGAPMACalculator>
    with SingleTickerProviderStateMixin {
  // ── State ─────────────────────────────────────────────────────────────────
  DateTime? _dob;
  final _gaWeeksCtrl = TextEditingController();
  final _gaDaysCtrl = TextEditingController();

  late int _curDay;
  late int _curMonth;
  late int _curYear;

  bool _showResults = false;
  bool _showInfo = false;
  _CalcResult? _result;

  String? _errDob;
  String? _errGa;
  String? _errCurDate;

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _curDay = now.day;
    _curMonth = now.month;
    _curYear = now.year;

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _gaWeeksCtrl.dispose();
    _gaDaysCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Calculation ───────────────────────────────────────────────────────────
  int _diffDays(DateTime a, DateTime b) {
    return b.difference(a).inDays;
  }

  ({int w, int d}) _fmtWkDays(int totalDays) {
    final abs = totalDays.abs();
    return (w: abs ~/ 7, d: abs % 7);
  }

  void _calculate() {
    setState(() {
      _errDob = null;
      _errGa = null;
      _errCurDate = null;
    });

    bool valid = true;

    // Validate DOB
    if (_dob == null) {
      setState(() => _errDob = 'Please select a valid date of birth');
      valid = false;
    }

    // Validate GA
    final gaWeeks = int.tryParse(_gaWeeksCtrl.text);
    final gaDays = int.tryParse(_gaDaysCtrl.text) ?? 0;
    if (gaWeeks == null || gaWeeks < 22 || gaWeeks > 44) {
      setState(() => _errGa = 'Enter gestational age weeks (22–44)');
      valid = false;
    }

    // Validate current date
    DateTime? curDate;
    try {
      curDate = DateTime(_curYear, _curMonth, _curDay);
      final daysInMonth = DateUtils.getDaysInMonth(_curYear, _curMonth);
      if (_curDay < 1 || _curDay > daysInMonth) {
        setState(() => _errCurDate = 'Please select a valid current date');
        valid = false;
        curDate = null;
      }
    } catch (_) {
      setState(() => _errCurDate = 'Please select a valid current date');
      valid = false;
    }

    if (_dob != null && curDate != null && curDate.isBefore(_dob!)) {
      setState(
          () => _errCurDate = 'Current date cannot be before date of birth');
      valid = false;
    }

    if (!valid) {
      setState(() => _showResults = false);
      return;
    }

    final dob = _dob!;
    final now = curDate!;
    final gaw = gaWeeks!;
    final gad = gaDays;

    final dol = _diffDays(dob, now) + 1;
    final gaTotalDays = gaw * 7 + gad;
    final chronDays = _diffDays(dob, now);
    final pmaTotalDays = gaTotalDays + chronDays;
    const termDays = 40 * 7; // 280
    final cgaTotalDays = pmaTotalDays - termDays;
    final weeksPrem = 40.0 - (gaw + gad / 7.0);

    final isPreterm = gaw < 37;
    final pmaReachedTerm = pmaTotalDays >= termDays;
    final withinTwoYears = chronDays <= 730;
    final cgaApplicable = isPreterm && pmaReachedTerm && withinTwoYears;

    String? cgaNotApplicableReason;
    if (!isPreterm) {
      cgaNotApplicableReason = 'Term/post-term birth';
    } else if (!pmaReachedTerm) {
      final pmaFmt = _fmtWkDays(pmaTotalDays);
      cgaNotApplicableReason = 'PMA only ${pmaFmt.w}w — await 40w';
    } else if (!withinTwoYears) {
      cgaNotApplicableReason = '> 2 years old';
    }

    // CGA display string
    final cgaAbs = cgaTotalDays.abs();
    final cgaWks = cgaAbs ~/ 7;
    final cgaDys = cgaAbs % 7;
    final cgaNeg = cgaTotalDays < 0;
    final cgaStr = cgaNeg ? '−${cgaWks}w ${cgaDys}d' : '${cgaWks}w ${cgaDys}d';

    // Birth status
    final String birthStatus;
    if (gaw < 37) {
      birthStatus = 'Preterm';
    } else if (gaw <= 41) {
      birthStatus = 'Term';
    } else {
      birthStatus = 'Post-term';
    }

    setState(() {
      _result = _CalcResult(
        dol: dol,
        gaTotalDays: gaTotalDays,
        gaWeeks: gaw,
        gaDaysVal: gad,
        chronDays: chronDays,
        pmaTotalDays: pmaTotalDays,
        cgaTotalDays: cgaTotalDays,
        cgaApplicable: cgaApplicable,
        cgaNotApplicableReason: cgaNotApplicableReason,
        cgaStr: cgaStr,
        cgaWks: cgaWks,
        cgaDys: cgaDys,
        birthStatus: birthStatus,
        weeksPrem: weeksPrem,
      );
      _showResults = true;
    });

    _fadeCtrl.forward(from: 0);
  }

  void _clearAll() {
    final now = DateTime.now();
    setState(() {
      _dob = null;
      _gaWeeksCtrl.clear();
      _gaDaysCtrl.clear();
      _curDay = now.day;
      _curMonth = now.month;
      _curYear = now.year;
      _errDob = null;
      _errGa = null;
      _errCurDate = null;
      _showResults = false;
      _result = null;
    });
  }

  // ── Date picker ───────────────────────────────────────────────────────────
  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      builder: (ctx, child) => Theme(
        data: Theme.of(context),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
        _errDob = null;
      });
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('CGA / PMA Calculator',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDobSection(),
            const SizedBox(height: 12),
            _buildGaSection(),
            const SizedBox(height: 12),
            _buildCurrentDateSection(),
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
            const SizedBox(height: 16),
            _buildInfoToggle(),
            if (_showInfo) _buildInfoSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Input sections ────────────────────────────────────────────────────────
  Widget _buildDobSection() {
    return _inputCard(
      title: 'Date of Birth',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _fieldLabel('Select Date'),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _pickDob,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor ??
                    Theme.of(context).cardColor,
                border: Border.all(
                    color: _errDob != null
                        ? Colors.red.shade400
                        : Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today,
                      color: Theme.of(context).colorScheme.primary, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    _dob != null
                        ? '${_dob!.day.toString().padLeft(2, '0')} / '
                            '${_dob!.month.toString().padLeft(2, '0')} / '
                            '${_dob!.year}'
                        : 'Tap to select date of birth',
                    style: TextStyle(
                        color: _dob != null
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          if (_errDob != null) _errorText(_errDob!),
        ],
      ),
    );
  }

  Widget _buildGaSection() {
    return _inputCard(
      title: 'Gestational Age at Birth',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Weeks'),
                    const SizedBox(height: 6),
                    _numberFieldWithBadge(
                      ctrl: _gaWeeksCtrl,
                      hint: 'e.g. 28',
                      badge: 'wks',
                      min: 22,
                      max: 44,
                      hasError: _errGa != null,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Days'),
                    const SizedBox(height: 6),
                    _numberFieldWithBadge(
                      ctrl: _gaDaysCtrl,
                      hint: '0–6',
                      badge: 'd',
                      min: 0,
                      max: 6,
                      hasError: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_errGa != null) _errorText(_errGa!),
        ],
      ),
    );
  }

  Widget _buildCurrentDateSection() {
    final now = DateTime.now();
    final years = List.generate(6, (i) => now.year - i);
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final daysInMonth = DateUtils.getDaysInMonth(_curYear, _curMonth);
    final days = List.generate(daysInMonth, (i) => i + 1);

    // Clamp day if month changed
    if (_curDay > daysInMonth) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _curDay = daysInMonth);
      });
    }

    return _inputCard(
      title: 'Current Date (Assessment)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Day / Month / Year'),
          const SizedBox(height: 6),
          Row(
            children: [
              // Day
              SizedBox(
                width: 70,
                child: _dropdown<int>(
                  value: days.contains(_curDay) ? _curDay : days.last,
                  items: days,
                  label: (v) => v.toString().padLeft(2, '0'),
                  onChanged: (v) =>
                      setState(() => _curDay = v ?? _curDay),
                  hasError: _errCurDate != null,
                ),
              ),
              const SizedBox(width: 8),
              // Month
              Expanded(
                child: _dropdown<int>(
                  value: _curMonth,
                  items: List.generate(12, (i) => i + 1),
                  label: (v) => months[v - 1],
                  onChanged: (v) =>
                      setState(() => _curMonth = v ?? _curMonth),
                  hasError: _errCurDate != null,
                ),
              ),
              const SizedBox(width: 8),
              // Year
              SizedBox(
                width: 90,
                child: _dropdown<int>(
                  value: _curYear,
                  items: years,
                  label: (v) => v.toString(),
                  onChanged: (v) =>
                      setState(() => _curYear = v ?? _curYear),
                  hasError: _errCurDate != null,
                ),
              ),
            ],
          ),
          if (_errCurDate != null) _errorText(_errCurDate!),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _calculate,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text('Calculate',
                style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 50,
          height: 50,
          child: OutlinedButton(
            onPressed: _clearAll,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                  color: Theme.of(context).colorScheme.outline),
              foregroundColor:
                  Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.zero,
            ),
            child: Text('↺',
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6))),
          ),
        ),
      ],
    );
  }

  // ── Results ───────────────────────────────────────────────────────────────
  Widget _buildResults(_CalcResult r) {
    final pmaFmt = _fmtWkDays(r.pmaTotalDays);
    final chronFmt = _fmtWkDays(r.chronDays);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 3 stat boxes
        Row(
          children: [
            Expanded(child: _statBox(
              icon: '📅',
              label: 'Day of Life',
              value: r.dol.toString(),
              sub: 'days old',
              color: _teal,
            )),
            const SizedBox(width: 8),
            Expanded(child: _statBox(
              icon: r.cgaApplicable ? '🧠' : '—',
              label: 'CGA',
              value: r.cgaApplicable ? '${r.cgaWks}w' : 'N/A',
              sub: r.cgaApplicable
                  ? '+${r.cgaDys}d'
                  : (r.cgaNotApplicableReason ?? ''),
              color: r.cgaApplicable
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              dimmed: !r.cgaApplicable,
            )),
            const SizedBox(width: 8),
            Expanded(child: _statBox(
              icon: '🌱',
              label: 'PMA',
              value: '${pmaFmt.w}w',
              sub: '+${pmaFmt.d}d',
              color: _green,
            )),
          ],
        ),
        const SizedBox(height: 12),
        // Detail card
        _darkCard(
          child: Column(
            children: [
              _detailRow('GA at Birth',
                  '${r.gaWeeks} wks ${r.gaDaysVal} days'),
              _detailRowBadge('Birth Status', r.birthStatus),
              _detailRow('Chronological Age',
                  '${r.chronDays} days (${chronFmt.w}w ${chronFmt.d}d)'),
              _detailRow('Weeks Since Birth',
                  '${chronFmt.w} weeks + ${chronFmt.d} days'),
              _detailRow(
                'Corrected Gestational Age',
                r.cgaApplicable
                    ? r.cgaStr
                    : 'N/A — ${r.cgaNotApplicableReason ?? ''}',
              ),
              _detailRow('Post-Menstrual Age',
                  '${pmaFmt.w}w ${pmaFmt.d}d'),
              _detailRow(
                'Weeks Premature',
                r.birthStatus == 'Preterm'
                    ? '${r.weeksPrem.toStringAsFixed(1)} weeks early'
                    : 'N/A (term)',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statBox({
    required String icon,
    required String label,
    required String value,
    required String sub,
    required Color color,
    bool dimmed = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
            color: dimmed
                ? Theme.of(context).colorScheme.outline
                : color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: dimmed
                      ? Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6)
                      : color,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: dimmed
                      ? Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6)
                      : color)),
          Text(sub,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6))),
        ],
      ),
    );
  }

  Widget _detailRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(key,
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                    fontSize: 12.5)),
          ),
          Expanded(
            flex: 5,
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

  Widget _detailRowBadge(String key, String status) {
    Color badgeColor;
    switch (status) {
      case 'Preterm':
        badgeColor = _amber;
      case 'Term':
        badgeColor = _green;
      default:
        badgeColor = Theme.of(context).colorScheme.primary;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(key,
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                    fontSize: 12.5)),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.15),
              border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status,
                style: TextStyle(
                    color: badgeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ── Info section ──────────────────────────────────────────────────────────
  Widget _buildInfoToggle() {
    return GestureDetector(
      onTap: () => setState(() => _showInfo = !_showInfo),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Text('📖', style: TextStyle(fontSize: 15)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'What is CGA & PMA? — Formulas & Clinical Use',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
            AnimatedRotation(
              turns: _showInfo ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.keyboard_arrow_down,
                  color: Theme.of(context).colorScheme.primary, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          _infoCgaCard(),
          const SizedBox(height: 12),
          _infoPmaCard(),
          const SizedBox(height: 12),
          _infoCompareCard(),
        ],
      ),
    );
  }

  Widget _infoCgaCard() {
    return _darkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('🧠', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Corrected Gestational Age (CGA)',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                Text('Also called: Corrected Age / Adjusted Age',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                        fontSize: 11.5)),
              ],
            ),
          ]),
          const SizedBox(height: 12),
          Text(
              'How old would this baby be if born at term?',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          _formulaBox(
            'CGA = Chronological Age − Weeks Premature\n'
            '      or equivalently:\n'
            'CGA = PMA − 40 weeks',
          ),
          const SizedBox(height: 10),
          Text(
            'CGA corrects for prematurity by subtracting the weeks born early from the baby\'s actual age. '
            'A baby born at 28 weeks who is now 3 months old has a CGA of ~0 months — developmentally equivalent to a newborn.',
            style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
                fontSize: 12.5,
                height: 1.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Used until 2 years of age, after which the correction is typically no longer applied.',
            style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
                fontSize: 12.5,
                height: 1.5),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _chip('Developmental milestones',
                  Theme.of(context).colorScheme.primary),
              _chip('Growth charts',
                  Theme.of(context).colorScheme.primary),
              _chip('Neurodevelopmental assessment',
                  Theme.of(context).colorScheme.primary),
              _chip('Hearing/vision screening',
                  Theme.of(context).colorScheme.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoPmaCard() {
    return _darkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('🌱', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Post-Menstrual Age (PMA)',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                Text('Also called: Postconceptional Age (PCA)',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                        fontSize: 11.5)),
              ],
            ),
          ]),
          const SizedBox(height: 12),
          const Text(
              "How many weeks since the mother's last menstrual period?",
              style: TextStyle(
                  color: _green,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          _formulaBox(
              'PMA = GA at Birth (weeks) + Chronological Age (weeks)'),
          const SizedBox(height: 10),
          Text(
            'PMA is a continuous clock starting at the LMP. It never resets and is always in weeks. '
            'A baby born at 28 weeks who is 8 weeks old has a PMA of 36 weeks.',
            style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
                fontSize: 12.5,
                height: 1.5),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _chip('Apnea of prematurity', _green),
              _chip('Caffeine therapy thresholds', _green),
              _chip('ROP screening schedules', _green),
              _chip('Discharge planning', _green),
              _chip('Safe for anaesthesia ≥ 44w PMA', _amber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoCompareCard() {
    return _darkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('⚖️', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Text('CGA vs PMA — Key Differences',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 14),
          _compareTable(),
        ],
      ),
    );
  }

  Widget _compareTable() {
    final rows = [
      ['Reference', 'Term (40 weeks)', 'Last Menstrual Period'],
      ['Units', 'Weeks / months', 'Always weeks'],
      ['Used for', 'Development & growth', 'Medical thresholds'],
      ['Formula', 'PMA − 40w', 'GA at birth + age'],
      ['Duration', 'Until 2 years', 'Entire NICU stay'],
    ];

    return Column(
      children: [
        // Header
        Row(
          children: [
            Expanded(
                flex: 3,
                child: Text('Property',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.bold))),
            Expanded(
                flex: 4,
                child: Text('CGA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold))),
            const Expanded(
                flex: 4,
                child: Text('PMA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: _green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold))),
          ],
        ),
        Divider(
            color: Theme.of(context).colorScheme.outline, height: 16),
        ...rows.map((row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Text(row[0],
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                              fontSize: 11.5))),
                  Expanded(
                      flex: 4,
                      child: Text(row[1],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.primary,
                              fontSize: 11.5))),
                  Expanded(
                      flex: 4,
                      child: Text(row[2],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: _green, fontSize: 11.5))),
                ],
              ),
            )),
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _inputCard({required String title, required Widget child}) {
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
          Text(title,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _darkCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  Widget _fieldLabel(String label) {
    return Text(label,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: 12,
            fontWeight: FontWeight.w600));
  }

  Widget _errorText(String msg) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(msg,
          style:
              TextStyle(color: Colors.red.shade400, fontSize: 12)),
    );
  }

  Widget _numberFieldWithBadge({
    required TextEditingController ctrl,
    required String hint,
    required String badge,
    required int min,
    required int max,
    required bool hasError,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: 13),
        suffixText: badge,
        suffixStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.bold),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor ??
            Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: hasError
                  ? Colors.red.shade400
                  : Theme.of(context).colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: hasError
                  ? Colors.red.shade400
                  : Theme.of(context).colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: hasError
                  ? Colors.red.shade400
                  : Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  Widget _dropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) label,
    required void Function(T?) onChanged,
    required bool hasError,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor ??
            Theme.of(context).cardColor,
        border: Border.all(
            color: hasError
                ? Colors.red.shade400
                : Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        dropdownColor: Theme.of(context).cardColor,
        underline: const SizedBox(),
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface, fontSize: 13),
        icon: Icon(Icons.expand_more,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            size: 18),
        items: items
            .map((v) => DropdownMenuItem<T>(
                  value: v,
                  child: Text(label(v),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 13)),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _formulaBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor ??
            Theme.of(context).cardColor,
        border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text,
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 12.5,
              fontFamily: 'monospace',
              height: 1.6)),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontSize: 11.5)),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────
class _CalcResult {
  final int dol;
  final int gaTotalDays;
  final int gaWeeks;
  final int gaDaysVal;
  final int chronDays;
  final int pmaTotalDays;
  final int cgaTotalDays;
  final bool cgaApplicable;
  final String? cgaNotApplicableReason;
  final String cgaStr;
  final int cgaWks;
  final int cgaDys;
  final String birthStatus;
  final double weeksPrem;

  _CalcResult({
    required this.dol,
    required this.gaTotalDays,
    required this.gaWeeks,
    required this.gaDaysVal,
    required this.chronDays,
    required this.pmaTotalDays,
    required this.cgaTotalDays,
    required this.cgaApplicable,
    required this.cgaNotApplicableReason,
    required this.cgaStr,
    required this.cgaWks,
    required this.cgaDys,
    required this.birthStatus,
    required this.weeksPrem,
  });
}
