import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Colors ────────────────────────────────────────────────────────────────────
const Color _cyan    = Color(0xFF1fd4e8);
const Color _cyanD   = Color(0xFF031518);
const Color _green   = Color(0xFF2dcc8a);
const Color _greenD  = Color(0xFF041a0f);
const Color _red     = Color(0xFFf06b6b);
const Color _redD    = Color(0xFF1c0808);
const Color _amber   = Color(0xFFf5a623);
const Color _amberD  = Color(0xFF1c1100);
const Color _blue    = Color(0xFF5ba3f5);
const Color _blueD   = Color(0xFF071528);
const Color _violet  = Color(0xFF9b7ff5);
const Color _violetD = Color(0xFF100e26);

// ── Param config ──────────────────────────────────────────────────────────────
class _Cfg {
  final double lo, hi, mn, mx;
  final int dec;
  final bool sym, rev;
  const _Cfg({required this.lo, required this.hi, required this.mn, required this.mx, required this.dec, required this.sym, required this.rev});
}

const _cfgPh   = _Cfg(lo:7.35, hi:7.45, mn:6.80, mx:7.80, dec:2, sym:false, rev:false);
const _cfgPco2 = _Cfg(lo:35,   hi:45,   mn:10,   mx:100,  dec:0, sym:false, rev:false);
const _cfgHco3 = _Cfg(lo:22,   hi:26,   mn:5,    mx:45,   dec:0, sym:false, rev:false);
const _cfgBe   = _Cfg(lo:-2,   hi:2,    mn:-25,  mx:25,   dec:0, sym:true,  rev:false);
const _cfgPao2 = _Cfg(lo:80,   hi:100,  mn:20,   mx:200,  dec:0, sym:false, rev:true);
const _cfgSpo2 = _Cfg(lo:94,   hi:100,  mn:60,   mx:100,  dec:0, sym:false, rev:true);

// ── Result model ──────────────────────────────────────────────────────────────
class _BgResult {
  final String dis, disLbl, vCls;
  final bool mixed;
  final String? cExp, cAct, cNote, cCls;
  final String beNote, beCls;
  final String oxyNote, oxyCls;
  // anion gap
  final String? ag, corrAG, agStepCls, agNote, ddText, ddCls, lacNote;
  final bool agHi, cagHi;
  // raw values
  final double ph, pco2, hco3, be, pao2, spo2;
  const _BgResult({
    required this.dis, required this.disLbl, required this.vCls, required this.mixed,
    this.cExp, this.cAct, this.cNote, this.cCls,
    required this.beNote, required this.beCls,
    required this.oxyNote, required this.oxyCls,
    this.ag, this.corrAG, this.agStepCls, this.agNote, this.ddText, this.ddCls, this.lacNote,
    required this.agHi, required this.cagHi,
    required this.ph, required this.pco2, required this.hco3, required this.be,
    required this.pao2, required this.spo2,
  });
}

// ── Main widget ───────────────────────────────────────────────────────────────
class BloodGasAnalyser extends StatefulWidget {
  const BloodGasAnalyser({super.key});
  @override
  State<BloodGasAnalyser> createState() => _BloodGasAnalyserState();
}

