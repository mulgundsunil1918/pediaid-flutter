// =============================================================================
// services/tool_registry.dart
//
// One catalogue of every individually-openable tool in the app: calculators,
// paediatric scores and the standalone neonatal scores.
//
// Why this exists
// ---------------
// Quick Access and Recents were both keyed to a hand-written table of ~30
// module keys in home_screen.dart. That table could only ever name whole
// modules ("Calculators"), never the tool the doctor actually used ("QTc"),
// and adding a tool to it meant editing Dart. With ~160 tools in the app that
// stopped scaling.
//
// Everything here is derived from the screens' own data — CalculatorsScreen's
// catalogue and allPaediatricScores — so a tool added to either list is
// automatically pinnable and automatically lands in Recents. There is no
// second list to keep in sync.
//
// Keys are persisted (SharedPreferences) so they MUST stay stable across
// releases. They are derived from the tool's title, which is why [_slug]
// strips punctuation rather than hashing: a title tweak like "QTc" ->
// "QTc (Bazett)" should not silently orphan a user's pinned shortcut, and a
// slug degrades more gracefully than a hash when it does change.
// =============================================================================

import 'package:flutter/material.dart';

import 'recents_service.dart';

import '../screens/calculators/calculators_screen.dart';
import '../screens/scores/paediatric_scores_hub.dart';
import '../screens/guides/guides_screen.dart';
import '../screens/scores/score_scaffold.dart';
import '../screens/guides/neonatal_scores/nichd_hie_screen.dart';
import '../screens/guides/neonatal_scores/lus_score_screen.dart';
import '../screens/guides/modified_ballard_screen.dart';
import '../screens/guides/pofras_screen.dart';
import '../screens/guides/can_score_screen.dart';

/// Which part of the app a tool belongs to. Used to group the picker.
enum ToolKind { calculator, score, guide }

class ToolEntry {
  /// Stable, persisted identifier, e.g. `calc:qtc` or `score:pews`.
  final String key;
  final String label;
  final String subtitle;
  final IconData icon;
  final ToolKind kind;

  /// Extra words to match on in the picker's search box (system name, the
  /// eponym, common abbreviations) — the label alone misses too much.
  final String keywords;

  final Widget Function() build;

  const ToolEntry({
    required this.key,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.kind,
    required this.build,
    this.keywords = '',
  });

  bool matches(String q) =>
      label.toLowerCase().contains(q) ||
      subtitle.toLowerCase().contains(q) ||
      keywords.toLowerCase().contains(q);
}

/// Lowercase, punctuation-free slug used as the persisted key.
String _slug(String title) {
  final s = title
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  return s.isEmpty ? 'tool' : s;
}

class ToolRegistry {
  ToolRegistry._();
  static final ToolRegistry instance = ToolRegistry._();

  List<ToolEntry>? _cache;

  /// Every openable tool, calculators first then scores.
  List<ToolEntry> get all => _cache ??= _build();

  List<ToolEntry> get calculators =>
      all.where((t) => t.kind == ToolKind.calculator).toList();

  List<ToolEntry> get scores =>
      all.where((t) => t.kind == ToolKind.score).toList();

  List<ToolEntry> get guides =>
      all.where((t) => t.kind == ToolKind.guide).toList();

  ToolEntry? byKey(String key) {
    for (final t in all) {
      if (t.key == key) return t;
    }
    return null;
  }

  /// Canonical key for a tool by its display label — the slug alone is not
  /// safe to reconstruct, because a name collision suffixes the second key.
  String? keyForLabel(String label, {ToolKind? kind}) {
    for (final t in all) {
      if (t.label == label && (kind == null || t.kind == kind)) return t.key;
    }
    return null;
  }

  /// Records a tool visit so Recents names the TOOL ("QTc"), not the module
  /// it happens to live in ("Calculators"). No-op for unregistered labels.
  void recordVisit(String label, {ToolKind? kind}) {
    final key = keyForLabel(label, kind: kind);
    if (key == null) return;
    // ignore: unawaited_futures
    RecentsService.instance.record(key, label);
  }

