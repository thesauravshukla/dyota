import 'package:flutter/material.dart';

/// Standard linear progress indicator used across all pages.
class AppLoadingBar extends StatelessWidget {
  const AppLoadingBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).progressIndicatorTheme;
    return LinearProgressIndicator(
      backgroundColor: theme.linearTrackColor,
      valueColor: AlwaysStoppedAnimation<Color>(
        theme.color ?? Colors.brown,
      ),
    );
  }
}

/// Centered circular spinner.
class AppSpinner extends StatelessWidget {
  const AppSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
