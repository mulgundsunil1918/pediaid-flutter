import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Colour tokens (match GIR calculator) ─────────────────────────────────────
const Color _accent = Color(0xFF58a6ff);
const Color _green  = Color(0xFF3fb950);
const Color _amber  = Color(0xFFd29922);
const Color _teal   = Color(0xFF39d0c8);

// ── Fluid tables ──────────────────────────────────────────────────────────────

// Table 48.2 — first week — (low, high) mL/kg/day indexed by day-1 (0=Day1 … 5=Day6+)
const _kTermTable = [
  (60.0, 80.0),
  (80.0, 100.0),
  (100.0, 120.0),
  (120.0, 150.0),
  (140.0, 160.0),
  (140.0, 160.0), // Day 6+
];
const _kPreTermTable = [
  (80.0, 90.0),
  (100.0, 110.0),
  (120.0, 130.0),
  (130.0, 150.0),
  (140.0, 160.0),
  (160.0, 180.0), // Day 6+
];
// After first postnatal week (Table 48.3): same for both groups
const double _kPostWeekLow  = 140.0;
const double _kPostWeekHigh = 160.0;

// ── Calculator screen ─────────────────────────────────────────────────────────

class MaintenanceFluidCalculator extends StatefulWidget {
  const MaintenanceFluidCalculator({super.key});

  @override
  State<MaintenanceFluidCalculator> createState() =>
      _MaintenanceFluidCalculatorState();
}

