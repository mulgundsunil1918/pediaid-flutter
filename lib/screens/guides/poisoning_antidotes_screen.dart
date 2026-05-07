// =============================================================================
// guides/poisoning_antidotes_screen.dart
// COMMON POISONING AND ANTIDOTES AVAILABLE table.
// All substances, antidotes, and doses transcribed verbatim.
// =============================================================================

import 'package:flutter/material.dart';
import '_emergency_guide_widgets.dart';

class _Antidote {
  final String substance;
  final String antidote;
  final String dose;
  const _Antidote(this.substance, this.antidote, this.dose);
}

const List<_Antidote> _antidotes = [
  _Antidote(
    'Anticholinergics',
    'Physostigmine (IV)',
    '0.5 mg, slow IV over 5 minute; repeated every 10 minute till a maximum of 2 mg',
  ),
  _Antidote(
    'Arsenic, mercury',
    'Dimercaprol (given as IM). Premedication with Histamine (H1 antagonist) is recommended',
    'Arsenic: 3 mg/kg/dose every 4 hrly for 2 days then every 6 hours on '
        'day 3 and then every 12 hrly for 10 days. '
        'Mercury: 5 mg/kg initially, followed by 2.5 mg/kg/dose 1 to 2 '
        'times/day for 10 days',
  ),
  _Antidote(
    'β-blockers',
    'Glucagon (IV, IM, SUBQ)',
    '3–10 mg bolus; if clinical response is obtained start continuous '
        'infusion 3–5 mg/hr. In wt < 20 kg: 0.02–0.03 mg/kg',
  ),
  _Antidote(
    'Benzodiazepines',
    'Flumazenil (IV)',
    'Initial dose: 0.01 mg/kg up to a maximum of 0.2 mg, followed by '
        'infusion of 0.005–0.01 mg/kg/hr',
  ),
  _Antidote(
    'Calcium channel blockers, hydrogen fluoride',
    'Calcium (IV)',
    '60 mg/kg/dose administered over 30–60 minutes',
  ),
  _Antidote(
    'Carbon monoxide',
    'Pure oxygen',
    '(no specific dose listed)',
  ),
  _Antidote(
    'Copper',
    'Penicillamine (oral)',
    '20 mg/kg/day divided every 12 hours',
  ),
  _Antidote(
    'Cyanide',
    'Sodium nitrite (IV) + Sodium thiosulphate (IV)',
    'Sodium nitrite 3 % solution, 0.2 mL/kg IV over 2 minute, followed '
        'by sodium thiosulphate 25 % solution, 1 mL/kg IV over 10–20 minute',
  ),
  _Antidote(
    'Digoxin',
    'Digoxin-specific FAB fragments (IV)',
    '800 mg (20 vials) — single dose or 2 divided doses',
  ),
  _Antidote(
    'Ethylene glycol and Methanol (used in antifreeze, heating fuel, wind-screen wiper and de-icing products)',
    'Fomepizole (IV)',
    'Initial dose: 15 mg/kg. Maintenance: 10 mg/kg every 12 hours for 4 '
        'doses, followed by 5 mg/kg every 12 hours thereafter, until '
        'ethylene glycol or methanol levels have been reduced to < 20 '
        'mg/dL and pH is normal',
  ),
  _Antidote(
    'Heparin',
    'Protamine (IV)',
    '1 mg of protamine for every 100 units of Heparin. Administer as a '
        'slow IV injection over 10 min. Maximum single dose 50 mg',
  ),
  _Antidote(
    'Iron',
    'Desferrioxamine (IV)',
    '15 mg/kg/h IV in 100–200 mL 5 % glucose solution',
  ),
  _Antidote(
    'Isoniazid, ethylene glycol',
    'Pyridoxine (IV)',
    '100 mg per day, until intoxication has resolved',
  ),
  _Antidote(
    'Lead',
    'Sodium calcium edetate (IM / IV)',
    '1000 mg/m²/day or 50 mg/kg/day (max 1000 mg). '
        'Lead Encephalopathy: 1500 mg/m²/day or 50–75 mg/kg/day',
  ),
  _Antidote(
    'Methemoglobinemia',
    'Methylene blue (IV)',
    '1–2 mg/kg every 30–60 minutes',
  ),
  _Antidote(
    'Narcotics (opium)',
    'Naloxone (IV)',
    '0.1 mg/kg/dose, repeat every 2–3 minutes if needed',
  ),
  _Antidote(
    'Nitrate and nitrites',
    'If methemoglobinemia, treat with methylene blue (IV)',
    '1–2 mg/kg every 30–60 minutes',
  ),
  _Antidote(
    'Opioids',
    'Naloxone, Nalmefene (IV)',
    '0.1 mg/kg/dose, repeat every 2–3 minutes if needed (Naloxone)',
  ),
  _Antidote(
    'Organophosphates',
    'Atropine (IV) + PAM (IV)',
    'Atropine — 0.05 mg/kg IV, every 10 minute until signs of '
        'atropinization. PAM 25–50 mg/kg IV in older children and 250 mg '
        'IV in infants over 5–10 minute, 8 hourly up to 36 hour',
  ),
  _Antidote(
    'Paracetamol',
    'N-acetylcysteine (oral, IV)',
    'Oral — initially 140 mg/kg, then 4 hourly, up to 72 hour. '
        'IV — 150 mg/kg by infusion over 15 minute, followed by 50 mg/kg '
        '4 hourly for 72 hour',
  ),
  _Antidote(
    'Phenothiazine',
    'Benadryl (diphenhydramine) (IV)',
    '1–2 mg/kg/dose every 6 hours',
  ),
  _Antidote(
    'Sulfonylurea class of oral hypoglycemic drugs',
    'Octreotide (IV)',
    '50–100 mcg as a single dose. Dose may be repeated every 6 hours',
  ),
  _Antidote(
    'Warfarin',
    'Vitamin K (IV)',
    '0.3 mg/kg/dose once a day',
  ),
];

