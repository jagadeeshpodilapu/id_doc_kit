import '../models/id_document_type.dart';
import '../models/id_document_result.dart';
import 'aadhaar_validator.dart';
import 'pan_validator.dart';
import 'dl_validator.dart';
import 'gstin_validator.dart';

class IdValidator {
  IdValidator._internal();

  static final IdValidator instance = IdValidator._internal();

  final _aadhaar = AadhaarValidator();
  final _pan = PanValidator();
  final _dl = DrivingLicenseValidator();
  final _gstin = GstinValidator();

  IdDocumentResult validate({
    required IdDocumentType type,
    required String value,
  }) {
    switch (type) {
      case IdDocumentType.aadhaar:
        return _aadhaar.validate(value);
      case IdDocumentType.pan:
        return _pan.validate(value);
      case IdDocumentType.drivingLicense:
        return _dl.validate(value);
      case IdDocumentType.gstin:
        return _gstin.validate(value);
    }
  }

  /// Optional: try to auto-detect type (very naive).
  IdDocumentResult validateAuto(String value) {
    final cleaned = value.replaceAll(RegExp(r'\s+'), '').toUpperCase();

    if (RegExp(r'^\d{12}$').hasMatch(cleaned)) {
      return validate(type: IdDocumentType.aadhaar, value: value);
    } else if (RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(cleaned)) {
      return validate(type: IdDocumentType.pan, value: value);
    } else if (RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][0-9A-Z]$',
    ).hasMatch(cleaned)) {
      return validate(type: IdDocumentType.gstin, value: value);
    } else {
      // Try DL as a last attempt
      final dlResult = validate(
        type: IdDocumentType.drivingLicense,
        value: value,
      );
      if (dlResult.isValid) return dlResult;

      return IdDocumentResult(
        type: IdDocumentType.drivingLicense,
        rawValue: value,
        isValid: false,
        errorCode: 'UNKNOWN_TYPE',
        errorMessage: 'Could not determine document type from input.',
      );
    }
  }
}
