// =============================================================================
// neonatology_list_screen.dart
// Searchable list of all 199 v2 Neonatology drugs.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'formulary_v2_service.dart';
import '../formulary/drug_detail_v2_screen.dart';

class NeonatologyListScreen extends StatefulWidget {
  const NeonatologyListScreen({super.key});

  @override
  State<NeonatologyListScreen> createState() =>
      _NeonatologyListScreenState();
}

class _NeonatologyListScreenState extends State<NeonatologyListScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  List<FormularyV2Drug>? _drugs;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final drugs = await FormularyV2Service.instance.loadNeonatology();
    if (mounted) setState(() => _drugs = drugs);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final all = _drugs;
    final q = _query.trim().toLowerCase();
    final filtered = all == null
        ? null
        : (q.isEmpty
            ? all
            : all.where((d) {
                if (d.drug.toLowerCase().contains(q)) return true;
                if (d.altNames.any((a) => a.toLowerCase().contains(q))) {
                  return true;
                }
                if (d.category.toLowerCase().contains(q)) return true;
                return false;
              }).toList());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Neonatology Formulary',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 16, fontWeight: FontWeight.w800)),
            Text(
                all == null
                    ? 'Loading…'
                    : '${all.length} drugs · v2.0 (Neofax-derived)',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 11, color: Colors.white.withValues(alpha: 0.85))),
          ],
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              style: GoogleFonts.plusJakartaSans(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search drug, alt name, category…',
                hintStyle: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.5),
                    fontSize: 13),
                prefixIcon: Icon(Icons.search,
                    color: cs.onSurface.withValues(alpha: 0.55)),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24)),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                filled: true,
                isDense: true,
              ),
            ),
          ),
          if (filtered == null)
            const Expanded(
                child: Center(child: CircularProgressIndicator()))
          else if (filtered.isEmpty)
            Expanded(
                child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text('No drugs match "$_query".',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: cs.onSurface.withValues(alpha: 0.55))),
                    )))
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const SizedBox(height: 6),
                itemBuilder: (_, i) {
                  final d = filtered[i];
                  return _DrugRow(drug: d);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _DrugRow extends StatelessWidget {
  final FormularyV2Drug drug;
  const _DrugRow({required this.drug});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DrugDetailV2Screen(
            name: drug.drug,
            source: 'Neofax',
            pdfPage:
                (drug.sources['primary_neofax_page'] as num?)?.toInt() ?? 1,
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: cs.onSurface.withValues(alpha: 0.10)),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(drug.drug,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface)),
                  if (drug.category.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(drug.category,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: cs.onSurface.withValues(alpha: 0.65))),
                  ],
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color:
                    const Color(0xFF1565C0).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('${drug.doses.length} doses',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1565C0))),
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right,
                color: cs.onSurface.withValues(alpha: 0.45)),
          ],
        ),
      ),
    );
  }
}
