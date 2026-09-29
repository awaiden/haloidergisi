import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/core/storage/token_storage.dart';
import 'package:mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mobile/features/auth/data/datasources/google_web_auth.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

class _MockTokenStorage extends Mock implements TokenStorage {}

class _FakeWebAuth implements WebAuthenticator {
  _FakeWebAuth(this.respond);

  final Uri? Function(Uri start) respond;
  Uri? started;

  @override
  Future<Uri?> authenticate(Uri url) async {
    started = url;
    return respond(url);
  }
}

final _account = UserModel.fromJson({
  'id': 'u1',
  'email': 'a@b.co',
  'roles': ['USER'],
  'createdAt': '2026-01-01T00:00:00.000Z',
  'password': 'hash-should-be-ignored',
  'profile': {'id': 'p1', 'name': 'Ayşe', 'userId': 'u1'},
});

DioException _status(int code) {
  final options = RequestOptions(path: '/account');
  return DioException(
    requestOptions: options,
    response: Response(requestOptions: options, statusCode: code),
  );
}

void main() {
  late _MockRemote remote;
  late _MockTokenStorage storage;
  late AuthRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    storage = _MockTokenStorage();
    repository = AuthRepositoryImpl(remote, storage);
    when(() => storage.write(any())).thenAnswer((_) async {});
    when(() => storage.clear()).thenAnswer((_) async {});
  });

  group('login', () {
    test('stores the token and returns the account', () async {
      when(
        () => remote.login(
          email: 'a@b.co',
          password: 'secret1',
          turnstileToken: 't',
        ),
      ).thenAnswer((_) async => 'tok');
      when(() => remote.getAccount()).thenAnswer((_) async => _account);

      final user = await repository.login(
        email: 'a@b.co',
        password: 'secret1',
        turnstileToken: 't',
      );

      verify(() => storage.write('tok')).called(1);
      expect(user.displayName, 'Ayşe');
    });

    test('maps API errors and stores nothing', () async {
      when(
        () => remote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          turnstileToken: any(named: 'turnstileToken'),
        ),
      ).thenThrow(_status(400));

      await expectLater(
        repository.login(email: 'a@b.co', password: 'x', turnstileToken: 't'),
        throwsA(isA<ApiException>()),
      );
      verifyNever(() => storage.write(any()));
    });
  });

  group('logout', () {
    test('clears the token even when the request fails', () async {
      when(() => storage.read()).thenAnswer((_) async => 'tok');
      when(() => remote.logout('tok')).thenThrow(_status(500));

      await repository.logout();

      verify(() => storage.clear()).called(1);
    });
  });

  group('restoreSession', () {
    test('returns null without calling the API when no token', () async {
      when(() => storage.read()).thenAnswer((_) async => null);

      expect(await repository.restoreSession(), isNull);
      verifyNever(() => remote.getAccount());
    });

    test('clears a rejected token and returns null', () async {
      when(() => storage.read()).thenAnswer((_) async => 'tok');
      when(() => remote.getAccount()).thenThrow(_status(401));

      expect(await repository.restoreSession(), isNull);
      verify(() => storage.clear()).called(1);
    });

    test('keeps the token and rethrows when the server is unreachable',
        () async {
      when(() => storage.read()).thenAnswer((_) async => 'tok');
      when(() => remote.getAccount()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/account'),
          type: DioExceptionType.connectionError,
        ),
      );

      await expectLater(
        repository.restoreSession(),
        throwsA(isA<ApiException>()),
      );
      verifyNever(() => storage.clear());
    });
  });

  group('signInWithGoogle', () {
    AuthRepositoryImpl withBrowser(_FakeWebAuth web) => AuthRepositoryImpl(
          remote,
          storage,
          webAuthenticator: web,
          apiBaseUrl: 'http://localhost:3000',
        );

    test('starts the mobile flow with a challenge only the app can answer',
        () async {
      final web = _FakeWebAuth((_) => Uri.parse('halo://auth-callback?code=handoff'));
      when(
        () => remote.exchangeGoogleCode(
          code: any(named: 'code'),
          verifier: any(named: 'verifier'),
        ),
      ).thenAnswer((_) async => 'tok');
      when(() => remote.getAccount()).thenAnswer((_) async => _account);

      final user = await withBrowser(web).signInWithGoogle();

      expect(user?.displayName, 'Ayşe');
      expect(web.started!.path, '/auth/google');
      expect(web.started!.queryParameters['platform'], 'mobile');
      final verifier = verify(
        () => remote.exchangeGoogleCode(
          code: 'handoff',
          verifier: captureAny(named: 'verifier'),
        ),
      ).captured.single as String;
      final expectedChallenge = base64Url
          .encode(sha256.convert(ascii.encode(verifier)).bytes)
          .replaceAll('=', '');
      expect(web.started!.queryParameters['challenge'], expectedChallenge);
      verify(() => storage.write('tok')).called(1);
    });

    test('closing the browser is not an error', () async {
      final user = await withBrowser(_FakeWebAuth((_) => null)).signInWithGoogle();

      expect(user, isNull);
      verifyNever(() => storage.write(any()));
    });

    test('shows the reason the API sent back', () async {
      final web = _FakeWebAuth(
        (_) => Uri.parse('halo://auth-callback?error=Google%20giri%C5%9Fi%20iptal%20edildi.'),
      );

      await expectLater(
        withBrowser(web).signInWithGoogle(),
        throwsA(
          isA<ApiException>().having((e) => e.message, 'message', 'Google girişi iptal edildi.'),
        ),
      );
      verifyNever(() => storage.write(any()));
    });
  });
}
