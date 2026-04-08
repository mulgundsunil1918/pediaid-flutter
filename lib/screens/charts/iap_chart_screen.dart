import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class IAPChartScreen extends StatefulWidget {
  const IAPChartScreen({super.key});
  @override
  State<IAPChartScreen> createState() => _IAPChartScreenState();
}

class _IAPChartScreenState extends State<IAPChartScreen> {
  bool _isLoading = true;
  InAppWebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Theme.of(context).scaffoldBackgroundColor : const Color(0xFFF0F3FA);

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
            Text('5–18 Years · IAP 2015',
                style: TextStyle(fontSize: 11)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller?.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(color: bgColor),
          FutureBuilder<String>(
            future: rootBundle.loadString('assets/iap_growth_chart_2015_edited.html'),
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
                },
                onLoadStart: (controller, url) {
                  if (mounted) setState(() => _isLoading = true);
                },
                onLoadStop: (controller, url) async {
                  await controller.evaluateJavascript(source:
                    "document.body.style.backgroundColor = '${isDark ? '#0A0A0A' : '#F0F3FA'}';");
                  if (mounted) setState(() => _isLoading = false);
                },
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  domStorageEnabled: true,
                  allowFileAccessFromFileURLs: true,
                  allowUniversalAccessFromFileURLs: true,
                  mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                  useWideViewPort: true,
                  loadWithOverviewMode: true,
                  supportZoom: true,
                  builtInZoomControls: true,
                  displayZoomControls: false,
                  transparentBackground: false,
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
                    Text('Loading IAP Charts...',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 14,
                        )),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
