import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Theme Generation Tests', () {
    test('dark theme should be generated from seed color', () {
      // Arrange
      const seedColor = Colors.blue;
      final expectedColorScheme = ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      );

      // Act
      final darkTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
      );

      // Assert
      expect(darkTheme.colorScheme, equals(expectedColorScheme));
    });
  });
}