class _MaintenanceFluidCalculatorState extends State<MaintenanceFluidCalculator>
    with SingleTickerProviderStateMixin {

  // ── Controllers ─────────────────────────────────────────────────────────────
  final _weightCtrl = TextEditingController();
  final _ageCtrl    = TextEditingController();
  final _formKey    = GlobalKey<FormState>();

  // ── Inputs ──────────────────────────────────────────────────────────────────
  int _ageMode = 0; // 0=Days  1=Months  2=Years

  // ── Results ─────────────────────────────────────────────────────────────────
  bool         _showResults = false;
  _FluidResult? _result;

  // ── Animation ────────────────────────────────────────────────────────────────
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
    _ageCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Logic ────────────────────────────────────────────────────────────────────

  // Age in days from raw input + mode
  int? _ageInDays(String raw) {
    final v = double.tryParse(raw.trim());
    if (v == null || v < 0) return null;
    return switch (_ageMode) {
      0 => v.round(),
      1 => (v * 30.4375).round(),
      _ => (v * 365.25).round(),
    };
  }

  void _calculate() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final weightKg  = double.tryParse(_weightCtrl.text.trim());
    final ageInDays = _ageInDays(_ageCtrl.text.trim());
    if (weightKg == null || ageInDays == null) return;

    _FluidResult result;

    if (ageInDays <= 28) {
      // ── Group A: Neonatal table ───────────────────────────────────────────
      final bool isPreterm = weightKg < 1.5;           // <1500 g
      final double low, high;

      if (ageInDays > 6) {
        // After first postnatal week
        low  = _kPostWeekLow;
        high = _kPostWeekHigh;
      } else {
        final row = isPreterm
            ? _kPreTermTable[ageInDays > 0 ? ageInDays - 1 : 0]
            : _kTermTable   [ageInDays > 0 ? ageInDays - 1 : 0];
        low  = row.$1;
        high = row.$2;
      }

      result = _FluidResult(
        formulaUsed : 'Neonatal Fluid Table (Table 48.2 / 48.3)',
        formulaTag  : 'neonatal',
        lowDaily    : low  * weightKg,
        highDaily   : high * weightKg,
        lowRate     : (low  * weightKg) / 24.0,
        highRate    : (high * weightKg) / 24.0,
        isRange     : true,
        weightKg    : weightKg,
        ageInDays   : ageInDays,
        isPreterm   : isPreterm,
        ratePerKgLow  : low,
        ratePerKgHigh : high,
      );
    } else {
      // ── Group B: Holliday-Segar ───────────────────────────────────────────
      if (weightKg < 3.5) {
        // Edge-case: older than 28d but very low weight → use post-week neonatal
        final low  = _kPostWeekLow;
        final high = _kPostWeekHigh;
        result = _FluidResult(
          formulaUsed : 'Neonatal Guideline (weight <3.5 kg)',
          formulaTag  : 'neonatal_low',
          lowDaily    : low  * weightKg,
          highDaily   : high * weightKg,
          lowRate     : (low  * weightKg) / 24.0,
          highRate    : (high * weightKg) / 24.0,
          isRange     : true,
          weightKg    : weightKg,
          ageInDays   : ageInDays,
          isPreterm   : true,
          ratePerKgLow  : low,
          ratePerKgHigh : high,
        );
      } else {
        final daily = _hollidaySegar(weightKg);
        result = _FluidResult(
          formulaUsed : 'Holliday-Segar (100/50/20 rule)',
          formulaTag  : 'holliday',
          lowDaily    : daily,
          highDaily   : daily,
          lowRate     : daily / 24.0,
          highRate    : daily / 24.0,
          isRange     : false,
          weightKg    : weightKg,
          ageInDays   : ageInDays,
          isPreterm   : false,
          ratePerKgLow  : daily / weightKg,
          ratePerKgHigh : daily / weightKg,
        );
      }
    }

    setState(() {
      _result      = result;
      _showResults = true;
    });
    _fadeCtrl.forward(from: 0);
  }

  double _hollidaySegar(double wt) {
    if (wt <= 10)  return wt * 100;
    if (wt <= 20)  return 1000 + (wt - 10) * 50;
    return 1500 + (wt - 20) * 20;
  }

  void _reset() {
    _weightCtrl.clear();
    _ageCtrl.clear();
    setState(() {
      _ageMode     = 0;
      _showResults = false;
      _result      = null;
    });
    _formKey.currentState?.reset();
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs    = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Maintenance Fluids',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(cs),
                const SizedBox(height: 16),
                _buildInputCard(cs, isDark),
                const SizedBox(height: 14),
                _buildButtons(cs),

                if (_showResults && _result != null) ...[
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: _buildResults(_result!, cs, isDark),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                _buildReferenceTable(cs, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────────

  Widget _buildHeader(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('NEONATAL & PAEDIATRIC TOOL',
              style: TextStyle(
                  color: cs.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2)),
        ),
        const SizedBox(height: 8),
        Text('Maintenance Fluid Calculator',
            style: TextStyle(
                color: cs.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
            'Neonatal Table (Table 48.2/48.3) · Holliday-Segar (>1 month)',
            style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.6), fontSize: 12.5)),
      ],
    );
  }

  // ── Input card ────────────────────────────────────────────────────────────────

  Widget _buildInputCard(ColorScheme cs, bool isDark) {
    return _card(
      cs: cs,
      title: 'Patient Parameters',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weight field
          _fieldLabel('Weight (kg)', cs),
          const SizedBox(height: 6),
          TextFormField(
            controller: _weightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
            ],
            decoration: _inputDeco(cs, 'e.g. 1.2 or 14', 'kg'),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              final n = double.tryParse(v.trim());
              if (n == null) return 'Invalid number';
              if (n <= 0 || n > 150) return 'Enter valid weight';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Age mode toggle
          _fieldLabel('Age', cs),
          const SizedBox(height: 8),
          _AgeModeToggle(
            selected: _ageMode,
            cs: cs,
            onChanged: (v) => setState(() {
              _ageMode = v;
              _ageCtrl.clear();
              _showResults = false;
              _result = null;
            }),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _ageCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _inputDeco(
              cs,
              _ageMode == 0 ? '1 – 365' : _ageMode == 1 ? '1 – 216' : '1 – 18',
              _ageMode == 0 ? 'days' : _ageMode == 1 ? 'months' : 'years',
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              final n = int.tryParse(v.trim());
              if (n == null) return 'Invalid';
              if (_ageMode == 0 && (n < 1 || n > 365)) return '1–365 days';
              if (_ageMode == 1 && (n < 1 || n > 216)) return '1–216 months';
              if (_ageMode == 2 && (n < 1 || n > 18))  return '1–18 years';
              return null;
            },
          ),

          // Helper note
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _accent.withValues(alpha: 0.2)),
            ),
            child: Text(
              '≤ 28 days → Neonatal fluid table  ·  > 28 days / ≥ 3.5 kg → Holliday-Segar',
              style: TextStyle(
                  color: _accent,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ── Buttons ───────────────────────────────────────────────────────────────────

  Widget _buildButtons(ColorScheme cs) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _calculate,
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text('Calculate',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 50,
          height: 50,
          child: OutlinedButton(
            onPressed: _reset,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: cs.onSurface.withValues(alpha: 0.2)),
              foregroundColor: cs.onSurface.withValues(alpha: 0.6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.zero,
            ),
            child: Text('↺',
                style: TextStyle(
                    fontSize: 22,
                    color: cs.onSurface.withValues(alpha: 0.6))),
          ),
        ),
      ],
    );
  }

  // ── Results ───────────────────────────────────────────────────────────────────

  Widget _buildResults(_FluidResult r, ColorScheme cs, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Formula badge
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _green.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.check_circle_outline, color: _green, size: 13),
              const SizedBox(width: 5),
              Text(r.formulaUsed,
                  style: const TextStyle(
                      color: _green,
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold)),
            ]),
          ),
        ]),
        const SizedBox(height: 12),

        // Result cards
        Row(children: [
          Expanded(child: _resultCard(
            label   : 'Total Daily Fluid',
            value   : r.isRange
                ? '${r.lowDaily.toStringAsFixed(0)} – ${r.highDaily.toStringAsFixed(0)}'
                : r.lowDaily.toStringAsFixed(0),
            unit    : 'mL / day',
            color   : _accent,
          )),
          const SizedBox(width: 10),
          Expanded(child: _resultCard(
            label   : 'IV Rate',
            value   : r.isRange
                ? '${r.lowRate.toStringAsFixed(1)} – ${r.highRate.toStringAsFixed(1)}'
                : r.lowRate.toStringAsFixed(1),
            unit    : 'mL / hr',
            color   : _teal,
          )),
          const SizedBox(width: 10),
          Expanded(child: _resultCard(
            label   : 'Rate / kg',
            value   : r.isRange
                ? '${r.ratePerKgLow.toStringAsFixed(0)} – ${r.ratePerKgHigh.toStringAsFixed(0)}'
                : r.ratePerKgLow.toStringAsFixed(0),
            unit    : 'mL / kg / day',
            color   : _green,
          )),
        ]),
        const SizedBox(height: 12),

        // Detail summary
        _card(
          cs: cs,
          title: '',
          child: Column(children: [
            _detailRow(cs, 'Weight',         '${r.weightKg.toStringAsFixed(2)} kg'),
            _detailRow(cs, 'Age',
                r.ageInDays <= 28
                    ? 'Day ${r.ageInDays} of life'
                    : '${r.ageInDays} days (${(r.ageInDays / 30.4).toStringAsFixed(1)} months)'),
            if (r.formulaTag == 'neonatal' || r.formulaTag == 'neonatal_low') ...[
              _detailRow(cs, 'Weight Group',
                  r.isPreterm ? '< 1500 g (Preterm <1500g group)' : '> 1500 g (Term / Preterm >1500g)'),
            ],
            if (r.formulaTag == 'holliday') ...[
              _detailRowHighlight(cs, 'Holliday-Segar', _hsBreakdown(r.weightKg)),
            ],
          ]),
        ),
        const SizedBox(height: 12),

        // Fluid choice info block
        _buildFluidInfoBlock(r, cs, isDark),
        const SizedBox(height: 10),

        // Warning banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: _amber.withValues(alpha: 0.08),
            border: Border.all(color: _amber.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '⚠️  Adjust for clinical status: phototherapy, radiant warmer, fever, '
            'RDS, SIADH, renal failure, or excess losses.',
            style: TextStyle(color: _amber, fontSize: 12, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _resultCard({
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color, fontSize: 10.5, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(value,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            Divider(color: color.withValues(alpha: 0.3), height: 12),
            Text(unit,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      );
    });
  }

  Widget _buildFluidInfoBlock(_FluidResult r, ColorScheme cs, bool isDark) {
    final bool isNeonatal = r.formulaTag == 'neonatal' || r.formulaTag == 'neonatal_low';
    final bool isEarlyNeo = isNeonatal && r.ageInDays <= 2;

    late String heading;
    late String body;

    if (r.formulaTag == 'holliday') {
      heading = 'Recommended Fluid — Holliday-Segar (>1 month)';
      body =
          '• Typically 0.9% NaCl in 5% Dextrose (N/S + D5).\n'
          '• Or as clinically indicated.\n'
          '• Add KCl 20 mEq/L once urine output confirmed.';
    } else if (isEarlyNeo) {
      heading = 'Recommended Fluid — Neonates Day 1–2';
      body =
          '• Typically 10% Dextrose. No electrolytes initially.\n'
          '• Add Na⁺ and K⁺ from Day 2–3 once urine output is established.';
    } else {
      heading = 'Recommended Fluid — Neonates Day 3+';
      body =
          '• 0.9% NaCl in 10% Dextrose, or as per TPN prescription.\n'
          '• Electrolyte requirements: Na⁺ 2–3 mEq/kg/d, K⁺ 1–2 mEq/kg/d.';
    }

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _teal.withValues(alpha: isDark ? 0.1 : 0.06),
        border: Border.all(color: _teal.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.water_drop_outlined, color: _teal, size: 15),
            const SizedBox(width: 6),
            Expanded(
              child: Text(heading,
                  style: const TextStyle(
                      color: _teal,
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold)),
            ),
          ]),
          const SizedBox(height: 8),
          Text(body,
              style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.75),
                  fontSize: 12.5,
                  height: 1.55)),
        ],
      ),
    );
  }

  String _hsBreakdown(double wt) {
    if (wt <= 10)  return '${wt.toStringAsFixed(2)} kg × 100 = ${(wt * 100).toStringAsFixed(0)} mL';
    if (wt <= 20)  return '1000 + ${(wt - 10).toStringAsFixed(1)} kg × 50 = ${(1000 + (wt - 10) * 50).toStringAsFixed(0)} mL';
    return '1500 + ${(wt - 20).toStringAsFixed(1)} kg × 20 = ${(1500 + (wt - 20) * 20).toStringAsFixed(0)} mL';
  }

  // ── Reference table ───────────────────────────────────────────────────────────

  Widget _buildReferenceTable(ColorScheme cs, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text('Reference — Fluid Tables',
              style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold)),
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding:
              const EdgeInsets.fromLTRB(14, 0, 14, 14),
          children: [
            // ── Table 48.2 ─────────────────────────────────────────────────
            _refSubtitle('Table 48.2 — Parenteral Fluid Requirements (First Week)', cs),
            const SizedBox(height: 8),
            _table482(cs, isDark),
            const SizedBox(height: 14),

            // ── Table 48.3 ─────────────────────────────────────────────────
            _refSubtitle('Table 48.3 — After First Postnatal Week', cs),
            const SizedBox(height: 8),
            _table483(cs, isDark),
            const SizedBox(height: 14),

            // ── Holliday-Segar ─────────────────────────────────────────────
            _refSubtitle('Holliday-Segar — 100/50/20 Rule (>1 month, ≥3.5 kg)', cs),
            const SizedBox(height: 8),
            _tableHS(cs, isDark),
          ],
        ),
      ),
    );
  }

  Widget _refSubtitle(String text, ColorScheme cs) => Text(text,
      style: TextStyle(
          color: cs.primary,
          fontSize: 12,
          fontWeight: FontWeight.w700));

  Widget _table482(ColorScheme cs, bool isDark) {
    const headers = ['Day', '>1500 g\nmL/kg/day', '<1500 g\nmL/kg/day'];
    const rows = [
      ['1', '60 – 80', '80 – 90'],
      ['2', '80 – 100', '100 – 110'],
      ['3', '100 – 120', '120 – 130'],
      ['4', '120 – 150', '130 – 150'],
      ['5', '140 – 160', '140 – 160'],
      ['6+', '140 – 160', '160 – 180'],
    ];
    return _refTable(headers: headers, rows: rows, cs: cs, isDark: isDark);
  }

  Widget _table483(ColorScheme cs, bool isDark) {
    const headers = ['Group', 'mL/kg/day'];
    const rows = [
      ['Term neonates',    '140 – 160'],
      ['Preterm neonates', '140 – 160'],
    ];
    return _refTable(headers: headers, rows: rows, cs: cs, isDark: isDark);
  }

  Widget _tableHS(ColorScheme cs, bool isDark) {
    const headers = ['Weight', 'Fluid rate'];
    const rows = [
      ['First 10 kg',    '100 mL/kg/day'],
      ['Next 10 kg',     '+50 mL/kg/day  (10–20 kg)'],
      ['Above 20 kg',    '+20 mL/kg/day'],
      ['e.g. 25 kg', '1500 + 5×20 = 1600 mL/day'],
    ];
    return _refTable(headers: headers, rows: rows, cs: cs, isDark: isDark);
  }

  Widget _refTable({
    required List<String> headers,
    required List<List<String>> rows,
    required ColorScheme cs,
    required bool isDark,
  }) {
    final headerBg = cs.primary.withValues(alpha: isDark ? 0.22 : 0.1);
    final altBg    = cs.onSurface.withValues(alpha: 0.03);
    final border   = cs.onSurface.withValues(alpha: 0.12);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Table(
        border: TableBorder.all(color: border, width: 0.8,
            borderRadius: BorderRadius.circular(8)),
        columnWidths: {
          for (int i = 0; i < headers.length; i++)
            i: const FlexColumnWidth(),
        },
        children: [
          // Header row
          TableRow(
            decoration: BoxDecoration(color: headerBg),
            children: headers.map((h) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text(h,
                  style: TextStyle(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.5)),
            )).toList(),
          ),
          // Data rows
          ...rows.asMap().entries.map((e) {
            final idx = e.key;
            final row = e.value;
            return TableRow(
              decoration: BoxDecoration(
                  color: idx.isOdd ? altBg : null),
              children: row.map((cell) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Text(cell,
                    style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 12)),
              )).toList(),
            );
          }),
        ],
      ),
    );
  }

  // ── Shared helpers ────────────────────────────────────────────────────────────

  Widget _card({
    required ColorScheme cs,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(title,
                style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }

  Widget _fieldLabel(String text, ColorScheme cs) => Text(text,
      style: TextStyle(
          color: cs.onSurface.withValues(alpha: 0.6),
          fontSize: 11.5,
          fontWeight: FontWeight.w600));

  InputDecoration _inputDeco(ColorScheme cs, String hint, String suffix) =>
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

  Widget _detailRow(ColorScheme cs, String key, String value) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Expanded(flex: 4,
                child: Text(key,
                    style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.6),
                        fontSize: 12.5))),
            Expanded(flex: 6,
                child: Text(value,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600))),
          ],
        ),
      );

  Widget _detailRowHighlight(ColorScheme cs, String key, String value) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Expanded(flex: 4,
                child: Text(key,
                    style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.6),
                        fontSize: 12.5))),
            Expanded(flex: 6,
                child: Text(value,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: cs.primary,
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold))),
          ],
        ),
      );
}

