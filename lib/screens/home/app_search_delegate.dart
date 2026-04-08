import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../calculators/gestational_age_calculator.dart';
import '../calculators/ponderal_index_calculator.dart';
import '../calculators/bsa_calculator.dart';
import '../calculators/nutritional_audit_calculator.dart';
import '../calculators/tpn_calculator.dart';
import '../calculators/cga_pma_calculator.dart';
import '../calculators/gir_calculator.dart';
import '../calculators/schwartz_egfr_calculator.dart';
import '../calculators/blood_gas_analyser.dart';
import '../calculators/double_volume_exchange.dart';
import '../calculators/ventilator_parameters.dart';
import '../calculators/bp_hub_screen.dart';
import '../calculators/jaundice_hub_screen.dart';
import '../calculators/maintenance_fluid_calculator.dart';
import '../calculators/parkland_calculator_screen.dart';
import '../calculators/lund_browder_screen.dart';
import '../calculators/burn_mortality_calculator.dart';
import '../calculators/pet_calculator_screen.dart';
import '../charts/who_chart_selection_screen.dart';
import '../charts/iap_chart_screen.dart';
import '../charts/fenton_chart_screen.dart';
import '../formulary/formulary_screen.dart';
import '../guides/fetal_development_screen.dart';
import '../guides/nrp_pdf_viewer.dart';
import '../vaccines/vaccine_screen.dart';
import '../guides/neonatal_scores/neonatal_scores_screen.dart';
import '../guides/modified_ballard_screen.dart';
import '../guides/pals/pals_algorithms_screen.dart';
import '../tools/paediatric_parameters_screen.dart';
import '../guides/polycythemia_guide_screen.dart';
import '../guides/pofras_screen.dart';
import '../guides/can_score_screen.dart';
import '../lab_reference/lab_reference_screen.dart';

// ── Search item model ─────────────────────────────────────────────────────────

class _SearchItem {
  final String title;
  final String subtitle;
  final String category;
  final IconData icon;
  final Color color;
  final List<String> keywords;
  final void Function(BuildContext) navigate;

  const _SearchItem({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.color,
    this.keywords = const [],
    required this.navigate,
  });

  bool matches(String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();
    return title.toLowerCase().contains(q) ||
        subtitle.toLowerCase().contains(q) ||
        category.toLowerCase().contains(q) ||
        keywords.any((k) => k.toLowerCase().contains(q));
  }
}

// ── Master item list ──────────────────────────────────────────────────────────

const _kCalcColor  = Color(0xFF1565C0);
const _kChartColor = Color(0xFF6A1B9A);
const _kDrugColor  = Color(0xFF00695C);
const _kGuideColor = Color(0xFF6D4C41);
const _kLabColor   = Color(0xFF00838F);

