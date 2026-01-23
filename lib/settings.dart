import 'package:flutter/material.dart';

class Settings1Screen extends StatelessWidget {
  const Settings1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4E2784), // #4e2784
      body: SafeArea(
        child: Stack(
          children: [
            // Меню слева + пустая правая часть
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                        offset: const Offset(2, 0),
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

                // Правая часть экрана оставлена пустой
                const Expanded(child: SizedBox()),
              ],
            ),

            // Футер
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
    );
  }
}