import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'lund_browder_screen.dart';
import 'burn_mortality_calculator.dart';

// ── Colour tokens (GIR calculator style) ─────────────────────────────────────
const Color _accent = Color(0xFF58a6ff);
const Color _green  = Color(0xFF3fb950);
const Color _amber  = Color(0xFFd29922);
const Color _red    = Color(0xFFf85149);
const Color _teal   = Color(0xFF39d0c8);
const Color _orange = Color(0xFFf0883e);

class ParklandCalculatorScreen extends StatefulWidget {
  const ParklandCalculatorScreen({super.key});

  @override
  State<ParklandCalculatorScreen> createState() =>
      _ParklandCalculatorScreenState();
}

class _ParklandCalculatorScreenState extends State<ParklandCalculatorScreen>
    with SingleTickerProviderStateMixin {
  // ── Form ──────────────────────────────────────────────────────────────────
  final _formKey      = GlobalKey<FormState>();
  final _weightCtrl   = TextEditingController();
  final _tbsaCtrl     = TextEditingController();
  final _timeCtrl     = TextEditingController();
  final _fluidsCtrl   = TextEditingController();

  bool             _showResults = false;
  _ParklandResult? _result;

  // ── Animation ─────────────────────────────────────────────────────────────
  late AnimationController _fadeCtrl;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 380));
    _fadeAnim  = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _tbsaCtrl.dispose();
    _timeCtrl.dispose();
    _fluidsCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Logic ─────────────────────────────────────────────────────────────────

  double _hollidaySegar(double wt) {
    if (wt <= 10) return wt * 100;
    if (wt <= 20) return 1000 + (wt - 10) * 50;
    return 1500 + (wt - 20) * 20;
  }

  void _calculate() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final weight  = double.parse(_weightCtrl.text.trim());
    final tbsa    = double.parse(_tbsaCtrl.text.trim());
    final rawTime = double.parse(_timeCtrl.text.trim());
    final fluids  = double.tryParse(_fluidsCtrl.text.trim()) ?? 0.0;
    final time    = rawTime.clamp(0.0, 7.0);

    final total       = 3.0 * tbsa * weight;
    final firstHalf   = total / 2.0;
    final adjusted    = firstHalf - fluids;
    final denominator = 8.0 - time;
    final phase1Rate  = denominator > 0 ? adjusted / denominator : double.infinity;
    final phase2Rate  = (total / 2.0) / 16.0;
    final maintDaily  = _hollidaySegar(weight);
    final maintRate   = maintDaily / 24.0;

    setState(() {
      _result = _ParklandResult(
        weight     : weight,
        tbsa       : tbsa,
        time       : time,
        fluids     : fluids,
        total      : total,
        firstHalf  : firstHalf,
        adjusted   : adjusted,
        phase1Rate : phase1Rate,
        phase2Rate : phase2Rate,
        maintDaily : maintDaily,
        maintRate  : maintRate,
        negAdjusted: adjusted < 0,
        invalidRate: phase1Rate == double.infinity || phase1Rate.isNaN,
      );
      _showResults = true;
    });
    _fadeCtrl.forward(from: 0);
  }

  void _reset() {
    _weightCtrl.clear();
    _tbsaCtrl.clear();
    _timeCtrl.clear();
    _fluidsCtrl.clear();
    setState(() {
      _showResults = false;
      _result      = null;
    });
    _formKey.currentState?.reset();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Parkland Formula',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.refresh, size: 17),
            label: const Text('Reset'),
            style: TextButton.styleFrom(foregroundColor: _amber),
          ),
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Page header ─────────────────────────────────────────────
              _buildPageHeader(cs),
              const SizedBox(height: 14),

              // ── 1. Disclaimer banner ─────────────────────────────────────
              _buildDisclaimerBanner(cs, isDark),
              const SizedBox(height: 14),

              // ── 2. Rule of Nines table ───────────────────────────────────
              _buildRuleOfNinesCard(cs, isDark),
              const SizedBox(height: 14),

              // ── 3. Paediatric warning + L&B button ───────────────────────
              _buildPaedWarning(cs, isDark),
              const SizedBox(height: 14),

              // ── 4. Input form ────────────────────────────────────────────
              Form(
                key: _formKey,
                child: _buildInputCard(cs, isDark),
              ),
              const SizedBox(height: 14),

              // ── Calculate button ─────────────────────────────────────────
              _buildCalcButton(cs),

              // ── 5. Results ───────────────────────────────────────────────
              if (_showResults && _result != null) ...[
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: _buildResultSection(_result!, cs, isDark),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── Page header ───────────────────────────────────────────────────────────

  Widget _buildPageHeader(ColorScheme cs) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _orange.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text('BURNS RESUSCITATION',
            style: TextStyle(
                color: _orange,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2)),
      ),
      const SizedBox(height: 8),
      Text('Modified Parkland Formula',
          style: TextStyle(
              color: cs.onSurface, fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Text('Burns fluid resuscitation — first 24 hours',
          style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.6), fontSize: 12.5)),
    ],
  );

  // ── Disclaimer banner ─────────────────────────────────────────────────────

  Widget _buildDisclaimerBanner(ColorScheme cs, bool isDark) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: _red.withValues(alpha: isDark ? 0.12 : 0.07),
      border: Border.all(color: _red.withValues(alpha: 0.4)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('⚠️ ', style: TextStyle(fontSize: 15)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('For 2nd and 3rd degree burns only.',
                  style: TextStyle(
                      color: _red, fontSize: 13, fontWeight: FontWeight.bold, height: 1.4)),
              const SizedBox(height: 2),
              Text('Superficial (1st degree) burns are excluded from TBSA.',
                  style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.7),
                      fontSize: 12.5,
                      height: 1.4)),
            ],
          ),
        ),
      ],
    ),
  );

  // ── Rule of Nines table ───────────────────────────────────────────────────

  Widget _buildRuleOfNinesCard(ColorScheme cs, bool isDark) =>
      _sectionCard(
        cs: cs,
        title: 'Rule of Nines — Age & Percentage Table',
        titleIcon: Icons.table_chart_outlined,
        titleColor: _accent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Horizontally scrollable table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildNinesTable(cs, isDark),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: _teal.withValues(alpha: isDark ? 0.12 : 0.07),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _teal.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Text('💡 ', style: TextStyle(fontSize: 13)),
                  Expanded(
                    child: Text(
                      "Patient's palm = approximately 1% of body surface area",
                      style: TextStyle(
                          color: _teal, fontSize: 12.5, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildNinesTable(ColorScheme cs, bool isDark) {
    const headerBg = _orange;
    final rowData = [
      ['Head (Total)',    '18%',         '18%',            '9%'             ],
      ['Torso (Front)',   '18%',         '18%',            '18%'            ],
      ['Torso (Back)',    '18%',         '18%',            '18%'            ],
      ['Each Arm',        '9%',          '9%',             '9%'             ],
      ['Each Leg',        '14% (per leg)', '14% (per leg)', '18% (per leg)' ],
      ['Genitalia',       '1%',          '1%',             '1%'             ],
    ];
    final headers = ['Body Part', 'Infant\n(<1 yr)', 'Child\n(1–9 yrs)', 'Adult\n(≥10 yrs)'];
    final colWidths = [130.0, 100.0, 110.0, 110.0];

    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      border: TableBorder.all(
        color: cs.onSurface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      children: [
        // Header row
        TableRow(
          decoration: BoxDecoration(
            color: headerBg.withValues(alpha: isDark ? 0.25 : 0.15),
          ),
          children: List.generate(headers.length, (i) => SizedBox(
            width: colWidths[i],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text(
                headers[i],
                textAlign: i == 0 ? TextAlign.left : TextAlign.center,
                style: TextStyle(
                    color: _orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.5,
                    height: 1.3),
              ),
            ),
          )),
        ),
        // Data rows
        ...rowData.asMap().entries.map((entry) {
          final i   = entry.key;
          final row = entry.value;
          final isAlt = i.isOdd;
          return TableRow(
            decoration: BoxDecoration(
              color: isAlt
                  ? cs.onSurface.withValues(alpha: isDark ? 0.04 : 0.025)
                  : Colors.transparent,
            ),
            children: List.generate(row.length, (j) => SizedBox(
              width: colWidths[j],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                child: Text(
                  row[j],
                  textAlign: j == 0 ? TextAlign.left : TextAlign.center,
                  style: TextStyle(
                      color: j == 0
                          ? cs.onSurface
                          : cs.onSurface.withValues(alpha: 0.75),
                      fontSize: 12.5,
                      fontWeight: j == 0 ? FontWeight.w500 : FontWeight.normal),
                ),
              ),
            )),
          );
        }),
      ],
    );
  }

  // ── Paediatric warning + L&B button ──────────────────────────────────────

  Widget _buildPaedWarning(ColorScheme cs, bool isDark) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: _amber.withValues(alpha: isDark ? 0.1 : 0.06),
      border: Border.all(color: _amber.withValues(alpha: 0.35)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('⚠️ ', style: TextStyle(fontSize: 14)),
            Expanded(
              child: Text(
                'For paediatric patients, Rule of Nines is less accurate.\n'
                'Use Lund & Browder Chart for precise TBSA estimation.',
                style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.8),
                    fontSize: 12.5,
                    height: 1.45),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const LundBrowderScreen())),
            icon: const Icon(Icons.person_outlined, size: 16),
            label: const Text('Open Lund & Browder Calculator'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _amber,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 11),
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
          ),
        ),
      ],
    ),
  );

  // ── Input card ────────────────────────────────────────────────────────────

  Widget _buildInputCard(ColorScheme cs, bool isDark) => _sectionCard(
    cs: cs,
    title: 'Patient Parameters',
    titleIcon: Icons.edit_note_rounded,
    titleColor: cs.onSurface,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Weight
        _fieldLabel('Patient Weight (kg)', cs),
        const SizedBox(height: 6),
        TextFormField(
          controller: _weightCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          decoration: _deco(cs, 'e.g. 60', 'kg'),
          validator: (v) {
            final n = double.tryParse(v?.trim() ?? '');
            if (n == null || n <= 0) return 'Required';
            if (n > 300) return 'Enter valid weight';
            return null;
          },
        ),
        const SizedBox(height: 14),

        // TBSA
        _fieldLabel('Burned Body Surface Area — TBSA (%)', cs),
        const SizedBox(height: 4),
        Text('Use Rule of Nines table above or Lund & Browder for paediatrics',
            style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.45),
                fontSize: 11,
                height: 1.3)),
        const SizedBox(height: 6),
        TextFormField(
          controller: _tbsaCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          decoration: _deco(cs, 'e.g. 30', '%'),
          validator: (v) {
            final n = double.tryParse(v?.trim() ?? '');
            if (n == null || n <= 0) return 'Required';
            if (n > 100) return '1 – 100%';
            return null;
          },
        ),
        const SizedBox(height: 14),

        // Time since burn
        _fieldLabel('Time Elapsed Since Burn (hours)', cs),
        const SizedBox(height: 4),
        Text(
          'Enter actual time since burn injury — NOT since hospital arrival.\n'
          'If more than 7 hours, enter 7.',
          style: TextStyle(
              color: _amber, fontSize: 11, fontWeight: FontWeight.w500, height: 1.35)),
        const SizedBox(height: 6),
        TextFormField(
          controller: _timeCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          decoration: _deco(cs, '0 – 7', 'hrs'),
          validator: (v) {
            final n = double.tryParse(v?.trim() ?? '');
            if (n == null || n < 0) return 'Required (0–7 hrs)';
            if (n > 7) return 'Maximum 7 hrs — enter 7 if more time has passed';
            return null;
          },
        ),
        const SizedBox(height: 14),

        // IV fluids already given
        _fieldLabel('IV Fluids Already Given (mL)', cs),
        const SizedBox(height: 4),
        Text('Enter 0 if none given yet',
            style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.45), fontSize: 11)),
        const SizedBox(height: 6),
        TextFormField(
          controller: _fluidsCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          decoration: _deco(cs, 'e.g. 0 or 500', 'mL'),
          validator: (v) {
            final n = double.tryParse(v?.trim() ?? '');
            if (n == null || n < 0) return 'Required (0 or more)';
            return null;
          },
        ),
      ],
    ),
  );

  // ── Calculate button ──────────────────────────────────────────────────────

  Widget _buildCalcButton(ColorScheme cs) => ElevatedButton.icon(
    onPressed: _calculate,
    icon: const Icon(Icons.calculate_rounded, size: 18),
    label: const Text('Calculate',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
    style: ElevatedButton.styleFrom(
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
    ),
  );

  // ── Result section (narrative style) ─────────────────────────────────────

  Widget _buildResultSection(_ParklandResult r, ColorScheme cs, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        // ── SUMMARY ──────────────────────────────────────────────────────
        _resultBlock(
          cs: cs,
          isDark: isDark,
          color: _accent,
          icon: Icons.summarize_outlined,
          title: 'Summary',
          child: _narrativeText(
            cs,
            'This patient weighs ${r.weight.toStringAsFixed(1)} kg with '
            '${r.tbsa.toStringAsFixed(1)}% body surface area burned.\n\n'
            'Using the Modified Parkland Formula (3 mL × TBSA% × Weight), '
            'the total resuscitation volume for the first 24 hours is:\n',
            highlight: '${r.total.toStringAsFixed(0)} mL of Lactated Ringer\'s Solution',
            highlightColor: _accent,
          ),
        ),
        const SizedBox(height: 12),

        // ── PHASE 1 ───────────────────────────────────────────────────────
        _resultBlock(
          cs: cs,
          isDark: isDark,
          color: _orange,
          icon: Icons.timer_outlined,
          title: 'Phase 1 — Initial Resuscitation (First 8 Hours from Burn)',
          child: r.negAdjusted
              ? _warningBox(
                  '⚠️ Result is negative. Large volumes already given may indicate '
                  'complex fluid requirements. Seek expert burn clinician input '
                  'before starting IV fluids.',
                  _red, isDark, cs)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _narLine(cs,
                        'Give half the total volume (${r.firstHalf.toStringAsFixed(0)} mL) '
                        'in the first 8 hours from time of burn.'),
                    const SizedBox(height: 6),
                    _narLine(cs,
                        '${r.time.toStringAsFixed(1)} hours have already passed since the burn.'),
                    _narLine(cs,
                        'Remaining time for first phase: ${(8 - r.time).toStringAsFixed(1)} hours.'),
                    _narLine(cs,
                        'IV fluids already given: ${r.fluids.toStringAsFixed(0)} mL.'),
                    _narLine(cs,
                        'Remaining volume to give: ${r.adjusted.toStringAsFixed(0)} mL.'),
                    const SizedBox(height: 12),
                    // Rate highlight box
                    _rateBox(
                      label: '▶ Start IV resuscitation at:',
                      rate: '${r.phase1Rate.toStringAsFixed(1)} mL/hr',
                      fluid: 'Fluid: Lactated Ringer\'s Solution (RL)',
                      color: _orange,
                      isDark: isDark,
                      cs: cs,
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 12),

        // ── MAINTENANCE ───────────────────────────────────────────────────
        _resultBlock(
          cs: cs,
          isDark: isDark,
          color: _teal,
          icon: Icons.water_drop_outlined,
          title: 'Maintenance Fluid (Give Alongside Resuscitation)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _narLine(cs,
                  'In addition to resuscitation fluid, start maintenance IV fluid '
                  'using the Holliday-Segar rule:'),
              const SizedBox(height: 10),
              _rateBox(
                label: 'Maintenance rate:',
                rate: '${r.maintRate.toStringAsFixed(1)} mL/hr',
                fluid: 'Fluid: 0.9% Normal Saline or DNS (as clinically indicated)',
                color: _teal,
                isDark: isDark,
                cs: cs,
              ),
              const SizedBox(height: 10),
              _warningBox(
                '⚠️ Maintenance fluid is given IN ADDITION to resuscitation fluid — '
                'prescribe and run as a separate line.',
                _amber, isDark, cs),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── PHASE 2 ───────────────────────────────────────────────────────
        _resultBlock(
          cs: cs,
          isDark: isDark,
          color: _green,
          icon: Icons.hourglass_bottom_rounded,
          title: 'Phase 2 — Correction Phase (Hours 8–24 from Burn)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _narLine(cs, 'After initial 8-hour resuscitation is complete:'),
              _narLine(cs,
                  'Give the second half (${r.firstHalf.toStringAsFixed(0)} mL) '
                  'over the next 16 hours.'),
              const SizedBox(height: 10),
              _rateBox(
                label: '▶ Rate:',
                rate: '${r.phase2Rate.toStringAsFixed(1)} mL/hr',
                fluid: 'Fluid: Lactated Ringer\'s Solution (RL)',
                color: _green,
                isDark: isDark,
                cs: cs,
              ),
              const SizedBox(height: 10),
              _narLine(cs,
                  'Continue maintenance fluid at ${r.maintRate.toStringAsFixed(1)} mL/hr alongside.'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── URINE OUTPUT TARGETS ──────────────────────────────────────────
        _resultBlock(
          cs: cs,
          isDark: isDark,
          color: _accent,
          icon: Icons.monitor_heart_outlined,
          title: 'Urine Output Targets',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _narLine(cs,
                  'Monitor urine output every 1–2 hours to guide rate adjustments:'),
              const SizedBox(height: 10),
              _uoRow(cs, 'Paediatric target', '1 mL/kg/hr'),
              _uoRow(cs, 'Adult target', '0.5–1 mL/kg/hr  (30–50 mL/hr)'),
              const SizedBox(height: 10),
              _uoBanner('↑ UO below target', 'Increase rate by 10–20%', _red, isDark),
              const SizedBox(height: 6),
              _uoBanner('↓ UO above target', 'Decrease rate by 10–20%', _teal, isDark),
              const SizedBox(height: 10),
              _narLine(cs,
                  'Ongoing rate changes are guided by urine output and fluid status, '
                  'not by formula alone.'),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ── MORTALITY CHECK BUTTON ────────────────────────────────────────
        _buildMortalityButton(r),
      ],
    );
  }

  Widget _buildMortalityButton(_ParklandResult r) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF4A148C).withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BurnMortalityCalculator(initialTbsa: r.tbsa),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.monitor_heart_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Check Patient Mortality',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      SizedBox(height: 2),
                      Text('Revised Baux Score — mortality prediction',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11.5)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white54, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Result sub-widgets ────────────────────────────────────────────────────

  Widget _resultBlock({
    required ColorScheme cs,
    required bool isDark,
    required Color color,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(left: BorderSide(color: color, width: 3)),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: cs.onSurface.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 7),
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _narrativeText(
    ColorScheme cs,
    String text, {
    required String highlight,
    required Color highlightColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text,
            style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.8),
                fontSize: 13,
                height: 1.55)),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: highlightColor.withValues(alpha: 0.1),
            border: Border.all(color: highlightColor.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            highlight,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: highlightColor,
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _narLine(ColorScheme cs, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(text,
        style: TextStyle(
            color: cs.onSurface.withValues(alpha: 0.8),
            fontSize: 13,
            height: 1.5)),
  );

  Widget _rateBox({
    required String label,
    required String rate,
    required String fluid,
    required Color color,
    required bool isDark,
    required ColorScheme cs,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.13 : 0.07),
        border: Border.all(color: color.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.6),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(rate,
              style: TextStyle(
                  color: color,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  height: 1.1)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(fluid,
                style: TextStyle(
                    color: color,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _warningBox(String msg, Color color, bool isDark, ColorScheme cs) =>
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.1 : 0.06),
          border: Border.all(color: color.withValues(alpha: 0.35)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(msg,
            style: TextStyle(color: color, fontSize: 12.5, height: 1.45)),
      );

  Widget _uoRow(ColorScheme cs, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(children: [
      Expanded(child: Text(label,
          style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.65), fontSize: 12.5))),
      Text(value,
          style: TextStyle(
              color: cs.onSurface,
              fontSize: 12.5,
              fontWeight: FontWeight.w600)),
    ]),
  );

  Widget _uoBanner(String label, String action, Color color, bool isDark) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.12 : 0.07),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(children: [
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w700)),
          const Text('  →  ',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
          Expanded(child: Text(action,
              style: TextStyle(color: color, fontSize: 12))),
        ]),
      );

  // ── Shared card wrapper ────────────────────────────────────────────────────

  Widget _sectionCard({
    required ColorScheme cs,
    required String title,
    required IconData titleIcon,
    required Color titleColor,
    required Widget child,
  }) =>
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(titleIcon, color: titleColor, size: 16),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(title,
                      style: TextStyle(
                          color: titleColor,
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      );

  Widget _fieldLabel(String text, ColorScheme cs) => Text(text,
      style: TextStyle(
          color: cs.onSurface.withValues(alpha: 0.6),
          fontSize: 11.5,
          fontWeight: FontWeight.w600));

  InputDecoration _deco(ColorScheme cs, String hint, String suffix) =>
      InputDecoration(
        hintText: hint,
        suffixText: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                BorderSide(color: cs.onSurface.withValues(alpha: 0.15))),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        isDense: true,
      );
}

// ── Data model ────────────────────────────────────────────────────────────────

class _ParklandResult {
  final double weight, tbsa, time, fluids;
  final double total, firstHalf, adjusted;
  final double phase1Rate, phase2Rate;
  final double maintDaily, maintRate;
  final bool negAdjusted, invalidRate;

  const _ParklandResult({
    required this.weight,
    required this.tbsa,
    required this.time,
    required this.fluids,
    required this.total,
    required this.firstHalf,
    required this.adjusted,
    required this.phase1Rate,
    required this.phase2Rate,
    required this.maintDaily,
    required this.maintRate,
    required this.negAdjusted,
    required this.invalidRate,
  });
}
