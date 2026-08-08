// =============================================================================
// lib/screens/never_again/never_again_screen.dart
//
// "Never Again" — anonymous peer-learning module.
// Users share clinical mistakes anonymously so the team can learn.
// Visual style matches GIR Calculator (cardColor containers, onSurface 0.1
// border, 10-14 px rounded corners, Google Fonts Plus Jakarta Sans).
// =============================================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../services/never_again_service.dart';
import '../submissions/my_submissions_screen.dart';

// ── Category definitions ──────────────────────────────────────────────────────

const _kAllCategory = 'All';

// 30 paediatric topics. The original 9 stay verbatim so existing posts
// keep their category labels; the next 21 expand the taxonomy across
// every major paediatric subspecialty.
const List<String> _kCategories = [
  _kAllCategory,
  // ── Original 9 (do NOT rename — existing posts reference these strings)
  'Neonatology',
  'Fluids & Electrolytes',
  'Jaundice',
  'Sepsis & Infection',
  'Medications & Dosing',
  'Procedures',
  'Resuscitation',
  'Nutrition',
  // ── Subspecialties (added)
  'Cardiology',
  'Respiratory & Asthma',
  'Gastroenterology & Hepatology',
  'Nephrology / RTA',
  'Endocrinology / Diabetes',
  'Haematology / Oncology',
  'Neurology / Seizures',
  'Critical Care / PICU',
  'Emergency / Triage',
  // ── Acute presentations
  'Burns & Trauma',
  'Toxicology',
  'Envenomation',
  'Allergy / Anaphylaxis',
  // ── Long-term / preventive
  'Genetics / Metabolic',
  'Vaccines & Immunisation',
  'Growth & Development',
  'Adolescent / Mental Health',
  // ── Cross-cutting
  'Diagnostics / Imaging',
  'Surgery / Peri-operative',
  'Child Protection / NAI',
  'Communication / Ethics',
  'Education / Teaching',
  'Other',
];

const Map<String, Color> _kCategoryColors = {
  // Original 9
  'Neonatology': Color(0xFF1565C0),
  'Fluids & Electrolytes': Color(0xFF00838F),
  'Jaundice': Color(0xFFF9A825),
  'Sepsis & Infection': Color(0xFFC62828),
  'Medications & Dosing': Color(0xFF6A1B9A),
  'Procedures': Color(0xFF2E7D32),
  'Resuscitation': Color(0xFFD84315),
  'Nutrition': Color(0xFF558B2F),
  // Subspecialties
  'Cardiology': Color(0xFFAD1457),
  'Respiratory & Asthma': Color(0xFF0277BD),
  'Gastroenterology & Hepatology': Color(0xFFEF6C00),
  'Nephrology / RTA': Color(0xFF00695C),
  'Endocrinology / Diabetes': Color(0xFF7B1FA2),
  'Haematology / Oncology': Color(0xFFB71C1C),
  'Neurology / Seizures': Color(0xFF512DA8),
  'Critical Care / PICU': Color(0xFFE65100),
  'Emergency / Triage': Color(0xFFD32F2F),
  // Acute presentations
  'Burns & Trauma': Color(0xFFBF360C),
  'Toxicology': Color(0xFF4A148C),
  'Envenomation': Color(0xFF33691E),
  'Allergy / Anaphylaxis': Color(0xFFC62828),
  // Long-term / preventive
  'Genetics / Metabolic': Color(0xFF1A237E),
  'Vaccines & Immunisation': Color(0xFF2E7D32),
  'Growth & Development': Color(0xFF388E3C),
  'Adolescent / Mental Health': Color(0xFF6A1B9A),
  // Cross-cutting
  'Diagnostics / Imaging': Color(0xFF00838F),
  'Surgery / Peri-operative': Color(0xFF5D4037),
  'Child Protection / NAI': Color(0xFFB71C1C),
  'Communication / Ethics': Color(0xFF455A64),
  'Education / Teaching': Color(0xFF1565C0),
  'Other': Color(0xFF546E7A),
};

