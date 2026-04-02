// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'h_bot_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HBotData {

 int get count; set count(int value); String? get roleId; set roleId(String? value);
/// Create a copy of HBotData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HBotDataCopyWith<HBotData> get copyWith => _$HBotDataCopyWithImpl<HBotData>(this as HBotData, _$identity);

  /// Serializes this HBotData to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'HBotData(count: $count, roleId: $roleId)';
}


}

/// @nodoc
abstract mixin class $HBotDataCopyWith<$Res>  {
  factory $HBotDataCopyWith(HBotData value, $Res Function(HBotData) _then) = _$HBotDataCopyWithImpl;
@useResult
$Res call({
 int count, String? roleId
});




}
/// @nodoc
class _$HBotDataCopyWithImpl<$Res>
    implements $HBotDataCopyWith<$Res> {
  _$HBotDataCopyWithImpl(this._self, this._then);

  final HBotData _self;
  final $Res Function(HBotData) _then;

/// Create a copy of HBotData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? roleId = freezed,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,roleId: freezed == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HBotData].
extension HBotDataPatterns on HBotData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HBotData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HBotData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HBotData value)  $default,){
final _that = this;
switch (_that) {
case _HBotData():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HBotData value)?  $default,){
final _that = this;
switch (_that) {
case _HBotData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  String? roleId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HBotData() when $default != null:
return $default(_that.count,_that.roleId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  String? roleId)  $default,) {final _that = this;
switch (_that) {
case _HBotData():
return $default(_that.count,_that.roleId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  String? roleId)?  $default,) {final _that = this;
switch (_that) {
case _HBotData() when $default != null:
return $default(_that.count,_that.roleId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HBotData extends HBotData {
   _HBotData({this.count = 0, this.roleId}): super._();
  factory _HBotData.fromJson(Map<String, dynamic> json) => _$HBotDataFromJson(json);

@override@JsonKey()  int count;
@override  String? roleId;

/// Create a copy of HBotData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HBotDataCopyWith<_HBotData> get copyWith => __$HBotDataCopyWithImpl<_HBotData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HBotDataToJson(this, );
}



@override
String toString() {
  return 'HBotData(count: $count, roleId: $roleId)';
}


}

/// @nodoc
abstract mixin class _$HBotDataCopyWith<$Res> implements $HBotDataCopyWith<$Res> {
  factory _$HBotDataCopyWith(_HBotData value, $Res Function(_HBotData) _then) = __$HBotDataCopyWithImpl;
@override @useResult
$Res call({
 int count, String? roleId
});




}
/// @nodoc
class __$HBotDataCopyWithImpl<$Res>
    implements _$HBotDataCopyWith<$Res> {
  __$HBotDataCopyWithImpl(this._self, this._then);

  final _HBotData _self;
  final $Res Function(_HBotData) _then;

/// Create a copy of HBotData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? roleId = freezed,}) {
  return _then(_HBotData(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,roleId: freezed == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
