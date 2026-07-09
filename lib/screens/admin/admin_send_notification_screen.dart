// =============================================================================
// lib/screens/admin/admin_send_notification_screen.dart
//
// Admin-only compose form for broadcast push notifications. Reached from the
// "Send Notification" card on the Admin Dashboard. POSTs to
// /api/push/broadcast, which accepts the admin's JWT — the same login that
// unlocked the dashboard. A broadcast cannot be recalled once sent, so the
// send button goes through an explicit confirmation dialog.
// =============================================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../services/auth_service.dart';

class AdminSendNotificationScreen extends StatefulWidget {
  const AdminSendNotificationScreen({super.key});

  @override
  State<AdminSendNotificationScreen> createState() =>
      _AdminSendNotificationScreenState();
}

class _AdminSendNotificationScreenState
    extends State<AdminSendNotificationScreen> {
  static const int _titleMax = 65;
  static const int _bodyMax = 240;

  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  bool _sending = false;
  String? _error;
  String? _sentTitle; // non-null → success banner for the last broadcast

  @override
  void initState() {
    super.initState();
    // Live-update the preview + character counters as the admin types.
    _titleCtrl.addListener(() => setState(() {}));
    _bodyCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  bool get _canSend =>
      !_sending &&
      _titleCtrl.text.trim().isNotEmpty &&
      _bodyCtrl.text.trim().isNotEmpty;

  Future<void> _confirmAndSend() async {
    final title = _titleCtrl.text.trim();
    final body = _bodyCtrl.text.trim();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Send to all users?',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This pushes a notification to every subscribed device. '
              'It cannot be undone or recalled.',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(ctx).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 13, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(body,
                      style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Yes, send it'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() {
      _sending = true;
      _error = null;
      _sentTitle = null;
    });

    try {
      final res = await AuthService.instance.authorizedFetch(
        (headers) => http
            .post(
              Uri.parse('${AuthService.apiBase}/api/push/broadcast'),
              headers: headers,
              body: jsonEncode({'title': title, 'body': body}),
            )
            .timeout(const Duration(seconds: 15)),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        setState(() {
          _sentTitle = title;
          _titleCtrl.clear();
          _bodyCtrl.clear();
        });
      } else {
        String msg = 'Request failed (${res.statusCode})';
        try {
          final decoded = jsonDecode(res.body) as Map<String, dynamic>;
          msg = (decoded['message'] ?? decoded['error'] ?? msg).toString();
        } catch (_) {}
        setState(() => _error = msg);
      }
    } catch (e) {
      setState(() => _error = 'Could not reach the server: $e');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isAdmin = AuthService.instance.currentUser?.role == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Send Notification',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: !isAdmin
          ? Center(
              child: Text(
                'Admin access only',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Broadcast a push notification to every PediAid user. '
                  'Notifications cannot be recalled after sending.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: cs.onSurface.withValues(alpha: 0.65),
                  ),
                ),
                const SizedBox(height: 18),

                // Success banner
                if (_sentTitle != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16A34A).withValues(alpha: 0.1),
                      border: Border.all(
                          color: const Color(0xFF16A34A).withValues(alpha: 0.4)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            color: Color(0xFF16A34A), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '“$_sentTitle” sent to all subscribed devices.',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5, color: cs.onSurface),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Error banner
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Failed to send: $_error',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5, color: cs.onErrorContainer),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Title field
                Text(
                  'Title',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _titleCtrl,
                  maxLength: _titleMax,
                  decoration: InputDecoration(
                    hintText: 'e.g. New TPN Calculator update',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    counterText:
                        '${_titleCtrl.text.length}/$_titleMax',
                  ),
                ),
                const SizedBox(height: 10),

                // Message field
                Text(
                  'Message',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _bodyCtrl,
                  maxLength: _bodyMax,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText:
                        'e.g. Dextrose stock mixing now supports custom stock selection. Check it out!',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    counterText: '${_bodyCtrl.text.length}/$_bodyMax',
                  ),
                ),
                const SizedBox(height: 14),

                // Device-style preview
                if (_titleCtrl.text.isNotEmpty ||
                    _bodyCtrl.text.isNotEmpty) ...[
                  Text(
                    'PREVIEW',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: cs.primary,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            'Ped',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _titleCtrl.text.isEmpty
                                    ? 'Notification title'
                                    : _titleCtrl.text,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: cs.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _bodyCtrl.text.isEmpty
                                    ? 'Notification message'
                                    : _bodyCtrl.text,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  color:
                                      cs.onSurface.withValues(alpha: 0.7),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Send button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _canSend ? _confirmAndSend : null,
                    icon: _sending
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send_rounded, size: 18),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        _sending ? 'Sending…' : 'Send to all users',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.5, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
    );
  }
}
