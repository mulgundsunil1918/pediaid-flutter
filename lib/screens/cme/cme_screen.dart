// =============================================================================
// lib/screens/cme/cme_screen.dart
//
// Backend-backed CME / webinar / conference browser. Replaces the old
// hardcoded PEDICON and NeoUpdate static cards. Fetches events from
// GET /api/academics/cme/events via CmeService and filters them into four
// tabs by eventType.
//
// The user's own submissions used to live in a fifth "My posts" tab here.
// They now live in MySubmissionsScreen, which covers Never Again posts too —
// reachable from the AppBar history icon when signed in.
//
// Floating action button: "+ Post event" → PostEventScreen. Every card
// taps through to CmeDetailScreen.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../../services/cme_service.dart';
import '../../widgets/cme_filter_bar.dart';
import 'widgets/cme_event_card.dart';
import 'post_event_screen.dart';
import 'cme_detail_screen.dart';
import '../submissions/my_submissions_screen.dart';

const List<_TabDef> _eventTypeTabs = [
  _TabDef('conference', 'Conferences', Icons.event_available_rounded),
  _TabDef('webinar', 'Webinars', Icons.videocam_rounded),
  _TabDef('workshop', 'Workshops', Icons.build_rounded),
  _TabDef('course', 'Courses', Icons.school_rounded),
];

class _TabDef {
  const _TabDef(this.eventType, this.label, this.icon);
  final String eventType;
  final String label;
  final IconData icon;
}

class CmeScreen extends StatefulWidget {
  const CmeScreen({super.key});

  @override
  State<CmeScreen> createState() => _CmeScreenState();
}

class _CmeScreenState extends State<CmeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Server-side filters. The event-type tabs still narrow client-side, but
  // these three go to the API so the app never has to hold every event in
  // memory in order to filter them.
  String? _stateFilter;
  String? _modeFilter;
  String _query = '';

  Future<List<CmeEvent>>? _publicFuture;

  bool get _isLoggedIn => AuthService.instance.isLoggedIn;

  @override
  void initState() {
    super.initState();
    // Fixed 4 tabs, one per event type. The old 5th "My posts" tab moved to
    // the global My Submissions screen, which also covers Never Again — so
    // the tab count no longer changes with sign-in state.
    _tabController = TabController(length: _eventTypeTabs.length, vsync: this);
    _refreshAll();
    AuthService.instance.addListener(_onAuthChange);
  }

  @override
  void dispose() {
    _tabController.dispose();
    AuthService.instance.removeListener(_onAuthChange);
    super.dispose();
  }

  void _onAuthChange() {
    if (!mounted) return;
    // Only the FAB depends on auth now; rebuild and refresh.
    _refreshAll();
  }

  void _refreshAll() {
    setState(() {
      _publicFuture = CmeService.instance.list(
        state: _stateFilter,
        mode: _modeFilter,
        query: _query,
      );
    });
  }

  void _openMySubmissions() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const MySubmissionsScreen()),
    );
  }

  Future<void> _openPostScreen() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const PostEventScreen()),
    );
    if (result == true) _refreshAll();
  }

  void _openDetail(CmeEvent event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CmeDetailScreen(
          slugOrId: event.slug.isNotEmpty ? event.slug : event.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CME & Webinars',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        actions: [
          // A labelled button, not a bare icon. A clock-arrow glyph does not
          // say "the things you submitted" to anyone who hasn't been told, and
          // the tooltip only appears on long-press — which nobody does when
          // they are looking for something.
          if (_isLoggedIn)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: _openMySubmissions,
                icon: const Icon(Icons.fact_check_outlined, size: 18),
                label: Text(
                  'My Submissions',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.16),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          tabs: [
            for (final t in _eventTypeTabs)
              Tab(
                icon: Icon(t.icon, size: 16, color: Colors.white),
                text: t.label,
                iconMargin: const EdgeInsets.only(bottom: 2),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (CmeService.instance.usingPreview)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: const Color(0xFFFFF3E0),
              child: Text(
                'Showing sample events — live listings will load once the server is back online.',
                style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: const Color(0xFFE65100)),
                textAlign: TextAlign.center,
              ),
            ),
          CmeFilterBar(
            state: _stateFilter,
            mode: _modeFilter,
            query: _query,
            onStateChanged: (v) {
              _stateFilter = v;
              _refreshAll();
            },
            onModeChanged: (v) {
              _modeFilter = v;
              _refreshAll();
            },
            onQueryChanged: (v) {
              _query = v;
              _refreshAll();
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                for (final t in _eventTypeTabs)
                  _PublicTab(
                    future: _publicFuture,
                    eventType: t.eventType,
                    onRefresh: () async => _refreshAll(),
                    onTap: _openDetail,
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _isLoggedIn
          ? FloatingActionButton.extended(
              onPressed: _openPostScreen,
              icon: const Icon(Icons.add_rounded),
              label: Text(
                'Post event',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: const Color(0xFFE53E3E),
              foregroundColor: Colors.white,
            )
          : null,
    );
  }
}

// ---------------------------------------------------------------------------
// Public tab — filtered by eventType from the cached future
// ---------------------------------------------------------------------------

class _PublicTab extends StatelessWidget {
  const _PublicTab({
    required this.future,
    required this.eventType,
    required this.onRefresh,
    required this.onTap,
  });

  final Future<List<CmeEvent>>? future;
  final String eventType;
  final Future<void> Function() onRefresh;
  final void Function(CmeEvent event) onTap;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CmeEvent>>(
      future: future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const _LoadingState();
        }
        if (snap.hasError) {
          // Never surface raw backend/infra errors to end users.
          return _ErrorState(
            message: 'Events couldn’t be loaded right now. '
                'Please check your connection and try again in a little while.',
            onRetry: onRefresh,
          );
        }
        final filtered =
            (snap.data ?? []).where((e) => e.eventType == eventType).toList();
        if (filtered.isEmpty) {
          return _EmptyState(eventType: eventType, onRefresh: onRefresh);
        }
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.builder(
            // Top padding removed — the card's own margin already separates it
            // from the filter bar. bottom clears the "Post event" FAB.
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: filtered.length,
            itemBuilder: (_, i) => CmeEventCard(
              event: filtered[i],
              onTap: () => onTap(filtered[i]),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Loading, error, empty states
// ---------------------------------------------------------------------------

class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (_, __) => Container(
        height: 240,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView(
      children: [
        const SizedBox(height: 60),
        Icon(Icons.cloud_off_rounded, size: 60, color: cs.error),
        const SizedBox(height: 12),
        Text(
          "Couldn't load events",
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: cs.onSurface.withValues(alpha: 0.6),
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: Text(
              'Try again',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.eventType, required this.onRefresh});
  final String eventType;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        children: [
          const SizedBox(height: 80),
          Icon(Icons.event_busy_outlined,
              size: 60, color: cs.onSurface.withValues(alpha: 0.2)),
          const SizedBox(height: 12),
          Text(
            'No ${eventType}s yet',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Check back later — or tap the Post event button to share one with the community.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                height: 1.5,
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
