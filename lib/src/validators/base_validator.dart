import '../models/id_document_result.dart';
import '../models/id_document_type.dart';

abstract class BaseIdValidator {
  IdDocumentType get type;

  /// Validate the given [input] and return a structured result.
  IdDocumentResult validate(String input);

  /// Utility: normalize spacing / trim / uppercase
  String normalize(String input) {
    return input.trim();
  }
}
