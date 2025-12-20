import 'base_validator.dart';

import 'package:id_doc_kit/id_doc_kit.dart';

class DLStateCode {
  final String code;
  final String state;
  final String description;
  final bool isActive;

  const DLStateCode({
    required this.code,
    required this.state,
    required this.description,
    this.isActive = true,
  });

  @override
  String toString() => '$code: $state';
}

class DLValidationResult {
  final bool isValid;
  final String? errorMessage;
  final String? hint;
  final String? stateCode;
  final String? stateName;
  final String? rtoCode;
  final int? year;
  final String? serialNumber;
  final String? formattedDL;
  final bool? isLegacyCode;
  final String? stateDescription;
  final String? unknownStateCode;
  final String? errorCode;

  const DLValidationResult({
    required this.isValid,
    this.errorMessage,
    this.hint,
    this.stateCode,
    this.stateName,
    this.rtoCode,
    this.year,
    this.serialNumber,
    this.formattedDL,
    this.isLegacyCode,
    this.stateDescription,
    this.unknownStateCode,
    this.errorCode,
  });

  @override
  String toString() {
    if (isValid) {
      final legacy = isLegacyCode == true ? ' [LEGACY]' : '';
      return 'Valid DL: $formattedDL ($stateName)$legacy';
    } else {
      final hintText = hint != null ? '\nHint: $hint' : '';
      return 'Invalid DL: ${errorMessage ?? 'unknown'}$hintText';
    }
  }
}

// -------------------------
// DrivingLicenseStateValidator - comprehensive validator
// - Validates structure: SS (2 letters) + RR (1-2 digits) + YYYY (4 digits) + serial (4-8 digits)
// - Validates state code against a built-in list (active/legacy)
// - Performs RTO numeric range checks and year bounds (>=1988, <= currentYear + 1)
// - Options: requiredState, strictMode, allowLegacyCodes
// -------------------------
class DrivingLicenseStateValidator {
  // Core state/UT list. Keep this list updated from authoritative sources.
  static const List<DLStateCode> stateCodes = [
    // States (28)
    DLStateCode(
      code: 'AP',
      state: 'Andhra Pradesh',
      description: 'Andhra Pradesh (AP)',
    ),
    DLStateCode(
      code: 'AR',
      state: 'Arunachal Pradesh',
      description: 'Arunachal Pradesh',
    ),
    DLStateCode(code: 'AS', state: 'Assam', description: 'Assam'),
    DLStateCode(code: 'BR', state: 'Bihar', description: 'Bihar'),
    DLStateCode(code: 'CG', state: 'Chhattisgarh', description: 'Chhattisgarh'),
    DLStateCode(code: 'GA', state: 'Goa', description: 'Goa'),
    DLStateCode(code: 'GJ', state: 'Gujarat', description: 'Gujarat'),
    DLStateCode(code: 'HR', state: 'Haryana', description: 'Haryana'),
    DLStateCode(
      code: 'HP',
      state: 'Himachal Pradesh',
      description: 'Himachal Pradesh',
    ),
    DLStateCode(code: 'JH', state: 'Jharkhand', description: 'Jharkhand'),
    DLStateCode(code: 'KA', state: 'Karnataka', description: 'Karnataka'),
    DLStateCode(code: 'KL', state: 'Kerala', description: 'Kerala'),
    DLStateCode(
      code: 'MP',
      state: 'Madhya Pradesh',
      description: 'Madhya Pradesh',
    ),
    DLStateCode(code: 'MH', state: 'Maharashtra', description: 'Maharashtra'),
    DLStateCode(code: 'MN', state: 'Manipur', description: 'Manipur'),
    DLStateCode(code: 'ML', state: 'Meghalaya', description: 'Meghalaya'),
    DLStateCode(code: 'MZ', state: 'Mizoram', description: 'Mizoram'),
    DLStateCode(code: 'NL', state: 'Nagaland', description: 'Nagaland'),
    DLStateCode(code: 'OD', state: 'Odisha', description: 'Odisha (OD)'),
    DLStateCode(code: 'PB', state: 'Punjab', description: 'Punjab'),
    DLStateCode(code: 'RJ', state: 'Rajasthan', description: 'Rajasthan'),
    DLStateCode(code: 'SK', state: 'Sikkim', description: 'Sikkim'),
    DLStateCode(code: 'TN', state: 'Tamil Nadu', description: 'Tamil Nadu'),
    DLStateCode(code: 'TS', state: 'Telangana', description: 'Telangana'),
    DLStateCode(code: 'TR', state: 'Tripura', description: 'Tripura'),
    DLStateCode(
      code: 'UP',
      state: 'Uttar Pradesh',
      description: 'Uttar Pradesh',
    ),
    DLStateCode(code: 'UK', state: 'Uttarakhand', description: 'Uttarakhand'),
    DLStateCode(code: 'WB', state: 'West Bengal', description: 'West Bengal'),

    // Union Territories (8)
    DLStateCode(
      code: 'AN',
      state: 'Andaman and Nicobar Islands',
      description: 'Andaman and Nicobar Islands (UT)',
    ),
    DLStateCode(
      code: 'CH',
      state: 'Chandigarh',
      description: 'Chandigarh (UT)',
    ),
    DLStateCode(
      code: 'DD',
      state: 'Dadra and Nagar Haveli and Daman and Diu',
      description: 'Dadra and Nagar Haveli and Daman and Diu (UT)',
    ),
    DLStateCode(code: 'DL', state: 'Delhi', description: 'Delhi NCT (UT)'),
    DLStateCode(
      code: 'JK',
      state: 'Jammu and Kashmir',
      description: 'Jammu and Kashmir (UT)',
    ),
    DLStateCode(code: 'LA', state: 'Ladakh', description: 'Ladakh (UT)'),
    DLStateCode(
      code: 'LD',
      state: 'Lakshadweep',
      description: 'Lakshadweep (UT)',
    ),
    DLStateCode(
      code: 'PY',
      state: 'Puducherry',
      description: 'Puducherry (UT)',
    ),

    // Legacy / deprecated entries (kept for backward compatibility)
    DLStateCode(
      code: 'OR',
      state: 'Odisha (legacy OR)',
      description: 'Odisha legacy code OR',
      isActive: false,
    ),
    DLStateCode(
      code: 'DN',
      state: 'Dadra and Nagar Haveli (legacy)',
      description: 'Legacy DN',
      isActive: false,
    ),
    DLStateCode(
      code: 'DM',
      state: 'Daman (legacy)',
      description: 'Legacy DM',
      isActive: false,
    ),
  ];

