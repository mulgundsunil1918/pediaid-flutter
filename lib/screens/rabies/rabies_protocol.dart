// =============================================================================
// screens/rabies/rabies_protocol.dart — guideline DATA, no logic, no widgets
//
// WHY THIS FILE EXISTS SEPARATELY
// ------------------------------
// Two Indian sources govern rabies PEP and they do not agree everywhere. The
// temptation is to merge them into one "best" answer; that would be the worst
// possible outcome for a clinical tool, because the resulting recommendation
// would belong to no published guideline and could not be defended at a
// mortality meeting. So every recommendation here carries the source it came
// from, the differences are represented rather than resolved, and the engine
// is told which source to apply.
//
// SOURCES, TRANSCRIBED — NOT RECALLED
// -----------------------------------
//   IAP  — Indian Academy of Pediatrics, Standard Treatment Guidelines 2022,
//          "Rabies Prophylaxis in Children" (Ch-083). Lead author Anurag
//          Agarwal; co-authors Shivaprakash Sosale, Ashwath Narayan.
//          Read from the PDF on 2026-09-12.
//   NCDC — National Rabies Control Programme / NCDC, MoHFW, "Protocol for
//          Rabies Post Exposure Prophylaxis After Animal Bite" (the national
//          algorithm poster), read 2026-09-12; and National Guidelines for
//          Rabies Prophylaxis, 2019.
//   WHO  — cited where the IAP chapter itself cites it (Rabies vaccines: WHO
//          position paper, April 2018; WHO Expert Consultation on Rabies,
//          third report, 2018).
//
// Nothing in this file is inferred. Where a source is silent, the field says
// so rather than borrowing the other source's answer.
// =============================================================================

import 'package:flutter/material.dart';

/// The date every value in this file was checked against its source document.
///
/// A field, not a comment: a guideline tool that cannot say when it was last
/// verified is asking to be trusted on nothing.
final DateTime rabiesVerifiedOn = DateTime(2026, 9, 12);

// ── Sources ──────────────────────────────────────────────────────────────────

enum GuidelineSource { iap2022, ncdcNrcp, who }

extension GuidelineSourceX on GuidelineSource {
  String get label => switch (this) {
        GuidelineSource.iap2022 => 'IAP 2022',
        GuidelineSource.ncdcNrcp => 'NCDC / NRCP',
        GuidelineSource.who => 'WHO',
      };

  String get fullName => switch (this) {
        GuidelineSource.iap2022 =>
          'Indian Academy of Pediatrics — Standard Treatment Guidelines 2022, '
              'Rabies Prophylaxis in Children',
        GuidelineSource.ncdcNrcp =>
          'National Rabies Control Programme / NCDC, Ministry of Health & '
              'Family Welfare — Protocol for Rabies Post Exposure Prophylaxis '
              'After Animal Bite; National Guidelines for Rabies Prophylaxis, '
              '2019',
        GuidelineSource.who =>
          'World Health Organization — Rabies vaccines: WHO position paper, '
              'April 2018; WHO Expert Consultation on Rabies, third report, 2018',
      };

  String? get url => switch (this) {
        GuidelineSource.iap2022 =>
          'https://iapindia.org/pdf/Ch-083-Rabies-Prophylaxis-in-Children.pdf',
        GuidelineSource.ncdcNrcp =>
          'https://www.ncdc.mohfw.gov.in/wp-content/uploads/2024/07/PEP-Protocal.pdf',
        GuidelineSource.who => null,
      };
}

/// A statement plus the document it came from.
///
/// Used everywhere a recommendation is displayed, so a reader can always see
/// whose recommendation they are reading without leaving the screen.
@immutable
class Sourced {
  final String text;
  final GuidelineSource source;
  const Sourced(this.text, this.source);
}

// ── Exposure category ────────────────────────────────────────────────────────

enum ExposureCategory { categoryI, categoryII, categoryIII, uncertain }

extension ExposureCategoryX on ExposureCategory {
  String get label => switch (this) {
        ExposureCategory.categoryI => 'Category I',
        ExposureCategory.categoryII => 'Category II',
        ExposureCategory.categoryIII => 'Category III',
        ExposureCategory.uncertain => 'Category uncertain',
      };

  String get severity => switch (this) {
        ExposureCategory.categoryI => 'None',
        ExposureCategory.categoryII => 'Minor',
        ExposureCategory.categoryIII => 'Severe',
        ExposureCategory.uncertain => 'Not established',
      };
}

