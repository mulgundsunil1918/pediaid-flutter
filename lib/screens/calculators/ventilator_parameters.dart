import 'package:flutter/material.dart';
import 'dart:math';

// ── Colors ────────────────────────────────────────────────────────────────────
const Color _primary     = Color(0xFF2563eb);
const Color _primaryDark = Color(0xFF1d4ed8);
const Color _danger      = Color(0xFFdc2626);
const Color _warning     = Color(0xFFf59e0b);
const Color _success     = Color(0xFF16a34a);
const Color _info        = Color(0xFF0891b2);
const Color _purple      = Color(0xFF7c3aed);
// _bg removed - using Theme.of(context).scaffoldBackgroundColor
// _white, _textC, _textLight, _border replaced with theme-aware values
const Color _highlight   = Color(0xFFfef3c7);
const Color _orange      = Color(0xFFf97316);

// ── Main widget ───────────────────────────────────────────────────────────────
class VentilatorParameters extends StatefulWidget {
  const VentilatorParameters({super.key});
  @override
  State<VentilatorParameters> createState() => _VentilatorParametersState();
}

class _VentilatorParametersState extends State<VentilatorParameters> {
  int _activeTab = 0;

  // ── TAB 1 — OI ──────────────────────────────────────────────────────────────
  String _oiFio2Mode = 'percent';
  final _oiMapCtrl   = TextEditingController();
  final _oiFio2Ctrl  = TextEditingController();
  final _oiPao2Ctrl  = TextEditingController();
  double? _oiMap, _oiFio2Input, _oiPao2;
  double? _oiResult;
  String  _oiFio2Error = '';

  // ── TAB 1 — OSI ─────────────────────────────────────────────────────────────
  String _osiFio2Mode = 'percent';
  final _osiMapCtrl  = TextEditingController();
  final _osiFio2Ctrl = TextEditingController();
  final _osiSpo2Ctrl = TextEditingController();
  double? _osiMap, _osiFio2Input, _osiSpo2;
  double? _osiResult;

  // ── TAB 1 — MAP ─────────────────────────────────────────────────────────────
  final _mapPipCtrl  = TextEditingController();
  final _mapPeepCtrl = TextEditingController();
  final _mapTiCtrl   = TextEditingController();
  final _mapRateCtrl = TextEditingController();
  double? _mapPip, _mapPeep, _mapTi, _mapRate;
  double  _mapK = 0.64;
  double? _mapResult;

  // ── TAB 2 — HFOV OI ─────────────────────────────────────────────────────────
  String _hfovFio2Mode = 'percent';
  final _hfovMapCtrl  = TextEditingController();
  final _hfovFio2Ctrl = TextEditingController();
  final _hfovPao2Ctrl = TextEditingController();
  double? _hfovMap, _hfovFio2Input, _hfovPao2;
  double? _hfovOiResult;

  // ── TAB 2 — DCO2 ────────────────────────────────────────────────────────────
  final _dco2VthfCtrl   = TextEditingController();
  final _dco2FreqCtrl   = TextEditingController();
  final _dco2WeightCtrl = TextEditingController();
  double? _dco2Vthf, _dco2Freq, _dco2Weight;
  double? _dco2Result;

  // ── TAB 2 — Target DCO2 ─────────────────────────────────────────────────────
  final _tCurrPaco2Ctrl   = TextEditingController();
  final _tCurrDco2Ctrl    = TextEditingController();
  final _tTargetPaco2Ctrl = TextEditingController();
  double? _tCurrPaco2, _tCurrDco2, _tTargetPaco2;
  double? _targetDco2Result;

  // ── TAB 3 — SOPI ────────────────────────────────────────────────────────────
  final _sopiCpapCtrl = TextEditingController();
  final _sopiFio2Ctrl = TextEditingController();
  final _sopiSpo2Ctrl = TextEditingController();
  double? _sopiCpap, _sopiFio2, _sopiSpo2;
  double? _sopiResult;

  // ── TAB 3 — S/F ─────────────────────────────────────────────────────────────
  final _sfSpo2Ctrl = TextEditingController();
  final _sfFio2Ctrl = TextEditingController();
  double? _sfSpo2, _sfFio2;
  double? _sfResult;

  // ── TAB 3 — ROX ─────────────────────────────────────────────────────────────
  final _roxSpo2Ctrl = TextEditingController();
  final _roxFio2Ctrl = TextEditingController();
  final _roxRrCtrl   = TextEditingController();
  double? _roxSpo2, _roxFio2, _roxRr;
  double? _roxResult;

  @override
  void dispose() {
    _oiMapCtrl.dispose(); _oiFio2Ctrl.dispose(); _oiPao2Ctrl.dispose();
    _osiMapCtrl.dispose(); _osiFio2Ctrl.dispose(); _osiSpo2Ctrl.dispose();
    _mapPipCtrl.dispose(); _mapPeepCtrl.dispose(); _mapTiCtrl.dispose(); _mapRateCtrl.dispose();
    _hfovMapCtrl.dispose(); _hfovFio2Ctrl.dispose(); _hfovPao2Ctrl.dispose();
    _dco2VthfCtrl.dispose(); _dco2FreqCtrl.dispose(); _dco2WeightCtrl.dispose();
    _tCurrPaco2Ctrl.dispose(); _tCurrDco2Ctrl.dispose(); _tTargetPaco2Ctrl.dispose();
    _sopiCpapCtrl.dispose(); _sopiFio2Ctrl.dispose(); _sopiSpo2Ctrl.dispose();
    _sfSpo2Ctrl.dispose(); _sfFio2Ctrl.dispose();
    _roxSpo2Ctrl.dispose(); _roxFio2Ctrl.dispose(); _roxRrCtrl.dispose();
    super.dispose();
  }

