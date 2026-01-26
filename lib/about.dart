import 'package:flutter/material.dart';
import 'locale_strings.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- LEFT COLUMN: LOGOS ---
                  SizedBox(
                    width: isLargeScreen ? 220 : 140, // Adjust column width
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // UF Logo always present
                        Image.asset('assets/images/uf_logo.webp', width: 100),

                        const Spacer(),
                        // Dynamic MAN/JAS Logo
                        Image.asset(logoAsset, width: logoWidth),
                        const SizedBox(height: 20),
                        const Text(
                          'Проєкт створено на замовлення\nМалої академії наук України\nза ініціативи UF Incubator.',
                          style: TextStyle(fontSize: 10, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 40),

                  // --- RIGHT COLUMN: CONTENT ---
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Про OUTEX',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'OUTEX — це український стартап, який створює інноваційні мобільні застосунки для спорту та реабілітації з використанням штучного інтелекту.',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Ми допомагаємо людям тренуватись будь-де й будь-коли, стежити за правильною технікою виконання вправ та отримувати персональні плани тренувань.',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Підтримуючи Малу академію наук України, ми хочемо, щоб сучасні технології допомагали дітям полюбити математику, науку та рух.',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(height: 30),

                          // Photo & QR Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Photo
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white24,
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      'assets/images/about_photo.jpg',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),

                              // QR Code (No white background)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/qr_code.png',
                                    width: 100,
                                    height: 100,
                                  ),
                                  const SizedBox(height: 10),
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
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Back Button
            Positioned(
              top: 20,
              right: 20,
              child: FloatingActionButton.small(
                backgroundColor: Colors.white,
                child: const Icon(Icons.close, color: Color(0xFF4E2784)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
