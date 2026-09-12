// =============================================================================
// screens/rabies/rabies_engine.dart — the decision engine
//
// Pure functions over the data in rabies_protocol.dart. No widgets, no
// storage, no clock of its own — every time-dependent answer takes the date as
// an argument so it can be tested.
//
// THE RULE THAT SHAPES EVERY BRANCH
// ---------------------------------
// The two errors available here are not symmetrical. Giving prophylaxis that
// turns out to have been unnecessary costs a course of vaccine. Withholding it
// from a genuine exposure is, in the IAP chapter's own words, a disease with
// 100% mortality. So every ambiguity resolves toward assessing and treating,
// and the engine is built so that a missing answer produces "this cannot be
// decided" rather than a reassuring one.
//
// Concretely, the engine will NOT:
//   * read an unknown or undocumented vaccination history as "previously
//     immunised" — that swaps a 5-dose course plus RIG for 2 doses;
//   * let the standard immunocompetent pathway run for an immunocompromised
//     child, or for one whose immune status is unknown;
//   * compute a RIG dose without a weight, or a volume without a stated
//     product concentration;
//   * resolve an uncertain exposure category downward to Category I.
// =============================================================================

import 'package:flutter/foundation.dart';

import 'rabies_protocol.dart';

// ── Inputs ───────────────────────────────────────────────────────────────────

/// A yes / no / not-known answer.
///
/// Three values rather than a bool because "unsure" is a real and common
/// clinical answer here, and collapsing it to false is exactly how a
/// transdermal exposure gets recorded as a Category II scratch.
enum Tri { yes, no, unsure }

@immutable
class RabiesAssessment {
  /// Selected contact-type ids, from [kContactTypes].
  final Set<String> contactTypeIds;

  /// Set only when the clinician overrides the derived category.
  final ExposureCategory? categoryOverride;

  final Tri skinBroken;
  final Tri bleeding;

  /// Whether the contact history is reliable enough to withhold prophylaxis.
  ///
  /// Both sources qualify Category I with "if reliable contact history is
  /// available". Without that, Category I is not a clearance.
  final Tri reliableHistory;

  final ImmunisationStatus immunisationStatus;
  final ImmuneStatus immuneStatus;

  /// Days since a previously COMPLETED PEP course, when known. Drives the
  /// re-exposure branch, where IAP and NCDC genuinely differ.
  final int? daysSincePreviousPep;

  final double? weightKg;
  final VaccineRoute? preferredRoute;

  /// Which guideline's recommendations to produce.
  final GuidelineSource source;

  final String? animal;
  final DateTime? exposureDate;

  const RabiesAssessment({
    this.contactTypeIds = const {},
    this.categoryOverride,
    this.skinBroken = Tri.unsure,
    this.bleeding = Tri.unsure,
    this.reliableHistory = Tri.unsure,
    this.immunisationStatus = ImmunisationStatus.unknown,
    this.immuneStatus = ImmuneStatus.unknown,
    this.daysSincePreviousPep,
    this.weightKg,
    this.preferredRoute,
    this.source = GuidelineSource.ncdcNrcp,
    this.animal,
    this.exposureDate,
  });

  RabiesAssessment copyWith({
    Set<String>? contactTypeIds,
    ExposureCategory? categoryOverride,
    bool clearCategoryOverride = false,
    Tri? skinBroken,
    Tri? bleeding,
    Tri? reliableHistory,
    ImmunisationStatus? immunisationStatus,
    ImmuneStatus? immuneStatus,
    int? daysSincePreviousPep,
    bool clearDaysSincePreviousPep = false,
    double? weightKg,
    bool clearWeight = false,
    VaccineRoute? preferredRoute,
    GuidelineSource? source,
    String? animal,
    DateTime? exposureDate,
  }) =>
      RabiesAssessment(
        contactTypeIds: contactTypeIds ?? this.contactTypeIds,
        categoryOverride: clearCategoryOverride
            ? null
            : (categoryOverride ?? this.categoryOverride),
        skinBroken: skinBroken ?? this.skinBroken,
        bleeding: bleeding ?? this.bleeding,
        reliableHistory: reliableHistory ?? this.reliableHistory,
        immunisationStatus: immunisationStatus ?? this.immunisationStatus,
        immuneStatus: immuneStatus ?? this.immuneStatus,
        daysSincePreviousPep: clearDaysSincePreviousPep
            ? null
            : (daysSincePreviousPep ?? this.daysSincePreviousPep),
        weightKg: clearWeight ? null : (weightKg ?? this.weightKg),
        preferredRoute: preferredRoute ?? this.preferredRoute,
        source: source ?? this.source,
        animal: animal ?? this.animal,
        exposureDate: exposureDate ?? this.exposureDate,
      );
}

