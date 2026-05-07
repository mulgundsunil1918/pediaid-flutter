// =============================================================================
// guides/avpu_screen.dart
// AVPU Level of Consciousness assessment. Verbatim transcription of the
// adult + paediatric behavioural columns. Research add-on: GCS-equivalent
// rough mapping + clinical notes.
// =============================================================================

import 'package:flutter/material.dart';
import '_emergency_guide_widgets.dart';

class _AvpuRow {
  final String letter;
  final String label;
  final Color color;
  final String adult;
  final String paediatric;
  const _AvpuRow({
    required this.letter,
    required this.label,
    required this.color,
    required this.adult,
    required this.paediatric,
  });
}

const List<_AvpuRow> _rows = [
  _AvpuRow(
    letter: 'A',
    label: 'ALERT',
    color: Color(0xFF2E7D32),
    adult:
        'Eyes open spontaneously. Appears aware of and responsive to the '
        'environment. Follows commands, eyes track people and objects.',
    paediatric:
        'Child is active and responds appropriately to SO (significant '
        'other) and other external stimuli.',
  ),
  _AvpuRow(
    letter: 'V',
    label: 'VOICE',
    color: Color(0xFFEF6C00),
    adult:
        'Eyes do not open spontaneously but open to verbal stimuli. Able '
        'to respond in some meaningful way when spoken to.',
    paediatric:
        'Responds only when his or her name is called by SO.',
  ),
  _AvpuRow(
    letter: 'P',
    label: 'PAIN',
    color: Color(0xFFD84315),
    adult:
        'Does not respond to questions but moves or cries out in response '
        'to painful stimuli such as pinching the skin or earlobe.',
    paediatric:
        'Responds only when painful stimuli is received such as pinching '
        'the nail bed.',
  ),
  _AvpuRow(
    letter: 'U',
    label: 'UNRESPONSIVE',
    color: Color(0xFFB71C1C),
    adult: 'Patient does not respond to any stimuli.',
    paediatric: 'No response at all.',
  ),
];

class AvpuScreen extends StatelessWidget {
  const AvpuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EgScaffold(
      title: 'AVPU Scale',
      subtitle: 'Level of Consciousness assessment — Alert · Voice · Pain · '
          'Unresponsive.',
      children: [
        const EgSectionLabel('Scale', '  A · V · P · U'),
        ..._rows.map(_AvpuCard.new),

        // ── Learn more (verbatim source paragraph) ────────────────────
        const EgSectionLabel('Learn more', '  The "AVPU" scale'),
        const EgCard(
          child: Text(
            'The AVPU scale is a system where you can measure and record '
            'a patient\'s responsiveness to indicate their level of '
            'consciousness. It is a simplification of the Glasgow Coma '
            'Scale, which assesses a patient response in three measures: '
            'eyes, voice, and motor skills. The AVPU scale should be '
            'assessed during these three identifiable traits, looking for '
            'the best response for each. It has four possible outcomes for '
            'recording and the nurse should always work from best (A) to '
            'worst (U) to avoid unnecessary tests on patients who are '
            'clearly conscious. On the other hand, it should not be used '
            'for long-term follow up of neurological status.',
            style: TextStyle(fontSize: 13, height: 1.55),
          ),
        ),

        // ── AVPU ↔ GCS rough mapping (research add-on) ────────────────
        const EgPearl(
          title: 'Rough AVPU ↔ GCS mapping (research add-on)',
          body:
              'A — GCS 14–15 (alert, no deficit)\n'
              'V — GCS 12–13 (eye opening to voice)\n'
              'P — GCS 8 (responds only to pain — protect airway, '
              'often intubation threshold)\n'
              'U — GCS ≤ 6 (no response — definitely intubate)',
        ),
        const EgPearl(
          icon: Icons.lightbulb_outline,
          title: '"P or U" = airway is at risk',
          body:
              'Any AVPU level worse than V (i.e., P or U) means the patient '
              'cannot reliably protect their airway. Position laterally, '
              'suction, and prepare for intubation. Recheck every 5–10 '
              'minutes during transport.',
        ),

        const EgReferenceCard(
          text:
              'Level of '
              'Consciousness Assessment "AVPU" card. Mapping + airway '
              'pearls drawn from APLS 6th edition (Advanced Paediatric '
              'Life Support) and the BMJ Best Practice paediatric trauma '
              'pathway. For use by qualified clinicians only.',
        ),
      ],
    );
  }
}

class _AvpuCard extends StatelessWidget {
  final _AvpuRow row;
  const _AvpuCard(this.row);
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: row.color.withValues(alpha: 0.55)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: row.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(11),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(row.letter,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        )),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(row.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
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
                  Text('ADULT BEHAVIOR',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      )),
                  const SizedBox(height: 4),
                  Text(row.adult,
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.85),
                        fontSize: 13,
                        height: 1.55,
                      )),
                  const SizedBox(height: 14),
                  Text('PEDIATRIC BEHAVIOR',
                      style: TextStyle(
                        color: row.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      )),
                  const SizedBox(height: 4),
                  Text(row.paediatric,
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.85),
                        fontSize: 13,
                        height: 1.55,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
