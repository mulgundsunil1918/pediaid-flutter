import 'package:flutter/material.dart';
import '../calculators/pet_calculator_screen.dart';

class PolycythemiaGuideScreen extends StatelessWidget {
  const PolycythemiaGuideScreen({super.key});

  static const _accent = Color(0xFF880E4F); // deep pink/maroon for polycythemia
  static const _red    = Color(0xFFB71C1C);
  static const _amber  = Color(0xFFFF8F00);
  static const _green  = Color(0xFF2E7D32);
  static const _blue   = Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final cardBg    = isDark ? const Color(0xFF161B22) : Colors.white;
    final onSurface = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subText   = isDark ? Colors.white60 : Colors.black54;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Polycythemia Management')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Section 1 — Definition ────────────────────────────────────
            _sectionCard(
              cardBg: cardBg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Definition / Trigger', Icons.info_outline_rounded,
                      _accent, onSurface),
                  const SizedBox(height: 12),
                  _definitionChip(
                    'Venous hematocrit ≥ 65%',
                    Icons.water_drop_rounded,
                    _red,
                    isDark,
                  ),
                  const SizedBox(height: 8),
                  _definitionChip(
                    'First: Exclude dehydration (check weight loss)',
                    Icons.warning_amber_rounded,
                    _amber,
                    isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Section 2 — Algorithm ────────────────────────────────────
            _sectionCard(
              cardBg: cardBg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Management Algorithm', Icons.account_tree_outlined,
                      _accent, onSurface),
                  const SizedBox(height: 16),

                  // Top node
                  _flowNode(
                    label: 'Venous Hematocrit ≥ 65%',
                    color: _red,
                    isTrigger: true,
                  ),
                  _flowArrow(),

                  // Dehydration check
                  _flowNode(
                    label: 'Exclude dehydration\n(Check weight loss)',
                    color: _amber,
                  ),
                  _flowArrow(),

                  // Symptomatic / Asymptomatic split
                  Row(
                    children: [
                      Expanded(
                        child: _flowBranch(
                          label: 'Symptomatic',
                          color: _red,
                          isDark: isDark,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 60,
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                      Expanded(
                        child: _flowBranch(
                          label: 'Asymptomatic',
                          color: _blue,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),

                  // Left branch arrow
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _flowArrow(),
                            _flowNode(
                              label: 'PET\nIndicated',
                              color: _red,
                              isResult: true,
                            ),
                          ],
                        ),
                      ),
                      // Right branch — 3 sub-nodes
                      Expanded(
                        child: Column(
                          children: [
                            _flowArrow(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _hctSubNode('Hct\n≥ 75%', _red, isDark),
                                _hctSubNode('Hct\n70–74%', _amber, isDark),
                                _hctSubNode('Hct\n65–69%', _green, isDark),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _arrowDown(_red),
                                _arrowDown(_amber),
                                _arrowDown(_green),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _resultTag('PET', _red, isDark),
                                _resultTag('Consider\nhydration', _amber, isDark),
                                _resultTag('Monitor\nsymptoms', _green, isDark),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Section 3 — Rule of Thumb ─────────────────────────────────
            _sectionCard(
              cardBg: cardBg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Rule of Thumb', Icons.lightbulb_outline_rounded,
                      _amber, onSurface),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _amber.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      'Volume of blood to be exchanged is usually 20 mL/kg',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Blood volume reference (Rawlings Chart):',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: onSurface,
                      )),
                  const SizedBox(height: 8),
                  _bloodVolumeRow('Term babies', '80–90 mL/kg', _green, isDark),
                  const SizedBox(height: 6),
                  _bloodVolumeRow('Preterm babies', '90–100 mL/kg', _blue, isDark),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Section 4 — PET Calculator button ───────────────────────
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PETCalculatorScreen()),
              ),
              icon: const Icon(Icons.calculate_rounded),
              label: const Text('Open Partial Exchange Transfusion Calculator'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),

            // ── Reference ─────────────────────────────────────────────────
            Text(
              'Source: AIIMS Protocols in Neonatology',
              style: TextStyle(
                fontSize: 11,
                color: subText,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Widget helpers ─────────────────────────────────────────────────────────

  Widget _sectionCard({required Color cardBg, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _accent.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(14),
      child: child,
    );
  }

  Widget _sectionTitle(String title, IconData icon, Color color, Color onSurface) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: color,
            )),
      ],
    );
  }

  Widget _definitionChip(String text, IconData icon, Color color, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                )),
          ),
        ],
      ),
    );
  }

  Widget _flowNode({required String label, required Color color, bool isTrigger = false, bool isResult = false}) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(minWidth: 160, maxWidth: 220),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isTrigger || isResult ? color : color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: isTrigger || isResult ? 0 : 1.5),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isTrigger || isResult ? Colors.white : color,
            height: 1.3,
          ),
        ),
      ),
    );
  }

  Widget _flowArrow() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            Container(width: 2, height: 12, color: Colors.grey.withValues(alpha: 0.5)),
            Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.grey.withValues(alpha: 0.7), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _flowBranch({required String label, required Color color, required bool isDark}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: color,
          )),
    );
  }

  Widget _hctSubNode(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color, height: 1.2)),
    );
  }

  Widget _arrowDown(Color color) {
    return Icon(Icons.keyboard_arrow_down_rounded,
        color: color.withValues(alpha: 0.7), size: 18);
  }

  Widget _resultTag(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          )),
    );
  }

  Widget _bloodVolumeRow(String label, String value, Color color, bool isDark) {
    return Row(
      children: [
        Container(
          width: 10, height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            )),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: color,
              )),
        ),
      ],
    );
  }
}
