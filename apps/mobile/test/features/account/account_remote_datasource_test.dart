import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/account/data/datasources/account_remote_datasource.dart';
import 'package:mobile/features/account/domain/entities/profile_update.dart';

void main() {
  late RequestOptions captured;
  late Object? responseBody;
  late AccountRemoteDataSource dataSource;

  setUp(() {
    responseBody = null;
    final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options;
            handler.resolve(
              Response(requestOptions: options, data: responseBody),
            );
          },
        ),
      );
    dataSource = AccountRemoteDataSource(dio);
  });

  test('change password hits the account route with both fields', () async {
    await dataSource.changePassword(
      currentPassword: 'old-secret',
      newPassword: 'new-secret',
    );

    expect(captured.method, 'PATCH');
    expect(captured.path, '/account/password');
    expect(captured.data, {
      'currentPassword': 'old-secret',
      'newPassword': 'new-secret',
    });
  });

  test('profile update targets the profile id', () async {
    await dataSource.updateProfile(
      'p1',
      const ProfileUpdate(name: 'Ayşe', website: 'https://ayse.dev'),
    );

    expect(captured.path, '/profile/p1');
    // Regular users never send the admin-managed title.
    expect(captured.data, {
      'name': 'Ayşe',
      'bio': null,
      'website': 'https://ayse.dev',
    });
  });

  test('admins can set the title', () async {
    await dataSource.updateProfile(
      'p1',
      const ProfileUpdate(name: 'Ayşe', title: 'Editör', updateTitle: true),
    );

    expect((captured.data as Map)['title'], 'Editör');
  });

  test('missing notification settings (empty body) fall back to defaults',
      () async {
    responseBody = '';

    final settings = await dataSource.getNotificationSettings();

    expect(settings.emailNotifications, isTrue);
    expect(settings.newPost, isTrue);
    expect(settings.securityAlert, isTrue);
  });

  test('parses stored notification settings', () async {
    responseBody = {
      'emailNotifications': false,
      'newPost': true,
      'securityAlert': false,
    };

    final settings = await dataSource.getNotificationSettings();

    expect(settings.emailNotifications, isFalse);
    expect(settings.securityAlert, isFalse);
  });
}
