import 'package:flutter/material.dart';
import '../../services/lab_reference_service.dart';
import 'lab_item_detail_screen.dart';

class LabSystemScreen extends StatelessWidget {
  final LabSystem system;
  final LabReferenceService service;
  final Color accent;
  final IconData icon;

  const LabSystemScreen({
    super.key,
    required this.system,
    required this.service,
    required this.accent,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasLabs = system.labs.isNotEmpty;
    final hasGuides = system.guides.isNotEmpty;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: cs.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          system.name,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Labs ──────────────────────────────────────────────────────────
          if (hasLabs) ...[
            _SectionHeader(
              icon: Icons.science_outlined,
              label: 'Reference Labs',
              accent: accent,
            ),
            const SizedBox(height: 8),
            ...system.labs.map(
              (lab) => _ItemTile(
                name: lab,
                isGuide: false,
                hasData: service.hasData(lab),
                accent: accent,
                onTap: () => _navigate(context, lab),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // ── Guides ────────────────────────────────────────────────────────
          if (hasGuides) ...[
            _SectionHeader(
              icon: Icons.article_outlined,
              label: 'Clinical Guides & Tables',
              accent: accent,
            ),
            const SizedBox(height: 8),
            ...system.guides.map(
              (guide) => _ItemTile(
                name: guide,
                isGuide: true,
                hasData: service.hasData(guide),
                accent: accent,
                onTap: () => _navigate(context, guide),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // ── Footer ────────────────────────────────────────────────────────
          _buildFooter(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, String itemName) {
    final table = service.getTable(itemName);
    if (table == null) return; // Coming Soon — not tappable
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LabItemDetailScreen(itemName: itemName, table: table),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(Icons.menu_book_outlined, size: 16, color: cs.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Reference: Harriet Lane Handbook, 22nd Edition',
              style: TextStyle(
                  fontSize: 12, color: cs.onSurface.withValues(alpha: 0.65)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;

  const _SectionHeader(
      {required this.icon, required this.label, required this.accent});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, color: accent, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: cs.onSurface),
        ),
      ],
    );
  }
}

// ── Item tile ─────────────────────────────────────────────────────────────────

class _ItemTile extends StatelessWidget {
  final String name;
  final bool isGuide;
  final bool hasData;
  final Color accent;
  final VoidCallback onTap;

  const _ItemTile({
    required this.name,
    required this.isGuide,
    required this.hasData,
    required this.accent,
    required this.onTap,
  });

  static String _displayName(String n) =>
      n.replaceFirst(RegExp(r'^TABLE\s+[\d.]+:\s*', caseSensitive: false), '');

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dim = !hasData;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: dim ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Leading icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: dim
                        ? cs.onSurface.withValues(alpha: 0.05)
                        : accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    dim
                        ? Icons.lock_outline
                        : (isGuide
                            ? Icons.article_outlined
                            : Icons.science_outlined),
                    color: dim ? cs.onSurface.withValues(alpha: 0.3) : accent,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                // Name + Coming Soon
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _displayName(name),
                        style: TextStyle(
                          color: dim
                              ? cs.onSurface.withValues(alpha: 0.38)
                              : cs.onSurface,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      if (dim)
                        Text(
                          'Coming Soon',
                          style: TextStyle(
                            fontSize: 10,
                            color: cs.onSurface.withValues(alpha: 0.3),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
                // Trailing
                if (!dim)
                  Icon(Icons.chevron_right,
                      color: cs.onSurface.withValues(alpha: 0.35), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