class _BloodGasAnalyserState extends State<BloodGasAnalyser>
    with TickerProviderStateMixin {
  // Slider values
  double _ph   = 7.40;
  double _pco2 = 40;
  double _hco3 = 24;
  double _be   = 0;
  double _pao2 = 90;
  double _spo2 = 98;

  // Anion gap toggle + values
  bool _agOn = false;
  double _na  = 140;
  double _cl  = 105;
  double _alb = 4.0;
  double _lac = 1.0;

  final _naCtrl  = TextEditingController(text: '140');
  final _clCtrl  = TextEditingController(text: '105');
  final _albCtrl = TextEditingController(text: '4.0');
  final _lacCtrl = TextEditingController(text: '1.0');

  // Steps open/closed — steps 0 and 1 open by default
  late List<bool> _stepOpen;

  bool _showResults = false;
  _BgResult? _result;
  final _scrollCtrl = ScrollController();

  late AnimationController _blinkCtrl;
  late Animation<double> _blinkAnim;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _stepOpen = List.generate(8, (i) => i < 2);
    _blinkCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
    _blinkAnim = CurvedAnimation(parent: _blinkCtrl, curve: Curves.easeInOut);
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.07), end: Offset.zero)
        .animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _blinkCtrl.dispose();
    _fadeCtrl.dispose();
    _scrollCtrl.dispose();
    _naCtrl.dispose(); _clCtrl.dispose(); _albCtrl.dispose(); _lacCtrl.dispose();
    super.dispose();
  }

  // ── Analysis ────────────────────────────────────────────────────────────────
  void _analyse() {
    final ph   = _ph;
    final pco2 = _pco2;
    final hco3 = _hco3;
    final be   = _be;
    final pao2 = _pao2;
    final spo2 = _spo2;

    final phLow  = ph < 7.35;
    final phHigh = ph > 7.45;
    final phNorm = !phLow && !phHigh;
    final phSts  = phNorm ? 'normal' : phLow ? 'acidosis' : 'alkalosis';

    final co2Hi = pco2 > 45;
    final co2Lo = pco2 < 35;
    final hco3Hi = hco3 > 26;
    final hco3Lo = hco3 < 22;

    String dis, disLbl, vCls;
    bool mixed = false;

    if (phSts == 'acidosis') {
      vCls = 'vac';
      if (co2Hi && hco3Lo) { dis='mixed-ac'; disLbl='Mixed: Respiratory + Metabolic Acidosis'; vCls='vm'; mixed=true; }
      else if (co2Hi)      { dis='resp-ac';  disLbl='Respiratory Acidosis'; }
      else if (hco3Lo)     { dis='met-ac';   disLbl='Metabolic Acidosis'; }
      else                 { dis='resp-ac';  disLbl='Respiratory Acidosis'; }
    } else if (phSts == 'alkalosis') {
      vCls = 'val';
      if (co2Lo && hco3Hi) { dis='mixed-alk'; disLbl='Mixed: Respiratory + Metabolic Alkalosis'; vCls='vm'; mixed=true; }
      else if (co2Lo)      { dis='resp-alk';  disLbl='Respiratory Alkalosis'; }
      else if (hco3Hi)     { dis='met-alk';   disLbl='Metabolic Alkalosis'; }
      else                 { dis='resp-alk';  disLbl='Respiratory Alkalosis'; }
    } else {
      if      (co2Hi && hco3Hi) { dis='comp-resp-ac';  disLbl='Compensated Respiratory Acidosis'; }
      else if (co2Lo && hco3Lo) { dis='comp-resp-alk'; disLbl='Compensated Respiratory Alkalosis'; }
      else if (hco3Lo && co2Lo) { dis='comp-met-ac';   disLbl='Compensated Metabolic Acidosis'; }
      else if (hco3Hi && co2Hi) { dis='comp-met-alk';  disLbl='Compensated Metabolic Alkalosis'; }
      else                      { dis='normal';         disLbl='Normal Blood Gas'; }
      vCls = 'vn';
    }

    // Compensation
    String? cExp, cAct, cNote, cCls;
    bool cMixed = false;

    if (dis == 'resp-ac' || dis == 'comp-resp-ac') {
      final d = pco2 - 40;
      final eA = (24 + d/10*1).toStringAsFixed(1);
      final eC = (24 + d/10*3.5).toStringAsFixed(1);
      cExp = 'Acute: HCO₃ expected ~$eA mEq/L | Chronic: ~$eC mEq/L';
      cAct = 'Actual HCO₃: ${hco3.toInt()} mEq/L';
      final eAv = double.parse(eA);
      final eCv = double.parse(eC);
      if (hco3 < eAv-2)      { cNote='HCO₃ below expected → concurrent Metabolic Acidosis'; cCls='r'; cMixed=true; }
      else if (hco3 > eCv+2) { cNote='HCO₃ above expected → concurrent Metabolic Alkalosis'; cCls='a'; cMixed=true; }
      else                   { cNote='Compensation within expected range ✓'; cCls='g'; }
    } else if (dis == 'resp-alk' || dis == 'comp-resp-alk') {
      final d = 40 - pco2;
      final eA = (24 - d/10*2).toStringAsFixed(1);
      final eC = (24 - d/10*5).toStringAsFixed(1);
      cExp = 'Acute: HCO₃ expected ~$eA mEq/L | Chronic: ~$eC mEq/L';
      cAct = 'Actual HCO₃: ${hco3.toInt()} mEq/L';
      final eAv = double.parse(eA);
      final eCv = double.parse(eC);
      if (hco3 > eAv+2)      { cNote='HCO₃ above expected → concurrent Metabolic Alkalosis'; cCls='a'; cMixed=true; }
      else if (hco3 < eCv-2) { cNote='HCO₃ below expected → concurrent Metabolic Acidosis'; cCls='r'; cMixed=true; }
      else                   { cNote='Compensation within expected range ✓'; cCls='g'; }
    } else if (dis == 'met-ac' || dis == 'comp-met-ac') {
      final e = (1.5*hco3+8);
      cExp = "Winter's Formula: Expected PCO₂ = ${(e-2).toStringAsFixed(1)}–${(e+2).toStringAsFixed(1)} mmHg";
      cAct = 'Actual PCO₂: ${pco2.toInt()} mmHg';
      if (pco2 > e+2)      { cNote='PCO₂ higher → concurrent Respiratory Acidosis'; cCls='r'; cMixed=true; }
      else if (pco2 < e-2) { cNote='PCO₂ lower → concurrent Respiratory Alkalosis'; cCls='v'; cMixed=true; }
      else                 { cNote='Respiratory compensation appropriate ✓'; cCls='g'; }
    } else if (dis == 'met-alk' || dis == 'comp-met-alk') {
      final e = (0.7*(hco3-24)+40);
      cExp = 'Expected PCO₂ = ${(e-2).toStringAsFixed(1)}–${(e+2).toStringAsFixed(1)} mmHg';
      cAct = 'Actual PCO₂: ${pco2.toInt()} mmHg';
      if (pco2 < e-2)      { cNote='PCO₂ lower → concurrent Respiratory Alkalosis'; cCls='v'; cMixed=true; }
      else if (pco2 > e+2) { cNote='PCO₂ higher → concurrent Respiratory Acidosis'; cCls='r'; cMixed=true; }
      else                 { cNote='Compensation appropriate ✓'; cCls='g'; }
    }

    if (cMixed && !mixed) { mixed=true; vCls='vm'; disLbl='Mixed Disorder — $disLbl'; }

    // Base excess
    String beNote, beCls;
    if (be < -2) {
      beNote = 'Base deficit ${be.toInt()} mEq/L → metabolic acidosis component';
      beCls = 'r';
      if (be < -6) beNote += ' ⚠️ Significant base deficit';
    } else if (be > 2) {
      beNote = 'Base excess +${be.toInt()} mEq/L → metabolic alkalosis component';
      beCls = 'a';
    } else {
      beNote = 'BE ${be.toInt()} mEq/L — within normal (−2 to +2)';
      beCls = 'g';
    }

    // Oxygenation
    String oxyNote, oxyCls;
    if (pao2 < 60)      { oxyNote='Severe hypoxaemia — PaO₂ critically low'; oxyCls='r'; }
    else if (pao2 < 80) { oxyNote='Mild–moderate hypoxaemia'; oxyCls='a'; }
    else                { oxyNote='Oxygenation adequate'; oxyCls='g'; }

    // Anion gap
    String? agStr, corrAGStr, agStepCls, agNote, ddText, ddCls, lacNote;
    bool agHi = false, cagHi = false;
    if (_agOn) {
      final agV    = _na - (_cl + hco3);
      final corrAGV = agV + 2.5*(4.0 - _alb);
      agStr    = agV.toStringAsFixed(1);
      corrAGStr = corrAGV.toStringAsFixed(1);
      agHi  = agV    > 12;
      cagHi = corrAGV > 12;
      agStepCls = agHi ? 'r' : 'g';
      agNote = agHi
        ? 'Elevated AG — MUDPILES: Methanol · Uraemia · DKA · Propylene glycol/Paracetamol · Isoniazid · Lactic acidosis · Ethylene glycol · Salicylates'
        : 'Normal AG acidosis — HARDUP: Hyperalimentation · Addison\'s · RTA · Diarrhoea · Ureteroenteric fistula · Pancreatic fistula';
      if (agHi) {
        final dd = (agV-12)/(24-hco3);
        final ddStr = dd.toStringAsFixed(2);
        if (dd < 0.4)     { ddText='$ddStr — <0.4 → additional normal AG acidosis present'; ddCls='r'; }
        else if (dd <= 2) { ddText='$ddStr — 0.4–2 → pure high AG metabolic acidosis'; ddCls='g'; }
        else              { ddText='$ddStr — >2 → concurrent metabolic alkalosis or chronic elevated HCO₃'; ddCls='a'; }
      }
      if (_lac > 2) {
        lacNote = 'Lactate ${_lac.toStringAsFixed(1)} mmol/L ↑ — suggests lactic acidosis (type A: hypoperfusion | type B: metabolic)';
      }
    }

    setState(() {
      _result = _BgResult(
        dis:dis, disLbl:disLbl, vCls:vCls, mixed:mixed,
        cExp:cExp, cAct:cAct, cNote:cNote, cCls:cCls,
        beNote:beNote, beCls:beCls,
        oxyNote:oxyNote, oxyCls:oxyCls,
        ag:agStr, corrAG:corrAGStr, agStepCls:agStepCls, agNote:agNote,
        ddText:ddText, ddCls:ddCls, lacNote:lacNote,
        agHi:agHi, cagHi:cagHi,
        ph:ph, pco2:pco2, hco3:hco3, be:be, pao2:pao2, spo2:spo2,
      );
      _showResults = true;
      _stepOpen = List.generate(8, (i) => i < 2);
    });
    _fadeCtrl.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
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
        title: const Text('Blood Gas Analyser',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        elevation: 0,
      ),
      body: KeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKeyEvent: (e) {
          if (e is KeyDownEvent) {
            if (e.logicalKey == LogicalKeyboardKey.enter) _analyse();
          }
        },
        child: SingleChildScrollView(
          controller: _scrollCtrl,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height:16),
              _buildSliderSection(),
              const SizedBox(height:12),
              _buildAGSection(),
              const SizedBox(height:16),
              _buildAnalyseButton(),
              if (_showResults && _result != null) ...[
                const SizedBox(height:20),
                FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: _buildResults(_result!),
                  ),
                ),
              ],
              const SizedBox(height:32),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AnimatedBuilder(
              animation: _blinkAnim,
              builder: (context2, child2) => Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _cyan.withValues(alpha: _blinkAnim.value),
                ),
              ),
            ),
            const SizedBox(width:6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal:10, vertical:4),
              decoration: BoxDecoration(
                color: _cyanD,
                border: Border.all(color: _cyan.withValues(alpha:0.4)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('ABG Interpreter',
                  style: TextStyle(color:_cyan, fontSize:11, fontWeight:FontWeight.bold, letterSpacing:1.2)),
            ),
          ],
        ),
        const SizedBox(height:8),
        Text('Blood Gas Analyser',
            style: TextStyle(color:Theme.of(context).colorScheme.onSurface, fontSize:22, fontWeight:FontWeight.bold)),
        const SizedBox(height:4),
        Text('Gradient sliders · systematic 7-step interpretation · clinical approach & formulas',
            style: TextStyle(color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize:12.5)),
      ],
    );
  }

  // ── Slider section ───────────────────────────────────────────────────────────
  Widget _buildSliderSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Acid–Base Parameters',
              style: TextStyle(color:Theme.of(context).colorScheme.onSurface, fontSize:13.5, fontWeight:FontWeight.bold)),
          const SizedBox(height:16),
          _buildSlider(
            name:'pH', unit:'—', value:_ph, cfg:_cfgPh,
            marks: const ['6.80 (critical low)', 'Normal 7.35–7.45', '7.80 (critical high)'],
            onChanged: (v) => setState(() => _ph = v),
          ),
          const SizedBox(height:20),
          _buildSlider(
            name:'PaCO₂', unit:'mmHg', value:_pco2, cfg:_cfgPco2,
            marks: const ['10 (low)', 'Normal 35–45', '100 (high)'],
            onChanged: (v) => setState(() => _pco2 = v),
          ),
          const SizedBox(height:20),
          _buildSlider(
            name:'HCO₃⁻', unit:'mEq/L', value:_hco3, cfg:_cfgHco3,
            marks: const ['5', 'Normal 22–26', '45'],
            onChanged: (v) => setState(() => _hco3 = v),
          ),
          const SizedBox(height:20),
          _buildSlider(
            name:'Base Excess', unit:'mEq/L', value:_be, cfg:_cfgBe,
            marks: const ['−25 (deficit)', 'Normal −2 to +2', '+25 (excess)'],
            onChanged: (v) => setState(() => _be = v),
            showPlus: true,
          ),
          const SizedBox(height:20),
          _buildSlider(
            name:'PaO₂', unit:'mmHg', value:_pao2, cfg:_cfgPao2,
            marks: const ['20 (critical)', 'Normal 80–100', '200'],
            onChanged: (v) => setState(() => _pao2 = v),
          ),
          const SizedBox(height:20),
          _buildSlider(
            name:'SpO₂', unit:'%', value:_spo2, cfg:_cfgSpo2,
            marks: const ['60% (critical)', 'Target ≥94%', '100%'],
            onChanged: (v) => setState(() => _spo2 = v),
            optional: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String name,
    required String unit,
    required double value,
    required _Cfg cfg,
    required List<String> marks,
    required ValueChanged<double> onChanged,
    bool showPlus = false,
    bool optional = false,
  }) {
    // Determine status
    String status; Color statusColor, statusBg;
    if (cfg.rev) {
      if (value < cfg.lo)      { status='LOW';    statusColor=_red;   statusBg=_redD; }
      else if (value <= cfg.hi){ status='NORMAL'; statusColor=_green; statusBg=_greenD; }
      else                     { status='NORMAL'; statusColor=_green; statusBg=_greenD; }
    } else {
      if (value < cfg.lo)      { status='LOW';    statusColor=_blue;  statusBg=_blueD; }
      else if (value > cfg.hi) { status='HIGH';   statusColor=_red;   statusBg=_redD; }
      else                     { status='NORMAL'; statusColor=_green; statusBg=_greenD; }
    }

    Color valueColor = statusColor;

    String displayVal = cfg.dec == 0
        ? value.toInt().toString()
        : value.toStringAsFixed(cfg.dec);
    if (showPlus && value > 0) displayVal = '+$displayVal';

    // Gradient colors
    List<Color> gradColors;
    if (cfg.rev) {
      gradColors = [_red, _amber, _green];
    } else if (cfg.sym) {
      gradColors = [_blue, _green, _red];
    } else {
      gradColors = [_blue, _green, _red];
    }

    final range = cfg.mx - cfg.mn;
    final loFrac = (cfg.lo - cfg.mn) / range;
    final hiFrac = (cfg.hi - cfg.mn) / range;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(name, style: TextStyle(color:Theme.of(context).colorScheme.onSurface, fontSize:13, fontWeight:FontWeight.w600)),
            const SizedBox(width:4),
            Text(unit, style: TextStyle(color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize:11.5)),
            if (optional) ...[
              const SizedBox(width:6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal:6, vertical:2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('optional', style: TextStyle(color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize:10)),
              ),
            ],
            const Spacer(),
            Text(displayVal, style: TextStyle(color:valueColor, fontSize:16, fontWeight:FontWeight.bold)),
            const SizedBox(width:8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal:7, vertical:3),
              decoration: BoxDecoration(
                color: statusBg,
                border: Border.all(color: statusColor.withValues(alpha:0.5)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(status, style: TextStyle(color:statusColor, fontSize:10, fontWeight:FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height:8),
        // Gradient track with slider
        _GradientSlider(
          value: value,
          min: cfg.mn,
          max: cfg.mx,
          gradColors: gradColors,
          loFrac: loFrac,
          hiFrac: hiFrac,
          step: cfg.dec == 0 ? 1.0 : (cfg.dec == 2 ? 0.01 : 0.1),
          onChanged: onChanged,
        ),
        const SizedBox(height:4),
        Row(
          children: [
            Text(marks[0], style: TextStyle(color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize:10)),
            const Spacer(),
            Text(marks[1], style: TextStyle(color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize:10)),
            const Spacer(),
            Text(marks[2], style: TextStyle(color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize:10)),
          ],
        ),
      ],
    );
  }

  // ── Anion Gap section ────────────────────────────────────────────────────────
  Widget _buildAGSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _agOn = !_agOn),
            child: Row(
              children: [
                const Text('⚗️', style: TextStyle(fontSize:16)),
                const SizedBox(width:8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Anion Gap Calculation',
                          style: TextStyle(color:Theme.of(context).colorScheme.onSurface, fontSize:13.5, fontWeight:FontWeight.bold)),
                      SizedBox(height:2),
                      Text('(toggle to include)', style: TextStyle(color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize:11)),
                    ],
                  ),
                ),
                _CyanSwitch(value: _agOn, onChanged: (v) => setState(() => _agOn = v)),
              ],
            ),
          ),
          if (_agOn) ...[
            const SizedBox(height:16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.2,
              children: [
                _agStepper(label:'Sodium Na⁺', unit:'mEq/L', value:_na, ctrl:_naCtrl, min:100, max:170, step:1, dec:0,
                    onChanged:(v) => setState(() => _na = v)),
                _agStepper(label:'Chloride Cl⁻', unit:'mEq/L', value:_cl, ctrl:_clCtrl, min:80, max:130, step:1, dec:0,
                    onChanged:(v) => setState(() => _cl = v)),
                _agStepper(label:'Albumin', unit:'g/dL', value:_alb, ctrl:_albCtrl, min:0.5, max:6, step:0.1, dec:1,
                    onChanged:(v) => setState(() => _alb = v)),
                _agStepper(label:'Lactate', unit:'mmol/L', value:_lac, ctrl:_lacCtrl, min:0, max:20, step:0.1, dec:1,
                    onChanged:(v) => setState(() => _lac = v)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _agStepper({
    required String label, required String unit, required double value,
    required TextEditingController ctrl,
    required double min, required double max, required double step, required int dec,
    required ValueChanged<double> onChanged,
  }) {
    String fmt(double v) => dec == 0 ? v.toInt().toString() : v.toStringAsFixed(dec);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color:Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize:10.5, fontWeight:FontWeight.w600)),
          Text(unit, style: TextStyle(color:Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), fontSize:9.5)),
          const SizedBox(height:4),
          Row(
            children: [
              _smBtn('−', () {
                final nv = double.parse((value - step).toStringAsFixed(dec+1));
                if (nv >= min) { ctrl.text = fmt(nv); onChanged(nv); }
              }),
              Expanded(
                child: TextField(
                  controller: ctrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: dec > 0),
                  textAlign: TextAlign.center,
                  style: TextStyle(color:Theme.of(context).colorScheme.onSurface, fontSize:13, fontWeight:FontWeight.bold),
                  decoration: const InputDecoration(
                    border: InputBorder.none, isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical:2, horizontal:2),
                  ),
                  onChanged: (t) {
                    final p = double.tryParse(t);
                    if (p != null && p >= min && p <= max) onChanged(p);
                  },
                ),
              ),
              _smBtn('+', () {
                final nv = double.parse((value + step).toStringAsFixed(dec+1));
                if (nv <= max) { ctrl.text = fmt(nv); onChanged(nv); }
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(color:Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(6)),
        child: Center(child: Text(label, style: TextStyle(color:Theme.of(context).colorScheme.onSurface, fontSize:16, fontWeight:FontWeight.bold))),
      ),
    );
  }

  // ── Analyse button ───────────────────────────────────────────────────────────
  Widget _buildAnalyseButton() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_cyan, Color(0xFF0891b2)]),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _analyse,
          borderRadius: BorderRadius.circular(10),
          child: const Center(
            child: Text('⚡ Analyse Blood Gas',
                style: TextStyle(color: Color(0xFF07090d), fontSize:15, fontWeight:FontWeight.bold, letterSpacing:0.5)),
          ),
        ),
      ),
    );
  }

  // ── Results ──────────────────────────────────────────────────────────────────
  Widget _buildResults(_BgResult r) {
    final stepCount = _agOn ? 7 : 6;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildVerdict(r),
        const SizedBox(height:12),
        _buildRawStrip(r),
        const SizedBox(height:12),
        _buildStep(0, r, '1', 'pH Assessment', 'pH ${r.ph.toStringAsFixed(2)} → ${r.phSts(r.ph).toUpperCase()}', _cyan, _buildStep1Body(r)),
        const SizedBox(height:8),
        _buildStep(1, r, '2', 'Identify Primary Disorder', r.disLbl, _cyan, _buildStep2Body(r)),
        const SizedBox(height:8),
        _buildStep(2, r, '3', 'Compensation Analysis', r.cNote ?? 'No compensation applicable', _clsColor(r.cCls), _buildStep3Body(r)),
        const SizedBox(height:8),
        _buildStep(3, r, '4', 'Base Excess / Deficit', 'BE ${r.be >= 0 && r.beCls != 'g' ? '+' : ''}${r.be.toInt()} mEq/L', _clsColor(r.beCls), _buildStep4Body(r)),
        const SizedBox(height:8),
        _buildStep(4, r, '5', 'Oxygenation Assessment', 'PaO₂ ${r.pao2.toInt()} mmHg · SpO₂ ${r.spo2.toInt()}%', _clsColor(r.oxyCls), _buildStep5Body(r)),
        if (_agOn) ...[
          const SizedBox(height:8),
          _buildStep(5, r, '6', 'Anion Gap', 'AG ${r.ag} mEq/L — ${r.agHi ? 'ELEVATED' : 'Normal'}', _clsColor(r.agStepCls), _buildStep6Body(r)),
        ],
        const SizedBox(height:8),
        _buildStep(_agOn ? 6 : 5, r, '$stepCount', 'Mixed Disorder', r.mixed ? '⚠ Detected' : '— Not Detected',
            r.mixed ? _violet : _green, _buildStepMixedBody(r, stepCount)),
        const SizedBox(height:16),
        _buildDisclaimer(),
      ],
    );
  }

  Color _clsColor(String? cls) {
    switch (cls) {
      case 'r': return _red;
      case 'g': return _green;
      case 'a': return _amber;
      case 'v': return _violet;
      default:  return _cyan;
    }
  }

  // ── Verdict box ──────────────────────────────────────────────────────────────
  Widget _buildVerdict(_BgResult r) {
    Color bg, border, textC;
    switch (r.vCls) {
      case 'vac': bg=_redD;    border=_red.withValues(alpha:.5);    textC=_red;    break;
      case 'val': bg=_blueD;   border=_blue.withValues(alpha:.5);   textC=_blue;   break;
      case 'vm':  bg=_violetD; border=_violet.withValues(alpha:.5); textC=_violet; break;
      default:    bg=_greenD;  border=_green.withValues(alpha:.5);  textC=_green;  break;
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color:bg, border:Border.all(color:border), borderRadius:BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Primary Interpretation', style: TextStyle(color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize:10.5)),
                    const SizedBox(height:4),
                    Text(r.disLbl, style: TextStyle(color:textC, fontSize:14, fontWeight:FontWeight.bold)),
                  ],
                ),
              ),
              Text(r.ph.toStringAsFixed(2),
                  style: TextStyle(color:textC, fontSize:28, fontWeight:FontWeight.bold)),
            ],
          ),
          const SizedBox(height:8),
          Text(
            'pH ${r.ph.toStringAsFixed(2)} · PCO₂ ${r.pco2.toInt()} · HCO₃ ${r.hco3.toInt()} · BE ${r.be >= 0 ? '+' : ''}${r.be.toInt()} · PaO₂ ${r.pao2.toInt()} · SpO₂ ${r.spo2.toInt()}%${r.mixed ? ' · ⚠ Mixed disorder detected' : ''}',
            style: TextStyle(color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize:11.5),
          ),
        ],
      ),
    );
  }

  // ── Raw strip ────────────────────────────────────────────────────────────────
  Widget _buildRawStrip(_BgResult r) {
    return Row(
      children: [
        _rawBox('pH',   r.ph.toStringAsFixed(2),   r.ph < 7.35 ? 'lo' : r.ph > 7.45 ? 'hi' : 'ok', false),
        const SizedBox(width:6),
        _rawBox('PCO₂', '${r.pco2.toInt()}',        r.pco2 < 35 ? 'lo' : r.pco2 > 45 ? 'hi' : 'ok', false),
        const SizedBox(width:6),
        _rawBox('HCO₃', '${r.hco3.toInt()}',        r.hco3 < 22 ? 'lo' : r.hco3 > 26 ? 'hi' : 'ok', false),
        const SizedBox(width:6),
        _rawBox('BE',   '${r.be >= 0 ? '+' : ''}${r.be.toInt()}', r.be < -2 ? 'lo' : r.be > 2 ? 'hi' : 'ok', false),
        const SizedBox(width:6),
        _rawBox('PaO₂', '${r.pao2.toInt()}',        r.pao2 < 80 ? 'lo' : 'ok', true),
        const SizedBox(width:6),
        _rawBox('SpO₂', '${r.spo2.toInt()}%',       r.spo2 < 94 ? 'lo' : 'ok', true),
      ],
    );
  }

  Widget _rawBox(String label, String val, String sts, bool inv) {
    Color c;
    if (sts == 'ok') {
      c = _green;
    } else if (inv) {
      c = _red;
    } else if (sts == 'lo') {
      c = _blue;
    } else {
      c = _red;
    }
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical:8, horizontal:4),
        decoration: BoxDecoration(
          color: c.withValues(alpha:.12),
          border: Border.all(color: c.withValues(alpha:.4)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize:9.5)),
            const SizedBox(height:4),
            Text(val, style: TextStyle(color:c, fontSize:12, fontWeight:FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // ── Collapsible step ─────────────────────────────────────────────────────────
  Widget _buildStep(int idx, _BgResult r, String num, String title, String sub, Color numColor, Widget body) {
    final open = _stepOpen[idx];
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: open ? numColor.withValues(alpha:.4) : Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _stepOpen[idx] = !_stepOpen[idx]),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width:28, height:28,
                    decoration: BoxDecoration(
                      color: numColor.withValues(alpha:.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Text(num, style: TextStyle(color:numColor, fontSize:12, fontWeight:FontWeight.bold))),
                  ),
                  const SizedBox(width:10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Step $num — $title',
                            style: TextStyle(color:Theme.of(context).colorScheme.onSurface, fontSize:12.5, fontWeight:FontWeight.bold)),
                        const SizedBox(height:2),
                        Text(sub, style: TextStyle(color:numColor, fontSize:11.5), maxLines:2, overflow:TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Icon(open ? Icons.expand_less : Icons.expand_more, color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), size:18),
                ],
              ),
            ),
          ),
          if (open) ...[
            Divider(height:1, color: Theme.of(context).colorScheme.outline),
            Padding(padding: const EdgeInsets.all(12), child: body),
          ],
        ],
      ),
    );
  }

  // ── Step bodies ──────────────────────────────────────────────────────────────
  Widget _buildStep1Body(_BgResult r) {
    final ph = r.ph;
    final phDesc = ph < 7.35
        ? 'below 7.35 → Acidaemia'
        : ph > 7.45 ? 'above 7.45 → Alkalaemia' : 'within normal range (7.35–7.45)';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _bodyText('pH ${ph.toStringAsFixed(2)} is $phDesc.'),
        const SizedBox(height:8),
        _bodyText('pH is the net result — it tells us the overall acid-base balance but not the cause. Normal pH does not exclude a disorder — a compensated disorder can have a normal pH.'),
        const SizedBox(height:8),
        _pill(Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), 'Critical values: pH <7.2 or >7.6 require urgent attention · Incompatible with life: <6.8 or >7.8'),
      ],
    );
  }

  Widget _buildStep2Body(_BgResult r) {
    final pco2C = r.pco2 > 45 ? _red : r.pco2 < 35 ? _blue : _green;
    final hco3C = r.hco3 > 26 ? _red : r.hco3 < 22 ? _blue : _green;
    final pco2D = r.pco2 > 45 ? '↑ HIGH — hypoventilation' : r.pco2 < 35 ? '↓ LOW — hyperventilation' : 'Normal range';
    final hco3D = r.hco3 > 26 ? '↑ HIGH — metabolic alkalosis driver' : r.hco3 < 22 ? '↓ LOW — metabolic acidosis driver' : 'Normal range';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _valueRow('PCO₂', '${r.pco2.toInt()}', 'mmHg', pco2C, pco2D),
        const SizedBox(height:6),
        _valueRow('HCO₃', '${r.hco3.toInt()}', 'mEq/L', hco3C, hco3D),
        const SizedBox(height:8),
        _bodyText('Key rule: The parameter that moves in the same direction as pH (or would cause pH to move that way) is the primary driver. The other parameter is the compensation.'),
        const SizedBox(height:8),
        _intelBlock(r.dis, r),
      ],
    );
  }

  Widget _buildStep3Body(_BgResult r) {
    if (r.cExp == null) {
      return _bodyText('No compensation formula applicable for this pattern.');
    }
    final ccColor = _clsColor(r.cCls);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _cyanD, border: Border.all(color:_cyan.withValues(alpha:.3)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(r.cExp!, style: const TextStyle(color:_cyan, fontSize:12, fontFamily:'monospace')),
        ),
        const SizedBox(height:6),
        Text(r.cAct!, style: TextStyle(color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize:12)),
        const SizedBox(height:6),
        _pill(ccColor, ccColor.withValues(alpha:.12), r.cNote!),
        const SizedBox(height:8),
        _intelBlock('compensation', r),
      ],
    );
  }

  Widget _buildStep4Body(_BgResult r) {
    final bc = _clsColor(r.beCls);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('${r.be >= 0 ? '+' : ''}${r.be.toInt()}',
                style: TextStyle(color:bc, fontSize:22, fontWeight:FontWeight.bold)),
            const SizedBox(width:6),
            Text('mEq/L', style: TextStyle(color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize:12)),
            const SizedBox(width:10),
            Expanded(child: Text(r.beNote, style: TextStyle(color:bc, fontSize:12))),
          ],
        ),
        const SizedBox(height:8),
        _intelBlock('be', r),
      ],
    );
  }

  Widget _buildStep5Body(_BgResult r) {
    final pao2C = r.pao2 >= 80 ? _green : r.pao2 >= 60 ? _amber : _red;
    final spo2C = r.spo2 >= 94 ? _green : r.spo2 >= 88 ? _amber : _red;
    final pao2Sub = r.pao2 >= 80 ? 'Normal mmHg' : r.pao2 >= 60 ? 'Mild hypoxaemia' : 'Hypoxaemia';
    final spo2Sub = r.spo2 >= 94 ? 'Adequate' : r.spo2 >= 88 ? 'Borderline' : 'Low';
    final oxC = _clsColor(r.oxyCls);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _oxyBox('PaO₂', '${r.pao2.toInt()}', pao2Sub, pao2C)),
            const SizedBox(width:10),
            Expanded(child: _oxyBox('SpO₂', '${r.spo2.toInt()}%', spo2Sub, spo2C)),
          ],
        ),
        const SizedBox(height:8),
        _pill(oxC, oxC.withValues(alpha:.12), r.oxyNote),
        const SizedBox(height:8),
        _intelBlock('oxy', r),
      ],
    );
  }

  Widget _oxyBox(String label, String val, String sub, Color c) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: c.withValues(alpha:.1),
        border: Border.all(color:c.withValues(alpha:.4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize:11)),
          const SizedBox(height:4),
          Text(val, style: TextStyle(color:c, fontSize:20, fontWeight:FontWeight.bold)),
          const SizedBox(height:2),
          Text(sub, style: TextStyle(color:c, fontSize:10.5)),
        ],
      ),
    );
  }

  Widget _buildStep6Body(_BgResult r) {
    if (!_agOn || r.ag == null) return _bodyText('Enable Anion Gap toggle above.');
    final agC    = r.agHi  ? _red : _green;
    final cagC   = r.cagHi ? _red : _green;
    final agNotC = r.agHi  ? _red : _amber;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _oxyBox('Anion Gap', r.ag!, '${r.agHi ? 'ELEVATED >12' : 'Normal ≤12'} mEq/L', agC)),
            const SizedBox(width:10),
            Expanded(child: _oxyBox('Corrected AG (alb)', r.corrAG!, '${r.cagHi ? 'ELEVATED >12' : 'Normal ≤12'} mEq/L', cagC)),
          ],
        ),
        const SizedBox(height:8),
        _pill(agNotC, agNotC.withValues(alpha:.12), r.agNote!),
        if (r.lacNote != null) ...[
          const SizedBox(height:6),
          _pill(_red, _redD, r.lacNote!),
        ],
        if (r.agHi && r.ddText != null) ...[
          const SizedBox(height:8),
          _intelBlock('dd', r),
        ],
        const SizedBox(height:8),
        _intelBlock('ag', r),
      ],
    );
  }

  Widget _buildStepMixedBody(_BgResult r, int stepNum) {
    if (!r.mixed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bodyText('Compensation is appropriate for a single primary disorder. No mixed disorder detected — always correlate clinically.'),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _bodyText('The actual compensation is outside the expected range for a single disorder — a concurrent second acid-base disorder is present.'),
        const SizedBox(height:6),
        if (r.cNote != null) _pill(_red, _redD, r.cNote!),
        const SizedBox(height:8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _violetD, border: Border.all(color:_violet.withValues(alpha:.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('🔍 Approach to Mixed Disorders',
                  style: TextStyle(color:_violet, fontSize:12.5, fontWeight:FontWeight.bold)),
              const SizedBox(height:8),
              _bodyText('Step 1: Identify primary disorder from pH direction.', color:Theme.of(context).colorScheme.onSurface),
              _bodyText('Step 2: Calculate expected compensation.', color:Theme.of(context).colorScheme.onSurface),
              _bodyText('Step 3: If actual ≠ expected → name the second disorder.', color:Theme.of(context).colorScheme.onSurface),
              const SizedBox(height:6),
              Text('Common mixed patterns:', style: TextStyle(color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize:11.5)),
              const SizedBox(height:4),
              _bullet('Met acidosis + Resp acidosis → cardiac arrest, neonatal asphyxia, severe sepsis with respiratory failure'),
              _bullet('Met alkalosis + Resp alkalosis → over-ventilated patient with vomiting/NG losses'),
              _bullet('High AG acidosis + Met alkalosis → DKA with vomiting (detect via Delta-Delta ratio)'),
            ],
          ),
        ),
      ],
    );
  }

  // ── Intel blocks ─────────────────────────────────────────────────────────────
  Widget _intelBlock(String key, _BgResult r) {
    String title;
    List<Widget> content;
    switch (key) {
      case 'resp-ac':
        title = 'Respiratory Acidosis — Clinical Approach';
        content = [
          _bodyText('Primary problem: CO₂ retention (hypoventilation) → pH falls. The lungs are failing to eliminate CO₂.'),
          _bodyText('How to identify: pH ↓ + PCO₂ ↑. HCO₃ rises as renal compensation (takes 3–5 days for full effect).'),
          _formulaBox('Acute compensation:   HCO₃ rises ~1 mEq/L per 10 mmHg ↑ PCO₂ · pH falls ~0.08\nChronic compensation: HCO₃ rises ~3.5 mEq/L per 10 mmHg ↑ PCO₂ · pH falls ~0.03'),
          _subHead('Common causes:'),
          _bullet('CNS depression: Opioids, sedatives, brainstem injury, seizures'),
          _bullet('Airway/Lung: Severe asthma, COPD, pneumothorax, severe pneumonia, ARDS'),
          _bullet('Neuromuscular: Myasthenia gravis, Guillain-Barré, phrenic nerve palsy'),
          _bullet('Neonatal: RDS, MAS, TTN, apnoea of prematurity, PPHN'),
          _bodyText('Management: Treat the underlying cause. Support ventilation — oxygen, NIV, HFNC, or intubation as indicated.'),
        ];
        break;
      case 'comp-resp-ac':
        title = 'Compensated Respiratory Acidosis — Clinical Approach';
        content = [
          _bodyText('Primary problem: Same as respiratory acidosis — CO₂ retention (hypoventilation). However, pH has normalised because the kidneys have had sufficient time (3–5 days) to retain HCO₃.'),
          _bodyText('This indicates a CHRONIC respiratory disorder.'),
          _formulaBox('Chronic: Expected HCO₃ = 24 + [(PCO₂ − 40) / 10] × 3.5\nAcute:   Expected HCO₃ = 24 + [(PCO₂ − 40) / 10] × 1'),
          _bodyText('Key clinical point: In a chronic CO₂ retainer (e.g. COPD), giving high-flow oxygen can abolish the hypoxic respiratory drive and worsen hypercapnia — use controlled oxygen therapy.'),
          _bodyText('Common causes: Chronic COPD, chronic neuromuscular disease, obesity hypoventilation syndrome, chronic lung disease of prematurity.'),
        ];
        break;
      case 'resp-alk':
        title = 'Respiratory Alkalosis — Clinical Approach';
        content = [
          _bodyText('Primary problem: Hyperventilation → CO₂ falls → pH rises. The lungs are eliminating too much CO₂.'),
          _bodyText('How to identify: pH ↑ + PCO₂ ↓. Kidney compensates by excreting HCO₃ (takes days).'),
          _formulaBox('Acute:   HCO₃ falls ~2 mEq/L per 10 mmHg ↓ PCO₂ · pH rises ~0.08\nChronic: HCO₃ falls ~5 mEq/L per 10 mmHg ↓ PCO₂'),
          _subHead('Common causes:'),
          _bullet('Anxiety, pain, crying, fever'),
          _bullet('Hypoxia (reflex hyperventilation)'),
          _bullet('Sepsis (early — central stimulation)'),
          _bullet('Over-ventilation on mechanical ventilator'),
          _bullet('Salicylate toxicity (early), hepatic encephalopathy'),
          _bullet('Pregnancy (progesterone-driven)'),
          _bodyText('Management: Treat underlying cause. Reduce ventilator rate/TV if iatrogenic.'),
        ];
        break;
      case 'comp-resp-alk':
        title = 'Compensated Respiratory Alkalosis — Clinical Approach';
        content = [
          _bodyText('Primary problem: Chronic hyperventilation → CO₂ low. Kidneys have excreted HCO₃ over time to bring pH back toward normal.'),
          _formulaBox('Chronic: Expected HCO₃ = 24 − [(40 − PCO₂) / 10] × 5\nAcute:   Expected HCO₃ = 24 − [(40 − PCO₂) / 10] × 2'),
          _bodyText('Common causes: Chronic liver disease (hepatic encephalopathy), pregnancy, high-altitude acclimatisation, chronic anaemia, chronic pain states.'),
        ];
        break;
      case 'met-ac':
        title = 'Metabolic Acidosis — Clinical Approach';
        content = [
          _bodyText('Primary problem: HCO₃ low → pH falls. The body has gained excess acid or lost base through a metabolic process.'),
          _bodyText('How to identify: pH ↓ + HCO₃ ↓. Lungs compensate rapidly (minutes to hours) by hyperventilating (Kussmaul breathing).'),
          _formulaBox("Winter's Formula — Expected respiratory compensation:\nExpected PCO₂ = (1.5 × HCO₃) + 8  ±  2 mmHg\n\nIf actual PCO₂ > expected → concurrent Respiratory Acidosis\nIf actual PCO₂ < expected → concurrent Respiratory Alkalosis"),
          _subHead('Step 2 — Calculate Anion Gap (AG):'),
          _formulaBox('AG = Na⁺ − (Cl⁻ + HCO₃⁻)        Normal: 8–12 mEq/L\nCorrected AG = AG + 2.5 × (4.0 − albumin g/dL)'),
          _subHead('Elevated AG (>12) — MUDPILES:'),
          _bullet('M-ethanol · U-raemia · D-KA'),
          _bullet('P-ropylene glycol / Paracetamol · I-soniazid'),
          _bullet('L-actic acidosis · E-thylene glycol · S-alicylates'),
          _bodyText('Normal AG — HARDUP: Hyperalimentation · Addison\'s · RTA · Diarrhoea · Ureteroenteric fistula · Pancreatic fistula'),
        ];
        break;
      case 'comp-met-ac':
        title = 'Compensated Metabolic Acidosis — Clinical Approach';
        content = [
          _bodyText('Primary problem: Low HCO₃ (metabolic). Lungs have compensated with hyperventilation (Kussmaul breathing) to blow off CO₂, bringing pH back toward normal.'),
          _formulaBox("Winter's Formula: Expected PCO₂ = (1.5 × HCO₃) + 8  ±  2\n\nNormal pH does NOT mean resolved — the metabolic process is still active."),
          _bodyText('Always calculate AG in metabolic acidosis. If AG is elevated, also calculate the Delta-Delta ratio to detect a coexisting disorder:'),
          _formulaBox('Delta-Delta = (AG − 12) / (24 − HCO₃)\n< 0.4  → additional normal AG acidosis present\n0.4–2  → pure high AG metabolic acidosis\n> 2   → concurrent metabolic alkalosis or chronic elevated HCO₃'),
        ];
        break;
      case 'met-alk':
        title = 'Metabolic Alkalosis — Clinical Approach';
        content = [
          _bodyText('Primary problem: HCO₃ high → pH rises. The body has gained base or lost acid through a metabolic process.'),
          _bodyText('How to identify: pH ↑ + HCO₃ ↑. Lungs compensate by hypoventilating (retaining CO₂).'),
          _formulaBox('Expected PCO₂ = 0.7 × (HCO₃ − 24) + 40  ±  5 mmHg\nNote: Compensation is limited — body won\'t allow SpO₂ to fall <90%'),
          _subHead('Two categories — urine Cl⁻ is key:'),
          _bullet('Chloride-responsive (urine Cl⁻ <20 mEq/L): Vomiting, NG suctioning, diuretics (past use), post-hypercapnia. Treat with volume + NaCl.'),
          _bullet('Chloride-resistant (urine Cl⁻ >20 mEq/L): Hyperaldosteronism, Cushing\'s, Bartter/Gitelman syndrome, exogenous steroids. Treat the underlying cause.'),
        ];
        break;
      case 'comp-met-alk':
        title = 'Compensated Metabolic Alkalosis — Clinical Approach';
        content = [
          _bodyText('Primary problem: High HCO₃. Lungs are hypoventilating (retaining CO₂) to compensate.'),
          _formulaBox('Expected PCO₂ = 0.7 × (HCO₃ − 24) + 40  ±  5 mmHg'),
          _bodyText('Respiratory compensation for metabolic alkalosis is always incomplete — the hypoxic drive prevents CO₂ retention beyond a certain point (PCO₂ rarely rises above 55–60 in pure metabolic alkalosis).'),
          _bodyText('Assess urine Cl⁻ to classify as chloride-responsive vs chloride-resistant.'),
        ];
        break;
      case 'normal':
        title = 'Normal Blood Gas — Clinical Approach';
        content = [
          _bodyText('All parameters within normal limits. This can represent:'),
          _bullet('Truly normal acid-base status'),
          _bullet('A fully compensated disorder — check if CO₂ and HCO₃ are both abnormal (both high or both low suggests compensated disorder)'),
          _bullet('A mixed disorder where two processes cancel out — always interpret in clinical context'),
          _bodyText('Do not assume a normal gas means the patient is well — oxygenation parameters and clinical status matter equally.'),
        ];
        break;
      case 'mixed-ac':
        title = 'Mixed Acidosis — Clinical Approach';
        content = [
          _bodyText('Most dangerous pattern: Both CO₂ ↑ (respiratory acidosis) AND HCO₃ ↓ (metabolic acidosis) simultaneously. Neither system can compensate for the other — pH can be severely low.'),
          _subHead('Common scenarios:'),
          _bullet('Cardiorespiratory arrest — lactic acidosis + CO₂ retention'),
          _bullet('Severe sepsis with respiratory failure'),
          _bullet('Neonatal asphyxia — the classic mixed picture (low pH, high CO₂, low HCO₃, high BE deficit)'),
          _bullet('Severe COPD + acute kidney injury'),
          _bodyText('Management: Urgent — address both simultaneously. Ventilate to correct CO₂. Treat metabolic cause (fluids, bicarbonate if BE < −10 and pH < 7.1, treat sepsis/hypoperfusion).'),
        ];
        break;
      case 'mixed-alk':
        title = 'Mixed Alkalosis — Clinical Approach';
        content = [
          _bodyText('Both CO₂ ↓ (respiratory alkalosis) AND HCO₃ ↑ (metabolic alkalosis). pH will be very high.'),
          _subHead('Common scenarios:'),
          _bullet('Over-ventilated patient with vomiting or NG losses'),
          _bullet('Diuretic use + mechanical hyperventilation'),
          _bullet('Post-cardiac surgery (citrate from transfusions + ventilator hyperventilation)'),
          _bodyText('Management: Reduce ventilator rate/tidal volume + correct metabolic cause (chloride replacement, volume).'),
        ];
        break;
      case 'compensation':
        title = 'Compensation Principles';
        content = [
          _bodyText('Respiratory disorders → Renal compensation (slow: 3–5 days full effect)'),
          _bodyText('Acidosis: kidneys retain HCO₃ | Alkalosis: kidneys excrete HCO₃'),
          _bodyText('Metabolic disorders → Respiratory compensation (fast: minutes to hours)'),
          _bodyText('Acidosis: hyperventilate to ↓ CO₂ (Kussmaul breathing) | Alkalosis: hypoventilate to ↑ CO₂'),
          const SizedBox(height:4),
          _bodyText('Golden rule: Compensation never overshoots. If pH is normalised and continues beyond normal, that is a second independent disorder — not over-compensation.'),
        ];
        break;
      case 'be':
        title = 'What Base Excess Tells Us';
        content = [
          _bodyText('BE is the purest measure of the metabolic component — it mathematically removes the respiratory component.'),
          _formulaBox('BE = amount of acid or base (mEq/L) needed to restore pH to 7.40\nat normal temperature, PCO₂ = 40 mmHg\n\nBE < −2  → base deficit (metabolic acidosis component)\nBE > +2  → base excess (metabolic alkalosis component)\nBE < −6  → clinically significant (neonatal asphyxia, severe sepsis)\nBE < −10 → severe — correlates with significant hypoxic injury in neonates'),
          _bodyText('In neonatal medicine, BE is particularly valuable — a severely negative BE at birth correlates with hypoxic-ischaemic encephalopathy (HIE) risk.'),
        ];
        break;
      case 'oxy':
        title = 'Oxygenation Targets';
        content = [
          _bodyText('Standard adult/paediatric: PaO₂ 80–100 mmHg · SpO₂ ≥94%'),
          _bodyText('Preterm neonates: SpO₂ 91–95% — avoid hyperoxia (causes ROP, BPD, lung injury)'),
          _bodyText('Term neonates: SpO₂ ≥95%'),
          _formulaBox('Hypoxaemia classification (PaO₂ on room air):\nMild:     60–79 mmHg\nModerate: 40–59 mmHg\nSevere:   <40 mmHg'),
        ];
        break;
      case 'dd':
        title = 'Delta-Delta Ratio';
        final ddC = _clsColor(r.ddCls);
        content = [
          _formulaBox('Delta-Delta = (AG − 12) / (24 − HCO₃) = (${r.ag} − 12) / (24 − ${r.hco3.toInt()}) = ${r.ddText?.split(' — ').first ?? ''}'),
          _pill(ddC, ddC.withValues(alpha:.12), r.ddText ?? ''),
        ];
        break;
      case 'ag':
        title = 'Anion Gap — How It Works';
        content = [
          _formulaBox('AG = Na⁺ − (Cl⁻ + HCO₃⁻)        Normal: 8–12 mEq/L\nCorrected AG = AG + 2.5 × (4.0 − albumin)\nAlways correct for albumin — low albumin falsely lowers AG'),
          _bodyText('The AG detects unmeasured anions. A normal AG acidosis means acid gained = base lost (e.g. diarrhoea). An elevated AG means an unmeasured acid has accumulated in the blood.'),
        ];
        break;
      default:
        return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.only(top:4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface, border: Border.all(color:Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color:_cyan, fontSize:11.5, fontWeight:FontWeight.bold)),
          const SizedBox(height:6),
          ...content,
        ],
      ),
    );
  }

  // ── Disclaimer ───────────────────────────────────────────────────────────────
  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _amberD, border: Border.all(color:_amber.withValues(alpha:.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        '⚠️ Clinical decision support only · Always correlate with patient context\n'
        'Normal: pH 7.35–7.45 · PCO₂ 35–45 · HCO₃ 22–26 · BE −2 to +2 · PaO₂ 80–100',
        style: TextStyle(color:_amber, fontSize:11.5, height:1.5),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────
  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, border: Border.all(color:Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  Widget _bodyText(String t, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom:4),
      child: Text(t, style: TextStyle(color:color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize:12, height:1.5)),
    );
  }

  Widget _subHead(String t) {
    return Padding(
      padding: const EdgeInsets.only(top:6, bottom:2),
      child: Text(t, style: TextStyle(color:Theme.of(context).colorScheme.onSurface, fontSize:12, fontWeight:FontWeight.bold)),
    );
  }

  Widget _bullet(String t) {
    return Padding(
      padding: const EdgeInsets.only(left:10, bottom:3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize:12)),
          Expanded(child: Text(t, style: TextStyle(color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize:12, height:1.4))),
        ],
      ),
    );
  }

  Widget _pill(Color textC, Color bgC, String t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:10, vertical:6),
      decoration: BoxDecoration(
        color: bgC, borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textC.withValues(alpha:.3)),
      ),
      child: Text(t, style: TextStyle(color:textC, fontSize:11.5, height:1.4)),
    );
  }

  Widget _formulaBox(String t) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical:4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(6),
        border: Border.all(color:Theme.of(context).colorScheme.outline),
      ),
      child: Text(t, style: TextStyle(color:Theme.of(context).colorScheme.onSurface, fontSize:11.5, fontFamily:'monospace', height:1.6)),
    );
  }

  Widget _valueRow(String label, String val, String unit, Color c, String desc) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal:8, vertical:4),
          decoration: BoxDecoration(
            color: c.withValues(alpha:.12), border: Border.all(color:c.withValues(alpha:.4)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text('$label $val $unit', style: TextStyle(color:c, fontSize:12, fontWeight:FontWeight.bold)),
        ),
        const SizedBox(width:8),
        Expanded(child: Text(desc, style: TextStyle(color:c, fontSize:12))),
      ],
    );
  }
}

