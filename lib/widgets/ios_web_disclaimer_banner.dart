import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shows a disclaimer banner on iOS only.
/// Displayed at the top of all drug dosage and calculator screens.
/// Includes a link to the PediAid web app for full clinical reference.
class IosWebDisclaimerBanner extends StatelessWidget {
  const IosWebDisclaimerBanner({super.key});

  static const _webAppUrl =
      'https://pediaid.bridgr.co.in';

  static bool get _shouldShow => !kIsWeb && Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    if (!_shouldShow) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A1A2E)
            : const Color(0xFFEEF2FF),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? const Color(0xFF4F46E5).withValues(alpha: 0.4)
                : const Color(0xFFC7D2FE),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              size: 16,
              color: isDark
                  ? const Color(0xFF818CF8)
                  : const Color(0xFF4F46E5)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'For clinical use, verify all information independently. '
              'Full reference available on the web app.',
              style: TextStyle(
                fontSize: 11.5,
                height: 1.4,
                color: isDark
                    ? const Color(0xFF818CF8)
                    : const Color(0xFF3730A3),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => launchUrl(
              Uri.parse(_webAppUrl),
              mode: LaunchMode.externalApplication,
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF4F46E5).withValues(alpha: 0.25)
                    : const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Web App',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFF818CF8)
                      : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
