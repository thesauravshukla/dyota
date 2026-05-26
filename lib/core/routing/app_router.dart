import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/controllers/auth_controller.dart';
import '../../features/auth/controllers/auth_state.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/verify_email_screen.dart';
import '../../features/home/screens/home_screen.dart';

class AppRoutes {
  AppRoutes._();
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const verifyEmail = '/verify-email';
  static const home = '/';
}

const _signedOutRoutes = {
  AppRoutes.login,
  AppRoutes.signup,
  AppRoutes.forgotPassword,
  AppRoutes.resetPassword,
};

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthRouterListenable(ref);
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: notifier,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final path = state.matchedLocation;

      if (auth is AuthInitializing) return null;

      final signedIn = auth is AuthAuthenticated;
      final goingToSignedOut = _signedOutRoutes.contains(path);

      if (!signedIn && !goingToSignedOut) return AppRoutes.login;
      if (signedIn && goingToSignedOut) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.home, builder: (_, __) => const HomeScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: AppRoutes.signup, builder: (_, __) => const SignupScreen()),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (_, state) => ResetPasswordScreen(
          token: state.uri.queryParameters['token'],
        ),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (_, state) => VerifyEmailScreen(
          token: state.uri.queryParameters['token'],
        ),
      ),
    ],
  );
});

/// Bridges Riverpod auth state changes to GoRouter so the redirect runs
/// whenever the user signs in/out.
class _AuthRouterListenable extends ChangeNotifier {
  _AuthRouterListenable(this._ref) {
    _sub = _ref.listen<AuthState>(
      authControllerProvider,
      (_, __) => notifyListeners(),
    );
  }

  final Ref _ref;
  late final ProviderSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
