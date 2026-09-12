// =============================================================================
// screens/rabies/rabies_algorithm_view.dart — the FLOW CHART view
//
// The NRCP poster, in the poster's own order: DECISION TO TREAT, then the
// POST EXPOSURE PROPHYLAXIS PROTOCOL, then RIG DOSAGE, then the references.
// Everything here is the national protocol. IAP lines appear only where they
// explain something the poster states without elaboration, and stay labelled.
//
// The NRCP poster as something you can use rather than squint at.
//
// WHY WIDGETS IN AN InteractiveViewer, NOT AN SVG OR AN IMAGE
// -----------------------------------------------------------
// The obvious implementation is to ship the government poster as a PNG. That
// fails the only test that matters here: on a phone the text is unreadable, and
// nothing is tappable. Hand-authored SVG would be readable but still inert, and
// would need its own hit-testing, focus handling and theme swapping.
//
// Laying the tree out as real widgets inside an InteractiveViewer gives pinch,
// pan and double-tap zoom for free, keeps every node a real button with a
// semantic label, and means the diagram inherits the app's light and dark
// palettes instead of being a photograph of a printed page.
//
// The "you are here" highlight exists because the tree's job is not only to
// show the algorithm but to show where THIS child sits in it.
// =============================================================================

import 'package:flutter/material.dart';

import 'rabies_protocol.dart';
import 'rabies_rig.dart';
import 'rabies_widgets.dart';

/// One node, and the detail panel it opens.
@immutable
class AlgoNode {
  final String id;
  final String title;
  final String? subtitle;
  final Color color;
  final List<Sourced> detail;

  const AlgoNode({
    required this.id,
    required this.title,
    required this.color,
    this.subtitle,
    this.detail = const [],
  });
}

class RabiesAlgorithmView extends StatefulWidget {
  /// The node to highlight, when the assessment has reached one.
  final String? highlightId;
  const RabiesAlgorithmView({super.key, this.highlightId});

  @override
  State<RabiesAlgorithmView> createState() => _RabiesAlgorithmViewState();
}

