import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/guidelines_search_service.dart';
import '../../services/formulary_v2_service.dart';
import '../../utils/friendly_error.dart';

import '../calculators/gestational_age_calculator.dart';
import '../calculators/ponderal_index_calculator.dart';
import '../calculators/mid_parental_height_calculator.dart';
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
// New fluid / electrolyte / sodium calculators (user's WIP).
import '../calculators/anion_gap_calculator.dart';
import '../calculators/blood_volume_calculator.dart';
import '../calculators/calcium_correction_calculator.dart';
import '../calculators/corrected_anion_gap_calculator.dart';
import '../calculators/corrected_sodium_calculator.dart';
import '../calculators/dextrose_bolus_calculator.dart';
import '../calculators/ett_calculator.dart';
import '../calculators/free_water_deficit_calculator.dart';
import '../calculators/magnesium_correction_calculator.dart';
import '../calculators/phosphate_correction_calculator.dart';
import '../calculators/potassium_correction_calculator.dart';
import '../calculators/serum_osmolality_calculator.dart';
import '../calculators/sodium_correction_calculator.dart';
import '../calculators/umbilical_catheter_calculator.dart';
import '../calculators/urine_anion_gap_calculator.dart';
import '../calculators/neonatal_bp_calculator.dart';
import '../calculators/echo_calculators_screen.dart';
import '../charts/who_chart_selection_screen.dart';
import '../charts/iap_chart_screen.dart';
import '../charts/fenton_chart_screen.dart';
import '../formulary/formulary_screen.dart';
import '../formulary/drug_detail_v2_screen.dart';
import '../formulary_v2/formulary_v2_hub.dart';
import '../drugs/emergency_nicu_drugs_screen.dart';
import '../drugs/emergency_picu_drugs_screen.dart';
import '../guides/fetal_development_screen.dart';
import '../guides/nrp_pdf_viewer.dart';
import '../guides/neonatal_echo_screen.dart';
import '../guides/birthweight_classification_screen.dart';
import '../guides/ga_classification_screen.dart';
import '../guides/developmental_milestones/dev_milestones_hub.dart';
import '../guides/developmental_milestones/tdsc/tdsc_assistant_screen.dart';
// New emergency guides.
import '../guides/acute_severe_asthma_screen.dart';
import '../guides/avpu_screen.dart';
import '../guides/dka_algorithm_screen.dart';
import '../guides/electrolyte_corrections_screen.dart';
import '../guides/emergency_icu_drugs_screen.dart';
import '../guides/gcs_screen.dart';
import '../guides/hypertensive_emergency_screen.dart';
import '../guides/poisoning_antidotes_screen.dart';
import '../guides/rsi_guide_screen.dart';
import '../guides/scorpion_sting_screen.dart';
import '../guides/sedation_paralytics_screen.dart';
import '../guides/seizure_meds_screen.dart';
import '../guides/snake_envenomation_screen.dart';
import '../vaccines/vaccine_screen.dart';
import '../guides/neonatal_scores/neonatal_scores_screen.dart';
import '../guides/modified_ballard_screen.dart';
import '../guides/pals/pals_algorithms_screen.dart';
import '../tools/paediatric_parameters_screen.dart';
import '../guides/polycythemia_guide_screen.dart';
import '../guides/pofras_screen.dart';
import '../guides/can_score_screen.dart';
import '../lab_reference/lab_reference_screen.dart';
import '../faq_screen.dart';
import '../cme/cme_screen.dart';
import '../never_again/never_again_screen.dart';
import '../calculators/infant_bp_calculator.dart';
import '../../academics/academics_web_screen.dart';
import '../resources/resources_screen.dart';
import '../../services/academics_search_service.dart';

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

  /// Everything this item can be found by, lowercased once.
  ///
  /// Includes the synonym table below, so a tool is reachable by the words
  /// people actually type rather than only by its printed title.
  String get _haystack {
    final extra = _kSynonyms[title] ?? const <String>[];
    return [title, subtitle, category, ...keywords, ...extra]
        .join(' ')
        .toLowerCase();
  }

  /// A single trailing 's' removed, for words longer than three letters.
  ///
  /// The cheapest useful stemming: it makes "charts"/"chart", "plotters"/
  /// "plotter" and, crucially, "fentons"/"fenton" the same token. Without it,
  /// exact-substring matching failed on the plural or possessive form people
  /// actually type — "fentons growth chart" found nothing because "fentons"
  /// is not inside "fenton preterm charts".
  static String _stem(String w) =>
      (w.length > 3 && w.endsWith('s')) ? w.substring(0, w.length - 1) : w;

  /// How many words of the query this item matches, after stemming both
  /// sides. Zero means no match. Used for both filtering and ranking.
  int score(String query) {
    final words = query.toLowerCase().split(RegExp(r'\s+'))
      ..removeWhere((w) => w.isEmpty);
    if (words.isEmpty) return 1;

    // Stem the haystack once so "charts" in the query hits "chart" in a title.
    final hay = _haystack.split(RegExp(r'\s+')).map(_stem).join(' ');

    var hits = 0;
    for (final w in words) {
      if (hay.contains(_stem(w))) hits++;
    }
    return hits;
  }

  /// Whether the item should appear for this query.
  ///
  /// Every word must match on short queries. On a query of three or more
  /// words, one miss is forgiven — so "iap growth charts download" still
  /// finds IAP Growth Charts on the strength of iap + growth + charts, even
  /// though nothing indexes "download". A single stray or unindexed word no
  /// longer erases an otherwise obvious result. Results are ranked by [score]
  /// elsewhere, so the closest matches still lead.
  bool matches(String query) {
    if (query.isEmpty) return true;
    final n = query.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    if (n == 0) return true;
    final s = score(query);
    return n >= 3 ? s >= n - 1 : s == n;
  }
}

