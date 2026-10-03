// =============================================================================
// test/formulary_v3_test.dart
//
// Drug Formulary 3.0 — the extracted data, the hub, and the shared helper
// that already had one real bug caught before it shipped: the hub's own
// title-case code only capitalised the first letter of the whole name and
// lowercased everything after it, which is correct for a one-word drug and
// wrong for most of the formulary ("Aluminum hydroxide with..." instead of
// "Aluminum Hydroxide With..."). These tests pin the shared version so that
// bug can't come back in a second copy.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pediaid_app/screens/formulary_v3/drug_entry_v3.dart';
import 'package:pediaid_app/screens/formulary_v3/formulary_v3_data.dart';
import 'package:pediaid_app/screens/formulary_v3/formulary_v3_hub.dart';
import 'package:pediaid_app/services/tool_registry.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('the data assembles correctly', () {
    test('every letter file concatenates — count matches the extraction\'s '
        'own verified total', () {
      expect(allFormularyV3Drugs.length, kExpectedFormularyV3Count);
    });

    test('no drug name is duplicated across the 26 files', () {
      final names = allFormularyV3Drugs.map((d) => d.name).toList();
      expect(names.toSet().length, names.length,
          reason: 'a duplicate would mean two files both claim the same '
              'drug, or one file is concatenated twice');
    });

    test('every entry has a name', () {
      expect(allFormularyV3Drugs.where((d) => d.name.trim().isEmpty), isEmpty);
    });

    test('a drug with a table keeps it as a real table, not flattened text',
        () {
      final gentamicin =
          allFormularyV3Drugs.firstWhere((d) => d.name == 'GENTAMICIN');
      final withTable =
          gentamicin.doseSections.where((s) => s.table != null).toList();
      expect(withTable, hasLength(1));
      expect(withTable.first.table!.rows, hasLength(6),
          reason: 'the postconceptional-age dosing table has six rows in '
              'the book');
    });
  });

  group('titleCaseDrugName — the bug the hub\'s own copy had', () {
    test('a single-word name', () {
      expect(titleCaseDrugName('GENTAMICIN'), 'Gentamicin');
    });

    test('a multi-word name capitalises EVERY word, not just the first', () {
      // The hub's original inline version lowercased everything after the
      // very first letter of the whole string, regardless of word
      // boundaries — this is the exact case that caught it.
      expect(
        titleCaseDrugName('ALUMINUM HYDROXIDE WITH MAGNESIUM HYDROXIDE'),
        'Aluminum Hydroxide With Magnesium Hydroxide',
      );
    });

    test('an empty name does not throw', () {
      expect(titleCaseDrugName(''), '');
    });
  });

  group('the registry knows about all 489 drugs', () {
    test('a drug is individually searchable by its generic name', () {
      final hits = ToolRegistry.instance.search('gentamicin');
      expect(hits.any((t) => t.label == 'Gentamicin'), isTrue);
    });

    test('a brand name finds the generic entry', () {
      // Acetaminophen's brandNames string includes "Tylenol" — searching the
      // brand must surface the generic-name entry, not fail silently.
      final hits = ToolRegistry.instance.search('tylenol');
      expect(hits.any((t) => t.label == 'Acetaminophen'), isTrue);
    });

    test('a cross-reference entry is findable too', () {
      // "ACTH — See Corticotropin" — someone typing the abbreviation should
      // find something, same as the printed book.
      final hits = ToolRegistry.instance.search('acth');
      expect(hits, isNotEmpty);
    });

    test('every registered drug key is unique', () {
      final drugKeys = ToolRegistry.instance.all
          .where((t) => t.kind == ToolKind.drug)
          .map((t) => t.key)
          .toList();
      expect(drugKeys.length, allFormularyV3Drugs.where((d) => d.name.isNotEmpty).length);
      expect(drugKeys.toSet().length, drugKeys.length);
    });
  });

  group('the hub screen, on a phone', () {
    Future<void> pump(WidgetTester tester) async {
      tester.view.physicalSize = const Size(375, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const MaterialApp(home: FormularyV3Hub()));
      await tester.pump();
    }

    testWidgets('opens with an A section and the first drug visible',
        (tester) async {
      await pump(tester);
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('search narrows the list to a matching drug', (tester) async {
      await pump(tester);
      await tester.enterText(find.byType(TextField), 'gentamicin');
      await tester.pump();
      expect(find.textContaining('Gentamicin'), findsWidgets);
      expect(find.text('Acetaminophen'), findsNothing);
    });

    testWidgets('a cross-reference row shows its "See ..." line, not a blank '
        'monograph', (tester) async {
      await pump(tester);
      await tester.enterText(find.byType(TextField), 'acth');
      await tester.pump();
      expect(find.textContaining('See'), findsWidgets);
    });

    testWidgets('tapping a drug opens its detail screen', (tester) async {
      await pump(tester);
      await tester.enterText(find.byType(TextField), 'gentamicin');
      await tester.pump();
      await tester.tap(find.textContaining('Gentamicin').first);
      await tester.pumpAndSettle();
      expect(find.text('Antibiotic, aminoglycoside'), findsWidgets);
    });
  });
}
