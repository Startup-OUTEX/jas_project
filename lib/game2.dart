import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'circle_logic.dart';
import 'game3.dart';
import 'services/score_service.dart';
import 'widgets/app_footer.dart';

class Game2Screen extends StatefulWidget {
  const Game2Screen({super.key});

  @override
  State<Game2Screen> createState() => _Game2ScreenState();
}

class _Game2ScreenState extends State<Game2Screen>
    with SingleTickerProviderStateMixin {
  final List<Offset> _points = [];
  CircleResult? _result;
  bool _isDrawing = false;
  final ScoreService _scoreService = ScoreService();

  // Animation for result
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _points.clear();
      _result = null;
      _isDrawing = true;
      _points.add(details.localPosition);
      _animController.reset();
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDrawing) return;
    setState(() {
      _points.add(details.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) async {
    if (!_isDrawing) return;

    final result = CircleEvaluator.evaluate(_points);

    // Save score if it's a valid attempt (e.g. > 0%)
    if (result.score > 0) {
      await _scoreService.saveScore(result.score);
    }

    setState(() {
      _isDrawing = false;
      _result = result;
    });

    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // Використовуємо LayoutBuilder для адаптації під різні екрани
    return Scaffold(
      backgroundColor: const Color(0xFF4E2784),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: Stack(
              children: [
                // 1. Полотно для малювання
                GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: CustomPaint(
                    painter: BoardPainter(points: _points, result: _result),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.transparent,
                    ),
                  ),
                ),

                // 2. Кнопка "Назад" - покращений UX
                Positioned(
                  top: 20,
                  left: 20,
                  child: FloatingActionButton.small(
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF4E2784),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),

                // 3. Інструкція (центр)
                if (_points.isEmpty && _result == null)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Торкнись і малюй!',
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                // 4. Інструкція знизу
                if (_result == null)
                  Positioned(
                    bottom: 80,
                    left: constraints.maxWidth * 0.1,
                    right: constraints.maxWidth * 0.1,
                    child: const Text(
                      'Намагайся намалювати ідеальне коло одним рухом',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),

                // 5. Результат з анімацією
                if (_result != null)
                  Center(
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${_result!.score.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize:
                                    constraints.maxHeight *
                                    0.15, // Адаптивний шрифт
                                fontWeight: FontWeight.bold,
                                color: _getColorForScore(_result!.score),
                              ),
                            ),
                            Text(
                              _result!.message,
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _points.clear();
                                      _result = null;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: Color(0xFF4E2784),
                                  ),
                                  label: const Text(
                                    'Ще раз',
                                    style: TextStyle(color: Color(0xFF4E2784)),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Перехід до результатів
                                    // Navigator.of(context).push...
                                    // Поки що просто скидаємо, щоб користувач міг далі грати
                                    // Або можна відправити на екран рекордів
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Game3Screen(),
                                      ), // Або Records2Screen
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.list,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Рейтинг',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // --- ФУТЕР ---
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 5,
                  child: AppFooter(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getColorForScore(double score) {
    if (score >= 90) return Colors.greenAccent;
    if (score >= 70) return Colors.yellowAccent;
    return Colors.redAccent;
  }
}

class BoardPainter extends CustomPainter {
  final List<Offset> points;
  final CircleResult? result;

  BoardPainter({required this.points, this.result});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isNotEmpty) {
      final paint = Paint()
        ..color = Colors.white
        ..strokeWidth = 4.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);
    }

    if (result != null) {
      final idealPaint = Paint()
        ..color = Colors.green.withOpacity(0.5)
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(result!.center, result!.radius, idealPaint);
      canvas.drawCircle(
        result!.center,
        3.0,
        Paint()..color = Colors.greenAccent,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) => true;
}
