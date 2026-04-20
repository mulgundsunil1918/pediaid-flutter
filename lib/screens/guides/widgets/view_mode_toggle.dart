// =============================================================================
// lib/screens/guides/widgets/view_mode_toggle.dart
//
// Shared Smart / Table segmented toggle used by the GA and Birthweight
// Classification screens.
//   - Smart view  → live classifier + only the matching card(s) highlighted
//   - Table view  → full reference table, static
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ViewModeChoice { smart, table }

class ViewModeToggle extends StatelessWidget {
  const ViewModeToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ViewModeChoice value;
  final ValueChanged<ViewModeChoice> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _segment(
            context,
            label: 'Smart View',
            icon: Icons.auto_awesome_rounded,
            active: value == ViewModeChoice.smart,
            onTap: () => onChanged(ViewModeChoice.smart),
          ),
          _segment(
            context,
            label: 'Table View',
            icon: Icons.table_rows_rounded,
            active: value == ViewModeChoice.table,
            onTap: () => onChanged(ViewModeChoice.table),
          ),
        ],
      ),
    );
  }

  Widget _segment(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: active ? cs.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: active
                    ? Colors.white
                    : cs.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: active
                      ? Colors.white
                      : cs.onSurface.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