Color _categoryColor(String cat) =>
    _kCategoryColors[cat] ?? const Color(0xFF546E7A);

const List<String> _kRoles = [
  'Resident',
  'Fellow',
  'Senior Resident',
  'Consultant',
  'Nurse',
  'Other',
  'Prefer not to say',
];

// ── Screen ────────────────────────────────────────────────────────────────────

class NeverAgainScreen extends StatefulWidget {
  const NeverAgainScreen({super.key});

  @override
  State<NeverAgainScreen> createState() => _NeverAgainScreenState();
}

class _NeverAgainScreenState extends State<NeverAgainScreen> {
  final _service = NeverAgainService.instance;
  final _scrollCtrl = ScrollController();

  String _selectedCategory = _kAllCategory;

  // Text search only. No state or city filter here, unlike CME: these posts
  // are anonymous, and location plus role plus category plus date is often
  // enough to identify one person — in a small subspecialty it is close to a
  // name. The whole point of the module is that admitting a mistake is safe.
  String _query = '';
  final List<NeverAgainPost> _posts = [];
  bool _loading = true;
  bool _loadingMore = false;
  int _page = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _init();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await _service.init();
    await _loadPage(reset: true);
  }

  Future<void> _loadPage({bool reset = false}) async {
    if (reset) {
      setState(() {
        _loading = true;
        _page = 1;
        _hasMore = true;
        _posts.clear();
      });
    }
    try {
      final cat = _selectedCategory == _kAllCategory ? null : _selectedCategory;
      final result = await _service.getPosts(
        category: cat,
        query: _query,
        page: _page,
      );
      if (!mounted) return;
      setState(() {
        _posts.addAll(result.posts);
        _hasMore = result.hasMore;
        _loading = false;
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadingMore = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
            _scrollCtrl.position.maxScrollExtent - 200 &&
        !_loadingMore &&
        _hasMore &&
        !_loading) {
      setState(() {
        _loadingMore = true;
        _page++;
      });
      _loadPage();
    }
  }

  Future<void> _onRefresh() async {
    await _loadPage(reset: true);
  }

  void _selectCategory(String cat) {
    if (cat == _selectedCategory) return;
    setState(() => _selectedCategory = cat);
    _loadPage(reset: true);
  }

  // Opens the global submissions screen rather than a Never-Again-only sheet:
  // posts from here and events posted to CME now share one list.
  void _openMySubmissions() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const MySubmissionsScreen()),
    );
  }

  void _openSubmitSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SubmitSheet(
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Submitted — it'll appear once a moderator approves it. Check My Submissions for status.",
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
          _loadPage(reset: true);
        },
        onRateLimit: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'You have posted too many times recently. Please try again later.',
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Color(0xFFD84315),
            ),
          );
        },
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        // Force white foreground for the title, subtitle, and action
        // icons so they're readable on the blue AppBar regardless of
        // the active Material theme.
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Never Again',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Text(
              'Learn from real mistakes · Anonymous',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                // AppBar is on a blue background — use white with reduced
                // alpha so the subtitle is readable on every theme. Using
                // onSurface here rendered dark grey on blue which was
                // barely visible.
                color: Colors.white.withValues(alpha: 0.80),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        toolbarHeight: 60,
        actions: [
          // Labelled, because a clock-arrow glyph does not say "the things you
          // submitted" to anyone who hasn't been told, and its tooltip only
          // appears on long-press — which nobody does while hunting for
          // something. The "+" beside it stays an icon: that one really is
          // universally read as "add".
          // Icon-only under 420dp: two labelled buttons plus the title overflow
          // a phone app bar. If one has to lose its label it is this one —
          // "Share a mistake" is the action the screen exists for.
          if (MediaQuery.of(context).size.width < 420)
            IconButton(
              onPressed: _openMySubmissions,
              icon: const Icon(Icons.fact_check_outlined),
              tooltip: 'My Submissions',
              color: Colors.white,
            )
          else
            TextButton.icon(
              onPressed: _openMySubmissions,
              icon: const Icon(Icons.fact_check_outlined, size: 18),
              label: Text(
                'My Submissions',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.white.withValues(alpha: 0.16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          // Solid and labelled. A bare "+" reads as "add" in the abstract, but
          // nothing about it says what gets added — and on a screen whose whole
          // point is that people contribute, the one action that matters was the
          // least visible thing in the bar. Filled white against the blue so it
          // is unmistakably the primary action.
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 8),
            child: FilledButton.icon(
              onPressed: _openSubmitSheet,
              icon: const Icon(Icons.add, size: 18),
              label: Text(
                'Share a mistake',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1565C0),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_service.usingPreview)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: const Color(0xFFFFF3E0),
              child: Text(
                'Showing sample posts — live feed will load once the server is back online.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  color: const Color(0xFFE65100),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          _CategoryFilterRow(
            selected: _selectedCategory,
            onSelect: _selectCategory,
            onSearch: (v) {
              _query = v;
              _loadPage(reset: true);
            },
          ),
          Expanded(child: _buildFeed()),
        ],
      ),
    );
  }

  Widget _buildFeed() {
    if (_loading) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => const _ShimmerCard(),
      );
    }

    if (_posts.isEmpty) {
      return _EmptyState(category: _selectedCategory, onAdd: _openSubmitSheet);
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.separated(
        controller: _scrollCtrl,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: _posts.length + (_loadingMore ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= _posts.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }
          final post = _posts[index];
          return _PostCard(
            key: ValueKey(post.id),
            post: post,
            onResonateChanged: () => setState(() {}),
            onFlag: () async {
              await _service.flagPost(post.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Post flagged for review.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

// ── Category filter row ───────────────────────────────────────────────────────

class _CategoryFilterRow extends StatefulWidget {
  const _CategoryFilterRow({
    required this.selected,
    required this.onSelect,
    required this.onSearch,
  });

  final String selected;
  final ValueChanged<String> onSelect;

  /// Fires debounced. The field's hint has always promised "Search topics —
  /// e.g. seizure, sepsis, NICU", but it only ever filtered the category chip
  /// list, so typing a clinical term searched nothing. It now searches the
  /// posts themselves, server-side, which is what the hint says and what
  /// anyone would expect.
  final ValueChanged<String> onSearch;

  @override
  State<_CategoryFilterRow> createState() => _CategoryFilterRowState();
}

class _CategoryFilterRowState extends State<_CategoryFilterRow> {
  final TextEditingController _q = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _q.dispose();
    super.dispose();
  }

  void _onTyped(String value) {
    setState(() {}); // repaint the clear affordance
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) widget.onSearch(value);
    });
  }

  /// Chips that match the current filter query. "All" always stays
  /// visible so users can still reset to the full list.
  List<String> get _visibleCategories {
    // The text box now searches posts, so it must not also hide categories:
    // typing "sepsis" would collapse the chip row at the same moment the
    // results below changed, and neither effect would be explicable.
    return _kCategories;
    // ignore: dead_code
    final q = _q.text.trim().toLowerCase();
    if (q.isEmpty) return _kCategories;
    return _kCategories
        .where((c) => c == _kAllCategory || c.toLowerCase().contains(q))
        .toList();
  }

  /// Full-height searchable topic list.
  ///
  /// Type-to-filter rather than a plain list: with 31 entries, scanning is
  /// still work, and someone who knows they want "Envenomation" should be able
  /// to type three letters and land on it.
  Future<void> _openTopicPicker(BuildContext context) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => _TopicPickerSheet(selected: widget.selected),
    );
    if (picked != null) widget.onSelect(picked);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final visible = _visibleCategories;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: cs.onSurface.withValues(alpha: 0.08)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Topic search — filter the chips themselves so 30 categories
          // stay scannable. As the user types, only matching chips show.
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
            child: SizedBox(
              height: 38,
              child: TextField(
                controller: _q,
                onChanged: _onTyped,
                style: GoogleFonts.plusJakartaSans(fontSize: 13),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Search topics — e.g. seizure, sepsis, NICU…',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: cs.onSurface.withValues(alpha: 0.45),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 18,
                    color: cs.onSurface.withValues(alpha: 0.45),
                  ),
                  suffixIcon: _q.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear, size: 16),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            _q.clear();
                            setState(() {});
                          },
                        ),
                  filled: true,
                  fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: cs.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: cs.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: cs.primary),
                  ),
                ),
              ),
            ),
          ),
          // A "browse all" button ahead of the chips.
          //
          // The taxonomy grew to 31 topics, and a horizontal row that long is
          // effectively unsearchable: reaching "Toxicology" means swiping past
          // twenty chips with no idea how many remain or whether it exists at
          // all. The chips stay, because they are genuinely quick for the
          // common few, but anyone hunting a specific topic can now open a
          // searchable list instead of scrolling blind.
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _openTopicPicker(context),
                icon: const Icon(Icons.filter_list_rounded, size: 17),
                label: Text(
                  widget.selected == _kAllCategory
                      ? 'Browse all ${_kCategories.length - 1} topics'
                      : widget.selected,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  foregroundColor: widget.selected == _kAllCategory
                      ? cs.onSurface.withValues(alpha: 0.7)
                      : cs.primary,
                  side: BorderSide(
                    color: widget.selected == _kAllCategory
                        ? cs.onSurface.withValues(alpha: 0.18)
                        : cs.primary,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          // Horizontal-scrolling chip row. ListView.separated with explicit
          // ClampingScrollPhysics scrolls reliably on Android; InkWell on
          // each chip wins the tap vs swipe gesture arbitration so the
          // user can swipe across chips to scroll without misfiring taps.
          SizedBox(
            height: 44,
            child: visible.isEmpty
                ? Center(
                    child: Text(
                      'No topic matches "${_q.text}"',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: 0.45),
                      ),
                    ),
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    itemCount: visible.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final cat = visible[i];
                      final isSelected = cat == widget.selected;
                      final catColor = cat == _kAllCategory
                          ? cs.primary
                          : _categoryColor(cat);
                      return InkWell(
                        onTap: () => widget.onSelect(cat),
                        borderRadius: BorderRadius.circular(20),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? catColor : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? catColor
                                  : cs.onSurface.withValues(alpha: 0.25),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            cat,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : cs.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Post card ─────────────────────────────────────────────────────────────────

class _PostCard extends StatefulWidget {
  const _PostCard({
    super.key,
    required this.post,
    required this.onResonateChanged,
    required this.onFlag,
  });

  final NeverAgainPost post;
  final VoidCallback onResonateChanged;
  final VoidCallback onFlag;

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _expanded = false;
  late bool _resonated;
  late int _resonateCount;
  bool _resonating = false;

  @override
  void initState() {
    super.initState();
    _resonated = NeverAgainService.instance.isResonated(widget.post.id);
    _resonateCount = widget.post.resonatedCount;
  }

  Future<void> _toggleResonate() async {
    if (_resonating) return;
    setState(() => _resonating = true);
    try {
      final result = await NeverAgainService.instance.toggleResonate(
        widget.post.id,
      );
      if (!mounted) return;
      setState(() {
        _resonated = result.resonated;
        _resonateCount = result.newCount;
        _resonating = false;
      });
      widget.onResonateChanged();
    } catch (_) {
      if (mounted) setState(() => _resonating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final post = widget.post;
    final catColor = _categoryColor(post.category);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top meta row ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Row(
              children: [
                // Category chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    post.category,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: catColor,
                    ),
                  ),
                ),
                if (post.role != null && post.role!.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: cs.onSurface.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      post.role!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  timeago.format(post.createdAt),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: cs.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ── What happened ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.report_problem_outlined,
                  size: 16,
                  color: Color(0xFFF57C00),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    post.whatHappened,
                    maxLines: _expanded ? null : 2,
                    overflow: _expanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      // Full opacity for maximum readability — the
                      // previous 0.9 alpha looked washed-out against
                      // the card background on some themes.
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Read more / less ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                _expanded ? 'Read less' : 'Read more',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: cs.primary,
                ),
              ),
            ),
          ),

          // ── Expanded: What went wrong + The lesson ────────────────────────
          if (_expanded) ...[
            const SizedBox(height: 4),
            _ExpandedSection(
              icon: Icons.child_care,
              iconColor: const Color(0xFFC62828),
              label: 'What went wrong',
              text: post.whatWentWrong,
            ),
            const SizedBox(height: 8),
            _ExpandedSection(
              icon: Icons.lightbulb_outline,
              iconColor: const Color(0xFFF9A825),
              label: 'The lesson',
              text: post.theLesson,
              bold: true,
            ),
            const SizedBox(height: 4),
          ],

          const Divider(height: 1, indent: 14, endIndent: 14),

          // ── Bottom action row ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              children: [
                // Heart / resonate button
                _ResonateButton(
                  count: _resonateCount,
                  resonated: _resonated,
                  loading: _resonating,
                  onTap: _toggleResonate,
                ),
                const Spacer(),
                // Flag button
                IconButton(
                  icon: Icon(
                    Icons.flag_outlined,
                    size: 18,
                    color: cs.onSurface.withValues(alpha: 0.35),
                  ),
                  tooltip: 'Flag this post',
                  onPressed: widget.onFlag,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Expanded section (what went wrong / lesson) ───────────────────────────────

class _ExpandedSection extends StatelessWidget {
  const _ExpandedSection({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.text,
    this.bold = false,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.06),
          border: Border.all(color: iconColor.withValues(alpha: 0.15)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 15, color: iconColor),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: iconColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    text,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      height: 1.55,
                      fontWeight: bold ? FontWeight.w600 : FontWeight.w500,
                      // Full opacity — the expanded body is the clinical
                      // content, it should be as readable as possible.
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Resonate button ───────────────────────────────────────────────────────────

class _ResonateButton extends StatelessWidget {
  const _ResonateButton({
    required this.count,
    required this.resonated,
    required this.loading,
    required this.onTap,
  });

  final int count;
  final bool resonated;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final activeColor = const Color(0xFFE53935);
    final inactiveColor = cs.onSurface.withValues(alpha: 0.45);

    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            loading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: resonated ? activeColor : inactiveColor,
                    ),
                  )
                : Icon(
                    resonated ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: resonated ? activeColor : inactiveColor,
                  ),
            const SizedBox(width: 5),
            Text(
              count.toString(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: resonated ? activeColor : inactiveColor,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'resonate',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.category, required this.onAdd});

  final String category;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 72,
              color: cs.onSurface.withValues(alpha: 0.18),
            ),
            const SizedBox(height: 20),
            Text(
              category == _kAllCategory
                  ? 'No posts yet'
                  : 'No posts yet in $category',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: cs.onSurface.withValues(alpha: 0.45),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to share a lesson',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                color: cs.onSurface.withValues(alpha: 0.35),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Share a lesson'),
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shimmer placeholder card ──────────────────────────────────────────────────

class _ShimmerCard extends StatefulWidget {
  const _ShimmerCard();

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _anim = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final shimmer = cs.onSurface.withValues(alpha: _anim.value * 0.12);
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Rect(width: 90, height: 22, color: shimmer, radius: 20),
                  const SizedBox(width: 8),
                  _Rect(width: 60, height: 22, color: shimmer, radius: 20),
                  const Spacer(),
                  _Rect(width: 50, height: 14, color: shimmer, radius: 4),
                ],
              ),
              const SizedBox(height: 14),
              _Rect(
                width: double.infinity,
                height: 14,
                color: shimmer,
                radius: 4,
              ),
              const SizedBox(height: 8),
              _Rect(width: 200, height: 14, color: shimmer, radius: 4),
              const SizedBox(height: 16),
              _Rect(width: 80, height: 13, color: shimmer, radius: 4),
            ],
          ),
        );
      },
    );
  }
}

