// =============================================================================
// catchup/catchup_engine.dart — rule-based catch-up immunization engine
//
// Pure Dart (no Flutter imports) so the clinical logic is unit-testable via
// `flutter test`. The UI (catchup_screen.dart) is a thin layer over this.
//
// GUIDELINE: IAP-ACVIP 2025 (Indian Pediatrics 2026). Rule VALUES here are a
// DRAFT and MUST be verified against the current publication before clinical
// use — see the `source`/`confidence` on each VaccineRule and the module
// disclaimer. The ENGINE (validity, intervals, grace, live-vaccine spacing,
// age windows) is guideline-agnostic; swapping the rule set updates behaviour.
//
// Core principle: NEVER restart a valid series just because the child is late.
// A previously valid dose stays valid; the engine continues from history.
// =============================================================================

const String kGuidelineVersion = 'IAP-ACVIP-2025';
const String kGuidelineEffective = '2026';

/// ACVIP grace period: a dose given up to this many days early still counts.
const int kGraceDays = 4;

/// Minimum spacing between two non-simultaneous live parenteral vaccines.
const int kLiveVaccineSpacingDays = 28;

// ---------------------------------------------------------------------------
// Age
// ---------------------------------------------------------------------------

class Age {
  final int totalDays;
  const Age(this.totalDays);

  factory Age.between(DateTime from, DateTime to) =>
      Age(to.difference(from).inDays);

  int get years => (totalDays / 365.25).floor();
  int get months => (totalDays / 30.4375).floor();
  int get weeks => (totalDays / 7).floor();

  /// "2 years 4 months" / "6 weeks" style label.
  String get label {
    if (totalDays < 56) return '$weeks weeks';
    final y = years;
    final m = months - y * 12;
    if (y == 0) return '$m month${m == 1 ? '' : 's'}';
    if (m == 0) return '$y year${y == 1 ? '' : 's'}';
    return '$y year${y == 1 ? '' : 's'} $m month${m == 1 ? '' : 's'}';
  }
}

// ---------------------------------------------------------------------------
// Vaccine rule model (the data layer the engine consumes)
// ---------------------------------------------------------------------------

enum VaccineKind { inactivated, live }

/// One age band's dose requirement — supports age-dependent catch-up
/// (PCV, Hib, HPV, HepA…). The FIRST band whose [maxAgeDays] the child's age
/// at *first dose* falls under decides the total doses required.
class DoseBand {
  /// Upper bound (exclusive) of age-at-initiation for this band, in days.
  final int maxAgeDays;

  /// Total valid doses needed to complete the series when started in this band.
  final int dosesRequired;

  /// Minimum interval(s) in days between consecutive doses. If shorter than
  /// (dosesRequired-1), the last value repeats.
  final List<int> intervalsDays;

  const DoseBand({
    required this.maxAgeDays,
    required this.dosesRequired,
    required this.intervalsDays,
  });

  int intervalBefore(int doseNumber) {
    // doseNumber is 1-based; interval before dose N is intervalsDays[N-2].
    if (doseNumber < 2 || intervalsDays.isEmpty) return 0;
    final idx = doseNumber - 2;
    return idx < intervalsDays.length
        ? intervalsDays[idx]
        : intervalsDays.last;
  }
}

class VaccineRule {
  final String id;
  final String name;
  final String shortName;
  final VaccineKind kind;

  /// Minimum age for the FIRST dose, in days.
  final int minAgeDays;

  /// Beyond this age, a NEW series may not be *initiated* (null = no limit).
  final int? maxInitAgeDays;

  /// Beyond this age, the series may not be *completed* at all (null = none).
  /// Rotavirus is the critical case.
  final int? maxCompleteAgeDays;

  /// Age-banded dose requirements, evaluated in order.
  final List<DoseBand> bands;

  /// Special-situation only (Meningococcal, JE, Cholera, PPSV23, Rabies, YF):
  /// never shown as routinely due; surfaced under "Special situations".
  final bool specialOnly;

  final String route;
  final String notes;
  final String source;
  final String confidence; // HIGH | MED | LOW

  const VaccineRule({
    required this.id,
    required this.name,
    required this.shortName,
    required this.kind,
    required this.minAgeDays,
    this.maxInitAgeDays,
    this.maxCompleteAgeDays,
    required this.bands,
    this.specialOnly = false,
    this.route = '',
    this.notes = '',
    this.source = '',
    this.confidence = 'LOW',
  });

