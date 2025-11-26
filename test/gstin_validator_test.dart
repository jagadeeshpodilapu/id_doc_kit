import 'package:flutter_test/flutter_test.dart';
import 'package:id_doc_kit/id_doc_kit.dart';

void main() {
  group('GSTIN validation', () {
    test('valid GSTIN passes basic structure', () {
      // 29 = Karnataka
      final result = IdValidator.instance.validate(
        type: IdDocumentType.gstin,
        value: '29ABCDE1234F1Z5',
      );

      expect(result.isValid, true);
      expect(result.normalizedValue, '29ABCDE1234F1Z5');
      expect(result.errorCode, isNull);
    });

    test('GSTIN with wrong length fails', () {
      final result = IdValidator.instance.validate(
        type: IdDocumentType.gstin,
        value: '29ABCDE1234F1Z', // 14 chars
      );

      expect(result.isValid, false);
      expect(result.errorCode, 'INVALID_LENGTH');
    });

    test('GSTIN with invalid state code fails', () {
      final result = IdValidator.instance.validate(
        type: IdDocumentType.gstin,
        value: '99ABCDE1234F1Z5', // 99 not in 01–37
      );

      expect(result.isValid, false);
      expect(result.errorCode, 'INVALID_FORMAT');
    });

    test('GSTIN with invalid PAN segment fails', () {
      final result = IdValidator.instance.validate(
        type: IdDocumentType.gstin,
        value: '29ABCD1234F1Z5X', // PAN part wrong
      );

      expect(result.isValid, false);
      expect(result.errorCode, 'INVALID_FORMAT');
    });
  });
}
