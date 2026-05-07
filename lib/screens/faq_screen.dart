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
    // ── About PediAid ───────────────────────────────────────────────────
    _QA(
      question: 'What is PediAid?',
      answer:
          'PediAid is a paediatric & neonatal clinical reference app. '
          'In one place: 40+ bedside calculators, 676 drugs (Neofax + '
          'Harriet Lane) with a structured detail view, growth charts '
          '(WHO, IAP, Fenton, INTERGROWTH), bilirubin pathways (AAP '
          '2022 + NICE CG98), IAP STG 2022, IAP Action Plan 2026, NNF '
          'CPG 2021, lab references, emergency NICU/PICU drug bundles '
          'and acute-care protocols (DKA, RSI, status epilepticus, snake '
          '/ scorpion envenomation, hypertensive emergency).\n\n'
          'Runs on Android, iOS, web and desktop. Works offline once '
          'the assets load.',
    ),
    _QA(
      question: 'Who is PediAid built for?',
      answer:
          'Paediatricians, neonatologists, paediatric / neonatal '
          'registrars and fellows, NICU / PICU nurses and final-year '
          'medical students. The app assumes the user is a qualified '
          'or training healthcare professional.',
    ),
    _QA(
      question: 'Is PediAid a substitute for clinical judgement?',
      answer:
          'No. PediAid is a clinical decision support tool intended '
          'for use by qualified healthcare professionals only. Always '
          'verify every dose, threshold and centile against current '
          'guidelines, the patient\'s clinical context and your local '
          'protocols before any treatment decision.',
    ),

    // ── Sources & accuracy ─────────────────────────────────────────────
    _QA(
      question: 'Where does the data come from?',
      answer:
          '• Bilirubin thresholds: AAP 2022 (≥35 wk) and NICE CG98 '
          '(<35 wk).\n'
          '• Growth charts: WHO 2006 / 2007, IAP 2015, Fenton 2013, '
          'INTERGROWTH-21st.\n'
          '• Drug formulary: Neofax Nov 2024 (199 NICU drugs, fully '
          'cross-checked) + Harriet Lane 22nd edition (478 paediatric '
          'drugs, restructured into clean dose blocks).\n'
          '• Indian brand names: IAP Drug Formulary 2024 + DailyMed '
          'cross-references.\n'
          '• Standard treatment guidelines: IAP STG 2022, IAP Action '
          'Plan 2026, NNF CPG 2021.\n'
          '• Lab references: Harriet Lane chapter 14.\n\n'
          'Every calculator, drug entry and chart names its source on '
          'screen. Original PDFs are reachable from inside each drug '
          'page via the "Open source PDF" link.',
    ),
    _QA(
      question: 'How are drug doses cross-checked?',
      answer:
          'Each of the 199 Neofax-derived drugs has every numeric dose '
          'fact verified against the source Neofax monograph: 75% are '
          'verbatim matches, the remaining 25% are intentional '
          'paraphrasing (same numeric value and unit, different '
          'surrounding wording — done to stay copyright-safe). Spot '
          'checks across 100+ paraphrased entries found zero numeric '
          'or unit errors.\n\n'
          'Harriet Lane–derived paediatric drugs are auto-extracted by '
          'a structured-section parser, then split into Quick Summary, '
          'Dose, Preparation, Monitoring, Common vs Serious adverse '
          'effects and Contraindications. Original wording is preserved '
          'verbatim — only the layout changes.',
    ),
    _QA(
      question: 'How accurate are the calculators?',
      answer:
          'The math is verified against the source publication for '
          'every tool. Formulas are visible on every result screen so '
          'you can re-check the calculation yourself. If you find a '
          'discrepancy, report it via Settings → Report a bug — we '
          'read every report.',
    ),

    // ── Finding things in the app ──────────────────────────────────────
    _QA(
      question: 'How do I find a specific drug, calculator or guideline?',
      answer:
          'Tap the search bar at the top of the home screen. Type '
          'anything — drug names, abbreviations, guideline topics — and '
          'results land grouped by category (Calculators, Drugs, '
          'Guides, Charts, IAP STG, NNF CPG, Academics).\n\n'
          'Common abbreviations resolve automatically:\n'
          '• "uti" → urinary tract infection chapter\n'
          '• "dka" → diabetic ketoacidosis algorithm\n'
          '• "rsi" → rapid sequence intubation\n'
          '• "2d echo" → neonatal echo guide + echo calculators\n'
          '• "vanc" → Vancomycin drug entry\n'
          '• "apap" or "acetaminophen" → Paracetamol\n'
          '• "ett" → endotracheal tube size & depth\n'
          '• "uvc / uac" → umbilical catheter depth\n'
          '• "sga / aga / lga / lbw / vlbw / elbw" → birthweight '
          'classification.',
    ),
    _QA(
      question: 'How do I read a drug\'s dose page?',
      answer:
          'Drug Formulary → "Drug Formulary 2.0" → Neonatology or '
          'Paediatrics → tap the drug. The detail page is laid out the '
          'same way for every drug:\n\n'
          '1. Quick Summary card — auto-extracted Route · Key dose · '
          'Infusion · Max · Watch for · Monitor.\n'
          '2. Dose — per indication, per population (Neonate / Infant / '
          'Child / Adolescent / Adult), with route chips and bold dose '
          'values.\n'
          '3. Indian formulations & brands (Neofax drugs).\n'
          '4. Preparation — reconstitution + incompatibilities.\n'
          '5. Monitoring.\n'
          '6. Common adverse effects (orange) vs Serious toxicities '
          '(red — sentences containing fatal / cardiac arrest / '
          'anaphylaxis / Stevens-Johnson / hepatic failure / etc. '
          'auto-flagged).\n'
          '7. Contraindications & cautions.\n'
          '8. Renal / hepatic adjustment.\n'
          '9. Notes & pearls.\n\n'
          'The original Neofax / Harriet Lane PDF is one tap away from '
          'the bottom of every drug page.',
    ),
    _QA(
      question: 'What\'s Emergency NICU / PICU Drugs?',
      answer:
          'A red banner on the Drug Formulary screen leads to '
          'crash-cart drug bundles with live weight-based preparation. '
          'Enter the patient\'s weight once and see ready-to-give doses '
          'for adrenaline, atropine, naloxone, sodium bicarbonate, '
          'calcium gluconate, dextrose 10% and the full PICU '
          'pressor / inotrope / sedation infusion list.\n\n'
          'Faster than a calculator when seconds matter.',
    ),
    _QA(
      question: 'How do I customise Quick Access?',
      answer:
          'On the home screen → Quick Access section → tap "Edit". '
          'You can add or remove tiles for any combination of '
          'calculators and tools. The choice persists on this device '
          'and survives app restarts.',
    ),

    // ── Privacy ────────────────────────────────────────────────────────
    _QA(
      question: 'Is my patient data sent anywhere?',
      answer:
          'No. Anything you type into a calculator (weight, gestational '
          'age, lab values, drug doses) is never sent to our servers '
          'and is discarded as soon as you close the screen. The drug '
          'formulary, calculators, charts and guides all run entirely '
          'on-device.',
    ),
    _QA(
      question: 'Where is my data stored?',
      answer:
          'Your preferences (theme, last-used inputs, Quick Access '
          'tiles, onboarding flags) live on THIS DEVICE only, in '
          'SharedPreferences. They are cleared when you uninstall.\n\n'
          'If you sign in (when account login is enabled), your email '
          'and display name live on our backend at '
          'pediaid-backend.onrender.com (Render + Neon Postgres). See '
          'the Privacy Policy for full detail.',
    ),

    // ── Account ─────────────────────────────────────────────────────────
    _QA(
      question: 'Do I need an account to use PediAid?',
      answer:
          'No. Calculators, charts, drug formulary, growth charts, '
          'guides and emergency tools all work without an account.\n\n'
          'Login is currently disabled while we polish the app. When '
          'it returns, an account will only be needed for the '
          'Academics web module (peer-reviewed chapters, CME tracking, '
          'contributor features).',
    ),
    _QA(
      question: 'How do I create an account?',
      answer:
          'Login is currently disabled in this build for testing. When '
          'it\'s re-enabled: Sign in screen → Create account, valid '
          'email + 8-character password, you\'ll get a verification '
          'email (check spam if it doesn\'t arrive in 5 minutes).',
    ),
    _QA(
      question: 'I forgot my password.',
      answer:
          'When account login is enabled: Sign in → Forgot password → '
          'enter your email. You\'ll get a reset link valid for 1 hour. '
          'If the email doesn\'t arrive, check spam.',
    ),
    _QA(
      question: 'How do I sign out / delete my account?',
      answer:
          'Settings → Danger zone → Sign out (you can sign back in any '
          'time) or Delete account (you\'ll be asked to type DELETE; '
          'deletion is immediate and permanent — no soft-delete, no '
          'grace period; all your data is removed from our servers).',
    ),

    // ── Tutorials & device ─────────────────────────────────────────────
    _QA(
      question: 'How do I see the tutorial again?',
      answer:
          'Settings → Help & Support → Replay tutorial. This resets '
          'BOTH the 6-slide welcome onboarding (Welcome → Calculators → '
          'Drug Formulary → Emergency → Guidelines → Search) AND the '
          '6-step coachmark tour over the real home-screen UI (drawer, '
          'search bar, Quick Access, Calculators tile, Drug Formulary, '
          'Guides). The next app open will replay both.',
    ),
    _QA(
      question:
          'I\'m not getting push notifications on my Samsung / Xiaomi / '
          'OnePlus / Vivo / Oppo phone.',
      answer:
          'These OEMs aggressively kill background apps to save '
          'battery, which breaks push delivery. To fix:\n\n'
          '1. Long-press the PediAid icon → App info.\n'
          '2. Battery → set to "Unrestricted" (Samsung) / "No '
          'restrictions" (others).\n'
          '3. On Xiaomi / Oppo / Vivo / Realme: open Security app → '
          'Permissions → Autostart → enable for PediAid.\n'
          '4. On Samsung: Settings → Battery and device care → '
          'Battery → Background usage limits → Never sleeping apps → '
          'add PediAid.\n\n'
          'Pixel and stock-Android phones don\'t need any of this.',
    ),
    _QA(
      question: 'How do I change the app theme or text size?',
      answer:
          'Settings → Appearance → Light / Dark (your choice persists '
          'across restarts). For text size: Settings → Accessibility → '
          'Text size slider (100% – 150%). The Android system-wide '
          'font scale also applies on top.',
    ),

    // ── Feedback ───────────────────────────────────────────────────────
    _QA(
      question: 'How do I share PediAid with a colleague?',
      answer:
          'Settings → Help & Support → Share the app. Sends a message '
          'with the Play Store link (or the web app link until the '
          'Play Store listing is live).',
    ),
    _QA(
      question: 'How do I rate / review PediAid?',
      answer:
          'Settings → Help & Support → Rate PediAid. Opens Google\'s '
          'native in-app review prompt — you stay inside the app. On '
          'web it opens the Play Store listing.',
    ),
    _QA(
      question: 'I found a bug or want a new feature. How do I report it?',
      answer:
          'Settings → Help & Support → Report a bug (or → Suggest a '
          'feature). The email is pre-filled with your app version, '
          'build number, platform and account, so we don\'t have to '
          'ask you back. We read every email.',
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
