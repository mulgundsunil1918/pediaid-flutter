import 'package:flutter/material.dart';
import 'dart:math';


class TpnCalculator extends StatefulWidget {
  const TpnCalculator({super.key});

  @override
  State<TpnCalculator> createState() => _TpnCalculatorState();
}

class _TpnCalculatorState extends State<TpnCalculator> {
  String? _tpnType; // null, 'stock', 'multiline'
  String _potassiumType = 'kphos'; // 'kphos' or 'kcl'

  final _weightCtrl = TextEditingController();
  final _totalVolumeCtrl = TextEditingController();
  final _otherInfusionsCtrl = TextEditingController();
  final _sodiumCtrl = TextEditingController();
  final _potassiumCtrl = TextEditingController();
  final _aminovenCtrl = TextEditingController();
  final _lipidCtrl = TextEditingController();
  final _calciumCtrl = TextEditingController();
  final _girCtrl = TextEditingController();

  _TpnResult? _result;

  @override
  void dispose() {
    _weightCtrl.dispose();
    _totalVolumeCtrl.dispose();
    _otherInfusionsCtrl.dispose();
    _sodiumCtrl.dispose();
    _potassiumCtrl.dispose();
    _aminovenCtrl.dispose();
    _lipidCtrl.dispose();
    _calciumCtrl.dispose();
    _girCtrl.dispose();
    super.dispose();
  }

  void _reset() {
    setState(() {
      _tpnType = null;
      _result = null;
      _potassiumType = 'kphos';
      for (final c in [
        _weightCtrl, _totalVolumeCtrl, _otherInfusionsCtrl, _sodiumCtrl,
        _potassiumCtrl, _aminovenCtrl, _lipidCtrl, _calciumCtrl, _girCtrl,
      ]) {
        c.clear();
      }
    });
  }

  // ── Dextrose mixture finder ───────────────────────────────────────────────
  _DextroseMix? _findDextroseMixture(double targetConc, double totalDexVol) {
    const stocks = [0.0, 5.0, 10.0, 25.0, 50.0];
    _DextroseMix? best;
    double bestDiff = double.infinity;

    for (int i = 0; i < stocks.length; i++) {
      for (int j = i; j < stocks.length; j++) {
        final a = stocks[i];
        final b = stocks[j];
        if ((b - a).abs() < 0.001) {
          if ((a - targetConc).abs() < bestDiff) {
            bestDiff = (a - targetConc).abs();
            best = _DextroseMix(a, b, totalDexVol, 0.0, totalDexVol);
          }
          continue;
        }
        // targetConc = a * volA/total + b * volB/total
        // volA + volB = totalDexVol
        // volA = (targetConc - b) * totalDexVol / (a - b)
        final volA = (targetConc - b) * totalDexVol / (a - b);
        final volB = totalDexVol - volA;
        if (volA < -0.001 || volB < -0.001) continue;
        final actualConc = (a * max(0, volA) + b * max(0, volB)) / totalDexVol;
        final diff = (actualConc - targetConc).abs();
        if (diff < bestDiff) {
          bestDiff = diff;
          best = _DextroseMix(a, b, max(0, volA), max(0, volB), totalDexVol);
        }
      }
    }
    return best;
  }

  // ── Calculate ─────────────────────────────────────────────────────────────
  void _calculate() {
    final errors = <String>[];

    final w = double.tryParse(_weightCtrl.text);
    final tv = double.tryParse(_totalVolumeCtrl.text);
    final oi = double.tryParse(_otherInfusionsCtrl.text) ?? 0.0;
    final sod = double.tryParse(_sodiumCtrl.text) ?? 0.0;
    final pot = double.tryParse(_potassiumCtrl.text) ?? 0.0;
    final ami = double.tryParse(_aminovenCtrl.text) ?? 0.0;
    final lip = double.tryParse(_lipidCtrl.text) ?? 0.0;
    final cal = double.tryParse(_calciumCtrl.text) ?? 0.0;
    final gir = double.tryParse(_girCtrl.text) ?? 0.0;

    if (w == null || w <= 0) errors.add('Valid weight required');
    if (tv == null || tv <= 0) errors.add('Valid total volume required');

    if (errors.isNotEmpty) {
      setState(() => _result = _TpnResult(errors: errors));
      return;
    }

    final tpnVol = tv! - oi;

    if (_tpnType == 'stock') {
      _calculateStock(w!, tpnVol, sod, pot, ami, cal, gir, errors);
    } else {
      _calculateMultiline(w!, tpnVol, sod, pot, ami, lip, cal, gir, errors);
    }
  }

