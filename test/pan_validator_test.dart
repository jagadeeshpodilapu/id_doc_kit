import 'package:flutter_test/flutter_test.dart';
import 'package:id_doc_kit/id_doc_kit.dart';

void main() {
  group('PAN validation', () {
    test('valid PAN passes', () {
      final result = IdValidator.instance.validate(
        type: IdDocumentType.pan,
        value: 'ABCDE1234F',
      );

      expect(result.isValid, true);
      expect(result.normalizedValue, 'ABCDE1234F');
      expect(result.errorCode, isNull);
    });

    test('PAN with wrong pattern fails', () {
      final result = IdValidator.instance.validate(
        type: IdDocumentType.pan,
        value: 'ABC1234EFG', // wrong order
      );

      expect(result.isValid, false);
      expect(result.errorCode, 'INVALID_FORMAT');
    });

    test('PAN with lowercase should normalize or fail consistently', () {
      final result = IdValidator.instance.validate(
        type: IdDocumentType.pan,
        value: 'abcde1234f',
      );

      // If you uppercase internally, this should be valid.
      // If not, adjust expectation.
      expect(result.isValid, true);
      expect(result.normalizedValue, 'ABCDE1234F');
    });
  });
}
