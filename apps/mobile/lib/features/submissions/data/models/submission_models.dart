import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/submission.dart';

part 'submission_models.freezed.dart';
part 'submission_models.g.dart';

@freezed
abstract class SubmissionCallModel with _$SubmissionCallModel {
  const SubmissionCallModel._();

  const factory SubmissionCallModel({
    required String id,
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    String? description,
  }) = _SubmissionCallModel;

  factory SubmissionCallModel.fromJson(Map<String, dynamic> json) =>
      _$SubmissionCallModelFromJson(json);

  SubmissionCall toEntity() => SubmissionCall(
        id: id,
        title: title,
        description: description,
        startDate: startDate,
        endDate: endDate,
      );
}

@freezed
abstract class ArticleModel with _$ArticleModel {
  const ArticleModel._();

  const factory ArticleModel({
    required String id,
    required String callId,
    required String title,
    required String status,
    required DateTime createdAt,
    String? content,
    String? fileUrl,
    String? adminNote,
    // `call` would clash with freezed's generated copyWith `call()`.
    @JsonKey(name: 'call') SubmissionCallModel? submissionCall,
  }) = _ArticleModel;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  Submission toEntity() => Submission(
        id: id,
        callId: callId,
        title: title,
        status: ArticleStatus.fromApi(status),
        createdAt: createdAt,
        content: content,
        fileUrl: fileUrl,
        adminNote: adminNote,
        call: submissionCall?.toEntity(),
      );
}
