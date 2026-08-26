// =============================================================================
// calculators/new_clinical_calculators.dart
//
// New single-formula clinical calculators built on SimpleCalcScaffold. Each is
// a thin StatelessWidget wiring inputs → a sourced formula → result. Grouped
// here by system for maintenance; registered individually in calculators_screen.
// =============================================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'simple_calc_scaffold.dart';

const _heme = Color(0xFFAD1457);
const _cardio = Color(0xFFC62828);
const _renal = Color(0xFF00695C);
const _hep = Color(0xFF6A4C00);
const _endo = Color(0xFF4527A0);
const _neuro = Color(0xFF283593);
const _tox = Color(0xFFBF360C);
const _growth = Color(0xFF2E7D32);

Color _band(double v, List<double> cuts, List<Color> cols) {
  for (var i = 0; i < cuts.length; i++) {
    if (v < cuts[i]) return cols[i];
  }
  return cols.last;
}

// ── Haematology ──────────────────────────────────────────────────────────────

class AbsoluteCountsCalculator extends StatelessWidget {
  const AbsoluteCountsCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Absolute Counts (ANC / AEC / ALC)',
        subtitle:
            'Absolute neutrophil, eosinophil and lymphocyte counts from the CBC differential.',
        accent: _heme,
        fields: const [
          CalcField('wbc', 'Total WBC', unit: '×10⁹/L', hint: 'e.g. 8.0'),
          CalcField('neut', 'Neutrophils (segs)', unit: '%', hint: 'e.g. 45'),
          CalcField('bands', 'Bands (optional)', unit: '%', hint: 'e.g. 5'),
          CalcField('eos', 'Eosinophils (optional)', unit: '%', hint: 'e.g. 3'),
          CalcField('lymph', 'Lymphocytes (optional)', unit: '%', hint: 'e.g. 40'),
        ],
        compute: (v) {
          final wbc = v['wbc'];
          final neut = v['neut'];
          if (wbc == null || neut == null) return null;
          final wbcUl = wbc * 1000; // ×10⁹/L → cells/µL
          final anc = wbcUl * ((neut + (v['bands'] ?? 0)) / 100);
          final aec = v['eos'] != null ? wbcUl * (v['eos']! / 100) : null;
          final alc = v['lymph'] != null ? wbcUl * (v['lymph']! / 100) : null;
          final color = _band(anc, [500, 1000, 1500],
              [Color(0xFFB71C1C), Color(0xFFEF6C00), Color(0xFFF9A825), _growth]);
          final band = anc < 500
              ? 'Severe neutropenia'
              : anc < 1000
                  ? 'Moderate'
                  : anc < 1500
                      ? 'Mild'
                      : 'Normal';
          return CalcResult(
            value: 'ANC ${anc.round()} /µL',
            band: band,
            color: color,
            detail:
                'Neutropenia thresholds: <1500 mild · <1000 moderate · <500 severe (higher infection risk).',
            extra: [
              if (aec != null) ('AEC (eosinophils)', '${aec.round()} /µL'),
              if (alc != null) ('ALC (lymphocytes)', '${alc.round()} /µL'),
            ],
          );
        },
        notes: const [
          'ANC = Total WBC × (%segmented neutrophils + %bands) ÷ 100.',
          'AEC / ALC use the eosinophil / lymphocyte %. Enter WBC in ×10⁹/L (= ×10³/µL).',
        ],
      );
}

