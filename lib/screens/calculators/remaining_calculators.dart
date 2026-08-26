// =============================================================================
// calculators/remaining_calculators.dart
//
// Critical-care, cardiac, renal, haematology, growth and drug calculators.
// Each carries its formula and original source in `notes`.
// =============================================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'simple_calc_scaffold.dart';

const _crit = Color(0xFFC62828);
const _cardio = Color(0xFFAD1457);
const _renal = Color(0xFF00695C);
const _heme = Color(0xFF6A1B9A);
const _growth = Color(0xFF2E7D32);
const _drug = Color(0xFF00838F);
const _green = Color(0xFF2E7D32);
const _amber = Color(0xFFF9A825);
const _orange = Color(0xFFEF6C00);
const _red = Color(0xFFB71C1C);

// ── Critical care ────────────────────────────────────────────────────────────

class AaGradientCalculator extends StatelessWidget {
  const AaGradientCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'A–a Gradient',
        subtitle:
            'Alveolar–arterial oxygen gradient — separates hypoventilation from V/Q mismatch, shunt and diffusion defects.',
        accent: _crit,
        fields: const [
          CalcField('fio2', 'FiO₂ (decimal)', hint: 'e.g. 0.21', unit: '0.21–1.0'),
          CalcField('pao2', 'PaO₂ (arterial)', unit: 'mmHg', hint: 'e.g. 90'),
          CalcField('paco2', 'PaCO₂', unit: 'mmHg', hint: 'e.g. 40'),
          CalcField('age', 'Age (for expected value)', unit: 'years', hint: 'e.g. 8'),
          CalcField('patm', 'Atmospheric pressure', unit: 'mmHg', hint: '760 (sea level)'),
        ],
        compute: (v) {
          var fio2 = v['fio2'];
          final pao2 = v['pao2'], paco2 = v['paco2'];
          if (fio2 == null || pao2 == null || paco2 == null) return null;
          if (fio2 > 1.0) fio2 = fio2 / 100; // tolerate % entry
          final patm = v['patm'] ?? 760;
          // PAO2 = FiO2 × (Patm − PH2O) − PaCO2/R,  PH2O = 47, R = 0.8
          final pAO2 = fio2 * (patm - 47) - (paco2 / 0.8);
          final grad = pAO2 - pao2;
          final age = v['age'];
          final expected = age != null ? (age / 4) + 4 : null;
          // Without an age the result used to read "Enter age for expected"
          // and give no interpretation at all — unhelpful at the cot side,
          // where the age is known but nobody wants to type it to find out
          // whether 40 mmHg is bad. (Age/4)+4 is adult-derived anyway and
          // overstates the normal range in a young child, so a plain
          // paediatric ceiling of 15 mmHg on room air is used instead.
          final ceiling = expected ?? 15.0;
          final high = grad > ceiling;
          // a/A ratio: unlike the raw gradient it stays comparatively stable
          // as FiO₂ changes, which makes it the number to trend on a
          // ventilated child.
          final aToA = pAO2 > 0 ? pao2 / pAO2 : 0.0;
          return CalcResult(
            value: '${grad.toStringAsFixed(1)} mmHg',
            band: high ? 'Elevated' : 'Normal',
            color: high ? _orange : _green,
            detail: high
                ? 'Gradient exceeds the expected value — suggests V/Q mismatch, right-to-left shunt or a diffusion defect rather than pure hypoventilation.'
                : 'A NORMAL gradient with hypoxaemia points to hypoventilation or a low inspired oxygen tension (e.g. altitude). Check the PaCO₂: a high value with a normal gradient is hypoventilation.',
            extra: [
              ('Alveolar PAO₂', '${pAO2.toStringAsFixed(1)} mmHg'),
              ('a/A ratio', aToA.toStringAsFixed(2) + (aToA < 0.75 ? '  (low)' : '')),
              if (expected != null)
                ('Expected for age', '≤ ${expected.toStringAsFixed(1)} mmHg')
              else
                ('Reference used', '≤ 15 mmHg (paediatric, room air)'),
            ],
          );
        },
        notes: const [
          'PAO₂ = FiO₂ × (Patm − 47) − PaCO₂ ÷ 0.8;  A–a gradient = PAO₂ − PaO₂.',
          'Expected gradient on room air ≈ (age ÷ 4) + 4 mmHg. The gradient rises with supplemental oxygen, so interpret with care above FiO₂ 0.21.',
          'That (age ÷ 4) + 4 rule is derived in adults. In children on room air a gradient above roughly 15 mmHg is the more useful ceiling, and that is what is applied when no age is entered.',
          'a/A ratio = PaO₂ ÷ PAO₂; below 0.75 is abnormal. It holds up better than the raw gradient when FiO₂ changes, so trend it rather than the gradient on a ventilated child.',
          'Atmospheric pressure defaults to 760 mmHg (sea level). Enter the local value at altitude — using 760 well above sea level inflates PAO₂ and manufactures a gradient that is not there.',
        ],
      );
}

