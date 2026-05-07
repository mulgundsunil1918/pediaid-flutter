// =============================================================================
// lib/services/formulary_v2_service.dart
//
// Loads the structured PediAid v2/v3 drug data:
//   - assets/data/formulary/formulary_v2/harrietlane_v3.json  (478 HL drugs,
//     restructured by tools/restructure_hl.py — clean dose blocks)
//   - assets/data/formulary/formulary_v2/neofax_full.json     (199 Neofax
//     drugs, fully authored)
//
// Exposes `DrugV2` records that the new DrugDetailScreenV2 renders. The
// thin `DrugEntry` index (name + page) used by FormularyScreen for the
// search list still comes from the old FormularyService — we look up the
// rich detail here only when the user taps an entry.
// =============================================================================

import 'dart:convert';

import 'package:flutter/services.dart';

class DoseBlock {
  final String indication;
  final List<DosePopulation> populations;
  const DoseBlock({required this.indication, required this.populations});

  factory DoseBlock.fromJson(Map<String, dynamic> j) => DoseBlock(
        indication: (j['indication'] as String?) ?? 'Dosing',
        populations: ((j['populations'] as List?) ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(DosePopulation.fromJson)
            .toList(),
      );
}

class DosePopulation {
  final String label;
  final String routeHint;
  final String doseMd;
  const DosePopulation({
    required this.label,
    required this.routeHint,
    required this.doseMd,
  });

  factory DosePopulation.fromJson(Map<String, dynamic> j) => DosePopulation(
        label: (j['label'] as String?) ?? '',
        routeHint: (j['route_hint'] as String?) ?? '',
        doseMd: (j['dose_md'] as String?) ?? '',
      );
}

/// A single drug — either Harriet Lane (v3 restructured) or Neofax (v2).
/// The two source schemas differ; this class normalises them.
class DrugV2 {
  final String id;
  final String drug;
  final List<String> altNames;
  final String category;
  final int page;
  final String source; // 'Harriet Lane' or 'Neofax'
  final bool hidden;

  // For HL-derived drugs:
  final List<DoseBlock> doseBlocks;
  final String rawDoseMd;
  final List<String> callouts;
  final String cautionsMd;
  final String monitoringMd;
  final String adverseEffectsMd;
  final String pharmacokineticsMd;
  final String pearlsMd;

  const DrugV2({
    required this.id,
    required this.drug,
    required this.altNames,
    required this.category,
    required this.page,
    required this.source,
    required this.hidden,
    required this.doseBlocks,
    required this.rawDoseMd,
    required this.callouts,
    required this.cautionsMd,
    required this.monitoringMd,
    required this.adverseEffectsMd,
    required this.pharmacokineticsMd,
    required this.pearlsMd,
  });

