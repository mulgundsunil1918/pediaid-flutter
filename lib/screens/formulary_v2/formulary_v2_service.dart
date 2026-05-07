// =============================================================================
// formulary_v2_service.dart
// Singleton service that loads + caches the Neonatology v2 formulary
// (assets/data/formulary/formulary_v2/neofax_full.json).
// =============================================================================

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class FormularyV2Drug {
  final String id;
  final String drug;
  final List<String> altNames;
  final String category;
  final String? atcCode;
  final List<Map<String, dynamic>> indiaFormulations;
  final List<Map<String, dynamic>> doses;
  final String? monitoring;
  final String? adverseEffects;
  final String? contraindications;
  final String? renalAdjustment;
  final String? hepaticAdjustment;
  final String? incompatibilities;
  final String? reconstitution;
  final String? administration;
  final String? blackBoxWarning;
  final String? infusionPreparation;
  final String? pearl;
  final String? pharmacokinetics;
  final Map<String, dynamic> sources;
  final Map<String, dynamic> review;

  FormularyV2Drug.fromJson(Map<String, dynamic> j)
      : id = j['id'] as String,
        drug = j['drug'] as String,
        altNames = (j['alt_names'] as List?)?.cast<String>() ?? const [],
        category = (j['category'] as String?) ?? '',
        atcCode = j['atc_code'] as String?,
        indiaFormulations =
            ((j['india_formulations'] as List?) ?? const [])
                .cast<Map<String, dynamic>>(),
        doses = ((j['doses'] as List?) ?? const [])
            .cast<Map<String, dynamic>>(),
        monitoring = j['monitoring'] as String?,
        adverseEffects = j['adverse_effects'] as String?,
        contraindications = j['contraindications'] as String?,
        renalAdjustment = j['renal_adjustment'] as String?,
        hepaticAdjustment = j['hepatic_adjustment'] as String?,
        incompatibilities = j['incompatibilities'] as String?,
        reconstitution = j['reconstitution'] as String?,
        administration = j['administration'] as String?,
        blackBoxWarning = j['black_box_warning'] as String?,
        infusionPreparation = j['infusion_preparation'] as String?,
        pearl = j['pearl'] as String?,
        pharmacokinetics = j['pharmacokinetics'] as String?,
        sources = (j['sources'] as Map?)?.cast<String, dynamic>() ??
            const {},
        review = (j['review'] as Map?)?.cast<String, dynamic>() ?? const {};
}

class FormularyV2Service {
  FormularyV2Service._();
  static final FormularyV2Service instance = FormularyV2Service._();

  List<FormularyV2Drug>? _neonatologyCache;
  List<FormularyV2Drug>? _paediatricsCache;

  Future<List<FormularyV2Drug>> loadNeonatology() async {
    if (_neonatologyCache != null) return _neonatologyCache!;
    final raw = await rootBundle.loadString(
        'assets/data/formulary/formulary_v2/neofax_full.json');
    final m = json.decode(raw) as Map<String, dynamic>;
    final drugs = (m['drugs'] as List)
        .cast<Map<String, dynamic>>()
        .map(FormularyV2Drug.fromJson)
        .toList();
    _neonatologyCache = drugs;
    return drugs;
  }

  Future<List<FormularyV2Drug>> loadPaediatrics() async {
    if (_paediatricsCache != null) return _paediatricsCache!;
    final raw = await rootBundle.loadString(
        'assets/data/formulary/formulary_v2/harrietlane_full.json');
    final m = json.decode(raw) as Map<String, dynamic>;
    final drugs = (m['drugs'] as List)
        .cast<Map<String, dynamic>>()
        .map(FormularyV2Drug.fromJson)
        .toList();
    _paediatricsCache = drugs;
    return drugs;
  }
}
