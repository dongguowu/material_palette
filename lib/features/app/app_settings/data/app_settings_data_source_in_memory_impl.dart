import 'package:fpdart/fpdart.dart';

import '../../app_logger/ui/app_logger.dart' show log, logTitle;
import '../domain/app_settings_model.dart';
import 'app_settings_data_source.dart';

/// Stores application settings in memory without persistence.
///
/// Useful for:
/// * Testing
/// * Prototyping
/// * Temporary storage
///
/// Note: Data is lost when the app restarts.
class InMemoryDataSource implements AppSettingsDataSource {
  /// Current settings stored in memory
  late AppSettings _cache;

  /// Creates a new instance with default settings
  InMemoryDataSource() {
    _cache = AppSettings.defaultAppSettings;
    logTitle(
        '[InMemoryDataSource] initialized default AppSetting (${_cache.hashCode})');
    log(_cache.toString());
  }

  /// Gets the current settings from memory
  ///
  /// Example:
  /// ```dart
  /// final result = await dataSource.getSettings();
  /// result.match(
  ///   (error) => print('Error: $error'),
  ///   (settings) => print('Settings: $settings')
  /// );
  /// ```
  @override
  Future<Either<String, AppSettings>> getSettings() async {
    return Right(_cache);
  }

  /// Updates settings by merging new values with existing ones
  ///
  /// Only updates fields that are explicitly set in [toUpdateSettings].
  /// Null fields in [toUpdateSettings] keep their existing values.
  ///
  /// Example:
  /// ```dart
  /// final result = await dataSource.updateSettings(
  ///   AppSettings(isDarkModeEnabled: true)
  /// );
  /// ```
  @override
  Future<Either<String, AppSettings>> updateSettings(
      AppSettings toUpdateSettings) async {
    final mergedSettings = _cache.updatepartial(toUpdateSettings);

    if (_cache == mergedSettings) {
      logTitle('[InMemoryDataSource] toUpdate is identical');
      return Right(_cache);
    }

    _cache = mergedSettings;
    return Right(_cache);
  }
}