/// Extra words each tool should be findable by: synonyms, abbreviations,
/// source names and the years people search by.
///
/// Kept as a table beside the index rather than inline on all 82 items, so
/// adding a synonym is a one-line change and the item definitions stay
/// readable. Keys must match the item title exactly.
const Map<String, List<String>> _kSynonyms = {
  'Fenton Preterm Charts': [
    'plotter', 'plot', 'preterm growth', 'premature', 'growth chart',
    '2013', 'z score', 'zscore', 'percentile',
  ],
  'WHO Growth Charts': [
    'plotter', 'plot', 'growth chart', 'height', 'weight', 'length',
    'head circumference', 'ofc', 'bmi', 'z score', 'zscore', 'percentile',
    '2006', '2007',
  ],
  'IAP Growth Charts': [
    'plotter', 'plot', 'growth chart', 'indian', 'height', 'weight',
    'bmi', 'percentile', '2015',
  ],
  'INTERGROWTH-21st': ['plotter', 'plot', 'growth chart', 'intergrowth', 'preterm'],
  'Neonatal Jaundice': [
    'bilirubin', 'bili', 'tsb', 'phototherapy', 'exchange transfusion',
    'hyperbilirubinaemia', 'hyperbilirubinemia', 'aap', '2022', 'nice',
    'cg98', 'guideline', 'nomogram', 'icterus', 'kernicterus',
  ],
  'Blood Pressure': [
    'bp', 'hypertension', 'percentile', 'aap', '2017', 'guideline',
  ],
  'Neonatal BP': ['bp', 'blood pressure', 'hypotension', 'gestational age'],
  'Infant BP (1-12 Months)': ['bp', 'blood pressure', 'percentile'],
  'GIR Calculator': [
    'glucose infusion rate', 'dextrose', 'sugar', 'hypoglycaemia',
    'hypoglycemia', 'mg/kg/min',
  ],
  'Maintenance Fluids': [
    'iv fluids', 'holliday', 'segar', 'drip', 'hydration', 'deficit',
  ],
  'TPN Calculator': ['parenteral nutrition', 'total parenteral', 'lipids', 'amino acid'],
  'DVET Calculator': ['double volume exchange', 'exchange transfusion', 'bilirubin'],
  'PET Calculator': ['partial exchange', 'polycythemia', 'polycythaemia', 'hematocrit'],
  'Body Surface Area': ['bsa', 'mosteller', 'dubois', 'chemo'],
  'Schwartz eGFR': ['gfr', 'creatinine', 'renal', 'kidney', 'clearance'],
  'Blood Gas Analyser': ['abg', 'vbg', 'acid base', 'ph', 'metabolic acidosis', 'anion'],
  'Ventilator Parameters': [
    'tidal volume', 'map', 'oi', 'osi', 'oxygenation index', 'ventilation',
    'peep', 'pip',
  ],
  'CGA / PMA Calculator': [
    'corrected gestational age', 'postmenstrual age', 'corrected age', 'pma',
  ],
  'Gestational Age & EDD': ['edd', 'due date', 'lmp', 'dating'],
  'Mid-Parental Height': ['target height', 'genetic potential', 'final height', 'mph'],
  'Drug Formulary': [
    'drugs', 'medication', 'dose', 'dosing', 'neofax', 'harriet lane',
    'formulary',
  ],
  'Drug Formulary 2.0': ['drugs', 'medication', 'dose', 'dosing', 'neofax', 'harriet lane'],
  'Emergency NICU Drugs': ['resuscitation', 'code', 'crash', 'infusion', 'neonatal'],
  'Emergency PICU Drugs': ['resuscitation', 'code', 'crash', 'infusion', 'paediatric'],
  'NRP 9th Edition': ['resuscitation', 'neonatal resuscitation', 'delivery room', 'algorithm'],
  'PALS Algorithms': ['resuscitation', 'cardiac arrest', 'algorithm', 'acls'],
  'Immunisation Schedule': ['vaccine', 'vaccination', 'immunization', 'iap schedule'],
  'Neonatal Scores': ['apgar', 'snappe', 'crib', 'downe', 'silverman', 'score'],
  'Modified Ballard Score': ['ballard', 'gestational age assessment', 'maturity'],
  'NICHD HIE Assessment': ['hie', 'asphyxia', 'cooling', 'encephalopathy', 'sarnat'],
  'Lab Reference': ['normal values', 'reference range', 'labs', 'investigations'],
  'Developmental Milestones': ['milestones', 'development', 'ddst', 'delay'],
  'Trivandrum DSC (TDSC)': ['trivandrum', 'development screening', 'tdsc'],
  'Resources': ['pdf', 'download', 'charts', 'handout', 'teaching'],
  'Academics': [
    'trials', 'landmark trials', 'guidelines', 'stg', 'nnf', 'iap',
    'action plan', 'journal', 'reviews', 'recent guides',
  ],
  'CME & Webinars': ['conference', 'workshop', 'course', 'webinar', 'credits', 'certificate'],
  'Never Again': ['mistakes', 'lessons', 'incident', 'safety', 'error'],
  'DKA Algorithm': ['diabetic ketoacidosis', 'insulin', 'ketones', 'diabetes'],
  'Acute Severe Asthma': ['wheeze', 'bronchodilator', 'salbutamol', 'status asthmaticus'],
  'Rapid Sequence Intubation': ['rsi', 'intubation', 'airway', 'induction'],
  'ETT Size & Depth': ['tube size', 'intubation', 'airway', 'endotracheal'],
  'Poisoning Antidotes': ['toxicology', 'overdose', 'antidote', 'poison'],
  'Snake Envenomation': ['snake bite', 'antivenom', 'asv'],
  'Scorpion Sting': ['prazosin', 'envenomation', 'sting'],
  'Seizure Medications': ['status epilepticus', 'anticonvulsant', 'fits', 'convulsion'],
  'Electrolyte Corrections': [
    'sodium', 'potassium', 'calcium', 'magnesium', 'phosphate', 'correction',
  ],
  'Burn Mortality': ['burns', 'tbsa', 'baux'],
  'Parkland Formula': ['burns', 'fluid resuscitation', 'tbsa'],
  'Lund & Browder Chart': ['burns', 'tbsa', 'body surface'],
  'Neonatal Echo': ['echocardiography', 'cardiac', 'heart', 'pda', 'shunt'],
  '2D Echo Calculators': ['echocardiography', 'cardiac', 'z score', 'valve'],
  'Umbilical Catheter Depth': ['uac', 'uvc', 'umbilical line', 'catheter'],
  'Birthweight Classification': ['lbw', 'vlbw', 'elbw', 'sga', 'aga', 'lga'],
  'Gestational Age Classification': ['preterm', 'term', 'post term', 'classification'],
  'Polycythemia in Newborn': ['polycythaemia', 'hematocrit', 'haematocrit', 'partial exchange'],
  'Blood Volume': ['circulating volume', 'transfusion', 'ebv'],
  'Serum Osmolality': ['osmolality', 'osmolar gap', 'tonicity'],
  'Free Water Deficit': ['hypernatremia', 'hypernatraemia', 'water deficit'],
  'Dextrose Bolus': ['hypoglycaemia', 'hypoglycemia', 'sugar', 'd10'],
  'FAQ & Help': ['help', 'support', 'how to', 'contact'],
};

// ── Master item list ──────────────────────────────────────────────────────────

const _kCalcColor      = Color(0xFF1565C0);
const _kChartColor     = Color(0xFF6A1B9A);
const _kDrugColor      = Color(0xFF00695C);
const _kGuideColor     = Color(0xFF6D4C41);
const _kLabColor       = Color(0xFF00838F);
const _kEmergencyColor = Color(0xFFB71C1C);
const _kAcademicsColor = Color(0xFF7C3AED);
const _kResourceColor  = Color(0xFFAD1457);


/// Titles withheld from search on iOS.
///
/// App Store guideline 1.4.2 restricts drug dosage tools to manufacturers,
/// hospitals, universities and similar approved entities, so these screens are
/// hidden from the calculators list and the guides list on iOS. Search reaches
/// them by a different path, and a gate that every other route respects but
/// search ignores is not a gate at all — someone typing "TPN" would still land
/// on the screen the build is meant not to have.
///
/// Kept in step with `iosHidden` in calculators_screen.dart and `dosing` in
/// guides_screen.dart. Those lists are the source of truth; this mirrors them
/// because the search index is built from a separate set of entries.
const Set<String> _kIosHiddenTitles = {
  'Acute Severe Asthma',
  'Blood Gas Analyser',
  'Calcium Correction (↓Ca)',
  'DKA Algorithm',
  'DVET Calculator',
  'Electrolyte Corrections',
  'Emergency ICU Drugs',
  'Free Water Deficit (↑Na)',
  'GIR Calculator',
  'Glasgow Coma Scale',
  'Hypertensive Emergency',
  'Hypoglycaemia Bolus',
  'K Correction (↓/↑K)',
  'Magnesium Correction (↓Mg)',
  'Maintenance Fluids',
  'Na Correction (↓Na)',
  'PET Calculator',
  'Parkland Formula',
  'Phosphate Correction (↓PO₄)',
  'Poisoning & Antidotes',
  'RSI — Rapid Sequence Intubation',
  'Sedation, Analgesia & Paralytics',
  'Seizure Medications',
  'Snake Envenomation',
  'TPN Calculator',
};

List<_SearchItem> _buildAllItems() => _allItemsUnfiltered()
    .where((i) => !(!kIsWeb && Platform.isIOS && _kIosHiddenTitles.contains(i.title)))
    .toList();

