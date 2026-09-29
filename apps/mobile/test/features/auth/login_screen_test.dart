import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements AuthRepository {}

void main() {
  late _MockRepository repository;

  setUp(() {
    repository = _MockRepository();
    when(() => repository.restoreSession()).thenAnswer((_) async => null);
  });

  Future<void> pumpLogin(WidgetTester tester) => tester.pumpWidget(
        ProviderScope(
          overrides: [authRepositoryProvider.overrideWithValue(repository)],
          child: const MaterialApp(home: LoginScreen()),
        ),
      );

  void verifyNoLogin() => verifyNever(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          turnstileToken: any(named: 'turnstileToken'),
        ),
      );

  testWidgets('blocks submit on invalid email and short password',
      (tester) async {
    await pumpLogin(tester);

    await tester.enterText(find.byType(TextField).at(0), 'not-an-email');
    await tester.enterText(find.byType(TextField).at(1), '123');
    await tester.tap(find.widgetWithText(FilledButton, 'Giriş Yap'));
    await tester.pump();

    expect(find.text('Geçerli bir e-posta adresi girin.'), findsOneWidget);
    expect(find.text('Şifre en az 6 karakter olmalıdır.'), findsOneWidget);
    verifyNoLogin();
  });

  testWidgets('waits for the Turnstile token, then gives up', (tester) async {
    await pumpLogin(tester);

    await tester.enterText(find.byType(TextField).at(0), 'a@b.co');
    await tester.enterText(find.byType(TextField).at(1), 'secret1');
    await tester.tap(find.widgetWithText(FilledButton, 'Giriş Yap'));
    // The form waits for the background check before giving up.
    await tester.pump(const Duration(seconds: 5));
    verifyNoLogin();
    await tester.pump(const Duration(seconds: 6));

    expect(
      find.text('Güvenlik doğrulaması tamamlanamadı. Lütfen tekrar deneyin.'),
      findsOneWidget,
    );
    verifyNoLogin();
  });
}
