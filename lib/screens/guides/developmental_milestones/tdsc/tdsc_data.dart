// =============================================================================
// lib/screens/guides/developmental_milestones/tdsc/tdsc_data.dart
//
// Trivandrum Developmental Screening Chart (TDSC) — source-of-truth data.
//
// Charts merged here:
//   • Chart 1: TDSC 0–3 years  (27 items, age 1–34 mo)
//   • Chart 2: TDSC 3–6 years  (24 items, age 36–72 mo)
//
// Item names and bar ranges are taken verbatim from the published TDSC
// charts (Child Development Centre, Trivandrum Medical College, Kerala).
// Each bar shows the age window during which the typical normative
// proportion of children pass the item.
//
// HOW THE CHART IS USED (verbatim screening logic):
//   1. Drop a vertical line at the child's chronological age (in months).
//      For preterm infants ≤ 24 months, use age corrected for prematurity.
//   2. Note every item the line intersects — those are the items being
//      screened at this age.
//   3. The child is examined / observed for each crossed item.
//   4. If the child FAILS 2 OR MORE of the crossed items, screen positive
//      → refer for formal developmental assessment.
//   5. If the child fails ≤ 1 item, screening is negative; reassess at the
//      next routine visit.
//
// Reference: Nair MK, Nair GH, Mini AO, et al. Trivandrum Developmental
// Screening Chart. Indian Pediatrics 2009;46:S57–61 (TDSC 0–2y) and
// Indian Pediatrics 2013;50:837–840 (TDSC II 0–6y).
// =============================================================================

import 'package:flutter/material.dart';

/// Which of the two charts an item belongs to.
enum TdscChart { youngest, eldest }

extension TdscChartLabel on TdscChart {
  String get label => switch (this) {
        TdscChart.youngest => 'TDSC 0–3 years',
        TdscChart.eldest => 'TDSC 3–6 years',
      };
  String get rangeLabel => switch (this) {
        TdscChart.youngest => '1–34 mo',
        TdscChart.eldest => '36–72 mo',
      };
  Color get accent => switch (this) {
        TdscChart.youngest => const Color(0xFFE65100),
        TdscChart.eldest => const Color(0xFFB71C1C),
      };
}

/// A loose domain tag for Smart View grouping. The published TDSC does
/// not stratify items by domain (it is a single-pass screen) — these tags
/// are purely a UI aid so the clinician can scan items by category.
enum TdscDomain { grossMotor, fineMotor, language, personalSocial }

class TdscDomainInfo {
  final String title;
  final String shortLabel;
  final IconData icon;
  final Color color;
  const TdscDomainInfo({
    required this.title,
    required this.shortLabel,
    required this.icon,
    required this.color,
  });
}

const Map<TdscDomain, TdscDomainInfo> kTdscDomainInfo = {
  TdscDomain.grossMotor: TdscDomainInfo(
    title: 'Gross Motor',
    shortLabel: 'Gross Motor',
    icon: Icons.directions_run_rounded,
    color: Color(0xFF1565C0),
  ),
  TdscDomain.fineMotor: TdscDomainInfo(
    title: 'Fine Motor / Adaptive',
    shortLabel: 'Fine Motor',
    icon: Icons.draw_rounded,
    color: Color(0xFF6A1B9A),
  ),
  TdscDomain.language: TdscDomainInfo(
    title: 'Language / Cognitive',
    shortLabel: 'Language',
    icon: Icons.record_voice_over_rounded,
    color: Color(0xFF00897B),
  ),
  TdscDomain.personalSocial: TdscDomainInfo(
    title: 'Personal-Social',
    shortLabel: 'Social',
    icon: Icons.people_alt_rounded,
    color: Color(0xFFEF6C00),
  ),
};

/// One item on the TDSC.
class TdscItem {
  /// Chart number (1-based, matches the printed chart).
  final int number;
  final String name;

