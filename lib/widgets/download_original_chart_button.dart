// =============================================================================
// lib/widgets/download_original_chart_button.dart
//
// Drop-in "Download Original Chart" button for interactive chart/calculator
// screens that also have a static PDF counterpart in Resources (Fenton, WHO,
// IAP, BP, Jaundice). Opens the Drive file directly — same driveId catalog
// as lib/screens/resources/resources_screen.dart.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadOriginalChartButton extends StatelessWidget {
  final String driveId;
  final String label;

  const DownloadOriginalChartButton({
    super.key,
    required this.driveId,
    this.label = 'Download Original Chart',
  });

  Future<void> _open(BuildContext context) async {
    final uri = Uri.parse('https://drive.google.com/file/d/$driveId/view');
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the chart PDF')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _open(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.download_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
