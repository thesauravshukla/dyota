import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_router.dart';
import '../../../data/models/api_error.dart';
import '../../../data/repositories/auth_repository_provider.dart';
import '../widgets/auth_error_banner.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/confirm_password_field.dart';
import '../widgets/password_field.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, this.token});

  final String? token;

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _busy = false;
  bool _done = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.token != null) _tokenCtrl.text = widget.token!;
  }

  @override
  void dispose() {
    _tokenCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authRepositoryProvider).resetPassword(
            token: _tokenCtrl.text.trim(),
            newPassword: _passwordCtrl.text,
          );
      if (mounted) setState(() => _done = true);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _done ? _buildDone(context) : _buildForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final showTokenField = widget.token == null;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Choose a new password',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          if (_error != null) ...[
            AuthErrorBanner(
              message: _error!,
              onDismiss: () => setState(() => _error = null),
            ),
            const SizedBox(height: 16),
          ],
          if (showTokenField) ...[
            TextFormField(
              controller: _tokenCtrl,
              enabled: !_busy,
              decoration: const InputDecoration(
                labelText: 'Reset code',
                prefixIcon: Icon(Icons.vpn_key_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Reset code is required' : null,
            ),
            const SizedBox(height: 12),
          ],
          PasswordField(
            controller: _passwordCtrl,
            enabled: !_busy,
            label: 'New password',
            textInputAction: TextInputAction.next,
            autofillHint: AutofillHints.newPassword,
          ),
          const SizedBox(height: 12),
          ConfirmPasswordField(
            controller: _confirmCtrl,
            passwordController: _passwordCtrl,
            enabled: !_busy,
            onSubmitted: _submit,
          ),
          const SizedBox(height: 24),
          AuthSubmitButton(
            label: 'Update password',
            busy: _busy,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }

  Widget _buildDone(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 56,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Password updated',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'You can now sign in with your new password.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => context.go(AppRoutes.login),
          child: const Text('Back to sign in'),
        ),
      ],
    );
  }
}