  void _calculateStock(double w, double tpnVol, double sod, double pot,
      double ami, double cal, double gir, List<String> errors) {
    // Component volumes (per day → already in ml for 24h)
    final sodiumVol = (sod * w) / 0.5;       // 3% NaCl → 0.5 mEq/ml
    final potassiumVol = _potassiumType == 'kphos'
        ? (pot * w) / 4.0                     // KH2PO4 4 mEq/ml
        : (pot * w) / 2.0;                    // KCl 2 mEq/ml
    final aminovenVol = (ami * w) / 0.1;      // Aminoven 10% → 0.1 g/ml
    final mgso4Vol = 0.1 * w;                 // MgSO4 fixed 0.1 ml/kg
    final calciumVol = cal * w;               // Calcium gluconate 1 ml/kg/unit

    // Dextrose
    // GIR (mg/kg/min) → dextrose g/day = GIR × w × 1440 / 1000
    final dextroseGday = gir * w * 1.44;
    // Volume dextrose = tpnVol - other additives
    final additivesVol =
        sodiumVol + potassiumVol + aminovenVol + mgso4Vol + calciumVol;
    final dexVol = tpnVol - additivesVol;

    if (dexVol < 0) {
      errors.add('Additive volumes exceed TPN volume. Reduce components.');
      setState(() => _result = _TpnResult(errors: errors));
      return;
    }

    // Target dextrose concentration
    final targetDexConc = dexVol > 0 ? (dextroseGday / dexVol) * 100 : 0.0;
    final mix = _findDextroseMixture(targetDexConc, dexVol);

    // Nutritional totals
    final proteinGday = aminovenVol * 0.1;  // Aminoven 10%
    final fatGday = 0.0;
    final carbsGday = dextroseGday;
    final caloriesDay =
        proteinGday * 4 + fatGday * 9 + carbsGday * 3.4;

    setState(() {
      _result = _TpnResult(
        errors: errors,
        tpnType: 'stock',
        weight: w,
        tpnVolume: tpnVol,
        stockResult: _StockResult(
          sodiumVol: sodiumVol,
          potassiumVol: potassiumVol,
          potassiumType: _potassiumType,
          aminovenVol: aminovenVol,
          mgso4Vol: mgso4Vol,
          calciumVol: calciumVol,
          dexVol: dexVol,
          targetDexConc: targetDexConc,
          dextroseMix: mix,
          proteinGkg: proteinGday / w,
          fatGkg: fatGday / w,
          carbsGkg: carbsGday / w,
          calKcalKg: caloriesDay / w,
          girActual: gir,
        ),
      );
    });
  }

