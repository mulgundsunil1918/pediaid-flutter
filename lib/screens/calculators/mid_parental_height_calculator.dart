import 'package:flutter/material.dart';

enum _Sex { boy, girl }

class MidParentalHeightCalculator extends StatefulWidget {
  const MidParentalHeightCalculator({super.key});

  @override
  State<MidParentalHeightCalculator> createState() =>
      _MidParentalHeightCalculatorState();
}

class _MidParentalHeightCalculatorState
    extends State<MidParentalHeightCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _motherController = TextEditingController();
  final _fatherController = TextEditingController();
  _Sex _sex = _Sex.boy;

  double? _mph;

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    final double mh = double.parse(_motherController.text);
    final double fh = double.parse(_fatherController.text);
    final double mph =
        _sex == _Sex.boy ? (mh + fh) / 2 + 6.5 : (mh + fh) / 2 - 6.5;
    setState(() => _mph = mph);
  }

  void _reset() {
    _formKey.currentState?.reset();
    _motherController.clear();
    _fatherController.clear();
    setState(() {
      _mph = null;
      _sex = _Sex.boy;
    });
  }

  @override
  void dispose() {
    _motherController.dispose();
    _fatherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Mid-Parental Height'),
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
            if (_mph != null) ...[
              const SizedBox(height: 16),
              _buildResultCard(),
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
                Expanded(
                  child: Text(
                    'Mid-Parental Height (MPH)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Determines a child's genetic height potential from parental "
              'heights — useful for contextualising growth-chart centiles '
              'and screening for familial short or tall stature.',
              style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.5),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Text(
                    "Boys: (Mother's + Father's height)/2 + 6.5 cm",
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Girls: (Mother's + Father's height)/2 − 6.5 cm",
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
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
                "Child's Sex",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: _sexButton(_Sex.boy, 'Boy', Icons.male_rounded)),
                  const SizedBox(width: 12),
                  Expanded(
                      child:
                          _sexButton(_Sex.girl, 'Girl', Icons.female_rounded)),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Enter Parental Heights',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _motherController,
                style: TextStyle(color: colorScheme.onSurface),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: _inputDecoration(
                  label: "Mother's Height",
                  hint: 'e.g. 160',
                  suffix: 'cm',
                  icon: Icons.height_rounded,
                  helper: 'Range: 120 – 200 cm',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Enter mother's height";
                  final h = double.tryParse(v);
                  if (h == null) return 'Enter a valid number';
                  if (h < 120 || h > 200) return 'Height must be 120–200 cm';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fatherController,
                style: TextStyle(color: colorScheme.onSurface),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: _inputDecoration(
                  label: "Father's Height",
                  hint: 'e.g. 175',
                  suffix: 'cm',
                  icon: Icons.height_rounded,
                  helper: 'Range: 130 – 220 cm',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Enter father's height";
                  final h = double.tryParse(v);
                  if (h == null) return 'Enter a valid number';
                  if (h < 130 || h > 220) return 'Height must be 130–220 cm';
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

  Widget _sexButton(_Sex value, String label, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = _sex == value;
    return Material(
      color: selected
          ? colorScheme.primary
          : colorScheme.onSurface.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => setState(() => _sex = value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: selected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface.withValues(alpha: 0.6)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final colorScheme = Theme.of(context).colorScheme;
    final low = _mph! - 6;
    final high = _mph! + 6;
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
              'Mid-Parental Height',
              style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  letterSpacing: 1.1),
            ),
            const SizedBox(height: 6),
            Text(
              _mph!.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            Text(
              'cm',
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
                    'Target Height Range',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${low.toStringAsFixed(1)} – ${high.toStringAsFixed(1)} cm  (MPH ± 6 cm)',
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
              'Genetic potential estimate only — actual adult height is also '
              'influenced by nutrition, health, and environmental factors.',
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
      labelStyle:
          TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
      floatingLabelStyle: TextStyle(color: colorScheme.primary),
    );
  }
}
