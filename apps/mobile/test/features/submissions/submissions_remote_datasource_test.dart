import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/features/submissions/data/datasources/submissions_remote_datasource.dart';

void main() {
  late Object? responseBody;
  late SubmissionsRemoteDataSource dataSource;

  setUp(() {
    final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response(requestOptions: options, data: responseBody),
            );
          },
        ),
      );
    dataSource = SubmissionsRemoteDataSource(dio);
  });

  test('an unknown call (empty 200 body) becomes a readable error', () async {
    responseBody = '';

    await expectLater(
      dataSource.getCall('missing'),
      throwsA(
        isA<ApiException>().having((e) => e.message, 'message', 'Çağrı bulunamadı.'),
      ),
    );
  });

  test('parses my articles with their call', () async {
    responseBody = [
      {
        'id': 'a1',
        'callId': 'c1',
        'authorId': 'u1',
        'title': 'Kader Üzerine',
        'content': '',
        'fileUrl': '1-kader.docx',
        'status': 'REVISION_REQ',
        'adminNote': 'Sonu kısaltılsın.',
        'createdAt': '2026-09-20T10:00:00.000Z',
        'call': {
          'id': 'c1',
          'title': 'Kader ',
          'startDate': '2026-09-01T00:00:00.000Z',
          'endDate': '2026-10-30T00:00:00.000Z',
          'isActive': true,
        },
      },
    ];

    final items = await dataSource.getMyArticles();
    final entity = items.single.toEntity();

    expect(entity.call?.title, 'Kader ');
    expect(entity.status.label, 'Revizyon İstendi');
    expect(entity.adminNote, 'Sonu kısaltılsın.');
  });
}
