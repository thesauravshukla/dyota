import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api/api_exception.dart';
import '../api/auth_api.dart';
import '../api/models.dart';
import '../auth/auth_controller.dart';
import '../theme/app_theme.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.auth,
    required this.email,
    required this.started,
  });

  final AuthController auth;
  final String email;
  final LoginStarted started;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const _error = Color(0xFFA5503C);

  final _api = AuthApi();
  final _controller = TextEditingController();

  late DateTime _resendAt;
  late int _sendsRemaining;
  Timer? _ticker;
  Duration _cooldown = Duration.zero;

  bool _busy = false;
  bool _resending = false;
  String? _message;
  int? _attemptsRemaining;

  @override
  void initState() {
    super.initState();
    _resendAt = widget.started.resendAvailableAt;
    _sendsRemaining = widget.started.sendsRemaining;
    _startCountdown();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// Counts down to the server's own timestamp rather than running a local
  /// 30-second timer, which drifts as soon as the app is backgrounded. The
  /// clamp guards against a skewed device clock; the server's 429 is the real
  /// authority either way.
  void _startCountdown() {
    _ticker?.cancel();
    void tick() {
      var left = _resendAt.difference(DateTime.now());
      if (left > const Duration(minutes: 5)) left = const Duration(seconds: 60);
      if (!mounted) return;
      setState(() => _cooldown = left.isNegative ? Duration.zero : left);
      if (left.isNegative) _ticker?.cancel();
    }

    tick();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  Future<void> _verify() async {
    final code = _controller.text.trim();
    if (code.length < 4) return;
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final result = await _api.verify(widget.started.sessionId, code);
      if (!mounted) return;

      if (result.authenticated && result.token != null && result.user != null) {
        await widget.auth.signIn(result.token!, result.user!,
            isNewUser: result.isNewUser ?? false);
        if (!mounted) return;
        // Back to the gate, which now renders Home. The consumed login must not
        // stay on the stack behind it.
        Navigator.of(context).popUntil((route) => route.isFirst);
        return;
      }

      final reason = result.reason ?? 'INVALID_CODE';
      if (reason == 'ATTEMPTS_EXHAUSTED' || reason == 'SESSION_EXPIRED') {
        _failAndRestart(reason == 'ATTEMPTS_EXHAUSTED'
            ? 'Too many incorrect codes. Please start again.'
            : 'This login attempt expired. Please start again.');
        return;
      }
      setState(() {
        _attemptsRemaining = result.attemptsRemaining;
        _message = switch (reason) {
          'CODE_EXPIRED' => 'That code has expired. Ask for a new one.',
          'ALREADY_VERIFIED' => 'This code has already been used.',
          _ => 'That code is not right.',
        };
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.requiresRestart) {
        _failAndRestart(e.friendlyMessage);
      } else {
        setState(() => _message = e.friendlyMessage);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    setState(() {
      _resending = true;
      _message = null;
    });
    try {
      final resent = await _api.resend(widget.started.sessionId);
      if (!mounted) return;
      setState(() {
        _resendAt = resent.resendAvailableAt;
        _sendsRemaining = resent.sendsRemaining;
        // A replaced code matters to the user: the one already in their inbox
        // no longer works.
        _message = resent.newCodeIssued
            ? 'The old code expired, so we sent a new one.'
            : 'We sent that code again.';
        _attemptsRemaining = null;
      });
      _startCountdown();
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.requiresRestart) {
        _failAndRestart(e.friendlyMessage);
      } else {
        setState(() => _message = e.friendlyMessage);
        if (e.retryAfter != null) {
          _resendAt = DateTime.now().add(e.retryAfter!);
          _startCountdown();
        }
      }
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  void _failAndRestart(String message) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final waiting = _cooldown > Duration.zero;
    final exhausted = _sendsRemaining <= 0;

    return Scaffold(
      appBar: AppBar(leading: const BackButton(color: AppColors.ink)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Text('Check your email', style: text.headlineMedium),
              const SizedBox(height: 10),
              Text('We sent a 6-digit code to ${widget.email}.', style: text.bodyMedium),
              const SizedBox(height: 28),
              TextField(
                controller: _controller,
                enabled: !_busy,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                style: text.headlineMedium?.copyWith(letterSpacing: 10),
                textAlign: TextAlign.center,
                onSubmitted: (_) => _verify(),
                decoration: const InputDecoration(hintText: '------'),
              ),
              if (_message != null) ...[
                const SizedBox(height: 12),
                Text(
                  _attemptsRemaining != null
                      ? '$_message $_attemptsRemaining attempt${_attemptsRemaining == 1 ? '' : 's'} left.'
                      : _message!,
                  style: text.bodyMedium?.copyWith(color: _error),
                ),
              ],
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _busy ? null : _verify,
                child: _busy
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.onInk))
                    : const Text('Verify'),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: (waiting || exhausted || _resending) ? null : _resend,
                  child: Text(
                    exhausted
                        ? 'No more codes for this attempt'
                        : waiting
                            ? 'Resend in ${_cooldown.inSeconds}s'
                            : 'Send it again',
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
