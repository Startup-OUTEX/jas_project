import 'package:flutter/material.dart';
import 'services/responsive.dart';
import 'package:flutter/services.dart';
import 'splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'locale_strings.dart';

import 'services/easter_egg_service.dart';

import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocale.init();

  // Init Easter Egg Service
  EasterEggService().init();

  // Принудительно ставим горизонтальный режим (Only on Mobile)
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } else if (!kIsWeb && Platform.isWindows) {
    await windowManager.ensureInitialized();
    await windowManager.setFullScreen(true);
  }
  
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _service = EasterEggService();

  @override
  void initState() {
    super.initState();
    // Setup callbacks for Dialogs
    _service.onShowCat = () {
      if (navigatorKey.currentState?.context != null) {
        showDialog(
          context: navigatorKey.currentState!.context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Colors.brown[100],
            title: Text("📦 Meow!"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.pets, size: 60.rRes, color: Colors.orange),
                SizedBox(height: 10..hRes),
                Text("Я живий! (Напевно)\n\nI am alive! (Probably)"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    };

    _service.onShowBlackHoleMessage = () {
      if (navigatorKey.currentState?.context != null) {
        showDialog(
          context: navigatorKey.currentState!.context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              "⚠️ 1/0 Error",
              style: TextStyle(color: Colors.red),
            ),
            content: Text(
              "Обережно! Ти ледь не створив чорну діру.\n\nWarning! You almost created a black hole.",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    };

    _service.onShowBicep = () {
      if (navigatorKey.currentState?.context != null) {
        showDialog(
          context: navigatorKey.currentState!.context,
          builder: (ctx) => SimpleDialog(
            backgroundColor: Colors.white,
            children: [
              Center(
                child: Icon(Icons.fitness_center, size: 80.rRes, color: Colors.blue),
              ),
              SizedBox(height: 10..hRes),
              Center(
                child: Text(
                  "Качаємо мозок!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }
    };

    _service.onShowTeam = () {
      if (navigatorKey.currentState?.context != null) {
        showDialog(
          context: navigatorKey.currentState!.context,
          builder: (ctx) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10.rRes),
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/about_photo.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _service.isRetroMode,
        _service.isMatrixMode,
        _service.isGlitchMode,
      ]),
      builder: (context, child) {
        // 1. Base App
        Widget app = MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'e-Ukraine',
            scaffoldBackgroundColor: const Color(0xFF4E2784),
            // Adjust theme for Retro Mode
            colorScheme: _service.isRetroMode.value
                ? const ColorScheme.light(
                    primary: Colors.brown,
                    surface: Color(0xFFFDF5E6),
                  )
                : null,
          ),
          home: const SplashScreen(),
        );

        // 2. Apply Glitch (Black Hole) - Dark Overlay
        if (_service.isGlitchMode.value) {
          app = Stack(
            textDirection: TextDirection.ltr,
            children: [
              app,
              Container(color: Colors.black.withOpacity(0.85)),
            ],
          );
        }

        // 3. Apply Retro Mode - Sepia
        if (_service.isRetroMode.value) {
          app = ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              0.393,
              0.769,
              0.189,
              0,
              0,
              0.349,
              0.686,
              0.168,
              0,
              0,
              0.272,
              0.534,
              0.131,
              0,
              0,
              0,
              0,
              0,
              1,
              0,
            ]),
            child: app,
          );
        }

        // 4. Apply Matrix Mode - Green Tint
        if (_service.isMatrixMode.value) {
          app = ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.green,
              BlendMode.modulate,
            ),
            child: app,
          );
        }

        // 5. Apply Windows Desktop Scale
        if (!kIsWeb && Platform.isWindows) {
          app = ScreenUtilInit(
            designSize: const Size(1920, 1080),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: child!,
              );
            },
            child: app,
          );
        }

        return app;
      },
    );
  }
}