  /// Return DLStateCode by code (case-insensitive). If includeInactive is false, only active states returned.
  static DLStateCode? getStateByCode(
    String code, {
    bool includeInactive = true,
  }) {
    final upper = code.toUpperCase();
    try {
      return stateCodes.firstWhere(
        (s) => s.code.toUpperCase() == upper && (includeInactive || s.isActive),
      );
    } catch (e) {
      return null;
    }
  }

  /// Suggest similar state codes for a mistyped code (simple heuristic)
  static List<String> suggestStateCode(String invalidCode) {
    final upper = invalidCode.toUpperCase();
    final List<String> suggestions = [];
    for (final s in stateCodes.where((x) => x.isActive)) {
      if (s.code == upper) {
        suggestions.add(s.code);
        continue;
      }
      if (s.code.startsWith(upper.substring(0, 1))) {
        suggestions.add(s.code);
      }
    }
    return suggestions.take(5).toList();
  }

  /// Comprehensive validator.
  ///
  /// Options:
  /// - requiredState: if provided, license must be from that state
  /// - strictMode: if true, apply stricter checks (reject legacy codes, reject DL leading-zero specifics for DL example)
  /// - allowLegacyCodes: whether to accept legacy codes such as OR (Odisha old)
  static DLValidationResult validate(
    String dlNumber, {
    String? requiredState,
    bool strictMode = false,
    bool allowLegacyCodes = true,
  }) {
    // Basic empty check
    if (dlNumber.trim().isEmpty) {
      return DLValidationResult(
        isValid: false,
        errorMessage: 'Driving License number cannot be empty',
        errorCode: 'DL_EMPTY',
      );
    }

    // normalize: remove spaces/hyphens/dots, uppercase
    final clean = dlNumber.trim().toUpperCase().replaceAll(
      RegExp(r'[^A-Z0-9]'),
      '',
    );

    // Pattern:
    // state: 2 letters (A-Z)
    // rto: 1-2 digits
    // year: 4 digits
    // serial: 4-8 digits
    final regex = RegExp(r'^([A-Z]{2})(\d{1,2})(\d{4})(\d{4,8})$');
    final match = regex.firstMatch(clean);
    if (match == null) {
      // Give length-oriented hints
      if (clean.length < 9) {
        return DLValidationResult(
          isValid: false,
          errorMessage: 'Too short to be a valid DL number',
          hint: 'Expected format: SS-RR-YYYY-NNNN (e.g., KA-01-2021-0001234)',
          errorCode: 'DL_TOO_SHORT',
        );
      }
      return DLValidationResult(
        isValid: false,
        errorMessage:
            'Invalid DL format. Expected state letters + digits (RTO/year/serial).',
        hint: 'Example: KA0120210001234',
        errorCode: 'DL_INVALID_FORMAT',
      );
    }

    final stateCode = match.group(1)!;
    final rtoStr = match.group(2)!;
    final yearStr = match.group(3)!;
    final serialStr = match.group(4)!;

    // State code check
    final state = getStateByCode(stateCode, includeInactive: allowLegacyCodes);
    if (state == null) {
      return DLValidationResult(
        isValid: false,
        errorMessage: 'Invalid state code: $stateCode',
        hint: 'Use valid state/UT codes like KA, MH, TN, DL',
        unknownStateCode: stateCode,
        errorCode: 'DL_UNKNOWN_STATE',
      );
    }

    // If a requiredState is provided, ensure it matches
    if (requiredState != null) {
      final required = getStateByCode(
        requiredState,
        includeInactive: allowLegacyCodes,
      );
      if (required == null) {
        return DLValidationResult(
          isValid: false,
          errorMessage: 'Invalid required state code: $requiredState',
          errorCode: 'DL_INVALID_REQUIRED_STATE',
        );
      }
      if (required.code.toUpperCase() != stateCode) {
        return DLValidationResult(
          isValid: false,
          errorMessage:
              'License must be from ${required.state} ($requiredState)',
          hint: 'Provided license is from ${state.state} ($stateCode)',
          stateCode: stateCode,
          stateName: state.state,
          errorCode: 'DL_REQUIRED_STATE_MISMATCH',
        );
      }
    }

    // Legacy state handling
    if (!state.isActive && strictMode) {
      return DLValidationResult(
        isValid: false,
        errorMessage:
            'Legacy state code: $stateCode is not allowed in strict mode',
        hint: state.description,
        stateCode: stateCode,
        stateName: state.state,
        isLegacyCode: true,
        errorCode: 'DL_STRICT_LEGACY',
      );
    }

    // RTO numeric range check
    final rtoInt = int.tryParse(rtoStr);
    if (rtoInt == null || rtoInt < 0 || rtoInt > 99) {
      return DLValidationResult(
        isValid: false,
        errorMessage: 'Invalid RTO code: $rtoStr',
        errorCode: 'DL_RTO_INVALID',
      );
    }

    // Delhi special-case (optional strict check)
    if (stateCode == 'DL' && strictMode) {
      // If strict, reject leading-zero RTO codes for Delhi (DL1 not DL01)
      if (rtoStr.length == 2 && rtoStr.startsWith('0')) {
        return DLValidationResult(
          isValid: false,
          errorMessage:
              'Delhi RTO code should not have a leading zero in strict mode',
          errorCode: 'DL_STRICT_RTO_DL',
        );
      }
    }

    // Year validation
    final yearInt = int.tryParse(yearStr);
    final currentYear = DateTime.now().year;
    if (yearInt == null || yearInt < 1988 || yearInt > currentYear + 1) {
      // Allow legacy/before-1988 only when not strict and allowLegacyCodes true
      if (!(allowLegacyCodes && !strictMode)) {
        return DLValidationResult(
          isValid: false,
          errorMessage:
              'Year must be between 1988 and ${currentYear + 1} (found: $yearStr)',
          hint: 'Motor Vehicles Act 1988 is a common lower bound',
          errorCode: 'DL_YEAR_INVALID',
        );
      }
    }

    // Serial numeric check
    final serialInt = int.tryParse(serialStr);
    if (serialInt == null || serialInt < 0) {
      return DLValidationResult(
        isValid: false,
        errorMessage: 'Invalid serial number',
        errorCode: 'DL_SERIAL_INVALID',
      );
    }

    // If we reach here, it's valid per comprehensive rules
    final formatted =
        '${stateCode.padRight(2)}-${rtoStr.padLeft(2, '0')}-$yearStr-$serialStr';

    return DLValidationResult(
      isValid: true,
      stateCode: stateCode,
      stateName: state.state,
      rtoCode: rtoStr,
      year: yearInt,
      serialNumber: serialStr,
      formattedDL: formatted,
      isLegacyCode: !state.isActive,
      stateDescription: state.description,
      errorCode: null,
    );
  }

