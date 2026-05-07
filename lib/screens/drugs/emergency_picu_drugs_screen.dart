// =============================================================================
// emergency_picu_drugs_screen.dart
// Emergency PICU Drugs — Working calculator
//   - Top: Bolus / STAT drugs (Adrenaline, Atropine, Adenosine, Amiodarone,
//     Calcium gluconate, Dextrose, Insulin, Magnesium sulphate, Naloxone,
//     Sodium Bicarbonate). Weight-based with live mg + mL output.
//   - Bottom: Continuous Vasoactive Infusions (Dopamine, Dobutamine,
//     Epinephrine, Norepinephrine, Vasopressin, Milrinone, Levosimendan,
//     SNP, NTG). Smart View (preparation card per drug) + Table View.
//   - Header pill links to the Emergency ICU Drugs reference Guide.
// All numeric data verbatim from internal reference compendium.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../guides/emergency_icu_drugs_screen.dart';

const Color _picuRed = Color(0xFF6A1B9A); // PICU = purple to differentiate from NICU red
const Color _picuRedDark = Color(0xFF4A148C);
const Color _picuAccent = Color(0xFFB71C1C);

// ─── Bolus drug data (Emergency Drugs table) ────────────────────────────────

class _BolusDrug {
  final String name;
  final String indication;
  /// Per-kg dose. Multiple per-kg doses (e.g. for different indications)
  /// are presented as a single computed line per indication string.
  final List<_BolusDoseRule> rules;
  final String maxDose;
  final String comments;
  final String? warning;
  const _BolusDrug({
    required this.name,
    required this.indication,
    required this.rules,
    required this.maxDose,
    required this.comments,
    this.warning,
  });
}

/// One row of dose calculation for a bolus drug.
/// dosePerKg can be in mg, mL, U, mEq — described in [unit].
/// concentrationMgPerMl = vial concentration (mg/mL or U/mL or mEq/mL); used
/// to compute mL volume = (dosePerKg × wt) / concentration. Set to null when
/// the row is volume-based (e.g. dextrose 10 mL/kg) — then dosePerKg is mL.
class _BolusDoseRule {
  final String label;
  final double dosePerKg;
  final String unit; // 'mg', 'U', 'mEq', 'mL'
  final double? concentration; // unit per mL of stock; null = volume-based
  final String stockLabel;
  const _BolusDoseRule({
    required this.label,
    required this.dosePerKg,
    required this.unit,
    required this.stockLabel,
    this.concentration,
  });
}

