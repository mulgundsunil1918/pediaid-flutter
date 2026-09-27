// =============================================================================
// lib/services/profile_store.dart
//
// Extended doctor profile persisted locally in SharedPreferences. This
// deliberately stays on the device rather than going to the backend in v1:
//   - it lets the AccountScreen ship today without a new DB migration
//   - the user's identity (email + access token) is still authoritative
//     in the backend via AuthService
//
// Fields captured here:
//   - fullName       (string, defaults to the name on the auth blob)
//   - age            (int, optional)
//   - gender         (string, optional — Male/Female/Other/Prefer not to say)
//   - profileEmoji   (single emoji as the avatar image)
//   - qualifications (list of strings, e.g. ['MBBS', 'MD (Paediatrics)'])
//   - specialty      (string, defaults to 'Paediatrics')
//
// Updates notify listeners so the AccountScreen header refreshes in place.
// =============================================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Static lists used by the AccountScreen dropdowns / chips
// ---------------------------------------------------------------------------

/// Indian medical specialties relevant to PediAid. Paediatrics-focused
/// sub-specialties come first because the app's audience is mostly
/// paediatricians; general specialties follow.
const List<String> kMedicalSpecialties = [
  // Paediatrics core
  'Paediatrics',
  'Neonatology',
  // Paediatric sub-specialties
  'Paediatric Cardiology',
  'Paediatric Nephrology',
  'Paediatric Pulmonology',
  'Paediatric Neurology',
  'Paediatric Endocrinology',
  'Paediatric Gastroenterology',
  'Paediatric Hepatology',
  'Paediatric Hematology & Oncology',
  'Paediatric Infectious Diseases',
  'Paediatric Rheumatology',
  'Paediatric Allergy & Immunology',
  'Paediatric Emergency Medicine',
  'Paediatric Critical Care',
  'Paediatric Surgery',
  'Paediatric Orthopaedics',
  'Paediatric Genetics',
  'Developmental Paediatrics',
  'Adolescent Medicine',
  // General adult specialties
  'General Medicine',
  'Family Medicine',
  'Obstetrics & Gynaecology',
  'Internal Medicine',
  'General Surgery',
  'Anaesthesiology',
  'Radiology',
  'Pathology',
  'Psychiatry',
  'Community Medicine',
  'Other',
];

/// Common qualifications held by Indian paediatricians. Users tick which
/// apply; the list on the card shows only the ticked ones.
const List<String> kCommonQualifications = [
  'MBBS',
  'MD (Paediatrics)',
  'DNB (Paediatrics)',
  'DCH',
  'MRCPCH',
  'FRCPCH',
  'DM (Neonatology)',
  'DM (Paediatric Cardiology)',
  'DM (Paediatric Nephrology)',
  'DM (Paediatric Neurology)',
  'DM (Paediatric Gastroenterology)',
  'DM (Paediatric Critical Care)',
  'DM (Paediatric Haemato-Oncology)',
  'Fellowship (NNF)',
  'Fellowship (IAP)',
  'PhD',
];

/// Gender options offered in the dropdown. Keeping 'Prefer not to say' to
/// avoid forcing the user to disclose.
const List<String> kGenderOptions = [
  'Male',
  'Female',
  'Other',
  'Prefer not to say',
];

/// Curated emoji set for the avatar picker. A mix of doctors, faces, and
/// neutral placeholders so readers/students/doctors all have something
/// that feels like them without a photo upload step.
const List<String> kProfileEmojis = [
  '🧑‍⚕️', '👨‍⚕️', '👩‍⚕️', '🩺', '💉', '🧬',
  '🫀', '🧠', '👶', '🍼', '🌡️', '💊',
  '😀', '😎', '🤓', '🥼', '🦸', '🦸‍♀️',
];

// ---------------------------------------------------------------------------
// Data class
// ---------------------------------------------------------------------------

class DoctorProfile {
  final String fullName;

