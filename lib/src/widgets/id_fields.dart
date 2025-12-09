import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/id_document_type.dart';
import '../models/id_document_result.dart';
import '../utility/id_doc_kit_formatter.dart';
import '../validators/id_validator.dart';

/// Builds a custom error string based on the validation result.
typedef IdErrorBuilder = String? Function(IdDocumentResult result);

/// Core validator helper – use this with your own TextFormField.
FormFieldValidator<String> idFormFieldValidator(
  IdDocumentType type, {
  String? requiredMessage,
  bool allowEmpty = false,
  bool autoTrim = true,
  IdErrorBuilder? errorBuilder,
  bool autoFormat = true,
}) {
  return (String? value) {
    var text = value ?? '';

    if (autoTrim) {
      text = text.trim();
    }

    if (text.isEmpty) {
      if (allowEmpty) return null;
      return requiredMessage ?? 'Required';
    }

    // Optionally format the value before validating
    final toValidate = autoFormat ? IdFormatter.format(type, text) : text;

    final result = IdValidator.instance.validate(type: type, value: toValidate);

    if (!result.isValid) {
      if (errorBuilder != null) {
        return errorBuilder(result);
      }
      return result.errorMessage ?? 'Invalid ${type.name}';
    }

    return null;
  };
}

/// Configurable ID text field based on TextFormField.
class IdTextField extends StatefulWidget {
  final IdDocumentType type;
  final TextEditingController? controller;

  // Visuals & input behavior
  final InputDecoration? decoration;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final int? maxLength;
  final int? maxLines;
  final bool obscureText;
  final bool autoFormat;
  // Validation behavior
  final AutovalidateMode autovalidateMode;
  final String? requiredMessage;
  final bool allowEmpty;
  final bool autoTrim;
  final IdErrorBuilder? errorBuilder;

  // Callbacks
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? onValidationChanged;
  final FormFieldSetter<String>? onSaved;

  const IdTextField({
    super.key,
    required this.type,
    this.controller,
    this.decoration,
    this.style,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
    this.obscureText = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.requiredMessage,
    this.allowEmpty = false,
    this.autoTrim = true,
    this.errorBuilder,
    this.onChanged,
    this.onValidationChanged,
    this.onSaved,
    this.autoFormat = true,
  });

  @override
  State<IdTextField> createState() => _IdTextFieldState();
}

class _IdTextFieldState extends State<IdTextField> {
  late TextEditingController _controller;
  late FormFieldValidator<String> _validatorFn;
  bool? _lastValidState;
  bool _isApplyingFormat = false;

  bool get _ownsController => widget.controller == null;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _validatorFn = _createValidator();

