import 'package:flutter/material.dart';

import '../auth/auth_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/weave_mark.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.auth});

  final AuthController auth;

  static const _fibres = ['Cotton', 'Silk', 'Linen', 'Khadi'];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const WeaveLockup(markSize: 24),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.muted),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.muted),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.muted),
            onSelected: (value) {
              if (value == 'signout') auth.signOut();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'signout',
                child: Text('Sign out', style: text.bodyLarge),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          if (auth.showWelcome) ...[
            _WelcomeCard(onDismiss: auth.dismissWelcome),
            const SizedBox(height: 22),
          ],
          Text('Shop by fibre', style: _sectionStyle(text)),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final fibre in _fibres) ...[
                Expanded(child: _Fibre(label: fibre)),
                if (fibre != _fibres.last) const SizedBox(width: 10),
              ],
            ],
          ),
          const SizedBox(height: 24),
          Text('New this week', style: _sectionStyle(text)),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: _Tile()),
              SizedBox(width: 12),
              Expanded(child: _Tile()),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle? _sectionStyle(TextTheme text) => text.bodySmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        color: AppColors.muted,
      );
}

/// Shown once, on the first session after the account is created.
class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('NEW HERE',
                  style: text.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                      color: AppColors.ink)),
              const SizedBox(height: 10),
              Text('Welcome to Dyota', style: text.headlineMedium),
              const SizedBox(height: 8),
              // TODO: replace with a real one-line description once the
              // positioning copy is written.
              Text('[ one line on what Dyota is ]',
                  style: text.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                ),
                onPressed: onDismiss,
                child: const Text('Browse fabrics'),
              ),
            ],
          ),
          Positioned(
            top: -6,
            right: -6,
            child: IconButton(
              icon: const Icon(Icons.close, size: 18, color: AppColors.muted),
              onPressed: onDismiss,
            ),
          ),
        ],
      ),
    );
  }
}

class _Fibre extends StatelessWidget {
  const _Fibre({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.swatch,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        const SizedBox(height: 7),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      decoration: BoxDecoration(
        color: AppColors.swatch,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.image_outlined, color: AppColors.ghost, size: 26),
    );
  }
}
