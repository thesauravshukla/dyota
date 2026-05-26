import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_router.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';
import '../widgets/auth_error_banner.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/confirm_password_field.dart';
import '../widgets/email_field.dart';
import '../widgets/password_field.dart';
import '../widgets/social_buttons.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _emailCtrl.addListener(_recomputeCanSubmit);
    _passwordCtrl.addListener(_recomputeCanSubmit);
    _confirmCtrl.addListener(_recomputeCanSubmit);
  }

  void _recomputeCanSubmit() {
    final ok = _emailCtrl.text.trim().isNotEmpty &&
        _passwordCtrl.text.length >= 8 &&
        _confirmCtrl.text == _passwordCtrl.text;
    if (ok != _canSubmit) setState(() => _canSubmit = ok);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(authControllerProvider.notifier).signup(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          confirmPassword: _confirmCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final busy = state is AuthSubmitting;
    final errorMessage = state is AuthError ? state.message : null;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  onChanged: _recomputeCanSubmit,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Create your account',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'It takes less than a minute.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      if (errorMessage != null) ...[
                        AuthErrorBanner(
                          message: errorMessage,
                          onDismiss: () =>
                              ref.read(authControllerProvider.notifier).clearError(),
                        ),
                        const SizedBox(height: 16),
                      ],
                      EmailField(controller: _emailCtrl, enabled: !busy),
                      const SizedBox(height: 12),
                      PasswordField(
                        controller: _passwordCtrl,
                        enabled: !busy,
                        textInputAction: TextInputAction.next,
                        autofillHint: AutofillHints.newPassword,
                      ),
                      const SizedBox(height: 12),
                      ConfirmPasswordField(
                        controller: _confirmCtrl,
                        passwordController: _passwordCtrl,
                        enabled: !busy,
                        onSubmitted: _submit,
                      ),
                      const SizedBox(height: 24),
                      AuthSubmitButton(
                        label: 'Create account',
                        busy: busy,
                        onPressed: _canSubmit ? _submit : null,
                      ),
                      const SizedBox(height: 16),
                      const SocialButtons(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account? '),
                          TextButton(
                            onPressed:
                                busy ? null : () => context.go(AppRoutes.login),
                            child: const Text('Sign in'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
