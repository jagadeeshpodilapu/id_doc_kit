import 'base_validator.dart';
import '../models/id_document_result.dart';
import '../models/id_document_type.dart';

class EmailValidator extends BaseIdValidator {
  @override
  IdDocumentType get type => IdDocumentType.email;

  @override
  IdDocumentResult validate(String input) {
    final raw = input;
    final normalized = normalize(input).toLowerCase();

    if (normalized.isEmpty) {
      return failure(
        raw,
        errorCode: 'REQUIRED',
        errorMessage: 'Email is required.',
      );
    }

    // Practical (not overly strict) email regex
    final regex = RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');

    if (!regex.hasMatch(normalized)) {
      return failure(
        raw,
        errorCode: 'INVALID_FORMAT',
        errorMessage: 'Enter a valid email address.',
      );
    }

    final domain = normalized.split('@').last;

    // SUCCESS — no checksum → confidence < 1.0
    return success(
      raw,
      normalizedValue: normalized,
      confidence: 0.9,
      meta: {'domain': domain},
    );
  }
}
