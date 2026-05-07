// =============================================================================
// lib/screens/guides/developmental_milestones/dev_milestones_data.dart
//
// Source-of-truth data for the Developmental Milestones module.
//
// PRIMARY SOURCE — preserved verbatim from:
//   AIIMS New Delhi · Department of Paediatrics · Child Neurology Division
//   Prof. Sheffali Gulati · pedneuroaiims.org
//   Reference card "Developmental Milestones" (2-page handout).
//
// ENRICHMENTS from other reputable paediatric sources:
//   - Nelson Textbook of Pediatrics (chapters on Developmental & Behavioural)
//   - Ghai Essential Pediatrics (Indian standard textbook, growth-and-
//     development chapter)
//   - WHO Multicentre Growth Reference Study — windows of achievement for
//     six gross motor milestones (2006)
//   - AAP / Bright Futures developmental surveillance schedule
//
// Every milestone and red-flag in the PDF is included verbatim. Cross-source
// additions (e.g. WHO motor windows, DQ interpretation bands) are clearly
// attributed in the renderer, not blended into the AIIMS strings.
// =============================================================================

import 'package:flutter/material.dart';

// ── Domains ─────────────────────────────────────────────────────────────────

enum DevDomain {
  grossMotor,
  fineMotor,
  language,
  hearing,
  socioadaptive,
  vision,
}

/// Display metadata per domain — title, short label, emoji, accent colour.
class DevDomainInfo {
  final String title;
  final String shortLabel;
  final String emoji;
  final Color color;
  final IconData icon;
  const DevDomainInfo({
    required this.title,
    required this.shortLabel,
    required this.emoji,
    required this.color,
    required this.icon,
  });
}

const Map<DevDomain, DevDomainInfo> kDomainInfo = {
  DevDomain.grossMotor: DevDomainInfo(
    title: 'Gross Motor',
    shortLabel: 'Gross Motor',
    emoji: '🦵',
    color: Color(0xFF1565C0),
    icon: Icons.directions_run_rounded,
  ),
  DevDomain.fineMotor: DevDomainInfo(
    title: 'Fine Motor',
    shortLabel: 'Fine Motor',
    emoji: '✋',
    color: Color(0xFF6A1B9A),
    icon: Icons.pan_tool_rounded,
  ),
  DevDomain.language: DevDomainInfo(
    title: 'Language',
    shortLabel: 'Language',
    emoji: '💬',
    color: Color(0xFFE65100),
    icon: Icons.record_voice_over_rounded,
  ),
  DevDomain.hearing: DevDomainInfo(
    title: 'Hearing',
    shortLabel: 'Hearing',
    emoji: '👂',
    color: Color(0xFF00897B),
    icon: Icons.hearing_rounded,
  ),
  DevDomain.socioadaptive: DevDomainInfo(
    title: 'Socioadaptive',
    shortLabel: 'Social',
    emoji: '🤝',
    color: Color(0xFFAD1457),
    icon: Icons.groups_rounded,
  ),
  DevDomain.vision: DevDomainInfo(
    title: 'Vision',
    shortLabel: 'Vision',
    emoji: '👁️',
    color: Color(0xFF455A64),
    icon: Icons.visibility_rounded,
  ),
};

// ── Models ──────────────────────────────────────────────────────────────────

/// One developmental milestone. Months may be fractional (e.g. 0.92 for 4
/// weeks; 6.5 for 26 weeks IU we render with `prenatal: true`). The
/// `ageLabel` string is what's shown on screen, untouched from the
/// reference handout.
class Milestone {
  final DevDomain domain;
  final double ageMonths;
  final String ageLabel;
  final String description;
  /// True for intrauterine entries (e.g. 29 weeks IU, 26 weeks IU). They
  /// render with a "Prenatal" tag and don't participate in DQ
  /// calculations.
  final bool prenatal;

