// =============================================================================
// screens/rabies/rabies_reference_view.dart — the CHART view
//
// Everything at once, for reading rather than being led. The smart view asks
// questions and narrows to one answer; this shows the whole protocol, both
// sources side by side, and every table.
//
// The two views exist because they serve different moments. Mid-consultation
// with a crying child, a clinician wants the smart view. Preparing, teaching,
// or checking a decision afterwards, they want this one — and a tool that
// offers only the wizard forces them to pretend to be a patient to read a
// table they already know exists.
// =============================================================================

import 'package:flutter/material.dart';

import 'rabies_protocol.dart';
import 'rabies_widgets.dart';

class RabiesReferenceView extends StatelessWidget {
  final String query;
  const RabiesReferenceView({super.key, this.query = ''});

  /// Whether a section matches the module search.
  bool _hit(String haystack) =>
      query.isEmpty || haystack.toLowerCase().contains(query.toLowerCase());

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final sections = <Widget>[
      if (_hit('category exposure classification I II III touching licking '
          'nibbling scratch bite transdermal mucous membrane'))
        _categories(cs),
      if (_hit('wound washing soap water antiseptic povidone iodine suture '
          'tetanus antibiotics first aid'))
        _woundCare(cs),
      if (_hit('reference table summary vaccine rig category previously '
          'immunised immunocompromised'))
        _summaryTable(cs),
      if (_hit('vaccine schedule intradermal intramuscular ID IM days 0 3 7 '
          '14 28 route deltoid thigh gluteal site'))
        _schedules(cs),
      if (_hit('rig rmab hrig erig immunoglobulin monoclonal dose iu/kg '
          'infiltration window day 7'))
        _rigSection(cs),
      if (_hit('children paediatric age weight dose site thigh deltoid '
          'gluteal minimum age'))
        _paediatric(cs),
      if (_hit('special situations pregnancy delayed dose repeat exposure '
          'multiple wounds nerve covid animal observation immunocompromised'))
        _special(cs),
      if (_hit('guideline comparison iap ncdc nrcp who difference conflict '
          'source'))
        _comparison(cs),
      if (_hit('warning danger fatal do not gluteal delay'))
        _warnings(cs),
      if (_hit('prep pre-exposure prophylaxis booster serology'))
        _prep(cs),
      if (_hit('reference source citation iap ncdc who further reading'))
        _references(cs),
    ];

    if (sections.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text('Nothing in this module matches “$query”.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, color: cs.onSurface.withValues(alpha: 0.6))),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
      children: [...sections, const RabiesDisclaimer()],
    );
  }

