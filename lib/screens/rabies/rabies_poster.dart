// =============================================================================
// screens/rabies/rabies_poster.dart — the NRCP poster, reproduced in full
//
// "PROTOCOL FOR RABIES POST EXPOSURE PROPHYLAXIS AFTER ANIMAL BITE", Ministry
// of Health and Family Welfare, Government of India — National Rabies Control
// Programme.
//
// WHY EVERY WORD, AND NOT A SUMMARY
// ---------------------------------
// The first version of this module paraphrased the poster into categories and
// schedules. That lost things that turn out to carry weight: the dose COUNTS
// ("04 doses", "05 doses", "02 doses") that tell a pharmacist what to issue,
// the "IMMUNE COMPETENT PERSON" qualifier on every regimen, the reporting
// requirement, the statement that NRCP advocates the intradermal route, and
// the programme's own framing. A clinician who knows the poster should be able
// to find any line of it here.
//
// So the text below is transcribed verbatim, including the source's own
// emphasis. Where the poster uses a picture to carry meaning — a tap and soap,
// a syringe, a vial — an emoji stands in, because the meaning is part of the
// content and a wall of unbroken text is not what the original communicates.
//
// The poster's own spellings are kept ("atleast", "imunoglobulin") only where
// quoting exactly matters; obvious typography is normalised for legibility.
// =============================================================================

import 'package:flutter/material.dart';

import 'rabies_protocol.dart';
import 'rabies_widgets.dart';

// ── Header ───────────────────────────────────────────────────────────────────

class PosterHeader extends StatelessWidget {
  const PosterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text('MINISTRY OF HEALTH AND FAMILY WELFARE',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: cs.onSurface.withValues(alpha: 0.65))),
          Text('GOVERNMENT OF INDIA',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: cs.onSurface.withValues(alpha: 0.55))),
          const SizedBox(height: 10),
          Text(
            'PROTOCOL FOR RABIES POST EXPOSURE PROPHYLAXIS AFTER ANIMAL BITE',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15,
                height: 1.3,
                fontWeight: FontWeight.w900,
                color: cs.onSurface),
          ),
        ],
      ),
    );
  }
}

/// One of the poster's two banner headings.
class PosterBanner extends StatelessWidget {
  const PosterBanner(this.text, {super.key, this.emoji});
  final String text;
  final String? emoji;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: cs.primary.withValues(alpha: 0.55), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (emoji != null) ...[
            Text(emoji!, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                    color: cs.primary)),
          ),
        ],
      ),
    );
  }
}

// ── DECISION TO TREAT ────────────────────────────────────────────────────────

