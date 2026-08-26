// =============================================================================
// scores/neonatal_scores.dart
//
// Neonatal scores that fit the ScoreDef criteria/point engine.
//
// The JSON-driven neonatal scores (Apgar, Downes, Silverman…) live in
// nicu_scores.json and are reached through the Neonatal Scores hub. Anything
// that is a straight weighted checklist belongs here instead, because it gets
// the shared scaffold, the registry entry, and search/Quick Access for free.
// =============================================================================

import 'package:flutter/material.dart';

import 'score_scaffold.dart';

const _neo = Color(0xFF0E7490); // teal — distinct from the paediatric accents

// -----------------------------------------------------------------------------
// Modified Finnegan Neonatal Abstinence Scoring System
//
// The 21-item modified form in routine NICU use, not Finnegan's original 31-item
// tool. Items that are mutually exclusive in the original chart are modelled as
// one question with graded options — a baby cannot be both "sleeps <1 h" and
// "sleeps <3 h", and letting both be ticked would silently inflate the total.
//
// Disturbed and undisturbed tremors are DELIBERATELY separate questions: the
// original chart scores them on separate lines and a baby can have both, so
// collapsing them would under-score the very infants closest to treatment.
// -----------------------------------------------------------------------------
final modifiedFinneganScore = ScoreDef(
  title: 'Modified Finnegan NAS Score',
  subtitle:
      'Neonatal abstinence / opioid withdrawal severity. Scored every 3–4 hours, '
      'after a feed, covering the whole interval since the last score.',
  system: 'Neonatal',
  accent: _neo,
  questions: [
    // ── Central nervous system ────────────────────────────────────────────
    ScoreQ('Cry', [
      ScoreChoice('Normal', 0),
      ScoreChoice('Excessive high-pitched cry', 2),
      ScoreChoice('Continuous high-pitched cry', 3),
    ]),
    ScoreQ('Sleep after feeding', [
      ScoreChoice('Sleeps normally (≥3 hours)', 0),
      ScoreChoice('Sleeps <3 hours', 1),
      ScoreChoice('Sleeps <2 hours', 2),
      ScoreChoice('Sleeps <1 hour', 3),
    ]),
    ScoreQ('Moro reflex', [
      ScoreChoice('Normal', 0),
      ScoreChoice('Hyperactive', 2),
      ScoreChoice('Markedly hyperactive', 3),
    ]),
    ScoreQ('Tremors — disturbed', [
      ScoreChoice('None', 0),
      ScoreChoice('Mild', 1),
      ScoreChoice('Moderate to severe', 2),
    ]),
    ScoreQ('Tremors — undisturbed', [
      ScoreChoice('None', 0),
      ScoreChoice('Mild', 3),
      ScoreChoice('Moderate to severe', 4),
    ]),
    ScoreQ.yesNo('Increased muscle tone', pts: 2),
    ScoreQ.yesNo('Excoriation (chin, knees, elbows, toes, nose)', pts: 1),
    ScoreQ.yesNo('Myoclonic jerks', pts: 3),
    ScoreQ.yesNo('Generalised convulsions', pts: 5),

    // ── Metabolic, vasomotor and respiratory ──────────────────────────────
    ScoreQ.yesNo('Sweating', pts: 1),
    ScoreQ('Temperature', [
      ScoreChoice('Normal (<37.2 °C / 99 °F)', 0),
      ScoreChoice('37.2–38.3 °C (99–100.8 °F)', 1),
      ScoreChoice('≥38.4 °C (≥100.9 °F)', 2),
    ]),
    ScoreQ.yesNo('Frequent yawning (>3–4 times in the interval)', pts: 1),
    ScoreQ.yesNo('Mottling', pts: 1),
    ScoreQ.yesNo('Nasal stuffiness', pts: 1),
    ScoreQ.yesNo('Sneezing (>3–4 times in the interval)', pts: 1),
    ScoreQ.yesNo('Nasal flaring', pts: 2),
    ScoreQ('Respiratory rate', [
      ScoreChoice('≤60 / min', 0),
      ScoreChoice('>60 / min', 1),
      ScoreChoice('>60 / min with retractions', 2),
    ]),

    // ── Gastrointestinal ──────────────────────────────────────────────────
    ScoreQ.yesNo('Excessive sucking', pts: 1),
    ScoreQ.yesNo('Poor feeding', pts: 2),
    ScoreQ('Vomiting', [
      ScoreChoice('None', 0),
      ScoreChoice('Regurgitation', 2),
      ScoreChoice('Projectile vomiting', 3),
    ]),
    ScoreQ('Stools', [
      ScoreChoice('Normal', 0),
      ScoreChoice('Loose stools', 2),
      ScoreChoice('Watery stools', 3),
    ]),
  ],
  bands: const [
    ScoreBand(
      0,
      'Below treatment threshold',
      Color(0xFF2E7D32),
      'Continue non-pharmacological care and keep scoring every 3–4 hours. '
          'Rooming-in with the mother, swaddling, minimal handling, a quiet '
          'dim room, frequent small feeds and skin-to-skin contact are '
          'first-line and are what most infants need.',
    ),
    ScoreBand(
      8,
      'At threshold — check the trend, not this score',
      Color(0xFFF57C00),
      'A single score of 8 or more does not start treatment. Start '
          'pharmacotherapy when THREE consecutive scores are ≥8, or TWO '
          'consecutive scores are ≥12. Re-score after the next feed and '
          'optimise non-pharmacological measures now.',
    ),
    ScoreBand(
      12,
      'High — two consecutive scores here start treatment',
      Color(0xFFB71C1C),
      'If the previous score was also ≥12, begin pharmacotherapy. Oral '
          'morphine is first-line for opioid withdrawal; methadone and '
          'buprenorphine are alternatives. Phenobarbital is used for '
          'non-opioid or polysubstance withdrawal, or as an adjunct. Check '
          'for a treatable cause of a high score — sepsis, hypoglycaemia, '
          'hypocalcaemia, hyperthyroidism, hypoxic-ischaemic injury — before '
          'attributing everything to withdrawal.',
    ),
  ],
  notes: const [
    'Finnegan LP, Connaughton JF Jr, Kron RE, Emich JP. Neonatal abstinence '
        'syndrome: assessment and management. Addict Dis. 1975;2(1-2):141-58. '
        'PMID: 1163358.',
    'Hudak ML, Tan RC; AAP Committee on Drugs and Committee on Fetus and '
        'Newborn. Neonatal drug withdrawal. Pediatrics. 2012;129(2):e540-60. '
        'PMID: 22291123.',
    'Score AFTER a feed, and score the whole interval since the last '
        'assessment rather than the moment of observation. Waking a settled '
        'baby only to score it inflates the CNS items.',
    'The 8 and 12 thresholds come from the original Finnegan tool and are '
        'widely used but have never been formally validated. They guide the '
        'decision; they do not make it.',
    'Eat-Sleep-Console (ESC) is increasingly used in place of Finnegan '
        'scoring and is associated with shorter treatment and shorter stay. '
        'Follow your unit protocol — this tool implements Finnegan, not ESC.',
  ],
);

