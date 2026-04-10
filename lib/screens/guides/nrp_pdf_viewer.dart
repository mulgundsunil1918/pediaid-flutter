// =============================================================================
// lib/screens/guides/nrp_pdf_viewer.dart
//
// NRP 8th Edition PDF viewer. Uses syncfusion_flutter_pdfviewer on mobile
// where it renders fast and supports gestures natively, and on Flutter
// web it bounces the user straight into the browser's native PDF viewer
// via url_launcher. SfPdfViewer's web story is flaky with large PDFs
// on canvaskit, so we don't try to render the PDF inside the canvas
// there — the native viewer is always available, is faster, and lets
// the user download / print through familiar browser UI.
// =============================================================================

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/web_asset_url.dart';

const String _kNrpAssetKey = 'assets/nrp.pdf';

class NrpPdfViewer extends StatefulWidget {
  const NrpPdfViewer({super.key});

  @override
  State<NrpPdfViewer> createState() => _NrpPdfViewerState();
}

class _NrpPdfViewerState extends State<NrpPdfViewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _webLaunched = false;
  String? _webError;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // Fire the launch after the first frame so we're definitely
      // attached to the widget tree before async work begins.
      WidgetsBinding.instance.addPostFrameCallback((_) => _launchOnWeb());
    }
  }

  Future<void> _launchOnWeb() async {
    final url = webAssetUrl(_kNrpAssetKey);
    if (url == null) return;
    try {
      final ok = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
      if (!ok && mounted) {
        setState(() => _webError = 'Browser blocked the PDF popup.');
      } else if (mounted) {
        setState(() => _webLaunched = true);
      }
    } catch (e) {
      if (mounted) setState(() => _webError = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NRP 8th Edition',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: kIsWeb ? _buildWebFallback(cs) : _buildNativeViewer(cs),
    );
  }

  Widget _buildNativeViewer(ColorScheme cs) {
    return SfPdfViewer.asset(
      _kNrpAssetKey,
      key: _pdfViewerKey,
      canShowScrollHead: true,
      canShowScrollStatus: true,
      enableDoubleTapZooming: true,
      onDocumentLoadFailed: (details) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: cs.error,
            content: Text(
              'Failed to load PDF: ${details.description}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWebFallback(ColorScheme cs) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.picture_as_pdf_rounded, size: 72, color: cs.primary),
            const SizedBox(height: 16),
            Text(
              _webLaunched
                  ? 'NRP 8th Edition opened in a new tab'
                  : 'Opening NRP 8th Edition…',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _webError ??
                  "If the tab didn't open, your browser may have blocked the popup.",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: cs.onSurface.withValues(alpha: 0.65),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _launchOnWeb,
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(
                _webLaunched ? 'Open again' : 'Open NRP PDF',
                style:
                    GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