/// Category definitions, worded as the sources word them.
///
/// IAP 2022 and the NRCP poster give identical category definitions, which is
/// why there is one list rather than two.
const Map<ExposureCategory, List<String>> kCategoryDefinitions = {
  ExposureCategory.categoryI: [
    'Touching or feeding of animals',
    'Licks on intact skin',
  ],
  ExposureCategory.categoryII: [
    'Nibbling of uncovered skin',
    'Minor scratches or abrasions without bleeding',
  ],
  ExposureCategory.categoryIII: [
    'Single or multiple transdermal bites or scratches',
    'Licks on broken skin',
    'Contamination of mucous membrane with saliva',
  ],
  ExposureCategory.uncertain: [
    'The history does not establish a category with confidence',
  ],
};

// ── Contact types, and the category each maps to ─────────────────────────────

/// One selectable kind of contact.
///
/// `category` is the category that contact ALONE establishes. It is a floor,
/// not a verdict: bleeding or broken skin can raise it, which the engine
/// handles. Species is deliberately NOT part of this — no source grades
/// exposure by animal, and implying otherwise would be the single most
/// dangerous simplification available here.
@immutable
class ContactType {
  final String id;
  final String label;
  final ExposureCategory category;
  const ContactType(this.id, this.label, this.category);
}

const List<ContactType> kContactTypes = [
  ContactType('touch', 'Touching or feeding only', ExposureCategory.categoryI),
  ContactType('lick_intact', 'Lick on intact skin', ExposureCategory.categoryI),
  ContactType('nibble', 'Nibbling of uncovered skin', ExposureCategory.categoryII),
  ContactType('scratch_nobleed', 'Minor scratch or abrasion without bleeding',
      ExposureCategory.categoryII),
  ContactType('scratch_bleed', 'Scratch with bleeding',
      ExposureCategory.categoryIII),
  ContactType('bite_single', 'Single bite', ExposureCategory.categoryIII),
  ContactType('bite_multiple', 'Multiple bites', ExposureCategory.categoryIII),
  ContactType('bite_face', 'Bite involving face, head or neck',
      ExposureCategory.categoryIII),
  ContactType('lick_broken', 'Lick on broken skin', ExposureCategory.categoryIII),
  ContactType('mucosa_saliva', 'Saliva contact with eye or mouth',
      ExposureCategory.categoryIII),
  ContactType('mucosa_other', 'Other mucosal exposure',
      ExposureCategory.categoryIII),
];

// ── Animals ──────────────────────────────────────────────────────────────────

/// Species list, for the record only.
///
/// IAP 2022: rabies is transmitted to humans largely by dogs and cats (>97%);
/// wild animals (2%) such as mongoose, foxes, jackals, wild dogs, wild rodents,
/// and occasionally monkeys, horses, donkeys and others. Domestic rats, rabbits
/// and birds are ordinarily not known to transmit rabies.
///
/// The engine does not read this. It is documentation and context, because
/// species never decides PEP on its own.
const List<String> kAnimals = [
  'Dog',
  'Cat',
  'Monkey',
  'Bat',
  'Mongoose',
  'Fox / Jackal',
  'Other mammal',
  'Unknown animal',
  'Other',
];

/// Species IAP lists as not ordinarily transmitting rabies.
///
/// Shown as context next to the category, never as a reason to withhold PEP —
/// the category and the exposure history decide that.
const List<String> kLowRiskSpeciesNote = [
  'Domestic rats',
  'Rabbits',
  'Birds',
];

// ── Immunisation status ──────────────────────────────────────────────────────

enum ImmunisationStatus {
  never,
  completedPrEP,
  completedPEP,
  uncertainDocumentation,
  unknown,
}

extension ImmunisationStatusX on ImmunisationStatus {
  String get label => switch (this) {
        ImmunisationStatus.never => 'Never vaccinated',
        ImmunisationStatus.completedPrEP => 'Completed pre-exposure prophylaxis',
        ImmunisationStatus.completedPEP => 'Completed post-exposure prophylaxis',
        ImmunisationStatus.uncertainDocumentation =>
          'Previously vaccinated, documentation uncertain',
        ImmunisationStatus.unknown => 'Unknown',
      };

  /// True only for a status the sources accept as "previously immunised".
  ///
  /// Both documents define this the same way and both define it narrowly:
  /// NRCP — "Animal bite patient who can DOCUMENT previous history of complete
  /// post exposure or pre exposure prophylaxis by modern vaccines"; IAP — "can
  /// document previous PrEP or PEP".
  ///
  /// So uncertain and unknown are NOT previously immunised. Treating them as
  /// such would give a child two doses where they need five plus RIG, which is
  /// the most consequential error this module could make.
  bool get countsAsPreviouslyImmunised =>
      this == ImmunisationStatus.completedPrEP ||
      this == ImmunisationStatus.completedPEP;
}

enum ImmuneStatus { immunocompetent, immunocompromised, unknown }

extension ImmuneStatusX on ImmuneStatus {
  String get label => switch (this) {
        ImmuneStatus.immunocompetent => 'Immunocompetent',
        ImmuneStatus.immunocompromised => 'Immunocompromised',
        ImmuneStatus.unknown => 'Immune status unknown',
      };
}

