// =============================================================================
// lib/screens/guides/developmental_milestones/dev_milestones_smart_view.dart
//
// Bidirectional smart view:
//   1. By Age      — pick chronological age → see expected milestones across
//                    all six domains + every red flag activated by that age.
//   2. By Behaviour — tick the milestones the child has achieved → app
//                    estimates developmental age per domain (max age of
//                    ticked items in each domain). Optional CA input gives
//                    DQ per domain on the fly.
//
// Both modes use the same milestone data (lib/.../dev_milestones_data.dart).
// Source: AIIMS New Delhi · Sheffali Gulati handout, verbatim.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dev_milestones_data.dart';

class DevMilestonesSmartView extends StatefulWidget {
  const DevMilestonesSmartView({super.key});

  @override
  State<DevMilestonesSmartView> createState() => _DevMilestonesSmartViewState();
}

class _DevMilestonesSmartViewState extends State<DevMilestonesSmartView>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart View'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        bottom: TabBar(
          controller: _tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'By Age', icon: Icon(Icons.cake_outlined, size: 18)),
            Tab(
                text: 'By Behaviour',
                icon: Icon(Icons.check_circle_outline_rounded, size: 18)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [
          _ByAgeMode(),
          _ByBehaviourMode(),
        ],
      ),
    );
  }
}

// ─── BY AGE MODE ─────────────────────────────────────────────────────────────

class _ByAgeMode extends StatefulWidget {
  const _ByAgeMode();
  @override
  State<_ByAgeMode> createState() => _ByAgeModeState();
}

class _ByAgeModeState extends State<_ByAgeMode> {
  // Default 12 months — most useful first-load value (covers ~half of all
  // milestones in the AIIMS handout).
  double _ageMonths = 12;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final byDomain = milestonesUpTo(_ageMonths);
    final flags = redFlagsAtOrBefore(_ageMonths);
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      children: [
        // Age picker
        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.cake_outlined, size: 18, color: cs.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Chronological age',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                      color: cs.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _ageDisplay(_ageMonths),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 14),
                ),
                child: Slider(
                  value: _ageMonths,
                  min: 0,
                  max: 60,
                  divisions: 120, // 0.5-month resolution
                  onChanged: (v) => setState(() => _ageMonths = v),
                ),
              ),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final preset in const [
                    1.0, 3.0, 6.0, 9.0, 12.0, 18.0, 24.0, 36.0, 48.0, 60.0,
                  ])
                    _AgePresetChip(
                      label: _ageDisplay(preset),
                      isSelected: (preset - _ageMonths).abs() < 0.1,
                      onTap: () => setState(() => _ageMonths = preset),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Red flags at this age ─────────────────────────────────────────
        if (flags.isNotEmpty) ...[
          _SectionHeader(
            title: 'Red flags activated by ${_ageDisplay(_ageMonths)}',
            color: const Color(0xFFB71C1C),
            icon: Icons.warning_amber_rounded,
          ),
          for (final f in flags) _RedFlagRow(flag: f),
          const SizedBox(height: 16),
        ],

        // ── Milestones per domain ────────────────────────────────────────
        for (final entry in byDomain.entries)
          if (entry.value.isNotEmpty) ...[
            _DomainSection(domain: entry.key, milestones: entry.value),
          ],

        if (byDomain.values.every((l) => l.isEmpty))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                'No postnatal milestones expected before this age.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _AgePresetChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _AgePresetChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? cs.primary
                : cs.onSurface.withValues(alpha: 0.25),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: isSelected ? cs.onPrimary : cs.onSurface,
          ),
        ),
      ),
    );
  }
}

