import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/auth_repository_provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

/// Renders an "or continue with" divider plus a Google button.
/// Hides itself entirely when Google sign-in is unconfigured or
/// unsupported on this platform.
class SocialButtons extends ConsumerWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final available = ref.watch(googleSignInAvailableProvider);
    if (!available) return const SizedBox.shrink();

    final state = ref.watch(authControllerProvider);
    final busy = state is AuthSubmitting;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'or continue with',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 48,
          child: OutlinedButton.icon(
            onPressed: busy
                ? null
                : () =>
                    ref.read(authControllerProvider.notifier).signInWithGoogle(),
            icon: const Icon(Icons.g_mobiledata, size: 28),
            label: const Text('Continue with Google'),
          ),
        ),
      ],
    );
  }
}
