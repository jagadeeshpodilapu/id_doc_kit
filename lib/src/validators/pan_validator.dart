import 'base_validator.dart';
import '../models/id_document_result.dart';
import '../models/id_document_type.dart';

class PanValidator extends BaseIdValidator {
  @override
  IdDocumentType get type => IdDocumentType.pan;

  @override
  IdDocumentResult validate(String input) {
    final raw = input;
    var normalized = normalize(input).toUpperCase();

    final regex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');

    if (!regex.hasMatch(normalized)) {
      return IdDocumentResult(
        type: type,
        rawValue: raw,
        isValid: false,
        errorCode: 'INVALID_FORMAT',
        errorMessage: 'PAN must be in the format AAAAA9999A.',
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
