# Material Palette

**A comprehensive Flutter application for exploring and applying Material Design 3 colors.**

This project provides an intuitive and visually engaging experience for developers, designers, and anyone interested in color theory. Select a seed color, and the app dynamically generates a cohesive color scheme that aligns with Material Design principles.

---

## 🚀 Getting Started

This section provides a quick overview for developers to get the project running.

### Prerequisites
- Flutter SDK 3.7.2 or higher
- Dart SDK compatible with Flutter version

### Setup
1.  **Clone the repository**:
    ```bash
    git clone git@github.com:dongguowu/material_palette.git
    cd material_palette
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Generate code**:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
4.  **Run the app**:
    ```bash
    flutter run
    ```
---

## 📚 Project Documentation Hub

This project uses a multi-file documentation structure to keep information organized and easy to find. Use this hub to navigate to the document you need based on your role or task.

### I am a...

<details>
<summary>👨‍💻 <strong>Developer</strong></summary>

| Document | What you'll find |
| :--- | :--- |
| **[CLAUDE.md](CLAUDE.md)** | **Start here.** Your primary guide for development setup, commands, and project-specific conventions. |
| **[docs/TECHNICAL_SPECS.md](docs/TECHNICAL_SPECS.md)** | Deep dive into the code. Detailed implementation patterns, code examples, and API usage. |
| **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)** | Understand the big picture. System design, component relationships, and data flow diagrams. |
| **[docs/API.md](docs/API.md)** | Public interfaces, service contracts, and data models. |
| **[docs/DEPLOYMENT.md](docs/DEPLOYMENT.md)** | How to build and release the app. CI/CD pipelines and platform-specific deployment. |
| **[docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** | Solutions for common build, runtime, and performance issues. |

</details>

<details>
<summary>🎨 <strong>Designer or Product Manager</strong></summary>

| Document | What you'll find |
| :--- | :--- |
| **[docs/PRD.md](docs/PRD.md)** | **Start here.** The "what" and "why" of the project. Product vision, feature requirements, and success metrics. |
| **[docs/USER_STORIES.md](docs/USER_STORIES.md)** | Understand our users. Personas, user journeys, and acceptance criteria for features. |
| **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)** | High-level overview of the system's structure and technical capabilities. |

</details>

<details>
<summary>🤝 <strong>New Contributor</strong></summary>

| Document | What you'll find |
| :--- | :--- |
| **[README.md](README.md)** | **You are here.** Get a project overview and learn how to navigate the docs. |
| **[CLAUDE.md](CLAUDE.md)** | Your guide to getting started with development and understanding our workflow. |
| **[docs/PRD.md](docs/PRD.md)** | Understand the project's goals and features before you start coding. |

</details>

### I want to know about...

- **Project Goals & Features**: See the **[Product Requirements Document (PRD)](docs/PRD.md)**.
- **User Personas & Scenarios**: See the **[User Stories](docs/USER_STORIES.md)**.
- **System Design & Data Flow**: See the **[Architecture Document](docs/ARCHITECTURE.md)**.
- **Code Examples & Implementation Details**: See the **[Technical Specs](docs/TECHNICAL_SPECS.md)**.
- **How to Deploy the App**: See the **[Deployment Guide](docs/DEPLOYMENT.md)**.
- **How to Fix Common Problems**: See the **[Troubleshooting Guide](docs/TROUBLESHOOTING.md)**.

---

## ✨ Core Features

- **Dynamic Color Generation**: Create full Material 3 palettes from a single seed color.
- **Advanced Color Picker**: Fine-tune your selection with a custom color wheel and hex input.
- **Accessibility Compliance**: Real-time WCAG contrast ratio validation.
- **Adaptive UI**: Responsive design that looks great on mobile, tablet, and desktop.
- **Export Options**: Get your color schemes in multiple formats (Flutter, CSS, JSON).

## 🛠️ Technology Stack

- **Framework**: Flutter
- **Architecture**: Clean Architecture, Feature-based
- **State Management**: Riverpod
- **Navigation**: Auto Route
- **Persistence**: SharedPreferences
- **For a detailed breakdown, see**: **[Technical Specs](docs/TECHNICAL_SPECS.md#technology-stack--dependencies)**.

---

## ⚖️ License

This project is licensed under the [MIT License](LICENSE).
