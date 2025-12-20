import 'base_validator.dart';
import '../models/id_document_result.dart';
import '../models/id_document_type.dart';

class PanValidator extends BaseIdValidator {
  static final RegExp _panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');

  @override
  IdDocumentType get type => IdDocumentType.pan;

  @override
  String normalize(String input) {
    return input.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '');
  }

  @override
  IdDocumentResult validate(String input) {
    final normalized = normalize(input);

    if (!_panRegex.hasMatch(normalized)) {
      return failure(
        input,
        errorCode: 'PAN_INVALID',
        errorMessage: 'Invalid PAN format',
      );
    }

    return success(
      input,
      normalizedValue: normalized,
      confidence: 1.0,
      meta: {
        'prefix': normalized.substring(0, 5),
        'number': normalized.substring(5, 9),
        'suffix': normalized.substring(9),
      },
    );
  }
}
