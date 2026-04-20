// =============================================================================
// lib/screens/drugs/emergency/drug_extras.dart
//
// Static reference data used by the 4-tab drug cards: diluent compatibility,
// max-dose warnings with clinician-facing suggestion text, drug info text,
// and pure-math helpers for the Titrate / Check tabs.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Diluent compatibility ────────────────────────────────────────────────────

class DiluentCompat {
  final List<String> compatible;
  final List<String> incompatible;
  const DiluentCompat({required this.compatible, required this.incompatible});
}

const Map<String, DiluentCompat> kDiluentCompat = {
  'Dopamine': DiluentCompat(
    compatible: ['NS', '5% Dextrose', '10% Dextrose'],
    incompatible: ['Sodium bicarbonate (alkaline — inactivates dopamine)'],
  ),
  'Dobutamine': DiluentCompat(
    compatible: ['NS', '5% Dextrose', '10% Dextrose'],
    incompatible: ['Sodium bicarbonate', 'Alkaline solutions'],
  ),
  'Adrenaline': DiluentCompat(
    compatible: ['NS', '5% Dextrose'],
    incompatible: [
      'Sodium bicarbonate',
      'Alkaline solutions',
      'Blood products',
    ],
  ),
  'Noradrenaline': DiluentCompat(
    compatible: ['NS', '5% Dextrose'],
    incompatible: ['Alkaline solutions', 'Blood products'],
  ),
  'Milrinone': DiluentCompat(
    compatible: ['NS', '5% Dextrose', '0.45% NS'],
    incompatible: ['Furosemide (precipitates if mixed in same line)'],
  ),
  'Fentanyl': DiluentCompat(
    compatible: ['NS', '5% Dextrose', 'Sterile Water'],
    incompatible: ['None at standard concentrations'],
  ),
  'Vasopressin': DiluentCompat(
    compatible: ['NS', '5% Dextrose'],
    incompatible: ['None at standard concentrations'],
  ),
  'Morphine': DiluentCompat(
    compatible: ['NS', '5% Dextrose', 'Sterile Water'],
    incompatible: ['Aminophylline', 'Sodium bicarbonate'],
  ),
  'PGE1': DiluentCompat(
    compatible: ['5% Dextrose (preferred)', 'NS'],
    incompatible: ['Do NOT use without dilution'],
  ),
  'Midazolam': DiluentCompat(
    compatible: ['NS', '5% Dextrose', 'Sterile Water'],
    incompatible: ['Alkaline solutions', 'Sodium bicarbonate'],
  ),
  'Furosemide': DiluentCompat(
    compatible: ['NS'],
    incompatible: [
      'Milrinone (precipitates)',
      'Acidic solutions',
      'Dobutamine (at high concentration)',
    ],
  ),
  'Ketamine': DiluentCompat(
    compatible: ['NS', '5% Dextrose', 'Sterile Water'],
    incompatible: ['Barbiturates (precipitates)', 'Diazepam'],
  ),
  'Dexmedetomidine': DiluentCompat(
    compatible: ['NS', '5% Dextrose'],
    incompatible: ['None significant'],
  ),
  'Sildenafil': DiluentCompat(
    compatible: ['5% Dextrose (preferred)', 'NS'],
    incompatible: ['None at standard dilutions'],
  ),
};

// ─── Max-dose warnings (per drug) ─────────────────────────────────────────────

class MaxDoseInfo {
  /// Numeric threshold in the drug's native dose unit.
  final double maxValue;
  /// Dose unit — 'mcg/kg/min' | 'mcg/kg/hr' | 'mg/kg/hr'
  final String unit;
  /// Clinician-facing escalation suggestion.
  final String suggestion;
  const MaxDoseInfo(this.maxValue, this.unit, this.suggestion);
}

