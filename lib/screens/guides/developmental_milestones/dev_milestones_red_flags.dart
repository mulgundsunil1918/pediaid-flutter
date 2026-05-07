// =============================================================================
// lib/screens/guides/developmental_milestones/dev_milestones_red_flags.dart
//
// Every age × domain red flag from the AIIMS handout, sorted age-ascending
// and grouped by domain. Each row reads as: "by age X, child not doing Y →
// flag for assessment".
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dev_milestones_data.dart';

class DevMilestonesRedFlags extends StatelessWidget {
  const DevMilestonesRedFlags({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final byDomain = <DevDomain, List<RedFlag>>{
      for (final d in DevDomain.values) d: <RedFlag>[],
    };
    for (final f in kRedFlags) {
      byDomain[f.domain]!.add(f);
    }
    for (final list in byDomain.values) {
      list.sort((a, b) => a.ageMonths.compareTo(b.ageMonths));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Red Flags'),
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
            // Header advisory
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              decoration: BoxDecoration(
                color: const Color(0xFFB71C1C).withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFB71C1C).withValues(alpha: 0.30)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Color(0xFFB71C1C), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'A red flag is when the listed milestone has NOT been achieved by the listed age. It does not mean pathology — it means formal developmental assessment is warranted.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFB71C1C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            for (final entry in byDomain.entries)
              if (entry.value.isNotEmpty)
                _DomainFlagsCard(
                  domain: entry.key,
                  flags: entry.value,
                ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'When to refer:\n• Single-domain delay → screen for sensory deficit, environmental factors, then reassess in 3 months.\n• Two or more domains delayed → Global Developmental Delay → refer for full assessment + early intervention.\n• Loss of previously acquired skills (regression) → URGENT neurology referral.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  height: 1.55,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DomainFlagsCard extends StatelessWidget {
  final DevDomain domain;
  final List<RedFlag> flags;
  const _DomainFlagsCard({required this.domain, required this.flags});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final info = kDomainInfo[domain]!;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.55)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
            decoration: BoxDecoration(
              color: const Color(0xFFB71C1C).withValues(alpha: 0.08),
              border: const Border(
                left: BorderSide(color: Color(0xFFB71C1C), width: 3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: info.color.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(info.icon, color: info.color, size: 17),
                ),
                const SizedBox(width: 10),
                Text(
                  info.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  '${flags.length} flags',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFB71C1C),
                  ),
                ),
              ],
            ),
          ),
          for (int i = 0; i < flags.length; i++) ...[
            if (i > 0)
              Divider(
                height: 0,
                color: cs.outlineVariant.withValues(alpha: 0.4),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB71C1C).withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      flags[i].ageLabel,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFB71C1C),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      flags[i].description,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
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
    );
  }
}