  void _calculateMultiline(double w, double tpnVol, double sod, double pot,
      double ami, double lip, double cal, double gir, List<String> errors) {
    // Line 1: electrolytes + amino acids ONLY
    final sodiumVol = (sod * w) / 0.5;
    final potassiumVol = _potassiumType == 'kphos'
        ? (pot * w) / 4.0
        : (pot * w) / 2.0;
    final aminovenVol = (ami * w) / 0.1;
    final mgso4Vol = 0.1 * w;
    final line1Vol = sodiumVol + potassiumVol + aminovenVol + mgso4Vol;

    // Line 2: lipid + multivitamin + heparin
    // lip is g/kg/day (SMOF 20% = 0.2 g/ml)
    final double lipidGramsPerDay = lip * w;      // g/day
    final double lipidVol = lipidGramsPerDay / 0.2; // ml/day (SMOF 20% = 0.2g/ml)
    final multivitVol = 1.5 * w;
    const heparinVol = 1.0;
    final line2Vol = lipidVol + multivitVol + heparinVol;

    // Calcium
    final calciumVol = cal * w;

    // Dextrose = all remaining volume → goes into Line 3 with calcium
    final dexVol = tpnVol - line1Vol - line2Vol - calciumVol;

    if (dexVol < 0) {
      errors.add('Component volumes exceed TPN volume. Reduce electrolytes, lipid or calcium.');
      setState(() => _result = _TpnResult(errors: errors));
      return;
    }

    // Line 3: calcium + dextrose
    final line3Vol = calciumVol + dexVol;

    // Dextrose concentration
    final dextroseGday = gir * w * 1.44;
    final targetDexConc = dexVol > 0 ? (dextroseGday / dexVol) * 100 : 0.0;
    final mix = _findDextroseMixture(targetDexConc, dexVol);

    // Nutritional analysis
    final proteinGday = aminovenVol * 0.1;          // Aminoven 10%
    final double lipidKcalPerDay = lipidVol * 2.0;  // kcal/day (2 kcal/ml for SMOF 20%)
    final fatGday = lipidGramsPerDay;               // g/day (already in grams)
    final carbsGday = dextroseGday;
    final caloriesDay = proteinGday * 4 + lipidKcalPerDay + carbsGday * 3.4;
    final npcCalories = lipidKcalPerDay + carbsGday * 3.4;
    final nitrogenG = proteinGday / 6.25;
    final npcnRatio = nitrogenG > 0 ? npcCalories / nitrogenG : 0.0;

    // NPC:N status
    final String npcnStatus;
    if (npcnRatio < 70) {
      npcnStatus = 'alert';
    } else if (npcnRatio <= 100) {
      npcnStatus = 'ideal';
    } else if (npcnRatio <= 150) {
      npcnStatus = 'acceptable';
    } else {
      npcnStatus = 'warning';
    }

    // kcal per gram amino acid
    final kcalPerGAA = proteinGday > 0 ? npcCalories / proteinGday : 0.0;
    final String kcalAAStatus;
    if (kcalPerGAA < 30) {
      kcalAAStatus = 'insufficient';
    } else if (kcalPerGAA <= 40) {
      kcalAAStatus = 'recommended';
    } else {
      kcalAAStatus = 'adequate';
    }

    setState(() {
      _result = _TpnResult(
        errors: errors,
        tpnType: 'multiline',
        weight: w,
        tpnVolume: tpnVol,
        multilineResult: _MultilineResult(
          line1Vol: line1Vol,
          line2Vol: line2Vol,
          line3Vol: line3Vol,
          sodiumVol: sodiumVol,
          potassiumVol: potassiumVol,
          potassiumType: _potassiumType,
          aminovenVol: aminovenVol,
          mgso4Vol: mgso4Vol,
          calciumVol: calciumVol,
          lipidVol: lipidVol,
          multivitVol: multivitVol,
          heparinVol: heparinVol,
          dexVol: dexVol,
          targetDexConc: targetDexConc,
          dextroseMix: mix,
          proteinGkg: proteinGday / w,
          fatGkg: fatGday / w,
          carbsGkg: carbsGday / w,
          calKcalKg: caloriesDay / w,
          girActual: gir,
          npcnRatio: npcnRatio,
          npcnStatus: npcnStatus,
          kcalPerGAA: kcalPerGAA,
          kcalAAStatus: kcalAAStatus,
        ),
      );
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('TPN Calculator',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          if (_tpnType != null)
            TextButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Reset',
                  style: TextStyle(fontSize: 13)),
            ),
        ],
      ),
      body: _tpnType == null ? _buildTypeSelection() : _buildCalculator(),
    );
  }

  // ── Type selection screen ─────────────────────────────────────────────────
  Widget _buildTypeSelection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text('Select TPN Type',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 6),
          Text(
            'Choose the type of Total Parenteral Nutrition order',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 13),
          ),
          const SizedBox(height: 28),
          _TypeCard(
            title: 'Stock Solution',
            subtitle: 'Single bag — dextrose + electrolytes + amino acids',
            icon: Icons.science,
            color: Colors.amber.shade700,
            onTap: () => setState(() => _tpnType = 'stock'),
          ),
          const SizedBox(height: 16),
          _TypeCard(
            title: 'Multi-Line TPN',
            subtitle: 'Line 1: electrolytes + amino acids · Line 2: lipid + vitamins · Line 3: calcium + dextrose',
            icon: Icons.layers,
            color: Colors.blue.shade700,
            onTap: () => setState(() => _tpnType = 'multiline'),
          ),
        ],
      ),
    );
  }

  // ── Calculator form ────────────────────────────────────────────────────────
  Widget _buildCalculator() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionCard(
            title: 'Patient Information',
            icon: Icons.person,
            color: Theme.of(context).colorScheme.primary,
            children: [
              _inputRow('Weight (kg)', _weightCtrl, 'e.g. 1.2'),
              _inputRow('Total Volume per Day (ml)', _totalVolumeCtrl, 'e.g. 150'),
              _inputRow('Other Infusions/Feeds/Drugs (ml/day)', _otherInfusionsCtrl, 'e.g. 20', optional: true),
            ],
          ),
          const SizedBox(height: 12),
          _sectionCard(
            title: 'TPN Components',
            icon: Icons.medication,
            color: Colors.teal.shade700,
            children: [
              _inputRow('Sodium (mEq/kg/day)', _sodiumCtrl, 'e.g. 3'),
              const SizedBox(height: 8),
              _potassiumRow(),
              const SizedBox(height: 8),
              _inputRow('Aminoven 10% (g/kg/day)', _aminovenCtrl, 'e.g. 2.5'),
              if (_tpnType == 'multiline') ...[
                _inputRow('Lipid SMOF 20% (g/kg/day)', _lipidCtrl, 'e.g. 2'),
              ],
              _inputRow('Calcium Gluconate (ml/kg/day)', _calciumCtrl, 'e.g. 1'),
              _inputRow('GIR (mg/kg/min)', _girCtrl, 'e.g. 6'),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _calculate,
            icon: const Icon(Icons.calculate, size: 20),
            label: const Text('Calculate TPN',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          if (_result != null) ...[
            const SizedBox(height: 20),
            _buildResults(),
          ],
        ],
      ),
    );
  }

  Widget _potassiumRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _inputRow('Potassium (mEq/kg/day)', _potassiumCtrl, 'e.g. 2'),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('Source:', style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(width: 12),
            _radioChip('KH₂PO₄ (4 mEq/ml)', 'kphos'),
            const SizedBox(width: 8),
            _radioChip('KCl (2 mEq/ml)', 'kcl'),
          ],
        ),
      ],
    );
  }

  Widget _radioChip(String label, String value) {
    final selected = _potassiumType == value;
    return GestureDetector(
      onTap: () => setState(() => _potassiumType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).colorScheme.primary : Colors.transparent,
          border: Border.all(color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : Theme.of(context).colorScheme.onSurface,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(title,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: color)),
              ],
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _inputRow(String label, TextEditingController ctrl, String hint,
      {bool optional = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 4),
          TextField(
            controller: ctrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.outline),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Results ───────────────────────────────────────────────────────────────
  Widget _buildResults() {
    final r = _result!;

    if (r.errors.isNotEmpty) {
      return _errorBanner(r.errors);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _volumeSummaryCard(r),
        const SizedBox(height: 12),
        if (r.tpnType == 'stock') _buildStockResults(r.stockResult!) else _buildMultilineResults(r.multilineResult!),
      ],
    );
  }

  Widget _errorBanner(List<String> errors) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.error_outline, color: Colors.red.shade700, size: 18),
            const SizedBox(width: 8),
            Text('Input Errors',
                style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ]),
          const SizedBox(height: 8),
          ...errors.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• $e',
                    style: TextStyle(
                        color: Colors.red.shade700, fontSize: 13)),
              )),
        ],
      ),
    );
  }

  Widget _volumeSummaryCard(_TpnResult r) {
    return _resultCard(
      title: 'Volume Summary',
      icon: Icons.water_drop,
      color: Theme.of(context).colorScheme.primary,
      children: [
        _resultRow('Weight', '${r.weight!.toStringAsFixed(2)} kg'),
        _resultRow('Total TPN Volume', '${r.tpnVolume!.toStringAsFixed(1)} ml/day'),
      ],
    );
  }

  Widget _buildStockResults(_StockResult s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _resultCard(
          title: 'Stock Solution Components',
          icon: Icons.science,
          color: Colors.amber.shade800,
          children: [
            _resultRow('3% NaCl (Sodium)', '${s.sodiumVol.toStringAsFixed(2)} ml'),
            _resultRow(
              s.potassiumType == 'kphos' ? 'KH₂PO₄ (Potassium)' : 'KCl (Potassium)',
              '${s.potassiumVol.toStringAsFixed(2)} ml',
            ),
            _resultRow('Aminoven 10%', '${s.aminovenVol.toStringAsFixed(2)} ml'),
            _resultRow('MgSO₄', '${s.mgso4Vol.toStringAsFixed(2)} ml'),
            _resultRow('Calcium Gluconate', '${s.calciumVol.toStringAsFixed(2)} ml'),
            const Divider(),
            _resultRow('Dextrose Volume', '${s.dexVol.toStringAsFixed(2)} ml',
                bold: true),
            _resultRow('Target Dextrose Conc.', '${s.targetDexConc.toStringAsFixed(1)}%',
                bold: true),
            if (s.dextroseMix != null) ...[
              const SizedBox(height: 8),
              _dextroseMixBox(s.dextroseMix!),
            ],
            const SizedBox(height: 8),
            _infusionRateRow(s.dexVol + s.sodiumVol + s.potassiumVol + s.aminovenVol + s.mgso4Vol + s.calciumVol, Colors.amber.shade700),
          ],
        ),
        const SizedBox(height: 12),
        _nutritionCard(
          proteinGkg: s.proteinGkg,
          fatGkg: s.fatGkg,
          carbsGkg: s.carbsGkg,
          calKcalKg: s.calKcalKg,
          gir: s.girActual,
        ),
      ],
    );
  }

  Widget _buildMultilineResults(_MultilineResult m) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Line 1
        _resultCard(
          title: 'Line 1 — Electrolytes + Amino Acids',
          icon: Icons.opacity,
          color: Colors.blue.shade700,
          children: [
            _resultRow('Total Line 1 Volume', '${m.line1Vol.toStringAsFixed(1)} ml/day', bold: true),
            const Divider(),
            _resultRow('3% NaCl (Sodium)', '${m.sodiumVol.toStringAsFixed(2)} ml'),
            _resultRow(
              m.potassiumType == 'kphos' ? 'KH₂PO₄ (Potassium)' : 'KCl (Potassium)',
              '${m.potassiumVol.toStringAsFixed(2)} ml',
            ),
            _resultRow('Aminoven 10%', '${m.aminovenVol.toStringAsFixed(2)} ml'),
            _resultRow('MgSO₄', '${m.mgso4Vol.toStringAsFixed(2)} ml'),
            const SizedBox(height: 8),
            _infusionRateRow(m.line1Vol, Colors.blue.shade700),
          ],
        ),
        const SizedBox(height: 12),
        // Line 2
        _resultCard(
          title: 'Line 2 — Lipid + Multivitamin + Heparin',
          icon: Icons.local_pharmacy,
          color: Colors.green.shade700,
          children: [
            _resultRow('Total Line 2 Volume', '${m.line2Vol.toStringAsFixed(1)} ml/day', bold: true),
            const Divider(),
            _resultRow('Lipid SMOF 20%', '${(m.lipidVol * 0.2 / (_result?.weight ?? 1)).toStringAsFixed(1)} g/kg/day (${m.lipidVol.toStringAsFixed(1)} ml/day)'),
            _resultRow('Multivitamin', '${m.multivitVol.toStringAsFixed(2)} ml'),
            _resultRow('Heparin', '${m.heparinVol.toStringAsFixed(2)} ml (fixed)'),
            const SizedBox(height: 8),
            _infusionRateRow(m.line2Vol, Colors.green.shade700),
          ],
        ),
        const SizedBox(height: 12),
        // Line 3
        _resultCard(
          title: 'Line 3 — Calcium + Dextrose',
          icon: Icons.circle,
          color: Colors.purple.shade700,
          children: [
            _resultRow('Total Line 3 Volume', '${m.line3Vol.toStringAsFixed(1)} ml/day', bold: true),
            const Divider(),
            _resultRow('Calcium Gluconate', '${m.calciumVol.toStringAsFixed(2)} ml'),
            _resultRow('Dextrose Volume', '${m.dexVol.toStringAsFixed(2)} ml', bold: true),
            _resultRow('Target Dextrose Conc.', '${m.targetDexConc.toStringAsFixed(1)}%', bold: true),
            if (m.dextroseMix != null) ...[
              const SizedBox(height: 8),
              _dextroseMixBox(m.dextroseMix!),
            ],
            const SizedBox(height: 8),
            _infusionRateRow(m.line3Vol, Colors.purple.shade700),
          ],
        ),
        const SizedBox(height: 12),
        _nutritionCard(
          proteinGkg: m.proteinGkg,
          fatGkg: m.fatGkg,
          carbsGkg: m.carbsGkg,
          calKcalKg: m.calKcalKg,
          gir: m.girActual,
          npcnRatio: m.npcnRatio,
          npcnStatus: m.npcnStatus,
          kcalPerGAA: m.kcalPerGAA,
          kcalAAStatus: m.kcalAAStatus,
        ),
      ],
    );
  }

  Widget _dextroseMixBox(_DextroseMix mix) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dextrose Mixture',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                  fontSize: 13)),
          const SizedBox(height: 6),
          if (mix.volA > 0.01)
            Text(
              'D${mix.concA.toStringAsFixed(0)}W: ${mix.volA.toStringAsFixed(2)} ml',
              style: const TextStyle(fontSize: 13),
            ),
          if (mix.volB > 0.01)
            Text(
              'D${mix.concB.toStringAsFixed(0)}W: ${mix.volB.toStringAsFixed(2)} ml',
              style: const TextStyle(fontSize: 13),
            ),
          Text(
            'Total: ${mix.totalVol.toStringAsFixed(2)} ml',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _nutritionCard({
    required double proteinGkg,
    required double fatGkg,
    required double carbsGkg,
    required double calKcalKg,
    required double gir,
    double? npcnRatio,
    String? npcnStatus,
    double? kcalPerGAA,
    String? kcalAAStatus,
  }) {
    return _resultCard(
      title: 'Nutritional Analysis',
      icon: Icons.analytics,
      color: Colors.indigo.shade700,
      children: [
        _resultRow('Protein', '${proteinGkg.toStringAsFixed(2)} g/kg/day'),
        _resultRow('Fat', '${fatGkg.toStringAsFixed(2)} g/kg/day'),
        _resultRow('Carbohydrates', '${carbsGkg.toStringAsFixed(2)} g/kg/day'),
        _resultRow('Total Calories', '${calKcalKg.toStringAsFixed(1)} kcal/kg/day',
            bold: true),
        _resultRow('GIR', '${gir.toStringAsFixed(1)} mg/kg/min'),
        if (npcnRatio != null) ...[
          _resultRow('NPC : N Ratio', '${npcnRatio.toStringAsFixed(0)} : 1'),
          const SizedBox(height: 12),
          _npcnInterpTable(npcnRatio, npcnStatus ?? ''),
        ],
        if (kcalPerGAA != null) ...[
          const SizedBox(height: 12),
          _resultRow('Calories per g Amino Acid', '${kcalPerGAA.toStringAsFixed(1)} kcal/g'),
          const SizedBox(height: 8),
          _kcalAAInterpTable(kcalPerGAA, kcalAAStatus ?? ''),
        ],
      ],
    );
  }

  Widget _npcnInterpTable(double ratio, String status) {
    const rows = [
      _InterpRow('< 70 : 1', 'High protein intake',
          'Seen in severe catabolism — acceptable if clinically indicated', 'alert'),
      _InterpRow('70–100 : 1', 'IDEAL for preterm infants',
          'Optimal for protein anabolism and growth (ESPGHAN 2022)', 'ideal'),
      _InterpRow('100–150 : 1', 'Acceptable range',
          'Adequate but protein utilisation may be suboptimal', 'acceptable'),
      _InterpRow('> 150 : 1', 'Low protein intake',
          'Risk of catabolism — consider increasing protein unless contraindicated', 'warning'),
    ];
    return _interpTable(
      title: 'ESPGHAN Guidelines — NPC:N Ratio Interpretation',
      rows: rows,
      activeStatus: status,
    );
  }

  Widget _kcalAAInterpTable(double kcalPerGAA, String status) {
    const rows = [
      _InterpRow('< 30 kcal/g', 'Insufficient caloric support',
          'Amino acids used for energy, not anabolism', 'insufficient'),
      _InterpRow('30–40 kcal/g', 'Recommended range',
          'Adequate non-protein caloric support (ESPGHAN 2022)', 'recommended'),
      _InterpRow('> 40 kcal/g', 'Adequate caloric support',
          'Good caloric support for protein utilisation', 'adequate'),
    ];
    return _interpTable(
      title: 'Calories per gram Amino Acid — Interpretation',
      rows: rows,
      activeStatus: status,
    );
  }

  Widget _interpTable({
    required String title,
    required List<_InterpRow> rows,
    required String activeStatus,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade800)),
        const SizedBox(height: 6),
        ...rows.map((row) {
          final isActive = row.status == activeStatus;
          final bg = isActive ? _statusBg(row.status) : Colors.transparent;
          final border = isActive ? _statusBorder(row.status) : Theme.of(context).colorScheme.outline.withValues(alpha: 0.5);
          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: bg,
              border: Border.all(color: border),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(row.range,
                        style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: isActive
                                ? _statusText(row.status)
                                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text('→ ${row.label}',
                          style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isActive
                                  ? _statusText(row.status)
                                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
                    ),
                  ],
                ),
                Text(row.note,
                    style: TextStyle(
                        fontSize: 11,
                        color: isActive
                            ? _statusText(row.status).withValues(alpha: 0.85)
                            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
              ],
            ),
          );
        }),
      ],
    );
  }

  Color _statusBg(String status) {
    switch (status) {
      case 'ideal':
        return Colors.green.shade50;
      case 'acceptable':
        return Colors.blue.shade50;
      case 'warning':
        return Colors.yellow.shade50;
      case 'alert':
        return Colors.orange.shade50;
      case 'recommended':
        return Colors.green.shade50;
      case 'insufficient':
        return Colors.orange.shade50;
      case 'adequate':
        return Colors.blue.shade50;
      default:
        return Colors.grey.shade50;
    }
  }

  Color _statusBorder(String status) {
    switch (status) {
      case 'ideal':
        return Colors.green.shade300;
      case 'acceptable':
        return Colors.blue.shade300;
      case 'warning':
        return Colors.yellow.shade600;
      case 'alert':
        return Colors.orange.shade400;
      case 'recommended':
        return Colors.green.shade300;
      case 'insufficient':
        return Colors.orange.shade400;
      case 'adequate':
        return Colors.blue.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  Color _statusText(String status) {
    switch (status) {
      case 'ideal':
        return Colors.green.shade800;
      case 'acceptable':
        return Colors.blue.shade800;
      case 'warning':
        return Colors.yellow.shade900;
      case 'alert':
        return Colors.orange.shade900;
      case 'recommended':
        return Colors.green.shade800;
      case 'insufficient':
        return Colors.orange.shade900;
      case 'adequate':
        return Colors.blue.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  Widget _infusionRateRow(double totalVol, Color color) {
    final rate = totalVol / 24.0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Text('💉', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Text('Infusion Rate:',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color)),
          const Spacer(),
          Text('${rate.toStringAsFixed(2)} ml/hr',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color)),
        ],
      ),
    );
  }

  Widget _resultCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _resultRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: bold ? FontWeight.bold : FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary)),
        ],
      ),
    );
  }
}