class CppCalculator extends StatelessWidget {
  const CppCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Cerebral Perfusion Pressure',
        subtitle: 'CPP = MAP − ICP. Central to traumatic brain injury management.',
        accent: _crit,
        fields: const [
          CalcField('map', 'Mean arterial pressure (MAP)', unit: 'mmHg', hint: 'e.g. 70'),
          CalcField('icp', 'Intracranial pressure (ICP)', unit: 'mmHg', hint: 'e.g. 15'),
          CalcField('age', 'Age (for target)', unit: 'years', hint: 'e.g. 6'),
        ],
        compute: (v) {
          final map = v['map'], icp = v['icp'];
          if (map == null || icp == null) return null;
          final cpp = map - icp;
          final age = v['age'];
          double target = 50;
          String band = 'Target ≥ 50 mmHg';
          if (age != null) {
            if (age < 1) {
              target = 40;
              band = 'Infant target ≥ 40';
            } else if (age < 6) {
              target = 50;
              band = 'Target ≥ 50 (1–5 y)';
            } else if (age < 12) {
              target = 55;
              band = 'Target ≥ 55 (6–11 y)';
            } else {
              target = 60;
              band = 'Target ≥ 60 (≥ 12 y)';
            }
          }
          final ok = cpp >= target;
          return CalcResult(
            value: '${cpp.toStringAsFixed(0)} mmHg',
            band: ok ? 'At/above target' : 'BELOW target',
            color: ok ? _green : _red,
            detail: ok
                ? 'CPP meets the age-based minimum ($band). Continue to avoid hypotension, hypoxia, hyperthermia and hypercarbia.'
                : 'CPP is BELOW the age-based minimum ($band) — risk of cerebral ischaemia. Raise MAP (fluids/vasopressors) and/or lower ICP (head-up 30°, sedation, osmotherapy, CSF drainage).',
            extra: [('Age-based minimum', '${target.toStringAsFixed(0)} mmHg')],
          );
        },
        notes: const [
          'CPP = MAP − ICP.',
          'Paediatric TBI targets: infants ≥40, 1–5 y ≥50, 6–11 y ≥55, ≥12 y ≥60 mmHg. ICP treatment threshold is >20 mmHg.',
          'Source: Kochanek PM et al. Guidelines for the Management of Pediatric Severe Traumatic Brain Injury, 3rd Edition. Pediatr Crit Care Med 2019;20(3S):S1–S82.',
        ],
      );
}

class HendersonHasselbalchCalculator extends StatelessWidget {
  const HendersonHasselbalchCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Henderson-Hasselbalch',
        subtitle: 'Calculates pH from bicarbonate and PaCO₂ — checks internal consistency of a blood gas.',
        accent: _crit,
        fields: const [
          CalcField('hco3', 'Bicarbonate (HCO₃⁻)', unit: 'mmol/L', hint: 'e.g. 24'),
          CalcField('paco2', 'PaCO₂', unit: 'mmHg', hint: 'e.g. 40'),
        ],
        compute: (v) {
          final hco3 = v['hco3'], paco2 = v['paco2'];
          if (hco3 == null || paco2 == null || paco2 <= 0 || hco3 <= 0) {
            return null;
          }
          final ph = 6.1 + (math.log(hco3 / (0.03 * paco2)) / math.ln10);
          final acidotic = ph < 7.35;
          final alkalotic = ph > 7.45;
          return CalcResult(
            value: 'pH ${ph.toStringAsFixed(2)}',
            band: acidotic
                ? 'Acidaemia'
                : (alkalotic ? 'Alkalaemia' : 'Normal pH'),
            color: acidotic ? _orange : (alkalotic ? _amber : _green),
            detail: acidotic
                ? 'pH <7.35. Low HCO₃⁻ suggests a metabolic acidosis; high PaCO₂ suggests a respiratory acidosis.'
                : alkalotic
                    ? 'pH >7.45. High HCO₃⁻ suggests a metabolic alkalosis; low PaCO₂ suggests a respiratory alkalosis.'
                    : 'pH within the normal range — a normal pH can still hide a mixed disorder, so check the anion gap.',
            extra: [
              ('Dissolved CO₂ (0.03 × PaCO₂)',
                  (0.03 * paco2).toStringAsFixed(2)),
            ],
          );
        },
        notes: const [
          'pH = 6.1 + log₁₀( HCO₃⁻ ÷ (0.03 × PaCO₂) ).',
          'A calculated pH that differs markedly from the measured value suggests a sampling or analyser error.',
        ],
      );
}

