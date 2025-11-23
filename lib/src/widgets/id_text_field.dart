import 'package:flutter/material.dart';

import '../../id_doc_kit.dart';

class IdTextField extends StatefulWidget {
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
  State<IdTextField> createState() => _IdTextFieldState();
}

class _IdTextFieldState extends State<IdTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.label ?? widget.type.name.toUpperCase(),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        final text = value ?? '';
        if (text.isEmpty) return 'Required';

        final result = IdValidator.instance.validate(
          type: widget.type,
          value: text,
        );
        // Defer callback to avoid setState during build
        Future.microtask(() {
          widget.onValidationChanged?.call(result.isValid);
        });

        if (!result.isValid) {
          return result.errorMessage ?? 'Invalid ${widget.type.name}';
        }
        return null;
      },
    );
  }
}
