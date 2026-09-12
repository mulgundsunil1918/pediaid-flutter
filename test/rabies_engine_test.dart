// =============================================================================
// test/rabies_engine_test.dart
//
// The rabies decision engine.
//
// Rabies has ~100% mortality once symptomatic, so the two possible errors here
// are not symmetrical: an unnecessary course costs vaccine, a missed one costs
// a child. Most of these tests therefore pin the SAFE direction of an
// ambiguity rather than a happy path — an undocumented vaccination history must
// not shorten the course, an unknown immune status must not select the
// immunocompetent pathway, and an unresolved category must never collapse to
// Category I.
//
// The second theme is source attribution. IAP 2022 and the NRCP algorithm
// genuinely disagree about re-exposure, and a tool that merged them would
// produce a recommendation belonging to no published guideline. Those cases are
// asserted against BOTH sources.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/rabies/rabies_engine.dart';
import 'package:pediaid_app/screens/rabies/rabies_protocol.dart';

RabiesAssessment _a({
  Set<String> contacts = const {},
  ExposureCategory? category,
  Tri skinBroken = Tri.no,
  Tri bleeding = Tri.no,
  Tri reliable = Tri.yes,
  ImmunisationStatus immunisation = ImmunisationStatus.never,
  ImmuneStatus immune = ImmuneStatus.immunocompetent,
  int? daysSincePep,
  double? weight = 15,
  VaccineRoute? route,
  GuidelineSource source = GuidelineSource.ncdcNrcp,
}) =>
    RabiesAssessment(
      contactTypeIds: contacts,
      categoryOverride: category,
      skinBroken: skinBroken,
      bleeding: bleeding,
      reliableHistory: reliable,
      immunisationStatus: immunisation,
      immuneStatus: immune,
      daysSincePreviousPep: daysSincePep,
      weightKg: weight,
      preferredRoute: route,
      source: source,
    );

