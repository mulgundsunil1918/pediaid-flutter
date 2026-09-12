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
    await _phone(tester, const Scaffold(body: RabiesAlgorithmView()), h: 4000);
    // "CATEGORY III" now appears twice — once as the DECISION TO TREAT badge
    // and once as the tree node. The tappable one is the later.
    await tester.scrollUntilVisible(find.text('CATEGORY III').last, 200,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('CATEGORY III').last);
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

  testWidgets('the flow chart has ONE scroll surface, not a nested one',
      (tester) async {
    // The tree used to sit in a fixed 460 px box with its own
    // InteractiveViewer inside the page's ListView. A drag inside the box
    // panned the tree, a drag outside scrolled the page, and the tree was
    // clipped at both ends — reported as "scrolling issues" from a screenshot
    // showing the first and last nodes cut off.
    await _phone(tester, const Scaffold(body: RabiesAlgorithmView()), h: 4000);
    expect(find.byType(InteractiveViewer), findsNothing,
        reason: 'no pannable viewer nested inside the page scroll');
    // Wide tables still scroll sideways inside themselves, which is correct
    // and is not what was broken — so count only the VERTICAL surfaces.
    final vertical = tester
        .widgetList<Scrollable>(find.byType(Scrollable))
        .where((s) => s.axisDirection == AxisDirection.down)
        .length;
    expect(vertical, 1, reason: 'exactly one vertical scroll surface');
  });

  testWidgets('every node of the tree is reachable by scrolling',
      (tester) async {
    await _phone(tester, const Scaffold(body: RabiesAlgorithmView()), h: 4000);
    // First and last nodes were the two being clipped.
    for (final t in ['ANIMAL EXPOSURE', 'FOLLOW-UP & COMPLETION']) {
      await tester.scrollUntilVisible(find.text(t), 300,
          scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      expect(find.text(t), findsOneWidget, reason: t);
    }
  });

  testWidgets('the expand button opens a zoom view with no outer scroll',
      (tester) async {
    await _phone(tester, const Scaffold(body: RabiesAlgorithmView()), h: 4000);
    await tester.scrollUntilVisible(find.byTooltip('Expand diagram'), 300,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Expand diagram'));
    await tester.pumpAndSettle();

    expect(find.byType(InteractiveViewer), findsOneWidget,
        reason: 'zoom lives here, where it owns the whole screen');
    expect(find.byTooltip('Reset view'), findsOneWidget);
    expect(find.text('CATEGORY III'), findsWidgets);
  });

  // ── Every element of the NRCP poster ───────────────────────────────────
  //
  // Sunil: "please put every point and every word of this image". The first
  // version paraphrased the poster into categories and schedules, which lost
  // the dose COUNTS a pharmacist needs, the IMMUNE COMPETENT PERSON qualifier
  // on every regimen, the reporting requirement, the route advocacy and the
  // programme's own framing. These assert the poster line by line.
  group('the poster is reproduced in full', () {
    // .first throughout: scrollUntilVisible needs a finder matching exactly
    // one widget, and several of these phrases legitimately appear more than
    // once on the page.
    Future<void> seek(WidgetTester tester, Finder f) async {
      await tester.scrollUntilVisible(f.first, 300,
          scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
    }

    testWidgets('masthead, both banners and the footer', (tester) async {
      await _phone(tester, const Scaffold(body: RabiesAlgorithmView()),
          h: 9000);
      for (final t in [
        'MINISTRY OF HEALTH AND FAMILY WELFARE',
        'GOVERNMENT OF INDIA',
        'PROTOCOL FOR RABIES POST EXPOSURE PROPHYLAXIS AFTER ANIMAL BITE',
        'DECISION TO TREAT',
        'POST EXPOSURE PROPHYLAXIS PROTOCOL',
        'RABIES IMMUNOGLOBULIN — RIG DOSAGE',
        'NATIONAL RABIES CONTROL PROGRAMME',
      ]) {
        await seek(tester, find.text(t));
        expect(find.text(t), findsOneWidget, reason: t);
      }
      await seek(tester, find.textContaining('ADOPT ONE HEALTH'));
      expect(find.textContaining('ADOPT ONE HEALTH, STOP RABIES'),
          findsOneWidget);
    });

    testWidgets('the DECISION TO TREAT outcomes', (tester) async {
      await _phone(tester, const Scaffold(body: RabiesAlgorithmView()),
          h: 9000);
      for (final t in [
        'No prophylaxis needed',
        'ONLY RABIES VACCINATION',
        'RABIES VACCINATION  +  RIG INFILTRATION',
      ]) {
        await seek(tester, find.text(t));
        expect(find.text(t), findsWidgets, reason: t);
      }
      // The reporting requirement sits with this block on the poster.
      await seek(tester, find.textContaining('NRCP monthly report'));
      expect(find.textContaining('reported in NRCP monthly report'),
          findsWidgets);
    });

    testWidgets('the 15-minute wash instruction, verbatim', (tester) async {
      await _phone(tester, const Scaffold(body: RabiesAlgorithmView()),
          h: 9000);
      await seek(tester, find.text('WASH FIRST — EVERY CATEGORY'));
      // The poster emphasises "15 minutes" inside the sentence; the emphasis
      // is part of the instruction.
      expect(find.textContaining('mild soap and running water'), findsWidgets);
      expect(find.textContaining('decrease viral load'), findsWidgets);
    });

    testWidgets('the dose COUNTS a pharmacist needs', (tester) async {
      await _phone(tester, const Scaffold(body: RabiesAlgorithmView()),
          h: 9000);
      for (final t in [
        'Give 04 doses OF RABIES VACCINE',
        'Give 05 doses OF RABIES VACCINE',
        'Give 02 doses OF RABIES VACCINE',
      ]) {
        await seek(tester, find.text(t));
        expect(find.text(t), findsWidgets, reason: t);
      }
      // And the day strings, exactly as printed.
      await seek(tester, find.text('0 – 3 – 7 – 14 – 28'));
      expect(find.text('0 – 3 – 7 – 14 – 28'), findsWidgets);
      expect(find.text('0 – 3 – 7 – 28'), findsWidgets);
      expect(find.text('0 – 3'), findsWidgets);
    });

    testWidgets('IMMUNE COMPETENT PERSON qualifies every regimen',
        (tester) async {
      await _phone(tester, const Scaffold(body: RabiesAlgorithmView()),
          h: 9000);
      await seek(tester, find.text('IMMUNE COMPETENT PERSON'));
      // Three regimen boxes, three qualifiers — it is what sends an
      // immunocompromised child down the other branch.
      expect(find.text('IMMUNE COMPETENT PERSON'), findsNWidgets(3));
    });

    testWidgets('the boxed remarks the poster prints below the algorithm',
        (tester) async {
      await _phone(tester, const Scaffold(body: RabiesAlgorithmView()),
          h: 9000);
      for (final t in [
        'FOR IMMUNE COMPROMISED PERSON',
        '*Previously Immunised Case',
        'REPEAT EXPOSURE',
        'WHERE TO INJECT THE VACCINE',
      ]) {
        await seek(tester, find.text(t));
        expect(find.text(t), findsOneWidget, reason: t);
      }
      await seek(tester, find.textContaining('TREAT AS PREVIOUSLY IMMUNIZED'));
      expect(find.textContaining('TREAT AS PREVIOUSLY IMMUNIZED'), findsWidgets);
      await seek(tester, find.textContaining('gluteal region'));
      expect(find.textContaining('gluteal region'), findsWidgets);
    });

    testWidgets('the four RIG rules and the route advocacy', (tester) async {
      await _phone(tester, const Scaffold(body: RabiesAlgorithmView()),
          h: 9000);
      for (final t in [
        'The maximum dosage for HRIG is 20 IU/Kg',
        'avoiding compartment syndrome',
        'Do not give RIG beyond the 7th day',
        'direct nerve exposure is suspected',
        'NRCP ADVOCATES INTRADERMAL ROUTE',
      ]) {
        await seek(tester, find.textContaining(t));
        expect(find.textContaining(t), findsWidgets, reason: t);
      }
    });
  });
}
