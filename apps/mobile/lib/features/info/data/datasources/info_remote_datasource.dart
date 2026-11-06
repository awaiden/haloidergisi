import 'package:dio/dio.dart';

import '../../../../core/models/paginated.dart';
import '../../domain/entities/contact_message.dart';
import '../models/team_models.dart';

class InfoRemoteDataSource {
  InfoRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<CrewModel>> getCrews() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/crews',
      queryParameters: {'limit': -1, 'sort': 'sort:asc'},
    );
    return Paginated.fromJson(response.data!, CrewModel.fromJson).items;
  }

  /// Turnstile-guarded, like the auth forms.
  Future<void> sendMessage(ContactMessage message, String turnstileToken) =>
      _dio.post<void>(
        '/messages',
        data: {
          'name': message.name,
          'email': message.email,
          'subject': message.subject,
          'content': message.content,
          'cf-turnstile-response': turnstileToken,
        },
      );
}