const List<_BolusDrug> _bolusDrugs = [
  _BolusDrug(
    name: 'Adrenaline',
    indication: 'Cardiac arrest · Symptomatic bradycardia · Anaphylaxis',
    rules: [
      _BolusDoseRule(
        label: 'Cardiac arrest IV/IO (1:10,000)',
        dosePerKg: 0.01,
        unit: 'mg',
        concentration: 0.1, // 1:10,000 = 0.1 mg/mL
        stockLabel: '1:10,000 (0.1 mg/mL)',
      ),
      _BolusDoseRule(
        label: 'Symptomatic bradycardia ETT (1:1,000)',
        dosePerKg: 0.1,
        unit: 'mg',
        concentration: 1.0, // 1:1,000 = 1 mg/mL
        stockLabel: '1:1,000 (1 mg/mL)',
      ),
      _BolusDoseRule(
        label: 'Anaphylaxis IM (1:1,000)',
        dosePerKg: 0.01,
        unit: 'mg',
        concentration: 1.0,
        stockLabel: '1:1,000 (1 mg/mL)',
      ),
    ],
    maxDose: '1 mg / 2.5 mg / 0.5 mg',
    comments: 'IM in anaphylaxis. Repeat q 3–5 min in arrest.',
  ),
  _BolusDrug(
    name: 'Atropine',
    indication: 'Bradycardia · AV Block',
    rules: [
      _BolusDoseRule(
        label: 'IV / IO / IM',
        dosePerKg: 0.02,
        unit: 'mg',
        concentration: 0.6, // typical 1 mL = 0.6 mg vial
        stockLabel: '0.6 mg/mL',
      ),
      _BolusDoseRule(
        label: 'ETT',
        dosePerKg: 0.05, // 0.04–0.06 mg/kg, midpoint
        unit: 'mg',
        concentration: 0.6,
        stockLabel: '0.6 mg/mL',
      ),
    ],
    maxDose: '1 mg',
    comments: 'Min single dose 0.1 mg to avoid paradoxical bradycardia.',
  ),
  _BolusDrug(
    name: 'Adenosine',
    indication: 'Supraventricular tachycardia',
    rules: [
      _BolusDoseRule(
        label: '1st dose IV/IO',
        dosePerKg: 0.1,
        unit: 'mg',
        concentration: 3.0,
        stockLabel: '3 mg/mL',
      ),
      _BolusDoseRule(
        label: '2nd dose IV/IO',
        dosePerKg: 0.2,
        unit: 'mg',
        concentration: 3.0,
        stockLabel: '3 mg/mL',
      ),
    ],
    maxDose: '6 mg / 12 mg',
    comments: 'Rapid bolus, immediately follow with 10 mL NS flush.',
    warning: 'Half-life ~10 sec — give as fast push into a large vein.',
  ),
  _BolusDrug(
    name: 'Amiodarone',
    indication: 'Ventricular tachycardia · Ventricular fibrillation',
    rules: [
      _BolusDoseRule(
        label: 'IV / IO',
        dosePerKg: 5.0,
        unit: 'mg',
        concentration: 50.0, // 1 mL = 50 mg
        stockLabel: '50 mg/mL',
      ),
    ],
    maxDose: 'First dose 300 mg ; Subsequent 150 mg',
    comments: 'Infuse over 20–60 minutes (over 1–2 min in pulseless arrest).',
  ),
  _BolusDrug(
    name: 'Calcium gluconate (10 %)',
    indication: 'Hypocalcaemia · Hyperkalaemia',
    rules: [
      _BolusDoseRule(
        label: 'IV slow push',
        dosePerKg: 1.0,
        unit: 'mL',
        stockLabel: '10 % solution',
      ),
    ],
    maxDose: '2 g per dose',
    comments: 'Over 10–20 min via confirmed IV — extravasation causes necrosis.',
    warning: 'Do NOT mix with NaHCO₃ (precipitates). Monitor HR.',
  ),
  _BolusDrug(
    name: 'Dextrose',
    indication: 'Hypoglycaemia',
    rules: [
      _BolusDoseRule(
        label: '10 % dextrose IV/IO',
        dosePerKg: 10.0,
        unit: 'mL',
        stockLabel: '10 % dextrose',
      ),
      _BolusDoseRule(
        label: '25 % dextrose IV/IO',
        dosePerKg: 4.0,
        unit: 'mL',
        stockLabel: '25 % dextrose',
      ),
      _BolusDoseRule(
        label: '50 % dextrose IV/IO',
        dosePerKg: 2.0,
        unit: 'mL',
        stockLabel: '50 % dextrose',
      ),
    ],
    maxDose: 'Max single dose 50 g',
    comments: 'Re-check capillary glucose at 15–30 min.',
  ),
  _BolusDrug(
    name: 'Insulin',
    indication: 'Hyperkalaemia',
    rules: [
      _BolusDoseRule(
        label: 'Regular insulin IV/IO',
        dosePerKg: 0.1,
        unit: 'U',
        concentration: 100.0, // 1 mL = 100 U
        stockLabel: '100 U/mL (regular)',
      ),
    ],
    maxDose: '10 Units',
    comments: 'Always co-administer with 0.5 g/kg dextrose. Monitor blood glucose hourly.',
  ),
  _BolusDrug(
    name: 'Magnesium sulphate',
    indication: 'Torsades de pointes · Hypomagnesaemia',
    rules: [
      _BolusDoseRule(
        label: 'IV / IO',
        dosePerKg: 50.0,
        unit: 'mg',
        concentration: 500.0, // 50 % MgSO4 = 500 mg/mL
        stockLabel: '50 % (500 mg/mL)',
      ),
    ],
    maxDose: '2 g per dose',
    comments: 'Over 20–30 min. Stop if hypotension or bradycardia.',
  ),
  _BolusDrug(
    name: 'Naloxone',
    indication: 'Opioid overdose · Respiratory depression',
    rules: [
      _BolusDoseRule(
        label: 'Resp depression (low dose)',
        dosePerKg: 0.003, // 0.001–0.005 midpoint
        unit: 'mg',
        concentration: 0.4, // 1 mL = 0.4 mg
        stockLabel: '0.4 mg/mL',
      ),
      _BolusDoseRule(
        label: 'Full reversal IV/IO/IM/SC',
        dosePerKg: 0.1,
        unit: 'mg',
        concentration: 0.4,
        stockLabel: '0.4 mg/mL',
      ),
    ],
    maxDose: '0.1 mg / 2 mg',
    comments: 'ETT dose 2–3× IV dose. Watch for re-narcotisation.',
  ),
  _BolusDrug(
    name: 'Sodium Bicarbonate',
    indication: 'Metabolic acidosis · Hyperkalaemia · TCA overdose',
    rules: [
      _BolusDoseRule(
        label: 'IV / IO (8.4 %)',
        dosePerKg: 1.0,
        unit: 'mEq',
        concentration: 1.0, // 8.4 % = 1 mEq/mL
        stockLabel: '8.4 % (1 mEq/mL)',
      ),
    ],
    maxDose: '50 mEq per dose',
    comments: 'Dilute 1:1 with sterile water for peripheral access.',
    warning: 'Establish ventilation first. Do NOT mix with adrenaline or calcium.',
  ),
];

// ─── Infusion drug data (Vasoactive Medications) ────────────────────────────

