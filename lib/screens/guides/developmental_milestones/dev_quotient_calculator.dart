// =============================================================================
// lib/screens/guides/developmental_milestones/dev_quotient_calculator.dart
//
// Developmental Quotient calculator. Per-domain DQ:
//
//   DQ = (Developmental Age in domain / Chronological Age) × 100
//
// One CA input + four DA inputs (Gross Motor, Fine Motor, Language,
// Socioadaptive — the Gesell four). Hearing and Vision are usually
// reported descriptively, not via DQ; we keep them visible if the user
// also wants to enter them but they don't drive the "global DQ" headline.
//
// Interpretation bands per Nelson + Ghai consensus:
//   ≥ 85 → Normal
//   70–84 → At-risk / borderline
//   < 70 → Significant developmental delay
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dev_milestones_data.dart';

class DevQuotientCalculator extends StatefulWidget {
  const DevQuotientCalculator({super.key});

  @override
  State<DevQuotientCalculator> createState() => _DevQuotientCalculatorState();
}

class _DevQuotientCalculatorState extends State<DevQuotientCalculator> {
  final _ca = TextEditingController(); // chronological age in months
  final Map<DevDomain, TextEditingController> _da = {
    for (final d in DevDomain.values) d: TextEditingController(),
  };

  @override
  void dispose() {
    _ca.dispose();
    for (final c in _da.values) {
      c.dispose();
    }
    super.dispose();
  }

  double? get _caMonths {
    final v = double.tryParse(_ca.text.trim());
    if (v == null || v <= 0) return null;
    return v;
  }

  double? _daMonths(DevDomain d) {
    final v = double.tryParse(_da[d]!.text.trim());
    if (v == null || v <= 0) return null;
    return v;
  }

  double? _dq(DevDomain d) {
    final ca = _caMonths;
    final da = _daMonths(d);
    if (ca == null || da == null) return null;
    return (da / ca) * 100;
  }

  /// Headline DQ — average of the four core domains (Gesell). We deliberately
  /// average rather than report the lowest, because clinicians use both:
  /// "average DQ" for global functional status and "lowest DQ" for the
  /// driver of intervention. Both are surfaced.
  double? get _headlineDq {
    final core = [
      DevDomain.grossMotor,
      DevDomain.fineMotor,
      DevDomain.language,
      DevDomain.socioadaptive,
    ];
    final values = core.map(_dq).whereType<double>().toList();
    if (values.length < 2) return null;
    return values.reduce((a, b) => a + b) / values.length;
  }

  double? get _lowestDq {
    final values =
        DevDomain.values.map(_dq).whereType<double>().toList();
    if (values.isEmpty) return null;
    return values.reduce((a, b) => a < b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final headline = _headlineDq;
    final lowest = _lowestDq;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developmental Quotient'),
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
            // Formula reminder
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: cs.primary.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  Icon(Icons.functions_rounded, color: cs.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'DQ = (Developmental Age ÷ Chronological Age) × 100\nEnter chronological age and the developmental age the child has reached in each domain (in months).',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Chronological age input
            _NumberInput(
              label: 'Chronological age',
              suffix: 'months',
              controller: _ca,
              onChanged: () => setState(() {}),
              accent: cs.primary,
              hint: 'e.g. 18',
            ),
            const SizedBox(height: 6),
            Text(
              'For preterm infants ≤ 24 months postnatal, use CORRECTED chronological age.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontStyle: FontStyle.italic,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),

            // Headline result
            if (headline != null) ...[
              _HeadlineResult(
                  averageDq: headline,
                  lowestDq: lowest!,
                  cs: cs),
              const SizedBox(height: 18),
            ],

            // Per-domain DA inputs
            Text(
              'Developmental age — per domain',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            for (final d in DevDomain.values)
              _DomainDqRow(
                domain: d,
                controller: _da[d]!,
                ca: _caMonths,
                onChanged: () => setState(() {}),
              ),

            const SizedBox(height: 18),

            // Interpretation bands legend
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interpretation bands  ·  Nelson + Ghai',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (final b in kDqBands) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 3, right: 8),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: b.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                color: cs.onSurface,
                                height: 1.45,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      'DQ ${b.upper >= 200 ? "≥ ${b.lower.toStringAsFixed(0)}" : "${b.lower.toStringAsFixed(0)}–${(b.upper - 1).toStringAsFixed(0)}"}: ',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                    color: b.color,
                                  ),
                                ),
                                TextSpan(text: '${b.label}. '),
                                TextSpan(
                                  text: b.interpretation,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    color: cs.onSurfaceVariant,
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 16, color: cs.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Two or more domains with DQ < 70 → Global Developmental Delay → refer for full assessment + early intervention.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberInput extends StatelessWidget {
  final String label;
  final String suffix;
  final String hint;
  final Color accent;
  final TextEditingController controller;
  final VoidCallback onChanged;
  const _NumberInput({
    required this.label,
    required this.suffix,
    required this.controller,
    required this.onChanged,
    required this.accent,
    required this.hint,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: accent,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  onChanged: (_) => onChanged(),
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: hint,
                    hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurface.withValues(alpha: 0.4)),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Text(
                suffix,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DomainDqRow extends StatelessWidget {
  final DevDomain domain;
  final TextEditingController controller;
  final double? ca;
  final VoidCallback onChanged;
  const _DomainDqRow({
    required this.domain,
    required this.controller,
    required this.ca,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final info = kDomainInfo[domain]!;
    final daText = controller.text.trim();
    final da = double.tryParse(daText);
    final dq = (ca != null && ca! > 0 && da != null && da > 0)
        ? (da / ca!) * 100
        : null;
    final band = dq != null ? interpretDq(dq) : null;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: band?.color.withValues(alpha: 0.45) ??
              cs.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: info.color.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(info.icon, color: info.color, size: 18),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              info.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 76,
            child: TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => onChanged(),
              textAlign: TextAlign.right,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'DA mo',
                hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface.withValues(alpha: 0.35)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: cs.outlineVariant.withValues(alpha: 0.55)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: cs.outlineVariant.withValues(alpha: 0.55)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (dq != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: band!.color.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'DQ ${dq.toStringAsFixed(0)}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: band.color,
                ),
              ),
            )
          else
            Text(
              '—',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: cs.onSurface.withValues(alpha: 0.3),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeadlineResult extends StatelessWidget {
  final double averageDq;
  final double lowestDq;
  final ColorScheme cs;
  const _HeadlineResult({
    required this.averageDq,
    required this.lowestDq,
    required this.cs,
  });
  @override
  Widget build(BuildContext context) {
    final avgBand = interpretDq(averageDq);
    final lowBand = interpretDq(lowestDq);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            avgBand.color.withValues(alpha: 0.18),
            avgBand.color.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: avgBand.color.withValues(alpha: 0.40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights_rounded, color: avgBand.color, size: 20),
              const SizedBox(width: 8),
              Text(
                'GLOBAL DQ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: avgBand.color,
                ),
              ),
              const Spacer(),
              Text(
                averageDq.toStringAsFixed(0),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                  color: avgBand.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            avgBand.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: avgBand.color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            avgBand.interpretation,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            decoration: BoxDecoration(
              color: cs.surface.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      color: lowBand.color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(
                  'Lowest domain DQ: ${lowestDq.toStringAsFixed(0)} (${lowBand.label})',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: lowBand.color,
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
