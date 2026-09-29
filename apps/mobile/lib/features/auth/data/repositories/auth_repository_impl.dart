import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

import '../../../../app/constants/env.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/google_web_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._remote,
    this._tokenStorage, {
    this._webAuthenticator = const FlutterWebAuthenticator(),
    this._apiBaseUrl = Env.apiBaseUrl,
  });

  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;
  final WebAuthenticator _webAuthenticator;
  final String _apiBaseUrl;

  @override
  Future<User?> restoreSession() async {
    if (await _tokenStorage.read() == null) return null;
    try {
      return (await _remote.getAccount()).toEntity();
    } catch (e) {
      final error = ApiException.from(e);
      if (error.isUnauthorized) {
        await _tokenStorage.clear();
        return null;
      }
      throw error;
    }
  }

  @override
  Future<User> login({
    required String email,
    required String password,
    required String turnstileToken,
  }) =>
      _guard(() async {
        final token = await _remote.login(
          email: email,
          password: password,
          turnstileToken: turnstileToken,
        );
        await _tokenStorage.write(token);
        try {
          return (await _remote.getAccount()).toEntity();
        } catch (_) {
          await _tokenStorage.clear();
          rethrow;
        }
      });

  @override
  Future<User?> signInWithGoogle() => _guard(() async {
        // PKCE between the app and the API: only this app knows the verifier,
        // so a handoff code intercepted from the halo:// deep link is useless.
        final verifier = _randomUrlSafe(32);
        final challenge = base64Url
            .encode(sha256.convert(ascii.encode(verifier)).bytes)
            .replaceAll('=', '');

        final start = Uri.parse(_apiBaseUrl).replace(
          path: '/auth/google',
          queryParameters: {'platform': 'mobile', 'challenge': challenge},
        );
        final callback = await _webAuthenticator.authenticate(start);
        if (callback == null) return null;

        final params = callback.queryParameters;
        final error = params['error'];
        if (error != null) throw ApiException(error);
        final code = params['code'];
        if (code == null) throw const ApiException('Google ile giriş başarısız oldu.');

        final token = await _remote.exchangeGoogleCode(code: code, verifier: verifier);
        await _tokenStorage.write(token);
        try {
          return (await _remote.getAccount()).toEntity();
        } catch (_) {
          await _tokenStorage.clear();
          rethrow;
        }
      });

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String turnstileToken,
  }) =>
      _guard(
        () => _remote.register(
          name: name,
          email: email,
          password: password,
          turnstileToken: turnstileToken,
        ),
      );

  @override
  Future<void> requestPasswordReset({
    required String email,
    required String turnstileToken,
  }) =>
      _guard(
        () => _remote.forgotPassword(
          email: email,
          turnstileToken: turnstileToken,
        ),
      );

  @override
  Future<void> logout() async {
    final token = await _tokenStorage.read();
    try {
      if (token != null) await _remote.logout(token);
    } catch (_) {
      // The local session is dropped regardless; a stale server token expires on its own.
    } finally {
      await _tokenStorage.clear();
    }
  }

  static String _randomUrlSafe(int bytes) {
    final random = Random.secure();
    final values = List<int>.generate(bytes, (_) => random.nextInt(256));
    return base64Url.encode(values).replaceAll('=', '');
  }

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}
