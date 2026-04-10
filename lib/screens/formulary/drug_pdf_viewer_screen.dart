// =============================================================================
// lib/screens/formulary/drug_pdf_viewer_screen.dart
//
// Opens a NEOFAX or Harriet Lane drug PDF at a specific page. On mobile
// + desktop uses syncfusion_flutter_pdfviewer for fast inline rendering
// with page snapping. On Flutter web both PDFs are tens of megabytes
// and SfPdfViewer on canvaskit chokes trying to render them — we bounce
// the user straight into the browser's native PDF viewer via
// url_launcher, deep-linked to the exact drug page with a #page=N
// fragment (supported by Chrome, Edge, Firefox).
// =============================================================================

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/formulary_service.dart';
import '../../utils/web_asset_url.dart';

class DrugPdfViewerScreen extends StatefulWidget {
  final DrugEntry entry;

  const DrugPdfViewerScreen({super.key, required this.entry});

  @override
  State<DrugPdfViewerScreen> createState() => _DrugPdfViewerScreenState();
}

class _DrugPdfViewerScreenState extends State<DrugPdfViewerScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isLoading = true;
  bool _webLaunched = false;
  String? _webError;

  bool get _isHarrietLane => widget.entry.source == 'Harriet Lane 2023';

  Color _appBarColor(BuildContext context) =>
      _isHarrietLane ? const Color(0xFF53D2DC) : Theme.of(context).colorScheme.primary;

  String get _pdfAsset => _isHarrietLane
      ? 'assets/data/formulary/harriet lane drug.pdf'
      : 'assets/data/formulary/NEOFAX NOV. 2024.pdf';

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _launchOnWeb());
    }
  }

  Future<void> _launchOnWeb() async {
    final base = webAssetUrl(_pdfAsset);
    if (base == null) return;
    // #page=N makes Chrome/Edge/Firefox open the PDF at the drug's page
    // instead of page 1.
    final url = '$base#page=${widget.entry.page}';
    try {
      final ok = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
      if (!ok && mounted) {
        setState(() {
          _webError = 'Browser blocked the PDF popup.';
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _webLaunched = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _webError = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: _appBarColor(context),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.entry.name,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: kIsWeb ? _buildWebFallback() : _buildNativeViewer(),
    );
  }

  Widget _buildNativeViewer() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              SfPdfViewer.asset(
                _pdfAsset,
                key: _pdfViewerKey,
                initialPageNumber: widget.entry.page,
                pageLayoutMode: PdfPageLayoutMode.single,
                canShowScrollHead: true,
                canShowScrollStatus: true,
                onDocumentLoaded: (_) {
                  if (mounted) setState(() => _isLoading = false);
                },
                onDocumentLoadFailed: (details) {
                  if (mounted) setState(() => _isLoading = false);
                },
              ),
              if (_isLoading)
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: _appBarColor(context)),
                        const SizedBox(height: 16),
                        Text(
                          'Loading ${widget.entry.name}...',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        _buildBottomStrip(),
      ],
    );
  }

  Widget _buildWebFallback() {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.picture_as_pdf_rounded,
                size: 72, color: _appBarColor(context)),
            const SizedBox(height: 16),
            Text(
              _webLaunched
                  ? '${widget.entry.name} opened in a new tab'
                  : 'Opening ${widget.entry.name}…',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Page ${widget.entry.page} · ${widget.entry.source}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _appBarColor(context),
              ),
            ),
            const SizedBox(height: 10),
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
                _webLaunched ? 'Open again' : 'Open drug PDF',
                style:
                    GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: _appBarColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomStrip() {
    return Container(
      height: 32,
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Page ${widget.entry.page}',
            style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
          ),
          Text(
            'Data from ${widget.entry.source}',
            style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }
}
