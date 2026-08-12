// =============================================================================
// lib/screens/guides/guides_screen.dart
//
// Hub of every clinical guide / protocol / scoring screen in the app.
//
// Filter chips at the top let the user slice the flat list by clinical
// context (Emergency / Neonatal / Resuscitation / Scoring / Reference).
// Each guide carries `categories: List<String>` — many are double-tagged
// (NRP is both Resuscitation and Neonatal; CAN Score is both Scoring
// and Neonatal; AVPU is both Scoring and Emergency, etc.). Tap "All"
// to see everything.
// =============================================================================


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'fetal_development_screen.dart';
import 'nrp_pdf_viewer.dart';
import '../vaccines/vaccine_screen.dart';
import 'neonatal_scores/neonatal_scores_screen.dart';
import 'pals/pals_algorithms_screen.dart';
import 'neonatal_echo_screen.dart';
import '../tools/paediatric_parameters_screen.dart';
import 'polycythemia_guide_screen.dart';
import 'ga_classification_screen.dart';
import 'birthweight_classification_screen.dart';
import 'dka_algorithm_screen.dart';
import 'snake_envenomation_screen.dart';
import 'scorpion_sting_screen.dart';
import 'poisoning_antidotes_screen.dart';
import 'acute_severe_asthma_screen.dart';
import 'hypertensive_emergency_screen.dart';
import 'avpu_screen.dart';
import 'gcs_screen.dart';
import 'rsi_guide_screen.dart';
import 'electrolyte_corrections_screen.dart';
import 'emergency_icu_drugs_screen.dart';
import 'sedation_paralytics_screen.dart';
import 'seizure_meds_screen.dart';
import 'developmental_milestones/dev_milestones_hub.dart';

// ── Category catalogue ──────────────────────────────────────────────────────

const String _kAll = 'All';
const String _kEmergency = 'Emergency';
const String _kNeonatal = 'Neonatal';
const String _kResus = 'Resuscitation';
const String _kScoring = 'Scoring';
const String _kReference = 'Reference';

const List<String> _kCategories = [
  _kAll,
  _kEmergency,
  _kNeonatal,
  _kResus,
  _kScoring,
  _kReference,
];

class GuidesScreen extends StatefulWidget {
  const GuidesScreen({super.key});

  @override
  State<GuidesScreen> createState() => _GuidesScreenState();
}

class _GuidesScreenState extends State<GuidesScreen> {
  String _selected = _kAll;

  /// Guides available on this platform. See [_GuideItem.dosing].
  // All guides show on every platform, including the dose guides that were
  // hidden on iOS — see the calculators screen for the reasoning. The `dosing`
  // flags stay on the items, unused, so this is one line to reverse.
  List<_GuideItem> get _visibleGuides => _guides;

