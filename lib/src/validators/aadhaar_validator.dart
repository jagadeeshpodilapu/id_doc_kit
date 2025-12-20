import 'base_validator.dart';
import '../models/id_document_result.dart';
import '../models/id_document_type.dart';

class AadhaarValidator extends BaseIdValidator {
  @override
  IdDocumentType get type => IdDocumentType.aadhaar;

  @override
  String normalize(String input) {
    return input.trim().replaceAll(RegExp(r'\s+'), '');
  }

  @override
  IdDocumentResult validate(String input) {
    final normalized = normalize(input);

    // Validate format: 12 digits
    if (!RegExp(r'^\d{12}$').hasMatch(normalized)) {
      return failure(
        input,
        errorCode: 'AADHAAR_INVALID_FORMAT',
        errorMessage: 'Aadhaar must be 12 digits',
      );
    }

    // Validate checksum using Verhoeff algorithm
    if (!_verhoeffValidate(normalized)) {
      return failure(
        input,
        errorCode: 'AADHAAR_CHECKSUM_INVALID',
        errorMessage: 'Invalid Aadhaar number',
      );
    }

    return success(
      input,
      normalizedValue: normalized,
      confidence: 1.0,
      meta: {'last4': normalized.substring(8)},
    );
  }

  // ---- Verhoeff implementation ----

  static const List<List<int>> _d = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
    [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
    [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
    [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
    [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
    [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
    [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
    [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
    [9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  ];

  static const List<List<int>> _p = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
    [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
    [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
    [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
    [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
    [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
    [7, 0, 4, 6, 9, 1, 3, 2, 5, 8],
  ];

  bool _verhoeffValidate(String num) {
    var c = 0;
    final reversed = num.split('').reversed.toList();
    for (var i = 0; i < reversed.length; i++) {
      final digit = int.parse(reversed[i]);
      c = _d[c][_p[i % 8][digit]];
    }
    return c == 0;
  }
}
