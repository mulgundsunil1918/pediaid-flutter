// =============================================================================
// guides/electrolyte_corrections_screen.dart
// Source: the source "ELECTROLYTE CORRECTIONS" card. Verbatim transcription of
// every value. Each formula chip cross-links to the matching calculator.
// =============================================================================

import 'package:flutter/material.dart';
import '_emergency_guide_widgets.dart';
import '../calculators/free_water_deficit_calculator.dart';
import '../calculators/sodium_correction_calculator.dart';
import '../calculators/potassium_correction_calculator.dart';
import '../calculators/calcium_correction_calculator.dart';
import '../calculators/magnesium_correction_calculator.dart';
import '../calculators/phosphate_correction_calculator.dart';
import '../calculators/dextrose_bolus_calculator.dart';
import '../calculators/anion_gap_calculator.dart';
import '../calculators/serum_osmolality_calculator.dart';
import '../calculators/corrected_sodium_calculator.dart';

class ElectrolyteCorrectionsScreen extends StatelessWidget {
  const ElectrolyteCorrectionsScreen({super.key});

  Widget _row(BuildContext ctx, {
    required String tag,
    required Color color,
    required String title,
    required List<String> treatments,
    required List<String> workup,
    required List<({String label, Widget Function() open})> calcs,
  }) {
    final cs = Theme.of(ctx).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(ctx).cardColor,
          border: Border.all(color: color.withValues(alpha: 0.55)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                    width: 50,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TREATMENT',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      )),
                  const SizedBox(height: 6),
                  EgBulletList(items: treatments),
                  const SizedBox(height: 12),
                  Text('WORK-UP',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      )),
                  const SizedBox(height: 6),
                  EgBulletList(items: workup),
                  if (calcs.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: calcs.map((c) {
                        return InkWell(
                          onTap: () => Navigator.push(ctx,
                              MaterialPageRoute(builder: (_) => c.open())),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 11, vertical: 7),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.calculate,
                                    color: Colors.white, size: 14),
                                const SizedBox(width: 6),
                                Text(c.label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
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

  @override
  Widget build(BuildContext context) {
    return EgScaffold(
      title: 'Electrolyte Corrections',
      subtitle: 'Treatment + work-up for every disturbance. Tap any '
          'calculator chip to do the math.',
      children: [
        // ── Top header (ABG + adjuncts from source) ────────────────────
        const EgSectionLabel('Adjuncts', '  Volume + base correction'),
        const EgCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Albumin',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: emergencyBrand)),
              SizedBox(height: 2),
              Text('0.5 – 1 g/kg of 25 % (2 – 4 mL/kg). Use 5 % for volume '
                  'expansion.'),
              SizedBox(height: 12),
              Text('BiCarb',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: emergencyBrand)),
              SizedBox(height: 2),
              Text('0.5 – 2 mEq/kg over 5–10 min. '
                  '[(Base deficit)(wt)(0.3) = dose in mEq] (1 Amp = 50 mEq).'),
              SizedBox(height: 12),
              Text('THAM',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: emergencyBrand)),
              SizedBox(height: 2),
              Text('(Base deficit)(wt)(0.5) = dose in mL. Infuse 1–2 mL/hr. '
                  'If base deficit unknown give 3–6 mL/kg/dose.'),
            ],
          ),
        ),

        const EgSectionLabel('Disturbances', '  Tap a calculator chip'),

        // ── ↑Ca ─────────────────────────────────────────────────────────
        _row(
          context,
          tag: '↑Ca',
          color: emergencyAmber,
          title: 'Hypercalcaemia',
          treatments: const [
            'Loop diuretics, IVF at 2–3 × maintenance',
            'Bisphosphonates with or without calcitonin',
          ],
          workup: const [
            'CMP, PO₄, Mg, PTH, VitD',
            'Urine Ca/Cr/PO₄, EKG',
          ],
          calcs: const [],
        ),

        // ── ↓Ca ─────────────────────────────────────────────────────────
        _row(
          context,
          tag: '↓Ca',
          color: emergencyBlue,
          title: 'Hypocalcaemia',
          treatments: const [
            'CaCl₂ 10–20 mg/kg q 10 min, max 500 mg/dose',
            'Ca gluconate 100 mg/kg q 10 min, max 4 g/dose',
            'MgSO₄ 25–50 mg/kg, max 2.5 g/dose',
          ],
          workup: const [
            'CMP, PO₄, Mg, PTH, VitD',
            'Urine Ca/Cr/PO₄/protein, EKG',
            'iCa, left wrist X-ray',
          ],
          calcs: [
            (label: 'Calcium correction', open: () => const CalciumCorrectionCalculator()),
          ],
        ),

        // ── ↑Na ─────────────────────────────────────────────────────────
        _row(
          context,
          tag: '↑Na',
          color: emergencyAmber,
          title: 'Hypernatraemia',
          treatments: const [
            'NS bolus to correct dehydration',
            'Correct Free Water Deficit (FWD) over 24–48 hrs',
            'Goal ↓ in Na 10–15 mEq/L per 24 hr',
            'Vasopressin: 0.5 microUnits/kg/hr, titrate q 15 min to goal '
                'UOP < 1–2 mL/kg/hr (in central DI)',
          ],
          workup: const [
            '4 mL FW/kg = ↓ Na 1 mEq/L',
            'FWD = 0.6 (wt) ([Na]/140 − 1)',
          ],
          calcs: [
            (label: 'Free water deficit', open: () => const FreeWaterDeficitCalculator()),
          ],
        ),

        // ── ↓Na ─────────────────────────────────────────────────────────
        _row(
          context,
          tag: '↓Na',
          color: emergencyRed,
          title: 'Hyponatraemia',
          treatments: const [
            'Slow correction: 0.5 mEq/L/hr or 15 mEq/L/day',
            'Symptomatic: 3 % saline 6 mL/kg ( ↑ by 5 mEq/L )',
            'Na deficit (mEq) = (Na_goal − Na_meas) × wt × 1.2',
          ],
          workup: const [
            'Urine & serum osm',
            'UA, urine lytes, CMP, lipids',
            'H₂O restriction if SIADH',
          ],
          calcs: [
            (label: 'Na correction', open: () => const SodiumCorrectionCalculator()),
            (label: 'Corrected Na (hyperglycaemia)', open: () => const CorrectedSodiumCalculator()),
          ],
        ),

        // ── ↑K ──────────────────────────────────────────────────────────
        _row(
          context,
          tag: '↑K',
          color: emergencyRed,
          title: 'Hyperkalaemia',
          treatments: const [
            'Dextrose 1–2 g/kg IV with Insulin 0.1 U/kg IV',
            'CaCl₂ 10–20 mg/kg IV, NaHCO₃ 1–2 mEq/kg',
            'Kayexalate 1–2 g/kg/dose NG/PR, Lasix, Dialysis',
          ],
          workup: const [
            'CMP, ABG, CK, UA, EKG',
            'Urine lytes',
          ],
          calcs: [
            (label: '↑K regimen', open: () => const PotassiumCorrectionCalculator()),
          ],
        ),

        // ── ↓K ──────────────────────────────────────────────────────────
        _row(
          context,
          tag: '↓K',
          color: emergencyAmber,
          title: 'Hypokalaemia',
          treatments: const [
            '0.5–1 mEq/kg KCl IV over 1–2 hours',
          ],
          workup: const [
            'Urine K > 40 mEq/L → renal wasting',
            'Urine K/Cr > 15 → renal wasting',
          ],
          calcs: [
            (label: 'KCl replacement', open: () => const PotassiumCorrectionCalculator()),
          ],
        ),

        // ── ↓Glu ────────────────────────────────────────────────────────
        _row(
          context,
          tag: '↓Glu',
          color: emergencyRed,
          title: 'Hypoglycaemia',
          treatments: const [
            'D10 5 mL/kg PIV, D25 2 mL/kg CVL',
            'Infusion: 6–8 mg/kg/min of D10',
            'No IV: Glucagon 0.003, Epi 0.01 mg/kg IM/SQ',
            'If > 10 mg/kg/min: diazoxide 3–8 mg/kg/day q 12, OR '
                'octreotide 10 mcg/kg IV or SQ q 8 hr',
          ],
          workup: const [
            'Critical labs: insulin, C-peptide, cortisol, GH, FFA, lactate, '
                'acetone, LFTs, NH₄, U Glu, urine ketones, IGF-1',
          ],
          calcs: [
            (label: 'Hypoglycaemia bolus', open: () => const DextroseBolusCalculator()),
          ],
        ),

        // ── ↓Mg ─────────────────────────────────────────────────────────
        _row(
          context,
          tag: '↓Mg',
          color: emergencyBlue,
          title: 'Hypomagnesaemia',
          treatments: const [
            'Correct if Mg < 0.75 mmol/L',
            '0.2 mmol/kg (50 mg/kg) (0.5 mL/kg of 10 % MgSO₄)',
            '25–50 mg/kg MgSO₄ over 2–4 hours',
            'Max 4 mmol or 1 g or 10 mL over 10 min',
            'Oral 0.2–0.4 mmol/kg',
          ],
          workup: const [
            'FE_Mg < 2 % → non-renal loss',
            '24-hr urine Mg > 30 mg → renal loss',
          ],
          calcs: [
            (label: 'Mg replacement', open: () => const MagnesiumCorrectionCalculator()),
          ],
        ),

        // ── ↓PO₄ ────────────────────────────────────────────────────────
        _row(
          context,
          tag: '↓PO₄',
          color: emergencyBlue,
          title: 'Hypophosphataemia',
          treatments: const [
            '0.15–0.3 mmol/kg of NaPhos / KPhos IV over 4 hr',
            'Correct if phosphorus < 0.8 mmol/L',
            '0.4 mmol/kg (child > 2 yr) — 0.7 mmol/kg (child < 2 yr)',
            'NaPhos (0.6 mmol/mL) or KPhos (1–3 mmol/mL) over 8–14 hr',
            'Dilute 1:10 in 0.9 % saline or 5 % D',
            'Peripheral: 0.05 mmol/kg/hr ; CVL: 0.5 mmol/kg/hr',
            'Oral: 1–3 mmol/kg/day (Phos sachet 500 mg = 16 mmol; '
                'K-Phos tab 250 mg = 8 mmol)',
          ],
          workup: const [
            'Refeeding syndrome, DKA, renal Fanconi syndrome, vitamin D '
                'deficiency, X-linked hypophosphataemia',
          ],
          calcs: [
            (label: 'PO₄ replacement', open: () => const PhosphateCorrectionCalculator()),
          ],
        ),

        const EgSectionLabel('Linked diagnostic calculators', ''),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _linkChip(context, 'Anion Gap',
                  () => const AnionGapCalculator()),
              _linkChip(context, 'Serum Osmolality',
                  () => const SerumOsmolalityCalculator()),
              _linkChip(context, 'Corrected Na',
                  () => const CorrectedSodiumCalculator()),
            ],
          ),
        ),

        const EgReferenceCard(
          text:
              ''
              'ELECTROLYTE CORRECTIONS card. Every value transcribed '
              'verbatim. Calculator chips link to the matching tools '
              'inside this app. For use by qualified clinicians only.',
        ),
      ],
    );
  }

  Widget _linkChip(BuildContext ctx, String label, Widget Function() open) {
    return InkWell(
      onTap: () => Navigator.push(
          ctx, MaterialPageRoute(builder: (_) => open())),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: emergencyBrand,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calculate, color: Colors.white, size: 14),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                )),
          ],
        ),
      ),
    );
  }
}
