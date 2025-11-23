# id_doc_kit

A structured toolkit for validating **Indian ID documents** in Flutter apps.

Supports:

- ✅ Aadhaar (with Verhoeff checksum)
- ✅ PAN
- ✅ Driving License (basic format validation)
- ✅ Rich result models (not just `bool`)
- ✅ Flutter form field widget with built-in validation

> Perfect for onboarding / KYC flows in fintech and identity apps.

---

## ✨ Features

- **Structured results**  
  Get `IdDocumentResult` with:
    - `isValid`
    - `normalizedValue`
    - `errorCode` (e.g. `INVALID_FORMAT`, `INVALID_CHECKSUM`)
    - `errorMessage` (user-friendly)

- **Multiple document types**
    - `IdDocumentType.aadhaar`
    - `IdDocumentType.pan`
    - `IdDocumentType.drivingLicense`

- **Unified validator API**  
  Use a single `IdValidator.instance` for all types, or call `validateAuto` to try auto-detection.

- **Flutter widgets**
    - `IdTextField` → A `TextFormField` wrapper with built-in validation.

---

## 🧩 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  id_doc_kit: ^0.0.1
