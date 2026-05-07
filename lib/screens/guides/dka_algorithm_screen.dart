// =============================================================================
// guides/dka_algorithm_screen.dart
//
// Diabetic Ketoacidosis Algorithm — every value transcribed verbatim from
// the source flowchart. Research-based context (ISPAD 2022, neurocognitive
// outcomes literature, two-bag system rationale) is added in clearly
// labelled "Clinical pearls" boxes so the eye can separate source-of-truth
// from supplementary explanation.
//
// Source flow (top → bottom):
//
//   Immediate Assessment ──┐
//   Clinical Signs ────────┤── Diagnosis confirmed → Contact Senior Staff
//   Biochemical Features ──┘
//                                  │
//          ┌───────────────────────┼───────────────────────┐
//   Minimal dehydration   Dehydration >5% / Not shock      Shock / coma
//   (oral fluids)         Acidotic / Vomiting              Reduced LOC
//          │                       │                          │
//   SC insulin            IV fluids 0.9% saline               Resuscitation
//   Continue oral         10 mL/kg/h, KCl 40 mmol/L           ABC, NG tube
//          │                       │                          │
//          └───────────────────────┴──────────┬───────────────┘
//                                             ▼
//                Continuous insulin infusion 0.05–0.1 U/kg/hr
//                Started 1 hr AFTER fluids initiated
//                                             │
//                Critical Observations (hourly + Q2H electrolytes)
//                                             │
//   ┌────────────────┬────────────────┬───────┴──────────┬────────────────┐
//   Acidosis not     Blood glc          Improved →         Neurological
//   improving →      <300 mg/dL or      Transition to      deterioration →
//   Re-evaluate      falling fast →     SC insulin         Cerebral oedema?
//                    Add glucose                            CE Management
// =============================================================================

import 'package:flutter/material.dart';

const Color _kBrand = Color(0xFF6A1B9A);          // Source brochure purple
const Color _kBrandLight = Color(0xFFE1BEE7);
const Color _kSevereRed = Color(0xFFB71C1C);
const Color _kModerateAmber = Color(0xFFEF6C00);
const Color _kMildGreen = Color(0xFF2E7D32);
const Color _kInfoBlue = Color(0xFF1565C0);

class DkaAlgorithmScreen extends StatelessWidget {
  const DkaAlgorithmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('DKA Algorithm',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        elevation: 0,
        backgroundColor: _kBrand,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
        children: [
          // ── Banner ────────────────────────────────────────────────────
          Container(
            color: _kBrand,
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('DKA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    )),
                const SizedBox(height: 2),
                Text('Diabetic Ketoacidosis — paediatric management algorithm',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12.5,
                      height: 1.4,
                    )),
              ],
            ),
          ),

