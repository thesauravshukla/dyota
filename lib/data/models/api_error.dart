import 'package:dio/dio.dart';

/// Thrown by the data layer when the API returns an error envelope
/// (`{ code, message }`) or the request fails locally.
class ApiException implements Exception {
  ApiException({required this.code, required this.message, this.status});

  final String code;
  final String message;
  final int? status;

  @override
  String toString() => 'ApiException($code, $status): $message';

  static ApiException fromDioError(DioException e) {
    final res = e.response;
    final data = res?.data;
    if (data is Map<String, dynamic>) {
      final code = data['code'] as String? ?? 'UNKNOWN';
      final message = data['message'] as String? ?? 'Request failed';
      return ApiException(code: code, message: message, status: res?.statusCode);
    }
    return ApiException(
      code: 'NETWORK_ERROR',
      message: e.message ?? 'Network error',
      status: res?.statusCode,
    );
  }

  static ApiException fromResponse(Response<dynamic> res) {
    final data = res.data;
    if (data is Map<String, dynamic>) {
      return ApiException(
        code: data['code'] as String? ?? 'UNKNOWN',
        message: data['message'] as String? ?? 'Request failed',
        status: res.statusCode,
      );
    }
    return ApiException(
      code: 'UNKNOWN',
      message: 'Request failed',
      status: res.statusCode,
    );
  }
}
