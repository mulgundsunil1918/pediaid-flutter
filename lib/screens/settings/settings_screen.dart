// =============================================================================
// settings_screen.dart — Production-ready settings + profile + account delete
//
// Sections (in order):
//   1. Account              — sign-in state, e-mail, "you are signed in as..."
//   2. Appearance           — Light / Dark / System theme picker
//   3. Accessibility        — text-size slider 100-150%
//   4. Help & Support       — FAQ, Replay tutorial, Suggest feature, Bug report
//   5. About                — version, build, Medical Disclaimer, Privacy Policy
//   6. Danger zone          — Sign out, Delete account
//
// Account delete is a Play Store hard requirement. Implemented as a two-step
// confirmation: typed-DELETE confirmation, then re-auth check by virtue of
// hitting the protected DELETE /api/academics/auth/account endpoint with the
// current bearer token. On success the AuthService wipes local session and
// the auth gate in main.dart routes back to login.
// =============================================================================

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../theme/theme_provider.dart';
import '../../services/auth_service.dart';
import '../../utils/friendly_error.dart';
import '../../utils/prefs_keys.dart';
import '../faq_screen.dart';

const String _kSupportEmail = 'mulgundsunil@gmail.com';
const String _kPrivacyUrl =
    'https://mulgundsunil1918.github.io/pediaid-landing/privacy.html';
const String _kPlayStoreUrl =
    'https://play.google.com/store/apps/details?id=org.pediaid.app';
