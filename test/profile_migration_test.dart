// =============================================================================
// test/profile_migration_test.dart
//
// The rescue that moves device-only profile data into Firestore.
//
// The whole risk here is precedence. Age, gender and qualifications exist ONLY
// on the handset — if this drops them, they are gone for good. But name and
// specialty exist on BOTH sides and can disagree, and pushing a stale device
// value over a newer server one would recreate the exact divergence this work
// is meant to end.
//
// So: the server wins wherever it has an opinion, the device fills the gaps,
// and neither rule is allowed to drift.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/models/app_user.dart';
import 'package:pediaid_app/services/profile_migration.dart';
import 'package:pediaid_app/services/profile_store.dart';

AppUser _remote({
  String name = '',
  String? specialty,
  String? avatarEmoji,
  String? gender,
  List<String> qualifications = const [],
  int? yearOfBirth,
}) =>
    AppUser(
      uid: 'u1',
      name: name,
      email: 'a@b.com',
      role: UserRole.doctor,
      specialty: specialty,
      avatarEmoji: avatarEmoji,
      gender: gender,
      qualifications: qualifications,
      yearOfBirth: yearOfBirth,
      createdAt: DateTime(2026, 1, 1),
    );

DoctorProfile _local({
  String fullName = '',
  int? age,
  String? gender,
  String profileEmoji = '',
  List<String> qualifications = const [],
  String specialty = '',
}) =>
    DoctorProfile(
      fullName: fullName,
      age: age,
      gender: gender,
      profileEmoji: profileEmoji,
      qualifications: qualifications,
      specialty: specialty,
    );

void main() {
  group('the server wins wherever it has a value', () {
    test('a name already in Firestore is never overwritten', () {
      final plan = planProfileMigration(
        local: _local(fullName: 'Old Device Name'),
        remote: _remote(name: 'Current Name'),
      );
      expect(plan.containsKey('name'), isFalse,
          reason: 'overwriting the server copy recreates the divergence');
    });

    test('a specialty already in Firestore is never overwritten', () {
      final plan = planProfileMigration(
        local: _local(specialty: 'Neonatology'),
        remote: _remote(name: 'X', specialty: 'Paediatrics'),
      );
      expect(plan.containsKey('specialty'), isFalse);
    });

    test('an empty string on the server counts as no value', () {
      // '' is what a skipped setup screen leaves behind — a gap, not a choice.
      final plan = planProfileMigration(
        local: _local(fullName: 'Dr Real', specialty: 'Neonatology'),
        remote: _remote(name: '   ', specialty: '  '),
      );
      expect(plan['name'], 'Dr Real');
      expect(plan['specialty'], 'Neonatology');
    });
  });

  group('device-only fields are rescued', () {
    test('gender, emoji and qualifications come across', () {
      final plan = planProfileMigration(
        local: _local(
          gender: 'Female',
          profileEmoji: '👩‍⚕️',
          qualifications: ['MBBS', 'MD Paediatrics'],
        ),
        remote: _remote(name: 'Dr A'),
      );
      expect(plan['gender'], 'Female');
      expect(plan['avatarEmoji'], '👩‍⚕️');
      expect(plan['legacyQualifications'], ['MBBS', 'MD Paediatrics']);
    });

    test('old free-text qualifications are NOT guessed into catalogue ids', () {
      // Mapping "MD Paediatrics" onto md_paed looks safe and is not: the same
      // guess applied to "MD" or "Fellowship" would attribute a qualification
      // the person never claimed.
      final plan = planProfileMigration(
        local: _local(qualifications: ['MD']),
        remote: _remote(name: 'Dr A'),
      );
      expect(plan.containsKey('qualifications'), isFalse);
      expect(plan['legacyQualifications'], ['MD']);
    });

    test('nothing is sent for a field the server already has', () {
      final plan = planProfileMigration(
        local: _local(gender: 'Male', qualifications: ['MBBS']),
        remote: _remote(name: 'Dr A', gender: 'Female', qualifications: ['mbbs']),
      );
      expect(plan.containsKey('gender'), isFalse);
      expect(plan.containsKey('legacyQualifications'), isFalse);
    });
  });

  group('age becomes a year of birth, and says that it is a guess', () {
    test('a stored age is converted and flagged estimated', () {
      final plan = planProfileMigration(
        local: _local(age: 40),
        remote: _remote(name: 'Dr A'),
      );
      expect(plan['yearOfBirth'], DateTime.now().year - 40);
      expect(plan['yearOfBirthEstimated'], isTrue,
          reason: 'the stored age had been decaying since the day it was typed');
    });

    test('an implausible age is discarded rather than stored', () {
      for (final bad in [0, -3, 200]) {
        final plan = planProfileMigration(
          local: _local(age: bad),
          remote: _remote(name: 'Dr A'),
        );
        expect(plan.containsKey('yearOfBirth'), isFalse, reason: '$bad');
      }
    });

    test('a year already on the server is left alone', () {
      final plan = planProfileMigration(
        local: _local(age: 40),
        remote: _remote(name: 'Dr A', yearOfBirth: 1990),
      );
      expect(plan.containsKey('yearOfBirth'), isFalse);
    });
  });

  group('the no-op cases', () {
    test('an empty device profile plans nothing', () {
      expect(planProfileMigration(local: _local(), remote: _remote(name: 'A')),
          isEmpty);
    });

    test('a fully populated server plans nothing', () {
      final plan = planProfileMigration(
        local: _local(
          fullName: 'Dr A',
          age: 40,
          gender: 'Male',
          profileEmoji: '🧑‍⚕️',
          qualifications: ['MBBS'],
          specialty: 'Neonatology',
        ),
        remote: _remote(
          name: 'Dr A',
          specialty: 'Neonatology',
          avatarEmoji: '🧑‍⚕️',
          gender: 'Male',
          qualifications: ['mbbs'],
          yearOfBirth: 1986,
        ),
      );
      expect(plan, isEmpty);
    });
  });

  group('age is derived, never stored', () {
    test('AppUser.age computes from the year', () {
      final u = _remote(name: 'A', yearOfBirth: DateTime.now().year - 33);
      expect(u.age, 33);
    });

    test('no year means no age, not zero', () {
      expect(_remote(name: 'A').age, isNull);
    });

    test('a nonsense year does not produce a nonsense age', () {
      expect(_remote(name: 'A', yearOfBirth: 1200).age, isNull);
      expect(_remote(name: 'A', yearOfBirth: 3000).age, isNull);
    });
  });
}
