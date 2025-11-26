import 'package:flutter_test/flutter_test.dart';
import 'package:id_doc_kit/id_doc_kit.dart';

void main() {
  group('Aadhaar validation', () {
    test('Aadhaar with random 12 digits fails checksum', () {
      const aadhaar = '999988887777';

      final result = IdValidator.instance.validate(
        type: IdDocumentType.aadhaar,
        value: aadhaar,
      );

      expect(result.isValid, false);
      expect(result.errorCode, 'INVALID_CHECKSUM');
    });

    test('Aadhaar with non-digits fails', () {
      final result = IdValidator.instance.validate(
        type: IdDocumentType.aadhaar,
        value: '9999A8887777',
      );

      expect(result.isValid, false);
      expect(result.errorCode, anyOf('INVALID_FORMAT', 'INVALID_LENGTH'));
    });

    test('Aadhaar with wrong length fails', () {
      final result = IdValidator.instance.validate(
        type: IdDocumentType.aadhaar,
        value: '12345678901', // 11 digits
      );

      expect(result.isValid, false);
      expect(result.errorCode, anyOf('INVALID_LENGTH', 'INVALID_FORMAT'));
    });

    test('Aadhaar with all same digits fails pattern', () {
      final result = IdValidator.instance.validate(
        type: IdDocumentType.aadhaar,
        value: '111111111111',
      );

      expect(result.isValid, false);
      expect(result.errorCode, 'INVALID_PATTERN');
    });
  });
}
