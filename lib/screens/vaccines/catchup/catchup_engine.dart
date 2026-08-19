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

/// `live` means live PARENTERAL — the only kind the 28-day spacing rule
/// applies to. Oral live vaccines (rotavirus, OPV) neither trigger nor are
/// blocked by it, so they need their own kind rather than a comment.
enum VaccineKind { inactivated, live, liveOral }

/// Needed because some schedules differ by sex — IAP-ACVIP 2025 allows a
/// SINGLE HPV dose for immunocompetent girls aged 9–15, but not for boys.
/// [unknown] falls back to the sex-neutral schedule, which is the safer
/// (higher dose count) option.
enum PatientSex { unknown, female, male }

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

  /// Minimum AGE for the final dose of this band, in days.
  ///
  /// This is how a booster is expressed: a 7–11 month PCV starter needs two
  /// primary doses plus a booster that cannot be given before 12 months, no
  /// matter how long the interval since the previous dose.
  final int? minFinalDoseAgeDays;

  const DoseBand({
    required this.maxAgeDays,
    required this.dosesRequired,
    required this.intervalsDays,
    this.minFinalDoseAgeDays,
  });

  int intervalBefore(int doseNumber) {
    // doseNumber is 1-based; interval before dose N is intervalsDays[N-2].
    if (doseNumber < 2 || intervalsDays.isEmpty) return 0;
    final idx = doseNumber - 2;
    return idx < intervalsDays.length ? intervalsDays[idx] : intervalsDays.last;
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

  /// Minimum interval from dose 1 to the FINAL dose, in days.
  ///
  /// Some series constrain the whole span, not just consecutive gaps. Hep B is
  /// the case that forced this: dose 2 must be ≥4 weeks after dose 1 and dose 3
  /// ≥8 weeks after dose 2, but dose 3 must ALSO be ≥16 weeks after dose 1.
  /// Consecutive minimums alone would allow a valid-looking 12-week series.
  final int? minFirstToFinalDays;

  /// Minimum age at the FINAL dose, in days (Hep B: 24 weeks).
  final int? minFinalDoseAgeDays;

  /// Age-banded dose requirements, evaluated in order.
  final List<DoseBand> bands;

  /// Used INSTEAD of [bands] for an immunocompetent female patient.
  /// Null means the schedule does not vary by sex.
  final List<DoseBand>? bandsFemaleImmunocompetent;

  /// A product-specific alternative the clinician can select — rotavirus is
  /// the case that needs it (Rotarix is a 2-dose course, Rotavac/RotaTeq are
  /// 3-dose). [alternateLabel] names it in the UI.
  final List<DoseBand>? alternateBands;
  final String? alternateLabel;

  /// Special-situation only (Meningococcal, JE, Cholera, PPSV23, Rabies, YF):
  /// never shown as routinely due; surfaced under "Special situations".
  final bool specialOnly;

  /// Max doses to offer in the history picker. Defaults to the largest band
  /// requirement, so a single-dose vaccine (BCG, OPV, TCV) shows 0–1, not 0–4.
  final int? maxDosesInput;

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
    this.minFirstToFinalDays,
    this.minFinalDoseAgeDays,
    required this.bands,
    this.bandsFemaleImmunocompetent,
    this.alternateBands,
    this.alternateLabel,
    this.specialOnly = false,
    this.maxDosesInput,
    this.route = '',
    this.notes = '',
    this.source = '',
    this.confidence = 'LOW',
  });

  bool get isLive => kind == VaccineKind.live || kind == VaccineKind.liveOral;

  /// Only parenteral live vaccines participate in the 28-day spacing rule.
  bool get isLiveParenteral => kind == VaccineKind.live;

  /// Doses to offer in the history picker (chips 0..maxDoses).
  int get maxDoses =>
      maxDosesInput ??
      (specialOnly
          ? 1
          : bands.map((b) => b.dosesRequired).fold(1, (a, b) => a > b ? a : b));

  /// The dose band that applies given the age (in days) at the FIRST dose.
  /// The band set that applies to this patient. High-risk (immunocompromised)
  /// always uses the sex-neutral set — the reduced-dose schedules are for
  /// immunocompetent children only.
  List<DoseBand> bandsFor({
    PatientSex sex = PatientSex.unknown,
    bool highRisk = false,
    bool useAlternate = false,
  }) {
    if (useAlternate && alternateBands != null) return alternateBands!;
    if (!highRisk &&
        sex == PatientSex.female &&
        bandsFemaleImmunocompetent != null) {
      return bandsFemaleImmunocompetent!;
    }
    return bands;
  }

  DoseBand bandForFirstDoseAge(
    int firstDoseAgeDays, {
    PatientSex sex = PatientSex.unknown,
    bool highRisk = false,
    bool useAlternate = false,
  }) {
    final list = bandsFor(
      sex: sex,
      highRisk: highRisk,
      useAlternate: useAlternate,
    );
    for (final b in list) {
      if (firstDoseAgeDays < b.maxAgeDays) return b;
    }
    return list.last;
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

  /// Doses the clinician entered that did NOT count, each with the reason.
  /// Without this the engine silently drops them and the dose count looks
  /// wrong for no visible reason.
  final List<String> rejectedDoses;

  Recommendation copyWith({
    RecStatus? status,
    String? reason,
    DateTime? earliestDate,
  }) => Recommendation(
    vaccineId: vaccineId,
    vaccineName: vaccineName,
    doseNumber: doseNumber,
    dosesRequired: dosesRequired,
    status: status ?? this.status,
    reason: reason ?? this.reason,
    earliestDate: earliestDate ?? this.earliestDate,
    minIntervalDays: minIntervalDays,
    isLive: isLive,
    rejectedDoses: rejectedDoses,
  );

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
    this.rejectedDoses = const [],
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
    PatientSex sex = PatientSex.unknown,

    /// Rule ids for which the clinician selected the product-specific
    /// alternate schedule (e.g. {'rota'} for Rotarix).
    Set<String> useAlternate = const {},
  }) {
    final age = Age.between(dob, today);
    final recs = <Recommendation>[];

    for (final rule in rules) {
      if (rule.specialOnly) {
        recs.add(
          Recommendation(
            vaccineId: rule.id,
            vaccineName: rule.name,
            doseNumber: 0,
            dosesRequired: 0,
            status: RecStatus.special,
            reason: rule.notes.isEmpty
                ? 'Indication-based — give only for the relevant risk/travel/outbreak situation.'
                : rule.notes,
            isLive: rule.isLive,
          ),
        );
        continue;
      }
      recs.add(
        _evaluateVaccine(
          rule,
          dob,
          today,
          age,
          history[rule.id] ?? const [],
          sex: sex,
          highRisk: highRisk,
          useAlternate: useAlternate.contains(rule.id),
        ),
      );
    }
    return CatchupResult(
      age: age,
      recommendations: _applyLiveSpacing(rules, history, today, recs),
    );
  }

  /// Two live PARENTERAL vaccines must be given on the SAME day or at least
  /// [kLiveVaccineSpacingDays] apart. Each vaccine is evaluated in isolation,
  /// so this cross-vaccine rule has to be applied afterwards — without it the
  /// engine would happily say "MMR today" to a child given varicella last week.
  ///
  /// Oral live vaccines (rotavirus, OPV) are exempt, which is why they carry
  /// [VaccineKind.liveOral].
  ///
  /// The 4-day grace deliberately does NOT apply here: the 28-day live interval
  /// is absolute.
  List<Recommendation> _applyLiveSpacing(
    List<VaccineRule> rules,
    Map<String, List<GivenDose>> history,
    DateTime today,
    List<Recommendation> recs,
  ) {
    final byId = {for (final r in rules) r.id: r};

    // Most recent live-parenteral dose in the history, and what it was.
    DateTime? lastLive;
    String? lastLiveName;
    history.forEach((id, doses) {
      final rule = byId[id];
      if (rule == null || !rule.isLiveParenteral) return;
      for (final d in doses) {
        final when = d.date;
        if (when == null || when.isAfter(today)) continue;
        if (lastLive == null || when.isAfter(lastLive!)) {
          lastLive = when;
          lastLiveName = rule.shortName;
        }
      }
    });
    if (lastLive == null) return recs;

    final gap = today.difference(lastLive!).inDays;
    // Same-day co-administration is allowed, so only a gap of 1..27 defers.
    if (gap <= 0 || gap >= kLiveVaccineSpacingDays) return recs;
    final earliest = lastLive!.add(
      const Duration(days: kLiveVaccineSpacingDays),
    );

    return recs.map((r) {
      final rule = byId[r.vaccineId];
      if (rule == null || !rule.isLiveParenteral) return r;
      if (r.vaccineId == _idOfMostRecentLive(history, byId, lastLive!))
        return r;
      if (r.status != RecStatus.dueToday &&
          r.status != RecStatus.missedEligible) {
        return r;
      }
      return r.copyWith(
        status: RecStatus.notYetDue,
        earliestDate: earliest,
        reason:
            'Another live vaccine ($lastLiveName) was given $gap day(s) ago. '
            'Two live injectable vaccines must be given on the same day or at '
            'least $kLiveVaccineSpacingDays days apart.',
      );
    }).toList();
  }

  /// Which vaccine the most recent live-parenteral dose belonged to — that one
  /// is not blocked by its own dose.
  String? _idOfMostRecentLive(
    Map<String, List<GivenDose>> history,
    Map<String, VaccineRule> byId,
    DateTime when,
  ) {
    for (final e in history.entries) {
      final rule = byId[e.key];
      if (rule == null || !rule.isLiveParenteral) continue;
      for (final d in e.value) {
        if (d.date != null && d.date!.isAtSameMomentAs(when)) return e.key;
      }
    }
    return null;
  }

  Recommendation _evaluateVaccine(
    VaccineRule rule,
    DateTime dob,
    DateTime today,
    Age age,
    List<GivenDose> given, {
    PatientSex sex = PatientSex.unknown,
    bool highRisk = false,
    bool useAlternate = false,
  }) {
    // Count VALID prior doses. A dose counts unless it fails min age (with the
    // 4-day grace) or the min interval from the previous valid dose. Doses with
    // unknown dates are trusted as valid (the clinician asserted them) but then
    // block precise date math for the NEXT dose.
    int validDoses = 0;
    DateTime? lastValidDate;
    DateTime? firstValidDate;
    bool missingDate = false;
    final rejected = <String>[];

    // Determine the band from the age at the first dose that could actually
    // count. Using `given.first` outright let a dose given BEFORE the minimum
    // age — one the loop below then rejects — decide how many doses the whole
    // series needs. Interval validity depends on the band, so only the minimum
    // age is used here; that breaks the circularity and fixes the real case.
    int? firstUsableAgeDays;
    for (final d in given) {
      if (d.date == null) continue;
      final a = Age.between(dob, d.date!).totalDays;
      if (a >= rule.minAgeDays - kGraceDays) {
        firstUsableAgeDays = a;
        break;
      }
    }
    final firstAgeDays = firstUsableAgeDays ?? age.totalDays;
    final band = rule.bandForFirstDoseAge(
      firstAgeDays,
      sex: sex,
      highRisk: highRisk,
      useAlternate: useAlternate,
    );
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
        // Too early for the minimum age — does not count, and does not
        // advance lastValidDate.
        rejected.add(
          'Dose ${i + 1} given at ${_ageWords(ageAtDose)} — before the '
          'minimum age of ${_ageWords(rule.minAgeDays)}. Repeat it.',
        );
        continue;
      }
      // Min interval from previous valid dose (with grace).
      if (lastValidDate != null) {
        final need = band.intervalBefore(validDoses + 1);
        final gap = d.date!.difference(lastValidDate).inDays;
        if (gap < need - kGraceDays) {
          rejected.add(
            'Dose ${i + 1} given $gap days after the previous valid dose — '
            'less than the ${need}-day minimum interval. Repeat it.',
          );
          continue;
        }
      }
      validDoses++;
      firstValidDate ??= d.date;
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
        rejectedDoses: rejected,
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
        rejectedDoses: rejected,
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
        rejectedDoses: rejected,
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
        rejectedDoses: rejected,
      );
    }

    // Final-dose constraints are evaluated OUTSIDE the interval guard so they
    // also bind a single-dose series (where nextDose is 1 and there is no
    // previous dose to measure an interval from).
    //
    // They are ABSOLUTE: the 4-day grace applies to minimum intervals, not to
    // a minimum age or a whole-series span, so these are compared to `today`
    // directly rather than to today-plus-grace.
    DateTime? absoluteEarliest;
    if (nextDose == required) {
      final span = rule.minFirstToFinalDays;
      if (span != null && firstValidDate != null) {
        absoluteEarliest = firstValidDate.add(Duration(days: span));
      }
      // Per-rule (Hep B) and per-band (PCV/Hib booster) minimum final ages;
      // the later of the two wins.
      for (final minAge in [
        rule.minFinalDoseAgeDays,
        band.minFinalDoseAgeDays,
      ]) {
        if (minAge == null) continue;
        final byAge = dob.add(Duration(days: minAge));
        if (absoluteEarliest == null || byAge.isAfter(absoluteEarliest)) {
          absoluteEarliest = byAge;
        }
      }
    }

    // A next dose is required. Is the minimum interval satisfied?
    if (nextDose >= 2 && lastValidDate != null) {
      final need = band.intervalBefore(nextDose);
      final byInterval = lastValidDate.add(Duration(days: need));
      // Grace applies to the interval component only.
      final intervalBlocks = today.isBefore(
        byInterval.subtract(const Duration(days: kGraceDays)),
      );
      final absoluteBlocks =
          absoluteEarliest != null && today.isBefore(absoluteEarliest);

      var earliest = byInterval;
      if (absoluteEarliest != null && absoluteEarliest.isAfter(earliest)) {
        earliest = absoluteEarliest;
      }

      if (intervalBlocks || absoluteBlocks) {
        return Recommendation(
          vaccineId: rule.id,
          vaccineName: rule.name,
          doseNumber: nextDose,
          dosesRequired: required,
          status: RecStatus.notYetDue,
          // Name the constraint that actually SETS the date. When a booster
          // age and an interval both bind, the later one is the real answer;
          // saying "minimum interval" there is misleading.
          reason:
              (absoluteEarliest != null &&
                  !absoluteEarliest.isBefore(byInterval))
              ? (band.minFinalDoseAgeDays != null
                    ? 'The booster cannot be given before '
                          '${_ageWords(band.minFinalDoseAgeDays!)} of age.'
                    : 'The final dose has a minimum age / minimum spacing '
                          'from the first dose that has not yet been reached.')
              : 'Minimum interval from the previous dose not yet elapsed.',
          earliestDate: earliest,
          minIntervalDays: need,
          isLive: rule.isLive,
          rejectedDoses: rejected,
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
        rejectedDoses: rejected,
      );
    }

    // A single-dose series (or a first dose) can still be blocked by an
    // absolute final-dose constraint — the interval branch above never runs
    // for it.
    if (absoluteEarliest != null && today.isBefore(absoluteEarliest)) {
      return Recommendation(
        vaccineId: rule.id,
        vaccineName: rule.name,
        doseNumber: nextDose,
        dosesRequired: required,
        status: RecStatus.notYetDue,
        reason: band.minFinalDoseAgeDays != null
            ? 'The booster cannot be given before '
                  '${_ageWords(band.minFinalDoseAgeDays!)} of age.'
            : 'The final dose has a minimum age that has not yet been reached.',
        earliestDate: absoluteEarliest,
        isLive: rule.isLive,
        rejectedDoses: rejected,
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
      rejectedDoses: rejected,
    );
  }

  static String _ageWords(int days) {
    if (days < 56) return '${(days / 7).round()} weeks';
    final m = (days / 30.4375).round();
    if (m < 24) return '$m months';
    return '${(days / 365.25).round()} years';
  }
}
