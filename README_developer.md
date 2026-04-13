# JAS Project - Developer Documentation

This document covers the technical details, setup, and structure of the "Draw A Circle" application.

---

## 🛠️ Tech Stack
*   **Framework**: Flutter (Dart)
*   **State Management**: `StatefulWidget` + `ValueNotifier` (for global themes like Easter Eggs).
*   **Localization**: Custom `AppLocale` class (JSON-based lightweight localization).
*   **Storage**: `shared_preferences` for saving settings and high scores.
*   **Sensors**: `sensors_plus` (for shake detection).
*   **Window Management**: `window_manager` (for enforcing fullscreen on Windows platforms).
*   **Packaging**: `Inno Setup` Compiler (for `.exe` installers).

---

## 📁 Project Structure

*   `lib/main.dart`: Entry point. Handles global theme providers (`EasterEggService`), orientation locking, and the **Windows Desktop Scaling Wrapper** (FittedBox wrapper logic to constrain the app to a virtual 1920x1080 canvas without breaking layout on electronic monitors).
*   `lib/game1.dart` & `game2.dart`: Main game loops and instruction screens (Circle Drawing logic).
*   `lib/circle_logic.dart`: Mathematical logic for circle detection (RMSE, Roundness, Hausdorff).
*   `lib/settings.dart`: Settings screen + Admin Dialog (`_AdminLoginDialog`).
*   `lib/about.dart`: "About Project" screen containing UI-based Easter eggs.
*   `inno_setup.iss`: Inno Setup compiler script used to generate a professional executable installer out of the built binaries.

---

## 🔑 Admin Codes (Hardcoded)

These codes are intercepted in `lib/settings.dart` -> `_AdminLoginDialog`:

*   **Admin Access**: `OUTEX&JAS&UF-2026`
*   **Team Photo**: `TEAM`
*   **Retro Mode**: `OLD` or `SCHOOL`
*   **Black Hole**: `1/0`

---

## 🐛 Specific Platform Implementations

1.  **Desktop Fullscreen & Scaling**: 
    To support massive 4K or ultra-wide interactive whiteboards on Windows natively, `lib/main.dart` wraps the entire application instance in an `AspectRatio(16/9)` inside a `FittedBox` statically linked to a `SizedBox(1920, 1080)` virtual canvas layout. This guarantees flawless UI ratios regardless of the host resolution.
2.  **Desktop Exit Node**:
    Since the application invokes aggressive Fullscreen borderless state natively on `Platform.isWindows`, an explicit `onTap: () => exit(0)` localized Close *(X)* button is injected dynamically onto the UI Stack.
3.  **Shake Detection Constraints**:
    Shake detection (Schrödinger's Cat) is intentionally isolated to Android/iOS tablets to bypass unhandled sensor exceptions on unsupported desktop OS contexts.

---

## 🚀 How to Run & Build

### Development
```bash
# Mobile (Android/iOS)
flutter run

# Windows
flutter run -d windows
```

### Building for Release

**📱 Android (APK):**
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

**🪟 Windows (.exe Setup Installer):**
1. Run `flutter build windows --release` to compile binaries inside `build/windows/x64/runner/Release`.
2. Open `inno_setup.iss` inside **Inno Setup**.
3. Press **Compile**. The packaged artifact will be written to the `InnoInstaller/JasProject_Setup.exe` directory logic space.
```
