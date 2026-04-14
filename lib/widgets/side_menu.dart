import 'package:flutter/material.dart';
import '../services/responsive.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Common side menu
      width: 220.wRes,
      padding: EdgeInsets.symmetric(horizontal: 10.wRes),
      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
    );
  }
}
