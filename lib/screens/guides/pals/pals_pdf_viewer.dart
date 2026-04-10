// =============================================================================
// lib/screens/guides/pals/pals_pdf_viewer.dart
//
// PALS (Pediatric Advanced Life Support) PDF viewer. On mobile + desktop
// renders with syncfusion_flutter_pdfviewer, which supports jump-to-page
// for the algorithm deep-links. On Flutter web the PDF is opened in a
// new browser tab via url_launcher instead — SfPdfViewer on canvaskit
// can't reliably render this PDF and the native browser viewer is
// instant and universally supported.
// =============================================================================

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/web_asset_url.dart';

const String _kPalsAssetKey = 'assets/pals/pals.pdf';

class PalsPdfViewer extends StatefulWidget {
  const PalsPdfViewer({
    super.key,
    this.title = 'PALS Algorithms',
    this.initialPage = 0,
  });

  final String title;
  final int initialPage;

  @override
  State<PalsPdfViewer> createState() => _PalsPdfViewerState();
}

class _PalsPdfViewerState extends State<PalsPdfViewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late final PdfViewerController _controller;
  bool _webLaunched = false;
  String? _webError;

  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _launchOnWeb());
    }
  }

  Future<void> _launchOnWeb() async {
    // Append a fragment identifier so PDF viewers that support it (Chrome,
    // Firefox) jump directly to the requested algorithm page.
    final base = webAssetUrl(_kPalsAssetKey);
    if (base == null) return;
    final url = widget.initialPage > 0 ? '$base#page=${widget.initialPage + 1}' : base;
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
          widget.title,
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: kIsWeb ? _buildWebFallback(cs) : _buildNativeViewer(cs),
    );
  }

  Widget _buildNativeViewer(ColorScheme cs) {
    return SfPdfViewer.asset(
      _kPalsAssetKey,
      key: _pdfViewerKey,
      controller: _controller,
      onDocumentLoaded: (_) {
        // jumpToPage is 1-based in syncfusion
        if (widget.initialPage > 0) {
          _controller.jumpToPage(widget.initialPage + 1);
        }
      },
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
                  ? '${widget.title} opened in a new tab'
                  : 'Opening ${widget.title}…',
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
                _webLaunched ? 'Open again' : 'Open PDF',
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
