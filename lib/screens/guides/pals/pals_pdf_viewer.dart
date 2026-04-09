// =============================================================================
// lib/screens/guides/pals/pals_pdf_viewer.dart
//
// PALS (Pediatric Advanced Life Support) PDF viewer. Rewritten to use
// syncfusion_flutter_pdfviewer so the same widget works on web, mobile,
// and desktop. The previous implementation used flutter_pdfview which
// requires dart:io and is mobile-only — the web build just showed a
// "Not supported on web" card.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
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
      body: SfPdfViewer.asset(
        'assets/pals/pals.pdf',
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
      ),
    );
  }
}
