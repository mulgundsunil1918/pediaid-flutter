// =============================================================================
// faq_screen.dart — Hand-written, static, offline FAQ screen.
// 18 collapsible Q&A items. Zero backend reads, zero cost, works offline.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  static const String _supportEmail = 'mulgundsunil@gmail.com';
  static const String _privacyUrl =
      'https://mulgundsunil1918.github.io/pediaid-landing/privacy.html';

  static const List<_QA> _items = [
    _QA(
      question: 'What is PediAid?',
      answer:
          'PediAid is a paediatric & neonatal clinical reference app — '
          'calculators, growth charts, drug formulary and bilirubin '
          'pathways from AAP 2022, NICE CG98, IAP STG, NNF CPG and the '
          'Neofax + Harriet Lane formularies. It runs on Android, iOS, '
          'web and desktop, and works offline once the assets load.',
    ),
    _QA(
      question: 'Is PediAid a substitute for clinical judgement?',
      answer:
          'No. PediAid is a clinical decision support tool intended for '
          'use by qualified healthcare professionals only. Always verify '
          'every result against current guidelines, the patient\'s '
          'clinical context and your local protocols before any '
          'treatment decision.',
    ),
    _QA(
      question: 'Do I need an account to use PediAid?',
      answer:
          'No — the calculators, charts and formulary work without an '
          'account. An account is only needed to access the Academics '
          'web app (peer-reviewed chapters, CME, contributor features).',
    ),
    _QA(
      question: 'Where does the data come from?',
      answer:
          '• Bilirubin thresholds: AAP 2022 (≥35 wk) and NICE CG98 '
          '(<35 wk).\n'
          '• Growth charts: WHO 2006/2007, IAP 2015 and Fenton 2013.\n'
          '• Drug formulary: Neofax (neonatal) and Harriet Lane '
          '(paediatric).\n'
          '• Standard treatment guidelines: IAP STG 2022, IAP Action '
          'Plan 2026, NNF CPG 2021.\n\n'
          'Every calculator and chart screen names its source.',
    ),
    _QA(
      question: 'Is my patient data sent anywhere?',
      answer:
          'No. Anything you type into a calculator (weight, gestational '
          'age, lab values, etc.) is never sent to our servers and is '
          'discarded as soon as you close the screen. Only your account '
          'email and authentication token are stored on our servers.',
    ),
    _QA(
      question: 'How accurate are the calculators?',
      answer:
          'The math is verified against the source publication for every '
          'tool. Formulas are visible on every results screen for your '
          'own check. If you find a discrepancy, please report it via '
          'Settings → Report a bug.',
    ),
    _QA(
      question: 'How do I create an account?',
      answer:
          'Tap Sign in on the home screen → Create account. You\'ll need '
          'a valid email and a password (8+ characters). You\'ll get a '
          'verification email — check spam if it doesn\'t arrive in 5 '
          'minutes.',
    ),
    _QA(
      question: 'I forgot my password. What now?',
      answer:
          'On the Sign in screen → Forgot password → enter your email. '
          'You\'ll get a reset link valid for 1 hour. If the email '
          'doesn\'t arrive, check the spam folder.',
    ),
    _QA(
      question: 'How do I sign out?',
      answer:
          'Settings → Danger zone → Sign out. You can sign back in any '
          'time without losing data.',
    ),
    _QA(
      question: 'How do I delete my account?',
      answer:
          'Settings → Danger zone → Delete account. You\'ll be asked to '
          'type DELETE to confirm. Deletion is immediate and permanent — '
          'there is no soft-delete or grace period. All data associated '
          'with your account is removed from our servers.',
    ),
    _QA(
      question: 'I\'m not getting push notifications on my Samsung / '
          'Xiaomi / OnePlus / Vivo / Oppo phone',
      answer:
          'These OEMs aggressively kill background apps to save battery, '
          'which breaks push delivery. To fix:\n\n'
          '1. Long-press the PediAid icon → App info.\n'
          '2. Battery → set to "Unrestricted" (Samsung) / "No '
          'restrictions" (others).\n'
          '3. On Xiaomi / Oppo / Vivo / Realme: open Security app → '
          'Permissions → Autostart → enable for PediAid.\n'
          '4. On Samsung: Settings → Battery and device care → Battery → '
          'Background usage limits → Never sleeping apps → add PediAid.\n\n'
          'Pixel and stock-Android phones do not need any of this.',
    ),
    _QA(
      question: 'How do I change the app theme?',
      answer:
          'Settings → Appearance → Light or Dark. Your choice persists '
          'across app restarts. A "follow system" option is on the '
          'roadmap.',
    ),
    _QA(
      question: 'The text is too small. Can I make it bigger?',
      answer:
          'Settings → Accessibility → Text size slider (100% – 150%). '
          'This affects readable text throughout the app. The Android '
          'system-wide font scale also applies on top.',
    ),
    _QA(
      question: 'Where is my data stored?',
      answer:
          'Account info (email, display name) lives on our backend at '
          'pediaid-backend.onrender.com (Render + Neon Postgres). Your '
          'preferences (theme, last-used inputs, onboarding flags) live '
          'on this device only and are cleared on uninstall. See the '
          'Privacy Policy for full detail.',
    ),
    _QA(
      question: 'How do I share PediAid with a colleague?',
      answer:
          'Settings → Help & Support → Share the app. Sends a message '
          'with the Play Store link (or web app link if not yet '
          'published).',
    ),
    _QA(
      question: 'How do I rate / review PediAid?',
      answer:
          'Settings → Help & Support → Rate PediAid. Opens Google\'s '
          'native in-app review prompt — you stay inside PediAid. On '
          'web it opens the Play Store listing.',
    ),
    _QA(
      question: 'I found a bug. How do I report it?',
      answer:
          'Settings → Help & Support → Report a bug. The mail is '
          'pre-filled with your app version, build number, platform and '
          'account — saves a back-and-forth. We read every bug report.',
    ),
    _QA(
      question: 'How do I see the welcome tour again?',
      answer:
          'Settings → Help & Support → Replay tutorial. Resets the '
          'tutorial flag — the slides will show on the next app start.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Frequently asked questions',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap any question to expand the answer.',
            style: TextStyle(
              fontSize: 13,
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          ..._items.map((qa) => _QaTile(qa: qa)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.06),
              border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Still need help?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                        fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  'We read every email. Usually within 24 hours.',
                  style: TextStyle(
                      fontSize: 12.5,
                      color: cs.onSurface.withValues(alpha: 0.7)),
                ),
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  _LinkChip(
                    icon: Icons.mail_outline,
                    label: _supportEmail,
                    onTap: () => launchUrl(
                        Uri.parse('mailto:$_supportEmail?subject=PediAid help'),
                        mode: LaunchMode.externalApplication),
                  ),
                  _LinkChip(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Policy',
                    onTap: () => launchUrl(Uri.parse(_privacyUrl),
                        mode: LaunchMode.externalApplication),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QA {
  final String question;
  final String answer;
  const _QA({required this.question, required this.answer});
}

class _QaTile extends StatelessWidget {
  final _QA qa;
  const _QaTile({required this.qa});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 14),
            childrenPadding:
                const EdgeInsets.fromLTRB(14, 0, 14, 14),
            title: Text(qa.question,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: cs.onSurface)),
            iconColor: cs.primary,
            collapsedIconColor: cs.onSurface.withValues(alpha: 0.55),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  qa.answer,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.55,
                    color: cs.onSurface.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _LinkChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: cs.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: cs.onPrimary),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 11.5,
                  color: cs.onPrimary,
                  fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}