class _RabiesAlgorithmViewState extends State<RabiesAlgorithmView> {
  final _controller = TransformationController();
  final _weightCtl = TextEditingController();
  double? _weight;
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.highlightId;
  }

  @override
  void dispose() {
    _controller.dispose();
    _weightCtl.dispose();
    super.dispose();
  }

  void _reset() => setState(() => _controller.value = Matrix4.identity());

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Rabies PEP Decision Algorithm',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface),
              ),
            ),
            IconButton(
              tooltip: 'Reset view',
              onPressed: _reset,
              icon: const Icon(Icons.center_focus_strong_outlined, size: 20),
            ),
            IconButton(
              tooltip: 'Expand diagram',
              onPressed: () => _openFullScreen(context),
              icon: const Icon(Icons.open_in_full, size: 19),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Pinch or double-tap to zoom, drag to pan. Tap any box to read what '
            'it means.',
            style: TextStyle(
                fontSize: 11.5,
                height: 1.4,
                color: cs.onSurface.withValues(alpha: 0.6)),
          ),
        ),
        // A bordered, fixed-height box: the tree pans and zooms inside it, and
        // the page scrolls around it. Without the border the two gestures are
        // indistinguishable to the user.
        Container(
          height: 460,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: _viewer(
          cs),
        ),
        if (_selected != null) _detailPanel(cs),
        const SizedBox(height: 14),
        _rigDosage(cs),
        _paediatric(cs),
        _special(cs),
        _warnings(cs),
        _references(cs),
        const RabiesDisclaimer(),
      ],
    );
  }

  /// The zoomable tree.
  ///
  /// constrained: false so it keeps its natural HEIGHT and is panned to rather
  /// than squeezed into the box and clipped — it runs about 450 px taller than
  /// a phone screen. Width is still pinned so the diagram never needs
  /// horizontal panning just to be read at 1x.
  Widget _viewer(ColorScheme cs) => LayoutBuilder(
        builder: (context, constraints) {
          final treeWidth = (constraints.maxWidth - 32).clamp(280.0, 720.0);
          return InteractiveViewer(
            transformationController: _controller,
            minScale: 0.4,
            maxScale: 3.5,
            constrained: false,
            boundaryMargin: const EdgeInsets.all(120),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(width: treeWidth, child: _tree(cs)),
            ),
          );
        },
      );

  void _openFullScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Rabies PEP Decision Algorithm')),
          body: RabiesAlgorithmView(highlightId: _selected),
        ),
      ),
    );
  }

  // ── The tree ───────────────────────────────────────────────────────────
  //
  // A column of rows rather than absolute positions: it reflows for any
  // width, so the same diagram is legible on a 375 px phone and a desktop,
  // and never forces the page body to scroll sideways.
  Widget _tree(ColorScheme cs) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _node(_kExposure, wide: true),
            _arrow(cs),
            _node(_kWash, wide: true),
            _arrow(cs),
            _label(cs, 'ASSESS THE CONTACT'),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _node(_kCatI)),
                const SizedBox(width: 8),
                Expanded(child: _node(_kCatII)),
                const SizedBox(width: 8),
                Expanded(child: _node(_kCatIII)),
              ],
            ),
            _arrow(cs),
            _node(_kPrevImm, wide: true),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _node(_kNaive)),
                const SizedBox(width: 8),
                Expanded(child: _node(_kBoost)),
              ],
            ),
            _arrow(cs),
            _node(_kImmuno, wide: true),
            _arrow(cs),
            _node(_kRig, wide: true),
            _arrow(cs),
            _node(_kFollowUp, wide: true),
          ],
        );

  // ── RIG DOSAGE — the poster's third block ───────────────────────────────
  //
  // The weight field lives here rather than on its own screen because this is
  // where a clinician arrives already knowing RIG is indicated and wanting the
  // number. All four agents are shown at once: the choice is usually decided
  // by what is in the fridge, and the fifteen-fold potency gap between the two
  // monoclonals is safer seen than remembered.
  Widget _rigDosage(ColorScheme cs) => RabiesCard(
        title: 'Rabies immunoglobulin — RIG dosage',
        icon: Icons.vaccines_outlined,
        accent: kCatIIIRed,
        subtitle: 'HRIG 20 IU/kg  ·  ERIG 40 IU/kg',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _weightCtl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Weight',
                suffixText: 'kg',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _weight = double.tryParse(v.trim())),
            ),
            const SizedBox(height: 12),
            ScrollableTable(
              child: DataTable(
                columnSpacing: 18,
                headingRowHeight: 38,
                dataRowMinHeight: 40,
                dataRowMaxHeight: 58,
                columns: const [
                  DataColumn(label: Text('Agent', style: _th)),
                  DataColumn(label: Text('IU/kg', style: _th)),
                  DataColumn(label: Text('Dose', style: _th)),
                  DataColumn(label: Text('Volume', style: _th)),
                ],
                rows: [
                  for (final d in calculateAllRig(weightKg: _weight))
                    DataRow(cells: [
                      DataCell(SizedBox(
                          width: 130, child: Text(d.agent.label, style: _td))),
                      DataCell(Text('${d.agent.iuPerKg}', style: _td)),
                      DataCell(Text(d.iuLabel, style: _tdBold)),
                      DataCell(Text(d.volumeLabel, style: _td)),
                    ]),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: kCatIIIRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: kCatIIIRed.withValues(alpha: 0.5)),
              ),
              child: const Text(
                'RIG IS FOR LOCAL WOUND INFILTRATION — NOT ROUTINE IM '
                'INJECTION AT A DISTANT SITE.',
                style: TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    fontWeight: FontWeight.w900,
                    color: kCatIIIRed),
              ),
            ),
            const SizedBox(height: 12),
            for (final s in kRigAdministrationSteps) SourcedLine(s),
            const SizedBox(height: 2),
            Text(
              'Volume is shown only where a product potency is known. Confirm '
              'it against the vial in hand — a wrong concentration is a wrong '
              'dose.',
              style: TextStyle(
                  fontSize: 11.5,
                  height: 1.45,
                  fontStyle: FontStyle.italic,
                  color: cs.onSurface.withValues(alpha: 0.7)),
            ),
          ],
        ),
      );

  /// What is different in children.
  ///
  /// Kept because the commonest paediatric error here is assuming a child gets
  /// a reduced vaccine dose. They do not — only the injection site changes.
  Widget _paediatric(ColorScheme cs) => RabiesCard(
        title: 'Children: what is different',
        icon: Icons.child_care_outlined,
        collapsible: true,
        subtitle: 'Less than most people assume',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [for (final p in kPaediatricPoints) SourcedLine(p)],
        ),
      );

  /// The branches the flow chart cannot show without becoming unreadable.
  ///
  /// IAP lines here are explanatory — they say WHY the national protocol
  /// requires something — and stay labelled so the distinction survives.
  Widget _special(ColorScheme cs) => RabiesCard(
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

  Widget _warnings(ColorScheme cs) => RabiesCard(
        title: 'Clinical warnings',
        icon: Icons.report_problem_outlined,
        accent: kCatIIIRed,
        collapsible: true,
        child: Column(
          children: [for (final w in kStandingWarnings) WarningBox(w)],
        ),
      );

  Widget _references(ColorScheme cs) => RabiesCard(
        title: 'References',
        icon: Icons.menu_book_outlined,
        subtitle: 'Checked '
            '${rabiesVerifiedOn.day}/${rabiesVerifiedOn.month}/${rabiesVerifiedOn.year}',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The algorithm, categories, schedules and RIG rules in this '
              'module are the NCDC / NRCP national protocol. IAP 2022 is cited '
              'only where it explains something the national protocol states '
              'without elaboration.',
              style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: cs.onSurface.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: 14),
            for (final src in GuidelineSource.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      SourceChip(src),
                      if (src == GuidelineSource.ncdcNrcp) ...[
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text('PRIMARY SOURCE',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.4,
                                  color: sourceColor(src))),
                        ),
                      ],
                    ]),
                    const SizedBox(height: 6),
                    Text(src.fullName,
                        style: TextStyle(
                            fontSize: 12.5,
                            height: 1.5,
                            color: cs.onSurface.withValues(alpha: 0.85))),
                    if (src.url != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(src.url!,
                            style: TextStyle(
                                fontSize: 11,
                                height: 1.4,
                                color: sourceColor(src))),
                      ),
                  ],
                ),
              ),
          ],
        ),
      );

  Widget _label(ColorScheme cs, String text) => Text(
        text,
        style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.6,
            color: cs.onSurface.withValues(alpha: 0.45)),
      );

  Widget _arrow(ColorScheme cs) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Icon(Icons.arrow_downward,
            size: 17, color: cs.onSurface.withValues(alpha: 0.35)),
      );

  Widget _node(AlgoNode n, {bool wide = false}) {
    final cs = Theme.of(context).colorScheme;
    final selected = _selected == n.id;
    final here = widget.highlightId == n.id;

    return Semantics(
      button: true,
      selected: selected,
      label: '${n.title}. ${n.subtitle ?? ''} Tap for detail.',
      child: InkWell(
        onTap: () => setState(() => _selected = selected ? null : n.id),
        borderRadius: BorderRadius.circular(11),
        child: Container(
          width: wide ? double.infinity : null,
          // Minimum height keeps the three category boxes the same size even
          // when their labels wrap differently.
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
          decoration: BoxDecoration(
            color: n.color.withValues(alpha: selected ? 0.2 : 0.09),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: n.color.withValues(alpha: selected ? 1 : 0.5),
              width: selected ? 2 : 1.2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (here)
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: n.color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('YOU ARE HERE',
                        style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            color: Colors.white)),
                  ),
                ),
              Text(n.title,
                  style: TextStyle(
                      fontSize: wide ? 13 : 12,
                      height: 1.25,
                      fontWeight: FontWeight.w800,
                      color: n.color)),
              if (n.subtitle != null) ...[
                const SizedBox(height: 3),
                Text(n.subtitle!,
                    style: TextStyle(
                        fontSize: 10.5,
                        height: 1.35,
                        color: cs.onSurface.withValues(alpha: 0.7))),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailPanel(ColorScheme cs) {
    final node = _kAllNodes.firstWhere((n) => n.id == _selected);
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.42),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        border: Border(
            top: BorderSide(color: node.color.withValues(alpha: 0.5), width: 2)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(node.title,
                      style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w900,
                          color: node.color)),
                ),
                IconButton(
                  onPressed: () => setState(() => _selected = null),
                  icon: const Icon(Icons.close, size: 19),
                  tooltip: 'Close',
                ),
              ],
            ),
            const SizedBox(height: 6),
            for (final d in node.detail) SourcedLine(d),
          ],
        ),
      ),
    );
  }
}