// -----------------------------------------------------------------------------
// SNAPPE-II
//
// SNAP-II (six physiology items from the first 12 hours) plus the perinatal
// extension (birth weight, SGA, 5-minute Apgar). Maximum 162.
//
// Point weights were verified rather than recalled: the six SNAP-II items came
// from a published scoring table, the perinatal three from a second source, and
// the nine maxima sum to exactly 162 — the documented ceiling — which is the
// arithmetic check that the set is complete and correctly weighted.
//
// This is a MORTALITY RISK and illness-severity score for populations and
// benchmarking. It is not a bedside treatment tool, and the bands say so: a
// high score describes a cohort's risk, not a prediction about the baby in
// front of you. Written that way deliberately, because a number this precise
// invites being read as a prognosis.
// -----------------------------------------------------------------------------
final snappeIIScore = ScoreDef(
  title: 'SNAPPE-II',
  subtitle:
      'Illness severity and mortality risk for newborn intensive care. Uses the '
      'WORST value of each parameter in the first 12 hours after admission.',
  system: 'Neonatal',
  accent: _neo,
  totalLabel: 'points',
  questions: [
    // ── SNAP-II: physiology, worst value in the first 12 hours ────────────
    ScoreQ('Mean blood pressure (lowest)', [
      ScoreChoice('≥ 30 mmHg', 0),
      ScoreChoice('20–29 mmHg', 9),
      ScoreChoice('< 20 mmHg', 19),
    ]),
    ScoreQ('Lowest temperature', [
      ScoreChoice('≥ 35.6 °C', 0),
      ScoreChoice('35.0–35.5 °C', 8),
      ScoreChoice('< 35.0 °C', 15),
    ]),
    ScoreQ('PO₂ / FiO₂ ratio (lowest)', [
      ScoreChoice('≥ 2.5', 0),
      ScoreChoice('1.0 – 2.49', 5),
      ScoreChoice('0.3 – 0.99', 16),
      ScoreChoice('< 0.3', 28),
    ]),
    ScoreQ('Lowest serum pH', [
      ScoreChoice('≥ 7.20', 0),
      ScoreChoice('7.10 – 7.19', 7),
      ScoreChoice('< 7.10', 16),
    ]),
    ScoreQ.yesNo('Multiple seizures', pts: 19),
    ScoreQ('Urine output', [
      ScoreChoice('≥ 1.0 mL/kg/h', 0),
      ScoreChoice('0.1 – 0.9 mL/kg/h', 5),
      ScoreChoice('< 0.1 mL/kg/h', 18),
    ]),

    // ── Perinatal extension ───────────────────────────────────────────────
    ScoreQ('Birth weight', [
      ScoreChoice('≥ 1000 g', 0),
      ScoreChoice('750 – 999 g', 10),
      ScoreChoice('< 750 g', 17),
    ]),
    ScoreQ.yesNo('Small for gestational age (< 3rd centile)', pts: 12),
    ScoreQ('Apgar at 5 minutes', [
      ScoreChoice('≥ 7', 0),
      ScoreChoice('< 7', 18),
    ]),
  ],
  bands: const [
    ScoreBand(
      0,
      'Low risk band',
      Color(0xFF2E7D32),
      'Mortality risk in this band is low. The score describes severity of '
          'illness in the first 12 hours; it does not replace the clinical '
          'picture or the trend.',
    ),
    ScoreBand(
      20,
      'Moderate risk band',
      Color(0xFFF9A825),
      'Mortality risk rises steadily through this band. Useful for triage '
          'discussions, transfer decisions and counselling context — not as a '
          'prediction for an individual infant.',
    ),
    ScoreBand(
      40,
      'High risk band',
      Color(0xFFF57C00),
      'A score of 40 or more is the cutoff most often used in the literature '
          'to define high mortality risk. Treat it as a prompt to review the '
          'whole picture, not as a prognosis.',
    ),
    ScoreBand(
      60,
      'Very high risk band',
      Color(0xFFB71C1C),
      'Substantially elevated mortality risk at population level. Individual '
          'outcomes vary widely, and infants with very high scores do survive '
          'intact — the score is a severity measure, not a ceiling.',
    ),
  ],
  notes: const [
    'Richardson DK, Corcoran JD, Escobar GJ, Lee SK. SNAP-II and SNAPPE-II: '
        'simplified newborn illness severity and mortality risk scores. '
        'J Pediatr. 2001;138(1):92-100. PMID: 11148519.',
    'Use the WORST value of each physiological parameter recorded in the first '
        '12 hours after admission. Scoring a later or a better value '
        'systematically understates severity and breaks comparability.',
    'Maximum 162: SNAP-II contributes up to 115 and the perinatal extension '
        'up to 47.',
    'PO₂ / FiO₂ uses PO₂ in mmHg over FiO₂ as a DECIMAL (0.21–1.0), so a PO₂ '
        'of 60 on 40 % oxygen gives 60 / 0.40 = 150 — not the ratio this score '
        'wants. SNAP-II uses the value divided by 100, i.e. 1.5 here.',
    'Designed and validated for illness severity and mortality risk across '
        'populations, for benchmarking and research. It is not a bedside '
        'treatment tool and should not be quoted to parents as an individual '
        'prognosis.',
    'Some implementations use the lowest Apgar in the first hour rather than '
        'the 5-minute Apgar. This tool uses the 5-minute value, as in the '
        'original description.',
  ],
);

final List<ScoreDef> neonatalScores = [
  modifiedFinneganScore,
  snappeIIScore,
];
