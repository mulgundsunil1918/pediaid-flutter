// Version comparison decides whether a released build is blocked. String
// comparison gets 1.10.0 vs 1.9.0 backwards, which would either strand users
// on a bad build or lock out a good one.
import 'package:flutter_test/flutter_test.dart';
import 'package:pediaid_app/services/app_config_service.dart';

void main() {
  group('compareVersions', () {
    test('equal', () => expect(compareVersions('1.2.0', '1.2.0'), 0));
    test('patch older', () => expect(compareVersions('1.2.0', '1.2.1') < 0, true));
    test('patch newer', () => expect(compareVersions('1.2.2', '1.2.1') > 0, true));
    test('double-digit minor beats single', () {
      expect(compareVersions('1.10.0', '1.9.0') > 0, true);   // string compare fails here
    });
    test('major dominates', () => expect(compareVersions('2.0.0', '1.99.99') > 0, true));
    test('build suffix ignored', () => expect(compareVersions('1.2.0+9', '1.2.0') , 0));
    test('missing segments treated as zero', () {
      expect(compareVersions('1.2', '1.2.0'), 0);
      expect(compareVersions('1.2', '1.2.1') < 0, true);
    });
    test('garbage does not throw', () {
      expect(() => compareVersions('x.y.z', '1.0.0'), returnsNormally);
    });
  });
}
