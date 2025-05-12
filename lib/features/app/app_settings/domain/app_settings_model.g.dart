// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  version: (json['version'] as num?)?.toInt(),
  isDarkModeEnabled: json['isDarkModeEnabled'] as bool?,
  selectedPageIndex: (json['selectedPageIndex'] as num?)?.toInt(),
  selectedMarkerIndex: (json['selectedMarkerIndex'] as num?)?.toInt(),
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'version': instance.version,
      'isDarkModeEnabled': instance.isDarkModeEnabled,
      'selectedPageIndex': instance.selectedPageIndex,
      'selectedMarkerIndex': instance.selectedMarkerIndex,
    };
