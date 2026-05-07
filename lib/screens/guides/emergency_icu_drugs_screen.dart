// =============================================================================
// guides/emergency_icu_drugs_screen.dart
// EMERGENCY DRUGS + VASOACTIVE MEDICATIONS tables.
// Verbatim transcription of every dose.
// =============================================================================

import 'package:flutter/material.dart';
import '_emergency_guide_widgets.dart';
import '../drugs/emergency_picu_drugs_screen.dart';

class _EmergencyDrug {
  final String name;
  final String indication;
  final String dose;
  final String maxDose;
  final String comments;
  const _EmergencyDrug({
    required this.name,
    required this.indication,
    required this.dose,
    required this.maxDose,
    required this.comments,
  });
}

const List<_EmergencyDrug> _emergencyDrugs = [
  _EmergencyDrug(
    name: 'Adrenaline',
    indication: 'Cardiac arrest · Symptomatic bradycardia · Anaphylaxis',
    dose:
        '0.01 mg/kg (0.1 mL/kg) 1:10,000 IV/IO; '
        '0.1 mg/kg (0.1 mL/kg) 1:1,000 ETT; '
        '0.01 mg/kg (0.01 mL/kg) 1:1,000 IM',
    maxDose: '1 mg / 2.5 mg / 0.5 mg',
    comments: 'IM in anaphylaxis',
  ),
  _EmergencyDrug(
    name: 'Atropine',
    indication: 'Bradycardia · AV Block',
    dose: '0.02 mg/kg IV/IO/IM ; 0.04–0.06 mg/kg ETT',
    maxDose: '1 mg',
    comments: '',
  ),
  _EmergencyDrug(
    name: 'Adenosine',
    indication: 'Supraventricular tachycardia',
    dose: '0.1 mg/kg IV/IO ; 0.2 mg/kg repeat dose',
    maxDose: '6 mg / 12 mg',
    comments: 'Rapid bolus. Flush with 10 mL normal saline.',
  ),
  _EmergencyDrug(
    name: 'Amiodarone',
    indication: 'Ventricular tachycardia · Ventricular fibrillation',
    dose: '5 mg/kg IV/IO',
    maxDose: 'First dose 300 mg ; Subsequent 150 mg',
    comments: 'Over 20–60 minutes',
  ),
  _EmergencyDrug(
    name: 'Calcium gluconate (10 %)',
    indication: 'Hypocalcaemia · Hyperkalaemia',
    dose: '1 mL/kg',
    maxDose: '2 g',
    comments: 'Over 10–20 minutes',
  ),
  _EmergencyDrug(
    name: 'Dextrose',
    indication: 'Hypoglycaemia',
    dose: '10 % Dx — 10 mL/kg IV/IO ; 25 % Dx — 4 mL/kg IV/IO ; '
        '50 % Dx — 2 mL/kg IV/IO',
    maxDose: 'Max single dose 50 g',
    comments: '',
  ),
  _EmergencyDrug(
    name: 'Insulin',
    indication: 'Hyperkalaemia',
    dose: '0.1 U/kg IV/IO',
    maxDose: '10 Units',
    comments: 'Along with 0.5 g/kg dextrose',
  ),
  _EmergencyDrug(
    name: 'Magnesium sulphate',
    indication: 'Torsades de pointes · Hypomagnesaemia',
    dose: '50 mg/kg IV/IO',
    maxDose: '2 g',
    comments:
        'Over 20–30 minutes. Monitor for bradycardia and hypotension.',
  ),
  _EmergencyDrug(
    name: 'Naloxone',
    indication: 'Opioid overdose · Resp depression',
    dose:
        'Resp depression 0.001–0.005 mg/kg/dose IV/IO/IM/SC ; '
        'Full reversal 0.1 mg/kg IV/IO/IM/SC',
    maxDose: '0.1 mg / 2 mg',
    comments: 'ETT dose 2–3 times',
  ),
  _EmergencyDrug(
    name: 'Sodium Bicarbonate',
    indication:
        'Metabolic acidosis · Hyperkalaemia · Tricyclic antidepressant overdose',
    dose: '1 mEq/kg IV/IO',
    maxDose: '50 mEq',
    comments: 'Dilute with 1:1 sterile water',
  ),
];

class _Vasoactive {
  final String name;
  final String dose;
  final String dilution;
  final String rate;
  const _Vasoactive(this.name, this.dose, this.dilution, this.rate);
}

