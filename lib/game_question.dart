import 'package:flutter/material.dart';
import 'game2.dart';
import 'settings.dart';
import 'records2.dart';
import 'about.dart';
import 'services/score_service.dart';
import 'widgets/app_footer.dart';
import 'widgets/random_circles_background.dart';
import 'locale_strings.dart';

class GameQuestionScreen extends StatelessWidget {
  const GameQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4E2784),
      body: SafeArea(
        child: Stack(
          children: [
            // 0. Фоновая анимация
            const RandomCirclesBackground(),

            // 1. Основной слой: Меню + Контент
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Меню слева + кнопки
                Container(
                  width:
                      250, // Expanded width for the big logo (approx 2x of 120)
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      // Explicitly BIGGER logo for Main Screen
                      SizedBox(
                        width: 440, // As requested/implied 2x size
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Spacer(),
                      // Кнопка Налаштувань
                      _buildGameButton(
                        context,
                        icon: Icons.settings,
                        color: Colors.blueAccent,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const Settings1Screen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      // Кнопка Рейтингу
                      _buildGameButton(
                        context,
                        icon: Icons.emoji_events,
                        color: Colors.amber,
                        onTap: () async {
                          final scoreService = ScoreService();
                          final topScores = await scoreService.getTopScores();

                          if (context.mounted) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Records2Screen(),
                              ),
                            );
                            if (topScores.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Ще нікого немає. Стань першим!',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ),

                // Центральная часть
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocale.tr('main_title'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontFamily: 'e-Ukraine', // Ensure font usage
                            fontWeight: FontWeight.w900,
                            height: 1.2,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 4),
                                blurRadius: 8,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Кнопка "Почати"
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 1.0, end: 1.1),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeInOut,
                          builder: (context, scale, child) {
                            return Transform.scale(scale: scale, child: child);
                          },
                          onEnd: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.purpleAccent,
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        const Game2Screen(),
                                    transitionsBuilder:
                                        (_, animation, __, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                    transitionDuration: const Duration(
                                      milliseconds: 500,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                              label: Text(
                                AppLocale.tr('main_play'),
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFF6C35A8,
                                ), // Lighter purple
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                elevation: 0, // Handled by container
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Footer is now here, aligned with content
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const AboutScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const AppFooter(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(icon, color: color, size: 34),
          ),
        ),
      ),
    );
  }
}
