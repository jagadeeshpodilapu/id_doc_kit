import 'package:flutter_test/flutter_test.dart';
import 'package:id_doc_kit/id_doc_kit.dart';

void main() {
  group('Driving License validation', () {
    test('valid DL passes', () {
      // Example: KA01 202400012345
      final result = IdValidator.instance.validate(
        type: IdDocumentType.drivingLicense,
        value: 'KA0120240001234',
      );

      expect(result.isValid, true);
      expect(result.errorCode, isNull);
    });

    test('DL with wrong state code fails', () {
      final result = IdValidator.instance.validate(
        type: IdDocumentType.drivingLicense,
        value: '1A0120240001234',
      );

      expect(result.isValid, false);
      expect(result.errorCode, 'INVALID_FORMAT');
    });

    test('DL with wrong length fails', () {
      final result = IdValidator.instance.validate(
        type: IdDocumentType.drivingLicense,
        value: 'KA01202400012', // too short
      );

      expect(result.isValid, false);
      expect(result.errorCode, anyOf('INVALID_LENGTH', 'INVALID_FORMAT'));
    });
  });
}
