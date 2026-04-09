// =============================================================================
// lib/screens/guides/nrp_pdf_viewer.dart
//
// NRP 8th Edition PDF viewer. Uses syncfusion_flutter_pdfviewer, which
// supports web + iOS + Android + desktop out of the box — no conditional
// imports, no temp-file dance, no kIsWeb branch. Earlier versions used
// flutter_pdfview which is mobile-only and left the web build showing
// a "Not supported on web" placeholder; that's why NRP was broken on the
// pediaid-flutter gh-pages site.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class NrpPdfViewer extends StatefulWidget {
  const NrpPdfViewer({super.key});

  @override
  State<NrpPdfViewer> createState() => _NrpPdfViewerState();
}

class _NrpPdfViewerState extends State<NrpPdfViewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

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
      body: SfPdfViewer.asset(
        'assets/nrp.pdf',
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
      ),
    );
  }
}
