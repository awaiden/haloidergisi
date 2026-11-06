// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemberProfileModel {

 String get name; String? get title; String? get bio; String? get website; String? get avatarUrl;
/// Create a copy of MemberProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberProfileModelCopyWith<MemberProfileModel> get copyWith => _$MemberProfileModelCopyWithImpl<MemberProfileModel>(this as MemberProfileModel, _$identity);

  /// Serializes this MemberProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberProfileModel&&(identical(other.name, name) || other.name == name)&&(identical(other.title, title) || other.title == title)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.website, website) || other.website == website)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,title,bio,website,avatarUrl);

@override
String toString() {
  return 'MemberProfileModel(name: $name, title: $title, bio: $bio, website: $website, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $MemberProfileModelCopyWith<$Res>  {
  factory $MemberProfileModelCopyWith(MemberProfileModel value, $Res Function(MemberProfileModel) _then) = _$MemberProfileModelCopyWithImpl;
@useResult
$Res call({
 String name, String? title, String? bio, String? website, String? avatarUrl
});




}
/// @nodoc
class _$MemberProfileModelCopyWithImpl<$Res>
    implements $MemberProfileModelCopyWith<$Res> {
  _$MemberProfileModelCopyWithImpl(this._self, this._then);

  final MemberProfileModel _self;
  final $Res Function(MemberProfileModel) _then;

/// Create a copy of MemberProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? title = freezed,Object? bio = freezed,Object? website = freezed,Object? avatarUrl = freezed,}) {
  return _then(MemberProfileModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberProfileModel].
extension MemberProfileModelPatterns on MemberProfileModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberProfileModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _MemberProfileModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _MemberProfileModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? title,  String? bio,  String? website,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberProfileModel() when $default != null:
return $default(_that.name,_that.title,_that.bio,_that.website,_that.avatarUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? title,  String? bio,  String? website,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _MemberProfileModel():
return $default(_that.name,_that.title,_that.bio,_that.website,_that.avatarUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? title,  String? bio,  String? website,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _MemberProfileModel() when $default != null:
return $default(_that.name,_that.title,_that.bio,_that.website,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemberProfileModel implements MemberProfileModel {
  const _MemberProfileModel({required this.name, this.title, this.bio, this.website, this.avatarUrl});
  factory _MemberProfileModel.fromJson(Map<String, dynamic> json) => _$MemberProfileModelFromJson(json);

@override final  String name;
@override final  String? title;
@override final  String? bio;
@override final  String? website;
@override final  String? avatarUrl;

/// Create a copy of MemberProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberProfileModelCopyWith<_MemberProfileModel> get copyWith => __$MemberProfileModelCopyWithImpl<_MemberProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberProfileModel&&(identical(other.name, name) || other.name == name)&&(identical(other.title, title) || other.title == title)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.website, website) || other.website == website)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,title,bio,website,avatarUrl);

@override
String toString() {
  return 'MemberProfileModel(name: $name, title: $title, bio: $bio, website: $website, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$MemberProfileModelCopyWith<$Res> implements $MemberProfileModelCopyWith<$Res> {
  factory _$MemberProfileModelCopyWith(_MemberProfileModel value, $Res Function(_MemberProfileModel) _then) = __$MemberProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String? title, String? bio, String? website, String? avatarUrl
});




}
/// @nodoc
class __$MemberProfileModelCopyWithImpl<$Res>
    implements _$MemberProfileModelCopyWith<$Res> {
  __$MemberProfileModelCopyWithImpl(this._self, this._then);

  final _MemberProfileModel _self;
  final $Res Function(_MemberProfileModel) _then;

/// Create a copy of MemberProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? title = freezed,Object? bio = freezed,Object? website = freezed,Object? avatarUrl = freezed,}) {
  return _then(_MemberProfileModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CrewMemberModel {

 String get id; MemberProfileModel? get profile;
/// Create a copy of CrewMemberModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrewMemberModelCopyWith<CrewMemberModel> get copyWith => _$CrewMemberModelCopyWithImpl<CrewMemberModel>(this as CrewMemberModel, _$identity);

  /// Serializes this CrewMemberModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrewMemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,profile);

@override
String toString() {
  return 'CrewMemberModel(id: $id, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $CrewMemberModelCopyWith<$Res>  {
  factory $CrewMemberModelCopyWith(CrewMemberModel value, $Res Function(CrewMemberModel) _then) = _$CrewMemberModelCopyWithImpl;
@useResult
$Res call({
 String id, MemberProfileModel? profile
});


$MemberProfileModelCopyWith<$Res>? get profile;

}
/// @nodoc
class _$CrewMemberModelCopyWithImpl<$Res>
    implements $CrewMemberModelCopyWith<$Res> {
  _$CrewMemberModelCopyWithImpl(this._self, this._then);

  final CrewMemberModel _self;
  final $Res Function(CrewMemberModel) _then;

/// Create a copy of CrewMemberModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profile = freezed,}) {
  return _then(CrewMemberModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as MemberProfileModel?,
  ));
}
/// Create a copy of CrewMemberModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberProfileModelCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $MemberProfileModelCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [CrewMemberModel].
extension CrewMemberModelPatterns on CrewMemberModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrewMemberModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrewMemberModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrewMemberModel value)  $default,){
final _that = this;
switch (_that) {
case _CrewMemberModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrewMemberModel value)?  $default,){
final _that = this;
switch (_that) {
case _CrewMemberModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  MemberProfileModel? profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrewMemberModel() when $default != null:
return $default(_that.id,_that.profile);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  MemberProfileModel? profile)  $default,) {final _that = this;
switch (_that) {
case _CrewMemberModel():
return $default(_that.id,_that.profile);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  MemberProfileModel? profile)?  $default,) {final _that = this;
switch (_that) {
case _CrewMemberModel() when $default != null:
return $default(_that.id,_that.profile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CrewMemberModel implements CrewMemberModel {
  const _CrewMemberModel({required this.id, this.profile});
  factory _CrewMemberModel.fromJson(Map<String, dynamic> json) => _$CrewMemberModelFromJson(json);

@override final  String id;
@override final  MemberProfileModel? profile;

/// Create a copy of CrewMemberModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrewMemberModelCopyWith<_CrewMemberModel> get copyWith => __$CrewMemberModelCopyWithImpl<_CrewMemberModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrewMemberModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrewMemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,profile);

@override
String toString() {
  return 'CrewMemberModel(id: $id, profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$CrewMemberModelCopyWith<$Res> implements $CrewMemberModelCopyWith<$Res> {
  factory _$CrewMemberModelCopyWith(_CrewMemberModel value, $Res Function(_CrewMemberModel) _then) = __$CrewMemberModelCopyWithImpl;
@override @useResult
$Res call({
 String id, MemberProfileModel? profile
});


@override $MemberProfileModelCopyWith<$Res>? get profile;

}
/// @nodoc
class __$CrewMemberModelCopyWithImpl<$Res>
    implements _$CrewMemberModelCopyWith<$Res> {
  __$CrewMemberModelCopyWithImpl(this._self, this._then);

  final _CrewMemberModel _self;
  final $Res Function(_CrewMemberModel) _then;

/// Create a copy of CrewMemberModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profile = freezed,}) {
  return _then(_CrewMemberModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as MemberProfileModel?,
  ));
}

/// Create a copy of CrewMemberModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberProfileModelCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $MemberProfileModelCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// @nodoc
mixin _$CrewModel {

 String get id; String get name; int get sort; List<CrewMemberModel> get users;
/// Create a copy of CrewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrewModelCopyWith<CrewModel> get copyWith => _$CrewModelCopyWithImpl<CrewModel>(this as CrewModel, _$identity);

  /// Serializes this CrewModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrewModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.sort, sort) || other.sort == sort)&&const DeepCollectionEquality().equals(other.users, users));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,sort,const DeepCollectionEquality().hash(users));

@override
String toString() {
  return 'CrewModel(id: $id, name: $name, sort: $sort, users: $users)';
}


}

/// @nodoc
abstract mixin class $CrewModelCopyWith<$Res>  {
  factory $CrewModelCopyWith(CrewModel value, $Res Function(CrewModel) _then) = _$CrewModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, int sort, List<CrewMemberModel> users
});




}
/// @nodoc
class _$CrewModelCopyWithImpl<$Res>
    implements $CrewModelCopyWith<$Res> {
  _$CrewModelCopyWithImpl(this._self, this._then);

  final CrewModel _self;
  final $Res Function(CrewModel) _then;

/// Create a copy of CrewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? sort = null,Object? users = null,}) {
  return _then(CrewModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as int,users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<CrewMemberModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [CrewModel].
extension CrewModelPatterns on CrewModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrewModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrewModel value)  $default,){
final _that = this;
switch (_that) {
case _CrewModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrewModel value)?  $default,){
final _that = this;
switch (_that) {
case _CrewModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int sort,  List<CrewMemberModel> users)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrewModel() when $default != null:
return $default(_that.id,_that.name,_that.sort,_that.users);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int sort,  List<CrewMemberModel> users)  $default,) {final _that = this;
switch (_that) {
case _CrewModel():
return $default(_that.id,_that.name,_that.sort,_that.users);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int sort,  List<CrewMemberModel> users)?  $default,) {final _that = this;
switch (_that) {
case _CrewModel() when $default != null:
return $default(_that.id,_that.name,_that.sort,_that.users);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CrewModel extends CrewModel {
  const _CrewModel({required this.id, required this.name, this.sort = 0,  List<CrewMemberModel> users = const <CrewMemberModel>[]}): _users = users,super._();
  factory _CrewModel.fromJson(Map<String, dynamic> json) => _$CrewModelFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  int sort;
 final  List<CrewMemberModel> _users;
@override@JsonKey() List<CrewMemberModel> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}


/// Create a copy of CrewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrewModelCopyWith<_CrewModel> get copyWith => __$CrewModelCopyWithImpl<_CrewModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrewModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrewModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.sort, sort) || other.sort == sort)&&const DeepCollectionEquality().equals(other._users, _users));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,sort,const DeepCollectionEquality().hash(_users));

@override
String toString() {
  return 'CrewModel(id: $id, name: $name, sort: $sort, users: $users)';
}


}

/// @nodoc
abstract mixin class _$CrewModelCopyWith<$Res> implements $CrewModelCopyWith<$Res> {
  factory _$CrewModelCopyWith(_CrewModel value, $Res Function(_CrewModel) _then) = __$CrewModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int sort, List<CrewMemberModel> users
});




}
/// @nodoc
class __$CrewModelCopyWithImpl<$Res>
    implements _$CrewModelCopyWith<$Res> {
  __$CrewModelCopyWithImpl(this._self, this._then);

  final _CrewModel _self;
  final $Res Function(_CrewModel) _then;

/// Create a copy of CrewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? sort = null,Object? users = null,}) {
  return _then(_CrewModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as int,users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<CrewMemberModel>,
  ));
}


}

// dart format on
