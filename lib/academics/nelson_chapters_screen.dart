import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data/nelson_chapters.dart';
import 'nelson_chapter_detail_screen.dart';

class NelsonChaptersScreen extends StatefulWidget {
  const NelsonChaptersScreen({super.key});

  @override
  State<NelsonChaptersScreen> createState() => _NelsonChaptersScreenState();
}

class _NelsonChaptersScreenState extends State<NelsonChaptersScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  final Set<String> _expanded = <String>{};

  static const List<Color> _partColors = [
    Color(0xFF1565C0),
    Color(0xFF6A1B9A),
    Color(0xFF00695C),
    Color(0xFF00838F),
    Color(0xFF6D4C41),
    Color(0xFFC62828),
    Color(0xFFEF6C00),
    Color(0xFF2E7D32),
    Color(0xFF4527A0),
    Color(0xFFAD1457),
  ];

  Color _partColor(int idx) => _partColors[idx % _partColors.length];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<NelsonPart> _filtered() {
    if (_query.isEmpty) return kNelsonParts;
    final q = _query.toLowerCase();
    final result = <NelsonPart>[];
    for (final part in kNelsonParts) {
      final keptChapters = <NelsonChapter>[];
      for (final ch in part.chapters) {
        final chHit = ch.number.contains(q) ||
            ch.title.toLowerCase().contains(q);
        final keptSubs = ch.subchapters
            .where((s) =>
                s.number.contains(q) || s.title.toLowerCase().contains(q))
            .toList();
        if (chHit || keptSubs.isNotEmpty) {
          keptChapters.add(NelsonChapter(
            number: ch.number,
            title: ch.title,
            section: ch.section,
            subchapters: chHit ? ch.subchapters : keptSubs,
          ));
        }
      }
      if (keptChapters.isNotEmpty) {
        result.add(NelsonPart(
          roman: part.roman,
          number: part.number,
          title: part.title,
          chapters: keptChapters,
        ));
      }
    }
    return result;
  }

  void _openChapter(
    BuildContext context, {
    required String number,
    required String title,
    required String partTitle,
    bool isSub = false,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NelsonChapterDetailScreen(
          number: number,
          title: title,
          partTitle: partTitle,
          isSubchapter: isSub,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filtered();

    final autoExpand = _query.isNotEmpty;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Nelson Textbook',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v.trim()),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: cs.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Search by chapter number or title…',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: cs.onSurface.withValues(alpha: 0.45),
                ),
                prefixIcon: Icon(Icons.search, color: cs.onSurface.withValues(alpha: 0.55)),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(Icons.close, size: 18, color: cs.onSurface.withValues(alpha: 0.6)),
                        onPressed: () {
                          setState(() {
                            _searchCtrl.clear();
                            _query = '';
                          });
                        },
                      ),
                filled: true,
                fillColor: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : cs.surfaceContainerHighest.withValues(alpha: 0.6),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: filtered.isEmpty
          ? _buildEmpty(context)
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: filtered.length,
              itemBuilder: (context, partIdx) {
                final part = filtered[partIdx];
                final color = _partColor(kNelsonParts
                    .indexWhere((p) => p.roman == part.roman)
                    .clamp(0, kNelsonParts.length - 1));
                return _buildPart(context, part, color, autoExpand);
              },
            ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                size: 56, color: cs.onSurface.withValues(alpha: 0.3)),
            const SizedBox(height: 12),
            Text(
              'No chapters match “$_query”',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPart(
    BuildContext context,
    NelsonPart part,
    Color accent,
    bool autoExpand,
  ) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accent.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'PART ${part.roman}',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  part.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: accent,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...part.chapters.map((ch) => _buildChapterTile(context, ch, part, accent, autoExpand)),
        Divider(
          height: 24,
          indent: 16,
          endIndent: 16,
          color: cs.outline.withValues(alpha: 0.25),
        ),
      ],
    );
  }

  Widget _buildChapterTile(
    BuildContext context,
    NelsonChapter ch,
    NelsonPart part,
    Color accent,
    bool autoExpand,
  ) {
    final cs = Theme.of(context).colorScheme;
    final hasSubs = ch.subchapters.isNotEmpty;
    final key = '${part.roman}.${ch.number}';
    final expanded = autoExpand || _expanded.contains(key);

    return Column(
      children: [
        InkWell(
          onTap: () {
            if (hasSubs) {
              setState(() {
                if (_expanded.contains(key)) {
                  _expanded.remove(key);
                } else {
                  _expanded.add(key);
                }
              });
            } else {
              _openChapter(
                context,
                number: ch.number,
                title: ch.title,
                partTitle: 'Part ${part.roman} — ${part.title}',
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 42,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ch.number,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: accent,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ch.section != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            ch.section!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface.withValues(alpha: 0.45),
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      Text(
                        ch.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasSubs)
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: cs.onSurface.withValues(alpha: 0.55),
                  )
                else
                  Icon(
                    Icons.chevron_right,
                    color: cs.onSurface.withValues(alpha: 0.35),
                  ),
              ],
            ),
          ),
        ),
        if (hasSubs && expanded)
          ...ch.subchapters.map(
            (sub) => InkWell(
              onTap: () => _openChapter(
                context,
                number: sub.number,
                title: sub.title,
                partTitle: 'Part ${part.roman} — ${part.title}',
                isSub: true,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(70, 6, 16, 6),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 44,
                      child: Text(
                        sub.number,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: accent,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        sub.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: cs.onSurface.withValues(alpha: 0.85),
                          height: 1.3,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: cs.onSurface.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
