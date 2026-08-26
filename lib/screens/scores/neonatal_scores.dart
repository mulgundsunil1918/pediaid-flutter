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

final List<ScoreDef> neonatalScores = [modifiedFinneganScore];