const Map<String, MaxDoseInfo> kMaxDose = {
  'Dopamine': MaxDoseInfo(
    20, 'mcg/kg/min',
    'Above maximum dopamine dose. Consider adding Adrenaline for additional inotropic support.',
  ),
  'Dobutamine': MaxDoseInfo(
    20, 'mcg/kg/min',
    'Above maximum dobutamine dose. Consider adding Milrinone or Adrenaline.',
  ),
  'Adrenaline': MaxDoseInfo(
    1.0, 'mcg/kg/min',
    'High-dose adrenaline. Reassess underlying cause. Consider Noradrenaline if vasoplegia.',
  ),
  'Noradrenaline': MaxDoseInfo(
    0.3, 'mcg/kg/min',
    'Above recommended noradrenaline range for neonates. Reassess diagnosis and consult senior.',
  ),
  'Milrinone': MaxDoseInfo(
    1.0, 'mcg/kg/min',
    'Above maximum milrinone dose. Monitor for hypotension.',
  ),
  'Fentanyl': MaxDoseInfo(
    5, 'mcg/kg/hr',
    'Above standard fentanyl range. Ensure airway is secured. Monitor for chest wall rigidity.',
  ),
  'Midazolam': MaxDoseInfo(
    0.4, 'mg/kg/hr',
    'Above seizure dosing range. Escalate to phenobarbitone or phenytoin if seizures not controlled.',
  ),
  'Furosemide': MaxDoseInfo(
    1, 'mg/kg/hr',
    'Above maximum continuous furosemide dose. Monitor electrolytes closely.',
  ),
  'Ketamine': MaxDoseInfo(
    1.2, 'mg/kg/hr',
    'Above standard ketamine range. Monitor for emergence reactions.',
  ),
  'Dexmedetomidine': MaxDoseInfo(
    1.0, 'mcg/kg/hr',
    'Above recommended neonatal dexmedetomidine dose. Limited data in neonates <28 weeks.',
  ),
  'PGE1': MaxDoseInfo(
    0.4, 'mcg/kg/min',
    'Above recommended PGE1 dose. Apnoea and hypotension risk significantly increased.',
  ),
};

// ─── Drug info (mechanism · use · special) ────────────────────────────────────

class DrugInfo {
  final String mechanism;
  final String neonatalUse;
  final String special;
  final String source;
  const DrugInfo({
    required this.mechanism,
    required this.neonatalUse,
    required this.special,
    required this.source,
  });
}

