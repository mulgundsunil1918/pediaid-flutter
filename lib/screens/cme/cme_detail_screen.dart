// =============================================================================
// lib/screens/cme/cme_detail_screen.dart
//
// Full-page detail view for a single CME event. Fetches GET /cme/events/:slug
// and renders the existing CmeEventCard body (without the list ListView
// constraint) so the detail and list cards look identical. Adds a rejection
// banner for the owner if the event was rejected.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/cme_service.dart';
import 'widgets/cme_event_card.dart';

class CmeDetailScreen extends StatefulWidget {
  const CmeDetailScreen({super.key, required this.slugOrId});
  final String slugOrId;

  @override
  State<CmeDetailScreen> createState() => _CmeDetailScreenState();
}

class _CmeDetailScreenState extends State<CmeDetailScreen> {
  late Future<CmeEvent> _future;

  @override
  void initState() {
    super.initState();
    _future = CmeService.instance.getBySlug(widget.slugOrId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Event details',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: FutureBuilder<CmeEvent>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || !snap.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  snap.error?.toString() ?? 'Event not found.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            );
          }
          final event = snap.data!;
          return ListView(
            children: [
              if (event.status == 'rejected' &&
                  event.rejectionReason != null &&
                  event.rejectionReason!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.cancel_rounded,
                          size: 18, color: Colors.red.shade700),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'This event was not approved',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.red.shade900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event.rejectionReason!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: Colors.red.shade900,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (event.status == 'pending')
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.amber.shade300),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.schedule_rounded,
                          size: 18, color: Colors.amber.shade800),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'This event is awaiting admin review. Once approved, it will appear in the public CME list.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: Colors.amber.shade900,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              CmeEventCard(event: event),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }
}
