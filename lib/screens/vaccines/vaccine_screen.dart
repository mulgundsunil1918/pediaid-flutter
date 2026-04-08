import 'package:flutter/material.dart';
import '../../services/vaccine_service.dart';

// ── Table column widths ───────────────────────────────────────────────────────
const double _kAgeW   = 110.0;
const double _kVaccW  = 190.0;
const double _kDoseW  = 115.0;
const double _kRouteW = 120.0;
const double _kSiteW  = 150.0;
const double _kNotesW = 170.0;
const double _kTotalW = _kAgeW + _kVaccW + _kDoseW + _kRouteW + _kSiteW + _kNotesW;

// ── Palette ───────────────────────────────────────────────────────────────────
const Color _iapAccent  = Color(0xFF1565C0);
const Color _nisAccent  = Color(0xFF2E7D32);
const Color _noteAmber  = Color(0xFFF57C00);

// ─────────────────────────────────────────────────────────────────────────────
class VaccineScreen extends StatefulWidget {
  const VaccineScreen({super.key});

  @override
  State<VaccineScreen> createState() => _VaccineScreenState();
}

class _VaccineScreenState extends State<VaccineScreen> {
  int _schedIdx = 0; // 0 = IAP, 1 = NIS
  int _viewIdx  = 0; // 0 = Table, 1 = Smart

