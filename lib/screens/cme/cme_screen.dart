// =============================================================================
// lib/screens/cme/cme_screen.dart
//
// Backend-backed CME / webinar / conference browser. Replaces the old
// hardcoded PEDICON and NeoUpdate static cards. Fetches events from
// GET /api/academics/cme/events via CmeService and filters them into four
// tabs by eventType. When the user is signed in, a fifth "My posts" tab
// shows their own submissions (pending / published / rejected) with a
// status badge.
//
// Floating action button: "+ Post event" → PostEventScreen. Every card
// taps through to CmeDetailScreen.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../../services/cme_service.dart';
import '../../widgets/under_development_banner.dart';
import 'widgets/cme_event_card.dart';
import 'post_event_screen.dart';
import 'cme_detail_screen.dart';

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

  Future<List<CmeEvent>>? _publicFuture;
  Future<List<CmeEvent>>? _myFuture;

  bool get _isLoggedIn => AuthService.instance.isLoggedIn;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _eventTypeTabs.length + (_isLoggedIn ? 1 : 0),
      vsync: this,
    );
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
    final newLength = _eventTypeTabs.length + (_isLoggedIn ? 1 : 0);
    if (newLength != _tabController.length) {
      _tabController.dispose();
      setState(() {
        _tabController = TabController(length: newLength, vsync: this);
      });
    }
    _refreshAll();
  }

  void _refreshAll() {
    setState(() {
      _publicFuture = CmeService.instance.list();
      _myFuture = _isLoggedIn ? CmeService.instance.listMine() : null;
    });
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
    final hasMyTab = _isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CME & Webinars',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
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
            if (hasMyTab)
              const Tab(
                icon: Icon(Icons.person_outline_rounded,
                    size: 16, color: Colors.white),
                text: 'My posts',
                iconMargin: EdgeInsets.only(bottom: 2),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          const UnderDevelopmentBanner(
            message:
                'CME & Webinars is in preview — event listings, "My posts" submissions and admin moderation are still being wired up. Browse freely, but please don\'t rely on it for live registration deadlines yet.',
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
                if (hasMyTab)
                  _MyPostsTab(
                    future: _myFuture,
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
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
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
          return _ErrorState(
            message: snap.error?.toString() ?? 'Something went wrong.',
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
            padding: const EdgeInsets.only(top: 8, bottom: 100),
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
// My posts tab
// ---------------------------------------------------------------------------

class _MyPostsTab extends StatelessWidget {
  const _MyPostsTab({
    required this.future,
    required this.onRefresh,
    required this.onTap,
  });

  final Future<List<CmeEvent>>? future;
  final Future<void> Function() onRefresh;
  final void Function(CmeEvent event) onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FutureBuilder<List<CmeEvent>>(
      future: future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const _LoadingState();
        }
        if (snap.hasError) {
          return _ErrorState(
            message: snap.error?.toString() ?? 'Something went wrong.',
            onRetry: onRefresh,
          );
        }
        final mine = snap.data ?? [];
        if (mine.isEmpty) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              children: [
                const SizedBox(height: 80),
                Icon(Icons.post_add_rounded,
                    size: 60, color: cs.onSurface.withValues(alpha: 0.2)),
                const SizedBox(height: 12),
                Text(
                  "You haven't posted any events yet",
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
                    'Tap the Post event button to share a CME, webinar, workshop, or conference with the PediAid community.',
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
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 100),
            itemCount: mine.length,
            itemBuilder: (_, i) {
              final event = mine[i];
              return Stack(
                children: [
                  CmeEventCard(
                    event: event,
                    onTap: () => onTap(event),
                  ),
                  Positioned(
                    top: 20,
                    right: 28,
                    child: _StatusBadge(status: event.status),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'published' => ('PUBLISHED', const Color(0xFF16A34A)),
      'pending' => ('PENDING REVIEW', const Color(0xFFF59E0B)),
      'rejected' => ('REJECTED', const Color(0xFFDC2626)),
      'cancelled' => ('CANCELLED', const Color(0xFF6B7280)),
      _ => (status.toUpperCase(), const Color(0xFF6B7280)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
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