  /// Format DL number (insert dashes). If input invalid or can't be parsed, returns original string.
  static String format(String dlNumber) {
    final clean = dlNumber.trim().toUpperCase().replaceAll(
      RegExp(r'[^A-Z0-9]'),
      '',
    );
    final regex = RegExp(r'^([A-Z]{2})(\d{1,2})(\d{4})(\d{4,8})$');
    final match = regex.firstMatch(clean);
    if (match == null) return dlNumber;
    final s = match.group(1)!;
    final r = match.group(2)!;
    final y = match.group(3)!;
    final sn = match.group(4)!;
    return '${s.padRight(2)}-${r.padLeft(2, '0')}-$y-$sn';
  }

  /// Return active state/UT list by default
  static List<DLStateCode> getAllStates({bool includeInactive = false}) {
    return includeInactive
        ? stateCodes
        : stateCodes.where((s) => s.isActive).toList();
  }

  /// Grouped states/UTs
  static Map<String, List<DLStateCode>> getStatesByType() {
    final states = <DLStateCode>[];
    final uts = <DLStateCode>[];
    for (var s in stateCodes.where((s) => s.isActive)) {
      if (s.description.contains('(UT)')) {
        uts.add(s);
      } else {
        states.add(s);
      }
    }
    return {'States': states, 'Union Territories': uts};
  }
}

