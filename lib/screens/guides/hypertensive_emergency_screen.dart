// =============================================================================
// guides/hypertensive_emergency_screen.dart
// HYPERTENSIVE EMERGENCY flowchart + drug tables.
// Verbatim transcription of every dose and frequency.
// =============================================================================

import 'package:flutter/material.dart';
import '_emergency_guide_widgets.dart';

class _DoseRow {
  final String drug;
  final String dose;
  const _DoseRow(this.drug, this.dose);
}

const List<_DoseRow> _parenteral = [
  _DoseRow('Esmolol',
      'Bolus: 100–500 mCg/kg\nInfusion: 25–250 mCg/kg/min (max 1000 mCg/kg/min)'),
  _DoseRow('Hydralazine',
      '0.1–0.2 mg/kg/dose IV/IM (max 2 mg/kg/dose or 20 mg) Q4–6 hr PRN'),
  _DoseRow('Labetalol',
      'Bolus: 0.2–1 mg/kg (max 40 mg)\nInfusion: 0.25–1 mg/kg/hr (max 3 mg/kg/hr)'),
  _DoseRow('Nicardipine',
      'Start at 0.5–1 mCg/kg/min (max 5 mCg/min or 15 mg/hr)'),
  _DoseRow('Nitroprusside',
      '0.3–4 mCg/kg/min (max 10 mCg/kg/min)'),
];

const List<_DoseRow> _enteral = [
  _DoseRow('Captopril', '0.3–0.5 mg/kg (max 6 mg/kg/day or 450 mg/24 hr)'),
  _DoseRow('Clonidine',
      '1–10 mCg/kg/dose Q6–8 hr (max 25 mCg/kg/24 hr up to 0.8 mg/24 hr)'),
  _DoseRow('Nifedipine',
      '0.1–0.25 mg/kg/dose Q4–6 hr PO/SL (max 10 mg/dose, 1–2 mg/kg/24 hr)'),
];

class HypertensiveEmergencyScreen extends StatelessWidget {
  const HypertensiveEmergencyScreen({super.key});

