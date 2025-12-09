import 'package:flutter_test/flutter_test.dart';
import 'package:id_doc_kit/src/validators/dl_validator.dart';

void main() {
  final validator = DrivingLicenseValidator();

  test('comprehensive success (KA)', () {
    final r = validator.validate('KA0120210001234');
    expect(r.isValid, isTrue);
    expect(r.errorCode, isNull);
  });

  test('fallback accepted (unknown state)', () {
    final r = validator.validate('ZZ0119990001234');
    expect(r.isValid, isTrue);
    expect(r.errorCode, 'DL_VALID_FALLBACK');
  });

  test('completely invalid', () {
    final r = validator.validate('not a dl');
    expect(r.isValid, isFalse);
  });

  test('strict mode rejects legacy OR', () {
    final r = DrivingLicenseStateValidator.validate(
      'OR0120150001234',
      strictMode: true,
      allowLegacyCodes: false,
    );
    expect(r.isValid, isFalse);
    expect(r.errorCode, 'DL_STRICT_LEGACY');
  });
}
