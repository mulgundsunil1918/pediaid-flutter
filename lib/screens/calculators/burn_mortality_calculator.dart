import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Colour tokens ─────────────────────────────────────────────────────────────
const Color _headerColor = Color(0xFF4A148C); // deep purple for mortality risk

class BurnMortalityCalculator extends StatefulWidget {
  /// Optional: pre-fill TBSA when navigating from Parkland Calculator.
  final double? initialTbsa;

  const BurnMortalityCalculator({super.key, this.initialTbsa});

  @override
  State<BurnMortalityCalculator> createState() =>
      _BurnMortalityCalculatorState();
}

class _BurnMortalityCalculatorState extends State<BurnMortalityCalculator>
    with SingleTickerProviderStateMixin {
  // ── Form ──────────────────────────────────────────────────────────────────
  final _formKey    = GlobalKey<FormState>();
  late final TextEditingController _tbsaCtrl;
  final TextEditingController _ageCtrl = TextEditingController();

  bool _inhalation  = false; // false = No (0), true = Yes (1)
  bool _showResult  = false;
  int  _baux        = 0;

  // ── Animation ─────────────────────────────────────────────────────────────
  late AnimationController _fadeCtrl;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();
    _tbsaCtrl = TextEditingController(
      text: widget.initialTbsa != null
          ? widget.initialTbsa!.toStringAsFixed(1)
          : '',
    );
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim  = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));

    // If TBSA pre-filled, auto-calculate once age is entered
  }

  @override
  void dispose() {
    _tbsaCtrl.dispose();
    _ageCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Logic ─────────────────────────────────────────────────────────────────

  void _calculate() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final tbsa = double.parse(_tbsaCtrl.text.trim());
    final age  = double.parse(_ageCtrl.text.trim());
    final r    = _inhalation ? 1 : 0;

    setState(() {
      _baux       = (tbsa + age + 17 * r).round();
      _showResult = true;
    });
    _fadeCtrl.forward(from: 0);
  }

  void _reset() {
    _tbsaCtrl.text = widget.initialTbsa != null
        ? widget.initialTbsa!.toStringAsFixed(1)
        : '';
    _ageCtrl.clear();
    setState(() {
      _inhalation = false;
      _showResult = false;
      _baux       = 0;
    });
    _formKey.currentState?.reset();
    _fadeCtrl.reset();
  }

  // ── Mortality category ────────────────────────────────────────────────────

  _MortalityCategory get _category {
    if (_baux > 140) {
      return _MortalityCategory(
        label: 'Near 100% Mortality',
        range: 'Score > 140',
        color: const Color(0xFF1A0000),
        textColor: const Color(0xFFFF1744),
        bgColor: const Color(0xFFFF1744),
        icon: Icons.dangerous_rounded,
        description: 'Extremely high mortality. Near-certain death in most populations.',
      );
    }
    if (_baux > 110) {
      return _MortalityCategory(
        label: 'Very High Mortality',
        range: 'Score > 110 · >90% predicted',
        color: const Color(0xFFB71C1C),
        textColor: const Color(0xFFB71C1C),
        bgColor: const Color(0xFFB71C1C),
        icon: Icons.warning_rounded,
        description: 'Very high predicted mortality. Aggressive palliative and supportive care should be considered.',
      );
    }
    if (_baux >= 90) {
      return _MortalityCategory(
        label: 'High Mortality',
        range: 'Score 90–110 · 50–75% predicted',
        color: const Color(0xFFE65100),
        textColor: const Color(0xFFE65100),
        bgColor: const Color(0xFFE65100),
        icon: Icons.priority_high_rounded,
        description: 'High predicted mortality. Requires burn ICU care and multidisciplinary team.',
      );
    }
    if (_baux >= 70) {
      return _MortalityCategory(
        label: 'Moderate Mortality',
        range: 'Score 70–90 · 10–50% predicted',
        color: const Color(0xFFF57F17),
        textColor: const Color(0xFFF57F17),
        bgColor: const Color(0xFFF57F17),
        icon: Icons.error_outline_rounded,
        description: 'Moderate predicted mortality. Close monitoring and early intervention essential.',
      );
    }
    return _MortalityCategory(
      label: 'Low Mortality',
      range: 'Score < 70 · <5% predicted',
      color: const Color(0xFF2E7D32),
      textColor: const Color(0xFF2E7D32),
      bgColor: const Color(0xFF2E7D32),
      icon: Icons.check_circle_outline_rounded,
      description: 'Low predicted mortality. Standard burn unit care recommended.',
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Burn Mortality Calculator',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.refresh, size: 17),
            label: const Text('Reset'),
            style: TextButton.styleFrom(foregroundColor: _headerColor),
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
              // ── Header ───────────────────────────────────────────────────
              _buildHeader(cs),
              const SizedBox(height: 14),

              // ── Pre-fill notice ───────────────────────────────────────────
              if (widget.initialTbsa != null)
                _buildPrefillBanner(cs, isDark),
              if (widget.initialTbsa != null) const SizedBox(height: 12),

              // ── Input form ────────────────────────────────────────────────
              Form(
                key: _formKey,
                child: _buildInputCard(cs, isDark),
              ),
              const SizedBox(height: 14),

              // ── Calculate button ──────────────────────────────────────────
              ElevatedButton.icon(
                onPressed: _calculate,
                icon: const Icon(Icons.calculate_rounded, size: 18),
                label: const Text('Calculate Revised Baux Score',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _headerColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),

              // ── Result ────────────────────────────────────────────────────
              if (_showResult) ...[
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: _buildResult(cs, isDark),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(ColorScheme cs) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _headerColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text('BURNS MORTALITY RISK',
            style: TextStyle(
                color: _headerColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2)),
      ),
      const SizedBox(height: 8),
      Text('Revised Baux Score',
          style: TextStyle(
              color: cs.onSurface, fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Text('Predicted mortality from burn injury',
          style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.6), fontSize: 12.5)),
    ],
  );

  // ── Pre-fill banner ───────────────────────────────────────────────────────

  Widget _buildPrefillBanner(ColorScheme cs, bool isDark) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: _headerColor.withValues(alpha: isDark ? 0.12 : 0.07),
      border: Border.all(color: _headerColor.withValues(alpha: 0.3)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        const Icon(Icons.link_rounded, color: _headerColor, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'TBSA pre-filled from Parkland Calculator '
            '(${widget.initialTbsa!.toStringAsFixed(1)}%). '
            'Enter Age and Inhalation Injury to complete.',
            style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.75),
                fontSize: 12,
                height: 1.4),
          ),
        ),
      ],
    ),
  );

  // ── Input card ────────────────────────────────────────────────────────────

  Widget _buildInputCard(ColorScheme cs, bool isDark) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Row(
          children: [
            Icon(Icons.edit_note_rounded,
                color: _headerColor, size: 16),
            const SizedBox(width: 7),
            Text('Patient Parameters',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                    color: cs.onSurface)),
          ],
        ),
        const SizedBox(height: 14),

        // TBSA
        _fieldLabel('TBSA (%)', cs),
        const SizedBox(height: 6),
        TextFormField(
          controller: _tbsaCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          decoration: _deco(cs, 'e.g. 35', '%'),
          validator: (v) {
            final n = double.tryParse(v?.trim() ?? '');
            if (n == null || n <= 0) return 'Required';
            if (n > 100) return '1 – 100%';
            return null;
          },
        ),
        const SizedBox(height: 14),

        // Age
        _fieldLabel('Age (years)', cs),
        const SizedBox(height: 6),
        TextFormField(
          controller: _ageCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: _deco(cs, 'e.g. 45', 'yrs'),
          validator: (v) {
            final n = int.tryParse(v?.trim() ?? '');
            if (n == null || n < 0) return 'Required';
            if (n > 120) return 'Enter valid age';
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Inhalation injury toggle
        _fieldLabel('Inhalation Injury', cs),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _inhalationBtn(false, 'No', 'R = 0', cs)),
            const SizedBox(width: 10),
            Expanded(child: _inhalationBtn(true, 'Yes', 'R = 1  (+17 pts)', cs)),
          ],
        ),
      ],
    ),
  );

  Widget _inhalationBtn(bool value, String label, String sub, ColorScheme cs) {
    final selected = _inhalation == value;
    final color    = value ? const Color(0xFFB71C1C) : const Color(0xFF2E7D32);
    return GestureDetector(
      onTap: () => setState(() => _inhalation = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: selected ? color : color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: selected ? Colors.white : color)),
            const SizedBox(height: 2),
            Text(sub,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10.5,
                    color: selected ? Colors.white70 : cs.onSurface.withValues(alpha: 0.45))),
          ],
        ),
      ),
    );
  }

  // ── Result ────────────────────────────────────────────────────────────────

  Widget _buildResult(ColorScheme cs, bool isDark) {
    final cat = _category;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Score card ──────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                cat.bgColor.withValues(alpha: 0.9),
                cat.bgColor.withValues(alpha: 0.65),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: cat.bgColor.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4)),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(cat.icon, color: Colors.white, size: 22),
                  const SizedBox(width: 8),
                  Text(cat.label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ],
              ),
              const SizedBox(height: 4),
              Text(cat.range,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Revised Baux Score',
                          style: TextStyle(color: Colors.white70, fontSize: 11)),
                      Text('$_baux',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 56,
                              fontWeight: FontWeight.w900,
                              height: 1.0)),
                    ],
                  ),
                  const Spacer(),
                  // Breakdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _scoreChip('TBSA', '${double.parse(_tbsaCtrl.text.trim()).toStringAsFixed(1)}%'),
                      const SizedBox(height: 4),
                      _scoreChip('Age', '${_ageCtrl.text.trim()} yrs'),
                      const SizedBox(height: 4),
                      _scoreChip('Inhalation',
                          _inhalation ? '+17 pts' : '+0 pts'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── Formula breakdown ───────────────────────────────────────────
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
                  Icon(Icons.functions_rounded,
                      color: _headerColor, size: 16),
                  const SizedBox(width: 7),
                  Text('Score Breakdown',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: _headerColor)),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: _headerColor.withValues(alpha: isDark ? 0.1 : 0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'R-Baux = TBSA + Age + (17 × R)\n'
                  '       = ${double.parse(_tbsaCtrl.text.trim()).toStringAsFixed(1)} + ${_ageCtrl.text.trim()} + (17 × ${_inhalation ? 1 : 0})\n'
                  '       = $_baux',
                  style: TextStyle(
                      fontFamily: 'monospace',
                      color: _headerColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.6),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // ── Clinical explanation ────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
                left: BorderSide(color: _headerColor, width: 3)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: _headerColor, size: 16),
                  const SizedBox(width: 7),
                  Text('Clinical Interpretation',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: _headerColor)),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Baux score in which TBSA is total burn surface area '
                '(burn area). R = 1 if there is an inhalation injury, '
                'while R = 0 if there is no inhalation injury.',
                style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.8),
                    fontSize: 13,
                    height: 1.6),
              ),
              const SizedBox(height: 10),
              Text(cat.description,
                  style: TextStyle(
                      color: cat.textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.5)),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // ── Mortality range reference ───────────────────────────────────
        _MortalityTable(cs: cs, isDark: isDark, currentScore: _baux),
      ],
    );
  }

  Widget _scoreChip(String label, String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ',
            style: const TextStyle(
                color: Colors.white60, fontSize: 11)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11)),
      ],
    ),
  );

  // ── Shared helpers ────────────────────────────────────────────────────────

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

