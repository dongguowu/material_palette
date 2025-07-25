# CLAUDE.md

> **⚡ Document Purpose**: Provides immediate development guidance and project context. Contains quick-start commands, current implementation status, and Claude CLI usage patterns for developers working on the project.

## Help user improve their English
Please read docs/ENGLISH_CORRECTIONS.md first.


This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Claude CLI Settings
```yaml
includeCoAuthoredBy: false
```

## Security Checks
- **.gitignore**: Before committing, always check `.gitignore` to confirm that `.env` files (including security keys) and `docs/ENGLISH_CORRECTIONS.md` have been ignored.

## Quick File Reference
docs/
├── [PRD.md](docs/PRD.md)                           # Product requirements and specifications
├── [TECHNICAL_SPECS.md](docs/TECHNICAL_SPECS.md)   # How to build it (implementation details)  
├── [ARCHITECTURE.md](docs/ARCHITECTURE.md)         # High-level system design and diagrams
├── [USER_STORIES.md](docs/USER_STORIES.md)         # User personas and acceptance criteria
└── [ENGLISH_CORRECTIONS.md](docs/ENGLISH_CORRECTIONS.md) # Language improvement instructions

📁 **Main Code**: [`lib/`](lib/) - All Flutter implementation
⚙️ **Config**: [`pubspec.yaml`](pubspec.yaml) - Dependencies and project config  
🧪 **Tests**: [`test/`](test/) - Unit and widget tests

### Key Implementation Files
- [`lib/main.dart`](lib/main.dart) - Application entry point
- [`lib/setup_dependencies.dart`](lib/setup_dependencies.dart) - Dependency injection setup
- [`lib/features/app_router/app_router.dart`](lib/features/app_router/app_router.dart) - Navigation configuration
- [`lib/core/theme/`](lib/core/theme/) - Material 3 theme implementation
- [`lib/features/color_explorer/`](lib/features/color_explorer/) - Main color exploration feature

## Project Overview

A comprehensive Flutter application for exploring and applying Material Design 3 colors with cross-platform support (iOS, Android, Web).

## Common Development Commands

### Basic Flutter Commands
```bash
flutter pub get                    # Install dependencies
flutter run                       # Run the app
flutter test                      # Run tests
flutter analyze                   # Static analysis
flutter doctor                    # Check Flutter installation
```

### Code Generation
```bash
flutter packages pub run build_runner build              # Generate code once
flutter packages pub run build_runner build --delete-conflicting-outputs  # Clean build
flutter packages pub run build_runner watch             # Watch for changes
```

### Build Commands
```bash
flutter build apk                  # Build Android APK
flutter build ios                  # Build iOS app
flutter build web                  # Build web app
flutter build windows             # Build Windows app
flutter build macos               # Build macOS app
flutter build linux               # Build Linux app
```

### Testing
```bash
# Run all tests
flutter test

# Run all tests with coverage
flutter test --coverage

# Run a specific test file
flutter test test/features/palette/ui/seed_color_generator_test.dart

# Run tests in a specific group by name
flutter test --plain-name "Mode Toggle"
```

#### Test Troubleshooting
If tests fail, follow these steps:
1.  **Check Flutter version**: Ensure you are on Flutter 3.30.0+
2.  **Update dependencies**: Run `flutter pub get`
3.  **Check imports**: Verify all required packages are available
4.  **Review error messages**: Look for specific assertion failures
5.  **Isolate the test**: Run the failing test file or group individually to debug

### Diagnostics
```bash
# Run the diagnostic script to check the test environment
bash diagnostic.sh
```
**Note**: The diagnostic script may report analysis issues. It is recommended to fix these to ensure code quality, but they may not prevent the tests from passing.

### Git & SSH
```bash
# Test SSH connection to GitHub
ssh -T git@github.com

# Set remote URL to use SSH
git remote set-url origin git@github.com:dongguowu/material_palette.git
```


## Architecture

### Feature-Based Structure
The app follows a feature-based architecture pattern with each feature organized into layers:

