import 'package:flutter/material.dart';
import 'dart:math';

// ── Colors ────────────────────────────────────────────────────────────────────
const Color _primary     = Color(0xFF2563eb);
const Color _primaryDark = Color(0xFF1d4ed8);
const Color _danger      = Color(0xFFdc2626);
const Color _warning     = Color(0xFFf59e0b);
const Color _success     = Color(0xFF16a34a);
const Color _info        = Color(0xFF0891b2);
// _bg removed - using Theme.of(context).scaffoldBackgroundColor
const Color _highlight   = Color(0xFFfef3c7);

const int _bloodVolTerm    = 85;
const int _bloodVolPreterm = 95;

// ── Result model ──────────────────────────────────────────────────────────────
class _DvetResult {
  final double weightKg;
  final int bloodVolPerKg;
  final double totalBloodVol;
  final double doubleVolume;
  final int aliquotSize;
  final int numCycles;
  final int procedureMinutes;
  final int procHours;
  final int procMins;
  final String volumeCalcText;
  final String aliquotCalcText;
  final String withdrawVol;
  final String infuseVol;
  final int highlightRow; // 0=<1000, 1=1000-2000, 2=>2000
  // blood
  final String bloodRec;
  final String crossmatch;
  final String unitsToOrder;
  final int highlightBloodRow; // 1-5, 0=none
  final String finalBloodRec;
  // indication
  final String indicationText;
  final String indicationLevel; // green/amber/neutral
  // summary
  final String summaryVolume;
  final String summaryAliquot;
  final String summaryCycles;

  const _DvetResult({
    required this.weightKg,
    required this.bloodVolPerKg,
    required this.totalBloodVol,
    required this.doubleVolume,
    required this.aliquotSize,
    required this.numCycles,
    required this.procedureMinutes,
    required this.procHours,
    required this.procMins,
    required this.volumeCalcText,
    required this.aliquotCalcText,
    required this.withdrawVol,
    required this.infuseVol,
    required this.highlightRow,
    required this.bloodRec,
    required this.crossmatch,
    required this.unitsToOrder,
    required this.highlightBloodRow,
    required this.finalBloodRec,
    required this.indicationText,
    required this.indicationLevel,
    required this.summaryVolume,
    required this.summaryAliquot,
    required this.summaryCycles,
  });
}

// ── Main widget ───────────────────────────────────────────────────────────────
class DoubleVolumeExchange extends StatefulWidget {
  const DoubleVolumeExchange({super.key});
  @override
  State<DoubleVolumeExchange> createState() => _DoubleVolumeExchangeState();
}