// ── Vaccine route and schedules ──────────────────────────────────────────────

enum VaccineRoute { intradermal, intramuscular }

extension VaccineRouteX on VaccineRoute {
  String get label => switch (this) {
        VaccineRoute.intradermal => 'Intradermal (ID)',
        VaccineRoute.intramuscular => 'Intramuscular (IM)',
      };
  String get shortLabel =>
      this == VaccineRoute.intradermal ? 'ID' : 'IM';
}

/// One vaccination regimen: which days, how many sites, and whose rule it is.
@immutable
class VaccineSchedule {
  final String id;
  final String label;
  final VaccineRoute route;

  /// Days after the first dose. Day 0 is always first.
  final List<int> days;

  /// Sites injected per visit (ID regimens use 1 or 2; IM is always 1).
  final int sitesPerVisit;

  /// Dose per site as the source words it.
  final String dosePerSite;

  final GuidelineSource source;

  /// Free text the source attaches to this regimen, e.g. the "2–2–2–0–2"
  /// shorthand IAP prints beside the intradermal schedule.
  final String? note;

  const VaccineSchedule({
    required this.id,
    required this.label,
    required this.route,
    required this.days,
    required this.sitesPerVisit,
    required this.dosePerSite,
    required this.source,
    this.note,
  });

  /// "0 – 3 – 7 – 14 – 28"
  String get daysLabel => days.join(' – ');

  int get doseCount => days.length;
}

// Previously NOT immunised ----------------------------------------------------

/// IAP 2022: "Intramuscular route: One dose of vaccine administered on days
/// 0–3–7–14–28 (1–1–1–1–1)".
const kScheduleImNaiveIap = VaccineSchedule(
  id: 'im_naive_iap',
  label: 'IM, previously not immunised',
  route: VaccineRoute.intramuscular,
  days: [0, 3, 7, 14, 28],
  sitesPerVisit: 1,
  dosePerSite: '1 vial (full dose), 1 site',
  source: GuidelineSource.iap2022,
  note: 'One dose on each of days 0–3–7–14–28 (1–1–1–1–1).',
);

/// IAP 2022: "Intradermal route: 0.1 mL × 2 sites on days 0–3–7–28
/// (2–2–2–0–2)". Note the 0 in the shorthand — there is no day-14 visit.
const kScheduleIdNaiveIap = VaccineSchedule(
  id: 'id_naive_iap',
  label: 'ID, previously not immunised',
  route: VaccineRoute.intradermal,
  days: [0, 3, 7, 28],
  sitesPerVisit: 2,
  dosePerSite: '0.1 mL per site, 2 sites',
  source: GuidelineSource.iap2022,
  note: '0.1 mL × 2 sites on days 0–3–7–28 (2–2–2–0–2). There is no day-14 '
      'visit on the intradermal schedule.',
);

/// NRCP poster: "Give 05 doses OF RABIES VACCINE via intramuscular route - IM
/// (1 vial, 1 site) on day 0 - 3 - 7 - 14 - 28".
const kScheduleImNaiveNcdc = VaccineSchedule(
  id: 'im_naive_ncdc',
  label: 'IM, previously not immunised',
  route: VaccineRoute.intramuscular,
  days: [0, 3, 7, 14, 28],
  sitesPerVisit: 1,
  dosePerSite: '1 vial, 1 site',
  source: GuidelineSource.ncdcNrcp,
  note: '5 doses, one vial at one site per visit.',
);

/// NRCP poster: "Give 04 doses OF RABIES VACCINE via intradermal route - ID
/// (0.1 ml 2 sites) on day 0 - 3 - 7 - 28".
const kScheduleIdNaiveNcdc = VaccineSchedule(
  id: 'id_naive_ncdc',
  label: 'ID, previously not immunised',
  route: VaccineRoute.intradermal,
  days: [0, 3, 7, 28],
  sitesPerVisit: 2,
  dosePerSite: '0.1 mL per site, 2 sites',
  source: GuidelineSource.ncdcNrcp,
  note: '4 doses. NRCP advocates the intradermal route for rabies vaccine '
      'administration.',
);

// Previously immunised --------------------------------------------------------

/// IAP 2022: "Only two doses of vaccines on days 0 and 3 either by IM/ID …
/// 1-site IM vaccine administration on days 0 and 3".
const kScheduleImBoostIap = VaccineSchedule(
  id: 'im_boost_iap',
  label: 'IM, previously immunised',
  route: VaccineRoute.intramuscular,
  days: [0, 3],
  sitesPerVisit: 1,
  dosePerSite: '1 vial, 1 site',
  source: GuidelineSource.iap2022,
);

