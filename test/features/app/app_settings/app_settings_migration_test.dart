import 'package:flutter_test/flutter_test.dart';
import 'package:material_palette/features/app/app_settings/domain/app_settings_model.dart';

void main() {
  group('AppSettings Migration Tests', () {
    test('should migrate from version 1 to latest', () {
      // Arrange
      final oldSettings = {
        'version': 1,
        'isDarkModeEnabled': false,
        'selectedPageIndex': 0,
        'selectedMarkerIndex': 0,
      };

      // Act
      final migratedSettings = AppSettings.fromJson(oldSettings).migrate();

      // Assert
      expect(migratedSettings.version, equals(currentVersion));
      expect(migratedSettings.isDarkModeEnabled, isFalse);
      expect(migratedSettings.selectedPageIndex, equals(0));
      expect(migratedSettings.selectedMarkerIndex, equals(0));
    });

    test('should not migrate if already at the latest version', () {
      // Arrange
      final currentSettings = {
        'version': currentVersion,
        'isDarkModeEnabled': true,
        'selectedPageIndex': 1,
        'selectedMarkerIndex': 2,
      };

      // Act
      final migratedSettings = AppSettings.fromJson(currentSettings).migrate();

      // Assert
      expect(migratedSettings.version, equals(currentVersion));
      expect(migratedSettings.isDarkModeEnabled, isTrue);
      expect(migratedSettings.selectedPageIndex, equals(1));
      expect(migratedSettings.selectedMarkerIndex, equals(2));
    });
  });
}