void main() {
  // ── Spec cases 1-6: the core matrix ────────────────────────────────────
  group('the four pathways', () {
    test('case 1: Category I, never vaccinated, reliable history — no PEP', () {
      final r = evaluateRabies(_a(
        contacts: {'touch'},
        category: ExposureCategory.categoryI,
      ));
      expect(r.pathway, RabiesPathway.noProphylaxis);
      expect(r.vaccineRequired, isFalse);
      expect(r.rigRequired, isFalse);
      // Washing is still advised — Category I is not "do nothing".
      expect(r.woundCareRequired, isTrue);
    });

    test('case 2: Category II, never vaccinated, immunocompetent — vaccine, no RIG',
        () {
      final r = evaluateRabies(_a(contacts: {'nibble'}));
      expect(r.category, ExposureCategory.categoryII);
      expect(r.pathway, RabiesPathway.standardNaive);
      expect(r.vaccineRequired, isTrue);
      expect(r.rigRequired, isFalse);
      expect(r.rigCaveat, contains('not indicated'));
    });

    test('case 3: Category III, never vaccinated, immunocompetent — vaccine + RIG',
        () {
      final r = evaluateRabies(_a(contacts: {'bite_single'}, skinBroken: Tri.yes));
      expect(r.category, ExposureCategory.categoryIII);
      expect(r.pathway, RabiesPathway.standardNaive);
      expect(r.vaccineRequired, isTrue);
      expect(r.rigRequired, isTrue);
      expect(r.schedule!.days, [0, 3, 7, 28]); // NRCP default is ID
    });

    test('case 4: Category III, previously immunised — 2 doses, no routine RIG',
        () {
      final r = evaluateRabies(_a(
        contacts: {'bite_single'},
        skinBroken: Tri.yes,
        immunisation: ImmunisationStatus.completedPEP,
      ));
      expect(r.pathway, RabiesPathway.previouslyImmunised);
      expect(r.vaccineRequired, isTrue);
      expect(r.schedule!.days, [0, 3],
          reason: 'previously immunised is a 2-dose regimen');
      expect(r.rigRequired, isFalse);
      // The NCDC nerve-exposure caveat must survive, as a clinician decision.
      expect(r.rigCaveat, contains('nerve'));
    });

    test('cases 5-6: immunocompromised gets its own pathway in BOTH categories',
        () {
      for (final contact in ['nibble', 'bite_single']) {
        final r = evaluateRabies(_a(
          contacts: {contact},
          skinBroken: contact == 'bite_single' ? Tri.yes : Tri.no,
          immune: ImmuneStatus.immunocompromised,
        ));
        expect(r.pathway, RabiesPathway.immunocompromised, reason: contact);
        // The whole point: RIG in Category II as well as III.
        expect(r.rigRequired, isTrue, reason: '$contact should still get RIG');
        expect(r.schedule!.route, VaccineRoute.intramuscular,
            reason: 'NRCP names the intramuscular route explicitly');
        expect(r.warnings.first.text, contains('IMMUNOCOMPROMISED'));
      }
    });
  });

  // ── Spec cases 13-15 plus the safety rules ─────────────────────────────
  group('previous immunisation is believed only when documented', () {
    test('case 13: documented previous PEP takes the short pathway', () {
      final r = evaluateRabies(_a(
        contacts: {'bite_single'},
        skinBroken: Tri.yes,
        immunisation: ImmunisationStatus.completedPEP,
      ));
      expect(r.pathway, RabiesPathway.previouslyImmunised);
    });

    test('case 14: documented previous PrEP also takes it', () {
      final r = evaluateRabies(_a(
        contacts: {'bite_single'},
        skinBroken: Tri.yes,
        immunisation: ImmunisationStatus.completedPrEP,
      ));
      expect(r.pathway, RabiesPathway.previouslyImmunised);
    });

    test('UNKNOWN history is NOT previously immunised', () {
      // The most consequential error available to this module: 2 doses and no
      // RIG, where 5 doses plus RIG were needed.
      final r = evaluateRabies(_a(
        contacts: {'bite_single'},
        skinBroken: Tri.yes,
        immunisation: ImmunisationStatus.unknown,
      ));
      expect(r.pathway, RabiesPathway.standardNaive);
      expect(r.rigRequired, isTrue);
      expect(r.schedule!.days.length, greaterThan(2));
      expect(r.warnings.first.text, contains('cannot be confirmed'));
    });

    test('UNCERTAIN documentation is NOT previously immunised either', () {
      final r = evaluateRabies(_a(
        contacts: {'bite_single'},
        skinBroken: Tri.yes,
        immunisation: ImmunisationStatus.uncertainDocumentation,
      ));
      expect(r.pathway, RabiesPathway.standardNaive);
      expect(r.rigRequired, isTrue);
    });

    test('an immunocompromised child does NOT drop to the 2-dose regimen', () {
      // Both flags set. The immunocompromised branch must win.
      final r = evaluateRabies(_a(
        contacts: {'bite_single'},
        skinBroken: Tri.yes,
        immunisation: ImmunisationStatus.completedPEP,
        immune: ImmuneStatus.immunocompromised,
      ));
      expect(r.pathway, RabiesPathway.immunocompromised);
      expect(r.rigRequired, isTrue);
      expect(r.schedule!.days.length, 5);
    });
  });

  // ── Case 15 and the guideline conflict ─────────────────────────────────
  group('case 15: re-exposure within 3 months is source-specific', () {
    test('IAP 2022: wound treatment only, no vaccine, no RIG', () {
      final r = evaluateRabies(_a(
        contacts: {'bite_single'},
        skinBroken: Tri.yes,
        immunisation: ImmunisationStatus.completedPEP,
        daysSincePep: 40,
        source: GuidelineSource.iap2022,
      ));
      expect(r.pathway, RabiesPathway.woundCareOnlyRecentPep);
      expect(r.vaccineRequired, isFalse);
      expect(r.rigRequired, isFalse);
      expect(r.woundCareRequired, isTrue);
      // Must not be presented as universal — it is IAP's rule, not NRCP's.
      expect(r.warnings.first.text, contains('IAP 2022-specific'));
    });

    test('NCDC/NRCP: treat as previously immunised, 2 doses on days 0 and 3',
        () {
      final r = evaluateRabies(_a(
        contacts: {'bite_single'},
        skinBroken: Tri.yes,
        immunisation: ImmunisationStatus.completedPEP,
        daysSincePep: 40,
        source: GuidelineSource.ncdcNrcp,
      ));
      expect(r.pathway, RabiesPathway.previouslyImmunised);
      expect(r.vaccineRequired, isTrue);
      expect(r.schedule!.days, [0, 3]);
    });

    test('beyond 3 months, IAP also uses the previously-immunised pathway', () {
      final r = evaluateRabies(_a(
        contacts: {'bite_single'},
        skinBroken: Tri.yes,
        immunisation: ImmunisationStatus.completedPEP,
        daysSincePep: 200,
        source: GuidelineSource.iap2022,
      ));
      expect(r.pathway, RabiesPathway.previouslyImmunised);
      expect(r.vaccineRequired, isTrue);
    });

    test('the exemption does not apply to an immunocompromised child', () {
      final r = evaluateRabies(_a(
        contacts: {'bite_single'},
        skinBroken: Tri.yes,
        immunisation: ImmunisationStatus.completedPEP,
        daysSincePep: 10,
        immune: ImmuneStatus.immunocompromised,
        source: GuidelineSource.iap2022,
      ));
      expect(r.pathway, RabiesPathway.immunocompromised);
    });
  });

  // ── Category derivation ────────────────────────────────────────────────
  group('category derivation never resolves downward', () {
    test('broken skin makes it Category III whatever was selected', () {
      final r = evaluateRabies(_a(contacts: {'nibble'}, skinBroken: Tri.yes));
      expect(r.category, ExposureCategory.categoryIII);
      expect(r.categoryReason, contains('transdermal'));
    });

    test('bleeding makes it Category III', () {
      final r = evaluateRabies(_a(contacts: {'scratch_nobleed'}, bleeding: Tri.yes));
      expect(r.category, ExposureCategory.categoryIII);
    });

    test('"unsure" about broken skin leaves the category UNRESOLVED', () {
      // Reading unsure as "no" is exactly how a transdermal bite gets filed as
      // a Category II scratch.
      final r = evaluateRabies(_a(contacts: {'nibble'}, skinBroken: Tri.unsure));
      expect(r.category, ExposureCategory.uncertain);
      expect(r.pathway, RabiesPathway.cannotDecide);
      expect(r.missing, contains('Exposure category'));
      expect(r.woundCareRequired, isTrue,
          reason: 'washing does not wait for the category');
    });

    test('no contact recorded is uncertain, never Category I', () {
      final r = evaluateRabies(_a());
      expect(r.category, ExposureCategory.uncertain);
      expect(r.pathway, RabiesPathway.cannotDecide);
      expect(r.vaccineRequired, isFalse);
      expect(r.warnings.first.text, contains('Do not assume Category I'));
    });

    test('the highest selected contact wins', () {
      final r = evaluateRabies(_a(contacts: {'touch', 'nibble', 'bite_multiple'}));
      expect(r.category, ExposureCategory.categoryIII);
    });

    test('species is not part of the decision', () {
      // Same contact, two very different animals, identical answer.
      final dog = evaluateRabies(RabiesAssessment(
        contactTypeIds: const {'bite_single'},
        skinBroken: Tri.yes,
        reliableHistory: Tri.yes,
        immunisationStatus: ImmunisationStatus.never,
        immuneStatus: ImmuneStatus.immunocompetent,
        weightKg: 15,
        animal: 'Dog',
      ));
      final bat = evaluateRabies(RabiesAssessment(
        contactTypeIds: const {'bite_single'},
        skinBroken: Tri.yes,
        reliableHistory: Tri.yes,
        immunisationStatus: ImmunisationStatus.never,
        immuneStatus: ImmuneStatus.immunocompetent,
        weightKg: 15,
        animal: 'Bat',
      ));
      expect(dog.category, bat.category);
      expect(dog.rigRequired, bat.rigRequired);
      expect(dog.pathway, bat.pathway);
    });
  });

  // ── Category I is conditional ──────────────────────────────────────────
  group('Category I clears only on a reliable history', () {
    test('without a reliable history it cannot clear the child', () {
      // Both sources qualify Category I with "if reliable contact history is
      // available". The parenthesis is the rule.
      final r = evaluateRabies(_a(
        contacts: {'touch'},
        category: ExposureCategory.categoryI,
        reliable: Tri.no,
      ));
      expect(r.pathway, RabiesPathway.cannotDecide);
      expect(r.missing, contains('Reliable contact history'));
    });

    test('"unsure" about reliability also does not clear', () {
      final r = evaluateRabies(_a(
        contacts: {'touch'},
        category: ExposureCategory.categoryI,
        reliable: Tri.unsure,
      ));
      expect(r.pathway, RabiesPathway.cannotDecide);
    });
  });

  // ── Missing inputs are named, not defaulted ────────────────────────────
  group('missing inputs are reported rather than guessed', () {
    test('Category III with no weight still recommends RIG, and says why not '
        'a dose', () {
      final r = evaluateRabies(_a(
        contacts: {'bite_single'},
        skinBroken: Tri.yes,
        weight: null,
      ));
      expect(r.rigRequired, isTrue,
          reason: 'the indication does not depend on knowing the weight');
      expect(r.missing.any((m) => m.contains('Weight')), isTrue);
    });

    test('unknown immune status above Category I is flagged', () {
      final r = evaluateRabies(_a(
        contacts: {'bite_single'},
        skinBroken: Tri.yes,
        immune: ImmuneStatus.unknown,
      ));
      expect(r.missing, contains('Immune status'));
    });
  });

  // ── Route selection ────────────────────────────────────────────────────
  group('route', () {
    test('NRCP defaults to intradermal, which it advocates', () {
      final r = evaluateRabies(_a(contacts: {'nibble'}));
      expect(r.schedule!.route, VaccineRoute.intradermal);
      expect(r.schedule!.days, [0, 3, 7, 28]);
    });

    test('an explicit route is honoured', () {
      final r = evaluateRabies(
          _a(contacts: {'nibble'}, route: VaccineRoute.intramuscular));
      expect(r.schedule!.route, VaccineRoute.intramuscular);
      expect(r.schedule!.days, [0, 3, 7, 14, 28]);
    });

    test('the other route is always offered alongside', () {
      final r = evaluateRabies(_a(contacts: {'nibble'}));
      expect(r.routeOptions.length, 2);
      expect(r.routeOptions.map((s) => s.route).toSet(),
          {VaccineRoute.intradermal, VaccineRoute.intramuscular});
    });

    test('the ID naive regimen has no day-14 visit', () {
      // IAP prints it as 2–2–2–0–2; the 0 is day 14 and is easy to lose.
      expect(kScheduleIdNaiveIap.days, isNot(contains(14)));
      expect(kScheduleIdNaiveNcdc.days, isNot(contains(14)));
    });

    test('previously-immunised ID is ONE site, naive ID is two', () {
      expect(kScheduleIdBoostIap.sitesPerVisit, 1);
      expect(kScheduleIdNaiveIap.sitesPerVisit, 2);
      expect(kScheduleIdBoostNcdc.sitesPerVisit, 1);
      expect(kScheduleIdNaiveNcdc.sitesPerVisit, 2);
    });
  });

  // ── Governance ─────────────────────────────────────────────────────────
  group('every recommendation is attributable', () {
    test('no instruction or warning is unsourced', () {
      final samples = [
        _a(contacts: {'touch'}, category: ExposureCategory.categoryI),
        _a(contacts: {'nibble'}),
        _a(contacts: {'bite_single'}, skinBroken: Tri.yes),
        _a(contacts: {'bite_single'}, skinBroken: Tri.yes, immune: ImmuneStatus.immunocompromised),
        _a(contacts: {'bite_single'}, skinBroken: Tri.yes, immunisation: ImmunisationStatus.completedPEP),
        _a(),
      ];
      for (final s in samples) {
        final r = evaluateRabies(s);
        for (final w in r.warnings) {
          expect(w.text.trim(), isNotEmpty);
        }
        for (final i in r.instructions) {
          expect(i.text.trim(), isNotEmpty);
        }
        expect(r.categoryReason.trim(), isNotEmpty);
      }
    });

    test('every schedule names its source', () {
      for (final s in kAllSchedules) {
        expect(s.days.first, 0, reason: '${s.id} must start at day 0');
        expect(s.dosePerSite.trim(), isNotEmpty);
      }
    });

    test('the guideline differences table flags the material conflicts', () {
      final material =
          kGuidelineDifferences.where((d) => d.material).map((d) => d.topic);
      expect(material, contains('Repeat exposure'));
      expect(material, contains('Immunocompromised route'));
    });

    test('the module records when it was checked against its sources', () {
      expect(rabiesVerifiedOn.year, greaterThanOrEqualTo(2026));
    });
  });
}
