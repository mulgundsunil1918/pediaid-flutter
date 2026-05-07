// =============================================================================
// guides/seizure_meds_screen.dart
// MEDICATIONS USED FOR SEIZURES CONTROL.
// =============================================================================

import 'package:flutter/material.dart';
import '_emergency_guide_widgets.dart';

class _SeizureDrug {
  final String drug;
  final String dose;
  final String route;
  final String maxDose;
  final String comments;
  const _SeizureDrug({
    required this.drug,
    required this.dose,
    required this.route,
    required this.maxDose,
    required this.comments,
  });
}

const List<_SeizureDrug> _drugs = [
  _SeizureDrug(
    drug: 'Lorazepam',
    dose: '0.05–0.1 mg/kg ; Max 4 mg',
    route: 'IV',
    maxDose: 'IV 0.5 mg/kg ; Infusion 0.01–0.1 mg/kg/h',
    comments:
        'Sedation, hypotension, bradycardia, respiratory depression, '
        'hyperactivity.',
  ),
  _SeizureDrug(
    drug: 'Diazepam',
    dose: '0.05–0.3 mg/kg (max < 5 yr 5 mg ; > 5 yr 10 mg). '
        'PR dose 0.5 mg/kg',
    route: 'IV / PR',
    maxDose: '0.1 mg/kg/min',
    comments:
        'Sedation, hypotension, bradycardia, respiratory depression, '
        'hyperactivity, thrombophlebitis.',
  ),
  _SeizureDrug(
    drug: 'Midazolam',
    dose: '0.1–0.15 mg/kg ; Max 0.15 mg/kg',
    route: 'IV / IM',
    maxDose: 'Infusion 1 mcg/kg/min — to max of 24 mg/kg/min',
    comments:
        'Sedation, hypotension, bradycardia (if hypotensive or bradycardic '
        'avoid midazolam) ; respiratory depression, apnea, laryngospasm, '
        'hyperactivity.',
  ),
  _SeizureDrug(
    drug: 'Phenytoin',
    dose: '15–20 mg/kg ; Max 1 g',
    route: 'IV',
    maxDose: 'Slow IV over 20 min @ 1 mg/kg/min to max of 50 mg/kg/min. '
        'Monitor heart rate and BP during administration. Infusion may '
        'be titrated to maintain base line heart rate.',
    comments:
        '1. Tachyarrhythmia commonly seen during administration → '
        'decrease infusion rate.\n'
        '2. Bradyarrhythmia, gallop, pulmonary oedema, hypotension noted '
        'during infusion is suggestive of underlying myocardial '
        'depression, severe sepsis, etc. → Stop PHT and consider '
        'alternative.\n'
        '3. Dysarthria, ataxia, sedation, thrombophlebitis, purple-glove '
        'syndrome.',
  ),
  _SeizureDrug(
    drug: 'Fosphenytoin',
    dose: '15–20 mg PE/kg',
    route: 'IV / IM',
    maxDose: '3 mg PE/kg/min to max 150 mg PE/min',
    comments: 'Dysarthria, ataxia, sedation, hypotension, arrhythmia.',
  ),
  _SeizureDrug(
    drug: 'Valproic Acid',
    dose: '15–20 mg/kg ; Max 3 g',
    route: 'IV',
    maxDose: '5 mg/kg/min ; Infusion 1–4 mg/kg/h',
    comments: 'Hypotension, arrhythmia, hepatitis, pancreatitis.',
  ),
  _SeizureDrug(
    drug: 'Levetiracetam',
    dose: 'Bolus 20–30 mg/kg ; Max 4.5 g',
    route: 'IV',
    maxDose: '5 mg/kg/min',
    comments: 'Behavioural changes.',
  ),
  _SeizureDrug(
    drug: 'Phenobarbitone',
    dose: '15–20 mg/kg up to max 1 g/dose',
    route: 'IV',
    maxDose: '1 mg/kg/min up to max 60 mg/min',
    comments:
        'Respiratory depression, prolonged sedation, hypotension, '
        'immunosuppression. Intubate if used following benzodiazepines.',
  ),
  _SeizureDrug(
    drug: 'Thiopentone',
    dose: '2–4 mg/kg',
    route: 'IV',
    maxDose: '1–6 mg/kg/h',
    comments:
        'Sedation, hypotension, respiratory depression, accumulation '
        'due to lipid solubility, extravasation can cause skin necrosis '
        'due to pH of 10.6.',
  ),
  _SeizureDrug(
    drug: 'Pentobarbital',
    dose: '10–15 mg/kg',
    route: 'IV',
    maxDose: '2–5 mg/kg q 5 min to stop breakthrough seizure ; '
        '1–3 mg/kg/h infusion',
    comments: '',
  ),
  _SeizureDrug(
    drug: 'Propofol',
    dose: '1–2 mg/kg',
    route: 'IV',
    maxDose: '25–65 mcg/kg/min (1–6 mg/kg/hr) Propofol infusion syndrome',
    comments: '',
  ),
  _SeizureDrug(
    drug: 'Ketamine',
    dose: '1.5 mg/kg',
    route: 'IV',
    maxDose: '10–40 µg/kg/min ; Infusion (1–5 mg/kg/hr) — Salivary '
        'secretions, laryngospasm',
    comments: '',
  ),
  _SeizureDrug(
    drug: 'Topiramate',
    dose: '2–5 mg/kg',
    route: 'NGT',
    maxDose: 'Increase by 5–11 mg/kg/day (max 1 g BD)',
    comments:
        'Hyperchloraemic metabolic acidosis, hyperammonaemia.',
  ),
  _SeizureDrug(
    drug: 'Lacosamide',
    dose: '2–2.5 mg/kg/dose',
    route: 'IV',
    maxDose: '(Max 200–400 mg/day) given in 1 or 2 doses',
    comments: 'Renal / hepatic adjustment ; hepatic clearance ; 2-AV block.',
  ),
];

