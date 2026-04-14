import 'package:flutter/material.dart';
import 'services/responsive.dart';
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
                child: Container(width: 8.wRes, height: 8.hRes, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
              ),
              Positioned(
                bottom: 80, left: 80, right: 80,
                child: Text(
                  'Не відривай палець від екрану під час малювання',
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