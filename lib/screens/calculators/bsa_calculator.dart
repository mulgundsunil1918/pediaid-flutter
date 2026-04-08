import 'dart:math';
import 'package:flutter/material.dart';

class BSACalculator extends StatefulWidget {
  const BSACalculator({super.key});

  @override
  State<BSACalculator> createState() => _BSACalculatorState();
}

class _BSACalculatorState extends State<BSACalculator> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  double? _bsa;
  _AgeGroup? _closestGroup;

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    final double weight = double.parse(_weightController.text);
    final double height = double.parse(_heightController.text);
    final double bsa = sqrt((height * weight) / 3600);
    setState(() {
      _bsa = bsa;
      _closestGroup = _AgeGroup.closest(bsa);
    });
  }

  void _reset() {
    _formKey.currentState?.reset();
    _weightController.clear();
    _heightController.clear();
    setState(() {
      _bsa = null;
      _closestGroup = null;
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('BSA Calculator'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 16),
            _buildInputCard(),
            if (_bsa != null) ...[
              const SizedBox(height: 16),
              _buildResultCard(),
              const SizedBox(height: 16),
              _buildReferenceTable(),
            ],
            const SizedBox(height: 16),
            _buildDisclaimer(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.info_outline,
                      color: colorScheme.primary, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  'Body Surface Area (BSA)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'BSA is used for dosing chemotherapy, burns assessment, and '
              'calculating cardiac index. The Mosteller formula is widely used '
              'in paediatric and adult clinical practice.',
              style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.5),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
              ),
              child: Text(
                'BSA (m²) = √( Height (cm) × Weight (kg) / 3600 )',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter Measurements',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                style: TextStyle(color: colorScheme.onSurface),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: _inputDecoration(
                  label: 'Weight',
                  hint: 'e.g. 3.5',
                  suffix: 'kg',
                  icon: Icons.monitor_weight_outlined,
                  helper: 'Range: 0.5 – 150 kg',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter weight';
                  final w = double.tryParse(v);
                  if (w == null) return 'Enter a valid number';
                  if (w < 0.5 || w > 150) return 'Weight must be 0.5–150 kg';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _heightController,
                style: TextStyle(color: colorScheme.onSurface),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: _inputDecoration(
                  label: 'Height',
                  hint: 'e.g. 50',
                  suffix: 'cm',
                  icon: Icons.straighten_outlined,
                  helper: 'Range: 30 – 200 cm',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter height';
                  final h = double.tryParse(v);
                  if (h == null) return 'Enter a valid number';
                  if (h < 30 || h > 200) return 'Height must be 30–200 cm';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Clear'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        side: BorderSide(color: colorScheme.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _calculate,
                      icon: const Icon(Icons.calculate, size: 18),
                      label: const Text('Calculate'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 3,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Body Surface Area',
              style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  letterSpacing: 1.1),
            ),
            const SizedBox(height: 6),
            Text(
              _bsa!.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            Text(
              'm²',
              style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    _closestGroup!.label,
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Closest reference: ${_closestGroup!.bsaRange}',
                    style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferenceTable() {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reference BSA by Age Group',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            ..._AgeGroup.all.map((group) {
              final isCurrent = _closestGroup == group;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : colorScheme.onSurface.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(8),
                  border: isCurrent
                      ? Border.all(color: colorScheme.primary, width: 1.5)
                      : Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Text(
                        group.label,
                        style: TextStyle(
                          fontWeight: isCurrent
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 13,
                          color: isCurrent
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      group.bsaRange,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: isCurrent
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_left,
                          color: colorScheme.primary, size: 20),
                    ],
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimer() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_outlined,
              color: Colors.amber, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'For clinical use — verify before acting.',
              style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required String suffix,
    required IconData icon,
    String? helper,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixText: suffix,
      helperText: helper,
      prefixIcon: Icon(icon, color: colorScheme.primary),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      labelStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
      floatingLabelStyle: TextStyle(color: colorScheme.primary),
    );
  }
}

// ---------------------------------------------------------------------------
// Age Group reference model
// ---------------------------------------------------------------------------

class _AgeGroup {
  final String label;
  final String bsaRange;
  final double midpoint;

  const _AgeGroup({
    required this.label,
    required this.bsaRange,
    required this.midpoint,
  });

  static const _AgeGroup preterm = _AgeGroup(
    label: 'Preterm neonate (<28 wks)',
    bsaRange: '~0.10 m²',
    midpoint: 0.10,
  );

  static const _AgeGroup termNeonate = _AgeGroup(
    label: 'Term neonate',
    bsaRange: '0.19–0.21 m²',
    midpoint: 0.20,
  );

  static const _AgeGroup infant = _AgeGroup(
    label: 'Infant (~1 year)',
    bsaRange: '~0.40 m²',
    midpoint: 0.40,
  );

  static const _AgeGroup child = _AgeGroup(
    label: 'Child (~10 years)',
    bsaRange: '~1.00 m²',
    midpoint: 1.00,
  );

  static const _AgeGroup adult = _AgeGroup(
    label: 'Adult',
    bsaRange: '1.70–1.90 m²',
    midpoint: 1.80,
  );

  static const List<_AgeGroup> all = [
    preterm,
    termNeonate,
    infant,
    child,
    adult,
  ];

  static _AgeGroup closest(double bsa) {
    _AgeGroup best = all.first;
    double bestDiff = (bsa - all.first.midpoint).abs();
    for (final group in all) {
      final diff = (bsa - group.midpoint).abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        best = group;
      }
    }
    return best;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is _AgeGroup && other.label == label;

  @override
  int get hashCode => label.hashCode;
}
