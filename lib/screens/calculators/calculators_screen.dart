// =============================================================================
// lib/screens/calculators/calculators_screen.dart
//
// Hub of every calculator + small clinical-tool screen in the app.
//
// Filter chips at the top let the user slice the flat list by clinical
// context (NICU / PICU & Emergency / Fluids & Electrolytes / Cardiac &
// Echo / Respiratory / Burns / Procedures). Each calculator carries
// `categories: List<String>` — many are tagged with two or three
// categories (e.g. ETT lives in NICU + PICU & Emergency + Respiratory
// + Procedures). Tap "All" to see everything.
//
// Single-select filter — minimal state, matches how clinicians scan
// during rounds. The selected chip is highlighted; an "Items" badge
// at the right of the chip strip shows the filtered count.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'blood_gas_analyser.dart';
import 'double_volume_exchange.dart';
import 'ventilator_parameters.dart';
import 'ponderal_index_calculator.dart';
import 'bsa_calculator.dart';
import 'nutritional_audit_calculator.dart';
import 'tpn_calculator.dart';
import 'cga_pma_calculator.dart';
import 'gir_calculator.dart';
import 'schwartz_egfr_calculator.dart';
import 'gestational_age_calculator.dart';
import 'maintenance_fluid_calculator.dart';
import 'parkland_calculator_screen.dart';
import 'lund_browder_screen.dart';
import 'burn_mortality_calculator.dart';
import 'pet_calculator_screen.dart';
import 'echo_calculators_screen.dart';
import 'anion_gap_calculator.dart';
import 'blood_volume_calculator.dart';
import 'serum_osmolality_calculator.dart';
import 'corrected_sodium_calculator.dart';
import 'urine_anion_gap_calculator.dart';
import 'corrected_anion_gap_calculator.dart';
import 'free_water_deficit_calculator.dart';
import 'sodium_correction_calculator.dart';
import 'potassium_correction_calculator.dart';
import 'calcium_correction_calculator.dart';
import 'magnesium_correction_calculator.dart';
import 'phosphate_correction_calculator.dart';
import 'dextrose_bolus_calculator.dart';
import 'umbilical_catheter_calculator.dart';
import 'ett_calculator.dart';
import 'mid_parental_height_calculator.dart';
import 'new_clinical_calculators.dart';
import 'converter_calculators.dart';
import 'remaining_calculators.dart';
import '../guides/gcs_screen.dart';
import '../../widgets/tool_gate.dart';

// ── Category catalogue ──────────────────────────────────────────────────────
//
// Order here drives chip-strip order. "All" is special — it bypasses the
// filter. Add a new category by adding a string to this list AND tagging
// at least one calculator with it.

const String _kAll = 'All';
const String _kNICU = 'NICU';
const String _kPICU = 'PICU & Emergency';
const String _kFluids = 'Fluids & Lytes';
const String _kCardiac = 'Cardiac & Echo';
const String _kResp = 'Respiratory';
const String _kBurns = 'Burns';
const String _kProc = 'Procedures';
const String _kHeme = 'Haematology';
const String _kRenal = 'Renal';
const String _kGI = 'GI & Liver';
const String _kEndo = 'Endocrine';
const String _kNeuro = 'Neurology';
const String _kTox = 'Toxicology';
const String _kGrowth = 'Growth';
const String _kLabs = 'Labs & Conversions';

const List<String> _kCategories = [
  _kAll,
  _kNICU,
  _kPICU,
  _kFluids,
  _kCardiac,
  _kResp,
  _kBurns,
  _kProc,
  _kHeme,
  _kRenal,
  _kGI,
  _kEndo,
  _kNeuro,
  _kTox,
  _kGrowth,
  _kLabs,
];

/// Which slice of the catalogue a CalculatorsScreen shows.
enum CalculatorScope {
  /// Every calculator (legacy behaviour — used by search/deep-links).
  all,

  /// NICU / neonatal tools only, shown as a plain list.
  neonatal,

  /// Everything else, with the by-system ⇄ A–Z sort toggle.
  paediatric,
}

class CalculatorsScreen extends StatefulWidget {
  final CalculatorScope scope;
  const CalculatorsScreen({super.key, this.scope = CalculatorScope.all});

  @override
  State<CalculatorsScreen> createState() => _CalculatorsScreenState();
}

class _CalculatorsScreenState extends State<CalculatorsScreen> {
  String _selected = _kAll;

