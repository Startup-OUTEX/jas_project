import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Common side menu
      width: 220,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
    );
  }
}
