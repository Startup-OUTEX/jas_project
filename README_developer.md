# JAS Project - Developer Documentation

This document covers the technical details, setup, and structure of the "Draw A Circle" application.

---

## 🛠️ Tech Stack
*   **Framework**: Flutter (Dart)
*   **State Management**: `StatefulWidget` + `ValueNotifier` (for global themes like Easter Eggs).
*   **Localization**: Custom `AppLocale` class (JSON-based lightweight localization).
*   **Storage**: `shared_preferences` for saving settings and high scores.
*   **Sensors**: `sensors_plus` (for shake detection).

---

## 📁 Project Structure

*   `lib/main.dart`: Entry point. Handles global theme providers (`EasterEggService`) and platform initialization.
*   `lib/services/`:
    *   `easter_egg_service.dart`: Singleton managing all secret modes (Retro, Matrix, Glitch) and triggers (Shake, Codes).
    *   `settings_service.dart`: Manages `SharedPrefs` for app flags.
    *   `score_service.dart`: Manages high scores logic.
    *   `sound_service.dart`: Handles SFX playback.
*   `lib/game2.dart`: Main game loop (Circle Drawing logic using `CustomPainter`).
*   `lib/circle_logic.dart`: Mathematical logic for circle detection (RMSE, Roundness, Hausdorff).
*   `lib/settings.dart`: Settings screen + Admin Dialog (`_AdminLoginDialog`).
*   `lib/about.dart`: "About Project" screen containing UI-based Easter eggs.

---

## 🔑 Admin Codes (Hardcoded)

These codes are intercepted in `lib/settings.dart` -> `_AdminLoginDialog`:

*   **Admin Access**: `OUTEX&JAS&UF-2026`
*   **Team Photo**: `TEAM`
*   **Retro Mode**: `OLD` or `SCHOOL`
*   **Black Hole**: `1/0`

---

## 🐛 Known Issues & Debugging

1.  **Android StringIndexOutOfBoundsException**:
    *   A runtime error related to `com.qualcomm.qti.qdma` may appear in logs on some Qualcomm devices. This is an OS-level/driver error and does not affect the Flutter app functionality.
    
2.  **Desktop Support**:
    *   Shake detection (Schrödinger's Cat) is disabled on Windows/macOS to prevent crashes.
    *   Orientation locking (`SystemChrome.setPreferredOrientations`) is skipped on desktop.

---

## 🚀 How to Run

```bash
# Mobile (Android/iOS)
flutter run

# Windows
flutter run -d windows

# MacOS
flutter run -d macos
```

## 📦 Building for Release

```bash
# Android APK
flutter build apk --release

# Windows
flutter build windows --release
```
