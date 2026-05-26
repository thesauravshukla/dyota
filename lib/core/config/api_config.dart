class ApiConfig {
  ApiConfig._();

  // Override at run time:
  //   flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8080
  // Defaults to the Android-emulator host loopback so a stock `flutter run`
  // on an emulator reaches a backend running on the host machine.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  static const String apiPrefix = '/api/v1';

  // The OAuth 2.0 **Web client ID** from Google Cloud Console. This is what
  // `google_sign_in` passes as `serverClientId` so the resulting idToken has
  // `aud == googleServerClientId`, which must match the backend's
  // `GOOGLE_CLIENT_ID` env var. Leave empty to disable Google sign-in.
  //
  //   flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=...apps.googleusercontent.com
  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );
}
