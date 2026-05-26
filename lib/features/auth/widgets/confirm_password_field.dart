import 'package:flutter/material.dart';

class ConfirmPasswordField extends StatefulWidget {
  const ConfirmPasswordField({
    super.key,
    required this.controller,
    required this.passwordController,
    this.enabled = true,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final TextEditingController passwordController;
  final bool enabled;
  final VoidCallback? onSubmitted;

  @override
  State<ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();
}

class _ConfirmPasswordFieldState extends State<ConfirmPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: _obscure,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => widget.onSubmitted?.call(),
      decoration: InputDecoration(
        labelText: 'Confirm password',
        prefixIcon: const Icon(Icons.lock_outline),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          tooltip: _obscure ? 'Show password' : 'Hide password',
          icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
      validator: (value) {
        if ((value ?? '').isEmpty) return 'Please confirm your password';
        if (value != widget.passwordController.text) return 'Passwords do not match';
        return null;
      },
    );
  }
}