  /// Paediatric hub only: false = grouped by system chips, true = flat A–Z.
  bool _azMode = false;

  /// Free-text filter, shown whenever the scoped list is long.
  String _query = '';

  static const List<_CalculatorItem> _calculators = [
    _CalculatorItem(
      title: 'Gestational Age & EDD',
      subtitle: 'EDD, GA & Antenatal Dates',
      icon: Icons.pregnant_woman_outlined,
      categories: [_kNICU],
      scope: ToolScope.neonatal,
    ),
    _CalculatorItem(
      title: 'Ponderal Index',
      subtitle: 'IUGR & nutritional status',
      icon: Icons.child_care,
      categories: [_kNICU],
      scope: ToolScope.neonatal,
    ),
    _CalculatorItem(
      title: 'Mid-Parental Height',
      subtitle: 'Genetic target height & range',
      icon: Icons.height_rounded,
      categories: [_kNICU],
    ),
    _CalculatorItem(
      title: 'Body Surface Area',
      subtitle: 'Mosteller formula',
      icon: Icons.person_outlined,
      categories: [_kBurns],
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'Nutritional Audit',
      subtitle: 'ESPGHAN 2022',
      icon: Icons.local_dining,
      categories: [_kNICU],
      scope: ToolScope.neonatal,
    ),
    _CalculatorItem(
      title: 'TPN Calculator',
      subtitle: 'Stock & multi-line TPN',
      iosHidden: true,
      icon: Icons.medical_services,
      categories: [_kNICU, _kFluids],
      scope: ToolScope.neonatal,
    ),
    _CalculatorItem(
      title: 'CGA / PMA Calculator',
      subtitle: 'Age correction',
      icon: Icons.calendar_month,
      categories: [_kNICU],
      scope: ToolScope.neonatal,
    ),
    _CalculatorItem(
      title: 'GIR Calculator',
      subtitle: 'Glucose infusion rate',
      iosHidden: true,
      icon: Icons.water_drop,
      categories: [_kNICU, _kFluids],
      scope: ToolScope.neonatal,
    ),
    _CalculatorItem(
      title: 'Schwartz eGFR',
      subtitle: 'Creatinine clearance',
      icon: Icons.monitor_heart,
      categories: [_kPICU, _kFluids],
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'Blood Gas Analyser',
      iosHidden: true,
      subtitle: '7-step interpretation',
      icon: Icons.air,
      categories: [_kPICU, _kResp, _kFluids],
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'DVET Calculator',
      subtitle: 'Exchange transfusion',
      iosHidden: true,
      icon: Icons.water_drop,
      categories: [_kNICU, _kProc],
      scope: ToolScope.neonatal,
    ),
    _CalculatorItem(
      title: 'Ventilator Parameters',
      subtitle: 'OI, OSI, MAP, HFOV',
      icon: Icons.monitor_heart,
      categories: [_kResp, _kPICU, _kNICU],
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'BPD Estimator',
      subtitle: 'Bronchopulmonary Dysplasia — NICHD Neonatal Research Network',
      icon: Icons.air,
      categories: [_kNICU, _kResp],
      scope: ToolScope.neonatal,
    ),
    // Blood Pressure + Neonatal Jaundice moved to Graphs & Charts only
    // (cards 5 & 6 there → BPHubScreen / JaundiceHubScreen) — they are chart
    // tools, so per Sunil they live under Charts, not Calculators.
    _CalculatorItem(
      title: 'Maintenance Fluids',
      subtitle: 'Neonatal & Paediatric Fluid Calculator',
      iosHidden: true,
      icon: Icons.local_drink_outlined,
      categories: [_kFluids, _kPICU, _kNICU],
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'Parkland Formula',
      subtitle: 'Burns Fluid Resuscitation',
      iosHidden: true,
      icon: Icons.local_fire_department_outlined,
      categories: [_kBurns, _kFluids, _kPICU],
    ),
    _CalculatorItem(
      title: 'Lund & Browder Chart',
      subtitle: 'Burn Surface Area Estimation',
      icon: Icons.person_outlined,
      categories: [_kBurns],
    ),
    _CalculatorItem(
      title: 'Burn Mortality',
      subtitle: 'Revised Baux Score',
      icon: Icons.monitor_heart_rounded,
      categories: [_kBurns],
    ),
    _CalculatorItem(
      title: 'PET Calculator',
      subtitle: 'Partial Exchange Transfusion — Polycythemia',
      iosHidden: true,
      icon: Icons.bloodtype_outlined,
      categories: [_kNICU, _kProc],
      scope: ToolScope.neonatal,
    ),
    _CalculatorItem(
      title: '2D Echo Calculators',
      subtitle: 'LVO · RVO · PAPSp · EF · LA/Ao · IVC',
      icon: Icons.monitor_heart,
      categories: [_kCardiac, _kNICU],
      scope: ToolScope.neonatal,
    ),
    // ── Fluid & electrolyte (an internal reference compendium set) ────────
    _CalculatorItem(
      title: 'Anion Gap',
      subtitle: 'Na − (HCO₃ + Cl) — HAGMA workup',
      icon: Icons.science_outlined,
      categories: [_kFluids, _kPICU],
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'Corrected AG (Albumin)',
      subtitle: 'AG + 2.5 × (Normal − Albumin)',
      icon: Icons.science_outlined,
      categories: [_kFluids, _kPICU],
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'Urine Anion Gap',
      subtitle: 'RTA vs diarrhoea',
      icon: Icons.water_drop_outlined,
      categories: [_kFluids],
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'Serum Osmolality',
      subtitle: '2Na + Glu/18 + BUN/2.8',
      icon: Icons.science,
      categories: [_kFluids],
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'Corrected Na (hyperglycaemia)',
      subtitle: 'Na + 1.6 × ((Glucose − 100)/100)',
      icon: Icons.calculate_outlined,
      categories: [_kFluids],
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'Blood Volume',
      subtitle: 'EBV by age band',
      icon: Icons.bloodtype_outlined,
      categories: [_kNICU, _kPICU],
      scope: ToolScope.both,
    ),
    // ── Electrolyte correction calculators ────────────────────────────
    _CalculatorItem(
      title: 'Free Water Deficit (↑Na)',
      subtitle: 'Hypernatraemia correction',
      iosHidden: true,
      icon: Icons.opacity_outlined,
      categories: [_kFluids],
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'Na Correction (↓Na)',
      subtitle: 'Sodium deficit + 3 % saline bolus',
      iosHidden: true,
      icon: Icons.calculate,
      categories: [_kFluids, _kPICU],
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'K Correction (↓/↑K)',
      subtitle: 'KCl replacement OR ↑K regimen',
      icon: Icons.calculate,
      categories: [_kFluids, _kPICU],
      iosHidden: true,
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'Calcium Correction (↓Ca)',
      subtitle: 'CaCl₂ / gluconate / MgSO₄',
      icon: Icons.calculate,
      categories: [_kFluids, _kPICU],
      iosHidden: true,
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'Magnesium Correction (↓Mg)',
      subtitle: 'MgSO₄ IV + oral',
      icon: Icons.calculate,
      categories: [_kFluids],
      iosHidden: true,
      scope: ToolScope.both,
    ),
    // Phosphate Correction — hidden for now (per request); re-enable by
    // uncommenting. Route + import below are kept so it re-enables cleanly.
    // _CalculatorItem(
    //   title: 'Phosphate Correction (↓PO₄)',
    //   subtitle: 'NaPhos / KPhos / oral',
    //   icon: Icons.calculate,
    //   categories: [_kFluids],
    //   iosHidden: true,
    // ),
    _CalculatorItem(
      title: 'Hypoglycaemia Bolus',
      subtitle: 'D10/D25/D50 + GIR + adjuncts',
      icon: Icons.calculate,
      categories: [_kNICU, _kPICU],
      iosHidden: true,
      scope: ToolScope.both,
    ),
    // ── Neuro scoring (PIC) ───────────────────────────────────────────
    _CalculatorItem(
      title: 'Glasgow Coma Scale',
      iosHidden: true,
      subtitle: 'Smart paediatric scorer',
      icon: Icons.psychology_outlined,
      categories: [_kPICU],
    ),
    // ── Procedural / airway / lines ──────────────────────────────────
    _CalculatorItem(
      title: 'UVC / UAC Depth',
      subtitle: 'Shukla / Dunn formulas + stump',
      icon: Icons.usb_outlined,
      categories: [_kNICU, _kProc],
      scope: ToolScope.neonatal,
    ),
    _CalculatorItem(
      title: 'ETT Size + Depth',
      subtitle: 'NTL+1 · weight · age-based · tube×3',
      icon: Icons.air_outlined,
      categories: [_kNICU, _kPICU, _kResp, _kProc],
      scope: ToolScope.both,
    ),
    // ── New clinical calculators (2026-08) ───────────────────────────
    _CalculatorItem(
      title: 'Weight Velocity',
      subtitle: 'g/kg/day gain or loss between two weights',
      icon: Icons.trending_up_rounded,
      categories: [_kNICU, _kGrowth],
    ),
    _CalculatorItem(
      title: 'Absolute Counts (ANC / AEC / ALC)',
      subtitle: 'Neutrophil · eosinophil · lymphocyte counts',
      icon: Icons.science_outlined,
      categories: [_kHeme],
    ),
    _CalculatorItem(
      title: 'Mentzer Index',
      subtitle: 'Iron deficiency vs β-thalassaemia trait',
      icon: Icons.bloodtype_outlined,
      categories: [_kHeme],
    ),
    _CalculatorItem(
      title: 'Corrected QT (QTc)',
      subtitle: 'Bazett heart-rate correction',
      icon: Icons.monitor_heart_outlined,
      categories: [_kCardiac],
    ),
    _CalculatorItem(
      title: 'Fractional Excretion of Na (FeNa)',
      subtitle: 'Pre-renal vs intrinsic AKI',
      icon: Icons.water_drop_outlined,
      categories: [_kRenal, _kFluids],
    ),
    _CalculatorItem(
      title: 'APRI (AST-to-Platelet Ratio)',
      subtitle: 'Non-invasive liver fibrosis marker',
      icon: Icons.analytics_outlined,
      categories: [_kGI],
    ),
    _CalculatorItem(
      title: 'FIB-4 Index',
      subtitle: 'Age · AST · ALT · platelets fibrosis index',
      icon: Icons.analytics_outlined,
      categories: [_kGI],
    ),
    _CalculatorItem(
      title: 'PELD / MELD Score',
      subtitle: 'Liver-disease severity for transplant',
      icon: Icons.local_hospital_outlined,
      categories: [_kGI],
    ),
    _CalculatorItem(
      title: 'HbA1c → eAG',
      subtitle: 'Estimated average glucose',
      icon: Icons.speed_outlined,
      categories: [_kEndo],
    ),
    _CalculatorItem(
      title: 'CSF WBC Correction',
      subtitle: 'Traumatic-tap blood-contamination correction',
      icon: Icons.biotech_outlined,
      categories: [_kNeuro],
    ),
    _CalculatorItem(
      title: 'Paracetamol Toxicity + NAC',
      subtitle: 'Rumack-Matthew nomogram + NAC dosing',
      icon: Icons.medication_liquid_outlined,
      categories: [_kTox, _kPICU],
    ),
    _CalculatorItem(
      title: 'Body Mass Index (BMI)',
      subtitle: 'BMI — plot on BMI-for-age chart',
      icon: Icons.straighten_outlined,
      categories: [_kGrowth],
    ),
    _CalculatorItem(
      title: 'Steroid Converter',
      subtitle: 'Equivalent glucocorticoid doses',
      icon: Icons.swap_vert_circle_outlined,
      categories: [_kLabs, _kEndo],
    ),
    _CalculatorItem(
      title: 'A–a Gradient',
      subtitle: 'Alveolar–arterial oxygen gradient',
      icon: Icons.air_outlined,
      categories: [_kPICU, _kResp],
    ),
    _CalculatorItem(
      title: 'Cerebral Perfusion Pressure',
      subtitle: 'CPP = MAP − ICP · age-based targets',
      icon: Icons.psychology_outlined,
      categories: [_kPICU, _kNeuro],
    ),
    _CalculatorItem(
      title: 'Henderson-Hasselbalch',
      subtitle: 'pH from HCO₃⁻ and PaCO₂',
      icon: Icons.functions_outlined,
      categories: [_kPICU, _kFluids],
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'Total Body Water',
      subtitle: 'Age-based TBW estimate',
      icon: Icons.water_outlined,
      categories: [_kFluids, _kPICU],
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'Urine Output & Fluid Balance',
      subtitle: 'mL/kg/h with oliguria thresholds',
      icon: Icons.opacity_outlined,
      categories: [_kRenal, _kFluids],
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'Predicted PEFR',
      subtitle: 'Height-based peak flow + % predicted',
      icon: Icons.speed_outlined,
      categories: [_kResp],
    ),
    _CalculatorItem(
      title: 'Cardiac Output (Fick)',
      subtitle: 'VO₂ and A–V O₂ difference',
      icon: Icons.monitor_heart_outlined,
      categories: [_kCardiac, _kPICU],
    ),
    _CalculatorItem(
      title: 'Mean Arterial Pressure',
      subtitle: 'MAP + pulse pressure',
      icon: Icons.favorite_outline,
      categories: [_kCardiac, _kPICU],
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'Fractional Excretion of Mg',
      subtitle: 'Renal vs extra-renal Mg loss',
      icon: Icons.science_outlined,
      categories: [_kRenal, _kFluids],
    ),
    _CalculatorItem(
      title: 'Reticulocyte Count / RPI',
      subtitle: 'Absolute · corrected · production index',
      icon: Icons.bloodtype_outlined,
      categories: [_kHeme],
    ),
    _CalculatorItem(
      title: 'Cryoprecipitate Dosing',
      subtitle: 'Fibrinogen replacement',
      icon: Icons.water_drop_outlined,
      categories: [_kHeme],
    ),
    _CalculatorItem(
      title: 'Ideal Body Weight',
      subtitle: 'Traub-Johnson IBW + adjusted weight',
      icon: Icons.straighten_outlined,
      categories: [_kGrowth],
    ),
    _CalculatorItem(
      title: 'BMR / Energy Requirement',
      subtitle: 'Schofield equations',
      icon: Icons.local_fire_department_outlined,
      categories: [_kGrowth],
    ),
    _CalculatorItem(
      title: 'Total Iron Deficit',
      subtitle: 'Ganzoni formula',
      icon: Icons.medication_outlined,
      categories: [_kHeme, _kLabs],
    ),
    _CalculatorItem(
      title: 'IV Drip Rate',
      subtitle: 'mL/hour and drops/minute',
      icon: Icons.water_drop_outlined,
      categories: [_kFluids],
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'Calcium Salt Equivalents',
      subtitle: 'Gluconate ↔ chloride',
      icon: Icons.swap_horiz_outlined,
      categories: [_kFluids, _kLabs],
      scope: ToolScope.both,
    ),
    _CalculatorItem(
      title: 'Unit Converter',
      subtitle: 'SI · mg/dL ↔ mmol/L · °C↔°F · kg↔lb',
      icon: Icons.swap_horiz_outlined,
      categories: [_kLabs],
      scope: ToolScope.both,
    ),
  ];

