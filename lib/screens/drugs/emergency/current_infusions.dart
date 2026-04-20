// ============================================================
//  current_infusions.dart
//  Running Continuous Infusions tracker — Emergency NICU Drugs
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

/// One running drug infusion — name, rate (ml/hr), concentration at prep time.
class RunningInfusion {
  final String drugName;
  final double rateMlPerHr;
  final double preparedConcentration; // mcg/ml for most, mg/ml for Fur/Ket/Mid, units/ml for Vasopressin
  final String doseUnit; // 'mcg/kg/min' | 'mcg/kg/hr' | 'mg/kg/hr' | 'units/kg/min'

  const RunningInfusion({
    required this.drugName,
    required this.rateMlPerHr,
    required this.preparedConcentration,
    required this.doseUnit,
  });
}

// ── Store ─────────────────────────────────────────────────────────────────────

/// In-memory store with ChangeNotifier. Keeps the list, provides add/remove.
class InfusionStore extends ChangeNotifier {
  static final InfusionStore instance = InfusionStore._();
  InfusionStore._();

  final List<RunningInfusion> _items = [];

  List<RunningInfusion> get items => List.unmodifiable(_items);

  void add(RunningInfusion inf) {
    _items.add(inf);
    notifyListeners();
  }

  void removeAt(int i) {
    if (i >= 0 && i < _items.length) {
      _items.removeAt(i);
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// ── Drug Catalogue ────────────────────────────────────────────────────────────

const List<String> _kDrugNames = [
  'Dopamine',
  'Dobutamine',
  'Adrenaline',
  'Noradrenaline',
  'Milrinone',
  'Fentanyl',
  'Vasopressin',
  'PGE1',
  'Midazolam',
  'Furosemide',
  'Ketamine',
  'Dexmedetomidine',
  'Sildenafil',
];

/// Dose unit per drug.
String _doseUnitForDrug(String drugName) {
  switch (drugName) {
    case 'Dopamine':
    case 'Dobutamine':
    case 'Adrenaline':
    case 'Noradrenaline':
    case 'Milrinone':
    case 'PGE1':
      return 'mcg/kg/min';
    case 'Fentanyl':
    case 'Dexmedetomidine':
      return 'mcg/kg/hr';
    case 'Vasopressin':
      return 'units/kg/min';
    case 'Midazolam':
    case 'Furosemide':
    case 'Ketamine':
    case 'Sildenafil':
      return 'mg/kg/hr';
    default:
      return 'mcg/kg/min';
  }
}

/// Compute prepared concentration from weight + standard dilution rule.
double computeConcentrationForDrug(String drugName, double weightKg) {
  switch (drugName) {
    case 'Dopamine':
      return 15 * weightKg * 1000 / 24; // mcg/ml
    case 'Dobutamine':
      return 15 * weightKg * 1000 / 24; // mcg/ml
    case 'Adrenaline':
      return 1.5 * weightKg * 1000 / 24; // mcg/ml
    case 'Noradrenaline':
      return 1.5 * weightKg * 1000 / 24; // mcg/ml
    case 'Milrinone':
      return 1.5 * weightKg * 1000 / 50; // mcg/ml
    case 'Fentanyl':
      return 10; // mcg/ml fixed
    case 'Vasopressin':
      return 1.5 * weightKg / 10; // units/ml
    case 'PGE1':
      return 10; // mcg/ml fixed
    case 'Midazolam':
      return 3 * weightKg / 24; // mg/ml
    case 'Furosemide':
      return 1; // mg/ml fixed
    case 'Ketamine':
      return 1; // mg/ml fixed
    case 'Dexmedetomidine':
      return 10; // mcg/ml fixed
    case 'Sildenafil':
      return 0.8; // mg/ml (undiluted)
    default:
      return 0;
  }
}

/// Returns true if the drug's concentration scales with weight (weight-based dilution).
bool _isWeightBasedDrug(String drugName) {
  const weightBased = {
    'Dopamine',
    'Dobutamine',
    'Adrenaline',
    'Noradrenaline',
    'Milrinone',
    'Vasopressin',
    'Midazolam',
  };
  return weightBased.contains(drugName);
}

// ── Dose computation ──────────────────────────────────────────────────────────

double _computeDose({
  required double rateMlPerHr,
  required double conc,
  required double weightKg,
  required String doseUnit,
}) {
  if (weightKg <= 0) return 0;
  switch (doseUnit) {
    case 'mcg/kg/min':
      return rateMlPerHr * conc / weightKg / 60;
    case 'mcg/kg/hr':
      return rateMlPerHr * conc / weightKg;
    case 'mg/kg/hr':
      return rateMlPerHr * conc / weightKg;
    case 'units/kg/min':
      return rateMlPerHr * conc / weightKg / 60;
    default:
      return rateMlPerHr * conc / weightKg / 60;
  }
}

// ── Public entry point ────────────────────────────────────────────────────────

/// Full-height draggable sheet for tracking running infusions.
Future<void> openCurrentInfusionsSheet(
  BuildContext context, {
  required double? weightKg,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _InfusionsSheet(weightKg: weightKg),
  );
}

// ── Sheet widget ──────────────────────────────────────────────────────────────

class _InfusionsSheet extends StatelessWidget {
  final double? weightKg;
  const _InfusionsSheet({required this.weightKg});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return _InfusionsSheetBody(
          weightKg: weightKg,
          scrollController: scrollController,
        );
      },
    );
  }
}

