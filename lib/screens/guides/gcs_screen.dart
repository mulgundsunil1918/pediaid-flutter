// =============================================================================
// guides/gcs_screen.dart
// Glasgow Coma Scale — paediatric & adult.
// SMART VIEW: tap-to-score interactive total.
// TABLE VIEW: full reference tables (verbatim transcription).
// =============================================================================

import 'package:flutter/material.dart';
import '_emergency_guide_widgets.dart';

// ── Reference data (verbatim from source) ────────────────────────────────────

const List<({int score, String under1, String over1})> _eyeTable = [
  (score: 4, under1: 'Spontaneously', over1: 'Spontaneously'),
  (score: 3, under1: 'To shout', over1: 'To verbal command'),
  (score: 2, under1: 'To pain', over1: 'To pain'),
  (score: 1, under1: 'No response', over1: 'No response'),
];

const List<({int score, String under1, String over1})> _motorTable = [
  (score: 6, under1: 'Spontaneous movement', over1: 'Obeys'),
  (score: 5, under1: 'Localizes pain', over1: 'Localizes pain'),
  (score: 4, under1: 'Flexion withdrawal', over1: 'Flexion withdrawal'),
  (score: 3, under1: 'Decorticate flexion', over1: 'Decorticate flexion'),
  (score: 2, under1: 'Decerebrate extension', over1: 'Decerebrate extension'),
  (score: 1, under1: 'No response', over1: 'No response'),
];

const List<({int score, String infant, String mid, String old})> _verbalTable = [
  (score: 5, infant: 'Smiles, coos appropriately', mid: 'Appropriate words', old: 'Oriented, converses'),
  (score: 4, infant: 'Appropriate cry', mid: 'Inappropriate words', old: 'Disoriented, converses'),
  (score: 3, infant: 'Inappropriate cry or scream', mid: 'Cries or screams', old: 'Inappropriate words'),
  (score: 2, infant: 'Grunts', mid: 'Grunts', old: 'Incomprehensible sounds'),
  (score: 1, infant: 'No response', mid: 'No response', old: 'No response'),
];

enum _AgeBand { infantU2, mid, over5 }

class GcsScreen extends StatefulWidget {
  const GcsScreen({super.key});
  @override
  State<GcsScreen> createState() => _GcsScreenState();
}