class _Rect extends StatelessWidget {
  const _Rect({
    required this.width,
    required this.height,
    required this.color,
    required this.radius,
  });

  final double width;
  final double height;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ── Submit bottom sheet ───────────────────────────────────────────────────────

class _SubmitSheet extends StatefulWidget {
  const _SubmitSheet({required this.onSuccess, required this.onRateLimit});

  final VoidCallback onSuccess;
  final VoidCallback onRateLimit;

  @override
  State<_SubmitSheet> createState() => _SubmitSheetState();
}

class _SubmitSheetState extends State<_SubmitSheet> {
  final _formKey = GlobalKey<FormState>();

  String? _category;
  String? _role;

  final _whatHappenedCtrl = TextEditingController();
  final _whatWentWrongCtrl = TextEditingController();
  final _theLessonCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  bool _disclaimerChecked = false;
  bool _submitting = false;

  @override
  void dispose() {
    _whatHappenedCtrl.dispose();
    _whatWentWrongCtrl.dispose();
    _theLessonCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _category != null &&
      _whatHappenedCtrl.text.trim().isNotEmpty &&
      _whatWentWrongCtrl.text.trim().isNotEmpty &&
      _theLessonCtrl.text.trim().isNotEmpty &&
      _disclaimerChecked &&
      !_submitting;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() => _submitting = true);
    try {
      await NeverAgainService.instance.submitPost(
        whatHappened: _whatHappenedCtrl.text.trim(),
        whatWentWrong: _whatWentWrongCtrl.text.trim(),
        theLesson: _theLessonCtrl.text.trim(),
        category: _category!,
        role: _role,
        email: _emailCtrl.text,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onSuccess();
    } catch (e) {
      // Check if it's a rate limit error by message content
      if (e.toString().contains('posting limit') ||
          e.toString().contains('429')) {
        if (!mounted) return;
        Navigator.of(context).pop();
        widget.onRateLimit();
        return;
      }
      // Show what the server actually said.
      //
      // This used to be a flat "Something went wrong. Please try again.", which
      // is the worst possible response to a validation failure: the server had
      // already explained the problem ("what_happened exceeds 500 character
      // limit"), the fix was one edit away, and the message threw that away —
      // so retrying unchanged failed identically, forever, with the writing
      // still sitting in the form.
      if (!mounted) return;
      setState(() => _submitting = false);
      final reason = e
          .toString()
          .replaceFirst('Exception: ', '')
          // Field names are the API's, not words a user should have to read.
          .replaceAll('what_happened', 'What happened')
          .replaceAll('what_went_wrong', 'What went wrong')
          .replaceAll('the_lesson', 'The lesson');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            reason.isEmpty ? 'Something went wrong. Please try again.' : reason,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFC62828),
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + viewInsets.bottom),
      child: Form(
        key: _formKey,
        onChanged: () => setState(() {}),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Handle bar ───────────────────────────────────────────────
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // ── Header ───────────────────────────────────────────────────
              Text(
                'Share a Mistake',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your post is fully anonymous. No identifying information is stored. '
                'Help colleagues learn from what you experienced.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontStyle: FontStyle.italic,
                  color: cs.onSurface.withValues(alpha: 0.5),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // ── Category + Role row ───────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: _SheetDropdown<String>(
                      label: 'Category *',
                      value: _category,
                      items: _kCategories
                          .where((c) => c != _kAllCategory)
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _category = v),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 4,
                    child: _SheetDropdown<String>(
                      label: 'Role (optional)',
                      value: _role,
                      items: _kRoles
                          .map(
                            (r) => DropdownMenuItem(value: r, child: Text(r)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _role = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── What happened ─────────────────────────────────────────────
              _SheetTextField(
                controller: _whatHappenedCtrl,
                label: 'What happened?',
                hint: 'Briefly describe the clinical scenario…',
                maxLines: 4,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // ── What went wrong ───────────────────────────────────────────
              _SheetTextField(
                controller: _whatWentWrongCtrl,
                label: 'What went wrong?',
                hint: 'What was the root cause or missed step?',
                maxLines: 4,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // ── The lesson ────────────────────────────────────────────────
              _SheetTextField(
                controller: _theLessonCtrl,
                label: 'The lesson',
                hint: 'What would you do differently? What should others know?',
                maxLines: 3,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // ── Optional contact email ────────────────────────────────────
              _SheetTextField(
                controller: _emailCtrl,
                label: 'Your email (optional)',
                hint: 'Only if you want us to reach you about this post',
                maxLines: 1,
                maxLength: 255,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 4),
              Text(
                'Never shown publicly or to other users — only visible to '
                'admins, and only if a revision is needed before publishing.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: cs.onSurface.withValues(alpha: 0.45),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),

              // ── Disclaimer checkbox ───────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9A825).withValues(alpha: 0.07),
                  border: Border.all(
                    color: const Color(0xFFF9A825).withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _disclaimerChecked,
                        onChanged: (v) =>
                            setState(() => _disclaimerChecked = v ?? false),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(
                          () => _disclaimerChecked = !_disclaimerChecked,
                        ),
                        child: Text(
                          'I confirm this post contains no patient identifiers, '
                          'no staff names, and no hospital names.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            height: 1.5,
                            color: cs.onSurface.withValues(alpha: 0.75),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── Review notice ─────────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 15,
                    color: cs.onSurface.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Submitted content is reviewed before publication. '
                      'You can track all submissions from the menu → My Submissions.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        height: 1.45,
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── Submit button ─────────────────────────────────────────────
              ElevatedButton(
                onPressed: _canSubmit ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  disabledBackgroundColor: cs.onSurface.withValues(alpha: 0.1),
                  foregroundColor: cs.onPrimary,
                  disabledForegroundColor: cs.onSurface.withValues(alpha: 0.35),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Post Anonymously',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sheet helper widgets ──────────────────────────────────────────────────────

class _SheetDropdown<T> extends StatelessWidget {
  const _SheetDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: cs.onSurface.withValues(alpha: 0.15)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              hint: Text(
                'Select',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: cs.onSurface.withValues(alpha: 0.4),
                ),
              ),
              items: items,
              onChanged: onChanged,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: cs.onSurface,
              ),
              dropdownColor: Theme.of(context).cardColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _SheetTextField extends StatelessWidget {
  const _SheetTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.maxLines,
    this.maxLength,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final int? maxLength;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          onChanged: onChanged,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.5,
            height: 1.5,
            color: cs.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: cs.onSurface.withValues(alpha: 0.35),
            ),
            filled: true,
            fillColor: Theme.of(context).cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: cs.onSurface.withValues(alpha: 0.15),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: cs.onSurface.withValues(alpha: 0.15),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: cs.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.all(12),
            counterStyle: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Topic picker ──────────────────────────────────────────────────────────────

/// Searchable list of every topic, opened from the filter button.
///
/// Exists because the horizontal chip row does not scale past about a dozen
/// entries: with 31 topics there is no way to see what is available, and
/// reaching the far end means a long blind swipe. Here the whole taxonomy is
/// visible at once and filterable by typing.
class _TopicPickerSheet extends StatefulWidget {
  const _TopicPickerSheet({required this.selected});

  final String selected;

  @override
  State<_TopicPickerSheet> createState() => _TopicPickerSheetState();
}

class _TopicPickerSheetState extends State<_TopicPickerSheet> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final q = _search.text.trim().toLowerCase();
    final matches = _kCategories
        .where((c) => q.isEmpty || c.toLowerCase().contains(q))
        .toList();

    return Padding(
      // Lifts the sheet clear of the keyboard while searching.
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: TextField(
                controller: _search,
                autofocus: false,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search topics…',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _search.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18),
                          onPressed: () => setState(_search.clear),
                        ),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            if (matches.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'No topic matches "${_search.text}"',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (_, i) {
                    final cat = matches[i];
                    final isSelected = cat == widget.selected;
                    return ListTile(
                      dense: true,
                      leading: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cat == _kAllCategory
                              ? cs.primary
                              : _categoryColor(cat),
                        ),
                      ),
                      title: Text(
                        cat == _kAllCategory ? 'All topics' : cat,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.5,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected ? cs.primary : cs.onSurface,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_rounded,
                              size: 18,
                              color: cs.primary,
                            )
                          : null,
                      onTap: () => Navigator.pop(context, cat),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
