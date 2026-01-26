import 'dart:math';
import 'package:flutter/material.dart';

class RandomCirclesBackground extends StatefulWidget {
  const RandomCirclesBackground({super.key});

  @override
  State<RandomCirclesBackground> createState() =>
      _RandomCirclesBackgroundState();
}

class _RandomCirclesBackgroundState extends State<RandomCirclesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_CircleData> _circles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Long cycle for smooth movement
    )..repeat();

    // Generate initial circles
    for (int i = 0; i < 15; i++) {
      _circles.add(_generateCircle());
    }
  }

  _CircleData _generateCircle() {
    return _CircleData(
      position: Offset(_random.nextDouble(), _random.nextDouble()),
      radius: _random.nextDouble() * 50 + 10, // 10 to 60
      color: Colors.white.withOpacity(
        _random.nextDouble() * 0.1 + 0.05,
      ), // Low opacity
      speed: Offset(
        (_random.nextDouble() - 0.5) * 0.002,
        (_random.nextDouble() - 0.5) * 0.002,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _CirclesPainter(_circles),
        );
      },
    );
  }
}

class _CircleData {
  Offset position;
  final double radius;
  final Color color;
  final Offset speed;

  _CircleData({
    required this.position,
    required this.radius,
    required this.color,
    required this.speed,
  });

  void update() {
    position += speed;
    // Wrap around logic can be added here if needed,
    // but for now let's just let them float.
    // If they go too far, maybe reset?
    if (position.dx < -0.1) position = Offset(1.1, position.dy);
    if (position.dx > 1.1) position = Offset(-0.1, position.dy);
    if (position.dy < -0.1) position = Offset(position.dx, 1.1);
    if (position.dy > 1.1) position = Offset(position.dx, -0.1);
  }
}

class _CirclesPainter extends CustomPainter {
  final List<_CircleData> circles;

  _CirclesPainter(this.circles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var circle in circles) {
      circle
          .update(); // Update position for next frame (side effect in paint is usually bad practice but acceptable for simple uncontrolled animation)

      final paint = Paint()
        ..color = circle.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final center = Offset(
        circle.position.dx * size.width,
        circle.position.dy * size.height,
      );

      canvas.drawCircle(center, circle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