class _InfusionDrug {
  final String name;
  final String doseRange; // µg/kg/min etc.
  /// Dilution rule: drug amount per kg in 50 mL diluent.
  /// `dilutionMgPerKg` mg/kg in 50 mL  (or mIU/kg for Vasopressin).
  final double dilutionMgPerKg;
  /// Reference rate label, e.g. '1 mL/hr = 10 µg/kg/min'.
  final String referenceRate;
  /// Dose unit: 'µg/kg/min', 'mIU/kg/min'
  final String doseUnit;
  /// Implied 1 mL/hr dose (the value before unit).
  final double oneMlPerHrDose;
  final String diluent;
  final String stockLabel;
  /// Stock vial concentration (drug per mL) — same unit as dilutionMgPerKg.
  /// Used to compute the mL of drug to draw from the vial.
  final double stockPerMl;
  final String? warning;
  const _InfusionDrug({
    required this.name,
    required this.doseRange,
    required this.dilutionMgPerKg,
    required this.referenceRate,
    required this.doseUnit,
    required this.oneMlPerHrDose,
    required this.diluent,
    required this.stockLabel,
    required this.stockPerMl,
    this.warning,
  });
}

const List<_InfusionDrug> _infusionDrugs = [
  _InfusionDrug(
    name: 'Dopamine',
    doseRange: '5–20 µg/kg/min',
    dilutionMgPerKg: 30.0,
    referenceRate: '1 mL/hr = 10 µg/kg/min',
    doseUnit: 'µg/kg/min',
    oneMlPerHrDose: 10.0,
    diluent: '50 mL D5',
    stockLabel: '40 mg/mL ampoule',
    stockPerMl: 40.0,
  ),
  _InfusionDrug(
    name: 'Dobutamine',
    doseRange: '5–20 µg/kg/min',
    dilutionMgPerKg: 30.0,
    referenceRate: '1 mL/hr = 10 µg/kg/min',
    doseUnit: 'µg/kg/min',
    oneMlPerHrDose: 10.0,
    diluent: '50 mL D5',
    stockLabel: '50 mg/mL ampoule',
    stockPerMl: 50.0,
  ),
  _InfusionDrug(
    name: 'Epinephrine (Adrenaline)',
    doseRange: '0.05–1.0 µg/kg/min',
    dilutionMgPerKg: 0.3,
    referenceRate: '1 mL/hr = 0.1 µg/kg/min',
    doseUnit: 'µg/kg/min',
    oneMlPerHrDose: 0.1,
    diluent: '50 mL D5',
    stockLabel: '1 mg/mL (1:1,000)',
    stockPerMl: 1.0,
  ),
  _InfusionDrug(
    name: 'Norepinephrine',
    doseRange: '0.05–0.5 µg/kg/min',
    dilutionMgPerKg: 0.3,
    referenceRate: '1 mL/hr = 0.1 µg/kg/min',
    doseUnit: 'µg/kg/min',
    oneMlPerHrDose: 0.1,
    diluent: '50 mL D5',
    stockLabel: '2 mg/mL ampoule',
    stockPerMl: 2.0,
  ),
  _InfusionDrug(
    name: 'Vasopressin',
    doseRange: '0.5–2 mIU/kg/min',
    dilutionMgPerKg: 3.0, // 3 milliunits/kg in 50 mL — special unit
    referenceRate: '1 mL/hr = 1 mIU/kg/min',
    doseUnit: 'mIU/kg/min',
    oneMlPerHrDose: 1.0,
    diluent: '50 mL D5',
    stockLabel: '20 U/mL ampoule (= 20,000 mIU/mL)',
    stockPerMl: 20000.0, // 20 U = 20000 mIU per mL
  ),
  _InfusionDrug(
    name: 'Milrinone',
    doseRange: '0.25–1.0 µg/kg/min',
    dilutionMgPerKg: 1.5,
    referenceRate: '1 mL/hr = 0.5 µg/kg/min',
    doseUnit: 'µg/kg/min',
    oneMlPerHrDose: 0.5,
    diluent: '50 mL D5',
    stockLabel: '1 mg/mL ampoule',
    stockPerMl: 1.0,
  ),
  _InfusionDrug(
    name: 'Levosimendan',
    doseRange: '0.05–0.2 µg/kg/min',
    dilutionMgPerKg: 0.3,
    referenceRate: '1 mL/hr = 0.1 µg/kg/min',
    doseUnit: 'µg/kg/min',
    oneMlPerHrDose: 0.1,
    diluent: '50 mL D5',
    stockLabel: '2.5 mg/mL ampoule',
    stockPerMl: 2.5,
  ),
  _InfusionDrug(
    name: 'Sodium nitroprusside (SNP)',
    doseRange: '0.5–10 µg/kg/min',
    dilutionMgPerKg: 3.0,
    referenceRate: '1 mL/hr = 1 µg/kg/min',
    doseUnit: 'µg/kg/min',
    oneMlPerHrDose: 1.0,
    diluent: '50 mL D5',
    stockLabel: '50 mg vial / 2 mL → 25 mg/mL',
    stockPerMl: 25.0,
    warning: 'Protect from light. Watch for cyanide toxicity beyond 48 h or > 2 µg/kg/min.',
  ),
  _InfusionDrug(
    name: 'Nitroglycerine (NTG)',
    doseRange: '0.5–20 µg/kg/min',
    dilutionMgPerKg: 3.0,
    referenceRate: '1 mL/hr = 1 µg/kg/min',
    doseUnit: 'µg/kg/min',
    oneMlPerHrDose: 1.0,
    diluent: '50 mL D5',
    stockLabel: '5 mg/mL ampoule',
    stockPerMl: 5.0,
  ),
];

