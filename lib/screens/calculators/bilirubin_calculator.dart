import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ══════════════════════════════════════════════════════════════════════════════
// AAP 2022 Neonatal Bilirubin / Jaundice Calculator  ≥35 weeks
// Kemper AR et al. Pediatrics. 2022;150(3):e2022058859
// ══════════════════════════════════════════════════════════════════════════════

class BilirubinCalculator extends StatefulWidget {
  const BilirubinCalculator({super.key});
  @override
  State<BilirubinCalculator> createState() => _BilirubinCalculatorState();
}

class _BilirubinCalculatorState extends State<BilirubinCalculator> {
  // ── Data ──────────────────────────────────────────────────────────────────
  Map<String, dynamic>? _data;
  bool _dataLoaded = false;

  // ── Inputs ────────────────────────────────────────────────────────────────
  int _ga = 38;
  bool _ageInHours = true;
  int _ageHours = 24;
  int _ageDays = 1;
  int _ageExtraHours = 0;
  double _tsb = 8.0;
  bool _showAlbumin = false;
  double _albumin = 3.0;

  // ── Risk factors ──────────────────────────────────────────────────────────
  bool _rfAlbumin = false;
  bool _rfIsoimmune = false;
  bool _rfG6PD = false;
  bool _rfSepsis = false;
  bool _rfInstability = false;

  // ── TSB stepper inline edit controller ────────────────────────────────────
  final _tsbInputCtrl = TextEditingController(text: '8.0');

  bool get _hasRisk =>
      _rfAlbumin || _rfIsoimmune || _rfG6PD || _rfSepsis || _rfInstability;

