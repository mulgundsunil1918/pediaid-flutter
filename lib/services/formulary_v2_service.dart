// =============================================================================
// lib/services/formulary_v2_service.dart
//
// Loads the structured PediAid v2/v3 drug data:
//   - assets/data/formulary/formulary_v2/harrietlane_v3.json  (478 HL drugs,
//     restructured by tools/restructure_hl.py — clean dose blocks)
//   - assets/data/formulary/formulary_v2/neofax_full.json     (199 Neofax
//     drugs, fully authored)
//
// The two source schemas differ; this class normalises them into a single
// `DrugV2` shape that the premium drug-detail screen renders. All content
// from the source JSON is preserved verbatim — granular fields are split
// out so the renderer can color-code and section them, but no information
// is dropped.
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

/// Single Indian formulation entry (Neofax has these structured; HL doesn't).
class FormulationEntry {
  final String form;
  final String strength;
  final List<String> brandsIndia;
  final String notes;
  const FormulationEntry({
    required this.form,
    required this.strength,
    required this.brandsIndia,
    required this.notes,
  });

  factory FormulationEntry.fromJson(Map<String, dynamic> j) => FormulationEntry(
        form: ((j['form'] as String?) ?? '').trim(),
        strength: ((j['strength'] as String?) ?? '').trim(),
        brandsIndia: ((j['brands_india'] as List?) ?? const [])
            .map((e) => '$e').toList(),
        notes: ((j['notes'] as String?) ?? '').trim(),
      );
}

/// A single drug — either Harriet Lane (v3 restructured) or Neofax (v2).
/// All content fields below are preserved verbatim from the source JSON.
class DrugV2 {
  final String id;
  final String drug;
  final List<String> altNames;
  final String category;
  final String atcCode;
  final int page;
  final String source; // 'Harriet Lane' or 'Neofax'
  final bool hidden;

  // Dose data — both schemas
  final List<DoseBlock> doseBlocks;
  final String rawDoseMd;
  final List<String> callouts;

  // Indian formulations (Neofax-only currently)
  final List<FormulationEntry> formulations;

  // Granular text sections — all preserved verbatim, never truncated.
  final String cautionsMd;          // contraindications + cautions
  final String monitoringMd;        // monitoring guidance
  final String adverseEffectsMd;    // adverse events
  final String pharmacokineticsMd;  // PK (HL only)
  final String pearlsMd;            // clinical pearls
  final String reconstitutionMd;    // preparation (Neofax)
  final String incompatibilitiesMd; // IV incompatibilities (Neofax)
  final String renalAdjustmentMd;   // renal adjustment (Neofax)
  final String hepaticAdjustmentMd; // hepatic adjustment (Neofax)

  const DrugV2({
    required this.id,
    required this.drug,
    required this.altNames,
    required this.category,
    required this.atcCode,
    required this.page,
    required this.source,
    required this.hidden,
    required this.doseBlocks,
    required this.rawDoseMd,
    required this.callouts,
    required this.formulations,
    required this.cautionsMd,
    required this.monitoringMd,
    required this.adverseEffectsMd,
    required this.pharmacokineticsMd,
    required this.pearlsMd,
    required this.reconstitutionMd,
    required this.incompatibilitiesMd,
    required this.renalAdjustmentMd,
    required this.hepaticAdjustmentMd,
  });

  bool get isNeofax => source.toLowerCase().contains('neofax');
  bool get isHarrietLane => source.toLowerCase().contains('harriet');

