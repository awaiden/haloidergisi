// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    _CategoryModel(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$CategoryModelToJson(_CategoryModel instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_PostModel _$PostModelFromJson(Map<String, dynamic> json) => _PostModel(
  id: json['id'] as String,
  slug: json['slug'] as String,
  title: json['title'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  content: json['content'] as String?,
  coverImage: json['coverImage'] as String?,
  attachment: json['attachment'] as String?,
  category: json['category'] == null
      ? null
      : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PostModelToJson(_PostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'createdAt': instance.createdAt.toIso8601String(),
      'content': instance.content,
      'coverImage': instance.coverImage,
      'attachment': instance.attachment,
      'category': instance.category,
    };