// ─── Helpers ────────────────────────────────────────────────────────────────

String _fmt(double v, {int decimals = 2}) {
  if (v.isNaN || v.isInfinite) return '—';
  if (v == v.roundToDouble() && decimals <= 2) {
    return v.toStringAsFixed(decimals);
  }
  return v.toStringAsFixed(decimals);
}

// =============================================================================
// Main screen
// =============================================================================

class EmergencyPICUDrugsScreen extends StatefulWidget {
  const EmergencyPICUDrugsScreen({super.key});

  @override
  State<EmergencyPICUDrugsScreen> createState() =>
      _EmergencyPICUDrugsScreenState();
}

enum _PicuModule { stat, infusion }

class _EmergencyPICUDrugsScreenState extends State<EmergencyPICUDrugsScreen> {
  final TextEditingController _weightCtrl = TextEditingController();
  final TextEditingController _customVolCtrl = TextEditingController();
  double? _weight;
  bool _smartView = true;
  _PicuModule _module = _PicuModule.stat;

  // Infusion-only controls
  double _multiplier = 1.0;
  String _dropdownVolume = 'Default';
  double? _customVolumeMl;
  bool _showCustomVolField = false;

  @override
  void dispose() {
    _weightCtrl.dispose();
    _customVolCtrl.dispose();
    super.dispose();
  }

  void _onWeightChanged(String v) {
    setState(() => _weight = double.tryParse(v));
  }