  /// Examiner's prompt — what to actually do / observe to elicit the item.
  /// These are common bedside elicitations; the printed TDSC shows only
  /// the item label, examiner technique is part of the manual.
  final String prompt;

  /// Bar range in months. ageStart = age at which a small minority of
  /// normal children pass; ageEnd = age by which the great majority pass.
  /// At any chronological age between these two values the item is
  /// "being screened" — the vertical line crosses the bar.
  final double ageStart;
  final double ageEnd;

  final TdscDomain domain;
  final TdscChart chart;

  const TdscItem({
    required this.number,
    required this.name,
    required this.prompt,
    required this.ageStart,
    required this.ageEnd,
    required this.domain,
    required this.chart,
  });

  /// True if the vertical line at [ageMonths] crosses this item's bar.
  bool isCrossedAt(double ageMonths) =>
      ageMonths >= ageStart && ageMonths <= ageEnd;
}

// ─── Chart 1 — TDSC 0–3 years ───────────────────────────────────────────────
// 27 items, X-axis 1–34 months. Items are listed in the order they appear
// on the printed chart (bottom-to-top = earliest to latest).

const List<TdscItem> kTdscYoungest = [
  TdscItem(
    number: 1,
    name: 'Social smile',
    prompt:
        'Smile back at the infant from ~30 cm; the infant smiles spontaneously in response.',
    ageStart: 1, ageEnd: 3,
    domain: TdscDomain.personalSocial,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 2,
    name: 'Eyes follow pen / pencil',
    prompt:
        'Move a pen slowly horizontally across midline; eyes track smoothly through 90°.',
    ageStart: 2, ageEnd: 4,
    domain: TdscDomain.fineMotor,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 3,
    name: 'Hold head steady',
    prompt:
        'Hold infant upright; head stays steady without bobbing for several seconds.',
    ageStart: 3, ageEnd: 5,
    domain: TdscDomain.grossMotor,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 4,
    name: 'Rolls from back to stomach',
    prompt: 'Place supine on a flat surface; rolls completely to prone.',
    ageStart: 4, ageEnd: 6,
    domain: TdscDomain.grossMotor,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 5,
    name: 'Turns head to sound of bell / rattle',
    prompt:
        'Out of visual field, ring a bell at ear level; head turns toward the sound.',
    ageStart: 5, ageEnd: 7,
    domain: TdscDomain.personalSocial,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 6,
    name: 'Transfers objects hand to hand',
    prompt:
        'Offer a small toy; the infant grasps and passes it from one hand to the other.',
    ageStart: 6, ageEnd: 8,
    domain: TdscDomain.fineMotor,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 7,
    name: 'Raises self to sitting position',
    prompt:
        'From supine, the infant pulls / pushes up to sit independently.',
    ageStart: 6, ageEnd: 10,
    domain: TdscDomain.grossMotor,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 8,
    name: 'Standing up by furniture',
    prompt:
        'Pulls to stand at a low table or sofa and maintains standing while holding on.',
    ageStart: 7, ageEnd: 11,
    domain: TdscDomain.grossMotor,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 9,
    name: 'Fine prehension — pellet',
    prompt:
        'Picks up a small pellet (e.g. cumin seed) using neat pincer grasp (thumb + index).',
    ageStart: 8, ageEnd: 12,
    domain: TdscDomain.fineMotor,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 10,
    name: 'Pat-a-cake',
    prompt: 'Imitates clapping or pat-a-cake on demonstration.',
    ageStart: 8, ageEnd: 12,
    domain: TdscDomain.personalSocial,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 11,
    name: 'Walks with help',
    prompt: 'Walks several steps holding one or both adult hands.',
    ageStart: 9, ageEnd: 13,
    domain: TdscDomain.grossMotor,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 12,
    name: 'Throws ball',
    prompt:
        'On request, throws a small ball overhand or underhand toward the examiner.',
    ageStart: 12, ageEnd: 17,
    domain: TdscDomain.grossMotor,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 13,
    name: 'Walks alone',
    prompt: 'Walks at least 5 steps unsupported with good balance.',
    ageStart: 13, ageEnd: 18,
    domain: TdscDomain.grossMotor,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 14,
    name: 'Says two words',
    prompt:
        'Uses at least two meaningful words other than "mama / dada" (parent-reported is acceptable).',
    ageStart: 14, ageEnd: 20,
    domain: TdscDomain.language,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 15,
    name: 'Walks backwards',
    prompt:
        'On demonstration, walks backwards 2 or more steps without falling.',
    ageStart: 15, ageEnd: 21,
    domain: TdscDomain.grossMotor,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 16,
    name: 'Walks upstairs with help',
    prompt:
        'Walks up at least 2 stairs with one hand held or holding a railing.',
    ageStart: 17, ageEnd: 23,
    domain: TdscDomain.grossMotor,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 17,
    name: 'Points to parts of doll (3 parts)',
    prompt:
        'On request, points to at least 3 body parts on a doll (e.g. eyes, nose, mouth).',
    ageStart: 18, ageEnd: 24,
    domain: TdscDomain.language,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 18,
    name: 'Removes garments',
    prompt: 'Takes off socks, shoes, or hat without help.',
    ageStart: 19, ageEnd: 26,
    domain: TdscDomain.personalSocial,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 19,
    name: 'Uses words for personal needs',
    prompt:
        'Asks for things by name when needed (e.g. "water", "milk", "potty").',
    ageStart: 20, ageEnd: 30,
    domain: TdscDomain.language,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 20,
    name: 'Jumps in place',
    prompt:
        'On demonstration, lifts both feet off the ground simultaneously.',
    ageStart: 22, ageEnd: 26,
    domain: TdscDomain.grossMotor,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 21,
    name: 'Differentiates big & small',
    prompt:
        'Shown two similar objects of different size: correctly indicates which is big and which is small.',
    ageStart: 22, ageEnd: 27,
    domain: TdscDomain.language,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 22,
    name: 'Points to 7 common objects',
    prompt:
        'In a picture book or room: correctly points to at least 7 named common objects.',
    ageStart: 23, ageEnd: 29,
    domain: TdscDomain.language,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 23,
    name: 'Brushes teeth with help',
    prompt:
        'Holds a toothbrush and makes brushing motions with adult assistance.',
    ageStart: 24, ageEnd: 30,
    domain: TdscDomain.personalSocial,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 24,
    name: 'Tells gender when asked',
    prompt: 'Correctly answers "Are you a boy or a girl?".',
    ageStart: 25, ageEnd: 32,
    domain: TdscDomain.language,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 25,
    name: "Answers at least half understandably to others",
    prompt:
        'A stranger (not parent) understands at least half of what the child says.',
    ageStart: 26, ageEnd: 34,
    domain: TdscDomain.language,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 26,
    name: "On instruction places objects 'in', 'on', & 'under'",
    prompt:
        'On verbal instruction, places an object correctly in, on, and under a container.',
    ageStart: 27, ageEnd: 34,
    domain: TdscDomain.language,
    chart: TdscChart.youngest,
  ),
  TdscItem(
    number: 27,
    name: 'Asks simple questions',
    prompt:
        'Spontaneously asks simple "what?", "where?", or "who?" questions.',
    ageStart: 28, ageEnd: 34,
    domain: TdscDomain.language,
    chart: TdscChart.youngest,
  ),
];

