// =============================================================================
// lib/widgets/under_development_banner.dart
//
// Slim amber-orange banner that pins to the top of in-progress screens
// (CME & Webinars, Never Again, etc.). Tells the user the screen is a
// preview, lets them dismiss for the session if they want, and links
// back to feedback so they can report what's missing.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UnderDevelopmentBanner extends StatefulWidget {
  /// One short sentence describing what's preview-only on this screen.
  final String message;
  const UnderDevelopmentBanner({
    super.key,
    this.message = 'Preview only — this section is still under active development. Please don\'t rely on it for clinical decisions yet.',
  });

  @override
  State<UnderDevelopmentBanner> createState() => _UnderDevelopmentBannerState();
}

class _UnderDevelopmentBannerState extends State<UnderDevelopmentBanner> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: const Color(0xFFFFF3E0),
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
          decoration: BoxDecoration(
            border: Border(
              left: const BorderSide(color: Color(0xFFE65100), width: 4),
              bottom: BorderSide(
                color: const Color(0xFFFFB74D).withValues(alpha: 0.7),
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.engineering_rounded,
                  color: Color(0xFFE65100), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UNDER DEVELOPMENT',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: const Color(0xFFE65100),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.message,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6D4C00),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Hide for now',
                icon: const Icon(Icons.close_rounded,
                    color: Color(0xFF6D4C00), size: 18),
                onPressed: () => setState(() => _dismissed = true),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                    minWidth: 32, minHeight: 32),
                splashRadius: 18,
                visualDensity: VisualDensity.compact,
                color: cs.onSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