  const Milestone({
    required this.domain,
    required this.ageMonths,
    required this.ageLabel,
    required this.description,
    this.prenatal = false,
  });
}

/// A single age × domain red flag — when this milestone is NOT achieved
/// by the listed age, it warrants formal developmental assessment.
class RedFlag {
  final DevDomain domain;
  final double ageMonths;
  final String ageLabel;
  final String description;
  const RedFlag({
    required this.domain,
    required this.ageMonths,
    required this.ageLabel,
    required this.description,
  });
}

// ── Milestones (ALL 76 entries — every word from AIIMS handout, verbatim)──

const List<Milestone> kMilestones = [
  // ════════════════════════════════════════════════════════════════════════
  // GROSS MOTOR — 17 entries
  // ════════════════════════════════════════════════════════════════════════
  Milestone(
    domain: DevDomain.grossMotor,
    ageMonths: 1,
    ageLabel: '4 weeks',
    description:
        'Complete head lag on pull to sit, pelvis high with knees under abdomen',
  ),
  Milestone(
    domain: DevDomain.grossMotor,
    ageMonths: 2,
    ageLabel: '8 weeks',
    description:
        'On pull to sit less head lag, on ventral suspension can maintain head in same plane as rest of the body, in prone position has head in midline',
  ),
  Milestone(
    domain: DevDomain.grossMotor,
    ageMonths: 3,
    ageLabel: '12 weeks',
    description:
        'Bears weight on forearm, face couch angle 45°–90°, only slight head lag on pull to sit',
  ),
  Milestone(
    domain: DevDomain.grossMotor,
    ageMonths: 5,
    ageLabel: '20 weeks',
    description: 'No head lag',
  ),
  Milestone(
    domain: DevDomain.grossMotor,
    ageMonths: 6,
    ageLabel: '6 months',
    description:
        'Keeps chest and upper part of abdomen off couch, rolls from prone to supine, sits supported (with back support)',
  ),
  Milestone(
    domain: DevDomain.grossMotor,
    ageMonths: 7,
    ageLabel: '7 months',
    description:
        'Sits on couch with hand support, weights on one hand, rolls from supine to prone',
  ),
  Milestone(
    domain: DevDomain.grossMotor,
    ageMonths: 9,
    ageLabel: '9 months',
    description: 'Crawls, stands himself on holding furniture',
  ),
  Milestone(
    domain: DevDomain.grossMotor,
    ageMonths: 10,
    ageLabel: '10 months',
    description: 'Creeps on hands and knees with abdomen off',
  ),
  Milestone(
    domain: DevDomain.grossMotor,
    ageMonths: 11,
    ageLabel: '11 months',
    description:
        'Cruises (walks holding on to furniture); pivots (twisting around to pick an object)',
  ),
  Milestone(
    domain: DevDomain.grossMotor,
    ageMonths: 12,
    ageLabel: '12 months',
    description: 'Walks with one hand held',
  ),
  Milestone(
    domain: DevDomain.grossMotor,
    ageMonths: 15,
    ageLabel: '15 months',
    description: 'Walks unsupported',
  ),
  Milestone(
    domain: DevDomain.grossMotor,
    ageMonths: 18,
    ageLabel: '18 months',
    description: 'Runs stiffly',
  ),
  Milestone(
    domain: DevDomain.grossMotor,
    ageMonths: 24,
    ageLabel: '24 months',
    description:
        'Goes up and downstairs two feet per step; runs properly',
  ),
  Milestone(
    domain: DevDomain.grossMotor,
    ageMonths: 30,
    ageLabel: '2½ years',
    description: 'Jumps with both feet, walks on tip toe',
  ),
  Milestone(
    domain: DevDomain.grossMotor,
    ageMonths: 36,
    ageLabel: '3 years',
    description:
        'Rides a tricycle, goes up stairs — one foot per step, goes downstairs — two feet per step',
  ),
  Milestone(
    domain: DevDomain.grossMotor,
    ageMonths: 48,
    ageLabel: '4 years',
    description: 'Goes downstairs one foot per step; skips on one foot',
  ),
  Milestone(
    domain: DevDomain.grossMotor,
    ageMonths: 60,
    ageLabel: '5 years',
    description: 'Skips on both feet',
  ),

  // ════════════════════════════════════════════════════════════════════════
  // FINE MOTOR — 14 entries
  // ════════════════════════════════════════════════════════════════════════
  Milestone(
    domain: DevDomain.fineMotor,
    ageMonths: 1,
    ageLabel: '1 month',
    description: 'Primitive grasp reflex',
  ),
  Milestone(
    domain: DevDomain.fineMotor,
    ageMonths: 3,
    ageLabel: '3 months',
    description: 'No grasp reflex, retains rattle if placed in hand',
  ),
  Milestone(
    domain: DevDomain.fineMotor,
    ageMonths: 4,
    ageLabel: '4 months',
    description: 'Hand regard, bidextrous approach',
  ),
  Milestone(
    domain: DevDomain.fineMotor,
    ageMonths: 5,
    ageLabel: '5 months',
    description: 'Palmar grasp',
  ),
  Milestone(
    domain: DevDomain.fineMotor,
    ageMonths: 6,
    ageLabel: '6 months',
    description: 'Unidextrous approach, transfers of objects',
  ),
  Milestone(
    domain: DevDomain.fineMotor,
    ageMonths: 9,
    ageLabel: '9 months',
    description: 'Pincer grasp',
  ),
  Milestone(
    domain: DevDomain.fineMotor,
    ageMonths: 12,
    ageLabel: '12 months',
    description: 'Casting',
  ),
  Milestone(
    domain: DevDomain.fineMotor,
    ageMonths: 15,
    ageLabel: '15 months',
    description:
        'Picks up & drinks from cup, scribbles spontaneously, tower of 2 cubes',
  ),
  Milestone(
    domain: DevDomain.fineMotor,
    ageMonths: 18,
    ageLabel: '18 months',
    description: 'Manages spoon well, tower of 3–4 cubes, turns 2–3 pages',
  ),
  Milestone(
    domain: DevDomain.fineMotor,
    ageMonths: 24,
    ageLabel: '2 years',
    description:
        'Takes off clothes without buttons, imitates horizontal line and circle, tower of 5–6 cubes, turns page singly',
  ),
  Milestone(
    domain: DevDomain.fineMotor,
    ageMonths: 30,
    ageLabel: '2½ years',
    description: 'Imitate vertical line, tower of 8 cubes',
  ),
  Milestone(
    domain: DevDomain.fineMotor,
    ageMonths: 36,
    ageLabel: '3 years',
    description:
        'Puts on shoes without lace, unbuttons, imitates cross, copies circle, tower of 9–10 cubes, imitates bridge',
  ),
  Milestone(
    domain: DevDomain.fineMotor,
    ageMonths: 48,
    ageLabel: '4 years',
    description:
        'Copies cross, draw a man test 4 parts, incomplete man 3 parts, buttons',
  ),
  Milestone(
    domain: DevDomain.fineMotor,
    ageMonths: 54,
    ageLabel: '4½ years',
    description:
        'Copies square, copies gate, draw a man test 6 parts, incomplete man adds six parts',
  ),

  // ════════════════════════════════════════════════════════════════════════
  // LANGUAGE — 14 entries
  // ════════════════════════════════════════════════════════════════════════
  Milestone(
    domain: DevDomain.language,
    ageMonths: 1,
    ageLabel: '4 weeks',
    description: 'Quietens when bell is rung',
  ),
  Milestone(
    domain: DevDomain.language,
    ageMonths: 2,
    ageLabel: '8 weeks',
    description: 'Smiles and vocalizes when talked to',
  ),
  Milestone(
    domain: DevDomain.language,
    ageMonths: 3,
    ageLabel: '12 weeks',
    description: 'Squeals with pleasure, aah-naah',
  ),
  Milestone(
    domain: DevDomain.language,
    ageMonths: 4,
    ageLabel: '16 weeks',
    description: 'Aah-goo',
  ),
  Milestone(
    domain: DevDomain.language,
    ageMonths: 5,
    ageLabel: '20 weeks',
    description: 'Razzing (blowing between partly closed lips)',
  ),
  Milestone(
    domain: DevDomain.language,
    ageMonths: 6,
    ageLabel: '24 weeks',
    description: 'Monosyllabic babble (ba-ba, da-da)',
  ),
  Milestone(
    domain: DevDomain.language,
    ageMonths: 8,
    ageLabel: '32 weeks',
    description: 'Bisyllable (ba-ba, da-da)',
  ),
  Milestone(
    domain: DevDomain.language,
    ageMonths: 12,
    ageLabel: '1 year',
    description: '2–3 words with meaning',
  ),
  Milestone(
    domain: DevDomain.language,
    ageMonths: 15,
    ageLabel: '15 months',
    description: 'Jargoning',
  ),
  Milestone(
    domain: DevDomain.language,
    ageMonths: 18,
    ageLabel: '18 months',
    description: '10 words with meaning',
  ),
  Milestone(
    domain: DevDomain.language,
    ageMonths: 24,
    ageLabel: '2 years',
    description: '50 words vocabulary',
  ),
  Milestone(
    domain: DevDomain.language,
    ageMonths: 36,
    ageLabel: '3 years',
    description:
        '250 words vocabulary, questioning, uses pronouns, nursery rhymes',
  ),
  Milestone(
    domain: DevDomain.language,
    ageMonths: 48,
    ageLabel: '4 years',
    description: 'Speaks in sentences of 5–6 words; tells long stories',
  ),
  Milestone(
    domain: DevDomain.language,
    ageMonths: 60,
    ageLabel: '5 years',
    description:
        'Speaks sentences of more than 5 words; uses future tense; says name and address',
  ),

  // ════════════════════════════════════════════════════════════════════════
  // HEARING — 8 entries (one prenatal)
  // ════════════════════════════════════════════════════════════════════════
  Milestone(
    domain: DevDomain.hearing,
    ageMonths: -3.25, // 26 weeks IU sorts before birth
    ageLabel: '26 weeks IU',
    description: 'Startle reflex',
    prenatal: true,
  ),
  Milestone(
    domain: DevDomain.hearing,
    ageMonths: 3,
    ageLabel: '3 months',
    description: 'Turns the head to the side from where sound is coming',
  ),
  Milestone(
    domain: DevDomain.hearing,
    ageMonths: 3.5,
    ageLabel: '3–4 months',
    description: 'Turns the head as well as eyes to the direction of sound',
  ),
  Milestone(
    domain: DevDomain.hearing,
    ageMonths: 5.5,
    ageLabel: '5–6 months',
    description: 'Turns head sidewards and below',
  ),
  Milestone(
    domain: DevDomain.hearing,
    ageMonths: 6,
    ageLabel: '6 months',
    description:
        'Turns head sidewards and then upward; starts imitating sounds',
  ),
  Milestone(
    domain: DevDomain.hearing,
    ageMonths: 7,
    ageLabel: '6–8 months',
    description: 'Starts responding to name',
  ),
  Milestone(
    domain: DevDomain.hearing,
    ageMonths: 9,
    ageLabel: '8–10 months',
    description: 'Turns head diagonally and directly towards the sound source',
  ),
  Milestone(
    domain: DevDomain.hearing,
    ageMonths: 12,
    ageLabel: '1 year',
    description: 'Ability to localize sound as good as adult',
  ),

  // ════════════════════════════════════════════════════════════════════════
  // SOCIOADAPTIVE — 14 entries
  // ════════════════════════════════════════════════════════════════════════
  Milestone(
    domain: DevDomain.socioadaptive,
    ageMonths: 2,
    ageLabel: '2 months',
    description: 'Social smile',
  ),
  Milestone(
    domain: DevDomain.socioadaptive,
    ageMonths: 3,
    ageLabel: '3 months',
    description: 'Recognises mother',
  ),
  Milestone(
    domain: DevDomain.socioadaptive,
    ageMonths: 5,
    ageLabel: '5 months',
    description: 'Smiles at mirror image',
  ),
  Milestone(
    domain: DevDomain.socioadaptive,
    ageMonths: 6,
    ageLabel: '6 months',
    description: 'Stretches arms out to be held; stranger anxiety',
  ),
  Milestone(
    domain: DevDomain.socioadaptive,
    ageMonths: 7,
    ageLabel: '7 months',
    description: 'Responds to name',
  ),
  Milestone(
    domain: DevDomain.socioadaptive,
    ageMonths: 9,
    ageLabel: '9 months',
    description:
        'Waves "bye-bye"; pulls clothes of another to attract attention; repeats performance laughed at; responds to words e.g., "where is daddy?"',
  ),
  Milestone(
    domain: DevDomain.socioadaptive,
    ageMonths: 12,
    ageLabel: '12 months',
    description: 'Plays peek-boo while covering face',
  ),
  Milestone(
    domain: DevDomain.socioadaptive,
    ageMonths: 15,
    ageLabel: '15 months',
    description: 'Indicates wet pants',
  ),
  Milestone(
    domain: DevDomain.socioadaptive,
    ageMonths: 18,
    ageLabel: '18 months',
    description:
        'Domestic mimicry; points to 2–3 body parts, is dry by the day',
  ),
  Milestone(
    domain: DevDomain.socioadaptive,
    ageMonths: 24,
    ageLabel: '2 years',
    description:
        'Parallel play (watches others play and plays near them, but not with them)',
  ),
  Milestone(
    domain: DevDomain.socioadaptive,
    ageMonths: 30,
    ageLabel: '2½ years',
    description: 'Knows full name and gender',
  ),
  Milestone(
    domain: DevDomain.socioadaptive,
    ageMonths: 36,
    ageLabel: '3 years',
    description: 'Shares toys, joins in play',
  ),
  Milestone(
    domain: DevDomain.socioadaptive,
    ageMonths: 48,
    ageLabel: '4 years',
    description: 'Attends to own toilet needs',
  ),
  Milestone(
    domain: DevDomain.socioadaptive,
    ageMonths: 60,
    ageLabel: '5 years',
    description: 'Distinguishes morning from noon, compares 2 weights',
  ),

  // ════════════════════════════════════════════════════════════════════════
  // VISION — 9 entries (one prenatal)
  // ════════════════════════════════════════════════════════════════════════
  Milestone(
    domain: DevDomain.vision,
    ageMonths: -2.5, // 29 weeks IU
    ageLabel: '29 weeks IU',
    description: 'Pupillary reflex',
    prenatal: true,
  ),
  Milestone(
    domain: DevDomain.vision,
    ageMonths: 0,
    ageLabel: 'At birth',
    description:
        'Horizontal tracking of mother\'s face till 180°; follows dangling ring up to 45°',
  ),
  Milestone(
    domain: DevDomain.vision,
    ageMonths: 1.25,
    ageLabel: '4–6 weeks',
    description: 'Vertical tracking; follows dangling ring to 90°',
  ),
  Milestone(
    domain: DevDomain.vision,
    ageMonths: 3,
    ageLabel: '12 weeks',
    description:
        'Follows dangling ring up to 180°; looks at the objects in the midline',
  ),
  Milestone(
    domain: DevDomain.vision,
    ageMonths: 4,
    ageLabel: '16 weeks',
    description: 'Immediate regard of the dangling object',
  ),
  Milestone(
    domain: DevDomain.vision,
    ageMonths: 5,
    ageLabel: '4–6 months',
    description: 'Well established binocular vision',
  ),
  Milestone(
    domain: DevDomain.vision,
    ageMonths: 6,
    ageLabel: '6 months',
    description: 'Adjusts position to see an object',
  ),
  Milestone(
    domain: DevDomain.vision,
    ageMonths: 12,
    ageLabel: '1 year',
    description: 'Begins to appreciate forms and colours',
  ),
  Milestone(
    domain: DevDomain.vision,
    ageMonths: 30,
    ageLabel: '2½ years',
    description: 'Fully mature visual acuity',
  ),
];

