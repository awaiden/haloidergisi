// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NewsAuthorModel {

 NewsAuthorProfileModel? get profile;
/// Create a copy of NewsAuthorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsAuthorModelCopyWith<NewsAuthorModel> get copyWith => _$NewsAuthorModelCopyWithImpl<NewsAuthorModel>(this as NewsAuthorModel, _$identity);

  /// Serializes this NewsAuthorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsAuthorModel&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profile);

@override
String toString() {
  return 'NewsAuthorModel(profile: $profile)';
}


}

/// @nodoc
abstract mixin class $NewsAuthorModelCopyWith<$Res>  {
  factory $NewsAuthorModelCopyWith(NewsAuthorModel value, $Res Function(NewsAuthorModel) _then) = _$NewsAuthorModelCopyWithImpl;
@useResult
$Res call({
 NewsAuthorProfileModel? profile
});


$NewsAuthorProfileModelCopyWith<$Res>? get profile;

}
/// @nodoc
class _$NewsAuthorModelCopyWithImpl<$Res>
    implements $NewsAuthorModelCopyWith<$Res> {
  _$NewsAuthorModelCopyWithImpl(this._self, this._then);

  final NewsAuthorModel _self;
  final $Res Function(NewsAuthorModel) _then;

/// Create a copy of NewsAuthorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = freezed,}) {
  return _then(NewsAuthorModel(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as NewsAuthorProfileModel?,
  ));
}
/// Create a copy of NewsAuthorModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NewsAuthorProfileModelCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $NewsAuthorProfileModelCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [NewsAuthorModel].
extension NewsAuthorModelPatterns on NewsAuthorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewsAuthorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewsAuthorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewsAuthorModel value)  $default,){
final _that = this;
switch (_that) {
case _NewsAuthorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewsAuthorModel value)?  $default,){
final _that = this;
switch (_that) {
case _NewsAuthorModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NewsAuthorProfileModel? profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewsAuthorModel() when $default != null:
return $default(_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NewsAuthorProfileModel? profile)  $default,) {final _that = this;
switch (_that) {
case _NewsAuthorModel():
return $default(_that.profile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NewsAuthorProfileModel? profile)?  $default,) {final _that = this;
switch (_that) {
case _NewsAuthorModel() when $default != null:
return $default(_that.profile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NewsAuthorModel implements NewsAuthorModel {
  const _NewsAuthorModel({this.profile});
  factory _NewsAuthorModel.fromJson(Map<String, dynamic> json) => _$NewsAuthorModelFromJson(json);

@override final  NewsAuthorProfileModel? profile;

/// Create a copy of NewsAuthorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsAuthorModelCopyWith<_NewsAuthorModel> get copyWith => __$NewsAuthorModelCopyWithImpl<_NewsAuthorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NewsAuthorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsAuthorModel&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profile);

@override
String toString() {
  return 'NewsAuthorModel(profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$NewsAuthorModelCopyWith<$Res> implements $NewsAuthorModelCopyWith<$Res> {
  factory _$NewsAuthorModelCopyWith(_NewsAuthorModel value, $Res Function(_NewsAuthorModel) _then) = __$NewsAuthorModelCopyWithImpl;
@override @useResult
$Res call({
 NewsAuthorProfileModel? profile
});


@override $NewsAuthorProfileModelCopyWith<$Res>? get profile;

}
/// @nodoc
class __$NewsAuthorModelCopyWithImpl<$Res>
    implements _$NewsAuthorModelCopyWith<$Res> {
  __$NewsAuthorModelCopyWithImpl(this._self, this._then);

  final _NewsAuthorModel _self;
  final $Res Function(_NewsAuthorModel) _then;

/// Create a copy of NewsAuthorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = freezed,}) {
  return _then(_NewsAuthorModel(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as NewsAuthorProfileModel?,
  ));
}

/// Create a copy of NewsAuthorModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NewsAuthorProfileModelCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $NewsAuthorProfileModelCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// @nodoc
mixin _$NewsAuthorProfileModel {

 String get name;
/// Create a copy of NewsAuthorProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsAuthorProfileModelCopyWith<NewsAuthorProfileModel> get copyWith => _$NewsAuthorProfileModelCopyWithImpl<NewsAuthorProfileModel>(this as NewsAuthorProfileModel, _$identity);

  /// Serializes this NewsAuthorProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsAuthorProfileModel&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'NewsAuthorProfileModel(name: $name)';
}


}

/// @nodoc
abstract mixin class $NewsAuthorProfileModelCopyWith<$Res>  {
  factory $NewsAuthorProfileModelCopyWith(NewsAuthorProfileModel value, $Res Function(NewsAuthorProfileModel) _then) = _$NewsAuthorProfileModelCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$NewsAuthorProfileModelCopyWithImpl<$Res>
    implements $NewsAuthorProfileModelCopyWith<$Res> {
  _$NewsAuthorProfileModelCopyWithImpl(this._self, this._then);

  final NewsAuthorProfileModel _self;
  final $Res Function(NewsAuthorProfileModel) _then;

/// Create a copy of NewsAuthorProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,}) {
  return _then(NewsAuthorProfileModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NewsAuthorProfileModel].
extension NewsAuthorProfileModelPatterns on NewsAuthorProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewsAuthorProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewsAuthorProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewsAuthorProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _NewsAuthorProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewsAuthorProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _NewsAuthorProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewsAuthorProfileModel() when $default != null:
return $default(_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name)  $default,) {final _that = this;
switch (_that) {
case _NewsAuthorProfileModel():
return $default(_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name)?  $default,) {final _that = this;
switch (_that) {
case _NewsAuthorProfileModel() when $default != null:
return $default(_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NewsAuthorProfileModel implements NewsAuthorProfileModel {
  const _NewsAuthorProfileModel({required this.name});
  factory _NewsAuthorProfileModel.fromJson(Map<String, dynamic> json) => _$NewsAuthorProfileModelFromJson(json);

@override final  String name;

/// Create a copy of NewsAuthorProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsAuthorProfileModelCopyWith<_NewsAuthorProfileModel> get copyWith => __$NewsAuthorProfileModelCopyWithImpl<_NewsAuthorProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NewsAuthorProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsAuthorProfileModel&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'NewsAuthorProfileModel(name: $name)';
}


}

/// @nodoc
abstract mixin class _$NewsAuthorProfileModelCopyWith<$Res> implements $NewsAuthorProfileModelCopyWith<$Res> {
  factory _$NewsAuthorProfileModelCopyWith(_NewsAuthorProfileModel value, $Res Function(_NewsAuthorProfileModel) _then) = __$NewsAuthorProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String name
});




}
/// @nodoc
class __$NewsAuthorProfileModelCopyWithImpl<$Res>
    implements _$NewsAuthorProfileModelCopyWith<$Res> {
  __$NewsAuthorProfileModelCopyWithImpl(this._self, this._then);

  final _NewsAuthorProfileModel _self;
  final $Res Function(_NewsAuthorProfileModel) _then;

/// Create a copy of NewsAuthorProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_NewsAuthorProfileModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$NewsModel {

 String get id; String get slug; String get title; String get content; DateTime get createdAt; DateTime? get publishedAt; String? get keywords; NewsAuthorModel? get author;
/// Create a copy of NewsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsModelCopyWith<NewsModel> get copyWith => _$NewsModelCopyWithImpl<NewsModel>(this as NewsModel, _$identity);

  /// Serializes this NewsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.keywords, keywords) || other.keywords == keywords)&&(identical(other.author, author) || other.author == author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,title,content,createdAt,publishedAt,keywords,author);

@override
String toString() {
  return 'NewsModel(id: $id, slug: $slug, title: $title, content: $content, createdAt: $createdAt, publishedAt: $publishedAt, keywords: $keywords, author: $author)';
}


}

/// @nodoc
abstract mixin class $NewsModelCopyWith<$Res>  {
  factory $NewsModelCopyWith(NewsModel value, $Res Function(NewsModel) _then) = _$NewsModelCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String title, String content, DateTime createdAt, DateTime? publishedAt, String? keywords, NewsAuthorModel? author
});


$NewsAuthorModelCopyWith<$Res>? get author;

}
/// @nodoc
class _$NewsModelCopyWithImpl<$Res>
    implements $NewsModelCopyWith<$Res> {
  _$NewsModelCopyWithImpl(this._self, this._then);

  final NewsModel _self;
  final $Res Function(NewsModel) _then;

/// Create a copy of NewsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? content = null,Object? createdAt = null,Object? publishedAt = freezed,Object? keywords = freezed,Object? author = freezed,}) {
  return _then(NewsModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,keywords: freezed == keywords ? _self.keywords : keywords // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as NewsAuthorModel?,
  ));
}
/// Create a copy of NewsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NewsAuthorModelCopyWith<$Res>? get author {
    if (_self.author == null) {
    return null;
  }

  return $NewsAuthorModelCopyWith<$Res>(_self.author!, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [NewsModel].
extension NewsModelPatterns on NewsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewsModel value)  $default,){
final _that = this;
switch (_that) {
case _NewsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewsModel value)?  $default,){
final _that = this;
switch (_that) {
case _NewsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  String content,  DateTime createdAt,  DateTime? publishedAt,  String? keywords,  NewsAuthorModel? author)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewsModel() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.content,_that.createdAt,_that.publishedAt,_that.keywords,_that.author);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  String content,  DateTime createdAt,  DateTime? publishedAt,  String? keywords,  NewsAuthorModel? author)  $default,) {final _that = this;
switch (_that) {
case _NewsModel():
return $default(_that.id,_that.slug,_that.title,_that.content,_that.createdAt,_that.publishedAt,_that.keywords,_that.author);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String title,  String content,  DateTime createdAt,  DateTime? publishedAt,  String? keywords,  NewsAuthorModel? author)?  $default,) {final _that = this;
switch (_that) {
case _NewsModel() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.content,_that.createdAt,_that.publishedAt,_that.keywords,_that.author);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NewsModel extends NewsModel {
  const _NewsModel({required this.id, required this.slug, required this.title, required this.content, required this.createdAt, this.publishedAt, this.keywords, this.author}): super._();
  factory _NewsModel.fromJson(Map<String, dynamic> json) => _$NewsModelFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String title;
@override final  String content;
@override final  DateTime createdAt;
@override final  DateTime? publishedAt;
@override final  String? keywords;
@override final  NewsAuthorModel? author;

/// Create a copy of NewsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsModelCopyWith<_NewsModel> get copyWith => __$NewsModelCopyWithImpl<_NewsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NewsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.keywords, keywords) || other.keywords == keywords)&&(identical(other.author, author) || other.author == author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,title,content,createdAt,publishedAt,keywords,author);

@override
String toString() {
  return 'NewsModel(id: $id, slug: $slug, title: $title, content: $content, createdAt: $createdAt, publishedAt: $publishedAt, keywords: $keywords, author: $author)';
}


}

/// @nodoc
abstract mixin class _$NewsModelCopyWith<$Res> implements $NewsModelCopyWith<$Res> {
  factory _$NewsModelCopyWith(_NewsModel value, $Res Function(_NewsModel) _then) = __$NewsModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String title, String content, DateTime createdAt, DateTime? publishedAt, String? keywords, NewsAuthorModel? author
});


@override $NewsAuthorModelCopyWith<$Res>? get author;

}
/// @nodoc
class __$NewsModelCopyWithImpl<$Res>
    implements _$NewsModelCopyWith<$Res> {
  __$NewsModelCopyWithImpl(this._self, this._then);

  final _NewsModel _self;
  final $Res Function(_NewsModel) _then;

/// Create a copy of NewsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? content = null,Object? createdAt = null,Object? publishedAt = freezed,Object? keywords = freezed,Object? author = freezed,}) {
  return _then(_NewsModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,keywords: freezed == keywords ? _self.keywords : keywords // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as NewsAuthorModel?,
  ));
}

/// Create a copy of NewsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NewsAuthorModelCopyWith<$Res>? get author {
    if (_self.author == null) {
    return null;
  }

  return $NewsAuthorModelCopyWith<$Res>(_self.author!, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}

// dart format on