/// The poster's first block: each category, and what it earns.
///
/// The original is a table — category on the left, washing in the middle
/// spanning all three rows, outcome on the right. On a phone that becomes one
/// card per category with the outcome inside it, and the washing column lifted
/// out below, because it applies to every row anyway.
class DecisionToTreat extends StatelessWidget {
  const DecisionToTreat({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PosterBanner('DECISION TO TREAT', emoji: '🐕'),
        _row(
          context,
          ExposureCategory.categoryI,
          const ['Touching or feeding of animals', 'Licks on intact skin'],
          outcome: 'No prophylaxis needed',
          outcomeNote: '(If reliable contact history is available)',
          outcomeEmoji: '✅',
        ),
        _row(
          context,
          ExposureCategory.categoryII,
          const [
            'Nibbling of uncovered skin',
            'Minor scratches or abrasions without bleeding',
          ],
          outcome: 'ONLY RABIES VACCINATION',
          outcomeEmoji: '💉',
        ),
        _row(
          context,
          ExposureCategory.categoryIII,
          const [
            'Single or multiple transdermal bites or scratches',
            'Licks on broken skin',
            'Contamination of mucous membrane with saliva',
          ],
          outcome: 'RABIES VACCINATION  +  RIG INFILTRATION',
          outcomeEmoji: '💉🧪',
        ),
        const _WashBlock(),
        const _PosterFootnote(
          '*All categories of bite should be reported in NRCP monthly report.',
        ),
      ],
    );
  }

  Widget _row(
    BuildContext context,
    ExposureCategory cat,
    List<String> bullets, {
    required String outcome,
    required String outcomeEmoji,
    String? outcomeNote,
  }) {
    final cs = Theme.of(context).colorScheme;
    final c = categoryColor(cat);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: c.withValues(alpha: 0.5),
            // Category III carries the most consequence and the most weight.
            width: cat == ExposureCategory.categoryIII ? 1.8 : 1.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryBadge(cat),
                const SizedBox(height: 8),
                for (final b in bullets)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('•  ',
                            style: TextStyle(
                                fontSize: 13, height: 1.4, color: c)),
                        Expanded(
                          child: Text(b,
                              style: TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface.withValues(alpha: 0.9))),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: c.withValues(alpha: 0.13),
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(11)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(outcomeEmoji, style: const TextStyle(fontSize: 15)),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(outcome,
                          style: TextStyle(
                              fontSize: 12.5,
                              height: 1.35,
                              fontWeight: FontWeight.w900,
                              color: c)),
                      if (outcomeNote != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(outcomeNote,
                              style: TextStyle(
                                  fontSize: 11.5,
                                  height: 1.35,
                                  color: c.withValues(alpha: 0.85))),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The washing column, verbatim. Applies to every category, which is why the
/// poster spans it across all three rows.
class _WashBlock extends StatelessWidget {
  const _WashBlock();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: kCatIIIRed.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kCatIIIRed.withValues(alpha: 0.55), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🧼🚿', style: TextStyle(fontSize: 17)),
              SizedBox(width: 9),
              Expanded(
                child: Text('WASH FIRST — EVERY CATEGORY',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.3,
                        color: kCatIIIRed)),
              ),
            ],
          ),
          const SizedBox(height: 9),
          // The poster prints "15 minutes" in red inside the sentence; the
          // emphasis is part of the instruction, so it is preserved.
          Text.rich(
            TextSpan(
              style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: cs.onSurface.withValues(alpha: 0.9)),
              children: const [
                TextSpan(
                    text: 'Gently wash all scratches or wounds with mild soap '
                        'and running water for atleast '),
                TextSpan(
                    text: '"15 minutes"',
                    style: TextStyle(
                        fontWeight: FontWeight.w900, color: kCatIIIRed)),
                TextSpan(
                    text: ' irrespective of exposure category to decrease '
                        'viral load'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PosterFootnote extends StatelessWidget {
  const _PosterFootnote(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📝  ', style: TextStyle(fontSize: 12)),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 11.5,
                    height: 1.45,
                    fontStyle: FontStyle.italic,
                    color: cs.onSurface.withValues(alpha: 0.7))),
          ),
        ],
      ),
    );
  }
}

// ── POST EXPOSURE PROPHYLAXIS PROTOCOL — the regimen boxes ───────────────────

/// One of the poster's three dose boxes, verbatim.
///
/// The dose COUNTS matter and were lost in the first version: "04 doses" and
/// "05 doses" are what a clinician tells the pharmacy, and "02 doses" is the
/// whole difference the previously-immunised branch makes.
class RegimenBox extends StatelessWidget {
  const RegimenBox({
    super.key,
    required this.heading,
    required this.headingEmoji,
    required this.color,
    required this.idDoses,
    required this.idDetail,
    required this.idDays,
    required this.imDoses,
    required this.imDetail,
    required this.imDays,
    this.headingNote,
  });

