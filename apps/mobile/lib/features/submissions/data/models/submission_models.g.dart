// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubmissionCallModel _$SubmissionCallModelFromJson(Map<String, dynamic> json) =>
    _SubmissionCallModel(
      id: json['id'] as String,
      title: json['title'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$SubmissionCallModelToJson(
  _SubmissionCallModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'description': instance.description,
};

_ArticleModel _$ArticleModelFromJson(Map<String, dynamic> json) =>
    _ArticleModel(
      id: json['id'] as String,
      callId: json['callId'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      content: json['content'] as String?,
      fileUrl: json['fileUrl'] as String?,
      adminNote: json['adminNote'] as String?,
      submissionCall: json['call'] == null
          ? null
          : SubmissionCallModel.fromJson(json['call'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ArticleModelToJson(_ArticleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'callId': instance.callId,
      'title': instance.title,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'content': instance.content,
      'fileUrl': instance.fileUrl,
      'adminNote': instance.adminNote,
      'call': instance.submissionCall,
    };