// ── Outputs ──────────────────────────────────────────────────────────────────

/// Which overall pathway the child is on.
///
/// A named pathway rather than a pile of booleans, because the pathway is the
/// thing a clinician has to recognise and hand over: "this is the
/// immunocompromised pathway" carries the whole plan.
enum RabiesPathway {
  /// Reliable Category I contact — no prophylaxis.
  noProphylaxis,

  /// Category II or III, no documented previous immunisation, immunocompetent.
  standardNaive,

  /// Documented previous PrEP or PEP, immunocompetent.
  previouslyImmunised,

  /// Immunocompromised, any category above I. Overrides the two above.
  immunocompromised,

  /// IAP only: re-exposure within 3 months of completing PEP.
  woundCareOnlyRecentPep,

  /// Not enough information to place the child on a pathway.
  cannotDecide,
}

extension RabiesPathwayX on RabiesPathway {
  String get label => switch (this) {
        RabiesPathway.noProphylaxis => 'No prophylaxis indicated',
        RabiesPathway.standardNaive => 'Standard pathway — not previously immunised',
        RabiesPathway.previouslyImmunised => 'Previously immunised pathway',
        RabiesPathway.immunocompromised => 'IMMUNOCOMPROMISED — special protocol',
        RabiesPathway.woundCareOnlyRecentPep =>
          'Wound care only — re-exposure within 3 months of completed PEP',
        RabiesPathway.cannotDecide => 'Cannot be decided from the information given',
      };
}

@immutable
class RabiesRecommendation {
  final ExposureCategory category;

  /// Why the category came out as it did, in one line.
  final String categoryReason;

  final RabiesPathway pathway;

  /// True whenever any wound is present — which is every category above I, and
  /// Category I where contaminated skin needs washing.
  final bool woundCareRequired;

  final bool vaccineRequired;
  final VaccineSchedule? schedule;

  /// Both routes for the chosen source, so the clinician can see the
  /// alternative they did not pick.
  final List<VaccineSchedule> routeOptions;

  final bool rigRequired;

  /// Set when RIG is not routine but a named caveat applies.
  final String? rigCaveat;

  /// Things that must be read, ordered most severe first.
  final List<ClinicalWarning> warnings;

  /// Points that are specific to this result rather than standing advice.
  final List<Sourced> instructions;

  /// Non-empty when the engine could not decide something; each entry names
  /// the missing input.
  final List<String> missing;

  const RabiesRecommendation({
    required this.category,
    required this.categoryReason,
    required this.pathway,
    required this.woundCareRequired,
    required this.vaccineRequired,
    required this.routeOptions,
    required this.rigRequired,
    required this.warnings,
    required this.instructions,
    this.schedule,
    this.rigCaveat,
    this.missing = const [],
  });

  bool get isDecided => pathway != RabiesPathway.cannotDecide;
}

// ── Category derivation ──────────────────────────────────────────────────────

int _rank(ExposureCategory c) => switch (c) {
      ExposureCategory.categoryI => 1,
      ExposureCategory.categoryII => 2,
      ExposureCategory.categoryIII => 3,
      ExposureCategory.uncertain => 0,
    };

/// Works out the exposure category from the contact history.
///
/// Rules, in order:
///   * the highest category among the selected contacts sets the floor;
///   * broken skin or bleeding means a transdermal exposure, which is
///     Category III by definition, whatever else was selected;
///   * "unsure" about broken skin or bleeding cannot be read as "no" — if the
///     answer could raise the category, the category is uncertain;
///   * nothing selected is uncertain, never Category I.
///
/// Species is deliberately absent. No source grades exposure by animal, and a
/// tool that let "it was only a pet dog" lower a category would be dangerous.
({ExposureCategory category, String reason}) deriveCategory(
    RabiesAssessment a) {
  if (a.categoryOverride != null) {
    return (
      category: a.categoryOverride!,
      reason: 'Set by the clinician.',
    );
  }

  if (a.contactTypeIds.isEmpty) {
    return (
      category: ExposureCategory.uncertain,
      reason: 'No type of contact has been recorded.',
    );
  }

  final selected = kContactTypes
      .where((c) => a.contactTypeIds.contains(c.id))
      .toList(growable: false);

  if (selected.isEmpty) {
    return (
      category: ExposureCategory.uncertain,
      reason: 'The recorded contact type is not recognised.',
    );
  }

  var base = selected.first.category;
  for (final c in selected) {
    if (_rank(c.category) > _rank(base)) base = c.category;
  }
  final baseLabel = selected
      .firstWhere((c) => c.category == base)
      .label
      .toLowerCase();

  // Transdermal by definition.
  if (a.skinBroken == Tri.yes) {
    return (
      category: ExposureCategory.categoryIII,
      reason: 'Broken skin — a transdermal exposure is Category III.',
    );
  }
  if (a.bleeding == Tri.yes) {
    return (
      category: ExposureCategory.categoryIII,
      reason: 'Bleeding — a transdermal exposure is Category III.',
    );
  }

  // An unknown answer that could raise the category leaves it unresolved.
  if (_rank(base) < _rank(ExposureCategory.categoryIII) &&
      (a.skinBroken == Tri.unsure || a.bleeding == Tri.unsure)) {
    return (
      category: ExposureCategory.uncertain,
      reason: 'Whether the skin was broken or bled is not established, and '
          'either would make this Category III.',
    );
  }

  return (category: base, reason: 'Based on: $baseLabel.');
}

