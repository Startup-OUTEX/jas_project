import 'package:flutter/material.dart';
import 'services/responsive.dart';
import 'game_question.dart';
import 'locale_strings.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Автоматический переход через 1.5 секунды
    Future.delayed(const Duration(milliseconds: 1500), _navigateToNext);
  }

  void _navigateToNext() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const GameQuestionScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Контент по центру
            // Контент по центру
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 120.wRes,
                    height: 120.hRes,
                    child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 8),
                  ),
                  SizedBox(height: 48.hRes),
                  Text(
                    AppLocale.tr('loading_text'),
                    style: TextStyle(
                      fontSize: 36.spRes,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  SizedBox(height: 24.hRes),
                  Text(
                    AppLocale.tr('loading_subtext'),
                    style: TextStyle(fontSize: 24.spRes, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // --- ФУТЕР (ФИКСИРОВАН) ---
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Column(
                children: [
                   Text(
                    AppLocale.tr('footer_text'),
                    style: TextStyle(fontSize: 18.spRes, color: Colors.white54),
                  ),
                  Text(
                    'outexua.com',
                    style: TextStyle(fontSize: 18.spRes, color: Colors.white54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
