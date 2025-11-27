import 'package:flutter_test/flutter_test.dart';
import 'package:id_doc_kit/src/validators/passport_validator.dart';

void main() {
  final validator = PassportValidator();

  group('PassportValidator', () {
    test('valid passport (A + 7 digits)', () {
      final result = validator.validate('A1234567');
      expect(result.isValid, isTrue);
      expect(result.normalizedValue, equals('A1234567'));
    });

    test('invalid passport wrong letter', () {
      // 'Q' or 'Z' are rarely used and likely invalid - our regex is conservative
      final result = validator.validate('Q1234567');
      expect(result.isValid, isFalse);
      expect(result.errorCode, equals('INVALID_FORMAT'));
    });

    test('invalid length', () {
      final result = validator.validate('A123'); // too short
      expect(result.isValid, isFalse);
      expect(result.errorCode, equals('INVALID_FORMAT'));
    });

    test('empty passport', () {
      final result = validator.validate('');
      expect(result.isValid, isFalse);
      expect(result.errorCode, equals('REQUIRED'));
    });

    test('lowercase input normalized', () {
      final result = validator.validate('a1234567');
      expect(result.isValid, isTrue);
      expect(result.normalizedValue, equals('A1234567'));
    });
  });
}