// ── The engine ───────────────────────────────────────────────────────────────

/// Produces the recommendation for one assessment.
///
/// [today] is passed in rather than read from the clock so every time-dependent
/// branch is testable.
RabiesRecommendation evaluateRabies(RabiesAssessment a, {DateTime? today}) {
  final derived = deriveCategory(a);
  final category = derived.category;
  final warnings = <ClinicalWarning>[];
  final instructions = <Sourced>[];
  final missing = <String>[];

  final naiveSchedules = _schedulesFor(a.source, previouslyImmunised: false);
  final boostSchedules = _schedulesFor(a.source, previouslyImmunised: true);

  // ── Category uncertain ─────────────────────────────────────────────────
  //
  // Deliberately the first branch. An unresolved category must never fall
  // through into a pathway, because every pathway below implies a decision
  // about whether to treat.
  if (category == ExposureCategory.uncertain) {
    missing.add('Exposure category');
    return RabiesRecommendation(
      category: category,
      categoryReason: derived.reason,
      pathway: RabiesPathway.cannotDecide,
      woundCareRequired: true,
      vaccineRequired: false,
      routeOptions: naiveSchedules,
      rigRequired: false,
      warnings: const [
        ClinicalWarning(
          'Exposure category uncertain — clinical assessment required. Do not '
          'assume Category I. Wash the wound now regardless.',
          WarningLevel.critical,
          GuidelineSource.ncdcNrcp,
        ),
        ...kStandingWarnings,
      ],
      instructions: const [
        Sourced(
          'Wash now: washing is indicated irrespective of exposure category '
          'and must not wait for the category to be settled.',
          GuidelineSource.ncdcNrcp,
        ),
      ],
      missing: missing,
    );
  }

  // ── Immune status unknown, above Category I ────────────────────────────
  //
  // The immunocompromised pathway differs in both RIG indication and route, so
  // an unknown immune status cannot be quietly treated as competent.
  final immunocompromised = a.immuneStatus == ImmuneStatus.immunocompromised;
  if (category != ExposureCategory.categoryI &&
      a.immuneStatus == ImmuneStatus.unknown) {
    missing.add('Immune status');
  }

  // ── Category I ─────────────────────────────────────────────────────────
  if (category == ExposureCategory.categoryI) {
    // "No prophylaxis needed (if reliable contact history is available)" —
    // the parenthesis is the whole rule, so it is enforced rather than shown.
    if (a.reliableHistory != Tri.yes) {
      missing.add('Reliable contact history');
      return RabiesRecommendation(
        category: category,
        categoryReason: derived.reason,
        pathway: RabiesPathway.cannotDecide,
        woundCareRequired: true,
        vaccineRequired: false,
        routeOptions: naiveSchedules,
        rigRequired: false,
        warnings: const [
          ClinicalWarning(
            'Category I contact, but the history is not established as '
            'reliable. Both sources withhold prophylaxis only when a reliable '
            'contact history is available — reassess before deciding not to '
            'treat.',
            WarningLevel.critical,
            GuidelineSource.ncdcNrcp,
          ),
          ...kStandingWarnings,
        ],
        instructions: const [
          Sourced(
            'Wash any contaminated skin. Reassess the history; if the contact '
            'cannot be established as Category I, treat according to the '
            'category that cannot be excluded.',
            GuidelineSource.ncdcNrcp,
          ),
        ],
        missing: missing,
      );
    }

    return RabiesRecommendation(
      category: category,
      categoryReason: derived.reason,
      pathway: RabiesPathway.noProphylaxis,
      woundCareRequired: true,
      vaccineRequired: false,
      routeOptions: naiveSchedules,
      rigRequired: false,
      warnings: const [
        ClinicalWarning(
          'All categories of bite should be reported in the NRCP monthly '
          'report.',
          WarningLevel.info,
          GuidelineSource.ncdcNrcp,
        ),
      ],
      instructions: const [
        Sourced(
          'No prophylaxis needed, as a reliable contact history is available.',
          GuidelineSource.ncdcNrcp,
        ),
        Sourced(
          'Wash exposed skin if it is contaminated, and reassess if any part '
          'of the history is in doubt.',
          GuidelineSource.ncdcNrcp,
        ),
      ],
      missing: missing,
    );
  }

  // Everything below is Category II or III.
  warnings.addAll(kStandingWarnings);

  // ── Re-exposure within 3 months of a completed PEP course ──────────────
  //
  // The one place the two sources give genuinely different ACTIONS, so the
  // answer depends on which source is selected and says so out loud.
  final recentPep = a.immunisationStatus == ImmunisationStatus.completedPEP &&
      a.daysSincePreviousPep != null &&
      a.daysSincePreviousPep! < 90;

  if (recentPep && !immunocompromised) {
    if (a.source == GuidelineSource.iap2022) {
      return RabiesRecommendation(
        category: category,
        categoryReason: derived.reason,
        pathway: RabiesPathway.woundCareOnlyRecentPep,
        woundCareRequired: true,
        vaccineRequired: false,
        routeOptions: boostSchedules,
        rigRequired: false,
        warnings: [
          const ClinicalWarning(
            'This is an IAP 2022-specific recommendation. The NRCP algorithm '
            'instead treats any future repeat exposure as previously '
            'immunised and gives 2 doses on days 0 and 3. Switch the source to '
            'compare before deciding.',
            WarningLevel.caution,
            GuidelineSource.iap2022,
          ),
          ...warnings,
        ],
        instructions: const [
          Sourced(
            'If repeat exposure occurs within 3 months of completion of PEP, '
            'only wound treatment is required — neither vaccine nor RIG are '
            'needed.',
            GuidelineSource.iap2022,
          ),
        ],
        missing: missing,
      );
    }
    instructions.add(const Sourced(
      'For Category II and III, if repeat exposure occurs in the future, treat '
      'as previously immunised and follow the algorithm — 2 doses on days 0 '
      'and 3. NRCP does not carry the IAP 3-month wound-care-only exemption.',
      GuidelineSource.ncdcNrcp,
    ));
  }

  // ── Immunocompromised ──────────────────────────────────────────────────
  //
  // Checked BEFORE the previously-immunised branch on purpose: a previously
  // immunised but immunocompromised child must not drop to the 2-dose
  // regimen. This branch is the reason the pathway is an enum rather than a
  // set of flags — nothing below can silently override it.
  if (immunocompromised) {
    final imSchedule = naiveSchedules
        .firstWhere((s) => s.route == VaccineRoute.intramuscular);
    return RabiesRecommendation(
      category: category,
      categoryReason: derived.reason,
      pathway: RabiesPathway.immunocompromised,
      woundCareRequired: true,
      vaccineRequired: true,
      schedule: imSchedule,
      // Only the IM option is offered: NRCP names the route explicitly.
      routeOptions: [imSchedule],
      rigRequired: true,
      warnings: [
        const ClinicalWarning(
          'IMMUNOCOMPROMISED — SPECIAL PROTOCOL. RIG is infiltrated in '
          'Category II as well as Category III, and the full vaccine course is '
          'given by the intramuscular route. Do not apply the standard '
          'immunocompetent pathway.',
          WarningLevel.critical,
          GuidelineSource.ncdcNrcp,
        ),
        ...warnings,
      ],
      instructions: [
        const Sourced(
          'Proper wound management, followed by local infiltration of RIG in '
          'both Category II and Category III exposures.',
          GuidelineSource.ncdcNrcp,
        ),
        const Sourced(
          'After this, a complete course of rabies vaccine by the '
          'intramuscular route should be undertaken in both Category II and '
          'Category III exposures.',
          GuidelineSource.ncdcNrcp,
        ),
        const Sourced(
          'RIG/RMAb is also indicated in Category II in immunocompromised '
          'patients.',
          GuidelineSource.iap2022,
        ),
        ...instructions,
      ],
      missing: [
        ...missing,
        if (a.weightKg == null) 'Weight, for the RIG/RMAb dose',
      ],
    );
  }

  // ── Previously immunised ───────────────────────────────────────────────
  if (a.immunisationStatus.countsAsPreviouslyImmunised) {
    final schedule = _pick(boostSchedules, a.preferredRoute, a.source);
    return RabiesRecommendation(
      category: category,
      categoryReason: derived.reason,
      pathway: RabiesPathway.previouslyImmunised,
      woundCareRequired: true,
      vaccineRequired: true,
      schedule: schedule,
      routeOptions: boostSchedules,
      rigRequired: false,
      rigCaveat:
          'RIG is not indicated in a previously immunised patient. Where '
          'direct nerve exposure is suspected, the treating physician may '
          'consider RIG infiltration — a clinician decision, not routine '
          'treatment.',
      warnings: [
        const ClinicalWarning(
          'Previously immunised means a DOCUMENTED complete previous '
          'pre-exposure or post-exposure course with modern vaccines. If the '
          'documentation cannot be produced, use the not-previously-immunised '
          'pathway.',
          WarningLevel.caution,
          GuidelineSource.ncdcNrcp,
        ),
        ...warnings,
      ],
      instructions: [
        const Sourced(
          'Two doses of vaccine, on days 0 and 3. No RIG/RMAb.',
          GuidelineSource.iap2022,
        ),
        ...instructions,
      ],
      missing: missing,
    );
  }

  // ── Not previously immunised, immunocompetent ──────────────────────────
  //
  // Undocumented and unknown histories land here, which is the safe side: a
  // full course given to someone who turns out to have been covered costs
  // vaccine; the reverse costs a life.
  if (a.immunisationStatus == ImmunisationStatus.uncertainDocumentation ||
      a.immunisationStatus == ImmunisationStatus.unknown) {
    warnings.insert(
      0,
      const ClinicalWarning(
        'Previous immunisation cannot be confirmed, so the '
        'not-previously-immunised pathway applies. Do not shorten the course '
        'on an undocumented history.',
        WarningLevel.caution,
        GuidelineSource.ncdcNrcp,
      ),
    );
  }

  final schedule = _pick(naiveSchedules, a.preferredRoute, a.source);
  final rig = category == ExposureCategory.categoryIII;

  return RabiesRecommendation(
    category: category,
    categoryReason: derived.reason,
    pathway: RabiesPathway.standardNaive,
    woundCareRequired: true,
    vaccineRequired: true,
    schedule: schedule,
    routeOptions: naiveSchedules,
    rigRequired: rig,
    rigCaveat: rig
        ? null
        : 'RIG is not indicated for Category II in an immunocompetent, '
            'previously unimmunised patient.',
    warnings: warnings,
    instructions: [
      if (rig)
        const Sourced(
          'Infiltrate the wounds with RIG as soon as possible.',
          GuidelineSource.ncdcNrcp,
        ),
      ...instructions,
    ],
    missing: [
      ...missing,
      if (rig && a.weightKg == null) 'Weight, for the RIG/RMAb dose',
    ],
  );
}

