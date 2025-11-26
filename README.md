# id_doc_kit

A lightweight, production-ready Flutter/Dart toolkit for validating  
**Indian ID documents** with structured results and flexible form field support.

Perfect for **KYC, onboarding, fintech, verification, and identity apps**.

---

## ✅ Supported Documents

- ✅ Aadhaar (with Verhoeff checksum)
- ✅ PAN
- ✅ Driving License (basic format)
- ✅ GSTIN (basic structure + state code)

---

## ✨ Key Features

- ✅ **Structured validation results**
  - `isValid`
  - `normalizedValue`
  - `errorCode` (e.g. `INVALID_FORMAT`, `INVALID_LENGTH`, `INVALID_CHECKSUM`)
  - `errorMessage` (user-friendly)

- ✅ **Single unified validator API**
  - `IdValidator.instance.validate(...)`
  - `IdValidator.instance.validateAuto(...)`

- ✅ **Three flexible ways to handle input fields**
  - `idFormFieldValidator` → logic only
  - `IdTextField` → quick drop-in widget
  - `IdField` → fully custom UI using builder

- ✅ **Null-safe & production-ready**
- ✅ **Works on Android, iOS & Web**

---

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  id_doc_kit: ^0.0.3
