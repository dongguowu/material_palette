import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_logger/ui/app_logger.dart' show log, logError, logInfo;
import '../domain/app_settings_model.dart';
import 'app_settings_data_source.dart';

/// A data source implementation for managing app settings using SharedPreferences.
///
/// This class provides persistent storage and caching for application settings using
/// SharedPreferences as the underlying storage mechanism. It implements the
/// [AppSettingsDataSource] interface and provides:
///
/// * Caching to minimize SharedPreferences reads
/// * Error handling with Either type from fpdart
/// * Automatic initialization of default settings
/// * Thread-safe operations
///
/// Example:
/// ```dart
/// final prefs = await SharedPreferencesWithCache.create();
/// final dataSource = SharedPrefsDataSource(prefs);
/// final settingsResult = await dataSource.getSettings();
/// ```
///
/// See also:
/// * [AppSettingsDataSource] - The interface this class implements
/// * [AppSettings] - The model class for application settings
class SharedPrefsDataSource implements AppSettingsDataSource {
  /// SharedPreferences instance with caching capabilities
  final SharedPreferencesWithCache? _prefs;

  /// In-memory cache of the current application settings
  AppSettings? _cachedSettings;

  /// Creates a new [SharedPrefsDataSource] instance.
  ///
  /// Parameters:
  ///   * [_prefs] - SharedPreferences instance for persistent storage.
  ///     If null, the data source will operate in memory-only mode.
  SharedPrefsDataSource(this._prefs) {
    if (_prefs == null) {
      String message =
          '[SharedPrefsDataSource] _prefs is null, cannot persist app settings';
      logError(message);
    }
  }

  /// Retrieves the current application settings.
  ///
  /// Logic flow:
  /// 1. SharedPreferences is not available (_prefs == null):
  ///    1.1. Return existing cache if available
  ///    1.2. Initialize cache with defaults and return if no cache exists
  /// 2. SharedPreferences is available:
  ///    2.a. Successfully load and parse settings from storage, update cache
  ///    2.b. No settings found in storage, persist defaults
  ///    2.c. Loading/parsing fails, fallback to defaults
  ///
  /// Returns:
  /// * [Right] with [AppSettings] on success (from cache, storage, or defaults)
  /// * [Left] with error message on failure (though currently always returns Right)
  @override
  Future<Either<String, AppSettings>> getSettings() async {
    // 1. Handle case when SharedPreferences is not available
    if (_prefs == null) {
      // 1.1. Return existing cache if available
      if (_cachedSettings != null) {
        logInfo(
            '[SharedPrefsDataSource] SharedPreferences unavailable, returning cached settings: ${_cachedSettings!.toJson()}');
        return Right(_cachedSettings!);
      }

      // 1.2. Initialize cache with defaults and return
      _cachedSettings = AppSettings.defaultAppSettings;
      logInfo(
          '[SharedPrefsDataSource] SharedPreferences unavailable, returning default settings: ${_cachedSettings!.toJson()}');
      return Right(_cachedSettings!);
    }

    // 2. Handle case when SharedPreferences is available
    try {
      // First check cache to avoid unnecessary storage reads
      if (_cachedSettings != null) {
        logInfo(
            '[SharedPrefsDataSource] Returning cached settings: ${_cachedSettings!.toJson()}');
        return Right(_cachedSettings!);
      }

      final String? jsonString = _prefs.getString(SharedPrefsKeys.appSettings);

      // 2.a. Successfully load and parse settings
      if (jsonString != null) {
        _cachedSettings = AppSettings.fromJson(jsonDecode(jsonString));
        logInfo(
            '[SharedPrefsDataSource] Loaded settings from SharedPreferences: ${_cachedSettings!.toJson()}');
        return Right(_cachedSettings!);
      }

      // 2.b. No settings found, persist defaults
      _cachedSettings = AppSettings.defaultAppSettings;
      final persistedSettings = await _persistDefaultSettings(_prefs);
      if (persistedSettings == null) {
        logError('[SharedPrefsDataSource] Failed to persist default settings');
      } else {
        logInfo(
            '[SharedPrefsDataSource] Successfully persisted default settings');
      }
      logInfo(
          '[SharedPrefsDataSource] No settings found in SharedPreferences, returning default settings: ${_cachedSettings!.toJson()}');
      return Right(_cachedSettings!);
    } catch (e) {
      // 2.c. Loading/parsing fails, fallback to defaults
      final String message =
          '[SharedPrefsDataSource] Error loading app settings from SharedPreferences: $e';
      logError(message);
      _cachedSettings = AppSettings.defaultAppSettings;
      logInfo(
          '[SharedPrefsDataSource] Returning default settings due to error: ${_cachedSettings!.toJson()}');
      return Right(_cachedSettings!);
    }
  }

