// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemberProfileModel _$MemberProfileModelFromJson(Map<String, dynamic> json) =>
    _MemberProfileModel(
      name: json['name'] as String,
      title: json['title'] as String?,
      bio: json['bio'] as String?,
      website: json['website'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$MemberProfileModelToJson(_MemberProfileModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'title': instance.title,
      'bio': instance.bio,
      'website': instance.website,
      'avatarUrl': instance.avatarUrl,
    };

_CrewMemberModel _$CrewMemberModelFromJson(Map<String, dynamic> json) =>
    _CrewMemberModel(
      id: json['id'] as String,
      profile: json['profile'] == null
          ? null
          : MemberProfileModel.fromJson(
              json['profile'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$CrewMemberModelToJson(_CrewMemberModel instance) =>
    <String, dynamic>{'id': instance.id, 'profile': instance.profile};

_CrewModel _$CrewModelFromJson(Map<String, dynamic> json) => _CrewModel(
  id: json['id'] as String,
  name: json['name'] as String,
  sort: (json['sort'] as num?)?.toInt() ?? 0,
  users:
      (json['users'] as List<dynamic>?)
          ?.map((e) => CrewMemberModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CrewMemberModel>[],
);

Map<String, dynamic> _$CrewModelToJson(_CrewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sort': instance.sort,
      'users': instance.users,
    };
