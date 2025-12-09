# id_doc_kit

A lightweight, production-ready Flutter/Dart toolkit for validating  
**Indian ID documents** with structured results and flexible form field support.

Perfect for **KYC, onboarding, fintech, business verification, and identity apps**.

---

## 🚀 Live Demo

Try it out in your browser! 👉 **[View Live Demo](https://jagadeeshpodilapu.github.io/id_doc_kit/)**

The demo showcases all supported document types with real-time validation feedback.

---

## ✅ Supported Documents

- ✅ **Aadhaar** (with Verhoeff checksum)
- ✅ **PAN**
- ✅ **Driving License** (basic format)
- ✅ **GSTIN** (basic structure + state code)
- ✅ **Voter ID (EPIC)** — 2–3 letters + 7 digits
- ✅ **Passport (Indian)** — 1 letter + 7 digits
- ✅ **Phone number** (India)
- ✅ **PIN code** (India)
- ✅ **Email** (basic format)



This makes `id_doc_kit` one of the most complete, developer-friendly **Indian document validation** packages on pub.dev.

---

## ✨ Key Features

- ✅ **Structured validation results**

  - `isValid`
  - `normalizedValue`
  - `errorCode` (e.g. `INVALID_FORMAT`, `INVALID_LENGTH`, `INVALID_CHECKSUM`)
  - `errorMessage` (human-friendly)

- ✅ **Single unified validator API**

  - `IdValidator.instance.validate(type: ..., value: ...)`
  - `IdValidator.instance.validateAuto(value)` _(optional)_

- ✅ **Three flexible ways to handle input fields**

  - `idFormFieldValidator` → logic only
  - `IdTextField` → ready-to-use widget
  - `IdField` → fully custom UI via builder

- 🔄 **Consistent behavior** across Aadhaar, PAN, DL, GSTIN, Voter ID, Passport
- 🚫 **No external APIs** (offline, fast, privacy-safe)
- 🌐 **Works on Android, iOS, Web**
- 🧪 **Well-tested & null-safe**

---
We validate driving licenses using a two-step approach:

1. **Comprehensive state-aware validation** (`DrivingLicenseStateValidator`)
  - Validates: state code, RTO, year (1988..currentYear+1), serial.
  - Options: `requiredState`, `strictMode`, `allowLegacyCodes`.

2. **Fallback permissive validation**
  - Applies a looser format (SS + RTO + YYYY + serial) only if comprehensive validation fails.
  - **Important:** fallback also validates the parsed year and serial to avoid false positives (error codes: `DL_FALLBACK_YEAR_INVALID`, `DL_FALLBACK_SERIAL_INVALID`).

Usage examples:

```dart
// Simple: package-level validator
final res = IdValidator.instance.validate(IdDocumentType.drivingLicense, 'KA0120210001234');
if (res.isValid) {
print('Normalized: ${res.normalizedValue}');
} else {
// show UI-friendly message
print(res.friendlyMessage);
}

// Strict mode (server-side)
final full = DrivingLicenseStateValidator.validate(
'OR0120150001234',
strictMode: true,
allowLegacyCodes: false,
);
if (!full.isValid) {
print(full.errorMessage);
}
```

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  id_doc_kit: ^0.0.8
```
