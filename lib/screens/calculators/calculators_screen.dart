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
import 'bp_hub_screen.dart';
import 'jaundice_hub_screen.dart';
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
import '../guides/gcs_screen.dart';

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

const List<String> _kCategories = [
  _kAll, _kNICU, _kPICU, _kFluids, _kCardiac, _kResp, _kBurns, _kProc,
];

class CalculatorsScreen extends StatefulWidget {
  const CalculatorsScreen({super.key});

  @override
  State<CalculatorsScreen> createState() => _CalculatorsScreenState();
}

class _CalculatorsScreenState extends State<CalculatorsScreen> {
  String _selected = _kAll;

  static const List<_CalculatorItem> _calculators = [
    _CalculatorItem(
      title: 'Gestational Age & EDD',
      subtitle: 'EDD, GA & Antenatal Dates',
      icon: Icons.pregnant_woman_outlined,
      categories: [_kNICU],
    ),
    _CalculatorItem(
      title: 'Ponderal Index',
      subtitle: 'IUGR & nutritional status',
      icon: Icons.child_care,
      categories: [_kNICU],
    ),
    _CalculatorItem(
      title: 'Body Surface Area',
      subtitle: 'Mosteller formula',
      icon: Icons.person_outlined,
      categories: [_kBurns],
    ),
    _CalculatorItem(
      title: 'Nutritional Audit',
      subtitle: 'ESPGHAN 2022',
      icon: Icons.local_dining,
      categories: [_kNICU],
    ),
    _CalculatorItem(
      title: 'TPN Calculator',
      subtitle: 'Stock & multi-line TPN',
      icon: Icons.medical_services,
      categories: [_kNICU, _kFluids],
    ),
    _CalculatorItem(
      title: 'CGA / PMA Calculator',
      subtitle: 'Age correction',
      icon: Icons.calendar_month,
      categories: [_kNICU],
    ),
    _CalculatorItem(
      title: 'GIR Calculator',
      subtitle: 'Glucose infusion rate',
      icon: Icons.water_drop,
      categories: [_kNICU, _kFluids],
    ),
    _CalculatorItem(
      title: 'Schwartz eGFR',
      subtitle: 'Creatinine clearance',
      icon: Icons.monitor_heart,
      categories: [_kPICU, _kFluids],
    ),
    _CalculatorItem(
      title: 'Blood Gas Analyser',
      subtitle: '7-step interpretation',
      icon: Icons.air,
      categories: [_kPICU, _kResp, _kFluids],
    ),
    _CalculatorItem(
      title: 'DVET Calculator',
      subtitle: 'Exchange transfusion',
      icon: Icons.water_drop,
      categories: [_kNICU, _kProc],
    ),
    _CalculatorItem(
      title: 'Ventilator Parameters',
      subtitle: 'OI, OSI, MAP, HFOV',
      icon: Icons.monitor_heart,
      categories: [_kResp, _kPICU, _kNICU],
    ),
    _CalculatorItem(
      title: 'BPD Estimator',
      subtitle: 'Bronchopulmonary Dysplasia — NICHD Neonatal Research Network',
      icon: Icons.air,
      categories: [_kNICU, _kResp],
    ),
    _CalculatorItem(
      title: 'Blood Pressure',
      subtitle: 'Neonatal & Paediatric BP',
      icon: Icons.favorite_rounded,
      categories: [_kCardiac, _kPICU, _kNICU],
    ),
    _CalculatorItem(
      title: 'Neonatal Jaundice',
      subtitle: 'AAP 2022 Bilirubin Tool',
      icon: Icons.opacity_rounded,
      categories: [_kNICU],
    ),
    _CalculatorItem(
      title: 'Maintenance Fluids',
      subtitle: 'Neonatal & Paediatric Fluid Calculator',
      icon: Icons.local_drink_outlined,
      categories: [_kFluids, _kPICU, _kNICU],
    ),
    _CalculatorItem(
      title: 'Parkland Formula',
      subtitle: 'Burns Fluid Resuscitation',
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
      icon: Icons.bloodtype_outlined,
      categories: [_kNICU, _kProc],
    ),
    _CalculatorItem(
      title: '2D Echo Calculators',
      subtitle: 'LVO · RVO · PAPSp · EF · LA/Ao · IVC',
      icon: Icons.monitor_heart,
      categories: [_kCardiac, _kNICU],
    ),
    // ── Fluid & electrolyte (an internal reference compendium set) ────────
    _CalculatorItem(
      title: 'Anion Gap',
      subtitle: 'Na − (HCO₃ + Cl) — HAGMA workup',
      icon: Icons.science_outlined,
      categories: [_kFluids, _kPICU],
    ),
    _CalculatorItem(
      title: 'Corrected AG (Albumin)',
      subtitle: 'AG + 2.5 × (Normal − Albumin)',
      icon: Icons.science_outlined,
      categories: [_kFluids, _kPICU],
    ),
    _CalculatorItem(
      title: 'Urine Anion Gap',
      subtitle: 'RTA vs diarrhoea',
      icon: Icons.water_drop_outlined,
      categories: [_kFluids],
    ),
    _CalculatorItem(
      title: 'Serum Osmolality',
      subtitle: '2Na + Glu/18 + BUN/2.8',
      icon: Icons.science,
      categories: [_kFluids],
    ),
    _CalculatorItem(
      title: 'Corrected Na (hyperglycaemia)',
      subtitle: 'Na + 1.6 × ((Glucose − 100)/100)',
      icon: Icons.calculate_outlined,
      categories: [_kFluids],
    ),
    _CalculatorItem(
      title: 'Blood Volume',
      subtitle: 'EBV by age band',
      icon: Icons.bloodtype_outlined,
      categories: [_kNICU, _kPICU],
    ),
    // ── Electrolyte correction calculators ────────────────────────────
    _CalculatorItem(
      title: 'Free Water Deficit (↑Na)',
      subtitle: 'Hypernatraemia correction',
      icon: Icons.opacity_outlined,
      categories: [_kFluids],
    ),
    _CalculatorItem(
      title: 'Na Correction (↓Na)',
      subtitle: 'Sodium deficit + 3 % saline bolus',
      icon: Icons.calculate,
      categories: [_kFluids, _kPICU],
    ),
    _CalculatorItem(
      title: 'K Correction (↓/↑K)',
      subtitle: 'KCl replacement OR ↑K regimen',
      icon: Icons.calculate,
      categories: [_kFluids, _kPICU],
    ),
    _CalculatorItem(
      title: 'Calcium Correction (↓Ca)',
      subtitle: 'CaCl₂ / gluconate / MgSO₄',
      icon: Icons.calculate,
      categories: [_kFluids, _kPICU],
    ),
    _CalculatorItem(
      title: 'Magnesium Correction (↓Mg)',
      subtitle: 'MgSO₄ IV + oral',
      icon: Icons.calculate,
      categories: [_kFluids],
    ),
    _CalculatorItem(
      title: 'Phosphate Correction (↓PO₄)',
      subtitle: 'NaPhos / KPhos / oral',
      icon: Icons.calculate,
      categories: [_kFluids],
    ),
    _CalculatorItem(
      title: 'Hypoglycaemia Bolus',
      subtitle: 'D10/D25/D50 + GIR + adjuncts',
      icon: Icons.calculate,
      categories: [_kNICU, _kPICU],
    ),
    // ── Neuro scoring (PIC) ───────────────────────────────────────────
    _CalculatorItem(
      title: 'Glasgow Coma Scale',
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
    ),
    _CalculatorItem(
      title: 'ETT Size + Depth',
      subtitle: 'NTL+1 · weight · age-based · tube×3',
      icon: Icons.air_outlined,
      categories: [_kNICU, _kPICU, _kResp, _kProc],
    ),
  ];

