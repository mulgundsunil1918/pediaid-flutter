// =============================================================================
// services/app_config_service.dart
//
// The remote lever for when something is wrong with a released build.
//
// Every dose, every calculator constant and every reference table is compiled
// into the app as a bundled asset. So if a wrong dose ships, the only recourse
// is: build, submit, wait for store review, and then wait for each user to
// update — which many never do. Someone could keep using an incorrect
// paediatric dose indefinitely, and there would be no way to warn them or stop
// it. For a dosing app that is not an acceptable position to be in.
//
// This gives three levers without a store release:
//   • minVersion    — block builds at or below a known-bad version
//   • disabledTools — take a single calculator out of service
//   • notice        — show a message at the top of the app
//
// Hosted as a static file on the same GitHub Pages site as the web build, not
// on the API. Render's free tier sleeps and can take 30s to wake; making app
// launch wait on that would be a self-inflicted outage. A static file is
// CDN-served, needs no backend, and can be edited from GitHub's web UI in
// under a minute during an incident.
//
// FAILS OPEN, always. Offline, 404, malformed JSON, slow network — every one
// of those leaves the app fully usable. A safety mechanism that bricks the app
// when the network is unavailable would cause far more harm than the rare bad
// release it exists to contain.
// =============================================================================

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class AppConfig {
  const AppConfig({
    this.minVersion,
    this.disabledTools = const <String>{},
    this.notice,
    this.noticeUrl,
  });

  /// Builds strictly below this must not be used. Null disables the check.
  final String? minVersion;

  /// Tool ids taken out of service, e.g. {'tpn-calculator'}.
  final Set<String> disabledTools;

  /// Message shown at the top of the app. Null shows nothing.
  final String? notice;

  /// Optional link for the notice ("read more", "see correction").
  final String? noticeUrl;

  static const empty = AppConfig();

  factory AppConfig.fromJson(Map<String, dynamic> j) => AppConfig(
        minVersion: j['minVersion'] as String?,
        disabledTools: ((j['disabledTools'] as List<dynamic>?) ?? const [])
            .whereType<String>()
            .toSet(),
        notice: j['notice'] as String?,
        noticeUrl: j['noticeUrl'] as String?,
      );
}

/// Compares dotted versions numerically: 1.10.0 is newer than 1.9.0, which
/// string comparison gets backwards.
@visibleForTesting
int compareVersions(String a, String b) {
  List<int> parts(String v) => v
      .split('+')
      .first
      .split('.')
      .map((p) => int.tryParse(p.trim()) ?? 0)
      .toList();
  final pa = parts(a), pb = parts(b);
  final len = pa.length > pb.length ? pa.length : pb.length;
  for (var i = 0; i < len; i++) {
    final x = i < pa.length ? pa[i] : 0;
    final y = i < pb.length ? pb[i] : 0;
    if (x != y) return x.compareTo(y);
  }
  return 0;
}

class AppConfigService {
  AppConfigService._();
  static final AppConfigService instance = AppConfigService._();

  static const _url = 'https://pediaid.bridgr.co.in/app-config.json';

  AppConfig _config = AppConfig.empty;
  AppConfig get config => _config;

  String _version = '';
  String get currentVersion => _version;

  /// True when this build is older than the configured minimum.
  bool get updateRequired {
    final min = _config.minVersion;
    if (min == null || min.isEmpty || _version.isEmpty) return false;
    return compareVersions(_version, min) < 0;
  }

  bool isToolDisabled(String toolId) => _config.disabledTools.contains(toolId);

  /// Loads the config. Never throws, never blocks longer than the timeout.
  Future<void> load() async {
    try {
      final info = await PackageInfo.fromPlatform();
      _version = info.version;
    } catch (_) {
      // Without a version the minVersion check cannot run; the tool and notice
      // levers still work.
    }

    try {
      final res = await http
          // Cache-busted: a stale copy of the very file used to announce an
          // emergency would defeat the purpose.
          .get(Uri.parse('$_url?t=${DateTime.now().millisecondsSinceEpoch}'))
          .timeout(const Duration(seconds: 4));
      if (res.statusCode != 200) return;
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) {
        _config = AppConfig.fromJson(decoded);
      }
    } catch (_) {
      // Offline, slow, 404, malformed — all leave _config at empty, which
      // means "nothing is wrong", which is the safe default. See the header.
    }
  }
}