  List<ToolEntry> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all.where((t) => t.matches(q)).toList();
  }

  List<ToolEntry> _build() {
    final out = <ToolEntry>[];
    final seen = <String>{};

    void add(ToolEntry e) {
      // Two tools could slug identically (e.g. a calculator and a score with
      // the same name). First wins and the second is suffixed, so a key never
      // silently points at the wrong screen.
      var key = e.key;
      var n = 2;
      while (!seen.add(key)) {
        key = '${e.key}-$n';
        n++;
      }
      out.add(
        ToolEntry(
          key: key,
          label: e.label,
          subtitle: e.subtitle,
          icon: e.icon,
          kind: e.kind,
          keywords: e.keywords,
          build: e.build,
        ),
      );
    }

    // ── Calculators ─────────────────────────────────────────────────────────
    for (final c in calculatorCatalogue) {
      final title = c.title;
      add(
        ToolEntry(
          key: 'calc:${_slug(title)}',
          label: title,
          subtitle: c.subtitle,
          icon: c.icon,
          kind: ToolKind.calculator,
          keywords:
              '${c.subtitle} ${c.neonatal ? 'neonatal nicu' : 'paediatric'}',
          // Resolved at tap time, not now: building 63 screens up front to fill
          // a catalogue would cost more than the catalogue saves.
          build: () => calculatorScreenFor(title) ?? const SizedBox.shrink(),
        ),
      );
    }

    // ── Paediatric scores ───────────────────────────────────────────────────
    for (final d in allPaediatricScores) {
      add(
        ToolEntry(
          key: 'score:${_slug(d.title)}',
          label: d.title,
          subtitle: d.subtitle,
          icon: Icons.checklist_rounded,
          kind: ToolKind.score,
          keywords: '${d.system} ${d.subtitle}',
          build: () => ScoreScaffold(def: d),
        ),
      );
    }

    // ── Guides & protocols ──────────────────────────────────────────────────
    for (final g in guideCatalogue) {
      add(
        ToolEntry(
          key: 'guide:${_slug(g.title)}',
          label: g.title,
          subtitle: g.subtitle,
          icon: g.icon,
          kind: ToolKind.guide,
          keywords: g.subtitle,
          build: () => Builder(builder: g.build),
        ),
      );
    }

    // ── Standalone neonatal scores ──────────────────────────────────────────
    // The rest of the neonatal hub is JSON-driven and needs an async load, so
    // only the screens that stand alone are registered here.
    void neo(
      String label,
      String subtitle,
      String keywords,
      Widget Function() b,
    ) => add(
      ToolEntry(
        key: 'score:${_slug(label)}',
        label: label,
        subtitle: subtitle,
        icon: Icons.child_care_rounded,
        kind: ToolKind.score,
        keywords: 'neonatal nicu $keywords',
        build: b,
      ),
    );

    neo(
      'NICHD HIE Assessment',
      'Cooling eligibility & assessment',
      'hypoxic ischaemic encephalopathy therapeutic hypothermia sarnat',
      () => const NichdHieScreen(),
    );
    neo(
      'Lung Ultrasound Score (LUS)',
      'Neonatal lung aeration',
      'surfactant respiratory distress 6 zone 10 zone',
      () => const LusScoreScreen(),
    );
    neo(
      'Modified Ballard Score',
      'Gestational age assessment',
      'neuromuscular physical maturity new ballard',
      () => const ModifiedBallardScreen(),
    );
    neo(
      'POFRAS',
      'Preterm oral feeding readiness',
      'oral feeding readiness assessment scale breastfeeding',
      () => const PofrasScreen(),
    );
    neo(
      'CAN Score',
      'Clinical assessment of nutrition at birth',
      'malnutrition metcoff nutrition',
      () => const CanScoreScreen(),
    );

    return List.unmodifiable(out);
  }
}
