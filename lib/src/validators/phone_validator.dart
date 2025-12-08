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
    // remove spaces, hyphens, parentheses
    normalized = normalized.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    // remove plus sign
    normalized = normalized.replaceAll('+', '');
    // keep only digits
    normalized = normalized.replaceAll(RegExp(r'\D'), '');

    if (normalized.isEmpty) {
      return IdDocumentResult(
        type: type,
        rawValue: raw,
        isValid: false,
        errorCode: 'REQUIRED',
        errorMessage: 'Phone number is required.',
      );
    }

    // handle leading country code or leading zero:
    // If starts with country code '91' and length > 10, take last 10 digits
    if (normalized.length > 10 && normalized.startsWith('91')) {
      normalized = normalized.substring(normalized.length - 10);
    } else if (normalized.length == 11 && normalized.startsWith('0')) {
      // leading 0 (0XXXXXXXXXX)
      normalized = normalized.substring(1);
    }

    // Now should be exactly 10 digits
    if (normalized.length != 10) {
      return IdDocumentResult(
        type: type,
        rawValue: raw,
        isValid: false,
        errorCode: 'INVALID_LENGTH',
        errorMessage: 'Phone number must be 10 digits.',
      );
    }

    // First digit must be 6-9 for Indian mobile numbers
    final regex = RegExp(r'^[6-9][0-9]{9}$');
    if (!regex.hasMatch(normalized)) {
      return IdDocumentResult(
        type: type,
        rawValue: raw,
        isValid: false,
        errorCode: 'INVALID_FORMAT',
        errorMessage: 'Enter a valid Indian mobile number.',
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
