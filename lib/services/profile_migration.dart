// =============================================================================
// services/profile_migration.dart
//
// Rescues the profile data that only ever existed on the device.
//
// PediAid collected the same profile through TWO screens that wrote to two
// different places and never read each other:
//
//   ProfileSetupScreen (first install)  -> name, specialty      -> Firestore
//   Account screen     (settings)       -> name, age, gender,
//                                          emoji, qualifications,
//                                          specialty            -> SharedPreferences
//
// So name and specialty existed in both and could disagree, and age, gender
// and qualifications never left the handset. Nobody has ever been able to read
// them, and every reinstall deletes them permanently.
//
// This runs once per install and pushes the local copy up to Firestore, but
// ONLY into fields Firestore has nothing for. The server copy is authoritative
// wherever it has an opinion: it is the one both screens can see, and silently
// overwriting it with a stale device value is exactly the bug this whole piece
// of work exists to end.
//
// Deliberately conservative — it can run against a half-populated document, a
// signed-out user or no network, and do nothing harmful in every case.
// =============================================================================

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';
import 'profile_store.dart';
import 'firebase_auth_service.dart';

/// Set once the local profile has been offered to Firestore.
const String _kMigratedKey = 'profile_local_to_firestore_v1';

/// Result of an attempt, for logging and tests.
enum ProfileMigrationOutcome {
  /// Already done on this install.
  alreadyDone,

  /// No signed-in user, so there is no document to write to. NOT marked done —
  /// the local data is still there and the next signed-in launch retries.
  noUser,

  /// Nothing on the device worth sending.
  nothingLocal,

  /// Firestore already had a value for every field. Marked done.
  serverAlreadyComplete,

  /// Fields were copied up.
  migrated,

  /// The write failed. NOT marked done, so it is retried next launch.
  failed,
}

/// Decides what should be copied up, given both sides.
///
/// Pure, so the precedence rule is testable without Firestore: the server wins
/// wherever it has a value, the device fills the gaps.
@visibleForTesting
Map<String, dynamic> planProfileMigration({
  required DoctorProfile local,
  required AppUser remote,
}) {
  final out = <String, dynamic>{};

  if (remote.name.trim().isEmpty && local.fullName.trim().isNotEmpty) {
    out['name'] = local.fullName.trim();
  }
  if ((remote.specialty?.trim().isEmpty ?? true) &&
      local.specialty.trim().isNotEmpty) {
    out['specialty'] = local.specialty.trim();
  }
  if (remote.avatarEmoji == null && local.profileEmoji.trim().isNotEmpty) {
    out['avatarEmoji'] = local.profileEmoji;
  }
  if (remote.gender == null && (local.gender?.trim().isNotEmpty ?? false)) {
    out['gender'] = local.gender!.trim();
  }
  if (remote.qualifications.isEmpty && local.qualifications.isNotEmpty) {
    // These are free-text values from the old Account screen, not catalogue
    // ids. They are carried across as-is rather than guessed at: a wrong
    // mapping would put a qualification on a doctor who never claimed it.
    // The profile form treats an unrecognised value as "not yet answered",
    // so the user is asked once and the text is replaced by real ids.
    out['legacyQualifications'] = local.qualifications;
  }

  // age -> yearOfBirth. The stored int was correct on the day it was typed and
  // has been decaying ever since, so this is an estimate and is marked as one.
  // Better than discarding it: it still puts the person in the right decade,
  // and the form asks for a real year anyway.
  if (remote.yearOfBirth == null && local.age != null) {
    final age = local.age!;
    if (age > 0 && age < 120) {
      out['yearOfBirth'] = DateTime.now().year - age;
      out['yearOfBirthEstimated'] = true;
    }
  }

  return out;
}

/// Copies device-only profile data into Firestore, once.
///
/// Never throws — a failed migration must not stop the app from starting.
Future<ProfileMigrationOutcome> migrateLocalProfileToFirestore({
  required FirebaseAuthService service,
  required AppUser? currentUser,
  SharedPreferences? prefs,
}) async {
  try {
    final p = prefs ?? await SharedPreferences.getInstance();
    if (p.getBool(_kMigratedKey) ?? false) {
      return ProfileMigrationOutcome.alreadyDone;
    }

    // Not marked done: a signed-out launch must not consume the one attempt.
    if (currentUser == null) return ProfileMigrationOutcome.noUser;

    if (!ProfileStore.instance.isLoaded) {
      await ProfileStore.instance.load();
    }
    final local = ProfileStore.instance.profile;

    final updates = planProfileMigration(local: local, remote: currentUser);
    if (updates.isEmpty) {
      // Either the device had nothing, or the server already knew everything.
      // Both mean there is nothing left to rescue, so stop trying.
      await p.setBool(_kMigratedKey, true);
      return local.fullName.trim().isEmpty
          ? ProfileMigrationOutcome.nothingLocal
          : ProfileMigrationOutcome.serverAlreadyComplete;
    }

    await service.mergeProfileFields(updates);
    await p.setBool(_kMigratedKey, true);
    debugPrint('[profile] rescued ${updates.keys.join(", ")} from the device');
    return ProfileMigrationOutcome.migrated;
  } catch (e) {
    // Left unmarked on purpose, so the next launch tries again.
    debugPrint('[profile] migration failed, will retry next launch: $e');
    return ProfileMigrationOutcome.failed;
  }
}
