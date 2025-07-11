# Material Palette

**Material Palette** is a comprehensive Flutter application designed to help users explore and apply **Material Design 3 colors** effortlessly. Users select a seed color, and the app dynamically generates a **cohesive color scheme** that aligns with Material Design principles. Whether building user interfaces, designing presentations, or simply experimenting with color theory, Material Palette provides an intuitive and **visually engaging** experience.

## Project Overview

Material Palette is a fully-implemented Flutter application for exploring and applying Material Design 3 colors. The project has evolved from an empty repository to a comprehensive color palette tool with sophisticated features and responsive design.

## Architecture & Technology Stack

- **Framework**: Flutter 3.7.2+ with Material 3 support
- **State Management**: Riverpod with code generation
- **Navigation**: Auto Route for type-safe routing
- **Persistence**: SharedPreferences for settings
- **Dependency Injection**: GetIt service locator
- **Code Generation**: Freezed for immutable models

### Key Dependencies

**Core Flutter:**
- `flutter_riverpod` - State management
- `auto_route` - Type-safe navigation
- `shared_preferences` - Data persistence
- `flutter_adaptive_scaffold` - Responsive UI

**Code Generation:**
- `build_runner`, `freezed`, `json_serializable`
- `riverpod_generator`, `auto_route_generator`

**UI Components:**
- `flutter_colorpicker` - Color selection
- `logger` & `flutter_logs` - Logging

## Core Features

### 1. **Color Seed Management**
- Dynamic color scheme generation from seed colors
- Hex color string parsing with validation
- Default color management and persistence

### 2. **Advanced Color Picker**
- Custom color wheel implementation with HSV support
- Material color palette grid (18 predefined colors)
- Hex input field with real-time validation
- Random color generation from Material palette

### 3. **Material 3 Design Helper**
- Comprehensive color role documentation
- Accessibility contrast ratio calculations (WCAG compliance)
- Usage examples and best practices
- Color scheme generation utilities

### 4. **Adaptive Layout System**
- Responsive navigation (bottom bar → navigation rail)
- Breakpoint-based layout adaptation
- Tab-based navigation with state management
- Multi-screen support (small, medium, large)

### 5. **Settings Management**
- Versioned settings schema with automatic migration
- Dark mode toggle capability
- Compile-time validation with runtime fallbacks
- Persistent user preferences

## Technical Highlights

- **Clean Architecture**: Feature-based modular structure
- **Type Safety**: Extensive use of code generation
- **Responsive Design**: Adaptive UI for different screen sizes
- **Accessibility**: WCAG contrast ratio checking
- **Error Handling**: Comprehensive logging and validation
- **Performance**: Efficient state management with Riverpod

## Installation

### Prerequisites
- Flutter SDK 3.7.2 or higher
- Dart SDK compatible with Flutter version

### Setup
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Generate code:
   ```bash
   flutter packages pub run build_runner build
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Usage

1. **Select a seed color** from the predefined Material palette or use the custom color picker
2. **View the dynamically generated Material Design color palette** with all color roles
3. **Explore color relationships** and accessibility information
4. **Apply colors** to your projects using the comprehensive color documentation
5. **Toggle between light and dark themes** to see how colors adapt

## Project Status

The `1-core-functionality-implementation` branch contains a **production-ready** Material Palette application with sophisticated color management, responsive design, and comprehensive Material 3 integration.

## License

[MIT License](LICENSE)

---

Feel free to tweak this README to add installation instructions, screenshots, or more details! Let me know if you'd like refinements. 🚀
