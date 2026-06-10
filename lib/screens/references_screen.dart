// =============================================================================
// references_screen.dart — References & Citations
//
// Lists every primary source used in PediAid: drug databases, growth chart
// standards, clinical guidelines, and calculator references.
// Added to satisfy App Store guideline 1.4.1 (medical apps must cite sources).
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferencesScreen extends StatelessWidget {
  const ReferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('References & Sources',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _disclaimer(context, isDark, cs),
          const SizedBox(height: 20),
          _section(context, 'Drug References', Icons.medication_rounded,
              const Color(0xFF1E3A5F), [
            _Ref(
              title: 'Neofax®',
              subtitle: 'Neonatal drug reference',
              detail:
                  'Neofax® is a leading neonatal drug reference used by clinicians worldwide. '
                  'All neonatal drug dosage data in PediAid is sourced from Neofax.',
              url: 'https://www.micromedexsolutions.com',
            ),
            _Ref(
              title: 'Harriet Lane Handbook®',
              subtitle: 'Paediatric drug & clinical reference',
              detail:
                  'The Harriet Lane Handbook is a standard paediatric clinical reference published '
                  'by Johns Hopkins. Paediatric drug dosages in PediAid are sourced from this reference.',
              url: 'https://www.elsevier.com/books/the-harriet-lane-handbook',
            ),
          ]),
          const SizedBox(height: 16),
          _section(context, 'Clinical Practice Guidelines',
              Icons.menu_book_rounded, const Color(0xFF065F46), [
            _Ref(
              title: 'IAP Standard Treatment Guidelines 2022',
              subtitle: 'Indian Academy of Pediatrics',
              detail:
                  'Consensus-based guidelines covering 149 paediatric and neonatal topics — '
                  'definitions, evaluation, management flowcharts and follow-up.',
              url: 'https://iapindia.org',
            ),
            _Ref(
              title: 'IAP Action Plan 2026',
              subtitle: 'Indian Academy of Pediatrics',
              detail:
                  'Practice guidelines and action plans for common paediatric conditions, '
                  'published by the Indian Academy of Pediatrics.',
              url: 'https://iapindia.org',
            ),
            _Ref(
              title: 'NNF Clinical Practice Guidelines',
              subtitle: 'National Neonatology Forum of India',
              detail:
                  'Evidence-based neonatal clinical practice guidelines published by the '
                  'National Neonatology Forum of India.',
              url: 'https://nnfi.org',
            ),
            _Ref(
              title: 'AAP CPG: Hyperbilirubinemia (2022)',
              subtitle: 'American Academy of Pediatrics',
              detail:
                  'AAP Clinical Practice Guideline: Management of hyperbilirubinemia in '
                  'newborn infants 35 or more weeks of gestation. Pediatrics, 2022.',
              url:
                  'https://publications.aap.org/pediatrics/article/150/3/e2022058859/188726',
            ),
            _Ref(
              title: 'NICE CG98: Neonatal Jaundice',
              subtitle: 'National Institute for Health and Care Excellence',
              detail:
                  'NICE Clinical Guideline CG98: Neonatal jaundice. '
                  'National Institute for Health and Care Excellence, UK.',
              url: 'https://www.nice.org.uk/guidance/cg98',
            ),
          ]),
          const SizedBox(height: 16),
          _section(context, 'Growth Chart Standards',
              Icons.show_chart_rounded, const Color(0xFF7C3AED), [
            _Ref(
              title: 'WHO Child Growth Standards (0–5 years)',
              subtitle: 'World Health Organization, 2006',
              detail:
                  'WHO Multicentre Growth Reference Study. WHO child growth standards: '
                  'length/height-for-age, weight-for-age, weight-for-length, weight-for-height '
                  'and body mass index-for-age.',
              url: 'https://www.who.int/tools/child-growth-standards',
            ),
            _Ref(
              title: 'WHO Growth Reference (5–19 years)',
              subtitle: 'World Health Organization, 2007',
              detail:
                  'WHO Reference 2007 for school-age children and adolescents. '
                  'de Onis M et al. Bull World Health Organ. 2007.',
              url:
                  'https://www.who.int/tools/growth-reference-data-for-5to19-years',
            ),
            _Ref(
              title: 'IAP Growth Charts 2015',
              subtitle: 'Indian Academy of Pediatrics',
              detail:
                  'Revised IAP growth charts for height, weight, and body mass index '
                  'for 5–18-year-old Indian children. Indian Pediatrics, 2015.',
              url: 'https://iapindia.org',
            ),
            _Ref(
              title: 'Fenton Preterm Growth Chart (2013)',
              subtitle: 'Tanis R. Fenton & Jae H. Kim',
              detail:
                  'A systematic review and meta-analysis to revise the Fenton growth chart '
                  'for preterm infants. BMC Pediatrics, 2013.',
              url:
                  'https://bmcpediatr.biomedcentral.com/articles/10.1186/1471-2431-13-59',
            ),
            _Ref(
              title: 'INTERGROWTH-21st Standards',
              subtitle: 'International Fetal and Newborn Growth Consortium',
              detail:
                  'International standards for newborn weight, length, and head circumference '
                  'by gestational age and sex. Villar J et al. Lancet, 2014.',
              url: 'https://intergrowth21.tghn.org',
            ),
          ]),
          const SizedBox(height: 16),
          _section(context, 'Calculator References',
              Icons.calculate_rounded, const Color(0xFFB45309), [
            _Ref(
              title: 'Schwartz Formula (eGFR)',
              subtitle: 'Kidney function estimation in children',
              detail:
                  'Schwartz GJ et al. New equations to estimate GFR in children with CKD. '
                  'J Am Soc Nephrol. 2009.',
            ),
            _Ref(
              title: 'Mosteller Formula (BSA)',
              subtitle: 'Body surface area calculation',
              detail:
                  'Mosteller RD. Simplified calculation of body-surface area. '
                  'N Engl J Med. 1987.',
            ),
            _Ref(
              title: 'Nelson Textbook of Pediatrics',
              subtitle: '21st Edition — General paediatric reference',
              detail:
                  'Kliegman RM et al. Nelson Textbook of Pediatrics, 21st Edition. '
                  'Elsevier, 2020. Used for general paediatric normal ranges and reference values.',
              url: 'https://www.elsevier.com/books/nelson-textbook-of-pediatrics',
            ),
          ]),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'PediAid is intended for use by qualified healthcare professionals only.\n'
              'Always verify clinical information with current institutional protocols.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                height: 1.5,
                color: cs.onSurface.withValues(alpha: 0.45),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _disclaimer(
      BuildContext context, bool isDark, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A1A2E)
            : const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? const Color(0xFF4F46E5).withValues(alpha: 0.4)
              : const Color(0xFFC7D2FE),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              size: 18,
              color: isDark
                  ? const Color(0xFF818CF8)
                  : const Color(0xFF4F46E5)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'All clinical content in PediAid is sourced from peer-reviewed references '
              'and established medical guidelines listed below. Content is regularly reviewed '
              'but may not reflect the latest updates. Clinical judgement must always be applied.',
              style: TextStyle(
                fontSize: 12.5,
                height: 1.5,
                color: isDark
                    ? const Color(0xFF818CF8)
                    : const Color(0xFF3730A3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title, IconData icon,
      Color color, List<_Ref> refs) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Text(title,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color)),
        ]),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E1E2E)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.grey.shade200,
            ),
          ),
          child: Column(
            children: [
              for (int i = 0; i < refs.length; i++) ...[
                if (i > 0)
                  Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.07)
                          : Colors.grey.shade100),
                _RefTile(ref: refs[i], color: color),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Ref {
  final String title;
  final String subtitle;
  final String detail;
  final String? url;

  const _Ref({
    required this.title,
    required this.subtitle,
    required this.detail,
    this.url,
  });
}

class _RefTile extends StatelessWidget {
  final _Ref ref;
  final Color color;

  const _RefTile({required this.ref, required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: ref.url != null
          ? () => launchUrl(Uri.parse(ref.url!),
              mode: LaunchMode.externalApplication)
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: Text(ref.title,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface)),
              ),
              if (ref.url != null) ...[
                const SizedBox(width: 6),
                Icon(Icons.open_in_new_rounded,
                    size: 14,
                    color: color.withValues(alpha: 0.7)),
              ],
            ]),
            const SizedBox(height: 2),
            Text(ref.subtitle,
                style: TextStyle(
                    fontSize: 11.5,
                    color: color,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Text(ref.detail,
                style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: cs.onSurface.withValues(alpha: 0.6))),
          ],
        ),
      ),
    );
  }
}
