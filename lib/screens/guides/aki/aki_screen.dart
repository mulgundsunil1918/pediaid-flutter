// =============================================================================
// screens/guides/aki/aki_screen.dart
//
// AKI staging, reached from both the neonatal and the paediatric score hubs.
//
// One screen, two entry points. The hub that opened it sets the age band, and
// the age band decides the system — that is the whole shape of the flowchart:
// under 28 days there is exactly one answer, and beyond it KDIGO leads with
// pRIFLE offered alongside. Letting a neonatal entry point reach pRIFLE would
// be offering a system defined on creatinine clearance to a patient whose
// creatinine still reflects their mother's.
// =============================================================================

import 'package:flutter/material.dart';

import 'aki_classification.dart';

/// Which hub opened this.
enum AkiEntry { neonatal, paediatric }

class AkiScreen extends StatefulWidget {
  const AkiScreen({super.key, this.entry = AkiEntry.paediatric});

  final AkiEntry entry;

  @override
  State<AkiScreen> createState() => _AkiScreenState();
}

class _AkiScreenState extends State<AkiScreen> {
  late AkiEntry _entry = widget.entry;
  bool _prifle = false;
  bool _tableView = false;

  final _refCtl = TextEditingController();
  final _curCtl = TextEditingController();
  final _uoCtl = TextEditingController();
  bool _dialysis = false;
  bool _anuric = false;

  AkiSystem get _system => _entry == AkiEntry.neonatal
      ? AkiSystem.neonatalKdigo
      : (_prifle ? AkiSystem.prifle : AkiSystem.kdigo);

  @override
  void dispose() {
    _refCtl.dispose();
    _curCtl.dispose();
    _uoCtl.dispose();
    super.dispose();
  }

