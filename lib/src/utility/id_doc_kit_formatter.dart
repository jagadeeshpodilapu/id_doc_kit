// Centralized formatter for ALL document types supported by id_doc_kit.
// Formatting is UI-friendly and non-destructive.
// Validators should still operate on normalized/strict values internally.

import 'package:id_doc_kit/id_doc_kit.dart';

class IdFormatter {
  /// Universal formatter entry point.
  /// Developers can call:
  ///   IdFormatter.format(IdDocumentType.pan, "ab cd e1234f");
  static String format(IdDocumentType type, String value) {
    switch (type) {
      case IdDocumentType.pan:
        return _formatPan(value);

      case IdDocumentType.aadhaar:
        return _formatAadhaar(value);

      case IdDocumentType.gstin:
        return _formatGstin(value);

      case IdDocumentType.drivingLicense:
        return _formatDrivingLicense(value);

      case IdDocumentType.voterId:
        return _formatVoter(value);

      case IdDocumentType.passport:
        return _formatPassport(value);

      case IdDocumentType.pinCode:
        return _formatPin(value);

      case IdDocumentType.phone:
        return _formatPhone(value);

      case IdDocumentType.email:
        return _formatEmail(value);
    }
  }

  // ---------------------------------------------------------------------------
  // PAN (ABCDE1234F)
  // ---------------------------------------------------------------------------
  static String _formatPan(String v) {
    return v.trim().toUpperCase().replaceAll(' ', '');
  }

  // ---------------------------------------------------------------------------
  // Aadhaar -> XXXX XXXX XXXX  (UI friendly)
  // ---------------------------------------------------------------------------
  static String _formatAadhaar(String v) {
    final digits = v.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) return '';

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 12; i++) {
      if (i != 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  // ---------------------------------------------------------------------------
  // GSTIN (uppercase, no spaces)
  // ---------------------------------------------------------------------------
  static String _formatGstin(String v) {
    return v.trim().toUpperCase().replaceAll(' ', '');
  }

  // ---------------------------------------------------------------------------
  // Driving License UI formatting
  // Attempts a pretty format: SS-RR-YYYY-NNNNNNN
  // Does NOT validate — validation occurs in DrivingLicenseValidator.
  // ---------------------------------------------------------------------------
  static String _formatDrivingLicense(String v) {
    final clean = v.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();

    // If too short, just return cleaned
    if (clean.length < 6) return clean;

    // Try splitting into SS RR YYYY SERIAL (best effort)
    try {
      final ss = clean.substring(0, 2);
      final rr = clean.substring(2, 4);
      final year = clean.length >= 8 ? clean.substring(4, 8) : '';
      final serial = clean.length > 8 ? clean.substring(8) : '';

      if (year.isEmpty) return clean;

      if (serial.isEmpty) return '$ss-$rr-$year';

      return '$ss-$rr-$year-$serial';
    } catch (_) {
      return clean;
    }
  }

  // ---------------------------------------------------------------------------
  // Voter ID (uppercase, no spaces)
  // ---------------------------------------------------------------------------
  static String _formatVoter(String v) {
    return v.trim().toUpperCase().replaceAll(' ', '');
  }

  // ---------------------------------------------------------------------------
  // Passport (uppercase, no spaces)
  // ---------------------------------------------------------------------------
  static String _formatPassport(String v) {
    return v.trim().toUpperCase().replaceAll(' ', '');
  }

  // ---------------------------------------------------------------------------
  // PIN (digits only)
  // ---------------------------------------------------------------------------
  static String _formatPin(String v) {
    return v
        .replaceAll(RegExp(r'[^0-9]'), '')
        .substring(0, v.length.clamp(0, 6));
  }

  // ---------------------------------------------------------------------------
  // Phone normalization:
  // - Remove non-digits
  // - Remove +91
  // - Remove leading 0
  // ---------------------------------------------------------------------------
  static String _formatPhone(String v) {
    var s = v.replaceAll(RegExp(r'[^0-9+]'), '');

    if (s.startsWith('+91')) {
      s = s.substring(3);
    }
    if (s.startsWith('0')) {
      s = s.substring(1);
    }

    return s;
  }

  // ---------------------------------------------------------------------------
  // Email -> lowercase (standard normalization)
  // ---------------------------------------------------------------------------
  static String _formatEmail(String v) {
    return v.trim().toLowerCase();
  }
}
