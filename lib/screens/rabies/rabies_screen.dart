// =============================================================================
// screens/rabies/rabies_screen.dart — the module hub
//
// TWO views, and only two:
//
//   Protocol — the published NRCP poster, as issued, zoomable. An earlier
//              version rebuilt it out of widgets; that overflowed sideways and
//              clipped "Category III" mid-sentence, and a clinician who knows
//              the poster could not navigate a layout that was not the
//              poster's. The artwork already solves the layout problem.
//   Assess   — the same algorithm as a tappable assessment ending in one
//              recommendation. This is the half paper cannot do.
//
// ONE SOURCE OF TRUTH: NCDC / NRCP
// --------------------------------
// The algorithm, the categories, the schedules, the RIG rules and the flow
// chart are all the national protocol. The IAP 2022 chapter is used ONLY where
// it explains something the poster states without elaboration — the reason the
// RIG window closes at day 7, what wound washing actually achieves, the
// monoclonal doses the poster does not print. Those lines stay labelled IAP so
// a reader can see which is which, but nothing about the DECISION comes from
// them.
//
// This replaced a four-tab version with a guideline switcher. Letting a
// clinician toggle between two guidelines mid-assessment sounds thorough and
// is actually a way to end up following neither.
// =============================================================================

import 'package:flutter/material.dart';

import 'rabies_assess_view.dart';
import 'rabies_protocol_image.dart';
import 'rabies_protocol.dart';

class RabiesScreen extends StatefulWidget {
  const RabiesScreen({super.key});

  @override
  State<RabiesScreen> createState() => _RabiesScreenState();
}

class _RabiesScreenState extends State<RabiesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        // One line. The two-line title plus a 122 px bottom overflowed the
        // app bar and clipped the module name off the top of the screen.
        title: const Text(kRabiesModuleTitle,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        bottom: TabBar(
          controller: _tabs,
          // Set explicitly: inherited from the theme these came out dark on
          // the blue app bar and were effectively unreadable.
          labelColor: cs.onPrimary,
          unselectedLabelColor: cs.onPrimary.withValues(alpha: 0.72),
          indicatorColor: cs.onPrimary,
          indicatorWeight: 3,
          labelStyle:
              const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
          unselectedLabelStyle:
              const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Protocol'),
            Tab(text: 'Assess'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          RabiesProtocolImage(),
          RabiesAssessView(),
        ],
      ),
    );
  }
}