// ── Type selection card ───────────────────────────────────────────────────────
class _TypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _TypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 12.5, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), height: 1.4)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Interpretation row ────────────────────────────────────────────────────────
class _InterpRow {
  final String range;
  final String label;
  final String note;
  final String status;

  const _InterpRow(this.range, this.label, this.note, this.status);
}

// ── Data models ───────────────────────────────────────────────────────────────
class _DextroseMix {
  final double concA;
  final double concB;
  final double volA;
  final double volB;
  final double totalVol;

  _DextroseMix(this.concA, this.concB, this.volA, this.volB, this.totalVol);
}

class _StockResult {
  final double sodiumVol;
  final double potassiumVol;
  final String potassiumType;
  final double aminovenVol;
  final double mgso4Vol;
  final double calciumVol;
  final double dexVol;
  final double targetDexConc;
  final _DextroseMix? dextroseMix;
  final double proteinGkg;
  final double fatGkg;
  final double carbsGkg;
  final double calKcalKg;
  final double girActual;

  _StockResult({
    required this.sodiumVol,
    required this.potassiumVol,
    required this.potassiumType,
    required this.aminovenVol,
    required this.mgso4Vol,
    required this.calciumVol,
    required this.dexVol,
    required this.targetDexConc,
    required this.dextroseMix,
    required this.proteinGkg,
    required this.fatGkg,
    required this.carbsGkg,
    required this.calKcalKg,
    required this.girActual,
  });
}

