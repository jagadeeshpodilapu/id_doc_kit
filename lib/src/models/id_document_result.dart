import 'id_document_type.dart';

class IdDocumentResult {
  final IdDocumentType type;
  final String rawValue;
  final bool isValid;
  final String? normalizedValue;
  final String? errorCode;
  final String? errorMessage;
  final double confidence;
  final Map<String, dynamic>? metadata;

  const IdDocumentResult({
    required this.type,
    required this.rawValue,
    required this.isValid,
    this.normalizedValue,
    this.errorCode,
    this.errorMessage,
    this.confidence = 0.0,
    this.metadata,
  });

  @override
  String toString() {
    return 'IdDocumentResult(type: $type, rawValue: $rawValue, '
        'isValid: $isValid, normalizedValue: $normalizedValue, '
        'errorCode: $errorCode, errorMessage: $errorMessage, confidence: $confidence, metadata: $metadata)';
  }
}