    // If there's initial text and autoFormat is enabled, format it once
    if (widget.autoFormat && _controller.text.isNotEmpty) {
      final formatted = IdFormatter.format(widget.type, _controller.text);
      _controller.value = _controller.value.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(IdTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controller if it changed
    if (widget.controller != oldWidget.controller) {
      if (_ownsController) {
        _controller.dispose();
      }
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_onControllerChanged);
    }

    // Recreate validator if validation parameters changed
    if (widget.type != oldWidget.type ||
        widget.requiredMessage != oldWidget.requiredMessage ||
        widget.allowEmpty != oldWidget.allowEmpty ||
        widget.autoTrim != oldWidget.autoTrim ||
        widget.errorBuilder != oldWidget.errorBuilder ||
        widget.autoFormat != oldWidget.autoFormat) {
      _validatorFn = _createValidator();
      // Reset validation state since rules changed
      _lastValidState = null;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  FormFieldValidator<String> _createValidator() {
    return idFormFieldValidator(
      widget.type,
      requiredMessage: widget.requiredMessage,
      allowEmpty: widget.allowEmpty,
      autoTrim: widget.autoTrim,
      errorBuilder: widget.errorBuilder,
      autoFormat: widget.autoFormat,
    );
  }

  void _onControllerChanged() {
    if (_isApplyingFormat) return;

    final raw = _controller.text;
    final selection = _controller.selection;

    if (widget.autoFormat) {
      final formatted = IdFormatter.format(widget.type, raw);
      if (formatted != raw) {
        // apply formatting while preserving cursor position
        final baseOffset = selection.baseOffset;
        final isAtEnd = baseOffset >= raw.length;
        final newOffset = isAtEnd
            ? formatted.length
            : _preserveOffset(raw, formatted, baseOffset);

        _isApplyingFormat = true;
        _controller.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(
            offset: newOffset.clamp(0, formatted.length),
          ),
        );
        _isApplyingFormat = false;
      }
      _notifyChangeAndValidation(_controller.text);
    } else {
      _notifyChangeAndValidation(raw);
    }
  }

  void _handleChanged(String value) {
    // kept for backward compatibility if someone uses onChanged from TextFormField
    // but internal change handling will call onChanged via _notifyChangeAndValidation
  }

  void _notifyChangeAndValidation(String value) {
    // Call onChanged with the (possibly formatted) value
    widget.onChanged?.call(value);

    // Compute validation result using validator function
    final isValid = _validatorFn(value) == null;

    if (_lastValidState != isValid) {
      _lastValidState = isValid;
      widget.onValidationChanged?.call(isValid);
    }
  }

  int _preserveOffset(String oldText, String newText, int oldOffset) {
    // Heuristic: preserve count of alphanumeric chars before cursor
    final oldUpTo = oldText.substring(0, oldOffset.clamp(0, oldText.length));
    final alnumCount = oldUpTo.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').length;

    var seen = 0;
    for (var i = 0; i < newText.length; i++) {
      if (RegExp(r'[A-Za-z0-9]').hasMatch(newText[i])) seen++;
      if (seen >= alnumCount) {
        return i + 1;
      }
    }
    return newText.length;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: widget.decoration ?? _buildDefaultDecoration(),
      style: widget.style,
      keyboardType: widget.keyboardType ?? _keyboardTypeForDocument,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      obscureText: widget.obscureText,
      autovalidateMode: widget.autovalidateMode,
      validator: _validatorFn,
      onChanged:
          _handleChanged, // kept but actual change handling via controller listener
      onSaved: widget.onSaved,
    );
  }

  InputDecoration _buildDefaultDecoration() {
    return InputDecoration(
      labelText: _labelForDocument,
      border: const OutlineInputBorder(),
    );
  }

  String get _labelForDocument => switch (widget.type) {
    IdDocumentType.aadhaar => 'Aadhaar Number',
    IdDocumentType.pan => 'PAN Number',
    IdDocumentType.drivingLicense => 'Driving License Number',
    IdDocumentType.gstin => 'GSTIN',
    IdDocumentType.voterId => 'Voter ID',
    IdDocumentType.passport => 'Passport Number',
    IdDocumentType.pinCode => 'PIN Code',
    IdDocumentType.email => 'Email Address',
    IdDocumentType.phone => 'Phone Number',
  };

  TextInputType get _keyboardTypeForDocument => switch (widget.type) {
    IdDocumentType.aadhaar => TextInputType.number,
    IdDocumentType.phone => TextInputType.number,
    IdDocumentType.pinCode => TextInputType.number,
    _ => TextInputType.text,
  };
}

/// Builder-based field for maximum flexibility.
/// You control full UI; this widget manages controller + validation.
typedef IdFieldBuilder =
    Widget Function(
      BuildContext context,
      TextEditingController controller,
      IdDocumentResult? result,
    );

class IdField extends StatefulWidget {
  final IdDocumentType type;
  final IdFieldBuilder builder;
  final TextEditingController? controller;

  final String? requiredMessage;
  final bool allowEmpty;
  final bool autoTrim;
  final IdErrorBuilder? errorBuilder;
  final String? initialValue;

  // NEW: autoFormat toggle
  final bool autoFormat;

