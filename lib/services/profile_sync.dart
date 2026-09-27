// =============================================================================
// services/profile_sync.dart
//
// Copies the profile from Firestore into the Academics backend.
//
// Firestore is authoritative and is written first — it is the identity store,
// it works whenever the user is signed in, and it survives reinstalls. But the
// admin dashboard is React reading Postgres through this backend, and it
// cannot see Firestore at all. Without this, everything collected by the
// profile form would be invisible on the screen built to report on it.
//
// Deliberately NOT part of saving. The form's job is done once Firestore has
// the data; if this fails the user must not be told their profile did not
// save, because it did. Instead a dirty flag is set and the next launch
// retries. Worst case the dashboard is one launch behind, which is a far
// better failure than a form that refuses to complete because a second
// service was briefly unreachable.
// =============================================================================

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';
import 'auth_service.dart';

/// Set when a sync is owed. Holds the payload, so a retry does not need the
/// user object to still be in memory.
const String _kPendingKey = 'profile_sync_pending_v1';

/// The schema version this device last got accepted by the backend.
///
/// The pending flag alone was not enough, and the gap showed up within the
/// hour: the form shipped at 08:54 and this sync at 09:03, so every profile
/// completed in between was written to Firestore, never POSTed, and never
/// flagged as owing — because the code that would have flagged it did not
/// exist yet. Those profiles could never catch up.
///
/// Comparing versions instead of trusting a flag makes it self-healing: any
/// profile the backend has not confirmed at the current version is sent, no
/// matter why it was missed.
const String _kSyncedVersionKey = 'profile_synced_version_v1';

/// Builds the payload the backend's PUT /me expects.
@visibleForTesting
Map<String, dynamic> profileSyncPayload(AppUser u) => {
  'fullName': u.name,
  'specialty': u.specialty ?? '',
  'yearOfBirth': u.yearOfBirth,
  'gender': u.gender,
  'qualifications': u.qualifications,
  'profileSchemaVersion': u.profileSchemaVersion,
};

/// Sends the profile, or records that it still needs sending.
///
/// Never throws.
Future<bool> syncProfileToBackend(AppUser user, {http.Client? client}) async {
  final payload = profileSyncPayload(user);
  final ok = await _post(payload, client: client);
  final prefs = await SharedPreferences.getInstance();
  if (ok) {
    await prefs.remove(_kPendingKey);
    await prefs.setInt(_kSyncedVersionKey, user.profileSchemaVersion);
  } else {
    await prefs.setString(_kPendingKey, jsonEncode(payload));
  }
  return ok;
}

/// Sends the profile if the backend has not confirmed this version of it.
///
/// Called at boot with whatever user the app hydrated. Cheap when there is
/// nothing to do — one SharedPreferences read and no network — and it is the
/// only thing that rescues a profile saved before this file existed.
Future<void> ensureProfileSynced(AppUser? user, {http.Client? client}) async {
  try {
    if (user == null || !user.isProfileComplete) return;
    final prefs = await SharedPreferences.getInstance();
    final synced = prefs.getInt(_kSyncedVersionKey) ?? 0;
    if (synced >= user.profileSchemaVersion) return;
    final ok = await syncProfileToBackend(user, client: client);
    debugPrint('[profile] backfill sync ${ok ? "sent" : "deferred"}');
  } catch (e) {
    debugPrint('[profile] backfill sync failed: $e');
  }
}

/// Retries a sync left owing by an earlier launch.
///
/// Called from boot, fire-and-forget. A no-op when nothing is pending, so it
/// costs one SharedPreferences read on the overwhelming majority of launches
/// and never touches the network.
Future<void> retryPendingProfileSync({http.Client? client}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kPendingKey);
    if (raw == null) return;
    final payload = jsonDecode(raw) as Map<String, dynamic>;
    if (await _post(payload, client: client)) {
      await prefs.remove(_kPendingKey);
      debugPrint('[profile] pending sync cleared');
    }
  } catch (e) {
    debugPrint('[profile] pending sync retry failed: $e');
  }
}

Future<bool> _post(Map<String, dynamic> payload, {http.Client? client}) async {
  final token = AuthService.instance.accessToken;
  // No legacy session yet — the bridge may not have landed. Not an error, and
  // not a reason to drop the payload: it stays pending and goes next launch.
  if (token == null || token.isEmpty) return false;

  final c = client ?? http.Client();
  try {
    final res = await c
        .put(
          Uri.parse('${AuthService.apiBase}/api/academics/me'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(payload),
        )
        .timeout(const Duration(seconds: 15));
    return res.statusCode >= 200 && res.statusCode < 300;
  } catch (e) {
    debugPrint('[profile] sync failed: $e');
    return false;
  } finally {
    if (client == null) c.close();
  }
}
