import 'package:flutter/material.dart';
import 'loading.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    // Автоматический переход через 2.5 секунды
    Future.delayed(const Duration(milliseconds: 2500), _navigateToNext);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToNext() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoadingScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Логотип строго по центру с анимацией
          Center(
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
              ),
            ),
          ),

          // Футер (прибит к низу)
          const Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Center(
              child: Text(
                'Застосунок створено за підтримки OUTEX',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