```
lib/
├── core/                         # Core utilities and services
│   ├── theme/                   # Material 3 theme implementation
│   ├── services/                # Dependency injection setup  
│   └── utils/                   # Helper functions
├── features/                    # Feature-based modules
│   ├── app_color/               # Global color seed management
│   ├── app_layout/              # Adaptive layout and navigation
│   ├── app_router/              # Auto Route navigation setup
│   ├── app_settings/            # Settings persistence with SharedPreferences
│   ├── app_themes/              # Dark/light mode theming
│   ├── app_logger/              # Logging infrastructure
│   ├── color_explorer/          # Main color exploration feature
│   └── app_accessibility/       # WCAG compliance tools
├── shared/                      # Shared widgets and models
│   ├── widgets/                 # Reusable UI components
│   └── models/                  # Data models with Freezed
└── main.dart                    # App entry point
```

**📖 For detailed architecture diagrams and patterns**: See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md)
**📋 For user requirements and acceptance criteria**: See [`docs/USER_STORIES.md`](docs/USER_STORIES.md)

### Layer Organization
Each feature follows Clean Architecture principles:
- **UI Layer**: Pages, widgets, and Riverpod providers
- **Domain Layer**: Models, repositories (abstract)
- **Data Layer**: Repository implementations, data sources

