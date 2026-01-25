import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      // Використовуємо FittedBox або LayoutBuilder всередині, якщо треба
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
    );
  }
}