/// IAP 2022: "1-site ID vaccine (0.1 mL) administration on days 0 and 3".
/// Note this is ONE site, unlike the 2-site naive intradermal regimen.
const kScheduleIdBoostIap = VaccineSchedule(
  id: 'id_boost_iap',
  label: 'ID, previously immunised',
  route: VaccineRoute.intradermal,
  days: [0, 3],
  sitesPerVisit: 1,
  dosePerSite: '0.1 mL, 1 site',
  source: GuidelineSource.iap2022,
  note: 'One site, not two — the 2-site regimen is for previously '
      'unimmunised patients.',
);

/// NRCP poster: "Give 02 doses OF RABIES VACCINE via intramuscular route- IM
/// (1 vial, 1 site) on day 0 - 3".
const kScheduleImBoostNcdc = VaccineSchedule(
  id: 'im_boost_ncdc',
  label: 'IM, previously immunised',
  route: VaccineRoute.intramuscular,
  days: [0, 3],
  sitesPerVisit: 1,
  dosePerSite: '1 vial, 1 site',
  source: GuidelineSource.ncdcNrcp,
);

/// NRCP poster: "Give 02 doses OF RABIES VACCINE via intradermal route - ID
/// (0.1 ml 1 site) on day 0 - 3".
const kScheduleIdBoostNcdc = VaccineSchedule(
  id: 'id_boost_ncdc',
  label: 'ID, previously immunised',
  route: VaccineRoute.intradermal,
  days: [0, 3],
  sitesPerVisit: 1,
  dosePerSite: '0.1 mL, 1 site',
  source: GuidelineSource.ncdcNrcp,
);

const List<VaccineSchedule> kAllSchedules = [
  kScheduleImNaiveIap,
  kScheduleIdNaiveIap,
  kScheduleImNaiveNcdc,
  kScheduleIdNaiveNcdc,
  kScheduleImBoostIap,
  kScheduleIdBoostIap,
  kScheduleImBoostNcdc,
  kScheduleIdBoostNcdc,
];

// ── Pre-exposure prophylaxis (for reference, not part of the PEP engine) ─────

/// IAP 2022 PrEP regimens. Included because the chapter's own key points end
/// with "PrEP should be offered to all children", and because a clinician
/// reading this module is often being asked about it in the same consultation.
const List<VaccineSchedule> kPrEPSchedules = [
  VaccineSchedule(
    id: 'prep_im_iap',
    label: 'PrEP, intramuscular',
    route: VaccineRoute.intramuscular,
    days: [0, 7, 28],
    sitesPerVisit: 1,
    dosePerSite: '1 dose, 1 site',
    source: GuidelineSource.iap2022,
    note: 'Days 0, 7 and 21 or 28, into the anterolateral thigh or deltoid.',
  ),
  VaccineSchedule(
    id: 'prep_id_iap',
    label: 'PrEP, intradermal',
    route: VaccineRoute.intradermal,
    days: [0, 7, 28],
    sitesPerVisit: 1,
    dosePerSite: '0.1 mL',
    source: GuidelineSource.iap2022,
    note: 'Days 0, 7 and 21 or 28. Two-site intradermal administration on '
        'days 0 and 7 is also recommended.',
  ),
];

// ── Passive immunisation: RIG and RMAb products ──────────────────────────────

enum PassiveAgentKind { hrig, erig, rmabSingle, rmabCocktail, other }

/// A passive immunising agent with its dose and, where the source states one,
/// its potency.
///
/// `concentrationIuPerMl` is nullable and stays null for anything the source
/// does not state. Volume is never computed from a guessed concentration —
/// products differ, and a wrong volume is a wrong dose.
@immutable
class PassiveAgent {
  final PassiveAgentKind kind;
  final String label;

  /// International units per kilogram of body weight.
  final double iuPerKg;

  /// Potency as printed in the source, where it prints one.
  final double? concentrationIuPerMl;

  final GuidelineSource source;
  final String? skinTest;
  final String? note;

  const PassiveAgent({
    required this.kind,
    required this.label,
    required this.iuPerKg,
    required this.source,
    this.concentrationIuPerMl,
    this.skinTest,
    this.note,
  });
}

/// IAP 2022 and the NRCP poster agree on both immunoglobulin doses:
/// HRIG 20 IU/kg, ERIG 40 IU/kg.
const kHrig = PassiveAgent(
  kind: PassiveAgentKind.hrig,
  label: 'HRIG — human rabies immunoglobulin',
  iuPerKg: 20,
  source: GuidelineSource.iap2022,
  skinTest: 'No skin sensitivity test required.',
  note: 'Imported and expensive. Available in a prefilled syringe.',
);