List<_SearchItem> _buildAllItems() => [

  // ── Calculators & Tools ─────────────────────────────────────────────────────

  _SearchItem(
    title: 'Gestational Age & EDD',
    subtitle: 'EDD, GA & Antenatal Dates',
    category: 'Calculators & Tools',
    icon: Icons.pregnant_woman_outlined,
    color: _kCalcColor,
    keywords: const ['edd', 'lmp', 'due date', 'dating', 'weeks', 'pregnancy dating', 'antenatal'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const GestationalAgeCalculator())),
  ),

  _SearchItem(
    title: 'Ponderal Index',
    subtitle: 'IUGR & nutritional status',
    category: 'Calculators & Tools',
    icon: Icons.child_care,
    color: _kCalcColor,
    keywords: const ['iugr', 'ponderal', 'weight', 'length', 'growth restriction', 'nutrition', 'PI'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const PonderalIndexCalculator())),
  ),

  _SearchItem(
    title: 'Body Surface Area',
    subtitle: 'Mosteller formula',
    category: 'Calculators & Tools',
    icon: Icons.person_outlined,
    color: _kCalcColor,
    keywords: const ['bsa', 'mosteller', 'surface area', 'dose calculation'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const BSACalculator())),
  ),

  _SearchItem(
    title: 'Nutritional Audit',
    subtitle: 'ESPGHAN 2022',
    category: 'Calculators & Tools',
    icon: Icons.local_dining,
    color: _kCalcColor,
    keywords: const ['espghan', 'feeds', 'calories', 'nutrition', 'audit', 'enteral', 'protein', 'intake'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const NutritionalAuditCalculator())),
  ),

  _SearchItem(
    title: 'TPN Calculator',
    subtitle: 'Stock & multi-line TPN',
    category: 'Calculators & Tools',
    icon: Icons.medical_services,
    color: _kCalcColor,
    keywords: const ['tpn', 'parenteral nutrition', 'iv nutrition', 'dextrose', 'amino acids', 'lipids', 'total parenteral'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const TpnCalculator())),
  ),

  _SearchItem(
    title: 'CGA / PMA Calculator',
    subtitle: 'Age correction for prematurity',
    category: 'Calculators & Tools',
    icon: Icons.calendar_month,
    color: _kCalcColor,
    keywords: const ['corrected gestational age', 'postmenstrual age', 'cga', 'pma', 'premature', 'corrected age', 'preterm age'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const CGAPMACalculator())),
  ),

  _SearchItem(
    title: 'GIR Calculator',
    subtitle: 'Glucose infusion rate',
    category: 'Calculators & Tools',
    icon: Icons.water_drop,
    color: _kCalcColor,
    keywords: const ['glucose', 'infusion rate', 'gir', 'dextrose', 'sugar', 'hypoglycaemia', 'neonatal glucose'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const GIRCalculator())),
  ),

  _SearchItem(
    title: 'Schwartz eGFR',
    subtitle: 'Creatinine clearance',
    category: 'Calculators & Tools',
    icon: Icons.monitor_heart_outlined,
    color: _kCalcColor,
    keywords: const ['egfr', 'creatinine', 'renal', 'kidney', 'gfr', 'glomerular filtration', 'schwartz', 'clearance'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const SchwartzEGFRCalculator())),
  ),

  _SearchItem(
    title: 'Blood Gas Analyser',
    subtitle: '7-step interpretation',
    category: 'Calculators & Tools',
    icon: Icons.air,
    color: _kCalcColor,
    keywords: const ['abg', 'blood gas', 'ph', 'pco2', 'po2', 'bicarbonate', 'acid base', 'metabolic', 'respiratory', 'acidosis', 'alkalosis'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const BloodGasAnalyser())),
  ),

  _SearchItem(
    title: 'DVET Calculator',
    subtitle: 'Double volume exchange transfusion',
    category: 'Calculators & Tools',
    icon: Icons.bloodtype_outlined,
    color: _kCalcColor,
    keywords: const ['exchange transfusion', 'dvet', 'double volume', 'blood exchange', 'jaundice treatment', 'ET'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const DoubleVolumeExchange())),
  ),

  _SearchItem(
    title: 'Ventilator Parameters',
    subtitle: 'OI, OSI, MAP, HFOV',
    category: 'Calculators & Tools',
    icon: Icons.air_rounded,
    color: _kCalcColor,
    keywords: const ['ventilator', 'oxygenation index', 'OI', 'OSI', 'mean airway pressure', 'MAP', 'HFOV', 'respiratory', 'mechanical ventilation'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const VentilatorParameters())),
  ),

  _SearchItem(
    title: 'BPD Estimator',
    subtitle: 'Bronchopulmonary Dysplasia — NICHD',
    category: 'Calculators & Tools',
    icon: Icons.air,
    color: _kCalcColor,
    keywords: const ['bpd', 'bronchopulmonary dysplasia', 'chronic lung disease', 'CLD', 'NICHD', 'preterm lung'],
    navigate: (ctx) => launchUrl(
      Uri.parse('https://neonatal.rti.org/index.cfm?fuseaction=BPD_Calculator2.start'),
      mode: LaunchMode.externalApplication,
    ),
  ),

  _SearchItem(
    title: 'Blood Pressure',
    subtitle: 'Neonatal & Paediatric BP',
    category: 'Calculators & Tools',
    icon: Icons.favorite_rounded,
    color: _kCalcColor,
    keywords: const ['blood pressure', 'bp', 'hypertension', 'hypotension', 'neonatal bp', 'pediatric bp', 'centile', 'systolic', 'diastolic', 'zubrow', 'aap bp'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const BPHubScreen())),
  ),

  _SearchItem(
    title: 'Neonatal Jaundice',
    subtitle: 'AAP 2022 Bilirubin Tool',
    category: 'Calculators & Tools',
    icon: Icons.opacity_rounded,
    color: _kCalcColor,
    keywords: const ['bilirubin', 'jaundice', 'phototherapy', 'exchange', 'TSB', 'icterus', 'aap 2022', 'kemper', 'hour specific', 'neurotoxicity'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const JaundiceHubScreen())),
  ),

  _SearchItem(
    title: 'Maintenance Fluids',
    subtitle: 'Neonatal & Paediatric Fluid Calculator',
    category: 'Calculators & Tools',
    icon: Icons.local_drink_outlined,
    color: _kCalcColor,
    keywords: const ['maintenance fluid', 'fluid', 'holliday segar', 'neonatal fluid', 'iv fluid', 'fluid requirement', 'ml per kg', 'dehydration', 'fluid therapy'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const MaintenanceFluidCalculator())),
  ),

  _SearchItem(
    title: 'Parkland Formula',
    subtitle: 'Burns Fluid Resuscitation',
    category: 'Calculators & Tools',
    icon: Icons.local_fire_department_outlined,
    color: _kCalcColor,
    keywords: const ['parkland', 'burns', 'burn fluid', 'tbsa', 'fluid resuscitation', 'lactated ringer', 'burn management', 'burn calculator', 'modified parkland'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const ParklandCalculatorScreen())),
  ),

  _SearchItem(
    title: 'Lund & Browder Chart',
    subtitle: 'Burn Surface Area Estimation',
    category: 'Calculators & Tools',
    icon: Icons.person_outlined,
    color: _kCalcColor,
    keywords: const ['lund browder', 'burn surface area', 'tbsa', 'burn assessment', 'body surface', 'burn percentage', 'burn chart', 'burn depth'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const LundBrowderScreen())),
  ),

  _SearchItem(
    title: 'PET Calculator',
    subtitle: 'Partial Exchange Transfusion — Polycythemia',
    category: 'Calculators & Tools',
    icon: Icons.bloodtype_outlined,
    color: _kCalcColor,
    keywords: const ['PET', 'partial exchange', 'polycythemia', 'polycythaemia', 'exchange transfusion', 'hematocrit', 'haematocrit', 'neonatal polycythemia', 'blood volume'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const PETCalculatorScreen())),
  ),

  _SearchItem(
    title: 'Burn Mortality',
    subtitle: 'Revised Baux Score — Mortality Prediction',
    category: 'Calculators & Tools',
    icon: Icons.monitor_heart_rounded,
    color: _kCalcColor,
    keywords: const ['baux', 'revised baux', 'burn mortality', 'mortality score', 'inhalation injury', 'burn prognosis', 'tbsa age', 'burn survival'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const BurnMortalityCalculator())),
  ),

  // ── Charts ──────────────────────────────────────────────────────────────────

  _SearchItem(
    title: 'WHO Growth Charts',
    subtitle: '0 to 5 Years — Boys & Girls',
    category: 'Charts',
    icon: Icons.show_chart,
    color: _kChartColor,
    keywords: const ['who', 'growth chart', 'weight', 'height', 'head circumference', 'bmi', '0-5 years', 'centile', 'percentile', 'z-score'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const WhoChartSelectionScreen())),
  ),

  _SearchItem(
    title: 'IAP Growth Charts',
    subtitle: '5 to 18 Years — Indian Reference',
    category: 'Charts',
    icon: Icons.show_chart,
    color: _kChartColor,
    keywords: const ['iap', 'indian', 'growth chart', 'height', 'weight', '5-18 years', 'iap 2015', 'adolescent'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const IAPChartScreen())),
  ),

  _SearchItem(
    title: 'Fenton Preterm Charts',
    subtitle: '22 to 50 weeks PMA — SGA / AGA / LGA',
    category: 'Charts',
    icon: Icons.monitor_heart_outlined,
    color: _kChartColor,
    keywords: const ['fenton', 'preterm', 'SGA', 'AGA', 'LGA', 'small for gestational age', 'growth', 'neonatal growth', '22-50 weeks', 'percentile'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const FentonChartScreen())),
  ),

  _SearchItem(
    title: 'INTERGROWTH-21st',
    subtitle: 'Neonatal Growth Charts — Oxford',
    category: 'Charts',
    icon: Icons.open_in_browser,
    color: _kChartColor,
    keywords: const ['intergrowth', 'oxford', 'neonatal growth', 'fetal growth', 'postnatal', 'preterm growth standard'],
    navigate: (ctx) => launchUrl(
      Uri.parse('https://intergrowth21.ndog.ox.ac.uk/en/ManualEntry'),
      mode: LaunchMode.externalApplication,
    ),
  ),

  // ── Drug Formulary ──────────────────────────────────────────────────────────

  _SearchItem(
    title: 'Drug Formulary',
    subtitle: '500+ drugs — Neofax & Harriet Lane',
    category: 'Drug Formulary',
    icon: Icons.medication_rounded,
    color: _kDrugColor,
    keywords: const ['drug', 'medication', 'dose', 'formulary', 'neofax', 'harriet lane', 'antibiotic', 'medicine', 'pediatric drug', 'neonatal drug', 'dosing'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const FormularyScreen())),
  ),

  // ── Guides ──────────────────────────────────────────────────────────────────

  _SearchItem(
    title: 'Fetal Development',
    subtitle: 'Week-by-week from LMP',
    category: 'Guides',
    icon: Icons.child_care_outlined,
    color: _kGuideColor,
    keywords: const ['fetal development', 'week by week', 'pregnancy', 'embryo', 'organogenesis', 'trimester', 'fetus', 'lmp'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const FetalDevelopmentScreen())),
  ),

  _SearchItem(
    title: 'NRP 9th Edition',
    subtitle: 'Neonatal Resuscitation Program',
    category: 'Guides',
    icon: Icons.menu_book,
    color: _kGuideColor,
    keywords: const ['nrp', 'newborn resuscitation', 'neonatal resuscitation', 'delivery room', 'resuscitation algorithm', '9th edition', 'apnea', 'intubation'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const NrpPdfViewer())),
  ),

  _SearchItem(
    title: 'Immunisation Schedule',
    subtitle: 'IAP 2022 & National (NIS)',
    category: 'Guides',
    icon: Icons.vaccines_outlined,
    color: _kGuideColor,
    keywords: const ['vaccine', 'immunization', 'immunisation', 'schedule', 'iap', 'nis', 'vaccination', 'bcg', 'opv', 'dpt', 'hepb'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const VaccineScreen())),
  ),

  _SearchItem(
    title: 'Neonatal Scores',
    subtitle: 'Apgar · Downes · Sarnat · Thompson & more',
    category: 'Guides',
    icon: Icons.assessment,
    color: _kGuideColor,
    keywords: const ['apgar', 'downes', 'sarnat', 'thompson', 'score', 'hie', 'levene', 'ballard', 'neonatal assessment', 'IVH', 'PHVD', 'NICHD'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const NeonatalScoresScreen())),
  ),

  _SearchItem(
    title: 'NICHD HIE Assessment',
    subtitle: 'Cooling eligibility & assessment tool',
    category: 'Guides',
    icon: Icons.thermostat_rounded,
    color: _kGuideColor,
    keywords: const ['NICHD', 'HIE', 'cooling', 'hypothermia', 'therapeutic hypothermia', 'birth asphyxia', 'hypoxic ischemic', 'encephalopathy'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const NeonatalScoresScreen())),
  ),

  _SearchItem(
    title: 'Modified Ballard Score',
    subtitle: 'Gestational Age Assessment',
    category: 'Guides',
    icon: Icons.child_care,
    color: _kGuideColor,
    keywords: const ['ballard', 'gestational age', 'maturity', 'assessment', 'scoring', 'neuromuscular', 'physical maturity'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const ModifiedBallardScreen())),
  ),

  _SearchItem(
    title: 'PALS Algorithms',
    subtitle: 'Pediatric Advanced Life Support',
    category: 'Guides',
    icon: Icons.monitor_heart,
    color: _kGuideColor,
    keywords: const ['pals', 'pediatric advanced life support', 'resuscitation', 'algorithm', 'cardiac arrest', 'bradycardia', 'tachycardia', 'shock', 'CPR', 'FBAO'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const PalsAlgorithmsScreen())),
  ),

  _SearchItem(
    title: 'Neonatal Echo',
    subtitle: 'TnECHO & Neonatal Hemodynamics',
    category: 'Guides',
    icon: Icons.monitor_heart,
    color: _kGuideColor,
    keywords: const ['echo', 'echocardiogram', 'tnecho', 'hemodynamics', 'cardiac', 'neocardiolab', 'targeted neonatal', 'PDA', 'PPHN'],
    navigate: (ctx) => launchUrl(
      Uri.parse('https://www.neocardiolab.com/tnecho-and-neonatal-hemodynamics'),
      mode: LaunchMode.externalApplication,
    ),
  ),

  _SearchItem(
    title: 'Paediatric Parameters',
    subtitle: 'Parameters & Equipment — Harriet Lane',
    category: 'Guides',
    icon: Icons.medical_services_outlined,
    color: _kGuideColor,
    keywords: const ['parameters', 'equipment', 'harriet lane', 'et tube', 'ETT', 'laryngoscope', 'weight based', 'paediatric equipment', 'age based', 'NGT', 'foley'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const PaediatricParametersScreen())),
  ),

  _SearchItem(
    title: 'Polycythemia in Newborn',
    subtitle: 'Management Algorithm — AIIMS Protocol',
    category: 'Guides',
    icon: Icons.bloodtype,
    color: _kGuideColor,
    keywords: const ['polycythemia', 'polycythaemia', 'hematocrit', 'haematocrit', 'PET', 'partial exchange', 'hyperviscosity', 'AIIMS', 'neonatal polycythemia', 'venous hct'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const PolycythemiaGuideScreen())),
  ),

  _SearchItem(
    title: 'POFRAS',
    subtitle: 'Preterm Oral Feeding Readiness Assessment Scale',
    category: 'Guides',
    icon: Icons.child_care_outlined,
    color: _kGuideColor,
    keywords: const ['pofras', 'oral feeding', 'preterm feeding', 'feeding readiness', 'sucking', 'oral motor', 'NNS', 'non nutritive sucking', 'oral reflexes', 'fujinaga', 'breastfeeding readiness', 'preterm oral'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const PofrasScreen())),
  ),

  _SearchItem(
    title: 'CAN Score',
    subtitle: 'Clinical Assessment of Nutrition at Birth',
    category: 'Guides',
    icon: Icons.monitor_weight_outlined,
    color: _kGuideColor,
    keywords: const ['CAN score', 'clinical assessment nutrition', 'fetal malnutrition', 'nutritional assessment', 'metcoff', 'IUGR', 'intrauterine growth restriction', 'fat wasting', 'muscle wasting', 'newborn nutrition', 'birth nutrition'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const CanScoreScreen())),
  ),

  // ── Lab Reference ───────────────────────────────────────────────────────────

  _SearchItem(
    title: 'Lab Reference',
    subtitle: 'Normal values — Paediatric & Neonatal',
    category: 'Lab Reference',
    icon: Icons.biotech_rounded,
    color: _kLabColor,
    keywords: const ['lab', 'laboratory', 'reference values', 'normal values', 'CBC', 'electrolytes', 'LFT', 'RFT', 'haematology', 'biochemistry', 'blood counts', 'thyroid', 'coagulation'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const LabReferenceScreen())),
  ),
];

