// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettings {

 int? get version; bool? get isDarkModeEnabled; int? get selectedPageIndex; int? get selectedMarkerIndex;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.version, version) || other.version == version)&&(identical(other.isDarkModeEnabled, isDarkModeEnabled) || other.isDarkModeEnabled == isDarkModeEnabled)&&(identical(other.selectedPageIndex, selectedPageIndex) || other.selectedPageIndex == selectedPageIndex)&&(identical(other.selectedMarkerIndex, selectedMarkerIndex) || other.selectedMarkerIndex == selectedMarkerIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,isDarkModeEnabled,selectedPageIndex,selectedMarkerIndex);

@override
String toString() {
  return 'AppSettings(version: $version, isDarkModeEnabled: $isDarkModeEnabled, selectedPageIndex: $selectedPageIndex, selectedMarkerIndex: $selectedMarkerIndex)';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 int? version, bool? isDarkModeEnabled, int? selectedPageIndex, int? selectedMarkerIndex
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = freezed,Object? isDarkModeEnabled = freezed,Object? selectedPageIndex = freezed,Object? selectedMarkerIndex = freezed,}) {
  return _then(_self.copyWith(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,isDarkModeEnabled: freezed == isDarkModeEnabled ? _self.isDarkModeEnabled : isDarkModeEnabled // ignore: cast_nullable_to_non_nullable
as bool?,selectedPageIndex: freezed == selectedPageIndex ? _self.selectedPageIndex : selectedPageIndex // ignore: cast_nullable_to_non_nullable
as int?,selectedMarkerIndex: freezed == selectedMarkerIndex ? _self.selectedMarkerIndex : selectedMarkerIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AppSettings extends AppSettings {
  const _AppSettings({this.version, this.isDarkModeEnabled, this.selectedPageIndex, this.selectedMarkerIndex}): assert(version == null || (version >= AppSettingsConstraints.minVersion && version <= AppSettingsConstraints.maxVersion), 'Version must be between 1 and 3'),assert(selectedPageIndex == null || (selectedPageIndex >= AppSettingsConstraints.minPageIndex && selectedPageIndex <= AppSettingsConstraints.maxPageIndex), 'Page index must be between -1 and 3'),assert(selectedMarkerIndex == null || (selectedMarkerIndex >= AppSettingsConstraints.minMarkerIndex && selectedMarkerIndex <= AppSettingsConstraints.maxMarkerIndex), 'Marker index must be between -1 and 50'),super._();
  factory _AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

@override final  int? version;
@override final  bool? isDarkModeEnabled;
@override final  int? selectedPageIndex;
@override final  int? selectedMarkerIndex;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.version, version) || other.version == version)&&(identical(other.isDarkModeEnabled, isDarkModeEnabled) || other.isDarkModeEnabled == isDarkModeEnabled)&&(identical(other.selectedPageIndex, selectedPageIndex) || other.selectedPageIndex == selectedPageIndex)&&(identical(other.selectedMarkerIndex, selectedMarkerIndex) || other.selectedMarkerIndex == selectedMarkerIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,isDarkModeEnabled,selectedPageIndex,selectedMarkerIndex);

@override
String toString() {
  return 'AppSettings(version: $version, isDarkModeEnabled: $isDarkModeEnabled, selectedPageIndex: $selectedPageIndex, selectedMarkerIndex: $selectedMarkerIndex)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 int? version, bool? isDarkModeEnabled, int? selectedPageIndex, int? selectedMarkerIndex
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = freezed,Object? isDarkModeEnabled = freezed,Object? selectedPageIndex = freezed,Object? selectedMarkerIndex = freezed,}) {
  return _then(_AppSettings(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,isDarkModeEnabled: freezed == isDarkModeEnabled ? _self.isDarkModeEnabled : isDarkModeEnabled // ignore: cast_nullable_to_non_nullable
as bool?,selectedPageIndex: freezed == selectedPageIndex ? _self.selectedPageIndex : selectedPageIndex // ignore: cast_nullable_to_non_nullable
as int?,selectedMarkerIndex: freezed == selectedMarkerIndex ? _self.selectedMarkerIndex : selectedMarkerIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
