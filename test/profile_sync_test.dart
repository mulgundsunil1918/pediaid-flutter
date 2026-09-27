// =============================================================================
// test/profile_sync_test.dart
//
// The gap that let a completed profile never reach the backend.
//
// The profile form shipped at 08:54 and this sync at 09:03. Every profile
// completed in those nine minutes was written to Firestore, never POSTed, and
// never flagged as owing — because the code that sets the flag did not exist
// yet. The retry only ever looked at that flag, so those profiles could not
// catch up, and the analytics dashboard they feed read zero.
//
// The lesson is not "ship them together". It is that a retry keyed on a flag
// only covers failures it witnessed, and says nothing about work that was
// never attempted. A version comparison covers both.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/models/app_user.dart';
import 'package:pediaid_app/services/profile_sync.dart';

AppUser _user({
  int schema = kProfileSchemaVersion,
  List<String> quals = const ['mbbs'],
  int? yob = 1996,
}) =>
    AppUser(
      uid: 'u1',
      name: 'Dr A',
      email: 'a@b.com',
      role: UserRole.doctor,
      specialty: 'Neonatology',
      yearOfBirth: yob,
      qualifications: quals,
      profileSchemaVersion: schema,
      createdAt: DateTime(2026),
    );

void main() {
  group('the payload carries what the dashboard charts', () {
    test('every field the analytics query groups by is present', () {
      final p = profileSyncPayload(_user());
      for (final k in [
        'fullName',
        'specialty',
        'yearOfBirth',
        'gender',
        'qualifications',
        'profileSchemaVersion',
      ]) {
        expect(p.containsKey(k), isTrue, reason: k);
      }
    });

    test('the schema version travels, so the backend can tell complete from '
        'partial', () {
      expect(profileSyncPayload(_user())['profileSchemaVersion'],
          kProfileSchemaVersion);
    });

    test('a year of birth is sent, never an age', () {
      final p = profileSyncPayload(_user(yob: 1996));
      expect(p['yearOfBirth'], 1996);
      expect(p.containsKey('age'), isFalse,
          reason: 'an age would decay in the database as well as on the phone');
    });

    test('qualifications travel as a list, not a joined string', () {
      final p = profileSyncPayload(_user(quals: ['mbbs', 'md_paed']));
      expect(p['qualifications'], ['mbbs', 'md_paed']);
      // The analytics query UNNESTs this column. A joined string would count
      // "mbbs, md_paed" as one qualification nobody holds.
      expect(p['qualifications'], isA<List<String>>());
    });
  });

  group('who the backfill considers', () {
    // ensureProfileSynced short-circuits before touching prefs or the network
    // for these, which is what keeps it free on almost every launch.
    test('an incomplete profile is not sent', () {
      expect(_user(quals: const []).isProfileComplete, isFalse);
    });

    test('a profile from before the current schema is not sent as complete',
        () {
      expect(_user(schema: 0).isProfileComplete, isFalse);
    });

    test('a complete profile is the case that must be sent', () {
      expect(_user().isProfileComplete, isTrue);
    });
  });
}
