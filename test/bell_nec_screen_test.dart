// =============================================================================
// test/bell_nec_screen_test.dart
//
// The two views Sunil asked for, on a phone.
//
// The Stage view is the one that needed building: Bell's is a classification,
// not a score, so the shared tap-to-score view would have summed columns that
// are not points and reported a total out of a maximum that does not exist.
// These check it stages instead of scoring, and that the table view keeps every
// word on screen rather than pushing columns off the right edge — which is how
// the grade-2 column on Silverman and Downes used to hide.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/guides/neonatal_scores/bell_nec_screen.dart';

Future<void> _phone(WidgetTester tester, {double h = 2400}) async {
  tester.view.physicalSize = Size(375, h);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MaterialApp(home: BellNecScreen()));
  await tester.pumpAndSettle();
}

Future<void> _seek(WidgetTester tester, Finder f) async {
  await tester.scrollUntilVisible(f, 300,
      scrollable: find.byType(Scrollable).first);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('opens on the Stage view with both toggles', (tester) async {
    await _phone(tester);
    expect(find.text("Modified Bell's Staging"), findsWidgets);
    expect(find.text('Stage'), findsOneWidget);
    expect(find.text('Table'), findsOneWidget);
    // Nothing selected yet, and that must not read as stage IA.
    expect(find.text('No stage established'), findsOneWidget);
  });

  testWidgets('tapping pneumoperitoneum stages IIIB and calls for surgery',
      (tester) async {
    await _phone(tester);
    await _seek(tester, find.text('Pneumoperitoneum'));
    await tester.tap(find.text('Pneumoperitoneum'));
    await tester.pumpAndSettle();

    await _seek(tester, find.text('STAGE IIIB'));
    expect(find.text('STAGE IIIB'), findsOneWidget);
    expect(find.text('Advanced, severely ill, perforated bowel'),
        findsOneWidget);
    expect(find.textContaining('surgery'), findsWidgets);
    expect(find.textContaining('Perforated bowel'), findsWidgets);
  });

  testWidgets('a lower finding does not lower an established stage',
      (tester) async {
    // The classification is cumulative: adding an IA finding to a IIA picture
    // must not drag it back to IA.
    await _phone(tester);
    await _seek(tester, find.text('Pneumatosis intestinalis'));
    await tester.tap(find.text('Pneumatosis intestinalis'));
    await tester.pumpAndSettle();
    await _seek(tester, find.text('Apnoea'));
    await tester.tap(find.text('Apnoea'));
    await tester.pumpAndSettle();

    await _seek(tester, find.text('STAGE IIA'));
    expect(find.text('STAGE IIA'), findsOneWidget);
    expect(find.text('STAGE IA'), findsNothing);
  });

  testWidgets('a "with or without" finding alone establishes nothing',
      (tester) async {
    await _phone(tester);
    await _seek(tester, find.textContaining('Abdominal tenderness'));
    await tester.tap(find.textContaining('Abdominal tenderness'));
    await tester.pumpAndSettle();

    expect(find.text('No stage established'), findsOneWidget);
    expect(find.textContaining('with or without'), findsWidgets);
  });

  testWidgets('no total is ever shown — this is not a score', (tester) async {
    // The shared smart view renders "/ 21" style denominators. Bell's has no
    // maximum, and showing one would be an invented number.
    await _phone(tester);
    await _seek(tester, find.text('Pneumatosis intestinalis'));
    await tester.tap(find.text('Pneumatosis intestinalis'));
    await tester.pumpAndSettle();

    expect(find.textContaining('/ '), findsNothing,
        reason: 'a denominator would imply the stages are added');
  });

  testWidgets('the table view shows all six stages with every column',
      (tester) async {
    await _phone(tester, h: 5000);
    await tester.tap(find.text('Table'));
    await tester.pumpAndSettle();

    for (final code in ['IA', 'IB', 'IIA', 'IIB', 'IIIA', 'IIIB']) {
      await _seek(tester, find.text('STAGE $code'));
      expect(find.text('STAGE $code'), findsOneWidget, reason: code);
    }
    // Four columns per stage, stacked so nothing sits off the right edge.
    expect(find.text('SYSTEMIC'), findsWidgets);
    expect(find.text('ABDOMINAL'), findsWidgets);
    expect(find.text('RADIOGRAPHIC'), findsWidgets);
    expect(find.text('TREATMENT'), findsWidgets);
  });

  testWidgets('the reference is rendered, not merely declared',
      (tester) async {
    // A const string nothing renders is tree-shaken out of the release bundle.
    await _phone(tester, h: 5000);
    await _seek(tester, find.text('REFERENCE'));
    expect(find.textContaining('Walsh'), findsWidgets);
    expect(find.textContaining('not a scoring system'), findsWidgets);
  });
}