  /// Resolve total prep volume in mL (default = 50 mL for PICU per brochure).
  double _resolvedTotalMl() {
    if (_dropdownVolume == 'Default') return 50.0;
    if (_dropdownVolume == 'Custom') return _customVolumeMl ?? 50.0;
    final v = double.tryParse(_dropdownVolume.replaceAll('ml', '').trim());
    return v ?? 50.0;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme =
        GoogleFonts.plusJakartaSansTextTheme(Theme.of(context).textTheme);
    return Theme(
      data: Theme.of(context).copyWith(textTheme: textTheme),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _picuRed,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Emergency PICU Drugs',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              Text('Weight-based · Bolus + Infusion calculator',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.85))),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Open Reference Guide',
              icon: const Icon(Icons.menu_book_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const EmergencyIcuDrugsScreen()),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // ── Module switch ────────────────────────────────────────────
            _PicuModuleSwitch(
              current: _module,
              onChanged: (m) => setState(() => _module = m),
            ),
            // ── Sticky Header (weight + smart/table + multiplier/vol) ───
            _PicuStickyHeader(
              weightCtrl: _weightCtrl,
              onWeightChanged: _onWeightChanged,
              smartView: _smartView,
              onViewToggle: (v) => setState(() => _smartView = v),
              showAdvancedControls:
                  _module == _PicuModule.infusion && _smartView,
              multiplier: _multiplier,
              onMultiplierChanged: (v) =>
                  setState(() => _multiplier = v),
              dropdownVolume: _dropdownVolume,
              onDropdownChanged: (v) {
                setState(() {
                  _dropdownVolume = v ?? 'Default';
                  _showCustomVolField = _dropdownVolume == 'Custom';
                  if (!_showCustomVolField) _customVolumeMl = null;
                });
              },
              showCustomVolField: _showCustomVolField,
              customVolCtrl: _customVolCtrl,
              onCustomVolChanged: (v) =>
                  setState(() => _customVolumeMl = double.tryParse(v)),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                children: [
                  if (_module == _PicuModule.stat) ...[
                    if (_smartView) ...[
                      for (final d in _bolusDrugs)
                        _BolusDrugCard(drug: d, weight: _weight),
                    ] else ...[
                      _BolusTable(weight: _weight),
                    ],
                  ] else ...[
                    if (_smartView) ...[
                      for (final d in _infusionDrugs)
                        _InfusionSmartCardV2(
                            drug: d,
                            weight: _weight,
                            multiplier: _multiplier,
                            totalMl: _resolvedTotalMl()),
                    ] else ...[
                      _InfusionTableHeader(),
                      for (final d in _infusionDrugs)
                        _InfusionTableRow(
                            drug: d,
                            weight: _weight,
                            multiplier: _multiplier,
                            totalMl: _resolvedTotalMl()),
                    ],
                  ],

                  const SizedBox(height: 16),
                  // Cross-link to guide
                  _GuideLinkPill(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const EmergencyIcuDrugsScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _Disclaimer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Module switch ──────────────────────────────────────────────────────────

class _PicuModuleSwitch extends StatelessWidget {
  final _PicuModule current;
  final ValueChanged<_PicuModule> onChanged;
  const _PicuModuleSwitch({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.10),
              width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _btn(
              label: 'STAT BOLUS',
              icon: Icons.bolt,
              selected: current == _PicuModule.stat,
              onTap: () => onChanged(_PicuModule.stat),
              color: _picuAccent,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _btn(
              label: 'INFUSION',
              icon: Icons.water_drop_outlined,
              selected: current == _PicuModule.infusion,
              onTap: () => onChanged(_PicuModule.infusion),
              color: _picuRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: selected ? 0 : 1.5),
          boxShadow: selected
              ? [
                  BoxShadow(
                      color: color.withValues(alpha: 0.30),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? Colors.white : color, size: 18),
            const SizedBox(width: 8),
            Text(label,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    color: selected ? Colors.white : color)),
          ],
        ),
      ),
    );
  }
}

// ─── Sticky header (with optional multiplier + volume controls) ─────────────

class _PicuStickyHeader extends StatelessWidget {
  final TextEditingController weightCtrl;
  final ValueChanged<String> onWeightChanged;
  final bool smartView;
  final ValueChanged<bool> onViewToggle;
  final bool showAdvancedControls;
  final double multiplier;
  final ValueChanged<double> onMultiplierChanged;
  final String dropdownVolume;
  final ValueChanged<String?> onDropdownChanged;
  final bool showCustomVolField;
  final TextEditingController customVolCtrl;
  final ValueChanged<String> onCustomVolChanged;
  const _PicuStickyHeader({
    required this.weightCtrl,
    required this.onWeightChanged,
    required this.smartView,
    required this.onViewToggle,
    required this.showAdvancedControls,
    required this.multiplier,
    required this.onMultiplierChanged,
    required this.dropdownVolume,
    required this.onDropdownChanged,
    required this.showCustomVolField,
    required this.customVolCtrl,
    required this.onCustomVolChanged,
  });

  static const List<double> _multValues = [0.5, 1.0, 2.0, 3.0, 4.0];
  static const List<String> _multLabels = ['½x', '1x', '2x', '3x', '4x'];
  static const List<String> _volOptions = [
    'Default',
    '20ml',
    '50ml',
    '100ml',
    'Custom',
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: cs.onSurface.withValues(alpha: 0.12), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: weightCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            onChanged: onWeightChanged,
            decoration: InputDecoration(
              labelText: "Patient's Weight",
              hintText: 'Enter weight in kg',
              suffixText: 'kg',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              isDense: true,
            ),
            style: GoogleFonts.plusJakartaSans(
                fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: smartView
                    ? FilledButton.icon(
                        onPressed: () => onViewToggle(true),
                        icon: const Text('🧠',
                            style: TextStyle(fontSize: 14)),
                        label: const Text('Smart View'),
                        style: FilledButton.styleFrom(
                            backgroundColor: _picuRed,
                            foregroundColor: Colors.white),
                      )
                    : OutlinedButton.icon(
                        onPressed: () => onViewToggle(true),
                        icon: const Text('🧠',
                            style: TextStyle(fontSize: 14)),
                        label: const Text('Smart View'),
                      ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: !smartView
                    ? FilledButton.icon(
                        onPressed: () => onViewToggle(false),
                        icon: const Text('📋',
                            style: TextStyle(fontSize: 14)),
                        label: const Text('Table View'),
                        style: FilledButton.styleFrom(
                            backgroundColor: _picuRed,
                            foregroundColor: Colors.white),
                      )
                    : OutlinedButton.icon(
                        onPressed: () => onViewToggle(false),
                        icon: const Text('📋',
                            style: TextStyle(fontSize: 14)),
                        label: const Text('Table View'),
                      ),
              ),
            ],
          ),
          if (showAdvancedControls) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Text('Concentration:',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withValues(alpha: 0.7))),
                const SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_multValues.length, (i) {
                        final v = _multValues[i];
                        final selected = multiplier == v;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text(_multLabels[i],
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700)),
                            selected: selected,
                            onSelected: (_) {
                              HapticFeedback.selectionClick();
                              onMultiplierChanged(v);
                            },
                            selectedColor: _picuRed,
                            labelStyle: TextStyle(
                                color: selected ? Colors.white : null),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 0),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Total volume:',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withValues(alpha: 0.7))),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: dropdownVolume,
                  isDense: true,
                  items: _volOptions
                      .map((v) => DropdownMenuItem(
                            value: v,
                            child: Text(v,
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13)),
                          ))
                      .toList(),
                  onChanged: onDropdownChanged,
                  underline: const SizedBox.shrink(),
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 13, color: cs.onSurface),
                ),
                if (showCustomVolField) ...[
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 70,
                    child: TextField(
                      controller: customVolCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*')),
                      ],
                      onChanged: onCustomVolChanged,
                      decoration: InputDecoration(
                        hintText: 'mL',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        isDense: true,
                      ),
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Guide link pill ────────────────────────────────────────────────────────

class _GuideLinkPill extends StatelessWidget {
  final VoidCallback onTap;
  const _GuideLinkPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: _picuRedDark.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: _picuRedDark.withValues(alpha: 0.30)),
        ),
        child: Row(
          children: [
            const Icon(Icons.menu_book_outlined,
                color: _picuRedDark, size: 18),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Open Emergency ICU Drugs reference guide',
                style: TextStyle(
                    color: _picuRedDark,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700),
              ),
            ),
            const Icon(Icons.chevron_right,
                color: _picuRedDark, size: 18),
          ],
        ),
      ),
    );
  }
}

