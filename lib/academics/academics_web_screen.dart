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
  static const _baseUrl =
      'https://academics.pediaid.bridgr.co.in';

  InAppWebViewController? _controller;
  bool _loading = true;
  int _progress = 0;

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
      body: InAppWebView(
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
        onLoadStart: (c, url) => setState(() => _loading = true),
        onLoadStop: (c, url) => setState(() => _loading = false),
        onProgressChanged: (c, progress) =>
            setState(() => _progress = progress),
        shouldOverrideUrlLoading: (c, action) async {
          // Keep all navigation inside the webview
          return NavigationActionPolicy.ALLOW;
        },
      ),
    );
  }
}
