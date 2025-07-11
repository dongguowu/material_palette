# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter Material Design 3 color palette application. The app helps users explore and apply Material Design 3 colors by generating cohesive color schemes from seed colors.

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
flutter test                       # Run all tests
flutter test test/specific_test.dart  # Run specific test
```

## Architecture

### Feature-Based Structure
The app follows a feature-based architecture pattern with each feature organized into layers:

```
lib/features/
├── app/                          # Application-level features
│   ├── app_color/               # Global color seed management
│   ├── app_layout/              # Adaptive layout and navigation
│   ├── app_router/              # Auto Route navigation setup
│   ├── app_settings/            # Settings persistence with SharedPreferences
│   ├── app_themes/              # Dark/light mode theming
│   └── app_logger/              # Logging infrastructure
└── palette/                     # Color palette features
    └── ui/                      # Palette pages and widgets
```

### Layer Organization
Each feature follows Clean Architecture principles:
- **UI Layer**: Pages, widgets, and Riverpod providers
- **Domain Layer**: Models, repositories (abstract)
- **Data Layer**: Repository implementations, data sources

### Key Technology Stack
- **State Management**: Riverpod with code generation (`riverpod_generator`)
- **Navigation**: Auto Route with type-safe routing
- **Data Persistence**: SharedPreferences for settings
- **Dependency Injection**: GetIt service locator
- **Code Generation**: Freezed for immutable models, JSON serialization
- **Responsive UI**: `flutter_adaptive_scaffold` for different screen sizes

### Code Generation Dependencies
The project heavily uses code generation. Key files that trigger generation:
- Files with `@riverpod` annotations
- Files with `@freezed` annotations  
- Files with `@JsonSerializable` annotations
- AutoRoute configuration files

### Important Patterns
- **Riverpod Providers**: Use `riverpod_annotation` for generated providers
- **Immutable Models**: Use Freezed for data classes with `@freezed`
- **Navigation**: Auto Route handles type-safe routing with guards
- **Dependency Setup**: `setup_dependencies.dart` configures GetIt registrations
- **Adaptive Layout**: Navigation switches between bottom bar and rail based on screen size

### Main Entry Points
- `lib/main.dart`: App initialization and provider setup
- `lib/setup_dependencies.dart`: Dependency injection configuration
- `lib/features/app/app_router/app_router.dart`: Navigation configuration

## Key Dependencies to Note

When adding new features, be aware of these patterns:
- Riverpod providers should use `@riverpod` annotation for generation
- New routes must be added to the AutoRoute configuration
- Models should use Freezed for immutability and JSON serialization
- Settings should go through the `AppSettingsRepository` for persistence
