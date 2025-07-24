import 'package:flutter_test/flutter_test.dart';
import 'package:material_palette/features/app/app_settings/domain/app_settings_model.dart';

void main() {
  group('AppSettings Model Tests', () {
    test('should merge settings correctly', () {
      // Arrange
      final initialSettings = AppSettings.defaultAppSettings;
      final newSettings = initialSettings.copyWith(isDarkModeEnabled: true);

      // Act
      final mergedSettings = initialSettings.merge(newSettings);

      // Assert
      expect(mergedSettings.isDarkModeEnabled, isTrue);
    });
  });
}
