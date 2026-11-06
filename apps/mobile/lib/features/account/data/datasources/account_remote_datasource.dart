import 'package:dio/dio.dart';

import '../../domain/entities/notification_settings.dart';
import '../../domain/entities/profile_update.dart';

class AccountRemoteDataSource {
  AccountRemoteDataSource(this._dio);

  final Dio _dio;

  /// `ProfileGuard` only lets users edit their own profile.
  Future<void> updateProfile(String profileId, ProfileUpdate update) =>
      _dio.patch<void>(
        '/profile/${Uri.encodeComponent(profileId)}',
        data: {
          'name': update.name,
          if (update.updateTitle) 'title': update.title,
          'bio': update.bio,
          'website': update.website,
          'avatarUrl': ?update.avatarUrl,
        },
      );

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _dio.patch<void>(
        '/account/password',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );

  Future<NotificationSettings> getNotificationSettings() async {
    // An empty body (no settings row yet) arrives as '' rather than a map.
    final response = await _dio.get<Object?>('/account/notification-settings');
    return _settingsFromJson(response.data);
  }

  Future<NotificationSettings> updateNotificationSettings(
    NotificationSettings settings,
  ) async {
    final response = await _dio.patch<Object?>(
      '/account/notification-settings',
      data: {
        'emailNotifications': settings.emailNotifications,
        'newPost': settings.newPost,
        'securityAlert': settings.securityAlert,
      },
    );
    return _settingsFromJson(response.data);
  }

  /// Users created before settings existed have no row yet: use the DB defaults.
  NotificationSettings _settingsFromJson(Object? data) {
    final json = data is Map ? data : null;
    return NotificationSettings(
        emailNotifications: json?['emailNotifications'] as bool? ?? true,
        newPost: json?['newPost'] as bool? ?? true,
      securityAlert: json?['securityAlert'] as bool? ?? true,
    );
  }
}
