// =============================================================================
// lib/deep_links.dart
//
// Web-only URL deep-linking. The app has no internal router (every screen is
// reached via Navigator.push from the previous one, so the browser URL never
// changes) — that's fine for in-app navigation, but it means a link from an
// external page (e.g. an SEO landing page on info.pediaid.bridgr.co.in) can't
// land a visitor on a specific tool.
//
// This file adds a narrow, additive fix: on web boot, read the URL's hash
// fragment (e.g. pediaid.bridgr.co.in/#fenton-growth-chart), look it up here,
// and push that one screen on top of the normal boot flow. It does not touch
// routing anywhere else in the app — every existing Navigator.push call site
// is untouched, and in-app navigation behaves exactly as before.
//
// Slugs here MUST stay in sync with landing/tools_data.json (the SEO catalog)
// — each slug is the anchor the marketing site links to.
//
// A few tools link straight to an external site in-app (BPD Estimator,
// INTERGROWTH-21st, Neonatal Echo/TnECHO guide) — those have no in-app screen
// to deep-link to, so they're intentionally left out of this map; their SEO
// pages link straight to the external URL instead.
// =============================================================================

import 'package:flutter/material.dart';

import 'screens/calculators/gestational_age_calculator.dart';
import 'screens/calculators/ponderal_index_calculator.dart';
import 'screens/calculators/bsa_calculator.dart';
import 'screens/calculators/nutritional_audit_calculator.dart';
import 'screens/calculators/tpn_calculator.dart';
import 'screens/calculators/cga_pma_calculator.dart';
import 'screens/calculators/gir_calculator.dart';
import 'screens/calculators/schwartz_egfr_calculator.dart';
import 'screens/calculators/blood_gas_analyser.dart';
import 'screens/calculators/double_volume_exchange.dart';
import 'screens/calculators/ventilator_parameters.dart';
import 'screens/calculators/bp_hub_screen.dart';
import 'screens/calculators/jaundice_hub_screen.dart';
import 'screens/calculators/maintenance_fluid_calculator.dart';
import 'screens/calculators/parkland_calculator_screen.dart';
import 'screens/calculators/lund_browder_screen.dart';
import 'screens/calculators/pet_calculator_screen.dart';
import 'screens/calculators/burn_mortality_calculator.dart';
import 'screens/calculators/anion_gap_calculator.dart';
import 'screens/calculators/corrected_anion_gap_calculator.dart';
import 'screens/calculators/urine_anion_gap_calculator.dart';
import 'screens/calculators/sodium_correction_calculator.dart';
import 'screens/calculators/corrected_sodium_calculator.dart';
import 'screens/calculators/free_water_deficit_calculator.dart';
import 'screens/calculators/potassium_correction_calculator.dart';
import 'screens/calculators/calcium_correction_calculator.dart';
import 'screens/calculators/magnesium_correction_calculator.dart';
import 'screens/calculators/dextrose_bolus_calculator.dart';
import 'screens/calculators/serum_osmolality_calculator.dart';
import 'screens/calculators/blood_volume_calculator.dart';
import 'screens/calculators/ett_calculator.dart';
import 'screens/calculators/umbilical_catheter_calculator.dart';
import 'screens/calculators/neonatal_bp_calculator.dart';
import 'screens/calculators/echo_calculators_screen.dart';
import 'screens/calculators/infant_bp_calculator.dart';
import 'screens/calculators/mid_parental_height_calculator.dart';

import 'screens/charts/who_chart_selection_screen.dart';
import 'screens/charts/iap_chart_screen.dart';
import 'screens/charts/fenton_chart_screen.dart';

import 'screens/formulary/formulary_screen.dart';

