import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/team.dart';

part 'team_models.freezed.dart';
part 'team_models.g.dart';

/// Profile fields `GET /crews` exposes for each member (no account data).
@freezed
abstract class MemberProfileModel with _$MemberProfileModel {
  const factory MemberProfileModel({
    required String name,
    String? title,
    String? bio,
    String? website,
    String? avatarUrl,
  }) = _MemberProfileModel;

  factory MemberProfileModel.fromJson(Map<String, dynamic> json) =>
      _$MemberProfileModelFromJson(json);
}

@freezed
abstract class CrewMemberModel with _$CrewMemberModel {
  const factory CrewMemberModel({required String id, MemberProfileModel? profile}) =
      _CrewMemberModel;

  factory CrewMemberModel.fromJson(Map<String, dynamic> json) =>
      _$CrewMemberModelFromJson(json);
}

@freezed
abstract class CrewModel with _$CrewModel {
  const CrewModel._();

  const factory CrewModel({
    required String id,
    required String name,
    @Default(0) int sort,
    @Default(<CrewMemberModel>[]) List<CrewMemberModel> users,
  }) = _CrewModel;

  factory CrewModel.fromJson(Map<String, dynamic> json) => _$CrewModelFromJson(json);

  Crew toEntity() => Crew(
        id: id,
        name: name,
        sort: sort,
        members: [
          for (final user in users)
            if (user.profile case final profile?)
              TeamMember(
                id: user.id,
                name: profile.name,
                title: profile.title,
                bio: profile.bio,
                website: profile.website,
                avatarUrl: profile.avatarUrl,
              ),
        ],
      );
}
