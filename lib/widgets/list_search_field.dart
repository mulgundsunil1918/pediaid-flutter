// =============================================================================
// widgets/list_search_field.dart
//
// The single search box used by every browse list in the app.
//
// Sunil's rule: any screen with more than ~8 items gets a search bar. Each
// screen previously would have hand-rolled its own TextField, which is how the
// app ended up with three visually different filter rows. This is the one
// implementation — themed from ColorScheme so it is correct in light and dark
// without any per-screen colour work.
// =============================================================================

import 'package:flutter/material.dart';

class ListSearchField extends StatelessWidget {
  const ListSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.padding = const EdgeInsets.fromLTRB(16, 10, 16, 4),
  });

  final TextEditingController controller;

  /// Say what is being searched and how much of it, e.g.
  /// 'Search 24 analytes…' — a bare 'Search…' hides the size of the list.
  final String hintText;

  final ValueChanged<String> onChanged;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasText = controller.text.isNotEmpty;

    OutlineInputBorder border(Color c, [double w = 1.0]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: c, width: w),
        );

    return Padding(
      padding: padding,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: TextStyle(fontSize: 14, color: cs.onSurface),
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: 13.5, color: cs.onSurface.withValues(alpha: 0.45)),
          prefixIcon: Icon(Icons.search,
              size: 20, color: cs.onSurface.withValues(alpha: 0.5)),
          suffixIcon: !hasText
              ? null
              : IconButton(
                  icon: Icon(Icons.close,
                      size: 18, color: cs.onSurface.withValues(alpha: 0.6)),
                  tooltip: 'Clear',
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: border(cs.outline.withValues(alpha: 0.35)),
          enabledBorder: border(cs.outline.withValues(alpha: 0.35)),
          focusedBorder: border(cs.primary, 1.4),
        ),
      ),
    );
  }
}

/// Shown in place of the list when a query matches nothing. Repeats the query
/// back so it is obvious the list is filtered rather than empty.
class ListSearchEmptyState extends StatelessWidget {
  const ListSearchEmptyState({
    super.key,
    required this.query,
    required this.noun,
  });

  final String query;

  /// Plural noun for what was searched, e.g. 'analytes', 'resources'.
  final String noun;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                size: 40, color: cs.onSurface.withValues(alpha: 0.3)),
            const SizedBox(height: 12),
            Text(
              'No $noun match "$query".',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13.5, color: cs.onSurface.withValues(alpha: 0.55)),
            ),
          ],
        ),
      ),
    );
  }
}