  Widget _doseTable(BuildContext context, String label, List<_DoseRow> rows) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: cs.onSurface.withValues(alpha: 0.10)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: const BoxDecoration(
                color: emergencyBrand,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(11),
                ),
              ),
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5)),
            ),
            ...rows.asMap().entries.map((e) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: e.key.isEven
                        ? cs.onSurface.withValues(alpha: 0.025)
                        : null,
                    border: Border(
                      bottom: BorderSide(
                          color: cs.onSurface.withValues(alpha: 0.06)),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(e.value.drug,
                            style: TextStyle(
                              color: cs.onSurface,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 7,
                        child: Text(e.value.dose,
                            style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.85),
                              fontSize: 12.5,
                              height: 1.45,
                            )),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _pathChip({
    required String tag,
    required String title,
    required String criteria,
    required Color color,
    required List<String> steps,
  }) {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
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
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
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
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.10),
                        border:
                            Border.all(color: color.withValues(alpha: 0.35)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(criteria,
                          style: TextStyle(
                            color: color,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            height: 1.45,
                          )),
                    ),
                    const SizedBox(height: 12),
                    Text('STEPS',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        )),
                    const SizedBox(height: 6),
                    EgBulletList(items: steps, numbered: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return EgScaffold(
      title: 'Hypertensive Emergency',
      subtitle: 'Triage of confirmed paediatric hypertension + dosing tables.',
      children: [
        // ── 3 paths ───────────────────────────────────────────────────
        const EgSectionLabel('Triage', '  Hypertension confirmed → 3 paths'),

        _pathChip(
          tag: 'PATH A',
          title: 'Chronic hypertension',
          criteria:
              'No reason to suspect acute aetiology based on investigations '
              'and symptoms.',
          color: emergencyGreen,
          steps: const [
            'First-line agents: ACE-Is, ARBs, thiazide diuretics, CCBs — '
                'consider combination of first-line agents to reach target '
                'BP goal.',
            'Adjunct agents may be considered based on underlying aetiology, '
                'e.g., β-blockers, α-blockers, loop and potassium-sparing '
                'diuretics, clonidine, minoxidil.',
          ],
        ),
        _pathChip(
          tag: 'PATH B',
          title: 'Hypertensive urgency',
          criteria:
              'Acute severe hypertension WITHOUT features of target-organ '
              'damage.',
          color: emergencyAmber,
          steps: const [
            'PO nifedipine (liquid or "bite and swallow" capsule) — start '
                'at low dose of 100 micrograms/kg, OR IV hydralazine bolus '
                '— start at low dose of 100–150 micrograms/kg (1 month – '
                '11 years).',
            'If evidence of fluid overload, consider a thiazide or loop '
                'diuretic.',
            'Early consideration of longer-acting antihypertensive agents '
                '(as detailed for "Chronic hypertension").',
          ],
        ),
        _pathChip(
          tag: 'PATH C',
          title: 'Hypertensive emergency',
          criteria:
              'Acute severe hypertension (SBP > 99ᵗʰ centile, plus 5 mmHg) '
              'WITH features of target-organ damage.',
          color: emergencyRed,
          steps: const [
            'ABC approach. Ensure IV access.',
            'APLS seizure management if necessary.',
            'Contact PICU and renal consultant.',
            'Ensure no acute neurological / neurosurgical concerns '
                'requiring neuroimaging.',
            'First-line: IV labetalol infusion.',
            'Second-line: IV SNP infusion.',
            'Third-line: IV hydralazine infusion.',
            'If evidence of fluid overload, consider a thiazide or loop '
                'diuretic, or CRRT for fluid removal if oligoanuric.',
          ],
        ),

        const EgPearl(
          icon: Icons.timeline,
          title: 'How fast to drop BP',
          body:
              'Aim to reduce SBP by 1/3ʳᵈ in the first 12 hours, a further '
              '1/3ʳᵈ over the next 12 hours, and the final 1/3ʳᵈ over the '
              'next 24 hours (towards 90ᵗʰ–95ᵗʰ centile). Faster drops '
              'risk watershed cerebral ischaemia and posterior reversible '
              'encephalopathy syndrome (PRES).',
        ),

        // ── Drug doses (parenteral) ───────────────────────────────────
        const EgSectionLabel('Drug doses', '  Acute use'),
        _doseTable(context, 'Parenteral therapy', _parenteral),
        const SizedBox(height: 12),
        _doseTable(context, 'Enteral therapy', _enteral),

        const EgSectionLabel('Abbreviations', ''),
        const EgCard(
          child: EgBulletList(items: [
            'ACE — Angiotensin-Converting Enzyme',
            'IM — Intramuscular',
            'IV — Intravenous',
            'mCg — micrograms',
            'PO — by mouth',
            'SL — sublingual',
            'SNP — Sodium Nitroprusside',
            'CRRT — Continuous Renal Replacement Therapy',
          ]),
        ),

        // ── Antihypertensive Drugs (oral / chronic) ───────────────────
        const EgSectionLabel('Antihypertensive drugs',
            '  Long-term oral agents (per kg/day)'),
        const _OralDrugTable(),

        // ── Diuretics (chronic table from page 1) ─────────────────────
        const EgSectionLabel('Diuretics', '  Long-term'),
        const _DiureticTable(),

        // ── Pearls ────────────────────────────────────────────────────
        const EgPearl(
          title: 'Avoid SL nifedipine in <2 yr — research add-on',
          body:
              'Sublingual / "bite-and-swallow" nifedipine can cause '
              'precipitous BP drop and stroke in younger children. AAP '
              '2017 BP guideline reserves it for children > 2 yr where IV '
              'access is delayed. Safer alternative in infants is '
              'oral isradipine 0.05–0.1 mg/kg.',
        ),
        const EgPearl(
          icon: Icons.report_outlined,
          title: 'Sodium nitroprusside cyanide caution',
          body:
              'Maximum recommended dose 10 mCg/kg/min for ≤ 10 min; for '
              'longer use, stay ≤ 4 mCg/kg/min. Monitor lactate, mixed '
              'venous saturation and acid-base. Co-infuse sodium '
              'thiosulphate in renal failure or prolonged use to scavenge '
              'cyanide.',
        ),

        const EgReferenceCard(
          text:
              'Hypertensive '
              'Emergency flowchart + Antihypertensive Drugs tables. '
              'Research add-ons draw on the AAP Clinical Practice '
              'Guideline for Screening and Management of High Blood Pressure '
              'in Children and Adolescents (2017) and the ESH 2022 '
              'paediatric hypertension consensus. For use by qualified '
              'clinicians only.',
        ),
      ],
    );
  }
}

// ── Long-term oral antihypertensive agents (page 2 of source) ───────────────
class _OralRow {
  final String klass;
  final String drug;
  final String initial;
  final String max;
  final String divided;
  const _OralRow(this.klass, this.drug, this.initial, this.max, this.divided);
}

