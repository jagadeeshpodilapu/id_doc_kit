import 'base_validator.dart';
import '../models/id_document_result.dart';
import '../models/id_document_type.dart';

class DrivingLicenseValidator extends BaseIdValidator {
  @override
  IdDocumentType get type => IdDocumentType.drivingLicense;

  @override
  IdDocumentResult validate(String input) {
    final raw = input;
    var normalized = normalize(input).toUpperCase();
    normalized = normalized.replaceAll(RegExp(r'\s+'), '');

    // Very basic pattern: e.g. AP16 20240012345 -> AP1620240012345
    final regex = RegExp(r'^[A-Z]{2}\d{2}\d{11}$');

    if (!regex.hasMatch(normalized)) {
      return IdDocumentResult(
        type: type,
        rawValue: raw,
        isValid: false,
        errorCode: 'INVALID_FORMAT',
        errorMessage:
            'Driving License must be 2 letters, 2 digits, and 11 digits (basic format).',
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
