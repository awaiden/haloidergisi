import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/router/app_router.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';

final _user = User(
  id: 'u1',
  email: 'a@b.co',
  roles: const ['USER'],
  createdAt: DateTime(2026),
);

String? redirect(AsyncValue<User?> auth, String location) =>
    authRedirect(auth, Uri.parse(location));

void main() {
  const loading = AsyncLoading<User?>();
  const signedOut = AsyncData<User?>(null);
  final signedIn = AsyncData<User?>(_user);

  test('holds on splash while restoring or after a failed restore', () {
    expect(redirect(loading, Routes.home), Routes.splash);
    expect(redirect(loading, Routes.splash), isNull);
    expect(
      redirect(AsyncError<User?>('x', StackTrace.empty), Routes.login),
      Routes.splash,
    );
  });

  test('content and the account tab are public', () {
    expect(redirect(signedOut, Routes.splash), Routes.home);
    expect(redirect(signedOut, Routes.home), isNull);
    expect(redirect(signedOut, Routes.post('halo-18')), isNull);
    expect(redirect(signedOut, Routes.issueReader('halo-18')), isNull);
    expect(redirect(signedOut, Routes.newsItem('duyuru')), isNull);
    expect(redirect(signedOut, Routes.account), isNull);
    expect(redirect(signedOut, Routes.login), isNull);
  });

  test('account pages send signed-out users to login and back', () {
    final target = redirect(signedOut, Routes.changePassword);
    expect(target, Routes.loginFrom(Routes.changePassword));

    expect(redirect(signedIn, target!), Routes.changePassword);
  });

  test('info pages under /account stay public', () {
    for (final page in [
      Routes.settings,
      Routes.about,
      Routes.team,
      Routes.contact,
      Routes.privacy,
      Routes.terms,
    ]) {
      expect(redirect(signedOut, page), isNull, reason: page);
    }
    expect(redirect(signedOut, Routes.mySubmissions), Routes.loginFrom(Routes.mySubmissions));
    expect(redirect(signedOut, Routes.editProfile), Routes.loginFrom(Routes.editProfile));
  });

  test('call pages are public but the submit form needs a session', () {
    expect(redirect(signedOut, Routes.calls), isNull);
    expect(redirect(signedOut, Routes.call('c1')), isNull);
    expect(redirect(signedOut, Routes.submit('c1')), Routes.loginFrom(Routes.submit('c1')));
    expect(redirect(signedIn, Routes.submit('c1')), isNull);
  });

  test('signed-in users leave auth routes', () {
    expect(redirect(signedIn, Routes.login), Routes.home);
    expect(redirect(signedIn, Routes.forgotPassword), Routes.home);
    expect(redirect(signedIn, Routes.splash), Routes.home);
    expect(redirect(signedIn, Routes.home), isNull);
    expect(redirect(signedIn, Routes.notificationSettings), isNull);
  });

  test('ignores a from parameter that is not an in-app path', () {
    expect(redirect(signedIn, '/login?from=https://evil.test'), Routes.home);
    expect(redirect(signedIn, '/login?from=//evil.test'), Routes.home);
  });
}
