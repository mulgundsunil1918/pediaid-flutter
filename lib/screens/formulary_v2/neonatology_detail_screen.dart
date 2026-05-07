// =============================================================================
// neonatology_detail_screen.dart
// Detail view for a single v2 drug — shows India formulations, dose table,
// monitoring, AE, contraindications, sources.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'formulary_v2_service.dart';

class NeonatologyDetailScreen extends StatelessWidget {
  final FormularyV2Drug drug;
  const NeonatologyDetailScreen({super.key, required this.drug});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(drug.drug,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 16, fontWeight: FontWeight.w800)),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 32),
        children: [
          // Header card
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0).withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0xFF1565C0).withValues(alpha: 0.30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(drug.drug,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0D47A1))),
                if (drug.altNames.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text('Also known as: ${drug.altNames.join(", ")}',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: cs.onSurface.withValues(alpha: 0.7))),
                ],
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (drug.category.isNotEmpty)
                      _chip(drug.category, const Color(0xFF1565C0)),
                    if ((drug.atcCode ?? '').isNotEmpty)
                      _chip('ATC ${drug.atcCode}', const Color(0xFF6A1B9A)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Reference banner — notes summarised from Neofax
          if (drug.sources['primary_neofax_page'] != null) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE7F6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color(0xFF5E35B1).withValues(alpha: 0.30)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.book_outlined,
                      color: Color(0xFF4527A0), size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Reference: notes summarised from Neofax NOV 2024 '
                      'p.${drug.sources['primary_neofax_page']} '
                      '· cross-checked against ${(drug.sources['cross_checks'] as List?)?.length ?? 0} '
                      'authoritative sources',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: const Color(0xFF4527A0),
                          fontWeight: FontWeight.w600,
                          height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Black box warning if present
          if ((drug.blackBoxWarning ?? '').isNotEmpty) ...[
            _alertCard(
                title: '⚠ BLACK-BOX WARNING',
                body: drug.blackBoxWarning!,
                bg: const Color(0xFFFFEBEE),
                fg: const Color(0xFFB71C1C),
                border: const Color(0xFFEF9A9A)),
            const SizedBox(height: 12),
          ],

          // India formulations
          if (drug.indiaFormulations.isNotEmpty) ...[
            _sectionHeader('India formulations (oral / topical only)'),
            ...drug.indiaFormulations.map((f) => _formulationCard(f)),
            const SizedBox(height: 12),
          ],

          // Doses
          _sectionHeader('Dose table'),
          ...drug.doses.map((d) => _doseCard(d)),
          const SizedBox(height: 12),

          // Administration
          if ((drug.administration ?? '').isNotEmpty) ...[
            _sectionHeader('Administration'),
            _bodyText(drug.administration!),
            const SizedBox(height: 12),
          ],
          if ((drug.infusionPreparation ?? '').isNotEmpty) ...[
            _sectionHeader('Infusion preparation'),
            _bodyText(drug.infusionPreparation!),
            const SizedBox(height: 12),
          ],
          if ((drug.reconstitution ?? '').isNotEmpty) ...[
            _sectionHeader('Reconstitution'),
            _bodyText(drug.reconstitution!),
            const SizedBox(height: 12),
          ],

          // Monitoring
          if ((drug.monitoring ?? '').isNotEmpty) ...[
            _sectionHeader('Monitoring'),
            _bodyText(drug.monitoring!),
            const SizedBox(height: 12),
          ],

          // Adverse effects
          if ((drug.adverseEffects ?? '').isNotEmpty) ...[
            _sectionHeader('Adverse effects'),
            _bodyText(drug.adverseEffects!),
            const SizedBox(height: 12),
          ],

          // Contraindications
          if ((drug.contraindications ?? '').isNotEmpty) ...[
            _sectionHeader('Contraindications / Precautions'),
            _bodyText(drug.contraindications!),
            const SizedBox(height: 12),
          ],

          // Renal / Hepatic adjustments
          if ((drug.renalAdjustment ?? '').isNotEmpty) ...[
            _sectionHeader('Renal adjustment'),
            _bodyText(drug.renalAdjustment!),
            const SizedBox(height: 12),
          ],
          if ((drug.hepaticAdjustment ?? '').isNotEmpty) ...[
            _sectionHeader('Hepatic adjustment'),
            _bodyText(drug.hepaticAdjustment!),
            const SizedBox(height: 12),
          ],

          // Incompatibilities
          if ((drug.incompatibilities ?? '').isNotEmpty) ...[
            _sectionHeader('Incompatibilities'),
            _bodyText(drug.incompatibilities!),
            const SizedBox(height: 12),
          ],

          // Pearl
          if ((drug.pearl ?? '').isNotEmpty) ...[
            _alertCard(
                title: '💡 Clinical pearl',
                body: drug.pearl!,
                bg: const Color(0xFFFFF8E1),
                fg: const Color(0xFF8B5300),
                border: const Color(0xFFFFD180)),
            const SizedBox(height: 12),
          ],

          // Sources
          _sectionHeader('Sources & cross-checks'),
          _sourcesCard(drug.sources),
          const SizedBox(height: 12),

          // Review status
          _reviewStatusCard(drug.review),
          const SizedBox(height: 18),

          // Footer disclaimer
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: cs.onSurface.withValues(alpha: 0.10))),
            child: Text(
              'PediAid v2 Neonatology Formulary — DRAFT entry, pending '
              'clinician review. Verify every dose against your local '
              'protocol and current vial / formulation strength before '
              'administration. PediAid assumes no liability.',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: cs.onSurface.withValues(alpha: 0.65),
                  fontStyle: FontStyle.italic,
                  height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String s) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Text(s.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                color: const Color(0xFF1565C0))),
      );

  Widget _bodyText(String s) => Builder(builder: (ctx) {
        final cs = Theme.of(ctx).colorScheme;
        return Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          decoration: BoxDecoration(
              color: Theme.of(ctx).cardColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: cs.onSurface.withValues(alpha: 0.10))),
          child: Text(s,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  height: 1.5,
                  color: cs.onSurface.withValues(alpha: 0.85))),
        );
      });

  Widget _formulationCard(Map<String, dynamic> f) {
    final form = (f['form'] ?? '') as String;
    final strength = (f['strength'] ?? '') as String;
    final brands = ((f['brands_india'] as List?) ?? const []).cast<String>();
    final notes = (f['notes'] ?? '') as String;
    return Builder(builder: (ctx) {
      final cs = Theme.of(ctx).colorScheme;
      return Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.fromLTRB(12, 9, 12, 11),
        decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD).withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: const Color(0xFF1565C0).withValues(alpha: 0.25))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(form,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D47A1))),
            if (strength.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(strength,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: cs.onSurface.withValues(alpha: 0.85),
                      height: 1.4)),
            ],
            if (brands.isNotEmpty) ...[
              const SizedBox(height: 5),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: brands
                    .map((b) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                              color: const Color(0xFF1565C0)
                                  .withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(b,
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0D47A1))),
                        ))
                    .toList(),
              ),
            ],
            if (notes.isNotEmpty) ...[
              const SizedBox(height: 5),
              Text(notes,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: cs.onSurface.withValues(alpha: 0.65),
                      height: 1.4)),
            ],
          ],
        ),
      );
    });
  }

  Widget _doseCard(Map<String, dynamic> d) {
    final indication = (d['indication'] ?? '') as String;
    final route = (d['route'] ?? '') as String;
    final ga = (d['ga_band'] ?? '') as String;
    final pma = (d['pma_band'] ?? '') as String?;
    final pna = (d['postnatal_age_band'] ?? '') as String?;
    final load = (d['loading_dose_per_kg'] ?? '') as String?;
    final dose = (d['dose_per_kg_per_dose'] ?? '') as String?;
    final freq = (d['frequency'] ?? '') as String?;
    final maxPerDose = (d['max_per_dose'] ?? '') as String?;
    final maxDay = (d['max_per_day_all_routes'] ?? '') as String?;
    final infRate = (d['infusion_rate'] ?? '') as String?;
    final dpkpmStart = (d['dose_per_kg_per_min_starting'] ?? '') as String?;
    final dpkpmRange = (d['dose_per_kg_per_min_range'] ?? '') as String?;
    final dur = (d['duration'] ?? '') as String?;
    final comments = (d['comments'] ?? '') as String?;

    return Builder(builder: (ctx) {
      final cs = Theme.of(ctx).colorScheme;
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
            color: Theme.of(ctx).cardColor,
            borderRadius: BorderRadius.circular(10),
            border: Border(
              left: const BorderSide(color: Color(0xFF1565C0), width: 4),
              top: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
              right: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
              bottom: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indication
            Text(indication,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D47A1))),
            const SizedBox(height: 4),
            // Route + bands
            Wrap(
              spacing: 4,
              runSpacing: 3,
              children: [
                if (route.isNotEmpty) _smChip(route, const Color(0xFF1565C0)),
                if (ga.isNotEmpty) _smChip(ga, const Color(0xFF00838F)),
                if ((pma ?? '').isNotEmpty)
                  _smChip('PMA: $pma', const Color(0xFF00838F)),
                if ((pna ?? '').isNotEmpty)
                  _smChip('Postnatal: $pna', const Color(0xFF00838F)),
              ],
            ),
            const SizedBox(height: 6),
            // KV pairs
            if ((load ?? '').isNotEmpty) _kv('Load', load!),
            if ((dose ?? '').isNotEmpty) _kv('Dose', dose!),
            if ((dpkpmStart ?? '').isNotEmpty) _kv('Start', dpkpmStart!),
            if ((dpkpmRange ?? '').isNotEmpty) _kv('Range', dpkpmRange!),
            if ((freq ?? '').isNotEmpty) _kv('Freq', freq!),
            if ((maxPerDose ?? '').isNotEmpty) _kv('Max', maxPerDose!),
            if ((maxDay ?? '').isNotEmpty) _kv('Max/day', maxDay!),
            if ((infRate ?? '').isNotEmpty) _kv('Rate', infRate!),
            if ((dur ?? '').isNotEmpty) _kv('Duration', dur!),
            if ((comments ?? '').isNotEmpty) ...[
              const SizedBox(height: 5),
              Text(comments!,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: cs.onSurface.withValues(alpha: 0.7),
                      fontStyle: FontStyle.italic,
                      height: 1.4)),
            ],
          ],
        ),
      );
    });
  }

  Widget _kv(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 64,
                child: Text(label,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1565C0)))),
            Expanded(
              child: Text(value,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12, height: 1.4)),
            ),
          ],
        ),
      );

  Widget _smChip(String s, Color c) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
            color: c.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(6)),
        child: Text(s,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: c,
                letterSpacing: 0.2)),
      );

  Widget _chip(String s, Color c) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            color: c.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20)),
        child: Text(s,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5, fontWeight: FontWeight.w800, color: c)),
      );

  Widget _alertCard({
    required String title,
    required String body,
    required Color bg,
    required Color fg,
    required Color border,
  }) =>
      Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border, width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: fg,
                    letterSpacing: 0.4)),
            const SizedBox(height: 4),
            Text(body,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, color: fg, height: 1.45)),
          ],
        ),
      );

  Widget _sourcesCard(Map<String, dynamic> sources) {
    final page = sources['primary_neofax_page'];
    final crossChecks =
        ((sources['cross_checks'] as List?) ?? const [])
            .cast<Map<String, dynamic>>();
    return Builder(builder: (ctx) {
      final cs = Theme.of(ctx).colorScheme;
      return Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
        decoration: BoxDecoration(
            color: Theme.of(ctx).cardColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: cs.onSurface.withValues(alpha: 0.10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Primary source: Neofax NOV 2024 page $page',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface.withValues(alpha: 0.85))),
            const SizedBox(height: 6),
            if (crossChecks.isNotEmpty) ...[
              Text('CROSS-CHECKS',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: cs.onSurface.withValues(alpha: 0.55))),
              const SizedBox(height: 4),
              ...crossChecks.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('✓ ',
                            style: TextStyle(color: Color(0xFF2E7D32))),
                        Expanded(
                          child: Text(
                              '${c['source'] ?? ''} — ${c['agreement'] ?? ''}',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: cs.onSurface.withValues(alpha: 0.75),
                                  height: 1.4)),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      );
    });
  }

  Widget _reviewStatusCard(Map<String, dynamic> review) {
    final status = (review['status'] ?? 'unknown') as String;
    final notes = (review['notes'] ?? '') as String;
    final color = status == 'published'
        ? const Color(0xFF2E7D32)
        : const Color(0xFFE65100);
    return Builder(builder: (ctx) {
      final cs = Theme.of(ctx).colorScheme;
      return Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.fact_check_outlined, color: color, size: 16),
                const SizedBox(width: 6),
                Text('Review status: ${status.replaceAll("_", " ")}',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: color)),
              ],
            ),
            if (notes.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(notes,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: cs.onSurface.withValues(alpha: 0.7),
                      fontStyle: FontStyle.italic,
                      height: 1.4)),
            ],
          ],
        ),
      );
    });
  }
}
