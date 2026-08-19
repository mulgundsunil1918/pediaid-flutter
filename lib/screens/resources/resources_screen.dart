// =============================================================================
// lib/screens/resources/resources_screen.dart
//
// Downloadable clinical resources — growth charts, BP charts, scoring
// systems, official guidelines and teaching templates. Files are hosted on
// a shared Google Drive folder (already public, "anyone with the link");
// tapping a card opens the file's Drive page in the browser rather than
// downloading in-app, since Drive already handles preview/download there.
//
// Category list and items mirror landing/resources_data.json (the same
// catalog backing the SEO pages at info.pediaid.bridgr.co.in/resources/) —
// keep both in sync when adding a new resource.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/list_search_field.dart';

const String _kAll = 'All';
const String _kGrowthCharts = 'Growth Charts';
const String _kBpCharts = 'BP Charts';
const String _kJaundice = 'Jaundice';
const String _kScoring = 'Scoring Systems';
const String _kNeuro = 'Neurological Assessment';
const String _kVaccination = 'Vaccination';
const String _kEcho = 'Echocardiography';
const String _kVentilation = 'Ventilation';
const String _kQuickRef = 'Quick Reference';
const String _kGuidelines = 'Guidelines';
const String _kTeaching = 'Teaching Templates';
const String _kNutrition = 'Nutrition';
const String _kDrugs = 'Drug References';
const String _kCommunity = 'Community Paediatrics';
const String _kExam = 'Exam & Viva';

const List<String> _kCategories = [
  _kAll, _kGrowthCharts, _kBpCharts, _kJaundice, _kScoring, _kNeuro,
  _kVaccination, _kEcho, _kVentilation, _kQuickRef, _kGuidelines,
  _kTeaching, _kNutrition, _kDrugs, _kCommunity, _kExam,
];

const Map<String, IconData> _kCategoryIcons = {
  _kGrowthCharts: Icons.show_chart_rounded,
  _kBpCharts: Icons.favorite_rounded,
  _kJaundice: Icons.opacity_rounded,
  _kScoring: Icons.assessment_rounded,
  _kNeuro: Icons.psychology_outlined,
  _kVaccination: Icons.vaccines_outlined,
  _kEcho: Icons.monitor_heart_rounded,
  _kVentilation: Icons.air_rounded,
  _kQuickRef: Icons.menu_book_rounded,
  _kGuidelines: Icons.rule_rounded,
  _kTeaching: Icons.description_rounded,
  _kNutrition: Icons.restaurant_rounded,
  _kDrugs: Icons.medication_rounded,
  _kCommunity: Icons.groups_rounded,
  _kExam: Icons.school_rounded,
};

class ResourceItem {
  final String title;
  final String filename;
  final String driveId;
  final String category;

  const ResourceItem({
    required this.title,
    required this.filename,
    required this.driveId,
    required this.category,
  });

  IconData get icon => _kCategoryIcons[category] ?? Icons.insert_drive_file_rounded;

  Uri get driveUri => Uri.parse('https://drive.google.com/file/d/$driveId/view');
}