// ── Red flags (ALL 23 — every word from AIIMS handout, verbatim) ────────────

const List<RedFlag> kRedFlags = [
  // Gross motor
  RedFlag(domain: DevDomain.grossMotor, ageMonths: 9,  ageLabel: '9 months',  description: 'No sitting without support'),
  RedFlag(domain: DevDomain.grossMotor, ageMonths: 12, ageLabel: '12 months', description: 'No standing with assistance'),
  RedFlag(domain: DevDomain.grossMotor, ageMonths: 17, ageLabel: '17 months', description: 'Unable to stand alone'),
  RedFlag(domain: DevDomain.grossMotor, ageMonths: 18, ageLabel: '18 months', description: 'Unable to walk alone'),
  RedFlag(domain: DevDomain.grossMotor, ageMonths: 24, ageLabel: '2 years',   description: 'Unable to walk upstairs with help'),
  RedFlag(domain: DevDomain.grossMotor, ageMonths: 48, ageLabel: '4 years',   description: 'Unable to jump'),

  // Fine motor
  RedFlag(domain: DevDomain.fineMotor, ageMonths: 5,  ageLabel: '5 months',  description: 'Unable to hold rattle'),
  RedFlag(domain: DevDomain.fineMotor, ageMonths: 12, ageLabel: '12 months', description: 'No pincer grasp'),
  RedFlag(domain: DevDomain.fineMotor, ageMonths: 20, ageLabel: '20 months', description: 'Unable to remove socks/gloves'),
  RedFlag(domain: DevDomain.fineMotor, ageMonths: 24, ageLabel: '24 months', description: 'Unable to scribble'),
  RedFlag(domain: DevDomain.fineMotor, ageMonths: 36, ageLabel: '3 years',   description: 'Cannot work simple toys'),
  RedFlag(domain: DevDomain.fineMotor, ageMonths: 60, ageLabel: '5 years',   description: 'Does not draw picture'),

  // Socioadaptive
  RedFlag(domain: DevDomain.socioadaptive, ageMonths: 2,  ageLabel: '2 months',  description: 'No social smile'),
  RedFlag(domain: DevDomain.socioadaptive, ageMonths: 12, ageLabel: '12 months', description: 'No pointing'),
  RedFlag(domain: DevDomain.socioadaptive, ageMonths: 36, ageLabel: '3 years',   description: 'No pretend play'),
  RedFlag(domain: DevDomain.socioadaptive, ageMonths: 48, ageLabel: '4 years',   description: 'Does not respond to peers'),
  RedFlag(domain: DevDomain.socioadaptive, ageMonths: 60, ageLabel: '5 years',   description: 'Unusually withdrawn and not active'),

  // Hearing / Speech (PDF labels these "Red Flags for Hearing"; they
  // describe expressive-language deficits used to flag hearing/language
  // concerns. We file under hearing for parity with the PDF.)
  RedFlag(domain: DevDomain.hearing, ageMonths: 12, ageLabel: '12 months', description: 'No babbling / vocal imitation'),
  RedFlag(domain: DevDomain.hearing, ageMonths: 18, ageLabel: '18 months', description: 'No use of single words'),
  RedFlag(domain: DevDomain.hearing, ageMonths: 24, ageLabel: '24 months', description: 'Single word vocabulary ≤10 words'),
  RedFlag(domain: DevDomain.hearing, ageMonths: 30, ageLabel: '30 months', description: '<100 words, no 2-word combination'),
  RedFlag(domain: DevDomain.hearing, ageMonths: 36, ageLabel: '36 months', description: '<200 words, no telegraphic sentence'),
  RedFlag(domain: DevDomain.hearing, ageMonths: 42, ageLabel: '42 months', description: '<600 words, no simple sentences'),
];