  bool get isLive => kind == VaccineKind.live;

  /// The dose band that applies given the age (in days) at the FIRST dose.
  DoseBand bandForFirstDoseAge(int firstDoseAgeDays) {
    for (final b in bands) {
      if (firstDoseAgeDays < b.maxAgeDays) return b;
    }
    return bands.last;
  }
}

// ---------------------------------------------------------------------------
// A previously received dose (from history)
// ---------------------------------------------------------------------------

class GivenDose {
  /// Date administered, or null if the clinician only knows "a dose was given".
  final DateTime? date;
  const GivenDose(this.date);
}

// ---------------------------------------------------------------------------
// Engine output
// ---------------------------------------------------------------------------

enum RecStatus {
  dueToday, // can and should be given today
  notYetDue, // valid next dose, but minimum interval not yet elapsed
  missedEligible, // behind schedule but still within the eligible window → give now
  notEligible, // age window passed (e.g. rotavirus) → cannot initiate/complete
  complete, // series already complete
  special, // special-situation / indication-based
  needsDate, // can't compute earliest date because a prior dose date is missing
}

class Recommendation {
  final String vaccineId;
  final String vaccineName;
  final int doseNumber; // the dose this recommendation is about (1-based)
  final int dosesRequired;
  final RecStatus status;
  final String reason;
  final DateTime? earliestDate; // when status == notYetDue
  final int? minIntervalDays;
  final bool isLive;

  const Recommendation({
    required this.vaccineId,
    required this.vaccineName,
    required this.doseNumber,
    required this.dosesRequired,
    required this.status,
    required this.reason,
    this.earliestDate,
    this.minIntervalDays,
    this.isLive = false,
  });

  String get doseLabel =>
      dosesRequired <= 1 ? 'Single dose' : 'Dose $doseNumber of $dosesRequired';
}

// ---------------------------------------------------------------------------
// The engine
// ---------------------------------------------------------------------------

class CatchupResult {
  final Age age;
  final List<Recommendation> recommendations;
  const CatchupResult({required this.age, required this.recommendations});

  List<Recommendation> byStatus(RecStatus s) =>
      recommendations.where((r) => r.status == s).toList();
}

class CatchupEngine {
  final List<VaccineRule> rules;
  const CatchupEngine(this.rules);

  CatchupResult evaluate({
    required DateTime dob,
    required DateTime today,
    required Map<String, List<GivenDose>> history,
    bool highRisk = false,
  }) {
    final age = Age.between(dob, today);
    final recs = <Recommendation>[];

    for (final rule in rules) {
      if (rule.specialOnly) {
        recs.add(Recommendation(
          vaccineId: rule.id,
          vaccineName: rule.name,
          doseNumber: 0,
          dosesRequired: 0,
          status: RecStatus.special,
          reason: rule.notes.isEmpty
              ? 'Indication-based — give only for the relevant risk/travel/outbreak situation.'
              : rule.notes,
          isLive: rule.isLive,
        ));
        continue;
      }
      recs.add(_evaluateVaccine(rule, dob, today, age, history[rule.id] ?? const []));
    }
    return CatchupResult(age: age, recommendations: recs);
  }

