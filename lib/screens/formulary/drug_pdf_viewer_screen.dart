// =============================================================================
// lib/screens/formulary/drug_pdf_viewer_screen.dart
//
// Shows a NEOFAX or Harriet Lane drug at its exact page.
//
// Native (Android/iOS/desktop): syncfusion_flutter_pdfviewer renders the
// bundled PDF inline, opened at the drug's page — works offline.
//
// Web: the full books are multi-megabyte and SfPdfViewer chokes on canvaskit,
// so instead we show ONLY that drug's page as a pre-rendered image
// (`/drug-pages/{book}/{page}.webp`, ~150 KB) inline with pinch-zoom — the
// whole book never downloads. If the image can't load, a button falls back to
// opening the full PDF at #page=N in the browser's native viewer.
// =============================================================================

import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
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
  bool _isLoading = true; // native PDF load state

  bool get _isHarrietLane =>
      widget.entry.source.toLowerCase().contains('harriet');

  Color _appBarColor(BuildContext context) =>
      _isHarrietLane ? const Color(0xFF53D2DC) : Theme.of(context).colorScheme.primary;

  String get _pdfAsset => _isHarrietLane
      ? 'assets/data/formulary/harriet-lane-drug.pdf'
      : 'assets/data/formulary/neofax-nov-2024.pdf';

  String get _book => _isHarrietLane ? 'harriet' : 'neofax';

  /// Fallback only: opens the full PDF at the drug's page in the browser's
  /// native viewer, used if the single-page image fails to load.
  Future<void> _launchFullPdf() async {
    final base = webAssetUrl(_pdfAsset);
    if (base == null) return;
    final url = '$base#page=${widget.entry.page}';
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  }

  // A monograph can run several pages. spans.json (shipped with the page
  // images) maps each drug's start page → its last page, so web shows the
  // whole drug, not just the first page. Cached across viewer opens.
  static Map<String, dynamic>? _spansCache;
  static Future<Map<String, dynamic>?>? _spansFuture;

  Future<int> _endPage() async {
    final start = widget.entry.page;
    try {
      _spansFuture ??= http
          .get(Uri.parse('${Uri.base.origin}/drug-pages/spans.json'))
          .then((r) => r.statusCode == 200
              ? jsonDecode(r.body) as Map<String, dynamic>
              : null);
      _spansCache ??= await _spansFuture;
      final book = _spansCache?[_book] as Map<String, dynamic>?;
      final end = book?['$start'];
      if (end is num && end.toInt() >= start) return end.toInt();
    } catch (_) {
      // Fall back to a single page.
    }
    return start;
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
      body: kIsWeb ? _buildWebPage() : _buildNativeViewer(),
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

  // Web: every page of the drug's monograph, stacked in a scroll.
  Widget _buildWebPage() {
    return FutureBuilder<int>(
      future: _endPage(),
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(
              child: CircularProgressIndicator(color: _appBarColor(context)));
        }
        final end = snap.data ?? widget.entry.page;
        final pages = [for (var p = widget.entry.page; p <= end; p++) p];
        return Column(
          children: [
            Expanded(
              child: ColoredBox(
                color: const Color(0xFFEDEFF3),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: pages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (ctx, i) =>
                      _webPageImage(pages[i], isFirst: i == 0),
                ),
              ),
            ),
            _buildBottomStrip(pageCount: pages.length),
          ],
        );
      },
    );
  }

  Widget _webPageImage(int page, {required bool isFirst}) {
    final url = '${Uri.base.origin}/drug-pages/$_book/$page.webp';
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Image.network(
            url,
            fit: BoxFit.fitWidth,
            loadingBuilder: (ctx, child, progress) {
              if (progress == null) return child;
              return Container(
                height: 360,
                alignment: Alignment.center,
                child: CircularProgressIndicator(color: _appBarColor(context)),
              );
            },
            // Only the first page failing is worth a full error card; a missing
            // continuation page just drops out silently.
            errorBuilder: (ctx, err, st) =>
                isFirst ? _buildWebImageError() : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  Widget _buildWebImageError() {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.picture_as_pdf_rounded,
                size: 56, color: _appBarColor(context)),
            const SizedBox(height: 12),
            Text(
              "Couldn't load this drug's page.",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${widget.entry.name} · page ${widget.entry.page} · ${widget.entry.source}',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: cs.onSurface.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _launchFullPdf,
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(
                'Open the full page',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
              ),
              style:
                  FilledButton.styleFrom(backgroundColor: _appBarColor(context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomStrip({int? pageCount}) {
    final start = widget.entry.page;
    final pageLabel = (pageCount != null && pageCount > 1)
        ? 'Pages $start–${start + pageCount - 1}'
        : 'Page $start';
    return Container(
      height: 32,
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            pageLabel,
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
