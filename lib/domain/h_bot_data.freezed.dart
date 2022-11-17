// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'h_bot_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

HBotData _$HBotDataFromJson(Map<String, dynamic> json) {
  return _HBotData.fromJson(json);
}

/// @nodoc
mixin _$HBotData {
  int get count => throw _privateConstructorUsedError;
  set count(int value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HBotDataCopyWith<HBotData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HBotDataCopyWith<$Res> {
  factory $HBotDataCopyWith(HBotData value, $Res Function(HBotData) then) =
      _$HBotDataCopyWithImpl<$Res>;
  $Res call({int count});
}

/// @nodoc
class _$HBotDataCopyWithImpl<$Res> implements $HBotDataCopyWith<$Res> {
  _$HBotDataCopyWithImpl(this._value, this._then);

  final HBotData _value;
  // ignore: unused_field
  final $Res Function(HBotData) _then;

  @override
  $Res call({
    Object? count = freezed,
  }) {
    return _then(_value.copyWith(
      count: count == freezed
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$$_HBotDataCopyWith<$Res> implements $HBotDataCopyWith<$Res> {
  factory _$$_HBotDataCopyWith(
          _$_HBotData value, $Res Function(_$_HBotData) then) =
      __$$_HBotDataCopyWithImpl<$Res>;
  @override
  $Res call({int count});
}

/// @nodoc
class __$$_HBotDataCopyWithImpl<$Res> extends _$HBotDataCopyWithImpl<$Res>
    implements _$$_HBotDataCopyWith<$Res> {
  __$$_HBotDataCopyWithImpl(
      _$_HBotData _value, $Res Function(_$_HBotData) _then)
      : super(_value, (v) => _then(v as _$_HBotData));

  @override
  _$_HBotData get _value => super._value as _$_HBotData;

  @override
  $Res call({
    Object? count = freezed,
  }) {
    return _then(_$_HBotData(
      count: count == freezed
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_HBotData extends _HBotData {
  _$_HBotData({this.count = 0}) : super._();

  factory _$_HBotData.fromJson(Map<String, dynamic> json) =>
      _$$_HBotDataFromJson(json);

  @override
  @JsonKey()
  int count;

  @override
  String toString() {
    return 'HBotData(count: $count)';
  }

  @JsonKey(ignore: true)
  @override
  _$$_HBotDataCopyWith<_$_HBotData> get copyWith =>
      __$$_HBotDataCopyWithImpl<_$_HBotData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_HBotDataToJson(
      this,
    );
  }
}

abstract class _HBotData extends HBotData {
  factory _HBotData({int count}) = _$_HBotData;
  _HBotData._() : super._();

  factory _HBotData.fromJson(Map<String, dynamic> json) = _$_HBotData.fromJson;

  @override
  int get count;
  set count(int value);
  @override
  @JsonKey(ignore: true)
  _$$_HBotDataCopyWith<_$_HBotData> get copyWith =>
      throw _privateConstructorUsedError;
}
