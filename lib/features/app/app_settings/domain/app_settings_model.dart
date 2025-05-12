import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings_model.freezed.dart';
part 'app_settings_model.g.dart';

/// Current version of the app settings schema.
///
/// Version history:
/// - v1: Initial version
/// - v2: Added dark mode support
/// - v3: Added marker and page index support (current)
const currentVersion = 3;

/// Constraints for app settings validation
class AppSettingsConstraints {
  static const int minVersion = 1;
  static const int maxVersion = currentVersion;
  static const int minPageIndex = -1; // -1 indicates no selection
  static const int maxPageIndex = 3; // Arbitrary maximum for safety
  static const int minMarkerIndex = -1;
  static const int maxMarkerIndex = 50; // Arbitrary maximum for safety
}

/// Default application settings used as initial state.
///
/// These values are used when:
/// - The app is launched for the first time
/// - No existing settings are found
/// - Settings migration fails
const defaultValue = AppSettings(
    version: currentVersion,
    isDarkModeEnabled: false,
    selectedMarkerIndex: 0,
    selectedPageIndex: -1);

/// Represents the application settings model with versioning support and compile-time validation.
///
/// This immutable class manages application-wide settings including:
/// - Schema versioning for backwards compatibility
/// - UI preferences (dark mode)
/// - Navigation state (selected page and marker)
///
/// The class enforces strict validation rules at compile-time when using const constructors:
/// - Version must be between 1 and [currentVersion]
/// - Page index must be between -1 and 100
/// - Marker index must be between 0 and 1000
///
/// Example of valid const construction:
/// ```dart
/// const settings = AppSettings(
///   version: 3,
///   isDarkModeEnabled: true,
///   selectedPageIndex: 0,
///   selectedMarkerIndex: 1,
/// );
/// ```
///
/// For runtime validation of dynamic values, use [AppSettings.normalized] factory instead:
/// ```dart
/// final settings = AppSettings.normalized(
///   version: dynamicVersion,
///   selectedPageIndex: dynamicPageIndex,
/// );
/// ```
@freezed
abstract class AppSettings with _$AppSettings {
  /// Creates a new instance of [AppSettings] with compile-time validation.
  ///
  /// All parameters must be compile-time constants for validation to work.
  /// Will fail at compile-time if any of these conditions are not met:
  /// - [version] must be between [AppSettingsConstraints.minVersion] (1) and [AppSettingsConstraints.maxVersion] (3)
  /// - [selectedPageIndex] must be between [AppSettingsConstraints.minPageIndex] (-1) and [AppSettingsConstraints.maxPageIndex] (100)
  /// - [selectedMarkerIndex] must be between [AppSettingsConstraints.minMarkerIndex] (0) and [AppSettingsConstraints.maxMarkerIndex] (1000)
  ///
  /// Example:
  /// ```dart
  /// const settings = AppSettings(
  ///   version: 3,
  ///   isDarkModeEnabled: true,
  ///   selectedPageIndex: 0,
  ///   selectedMarkerIndex: 1,
  /// );
  /// ```
  @Assert(
      'version == null || (version >= AppSettingsConstraints.minVersion && version <= AppSettingsConstraints.maxVersion)',
      'Version must be between ${AppSettingsConstraints.minVersion} and ${AppSettingsConstraints.maxVersion}')
  @Assert(
      'selectedPageIndex == null || (selectedPageIndex >= AppSettingsConstraints.minPageIndex && selectedPageIndex <= AppSettingsConstraints.maxPageIndex)',
      'Page index must be between ${AppSettingsConstraints.minPageIndex} and ${AppSettingsConstraints.maxPageIndex}')
  @Assert(
      'selectedMarkerIndex == null || (selectedMarkerIndex >= AppSettingsConstraints.minMarkerIndex && selectedMarkerIndex <= AppSettingsConstraints.maxMarkerIndex)',
      'Marker index must be between ${AppSettingsConstraints.minMarkerIndex} and ${AppSettingsConstraints.maxMarkerIndex}')
  const factory AppSettings({
    int? version,
    bool? isDarkModeEnabled,
    int? selectedPageIndex,
    int? selectedMarkerIndex,
  }) = _AppSettings;

  /// Creates an [AppSettings] instance from a JSON map.
  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  /// Creates a normalized [AppSettings] instance with runtime validation.
  ///
  /// This factory constructor validates and normalizes input values at runtime.
  /// Use this instead of the const constructor when working with dynamic values.
  ///
  /// Throws:
  /// - [RangeError] if any numeric value is outside its valid range
  ///
  /// Example:
  /// ```dart
  /// final settings = AppSettings.normalized(
  ///   version: someVersion,
  ///   selectedPageIndex: somePageIndex,
  /// );
  /// ```
  factory AppSettings.normalized({
    int? version,
    bool? isDarkModeEnabled,
    int? selectedPageIndex,
    int? selectedMarkerIndex,
  }) {
    // Validate version
    if (version != null) {
      RangeError.checkValueInInterval(
        version,
        AppSettingsConstraints.minVersion,
        AppSettingsConstraints.maxVersion,
        'version',
      );
    }

    // Validate page index
    if (selectedPageIndex != null) {
      RangeError.checkValueInInterval(
        selectedPageIndex,
        AppSettingsConstraints.minPageIndex,
        AppSettingsConstraints.maxPageIndex,
        'selectedPageIndex',
      );
    }

    // Validate marker index
    if (selectedMarkerIndex != null) {
      RangeError.checkValueInInterval(
        selectedMarkerIndex,
        AppSettingsConstraints.minMarkerIndex,
        AppSettingsConstraints.maxMarkerIndex,
        'selectedMarkerIndex',
      );
    }

    return AppSettings(
      version: version,
      isDarkModeEnabled: isDarkModeEnabled,
      selectedPageIndex: selectedPageIndex,
      selectedMarkerIndex: selectedMarkerIndex,
    );
  }

  /// Updates the current settings with non-null values from another instance.
  AppSettings updatepartial(AppSettings other) {
    return AppSettings(
      version: other.version ?? version,
      isDarkModeEnabled: other.isDarkModeEnabled ?? isDarkModeEnabled,
      selectedPageIndex: other.selectedPageIndex ?? selectedPageIndex,
      selectedMarkerIndex: other.selectedMarkerIndex ?? selectedMarkerIndex,
    );
  }

  /// Migrates the settings to the current version.
  AppSettings migrate() {
    if (version != null && version! < currentVersion) {
      if (version == 1) {
        return copyWith(
          version: currentVersion,
        );
      }
    }
    return this;
  }

  /// Returns the default application settings.
  static AppSettings get defaultAppSettings => defaultValue;

  // Private constructor needed for migration method
  const AppSettings._();
}
