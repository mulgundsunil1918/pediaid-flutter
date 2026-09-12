// =============================================================================
// screens/rabies/rabies_assess_view.dart — the SMART view
//
// Tap the findings, get the recommendation. The counterpart is the chart view,
// which shows the whole protocol at once for someone who wants to read rather
// than be led.
//
// Two deliberate choices:
//
// The result is LIVE, not behind a "calculate" button. A clinician changing
// "unsure" to "yes" on broken skin should see Category II become Category III
// as they tap it — that is the teaching moment, and burying it behind a submit
// step wastes it.
//
// The result panel leads with what is MISSING when anything is missing. An
// incomplete answer presented as a recommendation is worse than no answer,
// because it looks finished.
// =============================================================================

import 'package:flutter/material.dart';

import 'rabies_engine.dart';
import 'rabies_protocol.dart';
import 'rabies_rig.dart';
import 'rabies_tracker.dart';
import 'rabies_widgets.dart';

class RabiesAssessView extends StatefulWidget {
  const RabiesAssessView({super.key});

  @override
  State<RabiesAssessView> createState() => _RabiesAssessViewState();
}

class _RabiesAssessViewState extends State<RabiesAssessView> {
  RabiesAssessment _a = const RabiesAssessment();
  final _weightCtl = TextEditingController();
  DateTime? _firstDoseDate;

  @override
  void dispose() {
    _weightCtl.dispose();
    super.dispose();
  }

  Tri _tri(int i) => switch (i) { 0 => Tri.yes, 1 => Tri.no, _ => Tri.unsure };
  int _triIndex(Tri t) => switch (t) { Tri.yes => 0, Tri.no => 1, Tri.unsure => 2 };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final a = _a.copyWith(source: GuidelineSource.ncdcNrcp);
    final r = evaluateRabies(a);

    // Desktop gets the assessment on the left and a live result on the right;
    // a phone stacks them with the result pinned to the bottom.
    final wide = MediaQuery.sizeOf(context).width >= 900;