class DrivingLicenseValidator extends BaseIdValidator {
  @override
  IdDocumentType get type => IdDocumentType.drivingLicense;

  @override
  IdDocumentResult validate(String input) {
    final raw = input;
    final normalized = _normalize(raw);

    // 1️⃣ Comprehensive validation
    final full = DrivingLicenseStateValidator.validate(normalized);

    if (full.isValid) {
      return success(
        raw,
        normalizedValue: full.formattedDL ?? normalized,
        confidence: 1.0,
        meta: {
          'stateCode': full.stateCode,
          'stateName': full.stateName,
          'rto': full.rtoCode,
          'year': full.year,
          'serial': full.serialNumber,
          'isLegacy': full.isLegacyCode ?? false,
          'isFallback': false,
        },
      );
    }

    // 2️⃣ Fallback validation (permissive)
    final fallbackRegex = RegExp(r'^([A-Z]{2})(\d{1,2})(\d{4})(\d{4,8})$');
    final m = fallbackRegex.firstMatch(normalized);

    if (m != null) {
      final stateCode = m.group(1)!;
      final rto = m.group(2)!;
      final year = int.tryParse(m.group(3)!);
      final serial = m.group(4)!;

      final formatted =
          '${stateCode.padRight(2)}-${rto.padLeft(2, '0')}-${m.group(3)}-$serial';

      return success(
        raw,
        normalizedValue: formatted,
        confidence: 0.6,
        meta: {
          'stateCode': stateCode,
          'rto': rto,
          'year': year,
          'serial': serial,
          'isFallback': true,
        },
      );
    }

    // 3️⃣ Invalid
    return failure(
      raw,
      errorCode: full.errorCode ?? 'DL_INVALID',
      errorMessage: 'Invalid driving license format. ${full.errorMessage ?? ''}'
          .trim(),
    );
  }

  String _normalize(String input) {
    return input.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  }
}