// ─── Chart 2 — TDSC 3–6 years ───────────────────────────────────────────────
// 24 items, X-axis 36–72 months.

const List<TdscItem> kTdscEldest = [
  TdscItem(
    number: 1,
    name: 'Broad jump (both legs)',
    prompt:
        'On demonstration, jumps forward at least 30 cm with both feet leaving the ground together.',
    ageStart: 36, ageEnd: 42,
    domain: TdscDomain.grossMotor,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 2,
    name: 'Copy a circle',
    prompt:
        'Copies a circle on plain paper after seeing the examiner draw one (no demonstration of the path).',
    ageStart: 36, ageEnd: 44,
    domain: TdscDomain.fineMotor,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 3,
    name: 'Balance on one foot for 1 second',
    prompt: 'Stands on either foot for at least 1 second without support.',
    ageStart: 37, ageEnd: 46,
    domain: TdscDomain.grossMotor,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 4,
    name: 'Answers 2 questions (e.g., "Hungry?", "Cold?")',
    prompt:
        'Correctly answers two reasoning questions such as "What do you do when you are hungry / cold?".',
    ageStart: 38, ageEnd: 47,
    domain: TdscDomain.language,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 5,
    name: 'Names one colour',
    prompt: 'On request, correctly names at least one of four basic colours.',
    ageStart: 38, ageEnd: 48,
    domain: TdscDomain.language,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 6,
    name: 'Tells use of 2 objects (e.g., pencil, chair)',
    prompt:
        'When shown each object: states what it is used for (e.g., "to write", "to sit").',
    ageStart: 39, ageEnd: 49,
    domain: TdscDomain.language,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 7,
    name: "Concept of 'one' (Pick 1 from a group)",
    prompt:
        'Asked to bring "just one" object from a small group: brings exactly one.',
    ageStart: 40, ageEnd: 50,
    domain: TdscDomain.language,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 8,
    name: 'Plays near and talks with peers',
    prompt:
        'Engages in cooperative play with peers including back-and-forth conversation.',
    ageStart: 40, ageEnd: 52,
    domain: TdscDomain.personalSocial,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 9,
    name: 'Hops continuously 5 steps',
    prompt: 'Hops on one foot at least 5 consecutive times without falling.',
    ageStart: 41, ageEnd: 54,
    domain: TdscDomain.grossMotor,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 10,
    name: 'Draws person with 3 parts',
    prompt:
        'Asked to "draw a person": drawing includes at least 3 recognisable body parts.',
    ageStart: 42, ageEnd: 56,
    domain: TdscDomain.fineMotor,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 11,
    name: 'Writes 3 alphabets (e.g., A, F, E)',
    prompt:
        'On request, copies / writes any 3 capital letters legibly (no specific spelling).',
    ageStart: 44, ageEnd: 58,
    domain: TdscDomain.fineMotor,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 12,
    name: 'Tells function of 3 body parts',
    prompt:
        'Names a function for at least 3 body parts (e.g. "eyes — to see", "ears — to hear").',
    ageStart: 45, ageEnd: 60,
    domain: TdscDomain.language,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 13,
    name: 'Paints / shades a blank circle',
    prompt:
        'Given a printed empty circle and a crayon: shades the inside without leaving major gaps.',
    ageStart: 46, ageEnd: 62,
    domain: TdscDomain.fineMotor,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 14,
    name: 'Defines / explains 10 words',
    prompt:
        'Asked one at a time, defines or describes the use of at least 10 common words.',
    ageStart: 47, ageEnd: 64,
    domain: TdscDomain.language,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 15,
    name: 'Heel-to-toe walk — 4 consecutive steps',
    prompt:
        'On a straight line, walks heel-to-toe without sideways stepping for 4 steps.',
    ageStart: 48, ageEnd: 66,
    domain: TdscDomain.grossMotor,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 16,
    name: 'Answers "why?" questions',
    prompt:
        'Gives a logical answer to at least 2 "why?" questions (e.g., "Why do we wear clothes?").',
    ageStart: 49, ageEnd: 68,
    domain: TdscDomain.language,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 17,
    name: 'Folds paper diagonally twice',
    prompt:
        'On demonstration, folds a square paper twice diagonally to form a smaller triangle.',
    ageStart: 51, ageEnd: 70,
    domain: TdscDomain.fineMotor,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 18,
    name: 'Copies 3 shapes (▲ ● ■)',
    prompt:
        'Copies a triangle, a circle, and a square — each recognisably (no demonstration of stroke order).',
    ageStart: 52, ageEnd: 72,
    domain: TdscDomain.fineMotor,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 19,
    name: 'Points to "middle"',
    prompt:
        'Shown 3 objects in a row: correctly points to the middle one when asked.',
    ageStart: 54, ageEnd: 72,
    domain: TdscDomain.language,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 20,
    name: 'Picks 5 objects from a group',
    prompt: 'On request, picks exactly 5 objects from a larger collection.',
    ageStart: 55, ageEnd: 72,
    domain: TdscDomain.language,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 21,
    name: 'Buttons / unbuttons',
    prompt:
        'Buttons or unbuttons a regular shirt button without adult help.',
    ageStart: 56, ageEnd: 72,
    domain: TdscDomain.personalSocial,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 22,
    name: 'Names days of the week in order',
    prompt: 'Recites the seven days of the week in correct order.',
    ageStart: 57, ageEnd: 72,
    domain: TdscDomain.language,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 23,
    name: 'Uses 5–6 word sentences',
    prompt:
        'Speaks in fluent sentences of 5 or more words during conversation.',
    ageStart: 58, ageEnd: 72,
    domain: TdscDomain.language,
    chart: TdscChart.eldest,
  ),
  TdscItem(
    number: 24,
    name: 'Writes own name',
    prompt:
        'Writes first name legibly without copying (letter reversal acceptable).',
    ageStart: 60, ageEnd: 72,
    domain: TdscDomain.fineMotor,
    chart: TdscChart.eldest,
  ),
];

