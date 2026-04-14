import 'package:flutter/material.dart';
import 'services/responsive.dart';
import 'game2.dart';

class Game1Screen extends StatelessWidget {
  const Game1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const Game2Screen()),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Точка по центру
              Center(
                child: Container(
                  width: 8.wRes, height: 8.hRes, 
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ),

              // Текст инструкции
              Positioned(
                bottom: 80, left: 80, right: 80,
                child: Text(
                  'Ми порівнюємо твою фігуру з ідеальним колом. Чим ближче вони збігаються, тим більший відсоток',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32.spRes, color: Colors.white, height: 1.5),
                ),
              ),

              // --- ФУТЕР (ФИКСИРОВАН) ---
              Positioned(
                left: 0, right: 0, bottom: 0,
                child: Column(
                  children: [
                    Text('Застосунок створено за підтримки OUTEX', style: TextStyle(fontSize: 11.spRes, color: Colors.white70)),
                    Text('outexua.com', style: TextStyle(fontSize: 11.spRes, color: Colors.white70)),
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