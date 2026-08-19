// Skeleton placeholders shown while list screens load.
//
// These animate with a repeating controller, so `pumpAndSettle` would never
// return — every pump here is a fixed-duration `pump`. That is also the reason
// this lives in its own file rather than in mobile_layout_test.dart, whose
// helper settles.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/widgets/skeleton.dart';

Future<Object?> _renderOnPhone(
  WidgetTester tester,
  Widget w, {
  Brightness brightness = Brightness.light,
}) async {
  tester.view.physicalSize = const Size(375 * 3, 812 * 3);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(MaterialApp(
    theme: ThemeData(brightness: brightness),
    home: Scaffold(body: w),
  ));
  // Advance through the shimmer rather than settling it.
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pump(const Duration(milliseconds: 600));
  return tester.takeException();
}

void main() {
  testWidgets('SkeletonList fits a phone in both themes', (tester) async {
    for (final b in [Brightness.light, Brightness.dark]) {
      final err = await _renderOnPhone(tester, const SkeletonList(items: 8),
          brightness: b);
      expect(err, isNull, reason: 'SkeletonList overflowed in $b');
      expect(find.byType(SkeletonBox), findsWidgets);
    }
  });

  testWidgets('SkeletonBox animates without throwing', (tester) async {
    final err = await _renderOnPhone(
        tester, const Center(child: SkeletonBox(width: 120)));
    expect(err, isNull);
  });

  testWidgets('SkeletonList disposes its controllers cleanly', (tester) async {
    // A repeating controller that outlives its State throws on the next tick,
    // which is how a skeleton turns a slow load into a crash.
    await _renderOnPhone(tester, const SkeletonList(items: 5));
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
  });
}
