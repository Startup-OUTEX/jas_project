import 'dart:math';
import 'dart:ui';

class CircleResult {
  final double score; // 0 to 100
  final Offset center;
  final double radius;
  final String message;

  CircleResult({
    required this.score,
    required this.center,
    required this.radius,
    required this.message,
  });
}

class CircleEvaluator {
  static CircleResult evaluate(List<Offset> points) {
    if (points.length < 10) {
      return CircleResult(
        score: 0,
        center: Offset.zero,
        radius: 0,
        message: 'Занадто мало точок',
      );
    }

    // 1. Calculate Centroid
    double sumX = 0;
    double sumY = 0;
    for (var p in points) {
      sumX += p.dx;
      sumY += p.dy;
    }
    final center = Offset(sumX / points.length, sumY / points.length);

    // 2. Calculate Radii and Mean Radius
    double sumRadius = 0;
    List<double> radii = [];
    for (var p in points) {
      double r = (p - center).distance;
      radii.add(r);
      sumRadius += r;
    }
    final meanRadius = sumRadius / points.length;

    // 3. Calculate Variance and StdDev
    double sumSquaredDiff = 0;
    for (var r in radii) {
      sumSquaredDiff += pow(r - meanRadius, 2);
    }
    final variance = sumSquaredDiff / points.length;
    final stdDev = sqrt(variance);

    // 4. Calculate Score
    // Coefficient of variation (CV) = stdDev / meanRadius
    // Perfect circle -> CV = 0.
    // Penalty factor can be adjusted.
    // If CV is 0.2 (20% deviation), score should be low.

    double rawScore =
        100 * (1 - (stdDev / meanRadius) * 4); // *4 to make it stricter/harder
    double score = rawScore.clamp(0.0, 100.0);

    String message = '';
    if (score > 95) {
      message = 'Неймовірно!';
    } else if (score > 90) {
      message = 'Чудово!';
    } else if (score > 80) {
      message = 'Дуже добре';
    } else if (score > 50) {
      message = 'Непогано';
    } else {
      message = 'Спробуй ще раз';
    }

    return CircleResult(
      score: score,
      center: center,
      radius: meanRadius,
      message: message,
    );
  }
}
