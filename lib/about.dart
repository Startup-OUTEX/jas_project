import 'package:flutter/material.dart';
import 'services/responsive.dart';
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
          ? 'assets/images/JAS_full_text_white_transparent.png'
          : 'assets/images/JAS_full_text_white_transparent.png';
    } else {
      logoAsset = isLargeScreen
          ? 'assets/images/MAN_full_text_white_transparent.png'
          : 'assets/images/MAN_abbr_white_transparent.png';
    }

    // Adjust logo size based on screen size (substantially larger for electronic boards)
    final double scaleFactor = isLargeScreen ? (MediaQuery.of(context).size.width / 1920) : 1.0;
    final double logoWidth = isLargeScreen ? (250 * scaleFactor).clamp(200.0, 400.0) : 120.0;
    final double ufLogoWidth = isLargeScreen ? (150 * scaleFactor).clamp(120.0, 250.0) : 100.0;

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
                  Expanded(
                    flex: 1, // Let logos take 25% of screen
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        // Dynamic MAN/JAS Logo
                        GestureDetector(
                          onTap: () => EasterEggService().tapLogoForPi(),
                          child: Image.asset(logoAsset, width: logoWidth),
                        ),
                        SizedBox(height: 20.hRes),

                        // Outex Tap
                        GestureDetector(
                          onTap: () => EasterEggService().tapOutex(),
                          child: Text(
                            AppLocale.tr('about_project_info'),
                            style: TextStyle(
                              fontSize: 14.spRes,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 40..wRes),

                  // --- RIGHT COLUMN: CONTENT ---
                  Expanded(
                    flex: 3, // Text takes 75% of screen
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocale.tr('about_title'),
                          style: TextStyle(
                            fontSize: 48.spRes, // Huge title
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 15..hRes), // Reduced spacing
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
                                  style: TextStyle(
                                    fontSize: 24.spRes, // Good presentation size
                                    color: Colors.white,
                                    height: 1.5,
                                  ),
                                ),
                                SizedBox(height: 16.hRes),
                                Text(
                                  AppLocale.tr('about_text_2'),
                                  style: TextStyle(
                                    fontSize: 24.spRes,
                                    color: Colors.white,
                                    height: 1.5,
                                  ),
                                ),
                                SizedBox(height: 16.hRes),
                                Text(
                                  AppLocale.tr('about_text_3'),
                                  style: TextStyle(
                                    fontSize: 24.spRes,
                                    color: Colors.white,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15..hRes),

                        // QR Code Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                'assets/images/qr-code.png',
                                width: 200.wRes,  // Much larger QR
                                height: 200.hRes,
                              ),
                            ),
                            SizedBox(width: 24.wRes),
                            Text(
                              'outexua.com',
                              style: TextStyle(
                                fontSize: 28.spRes,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
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
                colors: [
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