  // ── Results ───────────────────────────────────────────────────────────────
  bool _calculated = false;
  double? _photoThreshold;
  double? _exchangeThreshold;
  double? _escalationThreshold;
  String _classification = '';
  String _gaKeyUsed = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _tsbInputCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final raw = await rootBundle
        .loadString('assets/data/bilirubin/bilirubin_data.json');
    setState(() {
      _data = jsonDecode(raw) as Map<String, dynamic>;
      _dataLoaded = true;
    });
  }

  // ── Threshold lookup ──────────────────────────────────────────────────────
  double? _getThreshold(
      Map<String, dynamic> table, String gaKey, int ageHours) {
    final gaData = table[gaKey] as Map<String, dynamic>?;
    if (gaData == null) return null;

    final int day = ageHours ~/ 24;
    final int hour = ageHours % 24;

    if (gaData.containsKey(day.toString())) {
      final row = gaData[day.toString()] as List<dynamic>;
      if (hour < row.length && row[hour] != null) {
        return (row[hour] as num).toDouble();
      }
    }

    // Plateau at last day's last non-null value
    final int maxDay =
        gaData.keys.map((k) => int.parse(k)).reduce(max);
    if (day > maxDay) {
      final lastRow = gaData[maxDay.toString()] as List<dynamic>;
      final lastVal =
          lastRow.lastWhere((v) => v != null, orElse: () => null);
      return lastVal != null ? (lastVal as num).toDouble() : null;
    }
    return null;
  }

  String _gaKeyNoRisk() {
    if (_ga >= 40) return '40';
    return _ga.toString();
  }

  String _gaKeyRisk() {
    if (_ga >= 38) return '38plus';
    return _ga.toString();
  }

  int get _totalHours =>
      _ageInHours ? _ageHours : (_ageDays * 24 + _ageExtraHours);

  void _calculate() {
    if (_data == null) return;

    final photoTable = _hasRisk
        ? _data!['phototherapy_with_risk'] as Map<String, dynamic>
        : _data!['phototherapy_no_risk'] as Map<String, dynamic>;
    final exchangeTable = _hasRisk
        ? _data!['exchange_with_risk'] as Map<String, dynamic>
        : _data!['exchange_no_risk'] as Map<String, dynamic>;

    final photoKey = _hasRisk ? _gaKeyRisk() : _gaKeyNoRisk();
    final exchKey = _gaKeyRisk();

    final photo = _getThreshold(photoTable, photoKey, _totalHours);
    final exch = _getThreshold(exchangeTable, exchKey, _totalHours);

    setState(() {
      _photoThreshold = photo;
      _exchangeThreshold = exch;
      _escalationThreshold = exch != null ? exch - 2.0 : null;
      _gaKeyUsed = photoKey;
      _calculated = true;
      _classification = _classify();
    });
  }

  String _classify() {
    if (_exchangeThreshold != null && _tsb >= _exchangeThreshold!) {
      return 'exchange';
    } else if (_escalationThreshold != null &&
        _tsb >= _escalationThreshold!) {
      return 'escalation';
    } else if (_photoThreshold != null && _tsb >= _photoThreshold!) {
      return 'phototherapy';
    }
    return 'below';
  }

  // ── Colors / labels — SEMANTIC medical colors, kept as-is ─────────────────
  Color get _statusColor {
    switch (_classification) {
      case 'exchange':
        return const Color(0xFFE53935);
      case 'escalation':
        return const Color(0xFFf97316);
      case 'phototherapy':
        return const Color(0xFFF5A623);
      default:
        return const Color(0xFF2DBD8C);
    }
  }

  Color get _statusBg {
    switch (_classification) {
      case 'exchange':
        return const Color(0xFFFFEBEE);
      case 'escalation':
        return const Color(0xFFFFF3E0);
      case 'phototherapy':
        return const Color(0xFFFFF8E1);
      default:
        return const Color(0xFFE8F5E9);
    }
  }

  String get _statusEmoji {
    switch (_classification) {
      case 'exchange':
        return '🔴';
      case 'escalation':
        return '🟠';
      case 'phototherapy':
        return '🟡';
      default:
        return '🟢';
    }
  }

  String get _classificationTitle {
    switch (_classification) {
      case 'exchange':
        return 'Exchange Transfusion Threshold Reached';
      case 'escalation':
        return 'Escalation of Care Required';
      case 'phototherapy':
        return 'Phototherapy Recommended';
      default:
        return 'Below Phototherapy Threshold';
    }
  }

  String get _actionText {
    switch (_classification) {
      case 'exchange':
        return 'URGENT: Exchange transfusion indicated. Transfer to NICU immediately. Contact neonatologist STAT.';
      case 'escalation':
        return 'ESCALATE: 2 mg/dL below exchange threshold. Intensive phototherapy + IV hydration. STAT labs. Consult neonatologist for NICU transfer.';
      case 'phototherapy':
        return 'Start intensive phototherapy. Verify irradiance ≥30 mW/cm²/nm. Check TSB within 12 hours.';
      default:
        return 'Below phototherapy threshold. Continue monitoring. Follow-up per discharge plan (Fig 7, AAP 2022).';
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary)),
      );

  Widget _tagChip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
      );

  // ── BUILD ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: cs.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bilirubin Assessment',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimary)),
            Text('AAP 2022 · ≥35 weeks gestation',
                style: TextStyle(fontSize: 11, color: cs.onPrimary.withValues(alpha: 0.7))),
          ],
        ),
      ),
      body: !_dataLoaded
          ? Center(
              child:
                  CircularProgressIndicator(color: cs.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header badge
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5A623).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                        border:
                            Border.all(color: const Color(0xFFF5A623).withValues(alpha: 0.5)),
                      ),
                      child: const Text('AAP 2022 GUIDELINE',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.15,
                              color: Color(0xFFF5A623))),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Text('Neonatal Jaundice',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface)),
                  Text(
                      '≥35 weeks gestation · TSB threshold calculator',
                      style: TextStyle(
                          fontSize: 13, color: cs.onSurface.withValues(alpha: 0.6))),
                  const SizedBox(height: 16),
                  _buildInputCard(),
                  const SizedBox(height: 12),
                  _buildRiskFactorsCard(),
                  const SizedBox(height: 12),
                  _buildAlbuminCard(),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        foregroundColor: cs.onPrimary,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _calculate,
                      child: const Text('Assess Bilirubin',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  if (_calculated) ...[
                    const SizedBox(height: 20),
                    _buildStatusHero(),
                    const SizedBox(height: 12),
                    _buildThresholdCard(),
                    if (_showAlbumin) ...[
                      const SizedBox(height: 12),
                      _buildBACard(),
                    ],
                    if (_hasRisk) ...[
                      const SizedBox(height: 12),
                      _buildRiskSummaryCard(),
                    ],
                    const SizedBox(height: 12),
                    _buildClinicalActionsCard(),
                    if (_rfIsoimmune &&
                        (_classification == 'escalation' ||
                            _classification == 'exchange')) ...[
                      const SizedBox(height: 12),
                      _buildIVIGCard(),
                    ],
                    const SizedBox(height: 12),
                    _buildReferenceCard(),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  // ── Input card ─────────────────────────────────────────────────────────────
  Widget _buildInputCard() {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient Data',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: cs.primary)),
            const SizedBox(height: 16),

            // GA chips
            _sectionLabel('Gestational Age (weeks)'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [35, 36, 37, 38, 39, 40].map((ga) {
                final label = ga == 40 ? '≥40' : '$ga';
                final selected =
                    ga == 40 ? _ga >= 40 : _ga == ga;
                return GestureDetector(
                  onTap: () => setState(() => _ga = ga),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? cs.primary
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? cs.primary
                            : cs.primary.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(label,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? cs.onPrimary
                                : cs.primary)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Age toggle
            _sectionLabel('Age at Time of Measurement'),
            Container(
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(3),
              child: Row(children: [
                Expanded(child: _ageTabBtn('Hours', true)),
                Expanded(child: _ageTabBtn('Days + Hours', false)),
              ]),
            ),
            const SizedBox(height: 12),

            if (_ageInHours) ...[
              _IntStepperField(
                label: 'Age (hours)',
                value: _ageHours,
                min: 0,
                max: 336,
                hint: '0–336 hrs',
                onChanged: (v) => setState(() => _ageHours = v),
              ),
            ] else ...[
              Row(children: [
                Expanded(
                  child: _IntStepperField(
                    label: 'Days',
                    value: _ageDays,
                    min: 0,
                    max: 14,
                    hint: '0–14',
                    onChanged: (v) =>
                        setState(() => _ageDays = v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _IntStepperField(
                    label: 'Hours',
                    value: _ageExtraHours,
                    min: 0,
                    max: 23,
                    hint: '0–23',
                    onChanged: (v) =>
                        setState(() => _ageExtraHours = v),
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              Text(
                '= $_totalHours total hours  (${_totalHours ~/ 24}d ${_totalHours % 24}h)',
                style: TextStyle(
                    fontSize: 11,
                    color: cs.primary,
                    fontWeight: FontWeight.w600),
              ),
            ],
            const SizedBox(height: 20),

            // TSB
            _sectionLabel('Total Serum Bilirubin — TSB (mg/dL)'),
            _tsbStepper(),
            const SizedBox(height: 4),
            Text(
                'Use TSB — do NOT subtract direct/conjugated bilirubin',
                style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurface.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  Widget _ageTabBtn(String label, bool isHours) {
    final cs = Theme.of(context).colorScheme;
    final active = _ageInHours == isHours;
    return GestureDetector(
      onTap: () => setState(() => _ageInHours = isHours),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: active ? cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: active
                    ? cs.onPrimary
                    : cs.onSurface.withValues(alpha: 0.6))),
      ),
    );
  }

  Widget _tsbStepper() {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: cs.outline),
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor,
      ),
      child: Row(children: [
        IconButton(
          icon: const Icon(Icons.remove, size: 18),
          color: _tsb > 0
              ? cs.primary
              : cs.onSurface.withValues(alpha: 0.3),
          onPressed: _tsb > 0
              ? () {
                  final v = double.parse((_tsb - 0.1).toStringAsFixed(1));
                  setState(() => _tsb = v);
                  _tsbInputCtrl.text = v.toStringAsFixed(1);
                }
              : null,
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
        ),
        Expanded(
          child: Column(children: [
            SizedBox(
              height: 44,
              child: Center(
                child: TextField(
                  controller: _tsbInputCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold, color: cs.primary),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null && parsed >= 0 && parsed <= 35) {
                      setState(() => _tsb = double.parse(parsed.toStringAsFixed(1)));
                    }
                  },
                  onSubmitted: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null) {
                      final clamped = parsed.clamp(0.0, 35.0);
                      setState(() => _tsb = double.parse(clamped.toStringAsFixed(1)));
                      _tsbInputCtrl.text = _tsb.toStringAsFixed(1);
                    } else {
                      _tsbInputCtrl.text = _tsb.toStringAsFixed(1);
                    }
                  },
                ),
              ),
            ),
            Text('mg/dL',
                style: TextStyle(
                    fontSize: 10, color: cs.onSurface.withValues(alpha: 0.5)),
                textAlign: TextAlign.center),
            Text('tap to type · use − + to step',
                style: TextStyle(
                    fontSize: 9, color: cs.onSurface.withValues(alpha: 0.35)),
                textAlign: TextAlign.center),
            const SizedBox(height: 4),
          ]),
        ),
        IconButton(
          icon: const Icon(Icons.add, size: 18),
          color: _tsb < 35
              ? cs.primary
              : cs.onSurface.withValues(alpha: 0.3),
          onPressed: _tsb < 35
              ? () {
                  final v = double.parse((_tsb + 0.1).toStringAsFixed(1));
                  setState(() => _tsb = v);
                  _tsbInputCtrl.text = v.toStringAsFixed(1);
                }
              : null,
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
        ),
      ]),
    );
  }

  // ── Risk factors card ──────────────────────────────────────────────────────
  Widget _buildRiskFactorsCard() {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text('Neurotoxicity Risk Factors',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: cs.primary)),
              const SizedBox(width: 6),
              Tooltip(
                message:
                    'Any factor lowers phototherapy & exchange thresholds',
                child: Icon(Icons.info_outline,
                    size: 16,
                    color: cs.primary.withValues(alpha: 0.6)),
              ),
            ]),
            const SizedBox(height: 12),
            _riskTile('Albumin <3.0 g/dL', _rfAlbumin,
                (v) => setState(() => _rfAlbumin = v)),
            _riskTile(
                'Isoimmune hemolytic disease / Positive DAT',
                _rfIsoimmune,
                (v) => setState(() => _rfIsoimmune = v)),
            _riskTile(
                'G6PD deficiency or other hemolytic condition',
                _rfG6PD,
                (v) => setState(() => _rfG6PD = v)),
            _riskTile('Sepsis', _rfSepsis,
                (v) => setState(() => _rfSepsis = v)),
            _riskTile(
                'Significant clinical instability (past 24 hrs)',
                _rfInstability,
                (v) => setState(() => _rfInstability = v)),
            const SizedBox(height: 10),
            // These are semantic medical indicator colors — kept as-is
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _hasRisk
                    ? const Color(0xFFFFF8E1)
                    : const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: _hasRisk
                        ? const Color(0xFFF5A623)
                        : const Color(0xFF2DBD8C)),
              ),
              child: Row(children: [
                Icon(
                    _hasRisk
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle_outline,
                    size: 16,
                    color: _hasRisk
                        ? const Color(0xFFF5A623)
                        : const Color(0xFF2DBD8C)),
                const SizedBox(width: 8),
                Text(
                  _hasRisk
                      ? 'Using risk-factor thresholds'
                      : 'Using standard thresholds',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _hasRisk
                          ? const Color(0xFFF5A623)
                          : const Color(0xFF2DBD8C)),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _riskTile(
      String label, bool value, ValueChanged<bool> onChanged) {
    final cs = Theme.of(context).colorScheme;
    return CheckboxListTile(
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      title: Text(label,
          style: TextStyle(
              fontSize: 13, color: cs.onSurface)),
      activeColor: cs.primary,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  // ── Albumin card ───────────────────────────────────────────────────────────
  Widget _buildAlbuminCard() {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 1,
      color: Theme.of(context).cardColor,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => _showAlbumin = !_showAlbumin),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(children: [
                Icon(Icons.science_outlined,
                    color: cs.primary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Enter albumin for B/A ratio assessment (optional)',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: cs.primary),
                  ),
                ),
                Icon(
                    _showAlbumin
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: cs.primary),
              ]),
              if (_showAlbumin) ...[
                const SizedBox(height: 14),
                Row(children: [
                  Text('Albumin (g/dL):',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface)),
                  const SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: cs.outline),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 16),
                            color: _albumin > 1.0
                                ? cs.primary
                                : cs.onSurface.withValues(alpha: 0.3),
                            onPressed: _albumin > 1.0
                                ? () => setState(() => _albumin =
                                    double.parse((_albumin - 0.1)
                                        .toStringAsFixed(1)))
                                : null,
                            constraints: const BoxConstraints(
                                minWidth: 36, minHeight: 36),
                          ),
                          Text(_albumin.toStringAsFixed(1),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: cs.primary)),
                          IconButton(
                            icon: const Icon(Icons.add, size: 16),
                            color: _albumin < 5.0
                                ? cs.primary
                                : cs.onSurface.withValues(alpha: 0.3),
                            onPressed: _albumin < 5.0
                                ? () => setState(() => _albumin =
                                    double.parse((_albumin + 0.1)
                                        .toStringAsFixed(1)))
                                : null,
                            constraints: const BoxConstraints(
                                minWidth: 36, minHeight: 36),
                          ),
                        ]),
                  ),
                  const SizedBox(width: 12),
                  if (_albumin > 0)
                    _tagChip(
                        'B/A = ${(_tsb / _albumin).toStringAsFixed(2)}'),
                ]),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── Results ────────────────────────────────────────────────────────────────
  // Status hero uses semantic medical colors — kept as-is
  Widget _buildStatusHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _statusBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: _statusColor.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Column(children: [
        Text(_statusEmoji,
            style: const TextStyle(fontSize: 40)),
        const SizedBox(height: 8),
        Text(_classificationTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _statusColor)),
        const SizedBox(height: 6),
        Text('${_tsb.toStringAsFixed(1)} mg/dL',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: _statusColor)),
        const SizedBox(height: 8),
        Text(_actionText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13, color: _statusColor, height: 1.5)),
      ]),
    );
  }

  Widget _buildThresholdCard() {
    final cs = Theme.of(context).colorScheme;
    final h = _totalHours;
    final d = h ~/ 24;
    final rem = h % 24;
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thresholds at GA $_ga wks · Age $h hrs (${d}d ${rem}h)',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: cs.primary),
            ),
            const SizedBox(height: 12),
            // Threshold rows use semantic medical colors — kept as-is
            if (_photoThreshold != null)
              _thresholdRow('Phototherapy', _photoThreshold!,
                  _tsb >= _photoThreshold!),
            if (_escalationThreshold != null)
              _thresholdRow('Escalation (ET−2)',
                  _escalationThreshold!, _tsb >= _escalationThreshold!),
            if (_exchangeThreshold != null)
              _thresholdRow('Exchange Transfusion', _exchangeThreshold!,
                  _tsb >= _exchangeThreshold!),
            const SizedBox(height: 10),
            Wrap(spacing: 6, children: [
              _tagChip(_hasRisk
                  ? 'Risk-factor thresholds'
                  : 'Standard thresholds'),
              _tagChip('GA group: $_gaKeyUsed'),
            ]),
          ],
        ),
      ),
    );
  }

  // Threshold row uses semantic medical colors — kept as-is
  Widget _thresholdRow(
      String label, double threshold, bool atOrAbove) {
    final cs = Theme.of(context).colorScheme;
    final color = atOrAbove
        ? const Color(0xFFE53935)
        : const Color(0xFF2DBD8C);
    final bg = atOrAbove
        ? const Color(0xFFFFEBEE)
        : const Color(0xFFE8F5E9);
    final margin = threshold - _tsb;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(children: [
        Expanded(
          child: Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface)),
        ),
        Text('${threshold.toStringAsFixed(1)} mg/dL',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color)),
        const SizedBox(width: 8),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            atOrAbove
                ? '⚠️ At/Above'
                : '✓ ${margin.toStringAsFixed(1)} below',
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color),
          ),
        ),
      ]),
    );
  }

  // B/A card uses semantic medical colors — kept as-is
  Widget _buildBACard() {
    final ba = _tsb / _albumin;
    final double baThresh;
    if (_ga >= 38 && !_hasRisk) {
      baThresh = 8.0;
    } else if (_ga >= 38 && _hasRisk) {
      baThresh = 7.2;
    } else if (_ga < 38 && !_hasRisk) {
      baThresh = 7.2;
    } else {
      baThresh = 6.8;
    }
    final atThresh = ba >= baThresh;
    final color =
        atThresh ? const Color(0xFFE53935) : const Color(0xFF2DBD8C);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: atThresh
            ? const Color(0xFFFFEBEE)
            : const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bilirubin:Albumin (B/A) Ratio',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 8),
            Row(children: [
              Text('B/A = ${ba.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${atThresh ? "At/above" : "Below"} exchange threshold ($baThresh)',
                  style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ]),
          ]),
    );
  }

  Widget _buildRiskSummaryCard() {
    final active = <String>[];
    if (_rfAlbumin) active.add('Albumin <3.0 g/dL');
    if (_rfIsoimmune) active.add('Isoimmune hemolysis / positive DAT');
    if (_rfG6PD) active.add('G6PD deficiency or hemolytic condition');
    if (_rfSepsis) active.add('Sepsis');
    if (_rfInstability) active.add('Significant clinical instability');
    final cs = Theme.of(context).colorScheme;

    // Risk summary uses amber semantic color — kept as-is
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFFF5A623), width: 1.5),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [
              Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFF5A623), size: 18),
              SizedBox(width: 8),
              Text('Active Risk Factors',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF5A623))),
            ]),
            const SizedBox(height: 8),
            ...active.map((rf) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(children: [
                    const Icon(Icons.circle,
                        size: 6, color: Color(0xFFF5A623)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(rf,
                            style: TextStyle(
                                fontSize: 12,
                                color: cs.onSurface))),
                  ]),
                )),
            const SizedBox(height: 6),
            Text(
                'These risk factors lower phototherapy and exchange thresholds.',
                style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurface.withValues(alpha: 0.6),
                    fontStyle: FontStyle.italic)),
          ]),
    );
  }

  Widget _buildClinicalActionsCard() {
    final cs = Theme.of(context).colorScheme;
    final List<String> bullets;
    // Clinical action header uses semantic medical colors — kept as-is
    final Color headerColor;
    switch (_classification) {
      case 'below':
        headerColor = const Color(0xFF2DBD8C);
        final margin = _photoThreshold != null
            ? (_photoThreshold! - _tsb).toStringAsFixed(1)
            : '—';
        bullets = [
          'Continue monitoring',
          'Follow-up bilirubin based on Fig 7 (AAP 2022)',
          'Threshold minus TSB = $margin mg/dL margin',
        ];
        break;
      case 'phototherapy':
        headerColor = const Color(0xFFF5A623);
        bullets = [
          'Start intensive phototherapy immediately',
          'Irradiance ≥30 mW/cm²/nm (narrow-spectrum LED ~475nm)',
          'Measure TSB within 12 hours of starting phototherapy',
          'Continue breastfeeding/feeding during phototherapy',
          'Check CBC, blood type, DAT, G6PD if cause unknown',
        ];
        break;
      case 'escalation':
        headerColor = const Color(0xFFf97316);
        bullets = [
          'ESCALATION OF CARE — medical emergency',
          'Intensive phototherapy + oral AND IV hydration',
          'STAT: TSB, direct bili, CBC, albumin, chemistry, type & crossmatch',
          'Consult neonatologist — consider urgent NICU transfer',
          'Measure TSB every 2 hours',
          'Consider IVIG 0.5–1 g/kg if isoimmune hemolytic disease (positive DAT)',
        ];
        break;
      default: // exchange
        headerColor = const Color(0xFFE53935);
        bullets = [
          'URGENT EXCHANGE TRANSFUSION indicated',
          'Transfer to NICU immediately if not already there',
          'Cross-matched washed PRBCs + FFP, Hct ~40%',
          'Continue intensive phototherapy during transfer',
          'If TSB falls below ET threshold before starting: may defer with q2h TSB monitoring',
        ];
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: headerColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: headerColor.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Clinical Actions',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: headerColor)),
            const SizedBox(height: 10),
            ...bullets.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ',
                          style: TextStyle(
                              color: headerColor,
                              fontWeight: FontWeight.bold)),
                      Expanded(
                          child: Text(b,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: cs.onSurface,
                                  height: 1.4))),
                    ],
                  ),
                )),
          ]),
    );
  }

  Widget _buildIVIGCard() {
    final cs = Theme.of(context).colorScheme;
    // IVIG card uses a blue informational color — kept as-is (semantic)
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFF1976D2).withValues(alpha: 0.4)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.vaccines_outlined,
            color: Color(0xFF1976D2), size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('IVIG Option',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2))),
                const SizedBox(height: 4),
                Text(
                  '0.5–1 g/kg IV over 2 hours for positive DAT/isoimmune hemolysis. '
                  'May repeat in 12 hours. Discuss risks/benefits (possible NEC association).',
                  style: TextStyle(
                      fontSize: 12,
                      color: cs.onSurface,
                      height: 1.5),
                ),
              ]),
        ),
      ]),
    );
  }

  Widget _buildReferenceCard() {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📚  Reference',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: cs.primary)),
            const SizedBox(height: 8),
            Text(
              'Kemper AR, Newman TB, Slaughter JL, et al.\n'
              'Clinical Practice Guideline Revision: Management of\n'
              'Hyperbilirubinemia in the Newborn Infant 35 or More\n'
              'Weeks of Gestation. Pediatrics. 2022;150(3):e2022058859.',
              style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurface.withValues(alpha: 0.5),
                  fontStyle: FontStyle.italic,
                  height: 1.5),
            ),
            const SizedBox(height: 8),
            Text(
              'Thresholds based on expert opinion. TSB used (do not subtract '
              'direct bilirubin). For clinical use by qualified professionals only. '
              'Verify before acting.',
              style: TextStyle(
                  fontSize: 10,
                  color: cs.onSurface.withValues(alpha: 0.5),
                  height: 1.5),
            ),
          ]),
    );
  }
}