  /// All calculators when "All" is selected; otherwise those whose
  /// `categories` list contains the active chip.
  List<_CalculatorItem> get _filtered => _selected == _kAll
      ? _calculators
      : _calculators.where((c) => c.categories.contains(_selected)).toList();

  /// Per-chip count badge shown next to the chip label.
  int _countFor(String category) {
    if (category == _kAll) return _calculators.length;
    return _calculators.where((c) => c.categories.contains(category)).length;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Calculators & Tools'),
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
                    _CategoryChipBar(
                      categories: _kCategories,
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
                                childAspectRatio: 1.1,
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
    switch (title) {
      case 'Gestational Age & EDD':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const GestationalAgeCalculator()));
      case 'Ponderal Index':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const PonderalIndexCalculator()));
      case 'Body Surface Area':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const BSACalculator()));
      case 'Nutritional Audit':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const NutritionalAuditCalculator()));
      case 'TPN Calculator':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const TpnCalculator()));
      case 'CGA / PMA Calculator':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CGAPMACalculator()));
      case 'GIR Calculator':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const GIRCalculator()));
      case 'Schwartz eGFR':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SchwartzEGFRCalculator()));
      case 'Blood Gas Analyser':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const BloodGasAnalyser()));
      case 'DVET Calculator':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const DoubleVolumeExchange()));
      case 'Ventilator Parameters':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const VentilatorParameters()));
      case 'BPD Estimator':
        launchUrl(
          Uri.parse('https://neonatal.rti.org/index.cfm?fuseaction=BPD_Calculator2.start'),
          mode: LaunchMode.externalApplication,
        );
      case 'Blood Pressure':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const BPHubScreen()));
      case 'Neonatal Jaundice':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const JaundiceHubScreen()));
      case 'Maintenance Fluids':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const MaintenanceFluidCalculator()));
      case 'Parkland Formula':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ParklandCalculatorScreen()));
      case 'Lund & Browder Chart':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const LundBrowderScreen()));
      case 'Burn Mortality':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const BurnMortalityCalculator()));
      case 'PET Calculator':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const PETCalculatorScreen()));
      case '2D Echo Calculators':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const EchoCalculatorsScreen()));
      case 'Anion Gap':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AnionGapCalculator()));
      case 'Corrected AG (Albumin)':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CorrectedAnionGapCalculator()));
      case 'Urine Anion Gap':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const UrineAnionGapCalculator()));
      case 'Serum Osmolality':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SerumOsmolalityCalculator()));
      case 'Corrected Na (hyperglycaemia)':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CorrectedSodiumCalculator()));
      case 'Blood Volume':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const BloodVolumeCalculator()));
      case 'Free Water Deficit (↑Na)':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const FreeWaterDeficitCalculator()));
      case 'Na Correction (↓Na)':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SodiumCorrectionCalculator()));
      case 'K Correction (↓/↑K)':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PotassiumCorrectionCalculator()));
      case 'Calcium Correction (↓Ca)':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CalciumCorrectionCalculator()));
      case 'Magnesium Correction (↓Mg)':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MagnesiumCorrectionCalculator()));
      case 'Phosphate Correction (↓PO₄)':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PhosphateCorrectionCalculator()));
      case 'Hypoglycaemia Bolus':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const DextroseBolusCalculator()));
      case 'Glasgow Coma Scale':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const GcsScreen()));
      case 'UVC / UAC Depth':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const UmbilicalCatheterCalculator()));
      case 'ETT Size + Depth':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const EttCalculator()));
    }
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
    return Container(
      height: 50,
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = categories[i];
          final isSelected = cat == selected;
          final count = countFor(cat);
          return InkWell(
            onTap: () => onSelect(cat),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? cs.primary
                    : cs.surfaceContainerHighest.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? cs.primary
                      : cs.outlineVariant.withValues(alpha: 0.45),
                  width: isSelected ? 1 : 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    cat,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? cs.onPrimary : cs.onSurface,
                      letterSpacing: 0.05,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cs.onPrimary.withValues(alpha: 0.20)
                          : cs.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$count',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? cs.onPrimary : cs.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
          Icon(Icons.filter_alt_off_outlined,
              size: 48, color: cs.onSurface.withValues(alpha: 0.3)),
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
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
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

class _CalculatorItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> categories;

  const _CalculatorItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.categories,
  });
}
