import '../../../../core/network/api_exception.dart';
import '../../domain/entities/notification_settings.dart';
import '../../domain/entities/profile_update.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_remote_datasource.dart';

class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl(this._remote);

  final AccountRemoteDataSource _remote;

  @override
  Future<void> updateProfile(String profileId, ProfileUpdate update) =>
      _guard(() => _remote.updateProfile(profileId, update));

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _guard(
        () => _remote.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );

  @override
  Future<NotificationSettings> getNotificationSettings() =>
      _guard(_remote.getNotificationSettings);

  @override
  Future<NotificationSettings> updateNotificationSettings(
    NotificationSettings settings,
  ) =>
      _guard(() => _remote.updateNotificationSettings(settings));

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}
