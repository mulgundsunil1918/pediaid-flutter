// =============================================================================
// widgets/app_config_gate.dart
//
// Blocks the app when the released build is known to be unsafe.
//
// Shown only when app-config.json names a minVersion newer than this build.
// That file is empty by default, so in normal operation this widget renders
// its child and is invisible.
//
// The bar for using it is deliberately high: a wrong dose, a broken
// calculator, something that could lead to a real mistake at a bedside.
// Blocking an app a clinician is holding mid-shift is itself disruptive, so it
// must only ever happen when using it would be worse.
//
// If the config cannot be fetched the child renders normally — see
// AppConfigService for why failing open is the only defensible default here.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/app_config_service.dart';

class AppConfigGate extends StatefulWidget {
  const AppConfigGate({super.key, required this.child});

  final Widget child;

  @override
  State<AppConfigGate> createState() => _AppConfigGateState();
}

class _AppConfigGateState extends State<AppConfigGate> {
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    await AppConfigService.instance.load();
    if (mounted) setState(() => _checked = true);
  }

  @override
  Widget build(BuildContext context) {
    // Render the app immediately while the check runs. A four-second splash on
    // every launch, to catch a situation that should arise once a year, is a
    // bad trade — and the check is fast enough that a blocked build is caught
    // long before anyone reaches a calculator.
    if (!_checked || !AppConfigService.instance.updateRequired) {
      return widget.child;
    }
    return const _UpdateRequiredScreen();
  }
}

class _UpdateRequiredScreen extends StatelessWidget {
  const _UpdateRequiredScreen();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cfg = AppConfigService.instance.config;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: cs.errorContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.warning_amber_rounded,
                        color: cs.onErrorContainer, size: 30),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Please update PediAid',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    // The specific reason comes from the config, because "an
                    // update is required" without saying why invites people to
                    // ignore it — which is the one thing that must not happen.
                    cfg.notice ??
                        'This version of PediAid has a problem that could affect '
                            'clinical accuracy. Please update before using it '
                            'again.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
                      height: 1.6,
                      color: cs.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 22),
                  if (cfg.noticeUrl != null && cfg.noticeUrl!.isNotEmpty)
                    FilledButton(
                      onPressed: () => launchUrl(
                        Uri.parse(cfg.noticeUrl!),
                        mode: LaunchMode.externalApplication,
                      ),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Update now',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  const SizedBox(height: 14),
                  Text(
                    'Installed version ${AppConfigService.instance.currentVersion}. '
                    'Questions: help@bridgr.co.in',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: cs.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