class MentzerIndexCalculator extends StatelessWidget {
  const MentzerIndexCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Mentzer Index',
        subtitle:
            'Discriminates iron-deficiency anaemia from β-thalassaemia trait in a microcytic anaemia.',
        accent: _heme,
        fields: const [
          CalcField('mcv', 'MCV', unit: 'fL', hint: 'e.g. 65'),
          CalcField('rbc', 'RBC count', unit: '×10¹²/L', hint: 'e.g. 5.6'),
        ],
        compute: (v) {
          final mcv = v['mcv'], rbc = v['rbc'];
          if (mcv == null || rbc == null || rbc == 0) return null;
          final idx = mcv / rbc;
          final thal = idx < 13;
          return CalcResult(
            value: idx.toStringAsFixed(1),
            band: thal ? 'Thalassaemia trait likely' : 'Iron deficiency likely',
            color: thal ? const Color(0xFF6A1B9A) : const Color(0xFFEF6C00),
            detail: idx < 13
                ? '< 13 → β-thalassaemia trait more likely (RBC count preserved). Confirm with HbA2/electrophoresis.'
                : idx > 13
                    ? '> 13 → iron-deficiency anaemia more likely. Confirm with ferritin/iron studies.'
                    : '≈ 13 → indeterminate; use ferritin + HbA2 to differentiate.',
          );
        },
        notes: const [
          'Mentzer Index = MCV ÷ RBC count (×10¹²/L, i.e. millions/µL).',
          'A screening aid only — not diagnostic. Confirm with iron studies and Hb electrophoresis.',
        ],
      );
}

// ── Cardiology ───────────────────────────────────────────────────────────────

class QtcCalculator extends StatelessWidget {
  const QtcCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Corrected QT (QTc)',
        subtitle: 'Bazett heart-rate–corrected QT interval.',
        accent: _cardio,
        fields: const [
          CalcField('qt', 'Measured QT', unit: 'ms', hint: 'e.g. 380'),
          CalcField('hr', 'Heart rate', unit: 'bpm', hint: 'e.g. 90'),
        ],
        compute: (v) {
          final qt = v['qt'], hr = v['hr'];
          if (qt == null || hr == null || hr == 0) return null;
          final rr = 60 / hr; // seconds
          final qtc = qt / math.sqrt(rr);
          final color = _band(qtc, [450, 460, 500],
              [_growth, Color(0xFFF9A825), Color(0xFFEF6C00), Color(0xFFB71C1C)]);
          final band = qtc >= 500
              ? 'Markedly prolonged'
              : qtc >= 460
                  ? 'Prolonged'
                  : qtc >= 450
                      ? 'Borderline'
                      : 'Normal';
          return CalcResult(
            value: '${qtc.round()} ms',
            band: band,
            color: color,
            detail:
                'Paediatric cut-offs: >460 ms prolonged, >500 ms high risk of torsades. Review QT-prolonging drugs & electrolytes (K⁺, Mg²⁺, Ca²⁺).',
          );
        },
        notes: const [
          'Bazett: QTc = QT ÷ √RR, where RR (s) = 60 ÷ heart rate.',
          'Bazett over-corrects at fast rates — interpret with caution in tachycardia.',
        ],
      );
}

// ── Renal ────────────────────────────────────────────────────────────────────

class FenaCalculator extends StatelessWidget {
  const FenaCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Fractional Excretion of Na (FeNa)',
        subtitle: 'Differentiates pre-renal from intrinsic (ATN) acute kidney injury.',
        accent: _renal,
        fields: const [
          CalcField('una', 'Urine sodium', unit: 'mmol/L', hint: 'e.g. 20'),
          CalcField('sna', 'Serum sodium', unit: 'mmol/L', hint: 'e.g. 138'),
          CalcField('ucr', 'Urine creatinine', unit: 'mg/dL', hint: 'e.g. 60'),
          CalcField('scr', 'Serum creatinine', unit: 'mg/dL', hint: 'e.g. 1.2'),
        ],
        compute: (v) {
          final una = v['una'], sna = v['sna'], ucr = v['ucr'], scr = v['scr'];
          if (una == null || sna == null || ucr == null || scr == null) {
            return null;
          }
          if (sna == 0 || ucr == 0) return null;
          final fena = (una * scr) / (sna * ucr) * 100;
          final color = fena < 1
              ? _growth
              : fena <= 2
                  ? const Color(0xFFF9A825)
                  : const Color(0xFFEF6C00);
          final band = fena < 1
              ? 'Pre-renal'
              : fena <= 2
                  ? 'Indeterminate'
                  : 'Intrinsic / ATN';
          return CalcResult(
            value: '${fena.toStringAsFixed(2)} %',
            band: band,
            color: color,
            detail:
                '<1% pre-renal (volume depletion) · 1–2% indeterminate · >2% intrinsic/ATN. FeNa is unreliable after diuretics — use FeUrea instead. Neonates: pre-renal cut-off <2.5%.',
          );
        },
        notes: const [
          'FeNa = (Urine Na × Serum Cr) ÷ (Serum Na × Urine Cr) × 100. Cr units cancel.',
        ],
      );
}