// ── Extension for step 1 sub ──────────────────────────────────────────────────
extension _BgResultExt on _BgResult {
  String phSts(double ph) =>
      ph < 7.35 ? 'acidosis' : ph > 7.45 ? 'alkalosis' : 'normal';
}

// ── Gradient slider ───────────────────────────────────────────────────────────
class _GradientSlider extends StatelessWidget {
  final double value, min, max, step;
  final List<Color> gradColors;
  final double loFrac, hiFrac;
  final ValueChanged<double> onChanged;

  const _GradientSlider({
    required this.value, required this.min, required this.max,
    required this.gradColors, required this.loFrac, required this.hiFrac,
    required this.step, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 8,
        thumbColor: Colors.white,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
        activeTrackColor: Colors.transparent,
        inactiveTrackColor: Colors.transparent,
        trackShape: _GradTrackShape(gradColors:gradColors, loFrac:loFrac, hiFrac:hiFrac),
      ),
      child: Slider(
        value: value.clamp(min, max),
        min: min,
        max: max,
        divisions: ((max - min) / step).round(),
        onChanged: onChanged,
      ),
    );
  }
}

class _GradTrackShape extends SliderTrackShape {
  final List<Color> gradColors;
  final double loFrac, hiFrac;
  const _GradTrackShape({required this.gradColors, required this.loFrac, required this.hiFrac});