// ── Node definitions ─────────────────────────────────────────────────────────

const _kExposure = AlgoNode(
  id: 'exposure',
  title: 'ANIMAL EXPOSURE',
  subtitle: 'Bite, scratch, lick or mucosal contact',
  color: Color(0xFF455A64),
  detail: [
    Sourced(
      'Rabies is transmitted to humans largely by dogs and cats (>97%), and by '
      'wild animals (2%) such as mongoose, foxes, jackals, wild dogs and wild '
      'rodents; occasionally monkeys, horses and donkeys. Domestic rats, '
      'rabbits and birds are ordinarily not known to transmit rabies.',
      GuidelineSource.iap2022,
    ),
    Sourced(
      'All categories of bite should be reported in the NRCP monthly report.',
      GuidelineSource.ncdcNrcp,
    ),
  ],
);

const _kWash = AlgoNode(
  id: 'wash',
  title: 'WASH THE WOUND — IMMEDIATELY',
  subtitle: '10–15 min (NRCP: at least 15), soap and running water',
  color: kCatIIIRed,
  detail: [
    Sourced(
      'Gently wash all scratches or wounds with mild soap and running water '
      'for at least 15 minutes, irrespective of exposure category, to decrease '
      'viral load.',
      GuidelineSource.ncdcNrcp,
    ),
    Sourced(
      'Rabies risk is reduced by almost 50% by early and proper local '
      'treatment of wounds.',
      GuidelineSource.iap2022,
    ),
    Sourced(
      'After allowing the wound to dry, apply an antiseptic such as '
      'povidone-iodine or surgical spirit. Routine suturing is not '
      'recommended; a few stay sutures may be used to stop bleeding, and only '
      'after RIG infiltration.',
      GuidelineSource.iap2022,
    ),
  ],
);

