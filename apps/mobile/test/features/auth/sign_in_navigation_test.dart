import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/app/router/app_router.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements AuthRepository {}

void main() {
  late _MockRepository repository;

  setUp(() {
    repository = _MockRepository();
    when(() => repository.restoreSession()).thenAnswer((_) async => null);
    when(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
        turnstileToken: any(named: 'turnstileToken'),
      ),
    ).thenAnswer(
      (_) async => User(id: 'u1', email: 'a@b.co', roles: const ['USER'], createdAt: DateTime(2026)),
    );
  });

  GoRouter router() => GoRouter(
        initialLocation: Routes.account,
        routes: [
          GoRoute(path: Routes.home, builder: (_, _) => const Text('home')),
          GoRoute(path: Routes.account, builder: (_, _) => const Text('account')),
          GoRoute(
            path: Routes.login,
            builder: (_, _) => const AuthScaffold(
              icon: Icons.login,
              title: 'Giriş Yapın',
              description: '',
              child: SizedBox(),
            ),
          ),
        ],
      );

  Future<void> signIn(WidgetTester tester) async {
    final container = ProviderScope.containerOf(tester.element(find.byType(AuthScaffold)));
    await container
        .read(authControllerProvider.notifier)
        .login(email: 'a@b.co', password: 'secret1', turnstileToken: 't');
    await tester.pumpAndSettle();
  }

  Future<GoRouter> pumpPushedLogin(WidgetTester tester, String location) async {
    final r = router();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp.router(routerConfig: r),
      ),
    );
    await tester.pumpAndSettle();
    r.push(location);
    await tester.pumpAndSettle();
    expect(find.byType(AuthScaffold), findsOneWidget);
    return r;
  }

  testWidgets('a pushed login returns to the page it came from', (tester) async {
    await pumpPushedLogin(tester, Routes.loginFrom(Routes.account));

    await signIn(tester);

    expect(find.byType(AuthScaffold), findsNothing);
    expect(find.text('account'), findsOneWidget);
  });

  testWidgets('without a from parameter it goes home', (tester) async {
    await pumpPushedLogin(tester, Routes.login);

    await signIn(tester);

    expect(find.byType(AuthScaffold), findsNothing);
    expect(find.text('home'), findsOneWidget);
  });
}
