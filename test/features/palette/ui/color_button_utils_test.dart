import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Color Button Utility Tests', () {
    /// Helper function to calculate contrast color (copied from _ColorButton)
    Color getContrastColor(Color backgroundColor) {
      final luminance = (0.299 * backgroundColor.red + 
                       0.587 * backgroundColor.green + 
                       0.114 * backgroundColor.blue) / 255;
      
      return luminance > 0.5 ? Colors.black : Colors.white;
    }
    
    /// Helper function to convert color to hex (copied from _ColorButton)
    String colorToHex(Color color) {
      return '#${color.red.toRadixString(16).padLeft(2, '0')}'
             '${color.green.toRadixString(16).padLeft(2, '0')}'
             '${color.blue.toRadixString(16).padLeft(2, '0')}'.toUpperCase();
    }

    group('Contrast Color Calculation', () {
      test('should return black text for light backgrounds', () {
        // Light colors should have black text
        expect(getContrastColor(Colors.white), equals(Colors.black));
        expect(getContrastColor(Colors.yellow), equals(Colors.black));
        expect(getContrastColor(const Color(0xFFFFFFFF)), equals(Colors.black));
        expect(getContrastColor(const Color(0xFFF0F0F0)), equals(Colors.black));
      });

      test('should return white text for dark backgrounds', () {
        // Dark colors should have white text
        expect(getContrastColor(Colors.black), equals(Colors.white));
        expect(getContrastColor(Colors.blue), equals(Colors.white));
        expect(getContrastColor(const Color(0xFF000000)), equals(Colors.white));
        expect(getContrastColor(const Color(0xFF303030)), equals(Colors.white));
      });

      test('should handle edge cases correctly', () {
        // Test medium gray (luminance around 0.5)
        final mediumGray = Color(0xFF808080);
        final contrastColor = getContrastColor(mediumGray);
        expect(contrastColor, isIn([Colors.black, Colors.white]));
        
        // Test specific threshold cases
        expect(getContrastColor(const Color(0xFF7F7F7F)), equals(Colors.white)); // Just below threshold
        expect(getContrastColor(const Color(0xFF808080)), equals(Colors.black)); // At threshold
      });

      test('should be consistent for same colors', () {
        const testColor = Color(0xFF3F51B5); // Indigo
        final result1 = getContrastColor(testColor);
        final result2 = getContrastColor(testColor);
        expect(result1, equals(result2));
      });
    });

    group('Hex Color Conversion', () {
      test('should convert basic colors to hex correctly', () {
        expect(colorToHex(Colors.red), equals('#F44336'));
        expect(colorToHex(Colors.green), equals('#4CAF50'));
        expect(colorToHex(Colors.blue), equals('#2196F3'));
        expect(colorToHex(Colors.white), equals('#FFFFFF'));
        expect(colorToHex(Colors.black), equals('#000000'));
      });

      test('should convert Material colors to hex correctly', () {
        expect(colorToHex(const Color(0xFF2196F3)), equals('#2196F3')); // Blue
        expect(colorToHex(const Color(0xFF4CAF50)), equals('#4CAF50')); // Green
        expect(colorToHex(const Color(0xFFFF9800)), equals('#FF9800')); // Orange
      });

      test('should pad single digit hex values', () {
        expect(colorToHex(const Color(0xFF010203)), equals('#010203'));
        expect(colorToHex(const Color(0xFF000001)), equals('#000001'));
        expect(colorToHex(const Color(0xFF0A0B0C)), equals('#0A0B0C'));
      });

      test('should always return uppercase hex', () {
        expect(colorToHex(const Color(0xFFabcdef)), equals('#ABCDEF'));
        expect(colorToHex(const Color(0xFF123abc)), equals('#123ABC'));
      });

      test('should ignore alpha channel in RGB hex', () {
        // Function only outputs RGB, not ARGB
        expect(colorToHex(const Color(0x80FF0000)), equals('#FF0000')); // Semi-transparent red
        expect(colorToHex(const Color(0x00FF0000)), equals('#FF0000')); // Fully transparent red
      });
    });

    group('Combined Functionality', () {
      test('should provide readable text for all test colors', () {
        final testColors = [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow,
          Colors.purple,
          Colors.orange,
          Colors.pink,
          Colors.brown,
          Colors.grey,
          const Color(0xFF3F51B5), // Indigo
          const Color(0xFF009688), // Teal
          const Color(0xFF795548), // Brown
        ];

        for (final color in testColors) {
          final hex = colorToHex(color);
          final contrastColor = getContrastColor(color);
          
          // Verify hex is valid format
          expect(hex, matches(r'^#[0-9A-F]{6}$'));
          
          // Verify contrast color is either black or white
          expect(contrastColor, isIn([Colors.black, Colors.white]));
          
          // Verify consistency
          expect(getContrastColor(color), equals(contrastColor));
          expect(colorToHex(color), equals(hex));
        }
      });
    });
  });
}