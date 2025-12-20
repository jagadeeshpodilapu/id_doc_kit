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
      return failure(
        raw,
        errorCode: 'REQUIRED',
        errorMessage: 'Voter ID is required.',
      );
    }

    // EPIC formats:
    // - 2 letters + 7 digits
    // - 3 letters + 7 digits
    final isValidFormat =
        RegExp(r'^[A-Z]{2}[0-9]{7}$').hasMatch(normalized) ||
        RegExp(r'^[A-Z]{3}[0-9]{7}$').hasMatch(normalized);

    if (!isValidFormat) {
      return failure(
        raw,
        errorCode: 'INVALID_FORMAT',
        errorMessage:
            'Voter ID must be 2–3 letters followed by 7 digits (e.g. ABC1234567).',
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