class PoisoningAntidotesScreen extends StatelessWidget {
  const PoisoningAntidotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return EgScaffold(
      title: 'Poisoning & Antidotes',
      subtitle: 'Common substances, their antidotes, and exact doses.',
      children: [
        // ── Search-friendly antidote list ─────────────────────────────
        const EgSectionLabel('Antidotes', '  Substance → Antidote → Dose'),
        ..._antidotes.map((a) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border(
                    left: const BorderSide(color: emergencyBrand, width: 4),
                    top: BorderSide(
                        color: cs.onSurface.withValues(alpha: 0.10)),
                    right: BorderSide(
                        color: cs.onSurface.withValues(alpha: 0.10)),
                    bottom: BorderSide(
                        color: cs.onSurface.withValues(alpha: 0.10)),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.substance,
                        style: TextStyle(
                          color: cs.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        )),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: emergencyBrand.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        a.antidote,
                        style: const TextStyle(
                          color: emergencyBrand,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(a.dose,
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.85),
                          fontSize: 12.5,
                          height: 1.55,
                        )),
                  ],
                ),
              ),
            )),

        // ── Activated charcoal ────────────────────────────────────────
        const EgSectionLabel('Activated charcoal', '  Indications + PHAILS'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  decoration: BoxDecoration(
                    color: emergencyGreen.withValues(alpha: 0.08),
                    border:
                        Border.all(color: emergencyGreen.withValues(alpha: 0.35)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('INDICATED FOR',
                          style: TextStyle(
                            color: emergencyGreen,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          )),
                      SizedBox(height: 6),
                      EgBulletList(items: [
                        'Salicylates',
                        'Phenobarbital',
                        'Carbamazepine',
                        'Digoxin',
                        'Theophylline',
                      ]),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  decoration: BoxDecoration(
                    color: emergencyRed.withValues(alpha: 0.08),
                    border:
                        Border.all(color: emergencyRed.withValues(alpha: 0.35)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('NOT ABSORBED  (PHAILS)',
                          style: TextStyle(
                            color: emergencyRed,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          )),
                      SizedBox(height: 6),
                      EgBulletList(items: [
                        'P — Pesticides',
                        'H — Hydrocarbons',
                        'A — Acids, Alkalis, Alcohols',
                        'I — Iron',
                        'L — Lithium',
                        'S — Solvents',
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Hemodialysis indications ──────────────────────────────────
        const EgSectionLabel('Haemodialysis', '  When to dialyse'),
        const EgCard(
          child: EgBlock(
            title: 'Indications for hemodialysis',
            lines: [
              'Methanol',
              'Ethylene Glycol',
              'Salicylate',
              'Phenobarbitone',
              'Theophylline',
              'Lithium',
            ],
          ),
        ),

        const EgPearl(
          title: 'Dialysable poison mnemonic — ISTUMBLE',
          body:
              'I — Isopropanol, S — Salicylates, T — Theophylline, U — Uraemia, '
              'M — Methanol, B — Barbiturates (long-acting), L — Lithium, '
              'E — Ethylene glycol. Useful one-line memory aid for the '
              'dialysable poisons list.',
        ),
        const EgPearl(
          icon: Icons.report_outlined,
          title: 'Activated charcoal — single dose protocol',
          body:
              '1 g/kg PO/NG (max 50 g) within 1 hour of ingestion. Can be '
              'given later for sustained-release preparations or '
              'anticholinergics that delay gastric emptying. Multi-dose '
              'activated charcoal (0.5 g/kg q 4–6 h) for carbamazepine, '
              'phenobarbital, theophylline, dapsone, quinine.',
        ),

        // ── National Poisons Info Center ──────────────────────────────
        const EgSectionLabel('Helpline', '  AIIMS 24×7'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: emergencyBrand,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(Icons.phone_in_talk, color: Colors.white, size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NATIONAL POISONS INFORMATION CENTER, AIIMS (24×7)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '011-26593677',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const EgReferenceCard(
          text:
              'Common Poisoning '
              'and Antidotes Available card. Mnemonic + clinical notes '
              'are research add-ons (Goldfrank\'s Toxicologic Emergencies, '
              '11th ed.; AAP Committee on Drugs). For use by qualified '
              'clinicians only — verify dose and route against the source '
              'guideline before administering.',
        ),
      ],
    );
  }
}