// ── Int Stepper Field ──────────────────────────────────────────────────────
class _IntStepperField extends StatefulWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final String hint;
  final ValueChanged<int> onChanged;

  const _IntStepperField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.hint,
    required this.onChanged,
  });

  @override
  State<_IntStepperField> createState() => _IntStepperFieldState();
}

class _IntStepperFieldState extends State<_IntStepperField> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(_IntStepperField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      final newText = widget.value.toString();
      if (_ctrl.text != newText) {
        _ctrl.text = newText;
        _ctrl.selection =
            TextSelection.collapsed(offset: newText.length);
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleTextChange(String text) {
    final v = int.tryParse(text);
    if (v != null && v >= widget.min && v <= widget.max) {
      widget.onChanged(v);
    }
  }

  void _decrement() {
    final newVal = widget.value - 1;
    widget.onChanged(newVal);
    _ctrl.text = newVal.toString();
    _ctrl.selection =
        TextSelection.collapsed(offset: _ctrl.text.length);
  }

  void _increment() {
    final newVal = widget.value + 1;
    widget.onChanged(newVal);
    _ctrl.text = newVal.toString();
    _ctrl.selection =
        TextSelection.collapsed(offset: _ctrl.text.length);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: cs.onSurface)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: cs.outline),
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).cardColor,
          ),
          child: Row(children: [
            IconButton(
              icon: const Icon(Icons.remove, size: 18),
              color: widget.value > widget.min
                  ? cs.primary
                  : cs.onSurface.withValues(alpha: 0.3),
              onPressed:
                  widget.value > widget.min ? _decrement : null,
              constraints:
                  const BoxConstraints(minWidth: 44, minHeight: 44),
            ),
            Expanded(
              child: Column(children: [
                TextField(
                  controller: _ctrl,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: cs.primary),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: _handleTextChange,
                ),
                Text(widget.hint,
                    style: TextStyle(
                        fontSize: 10, color: cs.onSurface.withValues(alpha: 0.5)),
                    textAlign: TextAlign.center),
              ]),
            ),
            IconButton(
              icon: const Icon(Icons.add, size: 18),
              color: widget.value < widget.max
                  ? cs.primary
                  : cs.onSurface.withValues(alpha: 0.3),
              onPressed:
                  widget.value < widget.max ? _increment : null,
              constraints:
                  const BoxConstraints(minWidth: 44, minHeight: 44),
            ),
          ]),
        ),
      ],
    );
  }
}