List<_SearchItem> _allItemsUnfiltered() => [

  // ── Calculators & Tools ─────────────────────────────────────────────────────

  _SearchItem(
    title: 'Gestational Age & EDD',
    subtitle: 'EDD, GA & Antenatal Dates',
    category: 'Calculators & Tools',
    icon: Icons.pregnant_woman_outlined,
    color: _kCalcColor,
    keywords: const ['edd', 'lmp', 'due date', 'dating', 'weeks', 'pregnancy dating', 'antenatal', 'expected date delivery', 'naegele', 'USG dating', 'scan date', 'trimester', 'conception', 'estimated delivery', 'obstetric date'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const GestationalAgeCalculator())),
  ),

  _SearchItem(
    title: 'Ponderal Index',
    subtitle: 'IUGR & nutritional status',
    category: 'Calculators & Tools',
    icon: Icons.child_care,
    color: _kCalcColor,
    keywords: const ['iugr', 'ponderal', 'weight', 'length', 'growth restriction', 'nutrition', 'PI', 'fetal growth restriction', 'FGR', 'SGA', 'wasting', 'symmetrical IUGR', 'asymmetrical IUGR', 'thin baby', 'malnourished'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const PonderalIndexCalculator())),
  ),

  _SearchItem(
    title: 'Mid-Parental Height',
    subtitle: 'Genetic target height & range',
    category: 'Calculators & Tools',
    icon: Icons.height_rounded,
    color: _kCalcColor,
    keywords: const ['mid parental height', 'MPH', 'target height', 'genetic potential', 'short stature', 'tall stature', 'familial short stature', 'parental height', "mother's height", "father's height", 'target height range', 'growth potential', 'height prediction'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const MidParentalHeightCalculator())),
  ),

  _SearchItem(
    title: 'Body Surface Area',
    subtitle: 'Mosteller formula',
    category: 'Calculators & Tools',
    icon: Icons.person_outlined,
    color: _kCalcColor,
    keywords: const ['bsa', 'mosteller', 'surface area', 'dose calculation', 'body surface', 'chemotherapy dose', 'drug dosing', 'body area'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const BSACalculator())),
  ),

  _SearchItem(
    title: 'Nutritional Audit',
    subtitle: 'ESPGHAN 2022',
    category: 'Calculators & Tools',
    icon: Icons.local_dining,
    color: _kCalcColor,
    keywords: const ['espghan', 'feeds', 'calories', 'nutrition', 'audit', 'enteral', 'protein', 'intake', 'calorie calculator', 'feeding audit', 'kcal', 'breast milk', 'formula', 'fortifier', 'preterm feeding', 'energy', 'growth velocity', 'feed volume'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const NutritionalAuditCalculator())),
  ),

  _SearchItem(
    title: 'TPN Calculator',
    subtitle: 'Stock & multi-line TPN',
    category: 'Calculators & Tools',
    icon: Icons.medical_services,
    color: _kCalcColor,
    keywords: const ['tpn', 'parenteral nutrition', 'iv nutrition', 'dextrose', 'amino acids', 'lipids', 'total parenteral', 'PN', 'intralipid', 'smof', 'trophamine', 'primene', 'hyperalimentation', 'central line nutrition', 'vaminolact'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const TpnCalculator())),
  ),

  _SearchItem(
    title: 'CGA / PMA Calculator',
    subtitle: 'Age correction for prematurity',
    category: 'Calculators & Tools',
    icon: Icons.calendar_month,
    color: _kCalcColor,
    keywords: const ['corrected gestational age', 'postmenstrual age', 'cga', 'pma', 'premature', 'corrected age', 'preterm age', 'chronological age', 'adjusted age', 'preterm correction', 'age correction'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const CGAPMACalculator())),
  ),

  _SearchItem(
    title: 'GIR Calculator',
    subtitle: 'Glucose infusion rate',
    category: 'Calculators & Tools',
    icon: Icons.water_drop,
    color: _kCalcColor,
    keywords: const ['glucose', 'infusion rate', 'gir', 'dextrose', 'sugar', 'hypoglycaemia', 'neonatal glucose', 'hypoglycemia', 'blood sugar', 'D10', 'D5', 'mg/kg/min', 'glucose delivery rate', 'low sugar', 'hyperglycemia', 'hyperglycaemia'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const GIRCalculator())),
  ),

  _SearchItem(
    title: 'Schwartz eGFR',
    subtitle: 'Creatinine clearance',
    category: 'Calculators & Tools',
    icon: Icons.monitor_heart_outlined,
    color: _kCalcColor,
    keywords: const ['egfr', 'creatinine', 'renal', 'kidney', 'gfr', 'glomerular filtration', 'schwartz', 'clearance', 'AKI', 'acute kidney injury', 'renal failure', 'CKD', 'kidney function', 'nephrology', 'bedside schwartz'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const SchwartzEGFRCalculator())),
  ),

  _SearchItem(
    title: 'Blood Gas Analyser',
    subtitle: '7-step interpretation',
    category: 'Calculators & Tools',
    icon: Icons.air,
    color: _kCalcColor,
    keywords: const ['abg', 'blood gas', 'ph', 'pco2', 'po2', 'bicarbonate', 'acid base', 'metabolic', 'respiratory', 'acidosis', 'alkalosis', 'VBG', 'venous blood gas', 'base excess', 'base deficit', 'BE', 'lactate', 'compensation', 'mixed disorder', 'HCO3', 'arterial gas'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const BloodGasAnalyser())),
  ),

  _SearchItem(
    title: 'DVET Calculator',
    subtitle: 'Double volume exchange transfusion',
    category: 'Calculators & Tools',
    icon: Icons.bloodtype_outlined,
    color: _kCalcColor,
    keywords: const ['exchange transfusion', 'dvet', 'double volume', 'blood exchange', 'jaundice treatment', 'ET', 'severe jaundice', 'kernicterus', 'bilirubin encephalopathy', 'aliquot', 'blood group incompatibility', 'Rh incompatibility', 'ABO incompatibility', 'isoimmunisation'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const DoubleVolumeExchange())),
  ),

  _SearchItem(
    title: 'Ventilator Parameters',
    subtitle: 'OI, OSI, MAP, HFOV',
    category: 'Calculators & Tools',
    icon: Icons.air_rounded,
    color: _kCalcColor,
    keywords: const ['ventilator', 'oxygenation index', 'OI', 'OSI', 'mean airway pressure', 'MAP', 'HFOV', 'respiratory', 'mechanical ventilation', 'CPAP', 'SIMV', 'pressure support', 'FiO2', 'PEEP', 'PIP', 'tidal volume', 'ventilator settings', 'respiratory failure', 'oxygen', 'surfactant', 'RDS', 'HFO'],
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
    keywords: const ['blood pressure', 'bp', 'hypertension', 'hypotension', 'neonatal bp', 'pediatric bp', 'centile', 'systolic', 'diastolic', 'zubrow', 'aap bp', 'high bp', 'low bp', 'bp chart', 'bp centile', 'bp percentile', 'normal bp', 'stage 1', 'stage 2', 'infant bp', 'child bp', 'adolescent bp'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const BPHubScreen())),
  ),

  _SearchItem(
    title: 'Neonatal Jaundice',
    subtitle: 'AAP 2022 Bilirubin Tool',
    category: 'Calculators & Tools',
    icon: Icons.opacity_rounded,
    color: _kCalcColor,
    keywords: const ['bilirubin', 'jaundice', 'phototherapy', 'exchange', 'TSB', 'icterus', 'aap 2022', 'kemper', 'hour specific', 'neurotoxicity', 'yellow baby', 'bili', 'neonatal jaundice', 'breast milk jaundice', 'physiological jaundice', 'pathological jaundice', 'conjugated', 'unconjugated', 'direct bilirubin', 'indirect bilirubin', 'bhutani', 'nomogram', 'risk zone'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const JaundiceHubScreen())),
  ),

  _SearchItem(
    title: 'Maintenance Fluids',
    subtitle: 'Neonatal & Paediatric Fluid Calculator',
    category: 'Calculators & Tools',
    icon: Icons.local_drink_outlined,
    color: _kCalcColor,
    keywords: const ['maintenance fluid', 'fluid', 'holliday segar', 'neonatal fluid', 'iv fluid', 'fluid requirement', 'ml per kg', 'dehydration', 'fluid therapy', '4-2-1 rule', 'fluid rate', 'drip rate', 'normal saline', 'NS', 'RL', 'ringer lactate', 'D5NS', 'isolyte', 'fluid bolus', 'fluid management', 'day 1 fluid', 'preterm fluid'],
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
    keywords: const ['who', 'growth chart', 'weight', 'height', 'head circumference', 'bmi', '0-5 years', 'centile', 'percentile', 'z-score', 'growth monitoring', 'wasting', 'stunting', 'underweight', 'obesity', 'overweight', 'failure to thrive', 'FTT', 'growth faltering', 'OFC', 'length for age', 'weight for age', 'weight for length'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const WhoChartSelectionScreen())),
  ),

  _SearchItem(
    title: 'IAP Growth Charts',
    subtitle: '5 to 18 Years — Indian Reference',
    category: 'Charts',
    icon: Icons.show_chart,
    color: _kChartColor,
    keywords: const ['iap', 'indian', 'growth chart', 'height', 'weight', '5-18 years', 'iap 2015', 'adolescent', 'school age', 'india growth', 'national growth', 'short stature', 'tall stature', 'mid parental height', 'target height', 'puberty', 'BMI chart'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const IAPChartScreen())),
  ),

  _SearchItem(
    title: 'Fenton Preterm Charts',
    subtitle: '22 to 50 weeks PMA — SGA / AGA / LGA',
    category: 'Charts',
    icon: Icons.monitor_heart_outlined,
    color: _kChartColor,
    keywords: const ['fenton', 'preterm', 'SGA', 'AGA', 'LGA', 'small for gestational age', 'growth', 'neonatal growth', '22-50 weeks', 'percentile', 'fenton 2013', 'preterm growth chart', 'NICU growth', 'premature growth', 'birth weight centile', 'growth velocity', 'EUGR', 'postnatal growth failure'],
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
    keywords: const ['drug', 'medication', 'dose', 'formulary', 'neofax', 'harriet lane', 'antibiotic', 'medicine', 'pediatric drug', 'neonatal drug', 'dosing', 'mg per kg', 'paracetamol', 'amoxicillin', 'ceftriaxone', 'gentamicin', 'vancomycin', 'meropenem', 'ibuprofen', 'phenobarbitone', 'caffeine', 'surfactant', 'indomethacin', 'drug dose', 'syrup', 'injection', 'tablet'],
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
    keywords: const ['nrp', 'newborn resuscitation', 'neonatal resuscitation', 'delivery room', 'resuscitation algorithm', '9th edition', 'apnea', 'intubation', 'PPV', 'positive pressure ventilation', 'CPAP', 'chest compressions', 'golden minute', 'meconium', 'birth asphyxia', 'delayed cord clamping', 'T-piece', 'epinephrine', 'adrenaline', 'UVC', 'heart rate', 'SpO2 target'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const NrpPdfViewer())),
  ),

  _SearchItem(
    title: 'Immunisation Schedule',
    subtitle: 'IAP 2022 & National (NIS)',
    category: 'Guides',
    icon: Icons.vaccines_outlined,
    color: _kGuideColor,
    keywords: const ['vaccine', 'immunization', 'immunisation', 'schedule', 'iap', 'nis', 'vaccination', 'bcg', 'opv', 'dpt', 'hepb', 'mmr', 'typhoid', 'varicella', 'pneumococcal', 'pcv', 'rotavirus', 'hib', 'hepatitis', 'meningococcal', 'catch up', 'booster', 'birth dose', 'ipv', 'tdap', 'flu vaccine', 'influenza', 'hpv', 'pentavalent'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const VaccineScreen())),
  ),

  _SearchItem(
    title: 'Neonatal Scores',
    subtitle: 'Apgar · Downes · Sarnat · Thompson & more',
    category: 'Guides',
    icon: Icons.assessment,
    color: _kGuideColor,
    keywords: const ['apgar', 'downes', 'sarnat', 'thompson', 'score', 'hie', 'levene', 'ballard', 'neonatal assessment', 'IVH', 'PHVD', 'NICHD', 'silverman anderson', 'silverman', 'respiratory distress score', 'LATCH', 'breastfeeding score', 'CAN score', 'nutrition score', 'POFRAS', 'feeding readiness', 'combined apgar', 'lung ultrasound', 'LUS', 'neonatal scoring'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const NeonatalScoresScreen())),
  ),

  _SearchItem(
    title: 'NICHD HIE Assessment',
    subtitle: 'Cooling eligibility & assessment tool',
    category: 'Guides',
    icon: Icons.thermostat_rounded,
    color: _kGuideColor,
    keywords: const ['NICHD', 'HIE', 'cooling', 'hypothermia', 'therapeutic hypothermia', 'birth asphyxia', 'hypoxic ischemic', 'encephalopathy', 'perinatal asphyxia', 'seizures', 'MRI brain', 'whole body cooling', 'selective head cooling', 'servo mode', 'rewarming', '33.5 degrees', 'neonatal seizures'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const NeonatalScoresScreen())),
  ),

  _SearchItem(
    title: 'Modified Ballard Score',
    subtitle: 'Gestational Age Assessment',
    category: 'Guides',
    icon: Icons.child_care,
    color: _kGuideColor,
    keywords: const ['ballard', 'gestational age', 'maturity', 'assessment', 'scoring', 'neuromuscular', 'physical maturity', 'new ballard', 'NBS', 'square window', 'arm recoil', 'popliteal angle', 'scarf sign', 'heel to ear', 'skin texture', 'lanugo', 'plantar crease', 'breast bud', 'genitalia', 'posture'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const ModifiedBallardScreen())),
  ),

  _SearchItem(
    title: 'PALS Algorithms',
    subtitle: 'Pediatric Advanced Life Support',
    category: 'Guides',
    icon: Icons.monitor_heart,
    color: _kGuideColor,
    keywords: const ['pals', 'pediatric advanced life support', 'resuscitation', 'algorithm', 'cardiac arrest', 'bradycardia', 'tachycardia', 'shock', 'CPR', 'FBAO', 'SVT', 'supraventricular tachycardia', 'VT', 'VF', 'pulseless', 'AED', 'defibrillation', 'cardioversion', 'adenosine', 'amiodarone', 'chest compression', 'pediatric resuscitation', 'choking', 'foreign body', 'asystole', 'PEA'],
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
    keywords: const ['parameters', 'equipment', 'harriet lane', 'et tube', 'ETT', 'laryngoscope', 'weight based', 'paediatric equipment', 'age based', 'NGT', 'foley', 'chest tube', 'suction catheter', 'BP cuff size', 'mask size', 'ambu bag', 'LMA', 'IO needle', 'intraosseous', 'IV cannula', 'tracheostomy', 'blade size', 'miller', 'macintosh'],
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
    keywords: const ['CAN score', 'clinical assessment nutrition', 'fetal malnutrition', 'nutritional assessment', 'metcoff', 'IUGR', 'intrauterine growth restriction', 'fat wasting', 'muscle wasting', 'newborn nutrition', 'birth nutrition', 'SGA nutrition', 'subcutaneous fat', 'skin fold', 'hair quality', 'nail', 'cheek fat', 'breast tissue', 'buttocks', 'abdomen', 'arms', 'legs'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const CanScoreScreen())),
  ),

  // ── Lab Reference ───────────────────────────────────────────────────────────

  _SearchItem(
    title: 'Lab Reference',
    subtitle: 'Normal values — Paediatric & Neonatal',
    category: 'Lab Reference',
    icon: Icons.biotech_rounded,
    color: _kLabColor,
    keywords: const ['lab', 'laboratory', 'reference values', 'normal values', 'CBC', 'electrolytes', 'LFT', 'RFT', 'haematology', 'biochemistry', 'blood counts', 'thyroid', 'coagulation', 'normal range', 'hemoglobin', 'haemoglobin', 'WBC', 'platelet', 'bilirubin', 'creatinine', 'urea', 'ALT', 'AST', 'CRP', 'ESR', 'PT', 'INR', 'aPTT', 'fibrinogen', 'TSH', 'T3', 'T4', 'cortisol', 'ammonia', 'lactate', 'blood sugar', 'ABG values', 'CSF', 'urine', 'neonatal values', 'pediatric range'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const LabReferenceScreen())),
  ),

  // ─── New fluid / electrolyte / sodium calculators ──────────────────────────

  _SearchItem(
    title: 'Anion Gap',
    subtitle: 'Na − (Cl + HCO₃)',
    category: 'Calculators & Tools',
    icon: Icons.science_outlined,
    color: _kCalcColor,
    keywords: const ['anion gap', 'AG', 'metabolic acidosis', 'high anion gap', 'normal anion gap', 'HAGMA', 'NAGMA', 'acidosis', 'sodium chloride bicarbonate'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const AnionGapCalculator())),
  ),
  _SearchItem(
    title: 'Corrected Anion Gap',
    subtitle: 'Albumin-corrected AG',
    category: 'Calculators & Tools',
    icon: Icons.science_outlined,
    color: _kCalcColor,
    keywords: const ['corrected anion gap', 'CAG', 'albumin corrected', 'hypoalbuminaemia', 'hypoalbuminemia', 'metabolic acidosis', 'AG'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const CorrectedAnionGapCalculator())),
  ),
  _SearchItem(
    title: 'Urine Anion Gap',
    subtitle: 'UAG — distal RTA workup',
    category: 'Calculators & Tools',
    icon: Icons.science_outlined,
    color: _kCalcColor,
    keywords: const ['urine anion gap', 'UAG', 'RTA', 'renal tubular acidosis', 'distal RTA', 'urine sodium potassium chloride'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const UrineAnionGapCalculator())),
  ),
  _SearchItem(
    title: 'Sodium Correction',
    subtitle: 'Hyponatraemia & hypernatraemia',
    category: 'Calculators & Tools',
    icon: Icons.water,
    color: _kCalcColor,
    keywords: const ['sodium', 'hyponatraemia', 'hyponatremia', 'hypernatraemia', 'hypernatremia', 'na correction', 'osmotic demyelination', 'central pontine', '3% saline', 'hypertonic saline', 'free water', 'sodium deficit', 'SIADH', 'cerebral salt wasting', 'low sodium', 'high sodium', 'ODS', 'myelinolysis', 'seizures hyponatremia', 'total body water'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const SodiumCorrectionCalculator())),
  ),
  _SearchItem(
    title: 'Corrected Sodium',
    subtitle: 'Hyperglycaemia & TG correction',
    category: 'Calculators & Tools',
    icon: Icons.water,
    color: _kCalcColor,
    keywords: const ['corrected sodium', 'pseudo-hyponatraemia', 'pseudohyponatraemia', 'glucose correction', 'hyperglycaemia', 'hyperglycemia', 'na correction'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const CorrectedSodiumCalculator())),
  ),
  _SearchItem(
    title: 'Free Water Deficit',
    subtitle: 'Hypernatraemia rehydration',
    category: 'Calculators & Tools',
    icon: Icons.water,
    color: _kCalcColor,
    keywords: const ['free water deficit', 'FWD', 'hypernatraemia', 'hypernatremia', 'dehydration', 'rehydration', 'water deficit', 'TBW'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const FreeWaterDeficitCalculator())),
  ),
  _SearchItem(
    title: 'Potassium Correction',
    subtitle: 'Hypokalaemia & hyperkalaemia',
    category: 'Calculators & Tools',
    icon: Icons.bolt_outlined,
    color: _kCalcColor,
    keywords: const ['potassium', 'k correction', 'hypokalaemia', 'hypokalemia', 'hyperkalaemia', 'hyperkalemia', 'KCl', 'potassium chloride', 'IV potassium', 'oral potassium', 'low potassium', 'high potassium', 'ECG changes', 'tall T wave', 'U wave', 'arrhythmia', 'cardiac arrest potassium', 'salbutamol nebulisation', 'insulin dextrose', 'calcium gluconate hyperkalemia', 'kayexalate'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const PotassiumCorrectionCalculator())),
  ),
  _SearchItem(
    title: 'Calcium Correction',
    subtitle: 'Hypocalcaemia / albumin-corrected',
    category: 'Calculators & Tools',
    icon: Icons.bolt_outlined,
    color: _kCalcColor,
    keywords: const ['calcium', 'ca correction', 'hypocalcaemia', 'hypocalcemia', 'corrected calcium', 'albumin', 'ionised calcium', 'tetany', 'gluconate', 'low calcium', 'QTc prolongation', 'trousseau', 'chvostek', 'jitteriness', 'seizures calcium', 'calcium chloride', 'neonatal hypocalcaemia', 'vitamin D', 'rickets', 'DiGeorge'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const CalciumCorrectionCalculator())),
  ),
  _SearchItem(
    title: 'Magnesium Correction',
    subtitle: 'Hypomagnesaemia',
    category: 'Calculators & Tools',
    icon: Icons.bolt_outlined,
    color: _kCalcColor,
    keywords: const ['magnesium', 'mg correction', 'hypomagnesaemia', 'hypomagnesemia', 'MgSO4', 'magnesium sulfate', 'tetany', 'torsades'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const MagnesiumCorrectionCalculator())),
  ),
  _SearchItem(
    title: 'Phosphate Correction',
    subtitle: 'Hypophosphataemia',
    category: 'Calculators & Tools',
    icon: Icons.bolt_outlined,
    color: _kCalcColor,
    keywords: const ['phosphate', 'po4 correction', 'hypophosphataemia', 'hypophosphatemia', 'metabolic bone disease of prematurity', 'MBDP', 'rickets'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const PhosphateCorrectionCalculator())),
  ),
  _SearchItem(
    title: 'Dextrose Bolus',
    subtitle: 'Neonatal hypoglycaemia',
    category: 'Calculators & Tools',
    icon: Icons.water_drop,
    color: _kCalcColor,
    keywords: const ['dextrose bolus', 'D10', '2 mL/kg', 'hypoglycaemia', 'hypoglycemia', 'minibolus', 'mini bolus', 'glucose bolus', 'low blood sugar', 'neonatal hypoglycaemia', 'D10W', 'D25', 'D50', 'central line dextrose', 'peripheral dextrose', 'GIR', 'glucose infusion rate', 'IDM', 'infant of diabetic mother', 'LGA hypoglycemia', 'SGA hypoglycemia', 'glucagon', 'diazoxide', 'congenital hyperinsulinism'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const DextroseBolusCalculator())),
  ),
  _SearchItem(
    title: 'Serum Osmolality',
    subtitle: '2Na + Glucose/18 + BUN/2.8',
    category: 'Calculators & Tools',
    icon: Icons.science_outlined,
    color: _kCalcColor,
    keywords: const ['serum osmolality', 'osmolality', 'osmolar gap', 'osmolar', 'methanol', 'ethylene glycol', 'mannitol'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const SerumOsmolalityCalculator())),
  ),
  _SearchItem(
    title: 'Blood Volume',
    subtitle: 'EBV by age & weight',
    category: 'Calculators & Tools',
    icon: Icons.bloodtype_outlined,
    color: _kCalcColor,
    keywords: const ['blood volume', 'EBV', 'estimated blood volume', 'transfusion volume', 'preterm', 'term neonate', 'paediatric blood volume'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const BloodVolumeCalculator())),
  ),
  _SearchItem(
    title: 'ETT Size & Depth',
    subtitle: 'Endotracheal tube — age / NTL+1',
    category: 'Calculators & Tools',
    icon: Icons.air,
    color: _kCalcColor,
    keywords: const ['ETT', 'endotracheal tube', 'tube size', 'tube depth', 'NTL+1', 'NTL plus 1', 'intubation', 'airway', 'cuffed', 'uncuffed', 'oral ETT', 'nasal ETT', 'ET tube', 'endotracheal', 'laryngoscope', 'cole formula', 'weight based tube', 'age based tube', 'lip level', 'nostril level', 'INSURE', 'LISA'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const EttCalculator())),
  ),
  _SearchItem(
    title: 'Umbilical Catheter Depth',
    subtitle: 'UVC / UAC insertion length',
    category: 'Calculators & Tools',
    icon: Icons.linear_scale_rounded,
    color: _kCalcColor,
    keywords: const ['UVC', 'UAC', 'umbilical venous catheter', 'umbilical arterial catheter', 'umbilical line', 'shukla', 'birthweight', 'catheter depth', 'umbilical insertion', 'central line', 'umbilical stump', 'D1 diaphragm', 'T8-T10', 'L3-L4', 'high line', 'low line', 'xray confirmation', 'PICC'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const UmbilicalCatheterCalculator())),
  ),
  _SearchItem(
    title: 'Neonatal BP',
    subtitle: 'GA & day-of-life nomogram',
    category: 'Calculators & Tools',
    icon: Icons.favorite_rounded,
    color: _kCalcColor,
    keywords: const ['neonatal blood pressure', 'neonatal BP', 'neonatal hypertension', 'neonatal hypotension', 'preterm BP', 'mean BP', 'systolic BP', 'BP centile', 'zubrow', 'PMA', 'gestational age BP', 'MAP', 'mean arterial pressure', 'NIBP', 'invasive BP', 'arterial line BP'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const NeonatalBPCalculator())),
  ),
  _SearchItem(
    title: '2D Echo Calculators',
    subtitle: 'Z-scores, shortening fraction, EF, RVSP',
    category: 'Calculators & Tools',
    icon: Icons.monitor_heart_outlined,
    color: _kCalcColor,
    keywords: const ['echo', '2d echo', 'echocardiogram', 'echocardiography', 'z-score', 'shortening fraction', 'ejection fraction', 'EF', 'RVSP', 'PASP', 'PA pressure', 'cardiac', 'fractional shortening', 'TAPSE', 'LVEDD', 'LVESD', 'IVS', 'LVPW', 'aortic root', 'LA size', 'PDA', 'ASD', 'VSD', 'valve regurgitation', 'PPHN', 'TR jet', 'cardiac output', 'SVC flow'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const EchoCalculatorsScreen())),
  ),

  // ─── Emergency drug bundles ────────────────────────────────────────────────

  _SearchItem(
    title: 'Emergency NICU Drugs',
    subtitle: '14 drugs · live weight-based prep',
    category: 'Emergency',
    icon: Icons.emergency_outlined,
    color: _kEmergencyColor,
    keywords: const ['emergency drugs', 'NICU drugs', 'resuscitation drugs', 'adrenaline', 'epinephrine', 'atropine', 'naloxone', 'sodium bicarbonate', 'calcium gluconate', 'D10', 'NICU code', 'crash cart neonatal', 'neonatal emergency', 'code blue NICU', 'prostaglandin', 'PGE1', 'surfactant', 'dopamine', 'dobutamine', 'milrinone', 'phenobarbitone loading', 'volume expander'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const EmergencyNICUDrugsScreen())),
  ),
  _SearchItem(
    title: 'Emergency PICU Drugs',
    subtitle: 'STAT bolus & infusion drugs (paediatric)',
    category: 'Emergency',
    icon: Icons.emergency_outlined,
    color: _kEmergencyColor,
    keywords: const ['emergency drugs', 'PICU drugs', 'pediatric emergency', 'paediatric emergency', 'crash cart', 'resuscitation drugs', 'inotrope', 'pressor', 'STAT bolus', 'infusion drugs', 'code drugs', 'adrenaline drip', 'noradrenaline', 'code blue', 'vasopressor', 'shock drugs', 'dopamine drip', 'dobutamine drip', 'norepinephrine', 'epinephrine drip', 'vasopressin', 'hydrocortisone stress dose', 'adenosine', 'amiodarone', 'labetalol', 'nicardipine'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const EmergencyPICUDrugsScreen())),
  ),
  _SearchItem(
    title: 'Drug Formulary 2.0',
    subtitle: 'Premium UI · Neonatology + Paediatrics',
    category: 'Drug Formulary',
    icon: Icons.menu_book_rounded,
    color: _kDrugColor,
    keywords: const ['drug formulary 2.0', 'drug formulary v2', 'curated formulary', 'NICU drugs', 'paediatric drugs', 'india brands', 'cross-checked', 'WMFc', 'NNF CPG', 'AAP red book'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const FormularyV2Hub())),
  ),

  // ─── Emergency / acute clinical guides ─────────────────────────────────────

  _SearchItem(
    title: 'Acute Severe Asthma',
    subtitle: 'Stepwise management',
    category: 'Emergency',
    icon: Icons.air,
    color: _kEmergencyColor,
    keywords: const ['asthma', 'acute severe asthma', 'status asthmaticus', 'salbutamol', 'albuterol', 'ipratropium', 'magnesium sulfate', 'wheeze', 'bronchospasm', 'PEF', 'reactive airway', 'GINA'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const AcuteSevereAsthmaScreen())),
  ),
  _SearchItem(
    title: 'AVPU',
    subtitle: 'Level-of-consciousness scale',
    category: 'Emergency',
    icon: Icons.psychology_outlined,
    color: _kEmergencyColor,
    keywords: const ['AVPU', 'consciousness', 'level of consciousness', 'alert voice pain unresponsive', 'altered sensorium', 'rapid neuro', 'neuro assessment'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const AvpuScreen())),
  ),
  _SearchItem(
    title: 'GCS — Glasgow Coma Scale',
    subtitle: 'Adult & paediatric versions',
    category: 'Emergency',
    icon: Icons.psychology_outlined,
    color: _kEmergencyColor,
    keywords: const ['GCS', 'glasgow coma scale', 'paediatric GCS', 'pediatric GCS', 'consciousness', 'eye opening', 'verbal response', 'motor response', 'head injury', 'altered sensorium'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const GcsScreen())),
  ),
  _SearchItem(
    title: 'DKA Algorithm',
    subtitle: 'Diabetic ketoacidosis — paediatric',
    category: 'Emergency',
    icon: Icons.warning_amber_rounded,
    color: _kEmergencyColor,
    keywords: const ['DKA', 'diabetic ketoacidosis', 'ketoacidosis', 'insulin infusion', 'cerebral edema', 'rehydration', 'fluid bolus', 'bicarb', 'ISPAD', 'hyperglycaemia', 'type 1 diabetes', 'T1DM'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const DkaAlgorithmScreen())),
  ),
  _SearchItem(
    title: 'Electrolyte Corrections',
    subtitle: 'Na, K, Ca, Mg, PO₄ — quick reference',
    category: 'Emergency',
    icon: Icons.tune_rounded,
    color: _kEmergencyColor,
    keywords: const ['electrolyte', 'corrections', 'sodium', 'potassium', 'calcium', 'magnesium', 'phosphate', 'electrolyte imbalance', 'hyponatraemia', 'hyperkalaemia', 'hypokalaemia', 'tetany'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const ElectrolyteCorrectionsScreen())),
  ),
  _SearchItem(
    title: 'Emergency ICU Drugs',
    subtitle: 'Quick-reference dosing & infusions',
    category: 'Emergency',
    icon: Icons.bolt_rounded,
    color: _kEmergencyColor,
    keywords: const ['ICU drugs', 'emergency drugs', 'pressor', 'inotrope', 'sedation', 'paralytic', 'vasopressor', 'antiarrhythmic', 'crash cart', 'shock drugs'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const EmergencyIcuDrugsScreen())),
  ),
  _SearchItem(
    title: 'Hypertensive Emergency',
    subtitle: 'BP crisis — stepwise antihypertensives',
    category: 'Emergency',
    icon: Icons.favorite_outline,
    color: _kEmergencyColor,
    keywords: const ['hypertensive emergency', 'hypertensive crisis', 'severe hypertension', 'labetalol', 'nicardipine', 'nitroprusside', 'malignant hypertension', 'PRES', 'BP crisis', 'antihypertensive infusion'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const HypertensiveEmergencyScreen())),
  ),
  _SearchItem(
    title: 'Poisoning Antidotes',
    subtitle: 'Common poisons & antidotes',
    category: 'Emergency',
    icon: Icons.coronavirus_outlined,
    color: _kEmergencyColor,
    keywords: const ['poisoning', 'antidote', 'paracetamol overdose', 'NAC', 'N-acetylcysteine', 'organophosphate', 'pralidoxime', 'atropine OP', 'naloxone', 'opioid overdose', 'flumazenil', 'iron poisoning', 'desferrioxamine'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const PoisoningAntidotesScreen())),
  ),
  _SearchItem(
    title: 'Rapid Sequence Intubation',
    subtitle: 'RSI — drugs, doses & checklist',
    category: 'Emergency',
    icon: Icons.air,
    color: _kEmergencyColor,
    keywords: const ['RSI', 'rapid sequence intubation', 'intubation', 'sedation', 'paralysis', 'ketamine', 'rocuronium', 'succinylcholine', 'fentanyl', 'midazolam', 'pre-oxygenation', 'cricoid', 'BURP'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const RsiGuideScreen())),
  ),
  _SearchItem(
    title: 'Sedation & Paralytics',
    subtitle: 'PICU sedation & paralytic infusions',
    category: 'Emergency',
    icon: Icons.bedtime_outlined,
    color: _kEmergencyColor,
    keywords: const ['sedation', 'paralytic', 'midazolam', 'fentanyl', 'morphine', 'ketamine', 'dexmedetomidine', 'rocuronium', 'vecuronium', 'cisatracurium', 'PICU sedation', 'continuous infusion'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const SedationParalyticsScreen())),
  ),
  _SearchItem(
    title: 'Seizure Medications',
    subtitle: 'Status epilepticus pathway',
    category: 'Emergency',
    icon: Icons.bolt_outlined,
    color: _kEmergencyColor,
    keywords: const ['seizure', 'status epilepticus', 'convulsion', 'fits', 'midazolam', 'lorazepam', 'levetiracetam', 'phenytoin', 'fosphenytoin', 'phenobarbitone', 'phenobarbital', 'rectal diazepam', 'valproate'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const SeizureMedsScreen())),
  ),
  _SearchItem(
    title: 'Scorpion Sting',
    subtitle: 'Prazosin protocol',
    category: 'Emergency',
    icon: Icons.bug_report_outlined,
    color: _kEmergencyColor,
    keywords: const ['scorpion', 'scorpion sting', 'red scorpion', 'prazosin', 'pulmonary edema scorpion', 'scorpion envenomation', 'mesobuthus', 'autonomic storm'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const ScorpionStingScreen())),
  ),
  _SearchItem(
    title: 'Snake Envenomation',
    subtitle: 'ASV protocol & 20-min WBCT',
    category: 'Emergency',
    icon: Icons.bug_report_outlined,
    color: _kEmergencyColor,
    keywords: const ['snake bite', 'snake envenomation', 'ASV', 'anti-snake venom', 'WBCT', '20 minute WBCT', 'cobra', 'krait', 'viper', 'haemotoxic', 'neurotoxic', 'neostigmine', 'big four'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const SnakeEnvenomationScreen())),
  ),

  // ─── Other guides ──────────────────────────────────────────────────────────

  _SearchItem(
    title: 'Birthweight Classification',
    subtitle: 'AGA · SGA · LGA · LBW · VLBW · ELBW',
    category: 'Guides',
    icon: Icons.monitor_weight_outlined,
    color: _kGuideColor,
    keywords: const ['birthweight', 'AGA', 'SGA', 'LGA', 'LBW', 'VLBW', 'ELBW', 'low birth weight', 'classification', 'small for gestational age', 'large for gestational age'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const BirthweightClassificationScreen())),
  ),
  _SearchItem(
    title: 'Gestational Age Classification',
    subtitle: 'Term · Preterm · Post-term · WHO bands',
    category: 'Guides',
    icon: Icons.calendar_view_week_rounded,
    color: _kGuideColor,
    keywords: const ['GA classification', 'gestational age classification', 'term', 'preterm', 'late preterm', 'extremely preterm', 'very preterm', 'post-term', 'post term', 'WHO GA bands'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const GAClassificationScreen())),
  ),
  _SearchItem(
    title: 'Neonatal Echo (in-app)',
    subtitle: '23 measurements with cine reference',
    category: 'Guides',
    icon: Icons.monitor_heart,
    color: _kGuideColor,
    keywords: const ['neonatal echo', '2d echo', 'echocardiogram', 'tnecho', 'targeted neonatal echo', 'PDA', 'PPHN', 'measurements', 'M-mode', 'apical 4 chamber', 'parasternal', 'subcostal', 'cardiac measurements'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const NeonatalEchoScreen())),
  ),
  _SearchItem(
    title: 'Developmental Milestones',
    subtitle: 'Smart view · list · red flags · DQ calculator',
    category: 'Guides',
    icon: Icons.child_friendly_rounded,
    color: _kGuideColor,
    keywords: const [
      'developmental milestones', 'milestones', 'development', 'DQ',
      'developmental quotient', 'developmental delay', 'global developmental delay',
      'GDD', 'red flags', 'gross motor', 'fine motor', 'language',
      'social smile', 'pincer grasp', 'crawls', 'walks',
      'pretend play', 'social', 'hearing', 'vision',
      'developmental screening', 'denver', 'ages and stages',
      'pediatric development', 'paediatric development',
      'jargoning', 'babbling', 'cooing', 'tower of cubes', 'draw a man',
      'sits', 'rolls over', 'stands', 'speaks', 'mama dada',
      'preterm correction', 'corrected age', 'smart view',
    ],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const DevMilestonesHub())),
  ),
  _SearchItem(
    title: 'Trivandrum DSC (TDSC)',
    subtitle: 'Intelligent screening assistant · auto verdict · refer rule',
    category: 'Guides',
    icon: Icons.assignment_turned_in_outlined,
    color: _kGuideColor,
    keywords: const [
      'TDSC', 'Trivandrum', 'trivandrum dsc',
      'trivandrum developmental screening chart',
      'developmental screening', 'screening tool', 'dev screen',
      'Nair', 'CDC Trivandrum', 'Indian Pediatrics',
      'screening positive', 'suspect delay', 'refer for assessment',
      'pass fail', 'achieved milestone', 'not achieved milestone',
      'two or more fails', 'screen positive',
      'Bayley', 'DASII', 'Vineland',
      'age cursor', 'vertical line', 'classic mode', 'brown orange bar',
      'milestone bar', 'window of acquisition',
      'risk stratification', 'low risk', 'mild concern', 'moderate concern',
      'preterm correction', 'corrected age',
      'paediatric screening', 'pediatric screening', 'kerala',
    ],
    navigate: (ctx) =>
        Navigator.push(ctx, MaterialPageRoute(builder: (_) => const TdscAssistantScreen())),
  ),

  // ─── Infant BP (separate entry for discoverability) ────────────────────────

  _SearchItem(
    title: 'Infant BP (1-12 Months)',
    subtitle: 'Second Task Force 1987 — centiles & hypotension',
    category: 'Calculators & Tools',
    icon: Icons.favorite_rounded,
    color: _kCalcColor,
    keywords: const ['infant blood pressure', 'infant BP', 'baby BP', '1-12 months', 'second task force', '1987', 'task force BP', 'infant hypertension', 'infant hypotension', 'PALS hypotension', 'SBP less than 70', 'baby blood pressure', 'BP 1 year', 'BP 6 months'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const InfantBPCalculator())),
  ),

  // ─── Never Again ──────────────────────────────────────────────────────────

  _SearchItem(
    title: 'Never Again',
    subtitle: 'Anonymous peer-learning from real clinical mistakes',
    category: 'Academics',
    icon: Icons.groups_rounded,
    color: _kAcademicsColor,
    keywords: const ['never again', 'mistake', 'error', 'clinical error', 'medical error', 'peer learning', 'lesson learned', 'anonymous', 'near miss', 'adverse event', 'patient safety', 'learning from mistakes', 'what went wrong', 'root cause', 'morbidity mortality', 'M&M', 'case discussion'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const NeverAgainScreen())),
  ),

  // ─── Library / Academics ───────────────────────────────────────────────────

  _SearchItem(
    title: 'Academics',
    subtitle: 'Nelson · IAP STG · NNF CPG · Action Plan 2026',
    category: 'Academics',
    icon: Icons.school_rounded,
    color: _kAcademicsColor,
    keywords: const ['academics', 'Nelson', 'textbook', 'IAP STG', 'NNF CPG', 'IAP action plan', 'guidelines', 'chapters', 'reference', 'standard treatment guidelines', 'clinical practice guidelines', 'Nelson pediatrics', 'IAP 2026', 'action plan', 'textbook chapter', 'study material', 'protocol', 'SOP'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const AcademicsWebScreen())),
  ),
  _SearchItem(
    title: 'CME & Webinars',
    subtitle: 'Upcoming events, archive, and credits',
    category: 'Academics',
    icon: Icons.event_available_rounded,
    color: _kAcademicsColor,
    keywords: const ['CME', 'continuing medical education', 'webinar', 'workshop', 'conference', 'pedicon', 'paedicon', 'NNF', 'IAP', 'NeoUpdate', 'NRP course', 'PALS course', 'credit hours', 'registration', 'online course', 'certificate', 'medical conference', 'paediatric conference', 'training', 'hands on'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const CmeScreen())),
  ),
  _SearchItem(
    title: 'FAQ & Help',
    subtitle: 'Common questions about PediAid',
    category: 'Academics',
    icon: Icons.help_outline_rounded,
    color: _kAcademicsColor,
    keywords: const ['faq', 'help', 'support', 'how to', 'questions', 'troubleshooting'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const FaqScreen())),
  ),

  // ── Downloadable Resources ───────────────────────────────────────────────────
  // Individual entries open the Drive file directly (same pattern as the
  // BPD Estimator / INTERGROWTH-21st external links above) — a search hit
  // is a download action, not a screen to browse through.

  _SearchItem(
    title: 'Resources',
    subtitle: 'Downloadable charts, scores & templates',
    category: 'Resources',
    icon: Icons.download_rounded,
    color: _kResourceColor,
    keywords: const ['resources', 'downloads', 'pdf', 'printable', 'charts', 'templates'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const ResourcesScreen())),
  ),
  for (final r in kResourceItems)
    _SearchItem(
      title: r.title,
      subtitle: 'Resources · ${r.category}',
      category: 'Resources',
      icon: r.icon,
      color: _kResourceColor,
      keywords: [r.filename, r.category, 'pdf', 'download'],
      navigate: (ctx) => launchUrl(r.driveUri, mode: LaunchMode.externalApplication),
    ),
];

