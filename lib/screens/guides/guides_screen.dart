import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'fetal_development_screen.dart';
import 'nrp_pdf_viewer.dart';
import '../vaccines/vaccine_screen.dart';
import 'neonatal_scores/neonatal_scores_screen.dart';
import 'modified_ballard_screen.dart';
import 'pals/pals_algorithms_screen.dart';
import '../tools/paediatric_parameters_screen.dart';
import 'polycythemia_guide_screen.dart';
import 'pofras_screen.dart';
import 'can_score_screen.dart';

class GuidesScreen extends StatelessWidget {
  const GuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                child: GridView.count(
                  crossAxisCount: cols,
                  padding: const EdgeInsets.all(14),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.1,
                  children: [
                    _GuideCard(
                      title: 'Fetal Development',
                      subtitle: 'Week-by-week from LMP',
                      icon: Icons.child_care_outlined,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const FetalDevelopmentScreen())),
                    ),
                    _GuideCard(
                      title: 'NRP 9th Edition',
                      subtitle: 'Neonatal Resuscitation Program • 9th Edition',
                      icon: Icons.menu_book,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const NrpPdfViewer())),
                    ),
                    _GuideCard(
                      title: 'Immunisation Schedule',
                      subtitle: 'IAP 2022 & National (NIS)',
                      icon: Icons.vaccines_outlined,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const VaccineScreen())),
                    ),
                    _GuideCard(
                      title: 'Neonatal Scores',
                      subtitle: 'Apgar, Downes, Sarnat, Thompson & more',
                      icon: Icons.assessment,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const NeonatalScoresScreen())),
                    ),
                    _GuideCard(
                      title: 'Modified Ballard Score',
                      subtitle: 'Gestational Age Assessment',
                      icon: Icons.child_care,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const ModifiedBallardScreen())),
                    ),
                    _GuideCard(
                      title: 'PALS Algorithms',
                      subtitle: 'Pediatric Advanced Life Support',
                      icon: Icons.monitor_heart,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const PalsAlgorithmsScreen())),
                    ),
                    _GuideCard(
                      title: 'Neonatal Echo',
                      subtitle: 'TnECHO & Neonatal Hemodynamics — NeoCardioLab',
                      icon: Icons.monitor_heart,
                      onTap: () async {
                        final uri = Uri.parse(
                            'https://www.neocardiolab.com/tnecho-and-neonatal-hemodynamics');
                        if (!await launchUrl(uri,
                            mode: LaunchMode.externalApplication)) {
                          if (context.mounted) {
                            _showComingSoon(context, 'Could not open browser');
                          }
                        }
                      },
                    ),
                    _GuideCard(
                      title: 'Paediatric Parameters',
                      subtitle: 'Parameters & Equipment — Harriet Lane',
                      icon: Icons.medical_services_outlined,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const PaediatricParametersScreen())),
                    ),
                    _GuideCard(
                      title: 'Polycythemia in Newborn',
                      subtitle: 'Management Algorithm — AIIMS Protocol',
                      icon: Icons.bloodtype,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const PolycythemiaGuideScreen())),
                    ),
                    _GuideCard(
                      title: 'POFRAS',
                      subtitle: 'Preterm Oral Feeding Readiness Assessment Scale',
                      icon: Icons.child_care_outlined,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const PofrasScreen())),
                    ),
                    _GuideCard(
                      title: 'CAN Score',
                      subtitle: 'Clinical Assessment of Nutrition at Birth',
                      icon: Icons.monitor_weight_outlined,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const CanScoreScreen())),
                    ),
                    _GuideCard(
                      title: 'Sepsis Protocols',
                      subtitle: 'Neonatal & paediatric sepsis',
                      icon: Icons.biotech_outlined,
                      comingSoon: true,
                      onTap: () => _showComingSoon(context, 'Sepsis Protocols'),
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$name — Coming Soon',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
      backgroundColor: Theme.of(context).colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }
}

class _GuideCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool comingSoon;
  final VoidCallback onTap;

  const _GuideCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.comingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final primary = comingSoon ? cs.onSurface.withValues(alpha: 0.35) : cs.primary;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: primary, size: 22),
                  ),
                  if (comingSoon)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: cs.onSurface.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('Soon',
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface.withValues(alpha: 0.4))),
                    ),
                ],
              ),
              const Spacer(),
              Container(
                width: 3, height: 14,
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
    );
  }
}