const _kCatI = AlgoNode(
  id: 'cat1',
  title: 'CATEGORY I',
  subtitle: 'Touching or feeding; licks on intact skin',
  color: kCatIBlue,
  detail: [
    Sourced(
      'No prophylaxis needed — if a reliable contact history is available. '
      'That condition is the rule, not a footnote: without a reliable history, '
      'Category I does not clear the child.',
      GuidelineSource.ncdcNrcp,
    ),
  ],
);

const _kCatII = AlgoNode(
  id: 'cat2',
  title: 'CATEGORY II',
  subtitle: 'Nibbling of uncovered skin; minor scratches without bleeding',
  color: kCatIIAmber,
  detail: [
    Sourced(
      'Local treatment of wounds, and rabies vaccine.',
      GuidelineSource.iap2022,
    ),
    Sourced(
      'Only rabies vaccination — RIG is not indicated in an immunocompetent '
      'previously unimmunised patient.',
      GuidelineSource.ncdcNrcp,
    ),
    Sourced(
      'RIG/RMAb IS indicated in Category II in immunocompromised patients.',
      GuidelineSource.iap2022,
    ),
  ],
);

const _kCatIII = AlgoNode(
  id: 'cat3',
  title: 'CATEGORY III',
  subtitle: 'Transdermal bites or scratches; licks on broken skin; '
      'saliva on mucous membrane',
  color: kCatIIIRed,
  detail: [
    Sourced(
      'Local treatment of wounds, RIG/RMAb, and anti-rabies vaccine.',
      GuidelineSource.iap2022,
    ),
    Sourced(
      'Infiltrate wounds with RIG as soon as possible.',
      GuidelineSource.ncdcNrcp,
    ),
    Sourced(
      'Vaccine alone is not enough: vaccine-induced antibodies appear only '
      'after 7–14 days, and the patient is unprotected during that window.',
      GuidelineSource.iap2022,
    ),
  ],
);

const _kPrevImm = AlgoNode(
  id: 'previm',
  title: 'WAS THE CHILD PREVIOUSLY IMMUNISED?',
  subtitle: 'Documented complete previous PrEP or PEP with modern vaccines',
  color: Color(0xFF00695C),
  detail: [
    Sourced(
      'Previously immunised means an animal bite patient who can DOCUMENT a '
      'previous history of complete post-exposure or pre-exposure prophylaxis '
      'by modern vaccines.',
      GuidelineSource.ncdcNrcp,
    ),
    Sourced(
      'An undocumented or unknown history is not previously immunised. '
      'Treating it as such swaps a full course plus RIG for two doses.',
      GuidelineSource.ncdcNrcp,
    ),
  ],
);

const _kNaive = AlgoNode(
  id: 'naive',
  title: 'NOT PREVIOUSLY IMMUNISED',
  subtitle: 'ID 0–3–7–28 (2 sites)  ·  or IM 0–3–7–14–28',
  color: kCatIIAmber,
  detail: [
    Sourced(
      '4 doses intradermally (0.1 mL, 2 sites) on days 0–3–7–28, OR 5 doses '
      'intramuscularly (1 vial, 1 site) on days 0–3–7–14–28.',
      GuidelineSource.ncdcNrcp,
    ),
    Sourced(
      'NRCP advocates the intradermal route for rabies vaccine administration.',
      GuidelineSource.ncdcNrcp,
    ),
  ],
);

