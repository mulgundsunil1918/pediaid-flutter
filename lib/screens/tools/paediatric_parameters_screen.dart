import 'package:flutter/material.dart';

// ── Reference data ─────────────────────────────────────────────────────────────
const Map<String, Map<String, String>> paedParamData = {
  'Premie': {
    'Weight': '2.5–3.5 kg',
    'Bag Valve Mask': 'Infant',
    'Nasal Airway': '12 Fr',
    'Oral Airway': 'Infant 50 mm',
    'Blade': 'MIL 0',
    'ETT': '2.5–3.0',
    'LMA': '1',
    'Glidescope': '1',
    'IV Catheter': '22–24 ga',
    'CVL': '3 Fr',
    'NGT / OGT': '5 Fr',
    'Chest Tube': '10–12 Fr',
    'Foley': '6 Fr',
  },
  'Newborn': {
    'Weight': '3.5–4 kg',
    'Bag Valve Mask': 'Infant',
    'Nasal Airway': '12 Fr',
    'Oral Airway': 'Small 60 mm',
    'Blade': 'MIL 0',
    'ETT': '3.0–3.5',
    'LMA': '1',
    'Glidescope': '1 or 2',
    'IV Catheter': '22–24 ga',
    'CVL': '3–4 Fr',
    'NGT / OGT': '5–8 Fr',
    'Chest Tube': '10–12 Fr',
    'Foley': '8 Fr',
  },
  '6 Months': {
    'Weight': '6–8 kg',
    'Bag Valve Mask': 'Small Child',
    'Nasal Airway': '14–16 Fr',
    'Oral Airway': 'Small 60 mm',
    'Blade': 'MIL 1',
    'ETT': '3.5–4.0',
    'LMA': '1.5',
    'Glidescope': '2',
    'IV Catheter': '20–24 ga',
    'CVL': '4 Fr',
    'NGT / OGT': '8 Fr',
    'Chest Tube': '12–18 Fr',
    'Foley': '8 Fr',
  },
  '1 Year': {
    'Weight': '10 kg',
    'Bag Valve Mask': 'Small Child',
    'Nasal Airway': '14–16 Fr',
    'Oral Airway': 'Small 60 mm',
    'Blade': 'MIL 1, MAC 2',
    'ETT': '4.0–4.5',
    'LMA': '2',
    'Glidescope': '2',
    'IV Catheter': '20–24 ga',
    'CVL': '4–5 Fr',
    'NGT / OGT': '10 Fr',
    'Chest Tube': '16–20 Fr',
    'Foley': '8 Fr',
  },
  '2–3 Years': {
    'Weight': '13–16 kg',
    'Bag Valve Mask': 'Child',
    'Nasal Airway': '14–18 Fr',
    'Oral Airway': 'Small 70 mm',
    'Blade': 'MIL 1, MAC 2',
    'ETT': '4.5–5.0',
    'LMA': '2',
    'Glidescope': '3',
    'IV Catheter': '18–22 ga',
    'CVL': '4–5 Fr',
    'NGT / OGT': '10–12 Fr',
    'Chest Tube': '16–24 Fr',
    'Foley': '8 Fr',
  },
  '4–6 Years': {
    'Weight': '20–25 kg',
    'Bag Valve Mask': 'Child',
    'Nasal Airway': '14–18 Fr',
    'Oral Airway': 'Small 70–80 mm',
    'Blade': 'MIL 2, MAC 3',
    'ETT': '5.0–5.5',
    'LMA': '2.5',
    'Glidescope': '3',
    'IV Catheter': '18–22 ga',
    'CVL': '5 Fr',
    'NGT / OGT': '12–14 Fr',
    'Chest Tube': '20–28 Fr',
    'Foley': '8 Fr',
  },
  '7–10 Years': {
    'Weight': '25–35 kg',
    'Bag Valve Mask': 'Child / Small Adult',
    'Nasal Airway': '16–20 Fr',
    'Oral Airway': 'Medium 80–90 mm',
    'Blade': 'MIL 2, MAC 3',
    'ETT': '5.5–6.0',
    'LMA': '2.5–3',
    'Glidescope': '3',
    'IV Catheter': '18–22 ga',
    'CVL': '5 Fr',
    'NGT / OGT': '12–14 Fr',
    'Chest Tube': '20–32 Fr',
    'Foley': '8 Fr',
  },
  '11–15 Years': {
    'Weight': '40–50 kg',
    'Bag Valve Mask': 'Adult',
    'Nasal Airway': '18–22 Fr',
    'Oral Airway': 'Medium 90 mm',
    'Blade': 'MIL 2, MAC 3',
    'ETT': '6.0–6.5',
    'LMA': '3',
    'Glidescope': '3 or 4',
    'IV Catheter': '18–20 ga',
    'CVL': '7 Fr',
    'NGT / OGT': '14–18 Fr',
    'Chest Tube': '28–38 Fr',
    'Foley': '10 Fr',
  },
  '>16 Years': {
    'Weight': '>50 kg',
    'Bag Valve Mask': 'Adult',
    'Nasal Airway': '22–36 Fr',
    'Oral Airway': 'Medium 90 mm',
    'Blade': 'MIL 2, MAC 3',
    'ETT': '7.0–8.0',
    'LMA': '4',
    'Glidescope': '3 or 4',
    'IV Catheter': '16–20 ga',
    'CVL': '7 Fr',
    'NGT / OGT': '14–18 Fr',
    'Chest Tube': '28–42 Fr',
    'Foley': '12 Fr',
  },
};

