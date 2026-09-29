import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/posts/data/datasources/posts_remote_datasource.dart';

void main() {
  late RequestOptions captured;
  late PostsRemoteDataSource dataSource;

  setUp(() {
    final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options;
            handler.resolve(
              Response(
                requestOptions: options,
                data: {
                  'items': [
                    {
                      'id': 'p1',
                      'slug': 'halo-18',
                      'status': 'PUBLISHED',
                      'title': 'Halo 18. Dal',
                      'createdAt': '2026-09-01T10:00:00.000Z',
                      'coverImage': 'covers/18.jpg',
                      'category': {'id': 'c1', 'name': 'Aylık Dergiler'},
                    },
                  ],
                  'meta': {'total': 31, 'take': 12, 'skip': 0},
                },
              ),
            );
          },
        ),
      );
    dataSource = PostsRemoteDataSource(dio);
  });

  test('always requests published posts with their category', () async {
    final page = await dataSource.getPosts(page: 2, limit: 12);

    expect(captured.path, '/posts');
    expect(captured.queryParameters['status'], 'PUBLISHED');
    expect(jsonDecode(captured.queryParameters['fields'] as String), {
      'category': true,
    });
    expect(captured.queryParameters['page'], 2);
    expect(captured.queryParameters.containsKey('categoryId'), isFalse);
    expect(captured.queryParameters.containsKey('search'), isFalse);

    expect(page.total, 31);
    expect(page.items.single.category?.name, 'Aylık Dergiler');
  });

  test('passes category and search filters when set', () async {
    await dataSource.getPosts(
      page: 1,
      limit: 12,
      categoryId: 'c1',
      search: 'dönüşüm',
    );

    expect(captured.queryParameters['categoryId'], 'c1');
    expect(captured.queryParameters['search'], 'dönüşüm');
  });

  test('other issues exclude the current one', () async {
    await dataSource.getPosts(page: 1, limit: 8, excludeId: 'p1');

    expect(jsonDecode(captured.queryParameters['filter'] as String), {
      'id': {'not': 'p1'},
    });
  });

  test('categories: only those with published issues', () async {
    try {
      await dataSource.getCategories();
    } catch (_) {
      // The canned response is a posts page; only the request matters here.
    }
    expect(captured.path, '/categories');
    expect(captured.queryParameters['published'], 'true');
  });
}