  late final List<_GuideItem> _guides = [
    // Neonatal Scores — surfaced first and highlighted; bundles all the
    // neonatal scoring tools (incl. LATCH, POFRAS, Modified Ballard).
    _GuideItem(
      title: 'Neonatal Scores',
      subtitle:
          'Apgar, Downes, Sarnat, Thompson, LATCH, POFRAS, Ballard & more',
      icon: Icons.assessment,
      categories: const [_kNeonatal, _kScoring],
      highlight: true,
      badge: '14 scores',
      build: (_) => const NeonatalScoresScreen(),
    ),
    _GuideItem(
      title: 'GA Classification',
      subtitle: 'Gestational Age Definitions · Table 6-2',
      icon: Icons.calendar_month,
      categories: const [_kNeonatal, _kReference],
      build: (_) => const GAClassificationScreen(),
    ),
    _GuideItem(
      title: 'Birthweight Classification',
      subtitle: 'ELBW · VLBW · LBW · NBW · Macrosomia',
      icon: Icons.monitor_weight_outlined,
      categories: const [_kNeonatal, _kReference],
      build: (_) => const BirthweightClassificationScreen(),
    ),
    _GuideItem(
      title: 'Fetal Development',
      subtitle: 'Week-by-week from LMP',
      icon: Icons.child_care_outlined,
      categories: const [_kNeonatal, _kReference],
      build: (_) => const FetalDevelopmentScreen(),
    ),
    _GuideItem(
      title: 'Developmental Milestones',
      subtitle:
          'AIIMS reference · 76 milestones · 23 red flags · DQ calculator',
      icon: Icons.child_friendly_rounded,
      categories: const [_kNeonatal, _kScoring, _kReference],
      build: (_) => const DevMilestonesHub(),
    ),
    _GuideItem(
      title: 'NRP 9th Edition',
      subtitle: 'Neonatal Resuscitation Program • 9th Edition',
      icon: Icons.menu_book,
      categories: const [_kResus, _kNeonatal, _kEmergency],
      build: (_) => const NrpPdfViewer(),
    ),
    _GuideItem(
      title: 'Immunisation Schedule',
      subtitle: 'IAP 2022 & National (NIS)',
      icon: Icons.vaccines_outlined,
      categories: const [_kReference],
      build: (_) => const VaccineScreen(),
    ),
    // Modified Ballard & POFRAS now live inside "Neonatal Scores" (above).
    _GuideItem(
      title: 'PALS Algorithms',
      subtitle: 'Pediatric Advanced Life Support',
      icon: Icons.monitor_heart,
      categories: const [_kResus, _kEmergency],
      build: (_) => const PalsAlgorithmsScreen(),
    ),
    _GuideItem(
      title: 'Neonatal Echo',
      subtitle: 'TnECHO & Neonatal Hemodynamics — 23 measurements',
      icon: Icons.monitor_heart,
      categories: const [_kNeonatal, _kReference],
      build: (_) => const NeonatalEchoScreen(),
    ),
    _GuideItem(
      title: 'Paediatric Parameters',
      subtitle: 'Weight-banded vital sign + equipment table',
      icon: Icons.medical_services_outlined,
      categories: const [_kReference],
      build: (_) => const PaediatricParametersScreen(),
    ),
    _GuideItem(
      title: 'Polycythemia in Newborn',
      subtitle: 'Management Algorithm — AIIMS Protocol',
      icon: Icons.bloodtype,
      categories: const [_kNeonatal],
      build: (_) => const PolycythemiaGuideScreen(),
    ),
    // CAN Score moved into Neonatal Scores screen
    // ── Emergency protocol guides ────────────────────────────────────────
    _GuideItem(
      title: 'DKA Algorithm',
      subtitle: 'Diabetic ketoacidosis — paediatric flowchart',
      icon: Icons.water_drop_outlined,
      categories: const [_kEmergency],
      build: (_) => const DkaAlgorithmScreen(),
      dosing: true,
    ),
    _GuideItem(
      title: 'Snake Envenomation',
      subtitle: 'First aid · ASV · neuro/haem/renal features',
      icon: Icons.warning_amber_rounded,
      categories: const [_kEmergency],
      build: (_) => const SnakeEnvenomationScreen(),
      dosing: true,
    ),
    _GuideItem(
      title: 'Scorpion Sting',
      subtitle: '5-stage management · ASV + Prazosin',
      icon: Icons.bug_report_outlined,
      categories: const [_kEmergency],
      build: (_) => const ScorpionStingScreen(),
    ),
    _GuideItem(
      title: 'Poisoning & Antidotes',
      subtitle: 'Substance → antidote → dose · charcoal · HD',
      icon: Icons.science_outlined,
      categories: const [_kEmergency, _kReference],
      build: (_) => const PoisoningAntidotesScreen(),
      dosing: true,
    ),
    _GuideItem(
      title: 'Acute Severe Asthma',
      subtitle: 'Status asthmaticus — drug ladder',
      icon: Icons.air_outlined,
      categories: const [_kEmergency],
      build: (_) => const AcuteSevereAsthmaScreen(),
      dosing: true,
    ),
    _GuideItem(
      title: 'Hypertensive Emergency',
      subtitle: 'Triage · IV labetalol/SNP · drug doses',
      icon: Icons.favorite_outline,
      categories: const [_kEmergency],
      build: (_) => const HypertensiveEmergencyScreen(),
      dosing: true,
    ),
    _GuideItem(
      title: 'AVPU Scale',
      subtitle: 'Level of consciousness — Alert / Voice / Pain / Unresponsive',
      icon: Icons.psychology_outlined,
      categories: const [_kScoring, _kEmergency],
      build: (_) => const AvpuScreen(),
    ),
    _GuideItem(
      title: 'Glasgow Coma Scale',
      subtitle: 'Smart scorer + paediatric reference tables',
      icon: Icons.calculate_outlined,
      categories: const [_kScoring, _kEmergency],
      build: (_) => const GcsScreen(),
      dosing: true,
    ),
    _GuideItem(
      title: 'RSI — Rapid Sequence Intubation',
      subtitle: '7 P\'s + drug table + 5 scenario sequences',
      icon: Icons.air_outlined,
      categories: const [_kEmergency, _kResus],
      build: (_) => const RsiGuideScreen(),
      dosing: true,
    ),
    _GuideItem(
      title: 'Electrolyte Corrections',
      subtitle: 'Treatment + work-up + cross-linked calculators',
      icon: Icons.water_drop_outlined,
      categories: const [_kReference, _kEmergency],
      build: (_) => const ElectrolyteCorrectionsScreen(),
      dosing: true,
    ),
    _GuideItem(
      title: 'Emergency ICU Drugs',
      subtitle: 'Bolus + vasoactive infusion drug doses',
      icon: Icons.medical_services_outlined,
      categories: const [_kEmergency, _kReference],
      build: (_) => const EmergencyIcuDrugsScreen(),
      dosing: true,
    ),
    _GuideItem(
      title: 'Sedation, Analgesia & Paralytics',
      subtitle: 'PICU/NICU infusion reference (18 drugs)',
      icon: Icons.bedtime_outlined,
      categories: const [_kEmergency, _kReference],
      build: (_) => const SedationParalyticsScreen(),
      dosing: true,
    ),
    _GuideItem(
      title: 'Seizure Medications',
      subtitle: 'Status epilepticus ladder + reference table',
      icon: Icons.flash_on_outlined,
      categories: const [_kEmergency, _kReference],
      build: (_) => const SeizureMedsScreen(),
      dosing: true,
    ),
    _GuideItem(
      title: 'Sepsis Protocols',
      subtitle: 'Neonatal & paediatric sepsis',
      icon: Icons.biotech_outlined,
      categories: const [_kEmergency, _kNeonatal],
      comingSoon: true,
      build: null, // shows coming-soon snackbar instead of navigating
    ),
  ];

