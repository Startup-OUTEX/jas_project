# JAS Project — Developer Documentation

> **Version 1.0.0** | April 2026 | Windows Desktop Kiosk Edition

Technical reference for the "Draw A Circle" application.

---

## 🆕 Changelog v1.0.0 (April 2026)

| Area | Change |
|---|---|
| **Architecture** | Replaced rigid `16:9 AspectRatio + FittedBox` with `ScreenUtilInit` (flutter_screenutil) — no more black bars on non-16:9 screens |
| **Responsive System** | Added `lib/services/responsive.dart` with `ResponsiveSize` extension (`.wRes`, `.hRes`, `.spRes`, `.rRes`) — applies ScreenUtil scaling only on Windows, falls back to raw values on Android/iOS |
| **Main Menu** | Structural desktop redesign: hero title 64sp, PLAY button 48sp/70px icon, side panel icons 70px with 24px touch padding |
| **Settings** | Wrapped in centered glass Card (max-width 900px), section headers 28sp, dropdown fonts 22sp |
| **Leaderboard** | Centered ConstrainedBox (max-width 1000px), table row fonts 24sp |
| **About Screen** | Removed UF Incubator logo, QR code 200×200px, description text 24sp |
| **Instruction Screens** | Instruction text 32sp with line-height 1.5 |
| **Loading Screen** | Spinner 120×120px, text 36sp |
| **Bug Fix** | Fixed `set_desc_${widget.method}` showing as literal string (escaped `\$` in refactored code) |
| **Admin Security** | 30-second auto-logout timer for admin sessions |
| **Exit Button** | Moved "Exit App" button inside admin panel only |

---

## 🛠️ Tech Stack

| Package | Purpose |
|---|---|
| `flutter` | Core framework |
| `shared_preferences` | Persist settings & scores |
| `sensors_plus` | Shake detection (Android/iOS only) |
| `window_manager` | Fullscreen borderless window on Windows |
| `flutter_screenutil` | Proportional UI scaling on Windows |
| `audioplayers` | Sound effects |
| `confetti` | Confetti animation (Easter egg) |
| `intl` | Date formatting in leaderboard |

---

## 📁 Project Structure

```
lib/
├── main.dart              # Entry point: EasterEggService, ScreenUtilInit (Windows), fullscreen
├── game_question.dart     # Main menu screen (hero title, PLAY button, settings/trophy nav)
├── game1.dart             # Instruction screen 1 (tap to proceed)
├── game2.dart             # Core game: canvas drawing, gesture detection, scoring
├── game3.dart             # Instruction screen 3 (tap to proceed)
├── circle_logic.dart      # Math: RMSE, Roundness, Combined, Hausdorff algorithms
├── error.dart             # Line-too-short error screen
├── records2.dart          # Leaderboard (top scores, daily/all-time best)
├── settings.dart          # Settings + Admin login dialog (Easter egg codes)
├── about.dart             # About OUTEX screen (QR, logos, Pi Code Easter egg)
├── loading.dart           # Loading transition screen
├── splash_screen.dart     # Splash logo screen
├── locale_strings.dart    # Inline localization (UA/EN/DE) – no external JSON files
│
├── services/
│   ├── responsive.dart        # ResponsiveSize extension (.wRes/.hRes/.spRes/.rRes)
│   ├── settings_service.dart  # SharedPreferences wrappers for all settings
│   ├── score_service.dart     # Score CRUD operations + top-N filtering
│   └── easter_egg_service.dart # Global Easter egg state manager + Retro/Matrix/BlackHole
│
└── widgets/
    ├── app_footer.dart              # Shared footer "App created by OUTEX / outexua.com"
    ├── side_menu.dart               # (Legacy) left sidebar widget
    └── random_circles_background.dart # Animated purple circles background
```

---

## 🔑 Admin Codes

Intercepted in `lib/settings.dart` → `_AdminLoginDialog._checkPassword()`:

| Code | Action |
|---|---|
| `OUTEX&JAS&UF-2026` | Unlocks admin panel (30-sec auto-expire session) |
| `TEAM` | Shows team photo Easter egg |
| `OLD` or `SCHOOL` | Toggles Sepia/Retro filter |
| `1/0` | Triggers "Black Hole" screen glitch animation |

---

## 🖥 Platform-Specific Implementations

### Windows Desktop (Primary Target — v1.0.0)
- **ScreenUtil Init**: `main.dart` wraps the Windows app in `ScreenUtilInit(designSize: Size(1920, 1080))`. All UI values use `.wRes`/`.hRes`/`.spRes` extensions to scale proportionally.
- **Borderless Fullscreen**: `window_manager` sets the app to fullscreen, borderless, with always-on-top.
- **Exit control**: `exit(0)` is only accessible inside the admin panel (not exposed to end users).
- **No touch keyboard**: App is designed for drawing-only interaction — no text input for players.

### Android / iOS (Secondary — maintained, not actively developed)
- `.wRes` / `.spRes` return raw `double` values on non-Windows platforms, meaning **all original mobile layout logic is completely untouched**.
- Shake detection (Schrödinger's Cat Easter egg) is only active on mobile.

---

## 🚀 Build Instructions

### Development
```bash
# Windows
flutter run -d windows

# Android
flutter run  # connect device first
```

### Production Build

**🪟 Windows Release `.exe`:**
```bash
# Step 1: Compile
flutter build windows --release

# Output directory:
# build/windows/x64/runner/Release/

# Step 2: Package installer (optional)
# Open inno_setup.iss in Inno Setup Compiler → click Compile
# Output: InnoInstaller/JasProject_Setup.exe
```

**📱 Android APK:**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🐛 Known Issues / Notes

- `sensors_plus` import in `easter_egg_service.dart` is unused on Windows — safe to ignore warning.
- `BuildContext` across async gap warnings in `settings.dart` and `game2.dart` are pre-existing patterns and do not cause runtime issues (guarded by `mounted` checks).
- `curly_braces_in_flow_control_structures` warnings in `circle_logic.dart` are algorithm code style — functional.
