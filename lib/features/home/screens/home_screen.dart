import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_router.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/controllers/auth_state.dart';

/// Placeholder landing screen. Real catalog/home content will replace this.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    final email = state is AuthAuthenticated ? state.user.email : null;
    final verified = state is AuthAuthenticated && state.user.emailVerified;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dyota'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Signed in', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              if (email != null) Text(email),
              const SizedBox(height: 24),
              if (state is AuthAuthenticated && !verified)
                FilledButton.tonalIcon(
                  onPressed: () => context.push(AppRoutes.verifyEmail),
                  icon: const Icon(Icons.mark_email_unread_outlined),
                  label: const Text('Verify your email'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