// ── DQ interpretation bands (Nelson / Ghai consensus) ──────────────────────
//
// Developmental Quotient (DQ) = (Developmental age / Chronological age) × 100
// Cutoffs used in routine paediatric practice:

class DqBand {
  final double lower; // inclusive
  final double upper; // exclusive (or +inf when null)
  final String label;
  final String interpretation;
  final Color color;
  const DqBand({
    required this.lower,
    required this.upper,
    required this.label,
    required this.interpretation,
    required this.color,
  });
}

const List<DqBand> kDqBands = [
  DqBand(
    lower: 85, upper: 200,
    label: 'Normal',
    interpretation:
        'Development on track for chronological age. Continue routine surveillance.',
    color: Color(0xFF2E7D32),
  ),
  DqBand(
    lower: 70, upper: 85,
    label: 'At-risk / borderline',
    interpretation:
        'Borderline delay. Re-evaluate in 3 months; consider formal screening (TDSC, ASQ-3) and address modifiable factors (hearing, vision, nutrition, stimulation).',
    color: Color(0xFFE65100),
  ),
  DqBand(
    lower: 0, upper: 70,
    label: 'Significant delay',
    interpretation:
        'Significant developmental delay. Refer for full developmental assessment + early intervention. Look for cause (perinatal events, syndromic features, regression, sensory deficits, neglect).',
    color: Color(0xFFB71C1C),
  ),
];

