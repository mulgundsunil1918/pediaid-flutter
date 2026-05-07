// =============================================================================
// guides/rsi_guide_screen.dart
// RAPID SEQUENCE INTUBATION (FLOW & MEDICATIONS USED).
// Verbatim transcription of every drug, dose, indication and note + 5
// scenario-specific intubation sequences.
// =============================================================================

import 'package:flutter/material.dart';
import '_emergency_guide_widgets.dart';

class _RsiDrug {
  final String name;
  final String dose;
  final String indications;
  final String note;
  const _RsiDrug({
    required this.name,
    required this.dose,
    required this.indications,
    required this.note,
  });
}

const List<_RsiDrug> _drugs = [
  _RsiDrug(name: 'Lidocaine', dose: '1 mg/kg', indications: 'TBI, Raised ICP',
      note: 'Protect raised ICP due to intubation'),
  _RsiDrug(name: 'Fentanyl', dose: '2–3 µg/kg',
      indications: 'Raised ICP, hemodynamics instability',
      note: 'Decreased catecholamine surge, relative cardioprotection'),
  _RsiDrug(name: 'Morphine', dose: '0.1 – 0.2 mg/kg',
      indications: 'Can be used in all patients',
      note: 'Watch for hypotension after repeated doses'),
  _RsiDrug(name: 'Midazolam', dose: '0.1 – 0.3 mg/kg',
      indications: 'Not specific',
      note: 'Very variable response, may cause hypotension'),
  _RsiDrug(name: 'Ketamine', dose: '1–2 mg/kg',
      indications: 'Hypotension, reactive airway disease',
      note: 'May increase secretions'),
  _RsiDrug(name: 'Propofol', dose: '1–2 mg/kg',
      indications: 'Short acting, titrate dose and response',
      note: 'Watch BP, myocardial depression'),
  _RsiDrug(name: 'Succinylcholine', dose: '1 mg/kg',
      indications: 'Ultra-short acting',
      note: 'Hyperkalemia, muscle fasciculation'),
  _RsiDrug(name: 'Rocuronium', dose: '1 mg/kg',
      indications: 'Short acting',
      note: 'Watch for hypotension'),
  _RsiDrug(name: 'Vecuronium', dose: '0.1 mg/kg',
      indications: 'Longer duration of action, not a preferred agent for RSI',
      note: 'Long duration of action'),
  _RsiDrug(name: 'Atropine', dose: '0.02 mg/kg',
      indications: 'Symptomatic Bradycardia',
      note: 'To avoid Vagal response (35 mins)'),
  _RsiDrug(name: 'Glycopyrrolate', dose: '5–10 mcg/kg (Max 200 mcg)',
      indications: 'Anti Sialogogue',
      note: 'Premedication to ketamine — inhibits bradycardic response to hypoxia'),
  _RsiDrug(name: 'Thiopental', dose: 'IV 2–5 mg/kg',
      indications: 'Raised ICP',
      note: 'May cause cardiorespiratory depression. Decreases cerebral '
          'metabolic rate & ICP. No analgesia'),
  _RsiDrug(name: 'Atracurium', dose: '0.3–0.6 mg/kg',
      indications: '—',
      note: 'Long duration of action (40 min)'),
];

class _SequenceStep {
  final String text;
  final bool conditional;
  const _SequenceStep(this.text, {this.conditional = false});
}

class _Sequence {
  final String title;
  final Color color;
  final List<_SequenceStep> steps;
  const _Sequence({required this.title, required this.color, required this.steps});
}

