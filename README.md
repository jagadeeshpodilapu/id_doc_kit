# id_doc_kit

A lightweight, production-ready Flutter/Dart package for validating Indian ID documents used in KYC, onboarding, and fintech workflows.

## Built with a strict core architecture, structured results, and UI-friendly helpers.

## 🚀 Live Demo

Try it out in your browser! 👉 **[View Live Demo](https://jagadeeshpodilapu.github.io/id_doc_kit/)**

The demo showcases all supported document types with real-time validation feedback.

---

## ✨ Supported Documents

✅ Aadhaar

✅ PAN

✅ GSTIN

✅ Driving License (strict + fallback)

✅ Voter ID (EPIC)

✅ Passport

✅ PIN Code (India)

✅ Phone Number (India)

✅ Email

This makes `id_doc_kit` one of the most complete, developer-friendly **Indian document validation** packages on pub.dev.

---

## ✨ Key Features

- ✅ Structured Validation Results:

```dart
IdDocumentResult {
  type,
  rawValue,
  normalizedValue,
  isValid,
  errorCode,
  errorMessage,
  confidence,
  meta
}
```

### 🧠 Confidence Score (NEW)

Each validation result includes a confidence score (0.0 → 1.0) indicating structural certainty.

---

| Scenario                                                 | Confidence   |
| -------------------------------------------------------- | ------------ |
| Strict deterministic validation (PAN, Aadhaar, Passport) | `1.0`        |
| Strong structure, no checksum (GSTIN, Phone, Email, PIN) | `0.9 – 0.95` |
| Driving License fallback validation                      | `0.6`        |
| Invalid                                                  | `0.0`        |

## ⚠️ Important:

Confidence represents structural validation only. This package does NOT verify documents against government databases.

---

### 🧩 Metadata (meta) for Advanced Use Cases

Validators expose parsed data via the meta field.

Example (Driving License):

```json
meta: {
  "stateCode": "KA",
  "stateName": "Karnataka",
  "rto": "01",
  "year": 2021,
  "serial": "0001234",
  "isLegacy": false,
  "isFallback": false
}
```

### 🪪 Driving License Validation (Important)

Driving Licenses are validated in two stages:

**1️⃣ Strict Validation (Preferred)**

- Validates state/UT code
- RTO range
- Year bounds
- Legacy handling
- Returns confidence = 1.0

**2️⃣ Fallback Validation**

- Structural format match only
- Used when strict validation fails
- Returns confidence = 0.6
- Clearly marked via meta.isFallback = true

This ensures maximum compatibility with real-world data while maintaining transparency.

### 🧪 Example Usage

```dart
final result = IdValidator.instance.validate(
  type: IdDocumentType.pan,
  value: 'ABCDE1234F',
);

if (result.isValid && result.confidence >= 0.9) {
  // Safe to proceed
}
```

### 🎨 UI-Friendly Widgets

**Quick integration:**

```dart
IdTextField(
  type: IdDocumentType.pan,
  onValidationChanged: (isValid) {},
);
```

**Full control:**

```dart
IdField(
  type: IdDocumentType.aadhaar,
  builder: (context, controller, result) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        errorText: result?.errorMessage,
      ),
    );
  },
);
```

### 🧠 Design Principles

- No standalone functions
- Single validation entry point
- Strict base architecture
- No backend calls
- No UI assumptions
- Fully testable

### 📌 Use Cases

- KYC onboarding
- Fintech apps
- Identity verification
- Form validation
- Government document input

### 🔐 Disclaimer

This package performs format and structural validation only.
It does not confirm document ownership or authenticity with issuing authorities.

## ☕ Support & Sponsorship

If `id_doc_kit` saves you development time or helps in production,
consider supporting its development.

<a href="https://buymeacoffee.com/jagadeesh" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="41" alt="Buy Me a Coffee">
</a>

Your support helps maintain accuracy, documentation, and long-term maintenance.



