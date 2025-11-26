import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/id_document_type.dart';
import '../models/id_document_result.dart';
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

    final result = IdValidator.instance.validate(type: type, value: text);

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
  });

  @override
  State<IdTextField> createState() => _IdTextFieldState();
}

class _IdTextFieldState extends State<IdTextField> {
  late TextEditingController _controller;
  late FormFieldValidator<String> _validatorFn;
  bool? _lastValidState;

  bool get _ownsController => widget.controller == null;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _validatorFn = _createValidator();
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
    }

    // Recreate validator if validation parameters changed
    if (widget.type != oldWidget.type ||
        widget.requiredMessage != oldWidget.requiredMessage ||
        widget.allowEmpty != oldWidget.allowEmpty ||
        widget.autoTrim != oldWidget.autoTrim ||
        widget.errorBuilder != oldWidget.errorBuilder) {
      _validatorFn = _createValidator();
      // Reset validation state since rules changed
      _lastValidState = null;
    }
  }

  @override
  void dispose() {
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
    );
  }

  void _handleChanged(String value) {
    widget.onChanged?.call(value);
    _notifyValidationChangeIfNeeded(value);
  }

  void _notifyValidationChangeIfNeeded(String value) {
    if (widget.onValidationChanged == null) return;

    final isValid = _validatorFn(value) == null;
    if (_lastValidState != isValid) {
      _lastValidState = isValid;
      widget.onValidationChanged!(isValid);
    }
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
      onChanged: _handleChanged,
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
  };

  TextInputType get _keyboardTypeForDocument => switch (widget.type) {
    IdDocumentType.aadhaar => TextInputType.number,
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
  });

  @override
  State<IdField> createState() => _IdFieldState();
}

class _IdFieldState extends State<IdField> {
  late TextEditingController _controller;
  IdDocumentResult? _lastResult;

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
        widget.autoTrim != oldWidget.autoTrim) {
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
    _validate(_controller.text);
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
      newResult = IdValidator.instance.validate(type: widget.type, value: text);
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
