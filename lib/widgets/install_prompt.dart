// =============================================================================
// widgets/install_prompt.dart
//
// Points mobile browser visitors at the best version of PediAid for their
// device: the Play Store app on Android, an installed Home Screen app on iOS.
//
// Web only, mobile only, and never once the app is actually installed —
// standalone display mode means the visitor already did this, and nagging
// someone to install what they are already running is how a prompt becomes
// something people learn to close without reading.
//
// A word on "force": a web page cannot force an install, and blocking the
// content until someone complies would be both hostile and trivially bypassed.
// What it CAN do is be impossible to miss and easy to act on. So this is a
// full-width bar with a real button, dismissible once, remembered afterwards.
//
// The iOS copy attributes the absence to App Store policy requirements, which
// is accurate as things stand: review has asked for changes before it can be
// published. Keep the word "yet" — it is what makes the sentence true, and
// what stops it becoming false the moment the app is approved.
// =============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'install_prompt_platform.dart'
    if (dart.library.html) 'install_prompt_web.dart';

const _playStoreUrl =
    'https://play.google.com/store/apps/details?id=com.pediaid.pediaid';
const _dismissKey = 'pediaid_install_prompt_dismissed';

class InstallPrompt extends StatefulWidget {
  const InstallPrompt({super.key});

  @override
  State<InstallPrompt> createState() => _InstallPromptState();
}

class _InstallPromptState extends State<InstallPrompt> {
  bool _dismissed = true; // hidden until we know it should show

  @override
  void initState() {
    super.initState();
    _decide();
  }

  Future<void> _decide() async {
    // Native builds are already the app.
    if (!kIsWeb) return;
    // Installed to the Home Screen / launched standalone — nothing to offer.
    if (isRunningStandalone()) return;
    // Desktop browsers get nothing: there is no app to install for them.
    final platform = defaultTargetPlatform;
    if (platform != TargetPlatform.android && platform != TargetPlatform.iOS) {
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_dismissKey) ?? false) return;
    } catch (_) {
      // Storage unavailable — showing it is the safe side of this trade.
    }
    if (mounted) setState(() => _dismissed = false);
  }

  Future<void> _dismiss() async {
    setState(() => _dismissed = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_dismissKey, true);
    } catch (_) {
      /* it will reappear next visit; harmless */
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;

    return Material(
      color: cs.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isAndroid ? Icons.shop_rounded : Icons.ios_share_rounded,
                color: cs.onPrimary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAndroid
                          ? 'Get the PediAid app'
                          : 'Add PediAid to your Home Screen',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: cs.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isAndroid
                          ? 'Faster, works offline, and gets notifications.'
                          // Concrete steps: iOS offers no install button, and
                          // "add to home screen" means nothing to most people
                          // unless you name the menu it lives in.
                          : 'Due to App Store policy requirements the full version '
                              'isn\'t available there yet. Tap Share, then '
                              '"Add to Home Screen" — it works just like the app.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        height: 1.35,
                        color: cs.onPrimary.withValues(alpha: 0.9),
                      ),
                    ),
                    if (isAndroid) ...[
                      const SizedBox(height: 8),
                      FilledButton.icon(
                        onPressed: () => launchUrl(
                          Uri.parse(_playStoreUrl),
                          mode: LaunchMode.externalApplication,
                        ),
                        icon: const Icon(Icons.download_rounded, size: 16),
                        label: Text(
                          'Get it on Google Play',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: cs.onPrimary,
                          foregroundColor: cs.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: _dismiss,
                icon: Icon(Icons.close_rounded,
                    color: cs.onPrimary.withValues(alpha: 0.8), size: 18),
                tooltip: 'Dismiss',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
