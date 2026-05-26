import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/api_error.dart';
import '../../../data/repositories/auth_repository_provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';
import '../widgets/auth_error_banner.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key, this.token});

  /// Token from a verification deep link, if any.
  final String? token;

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _busy = false;
  String? _error;
  String? _info;

  @override
  void initState() {
    super.initState();
    if (widget.token != null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _confirm(widget.token!));
    }
  }

  Future<void> _confirm(String token) async {
    setState(() {
      _busy = true;
      _error = null;
      _info = null;
    });
    try {
      await ref.read(authRepositoryProvider).confirmEmailVerification(token);
      await ref.read(authControllerProvider.notifier).refreshUser();
      if (mounted) setState(() => _info = 'Email verified.');
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not verify email.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    final auth = ref.read(authControllerProvider);
    final email = auth is AuthAuthenticated ? auth.user.email : null;
    if (email == null) {
      setState(() => _error = 'You must be signed in to resend verification.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _info = null;
    });
    try {
      await ref.read(authRepositoryProvider).requestEmailVerification(email);
      if (mounted) setState(() => _info = 'Verification email sent.');
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not send verification email.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final email = auth is AuthAuthenticated ? auth.user.email : null;
    final verified = auth is AuthAuthenticated && auth.user.emailVerified;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify your email')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    verified
                        ? Icons.verified_outlined
                        : Icons.mark_email_unread_outlined,
                    size: 56,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    verified ? 'You are verified' : 'Check your email',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    verified
                        ? 'Your email is confirmed. You can place orders now.'
                        : email != null
                            ? "We sent a verification link to $email. Tap it to verify."
                            : 'We sent you a verification link. Tap it to verify.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  if (_error != null) ...[
                    AuthErrorBanner(
                      message: _error!,
                      onDismiss: () => setState(() => _error = null),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (_info != null) ...[
                    _InfoBanner(message: _info!),
                    const SizedBox(height: 12),
                  ],
                  if (!verified)
                    FilledButton(
                      onPressed: _busy ? null : _resend,
                      child: _busy
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Resend verification email'),
                    ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () =>
                            ref.read(authControllerProvider.notifier).refreshUser(),
                    child: const Text("I've verified — refresh"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.primaryContainer,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: scheme.onPrimaryContainer),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message, style: TextStyle(color: scheme.onPrimaryContainer)),
            ),
          ],
        ),
      ),
    );
  }
}
