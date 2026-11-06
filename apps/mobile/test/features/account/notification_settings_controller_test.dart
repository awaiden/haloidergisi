import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/features/account/domain/entities/notification_settings.dart';
import 'package:mobile/features/account/domain/repositories/account_repository.dart';
import 'package:mobile/features/account/presentation/controllers/account_controller.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements AccountRepository {}

const _allOn = NotificationSettings(
  emailNotifications: true,
  newPost: true,
  securityAlert: true,
);

void main() {
  late _MockRepository repository;
  late ProviderContainer container;

  setUpAll(() => registerFallbackValue(_allOn));

  setUp(() {
    repository = _MockRepository();
    when(() => repository.getNotificationSettings())
        .thenAnswer((_) async => _allOn);
    container = ProviderContainer(
      overrides: [accountRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    container.listen(notificationSettingsControllerProvider, (_, _) {});
  });

  test('saves a toggle', () async {
    final next = _allOn.copyWith(newPost: false);
    when(() => repository.updateNotificationSettings(any()))
        .thenAnswer((_) async => next);
    await container.read(notificationSettingsControllerProvider.future);

    await container
        .read(notificationSettingsControllerProvider.notifier)
        .save(next);

    expect(
      container.read(notificationSettingsControllerProvider).value?.newPost,
      isFalse,
    );
  });

  test('reverts the toggle when saving fails', () async {
    when(() => repository.updateNotificationSettings(any()))
        .thenThrow(const ApiException('Sunucuya ulaşılamıyor.'));
    await container.read(notificationSettingsControllerProvider.future);

    await expectLater(
      container
          .read(notificationSettingsControllerProvider.notifier)
          .save(_allOn.copyWith(newPost: false)),
      throwsA(isA<ApiException>()),
    );

    expect(
      container.read(notificationSettingsControllerProvider).value?.newPost,
      isTrue,
    );
  });
}
