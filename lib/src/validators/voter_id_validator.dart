import '../models/id_document_type.dart';
import '../models/id_document_result.dart';
import 'base_validator.dart';

class VoterIdValidator extends BaseIdValidator {
  @override
  IdDocumentType get type => IdDocumentType.voterId;

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
        errorMessage: 'Voter ID is required.',
      );
    }

    // Accept both common formats:
    // 3 letters + 7 digits => ABC1234567
    // 2 letters + 7 digits => AB1234567
    final regex3 = RegExp(r'^[A-Z]{3}[0-9]{7}$');
    final regex2 = RegExp(r'^[A-Z]{2}[0-9]{7}$');

    if (!regex3.hasMatch(normalized) && !regex2.hasMatch(normalized)) {
      return IdDocumentResult(
        type: type,
        rawValue: raw,
        isValid: false,
        errorCode: 'INVALID_FORMAT',
        errorMessage:
            'Voter ID must be 2–3 letters followed by 7 digits (e.g. ABC1234567).',
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