  @override
  Rect getPreferredRect({required RenderBox parentBox, Offset offset = Offset.zero,
      required SliderThemeData sliderTheme, bool isEnabled = true, bool isDiscrete = false}) {
    final height = sliderTheme.trackHeight ?? 8;
    final top    = offset.dy + (parentBox.size.height - height) / 2;
    return Rect.fromLTWH(offset.dx + 12, top, parentBox.size.width - 24, height);
  }

  @override
  void paint(PaintingContext context, Offset offset,
      {required RenderBox parentBox, required SliderThemeData sliderTheme,
       required Animation<double> enableAnimation, required Offset thumbCenter,
       Offset? secondaryOffset, bool isEnabled = true, bool isDiscrete = false,
       required TextDirection textDirection}) {
    final rect = getPreferredRect(parentBox: parentBox, offset: offset, sliderTheme: sliderTheme);
    final canvas = context.canvas;
    final rr = RRect.fromRectAndRadius(rect, const Radius.circular(4));

    // Gradient background
    final gradPaint = Paint()
      ..shader = LinearGradient(colors: gradColors)
          .createShader(rect);
    canvas.drawRRect(rr, gradPaint);

    // Normal zone highlight
    final loPx  = rect.left + loFrac * rect.width;
    final hiPx  = rect.left + hiFrac * rect.width;
    final normalRect = Rect.fromLTRB(loPx, rect.top, hiPx, rect.bottom);
    final normalPaint = Paint()
      ..color = _green.withValues(alpha: .35)
      ..blendMode = BlendMode.srcOver;
    canvas.drawRect(normalRect, normalPaint);
  }
}

// ── Cyan toggle switch ────────────────────────────────────────────────────────
class _CyanSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _CyanSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44, height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: value ? _cyan.withValues(alpha:.3) : Theme.of(context).colorScheme.surface,
          border: Border.all(color: value ? _cyan : Theme.of(context).colorScheme.outline),
          boxShadow: value ? [BoxShadow(color: _cyan.withValues(alpha:.4), blurRadius:6)] : [],
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18, height: 18,
            margin: const EdgeInsets.symmetric(horizontal:3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? _cyan : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}