// ─── Bolus drug card ────────────────────────────────────────────────────────

class _BolusDrugCard extends StatelessWidget {
  final _BolusDrug drug;
  final double? weight;
  const _BolusDrugCard({required this.drug, required this.weight});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: const BorderSide(color: _picuAccent, width: 4),
          top: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
          right: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
          bottom: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(drug.name,
                    style: const TextStyle(
                        fontSize: 15.5, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _picuAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('STAT',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: _picuAccent)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(drug.indication,
              style: TextStyle(
                  fontSize: 11.5,
                  color: cs.onSurface.withValues(alpha: 0.7),
                  fontStyle: FontStyle.italic)),
          const SizedBox(height: 10),
          // Per-rule computed dose lines
          ...drug.rules.map((r) => _BolusRuleRow(rule: r, weight: weight)),
          const SizedBox(height: 8),
          _kv(context, 'Max', drug.maxDose),
          if (drug.comments.isNotEmpty)
            _kv(context, 'Notes', drug.comments),
          if (drug.warning != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFEF9A9A)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Color(0xFFB71C1C), size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(drug.warning!,
                        style: const TextStyle(
                            color: Color(0xFFB71C1C),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _kv(BuildContext ctx, String label, String value) {
    final cs = Theme.of(ctx).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 50,
            child: Text(label,
                style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.55),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3)),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.85),
                    fontSize: 12,
                    height: 1.45)),
          ),
        ],
      ),
    );
  }
}

class _BolusRuleRow extends StatelessWidget {
  final _BolusDoseRule rule;
  final double? weight;
  const _BolusRuleRow({required this.rule, required this.weight});

  @override
  Widget build(BuildContext context) {
    final w = weight;
    final hasWt = w != null && w > 0;

    String doseLine;
    String volLine;
    if (hasWt) {
      final doseAbs = rule.dosePerKg * w;
      if (rule.unit == 'mL') {
        // Volume-based — dose in mL is the dose itself.
        doseLine = '${_fmt(doseAbs)} mL of ${rule.stockLabel}';
        volLine = '@ ${_fmt(rule.dosePerKg)} mL/kg';
      } else if (rule.concentration != null) {
        final mlVol = doseAbs / rule.concentration!;
        doseLine = '${_fmt(doseAbs, decimals: 3)} ${rule.unit}';
        volLine =
            '= ${_fmt(mlVol, decimals: 2)} mL of ${rule.stockLabel}';
      } else {
        doseLine = '${_fmt(doseAbs, decimals: 3)} ${rule.unit}';
        volLine = rule.stockLabel;
      }
    } else {
      doseLine =
          '${_fmt(rule.dosePerKg, decimals: rule.dosePerKg < 0.01 ? 4 : 3)} ${rule.unit}/kg';
      volLine = '— enter weight to see mL —';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 7, 10, 8),
        decoration: BoxDecoration(
          color: hasWt
              ? const Color(0xFFFFF3E0)
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: hasWt
                  ? const Color(0xFFFFCC80)
                  : Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(rule.label,
                style: const TextStyle(
                    fontSize: 11.5, fontWeight: FontWeight.w800)),
            const SizedBox(height: 3),
            Text(doseLine,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: hasWt
                        ? const Color(0xFFE65100)
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7))),
            const SizedBox(height: 1),
            Text(volLine,
                style: TextStyle(
                    fontSize: 11.5,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7))),
          ],
        ),
      ),
    );
  }
}

// ─── Infusion smart card V2 — weight × multiplier × totalMl ──────────────────

