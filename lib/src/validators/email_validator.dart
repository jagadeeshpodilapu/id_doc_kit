import 'base_validator.dart';
import '../models/id_document_result.dart';
import '../models/id_document_type.dart';

class EmailValidator extends BaseIdValidator {
  @override
  IdDocumentType get type => IdDocumentType.email;

  @override
  IdDocumentResult validate(String input) {
    final raw = input;
    var normalized = normalize(input).trim().toLowerCase();

    if (normalized.isEmpty) {
      return IdDocumentResult(
        type: type,
        rawValue: raw,
        isValid: false,
        errorCode: 'REQUIRED',
        errorMessage: 'Email is required.',
      );
    }

    // Practical, not-overly-strict regex used commonly
    final regex = RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');

    if (!regex.hasMatch(normalized)) {
      return IdDocumentResult(
        type: type,
        rawValue: raw,
        isValid: false,
        errorCode: 'INVALID_FORMAT',
        errorMessage: 'Enter a valid email address.',
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
