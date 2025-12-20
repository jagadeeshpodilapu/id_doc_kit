import 'base_validator.dart';
import '../models/id_document_result.dart';
import '../models/id_document_type.dart';

class PhoneValidator extends BaseIdValidator {
  @override
  IdDocumentType get type => IdDocumentType.phone;

  @override
  IdDocumentResult validate(String input) {
    final raw = input;

    var normalized = normalize(input);

    // Remove spaces, hyphens, parentheses, plus sign
    normalized = normalized.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

    // Keep digits only
    normalized = normalized.replaceAll(RegExp(r'\D'), '');

    if (normalized.isEmpty) {
      return failure(
        raw,
        errorCode: 'REQUIRED',
        errorMessage: 'Phone number is required.',
      );
    }

    // Handle country code or leading zero
    if (normalized.length > 10 && normalized.startsWith('91')) {
      normalized = normalized.substring(normalized.length - 10);
    } else if (normalized.length == 11 && normalized.startsWith('0')) {
      normalized = normalized.substring(1);
    }

    // Must be exactly 10 digits
    if (normalized.length != 10) {
      return failure(
        raw,
        errorCode: 'INVALID_LENGTH',
        errorMessage: 'Phone number must be 10 digits.',
      );
    }

    // Indian mobile numbers start with 6–9
    if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(normalized)) {
      return failure(
        raw,
        errorCode: 'INVALID_FORMAT',
        errorMessage: 'Enter a valid Indian mobile number.',
      );
    }

    // SUCCESS (no checksum → confidence < 1.0)
    return success(
      raw,
      normalizedValue: normalized,
      confidence: 0.9,
      meta: {'country': 'IN'},
    );
  }
}
