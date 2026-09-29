import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/theme/theme_mode_controller.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/settings/presentation/screens/settings_screen.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements AuthRepository {}

void main() {
  Future<ProviderContainer> pump(WidgetTester tester, {User? user}) async {
    final repository = _MockRepository();
    when(() => repository.restoreSession()).thenAnswer((_) async => user);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();
    return ProviderScope.containerOf(tester.element(find.byType(SettingsScreen)));
  }

  testWidgets('signed out: preferences and HALO pages, no notifications',
      (tester) async {
    await pump(tester);

    expect(find.text('Görünüm'), findsOneWidget);
    expect(find.text('Hakkımızda'), findsOneWidget);
    expect(find.text('Bildirimler'), findsNothing);
  });

  testWidgets('signed in: notification settings appear', (tester) async {
    await pump(
      tester,
      user: User(id: 'u1', email: 'a@b.co', roles: const ['USER'], createdAt: DateTime(2026)),
    );

    expect(find.text('Bildirimler'), findsOneWidget);
  });

  testWidgets('choosing Koyu switches the theme', (tester) async {
    final container = await pump(tester);

    await tester.tap(find.text('Koyu'));
    await tester.pumpAndSettle();

    expect(container.read(themeModeControllerProvider), ThemeMode.dark);
  });
}
