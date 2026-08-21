import 'package:flutter/material.dart';

import 'auth/auth_controller.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/weave_mark.dart';

void main() {
  // restore() reaches the platform keystore straight away, which needs the
  // binding to exist first.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DyotaApp(auth: AuthController()..restore()));
}

class DyotaApp extends StatelessWidget {
  const DyotaApp({super.key, required this.auth});

  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dyota',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: _Gate(auth: auth),
    );
  }
}

/// Decides between the launch screen, sign-in and home, and rebuilds whenever
/// auth state changes — so signing out anywhere returns here.
class _Gate extends StatelessWidget {
  const _Gate({required this.auth});

  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: auth,
      builder: (context, _) => switch (auth.status) {
        AuthStatus.unknown => const _Splash(),
        AuthStatus.authenticated => HomeScreen(auth: auth),
        AuthStatus.unauthenticated => LoginScreen(auth: auth),
        AuthStatus.unreachable => _Unreachable(onRetry: auth.restore),
      },
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: WeaveLockup(markSize: 44, axis: Axis.vertical)),
    );
  }
}

/// We hold a token but could not reach the server. Deliberately not a sign-out:
/// the session may well be fine.
class _Unreachable extends StatelessWidget {
  const _Unreachable({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const WeaveMark(size: 40, colour: AppColors.ghost),
              const SizedBox(height: 20),
              Text("Can't reach Dyota", style: text.headlineMedium),
              const SizedBox(height: 8),
              Text('Check your connection and try again.',
                  textAlign: TextAlign.center, style: text.bodyMedium),
              const SizedBox(height: 22),
              FilledButton(onPressed: onRetry, child: const Text('Try again')),
            ],
          ),
        ),
      ),
    );
  }
}