// ── Hepatology ───────────────────────────────────────────────────────────────

class ApriCalculator extends StatelessWidget {
  const ApriCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'APRI (AST-to-Platelet Ratio)',
        subtitle: 'Non-invasive marker of significant hepatic fibrosis / cirrhosis.',
        accent: _hep,
        fields: const [
          CalcField('ast', 'AST', unit: 'U/L', hint: 'e.g. 80'),
          CalcField('uln', 'AST upper-limit-normal', unit: 'U/L', hint: 'e.g. 40'),
          CalcField('plt', 'Platelets', unit: '×10⁹/L', hint: 'e.g. 150'),
        ],
        compute: (v) {
          final ast = v['ast'], uln = v['uln'], plt = v['plt'];
          if (ast == null || uln == null || plt == null || uln == 0 || plt == 0) {
            return null;
          }
          final apri = (ast / uln) / plt * 100;
          final color = apri < 0.5
              ? _growth
              : apri < 1.0
                  ? const Color(0xFFF9A825)
                  : const Color(0xFFB71C1C);
          final band = apri < 0.5
              ? 'Fibrosis unlikely'
              : apri < 1.0
                  ? 'Indeterminate'
                  : 'Cirrhosis likely';
          return CalcResult(
            value: apri.toStringAsFixed(2),
            band: band,
            color: color,
            detail:
                '<0.5 significant fibrosis unlikely · >1.0 suggests cirrhosis. Cut-offs derived in adults with hepatitis C — interpret paediatric values with caution.',
          );
        },
        notes: const [
          'APRI = (AST ÷ AST ULN) ÷ platelet count (×10⁹/L) × 100.',
        ],
      );
}

class Fib4Calculator extends StatelessWidget {
  const Fib4Calculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'FIB-4 Index',
        subtitle: 'Non-invasive liver-fibrosis index (age, AST, ALT, platelets).',
        accent: _hep,
        fields: const [
          CalcField('age', 'Age', unit: 'years', hint: 'e.g. 14'),
          CalcField('ast', 'AST', unit: 'U/L', hint: 'e.g. 80'),
          CalcField('alt', 'ALT', unit: 'U/L', hint: 'e.g. 60'),
          CalcField('plt', 'Platelets', unit: '×10⁹/L', hint: 'e.g. 150'),
        ],
        compute: (v) {
          final age = v['age'], ast = v['ast'], alt = v['alt'], plt = v['plt'];
          if (age == null || ast == null || alt == null || plt == null) {
            return null;
          }
          if (plt == 0 || alt == 0) return null;
          final fib = (age * ast) / (plt * math.sqrt(alt));
          final color = fib < 1.45
              ? _growth
              : fib <= 3.25
                  ? const Color(0xFFF9A825)
                  : const Color(0xFFB71C1C);
          final band = fib < 1.45
              ? 'Low'
              : fib <= 3.25
                  ? 'Indeterminate'
                  : 'Advanced fibrosis';
          return CalcResult(
            value: fib.toStringAsFixed(2),
            band: band,
            color: color,
            detail:
                '<1.45 advanced fibrosis unlikely · >3.25 advanced fibrosis likely. Validated in adults — paediatric performance is limited.',
          );
        },
        notes: const [
          'FIB-4 = (Age × AST) ÷ (Platelets ×10⁹/L × √ALT).',
        ],
      );
}

