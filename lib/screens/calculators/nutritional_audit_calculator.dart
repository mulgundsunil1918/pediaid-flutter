import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'html_download_stub.dart'
    if (dart.library.html) 'html_download_web.dart';

const Color _green  = Color(0xFF2e7d32);
const Color _orange = Color(0xFFe65100);
const Color _red    = Color(0xFFc62828);

// ── Nutrient bag ───────────────────────────────────────────────────────────────

class _N {
  final double protein, fat, carbs, calcium, phosphorus, iron, vitD, calories;
  const _N({
    this.protein = 0, this.fat = 0, this.carbs = 0, this.calcium = 0,
    this.phosphorus = 0, this.iron = 0, this.vitD = 0, this.calories = 0,
  });
  static const zero = _N();
  _N operator +(_N o) => _N(
    protein: protein + o.protein, fat: fat + o.fat, carbs: carbs + o.carbs,
    calcium: calcium + o.calcium, phosphorus: phosphorus + o.phosphorus,
    iron: iron + o.iron, vitD: vitD + o.vitD, calories: calories + o.calories,
  );
  _N scale(double k) => _N(
    protein: protein * k, fat: fat * k, carbs: carbs * k, calcium: calcium * k,
    phosphorus: phosphorus * k, iron: iron * k, vitD: vitD * k, calories: calories * k,
  );
}

// ── Custom item ────────────────────────────────────────────────────────────────

class _CustomItem {
  final String name;
  final double amount;
  final _N composition;
  _CustomItem({required this.name, required this.amount, required this.composition});
}

// ── Item type ──────────────────────────────────────────────────────────────────

enum _ItemType { formula, fortification, supplement }

String _typeLabel(_ItemType t) => switch (t) {
  _ItemType.formula       => 'Formula',
  _ItemType.fortification => 'Fortification',
  _ItemType.supplement    => 'Supplement',
};

String _amountLabel(_ItemType t) => switch (t) {
  _ItemType.formula       => 'Volume (ml/day)',
  _ItemType.supplement    => 'Volume (ml/day)',
  _ItemType.fortification => 'Number of Sachets/day',
};

// ── Compositions: feeds per 100 ml ────────────────────────────────────────────

const _cEbm  = _N(protein:1.1,  fat:3.4,  carbs:7.4,  calcium:35,   phosphorus:15,    iron:0.2,  vitD:0,     calories:67);
const _cTf   = _N(protein:1.49, fat:3.28, carbs:8.05, calcium:54,   phosphorus:33.75, iron:0.55, vitD:0.95,  calories:66.3);
const _cPtf  = _N(protein:2.67, fat:3.89, carbs:8.72, calcium:102,  phosphorus:51,    iron:1.62, vitD:116.8, calories:78.9);
const _cNeo  = _N(protein:1.8,  fat:3.5,  carbs:7.1,  calcium:77.1, phosphorus:50.2,  iron:1,    vitD:64,    calories:67);

// ── Compositions: fortifications per sachet ───────────────────────────────────

const _cHmfL  = _N(protein:0.27, fat:0.04, carbs:0.49, calcium:15,   phosphorus:7.8,  iron:0.3, vitD:132, calories:3.27);
const _cHmfA  = _N(protein:0.35, fat:0.18, carbs:0.24, calcium:20,   phosphorus:10,   iron:0,   vitD:50,  calories:4.5);
const _cMmfN  = _N(protein:0.12, fat:0.02, carbs:0.78, calcium:2.51, phosphorus:1.77, iron:0,   vitD:0,   calories:3.5);
const _cNeoPF = _N(protein:0.75, fat:0,    carbs:0,    calcium:0,    phosphorus:0,    iron:0,   vitD:0,   calories:4);

// ── Compositions: supplements per ml ─────────────────────────────────────────

const _cMct      = _N(fat:0.945, calories:7.8);
const _cCalcimax = _N(calcium:30, phosphorus:15, vitD:20);
// Orofer: iron = orofer_ml * 10 * 0.1  (handled inline)

// ── ESPGHAN 2022 guidelines (per kg/day) ──────────────────────────────────────

class _GL {
  final String name, unit;
  final double min, max;
  final double Function(_N) get;
  _GL({required this.name, required this.unit, required this.min, required this.max, required this.get});
}

final _gls = <_GL>[
  _GL(name:'Protein',      unit:'g',    min:3.5,  max:4.0,  get:(n)=>n.protein),
  _GL(name:'Fat',          unit:'g',    min:4.8,  max:8.1,  get:(n)=>n.fat),
  _GL(name:'Carbohydrate', unit:'g',    min:11,   max:15,   get:(n)=>n.carbs),
  _GL(name:'Calcium',      unit:'mg',   min:120,  max:200,  get:(n)=>n.calcium),
  _GL(name:'Phosphorus',   unit:'mg',   min:66,   max:110,  get:(n)=>n.phosphorus),
  _GL(name:'Iron',         unit:'mg',   min:2,    max:3,    get:(n)=>n.iron),
  _GL(name:'Vitamin D',    unit:'IU',   min:400,  max:700,  get:(n)=>n.vitD),
  _GL(name:'Calories',     unit:'kcal', min:115,  max:140,  get:(n)=>n.calories),
];