// Ported from landing/resources_data.json — keep the two in sync.
const List<ResourceItem> kResourceItems = [
  ResourceItem(title: 'WHO & IAP Growth Charts', filename: 'Growth charts WHO & IAP (1).pdf', driveId: '1r3lMy7gRckpSkzAabWVFrEKHoMu4SS7g', category: _kGrowthCharts),
  ResourceItem(title: 'Fenton 2025 Growth Chart — Boys', filename: 'Fentons 2025 - boys.pdf', driveId: '1Qu1CntSMS7lkVGXtfiOrO91vGUgiQBpD', category: _kGrowthCharts),
  ResourceItem(title: 'Fenton 2025 Growth Chart — Girls', filename: 'Fentons 2025 - girls.pdf', driveId: '1pN-2dyuG-WsxWvE6Iv4d5FTYpYAEAsPa', category: _kGrowthCharts),

  ResourceItem(title: 'AAP 2017 BP Chart', filename: 'AAP 2017 BP charts.pdf', driveId: '1Q1MmyPDjnn7x2vdszreX33Aiu-nXkES2', category: _kBpCharts),
  ResourceItem(title: 'Zubrow Neonatal BP Chart', filename: 'Zubrows BP charts.pdf', driveId: '1g0vcu8_Gxf7B3RzPKI8kPwEkHoh5XhhD', category: _kBpCharts),

  ResourceItem(title: 'AAP 2022 Jaundice Guideline', filename: 'AAP Jaudince 2022.pdf', driveId: '1BFJwNLICCnTFlah1q-RyIryP58sDANQl', category: _kJaundice),
  ResourceItem(title: 'NICE CG98 Preterm Jaundice Charts', filename: 'NICE Jaudice preterm charts .pdf', driveId: '1ne9-ekD0_DjeGAoRMZYcgZEhf_JmytPG', category: _kJaundice),

  ResourceItem(title: 'Modified Ballard Score Sheet', filename: 'BallardScore_scoresheet.pdf', driveId: '1Zv1Ki-5XHmU1RtXTa3dLZeux23En6ePn', category: _kScoring),
  ResourceItem(title: 'CAN Score Sheet', filename: 'CAN score .pdf', driveId: '1gFtr0R4BsldDozp2gM_WGH4zTSkMHNHe', category: _kScoring),
  ResourceItem(title: 'Thompson HIE Scoring', filename: 'Thompson Scoring HIE.pdf', driveId: '1m93906S_nA3SK4BQJIhcyK2RDQvPK7Fd', category: _kScoring),
  ResourceItem(title: 'Sarnat and Sarnat HIE Staging', filename: 'Sarnat and Sarnat.pdf', driveId: '1wsbckCYsHda6CW33b5AKZmwhaRED7LWU', category: _kScoring),
  ResourceItem(title: 'POFRAS Score Sheet', filename: 'POFRAS score.pdf', driveId: '1vd8Unkn6PPLHoCIg6XaGCph6cCYO0r6c', category: _kScoring),
  ResourceItem(title: 'LATCH Breastfeeding Score Sheet', filename: 'Latch score .pdf', driveId: '1w2mPkUm9mX8dOUrQ2uw5GhAvxrDdNvLF', category: _kScoring),
  ResourceItem(title: 'NICHD HIE / TIMEBRAIN Assessment', filename: 'NICHD Assessment TimeBrain May 2020.pdf', driveId: '1FMXB1_dDNr_euPYhQZwX1CKCLlB0awSt', category: _kScoring),

  ResourceItem(title: 'HINE, HNNE & Newborn Neuro Exam', filename: 'HINE , HNNE , CNS examination , Neurological assessment of newborns.pdf', driveId: '1ShGbKFA2CIrISfWdqY5vRMBYzxMGnpu6', category: _kNeuro),
  ResourceItem(title: 'Cranial USG Reference', filename: 'Cranial USG .pdf', driveId: '16HEfrmttQz01x2LVxD84gkzD2Vxe7SsW', category: _kNeuro),

  ResourceItem(title: 'IAP & NIS Vaccination Schedule', filename: 'IAP and NIS vaccination .pdf', driveId: '1klOuYQvRrUTYiXmhG2qJuPwbjhkAYvsX', category: _kVaccination),
  ResourceItem(title: 'IAP Immunisation Schedule 2022 (Print)', filename: 'Vaccination  FOR PRINT.pdf', driveId: '1JXWLV_chEsk5GXN9y7zRVBRZtQJLa2G6', category: _kVaccination),

  ResourceItem(title: 'Targeted Neonatal Echocardiography Manual', filename: 'TargetedNeonatalEchocardiographyTeachingManual-NewEdition.pdf', driveId: '1_sDOOI8T_GG-3GgzGsYWo8oOETjoOgGY', category: _kEcho),
  ResourceItem(title: 'Nursing & Echo Reference', filename: 'NSG AND ECHO.pdf', driveId: '1_tJmX1AFKXtWm0DigQ4313C4ob4J8uUU', category: _kEcho),

  ResourceItem(title: 'Mechanical Ventilation Manual', filename: 'Mechanical Ventilation Manual.pdf', driveId: '1NTlbQs5LTBCwIkziGQzKhBZ73DdJy6rb', category: _kVentilation),
  ResourceItem(title: 'Neonatal Ventilation Basics', filename: 'Neonatal-Ventilation.pdf', driveId: '1Kp8tPs2u3Ic96mG90TyQSnM4XTR7Zw7V', category: _kVentilation),

  ResourceItem(title: 'NNF Ready Reckoner', filename: 'NNF ready reckoner.pdf', driveId: '18ZkGozmhf0kBOhkYBvfCmDgibg_e4GUa', category: _kQuickRef),

  ResourceItem(title: 'IAP Standard Treatment Guidelines (Combined)', filename: 'COMBINED PDF STANDARD TREATMENT GUIDELINE UPTO 093.pdf', driveId: '1pib_nWnN2JRssBCvDNzO52r_1L_k-tIC', category: _kGuidelines),

  ResourceItem(title: 'Acute Neonate Case Proforma', filename: 'Acute History neonate - Sunil.pdf', driveId: '18-_kzcUQql0qzzMQTQ03F217eTKUYXDq', category: _kTeaching),
  ResourceItem(title: 'Growing Preterm Case Proforma', filename: 'Growing Preterm Case Proforma Sunil.pdf', driveId: '1y-pb-PoXVDb1kxo6EGYtOU7RkpvRVbkC', category: _kTeaching),

  ResourceItem(title: 'Nutritional Audit in Preterm Babies', filename: 'Nutritional Audit in Preterm babies.xlsx', driveId: '1TyyGLgEr0cAUfYwCZJ6lRQRf7sy37nN7', category: _kNutrition),

  // ── Added 2026-08-19 from the shared Drive folder ──────────────────────
  ResourceItem(title: 'BLS & Choking Algorithms', filename: 'BLS and CHOKING.pdf', driveId: '146RHWabJWdl6gyTJ5ZFWdRSOuFz8ViCI', category: _kGuidelines),
  ResourceItem(title: 'NRP 9th Edition Manual', filename: 'NRP 9th edition.pdf', driveId: '1zgi3OyKiBIg4Z-lBYZya4fRaVeIOjyW6', category: _kGuidelines),
  ResourceItem(title: 'PALS Algorithms 2020', filename: 'PALS-Algorithms-2020.pdf', driveId: '1F_0BTUc9BbU2C1Ef1JB41TLsvFH7-KBB', category: _kGuidelines),
  ResourceItem(title: 'NeoFax (Nov 2024)', filename: 'NEOFAX NOV. 2024.pdf', driveId: '1n-zeI8Duyn3cl-xOVPW03Vs203Djg2ro', category: _kDrugs),
  ResourceItem(title: 'Frank Shann Drug Doses (2017)', filename: 'Drug_Dose_Frank_Shann_2017_pdf.pdf', driveId: '1tcJRA5e89lZSQhuqLJPbPxzEFX1O_FpY', category: _kDrugs),
  ResourceItem(title: 'Immunisation in Special Situations', filename: 'IMMUNIZATION  IN SPECIAL SITUATIONS..pptx', driveId: '10QcNd5CZm61lsZgzHdNHuwlCffH8VkPT', category: _kVaccination),
  ResourceItem(title: 'Paediatric Nutrition', filename: 'PEDIATRIC NUTRITION .pdf', driveId: '13m-w6J6__1y545j_OYE4jVckRak5qYSj', category: _kNutrition),
  ResourceItem(title: 'Nutritive Value of Common Foods', filename: 'NUTRITIVE VALUE OF COMMON FOODS.pptx', driveId: '1vVm6Yw0Em9tQSvRQjNwqcObXH3ltn8EV', category: _kNutrition),
  ResourceItem(title: 'Cerebral Palsy Case Presentation', filename: 'Cerebral palsy case presentation notes.pdf', driveId: '1KROf-QRzkIJ1HX9MG9Ov0zwlL3Q8zT66', category: _kTeaching),
  ResourceItem(title: 'Paediatric Case Format', filename: 'Pedia format.pdf', driveId: '1asI_XR4olS6QDeVLs0nVBd0c0Epe2cOT', category: _kTeaching),
  ResourceItem(title: 'Social Paediatrics', filename: 'Social pediatrics.pdf', driveId: '1H8BPF06HeDC8Vhl3WkQV1snJq7FyS5tF', category: _kCommunity),
  ResourceItem(title: 'National Health Programmes — Brief Notes', filename: 'BRIEF NOTES ON NATIONAL HEALTH PROGRAMS.pdf', driveId: '1cVxtjNFLLETB6CItJ6t_S2nK7CFMqQOt', category: _kCommunity),
  ResourceItem(title: 'Sankalan — National Health Programmes Handbook', filename: 'Sankalan-National Health Programmes Handbook.pdf', driveId: '1HQXZ951u2v7tGnVTkXToGo5gotXKAbS8', category: _kCommunity),
  ResourceItem(title: 'NNF Fellowship Question Bank (to 2026)', filename: 'NNF Fellowship All QBANK till 2026.pdf', driveId: '1SCrguB_n4S8VV0LUUjvXjwBzTuRfEsZN', category: _kExam),
  ResourceItem(title: 'MD Paediatrics Question Paper Compilation', filename: 'M.D., Peds Qn. Paper Compilation.pdf', driveId: '1l7s9uso3GQu2L75ozx3K_QY1L1KZDyV_', category: _kExam),
  ResourceItem(title: 'System-wise Question Bank', filename: 'Systemwise question bank-1-1.pdf (1).pdf', driveId: '18RKkAjF0tadrYsfDAUPPsW14xIih540x', category: _kExam),
  ResourceItem(title: 'Instruments Viva', filename: 'INSTRUMENTS VIVA.pptx', driveId: '12vLfM3D1whyNyHuY_M8qPMX9CGjGXj9A', category: _kExam),
  ResourceItem(title: 'Instruments Reference', filename: 'Instruments.pdf', driveId: '1WTgyAYQh07h-dZSvSBEMFy71nJQH_ETj', category: _kExam),
  ResourceItem(title: 'Final Year X-Ray Viva', filename: 'final year X rays viva-1.pptx', driveId: '1rdpM0Mio1WKpN1FKg0KecBBke9HDHIw0', category: _kExam),
  ResourceItem(title: 'X-Ray Viva — PG', filename: 'xray-pg.pptx', driveId: '1XgQ_iZh0z8xK5U-cSi9AusWVPThiVzGj', category: _kExam),
];

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  String _selected = _kAll;
  final TextEditingController _searchCtl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  /// A query searches every resource, not just the selected chip's — a hit
  /// hidden behind an unrelated chip reads as "not in the app".
  List<ResourceItem> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      return kResourceItems
          .where((r) =>
              r.title.toLowerCase().contains(q) ||
              r.filename.toLowerCase().contains(q) ||
              r.category.toLowerCase().contains(q))
          .toList();
    }
    return _selected == _kAll
        ? kResourceItems
        : kResourceItems.where((r) => r.category == _selected).toList();
  }

  int _countFor(String category) {
    if (category == _kAll) return kResourceItems.length;
    return kResourceItems.where((r) => r.category == category).length;
  }

  Future<void> _openResource(BuildContext context, ResourceItem item) async {
    final ok = await launchUrl(item.driveUri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open ${item.filename}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Resources'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: SafeArea(
        bottom: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            final cols = isWide ? 3 : 2;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                      child: Text(
                        'Free PDFs for bedside and teaching use — tap a card to open '
                        'it in Drive.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    _CategoryChipBar(
                      categories: _kCategories,
                      selected: _selected,
                      onSelect: (c) => setState(() {
                        _selected = c;
                        _query = '';
                        _searchCtl.clear();
                      }),
                      countFor: _countFor,
                    ),
                    ListSearchField(
                      controller: _searchCtl,
                      hintText:
                          'Search ${kResourceItems.length} resources…',
                      onChanged: (v) => setState(() => _query = v),
                      padding: const EdgeInsets.fromLTRB(14, 2, 14, 6),
                    ),
                    Expanded(
                      child: filtered.isEmpty
                          ? (_query.trim().isEmpty
                              ? const _EmptyState()
                              : ListSearchEmptyState(
                                  query: _searchCtl.text, noun: 'resources'))
                          : GridView.builder(
                              padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                              itemCount: filtered.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: cols,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1.1,
                              ),
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                return _ResourceCard(
                                  item: item,
                                  onTap: () => _openResource(context, item),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryChipBar extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final int Function(String) countFor;
  final ValueChanged<String> onSelect;
  const _CategoryChipBar({
    required this.categories,
    required this.selected,
    required this.countFor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // One scrolling line, not a wrapped block. Twelve categories wrapped to
    // six rows on a phone and pushed the resources themselves below the fold
    // — you arrived at a filter and had to scroll past it to reach anything
    // worth filtering. Sideways it is: the selected chip stays visible at the
    // start, and the row is obviously draggable because chips are clipped at
    // the right edge rather than ending neatly.
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
        physics: const ClampingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = categories[i];
          // Center, so the chip keeps its own height instead of being
          // stretched to the row's by the horizontal list's constraints.
          return Center(
            child: _chip(
              cs,
              label: cat,
              count: countFor(cat),
              selected: cat == selected,
              onTap: () => onSelect(cat),
            ),
          );
        },
      ),
    );
  }

  Widget _chip(
    ColorScheme cs, {
    required String label,
    required int count,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? cs.primary : cs.surfaceContainerHighest.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? cs.primary : cs.outlineVariant.withValues(alpha: 0.45),
            width: selected ? 1 : 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: selected ? cs.onPrimary : cs.onSurface,
                letterSpacing: 0.05,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: selected
                    ? cs.onPrimary.withValues(alpha: 0.20)
                    : cs.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: selected ? cs.onPrimary : cs.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.filter_alt_off_outlined, size: 48, color: cs.onSurface.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          Text(
            'Nothing in this category yet.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final ResourceItem item;
  final VoidCallback onTap;

  const _ResourceCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isXlsx = item.filename.toLowerCase().endsWith('.xlsx');
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.icon, color: primary, size: 22),
                  ),
                  const Spacer(),
                  Icon(
                    isXlsx ? Icons.grid_on_rounded : Icons.download_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                item.title,
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                item.category,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
