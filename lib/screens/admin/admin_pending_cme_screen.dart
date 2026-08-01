// =============================================================================
// lib/screens/admin/admin_pending_cme_screen.dart
//
// Admin-only list of user-submitted CMEs / webinars / conferences awaiting
// review. Each row has Approve + Reject buttons. Rejecting prompts for a
// reason (min 5 chars) which is passed to the backend and emailed to the
// poster.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/admin_service.dart';
import '../../services/cme_service.dart';
import '../cme/widgets/cme_event_card.dart';

class AdminPendingCmeScreen extends StatefulWidget {
  const AdminPendingCmeScreen({super.key});

  @override
  State<AdminPendingCmeScreen> createState() => _AdminPendingCmeScreenState();
}

class _AdminPendingCmeScreenState extends State<AdminPendingCmeScreen> {
  Future<List<CmeEvent>>? _future;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _future = AdminService.instance.listPendingCmeEvents();
    });
  }

  Future<void> _approve(CmeEvent event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Approve event?',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          '"${event.title}" will be published and visible to every PediAid user. The poster will receive an email and in-app notification.',
          style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await AdminService.instance.approveCmeEvent(event.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Approved "${event.title}"')),
      );
      _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Approval failed: $e')),
      );
    }
  }

  Future<String?> _promptReason({
    required String title,
    required String helperText,
    required String confirmLabel,
    required Color confirmColor,
  }) {
    return showDialog<String>(
      context: context,
      builder: (ctx) {
        final ctl = TextEditingController();
        return AlertDialog(
          title: Text(
            title,
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                helperText,
                style: GoogleFonts.plusJakartaSans(fontSize: 12.5, height: 1.5),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctl,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'e.g. The brochure link is broken and the date…',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: confirmColor),
              onPressed: () {
                if (ctl.text.trim().length < 5) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                      content: Text('Reason must be at least 5 characters.'),
                    ),
                  );
                  return;
                }
                Navigator.pop(ctx, ctl.text.trim());
              },
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );
  }

  Future<void> _reject(CmeEvent event) async {
    final reason = await _promptReason(
      title: 'Reject event',
      helperText:
          'Tell the poster why their event wasn\'t approved. They will see this in their email and inside the app.',
      confirmLabel: 'Reject',
      confirmColor: Colors.red,
    );
    if (reason == null) return;

    try {
      await AdminService.instance.rejectCmeEvent(event.id, reason);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rejected "${event.title}"')),
      );
      _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rejection failed: $e')),
      );
    }
  }

  Future<void> _requestChanges(CmeEvent event) async {
    final reason = await _promptReason(
      title: 'Request changes',
      helperText:
          'The event goes back to the poster with your note — they can edit and resubmit without losing their place in the queue.',
      confirmLabel: 'Send back for changes',
      confirmColor: const Color(0xFFD69E2E),
    );
    if (reason == null) return;

    try {
      await AdminService.instance.requestCmeEventChanges(event.id, reason);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sent "${event.title}" back for changes')),
      );
      _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request changes failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pending CMEs',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refresh(),
        child: FutureBuilder<List<CmeEvent>>(
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
                    'No events waiting for review',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'You\'re all caught up.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: cs.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 40),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final event = items[i];
                return Column(
                  children: [
                    CmeEventCard(event: event),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => _requestChanges(event),
                              icon: const Icon(Icons.edit_note_rounded, size: 18),
                              label: Text(
                                'Request changes',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFB45309),
                                side: const BorderSide(color: Color(0xFFD69E2E)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _reject(event),
                                  icon: const Icon(Icons.close_rounded, size: 18),
                                  label: Text(
                                    'Reject',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: () => _approve(event),
                                  icon: const Icon(Icons.check_rounded, size: 18),
                                  label: Text(
                                    'Approve',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF16A34A),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
