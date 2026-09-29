import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/info/data/datasources/info_remote_datasource.dart';
import 'package:mobile/features/info/data/repositories/info_repository_impl.dart';
import 'package:mobile/features/info/domain/entities/contact_message.dart';

void main() {
  late RequestOptions captured;
  late Object? responseBody;
  late InfoRepositoryImpl repository;

  setUp(() {
    responseBody = null;
    final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options;
            handler.resolve(Response(requestOptions: options, data: responseBody));
          },
        ),
      );
    repository = InfoRepositoryImpl(InfoRemoteDataSource(dio));
  });

  test('team comes back in sort order, skipping empty sections and profileless members',
      () async {
    responseBody = {
      'items': [
        {
          'id': 'c2',
          'name': 'Editörler',
          'sort': 1,
          'users': [
            {
              'id': 'u2',
              'profile': {'id': 'p2', 'name': 'Ebru', 'avatarUrl': 'avatars/u2'},
            },
            {'id': 'u3', 'profile': null},
          ],
        },
        {'id': 'c3', 'name': 'Boş', 'sort': 2, 'users': []},
        {
          'id': 'c1',
          'name': 'Yönetim',
          'sort': 0,
          'users': [
            {
              'id': 'u1',
              'profile': {'id': 'p1', 'name': 'Halil', 'title': 'Site Geliştiricisi'},
            },
          ],
        },
      ],
      'meta': {'total': 3},
    };

    final team = await repository.getTeam();

    expect(captured.queryParameters['limit'], -1);
    expect(team.map((c) => c.name), ['Yönetim', 'Editörler']);
    expect(team[1].members.single.name, 'Ebru');
    expect(team[0].members.single.title, 'Site Geliştiricisi');
  });

  test('contact messages carry the Turnstile token', () async {
    await repository.sendMessage(
      const ContactMessage(
        name: 'Ayşe',
        email: 'ayse@example.com',
        subject: 'Merhaba',
        content: 'Dergi harika.',
      ),
      turnstileToken: 'tt',
    );

    expect(captured.method, 'POST');
    expect(captured.path, '/messages');
    expect(captured.data, {
      'name': 'Ayşe',
      'email': 'ayse@example.com',
      'subject': 'Merhaba',
      'content': 'Dergi harika.',
      'cf-turnstile-response': 'tt',
    });
  });
}
