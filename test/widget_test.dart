// Smoke test: does the app build and lay out its first frame without throwing?
//
// This was failing permanently with ProviderNotFoundException because it pumped
// PediAidApp bare, while main() wraps it in a MultiProvider supplying
// AuthProvider and ThemeProvider. A test that can never pass is worse than no
// test — `flutter test` always reported a failure, so a real regression would
// have been indistinguishable from the usual noise.
//
// It also asserted find.text('PediAid'), which was already fragile and is now
// simply wrong: the app opens behind an onboarding gate and a config gate, so
// the first frame is a loading state rather than the home screen. "Builds
// without throwing" is what a smoke test is actually for, and it is the
// assertion that would have caught the provider bug on day one.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pediaid_app/main.dart';
import 'package:pediaid_app/providers/auth_provider.dart';
import 'package:pediaid_app/theme/theme_provider.dart';

void main() {
  setUp(() {
    // The onboarding gate reads prefs on its first frame; without this the
    // plugin channel is missing and the failure looks like an app bug.
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('App builds its first frame without throwing', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const PediAidApp(),
      ),
    );

    // One frame only. pumpAndSettle would wait on the config fetch and the auth
    // stream, neither of which ever resolves in a unit-test environment.
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
