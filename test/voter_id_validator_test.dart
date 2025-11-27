import 'package:flutter_test/flutter_test.dart';
import 'package:id_doc_kit/src/validators/voter_id_validator.dart';

void main() {
  final validator = VoterIdValidator();

  group('VoterIdValidator', () {
    test('valid 3-letter format', () {
      final result = validator.validate('ABC1234567');
      expect(result.isValid, isTrue);
      expect(result.normalizedValue, equals('ABC1234567'));
    });

    test('valid 2-letter format', () {
      final result = validator.validate('AB1234567');
      expect(result.isValid, isTrue);
      expect(result.normalizedValue, equals('AB1234567'));
    });

    test('invalid format (letters missing)', () {
      final result = validator.validate('1234567890');
      expect(result.isValid, isFalse);
      expect(result.errorCode, equals('INVALID_FORMAT'));
    });

    test('empty value', () {
      final result = validator.validate('');
      expect(result.isValid, isFalse);
      expect(result.errorCode, equals('REQUIRED'));
    });

    test('lowercase input is normalized', () {
      final result = validator.validate('abc1234567');
      expect(result.isValid, isTrue);
      expect(result.normalizedValue, equals('ABC1234567'));
    });
  });
}
