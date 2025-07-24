# Material 3 Color Explorer - Technical Specifications

> **🔧 Document Purpose**: Defines HOW to build the system technically. Contains detailed code examples, implementation patterns, API specifications, and testing strategies for developers and technical architects.

## Table of Contents
- [Technology Stack & Dependencies](#technology-stack--dependencies)
- [Architecture Overview](#architecture-overview)
- [State Management](#state-management)
- [Material 3 Color Implementation](#material-3-color-implementation)
- [Adaptive UI System](#adaptive-ui-system)
- [Data Models](#data-models)
- [Navigation & Routing](#navigation--routing)
- [Settings & Persistence](#settings--persistence)
- [Accessibility Implementation](#accessibility-implementation)
- [Performance Specifications](#performance-specifications)
- [Platform-Specific Implementations](#platform-specific-implementations)
- [Testing Strategy](#testing-strategy)
- [Build & Deployment](#build--deployment)

## Technology Stack & Dependencies

### Core Flutter Packages
```yaml
dependencies:
  flutter_riverpod: ^2.x.x          # State management
  auto_route: ^7.x.x                # Type-safe navigation
  shared_preferences: ^2.x.x        # Data persistence
  flutter_adaptive_scaffold: ^0.x.x # Responsive UI framework
  flutter_colorpicker: ^1.x.x       # Advanced color selection
  logger: ^2.x.x                     # Structured logging
  flutter_logs: ^2.x.x              # Log management
  get_it: ^7.x.x                     # Dependency injection
  freezed_annotation: ^2.x.x        # Immutable models
  json_annotation: ^4.x.x           # JSON serialization

dev_dependencies:
  build_runner: ^2.x.x               # Build system automation
  freezed: ^2.x.x                    # Code generation for models
  json_serializable: ^6.x.x         # JSON serialization
  riverpod_generator: ^2.x.x         # Provider code generation
  auto_route_generator: ^7.x.x       # Route generation
  riverpod_lint: ^2.x.x              # Linting rules
```

### Architecture Dependencies
- **State Management**: Riverpod with code generation for reactive patterns
- **Clean Architecture**: Feature-based modular structure with clear layer separation
- **Dependency Injection**: GetIt service locator with singleton and factory patterns
- **Code Generation**: Extensive use of build_runner for productivity and type safety

## Architecture Overview

### Clean Architecture Implementation
```
lib/
├── core/
│   ├── constants/          # App-wide constants
│   ├── errors/            # Error handling and exceptions
│   ├── services/          # External services and APIs
│   ├── theme/             # Material 3 theme implementation
│   └── utils/             # Utility functions and helpers
├── features/
│   ├── color_explorer/    # Main color exploration feature
│   │   ├── data/         # Data sources and repositories
│   │   ├── domain/       # Business logic and entities
│   │   └── presentation/ # UI components and state management
│   ├── settings/         # Application settings
│   └── accessibility/    # Accessibility tools and validation
├── shared/
│   ├── widgets/          # Reusable UI components
│   ├── models/           # Shared data models
│   └── providers/        # Shared Riverpod providers
└── main.dart
```

### Dependency Injection Setup
```dart
// lib/core/services/service_locator.dart
final getIt = GetIt.instance;

void setupServiceLocator() {
  // Singletons
  getIt.registerSingleton<Logger>(Logger());
  getIt.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance()
  );
  
  // Factories
  getIt.registerFactory<ColorCalculationService>(
    () => ColorCalculationService()
  );
  getIt.registerFactory<AccessibilityService>(
    () => AccessibilityService()
  );
}
```

## State Management

### Riverpod Provider Architecture
```dart
// lib/shared/providers/app_providers.dart

// Global app state
@riverpod
class AppState extends _$AppState {
  @override
  AppStateModel build() => const AppStateModel();
  
  void updateThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }
}

// Color scheme state
@riverpod
class ColorScheme extends _$ColorScheme {
  @override
  ColorSchemeModel build() => ColorSchemeModel.defaultScheme();
  
  void updateFromSeedColor(Color seedColor) {
    final lightScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );
    final darkScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );
    
    state = state.copyWith(
      seedColor: seedColor,
      lightScheme: lightScheme,
      darkScheme: darkScheme,
    );
  }
  
  Future<void> calculateSeedFromPrimary(Color primaryColor) async {
    final calculatedSeed = await _calculateSeedColor(primaryColor);
    updateFromSeedColor(calculatedSeed);
  }
}

// Settings state with persistence
@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<AppSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings.fromPreferences(prefs);
  }
  
  Future<void> updateSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await settings.saveToPreferences(prefs);
    state = AsyncValue.data(settings);
  }
}
```

### State Model Definitions
```dart
// lib/shared/models/app_state.dart
@freezed
class AppStateModel with _$AppStateModel {
  const factory AppStateModel({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(ScreenSize.small) ScreenSize currentScreenSize,
  }) = _AppStateModel;
  
  factory AppStateModel.fromJson(Map<String, dynamic> json) =>
      _$AppStateModelFromJson(json);
}

// lib/shared/models/color_scheme_model.dart
@freezed
class ColorSchemeModel with _$ColorSchemeModel {
  const factory ColorSchemeModel({
    required Color seedColor,
    required ColorScheme lightScheme,
    required ColorScheme darkScheme,
    @Default([]) List<AccessibilityIssue> accessibilityIssues,
    @Default([]) List<Color> recentColors,
  }) = _ColorSchemeModel;
  
  const ColorSchemeModel._();
  
  factory ColorSchemeModel.defaultScheme() => ColorSchemeModel(
    seedColor: const Color(0xFF6750A4),
    lightScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.light,
    ),
    darkScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.dark,
    ),
  );
  
  // Business logic methods
  Map<String, Color> get allLightColors => {
    'primary': lightScheme.primary,
    'onPrimary': lightScheme.onPrimary,
    'primaryContainer': lightScheme.primaryContainer,
    'onPrimaryContainer': lightScheme.onPrimaryContainer,
    // ... all other color roles
  };
  
  Map<String, Color> get allDarkColors => {
    // Similar structure for dark theme
  };
  
  factory ColorSchemeModel.fromJson(Map<String, dynamic> json) =>
      _$ColorSchemeModelFromJson(json);
}
```

## Material 3 Color Implementation

### HCT Color Space Calculations
```dart
// lib/core/services/color_calculation_service.dart
class ColorCalculationService {
  static const double _primaryTone = 40.0;
  static const double _primaryContainerTone = 90.0;
  
  /// Generate complete Material 3 color scheme from seed color
  ColorScheme generateColorScheme({
    required Color seedColor,
    required Brightness brightness,
  }) {
    final hct = Hct.fromInt(seedColor.value);
    
    return ColorScheme(
      brightness: brightness,
      primary: _generateTonalColor(hct, _getPrimaryTone(brightness)),
      onPrimary: _generateTonalColor(hct, _getOnPrimaryTone(brightness)),
      primaryContainer: _generateTonalColor(hct, _getPrimaryContainerTone(brightness)),
      onPrimaryContainer: _generateTonalColor(hct, _getOnPrimaryContainerTone(brightness)),
      // ... implement all color roles
    );
  }
  
  /// Reverse calculate seed color from primary color
  Future<Color> calculateSeedFromPrimary(Color primaryColor) async {
    final targetHct = Hct.fromInt(primaryColor.value);
    
    // Algorithm to find seed color that generates closest primary
    double bestDistance = double.infinity;
    Hct bestSeed = targetHct;
    
    // Search through hue/chroma space
    for (double hue = 0; hue < 360; hue += 1) {
      for (double chroma = 0; chroma <= 150; chroma += 1) {
        final candidateSeed = Hct.from(hue, chroma, 50);
        final generatedPrimary = _generateTonalColor(candidateSeed, _primaryTone);
        final distance = _calculateColorDistance(primaryColor, generatedPrimary);
        
        if (distance < bestDistance) {
          bestDistance = distance;
          bestSeed = candidateSeed;
        }
      }
    }
    
    return Color(bestSeed.toInt());
  }
  
  Color _generateTonalColor(Hct baseHct, double tone) {
    return Color(Hct.from(baseHct.hue, baseHct.chroma, tone).toInt());
  }
  
  double _calculateColorDistance(Color color1, Color color2) {
    final hct1 = Hct.fromInt(color1.value);
    final hct2 = Hct.fromInt(color2.value);
    
    // LAB color space distance calculation
    return math.sqrt(
      math.pow(hct1.hue - hct2.hue, 2) +
      math.pow(hct1.chroma - hct2.chroma, 2) +
      math.pow(hct1.tone - hct2.tone, 2)
    );
  }
}
```

### Color Role Documentation System
```dart
// lib/shared/models/color_role_info.dart
@freezed
class ColorRoleInfo with _$ColorRoleInfo {
  const factory ColorRoleInfo({
    required String name,
    required String description,
    required List<String> usageExamples,
    required double minimumContrastRatio,
    required AccessibilityLevel wcagLevel,
    required List<String> pairedWith,
  }) = _ColorRoleInfo;
  
  const ColorRoleInfo._();
  
  static const Map<String, ColorRoleInfo> materialColorRoles = {
    'primary': ColorRoleInfo(
      name: 'Primary',
      description: 'High-emphasis fills, texts, and icons against surface',
      usageExamples: ['FAB', 'Primary buttons', 'Active states'],
      minimumContrastRatio: 4.5,
      wcagLevel: AccessibilityLevel.aa,
      pairedWith: ['onPrimary', 'surface'],
    ),
    // ... define all Material 3 color roles
  };
}
```

## Adaptive UI System

### Responsive Breakpoint Implementation
```dart
// lib/core/utils/responsive_utils.dart
enum ScreenSize {
  small(maxWidth: 600),
  medium(maxWidth: 840),
  large(maxWidth: double.infinity);
  
  const ScreenSize({required this.maxWidth});
  final double maxWidth;
  
  static ScreenSize fromWidth(double width) {
    if (width < small.maxWidth) return small;
    if (width < medium.maxWidth) return medium;
    return large;
  }
}

class ResponsiveConfig {
  static const double smallBreakpoint = 600;
  static const double mediumBreakpoint = 840;
  
  static NavigationType getNavigationType(double width) {
    if (width < smallBreakpoint) return NavigationType.bottomNavigation;
    if (width < mediumBreakpoint) return NavigationType.navigationRail;
    return NavigationType.navigationDrawer;
  }
}

// lib/shared/widgets/adaptive_scaffold.dart
class AdaptiveScaffold extends ConsumerWidget {
  const AdaptiveScaffold({
    super.key,
    required this.destinations,
    required this.body,
    this.selectedIndex = 0,
    this.onDestinationSelected,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final navigationType = ResponsiveConfig.getNavigationType(
          constraints.maxWidth
        );
        
        return switch (navigationType) {
          NavigationType.bottomNavigation => _buildBottomNavigation(),
          NavigationType.navigationRail => _buildNavigationRail(),
          NavigationType.navigationDrawer => _buildNavigationDrawer(),
        };
      },
    );
  }
}
```

### Navigation State Management
```dart
// lib/shared/providers/navigation_provider.dart
@riverpod
class NavigationState extends _$NavigationState {
  @override
  NavigationStateModel build() => const NavigationStateModel();
  
  void selectDestination(int index) {
    state = state.copyWith(selectedIndex: index);
  }
  
  void updateScreenSize(ScreenSize screenSize) {
    state = state.copyWith(currentScreenSize: screenSize);
  }
}

@freezed
class NavigationStateModel with _$NavigationStateModel {
  const factory NavigationStateModel({
    @Default(0) int selectedIndex,
    @Default(ScreenSize.small) ScreenSize currentScreenSize,
    @Default([]) List<NavigationDestination> destinations,
  }) = _NavigationStateModel;
}
```

## Data Models

### Settings Model with Migration
```dart
// lib/shared/models/app_settings.dart
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
  
  const AppSettings._();
  
  factory AppSettings.fromPreferences(SharedPreferences prefs) {
    final version = prefs.getInt('settings_version') ?? 1;
    
    // Handle migration if needed
    if (version < currentSchemaVersion) {
      return _migrateSettings(prefs, version);
    }
    
    return AppSettings(
      schemaVersion: version,
      themeMode: ThemeMode.values[prefs.getInt('theme_mode') ?? 0],
      showAccessibilityInfo: prefs.getBool('show_accessibility_info') ?? true,
      // ... load other settings
    );
  }
  
  Future<void> saveToPreferences(SharedPreferences prefs) async {
    await prefs.setInt('settings_version', schemaVersion);
    await prefs.setInt('theme_mode', themeMode.index);
    await prefs.setBool('show_accessibility_info', showAccessibilityInfo);
    // ... save other settings
  }
  
  static const int currentSchemaVersion = 1;
  
  static AppSettings _migrateSettings(SharedPreferences prefs, int fromVersion) {
    // Handle settings migration between versions
    switch (fromVersion) {
      case 0:
        // Migrate from version 0 to 1
        return const AppSettings(); // Use defaults
      default:
        return const AppSettings();
    }
  }
  
  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
```

### Accessibility Models
```dart
// lib/shared/models/accessibility_models.dart
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
  
  const AccessibilityIssue._();
  
  bool get isCompliant => currentLevel.index >= requiredLevel.index;
  
  factory AccessibilityIssue.fromJson(Map<String, dynamic> json) =>
      _$AccessibilityIssueFromJson(json);
}

enum AccessibilityLevel {
  fail(0, 'Fail'),
  aa(4.5, 'AA'),
  aaa(7.0, 'AAA');
  
  const AccessibilityLevel(this.minimumRatio, this.label);
  final double minimumRatio;
  final String label;
}
```

## Navigation & Routing

### Auto Route Configuration
```dart
// lib/core/routing/app_router.dart
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    // Main shell route with adaptive navigation
    AutoRoute(
      page: ShellRouteWrapper.page,
      path: '/',
      children: [
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
      ],
    ),
    
    // Modal routes
    AutoRoute(
      page: ColorPickerRoute.page,
      path: '/color-picker',
    ),
    AutoRoute(
      page: ExportRoute.page,
      path: '/export',
    ),
  ];
}

// Route pages
@RoutePage()
class ShellRouteWrapperPage extends StatelessWidget {
  const ShellRouteWrapperPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const AdaptiveScaffold(
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.palette),
          label: 'Explore',
        ),
        NavigationDestination(
          icon: Icon(Icons.accessibility),
          label: 'Accessibility',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      body: AutoRouter(),
    );
  }
}
```

## Settings & Persistence

### SharedPreferences Service
```dart
// lib/core/services/preferences_service.dart
class PreferencesService {
  static const String _settingsKey = 'app_settings';
  static const String _recentColorsKey = 'recent_colors';
  
  final SharedPreferences _prefs;
  
  PreferencesService(this._prefs);
  
  Future<AppSettings> loadSettings() async {
    final settingsJson = _prefs.getString(_settingsKey);
    if (settingsJson == null) {
      return const AppSettings();
    }
    
    try {
      final json = jsonDecode(settingsJson) as Map<String, dynamic>;
      return AppSettings.fromJson(json);
    } catch (e) {
      // Log error and return defaults
      return const AppSettings();
    }
  }
  
  Future<void> saveSettings(AppSettings settings) async {
    final json = jsonEncode(settings.toJson());
    await _prefs.setString(_settingsKey, json);
  }
  
  Future<void> saveRecentColors(List<Color> colors) async {
    final colorValues = colors.map((c) => c.value).toList();
    await _prefs.setStringList(
      _recentColorsKey,
      colorValues.map((v) => v.toString()).toList(),
    );
  }
  
  List<Color> loadRecentColors() {
    final colorStrings = _prefs.getStringList(_recentColorsKey) ?? [];
    return colorStrings
        .map((s) => Color(int.parse(s)))
        .toList();
  }
}
```

## Accessibility Implementation

### WCAG Contrast Calculations
```dart
// lib/core/services/accessibility_service.dart
class AccessibilityService {
  static double calculateContrastRatio(Color foreground, Color background) {
    final fLuminance = _calculateRelativeLuminance(foreground);
    final bLuminance = _calculateRelativeLuminance(background);
    
    final lighter = math.max(fLuminance, bLuminance);
    final darker = math.min(fLuminance, bLuminance);
    
    return (lighter + 0.05) / (darker + 0.05);
  }
  
  static double _calculateRelativeLuminance(Color color) {
    final r = _gammaCorrect(color.red / 255.0);
    final g = _gammaCorrect(color.green / 255.0);
    final b = _gammaCorrect(color.blue / 255.0);
    
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }
  
  static double _gammaCorrect(double value) {
    return value <= 0.03928
        ? value / 12.92
        : math.pow((value + 0.055) / 1.055, 2.4).toDouble();
  }
  
  static AccessibilityLevel getComplianceLevel(double contrastRatio) {
    if (contrastRatio >= 7.0) return AccessibilityLevel.aaa;
    if (contrastRatio >= 4.5) return AccessibilityLevel.aa;
    return AccessibilityLevel.fail;
  }
  
  static List<AccessibilityIssue> validateColorScheme(ColorSchemeModel scheme) {
    final issues = <AccessibilityIssue>[];
    
    // Check all color role combinations
    final colorPairs = _getColorPairsToCheck(scheme);
    
    for (final pair in colorPairs) {
      final ratio = calculateContrastRatio(pair.foreground, pair.background);
      final level = getComplianceLevel(ratio);
      
      if (level == AccessibilityLevel.fail) {
        issues.add(AccessibilityIssue(
          colorRole: pair.roleName,
          foreground: pair.foreground,
          background: pair.background,
          contrastRatio: ratio,
          currentLevel: level,
          requiredLevel: AccessibilityLevel.aa,
          suggestion: _generateSuggestion(pair),
        ));
      }
    }
    
    return issues;
  }
}
```

## Performance Specifications

### Benchmarks and Monitoring
```dart
// lib/core/services/performance_service.dart
class PerformanceService {
  static const Duration maxColorCalculationTime = Duration(milliseconds: 50);
  static const Duration maxNavigationTime = Duration(milliseconds: 200);
  
  static Future<T> measureAsyncOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = await operation();
      stopwatch.stop();
      
      _logPerformance(operationName, stopwatch.elapsed);
      return result;
    } catch (e) {
      stopwatch.stop();
      _logError(operationName, stopwatch.elapsed, e);
      rethrow;
    }
  }
  
  static void _logPerformance(String operation, Duration duration) {
    final logger = getIt<Logger>();
    
    if (duration > maxColorCalculationTime && 
        operation.contains('color')) {
      logger.w('Slow color calculation: $operation took ${duration.inMilliseconds}ms');
    } else {
      logger.d('$operation completed in ${duration.inMilliseconds}ms');
    }
  }
}
```

### Memory Management
```dart
// lib/core/utils/memory_utils.dart
class MemoryUtils {
  static const int maxRecentColors = 50;
  static const int maxCacheSize = 100;
  
  static void pruneRecentColors(List<Color> colors) {
    if (colors.length > maxRecentColors) {
      colors.removeRange(maxRecentColors, colors.length);
    }
  }
  
  static void clearCaches() {
    // Clear any in-memory caches
    ColorCalculationService.clearCache();
    AccessibilityService.clearCache();
  }
}
```

## Platform-Specific Implementations

### iOS Specific Features
```dart
// lib/core/platform/ios_specific.dart
class IOSSpecificFeatures {
  static Future<void> setupHapticFeedback() async {
    if (Platform.isIOS) {
      // Configure haptic feedback patterns
    }
  }
  
  static Future<Color?> showNativeColorPicker(Color initialColor) async {
    if (Platform.isIOS) {
      // Use platform channel for native iOS color picker
      return await _iosColorPickerChannel.invokeMethod('showColorPicker', {
        'initialColor': initialColor.value,
      });
    }
    return null;
  }
}
```

### Web Specific Features
```dart
// lib/core/platform/web_specific.dart
class WebSpecificFeatures {
  static void setupURLHandling() {
    if (kIsWeb) {
      // Handle URL-based color scheme sharing
    }
  }
  
  static Future<void> downloadColorScheme(
    ColorSchemeModel scheme,
    String format,
  ) async {
    if (kIsWeb) {
      final content = _generateExportContent(scheme, format);
      final blob = html.Blob([content]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'color_scheme.$format')
        ..click();
      
      html.Url.revokeObjectUrl(url);
    }
  }
}
```

## Testing Strategy

### Unit Test Structure
```dart
// test/core/services/color_calculation_service_test.dart
void main() {
  group('ColorCalculationService', () {
    late ColorCalculationService service;
    
    setUp(() {
      service = ColorCalculationService();
    });
    
    test('should generate valid Material 3 color scheme', () {
      // Test color scheme generation
      final scheme = service.generateColorScheme(
        seedColor: const Color(0xFF6750A4),
        brightness: Brightness.light,
      );
      
      expect(scheme.primary, isA<Color>());
      expect(scheme.brightness, Brightness.light);
      // Verify contrast ratios meet minimum requirements
    });
    
    test('should calculate seed color from primary', () async {
      // Test reverse calculation
      const primaryColor = Color(0xFF6750A4);
      final calculatedSeed = await service.calculateSeedFromPrimary(primaryColor);
      
      // Generate scheme from calculated seed
      final generatedScheme = service.generateColorScheme(
        seedColor: calculatedSeed,
        brightness: Brightness.light,
      );
      
      // Verify the generated primary is close to the target
      expect(
        _colorDistance(generatedScheme.primary, primaryColor),
        lessThan(10.0), // Acceptable color distance threshold
      );
    });
  });
}
```

### Widget Test Examples
```dart
// test/features/color_explorer/color_explorer_test.dart
void main() {
  testWidgets('ColorExplorer updates scheme when seed color changes', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: ColorExplorerPage(),
        ),
      ),
    );
    
    // Find color picker and tap it
    final colorPicker = find.byType(ColorPicker);
    expect(colorPicker, findsOneWidget);
    
    // Simulate color selection
    // Verify UI updates with new color scheme
  });
}
```

## Build & Deployment

### Build Configuration
```yaml
# Flutter build configurations
flutter:
  assets:
    - assets/images/
    - assets/fonts/
    
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
        - asset: assets/fonts/Roboto-Bold.ttf
          weight: 700

# Platform-specific configurations
flutter_native_splash:
  color: "#6750A4"
  image: assets/images/splash_icon.png
  android_12:
    color: "#6750A4"
    image: assets/images/splash_icon_android12.png

flutter_launcher_icons:
  android: true
  ios: true
  web:
    generate: true
    image_path: "assets/images/icon.png"
```

### CI/CD Pipeline Configuration
```yaml
# .github/workflows/build_and_test.yml
name: Build and Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.7.2'
      
      - name: Get dependencies
        run: flutter pub get
      
      - name: Run code generation
        run: dart run build_runner build
      
      - name: Run tests
        run: flutter test --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3

  build:
    needs: test
    strategy:
      matrix:
        platform: [android, ios, web]
    runs-on: ${{ matrix.platform == 'ios' && 'macos-latest' || 'ubuntu-latest' }}
    
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      
      - name: Build ${{ matrix.platform }}
        run: |
          flutter pub get
          dart run build_runner build
          flutter build ${{ matrix.platform }} --release
```

### Environment Configuration
```dart
// lib/core/config/environment.dart
enum Environment {
  development,
  staging,
  production,
}

class AppConfig {
  static const Environment environment = Environment.development;
  
  static const bool enableLogging = environment != Environment.production;
  static const bool enablePerformanceMonitoring = true;
  
  static const String appName = 'Material 3 Color Explorer';
  static const String version = '1.0.0';
  
  static const Duration colorCalculationTimeout = Duration(seconds: 5);
  static const int maxRecentColors = 50;
}
```