  // ── OI Calculation ───────────────────────────────────────────────────────────
  void _calcOI() {
    if (_oiMap == null || _oiFio2Input == null || _oiPao2 == null || _oiPao2! <= 0) {
      setState(() { _oiResult = null; _oiFio2Error = ''; });
      return;
    }
    double fio2Pct;
    if (_oiFio2Mode == 'percent') {
      if (_oiFio2Input! < 21 || _oiFio2Input! > 100) {
        setState(() { _oiFio2Error = 'Value out of range. For decimal mode, enter 0.21-1.00'; _oiResult = null; });
        return;
      }
      fio2Pct = _oiFio2Input!;
    } else {
      if (_oiFio2Input! < 0.21 || _oiFio2Input! > 1.0) {
        setState(() { _oiFio2Error = 'Value out of range. For decimal mode, enter 0.21-1.00'; _oiResult = null; });
        return;
      }
      fio2Pct = _oiFio2Input! * 100;
    }
    final oi = (_oiMap! * fio2Pct) / _oiPao2!;
    setState(() { _oiFio2Error = ''; _oiResult = (oi * 10).round() / 10; });
  }

  // ── OSI Calculation ──────────────────────────────────────────────────────────
  void _calcOSI() {
    if (_osiMap == null || _osiFio2Input == null || _osiSpo2 == null || _osiSpo2! <= 0) {
      setState(() => _osiResult = null);
      return;
    }
    double fio2Pct = _osiFio2Mode == 'percent' ? _osiFio2Input! : _osiFio2Input! * 100;
    final osi = (_osiMap! * fio2Pct) / _osiSpo2!;
    setState(() => _osiResult = (osi * 10).round() / 10);
  }

  // ── MAP Calculation ──────────────────────────────────────────────────────────
  void _calcMAP() {
    if (_mapPip == null || _mapPeep == null || _mapTi == null || _mapRate == null || _mapRate! <= 0) {
      setState(() => _mapResult = null);
      return;
    }
    final ttotal = 60 / _mapRate!;
    final map = _mapK * (_mapTi! / ttotal) * (_mapPip! - _mapPeep!) + _mapPeep!;
    final mapR = (map * 10).round() / 10;
    setState(() {
      _mapResult = mapR;
      // auto-fill OI and OSI MAP
      final s = mapR.toStringAsFixed(1);
      _oiMapCtrl.text  = s; _oiMap  = mapR;
      _osiMapCtrl.text = s; _osiMap = mapR;
    });
    _calcOI();
    _calcOSI();
  }

  // ── HFOV OI Calculation ──────────────────────────────────────────────────────
  void _calcHfovOI() {
    if (_hfovMap == null || _hfovFio2Input == null || _hfovPao2 == null || _hfovPao2! <= 0) {
      setState(() => _hfovOiResult = null);
      return;
    }
    double fio2Pct = _hfovFio2Mode == 'percent' ? _hfovFio2Input! : _hfovFio2Input! * 100;
    final oi = (_hfovMap! * fio2Pct) / _hfovPao2!;
    setState(() => _hfovOiResult = (oi * 10).round() / 10);
  }

  // ── DCO2 Calculation ─────────────────────────────────────────────────────────
  void _calcDco2() {
    if (_dco2Vthf == null || _dco2Freq == null) {
      setState(() => _dco2Result = null);
      return;
    }
    final vthfAbs = _dco2Weight != null ? _dco2Vthf! * (_dco2Weight! / 1000) : _dco2Vthf!;
    final dco2 = pow(vthfAbs, 2) * _dco2Freq!;
    setState(() => _dco2Result = dco2.roundToDouble());
  }

  // ── Target DCO2 ──────────────────────────────────────────────────────────────
  void _calcTargetDco2() {
    if (_tCurrPaco2 == null || _tCurrDco2 == null || _tTargetPaco2 == null || _tTargetPaco2! <= 0) {
      setState(() => _targetDco2Result = null);
      return;
    }
    final t = _tCurrDco2! * (_tCurrPaco2! / _tTargetPaco2!);
    setState(() => _targetDco2Result = t.roundToDouble());
  }

  // ── SOPI ─────────────────────────────────────────────────────────────────────
  void _calcSOPI() {
    if (_sopiCpap == null || _sopiFio2 == null || _sopiSpo2 == null || _sopiSpo2! <= 0) {
      setState(() => _sopiResult = null);
      return;
    }
    final s = (_sopiCpap! * _sopiFio2!) / _sopiSpo2!;
    setState(() => _sopiResult = (s * 100).round() / 100);
  }

  // ── S/F ──────────────────────────────────────────────────────────────────────
  void _calcSF() {
    if (_sfSpo2 == null || _sfFio2 == null || _sfFio2! <= 0) {
      setState(() => _sfResult = null);
      return;
    }
    final sf = _sfSpo2! / _sfFio2!;
    setState(() => _sfResult = (sf * 10).round() / 10);
  }

  // ── ROX ──────────────────────────────────────────────────────────────────────
  void _calcROX() {
    if (_roxSpo2 == null || _roxFio2 == null || _roxRr == null || _roxFio2! <= 0 || _roxRr! <= 0) {
      setState(() => _roxResult = null);
      return;
    }
    final rox = (_roxSpo2! / _roxFio2!) / _roxRr!;
    setState(() => _roxResult = (rox * 100).round() / 100);
  }

  // ── OI severity helpers ──────────────────────────────────────────────────────
  ({String label, Color color}) _oiCat(double oi) {
    if (oi < 5)   return (label: 'Mild',          color: _success);
    if (oi <= 15) return (label: 'Moderate',       color: _warning);
    if (oi <= 25) return (label: 'Severe',         color: _orange);
    if (oi <= 40) return (label: 'Very Severe',    color: _danger);
    return              (label: 'ECMO Consider',  color: _purple);
  }

  ({String label, Color color}) _osiCat(double osi) {
    if (osi < 2.9)   return (label: 'Mild',         color: _success);
    if (osi <= 6.5)  return (label: 'Moderate',      color: _warning);
    if (osi <= 11.5) return (label: 'Severe',        color: _orange);
    if (osi <= 19.1) return (label: 'Very Severe',   color: _danger);
    return               (label: 'ECMO Consider', color: _purple);
  }