class PeldMeldCalculator extends StatelessWidget {
  const PeldMeldCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'PELD / MELD Score',
        subtitle:
            'Liver-disease severity for transplant prioritisation. PELD if <12 y, MELD if ≥12 y.',
        accent: _hep,
        fields: const [
          CalcField('age', 'Age', unit: 'years', hint: 'e.g. 3'),
          CalcField('bili', 'Total bilirubin', unit: 'mg/dL', hint: 'e.g. 4'),
          CalcField('inr', 'INR', hint: 'e.g. 1.8'),
          CalcField('alb', 'Albumin (PELD)', unit: 'g/dL', hint: 'e.g. 2.8'),
          CalcField('cr', 'Creatinine (MELD)', unit: 'mg/dL', hint: 'e.g. 1.0'),
          CalcField('gf', 'Growth failure (< −2 SD)', toggle: true),
        ],
        compute: (v) {
          final age = v['age'], bili = v['bili'], inr = v['inr'];
          if (age == null || bili == null || inr == null) return null;
          double lb(double? x) => math.log((x == null || x < 1) ? 1 : x);
          if (age < 12) {
            final alb = v['alb'];
            if (alb == null) return null;
            var s = 10 *
                (0.480 * lb(bili) +
                    1.857 * lb(inr) -
                    0.687 * math.log(alb < 1 ? 1 : alb) +
                    (age < 1 ? 0.436 : 0) +
                    ((v['gf'] ?? 0) == 1 ? 0.667 : 0));
            final score = s.round();
            return CalcResult(
              value: 'PELD $score',
              band: score >= 20 ? 'High priority' : 'Lower priority',
              color: score >= 20 ? const Color(0xFFB71C1C) : _hep,
              detail:
                  'PELD used (age <12 y). Higher score = greater 90-day mortality risk. Growth failure and age <1 y each add points.',
            );
          } else {
            final cr = v['cr'];
            if (cr == null) return null;
            final crC = cr > 4 ? 4.0 : (cr < 1 ? 1.0 : cr);
            final s =
                3.78 * lb(bili) + 11.2 * lb(inr) + 9.57 * math.log(crC) + 6.43;
            final score = s.round().clamp(6, 40);
            return CalcResult(
              value: 'MELD $score',
              band: score >= 20 ? 'High priority' : 'Lower priority',
              color: score >= 20 ? const Color(0xFFB71C1C) : _hep,
              detail:
                  'MELD used (age ≥12 y). Creatinine bounded to 1–4 mg/dL (4 if on dialysis). Range 6–40.',
            );
          }
        },
        notes: const [
          'PELD = 10 × [0.480·ln(bili) + 1.857·ln(INR) − 0.687·ln(albumin) + 0.436(if <1 y) + 0.667(growth failure)].',
          'MELD = 3.78·ln(bili) + 11.2·ln(INR) + 9.57·ln(creatinine) + 6.43. Lab values <1 set to 1.',
        ],
      );
}

// ── Endocrine ────────────────────────────────────────────────────────────────

class HbA1cEagCalculator extends StatelessWidget {
  const HbA1cEagCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'HbA1c → Estimated Average Glucose',
        subtitle: 'Converts HbA1c to estimated average glucose (eAG).',
        accent: _endo,
        fields: const [
          CalcField('a1c', 'HbA1c', unit: '%', hint: 'e.g. 7.0'),
        ],
        compute: (v) {
          final a1c = v['a1c'];
          if (a1c == null) return null;
          final mgdl = 28.7 * a1c - 46.7;
          final mmol = 1.59 * a1c - 2.59;
          return CalcResult(
            value: '${mgdl.round()} mg/dL',
            band: a1c < 7 ? 'At/near target' : 'Above target',
            color: a1c < 7 ? _growth : const Color(0xFFEF6C00),
            detail:
                'Estimated average glucose over ~3 months. Typical paediatric T1DM target HbA1c <7% (individualise).',
            extra: [('eAG (mmol/L)', mmol.toStringAsFixed(1))],
          );
        },
        notes: const [
          'eAG (mg/dL) = 28.7 × HbA1c − 46.7  ·  eAG (mmol/L) = 1.59 × HbA1c − 2.59 (ADAG study).',
        ],
      );
}

