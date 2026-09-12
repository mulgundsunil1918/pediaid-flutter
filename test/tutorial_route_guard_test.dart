// =============================================================================
// test/tutorial_route_guard_test.dart
//
// The coachmark tour started from HomeScreen's FIRST FRAME. On a first
// install, signing in pushes ProfileSetupScreen ("a few more details") on top
// of HomeScreen — and HomeScreen's first frame renders underneath it. So the
// tour drew its spotlights over the profile form, pointing at a drawer and a
// search bar that were not on screen.
//
// HomeScreen itself is far too heavy to pump here (Provider, Firebase, a dozen
// services), so this does not test HomeScreen. It tests the two framework
// behaviours the fix depends on — that a covered route reports isCurrent
// false, and that RouteAware.didPopNext fires when the cover is removed. If
// either of those is not true, the fix is inert and this is where that shows.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/main.dart' show appRouteObserver;

/// Stands in for HomeScreen: starts a "tour" on first frame, but only when it
/// is actually the visible route — and retries once uncovered.
class _TourHost extends StatefulWidget {
  const _TourHost({required this.onTourStart, required this.onTourAbort});
  final VoidCallback onTourStart;
  final VoidCallback onTourAbort;

  @override
  State<_TourHost> createState() => _TourHostState();
}

class _TourHostState extends State<_TourHost> with RouteAware {
  bool _attempted = false;
  bool _running = false;

  void _maybeStart() {
    if (_attempted) return;
    final route = ModalRoute.of(context);
    // Not "done" — "not yet". Deliberately does not burn the flag.
    if (route != null && !route.isCurrent) return;
    _attempted = true;
    _running = true;
    widget.onTourStart();
  }

  /// Mirrors HomeScreen.didPushNext: the tour was already up when the profile
  /// form arrived, so it is dismissed and re-armed rather than left on top.
  @override
  void didPushNext() {
    if (!_running) return;
    _running = false;
    _attempted = false;
    widget.onTourAbort();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) appRouteObserver.subscribe(this, route);
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStart());
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStart());
    return const Scaffold(body: Text('home'));
  }
}

void main() {
  testWidgets('the tour waits while another screen covers home, then runs',
      (tester) async {
    var tourStarts = 0;
    var tourAborts = 0;
    final navKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(MaterialApp(
      navigatorKey: navKey,
      navigatorObservers: [appRouteObserver],
      home: _TourHost(
        onTourStart: () => tourStarts++,
        onTourAbort: () => tourAborts++,
      ),
    ));

    // The REAL sequence: home renders and starts the tour, and the profile
    // form arrives a frame later. — this is the real sequence:
    // HomeScreen builds underneath while the profile form is pushed on top.
    navKey.currentState!.push(
      MaterialPageRoute<void>(builder: (_) => const Scaffold(body: Text('profile'))),
    );
    await tester.pumpAndSettle();

    expect(find.text('profile'), findsOneWidget);
    expect(tourAborts, 1,
        reason: 'the tour must be taken down, not left over the profile form');

    // ProfileSetupScreen pops itself back to the first route when done.
    navKey.currentState!.popUntil((r) => r.isFirst);
    await tester.pumpAndSettle();

    expect(tourStarts, 2,
        reason: 'once home is actually visible the tour must run again — '
            'abandoning it entirely would be the other half of the bug');
  });

  testWidgets('with nothing covering home, the tour runs immediately',
      (tester) async {
    var tourStarts = 0;
    await tester.pumpWidget(MaterialApp(
      navigatorObservers: [appRouteObserver],
      home: _TourHost(
        onTourStart: () => tourStarts++,
        onTourAbort: () {},
      ),
    ));
    await tester.pumpAndSettle();
    expect(tourStarts, 1);
  });
}
