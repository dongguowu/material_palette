# Material Palette

**Material Palette** is a comprehensive Flutter application designed to help users explore and apply **Material Design 3 colors** effortlessly. Users select a seed color, and the app dynamically generates a **cohesive color scheme** that aligns with Material Design principles. Whether building user interfaces, designing presentations, or simply experimenting with color theory, Material Palette provides an intuitive and **visually engaging** experience.

## 📚 Documentation Navigation

> **📚 Document Purpose**: This README provides a comprehensive project overview. For detailed documentation, please use the navigation guide below to find information across all project documents.

### Core Documentation
| Document | Purpose | Key Sections |
|----------|---------|-------------|
| **[docs/PRD.md](docs/PRD.md)** | Product Requirements | Features, Tech Stack, Success Metrics |
| **[docs/TECHNICAL_SPECS.md](docs/TECHNICAL_SPECS.md)** | Implementation Details | Code Examples, Architecture, Testing |
| **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)** | System Design | Diagrams, Patterns, Performance |
| **[docs/USER_STORIES.md](docs/USER_STORIES.md)** | User Requirements | Personas, Acceptance Criteria, Scenarios |
| **[docs/API.md](docs/API.md)** | Public Interfaces | Service APIs, Data Models, Usage Examples |
| **[docs/DEPLOYMENT.md](docs/DEPLOYMENT.md)** | Release Procedures | CI/CD, Build Config, Release Management |
| **[docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** | Problem Solving | Common Issues, Diagnostics, Solutions |

### Development Reference  
| Document | Purpose | Key Content |
|----------|---------|-------------|
| **[CLAUDE.md](CLAUDE.md)** | Development Guide | Quick Start, Patterns, CLI Usage |
| **[docs/ENGLISH_CORRECTIONS.md](docs/ENGLISH_CORRECTIONS.md)** | Language Assistance | Grammar Correction Instructions |

---

## Project Overview

Material Palette is a fully-implemented Flutter application for exploring and applying Material Design 3 colors. The project has evolved from an empty repository to a comprehensive color palette tool with sophisticated features and responsive design.

## Architecture & Technology Stack

- **Framework**: Flutter 3.7.2+ with Material 3 support
- **State Management**: Riverpod with code generation
- **Navigation**: Auto Route for type-safe routing
- **Persistence**: SharedPreferences for settings
- **Dependency Injection**: GetIt service locator
- **Code Generation**: Freezed for immutable models
- **For more details, see**: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) and [docs/TECHNICAL_SPECS.md](docs/TECHNICAL_SPECS.md)

## Core Features

- **Color Seed Management**: Dynamic color scheme generation.
- **Advanced Color Picker**: Custom color wheel, Material palette grid, and hex input.
- **Material 3 Design Helper**: Color role documentation and accessibility validation.
- **Adaptive Layout System**: Responsive navigation for all screen sizes.
- **Settings Management**: Versioned settings with dark mode support.

## Installation

### Prerequisites
- Flutter SDK 3.7.2 or higher
- Dart SDK compatible with Flutter version

### Setup
1.  Clone the repository
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Generate code:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
4.  Run the app:
    ```bash
    flutter run
    ```

## Usage

1.  **Select a seed color** from the predefined Material palette or use the custom color picker.
2.  **View the dynamically generated Material Design color palette**.
3.  **Explore color relationships** and accessibility information.
4.  **Toggle between light and dark themes** to see how colors adapt.

## Project Status

The `1-core-functionality-implementation` branch contains a **production-ready** Material Palette application with sophisticated color management, responsive design, and comprehensive Material 3 integration.

## License

[MIT License](LICENSE)