const _kBoost = AlgoNode(
  id: 'boost',
  title: 'PREVIOUSLY IMMUNISED',
  subtitle: '2 doses  ·  day 0 and day 3  ·  no routine RIG',
  color: Color(0xFF00695C),
  detail: [
    Sourced(
      'Only two doses of vaccine, on days 0 and 3, by either route. No '
      'RIG/RMAb is indicated.',
      GuidelineSource.iap2022,
    ),
    Sourced(
      'Intradermally this is ONE site, not the two sites used for a previously '
      'unimmunised patient.',
      GuidelineSource.ncdcNrcp,
    ),
    Sourced(
      'Where direct nerve exposure is suspected, the treating physician may '
      'consider RIG infiltration.',
      GuidelineSource.ncdcNrcp,
    ),
    Sourced(
      'IAP only: re-exposure within 3 months of completing PEP needs wound '
      'treatment alone — neither vaccine nor RIG. NRCP does not carry this '
      'exemption.',
      GuidelineSource.iap2022,
    ),
  ],
);

const _kImmuno = AlgoNode(
  id: 'immuno',
  title: 'IMMUNOCOMPROMISED? — SPECIAL PROTOCOL',
  subtitle: 'RIG in Category II as well as III, and the IM route',
  color: Color(0xFF6A1B9A),
  detail: [
    Sourced(
      'Proper wound management followed by local infiltration of RIG in BOTH '
      'Category II and Category III exposures.',
      GuidelineSource.ncdcNrcp,
    ),
    Sourced(
      'After this, a complete course of rabies vaccine by the INTRAMUSCULAR '
      'route in both Category II and Category III exposures.',
      GuidelineSource.ncdcNrcp,
    ),
    Sourced(
      'This branch overrides the standard pathway. A previously immunised but '
      'immunocompromised child does not drop to the 2-dose regimen.',
      GuidelineSource.ncdcNrcp,
    ),
  ],
);

const _kRig = AlgoNode(
  id: 'rig',
  title: 'RIG / RMAb — LOCAL INFILTRATION',
  subtitle: 'HRIG 20 IU/kg  ·  ERIG 40 IU/kg  ·  not beyond day 7',
  color: kCatIIIRed,
  detail: [
    Sourced(
      'The maximum dosage for HRIG is 20 IU/kg body weight, and for ERIG '
      '40 IU/kg body weight.',
      GuidelineSource.ncdcNrcp,
    ),
    Sourced(
      'Human RMAb 3.33 IU/kg (potency 40 IU/mL); RMAb cocktail 40 IU/kg '
      '(potency 600 IU/mL).',
      GuidelineSource.iap2022,
    ),
    Sourced(
      'The entire dose, or as much as is anatomically feasible, is infiltrated '
      'into or as close as possible to the wound — while avoiding compartment '
      'syndrome.',
      GuidelineSource.ncdcNrcp,
    ),
    Sourced(
      'The remainder does not need to be injected intramuscularly at a '
      'distance from the wound.',
      GuidelineSource.iap2022,
    ),
    Sourced(
      'Do not give RIG beyond the 7th day after the 1st vaccine dose on day 0.',
      GuidelineSource.ncdcNrcp,
    ),
  ],
);

const _kFollowUp = AlgoNode(
  id: 'followup',
  title: 'FOLLOW-UP & COMPLETION',
  subtitle: 'Complete the course; a delayed dose is resumed, never restarted',
  color: kOkGreen,
  detail: [
    Sourced(
      'Should a vaccine dose be delayed for any reason, the PEP regimen should '
      'be resumed or continued — NOT restarted.',
      GuidelineSource.iap2022,
    ),
    Sourced(
      'Changes in vaccine product and/or route during the same PEP course are '
      'acceptable, if unavoidable, to ensure the course is completed.',
      GuidelineSource.iap2022,
    ),
    Sourced(
      'Completion of the vaccination course as per schedule is paramount. A '
      'full course must follow wound cleansing and passive immunisation, or '
      'treatment failure can occur.',
      GuidelineSource.iap2022,
    ),
  ],
);

const List<AlgoNode> _kAllNodes = [
  _kExposure,
  _kWash,
  _kCatI,
  _kCatII,
  _kCatIII,
  _kPrevImm,
  _kNaive,
  _kBoost,
  _kImmuno,
  _kRig,
  _kFollowUp,
];

const _th = TextStyle(fontSize: 12, fontWeight: FontWeight.w800);
const _td = TextStyle(fontSize: 12, height: 1.3);
const _tdBold =
    TextStyle(fontSize: 12.5, height: 1.3, fontWeight: FontWeight.w900);
