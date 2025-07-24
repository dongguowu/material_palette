# Material 3 Color Explorer - API Documentation

> **🔌 Document Purpose**: Defines public interfaces and usage patterns. Contains API specifications, integration examples, and service interfaces for developers implementing or consuming the color system components.

## Table of Contents
- [Core API Overview](#core-api-overview)
- [Color Calculation Service API](#color-calculation-service-api)
- [Settings Management API](#settings-management-api)
- [Accessibility Service API](#accessibility-service-api)
- [Export Service API](#export-service-api)
- [State Management API](#state-management-api)
- [Navigation API](#navigation-api)
- [Platform Integration API](#platform-integration-api)
- [Usage Examples](#usage-examples)

## Core API Overview

### Service Architecture
The application exposes several key services through dependency injection:

```dart
// Service registration in setup_dependencies.dart
void setupServiceLocator() {
  getIt.registerSingleton<ColorCalculationService>(ColorCalculationService());
  getIt.registerSingleton<AccessibilityService>(AccessibilityService());
  getIt.registerSingleton<SettingsRepository>(SettingsRepositoryImpl());
  getIt.registerSingleton<ExportService>(ExportService());
}
```

### API Access Pattern
```dart
// Access services through GetIt
final colorService = getIt<ColorCalculationService>();
final settingsRepo = getIt<SettingsRepository>();
```

## Color Calculation Service API

### Interface Definition
```dart
abstract class ColorCalculationService {
  /// Generate complete Material 3 color scheme from seed color
  ColorScheme generateColorScheme({
    required Color seedColor,
    required Brightness brightness,
  });
  
  /// Calculate seed color from target primary color
  Future<Color> calculateSeedFromPrimary(Color primaryColor);
  
  /// Generate color palette with all Material 3 roles
  ColorPalette generatePalette(Color seedColor);
  
  /// Get color information for specific role
  ColorRoleInfo getColorRoleInfo(String roleName);
}
```

### Method Details

#### `generateColorScheme()`
**Purpose**: Creates complete Material 3 ColorScheme from seed color
**Parameters**:
- `seedColor`: Base color for palette generation
- `brightness`: Light or dark theme variant

**Returns**: `ColorScheme` with all Material 3 color roles
**Performance**: <50ms execution time
**Example**:
```dart
final scheme = colorService.generateColorScheme(
  seedColor: const Color(0xFF6750A4),
  brightness: Brightness.light,
);
```

#### `calculateSeedFromPrimary()`
**Purpose**: Reverse-engineers seed color from desired primary color
**Parameters**:
- `primaryColor`: Target primary color

**Returns**: `Future<Color>` - calculated seed color
**Performance**: <200ms execution time
**Algorithm**: HCT color space optimization search
**Example**:
```dart
final seedColor = await colorService.calculateSeedFromPrimary(
  const Color(0xFF1976D2),
);
```

#### `generatePalette()`
**Purpose**: Creates comprehensive color palette with accessibility data
**Parameters**:
- `seedColor`: Base color for generation

**Returns**: `ColorPalette` object with light/dark schemes and accessibility info
**Example**:
```dart
final palette = colorService.generatePalette(Colors.blue);
print('Light primary: ${palette.lightScheme.primary}');
print('Accessibility issues: ${palette.accessibilityIssues.length}');
```

## Settings Management API

### Repository Interface
```dart
abstract class SettingsRepository {
  /// Load current app settings
  Future<AppSettings> loadSettings();
  
  /// Save app settings with validation
  Future<void> saveSettings(AppSettings settings);
  
  /// Update specific setting
  Future<void> updateSetting<T>(String key, T value);
  
  /// Reset to default settings
  Future<void> resetToDefaults();
  
  /// Migrate settings between schema versions
  Future<AppSettings> migrateSettings(int fromVersion, int toVersion);
}
```

### Settings Model
```dart
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(1) int schemaVersion,
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(true) bool showAccessibilityInfo,
    @Default(ColorFormat.hex) ColorFormat defaultExportFormat,
    @Default([]) List<Color> recentColors,
    @Default(true) bool enableHapticFeedback,
    @Default(Locale('en')) Locale preferredLocale,
  }) = _AppSettings;
}
```

### Usage Examples
```dart
// Load settings
final settings = await settingsRepo.loadSettings();

// Update theme mode
await settingsRepo.updateSetting('themeMode', ThemeMode.dark);

// Save complete settings
final newSettings = settings.copyWith(showAccessibilityInfo: false);
await settingsRepo.saveSettings(newSettings);
```

## Accessibility Service API

### Interface Definition
```dart
abstract class AccessibilityService {
  /// Calculate WCAG contrast ratio between two colors
  static double calculateContrastRatio(Color foreground, Color background);
  
  /// Get WCAG compliance level for contrast ratio
  static AccessibilityLevel getComplianceLevel(double contrastRatio);
  
  /// Validate entire color scheme for accessibility
  static List<AccessibilityIssue> validateColorScheme(ColorSchemeModel scheme);
  
  /// Generate accessibility report
  AccessibilityReport generateReport(ColorSchemeModel scheme);
  
  /// Get suggestions for improving contrast
  List<ColorSuggestion> getContrastImprovements(
    Color foreground, 
    Color background,
  );
}
```

### Accessibility Models
```dart
@freezed
class AccessibilityIssue with _$AccessibilityIssue {
  const factory AccessibilityIssue({
    required String colorRole,
    required Color foreground,
    required Color background,
    required double contrastRatio,
    required AccessibilityLevel currentLevel,
    required AccessibilityLevel requiredLevel,
    required String suggestion,
  }) = _AccessibilityIssue;
}

enum AccessibilityLevel {
  fail(0, 'Fail'),
  aa(4.5, 'AA'),
  aaa(7.0, 'AAA');
}
```

### Usage Examples
```dart
// Calculate contrast ratio
final ratio = AccessibilityService.calculateContrastRatio(
  Colors.white, 
  Colors.blue,
);

// Validate color scheme
final issues = AccessibilityService.validateColorScheme(colorScheme);
if (issues.isNotEmpty) {
  print('Found ${issues.length} accessibility issues');
}
```

## Export Service API

### Interface Definition
```dart
abstract class ExportService {
  /// Export color scheme to Flutter theme code
  Future<String> exportToFlutter(ColorSchemeModel scheme);
  
  /// Export to CSS custom properties
  Future<String> exportToCSS(ColorSchemeModel scheme);
  
  /// Export to JSON format
  Future<String> exportToJSON(ColorSchemeModel scheme);
  
  /// Export to design tokens format
  Future<String> exportToDesignTokens(ColorSchemeModel scheme);
  
  /// Copy to clipboard
  Future<void> copyToClipboard(String content);
  
  /// Save to file (platform-specific)
  Future<void> saveToFile(String content, String filename);
}
```

### Export Formats
```dart
enum ExportFormat {
  flutter('Flutter Theme'),
  css('CSS Variables'),
  json('JSON'),
  designTokens('Design Tokens'),
  figma('Figma Colors');
}
```

### Usage Examples
```dart
// Export to Flutter code
final flutterCode = await exportService.exportToFlutter(colorScheme);

// Save CSS file
final cssContent = await exportService.exportToCSS(colorScheme);
await exportService.saveToFile(cssContent, 'theme.css');

// Copy JSON to clipboard
final jsonContent = await exportService.exportToJSON(colorScheme);
await exportService.copyToClipboard(jsonContent);
```

## State Management API

### Riverpod Providers
```dart
// Color scheme provider
@riverpod
class ColorSchemeNotifier extends _$ColorSchemeNotifier {
  @override
  ColorSchemeModel build() => ColorSchemeModel.defaultScheme();
  
  void updateFromSeedColor(Color seedColor) { /* implementation */ }
  Future<void> calculateSeedFromPrimary(Color primaryColor) async { /* implementation */ }
}

// Settings provider
@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<AppSettings> build() async => await ref.read(settingsRepositoryProvider).loadSettings();
  
  Future<void> updateSettings(AppSettings settings) async { /* implementation */ }
}

// Navigation provider
@riverpod
class NavigationState extends _$NavigationState {
  @override
  NavigationStateModel build() => const NavigationStateModel();
  
  void selectDestination(int index) { /* implementation */ }
}
```

### Provider Usage
```dart
// In widgets
class ColorExplorerPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(colorSchemeNotifierProvider);
    final settings = ref.watch(settingsNotifierProvider);
    
    return Scaffold(
      // UI implementation
    );
  }
}

// Update state
ref.read(colorSchemeNotifierProvider.notifier).updateFromSeedColor(newColor);
```

## Navigation API

### Auto Route Configuration
```dart
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: ColorExplorerRoute.page,
      path: '/explore',
      initial: true,
    ),
    AutoRoute(
      page: AccessibilityRoute.page,
      path: '/accessibility',
    ),
    AutoRoute(
      page: SettingsRoute.page,
      path: '/settings',
    ),
  ];
}
```

### Navigation Usage
```dart
// Navigate to route
context.router.push(const AccessibilityRoute());

// Navigate with parameters
context.router.push(ColorPickerRoute(initialColor: Colors.blue));

// Replace current route
context.router.pushAndClearStack(const SettingsRoute());
```

## Platform Integration API

### Platform-Specific Services
```dart
// iOS specific features
abstract class IOSColorPickerService {
  Future<Color?> showNativeColorPicker(Color initialColor);
  Future<void> triggerHapticFeedback(HapticFeedbackType type);
  Future<void> shareColorScheme(ColorSchemeModel scheme);
}

// Web specific features
abstract class WebExportService {
  Future<void> downloadFile(String content, String filename);
  void copyToClipboard(String content);
  void updateURL(ColorSchemeModel scheme);
}

// Android specific features
abstract class AndroidIntegrationService {
  Future<Color?> extractDynamicColor();
  Future<void> shareViaIntent(String content);
}
```

## Usage Examples

### Complete Color Exploration Workflow
```dart
class ColorExplorationExample {
  Future<void> exploreColor(Color seedColor) async {
    // 1. Generate color scheme
    final colorService = getIt<ColorCalculationService>();
    final scheme = colorService.generateColorScheme(
      seedColor: seedColor,
      brightness: Brightness.light,
    );
    
    // 2. Validate accessibility
    final accessibilityService = getIt<AccessibilityService>();
    final issues = accessibilityService.validateColorScheme(
      ColorSchemeModel.fromColorScheme(scheme),
    );
    
    // 3. Update UI state
    final ref = ProviderContainer();
    ref.read(colorSchemeNotifierProvider.notifier)
       .updateFromSeedColor(seedColor);
    
    // 4. Save to recent colors
    final settings = await ref.read(settingsNotifierProvider.future);
    final updatedSettings = settings.copyWith(
      recentColors: [seedColor, ...settings.recentColors].take(10).toList(),
    );
    await ref.read(settingsNotifierProvider.notifier)
             .updateSettings(updatedSettings);
    
    // 5. Export if needed
    final exportService = getIt<ExportService>();
    final cssCode = await exportService.exportToCSS(
      ColorSchemeModel.fromColorScheme(scheme),
    );
  }
}
```

### Reverse Engineering Workflow
```dart
class ReverseEngineeringExample {
  Future<void> findSeedFromPrimary(Color targetPrimary) async {
    final colorService = getIt<ColorCalculationService>();
    
    // Calculate seed color
    final calculatedSeed = await colorService.calculateSeedFromPrimary(
      targetPrimary,
    );
    
    // Generate scheme from calculated seed
    final generatedScheme = colorService.generateColorScheme(
      seedColor: calculatedSeed,
      brightness: Brightness.light,
    );
    
    // Compare results
    final colorDistance = _calculateColorDistance(
      targetPrimary,
      generatedScheme.primary,
    );
    
    print('Calculated seed: ${calculatedSeed.value.toRadixString(16)}');
    print('Color distance: $colorDistance');
    print('Generated primary: ${generatedScheme.primary.value.toRadixString(16)}');
  }
}
```

### Custom Export Integration
```dart
class CustomExportExample {
  Future<void> exportToCustomFormat(ColorSchemeModel scheme) async {
    final exportService = getIt<ExportService>();
    
    // Create custom export format
    final customFormat = '''
    // Custom Design System Colors
    export const colors = {
      primary: '${scheme.lightScheme.primary.value.toRadixString(16)}',
      secondary: '${scheme.lightScheme.secondary.value.toRadixString(16)}',
      // ... other colors
    };
    ''';
    
    // Save or copy
    await exportService.saveToFile(customFormat, 'custom-colors.js');
  }
}
```

## Error Handling

### API Error Types
```dart
abstract class ColorSystemException implements Exception {
  const ColorSystemException(this.message);
  final String message;
}

class InvalidColorException extends ColorSystemException {
  const InvalidColorException(super.message);
}

class CalculationTimeoutException extends ColorSystemException {
  const CalculationTimeoutException(super.message);
}

class ExportFailedException extends ColorSystemException {
  const ExportFailedException(super.message);
}
```

### Error Handling Patterns
```dart
try {
  final scheme = colorService.generateColorScheme(
    seedColor: userColor,
    brightness: Brightness.light,
  );
} on InvalidColorException catch (e) {
  // Handle invalid color input
  showErrorDialog('Invalid color: ${e.message}');
} on CalculationTimeoutException catch (e) {
  // Handle timeout
  showErrorDialog('Calculation took too long: ${e.message}');
} catch (e) {
  // Handle unexpected errors
  showErrorDialog('Unexpected error: $e');
}
```

This API documentation provides complete interfaces and usage patterns for integrating with the Material 3 Color Explorer system. All services are designed for testability, performance, and cross-platform compatibility.