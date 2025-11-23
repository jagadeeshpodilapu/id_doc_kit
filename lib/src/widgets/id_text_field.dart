import 'package:flutter/material.dart';

import '../../id_doc_kit.dart';

class IdTextField extends StatelessWidget {
  final IdDocumentType type;
  final TextEditingController? controller;
  final String? label;
  final void Function(bool isValid)? onValidationChanged;

  const IdTextField({
    super.key,
    required this.type,
    this.controller,
    this.label,
    this.onValidationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final _controller = controller ?? TextEditingController();

    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: label ?? type.name.toUpperCase(),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        final text = value ?? '';
        if (text.isEmpty) return 'Required';

        final result =
        IdValidator.instance.validate(type: type, value: text);
        onValidationChanged?.call(result.isValid);

        if (!result.isValid) {
          return result.errorMessage ?? 'Invalid ${type.name}';
        }
        return null;
      },
    );
  }
}
