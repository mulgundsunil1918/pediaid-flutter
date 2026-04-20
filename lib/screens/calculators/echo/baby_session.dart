// =============================================================================
// lib/screens/calculators/echo/baby_session.dart
//
// Small in-memory store shared across the 2D Echo Calculators module so the
// user doesn't have to re-type the baby's weight / HR / gestational age in
// every calculator. Values also persist to SharedPreferences so the session
// survives a tab refresh / app restart.
//
// Exposes:
//   - BabySession.of(context).weight / hr / gaWeeks
//   - BabySessionProvider — wrap the screen tree with this once
//   - BabySessionBar — a chip-style header widget showing current values
//     with an "edit" button
//   - EchoPrefs — SharedPreferences helpers for recently-used calculators
// =============================================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Baby session store (ChangeNotifier + inherited access)
// ---------------------------------------------------------------------------

class BabySession extends ChangeNotifier {
  double? _weight;
  double? _hr;
  double? _gaWeeks;

  double? get weight => _weight;
  double? get hr => _hr;
  double? get gaWeeks => _gaWeeks;

  /// Convenience accessor the InheritedWidget provides to descendants.
  static BabySession of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<_BabySessionInherited>();
    assert(provider != null, 'No BabySessionProvider found in widget tree');
    return provider!.session;
  }

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _weight  = prefs.getDouble('echo_baby_weight');
      _hr      = prefs.getDouble('echo_baby_hr');
      _gaWeeks = prefs.getDouble('echo_baby_ga');
      notifyListeners();
    } catch (_) {/* ignore */}
  }

  Future<void> update({double? weight, double? hr, double? gaWeeks}) async {
    _weight  = weight ?? _weight;
    _hr      = hr ?? _hr;
    _gaWeeks = gaWeeks ?? _gaWeeks;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_weight != null)  await prefs.setDouble('echo_baby_weight', _weight!);
      if (_hr != null)      await prefs.setDouble('echo_baby_hr', _hr!);
      if (_gaWeeks != null) await prefs.setDouble('echo_baby_ga', _gaWeeks!);
    } catch (_) {/* ignore */}
  }

  Future<void> clear() async {
    _weight = null;
    _hr = null;
    _gaWeeks = null;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('echo_baby_weight');
      await prefs.remove('echo_baby_hr');
      await prefs.remove('echo_baby_ga');
    } catch (_) {/* ignore */}
  }
}

class _BabySessionInherited extends InheritedNotifier<BabySession> {
  const _BabySessionInherited({
    required this.session,
    required super.notifier,
    required super.child,
  });

  final BabySession session;
}

/// Wrap the echo calculator screen tree with this widget. It creates a
/// single BabySession and hydrates it from SharedPreferences.
class BabySessionProvider extends StatefulWidget {
  const BabySessionProvider({super.key, required this.child});

  final Widget child;

  @override
  State<BabySessionProvider> createState() => _BabySessionProviderState();
}

class _BabySessionProviderState extends State<BabySessionProvider> {
  final BabySession _session = BabySession();

  @override
  void initState() {
    super.initState();
    _session.load();
  }

  @override
  void dispose() {
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BabySessionInherited(
      session: _session,
      notifier: _session,
      child: widget.child,
    );
  }
}

// ---------------------------------------------------------------------------
// BabySessionBar — chip-style header with edit action
// ---------------------------------------------------------------------------

class BabySessionBar extends StatelessWidget {
  const BabySessionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final session = BabySession.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(Icons.child_care_rounded, size: 20, color: cs.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Wrap(
              spacing: 14,
              runSpacing: 4,
              children: [
                _Chip(label: 'Weight', value: session.weight != null ? '${session.weight!.toStringAsFixed(2)} kg' : '—'),
                _Chip(label: 'HR',     value: session.hr != null     ? '${session.hr!.toStringAsFixed(0)} bpm' : '—'),
                _Chip(label: 'GA',     value: session.gaWeeks != null ? '${session.gaWeeks!.toStringAsFixed(1)} wk' : '—'),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () => _editSession(context, session),
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: Text(
              'Edit',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editSession(BuildContext context, BabySession s) async {
    final wCtl  = TextEditingController(text: s.weight?.toString() ?? '');
    final hCtl  = TextEditingController(text: s.hr?.toString() ?? '');
    final gCtl  = TextEditingController(text: s.gaWeeks?.toString() ?? '');
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final cs = Theme.of(ctx).colorScheme;
        return Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Baby session',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18, fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 4),
              Text('Shared across every echo calculator in this session.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, color: cs.onSurface.withValues(alpha: 0.6),
                  )),
              const SizedBox(height: 18),
              _sheetField(ctx, controller: wCtl, label: 'Weight (kg)', hint: 'e.g. 1.2'),
              const SizedBox(height: 12),
              _sheetField(ctx, controller: hCtl, label: 'Heart rate (bpm)', hint: 'e.g. 150'),
              const SizedBox(height: 12),
              _sheetField(ctx, controller: gCtl, label: 'Gestational age (weeks)', hint: 'e.g. 32.5'),
              const SizedBox(height: 20),
              Row(
                children: [
                  TextButton(
                    onPressed: () { s.clear(); Navigator.pop(ctx); },
                    child: const Text('Clear all'),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () {
                      s.update(
                        weight:  double.tryParse(wCtl.text),
                        hr:      double.tryParse(hCtl.text),
                        gaWeeks: double.tryParse(gCtl.text),
                      );
                      Navigator.pop(ctx);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    wCtl.dispose(); hCtl.dispose(); gCtl.dispose();
  }

  Widget _sheetField(BuildContext ctx,
      {required TextEditingController controller,
      required String label,
      required String hint}) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return RichText(
      text: TextSpan(
        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: cs.onSurface),
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(color: cs.onSurface.withValues(alpha: 0.55)),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// EchoPrefs — recently-used tracking
// ---------------------------------------------------------------------------

class EchoPrefs {
  static const _recentKey = 'echo_recent_calcs';
  static const _maxRecent = 6;

  /// Returns the ordered list of recently-used calculator ids (most recent first).
  static Future<List<String>> getRecent() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_recentKey) ?? const [];
    } catch (_) {
      return const [];
    }
  }

  /// Pushes [id] to the front of the recent list, dedupes, trims to [_maxRecent].
  static Future<void> recordUse(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = prefs.getStringList(_recentKey) ?? <String>[];
      final next = <String>[id, ...current.where((e) => e != id)].take(_maxRecent).toList();
      await prefs.setStringList(_recentKey, next);
    } catch (_) {/* ignore */}
  }
}