class TotalBodyWaterCalculator extends StatelessWidget {
  const TotalBodyWaterCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Total Body Water',
        subtitle: 'Estimates total body water — used for free-water and dialysis calculations.',
        accent: _crit,
        fields: const [
          CalcField('wt', 'Weight', unit: 'kg', hint: 'e.g. 15'),
          CalcField('age', 'Age', unit: 'years', hint: 'e.g. 4 (use 0 for newborn)'),
        ],
        compute: (v) {
          final wt = v['wt'], age = v['age'];
          if (wt == null || age == null) return null;
          double frac;
          String band;
          if (age < 0.083) {
            frac = 0.75;
            band = 'Newborn (~75 %)';
          } else if (age < 1) {
            frac = 0.65;
            band = 'Infant (~65 %)';
          } else if (age < 12) {
            frac = 0.60;
            band = 'Child (~60 %)';
          } else {
            frac = 0.60;
            band = 'Adolescent (~60 %)';
          }
          final tbw = wt * frac;
          return CalcResult(
            value: '${tbw.toStringAsFixed(1)} L',
            band: band,
            color: _crit,
            detail:
                'Total body water falls with age: about 75–80% of body weight in the newborn, 65% in infancy and 60% in older children. Used in free-water deficit and sodium-correction calculations.',
            extra: [
              ('Fraction used', '${(frac * 100).toStringAsFixed(0)} %'),
              ('Intracellular (≈⅔)', '${(tbw * 2 / 3).toStringAsFixed(1)} L'),
              ('Extracellular (≈⅓)', '${(tbw / 3).toStringAsFixed(1)} L'),
            ],
          );
        },
        notes: const [
          'TBW = weight (kg) × age-appropriate fraction (0.75 newborn, 0.65 infant, 0.60 child).',
          'Adolescent girls are often estimated at 0.55 because of higher body-fat proportion.',
        ],
      );
}

class UrineOutputCalculator extends StatelessWidget {
  const UrineOutputCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Urine Output & Fluid Balance',
        subtitle: 'Urine output in mL/kg/hour with oliguria thresholds.',
        accent: _crit,
        fields: const [
          CalcField('vol', 'Urine volume', unit: 'mL', hint: 'e.g. 120'),
          CalcField('wt', 'Weight', unit: 'kg', hint: 'e.g. 10'),
          CalcField('hrs', 'Over how many hours', unit: 'h', hint: 'e.g. 8'),
          CalcField('intake', 'Total intake in the same period (optional)', unit: 'mL', hint: 'e.g. 400'),
        ],
        compute: (v) {
          final vol = v['vol'], wt = v['wt'], hrs = v['hrs'];
          if (vol == null || wt == null || hrs == null || wt <= 0 || hrs <= 0) {
            return null;
          }
          final rate = vol / wt / hrs;
          final anuric = rate < 0.3;
          final oliguric = rate < 0.5;
          final low = rate < 1.0;
          final extra = <(String, String)>[];
          final intake = v['intake'];
          if (intake != null) {
            final bal = intake - vol;
            extra.add(('Balance (intake − urine)',
                '${bal >= 0 ? '+' : ''}${bal.toStringAsFixed(0)} mL'));
          }
          return CalcResult(
            value: '${rate.toStringAsFixed(2)} mL/kg/h',
            band: anuric
                ? 'Anuria/severe oliguria'
                : oliguric
                    ? 'Oliguria'
                    : low
                        ? 'Low-normal'
                        : 'Adequate',
            color: anuric
                ? _red
                : oliguric
                    ? _orange
                    : low
                        ? _amber
                        : _green,
            detail: anuric
                ? '<0.3 mL/kg/h — meets pRIFLE Failure criteria if sustained ≥24 h. Urgent assessment of volume status, perfusion and obstruction; nephrology input.'
                : oliguric
                    ? '<0.5 mL/kg/h — oliguria (pRIFLE Risk if ≥8 h, Injury if ≥16 h). Review perfusion, nephrotoxins and fluid balance.'
                    : low
                        ? 'Below 1 mL/kg/h — acceptable in older children but low for infants, who normally pass 1–2 mL/kg/h.'
                        : 'Adequate urine output. Infants normally 1–2 mL/kg/h; older children ≥1 mL/kg/h.',
            extra: extra,
          );
        },
        notes: const [
          'Urine output (mL/kg/h) = volume (mL) ÷ weight (kg) ÷ hours.',
          'pRIFLE urine-output criteria: Risk <0.5 mL/kg/h × 8 h · Injury <0.5 × 16 h · Failure <0.3 × 24 h or anuria × 12 h.',
        ],
      );
}

