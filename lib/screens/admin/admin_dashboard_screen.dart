// =============================================================================
// lib/screens/admin/admin_dashboard_screen.dart
//
// The admin-only entry point. Reached from the red "Admin" tile at the bottom
// of the home screen, shown only when the logged-in user has role='admin'.
//
// Shows three summary cards (CMEs pending / Chapters pending / Role requests)
// and taps through to the dedicated pending list screens where individual
// items can be approved or rejected.
// =============================================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../../services/admin_service.dart';
import 'admin_pending_cme_screen.dart';
import 'admin_pending_chapters_screen.dart';
import 'admin_pending_roles_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  Future<AdminSummaryCounts>? _future;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _refresh();
    // Auto-refresh every 60s while the dashboard is visible so new
    // submissions light up without a manual pull-to-refresh.
    _pollTimer = Timer.periodic(const Duration(seconds: 60), (_) => _refresh());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _refresh() {
    setState(() {
      _future = AdminService.instance.getSummaryCounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final user = AuthService.instance.currentUser;
    final isAdmin = user?.role == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _refresh,
          ),
        ],
      ),
      body: !isAdmin
          ? _AccessDenied()
          : RefreshIndicator(
              onRefresh: () async => _refresh(),
              child: FutureBuilder<AdminSummaryCounts>(
                future: _future,
                builder: (context, snap) {
                  final counts = snap.data;
                  return ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Greeting
                      Text(
                        'Welcome, Admin',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: cs.onSurface.withValues(alpha: 0.65),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Total pending banner
                      _TotalBanner(
                        total: counts?.total ?? 0,
                        loading: snap.connectionState ==
                                ConnectionState.waiting &&
                            counts == null,
                        hasError: snap.hasError,
                      ),
                      const SizedBox(height: 18),

                      // Section header
                      Text(
                        'Pending reviews',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface.withValues(alpha: 0.85),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _SummaryCard(
                        icon: Icons.event_available_rounded,
                        color: const Color(0xFF2563EB),
                        title: 'CMEs, Webinars & Events',
                        subtitle:
                            'User-posted events waiting for your approval',
                        count: counts?.cmesPending,
                        loading: counts == null,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AdminPendingCmeScreen(),
                            ),
                          );
                          _refresh();
                        },
                      ),
                      const SizedBox(height: 10),
                      _SummaryCard(
                        icon: Icons.auto_stories_rounded,
                        color: const Color(0xFF7C3AED),
                        title: 'Topic Chapters',
                        subtitle: 'Guides submitted for peer review',
                        count: counts?.chaptersPending,
                        loading: counts == null,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AdminPendingChaptersScreen(),
                            ),
                          );
                          _refresh();
                        },
                      ),
                      const SizedBox(height: 10),
                      _SummaryCard(
                        icon: Icons.person_add_alt_1_rounded,
                        color: const Color(0xFF059669),
                        title: 'Role Requests',
                        subtitle: 'Author / moderator applications',
                        count: counts?.roleRequestsPending,
                        loading: counts == null,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AdminPendingRolesScreen(),
                            ),
                          );
                          _refresh();
                        },
                      ),
                      const SizedBox(height: 18),
                      if (snap.hasError)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cs.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Failed to load counts: ${snap.error}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: cs.onErrorContainer,
                            ),
                          ),
                        ),
                      const SizedBox(height: 40),
                    ],
                  );
                },
              ),
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Total pending banner at the top of the dashboard
// ---------------------------------------------------------------------------

class _TotalBanner extends StatelessWidget {
  const _TotalBanner({
    required this.total,
    required this.loading,
    required this.hasError,
  });
  final int total;
  final bool loading;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30DC2626),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loading
                      ? 'Loading…'
                      : hasError
                          ? '—'
                          : '$total pending',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  total == 0 && !loading && !hasError
                      ? 'All caught up — nothing waiting for you.'
                      : 'Items waiting for your review',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Summary card — icon + title + count badge
// ---------------------------------------------------------------------------

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.loading,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final int? count;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (loading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: (count ?? 0) > 0 ? color : cs.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${count ?? 0}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurface.withValues(alpha: 0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccessDenied extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline_rounded, size: 64, color: cs.error),
            const SizedBox(height: 12),
            Text(
              'Admin access only',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'You need an admin account to view this page.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
