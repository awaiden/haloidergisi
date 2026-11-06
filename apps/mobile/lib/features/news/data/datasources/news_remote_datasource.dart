import 'package:dio/dio.dart';

import '../models/news_model.dart';

/// `GET /news` already hides unpublished items for non-admins.
class NewsRemoteDataSource {
  NewsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<NewsModel>> getNews() async {
    final response = await _dio.get<List<dynamic>>('/news');
    return response.data!
        .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<NewsModel> getNewsItem(String idOrSlug) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/news/${Uri.encodeComponent(idOrSlug)}',
    );
    return NewsModel.fromJson(response.data!);
  }
}