class _DomainSection extends StatelessWidget {
  final DevDomain domain;
  final List<Milestone> milestones;
  const _DomainSection({required this.domain, required this.milestones});
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
          // Domain header
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: info.color.withValues(alpha: 0.10),
              border: Border(
                left: BorderSide(color: info.color, width: 3),
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
                    color: info.color,
                  ),
                ),
                const Spacer(),
                Text(
                  '${milestones.length}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: info.color.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          // Milestone rows
          for (int i = 0; i < milestones.length; i++) ...[
            if (i > 0)
              Divider(
                height: 0,
                color: cs.outlineVariant.withValues(alpha: 0.4),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 70,
                    child: Text(
                      milestones[i].ageLabel,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: info.color,
                      ),
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
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  const _SectionHeader({
    required this.title,
    required this.color,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _RedFlagRow extends StatelessWidget {
  final RedFlag flag;
  const _RedFlagRow({required this.flag});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final info = kDomainInfo[flag.domain]!;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFB71C1C).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: const Border(
          left: BorderSide(color: Color(0xFFB71C1C), width: 3),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 76,
            child: Text(
              flag.ageLabel,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFB71C1C),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: info.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              info.shortLabel,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: info.color,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              flag.description,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── BY BEHAVIOUR MODE ───────────────────────────────────────────────────────

class _ByBehaviourMode extends StatefulWidget {
  const _ByBehaviourMode();
  @override
  State<_ByBehaviourMode> createState() => _ByBehaviourModeState();
}

class _ByBehaviourModeState extends State<_ByBehaviourMode> {
  /// Set of milestone descriptions the user has ticked. We key on the
  /// `description` string because it's stable and unique across the
  /// AIIMS handout.
  final Set<String> _observed = {};

  /// Optional chronological age input — when set, lets us compute DQ
  /// per domain inline.
  final TextEditingController _caCtrl = TextEditingController();
  double? get _chronoAge {
    final raw = double.tryParse(_caCtrl.text.trim());
    if (raw == null || raw <= 0) return null;
    return raw;
  }

  @override
  void dispose() {
    _caCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final daByDomain = developmentalAgeFromObserved(_observed);
    final maxDa = daByDomain.values.fold<double>(0, (a, b) => b > a ? b : a);
    final ca = _chronoAge;

    // Group all postnatal milestones by domain (sorted ascending so user
    // ticks earliest-first naturally).
    final grouped = <DevDomain, List<Milestone>>{
      for (final d in DevDomain.values) d: <Milestone>[],
    };
    for (final m in kMilestones) {
      if (!m.prenatal) grouped[m.domain]!.add(m);
    }
    for (final list in grouped.values) {
      list.sort((a, b) => a.ageMonths.compareTo(b.ageMonths));
    }

    return Column(
      children: [
        // ── Result panel — always visible at top ──────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.5),
            border: Border(
              bottom: BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.4)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.insights_rounded,
                      size: 18, color: cs.primary),
                  const SizedBox(width: 8),
                  Text(
                    'ESTIMATED DEVELOPMENTAL AGE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                      color: cs.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _observed.isEmpty
                        ? '—'
                        : 'Overall ${_ageDisplay(maxDa)}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  for (final d in DevDomain.values)
                    _DomainChipResult(
                      domain: d,
                      da: daByDomain[d] ?? 0,
                      ca: ca,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              // Chronological age input (optional) — DQ uses this when set.
              SizedBox(
                height: 38,
                child: TextField(
                  controller: _caCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  onChanged: (_) => setState(() {}),
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 13, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText:
                        'Optional: chronological age (months) — gives DQ per domain',
                    hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: 0.5)),
                    prefixIcon: Icon(Icons.calculate_outlined,
                        size: 18, color: cs.onSurface.withValues(alpha: 0.5)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    filled: true,
                    fillColor:
                        cs.surface.withValues(alpha: 0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: cs.outlineVariant.withValues(alpha: 0.4)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: cs.outlineVariant.withValues(alpha: 0.4)),
                    ),
                  ),
                ),
              ),
              if (_observed.isNotEmpty) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => setState(() {
                    _observed.clear();
                    _caCtrl.clear();
                  }),
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Reset'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 28),
                  ),
                ),
              ],
            ],
          ),
        ),

        // ── Checklist ─────────────────────────────────────────────────────
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
            children: [
              for (final entry in grouped.entries)
                _BehaviourDomainSection(
                  domain: entry.key,
                  milestones: entry.value,
                  observed: _observed,
                  onToggle: (m) => setState(() {
                    if (_observed.contains(m.description)) {
                      _observed.remove(m.description);
                    } else {
                      _observed.add(m.description);
                    }
                  }),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DomainChipResult extends StatelessWidget {
  final DevDomain domain;
  final double da;
  final double? ca;
  const _DomainChipResult({
    required this.domain,
    required this.da,
    required this.ca,
  });
  @override
  Widget build(BuildContext context) {
    final info = kDomainInfo[domain]!;
    final dq = (ca != null && ca! > 0 && da > 0) ? (da / ca! * 100) : null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: info.color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: info.color.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(info.icon, size: 14, color: info.color),
          const SizedBox(width: 5),
          Text(
            info.shortLabel,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: info.color,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            da == 0 ? '—' : _ageDisplay(da),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: info.color,
            ),
          ),
          if (dq != null) ...[
            const SizedBox(width: 6),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: interpretDq(dq).color.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'DQ ${dq.toStringAsFixed(0)}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: interpretDq(dq).color,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BehaviourDomainSection extends StatelessWidget {
  final DevDomain domain;
  final List<Milestone> milestones;
  final Set<String> observed;
  final void Function(Milestone) onToggle;
  const _BehaviourDomainSection({
    required this.domain,
    required this.milestones,
    required this.observed,
    required this.onToggle,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final info = kDomainInfo[domain]!;
    final tickedHere = milestones
        .where((m) => observed.contains(m.description))
        .length;
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
        childrenPadding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: info.color.withValues(alpha: 0.13),
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
              '$tickedHere / ${milestones.length}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
        children: [
          for (final m in milestones)
            CheckboxListTile(
              value: observed.contains(m.description),
              onChanged: (_) => onToggle(m),
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: info.color,
              title: Text(
                m.description,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface,
                ),
              ),
              subtitle: Text(
                m.ageLabel,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: info.color,
                  letterSpacing: 0.2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Helpers ────────────────────────────────────────────────────────────────

String _ageDisplay(double months) {
  if (months <= 0) return 'Newborn';
  if (months < 12) {
    if (months == months.roundToDouble()) {
      return '${months.toStringAsFixed(0)} mo';
    }
    return '${months.toStringAsFixed(1)} mo';
  }
  final years = months / 12;
  if (years == years.roundToDouble()) {
    return '${years.toStringAsFixed(0)} yr';
  }
  return '${years.toStringAsFixed(1)} yr';
}
