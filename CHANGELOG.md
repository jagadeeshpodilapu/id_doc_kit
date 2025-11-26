## 0.0.4

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
