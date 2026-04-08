import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PalsPdfViewer extends StatefulWidget {
  /// Algorithm name — shown in the AppBar title.
  final String title;

  /// 0-based page index to jump to on open.
  final int initialPage;

  const PalsPdfViewer({
    super.key,
    required this.title,
    required this.initialPage,
  });

  @override
  State<PalsPdfViewer> createState() => _PalsPdfViewerState();
}

class _PalsPdfViewerState extends State<PalsPdfViewer> {
  String? _localPath;
  bool _isLoading = true;
  bool _hasError  = false;
  int  _currentPage = 0;
  int  _totalPages  = 0;


  @override
  void initState() {
    super.initState();
    if (!kIsWeb) _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final data  = await rootBundle.load('assets/pals/pals.pdf');
      final bytes = data.buffer.asUint8List();
      final dir   = await getTemporaryDirectory();
      final file  = File('${dir.path}/pals.pdf');
      await file.writeAsBytes(bytes, flush: true);
      if (mounted) {
        setState(() {
          _localPath = file.path;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() { _isLoading = false; _hasError = true; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_totalPages > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  'Page ${_currentPage + 1} of $_totalPages',
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(cs),
    );
  }

  Widget _buildBody(ColorScheme cs) {
    // ── Web: PDFView not supported ──────────────────────────────────────────
    if (kIsWeb) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.open_in_browser_rounded, color: cs.primary, size: 52),
              const SizedBox(height: 20),
              Text(
                'PDF viewer not available on web',
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please use the Android or iOS app to view PALS Algorithms.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.6),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ── Loading ─────────────────────────────────────────────────────────────
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: cs.primary),
            const SizedBox(height: 16),
            Text(
              'Loading ${widget.title}…',
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    // ── Error ───────────────────────────────────────────────────────────────
    if (_hasError || _localPath == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.error_outline, color: cs.error, size: 44),
              ),
              const SizedBox(height: 20),
              Text(
                'Failed to load PDF',
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Place pals.pdf in assets/pals/\nand run flutter pub get.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.6),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ── PDF viewer ──────────────────────────────────────────────────────────
    return PDFView(
      filePath: _localPath!,
      enableSwipe: true,
      swipeHorizontal: true,
      autoSpacing: false,
      pageFling: true,
      defaultPage: widget.initialPage,
      onViewCreated: (controller) {
        if (widget.initialPage > 0) {
          controller.setPage(widget.initialPage);
        }
      },
      onRender: (pages) {
        if (mounted) setState(() => _totalPages = pages ?? 0);
      },
      onPageChanged: (page, total) {
        if (mounted) {
          setState(() {
            _currentPage = page ?? 0;
            _totalPages  = total ?? 0;
          });
        }
      },
      onError: (_) {
        if (mounted) setState(() => _hasError = true);
      },
    );
  }
}
