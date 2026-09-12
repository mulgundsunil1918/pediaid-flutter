// =============================================================================
// test/store_links_test.dart
//
// Which store this device is sent to.
//
// These were decided at each call site and drifted: Settings sent every web
// visitor to Google Play — including anyone reading on an iPhone or a Mac —
// and the automatic rate dialog's fallback opened Google Play on iOS, where
// the link does nothing useful at all.
//
// Cheap to test, and the failure is invisible on the developer's own device,
// which is exactly the kind of bug that survives for months.
// =============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/utils/share_message.dart';

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  group('Apple devices go to the App Store', () {
    for (final p in [TargetPlatform.iOS, TargetPlatform.macOS]) {
      test('$p', () {
        debugDefaultTargetPlatformOverride = p;
        expect(storeUrlForThisDevice(), contains('apps.apple.com'));
        expect(reviewUrlForThisDevice(), contains('apps.apple.com'));
        expect(storeNameForThisDevice(), 'App Store');
        // The write-review page, not merely the listing — someone who tapped
        // "Rate PediAid" should land on the form, not a download button.
        expect(reviewUrlForThisDevice(), contains('action=write-review'));
        expect(reviewUrlForThisDevice(), contains(kAppStoreId));
      });
    }
  });

  group('everything else goes to Google Play', () {
    for (final p in [TargetPlatform.android, TargetPlatform.windows]) {
      test('$p', () {
        debugDefaultTargetPlatformOverride = p;
        expect(storeUrlForThisDevice(), contains('play.google.com'));
        expect(reviewUrlForThisDevice(), contains('play.google.com'));
        expect(storeNameForThisDevice(), 'Play Store');
      });
    }
  });

  test('no device is ever sent to the other platform\'s store', () {
    for (final p in TargetPlatform.values) {
      debugDefaultTargetPlatformOverride = p;
      final url = reviewUrlForThisDevice();
      final apple = p == TargetPlatform.iOS || p == TargetPlatform.macOS;
      expect(url.contains('play.google.com'), !apple, reason: '$p');
      expect(url.contains('apps.apple.com'), apple, reason: '$p');
    }
  });

  test('the App Store id is the live one, not the dead listing', () {
    // 6748139585 is a dead id that once shipped in the share message and sent
    // every iOS recipient to a listing that no longer resolves.
    expect(kAppStoreId, '6777623709');
    expect(kShareMessage, isNot(contains('6748139585')));
  });

  test('the share message offers BOTH stores, since the recipient is unknown', () {
    expect(kShareMessage, contains('play.google.com'));
    expect(kShareMessage, contains('apps.apple.com'));
  });
}
