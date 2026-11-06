import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/models/paginated.dart';
import '../models/post_model.dart';

/// `GET /posts` is public and does not filter by status itself, so every list
/// request must ask for `status=PUBLISHED` (as the web does).
class PostsRemoteDataSource {
  PostsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<Paginated<PostModel>> getPosts({
    required int page,
    required int limit,
    String? categoryId,
    String? search,
    String? excludeId,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/posts',
      queryParameters: {
        'status': 'PUBLISHED',
        'fields': jsonEncode({'category': true}),
        'page': page,
        'limit': limit,
        'categoryId': ?categoryId,
        'search': ?search,
        if (excludeId != null)
          'filter': jsonEncode({
            'id': {'not': excludeId},
          }),
      },
    );
    return Paginated.fromJson(response.data!, PostModel.fromJson);
  }

  Future<PostModel> getPost(String idOrSlug) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/posts/${Uri.encodeComponent(idOrSlug)}',
    );
    return PostModel.fromJson(response.data!);
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/categories',
      // Only categories that actually hold published issues.
      queryParameters: {'limit': -1, 'sort': 'name:asc', 'published': 'true'},
    );
    return Paginated.fromJson(response.data!, CategoryModel.fromJson).items;
  }
}