  List<_GuideItem> get _filtered => _selected == _kAll
      ? _visibleGuides
      : _visibleGuides.where((g) => g.categories.contains(_selected)).toList();

  int _countFor(String category) {
    if (category == _kAll) return _visibleGuides.length;
    return _visibleGuides.where((g) => g.categories.contains(category)).length;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Guides'),
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
                                final g = filtered[index];
                                return _GuideCard(
                                  title: g.title,
                                  subtitle: g.subtitle,
                                  icon: g.icon,
                                  comingSoon: g.comingSoon,
                                  highlight: g.highlight,
                                  badge: g.badge,
                                  onTap: () {
                                    if (g.comingSoon || g.build == null) {
                                      _showComingSoon(context, g.title);
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: g.build!),
                                      );
                                    }
                                  },
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

  void _showComingSoon(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$name — Coming Soon',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ── Reusable category-chip strip ────────────────────────────────────────────

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final cat in categories)
            _chip(
              cs,
              label: cat,
              count: countFor(cat),
              selected: cat == selected,
              onTap: () => onSelect(cat),
            ),
        ],
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

class _GuideItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> categories;
  final WidgetBuilder? build;
  /// Contains per-kilogram drug doses.
  ///
  /// App Store guideline 1.4.2 restricts drug dosage tools to manufacturers,
  /// hospitals, universities and similar approved entities. A lookup table of
  /// mg/kg is the same thing as a calculator for that purpose, so these are
  /// withheld on iOS only. Android and web are unaffected.
  final bool dosing;

  final bool comingSoon;
  final bool highlight;
  final String? badge;

  _GuideItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.categories,
    required this.build,
    this.dosing = false,
    this.comingSoon = false,
    this.highlight = false,
    this.badge,
  });
}

class _GuideCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool comingSoon;
  final bool highlight;
  final String? badge;
  final VoidCallback onTap;

  const _GuideCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.comingSoon = false,
    this.highlight = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Highlighted tiles get a distinct accent colour + filled background.
    const accent = Color(
      0xFF7C3AED,
    ); // violet — stands out from the primary blue
    final primary = comingSoon
        ? cs.onSurface.withValues(alpha: 0.35)
        : (highlight ? accent : cs.primary);
    return Container(
      decoration: highlight
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accent.withValues(alpha: 0.20),
                  accent.withValues(alpha: 0.06),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.22),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            )
          : null,
      child: Card(
        elevation: highlight ? 0 : 2,
        color: highlight ? Colors.transparent : Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: highlight
              ? BorderSide(color: accent.withValues(alpha: 0.6), width: 1.6)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: highlight
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  accent,
                                  accent.withValues(alpha: 0.78),
                                ],
                              )
                            : null,
                        color: highlight
                            ? null
                            : primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: highlight
                            ? [
                                BoxShadow(
                                  color: accent.withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        icon,
                        color: highlight ? Colors.white : primary,
                        size: 22,
                      ),
                    ),
                    if (badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      )
                    else if (comingSoon)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: cs.onSurface.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Soon',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                  ],
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
                  title,
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
                  subtitle,
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.55),
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
