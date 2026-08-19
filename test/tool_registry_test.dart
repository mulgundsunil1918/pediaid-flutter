// Guards the registry that Quick Access and Recents resolve shortcuts through.
// A tool whose key does not round-trip becomes a shortcut that does nothing
// when tapped — the exact failure this registry was built to remove.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pediaid_app/services/tool_registry.dart';
import 'package:pediaid_app/utils/share_message.dart';

void main() {
  final reg = ToolRegistry.instance;

  test('registry covers calculators and scores', () {
    expect(reg.calculators.length, greaterThan(50));
    expect(reg.scores.length, greaterThan(90));
    debugPrint('registry: ${reg.calculators.length} calculators, '
        '${reg.scores.length} scores, ${reg.all.length} total');
  });

  test('every key is unique and round-trips through byKey', () {
    final keys = reg.all.map((t) => t.key).toList();
    expect(keys.toSet().length, keys.length, reason: 'duplicate tool key');
    for (final t in reg.all) {
      expect(reg.byKey(t.key)?.label, t.label, reason: 'byKey failed: ${t.key}');
    }
  });

  test('every tool builds a real screen (no dead shortcuts)', () {
    for (final t in reg.all) {
      final w = t.build();
      expect(w, isNotNull, reason: '${t.key} built null');
      expect(w, isNot(isA<SizedBox>()),
          reason: '${t.key} (${t.label}) resolved to nothing');
    }
  });

  test('guides are pinnable too', () {
    expect(reg.guides.length, greaterThan(15));
    expect(reg.byKey(reg.guides.first.key), isNotNull);
  });

  test('share message carries the correct store links', () {
    // The drawer previously shipped App Store id 6748139585, sending every
    // iOS recipient to the wrong listing.
    expect(kShareMessage, contains('id6777623709'));
    expect(kShareMessage, isNot(contains('6748139585')));
    expect(kShareMessage, contains('id=com.pediaid.pediaid'));
  });

  test('search finds tools by label and by keyword', () {
    expect(reg.search('qtc'), isNotEmpty);
    expect(reg.search('zzzznotathing'), isEmpty);
  });
}

// Appended: guides became pinnable too, and the share message is a public
// claim that must not carry a stale store link.
