// =============================================================================
// lib/screens/submissions/my_submissions_screen.dart
//
// One place for everything the user has submitted, across Never Again and all
// four CME event types. Supersedes the two separate per-module views that
// used to exist (_MySubmissionsSheet in never_again_screen.dart and the
// "My posts" tab in cme_screen.dart).
//
// Visual style follows the Never Again submission cards it replaces:
// cardColor container, onSurface 0.1 border, 12px radius, Plus Jakarta Sans.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../services/submissions_service.dart';
import 'package:share_plus/share_plus.dart';

class MySubmissionsScreen extends StatefulWidget {
  const MySubmissionsScreen({super.key});

  @override
  State<MySubmissionsScreen> createState() => _MySubmissionsScreenState();
}

class _MySubmissionsScreenState extends State<MySubmissionsScreen> {
  late Future<List<Submission>> _future;
  SubmissionStatus? _filter;

  @override
  void initState() {
    super.initState();
    _future = SubmissionsService.instance.getMySubmissions();
  }

  void _reload() {
    setState(() {
      _future = SubmissionsService.instance.getMySubmissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Submissions',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: _reload,
          ),
        ],
      ),
      body: FutureBuilder<List<Submission>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          }

          if (snap.hasError) {
            return _Message(
              icon: Icons.cloud_off_rounded,
              title: "Couldn't load your submissions",
              body: 'Check your connection and try again.',
              action: TextButton(
                onPressed: _reload,
                child: const Text('Retry'),
              ),
            );
          }

          final all = snap.data ?? [];
          if (all.isEmpty) {
            return const _Message(
              icon: Icons.inbox_rounded,
              title: 'Nothing submitted yet',
              body:
                  'Anything you share in Never Again, or any event you post to '
                  'CME, will show up here with its review status.',
            );
          }

          final visible = _filter == null
              ? all
              : all.where((s) => s.status == _filter).toList();

          // Only offer filters the user actually has submissions for —
          // a fixed 8-chip row would be mostly dead options.
          final present = <SubmissionStatus>{
            for (final s in all) s.status,
          }.toList()..sort((a, b) => a.index.compareTo(b.index));

          return Column(
            children: [
              if (present.length > 1)
                _FilterRow(
                  statuses: present,
                  selected: _filter,
                  onSelect: (s) => setState(() => _filter = s),
                ),
              Expanded(
                child: visible.isEmpty
                    ? const _Message(
                        icon: Icons.filter_alt_off_rounded,
                        title: 'Nothing in this filter',
                        body: 'Try a different status above.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        itemCount: visible.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (_, i) =>
                            _SubmissionCard(item: visible[i]),
                      ),
              ),
            ],
          );
        },
      ),
      backgroundColor: cs.surface,
    );
  }
}

// ── Filter chips ──────────────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.statuses,
    required this.selected,
    required this.onSelect,
  });

  final List<SubmissionStatus> statuses;
  final SubmissionStatus? selected;
  final ValueChanged<SubmissionStatus?> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        children: [
          _Chip(
            label: 'All',
            selected: selected == null,
            onTap: () => onSelect(null),
          ),
          for (final s in statuses) ...[
            const SizedBox(width: 8),
            _Chip(
              label: submissionStatusLabel(s),
              selected: selected == s,
              onTap: () => onSelect(s),
            ),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? cs.primary : cs.onSurface.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected
                ? cs.onPrimary
                : cs.onSurface.withValues(alpha: 0.65),
          ),
        ),
      ),
    );
  }
}

// ── Submission card ───────────────────────────────────────────────────────────

class _SubmissionCard extends StatelessWidget {
  const _SubmissionCard({required this.item});
  final Submission item;

  (String, Color) get _statusMeta => switch (item.status) {
    SubmissionStatus.published => ('LIVE', const Color(0xFF2E7D32)),
    SubmissionStatus.approved => ('APPROVED', const Color(0xFF2E7D32)),
    SubmissionStatus.rejected => ('NOT APPROVED', const Color(0xFFC62828)),
    SubmissionStatus.needsEdit => ('NEEDS CHANGES', const Color(0xFFEF6C00)),
    SubmissionStatus.underReview => ('UNDER REVIEW', const Color(0xFF1565C0)),
    SubmissionStatus.archived => ('ARCHIVED', const Color(0xFF546E7A)),
    SubmissionStatus.draft => ('DRAFT', const Color(0xFF546E7A)),
    SubmissionStatus.submitted => ('UNDER REVIEW', const Color(0xFFF9A825)),
  };

  /// Share text for an approved submission.
  ///
  /// Carries the reference code with the details rather than only a link: the
  /// code is what identifies this entry in any later query, and a link alone
  /// leaves the person sharing it unable to say which submission they mean.
  void _share(Submission item) {
    final buf = StringBuffer()
      ..writeln(item.title)
      ..writeln()
      ..writeln('${submissionModuleLabel(item.module)} on PediAid')
      ..writeln('PediAid ID no.: ${item.referenceCode}');
    // No link — Academics is kept off public surfaces, and the PediAid ID
    // is what identifies this submission.
    Share.share(buf.toString().trim(), subject: item.title);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (label, color) = _statusMeta;
    final feedback = item.adminFeedback;
    final showFeedback =
        feedback != null &&
        feedback.trim().isNotEmpty &&
        (item.status == SubmissionStatus.needsEdit ||
            item.status == SubmissionStatus.rejected);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  submissionModuleLabel(item.module),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
              Text(
                timeago.format(item.createdAt, locale: 'en_short'),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: cs.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              height: 1.45,
              color: cs.onSurface.withValues(alpha: 0.85),
            ),
          ),
          // Reference code plus a share action, once there is something to
          // share. The code is the only handle a submitter has on their entry —
          // it is what they quote in a query — so it is selectable, and the
          // share text carries it alongside the details rather than leaving
          // someone to copy it out separately.
          if (item.referenceCode != null && item.referenceCode!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.tag_rounded,
                  size: 14,
                  color: cs.onSurface.withValues(alpha: 0.45),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: SelectableText(
                    item.referenceCode!,
                    style: GoogleFonts.robotoMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                if (item.status == SubmissionStatus.published)
                  TextButton.icon(
                    onPressed: () => _share(item),
                    icon: const Icon(Icons.share_rounded, size: 15),
                    label: Text(
                      'Share',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
              ],
            ),
          ],
          if (showFeedback) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.07),
                border: Border.all(color: color.withValues(alpha: 0.25)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'REVIEWER FEEDBACK',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: color,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feedback.trim(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      height: 1.45,
                      color: cs.onSurface.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Empty / error state ───────────────────────────────────────────────────────

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: cs.onSurface.withValues(alpha: 0.25)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: cs.onSurface.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.5,
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
            if (action != null) ...[const SizedBox(height: 12), action!],
          ],
        ),
      ),
    );
  }
}
