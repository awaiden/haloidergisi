class SubmissionCall {
  const SubmissionCall({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.description,
  });

  final String id;
  final String title;

  /// Markdown.
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
}

enum ArticleStatus {
  pending('Beklemede'),
  reviewing('İnceleniyor'),
  approved('Onaylandı'),
  rejected('Reddedildi'),
  revisionRequested('Revizyon İstendi');

  const ArticleStatus(this.label);

  final String label;

  static ArticleStatus fromApi(String value) => switch (value) {
        'REVIEWING' => reviewing,
        'APPROVED' => approved,
        'REJECTED' => rejected,
        'REVISION_REQ' => revisionRequested,
        _ => pending,
      };

  /// Mirrors `ArticleGuard`: authors may only edit pending or revision-requested work.
  bool get canEdit => this == pending || this == revisionRequested;
}

/// A piece submitted to a call (`Article` in the API).
class Submission {
  const Submission({
    required this.id,
    required this.callId,
    required this.title,
    required this.status,
    required this.createdAt,
    this.content,
    this.fileUrl,
    this.adminNote,
    this.call,
  });

  final String id;
  final String callId;
  final String title;
  final ArticleStatus status;
  final DateTime createdAt;
  final String? content;

  /// CDN path of the uploaded file.
  final String? fileUrl;
  final String? adminNote;
  final SubmissionCall? call;
}