class _GcsScreenState extends State<GcsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  // Smart-view state
  _AgeBand _band = _AgeBand.over5;
  int? _eye;
  int? _motor;
  int? _verbal;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  bool get _under1 => _band == _AgeBand.infantU2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Glasgow Coma Scale',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        elevation: 0,
        backgroundColor: emergencyBrand,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          tabs: const [
            Tab(text: 'Smart score'),
            Tab(text: 'Table view'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildSmart(),
          _buildTables(),
        ],
      ),
    );
  }

  // ── SMART VIEW ─────────────────────────────────────────────────────────
  Widget _buildSmart() {
    final cs = Theme.of(context).colorScheme;
    final total = (_eye ?? 0) + (_motor ?? 0) + (_verbal ?? 0);
    final allChosen = _eye != null && _motor != null && _verbal != null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 32),
      children: [
        // Age band selector
        const EgSectionLabel('Patient age', ''),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SegmentedButton<_AgeBand>(
            segments: const [
              ButtonSegment(value: _AgeBand.infantU2, label: Text('< 1 yr')),
              ButtonSegment(value: _AgeBand.mid, label: Text('2–5 yr')),
              ButtonSegment(value: _AgeBand.over5, label: Text('> 5 yr')),
            ],
            selected: {_band},
            onSelectionChanged: (s) {
              setState(() {
                _band = s.first;
                // Verbal options change with age band — reset.
                _verbal = null;
              });
            },
          ),
        ),

        // Eye Opening
        const EgSectionLabel('Eye opening', ''),
        ..._eyeTable.map((r) => _ScoreTile(
              score: r.score,
              label: _under1 ? r.under1 : r.over1,
              selected: _eye == r.score,
              onTap: () => setState(() => _eye = r.score),
            )),

        // Best Motor Response
        const EgSectionLabel('Best motor response', ''),
        ..._motorTable.map((r) => _ScoreTile(
              score: r.score,
              label: _under1 ? r.under1 : r.over1,
              selected: _motor == r.score,
              onTap: () => setState(() => _motor = r.score),
            )),

        // Best Verbal Response
        const EgSectionLabel('Best verbal response', ''),
        ..._verbalTable.map((r) {
          final label = switch (_band) {
            _AgeBand.infantU2 => r.infant,
            _AgeBand.mid => r.mid,
            _AgeBand.over5 => r.old,
          };
          return _ScoreTile(
            score: r.score,
            label: label,
            selected: _verbal == r.score,
            onTap: () => setState(() => _verbal = r.score),
          );
        }),

        // Total score
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            decoration: BoxDecoration(
              color: allChosen
                  ? _severityColor(total).withValues(alpha: 0.10)
                  : cs.onSurface.withValues(alpha: 0.04),
              border: Border.all(
                color: allChosen
                    ? _severityColor(total).withValues(alpha: 0.45)
                    : cs.onSurface.withValues(alpha: 0.10),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TOTAL GCS',
                    style: TextStyle(
                      color: allChosen
                          ? _severityColor(total)
                          : cs.onSurface.withValues(alpha: 0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    )),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      allChosen ? '$total' : '—',
                      style: TextStyle(
                        color: allChosen
                            ? _severityColor(total)
                            : cs.onSurface.withValues(alpha: 0.5),
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('/ 15',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.6),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  allChosen
                      ? 'E${_eye!}  ·  M${_motor!}  ·  V${_verbal!}  ·  '
                          '${_severityLabel(total)}'
                      : 'Pick one option in each section.',
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (allChosen) ...[
                  const SizedBox(height: 10),
                  Text(
                    _severityBlurb(total),
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.85),
                      fontSize: 12.5,
                      height: 1.55,
                    ),
                  ),
                ],
                if (allChosen) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => setState(() {
                          _eye = null;
                          _motor = null;
                          _verbal = null;
                        }),
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),

        const EgPearl(
          title: 'GCS thresholds — research add-on',
          body:
              '• 13–15 = mild head injury\n'
              '• 9–12 = moderate head injury\n'
              '• ≤ 8 = severe head injury → secure airway (ETT) and admit to ICU.\n\n'
              'Always document the components separately (E/M/V), not just '
              'the total — a GCS 8 made up of E1·M5·V2 is very different '
              'from E2·M2·V4.',
        ),
        const EgPearl(
          icon: Icons.report_outlined,
          title: 'Pitfalls — research add-on',
          body:
              '• Intubated patient: V is scored "1T" (chart it explicitly).\n'
              '• Periorbital oedema can prevent eye opening — chart "1C".\n'
              '• Sedation, hypoglycaemia and hypoxia all artificially '
              'lower GCS — correct first, reassess.',
        ),

        const EgReferenceCard(
          text:
              'Glasgow Coma '
              'Scale Score card. Smart score interactivity + thresholds + '
              'pitfalls drawn from Teasdale & Jennett (Lancet 1974) and '
              'APLS 6th edition. For use by qualified clinicians only.',
        ),
      ],
    );
  }

  // ── TABLE VIEW (verbatim) ───────────────────────────────────────────────
  Widget _buildTables() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 32),
      children: [
        const EgSectionLabel('Eye opening', ''),
        _RefTable(
          headers: const ['Score', '< 1 year', '> 1 year'],
          rows: _eyeTable
              .map((r) => [r.score.toString(), r.under1, r.over1])
              .toList(),
        ),
        const EgSectionLabel('Best motor response', ''),
        _RefTable(
          headers: const ['Score', '< 1 year', '> 1 year'],
          rows: _motorTable
              .map((r) => [r.score.toString(), r.under1, r.over1])
              .toList(),
        ),
        const EgSectionLabel('Best verbal response', ''),
        _RefTable(
          headers: const ['Score', '0–23 mo', '2–5 yr', '> 5 yr'],
          rows: _verbalTable
              .map((r) => [r.score.toString(), r.infant, r.mid, r.old])
              .toList(),
        ),

        // Source notes that appeared above the GCS table on the page
        const EgSectionLabel('Adjunct neuro-management', '  From source page'),
        const EgCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('3 % saline',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: emergencyBrand)),
              SizedBox(height: 2),
              Text('3–5 mL/kg over 30–60 minutes — if serum osm > 320'),
              SizedBox(height: 12),
              Text('Pentobarbital coma',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: emergencyBrand)),
              SizedBox(height: 2),
              Text('10 mg/kg load, then infusion at 1–6 mg/kg/hour'),
              SizedBox(height: 12),
              Text('Spinal cord injury',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: emergencyBrand)),
              SizedBox(height: 2),
              Text('Consider Solumedrol: 30 mg/kg, then 5.4 mg/kg/hr for 23 h'),
            ],
          ),
        ),

        const EgReferenceCard(
          text:
              'Glasgow Coma '
              'Scale Score reference page. For use by qualified clinicians '
              'only.',
        ),
      ],
    );
  }

  // ── Severity helpers ──────────────────────────────────────────────────
  Color _severityColor(int t) {
    if (t >= 13) return emergencyGreen;
    if (t >= 9) return emergencyAmber;
    return emergencyRed;
  }

  String _severityLabel(int t) {
    if (t >= 13) return 'Mild';
    if (t >= 9) return 'Moderate';
    return 'Severe';
  }

  String _severityBlurb(int t) {
    if (t >= 13) {
      return 'Mild head injury (GCS 13–15). Observe; consider CT for any '
          'concerning features (vomiting, amnesia, headache, suspected NAI).';
    }
    if (t >= 9) {
      return 'Moderate head injury (GCS 9–12). Admit, frequent neuro '
          'observations, head CT, paediatric neurosurgical input.';
    }
    return 'Severe head injury (GCS ≤ 8) — secure the airway (intubate), '
        'maintain SpO₂ ≥ 94 %, normocapnia, treat ICP, urgent CT and '
        'paediatric neurosurgical referral.';
  }
}

