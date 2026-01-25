import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Застосунок створено за підтримки OUTEX',
          style: TextStyle(fontSize: 11, color: Colors.white70),
        ),
        Text(
          'outexua.com',
          style: TextStyle(fontSize: 11, color: Colors.white70),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
