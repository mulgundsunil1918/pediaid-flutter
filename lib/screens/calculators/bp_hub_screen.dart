import 'package:flutter/material.dart';
import 'neonatal_bp_calculator.dart';
import 'bp_calculator.dart';

class BPHubScreen extends StatelessWidget {
  const BPHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Pressure Calculator',
            style: TextStyle(fontWeight: FontWeight.bold, color: cs.onPrimary)),
        backgroundColor: cs.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: cs.primary.withValues(alpha: 0.4)),
              ),
              child: Text('SELECT PATIENT TYPE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.15,
                    color: cs.primary,
                  )),
            ),
            const SizedBox(height: 12),
            Text('Blood Pressure\nAssessment',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                  height: 1.2,
                )),
            const SizedBox(height: 6),
            Text(
                'Choose the appropriate reference based on patient age',
                style: TextStyle(fontSize: 13, color: cs.onSurface.withValues(alpha: 0.6))),
            const SizedBox(height: 28),

            _BPOptionCard(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const NeonatalBPCalculator())),
              icon: Icons.child_friendly,
              iconBgColor: cs.primary,
              title: 'Neonatal BP',
              subtitle: 'Preterm & Term Neonates',
              description: 'PMA 24–46 weeks\nZubrow et al. 1995',
              tag: 'NICU',
              tagColor: cs.primary,
              details: const [
                '📊 5th, 50th, 95th centiles',
                '🫀 Systolic · Diastolic · Mean BP',
                '📅 Postmenstrual age based',
              ],
            ),
            const SizedBox(height: 14),

            _BPOptionCard(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const BPCalculator())),
              icon: Icons.boy,
              iconBgColor: cs.primary,
              title: 'Paediatric BP',
              subtitle: 'Children & Adolescents',
              description: 'Age 1–17 years\nAAP Clinical Practice Guideline 2017',
              tag: 'PAEDIATRICS',
              tagColor: cs.primary,
              details: const [
                '📊 50th, 90th, 95th, 99th centiles',
                '📏 Height percentile adjusted',
                '👦 Boys & Girls separate tables',
              ],
            ),
            const Spacer(),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: cs.outline),
              ),
              child: Text(
                '⚕️ Both calculators include bedside quick reference values and clinical interpretation. For clinical use only — verify before acting.',
                style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurface.withValues(alpha: 0.6),
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _BPOptionCard extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String description;
  final String tag;
  final Color tagColor;
  final List<String> details;

  const _BPOptionCard({
    required this.onTap,
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tag,
    required this.tagColor,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outline),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            )),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: tagColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(tag,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: tagColor,
                              letterSpacing: 0.1,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 13, color: cs.onSurface.withValues(alpha: 0.6))),
                  const SizedBox(height: 6),
                  Text(description,
                      style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurface.withValues(alpha: 0.5),
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                      )),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: details
                        .map((d) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: cs.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: cs.outline),
                              ),
                              child: Text(d,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: cs.onSurface.withValues(alpha: 0.6),
                                  )),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right,
                color: cs.onSurface.withValues(alpha: 0.4), size: 22),
          ],
        ),
      ),
    );
  }
}
