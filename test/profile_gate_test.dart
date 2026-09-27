// =============================================================================
// test/profile_gate_test.dart
//
// The rule the gate enforces, tested on AppUser where it actually lives.
//
// Sunil installed build 40 expecting to be asked for his details and was not,
// because the form had never been built — only the schema and the migration
// had. So the thing worth pinning is not the widget but the PREDICATE: what
// counts as complete, and what does not.
//
// The versioned half is the part that is easy to get wrong later. Adding a
// field to the mandatory set has to re-ask everyone; if isProfileComplete only
// checked for non-null fields, a profile filled in before the new field
// existed would keep passing and the field would stay empty forever, silently.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/models/app_user.dart';

AppUser _user({
  String name = 'Dr A',
  String? specialty = 'Neonatology',
  int? yearOfBirth = 1985,
  List<String> qualifications = const ['mbbs'],
  int schema = kProfileSchemaVersion,
}) =>
    AppUser(
      uid: 'u1',
      name: name,
      email: 'a@b.com',
      role: UserRole.doctor,
      specialty: specialty,
      yearOfBirth: yearOfBirth,
      qualifications: qualifications,
      profileSchemaVersion: schema,
      createdAt: DateTime(2026),
    );

void main() {
  group('a complete profile passes', () {
    test('every mandatory field present, at the current schema', () {
      expect(_user().isProfileComplete, isTrue);
    });

    test('a future schema version still passes', () {
      // Someone who filled the form on a newer build must not be re-asked by
      // an older one.
      expect(_user(schema: kProfileSchemaVersion + 5).isProfileComplete, isTrue);
    });
  });

  group('each missing field blocks on its own', () {
    test('no name', () => expect(_user(name: '  ').isProfileComplete, isFalse));
    test('no specialty',
        () => expect(_user(specialty: '').isProfileComplete, isFalse));
    test('null specialty',
        () => expect(_user(specialty: null).isProfileComplete, isFalse));
    test('no year of birth',
        () => expect(_user(yearOfBirth: null).isProfileComplete, isFalse));
    test('no qualifications',
        () => expect(_user(qualifications: const []).isProfileComplete, isFalse));
  });

  group('the version is what makes adding a field work', () {
    test('an old profile is incomplete even with every field filled', () {
      // This is the case Sunil hit in reverse: everyone signed in before this
      // existed has schemaVersion 0, and must be asked once.
      final legacy = _user(schema: 0);
      expect(legacy.name.trim(), isNotEmpty);
      expect(legacy.yearOfBirth, isNotNull);
      expect(legacy.isProfileComplete, isFalse,
          reason: 'schemaVersion 0 predates the current mandatory set');
    });

    test('a user who has never seen the form is incomplete', () {
      final fresh = AppUser(
        uid: 'u2',
        name: '',
        email: 'x@y.com',
        role: UserRole.doctor,
        createdAt: DateTime(2026),
      );
      expect(fresh.profileSchemaVersion, 0);
      expect(fresh.isProfileComplete, isFalse);
    });

    test('the current version is 1 — bump it when a field is added', () {
      expect(kProfileSchemaVersion, 1);
    });
  });

  group('email is deliberately NOT part of the check', () {
    test('an Apple relay address does not read as incomplete', () {
      final relay = AppUser(
        uid: 'u3',
        name: 'Dr A',
        email: 'abc123@privaterelay.appleid.com',
        role: UserRole.doctor,
        specialty: 'Paediatrics',
        yearOfBirth: 1985,
        qualifications: const ['mbbs'],
        profileSchemaVersion: kProfileSchemaVersion,
        createdAt: DateTime(2026),
      );
      expect(relay.isProfileComplete, isTrue,
          reason: 'Apple forbids rejecting relay addresses, and the auth '
              'provider always supplies one, so it can never be missing');
    });
  });
}