/// Combined list (chart 1 then chart 2) — convenient for unified search.
List<TdscItem> get kTdscAll => [...kTdscYoungest, ...kTdscEldest];

/// All items whose bar is crossed by the vertical line at [ageMonths].
List<TdscItem> tdscItemsAt(double ageMonths) {
  return kTdscAll.where((it) => it.isCrossedAt(ageMonths)).toList()
    ..sort((a, b) => a.ageStart.compareTo(b.ageStart));
}

/// Convenience selector — which chart applies for a given age?
/// Items can overlap (chart 1 ends at 34, chart 2 starts at 36) so we
/// use 36 mo as the cut-off.
TdscChart preferredChartFor(double ageMonths) =>
    ageMonths < 36 ? TdscChart.youngest : TdscChart.eldest;

/// Pass / fail / not-tested state per item (for the screening sheet).
enum TdscPass { unset, pass, fail }

/// Outcome of running the screen.
class TdscScoreResult {
  final int crossedTotal;
  final int failed;
  final int passed;
  final int unknown;
  final bool suspect;
  final List<TdscItem> failedItems;
  const TdscScoreResult({
    required this.crossedTotal,
    required this.failed,
    required this.passed,
    required this.unknown,
    required this.suspect,
    required this.failedItems,
  });
}

/// Score the screen at [ageMonths] given a per-item pass/fail map.
/// Returns total crossed, how many failed, and whether the result is
/// "suspect for delay" per the published rule (≥ 2 failures).
TdscScoreResult scoreTdsc({
  required double ageMonths,
  required Map<int, TdscPass> answers, // key = stableId (chart*100 + number)
}) {
  final crossed = tdscItemsAt(ageMonths);
  int failed = 0;
  int passed = 0;
  int unknown = 0;
  final failedItems = <TdscItem>[];
  for (final it in crossed) {
    final id = stableId(it);
    final p = answers[id] ?? TdscPass.unset;
    switch (p) {
      case TdscPass.fail:
        failed++;
        failedItems.add(it);
      case TdscPass.pass:
        passed++;
      case TdscPass.unset:
        unknown++;
    }
  }
  return TdscScoreResult(
    crossedTotal: crossed.length,
    failed: failed,
    passed: passed,
    unknown: unknown,
    suspect: failed >= 2,
    failedItems: failedItems,
  );
}

/// Stable ID for an item across the two charts.
int stableId(TdscItem it) =>
    (it.chart == TdscChart.youngest ? 100 : 200) + it.number;
