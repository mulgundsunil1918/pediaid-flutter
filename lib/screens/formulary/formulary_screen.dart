import 'package:flutter/material.dart';
import '../../services/formulary_service.dart';
import 'drug_pdf_viewer_screen.dart';
import '../drugs/emergency_nicu_drugs_screen.dart';

enum _Source { none, neofax, harrietLane }

class FormularyScreen extends StatefulWidget {
  const FormularyScreen({super.key});

  @override
  State<FormularyScreen> createState() => _FormularyScreenState();
}

class _FormularyScreenState extends State<FormularyScreen> {
  final FormularyService _service = FormularyService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  _Source _selectedSource = _Source.none;
  List<DrugEntry>? _results;
  bool _loading = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _selectSource(_Source source) async {
    if (_selectedSource == source) return;
    _searchController.clear();
    _query = '';
    setState(() {
      _selectedSource = source;
      _loading = true;
      _results = null;
    });
    final all = source == _Source.neofax
        ? await _service.getAllNeofax()
        : await _service.getAllHarrietLane();
    if (mounted) {
      setState(() {
        _results = all;
        _loading = false;
      });
    }
  }

  void _onSearchChanged() {
    final q = _searchController.text.trim();
    if (q == _query) return;
    _query = q;
    _runSearch(q);
  }

  Future<void> _runSearch(String q) async {
    if (_selectedSource == _Source.none) return;
    setState(() => _loading = true);
    final results = _selectedSource == _Source.neofax
        ? await _service.searchNeofax(q)
        : await _service.searchHarrietLane(q);
    if (mounted) {
      setState(() {
        _results = results;
        _loading = false;
      });
    }
  }

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
          'Drug Formulary',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            _buildSourceSelector(),
            if (_selectedSource != _Source.none) ...[
              _buildSearchBar(),
              Expanded(child: _buildContent()),
            ],
          ],
        ),
      ),
    );
  }

  // ── Source selector ──────────────────────────────────────────────────────────

  Widget _buildSourceSelector() {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Source',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SourceCard(
                    icon: Icons.child_care,
                    label: 'Neonatology',
                    sublabel: 'Neofax',
                    count: '200 drugs',
                    selected: _selectedSource == _Source.neofax,
                    onTap: () => _selectSource(_Source.neofax),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SourceCard(
                    icon: Icons.people_alt_outlined,
                    label: 'Paediatrics',
                    sublabel: 'Harriet Lane',
                    count: '457 drugs',
                    selected: _selectedSource == _Source.harrietLane,
                    onTap: () => _selectSource(_Source.harrietLane),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _EmergencyDrugsCard(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const EmergencyNICUDrugsScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Search bar ───────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    final cs = Theme.of(context).colorScheme;
    final hint = _selectedSource == _Source.neofax
        ? 'Search Neofax...'
        : 'Search Harriet Lane...';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        style: TextStyle(color: cs.onSurface),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.45), fontSize: 14),
          prefixIcon: Icon(Icons.search, color: cs.onSurface.withValues(alpha: 0.45)),
          suffixIcon: _query.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close, color: cs.onSurface.withValues(alpha: 0.45)),
                  onPressed: () {
                    _searchController.clear();
                    _searchFocus.unfocus();
                  },
                )
              : null,
          filled: true,
          // fillColor deliberately omitted — inherits from inputDecorationTheme
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: cs.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: cs.primary, width: 1.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }

  // ── Drug list ────────────────────────────────────────────────────────────────

  Widget _buildContent() {
    final cs = Theme.of(context).colorScheme;

    if (_loading) {
      return Center(
        child: CircularProgressIndicator(color: cs.primary),
      );
    }

    final results = _results ?? [];

    if (results.isEmpty && _query.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 48,
                  color: cs.onSurface.withValues(alpha: 0.4)),
              const SizedBox(height: 12),
              Text(
                'No results for \'$_query\'',
                style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (context, index) =>
          Divider(color: cs.outline, height: 1),
      itemBuilder: (context, index) {
        final entry = results[index];
        return ListTile(
          tileColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(
            entry.name,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
                fontSize: 16),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'p.${entry.page}',
                  style: TextStyle(
                      fontSize: 12,
                      color: cs.primary,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.chevron_right,
                  color: cs.onSurface.withValues(alpha: 0.4)),
            ],
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => DrugPdfViewerScreen(entry: entry)),
          ),
        );
      },
    );
  }
}

// ── Source card widget ────────────────────────────────────────────────────────

class _SourceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final String count;
  final bool selected;
  final VoidCallback onTap;

  const _SourceCard({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? cs.primary.withValues(alpha: 0.15)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? cs.primary : cs.outline,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: selected ? 0.15 : 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: cs.primary, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              count,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withValues(alpha: selected ? 0.9 : 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Emergency NICU Drugs shortcut card
//
// Deep-red tile surfaced at the top of the Formulary screen. A subtle
// pulsing white dot on the right makes it visibly different from the
// normal source cards — flags this as an emergency / high-priority tool
// without screaming.
// ─────────────────────────────────────────────────────────────────────────────

class _EmergencyDrugsCard extends StatefulWidget {
  const _EmergencyDrugsCard({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_EmergencyDrugsCard> createState() => _EmergencyDrugsCardState();
}

class _EmergencyDrugsCardState extends State<_EmergencyDrugsCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFB71C1C),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFB71C1C).withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.emergency, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Emergency NICU Drugs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Weight-based · Preparation Guide',
                    style: TextStyle(
                      color: Color(0xCCFFFFFF),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Pulsing white dot — attention indicator.
            AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) {
                final t = _pulse.value;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 22 + (6 * t),
                      height: 22 + (6 * t),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.25 * (1 - t)),
                      ),
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
