// =============================================================================
// guides/scorpion_sting_screen.dart
// SCORPION STING staging chart. Verbatim transcription.
// =============================================================================

import 'package:flutter/material.dart';
import '_emergency_guide_widgets.dart';

class ScorpionStingScreen extends StatelessWidget {
  const ScorpionStingScreen({super.key});

  Widget _stage({
    required String stage,
    required String hours,
    required Color color,
    required List<String> features,
    required String treatment,
  }) {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: color.withValues(alpha: 0.55)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(11),
                    topRight: Radius.circular(11),
                  ),
                ),
                child: Row(
                  children: [
                    Text(stage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        )),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(hours,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Clinical features'.toUpperCase(),
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        )),
                    const SizedBox(height: 6),
                    EgBulletList(items: features),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.10),
                        border: Border.all(color: color.withValues(alpha: 0.35)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.medical_services,
                              color: color, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(treatment,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  height: 1.4,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return EgScaffold(
      title: 'Scorpion Sting',
      subtitle: 'Stage-based recognition + treatment. ASV + Prazosin is the '
          'cornerstone.',
      children: [
        const EgSectionLabel('Stages', '  Time from sting'),

        _stage(
          stage: 'Stage I',
          hours: '0–4 hours',
          color: emergencyGreen,
          features: const [
            'Sweating',
            'Salivation',
            'Mydriasis',
            'Priapism',
            'Hypertension',
            'Hypotension',
            'Cold extremities',
          ],
          treatment: 'ASV + Prazosin',
        ),
        _stage(
          stage: 'Stage II',
          hours: '4–6 hours',
          color: emergencyAmber,
          features: const [
            'Hypertension',
            'Tachycardia',
            'Cold extremities',
          ],
          treatment: 'ASV + Prazosin',
        ),
        _stage(
          stage: 'Stage III',
          hours: '6–10 hours',
          color: emergencyRed,
          features: const [
            'Tachycardia',
            'Hypotension',
            'Pulmonary Oedema',
            'Cold extremities',
          ],
          treatment: 'ASV + Prazosin + Dobutamine + NIV / MV',
        ),
        _stage(
          stage: 'Stage IV',
          hours: '0–6 hours',
          color: emergencyRed,
          features: const ['Massive Pulmonary Oedema'],
          treatment: 'ASV + SNP — or — NTG + NIV / MV',
        ),
        _stage(
          stage: 'Stage V',
          hours: '> 12 hours',
          color: emergencyBrand,
          features: const [
            'Warm Extremities',
            'Tachycardia',
            'Hypotension',
            'Pulmonary Oedema',
            'Gray Pallor (warm shock)',
          ],
          treatment: 'Dobutamine',
        ),

        const EgSectionLabel('All paths', '  → RECOVERY'),
        EgCard(
          child: Row(
            children: const [
              Icon(Icons.favorite, color: emergencyGreen, size: 22),
              SizedBox(width: 10),
              Expanded(
                child: Text('All stages converge on RECOVERY when '
                    'extremities are warm, dry and peripheral veins are '
                    'visible easily.',
                    style: TextStyle(fontSize: 13, height: 1.5)),
              ),
            ],
          ),
        ),

        const EgSectionLabel('Legend', '  Abbreviations'),
        const EgCard(
          child: EgBulletList(items: [
            'ASV — Antiscorpion Venom',
            'SNP — Sodium Nitroprusside',
            'NTG — Nitroglycerine',
            'NIV — Non-invasive ventilation',
            'MV — Mechanical Ventilation',
          ]),
        ),

        // ── Management ────────────────────────────────────────────────
        const EgSectionLabel('Management', ''),
        const EgBanner(
          icon: Icons.local_hospital,
          title: '1.  ABC stabilization',
        ),
        const SizedBox(height: 10),
        EgCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('2.  PRAZOSIN',
                  style: TextStyle(
                    color: emergencyBrand,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  )),
              SizedBox(height: 8),
              EgBulletList(items: [
                'a) Available as 1 mg / 2.5 mg / 5 mg tablets',
                'b) Dose is 30 microgram/kg/dose',
                'c) Sustained release tablets are not recommended',
                'd) Repeated every 3 hours as per response',
                'e) Later every 6 hours till extremities are warm, dry and '
                    'peripheral veins are visible easily',
                'f) Other medications are not helpful',
              ]),
            ],
          ),
        ),

        const EgPearl(
          title: 'Prazosin — research add-on',
          body:
              'Prazosin is a selective post-synaptic α1-blocker. It reverses '
              'the autonomic storm of Mesobuthus tamulus (Indian Red '
              'Scorpion) venom. Pune protocol (Bawaskar): 30 μg/kg PO repeat '
              'q 3 h × 3 doses, then q 6 h until warm peripheries. First '
              'dose hypotension is rare in scorpion sting because the '
              'patient is already vasoconstricted.',
        ),
        const EgPearl(
          icon: Icons.warning_amber_rounded,
          title: 'When to add Dobutamine — research add-on',
          body:
              'Add dobutamine 5–15 μg/kg/min when there is myocardial '
              'dysfunction (pulmonary oedema, gallop, EF < 40 %). Continue '
              'until warm shock resolves. Avoid dopamine — pure α-effect '
              'worsens venom-induced vasoconstriction.',
        ),

        const EgReferenceCard(
          text:
              'Scorpion Sting '
              'staging card. Research add-ons draw on the Bawaskar Pune '
              'Protocol (Lancet 2011) and the IAP Standard Treatment '
              'Guidelines for Scorpion Envenomation. For use by qualified '
              'clinicians only.',
        ),
      ],
    );
  }
}