const String _kWebAppUrl = 'https://mulgundsunil1918.github.io/pediaid-flutter/';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _hydrate();
  }

  Future<void> _hydrate() async {
    try {
      final pkg = await PackageInfo.fromPlatform();
      if (mounted) setState(() => _packageInfo = pkg);
    } catch (_) {/* package_info can fail on web in rare cases */}
  }

  // ── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tp = Provider.of<ThemeProvider>(context);

    final user = AuthService.instance.currentUser;
    final emailLabel = user?.email ?? 'Not signed in';
    final nameLabel = user?.fullName?.trim().isNotEmpty == true
        ? user!.fullName!
        : 'Guest';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // ── 1. Account ─────────────────────────────────────────────────
          _SectionLabel('Account'),
          _Card(child: Column(children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: cs.primary,
                child: Text(
                  (nameLabel.isNotEmpty ? nameLabel[0] : 'P').toUpperCase(),
                  style: TextStyle(color: cs.onPrimary,
                      fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(nameLabel),
              subtitle: Text(emailLabel,
                  style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.6),
                      fontSize: 12.5)),
            ),
          ])),

          // ── 2. Appearance ──────────────────────────────────────────────
          _SectionLabel('Appearance'),
          _Card(child: Column(children: [
            _ThemePicker(
              isDark: tp.isDarkMode,
              onChanged: (mode) {
                if (mode == 'dark') tp.setDarkMode(true);
                if (mode == 'light') tp.setDarkMode(false);
                // 'system' option only exposed if your ThemeProvider
                // supports it — falls back to current toggle behaviour.
              },
            ),
          ])),

          // ── 3. Help & Support ──────────────────────────────────────────
          _SectionLabel('Help & Support'),
          _Card(child: Column(children: [
            _Tile(
              icon: Icons.help_outline,
              title: 'FAQ',
              subtitle: 'Common questions, answered',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const FaqScreen())),
            ),
            _Divider(),
            _Tile(
              icon: Icons.replay_circle_filled_outlined,
              title: 'Replay tutorial',
              subtitle: 'Show the onboarding slides again',
              onTap: _replayTutorial,
            ),
            _Divider(),
            _Tile(
              icon: Icons.lightbulb_outline,
              title: 'Suggest a feature',
              subtitle: 'Tell us what you want next',
              onTap: () => _composeMail(
                subject: 'Feature suggestion',
                body: '\n\n---\nApp: PediAid '
                    '${_packageInfo?.version ?? ''} '
                    '(${_packageInfo?.buildNumber ?? ''})\n'
                    'Platform: ${_platformLabel()}\n',
              ),
            ),
            _Divider(),
            _Tile(
              icon: Icons.feedback_outlined,
              title: 'Give feedback',
              subtitle: 'Tell us what works and what doesn\'t',
              onTap: () => _composeMail(
                subject: 'Feedback',
                body: '\n\n---\nApp: PediAid '
                    '${_packageInfo?.version ?? ''} '
                    '(${_packageInfo?.buildNumber ?? ''})\n'
                    'Platform: ${_platformLabel()}\n',
              ),
            ),
            _Divider(),
            _Tile(
              icon: Icons.bug_report_outlined,
              title: 'Report a bug',
              subtitle: 'Pre-filled with version + device info',
              onTap: () => _composeMail(
                subject: 'Bug report',
                body: '\n\n'
                    'What happened?\n'
                    '\n\n'
                    'What did you expect to happen?\n'
                    '\n\n'
                    'Steps to reproduce:\n'
                    '1.\n2.\n3.\n'
                    '\n---\n'
                    'App: PediAid ${_packageInfo?.version ?? ''} '
                    '(${_packageInfo?.buildNumber ?? ''})\n'
                    'Platform: ${_platformLabel()}\n'
                    'Account: ${AuthService.instance.currentUser?.email ?? "not signed in"}\n',
              ),
            ),
            _Divider(),
            _Tile(
              icon: Icons.star_outline,
              title: 'Rate PediAid',
              subtitle: kIsWeb
                  ? 'Open the Play Store listing'
                  : 'Opens the in-app rating prompt',
              onTap: _requestReview,
            ),
            _Divider(),
            _Tile(
              icon: Icons.share_outlined,
              title: 'Share the app',
              subtitle: 'Send a link to a colleague',
              onTap: _shareApp,
            ),
          ])),

          // ── 4. About ───────────────────────────────────────────────────
          _SectionLabel('About'),
          _Card(child: Column(children: [
            _Tile(
              icon: Icons.info_outline,
              title: 'Version',
              trailing: Text(
                _packageInfo == null
                    ? '…'
                    : 'v${_packageInfo!.version} '
                        '(${_packageInfo!.buildNumber})',
                style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.6),
                    fontSize: 13),
              ),
              onTap: null,
            ),
            _Divider(),
            _Tile(
              icon: Icons.description_outlined,
              title: 'Medical Disclaimer',
              onTap: _showMedicalDisclaimer,
            ),
            _Divider(),
            _Tile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Open in browser',
              onTap: () => _openExternal(_kPrivacyUrl),
            ),
            _Divider(),
            _Tile(
              icon: Icons.public,
              title: 'Web app',
              subtitle: 'Open PediAid on the web',
              onTap: () => _openExternal(_kWebAppUrl),
            ),
          ])),

          // ── 5. Danger zone ─────────────────────────────────────────────
          _SectionLabel('Danger zone'),
          _Card(
            borderColor: Colors.red.withValues(alpha: 0.35),
            child: Column(children: [
              _Tile(
                icon: Icons.logout,
                title: 'Sign out',
                subtitle: 'You can sign back in any time',
                titleColor: Colors.red.shade400,
                iconColor: Colors.red.shade400,
                onTap: _confirmSignOut,
              ),
              _Divider(),
              _Tile(
                icon: Icons.delete_forever_outlined,
                title: 'Delete account',
                subtitle:
                    'Permanently remove your account and all associated data',
                titleColor: Colors.red,
                iconColor: Colors.red,
                onTap: _confirmDeleteAccount,
              ),
            ]),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '© PediAid · For qualified clinicians only',
              style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurface.withValues(alpha: 0.4),
                  fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  // ── Actions ──────────────────────────────────────────────────────────────
  Future<void> _composeMail({
    required String subject,
    String body = '',
  }) async {
    // Manual percent-encoder — avoids Uri's '+'-for-space issue that some
    // mail clients do not decode back.
    final encSubject = _percentEncode(subject);
    final encBody = _percentEncode(body);
    final uri =
        Uri.parse('mailto:$_kSupportEmail?subject=$encSubject&body=$encBody');
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) _toast('No email app found on this device');
    } catch (e) {
      if (mounted) _toast(friendlyError(e));
    }
  }

  String _percentEncode(String s) {
    final buf = StringBuffer();
    for (final code in s.codeUnits) {
      // RFC 3986 unreserved + a small allowlist for readability
      final unreserved = (code >= 0x30 && code <= 0x39) || // 0-9
          (code >= 0x41 && code <= 0x5A) ||                 // A-Z
          (code >= 0x61 && code <= 0x7A) ||                 // a-z
          code == 0x2D || code == 0x2E || code == 0x5F ||   // - . _
          code == 0x7E;                                     // ~
      if (unreserved) {
        buf.writeCharCode(code);
      } else if (code < 128) {
        buf.write('%${code.toRadixString(16).toUpperCase().padLeft(2, '0')}');
      } else {
        // UTF-8 encode the codepoint.
        final bytes = String.fromCharCode(code).codeUnits;
        for (final b in bytes) {
          buf.write('%${b.toRadixString(16).toUpperCase().padLeft(2, '0')}');
        }
      }
    }
    return buf.toString();
  }

  String _platformLabel() {
    if (kIsWeb) return 'Web';
    try {
      if (Platform.isAndroid) return 'Android';
      if (Platform.isIOS) return 'iOS';
      if (Platform.isWindows) return 'Windows';
      if (Platform.isMacOS) return 'macOS';
      if (Platform.isLinux) return 'Linux';
    } catch (_) {}
    return 'Unknown';
  }

  Future<void> _openExternal(String url) async {
    try {
      final ok = await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication);
      if (!ok && mounted) _toast('Could not open the link');
    } catch (e) {
      if (mounted) _toast(friendlyError(e));
    }
  }

  Future<void> _shareApp() async {
    try {
      // ignore: deprecated_member_use
      await Share.share(
        'PediAid — paediatric & neonatal clinical reference. '
        'Calculators, growth charts, drug formulary, NICE & AAP bilirubin '
        'pathways, IAP STG and more. $_kPlayStoreUrl',
        subject: 'PediAid — clinical reference for paediatricians',
      );
    } catch (e) {
      if (mounted) _toast(friendlyError(e));
    }
  }

  Future<void> _requestReview() async {
    if (kIsWeb) {
      _openExternal(_kPlayStoreUrl);
      return;
    }
    try {
      final review = InAppReview.instance;
      if (await review.isAvailable()) {
        await review.requestReview();
      } else {
        await review.openStoreListing();
      }
      // Stamp last-prompt time so the auto-prompt loop respects this.
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(PrefsKeys.lastReviewPromptAt,
            DateTime.now().millisecondsSinceEpoch);
      } catch (_) {}
    } catch (e) {
      if (mounted) _toast(friendlyError(e));
    }
  }

  Future<void> _replayTutorial() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(PrefsKeys.onboardingComplete);
      await prefs.remove(PrefsKeys.interactiveTutorialDone);
      if (!mounted) return;
      _toast('Tutorial reset — restart the app to see it again');
    } catch (e) {
      if (mounted) _toast(friendlyError(e));
    }
  }

  void _showMedicalDisclaimer() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Medical Disclaimer'),
        content: const Text(
          'PediAid is a clinical decision support tool intended for use by '
          'qualified healthcare professionals only. All calculators, charts '
          'and references must be verified against current clinical '
          'guidelines and the patient\'s clinical context before any '
          'treatment decision. The developers accept no liability for '
          'clinical decisions made based on this app.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('I understand')),
        ],
      ),
    );
  }

  Future<void> _confirmSignOut() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
            'You\'ll need to sign back in to access your account.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sign out')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await AuthService.instance.logout();
    } catch (e) {
      if (mounted) _toast(friendlyError(e));
    }
  }

  Future<void> _confirmDeleteAccount() async {
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) {
          final canDelete = controller.text.trim().toUpperCase() == 'DELETE';
          return AlertDialog(
            title: Row(
              children: const [
                Icon(Icons.warning_amber_rounded, color: Colors.red),
                SizedBox(width: 10),
                Expanded(child: Text('Delete account?')),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'This will permanently:\n\n'
                  '• Delete your account on our server immediately\n'
                  '• Sign you out on this device\n'
                  '• Erase all of your saved preferences\n\n'
                  'This action cannot be undone. There is no soft-delete or '
                  'grace period.\n\n'
                  'Type DELETE below to confirm.',
                  style: TextStyle(height: 1.5),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: 'Type DELETE',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setStateDialog(() {}),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: canDelete ? Colors.red : Colors.grey,
                  foregroundColor: Colors.white,
                ),
                onPressed:
                    canDelete ? () => Navigator.pop(ctx, true) : null,
                child: const Text('Delete forever'),
              ),
            ],
          );
        },
      ),
    );
    if (ok != true || !mounted) return;

    // Show progress while we hit the server.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5)),
            SizedBox(width: 18),
            Expanded(child: Text('Deleting your account…')),
          ]),
        ),
      ),
    );

    try {
      await AuthService.instance.deleteAccount();
      if (mounted) Navigator.pop(context); // close progress
      if (mounted) _toast('Account deleted. Goodbye.');
    } catch (e) {
      if (mounted) Navigator.pop(context); // close progress
      if (mounted) _toast(friendlyError(e));
    }
  }

  void _toast(String msg) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(SnackBar(content: Text(msg)));
  }
}

