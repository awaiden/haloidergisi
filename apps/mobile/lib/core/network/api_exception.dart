import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Mirrors `resolveApiError` in `apps/web/src/lib/api-client.ts`.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  bool get isUnauthorized => statusCode == 401;

  factory ApiException.from(Object error) {
    if (error is ApiException) return error;
    if (error is! DioException) {
      debugPrint('Unexpected error: $error');
      // In debug builds show what actually went wrong.
      return ApiException(
        kDebugMode
            ? 'Bilinmeyen bir hata oluştu: $error'
            : 'Bilinmeyen bir hata oluştu.',
      );
    }

    final response = error.response;
    if (response == null) {
      return const ApiException('Sunucuya ulaşılamıyor.');
    }

    final statusCode = response.statusCode;
    if (statusCode == 500) {
      return const ApiException('Sunucu hatası oluştu.', statusCode: 500);
    }
    if (statusCode == 413) {
      return const ApiException('Dosya çok büyük.', statusCode: 413);
    }

    final data = response.data;
    final message = data is Map ? data['message'] : null;
    return ApiException(switch (message) {
      List() => message.join(', '),
      String() => message,
      _ => 'Bilinmeyen bir hata oluştu.',
    }, statusCode: statusCode);
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
