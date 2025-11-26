import 'base_validator.dart';
import '../models/id_document_result.dart';
import '../models/id_document_type.dart';

class GstinValidator extends BaseIdValidator {
  @override
  IdDocumentType get type => IdDocumentType.gstin;

  @override
  IdDocumentResult validate(String input) {
    final raw = input;
    var normalized = normalize(input).toUpperCase();
    normalized = normalized.replaceAll(RegExp(r'\s+'), '');

    // Basic length check
    if (normalized.length != 15) {
      return IdDocumentResult(
        type: type,
        rawValue: raw,
        isValid: false,
        errorCode: 'INVALID_LENGTH',
        errorMessage: 'GSTIN must be exactly 15 characters.',
      );
    }

    // Basic GSTIN structure:
    // 01–37 (state code) + PAN (AAAAA9999A) + 1 entity code + 'Z' + 1 checksum
    final regex = RegExp(
      r'^'
      r'([0][1-9]|[1-2][0-9]|3[0-7])' // 01–37 state code
      r'[A-Z]{5}[0-9]{4}[A-Z]' // PAN part
      r'[0-9A-Z]' // entity code
      r'Z' // default Z
      r'[0-9A-Z]' // checksum (we don’t fully verify checksum yet)
      r'$',
    );

    if (!regex.hasMatch(normalized)) {
      return IdDocumentResult(
        type: type,
        rawValue: raw,
        isValid: false,
        errorCode: 'INVALID_FORMAT',
        errorMessage: 'GSTIN format is invalid.',
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
