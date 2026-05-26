import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final bool enabled;
  final VoidCallback? onSubmitted;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      autocorrect: false,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => onSubmitted?.call(),
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.mail_outline),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        final v = value?.trim() ?? '';
        if (v.isEmpty) return 'Email is required';
        if (!_emailRegex.hasMatch(v)) return 'Enter a valid email';
        return null;
      },
    );
  }
}