// ── Neurology ────────────────────────────────────────────────────────────────

class CsfWbcCorrectionCalculator extends StatelessWidget {
  const CsfWbcCorrectionCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'CSF WBC Correction (traumatic tap)',
        subtitle:
            'Corrects the CSF white-cell count for blood contamination from a traumatic tap.',
        accent: _neuro,
        fields: const [
          CalcField('csfwbc', 'CSF WBC (observed)', unit: '/µL', hint: 'e.g. 50'),
          CalcField('csfrbc', 'CSF RBC', unit: '/µL', hint: 'e.g. 5000'),
          CalcField('bloodwbc', 'Blood WBC', unit: '×10⁹/L', hint: 'e.g. 10'),
          CalcField('bloodrbc', 'Blood RBC', unit: '×10¹²/L', hint: 'e.g. 4.5'),
        ],
        compute: (v) {
          final cw = v['csfwbc'],
              cr = v['csfrbc'],
              bw = v['bloodwbc'],
              br = v['bloodrbc'];
          if (cw == null || cr == null || bw == null || br == null || br == 0) {
            return null;
          }
          // Convert blood counts to /µL: WBC ×10⁹/L = ×10³/µL; RBC ×10¹²/L = ×10⁶/µL.
          final bwUl = bw * 1000;
          final brUl = br * 1e6;
          final expected = cr * (bwUl / brUl);
          final corrected = (cw - expected).clamp(0, double.infinity);
          final pleocytosis = corrected > 7;
          return CalcResult(
            value: 'Corrected WBC ${corrected.round()} /µL',
            band: pleocytosis ? 'True pleocytosis' : 'Within expected',
            color: pleocytosis ? const Color(0xFFB71C1C) : _growth,
            detail:
                'Corrected CSF WBC = observed − (CSF RBC × blood WBC/RBC). A corrected count still elevated suggests genuine CSF pleocytosis (meningitis), not just blood.',
            extra: [
              ('Predicted WBC from blood', '${expected.round()} /µL'),
            ],
          );
        },
        notes: const [
          'Predicted CSF WBC from blood = CSF RBC × (blood WBC ÷ blood RBC).',
          'Rule of thumb ≈ 1 WBC per 500–1000 RBC. Correction is approximate; a very high RBC count reduces reliability.',
        ],
      );
}

// ── Toxicology ───────────────────────────────────────────────────────────────

class ParacetamolCalculator extends StatelessWidget {
  const ParacetamolCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Paracetamol Toxicity + NAC',
        subtitle:
            'Rumack-Matthew nomogram (treatment line) for a single acute ingestion, with weight-based NAC dosing.',
        accent: _tox,
        fields: const [
          CalcField('t', 'Time since ingestion', unit: 'h', hint: '4–24'),
          CalcField('level', 'Paracetamol level', unit: 'µg/mL', hint: 'e.g. 120'),
          CalcField('wt', 'Weight (for NAC)', unit: 'kg', hint: 'e.g. 20'),
        ],
        compute: (v) {
          final t = v['t'], level = v['level'];
          if (t == null || level == null) return null;
          if (t < 4) {
            return const CalcResult(
              value: 'Not interpretable',
              band: '< 4 h',
              color: Color(0xFF757575),
              detail:
                  'The nomogram is only valid from 4 h to 24 h after a single acute ingestion. Repeat the level at ≥4 h.',
            );
          }
          if (t > 24) {
            return const CalcResult(
              value: 'Nomogram not valid',
              band: '> 24 h',
              color: Color(0xFFEF6C00),
              detail:
                  'Beyond 24 h the nomogram does not apply — treat based on levels, LFTs/INR and clinical picture; discuss with toxicology.',
            );
          }
          // Treatment line: 150 µg/mL at 4 h, halving every ~4 h.
          final line = 150 * math.pow(2, -(t - 4) / 4);
          final above = level >= line;
          final wt = v['wt'];
          final extra = <(String, String)>[
            ('Treatment line at ${t.toStringAsFixed(1)} h', '${line.toStringAsFixed(0)} µg/mL'),
          ];
          if (above && wt != null) {
            extra.addAll([
              ('NAC bag 1 (150 mg/kg / 1 h)', '${(150 * wt).round()} mg'),
              ('NAC bag 2 (50 mg/kg / 4 h)', '${(50 * wt).round()} mg'),
              ('NAC bag 3 (100 mg/kg / 16 h)', '${(100 * wt).round()} mg'),
            ]);
          }
          return CalcResult(
            value: above ? 'Above treatment line' : 'Below treatment line',
            band: above ? 'Treat with NAC' : 'NAC not indicated',
            color: above ? const Color(0xFFB71C1C) : _growth,
            detail: above
                ? 'Level is on/above the 150-line — start N-acetylcysteine. Standard 21-h IV regimen shown${wt == null ? ' (enter weight for doses)' : ''}.'
                : 'Level below the treatment line for a single acute ingestion. Reassess if staggered/unknown-time ingestion or symptomatic.',
            extra: extra,
          );
        },
        notes: const [
          'Treatment line = 150 µg/mL (≈150 mg/L) at 4 h, halving every 4 h (≈37.5 at 12 h, ≈4.7 at 24 h).',
          'Applies to a SINGLE acute ingestion with a known time. Staggered/unknown-time ingestions: treat per protocol regardless of nomogram.',
        ],
      );
}