  VaccineSchedule? _iap;
  VaccineSchedule? _nis;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final iap = await VaccineService().loadIAP();
      final nis = await VaccineService().loadNIS();
      if (mounted) setState(() { _iap = iap; _nis = nis; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = e.toString(); });
    }
  }

  VaccineSchedule? get _current => _schedIdx == 0 ? _iap : _nis;
  Color get _accent => _schedIdx == 0 ? _iapAccent : _nisAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Immunisation Schedule',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        elevation: 0,
      ),
      body: _loading
          ? _buildLoading()
          : _error != null
              ? _buildError()
              : _buildContent(),
    );
  }

  // ── Loading / Error ───────────────────────────────────────────────────────

  Widget _buildLoading() {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CircularProgressIndicator(color: _accent),
        const SizedBox(height: 16),
        Text('Loading schedule…',
            style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.6), fontSize: 14)),
      ]),
    );
  }

  Widget _buildError() {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.error_outline, color: cs.error, size: 48),
          const SizedBox(height: 16),
          Text('Failed to load schedule',
              style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(_error ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.55), fontSize: 12)),
        ]),
      ),
    );
  }

  // ── Main content ──────────────────────────────────────────────────────────

  Widget _buildContent() {
    return Column(
      children: [
        _buildToggles(),
        Expanded(child: _buildBody()),
      ],
    );
  }

  // ── Toggles ───────────────────────────────────────────────────────────────

  Widget _buildToggles() {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Column(
        children: [
          // Primary: IAP | NIS
          Row(children: [
            _toggleBtn('IAP 2022', 0, _schedIdx, _iapAccent,
                () => setState(() => _schedIdx = 0)),
            const SizedBox(width: 8),
            _toggleBtn('NIS (National)', 1, _schedIdx, _nisAccent,
                () => setState(() => _schedIdx = 1)),
          ]),
          const SizedBox(height: 8),
          // Secondary: Table | Smart
          Row(children: [
            _toggleBtn('Table View', 0, _viewIdx, cs.primary,
                () => setState(() => _viewIdx = 0)),
            const SizedBox(width: 8),
            _toggleBtn('Smart View', 1, _viewIdx, cs.primary,
                () => setState(() => _viewIdx = 1)),
          ]),
        ],
      ),
    );
  }

  Widget _toggleBtn(String label, int idx, int cur, Color color, VoidCallback onTap) {
    final sel = idx == cur;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: sel ? color : color.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: sel ? color : color.withValues(alpha: 0.25)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: sel ? Colors.white : color,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────────────────

  Widget _buildBody() {
    final schedule = _current;
    if (schedule == null) return const SizedBox.shrink();
    if (_viewIdx == 0) return _TableView(schedule: schedule, accent: _accent);
    return _SmartView(schedule: schedule, accent: _accent);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TABLE VIEW
// ─────────────────────────────────────────────────────────────────────────────

class _TableView extends StatelessWidget {
  final VaccineSchedule schedule;
  final Color accent;

  const _TableView({required this.schedule, required this.accent});

  @override
  Widget build(BuildContext context) {
    final cs    = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border  = cs.onSurface.withValues(alpha: isDark ? 0.15 : 0.12);
    final ageBg   = accent.withValues(alpha: 0.09);
    final altBg   = cs.onSurface.withValues(alpha: isDark ? 0.04 : 0.025);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(accent, border, isDark, context),
                  Container(height: 1.5, width: _kTotalW, color: accent.withValues(alpha: 0.5)),
                  // Rows
                  ..._buildRows(ageBg, altBg, border, cs),
                ],
              ),
            ),
          ),
        ),
        if (schedule.notes.isNotEmpty)
          _NotesFooter(notes: schedule.notes),
      ],
    );
  }

  Widget _buildHeader(Color accent, Color border, bool isDark, BuildContext context) {
    return Container(
      color: accent.withValues(alpha: isDark ? 0.2 : 0.12),
      child: Row(children: [
        _hCell('Age',     _kAgeW,   border, accent),
        _hCell('Vaccine', _kVaccW,  border, accent),
        _hCell('Dose',    _kDoseW,  border, accent),
        _hCell('Route',   _kRouteW, border, accent),
        _hCell('Site',    _kSiteW,  border, accent),
        _hCell('Notes',   _kNotesW, border, accent, isLast: true),
      ]),
    );
  }

  Widget _hCell(String text, double w, Color border, Color accent,
      {bool isLast = false}) {
    return Container(
      width: w,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
            right: isLast ? BorderSide.none : BorderSide(color: border)),
      ),
      child: Text(text,
          style: TextStyle(
              color: accent,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3)),
    );
  }

  List<Widget> _buildRows(
      Color ageBg, Color altBg, Color border, ColorScheme cs) {
    final rows  = <Widget>[];
    int rowIdx  = 0;

    for (final group in schedule.data) {
      bool firstInGroup = true;
      for (final entry in group.entries) {
        final bg = rowIdx % 2 == 0 ? Colors.transparent : altBg;
        final ageLabel = firstInGroup ? group.age : '';

        if (entry.type == 'text_block') {
          rows.add(_TextBlockRow(
            age: ageLabel,
            entry: entry,
            rowBg: bg,
            ageBg: ageBg,
            border: border,
            accent: accent,
            cs: cs,
          ));
        } else {
          rows.add(_StructuredRow(
            age: ageLabel,
            entry: entry,
            rowBg: bg,
            ageBg: ageBg,
            border: border,
            accent: accent,
            cs: cs,
          ));
        }
        firstInGroup = false;
        rowIdx++;
      }
    }
    return rows;
  }
}

// ── Table row — structured ────────────────────────────────────────────────────

class _StructuredRow extends StatelessWidget {
  final String age;
  final VaccineEntry entry;
  final Color rowBg, ageBg, border, accent;
  final ColorScheme cs;

  const _StructuredRow({
    required this.age,
    required this.entry,
    required this.rowBg,
    required this.ageBg,
    required this.border,
    required this.accent,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final showAge = age.isNotEmpty;
    final notesText = [
      if (entry.notes.isNotEmpty) entry.notes,
      if (entry.brands.isNotEmpty) 'Examples: ${entry.brands.join(', ')}',
    ].join('\n');

    return Container(
      color: rowBg,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DataCell(
              text: age,
              width: _kAgeW,
              border: border,
              bg: showAge ? ageBg : null,
              textColor: showAge ? accent : null,
              bold: showAge,
              cs: cs,
            ),
            _DataCell(
                text: entry.vaccine,
                width: _kVaccW,
                border: border,
                bold: true,
                cs: cs),
            _DataCell(text: entry.dose,  width: _kDoseW,  border: border, cs: cs),
            _DataCell(text: entry.route, width: _kRouteW, border: border, cs: cs),
            _DataCell(text: entry.site,  width: _kSiteW,  border: border, cs: cs),
            _DataCell(
                text: notesText,
                width: _kNotesW,
                border: border,
                isLast: true,
                isNote: true,
                cs: cs),
          ],
        ),
      ),
    );
  }
}

