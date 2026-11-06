import '../entities/notification_settings.dart';
import '../entities/profile_update.dart';

abstract interface class AccountRepository {
  Future<void> updateProfile(String profileId, ProfileUpdate update);

  /// Signs out the user's other devices; the current session stays valid.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<NotificationSettings> getNotificationSettings();

  Future<NotificationSettings> updateNotificationSettings(
    NotificationSettings settings,
  );
}
