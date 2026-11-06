import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements AuthRepository {}

/// AuthScaffold watches the session, so it needs a (signed-out) ProviderScope.
Widget app(GoRouter router) {
  final repository = _MockRepository();
  when(() => repository.restoreSession()).thenAnswer((_) async => null);
  return ProviderScope(
    overrides: [authRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  GoRouter router(String initial) => GoRouter(
        initialLocation: initial,
        routes: [
          GoRoute(path: '/', builder: (_, _) => const Text('home')),
          GoRoute(
            path: '/login',
            builder: (_, _) => const AuthScaffold(
              icon: Icons.login,
              title: 'Giriş Yapın',
              description: '',
              child: SizedBox(),
            ),
          ),
        ],
      );

  testWidgets('an auth page opened directly can still go home', (tester) async {
    await tester.pumpWidget(app(router('/login')));

    expect(find.byType(BackButton), findsNothing);
    await tester.tap(find.byTooltip('Ana Sayfa'));
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('the system back button goes home instead of closing the app',
      (tester) async {
    await tester.pumpWidget(app(router('/login')));

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('pushed from another page, it shows a normal back button',
      (tester) async {
    final r = router('/');
    await tester.pumpWidget(app(r));
    r.push('/login');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
  });
}
