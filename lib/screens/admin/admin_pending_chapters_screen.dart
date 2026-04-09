// =============================================================================
// lib/screens/admin/admin_pending_chapters_screen.dart
//
// Lists chapter submissions currently in the moderation queue. Tapping a
// row opens the React academics review page in a web view (the editor is a
// rich text experience and duplicating it in Flutter is out of scope). The
// approve/reject actions still happen on the web page — this Flutter
// screen is a discovery surface so the admin can see the queue length and
// jump to the right place.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/admin_service.dart';

class AdminPendingChaptersScreen extends StatefulWidget {
  const AdminPendingChaptersScreen({super.key});

  @override
  State<AdminPendingChaptersScreen> createState() =>
      _AdminPendingChaptersScreenState();
}

class _AdminPendingChaptersScreenState
    extends State<AdminPendingChaptersScreen> {
  Future<List<PendingChapterSubmission>>? _future;

  static const String _reviewBaseUrl =
      'https://mulgundsunil1918.github.io/pediaid-frontend/academics/moderation';

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _future = AdminService.instance.listPendingChapters();
    });
  }

  Future<void> _openReview(PendingChapterSubmission chapter) async {
    final url = Uri.parse(
      '$_reviewBaseUrl/${chapter.slug.isEmpty ? chapter.id : chapter.slug}',
    );
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Couldn't open the review page."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pending Chapters',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refresh(),
        child: FutureBuilder<List<PendingChapterSubmission>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return ListView(
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Failed to load: ${snap.error}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(color: cs.error),
                      ),
                    ),
                  ),
                ],
              );
            }
            final items = snap.data ?? [];
            if (items.isEmpty) {
              return ListView(
                children: [
                  const SizedBox(height: 120),
                  Icon(Icons.check_circle_outline_rounded,
                      size: 64, color: cs.onSurface.withValues(alpha: 0.25)),
                  const SizedBox(height: 12),
                  Text(
                    'No chapters waiting for review',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final ch = items[i];
                return Container(
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ch.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${ch.authorName ?? 'Unknown author'}${ch.authorEmail != null ? ' · ${ch.authorEmail}' : ''}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: cs.onSurface.withValues(alpha: 0.65),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FilledButton.icon(
                            onPressed: () => _openReview(ch),
                            icon: const Icon(Icons.open_in_new_rounded,
                                size: 16),
                            label: Text(
                              'Open to review',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
