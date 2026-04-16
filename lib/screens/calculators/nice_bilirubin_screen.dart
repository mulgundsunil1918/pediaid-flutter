import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fl_chart/fl_chart.dart';

const double _umolPerMgDl = 17.1;

class _GaThresholds {
  final double photoStart;
  final double photoPlateauDay;
  final double photoPlateau;
  final double exchStart;
  final double exchPlateauDay;
  final double exchPlateau;

  _GaThresholds({
    required this.photoStart,
    required this.photoPlateauDay,
    required this.photoPlateau,
    required this.exchStart,
    required this.exchPlateauDay,
    required this.exchPlateau,
  });

  factory _GaThresholds.fromJson(Map<String, dynamic> j) {
    final p = j['photo'] as Map<String, dynamic>;
    final e = j['exchange'] as Map<String, dynamic>;
    return _GaThresholds(
      photoStart: (p['start'] as num).toDouble(),
      photoPlateauDay: (p['plateau_day'] as num).toDouble(),
      photoPlateau: (p['plateau'] as num).toDouble(),
      exchStart: (e['start'] as num).toDouble(),
      exchPlateauDay: (e['plateau_day'] as num).toDouble(),
      exchPlateau: (e['plateau'] as num).toDouble(),
    );
  }
}

class NiceBilirubinScreen extends StatefulWidget {
  const NiceBilirubinScreen({super.key});

  @override
  State<NiceBilirubinScreen> createState() => _NiceBilirubinScreenState();
}

class _NiceBilirubinScreenState extends State<NiceBilirubinScreen> {
  // ── GA chips ────────────────────────────────────────────────────────────────
  static const List<String> _gaKeys = [
    '23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38plus'
  ];
  String? _selectedGa;

  // ── Age steppers ────────────────────────────────────────────────────────────
  int _days = 0;
  int _hours = 0;

  // ── TSB ─────────────────────────────────────────────────────────────────────
  bool _isUmol = true; // true = µmol/L, false = mg/dL
  final TextEditingController _tsbCtrl = TextEditingController();
  double? _tsbValue; // in selected unit

  // ── Results ─────────────────────────────────────────────────────────────────
  bool _showResults = false;
  Map<String, _GaThresholds>? _data;
  String? _loadError;