DqBand interpretDq(double dq) {
  for (final b in kDqBands) {
    if (dq >= b.lower && dq < b.upper) return b;
  }
  return kDqBands.last;
}

// ── Helpers ─────────────────────────────────────────────────────────────────

/// All postnatal milestones at or before [chronoAgeMonths], grouped by
/// domain and sorted oldest-first (most recently achieved at the top
/// inside each domain).
Map<DevDomain, List<Milestone>> milestonesUpTo(double chronoAgeMonths) {
  final out = <DevDomain, List<Milestone>>{
    for (final d in DevDomain.values) d: <Milestone>[],
  };
  for (final m in kMilestones) {
    if (m.prenatal) continue;
    if (m.ageMonths <= chronoAgeMonths) {
      out[m.domain]!.add(m);
    }
  }
  for (final list in out.values) {
    list.sort((a, b) => b.ageMonths.compareTo(a.ageMonths));
  }
  return out;
}

/// All red flags whose age-cutoff has been reached or passed at
/// [chronoAgeMonths]. These should be re-checked at the bedside —
/// failure to achieve the corresponding milestone is the actual flag.
List<RedFlag> redFlagsAtOrBefore(double chronoAgeMonths) {
  return kRedFlags
      .where((r) => r.ageMonths <= chronoAgeMonths)
      .toList()
    ..sort((a, b) => a.ageMonths.compareTo(b.ageMonths));
}

/// Estimated developmental age (in months) per domain, given a set of
/// observed-milestone descriptions. We take the MAX age of each
/// observed milestone — i.e. the highest milestone the child can
/// perform reflects their developmental age in that domain.
Map<DevDomain, double> developmentalAgeFromObserved(
    Set<String> observedDescriptions) {
  final out = <DevDomain, double>{
    for (final d in DevDomain.values) d: 0,
  };
  for (final m in kMilestones) {
    if (m.prenatal) continue;
    if (observedDescriptions.contains(m.description)) {
      if (m.ageMonths > (out[m.domain] ?? 0)) {
        out[m.domain] = m.ageMonths;
      }
    }
  }
  return out;
}
