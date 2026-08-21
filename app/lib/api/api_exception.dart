/// Carries the machine-readable code from the API so the UI can react to a
/// specific failure rather than parsing prose.
class ApiException implements Exception {
  final String code;
  final String message;
  final Duration? retryAfter;

  ApiException(this.code, this.message, {this.retryAfter});

  /// Failures the user can actually do something about get a tailored message;
  /// everything else falls back to whatever the server said.
  String get friendlyMessage => switch (code) {
        'INVALID_IDENTIFIER' => 'That does not look like a valid email address.',
        'CHANNEL_UNAVAILABLE' =>
          'Login by SMS is not available yet. Please use your email address.',
        'COOLDOWN_ACTIVE' => 'Please wait a moment before requesting another code.',
        'SENDS_EXHAUSTED' =>
          'Too many codes requested. Start again with your email address.',
        'IDENTIFIER_RATE_LIMITED' || 'IP_RATE_LIMITED' =>
          'Too many attempts. Please try again later.',
        'VERIFICATION_UNAVAILABLE' =>
          'We cannot send codes right now. Please try again shortly.',
        'SESSION_NOT_FOUND' || 'SESSION_TERMINATED' || 'SESSION_EXPIRED' =>
          'This login attempt has expired. Please start again.',
        'NETWORK' => 'Could not reach the server. Check your connection.',
        _ => message,
      };

  /// True when the user has to go back and start a fresh login.
  bool get requiresRestart => const {
        'SESSION_NOT_FOUND',
        'SESSION_TERMINATED',
        'SESSION_EXPIRED',
        'SENDS_EXHAUSTED',
      }.contains(code);

  @override
  String toString() => 'ApiException($code): $message';
}