const kErig = PassiveAgent(
  kind: PassiveAgentKind.erig,
  label: 'ERIG — equine rabies immunoglobulin',
  iuPerKg: 40,
  source: GuidelineSource.iap2022,
  skinTest: 'Use only after a skin sensitivity test, as per the product insert.',
  note: 'Indigenously manufactured.',
);

/// IAP 2022: "Human RMAb (single MAB): Dosage 3.33 IU/kg body weight.
/// Potency: 40 IU/mL".
const kRmabSingle = PassiveAgent(
  kind: PassiveAgentKind.rmabSingle,
  label: 'Human RMAb — single monoclonal antibody',
  iuPerKg: 3.33,
  concentrationIuPerMl: 40,
  source: GuidelineSource.iap2022,
  skinTest: 'No skin sensitivity test required.',
  note: 'Potency 40 IU/mL as stated in IAP 2022. Always confirm against the '
      'product in hand.',
);

/// IAP 2022: "Cocktail of RMAbs (Docaravimab and Miromavimab): Dosage 40 IU/kg
/// body weight. Potency: 600 IU/mL".
const kRmabCocktail = PassiveAgent(
  kind: PassiveAgentKind.rmabCocktail,
  label: 'RMAb cocktail — docaravimab + miromavimab',
  iuPerKg: 40,
  concentrationIuPerMl: 600,
  source: GuidelineSource.iap2022,
  skinTest: 'No skin sensitivity test required.',
  note: 'Potency 600 IU/mL as stated in IAP 2022. Always confirm against the '
      'product in hand.',
);

const List<PassiveAgent> kPassiveAgents = [
  kHrig,
  kErig,
  kRmabSingle,
  kRmabCocktail,
];

/// WHO, as cited by the IAP chapter.
const kWhoRmabPreference = Sourced(
  'If available, the use of rabies monoclonal antibodies instead of rabies '
  'immunoglobulin is encouraged.',
  GuidelineSource.who,
);

// ── Wound care ───────────────────────────────────────────────────────────────

/// The steps, in the order both sources give them.
///
/// Step 1 is first for a reason that is clinical, not editorial: IAP states
/// that early and proper local treatment reduces rabies risk by almost 50%,
/// which makes washing the single highest-yield act in the whole pathway —
/// and it is free, immediate, and requires nothing to be arranged.
const List<Sourced> kWoundCareSteps = [
  Sourced(
    'Wash the wound immediately. Every animal bite should be washed for '
    '10–15 minutes with a copious amount of water and soap — a detergent soap '
    'is preferable.',
    GuidelineSource.iap2022,
  ),
  Sourced(
    'Gently wash all scratches or wounds with mild soap and running water for '
    'at least 15 minutes, irrespective of exposure category, to decrease '
    'viral load.',
    GuidelineSource.ncdcNrcp,
  ),
  Sourced(
    'Allow the wound to dry for a few minutes.',
    GuidelineSource.iap2022,
  ),
  Sourced(
    'Apply an antiseptic — povidone-iodine or surgical spirit — to all wounds, '
    'to chemically inactivate or kill rabies virus at the bite site.',
    GuidelineSource.iap2022,
  ),
  Sourced(
    'Do not suture routinely. Routine suturing and surgical dressing are not '
    'recommended. A few stay sutures may be applied to stop bleeding, and only '
    'after RIG/RMAb has been infiltrated into the wounds.',
    GuidelineSource.iap2022,
  ),
  Sourced(
    'Give a tetanus-containing vaccine if indicated by the previous '
    'immunisation status.',
    GuidelineSource.iap2022,
  ),
  Sourced(
    'Consider anti-inflammatory treatment and antibiotics depending on the '
    'type of wound.',
    GuidelineSource.iap2022,
  ),
];

const kWoundCareHeadline = Sourced(
  'Rabies risk is reduced by almost 50% by early and proper local treatment '
  'of wounds.',
  GuidelineSource.iap2022,
);

// ── Injection site ───────────────────────────────────────────────────────────

const List<Sourced> kInjectionSiteRules = [
  Sourced(
    'Rabies vaccine should be administered in the deltoid muscle for adults '
    'and children, and in the anterolateral thigh for infants and small '
    'children.',
    GuidelineSource.ncdcNrcp,
  ),
  Sourced(
    'Rabies vaccine should NOT be injected in the gluteal region.',
    GuidelineSource.ncdcNrcp,
  ),
  Sourced(
    'For young children under 2 years, the anterolateral area of the thigh is '
    'recommended.',
    GuidelineSource.iap2022,
  ),
];

// ── RIG/RMAb administration ──────────────────────────────────────────────────