class _MultilineResult {
  final double line1Vol;
  final double line2Vol;
  final double line3Vol;
  final double sodiumVol;
  final double potassiumVol;
  final String potassiumType;
  final double aminovenVol;
  final double mgso4Vol;
  final double calciumVol;
  final double lipidVol;
  final double multivitVol;
  final double heparinVol;
  final double dexVol;
  final double targetDexConc;
  final _DextroseMix? dextroseMix;
  final double proteinGkg;
  final double fatGkg;
  final double carbsGkg;
  final double calKcalKg;
  final double girActual;
  final double npcnRatio;
  final String npcnStatus;
  final double kcalPerGAA;
  final String kcalAAStatus;

  _MultilineResult({
    required this.line1Vol,
    required this.line2Vol,
    required this.line3Vol,
    required this.sodiumVol,
    required this.potassiumVol,
    required this.potassiumType,
    required this.aminovenVol,
    required this.mgso4Vol,
    required this.calciumVol,
    required this.lipidVol,
    required this.multivitVol,
    required this.heparinVol,
    required this.dexVol,
    required this.targetDexConc,
    required this.dextroseMix,
    required this.proteinGkg,
    required this.fatGkg,
    required this.carbsGkg,
    required this.calKcalKg,
    required this.girActual,
    required this.npcnRatio,
    required this.npcnStatus,
    required this.kcalPerGAA,
    required this.kcalAAStatus,
  });
}

class _TpnResult {
  final List<String> errors;
  final String? tpnType;
  final double? weight;
  final double? tpnVolume;
  final _StockResult? stockResult;
  final _MultilineResult? multilineResult;

  _TpnResult({
    required this.errors,
    this.tpnType,
    this.weight,
    this.tpnVolume,
    this.stockResult,
    this.multilineResult,
  });
}