class PefrPredictedCalculator extends StatelessWidget {
  const PefrPredictedCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Predicted PEFR',
        subtitle:
            'Height-based predicted peak expiratory flow rate, with the measured value as a percentage of predicted.',
        accent: _crit,
        fields: const [
          CalcField('ht', 'Height', unit: 'cm', hint: 'e.g. 130'),
          CalcField('measured', 'Measured PEFR (optional)', unit: 'L/min', hint: 'e.g. 180'),
        ],
        compute: (v) {
          final ht = v['ht'];
          if (ht == null || ht < 100) return null;
          final predicted = ((ht - 100) * 5) + 100;
          final measured = v['measured'];
          if (measured == null) {
            return CalcResult(
              value: '${predicted.toStringAsFixed(0)} L/min',
              band: 'Predicted',
              color: _crit,
              detail:
                  'Predicted PEFR for this height. Enter the measured value to express it as a percentage of predicted.',
            );
          }
          final pct = measured / predicted * 100;
          final severe = pct < 50;
          final moderate = pct < 80;
          return CalcResult(
            value: '${pct.toStringAsFixed(0)} % of predicted',
            band: severe
                ? 'Severe'
                : moderate
                    ? 'Moderate'
                    : 'Mild / normal',
            color: severe ? _red : (moderate ? _orange : _green),
            detail: severe
                ? '<50% predicted — severe airflow obstruction. Treat as an acute severe exacerbation.'
                : moderate
                    ? '50–79% predicted — moderate obstruction. Bronchodilators and steroids; reassess response.'
                    : '≥80% predicted — mild or normal. Reassess after bronchodilator if symptomatic.',
            extra: [('Predicted PEFR', '${predicted.toStringAsFixed(0)} L/min')],
          );
        },
        notes: const [
          'Predicted PEFR (L/min) ≈ [(height cm − 100) × 5] + 100 — a clinical approximation for children.',
          'A child’s own personal best is a better reference than a population prediction where it is known.',
        ],
      );
}

// ── Cardiac ──────────────────────────────────────────────────────────────────

class FickCardiacOutputCalculator extends StatelessWidget {
  const FickCardiacOutputCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Cardiac Output (Fick)',
        subtitle: 'Fick-principle cardiac output from oxygen consumption and A–V oxygen difference.',
        accent: _cardio,
        fields: const [
          CalcField('vo2', 'Oxygen consumption (VO₂)', unit: 'mL/min', hint: 'e.g. 150'),
          CalcField('hb', 'Haemoglobin', unit: 'g/dL', hint: 'e.g. 12'),
          CalcField('sao2', 'Arterial saturation (SaO₂)', unit: '%', hint: 'e.g. 98'),
          CalcField('svo2', 'Mixed venous saturation (SvO₂)', unit: '%', hint: 'e.g. 70'),
          CalcField('bsa', 'BSA (optional, for index)', unit: 'm²', hint: 'e.g. 0.8'),
        ],
        compute: (v) {
          final vo2 = v['vo2'],
              hb = v['hb'],
              sao2 = v['sao2'],
              svo2 = v['svo2'];
          if (vo2 == null || hb == null || sao2 == null || svo2 == null) {
            return null;
          }
          final diff = (sao2 - svo2) / 100;
          if (diff <= 0) return null;
          // CO (L/min) = VO2 / (1.34 × Hb × (SaO2−SvO2) × 10)
          final co = vo2 / (1.34 * hb * diff * 10);
          final bsa = v['bsa'];
          final extra = <(String, String)>[
            ('A–V O₂ difference',
                '${(1.34 * hb * diff).toStringAsFixed(1)} mL O₂/dL'),
          ];
          String band = 'Cardiac output';
          Color color = _cardio;
          if (bsa != null && bsa > 0) {
            final ci = co / bsa;
            extra.add(('Cardiac index', '${ci.toStringAsFixed(2)} L/min/m²'));
            if (ci < 2.0) {
              band = 'Low cardiac index';
              color = _red;
            } else if (ci <= 4.0) {
              band = 'Normal index';
              color = _green;
            } else {
              band = 'High index';
              color = _amber;
            }
          }
          return CalcResult(
            value: '${co.toStringAsFixed(2)} L/min',
            band: band,
            color: color,
            detail:
                'Normal cardiac index in children is roughly 3.0–4.5 L/min/m²; below 2.0 indicates significant low-output state.',
            extra: extra,
          );
        },
        notes: const [
          'CO (L/min) = VO₂ ÷ [1.34 × Hb × (SaO₂ − SvO₂)] ÷ 10.',
          'Assumed VO₂ (e.g. 125–160 mL/min/m²) makes this an "assumed Fick" — measured VO₂ is more accurate.',
        ],
      );
}

