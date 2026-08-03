import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class IAPChartScreen extends StatefulWidget {
  const IAPChartScreen({super.key});
  @override
  State<IAPChartScreen> createState() => _IAPChartScreenState();
}

class _IAPChartScreenState extends State<IAPChartScreen> {
  bool _isLoading = true;
  InAppWebViewController? _controller;
  Timer? _loadTimeout;

  // flutter_inappwebview's web implementation doesn't reliably fire
  // onLoadStop for srcdoc/InAppWebViewInitialData content in every
  // browser — without this, a failed callback left the spinner covering
  // the screen forever with no way out except the AppBar refresh button,
  // which is easy to miss. This guarantees the spinner clears either way;
  // if the content genuinely didn't render, the user at least sees that
  // and can hit refresh, instead of a screen that looks permanently stuck.
  void _armLoadTimeout() {
    _loadTimeout?.cancel();
    _loadTimeout = Timer(const Duration(seconds: 6), () {
      if (mounted && _isLoading) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _loadTimeout?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? Theme.of(context).scaffoldBackgroundColor
        : const Color(0xFFF0F3FA);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('IAP Growth Charts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('5–18 Years · IAP 2015', style: TextStyle(fontSize: 11)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller?.reload(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.download_rounded),
        label: const Text('Download Original Chart'),
        onPressed: () async {
          final uri = Uri.parse(
              'https://drive.google.com/file/d/1r3lMy7gRckpSkzAabWVFrEKHoMu4SS7g/view');
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        },
      ),
      body: Stack(
        children: [
          Container(color: bgColor),
          FutureBuilder<String>(
            future: rootBundle
                .loadString('assets/iap_growth_chart_2015_edited.html'),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              return InAppWebView(
                initialData: InAppWebViewInitialData(
                  data: snapshot.data!,
                  mimeType: 'text/html',
                  encoding: 'utf-8',
                  baseUrl: WebUri('https://localhost'),
                ),
                onWebViewCreated: (controller) {
                  _controller = controller;
                  _armLoadTimeout();
                },
                onLoadStart: (controller, url) {
                  if (mounted) setState(() => _isLoading = true);
                  _armLoadTimeout();
                },
                onLoadStop: (controller, url) async {
                  _loadTimeout?.cancel();
                  await controller.evaluateJavascript(
                      source:
                          "document.body.style.backgroundColor = '${isDark ? '#0A0A0A' : '#F0F3FA'}';");
                  if (mounted) setState(() => _isLoading = false);
                },
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  domStorageEnabled: true,
                  transparentBackground: false,
                  supportZoom: true,
                  // iOS-specific
                  allowsInlineMediaPlayback: !kIsWeb && !Platform.isAndroid,
                  allowsBackForwardNavigationGestures:
                      !kIsWeb && !Platform.isAndroid,
                  // Android-specific
                  allowFileAccessFromFileURLs: !kIsWeb && Platform.isAndroid,
                  allowUniversalAccessFromFileURLs:
                      !kIsWeb && Platform.isAndroid,
                  mixedContentMode: !kIsWeb && Platform.isAndroid
                      ? MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW
                      : null,
                  useWideViewPort: !kIsWeb && Platform.isAndroid,
                  loadWithOverviewMode: !kIsWeb && Platform.isAndroid,
                  builtInZoomControls: !kIsWeb && Platform.isAndroid,
                  displayZoomControls: false,
                ),
              );
            },
          ),
          if (_isLoading)
            Container(
              color: bgColor,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading IAP Charts...',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
