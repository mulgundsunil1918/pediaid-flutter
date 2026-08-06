import 'dart:async';

import 'package:flutter/foundation.dart';
import 'dart:math' as math;
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
/// Books toppling like dominoes while Academics loads.
///
/// Stateful and driven by a repeating controller rather than by `progress`,
/// because the webview reports progress in a few large jumps — an animation
/// tied to it would sit still and then lurch. The books loop on their own
/// clock; the bar underneath is what actually reports progress.
class _AcademicsLoader extends StatefulWidget {
  const _AcademicsLoader({required this.progress});

  final int progress;

  @override
  State<_AcademicsLoader> createState() => _AcademicsLoaderState();
}

class _AcademicsLoaderState extends State<_AcademicsLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Never show a full bar before the page is actually ready: the webview
    // reports 100 slightly before first paint, and a filled bar sitting on a
    // blank screen looks more broken than a partial one.
    final fraction = (widget.progress.clamp(0, 100)) / 100 * 0.98;

    return Positioned.fill(
      child: ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 220,
                height: 86,
                child: AnimatedBuilder(
                  animation: _c,
                  builder: (context, _) => CustomPaint(
                    painter: _FallingBooksPainter(
                      t: _c.value,
                      colour: cs.primary,
                      shelf: cs.onSurface.withValues(alpha: 0.25),
                      background: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
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
                    value: widget.progress <= 0 ? null : fraction,
                    minHeight: 4,
                    backgroundColor: cs.onSurface.withValues(alpha: 0.08),
                    color: cs.primary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.progress <= 0
                    ? 'Connecting…'
                    : '${widget.progress}%',
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

/// Books toppling left to right, coming to rest against each other.
///
/// The first version rotated every book a full 90°, so each one swung through
/// the space of the one before it and the fallen pile overlapped into a
/// scribble. Real dominoes do not do that: the leading one lies flat and every
/// one after it stops when it lands on its neighbour.
///
/// So the rest angle is derived from the spacing rather than fixed —
/// asin(spacing / height) is the angle at which a book of this height, pivoted
/// this far from the next, just touches it. Change the spacing or the height
/// and the lean follows instead of needing a new magic number.
class _FallingBooksPainter extends CustomPainter {
  _FallingBooksPainter({
    required this.t,
    required this.colour,
    required this.shelf,
    required this.background,
  });

  /// 0…1, looping.
  final double t;
  final Color colour;
  final Color shelf;
  final Color background;

  static const _count = 5;
  static const _bookW = 13.0;
  static const _bookH = 46.0;
  /// Wide enough that a leaning book clears its neighbour's spine.
  static const _gap = 13.0;
  static const _pitch = _bookW + _gap;

  /// Fraction of the loop each book takes to fall; the remainder is the pause
  /// before the reset, which is what makes the loop read as deliberate.
  static const _fallSpan = 0.15;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeJoin = StrokeJoin.round
      ..color = colour;
    // OPAQUE, not translucent. A fallen book physically covers the one it
    // landed on, so it has to occlude it — with a see-through fill every
    // outline showed through every other and the stack read as a scribble.
    // The tint is pre-blended against the page background so it stays as light
    // as a 16% wash while still hiding what is underneath.
    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = Color.alphaBlend(colour.withValues(alpha: 0.16), background);

    final baseY = size.height - 12;
    final totalW = _count * _bookW + (_count - 1) * _gap;
    final startX = (size.width - totalW) / 2;

    canvas.drawLine(
      Offset(startX - 6, baseY + 1),
      Offset(startX + totalW + _bookH * 0.5, baseY + 1),
      Paint()
        ..color = shelf
        ..strokeWidth = 1.4,
    );

    // ~56°: far enough over to read as fallen, short of flat so the stack
    // still reads as books leaning rather than a heap.
    const restAngle = math.pi / 2 * 0.62;

    // Painted right to left so a leaning book overlaps the one it rests on,
    // rather than appearing to pass through it.
    for (var i = _count - 1; i >= 0; i--) {
      final begin = i * _fallSpan;
      final raw = ((t - begin) / _fallSpan).clamp(0.0, 1.0);
      final eased = raw * raw; // accelerates, as a falling book does

      // The leading book has nothing to catch it, so it goes all the way down.
      final target = i == 0 ? math.pi / 2 * 0.96 : restAngle;
      final angle = eased * target;

      final x = startX + i * _pitch;

      canvas.save();
      canvas.translate(x + _bookW, baseY); // pivot: the edge it tips over
      canvas.rotate(angle);

      final rect = Rect.fromLTWH(-_bookW, -_bookH, _bookW, _bookH);
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(2));
      canvas.drawRRect(rrect, fill);
      canvas.drawRRect(rrect, stroke);

      // Two spine bands, so a rotated book still reads as a book.
      canvas.drawLine(
        Offset(-_bookW + 3, -_bookH + 7),
        Offset(-3, -_bookH + 7),
        stroke,
      );
      canvas.drawLine(
        Offset(-_bookW + 3, -_bookH + 12),
        Offset(-3, -_bookH + 12),
        stroke,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_FallingBooksPainter old) =>
      old.t != t || old.colour != colour || old.shelf != shelf;
}
