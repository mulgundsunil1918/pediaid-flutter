// =============================================================================
// screens/rabies/rabies_widgets.dart — shared presentation pieces
//
// Small, dumb widgets used by every view in the module. Nothing here decides
// anything clinical; the engine does that.
//
// The one piece carrying real weight is [SourceChip]. Every clinical statement
// in this module is attributable, and an attribution that is easy to skip is
// the same as no attribution — so the chip sits inline with the claim rather
// than in a footnote, and is coloured per source so IAP and NRCP can be told
// apart at a glance in a dense list.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'rabies_protocol.dart';

// ── Palette ──────────────────────────────────────────────────────────────────
//
// Categories carry the severity, so their colours are fixed rather than
// theme-derived: Category III must look the same on every device and in both
// themes, because "did I read a II or a III" is the question this module
// exists to answer.

const Color kCatIBlue = Color(0xFF1565C0);
const Color kCatIIAmber = Color(0xFFB26A00);
const Color kCatIIIRed = Color(0xFFC62828);
const Color kOkGreen = Color(0xFF2E7D32);

Color categoryColor(ExposureCategory c) => switch (c) {
      ExposureCategory.categoryI => kCatIBlue,
      ExposureCategory.categoryII => kCatIIAmber,
      ExposureCategory.categoryIII => kCatIIIRed,
      ExposureCategory.uncertain => const Color(0xFF6A1B9A),
    };

Color warningColor(WarningLevel l) => switch (l) {
      WarningLevel.critical => kCatIIIRed,
      WarningLevel.caution => kCatIIAmber,
      WarningLevel.info => kCatIBlue,
    };

IconData warningIcon(WarningLevel l) => switch (l) {
      WarningLevel.critical => Icons.error_outline,
      WarningLevel.caution => Icons.warning_amber_rounded,
      WarningLevel.info => Icons.info_outline,
    };

Color sourceColor(GuidelineSource s) => switch (s) {
      GuidelineSource.iap2022 => const Color(0xFF00695C),
      GuidelineSource.ncdcNrcp => const Color(0xFF1565C0),
      GuidelineSource.who => const Color(0xFF6A1B9A),
    };

// ── Source attribution ───────────────────────────────────────────────────────

/// The label naming which document a statement came from.
///
/// Tapping opens the source where one is published online. Made tappable
/// because a clinician who disagrees with a recommendation should be one tap
/// from the document, not from an argument with an app.
class SourceChip extends StatelessWidget {
  final GuidelineSource source;
  final bool dense;
  const SourceChip(this.source, {super.key, this.dense = false});

  @override
  Widget build(BuildContext context) {
    final c = sourceColor(source);
    final chip = Container(
      padding: EdgeInsets.symmetric(
          horizontal: dense ? 6 : 8, vertical: dense ? 1.5 : 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: c.withValues(alpha: 0.32)),
      ),
      child: Text(
        source.label,
        style: TextStyle(
          fontSize: dense ? 10 : 10.5,
          fontWeight: FontWeight.w800,
          color: c,
          letterSpacing: 0.2,
        ),
      ),
    );

    final url = source.url;
    if (url == null) return Semantics(label: 'Source: ${source.fullName}', child: chip);

    return Semantics(
      label: 'Source: ${source.fullName}. Opens the document.',
      button: true,
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
        borderRadius: BorderRadius.circular(5),
        child: chip,
      ),
    );
  }
}

/// A sourced statement: the text, with its attribution inline.
class SourcedLine extends StatelessWidget {
  final Sourced item;
  final IconData? icon;
  final Color? iconColor;
  const SourcedLine(this.item, {super.key, this.icon, this.iconColor});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 9),
            child: Icon(icon ?? Icons.check_circle_outline,
                size: 16, color: iconColor ?? cs.primary),
          ),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 7,
              runSpacing: 4,
              children: [
                Text(item.text,
                    style: TextStyle(
                        fontSize: 13.5,
                        height: 1.45,
                        color: cs.onSurface.withValues(alpha: 0.88))),
                SourceChip(item.source, dense: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cards ────────────────────────────────────────────────────────────────────

/// A titled block. Collapsible where the content is long, because this module
/// is used one-handed on a phone mid-consultation.
class RabiesCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color? accent;
  final Widget child;
  final String? subtitle;
  final bool initiallyExpanded;
  final bool collapsible;

  const RabiesCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.accent,
    this.subtitle,
    this.initiallyExpanded = true,
    this.collapsible = false,
  });

  @override
  State<RabiesCard> createState() => _RabiesCardState();
}

class _RabiesCardState extends State<RabiesCard> {
  late bool _open = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final accent = widget.accent ?? cs.primary;

