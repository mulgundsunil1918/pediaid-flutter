// =============================================================================
// calculators/calculators_hub_screen.dart
//
// Entry point for Calculators, split the same way as Scores:
//   • Neonatal Calculators  — the NICU/neonatal tools, plain list.
//   • Paediatric Calculators — everything else, with a "Sort: by system ⇄ A–Z"
//     toggle (Sunil's requirement: only the paediatric hub gets the sort).
//
// Both open the existing CalculatorsScreen, which owns the catalogue and the
// navigation switch; this hub just tells it which slice to show and whether the
// sort control is available.
// =============================================================================

import 'package:flutter/material.dart';

import 'calculators_screen.dart';

class CalculatorsHubScreen extends StatelessWidget {
  const CalculatorsHubScreen({super.key});

  static const _neonatal = Color(0xFF1565C0);
  static const _paediatric = Color(0xFF00695C);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Calculators',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _card(
              context,
              accent: _neonatal,
              icon: Icons.child_friendly_rounded,
              title: 'Neonatal Calculators',
              subtitle:
                  'GIR, TPN, exchange transfusion, UVC/UAC, ETT, CGA/PMA, BPD & more',
              chips: const ['NICU', 'Newborn'],
              mode: CalculatorScope.neonatal,
            ),
            const SizedBox(height: 14),
            _card(
              context,
              accent: _paediatric,
              icon: Icons.calculate_rounded,
              title: 'Paediatric Calculators',
              subtitle:
                  'By system or A–Z — fluids, renal, cardiac, haematology, GI, toxicology & more',
              chips: const ['Sort by system', 'A–Z'],
              mode: CalculatorScope.paediatric,
            ),
            const SizedBox(height: 20),
            Text(
              'Every calculator states its formula and source. Decision support '
              'only — verify against your local protocol.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11.5,
                  color: cs.onSurface.withValues(alpha: 0.5)),
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
    required CalculatorScope mode,
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
              builder: (_) => CalculatorsScreen(scope: mode)),
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
                            height: 1.35,
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
