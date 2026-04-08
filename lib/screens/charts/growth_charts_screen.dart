import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'who_chart_selection_screen.dart';
import 'iap_chart_screen.dart';
import 'fenton_chart_screen.dart';

const _intergrowthUrl =
    'https://intergrowth21.ndog.ox.ac.uk/en/ManualEntry';

class GrowthChartsScreen extends StatelessWidget {
  const GrowthChartsScreen({super.key});

  Future<void> _launchIntergrowth(BuildContext context) async {
    final uri = Uri.parse(_intergrowthUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        _showSnackBar(context, 'Could not open browser.');
      }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Growth Charts'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── CARD 1: WHO 0-5 Years (ACTIVE) ────────────────────────────
            _ActiveChartCard(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const WhoChartSelectionScreen()),
              ),
            ),
            const SizedBox(height: 14),
            // ── CARD 2: IAP 5-18 Years (ACTIVE) ───────────────────────────
            _IAPChartCard(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IAPChartScreen()),
              ),
            ),
            const SizedBox(height: 14),
            // ── CARD 3: Fenton Preterm (ACTIVE) ───────────────────────────
            _FentonChartCard(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const FentonChartScreen()),
              ),
            ),
            const SizedBox(height: 14),
            // ── CARD 4: INTERGROWTH-21st (external) ───────────────────────
            _IntergrowthCard(
              onTap: () => _launchIntergrowth(context),
            ),
            const SizedBox(height: 14),
            // ── CARD 5: Other Charts (LOCKED) ─────────────────────────────
            _LockedChartCard(
              icon: Icons.bar_chart,
              title: 'Other Reference Charts',
              ageRange: 'Additional clinical charts',
              chips: const ['BP', 'Bilirubin', 'OFC'],
              measurements: '',
              onTap: () =>
                  _showSnackBar(context, 'Other charts — Coming Soon.'),
            ),
            const SizedBox(height: 24),
          ],
        ),
        ),
      ),
    );
  }
}

// ── Active WHO Card ───────────────────────────────────────────────────────────

class _ActiveChartCard extends StatelessWidget {
  final VoidCallback onTap;

  const _ActiveChartCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final accentTeal = cs.primary;
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border(
              left: BorderSide(color: accentTeal, width: 4),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon circle
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accentTeal,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.show_chart, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WHO Growth Charts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text('0 to 5 Years',
                        style: TextStyle(
                            fontSize: 13,
                            color: cs.onSurface.withValues(alpha: 0.6))),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _Chip('Boys', const Color(0xFF1565C0)),
                        _Chip('Girls', const Color(0xFFAD1457)),
                        _Chip('Centile + SD', accentTeal),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Height · Weight · HC · BMI · More',
                      style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withValues(alpha: 0.45)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: cs.onSurface, size: 26),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Active IAP Card ───────────────────────────────────────────────────────────

const Color _iapTeal = Color(0xFF0d7a6e);

class _IAPChartCard extends StatelessWidget {
  final VoidCallback onTap;

  const _IAPChartCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: const Border(
              left: BorderSide(color: _iapTeal, width: 4),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: _iapTeal,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.show_chart, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IAP Growth Charts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text('5 to 18 Years',
                        style: TextStyle(
                            fontSize: 13,
                            color: cs.onSurface.withValues(alpha: 0.6))),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _Chip('Boys', const Color(0xFF1565C0)),
                        _Chip('Girls', const Color(0xFFAD1457)),
                        _Chip('IAP 2015', _iapTeal),
                        _Chip('Indian Data', _iapTeal),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Height · Weight · BMI · Indian reference',
                      style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withValues(alpha: 0.45)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: _iapTeal, size: 26),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Active Fenton Card ────────────────────────────────────────────────────────

const Color _fentonPurple = Color(0xFF7C4DFF);

class _FentonChartCard extends StatelessWidget {
  final VoidCallback onTap;
  const _FentonChartCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: const Border(
              left: BorderSide(color: _fentonPurple, width: 4),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: _fentonPurple,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.monitor_heart_outlined,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fenton Preterm Charts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text('22 to 50 weeks PMA',
                        style: TextStyle(
                            fontSize: 13,
                            color: cs.onSurface.withValues(alpha: 0.6))),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _Chip('Boys', const Color(0xFF1565C0)),
                        _Chip('Girls', const Color(0xFFAD1457)),
                        _Chip('Fenton 2025', _fentonPurple),
                        _Chip('Preterm', _fentonPurple),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Weight · Length · HC · SGA/AGA/LGA',
                      style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withValues(alpha: 0.45)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: _fentonPurple, size: 26),
            ],
          ),
        ),
      ),
    );
  }
}

// ── INTERGROWTH-21st Card ─────────────────────────────────────────────────────

const Color _intergrowthOxford = Color(0xFF00695C);

class _IntergrowthCard extends StatelessWidget {
  final VoidCallback onTap;
  const _IntergrowthCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: const Border(
              left: BorderSide(color: _intergrowthOxford, width: 4),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: _intergrowthOxford,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.open_in_browser,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INTERGROWTH-21st',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Neonatal Growth Charts — Oxford',
                      style: TextStyle(
                          fontSize: 13,
                          color: cs.onSurface.withValues(alpha: 0.6)),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _Chip('Preterm', _intergrowthOxford),
                        _Chip('Term NB', _intergrowthOxford),
                        _Chip('Oxford 2014', _intergrowthOxford),
                        _Chip('Web Tool', const Color(0xFF0277BD)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Weight · Length · HC · Fetal · Postnatal',
                      style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withValues(alpha: 0.45)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.open_in_new,
                  color: _intergrowthOxford, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Locked Card ───────────────────────────────────────────────────────────────

const Color _warningAmber = Color(0xFFF5A623);

class _LockedChartCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String ageRange;
  final List<String> chips;
  final String measurements;
  final VoidCallback onTap;

  const _LockedChartCard({
    required this.icon,
    required this.title,
    required this.ageRange,
    required this.chips,
    required this.measurements,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final disabledText = cs.onSurface.withValues(alpha: 0.4);
    final disabledBorder = cs.outline.withValues(alpha: 0.4);
    final disabledBg = cs.onSurface.withValues(alpha: 0.04);

    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border(
              left: BorderSide(color: disabledBorder, width: 4),
            ),
            color: disabledBg,
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon circle
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: disabledBorder,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: disabledText, size: 26),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: disabledText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(ageRange,
                        style: TextStyle(
                            fontSize: 13, color: disabledText)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: chips
                          .map((c) => _Chip(c, disabledText))
                          .toList(),
                    ),
                    if (measurements.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        measurements,
                        style: TextStyle(
                            fontSize: 12, color: disabledText),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline,
                      color: disabledText, size: 20),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: _warningAmber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: _warningAmber.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      'Coming\nSoon',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: _warningAmber),
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
}

// ── Small chip ────────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