// ── Delegate ──────────────────────────────────────────────────────────────────

class AppSearchDelegate extends SearchDelegate<void> {
  AppSearchDelegate()
      : super(
            searchFieldLabel:
                'Search drugs, calculators, guides, IAP STG, NNF CPG…') {
    // Warm the guidelines + drug caches the moment the search opens so
    // the first keystroke already has the indexes in memory. Both calls
    // are idempotent — repeat invocations are free.
    GuidelinesSearchService.instance.ensureLoaded();
    // ignore: unawaited_futures
    FormularyV2Service().searchDrugs('');
  }

  late final List<_SearchItem> _allItems = _buildAllItems();

  List<_SearchItem> get _filtered {
    if (query.isEmpty) return _allItems;
    final hits = _allItems.where((i) => i.matches(query)).toList();
    // Rank by how many query words matched, so an item hitting all four words
    // sits above one that matched three of four under the one-miss rule.
    // Stable within a score, so the original curated order is preserved.
    hits.sort((a, b) => b.score(query).compareTo(a.score(query)));
    return hits;
  }

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
    final localItems = _filtered;
    final svc = GuidelinesSearchService.instance;

    // Group local matches by category, preserving insertion order.
    final grouped = <String, List<_SearchItem>>{};
    for (final item in localItems) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }

    final localTiles = grouped.entries.expand((entry) => <Widget>[
      _CategoryHeader(label: entry.key, cs: cs),
      ...entry.value.map((item) => _SearchResultTile(
            item: item,
            query: query,
            cs: cs,
            onTap: () => item.navigate(context),
          )),
    ]).toList();

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
        ...localTiles,

        // ── Drug formulary entries (Neofax + Harriet Lane v3, 676 drugs)
        // Async — searches by canonical name, alt-names and category.
        // Renders directly into the premium DrugDetailV2Screen on tap.
        if (query.trim().isNotEmpty)
          _DrugResultsSection(query: query.trim(), cs: cs),

        // ── Guideline chapters (IAP STG · IAP Action Plan 2026 · NNF CPG)
        // Async — only renders when user has typed something AND the index
        // is ready. Search is in-memory once the cache hydrates, so the
        // FutureBuilder rebuilds within ~1 frame after `ensureLoaded()`
        // resolves.
        if (query.trim().isNotEmpty)
          _GuidelineResultsSection(
            query: query.trim(),
            service: svc,
            cs: cs,
          ),

        // ── Academics library (landmark trials, guideline notes, CME events)
        // Lives on the server rather than in the app, so this is the only
        // section that needs the network. Public content — no sign-in — and
        // a failed request renders nothing rather than an error, because
        // everything above it is already on screen and usable.
        if (query.trim().isNotEmpty)
          _AcademicsResultsSection(query: query.trim(), cs: cs),

        if (query.trim().isNotEmpty && localItems.isEmpty)
          // Empty state ONLY shows once we know neither local nor
          // guideline results matched.
          _NoResultsHint(query: query, service: svc, cs: cs),
      ],
    );
  }
}

