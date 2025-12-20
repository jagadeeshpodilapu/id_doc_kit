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
    normalized = normalized.replaceAll(RegExp(r'\D'), '');

    if (normalized.isEmpty) {
      return failure(
        raw,
        errorCode: 'REQUIRED',
        errorMessage: 'PIN code is required.',
      );
    }

    // Indian PIN: 6 digits, cannot start with 0
    if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(normalized)) {
      return failure(
        raw,
        errorCode: 'INVALID_FORMAT',
        errorMessage: 'PIN code must be 6 digits and cannot start with 0.',
      );
    }

    // SUCCESS — no checksum → confidence < 1.0
    return success(
      raw,
      normalizedValue: normalized,
      confidence: 0.9,
      meta: {'country': 'IN'},
    );
  }
}