class MapCalculator extends StatelessWidget {
  const MapCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Mean Arterial Pressure (MAP)',
        subtitle: 'Mean arterial pressure from systolic and diastolic values.',
        accent: _cardio,
        fields: const [
          CalcField('sbp', 'Systolic BP', unit: 'mmHg', hint: 'e.g. 100'),
          CalcField('dbp', 'Diastolic BP', unit: 'mmHg', hint: 'e.g. 60'),
          CalcField('age', 'Age (for expected minimum)', unit: 'years', hint: 'e.g. 5'),
        ],
        compute: (v) {
          final sbp = v['sbp'], dbp = v['dbp'];
          if (sbp == null || dbp == null || sbp <= dbp) return null;
          final map = dbp + (sbp - dbp) / 3;
          final age = v['age'];
          final extra = <(String, String)>[
            ('Pulse pressure', '${(sbp - dbp).toStringAsFixed(0)} mmHg'),
          ];
          String band = 'MAP';
          Color color = _cardio;
          if (age != null) {
            // Rough 5th-centile MAP ≈ 40 + (1.5 × age) for children.
            final minMap = 40 + 1.5 * age;
            extra.add(
                ('Approx. 5th-centile MAP', '${minMap.toStringAsFixed(0)} mmHg'));
            if (map < minMap) {
              band = 'Below expected';
              color = _red;
            } else {
              band = 'Adequate';
              color = _green;
            }
          }
          return CalcResult(
            value: '${map.toStringAsFixed(0)} mmHg',
            band: band,
            color: color,
            detail:
                'MAP drives organ perfusion. In shock, aim for an age-appropriate MAP alongside clinical perfusion markers (capillary refill, lactate, urine output).',
            extra: extra,
          );
        },
        notes: const [
          'MAP = DBP + ⅓ × (SBP − DBP) — valid at normal heart rates; it underestimates at high rates.',
          'Approximate lower limit of normal MAP ≈ 40 + (1.5 × age in years) mmHg.',
        ],
      );
}

// ── Renal ────────────────────────────────────────────────────────────────────

class FeMgCalculator extends StatelessWidget {
  const FeMgCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Fractional Excretion of Magnesium',
        subtitle: 'Distinguishes renal magnesium wasting from extra-renal losses in hypomagnesaemia.',
        accent: _renal,
        fields: const [
          CalcField('umg', 'Urine magnesium', unit: 'mg/dL', hint: 'e.g. 3'),
          CalcField('smg', 'Serum magnesium', unit: 'mg/dL', hint: 'e.g. 1.4'),
          CalcField('ucr', 'Urine creatinine', unit: 'mg/dL', hint: 'e.g. 60'),
          CalcField('scr', 'Serum creatinine', unit: 'mg/dL', hint: 'e.g. 0.6'),
        ],
        compute: (v) {
          final umg = v['umg'], smg = v['smg'], ucr = v['ucr'], scr = v['scr'];
          if (umg == null || smg == null || ucr == null || scr == null) {
            return null;
          }
          if (smg <= 0 || ucr <= 0) return null;
          // 0.7 corrects for the protein-bound (non-filterable) fraction of Mg.
          final fe = (umg * scr) / (0.7 * smg * ucr) * 100;
          final renal = fe > 4;
          return CalcResult(
            value: '${fe.toStringAsFixed(1)} %',
            band: renal ? 'Renal wasting' : 'Extra-renal loss',
            color: renal ? _orange : _green,
            detail: renal
                ? '>4% in the presence of hypomagnesaemia indicates RENAL magnesium wasting — consider drugs (amphotericin, aminoglycosides, cisplatin, diuretics, calcineurin inhibitors), Gitelman/Bartter syndrome or tubular injury.'
                : '<2% suggests appropriate renal conservation, so losses are EXTRA-renal (gastrointestinal) or intake is inadequate.',
          );
        },
        notes: const [
          'FEMg = (UMg × SCr) ÷ (0.7 × SMg × UCr) × 100. The 0.7 factor corrects for magnesium that is protein-bound and therefore not filtered.',
        ],
      );
}

// ── Haematology ──────────────────────────────────────────────────────────────

class ReticulocyteCalculator extends StatelessWidget {
  const ReticulocyteCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Reticulocyte Count (Absolute · Corrected · RPI)',
        subtitle:
            'Corrects the reticulocyte percentage for anaemia — separates hypoproliferative from haemolytic anaemia.',
        accent: _heme,
        fields: const [
          CalcField('retic', 'Reticulocytes', unit: '%', hint: 'e.g. 2.5'),
          CalcField('hct', 'Haematocrit', unit: '%', hint: 'e.g. 25'),
          CalcField('rbc', 'RBC count (optional)', unit: '×10¹²/L', hint: 'e.g. 3.2'),
        ],
        compute: (v) {
          final retic = v['retic'], hct = v['hct'];
          if (retic == null || hct == null) return null;
          const normalHct = 45.0;
          final corrected = retic * (hct / normalHct);
          // Maturation factor by haematocrit.
          double mf;
          if (hct >= 35) {
            mf = 1.0;
          } else if (hct >= 25) {
            mf = 1.5;
          } else if (hct >= 20) {
            mf = 2.0;
          } else {
            mf = 2.5;
          }
          final rpi = corrected / mf;
          final extra = <(String, String)>[
            ('Corrected retic %', '${corrected.toStringAsFixed(2)} %'),
            ('Maturation factor', mf.toStringAsFixed(1)),
          ];
          final rbc = v['rbc'];
          if (rbc != null) {
            final arc = retic / 100 * rbc * 1e6; // → /µL
            extra.insert(0, ('Absolute retic count',
                '${arc.toStringAsFixed(0)} /µL'));
          }
          final adequate = rpi >= 2;
          return CalcResult(
            value: 'RPI ${rpi.toStringAsFixed(2)}',
            band: adequate ? 'Adequate response' : 'Inadequate response',
            color: adequate ? _green : _orange,
            detail: adequate
                ? 'RPI ≥2 indicates an ADEQUATE marrow response — consistent with haemolysis or blood loss.'
                : 'RPI <2 indicates an INADEQUATE marrow response — hypoproliferative anaemia (iron/B12/folate deficiency, marrow failure, chronic disease, renal disease).',
            extra: extra,
          );
        },
        notes: const [
          'Corrected retic % = retic % × (patient Hct ÷ 45).  RPI = corrected retic % ÷ maturation factor.',
          'Maturation factor: Hct ≥35 → 1.0; 25–34 → 1.5; 20–24 → 2.0; <20 → 2.5.',
          'Absolute reticulocyte count = retic % × RBC count. Normal ≈ 25 000–75 000/µL.',
        ],
      );
}