// ── Drug results section ─────────────────────────────────────────────────────
class _DrugResultsSection extends StatelessWidget {
  final String query;
  final ColorScheme cs;
  const _DrugResultsSection({required this.query, required this.cs});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DrugSearchHit>>(
      future: FormularyV2Service().searchDrugs(query),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(children: [
              SizedBox(
                width: 12, height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation(
                      cs.onSurface.withValues(alpha: 0.4)),
                ),
              ),
              const SizedBox(width: 8),
              Text('Searching drugs…',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: cs.onSurface.withValues(alpha: 0.5))),
            ]),
          );
        }
        final hits = snap.data ?? const <DrugSearchHit>[];
        if (hits.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CategoryHeader(label: 'Drugs', cs: cs),
            ...hits.map((h) => _DrugResultTile(hit: h, query: query, cs: cs)),
          ],
        );
      },
    );
  }
}

class _DrugResultTile extends StatelessWidget {
  final DrugSearchHit hit;
  final String query;
  final ColorScheme cs;
  const _DrugResultTile({
    required this.hit,
    required this.query,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final altMatched = _matchedAltName(hit.drug.altNames, query);
    final subtitleParts = <String>[
      if (altMatched != null) '"$altMatched"',
      if (hit.drug.category.isNotEmpty) hit.drug.category,
      hit.source,
      if (hit.page > 0) 'p${hit.page}',
    ];
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DrugDetailV2Screen(
            name: hit.drug.drug,
            source: hit.source,
            pdfPage: hit.page > 0 ? hit.page : 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _kDrugColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.medication_rounded,
                  color: _kDrugColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hit.drug.drug,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitleParts.join(' · '),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: cs.onSurface.withValues(alpha: 0.55),
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

  /// If the search hit landed via an alt-name (e.g. user typed "APAP" and
  /// the drug is "Paracetamol (Acetaminophen)"), surface that alt-name in
  /// the subtitle so the reader sees why the result matched.
  static String? _matchedAltName(List<String> altNames, String query) {
    final q = query.toLowerCase();
    for (final alt in altNames) {
      if (alt.toLowerCase().contains(q)) return alt;
    }
    return null;
  }
}

// ── Guideline results section ────────────────────────────────────────────────
// ── Academics results section ────────────────────────────────────────────────

class _AcademicsResultsSection extends StatelessWidget {
  final String query;
  final ColorScheme cs;
  const _AcademicsResultsSection({required this.query, required this.cs});

  static const _kColor = Color(0xFF0EA5E9);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AcademicsHit>>(
      // Results are cached per query inside the service, so the rebuild on
      // every keystroke costs one request per distinct string, not per frame.
      future: AcademicsSearchService.instance.search(query),
      builder: (context, snap) {
        // Nothing while in flight and nothing on failure: the local results
        // above are already usable, and a spinner or an error for a section
        // that may well be empty is just noise.
        final hits = snap.data ?? const <AcademicsHit>[];
        if (hits.isEmpty) return const SizedBox.shrink();

        final grouped = <String, List<AcademicsHit>>{};
        for (final h in hits) {
          grouped.putIfAbsent(h.kindLabel, () => []).add(h);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: grouped.entries.expand((entry) => <Widget>[
                _CategoryHeader(label: 'Academics · ${entry.key}', cs: cs),
                ...entry.value.map(
                  (h) => ListTile(
                    dense: true,
                    leading: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: _kColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        switch (h.kind) {
                          AcademicsHitKind.trial => Icons.science_rounded,
                          AcademicsHitKind.note => Icons.article_rounded,
                          AcademicsHitKind.event => Icons.event_available_rounded,
                        },
                        size: 17,
                        color: _kColor,
                      ),
                    ),
                    title: Text(
                      h.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    subtitle: h.subtitle.isEmpty
                        ? null
                        : Text(
                            h.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              color: cs.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AcademicsWebScreen(path: h.path),
                      ),
                    ),
                  ),
                ),
              ]).toList(),
        );
      },
    );
  }
}