// ── Delegate ──────────────────────────────────────────────────────────────────

class AppSearchDelegate extends SearchDelegate<void> {
  AppSearchDelegate() : super(searchFieldLabel: 'Search calculators, drugs, guides, charts…');

  late final List<_SearchItem> _allItems = _buildAllItems();

  List<_SearchItem> get _filtered =>
      query.isEmpty ? _allItems : _allItems.where((i) => i.matches(query)).toList();

  // ── Theming ────────────────────────────────────────────────────────────────

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF022B42) : const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white60, fontSize: 15),
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: const TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  @override
  List<Widget> buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.white),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => close(context, null),
  );

  // ── Results & suggestions ──────────────────────────────────────────────────

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final items = _filtered;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 56,
                color: cs.onSurface.withValues(alpha: 0.18)),
            const SizedBox(height: 14),
            Text('No results for "$query"',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: cs.onSurface.withValues(alpha: 0.45))),
            const SizedBox(height: 4),
            Text('Try a different keyword',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: cs.onSurface.withValues(alpha: 0.3))),
          ],
        ),
      );
    }

    // Group by category, preserving insertion order
    final grouped = <String, List<_SearchItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        if (query.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 2),
            child: Text(
              'All modules — tap to open',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: cs.onSurface.withValues(alpha: 0.4)),
            ),
          ),
        ...grouped.entries.expand((entry) => [
          _CategoryHeader(label: entry.key, cs: cs),
          ...entry.value.map((item) => _SearchResultTile(
            item: item,
            query: query,
            cs: cs,
            onTap: () => item.navigate(context),
          )),
        ]),
      ],
    );
  }
}

