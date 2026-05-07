// =============================================================================
// fluid_electrolyte_shared.dart
//
// Shared visual scaffolding for the 6 small fluid & electrolyte calculators
// (Anion Gap, Blood Volume, Serum Osmolality, Corrected Sodium, Urine Anion
// Gap, Corrected AG). Same look + feel as the GIR Calculator and the NICE
// Bilirubin screen so the family of fluid/electrolyte tools feels cohesive.
//
// Each calculator is its own screen file but composes these widgets:
//   - FECalcScaffold   — page chrome (AppBar, scroll, padding)
//   - FECalcInputCard  — labelled card for the inputs
//   - FECalcNumberField — single labelled decimal text field
//   - FECalcButton     — full-width "Calculate" primary button
//   - FECalcResultCard — big numeric result + units
//   - FECalcInsightCard — colour-coded interpretation band
//   - FECalcReferenceCard — small italic citation block
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FECalcScaffold extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const FECalcScaffold({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

class FECalcInputCard extends StatelessWidget {
  final String label;
  final Widget child;
  const FECalcInputCard({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.10)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(),
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.7),
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              )),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class FECalcNumberField extends StatelessWidget {
  final String label;
  final String? unit;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? hint;
  const FECalcNumberField({
    super.key,
    required this.label,
    required this.controller,
    this.unit,
    this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.65),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')),
          ],
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.3),
                fontWeight: FontWeight.normal,
                fontSize: 14),
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            suffixText: unit,
            suffixStyle: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.55),
                fontSize: 12.5,
                fontWeight: FontWeight.w600),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: cs.onSurface.withValues(alpha: 0.18)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: cs.onSurface.withValues(alpha: 0.18)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: cs.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class FECalcButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;
  const FECalcButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: Icon(icon),
        label: Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          disabledBackgroundColor: cs.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: cs.onSurface.withValues(alpha: 0.4),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class FECalcResultCard extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final String? formula;
  const FECalcResultCard({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.formula,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.08),
        border: Border.all(color: cs.primary.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(),
              style: TextStyle(
                color: cs.primary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              )),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value,
                  style: TextStyle(
                    color: cs.primary,
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 1.1,
                  )),
              if (unit != null) ...[
                const SizedBox(width: 6),
                Text(unit!,
                    style: TextStyle(
                      color: cs.primary.withValues(alpha: 0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ],
          ),
          if (formula != null) ...[
            const SizedBox(height: 8),
            Text(formula!,
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.6),
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                )),
          ],
        ],
      ),
    );
  }
}

enum FEInsightSeverity { good, warning, danger, info }

class FECalcInsightCard extends StatelessWidget {
  final String title;
  final String body;
  final FEInsightSeverity severity;
  const FECalcInsightCard({
    super.key,
    required this.title,
    required this.body,
    required this.severity,
  });

  ({Color bg, Color border, Color fg, IconData icon}) _palette(bool dark) {
    switch (severity) {
      case FEInsightSeverity.good:
        return (
          bg: dark ? const Color(0xFF1B5E20) : const Color(0xFFE8F5E9),
          border: const Color(0xFF66BB6A),
          fg: dark ? Colors.white : const Color(0xFF1B5E20),
          icon: Icons.check_circle_outline,
        );
      case FEInsightSeverity.warning:
        return (
          bg: dark ? const Color(0xFF4E3B00) : const Color(0xFFFFF8E1),
          border: const Color(0xFFFFB300),
          fg: dark ? const Color(0xFFFFD54F) : const Color(0xFF5D4037),
          icon: Icons.warning_amber_rounded,
        );
      case FEInsightSeverity.danger:
        return (
          bg: dark ? const Color(0xFF4E0000) : const Color(0xFFFFEBEE),
          border: const Color(0xFFEF5350),
          fg: dark ? const Color(0xFFEF9A9A) : const Color(0xFFB71C1C),
          icon: Icons.priority_high,
        );
      case FEInsightSeverity.info:
        return (
          bg: dark ? const Color(0xFF0D2A4D) : const Color(0xFFE3F2FD),
          border: const Color(0xFF2196F3),
          fg: dark ? const Color(0xFF90CAF9) : const Color(0xFF0D47A1),
          icon: Icons.info_outline,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final p = _palette(dark);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: p.bg,
        border: Border.all(color: p.border.withValues(alpha: 0.55)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(p.icon, color: p.fg, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    style: TextStyle(
                      color: p.fg,
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(body,
              style: TextStyle(
                color: p.fg,
                fontSize: 12.5,
                height: 1.5,
              )),
        ],
      ),
    );
  }
}

class FECalcReferenceCard extends StatelessWidget {
  final String text;
  const FECalcReferenceCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.04),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text,
          style: TextStyle(
            color: cs.onSurface.withValues(alpha: 0.55),
            fontSize: 11,
            fontStyle: FontStyle.italic,
            height: 1.55,
          )),
    );
  }
}

class FECalcGap extends StatelessWidget {
  final double height;
  const FECalcGap([this.height = 12]);
  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}