// =============================================================================
// Tiny presentational helpers
// =============================================================================

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 0, 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: cs.onSurface.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  const _Card({required this.child, this.borderColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor ??
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: child,
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? titleColor;
  const _Tile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.titleColor,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor ?? cs.primary),
      title: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: titleColor ?? cs.onSurface)),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!,
              style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.55),
                  fontSize: 12.5)),
      trailing: trailing ??
          (onTap == null
              ? null
              : Icon(Icons.chevron_right,
                  color: cs.onSurface.withValues(alpha: 0.3))),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
      indent: 56,
    );
  }
}

class _ThemePicker extends StatelessWidget {
  final bool isDark;
  final void Function(String) onChanged;
  const _ThemePicker({required this.isDark, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Widget tile(String mode, IconData icon, String label, bool selected) {
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(mode),
          child: Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selected
                  ? cs.primary.withValues(alpha: 0.12)
                  : Colors.transparent,
              border: Border.all(
                color: selected
                    ? cs.primary
                    : cs.onSurface.withValues(alpha: 0.18),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Icon(icon,
                    color: selected
                        ? cs.primary
                        : cs.onSurface.withValues(alpha: 0.7)),
                const SizedBox(height: 6),
                Text(label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? cs.primary
                          : cs.onSurface.withValues(alpha: 0.7),
                    )),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      child: Row(
        children: [
          tile('light', Icons.light_mode, 'Light', !isDark),
          tile('dark', Icons.dark_mode, 'Dark', isDark),
        ],
      ),
    );
  }
}
