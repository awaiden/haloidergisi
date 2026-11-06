import 'package:dio/dio.dart';

import '../models/user_model.dart';

/// REST calls to `apps/api/src/modules/auth` and `/account`.
///
/// Turnstile-guarded endpoints read the token from the
/// `cf-turnstile-response` body field (`TurnstileGuard`).
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  static const _turnstileField = 'cf-turnstile-response';

  Future<String> login({
    required String email,
    required String password,
    required String turnstileToken,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
        _turnstileField: turnstileToken,
      },
    );
    return response.data!['token'] as String;
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String turnstileToken,
  }) =>
      _dio.post<void>(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          _turnstileField: turnstileToken,
        },
      );

  Future<void> forgotPassword({
    required String email,
    required String turnstileToken,
  }) =>
      _dio.post<void>(
        '/auth/forgot-password',
        data: {'email': email, _turnstileField: turnstileToken},
      );

  /// Trades the one-time code from the Google flow for a session token; the
  /// [verifier] proves this app started the flow (PKCE).
  Future<String> exchangeGoogleCode({
    required String code,
    required String verifier,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/google/exchange',
      data: {'code': code, 'verifier': verifier},
    );
    return response.data!['token'] as String;
  }

  /// The API expects the token in the body, not the Authorization header.
  Future<void> logout(String token) =>
      _dio.post<void>('/auth/logout', data: {'token': token});

  Future<UserModel> getAccount() async {
    final response = await _dio.get<Map<String, dynamic>>('/account');
    return UserModel.fromJson(response.data!);
  }
}
