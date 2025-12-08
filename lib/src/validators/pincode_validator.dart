import 'base_validator.dart';
import '../models/id_document_result.dart';
import '../models/id_document_type.dart';

class PinCodeValidator extends BaseIdValidator {
  @override
  IdDocumentType get type => IdDocumentType.pinCode;

  @override
  IdDocumentResult validate(String input) {
    final raw = input;
    var normalized = normalize(input);
    normalized = normalized.replaceAll(RegExp(r'\s+'), '');
    // Keep only digits
    normalized = normalized.replaceAll(RegExp(r'\D'), '');

    if (normalized.isEmpty) {
      return IdDocumentResult(
        type: type,
        rawValue: raw,
        isValid: false,
        errorCode: 'REQUIRED',
        errorMessage: 'PIN code is required.',
      );
    }

    // Indian PIN: 6 digits, cannot start with 0
    final regex = RegExp(r'^[1-9][0-9]{5}$');
    if (!regex.hasMatch(normalized)) {
      return IdDocumentResult(
        type: type,
        rawValue: raw,
        isValid: false,
        errorCode: 'INVALID_FORMAT',
        errorMessage: 'PIN code must be 6 digits and cannot start with 0.',
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