  factory DrugV2.fromHL(Map<String, dynamic> j) => DrugV2(
        id: (j['id'] as String?) ?? '',
        drug: (j['drug'] as String?) ?? '',
        altNames: ((j['alt_names'] as List?) ?? const []).map((e) => '$e').toList(),
        category: (j['category'] as String?) ?? '',
        atcCode: (j['atc_code'] as String?) ?? '',
        page: (j['page'] as num?)?.toInt() ?? 0,
        source: 'Harriet Lane',
        hidden: (j['hidden'] as bool?) ?? false,
        doseBlocks: ((j['dose_blocks'] as List?) ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(DoseBlock.fromJson)
            .toList(),
        rawDoseMd: (j['raw_dose_md'] as String?) ?? '',
        callouts: ((j['callouts'] as List?) ?? const []).map((e) => '$e').toList(),
        formulations: const [],
        cautionsMd: (j['cautions_md'] as String?) ?? '',
        monitoringMd: (j['monitoring_md'] as String?) ?? '',
        adverseEffectsMd: (j['adverse_effects_md'] as String?) ?? '',
        pharmacokineticsMd: (j['pharmacokinetics_md'] as String?) ?? '',
        pearlsMd: (j['pearls_md'] as String?) ?? '',
        reconstitutionMd: '',
        incompatibilitiesMd: '',
        renalAdjustmentMd: '',
        hepaticAdjustmentMd: '',
      );

  /// Adapt the Neofax schema to our normalized shape. `doses` is a list of
  /// structured rows (indication / route / loading_dose_per_kg /
  /// dose_per_kg_per_dose / frequency / max_per_dose / comments) — we
  /// group them by indication and emit one DosePopulation per row.
  factory DrugV2.fromNeofax(Map<String, dynamic> j) {
    final doseRows = ((j['doses'] as List?) ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();

    // Group dose rows by indication, preserving original order.
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
        final dur   = ((r['duration'] as String?) ?? '').trim();
        final cmt   = ((r['comments'] as String?) ?? '').trim();

        // Build the dose narrative as Markdown — every field included.
        final parts = <String>[];
        if (load.isNotEmpty)   parts.add('**Loading:** $load');
        if (dose.isNotEmpty)   parts.add('**Dose:** $dose');
        if (freq.isNotEmpty)   parts.add('**Frequency:** $freq');
        if (inf.isNotEmpty)    parts.add('**Infusion rate:** $inf');
        if (dur.isNotEmpty)    parts.add('**Duration:** $dur');
        if (maxD.isNotEmpty)   parts.add('**Max per dose:** $maxD');
        if (maxDay.isNotEmpty) parts.add('**Max per day:** $maxDay');
        if (cmt.isNotEmpty)    parts.add(cmt);
        final doseMd = parts.join('  \n');

        final labelParts = <String>[];
        if (ga.isNotEmpty)  labelParts.add(ga);
        if (pma.isNotEmpty) labelParts.add(pma);
        if (pna.isNotEmpty) labelParts.add(pna);
        final label = labelParts.isEmpty ? '' : labelParts.join(' · ');

        return DosePopulation(
          label: label,
          routeHint: route, // keep original casing — it can be a long phrase
          doseMd: doseMd,
        );
      }).toList();
      blocks.add(DoseBlock(indication: ind, populations: pops));
    });

    final formulations = ((j['india_formulations'] as List?) ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(FormulationEntry.fromJson)
        .toList();

    return DrugV2(
      id: (j['id'] as String?) ?? '',
      drug: (j['drug'] as String?) ?? '',
      altNames: ((j['alt_names'] as List?) ?? const []).map((e) => '$e').toList(),
      category: (j['category'] as String?) ?? '',
      atcCode: (j['atc_code'] as String?) ?? '',
      page: ((j['sources'] as Map?)?['primary_neofax_page'] as num?)?.toInt() ?? 0,
      source: 'Neofax',
      hidden: false,
      doseBlocks: blocks,
      rawDoseMd: '',
      callouts: const [],
      formulations: formulations,
      cautionsMd:          (j['contraindications']  as String?) ?? '',
      monitoringMd:        (j['monitoring']         as String?) ?? '',
      adverseEffectsMd:    (j['adverse_effects']    as String?) ?? '',
      pharmacokineticsMd:  '',
      pearlsMd:            (j['pearl']              as String?) ?? '',
      reconstitutionMd:    (j['reconstitution']     as String?) ?? '',
      incompatibilitiesMd: (j['incompatibilities']  as String?) ?? '',
      renalAdjustmentMd:   (j['renal_adjustment']   as String?) ?? '',
      hepaticAdjustmentMd: (j['hepatic_adjustment'] as String?) ?? '',
    );
  }
}

class FormularyV2Service {
  static final FormularyV2Service _instance = FormularyV2Service._internal();
  factory FormularyV2Service() => _instance;
  FormularyV2Service._internal();

  Map<String, DrugV2>? _byId;
  // Index by canonical lowercase name AND by every alt-name lowercased,
  // so a list entry like "Acetaminophen" still resolves to the canonical
  // Neofax record "Paracetamol (Acetaminophen)" (alt_names contains
  // "Acetaminophen").
  Map<String, DrugV2>? _byNameLowerHL;
  Map<String, DrugV2>? _byNameLowerNeofax;

  Future<void> _ensureLoaded() async {
    if (_byId != null) return;

    final byId = <String, DrugV2>{};
    final byNameHL = <String, DrugV2>{};
    final byNameNF = <String, DrugV2>{};

    void index(Map<String, DrugV2> map, DrugV2 d) {
      map[d.drug.toLowerCase()] = d;
      // Strip parenthetical synonyms in the canonical name so
      // "Paracetamol (Acetaminophen)" also indexes under "paracetamol".
      final stripped = d.drug.replaceAll(RegExp(r'\s*\([^)]*\)'), '').trim();
      if (stripped.isNotEmpty && stripped.toLowerCase() != d.drug.toLowerCase()) {
        map.putIfAbsent(stripped.toLowerCase(), () => d);
      }
      for (final alt in d.altNames) {
        final k = alt.trim().toLowerCase();
        if (k.isEmpty) continue;
        // Don't overwrite a canonical-name match with an alt-name match.
        map.putIfAbsent(k, () => d);
      }
    }

    // ── Harriet Lane (v3 restructured) ──────────────────────────────
    try {
      final raw = await rootBundle.loadString(
          'assets/data/formulary/formulary_v2/harrietlane_v3.json');
      final j = json.decode(raw) as Map<String, dynamic>;
      for (final d in (j['drugs'] as List)) {
        final drug = DrugV2.fromHL(d as Map<String, dynamic>);
        if (drug.id.isEmpty) continue;
        byId[drug.id] = drug;
        index(byNameHL, drug);
      }
    } catch (_) {
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
        index(byNameNF, drug);
      }
    } catch (_) {}

    _byId = byId;
    _byNameLowerHL = byNameHL;
    _byNameLowerNeofax = byNameNF;
  }

  Future<DrugV2?> findByName(String name, {required String source}) async {
    await _ensureLoaded();
    final key = name.trim().toLowerCase();
    final pool = source.toLowerCase().contains('neofax')
        ? _byNameLowerNeofax
        : _byNameLowerHL;
    if (pool == null) return null;
    final hit = pool[key];
    if (hit != null) return hit;
    return _matchClosest(key, pool);
  }

  DrugV2? _matchClosest(String key, Map<String, DrugV2> map) {
    // Prefix or contains-key fallback so partial / casing differences
    // between the search index and the canonical name still resolve.
    for (final entry in map.entries) {
      if (entry.key.startsWith(key)) return entry.value;
    }
    for (final entry in map.entries) {
      if (entry.key.contains(key)) return entry.value;
    }
    return null;
  }
}