class _InfusionsSheetBody extends StatelessWidget {
  final double? weightKg;
  final ScrollController scrollController;

  const _InfusionsSheetBody({
    required this.weightKg,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // ── Drag handle ───────────────────────────────────────────────────
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // ── Header ────────────────────────────────────────────────────────
          _SheetHeader(weightKg: weightKg),
          const Divider(height: 1),
          // ── Body ──────────────────────────────────────────────────────────
          Expanded(
            child: ListenableBuilder(
              listenable: InfusionStore.instance,
              builder: (context, _) {
                final items = InfusionStore.instance.items;
                return CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    // ── Add button ─────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: OutlinedButton.icon(
                          onPressed: weightKg != null
                              ? () => _showAddDialog(context, weightKg!)
                              : null,
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(
                            '+ Add Infusion',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(44),
                          ),
                        ),
                      ),
                    ),
                    // ── Empty state ────────────────────────────────────────
                    if (items.isEmpty)
                      SliverFillRemaining(
                        child: _EmptyState(),
                      )
                    else ...[
                      // ── Infusion cards ─────────────────────────────────
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (ctx, i) => _InfusionCard(
                              infusion: items[i],
                              index: i,
                              weightKg: weightKg,
                            ),
                            childCount: items.length,
                          ),
                        ),
                      ),
                      // ── Totals card ────────────────────────────────────
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          child: _TotalsCard(
                            items: items,
                            weightKg: weightKg,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, double weightKg) {
    showDialog<void>(
      context: context,
      builder: (_) => _AddInfusionDialog(weightKg: weightKg),
    );
  }
}

// ── Sheet header ──────────────────────────────────────────────────────────────

