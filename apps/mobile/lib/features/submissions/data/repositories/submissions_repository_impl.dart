import '../../../../core/network/api_exception.dart';
import '../../domain/entities/submission.dart';
import '../../domain/repositories/submissions_repository.dart';
import '../datasources/submissions_remote_datasource.dart';

class SubmissionsRepositoryImpl implements SubmissionsRepository {
  SubmissionsRepositoryImpl(this._remote);

  final SubmissionsRemoteDataSource _remote;

  @override
  Future<List<SubmissionCall>> getActiveCalls() => _guard(() async {
        final models = await _remote.getActiveCalls();
        return models.map((m) => m.toEntity()).toList();
      });

  @override
  Future<SubmissionCall> getCall(String id) =>
      _guard(() async => (await _remote.getCall(id)).toEntity());

  @override
  Future<Submission?> getMySubmissionFor(String callId) => _guard(() async {
        final articleId = await _remote.checkSubmission(callId);
        if (articleId == null) return null;
        return (await _remote.getArticle(articleId)).toEntity();
      });

  @override
  Future<List<Submission>> getMySubmissions() => _guard(() async {
        final models = await _remote.getMyArticles();
        return models.map((m) => m.toEntity()).toList();
      });

  @override
  Future<void> submit({
    required String callId,
    required String title,
    required String fileUrl,
    String? content,
  }) =>
      _guard(
        () => _remote.createArticle(
          callId: callId,
          title: title,
          fileUrl: fileUrl,
          content: content,
        ),
      );

  @override
  Future<void> update(
    String id, {
    required String title,
    required String fileUrl,
    String? content,
  }) =>
      _guard(
        () => _remote.updateArticle(
          id,
          title: title,
          fileUrl: fileUrl,
          content: content,
        ),
      );

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}