class _InfusionSmartCardV2 extends StatelessWidget {
  final _InfusionDrug drug;
  final double? weight;
  final double multiplier;
  final double totalMl;
  const _InfusionSmartCardV2({
    required this.drug,
    required this.weight,
    required this.multiplier,
    required this.totalMl,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final w = weight;
    final hasWt = w != null && w > 0;
    final unit = drug.name == 'Vasopressin' ? 'mIU' : 'mg';

    // Drug amount (scaled by multiplier).
    // Brochure: dilutionMgPerKg in 50 mL → 1 mL/hr = oneMlPerHrDose.
    // Scale to user's total volume: drugAmt × (50 / totalMl) keeps the
    // 1mL/hr → dose constant; OR scale dose with concentration (NICU style).
    // We follow NICU semantics: multiplier scales the DRUG amount in the same
    // syringe → final concentration scales × multiplier → 1 mL/hr delivers
    // (oneMlPerHrDose × multiplier × 50/totalMl) effectively.
    // To keep the math simple and match brochure: we recompute final conc and
    // 1 mL/hr equivalent dose for the chosen totalMl + multiplier.
    final drugAmt = hasWt ? drug.dilutionMgPerKg * w * multiplier : 0.0;
    final drugMl = hasWt ? drugAmt / drug.stockPerMl : 0.0;
    final dilMl = hasWt ? totalMl - drugMl : 0.0;
    // 1 mL/hr at this prep delivers (drugAmt / totalMl) per hr.
    // Convert to dose unit:
    //  µg/kg/min: per-min = (drugAmt × 1000 / totalMl) / 60 ; per-kg = /w
    //  mIU/kg/min: drugAmt is mIU → per-min = (drugAmt / totalMl) / 60 ; /w
    final double oneMlDose;
    if (drug.doseUnit == 'µg/kg/min' && hasWt) {
      oneMlDose = (drugAmt * 1000.0 / totalMl) / 60.0 / w;
    } else if (drug.doseUnit == 'mIU/kg/min' && hasWt) {
      oneMlDose = (drugAmt / totalMl) / 60.0 / w;
    } else {
      oneMlDose = drug.oneMlPerHrDose * multiplier;
    }
    final canFit = hasWt && drugMl > 0 && drugMl <= totalMl;
    final overFlow = hasWt && drugMl > totalMl;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: _picuRed, width: 4),
          top: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
          right: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
          bottom: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(drug.name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _picuRed,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(drug.doseRange,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // PREPARE block
          Container(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            decoration: BoxDecoration(
              color: hasWt
                  ? (canFit
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFF3E0))
                  : cs.onSurface.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: hasWt
                      ? (canFit
                          ? const Color(0xFF81C784)
                          : const Color(0xFFFFCC80))
                      : cs.onSurface.withValues(alpha: 0.10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PREPARE',
                    style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.55),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3)),
                const SizedBox(height: 4),
                if (hasWt) ...[
                  Text(
                    'Take ${_fmt(drugMl, decimals: 2)} mL of '
                    '${drug.stockLabel} (= ${_fmt(drugAmt)} $unit)',
                    style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        height: 1.4),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Add ${_fmt(dilMl, decimals: 2)} mL of '
                    '${drug.diluent.replaceAll('50 mL ', '')} '
                    'to make ${_fmt(totalMl)} mL total',
                    style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: cs.onSurface.withValues(alpha: 0.85)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Final: ${_fmt(drugAmt / totalMl * (drug.doseUnit == 'µg/kg/min' ? 1000 : 1), decimals: drug.doseUnit == 'µg/kg/min' ? 1 : 2)} '
                    '${drug.doseUnit == 'µg/kg/min' ? 'µg' : 'mIU'}/mL',
                    style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B5E20)),
                  ),
                  if (overFlow) ...[
                    const SizedBox(height: 4),
                    Text(
                      '⚠ Drug volume (${_fmt(drugMl)} mL) exceeds the chosen total — pick a larger total volume.',
                      style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFBF360C),
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ] else
                  Text(
                    'Add (Wt × ${_fmt(drug.dilutionMgPerKg)} × ${_fmt(multiplier)}) $unit to ${_fmt(totalMl)} mL total. '
                    'Stock: ${drug.stockLabel}.',
                    style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // TITRATE block
          Container(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFCC80)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TITRATE',
                    style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.55),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3)),
                const SizedBox(height: 3),
                Text(
                  hasWt
                      ? '1 mL/hr → ${_fmt(oneMlDose, decimals: oneMlDose < 1 ? 3 : 2)} ${drug.doseUnit}'
                      : drug.referenceRate,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFE65100)),
                ),
                const SizedBox(height: 4),
                _RateLadderV2(
                    oneMlDose: hasWt ? oneMlDose : drug.oneMlPerHrDose,
                    doseUnit: drug.doseUnit),
              ],
            ),
          ),
          if (drug.warning != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFEF9A9A)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Color(0xFFB71C1C), size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(drug.warning!,
                        style: const TextStyle(
                            color: Color(0xFFB71C1C),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RateLadderV2 extends StatelessWidget {
  final double oneMlDose;
  final String doseUnit;
  const _RateLadderV2({required this.oneMlDose, required this.doseUnit});

  @override
  Widget build(BuildContext context) {
    const steps = [0.5, 1.0, 2.0, 4.0];
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: steps.map((mlhr) {
        final dose = mlhr * oneMlDose;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFFFCC80)),
          ),
          child: Text(
              '${_fmt(mlhr)} mL/hr → ${_fmt(dose, decimals: dose < 1 ? 3 : 2)} $doseUnit',
              style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFBF360C))),
        );
      }).toList(),
    );
  }
}

// ─── Infusion table view ────────────────────────────────────────────────────

class _InfusionTableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: _picuRed.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: _hdr('DRUG', cs)),
          Expanded(flex: 3, child: _hdr('DOSE RANGE', cs)),
          Expanded(flex: 4, child: _hdr('DRUG mL + DILUENT', cs)),
          Expanded(flex: 3, child: _hdr('1 mL/hr =', cs)),
        ],
      ),
    );
  }

  Widget _hdr(String s, ColorScheme cs) => Text(s,
      style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
          color: cs.onSurface.withValues(alpha: 0.65)));
}

