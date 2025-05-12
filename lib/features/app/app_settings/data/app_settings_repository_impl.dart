import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/app_settings_model.dart';
import '../domain/app_settings_repository.dart';
import 'app_settings_data_source.dart';

part 'app_settings_repository_impl.g.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final AppSettingsDataSource _dataSource;
  const AppSettingsRepositoryImpl(this._dataSource);

  @override
  Future<Either<String, AppSettings>> getSettings() async {
    return await _dataSource.getSettings();
  }

  @override
  Future<Either<String, AppSettings>> updateSettings(
      AppSettings toUpdateSettings) async {
    return await _dataSource.updateSettings(toUpdateSettings);
  }
}

// Riverpod's provider-based dependency injection
@riverpod
AppSettingsRepository appSettingsRepository(Ref ref) =>
    AppSettingsRepositoryImpl(GetIt.instance<AppSettingsDataSource>());
