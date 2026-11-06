import '../entities/notification_settings.dart';
import '../repositories/account_repository.dart';

class GetNotificationSettings {
  const GetNotificationSettings(this._repository);

  final AccountRepository _repository;

  Future<NotificationSettings> call() => _repository.getNotificationSettings();
}

class UpdateNotificationSettings {
  const UpdateNotificationSettings(this._repository);

  final AccountRepository _repository;

  Future<NotificationSettings> call(NotificationSettings settings) =>
      _repository.updateNotificationSettings(settings);
}