  final String heading;
  final String headingEmoji;
  final String? headingNote;
  final Color color;
  final String idDoses, idDetail, idDays;
  final String imDoses, imDetail, imDays;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.55), width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.13),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(headingEmoji, style: const TextStyle(fontSize: 15)),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(heading,
                          style: TextStyle(
                              fontSize: 13,
                              height: 1.3,
                              fontWeight: FontWeight.w900,
                              color: color)),
                      if (headingNote != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(headingNote!,
                              style: TextStyle(
                                  fontSize: 11,
                                  height: 1.35,
                                  color: color.withValues(alpha: 0.85))),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // The poster labels every regimen box this way. It is the
                // qualifier that sends an immunocompromised child elsewhere.
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text('IMMUNE COMPETENT PERSON',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.4,
                          color: cs.onSurface.withValues(alpha: 0.75))),
                ),
                const SizedBox(height: 12),
                _route(cs, '💉', idDoses, 'via intradermal route — ID',
                    idDetail, idDays, color),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  child: Center(
                    child: Text('OR',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface.withValues(alpha: 0.6))),
                  ),
                ),
                _route(cs, '💉', imDoses, 'via intramuscular route — IM',
                    imDetail, imDays, color),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _route(ColorScheme cs, String emoji, String doses, String route,
      String detail, String days, Color c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(doses,
                  style: TextStyle(
                      fontSize: 13,
                      height: 1.3,
                      fontWeight: FontWeight.w900,
                      color: c)),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22, top: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(route,
                  style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface.withValues(alpha: 0.85))),
              Text(detail,
                  style: TextStyle(
                      fontSize: 11.5,
                      height: 1.35,
                      color: cs.onSurface.withValues(alpha: 0.65))),
              const SizedBox(height: 5),
              // A Wrap, not a Row: "0 – 3 – 7 – 14 – 28" set at 16 px runs
              // 62 px past a 375 px phone, and the days are the one part of
              // this box that must not be clipped.
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('📅  on day  ',
                      style: TextStyle(
                          fontSize: 11.5,
                          color: cs.onSurface.withValues(alpha: 0.7))),
                  Text(days,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: c)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A plain bordered note, as the poster prints its several boxed remarks.
class PosterNote extends StatelessWidget {
  const PosterNote({
    super.key,
    required this.title,
    required this.emoji,
    required this.lines,
    this.color,
    this.bulleted = true,
  });

  final String title;
  final String emoji;
  final List<String> lines;
  final Color? color;
  final bool bulleted;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final c = color ?? cs.primary;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: c.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 15)),
              const SizedBox(width: 9),
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        fontSize: 12.5,
                        height: 1.35,
                        fontWeight: FontWeight.w900,
                        color: c)),
              ),
            ],
          ),
          if (lines.isNotEmpty) const SizedBox(height: 8),
          for (final l in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (bulleted)
                    Text('•  ',
                        style: TextStyle(fontSize: 12.5, height: 1.45, color: c)),
                  Expanded(
                    child: Text(l,
                        style: TextStyle(
                            fontSize: 12.5,
                            height: 1.45,
                            color: cs.onSurface.withValues(alpha: 0.88))),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Footer ───────────────────────────────────────────────────────────────────

class PosterFooter extends StatelessWidget {
  const PosterFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 4, bottom: 14),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: cs.primary.withValues(alpha: 0.4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('⭐', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  '*NRCP ADVOCATES INTRADERMAL ROUTE FOR RABIES VACCINE '
                  'ADMINISTRATION',
                  style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.2,
                      color: cs.primary),
                ),
              ),
            ],
          ),
        ),
        Divider(color: cs.onSurface.withValues(alpha: 0.3), thickness: 1.2),
        const SizedBox(height: 8),
        Text('NATIONAL RABIES CONTROL PROGRAMME',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.4,
                color: cs.onSurface)),
        const SizedBox(height: 4),
        Text('🐕  ADOPT ONE HEALTH, STOP RABIES  🩺',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12,
                letterSpacing: 0.6,
                color: cs.onSurface.withValues(alpha: 0.7))),
        const SizedBox(height: 6),
        Divider(color: cs.onSurface.withValues(alpha: 0.3), thickness: 1.2),
      ],
    );
  }
}
