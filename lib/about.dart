import 'package:flutter/material.dart';
import 'locale_strings.dart';

import 'package:confetti/confetti.dart';
import 'services/easter_egg_service.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    EasterEggService().onTriggerConfetti = () {
      if (mounted) _confettiController.play();
    };
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine which logo to show
    final isEnglish = AppLocale.currentCode == 'en';
    final isLargeScreen =
        MediaQuery.of(context).size.width > 800; // Threshold for large screen

    String logoAsset;
    if (isEnglish) {
      logoAsset = isLargeScreen
          ? 'assets/images/JASBigWLogo.png'
          : 'assets/images/JASSmallWLogo.png';
    } else {
      logoAsset = isLargeScreen
          ? 'assets/images/ManBigWLogo.png'
          : 'assets/images/ManSmallWLogo.png';
    }

    // Adjust logo size based on screen size
    final double logoWidth = isLargeScreen ? 200 : 120;

    return Scaffold(
      backgroundColor: const Color(0xFF4E2784),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white), // Standard back button
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- LEFT COLUMN: LOGOS ---
                  SizedBox(
                    width: isLargeScreen ? 220 : 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // UF Logo
                        GestureDetector(
                          onTap: () => EasterEggService().tapLogoForPi(),
                          child: Image.asset(
                            'assets/images/uf_logo.webp',
                            width: 100,
                            // Removed color: Colors.white to show original logo
                            // (avoids solid white box if image has bg)
                          ),
                        ),

                        const Spacer(),
                        // Dynamic MAN/JAS Logo
                        GestureDetector(
                          onTap: () => EasterEggService().tapLogoForPi(),
                          child: Image.asset(logoAsset, width: logoWidth),
                        ),
                        const SizedBox(height: 20),

                        // Outex Tap
                        GestureDetector(
                          onTap: () => EasterEggService().tapOutex(),
                          child: Text(
                            AppLocale.tr('about_project_info'),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 40),

                  // --- RIGHT COLUMN: CONTENT ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocale.tr('about_title'),
                          style: const TextStyle(
                            fontSize: 26, // Reduced slightly
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 15), // Reduced spacing
                        // Use Flexible to prevent overflow
                        Flexible(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocale.tr('about_text_1'),
                                  style: const TextStyle(
                                    fontSize: 14, // Reduced standard text size
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppLocale.tr('about_text_2'),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppLocale.tr('about_text_3'),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // QR Code Row - Fixed position at bottom
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors
                                    .white, // Restore white bg for readability for now
                              ),
                              child: Image.asset(
                                'assets/images/qr_code.png',
                                width: 80,
                                height: 80,
                              ),
                            ),
                            const SizedBox(width: 15),
                            const Text(
                              'outexua.com',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.black,
                  Colors.white,
                ], // Matrix/Pi theme
              ),
            ),
          ],
        ),
      ),
    );
  }
}
