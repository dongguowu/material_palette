// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dark_mode_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DarkModeModel {

 ThemeMode get themeMode; set themeMode(ThemeMode value);
/// Create a copy of DarkModeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DarkModeModelCopyWith<DarkModeModel> get copyWith => _$DarkModeModelCopyWithImpl<DarkModeModel>(this as DarkModeModel, _$identity);

  /// Serializes this DarkModeModel to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'DarkModeModel(themeMode: $themeMode)';
}


}

/// @nodoc
abstract mixin class $DarkModeModelCopyWith<$Res>  {
  factory $DarkModeModelCopyWith(DarkModeModel value, $Res Function(DarkModeModel) _then) = _$DarkModeModelCopyWithImpl;
@useResult
$Res call({
 ThemeMode themeMode
});




}
/// @nodoc
class _$DarkModeModelCopyWithImpl<$Res>
    implements $DarkModeModelCopyWith<$Res> {
  _$DarkModeModelCopyWithImpl(this._self, this._then);

  final DarkModeModel _self;
  final $Res Function(DarkModeModel) _then;

/// Create a copy of DarkModeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,}) {
  return _then(_self.copyWith(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _DarkModeModel implements DarkModeModel {
   _DarkModeModel({required this.themeMode});
  factory _DarkModeModel.fromJson(Map<String, dynamic> json) => _$DarkModeModelFromJson(json);

@override  ThemeMode themeMode;

/// Create a copy of DarkModeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DarkModeModelCopyWith<_DarkModeModel> get copyWith => __$DarkModeModelCopyWithImpl<_DarkModeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DarkModeModelToJson(this, );
}



@override
String toString() {
  return 'DarkModeModel(themeMode: $themeMode)';
}


}

/// @nodoc
abstract mixin class _$DarkModeModelCopyWith<$Res> implements $DarkModeModelCopyWith<$Res> {
  factory _$DarkModeModelCopyWith(_DarkModeModel value, $Res Function(_DarkModeModel) _then) = __$DarkModeModelCopyWithImpl;
@override @useResult
$Res call({
 ThemeMode themeMode
});




}
/// @nodoc
class __$DarkModeModelCopyWithImpl<$Res>
    implements _$DarkModeModelCopyWith<$Res> {
  __$DarkModeModelCopyWithImpl(this._self, this._then);

  final _DarkModeModel _self;
  final $Res Function(_DarkModeModel) _then;

/// Create a copy of DarkModeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,}) {
  return _then(_DarkModeModel(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,
  ));
}


}

// dart format on
