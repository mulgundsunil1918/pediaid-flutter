// =============================================================================
// test/rop_screen_render_test.dart
//
// The ROP screen is the widest form in the app — protocol picker, risk-factor
// chips, two eye editors and a treatment block. This pins that it fits a
// 375 px phone in both themes, and that the DRAFT warning is actually on
// screen rather than merely in the code.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pediaid_app/screens/rop/rop_screen.dart';

void main() {
  testWidgets('ROP screen renders on a 375px phone without overflow',
      (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: RopScreen()));
    await tester.pumpAndSettle();

    expect(find.text('ROP Screening & Follow-up'), findsOneWidget);
    expect(find.textContaining('DRAFT clinical content'), findsOneWidget,
        reason: 'the unverified-content warning must be visible');
    expect(tester.takeException(), isNull);

    // Open the examination section — the widest part of the screen. The
    // button sits below the fold on a 375x812 phone, so it must be scrolled
    // into view before tapping or the hit test silently misses.
    final btn = find.text('Full examination');
    await tester.ensureVisible(btn);
    await tester.pumpAndSettle();
    await tester.tap(btn);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'exam mode overflowed');
    // Card titles render uppercased by _card().
    expect(find.text('RIGHT EYE'), findsOneWidget);
    expect(find.text('LEFT EYE'), findsOneWidget);
  });

  testWidgets('dark mode renders too', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData.dark(),
      home: const RopScreen(),
    ));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
