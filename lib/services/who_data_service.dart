import 'package:flutter/services.dart';
import 'package:excel/excel.dart';

// ── Data models ───────────────────────────────────────────────────────────────

class WhoPercentilePoint {
  final double day;
  final double l, m, s;
  final double p3, p5, p10, p15, p25, p50, p75, p85, p90, p95, p97;

  const WhoPercentilePoint({
    required this.day,
    required this.l,
    required this.m,
    required this.s,
    required this.p3,
    required this.p5,
    required this.p10,
    required this.p15,
    required this.p25,
    required this.p50,
    required this.p75,
    required this.p85,
    required this.p90,
    required this.p95,
    required this.p97,
  });
}

class WhoZScorePoint {
  final double day;
  final double l, m, s;
  final double sd3neg, sd2neg, sd1neg, sd0, sd1, sd2, sd3;

  const WhoZScorePoint({
    required this.day,
    required this.l,
    required this.m,
    required this.s,
    required this.sd3neg,
    required this.sd2neg,
    required this.sd1neg,
    required this.sd0,
    required this.sd1,
    required this.sd2,
    required this.sd3,
  });
}

// ── Service ───────────────────────────────────────────────────────────────────

class WhoDataService {
  static final WhoDataService instance = WhoDataService._();
  WhoDataService._();

  final Map<String, List<WhoPercentilePoint>> _percentileCache = {};
  final Map<String, List<WhoZScorePoint>> _zscoreCache = {};

  /// Load percentile data for [chartType] and [gender].
  /// File: assets/data/who/{chartType}-{gender}-percentiles-expanded-tables.xlsx
  /// Column indices: 0=Age, 1=L, 2=M, 3=S, 4=P01(skip), 5=P1(skip),
  ///   6=P3, 7=P5, 8=P10, 9=P15, 10=P25, 11=P50, 12=P75, 13=P85,
  ///   14=P90, 15=P95, 16=P97, 17=P99(skip), 18=P999(skip)
  Future<List<WhoPercentilePoint>> loadPercentileData(
      String chartType, String gender) async {
    final key = '$chartType-$gender';
    if (_percentileCache.containsKey(key)) return _percentileCache[key]!;

    final path =
        'assets/data/who/$chartType-$gender-percentiles-expanded-tables.xlsx';
    final byteData = await rootBundle.load(path);
    final excel = Excel.decodeBytes(byteData.buffer.asUint8List());
    final sheet = excel.tables.values.first;

    final points = <WhoPercentilePoint>[];
    for (int i = 1; i < sheet.maxRows; i++) {
      final row = sheet.row(i);
      if (row.length < 17) continue;
      final dayCell = row[0];
      if (dayCell == null) continue;
      final day = _toDouble(dayCell);
      if (day == 0 && i > 1) continue; // skip empty trailing rows
      points.add(WhoPercentilePoint(
        day: day,
        l:   _toDouble(row[1]),
        m:   _toDouble(row[2]),
        s:   _toDouble(row[3]),
        // index 4=P01, 5=P1 — skipped
        p3:  _toDouble(row[6]),
        p5:  _toDouble(row[7]),
        p10: _toDouble(row[8]),
        p15: _toDouble(row[9]),
        p25: _toDouble(row[10]),
        p50: _toDouble(row[11]),
        p75: _toDouble(row[12]),
        p85: _toDouble(row[13]),
        p90: _toDouble(row[14]),
        p95: _toDouble(row[15]),
        p97: _toDouble(row[16]),
      ));
    }

    _percentileCache[key] = points;
    return points;
  }

  /// Load z-score data for [chartType] and [gender].
  /// File: assets/data/who/{chartType}-{gender}-zscore-expanded-tables.xlsx
  /// Column indices: 0=Day, 1=L, 2=M, 3=S, 4=SD4neg(skip), 5=SD3neg,
  ///   6=SD2neg, 7=SD1neg, 8=SD0, 9=SD1, 10=SD2, 11=SD3, 12=SD4(skip)
  Future<List<WhoZScorePoint>> loadZScoreData(
      String chartType, String gender) async {
    final key = '$chartType-$gender';
    if (_zscoreCache.containsKey(key)) return _zscoreCache[key]!;

    // Some WHO files were shipped without the trailing 's' on "table"
    final suffix = (chartType == 'wfl' || chartType == 'ssfa')
        ? 'zscore-expanded-table.xlsx'
        : 'zscore-expanded-tables.xlsx';
    final path = 'assets/data/who/$chartType-$gender-$suffix';
    final byteData = await rootBundle.load(path);
    final excel = Excel.decodeBytes(byteData.buffer.asUint8List());
    final sheet = excel.tables.values.first;

    final points = <WhoZScorePoint>[];
    for (int i = 1; i < sheet.maxRows; i++) {
      final row = sheet.row(i);
      if (row.length < 12) continue;
      final dayCell = row[0];
      if (dayCell == null) continue;
      final day = _toDouble(dayCell);
      if (day == 0 && i > 1) continue;
      points.add(WhoZScorePoint(
        day:    day,
        l:      _toDouble(row[1]),
        m:      _toDouble(row[2]),
        s:      _toDouble(row[3]),
        // index 4=SD4neg — skipped
        sd3neg: _toDouble(row[5]),
        sd2neg: _toDouble(row[6]),
        sd1neg: _toDouble(row[7]),
        sd0:    _toDouble(row[8]),
        sd1:    _toDouble(row[9]),
        sd2:    _toDouble(row[10]),
        sd3:    _toDouble(row[11]),
        // index 12=SD4 — skipped
      ));
    }

    _zscoreCache[key] = points;
    return points;
  }

  // ── Internal helpers ─────────────────────────────────────────────────────────

  double _toDouble(Data? cell) {
    final v = cell?.value;
    if (v is IntCellValue)    return v.value.toDouble();
    if (v is DoubleCellValue) return v.value;
    if (v is TextCellValue)   return double.tryParse(v.value.text ?? '') ?? 0;
    return 0;
  }
}