// ── Result row ────────────────────────────────────────────────────────────────

class _NRow {
  final String name, unit;
  final double total, perKg, min, max;
  _NRow({required this.name, required this.unit, required this.total,
         required this.perKg, required this.min, required this.max});
  String   get status => perKg < min ? 'deficit' : perKg > max ? 'excessive' : 'sufficient';
  Color    get color  => status == 'deficit' ? _orange : status == 'excessive' ? _red : _green;
  IconData get icon   => status == 'deficit'
      ? Icons.error_outline
      : status == 'excessive'
          ? Icons.cancel_outlined
          : Icons.check_circle_outline;
}

// ── Calculation snapshot ──────────────────────────────────────────────────────

class _Snap {
  final double weight, totalVolume;
  final List<_NRow> rows;
  final double ebmVol, tfVol, ptfVol, neoVol;
  final double hmfLSach, hmfASach, mmfNSach, neoPFSach;
  final double mctMl, calcimaxMl, oroferMl;
  final List<_CustomItem> cf, cfo, cs;
  _Snap({
    required this.weight, required this.totalVolume, required this.rows,
    required this.ebmVol, required this.tfVol, required this.ptfVol, required this.neoVol,
    required this.hmfLSach, required this.hmfASach, required this.mmfNSach, required this.neoPFSach,
    required this.mctMl, required this.calcimaxMl, required this.oroferMl,
    required this.cf, required this.cfo, required this.cs,
  });
}

// ── Reference table data ──────────────────────────────────────────────────────

const _refHeaders = [
  'Product', 'Protein\n(g)', 'Fat\n(g)', 'Carbs\n(g)',
  'Calcium\n(mg)', 'Phosphorus\n(mg)', 'Iron\n(mg)', 'Vit D\n(IU)', 'Calories\n(kcal)',
];

const _refData = [
  ['EBM (100ml Preterm)',      '1.1',  '3.4',   '7.4',  '35',   '15',    '0.2',  '0',     '67'],
  ['HMF L (1gm sachet)',       '0.27', '0.04',  '0.49', '15',   '7.8',   '0.3',  '132',   '3.27'],
  ['HMF A (1gm sachet)',       '0.35', '0.18',  '0.24', '20',   '10',    '0',    '50',    '4.5'],
  ['MMF N (1gm sachet)',       '0.12', '0.02',  '0.78', '2.51', '1.77',  '0',    '0',     '3.5'],
  ['PTF-APTAMIL (100ml)',      '2.67', '3.89',  '8.72', '102',  '51',    '1.62', '116.8', '78.9'],
  ['TF-APTAMIL GOLD (100ml)',  '1.49', '3.28',  '8.05', '54',   '33.75', '0.55', '0.95',  '66.3'],
  ['Neocate (100ml)',          '1.8',  '3.5',   '7.1',  '77.1', '50.2',  '1',    '64',    '67'],
  ['Neo PF (1gm sachet)',      '0.75', '-',     '-',    '-',    '-',     '-',    '-',     '4'],
  ['Simyl MCT (1ml)',          '-',    '0.945', '-',    '-',    '-',     '-',    '-',     '7.8'],
  ['Calcimax (1ml)',           '-',    '-',     '-',    '30',   '15',    '-',    '20',    '-'],
  ['Orofer (0.1ml)',           '-',    '-',     '-',    '-',    '-',     '1',    '-',     '-'],
];

const _espghanData = [
  ['Protein (g)',      '3.5', '4'],
  ['Fat (g)',          '4.8', '8.1'],
  ['Carbohydrate (g)', '11',  '15'],
  ['Calcium (mg)',     '120', '200'],
  ['Phosphorus (mg)',  '66',  '110'],
  ['Iron (mg)',        '2',   '3'],
  ['Vitamin D (IU)',   '400', '700'],
  ['Calories (K.Cal)', '115', '140'],
];

const _notes = [
  'All calculations based on actual daily intake and baby\'s weight',
  'Orofer provides 1mg iron per 0.1ml (10mg per ml)',
  'Formula compositions are per 100ml of prepared feed',
  'Fortification compositions are per sachet/packet',
  'Custom items included as per nutritional data entered',
];

// ── Main widget ───────────────────────────────────────────────────────────────

class NutritionalAuditCalculator extends StatefulWidget {
  const NutritionalAuditCalculator({super.key});
  @override
  State<NutritionalAuditCalculator> createState() => _NAState();
}