class _SheetHeader extends StatelessWidget {
  final double? weightKg;
  const _SheetHeader({required this.weightKg});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Accent bar
          Container(
            width: 4,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFB71C1C),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Running Infusions',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  weightKg != null
                      ? 'Weight: ${weightKg!.toStringAsFixed(2)} kg'
                      : 'Enter weight in main screen first',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Close button
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.water_drop_outlined,
            size: 56,
            color: cs.onSurface.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 16),
          Text(
            'No infusions running',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withValues(alpha: 0.45),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap + to add one',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: cs.onSurface.withValues(alpha: 0.35),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Infusion card ─────────────────────────────────────────────────────────────

class _InfusionCard extends StatelessWidget {
  final RunningInfusion infusion;
  final int index;
  final double? weightKg;

  const _InfusionCard({
    required this.infusion,
    required this.index,
    required this.weightKg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    String doseText;
    String fluidText;

    if (weightKg != null && weightKg! > 0) {
      final dose = _computeDose(
        rateMlPerHr: infusion.rateMlPerHr,
        conc: infusion.preparedConcentration,
        weightKg: weightKg!,
        doseUnit: infusion.doseUnit,
      );
      final fluidMlPerKgDay = infusion.rateMlPerHr * 24 / weightKg!;
      doseText =
          '${_fmt(dose)} ${infusion.doseUnit}';
      fluidText = '${_fmt(fluidMlPerKgDay)} ml/kg/day';
    } else {
      doseText = 'Enter weight';
      fluidText = '—';
    }

    return Dismissible(
      key: ValueKey('infusion_${index}_${infusion.drugName}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.red.shade700,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => InfusionStore.instance.removeAt(index),
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        color: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: cs.onSurface.withValues(alpha: 0.1),
          ),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      infusion.drugName.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB71C1C),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Running at ${_fmt(infusion.rateMlPerHr)} ml/hr',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: cs.onSurface.withValues(alpha: 0.75),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Delivering: $doseText',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Fluid: $fluidText',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 18,
                  color: cs.onSurface.withValues(alpha: 0.45),
                ),
                onPressed: () => InfusionStore.instance.removeAt(index),
                tooltip: 'Remove',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Totals card ───────────────────────────────────────────────────────────────

class _TotalsCard extends StatelessWidget {
  final List<RunningInfusion> items;
  final double? weightKg;

  const _TotalsCard({required this.items, required this.weightKg});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final totalMlPerHr = items.fold<double>(0, (s, e) => s + e.rateMlPerHr);
    final totalMlPerKgDay =
        (weightKg != null && weightKg! > 0) ? totalMlPerHr * 24 / weightKg! : 0.0;

    // Banner colour
    Color? bannerColor;
    String? bannerText;
    if (totalMlPerKgDay > 60) {
      bannerColor = Colors.red.shade700;
      bannerText =
          'Very high fluid load from infusions — consider concentrated preparations';
    } else if (totalMlPerKgDay > 30) {
      bannerColor = Colors.amber.shade700;
      bannerText =
          'High infusion fluid load — check total daily fluid allowance';
    }

    // Savings tips
    final List<_SavingsTip> tips = [];
    if (weightKg != null && weightKg! > 0 && totalMlPerKgDay > 20) {
      for (final inf in items) {
        if (_isWeightBasedDrug(inf.drugName)) {
          final savedMlPerDay = (inf.rateMlPerHr * 24) / 2;
          tips.add(_SavingsTip(
            drugName: inf.drugName,
            savedMlPerDay: savedMlPerDay,
          ));
        }
      }
    }

    return Card(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.onSurface.withValues(alpha: 0.1)),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total infusion fluid',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${_fmt(totalMlPerHr)} ml/hr',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            if (weightKg != null && weightKg! > 0) ...[
              const SizedBox(height: 2),
              Text(
                '= ${_fmt(totalMlPerKgDay)} ml/kg/day from infusions',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
            if (bannerColor != null && bannerText != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: bannerColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: bannerColor.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      totalMlPerKgDay > 60
                          ? Icons.warning_rounded
                          : Icons.info_outline_rounded,
                      color: bannerColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        bannerText,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: bannerColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Note: add feeds, TPN, flushes for total fluid balance',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: cs.onSurface.withValues(alpha: 0.45),
                fontStyle: FontStyle.italic,
              ),
            ),
            // Savings tips
            for (final tip in tips) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.blue.shade200.withValues(alpha: 0.6),
                  ),
                ),
                child: Text(
                  '\u{1F4A1} Tip: switching ${tip.drugName} to 2\u00D7 concentration '
                  'would save ${_fmt(tip.savedMlPerDay)} ml/day\n'
                  '(halves the infusion rate while delivering the same dose)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SavingsTip {
  final String drugName;
  final double savedMlPerDay;
  const _SavingsTip({required this.drugName, required this.savedMlPerDay});
}

// ── Add infusion dialog ───────────────────────────────────────────────────────

class _AddInfusionDialog extends StatefulWidget {
  final double weightKg;
  const _AddInfusionDialog({required this.weightKg});

  @override
  State<_AddInfusionDialog> createState() => _AddInfusionDialogState();
}

class _AddInfusionDialogState extends State<_AddInfusionDialog> {
  String _selectedDrug = _kDrugNames.first;
  final TextEditingController _rateCtrl = TextEditingController();
  bool _rateValid = false;

  @override
  void initState() {
    super.initState();
    _rateCtrl.addListener(_onRateChanged);
  }

  void _onRateChanged() {
    final v = double.tryParse(_rateCtrl.text.trim());
    final valid = v != null && v > 0;
    if (valid != _rateValid) {
      setState(() => _rateValid = valid);
    }
  }

  @override
  void dispose() {
    _rateCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final rate = double.tryParse(_rateCtrl.text.trim());
    if (rate == null || rate <= 0) return;

    final conc =
        computeConcentrationForDrug(_selectedDrug, widget.weightKg);
    final unit = _doseUnitForDrug(_selectedDrug);

    InfusionStore.instance.add(RunningInfusion(
      drugName: _selectedDrug,
      rateMlPerHr: rate,
      preparedConcentration: conc,
      doseUnit: unit,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final conc = computeConcentrationForDrug(_selectedDrug, widget.weightKg);
    final unit = _doseUnitForDrug(_selectedDrug);

    return AlertDialog(
      title: Text(
        'Add Infusion',
        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drug dropdown
            Text(
              'Drug',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedDrug,
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: cs.onSurface,
              ),
              items: _kDrugNames
                  .map((d) => DropdownMenuItem(
                        value: d,
                        child: Text(d),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedDrug = v);
              },
            ),
            const SizedBox(height: 14),
            // Rate field
            Text(
              'Current rate (ml/hr)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _rateCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: '0.0',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                suffixText: 'ml/hr',
              ),
              style: GoogleFonts.plusJakartaSans(fontSize: 14),
            ),
            const SizedBox(height: 14),
            // Computed concentration info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Standard prep: ${_fmt(conc)} ${_concUnitLabel(unit)}\n'
                '(weight: ${widget.weightKg.toStringAsFixed(2)} kg)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: cs.onSurface.withValues(alpha: 0.65),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: GoogleFonts.plusJakartaSans(),
          ),
        ),
        FilledButton(
          onPressed: _rateValid ? _submit : null,
          child: Text(
            'Add',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

String _fmt(double v) {
  if (v == v.truncateToDouble()) {
    return v.toStringAsFixed(0);
  }
  // Up to 3 significant figures after decimal, trimming trailing zeros
  String s = v.toStringAsFixed(3);
  s = s.replaceAll(RegExp(r'0+$'), '');
  s = s.replaceAll(RegExp(r'\.$'), '');
  return s;
}

String _concUnitLabel(String doseUnit) {
  switch (doseUnit) {
    case 'mcg/kg/min':
    case 'mcg/kg/hr':
      return 'mcg/ml';
    case 'mg/kg/hr':
      return 'mg/ml';
    case 'units/kg/min':
      return 'units/ml';
    default:
      return 'mcg/ml';
  }
}