  // ── Categories ─────────────────────────────────────────────────────────
  Widget _categories(ColorScheme cs) => RabiesCard(
        title: 'Exposure categories',
        icon: Icons.category_outlined,
        subtitle: 'IAP 2022 and NRCP define these identically',
        child: Column(
          children: [
            for (final c in [
              ExposureCategory.categoryI,
              ExposureCategory.categoryII,
              ExposureCategory.categoryIII,
            ])
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: categoryColor(c).withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                      color: categoryColor(c).withValues(alpha: 0.45),
                      // Category III carries the most consequence, so it also
                      // carries the most visual weight.
                      width: c == ExposureCategory.categoryIII ? 1.6 : 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CategoryBadge(c),
                        const SizedBox(width: 9),
                        Text(c.severity,
                            style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface.withValues(alpha: 0.6))),
                      ],
                    ),
                    const SizedBox(height: 9),
                    for (final d in kCategoryDefinitions[c]!)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('• $d',
                            style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: cs.onSurface.withValues(alpha: 0.88))),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      switch (c) {
                        ExposureCategory.categoryI =>
                          'No prophylaxis needed — but only if a reliable '
                              'contact history is available.',
                        ExposureCategory.categoryII =>
                          'Wound treatment + rabies vaccine. RIG is not '
                              'indicated in an immunocompetent, previously '
                              'unimmunised patient.',
                        ExposureCategory.categoryIII =>
                          'Wound treatment + rabies vaccine + RIG/RMAb '
                              'infiltrated into and around the wounds.',
                        ExposureCategory.uncertain => '',
                      },
                      style: TextStyle(
                          fontSize: 12.5,
                          height: 1.45,
                          fontWeight: FontWeight.w700,
                          color: categoryColor(c)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );

  // ── Wound care ─────────────────────────────────────────────────────────
  Widget _woundCare(ColorScheme cs) => RabiesCard(
        title: 'Immediate wound management',
        icon: Icons.water_drop_outlined,
        accent: kCatIIIRed,
        subtitle: 'Before any decision about vaccine',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SourcedLine(kWoundCareHeadline,
                icon: Icons.trending_down, iconColor: kOkGreen),
            const Divider(height: 22),
            for (final s in kWoundCareSteps) SourcedLine(s),
            const SizedBox(height: 4),
            Text(
              'Assess separately whether tetanus prophylaxis, antibiotics or '
              'surgical review are needed. Not every animal bite needs '
              'antibiotics — weigh wound location, depth, contamination, '
              'delayed presentation, crush injury and immune status.',
              style: TextStyle(
                  fontSize: 12.5,
                  height: 1.45,
                  color: cs.onSurface.withValues(alpha: 0.78)),
            ),
          ],
        ),
      );

  // ── Summary table ──────────────────────────────────────────────────────
  Widget _summaryTable(ColorScheme cs) => RabiesCard(
        title: 'At a glance',
        icon: Icons.table_chart_outlined,
        subtitle: 'Footnotes matter — read them',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScrollableTable(
              child: DataTable(
                columnSpacing: 22,
                headingRowHeight: 40,
                dataRowMinHeight: 44,
                dataRowMaxHeight: 68,
                columns: const [
                  DataColumn(label: Text('Situation', style: _th)),
                  DataColumn(label: Text('Vaccine', style: _th)),
                  DataColumn(label: Text('RIG / RMAb', style: _th)),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Category I', style: _td)),
                    DataCell(Text('No', style: _td)),
                    DataCell(Text('No', style: _td)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Category II, not previously\nimmunised',
                        style: _td)),
                    DataCell(Text('Yes', style: _td)),
                    DataCell(Text('No *', style: _td)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Category III, not previously\nimmunised',
                        style: _td)),
                    DataCell(Text('Yes', style: _td)),
                    DataCell(Text('Yes', style: _tdBold)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Previously immunised,\ndocumented', style: _td)),
                    DataCell(Text('2 doses,\nday 0 + 3', style: _td)),
                    DataCell(Text('No †', style: _td)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Immunocompromised,\nCategory II or III',
                        style: _tdBold)),
                    DataCell(Text('Full course,\nIM route', style: _tdBold)),
                    DataCell(Text('Yes ‡', style: _tdBold)),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _footnote(cs, '*',
                'Except in an immunocompromised patient, where RIG/RMAb IS '
                'indicated in Category II.'),
            _footnote(cs, '†',
                'Where direct nerve exposure is suspected, the treating '
                'physician may consider RIG infiltration. A clinician '
                'decision, not routine treatment.'),
            _footnote(cs, '‡',
                'Local infiltration of RIG in both Category II and Category '
                'III, followed by the complete vaccine course by the '
                'intramuscular route.'),
          ],
        ),
      );

  Widget _footnote(ColorScheme cs, String marker, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 16,
              child: Text(marker,
                  style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface.withValues(alpha: 0.7))),
            ),
            Expanded(
              child: Text(text,
                  style: TextStyle(
                      fontSize: 11.8,
                      height: 1.45,
                      color: cs.onSurface.withValues(alpha: 0.72))),
            ),
          ],
        ),
      );

  // ── Schedules ──────────────────────────────────────────────────────────
  Widget _schedules(ColorScheme cs) => RabiesCard(
        title: 'Vaccine schedules',
        icon: Icons.event_note_outlined,
        subtitle: 'Both sources, both routes',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final source in [GuidelineSource.ncdcNrcp, GuidelineSource.iap2022]) ...[
              Row(children: [
                SourceChip(source),
                const SizedBox(width: 8),
                // Flexible, not bare: at 375 px this row overflowed by 26 px
                // and clipped the label off the right edge.
                Flexible(
                  child: Text(
                      source == GuidelineSource.ncdcNrcp
                          ? 'National protocol'
                          : 'Paediatric guideline',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface.withValues(alpha: 0.6))),
                ),
              ]),
              const SizedBox(height: 9),
              for (final s in kAllSchedules.where((s) => s.source == source))
                Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(alpha: 0.13),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(s.route.shortLabel,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    color: cs.primary)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(s.label,
                                style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: cs.onSurface)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text('Day ${s.daysLabel}   ·   ${s.doseCount} doses',
                          style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.3,
                              color: cs.onSurface)),
                      const SizedBox(height: 4),
                      Text(s.dosePerSite,
                          style: TextStyle(
                              fontSize: 12,
                              color: cs.onSurface.withValues(alpha: 0.75))),
                      if (s.note != null) ...[
                        const SizedBox(height: 5),
                        Text(s.note!,
                            style: TextStyle(
                                fontSize: 11.5,
                                height: 1.4,
                                fontStyle: FontStyle.italic,
                                color: cs.onSurface.withValues(alpha: 0.65))),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 8),
            ],
            const Divider(height: 20),
            Text('Injection site',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface)),
            const SizedBox(height: 9),
            for (final s in kInjectionSiteRules)
              SourcedLine(s,
                  icon: s.text.contains('NOT')
                      ? Icons.block
                      : Icons.place_outlined,
                  iconColor: s.text.contains('NOT') ? kCatIIIRed : null),
          ],
        ),
      );

  // ── RIG / RMAb ─────────────────────────────────────────────────────────
  Widget _rigSection(ColorScheme cs) => RabiesCard(
        title: 'RIG & RMAb',
        icon: Icons.vaccines_outlined,
        accent: kCatIIIRed,
        subtitle: 'Dose, product potency and where it goes',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScrollableTable(
              child: DataTable(
                columnSpacing: 18,
                headingRowHeight: 40,
                dataRowMinHeight: 42,
                dataRowMaxHeight: 62,
                columns: const [
                  DataColumn(label: Text('Agent', style: _th)),
                  DataColumn(label: Text('Dose', style: _th)),
                  DataColumn(label: Text('Potency', style: _th)),
                  DataColumn(label: Text('Skin test', style: _th)),
                ],
                rows: [
                  for (final a in kPassiveAgents)
                    DataRow(cells: [
                      DataCell(SizedBox(
                          width: 140,
                          child: Text(a.label, style: _td))),
                      DataCell(Text('${a.iuPerKg} IU/kg', style: _tdBold)),
                      DataCell(Text(
                          a.concentrationIuPerMl == null
                              ? 'Per product'
                              : '${a.concentrationIuPerMl!.toStringAsFixed(0)} IU/mL',
                          style: _td)),
                      DataCell(SizedBox(
                        width: 120,
                        child: Text(
                            (a.skinTest ?? '').contains('No') ? 'No' : 'Yes',
                            style: _td),
                      )),
                    ]),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: kCatIIAmber.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: kCatIIAmber.withValues(alpha: 0.4)),
              ),
              child: const Text(
                'Potencies above are the ones the guideline prints. Always use '
                'the product-specific prescribing information and current '
                'institutional or national guidance for concentration and '
                'administration — a wrong concentration is a wrong dose.',
                style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                    color: kCatIIAmber),
              ),
            ),
            const Divider(height: 24),
            Text('Administration',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface)),
            const SizedBox(height: 9),
            for (final s in kRigAdministrationSteps) SourcedLine(s),
            const SizedBox(height: 4),
            _rigTimeline(cs),
            const SizedBox(height: 10),
            SourcedLine(kWhoRmabPreference, icon: Icons.public),
          ],
        ),
      );

  /// The window, drawn rather than described — the day-7 cut-off is the thing
  /// most often missed, and a line with a stop on it is harder to skim past
  /// than a sentence.
  Widget _rigTimeline(ColorScheme cs) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kCatIIIRed.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kCatIIIRed.withValues(alpha: 0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('THE RIG WINDOW',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                    color: kCatIIIRed)),
            const SizedBox(height: 10),
            Row(
              children: [
                _tick(cs, 'Day 0', 'First vaccine dose\n+ RIG/RMAb now', true),
                Expanded(
                  child: Container(
                      height: 2,
                      color: kCatIIIRed.withValues(alpha: 0.35)),
                ),
                _tick(cs, 'Day 7', 'Window CLOSES', false),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Do not give RIG beyond the 7th day after the first vaccine '
              'dose. Give it as early as possible — the sooner, the better.',
              style: TextStyle(
                  fontSize: 12,
                  height: 1.45,
                  fontWeight: FontWeight.w700,
                  color: kCatIIIRed),
            ),
          ],
        ),
      );

  Widget _tick(ColorScheme cs, String day, String label, bool open) => SizedBox(
        width: 110,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(open ? Icons.play_circle_fill : Icons.stop_circle,
                    size: 16, color: kCatIIIRed),
                const SizedBox(width: 5),
                Text(day,
                    style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                        color: kCatIIIRed)),
              ],
            ),
            const SizedBox(height: 3),
            Text(label,
                style: TextStyle(
                    fontSize: 10.5,
                    height: 1.35,
                    color: cs.onSurface.withValues(alpha: 0.72))),
          ],
        ),
      );

  // ── Paediatric ─────────────────────────────────────────────────────────
  Widget _paediatric(ColorScheme cs) => RabiesCard(
        title: 'Children: what is different',
        icon: Icons.child_care_outlined,
        subtitle: 'Mostly: less than people assume',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final p in kPaediatricPoints) SourcedLine(p),
          ],
        ),
      );

  // ── Special situations ─────────────────────────────────────────────────
  Widget _special(ColorScheme cs) => RabiesCard(
        title: 'Special situations',
        icon: Icons.alt_route_outlined,
        collapsible: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final s in kSpecialSituations)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: warningColor(s.level).withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: warningColor(s.level).withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(s.title,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: warningColor(s.level))),
                        ),
                        SourceChip(s.source, dense: true),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(s.body,
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

  // ── Guideline comparison ───────────────────────────────────────────────
  Widget _comparison(ColorScheme cs) => RabiesCard(
        title: 'IAP 2022 vs NCDC / NRCP',
        icon: Icons.compare_arrows,
        subtitle: 'Neither is wrong — they are different documents',
        collapsible: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rows marked with a flag are where the two give genuinely '
              'different ACTIONS, not just different wording. Those are the '
              'ones to check against local policy before deciding.',
              style: TextStyle(
                  fontSize: 12,
                  height: 1.45,
                  color: cs.onSurface.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 12),
            for (final d in kGuidelineDifferences)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: d.material
                      ? kCatIIAmber.withValues(alpha: 0.07)
                      : cs.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: d.material
                      ? Border.all(color: kCatIIAmber.withValues(alpha: 0.45))
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (d.material) ...[
                          const Icon(Icons.flag, size: 14, color: kCatIIAmber),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(d.topic,
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: d.material
                                      ? kCatIIAmber
                                      : cs.onSurface)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _compareRow(cs, GuidelineSource.iap2022, d.iap),
                    const SizedBox(height: 6),
                    _compareRow(cs, GuidelineSource.ncdcNrcp, d.ncdc),
                  ],
                ),
              ),
          ],
        ),
      );

  Widget _compareRow(ColorScheme cs, GuidelineSource s, String text) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SourceChip(s, dense: true),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: cs.onSurface.withValues(alpha: 0.85))),
          ),
        ],
      );

  // ── Warnings ───────────────────────────────────────────────────────────
  Widget _warnings(ColorScheme cs) => RabiesCard(
        title: 'Clinical warnings',
        icon: Icons.report_problem_outlined,
        accent: kCatIIIRed,
        child: Column(
          children: [for (final w in kStandingWarnings) WarningBox(w)],
        ),
      );

  // ── PrEP ───────────────────────────────────────────────────────────────
  Widget _prep(ColorScheme cs) => RabiesCard(
        title: 'Pre-exposure prophylaxis',
        icon: Icons.shield_outlined,
        collapsible: true,
        initiallyExpanded: false,
        subtitle: 'IAP: offer it to all children in an endemic country',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final s in kPrEPSchedules)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${s.route.shortLabel} — day ${s.daysLabel}',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface)),
                    if (s.note != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(s.note!,
                            style: TextStyle(
                                fontSize: 12,
                                height: 1.4,
                                color: cs.onSurface.withValues(alpha: 0.75))),
                      ),
                  ],
                ),
              ),
            const SourcedLine(Sourced(
              'Pre-exposure prophylaxis makes administration of RIG '
              'unnecessary after a bite.',
              GuidelineSource.iap2022,
            )),
          ],
        ),
      );

  // ── References ─────────────────────────────────────────────────────────
  Widget _references(ColorScheme cs) => RabiesCard(
        title: 'References',
        icon: Icons.menu_book_outlined,
        subtitle: 'Checked on '
            '${rabiesVerifiedOn.day}/${rabiesVerifiedOn.month}/${rabiesVerifiedOn.year}',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final s in GuidelineSource.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SourceChip(s),
                    const SizedBox(height: 6),
                    Text(s.fullName,
                        style: TextStyle(
                            fontSize: 12.5,
                            height: 1.5,
                            color: cs.onSurface.withValues(alpha: 0.85))),
                    if (s.url != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(s.url!,
                            style: TextStyle(
                                fontSize: 11,
                                height: 1.4,
                                color: sourceColor(s))),
                      ),
                  ],
                ),
              ),
            const Divider(height: 18),
            Text(
              'Values in this module were transcribed from these documents, '
              'not recalled. Where the two Indian sources differ, both are '
              'shown and attributed rather than merged.',
              style: TextStyle(
                  fontSize: 11.5,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                  color: cs.onSurface.withValues(alpha: 0.65)),
            ),
          ],
        ),
      );
}

const _th = TextStyle(fontSize: 12, fontWeight: FontWeight.w800);
const _td = TextStyle(fontSize: 12, height: 1.35);
const _tdBold = TextStyle(fontSize: 12, height: 1.35, fontWeight: FontWeight.w800);