  factory DrugV2.fromHL(Map<String, dynamic> j) => DrugV2(
        id: (j['id'] as String?) ?? '',
        drug: (j['drug'] as String?) ?? '',
        altNames: ((j['alt_names'] as List?) ?? const []).map((e) => '$e').toList(),
        category: (j['category'] as String?) ?? '',
        page: (j['page'] as num?)?.toInt() ?? 0,
        source: 'Harriet Lane',
        hidden: (j['hidden'] as bool?) ?? false,
        doseBlocks: ((j['dose_blocks'] as List?) ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(DoseBlock.fromJson)
            .toList(),
        rawDoseMd: (j['raw_dose_md'] as String?) ?? '',
        callouts: ((j['callouts'] as List?) ?? const []).map((e) => '$e').toList(),
        cautionsMd: (j['cautions_md'] as String?) ?? '',
        monitoringMd: (j['monitoring_md'] as String?) ?? '',
        adverseEffectsMd: (j['adverse_effects_md'] as String?) ?? '',
        pharmacokineticsMd: (j['pharmacokinetics_md'] as String?) ?? '',
        pearlsMd: (j['pearls_md'] as String?) ?? '',
      );

  /// Adapt the Neofax schema to our normalized shape. Neofax `doses` is a
  /// list of structured rows (indication / route / dose_per_kg_per_dose /
  /// frequency / max_per_dose / comments) — we group them by indication
  /// and emit one DosePopulation per row, using `route` as the label.
  factory DrugV2.fromNeofax(Map<String, dynamic> j) {
    final doseRows = ((j['doses'] as List?) ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();

    // Group rows by indication.
    final Map<String, List<Map<String, dynamic>>> byInd = {};
    for (final r in doseRows) {
      final ind = ((r['indication'] as String?) ?? '').trim().isEmpty
          ? 'Dosing'
          : (r['indication'] as String).trim();
      byInd.putIfAbsent(ind, () => []).add(r);
    }

    final blocks = <DoseBlock>[];
    byInd.forEach((ind, rows) {
      final pops = rows.map((r) {
        final route = ((r['route'] as String?) ?? '').trim();
        final ga    = ((r['ga_band'] as String?) ?? '').trim();
        final pma   = ((r['pma_band'] as String?) ?? '').trim();
        final pna   = ((r['postnatal_age_band'] as String?) ?? '').trim();
        final dose  = ((r['dose_per_kg_per_dose'] as String?) ?? '').trim();
        final load  = ((r['loading_dose_per_kg'] as String?) ?? '').trim();
        final freq  = ((r['frequency'] as String?) ?? '').trim();
        final maxD  = ((r['max_per_dose'] as String?) ?? '').trim();
        final maxDay= ((r['max_per_day_all_routes'] as String?) ?? '').trim();
        final inf   = ((r['infusion_rate'] as String?) ?? '').trim();
        final cmt   = ((r['comments'] as String?) ?? '').trim();

        // Build the dose narrative as Markdown.
        final parts = <String>[];
        if (load.isNotEmpty)  parts.add('**Loading:** $load');
        if (dose.isNotEmpty)  parts.add('**Dose:** $dose');
        if (freq.isNotEmpty)  parts.add('**Frequency:** $freq');
        if (inf.isNotEmpty)   parts.add('**Infusion:** $inf');
        if (maxD.isNotEmpty)  parts.add('**Max/dose:** $maxD');
        if (maxDay.isNotEmpty)parts.add('**Max/day:** $maxDay');
        if (cmt.isNotEmpty)   parts.add(cmt);
        final doseMd = parts.join('  \n');

        final labelParts = [ga, pma, pna]
            .where((s) => s.isNotEmpty).toList();
        final label = labelParts.isEmpty ? '' : labelParts.join(' · ');

        return DosePopulation(
          label: label,
          routeHint: route.toUpperCase(),
          doseMd: doseMd,
        );
      }).toList();
      blocks.add(DoseBlock(indication: ind, populations: pops));
    });

    final indFormulations = ((j['india_formulations'] as List?) ?? const [])
        .whereType<Map<String, dynamic>>()
        .map((f) {
          final form = (f['form'] ?? '').toString().trim();
          final str  = (f['strength'] ?? '').toString().trim();
          final brands = ((f['brands_india'] as List?) ?? const [])
              .map((e) => '$e').join(', ');
          final note = (f['notes'] ?? '').toString().trim();
          var line = form.isNotEmpty ? '**$form** — $str' : '**Formulation:** $str';
          if (brands.isNotEmpty) line += '  \n_Indian brands:_ $brands';
          if (note.isNotEmpty)   line += '  \n_${note}_';
          return line;
        }).join('\n\n');

    final pearlsMd = [
      ((j['monitoring'] as String?) ?? '').trim().isNotEmpty
          ? '**Monitoring:** ${j['monitoring']}' : '',
      ((j['reconstitution'] as String?) ?? '').trim().isNotEmpty
          ? '**Reconstitution:** ${j['reconstitution']}' : '',
      ((j['incompatibilities'] as String?) ?? '').trim().isNotEmpty
          ? '**Incompatibilities:** ${j['incompatibilities']}' : '',
      ((j['renal_adjustment'] as String?) ?? '').trim().isNotEmpty
          ? '**Renal adjustment:** ${j['renal_adjustment']}' : '',
      ((j['hepatic_adjustment'] as String?) ?? '').trim().isNotEmpty
          ? '**Hepatic adjustment:** ${j['hepatic_adjustment']}' : '',
    ].where((s) => s.isNotEmpty).join('\n\n');

    return DrugV2(
      id: (j['id'] as String?) ?? '',
      drug: (j['drug'] as String?) ?? '',
      altNames: ((j['alt_names'] as List?) ?? const []).map((e) => '$e').toList(),
      category: (j['category'] as String?) ?? '',
      page: ((j['sources'] as Map?)?['primary_neofax_page'] as num?)?.toInt() ?? 0,
      source: 'Neofax',
      hidden: false,
      doseBlocks: blocks,
      rawDoseMd: indFormulations,
      callouts: const [],
      cautionsMd: (j['contraindications'] as String?) ?? '',
      monitoringMd: (j['monitoring'] as String?) ?? '',
      adverseEffectsMd: (j['adverse_effects'] as String?) ?? '',
      pharmacokineticsMd: '',
      pearlsMd: pearlsMd,
    );
  }
}

class FormularyV2Service {
  static final FormularyV2Service _instance = FormularyV2Service._internal();
  factory FormularyV2Service() => _instance;
  FormularyV2Service._internal();

  Map<String, DrugV2>? _byId;
  Map<String, DrugV2>? _byNameLowerHL;
  Map<String, DrugV2>? _byNameLowerNeofax;

  Future<void> _ensureLoaded() async {
    if (_byId != null) return;

    final byId = <String, DrugV2>{};
    final byNameHL = <String, DrugV2>{};
    final byNameNF = <String, DrugV2>{};

    // ── Harriet Lane (v3 restructured) ──────────────────────────────
    try {
      final raw = await rootBundle.loadString(
          'assets/data/formulary/formulary_v2/harrietlane_v3.json');
      final j = json.decode(raw) as Map<String, dynamic>;
      for (final d in (j['drugs'] as List)) {
        final drug = DrugV2.fromHL(d as Map<String, dynamic>);
        if (drug.id.isEmpty) continue;
        byId[drug.id] = drug;
        byNameHL[drug.drug.toLowerCase()] = drug;
      }
    } catch (e) {
      // fall through — Neofax still works.
    }

    // ── Neofax (v2 fully authored) ──────────────────────────────────
    try {
      final raw = await rootBundle.loadString(
          'assets/data/formulary/formulary_v2/neofax_full.json');
      final j = json.decode(raw) as Map<String, dynamic>;
      for (final d in (j['drugs'] as List)) {
        final drug = DrugV2.fromNeofax(d as Map<String, dynamic>);
        if (drug.id.isEmpty) continue;
        byId[drug.id] = drug;
        byNameNF[drug.drug.toLowerCase()] = drug;
      }
    } catch (_) {}

    _byId = byId;
    _byNameLowerHL = byNameHL;
    _byNameLowerNeofax = byNameNF;
  }

  Future<DrugV2?> findByName(String name, {required String source}) async {
    await _ensureLoaded();
    final key = name.trim().toLowerCase();
    if (source.toLowerCase().contains('neofax')) {
      return _byNameLowerNeofax?[key] ?? _matchClosest(key, _byNameLowerNeofax);
    }
    return _byNameLowerHL?[key] ?? _matchClosest(key, _byNameLowerHL);
  }

  DrugV2? _matchClosest(String key, Map<String, DrugV2>? map) {
    if (map == null) return null;
    // Try a starts-with fallback to handle minor name normalisation.
    for (final entry in map.entries) {
      if (entry.key.startsWith(key)) return entry.value;
    }
    return null;
  }
}