const Map<String, DrugInfo> kDrugInfo = {
  'Dopamine': DrugInfo(
    mechanism: 'β1 agonist at moderate dose, α1 at high dose, dopaminergic at low dose.',
    neonatalUse: 'First-line inotrope for neonatal shock/hypotension; renal-dose effect at ≤5 mcg/kg/min is controversial in neonates.',
    special: 'Extravasation causes tissue necrosis — use a confirmed central or deep peripheral line. Start at 5 mcg/kg/min and titrate.',
    source: 'NICE / ANZNN Neonatal Handbook',
  ),
  'Dobutamine': DrugInfo(
    mechanism: 'Predominantly β1 agonist → improves contractility and cardiac output.',
    neonatalUse: 'Useful in myocardial dysfunction, cardiogenic shock, post-asphyxia.',
    special: 'Less vasoconstrictive than dopamine. Can cause tachycardia and hypotension at high doses.',
    source: 'Neofax · ANZNN',
  ),
  'Adrenaline': DrugInfo(
    mechanism: 'Non-selective α and β agonist.',
    neonatalUse: 'Refractory shock, low cardiac output despite dopamine/dobutamine, cardiac arrest bolus.',
    special: 'Must be given via secure IV access. Can cause severe tissue injury if extravasated.',
    source: 'NRP · Neofax',
  ),
  'Noradrenaline': DrugInfo(
    mechanism: 'Potent α1 agonist with some β1 activity.',
    neonatalUse: 'Vasoplegic (warm) septic shock — raises SVR without excessive tachycardia.',
    special: 'Limited but growing neonatal evidence. Requires central line ideally.',
    source: 'ANZNN · ESPNIC consensus',
  ),
  'Milrinone': DrugInfo(
    mechanism: 'PDE3 inhibitor — inodilator. Increases contractility and reduces SVR/PVR.',
    neonatalUse: 'Low cardiac output syndrome, PPHN with RV dysfunction, post-cardiac surgery.',
    special: 'No loading dose in neonates due to hypotension risk. Infuse only. Monitor BP closely.',
    source: 'ESPNIC · ASE TNE 2024',
  ),
  'Fentanyl': DrugInfo(
    mechanism: 'Synthetic opioid — μ-receptor agonist. Analgesia + sedation.',
    neonatalUse: 'Analgesia during mechanical ventilation, pre-procedural sedation.',
    special: 'Rapid onset. Chest wall rigidity with fast bolus — give slow push. Tolerance develops.',
    source: 'Neofax',
  ),
  'Vasopressin': DrugInfo(
    mechanism: 'V1 receptor agonist → vasoconstriction via non-adrenergic pathway.',
    neonatalUse: 'Catecholamine-refractory shock, PPHN with systemic hypotension.',
    special: 'Second-line agent. Monitor for hyponatraemia, ischaemic complications.',
    source: 'ESPNIC consensus',
  ),
  'Morphine': DrugInfo(
    mechanism: 'μ-opioid agonist.',
    neonatalUse: 'Analgesia and sedation during ventilation; neonatal abstinence treatment.',
    special: 'Slower onset than fentanyl. Histamine release may drop BP. Dose per unit protocol.',
    source: 'Neofax · AAP',
  ),
  'PGE1': DrugInfo(
    mechanism: 'Prostaglandin E1 (alprostadil) — keeps ductus arteriosus patent.',
    neonatalUse: 'Duct-dependent congenital heart disease (cyanotic lesions, coarctation, HLHS).',
    special: 'Apnoea in 10–20% — be prepared to intubate. Hypotension, fever, jitteriness common.',
    source: 'NRP · ESC Cardiology',
  ),
  'Midazolam': DrugInfo(
    mechanism: 'Benzodiazepine — GABA-A receptor potentiation.',
    neonatalUse: 'Seizure control (2nd/3rd line), procedural sedation, sedation on ventilator.',
    special: 'Avoid as routine sedation in preterm (myoclonus, poor neurodevelopmental outcomes).',
    source: 'Neofax · AAP',
  ),
  'Furosemide': DrugInfo(
    mechanism: 'Loop diuretic — inhibits Na-K-2Cl cotransporter in loop of Henle.',
    neonatalUse: 'Fluid overload, heart failure, BPD chronic lung disease.',
    special: 'Ototoxicity with rapid infusion or concurrent aminoglycosides. Monitor K, Na, Ca.',
    source: 'Neofax',
  ),
  'Ketamine': DrugInfo(
    mechanism: 'NMDA receptor antagonist — dissociative anaesthesia.',
    neonatalUse: 'Procedural analgesia/sedation, intubation premedication, refractory sedation.',
    special: 'Preserves respiratory drive and BP. Bronchodilator. Increases secretions.',
    source: 'ANZNN · Neofax',
  ),
  'Dexmedetomidine': DrugInfo(
    mechanism: 'Highly selective α2 agonist — sedation without respiratory depression.',
    neonatalUse: 'Off-label sedation on ventilator; extubation / procedural sedation.',
    special: 'Bradycardia and hypotension. Limited safety data in extreme preterm.',
    source: 'ESPNIC off-label review',
  ),
  'Sildenafil': DrugInfo(
    mechanism: 'PDE5 inhibitor — pulmonary vasodilator.',
    neonatalUse: 'PPHN unresponsive to iNO; chronic pulmonary hypertension in BPD.',
    special: 'Monitor systemic BP (can drop). Loading followed by maintenance infusion or enteral dose.',
    source: 'ESPNIC · ASE TNE 2024',
  ),
};

