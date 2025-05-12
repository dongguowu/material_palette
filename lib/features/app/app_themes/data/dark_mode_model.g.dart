// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dark_mode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DarkModeModel _$DarkModeModelFromJson(Map<String, dynamic> json) =>
    _DarkModeModel(
      themeMode: $enumDecode(_$ThemeModeEnumMap, json['themeMode']),
    );

Map<String, dynamic> _$DarkModeModelToJson(_DarkModeModel instance) =>
    <String, dynamic>{'themeMode': _$ThemeModeEnumMap[instance.themeMode]!};

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