// ── Table row — text_block ────────────────────────────────────────────────────

class _TextBlockRow extends StatelessWidget {
  final String age;
  final VaccineEntry entry;
  final Color rowBg, ageBg, border, accent;
  final ColorScheme cs;

  const _TextBlockRow({
    required this.age,
    required this.entry,
    required this.rowBg,
    required this.ageBg,
    required this.border,
    required this.accent,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final showAge = age.isNotEmpty;
    return Container(
      color: rowBg,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DataCell(
              text: age,
              width: _kAgeW,
              border: border,
              bg: showAge ? ageBg : null,
              textColor: showAge ? accent : null,
              bold: showAge,
              cs: cs,
            ),
            // Full-width content spanning remaining columns
            Container(
              width: _kTotalW - _kAgeW,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.vaccine,
                      style: TextStyle(
                          color: cs.onSurface,
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ...entry.content.map((line) => Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(line,
                            style: TextStyle(
                                color: cs.onSurface.withValues(alpha: 0.78),
                                fontSize: 12,
                                height: 1.4)),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Individual table cell ─────────────────────────────────────────────────────

class _DataCell extends StatelessWidget {
  final String text;
  final double width;
  final Color border;
  final Color? bg;
  final Color? textColor;
  final bool bold;
  final bool isLast;
  final bool isNote;
  final ColorScheme cs;

  const _DataCell({
    required this.text,
    required this.width,
    required this.border,
    required this.cs,
    this.bg,
    this.textColor,
    this.bold = false,
    this.isLast = false,
    this.isNote = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? cs.onSurface.withValues(alpha: isNote ? 0.62 : 0.85);
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        border: Border(
            right: isLast ? BorderSide.none : BorderSide(color: border)),
      ),
      child: text.isEmpty
          ? const SizedBox.shrink()
          : Text(
              text,
              softWrap: true,
              style: TextStyle(
                  color: color,
                  fontSize: isNote ? 11 : 12.5,
                  fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
                  height: 1.4),
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SMART VIEW
// ─────────────────────────────────────────────────────────────────────────────

class _SmartView extends StatelessWidget {
  final VaccineSchedule schedule;
  final Color accent;

  const _SmartView({required this.schedule, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: schedule.data.length,
            itemBuilder: (ctx, i) => _AgeGroupCard(
              group: schedule.data[i],
              accent: accent,
              isLast: i == schedule.data.length - 1,
            ),
          ),
        ),
        if (schedule.notes.isNotEmpty)
          _NotesFooter(notes: schedule.notes),
      ],
    );
  }
}

// ── Age group card ────────────────────────────────────────────────────────────

class _AgeGroupCard extends StatefulWidget {
  final VaccineAgeGroup group;
  final Color accent;
  final bool isLast;

  const _AgeGroupCard(
      {required this.group, required this.accent, required this.isLast});

  @override
  State<_AgeGroupCard> createState() => _AgeGroupCardState();
}

class _AgeGroupCardState extends State<_AgeGroupCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final accent = widget.accent;
    final count  = widget.group.entries.length;

    return Container(
      margin: EdgeInsets.only(bottom: widget.isLast ? 0 : 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        onExpansionChanged: (v) => setState(() => _expanded = v),
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        childrenPadding: EdgeInsets.zero,
        collapsedBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(Icons.vaccines_rounded, color: accent, size: 20),
        ),
        title: Text(
          widget.group.age,
          style: TextStyle(
              color: cs.onSurface, fontSize: 14.5, fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '$count vaccine${count == 1 ? '' : 's'}',
          style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.5), fontSize: 12),
        ),
        trailing: AnimatedRotation(
          turns: _expanded ? 0.5 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(Icons.keyboard_arrow_down_rounded, color: accent),
        ),
        children: widget.group.entries.map((e) {
          if (e.type == 'text_block') {
            return _TextBlockTile(entry: e, accent: accent);
          }
          return _VaccineTile(entry: e, accent: accent);
        }).toList(),
      ),
    );
  }
}

// ── Vaccine tile (smart view) ─────────────────────────────────────────────────

class _VaccineTile extends StatelessWidget {
  final VaccineEntry entry;
  final Color accent;

  const _VaccineTile({required this.entry, required this.accent});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final divider = cs.onSurface.withValues(alpha: 0.07);

    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: divider))),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, right: 8),
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              ),
            ),
            Expanded(
              child: Text(entry.vaccine,
                  style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      height: 1.3)),
            ),
          ]),

          // Info chips
          if (entry.dose.isNotEmpty ||
              entry.route.isNotEmpty ||
              entry.site.isNotEmpty) ...[
            const SizedBox(height: 7),
            Wrap(
              spacing: 6,
              runSpacing: 5,
              children: [
                if (entry.dose.isNotEmpty)
                  _InfoChip(label: 'Dose', value: entry.dose, accent: accent, cs: cs),
                if (entry.route.isNotEmpty)
                  _InfoChip(label: 'Route', value: entry.route, accent: accent, cs: cs),
                if (entry.site.isNotEmpty)
                  _InfoChip(label: 'Site', value: entry.site, accent: accent, cs: cs),
              ],
            ),
          ],

          // Notes
          if (entry.notes.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 1, right: 5),
                child: Icon(Icons.info_outline,
                    size: 13,
                    color: cs.onSurface.withValues(alpha: 0.4)),
              ),
              Expanded(
                child: Text(entry.notes,
                    style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.6),
                        fontSize: 11.5,
                        fontStyle: FontStyle.italic,
                        height: 1.4)),
              ),
            ]),
          ],

          // Brands (IAP only)
          if (entry.brands.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              'Examples: ${entry.brands.join(' · ')}',
              style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.4),
                  fontSize: 11,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Text-block tile (smart view) ──────────────────────────────────────────────

