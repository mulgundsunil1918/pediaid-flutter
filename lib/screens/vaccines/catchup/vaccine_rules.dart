// =============================================================================
// catchup/vaccine_rules.dart — IAP-ACVIP catch-up rule set (DRAFT — VERIFY)
//
// ⚠️ CLINICAL DATA NOTICE: every value below is a DRAFT encoding and MUST be
// checked against the current IAP-ACVIP 2025 publication before clinical use.
// `confidence` marks how sure the encoding is (HIGH/MED/LOW). The engine
// (catchup_engine.dart) is guideline-agnostic — replacing this file updates the
// recommendations. Days are used throughout so date math is exact.
// =============================================================================

import 'catchup_engine.dart';

// Handy day constants.
const int _wk = 7;
const int _mo = 30; // for AGE thresholds only; intervals use exact weeks/days.

const List<VaccineRule> kCatchupRules = [
  VaccineRule(
    id: 'bcg',
    name: 'BCG',
    shortName: 'BCG',
    kind: VaccineKind.live,
    minAgeDays: 0,
    maxInitAgeDays: 12 * _mo, // give up to ~1 year; verify programme rule
    bands: [DoseBand(maxAgeDays: 1 << 30, dosesRequired: 1, intervalsDays: [])],
    route: 'ID',
    notes: 'Single dose. Do not revaccinate merely for absent scar.',
    source: 'IAP schedule', confidence: 'MED',
  ),
  VaccineRule(
    id: 'hepb',
    name: 'Hepatitis B',
    shortName: 'Hep B',
    kind: VaccineKind.inactivated,
    minAgeDays: 0,
    bands: [
      DoseBand(maxAgeDays: 1 << 30, dosesRequired: 3, intervalsDays: [4 * _wk, 8 * _wk]),
    ],
    route: 'IM',
    notes: '0–1–6 month framework. Special neonatal logic for HBsAg+ mother.',
    source: 'IAP schedule', confidence: 'MED',
  ),
  VaccineRule(
    id: 'opv',
    name: 'OPV (oral polio)',
    shortName: 'OPV',
    kind: VaccineKind.inactivated,
    minAgeDays: 0,
    bands: [DoseBand(maxAgeDays: 1 << 30, dosesRequired: 1, intervalsDays: [])],
    route: 'Oral',
    notes: 'Birth (zero) dose. Additional OPV per programme; primary polio via IPV.',
    source: 'IAP schedule', confidence: 'LOW',
  ),
  VaccineRule(
    id: 'ipv',
    name: 'IPV (inactivated polio)',
    shortName: 'IPV',
    kind: VaccineKind.inactivated,
    minAgeDays: 6 * _wk,
    bands: [
      DoseBand(maxAgeDays: 1 << 30, dosesRequired: 3, intervalsDays: [4 * _wk, 4 * _wk]),
    ],
    route: 'IM',
    notes: 'Primary series + boosters per schedule. Continue history; do not restart.',
    source: 'IAP schedule', confidence: 'LOW',
  ),
  VaccineRule(
    id: 'dtp',
    name: 'DTwP / DTaP',
    shortName: 'DTP',
    kind: VaccineKind.inactivated,
    minAgeDays: 6 * _wk,
    maxInitAgeDays: 7 * 365, // ≥7 y → switch to Tdap/Td (see notes)
    bands: [
      DoseBand(maxAgeDays: 1 << 30, dosesRequired: 3, intervalsDays: [4 * _wk, 24 * _wk]),
    ],
    route: 'IM',
    notes:
        'Below 7 y: 0–1–6 mo catch-up primary + boosters. At ≥7 y do NOT continue childhood DTP — use Tdap then Td. Do not restart a valid primary series.',
    source: 'IAP schedule', confidence: 'MED',
  ),
  VaccineRule(
    id: 'tdap',
    name: 'Tdap / Td (≥7 y)',
    shortName: 'Tdap/Td',
    kind: VaccineKind.inactivated,
    minAgeDays: 7 * 365,
    bands: [
      DoseBand(maxAgeDays: 1 << 30, dosesRequired: 3, intervalsDays: [4 * _wk, 24 * _wk]),
    ],
    route: 'IM',
    notes: 'For unimmunised ≥7 y: Tdap → Td → Td. If DTP primary already done, only booster(s) needed.',
    source: 'IAP schedule', confidence: 'LOW',
  ),
  VaccineRule(
    id: 'hib',
    name: 'Hib',
    shortName: 'Hib',
    kind: VaccineKind.inactivated,
    minAgeDays: 6 * _wk,
    maxInitAgeDays: 5 * 365, // healthy children generally not needed ≥5 y
    bands: [
      DoseBand(maxAgeDays: 12 * _mo, dosesRequired: 3, intervalsDays: [4 * _wk, 4 * _wk]),
      DoseBand(maxAgeDays: 15 * _mo, dosesRequired: 2, intervalsDays: [8 * _wk]),
      DoseBand(maxAgeDays: 5 * 365, dosesRequired: 1, intervalsDays: []),
    ],
    route: 'IM',
    notes: 'Age-dependent. High-risk children need separate handling.',
    source: 'IAP schedule', confidence: 'LOW',
  ),
  VaccineRule(
    id: 'pcv',
    name: 'PCV',
    shortName: 'PCV',
    kind: VaccineKind.inactivated,
    minAgeDays: 6 * _wk,
    maxInitAgeDays: 59 * _mo, // healthy children ≥5 y not routine
    bands: [
      DoseBand(maxAgeDays: 7 * _mo, dosesRequired: 3, intervalsDays: [4 * _wk, 4 * _wk]),
      DoseBand(maxAgeDays: 12 * _mo, dosesRequired: 2, intervalsDays: [4 * _wk]),
      DoseBand(maxAgeDays: 24 * _mo, dosesRequired: 2, intervalsDays: [8 * _wk]),
      DoseBand(maxAgeDays: 59 * _mo, dosesRequired: 1, intervalsDays: []),
    ],
    route: 'IM',
    notes: 'Age-banded catch-up. Product (PCV10/13/15) & high-risk rules vary — verify.',
    source: 'IAP schedule', confidence: 'LOW',
  ),
  VaccineRule(
    id: 'rota',
    name: 'Rotavirus',
    shortName: 'Rotavirus',
    kind: VaccineKind.live, // oral live; not counted for parenteral live spacing
    minAgeDays: 6 * _wk,
    maxInitAgeDays: 15 * _wk, // do not START after ~15 weeks
    maxCompleteAgeDays: 8 * _mo, // do not give any dose after ~8 months
    bands: [
      DoseBand(maxAgeDays: 1 << 30, dosesRequired: 3, intervalsDays: [4 * _wk, 4 * _wk]),
    ],
    route: 'Oral',
    notes:
        'STRICT age limits. Never initiate/complete beyond the age window even if doses were missed.',
    source: 'IAP/WHO', confidence: 'MED',
  ),
  VaccineRule(
    id: 'influenza',
    name: 'Influenza',
    shortName: 'Influenza',
    kind: VaccineKind.inactivated,
    minAgeDays: 6 * _mo,
    bands: [
      DoseBand(maxAgeDays: 1 << 30, dosesRequired: 2, intervalsDays: [4 * _wk]),
    ],
    route: 'IM',
    notes: 'First season (under ~9 y): 2 doses ≥4 wk apart, then annual single dose.',
    source: 'IAP schedule', confidence: 'LOW',
  ),
  VaccineRule(
    id: 'mmr',
    name: 'MMR',
    shortName: 'MMR',
    kind: VaccineKind.live,
    minAgeDays: 9 * _mo,
    bands: [
      DoseBand(maxAgeDays: 1 << 30, dosesRequired: 2, intervalsDays: [4 * _wk]),
    ],
    route: 'SC',
    notes:
        'Min interval 4 wk between measles-containing doses. A dose given <9 mo does not replace a routine dose.',
    source: 'IAP schedule', confidence: 'MED',
  ),
  VaccineRule(
    id: 'tcv',
    name: 'Typhoid conjugate (TCV)',
    shortName: 'TCV',
    kind: VaccineKind.inactivated,
    minAgeDays: 6 * _mo,
    bands: [DoseBand(maxAgeDays: 1 << 30, dosesRequired: 1, intervalsDays: [])],
    route: 'IM',
    notes: 'Single dose from 6 months. No routine booster.',
    source: 'IAP-ACVIP 2025', confidence: 'MED',
  ),
  VaccineRule(
    id: 'hepa',
    name: 'Hepatitis A (inactivated)',
    shortName: 'Hep A',
    kind: VaccineKind.inactivated,
    minAgeDays: 12 * _mo,
    bands: [
      DoseBand(maxAgeDays: 1 << 30, dosesRequired: 2, intervalsDays: [26 * _wk]),
    ],
    route: 'IM',
    notes: 'Inactivated: 2 doses 6 mo apart. Live attenuated formulation is a SINGLE dose — verify product.',
    source: 'IAP schedule', confidence: 'LOW',
  ),
  VaccineRule(
    id: 'varicella',
    name: 'Varicella',
    shortName: 'Varicella',
    kind: VaccineKind.live,
    minAgeDays: 12 * _mo,
    bands: [
      DoseBand(maxAgeDays: 1 << 30, dosesRequired: 2, intervalsDays: [12 * _wk]),
    ],
    route: 'SC',
    notes:
        '12 mo–12 y: preferred interval ~3 mo (min 4 wk valid). ≥13 y: min 4 wk. Not needed with evidence of immunity.',
    source: 'IAP schedule', confidence: 'MED',
  ),
  VaccineRule(
    id: 'hpv',
    name: 'HPV',
    shortName: 'HPV',
    kind: VaccineKind.inactivated,
    minAgeDays: 9 * 365,
    bands: [
      // NOTE 2025: girls 9–<15 y may need only 1 dose; boys 9–<15 y 2 doses;
      // ≥15 y / immunocompromised 3 doses. Sex/immune status not modelled here
      // yet — this 2-dose <15 / 3-dose ≥15 encoding is a placeholder. VERIFY.
      DoseBand(maxAgeDays: 15 * 365, dosesRequired: 2, intervalsDays: [26 * _wk]),
      DoseBand(maxAgeDays: 1 << 30, dosesRequired: 3, intervalsDays: [8 * _wk, 16 * _wk]),
    ],
    route: 'IM',
    notes: 'Adolescent. Dose count depends on age, sex and immune status in IAP-ACVIP 2025 — VERIFY & extend.',
    source: 'IAP-ACVIP 2025', confidence: 'LOW',
  ),

  // ── Special-situation / indication-based only ──────────────────────────────
  VaccineRule(id: 'mening', name: 'Meningococcal', shortName: 'Men', kind: VaccineKind.inactivated, minAgeDays: 0, bands: [DoseBand(maxAgeDays: 1 << 30, dosesRequired: 1, intervalsDays: [])], specialOnly: true, notes: 'High-risk, travel, outbreak, asplenia, complement deficiency.', source: 'IAP', confidence: 'MED'),
  VaccineRule(id: 'je', name: 'Japanese Encephalitis', shortName: 'JE', kind: VaccineKind.live, minAgeDays: 0, bands: [DoseBand(maxAgeDays: 1 << 30, dosesRequired: 2, intervalsDays: [])], specialOnly: true, notes: 'Endemic area / outbreak / travel indication.', source: 'IAP', confidence: 'MED'),
  VaccineRule(id: 'cholera', name: 'Cholera', shortName: 'Cholera', kind: VaccineKind.inactivated, minAgeDays: 0, bands: [DoseBand(maxAgeDays: 1 << 30, dosesRequired: 2, intervalsDays: [])], specialOnly: true, notes: 'Special situations only.', source: 'IAP', confidence: 'MED'),
  VaccineRule(id: 'ppsv23', name: 'PPSV23', shortName: 'PPSV23', kind: VaccineKind.inactivated, minAgeDays: 2 * 365, bands: [DoseBand(maxAgeDays: 1 << 30, dosesRequired: 1, intervalsDays: [])], specialOnly: true, notes: 'High-risk (asplenia, immunodeficiency); sequence with PCV.', source: 'IAP', confidence: 'MED'),
  VaccineRule(id: 'rabies', name: 'Rabies', shortName: 'Rabies', kind: VaccineKind.inactivated, minAgeDays: 0, bands: [DoseBand(maxAgeDays: 1 << 30, dosesRequired: 1, intervalsDays: [])], specialOnly: true, notes: 'Post-exposure or pre-exposure prophylaxis only — see the rabies module.', source: 'IAP', confidence: 'MED'),
  VaccineRule(id: 'yellowfever', name: 'Yellow Fever', shortName: 'YF', kind: VaccineKind.live, minAgeDays: 9 * _mo, bands: [DoseBand(maxAgeDays: 1 << 30, dosesRequired: 1, intervalsDays: [])], specialOnly: true, notes: 'Travel to endemic countries only.', source: 'IAP', confidence: 'MED'),
];
