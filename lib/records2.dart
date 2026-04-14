import 'package:flutter/material.dart';
import 'services/responsive.dart';
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
                                style: TextStyle(
                                  fontSize: 48.spRes,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10..hRes),

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

                              SizedBox(height: 15..hRes),

                              // Таблиця
                              Expanded(
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 1000),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white24, width: 2),
                                        borderRadius: BorderRadius.circular(24.rRes),
                                        color: Colors.white.withOpacity(0.05),
                                      ),
                                      padding: EdgeInsets.all(30.rRes),
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
                                                      style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 48.spRes,
                                                      ),
                                                ),
                                              )
                                            : ListView.separated(
                                                itemCount: _topScores.length,
                                                separatorBuilder: (c, i) =>
                                                    Divider(
                                                      color: Colors.white24,
                                                      height: 10.hRes,
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
                                                    rankWidget = Icon(
                                                      Icons.emoji_events,
                                                      color: Color(0xFFFFD700),
                                                      size: 24.rRes,
                                                    );
                                                  } else if (i == 1) {
                                                    rankColor = const Color(
                                                      0xFFC0C0C0,
                                                    ); // Silver
                                                    rankWidget = Icon(
                                                      Icons.emoji_events,
                                                      color: Color(0xFFC0C0C0),
                                                      size: 22.rRes,
                                                    );
                                                  } else if (i == 2) {
                                                    rankColor = const Color(
                                                      0xFFCD7F32,
                                                    ); // Bronze
                                                    rankWidget = Icon(
                                                      Icons.emoji_events,
                                                      color: Color(0xFFCD7F32),
                                                      size: 20.rRes,
                                                    );
                                                  } else {
                                                    rankWidget = Text(
                                                      '#${i + 1}',
                                                      style: TextStyle(
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
                                                          width: 80.wRes,
                                                          child: Center(
                                                            child: rankWidget,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 20.wRes,
                                                        ),
                                                        SizedBox(
                                                          width: 140.wRes,
                                                          child: Text(
                                                            '${entry.score.toStringAsFixed(1)}%',
                                                            style: TextStyle(
                                                              fontSize: 24.spRes,
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
                                                                style: TextStyle(
                                                                  fontSize: 24.spRes,
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
                                                                style: TextStyle(
                                                                  fontSize: 18.spRes,
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
                                                style: TextStyle(
                                                  fontSize: 24.spRes,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 10..hRes),
                                              SizedBox(height: 10..hRes),
                                              // Image3 removed
                                              SizedBox(height: 10..hRes),
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
                                                        style: TextStyle(
                                                          fontSize: 16.spRes,
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
                child: Icon(Icons.arrow_back, color: Color(0xFF4E2784)),
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
          style: TextStyle(fontSize: 24.spRes, color: Colors.white70),
        ),
        SizedBox(height: 4..hRes),
        Text(
          entry != null ? '${entry.score.toStringAsFixed(1)}%' : '--%',
          style: TextStyle(
            fontSize: 32.spRes,
            color: Colors.yellowAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (entry != null)
          Text(
            entry.playerName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 24.spRes, color: Colors.white),
          ),
      ],
    );
  }
}
