import 'package:flutter/material.dart';
import 'error.dart';

class Game3Screen extends StatelessWidget {
  const Game3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ErrorScreen()),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
              ),
              const Positioned(
                bottom: 80, left: 50, right: 50,
                child: Text(
                  'Не відривай палець від екрану під час малювання',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white),
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