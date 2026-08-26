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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pediaid_app/screens/rop/rop_screen.dart';

void main() {
  // The screen loads its history on init, so the store has to exist.
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('ROP screen renders on a 375px phone without overflow',
      (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: RopScreen()));
    await tester.pumpAndSettle();

    expect(find.text('ROP Screening & Follow-up'), findsOneWidget);
    // Protocols are now source-verified, so the banner names the document and
    // date rather than warning about draft content — but it must still be on
    // screen, because spec §73's clinical sign-off is a separate step.
    expect(find.textContaining('transcribed from the source guideline'),
        findsOneWidget,
        reason: 'provenance must be visible, not buried in code');
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

    // Spec §51: the classification reference must be rendered, not merely
    // declared. A const that nothing displays is tree-shaken out of the
    // release bundle, which is how this was missed the first time.
    expect(find.textContaining('Early Treatment for Retinopathy'),
        findsOneWidget,
        reason: 'the ETROP citation must be on screen');

    // §62/§63 — the clinician note and the save control are part of the exam.
    expect(find.text('CLINICIAN NOTES'), findsOneWidget);
    expect(find.text('Save examination'), findsOneWidget);
    // §65 — the privacy promise is stated where the reference field is.
    expect(find.textContaining('No name, phone or address'), findsOneWidget);
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