  // All calculators show on every platform now, including the dose tools that
  // were hidden on iOS. Medical dose references are permitted on the App Store
  // when they cite their sources (these do), and Sunil chose to keep the full
  // app on iOS. The `iosHidden` flags on individual items are left in place,
  // unused, so the decision is one line to reverse if it ever needs to be.
  List<_CalculatorItem> get _visible {
    switch (widget.scope) {
      case CalculatorScope.neonatal:
        return _calculators
            .where(
              (c) => c.scope == ToolScope.neonatal || c.scope == ToolScope.both,
            )
            .toList();
      case CalculatorScope.paediatric:
        return _calculators
            .where(
              (c) =>
                  c.scope == ToolScope.paediatric || c.scope == ToolScope.both,
            )
            .toList();
      case CalculatorScope.all:
        return _calculators;
    }
  }

  /// Chips are BODY SYSTEMS only. NICU/PICU describe the care setting, not a
  /// system, so they are never offered as filters inside a scoped hub — that
  /// is what previously showed "PICU & Emergency" under Neonatal Calculators.
  List<String> get _chipCategories {
    final present = <String>{
      for (final c in _visible)
        ...c.categories.where((k) => k != _kNICU && k != _kPICU),
    };
    final ordered = _kCategories.where(
      (k) => k != _kNICU && k != _kPICU && present.contains(k),
    );
    return [_kAll, ...ordered];
  }