          // ── Step 1: Immediate Assessment ───────────────────────────────
          _SectionLabel('Step 1', '  Immediate Assessment'),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _Block(
                  title: 'Clinical history',
                  lines: [
                    'Polyuria, polydipsia, nocturia, enuresis',
                    'Weight loss',
                    'Nausea, vomiting, abdominal pain, fatigue',
                    'Confusion, altered level of consciousness',
                  ],
                ),
                Divider(height: 24),
                _Block(
                  title: 'Clinical signs',
                  lines: [
                    'Dehydration',
                    'Deep sighing respiration (Kussmaul)',
                    'Smell of ketones',
                    'Lethargy / drowsiness',
                  ],
                ),
                Divider(height: 24),
                _Block(
                  title: 'Biochemical features & investigations',
                  lines: [
                    'Ketones in urine (ketonuria)',
                    'Blood glucose',
                    'Acidemia: vpH < 7.3, HCO₃ < 15 mmol/L',
                    'Urea, electrolytes',
                    'Other investigations as indicated',
                  ],
                ),
              ],
            ),
          ),

          _Pearl(
            icon: Icons.info_outline,
            title: 'Diagnostic criteria — ISPAD 2022 (research add-on)',
            body:
                'Hyperglycaemia (BG > 200 mg/dL / 11 mmol/L) + venous '
                'pH < 7.3 OR bicarbonate < 18 mmol/L + ketonaemia '
                '(β-OHB ≥ 3 mmol/L) or moderate-large ketonuria. '
                'Severity: mild pH 7.2–7.3, moderate 7.1–7.2, '
                'severe < 7.1.',
          ),

          // ── Step 2: Diagnosis confirmed → Senior staff ─────────────────
          _SectionLabel('Step 2', '  Diagnosis confirmed'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _kBrand,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: const [
                Icon(Icons.local_hospital, color: Colors.white, size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Diabetic Ketoacidosis confirmed — Contact Senior Staff',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]),
            ),
          ),

          // ── Step 3: Triage by severity (3 paths) ──────────────────────
          _SectionLabel('Step 3', '  Triage by severity'),

          // Path A — Mild
          _PathCard(
            color: _kMildGreen,
            colorDark: dark,
            tag: 'PATH A',
            severity: 'Minimal dehydration',
            criteria: ['Tolerating oral fluid'],
            therapyTitle: 'Therapy',
            therapyLines: const [
              'Start with SC insulin',
              'Continue oral hydration',
            ],
            outcomeTitle: 'If no improvement',
            outcome:
                '→ escalate to IV therapy (Path B), reassess hydration '
                'and acidosis.',
          ),

          // Path B — Moderate
          _PathCard(
            color: _kModerateAmber,
            colorDark: dark,
            tag: 'PATH B',
            severity: 'Dehydration > 5 %',
            criteria: const [
              'Not in shock',
              'Acidotic (hyperventilation)',
              'Vomiting',
            ],
            therapyTitle: 'IV Therapy',
            therapyLines: const [
              'Saline 0.9 %, 10 mL/kg over 1 h; may repeat',
              'Calculate fluid requirements',
              'Correct fluid deficit over 24–48 hours',
              'ECG for abnormal T-waves',
              'Add KCl 40 mmol per litre fluid',
            ],
          ),

          // Path C — Shock
          _PathCard(
            color: _kSevereRed,
            colorDark: dark,
            tag: 'PATH C',
            severity: 'Shock or reduced consciousness',
            criteria: const [
              'Reduced peripheral pulses',
              'Reduced conscious level / coma',
            ],
            therapyTitle: 'Resuscitation',
            therapyLines: const [
              'Airway + NG tube',
              'Breathing (100 % oxygen)',
              'Circulation (0.9 % saline) 10–20 mL/kg over 1–2 h, '
                  'and repeat until circulation is restored',
              'See CE Management (cerebral oedema risk)',
            ],
          ),

          _Pearl(
            icon: Icons.lightbulb_outline,
            title: 'Fluid choice — research add-on',
            body:
                'ISPAD 2022 + PECARN FLUID trial: balanced crystalloids '
                '(Plasmalyte®, Ringer-lactate) or 0.9 % saline are '
                'both acceptable. Aggressive (faster) fluid replacement does '
                'NOT increase the risk of cerebral injury. Use 0.45–0.9 '
                '% saline once initial volume restored.',
          ),

          // ── Step 4: Continuous insulin infusion ───────────────────────
          _SectionLabel('Step 4', '  Insulin'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _kInfoBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: const [
                    Icon(Icons.medical_information,
                        color: Colors.white, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text('Continuous insulin infusion',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  const Text(
                    '0.05 – 0.1 unit/kg/hour\n'
                    'Start 1 hour after fluids initiated.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.55,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          _Pearl(
            icon: Icons.lightbulb_outline,
            title: 'Why a 1-hour insulin delay (research add-on)',
            body:
                'Insulin is started 1 hour AFTER fluids have begun. Early '
                'simultaneous insulin can drop osmolality too rapidly and '
                'has been associated with cerebral oedema. Use 0.05 U/kg/h '
                'in children < 5 yr or pH > 7.15; otherwise 0.1 U/kg/h. Do '
                'NOT bolus insulin — no benefit, increases hypoglycaemia + '
                'hypokalaemia.',
          ),

          // ── Step 5: Critical Observations ─────────────────────────────
          _SectionLabel('Step 5', '  Critical observations'),
          _Card(
            child: const _Block(
              title: 'Monitor at the bedside',
              lines: [
                'Hourly blood glucose',
                'Hourly fluid input & output',
                'Neurological status at least hourly',
                'Electrolytes 2-hourly after starting IV fluid therapy',
                'Monitor ECG for T-wave changes',
              ],
            ),
          ),

          // ── Step 6: Branching outcomes ────────────────────────────────
          _SectionLabel('Step 6', '  Reassess & branch'),

          _OutcomeCard(
            color: _kModerateAmber,
            title: 'Acidosis NOT improving',
            sublines: const [
              'Re-evaluate:',
              ' • IV fluid calculations',
              ' • Insulin delivery system & dose',
              ' • Need for additional resuscitation',
              ' • Consider sepsis',
            ],
          ),

          _OutcomeCard(
            color: _kInfoBlue,
            title:
                'Blood glucose < 17 mmol/L (300 mg/dL) OR falling > 5 mmol/L/h '
                '(90 mg/dL/h)',
            heading: 'IV Therapy',
            sublines: const [
              'Change to 0.45 % or 0.9 % saline; add glucose to fluids '
                  '(5 % – 12.5 %) to prevent hypoglycaemia',
              'Adjust sodium infusion to promote an increase in measured '
                  'serum sodium',
            ],
          ),

          _OutcomeCard(
            color: _kMildGreen,
            title:
                'Improved — clinically well, ketoacidosis resolved, '
                'tolerating oral fluids',
            heading: 'Transition to SC insulin',
            sublines: const [
              'Start SC insulin then stop IV insulin after an appropriate '
                  'interval',
            ],
          ),

          _OutcomeCard(
            color: _kSevereRed,
            title: 'Neurological deterioration',
            heading: 'WARNING SIGNS',
            sublines: const [
              'Severe or progressive headache',
              'Slowing heart rate',
              'Irritability, confusion',
              'Decreased consciousness',
              'Incontinence',
              'Specific neurological signs',
              '',
              'Exclude hypoglycaemia',
              'Is it cerebral oedema?',
            ],
          ),

          // ── CE Management ─────────────────────────────────────────────
          _SectionLabel('CE Management', '  Cerebral oedema'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _kSevereRed,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: const [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.white, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Cerebral Oedema Management',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  const _BulletList(white: true, items: [
                    'Give mannitol 0.5 – 1 g/kg, OR 3 % hypertonic saline',
                    'Adjust IV fluids to maintain normal BP, but avoid '
                        'over-hydration',
                    'Call senior staff',
                    'Move to ICU',
                    'Consider cranial imaging only after the patient is '
                        'stabilised',
                  ]),
                ],
              ),
            ),
          ),

          _Pearl(
            icon: Icons.lightbulb_outline,
            title: 'Cerebral oedema dosing — research add-on',
            body:
                '• Mannitol 20 % 0.5–1 g/kg IV over 10–15 min '
                '(can repeat after 30 min if no response).\n'
                '• Hypertonic 3 % NaCl 2.5–5 mL/kg IV over '
                '10–15 min — equally effective, often preferred when '
                'volume status is fragile.\n'
                '• Risk factors: age < 5 yr, new-onset diabetes, '
                'severe acidosis, raised BUN, treatment with bicarbonate, '
                'failure of measured Na to rise during therapy.',
          ),

          // ── Pre-existing additions ────────────────────────────────────
          _SectionLabel('Common pitfalls', '  Research add-ons'),
          _Pearl(
            icon: Icons.report_outlined,
            title: 'Bicarbonate — almost never indicated',
            body:
                'Bicarbonate is associated with worse cerebral oedema '
                'outcomes and paradoxical CSF acidosis. ISPAD 2022: only '
                'consider for life-threatening hyperkalaemia or '
                'haemodynamic instability secondary to severe acidosis '
                '(pH < 6.9) UNRESPONSIVE to fluids. Even then ≤ 1–2 '
                'mmol/kg over 60 min.',
          ),
          _Pearl(
            icon: Icons.report_outlined,
            title: 'Two-bag system (research add-on)',
            body:
                'Use two identical bags — one with 0 % dextrose, one '
                'with 10 % dextrose, both with 0.45–0.9 % saline + 40 '
                'mmol/L KCl. Adjust the ratio to titrate dextrose 0–10 '
                '% without changing total fluid rate or stopping insulin. '
                'Reduces hypoglycaemia and time-to-resolution.',
          ),
          _Pearl(
            icon: Icons.report_outlined,
            title: 'Potassium replacement (research add-on)',
            body:
                'Total body K+ is depleted even when serum K+ is normal/high. '
                'Once urine output is established and K+ < 5.5 mmol/L, add '
                'KCl 40 mmol/L (mix as 20 KCl + 20 K-phosphate or '
                'K-acetate). Hold insulin if K+ < 3.3.',
          ),
          _Pearl(
            icon: Icons.report_outlined,
            title: 'Effective osmolality',
            body:
                'Effective osm = 2 × [Na] + glucose(mg/dL)/18.\n'
                'Aim for a slow, steady fall — a drop > 3 mOsm/kg/h '
                'is associated with cerebral oedema. Measured Na should '
                'rise as glucose falls; if it doesn\'t, increase the '
                'sodium content of the IV fluid.',
          ),

          // ── Reference ─────────────────────────────────────────────────
          _SectionLabel('Reference', ''),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.04),
                border:
                    Border.all(color: cs.onSurface.withValues(alpha: 0.08)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Source flowchart: an internal reference compendium — '
                'DKA Algorithm card. Research-add-on boxes draw on the '
                'ISPAD Clinical Practice Consensus Guidelines 2022 (Glaser '
                'et al.) and the PECARN FLUID DKA trial (NEJM 2018, Kuppermann '
                'et al.). Always verify against the patient\'s clinical '
                'context, your local protocol and the most current source '
                'guideline before any treatment decision. For use by qualified '
                'clinicians only.',
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.55),
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  height: 1.55,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Layout helpers ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String stepTag;
  final String title;
  const _SectionLabel(this.stepTag, this.title);
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 8),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: _kBrand.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              stepTag.toUpperCase(),
              style: const TextStyle(
                color: _kBrand,
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
          if (title.isNotEmpty)
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: cs.onSurface.withValues(alpha: 0.10)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}

