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
      return failure(
        raw,
        errorCode: 'INVALID_LENGTH',
        errorMessage: 'GSTIN must be exactly 15 characters.',
      );
    }

    // GSTIN structure:
    // 01–37 (state code) + PAN + entity + Z + checksum
    final regex = RegExp(
      r'^'
      r'([0][1-9]|[1-2][0-9]|3[0-7])' // State code
      r'([A-Z]{5}[0-9]{4}[A-Z])' // PAN
      r'([0-9A-Z])' // Entity
      r'Z' // Default Z
      r'([0-9A-Z])' // Checksum (not fully validated yet)
      r'$',
    );

    final match = regex.firstMatch(normalized);
    if (match == null) {
      return failure(
        raw,
        errorCode: 'INVALID_FORMAT',
        errorMessage: 'GSTIN format is invalid.',
      );
    }

    // Extract meta information
    final stateCode = match.group(1)!;
    final pan = match.group(2)!;
    final entity = match.group(3)!;
    final checksum = match.group(4)!;

    // SUCCESS — strong structural validation (checksum not fully verified yet)
    return success(
      raw,
      normalizedValue: normalized,
      confidence: 0.95,
      meta: {
        'stateCode': stateCode,
        'pan': pan,
        'entity': entity,
        'checksum': checksum,
      },
    );
  }
}