  /// With few tools, or only one system, the chip strip is noise.
  bool get _showChips => _chipCategories.length > 3;

  String get _screenTitle {
    switch (widget.scope) {
      case CalculatorScope.neonatal:
        return 'Neonatal Calculators';
      case CalculatorScope.paediatric:
        return 'Paediatric Calculators';
      case CalculatorScope.all:
        return 'Calculators & Tools';
    }
  }

  /// True when the by-system ⇄ A–Z control should be offered (paediatric only).
  bool get _showSort => widget.scope == CalculatorScope.paediatric;

  List<_CalculatorItem> get _filteredSorted {
    // In A–Z mode the chip strip is hidden, so the category selection must NOT
    // still be applied — otherwise the flat list silently shows only the last
    // selected system instead of everything in scope.
    var list = (_showSort && _azMode) ? _visible : _filtered;
    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where(
            (c) =>
                c.title.toLowerCase().contains(q) ||
                c.subtitle.toLowerCase().contains(q) ||
                c.categories.any((k) => k.toLowerCase().contains(q)),
          )
          .toList();
    }
    if (_showSort && _azMode) {
      return [...list]..sort((a, b) => a.title.compareTo(b.title));
    }
    return list;
  }

  /// A search box earns its place once the list is long enough to scroll.
  bool get _showSearch => _visible.length > 8;

  Widget _buildSearchBar() {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        onChanged: (v) => setState(() => _query = v),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search ${_visible.length} calculators…',
          prefixIcon: const Icon(Icons.search, size: 20),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.outline.withValues(alpha: 0.3)),
          ),
        ),
      ),
    );
  }

  List<_CalculatorItem> get _filtered => _selected == _kAll
      ? _visible
      : _visible.where((c) => c.categories.contains(_selected)).toList();

  int _countFor(String category) {
    if (category == _kAll) return _visible.length;
    return _visible.where((c) => c.categories.contains(category)).length;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredSorted;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(_screenTitle),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: SafeArea(
        bottom: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            final cols = isWide ? 3 : 2;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_showSearch) _buildSearchBar(),
                    if (_showSort) _buildSortToggle(),
                    if (_showChips && !(_showSort && _azMode))
                      _CategoryChipBar(
                        categories: _chipCategories,
                        selected: _selected,
                        countFor: _countFor,
                        onSelect: (c) => setState(() => _selected = c),
                      ),
                    Expanded(
                      child: filtered.isEmpty
                          ? const _EmptyState()
                          : GridView.builder(
                              padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                              itemCount: filtered.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: cols,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    mainAxisExtent: 150,
                                  ),
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                return _CalculatorCard(
                                  item: item,
                                  onTap: () => _navigate(context, item.title),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String title) {
    // The BPD estimator is an external tool, not a screen.
    if (title == 'BPD Estimator') {
      launchUrl(
        Uri.parse(
          'https://neonatal.rti.org/index.cfm?fuseaction=BPD_Calculator2.start',
        ),
        mode: LaunchMode.externalApplication,
      );
      return;
    }
    final screen = calculatorScreenFor(title);
    if (screen == null) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  /// Paediatric hub: switch between system-grouped chips and a flat A–Z list.
  Widget _buildSortToggle() {
    final cs = Theme.of(context).colorScheme;
    Widget btn(String label, bool active, VoidCallback onTap) => Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? cs.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: active
                  ? cs.onPrimary
                  : cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          children: [
            btn('By system', !_azMode, () => setState(() => _azMode = false)),
            const SizedBox(width: 4),
            btn('A–Z', _azMode, () => setState(() => _azMode = true)),
          ],
        ),
      ),
    );
  }
}