// ── Growth ───────────────────────────────────────────────────────────────────

// -----------------------------------------------------------------------------
// Weight velocity (neonatal)
//
// Two weights and two dates in; g/day, g/kg/day and percentage change out.
//
// Two g/kg/day methods are reported because they disagree, sometimes by 2-3
// g/kg/day over a long interval, and units quote whichever their protocol
// specifies. The exponential (Patel) method is the one to prefer over intervals
// longer than about a week — the arithmetic method uses a fixed starting weight
// as the denominator, so it progressively understates velocity as the baby
// grows.
// -----------------------------------------------------------------------------
class WeightVelocityCalculator extends StatelessWidget {
  const WeightVelocityCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Weight Velocity',
        subtitle:
            'Weight gain or loss between two points, as g/day, g/kg/day and a '
            'percentage — for growth monitoring in the NICU and at follow-up.',
        accent: _growth,
        fields: const [
          CalcField('w1', 'Starting weight', unit: 'g', hint: 'e.g. 1450'),
          CalcField.date('d1', 'Starting date'),
          CalcField('w2', 'Current weight', unit: 'g', hint: 'e.g. 1720'),
          CalcField.date('d2', 'Current date'),
        ],
        compute: (v) {
          final w1 = v['w1'], w2 = v['w2'];
          final d1 = v['d1'], d2 = v['d2'];
          if (w1 == null || w2 == null || d1 == null || d2 == null) return null;
          if (w1 <= 0 || w2 <= 0) return null;

          final days = (d2 - d1).round();
          if (days <= 0) return null; // same day or reversed — nothing to report

          final deltaG = w2 - w1;
          final gPerDay = deltaG / days;
          final pct = (deltaG / w1) * 100;

          // Arithmetic ("2-point") method: change per day per STARTING kg.
          final arithmetic = deltaG / (w1 / 1000) / days;
          // Exponential (Patel) method: 1000 x ln(W2/W1) / days. Accounts for
          // the denominator growing with the baby.
          final exponential = 1000 * (math.log(w2 / w1)) / days;

          final losing = deltaG < 0;
          final String band;
          final Color color;
          final String detail;

          if (losing) {
            band = 'Weight loss';
            color = const Color(0xFFB71C1C);
            detail =
                'Losing ${deltaG.abs().toStringAsFixed(0)} g over $days day'
                '${days == 1 ? '' : 's'} (${pct.toStringAsFixed(1)} %). In the '
                'first week this may be physiological — up to about 7–10 % in a '
                'term baby and 10–15 % in a preterm, with birth weight regained '
                'by day 10–14. Outside that window, or beyond those limits, look '
                'for intake, losses or illness.';
          } else if (exponential < 10) {
            band = 'Below target';
            color = const Color(0xFFF57C00);
            detail =
                'Gaining, but below the 15–20 g/kg/day usually targeted in a '
                'growing preterm infant. Review intake, fortification and '
                'ongoing losses before assuming a growth failure.';
          } else if (exponential <= 20) {
            band = 'On target';
            color = const Color(0xFF2E7D32);
            detail =
                'Within the 15–20 g/kg/day range that approximates intrauterine '
                'growth, which is the usual aim for a growing preterm infant.';
          } else {
            band = 'Above target';
            color = const Color(0xFF1565C0);
            detail =
                'Above the usual 15–20 g/kg/day. Confirm it is lean growth '
                'rather than oedema or fluid retention, particularly if the '
                'gain appeared suddenly.';
          }

          return CalcResult(
            value: '${exponential.toStringAsFixed(1)} g/kg/day',
            band: band,
            color: color,
            detail: detail,
            extra: [
              (
                'Total change',
                '${deltaG >= 0 ? '+' : ''}${deltaG.toStringAsFixed(0)} g '
                    'over $days day${days == 1 ? '' : 's'}'
              ),
              ('Per day', '${gPerDay >= 0 ? '+' : ''}${gPerDay.toStringAsFixed(1)} g/day'),
              ('Percentage change', '${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(1)} %'),
              ('Exponential (Patel)', '${exponential.toStringAsFixed(1)} g/kg/day'),
              ('Arithmetic (2-point)', '${arithmetic.toStringAsFixed(1)} g/kg/day'),
              ('Weights', '${w1.toStringAsFixed(0)} g → ${w2.toStringAsFixed(0)} g'),
            ],
          );
        },
        notes: const [
          'Exponential (Patel) method: 1000 × ln(W₂ / W₁) ÷ days. Preferred for '
              'intervals longer than about a week, and the headline figure here.',
          'Arithmetic (2-point) method: (W₂ − W₁) ÷ starting weight in kg ÷ days. '
              'Simple to do at the cot side, but it holds the denominator fixed at '
              'the starting weight, so it progressively understates velocity as '
              'the baby grows.',
          'Target in a growing preterm infant is about 15–20 g/kg/day, '
              'approximating intrauterine growth. Term infants are usually '
              'described in g/day instead — roughly 25–30 g/day in the early '
              'months.',
          'Early weight loss is expected: up to about 7–10 % in a term infant and '
              '10–15 % in a preterm, with birth weight regained by day 10–14. '
              'A negative velocity in the first week is not automatically a '
              'problem; one in the third week is.',
          'Patel AL, Engstrom JL, Meier PP, Kimura RE. Accuracy of methods for '
              'calculating postnatal growth velocity for extremely low birth '
              'weight infants. Pediatrics. 2005;116(6):1466-73.',
        ],
      );
}

class BmiCalculator extends StatelessWidget {
  const BmiCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Body Mass Index (BMI)',
        subtitle: 'BMI from weight and height. Interpret against BMI-for-age charts.',
        accent: _growth,
        fields: const [
          CalcField('wt', 'Weight', unit: 'kg', hint: 'e.g. 20'),
          CalcField('ht', 'Height', unit: 'cm', hint: 'e.g. 115'),
        ],
        compute: (v) {
          final wt = v['wt'], ht = v['ht'];
          if (wt == null || ht == null || ht == 0) return null;
          final m = ht / 100;
          final bmi = wt / (m * m);
          return CalcResult(
            value: '${bmi.toStringAsFixed(1)} kg/m²',
            band: 'Plot on chart',
            color: _growth,
            detail:
                'In children BMI must be read as a percentile/z-score for age & sex — plot this on the WHO (0–5 y) or IAP (5–18 y) BMI-for-age chart in Growth Charts. Raw adult cut-offs do not apply.',
          );
        },
        notes: const [
          'BMI = weight (kg) ÷ height (m)².',
        ],
      );
}