    final header = Row(
      children: [
        Icon(widget.icon, size: 19, color: accent),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title,
                  style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface)),
              if (widget.subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(widget.subtitle!,
                      style: TextStyle(
                          fontSize: 11.5,
                          color: cs.onSurface.withValues(alpha: 0.6))),
                ),
            ],
          ),
        ),
        if (widget.collapsible)
          Icon(_open ? Icons.expand_less : Icons.expand_more,
              size: 20, color: cs.onSurface.withValues(alpha: 0.5)),
      ],
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.collapsible)
            InkWell(
              onTap: () => setState(() => _open = !_open),
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  child: header),
            )
          else
            Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                child: header),
          if (_open)
            Padding(
              padding: EdgeInsets.fromLTRB(
                  14, widget.collapsible ? 0 : 0, 14, 14),
              child: widget.child,
            ),
        ],
      ),
    );
  }
}

/// A high-visibility warning. Level decides the colour, never the author.
class WarningBox extends StatelessWidget {
  final ClinicalWarning warning;
  const WarningBox(this.warning, {super.key});

  @override
  Widget build(BuildContext context) {
    final c = warningColor(warning.level);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.withValues(alpha: 0.42)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(warningIcon(warning.level), size: 17, color: c),
          const SizedBox(width: 9),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 7,
              runSpacing: 4,
              children: [
                Text(warning.text,
                    style: TextStyle(
                        fontSize: 12.8,
                        height: 1.42,
                        fontWeight: warning.level == WarningLevel.critical
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: c)),
                SourceChip(warning.source, dense: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The category badge — the single most important thing on the result screen.
class CategoryBadge extends StatelessWidget {
  final ExposureCategory category;
  final bool large;
  const CategoryBadge(this.category, {super.key, this.large = false});

  @override
  Widget build(BuildContext context) {
    final c = categoryColor(category);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: large ? 14 : 10, vertical: large ? 8 : 5),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(large ? 10 : 7),
        border: Border.all(color: c, width: large ? 1.6 : 1.1),
      ),
      child: Text(
        category.label.toUpperCase(),
        style: TextStyle(
          fontSize: large ? 16 : 11.5,
          fontWeight: FontWeight.w900,
          color: c,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

/// A yes / no / unsure selector.
///
/// Three explicit buttons rather than a switch, because "unsure" has to be as
/// easy to record as "no" — the engine treats them very differently and the UI
/// must not nudge toward the one that happens to be shorter to tap.
class TriSelector extends StatelessWidget {
  final String label;
  final int value; // 0 = yes, 1 = no, 2 = unsure
  final ValueChanged<int> onChanged;
  const TriSelector({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const labels = ['Yes', 'No', 'Unsure'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface.withValues(alpha: 0.85))),
          const SizedBox(height: 7),
          Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: _PillButton(
                    label: labels[i],
                    selected: value == i,
                    onTap: () => onChanged(i),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _PillButton(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          // 44 px is the minimum comfortable touch target, and this module is
          // used one-handed while holding a child's arm.
          constraints: const BoxConstraints(minHeight: 44),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? cs.primary.withValues(alpha: 0.13)
                : cs.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: selected
                  ? cs.primary
                  : cs.outlineVariant.withValues(alpha: 0.8),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              color: selected ? cs.primary : cs.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ),
      ),
    );
  }
}

/// A multi-select chip row.
class SelectChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? accent;
  const SelectChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final c = accent ?? cs.primary;
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? c.withValues(alpha: 0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: selected ? c : cs.outlineVariant.withValues(alpha: 0.8),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                size: 16,
                color: selected ? c : cs.onSurface.withValues(alpha: 0.35),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(label,
                    style: TextStyle(
                        fontSize: 13,
                        height: 1.3,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                        color: selected
                            ? c
                            : cs.onSurface.withValues(alpha: 0.85))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A wide table that scrolls inside itself.
///
/// Without this the page body scrolls sideways, which on a phone makes a
/// reference table unusable — the exact defect that made the neonatal score
/// tables hide their grade-2 column off-screen.
class ScrollableTable extends StatelessWidget {
  final Widget child;
  const ScrollableTable({super.key, required this.child});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: child,
      );
}

/// The module disclaimer. Present, readable, and deliberately not large.
class RabiesDisclaimer extends StatelessWidget {
  const RabiesDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 6, 2, 26),
      child: Text(
        kRabiesDisclaimer,
        style: TextStyle(
            fontSize: 11,
            height: 1.5,
            color: cs.onSurface.withValues(alpha: 0.55)),
      ),
    );
  }
}
