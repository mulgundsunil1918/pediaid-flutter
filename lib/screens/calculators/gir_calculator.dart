import 'package:flutter/material.dart';
import 'dart:math';

// ── Semantic color constants (non-background, kept for safety/status colors) ──
const Color _accent = Color(0xFF58a6ff);
const Color _green = Color(0xFF3fb950);
const Color _amber = Color(0xFFd29922);
const Color _red = Color(0xFFf85149);
const Color _teal = Color(0xFF39d0c8);

const List<int> _stocks = [0, 5, 10, 25, 50];

class GIRCalculator extends StatefulWidget {
  const GIRCalculator({super.key});

  @override
  State<GIRCalculator> createState() => _GIRCalculatorState();
}

class _GIRCalculatorState extends State<GIRCalculator>
    with SingleTickerProviderStateMixin {
  // ── State ─────────────────────────────────────────────────────────────────
  double _weight = 1850;
  double _glucoseVol = 220;
  double _gir = 6.0;

  final _weightCtrl = TextEditingController(text: '1850');
  final _glucoseVolCtrl = TextEditingController(text: '220');
  final _girCtrl = TextEditingController(text: '6.0');

  int? _stockA;
  int? _stockB;
  // autoLabel: 0=auto-pick on, 1=pick B, 2=manual set
  int _autoLabelState = 0;

  bool _showResults = false;
  _GIRResult? _result;

  String? _errWeight;
  String? _errVol;
  String? _errGir;

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
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
    _weightCtrl.dispose();
    _glucoseVolCtrl.dispose();
    _girCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Stock picker logic ────────────────────────────────────────────────────
  void _pickStock(int val) {
    setState(() {
      if (_stockA == null) {
        _stockA = val;
        _autoLabelState = 1; // "● Pick Stock B"
      } else if (_stockB == null && val != _stockA) {
        _stockB = val;
        _autoLabelState = 2; // "✓ Manual stocks set"
      } else {
        _stockA = null;
        _stockB = null;
        _autoLabelState = 0; // "● Auto-pick ON"
      }
    });
  }

  // ── Calculation helpers ───────────────────────────────────────────────────
  double? _pctNeeded(double gir, double weightKg, double volumeMl) {
    if (weightKg <= 0 || volumeMl <= 0) return null;
    return gir * weightKg * 144.0 / volumeMl;
  }

  List<double>? _mixTwo(
      double pct1, double pct2, double finalPct, double finalVol) {
    if (finalVol <= 0 || (pct1 - pct2).abs() < 1e-9) return null;
    final v1 = finalVol * (finalPct - pct2) / (pct1 - pct2);
    final v2 = finalVol - v1;
    return [v1, v2];
  }

  List<int?> _autoPickStocks(double targetPct) {
    int? lower;
    int? higher;
    for (final s in _stocks) {
      if (s <= targetPct) lower = s;
      if (s >= targetPct && higher == null) higher = s;
    }
    return [lower, higher];
  }

  _SafetyInfo _safetyInfo(double pct) {
    if (pct <= 12.5) {
      return _SafetyInfo(
        cls: 'safe',
        icon: '✅',
        msg: 'Safe for peripheral infusion',
        bg: _green.withValues(alpha: 0.12),
        border: _green.withValues(alpha: 0.5),
        textColor: _green,
      );
    } else if (pct <= 20.0) {
      return _SafetyInfo(
        cls: 'caution',
        icon: '⚠️',
        msg: 'Caution — prefer central line if prolonged usage',
        bg: _amber.withValues(alpha: 0.12),
        border: _amber.withValues(alpha: 0.5),
        textColor: _amber,
      );
    } else {
      return _SafetyInfo(
        cls: 'danger',
        icon: '🔴',
        msg: 'High concentration — central line strongly recommended',
        bg: _red.withValues(alpha: 0.12),
        border: _red.withValues(alpha: 0.5),
        textColor: _red,
      );
    }
  }

  // ── Calculate ─────────────────────────────────────────────────────────────
  void _calculate() {
    setState(() {
      _errWeight = null;
      _errVol = null;
      _errGir = null;
    });

    bool valid = true;

    if (_weight < 100 || _weight > 6000) {
      setState(() => _errWeight = 'Enter valid weight (100–6000 g)');
      valid = false;
    }
    if (_glucoseVol < 1) {
      setState(() => _errVol = 'Enter valid volume');
      valid = false;
    }
    if (_gir < 0 || _gir > 20) {
      setState(() => _errGir = 'Enter valid GIR (0–20)');
      valid = false;
    }

    if (!valid) {
      setState(() => _showResults = false);
      return;
    }

    final weightKg = _weight / 1000.0;
    final finalPct = _pctNeeded(_gir, weightKg, _glucoseVol)!;

    // Determine stocks
    int a, b;
    bool autoMode;
    if (_stockA != null && _stockB != null) {
      a = min(_stockA!, _stockB!);
      b = max(_stockA!, _stockB!);
      autoMode = false;
    } else {
      autoMode = true;
      final picked = _autoPickStocks(finalPct);
      final lower = picked[0];
      final higher = picked[1];
      if (lower == null) {
        a = 0;
        b = higher ?? 50;
      } else if (higher == null) {
        a = lower;
        b = 50;
      } else {
        a = lower;
        b = higher;
      }
    }

    final safety = _safetyInfo(finalPct);

    // Mix result
    String resAPct, resAVol, resBPct, resBVol, resFinalPct, resFinalVol;
    String? mixError;

    if ((a - b).abs() < 1e-9) {
      // Same stock
      resAPct = 'D$a%';
      resAVol = '${_glucoseVol.toStringAsFixed(1)} mL';
      resBPct = '—';
      resBVol = '0 mL';
      resFinalPct = '${finalPct.toStringAsFixed(2)}%';
      resFinalVol = '${_glucoseVol.toStringAsFixed(0)} mL';
    } else {
      final res = _mixTwo(a.toDouble(), b.toDouble(), finalPct, _glucoseVol);
      if (res == null || res[0] < -1 || res[1] < -1) {
        resAPct = 'D$a%';
        resAVol = 'ERR';
        resBPct = 'D$b%';
        resBVol = 'ERR';
        resFinalPct = '${finalPct.toStringAsFixed(2)}%';
        resFinalVol = '—';
        mixError =
            '⚠ Target ${finalPct.toStringAsFixed(2)}% is outside range of selected stocks (D$a% – D$b%). '
            'Choose stocks that bracket the target.';
      } else {
        final v1 = max(0.0, res[0]);
        final v2 = max(0.0, res[1]);
        resAPct = 'D$a%';
        resAVol = '${v1.toStringAsFixed(1)} mL';
        resBPct = 'D$b%';
        resBVol = '${v2.toStringAsFixed(1)} mL';
        resFinalPct = '${finalPct.toStringAsFixed(2)}%';
        resFinalVol = '${_glucoseVol.toStringAsFixed(0)} mL';
      }
    }

    setState(() {
      _result = _GIRResult(
        weightG: _weight,
        weightKg: weightKg,
        volMl: _glucoseVol,
        gir: _gir,
        finalPct: finalPct,
        resAPct: resAPct,
        resAVol: resAVol,
        resBPct: resBPct,
        resBVol: resBVol,
        resFinalPct: resFinalPct,
        resFinalVol: resFinalVol,
        safety: safety,
        mixError: mixError,
        autoMode: autoMode,
      );
      _showResults = true;
    });
    _fadeCtrl.forward(from: 0);
  }

  void _clearAll() {
    _weightCtrl.text = '1850';
    _glucoseVolCtrl.text = '220';
    _girCtrl.text = '6.0';
    setState(() {
      _weight = 1850;
      _glucoseVol = 220;
      _gir = 6.0;
      _stockA = null;
      _stockB = null;
      _autoLabelState = 0;
      _errWeight = null;
      _errVol = null;
      _errGir = null;
      _showResults = false;
      _result = null;
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('GIR Calculator',
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
            _buildPatientInputs(),
            const SizedBox(height: 12),
            _buildStockSection(),
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
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('NEONATAL TOOL',
                style: TextStyle(
                    color: cs.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2)),
          ),
          const SizedBox(height: 8),
          Text('GIR Dextrose Calculator',
              style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
              'Glucose Infusion Rate — required dextrose % & two-stock mixing instruction',
              style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 12.5)),
        ],
      );
    });
  }

  // ── Patient inputs ────────────────────────────────────────────────────────
  Widget _buildPatientInputs() {
    return Builder(builder: (context) => _sectionCard(
      title: 'Patient Inputs',
      context: context,
      child: Row(
        children: [
          Expanded(
            child: _stepperField(
              label: 'Weight',
              value: _weight,
              ctrl: _weightCtrl,
              unit: 'grams',
              step: 50,
              min: 100,
              max: 6000,
              error: _errWeight,
              onChanged: (v) => setState(() {
                _weight = v;
                _errWeight = null;
              }),
              decimals: 0,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _stepperField(
              label: 'Glucose Vol',
              value: _glucoseVol,
              ctrl: _glucoseVolCtrl,
              unit: 'mL / day',
              step: 5,
              min: 1,
              max: 1000,
              error: _errVol,
              onChanged: (v) => setState(() {
                _glucoseVol = v;
                _errVol = null;
              }),
              decimals: 0,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _stepperField(
              label: 'Target GIR',
              value: _gir,
              ctrl: _girCtrl,
              unit: 'mg/kg/min',
              step: 0.5,
              min: 0,
              max: 20,
              error: _errGir,
              onChanged: (v) => setState(() {
                _gir = v;
                _errGir = null;
              }),
              decimals: 1,
            ),
          ),
        ],
      ),
    ));
  }

  Widget _stepperField({
    required String label,
    required double value,
    required TextEditingController ctrl,
    required String unit,
    required double step,
    required double min,
    required double max,
    required String? error,
    required void Function(double) onChanged,
    required int decimals,
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
                  color: cs.onSurface.withValues(alpha: 0.6),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(
                  color: error != null ? _red : cs.onSurface.withValues(alpha: 0.15)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // + button
                _stepBtn(Icons.add, () {
                  final newVal =
                      double.parse((value + step).toStringAsFixed(decimals + 1));
                  if (newVal <= max) {
                    ctrl.text = fmt(newVal);
                    onChanged(newVal);
                  }
                }, context),
                // Editable value
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
                // − button
                _stepBtn(Icons.remove, () {
                  final newVal =
                      double.parse((value - step).toStringAsFixed(decimals + 1));
                  if (newVal >= min) {
                    ctrl.text = fmt(newVal);
                    onChanged(newVal);
                  }
                }, context),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(unit,
              style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 10.5)),
          if (error != null) ...[
            const SizedBox(height: 2),
            Text(error,
                style: const TextStyle(color: _red, fontSize: 10.5)),
          ],
        ],
      );
    });
  }

  Widget _stepBtn(IconData icon, VoidCallback onTap, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Icon(icon, color: cs.onSurface.withValues(alpha: 0.6), size: 16),
      ),
    );
  }

  // ── Stock section ─────────────────────────────────────────────────────────
  Widget _buildStockSection() {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return _sectionCard(
        title: 'Available Stock Solutions',
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tap to select Stock A ■ then Stock B ■ — or leave both unselected for auto-pick',
              style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 12),
            ),
            const SizedBox(height: 12),
            Row(
              children: _stocks.map((s) => _stockChip(s, context)).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _legendDot(_accent),
                const SizedBox(width: 4),
                Text('Stock A (lower)',
                    style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 11.5)),
                const SizedBox(width: 14),
                _legendDot(_teal),
                const SizedBox(width: 4),
                Text('Stock B (higher)',
                    style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 11.5)),
                const Spacer(),
                _autoLabel(),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _stockChip(int val, BuildContext context) {
    final isA = _stockA == val;
    final isB = _stockB == val;
    final cs = Theme.of(context).colorScheme;
    Color bg, border, textColor;
    if (isA) {
      bg = _accent.withValues(alpha: 0.2);
      border = _accent;
      textColor = _accent;
    } else if (isB) {
      bg = _teal.withValues(alpha: 0.2);
      border = _teal;
      textColor = _teal;
    } else {
      bg = Theme.of(context).cardColor;
      border = cs.onSurface.withValues(alpha: 0.15);
      textColor = cs.onSurface.withValues(alpha: 0.6);
    }
    return Expanded(
      child: GestureDetector(
        onTap: () => _pickStock(val),
        child: Container(
          margin: const EdgeInsets.only(right: 6),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'D$val%',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _legendDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _autoLabel() {
    String text;
    Color color;
    switch (_autoLabelState) {
      case 1:
        text = '● Pick Stock B';
        color = _teal;
      case 2:
        text = '✓ Manual stocks set';
        color = _green;
      default:
        text = '● Auto-pick ON';
        color = _teal;
    }
    return Text(text,
        style: TextStyle(
            color: color, fontSize: 11.5, fontWeight: FontWeight.w600));
  }

  // ── Action buttons ────────────────────────────────────────────────────────
  Widget _buildActionButtons() {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
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
              child: const Text('Calculate GIR',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 50,
            height: 50,
            child: OutlinedButton(
              onPressed: _clearAll,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: cs.onSurface.withValues(alpha: 0.2)),
                foregroundColor: cs.onSurface.withValues(alpha: 0.6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.zero,
              ),
              child: Text('↺',
                  style: TextStyle(fontSize: 20, color: cs.onSurface.withValues(alpha: 0.6))),
            ),
          ),
        ],
      );
    });
  }

  // ── Results ───────────────────────────────────────────────────────────────
  Widget _buildResults(_GIRResult r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMixGrid(r),
        const SizedBox(height: 12),
        _buildSafetyBanner(r.safety),
        if (r.mixError != null) ...[
          const SizedBox(height: 10),
          _buildMixError(r.mixError!),
        ],
        const SizedBox(height: 12),
        _buildDetailCard(r),
        const SizedBox(height: 14),
        _buildDisclaimer(),
      ],
    );
  }

  Widget _buildMixGrid(_GIRResult r) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _mixCard('Stock A', r.resAPct, r.resAVol, _accent)),
        _opText('+'),
        Expanded(child: _mixCard('Stock B', r.resBPct, r.resBVol, _teal)),
        _opText('='),
        Expanded(child: _mixCard('Final', r.resFinalPct, r.resFinalVol, _green)),
      ],
    );
  }

  Widget _mixCard(String cardLabel, String pct, String vol, Color color) {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(cardLabel,
              style: TextStyle(
                  color: color,
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(pct,
              style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          Divider(color: color.withValues(alpha: 0.3), height: 14),
          Text(vol,
              style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(cardLabel == 'Final' ? 'total' : 'to add',
              style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 10)),
        ],
      ),
    );
    });
  }

  Widget _opText(String op) {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(op,
            style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.6), fontSize: 18, fontWeight: FontWeight.bold)),
      );
    });
  }

  Widget _buildSafetyBanner(_SafetyInfo s) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: s.bg,
        border: Border.all(color: s.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(s.icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(s.msg,
                style: TextStyle(
                    color: s.textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildMixError(String msg) {
    return Builder(builder: (context) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: _red.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(msg,
            style: const TextStyle(color: _red, fontSize: 12.5)),
      );
    });
  }

  Widget _buildDetailCard(_GIRResult r) {
    final dexGrams = (r.finalPct / 100.0 * r.volMl).toStringAsFixed(2);
    return Builder(builder: (context) {
      return _sectionCard(
        title: '',
        context: context,
        child: Column(
          children: [
            _detailRow(context, 'Patient Weight',
                '${r.weightG.toInt()} g (${r.weightKg.toStringAsFixed(3)} kg)'),
            _detailRow(context, 'Glucose Volume / day', '${r.volMl.toInt()} mL'),
            _detailRow(context,
                'Target GIR', '${r.gir.toStringAsFixed(2)} mg/kg/min'),
            _detailRowHighlight(context, 'Required Dextrose %',
                '${r.finalPct.toStringAsFixed(2)}%'),
            _detailRow(context, 'Dextrose / day', '$dexGrams g'),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text('Formula',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 11.5)),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    '% = GIR × wt(kg) × 144 / vol(mL)',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 11,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _detailRow(BuildContext context, String key, String value) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(key,
                style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.6), fontSize: 12.5)),
          ),
          Expanded(
            flex: 6,
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _detailRowHighlight(BuildContext context, String key, String value) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(key,
                style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.6), fontSize: 12.5)),
          ),
          Expanded(
            flex: 6,
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: cs.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _amber.withValues(alpha: 0.08),
        border: Border.all(color: _amber.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        '⚠️ This calculator is a clinical aid only. Confirm compounding technique,\n'
        'sterility and local policy before administration.',
        style: TextStyle(color: _amber, fontSize: 11.5, height: 1.5),
      ),
    );
  }

  // ── Shared widgets ────────────────────────────────────────────────────────
  Widget _sectionCard({required String title, required Widget child, required BuildContext context}) {
    final cs = Theme.of(context).colorScheme;
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
}

// ── Data models ───────────────────────────────────────────────────────────────
class _SafetyInfo {
  final String cls;
  final String icon;
  final String msg;
  final Color bg;
  final Color border;
  final Color textColor;

  _SafetyInfo({
    required this.cls,
    required this.icon,
    required this.msg,
    required this.bg,
    required this.border,
    required this.textColor,
  });
}

class _GIRResult {
  final double weightG;
  final double weightKg;
  final double volMl;
  final double gir;
  final double finalPct;
  final String resAPct;
  final String resAVol;
  final String resBPct;
  final String resBVol;
  final String resFinalPct;
  final String resFinalVol;
  final _SafetyInfo safety;
  final String? mixError;
  final bool autoMode;

  _GIRResult({
    required this.weightG,
    required this.weightKg,
    required this.volMl,
    required this.gir,
    required this.finalPct,
    required this.resAPct,
    required this.resAVol,
    required this.resBPct,
    required this.resBVol,
    required this.resFinalPct,
    required this.resFinalVol,
    required this.safety,
    required this.mixError,
    required this.autoMode,
  });
}
