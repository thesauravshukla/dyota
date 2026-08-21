import 'package:flutter/material.dart';

import '../api/api_exception.dart';
import '../api/auth_api.dart';
import '../auth/auth_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/weave_mark.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.auth});

  final AuthController auth;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _api = AuthApi();
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Checked here as well as on the server: an obvious typo should not cost a
  /// round trip, and every send comes out of a real daily quota.
  String? _validate(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) return 'Enter your email address';
    final ok = RegExp(r'^[^@\s]+@[^@\s.]+\.[^@\s]+$').hasMatch(email);
    return ok ? null : 'That does not look like an email address';
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final email = _controller.text.trim().toLowerCase();
    try {
      final started = await _api.start(email);
      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => OtpScreen(auth: widget.auth, email: email, started: started),
      ));
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.friendlyMessage);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 3),
                const WeaveLockup(markSize: 56, axis: Axis.vertical),
                const Spacer(flex: 4),
                Text('Email address',
                    style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _controller,
                  validator: _validate,
                  enabled: !_busy,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.email],
                  onFieldSubmitted: (_) => _submit(),
                  decoration: const InputDecoration(hintText: 'you@example.com'),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!,
                      style: text.bodyMedium?.copyWith(color: const Color(0xFFA5503C))),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _busy ? null : _submit,
                  child: _busy
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.onInk))
                      : const Text('Continue'),
                ),
                const SizedBox(height: 14),
                Text("We'll email you a 6-digit code. No password to remember.",
                    textAlign: TextAlign.center, style: text.bodySmall),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
