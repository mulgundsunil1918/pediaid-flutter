// =============================================================================
// lib/screens/drugs/emergency/advanced_tools.dart
//
// Collapsible Advanced Tools tray for the Emergency NICU Drugs screen.
// Provides quick utilities that complement the main drug cards:
//   • Share preparation summary (clipboard)
//   • Syringe-change helper (info dialog)
//   • GA-adjusted cautions (input-driven flags)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Entry point — renders the collapsible card.
/// [weight] is the current baby weight in kg (nullable when user hasn't typed).
class AdvancedTools extends StatefulWidget {
  const AdvancedTools({super.key, required this.weight});

  final double? weight;

  @override
  State<AdvancedTools> createState() => _AdvancedToolsState();
}

class _AdvancedToolsState extends State<AdvancedTools> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.tune_rounded, size: 18, color: cs.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Advanced Tools',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 6),
              child: Column(
                children: [
                  _tool(
                    icon: Icons.share_outlined,
                    title: 'Share Preparation Summary',
                    subtitle:
                        'Copy preparation for all drugs at the current weight',
                    onTap: widget.weight == null
                        ? null
                        : () => _sharePrepSummary(context, widget.weight!),
                  ),
                  _tool(
                    icon: Icons.swap_horiz_rounded,
                    title: 'Syringe Change Calculator',
                    subtitle:
                        'Match the current concentration into a new syringe volume',
                    onTap: () => _showSyringeChangeDialog(context),
                  ),
                  _tool(
                    icon: Icons.timeline,
                    title: 'GA-adjusted Notes',
                    subtitle:
                        'Flag drugs with limited evidence at the entered gestation',
                    onTap: () => _showGaAdjustedDialog(context),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _tool({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    final disabled = onTap == null;
    return Opacity(
      opacity: disabled ? 0.55 : 1.0,
      child: ListTile(
        leading: Icon(icon, color: cs.primary, size: 20),
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            color: cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: cs.onSurface.withValues(alpha: 0.35),
        ),
        onTap: onTap,
      ),
    );
  }

  // ── Share summary ────────────────────────────────────────────────────────
  void _sharePrepSummary(BuildContext context, double w) {
    final ws = w.toStringAsFixed(2);
    final buf = StringBuffer()
      ..writeln('PediAid — Drug Prep for $ws kg baby')
      ..writeln('')
      ..writeln('Catecholamines & Inotropes:')
      ..writeln('• Dopamine: ${(15 * w / 40).toStringAsFixed(2)} ml (40mg/ml) + NS to 24ml → 1 ml/hr = 10 mcg/kg/min')
      ..writeln('• Dobutamine: ${(15 * w / 50).toStringAsFixed(2)} ml (50mg/ml) + NS to 24ml → 1 ml/hr = 10 mcg/kg/min')
      ..writeln('• Adrenaline: ${(1.5 * w).toStringAsFixed(2)} ml (1mg/ml) + NS to 24ml → 0.1 ml/hr = 0.1 mcg/kg/min')
      ..writeln('• Noradrenaline: ${(1.5 * w).toStringAsFixed(2)} ml (1mg/ml) + NS to 24ml → 0.1 ml/hr = 0.1 mcg/kg/min')
      ..writeln('• Milrinone: ${(1.5 * w).toStringAsFixed(2)} ml (1mg/ml) + NS to 50ml → 1 ml/hr = 0.5 mcg/kg/min')
      ..writeln('• Vasopressin: ${(1.5 * w / 20).toStringAsFixed(3)} ml (20u/ml) + NS to 10ml → 0.2 ml/hr = 0.0005 u/kg/min')
      ..writeln('')
      ..writeln('Sedation & Analgesia:')
      ..writeln('• Fentanyl: 2 ml (50mcg/ml) + 8 ml NS = 10ml → ${(0.1 * w).toStringAsFixed(2)} ml/hr = 1 mcg/kg/hr')
      ..writeln('• Morphine: per unit protocol (0.01–0.02 mg/kg/hr)')
      ..writeln('• Midazolam: ${(3 * w).toStringAsFixed(2)} ml (1mg/ml) + NS to 24ml → 1 ml/hr ≈ 0.125 mg/kg/hr')
      ..writeln('• Ketamine: 1 ml (50mg/ml) + 49 ml NS = 50ml → ${(0.5 * w).toStringAsFixed(2)} ml/hr = 0.5 mg/kg/hr')
      ..writeln('• Dexmedetomidine: 1 ml (100mcg/ml) + 9 ml NS = 10ml → ${(0.05 * w).toStringAsFixed(2)} ml/hr = 0.5 mcg/kg/hr')
      ..writeln('')
      ..writeln('Other:')
      ..writeln('• Furosemide: 1 ml (10mg/ml) + 9 ml NS = 10ml → ${(0.1 * w).toStringAsFixed(2)} ml/hr = 0.1 mg/kg/hr')
      ..writeln('• PGE1: 1 amp (500mcg) + 49 ml 5% Dextrose = 50ml → ${(0.6 * w).toStringAsFixed(2)} ml/hr = 0.1 mcg/kg/min')
      ..writeln('• Sildenafil load: ${(0.4 * w / 0.8).toStringAsFixed(2)} ml over 3 h; maint ${(1.6 * w / 24 / 0.8).toStringAsFixed(3)} ml/hr')
      ..writeln('')
      ..writeln('Always verify doses with a senior clinician or pharmacist before use.');
    Clipboard.setData(ClipboardData(text: buf.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preparation summary copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ── Syringe change helper ────────────────────────────────────────────────
  void _showSyringeChangeDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Syringe change',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'To match the current concentration in a different total volume:\n\n'
          '• Keep drug volume proportional to total volume.\n'
          '• If going from 24 ml → 50 ml at 1× concentration, scale drug volume by 50/24.\n'
          '• Keep rate in ml/hr the SAME — delivered dose stays identical.\n\n'
          'Tip: use the concentration multiplier chips above (½x / 2x / 3x / 4x) for common swap patterns.',
          style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  // ── GA-adjusted cautions ─────────────────────────────────────────────────
  void _showGaAdjustedDialog(BuildContext context) {
    final ctl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) {
          final ga = double.tryParse(ctl.text.trim());
          final flags = <String>[];
          if (ga != null) {
            if (ga < 28) {
              flags.add(
                'Dexmedetomidine — limited safety data in neonates <28 weeks.',
              );
              flags.add(
                'Morphine / Midazolam — associated with poorer neurodevelopmental outcomes in extreme preterm; use sparingly.',
              );
            }
            if (ga < 32) {
              flags.add(
                'Adrenaline / Noradrenaline — prefer central line; higher extravasation injury risk in extreme preterm.',
              );
            }
            if (ga < 34) {
              flags.add(
                'Sildenafil — PPHN data mostly in term / near-term. Limited preterm evidence.',
              );
            }
          }
          return AlertDialog(
            title: Text(
              'GA-adjusted cautions',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
            content: SizedBox(
              width: 320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: ctl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Gestation (weeks)',
                      hintText: 'e.g. 28',
                      suffixText: 'wks',
                    ),
                    onChanged: (_) => setSt(() {}),
                  ),
                  const SizedBox(height: 14),
                  if (flags.isEmpty)
                    Text(
                      ga == null
                          ? 'Enter GA to see drug-specific cautions.'
                          : 'No specific GA-related cautions flagged at ${ga.toStringAsFixed(1)} wks.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  else
                    ...flags.map((f) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 16,
                                color: Color(0xFFE65100),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  f,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close'),
              ),
            ],
          );
        },
      ),
    );
  }
}
