import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../models/submission_models.dart';

class SubmissionsRemoteDataSource {
  SubmissionsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<SubmissionCallModel>> getActiveCalls() async {
    final response = await _dio.get<List<dynamic>>('/submission-calls/active');
    return response.data!
        .map((e) => SubmissionCallModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<SubmissionCallModel> getCall(String id) async {
    final response = await _dio.get<Object?>(
      '/submission-calls/${Uri.encodeComponent(id)}',
    );
    final data = response.data;
    // An unknown id comes back as 200 with an empty body, not 404.
    if (data is! Map<String, dynamic>) throw const ApiException('Çağrı bulunamadı.');
    return SubmissionCallModel.fromJson(data);
  }

  /// `{ hasSubmitted, articleId? }` for the current user.
  Future<String?> checkSubmission(String callId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/submission-calls/${Uri.encodeComponent(callId)}/check-submission',
    );
    return response.data!['articleId'] as String?;
  }

  Future<ArticleModel> getArticle(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/articles/${Uri.encodeComponent(id)}',
    );
    return ArticleModel.fromJson(response.data!);
  }

  Future<List<ArticleModel>> getMyArticles() async {
    final response = await _dio.get<List<dynamic>>('/articles/my');
    return response.data!
        .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createArticle({
    required String callId,
    required String title,
    required String fileUrl,
    String? content,
  }) =>
      _dio.post<void>(
        '/articles',
        data: {
          'callId': callId,
          'title': title,
          'fileUrl': fileUrl,
          'content': ?content,
        },
      );

  Future<void> updateArticle(
    String id, {
    required String title,
    required String fileUrl,
    String? content,
  }) =>
      _dio.patch<void>(
        '/articles/${Uri.encodeComponent(id)}',
        data: {'title': title, 'fileUrl': fileUrl, 'content': content ?? ''},
      );
}