  const IdField({
    super.key,
    required this.type,
    required this.builder,
    this.controller,
    this.requiredMessage,
    this.allowEmpty = false,
    this.autoTrim = true,
    this.errorBuilder,
    this.initialValue,
    this.autoFormat = true,
  });

  @override
  State<IdField> createState() => _IdFieldState();
}

class _IdFieldState extends State<IdField> {
  late TextEditingController _controller;
  IdDocumentResult? _lastResult;
  bool _isApplyingFormat = false;

  bool get _ownsController => widget.controller == null;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _controller.addListener(_onChanged);
    // Validate initial value
    if (_controller.text.isNotEmpty || !widget.allowEmpty) {
      _validate(_controller.text);
    }
  }

  @override
  void didUpdateWidget(IdField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle controller changes
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_onChanged);
      if (_ownsController && oldWidget.controller == null) {
        _controller.dispose();
      }
      _controller =
          widget.controller ?? TextEditingController(text: widget.initialValue);
      _controller.addListener(_onChanged);
      _validate(_controller.text);
    }

    // Re-validate if validation parameters changed
    if (widget.type != oldWidget.type ||
        widget.requiredMessage != oldWidget.requiredMessage ||
        widget.allowEmpty != oldWidget.allowEmpty ||
        widget.autoTrim != oldWidget.autoTrim ||
        widget.autoFormat != oldWidget.autoFormat ||
        widget.errorBuilder != oldWidget.errorBuilder) {
      _validate(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onChanged() {
    if (_isApplyingFormat) return;

    var text = _controller.text;
    if (widget.autoFormat) {
      final formatted = IdFormatter.format(widget.type, text);
      if (formatted != text) {
        final selection = _controller.selection;
        final baseOffset = selection.baseOffset;
        final isAtEnd = baseOffset >= text.length;
        final newOffset = isAtEnd
            ? formatted.length
            : _preserveOffset(text, formatted, baseOffset);

        _isApplyingFormat = true;
        _controller.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(
            offset: newOffset.clamp(0, formatted.length),
          ),
        );
        _isApplyingFormat = false;
      }
      _validate(_controller.text);
    } else {
      _validate(text);
    }
  }

  int _preserveOffset(String oldText, String newText, int oldOffset) {
    final oldUpTo = oldText.substring(0, oldOffset.clamp(0, oldText.length));
    final alnumCount = oldUpTo.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').length;

    var seen = 0;
    for (var i = 0; i < newText.length; i++) {
      if (RegExp(r'[A-Za-z0-9]').hasMatch(newText[i])) seen++;
      if (seen >= alnumCount) return i + 1;
    }
    return newText.length;
  }

  void _validate(String value) {
    var text = value;
    if (widget.autoTrim) {
      text = text.trim();
    }

    IdDocumentResult? newResult;

    if (text.isEmpty) {
      if (widget.allowEmpty) {
        newResult = null;
      } else {
        newResult = IdDocumentResult(
          type: widget.type,
          rawValue: value,
          isValid: false,
          errorCode: 'REQUIRED',
          errorMessage: widget.requiredMessage ?? 'Required',
        );
      }
    } else {
      // If autoFormat enabled, validate formatted value so UI and validation match
      final toValidate = widget.autoFormat
          ? IdFormatter.format(widget.type, text)
          : text;
      newResult = IdValidator.instance.validate(
        type: widget.type,
        value: toValidate,
      );
    }

    // Only rebuild if result actually changed
    if (_resultChanged(newResult)) {
      setState(() {
        _lastResult = newResult;
      });
    }
  }

  bool _resultChanged(IdDocumentResult? newResult) {
    if (_lastResult == null && newResult == null) return false;
    if (_lastResult == null || newResult == null) return true;

    // Compare relevant fields
    return _lastResult!.isValid != newResult.isValid ||
        _lastResult!.errorCode != newResult.errorCode ||
        _lastResult!.errorMessage != newResult.errorMessage;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller, _lastResult);
  }
}
