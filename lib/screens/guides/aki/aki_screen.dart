// =============================================================================
// screens/guides/aki/aki_screen.dart
//
// AKI staging criteria, reached from both the neonatal and the paediatric
// score hubs.
//
// A reference table, not a calculator. Sunil's call, 26 Sep: nothing to enter
// and nothing computed — the criteria are what a clinician wants in front of
// them, and a staging engine sat between them and it. The engine and its tests
// were real and are in git at ba01ccb5 if this is ever wanted the other way.
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

  AkiSystem get _system => _entry == AkiEntry.neonatal
      ? AkiSystem.neonatalKdigo
      : (_prifle ? AkiSystem.prifle : AkiSystem.kdigo);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('AKI Classification')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
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
            const SizedBox(height: 4),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: _prifle,
              onChanged: (v) => setState(() => _prifle = v),
              title: const Text(
                'Show pRIFLE instead',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'KDIGO is the default. pRIFLE is classed on estimated '
                'creatinine clearance.',
                style: TextStyle(
                  fontSize: 11.5,
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],

          const SizedBox(height: 14),
          _StagingRule(),
          const SizedBox(height: 18),

          _TableView(system: _system),

          const SizedBox(height: 22),
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
/// a user who does not realise that will mistrust the table.
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

/// The rule that decides how the two columns combine.
///
/// Stated on screen rather than left to be inferred: it is the step most often
/// dropped, and a table alone does not say it.
class _StagingRule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: cs.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'Stage by whichever criterion — creatinine or urine output — '
              'gives the HIGHER stage. Neither column alone is the answer.',
              style: TextStyle(
                fontSize: 12,
                height: 1.45,
                color: cs.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
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
    // Stacked per stage rather than a wide grid: two columns of prose push the
    // second one off a 375 px screen, which is how the grade-2 column on
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