const List<_Vasoactive> _vasoactives = [
  _Vasoactive('Dopamine', '5–20 µg/kg/min', '30 mg / kg', '1 mL/hr = 10 µg/kg/min'),
  _Vasoactive('Dobutamine', '5–20 µg/kg/min', '30 mg / kg', '1 mL/hr = 10 µg/kg/min'),
  _Vasoactive('Epinephrine', '0.05–1.0 µg/kg/min', '0.3 mg / kg', '1 mL/hr = 0.1 µg/kg/min'),
  _Vasoactive('Norepinephrine', '0.05–0.5 µg/kg/min', '0.3 mg / kg', '1 mL/hr = 0.1 µg/kg/min'),
  _Vasoactive('Vasopressin', '0.5–2 mIU/kg/min', '3 milliunits/kg in 50 mL D5', '1 mL/hr = 1 milliunits/kg/min'),
  _Vasoactive('Milrinone', '0.25–1.0 µg/kg/min', '1.5 mg / kg', '1 mL/hr = 0.5 µg/kg/min'),
  _Vasoactive('Levosimendan', '0.05–0.2 µg/kg/min', '0.3 mg/kg', '1 mL/hr = 0.1 µg/kg/min'),
  _Vasoactive('Sodium nitroprusside (SNP)', '0.5–10 µg/kg/min', '3 mg / kg', '1 mL/hr = 1 µg/kg/min'),
  _Vasoactive('Nitroglycerine (NTG)', '0.5–20 µg/kg/min', '3 mg / kg', '1 mL/hr = 1 µg/kg/min'),
];

class EmergencyIcuDrugsScreen extends StatelessWidget {
  const EmergencyIcuDrugsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return EgScaffold(
      title: 'Emergency ICU Drugs',
      subtitle: 'Bolus + infusion drugs for resuscitation, '
          'arrhythmia, electrolyte emergencies and shock.',
      children: [
        // ── Open calculator pill ────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const EmergencyPICUDrugsScreen()),
            ),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
              decoration: BoxDecoration(
                color: emergencyBrand,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.calculate, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Open PICU Drugs calculator '
                      '(weight-based bolus + infusion)',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ),
        // ── Bolus drugs ─────────────────────────────────────────────────
        const EgSectionLabel('Emergency drugs', '  Bolus / IV push'),
        ..._emergencyDrugs.map((d) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border(
                    left: const BorderSide(color: emergencyBrand, width: 4),
                    top: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
                    right: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
                    bottom: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.name,
                        style: TextStyle(
                          color: cs.onSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 2),
                    Text(d.indication,
                        style: TextStyle(
                          color: emergencyBrand,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        )),
                    const SizedBox(height: 8),
                    _kv(context, 'Dose', d.dose),
                    if (d.maxDose.isNotEmpty)
                      _kv(context, 'Max', d.maxDose),
                    if (d.comments.isNotEmpty)
                      _kv(context, 'Note', d.comments),
                  ],
                ),
              ),
            )),

        // ── Vasoactive table ───────────────────────────────────────────
        const EgSectionLabel('Vasoactive medications',
            '  Inotropes · vasopressors · inodilators · vasodilators'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border:
                  Border.all(color: cs.onSurface.withValues(alpha: 0.10)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 9),
                  decoration: const BoxDecoration(
                    color: emergencyBrand,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(11),
                      topRight: Radius.circular(11),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Expanded(
                          flex: 4,
                          child: Text('Drug',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800))),
                      Expanded(
                          flex: 4,
                          child: Text('Dose',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800))),
                      Expanded(
                          flex: 4,
                          child: Text('Dilution / 50 mL D5',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800))),
                      Expanded(
                          flex: 4,
                          child: Text('1 mL/hr =',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800))),
                    ],
                  ),
                ),
                ..._vasoactives.asMap().entries.map((e) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: e.key.isEven
                            ? cs.onSurface.withValues(alpha: 0.025)
                            : null,
                        border: Border(
                          bottom: BorderSide(
                              color:
                                  cs.onSurface.withValues(alpha: 0.06)),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(e.value.name,
                                style: TextStyle(
                                  color: cs.onSurface,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  height: 1.4,
                                )),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(e.value.dose,
                                style: TextStyle(
                                  color:
                                      cs.onSurface.withValues(alpha: 0.85),
                                  fontSize: 11.5,
                                  height: 1.4,
                                )),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(e.value.dilution,
                                style: TextStyle(
                                  color:
                                      cs.onSurface.withValues(alpha: 0.85),
                                  fontSize: 11.5,
                                  height: 1.4,
                                )),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(e.value.rate,
                                style: TextStyle(
                                  color:
                                      cs.onSurface.withValues(alpha: 0.85),
                                  fontSize: 11.5,
                                  height: 1.4,
                                )),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),

        const EgPearl(
          title: 'Therapy phases (research add-on)',
          body:
              '0–5 min: Stabilisation phase — adrenaline, atropine, '
              'volume.\n'
              '5–20 min: Initial therapy phase — start vasoactive infusion '
              '(dopamine / adrenaline).\n'
              '20–40 min: Second therapy phase — escalate to noradrenaline '
              '+ inotropic support.\n'
              '40–60 min: Third therapy phase — milrinone, levosimendan, '
              'vasopressin; consider HFO/ECMO referral.',
        ),

        const EgReferenceCard(
          text:
              'Emergency '
              'Drugs + Vasoactive Medications tables. For use by '
              'qualified clinicians only.',
        ),
      ],
    );
  }

  Widget _kv(BuildContext ctx, String label, String value) {
    final cs = Theme.of(ctx).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 44,
            child: Text(label,
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.55),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                )),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.85),
                  fontSize: 12.5,
                  height: 1.55,
                )),
          ),
        ],
      ),
    );
  }
}
