/// Where the order-management-service lives.
///
/// The Android emulator reaches the host machine on 10.0.2.2 rather than
/// localhost, so this is overridden at run time:
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  static const String apiPrefix = '/api/v1/auth';
}
