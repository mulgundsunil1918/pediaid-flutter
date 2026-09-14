// =============================================================================
// test/sign_out_test.dart
//
// Pressing Sign out has to actually sign you out.
//
// It did not, from Settings. There were two Sign out buttons: Account went
// through AuthProvider.signOut(), which signs out of Firebase, clears the
// legacy JWT session, nulls the current user and notifies the listeners
// _AuthGate watches. Settings → Danger zone called AuthService.logout() alone,
// which clears the legacy tokens and nothing else — Firebase stayed signed in,
// _currentUser stayed populated, the gate was never told, and the app stayed
// put. The FAQ sends people to that button.
//
// So these tests are less about the happy path than about the three things that
// must happen TOGETHER, and the fact that one entry point did only one of them.
// =============================================================================

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:pediaid_app/providers/auth_provider.dart';
import 'package:pediaid_app/screens/auth/sign_out_flow.dart';

/// Records what the flow asked of the provider.
class _SpyAuthProvider extends ChangeNotifier implements AuthProvider {
  int signOutCalls = 0;
  bool notified = false;

  @override
  Future<void> signOut() async {
    signOutCalls++;
    notified = true;
    notifyListeners();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _host(_SpyAuthProvider spy, {required GlobalKey<NavigatorState> nav}) {
  return ChangeNotifierProvider<AuthProvider>.value(
    value: spy,
    child: MaterialApp(
      navigatorKey: nav,
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => confirmAndSignOut(context),
              child: const Text('Sign out'),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('confirming signs out through the provider', (tester) async {
    final spy = _SpyAuthProvider();
    final nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(_host(spy, nav: nav));

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Sign out?'), findsOneWidget, reason: 'confirmation first');

    // The dialog's own button, not the page's.
    await tester.tap(find.widgetWithText(FilledButton, 'Sign out'));
    await tester.pumpAndSettle();

    expect(spy.signOutCalls, 1,
        reason: 'must go through AuthProvider.signOut, which does Firebase, '
            'the legacy session AND the provider state together');
    expect(spy.notified, isTrue,
        reason: '_AuthGate only swaps to LoginScreen when it is notified');
  });

  testWidgets('cancelling signs nobody out', (tester) async {
    final spy = _SpyAuthProvider();
    final nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(_host(spy, nav: nav));

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    expect(spy.signOutCalls, 0);
    expect(find.text('Sign out?'), findsNothing);
  });

  testWidgets('pushed screens are unwound, not left on top', (tester) async {
    // The gate swaps its own child, but anything pushed above it would still
    // be sitting there showing a signed-in screen.
    final spy = _SpyAuthProvider();
    final nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(_host(spy, nav: nav));

    nav.currentState!.push(MaterialPageRoute<void>(
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => confirmAndSignOut(context),
            child: const Text('Sign out from a pushed page'),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Sign out from a pushed page'), findsOneWidget);

    await tester.tap(find.text('Sign out from a pushed page'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Sign out'));
    await tester.pumpAndSettle();

    expect(spy.signOutCalls, 1);
    expect(find.text('Sign out from a pushed page'), findsNothing,
        reason: 'the stack must unwind to the gate');
  });

  test('both entry points call the one shared flow', () async {
    // A source-level check, because the defect was not that either screen was
    // wrong in isolation — it was that there were two implementations of one
    // action and only one of them was complete.
    // Comments stripped: the doc comment on the fixed method NAMES the old
    // broken call to explain the history, and matching that would fail on
    // exactly the file that was fixed.
    Future<String> read(String p) async {
      final raw = await File(p).readAsString();
      return raw
          .split('\n')
          .where((l) => !l.trimLeft().startsWith('//'))
          .join('\n');
    }

    final settings =
        await read('lib/screens/settings/settings_screen.dart');
    final account = await read('lib/screens/account_screen.dart');

    for (final entry in {
      'settings': settings,
      'account': account,
    }.entries) {
      expect(entry.value, contains('confirmAndSignOut(context)'),
          reason: '${entry.key} must use the shared flow');
      expect(entry.value, isNot(contains('AuthService.instance.logout()')),
          reason: '${entry.key} must not clear the legacy session alone — '
              'that is exactly what left users signed in');
    }
  });
}