class SeizureMedsScreen extends StatelessWidget {
  const SeizureMedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return EgScaffold(
      title: 'Seizure Medications',
      subtitle: 'Status epilepticus drug ladder + complete reference '
          'doses.',
      children: [
        // ── Status epilepticus quick ladder ────────────────────────────
        const EgSectionLabel('Status epilepticus ladder',
            '  Time-anchored escalation'),
        const EgBanner(
          icon: Icons.timer,
          title: '0–5 min  ·  Stabilisation',
          body:
              'ABCs, IV access, glucose check, monitors. If hypoglycaemia '
              '→ D10 5 mL/kg.',
        ),
        const SizedBox(height: 10),
        const EgBanner(
          icon: Icons.medical_services,
          title: '5 min  ·  First-line benzodiazepine',
          body:
              'Lorazepam 0.1 mg/kg IV (max 4 mg) OR Midazolam 0.2 mg/kg IM '
              '/ 0.5 mg/kg buccal OR Diazepam 0.5 mg/kg PR. Repeat once at '
              '10 min if still seizing.',
        ),
        const SizedBox(height: 10),
        const EgBanner(
          icon: Icons.medical_services,
          title: '15–20 min  ·  Second-line',
          body:
              'Levetiracetam 60 mg/kg IV over 15 min (max 4.5 g) OR '
              'Fosphenytoin 20 mg PE/kg OR Valproate 40 mg/kg.',
        ),
        const SizedBox(height: 10),
        const EgBanner(
          icon: Icons.medical_services,
          title: '40 min  ·  Refractory — consider intubation',
          body:
              'Midazolam infusion (after bolus 0.2 mg/kg) — start 1 µg/kg/min, '
              'titrate. OR Pentobarbital 5 mg/kg load → 1–3 mg/kg/h. OR '
              'Propofol 1–2 mg/kg load → 1–4 mg/kg/h (watch for PRIS). '
              'Continuous EEG monitoring.',
        ),

        // ── Drug reference table ───────────────────────────────────────
        const EgSectionLabel('Drug reference table', '  Verbatim from source'),
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
                          child: Text(d.drug,
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
                          child: Text(d.route,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _kv(context, 'Dose', d.dose),
                    if (d.maxDose.isNotEmpty)
                      _kv(context, 'Max', d.maxDose),
                    if (d.comments.isNotEmpty)
                      _kv(context, 'Notes', d.comments),
                  ],
                ),
              ),
            )),

        const EgReferenceCard(
          text:
              'Medications '
              'Used For Seizures Control. Status ladder add-on per Status '
              'Epilepticus Treatment Guideline (Glauser et al., Neurol Clin '
              'Pract 2016) and ESETT trial. For use by qualified '
              'clinicians only.',
        ),
      ],
    );
  }

  Widget _kv(BuildContext ctx, String label, String value) {
    final cs = Theme.of(ctx).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 50,
            child: Text(label,
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.55),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                )),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.85),
                  fontSize: 12.5,
                  height: 1.55,
                )),
          ),
        ],
      ),
    );
  }
}
