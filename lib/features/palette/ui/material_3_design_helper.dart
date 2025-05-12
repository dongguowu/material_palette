import 'dart:math';

import 'package:flutter/material.dart';

/// A helper class that provides documentation and utilities for using
/// Material 3 Design color system in Flutter applications.
class Material3ColorHelper {
  /// Core color roles in Material 3
  static const Map<String, String> colorRoles = {
    'Primary': 'Main brand color for key UI elements',
    'onPrimary': 'Text/icons on primary surfaces',
    'primaryContainer': 'Alternative primary color for containers',
    'onPrimaryContainer': 'Text/icons on primary containers',

    'Secondary': 'Accent color for less prominent components',
    'onSecondary': 'Text/icons on secondary surfaces',
    'secondaryContainer': 'Alternative secondary color for containers',
    'onSecondaryContainer': 'Text/icons on secondary containers',

    'Tertiary': 'Additional accent color for special components',
    'onTertiary': 'Text/icons on tertiary surfaces',
    'tertiaryContainer': 'Alternative tertiary color for containers',
    'onTertiaryContainer': 'Text/icons on tertiary containers',

    'Surface': 'Background color for components',
    'onSurface': 'Text/icons on surface',
    'surfaceVariant': 'Alternative surface color',
    'onSurfaceVariant': 'Text/icons on surface variant',

    'Background': 'App background color',
    'onBackground': 'Text/icons on background',

    'Error': 'Error indication color',
    'onError': 'Text/icons on error surfaces',
    'errorContainer': 'Alternative error color for containers',
    'onErrorContainer': 'Text/icons on error containers',

    'Outline': 'Border and divider color',
    'OutlineVariant': 'Alternative border color',
  };

  /// Common usage patterns for Material 3 colors
  static Map<String, Widget Function(BuildContext)> commonUsageExamples = {
    'AppBar':
        (context) => AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          title: Text('AppBar Example'),
        ),

    'ElevatedButton':
        (context) => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () {},
          child: Text('Button Example'),
        ),

    'Card':
        (context) => Card(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Card Example',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
  };

  /// Best practices for using Material 3 colors
  static const List<String> bestPractices = [
    'Always pair background colors with their corresponding "on" colors',
    'Use primary colors for main actions and important UI elements',
    'Use secondary colors for less prominent actions and accents',
    'Use surface colors for component backgrounds',
    'Use error colors specifically for error states and warnings',
    'Consider accessibility and contrast ratios when choosing colors',
  ];

  /// Helper method to demonstrate color opacity variations
  static Color getColorWithOpacity(Color baseColor, double opacity) {
    return baseColor.withAlpha((opacity * 255).round());
  }

  /// Helper method to get a color scheme from a seed color
  static ColorScheme generateColorScheme({
    required Color seedColor,
    Brightness brightness = Brightness.light,
  }) {
    return ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness);
  }

  /// Helper method to check contrast ratio between two colors
  static double calculateContrastRatio(Color foreground, Color background) {
    double getLuminance(Color color) {
      final double r = color.r / 255;
      final double g = color.g / 255;
      final double b = color.b / 255;
      return 0.2126 * r + 0.7152 * g + 0.0722 * b;
    }

    final double foregroundLuminance = getLuminance(foreground);
    final double backgroundLuminance = getLuminance(background);

    final double lighter = max(foregroundLuminance, backgroundLuminance);
    final double darker = min(foregroundLuminance, backgroundLuminance);

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Helper method to check if a color combination meets WCAG contrast guidelines
  static bool isAccessible(Color foreground, Color background) {
    final double ratio = calculateContrastRatio(foreground, background);
    return ratio >= 4.5; // WCAG AA standard for regular text
  }
}

/// Extension methods for easy access to color scheme
extension ColorSchemeX on ColorScheme {
  /// Get a color variant with specific opacity
  Color getWithOpacity(Color color, double opacity) {
    return color.withAlpha((opacity * 255).round());
  }

  /// Get a color for interactive states
  Color getInteractiveStateColor({
    required Color baseColor,
    bool isPressed = false,
    bool isHovered = false,
    bool isDisabled = false,
  }) {
    if (isDisabled) return baseColor.withAlpha(102);
    if (isPressed) return baseColor.withAlpha(204);
    if (isHovered) return baseColor.withAlpha(230);
    return baseColor;
  }
}

/// Example usage widget
class Material3ColorExample extends StatelessWidget {
  const Material3ColorExample({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Material 3 Colors'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: ListView(
        children: [
          // Color roles section
          _buildSection(
            'Color Roles',
            Material3ColorHelper.colorRoles.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                subtitle: Text(entry.value),
                tileColor: colorScheme.surfaceContainerHighest,
              );
            }).toList(),
          ),

          // Usage examples section
          _buildSection(
            'Usage Examples',
            Material3ColorHelper.commonUsageExamples.entries.map((entry) {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.key),
                    SizedBox(height: 8),
                    entry.value(context),
                  ],
                ),
              );
            }).toList(),
          ),

          // Best practices section
          _buildSection(
            'Best Practices',
            Material3ColorHelper.bestPractices.map((practice) {
              return ListTile(
                leading: Icon(Icons.check, color: colorScheme.primary),
                title: Text(practice),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        ...children,
        Divider(),
      ],
    );
  }
}
