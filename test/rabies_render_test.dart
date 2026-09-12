// =============================================================================
// test/rabies_render_test.dart
//
// That the module renders, fits a phone, and shows what the engine computes.
//
// Rewritten when the module dropped from four tabs to two. Three of these
// pin defects that actually shipped: tab labels the theme rendered dark on a
// dark app bar (invisible, and reported from a real screenshot), a two-line
// title that clipped the module name off the top, and a citation that existed
// in source but was never rendered — which tree-shakes out of the release
// bundle and silently stops being in the product.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/rabies/rabies_algorithm_view.dart';
import 'package:pediaid_app/screens/rabies/rabies_assess_view.dart';
import 'package:pediaid_app/screens/rabies/rabies_screen.dart';

Future<void> _phone(WidgetTester tester, Widget child,
    {double h = 812}) async {
  tester.view.physicalSize = Size(375, h);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(home: child));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the module opens on a phone with exactly two tabs',
      (tester) async {
    await _phone(tester, const RabiesScreen());

    expect(find.text('Rabies & Animal Bite'), findsOneWidget,
        reason: 'the title was being clipped off the top');
    expect(find.text('Flow chart'), findsOneWidget);
    expect(find.text('Assess'), findsOneWidget);
    // The four-tab version is gone, along with the guideline switcher.
    expect(find.text('Reference'), findsNothing);
    expect(find.text('RIG'), findsNothing);
    // IAP chips DO still appear, as attribution on explanatory lines — that
    // is the point of keeping the source layer. What must be gone is the
    // SWITCHER, which let a clinician toggle the algorithm mid-assessment.
    expect(find.text('Guideline'), findsNothing,
        reason: 'the guideline switcher is gone; NCDC is the only algorithm');
  });

  testWidgets('tab labels are readable against the app bar', (tester) async {
    // They were inheriting a dark colour on a dark bar and were invisible.
    await _phone(tester, const RabiesScreen());
    final tabBar = tester.widget<TabBar>(find.byType(TabBar));
    final scheme = ThemeData().colorScheme;
    expect(tabBar.labelColor, isNotNull);
    expect(tabBar.labelColor, isNot(scheme.onSurface),
        reason: 'must be an on-primary colour, not the body text colour');
    expect(tabBar.unselectedLabelColor, isNotNull);
  });

  testWidgets('wound washing is shown BEFORE the assessment questions',
      (tester) async {
    await _phone(tester, const Scaffold(body: RabiesAssessView()));
    // Washing reduces rabies risk by ~50%, costs nothing, and must not look
    // like it waits for the category to be settled.
    expect(find.text('FIRST: WASH THE WOUND'), findsOneWidget);
    expect(tester.getTopLeft(find.text('FIRST: WASH THE WOUND')).dy,
        lessThan(tester.getTopLeft(find.text('Exposure')).dy));
  });

  testWidgets('the flow chart carries the poster\'s own sections',
      (tester) async {
    await _phone(tester, const Scaffold(body: RabiesAlgorithmView()), h: 4000);

    for (final title in [
      'Rabies PEP Decision Algorithm',
      'Rabies immunoglobulin — RIG dosage',
      'Children: what is different',
      'Special situations',
      'Clinical warnings',
      'References',
    ]) {
      await tester.scrollUntilVisible(find.text(title), 300,
          scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget, reason: 'section: $title');
    }
  });

  testWidgets('NCDC is named as the primary source', (tester) async {
    await _phone(tester, const Scaffold(body: RabiesAlgorithmView()), h: 4000);
    await tester.scrollUntilVisible(find.text('References'), 300,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    expect(find.text('PRIMARY SOURCE'), findsOneWidget);
  });

  testWidgets('tapping a flow-chart node opens its detail', (tester) async {
    await _phone(tester, const Scaffold(body: RabiesAlgorithmView()));
    expect(find.text('CATEGORY III'), findsOneWidget);
    await tester.tap(find.text('CATEGORY III'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Infiltrate wounds with RIG'), findsOneWidget);
  });

  testWidgets('RIG dosage computes 300 IU for a 15 kg child', (tester) async {
    await _phone(tester, const Scaffold(body: RabiesAlgorithmView()), h: 4000);
    await tester.scrollUntilVisible(
        find.text('Rabies immunoglobulin — RIG dosage'), 300,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '15');
    await tester.pumpAndSettle();

    expect(find.text('300 IU'), findsWidgets, reason: 'HRIG 20 IU/kg x 15 kg');
    expect(find.text('600 IU'), findsWidgets, reason: 'ERIG 40 IU/kg x 15 kg');
  });

  testWidgets('the day-7 cut-off and the disclaimer are actually rendered',
      (tester) async {
    await _phone(tester, const Scaffold(body: RabiesAlgorithmView()), h: 4000);
    await tester.scrollUntilVisible(find.text('Clinical warnings'), 300,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    expect(find.textContaining('Do not give RIG beyond the 7th day'),
        findsWidgets);

    await tester.scrollUntilVisible(
        find.textContaining('intended to support, not replace'), 300,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    expect(find.textContaining('intended to support, not replace'),
        findsOneWidget);
  });
}
