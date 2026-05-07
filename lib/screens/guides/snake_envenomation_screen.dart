// =============================================================================
// guides/snake_envenomation_screen.dart
// SNAKE ENVENOMATION & MANAGEMENT card.
// All values transcribed verbatim. Research add-ons in EgPearl boxes.
// =============================================================================

import 'package:flutter/material.dart';
import '_emergency_guide_widgets.dart';

class SnakeEnvenomationScreen extends StatelessWidget {
  const SnakeEnvenomationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EgScaffold(
      title: 'Snake Envenomation',
      subtitle: 'Suspected snake bite — first aid, recognition, anti-snake venom.',
      children: [
        // ── DON'T do these things ──────────────────────────────────────
        const EgSectionLabel('Don\'t do these things', '  Pre-hospital'),
        const EgDontDoCard(
          title: '6 things to AVOID',
          items: [
            'No tourniquet',
            'No cuts',
            'No washing',
            'No sucking of venom',
            'No electrical shock',
            'No herbal medicine',
          ],
        ),

        // ── Do these things ────────────────────────────────────────────
        const EgSectionLabel('Do these things', '  R.I.GH.T'),
        EgCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('"DO IT R.I.GH.T"',
                  style: TextStyle(
                    color: emergencyBrand,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
                  )),
              SizedBox(height: 10),
              EgBulletList(
                numbered: true,
                items: [
                  'R — Reassure',
                  'I — Immobilize',
                  'G.H — Get to Hospital',
                  'T — Tell doctor about specific symptoms',
                ],
              ),
            ],
          ),
        ),

        // ── Suspected snake bite triage ────────────────────────────────
        const EgSectionLabel('Triage', '  Suspected snake bite'),
        const EgBanner(
          icon: Icons.alt_route,
          title: 'Branches into: ENVENOMATION CONFIRMED  ·  VENOM NOT INJECTED',
        ),

        // ── When venom not injected ───────────────────────────────────
        const EgSectionLabel('Venom NOT injected', '  Dry-bite features'),
        const EgCard(
          child: EgBlock(
            title: 'When venom not injected',
            lines: [
              'Bite mark may or may not there',
              'Vasovagal',
              'Feeling cold',
              'Fear',
              'Anxiety',
              'Brady or tachycardia',
              'No systemic symptoms',
            ],
          ),
        ),
        const EgPearl(
          title: 'Dry bite — research add-on',
          body:
              '20–50 % of venomous snake bites are "dry bites" with no '
              'envenomation. Observe for at least 24 hours regardless — '
              'symptoms (esp. neurological from kraits) can be delayed by '
              '6–12 hours. Always recheck WBCT-20 at 6 h.',
        ),

        // ── Local effects ──────────────────────────────────────────────
        const EgSectionLabel('Envenomation confirmed', '  Local effects'),
        const EgCard(
          child: EgBlock(
            title: 'Local effects of envenomation',
            lines: [
              'Fang marks',
              'Local pain',
              'Local bleeding',
              'Bruising',
              'Lymphangitis',
              'Lymph node enlargement',
              'Inflammation (swelling, redness, heat)',
              'Blistering',
              'Local infection, abscess formation',
              'Necrosis',
            ],
          ),
        ),

        // ── Generalized symptoms ──────────────────────────────────────
        const EgSectionLabel('Systemic', '  Generalised symptoms'),
        const EgCard(
          child: EgBlock(
            title: 'Generalized symptoms',
            lines: [
              'Nausea',
              'Vomiting',
              'Malaise',
              'Abdominal pain',
              'Weakness',
              'Drowsiness',
              'Prostration',
            ],
          ),
        ),

        // ── Cardiovascular (Vipers) ───────────────────────────────────
        const EgSectionLabel('Vipers', '  Cardiovascular'),
        const EgCard(
          child: EgBlock(
            title: 'Cardiovascular (Vipers)',
            lines: [
              'Dizziness',
              'Faintness',
              'Collapse',
              'Shock',
              'Hypotension',
              'Cardiac arrhythmias',
              'Pulmonary oedema',
              'Cardiac arrest',
            ],
          ),
        ),

        // ── Hematological (Vipers) ────────────────────────────────────
        const EgSectionLabel('Vipers', '  Haematological'),
        const EgCard(
          child: EgBlock(
            title: 'Hematological (vipers)',
            lines: [
              'Bleeding from bite site',
              'Bleeding from old or partly old wounds',
              'Systemic spontaneous bleeding (Gums, Nose, Malena, '
                  'Hematuria, Vaginal bleeding, skin bleeds, mucosal bleeding)',
            ],
          ),
        ),
        const EgPearl(
          title: 'WBCT-20 — research add-on',
          body:
              'Whole-blood clotting time at 20 minutes is the bedside test '
              'for viper envenomation. Place 1–2 mL of fresh blood in a '
              'clean, dry test tube. Leave undisturbed 20 min. If still '
              'liquid → coagulopathy → ASV indicated. Repeat 6-hourly until '
              'normal.',
        ),

        // ── Neurological (Kraits) ─────────────────────────────────────
        const EgSectionLabel('Kraits', '  Neurological'),
        const EgCard(
          child: EgBlock(
            title: 'Neurological (Kraits)',
            lines: [
              'Drowsiness',
              'Paraesthesiae',
              'Heavy eyelids, ptosis, external ophthalmoplegia',
              'Paralysis of facial muscles',
              'Difficulty in opening mouth and showing tongue',
              'Weakness of other muscles innervated by the cranial nerves',
              'Aphonia',
              'Difficulty in swallowing secretions',
              'Respiratory and generalised flaccid paralysis',
            ],
          ),
        ),

        // ── Skeletal muscles breakdown ────────────────────────────────
        const EgSectionLabel('Sea snakes', '  Myotoxic features'),
        const EgCard(
          child: EgBlock(
            title: 'Skeletal muscles breakdown',
            lines: [
              'Generalised pain',
              'Stiffness and tenderness of muscles',
              'Trismus',
              'Myoglobinuria',
              'Hyperkalaemia',
              'Cardiac arrest',
            ],
          ),
        ),

        // ── Renal ─────────────────────────────────────────────────────
        const EgSectionLabel('Renal', '  AKI features'),
        const EgCard(
          child: EgBlock(
            title: 'Renal',
            lines: [
              'Lumbar pain',
              'Haematuria',
              'Haemoglobinuria',
              'Myoglobinuria',
              'Oliguria/anuria',
              'Symptoms and signs of uraemia',
            ],
          ),
        ),

        // ── Investigations ────────────────────────────────────────────
        const EgSectionLabel('Investigations required', ''),
        const EgCard(
          child: EgBlock(
            title: 'Send baseline workup',
            lines: [
              'Hemogram',
              'Whole blood clotting time',
              'PT, APTT, INR',
              'Urine examination',
              'Renal function test',
              'Serum electrolytes',
            ],
          ),
        ),

        // ── Management ────────────────────────────────────────────────
        const EgSectionLabel('Management', ''),
        const EgBanner(
          icon: Icons.local_hospital,
          title: '1.  Airway, Breathing, Circulation (ABC)',
        ),
        const SizedBox(height: 10),
        EgCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('2.  ANTI-SNAKE VENOM (ASV)',
                  style: TextStyle(
                    color: emergencyBrand,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  )),
              SizedBox(height: 8),
              EgBulletList(items: [
                'Usual dose 8–10 vials',
                'Should be administered over few hours',
                'Can be repeated as per response',
              ]),
            ],
          ),
        ),
        const SizedBox(height: 10),
        EgCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('3.  ALLERGIC REACTION TO ASV',
                  style: TextStyle(
                    color: emergencyRed,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  )),
              SizedBox(height: 8),
              EgBulletList(items: [
                'a) Hydrocortisone',
                'b) Anti-histaminic',
                'c) In Anaphylaxis (Adrenalin)',
              ]),
            ],
          ),
        ),

        const EgPearl(
          title: 'ASV reconstitution + dosing — research add-on',
          body:
              'India: Polyvalent ASV covers Big Four (Cobra, Krait, Russell\'s '
              'viper, Saw-scaled viper). Reconstitute each vial in 10 mL '
              'sterile water; dilute total in 200–250 mL NS. Infuse over '
              '60 min. Children get the SAME dose as adults — venom load '
              'is the same. Repeat every 6 h until WBCT < 20 min and '
              'neurotoxicity reverses or stabilises.',
        ),
        const EgPearl(
          icon: Icons.warning_amber_rounded,
          title: 'Atropine + neostigmine for neurotoxicity',
          body:
              'For krait/cobra neurotoxicity: Atropine 0.05 mg/kg + '
              'Neostigmine 0.04 mg/kg IV. Reassess at 30 min — if '
              'improved, repeat neostigmine 0.04 mg/kg with atropine '
              '0.025 mg/kg every 30 min × 5 doses, then 1–2 hourly.',
        ),

        const EgReferenceCard(
          text:
              'Snake Envenomation '
              '& Management card. Research add-ons draw on WHO SE-Asia '
              'Regional Snakebite Guidelines (2016) and the ICMR Indian '
              'Snakebite Management Protocol. For use by qualified clinicians '
              'only — verify against local antivenom availability and the '
              'patient\'s clinical context before administration.',
        ),
      ],
    );
  }
}
