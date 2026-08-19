// =============================================================================
// screens/vaccines/immunisation_hub_screen.dart
//
// Immunisation landing hub — presents IAP, National (NIS) and Catch-up as three
// separate entries instead of tabs buried inside one screen. Each opens the
// existing VaccineScreen at the right schedule index.
// =============================================================================

import 'package:flutter/material.dart';
import 'vaccine_screen.dart';

class ImmunisationHubScreen extends StatelessWidget {
  const ImmunisationHubScreen({super.key});

  static const _iap = Color(0xFF1565C0);
  static const _nis = Color(0xFF2E7D32);
  static const _catchup = Color(0xFF6A1B9A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Vaccination / Immunisation',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _card(
              context,
              accent: _iap,
              icon: Icons.vaccines_rounded,
              title: 'IAP Schedule',
              subtitle: 'IAP–ACVIP recommended schedule',
              chips: const ['Birth → 18 y', 'IAP 2022'],
              sched: 0,
            ),
            const SizedBox(height: 14),
            _card(
              context,
              accent: _nis,
              icon: Icons.public_rounded,
              title: 'National Schedule (NIS)',
              subtitle: 'Government of India — Universal Immunisation Programme',
              chips: const ['UIP', 'Free at PHC'],
              sched: 1,
            ),
            const SizedBox(height: 14),
            _card(
              context,
              accent: _catchup,
              icon: Icons.event_repeat_rounded,
              title: 'Catch-up Immunisation',
              subtitle: 'Age-appropriate catch-up for missed / delayed doses',
              chips: const ['Rule-based', 'IAP-ACVIP'],
              sched: 2,
            ),
            const SizedBox(height: 20),
            Text(
              'Schedules are references — always confirm against the current '
              'IAP/ACVIP and national guidance for your setting.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11.5,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(
    BuildContext context, {
    required Color accent,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<String> chips,
    required int sched,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 1.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  VaccineScreen(initialSched: sched, showPicker: false)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: accent, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: accent)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 12.5,
                            color: cs.onSurface.withValues(alpha: 0.65))),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final c in chips)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(c,
                                style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: accent)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  color: cs.onSurface.withValues(alpha: 0.3)),
            ],
          ),
        ),
      ),
    );
  }
}
