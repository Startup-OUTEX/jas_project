import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Принудительно ставим горизонтальный режим
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'e-Ukraine',
        scaffoldBackgroundColor: const Color(0xFF4E2784), // #4e2784
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}