  // For auto-scroll
  final ScrollController _scrollCtrl = ScrollController();
  final GlobalKey _resultsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadData();
    _tsbCtrl.addListener(() {
      final v = double.tryParse(_tsbCtrl.text.trim());
      setState(() => _tsbValue = v);
    });
  }

  Future<void> _loadData() async {
    try {
      final raw = await rootBundle.loadString('assets/nice/nicecharts.json');
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final th = decoded['thresholds'] as Map<String, dynamic>;
      final out = <String, _GaThresholds>{};
      th.forEach((k, v) {
        out[k] = _GaThresholds.fromJson(v as Map<String, dynamic>);
      });
      setState(() => _data = out);
    } catch (e) {
      setState(() => _loadError = e.toString());
    }
  }

  @override
  void dispose() {
    _tsbCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────
  String _gaLabel(String k) => k == '38plus' ? '\u226538' : k;

  int _totalHours() => _days * 24 + _hours;

  double _tsbUmol() {
    final v = _tsbValue ?? 0;
    if (_isUmol) return v;
    return (v * _umolPerMgDl);
  }

  double _thresholdAt(double ageDays, double start, double plateauDay, double plateau) {
    if (ageDays >= plateauDay) return plateau;
    return start + (ageDays / plateauDay) * (plateau - start);
  }

  String _toMgDl(num umol) => (umol / _umolPerMgDl).toStringAsFixed(1);

  bool get _canAssess =>
      _selectedGa != null && _tsbValue != null && _tsbValue! > 0 && _data != null;

  void _assess() {
    if (!_canAssess) return;
    setState(() => _showResults = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _resultsKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('NICE Bilirubin Chart',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            SizedBox(height: 2),
            Text('NICE CG98 \u00b7 23\u201338+ weeks',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
      body: _loadError != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Failed to load NICE data:\n$_loadError',
                    textAlign: TextAlign.center),
              ),
            )
          : _data == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildGaSection(),
                      const SizedBox(height: 12),
                      _buildAgeSection(),
                      const SizedBox(height: 12),
                      _buildTsbSection(),
                      const SizedBox(height: 16),
                      _buildAssessButton(),
                      if (_showResults) ...[
                        const SizedBox(height: 18),
                        Container(key: _resultsKey),
                        _buildRecommendationCard(),
                        const SizedBox(height: 12),
                        _buildChartCard(),
                      ],
                      const SizedBox(height: 14),
                      _buildReferenceCard(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  // ── Section 1: GA chips ─────────────────────────────────────────────────────
  Widget _buildGaSection() {
    return _sectionCard(
      title: 'Gestational Age',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _gaKeys.map(_buildGaChip).toList(),
      ),
    );
  }

  Widget _buildGaChip(String key) {
    final cs = Theme.of(context).colorScheme;
    final selected = _selectedGa == key;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedGa = key;
        _showResults = false;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 56,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? cs.primary : Colors.transparent,
          border: Border.all(
            color: selected ? cs.primary : cs.onSurface.withValues(alpha: 0.25),
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          _gaLabel(key),
          style: TextStyle(
            color: selected ? cs.onPrimary : cs.onSurface,
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ── Section 2: Age steppers ─────────────────────────────────────────────────
  Widget _buildAgeSection() {
    final cs = Theme.of(context).colorScheme;
    final hoursLocked = _days == 14;
    final total = _totalHours();
    return _sectionCard(
      title: 'Age from Birth',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _stepperBox(
                  label: 'Days',
                  value: _days,
                  min: 0,
                  max: 14,
                  onChanged: (v) => setState(() {
                    _days = v;
                    if (_days == 14) _hours = 0;
                    _showResults = false;
                  }),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _stepperBox(
                  label: 'Hours',
                  value: _hours,
                  min: 0,
                  max: 23,
                  enabled: !hoursLocked,
                  onChanged: (v) => setState(() {
                    _hours = v;
                    _showResults = false;
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Total: $_days days $_hours hours ($total hours)',
            style: TextStyle(
              fontSize: 11.5,
              color: cs.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepperBox({
    required String label,
    required int value,
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
    bool enabled = true,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.6),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border.all(color: cs.onSurface.withValues(alpha: 0.15)),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                visualDensity: VisualDensity.compact,
                color: enabled
                    ? cs.onSurface.withValues(alpha: 0.7)
                    : cs.onSurface.withValues(alpha: 0.25),
                onPressed: enabled && value > min
                    ? () => onChanged(value - 1)
                    : null,
              ),
              Text(
                '$value',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: enabled
                      ? cs.onSurface
                      : cs.onSurface.withValues(alpha: 0.4),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                visualDensity: VisualDensity.compact,
                color: enabled
                    ? cs.onSurface.withValues(alpha: 0.7)
                    : cs.onSurface.withValues(alpha: 0.25),
                onPressed: enabled && value < max
                    ? () => onChanged(value + 1)
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Section 3: TSB entry ────────────────────────────────────────────────────
  Widget _buildTsbSection() {
    final cs = Theme.of(context).colorScheme;
    final unitLabel = _isUmol ? '\u00b5mol/L' : 'mg/dL';
    String conversion = '';
    if (_tsbValue != null && _tsbValue! > 0) {
      if (_isUmol) {
        conversion = '= ${_toMgDl(_tsbValue!)} mg/dL';
      } else {
        conversion =
            '= ${(_tsbValue! * _umolPerMgDl).toStringAsFixed(0)} \u00b5mol/L';
      }
    }
    return _sectionCard(
      title: 'Total Serum Bilirubin',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _unitButton(
                  label: '\u00b5mol/L',
                  selected: _isUmol,
                  onTap: () {
                    if (!_isUmol) {
                      setState(() {
                        _isUmol = true;
                        _tsbCtrl.clear();
                        _tsbValue = null;
                        _showResults = false;
                      });
                    }
                  },
                  isLeft: true,
                ),
              ),
              Expanded(
                child: _unitButton(
                  label: 'mg/dL',
                  selected: !_isUmol,
                  onTap: () {
                    if (_isUmol) {
                      setState(() {
                        _isUmol = false;
                        _tsbCtrl.clear();
                        _tsbValue = null;
                        _showResults = false;
                      });
                    }
                  },
                  isLeft: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: cs.onSurface.withValues(alpha: 0.15)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _tsbCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: cs.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: 'Enter TSB value',
                hintStyle: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.35),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                suffixText: unitLabel,
                suffixStyle: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (conversion.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              conversion,
              style: TextStyle(
                fontSize: 12,
                color: cs.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _unitButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required bool isLeft,
  }) {
    final cs = Theme.of(context).colorScheme;
    final radius = isLeft
        ? const BorderRadius.only(
            topLeft: Radius.circular(8), bottomLeft: Radius.circular(8))
        : const BorderRadius.only(
            topRight: Radius.circular(8), bottomRight: Radius.circular(8));
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? cs.primary : Colors.transparent,
          border: Border.all(
            color: selected
                ? cs.primary
                : cs.onSurface.withValues(alpha: 0.25),
          ),
          borderRadius: radius,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? cs.onPrimary : cs.onSurface,
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ── Section 4: Assess button ────────────────────────────────────────────────
  Widget _buildAssessButton() {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _canAssess ? _assess : null,
        icon: const Icon(Icons.show_chart),
        label: const Text(
          'Assess & Plot Chart',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          disabledBackgroundColor: cs.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: cs.onSurface.withValues(alpha: 0.4),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  // ── Section 5: Recommendation card ──────────────────────────────────────────
  Widget _buildRecommendationCard() {
    final ga = _data![_selectedGa]!;
    final ageHoursTotal = _totalHours();
    final ageDaysFloat = ageHoursTotal / 24.0;

    final photoT = _thresholdAt(
            ageDaysFloat, ga.photoStart, ga.photoPlateauDay, ga.photoPlateau)
        .round();
    final exchT = _thresholdAt(
            ageDaysFloat, ga.exchStart, ga.exchPlateauDay, ga.exchPlateau)
        .round();
    final tsbUmol = _tsbUmol().round();
    final intensifiedT = exchT - 50;

    final dark = Theme.of(context).brightness == Brightness.dark;

    Color bg, fg;
    IconData icon;
    Color iconColor;
    String title;
    String body;

    if (tsbUmol < photoT) {
      // OUTCOME A
      bg = dark ? const Color(0xFF1B5E20) : const Color(0xFFE8F5E9);
      fg = dark ? Colors.white : const Color(0xFF1B5E20);
      iconColor = dark ? const Color(0xFFA5D6A7) : const Color(0xFF1B5E20);
      icon = Icons.check_circle_outline;
      title = 'Below Phototherapy Threshold';
      body = 'No phototherapy indicated at this age and gestation.\n\n'
          'Phototherapy threshold:   __$photoT __\u00b5mol/L  (${_toMgDl(photoT)} mg/dL)\n'
          'Exchange threshold:       __$exchT __\u00b5mol/L  (${_toMgDl(exchT)} mg/dL)\n\n'
          'Monitor clinically. Recheck bilirubin as indicated.';
    } else if (tsbUmol >= exchT) {
      // OUTCOME D
      bg = dark ? const Color(0xFF4E0000) : const Color(0xFFFFEBEE);
      fg = dark ? const Color(0xFFEF9A9A) : const Color(0xFFB71C1C);
      iconColor = dark ? const Color(0xFFEF9A9A) : const Color(0xFFB71C1C);
      icon = Icons.emergency;
      title = 'At or Above Exchange Transfusion Threshold';
      body = 'Exchange transfusion is indicated.\n\n'
          'Exchange threshold:   __$exchT __\u00b5mol/L  (${_toMgDl(exchT)} mg/dL)\n\n'
          '\u2022 Perform double-volume exchange transfusion\n'
          '\u2022 Do not stop multiple phototherapy during exchange\n'
          '\u2022 Use IVIG (500 mg/kg over 4 hrs) if isoimmune haemolytic\n'
          '  disease and SBR still rising >8.5 \u00b5mol/L/hr\n'
          '\u2022 Check SBR within 2 hours post-exchange\n'
          '\u2022 Exchange may be deferred only if SBR falls below\n'
          '  threshold while being prepared';
    } else if (tsbUmol >= intensifiedT && ageHoursTotal > 72) {
      // OUTCOME C
      bg = dark ? const Color(0xFF4E1F00) : const Color(0xFFFFF3E0);
      fg = dark ? const Color(0xFFFFAB40) : const Color(0xFFBF360C);
      iconColor = dark ? const Color(0xFFFFAB40) : const Color(0xFFBF360C);
      icon = Icons.priority_high;
      title = 'Consider Intensified Phototherapy';
      body =
          'TSB is within 50 \u00b5mol/L of the exchange transfusion threshold\n'
          'and age is >72 hours. NICE CG98 recommends considering\n'
          'intensified (multiple) phototherapy.\n\n'
          'Phototherapy threshold:   __$photoT __\u00b5mol/L  (${_toMgDl(photoT)} mg/dL)\n'
          'Intensified zone from:    __$intensifiedT __\u00b5mol/L  (${_toMgDl(intensifiedT)} mg/dL)\n'
          'Exchange threshold:       __$exchT __\u00b5mol/L  (${_toMgDl(exchT)} mg/dL)\n\n'
          '\u2022 Consider escalating to multiple phototherapy\n'
          '\u2022 Repeat SBR every 4\u20136 hours\n'
          '\u2022 Consider IVIG (500 mg/kg over 4 hrs) if isoimmune\n'
          '  haemolytic disease and SBR rising >8.5 \u00b5mol/L/hr\n'
          '\u2022 Prepare for possible exchange transfusion\n\n'
          "Note: 'Consider' is the NICE recommendation \u2014 apply\n"
          'clinical judgement. Not automatically mandatory.';
    } else {
      // OUTCOME B
      bg = dark ? const Color(0xFF4E3B00) : const Color(0xFFFFF8E1);
      fg = dark ? const Color(0xFFFFD54F) : const Color(0xFF5D4037);
      iconColor = dark ? const Color(0xFFFFD54F) : const Color(0xFF5D4037);
      icon = Icons.warning_amber_rounded;
      title = 'At or Above Phototherapy Threshold';
      body = 'Start single phototherapy.\n\n'
          'Phototherapy threshold:   __$photoT __\u00b5mol/L  (${_toMgDl(photoT)} mg/dL)\n'
          'Exchange threshold:       __$exchT __\u00b5mol/L  (${_toMgDl(exchT)} mg/dL)\n\n'
          '\u2022 Repeat SBR 4\u20136 hrs after starting phototherapy\n'
          '\u2022 Then every 6\u201312 hrs if stable or falling\n'
          '\u2022 Stop phototherapy when SBR falls \u226550 \u00b5mol/L below phototherapy threshold\n'
          '\u2022 Check rebound SBR 12\u201318 hrs after stopping';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: fg,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildBodyRichText(body, fg),
        ],
      ),
    );
  }

  // Renders body text. Numbers wrapped __X__ are bold (µmol/L thresholds).
  // Numbers in parentheses (mg/dL) stay normal weight.
  Widget _buildBodyRichText(String body, Color fg) {
    final spans = <TextSpan>[];
    final lines = body.split('\n');
    for (int li = 0; li < lines.length; li++) {
      final line = lines[li];
      // Tokenize on __...__ markers.
      final regex = RegExp(r'__(.+?)__');
      int idx = 0;
      for (final m in regex.allMatches(line)) {
        if (m.start > idx) {
          spans.add(TextSpan(text: line.substring(idx, m.start)));
        }
        spans.add(TextSpan(
          text: m.group(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
        idx = m.end;
      }
      if (idx < line.length) {
        spans.add(TextSpan(text: line.substring(idx)));
      }
      if (li < lines.length - 1) spans.add(const TextSpan(text: '\n'));
    }
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: fg,
          fontSize: 12.5,
          height: 1.45,
          fontFamily: DefaultTextStyle.of(context).style.fontFamily,
        ),
        children: spans,
      ),
    );
  }

  // ── Section 6: Chart card ───────────────────────────────────────────────────
  Widget _buildChartCard() {
    final cs = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ga = _data![_selectedGa]!;
    final ageHoursTotal = _totalHours();
    final ageDaysFloat = ageHoursTotal / 24.0;
    final tsbUmol = _tsbUmol();
    final exchT = _thresholdAt(
        ageDaysFloat, ga.exchStart, ga.exchPlateauDay, ga.exchPlateau);
    final intensifiedT = exchT - 50;

    final photoSpots = _series(ga.photoStart, ga.photoPlateauDay, ga.photoPlateau);
    final exchSpots = _series(ga.exchStart, ga.exchPlateauDay, ga.exchPlateau);

    final patientSpot = FlSpot(
        ageDaysFloat.clamp(0, 14).toDouble(), tsbUmol.clamp(0, 550).toDouble());

    final extraLines = <HorizontalLine>[
      HorizontalLine(
        y: tsbUmol.clamp(0, 550).toDouble(),
        color: const Color(0xFFD32F2F),
        strokeWidth: 1,
        dashArray: [4, 4],
      ),
    ];
    final extraVerticalLines = <VerticalLine>[
      VerticalLine(
        x: ageDaysFloat.clamp(0, 14).toDouble(),
        color: const Color(0xFFD32F2F),
        strokeWidth: 1,
        dashArray: [4, 4],
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'NICE Chart \u2014 ${_gaLabel(_selectedGa!)} weeks',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'NICE CG98',
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.5),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 320,
            decoration: BoxDecoration(
              color: dark ? const Color(0xFF1A2A3A) : Colors.white,
              border: Border.all(color: cs.onSurface.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.fromLTRB(8, 12, 16, 8),
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 14,
                minY: 0,
                maxY: 550,
                clipData: const FlClipData.all(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  verticalInterval: 1,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: cs.onSurface.withValues(alpha: 0.12),
                    strokeWidth: 1,
                    dashArray: [3, 3],
                  ),
                  getDrawingVerticalLine: (v) => FlLine(
                    color: cs.onSurface.withValues(alpha: 0.08),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: cs.onSurface.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    axisNameWidget: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('TSB (\u00b5mol/L)',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: cs.onSurface.withValues(alpha: 0.65),
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    axisNameSize: 18,
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: 100,
                      getTitlesWidget: (v, meta) {
                        if (v % 100 != 0) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text('${v.toInt()}',
                              style: TextStyle(
                                fontSize: 10,
                                color: cs.onSurface.withValues(alpha: 0.6),
                              )),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('Days from birth',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: cs.onSurface.withValues(alpha: 0.65),
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    axisNameSize: 18,
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      reservedSize: 22,
                      getTitlesWidget: (v, meta) {
                        if (v % 2 != 0) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text('${v.toInt()}',
                              style: TextStyle(
                                fontSize: 10,
                                color: cs.onSurface.withValues(alpha: 0.6),
                              )),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  // Phototherapy line
                  LineChartBarData(
                    spots: photoSpots,
                    isCurved: false,
                    color: const Color(0xFF1565C0),
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                  ),
                  // Exchange line
                  LineChartBarData(
                    spots: exchSpots,
                    isCurved: false,
                    color: const Color(0xFF8B0000),
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                  ),
                  // Intensified zone (only > 72 hrs)
                  if (ageHoursTotal > 72)
                    LineChartBarData(
                      spots: [
                        FlSpot(3.0, intensifiedT),
                        FlSpot(14.0, intensifiedT),
                      ],
                      isCurved: false,
                      color: const Color(0xFFE65100),
                      barWidth: 1.5,
                      dashArray: [6, 4],
                      dotData: const FlDotData(show: false),
                    ),
                  // Patient TSB dot
                  LineChartBarData(
                    spots: [patientSpot],
                    color: const Color(0xFFD32F2F),
                    barWidth: 0,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, pct, bar, idx) =>
                          FlDotCirclePainter(
                        radius: 6,
                        color: const Color(0xFFD32F2F),
                        strokeWidth: 1.5,
                        strokeColor: Colors.white,
                      ),
                    ),
                  ),
                ],
                extraLinesData: ExtraLinesData(
                  horizontalLines: extraLines,
                  verticalLines: extraVerticalLines,
                ),
                lineTouchData: const LineTouchData(enabled: false),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              _legendItem(
                  swatch: _legendBox(const Color(0xFF1565C0)),
                  text: 'Phototherapy threshold'),
              _legendItem(
                  swatch: _legendBox(const Color(0xFF8B0000)),
                  text: 'Exchange threshold'),
              _legendItem(
                  swatch: _legendDashed(const Color(0xFFE65100)),
                  text: 'Intensified zone (>72 hrs)'),
              _legendItem(
                  swatch: _legendCircle(const Color(0xFFD32F2F)),
                  text: 'Patient TSB'),
            ],
          ),
        ],
      ),
    );
  }

  List<FlSpot> _series(double start, double plateauDay, double plateau) {
    final spots = <FlSpot>[];
    for (int i = 0; i <= 140; i++) {
      final x = i * 0.1;
      final y = _thresholdAt(x, start, plateauDay, plateau);
      spots.add(FlSpot(x, y));
    }
    return spots;
  }

  Widget _legendItem({required Widget swatch, required String text}) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        swatch,
        const SizedBox(width: 6),
        Text(text,
            style: TextStyle(
              fontSize: 10.5,
              color: cs.onSurface.withValues(alpha: 0.7),
            )),
      ],
    );
  }

  Widget _legendBox(Color c) => Container(
        width: 14,
        height: 4,
        decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.circular(2),
        ),
      );

  Widget _legendDashed(Color c) => SizedBox(
        width: 14,
        height: 4,
        child: CustomPaint(painter: _DashedLinePainter(c)),
      );

  Widget _legendCircle(Color c) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      );

  // ── Section 7: Reference card ───────────────────────────────────────────────
  Widget _buildReferenceCard() {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.04),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Reference: National Institute for Health and Clinical Excellence.\n'
        'Neonatal jaundice. NICE clinical guideline CG98. May 2010.\n'
        'Appendix D: Treatment threshold graphs (pages 38\u201353).\n'
        'Updated recommendations: NICE CG98 addendum, 2016.\n\n'
        'Thresholds digitised from consensus-based graphical charts.\n'
        'Use total serum bilirubin \u2014 do not subtract conjugated fraction.\n'
        "'Consider intensified phototherapy' applies only after 72 hours of age\n"
        'per NICE CG98 section 1.4 (2016 update).\n'
        'For use by qualified clinicians only. Verify before acting.',
        style: TextStyle(
          fontSize: 10.5,
          height: 1.5,
          fontStyle: FontStyle.italic,
          color: cs.onSurface.withValues(alpha: 0.55),
        ),
      ),
    );
  }

  // ── Shared section card ─────────────────────────────────────────────────────
  Widget _sectionCard({required String title, required Widget child}) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.7),
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              )),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    const dash = 3.0;
    const gap = 2.0;
    double x = 0;
    final y = size.height / 2;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + dash, y), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
