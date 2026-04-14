import 'package:flutter/material.dart';
import 'services/responsive.dart';
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
                    width: 200.wRes,
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/logo.png', width: 200.wRes),
                        SizedBox(height: 8..hRes),
                        Transform.translate(
                          offset: const Offset(2, 0),
                          child: Image.asset('assets/images/image2.png', width: 50.wRes),
                        ),
                        SizedBox(height: 12..hRes),
                        Transform.translate(
                          offset: const Offset(2, 0),
                          child: Image.asset('assets/images/image1.png', width: 50.wRes),
                        ),
                        SizedBox(height: 12..hRes),
                        Transform.translate(
                          offset: const Offset(2, 0),
                          child: Image.asset('assets/images/image3.png', width: 50.wRes),
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
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 60.wRes),
                            child: Text(
                              'Тут з’являться твої результати, щойно спробуєш намалювати коло вперше',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18.spRes, color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 30..hRes),
                          SizedBox(
                            width: 80.wRes, height: 80.hRes,
                            child: Image.asset('assets/images/image3.png', fit: BoxFit.contain),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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