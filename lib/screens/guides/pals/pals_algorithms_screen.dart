import 'package:flutter/material.dart';
import 'pals_pdf_viewer.dart';

// ── Algorithm list ─────────────────────────────────────────────────────────────

class _Algorithm {
  final String name;
  final int page; // 1-based
  const _Algorithm(this.name, this.page);
}

const List<_Algorithm> _algorithms = [
  _Algorithm('Pediatric Cardiac Arrest',             1),
  _Algorithm('Bradycardia with Pulse',               2),
  _Algorithm('Tachycardia with Pulse',               3),
  _Algorithm('Septic Shock',                         4),
  _Algorithm('Management of Shock After ROSC',       5),
  _Algorithm('Length-Based Resuscitation',           6),
  _Algorithm('PALS Systematic Approach',             7),
  _Algorithm('Post-Cardiac Arrest Care',             8),
  _Algorithm('Child Foreign Body Airway Obstruction',9),
  _Algorithm('Infant Foreign Body Airway Obstruction',10),
];

// ── Screen ─────────────────────────────────────────────────────────────────────

class PalsAlgorithmsScreen extends StatelessWidget {
  const PalsAlgorithmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PALS Algorithms'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header banner ───────────────────────────────────────────
            Container(
              margin: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
              ),
              child: Text(
                'Pediatric Advanced Life Support — tap any algorithm to open '
                'it directly in the PDF viewer.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: cs.onSurface.withValues(alpha: 0.6),
                  height: 1.45,
                ),
              ),
            ),

            // ── List ────────────────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                itemCount: _algorithms.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, i) {
                  final algo = _algorithms[i];
                  return _AlgoTile(
                    algo: algo,
                    index: i,
                    cs: cs,
                    isDark: isDark,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PalsPdfViewer(
                          title: algo.name,
                          initialPage: algo.page - 1, // 0-based for PDFView
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Algorithm tile ─────────────────────────────────────────────────────────────

class _AlgoTile extends StatelessWidget {
  final _Algorithm algo;
  final int index;
  final ColorScheme cs;
  final bool isDark;
  final VoidCallback onTap;

  const _AlgoTile({
    required this.algo,
    required this.index,
    required this.cs,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      elevation: isDark ? 0 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: cs.primary.withValues(alpha: 0.5),
                width: 3,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Page badge
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${algo.page}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: cs.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Algorithm name
              Expanded(
                child: Text(
                  algo.name,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface,
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(width: 8),
              Icon(
                Icons.picture_as_pdf_outlined,
                size: 18,
                color: cs.onSurface.withValues(alpha: 0.35),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: cs.onSurface.withValues(alpha: 0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
