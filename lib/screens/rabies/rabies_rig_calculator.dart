// =============================================================================
// screens/rabies/rabies_rig_calculator.dart
//
// The passive-immunisation calculator, usable on its own.
//
// Standalone on purpose: the commonest real use is a clinician who has already
// decided the child needs RIG and just wants the number. Making them walk a
// seven-step wizard to reach a multiplication would be the kind of tool people
// work around with a phone calculator — which is where dosing errors come from.
//
// It shows all four agents at once rather than making the user pick first. The
// choice is often made by what is in the fridge, and seeing HRIG beside ERIG
// beside both monoclonals makes the fifteen-fold potency gap between the two
// RMAbs visible instead of something to be remembered.
// =============================================================================

import 'package:flutter/material.dart';

import 'rabies_protocol.dart';
import 'rabies_rig.dart';
import 'rabies_widgets.dart';

class RabiesRigCalculator extends StatefulWidget {
  const RabiesRigCalculator({super.key});

  @override
  State<RabiesRigCalculator> createState() => _RabiesRigCalculatorState();
}

class _RabiesRigCalculatorState extends State<RabiesRigCalculator> {
  final _weightCtl = TextEditingController();
  final _concCtl = TextEditingController();
  double? _weight;
  double? _conc;
  PassiveAgent _agent = kHrig;

  @override
  void dispose() {
    _weightCtl.dispose();
    _concCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final selected =
        calculateRig(agent: _agent, weightKg: _weight, concentrationIuPerMl: _conc);
    final all = calculateAllRig(weightKg: _weight);

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
      children: [
        RabiesCard(
          title: 'RIG / RMAb dose',
          icon: Icons.calculate_outlined,
          accent: kCatIIIRed,
          subtitle: 'Weight-based. Children get the full weight-based dose.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _weightCtl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Weight',
                  suffixText: 'kg',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (v) =>
                    setState(() => _weight = double.tryParse(v.trim())),
              ),
              const SizedBox(height: 16),
              Text('Agent',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface.withValues(alpha: 0.85))),
              const SizedBox(height: 8),
              for (final a in kPassiveAgents)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: SelectChip(
                      label: '${a.label}  ·  ${a.iuPerKg} IU/kg',
                      accent: kCatIIIRed,
                      selected: _agent.kind == a.kind,
                      onTap: () => setState(() {
                        _agent = a;
                        // Clearing the override rather than keeping it: the
                        // previous product's concentration applied to a new
                        // agent is the single most dangerous stale value this
                        // screen could hold.
                        _conc = null;
                        _concCtl.clear();
                      }),
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              TextField(
                controller: _concCtl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Product concentration (optional)',
                  suffixText: 'IU/mL',
                  border: const OutlineInputBorder(),
                  isDense: true,
                  helperMaxLines: 3,
                  helperText: _agent.concentrationIuPerMl == null
                      ? 'Not printed in the guideline for this agent — enter '
                          'the value from the vial to get a volume.'
                      : 'Guideline prints '
                          '${_agent.concentrationIuPerMl!.toStringAsFixed(0)} '
                          'IU/mL. Override if your vial differs.',
                ),
                onChanged: (v) =>
                    setState(() => _conc = double.tryParse(v.trim())),
              ),
            ],
          ),
        ),
        _resultCard(cs, selected),
        _allAgentsCard(cs, all),
        RabiesCard(
          title: 'Where it goes',
          icon: Icons.my_location_outlined,
          accent: kCatIIIRed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(11),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: kCatIIIRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: kCatIIIRed.withValues(alpha: 0.5)),
                ),
                child: const Text(
                  'RIG/RMAb IS FOR LOCAL WOUND INFILTRATION — NOT ROUTINE IM '
                  'INJECTION AT A DISTANT SITE.',
                  style: TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      fontWeight: FontWeight.w900,
                      color: kCatIIIRed),
                ),
              ),
              for (final s in kRigAdministrationSteps) SourcedLine(s),
            ],
          ),
        ),
        const RabiesDisclaimer(),
      ],
    );
  }

  Widget _resultCard(ColorScheme cs, RigDose d) {
    final ok = d.isComplete;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (ok ? kCatIIIRed : cs.outline).withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: (ok ? kCatIIIRed : cs.outline).withValues(alpha: 0.5),
            width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(d.agent.label,
              style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface.withValues(alpha: 0.75))),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DOSE',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            color: cs.onSurface.withValues(alpha: 0.5))),
                    const SizedBox(height: 3),
                    Text(d.iuLabel,
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                            color: ok
                                ? kCatIIIRed
                                : cs.onSurface.withValues(alpha: 0.35))),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('VOLUME',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            color: cs.onSurface.withValues(alpha: 0.5))),
                    const SizedBox(height: 3),
                    Text(d.volumeLabel,
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                            color: d.volumeMl != null
                                ? kCatIIIRed
                                : cs.onSurface.withValues(alpha: 0.35))),
                  ],
                ),
              ),
            ],
          ),
          if (d.weightKg != null) ...[
            const SizedBox(height: 8),
            Text(
              '${d.agent.iuPerKg} IU/kg × ${_trim(d.weightKg!)} kg'
              '${d.concentrationIuPerMl != null ? '  ÷  ${_trim(d.concentrationIuPerMl!)} IU/mL' : ''}',
              style: TextStyle(
                  fontSize: 12,
                  fontFeatures: const [],
                  color: cs.onSurface.withValues(alpha: 0.7)),
            ),
          ],
          if (d.missing.isNotEmpty) ...[
            const SizedBox(height: 10),
            for (final m in d.missing)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, size: 15, color: kCatIIAmber),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text('Needed: $m',
                          style: const TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              fontWeight: FontWeight.w600,
                              color: kCatIIAmber)),
                    ),
                  ],
                ),
              ),
          ],
          if (d.agent.skinTest != null) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                    d.agent.skinTest!.startsWith('No')
                        ? Icons.check_circle_outline
                        : Icons.warning_amber_rounded,
                    size: 15,
                    color: d.agent.skinTest!.startsWith('No')
                        ? kOkGreen
                        : kCatIIAmber),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(d.agent.skinTest!,
                      style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: cs.onSurface.withValues(alpha: 0.8))),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _allAgentsCard(ColorScheme cs, List<RigDose> all) => RabiesCard(
        title: 'All agents at this weight',
        icon: Icons.compare_arrows,
        subtitle: 'Choice is often decided by what is available',
        child: ScrollableTable(
          child: DataTable(
            columnSpacing: 20,
            headingRowHeight: 38,
            dataRowMinHeight: 40,
            dataRowMaxHeight: 56,
            columns: const [
              DataColumn(label: Text('Agent', style: _th)),
              DataColumn(label: Text('IU/kg', style: _th)),
              DataColumn(label: Text('Dose', style: _th)),
              DataColumn(label: Text('Volume', style: _th)),
            ],
            rows: [
              for (final d in all)
                DataRow(cells: [
                  DataCell(SizedBox(
                      width: 130, child: Text(d.agent.label, style: _td))),
                  DataCell(Text('${d.agent.iuPerKg}', style: _td)),
                  DataCell(Text(d.iuLabel, style: _tdBold)),
                  DataCell(Text(d.volumeLabel, style: _td)),
                ]),
            ],
          ),
        ),
      );

  String _trim(double v) {
    final s = v.toStringAsFixed(2);
    return s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }
}

const _th = TextStyle(fontSize: 12, fontWeight: FontWeight.w800);
const _td = TextStyle(fontSize: 12, height: 1.3);
const _tdBold = TextStyle(fontSize: 12.5, height: 1.3, fontWeight: FontWeight.w900);