const List<Sourced> kRigAdministrationSteps = [
  Sourced(
    'Infiltrate as much of the calculated dose as is anatomically feasible '
    'into and around all the wounds.',
    GuidelineSource.iap2022,
  ),
  Sourced(
    'Inject into the edges and base of the wound(s) until traces of RIG/RMAb '
    'ooze out.',
    GuidelineSource.iap2022,
  ),
  Sourced(
    'Infiltrate carefully into or as close as possible to the wound(s) or '
    'exposure site, while avoiding compartment syndrome.',
    GuidelineSource.ncdcNrcp,
  ),
  Sourced(
    'For multiple bites the calculated dose may not be sufficient to '
    'infiltrate all wounds. Dilute the RIG/RMAb in sterile normal saline to a '
    'volume sufficient to inject all wounds.',
    GuidelineSource.iap2022,
  ),
  Sourced(
    'The remainder of the calculated dose does NOT need to be injected '
    'intramuscularly at a distance from the wound. It may be fractionated into '
    'smaller individual syringes for other patients, with aseptic precautions.',
    GuidelineSource.iap2022,
  ),
  Sourced(
    'RIG/RMAb is always used together with rabies vaccine, as early as '
    'possible. A full course of vaccination must follow, or treatment failure '
    'can occur.',
    GuidelineSource.iap2022,
  ),
];

/// The reason the passive agent exists at all, which is also the reason its
/// window closes.
const kRigWindowRationale = Sourced(
  'Vaccine-induced antibodies appear only after 7–14 days. During that window '
  'the patient is unprotected, which is why RIG/RMAb is given. It is '
  'administered once, as soon as possible after the bite, and not beyond day 7 '
  'after the first dose of vaccine.',
  GuidelineSource.iap2022,
);

/// Day after the first vaccine dose beyond which the passive agent is not
/// given. Both sources state day 7.
const int kRigWindowDays = 7;

// ── Fixed clinical warnings ──────────────────────────────────────────────────

enum WarningLevel { critical, caution, info }

@immutable
class ClinicalWarning {
  final String text;
  final WarningLevel level;
  final GuidelineSource source;
  const ClinicalWarning(this.text, this.level, this.source);
}

const List<ClinicalWarning> kStandingWarnings = [
  ClinicalWarning(
    'Rabies is almost always fatal once clinical disease develops. Indicated '
    'post-exposure prophylaxis must not be delayed.',
    WarningLevel.critical,
    GuidelineSource.iap2022,
  ),
  ClinicalWarning(
    'Do not delay wound washing while vaccination is being arranged.',
    WarningLevel.critical,
    GuidelineSource.ncdcNrcp,
  ),
  ClinicalWarning(
    'RIG/RMAb is for local infiltration into and around the wound — not for '
    'routine intramuscular injection at a distant site.',
    WarningLevel.critical,
    GuidelineSource.iap2022,
  ),
  ClinicalWarning(
    'Do not give RIG beyond the 7th day after the 1st vaccine dose on day 0.',
    WarningLevel.critical,
    GuidelineSource.ncdcNrcp,
  ),
  ClinicalWarning(
    'Do not inject rabies vaccine into the gluteal region.',
    WarningLevel.critical,
    GuidelineSource.ncdcNrcp,
  ),
  ClinicalWarning(
    'Immunocompromised patients follow a different pathway — RIG in Category '
    'II as well as Category III, and the intramuscular route.',
    WarningLevel.caution,
    GuidelineSource.ncdcNrcp,
  ),
  ClinicalWarning(
    'Treat a patient as previously immunised only on documented evidence of a '
    'complete previous PrEP or PEP course with modern vaccines.',
    WarningLevel.caution,
    GuidelineSource.ncdcNrcp,
  ),
  ClinicalWarning(
    'If a vaccine dose is delayed, resume or continue the regimen — do not '
    'restart it.',
    WarningLevel.caution,
    GuidelineSource.iap2022,
  ),
  ClinicalWarning(
    'If the exposure category is uncertain, seek specialist or public-health '
    'guidance rather than assuming Category I.',
    WarningLevel.caution,
    GuidelineSource.ncdcNrcp,
  ),
  ClinicalWarning(
    'All categories of bite should be reported in the NRCP monthly report.',
    WarningLevel.info,
    GuidelineSource.ncdcNrcp,
  ),
];

// ── Special situations ───────────────────────────────────────────────────────

@immutable
class SpecialSituation {
  final String id;
  final String title;
  final String body;
  final GuidelineSource source;
  final WarningLevel level;
  const SpecialSituation({
    required this.id,
    required this.title,
    required this.body,
    required this.source,
    this.level = WarningLevel.info,
  });
}

