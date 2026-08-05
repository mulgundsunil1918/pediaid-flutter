// =============================================================================
// widgets/tool_gate.dart
//
// Takes a single calculator out of service without a store release.
//
// The counterpart to AppConfigGate, and usually the better first move: if one
// calculator is wrong, blocking the entire app punishes everyone using the
// other thirty tools correctly. This removes only the affected screen and
// leaves the rest working.
//
// The lever existed in the admin dashboard, the API and AppConfigService for
// some time before this widget did — nothing read `isToolDisabled`, so typing
// a tool id into the dashboard changed nothing at all. A control that appears
// to work but does not is worse than no control, because it is trusted during
// exactly the incident it was built for.
//
// Ids are the same ones Quick Access uses ('tpn', 'gir', 'bili', …), so the
// dashboard takes the name already visible throughout the app.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/app_config_service.dart';

class ToolGate extends StatelessWidget {
  const ToolGate({super.key, required this.toolId, required this.child});

  /// Quick Access key for this tool, e.g. 'tpn'.
  final String toolId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Config is already loaded by AppConfigGate at launch, so this is a plain
    // set lookup — no await, no spinner, nothing to fail. If the config never
    // loaded, disabledTools is empty and every tool stays available, which is
    // the same fail-open stance as the rest of this mechanism.
    if (!AppConfigService.instance.isToolDisabled(toolId)) return child;
    return _ToolUnavailableScreen(toolId: toolId);
  }
}

class _ToolUnavailableScreen extends StatelessWidget {
  const _ToolUnavailableScreen({required this.toolId});

  final String toolId;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cfg = AppConfigService.instance.config;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Temporarily unavailable',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: cs.errorContainer,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(Icons.build_circle_outlined,
                      color: cs.onErrorContainer, size: 28),
                ),
                const SizedBox(height: 18),
                Text(
                  'This tool is out of service',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  // Says explicitly not to work around it. Someone mid-shift who
                  // needs this number will otherwise reach for the version on
                  // their phone that is wrong, or a half-remembered formula —
                  // and the point of withdrawing it is that its output cannot
                  // be trusted right now.
                  cfg.notice ??
                      'We have taken this calculator out of service because its '
                          'result may not be correct. Please use another source '
                          'for this calculation until an update is available — '
                          'do not rely on a cached or older copy of this screen.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    height: 1.6,
                    color: cs.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 20),
                if (cfg.noticeUrl != null && cfg.noticeUrl!.isNotEmpty)
                  FilledButton(
                    onPressed: () => launchUrl(
                      Uri.parse(cfg.noticeUrl!),
                      mode: LaunchMode.externalApplication,
                    ),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'More information',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                const SizedBox(height: 14),
                Text(
                  'Every other tool in PediAid is unaffected.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: cs.onSurface.withValues(alpha: 0.55),
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