const List<_OralRow> _oralRows = [
  _OralRow('Vasodilators', 'Hydralazine', '1–2 mg', '5–8 mg', '3–4'),
  _OralRow('Vasodilators', 'Minoxidil', '0.1–0.2 mg', '1 mg', '1–2'),
  _OralRow('Vasodilators', 'Prazosin', '50–100 µg', '500 µg', '2–3'),
  _OralRow('Central α-agonist', 'Clonidine', '5–7 µg', '25 µg', '3'),
  _OralRow('Adrenergic blockers', 'Atenolol', '1 mg', '2 mg', '1'),
  _OralRow('Adrenergic blockers', 'Propranolol', '1–2 mg', '4 mg', '3'),
  _OralRow('Adrenergic blockers', 'Metoprolol', '1–2 mg', '6 mg', '2'),
  _OralRow('Adrenergic blockers', 'Labetalol', '1–3 mg', '10–12 mg', '2'),
  _OralRow('Adrenergic blockers', 'Phenoxybenzamine', '0.2 mg', '1–2 mg', '2'),
  _OralRow('Calcium channel blockers', 'Nifedipine (slow release)',
      '0.25 mg', '3 mg', '1–2'),
  _OralRow(
      'Calcium channel blockers', 'Amlodepine', '0.05–0.2 mg', '0.6 mg', '1–2'),
  _OralRow('ACE inhibitors', 'Captopril', '0.3 mg', '5 mg', '3'),
  _OralRow('ACE inhibitors', 'Enalapril', '0.1 mg', '0.5–1 mg', '1–2'),
  _OralRow('ACE inhibitors', 'Lisinopril', '0.05 mg', '0.6 mg', '1'),
  _OralRow('ACE inhibitors', 'Ramipril', '5–6 mg/m² per day', '—', '—'),
  _OralRow('ARBs', 'Losartan', '0.5–0.6 mg', '1 mg', '1'),
  _OralRow('ARBs', 'Irbesartan (6–12 yr)', '75–150 mg/day', '—', '1'),
  _OralRow('ARBs', 'Irbesartan (≥ 13 yr)', '150–300 mg/day', '—', '1'),
  _OralRow('ARBs', 'Valsartan (> 6 yr)', '1.3 mg', '2.7 mg', '1'),
];

class _OralDrugTable extends StatelessWidget {
  const _OralDrugTable();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    String? lastClass;
    final rows = <Widget>[];
    for (int i = 0; i < _oralRows.length; i++) {
      final r = _oralRows[i];
      if (r.klass != lastClass) {
        rows.add(Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
          color: emergencyBrand.withValues(alpha: 0.10),
          child: Text(r.klass.toUpperCase(),
              style: const TextStyle(
                color: emergencyBrand,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              )),
        ));
        lastClass = r.klass;
      }
      rows.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          border: Border(
            bottom:
                BorderSide(color: cs.onSurface.withValues(alpha: 0.06)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Text(r.drug,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  )),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 4,
              child: Text(r.initial,
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.85),
                    fontSize: 12,
                  )),
            ),
            Expanded(
              flex: 3,
              child: Text(r.max,
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.85),
                    fontSize: 12,
                  )),
            ),
            Expanded(
              flex: 2,
              child: Text(r.divided,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.85),
                    fontSize: 12,
                  )),
            ),
          ],
        ),
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: cs.onSurface.withValues(alpha: 0.10)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
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
                      flex: 5,
                      child: Text('Drug',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4))),
                  Expanded(
                      flex: 4,
                      child: Text('Initial dose',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800))),
                  Expanded(
                      flex: 3,
                      child: Text('Max dose',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800))),
                  Expanded(
                      flex: 2,
                      child: Text('Doses',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800))),
                ],
              ),
            ),
            ...rows,
          ],
        ),
      ),
    );
  }
}

// ── Diuretics table (long-term, page 1 of source) ───────────────────────────
class _DiureticRow {
  final String drug;
  final String dose;
  final String freq;
  const _DiureticRow(this.drug, this.dose, this.freq);
}

const List<_DiureticRow> _diuretics = [
  _DiureticRow('Amiloride', '0.2–0.6', '24 h, po'),
  _DiureticRow('Bumetanide', '0.01–0.02; max 0.3', '12–24 h, po'),
  _DiureticRow('Chlorthalidone', '0.25–2', '24 h, po'),
  _DiureticRow('Hydrochlorothiazide', '1–4; max 100 mg', '12–24 h, po'),
  _DiureticRow('Frusemide',
      '1–2; max 8–10. IV infusion bolus 1–2 mg/kg, then @ 0.1–1 mg/kg/h',
      '6–12 h po/IV; 24 h infusion'),
  _DiureticRow('Metolazone', '0.1–0.4', '12–24 h, po'),
  _DiureticRow('Spironolactone', '1–3; 30–90 mg/m²', '12–24 h, po'),
  _DiureticRow('Triamterene', '2–4; max 6; 120 mg/m²', '8–12 h, po'),
];

class _DiureticTable extends StatelessWidget {
  const _DiureticTable();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: cs.onSurface.withValues(alpha: 0.10)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
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
                      flex: 5,
                      child: Text('Drug',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4))),
                  Expanded(
                      flex: 5,
                      child: Text('Dose (mg/kg/day)',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800))),
                  Expanded(
                      flex: 4,
                      child: Text('Frequency, route',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800))),
                ],
              ),
            ),
            ..._diuretics.asMap().entries.map((e) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: e.key.isEven
                        ? cs.onSurface.withValues(alpha: 0.025)
                        : null,
                    border: Border(
                      bottom: BorderSide(
                          color: cs.onSurface.withValues(alpha: 0.06)),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text(e.value.drug,
                            style: TextStyle(
                              color: cs.onSurface,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(e.value.dose,
                            style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.85),
                              fontSize: 12,
                              height: 1.4,
                            )),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(e.value.freq,
                            style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.85),
                              fontSize: 12,
                              height: 1.4,
                            )),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