// ── UI helpers ────────────────────────────────────────────────────────────────

class _CategoryHeader extends StatelessWidget {
  final String label;
  final ColorScheme cs;
  const _CategoryHeader({required this.label, required this.cs});

  IconData _icon() {
    switch (label) {
      case 'Calculators & Tools': return Icons.calculate_rounded;
      case 'Charts':              return Icons.show_chart_rounded;
      case 'Drug Formulary':      return Icons.medication_rounded;
      case 'Guides':              return Icons.menu_book_outlined;
      case 'Lab Reference':       return Icons.biotech_rounded;
      default:                    return Icons.folder_outlined;
    }
  }

  Color _color() {
    switch (label) {
      case 'Calculators & Tools': return _kCalcColor;
      case 'Charts':              return _kChartColor;
      case 'Drug Formulary':      return _kDrugColor;
      case 'Guides':              return _kGuideColor;
      case 'Lab Reference':       return _kLabColor;
      default:                    return cs.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
      child: Row(
        children: [
          Icon(_icon(), size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: color.withValues(alpha: 0.25), height: 1)),
        ],
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final _SearchItem item;
  final String query;
  final ColorScheme cs;
  final VoidCallback onTap;

  const _SearchResultTile({
    required this.item,
    required this.query,
    required this.cs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: item.color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    item.subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right,
                size: 18, color: cs.onSurface.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}
