import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:material_palette/features/app/app_color/app_color_seed_notifier.dart';
import 'package:material_palette/setup_dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await setupDependencies(GetIt.instance);
  });

  tearDownAll(() {
    GetIt.I.reset();
  });

  group('ColorSeedNotifier State Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      addTearDown(container.dispose);
    });

    test('should initialize with default blue color', () {
      final initialColor = container.read(colorSeedNotifierProvider);
      expect(initialColor, equals(ColorSeedNotifier.defaultColorSeed));
      expect(initialColor, equals(Colors.blue));
    });

    test('should update color seed when updateColorSeed is called', () {
      const newColor = Color(0xFFFF0000); // Red
      container.read(colorSeedNotifierProvider.notifier).updateColorSeed(newColor);
      final updatedColor = container.read(colorSeedNotifierProvider);
      expect(updatedColor, equals(newColor));
    });

    test('should parse valid hex color string', () {
      const hexString = '#FF0000'; // Red
      container.read(colorSeedNotifierProvider.notifier).updateColorFromString(hexString);
      final updatedColor = container.read(colorSeedNotifierProvider);
      expect(updatedColor.red, equals(255));
      expect(updatedColor.green, equals(0));
      expect(updatedColor.blue, equals(0));
      expect(updatedColor.alpha, equals(255));
    });

    test('should parse hex color string without # prefix', () {
      const hexString = 'FF0000'; // Red without #
      container.read(colorSeedNotifierProvider.notifier).updateColorFromString(hexString);
      final updatedColor = container.read(colorSeedNotifierProvider);
      expect(updatedColor.red, equals(255));
      expect(updatedColor.green, equals(0));
      expect(updatedColor.blue, equals(0));
    });

    test('should parse ARGB hex color string', () {
      const hexString = '#80FF0000'; // Semi-transparent red
      container.read(colorSeedNotifierProvider.notifier).updateColorFromString(hexString);
      final updatedColor = container.read(colorSeedNotifierProvider);
      expect(updatedColor.alpha, equals(128)); // 0x80 = 128
      expect(updatedColor.red, equals(255));
      expect(updatedColor.green, equals(0));
      expect(updatedColor.blue, equals(0));
    });

    test('should not update color for invalid hex string', () {
      const invalidHexString = 'invalid';
      final initialColor = container.read(colorSeedNotifierProvider);
      container.read(colorSeedNotifierProvider.notifier).updateColorFromString(invalidHexString);
      final unchangedColor = container.read(colorSeedNotifierProvider);
      expect(unchangedColor, equals(initialColor));
    });

    test('should not update color for hex string with invalid length', () {
      const invalidHexString = '#FFF'; // Too short
      final initialColor = container.read(colorSeedNotifierProvider);
      container.read(colorSeedNotifierProvider.notifier).updateColorFromString(invalidHexString);
      final unchangedColor = container.read(colorSeedNotifierProvider);
      expect(unchangedColor, equals(initialColor));
    });

    test('should handle multiple color updates', () {
      const color1 = Color(0xFFFF0000); // Red
      const color2 = Color(0xFF00FF00); // Green
      const color3 = Color(0xFF0000FF); // Blue

      container.read(colorSeedNotifierProvider.notifier).updateColorSeed(color1);
      expect(container.read(colorSeedNotifierProvider), equals(color1));

      container.read(colorSeedNotifierProvider.notifier).updateColorSeed(color2);
      expect(container.read(colorSeedNotifierProvider), equals(color2));

      container.read(colorSeedNotifierProvider.notifier).updateColorSeed(color3);
      expect(container.read(colorSeedNotifierProvider), equals(color3));
    });

    test('should maintain state across multiple reads', () {
      const testColor = Color(0xFFFF00FF); // Magenta
      container.read(colorSeedNotifierProvider.notifier).updateColorSeed(testColor);
      final read1 = container.read(colorSeedNotifierProvider);
      final read2 = container.read(colorSeedNotifierProvider);
      final read3 = container.read(colorSeedNotifierProvider);
      expect(read1, equals(testColor));
      expect(read2, equals(testColor));
      expect(read3, equals(testColor));
    });

    group('Color String Parsing Edge Cases', () {
      test('should handle uppercase hex strings', () {
        const hexString = '#ABCDEF';
        container.read(colorSeedNotifierProvider.notifier).updateColorFromString(hexString);
        final updatedColor = container.read(colorSeedNotifierProvider);
        expect(updatedColor.red, equals(0xAB));
        expect(updatedColor.green, equals(0xCD));
        expect(updatedColor.blue, equals(0xEF));
      });

      test('should handle lowercase hex strings', () {
        const hexString = '#abcdef';
        container.read(colorSeedNotifierProvider.notifier).updateColorFromString(hexString);
        final updatedColor = container.read(colorSeedNotifierProvider);
        expect(updatedColor.red, equals(0xAB));
        expect(updatedColor.green, equals(0xCD));
        expect(updatedColor.blue, equals(0xEF));
      });

      test('should handle mixed case hex strings', () {
        const hexString = '#AbCdEf';
        container.read(colorSeedNotifierProvider.notifier).updateColorFromString(hexString);
        final updatedColor = container.read(colorSeedNotifierProvider);
        expect(updatedColor.red, equals(0xAB));
        expect(updatedColor.green, equals(0xCD));
        expect(updatedColor.blue, equals(0xEF));
      });
    });

    group('Provider Listening Tests', () {
      test('should notify listeners when color changes', () {
        Color? previousValue;
        Color? currentValue;
        
        container.listen(colorSeedNotifierProvider, (previous, next) {
          previousValue = previous;
          currentValue = next;
        });

        const newColor = Color(0xFFFF0000);

        container.read(colorSeedNotifierProvider.notifier).updateColorSeed(newColor);

        expect(previousValue, isNotNull);
        expect(currentValue, equals(newColor));
      });
    });
  });
}
