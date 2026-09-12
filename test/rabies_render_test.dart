// =============================================================================
// test/rabies_render_test.dart
//
// That the module actually renders, fits a phone, and shows the things the
// engine tests prove it computes.
//
// The engine tests are the ones that matter clinically, but a correct engine
// behind a screen that overflows, or behind a recommendation the layout clips,
// helps nobody. Two specific defects are pinned here because both have
// happened in this app before: content that only fits on a wide screen, and a
// citation that exists in source but is never rendered, so it gets tree-shaken
// out of the release bundle and silently stops being in the product at all.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/rabies/rabies_algorithm_view.dart';
import 'package:pediaid_app/screens/rabies/rabies_reference_view.dart';
import 'package:pediaid_app/screens/rabies/rabies_rig_calculator.dart';
import 'package:pediaid_app/screens/rabies/rabies_screen.dart';

Future<void> _phone(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(home: child));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the module opens on a 375px phone with its four tabs',
      (tester) async {
    await _phone(tester, const RabiesScreen());

    expect(find.text('Rabies & Animal Bite'), findsOneWidget);
    for (final tab in ['Assess', 'Reference', 'Algorithm', 'RIG']) {
      expect(find.text(tab), findsOneWidget, reason: 'tab $tab');
    }
    // Both guideline sources must be selectable from the top, not buried.
    expect(find.text('NCDC / NRCP'), findsWidgets);
    expect(find.text('IAP 2022'), findsWidgets);
  });

  testWidgets('wound washing is shown BEFORE the assessment questions',
      (tester) async {
    await _phone(tester, const RabiesScreen());
    // Not a styling preference: washing reduces rabies risk by ~50%, costs
    // nothing, and must not appear to depend on the category being settled.
    expect(find.text('FIRST: WASH THE WOUND'), findsOneWidget);

    final washY = tester.getTopLeft(find.text('FIRST: WASH THE WOUND')).dy;
    final exposureY = tester.getTopLeft(find.text('Exposure')).dy;
    expect(washY, lessThan(exposureY),
        reason: 'washing must sit above the questions, not after them');
  });

  testWidgets('the reference view renders every section without overflow',
      (tester) async {
    tester.view.physicalSize = const Size(375, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: Scaffold(
      body: RabiesReferenceView(),
    )));
    await tester.pumpAndSettle();

    // The list virtualises, so each section is scrolled to rather than
    // assumed present — which also proves the page scrolls cleanly to the end.
    for (final title in [
      'Exposure categories',
      'Immediate wound management',
      'At a glance',
      'Vaccine schedules',
      'RIG & RMAb',
      'Children: what is different',
      'IAP 2022 vs NCDC / NRCP',
      'References',
    ]) {
      await tester.scrollUntilVisible(find.text(title), 300,
          scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget, reason: 'section: $title');
    }
  });

  testWidgets('module search filters the reference view', (tester) async {
    tester.view.physicalSize = const Size(375, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: RabiesReferenceView(query: 'hrig'))));
    await tester.pumpAndSettle();

    expect(find.text('RIG & RMAb'), findsOneWidget);
    expect(find.text('Exposure categories'), findsNothing,
        reason: 'a search for HRIG should not return the category table');
  });

  testWidgets('the algorithm renders and its nodes open a detail panel',
      (tester) async {
    await _phone(tester, const Scaffold(body: RabiesAlgorithmView()));

    expect(find.text('Rabies PEP Decision Algorithm'), findsOneWidget);
    expect(find.text('CATEGORY III'), findsOneWidget);

    // Spec: tapping Category III opens its definition and management.
    await tester.tap(find.text('CATEGORY III'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Infiltrate wounds with RIG'), findsOneWidget);
  });

  testWidgets('the RIG calculator computes 300 IU for a 15 kg child on HRIG',
      (tester) async {
    tester.view.physicalSize = const Size(375, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: RabiesRigCalculator())));
    await tester.pumpAndSettle();

    // Before a weight is entered there must be no number pretending to be one.
    expect(find.text('—'), findsWidgets);

    await tester.enterText(find.byType(TextField).first, '15');
    await tester.pumpAndSettle();

    expect(find.text('300 IU'), findsWidgets,
        reason: 'HRIG at 20 IU/kg for 15 kg');
    // ERIG at 40 IU/kg appears in the all-agents table.
    expect(find.text('600 IU'), findsWidgets);
  });

  testWidgets('the day-7 RIG cut-off is rendered, not merely in the source',
      (tester) async {
    // A const string nothing renders is tree-shaken out of the release bundle.
    // This app has shipped that exact defect before, with the ETROP citation.
    tester.view.physicalSize = const Size(375, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: RabiesReferenceView(query: 'rig'))));
    await tester.pumpAndSettle();

    expect(find.textContaining('Do not give RIG beyond the 7th day'),
        findsWidgets);
    expect(find.text('THE RIG WINDOW'), findsOneWidget);
  });

  testWidgets('the disclaimer travels with the module', (tester) async {
    tester.view.physicalSize = const Size(375, 6000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: RabiesReferenceView(query: 'reference'))));
    await tester.pumpAndSettle();

    expect(find.textContaining('intended to support, not replace, clinical judgment'),
        findsOneWidget);
  });
}
