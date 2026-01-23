import 'package:flutter/material.dart';
import 'records1.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const Records1Screen()),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ),
              
              const Positioned(
                bottom: 60, left: 50, right: 50,
                child: Text(
                  'Здається, це занадто коротка лінія, а не коло. Спробуй намалювати повне коло',
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