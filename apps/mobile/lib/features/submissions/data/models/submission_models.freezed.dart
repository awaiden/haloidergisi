// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submission_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubmissionCallModel {

 String get id; String get title; DateTime get startDate; DateTime get endDate; String? get description;
/// Create a copy of SubmissionCallModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmissionCallModelCopyWith<SubmissionCallModel> get copyWith => _$SubmissionCallModelCopyWithImpl<SubmissionCallModel>(this as SubmissionCallModel, _$identity);

  /// Serializes this SubmissionCallModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmissionCallModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,startDate,endDate,description);

@override
String toString() {
  return 'SubmissionCallModel(id: $id, title: $title, startDate: $startDate, endDate: $endDate, description: $description)';
}


}

/// @nodoc
abstract mixin class $SubmissionCallModelCopyWith<$Res>  {
  factory $SubmissionCallModelCopyWith(SubmissionCallModel value, $Res Function(SubmissionCallModel) _then) = _$SubmissionCallModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime startDate, DateTime endDate, String? description
});




}
/// @nodoc
class _$SubmissionCallModelCopyWithImpl<$Res>
    implements $SubmissionCallModelCopyWith<$Res> {
  _$SubmissionCallModelCopyWithImpl(this._self, this._then);

  final SubmissionCallModel _self;
  final $Res Function(SubmissionCallModel) _then;

/// Create a copy of SubmissionCallModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? startDate = null,Object? endDate = null,Object? description = freezed,}) {
  return _then(SubmissionCallModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubmissionCallModel].
extension SubmissionCallModelPatterns on SubmissionCallModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubmissionCallModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubmissionCallModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubmissionCallModel value)  $default,){
final _that = this;
switch (_that) {
case _SubmissionCallModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubmissionCallModel value)?  $default,){
final _that = this;
switch (_that) {
case _SubmissionCallModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime startDate,  DateTime endDate,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmissionCallModel() when $default != null:
return $default(_that.id,_that.title,_that.startDate,_that.endDate,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime startDate,  DateTime endDate,  String? description)  $default,) {final _that = this;
switch (_that) {
case _SubmissionCallModel():
return $default(_that.id,_that.title,_that.startDate,_that.endDate,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime startDate,  DateTime endDate,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _SubmissionCallModel() when $default != null:
return $default(_that.id,_that.title,_that.startDate,_that.endDate,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubmissionCallModel extends SubmissionCallModel {
  const _SubmissionCallModel({required this.id, required this.title, required this.startDate, required this.endDate, this.description}): super._();
  factory _SubmissionCallModel.fromJson(Map<String, dynamic> json) => _$SubmissionCallModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  String? description;

/// Create a copy of SubmissionCallModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmissionCallModelCopyWith<_SubmissionCallModel> get copyWith => __$SubmissionCallModelCopyWithImpl<_SubmissionCallModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubmissionCallModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmissionCallModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,startDate,endDate,description);

@override
String toString() {
  return 'SubmissionCallModel(id: $id, title: $title, startDate: $startDate, endDate: $endDate, description: $description)';
}


}

/// @nodoc
abstract mixin class _$SubmissionCallModelCopyWith<$Res> implements $SubmissionCallModelCopyWith<$Res> {
  factory _$SubmissionCallModelCopyWith(_SubmissionCallModel value, $Res Function(_SubmissionCallModel) _then) = __$SubmissionCallModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime startDate, DateTime endDate, String? description
});




}
/// @nodoc
class __$SubmissionCallModelCopyWithImpl<$Res>
    implements _$SubmissionCallModelCopyWith<$Res> {
  __$SubmissionCallModelCopyWithImpl(this._self, this._then);

  final _SubmissionCallModel _self;
  final $Res Function(_SubmissionCallModel) _then;

/// Create a copy of SubmissionCallModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? startDate = null,Object? endDate = null,Object? description = freezed,}) {
  return _then(_SubmissionCallModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ArticleModel {

 String get id; String get callId; String get title; String get status; DateTime get createdAt; String? get content; String? get fileUrl; String? get adminNote;@JsonKey(name: 'call') SubmissionCallModel? get submissionCall;
/// Create a copy of ArticleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArticleModelCopyWith<ArticleModel> get copyWith => _$ArticleModelCopyWithImpl<ArticleModel>(this as ArticleModel, _$identity);

  /// Serializes this ArticleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArticleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.content, content) || other.content == content)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.adminNote, adminNote) || other.adminNote == adminNote)&&(identical(other.submissionCall, submissionCall) || other.submissionCall == submissionCall));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,callId,title,status,createdAt,content,fileUrl,adminNote,submissionCall);

@override
String toString() {
  return 'ArticleModel(id: $id, callId: $callId, title: $title, status: $status, createdAt: $createdAt, content: $content, fileUrl: $fileUrl, adminNote: $adminNote, submissionCall: $submissionCall)';
}


}

/// @nodoc
abstract mixin class $ArticleModelCopyWith<$Res>  {
  factory $ArticleModelCopyWith(ArticleModel value, $Res Function(ArticleModel) _then) = _$ArticleModelCopyWithImpl;
@useResult
$Res call({
 String id, String callId, String title, String status, DateTime createdAt, String? content, String? fileUrl, String? adminNote,@JsonKey(name: 'call') SubmissionCallModel? submissionCall
});


$SubmissionCallModelCopyWith<$Res>? get submissionCall;

}
/// @nodoc
class _$ArticleModelCopyWithImpl<$Res>
    implements $ArticleModelCopyWith<$Res> {
  _$ArticleModelCopyWithImpl(this._self, this._then);

  final ArticleModel _self;
  final $Res Function(ArticleModel) _then;

/// Create a copy of ArticleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? callId = null,Object? title = null,Object? status = null,Object? createdAt = null,Object? content = freezed,Object? fileUrl = freezed,Object? adminNote = freezed,Object? submissionCall = freezed,}) {
  return _then(ArticleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,fileUrl: freezed == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String?,adminNote: freezed == adminNote ? _self.adminNote : adminNote // ignore: cast_nullable_to_non_nullable
as String?,submissionCall: freezed == submissionCall ? _self.submissionCall : submissionCall // ignore: cast_nullable_to_non_nullable
as SubmissionCallModel?,
  ));
}
/// Create a copy of ArticleModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubmissionCallModelCopyWith<$Res>? get submissionCall {
    if (_self.submissionCall == null) {
    return null;
  }

  return $SubmissionCallModelCopyWith<$Res>(_self.submissionCall!, (value) {
    return _then(_self.copyWith(submissionCall: value));
  });
}
}


/// Adds pattern-matching-related methods to [ArticleModel].
extension ArticleModelPatterns on ArticleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArticleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArticleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArticleModel value)  $default,){
final _that = this;
switch (_that) {
case _ArticleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArticleModel value)?  $default,){
final _that = this;
switch (_that) {
case _ArticleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String callId,  String title,  String status,  DateTime createdAt,  String? content,  String? fileUrl,  String? adminNote, @JsonKey(name: 'call')  SubmissionCallModel? submissionCall)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArticleModel() when $default != null:
return $default(_that.id,_that.callId,_that.title,_that.status,_that.createdAt,_that.content,_that.fileUrl,_that.adminNote,_that.submissionCall);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String callId,  String title,  String status,  DateTime createdAt,  String? content,  String? fileUrl,  String? adminNote, @JsonKey(name: 'call')  SubmissionCallModel? submissionCall)  $default,) {final _that = this;
switch (_that) {
case _ArticleModel():
return $default(_that.id,_that.callId,_that.title,_that.status,_that.createdAt,_that.content,_that.fileUrl,_that.adminNote,_that.submissionCall);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String callId,  String title,  String status,  DateTime createdAt,  String? content,  String? fileUrl,  String? adminNote, @JsonKey(name: 'call')  SubmissionCallModel? submissionCall)?  $default,) {final _that = this;
switch (_that) {
case _ArticleModel() when $default != null:
return $default(_that.id,_that.callId,_that.title,_that.status,_that.createdAt,_that.content,_that.fileUrl,_that.adminNote,_that.submissionCall);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArticleModel extends ArticleModel {
  const _ArticleModel({required this.id, required this.callId, required this.title, required this.status, required this.createdAt, this.content, this.fileUrl, this.adminNote, @JsonKey(name: 'call') this.submissionCall}): super._();
  factory _ArticleModel.fromJson(Map<String, dynamic> json) => _$ArticleModelFromJson(json);

@override final  String id;
@override final  String callId;
@override final  String title;
@override final  String status;
@override final  DateTime createdAt;
@override final  String? content;
@override final  String? fileUrl;
@override final  String? adminNote;
@override@JsonKey(name: 'call') final  SubmissionCallModel? submissionCall;

/// Create a copy of ArticleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArticleModelCopyWith<_ArticleModel> get copyWith => __$ArticleModelCopyWithImpl<_ArticleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArticleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArticleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.content, content) || other.content == content)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.adminNote, adminNote) || other.adminNote == adminNote)&&(identical(other.submissionCall, submissionCall) || other.submissionCall == submissionCall));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,callId,title,status,createdAt,content,fileUrl,adminNote,submissionCall);

@override
String toString() {
  return 'ArticleModel(id: $id, callId: $callId, title: $title, status: $status, createdAt: $createdAt, content: $content, fileUrl: $fileUrl, adminNote: $adminNote, submissionCall: $submissionCall)';
}


}

/// @nodoc
abstract mixin class _$ArticleModelCopyWith<$Res> implements $ArticleModelCopyWith<$Res> {
  factory _$ArticleModelCopyWith(_ArticleModel value, $Res Function(_ArticleModel) _then) = __$ArticleModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String callId, String title, String status, DateTime createdAt, String? content, String? fileUrl, String? adminNote,@JsonKey(name: 'call') SubmissionCallModel? submissionCall
});


@override $SubmissionCallModelCopyWith<$Res>? get submissionCall;

}
/// @nodoc
class __$ArticleModelCopyWithImpl<$Res>
    implements _$ArticleModelCopyWith<$Res> {
  __$ArticleModelCopyWithImpl(this._self, this._then);

  final _ArticleModel _self;
  final $Res Function(_ArticleModel) _then;

/// Create a copy of ArticleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? callId = null,Object? title = null,Object? status = null,Object? createdAt = null,Object? content = freezed,Object? fileUrl = freezed,Object? adminNote = freezed,Object? submissionCall = freezed,}) {
  return _then(_ArticleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,fileUrl: freezed == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String?,adminNote: freezed == adminNote ? _self.adminNote : adminNote // ignore: cast_nullable_to_non_nullable
as String?,submissionCall: freezed == submissionCall ? _self.submissionCall : submissionCall // ignore: cast_nullable_to_non_nullable
as SubmissionCallModel?,
  ));
}

/// Create a copy of ArticleModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubmissionCallModelCopyWith<$Res>? get submissionCall {
    if (_self.submissionCall == null) {
    return null;
  }

  return $SubmissionCallModelCopyWith<$Res>(_self.submissionCall!, (value) {
    return _then(_self.copyWith(submissionCall: value));
  });
}
}

// dart format on