const List<SpecialSituation> kSpecialSituations = [
  SpecialSituation(
    id: 'immunocompromised',
    title: 'Immunocompromised child',
    body: 'Proper wound management followed by local infiltration of RIG in '
        'BOTH Category II and Category III exposures. After this, a complete '
        'course of rabies vaccine by the intramuscular route should be '
        'undertaken in both Category II and Category III exposures. IAP 2022 '
        'states the same principle: RIG/RMAb is also indicated in Category II '
        'in immunocompromised patients.',
    source: GuidelineSource.ncdcNrcp,
    level: WarningLevel.critical,
  ),
  SpecialSituation(
    id: 'pregnancy',
    title: 'Pregnancy',
    body: 'No condition, including pregnancy, is a contraindication to '
        'post-exposure prophylaxis. It is safe in all age groups.',
    source: GuidelineSource.iap2022,
  ),
  SpecialSituation(
    id: 'delayed_dose',
    title: 'A vaccine dose was delayed',
    body: 'Should a vaccine dose be delayed for any reason, the PEP regimen '
        'should be resumed or continued — NOT restarted. Give the missed dose '
        'as soon as possible and continue the remaining schedule.',
    source: GuidelineSource.iap2022,
    level: WarningLevel.caution,
  ),
  SpecialSituation(
    id: 'product_change',
    title: 'The vaccine product or route has to change mid-course',
    body: 'Changes in rabies vaccine product and/or the route of '
        'administration during the same PEP course are acceptable, if '
        'unavoidable, to ensure that the course is completed.',
    source: GuidelineSource.iap2022,
  ),
  SpecialSituation(
    id: 'multiple_wounds',
    title: 'Multiple wounds',
    body: 'The calculated dose of RIG/RMAb may not be sufficient to infiltrate '
        'all wounds. Dilute it in sterile normal saline to a volume sufficient '
        'to inject all of them. Distribute by wound size and depth, giving '
        'priority to the deepest and most contaminated.',
    source: GuidelineSource.iap2022,
    level: WarningLevel.caution,
  ),
  SpecialSituation(
    id: 'nerve_exposure',
    title: 'Previously vaccinated, direct nerve exposure suspected',
    body: 'RIG is not routinely indicated in a previously immunised patient. '
        'However, where direct nerve exposure is suspected, the treating '
        'physician may consider RIG infiltration. This is a clinician '
        'decision, not routine treatment.',
    source: GuidelineSource.ncdcNrcp,
    level: WarningLevel.caution,
  ),
  SpecialSituation(
    id: 'covid_vaccine',
    title: 'COVID vaccine and rabies vaccine together',
    body: 'Both can be given together at different sites, or at any interval, '
        'as both are killed vaccines.',
    source: GuidelineSource.iap2022,
  ),
  SpecialSituation(
    id: 'routine_immunisation',
    title: 'Routine immunisation status',
    body: 'Rabies post-exposure prophylaxis should be administered '
        'irrespective of previous routine vaccination status.',
    source: GuidelineSource.iap2022,
  ),
  SpecialSituation(
    id: 'prep_effect',
    title: 'The child had pre-exposure prophylaxis',
    body: 'Pre-exposure prophylaxis makes administration of RIG unnecessary '
        'after a bite. A routine PrEP booster or serology is recommended only '
        'where a continued high risk of exposure remains, such as laboratory '
        'work with rabies virus.',
    source: GuidelineSource.iap2022,
  ),
  SpecialSituation(
    id: 'animal_observation',
    title: 'Animal availability and observation',
    body: 'Category I requires a RELIABLE contact history before prophylaxis '
        'is withheld. Animal observation is a public-health activity that '
        'supports assessment; it is not a reason to delay prophylaxis that is '
        'otherwise indicated. If the animal is unavailable, has escaped, is '
        'behaving abnormally, or is suspected rabid, proceed on the exposure '
        'category and seek public-health guidance.',
    source: GuidelineSource.ncdcNrcp,
    level: WarningLevel.caution,
  ),
];

// ── Children: what is different ──────────────────────────────────────────────

const List<Sourced> kPaediatricPoints = [
  Sourced(
    'Post-exposure prophylaxis is safe in all age groups. No condition, '
    'including pregnancy, is a contraindication.',
    GuidelineSource.iap2022,
  ),
  Sourced(
    'There is no minimum age for rabies PEP. It is given whenever the exposure '
    'warrants it.',
    GuidelineSource.iap2022,
  ),
  Sourced(
    'The vaccine dose is NOT reduced because the patient is a child. A child '
    'receives the same dose as an adult; only the injection site changes.',
    GuidelineSource.iap2022,
  ),
  Sourced(
    'Infants and small children: anterolateral thigh. Older children: deltoid.',
    GuidelineSource.ncdcNrcp,
  ),
  Sourced(
    'Never the gluteal region.',
    GuidelineSource.ncdcNrcp,
  ),
  Sourced(
    'RIG and RMAb doses ARE weight-based, so a current weight is required '
    'before either can be calculated.',
    GuidelineSource.iap2022,
  ),
  Sourced(
    'PrEP should be offered to all children in an endemic country such as '
    'India.',
    GuidelineSource.iap2022,
  ),
];