class CryoprecipitateCalculator extends StatelessWidget {
  const CryoprecipitateCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Cryoprecipitate Dosing',
        subtitle: 'Fibrinogen replacement in hypofibrinogenaemia and massive haemorrhage.',
        accent: _heme,
        fields: const [
          CalcField('wt', 'Weight', unit: 'kg', hint: 'e.g. 20'),
          CalcField('current', 'Current fibrinogen (optional)', unit: 'mg/dL', hint: 'e.g. 80'),
          CalcField('target', 'Target fibrinogen (optional)', unit: 'mg/dL', hint: 'e.g. 150'),
        ],
        compute: (v) {
          final wt = v['wt'];
          if (wt == null || wt <= 0) return null;
          // Standard paediatric dosing: 1 unit per 5–10 kg.
          final lowUnits = wt / 10;
          final highUnits = wt / 5;
          final extra = <(String, String)>[
            ('Volume (≈10–15 mL/kg equivalent)',
                '${(wt * 1).toStringAsFixed(0)}–${(wt * 2).toStringAsFixed(0)} mL approx.'),
          ];
          final cur = v['current'], tgt = v['target'];
          if (cur != null && tgt != null && tgt > cur) {
            // Plasma volume ≈ 0.07 × wt × (1 − Hct); using 0.045 L/kg approx.
            final plasmaVolDl = wt * 0.045 * 10; // dL
            final mgNeeded = (tgt - cur) * plasmaVolDl;
            final units = mgNeeded / 250; // ~250 mg fibrinogen per unit
            extra.add(('Units to raise fibrinogen',
                '${units.ceil()} units (≈${mgNeeded.toStringAsFixed(0)} mg)'));
          }
          return CalcResult(
            value: '${lowUnits.ceil()}–${highUnits.ceil()} units',
            band: 'Standard dose',
            color: _heme,
            detail:
                'Standard paediatric dose is 1 unit per 5–10 kg body weight, which typically raises fibrinogen by 50–100 mg/dL. Recheck fibrinogen after transfusion.',
            extra: extra,
          );
        },
        notes: const [
          'One unit of cryoprecipitate contains roughly 150–250 mg fibrinogen in 10–20 mL.',
          'Transfusion threshold: fibrinogen <100 mg/dL with bleeding, or <150 mg/dL in massive haemorrhage/obstetric bleeding.',
        ],
      );
}

// ── Growth / nutrition ───────────────────────────────────────────────────────

class IdealBodyWeightCalculator extends StatelessWidget {
  const IdealBodyWeightCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Ideal Body Weight (Children)',
        subtitle:
            'Traub-Johnson height-based ideal body weight — used for drug dosing in obesity.',
        accent: _growth,
        fields: const [
          CalcField('ht', 'Height', unit: 'cm', hint: 'e.g. 130'),
          CalcField('wt', 'Actual weight (optional)', unit: 'kg', hint: 'e.g. 45'),
        ],
        compute: (v) {
          final ht = v['ht'];
          if (ht == null || ht < 70) return null;
          // Traub & Johnson: IBW (kg) = 2.396 × e^(0.01863 × height cm)
          final ibw = 2.396 * math.exp(0.01863 * ht);
          final wt = v['wt'];
          final extra = <(String, String)>[];
          String band = 'Ideal body weight';
          Color color = _growth;
          if (wt != null && ibw > 0) {
            final pct = wt / ibw * 100;
            extra.add(('Actual as % of IBW', '${pct.toStringAsFixed(0)} %'));
            // Adjusted body weight for lipophilic drug dosing.
            if (wt > ibw) {
              final abw = ibw + 0.4 * (wt - ibw);
              extra.add(('Adjusted body weight',
                  '${abw.toStringAsFixed(1)} kg'));
            }
            if (pct >= 120) {
              band = 'Obese range';
              color = _orange;
            } else if (pct >= 110) {
              band = 'Overweight range';
              color = _amber;
            } else if (pct < 80) {
              band = 'Underweight (wasting)';
              color = _orange;
            } else {
              band = 'Within normal range';
              color = _green;
            }
          }
          return CalcResult(
            value: '${ibw.toStringAsFixed(1)} kg',
            band: band,
            color: color,
            detail:
                'Use IBW (not actual weight) when dosing hydrophilic drugs in an obese child. Adjusted body weight = IBW + 0.4 × (actual − IBW) is used for some lipophilic drugs.',
            extra: extra,
          );
        },
        notes: const [
          'IBW (kg) = 2.396 × e^(0.01863 × height in cm). Validated for children 1–17 years, height 74–164 cm.',
          'Source: Traub SL, Johnson CE. Comparison of methods of estimating creatinine clearance in children. Am J Hosp Pharm 1980;37:195–201.',
          'Waterlow classification by % IBW: >120% obese · 110–120% overweight · 80–90% mild wasting · 70–80% moderate · <70% severe.',
        ],
      );
}

