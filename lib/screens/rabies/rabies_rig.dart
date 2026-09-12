// =============================================================================
// screens/rabies/rabies_rig.dart — passive-immunisation dose calculation
//
// Two rules govern everything here.
//
// FIRST: DOSE IN IU AND VOLUME IN mL ARE DIFFERENT ANSWERS.
// The guidelines state a dose per kilogram in international units. Turning
// that into millilitres needs the potency of the vial in hand, and potencies
// differ between products — IAP prints 40 IU/mL for single-monoclonal RMAb and
// 600 IU/mL for the cocktail, a fifteen-fold difference. A tool that guessed a
// concentration to produce a tidy volume would be manufacturing a dosing
// error. So volume is returned only when a concentration is supplied, and
// `volumeMl` is null otherwise.
//
// SECOND: NO WEIGHT, NO DOSE.
// A weight-based dose with no weight is not a small problem to paper over with
// a default. The calculator returns a result that says what is missing.
// =============================================================================

import 'package:flutter/foundation.dart';

import 'rabies_protocol.dart';

@immutable
class RigDose {
  final PassiveAgent agent;

  /// Weight used, in kilograms. Null when none was supplied.
  final double? weightKg;

  /// Total dose in international units. Null when it cannot be computed.
  final double? totalIu;

  /// Concentration used for the volume, in IU per mL. Null when not supplied.
  final double? concentrationIuPerMl;

  /// Volume in millilitres. Null unless a concentration was supplied.
  final double? volumeMl;

  /// Named reasons the calculation is incomplete.
  final List<String> missing;

  const RigDose({
    required this.agent,
    required this.weightKg,
    required this.totalIu,
    required this.concentrationIuPerMl,
    required this.volumeMl,
    required this.missing,
  });

  bool get isComplete => totalIu != null;

  /// Dose as text, rounded for display only.
  ///
  /// One decimal place, and trailing ".0" dropped: 20 IU/kg on whole-kilogram
  /// weights gives whole numbers, while 3.33 IU/kg does not, and printing
  /// "300.0 IU" for the first looks like false precision.
  String get iuLabel {
    final v = totalIu;
    if (v == null) return '—';
    return '${_trim(v)} IU';
  }

  String get volumeLabel {
    final v = volumeMl;
    if (v == null) return '—';
    return '${_trim(v)} mL';
  }
}

String _trim(double v) {
  final s = v.toStringAsFixed(2);
  // 300.00 -> 300 ; 49.95 -> 49.95 ; 66.60 -> 66.6
  return s
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}

/// Calculates a passive-immunisation dose.
///
/// [concentrationIuPerMl] overrides the agent's printed potency. It exists
/// because the potency in a guideline is the potency of the product the
/// guideline's authors had; the vial in the room may differ, and the person
/// holding it is the authority on that.
RigDose calculateRig({
  required PassiveAgent agent,
  double? weightKg,
  double? concentrationIuPerMl,
}) {
  final missing = <String>[];

  if (weightKg == null || weightKg <= 0) {
    missing.add('Current weight in kg');
    return RigDose(
      agent: agent,
      weightKg: null,
      totalIu: null,
      concentrationIuPerMl: concentrationIuPerMl,
      volumeMl: null,
      missing: missing,
    );
  }

  final totalIu = agent.iuPerKg * weightKg;

  // The agent's own printed potency is used only if the caller did not state
  // one. Either way the value used is reported back, so the number on screen
  // can always be traced to a concentration the reader can check.
  final conc = concentrationIuPerMl ?? agent.concentrationIuPerMl;
  if (conc == null || conc <= 0) {
    missing.add('Product concentration in IU/mL, to calculate a volume');
  }

  return RigDose(
    agent: agent,
    weightKg: weightKg,
    totalIu: totalIu,
    concentrationIuPerMl: conc,
    volumeMl: (conc == null || conc <= 0) ? null : totalIu / conc,
    missing: missing,
  );
}

/// Every agent's dose for one weight, for the comparison table.
List<RigDose> calculateAllRig({double? weightKg}) =>
    kPassiveAgents.map((a) => calculateRig(agent: a, weightKg: weightKg)).toList();

// ── The RIG window ───────────────────────────────────────────────────────────

enum RigWindowStatus {
  /// Vaccine not started — RIG should be given alongside the first dose.
  notStarted,

  /// Within 7 days of the first vaccine dose.
  open,

  /// Past day 7.
  closed,

  /// The first vaccine date is not known.
  unknown,
}

@immutable
class RigWindow {
  final RigWindowStatus status;
  final int? daysSinceFirstDose;
  final int? daysRemaining;
  final String message;
  const RigWindow({
    required this.status,
    required this.message,
    this.daysSinceFirstDose,
    this.daysRemaining,
  });
}

/// Whether passive immunisation can still be given.
///
/// Both sources close the window at day 7 after the first vaccine dose. Past
/// that, the vaccine-induced antibody response is the protection, and adding
/// RIG can blunt it — so this is a real "do not", not a scheduling preference.
RigWindow rigWindow({DateTime? firstVaccineDate, required DateTime today}) {
  if (firstVaccineDate == null) {
    return const RigWindow(
      status: RigWindowStatus.notStarted,
      message: 'Vaccine not yet started. Give RIG/RMAb as soon as possible, '
          'together with the first dose.',
    );
  }

  final d0 = DateTime(
      firstVaccineDate.year, firstVaccineDate.month, firstVaccineDate.day);
  final now = DateTime(today.year, today.month, today.day);
  final days = now.difference(d0).inDays;

  if (days < 0) {
    return const RigWindow(
      status: RigWindowStatus.unknown,
      message: 'The first vaccine date is after today. Check the date.',
    );
  }

  if (days > kRigWindowDays) {
    return RigWindow(
      status: RigWindowStatus.closed,
      daysSinceFirstDose: days,
      message: 'Day $days after the first vaccine dose. Do not give RIG beyond '
          'the 7th day after the first dose. Complete the vaccine course.',
    );
  }

  return RigWindow(
    status: RigWindowStatus.open,
    daysSinceFirstDose: days,
    daysRemaining: kRigWindowDays - days,
    message: days == 0
        ? 'Day 0 — give RIG/RMAb now, as soon as possible.'
        : 'Day $days after the first vaccine dose. '
            '${kRigWindowDays - days} day(s) of the window remain, but give it '
            'now — the sooner the better.',
  );
}
