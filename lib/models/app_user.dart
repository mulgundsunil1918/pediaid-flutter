import 'package:cloud_firestore/cloud_firestore.dart';

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
  final DateTime createdAt;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    this.avatarEmoji,
    this.specialty,
    required this.createdAt,
  });

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
        'createdAt': Timestamp.fromDate(createdAt),
      };

  AppUser copyWith({
    String? name,
    String? avatarUrl,
    String? avatarEmoji,
    String? specialty,
  }) =>
      AppUser(
        uid: uid,
        name: name ?? this.name,
        email: email,
        role: role,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        avatarEmoji: avatarEmoji ?? this.avatarEmoji,
        specialty: specialty ?? this.specialty,
        createdAt: createdAt,
      );
}
