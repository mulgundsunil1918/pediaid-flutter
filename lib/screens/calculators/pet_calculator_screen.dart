import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Colour tokens (GIR calculator style) ────────────────────────────────────
const Color _accent = Color(0xFF58a6ff);
const Color _green  = Color(0xFF3fb950);
const Color _amber  = Color(0xFFd29922);
const Color _teal   = Color(0xFF39d0c8);

class PETCalculatorScreen extends StatefulWidget {
  const PETCalculatorScreen({super.key});

  @override
  State<PETCalculatorScreen> createState() => _PETCalculatorScreenState();
}

class _PETCalculatorScreenState extends State<PETCalculatorScreen>
    with SingleTickerProviderStateMixin {
  // ── Form ──────────────────────────────────────────────────────────────────
  final _formKey   = GlobalKey<FormState>();
  final _weightCtrl = TextEditingController();
  final _obsCtr     = TextEditingController();
  final _desCtr     = TextEditingController(text: '55');

  bool _isPreterm   = false;   // false = term, true = preterm
  bool _showResult  = false;

  // ── Animation ─────────────────────────────────────────────────────────────
  late AnimationController _fadeCtrl;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  // ── Result ────────────────────────────────────────────────────────────────
  double _volLow  = 0;
  double _volHigh = 0;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim  = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _weightCtrl.dispose();
    _obsCtr.dispose();
    _desCtr.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final weight  = double.parse(_weightCtrl.text.trim());
    final obsHct  = double.parse(_obsCtr.text.trim());
    final desHct  = double.parse(_desCtr.text.trim());

    final bvLow  = weight * (_isPreterm ? 90 : 80);
    final bvHigh = weight * (_isPreterm ? 100 : 90);

    if (obsHct <= desHct) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Observed Hct must be greater than Desired Hct'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() {
      _volLow  = bvLow  * (obsHct - desHct) / obsHct;
      _volHigh = bvHigh * (obsHct - desHct) / obsHct;
      _showResult = true;
    });

    _fadeCtrl.forward(from: 0);
  }

  void _reset() {
    _weightCtrl.clear();
    _obsCtr.clear();
    _desCtr.text = '55';
    setState(() {
      _showResult  = false;
      _isPreterm   = false;
    });
    _fadeCtrl.reset();
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final cardBg   = isDark ? const Color(0xFF161B22) : Colors.white;
    final onSurface = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subText  = isDark ? Colors.white60 : Colors.black54;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('PET Calculator'),
        actions: [
          TextButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Reset'),
            style: TextButton.styleFrom(foregroundColor: _accent),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Info banner ──────────────────────────────────────────────
            _InfoBanner(cardBg: cardBg, onSurface: onSurface, subText: subText),
            const SizedBox(height: 16),

            // ── Input form ───────────────────────────────────────────────
            Form(
              key: _formKey,
              child: _sectionCard(
                context: context,
                title: 'Patient Details',
                icon: Icons.edit_note_rounded,
                cardBg: cardBg,
                child: Column(
                  children: [
                    _NumField(
                      ctrl: _weightCtrl,
                      label: 'Birth Weight (kg)',
                      hint: 'e.g. 3.2',
                      allowDecimal: true,
                      onSurface: onSurface,
                      subText: subText,
                      validator: (v) {
                        final d = double.tryParse(v ?? '');
                        if (d == null || d <= 0) return 'Enter valid weight';
                        if (d > 10) return 'Weight seems too high';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Gestation toggle
                    _GestationToggle(
                      isPreterm: _isPreterm,
                      onChanged: (v) => setState(() => _isPreterm = v),
                      onSurface: onSurface,
                      subText: subText,
                    ),
                    const SizedBox(height: 14),

                    _NumField(
                      ctrl: _obsCtr,
                      label: 'Observed Hematocrit (%)',
                      hint: 'e.g. 72',
                      allowDecimal: true,
                      onSurface: onSurface,
                      subText: subText,
                      validator: (v) {
                        final d = double.tryParse(v ?? '');
                        if (d == null || d <= 0) return 'Enter valid Hct';
                        if (d < 65) return 'Hct < 65% — polycythemia threshold not met';
                        if (d > 100) return 'Invalid Hct';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    _NumField(
                      ctrl: _desCtr,
                      label: 'Desired Hematocrit (%)',
                      hint: '55',
                      allowDecimal: true,
                      onSurface: onSurface,
                      subText: subText,
                      helperText: 'Target hematocrit: 50–55%',
                      validator: (v) {
                        final d = double.tryParse(v ?? '');
                        if (d == null || d <= 0) return 'Enter desired Hct';
                        if (d < 45 || d > 65) return 'Target usually 50–55%';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _calculate,
                        icon: const Icon(Icons.calculate_rounded),
                        label: const Text('Calculate Volume'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Result ───────────────────────────────────────────────────
            if (_showResult)
              FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: _ResultCard(
                    volLow: _volLow,
                    volHigh: _volHigh,
                    cardBg: cardBg,
                    onSurface: onSurface,
                    subText: subText,
                  ),
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ── Info Banner ───────────────────────────────────────────────────────────────
class _InfoBanner extends StatelessWidget {
  final Color cardBg, onSurface, subText;
  const _InfoBanner({required this.cardBg, required this.onSurface, required this.subText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _accent.withValues(alpha: 0.25)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.bloodtype_outlined, color: _accent, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Partial Exchange Transfusion — Polycythemia',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: onSurface,
                        )),
                    Text('Fluid used: Warmed 0.9% Normal Saline',
                        style: TextStyle(fontSize: 11, color: subText)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Volume = Blood Volume × (Observed Hct − Desired Hct) ÷ Observed Hct',
              style: TextStyle(
                fontSize: 12,
                color: _accent,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Gestation Toggle ──────────────────────────────────────────────────────────
class _GestationToggle extends StatelessWidget {
  final bool isPreterm;
  final ValueChanged<bool> onChanged;
  final Color onSurface, subText;

  const _GestationToggle({
    required this.isPreterm,
    required this.onChanged,
    required this.onSurface,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gestation', style: TextStyle(fontSize: 13, color: subText, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: !isPreterm ? _accent : _accent.withValues(alpha: 0.08),
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
                    border: Border.all(color: _accent.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    children: [
                      Text('Term',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: !isPreterm ? Colors.white : _accent,
                          )),
                      Text('80–90 mL/kg',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: !isPreterm ? Colors.white70 : subText,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isPreterm ? _accent : _accent.withValues(alpha: 0.08),
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
                    border: Border.all(color: _accent.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    children: [
                      Text('Preterm',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: isPreterm ? Colors.white : _accent,
                          )),
                      Text('90–100 mL/kg',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: isPreterm ? Colors.white70 : subText,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Result Card ───────────────────────────────────────────────────────────────
class _ResultCard extends StatelessWidget {
  final double volLow, volHigh;
  final Color cardBg, onSurface, subText;

  const _ResultCard({
    required this.volLow,
    required this.volHigh,
    required this.cardBg,
    required this.onSurface,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Volume result ────────────────────────────────────────────────
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_accent.withValues(alpha: 0.9), _teal.withValues(alpha: 0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _accent.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Exchange Volume',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 6),
              Text(
                '${volLow.toStringAsFixed(1)} – ${volHigh.toStringAsFixed(1)} mL',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Use ${volLow.toStringAsFixed(1)}–${volHigh.toStringAsFixed(1)} mL of warmed 0.9% Normal Saline '
                  'to replace equal volumes of blood withdrawn slowly over 30–60 minutes '
                  'in small aliquots of 5–10 mL via umbilical vein or peripheral vein.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── Clinical notes ───────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _green.withValues(alpha: 0.25)),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: _green, size: 16),
                  const SizedBox(width: 6),
                  Text('Clinical Notes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: _green,
                      )),
                ],
              ),
              const Divider(height: 16),
              ...[
                'Continuously monitor vital signs, glucose, and calcium.',
                'Aim for a hematocrit of 50–55% to prevent hyperviscosity and related complications.',
                'Rule of thumb: ~20 mL/kg is the usual exchange volume.',
                'Recheck hematocrit 4–6 hours post-procedure.',
                'Do NOT use plasma, albumin, or blood for PET in polycythemia.',
              ].map((note) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(color: _green, fontWeight: FontWeight.bold, fontSize: 13)),
                    Expanded(
                      child: Text(note,
                          style: TextStyle(fontSize: 13, color: onSurface, height: 1.4)),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // ── Reference ────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Source: AIIMS Protocols in Neonatology; Panel 3 — Volume to be exchanged in PET',
            style: TextStyle(fontSize: 10, color: subText, fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

Widget _sectionCard({
  required BuildContext context,
  required String title,
  required IconData icon,
  required Color cardBg,
  required Widget child,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final onSurface = isDark ? Colors.white : const Color(0xFF1A1A1A);

  return Container(
    decoration: BoxDecoration(
      color: cardBg,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _accent.withValues(alpha: 0.18)),
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: _accent, size: 18),
            const SizedBox(width: 8),
            Text(title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: onSurface,
                )),
          ],
        ),
        const Divider(height: 20),
        child,
      ],
    ),
  );
}

class _NumField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label, hint;
  final bool allowDecimal;
  final Color onSurface, subText;
  final String? helperText;
  final String? Function(String?)? validator;

  const _NumField({
    required this.ctrl,
    required this.label,
    required this.hint,
    required this.allowDecimal,
    required this.onSurface,
    required this.subText,
    this.helperText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          allowDecimal ? RegExp(r'^\d*\.?\d*') : RegExp(r'^\d*'),
        ),
      ],
      style: TextStyle(fontSize: 15, color: onSurface),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        labelStyle: TextStyle(color: subText),
        hintStyle: TextStyle(color: subText.withValues(alpha: 0.5)),
        helperStyle: TextStyle(color: _amber, fontSize: 11),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _accent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      validator: validator,
    );
  }
}
