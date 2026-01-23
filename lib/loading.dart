import 'package:flutter/material.dart';
import 'game_question.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const GameQuestionScreen()),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Контент по центру
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Завантаження...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Text('Готуємо для тебе завдання з геометрії...', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),

              // --- ФУТЕР (ФИКСИРОВАН) ---
              const Positioned(
                left: 0, right: 0, bottom: 0,
                child: Column(
                  children: [
                    Text('Застосунок створено за підтримки OUTEX', style: TextStyle(fontSize: 11, color: Colors.white70)),
                    Text('outexua.com', style: TextStyle(fontSize: 11, color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}