import 'package:flutter/material.dart';

class AppMaterialTheme {
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 10, 61, 1),
      brightness: Brightness.light,
    ),
    // Add any custom theme configurations here
  );

  static final dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      // seedColor: const Color(0xFF1E88E5),
      seedColor: const Color.fromARGB(255, 201, 204, 7),
      brightness: Brightness.dark,
    ),
    // Add any custom theme configurations here
  );

  // If you need to customize specific components:
  static final cardTheme = CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  // You can add custom colors that aren't part of the ColorScheme
  static const customColors = {
    'special': Color(0xFF4CAF50),
    // Add more custom colors if needed
  };
}