// ── Where the two Indian sources differ ──────────────────────────────────────

/// One row of the guideline comparison.
///
/// This table is the reason the module has a source layer at all. Presenting a
/// merged answer would hide every one of these.
@immutable
class GuidelineDifference {
  final String topic;
  final String iap;
  final String ncdc;

  /// True where the two genuinely recommend different actions, as opposed to
  /// wording the same action differently.
  final bool material;

  const GuidelineDifference({
    required this.topic,
    required this.iap,
    required this.ncdc,
    this.material = false,
  });
}

const List<GuidelineDifference> kGuidelineDifferences = [
  GuidelineDifference(
    topic: 'Category definitions',
    iap: 'Categories I, II and III as listed.',
    ncdc: 'Identical definitions.',
  ),
  GuidelineDifference(
    topic: 'Wound washing',
    iap: '10–15 minutes with copious water and soap; detergent soap preferable. '
        'Antiseptic after the wound has dried.',
    ncdc: 'At least 15 minutes with mild soap and running water, irrespective '
        'of exposure category.',
  ),
  GuidelineDifference(
    topic: 'IM schedule, not previously immunised',
    iap: 'Days 0–3–7–14–28, one dose per visit.',
    ncdc: 'Days 0–3–7–14–28, 5 doses, 1 vial at 1 site.',
  ),
  GuidelineDifference(
    topic: 'ID schedule, not previously immunised',
    iap: '0.1 mL × 2 sites on days 0–3–7–28.',
    ncdc: '0.1 mL, 2 sites, 4 doses on days 0–3–7–28.',
  ),
  GuidelineDifference(
    topic: 'Route preference',
    iap: 'Both routes presented without preference.',
    ncdc: 'NRCP advocates the intradermal route for rabies vaccine '
        'administration.',
    material: true,
  ),
  GuidelineDifference(
    topic: 'Previously immunised',
    iap: '2 doses on days 0 and 3, by either route. 1-site ID (0.1 mL) or '
        '1-site IM.',
    ncdc: '2 doses on days 0 and 3. ID 0.1 mL at 1 site, or IM 1 vial at '
        '1 site.',
  ),
  GuidelineDifference(
    topic: 'RIG in Category II',
    iap: 'Not indicated, except in immunocompromised patients, where RIG/RMAb '
        'is indicated.',
    ncdc: 'Not indicated. For an immunocompromised person, local infiltration '
        'of RIG in both Category II and Category III.',
  ),
  GuidelineDifference(
    topic: 'Immunocompromised route',
    iap: 'States RIG/RMAb is indicated in Category II; does not separately '
        'restrict the route.',
    ncdc: 'Explicitly requires the complete vaccine course by the '
        'INTRAMUSCULAR route in both Category II and III.',
    material: true,
  ),
  GuidelineDifference(
    topic: 'Repeat exposure',
    iap: 'Re-exposure within 3 months of completing PEP: wound treatment only '
        '— neither vaccine nor RIG is needed.',
    ncdc: 'For Category II and III, if repeat exposure occurs in the future, '
        'treat as previously immunised and follow the algorithm — i.e. 2 doses '
        'on days 0 and 3.',
    material: true,
  ),
  GuidelineDifference(
    topic: 'RIG remainder',
    iap: 'Does not need to be injected IM at a distance; may be fractionated '
        'for other patients with aseptic precautions.',
    ncdc: 'Entire dose, or as much as anatomically feasible, infiltrated into '
        'or as close as possible to the wound while avoiding compartment '
        'syndrome.',
  ),
  GuidelineDifference(
    topic: 'Previously vaccinated with suspected nerve exposure',
    iap: 'Not addressed.',
    ncdc: 'The treating physician may consider RIG infiltration.',
    material: true,
  ),
  GuidelineDifference(
    topic: 'Rabies monoclonal antibodies',
    iap: 'Human RMAb 3.33 IU/kg (potency 40 IU/mL); RMAb cocktail 40 IU/kg '
        '(potency 600 IU/mL). WHO 2018 encourages RMAb over RIG where '
        'available.',
    ncdc: 'The poster algorithm addresses RIG dosage; it does not print RMAb '
        'doses.',
  ),
];

// ── Module metadata ──────────────────────────────────────────────────────────

const String kRabiesModuleTitle = 'Rabies & Animal Bite';
const String kRabiesModuleSubtitle =
    'Assessment, wound management and post-exposure prophylaxis in children';

const String kRabiesDisclaimer =
    'Clinical decision-support tool for healthcare professionals. This module '
    'is intended to support, not replace, clinical judgment, local protocols, '
    'product prescribing information and public-health guidance. In cases of '
    'uncertainty, severe exposure, immunocompromise or unusual circumstances, '
    'consult appropriate specialist or public-health services.';
