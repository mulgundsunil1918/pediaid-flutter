// =============================================================================
// calculators/simple_calc_scaffold.dart
//
// A shared scaffold for the many single-formula clinical calculators (ANC,
// Mentzer, QTc, FeNa, APRI, FIB-4, HbA1c→eAG, CSF correction, PELD/MELD, …).
// Each calculator is a thin config: a title, a list of numeric/toggle inputs,
// a pure compute() that returns a result + interpretation, and its formula +
// source notes. Inputs compute live; nothing is submitted.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../scores/adaptive_color.dart';

/// One numeric or toggle input.
class CalcField {
  final String key;
  final String label;
  final String unit;
  final String hint;
  final bool toggle; // renders a switch instead of a number field (value 0/1)

  /// Renders a date picker. The value handed to [compute] is DAYS SINCE EPOCH,
  /// so subtracting two date fields gives the interval in whole days directly —
  /// which is what every clinical use of a date pair here actually wants.
  final bool isDate;

  const CalcField(
    this.key,
    this.label, {
    this.unit = '',
    this.hint = '',
    this.toggle = false,
  }) : isDate = false;

  const CalcField.date(this.key, this.label, {this.hint = ''})
      : unit = '',
        toggle = false,
        isDate = true;
}

/// The computed answer. [value] is the headline (e.g. "1.8 %"); [band] +
/// [color] are the interpretation chip; [detail] is the explanatory line;
/// [extra] holds optional secondary rows (label → value).
class CalcResult {
  final String value;
  final String band;
  final Color color;
  final String detail;
  final List<(String, String)> extra;

  const CalcResult({
    required this.value,
    this.band = '',
    this.color = const Color(0xFF2E7D32),
    this.detail = '',
    this.extra = const [],
  });
}

class SimpleCalcScaffold extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color accent;
  final List<CalcField> fields;

  /// Returns null while inputs are incomplete/invalid; a CalcResult otherwise.
  final CalcResult? Function(Map<String, double> v) compute;

  /// Formula + source lines shown under the result.
  final List<String> notes;

  const SimpleCalcScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.fields,
    required this.compute,
    this.notes = const [],
  });

  @override
  State<SimpleCalcScaffold> createState() => _SimpleCalcScaffoldState();
}

class _SimpleCalcScaffoldState extends State<SimpleCalcScaffold> {
  final Map<String, TextEditingController> _ctrls = {};
  final Map<String, bool> _toggles = {};
  final Map<String, DateTime> _dates = {};

  @override
  void initState() {
    super.initState();
    for (final f in widget.fields) {
      if (f.toggle) {
        _toggles[f.key] = false;
      } else {
        _ctrls[f.key] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (final c in _ctrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  Map<String, double> get _values {
    final m = <String, double>{};
    for (final f in widget.fields) {
      if (f.isDate) {
        final d = _dates[f.key];
        if (d != null) {
          // Whole days since epoch, computed from a date-only value so a
          // pick made at 23:00 and one made at 01:00 are still one day apart.
          m[f.key] = DateTime(d.year, d.month, d.day)
                  .millisecondsSinceEpoch /
              86400000.0;
        }
      } else if (f.toggle) {
        m[f.key] = (_toggles[f.key] ?? false) ? 1 : 0;
      } else {
        final v = double.tryParse(_ctrls[f.key]!.text.trim());
        if (v != null) m[f.key] = v;
      }
    }
    return m;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final result = widget.compute(_values);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        backgroundColor: widget.accent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.subtitle,
                style: TextStyle(
                    fontSize: 13,
                    color: cs.onSurface.withValues(alpha: 0.6))),
            const SizedBox(height: 16),
            for (final f in widget.fields) ...[
              _field(f, cs),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 6),
            if (result != null) _resultCard(result, cs),
            if (widget.notes.isNotEmpty) ...[
              const SizedBox(height: 18),
              _notesCard(cs),
            ],
            const SizedBox(height: 12),
            Text(
              'For clinical decision support only — verify against your local protocol.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11, color: cs.onSurface.withValues(alpha: 0.45)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(CalcField f, ColorScheme cs) {
    if (f.isDate) {
      final picked = _dates[f.key];
      return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final now = DateTime.now();
          final d = await showDatePicker(
            context: context,
            initialDate: picked ?? now,
            // Wide enough for a birth date and any follow-up, narrow enough
            // that a mis-tap cannot land decades away.
            firstDate: DateTime(now.year - 20),
            lastDate: DateTime(now.year + 1),
          );
          if (d != null) setState(() => _dates[f.key] = d);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.accent.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 18, color: widget.accent),
              const SizedBox(width: 12),
              Expanded(
                child: Text(f.label,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ),
              Text(
                picked == null
                    ? (f.hint.isEmpty ? 'Select' : f.hint)
                    : '${picked.day.toString().padLeft(2, '0')}/'
                        '${picked.month.toString().padLeft(2, '0')}/'
                        '${picked.year}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: picked == null ? FontWeight.w400 : FontWeight.w700,
                  color: picked == null
                      ? cs.onSurface.withValues(alpha: 0.45)
                      : widget.accent,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (f.toggle) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: widget.accent.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Expanded(
                child: Text(f.label,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600))),
            Switch(
              value: _toggles[f.key] ?? false,
              activeThumbColor: widget.accent,
              onChanged: (v) => setState(() => _toggles[f.key] = v),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(f.label.toUpperCase(),
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: cs.onSurface.withValues(alpha: 0.55))),
        const SizedBox(height: 6),
        TextField(
          controller: _ctrls[f.key],
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true, signed: false),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            isDense: true,
            hintText: f.hint,
            suffixText: f.unit.isEmpty ? null : f.unit,
            filled: true,
            fillColor: Theme.of(context).cardColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.accent.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.accent.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.accent, width: 1.6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _resultCard(CalcResult r, ColorScheme cs) {
    // Result colours are authored light; lift them in dark mode so the headline
    // value and band chip stay legible.
    final rc = adaptInk(context, r.color);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: rc.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: rc.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wrap (not Row): on a narrow phone the band chip drops to its own
          // line instead of squeezing the headline value.
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              Text(r.value,
                  style: TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w800, color: rc)),
              if (r.band.isNotEmpty)
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 80),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: rc.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(r.band,
                        style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: rc)),
                  ),
                ),
            ],
          ),
          if (r.detail.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(r.detail,
                style: TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: cs.onSurface.withValues(alpha: 0.85))),
          ],
          if (r.extra.isNotEmpty) ...[
            const SizedBox(height: 12),
            for (final (k, v) in r.extra)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expanded: long labels ("NAC bag 1 (150 mg/kg / 1 h)")
                    // wrap instead of pushing the value off a phone screen.
                    Expanded(
                      child: Text(k,
                          style: TextStyle(
                              fontSize: 13,
                              color: cs.onSurface.withValues(alpha: 0.7))),
                    ),
                    const SizedBox(width: 12),
                    Text(v,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _notesCard(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final n in widget.notes)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(n,
                  style: TextStyle(
                      fontSize: 12.5,
                      height: 1.45,
                      color: cs.onSurface.withValues(alpha: 0.75))),
            ),
        ],
      ),
    );
  }
}
