import 'package:flutter/material.dart';
import 'game1.dart';

class GameQuestionScreen extends StatelessWidget {
  const GameQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const Game1Screen()),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF4E2784), // фиолетовый фон как в примере
        body: SafeArea(
          child: Stack(
            children: [
              // 1. Основной слой: Меню + Вопрос
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Меню слева
                  Container(
                    width: 200,
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/logo.png', width: 200),
                        const SizedBox(height: 8),
                        Transform.translate(
                          offset: const Offset(2, 0), // чуть сдвинуть влево
                          child: Image.asset('assets/images/image2.png', width: 50),
                        ),
                        const SizedBox(height: 12),
                        Transform.translate(
                          offset: const Offset(2, 0),
                          child: Image.asset('assets/images/image1.png', width: 50),
                        ),
                        const SizedBox(height: 12),
                        Transform.translate(
                          offset: const Offset(2, 0),
                          child: Image.asset('assets/images/image3.png', width: 50),
                        ),
                      ],
                    ),
                  ),

                  // Вопрос справа (по центру области)
                  const Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Зможеш намалювати ідеальне коло?',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // --- ФУТЕР (ФИКСИРОВАН) ---
              const Positioned(
                left: 0, right: 0, bottom: 15,
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