import 'screens/guides/fetal_development_screen.dart';
import 'screens/guides/nrp_pdf_viewer.dart';
import 'screens/vaccines/immunisation_hub_screen.dart';
import 'screens/guides/neonatal_scores/neonatal_scores_screen.dart';
import 'screens/guides/modified_ballard_screen.dart';
import 'screens/guides/pals/pals_algorithms_screen.dart';
import 'screens/tools/paediatric_parameters_screen.dart';
import 'screens/guides/polycythemia_guide_screen.dart';
import 'screens/guides/pofras_screen.dart';
import 'screens/guides/can_score_screen.dart';
import 'screens/lab_reference/lab_reference_screen.dart';
import 'screens/drugs/emergency_nicu_drugs_screen.dart';
import 'screens/drugs/emergency_picu_drugs_screen.dart';
import 'screens/guides/acute_severe_asthma_screen.dart';
import 'screens/guides/avpu_screen.dart';
import 'screens/guides/gcs_screen.dart';
import 'screens/guides/dka_algorithm_screen.dart';
import 'screens/guides/electrolyte_corrections_screen.dart';
import 'screens/guides/emergency_icu_drugs_screen.dart';
import 'screens/guides/hypertensive_emergency_screen.dart';
import 'screens/guides/poisoning_antidotes_screen.dart';
import 'screens/guides/rsi_guide_screen.dart';
import 'screens/guides/sedation_paralytics_screen.dart';
import 'screens/guides/seizure_meds_screen.dart';
import 'screens/guides/scorpion_sting_screen.dart';
import 'screens/guides/snake_envenomation_screen.dart';
import 'screens/guides/birthweight_classification_screen.dart';
import 'screens/guides/ga_classification_screen.dart';
import 'screens/guides/neonatal_echo_screen.dart';
import 'screens/guides/developmental_milestones/dev_milestones_hub.dart';
import 'screens/guides/developmental_milestones/tdsc/tdsc_assistant_screen.dart';
import 'screens/never_again/never_again_screen.dart';
import 'screens/cme/cme_screen.dart';
import 'screens/faq_screen.dart';
import 'academics/academics_web_screen.dart';