class BmrCalculator extends StatelessWidget {
  const BmrCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'BMR / Resting Energy Expenditure',
        subtitle: 'Schofield weight-based equations for basal metabolic rate in children.',
        accent: _growth,
        fields: const [
          CalcField('wt', 'Weight', unit: 'kg', hint: 'e.g. 20'),
          CalcField('age', 'Age', unit: 'years', hint: 'e.g. 7'),
          CalcField('male', 'Male (1 = yes, 0 = female)', hint: '1 or 0'),
          CalcField('stress', 'Stress factor (optional)', hint: 'e.g. 1.3'),
        ],
        compute: (v) {
          final wt = v['wt'], age = v['age'], male = v['male'];
          if (wt == null || age == null || male == null) return null;
          final isMale = male >= 0.5;
          double bmr;
          if (age < 3) {
            bmr = isMale ? (59.512 * wt - 30.4) : (58.317 * wt - 31.1);
          } else if (age < 10) {
            bmr = isMale ? (22.706 * wt + 504.3) : (20.315 * wt + 485.9);
          } else {
            bmr = isMale ? (17.686 * wt + 658.2) : (13.384 * wt + 692.6);
          }
          final stress = v['stress'];
          final extra = <(String, String)>[
            ('Per kg', '${(bmr / wt).toStringAsFixed(0)} kcal/kg/day'),
          ];
          if (stress != null && stress > 0) {
            extra.add(('With stress factor ×$stress',
                '${(bmr * stress).toStringAsFixed(0)} kcal/day'));
          }
          return CalcResult(
            value: '${bmr.toStringAsFixed(0)} kcal/day',
            band: 'Schofield BMR',
            color: _growth,
            detail:
                'Basal metabolic rate at rest. Multiply by an activity/stress factor for total energy requirement — commonly 1.2–1.4 for ward patients, higher in sepsis, burns or catch-up growth.',
            extra: extra,
          );
        },
        notes: const [
          'Schofield (weight-only) equations, kcal/day:',
          'Boys — <3 y: 59.512×wt − 30.4 · 3–10 y: 22.706×wt + 504.3 · 10–18 y: 17.686×wt + 658.2',
          'Girls — <3 y: 58.317×wt − 31.1 · 3–10 y: 20.315×wt + 485.9 · 10–18 y: 13.384×wt + 692.6',
          'Source: Schofield WN. Predicting basal metabolic rate. Hum Nutr Clin Nutr 1985;39C(Suppl 1):5–41.',
        ],
      );
}

// ── Drug / fluids ────────────────────────────────────────────────────────────

class IronDeficitCalculator extends StatelessWidget {
  const IronDeficitCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Total Iron Deficit (Ganzoni)',
        subtitle: 'Total iron requirement for parenteral iron replacement.',
        accent: _drug,
        fields: const [
          CalcField('wt', 'Weight', unit: 'kg', hint: 'e.g. 20'),
          CalcField('hbActual', 'Actual haemoglobin', unit: 'g/dL', hint: 'e.g. 8'),
          CalcField('hbTarget', 'Target haemoglobin', unit: 'g/dL', hint: 'e.g. 12'),
        ],
        compute: (v) {
          final wt = v['wt'], a = v['hbActual'], t = v['hbTarget'];
          if (wt == null || a == null || t == null || t <= a) return null;
          // Ganzoni: deficit (mg) = wt × (target − actual) × 2.4 + iron stores
          final stores = wt < 35 ? wt * 15 : 500.0;
          final deficit = wt * (t - a) * 2.4 + stores;
          return CalcResult(
            value: '${deficit.toStringAsFixed(0)} mg',
            band: 'Total iron deficit',
            color: _drug,
            detail:
                'Total elemental iron required to correct the haemoglobin AND replenish stores. Divide into doses according to the preparation’s maximum single dose; oral iron remains first line where tolerated and absorbed.',
            extra: [
              ('Iron for haemoglobin',
                  '${(wt * (t - a) * 2.4).toStringAsFixed(0)} mg'),
              ('Iron for stores', '${stores.toStringAsFixed(0)} mg'),
            ],
          );
        },
        notes: const [
          'Ganzoni formula: iron deficit (mg) = body weight (kg) × (target Hb − actual Hb) (g/dL) × 2.4 + depot iron.',
          'Depot iron: 15 mg/kg for weight <35 kg; 500 mg for ≥35 kg.',
          'Source: Ganzoni AM. Intravenous iron-dextran: therapeutic and experimental possibilities. Schweiz Med Wochenschr 1970;100:301–3.',
        ],
      );
}

