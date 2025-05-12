import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dark_mode_model.freezed.dart';
part 'dark_mode_model.g.dart';

@unfreezed
abstract class DarkModeModel with _$DarkModeModel {
  factory DarkModeModel({required ThemeMode themeMode}) = _DarkModeModel;

  factory DarkModeModel.fromJson(Map<String, dynamic> json) =>
      _$DarkModeModelFromJson(json);
}
