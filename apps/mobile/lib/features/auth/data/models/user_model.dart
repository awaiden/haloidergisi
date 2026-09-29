import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  const ProfileModel._();

  const factory ProfileModel({
    required String id,
    required String name,
    String? avatarUrl,
    String? title,
    String? bio,
    String? website,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Profile toEntity() => Profile(
        id: id,
        name: name,
        avatarUrl: avatarUrl,
        title: title,
        bio: bio,
        website: website,
      );
}

/// Shape of `GET /account` (user row + `profile` relation).
@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String email,
    @Default(<String>[]) List<String> roles,
    required DateTime createdAt,
    DateTime? emailVerifiedAt,
    ProfileModel? profile,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  User toEntity() => User(
        id: id,
        email: email,
        roles: roles,
        createdAt: createdAt,
        emailVerifiedAt: emailVerifiedAt,
        profile: profile?.toEntity(),
      );
}
