import 'package:flutter/material.dart';
import '../../services/lab_reference_service.dart';
import 'lab_system_screen.dart';
import 'lab_item_detail_screen.dart';

class LabReferenceScreen extends StatefulWidget {
  const LabReferenceScreen({super.key});

  @override
  State<LabReferenceScreen> createState() => _LabReferenceScreenState();
}

class _LabReferenceScreenState extends State<LabReferenceScreen> {
  final LabReferenceService _svc = LabReferenceService();
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  List<LabSearchResult> _results = [];

  @override
  void initState() {
    super.initState();
    _ensureLoaded();
  }

  Future<void> _ensureLoaded() async {
    if (!_svc.isLoaded) {
      await _svc.load();
    }
    if (mounted) setState(() {});
  }

  void _onSearch(String v) {
    setState(() {
      _query = v;
      _results = _svc.search(v);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: cs.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lab Reference',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: TextField(
              controller: _searchCtrl,
              onChanged: _onSearch,
              style: TextStyle(color: cs.onSurface, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search labs & guides…',
                hintStyle: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.5), fontSize: 14),
                prefixIcon: Icon(Icons.search,
                    color: cs.onSurface.withValues(alpha: 0.5), size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear,
                            color: cs.onSurface.withValues(alpha: 0.5),
                            size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          _onSearch('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: !_svc.isLoaded
          ? Center(child: CircularProgressIndicator(color: cs.primary))
          : _query.isNotEmpty
              ? _buildSearchResults()
              : _buildSystemGrid(),
    );
  }

  // ── Search results ────────────────────────────────────────────────────────

  Widget _buildSearchResults() {
    final cs = Theme.of(context).colorScheme;
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off,
                size: 56, color: cs.onSurface.withValues(alpha: 0.3)),
            const SizedBox(height: 12),
            Text(
              'No results for "$_query"',
              style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.5), fontSize: 15),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      separatorBuilder: (context, i) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final r = _results[i];
        return _SearchResultCard(
          result: r,
          onTap: () {
            if (!r.hasData) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LabItemDetailScreen(
                  itemName: r.itemName,
                  table: _svc.getTable(r.itemName),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── System grid ───────────────────────────────────────────────────────────

  Widget _buildSystemGrid() {
    final cs = Theme.of(context).colorScheme;
    final systems = _svc.allSystems;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Systems',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: cs.onSurface),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.55,
            ),
            itemCount: systems.length,
            itemBuilder: (context, index) {
              final sys = systems[index];
              final accent = _accentForIndex(index);
              final icon = _iconForSystem(sys.name);
              final total = sys.allItems.length;
              final withData = _svc.itemsWithData(sys);
              return _SystemCard(
                system: sys,
                icon: icon,
                accent: accent,
                total: total,
                withData: withData,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LabSystemScreen(
                        system: sys,
                        service: _svc,
                        accent: accent,
                        icon: icon,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 20),
          _buildFooter(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(Icons.menu_book_outlined, size: 16, color: cs.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Reference: Harriet Lane Handbook, 22nd Edition',
              style: TextStyle(
                  fontSize: 12,
                  color: cs.onSurface.withValues(alpha: 0.65)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static Color _accentForIndex(int i) {
    const colours = [
      Color(0xFFE53935),
      Color(0xFF8E24AA),
      Color(0xFF1E88E5),
      Color(0xFF43A047),
      Color(0xFFD81B60),
      Color(0xFF00ACC1),
      Color(0xFF5E35B1),
      Color(0xFF00897B),
      Color(0xFF039BE5),
      Color(0xFF1565C0),
      Color(0xFFE65100),
      Color(0xFF6D4C41),
      Color(0xFFF57F17),
      Color(0xFF0097A7),
      Color(0xFF880E4F),
      Color(0xFFBF360C),
      Color(0xFF37474F),
    ];
    return colours[i % colours.length];
  }

  static IconData _iconForSystem(String name) {
    switch (name.toLowerCase().trim()) {
      case 'cardiology':
        return Icons.monitor_heart_outlined;
      case 'endocrinology':
        return Icons.science_outlined;
      case 'fluids & electrolytes':
        return Icons.water_drop_outlined;
      case 'gastroenterology':
        return Icons.lunch_dining_outlined;
      case 'genetics':
        return Icons.biotech_outlined;
      case 'hematology':
        return Icons.bloodtype_outlined;
      case 'immunology & allergy':
        return Icons.vaccines_outlined;
      case 'microbiology & infectious disease':
        return Icons.bug_report_outlined;
      case 'neonatology':
        return Icons.child_care_outlined;
      case 'nephrology':
        return Icons.opacity_outlined;
      case 'nutrition & growth':
        return Icons.restaurant_outlined;
      case 'oncology':
        return Icons.healing_outlined;
      case 'poisonings':
        return Icons.warning_amber_outlined;
      case 'pulmonology':
        return Icons.air_outlined;
      case 'rheumatology':
        return Icons.accessibility_new_outlined;
      case 'trauma & critical care':
        return Icons.emergency_outlined;
      default:
        return Icons.medical_services_outlined;
    }
  }
}

// ── System card ───────────────────────────────────────────────────────────────

class _SystemCard extends StatelessWidget {
  final LabSystem system;
  final IconData icon;
  final Color accent;
  final int total;
  final int withData;
  final VoidCallback onTap;

  const _SystemCard({
    required this.system,
    required this.icon,
    required this.accent,
    required this.total,
    required this.withData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: accent, size: 20),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$withData/$total',
                      style: TextStyle(
                          fontSize: 11,
                          color: accent,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                system.name,
                style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Search result card ────────────────────────────────────────────────────────

class _SearchResultCard extends StatelessWidget {
  final LabSearchResult result;
  final VoidCallback onTap;

  const _SearchResultCard({required this.result, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dimmed = !result.hasData;
    return Card(
      elevation: 1,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: dimmed ? null : onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: dimmed ? 0.05 : 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            result.isGuide
                ? Icons.article_outlined
                : Icons.science_outlined,
            color: dimmed
                ? cs.onSurface.withValues(alpha: 0.3)
                : cs.primary,
            size: 20,
          ),
        ),
        title: Text(
          _displayName(result.itemName),
          style: TextStyle(
            color: dimmed
                ? cs.onSurface.withValues(alpha: 0.4)
                : cs.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        subtitle: Row(
          children: [
            Chip(
              label: Text(
                result.system,
                style: TextStyle(
                    fontSize: 10,
                    color: dimmed
                        ? cs.onSurface.withValues(alpha: 0.3)
                        : cs.primary),
              ),
              backgroundColor: cs.primary.withValues(alpha: dimmed ? 0.04 : 0.1),
              padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
            ),
            if (dimmed) ...[
              const SizedBox(width: 6),
              Icon(Icons.lock_outline,
                  size: 12, color: cs.onSurface.withValues(alpha: 0.3)),
              const SizedBox(width: 2),
              Text('Coming Soon',
                  style: TextStyle(
                      fontSize: 10,
                      color: cs.onSurface.withValues(alpha: 0.35),
                      fontStyle: FontStyle.italic)),
            ],
          ],
        ),
        trailing: dimmed
            ? null
            : Icon(Icons.chevron_right,
                color: cs.onSurface.withValues(alpha: 0.35)),
      ),
    );
  }

  static String _displayName(String name) =>
      name.replaceFirst(RegExp(r'^TABLE\s+[\d.]+:\s*', caseSensitive: false), '');
}