class _TextBlockTile extends StatelessWidget {
  final VaccineEntry entry;
  final Color accent;

  const _TextBlockTile({required this.entry, required this.accent});

  @override
  Widget build(BuildContext context) {
    final cs      = Theme.of(context).colorScheme;
    final divider = cs.onSurface.withValues(alpha: 0.07);

    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: divider))),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(entry.vaccine,
              style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...entry.content.map((line) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, right: 8),
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                            color: accent, shape: BoxShape.circle),
                      ),
                    ),
                    Expanded(
                      child: Text(line,
                          style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.78),
                              fontSize: 12.5,
                              height: 1.45)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ── Info chip ─────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;
  final ColorScheme cs;

  const _InfoChip(
      {required this.label,
      required this.value,
      required this.accent,
      required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
                color: accent, fontSize: 10.5, fontWeight: FontWeight.w700),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.8), fontSize: 10.5),
          ),
        ]),
      ),
    );
  }
}

// ── Shared notes footer ───────────────────────────────────────────────────────

class _NotesFooter extends StatelessWidget {
  final List<String> notes;
  const _NotesFooter({required this.notes});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: cs.onSurface.withValues(alpha: 0.1), height: 1),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.info_outline_rounded, color: _noteAmber, size: 15),
            const SizedBox(width: 6),
            Text('Schedule Notes',
                style: const TextStyle(
                    color: _noteAmber,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 6),
          ...notes.map((n) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• $n',
                    style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.68),
                        fontSize: 11.5,
                        height: 1.45)),
              )),
        ],
      ),
    );
  }
}
