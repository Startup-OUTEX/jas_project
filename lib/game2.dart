import 'package:flutter/material.dart';
import 'dart:async';
import 'circle_logic.dart';
import 'records2.dart';
import 'services/score_service.dart';
import 'services/settings_service.dart';
import 'services/sound_service.dart'; // Import SoundService
import 'locale_strings.dart';
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
  final SettingsService _settingsService = SettingsService();
  final SoundService _soundService = SoundService(); // Init SoundService

  double _currentScore = 0.0; // Real-time score

  // Settings
  double _minThreshold = 15.0;

  // Animation for result
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  // Dynamic Text
  List<String> get _instructions => [
    AppLocale.tr('game_instruction_1'),
    AppLocale.tr('game_instruction_2'),
    AppLocale.tr('game_instruction_3'),
    AppLocale.tr('game_instruction_4'),
  ];
  int _currentInstructionIndex = 0;
  Timer? _textTimer;
  Timer? _drawingTimer;
  static const Duration _maxDrawingTime = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _loadSettings();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );

    // Start text rotation
    _textTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && _result == null) {
        setState(() {
          _currentInstructionIndex =
              (_currentInstructionIndex + 1) % _instructions.length;
        });
      }
    });
  }

  Future<void> _loadSettings() async {
    await _settingsService.loadSettings();
    setState(() {
      _minThreshold = _settingsService.minCirclePercentage;
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _textTimer?.cancel();
    _drawingTimer?.cancel();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _points.clear();
      _result = null;
      _currentScore = 0.0;
      _isDrawing = true;
      _points.add(details.localPosition);
      _animController.reset();
    });
    _soundService.startLoop('circling.wav'); // Start drawing sound

    _drawingTimer?.cancel();
    _drawingTimer = Timer(_maxDrawingTime, _onTimeout);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDrawing) return;
    setState(() {
      _points.add(details.localPosition);

      // Calculate score in real-time if enough points
      if (_points.length > 10) {
        final method = _settingsService.accuracyMethod;
        final tempResult = CircleEvaluator.evaluate(_points, method: method);
        _currentScore = tempResult.score;
      }
    });
  }

  void _onPanEnd(DragEndDetails details) async {
    _drawingTimer?.cancel();
    if (!_isDrawing) return;
    setState(() {
      _isDrawing = false;
    });

    await _soundService.stop(); // Stop drawing sound
    if (!mounted) return;

    // 1. Check strict size constraint (Too small?)
    // We can estimate size by bounding box of points
    double minX = double.infinity, maxX = double.negativeInfinity;
    double minY = double.infinity, maxY = double.negativeInfinity;
    for (var p in _points) {
      if (p.dx < minX) minX = p.dx;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dy > maxY) maxY = p.dy;
    }
    final width = maxX - minX;
    final height = maxY - minY;

    // Assume 100px diameter -> 50px radius
    // Exhibition screen is huge (1920x1080), so 100px is quite small.
    if (width < 100 || height < 100) {
      _showFeedback(AppLocale.tr('game_feedback_small'));
      _soundService.playSound('fail.wav'); // Play fail sound
      setState(() => _points.clear());
      return;
    }

    final method = _settingsService.accuracyMethod;
    final result = CircleEvaluator.evaluate(_points, method: method);

    // 2. Check threshold
    if (result.score < _minThreshold) {
      _showFeedback(AppLocale.tr('game_feedback_accuracy'));
      _soundService.playSound('fail.wav'); // Play fail sound
      setState(() => _points.clear());
      return;
    }

    // Valid attempt
    // NO AUTO SAVE HERE
    // await _scoreService.saveScore(result.score);

    setState(() {
      _result = result;
    });

    _soundService.playSound('score.wav'); // Play success sound
    _animController.forward();
  }

  Future<void> _showSaveDialog() async {
    final TextEditingController nameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            AppLocale.tr('game_save_title'),
            style: const TextStyle(color: Color(0xFF4E2784)),
          ),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: AppLocale.tr('game_enter_name'),
              border: OutlineInputBorder(),
            ),
            maxLength: 15,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocale.tr('game_btn_cancel')),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  await _scoreService.saveScore(
                    _result!.score,
                    playerName: name,
                  );
                  if (mounted) {
                    Navigator.pop(context); // Close dialog
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Records2Screen(),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4E2784),
              ),
              child: Text(
                AppLocale.tr('game_btn_save_confirm'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFeedback(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.orangeAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(50),
      ),
    );
  }

  void _onTimeout() {
    if (!_isDrawing) return;

    _drawingTimer?.cancel();
    _soundService.stop();
    _soundService.playSound('fail.wav');

    setState(() {
      _isDrawing = false;
      _points.clear();
      _result = null;
      _currentScore = 0.0;
    });

    _showFeedback(AppLocale.tr('game_timeout'));
  }

  String _getEncouragingMessage(double score) {
    if (score >= 95) return AppLocale.tr('enc_robot');
    if (score >= 90) return AppLocale.tr('enc_fantastic');
    if (score >= 80) return AppLocale.tr('enc_good');
    if (score >= 70) return AppLocale.tr('enc_ok');
    if (score >= 50) return AppLocale.tr('enc_norm');
    return AppLocale.tr('enc_bad');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4E2784),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: Stack(
              children: [
                // 0. Фоновая анимация
                // Можно добавить RandomCirclesBackground(), если нужно, но пока оставим чисто

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

                // 2. Кнопка "Назад"
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

                // 3. Інструкція (центр) - до початку малювання
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
                        Text(
                          AppLocale.tr('game_touch_draw'),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                // 6. Real-time Score Display (Top Center)
                if (_isDrawing && _points.length > 5)
                  Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_currentScore.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: _getColorForScore(_currentScore),
                          ),
                        ),
                      ),
                    ),
                  ),

                // 4. Інструкція знизу (змінюється, якщо немає результату)
                if (_result == null)
                  Positioned(
                    bottom: 80,
                    left: 40,
                    right: 40,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        _instructions[_currentInstructionIndex],
                        key: ValueKey<int>(_currentInstructionIndex),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
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
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24, width: 2),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${_result!.score.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: constraints.maxHeight * 0.15,
                                fontWeight: FontWeight.bold,
                                color: _getColorForScore(_result!.score),
                              ),
                            ),
                            Text(
                              _getEncouragingMessage(_result!.score),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
                                  label: Text(
                                    AppLocale.tr('game_btn_retry'),
                                    style: const TextStyle(
                                      color: Color(0xFF4E2784),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                ElevatedButton.icon(
                                  onPressed: _showSaveDialog,
                                  icon: const Icon(
                                    Icons.save,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    AppLocale.tr('game_btn_save'),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
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
    if (score >= 40)
      return Colors.orangeAccent; // Updated logic: >= 40 is acceptable
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
      // 1. Glow effect (behind)
      final glowPaint = Paint()
        ..color = Colors.cyanAccent.withOpacity(0.6)
        ..strokeWidth = 10.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);

      // 2. Main line
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

      canvas.drawPath(path, glowPaint);
      canvas.drawPath(path, paint);
    }

    if (result != null) {
      final idealPaint = Paint()
        ..color = Colors.green.withOpacity(0.3)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(result!.center, result!.radius, idealPaint);

      // Center point
      canvas.drawCircle(
        result!.center,
        4.0,
        Paint()..color = Colors.greenAccent,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) => true;
}
