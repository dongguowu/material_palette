import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app_logger/ui/app_logger.dart';

part 'app_color_seed_notifier.g.dart';

/// A notifier that manages the app's color seed for generating color schemes.
@riverpod
class ColorSeedNotifier extends _$ColorSeedNotifier {
  /// The default color seed used when the app starts.
  static const Color defaultColorSeed = Colors.blue;

  @override
  Color build() {
    // Return the default color seed as the initial state
    return defaultColorSeed;
  }

  /// Updates the color seed to a new value.
  /// This will trigger a rebuild of any widgets watching this provider.
  void updateColorSeed(Color newColor) {
    state = newColor;
  }

  /// Converts a color string to a Color object.
  /// Accepts hex strings in the format: '#RRGGBB' or '#AARRGGBB'
  /// Returns null if the string cannot be parsed.
  Color? _getColorFromString(String colorString) {
    // Remove any leading '#' character
    final hexString = colorString.replaceFirst('#', '');

    // Parse the hex string based on its length
    try {
      if (hexString.length == 6) {
        // RGB format
        return Color(int.parse('FF$hexString', radix: 16));
      } else if (hexString.length == 8) {
        // ARGB format
        return Color(int.parse(hexString, radix: 16));
      }
    } catch (e) {
      logError('Error parsing color string: $colorString');
    }
    return null;
  }

  void updateColorFromString(String colorString) {
    final color = _getColorFromString(colorString);
    if (color != null) {
      state = color;
    }
  }
}