class _Block extends StatelessWidget {
  final String title;
  final List<String> lines;
  const _Block({required this.title, required this.lines});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(),
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.7),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            )),
        const SizedBox(height: 8),
        _BulletList(items: lines),
      ],
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;
  final bool white;
  const _BulletList({required this.items, this.white = false});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fg = white ? Colors.white : cs.onSurface.withValues(alpha: 0.85);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.where((l) => l.isNotEmpty || true).map((line) {
        if (line.isEmpty) return const SizedBox(height: 8);
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('•',
                  style: TextStyle(
                      color: fg.withValues(alpha: 0.55),
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(line,
                    style: TextStyle(
                      color: fg,
                      fontSize: 13,
                      height: 1.5,
                    )),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _PathCard extends StatelessWidget {
  final Color color;
  final bool colorDark;
  final String tag;
  final String severity;
  final List<String> criteria;
  final String therapyTitle;
  final List<String> therapyLines;
  final String? outcomeTitle;
  final String? outcome;
  const _PathCard({
    required this.color,
    required this.colorDark,
    required this.tag,
    required this.severity,
    required this.criteria,
    required this.therapyTitle,
    required this.therapyLines,
    this.outcomeTitle,
    this.outcome,
  });
  @override
  Widget build(BuildContext context) {
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
            // Header strip
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(11),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(severity,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Criteria
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: criteria
                        .map((c) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.10),
                                border: Border.all(
                                    color: color.withValues(alpha: 0.35)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(c,
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 14),
                  // Therapy
                  Text(therapyTitle.toUpperCase(),
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      )),
                  const SizedBox(height: 6),
                  _BulletList(items: therapyLines),
                  if (outcomeTitle != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cs.onSurface.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(outcomeTitle!.toUpperCase(),
                              style: TextStyle(
                                color: cs.onSurface.withValues(alpha: 0.65),
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              )),
                          const SizedBox(height: 4),
                          Text(outcome!,
                              style: TextStyle(
                                color: cs.onSurface.withValues(alpha: 0.85),
                                fontSize: 12.5,
                                height: 1.5,
                              )),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutcomeCard extends StatelessWidget {
  final Color color;
  final String title;
  final String? heading;
  final List<String> sublines;
  const _OutcomeCard({
    required this.color,
    required this.title,
    this.heading,
    required this.sublines,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(
              left: BorderSide(color: color, width: 4),
              top: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
              right: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
              bottom: BorderSide(color: cs.onSurface.withValues(alpha: 0.10))),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                  color: color,
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                )),
            if (heading != null) ...[
              const SizedBox(height: 8),
              Text(heading!.toUpperCase(),
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  )),
            ],
            const SizedBox(height: 6),
            _BulletList(items: sublines),
          ],
        ),
      ),
    );
  }
}

class _Pearl extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const _Pearl({
    required this.icon,
    required this.title,
    required this.body,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: dark
              ? _kBrand.withValues(alpha: 0.18)
              : _kBrandLight.withValues(alpha: 0.4),
          border: Border.all(color: _kBrand.withValues(alpha: 0.25)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: _kBrand, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                      color: _kBrand,
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    )),
              ),
            ]),
            const SizedBox(height: 6),
            Text(body,
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.85),
                  fontSize: 12.5,
                  height: 1.55,
                )),
          ],
        ),
      ),
    );
  }
}