  double? _num(TextEditingController c) {
    final t = c.text.trim();
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  void _reset() {
    setState(() {
      _refCtl.clear();
      _curCtl.clear();
      _uoCtl.clear();
      _dialysis = false;
      _anuric = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final result = stageAki(
      system: _system,
      currentCreatinine: _num(_curCtl),
      referenceCreatinine: _num(_refCtl),
      urineOutput: _num(_uoCtl),
      onDialysis: _dialysis,
      anuric12h: _anuric,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('AKI Classification'),
        actions: [
          IconButton(
            tooltip: 'Reset',
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // ── Age band — the thing that decides the system ─────────────
          Text(
            'AGE BAND',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          SegmentedButton<AkiEntry>(
            segments: const [
              ButtonSegment(
                value: AkiEntry.neonatal,
                label: Text('Neonate', style: TextStyle(fontSize: 12.5)),
                icon: Icon(Icons.child_care, size: 16),
              ),
              ButtonSegment(
                value: AkiEntry.paediatric,
                label: Text('1 mo – 18 y', style: TextStyle(fontSize: 12.5)),
                icon: Icon(Icons.escalator_warning, size: 16),
              ),
            ],
            selected: {_entry},
            showSelectedIcon: false,
            onSelectionChanged: (v) => setState(() {
              _entry = v.first;
              if (_entry == AkiEntry.neonatal) _prifle = false;
            }),
          ),
          const SizedBox(height: 14),

          _SystemBanner(system: _system),

          // pRIFLE is a toggle, never a replacement, and never for a neonate.
          if (_entry == AkiEntry.paediatric) ...[
            const SizedBox(height: 10),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: _prifle,
              onChanged: (v) => setState(() => _prifle = v),
              title: const Text(
                'Use pRIFLE instead',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'KDIGO is the default. pRIFLE is classed on creatinine '
                'clearance, so it needs a height.',
                style: TextStyle(
                  fontSize: 11.5,
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Stage')),
              ButtonSegment(value: true, label: Text('Table')),
            ],
            selected: {_tableView},
            showSelectedIcon: false,
            onSelectionChanged: (v) => setState(() => _tableView = v.first),
          ),
          const SizedBox(height: 18),

          if (_tableView)
            _TableView(system: _system)
          else
            _StageView(
              result: result,
              refCtl: _refCtl,
              curCtl: _curCtl,
              uoCtl: _uoCtl,
              dialysis: _dialysis,
              anuric: _anuric,
              onChanged: () => setState(() {}),
              onDialysis: (v) => setState(() => _dialysis = v),
              onAnuric: (v) => setState(() => _anuric = v),
            ),

          const SizedBox(height: 28),
          Text(
            'REFERENCE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            kAkiReference,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.55,
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Says which system is in force and why, because the age band decides it and
/// a user who does not realise that will mistrust the answer.
class _SystemBanner extends StatelessWidget {
  const _SystemBanner({required this.system});
  final AkiSystem system;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star_rounded, size: 16, color: cs.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  system.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            system.ageBand,
            style: TextStyle(
              fontSize: 11.5,
              color: cs.onPrimaryContainer.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            system.referenceRule,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.45,
              color: cs.onPrimaryContainer.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _StageView extends StatelessWidget {
  const _StageView({
    required this.result,
    required this.refCtl,
    required this.curCtl,
    required this.uoCtl,
    required this.dialysis,
    required this.anuric,
    required this.onChanged,
    required this.onDialysis,
    required this.onAnuric,
  });

  final AkiResult result;
  final TextEditingController refCtl, curCtl, uoCtl;
  final bool dialysis, anuric;
  final VoidCallback onChanged;
  final ValueChanged<bool> onDialysis, onAnuric;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final neonatal = result.system.isNeonatal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _field(
          context,
          refCtl,
          neonatal ? 'Lowest previous creatinine' : 'Baseline creatinine',
          'mg/dL',
        ),
        const SizedBox(height: 12),
        _field(context, curCtl, 'Current creatinine', 'mg/dL'),
        const SizedBox(height: 12),
        _field(context, uoCtl, 'Urine output', 'mL/kg/h'),
        const SizedBox(height: 6),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          value: anuric,
          onChanged: (v) => onAnuric(v ?? false),
          title: const Text(
            'Anuric for 12 hours',
            style: TextStyle(fontSize: 13.5),
          ),
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          value: dialysis,
          onChanged: (v) => onDialysis(v ?? false),
          title: const Text(
            'Receiving dialysis / RRT',
            style: TextStyle(fontSize: 13.5),
          ),
        ),
        const SizedBox(height: 18),

        // ── Result ──────────────────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _tint(cs, result.stage),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.isStaged ? result.label!.toUpperCase() : 'NOT STAGED',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: cs.onSurface,
                ),
              ),
              if (result.isStaged) ...[
                const SizedBox(height: 6),
                Text(
                  'Higher of creatinine (${_axis(result.byCreatinine)}) and '
                  'urine output (${_axis(result.byUrineOutput)})',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
              if (result.reasons.isNotEmpty) ...[
                const SizedBox(height: 12),
                ...result.reasons.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(fontSize: 13, color: cs.onSurface),
                        ),
                        Expanded(
                          child: Text(
                            r,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: cs.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        if (result.notes.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...result.notes.map(
            (n) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 15,
                    color: cs.onSurface.withValues(alpha: 0.55),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      n,
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.45,
                        color: cs.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  static String _axis(int? v) => v == null ? 'not assessed' : 'stage $v';

  static Color _tint(ColorScheme cs, int? stage) => switch (stage) {
    null => cs.surfaceContainerHighest.withValues(alpha: 0.5),
    0 => cs.surfaceContainerHighest.withValues(alpha: 0.6),
    1 => cs.tertiaryContainer.withValues(alpha: 0.55),
    2 => cs.secondaryContainer.withValues(alpha: 0.6),
    _ => cs.errorContainer.withValues(alpha: 0.6),
  };

  Widget _field(
    BuildContext context,
    TextEditingController c,
    String label,
    String unit,
  ) {
    return TextField(
      controller: c,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        labelText: label,
        suffixText: unit,
        isDense: true,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _TableView extends StatelessWidget {
  const _TableView({required this.system});
  final AkiSystem system;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Stacked per stage rather than a wide grid: four columns of prose push
    // the last one off a 375 px screen, which is how the grade-2 column on
    // Silverman and Downes used to hide.
    return Column(
      children: tableFor(system).map((row) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: cs.primary.withValues(alpha: 0.5),
                width: 3,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                row.label.toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: cs.primary,
                ),
              ),
              const SizedBox(height: 10),
              _cell(cs, 'SERUM CREATININE', row.creatinine),
              const SizedBox(height: 8),
              _cell(cs, 'URINE OUTPUT', row.urineOutput),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _cell(ColorScheme cs, String head, String body) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        head,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.7,
          color: cs.onSurface.withValues(alpha: 0.5),
        ),
      ),
      const SizedBox(height: 3),
      Text(
        body,
        style: TextStyle(fontSize: 12.5, height: 1.45, color: cs.onSurface),
      ),
    ],
  );
}