class InfusionRateCalculator extends StatelessWidget {
  const InfusionRateCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'IV Drip Rate',
        subtitle: 'Converts an infusion volume and duration into mL/hour and drops per minute.',
        accent: _drug,
        fields: const [
          CalcField('vol', 'Volume to infuse', unit: 'mL', hint: 'e.g. 500'),
          CalcField('hrs', 'Over how many hours', unit: 'h', hint: 'e.g. 6'),
          CalcField('drop', 'Drop factor', unit: 'gtt/mL', hint: '60 micro, 15–20 macro'),
        ],
        compute: (v) {
          final vol = v['vol'], hrs = v['hrs'];
          if (vol == null || hrs == null || hrs <= 0) return null;
          final mlHr = vol / hrs;
          final drop = v['drop'] ?? 60;
          final gttMin = mlHr * drop / 60;
          return CalcResult(
            value: '${mlHr.toStringAsFixed(1)} mL/hour',
            band: 'Infusion rate',
            color: _drug,
            detail:
                'Use a micro-drip set (60 gtt/mL) for children — 1 mL/hour then equals 1 drop/minute, which makes rate checks straightforward.',
            extra: [
              ('Drops per minute', '${gttMin.toStringAsFixed(0)} gtt/min'),
              ('Drop factor used', '${drop.toStringAsFixed(0)} gtt/mL'),
              ('Total over ${hrs.toStringAsFixed(1)} h', '${vol.toStringAsFixed(0)} mL'),
            ],
          );
        },
        notes: const [
          'Rate (mL/h) = volume ÷ hours.  Drops/min = mL/h × drop factor ÷ 60.',
          'Drop factors: micro-drip 60 gtt/mL; macro-drip 15 or 20 gtt/mL depending on the set.',
        ],
      );
}

class CalciumEquivalentCalculator extends StatelessWidget {
  const CalciumEquivalentCalculator({super.key});
  @override
  Widget build(BuildContext context) => SimpleCalcScaffold(
        title: 'Calcium Salt Equivalents',
        subtitle:
            'Converts between calcium gluconate and calcium chloride by elemental calcium content.',
        accent: _drug,
        fields: const [
          CalcField('gluc', 'Calcium gluconate 10 % (optional)', unit: 'mL', hint: 'e.g. 10'),
          CalcField('chlor', 'Calcium chloride 10 % (optional)', unit: 'mL', hint: 'e.g. 3'),
        ],
        compute: (v) {
          final gluc = v['gluc'], chlor = v['chlor'];
          if (gluc == null && chlor == null) return null;
          // 10% solutions: gluconate 100 mg/mL salt → 9.3 mg/mL elemental Ca
          //                chloride  100 mg/mL salt → 27.3 mg/mL elemental Ca
          if (gluc != null) {
            final elem = gluc * 9.3;
            final equivChloride = elem / 27.3;
            return CalcResult(
              value: '${elem.toStringAsFixed(0)} mg elemental Ca',
              band: 'From gluconate',
              color: _drug,
              detail:
                  'Calcium gluconate 10% contains 9.3 mg/mL elemental calcium (0.46 mEq/mL). It is the preferred salt peripherally — calcium chloride is highly sclerosant and should go through a central line.',
              extra: [
                ('Equivalent calcium chloride 10 %',
                    '${equivChloride.toStringAsFixed(1)} mL'),
                ('mEq calcium', '${(elem / 20).toStringAsFixed(1)} mEq'),
              ],
            );
          }
          final elem = chlor! * 27.3;
          final equivGluc = elem / 9.3;
          return CalcResult(
            value: '${elem.toStringAsFixed(0)} mg elemental Ca',
            band: 'From chloride',
            color: _drug,
            detail:
                'Calcium chloride 10% contains 27.3 mg/mL elemental calcium (1.36 mEq/mL) — about three times as much as gluconate per mL. Give centrally where possible.',
            extra: [
              ('Equivalent calcium gluconate 10 %',
                  '${equivGluc.toStringAsFixed(1)} mL'),
              ('mEq calcium', '${(elem / 20).toStringAsFixed(1)} mEq'),
            ],
          );
        },
        notes: const [
          '10% calcium gluconate: 100 mg/mL salt = 9.3 mg/mL elemental calcium = 0.46 mEq/mL.',
          '10% calcium chloride: 100 mg/mL salt = 27.3 mg/mL elemental calcium = 1.36 mEq/mL.',
          'Elemental calcium (mg) ÷ 20 = mEq calcium.',
        ],
      );
}
