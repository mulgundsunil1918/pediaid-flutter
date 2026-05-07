import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ---------------------------------------------------------------------------
// Public entry point
// ---------------------------------------------------------------------------

/// Opens the full-height resus drugs sheet.
/// If [weightKg] is null the sheet shows its own TextField at the top.
Future<void> openResuscitationSheet(
  BuildContext context, {
  double? weightKg,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ResuscitationSheet(initialWeight: weightKg),
  );
}

// ---------------------------------------------------------------------------
// Main sheet widget
// ---------------------------------------------------------------------------

class _ResuscitationSheet extends StatefulWidget {
  const _ResuscitationSheet({this.initialWeight});
  final double? initialWeight;

  @override
  State<_ResuscitationSheet> createState() => _ResuscitationSheetState();
}

class _ResuscitationSheetState extends State<_ResuscitationSheet> {
  final TextEditingController _weightCtrl = TextEditingController();
  double? _weight;

  @override
  void initState() {
    super.initState();
    _weight = widget.initialWeight;
    if (_weight != null) {
      _weightCtrl.text = _weight.toString();
    }
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    super.dispose();
  }

  void _onWeightChanged(String val) {
    setState(() {
      _weight = double.tryParse(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _ResuscitationBody(
                  weight: _weight,
                  showWeightField: widget.initialWeight == null,
                  weightController: _weightCtrl,
                  onWeightChanged: _onWeightChanged,
                  scrollController: scrollController,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final double? w = _weight;
    final String subtitle = w != null
        ? 'Weight: ${w.toStringAsFixed(2)} kg'
        : 'Weight: — kg — enter weight above if not done';

    return Container(
      color: const Color(0xFFB71C1C),
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resuscitation Drugs',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Scrollable body
// ---------------------------------------------------------------------------

class _ResuscitationBody extends StatelessWidget {
  const _ResuscitationBody({
    required this.weight,
    required this.showWeightField,
    required this.weightController,
    required this.onWeightChanged,
    required this.scrollController,
  });

  final double? weight;
  final bool showWeightField;
  final TextEditingController weightController;
  final ValueChanged<String> onWeightChanged;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [];

    // Optional inline weight field
    if (showWeightField) {
      items.add(_WeightField(
        controller: weightController,
        onChanged: onWeightChanged,
      ));
    }

    // 12 drug cards
    items.addAll([
      _AdrenalineCard(weight: weight),
      _SodiumBicarbonateCard(weight: weight),
      _AdenosineCard(weight: weight),
      _CalciumGluconateCard(weight: weight),
      _GlucoseBolus(weight: weight),
      _AtropineCard(weight: weight),
      _PhenobarbitoneCard(weight: weight),
      _PhenytoinCard(weight: weight),
      _VitaminKCard(weight: weight),
      _NormalSalineCard(weight: weight),
      _FfpCard(weight: weight),
      _PrbcCard(weight: weight),
    ]);

    // Footer
    items.add(_FooterBanner());
    items.add(const SizedBox(height: 16));

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        separatorBuilder: (context2, index) => const SizedBox(height: 10),
        itemBuilder: (_, i) => items[i],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Inline weight field
// ---------------------------------------------------------------------------

class _WeightField extends StatelessWidget {
  const _WeightField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: onChanged,
        style: GoogleFonts.plusJakartaSans(fontSize: 14),
        decoration: InputDecoration(
          labelText: "Baby's Weight (kg)",
          labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13),
          suffixText: 'kg',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Category chip colour helper
// ---------------------------------------------------------------------------

Color _categoryColor(String category) {
  switch (category) {
    case 'EMERGENCY':
      return const Color(0xFFC62828);
    case 'ARRHYTHMIA':
      return const Color(0xFFE65100);
    case 'ANTICONVULSANT':
      return const Color(0xFF6A1B9A);
    case 'ROUTINE':
      return const Color(0xFF1565C0);
    case 'VOLUME':
      return const Color(0xFF00838F);
    case 'BLOOD PRODUCT':
      return const Color(0xFFAD1457);
    default:
      return Colors.grey;
  }
}

// ---------------------------------------------------------------------------
// Base drug card helper
// ---------------------------------------------------------------------------

class _DrugCard extends StatelessWidget {
  const _DrugCard({
    required this.name,
    required this.category,
    required this.accentColor,
    required this.children,
  });

  final String name;
  final String category;
  final Color accentColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final chipColor = _categoryColor(category);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cs.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left accent bar
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: name + category chip
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: chipColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: chipColor.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            category,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: chipColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...children,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared text helpers
// ---------------------------------------------------------------------------

Widget _doseLabel(String text) => _labelText(text, const Color(0xFF1565C0));
Widget _volLabel(String text) => _labelText(text, const Color(0xFF2E7D32));

Widget _labelText(String text, Color color) {
  return Text(
    text,
    style: GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}

Widget _greyText(String text, {bool italic = false}) {
  return Text(
    text,
    style: GoogleFonts.plusJakartaSans(
      fontSize: 12,
      color: Colors.grey[600],
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
    ),
  );
}

Widget _noteCard(String text, {required bool isRed}) {
  final bg = isRed
      ? const Color(0xFFFFEBEE)
      : const Color(0xFFFFF8E1);
  final border = isRed
      ? const Color(0xFFEF9A9A)
      : const Color(0xFFFFCC80);
  final textColor = isRed
      ? const Color(0xFFB71C1C)
      : const Color(0xFFE65100);
  final icon = isRed ? Icons.warning_amber_rounded : Icons.info_outline;

  return Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: border),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: textColor),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: textColor,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _formulaText(String text) {
  return Text(
    text,
    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[700]),
  );
}

const SizedBox _gap4 = SizedBox(height: 4);

// ---------------------------------------------------------------------------
// Drug 1 — Adrenaline
// ---------------------------------------------------------------------------

class _AdrenalineCard extends StatelessWidget {
  const _AdrenalineCard({required this.weight});
  final double? weight;

  @override
  Widget build(BuildContext context) {
    final w = weight;
    return _DrugCard(
      name: 'Adrenaline (Cardiac Arrest)',
      category: 'EMERGENCY',
      accentColor: const Color(0xFFC62828),
      children: [
        _formulaText('Dose: 0.01–0.03 mg/kg IV'),
        _formulaText('Prep: Use 1:10,000 solution (0.1 mg/ml)'),
        _gap4,
        if (w != null) ...[
          _doseLabel(
              'Dose: ${(0.01 * w).toStringAsFixed(2)} mg – ${(0.03 * w).toStringAsFixed(2)} mg'),
          _volLabel(
              '${(0.1 * w).toStringAsFixed(2)} ml to ${(0.3 * w).toStringAsFixed(2)} ml of 1:10,000 adrenaline'),
        ] else
          _formulaText('0.1–0.3 ml/kg of 1:10,000 adrenaline'),
        _gap4,
        _greyText('Route: IV or IO, rapid bolus', italic: true),
        _greyText('Repeat every 3–5 minutes', italic: true),
        _noteCard(
          'May dilute to 1 ml with NS for easier administration in very small babies.',
          isRed: false,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Drug 2 — Sodium Bicarbonate
// ---------------------------------------------------------------------------

class _SodiumBicarbonateCard extends StatelessWidget {
  const _SodiumBicarbonateCard({required this.weight});
  final double? weight;

  @override
  Widget build(BuildContext context) {
    final w = weight;
    return _DrugCard(
      name: 'Sodium Bicarbonate',
      category: 'EMERGENCY',
      accentColor: const Color(0xFFC62828),
      children: [
        _formulaText('Dose: 1–2 mEq/kg IV'),
        _formulaText('Prep: Use 4.2% solution (0.5 mEq/ml)'),
        _gap4,
        if (w != null) ...[
          _doseLabel(
              'Dose: ${(1 * w).toStringAsFixed(2)} mEq – ${(2 * w).toStringAsFixed(2)} mEq'),
          _volLabel(
              '${(2 * w).toStringAsFixed(2)} ml to ${(4 * w).toStringAsFixed(2)} ml of 4.2% NaHCO₃'),
        ] else
          _formulaText('2–4 ml/kg of 4.2% NaHCO₃'),
        _gap4,
        _greyText('Route: IV slow push over 2–3 minutes', italic: true),
        _noteCard(
          'Only use when adequate ventilation is established. Do NOT mix with adrenaline or calcium.',
          isRed: false,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Drug 3 — Adenosine
// ---------------------------------------------------------------------------

class _AdenosineCard extends StatelessWidget {
  const _AdenosineCard({required this.weight});
  final double? weight;

  @override
  Widget build(BuildContext context) {
    final w = weight;
    return _DrugCard(
      name: 'Adenosine (SVT)',
      category: 'ARRHYTHMIA',
      accentColor: const Color(0xFFE65100),
      children: [
        _formulaText('Dose: 0.1 → 0.2 → 0.3 mg/kg (sequential if needed)'),
        _formulaText(
            'Prep: Undiluted 3 mg/ml — dilute 1:1 with NS for small babies → 1.5 mg/ml'),
        _gap4,
        if (w != null) ...[
          _doseLabel('1st dose: ${(0.1 * w).toStringAsFixed(2)} mg'),
          _volLabel('= ${(0.1 * w / 3).toStringAsFixed(2)} ml of 3 mg/ml'),
          _gap4,
          _doseLabel('2nd dose: ${(0.2 * w).toStringAsFixed(2)} mg'),
          _volLabel('= ${(0.2 * w / 3).toStringAsFixed(2)} ml of 3 mg/ml'),
          _gap4,
          _doseLabel('3rd dose: ${(0.3 * w).toStringAsFixed(2)} mg'),
          _volLabel('= ${(0.3 * w / 3).toStringAsFixed(2)} ml of 3 mg/ml'),
        ] else
          _formulaText(
              '0.1/0.2/0.3 mg/kg → 0.033/0.067/0.1 ml/kg of 3 mg/ml'),
        _gap4,
        _greyText(
            'Route: Rapid IV push into largest vein, followed IMMEDIATELY by 2–3 ml NS flush',
            italic: true),
        _noteCard(
          'Must be given as fast bolus followed by rapid flush. Half-life 10 seconds.',
          isRed: false,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Drug 4 — Calcium Gluconate
// ---------------------------------------------------------------------------

class _CalciumGluconateCard extends StatelessWidget {
  const _CalciumGluconateCard({required this.weight});
  final double? weight;

  @override
  Widget build(BuildContext context) {
    final w = weight;
    return _DrugCard(
      name: 'Calcium Gluconate',
      category: 'EMERGENCY',
      accentColor: const Color(0xFFC62828),
      children: [
        _formulaText('Dose: 1–2 ml/kg of 10% solution IV'),
        _formulaText('Prep: 10% calcium gluconate (0.22 mEq/ml)'),
        _gap4,
        if (w != null)
          _volLabel(
              '${(1 * w).toStringAsFixed(2)} ml to ${(2 * w).toStringAsFixed(2)} ml of 10% calcium gluconate')
        else
          _formulaText('1–2 ml/kg of 10% calcium gluconate'),
        _gap4,
        _greyText(
            'Route: Slow IV push over 5–10 minutes. Must be through confirmed IV — tissue necrosis if extravasates',
            italic: true),
        _noteCard(
          'Do NOT mix with sodium bicarbonate (precipitates). Monitor HR during administration — slow if bradycardia.',
          isRed: true,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Drug 5 — Glucose Bolus
// ---------------------------------------------------------------------------

class _GlucoseBolus extends StatelessWidget {
  const _GlucoseBolus({required this.weight});
  final double? weight;

  @override
  Widget build(BuildContext context) {
    final w = weight;
    return _DrugCard(
      name: 'Glucose Bolus (Hypoglycaemia)',
      category: 'EMERGENCY',
      accentColor: const Color(0xFFC62828),
      children: [
        _formulaText('Dose: 2 ml/kg of 10% dextrose IV'),
        _gap4,
        if (w != null) ...[
          _volLabel('${(2 * w).toStringAsFixed(2)} ml of 10% dextrose'),
          _gap4,
          _doseLabel('Alternative (fluid restricted):'),
          _volLabel(
              '${(1 * w).toStringAsFixed(2)} ml of 25% dextrose (if fluid restricted)'),
        ] else
          _formulaText('2 ml/kg of 10% dextrose (or 1 ml/kg of 25% dextrose)'),
        _gap4,
        _greyText('Route: IV over 2–3 minutes', italic: true),
        _noteCard(
          'Follow with glucose infusion at 6–8 mg/kg/min. Recheck BSL in 30 minutes.',
          isRed: false,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Drug 6 — Atropine
// ---------------------------------------------------------------------------

class _AtropineCard extends StatelessWidget {
  const _AtropineCard({required this.weight});
  final double? weight;

  @override
  Widget build(BuildContext context) {
    final w = weight;
    return _DrugCard(
      name: 'Atropine',
      category: 'ARRHYTHMIA',
      accentColor: const Color(0xFFE65100),
      children: [
        _formulaText('Dose: 0.02 mg/kg IV (min 0.1 mg, max 0.5 mg)'),
        _formulaText('Prep: Atropine 0.6 mg/ml ampoule'),
        _gap4,
        if (w != null) ...[
          () {
            final calculatedDose = 0.02 * w;
            final actualDose = calculatedDose.clamp(0.1, 0.5);
            final vol = actualDose / 0.6;

            if (calculatedDose < 0.1) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _doseLabel('Below minimum dose'),
                  _volLabel(
                      'Weight-calculated dose (${calculatedDose.toStringAsFixed(2)} mg) is below minimum. Give 0.1 mg = 0.17 ml of 0.6 mg/ml'),
                ],
              );
            } else if (calculatedDose > 0.5) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _doseLabel('Above maximum dose'),
                  _volLabel(
                      'Weight-calculated dose (${calculatedDose.toStringAsFixed(2)} mg) is above maximum. Give 0.5 mg = 0.83 ml of 0.6 mg/ml'),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _doseLabel('${actualDose.toStringAsFixed(3)} mg'),
                  _volLabel(
                      '= ${vol.toStringAsFixed(2)} ml of 0.6 mg/ml atropine'),
                ],
              );
            }
          }(),
        ] else
          _formulaText('0.02 mg/kg (min 0.1 mg, max 0.5 mg) → ÷ 0.6 mg/ml'),
        _gap4,
        _greyText('Route: IV rapid push', italic: true),
        _greyText(
            'Indication: Bradycardia from vagal stimulation or prior to intubation',
            italic: true),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Drug 7 — Phenobarbitone
// ---------------------------------------------------------------------------

class _PhenobarbitoneCard extends StatelessWidget {
  const _PhenobarbitoneCard({required this.weight});
  final double? weight;

  @override
  Widget build(BuildContext context) {
    final w = weight;
    return _DrugCard(
      name: 'Phenobarbitone (Seizure Loading)',
      category: 'ANTICONVULSANT',
      accentColor: const Color(0xFF6A1B9A),
      children: [
        _formulaText('Dose: 20 mg/kg IV loading dose'),
        _formulaText(
            'Prep: Phenobarbitone 200 mg/ml — dilute with NS to 20 mg/ml for safer administration'),
        _gap4,
        if (w != null) ...[
          _doseLabel('Draw ${(20 * w / 200).toStringAsFixed(2)} ml'
              ' (= ${(w * 0.1).toStringAsFixed(2)} ml) of 200 mg/ml'),
          _volLabel(
              'Dilute to ${w.toStringAsFixed(2)} ml with NS (final 20 mg/ml)'),
        ] else
          _formulaText(
              '0.1 ml/kg of 200 mg/ml → dilute to weight (ml) with NS'),
        _gap4,
        _greyText('Route: IV over 20–30 minutes', italic: true),
        _noteCard(
          'May repeat 5–10 mg/kg boluses up to total 40 mg/kg. Monitor for respiratory depression.',
          isRed: false,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Drug 8 — Phenytoin
// ---------------------------------------------------------------------------

class _PhenytoinCard extends StatelessWidget {
  const _PhenytoinCard({required this.weight});
  final double? weight;

  @override
  Widget build(BuildContext context) {
    final w = weight;
    return _DrugCard(
      name: 'Phenytoin (Seizure Loading)',
      category: 'ANTICONVULSANT',
      accentColor: const Color(0xFF6A1B9A),
      children: [
        _formulaText('Dose: 20 mg/kg IV loading dose'),
        _formulaText('Prep: Phenytoin 50 mg/ml'),
        _gap4,
        if (w != null)
          _volLabel('${(0.4 * w).toStringAsFixed(2)} ml of 50 mg/ml phenytoin')
        else
          _formulaText('0.4 ml/kg of 50 mg/ml phenytoin'),
        _gap4,
        _greyText(
            'Route: IV over 20–30 minutes (not faster than 1 mg/kg/min)',
            italic: true),
        _noteCard(
          'Use NS only — precipitates in dextrose. Monitor ECG during infusion. Avoid in neonates with cardiac conduction defects.',
          isRed: true,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Drug 9 — Vitamin K
// ---------------------------------------------------------------------------

class _VitaminKCard extends StatelessWidget {
  const _VitaminKCard({required this.weight});
  final double? weight;

  @override
  Widget build(BuildContext context) {
    final w = weight;
    return _DrugCard(
      name: 'Vitamin K',
      category: 'ROUTINE',
      accentColor: const Color(0xFF1565C0),
      children: [
        _formulaText('Dose: <1.5 kg: 0.5 mg IM; ≥1.5 kg: 1 mg IM'),
        _formulaText('Prep: Vitamin K 10 mg/ml'),
        _gap4,
        if (w != null) ...[
          if (w < 1.5) ...[
            _doseLabel('Weight < 1.5 kg → 0.5 mg dose'),
            _volLabel('0.05 ml IM (0.5 mg) of 10 mg/ml'),
          ] else ...[
            _doseLabel('Weight ≥ 1.5 kg → 1 mg dose'),
            _volLabel('0.1 ml IM (1 mg) of 10 mg/ml'),
          ],
        ] else
          _formulaText('0.05 ml IM for <1.5 kg; 0.1 ml IM for ≥1.5 kg'),
        _gap4,
        _greyText('Route: IM injection', italic: true),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Drug 10 — Normal Saline Bolus
// ---------------------------------------------------------------------------

class _NormalSalineCard extends StatelessWidget {
  const _NormalSalineCard({required this.weight});
  final double? weight;

  @override
  Widget build(BuildContext context) {
    final w = weight;
    return _DrugCard(
      name: 'Normal Saline Bolus',
      category: 'VOLUME',
      accentColor: const Color(0xFF00838F),
      children: [
        _formulaText('Dose: 10–20 ml/kg IV'),
        _gap4,
        if (w != null)
          _volLabel(
              '${(10 * w).toStringAsFixed(0)} ml to ${(20 * w).toStringAsFixed(0)} ml of 0.9% NS')
        else
          _formulaText('10–20 ml/kg of 0.9% NS'),
        _gap4,
        _greyText('Route: IV over 30–60 minutes', italic: true),
        _noteCard(
          'Use 10 ml/kg first, reassess before second bolus. In preterm <28 wks, give slowly over 30–60 min to reduce IVH risk.',
          isRed: false,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Drug 11 — Fresh Frozen Plasma
// ---------------------------------------------------------------------------

class _FfpCard extends StatelessWidget {
  const _FfpCard({required this.weight});
  final double? weight;

  @override
  Widget build(BuildContext context) {
    final w = weight;
    return _DrugCard(
      name: 'Fresh Frozen Plasma (FFP)',
      category: 'BLOOD PRODUCT',
      accentColor: const Color(0xFFAD1457),
      children: [
        _formulaText('Dose: 10–15 ml/kg IV'),
        _gap4,
        if (w != null)
          _volLabel(
              '${(10 * w).toStringAsFixed(0)} ml to ${(15 * w).toStringAsFixed(0)} ml of FFP')
        else
          _formulaText('10–15 ml/kg of FFP'),
        _gap4,
        _greyText('Route: IV over 30–60 minutes', italic: true),
        _noteCard(
          'Ensure ABO compatibility. Thaw time ~30 mins. Indications: coagulopathy, DIC, sepsis with bleeding.',
          isRed: false,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Drug 12 — Packed Red Blood Cells
// ---------------------------------------------------------------------------

class _PrbcCard extends StatelessWidget {
  const _PrbcCard({required this.weight});
  final double? weight;

  @override
  Widget build(BuildContext context) {
    final w = weight;
    return _DrugCard(
      name: 'Packed Red Blood Cells (PRBC)',
      category: 'BLOOD PRODUCT',
      accentColor: const Color(0xFFAD1457),
      children: [
        _formulaText('Dose: 10–20 ml/kg IV'),
        _gap4,
        if (w != null)
          _volLabel(
              '${(10 * w).toStringAsFixed(0)} ml to ${(20 * w).toStringAsFixed(0)} ml of PRBC')
        else
          _formulaText('10–20 ml/kg of PRBC'),
        _gap4,
        _greyText('Route: IV over 3–4 hours (slower if haemodynamically stable)',
            italic: true),
        _noteCard(
          'Target Hb depends on clinical context. Use irradiated, CMV-negative blood for preterm <1500g. '
          'Transfusion threshold varies by GA, respiratory support, and symptoms.',
          isRed: false,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Footer
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// PUBLIC: ResusBolusList — inline column of all 12 bolus drug cards.
// Used by the NICU emergency drugs screen to render bolus drugs as a
// top-level "STAT BOLUS" view (instead of opening as a modal sheet).
// ---------------------------------------------------------------------------

class ResusBolusList extends StatelessWidget {
  const ResusBolusList({super.key, required this.weight});
  final double? weight;

  @override
  Widget build(BuildContext context) {
    final w = weight;
    final cards = <Widget>[
      _AdrenalineCard(weight: w),
      _SodiumBicarbonateCard(weight: w),
      _AdenosineCard(weight: w),
      _CalciumGluconateCard(weight: w),
      _GlucoseBolus(weight: w),
      _AtropineCard(weight: w),
      _PhenobarbitoneCard(weight: w),
      _PhenytoinCard(weight: w),
      _VitaminKCard(weight: w),
      _NormalSalineCard(weight: w),
      _FfpCard(weight: w),
      _PrbcCard(weight: w),
    ];
    return Column(
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          cards[i],
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// PUBLIC: ResusBolusTable — compact one-row-per-drug table view of bolus
// drugs. Computes mg + mL live from weight when entered.
// ---------------------------------------------------------------------------

class _BolusRow {
  final String name;
  final String indication;
  /// Returns the dose+volume string for the given weight (or "Enter wt").
  final String Function(double w) compute;
  /// Static reference shown when weight is not entered.
  final String reference;
  const _BolusRow({
    required this.name,
    required this.indication,
    required this.compute,
    required this.reference,
  });
}

final List<_BolusRow> _bolusRows = [
  _BolusRow(
    name: 'Adrenaline',
    indication: 'Cardiac arrest',
    reference: '0.01–0.03 mg/kg of 1:10,000',
    compute: (w) =>
        '${(0.01 * w).toStringAsFixed(2)}–${(0.03 * w).toStringAsFixed(2)} mg '
        '(${(0.1 * w).toStringAsFixed(2)}–${(0.3 * w).toStringAsFixed(2)} mL of 1:10,000)',
  ),
  _BolusRow(
    name: 'Na Bicarbonate',
    indication: 'Acidosis · Hyperkalaemia',
    reference: '1–2 mEq/kg of 4.2 %',
    compute: (w) =>
        '${(1 * w).toStringAsFixed(1)}–${(2 * w).toStringAsFixed(1)} mEq '
        '(${(2 * w).toStringAsFixed(1)}–${(4 * w).toStringAsFixed(1)} mL of 4.2 %)',
  ),
  _BolusRow(
    name: 'Adenosine 1st',
    indication: 'SVT — rapid push',
    reference: '0.1 mg/kg of 3 mg/mL',
    compute: (w) =>
        '${(0.1 * w).toStringAsFixed(2)} mg '
        '(${(0.1 * w / 3).toStringAsFixed(2)} mL of 3 mg/mL)',
  ),
  _BolusRow(
    name: 'Adenosine 2nd',
    indication: 'SVT — repeat',
    reference: '0.2 mg/kg of 3 mg/mL',
    compute: (w) =>
        '${(0.2 * w).toStringAsFixed(2)} mg '
        '(${(0.2 * w / 3).toStringAsFixed(2)} mL of 3 mg/mL)',
  ),
  _BolusRow(
    name: 'Calcium gluconate',
    indication: 'Hypocalc · Hyperkal',
    reference: '1–2 mL/kg of 10 %',
    compute: (w) =>
        '${(1 * w).toStringAsFixed(1)}–${(2 * w).toStringAsFixed(1)} mL of 10 %',
  ),
  _BolusRow(
    name: 'D10 bolus',
    indication: 'Hypoglycaemia',
    reference: '2 mL/kg of 10 % dextrose',
    compute: (w) => '${(2 * w).toStringAsFixed(1)} mL of 10 % dextrose',
  ),
  _BolusRow(
    name: 'Atropine',
    indication: 'Brady · pre-intubation',
    reference: '0.02 mg/kg (min 0.1 / max 0.5)',
    compute: (w) {
      final d = (0.02 * w).clamp(0.1, 0.5);
      return '${d.toStringAsFixed(2)} mg '
          '(${(d / 0.6).toStringAsFixed(2)} mL of 0.6 mg/mL)';
    },
  ),
  _BolusRow(
    name: 'Phenobarbitone',
    indication: 'Seizure load',
    reference: '20 mg/kg of 200 mg/mL',
    compute: (w) =>
        '${(20 * w).toStringAsFixed(0)} mg '
        '(${(0.1 * w).toStringAsFixed(2)} mL of 200 mg/mL)',
  ),
  _BolusRow(
    name: 'Phenytoin',
    indication: 'Seizure load',
    reference: '20 mg/kg of 50 mg/mL',
    compute: (w) =>
        '${(20 * w).toStringAsFixed(0)} mg '
        '(${(0.4 * w).toStringAsFixed(2)} mL of 50 mg/mL)',
  ),
  _BolusRow(
    name: 'Vitamin K',
    indication: 'IM at birth',
    reference: '0.5 mg < 1 kg ; 1 mg ≥ 1 kg',
    compute: (w) => w < 1.0
        ? '0.5 mg IM (0.05 mL of 10 mg/mL)'
        : '1.0 mg IM (0.1 mL of 10 mg/mL)',
  ),
  _BolusRow(
    name: 'Normal saline',
    indication: 'Volume bolus',
    reference: '10–20 mL/kg of 0.9 % NS',
    compute: (w) =>
        '${(10 * w).toStringAsFixed(0)}–${(20 * w).toStringAsFixed(0)} mL of 0.9 % NS',
  ),
  _BolusRow(
    name: 'FFP',
    indication: 'Coagulopathy',
    reference: '10–15 mL/kg',
    compute: (w) =>
        '${(10 * w).toStringAsFixed(0)}–${(15 * w).toStringAsFixed(0)} mL of FFP',
  ),
  _BolusRow(
    name: 'PRBC',
    indication: 'Anaemia · transfusion',
    reference: '10–20 mL/kg',
    compute: (w) =>
        '${(10 * w).toStringAsFixed(0)}–${(20 * w).toStringAsFixed(0)} mL of PRBC',
  ),
];

class ResusBolusTable extends StatelessWidget {
  const ResusBolusTable({super.key, required this.weight});
  final double? weight;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final w = weight;
    final hasWt = w != null && w > 0;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.10)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFB71C1C).withValues(alpha: 0.10),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(9),
                topRight: Radius.circular(9),
              ),
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: _hdr('DRUG')),
                Expanded(flex: 4, child: _hdr('INDICATION')),
                Expanded(
                    flex: 6,
                    child: _hdr(hasWt ? 'DOSE @ ${w.toStringAsFixed(2)} kg'
                        : 'REFERENCE')),
              ],
            ),
          ),
          for (final row in _bolusRows)
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 3,
                      child: Text(row.name,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700))),
                  Expanded(
                      flex: 4,
                      child: Text(row.indication,
                          style: TextStyle(
                              fontSize: 11,
                              color: cs.onSurface
                                  .withValues(alpha: 0.7)))),
                  Expanded(
                      flex: 6,
                      child: Text(
                          hasWt
                              ? row.compute(w)
                              : row.reference,
                          style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: hasWt
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              color: hasWt
                                  ? const Color(0xFFBF360C)
                                  : cs.onSurface
                                      .withValues(alpha: 0.85)))),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _hdr(String s) => Text(s,
      style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF8B0000),
          letterSpacing: 0.4));
}

class _FooterBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFB71C1C).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFB71C1C).withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Color(0xFFB71C1C), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'These are emergency reference doses only. Always verify with senior clinician.\n'
              'Doses based on standard neonatal resuscitation guidelines.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: const Color(0xFFB71C1C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
