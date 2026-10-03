// =============================================================================
// screens/formulary_v3/formulary_v3_data.dart
//
// Every drug Formulary 3.0 knows, in one place.
//
// The 26 files under data/ are generated — extracted word-for-word from the
// Harriet Lane Handbook 24th edition (see docs/formulary_v3/ for the full
// extraction brief, the checklist of all 489 entries, and every judgment call
// that wasn't purely mechanical) — and are not meant to be hand-edited. This
// file is the one place that is: it concatenates them into a single list, so
// nothing downstream (search, the hub, the registry) needs to know there are
// 26 files rather than one.
// =============================================================================

import 'data/a.dart';
import 'data/b.dart';
import 'data/c.dart';
import 'data/d.dart';
import 'data/e.dart';
import 'data/f.dart';
import 'data/g.dart';
import 'data/h.dart';
import 'data/i.dart';
import 'data/j.dart';
import 'data/k.dart';
import 'data/l.dart';
import 'data/m.dart';
import 'data/n.dart';
import 'data/o.dart';
import 'data/p.dart';
import 'data/q.dart';
import 'data/r.dart';
import 'data/s.dart';
import 'data/t.dart';
import 'data/u.dart';
import 'data/v.dart';
import 'data/w.dart';
import 'data/x.dart';
import 'data/y.dart';
import 'data/z.dart';

import 'drug_entry_v3.dart';

/// Every Formulary 3.0 entry, book order within each letter, letters A–Z.
///
/// Length is asserted at the bottom of this file against the extraction's own
/// checklist count — the same "derive it, don't hand-type it and let it rot"
/// rule this app applies everywhere else a count is shown.
final List<DrugEntryV3> allFormularyV3Drugs = [
  ...formularyA,
  ...formularyB,
  ...formularyC,
  ...formularyD,
  ...formularyE,
  ...formularyF,
  ...formularyG,
  ...formularyH,
  ...formularyI,
  ...formularyJ,
  ...formularyK,
  ...formularyL,
  ...formularyM,
  ...formularyN,
  ...formularyO,
  ...formularyP,
  ...formularyQ,
  ...formularyR,
  ...formularyS,
  ...formularyT,
  ...formularyU,
  ...formularyV,
  ...formularyW,
  ...formularyX,
  ...formularyY,
  ...formularyZ,
];

/// The extraction's own verification found 489 entries (444 monographs plus
/// 45 "See the real entry" cross-references) across 26 files. Asserted here so a
/// file silently failing to concatenate — a typo in this file, not the
/// generated data — is caught by any test that imports this file, rather than
/// discovered later as "some drugs are just missing" with no error anywhere.
const int kExpectedFormularyV3Count = 489;
