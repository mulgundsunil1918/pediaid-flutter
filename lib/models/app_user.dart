import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum UserRole { doctor, nurse, admin }

UserRole _roleFromString(String? v) {
  switch (v) {
    case 'doctor':
      return UserRole.doctor;
    case 'admin':
      return UserRole.admin;
    default:
      return UserRole.nurse;
  }
}

class AppUser {
  final String uid;
  final String name;
  final String email;
  final UserRole role;
  final String? avatarUrl;
  final String? avatarEmoji;
  final String? specialty;

  /// Year of birth, not age.
  ///
  /// The profile used to store a bare `age` int, which was true the day it was
  /// typed and wrong a year later — a field that silently decays is worse than
  /// no field, because nothing tells you it has rotted. Age is computed at
  /// display time from this.
  final int? yearOfBirth;
  final String? gender;

  /// Ids from [kQualificationGroups]. Multi-select: a paediatrician typically
  /// holds MBBS *and* MD *and* often a superspecialty.
  final List<String> qualifications;

  /// Which version of the profile form this document was last completed
  /// against. Anyone below [kProfileSchemaVersion] is asked again, prefilled
  /// with what is already known — that is what makes adding a field a
  /// re-collection rather than a silent gap.
  final int profileSchemaVersion;

  final DateTime createdAt;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    this.avatarEmoji,
    this.specialty,
    this.yearOfBirth,
    this.gender,
    this.qualifications = const [],
    this.profileSchemaVersion = 0,
    required this.createdAt,
  });

  /// A minimal profile built straight from the Firebase auth user, for when
  /// the Firestore profile document can't be read (rules mid-propagation, a
  /// transient error, a cold start). Sign-in has already succeeded by the time
  /// this is used, so the app treats the person as signed in with whatever the
  /// auth token already carries — name and email — rather than failing the
  /// whole login over an unreadable side document.
  factory AppUser.fromFirebaseUser(User u) => AppUser(
    uid: u.uid,
    name: u.displayName ?? (u.email ?? 'User').split('@').first,
    email: u.email ?? '',
    role: UserRole.doctor,
    avatarUrl: u.photoURL,
    createdAt: u.metadata.creationTime ?? DateTime.now(),
  );

  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return AppUser(
      uid: doc.id,
      name: (d['name'] as String?) ?? '',
      email: (d['email'] as String?) ?? '',
      role: _roleFromString(d['role'] as String?),
      avatarUrl: d['avatarUrl'] as String?,
      avatarEmoji: d['avatarEmoji'] as String?,
      specialty: d['specialty'] as String?,
      yearOfBirth: (d['yearOfBirth'] as num?)?.toInt(),
      gender: d['gender'] as String?,
      // Defensive: this field is written by more than one client and a
      // hand-edited document in the console is a real possibility.
      qualifications:
          (d['qualifications'] as List?)?.whereType<String>().toList() ??
          const [],
      profileSchemaVersion: (d['profileSchemaVersion'] as num?)?.toInt() ?? 0,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'role': role.name,
    if (avatarUrl != null) 'avatarUrl': avatarUrl,
    if (avatarEmoji != null) 'avatarEmoji': avatarEmoji,
    if (specialty != null) 'specialty': specialty,
    if (yearOfBirth != null) 'yearOfBirth': yearOfBirth,
    if (gender != null) 'gender': gender,
    if (qualifications.isNotEmpty) 'qualifications': qualifications,
    'profileSchemaVersion': profileSchemaVersion,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  AppUser copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    String? avatarEmoji,
    String? specialty,
    int? yearOfBirth,
    String? gender,
    List<String>? qualifications,
    int? profileSchemaVersion,
  }) => AppUser(
    uid: uid,
    name: name ?? this.name,
    email: email ?? this.email,
    role: role,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    avatarEmoji: avatarEmoji ?? this.avatarEmoji,
    specialty: specialty ?? this.specialty,
    yearOfBirth: yearOfBirth ?? this.yearOfBirth,
    gender: gender ?? this.gender,
    qualifications: qualifications ?? this.qualifications,
    profileSchemaVersion: profileSchemaVersion ?? this.profileSchemaVersion,
    createdAt: createdAt,
  );

  /// Age today, derived rather than stored. Null when no year is recorded.
  int? get age {
    if (yearOfBirth == null) return null;
    final years = DateTime.now().year - yearOfBirth!;
    return (years < 0 || years > 120) ? null : years;
  }

  /// Whether this profile satisfies the current mandatory set.
  ///
  /// Email is not checked: it always arrives from the auth provider, so it
  /// cannot be missing, and checking it would make a relay address look like
  /// an incomplete profile.
  bool get isProfileComplete =>
      profileSchemaVersion >= kProfileSchemaVersion &&
      name.trim().isNotEmpty &&
      yearOfBirth != null &&
      (specialty?.trim().isNotEmpty ?? false) &&
      qualifications.isNotEmpty;
}

/// Bump this whenever a field is added to the mandatory set. Every profile
/// below it is asked to complete the form again, prefilled.
const int kProfileSchemaVersion = 1;