/// slug -> screen builder. Keys must match landing/tools_data.json exactly.
final Map<String, WidgetBuilder> deepLinkRoutes = {
  'gestational-age-edd-calculator': (_) => const GestationalAgeCalculator(),
  'ponderal-index-calculator': (_) => const PonderalIndexCalculator(),
  'bsa-calculator-pediatric': (_) => const BSACalculator(),
  'nutritional-audit-calculator': (_) => const NutritionalAuditCalculator(),
  'tpn-calculator-neonatal': (_) => const TpnCalculator(),
  'cga-pma-calculator': (_) => const CGAPMACalculator(),
  'gir-calculator-neonatal': (_) => const GIRCalculator(),
  'schwartz-egfr-calculator': (_) => const SchwartzEGFRCalculator(),
  'blood-gas-analyser': (_) => const BloodGasAnalyser(),
  'double-volume-exchange-transfusion-calculator': (_) => const DoubleVolumeExchange(),
  'ventilator-parameters-calculator': (_) => const VentilatorParameters(),
  'pediatric-blood-pressure-calculator': (_) => const BPHubScreen(),
  'neonatal-jaundice-bilirubin-calculator': (_) => const JaundiceHubScreen(),
  'maintenance-fluid-calculator-pediatric': (_) => const MaintenanceFluidCalculator(),
  'parkland-formula-calculator': (_) => const ParklandCalculatorScreen(),
  'lund-browder-chart-calculator': (_) => const LundBrowderScreen(),
  'partial-exchange-transfusion-calculator': (_) => const PETCalculatorScreen(),
  'burn-mortality-calculator-baux': (_) => const BurnMortalityCalculator(),

  'who-growth-charts': (_) => const WhoChartSelectionScreen(),
  'iap-growth-charts': (_) => const IAPChartScreen(),
  'fenton-growth-chart': (_) => const FentonChartScreen(),

  'pediatric-drug-formulary': (_) => const FormularyScreen(),
  // Drug 2.0 is hidden for now — keep the old deep-link working by pointing it
  // at the book-based formulary instead of the (unreferenced) v2 hub.
  'drug-formulary-v2': (_) => const FormularyScreen(),

  'fetal-development-week-by-week': (_) => const FetalDevelopmentScreen(),
  'nrp-algorithm-neonatal-resuscitation': (_) => const NrpPdfViewer(),
  'iap-immunization-schedule': (_) => const ImmunisationHubScreen(),
  'neonatal-scoring-systems': (_) => const NeonatalScoresScreen(),
  'nichd-hie-assessment-tool': (_) => const NeonatalScoresScreen(),
  'modified-ballard-score-calculator': (_) => const ModifiedBallardScreen(),
  'pals-algorithms': (_) => const PalsAlgorithmsScreen(),
  'pediatric-equipment-parameters': (_) => const PaediatricParametersScreen(),
  'neonatal-polycythemia-management': (_) => const PolycythemiaGuideScreen(),
  'pofras-feeding-readiness-scale': (_) => const PofrasScreen(),
  'can-score-nutrition-assessment': (_) => const CanScoreScreen(),

  'pediatric-lab-reference-values': (_) => const LabReferenceScreen(),

  'anion-gap-calculator': (_) => const AnionGapCalculator(),
  'corrected-anion-gap-calculator': (_) => const CorrectedAnionGapCalculator(),
  'urine-anion-gap-calculator': (_) => const UrineAnionGapCalculator(),
  'sodium-correction-calculator': (_) => const SodiumCorrectionCalculator(),
  'corrected-sodium-calculator-glucose': (_) => const CorrectedSodiumCalculator(),
  'free-water-deficit-calculator': (_) => const FreeWaterDeficitCalculator(),
  'potassium-correction-calculator': (_) => const PotassiumCorrectionCalculator(),
  'calcium-correction-calculator': (_) => const CalciumCorrectionCalculator(),
  'magnesium-correction-calculator': (_) => const MagnesiumCorrectionCalculator(),
  'dextrose-bolus-calculator-hypoglycemia': (_) => const DextroseBolusCalculator(),
  'serum-osmolality-calculator': (_) => const SerumOsmolalityCalculator(),
  'pediatric-blood-volume-calculator': (_) => const BloodVolumeCalculator(),
  'ett-size-depth-calculator': (_) => const EttCalculator(),
  'umbilical-catheter-depth-calculator': (_) => const UmbilicalCatheterCalculator(),
  'neonatal-blood-pressure-calculator': (_) => const NeonatalBPCalculator(),
  'pediatric-echo-calculators': (_) => const EchoCalculatorsScreen(),

  'emergency-nicu-drugs': (_) => const EmergencyNICUDrugsScreen(),
  'emergency-picu-drugs': (_) => const EmergencyPICUDrugsScreen(),

  'acute-severe-asthma-management': (_) => const AcuteSevereAsthmaScreen(),
  'avpu-scale-calculator': (_) => const AvpuScreen(),
  'pediatric-glasgow-coma-scale-calculator': (_) => const GcsScreen(),
  'pediatric-dka-algorithm': (_) => const DkaAlgorithmScreen(),
  'electrolyte-corrections-reference': (_) => const ElectrolyteCorrectionsScreen(),
  'emergency-icu-drugs-reference': (_) => const EmergencyIcuDrugsScreen(),
  'pediatric-hypertensive-emergency-management': (_) => const HypertensiveEmergencyScreen(),
  'poisoning-antidotes-reference': (_) => const PoisoningAntidotesScreen(),
  'rapid-sequence-intubation-guide': (_) => const RsiGuideScreen(),
  'picu-sedation-paralytics-guide': (_) => const SedationParalyticsScreen(),
  'seizure-medication-status-epilepticus': (_) => const SeizureMedsScreen(),
  'scorpion-sting-management': (_) => const ScorpionStingScreen(),
  'snake-bite-envenomation-management': (_) => const SnakeEnvenomationScreen(),

  'birthweight-classification-elbw-vlbw-lbw': (_) => const BirthweightClassificationScreen(),
  'gestational-age-classification': (_) => const GAClassificationScreen(),
  'neonatal-echo-measurements-tool': (_) => const NeonatalEchoScreen(),
  'developmental-milestones-checker': (_) => const DevMilestonesHub(),
  'trivandrum-developmental-screening-chart': (_) => const TdscAssistantScreen(),

  'infant-blood-pressure-calculator': (_) => const InfantBPCalculator(),

  'never-again-clinical-lessons': (_) => const NeverAgainScreen(),

  'pediatric-textbooks-guidelines-academics': (_) => const AcademicsWebScreen(),
  'pediatric-cme-webinars': (_) => const CmeScreen(),
  'pediaid-faq-help': (_) => const FaqScreen(),

  'mid-parental-height-calculator': (_) => const MidParentalHeightCalculator(),
};

/// Reads the URL hash fragment (web only) and returns the matching builder,
/// if any. `pediaid.bridgr.co.in/#fenton-growth-chart` -> fragment is
/// `fenton-growth-chart`.
WidgetBuilder? resolveDeepLink() {
  final slug = Uri.base.fragment.trim();
  if (slug.isEmpty) return null;
  return deepLinkRoutes[slug];
}
