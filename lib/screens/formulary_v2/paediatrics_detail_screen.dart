// =============================================================================
// paediatrics_detail_screen.dart
// Detail view for a single Paediatrics (Harriet Lane-derived) drug.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'formulary_v2_service.dart';

class PaediatricsDetailScreen extends StatelessWidget {
  final FormularyV2Drug drug;
  const PaediatricsDetailScreen({super.key, required this.drug});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hlPage = drug.sources['primary_harriet_lane_page'];

    return Scaffold(
      appBar: AppBar(
        title: Text(drug.drug,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 16, fontWeight: FontWeight.w800)),
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 32),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            decoration: BoxDecoration(
              color: const Color(0xFF6A1B9A).withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color:
                      const Color(0xFF6A1B9A).withValues(alpha: 0.30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(drug.drug,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF4A148C))),
                if (drug.altNames.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text('Brand names: ${drug.altNames.join(", ")}',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: cs.onSurface.withValues(alpha: 0.7))),
                ],
                if (drug.category.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: const Color(0xFF6A1B9A)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(drug.category,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF6A1B9A))),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Reference banner
          if (hlPage != null) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE7F6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color:
                        const Color(0xFF5E35B1).withValues(alpha: 0.30)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.book_outlined,
                      color: Color(0xFF4527A0), size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Reference: notes auto-extracted from Harriet Lane '
                      'Handbook p.$hlPage. Awaiting manual authoring '
                      '(India brands + cross-checks).',
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

          // Available formulations (parsed from HL)
          if (drug.indiaFormulations.isNotEmpty) ...[
            _sectionHeader('Available formulations'),
            ...drug.indiaFormulations.map((f) {
              final strength = (f['strength'] ?? '') as String;
              final notes = (f['notes'] ?? '') as String;
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.fromLTRB(12, 9, 12, 11),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5).withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFF6A1B9A)
                          .withValues(alpha: 0.25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (strength.isNotEmpty)
                      Text(strength,
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: cs.onSurface.withValues(alpha: 0.85),
                              height: 1.45)),
                    if (notes.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(notes,
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: cs.onSurface.withValues(alpha: 0.65),
                              fontStyle: FontStyle.italic,
                              height: 1.4)),
                    ],
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
          ],

          // Doses (raw text from HL — clinician will refine)
          _sectionHeader('Dosing'),
          ...drug.doses.map((d) => _doseCard(d)),
          const SizedBox(height: 12),

          // Black-box warning (added by PediAid for some entries)
          if ((drug.blackBoxWarning ?? '').isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFEF9A9A), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('⚠ BLACK-BOX WARNING',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFB71C1C),
                          letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(drug.blackBoxWarning!,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: const Color(0xFFB71C1C),
                          height: 1.45)),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Adverse effects
          if ((drug.adverseEffects ?? '').isNotEmpty) ...[
            _sectionHeader('Adverse effects'),
            _bodyText(drug.adverseEffects!),
            const SizedBox(height: 12),
          ],

          // Contraindications / Cautions
          if ((drug.contraindications ?? '').isNotEmpty) ...[
            _sectionHeader('Cautions / Contraindications'),
            _bodyText(drug.contraindications!),
            const SizedBox(height: 12),
          ],

          // Drug interactions
          if ((drug.incompatibilities ?? '').isNotEmpty) ...[
            _sectionHeader('Drug interactions'),
            _bodyText(drug.incompatibilities!),
            const SizedBox(height: 12),
          ],

          // Monitoring (from PediAid augmentation)
          if ((drug.monitoring ?? '').isNotEmpty) ...[
            _sectionHeader('Monitoring'),
            _bodyText(drug.monitoring!),
            const SizedBox(height: 12),
          ],

          // Pharmacokinetics (T1/2, etc.)
          if ((drug.pharmacokinetics ?? '').isNotEmpty) ...[
            _sectionHeader('Pharmacokinetics'),
            _bodyText(drug.pharmacokinetics!),
            const SizedBox(height: 12),
          ],

          // Other comments / pearls
          if ((drug.pearl ?? '').isNotEmpty) ...[
            _sectionHeader('Other comments'),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color:
                          const Color(0xFFFFB300).withValues(alpha: 0.6))),
              child: Text(drug.pearl!,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: const Color(0xFF7F4F00),
                      height: 1.5)),
            ),
            const SizedBox(height: 12),
          ],

          // Source
          _sectionHeader('Source'),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: cs.onSurface.withValues(alpha: 0.10))),
            child: Text(
                'Harriet Lane Handbook (Mosby/Elsevier, 22nd ed) — page $hlPage. '
                'Cross-checks against WHO WMFc, IAP STG, BNFc, AAP Red Book '
                'pending manual authoring.',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: cs.onSurface.withValues(alpha: 0.7),
                    height: 1.45)),
          ),
          const SizedBox(height: 18),

          // Footer disclaimer
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color(0xFFEF9A9A))),
            child: Text(
              'BETA — auto-extracted entry. India brands and cross-checks '
              'NOT yet added. Verify every dose against your local '
              'protocol and current vial / formulation strength before '
              'administration. PediAid assumes no liability.',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: const Color(0xFFB71C1C),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _sectionHeader(String s) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Text(s.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                color: const Color(0xFF6A1B9A))),
      );

  Widget _doseCard(Map<String, dynamic> d) {
    final indication = (d['indication'] ?? '') as String;
    final comments = (d['comments'] ?? '') as String;
    return Builder(builder: (ctx) {
      final cs = Theme.of(ctx).colorScheme;
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
            color: Theme.of(ctx).cardColor,
            borderRadius: BorderRadius.circular(10),
            border: Border(
              left: const BorderSide(color: Color(0xFF6A1B9A), width: 4),
              top: BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
              right:
                  BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
              bottom:
                  BorderSide(color: cs.onSurface.withValues(alpha: 0.10)),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (indication.isNotEmpty) ...[
              Text(indication,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF4A148C))),
              const SizedBox(height: 6),
            ],
            if (comments.isNotEmpty)
              Text(comments,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: cs.onSurface.withValues(alpha: 0.85),
                      height: 1.5)),
          ],
        ),
      );
    });
  }
}
