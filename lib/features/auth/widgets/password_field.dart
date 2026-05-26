import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    this.label = 'Password',
    this.enabled = true,
    this.textInputAction = TextInputAction.done,
    this.minLength = 8,
    this.autofillHint = AutofillHints.password,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final bool enabled;
  final TextInputAction textInputAction;
  final int minLength;
  final String autofillHint;
  final VoidCallback? onSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: _obscure,
      autocorrect: false,
      enableSuggestions: false,
      autofillHints: [widget.autofillHint],
      textInputAction: widget.textInputAction,
      onFieldSubmitted: (_) => widget.onSubmitted?.call(),
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Icons.lock_outline),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          tooltip: _obscure ? 'Show password' : 'Hide password',
          icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
      validator: (value) {
        final v = value ?? '';
        if (v.isEmpty) return '${widget.label} is required';
        if (v.length < widget.minLength) {
          return 'Must be at least ${widget.minLength} characters';
        }
        return null;
      },
    );
  }
}
