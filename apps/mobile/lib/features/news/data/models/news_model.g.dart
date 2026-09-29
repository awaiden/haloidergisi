// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NewsAuthorModel _$NewsAuthorModelFromJson(Map<String, dynamic> json) =>
    _NewsAuthorModel(
      profile: json['profile'] == null
          ? null
          : NewsAuthorProfileModel.fromJson(
              json['profile'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$NewsAuthorModelToJson(_NewsAuthorModel instance) =>
    <String, dynamic>{'profile': instance.profile};

_NewsAuthorProfileModel _$NewsAuthorProfileModelFromJson(
  Map<String, dynamic> json,
) => _NewsAuthorProfileModel(name: json['name'] as String);

Map<String, dynamic> _$NewsAuthorProfileModelToJson(
  _NewsAuthorProfileModel instance,
) => <String, dynamic>{'name': instance.name};

_NewsModel _$NewsModelFromJson(Map<String, dynamic> json) => _NewsModel(
  id: json['id'] as String,
  slug: json['slug'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  publishedAt: json['publishedAt'] == null
      ? null
      : DateTime.parse(json['publishedAt'] as String),
  keywords: json['keywords'] as String?,
  author: json['author'] == null
      ? null
      : NewsAuthorModel.fromJson(json['author'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NewsModelToJson(_NewsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'keywords': instance.keywords,
      'author': instance.author,
    };
