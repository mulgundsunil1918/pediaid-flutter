// =============================================================================
// screens/rabies/rabies_screen.dart — the module hub
//
// Four tabs, because the module serves four different moments:
//
//   Assess     — the SMART view. Tap the findings, get the recommendation.
//   Reference  — the CHART view. The whole protocol, both sources, all tables.
//   Algorithm  — the NRCP decision tree, interactive and zoomable.
//   RIG        — the calculator on its own, for when that is all you need.
//
// The guideline selector lives in the app bar rather than inside a tab. It
// changes what every tab says, and hiding a control with that reach inside one
// screen would let a clinician read an IAP recommendation while believing they
// were reading the national protocol.
// =============================================================================

import 'package:flutter/material.dart';

import 'rabies_algorithm_view.dart';
import 'rabies_assess_view.dart';
import 'rabies_protocol.dart';
import 'rabies_reference_view.dart';
import 'rabies_rig_calculator.dart';
import 'rabies_widgets.dart';

class RabiesScreen extends StatefulWidget {
  const RabiesScreen({super.key});

  @override
  State<RabiesScreen> createState() => _RabiesScreenState();
}

class _RabiesScreenState extends State<RabiesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 4, vsync: this);

  // NRCP is the default because it is the national protocol for Indian
  // practice, which is what this app is primarily for. IAP is one tap away and
  // the difference is never hidden.
  GuidelineSource _source = GuidelineSource.ncdcNrcp;

  final _searchCtl = TextEditingController();
  String _query = '';
  bool _searching = false;

  @override
  void dispose() {
    _tabs.dispose();
    _searchCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: _searching
            ? TextField(
                controller: _searchCtl,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search this module…',
                  border: InputBorder.none,
                ),
                onChanged: (v) => setState(() => _query = v),
              )
            : const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(kRabiesModuleTitle,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                  Text('Post-exposure prophylaxis in children',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400)),
                ],
              ),
        actions: [
          IconButton(
            tooltip: _searching ? 'Close search' : 'Search this module',
            icon: Icon(_searching ? Icons.close : Icons.search),
            onPressed: () => setState(() {
              _searching = !_searching;
              if (!_searching) {
                _searchCtl.clear();
                _query = '';
              } else {
                // Search only reaches the reference view, so go there rather
                // than letting someone type into a tab that ignores them.
                _tabs.animateTo(1);
              }
            }),
          ),
        ],
        bottom: PreferredSize(
          // 122, not 96: the guideline selector wraps to two lines on a 375 px
          // phone and the old height clipped it by 48 px. Tab icons dropped to
          // buy that back — four short words do not need pictures, and app-bar
          // chrome is space the clinical content does not get.
          preferredSize: const Size.fromHeight(122),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sourceSelector(cs),
              TabBar(
                controller: _tabs,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: const [
                  Tab(text: 'Assess'),
                  Tab(text: 'Reference'),
                  Tab(text: 'Algorithm'),
                  Tab(text: 'RIG'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          RabiesAssessView(
            source: _source,
            onSourceChanged: (s) => setState(() => _source = s),
          ),
          RabiesReferenceView(query: _query),
          const RabiesAlgorithmView(),
          const RabiesRigCalculator(),
        ],
      ),
    );
  }

  /// The guideline toggle, plus the date the values were checked.
  ///
  /// The verification date sits here rather than buried in the references
  /// because a guideline tool that cannot say when it was last checked is
  /// asking to be trusted on nothing.
  Widget _sourceSelector(ColorScheme cs) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
        color: cs.surfaceContainerLowest,
        // A Wrap, not a Row: the fixed Row overflowed a 375 px phone by 241 px,
        // pushing the verification date off screen entirely. Wrapping lets the
        // date drop to a second line instead of disappearing.
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 6,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.rule_folder_outlined,
                    size: 16, color: cs.onSurface.withValues(alpha: 0.55)),
                const SizedBox(width: 7),
                Text('Guideline',
                    style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface.withValues(alpha: 0.6))),
              ],
            ),
            for (final s in [GuidelineSource.ncdcNrcp, GuidelineSource.iap2022])
              _sourceButton(cs, s),
            Text(
              'Checked '
              '${rabiesVerifiedOn.day}/${rabiesVerifiedOn.month}/${rabiesVerifiedOn.year}',
              style: TextStyle(
                  fontSize: 10,
                  color: cs.onSurface.withValues(alpha: 0.45)),
            ),
          ],
        ),
      );

  Widget _sourceButton(ColorScheme cs, GuidelineSource s) {
    final selected = _source == s;
    final c = sourceColor(s);
    return Semantics(
      selected: selected,
      button: true,
      label: 'Show ${s.fullName} recommendations',
      child: InkWell(
        onTap: () => setState(() => _source = s),
        borderRadius: BorderRadius.circular(7),
        child: Container(
          constraints: const BoxConstraints(minHeight: 32),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? c.withValues(alpha: 0.14) : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: selected ? c : cs.outlineVariant.withValues(alpha: 0.8),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(s.label,
              style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                  color: selected ? c : cs.onSurface.withValues(alpha: 0.7))),
        ),
      ),
    );
  }
}
