# Eisenhower Matrix - Flutter Todo App

A modern, professional Flutter application implementing the Eisenhower Matrix (Urgent-Important Matrix) for task prioritization. Perfect for busy professionals who need to organize their tasks effectively.

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)
![License](https://img.shields.io/badge/license-MIT-green)

## 📱 About

This app helps users prioritize tasks using the Eisenhower Matrix methodology, dividing tasks into four quadrants:

- **Q1: Urgent & Important** - Do First
- **Q2: Not Urgent & Important** - Schedule
- **Q3: Urgent & Not Important** - Delegate
- **Q4: Not Urgent & Not Important** - Eliminate

## ✨ Features

- ✅ Clean, modern UI with professional UX design
- ✅ Four-quadrant Eisenhower Matrix layout
- ✅ Add, edit, and delete tasks with swipe gestures
- ✅ Persistent local storage using Hive
- ✅ BLoC pattern for state management
- ✅ Responsive design for different screen sizes
- ✅ Custom typography using Google Fonts
- ✅ Smooth animations and transitions

## 🎥 Origin Story

This project was created for an Instagram video demonstration. The original prompt used to generate this project was:

> *"I want to create an application that does Eisenhower Matrix todo list, suitable for people who are very busy. make the UI modern and UX very professional. give me also step by step guide to generate the project. use bloc for state management, and other common best practice packages when (and if) needed."*

## 🏗️ Architecture

The project follows Flutter best practices and clean architecture principles:

```
lib/
├── core/
│   ├── di/              # Dependency injection setup
│   └── theme/           # App theme configuration
├── data/
│   ├── models/          # Data models (Hive)
│   ├── repositories/    # Data repositories
│   └── presentation/    # UI layer
│       ├── bloc/        # BLoC state management
│       ├── screens/     # App screens
│       └── widgets/     # Reusable widgets
└── main.dart            # App entry point
```

## 📦 Tech Stack

### Core
- **Flutter SDK**: ^3.9.2
- **Dart**: ^3.9.2

### State Management
- **flutter_bloc**: ^8.1.3 - BLoC pattern implementation
- **equatable**: ^2.0.5 - Value equality for Dart classes

### Local Storage
- **hive**: ^2.2.3 - Fast, lightweight NoSQL database
- **hive_flutter**: ^1.1.0 - Hive integration for Flutter

### Dependency Injection
- **get_it**: ^7.6.4 - Service locator for dependency injection

### UI/UX
- **google_fonts**: ^6.1.0 - Custom typography
- **flutter_slidable**: ^3.0.1 - Swipe actions for tasks
- **intl**: ^0.18.1 - Internationalization and date formatting

### Development
- **hive_generator**: ^2.0.1 - Code generation for Hive
- **build_runner**: ^2.4.6 - Build system
- **flutter_lints**: ^3.0.0 - Linting rules

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK (3.9.2 or higher)
- IDE (VS Code, Android Studio, or IntelliJ)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd todo-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive type adapters**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### iOS
```bash
cd ios
pod install
cd ..
flutter run
```

#### Android
```bash
flutter run
```

#### Web
```bash
flutter run -d chrome
```

## 🎯 Usage

1. **Add a Task**: Tap the floating action button (+) to create a new task
2. **Set Priority**: Choose the quadrant based on urgency and importance
3. **Manage Tasks**:
   - Swipe left on a task to delete
   - Tap on a task to view details or edit
4. **Track Progress**: Tasks are automatically saved and persist between sessions

## 🛠️ Development

### Run tests
```bash
flutter test
```

### Build for production
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

### Code generation (after model changes)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🎨 Customization

### Theme
Modify colors and styles in `lib/core/theme/app_theme.dart`

### Fonts
Change font families in the same theme file (currently using Google Fonts)

### Storage
Task data is stored locally using Hive. The database is initialized in `main.dart`

## 📝 Project Structure Details

- **Models**: Task model with Hive type adapter for local storage
- **Repository**: Abstraction layer for data operations
- **BLoC**: Events, states, and business logic for task management
- **Widgets**: Reusable components (TaskCard, QuadrantSection, AddTaskDialog)
- **Screens**: Main home screen with matrix layout
- **DI**: GetIt service locator setup

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 📧 Contact

For questions or feedback, please open an issue on GitHub.

---

**Made with ❤️ using Flutter and BLoC**
