import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_router.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';
import '../widgets/auth_error_banner.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/email_field.dart';
import '../widgets/password_field.dart';
import '../widgets/social_buttons.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final controller = ref.read(authControllerProvider.notifier);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await controller.login(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final busy = state is AuthSubmitting;
    final errorMessage = state is AuthError ? state.message : null;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Welcome back',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue to Dyota.',
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
                        onSubmitted: _submit,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: busy
                              ? null
                              : () => context.push(AppRoutes.forgotPassword),
                          child: const Text('Forgot password?'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AuthSubmitButton(
                        label: 'Sign in',
                        busy: busy,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 16),
                      const SocialButtons(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          TextButton(
                            onPressed:
                                busy ? null : () => context.go(AppRoutes.signup),
                            child: const Text('Sign up'),
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