class _InfusionTableRow extends StatelessWidget {
  final _InfusionDrug drug;
  final double? weight;
  final double multiplier;
  final double totalMl;
  const _InfusionTableRow({
    required this.drug,
    required this.weight,
    required this.multiplier,
    required this.totalMl,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final w = weight;
    final hasWt = w != null && w > 0;
    final unit = drug.name == 'Vasopressin' ? 'mIU' : 'mg';

    String dilution;
    String oneMl;
    if (hasWt) {
      final drugAmt = drug.dilutionMgPerKg * w * multiplier;
      final drugMl = drugAmt / drug.stockPerMl;
      final dilMl = totalMl - drugMl;
      dilution =
          '${_fmt(drugMl, decimals: 2)} mL + ${_fmt(dilMl, decimals: 2)} mL diluent';
      double oneMlDose;
      if (drug.doseUnit == 'µg/kg/min') {
        oneMlDose = (drugAmt * 1000.0 / totalMl) / 60.0 / w;
      } else if (drug.doseUnit == 'mIU/kg/min') {
        oneMlDose = (drugAmt / totalMl) / 60.0 / w;
      } else {
        oneMlDose = drug.oneMlPerHrDose * multiplier;
      }
      oneMl =
          '${_fmt(oneMlDose, decimals: oneMlDose < 1 ? 3 : 2)} ${drug.doseUnit}';
    } else {
      dilution =
          '${_fmt(drug.dilutionMgPerKg)} $unit/kg in ${_fmt(totalMl)} mL';
      oneMl = '${_fmt(drug.oneMlPerHrDose)} ${drug.doseUnit}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: cs.onSurface.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Text(drug.name,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700))),
          Expanded(
              flex: 3,
              child: Text(drug.doseRange,
                  style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurface.withValues(alpha: 0.85)))),
          Expanded(
              flex: 4,
              child: Text(dilution,
                  style: TextStyle(
                      fontSize: 10.5,
                      color: cs.onSurface.withValues(alpha: 0.85),
                      fontWeight:
                          hasWt ? FontWeight.w700 : FontWeight.w500))),
          Expanded(
              flex: 3,
              child: Text(oneMl,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFBF360C)))),
        ],
      ),
    );
  }
}

// ─── STAT bolus table view ──────────────────────────────────────────────────

class _BolusTable extends StatelessWidget {
  final double? weight;
  const _BolusTable({required this.weight});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final w = weight;
    final hasWt = w != null && w > 0;

    final rows = <Widget>[];
    rows.add(Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: _picuAccent.withValues(alpha: 0.10),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(9),
          topRight: Radius.circular(9),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 4, child: _hdr('DRUG · ROUTE')),
          Expanded(
              flex: 6,
              child: _hdr(hasWt
                  ? 'DOSE @ ${w.toStringAsFixed(2)} kg'
                  : 'PER-KG DOSE')),
          Expanded(flex: 3, child: _hdr('MAX')),
        ],
      ),
    ));

    for (final d in _bolusDrugs) {
      for (final r in d.rules) {
        String dose;
        if (hasWt) {
          final v = r.dosePerKg * w;
          if (r.unit == 'mL') {
            dose = '${_fmt(v)} mL of ${r.stockLabel}';
          } else if (r.concentration != null) {
            final ml = v / r.concentration!;
            dose =
                '${_fmt(v, decimals: 3)} ${r.unit}  (${_fmt(ml, decimals: 2)} mL)';
          } else {
            dose = '${_fmt(v, decimals: 3)} ${r.unit}';
          }
        } else {
          dose =
              '${_fmt(r.dosePerKg, decimals: r.dosePerKg < 0.01 ? 4 : 3)} ${r.unit}/kg';
        }
        rows.add(Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              bottom: BorderSide(
                  color: cs.onSurface.withValues(alpha: 0.08)),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.name,
                          style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 1),
                      Text(r.label,
                          style: TextStyle(
                              fontSize: 10,
                              color:
                                  cs.onSurface.withValues(alpha: 0.65))),
                    ],
                  )),
              Expanded(
                  flex: 6,
                  child: Text(dose,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: hasWt
                              ? FontWeight.w800
                              : FontWeight.w500,
                          color: hasWt
                              ? const Color(0xFFBF360C)
                              : cs.onSurface
                                  .withValues(alpha: 0.85)))),
              Expanded(
                  flex: 3,
                  child: Text(d.maxDose,
                      style: TextStyle(
                          fontSize: 10.5,
                          color:
                              cs.onSurface.withValues(alpha: 0.7)))),
            ],
          ),
        ));
      }
    }

    return Container(
      decoration: BoxDecoration(
        border:
            Border.all(color: cs.onSurface.withValues(alpha: 0.10)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: rows),
    );
  }

  Widget _hdr(String s) => Text(s,
      style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF8B0000),
          letterSpacing: 0.4));
}

// ─── Disclaimer ─────────────────────────────────────────────────────────────

class _Disclaimer extends StatelessWidget {
  const _Disclaimer();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.12)),
      ),
      child: Text(
        'PICU Emergency Drugs calculator. For use by qualified clinicians '
        'only — verify every dose against local protocol and current vial '
        'concentration before administration.',
        style: TextStyle(
            fontSize: 11,
            color: cs.onSurface.withValues(alpha: 0.7),
            height: 1.45),
      ),
    );
  }
}
