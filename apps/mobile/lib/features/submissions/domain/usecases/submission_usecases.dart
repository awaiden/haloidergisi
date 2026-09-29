import '../entities/submission.dart';
import '../repositories/submissions_repository.dart';

class GetActiveCalls {
  const GetActiveCalls(this._repository);

  final SubmissionsRepository _repository;

  Future<List<SubmissionCall>> call() => _repository.getActiveCalls();
}

class GetMySubmissions {
  const GetMySubmissions(this._repository);

  final SubmissionsRepository _repository;

  Future<List<Submission>> call() => _repository.getMySubmissions();
}

/// Creates the submission, or updates the existing one while it is still editable.
class SaveSubmission {
  const SaveSubmission(this._repository);

  final SubmissionsRepository _repository;

  Future<void> call({
    required String callId,
    required String title,
    required String fileUrl,
    String? content,
    Submission? existing,
  }) {
    final cleanTitle = title.trim();
    final cleanContent = content?.trim();
    final body = cleanContent == null || cleanContent.isEmpty ? null : cleanContent;

    if (existing == null) {
      return _repository.submit(
        callId: callId,
        title: cleanTitle,
        fileUrl: fileUrl,
        content: body,
      );
    }
    if (!existing.status.canEdit) {
      throw StateError('Submission ${existing.id} is ${existing.status.name}');
    }
    return _repository.update(
      existing.id,
      title: cleanTitle,
      fileUrl: fileUrl,
      content: body,
    );
  }
}
