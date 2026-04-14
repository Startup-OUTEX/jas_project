import 'package:flutter/material.dart';
import '../services/responsive.dart';
import '../locale_strings.dart';
import '../about.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const AboutScreen()));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocale.tr('footer_text'),
            style: TextStyle(fontSize: 11.spRes, color: Colors.white70),
          ),
          Text(
            'outexua.com',
            style: TextStyle(fontSize: 11.spRes, color: Colors.white70),
          ),
          SizedBox(height: 5..hRes),
        ],
      ),
    );
  }
}