class _NAState extends State<NutritionalAuditCalculator> {
  // Weight
  final _wtCtrl = TextEditingController();
  // Feeds
  final _ebmCtrl = TextEditingController();
  final _tfCtrl  = TextEditingController();
  final _ptfCtrl = TextEditingController();
  final _neoCtrl = TextEditingController();
  // Fortifications
  final _hmfLCtrl  = TextEditingController();
  final _hmfACtrl  = TextEditingController();
  final _mmfNCtrl  = TextEditingController();
  final _neoPFCtrl = TextEditingController();
  // Supplements
  final _mctCtrl      = TextEditingController();
  final _calcimaxCtrl = TextEditingController();
  final _oroferCtrl   = TextEditingController();
  // Custom lists
  final _cf  = <_CustomItem>[];
  final _cfo = <_CustomItem>[];
  final _cs  = <_CustomItem>[];

  _Snap? _snap;

  @override
  void dispose() {
    for (final c in [
      _wtCtrl, _ebmCtrl, _tfCtrl, _ptfCtrl, _neoCtrl,
      _hmfLCtrl, _hmfACtrl, _mmfNCtrl, _neoPFCtrl,
      _mctCtrl, _calcimaxCtrl, _oroferCtrl,
    ]) { c.dispose(); }
    super.dispose();
  }

  double _v(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0.0;

  // ── Calculate ───────────────────────────────────────────────────────────────

  void _calculate() {
    final wt = double.tryParse(_wtCtrl.text.trim()) ?? 0;
    if (wt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid baby weight.')));
      return;
    }
    final ebmVol    = _v(_ebmCtrl);
    final tfVol     = _v(_tfCtrl);
    final ptfVol    = _v(_ptfCtrl);
    final neoVol    = _v(_neoCtrl);
    final hmfLSach  = _v(_hmfLCtrl);
    final hmfASach  = _v(_hmfACtrl);
    final mmfNSach  = _v(_mmfNCtrl);
    final neoPFSach = _v(_neoPFCtrl);
    final mctMl     = _v(_mctCtrl);
    final calMl     = _v(_calcimaxCtrl);
    final orMl      = _v(_oroferCtrl);

    _N tot = _N.zero;
    // Feeds — (volume / 100) * per100ml
    tot = tot + _cEbm.scale(ebmVol / 100);
    tot = tot + _cTf.scale(tfVol / 100);
    tot = tot + _cPtf.scale(ptfVol / 100);
    tot = tot + _cNeo.scale(neoVol / 100);
    for (final f in _cf) { tot = tot + f.composition.scale(f.amount / 100); }
    // Fortifications — sachets * perSachet
    tot = tot + _cHmfL.scale(hmfLSach);
    tot = tot + _cHmfA.scale(hmfASach);
    tot = tot + _cMmfN.scale(mmfNSach);
    tot = tot + _cNeoPF.scale(neoPFSach);
    for (final f in _cfo) { tot = tot + f.composition.scale(f.amount); }
    // Supplements
    tot = tot + _cMct.scale(mctMl);
    tot = tot + _cCalcimax.scale(calMl);
    tot = tot + _N(iron: orMl * 10 * 0.1);
    for (final s in _cs) { tot = tot + s.composition.scale(s.amount); }

    final perKg   = tot.scale(1 / wt);
    final totalVol = ebmVol + tfVol + ptfVol + neoVol;
    setState(() {
      _snap = _Snap(
        weight: wt, totalVolume: totalVol,
        rows: _gls.map((g) => _NRow(name: g.name, unit: g.unit,
            total: g.get(tot), perKg: g.get(perKg), min: g.min, max: g.max)).toList(),
        ebmVol: ebmVol, tfVol: tfVol, ptfVol: ptfVol, neoVol: neoVol,
        hmfLSach: hmfLSach, hmfASach: hmfASach, mmfNSach: mmfNSach, neoPFSach: neoPFSach,
        mctMl: mctMl, calcimaxMl: calMl, oroferMl: orMl,
        cf: List.from(_cf), cfo: List.from(_cfo), cs: List.from(_cs),
      );
    });
  }

  // ── Reset ───────────────────────────────────────────────────────────────────

  void _reset() {
    for (final c in [
      _wtCtrl, _ebmCtrl, _tfCtrl, _ptfCtrl, _neoCtrl,
      _hmfLCtrl, _hmfACtrl, _mmfNCtrl, _neoPFCtrl,
      _mctCtrl, _calcimaxCtrl, _oroferCtrl,
    ]) { c.clear(); }
    setState(() { _cf.clear(); _cfo.clear(); _cs.clear(); _snap = null; });
  }

  // ── Add / remove custom items ────────────────────────────────────────────────

  Future<void> _addCustom(_ItemType type) async {
    final item = await showDialog<_CustomItem>(
        context: context, builder: (_) => _CustomItemDialog(type: type));
    if (item == null) return;
    setState(() {
      switch (type) {
        case _ItemType.formula:       _cf.add(item);
        case _ItemType.fortification: _cfo.add(item);
        case _ItemType.supplement:    _cs.add(item);
      }
    });
  }

  void _removeCustom(_ItemType type, int i) {
    setState(() {
      switch (type) {
        case _ItemType.formula:       _cf.removeAt(i);
        case _ItemType.fortification: _cfo.removeAt(i);
        case _ItemType.supplement:    _cs.removeAt(i);
      }
    });
  }

  // ── Export ──────────────────────────────────────────────────────────────────

  void _exportPDF() {
    final s = _snap!;
    final now = DateTime.now();
    final dateStr = '${now.day}-${now.month}-${now.year}';
    final fname = 'Nutritional_Audit_${s.weight}kg_$dateStr.html';
    final content = _buildHtml(s, dateStr);

    if (kIsWeb) {
      downloadHtml(content, fname);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Report Downloaded'),
          content: const Text(
              'Report downloaded! Open the HTML file in your browser '
              'and use Print > Save as PDF to create a PDF document.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Export Report'),
          content: Text(
            'Report generated for ${s.weight} kg patient ($dateStr).\n\n'
            'HTML export is available in the web version.',
            style: const TextStyle(fontSize: 13),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
    }
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Nutritional Audit'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Section 1: Weight
            _card(_weightSection()),
            const SizedBox(height: 16),
            // ── Section 2: Feeds
            _card(_feedsSection()),
            const SizedBox(height: 16),
            // ── Section 3: Fortifications
            _card(_fortSection()),
            const SizedBox(height: 16),
            // ── Section 4: Supplements
            _card(_suppSection()),
            const SizedBox(height: 20),
            // ── Section 5: Calculate + Clear buttons
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Clear / Reset'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    side: BorderSide(color: Theme.of(context).colorScheme.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _calculate,
                  icon: const Icon(Icons.calculate, size: 20),
                  label: const Text('Calculate Nutrition',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ]),
            // ── Section 6: Results
            if (_snap != null) ...[
              const SizedBox(height: 24),
              _resultsSection(_snap!),
            ],
            // ── Section 7: Reference tables (always visible)
            const SizedBox(height: 24),
            _refSection(),
            // ── Section 10: Footer
            const SizedBox(height: 20),
            _footerWidget(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Section builders
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _weightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _secHeader('Baby Weight', Icons.monitor_weight_outlined),
        const SizedBox(height: 14),
        _numField(_wtCtrl, 'Baby Weight (kg)', 'kg', hint: '0.000'),
      ],
    );
  }

