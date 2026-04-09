// =============================================================================
// lib/widgets/notification_bell.dart
//
// AppBar-mountable bell icon that shows a red unread-count badge, polls
// GET /api/academics/notifications every 60s while mounted, and opens a
// bottom-sheet notification list on tap with mark-read / mark-all-read
// actions. Gracefully handles the signed-out state by showing an empty
// silent bell (since the parent AppBar is only ever visible to signed-in
// users via _AuthGate, this branch is defensive rather than reachable).
// =============================================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../services/notifications_service.dart';

class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  Timer? _pollTimer;
  int _unreadCount = 0;
  List<PediaidNotification> _notifications = const [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Kick off first load, then start the 60-second polling tick.
    _refresh();
    _pollTimer = Timer.periodic(const Duration(seconds: 60), (_) => _refresh());
    // Also refresh when the auth state changes (e.g. fresh login).
    AuthService.instance.addListener(_refresh);
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    AuthService.instance.removeListener(_refresh);
    super.dispose();
  }

  Future<void> _refresh() async {
    if (!AuthService.instance.isLoggedIn) {
      if (mounted) {
        setState(() {
          _unreadCount = 0;
          _notifications = const [];
        });
      }
      return;
    }
    try {
      final result = await NotificationsService.instance.list();
      if (!mounted) return;
      setState(() {
        _unreadCount = result.unreadCount;
        _notifications = result.data;
      });
    } catch (_) {
      // Ignore — bell falls back to current cached state.
    }
  }

  Future<void> _openSheet() async {
    setState(() => _loading = true);
    await _refresh();
    if (!mounted) return;
    setState(() => _loading = false);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _NotificationSheet(
        initialItems: _notifications,
        initialUnread: _unreadCount,
        onChanged: _refresh,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: _openSheet,
          tooltip: _unreadCount > 0
              ? '$_unreadCount unread notifications'
              : 'Notifications',
        ),
        if (_unreadCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: IgnorePointer(
              child: Container(
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53E3E),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Text(
                  _unreadCount > 99 ? '99+' : '$_unreadCount',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom sheet — shows the list with mark-all-read and per-row mark-read.
// ---------------------------------------------------------------------------

class _NotificationSheet extends StatefulWidget {
  final List<PediaidNotification> initialItems;
  final int initialUnread;
  final Future<void> Function() onChanged;

  const _NotificationSheet({
    required this.initialItems,
    required this.initialUnread,
    required this.onChanged,
  });

  @override
  State<_NotificationSheet> createState() => _NotificationSheetState();
}

class _NotificationSheetState extends State<_NotificationSheet> {
  late List<PediaidNotification> _items;
  late int _unread;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _items = widget.initialItems;
    _unread = widget.initialUnread;
  }

  Future<void> _markAll() async {
    if (_unread == 0) return;
    setState(() => _busy = true);
    try {
      await NotificationsService.instance.markAllRead();
      setState(() {
        _items = _items
            .map((n) => PediaidNotification(
                  id: n.id,
                  title: n.title,
                  message: n.message,
                  type: n.type,
                  linkPath: n.linkPath,
                  isRead: true,
                  createdAt: n.createdAt,
                ))
            .toList();
        _unread = 0;
      });
      await widget.onChanged();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _markOne(PediaidNotification n) async {
    if (n.isRead) return;
    try {
      await NotificationsService.instance.markRead(n.id);
      setState(() {
        _items = _items
            .map((x) => x.id == n.id
                ? PediaidNotification(
                    id: x.id,
                    title: x.title,
                    message: x.message,
                    type: x.type,
                    linkPath: x.linkPath,
                    isRead: true,
                    createdAt: x.createdAt,
                  )
                : x)
            .toList();
        _unread = (_unread - 1).clamp(0, _unread);
      });
      await widget.onChanged();
    } catch (_) {
      // ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).size.height * 0.75;

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: height),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Grab handle
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 6),
              child: Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 12, 10),
              child: Row(
                children: [
                  Icon(Icons.notifications_outlined, color: cs.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _unread > 0
                          ? 'Notifications ($_unread unread)'
                          : 'Notifications',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  if (_unread > 0)
                    TextButton.icon(
                      onPressed: _busy ? null : _markAll,
                      icon: const Icon(Icons.done_all_rounded, size: 16),
                      label: Text(
                        'Mark all read',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),

            // List / empty state
            Expanded(
              child: _items.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.notifications_off_outlined,
                              size: 44,
                              color: cs.onSurface.withValues(alpha: 0.25),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "You're all caught up",
                              style: GoogleFonts.plusJakartaSans(
                                color: cs.onSurface,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "We'll let you know when something needs your attention.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                color: cs.onSurface.withValues(alpha: 0.55),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _items.length,
                      padding: const EdgeInsets.only(bottom: 12),
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (ctx, i) {
                        final n = _items[i];
                        return _NotificationRow(
                          notification: n,
                          onTap: () => _markOne(n),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  final PediaidNotification notification;
  final VoidCallback onTap;
  const _NotificationRow({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (icon, color) = _iconFor(notification.type);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        decoration: BoxDecoration(
          color: notification.isRead
              ? null
              : cs.primaryContainer.withValues(alpha: 0.25),
          border: notification.isRead
              ? null
              : Border(left: BorderSide(color: cs.primary, width: 3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 17, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: cs.onSurface.withValues(alpha: 0.75),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _relativeTime(notification.createdAt),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  (IconData, Color) _iconFor(String type) {
    switch (type) {
      case 'chapter_approved':
      case 'role_approved':
        return (Icons.check_circle_rounded, const Color(0xFF16A34A));
      case 'chapter_rejected':
      case 'role_rejected':
        return (Icons.cancel_rounded, const Color(0xFFDC2626));
      case 'chapter_changes_requested':
        return (Icons.edit_note_rounded, const Color(0xFFF59E0B));
      default:
        return (Icons.notifications_rounded, const Color(0xFF3B82F6));
    }
  }

  String _relativeTime(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${t.day}/${t.month}/${t.year}';
  }
}
