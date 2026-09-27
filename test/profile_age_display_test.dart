// =============================================================================
// test/profile_age_display_test.dart
//
// Sunil entered 1996 as a year of birth and the Account screen went on showing
// 24.
//
// Two causes, both mine. The local cache stored an AGE rather than a year — so
// it held whatever number had been typed at some unknown point, decaying by
// one every year — and the profile form never wrote the year into that cache
// at all, so the old value simply survived.
//
// It is the precise failure the code comments had already argued against, in a
// file that then went and stored an age anyway. So these tests check the
// property rather than the plumbing: there must be no stored age ANYWHERE that
// can drift from the year it came from.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/models/app_user.dart';
import 'package:pediaid_app/services/profile_store.dart';

DoctorProfile _p({int? yearOfBirth}) => DoctorProfile(
      fullName: 'Dr A',
      yearOfBirth: yearOfBirth,
      gender: null,
      profileEmoji: '🧑‍⚕️',
      qualifications: const [],
      specialty: 'Paediatrics',
    );

void main() {
  group('the reported bug', () {
    test('1996 reads as the right age, not a stale one', () {
      final expected = DateTime.now().year - 1996;
      expect(_p(yearOfBirth: 1996).age, expected);
      // The number that was actually on screen. Guard against it specifically:
      // it can only reappear if something starts storing an age again.
      expect(_p(yearOfBirth: 1996).age, isNot(24),
          skip: DateTime.now().year - 1996 == 24
              ? 'this year 1996 really is 24'
              : false);
    });

    test('changing the year changes the age immediately', () {
      final a = _p(yearOfBirth: 1996).age!;
      final b = _p(yearOfBirth: 1986).age!;
      expect(b - a, 10);
    });
  });

  group('age is derived in both models, never stored', () {
    test('DoctorProfile', () {
      expect(_p(yearOfBirth: null).age, isNull);
      expect(_p(yearOfBirth: DateTime.now().year - 40).age, 40);
    });

    test('AppUser agrees with DoctorProfile for the same year', () {
      const y = 1990;
      final user = AppUser(
        uid: 'u',
        name: 'Dr A',
        email: 'a@b.com',
        role: UserRole.doctor,
        yearOfBirth: y,
        createdAt: DateTime(2026),
      );
      expect(user.age, _p(yearOfBirth: y).age,
          reason: 'the cache and the authoritative copy must not disagree');
    });

    test('an impossible year yields no age rather than a silly one', () {
      expect(_p(yearOfBirth: 1200).age, isNull);
      expect(_p(yearOfBirth: DateTime.now().year + 5).age, isNull);
    });
  });

  group('the stored form holds a year', () {
    test('toJson writes yearOfBirth and no age', () {
      final json = _p(yearOfBirth: 1996).toJson();
      expect(json['yearOfBirth'], 1996);
      expect(json.containsKey('age'), isFalse,
          reason: 'a stored age is the thing that decayed');
    });

    test('a legacy cache holding an age is converted on read', () {
      // Anyone whose device still has the old shape must not lose the value.
      final p = DoctorProfile.fromJson({
        'fullName': 'Dr A',
        'age': 30,
        'specialty': 'Paediatrics',
      });
      expect(p.yearOfBirth, DateTime.now().year - 30);
      expect(p.age, 30);
    });

    test('the new key wins over a stale legacy age', () {
      final p = DoctorProfile.fromJson({
        'fullName': 'Dr A',
        'age': 24, // the stale value from the bug report
        'yearOfBirth': 1996,
        'specialty': 'Paediatrics',
      });
      expect(p.yearOfBirth, 1996);
      expect(p.age, DateTime.now().year - 1996);
    });

    test('a nonsense legacy age is dropped, not converted', () {
      for (final bad in [0, -5, 500]) {
        final p = DoctorProfile.fromJson({'fullName': 'A', 'age': bad});
        expect(p.yearOfBirth, isNull, reason: '$bad');
      }
    });
  });
}
