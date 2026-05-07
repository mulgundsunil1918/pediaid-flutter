import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/guidelines_search_service.dart';
import '../../services/formulary_v2_service.dart';
import '../../utils/friendly_error.dart';

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
import '../../academics/academics_web_screen.dart';

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

const _kCalcColor      = Color(0xFF1565C0);
const _kChartColor     = Color(0xFF6A1B9A);
const _kDrugColor      = Color(0xFF00695C);
const _kGuideColor     = Color(0xFF6D4C41);
const _kLabColor       = Color(0xFF00838F);
const _kEmergencyColor = Color(0xFFB71C1C);
const _kAcademicsColor = Color(0xFF7C3AED);

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
    keywords: const ['sodium', 'hyponatraemia', 'hyponatremia', 'hypernatraemia', 'hypernatremia', 'na correction', 'osmotic demyelination', 'central pontine', '3% saline', 'hypertonic saline', 'free water'],
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
    keywords: const ['potassium', 'k correction', 'hypokalaemia', 'hypokalemia', 'hyperkalaemia', 'hyperkalemia', 'KCl', 'potassium chloride', 'IV potassium', 'oral potassium'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const PotassiumCorrectionCalculator())),
  ),
  _SearchItem(
    title: 'Calcium Correction',
    subtitle: 'Hypocalcaemia / albumin-corrected',
    category: 'Calculators & Tools',
    icon: Icons.bolt_outlined,
    color: _kCalcColor,
    keywords: const ['calcium', 'ca correction', 'hypocalcaemia', 'hypocalcemia', 'corrected calcium', 'albumin', 'ionised calcium', 'tetany', 'gluconate'],
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
    keywords: const ['dextrose bolus', 'D10', '2 mL/kg', 'hypoglycaemia', 'hypoglycemia', 'minibolus', 'mini bolus', 'glucose bolus', 'low blood sugar', 'neonatal hypoglycaemia'],
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
    keywords: const ['ETT', 'endotracheal tube', 'tube size', 'tube depth', 'NTL+1', 'NTL plus 1', 'intubation', 'airway', 'cuffed', 'uncuffed', 'oral ETT', 'nasal ETT'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const EttCalculator())),
  ),
  _SearchItem(
    title: 'Umbilical Catheter Depth',
    subtitle: 'UVC / UAC insertion length',
    category: 'Calculators & Tools',
    icon: Icons.linear_scale_rounded,
    color: _kCalcColor,
    keywords: const ['UVC', 'UAC', 'umbilical venous catheter', 'umbilical arterial catheter', 'umbilical line', 'shukla', 'birthweight', 'catheter depth', 'umbilical insertion'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const UmbilicalCatheterCalculator())),
  ),
  _SearchItem(
    title: 'Neonatal BP',
    subtitle: 'GA & day-of-life nomogram',
    category: 'Calculators & Tools',
    icon: Icons.favorite_rounded,
    color: _kCalcColor,
    keywords: const ['neonatal blood pressure', 'neonatal BP', 'neonatal hypertension', 'neonatal hypotension', 'preterm BP', 'mean BP', 'systolic BP', 'BP centile'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const NeonatalBPCalculator())),
  ),
  _SearchItem(
    title: '2D Echo Calculators',
    subtitle: 'Z-scores, shortening fraction, EF, RVSP',
    category: 'Calculators & Tools',
    icon: Icons.monitor_heart_outlined,
    color: _kCalcColor,
    keywords: const ['echo', '2d echo', 'echocardiogram', 'echocardiography', 'z-score', 'shortening fraction', 'ejection fraction', 'EF', 'RVSP', 'PASP', 'PA pressure', 'cardiac', 'fractional shortening', 'TAPSE', 'LVEDD'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const EchoCalculatorsScreen())),
  ),

  // ─── Emergency drug bundles ────────────────────────────────────────────────

  _SearchItem(
    title: 'Emergency NICU Drugs',
    subtitle: '14 drugs · live weight-based prep',
    category: 'Emergency',
    icon: Icons.emergency_outlined,
    color: _kEmergencyColor,
    keywords: const ['emergency drugs', 'NICU drugs', 'resuscitation drugs', 'adrenaline', 'epinephrine', 'atropine', 'naloxone', 'sodium bicarbonate', 'calcium gluconate', 'D10', 'NICU code', 'crash cart neonatal'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const EmergencyNICUDrugsScreen())),
  ),
  _SearchItem(
    title: 'Emergency PICU Drugs',
    subtitle: 'STAT bolus & infusion drugs (paediatric)',
    category: 'Emergency',
    icon: Icons.emergency_outlined,
    color: _kEmergencyColor,
    keywords: const ['emergency drugs', 'PICU drugs', 'pediatric emergency', 'paediatric emergency', 'crash cart', 'resuscitation drugs', 'inotrope', 'pressor', 'STAT bolus', 'infusion drugs', 'code drugs', 'adrenaline drip', 'noradrenaline'],
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
    subtitle: 'AIIMS reference · smart view · DQ calculator',
    category: 'Guides',
    icon: Icons.child_friendly_rounded,
    color: _kGuideColor,
    keywords: const [
      'developmental milestones', 'milestones', 'development', 'DQ',
      'developmental quotient', 'developmental delay', 'global developmental delay',
      'GDD', 'red flags', 'gross motor', 'fine motor', 'language',
      'social smile', 'pincer grasp', 'crawls', 'walks',
      'pretend play', 'social', 'hearing', 'vision',
      'AIIMS', 'Sheffali Gulati', 'Trivandrum', 'TDSC',
      'developmental screening', 'denver', 'ages and stages',
      'pediatric development', 'paediatric development',
      'jargoning', 'babbling', 'cooing', 'tower of cubes', 'draw a man',
    ],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const DevMilestonesHub())),
  ),

  // ─── Library / Academics ───────────────────────────────────────────────────

  _SearchItem(
    title: 'Academics',
    subtitle: 'Nelson · IAP STG · NNF CPG · Action Plan 2026',
    category: 'Academics',
    icon: Icons.school_rounded,
    color: _kAcademicsColor,
    keywords: const ['academics', 'Nelson', 'textbook', 'IAP STG', 'NNF CPG', 'IAP action plan', 'guidelines', 'chapters', 'reference'],
    navigate: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const AcademicsWebScreen())),
  ),
  _SearchItem(
    title: 'CME & Webinars',
    subtitle: 'Upcoming events, archive, and credits',
    category: 'Academics',
    icon: Icons.event_available_rounded,
    color: _kAcademicsColor,
    keywords: const ['CME', 'continuing medical education', 'webinar', 'workshop', 'conference', 'paedicon', 'NNF', 'IAP'],
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
