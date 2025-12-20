import '../models/id_document_result.dart';
import '../models/id_document_type.dart';

abstract class BaseIdValidator {
  /// Document type handled by this validator
  IdDocumentType get type;

  /// Validate the given [input] and return a structured result.
  IdDocumentResult validate(String input);

  /// Base normalization hook.
  /// Subclasses should override if needed.
  String normalize(String input) {
    return input.trim();
  }

  /// Helper for successful validation results
  IdDocumentResult success(
    String rawValue, {
    String? normalizedValue,
    Map<String, dynamic>? meta,
    double confidence = 1.0,
  }) {
    return IdDocumentResult(
      type: type,
      rawValue: rawValue,
      normalizedValue: normalizedValue,
      isValid: true,
      meta: meta,
      confidence: confidence,
    );
  }

  /// Helper for failed validation results
  IdDocumentResult failure(
    String rawValue, {
    required String errorCode,
    required String errorMessage,
  }) {
    return IdDocumentResult(
      type: type,
      rawValue: rawValue,
      isValid: false,
      errorCode: errorCode,
      errorMessage: errorMessage,
      confidence: 0.0,
    );
  }
}
