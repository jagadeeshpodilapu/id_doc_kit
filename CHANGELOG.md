## 0.0.8 - Dl improvements

### Added
- `IdFormatter` — UI-friendly formatting helpers for PAN, Aadhaar, GSTIN, Driving License, Voter ID, Passport, PIN, Phone, Email.
- `autoFormat` option (default `true`) for `IdTextField` and `IdField` to format user input live.
- `idFormFieldValidator(..., autoFormat: true)` option to format before validation.


### Changed
- `IdTextField` / `IdField` updated to apply formatting + validation consistently (UI shows formatted text and friendly messages).
- README updated with formatter and autoFormat usage notes.
- Tests added for formatter behavior and key DL cases.

### Notes
- `autoFormat` is opt-out for developers who prefer raw input.
- For server-side validation use `DrivingLicenseStateValidator.validate` or call `IdFormatter.format(...)/IdValidator.validate(...)` on the server normalized data.

## 0.0.6 — KYC Essentials

- ✅ Added PIN code validator (India)
- ✅ Added Phone number validator (India)
- ✅ Added Email validator
- ✅ Added tests for new validators
- ✅ README updated with examples and demo link


## 0.0.4

### ✨ New Features
- Added **Voter ID (EPIC)** validation
  - Supports both 2–letter + 7 digits (e.g. AB1234567)
  - And 3–letter + 7 digits (e.g. ABC1234567)
- Added **Indian Passport** validation
  - Supports common format: 1 letter + 7 digits (e.g. A1234567)

### 🛠 Enhancements
- Updated `IdDocumentType` and `IdValidator` to support new document types.
- Improved README with updated examples and supported document list.

### 🧪 Testing
- Added new test suites for:
  - Voter ID validator
  - Passport validator

---

## 0.0.3

### ✨ New Features
- Added **GSTIN validation** (basic structure + state code check).
- Introduced a **flexible ID field system**:
  - `idFormFieldValidator` for custom `TextFormField`.
  - Improved `IdTextField` with safe validation callbacks and better controller handling.
  - New `IdField` builder for fully custom UI.

### 🧪 Testing & Quality
- Added unit tests for:
  - Aadhaar
  - PAN
  - Driving License
  - GSTIN
- Improved error handling coverage in tests to match real validator behaviour.

### 🛠 Improvements
- Refactored internal widget structure (single `id_fields.dart` entrypoint).
- Removed duplicate widget/typedef definitions.
- Fixed `setState()`-during-build issue in `IdTextField`.
- More consistent error codes and validation flow.

### 📱 Example App
- Updated example app to demonstrate:
  - `IdTextField` with PAN.
  - `TextFormField` + `idFormFieldValidator` for GSTIN.
  - `IdField` with custom Aadhaar UI and live validation feedback.

---

## 0.0.2
- Minor internal refactors and clean-up.

---

## 0.0.1 – Initial Release
- Initial support for:
  - Aadhaar validation (with checksum).
  - PAN validation.
  - Driving License validation (basic format).
- Core `IdValidator` API.
- Basic `IdTextField` widget.