  Widget _feedsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Expanded(child: _secHeader('Daily Feed Volume (ml/day)', Icons.water_drop_outlined)),
          _addBtn('+ Add Custom Formula', () => _addCustom(_ItemType.formula)),
        ]),
        const SizedBox(height: 14),
        _numField(_ebmCtrl,  'EBM (Expressed Breast Milk)',      'ml/day', hint: 'ml/day'),
        _numField(_tfCtrl,   'TF (Aptamil Gold - Term Formula)', 'ml/day', hint: 'ml/day'),
        _numField(_ptfCtrl,  'PTF (Aptamil - Preterm Formula)',  'ml/day', hint: 'ml/day'),
        _numField(_neoCtrl,  'Neocate Formula',                  'ml/day', hint: 'ml/day'),
        ..._cf.asMap().entries.map((e) =>
            _customRow(e.value, () => _removeCustom(_ItemType.formula, e.key))),
      ],
    );
  }

  Widget _fortSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Expanded(child: _secHeader('Fortifications (per day)', Icons.add_circle_outline)),
          _addBtn('+ Add Custom Fortification', () => _addCustom(_ItemType.fortification)),
        ]),
        const SizedBox(height: 14),
        _numField(_hmfLCtrl,  'HMF L - Lactodex (sachets)',  'sachets'),
        _numField(_hmfACtrl,  'HMF A - Advanced (sachets)',  'sachets'),
        _numField(_mmfNCtrl,  'MMF N - Neolacta (sachets)',  'sachets'),
        _numField(_neoPFCtrl, 'Neo PF (sachets)',             'sachets'),
        ..._cfo.asMap().entries.map((e) =>
            _customRow(e.value, () => _removeCustom(_ItemType.fortification, e.key))),
      ],
    );
  }

  Widget _suppSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Expanded(child: _secHeader('Supplements', Icons.medication_outlined)),
          _addBtn('+ Add Custom Supplement', () => _addCustom(_ItemType.supplement)),
        ]),
        const SizedBox(height: 14),
        _numField(_mctCtrl,      'Simyl MCT Oil (ml)',               'ml/day', hint: 'ml/day'),
        _numField(_calcimaxCtrl, 'Calcimax (ml)',                    'ml/day', hint: 'ml/day'),
        _numField(_oroferCtrl,   'Orofer (ml) - Iron 1mg per 0.1ml','ml/day', hint: 'ml/day'),
        ..._cs.asMap().entries.map((e) =>
            _customRow(e.value, () => _removeCustom(_ItemType.supplement, e.key))),
      ],
    );
  }

  // ── Section 6: Results ───────────────────────────────────────────────────────

  Widget _resultsSection(_Snap s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title + Export button
        Row(
          children: [
            Expanded(
              child: Text('Nutritional Assessment',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
            ),
            ElevatedButton.icon(
              onPressed: _exportPDF,
              icon: const Icon(Icons.download, size: 16),
              label: const Text('Export to PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Summary card
        _card(Wrap(
          spacing: 24, runSpacing: 8,
          children: [
            _summaryItem('Baby Weight', '${s.weight} kg'),
            _summaryItem('Total Feed Volume', '${s.totalVolume.toStringAsFixed(1)} ml/day'),
            if (s.cf.isNotEmpty)  _summaryItem('Custom Formulas', '${s.cf.length}'),
            if (s.cfo.isNotEmpty) _summaryItem('Custom Fortifications', '${s.cfo.length}'),
            if (s.cs.isNotEmpty)  _summaryItem('Custom Supplements', '${s.cs.length}'),
          ],
        )),
        const SizedBox(height: 12),
        // Results table card
        _card(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _resultsTable(s),
            ),
            const SizedBox(height: 16),
            Wrap(spacing: 16, runSpacing: 8, children: [
              _legendItem(Icons.check_circle_outline, _green,
                  'Sufficient - Within ESPGHAN 2022 guidelines'),
              _legendItem(Icons.error_outline, _orange,
                  'Deficit - Below recommended range'),
              _legendItem(Icons.cancel_outlined, _red,
                  'Excessive - Above recommended range'),
            ]),
          ],
        )),
      ],
    );
  }

  Widget _resultsTable(_Snap s) {
    const cw = [150.0, 110.0, 115.0, 150.0, 80.0];
    const headers = ['Nutrient', 'Total/Day', 'Per kg/Day', 'ESPGHAN Range', 'Status'];
    return Column(
      children: [
        // Header row
        Row(children: List.generate(5, (i) => Container(
          width: cw[i],
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          child: Text(headers[i],
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary)),
        ))),
        // Data rows
        ...s.rows.asMap().entries.map((e) {
          final r  = e.value;
          final bg = e.key.isEven ? Theme.of(context).cardColor : Theme.of(context).colorScheme.surface;
          String fmt(double v) => v < 10 ? v.toStringAsFixed(2) : v.toStringAsFixed(1);
          return Row(children: [
            _tCell('${r.name} (${r.unit})', cw[0], bg, bold: true),
            _tCell('${fmt(r.total)} ${r.unit}', cw[1], bg),
            _tCell('${fmt(r.perKg)} ${r.unit}', cw[2], bg, color: r.color, bold: true),
            _tCell('${r.min}–${r.max} ${r.unit}', cw[3], bg),
            SizedBox(width: cw[4], child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              color: bg,
              child: Icon(r.icon, color: r.color, size: 22),
            )),
          ]);
        }),
      ],
    );
  }

  Widget _tCell(String text, double w, Color bg, {Color? color, bool bold = false}) {
    return SizedBox(width: w, child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      color: bg,
      child: Text(text, style: TextStyle(
          fontSize: 12,
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          color: color ?? Theme.of(context).colorScheme.onSurface)),
    ));
  }

  Widget _summaryItem(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
      Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
    ]);
  }

  Widget _legendItem(IconData icon, Color color, String text) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: color, size: 16),
      const SizedBox(width: 4),
      Text(text, style: const TextStyle(fontSize: 11)),
    ]);
  }

  // ── Section 7: Reference tables ──────────────────────────────────────────────

  Widget _refSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Reference: Nutritional Composition Table',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
        const SizedBox(height: 12),
        _card(SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _buildRefTable(),
        )),
        const SizedBox(height: 16),
        _card(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ESPGHAN 2022 Guidelines',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 10),
            _buildEspghanTable(),
          ],
        )),
        const SizedBox(height: 16),
        _notesBox(),
      ],
    );
  }

  Widget _buildRefTable() {
    const cw = [170.0, 72.0, 72.0, 72.0, 90.0, 105.0, 72.0, 72.0, 90.0];
    return Column(children: [
      Row(children: List.generate(_refHeaders.length, (i) => Container(
        width: cw[i],
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        child: Text(_refHeaders[i],
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary),
            textAlign: TextAlign.center),
      ))),
      ..._refData.asMap().entries.map((e) {
        final bg = e.key.isEven ? Theme.of(context).cardColor : Theme.of(context).colorScheme.surface;
        return Row(children: List.generate(_refHeaders.length, (i) => Container(
          width: cw[i],
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
          color: bg,
          child: Text(e.value[i], style: TextStyle(
              fontSize: 11,
              fontWeight: i == 0 ? FontWeight.w600 : FontWeight.normal),
              textAlign: i == 0 ? TextAlign.left : TextAlign.center),
        )));
      }),
    ]);
  }

  Widget _buildEspghanTable() {
    return Column(children: [
      Container(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08), child: Row(children: [
        Expanded(flex: 4, child: _eCell('Nutrient (per kg per day)', header: true)),
        Expanded(flex: 2, child: _eCell('Lower Limit', header: true)),
        Expanded(flex: 2, child: _eCell('Upper Limit', header: true)),
      ])),
      ..._espghanData.asMap().entries.map((e) {
        final bg = e.key.isEven ? Theme.of(context).cardColor : Theme.of(context).colorScheme.surface;
        return Container(color: bg, child: Row(children: [
          Expanded(flex: 4, child: _eCell(e.value[0], bold: true)),
          Expanded(flex: 2, child: _eCell(e.value[1])),
          Expanded(flex: 2, child: _eCell(e.value[2])),
        ]));
      }),
    ]);
  }

  Widget _eCell(String t, {bool header = false, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(t, style: TextStyle(
          fontSize: 12,
          fontWeight: (header || bold) ? FontWeight.w700 : FontWeight.normal,
          color: header ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface)),
    );
  }

  Widget _notesBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.info_outline, color: Colors.amber, size: 18),
          SizedBox(width: 8),
          Text('Important Notes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ]),
        const SizedBox(height: 8),
        ..._notes.map((n) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('• ', style: TextStyle(fontSize: 12)),
            Expanded(child: Text(n, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface))),
          ]),
        )),
      ]),
    );
  }

  // ── Section 10: Footer ───────────────────────────────────────────────────────

  Widget _footerWidget() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(children: [
        Text('Prepared by: Dr. Sunil Mulgund',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
        const SizedBox(height: 4),
        Text('Based on ESPGHAN 2022 Guidelines for Preterm Infant Nutrition',
            style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
            textAlign: TextAlign.center),
      ]),
    );
  }

  // ── Shared UI helpers ────────────────────────────────────────────────────────

  Widget _card(Widget child) => Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(padding: const EdgeInsets.all(16), child: child),
  );

  Widget _secHeader(String title, IconData icon) => Row(children: [
    Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 18),
    ),
    const SizedBox(width: 10),
    Expanded(child: Text(title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).colorScheme.primary))),
  ]);

  Widget _numField(TextEditingController ctrl, String label, String suffix,
      {String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixText: suffix,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)),
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 13),
          floatingLabelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }

  Widget _addBtn(String label, VoidCallback onTap) => TextButton.icon(
    onPressed: onTap,
    icon: const Icon(Icons.add, size: 16),
    label: Text(label, style: const TextStyle(fontSize: 12)),
    style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary),
  );

  Widget _customRow(_CustomItem item, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Row(children: [
        Icon(Icons.fiber_manual_record, color: Theme.of(context).colorScheme.primary, size: 8),
        const SizedBox(width: 8),
        Expanded(child: Text(
            '${item.name}  —  ${item.amount.toStringAsFixed(1)}',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.primary))),
        GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, color: _red, size: 18)),
      ]),
    );
  }

  // ── HTML report builder ──────────────────────────────────────────────────────

  String _buildHtml(_Snap s, String dateStr) {
    String fmt(double v) => v < 10 ? v.toStringAsFixed(2) : v.toStringAsFixed(1);

    final assessRows = s.rows.map((r) {
      final sc = r.status == 'sufficient' ? 'green' : r.status == 'deficit' ? 'orange' : 'red';
      return '<tr>'
          '<td>${r.name} (${r.unit})</td>'
          '<td>${fmt(r.total)} ${r.unit}</td>'
          '<td>${fmt(r.perKg)} ${r.unit}</td>'
          '<td>${r.min}–${r.max} ${r.unit}</td>'
          '<td style="color:$sc;font-weight:bold">${r.status.toUpperCase()}</td>'
          '</tr>';
    }).join('\n');

    String feedsHtml = '';
    if (s.ebmVol > 0)    feedsHtml += '<div>EBM: ${s.ebmVol} ml/day</div>';
    if (s.tfVol > 0)     feedsHtml += '<div>TF Aptamil Gold: ${s.tfVol} ml/day</div>';
    if (s.ptfVol > 0)    feedsHtml += '<div>PTF Aptamil: ${s.ptfVol} ml/day</div>';
    if (s.neoVol > 0)    feedsHtml += '<div>Neocate: ${s.neoVol} ml/day</div>';
    for (final f in s.cf) { feedsHtml += '<div>${f.name} (Custom): ${f.amount} ml/day</div>'; }
    if (feedsHtml.isEmpty) feedsHtml = '<div style="color:#999">None entered</div>';

    String fortHtml = '';
    if (s.hmfLSach > 0)  fortHtml += '<div>HMF Lactodex: ${s.hmfLSach} sachets</div>';
    if (s.hmfASach > 0)  fortHtml += '<div>HMF Advanced: ${s.hmfASach} sachets</div>';
    if (s.mmfNSach > 0)  fortHtml += '<div>MMF Neolacta: ${s.mmfNSach} sachets</div>';
    if (s.neoPFSach > 0) fortHtml += '<div>Neo PF: ${s.neoPFSach} sachets</div>';
    for (final f in s.cfo) { fortHtml += '<div>${f.name} (Custom): ${f.amount} sachets</div>'; }
    if (fortHtml.isEmpty) fortHtml = '<div style="color:#999">None entered</div>';

    String suppHtml = '';
    if (s.mctMl > 0)      suppHtml += '<div>Simyl MCT: ${s.mctMl} ml/day</div>';
    if (s.calcimaxMl > 0) suppHtml += '<div>Calcimax: ${s.calcimaxMl} ml/day</div>';
    if (s.oroferMl > 0)   suppHtml += '<div>Orofer: ${s.oroferMl} ml/day</div>';
    for (final s2 in s.cs) { suppHtml += '<div>${s2.name} (Custom): ${s2.amount} ml/day</div>'; }
    if (suppHtml.isEmpty) suppHtml = '<div style="color:#999">None entered</div>';

    final refRowsHtml = _refData.map((r) =>
        '<tr>${r.map((c) => '<td>$c</td>').join()}</tr>').join('\n');
    final espRowsHtml = _espghanData.map((r) =>
        '<tr>${r.map((c) => '<td>$c</td>').join()}</tr>').join('\n');
    final notesHtml = _notes.map((n) => '<li>$n</li>').join('\n');
    final footer1 = '''
      <div class="footer">
        <strong>Prepared by: Dr. Sunil Mulgund</strong><br>
        Based on ESPGHAN 2022 Guidelines for Preterm Infant Nutrition<br>
        Email: mulgundsunil@gmail.com
      </div>''';
    final footer2 = '''
      <div class="footer">
        <strong>Prepared by: Dr. Sunil Mulgund</strong><br>
        Based on ESPGHAN 2022 Guidelines for Preterm Infant Nutrition<br>
        Email: mulgundsunil@gmail.com<br>
        <em style="font-size:10px">This is a computer-generated report. For medical decisions, please consult with healthcare professionals.</em>
      </div>''';

    return '''<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Nutritional Audit – ${s.weight}kg – $dateStr</title>
<style>
  body{font-family:Arial,sans-serif;margin:0;padding:20px;font-size:12px;color:#333}
  h1{color:#1a237e;font-size:22px;margin-bottom:2px}
  h2{color:#1a237e;font-size:16px;margin:18px 0 8px}
  h3{color:#1a237e;font-size:13px;margin:10px 0 5px}
  p{color:#555;margin-top:2px}
  table{width:100%;border-collapse:collapse;margin-bottom:14px}
  th{background:#1a237e;color:#fff;padding:8px 10px;text-align:left;font-size:11px}
  td{border:1px solid #ddd;padding:7px 10px;font-size:11px}
  tr:nth-child(even){background:#f8f9fa}
  .header-block{background:#f0f4ff;border:1px solid #c5cae9;padding:12px 16px;border-radius:6px;margin-bottom:16px}
  .grid3{display:grid;grid-template-columns:1fr 1fr 1fr;gap:12px;margin-bottom:16px}
  .box{background:#f8f9fa;border:1px solid #e0e0e0;padding:10px 12px;border-radius:4px}
  .box-title{font-weight:bold;color:#1a237e;margin-bottom:6px;font-size:12px}
  .legend{display:flex;gap:20px;margin-top:10px;flex-wrap:wrap}
  .li{display:flex;align-items:center;gap:5px;font-size:11px}
  .dot{width:10px;height:10px;border-radius:50%;display:inline-block}
  .footer{margin-top:20px;padding-top:10px;border-top:2px solid #1a237e;text-align:center;color:#555;font-size:11px}
  .notes-box{background:#fffde7;border:1px solid #f9a825;padding:12px;border-radius:6px;margin-top:12px}
  @media print{.page-break{page-break-before:always}}
</style>
</head>
<body>
<!-- PAGE 1 – ASSESSMENT -->
<h1>Preterm Baby Nutritional Audit</h1>
<p>ESPGHAN 2022 Guidelines Based Calculator</p>
<div class="header-block">
  <strong>Baby Weight:</strong> ${s.weight} kg &nbsp;&nbsp;
  <strong>Total Feed Volume:</strong> ${s.totalVolume.toStringAsFixed(1)} ml/day &nbsp;&nbsp;
  <strong>Date:</strong> $dateStr
</div>
<div class="grid3">
  <div class="box"><div class="box-title">Feeds</div>$feedsHtml</div>
  <div class="box"><div class="box-title">Fortifications</div>$fortHtml</div>
  <div class="box"><div class="box-title">Supplements</div>$suppHtml</div>
</div>
<h2>Assessment</h2>
<table>
  <thead><tr><th>Nutrient</th><th>Total/Day</th><th>Per kg/Day</th><th>ESPGHAN Range</th><th>Status</th></tr></thead>
  <tbody>$assessRows</tbody>
</table>
<div class="legend">
  <div class="li"><span class="dot" style="background:green"></span> SUFFICIENT – Within ESPGHAN 2022 guidelines</div>
  <div class="li"><span class="dot" style="background:orange"></span> DEFICIT – Below recommended range</div>
  <div class="li"><span class="dot" style="background:red"></span> EXCESSIVE – Above recommended range</div>
</div>
$footer1

<!-- PAGE 2 – REFERENCE -->
<div class="page-break">
<h2>Reference: Nutritional Composition Table</h2>
<table>
  <thead><tr><th>Product</th><th>Protein (g)</th><th>Fat (g)</th><th>Carbs (g)</th><th>Calcium (mg)</th><th>Phosphorus (mg)</th><th>Iron (mg)</th><th>Vit D (IU)</th><th>Calories (kcal)</th></tr></thead>
  <tbody>$refRowsHtml</tbody>
</table>
<h2>ESPGHAN 2022 Guidelines</h2>
<table>
  <thead><tr><th>Nutrient (per kg per day)</th><th>Lower Limit</th><th>Upper Limit</th></tr></thead>
  <tbody>$espRowsHtml</tbody>
</table>
<div class="notes-box">
  <strong>Important Notes:</strong>
  <ul style="margin:8px 0 0;padding-left:18px">$notesHtml</ul>
</div>
$footer2
</div>
</body>
</html>''';
  }
}

