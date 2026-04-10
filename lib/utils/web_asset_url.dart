// =============================================================================
// lib/utils/web_asset_url.dart
//
// Small helper that turns a Flutter asset key (the path you put in pubspec
// and pass to rootBundle) into an absolute URL the browser can fetch on
// Flutter web.
//
// Motivation: SfPdfViewer.asset() is documented as web-compatible but has
// known issues on some Flutter/canvaskit builds, especially with large
// PDFs (NEOFAX, NRP, PALS). Opening the asset directly in a new browser
// tab via url_launcher bypasses the in-app viewer entirely and lets the
// browser's native PDF reader take over — which Just Works on every
// desktop + mobile browser.
//
// Flutter web serves assets at `{baseHref}assets/{assetKey}`. The build
// mirrors the asset path verbatim, so an asset declared as
// `assets/nrp.pdf` ends up at `{baseHref}assets/assets/nrp.pdf` (note
// the double `assets/`). We compute this by resolving the key against
// Uri.base so it works no matter what the current base href is.
// =============================================================================

import 'package:flutter/foundation.dart' show kIsWeb;

/// Returns an absolute URL pointing at the given Flutter asset on web, or
/// null on non-web platforms (callers should fall back to rootBundle or
/// the native PDF viewer there).
///
/// [assetKey] is the exact string you'd pass to rootBundle, e.g.
/// `'assets/nrp.pdf'` or `'assets/data/formulary/NEOFAX NOV. 2024.pdf'`.
/// Spaces and other unsafe characters are URI-encoded so url_launcher
/// doesn't reject the result.
String? webAssetUrl(String assetKey) {
  if (!kIsWeb) return null;
  // Each path segment needs individual encoding so forward slashes stay
  // as separators and spaces become %20.
  final encodedSegments = assetKey
      .split('/')
      .map(Uri.encodeComponent)
      .join('/');
  // Uri.base on Flutter web is the current document URL. Resolving
  // `assets/<encoded>` against it yields the right absolute URL
  // regardless of the app's base href or route.
  return Uri.base.resolve('assets/$encodedSegments').toString();
}
