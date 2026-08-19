// =============================================================================
// widgets/skeleton.dart
//
// Shimmer placeholders shown while a screen's data loads.
//
// A bare CircularProgressIndicator says "something is happening" but nothing
// about what. A skeleton in the shape of the list that is coming makes the
// wait feel shorter and stops the layout jumping when the data lands, because
// the placeholder already occupies roughly the right space.
//
// Deliberately dependency-free — no `shimmer` package — so it themes from
// ColorScheme and cannot drift from the rest of the app in dark mode.
// =============================================================================

import 'package:flutter/material.dart';

/// A single shimmering block. Use directly for bespoke placeholder shapes.
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 14,
    this.radius = 6,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    // Dark mode needs a LIGHTER pulse on a dark ground; reusing the light-mode
    // alphas would make the skeleton invisible.
    final base = cs.onSurface.withValues(alpha: dark ? 0.06 : 0.07);
    final high = cs.onSurface.withValues(alpha: dark ? 0.14 : 0.13);

    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Color.lerp(base, high, _c.value),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

/// Placeholder for a list of cards — the shape most screens in this app load
/// into (a leading badge, a title line and a shorter subtitle line).
class SkeletonList extends StatelessWidget {
  const SkeletonList({
    super.key,
    this.items = 7,
    this.showLeading = true,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 24),
  });

  final int items;
  final bool showLeading;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView.separated(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outline.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            if (showLeading) ...[
              const SkeletonBox(width: 30, height: 30, radius: 9),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Varying widths read as text, not as a stack of identical bars.
                  SkeletonBox(width: i.isEven ? 190 : 150, height: 13),
                  const SizedBox(height: 8),
                  SkeletonBox(width: i.isEven ? 110 : 138, height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
