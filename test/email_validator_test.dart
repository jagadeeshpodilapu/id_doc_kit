import 'package:flutter_test/flutter_test.dart';
import 'package:id_doc_kit/id_doc_kit.dart';

void main() {
  final validator = IdValidator.instance;
  group('Email Validator (IdValidator.instance)', () {
    test('valid email returns normalized lowercase', () {
      final result = validator.validate(
        type: IdDocumentType.email,
        value: ' Jane.DOE@Example.COM ',
      );

      expect(result.isValid, isTrue);
      expect(result.type, IdDocumentType.email);
      expect(result.rawValue, ' Jane.DOE@Example.COM ');
      expect(
        result.normalizedValue,
        'jane.doe@example.com',
      ); // trimmed + lowercased
      expect(result.errorCode, isNull);
    });

    test('valid email with +tag', () {
      final result = validator.validate(
        type: IdDocumentType.email,
        value: 'user+tag@sub.domain.co.in',
      );

      expect(result.isValid, isTrue);
      expect(result.normalizedValue, 'user+tag@sub.domain.co.in');
    });

    test('invalid email - missing @', () {
      final result = validator.validate(
        type: IdDocumentType.email,
        value: 'plainaddress',
      );

      expect(result.isValid, isFalse);
      expect(result.errorMessage, isNotNull);
    });

    test('invalid email - domain starting with dot', () {
      final result = validator.validate(
        type: IdDocumentType.email,
        value: 'user@.com',
      );

      expect(result.isValid, isFalse);
    });
  });
}
