import 'package:dio/dio.dart';

import '../config/api_config.dart';

class ApiClient {
  ApiClient._(this.dio, this.refreshDio);

  /// Dio used for all authenticated calls; carries the [AuthInterceptor].
  final Dio dio;

  /// Bare Dio for token refresh and other calls that must not loop back
  /// through the auth interceptor.
  final Dio refreshDio;

  factory ApiClient.create() {
    const base = ApiConfig.baseUrl + ApiConfig.apiPrefix;
    final options = BaseOptions(
      baseUrl: base,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
      responseType: ResponseType.json,
      validateStatus: (status) => status != null && status < 500,
    );
    return ApiClient._(Dio(options), Dio(options));
  }
}
