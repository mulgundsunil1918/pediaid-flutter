// =============================================================================
// guides/acute_severe_asthma_screen.dart
// ACUTE SEVERE ASTHMA card. Verbatim transcription
// of every drug, dose and frequency.
// =============================================================================

import 'package:flutter/material.dart';
import '_emergency_guide_widgets.dart';

class AcuteSevereAsthmaScreen extends StatelessWidget {
  const AcuteSevereAsthmaScreen({super.key});

  Widget _classCard({
    required String title,
    required Color color,
    required List<String> bullets,
  }) {
    return Builder(builder: (context) {
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
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(11),
                    topRight: Radius.circular(11),
                  ),
                ),
                child: Text(title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: EgBulletList(items: bullets),
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
      title: 'Acute Severe Asthma',
      subtitle: 'Status asthmaticus — first-line trio + escalation '
          'medications.',
      children: [
        const EgSectionLabel('Medications', '  Three core drug classes'),

        _classCard(
          title: 'β₂ AGONIST',
          color: emergencyBlue,
          bullets: const [
            'Salbutamol continuous nebulization — 0.15–0.5 mg/kg/hr, '
                'or 10–20 mg/hr',
            'Salbutamol MDI (100 mcg) — 4–8 puffs',
            'Subcutaneous Terbutaline — 0.01 mg/kg/dose (max 0.3 mg), '
                'may be repeated q 20–30 min for total 3 times',
            'Terbutaline — loading dose 10 mcg/kg IV over 10 min '
                'followed by 0.1–10 mcg/kg/min',
          ],
        ),
        _classCard(
          title: 'ANTICHOLINERGIC AGENTS',
          color: emergencyAmber,
          bullets: const [
            'Ipratropium bromide',
            '125–500 mcg (if nebulized)',
            'administered every 20 min for up to three doses',
            'then every 4–6 hrs',
          ],
        ),
        _classCard(
          title: 'CORTICOSTEROIDS',
          color: emergencyGreen,
          bullets: const [
            'Hydrocortisone',
            '10 mg/kg IV stat',
            'Then 5 mg/kg IV q 6 hr',
            'Switch to PO Prednisolone 1–2 mg/kg/d when stable',
          ],
        ),

        // ── Other medications ─────────────────────────────────────────
        const EgSectionLabel('Other medications', '  Escalation'),
        EgCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('OTHER MEDICATIONS',
                  style: TextStyle(
                    color: emergencyBrand,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  )),
              SizedBox(height: 8),
              EgBulletList(items: [
                'Magnesium — 50 mg/kg/dose over 30 min, or infusion at '
                    'a rate of 10–20 mg/kg/hr; can repeat once or twice '
                    'after 4–6 hrs',
                'Theophylline — loading dose of 5–7 mg/kg infused over '
                    '20 min, followed by 0.5–0.9 mg/kg/hr',
                'Ketamine — 1 mg/kg/hr, titrated to effect',
                'Vecuronium — 0.1 mg/kg/hr, titrated to effect',
              ]),
            ],
          ),
        ),

        // ── Pearls ────────────────────────────────────────────────────
        const EgPearl(
          title: 'Severity assessment — research add-on',
          body:
              'GINA 2023 criteria for acute severe asthma in children:\n'
              '• Talks in words / unable to complete sentences\n'
              '• Sits hunched forward, agitated\n'
              '• RR > 30/min, accessory muscle use\n'
              '• HR > 120/min\n'
              '• SpO₂ < 90 % on room air\n'
              '• PEF ≤ 50 % predicted/personal best',
        ),
        const EgPearl(
          icon: Icons.lightbulb_outline,
          title: 'IV magnesium — preferred escalation',
          body:
              'After 1 h of standard therapy with no improvement, IV MgSO₄ '
              '40–50 mg/kg (max 2 g) over 20 min is the first escalation. '
              'Watch BP — magnesium is a vasodilator. Hypotension settles '
              'with fluid bolus.',
        ),
        const EgPearl(
          icon: Icons.warning_amber_rounded,
          title: 'When to intubate — research add-on',
          body:
              'Indications: deteriorating mental status, exhaustion, rising '
              'pCO₂ > 50 mmHg with worsening acidosis, refractory '
              'hypoxaemia. Use ketamine 1–2 mg/kg + rocuronium 1 mg/kg as '
              'RSI. Avoid morphine (histamine release). Permissive '
              'hypercapnia + low rate (8–12) + long expiratory time '
              '(I:E 1:3 to 1:5) to avoid breath stacking.',
        ),

        const EgReferenceCard(
          text:
              'Acute Severe '
              'Asthma card. Research add-ons draw on the GINA Global '
              'Strategy for Asthma Management 2023, BTS/SIGN British '
              'Asthma Guideline 2019 and the AAP Section on Pulmonology '
              'consensus. For use by qualified clinicians only — verify '
              'against the patient\'s clinical context and your local '
              'protocol before administering.',
        ),
      ],
    );
  }
}