  int _severityRowIdx(double? oi) {
    if (oi == null) return -1;
    if (oi < 5)   return 0;
    if (oi <= 15) return 1;
    if (oi <= 25) return 2;
    if (oi <= 40) return 3;
    return 4;
  }

  // ── Build ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Ventilator Parameters',
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
            _buildWarningBanner(),
            const SizedBox(height: 16),
            _buildTabs(),
            const SizedBox(height: 16),
            _buildTabContent(),
            const SizedBox(height: 16),
            _buildSeverityTable(),
            const SizedBox(height: 16),
            _buildFormulaReference(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return _card(child: Row(
      children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(color: _primary.withValues(alpha: .1), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.air, color: _primary, size: 30),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Neonatal Ventilator Parameters Calculator',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              const SizedBox(height: 4),
              Text('Corrected OI Formula: FiO2 Input Mode Selection for Accurate Calculations',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
            ],
          ),
        ),
      ],
    ));
  }

  // ── Warning banner ────────────────────────────────────────────────────────────
  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFfffbeb), Color(0xFFfef3c7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(color: _warning),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⚠️ CRITICAL FORMULA CLARIFICATION',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF92400e))),
          const SizedBox(height: 6),
          const Text('There are two valid ways to calculate OI depending on how FiO2 is entered:\n',
              style: TextStyle(fontSize: 12, color: Color(0xFF78350f), height: 1.5)),
          _formulaLine('Mode A (Percentage):', 'OI = (MAP × FiO2%) / PaO2', '— Enter FiO2 as 40 (for 40%)'),
          _formulaLine('Mode B (Decimal):', 'OI = (MAP × FiO2 × 100) / PaO2', '— Enter FiO2 as 0.40 (for 40%)'),
          const SizedBox(height: 6),
          const Text('Both give identical results! Choose your preferred input method below.',
              style: TextStyle(fontSize: 12, color: Color(0xFF78350f), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _formulaLine(String label, String formula, String note) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 12, color: Color(0xFF78350f), height: 1.5),
          children: [
            TextSpan(text: '$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: formula, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold)),
            TextSpan(text: ' $note'),
          ],
        ),
      ),
    );
  }

  // ── Tabs ─────────────────────────────────────────────────────────────────────
  Widget _buildTabs() {
    const labels = ['Conventional Ventilation', 'HFOV (High Frequency Oscillatory)', 'Non-Invasive (CPAP)'];
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: labels.asMap().entries.map((e) {
          final active = _activeTab == e.key;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _activeTab = e.key),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                decoration: BoxDecoration(
                  color: active ? _primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  e.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Tab content ───────────────────────────────────────────────────────────────
  Widget _buildTabContent() {
    switch (_activeTab) {
      case 0:  return _buildTab1();
      case 1:  return _buildTab2();
      default: return _buildTab3();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB 1 — Conventional
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildTab1() {
    return Column(
      children: [
        _buildOICard(),
        const SizedBox(height: 12),
        _buildOSICard(),
        const SizedBox(height: 12),
        _buildMAPCard(),
        const SizedBox(height: 12),
        _buildCorrelationCard(),
      ],
    );
  }

  // ── OI Card ───────────────────────────────────────────────────────────────────
  Widget _buildOICard() {
    final oiFio2Label = _oiFio2Mode == 'percent' ? 'FiO2 (%)' : 'FiO2 (decimal)';
    final oiFio2Hint  = _oiFio2Mode == 'percent' ? 'Enter as percentage (21-100)' : 'Enter as decimal (0.21-1.00)';
    final oiFio2PH    = _oiFio2Mode == 'percent' ? 'e.g., 40' : 'e.g., 0.40';
    final formulaText = _oiFio2Mode == 'percent'
        ? 'Current Formula: OI = (MAP × FiO2%) / PaO2 — Enter FiO2 as percentage (21-100)'
        : 'Current Formula: OI = (MAP × FiO2 × 100) / PaO2 — Enter FiO2 as decimal (0.21-1.00)';

    return _card(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text('🫁 Oxygenation Index (OI)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(width: 8),
          _badge('CORRECTED', _danger),
        ]),
        const SizedBox(height: 12),
        _fio2ModeRow(_oiFio2Mode, (v) { setState(() { _oiFio2Mode = v; _oiFio2Error = ''; _oiResult = null; }); }),
        const SizedBox(height: 8),
        _formulaBox(formulaText),
        const SizedBox(height: 12),
        _numField(label: 'Mean Airway Pressure (MAP)', ctrl: _oiMapCtrl, hint: 'e.g., 12', helperText: 'cmH2O',
            onChanged: (v) { _oiMap = double.tryParse(v); _calcOI(); }),
        const SizedBox(height: 8),
        _numField(label: oiFio2Label, ctrl: _oiFio2Ctrl, hint: oiFio2PH, helperText: oiFio2Hint,
            onChanged: (v) { _oiFio2Input = double.tryParse(v); _calcOI(); }),
        if (_oiFio2Error.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(_oiFio2Error, style: const TextStyle(color: _danger, fontSize: 11.5)),
        ],
        const SizedBox(height: 8),
        _numField(label: 'PaO2 (mmHg)', ctrl: _oiPao2Ctrl, hint: 'e.g., 55', helperText: 'From arterial blood gas',
            onChanged: (v) { _oiPao2 = double.tryParse(v); _calcOI(); }),
        if (_oiResult != null) ...[
          const SizedBox(height: 12),
          _resultBox(_oiResult!.toStringAsFixed(1), 'Oxygenation Index', _oiCat(_oiResult!)),
          const SizedBox(height: 8),
          _calcStepsBox(_oiCalcSteps()),
          const SizedBox(height: 8),
          _infoAlert('Validation: Normal lungs on room air: MAP ~5, FiO2 21%, PaO2 ~80 → OI ≈ 1.3'),
        ],
      ],
    ));
  }

  String _oiCalcSteps() {
    if (_oiMap == null || _oiFio2Input == null || _oiPao2 == null) return '';
    if (_oiFio2Mode == 'percent') {
      return '(MAP × fio2_percent) / pao2 = (${_oiMap!.toStringAsFixed(1)} × ${_oiFio2Input!.toStringAsFixed(0)}) / ${_oiPao2!.toStringAsFixed(0)} = ${_oiResult?.toStringAsFixed(1)}';
    } else {
      final pct = (_oiFio2Input! * 100).toStringAsFixed(0);
      return '(MAP × fio2_input × 100) / pao2 = (${_oiMap!.toStringAsFixed(1)} × ${_oiFio2Input!.toStringAsFixed(2)} × 100) / ${_oiPao2!.toStringAsFixed(0)} = (${_oiMap!.toStringAsFixed(1)} × $pct) / ${_oiPao2!.toStringAsFixed(0)} = ${_oiResult?.toStringAsFixed(1)}';
    }
  }

  // ── OSI Card ──────────────────────────────────────────────────────────────────
  Widget _buildOSICard() {
    final label      = _osiFio2Mode == 'percent' ? 'FiO2 (%)' : 'FiO2 (decimal)';
    final helperText = _osiFio2Mode == 'percent' ? 'Enter as percentage (21-100)' : 'Enter as decimal (0.21-1.00)';
    final ph         = _osiFio2Mode == 'percent' ? 'e.g., 60' : 'e.g., 0.60';
    final formulaText = _osiFio2Mode == 'percent'
        ? 'Current Formula: OSI = (MAP × FiO2%) / SpO2 — Enter FiO2 as percentage (21-100)'
        : 'Current Formula: OSI = (MAP × FiO2 × 100) / SpO2 — Enter FiO2 as decimal (0.21-1.00)';

    return _card(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text('📊 Oxygen Saturation Index (OSI)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(width: 8),
          _badge('Non-invasive', _success),
        ]),
        const SizedBox(height: 12),
        _fio2ModeRow(_osiFio2Mode, (v) { setState(() { _osiFio2Mode = v; _osiResult = null; }); }),
        const SizedBox(height: 8),
        _formulaBox(formulaText),
        const SizedBox(height: 12),
        _numField(label: 'Mean Airway Pressure (MAP)', ctrl: _osiMapCtrl, hint: 'e.g., 12', helperText: 'cmH2O',
            onChanged: (v) { _osiMap = double.tryParse(v); _calcOSI(); }),
        const SizedBox(height: 8),
        _numField(label: label, ctrl: _osiFio2Ctrl, hint: ph, helperText: helperText,
            onChanged: (v) { _osiFio2Input = double.tryParse(v); _calcOSI(); }),
        const SizedBox(height: 8),
        _numField(label: 'SpO2 (%)', ctrl: _osiSpo2Ctrl, hint: 'e.g., 92', helperText: 'Pulse oximeter reading',
            onChanged: (v) { _osiSpo2 = double.tryParse(v); _calcOSI(); }),
        if (_osiResult != null) ...[
          const SizedBox(height: 12),
          _resultBox(_osiResult!.toStringAsFixed(1), 'Oxygen Saturation Index', _osiCat(_osiResult!)),
          const SizedBox(height: 8),
          _calcStepsBox(_osiCalcSteps()),
          const SizedBox(height: 8),
          _infoAlert('Correlation: OI ≈ (2.3 × OSI) - 4'),
        ],
      ],
    ));
  }

  String _osiCalcSteps() {
    if (_osiMap == null || _osiFio2Input == null || _osiSpo2 == null) return '';
    if (_osiFio2Mode == 'percent') {
      return '(MAP × fio2_percent) / spo2 = (${_osiMap!.toStringAsFixed(1)} × ${_osiFio2Input!.toStringAsFixed(0)}) / ${_osiSpo2!.toStringAsFixed(0)} = ${_osiResult?.toStringAsFixed(1)}';
    } else {
      final pct = (_osiFio2Input! * 100).toStringAsFixed(0);
      return '(MAP × fio2_input × 100) / spo2 = (${_osiMap!.toStringAsFixed(1)} × ${_osiFio2Input!.toStringAsFixed(2)} × 100) / ${_osiSpo2!.toStringAsFixed(0)} = (${_osiMap!.toStringAsFixed(1)} × $pct) / ${_osiSpo2!.toStringAsFixed(0)} = ${_osiResult?.toStringAsFixed(1)}';
    }
  }

  // ── MAP Card ──────────────────────────────────────────────────────────────────
  Widget _buildMAPCard() {
    return _card(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('📐 Mean Airway Pressure (MAP)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 10),
        _darkBox('MAP = [K × (PIP - PEEP) × (Ti/Ttotal)] + PEEP'),
        const SizedBox(height: 12),
        LayoutBuilder(builder: (ctx, c) {
          final wide = c.maxWidth > 500;
          final fields = [
            _numField(label: 'PIP (Peak Inspiratory Pressure)', ctrl: _mapPipCtrl, hint: 'e.g., 24', helperText: 'cmH2O',
                onChanged: (v) { _mapPip = double.tryParse(v); _calcMAP(); }),
            _numField(label: 'PEEP', ctrl: _mapPeepCtrl, hint: 'e.g., 5', helperText: 'cmH2O',
                onChanged: (v) { _mapPeep = double.tryParse(v); _calcMAP(); }),
            _numField(label: 'Inspiratory Time (Ti)', ctrl: _mapTiCtrl, hint: 'e.g., 0.4', helperText: 'seconds',
                onChanged: (v) { _mapTi = double.tryParse(v); _calcMAP(); }),
            _numField(label: 'Ventilator Rate', ctrl: _mapRateCtrl, hint: 'e.g., 40', helperText: 'breaths/min',
                onChanged: (v) { _mapRate = double.tryParse(v); _calcMAP(); }),
          ];
          if (wide) {
            return Column(children: [
              Row(children: [Expanded(child: fields[0]), const SizedBox(width: 10), Expanded(child: fields[1])]),
              const SizedBox(height: 8),
              Row(children: [Expanded(child: fields[2]), const SizedBox(width: 10), Expanded(child: fields[3])]),
            ]);
          }
          return Column(children: fields.map((f) => Padding(padding: const EdgeInsets.only(bottom: 8), child: f)).toList());
        }),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Waveform Constant (K)', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 6),
            _kDropdown(),
          ],
        ),
        if (_mapResult != null) ...[
          const SizedBox(height: 12),
          _resultBox(_mapResult!.toStringAsFixed(1), 'cmH2O', null),
          const SizedBox(height: 8),
          _calcStepsBox(_mapCalcSteps()),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: _success.withValues(alpha: .08), border: Border.all(color: _success.withValues(alpha: .3)), borderRadius: BorderRadius.circular(6)),
            child: const Text('✓ MAP auto-filled into OI and OSI calculators above', style: TextStyle(color: _success, fontSize: 11.5, fontWeight: FontWeight.w600)),
          ),
        ],
      ],
    ));
  }

  String _mapCalcSteps() {
    if (_mapPip == null || _mapPeep == null || _mapTi == null || _mapRate == null) return '';
    final ttotal = 60 / _mapRate!;
    return 'Ttotal = 60/${_mapRate!.toStringAsFixed(0)} = ${ttotal.toStringAsFixed(2)}s\n'
        'MAP = $_mapK × (${_mapTi!.toStringAsFixed(2)}/${ttotal.toStringAsFixed(2)}) × (${_mapPip!.toStringAsFixed(0)}-${_mapPeep!.toStringAsFixed(0)}) + ${_mapPeep!.toStringAsFixed(0)}\n'
        '= ${_mapResult!.toStringAsFixed(1)} cmH2O';
  }

  Widget _kDropdown() {
    final items = [
      {'label': 'Square (K=1.0)',    'val': 1.0},
      {'label': 'Sine (K=0.64)',     'val': 0.64},
      {'label': 'Triangular (K=0.5)','val': 0.5},
    ];
    return Builder(builder: (context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(8)),
      child: DropdownButton<double>(
        value: _mapK,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        items: items.map((e) => DropdownMenuItem<double>(value: e['val'] as double, child: Text(e['label'] as String, style: const TextStyle(fontSize: 12.5)))).toList(),
        onChanged: (v) { setState(() => _mapK = v ?? 0.64); _calcMAP(); },
      ),
    ));
  }

  // ── Correlation Card ──────────────────────────────────────────────────────────
  Widget _buildCorrelationCard() {
    return _card(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('📈 OI vs OSI Correlation', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 12),
        if (_oiResult == null || _osiResult == null)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFf1f5f9), borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text('Enter values in both calculators to see correlation', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12.5))),
          )
        else
          _buildCorrelationGrid(),
      ],
    ));
  }

  Widget _buildCorrelationGrid() {
    final oi = _oiResult!;
    final osi = _osiResult!;
    final predOI = (2.3 * osi) - 4;
    final diff = (oi - predOI).abs();
    final diffColor = diff > 5 ? _danger : _success;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.8,
      children: [
        _corrBox('Measured OI', oi.toStringAsFixed(1), _primary),
        _corrBox('Measured OSI', osi.toStringAsFixed(1), _success),
        _corrBox('Predicted OI from OSI', '${predOI.toStringAsFixed(1)}\n(2.3 × OSI - 4)', _purple),
        _corrBox('Difference', diff.toStringAsFixed(1), diffColor),
      ],
    );
  }

  Widget _corrBox(String label, String val, Color color) {
    return Builder(builder: (context) => Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        border: Border.all(color: color.withValues(alpha: .4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 10.5)),
          const SizedBox(height: 2),
          Text(val, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    ));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB 2 — HFOV
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildTab2() {
    return Column(
      children: [
        _buildHfovOICard(),
        const SizedBox(height: 12),
        _buildDco2Card(),
        const SizedBox(height: 12),
        _buildHfovQuickRef(),
        const SizedBox(height: 12),
        _buildTargetDco2Card(),
      ],
    );
  }

  Widget _buildHfovOICard() {
    final formulaText = _hfovFio2Mode == 'percent'
        ? 'Formula: OI = (MAP × FiO2%) / PaO2'
        : 'Formula: OI = (MAP × FiO2 × 100) / PaO2';
    final ph = _hfovFio2Mode == 'percent' ? 'e.g., 50' : 'e.g., 0.50';
    final label = _hfovFio2Mode == 'percent' ? 'FiO2 (%)' : 'FiO2 (decimal)';
    final helper = _hfovFio2Mode == 'percent' ? 'Enter as percentage (21-100)' : 'Enter as decimal (0.21-1.00)';

    return _hfovCard(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text('🌊 HFOV Oxygenation Index', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(width: 8),
          _badge('HFOV', _purple),
        ]),
        const SizedBox(height: 12),
        _fio2ModeRow(_hfovFio2Mode, (v) { setState(() { _hfovFio2Mode = v; _hfovOiResult = null; }); }),
        const SizedBox(height: 8),
        _formulaBox(formulaText),
        const SizedBox(height: 12),
        _numField(label: 'HFOV MAP', ctrl: _hfovMapCtrl, hint: 'e.g., 14', helperText: 'cmH2O (set on oscillator)',
            onChanged: (v) { _hfovMap = double.tryParse(v); _calcHfovOI(); }),
        const SizedBox(height: 8),
        _numField(label: label, ctrl: _hfovFio2Ctrl, hint: ph, helperText: helper,
            onChanged: (v) { _hfovFio2Input = double.tryParse(v); _calcHfovOI(); }),
        const SizedBox(height: 8),
        _numField(label: 'PaO2 (mmHg)', ctrl: _hfovPao2Ctrl, hint: 'e.g., 60', helperText: '',
            onChanged: (v) { _hfovPao2 = double.tryParse(v); _calcHfovOI(); }),
        if (_hfovOiResult != null) ...[
          const SizedBox(height: 12),
          _resultBox(_hfovOiResult!.toStringAsFixed(1), 'HFOV OI', _oiCat(_hfovOiResult!)),
        ],
      ],
    ));
  }

  Widget _buildDco2Card() {
    String stepsText = '';
    if (_dco2Vthf != null && _dco2Freq != null) {
      final vthfAbs = _dco2Weight != null ? _dco2Vthf! * (_dco2Weight! / 1000) : _dco2Vthf!;
      if (_dco2Weight != null) {
        stepsText = 'DCO2 = ${vthfAbs.toStringAsFixed(1)}² × ${_dco2Freq!.toStringAsFixed(0)} = ${_dco2Result?.toStringAsFixed(0)}\n'
            '(VThf: ${_dco2Vthf!.toStringAsFixed(1)} mL/kg × ${(_dco2Weight! / 1000).toStringAsFixed(3)} kg = ${vthfAbs.toStringAsFixed(1)} mL)';
      } else {
        stepsText = 'DCO2 = ${_dco2Vthf!.toStringAsFixed(1)}² × ${_dco2Freq!.toStringAsFixed(0)} = ${_dco2Result?.toStringAsFixed(0)}';
      }
    }

    return _hfovCard(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text('💨 DCO2 (Diffusion Coefficient)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(width: 8),
          _badge('CO2 Elimination', _purple),
        ]),
        const SizedBox(height: 10),
        _darkBox('DCO2 = VThf² × f'),
        const SizedBox(height: 12),
        _numField(label: 'Tidal Volume (VThf)', ctrl: _dco2VthfCtrl, hint: 'e.g., 2.0', helperText: 'mL/kg (typically 1-3 mL/kg)',
            onChanged: (v) { _dco2Vthf = double.tryParse(v); _calcDco2(); }),
        const SizedBox(height: 8),
        _numField(label: 'Frequency (f)', ctrl: _dco2FreqCtrl, hint: 'e.g., 10', helperText: 'Hz (10-15 Hz preterm, 8-10 Hz term)',
            onChanged: (v) { _dco2Freq = double.tryParse(v); _calcDco2(); }),
        const SizedBox(height: 8),
        _numField(label: 'Weight (optional)', ctrl: _dco2WeightCtrl, hint: 'e.g., 1500', helperText: 'grams (for absolute VThf calculation)',
            onChanged: (v) { _dco2Weight = double.tryParse(v); _calcDco2(); }),
        if (_dco2Result != null) ...[
          const SizedBox(height: 12),
          _resultBox(_dco2Result!.toStringAsFixed(0), 'DCO2 (mL²·Hz)', null),
          const SizedBox(height: 8),
          _calcStepsBox(stepsText),
        ],
      ],
    ));
  }

  Widget _buildHfovQuickRef() {
    return _hfovCard(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('⚙️ HFOV Quick Reference', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            border: TableBorder.all(color: Theme.of(context).colorScheme.outline),
            defaultColumnWidth: const IntrinsicColumnWidth(),
            children: [
              TableRow(
                decoration: BoxDecoration(color: _primary.withValues(alpha: .9)),
                children: [
                  _th('Parameter', minW: 90), _th('Preterm (<1000g)', minW: 100), _th('Preterm (>1000g)', minW: 100), _th('Term', minW: 80),
                ],
              ),
              _qrRow('Frequency', '15 Hz', '10-12 Hz', '8-10 Hz'),
              _qrRow('Initial MAP', '8-10 cmH2O', '10-12 cmH2O', '12-15 cmH2O'),
              TableRow(
                decoration: const BoxDecoration(color: _highlight),
                children: [
                  _tdp('Amplitude (ΔP)', FontWeight.w600),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text('Adjust for chest wiggle (shoulders to umbilicus)',
                        style: TextStyle(fontSize: 11.5, color: Theme.of(context).colorScheme.onSurface), textAlign: TextAlign.left),
                  ),
                  const SizedBox.shrink(),
                  const SizedBox.shrink(),
                ],
              ),
              _qrRow('Bias Flow', '8-15 L/min', '10-20 L/min', '15-25 L/min'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: _warning.withValues(alpha: .1), border: Border.all(color: _warning.withValues(alpha: .5)), borderRadius: BorderRadius.circular(8)),
          child: const Text(
            'Strategy: High Volume (MAP 3-5 above CMV) for atelectasis; Low Volume (MAP 1-2 above CMV) for air leak',
            style: TextStyle(color: Color(0xFF78350f), fontSize: 12, height: 1.4),
          ),
        ),
      ],
    ));
  }

  TableRow _qrRow(String p, String a, String b, String c) {
    return TableRow(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      children: [_tdp(p, FontWeight.w600), _tdp(a, FontWeight.normal), _tdp(b, FontWeight.normal), _tdp(c, FontWeight.normal)],
    );
  }

  Widget _buildTargetDco2Card() {
    return _hfovCard(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🎯 PaCO2 Targeting', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 10),
        _darkBox('Target DCO2 = Current DCO2 × (Current PaCO2 / Target PaCO2)'),
        const SizedBox(height: 12),
        _numField(label: 'Current PaCO2', ctrl: _tCurrPaco2Ctrl, hint: 'e.g., 55', helperText: '',
            onChanged: (v) { _tCurrPaco2 = double.tryParse(v); _calcTargetDco2(); }),
        const SizedBox(height: 8),
        _numField(label: 'Current DCO2', ctrl: _tCurrDco2Ctrl, hint: 'e.g., 50', helperText: '',
            onChanged: (v) { _tCurrDco2 = double.tryParse(v); _calcTargetDco2(); }),
        const SizedBox(height: 8),
        _numField(label: 'Target PaCO2', ctrl: _tTargetPaco2Ctrl, hint: 'e.g., 45', helperText: '',
            onChanged: (v) { _tTargetPaco2 = double.tryParse(v); _calcTargetDco2(); }),
        if (_targetDco2Result != null) ...[
          const SizedBox(height: 12),
          _resultBox(_targetDco2Result!.toStringAsFixed(0), 'Target DCO2 Needed', null),
        ],
      ],
    ));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB 3 — CPAP
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildTab3() {
    return Column(
      children: [
        _buildSOPICard(),
        const SizedBox(height: 12),
        _buildSFCard(),
        const SizedBox(height: 12),
        _buildROXCard(),
      ],
    );
  }

  Widget _buildSOPICard() {
    return _card(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('📉 SOPI (Saturation Oxygenation Pressure Index)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 10),
        _darkBox('SOPI = (CPAP × FiO2) / SpO2\nFiO2 and SpO2 as decimals (e.g., 0.40 and 0.92)'),
        const SizedBox(height: 12),
        _numField(label: 'CPAP Pressure', ctrl: _sopiCpapCtrl, hint: 'e.g., 6', helperText: 'cmH2O',
            onChanged: (v) { _sopiCpap = double.tryParse(v); _calcSOPI(); }),
        const SizedBox(height: 8),
        _numField(label: 'FiO2 (decimal)', ctrl: _sopiFio2Ctrl, hint: 'e.g., 0.40', helperText: '0.21-1.00 (e.g., 40% = 0.40)',
            onChanged: (v) { _sopiFio2 = double.tryParse(v); _calcSOPI(); }),
        const SizedBox(height: 8),
        _numField(label: 'SpO2 (decimal)', ctrl: _sopiSpo2Ctrl, hint: 'e.g., 0.92', helperText: '0.50-1.00 (e.g., 92% = 0.92)',
            onChanged: (v) { _sopiSpo2 = double.tryParse(v); _calcSOPI(); }),
        if (_sopiResult != null) ...[
          const SizedBox(height: 12),
          _resultBox(_sopiResult!.toStringAsFixed(2), 'SOPI', null),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: _info.withValues(alpha: .1), borderRadius: BorderRadius.circular(6)),
            child: const Text('SOPI > 1.6 ≈ AaDO2 > 70 mmHg (severe)', style: TextStyle(color: _info, fontSize: 12)),
          ),
        ],
      ],
    ));
  }

  Widget _buildSFCard() {
    return _card(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('📊 SpO2/FiO2 (S/F) Ratio', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 10),
        _darkBox('S/F = SpO2 / FiO2'),
        const SizedBox(height: 12),
        _numField(label: 'SpO2 (%)', ctrl: _sfSpo2Ctrl, hint: 'e.g., 92', helperText: '',
            onChanged: (v) { _sfSpo2 = double.tryParse(v); _calcSF(); }),
        const SizedBox(height: 8),
        _numField(label: 'FiO2 (%)', ctrl: _sfFio2Ctrl, hint: 'e.g., 40', helperText: '',
            onChanged: (v) { _sfFio2 = double.tryParse(v); _calcSF(); }),
        if (_sfResult != null) ...[
          const SizedBox(height: 12),
          _resultBox(_sfResult!.toStringAsFixed(1), 'S/F Ratio', null),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: _info.withValues(alpha: .1), borderRadius: BorderRadius.circular(6)),
            child: const Text('Normal > 250, Mild 200-250, Moderate 150-200, Severe < 150', style: TextStyle(color: _info, fontSize: 12)),
          ),
        ],
      ],
    ));
  }

  Widget _buildROXCard() {
    return _card(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('📈 ROX Index (Weaning Predictor)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 10),
        _darkBox('ROX = (SpO2/FiO2) / RR'),
        const SizedBox(height: 12),
        _numField(label: 'SpO2 (%)', ctrl: _roxSpo2Ctrl, hint: 'e.g., 94', helperText: '',
            onChanged: (v) { _roxSpo2 = double.tryParse(v); _calcROX(); }),
        const SizedBox(height: 8),
        _numField(label: 'FiO2 (%)', ctrl: _roxFio2Ctrl, hint: 'e.g., 30', helperText: '',
            onChanged: (v) { _roxFio2 = double.tryParse(v); _calcROX(); }),
        const SizedBox(height: 8),
        _numField(label: 'Respiratory Rate', ctrl: _roxRrCtrl, hint: 'e.g., 45', helperText: 'breaths/min',
            onChanged: (v) { _roxRr = double.tryParse(v); _calcROX(); }),
        if (_roxResult != null) ...[
          const SizedBox(height: 12),
          _resultBox(_roxResult!.toStringAsFixed(2), 'ROX Index', null),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: _info.withValues(alpha: .1), borderRadius: BorderRadius.circular(6)),
            child: const Text('> 4.88 at 2h predicts HFNC success', style: TextStyle(color: _info, fontSize: 12)),
          ),
        ],
      ],
    ));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Severity Table
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildSeverityTable() {
    final hlRow = _severityRowIdx(_oiResult);
    const rows = [
      ['Mild', '< 5', 'Minimal lung disease', 'Conventional ventilation, wean as tolerated'],
      ['Moderate', '5 - 15', 'Moderate respiratory failure', 'Optimize conventional ventilation, consider surfactant'],
      ['Severe', '16 - 25', 'Severe respiratory failure', 'Consider HFOV, iNO if PPHN'],
      ['Very Severe', '26 - 40', 'Very severe respiratory failure', 'HFOV mandatory, iNO, consider paralysis'],
      ['ECMO Consider', '> 40-60', 'Refractory hypoxemia', 'ECMO evaluation if available'],
    ];
    const badgeColors = [_success, _warning, _orange, _danger, _purple];

    return _card(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('📋 OI Severity Classification & Clinical Actions',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            border: TableBorder.all(color: Theme.of(context).colorScheme.outline),
            defaultColumnWidth: const IntrinsicColumnWidth(),
            children: [
              TableRow(
                decoration: BoxDecoration(color: _primary.withValues(alpha: .9)),
                children: [
                  _th('Severity', minW: 100), _th('OI Range', minW: 70),
                  _th('Clinical Interpretation', minW: 160), _th('Recommended Actions', minW: 200),
                ],
              ),
              ...rows.asMap().entries.map((e) {
                final i = e.key;
                final r = e.value;
                final isHL = hlRow == i;
                return TableRow(
                  decoration: BoxDecoration(color: isHL ? _highlight : Theme.of(context).cardColor),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: _badge(r[0], badgeColors[i]),
                    ),
                    _tdp(r[1], FontWeight.w600),
                    _tdp(r[2], isHL ? FontWeight.bold : FontWeight.normal),
                    _tdp(r[3], isHL ? FontWeight.bold : FontWeight.normal),
                  ],
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: _danger.withValues(alpha: .08), border: Border.all(color: _danger.withValues(alpha: .4)), borderRadius: BorderRadius.circular(8)),
          child: const Text(
            'ECMO Criteria: OI > 40 on maximum support (HFOV + iNO) for > 4-6 hours, or OI > 60 at any time.',
            style: TextStyle(color: _danger, fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Formula Reference
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildFormulaReference() {
    return _card(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('📐 Correct Formula Reference', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 12),
        LayoutBuilder(builder: (ctx, c) {
          final wide = c.maxWidth > 600;
          final col1 = _refCol(
            'Standard OI Formula (US/International)',
            'OI = (MAP × FiO2%) / PaO2\nWhere:\n- MAP = cmH2O\n- FiO2% = percentage (e.g., 40 for 40%)\n- PaO2 = mmHg\n\nExample:\nMAP 12, FiO2 40%, PaO2 55\nOI = (12 × 40) / 55 = 8.7',
            false,
          );
          final col2 = _refCol(
            'Alternative OI Formula (Decimal Input)',
            'OI = (MAP × FiO2 × 100) / PaO2\nWhere:\n- MAP = cmH2O\n- FiO2 = decimal (e.g., 0.40 for 40%)\n- PaO2 = mmHg\n- × 100 converts decimal to %\n\nExample:\nMAP 12, FiO2 0.40, PaO2 55\nOI = (12 × 0.40 × 100) / 55 = 8.7',
            false,
          );
          final col3 = _refColGreen(
            'Key Validation Check',
            'Normal Lungs on Room Air:\nMAP ~5 cmH2O\nFiO2 21% (or 0.21)\nPaO2 ~80 mmHg\n\nExpected OI:\n(5 × 21) / 80 = 1.3\nor\n(5 × 0.21 × 100) / 80 = 1.3\n\nIf your OI is 10× higher, check FiO2 input mode!',
          );
          if (wide) {
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: col1), const SizedBox(width: 10), Expanded(child: col2), const SizedBox(width: 10), Expanded(child: col3),
            ]);
          }
          return Column(children: [col1, const SizedBox(height: 10), col2, const SizedBox(height: 10), col3]);
        }),
      ],
    ));
  }

  Widget _refCol(String title, String body, bool green) {
    return Builder(builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 6),
        _darkBox(body),
      ],
    ));
  }

  Widget _refColGreen(String title, String body) {
    return Builder(builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: _success, borderRadius: BorderRadius.circular(8)),
          child: Text(body, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontFamily: 'monospace', height: 1.6)),
        ),
      ],
    ));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Shared helpers
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .04), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: child,
    );
  }

  Widget _hfovCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFfaf5ff), Color(0xFFf3e8ff)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(color: _purple.withValues(alpha: .4)),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .04), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: child,
    );
  }

  Widget _numField({
    required String label, required TextEditingController ctrl,
    required String hint, required String helperText,
    required ValueChanged<String> onChanged,
  }) {
    return Builder(builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12),
            helperText: helperText.isEmpty ? null : helperText,
            helperStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 11),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Theme.of(context).colorScheme.outline)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Theme.of(context).colorScheme.outline)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _primary, width: 2)),
          ),
          onChanged: onChanged,
        ),
      ],
    ));
  }

  Widget _fio2ModeRow(String mode, ValueChanged<String> onChange) {
    return Row(
      children: [
        _modeChip('FiO2 as % (e.g., 40)', 'percent', mode, onChange),
        const SizedBox(width: 10),
        _modeChip('FiO2 as decimal (e.g., 0.40)', 'decimal', mode, onChange),
      ],
    );
  }

  Widget _modeChip(String label, String val, String current, ValueChanged<String> onChange) {
    final sel = current == val;
    return Builder(builder: (context) => GestureDetector(
      onTap: () => onChange(val),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16, height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: sel ? _primary : Theme.of(context).colorScheme.outline, width: 2),
              color: sel ? _primary : Colors.transparent,
            ),
            child: sel ? const Center(child: CircleAvatar(radius: 3, backgroundColor: Colors.white)) : null,
          ),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, color: sel ? _primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontWeight: sel ? FontWeight.w600 : FontWeight.normal)),
        ],
      ),
    ));
  }

  Widget _formulaBox(String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        border: Border.all(color: _warning.withValues(alpha: .5)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF78350f), fontWeight: FontWeight.w500)),
    );
  }

  Widget _darkBox(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF1e293b), borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'monospace', height: 1.6)),
    );
  }

  Widget _calcStepsBox(String text) {
    return Builder(builder: (context) => Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: const Color(0xFFf1f5f9), borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(fontSize: 11.5, fontFamily: 'monospace', color: Theme.of(context).colorScheme.onSurface, height: 1.6)),
    ));
  }

  Widget _infoAlert(String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _info.withValues(alpha: .08),
        border: Border.all(color: _info.withValues(alpha: .4)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: const TextStyle(color: _info, fontSize: 12)),
    );
  }

  Widget _resultBox(String value, String label, ({String label, Color color})? category) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_primary, _primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          if (category != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: .9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(category.label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: .15), border: Border.all(color: color.withValues(alpha: .5)), borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _th(String t, {double minW = 80}) {
    return Container(
      constraints: BoxConstraints(minWidth: minW),
      padding: const EdgeInsets.all(8),
      child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold)),
    );
  }

  Widget _tdp(String t, FontWeight fw) {
    return Builder(builder: (context) => Padding(
      padding: const EdgeInsets.all(8),
      child: Text(t, style: TextStyle(fontSize: 11.5, color: Theme.of(context).colorScheme.onSurface, fontWeight: fw, height: 1.4)),
    ));
  }
}
