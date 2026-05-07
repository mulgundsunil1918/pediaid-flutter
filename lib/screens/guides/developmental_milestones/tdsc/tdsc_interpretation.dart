// =============================================================================
// lib/screens/guides/developmental_milestones/tdsc/tdsc_interpretation.dart
//
// Plain-language explainer of how the TDSC works:
//   • The vertical-line method
//   • Pass / fail rule
//   • The "≥ 2 fails = suspect" cut-off + sensitivity
//   • Age correction for prematurity
//   • Caveats — what the screen does NOT do
//   • Citation
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TdscInterpretationScreen extends StatelessWidget {
  const TdscInterpretationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Read TDSC'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: SafeArea(
        bottom: true,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
          children: [
            _section(
              cs,
              icon: Icons.straighten_rounded,
              tint: const Color(0xFF1565C0),
              title: '1. Drop a vertical line at the child\'s age',
              body:
                  'Find the child\'s age on the X-axis (in months). Imagine a perfectly vertical line from that point. The line will cut across several horizontal bars — those bars are the items you screen at this visit. Outside that crossed set, items are either too easy (already mastered) or too advanced (not yet expected) and are not scored.',
            ),
            _section(
              cs,
              icon: Icons.check_circle_outline_rounded,
              tint: const Color(0xFF16A34A),
              title: '2. Mark each crossed item PASS or FAIL',
              body:
                  'For every item the line crosses, observe or elicit the behaviour. PASS = the child performs the item, even with parental report for clearly remembered things. FAIL = the child cannot perform the item AND has not been seen to do it at home.',
            ),
            _section(
              cs,
              icon: Icons.warning_amber_rounded,
              tint: const Color(0xFFDC2626),
              title: '3. Two or more fails ⇒ SUSPECT',
              body:
                  'If 2 or more crossed items fail, the screen is positive — refer for formal developmental assessment (Bayley III / DASII / Vineland) and a paediatric neurology evaluation. A score of ≤ 1 fail is reassuring; reassess at the next routine visit.',
              highlight: true,
            ),
            _section(
              cs,
              icon: Icons.child_care_rounded,
              tint: const Color(0xFFE65100),
              title: '4. Correct age for prematurity (≤ 24 mo)',
              body:
                  'For preterm infants up to 24 months chronological age, use age corrected for prematurity:\n\n     Corrected age = Chronological age − (40 − GA in weeks) ÷ 4\n\nExample — chronological 6 mo, GA 32 wk: corrected age = 6 − (40−32)/4 = 6 − 2 = 4 mo. Apply the vertical line at 4 mo, not 6.',
            ),
            _section(
              cs,
              icon: Icons.balance_rounded,
              tint: const Color(0xFF6A1B9A),
              title: '5. What the chart does NOT do',
              body:
                  '• It does not diagnose autism, intellectual disability, or specific language disorder — those need standardised tools and longitudinal evaluation.\n\n'
                  '• It does not give a developmental quotient or developmental age — for that use the Developmental Quotient calculator from the parent module.\n\n'
                  '• It does not replace clinical judgement. A child with concerning red flags (loss of acquired skills, severe parental concern, atypical neurology) still warrants referral even if they pass the screen.',
            ),
            _section(
              cs,
              icon: Icons.science_rounded,
              tint: const Color(0xFF00897B),
              title: '6. Performance characteristics',
              body:
                  'In the original CDC Trivandrum cohort, TDSC sensitivity for detecting children later confirmed delayed on Bayley/DASII was reported around 66 – 71 % with specificity 78 – 82 % — so it is intentionally tuned to over-refer rather than miss. Re-screen at every routine visit; persistent positives matter more than a one-off result.',
            ),
            _section(
              cs,
              icon: Icons.menu_book_rounded,
              tint: const Color(0xFF1565C0),
              title: '7. Original sources',
              body:
                  '• Nair MK, Nair GH, Mini AO, et al. Trivandrum Developmental Screening Chart (TDSC). Indian Pediatrics 2009; 46 Suppl: S57–61.\n\n'
                  '• Nair MK, Nair GH, George B, Suma N, et al. Development and validation of TDSC for children aged 0–6 years. Indian Pediatrics 2013; 50: 837–840.\n\n'
                  '• Child Development Centre, Trivandrum Medical College, Government of Kerala — official TDSC training material.',
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Use the Smart Screen to apply rules 1–4 in seconds, or the Chart View to see exactly which items are crossed at any age.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(
    ColorScheme cs, {
    required IconData icon,
    required Color tint,
    required String title,
    required String body,
    bool highlight = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: highlight
            ? tint.withValues(alpha: 0.08)
            : cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlight
              ? tint.withValues(alpha: 0.5)
              : cs.outlineVariant.withValues(alpha: 0.55),
          width: highlight ? 1.4 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: tint, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              height: 1.55,
              fontWeight: FontWeight.w500,
              color: cs.onSurface.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