// ── Mortality table ───────────────────────────────────────────────────────────

class _MortalityTable extends StatelessWidget {
  final ColorScheme cs;
  final bool isDark;
  final int currentScore;

  const _MortalityTable({
    required this.cs,
    required this.isDark,
    required this.currentScore,
  });

  static const _rows = [
    _MortalityRow('< 70',  'Low',           '< 5%',     Color(0xFF2E7D32)),
    _MortalityRow('70–90', 'Moderate',       '10–50%',   Color(0xFFF57F17)),
    _MortalityRow('90–110','High',           '50–75%',   Color(0xFFE65100)),
    _MortalityRow('> 110', 'Very High',      '> 90%',    Color(0xFFB71C1C)),
    _MortalityRow('> 140', 'Near Certain',   '~100%',    Color(0xFF7B0000)),
  ];

  bool _isActive(_MortalityRow row) {
    if (row.range == '< 70'  && currentScore < 70)  return true;
    if (row.range == '70–90' && currentScore >= 70 && currentScore <= 90) return true;
    if (row.range == '90–110'&& currentScore >= 90 && currentScore <= 110) return true;
    if (row.range == '> 110' && currentScore > 110 && currentScore <= 140) return true;
    if (row.range == '> 140' && currentScore > 140) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Icon(Icons.table_chart_outlined,
                  color: _headerColor, size: 16),
              const SizedBox(width: 7),
              Text('Mortality Category Reference',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: _headerColor)),
            ],
          ),
          const SizedBox(height: 12),
          ..._rows.map((row) {
            final active = _isActive(row);
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: active
                    ? row.color.withValues(alpha: isDark ? 0.2 : 0.1)
                    : Colors.transparent,
                border: Border.all(
                  color: active
                      ? row.color.withValues(alpha: 0.5)
                      : cs.onSurface.withValues(alpha: 0.07),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(row.range,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.5,
                            color: active
                                ? row.color
                                : cs.onSurface.withValues(alpha: 0.5))),
                  ),
                  Expanded(
                    child: Text(row.label,
                        style: TextStyle(
                            fontWeight: active
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12.5,
                            color: active
                                ? row.color
                                : cs.onSurface.withValues(alpha: 0.6))),
                  ),
                  Text(row.mortality,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                          color: active
                              ? row.color
                              : cs.onSurface.withValues(alpha: 0.5))),
                  if (active) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: row.color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('YOU',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Data models ───────────────────────────────────────────────────────────────

class _MortalityCategory {
  final String label, range, description;
  final Color  color, textColor, bgColor;
  final IconData icon;

  const _MortalityCategory({
    required this.label,
    required this.range,
    required this.description,
    required this.color,
    required this.textColor,
    required this.bgColor,
    required this.icon,
  });
}

class _MortalityRow {
  final String range, label, mortality;
  final Color  color;
  const _MortalityRow(this.range, this.label, this.mortality, this.color);
}