// ── Section 8: Custom item dialog ─────────────────────────────────────────────

class _CustomItemDialog extends StatefulWidget {
  final _ItemType type;
  const _CustomItemDialog({required this.type});
  @override
  State<_CustomItemDialog> createState() => _CIDState();
}

class _CIDState extends State<_CustomItemDialog> {
  final _nameCtrl = TextEditingController();
  final _amtCtrl  = TextEditingController();
  final _proCtrl  = TextEditingController();
  final _fatCtrl  = TextEditingController();
  final _carbCtrl = TextEditingController();
  final _caCtrl   = TextEditingController();
  final _pCtrl    = TextEditingController();
  final _feCtrl   = TextEditingController();
  final _vdCtrl   = TextEditingController();
  final _calCtrl  = TextEditingController();

  bool get _canAdd =>
      _nameCtrl.text.trim().isNotEmpty &&
      _amtCtrl.text.trim().isNotEmpty &&
      (double.tryParse(_amtCtrl.text.trim()) ?? 0) > 0;

  @override
  void dispose() {
    for (final c in [
      _nameCtrl, _amtCtrl, _proCtrl, _fatCtrl, _carbCtrl,
      _caCtrl, _pCtrl, _feCtrl, _vdCtrl, _calCtrl,
    ]) { c.dispose(); }
    super.dispose();
  }

