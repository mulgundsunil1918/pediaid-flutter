import 'package:flutter/material.dart';
import 'dart:math';
import '../../widgets/ios_feature_gate.dart';
import '../../widgets/educational_disclaimer_banner.dart';

const Color _green = Color(0xFF3fb950);
const Color _amber = Color(0xFFd29922);
const Color _red = Color(0xFFf85149);
const Color _orange = Color(0xFFe8822a);

const List<int> _stocks = [0, 5, 10, 25, 50];

class GIRCalculator extends StatefulWidget {
  const GIRCalculator({super.key});

  @override
  State<GIRCalculator> createState() => _GIRCalculatorState();
}

class _GIRCalculatorState extends State<GIRCalculator>
    with SingleTickerProviderStateMixin {
  // ── Tab state ────────────────────────────────────────────────────────────
  int _tabIndex = 0;

  // ── GIR Calculator state ─────────────────────────────────────────────────
  final _girTargetCtrl = TextEditingController();
  final _girVolCtrl = TextEditingController();
  final _girWeightCtrl = TextEditingController();
  _GIRCalcResult? _girResult;

  // ── Glucose Mixer state ──────────────────────────────────────────────────
  final _mixTargetPctCtrl = TextEditingController();
  final _mixTotalVolCtrl = TextEditingController();
  int _mixStockA = 5;
  int _mixStockB = 10;
  _MixResult? _mixResult;

  // ── Calories Calculator state ────────────────────────────────────────────
  final _calDextrosePctCtrl = TextEditingController();
  final _calVolumeCtrl = TextEditingController();
  final _calWeightCtrl = TextEditingController();
  _CaloriesResult? _calResult;

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _girTargetCtrl.dispose();
    _girVolCtrl.dispose();
    _girWeightCtrl.dispose();
    _mixTargetPctCtrl.dispose();
    _mixTotalVolCtrl.dispose();
    _calDextrosePctCtrl.dispose();
    _calVolumeCtrl.dispose();
    _calWeightCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Shared two-stock mixing math ─────────────────────────────────────────
  // Given a target %, total volume, and two stock concentrations, returns
  // how much of each to combine (or an error if the target is unreachable
  // with that pair). Used by both the GIR tab's auto-pick and the Mixer
  // tab's manual selection, and by the GIR result's stock override.
  ({double volA, double volB, String? error}) _mixVolumes(
      double targetPct, double totalVol, int stockA, int stockB) {
    final a = stockA.toDouble();
    final b = stockB.toDouble();

    if ((a - b).abs() < 0.001) {
      final matches = (a - targetPct).abs() < 0.001;
      return (
        volA: totalVol,
        volB: 0,
        error: matches
            ? null
            : 'Both stocks are D$stockA% — cannot reach ${targetPct.toStringAsFixed(1)}%',
      );
    }

    final v1 = totalVol * (targetPct - b) / (a - b);
    final v2 = totalVol - v1;
    if (v1 < -0.5 || v2 < -0.5) {
      return (
        volA: 0,
        volB: 0,
        error: 'Target ${targetPct.toStringAsFixed(1)}% is outside D$stockA%–D$stockB% range',
      );
    }
    return (volA: max(0, v1), volB: max(0, v2), error: null);
  }

  // ── GIR Calculation ──────────────────────────────────────────────────────
  void _calculateGIR() {
    final gir = double.tryParse(_girTargetCtrl.text);
    final vol = double.tryParse(_girVolCtrl.text);
    final weightG = double.tryParse(_girWeightCtrl.text);

    if (gir == null || vol == null || weightG == null ||
        gir <= 0 || vol <= 0 || weightG <= 0) {
      setState(() => _girResult = null);
      return;
    }

    final weightKg = weightG / 1000.0;
    final targetPct = gir * weightKg * 144.0 / vol;
    final safety = _safetyInfo(targetPct);

    // Auto-pick best two stocks
    int? lower, higher;
    for (final s in _stocks) {
      if (s <= targetPct) lower = s;
      if (s >= targetPct && higher == null) higher = s;
    }
    final a = lower ?? 0;
    final b = higher ?? 50;
    final mix = _mixVolumes(targetPct, vol, a, b);

    setState(() {
      _girResult = _GIRCalcResult(
        targetPct: targetPct,
        stockA: a,
        stockB: b,
        volA: mix.volA,
        volB: mix.volB,
        safety: safety,
        mixError: mix.error,
        weightG: weightG,
        weightKg: weightKg,
        totalVol: vol,
        gir: gir,
      );
    });
    _fadeCtrl.forward(from: 0);
  }

  // Called from the result's stock dropdowns — re-mixes with the overridden
  // stock(s) while keeping the same target % / volume from the calculation.
  void _overrideGIRStock({int? stockA, int? stockB}) {
    final r = _girResult;
    if (r == null) return;
    final newA = stockA ?? r.stockA;
    final newB = stockB ?? r.stockB;
    final mix = _mixVolumes(r.targetPct, r.totalVol, newA, newB);
    setState(() {
      _girResult = _GIRCalcResult(
        targetPct: r.targetPct,
        stockA: newA,
        stockB: newB,
        volA: mix.volA,
        volB: mix.volB,
        safety: r.safety,
        mixError: mix.error,
        weightG: r.weightG,
        weightKg: r.weightKg,
        totalVol: r.totalVol,
        gir: r.gir,
      );
    });
  }

  // ── Glucose Mixer Calculation ────────────────────────────────────────────
  void _calculateMix() {
    final targetPct = double.tryParse(_mixTargetPctCtrl.text);
    final totalVol = double.tryParse(_mixTotalVolCtrl.text);

    if (targetPct == null || totalVol == null ||
        targetPct < 0 || totalVol <= 0) {
      setState(() => _mixResult = null);
      return;
    }

    final mix = _mixVolumes(targetPct, totalVol, _mixStockA, _mixStockB);

    setState(() {
      _mixResult = _MixResult(
        stockA: _mixStockA, stockB: _mixStockB,
        volA: mix.volA, volB: mix.volB,
        totalVol: totalVol, actualPct: targetPct, error: mix.error,
      );
    });
    _fadeCtrl.forward(from: 0);
  }

  // ── Calories Calculation ─────────────────────────────────────────────────
  void _calculateCalories() {
    final dexPct = double.tryParse(_calDextrosePctCtrl.text);
    final vol = double.tryParse(_calVolumeCtrl.text);
    final weightG = double.tryParse(_calWeightCtrl.text);

    if (dexPct == null || vol == null || weightG == null ||
        dexPct < 0 || vol <= 0 || weightG <= 0) {
      setState(() => _calResult = null);
      return;
    }

    final weightKg = weightG / 1000.0;
    final dextroseG = dexPct / 100.0 * vol;
    final kcal = dextroseG * 3.4;
    final kcalPerKg = kcal / weightKg;
    final girVal = (dextroseG * 1000.0) / (weightKg * 1440.0);

    setState(() {
      _calResult = _CaloriesResult(
        dextroseG: dextroseG,
        kcal: kcal,
        kcalPerKg: kcalPerKg,
        gir: girVal,
        weightKg: weightKg,
      );
    });
    _fadeCtrl.forward(from: 0);
  }

  _SafetyInfo _safetyInfo(double pct) {
    if (pct <= 12.5) {
      return _SafetyInfo(
        icon: Icons.check_circle,
        msg: 'Safe for peripheral infusion',
        color: _green,
      );
    } else if (pct <= 20.0) {
      return _SafetyInfo(
        icon: Icons.warning_amber_rounded,
        msg: 'Caution — prefer central line if prolonged',
        color: _amber,
      );
    } else {
      return _SafetyInfo(
        icon: Icons.dangerous,
        msg: 'Central line strongly recommended',
        color: _red,
      );
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return IosFeatureGate(
      featureName: 'GIR Calculator',
      description:
          'Glucose infusion rate calculation is available on the PediAid web app with full clinical references.',
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('GIR Calculator',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          elevation: 0,
        ),
        body: Column(
          children: [
            const EducationalDisclaimerBanner(),
            _buildTabBar(),
            Expanded(
              child: IndexedStack(
                index: _tabIndex,
                children: [
                  _buildGIRTab(),
                  _buildMixerTab(),
                  _buildCaloriesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tab bar ──────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    final cs = Theme.of(context).colorScheme;
    const tabs = ['GIR Calculator', 'Glucose Mixer', 'Calories Calc'];
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = _tabIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tabIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? _orange : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tabs[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? Colors.white : cs.onSurface.withValues(alpha: 0.6),
                    fontSize: 12.5,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 1: GIR Calculator
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildGIRTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _inputField('Target GIR value', _girTargetCtrl, 'mg/kg/min', 'e.g. 6'),
          const SizedBox(height: 12),
          _inputField('Glucose volume (per day)', _girVolCtrl, 'mL', 'e.g. 220'),
          const SizedBox(height: 12),
          _inputField('Patient weight', _girWeightCtrl, 'grams', 'e.g. 1850'),
          const SizedBox(height: 18),
          _orangeButton('Calculate', _calculateGIR),
          if (_girResult != null) ...[
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _fadeAnim,
              child: _buildGIRResults(_girResult!),
            ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildGIRResults(_GIRCalcResult r) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Required dextrose concentration hero
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_orange, _orange.withValues(alpha: 0.85)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text('REQUIRED DEXTROSE',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1)),
              const SizedBox(height: 4),
              Text('${r.targetPct.toStringAsFixed(1)}%',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Override the auto-picked stock solutions
        Text('Prepare using',
            style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.6),
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        _girStockDropdowns(r),
        const SizedBox(height: 12),
        // Mixing volumes
        if (r.mixError == null) ...[
          _mixResultRow(
            'D${r.stockA}%',
            '${r.volA.toStringAsFixed(1)} mL',
            'D${r.stockB}%',
            '${r.volB.toStringAsFixed(1)} mL',
            '${r.targetPct.toStringAsFixed(1)}%',
            '${r.totalVol.toStringAsFixed(0)} mL',
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _red.withValues(alpha: 0.1),
              border: Border.all(color: _red.withValues(alpha: 0.4)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(r.mixError!,
                style: const TextStyle(color: _red, fontSize: 13)),
          ),
        ],
        const SizedBox(height: 12),
        // Safety indicator
        _safetyBanner(r.safety),
        const SizedBox(height: 12),
        // Detail card
        _detailCard([
          _dRow('Patient Weight', '${r.weightG.toInt()} g (${r.weightKg.toStringAsFixed(3)} kg)'),
          _dRow('Glucose Volume', '${r.totalVol.toInt()} mL/day'),
          _dRow('Target GIR', '${r.gir.toStringAsFixed(1)} mg/kg/min'),
          _dRow('Dextrose/day', '${(r.targetPct / 100.0 * r.totalVol).toStringAsFixed(1)} g'),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text('Formula: % = GIR x wt(kg) x 144 / vol(mL)',
                style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.5),
                    fontSize: 11,
                    fontStyle: FontStyle.italic)),
          ),
        ]),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 2: Glucose Mixer
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildMixerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _inputField('Target dextrose %', _mixTargetPctCtrl, '%', 'e.g. 7.3'),
          const SizedBox(height: 12),
          _inputField('Total volume', _mixTotalVolCtrl, 'mL', 'e.g. 220'),
          const SizedBox(height: 12),
          _stockDropdowns(),
          const SizedBox(height: 18),
          _orangeButton('Calculate Mix', _calculateMix),
          if (_mixResult != null) ...[
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _fadeAnim,
              child: _buildMixResults(_mixResult!),
            ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _stockDropdowns() {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Stock A (lower)',
                  style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              _stockDropdown(_mixStockA, (v) => setState(() => _mixStockA = v)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Stock B (higher)',
                  style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              _stockDropdown(_mixStockB, (v) => setState(() => _mixStockB = v)),
            ],
          ),
        ),
      ],
    );
  }

  // Stock override dropdowns shown on the GIR tab's result — lets the user
  // pick different stock solutions than the auto-picked pair.
  Widget _girStockDropdowns(_GIRCalcResult r) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Stock A (lower)',
                  style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              _stockDropdown(r.stockA, (v) => _overrideGIRStock(stockA: v)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Stock B (higher)',
                  style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              _stockDropdown(r.stockB, (v) => _overrideGIRStock(stockB: v)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stockDropdown(int value, void Function(int) onChanged) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: cs.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<int>(
        value: value,
        isExpanded: true,
        dropdownColor: Theme.of(context).cardColor,
        underline: const SizedBox(),
        style: TextStyle(color: cs.onSurface, fontSize: 14),
        items: _stocks.map((s) => DropdownMenuItem(
          value: s,
          child: Text('D$s%', style: TextStyle(color: cs.onSurface)),
        )).toList(),
        onChanged: (v) { if (v != null) onChanged(v); },
      ),
    );
  }

  Widget _buildMixResults(_MixResult r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (r.error != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: _red.withValues(alpha: 0.1),
              border: Border.all(color: _red.withValues(alpha: 0.4)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(r.error!,
                style: const TextStyle(color: _red, fontSize: 13)),
          ),
        _mixResultRow(
          'D${r.stockA}%',
          '${r.volA.toStringAsFixed(1)} mL',
          'D${r.stockB}%',
          '${r.volB.toStringAsFixed(1)} mL',
          '${r.actualPct.toStringAsFixed(1)}%',
          '${r.totalVol.toStringAsFixed(0)} mL',
        ),
        const SizedBox(height: 12),
        _safetyBanner(_safetyInfo(r.actualPct)),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 3: Calories Calculator
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildCaloriesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _inputField('Dextrose concentration', _calDextrosePctCtrl, '%', 'e.g. 10'),
          const SizedBox(height: 12),
          _inputField('Volume (per day)', _calVolumeCtrl, 'mL', 'e.g. 150'),
          const SizedBox(height: 12),
          _inputField('Patient weight', _calWeightCtrl, 'grams', 'e.g. 1850'),
          const SizedBox(height: 18),
          _orangeButton('Calculate Calories', _calculateCalories),
          if (_calResult != null) ...[
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _fadeAnim,
              child: _buildCaloriesResults(_calResult!),
            ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCaloriesResults(_CaloriesResult r) {
    return _detailCard([
      _dRow('Dextrose', '${r.dextroseG.toStringAsFixed(1)} g/day'),
      _dRow('Calories (from glucose)', '${r.kcal.toStringAsFixed(1)} kcal/day'),
      _dRow('Calories per kg', '${r.kcalPerKg.toStringAsFixed(1)} kcal/kg/day'),
      _dRow('Equivalent GIR', '${r.gir.toStringAsFixed(2)} mg/kg/min'),
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          'Formula: kcal = dextrose(g) x 3.4',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 11,
              fontStyle: FontStyle.italic),
        ),
      ),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Shared widgets
  // ══════════════════════════════════════════════════════════════════════════
  Widget _inputField(String label, TextEditingController ctrl, String suffix, String hint) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.7),
                fontSize: 13,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(color: cs.onSurface, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.35)),
            suffixText: suffix,
            suffixStyle: TextStyle(
                color: _orange, fontSize: 13, fontWeight: FontWeight.bold),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            filled: true,
            fillColor: Theme.of(context).cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: cs.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: cs.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: _orange, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _orangeButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _orange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
    );
  }

  Widget _mixResultRow(
      String labelA, String volA, String labelB, String volB,
      String labelFinal, String volFinal) {
    return Row(
      children: [
        Expanded(child: _mixCard(labelA, volA, const Color(0xFF58a6ff))),
        _opSymbol('+'),
        Expanded(child: _mixCard(labelB, volB, const Color(0xFF39d0c8))),
        _opSymbol('='),
        Expanded(child: _mixCard(labelFinal, volFinal, _green)),
      ],
    );
  }

  Widget _mixCard(String label, String vol, Color color) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(vol,
              style: TextStyle(
                  color: color,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _opSymbol(String op) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(op,
          style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.5),
              fontSize: 18,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _safetyBanner(_SafetyInfo s) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: s.color.withValues(alpha: 0.1),
        border: Border.all(color: s.color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(s.icon, color: s.color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(s.msg,
                style: TextStyle(
                    color: s.color,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _detailCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: children),
    );
  }

  Widget _dRow(String key, String value) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(key,
                style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.6), fontSize: 13)),
          ),
          Text(value,
              style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ── Data models ──────────────────────────────────────────────────────────────
class _SafetyInfo {
  final IconData icon;
  final String msg;
  final Color color;
  _SafetyInfo({required this.icon, required this.msg, required this.color});
}

class _GIRCalcResult {
  final double targetPct;
  final int stockA, stockB;
  final double volA, volB;
  final _SafetyInfo safety;
  final String? mixError;
  final double weightG, weightKg, totalVol, gir;
  _GIRCalcResult({
    required this.targetPct, required this.stockA, required this.stockB,
    required this.volA, required this.volB, required this.safety,
    required this.mixError, required this.weightG, required this.weightKg,
    required this.totalVol, required this.gir,
  });
}

class _MixResult {
  final int stockA, stockB;
  final double volA, volB, totalVol, actualPct;
  final String? error;
  _MixResult({
    required this.stockA, required this.stockB, required this.volA,
    required this.volB, required this.totalVol, required this.actualPct,
    this.error,
  });
}

class _CaloriesResult {
  final double dextroseG, kcal, kcalPerKg, gir, weightKg;
  _CaloriesResult({
    required this.dextroseG, required this.kcal, required this.kcalPerKg,
    required this.gir, required this.weightKg,
  });
}