  Recommendation _evaluateVaccine(
    VaccineRule rule,
    DateTime dob,
    DateTime today,
    Age age,
    List<GivenDose> given,
  ) {
    // Count VALID prior doses. A dose counts unless it fails min age (with the
    // 4-day grace) or the min interval from the previous valid dose. Doses with
    // unknown dates are trusted as valid (the clinician asserted them) but then
    // block precise date math for the NEXT dose.
    int validDoses = 0;
    DateTime? lastValidDate;
    bool missingDate = false;

    // Determine the band from the age at first dose (if known), else current.
    final firstAgeDays = (given.isNotEmpty && given.first.date != null)
        ? Age.between(dob, given.first.date!).totalDays
        : age.totalDays;
    final band = rule.bandForFirstDoseAge(firstAgeDays);
    final required = band.dosesRequired;

    for (var i = 0; i < given.length; i++) {
      final d = given[i];
      if (d.date == null) {
        validDoses++;
        missingDate = true;
        continue;
      }
      final ageAtDose = Age.between(dob, d.date!).totalDays;
      // Min age (with grace).
      if (ageAtDose < rule.minAgeDays - kGraceDays) {
        // invalid — too early; do not count, do not advance lastValidDate.
        continue;
      }
      // Min interval from previous valid dose (with grace).
      if (lastValidDate != null) {
        final need = band.intervalBefore(validDoses + 1);
        final gap = d.date!.difference(lastValidDate).inDays;
        if (gap < need - kGraceDays) continue; // invalid interval
      }
      validDoses++;
      lastValidDate = d.date;
    }

    // Series already complete?
    if (validDoses >= required) {
      return Recommendation(
        vaccineId: rule.id,
        vaccineName: rule.name,
        doseNumber: required,
        dosesRequired: required,
        status: RecStatus.complete,
        reason: 'All $required valid dose(s) documented.',
        isLive: rule.isLive,
      );
    }

    final nextDose = validDoses + 1;

    // Age window: can this dose still be given?
    if (rule.maxCompleteAgeDays != null &&
        age.totalDays >= rule.maxCompleteAgeDays!) {
      return Recommendation(
        vaccineId: rule.id,
        vaccineName: rule.name,
        doseNumber: nextDose,
        dosesRequired: required,
        status: RecStatus.notEligible,
        reason:
            'Child has exceeded the maximum age for completing ${rule.shortName}. Catch-up not indicated.',
        isLive: rule.isLive,
      );
    }
    if (validDoses == 0 &&
        rule.maxInitAgeDays != null &&
        age.totalDays >= rule.maxInitAgeDays!) {
      return Recommendation(
        vaccineId: rule.id,
        vaccineName: rule.name,
        doseNumber: 1,
        dosesRequired: required,
        status: RecStatus.notEligible,
        reason:
            'Child has exceeded the maximum age for initiating ${rule.shortName}.',
        isLive: rule.isLive,
      );
    }
    // Not yet old enough for the first dose.
    if (validDoses == 0 && age.totalDays < rule.minAgeDays - kGraceDays) {
      final earliest = dob.add(Duration(days: rule.minAgeDays));
      return Recommendation(
        vaccineId: rule.id,
        vaccineName: rule.name,
        doseNumber: 1,
        dosesRequired: required,
        status: RecStatus.notYetDue,
        reason:
            'Minimum age for ${rule.shortName} is ${_ageWords(rule.minAgeDays)}.',
        earliestDate: earliest,
        isLive: rule.isLive,
      );
    }

    // A next dose is required. Is the minimum interval satisfied?
    if (nextDose >= 2 && lastValidDate != null) {
      final need = band.intervalBefore(nextDose);
      final earliest = lastValidDate.add(Duration(days: need));
      if (today.isBefore(earliest.subtract(const Duration(days: kGraceDays)))) {
        return Recommendation(
          vaccineId: rule.id,
          vaccineName: rule.name,
          doseNumber: nextDose,
          dosesRequired: required,
          status: RecStatus.notYetDue,
          reason: 'Minimum interval from the previous dose not yet elapsed.',
          earliestDate: earliest,
          minIntervalDays: need,
          isLive: rule.isLive,
        );
      }
    } else if (nextDose >= 2 && missingDate) {
      return Recommendation(
        vaccineId: rule.id,
        vaccineName: rule.name,
        doseNumber: nextDose,
        dosesRequired: required,
        status: RecStatus.needsDate,
        reason:
            'Date of the previous ${rule.shortName} dose is required to calculate the earliest valid next dose.',
        minIntervalDays: band.intervalBefore(nextDose),
        isLive: rule.isLive,
      );
    }

    // Can give today.
    return Recommendation(
      vaccineId: rule.id,
      vaccineName: rule.name,
      doseNumber: nextDose,
      dosesRequired: required,
      status: validDoses == 0 ? RecStatus.dueToday : RecStatus.missedEligible,
      reason: validDoses == 0
          ? 'No valid dose documented and the child is within the eligible window.'
          : 'Behind schedule but still eligible — continue the series (do not restart).',
      minIntervalDays: nextDose >= 2 ? band.intervalBefore(nextDose) : null,
      isLive: rule.isLive,
    );
  }

  static String _ageWords(int days) {
    if (days < 56) return '${(days / 7).round()} weeks';
    final m = (days / 30.4375).round();
    if (m < 24) return '$m months';
    return '${(days / 365.25).round()} years';
  }
}