// ── Age mode toggle widget ────────────────────────────────────────────────────

class _AgeModeToggle extends StatelessWidget {
  final int selected;
  final ColorScheme cs;
  final ValueChanged<int> onChanged;

  const _AgeModeToggle({
    required this.selected,
    required this.cs,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const labels = ['Days', 'Months', 'Years'];
    return Row(
      children: List.generate(3, (i) {
        final isActive = selected == i;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 2 ? 8 : 0),
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isActive
                      ? cs.primary.withValues(alpha: 0.15)
                      : cs.onSurface.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isActive
                        ? cs.primary.withValues(alpha: 0.6)
                        : cs.outline.withValues(alpha: 0.25),
                    width: isActive ? 1.5 : 1,
                  ),
                ),
                child: Text(labels[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isActive
                            ? cs.primary
                            : cs.onSurface.withValues(alpha: 0.5))),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

class _FluidResult {
  final String formulaUsed;
  final String formulaTag;    // 'neonatal' | 'neonatal_low' | 'holliday'
  final double lowDaily;      // mL/day
  final double highDaily;     // mL/day (= lowDaily for Holliday-Segar)
  final double lowRate;       // mL/hr
  final double highRate;      // mL/hr
  final bool   isRange;
  final double weightKg;
  final int    ageInDays;
  final bool   isPreterm;
  final double ratePerKgLow;  // mL/kg/day
  final double ratePerKgHigh;

  const _FluidResult({
    required this.formulaUsed,
    required this.formulaTag,
    required this.lowDaily,
    required this.highDaily,
    required this.lowRate,
    required this.highRate,
    required this.isRange,
    required this.weightKg,
    required this.ageInDays,
    required this.isPreterm,
    required this.ratePerKgLow,
    required this.ratePerKgHigh,
  });
}