// ─── Pure math: Titrate & Check ───────────────────────────────────────────────

/// What rate (ml/hr) achieves a target dose for this concentration?
///
/// - [finalConcNativePerMl] is the drug's concentration in its NATIVE unit
///   (mcg/ml for catecholamines/PGE1/fentanyl/dexmed, mg/ml for midazolam/
///   furosemide/ketamine/sildenafil, units/ml for vasopressin).
/// - [doseUnit] is one of 'mcg/kg/min', 'mcg/kg/hr', 'mg/kg/hr', 'units/kg/min'.
double rateForTargetDose({
  required double targetDose,
  required double weight,
  required double finalConcNativePerMl,
  required String doseUnit,
}) {
  if (finalConcNativePerMl <= 0 || weight <= 0) return 0;
  switch (doseUnit) {
    case 'mcg/kg/min':
      return (targetDose * weight * 60) / finalConcNativePerMl;
    case 'mcg/kg/hr':
    case 'mg/kg/hr':
      return (targetDose * weight) / finalConcNativePerMl;
    case 'units/kg/min':
      return (targetDose * weight * 60) / finalConcNativePerMl;
    default:
      return 0;
  }
}

/// What dose does a running rate deliver?
double doseFromRate({
  required double rateMlHr,
  required double weight,
  required double finalConcNativePerMl,
  required String doseUnit,
}) {
  if (weight <= 0) return 0;
  switch (doseUnit) {
    case 'mcg/kg/min':
      return rateMlHr * finalConcNativePerMl / weight / 60;
    case 'mcg/kg/hr':
    case 'mg/kg/hr':
      return rateMlHr * finalConcNativePerMl / weight;
    case 'units/kg/min':
      return rateMlHr * finalConcNativePerMl / weight / 60;
    default:
      return 0;
  }
}

/// Convenience: banner colour choice for a target/max ratio.
enum DoseBand { safe, nearMax, overMax }

DoseBand doseBandFor(double targetDose, double? maxValue) {
  if (maxValue == null || maxValue <= 0) return DoseBand.safe;
  if (targetDose > maxValue) return DoseBand.overMax;
  if (targetDose > maxValue * 0.8) return DoseBand.nearMax;
  return DoseBand.safe;
}

// ─── Shared little helpers for tab UI ─────────────────────────────────────────

class TabCardHeader extends StatelessWidget {
  const TabCardHeader({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            color: cs.onSurface,
          ),
        ),
        if (subtitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
      ],
    );
  }
}

class DoseBanner extends StatelessWidget {
  const DoseBanner({super.key, required this.band, required this.message});
  final DoseBand band;
  final String message;
  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;
    switch (band) {
      case DoseBand.safe:
        bg = const Color(0xFF2E7D32).withValues(alpha: 0.12);
        fg = const Color(0xFF1B5E20);
        icon = Icons.check_circle_outline;
        break;
      case DoseBand.nearMax:
        bg = const Color(0xFFF57C00).withValues(alpha: 0.12);
        fg = const Color(0xFFE65100);
        icon = Icons.warning_amber_rounded;
        break;
      case DoseBand.overMax:
        bg = const Color(0xFFC62828).withValues(alpha: 0.12);
        fg = const Color(0xFFB71C1C);
        icon = Icons.error_outline;
        break;
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: fg.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                color: fg,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CompatibilityChips extends StatelessWidget {
  const CompatibilityChips({super.key, required this.compat});
  final DiluentCompat compat;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Compatible',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF2E7D32),
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final c in compat.compatible)
              _chip(icon: Icons.check, color: const Color(0xFF2E7D32), label: c),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Incompatible',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFC62828),
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final c in compat.incompatible)
              _chip(icon: Icons.close, color: const Color(0xFFC62828), label: c),
          ],
        ),
      ],
    );
  }

  Widget _chip({required IconData icon, required Color color, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
