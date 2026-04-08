import 'package:flutter/material.dart';
import 'bilirubin_calculator.dart';

class JaundiceHubScreen extends StatelessWidget {
  const JaundiceHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Neonatal Jaundice',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: cs.onPrimary)),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF5A623).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFF5A623).withValues(alpha: 0.5)),
              ),
              child: const Text('SELECT GESTATIONAL AGE GROUP',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.15,
                    color: Color(0xFFF5A623),
                  )),
            ),
            const SizedBox(height: 12),
            Text('Neonatal Jaundice\nAssessment',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                  height: 1.2,
                )),
            const SizedBox(height: 6),
            Text(
                'Choose the guideline based on gestational age at birth',
                style:
                    TextStyle(fontSize: 13, color: cs.onSurface.withValues(alpha: 0.6))),
            const SizedBox(height: 28),

            _JaundiceOptionCard(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const BilirubinCalculator())),
              isActive: true,
              icon: Icons.child_care,
              iconBgColor: const Color(0xFFF5A623),
              title: '≥ 35 Weeks',
              subtitle: 'Term & Late Preterm',
              description:
                  'AAP 2022 Guideline\nKemper AR et al. Pediatrics 2022',
              tag: 'AAP 2022',
              tagColor: const Color(0xFFF5A623),
              details: const [
                '📊 Hour-specific TSB thresholds',
                '🔬 Phototherapy + Exchange transfusion',
                '⚠️ Neurotoxicity risk factors',
                '🩸 Bilirubin:Albumin ratio',
              ],
            ),
            const SizedBox(height: 14),

            _JaundiceOptionCard(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'NICE Guidelines (<35 weeks) — Coming Soon',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: cs.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              ),
              isActive: false,
              icon: Icons.baby_changing_station,
              iconBgColor: Colors.grey,
              title: '< 35 Weeks',
              subtitle: 'Preterm Infants',
              description: 'NICE Guidelines\nNICE NG98 — Coming Soon',
              tag: 'COMING SOON',
              tagColor: Colors.grey,
              details: const [
                '📊 Gestation-specific thresholds',
                '🔬 Phototherapy levels by week',
                '📅 Postnatal age based',
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
                '⚕️ Use TSB (not TcB) for all treatment decisions. Do NOT subtract direct bilirubin from TSB. For clinical use only.',
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

class _JaundiceOptionCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool isActive;
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String description;
  final String tag;
  final Color tagColor;
  final List<String> details;

  const _JaundiceOptionCard({
    required this.onTap,
    required this.isActive,
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
      child: Opacity(
        opacity: isActive ? 1.0 : 0.55,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? tagColor.withValues(alpha: 0.4)
                  : cs.outline,
              width: isActive ? 1.5 : 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
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
                    Row(children: [
                      Expanded(
                        child: Text(title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            )),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color:
                              tagColor.withValues(alpha: 0.12),
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
                    ]),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 13,
                            color: cs.onSurface.withValues(alpha: 0.6))),
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
                                  borderRadius:
                                      BorderRadius.circular(20),
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
                    if (!isActive) ...[
                      const SizedBox(height: 8),
                      Row(children: [
                        Icon(Icons.lock_outline,
                            size: 14, color: cs.onSurface.withValues(alpha: 0.4)),
                        const SizedBox(width: 4),
                        Text(
                            'Coming Soon — NICE NG98 data being prepared',
                            style: TextStyle(
                                fontSize: 11,
                                color: cs.onSurface.withValues(alpha: 0.4),
                                fontStyle: FontStyle.italic)),
                      ]),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isActive
                    ? Icons.chevron_right
                    : Icons.lock_outline,
                color: cs.onSurface.withValues(alpha: 0.4),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