const List<_Sequence> _sequences = [
  _Sequence(
    title: 'Standard sequence',
    color: emergencyBlue,
    steps: [
      _SequenceStep('Fentanyl: 3–6 mcg/kg IV'),
      _SequenceStep('Midazolam: 0.1–0.2 mg/kg IV'),
      _SequenceStep('Consider: Atropine 0.02 mg/kg IV (min 0.1 mg, max 1 mg) for children < 5 yr', conditional: true),
      _SequenceStep('Rocuronium: 1–1.5 mg/kg OR Vecuronium 0.1–0.3 mg/kg'),
    ],
  ),
  _Sequence(
    title: 'Asthma sequence',
    color: emergencyAmber,
    steps: [
      _SequenceStep('Atropine: 0.02 mg/kg IV (min 0.1 mg, max 1 mg) for children < 5 yr'),
      _SequenceStep('Ketamine: 1–2 mg/kg IV'),
      _SequenceStep('Rocuronium: 1–1.5 mg/kg OR Vecuronium 0.1–0.3 mg/kg'),
      _SequenceStep('Midazolam: 0.1–0.2 mg/kg IV (before ketamine wears off)'),
    ],
  ),
  _Sequence(
    title: 'Hemodynamic instability sequence',
    color: emergencyRed,
    steps: [
      _SequenceStep('Ketamine: 1–2 mg/kg IV OR Etomidate 0.2–0.6 mg/kg IV'),
      _SequenceStep('Consider: Atropine 0.02 mg/kg IV (min 0.1 mg, max 1 mg) for children < 5 yr', conditional: true),
      _SequenceStep('Rocuronium: 1–1.5 mg/kg OR Vecuronium 0.1–0.3 mg/kg'),
      _SequenceStep('Midazolam: 0.1–0.2 mg/kg IV (after intubation if BPs are normal)', conditional: true),
    ],
  ),
  _Sequence(
    title: 'Head injury sequence',
    color: emergencyBrand,
    steps: [
      _SequenceStep('Lidocaine: 1 mg/kg IV'),
      _SequenceStep('Etomidate 0.2–0.6 mg/kg IV (if ↓BP) OR (if NL BP) Thiopental 3–5 mg/kg'),
      _SequenceStep('Consider: Atropine 0.02 mg/kg IV (min 0.1 mg, max 1 mg) for children < 5 yr', conditional: true),
      _SequenceStep('Consider: Lidocaine 1 mg/kg IV', conditional: true),
      _SequenceStep('Rocuronium: 1–1.5 mg/kg OR Vecuronium 0.1–0.4 mg/kg IV (only if NL BP)'),
    ],
  ),
  _Sequence(
    title: 'Organ failure considerations',
    color: emergencyGreen,
    steps: [
      _SequenceStep('Renal or Liver Failure (Grade 3/4): Propofol 1–2 mg/kg IV (↓ICP) OR Etomidate 0.3 mg/kg IV'),
      _SequenceStep('Low-dose Midazolam 0.05–0.1 mg/kg'),
      _SequenceStep('Atracurium 0.4–0.5 mg/kg (degraded by plasma esterase) OR Cisatracurium 0.1–0.15 mg/kg'),
      _SequenceStep('Rocuronium: 1–1.5 mg/kg OR Vecuronium 0.1–0.3 mg/kg'),
    ],
  ),
];

