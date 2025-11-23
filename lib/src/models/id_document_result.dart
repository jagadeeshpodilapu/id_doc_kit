import 'id_document_type.dart';

class IdDocumentResult {
  final IdDocumentType type;
  final String rawValue;
  final bool isValid;
  final String? normalizedValue;
  final String? errorCode;      // e.g. "INVALID_FORMAT", "INVALID_CHECKSUM"
  final String? errorMessage;   // human friendly

  const IdDocumentResult({
    required this.type,
    required this.rawValue,
    required this.isValid,
    this.normalizedValue,
    this.errorCode,
    this.errorMessage,
  });

  @override
  String toString() {
    return 'IdDocumentResult(type: $type, rawValue: $rawValue, '
        'isValid: $isValid, normalizedValue: $normalizedValue, '
        'errorCode: $errorCode, errorMessage: $errorMessage)';
  }
}
