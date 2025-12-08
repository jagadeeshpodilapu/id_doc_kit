import 'package:flutter_test/flutter_test.dart';
import 'package:id_doc_kit/id_doc_kit.dart';

void main() {
  final validator = IdValidator.instance;
  group('Phone Number Validator (IdValidator.instance)', () {
    test('plain 10-digit phone', () {
      final result = validator.validate(
        type: IdDocumentType.phone,
        value: '9123456789',
      );

      expect(result.isValid, isTrue);
      expect(result.type, IdDocumentType.phone);
      expect(result.rawValue, '9123456789');
      expect(result.normalizedValue, '9123456789');
      expect(result.errorCode, isNull);
    });

    test('with +91 prefix and separators is normalized to 10 digits', () {
      final result = validator.validate(
        type: IdDocumentType.phone,
        value: '+91 91234 56789',
      );

      expect(result.isValid, isTrue);
      expect(result.normalizedValue, '9123456789'); // typical normalization
    });

    test('with leading 0 is normalized', () {
      final result = validator.validate(
        type: IdDocumentType.phone,
        value: '09123456789',
      );

      expect(result.isValid, isTrue);
      expect(result.normalizedValue, '9123456789');
    });

    test('invalid phone - too short', () {
      final result = validator.validate(
        type: IdDocumentType.phone,
        value: '12345',
      );

      expect(result.isValid, isFalse);
      expect(result.errorMessage, isNotNull);
      expect(result.errorCode, isNotNull);
    });

    test('invalid phone - contains letters', () {
      final result = validator.validate(
        type: IdDocumentType.phone,
        value: '91234abcd9',
      );

      expect(result.isValid, isFalse);
    });
  });
}
