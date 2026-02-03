import 'package:flutter/material.dart';
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
            style: const TextStyle(fontSize: 11, color: Colors.white70),
          ),
          const Text(
            'outexua.com',
            style: TextStyle(fontSize: 11, color: Colors.white70),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
