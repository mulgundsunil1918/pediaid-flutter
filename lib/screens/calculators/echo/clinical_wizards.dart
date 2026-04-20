// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

// =============================================================================
// Severity colour constants
// =============================================================================
const Color _green = Color(0xFF2E7D32);
const Color _amber = Color(0xFFF57C00);
const Color _red = Color(0xFFC62828);

// =============================================================================
// Shared helper: _WizardSection
// =============================================================================
class _WizardSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _WizardSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: cs.onSurface.withValues(alpha: 0.55),
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...children.map(
            (c) => Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: c,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Shared helper: _WizardInputField
// =============================================================================
class _WizardInputField extends StatelessWidget {
  final String label;
  final String hint;
  final String? unit;
  final TextEditingController controller;
  final bool optional;

  const _WizardInputField({
    required this.label,
    required this.hint,
    required this.controller,
    this.unit,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: cs.onSurface.withValues(alpha: 0.7),
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (optional) ...[
              const SizedBox(width: 6),
              Text(
                '(optional)',
                style: GoogleFonts.plusJakartaSans(
                  color: cs.onSurface.withValues(alpha: 0.4),
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.plusJakartaSans(
            color: cs.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              color: cs.onSurface.withValues(alpha: 0.35),
              fontSize: 13,
            ),
            suffixText: unit,
            suffixStyle: GoogleFonts.plusJakartaSans(
              color: cs.onSurface.withValues(alpha: 0.55),
              fontSize: 12.5,
            ),
            filled: true,
            fillColor: cs.onSurface.withValues(alpha: 0.04),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.15)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.15)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: cs.primary, width: 1.5),
            ),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Shared helper: _WizardDropdown
// =============================================================================
class _WizardDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _WizardDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: cs.onSurface.withValues(alpha: 0.7),
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: cs.onSurface.withValues(alpha: 0.04),
            border: Border.all(color: cs.onSurface.withValues(alpha: 0.15)),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            icon: Icon(Icons.keyboard_arrow_down,
                color: cs.onSurface.withValues(alpha: 0.5), size: 20),
            style: GoogleFonts.plusJakartaSans(
              color: cs.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            dropdownColor: Theme.of(context).cardColor,
            items: items,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Shared helper: _WizardResultCard
// =============================================================================
class _WizardResultCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color severityColor;
  final String managementText;
  final List<String> findings;
  final String reference;
  final Widget? extraTop;

  const _WizardResultCard({
    required this.title,
    this.subtitle,
    required this.severityColor,
    required this.managementText,
    required this.findings,
    required this.reference,
    this.extraTop,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bgColor = severityColor.withValues(alpha: 0.09);
    final borderColor = severityColor.withValues(alpha: 0.35);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // — Severity header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: severityColor.withValues(alpha: 0.13),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (extraTop != null) ...[extraTop!, const SizedBox(height: 8)],
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: severityColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle!,
                    style: GoogleFonts.plusJakartaSans(
                      color: severityColor.withValues(alpha: 0.75),
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Management
                Text(
                  'Management',
                  style: GoogleFonts.plusJakartaSans(
                    color: cs.onSurface.withValues(alpha: 0.6),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  managementText,
                  style: GoogleFonts.plusJakartaSans(
                    color: cs.onSurface,
                    fontSize: 13,
                    height: 1.55,
                  ),
                ),

                if (findings.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    'Contributing Findings',
                    style: GoogleFonts.plusJakartaSans(
                      color: cs.onSurface.withValues(alpha: 0.6),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...findings.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('•  ',
                              style: GoogleFonts.plusJakartaSans(
                                  color: severityColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text(
                              f,
                              style: GoogleFonts.plusJakartaSans(
                                color: cs.onSurface.withValues(alpha: 0.85),
                                fontSize: 12.5,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Reference
                const SizedBox(height: 14),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    reference,
                    style: GoogleFonts.plusJakartaSans(
                      color: cs.onSurface.withValues(alpha: 0.5),
                      fontSize: 10.5,
                      fontStyle: FontStyle.italic,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SCREEN 1 — PdaStagingWizardScreen
// =============================================================================
class PdaStagingWizardScreen extends StatefulWidget {
  const PdaStagingWizardScreen({super.key});

  @override
  State<PdaStagingWizardScreen> createState() => _PdaStagingWizardScreenState();
}

class _PdaStagingWizardScreenState extends State<PdaStagingWizardScreen> {
  // -- Input controllers
  final _tddCtrl = TextEditingController();
  final _laAoCtrl = TextEditingController();
  final _lpaDiastolicCtrl = TextEditingController();
  final _lvoCtrl = TextEditingController();

  String _dtaFlow = 'Forward';
  String _celiacFlow = 'Forward';
  String _ductalPattern =
      'Closing (pulsatile L\u2192R, peak rising)';

  bool _assessed = false;
  // Result state
  int _score = 0;
  Color _severityColor = _green;
  String _severityLabel = '';
  String _management = '';
  List<String> _findings = [];

  static const List<String> _flowOptions = ['Forward', 'Absent', 'Reversed'];
  static const List<String> _patternOptions = [
    'Closing (pulsatile L\u2192R, peak rising)',
    'Growing (laminar low-velocity L\u2192R)',
    'Pulsatile (restrictive L\u2192R)',
    'Bidirectional / Pulmonary hypertension pattern',
  ];

  @override
  void dispose() {
    _tddCtrl.dispose();
    _laAoCtrl.dispose();
    _lpaDiastolicCtrl.dispose();
    _lvoCtrl.dispose();
    super.dispose();
  }

  void _assess() {
    HapticFeedback.mediumImpact();

    final tdd = double.tryParse(_tddCtrl.text) ?? 0.0;
    final laAo = double.tryParse(_laAoCtrl.text) ?? 0.0;
    final lpaDiastolic = double.tryParse(_lpaDiastolicCtrl.text) ?? 0.0;
    final lvo = double.tryParse(_lvoCtrl.text);

    int score = 0;
    final findings = <String>[];

    // TDD
    if (tdd >= 2.0) {
      score += 3;
      findings.add('Large TDD \u22652.0\u00a0mm (+3)');
    } else if (tdd >= 1.5) {
      score += 2;
      findings.add('Moderate TDD 1.5\u20131.9\u00a0mm (+2)');
    } else if (tdd >= 1.0) {
      score += 1;
      findings.add('Small TDD 1.0\u20131.4\u00a0mm (+1)');
    } else if (tdd > 0) {
      findings.add('TDD <1.0\u00a0mm (no contribution)');
    }

    // LA:Ao
    if (laAo >= 2.0) {
      score += 2;
      findings.add('LA:Ao \u22652.0 \u2014 significant LA volume overload (+2)');
    } else if (laAo >= 1.5) {
      score += 1;
      findings.add('LA:Ao 1.5\u20131.9 \u2014 elevated (+1)');
    }

    // LPA diastolic velocity
    if (lpaDiastolic >= 0.5) {
      score += 2;
      findings.add('LPA EDV \u22650.5\u00a0m/s \u2014 large shunt (+2)');
    } else if (lpaDiastolic >= 0.3) {
      score += 1;
      findings.add('LPA EDV 0.3\u20130.5\u00a0m/s \u2014 moderate shunt (+1)');
    }

    // Optional LVO
    if (lvo != null && lvo >= 400) {
      score += 1;
      findings.add('LVO \u2265400\u00a0mL/kg/min \u2014 high-output state (+1)');
    }

    // DTA diastolic flow
    if (_dtaFlow == 'Reversed') {
      score += 2;
      findings.add('Reversed DTA diastolic flow \u2014 systemic steal (+2)');
    } else if (_dtaFlow == 'Absent') {
      score += 1;
      findings.add('Absent DTA diastolic flow (+1)');
    }

    // Celiac diastolic flow
    if (_celiacFlow == 'Reversed') {
      score += 1;
      findings.add('Reversed celiac diastolic flow \u2014 gut hypoperfusion risk (+1)');
    } else if (_celiacFlow == 'Absent') {
      score += 1;
      findings.add('Absent celiac diastolic flow \u2014 watch for NEC (+1)');
    }

    // Ductal flow pattern
    if (_ductalPattern == 'Growing (laminar low-velocity L\u2192R)') {
      score += 2;
      findings.add('Growing ductal pattern \u2014 unrestricted L\u2192R (+2)');
    } else if (_ductalPattern == 'Pulsatile (restrictive L\u2192R)') {
      score += 1;
      findings.add('Pulsatile ductal pattern (+1)');
    } else if (_ductalPattern ==
        'Bidirectional / Pulmonary hypertension pattern') {
      score += 1;
      findings.add('Bidirectional flow \u2014 possible PPHN component (+1)');
    }

    // Cap at 12
    score = min(score, 12);

    String label;
    String management;
    Color color;

    if (score <= 2) {
      color = _green;
      label = 'No / Small PDA';
      management =
          'Not haemodynamically significant. Observe. No intervention required.';
    } else if (score <= 5) {
      color = _amber;
      label = 'Moderate PDA \u2014 Monitor';
      management =
          'Consider daily review. Optimise fluid balance (80% maintenance), '
          'maintain haematocrit >35%. Repeat echo in 24\u201348 hours. '
          'Consider pharmacological closure if clinical deterioration '
          '(worsening respiratory status, feed intolerance, oliguria).';
    } else if (score <= 8) {
      color = _red;
      label = 'Haemodynamically Significant PDA (hsPDA)';
      management =
          'Consider pharmacological closure with paracetamol (15\u00a0mg/kg every '
          '6\u00a0hours \u00d7 3\u00a0days) or ibuprofen (10\u00a0mg/kg then '
          '5\u00a0mg/kg \u00d7 2\u00a0doses, 24\u00a0h apart). Restrict fluids to '
          '80% maintenance. Reassess in 48\u201372\u00a0h.';
    } else {
      color = _red;
      label = 'Large / Severe hsPDA';
      management =
          'Strong indication for closure. Pharmacological closure first-line; '
          'consider surgical or transcatheter closure if medical therapy fails '
          'or contraindicated. Anticipate worsening respiratory status.';
    }

    setState(() {
      _score = score;
      _severityColor = color;
      _severityLabel = label;
      _management = management;
      _findings = findings;
      _assessed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 64,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PDA Staging Wizard',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              'El-Khuffash et al. 2018',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.80),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section: Morphology
          _WizardSection(
            title: 'MORPHOLOGY',
            children: [
              _WizardInputField(
                label: 'Ductal Diameter TDD',
                hint: 'e.g. 1.8',
                unit: 'mm',
                controller: _tddCtrl,
              ),
              _WizardInputField(
                label: 'LA:Ao Ratio',
                hint: 'e.g. 1.6',
                controller: _laAoCtrl,
              ),
            ],
          ),

          // Section: Pulmonary Overcirculation
          _WizardSection(
            title: 'PULMONARY OVERCIRCULATION',
            children: [
              _WizardInputField(
                label: 'LPA End-Diastolic Velocity',
                hint: 'e.g. 0.4',
                unit: 'm/s',
                controller: _lpaDiastolicCtrl,
              ),
              _WizardInputField(
                label: 'LVO',
                hint: 'e.g. 350',
                unit: 'mL/kg/min',
                controller: _lvoCtrl,
                optional: true,
              ),
            ],
          ),

          // Section: Systemic Steal
          _WizardSection(
            title: 'SYSTEMIC STEAL',
            children: [
              _WizardDropdown<String>(
                label: 'DTA Diastolic Flow',
                value: _dtaFlow,
                onChanged: (v) => setState(() => _dtaFlow = v ?? _dtaFlow),
                items: _flowOptions
                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                    .toList(),
              ),
              _WizardDropdown<String>(
                label: 'Celiac Trunk Diastolic Flow',
                value: _celiacFlow,
                onChanged: (v) => setState(() => _celiacFlow = v ?? _celiacFlow),
                items: _flowOptions
                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                    .toList(),
              ),
            ],
          ),

          // Section: Ductal Flow Pattern
          _WizardSection(
            title: 'DUCTAL FLOW PATTERN',
            children: [
              _WizardDropdown<String>(
                label: 'Flow Pattern',
                value: _ductalPattern,
                onChanged: (v) =>
                    setState(() => _ductalPattern = v ?? _ductalPattern),
                items: _patternOptions
                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                    .toList(),
              ),
            ],
          ),

          // Assess button
          FilledButton(
            onPressed: _assess,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Assess PDA Severity',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Result
          if (_assessed) ...[
            const SizedBox(height: 20),
            _WizardResultCard(
              title: _severityLabel,
              subtitle: 'Score: $_score / 12',
              severityColor: _severityColor,
              managementText: _management,
              findings: _findings,
              reference:
                  'El-Khuffash AF, Weisz DE, McNamara PJ. Hemodynamic significance '
                  'and decision to treat: PDA in preterm infants. Semin Fetal '
                  'Neonatal Med. 2018;23:245\u2013249.',
              extraTop: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _severityColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Hemodynamic Score: $_score / 12',
                  style: GoogleFonts.plusJakartaSans(
                    color: _severityColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// =============================================================================
// SCREEN 2 — PphnSeverityBundleScreen
// =============================================================================
class PphnSeverityBundleScreen extends StatefulWidget {
  const PphnSeverityBundleScreen({super.key});

  @override
  State<PphnSeverityBundleScreen> createState() =>
      _PphnSeverityBundleScreenState();
}

class _PphnSeverityBundleScreenState extends State<PphnSeverityBundleScreen> {
  // -- Input controllers
  final _trVelCtrl = TextEditingController();
  final _systolicBPCtrl = TextEditingController();
  final _rapCtrl = TextEditingController(text: '5');
  final _paatCtrl = TextEditingController();
  final _eiCtrl = TextEditingController();
  final _preDuctalCtrl = TextEditingController();
  final _postDuctalCtrl = TextEditingController();

  bool _midSystolicNotching = false;
  String _septalPosition = 'Normal (round LV)';
  String _ductalFlow = 'Closed / no PDA';

  bool _assessed = false;
  Color _severityColor = _green;
  String _severityLabel = '';
  String _management = '';
  List<String> _findings = [];

  static const List<String> _septalOptions = [
    'Normal (round LV)',
    'Systolic flattening (D-shape)',
    'Bowing into LV',
  ];
  static const List<String> _ductalOptions = [
    'Closed / no PDA',
    'Purely L\u2192R',
    'Bidirectional',
    'Purely R\u2192L (supra-systemic)',
  ];

  @override
  void dispose() {
    _trVelCtrl.dispose();
    _systolicBPCtrl.dispose();
    _rapCtrl.dispose();
    _paatCtrl.dispose();
    _eiCtrl.dispose();
    _preDuctalCtrl.dispose();
    _postDuctalCtrl.dispose();
    super.dispose();
  }

  void _assess() {
    HapticFeedback.mediumImpact();

    final trVel = double.tryParse(_trVelCtrl.text) ?? 0.0;
    final systolicBP = double.tryParse(_systolicBPCtrl.text) ?? 50.0;
    final rap = double.tryParse(_rapCtrl.text) ?? 5.0;
    final paat = double.tryParse(_paatCtrl.text) ?? 100.0;
    final ei = double.tryParse(_eiCtrl.text) ?? 1.0;
    final preDuctalSpO2 = double.tryParse(_preDuctalCtrl.text) ?? 0.0;
    final postDuctalSpO2 = double.tryParse(_postDuctalCtrl.text) ?? 0.0;

    // Derived values
    final papsp = 4 * trVel * trVel + rap;
    final ratio = systolicBP > 0 ? papsp / systolicBP : 0.0;
    final spO2Gradient = preDuctalSpO2 - postDuctalSpO2;
    final notching = _midSystolicNotching;

    String severity;
    String management;
    Color color;
    final findings = <String>[];

    if (ratio >= 1.0 ||
        _ductalFlow == 'Purely R\u2192L (supra-systemic)' ||
        _septalPosition == 'Bowing into LV') {
      color = _red;
      severity = 'Severe / Supra-systemic PPHN';
      management =
          'Urgent: iNO 20\u00a0ppm. Optimise oxygenation (SpO\u2082 target '
          '92\u201397%), gentle ventilation (keep PIP as low as tolerated, '
          'allow permissive hypercapnia PaCO\u2082 45\u201355). Maintain mean BP '
          '>45\u00a0mmHg with volume and dopamine/noradrenaline. Consider '
          'milrinone if LV dysfunction (watch for hypotension). Sildenafil '
          '0.5\u20132\u00a0mg/kg PO q6h as second agent. Consider prostacyclin '
          '(epoprostenol) infusion. Urgent ECMO referral if OI\u00a0>\u00a025.';
    } else if (ratio >= 0.67 || (paat < 45 && notching)) {
      color = _red;
      severity = 'Moderate PPHN';
      management =
          'Start iNO 20\u00a0ppm. Optimise ventilation and oxygenation. Keep '
          'pre-ductal SpO\u2082 92\u201397%. Support systemic BP with volume '
          '\u00b1 dopamine. Reassess in 4\u20136\u00a0h \u2014 wean iNO if '
          'PAPSp ratio <0.5. Consider sildenafil if iNO weaning fails.';
    } else if (ratio >= 0.5 || paat < 55 || trVel >= 2.8) {
      color = _amber;
      severity = 'Mild PPHN';
      management =
          'Optimise oxygenation (target SpO\u2082 92\u201397%). Avoid acidosis '
          'and hypercapnia. Ensure adequate preload and BP. Monitor closely '
          '\u2014 repeat echo in 4\u20136\u00a0h. Consider iNO trial if not '
          'improving.';
    } else {
      color = _green;
      severity = 'No Significant PPHN';
      management =
          'Pulmonary pressure within normal post-transitional range. Continue '
          'supportive care. Reassess if clinical deterioration.';
    }

    // Findings
    if (trVel > 0) {
      findings.add(
          'PAPSp estimated: ${papsp.toStringAsFixed(1)}\u00a0mmHg (4\u00d7TR\u00b2 + RAP)');
    }
    if (systolicBP > 0 && trVel > 0) {
      findings.add('PAP:systemic ratio: ${ratio.toStringAsFixed(2)}');
    }
    if (paat > 0) {
      findings.add(
          'PAAT ${paat.toInt()}\u00a0ms \u2014 ${paat < 45 ? "severely shortened" : paat < 55 ? "shortened" : "normal range"}');
    }
    if (notching) findings.add('Mid-systolic notching present \u2014 PVR elevation');
    if (ei > 1.0) {
      findings.add(
          'Eccentricity index ${ei.toStringAsFixed(2)} \u2014 ${ei >= 1.3 ? "significant septal shift" : "mild deviation"}');
    }
    findings.add('Septal position: $_septalPosition');
    findings.add('Ductal flow: $_ductalFlow');

    // SpO2 gradient
    String preductalNote;
    if (spO2Gradient >= 10) {
      preductalNote =
          'Pre/post-ductal SpO\u2082 gradient \u226510% suggests significant '
          'R\u2192L ductal shunting \u2014 supports supra-systemic PPHN.';
    } else if (spO2Gradient >= 5) {
      preductalNote =
          'Pre/post-ductal gradient 5\u201310% suggests mild-to-moderate '
          'R\u2192L shunting.';
    } else if (preDuctalSpO2 > 0 || postDuctalSpO2 > 0) {
      preductalNote = 'No significant pre/post-ductal SpO\u2082 gradient.';
    } else {
      preductalNote = '';
    }
    if (preductalNote.isNotEmpty) findings.add(preductalNote);

    setState(() {
      _severityColor = color;
      _severityLabel = severity;
      _management = management;
      _findings = findings;
      _assessed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 64,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PPHN Severity Bundle',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              'Jain & McNamara 2015 \u00b7 ASE TNE 2024',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.80),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section: Pulmonary Pressure Estimate
          _WizardSection(
            title: 'PULMONARY PRESSURE ESTIMATE',
            children: [
              _WizardInputField(
                label: 'TR Jet Peak Velocity',
                hint: 'e.g. 3.2',
                unit: 'm/s',
                controller: _trVelCtrl,
              ),
              _WizardInputField(
                label: 'Systemic Systolic BP',
                hint: 'e.g. 50',
                unit: 'mmHg',
                controller: _systolicBPCtrl,
              ),
              _WizardInputField(
                label: 'RAP Estimate',
                hint: '5',
                unit: 'mmHg',
                controller: _rapCtrl,
              ),
            ],
          ),

          // Section: Pulmonary Vascular Resistance
          _WizardSection(
            title: 'PULMONARY VASCULAR RESISTANCE',
            children: [
              _WizardInputField(
                label: 'PAAT',
                hint: 'e.g. 60',
                unit: 'ms',
                controller: _paatCtrl,
              ),
              Builder(builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Mid-systolic notching of MPA Doppler',
                        style: GoogleFonts.plusJakartaSans(
                          color: cs.onSurface.withValues(alpha: 0.7),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Switch(
                      value: _midSystolicNotching,
                      onChanged: (v) =>
                          setState(() => _midSystolicNotching = v),
                    ),
                  ],
                );
              }),
            ],
          ),

          // Section: Septal Position
          _WizardSection(
            title: 'SEPTAL POSITION',
            children: [
              _WizardInputField(
                label: 'Eccentricity Index (D1/D2)',
                hint: 'e.g. 1.2',
                controller: _eiCtrl,
              ),
              _WizardDropdown<String>(
                label: 'Septal Configuration',
                value: _septalPosition,
                onChanged: (v) =>
                    setState(() => _septalPosition = v ?? _septalPosition),
                items: _septalOptions
                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                    .toList(),
              ),
            ],
          ),

          // Section: Ductal Flow
          _WizardSection(
            title: 'DUCTAL FLOW',
            children: [
              _WizardDropdown<String>(
                label: 'Ductal Flow Direction',
                value: _ductalFlow,
                onChanged: (v) =>
                    setState(() => _ductalFlow = v ?? _ductalFlow),
                items: _ductalOptions
                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                    .toList(),
              ),
            ],
          ),

          // Section: Pre-/Post-ductal Saturation
          _WizardSection(
            title: 'PRE-/POST-DUCTAL SATURATION',
            children: [
              _WizardInputField(
                label: 'Pre-ductal SpO\u2082',
                hint: 'e.g. 95',
                unit: '%',
                controller: _preDuctalCtrl,
              ),
              _WizardInputField(
                label: 'Post-ductal SpO\u2082',
                hint: 'e.g. 88',
                unit: '%',
                controller: _postDuctalCtrl,
              ),
            ],
          ),

          // Assess button
          FilledButton(
            onPressed: _assess,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Assess PPHN Severity',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Result
          if (_assessed) ...[
            const SizedBox(height: 20),
            _WizardResultCard(
              title: _severityLabel,
              severityColor: _severityColor,
              managementText: _management,
              findings: _findings,
              reference:
                  'Jain A, McNamara PJ. Persistent pulmonary hypertension of the '
                  'newborn: advances in diagnosis and treatment. Semin Fetal '
                  'Neonatal Med. 2015;20:262\u2013271. ASE/CSE TNE Guidelines 2024.',
            ),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// =============================================================================
// SCREEN 3 — ShockPhenotypeClassifierScreen
// =============================================================================
class ShockPhenotypeClassifierScreen extends StatefulWidget {
  const ShockPhenotypeClassifierScreen({super.key});

  @override
  State<ShockPhenotypeClassifierScreen> createState() =>
      _ShockPhenotypeClassifierScreenState();
}

class _ShockPhenotypeClassifierScreenState
    extends State<ShockPhenotypeClassifierScreen> {
  // -- Input controllers
  final _lvoCtrl = TextEditingController();
  final _rvoCtrl = TextEditingController();
  final _svcCtrl = TextEditingController();
  final _civcCtrl = TextEditingController();
  final _laAoCtrl = TextEditingController();
  final _efCtrl = TextEditingController();
  final _fsCtrl = TextEditingController();

  String _perfusion = 'Warm peripheries, bounding pulses';
  String _context = 'Proven/suspected sepsis';

  bool _assessed = false;
  Color _severityColor = _green;
  String _phenotypeLabel = '';
  String _management = '';
  List<String> _findings = [];

  static const List<String> _perfusionOptions = [
    'Warm peripheries, bounding pulses',
    'Cool peripheries, weak pulses',
    'Mixed',
  ];
  static const List<String> _contextOptions = [
    'Proven/suspected sepsis',
    'Post-asphyxia',
    'Preterm IVH risk period',
    'Other',
  ];

  @override
  void dispose() {
    _lvoCtrl.dispose();
    _rvoCtrl.dispose();
    _svcCtrl.dispose();
    _civcCtrl.dispose();
    _laAoCtrl.dispose();
    _efCtrl.dispose();
    _fsCtrl.dispose();
    super.dispose();
  }

  void _assess() {
    HapticFeedback.mediumImpact();

    final lvo = double.tryParse(_lvoCtrl.text) ?? 200.0;
    final svcFlow = double.tryParse(_svcCtrl.text) ?? 60.0;
    final civc = double.tryParse(_civcCtrl.text) ?? 30.0;
    final laAo = double.tryParse(_laAoCtrl.text) ?? 1.3;
    final ef = double.tryParse(_efCtrl.text) ?? 55.0;

    final bool lowOutput = lvo < 150 || svcFlow < 41;
    final bool highOutput = lvo > 300;
    final bool highCivc = civc > 50;
    final bool lowEf = ef < 45;
    final bool hsPda = laAo > 1.5;

    String phenotype;
    String management;
    Color color;
    final findings = <String>[];

    if (highOutput &&
        _perfusion == 'Warm peripheries, bounding pulses' &&
        !lowEf) {
      color = _amber;
      phenotype = 'Distributive (Warm) Shock';
      management =
          'Low systemic vascular resistance. Likely sepsis / SIRS. Start '
          'antibiotics early. Vasopressor first-line: noradrenaline '
          '0.05\u20130.5\u00a0mcg/kg/min. Add hydrocortisone if refractory '
          '(2\u00a0mg/kg stat then 1\u00a0mg/kg q6h). Avoid large fluid boluses '
          'if LV function preserved.';
      findings.add('\u2191Cardiac output with warm peripheries \u2192 low SVR');
      findings.add('Consider: sepsis, early PDA, AV fistula');
    } else if (lowOutput && highCivc && ef >= 45) {
      color = _amber;
      phenotype = 'Hypovolaemic Shock';
      management =
          'Under-filled. Give 10\u201320\u00a0mL/kg normal saline bolus, '
          'reassess LVO and cIVC in 30\u00a0min. Look for loss (GI, blood loss, '
          'capillary leak, third-spacing). Avoid overfilling \u2014 preterms '
          'tolerate poorly.';
      findings.add(
          'Low cardiac output with collapsing IVC \u2192 inadequate preload');
      findings
          .add('Assess for: occult bleeding, dehydration, capillary leak');
    } else if (lowOutput && lowEf) {
      color = _red;
      phenotype = 'Cardiogenic Shock';
      management =
          'Myocardial dysfunction. Start inotrope: dobutamine '
          '5\u201315\u00a0mcg/kg/min (titrate). Consider milrinone if afterload '
          'reduction desired. Avoid tachycardia-inducing doses of dopamine. If '
          'severe: hydrocortisone + consider ECMO referral.';
      findings
          .add('Low cardiac output with reduced EF \u2192 poor contractility');
      findings.add(
          'Consider: post-asphyxia, myocarditis, severe sepsis with myocardial depression');
    } else if (hsPda && lvo > 400) {
      color = _amber;
      phenotype = 'PDA-associated High-Output State';
      management =
          'Pulmonary overcirculation masquerading as high LVO \u2014 systemic '
          'perfusion actually reduced. Use SVC flow as better marker of systemic '
          'output. Address the PDA (pharmacological closure). Optimise fluid '
          'balance (80% maintenance).';
      findings.add(
          'High LVO with elevated LA:Ao \u2192 pulmonary overcirculation from PDA');
    } else if (lowOutput && !highCivc && !lowEf) {
      color = _amber;
      phenotype = 'Mixed / Early Shock';
      management =
          'Early or mixed picture. Correct obvious precipitants '
          '(hypoglycaemia, hypocalcaemia, acidosis). Cautious 10\u00a0mL/kg '
          'crystalloid trial with close reassessment. If no response, start '
          'dopamine 5\u00a0mcg/kg/min and reassess. Low threshold for '
          'hydrocortisone.';
      findings.add('Low cardiac output without a single dominant phenotype');
    } else {
      color = _green;
      phenotype = 'No Clear Shock Phenotype';
      management =
          'Haemodynamic parameters within or near normal range. Reassess '
          'clinical context. If clinically unwell despite normal echo, consider: '
          'metabolic derangement, occult infection, evolving process. Repeat '
          'echo in 2\u20134\u00a0h.';
    }

    // Additional computed findings
    findings.add(
        'LVO: ${lvo.toStringAsFixed(0)}\u00a0mL/kg/min ${lvo < 150 ? "(\u2193 low)" : lvo > 300 ? "(\u2191 high)" : "(normal range)"}');
    findings.add(
        'SVC Flow: ${svcFlow.toStringAsFixed(0)}\u00a0mL/kg/min ${svcFlow < 41 ? "(\u2193 low)" : "(normal range)"}');
    findings.add(
        'IVC Collapsibility: ${civc.toStringAsFixed(0)}% ${civc > 50 ? "(\u2191 under-filled)" : "(adequate)"}');
    findings.add(
        'LV EF: ${ef.toStringAsFixed(0)}% ${ef < 45 ? "(\u2193 reduced)" : "(preserved)"}');
    findings.add('Clinical context: $_context');

    setState(() {
      _severityColor = color;
      _phenotypeLabel = phenotype;
      _management = management;
      _findings = findings;
      _assessed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 64,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shock Phenotype Classifier',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              'de Waal \u00b7 Kluckow \u00b7 Evans',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.80),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section: Cardiac Output
          _WizardSection(
            title: 'CARDIAC OUTPUT',
            children: [
              _WizardInputField(
                label: 'LVO',
                hint: 'e.g. 200',
                unit: 'mL/kg/min',
                controller: _lvoCtrl,
              ),
              _WizardInputField(
                label: 'RVO',
                hint: 'e.g. 220',
                unit: 'mL/kg/min',
                controller: _rvoCtrl,
                optional: true,
              ),
              _WizardInputField(
                label: 'SVC Flow',
                hint: 'e.g. 55',
                unit: 'mL/kg/min',
                controller: _svcCtrl,
              ),
            ],
          ),

          // Section: Preload / Volume Status
          _WizardSection(
            title: 'PRELOAD / VOLUME STATUS',
            children: [
              _WizardInputField(
                label: 'IVC Collapsibility Index',
                hint: 'e.g. 40',
                unit: '%',
                controller: _civcCtrl,
              ),
              _WizardInputField(
                label: 'LA:Ao',
                hint: 'e.g. 1.4',
                controller: _laAoCtrl,
              ),
            ],
          ),

          // Section: Contractility
          _WizardSection(
            title: 'CONTRACTILITY',
            children: [
              _WizardInputField(
                label: 'LV Ejection Fraction',
                hint: 'e.g. 55',
                unit: '%',
                controller: _efCtrl,
              ),
              _WizardInputField(
                label: 'Fractional Shortening',
                hint: 'e.g. 30',
                unit: '%',
                controller: _fsCtrl,
                optional: true,
              ),
            ],
          ),

          // Section: Afterload Indicators
          _WizardSection(
            title: 'AFTERLOAD INDICATORS',
            children: [
              _WizardDropdown<String>(
                label: 'Peripheral Perfusion',
                value: _perfusion,
                onChanged: (v) => setState(() => _perfusion = v ?? _perfusion),
                items: _perfusionOptions
                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                    .toList(),
              ),
            ],
          ),

          // Section: Context
          _WizardSection(
            title: 'CLINICAL CONTEXT',
            children: [
              _WizardDropdown<String>(
                label: 'Clinical Setting',
                value: _context,
                onChanged: (v) => setState(() => _context = v ?? _context),
                items: _contextOptions
                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                    .toList(),
              ),
            ],
          ),

          // Assess button
          FilledButton(
            onPressed: _assess,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Classify Shock Phenotype',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Result
          if (_assessed) ...[
            const SizedBox(height: 20),
            _WizardResultCard(
              title: _phenotypeLabel,
              severityColor: _severityColor,
              managementText: _management,
              findings: _findings,
              reference:
                  'de Waal K, Kluckow M. Functional echocardiography in the '
                  'neonatal intensive care unit: a practical approach. J Paediatr '
                  'Child Health. 2010;46:410\u2013415. Kluckow M, Evans N. Superior '
                  'vena cava flow in newborn infants. Arch Dis Child Fetal Neonatal '
                  'Ed. 2000;82:F188\u2013F194.',
              extraTop: Builder(builder: (context) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: _severityColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Phenotype Identified',
                    style: GoogleFonts.plusJakartaSans(
                      color: _severityColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }),
            ),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
