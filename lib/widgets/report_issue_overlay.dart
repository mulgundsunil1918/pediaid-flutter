import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import '../services/auth_service.dart';

/// Root navigator key — set on MaterialApp.navigatorKey in main.dart.
/// The overlay lives ABOVE the Navigator (MaterialApp.builder wraps it),
/// so its own BuildContext cannot reach a Navigator; the sheet must be
/// pushed through this key instead.
final GlobalKey<NavigatorState> reportNavigatorKey = GlobalKey<NavigatorState>();

/// Wraps the whole app (via `MaterialApp.builder`) with a small floating
/// "Report" button that appears on every screen — calculators, guides,
/// lab reference, formulary, everything — without touching any of those
/// 140+ screen files individually.
class ReportIssueOverlay extends StatelessWidget {
  final Widget child;
  const ReportIssueOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          right: 8,
          bottom: 90,
          child: SafeArea(
            child: _ReportFab(hostContext: context),
          ),
        ),
      ],
    );
  }
}

class _ReportFab extends StatelessWidget {
  final BuildContext hostContext;
  const _ReportFab({required this.hostContext});

  String _guessScreenTitle() {
    String? found;
    void visit(Element el) {
      final w = el.widget;
      if (w is AppBar && w.title is Text) {
        final data = (w.title as Text).data;
        if (data != null && data.trim().isNotEmpty) found = data;
      }
      el.visitChildren(visit);
    }

    try {
      hostContext.visitChildElements(visit);
    } catch (_) {
      // best-effort only — never let a failed tree-walk break the app
    }
    return found ?? 'Unknown screen';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _openSheet,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: cs.surface.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cs.outline.withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.flag_outlined, size: 15, color: cs.onSurface.withValues(alpha: 0.7)),
              const SizedBox(width: 5),
              Text('Report',
                  style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface.withValues(alpha: 0.75))),
            ],
          ),
        ),
      ),
    );
  }

  void _openSheet() {
    // Must go through the root navigator key — this widget sits above the
    // Navigator, so showModalBottomSheet(context) would find no Navigator
    // and silently fail (the original "button does nothing" bug).
    final nav = reportNavigatorKey.currentState;
    if (nav == null) return;
    final screenGuess = _guessScreenTitle();
    nav.push(ModalBottomSheetRoute(
      isScrollControlled: true,
      builder: (_) => _ReportSheet(initialScreen: screenGuess),
    ));
  }
}

class _ReportSheet extends StatefulWidget {
  final String initialScreen;
  const _ReportSheet({required this.initialScreen});

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  late final TextEditingController _screenCtrl =
      TextEditingController(text: widget.initialScreen);
  final _messageCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _screenCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final message = _messageCtrl.text.trim();
    if (message.isEmpty) return;
    setState(() => _sending = true);

    String appVersion = 'unknown';
    try {
      final info = await PackageInfo.fromPlatform();
      appVersion = '${info.version}+${info.buildNumber}';
    } catch (_) {}

    var ok = false;
    try {
      final res = await http
          .post(
            Uri.parse('${AuthService.apiBase}/api/feedback/report'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'screen': _screenCtrl.text.trim(),
              'message': message,
              'platform': kIsWeb ? 'web' : defaultTargetPlatform.name,
              'appVersion': appVersion,
            }),
          )
          .timeout(const Duration(seconds: 10));
      ok = res.statusCode >= 200 && res.statusCode < 300;
    } catch (_) {
      ok = false;
    }

    if (!mounted) return;
    setState(() => _sending = false);
    // Grab the messenger BEFORE popping — after pop this context is
    // deactivated and ScaffoldMessenger.of(context) would throw.
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(ok
            ? 'Thanks — your report was sent.'
            : "Couldn't send right now — please try again later."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Report an issue or suggestion',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: cs.onSurface)),
          const SizedBox(height: 12),
          TextField(
            controller: _screenCtrl,
            decoration: const InputDecoration(
              labelText: 'Screen',
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _messageCtrl,
            maxLines: 4,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'What went wrong, or what should improve?',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _sending ? null : _submit,
              child: _sending
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Send'),
            ),
          ),
        ],
      ),
    );
  }
}
