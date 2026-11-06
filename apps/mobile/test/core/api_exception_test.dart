import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_exception.dart';

DioException _response(int status, Object? data) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    response: Response(requestOptions: options, statusCode: status, data: data),
  );
}

void main() {
  test('joins validation message arrays', () {
    final e = ApiException.from(
      _response(400, {
        'message': ['email must be an email', 'password too short'],
        'statusCode': 400,
      }),
    );
    expect(e.message, 'email must be an email, password too short');
    expect(e.statusCode, 400);
  });

  test('passes through string messages', () {
    final e = ApiException.from(
      _response(400, {'message': 'Invalid credentials', 'statusCode': 400}),
    );
    expect(e.message, 'Invalid credentials');
  });

  test('hides 500 details', () {
    final e = ApiException.from(_response(500, {'message': 'boom'}));
    expect(e.message, 'Sunucu hatası oluştu.');
  });

  test('explains oversized uploads', () {
    final e = ApiException.from(_response(413, {'message': 'File too large'}));
    expect(e.message, 'Dosya çok büyük.');
  });

  test('reports unreachable server', () {
    final e = ApiException.from(
      DioException(
        requestOptions: RequestOptions(path: '/x'),
        type: DioExceptionType.connectionError,
      ),
    );
    expect(e.message, 'Sunucuya ulaşılamıyor.');
  });

  test('flags 401 as unauthorized', () {
    expect(ApiException.from(_response(401, {})).isUnauthorized, isTrue);
  });

  test('falls back for non-Dio errors', () {
    // Debug builds (tests included) append the original error.
    expect(
      ApiException.from(StateError('x')).message,
      startsWith('Bilinmeyen bir hata oluştu'),
    );
  });
}
