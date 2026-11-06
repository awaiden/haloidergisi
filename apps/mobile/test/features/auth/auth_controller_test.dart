import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements AuthRepository {}

final _user = User(
  id: 'u1',
  email: 'a@b.co',
  roles: const ['USER'],
  createdAt: DateTime(2026),
);

void main() {
  late _MockRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _MockRepository();
    container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
  });

  test('build restores a signed-out session as null', () async {
    when(() => repository.restoreSession()).thenAnswer((_) async => null);

    expect(await container.read(authControllerProvider.future), isNull);
  });

  test('build restores an existing session', () async {
    when(() => repository.restoreSession()).thenAnswer((_) async => _user);

    expect(await container.read(authControllerProvider.future), _user);
  });

  test('login sets the user; logout clears it', () async {
    when(() => repository.restoreSession()).thenAnswer((_) async => null);
    when(
      () => repository.login(
        email: 'a@b.co',
        password: 'secret1',
        turnstileToken: 't',
      ),
    ).thenAnswer((_) async => _user);
    when(() => repository.logout()).thenAnswer((_) async {});
    await container.read(authControllerProvider.future);
    final controller = container.read(authControllerProvider.notifier);

    await controller.login(
      email: ' a@b.co ',
      password: 'secret1',
      turnstileToken: 't',
    );
    expect(container.read(authControllerProvider).value, _user);

    await controller.logout();
    expect(container.read(authControllerProvider).value, isNull);
  });

  test('a session-expired event signs the user out', () async {
    when(() => repository.restoreSession()).thenAnswer((_) async => _user);
    await container.read(authControllerProvider.future);

    container.read(sessionExpiredProvider).add(null);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(authControllerProvider).value, isNull);
  });
}
