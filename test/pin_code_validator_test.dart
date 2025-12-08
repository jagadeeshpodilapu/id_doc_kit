import 'package:flutter_test/flutter_test.dart';
import 'package:id_doc_kit/id_doc_kit.dart';

void main() {
  final validator = IdValidator.instance;
  group('PIN Code Validator (IdValidator.instance)', () {
    test('valid 6-digit PIN returns valid result with normalizedValue', () {
      final result = validator.validate(
        type: IdDocumentType.pinCode,
        value: '560001',
      );

      expect(result, isA<IdDocumentResult>());
      expect(result.type, IdDocumentType.pinCode);
      expect(result.rawValue, '560001');
      expect(
        result.normalizedValue,
        '560001',
      ); // trimmed/numeric canonical form
      expect(result.isValid, isTrue);
      expect(result.errorCode, isNull);
      expect(result.errorMessage, isNull);
    });

    test('valid PIN with surrounding whitespace is normalized', () {
      final result = validator.validate(
        type: IdDocumentType.pinCode,
        value: ' 560001 ',
      );

      expect(result.isValid, isTrue);
      expect(result.normalizedValue, '560001');
    });

    test('invalid PIN - letters', () {
      final result = validator.validate(
        type: IdDocumentType.pinCode,
        value: '56A001',
      );

      expect(result.isValid, isFalse);
      expect(result.type, IdDocumentType.pinCode);
      expect(result.errorCode, isNotNull);
      expect(result.errorMessage, isNotNull);
    });

    test('invalid PIN - wrong length', () {
      final result = validator.validate(
        type: IdDocumentType.pinCode,
        value: '56001',
      ); // 5 digits

      expect(result.isValid, isFalse);
      expect(result.errorMessage, isNotNull);
    });
  });
}
