// =============================================================================
// screens/formulary_v3/formulary_v3_hub.dart
//
// The list screen for Drug Formulary 3.0 — search + an A–Z sectioned list,
// the same shape a physical formulary already has, rather than inventing a
// grouping (by drug class, by system) the book doesn't use and extraction
// didn't capture reliably enough to sort by.
// =============================================================================

import 'package:flutter/material.dart';

import 'drug_detail_v3_screen.dart';
import 'drug_entry_v3.dart';
import 'formulary_v3_data.dart';

class FormularyV3Hub extends StatefulWidget {
  const FormularyV3Hub({super.key});

  @override
  State<FormularyV3Hub> createState() => _FormularyV3HubState();
}

class _FormularyV3HubState extends State<FormularyV3Hub> {
  String _query = '';

  List<DrugEntryV3> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return allFormularyV3Drugs;
    return allFormularyV3Drugs
        .where((d) =>
            d.name.toLowerCase().contains(q) ||
            d.brandNames.toLowerCase().contains(q) ||
            d.drugClass.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final items = _filtered;

    final groups = <String, List<DrugEntryV3>>{};
    for (final d in items) {
      final letter = d.name.isEmpty ? '#' : d.name[0].toUpperCase();
      groups.putIfAbsent(letter, () => []).add(d);
    }
    final letters = groups.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drug Formulary 3.0'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search ${allFormularyV3Drugs.length} drugs…',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: cs.outline.withValues(alpha: 0.3)),
                ),
              ),
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text('No drugs match "$_query"',
                        style: TextStyle(color: cs.onSurface.withValues(alpha: 0.5))),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: letters.length,
                    itemBuilder: (_, i) {
                      final letter = letters[i];
                      final drugs = groups[letter]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 14, 2, 8),
                            child: Text(letter,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: cs.primary)),
                          ),
                          for (final d in drugs) _DrugTile(drug: d),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _DrugTile extends StatelessWidget {
  const _DrugTile({required this.drug});
  final DrugEntryV3 drug;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final title = titleCaseDrugName(drug.name);
    // A cross-reference entry's only content is "See <other drug>" — shown as
    // a lighter row so it reads as a pointer, not a full monograph.
    final isCrossRef = drug.doseSections.isEmpty &&
        drug.formulations.isEmpty &&
        drug.remarks.length == 1 &&
        drug.remarks.first.trim().toLowerCase().startsWith('see ');

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outline.withValues(alpha: 0.12)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DrugDetailV3Screen(drug: drug)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: isCrossRef
                                  ? cs.onSurface.withValues(alpha: 0.55)
                                  : cs.onSurface)),
                      if (isCrossRef)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(drug.remarks.first,
                              style: TextStyle(
                                  fontSize: 11.5,
                                  fontStyle: FontStyle.italic,
                                  color: cs.onSurface.withValues(alpha: 0.5))),
                        )
                      else if (drug.drugClass.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(drug.drugClass,
                              style: TextStyle(
                                  fontSize: 11.5,
                                  color: cs.onSurface.withValues(alpha: 0.6))),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right,
                    size: 20, color: cs.onSurface.withValues(alpha: 0.35)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