class _DoubleVolumeExchangeState extends State<DoubleVolumeExchange>
    with SingleTickerProviderStateMixin {
  // Inputs
  double? _weight;
  int?    _gestAge;

  String  _riskLevel = 'low';
  double? _tsb;
  String  _neoType   = '';
  String  _neoRh     = 'pos';
  String  _momType   = '';
  String  _momRh     = 'pos';
  String  _hemoType  = 'none';

  final _weightCtrl      = TextEditingController();
  final _gestCtrl        = TextEditingController();
  final _postnatalCtrl   = TextEditingController();
  final _tsbCtrl         = TextEditingController();

  _DvetResult? _result;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _weightCtrl.dispose();
    _gestCtrl.dispose();
    _postnatalCtrl.dispose();
    _tsbCtrl.dispose();
    super.dispose();
  }

  // ── Calculate ────────────────────────────────────────────────────────────────
  void _calculate() {
    if (_weight == null) {
      setState(() => _result = null);
      return;
    }
    final weight    = _weight!;
    final weightKg  = weight / 1000.0;
    final gestAge   = _gestAge;
    final isPreterm = gestAge != null && gestAge < 37;
    final bvpkg     = isPreterm ? _bloodVolPreterm : _bloodVolTerm;
    final totalBV   = weightKg * bvpkg;
    final doubleVol = totalBV * 2;

    // Aliquot
    int aliquot;
    if (weight < 1000) {
      aliquot = 5;
    } else if (weight <= 2000) {
      aliquot = 10;
    } else {
      aliquot = min(max((weightKg * 5).round(), 15), 20);
    }

    final numCycles    = (doubleVol / aliquot).ceil();
    final procMin      = numCycles * 5;
    final procH        = procMin ~/ 60;
    final procM        = procMin % 60;

    final volCalc =
        'Blood Volume = ${weightKg.toStringAsFixed(2)} kg × $bvpkg mL/kg = ${totalBV.round()} mL\n'
        'Double Volume = 2 × ${totalBV.round()} = ${doubleVol.round()} mL\n\n'
        'Aliquot Calculation:\n'
        'Based on weight ${weight.toInt()}g: $aliquot mL per cycle\n'
        'Number of cycles: ${doubleVol.round()} ÷ $aliquot = $numCycles cycles\n'
        'Total time: $numCycles × 5 min = ${procH}h ${procM}min';

    final aliquotCalc = 'Your calculated aliquot: $aliquot mL per cycle';

    final withdrawVol = '$aliquot mL';
    final infuseVol   = '$aliquot mL';

    int highlightRow = weight < 1000 ? 0 : weight <= 2000 ? 1 : 2;

    // Blood selection
    String bloodRec    = 'Enter blood types to see specific recommendation';
    String crossmatch  = 'Pending blood type entry';
    int    hlBlood     = 0;

    final hasBloodTypes = _neoType.isNotEmpty && _momType.isNotEmpty;

    if (hasBloodTypes) {
      if (_hemoType == 'rh' && _momRh == 'neg' && _neoRh == 'pos') {
        hlBlood = 3;
        if (_hemoType == 'abo' && _momType == 'O' &&
            (_neoType == 'A' || _neoType == 'B')) {
          hlBlood   = 4;
          bloodRec  = 'O NEGATIVE (Rh-negative mandatory, Type O for ABO compatibility)';
          crossmatch = 'Major crossmatch against mother (must lack D antigen and anti-A/anti-B)';
        } else {
          bloodRec  = 'O Negative OR $_neoType Negative (Rh-negative mandatory)';
          crossmatch = 'Crossmatch against mother for Rh compatibility';
        }
      } else if (_hemoType == 'abo') {
        if ((_momType == 'O' && (_neoType == 'A' || _neoType == 'B')) ||
            (_momType == 'A' && _neoType == 'B') ||
            (_momType == 'B' && _neoType == 'A')) {
          hlBlood   = 2;
          bloodRec  = 'Type O (Universal Donor) - Rh same as neonate';
          crossmatch = 'Must use Type O to avoid anti-A/anti-B in donor plasma';
        } else {
          hlBlood   = 1;
          bloodRec  = 'Type $_neoType, Rh ${_neoRh == 'pos' ? '+' : '-'} (Type-specific)';
          crossmatch = 'Type and screen (if no maternal antibodies)';
        }
      } else if (_hemoType == 'other') {
        hlBlood   = 5;
        bloodRec  = 'Antigen-negative for maternal antibody (consult blood bank)';
        crossmatch = 'Extended antigen typing required';
      } else {
        hlBlood   = 1;
        bloodRec  = 'Type $_neoType, Rh ${_neoRh == 'pos' ? '+' : '-'} (Type-specific, Rh-compatible)';
        crossmatch = 'Type and screen against neonate and mother';
      }
    }

    final unitsNeeded = hasBloodTypes
        ? (doubleVol * 1.2 / 250).ceil()
        : (doubleVol / 250).ceil();
    final unitsToOrder =
        '$unitsNeeded unit(s) (order ${(doubleVol * 1.2).round()} mL total)';

    final finalBloodRec =
        'FINAL BLOOD ORDER: $bloodRec | Volume: ${doubleVol.round()} mL (+20% extra)';

    // Indication
    String indicationText  = 'Enter TSB and risk level to determine indication for exchange';
    String indicationLevel = 'neutral';

    if (_tsb != null) {
      const thresholds = {'low': 22, 'medium': 20, 'high': 18};
      final threshold = thresholds[_riskLevel] ?? 22;
      if (_tsb! >= threshold) {
        indicationText  =
            '✓ EXCHANGE TRANSFUSION INDICATED — TSB ${_tsb!.toStringAsFixed(1)} mg/dL exceeds exchange threshold ($threshold mg/dL) for ${_riskLevel.toUpperCase()} risk neonate. Proceed with informed consent.';
        indicationLevel = 'green';
      } else {
        indicationText  =
            '⚠️ PHOTOTHERAPY FIRST — TSB ${_tsb!.toStringAsFixed(1)} mg/dL below exchange threshold ($threshold mg/dL). Start intensive phototherapy immediately. Recheck TSB in 2-4 hours. Exchange if rising rapidly or signs of ABE.';
        indicationLevel = 'amber';
      }
    }

    final newResult = _DvetResult(
      weightKg:        weightKg,
      bloodVolPerKg:   bvpkg,
      totalBloodVol:   totalBV,
      doubleVolume:    doubleVol,
      aliquotSize:     aliquot,
      numCycles:       numCycles,
      procedureMinutes: procMin,
      procHours:       procH,
      procMins:        procM,
      volumeCalcText:  volCalc,
      aliquotCalcText: aliquotCalc,
      withdrawVol:     withdrawVol,
      infuseVol:       infuseVol,
      highlightRow:    highlightRow,
      bloodRec:        bloodRec,
      crossmatch:      crossmatch,
      unitsToOrder:    unitsToOrder,
      highlightBloodRow: hlBlood,
      finalBloodRec:   finalBloodRec,
      indicationText:  indicationText,
      indicationLevel: indicationLevel,
      summaryVolume:   '${doubleVol.round()} mL',
      summaryAliquot:  '$aliquot mL',
      summaryCycles:   '$numCycles cycles',
    );

    final wasNull = _result == null;
    setState(() => _result = newResult);
    if (wasNull) _fadeCtrl.forward(from: 0);
  }

  // ── Build ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('DVET Calculator',
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
            _buildInputSection(),
            const SizedBox(height: 16),
            // Procedure summary always visible
            _buildProcedureSummary(),
            const SizedBox(height: 16),
            // Results (fade in when weight entered)
            if (_result != null)
              FadeTransition(
                opacity: _fadeAnim,
                child: _buildResults(_result!),
              ),
            const SizedBox(height: 16),
            _buildReferenceTable(),
            const SizedBox(height: 16),
            _buildReferences(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return _card(
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: _danger.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.favorite, color: _danger, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Neonatal DVET Calculator & Procedural Guide',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 4),
                Text('Complete Double Volume Exchange Transfusion Protocol with Step-by-Step Instructions',
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Warning banner ────────────────────────────────────────────────────────────
  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFfffbeb), Color(0xFFfef3c7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: _warning),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⚠️ CRITICAL PROCEDURE ALERT',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF92400e))),
          const SizedBox(height: 6),
          const Text(
            'This is a high-risk procedure requiring NICU expertise, informed consent, and immediate resuscitation capability. '
            'Procedure time: Minimum 2 hours (preferably 1.5-2 hours). Complete all calculations before starting.',
            style: TextStyle(fontSize: 12, color: Color(0xFF78350f), height: 1.5),
          ),
        ],
      ),
    );
  }

  // ── Input section ─────────────────────────────────────────────────────────────
  Widget _buildInputSection() {
    return LayoutBuilder(builder: (ctx, constraints) {
      final wide = constraints.maxWidth > 600;
      if (wide) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildPatientCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildBloodCard()),
          ],
        );
      }
      return Column(
        children: [
          _buildPatientCard(),
          const SizedBox(height: 12),
          _buildBloodCard(),
        ],
      );
    });
  }

  Widget _buildPatientCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('📊 Patient Parameters'),
          const SizedBox(height: 12),
          _inputField(
            label: 'Birth Weight (grams)',
            ctrl: _weightCtrl,
            hint: 'e.g., 2500',
            helperText: 'Required for all calculations',
            onChanged: (v) {
              _weight = double.tryParse(v);
              _calculate();
            },
          ),
          const SizedBox(height: 10),
          _inputField(
            label: 'Gestational Age (weeks)',
            ctrl: _gestCtrl,
            hint: 'e.g., 38',
            helperText: 'Determines blood volume (85 mL/kg term, 90-100 mL/kg preterm)',
            onChanged: (v) {
              _gestAge = int.tryParse(v);
              _calculate();
            },
          ),
          const SizedBox(height: 10),
          _inputField(
            label: 'Postnatal Age (hours)',
            ctrl: _postnatalCtrl,
            hint: 'e.g., 24',
            onChanged: (v) {
              _calculate();
            },
          ),
          const SizedBox(height: 10),
          Text('Clinical Risk Category',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 6),
          _riskRadio('low',    'Low Risk',    'Low Risk / ≥38wks + Well'),
          _riskRadio('medium', 'Medium Risk', 'Medium Risk / ≥38wks + RF or 35-37wks'),
          _riskRadio('high',   'High Risk',   'High Risk / <35wks or Sepsis/Acidosis'),
          const SizedBox(height: 10),
          _inputField(
            label: 'Total Serum Bilirubin (mg/dL)',
            ctrl: _tsbCtrl,
            hint: 'e.g., 20',
            onChanged: (v) {
              _tsb = double.tryParse(v);
              _calculate();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBloodCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('🩸 Blood Type & Hemolysis'),
          const SizedBox(height: 12),
          _dropdownField(
            label: 'Neonate Blood Group',
            value: _neoType.isEmpty ? null : _neoType,
            items: const ['A', 'B', 'AB', 'O'],
            onChanged: (v) { setState(() => _neoType = v ?? ''); _calculate(); },
          ),
          const SizedBox(height: 8),
          _rhRow('Neonate Rh Status', _neoRh, (v) { setState(() => _neoRh = v); _calculate(); }),
          const SizedBox(height: 10),
          _dropdownField(
            label: 'Mother Blood Group',
            value: _momType.isEmpty ? null : _momType,
            items: const ['A', 'B', 'AB', 'O'],
            onChanged: (v) { setState(() => _momType = v ?? ''); _calculate(); },
          ),
          const SizedBox(height: 8),
          _rhRow('Mother Rh Status', _momRh, (v) { setState(() => _momRh = v); _calculate(); }),
          const SizedBox(height: 10),
          Text('Hemolytic Disease Type',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 6),
          _hemoDropdown(),
        ],
      ),
    );
  }

  Widget _riskRadio(String value, String label, String desc) {
    final selected = _riskLevel == value;
    return GestureDetector(
      onTap: () { setState(() => _riskLevel = value); _calculate(); },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            Container(
              width: 18, height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: selected ? _primary : Theme.of(context).colorScheme.outline, width: 2),
                color: selected ? _primary : Colors.transparent,
              ),
              child: selected
                  ? const Center(child: CircleAvatar(radius: 4, backgroundColor: Colors.white))
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(desc, style: TextStyle(fontSize: 12, color: selected ? _primary : Theme.of(context).colorScheme.onSurface, fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rhRow(String label, String value, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 4),
        Row(
          children: [
            _rhChip('Rh+', 'pos', value, onChanged),
            const SizedBox(width: 8),
            _rhChip('Rh-', 'neg', value, onChanged),
          ],
        ),
      ],
    );
  }

  Widget _rhChip(String label, String val, String current, ValueChanged<String> onChanged) {
    final selected = current == val;
    return GestureDetector(
      onTap: () => onChanged(val),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? _primary : Theme.of(context).cardColor,
          border: Border.all(color: selected ? _primary : Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
      ),
    );
  }

  Widget _hemoDropdown() {
    const items = [
      MapEntry('none',  'No Hemolysis (Idiopathic/Other)'),
      MapEntry('abo',   'ABO Incompatibility'),
      MapEntry('rh',    'Rh (D) Hemolytic Disease'),
      MapEntry('other', 'Other Antibodies (Kell, Duffy, etc.)'),
    ];
    return _styledDropdown<String>(
      value: _hemoType,
      items: items.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value, style: const TextStyle(fontSize: 12.5)))).toList(),
      onChanged: (v) { setState(() => _hemoType = v ?? 'none'); _calculate(); },
    );
  }

  Widget _styledDropdown<T>({
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    Widget? hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<T>(
        value: value,
        hint: hint ?? Text('Select...', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12)),
        isExpanded: true,
        underline: const SizedBox.shrink(),
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  // ── Results ──────────────────────────────────────────────────────────────────
  Widget _buildResults(_DvetResult r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStep1(r),
        const SizedBox(height: 16),
        _buildStep2(r),
        const SizedBox(height: 16),
        _buildStep3(r),
        const SizedBox(height: 16),
        _buildStep4(),
        const SizedBox(height: 16),
        _buildStep5(),
      ],
    );
  }

  // ── Step 1 ────────────────────────────────────────────────────────────────────
  Widget _buildStep1(_DvetResult r) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepHeader('📐 STEP 1: VOLUME CALCULATIONS & ALIQUOT SIZES'),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (ctx, c) {
            final wide = c.maxWidth > 560;
            final leftCol = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [_primary, _primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text('${r.doubleVolume.round()} mL',
                          style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                      const Text('Total Exchange Volume (mL)',
                          style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf1f5f9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(r.volumeCalcText,
                      style: TextStyle(fontSize: 11.5, fontFamily: 'monospace', color: Theme.of(context).colorScheme.onSurface, height: 1.6)),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _success.withValues(alpha: .08),
                    border: Border.all(color: _success.withValues(alpha: .4)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Blood Volume Formula:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _success)),
                      const SizedBox(height: 4),
                      Text('• Term infants (≥37 wks): 85 mL/kg', style: TextStyle(fontSize: 11.5, color: Theme.of(context).colorScheme.onSurface)),
                      Text('• Preterm infants (<37 wks): 90-100 mL/kg', style: TextStyle(fontSize: 11.5, color: Theme.of(context).colorScheme.onSurface)),
                      Text('• Double Volume = 2 × Blood Volume', style: TextStyle(fontSize: 11.5, color: Theme.of(context).colorScheme.onSurface)),
                    ],
                  ),
                ),
              ],
            );
            final rightCol = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Aliquot Size per Cycle',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 8),
                _aliquotTable(r),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFf0fdf4), borderRadius: BorderRadius.circular(6)),
                  child: Text(r.aliquotCalcText,
                      style: const TextStyle(fontSize: 12, color: _success, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _danger.withValues(alpha: .08),
                    border: Border.all(color: _danger.withValues(alpha: .4)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '⚠️ CRITICAL: Total procedure time must be 1.5-2 hours. Do NOT exceed 2 hours due to risk of NEC, infection, and hemodynamic instability.',
                    style: TextStyle(fontSize: 11.5, color: _danger, height: 1.5),
                  ),
                ),
              ],
            );
            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: leftCol),
                  const SizedBox(width: 16),
                  Expanded(child: rightCol),
                ],
              );
            }
            return Column(children: [leftCol, const SizedBox(height: 16), rightCol]);
          }),
        ],
      ),
    );
  }

  Widget _aliquotTable(_DvetResult r) {
    return Table(
      border: TableBorder.all(color: Theme.of(context).colorScheme.outline, width: 1),
      columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(2), 2: FlexColumnWidth(2)},
      children: [
        TableRow(
          decoration: const BoxDecoration(color: _success),
          children: [
            _th('Neonate Weight'), _th('Aliquot Volume'), _th('Time per Cycle'),
          ],
        ),
        _aliquotRow('<1000 g', '5 mL', '5 minutes', r.highlightRow == 0, r.highlightRow == 0),
        _aliquotRow('1000-2000 g', '10 mL', '5 minutes', r.highlightRow == 1, r.highlightRow == 1),
        _aliquotRow('>2000 g', '15-20 mL', '5 minutes', r.highlightRow == 2, r.highlightRow == 2),
      ],
    );
  }

  TableRow _aliquotRow(String w, String a, String t, bool isHighlight, bool showYou) {
    final bg = isHighlight ? _highlight : Theme.of(context).cardColor;
    return TableRow(
      decoration: BoxDecoration(color: bg),
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Text(w, style: TextStyle(fontSize: 11.5, fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal, color: Theme.of(context).colorScheme.onSurface)),
              if (showYou) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(10)),
                  child: const Text('YOU', style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ],
          ),
        ),
        _td(a, isHighlight),
        _td(t, isHighlight),
      ],
    );
  }

  // ── Step 2 ────────────────────────────────────────────────────────────────────
  Widget _buildStep2(_DvetResult r) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepHeader('🩸 STEP 2: BLOOD PRODUCT SELECTION GUIDE'),
          const SizedBox(height: 12),
          _indicationAlert(r),
          const SizedBox(height: 14),
          Text('Blood Type Selection Based on Hemolysis',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 8),
          _bloodSelectionTable(r),
          const SizedBox(height: 12),
          _infoBox('Your Selection:', r.bloodRec, _primary),
          const SizedBox(height: 8),
          _infoBox('Crossmatch Requirements:', r.crossmatch, _info),
          const SizedBox(height: 8),
          _infoBox('Total Units to Order:', r.unitsToOrder, _success),
          const SizedBox(height: 14),
          Text('Mandatory Blood Specifications',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 8),
          _mandatorySpecs(),
        ],
      ),
    );
  }

  Widget _indicationAlert(_DvetResult r) {
    Color bg, border, textColor;
    switch (r.indicationLevel) {
      case 'green':
        bg = _success.withValues(alpha: .08); border = _success; textColor = _success;
        break;
      case 'amber':
        bg = _warning.withValues(alpha: .1); border = _warning; textColor = const Color(0xFF92400e);
        break;
      default:
        bg = const Color(0xFFf1f5f9); border = Theme.of(context).colorScheme.outline; textColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: bg, border: Border.all(color: border), borderRadius: BorderRadius.circular(8)),
      child: Text(r.indicationText,
          style: TextStyle(fontSize: 12.5, color: textColor, height: 1.5, fontWeight: FontWeight.w600)),
    );
  }

  Widget _bloodSelectionTable(_DvetResult r) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(color: Theme.of(context).colorScheme.outline),
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: [
          TableRow(
            decoration: BoxDecoration(color: _primary.withValues(alpha: .9)),
            children: [
              _th('Clinical Scenario', minW: 140),
              _th('Neonate Type', minW: 90),
              _th('Mother Type', minW: 90),
              _th('Blood to Use', minW: 140),
              _th('Special Requirements', minW: 160),
            ],
          ),
          _bloodRow(1, 'No Hemolysis', 'Any', 'Any (compatible)', 'Type-specific, Rh-compatible', Colors.green, 'Standard specifications', r.highlightBloodRow == 1),
          _bloodRow(2, 'ABO Incompatibility (e.g., Mom O, Baby A/B)', 'A or B', 'O', 'Type O (Universal Donor)', Colors.green, 'Must be Type O to avoid anti-A/anti-B antibodies in donor plasma', r.highlightBloodRow == 2),
          _bloodRow(3, 'Rh Hemolytic Disease (Mom Rh-, Baby Rh+)', 'Rh+', 'Rh-', 'Rh-negative (Type O or type-specific)', Colors.green, 'MANDATORY: Rh-negative regardless of ABO type', r.highlightBloodRow == 3),
          _bloodRow(4, 'Combined ABO + Rh', 'A/B Rh+', 'O Rh-', 'O Negative ONLY', Colors.red, 'Both conditions apply - most restrictive', r.highlightBloodRow == 4),
          _bloodRow(5, 'Other Antibodies (Kell, Duffy, Kidd, etc.)', 'Any', 'Any with antibodies', 'Antigen-negative for maternal antibody', Colors.orange, 'Consult blood bank for antigen typing', r.highlightBloodRow == 5),
        ],
      ),
    );
  }

  TableRow _bloodRow(int idx, String scenario, String neoT, String momT, String blood, Color bloodColor, String special, bool highlight) {
    final bg = highlight ? _highlight : Theme.of(context).cardColor;
    final fw = highlight ? FontWeight.bold : FontWeight.normal;
    return TableRow(
      decoration: BoxDecoration(color: bg),
      children: [
        _tdPad(scenario, fw),
        _tdPad(neoT, fw),
        _tdPad(momT, fw),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(blood, style: TextStyle(fontSize: 11.5, color: bloodColor, fontWeight: FontWeight.w600)),
        ),
        _tdPad(special, fw),
      ],
    );
  }

  Widget _mandatorySpecs() {
    const items = [
      'CMV Status: CMV-seronegative OR leukoreduced (leukodepleted)',
      'Irradiation: MUST be irradiated (prevents Transfusion-Associated GVHD)',
      'Freshness: ≤5 days old preferred (max 7 days) to preserve 2,3-DPG and reduce potassium',
      'Hematocrit: 50-60% (reconstitute PRBCs with FFP if needed - typically 60:40 ratio)',
      'Hemoglobin S: HbS-negative (sickle screen negative)',
      'Kell Status: Kell-negative for females of child-bearing potential',
      'Volume: Order 20% extra beyond calculated need',
    ];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFf8fafc),
      ),
      child: Column(
        children: items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('☐ ', style: TextStyle(fontSize: 13, color: _primary)),
              Expanded(child: Text(item, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface, height: 1.4))),
            ],
          ),
        )).toList(),
      ),
    );
  }

  // ── Step 3 ────────────────────────────────────────────────────────────────────
  Widget _buildStep3(_DvetResult r) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepHeader('🏥 STEP 3: EXCHANGE TRANSFUSION PROCEDURE'),
          const SizedBox(height: 16),
          _timeline([
            _timelineItem('PRE-PROCEDURE (30-60 min before)', _buildPreProcedure()),
            _timelineItem('ACCESS & SETUP (15-30 min)', _buildAccessSetup()),
            _timelineItem('DURING PROCEDURE (90-120 min)', _buildDuringProcedure(r)),
            _timelineItem('MONITORING & INTERVENTIONS', _buildMonitoring()),
            _timelineItem('POST-PROCEDURE (0-6 hours)', _buildPostProcedure()),
          ]),
        ],
      ),
    );
  }

  Widget _buildPreProcedure() {
    return _stepBox('Step 1', 'Verify & Prepare', [
      '• Confirm informed consent obtained',
      '• Verify blood product: Type, Rh, CMV status, irradiation date, freshness (<5 days)',
      '• Warm blood to 37°C using blood warmer (CRITICAL - prevent hypothermia)',
      '• Check hematocrit of donor blood (target 50-60%)',
      '• Prime blood administration set with filter',
    ]);
  }

  Widget _buildAccessSetup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepBox('Step 2', 'Vascular Access (Two Methods)', const []),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: _success),
            borderRadius: BorderRadius.circular(8),
            color: _success.withValues(alpha: .04),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('METHOD A: Isovolumetric (PREFERRED)',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: _success)),
              Text('Requires 2 access points - minimizes hemodynamic fluctuation',
                  style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
              const SizedBox(height: 6),
              Text('• Arterial: UAC (umbilical arterial catheter) OR peripheral arterial line',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
              Text('• Venous: UVC (umbilical venous catheter) with tip at IVC/RA junction',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
              Text('• Technique: Simultaneous withdrawal and infusion',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
              Text('• Rate: Continuous or 5 mL/kg aliquots every 5 minutes',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: _warning),
            borderRadius: BorderRadius.circular(8),
            color: _warning.withValues(alpha: .04),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('METHOD B: Push-Pull (Single Access)',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF92400e))),
              Text('When only UVC available - higher risk of volume fluctuation',
                  style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
              const SizedBox(height: 6),
              Text('• Access: Double-lumen UVC OR single lumen with 4-way stopcock',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
              Text('• Technique: Withdraw aliquot over 2-3 min → Discard → Infuse over 2-3 min',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
              Text('• Cycle: 4-5 minutes per aliquot',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
              const Text('• WARNING: Higher risk of air embolism - ensure experienced operator',
                  style: TextStyle(fontSize: 12, color: _danger, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDuringProcedure(_DvetResult r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepBox('Step 3', 'Exchange Execution', const []),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: Theme.of(context).colorScheme.outline),
          children: [
            TableRow(
              decoration: const BoxDecoration(color: _success),
              children: [
                _th('Action'), _th('Volume'), _th('Duration'), _th('Documentation'),
              ],
            ),
            TableRow(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              children: [
                _tdPad('Withdraw (Arterial)', FontWeight.normal),
                _tdPad(r.withdrawVol, FontWeight.bold),
                _tdPad('2-3 minutes', FontWeight.normal),
                _tdPad('Record on EBT chart', FontWeight.normal),
              ],
            ),
            TableRow(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              children: [
                _tdPad('Infuse (Venous)', FontWeight.normal),
                _tdPad(r.infuseVol, FontWeight.bold),
                _tdPad('2-3 minutes', FontWeight.normal),
                _tdPad('Same volume as withdrawn', FontWeight.normal),
              ],
            ),
            TableRow(
              decoration: const BoxDecoration(color: _highlight),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Cycle repeats every 5 minutes until total volume exchanged',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
                const SizedBox.shrink(),
                const SizedBox.shrink(),
                const SizedBox.shrink(),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: _danger.withValues(alpha: .08),
              border: Border.all(color: _danger.withValues(alpha: .4)),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Team Roles:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: _danger)),
              const SizedBox(height: 4),
              Text('• Person A (Doctor/ANNP): Withdraws aliquots, team leader', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
              Text('• Person B (Nurse 1): Infuses blood, monitors baby', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
              Text('• Person C (Nurse 2): Documents volumes, vital signs, alerts for every aliquot', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonitoring() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepBox('Step 4', 'Critical Monitoring & Interventions', const []),
        const SizedBox(height: 8),
        LayoutBuilder(builder: (ctx, c) {
          final wide = c.maxWidth > 400;
          final left = Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: _danger.withValues(alpha: .06),
                border: Border.all(color: _danger.withValues(alpha: .3)),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('⚠️ Vital Monitoring', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: _danger)),
                const SizedBox(height: 6),
                Text('• Continuous cardiorespiratory monitoring', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
                Text('• Blood pressure every 15 minutes', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
                Text('• Oxygen saturation (pre/post ductal if possible)', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
                Text('• Temperature every 30 minutes', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
              ],
            ),
          );
          final right = Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: _warning.withValues(alpha: .06),
                border: Border.all(color: _warning.withValues(alpha: .4)),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🧪 Lab Monitoring', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF92400e))),
                const SizedBox(height: 6),
                Text('• Glucose: Every 30 minutes (rebound hypoglycemia risk)', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
                Text('• Calcium: After every 100 mL exchanged (citrate toxicity)', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
                Text('• Potassium: Halfway and end (hyperkalemia from old blood)', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
                Text('• Bilirubin: Halfway and 4 hours post-procedure', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
              ],
            ),
          );
          if (wide) {
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: left), const SizedBox(width: 10), Expanded(child: right),
            ]);
          }
          return Column(children: [left, const SizedBox(height: 10), right]);
        }),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: _success.withValues(alpha: .06),
              border: Border.all(color: _success.withValues(alpha: .4)),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Calcium Gluconate Protocol:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: _success)),
              const SizedBox(height: 4),
              Text('Give 30 mg/kg Calcium Gluconate IV after every 100 mL of blood exchanged.', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
              Text('Also give if: Unexplained tachycardia, arrhythmias, hypotension, or prolonged QT on ECG.', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostProcedure() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepBox('Step 5', 'Post-Exchange Care', [
          '• Immediate: Check glucose at 15, 30, 60 minutes (rebound hypoglycemia)',
          '• 1 hour: CBC, electrolytes, ionized calcium, bilirubin',
          '• 4 hours: Repeat bilirubin, CBC (assess hemoglobin, platelets)',
          '• 6 hours: Final vitals, consider removing lines if stable',
          '• Feeds: NPO for 4-6 hours (NEC risk), then restart cautiously',
          '• Phototherapy: Continue until bilirubin stable or falling',
        ]),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: _danger.withValues(alpha: .08),
              border: Border.all(color: _danger.withValues(alpha: .4)),
              borderRadius: BorderRadius.circular(8)),
          child: const Text(
            'Watch for: Abdominal distension (NEC), thrombocytopenia, hypocalcemia, arrhythmias, temperature instability.',
            style: TextStyle(fontSize: 12, color: _danger, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  // ── Step 4 ────────────────────────────────────────────────────────────────────
  Widget _buildStep4() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepHeader('🧪 STEP 4: LABORATORY MONITORING SCHEDULE'),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(color: Theme.of(context).colorScheme.outline),
              defaultColumnWidth: const IntrinsicColumnWidth(),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: _primary.withValues(alpha: .9)),
                  children: [_th('Timing', minW: 110), _th('Required Tests', minW: 200), _th('Purpose', minW: 160)],
                ),
                _labRow('Pre-Exchange',
                    'CBC, ABG/VBG, Total/Direct Bilirubin, Electrolytes (K, Ca, iCa), Glucose, Blood Culture (if indicated), Type & Screen, DAT',
                    'Baseline assessment, confirm indication'),
                _labRow('Halfway (50%)', 'Blood Gas, Bilirubin, iCa, Glucose', 'Monitor for acidosis, hypocalcemia'),
                _labRow('Completion', 'CBC, Electrolytes, iCa, Glucose, ABG, Total/Direct Bilirubin', 'Assess final status, complications'),
                _labRow('4-6 Hours Post', 'CBC (Hct, Plts), Bilirubin, Electrolytes', 'Detect delayed hemolysis, thrombocytopenia'),
                _labRow('24 Hours Post', 'CBC, Bilirubin (if hemolytic disease)', 'Assess rebound, need for repeat ET'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow _labRow(String timing, String tests, String purpose) {
    return TableRow(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      children: [
        _tdPad(timing, FontWeight.w600),
        _tdPad(tests, FontWeight.normal),
        _tdPad(purpose, FontWeight.normal),
      ],
    );
  }

  // ── Step 5 ────────────────────────────────────────────────────────────────────
  Widget _buildStep5() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: _danger, borderRadius: BorderRadius.circular(6)),
            child: const Text('⚠️ STEP 5: COMPLICATIONS & MANAGEMENT',
                style: TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (ctx, c) {
            final wide = c.maxWidth > 560;
            final immediate = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Immediate Complications',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _danger)),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Table(
                    border: TableBorder.all(color: Theme.of(context).colorScheme.outline),
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(color: _danger),
                        children: [_th('Complication', minW: 120), _th('Recognition', minW: 140), _th('Action', minW: 140)],
                      ),
                      _compRow('Hypocalcemia', 'QT prolongation, jitteriness, arrhythmia', 'Calcium Gluconate 30 mg/kg IV'),
                      _compRow('Hypoglycemia', 'Glucose <40 mg/dL, lethargy, seizures', 'D10 bolus, increase GIR'),
                      _compRow('Hyperkalemia', 'Peaked T waves, arrhythmia', 'Calcium, Glucose/Insulin, stop if severe'),
                      _compRow('Volume Overload', 'Hypertension, tachypnea, hepatomegaly', 'Slow exchange rate, diuretics'),
                      _compRow('Air Embolism', 'Sudden cyanosis, cardiovascular collapse', 'Stop procedure, left lateral position, 100% O2'),
                    ],
                  ),
                ),
              ],
            );
            final delayed = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Delayed Complications',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _warning)),
                const SizedBox(height: 8),
                _delayedComp('NEC (Necrotizing Enterocolitis)',
                    'Most common serious complication. Risk increased by gut ischemia. NPO 4-6 hours post-procedure.'),
                _delayedComp('Thrombocytopenia',
                    'Dilutional + consumption. Check Plts at 4-6 hours. Transfuse if <20,000 or bleeding.'),
                _delayedComp('Infection',
                    'Bacterial contamination (rare with fresh blood). Monitor for sepsis.'),
                _delayedComp('Portal Vein Thrombosis',
                    'If UVC tip in portal circulation. Ensure UVC tip at IVC/RA junction.'),
                _delayedComp('Transfusion Reaction',
                    'Fever, hypotension, hemoglobinuria. Stop transfusion immediately.'),
              ],
            );
            if (wide) {
              return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: immediate), const SizedBox(width: 16), Expanded(child: delayed),
              ]);
            }
            return Column(children: [immediate, const SizedBox(height: 16), delayed]);
          }),
        ],
      ),
    );
  }

  TableRow _compRow(String comp, String recog, String action) {
    return TableRow(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      children: [
        _tdPad(comp, FontWeight.w600),
        _tdPad(recog, FontWeight.normal),
        _tdPad(action, FontWeight.normal),
      ],
    );
  }

  Widget _delayedComp(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: _warning.withValues(alpha: .06),
            border: Border.all(color: _warning.withValues(alpha: .3)),
            borderRadius: BorderRadius.circular(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF78350f))),
            const SizedBox(height: 2),
            Text(desc, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface, height: 1.4)),
          ],
        ),
      ),
    );
  }

  // ── Procedure summary ─────────────────────────────────────────────────────────
  Widget _buildProcedureSummary() {
    final r = _result;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [_primary.withValues(alpha: .85), _primaryDark],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📋 PROCEDURE SUMMARY',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          LayoutBuilder(builder: (ctx, c) {
            final wide = c.maxWidth > 500;
            final boxes = [
              _summaryBox('Total Volume to Exchange:', r?.summaryVolume ?? '—'),
              _summaryBox('Aliquot Size:', r?.summaryAliquot ?? '—'),
              _summaryBox('Number of Cycles:', r?.summaryCycles ?? '—'),
              _summaryBox('Procedure Duration:', '90-120 minutes'),
            ];
            if (wide) {
              return Row(children: boxes.map((b) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 8), child: b))).toList());
            }
            return Column(children: [
              Row(children: [Expanded(child: boxes[0]), const SizedBox(width: 8), Expanded(child: boxes[1])]),
              const SizedBox(height: 8),
              Row(children: [Expanded(child: boxes[2]), const SizedBox(width: 8), Expanded(child: boxes[3])]),
            ]);
          }),
          if (r != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: const Border(left: BorderSide(color: _success, width: 4)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(r.finalBloodRec,
                  style: TextStyle(fontSize: 12.5, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, height: 1.4)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _summaryBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10.5)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ── Reference table ───────────────────────────────────────────────────────────
  Widget _buildReferenceTable() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('📚 Reference: Exchange Thresholds (AAP 2022)'),
          const SizedBox(height: 10),
          Table(
            border: TableBorder.all(color: Theme.of(context).colorScheme.outline),
            columnWidths: const {0: FlexColumnWidth(1.2), 1: FlexColumnWidth(1.8), 2: FlexColumnWidth(1.8)},
            children: [
              TableRow(
                decoration: BoxDecoration(color: _primary.withValues(alpha: .1)),
                children: [
                  _thDark('Risk Category'), _thDark('Definition'), _thDark('Exchange Threshold (approximate)'),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                children: [
                  Padding(padding: const EdgeInsets.all(8), child: _badge('Low', _success)),
                  _tdPad('≥38 weeks + Well', FontWeight.normal),
                  _tdPad('TSB ≥ 20-25 mg/dL (or 340-425 μmol/L)', FontWeight.normal),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                children: [
                  Padding(padding: const EdgeInsets.all(8), child: _badge('Medium', _warning)),
                  _tdPad('≥38 weeks + Risk factors OR 35-37 weeks + Well', FontWeight.normal),
                  _tdPad('TSB ≥ 18-22 mg/dL (or 305-375 μmol/L)', FontWeight.normal),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                children: [
                  Padding(padding: const EdgeInsets.all(8), child: _badge('High', _danger)),
                  _tdPad('35-37 weeks + Risk factors OR <35 weeks', FontWeight.normal),
                  _tdPad('TSB ≥ 16-20 mg/dL (or 275-340 μmol/L)', FontWeight.normal),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xFFf0f9ff),
                border: Border.all(color: const Color(0xFFbae6fd)),
                borderRadius: BorderRadius.circular(6)),
            child: Text(
              'Note: Lower thresholds apply for hemolytic disease, signs of acute bilirubin encephalopathy (ABE), or sepsis. '
              'Risk factors include: isoimmune hemolytic disease, G6PD deficiency, asphyxia, significant lethargy, '
              'temperature instability, sepsis, acidosis, or albumin <3.0 g/dL.',
              style: TextStyle(fontSize: 11.5, color: Theme.of(context).colorScheme.onSurface, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // ── References ────────────────────────────────────────────────────────────────
  Widget _buildReferences() {
    const refs = [
      'AAP Clinical Practice Guideline: Management of Hyperbilirubinemia in the Newborn Infant 35 or More Weeks of Gestation (Pediatrics 2022)',
      'British Society for Haematology Guidelines: Transfusion for Fetuses, Neonates and Older Children (2023)',
      'UCSF Medical Center: Neonatal Exchange Transfusion Standardized Procedure',
      'Royal Children\'s Hospital Melbourne: Blood Products for Neonatal Transfusion',
      'NHS Ashford and St. Peter\'s Hospitals: Double Volume Exchange Transfusion Protocol (2022)',
      'StatPearls: Exchange Transfusion (2025)',
    ];
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('📖 References'),
          const SizedBox(height: 8),
          ...refs.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: _primary, fontSize: 13)),
                Expanded(child: Text(r, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface, height: 1.5))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // ── Timeline ──────────────────────────────────────────────────────────────────
  Widget _timeline(List<Widget> items) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left line + dots
        Column(
          children: items.asMap().entries.map((e) {
            final isLast = e.key == items.length - 1;
            return Column(
              children: [
                Container(
                  width: 12, height: 12,
                  decoration: const BoxDecoration(color: _primary, shape: BoxShape.circle),
                ),
                if (!isLast)
                  Container(width: 2, height: 100, color: _primary.withValues(alpha: .3)),
              ],
            );
          }).toList(),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _timelineItem(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _primary)),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _stepBox(String stepLabel, String stepTitle, List<String> bullets) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: _primary.withValues(alpha: .05),
          border: Border.all(color: _primary.withValues(alpha: .25)),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(4)),
                child: Text(stepLabel, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(stepTitle, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface))),
            ],
          ),
          if (bullets.isNotEmpty) ...[
            const SizedBox(height: 6),
            ...bullets.map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(b, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface, height: 1.4)),
            )),
          ],
        ],
      ),
    );
  }

  // ── Shared helpers ────────────────────────────────────────────────────────────
  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .04), blurRadius: 4, offset: const Offset(0, 2))]),
      child: child,
    );
  }

  Widget _sectionTitle(String t) {
    return Text(t, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface));
  }

  Widget _stepHeader(String t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [_primary, _primaryDark]),
          borderRadius: BorderRadius.circular(6)),
      child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.bold)),
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController ctrl,
    required String hint,
    String? helperText,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
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
            helperText: helperText,
            helperStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 11),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Theme.of(context).colorScheme.outline)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Theme.of(context).colorScheme.outline)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _primary, width: 2)),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _dropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 4),
        _styledDropdown<String>(
          value: value,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12.5)))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _infoBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: color.withValues(alpha: .06),
          border: Border.all(color: color.withValues(alpha: .3)),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface))),
        ],
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withValues(alpha: .15),
          border: Border.all(color: color.withValues(alpha: .5)),
          borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(fontSize: 11.5, color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _th(String t, {double minW = 80}) {
    return Container(
      constraints: BoxConstraints(minWidth: minW),
      padding: const EdgeInsets.all(8),
      child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold)),
    );
  }

  Widget _thDark(String t) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(t, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 11.5, fontWeight: FontWeight.bold)),
    );
  }

  Widget _td(String t, bool bold) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(t, style: TextStyle(fontSize: 11.5, color: Theme.of(context).colorScheme.onSurface, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
    );
  }

  Widget _tdPad(String t, FontWeight fw) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(t, style: TextStyle(fontSize: 11.5, color: Theme.of(context).colorScheme.onSurface, fontWeight: fw, height: 1.4)),
    );
  }
}