class _GuidelineResultsSection extends StatelessWidget {
  final String query;
  final GuidelinesSearchService service;
  final ColorScheme cs;
  const _GuidelineResultsSection({
    required this.query,
    required this.service,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: service.ensureLoaded(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          // Cache not yet hydrated. Show a thin loading hint, no spinner —
          // the local results above are already actionable.
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(children: [
              SizedBox(
                width: 12, height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation(
                      cs.onSurface.withValues(alpha: 0.4)),
                ),
              ),
              const SizedBox(width: 8),
              Text('Searching guidelines…',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: cs.onSurface.withValues(alpha: 0.5))),
            ]),
          );
        }

        final hits = service.search(query);
        if (hits.isEmpty) return const SizedBox.shrink();

        // Group by source publication.
        final grouped = <String, List<GuidelineSearchHit>>{};
        for (final h in hits) {
          grouped.putIfAbsent(h.source.shortName, () => []).add(h);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: grouped.entries.expand((entry) => <Widget>[
                _CategoryHeader(label: entry.key, cs: cs),
                ...entry.value.map((h) => _GuidelineResultTile(
                      hit: h,
                      query: query,
                      cs: cs,
                    )),
              ]).toList(),
        );
      },
    );
  }
}

class _GuidelineResultTile extends StatelessWidget {
  final GuidelineSearchHit hit;
  final String query;
  final ColorScheme cs;
  const _GuidelineResultTile({
    required this.hit,
    required this.query,
    required this.cs,
  });

