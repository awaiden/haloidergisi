import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

/// Attaches the opaque session token and reports rejected sessions.
///
/// It never navigates itself: [onSessionExpired] lets the auth controller
/// drop the user, and the router redirect takes it from there.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage, {required this.onSessionExpired});

  final TokenStorage _tokenStorage;
  final void Function() onSessionExpired;

  static const _hadTokenKey = 'hadToken';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.read();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      options.extra[_hadTokenKey] = true;
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final hadToken = err.requestOptions.extra[_hadTokenKey] == true;
    if (hadToken && err.response?.statusCode == 401) {
      await _tokenStorage.clear();
      onSessionExpired();
    }
    handler.next(err);
  }
}