  /// Updates the application settings in both cache and persistent storage.
  ///
  /// Logic flow:
  /// 1. Cache validation:
  ///    1.1. If no cache exists, initialize it via getSettings()
  ///    1.2. Create merged settings from cache and updates
  /// 2. Change detection:
  ///    2.1. Compare merged settings with cache
  ///    2.2. If identical, skip update and return cached settings
  /// 3. Update process:
  ///    3.1. If SharedPreferences not available, update cache only
  ///    3.2. If SharedPreferences available:
  ///         a. Attempt to persist to storage
  ///         b. Handle any persistence errors
  ///    3.3. Update cache with new settings
  ///
  /// Returns:
  /// * [Right] with updated [AppSettings] on success
  /// * [Left] with error message on failure (though currently always returns Right)
  ///
  /// Parameters:
  ///   * [partialSettings] - The new partial settings to apply
  @override
  Future<Either<String, AppSettings>> updateSettings(
      AppSettings partialSettings) async {
    // 1. Cache validation
    // 1.1. Ensure cache is initialized
    if (_cachedSettings == null) {
      final String message = '[SharedPrefsDataSource] No cache detected, initializing...';
      logInfo(message);
      await getSettings();
    }

    // 1.2. Create merged settings
    final mergedSettings = _cachedSettings!.merge(partialSettings);

    // 2. Change detection
    // 2.1 & 2.2. Skip if no changes detected
    if (_cachedSettings == mergedSettings) {
      final String message =
          '[SharedPrefsDataSource] No changes detected, skipping update';
      logInfo(message);
      return Right(_cachedSettings!);
    }

    // 3. Update process
    // 3.1. Handle memory-only mode
    if (_prefs == null) {
      _cachedSettings = mergedSettings;
      logInfo(
          '[SharedPrefsDataSource] SharedPreferences unavailable, updated cache only: ${_cachedSettings!.toJson()}');
      return Right(_cachedSettings!);
    }

    // 3.2. Persist to SharedPreferences
    try {
      // 3.2.a. Attempt to persist
      final String jsonString = jsonEncode(mergedSettings.toJson());
      await _prefs.setString(SharedPrefsKeys.appSettings, jsonString);
      logInfo('[SharedPrefsDataSource] Successfully persisted settings: $jsonString');
    } catch (e) {
      // 3.2.b. Handle persistence errors
      final String message =
          '[SharedPrefsDataSource] Error saving settings to SharedPreferences: $e';
      logError(message, e is Error ? e : null);
      // Continue execution - we'll still update the cache even if persistence fails
    }

    // 3.3. Update cache and return
    _cachedSettings = mergedSettings;
    logInfo('[SharedPrefsDataSource] Update complete, new settings: ${_cachedSettings!.toJson()}');
    return Right(_cachedSettings!);
  }

  /// Initializes default settings in SharedPreferences.
  ///
  /// This private method is called when no settings exist in SharedPreferences.
  /// It serializes and stores the default settings configuration.
  ///
  /// Returns the default [AppSettings] after attempting to persist it.
  Future<AppSettings?> _persistDefaultSettings(
      SharedPreferencesWithCache? prefs) async {
    if (prefs == null) {
      return null;
    }

    try {
      // Save the default settings to SharedPreferences.
      final String defaultJson =
          jsonEncode(AppSettings.defaultAppSettings.toJson());
      await prefs.setString(SharedPrefsKeys.appSettings, defaultJson);

      final String message =
          '[SharedPrefsDataSource] Set initial settings: ${AppSettings.defaultAppSettings.toJson()}';
      logInfo(message);
      return AppSettings.defaultAppSettings;
    } catch (e) {
      // Handle errors during initialization: Log the error
      final String message =
          '[SharedPrefsDataSource] Error initializing default app settings: $e';
      logError(message, e is Error ? e : null);
      return null; // Return null if initialization fails
    }
  }

  /// Creates a SharedPreferencesWithCache instance.
  ///
  /// This method initializes SharedPreferencesWithCache with specified cache options.
  /// Returns the instance if successful, or null if initialization fails.
  static Future<SharedPreferencesWithCache?> createPrefs() async {
    try {
      // Create a SharedPreferencesWithCache instance with the specified cache options.
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(
          allowList: <String>{
            SharedPrefsKeys.appSettings,
          },
        ),
      );
      final String message =
          '[SharedPrefsDataSource] SharedPreferencesWithCache created successfully: ${prefs.hashCode}';
      log(message);
      return prefs;
    } catch (e) {
      // Handle errors during initialization: Log the error and return null.
      final String message =
          '[SharedPrefsDataSource] Error creating SharedPreferencesWithCache: $e';
      logError(message, e is Error ? e : null);
      return null; // Return null if initialization fails
    }
  }
}

/// Keys used for storing settings in SharedPreferences
class SharedPrefsKeys {
  /// Key for storing the main application settings JSON
  static const String appSettings = 'fleet_app_settings';
}