  Future<void> _open(BuildContext context) async {
    try {
      final uri = Uri.parse(hit.url);
      final ok = await launchUrl(uri,
          mode: LaunchMode.externalApplication);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the chapter PDF')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyError(e))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(hit.source.colorArgb);
    return InkWell(
      onTap: () => _open(context),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                hit.no,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hit.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    [
                      if (hit.section.isNotEmpty) hit.section,
                      hit.source.shortName,
                    ].join(' · '),
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
            Icon(Icons.open_in_new,
                size: 16, color: cs.onSurface.withValues(alpha: 0.35)),
          ],
        ),
      ),
    );
  }
}

class _NoResultsHint extends StatelessWidget {
  final String query;
  final GuidelinesSearchService service;
  final ColorScheme cs;
  const _NoResultsHint({
    required this.query,
    required this.service,
    required this.cs,
  });
  @override
  Widget build(BuildContext context) {
    // Wait for BOTH guideline + drug indexes before deciding to show
    // the empty state — either could still produce a hit.
    final guidelineFuture = service.ensureLoaded();
    final drugFuture = FormularyV2Service().searchDrugs(query);
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        guidelineFuture.then<dynamic>((_) => null),
        drugFuture,
      ]),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }
        final drugs = (snap.data?[1] as List<DrugSearchHit>?) ?? const [];
        if (service.search(query).isNotEmpty || drugs.isNotEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
          child: Column(
            children: [
              Icon(Icons.search_off_rounded,
                  size: 56,
                  color: cs.onSurface.withValues(alpha: 0.18)),
              const SizedBox(height: 14),
              Text('No results for "$query"',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: cs.onSurface.withValues(alpha: 0.45))),
              const SizedBox(height: 4),
              Text(
                  'Try a synonym, abbreviation or section name',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: cs.onSurface.withValues(alpha: 0.3))),
            ],
          ),
        );
      },
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
      case 'Drugs':               return Icons.medication_outlined;
      case 'Guides':              return Icons.menu_book_outlined;
      case 'Lab Reference':       return Icons.biotech_rounded;
      case 'Emergency':           return Icons.emergency_outlined;
      case 'Academics':           return Icons.school_rounded;
      default:                    return Icons.folder_outlined;
    }
  }

  Color _color() {
    switch (label) {
      case 'Calculators & Tools': return _kCalcColor;
      case 'Charts':              return _kChartColor;
      case 'Drug Formulary':      return _kDrugColor;
      case 'Drugs':               return _kDrugColor;
      case 'Guides':              return _kGuideColor;
      case 'Lab Reference':       return _kLabColor;
      case 'Emergency':           return _kEmergencyColor;
      case 'Academics':           return _kAcademicsColor;
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
