// =============================================================================
// lib/screens/guides/developmental_milestones/dev_milestones_list_view.dart
//
// Plain list view — every milestone in the AIIMS handout grouped by domain.
// Six expandable sections, age-ascending within each, complete reference.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dev_milestones_data.dart';

class DevMilestonesListView extends StatelessWidget {
  const DevMilestonesListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Group postnatal first, prenatal entries (29w IU, 26w IU) appear at
    // the very top of their domain because they have negative ageMonths.
    final byDomain = <DevDomain, List<Milestone>>{
      for (final d in DevDomain.values) d: <Milestone>[],
    };
    for (final m in kMilestones) {
      byDomain[m.domain]!.add(m);
    }
    for (final list in byDomain.values) {
      list.sort((a, b) => a.ageMonths.compareTo(b.ageMonths));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse by Domain'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: SafeArea(
        bottom: true,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
          children: [
            for (final entry in byDomain.entries)
              _DomainExpansionCard(
                domain: entry.key,
                milestones: entry.value,
              ),
          ],
        ),
      ),
    );
  }
}

class _DomainExpansionCard extends StatelessWidget {
  final DevDomain domain;
  final List<Milestone> milestones;
  const _DomainExpansionCard({
    required this.domain,
    required this.milestones,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final info = kDomainInfo[domain]!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.55)),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: domain == DevDomain.grossMotor,
        tilePadding: const EdgeInsets.symmetric(horizontal: 14),
        childrenPadding: EdgeInsets.zero,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: info.color.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(info.icon, color: info.color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                  Text(
                    '${milestones.length} milestones',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: info.color, width: 3),
                top: BorderSide(
                    color: cs.outlineVariant.withValues(alpha: 0.4)),
              ),
            ),
            child: Column(
              children: [
                for (int i = 0; i < milestones.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 0,
                      indent: 14,
                      endIndent: 14,
                      color: cs.outlineVariant.withValues(alpha: 0.4),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 78,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                milestones[i].ageLabel,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: info.color,
                                ),
                              ),
                              if (milestones[i].prenatal)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    'Prenatal',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.4,
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            milestones[i].description,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              height: 1.45,
                              fontWeight: FontWeight.w500,
                              color: cs.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
