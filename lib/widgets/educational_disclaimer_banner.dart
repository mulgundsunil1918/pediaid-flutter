import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Educational disclaimer banner — shown on iOS only.
/// Satisfies Apple guideline 1.4.1 for medical apps.
class EducationalDisclaimerBanner extends StatelessWidget {
  const EducationalDisclaimerBanner({super.key});

  static bool get _isIos => !kIsWeb && Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    if (!_isIos) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1C1917)
            : const Color(0xFFFFFBEB),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? const Color(0xFF92400E).withValues(alpha: 0.5)
                : const Color(0xFFFDE68A),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 15,
            color: isDark
                ? const Color(0xFFFBBF24)
                : const Color(0xFF92400E),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'For educational and reference use only. Always verify against '
              'current clinical guidelines and your institutional protocols. '
              'Not a substitute for professional clinical judgement.',
              style: TextStyle(
                fontSize: 11,
                height: 1.45,
                color: isDark
                    ? const Color(0xFFFBBF24)
                    : const Color(0xFF92400E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