class _ScoreTile extends StatelessWidget {
  final int score;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ScoreTile({
    required this.score,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: selected
                ? emergencyBrand.withValues(alpha: 0.10)
                : Theme.of(context).cardColor,
            border: Border.all(
                color: selected
                    ? emergencyBrand
                    : cs.onSurface.withValues(alpha: 0.10),
                width: selected ? 1.5 : 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? emergencyBrand
                      : cs.onSurface.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('$score',
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : cs.onSurface.withValues(alpha: 0.65),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label,
                    style: TextStyle(
                      color: selected ? emergencyBrand : cs.onSurface,
                      fontSize: 13.5,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                      height: 1.35,
                    )),
              ),
              if (selected)
                const Icon(Icons.check_circle, color: emergencyBrand, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _RefTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;
  const _RefTable({required this.headers, required this.rows});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: cs.onSurface.withValues(alpha: 0.10)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: const BoxDecoration(
                color: emergencyBrand,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(11),
                ),
              ),
              child: Row(
                children: headers
                    .asMap()
                    .entries
                    .map((e) => Expanded(
                          flex: e.key == 0 ? 1 : 3,
                          child: Text(e.value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              )),
                        ))
                    .toList(),
              ),
            ),
            ...rows.asMap().entries.map((row) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(
                    color: row.key.isEven
                        ? cs.onSurface.withValues(alpha: 0.025)
                        : null,
                    border: Border(
                        bottom: BorderSide(
                            color: cs.onSurface.withValues(alpha: 0.06))),
                  ),
                  child: Row(
                    children: row.value
                        .asMap()
                        .entries
                        .map((e) => Expanded(
                              flex: e.key == 0 ? 1 : 3,
                              child: Text(e.value,
                                  style: TextStyle(
                                    color: e.key == 0
                                        ? emergencyBrand
                                        : cs.onSurface,
                                    fontSize: 12.5,
                                    fontWeight: e.key == 0
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    height: 1.4,
                                  )),
                            ))
                        .toList(),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