  double _p(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0.0;

  void _submit() {
    final name   = _nameCtrl.text.trim();
    final amount = double.tryParse(_amtCtrl.text.trim()) ?? 0;
    if (name.isEmpty || amount <= 0) return;
    Navigator.of(context).pop(_CustomItem(
      name: name, amount: amount,
      composition: _N(
        protein: _p(_proCtrl), fat: _p(_fatCtrl), carbs: _p(_carbCtrl),
        calcium: _p(_caCtrl), phosphorus: _p(_pCtrl),
        iron: _p(_feCtrl), vitD: _p(_vdCtrl), calories: _p(_calCtrl),
      ),
    ));
  }

  Widget _dField(TextEditingController ctrl, String label,
      {bool isText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: isText
            ? TextInputType.text
            : const TextInputType.numberWithOptions(decimal: true),
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          isDense: true,
          labelStyle: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Custom ${_typeLabel(widget.type)}',
          style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dField(_nameCtrl, 'Name *', isText: true),
              _dField(_amtCtrl, '${_amountLabel(widget.type)} *'),
              const Divider(height: 16),
              const Text('Nutritional Composition (per unit)',
                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              _dField(_proCtrl,  'Protein (g)'),
              _dField(_fatCtrl,  'Fat (g)'),
              _dField(_carbCtrl, 'Carbohydrate (g)'),
              _dField(_caCtrl,   'Calcium (mg)'),
              _dField(_pCtrl,    'Phosphorus (mg)'),
              _dField(_feCtrl,   'Iron (mg)'),
              _dField(_vdCtrl,   'Vitamin D (IU)'),
              _dField(_calCtrl,  'Calories (kcal)'),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _canAdd ? _submit : null,
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary),
          child: const Text('Add to Calculation'),
        ),
      ],
    );
  }
}
