# ChefSync - Premium Recipe & Cooking Assistant (Flutter)

A high-end, production-grade Flutter application designed for precision cooking with glassmorphic visuals, 60fps micro-animations, interactive 3D progress tracking, and full state management.

---

## 🏛️ Academic Architecture Overview

This project was built to satisfy academic requirements for mobile software engineering, UI/UX interaction design, and cloud backend integration.

### Core Architecture Layers:
1. **Presentation Layer (`lib/screens/`, `lib/widgets/`)**:
   - Clean, decoupled Flutter widgets adhering to Single Responsibility.
   - 60fps animations powered by `AnimationController`, `Hero`, `CurvedAnimation`, and `flutter_slidable`.
   - Frosted-glass UI implemented with hardware-accelerated `BackdropFilter` and `ImageFilter.blur`.

2. **Domain & Model Layer (`lib/models/`)**:
   - `Recipe`, `CookingStep`, and `Ingredient` models with JSON serialization (`fromJson` / `toJson`).
   - Progress calculations derived dynamically (`recipe.progressRatio`).

3. **State Management (`Provider` Pattern)**:
   - `RecipeProvider` and `AuthService` extending `ChangeNotifier` for predictable, testable unidirectional data flow.

4. **Service & Cloud Integration Layer (`lib/services/`)**:
   - **Firebase Auth**: User session management placeholder with fallback simulation.
   - **Firebase Storage**: Camera/gallery plating showcase photo upload pipeline.
   - **REST API Client**: Asynchronous POST `/recipes/generate` request execution.

---

## 🚀 Getting Started

### Prerequisites:
- Flutter SDK `>= 3.16.0`
- Dart SDK `>= 3.2.0`
- Android Studio / VS Code with Flutter extension
- An iOS Simulator or Android Emulator

### Run the App:
```bash
# 1. Clone repository
git clone https://github.com/academic/chefsync.git
cd chefsync

# 2. Install dependencies
flutter pub get

# 3. Launch application
flutter run
```

---

## 📱 Feature Highlights

| Screen | Academic Requirement | Flutter Implementation |
| :--- | :--- | :--- |
| **Splash Screen** | Staggered fade-in animation | `AnimationController` with staggered `CurvedAnimation` intervals (0.0 to 1.0) |
| **Login Screen** | Glassmorphic text fields & Firebase Auth | `GlassContainer` using `BackdropFilter`, custom `TextField` decorations, and `AuthService` |
| **Home Screen** | Staggered list, Hero animations, Shimmer | `Hero` tags (`recipe_hero_${id}`), `Shimmer.fromColors`, pull-to-refresh |
| **Generate Recipe** | POST request UI with morphing button | `AnimatedContainer` morphing from wide button to circular spinner |
| **Cooking Detail** | 3D Pot Progress & Slidable Checklist | `model_viewer_plus` placeholder, `Slidable` with swipe-to-complete, `FloatingGlassTimer` |
| **Plating Showcase** | Image selection & Firebase Storage | `image_picker` (Camera & Gallery), `FirebaseStorage.instance.putFile` hook |

---

## 🎨 Design Constitution Adherence
- **Zero-Pill Discipline**: Metadata displayed with elegant typographical separators (`·`).
- **60fps Compositor-Only Transitions**: Transforms, opacities, and curves optimized for minimal GPU/CPU overhead.
- **Glassmorphism**: 16-24px blur sigma, 1px semi-opaque borders, dark obsidian canvas (`#0D1117`).