  /// Year of birth, not age.
  ///
  /// This field WAS `int? age`, and that is exactly how it went wrong: the
  /// profile form wrote a year of birth to Firestore while this cache kept the
  /// age it had been holding for however long, so entering 1996 left the
  /// Account screen still reading 24. A stored age is correct on the day it is
  /// typed and decays silently every year after, and nothing tells you it has.
  ///
  /// [age] is derived from this now, so the two cannot disagree.
  final int? yearOfBirth;

  final String? gender;
  final String profileEmoji;
  final List<String> qualifications;
  final String specialty;

  const DoctorProfile({
    required this.fullName,
    required this.yearOfBirth,
    required this.gender,
    required this.profileEmoji,
    required this.qualifications,
    required this.specialty,
  });

  /// Age today. Null when no year is recorded, and null rather than a silly
  /// number when the stored year cannot be right.
  int? get age {
    if (yearOfBirth == null) return null;
    final years = DateTime.now().year - yearOfBirth!;
    return (years < 0 || years > 120) ? null : years;
  }

  DoctorProfile copyWith({
    String? fullName,
    int? yearOfBirth,
    bool clearYearOfBirth = false,
    String? gender,
    bool clearGender = false,
    String? profileEmoji,
    List<String>? qualifications,
    String? specialty,
  }) {
    return DoctorProfile(
      fullName: fullName ?? this.fullName,
      yearOfBirth:
          clearYearOfBirth ? null : (yearOfBirth ?? this.yearOfBirth),
      gender: clearGender ? null : (gender ?? this.gender),
      profileEmoji: profileEmoji ?? this.profileEmoji,
      qualifications: qualifications ?? this.qualifications,
      specialty: specialty ?? this.specialty,
    );
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'yearOfBirth': yearOfBirth,
        'gender': gender,
        'profileEmoji': profileEmoji,
        'qualifications': qualifications,
        'specialty': specialty,
      };

  factory DoctorProfile.fromJson(Map<String, dynamic> json) {
    return DoctorProfile(
      fullName: (json['fullName'] as String?) ?? '',
      // Reads the new key, and falls back to converting the legacy `age` for
      // anyone whose cache predates this. The conversion is an estimate — the
      // stored age had been decaying for an unknown time — but it puts them in
      // the right decade and the form asks for a real year anyway.
      yearOfBirth: (json['yearOfBirth'] as num?)?.toInt() ??
          (() {
            final legacy = (json['age'] as num?)?.toInt();
            if (legacy == null || legacy <= 0 || legacy > 120) return null;
            return DateTime.now().year - legacy;
          })(),
      gender: json['gender'] as String?,
      profileEmoji: (json['profileEmoji'] as String?) ?? '🧑‍⚕️',
      qualifications: ((json['qualifications'] as List<dynamic>?) ?? const [])
          .whereType<String>()
          .toList(),
      specialty: (json['specialty'] as String?) ?? 'Paediatrics',
    );
  }

  static const empty = DoctorProfile(
    fullName: '',
    yearOfBirth: null,
    gender: null,
    profileEmoji: '🧑‍⚕️',
    qualifications: [],
    specialty: 'Paediatrics',
  );
}

// ---------------------------------------------------------------------------
// Store singleton
// ---------------------------------------------------------------------------

class ProfileStore extends ChangeNotifier {
  ProfileStore._();
  static final ProfileStore instance = ProfileStore._();

  static const _kPrefKey = 'pediaid_doctor_profile_v1';

  DoctorProfile _profile = DoctorProfile.empty;
  bool _loaded = false;

  DoctorProfile get profile => _profile;
  bool get isLoaded => _loaded;

  Future<void> load({String? fallbackFullName}) async {
    if (_loaded) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kPrefKey);
      if (raw != null && raw.isNotEmpty) {
        _profile = DoctorProfile.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      } else if (fallbackFullName != null) {
        _profile = DoctorProfile.empty.copyWith(fullName: fallbackFullName);
      }
    } catch (e) {
      debugPrint('[ProfileStore] load failed: $e');
    } finally {
      _loaded = true;
      notifyListeners();
    }
  }

  Future<void> save(DoctorProfile next) async {
    _profile = next;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kPrefKey, jsonEncode(next.toJson()));
    } catch (e) {
      debugPrint('[ProfileStore] save failed: $e');
    }
  }
}