// ── Reusable category-chip strip (also used by GuidesScreen) ────────────────

class _CategoryChipBar extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final int Function(String) countFor;
  final ValueChanged<String> onSelect;
  const _CategoryChipBar({
    required this.categories,
    required this.selected,
    required this.countFor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // One horizontally-scrolling row instead of a Wrap: the Wrap spilled the
    // categories over ~4 lines and ate a third of the screen before the grid.
    // A single scroll strip keeps the filter to one row's height.
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          children: [
            for (int i = 0; i < categories.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              _chip(
                cs,
                label: categories[i],
                count: countFor(categories[i]),
                selected: categories[i] == selected,
                onTap: () => onSelect(categories[i]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _chip(
    ColorScheme cs, {
    required String label,
    required int count,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? cs.primary
              : cs.surfaceContainerHighest.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? cs.primary
                : cs.outlineVariant.withValues(alpha: 0.45),
            width: selected ? 1 : 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: selected ? cs.onPrimary : cs.onSurface,
                letterSpacing: 0.05,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: selected
                    ? cs.onPrimary.withValues(alpha: 0.20)
                    : cs.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: selected ? cs.onPrimary : cs.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.filter_alt_off_outlined,
            size: 48,
            color: cs.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(
            'Nothing in this category yet.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculatorCard extends StatelessWidget {
  final _CalculatorItem item;
  final VoidCallback onTap;

  const _CalculatorCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: primary, size: 22),
              ),
              const Spacer(),
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                item.title,
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                item.subtitle,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.65),
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Age/setting scope — kept SEPARATE from `categories`, which describe the
/// BODY SYSTEM. Mixing the two (NICU/PICU alongside Fluids/Cardiac) is what
/// previously leaked neonatal tools into the paediatric hub and vice versa.
enum ToolScope { neonatal, paediatric, both }

/// Public projection of a calculator entry — the private [_CalculatorItem]
/// carries grid-only concerns (categories, iOS gating) that shortcuts and
/// Recents have no use for.
class CalculatorCatalogEntry {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool neonatal;

  const CalculatorCatalogEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.neonatal,
  });
}

class _CalculatorItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> categories;
  final bool iosHidden;
  final ToolScope scope;

  const _CalculatorItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.categories,
    this.iosHidden = false,
    this.scope = ToolScope.paediatric,
  });
}

// ── Public catalogue & resolver (used by ToolRegistry) ──────────────────────
/// Every calculator that has an in-app screen, as plain data. The tool
/// registry builds shortcuts from this, so anything reachable from the grid
/// can also be pinned to Quick Access or land in Recents.
final List<CalculatorCatalogEntry> calculatorCatalogue = _CalculatorsScreenState
    ._calculators
    .where((c) => calculatorScreenFor(c.title) != null)
    .map(
      (c) => CalculatorCatalogEntry(
        title: c.title,
        subtitle: c.subtitle,
        icon: c.icon,
        neonatal: c.scope != ToolScope.paediatric,
      ),
    )
    .toList(growable: false);

/// Screen for a calculator title, or null when the title has no in-app
/// screen (external links) or is unknown. One source of truth shared by
/// the grid, Recents and Quick Access, so a tool reachable from the grid
/// is automatically reachable from a shortcut.
Widget? calculatorScreenFor(String title) {
  switch (title) {
    case 'Gestational Age & EDD':
      return ToolGate(toolId: 'ga', child: const GestationalAgeCalculator());
    case 'Ponderal Index':
      return ToolGate(
        toolId: 'ponderal',
        child: const PonderalIndexCalculator(),
      );
    case 'Mid-Parental Height':
      return ToolGate(
        toolId: 'mph',
        child: const MidParentalHeightCalculator(),
      );
    case 'Body Surface Area':
      return ToolGate(toolId: 'bsa', child: const BSACalculator());
    case 'Nutritional Audit':
      return ToolGate(
        toolId: 'nutri',
        child: const NutritionalAuditCalculator(),
      );
    case 'TPN Calculator':
      return ToolGate(toolId: 'tpn', child: const TpnCalculator());
    case 'CGA / PMA Calculator':
      return ToolGate(toolId: 'cga', child: const CGAPMACalculator());
    case 'GIR Calculator':
      return ToolGate(toolId: 'gir', child: const GIRCalculator());
    case 'Schwartz eGFR':
      return ToolGate(toolId: 'egfr', child: const SchwartzEGFRCalculator());
    case 'Blood Gas Analyser':
      return ToolGate(toolId: 'gas', child: const BloodGasAnalyser());
    case 'DVET Calculator':
      return ToolGate(toolId: 'dve', child: const DoubleVolumeExchange());
    case 'Ventilator Parameters':
      return ToolGate(toolId: 'vent', child: const VentilatorParameters());
    case 'Maintenance Fluids':
      return ToolGate(
        toolId: 'fluid',
        child: const MaintenanceFluidCalculator(),
      );
    case 'Parkland Formula':
      return ToolGate(
        toolId: 'parkland',
        child: const ParklandCalculatorScreen(),
      );
    case 'Lund & Browder Chart':
      return ToolGate(toolId: 'lund', child: const LundBrowderScreen());
    case 'Burn Mortality':
      return ToolGate(toolId: 'burn', child: const BurnMortalityCalculator());
    case 'PET Calculator':
      return ToolGate(toolId: 'pet', child: const PETCalculatorScreen());
    case '2D Echo Calculators':
      return ToolGate(toolId: 'echo', child: const EchoCalculatorsScreen());
    case 'Anion Gap':
      return ToolGate(toolId: 'anion-gap', child: const AnionGapCalculator());
    case 'Corrected AG (Albumin)':
      return const CorrectedAnionGapCalculator();
    case 'Urine Anion Gap':
      return ToolGate(
        toolId: 'urine-anion-gap',
        child: const UrineAnionGapCalculator(),
      );
    case 'Serum Osmolality':
      return ToolGate(
        toolId: 'serum-osmolality',
        child: const SerumOsmolalityCalculator(),
      );
    case 'Corrected Na (hyperglycaemia)':
      return ToolGate(
        toolId: 'corrected-sodium',
        child: const CorrectedSodiumCalculator(),
      );
    case 'Blood Volume':
      return ToolGate(
        toolId: 'blood-volume',
        child: const BloodVolumeCalculator(),
      );
    case 'Free Water Deficit (↑Na)':
      return ToolGate(
        toolId: 'free-water-deficit',
        child: const FreeWaterDeficitCalculator(),
      );
    case 'Na Correction (↓Na)':
      return ToolGate(
        toolId: 'sodium-correction',
        child: const SodiumCorrectionCalculator(),
      );
    case 'K Correction (↓/↑K)':
      return const PotassiumCorrectionCalculator();
    case 'Calcium Correction (↓Ca)':
      return const CalciumCorrectionCalculator();
    case 'Magnesium Correction (↓Mg)':
      return const MagnesiumCorrectionCalculator();
    case 'Phosphate Correction (↓PO₄)':
      return const PhosphateCorrectionCalculator();
    case 'Hypoglycaemia Bolus':
      return ToolGate(
        toolId: 'dextrose-bolus',
        child: const DextroseBolusCalculator(),
      );
    case 'Glasgow Coma Scale':
      return ToolGate(toolId: 'gcs', child: const GcsScreen());
    case 'UVC / UAC Depth':
      return const UmbilicalCatheterCalculator();
    case 'ETT Size + Depth':
      return ToolGate(toolId: 'ett', child: const EttCalculator());
    case 'Weight Velocity':
      return const WeightVelocityCalculator();
    case 'Absolute Counts (ANC / AEC / ALC)':
      return const AbsoluteCountsCalculator();
    case 'Mentzer Index':
      return const MentzerIndexCalculator();
    case 'Corrected QT (QTc)':
      return const QtcCalculator();
    case 'Fractional Excretion of Na (FeNa)':
      return const FenaCalculator();
    case 'APRI (AST-to-Platelet Ratio)':
      return const ApriCalculator();
    case 'FIB-4 Index':
      return const Fib4Calculator();
    case 'PELD / MELD Score':
      return const PeldMeldCalculator();
    case 'HbA1c → eAG':
      return const HbA1cEagCalculator();
    case 'CSF WBC Correction':
      return const CsfWbcCorrectionCalculator();
    case 'Paracetamol Toxicity + NAC':
      return const ParacetamolCalculator();
    case 'Body Mass Index (BMI)':
      return const BmiCalculator();
    case 'Steroid Converter':
      return const SteroidConverter();
    case 'A–a Gradient':
      return const AaGradientCalculator();
    case 'Cerebral Perfusion Pressure':
      return const CppCalculator();
    case 'Henderson-Hasselbalch':
      return const HendersonHasselbalchCalculator();
    case 'Total Body Water':
      return const TotalBodyWaterCalculator();
    case 'Urine Output & Fluid Balance':
      return const UrineOutputCalculator();
    case 'Predicted PEFR':
      return const PefrPredictedCalculator();
    case 'Cardiac Output (Fick)':
      return const FickCardiacOutputCalculator();
    case 'Mean Arterial Pressure':
      return const MapCalculator();
    case 'Fractional Excretion of Mg':
      return const FeMgCalculator();
    case 'Reticulocyte Count / RPI':
      return const ReticulocyteCalculator();
    case 'Cryoprecipitate Dosing':
      return const CryoprecipitateCalculator();
    case 'Ideal Body Weight':
      return const IdealBodyWeightCalculator();
    case 'BMR / Energy Requirement':
      return const BmrCalculator();
    case 'Total Iron Deficit':
      return const IronDeficitCalculator();
    case 'IV Drip Rate':
      return const InfusionRateCalculator();
    case 'Calcium Salt Equivalents':
      return const CalciumEquivalentCalculator();
    case 'Unit Converter':
      return const UnitConverter();
  }
  return null;
}
