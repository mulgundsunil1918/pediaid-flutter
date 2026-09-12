// =============================================================================
// test/rabies_render_test.dart
//
// Two tabs: the published NRCP poster, and the tappable assessment.
//
// Rewritten when the module stopped rebuilding the poster out of widgets. That
// version was faithful in content and wrong in practice — the node tree
// overflowed sideways on a wide screen and clipped "Category III" mid-sentence,
// and a clinician who knows the poster could not navigate a layout that was not
// the poster's. The published artwork already solves the layout problem.
//
// The tests that matter here are the ones pinning defects that actually
// shipped: tab labels the theme rendered dark on a dark app bar, a two-line
// title that clipped the module name off the top, and wound washing appearing
// after the questions rather than before them.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/rabies/rabies_assess_view.dart';
import 'package:pediaid_app/screens/rabies/rabies_protocol_image.dart';
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
    expect(find.text('Protocol'), findsOneWidget);
    expect(find.text('Assess'), findsOneWidget);
    // The four-tab version and its guideline switcher are gone.
    expect(find.text('Reference'), findsNothing);
    expect(find.text('Guideline'), findsNothing,
        reason: 'NCDC is the only algorithm source');
  });

  testWidgets('tab labels are readable against the app bar', (tester) async {
    // They were inheriting a dark colour on a dark bar and were invisible.
    await _phone(tester, const RabiesScreen());
    final tabBar = tester.widget<TabBar>(find.byType(TabBar));
    expect(tabBar.labelColor, isNotNull);
    expect(tabBar.labelColor, isNot(ThemeData().colorScheme.onSurface));
    expect(tabBar.unselectedLabelColor, isNotNull);
  });

  group('the Protocol tab', () {
    testWidgets('names the poster and its issuing body', (tester) async {
      await _phone(tester, const Scaffold(body: RabiesProtocolImage()),
          h: 2400);
      expect(
          find.textContaining(
              'Protocol for rabies post-exposure prophylaxis after animal bite'),
          findsOneWidget);
      expect(find.textContaining('National Rabies Control Programme'),
          findsWidgets);
      expect(find.textContaining('Ministry of Health and Family Welfare'),
          findsWidgets);
    });

    testWidgets('the poster is actually bundled and rendered', (tester) async {
      // Asserted, not branched on. The poster IS this page — a build that
      // silently shipped without the asset would leave the tab explaining its
      // own absence, and nothing else would fail.
      await _phone(tester, const Scaffold(body: RabiesProtocolImage()),
          h: 2400);
      expect(find.byType(Image), findsOneWidget,
          reason: 'assets/images/rabies/rabies.png must be in the bundle');
      expect(find.text('Poster not bundled in this build'), findsNothing);
      expect(find.textContaining('Tap the poster'), findsOneWidget);
    });

    testWidgets('the asset path in code matches the file on disk',
        (tester) async {
      // Catches a rename on either side, which would otherwise only show up as
      // an empty tab on a real device.
      await expectLater(
          rootBundle.load(kRabiesPosterAsset), completes);
    });

    testWidgets('carries the references and the disclaimer', (tester) async {
      await _phone(tester, const Scaffold(body: RabiesProtocolImage()),
          h: 3000);
      await tester.scrollUntilVisible(find.text('References'), 300,
          scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      expect(find.text('References'), findsOneWidget);
      expect(find.text('PRIMARY SOURCE'), findsOneWidget,
          reason: 'NCDC is named as primary, IAP only explains');

      await tester.scrollUntilVisible(
          find.textContaining('intended to support, not replace'), 300,
          scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      expect(find.textContaining('intended to support, not replace'),
          findsOneWidget);
    });
  });

  group('the Assess tab', () {
    testWidgets('wound washing is shown BEFORE the questions', (tester) async {
      await _phone(tester, const Scaffold(body: RabiesAssessView()));
      // Washing reduces rabies risk by ~50%, costs nothing, and must not look
      // like it waits for the category to be settled.
      expect(find.text('FIRST: WASH THE WOUND'), findsOneWidget);
      expect(tester.getTopLeft(find.text('FIRST: WASH THE WOUND')).dy,
          lessThan(tester.getTopLeft(find.text('Exposure')).dy));
    });

    testWidgets('an empty assessment refuses to decide', (tester) async {
      await _phone(tester, const Scaffold(body: RabiesAssessView()), h: 4000);
      await tester.scrollUntilVisible(
          find.text('RABIES PEP RECOMMENDATION'), 300,
          scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      // Nothing recorded must never read as Category I.
      expect(find.text('CATEGORY UNCERTAIN'), findsOneWidget);
      expect(find.text('STILL NEEDED'), findsOneWidget);
    });

    testWidgets('keeps the material that is not on the poster', (tester) async {
      await _phone(tester, const Scaffold(body: RabiesAssessView()), h: 5000);
      for (final t in ['Children: what is different', 'Special situations']) {
        // Not .first — evaluating it on a not-yet-built widget throws before
        // any scrolling can bring the widget into existence.
        await tester.scrollUntilVisible(find.text(t), 300,
            scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
        expect(find.text(t), findsOneWidget, reason: t);
      }
    });
  });
}
