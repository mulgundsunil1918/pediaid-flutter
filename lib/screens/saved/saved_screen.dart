// =============================================================================
// lib/screens/saved/saved_screen.dart
//
// Everything saved, from the same account as the web app. Filterable by type
// and by the tag the user gave it, and every row can be removed from here — a
// saved list you cannot prune stops being things you care about and becomes
// things you once tapped.
//
// Type chips are built from what is actually saved, so nobody is offered a
// filter that leads to an empty list.
// =============================================================================

import 'package:flutter/material.dart';
import '../../services/bookmarks_service.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  late Future<BookmarksResult> _future;
  String _type = 'all';
  String _tag = 'all';

  @override
  void initState() {
    super.initState();
    _future = BookmarksService.instance.getSaved();
  }

  void _reload() {
    setState(() {
      _future = BookmarksService.instance.getSaved();
    });
  }

  Future<void> _remove(Bookmark b) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await BookmarksService.instance.remove(b.itemType, b.itemId);
      _reload();
      messenger.showSnackBar(
        SnackBar(content: Text('Removed "${b.title}"')),
      );
    } catch (e) {
      // Say what went wrong. A silent failure here reads as a broken button.
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved')),
      body: FutureBuilder<BookmarksResult>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.error is NotSignedInException) {
            return _Message(
              icon: Icons.bookmark_border,
              title: 'Sign in to see your saved items',
              body: 'Saved items are tied to your account, so they follow you '
                  'to any device you sign in on.',
            );
          }
          if (snap.hasError) {
            return _Message(
              icon: Icons.error_outline,
              title: 'Could not load your saved items',
              body: snap.error.toString().replaceFirst('Exception: ', ''),
              onRetry: _reload,
            );
          }

          final result = snap.data!;
          final all = result.bookmarks;
          if (all.isEmpty) {
            return const _Message(
              icon: Icons.bookmark_border,
              title: 'Nothing saved yet',
              body: 'Tap the bookmark icon on a trial, guide or event to keep '
                  'it here.',
            );
          }

          final types = <String>{for (final b in all) b.itemType}.toList()..sort();
          final visible = all
              .where((b) =>
                  (_type == 'all' || b.itemType == _type) &&
                  (_tag == 'all' || b.tag == _tag))
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ChipRow(
                values: ['all', ...types],
                selected: _type,
                labelFor: (v) => v == 'all'
                    ? 'All'
                    : all.firstWhere((b) => b.itemType == v).typeLabel,
                onSelect: (v) => setState(() => _type = v),
              ),
              if (result.tags.isNotEmpty)
                _ChipRow(
                  values: ['all', ...result.tags],
                  selected: _tag,
                  labelFor: (v) => v == 'all' ? 'Any tag' : v,
                  onSelect: (v) => setState(() => _tag = v),
                ),
              Expanded(
                child: visible.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text('Nothing matches this filter.'),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: visible.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, i) =>
                            _SavedCard(b: visible[i], onRemove: () => _remove(visible[i])),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({
    required this.values,
    required this.selected,
    required this.labelFor,
    required this.onSelect,
  });

  final List<String> values;
  final String selected;
  final String Function(String) labelFor;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          for (final v in values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(labelFor(v)),
                selected: selected == v,
                onSelected: (_) => onSelect(v),
              ),
            ),
        ],
      ),
    );
  }
}

class _SavedCard extends StatelessWidget {
  const _SavedCard({required this.b, required this.onRemove});

  final Bookmark b;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _Pill(text: b.typeLabel, color: theme.colorScheme.primary),
                    if (b.tag != null && b.tag!.isNotEmpty)
                      _Pill(text: b.tag!, color: theme.colorScheme.secondary),
                  ],
                ),
                const SizedBox(height: 6),
                Text(b.title,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                if (b.subtitle != null && b.subtitle!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(b.subtitle!, style: theme.textTheme.bodySmall),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            tooltip: 'Remove from saved',
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    required this.body,
    this.onRetry,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: theme.disabledColor),
            const SizedBox(height: 14),
            Text(title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(body, textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onRetry, child: const Text('Try again')),
            ],
          ],
        ),
      ),
    );
  }
}
