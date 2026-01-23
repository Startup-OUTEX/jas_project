import 'package:flutter/material.dart';
import 'loading.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoadingScreen()),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Логотип строго по центру
            Center(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height * 0.4, // Ограничиваем высоту
                ),
              ),
            ),
            
            // Футер (прибит к низу)
            const Positioned(
              left: 0, right: 0, bottom: 20,
              child: Center(
                child: Text(
                  'Застосунок створено за підтримки OUTEX',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}