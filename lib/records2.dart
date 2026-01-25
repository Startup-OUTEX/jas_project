import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services/score_service.dart';
import 'widgets/side_menu.dart';
import 'widgets/app_footer.dart';

class Records2Screen extends StatefulWidget {
  const Records2Screen({super.key});

  @override
  State<Records2Screen> createState() => _Records2ScreenState();
}

class _Records2ScreenState extends State<Records2Screen> {
  final ScoreService _scoreService = ScoreService();
  List<ScoreEntry> _topScores = [];
  ScoreEntry? _dailyBest;
  ScoreEntry? _allTimeBest;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
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
                const SideMenu(),

                // Контент
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      right: 30,
                      bottom: 60,
                    ),
                    child: _loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Column(
                            children: [
                              const Text(
                                'Таблиця лідерів',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Картки найкращих
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildSummaryCard(
                                    'Найкраще за сьогодні',
                                    _dailyBest,
                                  ),
                                  _buildSummaryCard(
                                    'Найкраще за весь час',
                                    _allTimeBest,
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
                                        flex: 7,
                                        child: _topScores.isEmpty
                                            ? const Center(
                                                child: Text(
                                                  'Поки немає рекордів. Стань першим!',
                                                  style: TextStyle(
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
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 4.0,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 40,
                                                          child: Text(
                                                            '#${i + 1}',
                                                            style: const TextStyle(
                                                              color: Colors
                                                                  .yellowAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 120,
                                                          child: Text(
                                                            'Коло ${entry.score.toStringAsFixed(1)}%',
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            '${entry.playerName} (${DateFormat('dd.MM HH:mm').format(entry.date)})',
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white70,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                      ),

                                      // Заклик
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Спробуй побити рекорд!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            GestureDetector(
                                              onTap: () => Navigator.of(
                                                context,
                                              ).pop(), // Turn back to previous screen (Game probably)
                                              child: Image.asset(
                                                'assets/images/image3.png',
                                                width: 80,
                                                height: 80,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            ElevatedButton.icon(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              icon: const Icon(
                                                Icons.play_arrow,
                                              ),
                                              label: const Text('Грати'),
                                            ),
                                          ],
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
            const Positioned(left: 0, right: 0, bottom: 5, child: AppFooter()),

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
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
      ],
    );
  }
}