### Key Technology Stack
- **Complete technical specifications**: See [`docs/TECHNICAL_SPECS.md#technology-stack--dependencies`](docs/TECHNICAL_SPECS.md#technology-stack--dependencies)
- **Architecture**: Clean Architecture with feature-based modules ([`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md))
- **State Management**: Riverpod with code generation ([`lib/features/`](lib/features/))
- **Navigation**: Auto Route with type-safe routing ([`lib/features/app_router/`](lib/features/app_router/))
- **Data Persistence**: SharedPreferences for settings ([`lib/features/app_settings/`](lib/features/app_settings/))
- **Dependency Injection**: GetIt service locator ([`lib/setup_dependencies.dart`](lib/setup_dependencies.dart))

**🔧 For complete technical specifications**: See [`docs/TECHNICAL_SPECS.md`](docs/TECHNICAL_SPECS.md)

### Code Generation Dependencies
The project heavily uses code generation. Key files that trigger generation:
- Files with `@riverpod` annotations
- Files with `@freezed` annotations  
- Files with `@JsonSerializable` annotations
- AutoRoute configuration files

### Important Patterns
- **Riverpod Providers**: Use `riverpod_annotation` for generated providers ([examples in `docs/TECHNICAL_SPECS.md`](docs/TECHNICAL_SPECS.md#state-management))
- **Immutable Models**: Use Freezed for data classes with `@freezed` ([model examples](docs/TECHNICAL_SPECS.md#data-models))
- **Navigation**: Auto Route handles type-safe routing with guards ([routing config](lib/features/app_router/))
- **Dependency Setup**: [`setup_dependencies.dart`](lib/setup_dependencies.dart) configures GetIt registrations
- **Adaptive Layout**: Navigation switches between bottom bar and rail based on screen size ([layout examples](docs/TECHNICAL_SPECS.md#adaptive-ui-system))

### Main Entry Points
- [`lib/main.dart`](lib/main.dart): App initialization and provider setup
- [`lib/setup_dependencies.dart`](lib/setup_dependencies.dart): Dependency injection configuration  
- [`lib/features/app_router/app_router.dart`](lib/features/app_router/app_router.dart): Navigation configuration

## Key Dependencies to Note

When adding new features, be aware of these patterns:
- Riverpod providers should use `@riverpod` annotation for generation
- New routes must be added to the AutoRoute configuration
- Models should use Freezed for immutability and JSON serialization
- Settings should go through the `AppSettingsRepository` for persistence

## Current Implementation Status
✅ **Completed Features** ([full details in `docs/PRD.md`](docs/PRD.md))

🚧 **In Progress** ([see user stories in `docs/USER_STORIES.md`](docs/USER_STORIES.md))
- Material 3 color system implementation with HCT color space
- Adaptive layout system (bottom nav → navigation rail → drawer)
- Comprehensive settings management with versioned schema
- WCAG contrast ratio calculations
- Real-time color palette generation
- Cross-platform responsive design
- Export functionality for different formats
- Advanced color picker enhancements
- Documentation and help system

📋 **Planned Features** ([roadmap in `docs/PRD.md#future-roadmap`](docs/PRD.md#future-roadmap))
- Color scheme sharing capabilities
- Custom color harmony algorithms
- Design system integration tools
- Color palette export functionality
- Material 3 theme builder
- Color accessibility checker

## Development Guidelines

**📚 For complete development patterns**: See [`docs/TECHNICAL_SPECS.md`](docs/TECHNICAL_SPECS.md)
**🏗️ For architecture principles**: See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md)

## Code Style

- Use Riverpod providers for state management ([examples](docs/TECHNICAL_SPECS.md#riverpod-provider-architecture))
- Implement clean architecture patterns ([structure](docs/ARCHITECTURE.md#feature-based-module-structure))  
- Utilize code generation (Freezed, auto_route) ([patterns](docs/TECHNICAL_SPECS.md#code-generation-dependencies))
- Follow Material 3 design principles ([implementation](docs/TECHNICAL_SPECS.md#material-3-color-implementation))
- Maintain accessibility compliance (WCAG 2.1 AA) ([validation](docs/TECHNICAL_SPECS.md#accessibility-implementation))

## Key Implementation Details

**📋 For complete implementation specifications**: See [`docs/TECHNICAL_SPECS.md`](docs/TECHNICAL_SPECS.md)

### Material 3 Color Algorithm
- Uses HCT (Hue, Chroma, Tone) color space for accurate color generation ([implementation details](docs/TECHNICAL_SPECS.md#material-3-color-implementation))
- Implements both seed → palette and primary → seed calculations
- Maintains compliance with Material 3 specifications

#### Color Calculation Snippets
```dart
// HSV-based seed calculation from primary color
Color _calculateSeedFromPrimary(Color primaryColor) {
  final hsv = HSVColor.fromColor(primaryColor);
  return hsv.withSaturation((hsv.saturation * 0.9).clamp(0.3, 1.0))
           .withValue((hsv.value * 0.95).clamp(0.4, 1.0))
           .toColor();
}

// Smart contrast color for text readability
Color _getContrastColor(Color backgroundColor) {
  final luminance = (0.299 * backgroundColor.red + 
                   0.587 * backgroundColor.green + 
                   0.114 * backgroundColor.blue) / 255;
  return luminance > 0.5 ? Colors.black : Colors.white;
}
```

### Responsive Design Breakpoints ([layout system](docs/TECHNICAL_SPECS.md#adaptive-ui-system))
- Small: <600dp (bottom navigation)
- Medium: 600-840dp (navigation rail)  
- Large: >840dp (navigation drawer)

### Accessibility Features ([WCAG implementation](docs/TECHNICAL_SPECS.md#accessibility-implementation))
- Real-time WCAG contrast ratio validation
- Color role documentation and usage guidelines
- Screen reader compatibility
- High contrast mode support

## Common Development Tasks

**📚 For detailed development workflows**: See [`docs/TECHNICAL_SPECS.md#testing-strategy`](docs/TECHNICAL_SPECS.md#testing-strategy)

### Adding New Features ([architecture guide](docs/ARCHITECTURE.md#feature-based-module-structure))
1. Create feature module in [`lib/features/`](lib/features/)
2. Define models with Freezed ([examples](docs/TECHNICAL_SPECS.md#data-models))
3. Implement Riverpod providers ([patterns](docs/TECHNICAL_SPECS.md#state-management))
4. Create responsive UI components ([adaptive patterns](docs/TECHNICAL_SPECS.md#adaptive-ui-system))
5. Add route to AutoRoute configuration ([routing setup](lib/features/app_router/))
6. Write unit tests ([testing examples](docs/TECHNICAL_SPECS.md#testing-strategy))

### Color System Extensions ([implementation guide](docs/TECHNICAL_SPECS.md#material-3-color-implementation))
- All color calculations should use the established HCT utilities
- New color schemes must include accessibility validation  
- Export functionality should support multiple formats

### Testing Strategy ([complete strategy](docs/TECHNICAL_SPECS.md#testing-strategy))
- Unit tests for color calculations and business logic
- Widget tests for UI components
- Integration tests for user flows
- Accessibility testing for WCAG compliance

## Key Learnings & Important Notes
- **Default selectedPageIndex must be 0** (not -1) for AutoRoute to avoid assertion errors.
- **Use `withValues()` instead of the deprecated `withOpacity()`** for future compatibility.
- **`ValueKey` is essential for proper widget rebuilds** in lists when the underlying data changes.
- **Test expectations must match UI changes precisely** (e.g., `Icons.check` vs. `Icons.check_circle`).
- **HSV color space adjustments** are highly effective for algorithmic color manipulations in Material 3.
- **Luminance-based contrast calculations** (W3C formula) are crucial for ensuring text readability and accessibility.

## Key Implementation Files



## Claude CLI Usage Notes
When working with this project:

Reference this file for project context
Check docs/PRD.md for detailed requirements
Use existing patterns for state management and UI components
Maintain accessibility and responsive design standards
Follow established code generation patterns

Quick Commands
bash# Code generation
dart run build_runner build

# Running on different platforms
flutter run -d chrome          # Web
flutter run -d ios             # iOS Simulator
flutter run -d android         # Android Emulator

# Testing
flutter test                   # Unit tests
flutter test integration_test/ # Integration tests



### State Management Patterns
```dart
// Provider example
@riverpod
class ColorSchemeNotifier extends _$ColorSchemeNotifier {
  @override
  ColorScheme build() => ColorScheme.fromSeed(seedColor: Colors.blue);
  
  void updateSeedColor(Color color) {
    state = ColorScheme.fromSeed(seedColor: color);
  }
}
```

### Model Definition Pattern
```dart
// Freezed model example
@freezed
class ColorPalette with _$ColorPalette {
  const factory ColorPalette({
    required Color seedColor,
    required ColorScheme lightScheme,
    required ColorScheme darkScheme,
    @Default([]) List<AccessibilityIssue> accessibilityIssues,
  }) = _ColorPalette;
  
  factory ColorPalette.fromJson(Map<String, dynamic> json) =>
      _$ColorPaletteFromJson(json);
}
```

## Key Implementation Details

### Material 3 Color Algorithm
- Uses HCT (Hue, Chroma, Tone) color space for accurate color generation
- Implements both seed → palette and primary → seed calculations
- Maintains compliance with Material 3 specifications

### Responsive Design Breakpoints
- Small: <600dp (bottom navigation)
- Medium: 600-840dp (navigation rail)
- Large: >840dp (navigation drawer)

### Accessibility Features
- Real-time WCAG contrast ratio validation
- Color role documentation and usage guidelines
- Screen reader compatibility
- High contrast mode support

## Common Development Tasks

### Adding New Features
1. Create feature module in `lib/features/`
2. Define models with Freezed
3. Implement Riverpod providers
4. Create responsive UI components
5. Add route to AutoRoute configuration
6. Write unit tests

### Color System Extensions
- All color calculations should use the established HCT utilities
- New color schemes must include accessibility validation
- Export functionality should support multiple formats

### Testing Strategy
- Unit tests for color calculations and business logic
- Widget tests for UI components
- Integration tests for user flows
- Accessibility testing for WCAG compliance


## Instructions for Claude CLI

**📖 Documentation Reference Guide:**
- **Project Requirements**: Use [`docs/PRD.md`](docs/PRD.md) for product specifications and feature details
- **Technical Implementation**: Use [`docs/TECHNICAL_SPECS.md`](docs/TECHNICAL_SPECS.md) for code patterns and architecture  
- **System Design**: Use [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for high-level architecture and diagrams
- **User Requirements**: Use [`docs/USER_STORIES.md`](docs/USER_STORIES.md) for user personas and acceptance criteria
- **Development Context**: Use this file ([`CLAUDE.md`](CLAUDE.md)) for development patterns and current status

When helping with this project:

1. **Always reference the PRD first**: Use [`docs/PRD.md`](docs/PRD.md) for product requirements and feature specifications
2. **Use this context file**: Include this file for development patterns and current status  
3. **Include relevant source files**: Add specific files from [`lib/`](lib/) when discussing implementation

### Example Usage Patterns
```bash
# For new feature development
claude --file CLAUDE.md --file docs/PRD.md "Help me implement the export feature from section 4.4 of the PRD"

# For architecture questions  
claude --file CLAUDE.md --file docs/PRD.md --file lib/core/ "Review my architecture against the PRD requirements"

# For specific implementations
claude --file CLAUDE.md --file lib/features/color_explorer/ "Optimize this color calculation code"
```

## Claude CLI Usage Notes
When working with this project:
- Reference this file for project context
- Check `docs/PRD.md` for detailed requirements
- Use existing patterns for state management and UI components
- Maintain accessibility and responsive design standards
- Follow established code generation patterns

## Quick Commands
```bash
# Code generation
dart run build_runner build

# Running on different platforms
flutter run -d chrome          # Web
flutter run -d ios             # iOS Simulator
flutter run -d android         # Android Emulator

# Testing
flutter test                   # Unit tests
flutter test integration_test/ # Integration tests
```

## Application Improvement Plan

This plan outlines the steps to address the findings from the code quality analysis.

### Phase 1: Foundational Fixes

1.  **✅ Fix `flutter analyze` command**
    -   **Priority**: Critical
    -   **Problem**: The command crashes due to a `FileSystemException`, preventing automated static analysis.
    -   **Task**: Resolve the symlink issue in the development environment (likely related to WSL). This is essential for maintaining code quality.

2.  **✅ Fix Dependency Injection**
    -   **Priority**: High
    -   **Problem**: `AppSettingsRepository` is not registered in `setup_dependencies.dart`.
    -   **Task**: Add `getIt.registerLazySingleton<AppSettingsRepository>(() => AppSettingsRepositoryImpl(getIt()));` to `setupAppSettingDependencies`.

3.  **✅ Refactor `main.dart`**
    -   **Priority**: High
    -   **Problem**: Contains commented-out code and direct `getIt` registrations.
    -   **Tasks**:
        -   Move `AuthService` and `AppRouter` registrations to `setup_dependencies.dart`.
        -   Remove all commented-out code blocks.

### Phase 2: Logic and Consistency

4.  **✅ Complete Settings Migration**
    -   **Priority**: Medium
    -   **Problem**: The `migrate()` method in `app_settings_model.dart` is incomplete.
    -   **Task**: Implement the full migration logic to handle transitions between all schema versions.

5.  **✅ Unify Theme Generation**
    -   **Priority**: Medium
    -   **Problem**: The dark theme is hardcoded, unlike the light theme.
    -   **Task**: In `main.dart`, generate the `darkTheme` using `ColorScheme.fromSeed` with `brightness: Brightness.dark` for consistency.

6.  **✅ Refine Routing Configuration**
    -   **Priority**: Low
    -   **Problem**: Redundant `initial: true` flags in `app_router.dart`.
    -   **Task**: Remove the `initial: true` from the child `HomeRoute` and the explicit `initial: false` from other routes.

### Phase 3: State Management and Refinements

7.  **✅ Improve Notifier State Handling**
    -   **Priority**: Low
    -   **Problem**: The `AppSettingsNotifier` reverts to default settings on update failure.
    -   **Task**: Modify the `updateSettings` method to preserve the old state in case of an update error, providing a better user experience.

8.  **✅ Rename `updatepartial` method**
    -   **Priority**: Low
    -   **Problem**: The method name is unconventional.
    -   **Task**: Rename `updatepartial` in `app_settings_model.dart` to a more standard name like `merge`.
