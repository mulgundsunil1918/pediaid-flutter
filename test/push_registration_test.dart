// =============================================================================
// test/push_registration_test.dart
//
// PushService.shouldRegister decides whether a launch writes a row to Postgres.
//
// Getting it wrong in one direction costs money — the unconditional version
// wrote an identical row on every launch by every signed-in user, which is
// what kept the Neon compute from ever suspending. Getting it wrong in the
// other direction costs a user their notifications, silently, which this app
// has already shipped once. Every uncertain case must therefore answer TRUE,
// and these tests exist mainly to pin that asymmetry.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:pediaid_app/services/push_service.dart';

const _day = 86400000;
const _now = 1757000000000;

bool _should({
  String fp = 'tok|user-1',
  String? last = 'tok|user-1',
  int? lastAt = _now - _day,
  int now = _now,
  bool force = false,
}) =>
    PushService.shouldRegister(
      fingerprint: fp,
      lastFingerprint: last,
      lastAtMillis: lastAt,
      nowMillis: now,
      force: force,
    );

void main() {
  group('the write is skipped only when it would change nothing', () {
    test('same token, same user, registered recently: skip', () {
      expect(_should(), isFalse);
    });

    test('this is the whole saving: repeat launches stop writing', () {
      // Twelve launches in a day, nothing changed between them.
      for (var i = 0; i < 12; i++) {
        expect(_should(lastAt: _now - (i * 3600000)), isFalse,
            reason: 'launch $i wrote a row it did not need to');
      }
    });
  });

  group('every uncertain case registers', () {
    test('never registered before', () {
      expect(_should(last: null), isTrue);
      expect(_should(lastAt: null), isTrue);
    });

    test('the FCM token changed', () {
      expect(_should(last: 'OLD-TOKEN|user-1'), isTrue);
    });

    test('the same device is now a different account', () {
      // The backend stores token -> user. Skipping here would leave personal
      // notifications addressed to the previous account.
      expect(_should(last: 'tok|user-2'), isTrue);
    });

    test('signing in while signed-out registration is on record', () {
      expect(_should(fp: 'tok|user-1', last: 'tok|'), isTrue);
    });

    test('force always registers, however fresh the record', () {
      expect(_should(lastAt: _now, force: true), isTrue);
    });

    test('a backwards clock is not read as "recent"', () {
      // Age would be negative. Treating that as fresh would skip forever.
      expect(_should(lastAt: _now + (30 * _day)), isTrue);
    });
  });

  group('the 7-day safety refresh', () {
    test('6 days is still trusted', () {
      expect(_should(lastAt: _now - (6 * _day)), isFalse);
    });

    test('7 days re-registers', () {
      expect(_should(lastAt: _now - (7 * _day)), isTrue);
    });

    test('a long-dormant install re-registers on next launch', () {
      expect(_should(lastAt: _now - (400 * _day)), isTrue);
    });
  });
}