    final form = ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
      children: [
        _woundFirstCard(cs),
        _contactCard(cs, a),
        _historyCard(cs, a),
        _weightRouteCard(cs, a),
        if (!wide) const SizedBox(height: 8),
        if (!wide) _resultPanel(cs, a, r),
        const SizedBox(height: 6),
        // Not on the poster, and worth keeping: the branches a one-page
        // algorithm cannot show without becoming unreadable.
        _paediatricCard(cs),
        _specialCard(cs),
        const RabiesDisclaimer(),
      ],
    );

    if (!wide) return form;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: form),
        Container(width: 1, color: cs.outlineVariant.withValues(alpha: 0.6)),
        Expanded(
          flex: 4,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
            children: [_resultPanel(cs, a, r), const RabiesDisclaimer()],
          ),
        ),
      ],
    );
  }

  // ── Wound care, first ──────────────────────────────────────────────────
  //
  // Above the assessment, not below it. Washing is the highest-yield act in
  // the whole pathway — IAP puts the risk reduction at almost 50% — it is free,
  // it needs nothing to be arranged, and it must not wait for the category to
  // be settled. Putting it after the questions would imply it does.
  Widget _woundFirstCard(ColorScheme cs) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kCatIIIRed.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kCatIIIRed.withValues(alpha: 0.5), width: 1.4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.water_drop_outlined, color: kCatIIIRed, size: 20),
                const SizedBox(width: 9),
                const Expanded(
                  child: Text('FIRST: WASH THE WOUND',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: kCatIIIRed,
                          letterSpacing: 0.3)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Soap or detergent and copious running water, 10–15 minutes '
              '(NRCP: at least 15 minutes), irrespective of exposure category. '
              'Do not delay washing while vaccination is arranged.',
              style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface.withValues(alpha: 0.88)),
            ),
            const SizedBox(height: 10),
            SourcedLine(kWoundCareHeadline,
                icon: Icons.trending_down, iconColor: kOkGreen),
          ],
        ),
      );

  // ── Exposure ───────────────────────────────────────────────────────────
  Widget _contactCard(ColorScheme cs, RabiesAssessment a) {
    final derived = deriveCategory(a);
    return RabiesCard(
      title: 'Exposure',
      icon: Icons.pets_outlined,
      subtitle: 'What happened, and to what depth',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Animal involved',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface.withValues(alpha: 0.85))),
          const SizedBox(height: 7),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final animal in kAnimals)
                SelectChip(
                  label: animal,
                  selected: _a.animal == animal,
                  onTap: () => setState(() => _a = _a.copyWith(animal: animal)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Stated plainly, because "it was only the family dog" is the most
          // common reason a genuine Category III gets under-treated.
          Text(
            'Species is recorded for the notes. It does not change the '
            'category or the recommendation — no guideline grades exposure by '
            'animal.',
            style: TextStyle(
                fontSize: 11.5,
                height: 1.4,
                fontStyle: FontStyle.italic,
                color: cs.onSurface.withValues(alpha: 0.6)),
          ),
          const Divider(height: 26),
          Text('Nature of contact — select all that apply',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface.withValues(alpha: 0.85))),
          const SizedBox(height: 8),
          Column(
            children: [
              for (final c in kContactTypes)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: SelectChip(
                      label: c.label,
                      accent: categoryColor(c.category),
                      selected: _a.contactTypeIds.contains(c.id),
                      onTap: () => setState(() {
                        final next = Set<String>.from(_a.contactTypeIds);
                        next.contains(c.id) ? next.remove(c.id) : next.add(c.id);
                        _a = _a.copyWith(contactTypeIds: next);
                      }),
                    ),
                  ),
                ),
            ],
          ),
          const Divider(height: 26),
          TriSelector(
            label: 'Was the skin broken?',
            value: _triIndex(_a.skinBroken),
            onChanged: (i) =>
                setState(() => _a = _a.copyWith(skinBroken: _tri(i))),
          ),
          TriSelector(
            label: 'Was there bleeding?',
            value: _triIndex(_a.bleeding),
            onChanged: (i) => setState(() => _a = _a.copyWith(bleeding: _tri(i))),
          ),
          TriSelector(
            label: 'Is the contact history reliable?',
            value: _triIndex(_a.reliableHistory),
            onChanged: (i) =>
                setState(() => _a = _a.copyWith(reliableHistory: _tri(i))),
          ),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: categoryColor(derived.category).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                CategoryBadge(derived.category),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(derived.reason,
                      style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: cs.onSurface.withValues(alpha: 0.8))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── History ────────────────────────────────────────────────────────────
  Widget _historyCard(ColorScheme cs, RabiesAssessment a) => RabiesCard(
        title: 'Previous vaccination & immune status',
        icon: Icons.vaccines_outlined,
        subtitle: 'Both change the pathway, not just the dose count',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Previous rabies vaccination',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface.withValues(alpha: 0.85))),
            const SizedBox(height: 8),
            for (final s in ImmunisationStatus.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: SelectChip(
                    label: s.label,
                    selected: _a.immunisationStatus == s,
                    onTap: () =>
                        setState(() => _a = _a.copyWith(immunisationStatus: s)),
                  ),
                ),
              ),
            if (_a.immunisationStatus == ImmunisationStatus.completedPEP) ...[
              const SizedBox(height: 4),
              Text('Days since that PEP course was completed',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface.withValues(alpha: 0.85))),
              const SizedBox(height: 7),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final d in const [30, 60, 89, 120, 365])
                    SelectChip(
                      label: d < 90 ? '$d days' : '$d days',
                      selected: _a.daysSincePreviousPep == d,
                      onTap: () => setState(
                          () => _a = _a.copyWith(daysSincePreviousPep: d)),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // This is the one place the two Indian sources give different
              // ACTIONS, so it is called out where it is entered.
              Text(
                'NRCP: for Category II and III, a repeat exposure is treated '
                'as previously immunised — 2 doses on days 0 and 3 — whenever '
                'it occurs.',
                style: TextStyle(
                    fontSize: 11.5,
                    height: 1.4,
                    fontStyle: FontStyle.italic,
                    color: cs.onSurface.withValues(alpha: 0.65)),
              ),
            ],
            const Divider(height: 26),
            Text('Immune status',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface.withValues(alpha: 0.85))),
            const SizedBox(height: 8),
            for (final s in ImmuneStatus.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: SelectChip(
                    label: s.label,
                    accent: s == ImmuneStatus.immunocompromised
                        ? kCatIIIRed
                        : null,
                    selected: _a.immuneStatus == s,
                    onTap: () => setState(() => _a = _a.copyWith(immuneStatus: s)),
                  ),
                ),
              ),
          ],
        ),
      );

  // ── Weight and route ───────────────────────────────────────────────────
  Widget _weightRouteCard(ColorScheme cs, RabiesAssessment a) => RabiesCard(
        title: 'Weight & route',
        icon: Icons.monitor_weight_outlined,
        subtitle: 'Weight is needed for RIG/RMAb; the vaccine dose is not '
            'reduced for children',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _weightCtl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Current weight',
                suffixText: 'kg',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) {
                final w = double.tryParse(v.trim());
                setState(() => _a = w == null
                    ? _a.copyWith(clearWeight: true)
                    : _a.copyWith(weightKg: w));
              },
            ),
            const SizedBox(height: 16),
            Text('Vaccine route',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface.withValues(alpha: 0.85))),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final route in VaccineRoute.values) ...[
                  if (route != VaccineRoute.values.first)
                    const SizedBox(width: 8),
                  Expanded(
                    child: SelectChip(
                      label: route.label,
                      selected: _a.preferredRoute == route,
                      onTap: () =>
                          setState(() => _a = _a.copyWith(preferredRoute: route)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      );

  Widget _paediatricCard(ColorScheme cs) => RabiesCard(
        title: 'Children: what is different',
        icon: Icons.child_care_outlined,
        collapsible: true,
        initiallyExpanded: false,
        subtitle: 'Less than most people assume',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [for (final p in kPaediatricPoints) SourcedLine(p)],
        ),
      );

  Widget _specialCard(ColorScheme cs) => RabiesCard(
        title: 'Special situations',
        icon: Icons.alt_route_outlined,
        collapsible: true,
        initiallyExpanded: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final sit in kSpecialSituations)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: warningColor(sit.level).withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: warningColor(sit.level).withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(sit.title,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: warningColor(sit.level))),
                        ),
                        SourceChip(sit.source, dense: true),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(sit.body,
                        style: TextStyle(
                            fontSize: 12.5,
                            height: 1.5,
                            color: cs.onSurface.withValues(alpha: 0.85))),
                  ],
                ),
              ),
          ],
        ),
      );

  // ── Result ─────────────────────────────────────────────────────────────
  Widget _resultPanel(
      ColorScheme cs, RabiesAssessment a, RabiesRecommendation r) {
    final undecided = !r.isDecided;
    final accent = undecided ? kCatIIIRed : categoryColor(r.category);

    return Container(
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.55), width: 1.5),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(undecided ? Icons.help_outline : Icons.assignment_turned_in_outlined,
                  size: 20, color: accent),
              const SizedBox(width: 9),
              Expanded(
                child: Text('RABIES PEP RECOMMENDATION',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        color: accent)),
              ),
              const SourceChip(GuidelineSource.ncdcNrcp),
            ],
          ),
          const SizedBox(height: 13),
          CategoryBadge(r.category, large: true),
          const SizedBox(height: 8),
          Text(r.categoryReason,
              style: TextStyle(
                  fontSize: 12.5,
                  height: 1.4,
                  color: cs.onSurface.withValues(alpha: 0.75))),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(r.pathway.label,
                style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: accent)),
          ),

          // What is missing comes BEFORE the recommendation. A half-finished
          // answer that looks finished is the failure mode here.
          if (r.missing.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: kCatIIAmber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: kCatIIAmber.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('STILL NEEDED',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.4,
                          color: kCatIIAmber)),
                  const SizedBox(height: 6),
                  for (final m in r.missing)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text('• $m',
                          style: const TextStyle(
                              fontSize: 12.5,
                              height: 1.4,
                              fontWeight: FontWeight.w600,
                              color: kCatIIAmber)),
                    ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 14),
          _resultRow(cs, 'Wound care',
              r.woundCareRequired ? 'IMMEDIATE WASHING REQUIRED' : '—',
              emphasis: r.woundCareRequired),
          _resultRow(cs, 'Rabies vaccine', r.vaccineRequired ? 'YES' : 'NO',
              emphasis: r.vaccineRequired),
          if (r.schedule != null) ...[
            _resultRow(cs, 'Route', r.schedule!.route.label),
            _resultRow(cs, 'Schedule', 'Day ${r.schedule!.daysLabel}',
                emphasis: true),
            _resultRow(cs, 'Per visit', r.schedule!.dosePerSite),
            if (r.schedule!.note != null)
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 8),
                child: Text(r.schedule!.note!,
                    style: TextStyle(
                        fontSize: 11.5,
                        height: 1.4,
                        fontStyle: FontStyle.italic,
                        color: cs.onSurface.withValues(alpha: 0.65))),
              ),
          ],
          _resultRow(cs, 'RIG / RMAb', r.rigRequired ? 'YES' : 'NO',
              emphasis: r.rigRequired,
              color: r.rigRequired ? kCatIIIRed : null),
          if (r.rigCaveat != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(r.rigCaveat!,
                  style: TextStyle(
                      fontSize: 11.5,
                      height: 1.45,
                      color: cs.onSurface.withValues(alpha: 0.72))),
            ),

          if (r.rigRequired) ...[
            const SizedBox(height: 6),
            _rigBlock(cs, a),
          ],

          if (r.instructions.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text('WHAT TO DO',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                    color: cs.onSurface.withValues(alpha: 0.55))),
            const SizedBox(height: 8),
            for (final i in r.instructions) SourcedLine(i),
          ],

          if (r.vaccineRequired && r.schedule != null) ...[
            const SizedBox(height: 6),
            _followUpBlock(cs, r.schedule!),
          ],

          if (r.warnings.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text('WARNINGS',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                    color: cs.onSurface.withValues(alpha: 0.55))),
            const SizedBox(height: 8),
            for (final w in r.warnings) WarningBox(w),
          ],
        ],
      ),
    );
  }

  Widget _resultRow(ColorScheme cs, String label, String value,
      {bool emphasis = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 108,
            child: Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface.withValues(alpha: 0.6))),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    fontSize: emphasis ? 14 : 13,
                    height: 1.35,
                    fontWeight: emphasis ? FontWeight.w800 : FontWeight.w600,
                    color: color ?? cs.onSurface)),
          ),
        ],
      ),
    );
  }

  Widget _rigBlock(ColorScheme cs, RabiesAssessment a) {
    final doses = calculateAllRig(weightKg: a.weightKg);
    final w = a.weightKg;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCatIIIRed.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kCatIIIRed.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            w == null
                ? 'RIG / RMAb DOSE — enter a weight'
                : 'RIG / RMAb DOSE for ${_trimW(w)} kg',
            style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.3,
                color: kCatIIIRed),
          ),
          const SizedBox(height: 9),
          for (final d in doses)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text('${d.agent.label}  ·  ${d.agent.iuPerKg} IU/kg',
                        style: TextStyle(
                            fontSize: 12,
                            height: 1.35,
                            color: cs.onSurface.withValues(alpha: 0.82))),
                  ),
                  const SizedBox(width: 8),
                  Text(d.iuLabel,
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                          color: d.isComplete
                              ? kCatIIIRed
                              : cs.onSurface.withValues(alpha: 0.4))),
                ],
              ),
            ),
          const SizedBox(height: 6),
          const Text(
            'LOCAL INFILTRATION INTO AND AROUND THE WOUNDS — not routine IM '
            'injection at a distant site.',
            style: TextStyle(
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w800,
                color: kCatIIIRed),
          ),
          const SizedBox(height: 6),
          SourcedLine(kRigWindowRationale,
              icon: Icons.schedule, iconColor: kCatIIIRed),
        ],
      ),
    );
  }

  Widget _followUpBlock(ColorScheme cs, VaccineSchedule schedule) {
    final start = _firstDoseDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Text('FOLLOW-UP',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                    color: cs.onSurface.withValues(alpha: 0.55))),
            const Spacer(),
            TextButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: start ?? DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 120)),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) setState(() => _firstDoseDate = picked);
              },
              icon: const Icon(Icons.event, size: 16),
              label: Text(start == null ? 'Set first dose date' : 'Change date',
                  style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
        if (start == null)
          Text(
            'Set the date of the first dose to get calendar dates for the '
            'remaining visits.',
            style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: cs.onSurface.withValues(alpha: 0.65)),
          )
        else ...[
          for (final v in buildCourse(schedule: schedule, firstDoseDate: start)
              .visits)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  SizedBox(
                    width: 62,
                    child: Text(v.label,
                        style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface.withValues(alpha: 0.8))),
                  ),
                  Expanded(
                    child: Text(formatDoseDate(v.dueDate),
                        style: TextStyle(
                            fontSize: 12.5,
                            color: cs.onSurface.withValues(alpha: 0.85))),
                  ),
                  Text('${v.sites} site${v.sites > 1 ? 's' : ''}',
                      style: TextStyle(
                          fontSize: 11.5,
                          color: cs.onSurface.withValues(alpha: 0.55))),
                ],
              ),
            ),
          const SizedBox(height: 6),
          const SourcedLine(
            Sourced(
              'If a dose is delayed, resume or continue the schedule — never '
              'restart it.',
              GuidelineSource.iap2022,
            ),
            icon: Icons.update,
          ),
        ],
      ],
    );
  }

  String _trimW(double v) {
    final s = v.toStringAsFixed(1);
    return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
  }
}
