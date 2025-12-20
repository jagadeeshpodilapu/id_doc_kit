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
      return failure(
        raw,
        errorCode: 'REQUIRED',
        errorMessage: 'Passport number is required.',
      );
    }

    // Indian passport format: 1 letter + 7 digits
    // Conservative range used
    if (!RegExp(r'^[A-PR-WY][0-9]{7}$').hasMatch(normalized)) {
      return failure(
        raw,
        errorCode: 'INVALID_FORMAT',
        errorMessage: 'Passport format is invalid (e.g. A1234567).',
      );
    }

    // SUCCESS — deterministic format → confidence = 1.0
    return success(
      raw,
      normalizedValue: normalized,
      confidence: 1.0,
      meta: {'country': 'IN'},
    );
  }
}
