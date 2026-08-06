import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';

/// Loads the PediAid Academics web platform inside the Flutter app.
class AcademicsWebScreen extends StatefulWidget {
  /// Deep-link path appended after the base URL, e.g. '/academics/nelson'
  final String path;

  const AcademicsWebScreen({super.key, this.path = '/'});

  @override
  State<AcademicsWebScreen> createState() => _AcademicsWebScreenState();
}

class _AcademicsWebScreenState extends State<AcademicsWebScreen> {
  static const _baseUrl = 'https://academics.pediaid.bridgr.co.in';

  InAppWebViewController? _controller;
  bool _loading = true;
  int _progress = 0;

  /// Guarantees the loading overlay comes down even if the webview never
  /// reports anything.
  ///
  /// On web, flutter_inappwebview renders an iframe and fires none of the
  /// progress/load callbacks this overlay was keyed on — so the page loaded
  /// underneath while the overlay sat on top saying "Connecting…" forever.
  /// The overlay is cosmetic; the page beneath has its own boot UI. So it is
  /// removed on the FIRST of: a real load signal (native platforms), or this
  /// timer. Web gets a short fuse because no signal will ever come; native
  /// gets a long one purely as a safety net behind the real callbacks.
  Timer? _overlayFailsafe;

  @override
  void initState() {
    super.initState();
    _overlayFailsafe = Timer(
      Duration(milliseconds: kIsWeb ? 2500 : 20000),
      () {
        if (mounted && _loading) setState(() => _loading = false);
      },
    );
  }

  @override
  void dispose() {
    _overlayFailsafe?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ?embed=1 tells the academics site it is inside the app, so it drops its
    // own header — the Academics/Dashboard links, the search box and the
    // notification bell. All three are duplicates of chrome this Scaffold and
    // the app already provide, and the bell in particular belongs in PediAid
    // proper, not buried in a web view where notifications would be missed.
    final sep = widget.path.contains('?') ? '&' : '?';
    final url = '$_baseUrl${widget.path}${sep}embed=1';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Academics',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        actions: [
          // Reload button
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reload',
            onPressed: () => _controller?.reload(),
          ),
        ],
        bottom: _loading
            ? PreferredSize(
                preferredSize: const Size.fromHeight(3),
                child: LinearProgressIndicator(
                  value: _progress / 100,
                  backgroundColor: Colors.transparent,
                  color: Theme.of(context).colorScheme.primary,
                  minHeight: 3,
                ),
              )
            : null,
      ),
      // The webview paints nothing until the page's first frame, and the
      // Academics site is served from a backend that sleeps — so the wait was
      // a plain white screen with only a 3px bar on the app bar to suggest
      // anything was happening. An overlay covers that gap and reports real
      // progress, so a slow load reads as loading rather than as broken.
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(url)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              domStorageEnabled: true,
              databaseEnabled: true,
              useShouldOverrideUrlLoading: true,
              mediaPlaybackRequiresUserGesture: false,
              transparentBackground: true,
              supportZoom: false,
              // The Academics site is a single-column mobile layout — there's
              // no legitimate reason any page should scroll sideways. This
              // guards every page loaded here, regardless of individual page
              // CSS, against horizontal scroll/overflow.
              disableHorizontalScroll: true,
              useWideViewPort: true,
              loadWithOverviewMode: true,
            ),
            onWebViewCreated: (c) {
              _controller = c;
              c.addJavaScriptHandler(
                handlerName: 'goToAppHome',
                callback: (args) {
                  if (mounted) Navigator.of(context).pop();
                },
              );
            },
            // Web never re-raises the overlay: its only dismissal there is the
            // one-shot failsafe timer, so a late onLoadStart would bring the
            // overlay back with nothing left to take it down.
            onLoadStart: (c, url) {
              if (!kIsWeb) setState(() => _loading = true);
            },
            onLoadStop: (c, url) => setState(() => _loading = false),
            onProgressChanged: (c, progress) =>
                setState(() => _progress = progress),
            shouldOverrideUrlLoading: (c, action) async {
              // Keep all navigation inside the webview
              return NavigationActionPolicy.ALLOW;
            },
          ),
          if (_loading) _AcademicsLoader(progress: _progress),
        ],
      ),
    );
  }
}

/// Full-bleed loading state shown over the webview until the page paints.
///
/// Mirrors the app's boot loader: the brand name filling with colour as
/// progress climbs, rather than a spinner. A determinate percentage matters
/// more here than it usually would, because the Academics backend can be
/// waking from sleep and a wait of several seconds is normal — a spinner would
/// leave someone unable to tell a slow load from a hung one.
class _AcademicsLoader extends StatelessWidget {
  const _AcademicsLoader({required this.progress});

  final int progress;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Never show a full bar before the page is actually ready: the webview
    // reports 100 slightly before first paint, and a filled bar sitting on a
    // blank screen looks more broken than a partial one.
    final fraction = (progress.clamp(0, 100)) / 100 * 0.98;

    return Positioned.fill(
      child: ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Brand name, filled left-to-right in step with progress.
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  stops: [fraction, fraction],
                  colors: [cs.primary, cs.onSurface.withValues(alpha: 0.15)],
                ).createShader(bounds),
                child: Text(
                  'PediAid Academics',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress <= 0 ? null : fraction,
                    minHeight: 4,
                    backgroundColor: cs.onSurface.withValues(alpha: 0.08),
                    color: cs.primary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                progress <= 0 ? 'Connecting…' : '$progress%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
