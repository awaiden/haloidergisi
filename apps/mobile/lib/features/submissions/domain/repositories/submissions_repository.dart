import '../entities/submission.dart';

abstract interface class SubmissionsRepository {
  /// Calls that are active and inside their date window.
  Future<List<SubmissionCall>> getActiveCalls();

  Future<SubmissionCall> getCall(String id);

  /// The signed-in user's submission to [callId], if any (one per call).
  Future<Submission?> getMySubmissionFor(String callId);

  Future<List<Submission>> getMySubmissions();

  Future<void> submit({
    required String callId,
    required String title,
    required String fileUrl,
    String? content,
  });

  Future<void> update(
    String id, {
    required String title,
    required String fileUrl,
    String? content,
  });
}
