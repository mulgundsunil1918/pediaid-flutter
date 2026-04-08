import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';

/// Loads the PediAid Academics web platform inside the Flutter app.
class AcademicsWebScreen extends StatefulWidget {
  /// Deep-link path appended after the base URL, e.g. '/academics/nelson'
  final String path;

  const AcademicsWebScreen({super.key, this.path = '/academics'});

  @override
  State<AcademicsWebScreen> createState() => _AcademicsWebScreenState();
}

class _AcademicsWebScreenState extends State<AcademicsWebScreen> {
  static const _baseUrl =
      'https://mulgundsunil1918.github.io/pediaid-frontend';

  InAppWebViewController? _controller;
  bool _loading = true;
  int _progress = 0;

  @override
  Widget build(BuildContext context) {
    final url = '$_baseUrl${widget.path}';

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
        ),
        onWebViewCreated: (c) => _controller = c,
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
