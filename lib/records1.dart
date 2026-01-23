import 'package:flutter/material.dart';
import 'records2.dart';

class Records1Screen extends StatelessWidget {
  const Records1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const Records2Screen()),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // 1. Меню + Контент
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Меню
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

                  // Контент
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: Text(
                              'Тут з’являться твої результати, щойно спробуєш намалювати коло вперше',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 80, height: 80,
                            child: Image.asset('assets/images/image3.png', fit: BoxFit.contain),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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