class RsiGuideScreen extends StatelessWidget {
  const RsiGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return EgScaffold(
      title: 'Rapid Sequence Intubation',
      subtitle: 'The 7 P\'s + drug reference + scenario-specific sequences.',
      children: [
        // ── 7 P's timeline ──────────────────────────────────────────────
        const EgSectionLabel('The 7 P\'s', '  Time-anchored flow'),
        EgCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _PStep('Zero minus 10 min', '1. Preparation', emergencyBrand),
              _PStep('Zero minus 5 min', '2. Preoxygenation', emergencyBrand),
              _PStep('Zero minus 3 min', '3. Pretreatment', emergencyBrand),
              _PStep('Zero', '4. Paralysis / Induction', emergencyRed),
              _PStep('Zero plus 20–30 sec', '5. Positioning', emergencyAmber),
              _PStep('Zero plus 45 sec', '6. Placement with proof', emergencyAmber),
              _PStep('After', '7. Post-intubation management', emergencyGreen),
            ],
          ),
        ),

        // ── Pre-intubation checklist ───────────────────────────────────
        const EgSectionLabel('Pre-intubation', '  Setup checklist'),
        const EgCard(
          child: EgBlock(
            title: 'Have ready before zero',
            lines: [
              '100 % FiO₂ for > 3 min',
              'PPV (positive-pressure ventilation) bag',
              'Suction',
              'ETCO₂ sensor',
              'Oral airway',
              'Alternative ETT and blades',
              'NS bolus available if patient has ↓BP with PPV',
            ],
          ),
        ),

        // ── RSI standard recipe ────────────────────────────────────────
        const EgSectionLabel('Rapid Sequence Intubation', '  Default recipe'),
        const EgBanner(
          icon: Icons.medical_services,
          title: 'Etomidate 0.2–0.6 mg/kg IV  OR  Thiopental 3–5 mg/kg  OR  Propofol 1–2 mg/kg',
        ),
        const SizedBox(height: 8),
        const EgBanner(
          icon: Icons.medical_services,
          title: 'Rocuronium 1–1.5 mg/kg  OR  Succinylcholine 1–2 mg/kg IV',
        ),
        const SizedBox(height: 8),
        const EgBanner(
          icon: Icons.medical_services,
          title: 'Midazolam 0.1–0.2 mg/kg IV (after intubation)',
        ),
        const SizedBox(height: 12),
        const EgPearl(
          title: 'Consider atropine + cricoid pressure',
          body:
              'Atropine 0.02 mg/kg IV (min 0.1 mg, max 1 mg) for < 5 yr or '
              'any patient receiving succinylcholine. Hold cricoid pressure '
              'from loss of consciousness until ETT is confirmed.',
        ),

        // ── Drug reference table ───────────────────────────────────────
        const EgSectionLabel('Drug reference', '  Verbatim from source'),
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
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('Indication: ${d.indications}',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.7),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        )),
                    const SizedBox(height: 4),
                    Text(d.note,
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.85),
                          fontSize: 12.5,
                          height: 1.5,
                        )),
                  ],
                ),
              ),
            )),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 6, 16, 0),
          child: Text(
            'Intubation = analgesia + sedation + neuromuscular blocker '
            '+/- premedication',
            style: TextStyle(
              fontSize: 12.5,
              color: emergencyBrand,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // ── Scenario-specific sequences ─────────────────────────────────
        const EgSectionLabel('Sequences', '  Scenario-specific'),
        ..._sequences.map((s) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(color: s.color.withValues(alpha: 0.55)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: s.color,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(11),
                          topRight: Radius.circular(11),
                        ),
                      ),
                      child: Text(s.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                      child: EgBulletList(
                        items: s.steps.map((st) => st.text).toList(),
                        numbered: true,
                      ),
                    ),
                  ],
                ),
              ),
            )),

        const EgPearl(
          title: 'Confirming ETT placement (research add-on)',
          body:
              'Gold standard: continuous waveform capnography (ETCO₂ trace). '
              'Other confirmations: bilateral chest rise, equal air entry, '
              'no epigastric sounds, condensation in tube, SpO₂ rising. CXR '
              'after stabilisation for tip position (target T2–T3 in '
              'children, mid-trachea).',
        ),

        const EgReferenceCard(
          text:
              'Rapid Sequence '
              'Intubation (Flow & Medications Used) card. Research add-ons '
              'drawn from APLS 6th edition and the PALS RSI consensus. For '
              'use by qualified clinicians only.',
        ),
      ],
    );
  }
}

class _PStep extends StatelessWidget {
  final String time;
  final String label;
  final Color color;
  const _PStep(this.time, this.label, this.color);
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 110,
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(time,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                )),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                )),
          ),
        ],
      ),
    );
  }
}
