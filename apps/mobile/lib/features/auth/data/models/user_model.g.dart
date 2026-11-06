// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) =>
    _ProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      title: json['title'] as String?,
      bio: json['bio'] as String?,
      website: json['website'] as String?,
    );

Map<String, dynamic> _$ProfileModelToJson(_ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'title': instance.title,
      'bio': instance.bio,
      'website': instance.website,
    };

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  roles:
      (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  createdAt: DateTime.parse(json['createdAt'] as String),
  emailVerifiedAt: json['emailVerifiedAt'] == null
      ? null
      : DateTime.parse(json['emailVerifiedAt'] as String),
  profile: json['profile'] == null
      ? null
      : ProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'roles': instance.roles,
      'createdAt': instance.createdAt.toIso8601String(),
      'emailVerifiedAt': instance.emailVerifiedAt?.toIso8601String(),
      'profile': instance.profile,
    };
