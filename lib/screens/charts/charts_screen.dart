import 'package:flutter/material.dart';
import 'growth_charts_screen.dart';

const Color _warningAmber = Color(0xFFF5A623);

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Charts'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            // ── Growth Charts (active) ─────────────────────────────────────
            _ChartCategoryCard(
              icon: Icons.show_chart,
              iconBg: cs.primary,
              title: 'Growth Charts',
              subtitle: 'WHO · IAP · Fenton · Reference charts',
              disabled: false,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GrowthChartsScreen()),
              ),
            ),
            const SizedBox(height: 14),
            // ── Other Charts (coming soon) ─────────────────────────────────
            _ChartCategoryCard(
              icon: Icons.bar_chart,
              iconBg: Colors.grey,
              title: 'Other Charts',
              subtitle: 'Bilirubin · Blood Pressure · More',
              disabled: true,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Other Charts — Coming Soon'),
                  backgroundColor: cs.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartCategoryCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool disabled;
  final VoidCallback onTap;

  const _ChartCategoryCard({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final Color titleColor = disabled
        ? cs.onSurface.withValues(alpha: 0.4)
        : cs.onSurface;
    final Color subtitleColor = disabled
        ? cs.onSurface.withValues(alpha: 0.3)
        : cs.onSurface.withValues(alpha: 0.6);
    final Color borderColor = disabled
        ? cs.outline.withValues(alpha: 0.4)
        : cs.primary.withValues(alpha: 0.5);

    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      elevation: disabled ? 0 : 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBg.withValues(alpha: disabled ? 0.12 : 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon,
                    color: disabled
                        ? cs.onSurface.withValues(alpha: 0.3)
                        : iconBg,
                    size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: titleColor)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style:
                            TextStyle(fontSize: 13, color: subtitleColor)),
                  ],
                ),
              ),
              if (disabled)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline,
                        color: cs.onSurface.withValues(alpha: 0.3), size: 20),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: _warningAmber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: _warningAmber.withValues(alpha: 0.4)),
                      ),
                      child: Text('Coming Soon',
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: _warningAmber)),
                    ),
                  ],
                )
              else
                Icon(Icons.chevron_right,
                    color: cs.primary.withValues(alpha: 0.7), size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
