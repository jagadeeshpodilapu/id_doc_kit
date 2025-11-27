import '../models/id_document_type.dart';
import '../models/id_document_result.dart';
import 'base_validator.dart';

class PassportValidator extends BaseIdValidator {
  @override
  IdDocumentType get type => IdDocumentType.passport;

  @override
  IdDocumentResult validate(String input) {
    final raw = input;
    var normalized = normalize(input).toUpperCase();
    normalized = normalized.replaceAll(RegExp(r'\s+'), '');

    if (normalized.isEmpty) {
      return IdDocumentResult(
        type: type,
        rawValue: raw,
        isValid: false,
        errorCode: 'REQUIRED',
        errorMessage: 'Passport number is required.',
      );
    }

    // Common Indian passport format: 1 letter + 7 digits.
    // Use a conservative regex: first letter A-PR-WY (skipping some rarely-used letters)
    final regex = RegExp(r'^[A-PR-WY][0-9]{7}$');

    if (!regex.hasMatch(normalized)) {
      return IdDocumentResult(
        type: type,
        rawValue: raw,
        isValid: false,
        errorCode: 'INVALID_FORMAT',
        errorMessage: 'Passport format is invalid (e.g. A1234567).',
      );
    }

    return IdDocumentResult(
      type: type,
      rawValue: raw,
      isValid: true,
      normalizedValue: normalized,
    );
  }
}
