import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../services/formulary_service.dart';

class DrugPdfViewerScreen extends StatefulWidget {
  final DrugEntry entry;

  const DrugPdfViewerScreen({super.key, required this.entry});

  @override
  State<DrugPdfViewerScreen> createState() => _DrugPdfViewerScreenState();
}

class _DrugPdfViewerScreenState extends State<DrugPdfViewerScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isLoading = true;

  bool get _isHarrietLane => widget.entry.source == 'Harriet Lane 2023';

  Color _appBarColor(BuildContext context) =>
      _isHarrietLane ? const Color(0xFF53D2DC) : Theme.of(context).colorScheme.primary;

  String get _pdfAsset => _isHarrietLane
      ? 'assets/data/formulary/harriet lane drug.pdf'
      : 'assets/data/formulary/NEOFAX NOV. 2024.pdf';

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
      body: Column(
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
