// =============================================================================
// ios_feature_gate.dart
//
// On iOS, certain features (drug formulary, dosage calculators) are not
// available in the native app due to App Store guidelines (1.4.2 / 5.1.1ix).
// This widget replaces the feature content on iOS with a clean redirect to
// the PediAid web app where the full feature is available.
//
// On Android and web the widget is transparent — child is rendered as-is.
// =============================================================================

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IosFeatureGate extends StatelessWidget {
  /// The feature name shown in the message, e.g. "Drug Formulary"
  final String featureName;

  /// Brief description of what the feature does
  final String description;

  /// The child widget rendered on Android/web (ignored on iOS)
  final Widget child;

  static bool get _isIos => !kIsWeb && Platform.isIOS;

  const IosFeatureGate({
    super.key,
    required this.featureName,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!_isIos) return child;
    return _IosGateScreen(
        featureName: featureName, description: description);
  }
}

class _IosGateScreen extends StatelessWidget {
  final String featureName;
  final String description;

  const _IosGateScreen(
      {required this.featureName, required this.description});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(featureName,
            style:
                GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1A1A2E)
                      : const Color(0xFFEEF2FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.language_rounded,
                  size: 38,
                  color: isDark
                      ? const Color(0xFF818CF8)
                      : const Color(0xFF4F46E5),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                '$featureName is available on the PediAid Web App',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 10),

              // Guideline note
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.orange.withValues(alpha: 0.12)
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark
                        ? Colors.orange.withValues(alpha: 0.3)
                        : Colors.orange.shade200,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 16,
                        color: isDark
                            ? Colors.orange.shade300
                            : Colors.orange.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        // Deliberately does not name where else this content
                        // lives. Pointing iOS users to another PediAid surface
                        // for drug dosing reads to an App Store reviewer as
                        // routing around guideline 1.4.2 rather than complying
                        // with it — which is treated far more harshly than not
                        // shipping the feature at all.
                        'This section is not available in the iOS app. Please '
                        'refer to your usual departmental or formulary source.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: isDark
                              ? Colors.orange.shade300
                              : Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // No outbound button here.
              //
              // This gate is what an iOS user sees on reaching a drug-dosing
              // screen withheld under App Store guideline 1.4.2. A prominent
              // "Open PediAid Web App" CTA at that exact moment is the clearest
              // possible statement that the restriction is being routed around
              // rather than complied with — and the secondary guidelines link
              // read the same way in this context, however innocuous elsewhere.
              //
              // The screen now simply states the section is unavailable.
            ],
          ),
        ),
      ),
    );
  }
}
