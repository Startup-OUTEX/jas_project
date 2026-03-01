import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class EasterEggService extends ChangeNotifier {
  static final EasterEggService _instance = EasterEggService._internal();
  factory EasterEggService() => _instance;
  EasterEggService._internal();

  // State Notifiers
  final ValueNotifier<bool> isRetroMode = ValueNotifier(false);
  final ValueNotifier<bool> isMatrixMode = ValueNotifier(false);
  final ValueNotifier<bool> isGlitchMode = ValueNotifier(
    false,
  ); // For 1/0 black hole

  // Shake Detection
  StreamSubscription? _accelerometerSubscription;
  DateTime? _lastShakeTime;

  // Pi Code Logic
  final List<int> _piPattern = [3, 1, 4];
  final List<int> _currentTaps = [];
  Timer? _tapResetTimer;

  // Outex Logic
  int _outexTapCount = 0;
  Timer? _outexResetTimer;

  // Callbacks for UI
  Function()? onShowCat;
  Function()? onShowBlackHoleMessage;
  Function()? onTriggerConfetti;
  Function()? onShowBicep;
  Function()? onShowTeam; // New callback for Team Photo

  void init() {
    _startListeningToShake();
  }

  void triggerTeamPhoto() {
    onShowTeam?.call();
  }

  void dispose() {
    _accelerometerSubscription?.cancel();
    _tapResetTimer?.cancel();
    _outexResetTimer?.cancel();
    super.dispose();
  }

  void _startListeningToShake() {
    // Accelerometer is typically only available on mobile devices
    // Checking platform to avoid crashes on Desktop
    // ignore: unnecessary_cast
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return;
    }

    // Attempting to use accelerometerEvents (AccelerometerEvent) which includes gravity
    /*
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      double magnitude = event.x.abs() + event.y.abs() + event.z.abs();
      // With gravity (approx 9.8), standing still is ~9.8.
      // Shake threshold should be significantly higher, e.g. > 20 or check variance.
      // Let's assume > 25 sum of abs components.
      if (magnitude > 25.0) {
        final now = DateTime.now();
        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!) > const Duration(seconds: 2)) {
          _lastShakeTime = now;
          _triggerSchrodingersCat();
        }
      }
    });
    */
  }

  // --- TRIGGERS ---

  // 1. Schrödinger's Cat (Shake)
  void _triggerSchrodingersCat() {
    // We need a context to show dialog, but service doesn't have it.
    // We can use a GlobalKey<NavigatorState> or a callback.
    // For simplicity, we'll expose a stream or callback that UI listens to.
    onShowCat?.call();
  }

  // 2. Black Hole (1/0)
  void triggerBlackHole() {
    isGlitchMode.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      isGlitchMode.value = false;
    });
    onShowBlackHoleMessage?.call();
  }

  // 3. Retro Mode (OLD/SCHOOL)
  void toggleRetroMode() {
    isRetroMode.value = !isRetroMode.value;
    if (isRetroMode.value) {
      isMatrixMode.value = false;
    }
  }

  // 4. Pi Code (3-1-4)
  int _tempTapCount = 0;

  void tapLogoForPi() {
    _tempTapCount++;
    _tapResetTimer?.cancel();

    _tapResetTimer = Timer(const Duration(milliseconds: 800), () {
      if (_tempTapCount > 0) {
        _currentTaps.add(_tempTapCount);
        _tempTapCount = 0;
        _checkPiPattern();
      }
    });
  }

  void _checkPiPattern() {
    if (_currentTaps.isEmpty) return;

    bool match = true;
    for (int i = 0; i < _currentTaps.length; i++) {
      if (i >= _piPattern.length || _currentTaps[i] != _piPattern[i]) {
        match = false;
        break;
      }
    }

    if (!match) {
      _currentTaps.clear();
      return;
    }

    if (_currentTaps.length == _piPattern.length) {
      _triggerPiEffect();
      _currentTaps.clear();
    }
  }

  void _triggerPiEffect() {
    isMatrixMode.value = !isMatrixMode.value;
    if (isMatrixMode.value) isRetroMode.value = false;
    onTriggerConfetti?.call();
  }

  // 5. Outex (5 Taps)
  void tapOutex() {
    _outexTapCount++;
    _outexResetTimer?.cancel();
    _outexResetTimer = Timer(const Duration(milliseconds: 1000), () {
      _outexTapCount = 0;
    });

    if (_outexTapCount == 5) {
      onShowBicep?.call();
      _outexTapCount = 0;
    }
  }
}
