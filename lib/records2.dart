import 'package:flutter/material.dart';
import 'settings.dart';

class Records2Screen extends StatelessWidget {
  const Records2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const Settings1Screen()),
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

                  // Таблиця
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, right: 30, bottom: 60), // bottom: 60 щоб не наехать на футер
                      child: Column(
                        children: [
                          const Text('Таблиця лідерів', style: TextStyle(fontSize: 24, color: Colors.white)),
                          const SizedBox(height: 10),
                          
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                               Text('Найкраще коло за сьогодні: [XX]% \nНамалював/ла - Вікторія', style: TextStyle(fontSize: 12, color: Colors.white)),
                               Text('Найкраще коло за весь час: [XX]% \nНамалював/ла - Вітя', style: TextStyle(fontSize: 12, color: Colors.white)),
                            ],
                          ),
                          
                          const SizedBox(height: 15),

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: ListView.separated(
                                      itemCount: 15,
                                      separatorBuilder: (c, i) => const Divider(color: Colors.white24, height: 10),
                                      itemBuilder: (c, i) => const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 4.0),
                                        child: Row(
                                          children: [
                                            SizedBox(width: 100, child: Text('Коло [XX]%', style: TextStyle(fontSize: 14, color: Colors.white))),
                                            Expanded(child: Text('Намалював/ла - Коля', style: TextStyle(fontSize: 14, color: Colors.white))),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text('Спробуй побити рекорд!', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white)),
                                        const SizedBox(height: 10),
                                        Image.asset('assets/images/image3.png', width: 60, height: 60),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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