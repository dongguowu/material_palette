import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_palette/features/app/app_color/app_color_seed_notifier.dart';

void main() {
  group('ColorSeedNotifier State Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with default blue color', () {
      // Act
      final initialColor = container.read(colorSeedNotifierProvider);

      // Assert
      expect(initialColor, equals(ColorSeedNotifier.defaultColorSeed));
      expect(initialColor, equals(Colors.blue));
    });

    test('should update color seed when updateColorSeed is called', () {
      // Arrange
      const newColor = Color(0xFFFF0000); // Red

      // Act
      container.read(colorSeedNotifierProvider.notifier).updateColorSeed(newColor);

      // Assert
      final updatedColor = container.read(colorSeedNotifierProvider);
      expect(updatedColor, equals(newColor));
    });

    test('should parse valid hex color string', () {
      // Arrange
      const hexString = '#FF0000'; // Red

      // Act
      container.read(colorSeedNotifierProvider.notifier).updateColorFromString(hexString);

      // Assert
      final updatedColor = container.read(colorSeedNotifierProvider);
      expect(updatedColor.red, equals(255));
      expect(updatedColor.green, equals(0));
      expect(updatedColor.blue, equals(0));
      expect(updatedColor.alpha, equals(255));
    });

    test('should parse hex color string without # prefix', () {
      // Arrange
      const hexString = 'FF0000'; // Red without #

      // Act
      container.read(colorSeedNotifierProvider.notifier).updateColorFromString(hexString);

      // Assert
      final updatedColor = container.read(colorSeedNotifierProvider);
      expect(updatedColor.red, equals(255));
      expect(updatedColor.green, equals(0));
      expect(updatedColor.blue, equals(0));
    });

    test('should parse ARGB hex color string', () {
      // Arrange
      const hexString = '#80FF0000'; // Semi-transparent red

      // Act
      container.read(colorSeedNotifierProvider.notifier).updateColorFromString(hexString);

      // Assert
      final updatedColor = container.read(colorSeedNotifierProvider);
      expect(updatedColor.alpha, equals(128)); // 0x80 = 128
      expect(updatedColor.red, equals(255));
      expect(updatedColor.green, equals(0));
      expect(updatedColor.blue, equals(0));
    });

    test('should not update color for invalid hex string', () {
      // Arrange
      const invalidHexString = 'invalid';
      final initialColor = container.read(colorSeedNotifierProvider);

      // Act
      container.read(colorSeedNotifierProvider.notifier).updateColorFromString(invalidHexString);

      // Assert - Color should remain unchanged
      final unchangedColor = container.read(colorSeedNotifierProvider);
      expect(unchangedColor, equals(initialColor));
    });

    test('should not update color for hex string with invalid length', () {
      // Arrange
      const invalidHexString = '#FFF'; // Too short
      final initialColor = container.read(colorSeedNotifierProvider);

      // Act
      container.read(colorSeedNotifierProvider.notifier).updateColorFromString(invalidHexString);

      // Assert - Color should remain unchanged
      final unchangedColor = container.read(colorSeedNotifierProvider);
      expect(unchangedColor, equals(initialColor));
    });

    test('should handle multiple color updates', () {
      // Arrange
      const color1 = Color(0xFFFF0000); // Red
      const color2 = Color(0xFF00FF00); // Green
      const color3 = Color(0xFF0000FF); // Blue

      // Act & Assert
      container.read(colorSeedNotifierProvider.notifier).updateColorSeed(color1);
      expect(container.read(colorSeedNotifierProvider), equals(color1));

      container.read(colorSeedNotifierProvider.notifier).updateColorSeed(color2);
      expect(container.read(colorSeedNotifierProvider), equals(color2));

      container.read(colorSeedNotifierProvider.notifier).updateColorSeed(color3);
      expect(container.read(colorSeedNotifierProvider), equals(color3));
    });

    test('should maintain state across multiple reads', () {
      // Arrange
      const testColor = Color(0xFFFF00FF); // Magenta

      // Act
      container.read(colorSeedNotifierProvider.notifier).updateColorSeed(testColor);

      // Assert - Multiple reads should return the same color
      final read1 = container.read(colorSeedNotifierProvider);
      final read2 = container.read(colorSeedNotifierProvider);
      final read3 = container.read(colorSeedNotifierProvider);

      expect(read1, equals(testColor));
      expect(read2, equals(testColor));
      expect(read3, equals(testColor));
      expect(read1, equals(read2));
      expect(read2, equals(read3));
    });

    group('Color String Parsing Edge Cases', () {
      test('should handle uppercase hex strings', () {
        // Arrange
        const hexString = '#ABCDEF';

        // Act
        container.read(colorSeedNotifierProvider.notifier).updateColorFromString(hexString);

        // Assert
        final updatedColor = container.read(colorSeedNotifierProvider);
        expect(updatedColor.red, equals(0xAB));
        expect(updatedColor.green, equals(0xCD));
        expect(updatedColor.blue, equals(0xEF));
      });

      test('should handle lowercase hex strings', () {
        // Arrange
        const hexString = '#abcdef';

        // Act
        container.read(colorSeedNotifierProvider.notifier).updateColorFromString(hexString);

        // Assert
        final updatedColor = container.read(colorSeedNotifierProvider);
        expect(updatedColor.red, equals(0xAB));
        expect(updatedColor.green, equals(0xCD));
        expect(updatedColor.blue, equals(0xEF));
      });

      test('should handle mixed case hex strings', () {
        // Arrange
        const hexString = '#AbCdEf';

        // Act
        container.read(colorSeedNotifierProvider.notifier).updateColorFromString(hexString);

        // Assert
        final updatedColor = container.read(colorSeedNotifierProvider);
        expect(updatedColor.red, equals(0xAB));
        expect(updatedColor.green, equals(0xCD));
        expect(updatedColor.blue, equals(0xEF));
      });
    });

    group('Provider Listening Tests', () {
      test('should notify listeners when color changes', () {
        // Arrange
        Color? previousValue;
        Color? currentValue;
        
        container.listen(colorSeedNotifierProvider, (previous, next) {
          previousValue = previous;
          currentValue = next;
        });

        const newColor = Color(0xFFFF0000);

        // Act
        container.read(colorSeedNotifierProvider.notifier).updateColorSeed(newColor);

        // Assert
        expect(currentValue, equals(newColor));
      });
    });
  });
}