import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services/score_service.dart';
import 'widgets/app_footer.dart';
import 'locale_strings.dart';

class Records2Screen extends StatefulWidget {
  const Records2Screen({super.key});

  @override
  State<Records2Screen> createState() => _Records2ScreenState();
}

class _Records2ScreenState extends State<Records2Screen>
    with SingleTickerProviderStateMixin {
  final ScoreService _scoreService = ScoreService();
  List<ScoreEntry> _topScores = [];
  ScoreEntry? _dailyBest;
  ScoreEntry? _allTimeBest;
  bool _loading = true;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _loadData();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final tops = await _scoreService.getTopScores();
    final daily = await _scoreService.getDailyBest();
    final allTime = await _scoreService.getAllTimeBest();

    if (mounted) {
      setState(() {
        _topScores = tops;
        _dailyBest = daily;
        _allTimeBest = allTime;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4E2784),
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Меню (перевикористовуємо)
                // const SideMenu(), // Removed as per request (MAN logo)

                // Контент
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
                    child: _loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                AppLocale.tr('rec_title'),
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),

                              // Картки найкращих
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: _buildSummaryCard(
                                      AppLocale.tr('rec_today_best'),
                                      _dailyBest,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildSummaryCard(
                                      AppLocale.tr('rec_total_best'),
                                      _allTimeBest,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              // Таблиця
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white.withOpacity(0.05),
                                  ),
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      // Список рекордів
                                      Expanded(
                                        flex: 2,
                                        child: _topScores.isEmpty
                                            ? Center(
                                                child: Text(
                                                  AppLocale.tr('rec_empty'),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              )
                                            : ListView.separated(
                                                itemCount: _topScores.length,
                                                separatorBuilder: (c, i) =>
                                                    const Divider(
                                                      color: Colors.white24,
                                                      height: 10,
                                                    ),
                                                itemBuilder: (c, i) {
                                                  final entry = _topScores[i];
                                                  // Determine styling based on rank
                                                  Color rankColor =
                                                      Colors.white;
                                                  Widget rankWidget;

                                                  if (i == 0) {
                                                    rankColor = const Color(
                                                      0xFFFFD700,
                                                    ); // Gold
                                                    rankWidget = const Icon(
                                                      Icons.emoji_events,
                                                      color: Color(0xFFFFD700),
                                                      size: 24,
                                                    );
                                                  } else if (i == 1) {
                                                    rankColor = const Color(
                                                      0xFFC0C0C0,
                                                    ); // Silver
                                                    rankWidget = const Icon(
                                                      Icons.emoji_events,
                                                      color: Color(0xFFC0C0C0),
                                                      size: 22,
                                                    );
                                                  } else if (i == 2) {
                                                    rankColor = const Color(
                                                      0xFFCD7F32,
                                                    ); // Bronze
                                                    rankWidget = const Icon(
                                                      Icons.emoji_events,
                                                      color: Color(0xFFCD7F32),
                                                      size: 20,
                                                    );
                                                  } else {
                                                    rankWidget = Text(
                                                      '#${i + 1}',
                                                      style: const TextStyle(
                                                        color: Colors.white70,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    );
                                                  }

                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color: i < 3
                                                          ? rankColor
                                                                .withOpacity(
                                                                  0.1,
                                                                )
                                                          : null,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      border: i < 3
                                                          ? Border.all(
                                                              color: rankColor
                                                                  .withOpacity(
                                                                    0.3,
                                                                  ),
                                                            )
                                                          : null,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 8.0,
                                                          horizontal: 8.0,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 40,
                                                          child: Center(
                                                            child: rankWidget,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        SizedBox(
                                                          width: 70,
                                                          child: Text(
                                                            '${entry.score.toStringAsFixed(1)}%',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: rankColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                entry
                                                                    .playerName,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              Text(
                                                                DateFormat(
                                                                  'dd.MM HH:mm',
                                                                ).format(
                                                                  entry.date,
                                                                ),
                                                                style: const TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white54,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                      ),

                                      // Заклик / Кнопки справа
                                      Expanded(
                                        flex: 1,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppLocale.tr('rec_call'),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              const SizedBox(height: 10),
                                              // Image3 removed
                                              const SizedBox(height: 10),
                                              AnimatedBuilder(
                                                animation: _pulseAnimation,
                                                builder: (context, child) {
                                                  return Transform.scale(
                                                    scale:
                                                        _pulseAnimation.value,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 12,
                                                            ),
                                                        backgroundColor:
                                                            Colors.yellowAccent,
                                                        foregroundColor:
                                                            Colors.black,
                                                      ),
                                                      child: Text(
                                                        AppLocale.tr(
                                                          'rec_play',
                                                        ),
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),

            // --- ФУТЕР ---
            const Positioned(
              left: 0,
              right: 0,
              bottom: 5,
              child: Center(child: AppFooter()),
            ),

            // Кнопка назад
            Positioned(
              top: 20,
              left: 20,
              child: FloatingActionButton.small(
                backgroundColor: Colors.white,
                child: const Icon(Icons.arrow_back, color: Color(0xFF4E2784)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, ScoreEntry? entry) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          entry != null ? '${entry.score.toStringAsFixed(1)}%' : '--%',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.yellowAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (entry != null)
          Text(
            entry.playerName,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
      ],
    );
  }
}
