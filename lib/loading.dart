import 'package:flutter/material.dart';
import 'game_question.dart';

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
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Завантаження...',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Готуємо для тебе завдання з геометрії...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            // --- ФУТЕР (ФИКСИРОВАН) ---
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
                  Text(
                    'Застосунок створено за підтримки OUTEX',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  Text(
                    'outexua.com',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
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
