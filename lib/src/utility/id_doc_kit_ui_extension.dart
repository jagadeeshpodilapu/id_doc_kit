import 'package:id_doc_kit/id_doc_kit.dart';

extension IdDocumentUIExtension on IdDocumentResult {
  /// Unified UI-friendly message for ANY IdDocumentResult.
  String get friendlyMessage {
    switch (type) {
      case IdDocumentType.aadhaar:
        return _aadhaarMessage();
      case IdDocumentType.pan:
        return _panMessage();
      case IdDocumentType.gstin:
        return _gstMessage();
      case IdDocumentType.drivingLicense:
        return _dlMessage();
      case IdDocumentType.voterId:
        return _voterMessage();
      case IdDocumentType.passport:
        return _passportMessage();
      case IdDocumentType.pinCode:
        return _pinMessage();
      case IdDocumentType.phone:
        return _phoneMessage();
      case IdDocumentType.email:
        return _emailMessage();
    }
  }

  // ---------------------------------------------------------------------------
  // AADHAAR MESSAGES
  // ---------------------------------------------------------------------------
  String _aadhaarMessage() {
    if (isValid) return 'Aadhaar number verified successfully';

    switch (errorCode) {
      case 'AADHAAR_EMPTY':
        return 'Please enter your Aadhaar number.';
      case 'AADHAAR_INVALID_LENGTH':
        return 'Aadhaar must be 12 digits.';
      case 'AADHAAR_INVALID_PATTERN':
        return 'Invalid Aadhaar number. Please re-check.';
      case 'AADHAAR_CHECKSUM_INVALID':
        return 'Invalid Aadhaar checksum.';
      default:
        return errorMessage ?? 'Invalid Aadhaar number.';
    }
  }

  // ---------------------------------------------------------------------------
  // PAN MESSAGES
  // ---------------------------------------------------------------------------
  String _panMessage() {
    if (isValid) return 'PAN verified';

    switch (errorCode) {
      case 'PAN_EMPTY':
        return 'Please enter your PAN number.';
      case 'PAN_INVALID_FORMAT':
        return 'Invalid PAN format. Example: ABCDE1234F';
      default:
        return errorMessage ?? 'Invalid PAN number.';
    }
  }

  // ---------------------------------------------------------------------------
  // GSTIN MESSAGES
  // ---------------------------------------------------------------------------
  String _gstMessage() {
    if (isValid) return 'GSTIN verified';

    switch (errorCode) {
      case 'GST_EMPTY':
        return 'Please enter GSTIN.';
      case 'GST_INVALID_FORMAT':
        return 'Invalid GSTIN format.';
      case 'GST_CHECKSUM_INVALID':
        return 'GSTIN checksum is incorrect.';
      default:
        return errorMessage ?? 'Invalid GSTIN.';
    }
  }

  // ---------------------------------------------------------------------------
  // DRIVING LICENSE MESSAGES
  // ---------------------------------------------------------------------------
  String _dlMessage() {
    if (isValid) {
      if (errorCode == 'DL_VALID_FALLBACK') {
        return 'Looks valid, but could not be fully verified. Please confirm.';
      }
      return 'Driving license verified';
    }

    switch (errorCode) {
      case 'DL_EMPTY':
        return 'Please enter your driving license number.';
      case 'DL_TOO_SHORT':
        return 'This number looks too short.';
      case 'DL_INVALID_FORMAT':
        return 'Invalid DL format. Example: KA0120210001234';
      case 'DL_UNKNOWN_STATE':
        return 'State code not recognized. Use codes like KA, MH, DL.';
      case 'DL_YEAR_INVALID':
        return 'Invalid issue year in the license.';
      case 'DL_SERIAL_INVALID':
        return 'Serial number appears invalid.';
      case 'DL_RTO_INVALID':
        return 'RTO code is invalid (should be 01–99).';
      default:
        return errorMessage ?? 'Invalid driving license.';
    }
  }

  // ---------------------------------------------------------------------------
  // VOTER ID MESSAGES
  // ---------------------------------------------------------------------------
  String _voterMessage() {
    if (isValid) return 'Voter ID verified';

    switch (errorCode) {
      case 'VOTER_EMPTY':
        return 'Please enter your Voter ID.';
      case 'VOTER_INVALID_FORMAT':
        return 'Invalid Voter ID format.';
      default:
        return errorMessage ?? 'Invalid Voter ID.';
    }
  }

  // ---------------------------------------------------------------------------
  // PASSPORT MESSAGES
  // ---------------------------------------------------------------------------
  String _passportMessage() {
    if (isValid) return 'Passport verified';

    switch (errorCode) {
      case 'PASSPORT_EMPTY':
        return 'Please enter your passport number.';
      case 'PASSPORT_INVALID_FORMAT':
        return 'Invalid passport format. Example: A1234567';
      default:
        return errorMessage ?? 'Invalid passport number.';
    }
  }

  // ---------------------------------------------------------------------------
  // PIN CODE MESSAGES
  // ---------------------------------------------------------------------------
  String _pinMessage() {
    if (isValid) return 'PIN code looks valid';

    switch (errorCode) {
      case 'PIN_EMPTY':
        return 'Please enter the PIN code.';
      case 'PIN_INVALID_LENGTH':
        return 'PIN code must be 6 digits.';
      case 'PIN_INVALID_CHARS':
        return 'PIN code must contain digits only.';
      default:
        return errorMessage ?? 'Invalid PIN code.';
    }
  }

  // ---------------------------------------------------------------------------
  // PHONE NUMBER MESSAGES
  // ---------------------------------------------------------------------------
  String _phoneMessage() {
    if (isValid) {
      if (errorCode == 'PHONE_VALID_FALLBACK') {
        return 'Phone accepted, but format was unclear. Please confirm.';
      }
      return 'Phone number verified';
    }

    switch (errorCode) {
      case 'PHONE_EMPTY':
        return 'Please enter your phone number.';
      case 'PHONE_TOO_SHORT':
        return 'This phone number looks too short.';
      case 'PHONE_TOO_LONG':
        return 'This phone number looks too long.';
      case 'PHONE_INVALID_CHARS':
        return 'Phone number must have digits only.';
      case 'PHONE_INVALID_FORMAT':
        return 'Invalid phone number format.';
      default:
        return errorMessage ?? 'Invalid phone number.';
    }
  }

  // ---------------------------------------------------------------------------
  // EMAIL MESSAGES
  // ---------------------------------------------------------------------------
  String _emailMessage() {
    if (isValid) return 'Email looks valid';

    switch (errorCode) {
      case 'EMAIL_EMPTY':
        return 'Please enter your email address.';
      case 'EMAIL_INVALID_FORMAT':
        return 'Invalid email format.';
      default:
        return errorMessage ?? 'Invalid email address.';
    }
  }
}
