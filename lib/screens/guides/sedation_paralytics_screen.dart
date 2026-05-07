// =============================================================================
// guides/sedation_paralytics_screen.dart
// SEDATION, ANALGESIA & PARALYTICS (INFUSION).
// =============================================================================

import 'package:flutter/material.dart';
import '_emergency_guide_widgets.dart';

class _Drug {
  final String name;
  final String dose;
  final String dilution;
  final String infusionRate;
  const _Drug(this.name, this.dose, this.dilution, this.infusionRate);
}

const List<_Drug> _drugs = [
  _Drug('Morphine', '20–60 µg/kg/hr', 'Wt × 1 mg/kg in 50 mL 5 % D', '1–3 mL/hr'),
  _Drug('Fentanyl', '1–4 µg/kg/hr',
      'Children (< 20 kg): 1 mL = 50 µg vial, take 4 mL in 16 mL NS thus 1 mL = 10 µg.\n'
          'Children (> 20 kg): 1 mL = 50 µg vial, take 8 mL in 12 mL NS thus 1 mL = 20 µg',
      'Children < 20 kg: 0.1–0.4 mL/kg/hr ; Children > 20 kg: 0.2–0.8 mL/kg/hr'),
  _Drug('Midazolam', '1.6–8 µg/kg/min', 'UNDILUTED 1 mL = 1 mg', '0.1–0.5 mL/kg/hr'),
  _Drug('Ketamine', '10–40 µg/kg/min', 'WEIGHT × 30 mg/kg in 50 mL NS', '1–4 mL/hr'),
  _Drug('Dexmedetomidine', '0.2–0.7 µg/kg/hr', '1 mL (100 mcg) in 24 mL NS, 1 mL = 4 mcg', '0.05–0.2 mL/kg/hr'),
  _Drug('Vecuronium', '0.05–0.15 mg/kg/hr',
      '4 mg diluted with 4 mL NS (1 mL = 1 mg) take 2 mL in 8 mL NS (1 mL = 0.2 mg)',
      '0.25–1.3 mL/kg/hr'),
  _Drug('Pancuronium', '0.02–0.06 mg/kg/hr', '(1 mL = 2 mg) take 1 mL in 9 mL NS (1 mL = 0.2 mg)', '0.1–0.3 mL/kg/hr'),
  _Drug('Rocuronium', '0.6–0.8 mg/kg/h', '', ''),
  _Drug('Atracurium', '1–1.5 mg/kg/h', '', ''),
  _Drug('Cis-atracurium', '0.2 mg/kg/h', '', ''),
  _Drug('IV Clonidine', '1–3 mcg/kg/hr', 'IV over 10 min followed by 5 mg/kg/day', ''),
  _Drug('Phenobarbitone', '10 mg/kg/day', '', ''),
  _Drug('Propofol', '1–6 mg/kg/hr', '(Maximum single dose 12.5 mg)', ''),
  _Drug('Promethazine oral', '1 mg/kg/day Q 6–8 h', '(Maximum single dose 50 mg)', ''),
  _Drug('Diphenhydramine oral', '0.5–1 mg/kg/day Q 4–6 hourly', '(Maximum dose 1.2 mg daily)', ''),
  _Drug('Clonidine oral', '5 mcg/kg/day Q 6 hourly', '(Maximum single dose 50 mg)', ''),
  _Drug('Chlorpromazine', '0.5 mg/kg dose every 6–8 h', '(Maximum single dose 5 mg)', ''),
  _Drug('Haloperidol', '0.01–0.02 mg/kg/day Q 8–12 hourly', '', ''),
];

class SedationParalyticsScreen extends StatelessWidget {
  const SedationParalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return EgScaffold(
      title: 'Sedation, Analgesia & Paralytics',
      subtitle: 'PICU / NICU continuous infusion reference. Doses + '
          'dilutions + bedside infusion rate.',
      children: [
        const EgSectionLabel('Drugs', ''),
        ..._drugs.map((d) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border(
                    left: const BorderSide(color: emergencyBrand, width: 4),
                    top: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
                    right: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
                    bottom: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(d.name,
                              style: TextStyle(
                                color: cs.onSurface,
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: emergencyBrand,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(d.dose,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                              )),
                        ),
                      ],
                    ),
                    if (d.dilution.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('DILUTION',
                          style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.55),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          )),
                      const SizedBox(height: 2),
                      Text(d.dilution,
                          style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.85),
                            fontSize: 12.5,
                            height: 1.5,
                          )),
                    ],
                    if (d.infusionRate.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('IV INFUSION RATE',
                          style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.55),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          )),
                      const SizedBox(height: 2),
                      Text(d.infusionRate,
                          style: TextStyle(
                            color: emergencyBrand,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          )),
                    ],
                  ],
                ),
              ),
            )),

        // ── Sedation holiday ────────────────────────────────────────────
        const EgSectionLabel('Sedation holiday', '  Daily protocol'),
        const EgCard(
          child: EgBulletList(numbered: true, items: [
            'Stopping sedation infusion from early morning for a few hours '
                'and allowing the child to wake up.',
            'This reduces risk of VAP and allows better neurological '
                'assessment.',
            'If child is agitated or uncomfortable, re-start sedation.',
            'Should not be done in very sick children (ARDS with high '
                'ventilatory settings, kids with deteriorating courses of '
                'disease, etc.).',
          ]),
        ),

        const EgPearl(
          title: 'Pitfalls (research add-on)',
          body:
              '• Propofol infusion syndrome — risk > 4 mg/kg/hr beyond 48 h. '
              'Watch for metabolic acidosis, rhabdomyolysis, cardiac '
              'failure.\n'
              '• Ketamine — increases salivary secretions; pre-treat with '
              'glycopyrrolate.\n'
              '• Vecuronium / rocuronium — accumulate in renal/liver '
              'failure; prefer atracurium / cisatracurium (Hofmann '
              'elimination — degraded by plasma esterase).\n'
              '• Midazolam — prolonged sedation, immunosuppression; '
              'intubate if used following benzodiazepines.',
        ),

        const EgReferenceCard(
          text:
              'Sedation, '
              'Analgesia & Paralytics (Infusion) table. For use by '
              'qualified clinicians only — verify doses against local '
              'protocol.',
        ),
      ],
    );
  }
}