const List<String> _ageGroups = [
  'Premie',
  'Newborn',
  '6 Months',
  '1 Year',
  '2–3 Years',
  '4–6 Years',
  '7–10 Years',
  '11–15 Years',
  '>16 Years',
];

// ── Screen ────────────────────────────────────────────────────────────────────
class PaediatricParametersScreen extends StatefulWidget {
  const PaediatricParametersScreen({super.key});

  @override
  State<PaediatricParametersScreen> createState() =>
      _PaediatricParametersScreenState();
}

class _PaediatricParametersScreenState
    extends State<PaediatricParametersScreen> {
  String? _selectedAge;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final params = _selectedAge != null ? paedParamData[_selectedAge!] : null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Paediatric Parameters'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header chip ─────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'HARRIET LANE REFERENCE',
                      style: TextStyle(
                        color: cs.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Paediatric Parameters & Equipment',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Age-based sizing guide for airway & vascular access',
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Age group dropdown ───────────────────────────────────
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Select Age Group',
                      prefixIcon:
                          Icon(Icons.child_care, color: cs.primary, size: 20),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedAge,
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      hint: Text(
                        'Choose age group…',
                        style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.4),
                            fontSize: 14),
                      ),
                      items: _ageGroups
                          .map((age) => DropdownMenuItem(
                                value: age,
                                child: Text(age),
                              ))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedAge = val),
                    ),
                  ),

                  // ── Results ──────────────────────────────────────────────
                  if (params != null) ...[
                    const SizedBox(height: 20),
                    _buildWeightCard(context, params['Weight'] ?? '—'),
                    const SizedBox(height: 12),
                    _buildEquipmentTable(context, params),
                    const SizedBox(height: 16),
                    _buildDisclaimer(context),
                  ] else ...[
                    const SizedBox(height: 32),
                    _buildPlaceholder(context),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Weight highlight card ───────────────────────────────────────────────────
  Widget _buildWeightCard(BuildContext context, String weight) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.monitor_weight_outlined,
              color: cs.onPrimary, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated Weight',
                  style: TextStyle(
                    color: cs.onPrimary.withValues(alpha: 0.75),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  weight,
                  style: TextStyle(
                    color: cs.onPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: cs.onPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _selectedAge ?? '',
              style: TextStyle(
                color: cs.onPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Equipment table ─────────────────────────────────────────────────────────
  Widget _buildEquipmentTable(
      BuildContext context, Map<String, String> params) {
    final cs = Theme.of(context).colorScheme;
    // All keys except Weight
    final entries = params.entries
        .where((e) => e.key != 'Weight')
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: List.generate(entries.length, (i) {
          final entry = entries[i];
          final isLast = i == entries.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 13),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          color: cs.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        entry.value,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: cs.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Theme.of(context).dividerColor,
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }),
      ),
    );
  }

  // ── Placeholder (no selection yet) ─────────────────────────────────────────
  Widget _buildPlaceholder(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(Icons.medical_services_outlined,
            size: 52, color: cs.onSurface.withValues(alpha: 0.2)),
        const SizedBox(height: 12),
        Text(
          'Select an age group above',
          style: TextStyle(
            color: cs.onSurface.withValues(alpha: 0.4),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Equipment sizes and parameters will appear here',
          style: TextStyle(
            color: cs.onSurface.withValues(alpha: 0.3),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ── Disclaimer ──────────────────────────────────────────────────────────────
  Widget _buildDisclaimer(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline,
              size: 16, color: cs.onSurface.withValues(alpha: 0.4)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Reference: Harriet Lane Handbook',
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