/// The two route options for a source and immunisation state.
List<VaccineSchedule> _schedulesFor(
  GuidelineSource source, {
  required bool previouslyImmunised,
}) {
  if (source == GuidelineSource.iap2022) {
    return previouslyImmunised
        ? const [kScheduleIdBoostIap, kScheduleImBoostIap]
        : const [kScheduleIdNaiveIap, kScheduleImNaiveIap];
  }
  return previouslyImmunised
      ? const [kScheduleIdBoostNcdc, kScheduleImBoostNcdc]
      : const [kScheduleIdNaiveNcdc, kScheduleImNaiveNcdc];
}

/// Chooses the schedule for the requested route.
///
/// With no preference stated, NRCP's own stated preference for the intradermal
/// route is honoured under NRCP; under IAP, which expresses no preference, the
/// intramuscular regimen is offered as the more widely available default. The
/// other route is always returned alongside in `routeOptions`, so this is a
/// starting point rather than a decision taken away from the clinician.
VaccineSchedule _pick(
  List<VaccineSchedule> options,
  VaccineRoute? preferred,
  GuidelineSource source,
) {
  if (preferred != null) {
    for (final s in options) {
      if (s.route == preferred) return s;
    }
  }
  final fallback = source == GuidelineSource.ncdcNrcp
      ? VaccineRoute.intradermal
      : VaccineRoute.intramuscular;
  for (final s in options) {
    if (s.route == fallback) return s;
  }
  return options.first;
}
