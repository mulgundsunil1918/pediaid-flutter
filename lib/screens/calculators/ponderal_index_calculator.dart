import 'package:flutter/material.dart';

class PonderalIndexCalculator extends StatefulWidget {
  const PonderalIndexCalculator({super.key});

  @override
  State<PonderalIndexCalculator> createState() =>
      _PonderalIndexCalculatorState();
}

class _PonderalIndexCalculatorState extends State<PonderalIndexCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _lengthController = TextEditingController();

  double? _pi;
  _PICategory? _category;

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    final double weight = double.parse(_weightController.text);
    final double length = double.parse(_lengthController.text);
    final double pi = (weight / (length * length * length)) * 100;
    setState(() {
      _pi = pi;
      _category = _PICategory.fromValue(pi);
    });
  }

  void _reset() {
    _formKey.currentState?.reset();
    _weightController.clear();
    _lengthController.clear();
    setState(() {
      _pi = null;
      _category = null;
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _lengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Ponderal Index'),
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
            if (_pi != null) ...[
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
                  'Ponderal Index (PI)',
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
              'The Ponderal Index assesses neonatal nutritional status and body '
              'proportionality. It distinguishes between symmetrical and asymmetrical '
              'intrauterine growth restriction (IUGR).',
              style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.5),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2)),
              ),
              child: Text(
                'PI = (Weight in grams / Length in cm³) × 100',
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
                  label: 'Birth Weight',
                  hint: 'e.g. 3200',
                  suffix: 'g',
                  icon: Icons.monitor_weight_outlined,
                  helper: 'Range: 500 – 6000 g',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter birth weight';
                  final w = double.tryParse(v);
                  if (w == null) return 'Enter a valid number';
                  if (w < 500 || w > 6000) return 'Weight must be 500–6000 g';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lengthController,
                style: TextStyle(color: colorScheme.onSurface),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: _inputDecoration(
                  label: 'Birth Length',
                  hint: 'e.g. 50',
                  suffix: 'cm',
                  icon: Icons.straighten_outlined,
                  helper: 'Range: 25 – 65 cm',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter birth length';
                  final l = double.tryParse(v);
                  if (l == null) return 'Enter a valid number';
                  if (l < 25 || l > 65) return 'Length must be 25–65 cm';
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
    final cat = _category!;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 3,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cat.color.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Ponderal Index',
              style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  letterSpacing: 1.1),
            ),
            const SizedBox(height: 6),
            Text(
              _pi!.toStringAsFixed(3),
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: cat.color,
              ),
            ),
            Text(
              'g/cm³ × 100',
              style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: cat.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    cat.label,
                    style: TextStyle(
                      color: cat.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat.description,
                    style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurface,
                        height: 1.4),
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
              'Reference Ranges',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            ..._PICategory.all.map((cat) {
              final isCurrent = _category == cat;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? cat.color.withValues(alpha: 0.12)
                      : colorScheme.onSurface.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(8),
                  border: isCurrent
                      ? Border.all(color: cat.color, width: 1.5)
                      : Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: cat.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 80,
                      child: Text(
                        cat.range,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: cat.color,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        cat.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isCurrent
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isCurrent
                              ? cat.color
                              : colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (isCurrent)
                      Icon(Icons.arrow_left, color: cat.color, size: 20),
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
// PI Category model
// ---------------------------------------------------------------------------

class _PICategory {
  final String range;
  final String label;
  final String description;
  final Color color;

  const _PICategory({
    required this.range,
    required this.label,
    required this.description,
    required this.color,
  });

  static const _PICategory aga = _PICategory(
    range: '> 2.5',
    label: 'AGA — Normal',
    description:
        'Ponderal Index is within normal range. Consistent with appropriate-for-gestational-age (AGA) term newborn.',
    color: Color(0xFF2e7d32),
  );

  static const _PICategory symmetrical = _PICategory(
    range: '2.0 – 2.5',
    label: 'Symmetrical IUGR',
    description:
        'Both weight and length proportionally reduced, indicating chronic early-onset growth restriction.',
    color: Color(0xFFe65100),
  );

  static const _PICategory asymmetrical = _PICategory(
    range: '< 2.0',
    label: 'Asymmetrical IUGR',
    description:
        'Critically low. Consistent with Asymmetrical IUGR and Severe PEM. Immediate clinical evaluation warranted.',
    color: Color(0xFFc62828),
  );

  static const List<_PICategory> all = [aga, symmetrical, asymmetrical];

  static _PICategory fromValue(double pi) {
    if (pi > 2.5) return aga;
    if (pi >= 2.0) return symmetrical;
    return asymmetrical;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _PICategory && other.range == range;

  @override
  int get hashCode => range.hashCode;
}
